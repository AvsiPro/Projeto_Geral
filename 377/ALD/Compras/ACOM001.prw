#INCLUDE 'PROTHEUS.CH'

/*
    Inclusão de titulo do tipo AD quando pedido de compra gerado for selecionada a opção Gera AD = Sim
    MIT044 - P.C x AD
    @Autor - Alexandre Venâncio - 377
    15/12/2023   
    
*/
User Function ACOM001(nVlrTot,cCond,dDtEnt,nTipo)

Local aArea     :=  GetArea()
Local lRet      :=  .F.
Local nOpc      :=  0

Private oDlg1,oGrp1,oBtn1
Private aList1   :=  {}
Private oList1 
PRIVATE oOk        :=    LoadBitmap(GetResources(),'br_verde')  //Controla se o pedido foi alterado ou nao no grid.
PRIVATE oNo        :=    LoadBitmap(GetResources(),'br_vermelho')

If nTipo == 2
    U_ACOMD01(CA120NUM+'AD')
EndIf 

MontaList(cCond,nVlrTot,dDtEnt)


oDlg1      := MSDialog():New( 090,234,536,1060,"Titulo de Adiantamento ao Fornecedor",,,.F.,,,,,,.T.,,,.T. )

    oGrp1      := TGroup():New( 004,008,188,400,"Detalhamento",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{012,012,184,396},,, oGrp1 ) 
    oList1    := TCBrowse():New(012,012,385,170,, {'Parcela','Valor','%','Vencimento','Flag'},;
                                        {80,100,70,80,40},;
                                        oGrp1,,,,{|| /*FHelp(oList1:nAt)*/},{|| editped(oList1:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,)
    oList1:SetArray(aList1)
    oList1:bLine := {||{aList1[oList1:nAt,01],; 
                        Transform(aList1[oList1:nAt,02],"@E 999,999,999.99"),;
                        aList1[oList1:nAt,03],;
                        aList1[oList1:nAt,04],;
                        iF(aList1[oList1:nAt,05],oOk,oNo)}}

    oBtn1      := TButton():New( 196,176,"Confirmar",oDlg1,{||oDlg1:end(nOpc:=1)},037,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

If nOpc == 1
    lRet := GeraTit()
EndIf 

RestArea(aArea)

Return(lRet)

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 19/12/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function editped(nLinha)

Local nPosic := oList1:nColPos
Local nSmTot := 0
Local nItens := len(aList1)-1
Local nX 
Local nSmGer := 0
Local lParZr := .F.
Local nMark  := 0
Local nSomaPc := 0
Local nPos1  := Ascan(aHeader,{|x| Alltrim(x[2]) == "C7_TOTAL"})


Aeval(aCols,{|x| nSomaPc += x[nPos1] })

If nPosic == 2  
    /*For nX := 1 to len(aList1)
        If aList1[nX,05]
            nMark++
        EndIf 
    Next nX 

    nMark := nMark-1*/

    //Aeval(aList1,{|x| nSmTot += x[2]})

    lEditCell(aList1,oList1,"@E 999,999,999.99",2)

    aList1[nLinha,03] := (aList1[nLinha,02]/nSomaPc)*100

    /*
    aList1[nLinha,03] := (aList1[nLinha,02]/nSmTot)*100

    nDividir := (nSmTot - aList1[nLinha,02]) / nMark //nItens

    nSldPrc := round((100 - aList1[nLinha,3]) / nMark,2) //nItens

    For nX := 1 to len(aList1)
        If nX <> nLinha
            aList1[nX,02] := round(nSmTot * (nSldPrc / 100),2)  
            aList1[nX,03] := nSldPrc
        ENDIF
    Next nX 
    
    Aeval(aList1,{|x| nSmGer += If(x[3]>0,x[3],0)})
    
    For nX := 1 to len(aList1)
        If aList1[nX,03] == 0 .And. aList1[nX,05]
            lParZr := .T.
            EXIT
        EndIf 
    Next nX 

    /*If nSmGer <> 100 .Or. lParZr
        MsgAlert("Soma total não bate ou alguma parcela ficou zerada, favor conferir")
        oBtn1:disable()
    Else 
        oBtn1:enable()
    EndIf */
    oBtn1:enable()

ElseIf nPosic == 3  

    /*For nX := 1 to len(aList1)
        If aList1[nX,05]
            nMark++
        EndIf 
    Next nX 

    nMark := nMark-1

    Aeval(aList1,{|x| nSmTot += x[2]})*/

    lEditCell(aList1,oList1,"@E 999",3)

    aList1[nLinha,02] := round(nSomaPc * (aList1[nLinha,03] /100),2)

    /*aList1[nLinha,02] := round(nSmTot * (aList1[nLinha,03] /100),2)

    nDividir := (nSmTot - aList1[nLinha,02]) / nMark //nItens

    nSldPrc := round((100 - aList1[nLinha,3]) / nMark,2) //nItens

    For nX := 1 to len(aList1)
        If nX <> nLinha .And. aList1[nX,05]
            aList1[nX,02] := round(nSmTot * (nSldPrc / 100),2)  
            aList1[nX,03] := nSldPrc
        ENDIF
    Next nX 
    
    Aeval(aList1,{|x| nSmGer += If(x[3]>0,x[3],0)})
    
    For nX := 1 to len(aList1)
        If aList1[nX,03] == 0 .And. aList1[nX,05]
            lParZr := .T.
            EXIT
        EndIf 
    Next nX

    /*If nSmGer <> 100 .Or. lParZr
        MsgAlert("Soma total não bate ou alguma parcela ficou zerada, favor conferir")
        oBtn1:disable()
    Else 
        oBtn1:enable()
    EndIf */

    oBtn1:enable()
    
ElseIf nPosic == 5
    Aeval(aList1,{|x| nSmTot += x[2]})

    If aList1[nLinha,5]
        aList1[nLinha,5] := .F.
    Else 
        aList1[nLinha,5] := .T.
    EndIf 

    For nX := 1 to len(aList1)
        If aList1[nX,05]
            nMark++
        Else 
            aList1[nX,02] := 0
            aList1[nX,03] := 0
        EndIf 
    Next nX 

    nPercNew := round(100 / nMark,2)

    For nX := 1 to len(aList1)
        If aList1[nX,05]
            aList1[nX,02] := nSomaPc * (nPercNew / 100)  
            aList1[nX,03] := nPercNew
        EndIF 
    Next nX 
EndIf 

oList1:refresh()
oDlg1:refresh()

Return

/*/{Protheus.doc} MontaList
    (long_description)
    @type  Static Function
    @author user
    @since 19/12/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function MontaList(cCond,nVlr,dDtEnt)

Local aAux := {}
Local nX   := 0
Local nDif := 0
Local nDifP:= 0
Local nSoma:= 0
Local nToPr:= 0

DbSelectArea("SE4")
DbSetOrder(1)
If Dbseek(xFilial("SE4")+cCond)
    If SE4->E4_TIPO == "1"
        aAux := separa(SE4->E4_COND,",")
    EndIf 

    For nX := 1 to len(aAux)
        Aadd(aList1,{strzero(nX,2),round(nVlr/len(aAux),2),round(100/len(aAux),2),dDtEnt+val(aAux[nX]),.T.})
    Next nX 

    Aeval(aList1,{|x| nSoma+= x[2]})
    Aeval(aList1,{|x| nToPr+= x[3]})

    nDif := nVlr - nSoma
    nDifP := 100 - nToPr

    If nDif > 0
        aList1[len(aList1),02] += nDif
        aList1[len(aList1),03] += nDifP
    EndIf 
EndIf 

Return

/*/{Protheus.doc} GeraTit
    (long_description)
    @type  Static Function
    @author user
    @since 19/12/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function GeraTit()

Local aArea :=  GetArea()
Local lRet  :=  .T.
Local aVetSE2 := {}
Local nX 
Local cPrefixo  :=  SuperGetMV("TI_PRFADT",.F.,"ADT")
Local cTipo     :=  SuperGetMV("TI_TIPADT",.F.,"AD")
Local cNatureza :=  SuperGetMV("TI_NATADT",.F.,"21802")
Local cNatForn  :=  Posicione("SA2",1,xFilial("SA2")+CA120FORN+CA120LOJ,"A2_NATUREZ")
Local cHist     :=  CUSERNAME+" - "+cvaltochar(ddatabase)+" - "+cvaltochar(time())  

For nX := 1 to len(aList1)
    If aList1[nX,05]
        aVetSE2 := {}
        aAdd(aVetSE2, {"E2_FILIAL",  CFILANT            ,  Nil})
        aAdd(aVetSE2, {"E2_NUM",     CA120NUM+'AD'      ,  Nil})
        aAdd(aVetSE2, {"E2_PREFIXO", cPrefixo           ,  Nil})
        aAdd(aVetSE2, {"E2_PARCELA", aList1[nX,01]      ,  Nil})
        aAdd(aVetSE2, {"E2_TIPO",    cTipo              ,  Nil})
        aAdd(aVetSE2, {"E2_NATUREZ", If(!Empty(cNatForn),cNatForn,cNatureza)    ,  Nil})
        aAdd(aVetSE2, {"E2_FORNECE", CA120FORN          ,  Nil})
        aAdd(aVetSE2, {"E2_LOJA",    CA120LOJ           ,  Nil})
        //aAdd(aVetSE2, {"E2_NOMFOR",  cNomFor,           Nil})
        aAdd(aVetSE2, {"E2_EMISSAO", DA120EMIS          ,  Nil})
        aAdd(aVetSE2, {"E2_VENCTO",  aList1[nX,04]      ,  Nil})
        aAdd(aVetSE2, {"E2_VENCREA", Datavalida(aList1[nX,04])                  ,  Nil})
        aAdd(aVetSE2, {"E2_VALOR",   aList1[nX,02]      ,  Nil})
        aAdd(aVetSE2, {"E2_CC"   ,   SC7->C7_CC         ,  Nil})
        aAdd(aVetSE2, {"E2_HIST",    cHist              ,  Nil})
        aAdd(aVetSE2, {"E2_MOEDA",   1                  ,  Nil})
        
        //Inicia o controle de transação
        Begin Transaction
        //Chama a rotina automática
        lMsErroAuto := .F.
        MSExecAuto({|x,y| FINA050(x,y)}, aVetSE2, 3)
        
        //Se houve erro, mostra o erro ao usuário e desarma a transação
        If lMsErroAuto
            lRet := .F.
            MostraErro()
            DisarmTransaction()
        EndIf
        //Finaliza a transação
        End Transaction
    EndIf 
Next nX 

RestArea(aArea)

Return(lRet)

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
User Function ACOMD01(cPedido)

Local aArea     :=  GetArea()
Local cPrefixo  :=  SuperGetMV("TI_PRFADT",.F.,"ADT")

DbSelectArea("SE2")
DbSetOrder(1)
If Dbseek(cfilant+Avkey(cPrefixo,"E2_PREFIXO")+cPedido)
    While !EOF() .AND. SE2->E2_FILIAL == cfilant .AND. SE2->E2_PREFIXO == cPrefixo .AND. SE2->E2_NUM == Avkey(cPedido,"E2_NUM")
        Reclock("SE2",.F.)
        SE2->(Dbdelete())
        SE2->(Msunlock())
        Dbskip()
    EndDo
EndIf 

RestArea(aArea)

Return
