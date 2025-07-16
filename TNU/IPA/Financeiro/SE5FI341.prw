#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} SE5FI341
Ponto de entrada para eliminar a baixa do titulo de PA
@type user function
@author user
@since 08/05/2025
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User function SE5FI341()

Local nRecSE5 := SE5->(Recno())
Local nRecSE2 := SE2->(Recno())
Local lBaixaPP := type("lBxPP") != "U" .And. type("aTitF") != "U"


If Funname() == "MATA103"
    If lBaixaPP
        aAreaSE2 := GetArea()
        If aTitF[1,4] > 0
            DbSelectArea("SE2")
            Dbgoto(aTitF[1,4])
            Reclock("SE2",.F.)
            SE2->E2_TIPO    :=  'PP '
            SE2->E2_SALDO   :=  aTitF[1,3]
            SE2->(Msunlock())
        EndIf 

        If aTitF[1,6] > 0
            DbSelectArea("SE5")
            Dbgoto(aTitF[1,6])
            Reclock("SE5",.F.)
            SE5->E5_TIPO    :=  'PP '
            SE5->E5_TIPODOC :=  aTitF[1,5]
            SE5->(Msunlock())
            RestArea(aAreaSE2)
        EndIf 

    EndIf
    If nRecSE5 > 0
        DbSelectArea("SE5")
        Dbgoto(nRecSE5)
        Reclock("SE5",.F.)
        dbDelete()
        SE5->(Msunlock())
        If nRecSE2 > 0
            DbSelectArea("SE2")
            Dbgoto(nRecSE2)
        
            DbSelectArea("SE5")
            DbSetOrder(7)
            If Dbseek(SE2->E2_FILIAL+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+"PA "+SE2->E2_FORNECE+SE2->E2_LOJA)
                Reclock("SE5",.F.)
                dbDelete()
                SE5->(Msunlock())
            EndIF 
        EndIf 
    EndIf 
EndIF 

Return
