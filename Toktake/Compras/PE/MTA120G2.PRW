#INCLUDE "rwmake.ch"    
#INCLUDE "TopConn.ch"

/*
*****************************************************************************
** Programa: MTA120G2.PRW ** Autor: Wanderley Andrade    ** Data: 21/12/09 **
*****************************************************************************
** Descricao: Ponto de entrada para gravacao do nome do fornecedor         **
*****************************************************************************
*/
User Function MTA120G2

cfornece := SC7->C7_FORNECE
cloja    := SC7->C7_LOJA
cpedido  := SC7->C7_NUM
                                         
If cEmpAnt == "01"
	area6   := getarea()
	
	cQry	:= " SELECT * "
	cQry	+= " FROM "+RetSqlName("SA2")+" SA2"
	cQry	+= " WHERE A2_FILIAL = '"+xFilial("SA2")+"'"
	cQry	+= " AND   A2_COD    = '"+cfornece+"'"
	cQry	+= " AND   A2_LOJA   = '"+cloja+"'"
	
	If Select("TM1") > 0
		dbSelectArea("TM1")
		dbCloseArea()
	EndIf
	TCQUERY cQry NEW ALIAS "TM1"
	dbSelectArea("TM1")
	dbGoTop()
	cnomefor  := TM1->A2_NOME
	 
	dbCloseArea()
	
	restarea(area6)
	
	q1 := " UPDATE "+RETSQLNAME("SC7")+" SET  C7_XFORNEC = '"+cnomefor+"'  WHERE C7_NUM = '"+cpedido+"' AND D_E_L_E_T_<> '*' "
	TcSqlExec(q1)
EndIf
                                                                             
Return
