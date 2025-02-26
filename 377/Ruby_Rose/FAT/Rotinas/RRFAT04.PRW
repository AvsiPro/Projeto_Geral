#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} User Function RRFAT04
    (long_description)
    @type  Function
    @author user
    @since 29/04/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function RRFAT04(nOpc,cQem)

Local aArea :=  GetArea()
Local cRet 
Private nPosProd := Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_PRODUTO"})
Private nPosQVnd := Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_QTDVEN"})
Private nPosQSgn := Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_UNSVEN"})
Private nPosLot6 := Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_LOTECTL"})
Private nPosItem := Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_ITEM"})

If M->C5_TIPO == "N"
    //msgalert(aCols[n,npositem])
    //msgalert(cvaltochar(n))
    //cRet := xSldLoc(aCols[n,nPosProd],nOpc,cQem)
    cRet := SldLot(aCols[n,nPosProd],aCols[n,nPosQVnd],aCols[n,nPosQSgn],nOpc)
else
    If nOpc == 5
        cRet := aCols[n,nPosQVnd]
    ElseIf nOpc == 6
        cRet := aCols[n,nPosQSgn]
    EndIf 
EndIf 

RunTrigger(2,n,nil,,'C6_TES')

RestArea(aArea)

Return(cRet)

/*/{Protheus.doc} xSldLoc
    (long_description)
    @type  Static Function
    @author user
    @since 29/04/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function xSldLoc(cProduto,nOpc,cQem)

Local aArea := GetArea()
Local cQuery 
Local cRet 
Local lSaldo := .T.
Local cRastro := Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_RASTRO")
Local cFCIProd:= Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_ZFCICOD")
Local cSldPLt   := ''
Local cLotPrd   :=  ''
Local nCont     :=  0
Local cVirg     :=  ''
Default cQem    :=  ''


If len(aCols) > 1
    For nCont := 1 to len(aCols)
        If aCols[nCont,nPosProd] == cProduto
            cLotPrd += cVirg + Alltrim(aCols[nCont,nPosLot6])
            cVirg := "','"
        EndIf
    Next nCont 
ENDIF

//cQuery := "SELECT BF_LOCALIZ,BF_LOTECTL,BF_QUANT-BF_EMPENHO AS SALDO,BF_QTSEGUM-BF_EMPEN2 AS SALDO2,"
cQuery := "SELECT BF_LOCALIZ,BF_LOTECTL,B8_SALDO-B8_EMPENHO AS SALDO,B8_SALDO2-B8_EMPENH2 AS SALDO2,"
cQuery += " BF_DATAVEN,B8_DTVALID"
cQuery += " FROM "+RetSQLName("SBF")+" BF"
cQuery += " INNER JOIN "+RetSQLName("SB8")+" B8 ON B8_FILIAL=BF_FILIAL AND B8_PRODUTO=BF_PRODUTO AND B8.D_E_L_E_T_=' ' AND B8_LOTECTL=BF_LOTECTL"

If !Empty(cLotPrd)
    cQuery += " AND B8_LOTECTL NOT IN('"+cLotPrd+"')"
EndIf

cQuery += " WHERE BF_PRODUTO='"+cProduto+"' AND BF.D_E_L_E_T_=' '"
cQuery += " ORDER BY B8_DTVALID ASC"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB")

If nOpc == 1
    cRet := Space(TamSX3("C6_LOCALIZ")[1])
ElseIf nOpc == 2
    cRet := Space(TamSX3("C6_LOTECTL")[1])
ElseIf nOpc == 3
    cRet := 0
ElseIf nOpc == 4
    cRet := ''
ElseIf nOpc == 5
    cRet := If(cRastro<>"N",0,aCols[n,nPosQVnd])
ElseIf nOpc == 6
    cRet := 0
EndIf 

While !EOF()
    If nOpc == 6
        If val(cQem) == 1
            If aCols[n,nPosQSgn] <= TRB->SALDO2
                cRet := aCols[n,nPosQSgn]
                cSldPLt += 'Lote '+TRB->BF_LOTECTL+' Saldo 2un '+cvaltochar(TRB->SALDO2)+CRLF
                //lSaldo := .t.
            Else
                cRet := 0
                lSaldo := .F.
            EndIf 
        ElseIf val(cQem) == 2
            If aCols[n,nPosQSgn] <= TRB->SALDO2
                cRet := aCols[n,nPosQSgn] * SB1->B1_CONV
            Else
                cRet := 0
                lSaldo := .F.
            EndIf 
        ENDIF
    Else
        If aCols[n,nPosQVnd] <= TRB->SALDO
            
            If nOpc == 1
                cRet := TRB->BF_LOCALIZ
                exit
            ElseIf nOpc == 2
                cRet := TRB->BF_LOTECTL
                cSldPLt += 'Lote '+TRB->BF_LOTECTL+' Saldo '+cvaltochar(TRB->SALDO)+CRLF
                //exit
            ElseIf nOpc == 3
                cRet := aCols[n,nPosQVnd]
                exit 
            ElseIf nOpc == 4 .And. aCols[n,nPosLot6] == TRB->BF_LOTECTL
                cRet := 'Numero do lote '+Alltrim(TRB->BF_LOTECTL)+' validade '+cvaltochar(stod(TRB->B8_DTVALID))
                cRet += ' Codigo FCI '+cFCIProd
                exit
            ElseIf nOpc == 5 .And. aCols[n,nPosLot6] == TRB->BF_LOTECTL
                If val(cQem) == 1
                    cRet := aCols[n,nPosQVnd]
                    lSaldo := .T.
                ElseIf val(cQem) == 2
                    cRet := aCols[n,nPosQVnd] / SB1->B1_CONV
                    lSaldo := .T.
                EndIf 
                //exit
            EndIf 
        else
            If nOpc == 2
                cSldPLt += 'Lote '+TRB->BF_LOTECTL+' Saldo '+cvaltochar(TRB->SALDO)+CRLF
            ElseIf nOpc == 5
                cRet := 0
                lSaldo := .F.
                //exit
            EndIf 
        EndIf 
    EndIf 
    Dbskip()
EndDo 

If nOpc == 2 .And. !Empty(cSldPLt) .And. aCols[n,nPosQVnd] > 0
    MsgAlert("Verifique a necessidade de distribuição da quantidade deste produto em outras linhas conforme saldos por lote abaixo"+CRLF+cSldPLt)
endIf

If nPos == 6 .And. aCols[n,nPosQVnd] == 0
    aCols[n,nPosQSgn] := 0
    cRet := 0
EndIf 

If !lSaldo .And. nOpc >= 5 .And. cRastro <> 'N' .And. val(cQem) == 1
    MsgAlert("Produto sem saldo em estoque",'ultimo '+cQem)
EndIf 

RestArea(aArea)

Return(cRet)


user function xtstft4

Private aCols := {}
Private n := 1

Aadd(aCols,{1,1})
Aadd(aCols,{1,1})

If Empty(FunName())
	RpcSetType(3)
    RPCSetEnv("02","01")
EndIf	

SldLot('501',50,1)

return


/*/{Protheus.doc} SldLot
description)
    @type  Static Function
    @a
    @since 15/05/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function SldLot(cProduto,nQtd1,nQtd2,nOpc)

