#INCLUDE 'PROTHEUS.CH'

User Function M110STTS()
 
Local cNumSol   :=  Paramixb[1]
Local nOpt      :=  Paramixb[2]
Local lCopia    :=  Paramixb[3]
Local aAux1     :=  {}
Local aAux2     :=  {}
Local aAux3     :=  {}
Local nPosItem  :=  Ascan(aHeader,{|x| Alltrim(x[2]) == "C1_ITEM"})
Local nPosProd  :=  Ascan(aHeader,{|x| Alltrim(x[2]) == "C1_PRODUTO"})
Local nPosDesc  :=  Ascan(aHeader,{|x| Alltrim(x[2]) == "C1_DESCRI"})
Local nCont     :=  1
Local nX        :=  1
Local nZ        :=  1

If nOpt == 1 .And. !lCopia
    For nCont := 1 to len(aCols)
        aAux1 := buscaitem(aCols[nCont,nPosProd])
        If len(aAux1) > 0
            For nX := 1 to len(aAux1)
                aAux2 := {}
                For nZ := 1 to len(aHeader)
                    If nZ == nPosProd
                        Aadd(aAux2,aAux1[nX,01])
                    ElseIf nZ == nPosDesc
                        Aadd(aAux2,aAux1[nX,02])
                    ElseIf nZ == nPosItem
                        Aadd(aAux2,"    ")
                    Else 
                        Aadd(aAux2,aCols[nCont,nZ])
                    EndIF
                Next nZ 
                Aadd(aAux3,aAux2)
            Next nX
        EndIf
    Next nCont

    For nCont := 1 to len(aAux3)    
        Aadd(aCols,aAux3[nCont])
    Next nCont

    For nCont := 1 to len(aCols)
        If Empty(aCols[nCont,nPosItem])
            aCols[nCont,nPosItem] := strzero(nCont,4)
            Reclock("SC1",.T.)
            SC1->C1_FILIAL := cFilant
            SC1->C1_NUM    := cNumSol
            For nX := 1 to len(aHeader)
                lUsado := X3USO(GetSX3Cache(aHeader[nX,02], "X3_USADO"))
                cTipo := GetSX3Cache(aHeader[nX,02], "X3_CONTEXT")

                If lUsado .AND. cTipo <> "V" .And. !Alltrim(aHeader[nX,02]) $ "C1_ALI_WT/C1_REC_WT"
                    &("SC1->"+aHeader[nX,02]) := aCols[nCont,nX]
                endif
            Next nX 
            SC1->(Msunlock())
        EndIf 
    Next nCont
EndIf

Return Nil

/*/{Protheus.doc} BuscaItem
    (long_description)
    @type  Static Function
    @author user
    @since 18/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function BuscaItem(cCodigo)

Local aArea := GetArea()
Local aRet  := {}
Local cQuery 

cQuery := "SELECT B1_COD,B1_DESC" 
cQuery += " FROM "
cQuery += RetSQLName("SB1")+" B1"
cQuery += " WHERE B1_FILIAL='"+xFilial("SB1")+"' AND B1.D_E_L_E_T_=' '"
cQuery += " AND SUBSTRING(B1_COD,1,8) = '"+substr(cCodigo,1,8)+"' AND B1_COD<>'"+cCodigo+"'"
cQuery += " AND '"+cFilant+"'+B1_COD NOT IN(SELECT ZPN_FILIAL+ZPN_PRODUT FROM "+RetSQLName("ZPN")+" WHERE D_E_L_E_T_=' ')"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("MT110GRV.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

WHILE !EOF()
    Aadd(aRet,{TRB->B1_COD,TRB->B1_DESC})
    Dbskip()
EndDo 

RestArea(aArea)

Return(aRet)
