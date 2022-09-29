/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Funcao    � VLD_E2TP � Autor � Artur Nucci Ferrari    � Data � 22/07/11 ���
��������������������������������������������������������������������������Ĵ��
���Descricao � Controlde de inclus�o ao Ctas. a Pagar                      ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Tok-Take                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
#include "rwmake.ch"

User Function VLD_E2TP(cTipo)
Local aArea	   := GetArea()
Local cUserSE2 := Upper(AllTrim(cusername))
Local c_EOL	   := CHR(13)+CHR(10)
Local cRetTip  := Space(3)

If cEmpAnt == "01"
	Return
EndIf

IIF(Empty(cTipo),Space(3),cTipo)
cQuery := "SELECT ZZF_TIPO "  + c_EOL
cQuery += "FROM " + RetSqlName("ZZF") + c_EOL
cQuery += "WHERE D_E_L_E_T_='' " + c_EOL
cQuery += "AND ZZF_CART='P' " + c_EOL
cQuery += "AND ZZF_USER='" + cUserSE2 + "' " + c_EOL
cQuery += "AND ZZF_TIPO='" + cTipo + "' " + c_EOL
MemoWrite("VLD_ESTP.sql",cQuery)
If Select("TRB") > 0
	dbSelectArea("TRB")
	DbCloseArea()
EndIf
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
dbSelectArea("TRB")
dbGoTop()
If Eof()
	Aviso("Gerenciamento de Ctas. a Pagar","Voc� n�o tem autoriza��o para incluir um t�tulo do tipo ["+ Alltrim(cTipo) +"] no contas a pagar.",{"Ok"},,"Aten��o:")
	
	cRetTip := ""
Else
	cRetTip := TRB->ZZF_TIPO
End
RestArea(aArea)
Return cRetTip
