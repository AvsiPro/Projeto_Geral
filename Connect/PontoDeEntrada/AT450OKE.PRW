#INCLUDE "PROTHEUS.CH"

User Function AT450OKE()

    if AB8->AB8_CODSER == "000003"
        geraDE()
    endif

Return 

Static Function geraDE()

    Local aCab      := {}
    Local aItem     := {}
    Local aItens    := {}
    Local aItensRat := {}
    Local aCodRet   := {}
    Local aAux      := {}
    Local nOpc      := 3
    Local cNum      := ""
    // Local nI := 0
    Local nX        := 0
    // Local nReg := 1

    Private lMsErroAuto := .F.
    Private lMsHelpAuto := .T.

    for nX := 1 to len(aList2)
        if aList2[nX,1]
            Aadd(aAux, aList2[nX])
        endif
    next

    for nX := 1 to len(aList3)
        if aList3[nX,1]
            Aadd(aAux, aList3[nX])
        endif
    next

    cNum := GetSxeNum("SF1","F1_DOC")
    SF1->(dbSetOrder(1))
    While SF1->(dbSeek(xFilial("SF1")+cNum))
        ConfirmSX8()
        cNum := GetSxeNum("SF1","F1_DOC")
    EndDo

    //Cabeçalho
    aadd( aCab,{"F1_TIPO"    ,"B"                     ,NIL} )
    aadd( aCab,{"F1_FORMUL"  ,"S"                     ,NIL} )
    aadd( aCab,{"F1_DOC"     ,cNum                    ,NIL} )
    aadd( aCab,{"F1_SERIE"   ,"1 "                    ,NIL} )
    aadd( aCab,{"F1_EMISSAO" ,DDATABASE               ,NIL} )
    aadd( aCab,{"F1_DTDIGIT" ,DDATABASE               ,NIL} )
    aadd( aCab,{"F1_FORNECE" ,aAux[1,6]               ,NIL} )
    aadd( aCab,{"F1_LOJA"    ,aAux[1,7]              ,NIL} )
    aadd( aCab,{"F1_ESPECIE" ,"SPED"                  ,NIL} )
    // aadd( aCab,{"F1_COND"    ,"001"                  ,NIL} )
    // aadd( aCab,{"F1_DESPESA" ,10                     ,NIL} )
    // aadd( aCab,{"F1_DESCONT" , 0                     ,Nil} )
    // aadd( aCab,{"F1_SEGURO"  , 0                     ,Nil} )
    // aadd( aCab,{"F1_FRETE"   , 0                     ,Nil} )
    aadd( aCab,{"F1_MOEDA"   ,1                       ,Nil} )
    // aadd( aCab,{"F1_TXMOEDA" , 1                     ,Nil} )
    aadd( aCab,{"F1_STATUS"  ,"A"                     ,Nil} )

    //Itens
    For nX := 2 To len(aAux)

        aItem := {}
        aadd( aItem,{"D1_ITEM"       ,StrZero(nX - 1,4)       ,NIL} )
        aadd( aItem,{"D1_COD"        ,aAux[nX,02]             ,NIL} )
        aadd( aItem,{"D1_UM"         ,aAux[nX,11]             ,NIL} )
        aadd( aItem,{"D1_LOCAL"      ,aAux[nX,08]             ,NIL} )
        aadd( aItem,{"D1_QUANT"      ,aAux[nX,04]             ,NIL} )
        aadd( aItem,{"D1_VUNIT"      ,aAux[nX,06]             ,NIL} )
        aadd( aItem,{"D1_TOTAL"      ,aAux[nX,06]             ,NIL} )
        aadd( aItem,{"D1_TES"        ,"131"                   ,NIL} )
        aadd( aItem,{"D1_NFORI"      ,aAux[nX,09]             ,NIL} )
        aadd( aItem,{"D1_SERIORI"    ,aAux[nX,12]             ,NIL} )
        aadd( aItem,{"D1_ITEMORI"    ,aAux[nX,13]             ,NIL} )
        aadd( aItem,{"D1_IDENTB6"    ,aAux[nX,14]             ,NIL} )
        // aadd( aItem,{"D1_QTDEDEV"    ,aAux[nX,04]             ,NIL} )
        // aadd( aItem,{"D1_VALDEV"     ,aAux[nX,06]             ,NIL} )
        // aadd( aItem,{"D1_RATEIO" ,"2"               ,NIL} )
        aAdd( aItens, aItem )
        
    Next nX

    //Rateio de Centro de Custo
    aItem := {}
    aAdd( aItensRat, Array(2) )
    aItensRat[Len(aItensRat)][1] := "0001"
    aItensRat[Len(aItensRat)][2] := {}

    aAdd( aItem,{"DE_FILIAL"  ,xFilial("SDE")                  ,Nil} )
    aAdd( aItem,{"DE_ITEM"    ,StrZero(1,TamSx3("DE_ITEM")[1]) ,Nil} )
    aAdd( aItem,{"DE_DOC"     ,cNum                            ,Nil} )
    aAdd( aItem,{"DE_SERIE"   ,"1"                             ,Nil} )
    aAdd( aItem,{"DE_FORNECE" ,"001 "                          ,Nil} )
    aAdd( aItem,{"DE_LOJA"    ,"01"                            ,Nil} )
    aAdd( aItem,{"DE_ITEMNF"  ,"0001"                          ,Nil} )
    aAdd( aItem,{"DE_PERC"    ,100                             ,Nil} )
    aAdd( aItem,{"DE_CC"      ,"01"                            ,Nil} )
    aAdd( aItensRat[Len(aItensRat)][2], aClone(aItem) )

    //Array contendo a informação se gera DIRF e os códigos de retenção por imposto
    aAdd( aCodRet,{01 ,"0297" ,1 ,"..."} )
    aAdd( aCodRet,{02 ,"0297" ,1 ,"IRR"} )
    aAdd( aCodRet,{03 ,"5979" ,1 ,"PIS"} )
    aAdd( aCodRet,{04 ,"5960" ,1 ,"COF"} )
    aAdd( aCodRet,{05 ,"5987" ,1 ,"CSL"} )

    //3-Inclusão / 4-Classificação / 5-Exclusão
    MSExecAuto({|x,y,z,a,b| MATA103(x,y,z,,,,,/*a*/,,,/*b*/)},aCab,aItens,nOpc,/*aItensRat*/,/*aCodRet*/)
    // MSExecAuto({|x,y,z,a,b| MATA140(x,y,z,,,,,/*a*/,,,/*b*/)},aCab,aItens,nOpc,/*aItensRat*/,/*aCodRet*/)

    If !lMsErroAuto
        MsgInfo("Incluido NF: " + cNum, "Informa")
    Else
        MostraErro()
        RollBackSX8()
        MsgAlert("Erro ao incluir nota", "Erro")
    EndIf

Return
