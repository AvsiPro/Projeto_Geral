#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} User Function nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 19/12/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function FA050DEL()

Local aArea     :=  GetArea()
Local lRet      :=  .T.

If Alltrim(SE2->E2_PREFIXO) == 'PA' .And. Alltrim(SE2->E2_TIPO) == 'PA' .And. !Empty(SE2->E2_TITORIG)
    
    cUpdQry := "UPDATE "+RetSQLName("SE2")
    cUpdQry += " SET E2_SALDO=E2_VALOR,E2_BAIXA=' ',R_E_C_D_E_L_=0,D_E_L_E_T_=' '"
    cUpdQry += " WHERE E2_FILIAL||E2_PREFIXO||E2_NUM||E2_PARCELA='"+Alltrim(SE2->E2_TITORIG)+"' AND D_E_L_E_T_='*'"
    TcSqlExec(cUpdQry)

EndIf 

RestArea(aArea)

Return(lRet)