Local cQuery    :=  ""    
Local aAux      :=  {}
Local nCont     :=  0
Local cAux1     :=  ''
Local cAux2     :=  ''
Local cAux3     :=  ''
Local lSaldo    :=  .F.
Local cSaldo    :=  ''
//Local cRastro   :=  Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_RASTRO")
Local cFCIProd  :=  Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_ZFCICOD")
Local cRet  
Local cVirg     :=  ''
Local cLotPrd   :=  ''

//Private nPosProd := Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_PRODUTO"})
Private nPosQVnd := Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_QTDVEN"})
Private nPosQSgn := Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_UNSVEN"})
Private nPosLot6 := Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_LOTECTL"})
Private nPosInfA := Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_INFAD"})
Private nPosLocz := Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_LOCALIZ"})
Private nPosCF   := Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_CF"})
Private nPosTES  := Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_TES"})

If len(aCols) > 1
    For nCont := 1 to len(aCols)
        If aCols[nCont,nPosProd] == cProduto
            cLotPrd += cVirg + Alltrim(aCols[nCont,nPosLot6])
            cVirg := "','"
        EndIf
    Next nCont 
ENDIF

cQuery := "SELECT DISTINCT B8_DTVALID,B8_LOTECTL, B8_SALDO-B8_EMPENHO AS SALDO,B8_SALDO2-B8_EMPENH2 AS SALDO2,BF_LOCALIZ"
cQuery += " FROM "+RetSQLName("SB8")+" B8"
cQuery += " INNER JOIN "+RetSQLName("SBF")+" BF ON BF_FILIAL=B8_FILIAL AND BF_PRODUTO=B8_PRODUTO AND BF.D_E_L_E_T_=' '"
cQuery += " WHERE B8_FILIAL='"+xFilial("SB8")+"' AND B8_PRODUTO='"+cProduto+"' AND B8.D_E_L_E_T_=' '"

