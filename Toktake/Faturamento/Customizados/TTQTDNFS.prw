/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Fun��o    � TTQTDNFS    � Autor � Artur Nucci Ferrari   � Data � 14/07/10 ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao controle de Bloqueio de Abastecimento                  ���
����������������������������������������������������������������������������Ĵ��
��� Uso      � Tok Take Alimentacao                                          ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
/*/

User Function TTQTDNFS(_cFilial,_cDoc,_cSerie,_dEmissao,_cCliente,_cLoja)
Local aArea	 	:= GetArea()
Local c_EOL	    := CHR(13)+CHR(10)
Local nRetQtd   := 0
cQuery := "SELECT SUM(D2_QUANT) AS QTD " + c_EOL
cQuery += "FROM " + RetSqlName("SD2") + c_EOL
cQuery += "WHERE D_E_L_E_T_='' " + c_EOL
cQuery += "AND D2_FILIAL='" + _cFilial + "' " + c_EOL
cQuery += "AND D2_DOC='" + _cDoc + "' " + c_EOL
cQuery += "AND D2_SERIE='" + _cSerie + "' " + c_EOL
cQuery += "AND D2_EMISSAO='" + DTOS(_dEmissao) + "' " + c_EOL
cQuery += "AND D2_CLIENTE='" + _cCliente + "' " + c_EOL
cQuery += "AND D2_LOJA='" + _cLoja + "' " + c_EOL
MemoWrite("TTQTDNFS.sql",cQuery)
If Select("TRB") > 0
	dbSelectArea("TRB")
	DbCloseArea()
EndIf
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
nRetQtd := TRB->QTD
RestArea(aArea)
Return nRetQtd
