#INCLUDE 'PROTHEUS.CH'

User Function MT170FIM()

Local aArea     := GetArea() 
Local aSolic    := PARAMIXB[1]
Local aFilho    := {}
Local nCont     := 0
Local aCampos   := {}
Local nCnt2     := 0
Local nBkpQtd   := 0 //SC1->C1_QUANT
Local nDivQtd   := 0 //round(nBkpQtd / len(aFilho),0)
Local aAux      := {}
Local nX        := 0
Local _aCols    := {}

For nCont := 1 to len(aSolic)
    aAux    := U__SearchSon(aSolic[nCont,01])
    Aadd(aAux,{aSolic[nCont,02],qtditem(aSolic[nCont,02],aSolic[nCont,01]),aSolic[nCont,01]})
    Aadd(aFilho,aAux)
Next nCont 

If len(aFilho) > 0

    aCampos := FWSX3Util():GetListFieldsStruct( "SC1" , .F. )   

    For nCont := 1 to len(aCampos)
        Aadd(_aCols,{aCampos[nCont,01],}) //&("SC1->"+aCampos[nCont,01])
    Next nCont

    npos1 := Ascan(_aCols,{|x| x[1] == "C1_PRODUTO"})
    npos2 := Ascan(_aCols,{|x| x[1] == "C1_DESCRI"})
    npos3 := Ascan(_aCols,{|x| x[1] == "C1_ITEM"})
    npos4 := Ascan(_aCols,{|x| x[1] == "C1_QUANT"})
    npos5 := Ascan(_aCols,{|x| x[1] == "C1_NUM"})

    
    For nCont := 1 to len(aFilho)
        For nX := 1 to len(aFilho[nCont])-1

            aAuxiliar := BuscaSolc(aFilho[nCont,len(aFilho[nCont]),1],aFilho[nCont,len(aFilho[nCont]),3],aCampos)
            
            For nCnt2 := 1 to len(_aCols)
                nPos := Ascan(aAuxiliar,{|x| x[1] == _aCols[nCnt2,01]})
                If nPos > 0
                    _aCols[nCnt2,02] := aAuxiliar[nPos,02]
                EndIf 
            Next nCnt2

            If nBkpQtd == 0
                nBkpQtd := aFilho[nCont,len(aFilho[nCont]),02]
                nDivQtd := round(nBkpQtd / (len(aFilho[nCont])-1),0)
            ENDIF

            _aCols[nPos1,02] := aFilho[nCont,nX,01]
            _aCols[nPos2,02] := aFilho[nCont,nX,02]
            _aCols[nPos3,02] := maxitem(aFilho[nCont,len(aFilho[nCont]),01])

            If nDivQtd < nBkpQtd
                _aCols[npos4,02] := nDivQtd
                nBkpQtd := nBkpQtd - nDivQtd
            Else 
                _aCols[npos4,02] := nBkpQtd
            EndIf 

            Reclock("SC1",.T.)
            For nCnt2 := 1 to len(aCampos)
                If !aCampos[nCnt2,01] $ 'C1_XCLASSI'
                    nPos := Ascan(_aCols,{|x| alltrim(x[1]) == alltrim(aCampos[nCnt2,01])})
                    If nPos > 0
                        &("SC1->"+aCampos[nCnt2,01]) := _aCols[nPos,02]
                    EndIf
                EndIf 
            Next nCnt2 
            SC1->(Msunlock())
        Next nX
    Next nCont 

    
EndIf 

RestArea(aArea)

Return



 /*/{Protheus.doc} maxitem
    (long_description)
    @type  Function
    @author user
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
static Function maxitem(cDoc)

Local aArea := GetArea()
Local cQuery 
Local cItem := ''

cQuery := "SELECT MAX(C1_ITEM) AS ITEM FROM "+RetSQLName("SC1")
cQuery += " WHERE C1_FILIAL='"+xfilial("SC1")+"' AND C1_NUM='"+cDoc+"' AND D_E_L_E_T_=' '"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB")

cItem := Strzero(Val(TRB->ITEM)+1,4)

RestArea(aArea)

Return(cItem)

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 29/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function qtditem(cDoc,cPrd)
    
Local aArea := GetArea()
Local cQuery 
Local cItem := ''

cQuery := "SELECT C1_QUANT FROM "+RetSQLName("SC1")
cQuery += " WHERE C1_FILIAL='"+xfilial("SC1")+"' AND C1_NUM='"+cDoc+"' AND C1_PRODUTO='"+cPrd+"' AND D_E_L_E_T_=' '"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB")

cItem := TRB->C1_QUANT

RestArea(aArea)

Return(cItem)

/*/{Protheus.doc} BuscaSolc
    (long_description)
    @type  Static Function
    @author user
    @since 29/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function BuscaSolc(cSolic,cProd,aAux)

Local cQuery 
Local nY 
Local aRet := {}

cQuery := "SELECT * FROM "+RetSQLName("SC1")
cQuery += " WHERE C1_FILIAL='"+xFilial("SC1")+"' AND C1_NUM='"+cSolic+"' AND D_E_L_E_T_=' '"
cQuery += " AND C1_PRODUTO='"+cProd+"'"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB")

While !EOF()
    For nY := 1 to len(aAux)
        If aAux[nY,2] == "N"
            cConteudo := &("TRB->"+aAux[nY,01])
        ElseIf aAux[nY,2] == "D"
            cConteudo := stod(&("TRB->"+aAux[nY,01]))
        Else 
            cConteudo := FwCutOff(&("TRB->"+aAux[nY,01]),.t.)
        EndIf

        Aadd(aRet,{aAux[nY,01],cConteudo})
    Next nY 
    exit
    Dbskip()
EndDo

Return(aRet)
