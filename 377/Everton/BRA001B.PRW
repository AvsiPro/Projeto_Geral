#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � BRA001B	       � Autor � Eder Franca   � Data � 25/08/22  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Trazer a Descri��o do Fornecedor ou Cliente na Tabela de   ���
���Descri��o � Documento de Entrada - BROWSER Tabela SF1             	  ���
���@Altera��o - Everton Rosa 24/10/2024 - Retirar a funcionalidade para o grupo de empresa 03���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function BRA001B

Local cEmpNExc := SuperGetMV("TI_EMPNEXC",.F.,"03")
Local _cnome := " "

	IF !cEmpAnt $ cEmpNExc 
		Return(_cnome)
	endif

If SF1->F1_TIPO=="D" .OR. SF1->F1_TIPO=="B"		
	_cnome := Posicione("SA1",1,XFILIAL("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,"SA1->A1_NOME")	
Else
	_cnome := Posicione("SA2",1,XFILIAL("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"SA2->A2_NOME")
Endif

Return(_cnome)


