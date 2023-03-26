#include "rwmake.ch"
/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o      � M460FIM  � Autor � RODRIGO CORREA        � Data �dd/mm/aa  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o � - Utilizado na Geracao da Nota Fiscal de Saida               ���
���          � - Ponto de entrada disparado na geracao da nota de saida.    ���
���          � - Atualizar campos na Tabela SF2                             ���
���������������������������������������������������������������������������Ĵ��
��� Uso        � Protheus 12                                               ���
���������������������������������������������������������������������������Ĵ��
���Programador � Alteracao feita pelo Motivo ( Descricao abaixo)            ���
���������������������������������������������������������������������������Ĵ��
���            �                                                            ���
���            � Especifico DDC                                             ���
���            �                                                            ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
User Function M460FIM()
Local aArea		:= GetArea()	
Local cQuery	:= ""
Local nTotQtde	:= 0

cQuery := " SELECT D2_FILIAL,    "
cQuery += "        D2_COD,       "
cQuery += "        D2_QUANT      "
cQuery += "   FROM " + RetSQLName("SD2") 
cQuery += "  WHERE D2_FILIAL   = '" + xFilial("SD2") 	+ "' "
cQuery += "    AND D2_SERIE    = '" + SF2->F2_SERIE 	+ "' "
cQuery += "    AND D2_DOC      = '" + SF2->F2_DOC 		+ "'
cQuery += "    AND D_E_L_E_T_  = ' ' " 


If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf


cQuery := ChangeQuery(cQuery)                                          
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.F.)
TcSetField("TRB","D2_QUANT","N",11,2)                   

//For ni := 1 to Len(aStru)
//	If aStru[ni,2] != 'C'
//		TCSetField('TRB', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
//	Endif
//Next
 
DbSelectArea("TRB")	
While !Eof()
	nTotQtde += TRB->D2_QUANT
	DbSelectArea("TRB")		
	DbSkip()
End
DbSelectArea("TRB")	
DbCloseArea()

DbSelectArea("SF2")
RecLock("SF2", .F.)
SF2->F2_XQTDPD  := nTotQtde

MsUnLock()       

RestArea(aArea)
Return