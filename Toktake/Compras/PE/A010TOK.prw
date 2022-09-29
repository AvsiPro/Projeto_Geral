/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A010TOK   �Autor  �Jackson E. de Deus  � Data �  08/02/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � PE utilizado na inclus�o e altera��o do produto            ���
���          � valida��o de dados ao clicar no bot�o OK                   ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function A010TOK()

Local lExecuta	:= .T.
Local cCodEAN	:= Alltrim(M->B1_CODBAR)


/*--------------------------------------------------------------------------------------+ 		    			           
|S�o admiss�veis 0, 8, 12, 13 ou 14 caracteres.											| 
|Assim, nenhuma nota ser� rejeitada por n�o informar os c�digos, ou por informar um	| 
|c�digo incorreto.																		|
+---------------------------------------------------------------------------------------*/
  

If Len(cCodEAN) != 0 .And. Len(cCodEAN) != 13 .And. Len(cCodEAN) != 14
	Aviso("A010TOK","C�digo EAN inv�lido! - Corrigir para prosseguir.", {"Ok"},1) 
	lExecuta := .F.
Else 
	lExecuta := .T.
EndIf
If cEmpAnt == "01"
	//CHAMADA PARA GRAVACAO DE LOG NA ALTERACAO DE CADASTRO DE PRODUTOS	 - Alexandre 25/02/14	
	IF ALTERA .AND. lExecuta
		U_TTGENC05("SB1")
	EndIf       
EndIF

Return (lExecuta)