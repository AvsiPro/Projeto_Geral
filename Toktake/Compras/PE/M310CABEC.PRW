#INCLUDE "Protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M310CABEC �Autor  � Cadubitski         � Data �  Jan/2010   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para ALTERAR os dados do cabecalho do      ���
���          �pedido de vendas na rotina de transferencia entre filiai.   ���
�������������������������������������������������������������������������͹��
���Uso       � TokTake                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function M310CABEC()

Private nOpca	:= .f.
Private aCabRet	:= aClone(ParamIxb[2])         
Private cTransp	:= CriaVar("A4_COD",.F.)

Private oDlg 
Private oTransp

If cEmpAnt == "01"
	If ParamIxb[1] == "MATA410"
	
		DEFINE MSDIALOG oDlg TITLE "Sele��o da Transportadora." FROM U_C(282),U_C(364) TO U_C(325),U_C(715) PIXEL
		
			@ U_C(009),U_C(016) Say "Transportadora:" 	Size U_C(040),U_C(008)   PIXEL OF oDlg
			@ U_C(008),U_C(053) MsGet oTransp Var cTransp F3 "SA4"	 VALID(Vazio(Alltrim(cTransp)).Or.ExistCpo("SA4",+Alltrim(cTransp))) WHEN .T. Size U_C(035),U_C(009) PIXEL OF oDlg
		
			//DEFINE SBUTTON FROM U_C(015),U_C(080) TYPE 1 OF oDlg ENABLE ACTION (nOpca := .T.,oDlg:End())
			DEFINE SBUTTON FROM U_C(008),U_C(115) TYPE 1 OF oDlg ENABLE ACTION ( VerTransp() )
			
		ACTIVATE MSDIALOG oDlg CENTERED 
	EndIf
EndIF

Return(aCabRet)


Static Function VerTransp()

If !Empty(Alltrim(cTransp))

	aadd(aCabRet,{"C5_XNFABAS","2"		,Nil})//Abastecimento
	aadd(aCabRet,{"C5_XFINAL" ,"3"		,Nil})//Transferencia
	aadd(aCabRet,{"C5_TRANSP" ,Alltrim(cTransp)	,Nil})
	
	nOpca := .T.
	oDlg:End()
Else
	Alert("Favor informar a transportadora")
	nOpca := .F.
EndIf

Return()
