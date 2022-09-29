#include "topconn.ch"
#include "colors.ch"
#include "protheus.ch"
                    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTCTBC05  ºAutor  ³Jackson E. de Deus  º Data ³  19/03/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Estorno de flag de contabilizacao                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TTCTBC05()

Local cCodFil := space(2)
Local cNota := space(9)
Local cSerie := space(3)
Local cCliFor := space(6)
Local cLoja := space(4)
Local aItens := { "Entrada", "Saída" }
Local cCombo := aItens[1]
Local nOpcao := 0
Local nTipo := 1
Local nOk := 0
Local cMsg := ""


oDlg2      := MSDialog():New( 088,232,450,635,"Estorno de contabilização",,,.F.,,,,,,.T.,,,.T. )
	
	oCBox1	:= TComboBox():New( 012,020,{ |u| If(PCount()>0,cCombo:=u,cCombo) },aItens,060,010,oDlg2,,{|| IIF(oCBOX1:NAT==1,nTipo:=1,nTipo:=2) },,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,cCombo)

	oSay1      := TSay():New( 024,020,{ || "Filial"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)
	oGet1      := TGet():New( 024,070,{ |u| If(PCount()>0,cCodFil:=u,cCodFil)},oDlg2,044,008,'@!', { || }, CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	
	oSay2      := TSay():New( 036,020,{ || "Nota"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)
	oGet2      := TGet():New( 036,070,{ |u| If(PCount()>0,cNota:=u,cNota)},oDlg2,044,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)                                                                                                                                                         
	
	oSay3      := TSay():New( 048,020,{ || "Série"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)
	oGet3      := TGet():New( 048,070,{ |u| If(PCount()>0,cSerie:=u,cSerie)},oDlg2,044,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    
	oSay4      := TSay():New( 060,020,{ || "Cliente/Fornecedor"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,045,008)
	oGet4      := TGet():New( 060,070,{ |u| If(PCount()>0,cCliFor:=u,cCliFor)},oDlg2,044,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

	oSay5      := TSay():New( 072,020,{ || "Loja"},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)
	oGet5      := TGet():New( 072,070,{ |u| If(PCount()>0,cLoja:=u,cLoja)},oDlg2,044,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

	oBtn1		:= TButton():New( 126,096,"Confirmar",oDlg2,{ ||oDlg2:End(nOpcao:=1) },037,012,,,,.T.,,"",,,,.F. )
	oBtn2		:= TButton():New( 126,146,"Sair",oDlg2,{ ||oDlg2:End(nOpcao:=0) },037,012,,,,.T.,,"",,,,.F. )
		                        
oDlg2:Activate(,,,.T.)


If nOpcao == 1
	// nota de entrada
	If nTipo == 1   	
		dbSelectArea("SF1")
		dbSetOrder(1)
		If dbSeek( AvKey(cCodFil,"F1_FILIAL") +AvKey(cNota,"F1_DOC") + AvKey(cSerie,"F1_SERIE") +AvKey(cCliFor,"F1_FORNECE") +AvKey(cLoja,"F1_LOJA") )	
			If !Empty(SF1->F1_DTLANC)
				cMsg := "Nota: " +cNota +CRLF
				cMsg += "Serie: " +cSerie +CRLF
				cMsg += "Data de digitação: " +DTOC(SF1->F1_DTDIGIT) +CRLF 
				cMsg += "Valor: R$" +CValToChar(SF1->F1_VALBRUT) +CRLF
				cMsg += "Confirma a exclusão do flag de contabilização?"
				nOk := Aviso("",cMsg,{"Sim","Não"},3)
				If nOk == 1
					RecLock("SF1",.F.)
	  				SF1->F1_DTLANC := ctod("")
					MsUnLock()
					MsgInfo("Excluído com sucesso.") 
				EndIf
			Else
				MsgInfo("Flag já excluído.")
			EndIf
		Else
			MsgInfo("Não foi encontrado lançamento que corresponda aos dados informados.")
		EndIf
	// nota de saida
	Else 
		dbSelectArea("SF2")
		dbSetOrder(2)
		If dbSeek( AvKey(cCodFil,"F2_FILIAL") +AvKey(cCliFor,"F2_CLIENTE") +AvKey(cLoja,"F2_LOJA") +AvKey(cNota,"F2_DOC") + AvKey(cSerie,"F2_SERIE")  )
			If !Empty(SF2->F2_DTLANC)
				cMsg := "Nota: " +cNota +CRLF
				cMsg += "Serie: " +cSerie +CRLF
				cMsg += "Data de emissão: " +DTOC(SF2->F2_EMISSAO) +CRLF 
				cMsg += "Valor: R$" +CValToChar(SF2->F2_VALBRUT) +CRLF
				cMsg += "Confirma a exclusão do flag de contabilização?"
				nOk := Aviso("",cMsg,{"Sim","Não"},3)
				If nOk == 1
					RecLock("SF2",.F.)
					SF2->F2_DTLANC := ctod("")
					MsUnLock()
					MsgInfo("Excluído com sucesso.") 
				EndIf	
			Else
				MsgInfo("Flag já excluído.")
			EndIf  
		Else
			MsgInfo("Não foi encontrado lançamento que corresponda aos dados informados.")	
		EndIf
	EndIf		
EndIf                        

                        
Return                                                  