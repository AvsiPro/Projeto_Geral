/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MT010GRV � Autor � Artur Nucci Ferrari   � Data � 31/08/11 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de entrada de controle da tabela de pre�o            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function MT010GRV()
Local aArea	:= GetArea()
Local cUserLib  := Upper(AllTrim(cusername))
Local cCADVIP   := If(cEmpAnt == "01",AllTrim(SuperGetMv("MV_XCADVIP")),"")

If SM0->M0_CODIGO=='01' // .OR. SM0->M0_CODIGO=='11'

	IF cUserLib$(cCADVIP)
		If !(MsgYesNo("Confirma a libera��o da Tabela de Pre�os ?"))
			RecLock("AIA",.F.)
			AIA->AIA_DATATE  := ddatabase-1
			MsUnLock()
		Endif
	Else
		RecLock("AIA",.F.)
		AIA->AIA_DATATE  := ddatabase-1
		MsUnLock()
		MsgInfo("Esta tabela de Pre�os permanecer� Inativa at� que seja feita a avalia��o da controladoria." ,"I N F O R M A � � O")
	End
End
RestArea(aArea)
Return Nil
