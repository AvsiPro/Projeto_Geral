// Busca os funcionarios das empresas

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTTECC03  �Autor  � Jackson E. de Deus � Data �  09/08/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Consulta funcionarios                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User  Function TTTECC03(cMat)

Local cQuery := ""
Local cTabSRJ := "SRJ010"
Local cAliasSRA := ""
Local aAux := {}
Local nX := 0
Local aEmp := {"01","03","04","05","06","07","08","10","12","13"}
Local aStru := {}

If cEmpAnt <> "01"
  Return
EndIf

For nX := 1 To Len(aEmp)
    cAliasSRA := "SRA" +aEmp[nX] + "0"

	cQuery += "SELECT RA_MAT, RA_NOME, RA_CODFUNC, RA_TNOTRAB, RJ_DESC FROM " +cAliasSRA +" SRA " 
	
	cQuery += "	INNER JOIN " +cTabSRJ +" SRJ ON "
	cQuery += "	SRJ.RJ_FUNCAO = SRA.RA_CODFUNC "
	cQuery += "	AND SRJ.D_E_L_E_T_ = SRA.D_E_L_E_T_ "
	
	cQuery += " WHERE SRA.D_E_L_E_T_ = '' AND RA_DEMISSA = '' " 
		     
	If !Empty(cMat)
		cQuery += " AND RA_MAT = '"+cMat+"' "
	EndIf
	
	If nX <> Len(aEmp)
		cQuery += " UNION ALL "
	EndIf
	
	If nX == Len(aemp)
		cQuery += " ORDER BY RA_MAT"
	EndIf	
Next nx


If Select("TRBSRA") > 0
	TRBSRA->( dbCloseArea() )
EndIf                        

dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),"TRBSRA")  


Return