#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
                  
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � BRA003B	� Autor � Eder Franca           � Data � 25/08/22 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Trazer a Descri��o do Fornecedor ou Cliente na Tabela de   ���
���Descri��o � Pedido de Vendas - BROWSER Tabela SC5             	  ���
���@Altera��o - Everton Rosa 24/10/2024 - Retirar a funcionalidade para o grupo de empresa 03���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function BRA003B
Local cEmpNExc := SuperGetMV("TI_EMPNEXC",.F.,"03")
Local _cNome := " "

IF !cEmpAnt $ cEmpNExc 
    Return(_cNome)
endif
If (SC5->C5_TIPO=="D" .OR. SC5->C5_TIPO=="B")		
	_cNome := POSICIONE("SA2",1,XFILIAL("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"SA2->A2_NOME")	
Else
	_cNome := POSICIONE("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"SA1->A1_NOME")
Endif

Return(_cNome)


