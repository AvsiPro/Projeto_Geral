#include "protheus.ch"
#include "tbiconn.ch"
                      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTPROC24  ºAutor  ³Microsiga           º Data ³  12/19/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TTPROC24()

Local oGrp1
Private oDlg1
Private cCliente	:= Space(6)			
Private cLoja	:= Space(4)
Private cPatrimo := Space(254)
Private cAgente := Space(4)
Private oBtn

prepare environment empresa "01" filial "01"

If !FindFunction("U_TTTMKA19")
	Aviso("TTPROC19","Função U_TTTMKA19 não compilada no repositório.",{"Ok"})
	Return
EndIf

If !FindFunction("U_WSKPF009")
	Aviso("TTPROC19","Função U_WSKPF009 não compilada no repositório.",{"Ok"})
	Return
EndIf

	
oDlg1	:= MSDialog():New( 230,300,460,620,"Leitura de Serviço de café",,,.F.,,,,,,.T.,,,.T. )
	oFont	:= TFont():New('Arial',,-12,.T.,.T.)
	oSay	:= TSay():New( 004,004,{||"Criação de Planilha de Leitura de Serviço de Café"},oDlg1,,/*oFont*/,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)
	oSay2	:= TSay():New( 014,004,{||"Informe os patrimônios separados por ;"},oDlg1,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)

	//oGrp1	:= TGroup():New( 024,004,088,168,"",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	
	oSay3	:= TSay():New( 030,004,{||"Cliente"},oDlg1,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,008)     
	@ 040,004 GET oGet1 VAR cCliente OF oDlg1  SIZE 020,008 PIXEL
	
	oSay4	:= TSay():New( 030,040,{||"Loja"},oDlg1,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,008)     
	@ 040,040 GET oGet2 VAR cLoja OF oDlg1  SIZE 020,008 PIXEL
	
	oSay5	:= TSay():New( 030,076,{||"Agente"},oDlg1,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,20,008)     
	@ 040,076 GET oGet2 VAR cAgente OF oDlg1  SIZE 020,008 PIXEL
	
	oSay6	:= TSay():New( 060,004,{||"Patrimônios"},oDlg1,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,35,008)     
	@ 070,004 GET oMGet1 VAR cPatrimo OF oDlg1 MULTILINE SIZE 100,020 COLORS 0, 16777215 HSCROLL PIXEL

	oSBtn1	:= SButton():New( 092,076,1,{|| Processa({|| Gerar()   },"Criando planilhas, aguarde.."), oDlg1:End() },oDlg1,.T.,"Cria as planilhas", )

oDlg1:Activate(,,,.T.)

Return



Static Function Gerar()

Local aAux := {}
lOCAL cCNPJ := ""
Local nCont := 0
Local cNumOS := ""
Local aOS := {}


If AllTrim(cLoja) == ""
	cLoja := "0001"
EndIf

dbSelectArea("SA1")
dbSetOrder(1)
If dbSeek(xFilial("SA1")+AvKey(cCliente,"A1_COD") +AvKey(cLoja,"A1_LOJA"))
	cCNPJ := SA1->A1_CGC
EndIf

dbSelectArea("SN1")
dbSetOrder(2)
aAux := StrToKarr(cPatrimo, ";")
	
Procregua( Len(aAux) ) 
For nI := 1 To Len(aAux)
	nRecno := U_TTTMKA19(aAux[nI])
	If nRecno > 0
		SN1->( dbGoTo(nRecno) )
		If SN1->N1_XTPSERV $ "2|6"
			IncProc("Patrimônio " +aAux[nI])
			cNumOS := U_WSKPF009(2,cCNPJ,{aAux[nI]},Val(cAgente))
			If !AllTrim(cNumOS) $ "false" 
				//nCont++
				AADD(aOS, { aAux[nI], cNumOS } )
			EndIf
		EndIf
	EndIf
Next nI

If Len(aOS) > 0
	cMsg := "Foram criadas " +cvaltochar(Len(aOS)) + " planilhas." +CRLF
	//For nI := 1 To Len(aOS)
	  //	cMsg += "Patrimônio: " +aOS[nI][1]+ " - Planilha: " +aOS[nI][2] +CRLF
	//Next nI
	Aviso("TTPROC17",cMsg ,{"Ok"})
EndIf

Return