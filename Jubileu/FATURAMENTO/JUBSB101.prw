#INCLUDE "Protheus.ch"
#Include "TbiConn.ch"
#include "fileio.ch"

#DEFINE ENTER chr(13)+chr(10)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SB1 ATU EAN�Autor  �Microsiga           � Data �  08/11/2021 ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza Ean SB1										      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
		MsgStop("O arquivo " +cArqAux + " n�o foi encontrado. A importa��o ser� abortada!","[AVSIB9] - ATENCAO")
		Return
	EndIf

	FT_FUSE(cArqAux)
	ProcRegua(FT_FLASTREC())
	FT_FGOTOP()
	While !FT_FEOF()

		IncProc("Lendo arquivo ...")

		cLinha := FT_FREADLN()

		If lPrim
			//Campos do cabe�alho
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

	MsgAlert("Importa��o conclu�da!")

Return