If !Empty(cLotPrd)
    cQuery += " AND B8_LOTECTL NOT IN('"+cLotPrd+"')"
EndIf

cQuery += " ORDER BY B8_DTVALID ASC"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB")

While !EOF()
    Aadd(aAux,{TRB->SALDO,TRB->SALDO2,TRB->B8_LOTECTL,TRB->BF_LOCALIZ,TRB->B8_DTVALID})
    Dbskip()
ENDDO

if len(aAux) < 1
    msgalert("Item já existente no pedido com o lote disponível ou não há saldo")
endif 

If nOpc == 1
    For nCont := 1 to len(aAux)
        cSaldo += aAux[nCont,03]+cvaltochar(aAux[nCont,01])+CRLF
        If nQtd1 <= aAux[nCont,01]
            cAux1 := aAux[nCont,03]
            cAux2 := aAux[nCont,04]
            cAux3 := aAux[nCont,05]
            lSaldo := .T.
            exit
        EndIf     
    Next nCont 
else
    For nCont := 1 to len(aAux)
        cSaldo += aAux[nCont,03]+cvaltochar(aAux[nCont,02])+CRLF
        If nQtd2 <= aAux[nCont,02]
            cAux1 := aAux[nCont,03]
            cAux2 := aAux[nCont,04]
            cAux3 := aAux[nCont,05]
            lSaldo := .T.
            exit
        EndIf     
    Next nCont
EndIf

If lSaldo
    
    If nOpc == 1
        aCols[n,nPosQSgn] := aCols[n,nPosQVnd] / SB1->B1_CONV
        cRet := aCols[n,nPosQVnd]
    Else
        aCols[n,nPosQVnd] := aCols[n,nPosQSgn] * SB1->B1_CONV
        cRet := aCols[n,nPosQSgn]
    EndIf 

    aCols[n,nPosLot6] := cAux1
    aCols[n,nPosLocz] := cAux2
    aCols[n,nPosInfA] := 'Numero do lote '+Alltrim(cAux1)+' validade '+cvaltochar(stod(cAux3))+CRLF+' Codigo FCI '+cFCIProd
    aCols[n,nPosCF]   := Posicione("SF4",1,xFilial("SF4")+aCols[n,nPosTES],"F4_CF")                
else
    If !Empty(cSaldo)
        MsgAlert("Produto sem saldo, distribua a quantidade de acordo com os saldos disponíveis nos lotes abaixo!"+CRLF+cSaldo)    
        aCols[n,nPosLot6] := space(TamSX3("C6_LOTECTL")[1])
        aCols[n,nPosLocz] := space(TamSX3("C6_LOCALIZ")[1])
        aCols[n,nPosCF]   := space(TamSX3("C6_CF")[1])
        aCols[n,nPosInfA] := ''
        If nOpc == 1
            aCols[n,nPosQSgn] := 0
        ELSE
            aCols[n,nPosQVnd] := 0
        ENDIF 
    else
        MsgAlert("Produto sem saldo")
    endif 
    cRet := 0
EndIf 

Return(cRet)
