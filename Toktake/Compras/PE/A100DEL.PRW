
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A100DEL   �Autor  �  Cadubitski        � Data �  Jan/2010   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para nao permitr a exclusao da NFE se for  ���
���          �do tipo transferencia entre filiais.                        ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function A100DEL()

Local lRet := .T.
Local cUsrAut   := If(cEmpAnt == "01",Upper(AllTrim(SuperGetMV("MV_XADMFIS"))),"")
Local cUserLib  := Upper(AllTrim(cusername))

IF !(cUserLib$(cUsrAut)) .And. CEMPANT == "01"
	If !Empty(Alltrim(SF1->F1_XTRANSF))
		MsgAlert("Aten��o, a nota fiscal "+Alltrim(SF1->F1_DOC)+" � relativa a transferencia da filial "+Alltrim(SF1->F1_XTRANSF)+". Exclus�o n�o permitida.")
		Return(.F.)
	EndIf
END IF


Return(lRet)