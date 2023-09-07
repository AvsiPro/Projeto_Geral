#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} User Function nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 30/08/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function JUBPAP09()

Local cQuery 
Local aAux     :=   {}
Local ddtini 
Local ddtfim
Local nCont 
Local cPasta   := '\CLIENTE\'

If Select("SM0") == 0
	RpcSetType(3)
	RPCSetEnv("01","0801")
EndIf

ddtini := ctod('01/01/2022')
ddtfim := ctod('31/12/2022')

cQuery := "SELECT F2_FILIAL,F2_DOC,F2_SERIE"
cQuery += " FROM "+RetSQLName("SF2")
cQuery += " WHERE F2_FILIAL BETWEEN ' ' AND 'ZZZ' "
cQuery += " AND F2_EMISSAO BETWEEN '"+dtos(ddtini)+"' AND '"+dtos(ddtfim)+"'"
cQuery += " AND D_E_L_E_T_=' ' AND F2_CHVNFE<>' '"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("CONFATC01.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

WHILE !EOF()
    Aadd(aAux,{TRB->F2_FILIAL,TRB->F2_DOC,TRB->F2_SERIE})
    Dbskip()
ENDDO


For nCont := 1 to len(aAux)
    DbSelectArea("SF2")
    DbSetOrder(1)
    DbSeek(aAux[nCont,01]+aAux[nCont,02]+aAux[nCont,03])

    DbSelectArea("SF3")
    DbSetOrder(5)
    DbSeek(SF2->F2_FILIAL+SF2->F2_SERIE+SF2->F2_DOC)

    U_JUBDANFE(aAux[nCont,02],aAux[nCont,03],cPasta,'Danfe_'+SF2->F2_FILIAL)
Next nCont 

Return
