#INCLUDE 'PROTHEUS.CH'

User Function JCAJOB02

Local cQuery 
Local aAux      :=  {}
Local aAuxIt    :=  {}
Local aCmpCab   :=  {}
Local cArqHTML

Local cPathHTML
Local nX,nY 
Local nDias
Local cPedAtu   :=  ''
Local aItens    :=  {}

Private oHtml

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","00020087")
EndIf

cArqHTML    := "\workflow\Aviso_Compra_Fornecedor.html"
cPathHTML   := GetMV("MV_WFDIR") 
nDias       := SUPERGETMV( "JC_DIASPC", .F., 2 )
    
sDiaRef := dtos(ddatabase + nDias)

cQuery := "SELECT DISTINCT C7_FILIAL,C7_EMISSAO,C7_FORNECE,A2_NREDUZ,C7_LOJA,C7_DATPRF,C7_NUM,"
cQuery += "C7_ITEM,C7_PRODUTO,C7_QUANT,C7_PRECO,C7_TOTAL,B1_DESC"  	 
cQuery += " FROM "+RetSQLName("SC7")+" SC7"
cQuery += " INNER JOIN "+RetSQLName("SCR")+" SCR ON SCR.CR_FILIAL =  SC7.C7_FILIAL"
cQuery += " AND SCR.CR_NUM = SC7.C7_NUM AND SCR.CR_TIPO   =  'PC' AND SCR.D_E_L_E_T_=' ' AND CR_LIBAPRO<>' '"
cQuery += " INNER JOIN "+RetSQLName("SA2")+" A2 ON A2_FILIAL='"+xFilial("SA2")+"' AND A2_COD=C7_FORNECE AND A2_LOJA=C7_LOJA AND A2.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=C7_PRODUTO AND B1.D_E_L_E_T_=' '"
cQuery += " WHERE SC7.D_E_L_E_T_=' '"
//cQuery += " AND C7_DATPRF='"+sDiaRef+"'"
cQuery += " AND C7_QUJE<C7_QUANT AND C7_CONAPRO<>'B'"
cQuery += " ORDER BY C7_NUM,C7_ITEM"
                     
IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("JCAJOB02.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

WHILE !EOF()
//C7_EMISSAO,C7_FORNECE,A2_NREDUZ,C7_LOJA,C7_DATPRF,C7_NUM,C7_ITEM,C7_PRODUTO,C7_QUANT,C7_PRECO,C7_TOTAL
    If Empty(cPedAtu)
        cPedAtu := TRB->C7_NUM
    EndIf 

    Aadd(aAux,{ TRB->C7_EMISSAO,;
                TRB->C7_DATPRF,;
                TRB->C7_FORNECE,;
                TRB->C7_LOJA,;
                TRB->A2_NREDUZ,;
                TRB->C7_NUM,;
                FWFilialName('01',TRB->C7_FILIAL),;
                TRB->C7_FILIAL})

    Aadd(aAuxIt,{TRB->C7_ITEM,;
                TRB->C7_PRODUTO+'-'+Alltrim(TRB->B1_DESC),;
                TRB->C7_QUANT,;
                TRB->C7_PRECO,;
                TRB->C7_TOTAL,;
                TRB->C7_NUM,;
                TRB->C7_FILIAL})
    Dbskip()
EndDo

If len(aAux) > 0
    Aadd(aCmpCab,"C7_EMISSAO")
    Aadd(aCmpCab,"C7_DATPRF")
    Aadd(aCmpCab,"C7_FORNECE")
    Aadd(aCmpCab,"C7_LOJA")
    Aadd(aCmpCab,"A2_NREDUZ")
    Aadd(aCmpCab,"C7_NUM")

    Aadd(aItens,{   "C7_ITEM",;
                    "C7_PRODUTO",;
                    "C7_QUANT",;
                    "C7_PRECO",;
                    "C7_TOTAL"})

    //JCAMAIL1(cFrom,cTo,cSubject,cBody,aAttach,lConfirm,cCC,cBCC)
    //JCAMAIL2(cPara,cAssunto,cBody,cAtach,lLog)
    For nX := 1 to len(aAux)
        
        oHtml := TWFHtml():New( cArqHTML )
        
        For nY := 1 to len(aCmpCab)
            aAuxCmp := FWSX3Util():GetFieldStruct( FwCutOff(aCmpCab[nY]) )
            
            If aAuxCmp[2] == "N"
                cConteudo := Transform(aAux[nX,nY],"@R 999,999,999.99")
            ElseIf aAuxCmp[2] == "D"
                cConteudo := cvaltochar(stod(aAux[nX,nY]))
            Else 
                cConteudo := FwCutOff(aAux[nX,nY],.t.)
            EndIf
            oHTML:ValByName(aCmpCab[nY],cConteudo)
        Next nY 
        
        cConteudo := ''
        For nY := 1 to len(aItens)
            cConteudo := Buscalinha(aItens,aAuxIt,aAux[nX,06])
        Next nY

        oHTML:ValByName("linhasPedido",cConteudo)

        cFileName    := CriaTrab(NIL,.F.) + ".htm"
        cFileName    := cPathHTML + "\" + cFileName 
        oHtml:SaveFile(cFileName)
        
        cRet         := WFLoadFile(cFileName)
        cMensagem    := StrTran(cRet,chr(13),"")
        cMensagem    := StrTran(cRet,chr(10),"")
        cMensagem    := OemtoAnsi(cMensagem)
        
        U_JCAMAIL2('alexandre.venancio@avsipro.com.br','Solicitação de compra empresa - '+FwCutOff(aAux[nX,05],.T.)+' '+FwCutOff(aAux[nX,07],.T.),cMensagem,'',.F.)
    Next nX 
EndIf

Return

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 06/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Buscalinha(aArray,aArray2,cPedido)

Local aArea := GetArea()
Local nCont1 := 0
Local cRet   := ''
Local nCont2 := 0
Local cLinha := ''
Local cConteudo := ''

cRet := '<tr>'     
cRet += '    <td width=050><strong>!C7_ITEM!</strong></td>'
cRet += '    <td width=150><strong>!C7_PRODUTO!</strong></td>'
cRet += '    <td width=100 align=right><strong>!C7_QUANT!</strong></td>'
cRet += '    <td width=100 align=right><strong>!C7_PRECO!</strong></td>'
cRet += '    <td width=100 align=right><strong>!C7_TOTAL!</strong></td>'
cRet += '</tr>'

For nCont1 := 1 to len(aArray2)
    If aArray2[nCont1,06] == cPedido
        cLinha += cRet
        For nCont2 := 1 to len(aArray[1])
            aAuxCmp := FWSX3Util():GetFieldStruct( FwCutOff(aArray[1,nCont2]) )
            
            If aAuxCmp[2] == "N"
                cConteudo := Transform(aArray2[nCont1,nCont2],"@R 999,999,999.99")
            ElseIf aAuxCmp[2] == "D"
                cConteudo := cvaltochar(stod(aArray2[nCont1,nCont2]))
            Else 
                cConteudo := FwCutOff(aArray2[nCont1,nCont2],.t.)
            EndIf
            cLinha := strtran(cLinha,"!"+aArray[1,nCont2]+"!",cConteudo)
        Next nCont2 
    EndIf
Next nCont1

RestArea(aArea)

Return(cLinha)
