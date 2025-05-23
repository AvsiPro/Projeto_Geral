#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � BRA006B	       � Autor � Eder Franca   � Data � 22/08/22  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Trazer a Descri��o do Fornecedor identificadono Pedido de  ���
���Descri��o � Compras                                               	  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function BRA006B

Local cEmpNExc := SuperGetMV("TI_EMPNEXC",.F.,"03")
Local cFil     := SCR->CR_FILIAL
Local cNumPc   := ALLTRIM(SCR->CR_NUM)
Local cTipo    := SCR->CR_TIPO
Local cNome    := ""
Local cFornece := ""
Local cLoja    := ""
Local cUser    := ""
Local cComp    := ""

IF !cEmpAnt $ cEmpNExc 
    Return(_cNome)
endif

If cTipo == "PC"		
	cFornece := Posicione("SC7",1,cFil+cNumPc,"SC7->C7_FORNECE")	
	cLoja 	 := Posicione("SC7",1,cFil+cNumPc,"SC7->C7_LOJA")	
	cUser	 := Posicione("SC7",1,cFil+cNumPc,"SC7->C7_USER")
	cComp    := Substring(Posicione("SY1",3,xFilial("SY1")+cUser,"SY1->Y1_NOME"),1,10)
	cNome 	 := cComp+" - "+cFornece+" - "+cLoja+" - "+Posicione("SA2",1,xFilial("SA2")+cFornece+cLoja,"SA2->A2_NOME")

Endif

Return(cNome)


