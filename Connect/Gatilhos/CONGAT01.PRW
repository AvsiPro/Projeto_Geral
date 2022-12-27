#INCLUDE "PROTHEUS.CH"

User Function _XGTFT01

Local aArea :=  GetArea()
Local cQuery 
Local cCod  :=  Alltrim(M->B1_COD)+Alltrim(B1_XSUBTIP)

cQuery := "SELECT MAX(B1_COD) AS CODIGO"
cQuery += " FROM "+RetSQLName("SB1")
cQuery += " WHERE D_E_L_E_T_=' ' "
cQuery += " AND SUBSTRING(B1_COD,1,8) = '"+cCod+"'"
cQuery += " GROUP BY SUBSTRING(B1_COD,1,8)"

If Select('TRB') > 0
	dbSelectArea('TRB')	
	dbCloseArea()
EndIf     

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
dbSelectArea("TRB")

If !Empty(TRB->CODIGO)
    if len(AllTrim(TRB->CODIGO)) > 8
        cAux := Soma1(Alltrim(TRB->CODIGO))
        cCod := cAux
    else
        MsgAlert(TRB->CODIGO + " ja existe!", "Erro!")
    endif
Else 
    cCod := cCod+'01'
EndIf

RestArea(aArea)

Return(cCod)
