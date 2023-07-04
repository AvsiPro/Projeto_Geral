#INCLUDE "Protheus.ch"
#Include "TbiConn.ch"
#include "fileio.ch"

#DEFINE ENTER chr(13)+chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³User Function ROBSAINI()
ºAutor  ³Microsiga           º Data ³  20/03/2023						 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importa saldo incial de produtos por arquivos CSV          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ROBSAINI()

	Private cLinha  := ""
	Private cArqAux := ""
	Private cLocP	  := ""
	Private cCod    := ""
	Private lPrim   := .T.
	Private aCampos := {}
	Private aDados  := {}
	Private aVetor  := {}
	Private cFilAtu :=""
	Private lMsErroAuto := .F.
	Private cFileLog :=	'log_sld_'+dtos(ddatabase)+strtran(cvaltochar(time()),":")+'.txt'
	Private nHandle	:=	fcreate('c:\Temp\'+cFileLog , FO_READWRITE + FO_SHARED )

	//Chamando o cGetFile para pegar um arquivo txt ou xml, mostrando o servidor
	cArqAux := cGetFile( 'Arquivo *.csv|*.csv ',; //[ cMascara],
		'Selecao de Arquivos',;                  //[ cTitulo],
		0,;                                      //[ nMascpadrao],
		'C:\',;  	                              //[ cDirinicial],
		.F.,;                                    //[ lSalvar],
		GETF_LOCALHARD  + GETF_NETWORKDRIVE,;    //[ nOpcoes],
		.T.)                                     //[ lArvore]

	If !File(cArqAux)
		MsgStop("O arquivo " +cArqAux + " não foi encontrado. A importação será abortada!","[AVSIB9] - ATENCAO")
		Return
	EndIf

	Processa({||execlog()}, "Processando...")

Return
/*/{Protheus.doc} nomeFunction
	(long_description)
	@type  Function
	@author user
	@since date
	@version version
	@param param, param_type, param_descr
	@return return, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function execlog()

	Local nX := 0

	FT_FUSE(cArqAux)
	ProcRegua(FT_FLASTREC())
	FT_FGOTOP()

	While !FT_FEOF()

		IncProc("Lendo arquivo ...")

		cLinha := FT_FREADLN()

		If lPrim
			//Campos do cabeçalho
			aCampos := Separa(cLinha,";",.T.)
			lPrim := .F.
		Else
			//Itens
			AADD(aDados,Separa(cLinha,";",.T.))
		EndIf

		FT_FSKIP()
	EndDo

	For nX := 1 to len(aDados)
		cCod	:= ""
		cFilAtu := Padl(alltrim(aDados[nX,1]),4,"0")
		cfilant	:= cFilAtu
		cCod 	:= Alltrim(aDados[nX,02])
		cLocP   := padl(Alltrim(aDados[nX,04]),3,"0")

		dbSelectArea("SB1")
		SB1->(dbSetOrder(1))
		If SB1->(DbSeek(xFilial("SB1")+PadR(cCod, tamsx3('B1_COD') [1])))
			//verificar se produto bloqueado e dar laerta no relatorio
			If !SB1->B1_MSBLQL == "1"
				aVetor :={ {"B9_FILIAL" , cFilAtu				,  Nil},;
					{"B9_COD"    , SB1->B1_COD			,  Nil},;
					{"B9_LOCAL"  , cLocP		  		,  Nil},;
					{"B9_QINI"   , val(aDados[nX,03])	,  Nil} }

				DbselectArea("SB9")
				DbSetOrder(1)
				If !Dbseek(cfilant+SB1->B1_COD+cLocP)

					Begin Transaction
						lMsErroAuto := .F.
						MSExecAuto({|x, y| Mata220(x, y)}, aVetor, 3)
						If lMsErroAuto
							FWrite(nHandle,'Linha '+cvaltochar(nX+1)+" # "+SB1->B1_COD+"# Error_Log"+Chr(13)+Chr(10),1000)
							MostraErro('C:\TEMP\','sld_ini_'+dtos(ddatabase)+strtran(cvaltochar(time()),":")+'.txt')
							DisarmTransaction()
						else
							FWrite(nHandle,'Linha '+cvaltochar(nX+1)+" # "+SB1->B1_COD+"# OK"+Chr(13)+Chr(10),1000)
						EndIf
					End Transaction
				else
					FWrite(nHandle,'Linha '+cvaltochar(nX+1)+" # "+SB1->B1_COD+" # OK"+Chr(13)+Chr(10),1000)
				EndIf
			ELSE
				FWrite(nHandle,'Linha '+cvaltochar(nX+1)+" # "+SB1->B1_COD+" # ERRO produto bloqueado"+Chr(13)+Chr(10),1000)				
			ENDIF
		Else
			//Alert("Produto não encontrado, verifique o produto da linha "+STR(nX-1) )
			FWrite(nHandle,'Linha '+cvaltochar(nX+1)+" # "+cCod+"# ERRO produto inexistente"+Chr(13)+Chr(10),1000)
		EndIf
	Next nX

	FT_FUse()
	FCLOSE( nHandle )
	MsgAlert("Importação concluída!")
	WinExec('NOTEPAD '+ 'c:\Temp\'+cFileLog,1)

Return
