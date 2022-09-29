#include "topconn.ch"
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AT460TOK  �Autor  �Jackson E. de Deus  � Data �  26/09/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �PE executado apos a confirmacao para validacao da tela.     ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  �Versao| Alteracao realizada                    ���
�������������������������������������������������������������������������Ĵ��
���Jackson       �26/09/14�01.01 |Criacao                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function AT460TOK()

Local lRet := .T.
Local aArea := GetArea()
Local cCliente := AB6->AB6_CODCLI
Local cLoja := AB6->AB6_LOJA
Local cProduto := AB7->AB7_CODPRO
Local cNumChapa := AB7->AB7_NUMSER

If cEmpAnt <> "10"
	dbSelectArea("AA3")
	dbSetOrder(1)
	If !dbSeek( xFilial("AA3") +AvKey(cCliente,"AA3_CODCLI") +AvKey(cLoja,"AA3_LOJA") +AvKey(cProduto,"AA3_CODPRO") +AvKey(cNumChapa,"AA3_NUMSER") )
		SET DELETED OFF
		
		dbSeek( xFilial("AA3") +AvKey(cCliente,"AA3_CODCLI") +AvKey(cLoja,"AA3_LOJA") +AvKey(cProduto,"AA3_CODPRO") +AvKey(cNumChapa,"AA3_NUMSER") )
		If Found()
			/*
			variavel criada para guardar o recno do registro que esta sendo recuperado
			utilizada posteriormente no PE AT460GRV para excluir novamente o registro
			*/                                                
			//_SetNamedPrvt( "_nRecAA3" , RECNO() , "TECA460" )           
			
			//RecLock("AA3",.F.)
			//dbRecall()       
			//MsUnLock()
		EndIf
	EndIf
EndIf          

RestArea(aArea)

Return lRet