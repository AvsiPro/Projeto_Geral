#include 'rwmake.ch'
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � M410LIOK � Autor �  Marcio Santos Frade  � Data � 19/11/09 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Nao permite inclusao de Pedido com finalidade Venda sem    ���
���          � informar Item Contabil e Centro de Custo                   ���
�������������������������������������������������������������������������Ĵ��
���Observacao�                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico                                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function TMKLINOK()

Local lRet 	  := .T.
Local cCC     := GDFieldGet ("UB_CCUS",n)

If cEmpAnt == "01"
	
	If M->UA_XFINAL=="1" .and. Empty(cCC) //Tipo de Venda - Exigir Pedido de Venda
		Aviso("Verifica��o C.Custo","Pedido com Finalidade de Venda. Favor informar o Centro de Custo.",{"Ok"},,"Aten��o:")
	    lRet := .F.
	EndIf
	      
	
	//Nao permitr pedido de abastecimento sem local de estoque.
	If M->UA_XNFABA == "1" .and. Empty(M->UA_XCODPA)
		Aviso("Verifica��o Abastecimento.","Pedido de abastecimento, favor informar o local de estoque no cabe�alho do pedido de venda.",{"Ok"},,"Aten��o:")	
		lRet := .F.
	EndIf
	
	
	/*If Empty(GDFieldGet("UB_LOCAL",n))
		Aviso("Armazem.","Armazem em branco. Favor verificar.",{"Ok"},,"Aten��o:")	
		lRet := .F.
	EndIf*/
EndIf

Return (lRet)