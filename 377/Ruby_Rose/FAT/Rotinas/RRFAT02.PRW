#INCLUDE "PROTHEUS.CH"

User Function RRFAT02

Local aArea :=  GetArea()
Local nRet  := 0
Local cQuery 

cQuery := "SELECT SUM(C6_VALOR) AS TOTAL FROM "+RetSQLName("SC6")
cQuery += " WHERE C6_FILIAL='"+SC5->C5_FILIAL+"' AND C6_NUM='"+SC5->C5_NUM+"'"
cQuery += " AND D_E_L_E_T_=' '"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB")

nRet := TRB->TOTAL

RestAreA(aArea)

Return(nRet)
