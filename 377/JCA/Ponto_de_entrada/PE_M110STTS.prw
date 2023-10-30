#INCLUDE 'PROTHEUS.CH'
/*
    Ponto de entrada
    Cadastro de Marca do produto. Este cadastro precisa ser exibido na cotação e impresso nos relatórios.
    
    MIT 44_COMPRAS_COM009 - Marca do produto a ser exibido na cotação e impresso nos relatórios.

    Doc Mit
    https://docs.google.com/document/d/12hwpYztGFmFivlgxVfnDndqlwzB4nnZ6/edit
    Doc Validação entrega
    https://docs.google.com/document/d/1TQi-rLxiiEsTbCZE82Os3HvqnTZrdqP2/edit
    
    
*/
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
Local nPosQtd   :=  Ascan(aHeader,{|x| Alltrim(x[2]) == "C1_QUANT"})
Local nPosVnt   :=  Ascan(aHeader,{|x| Alltrim(x[2]) == "C1_VUNIT"})
Local nPosCC    :=  Ascan(aHeader,{|x| Alltrim(x[2]) == "C1_CC"})

Local nCont     :=  1
Local nX        :=  1   
Local nZ        :=  1
Local cFiEntr   :=  If(cvaltochar(nOpt) $ '1/2',CFILENT,'')


If cvaltochar(nOpt) $ '1/2' .And. !lCopia
    For nCont := 1 to len(aCols)
        If empty(Posicione("SB1",1,xFilial("SB1")+aCols[nCont,nPosProd],"B1_XCODPAI"))
            aAux1 := U__SearchSon(aCols[nCont,nPosProd])
            If len(aAux1) > 0
                For nX := 1 to len(aAux1)
                    nPosCol := Ascan(aCols,{|x| Alltrim(x[nPosProd]) == Alltrim(aAux1[nX,01])})
                    nPosAux := Ascan(aAux3,{|x| Alltrim(x[nPosProd]) == Alltrim(aAux1[nX,01])})
                    If nPosCol == 0 .and. nPosAux == 0
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
                    EndIf
                Next nX
            EndIf
        EndIf
    Next nCont

    For nCont := 1 to len(aAux3)    
        Aadd(aCols,aAux3[nCont])
    Next nCont

    For nCont := 1 to len(aCols)
        If Empty(aCols[nCont,nPosItem])

            aCols[nCont,nPosItem] := strzero(nCont,4)

            aBlock := xBloqCC(aCols[nCont,nPosCC])

            Reclock("SC1",.T.)
            SC1->C1_FILIAL := cFilant
            SC1->C1_NUM    := cNumSol
            SC1->C1_FILENT := cFiEntr
            If len(aBlock) > 0
                SC1->C1_APROV  := 'B'
            EndIf

            For nX := 1 to len(aHeader)
                lUsado := X3USO(GetSX3Cache(aHeader[nX,02], "X3_USADO"))
                cTipo := GetSX3Cache(aHeader[nX,02], "X3_CONTEXT")

                If lUsado .AND. cTipo <> "V" .And. !Alltrim(aHeader[nX,02]) $ "C1_ALI_WT/C1_REC_WT"
                    &("SC1->"+aHeader[nX,02]) := aCols[nCont,nX]
                endif
            Next nX 
            SC1->(Msunlock())

            If len(aBlock) > 0
                GeraBloq(aBlock,cNumSol,aCols[nCont,nPosItem],aCols[nCont,nPosQtd] * aCols[nCont,nPosVnt])
            EndIf 
        EndIf 
    Next nCont

    
EndIf

Return Nil

/*/{Protheus.doc} _SearchSon
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
User Function _SearchSon(cCodigo)

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

/*/{Protheus.doc} xBloqCC
    (long_description)
    @type  Static Function
    @author user
    @since 17/10/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function xBloqCC(cNumero)

Local cQuery 
Local aRet  := {}

cQuery := "SELECT DBL_GRUPO,DBL_ITEM,DBL_CC,AL_ITEM,AL_APROV,AL_USER"
cQuery += " FROM "+RetSQLName("DBL")+" DBL"
cQuery += " INNER JOIN "+RetSQLName("SAL")+" AL ON AL_FILIAL=DBL_FILIAL AND AL_COD=DBL_GRUPO AND AL.D_E_L_E_T_=' '"
cQuery += " WHERE DBL.D_E_L_E_T_=' ' AND DBL_FILIAL='"+xFilial("DBL")+"' AND DBL_CC='"+cNumero+"'"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("MT110GRV.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

While !EOF()
    Aadd(aRet,{ TRB->DBL_GRUPO,;
                TRB->DBL_ITEM,;
                TRB->DBL_CC,;
                TRB->AL_ITEM,;
                TRB->AL_APROV,;
                TRB->AL_USER })
    Dbskip()
EndDo 

Return(aRet)

/*/{Protheus.doc} xBlocCC
    (long_description)
    @type  Static Function
    @author user
    @since 18/10/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function GeraBloq(aArray,cNumSol,cItem,nValor)

Local aArea := GetArea()
Local nP 

For nP := 1 to len(aArray)
    Reclock("DBM",.T.)

    DBM->DBM_FILIAL :=  xFilial("DBM")
    DBM->DBM_TIPO   :=  'SC'
    DBM->DBM_NUM    :=  cNumSol
    DBM->DBM_ITEM   :=  cItem
    DBM->DBM_GRUPO  :=  aArray[nP,1]
    DBM->DBM_ITGRP  :=  aArray[nP,2]
    DBM->DBM_USER   :=  aArray[nP,6]
    DBM->DBM_APROV  :=  '2'
    DBM->DBM_USAPRO :=  aArray[nP,5]
    DBM->DBM_VALOR  :=  nValor

    DBM->(MSUNLOCK())
Next nP

RestArea(aArea)

Return
