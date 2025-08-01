#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#INCLUDE "ap5mail.ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT100TOK  �Autor  �Rodrigo Barreto	 � Data �  01/05/2022 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada na validacao do Botao OK da Classificacao ���
���          � do documento de entrada.                                   ���
�������������������������������������������������������������������������͹��
���Uso       � CLINICAS INTELIGENTE                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function MT100TOK

	Local aArea		:= 	GetArea()
	//Local nX
	Local aStatusP := {}
	Local lRet := .T.
	Local  oFont, oSay
	Private cMenObs := Space(06)////	SF1->F1_XTICKET//Space(06)

	Public _XSTTCLA	:=	''
	Public _XTICKET := 	''

	If funname() == "MATA103" //.and. !Inclui
		//If !Inclui
			cMenObs := SF1->F1_XTICKET
		//EndIf

		aAdd(aStatusP , "A=[Nota Classificada]")
		aAdd(aStatusP , "B=[Fornecedor errado] ")
		aAdd(aStatusP , "C=[Documento n�o fiscal] ")
		aAdd(aStatusP , "D=[Valor errado] ")
		aAdd(aStatusP , "E=[Itens divergentes da nota] ")
		aAdd(aStatusP , "F=[Sem documento anexo] ")
		aAdd(aStatusP , "G=[N�mero NFS errado]")
		aAdd(aStatusP , "H=[Filial incorreta]")

		@ 100,000 TO 230,270 DIALOG oDlg1 TITLE "Status da Classifica��o "

		cCombo1:= aStatusP[1]


		oCombo1 := TComboBox():New(02,02,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},;
			aStatusP,100,20,oDlg1,,,,,,.T.,,,,,,,,,'cCombo1')

		@ 22,02 SAY oSay PROMPT 'Informe o n�mero do ticket' SIZE 100,20 COLORS CLR_BLACK,CLR_WHITE FONT oFont OF oDlg1 PIXEL
		@ 32,02 GET cMenObs Picture "@S80!" SIZE 100,30

		@ 45,02 BUTTON "_Ok " SIZE 35,15 ACTION If(!empty(alltrim(cMenObs)),Processa({|| Grava()},,"Gravando...."),"")
		//Processa({|| Grava()},,"Gravando....")
		//@ 45,85 BUTTON "_Sair" SIZE 35,15 ACTION Close(oDlg1)

		ACTIVATE DIALOG oDlg1 CENTERED

		
	EndIF
	RestArea( aArea )
	//Return(.T.)
Return(lRet)

/*
*********************************
* FUN��O PARA GRAVA��O DOS DADOS
*********************************
*/

Static Function Grava()

	Local lRet		:= .T.
	Private cStClas := ""


	If cCombo1 == "A"
		cStClas := "A=Nota Classificada"
	ElseIf cCombo1 == "B"
		cStClas := "B=Fornecedor errado"
	ElseIf cCombo1 == "C"
		cStClas :=	"C=Documento n�o fiscal""
	ElseIf cCombo1 == "D"
		cStClas := "D=Valor errado"
	ElseIf cCombo1 == "E"
		cStClas := "E=Itens divergentes da nota"
	ElseIf cCombo1 == "F"
		cStClas := "F=Sem documento anexo"
	ElseIf cCombo1 == "G"
		cStClas := "G=N�mero NFS errado"
	ElseIf cCombo1 == "H"
		cStClas := "H=Filial errada"
	Else
		alert("Defina um status para a classifica��o.")
	EndIf

	If cCombo1 <> "A"
		l103class := .F.
	EndIf
	
	iF !Inclui
		DbSelectArea("SF1")
		DbSetOrder(1)
		Reclock("SF1",.F.)
		SF1->F1_XSTTCLA := cStClas
		SF1->F1_XTICKET := cMenObs
		SF1->(Msunlock())
	Else 
		_XSTTCLA	:=	cStClas
	 	_XTICKET 	:= 	cMenObs
	EndIf
	
	Close(oDlg1)

Return (lRet)
