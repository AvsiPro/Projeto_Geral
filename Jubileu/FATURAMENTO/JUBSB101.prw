#INCLUDE "Protheus.ch"
#Include "TbiConn.ch"
#include "fileio.ch"

#DEFINE ENTER chr(13)+chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SB1 ATU EANºAutor  ³Microsiga           º Data ³  08/11/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualiza Ean SB1										      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function JUBSB101()

	Local cLinha  := ""
	Local cArqAux := ""
	Local cLocP	  := ""
	Local nValCus	  := 0
	Local cCod    := ""
	Local nX := 0
	Local lPrim   := .T.
	Local aCampos := {}
	Local aDados  := {}
	Local aVetor  := {}
	Local lMsErroAuto := .F.

	//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "0201"

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
		cCod 	:= Alltrim(aDados[nX,01])
		//nValCus    := val(Alltrim(aDados[nX,02]))
		cCodEan := Alltrim(aDados[nX,02])

		DbSelectArea('SB1')
		DbSetOrder(1)
		 If Dbseek(xFilial('SB1')+cCod)
			RecLock('SB1',.F.)
			SB1->B1_CODBAR := cCodEan
			SB1->(MsUnLock())
		EndIf
	Next nX

	MsgAlert("Importação concluída!")

Return
