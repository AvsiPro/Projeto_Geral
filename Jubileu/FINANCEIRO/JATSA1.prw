#INCLUDE "Protheus.ch"
#Include "TbiConn.ch"
#include "fileio.ch"

#DEFINE ENTER chr(13)+chr(10)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SA1 ATU EAN�Autor  �Microsiga           � Data �  24/04/2022 ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza SA1		        							      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function JATSA1()

	Local cLinha  := ""
	Local cArqAux := ""
	Local cNome, cCodCli,cLoj    := ""
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
		cCodCli := Alltrim(aDados[nX,01])
		cLoj := Alltrim(aDados[nX,02])
		cVend	:= PadL(alltrim(aDados[nX,03]), 6, '0') 
		/*If cLoja <> "" .and. Rat("'",cLoja) 
        	cLoja   := substr(alltrim(aDados[nX,02]),2,4)
		Else 
			cLoja := alltrim(aDados[nX,02])
		EndIf
*/
		/*If len(cCod) < 6
			cCod := Padl(cCod,6,"0")
		EndIf
		*/
		DbSelectArea('SA1')
		DbSetOrder(1)
		//A1_FILIAL+A1_COD+A1_LOJA
		If Dbseek(xFilial('SA1')+AvKey(cCodCli ,"A1_COD")+ AvKey(cLoj  ,"A1_LOJA"))
			RecLock('SA1',.F.)
						
            SA1->A1_VEND    := cVend
            
           	SA1->(MsUnLock())
		EndIf
		DBCloseArea('SA1')
		
	Next nX

	MsgAlert("Importa��o conclu�da!")

Return


//Fucso cliente pelo nome
User function busCli(cNome)

Local lOk := .f.

Return
