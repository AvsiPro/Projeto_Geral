#INCLUDE "Protheus.ch"
#Include "TbiConn.ch"
#include "fileio.ch"

#DEFINE ENTER chr(13)+chr(10)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SB1 ATU EAN�Autor: Leonardo Oliveira   � Data �  01/06/2023 ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza C�digo de barras	        				      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RobCBar()

	Local cLinha  := ""
	Local cArqAux := ""
	Local cCodProd,cCodBar    := ""
	Local nX := 0
	Local lPrim   := .T.
	Local aCampos := {}
	Local aDados  := {}
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
		//cCpf := Alltrim(aDados[nX,01])
		cCodProd := Alltrim(aDados[nX,01])
		cCodBar := SUBSTR(Alltrim(aDados[nX,02]),1,13)

		DbSelectArea('SB1')
		DbSetOrder(1)
		If Dbseek(xFilial('SB1')+cCodProd )
			RecLock('SB1',.F.)
				SB1->B1_CODBAR := cCodBar
		EndIf
	Next nX
	//DBCloseArea('SB1')

	MsgAlert("Importa��o conclu�da!")

Return
