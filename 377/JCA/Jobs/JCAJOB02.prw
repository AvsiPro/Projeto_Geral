#INCLUDE 'PROTHEUS.CH'

User Function JCAJOB01

Local cQuery 
Local aAux      :=  {}
Local aCampos   :=  {}
Local cArqHTML
Local oHtml
Local cPathHTML
Local nX,nY 
Local nDias

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","00020087")
EndIf

cArqHTML    := "\workflow\Aviso_Compra_Fornecedor.html"
cPathHTML   := GetMV("MV_WFDIR") 
nDias       := SUPERGETMV( "JC_DIASPC", .F., 2 )
    
sDiaRef := dtos(ddatabase + nDias)

cQuery := "SELECT DISTINCT C7_EMISSAO,C7_FORNECE,A2_NREDUZ,C7_LOJA,C7_DATPRF,C7_NUM,"
cQuery += "C7_ITEM,C7_PRODUTO,C7_QUANT,C7_PRECO,C7_TOTAL"  	 
cQuery += " FROM "+RetSQLName("SC7")+" SC7"
cQuery += " INNER JOIN "+RetSQLName("SCR")+" SCR ON SCR.CR_FILIAL =  SC7.C7_FILIAL"
cQuery += " AND SCR.CR_NUM = SC7.C7_NUM AND SCR.CR_TIPO   =  'PC' AND SCR.D_E_L_E_T_=' ' AND CR_LIBAPRO<>' '"
cQuery += " INNER JOIN "+RetSQLName("SA2")+" A2 ON A2_FILIAL='"+xFilial("SA2")+"' AND A2_COD=C7_FORNECE AND A2_LOJA=C7_LOJA AND A2.D_E_L_E_T_=' '"
cQuery += " WHERE SC7.D_E_L_E_T_=' '"
cQuery += " AND C1_DATPRF='"+sDiaRef+"'"
cQuery += " AND C7_QUJE<C7_QUANT AND C7_CONAPRO<>'B'"
                     
IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("JCAJOB02.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

WHILE !EOF()
//C7_EMISSAO,C7_FORNECE,A2_NREDUZ,C7_LOJA,C7_DATPRF,C7_NUM,C7_ITEM,C7_PRODUTO,C7_QUANT,C7_PRECO,C7_TOTAL
    Aadd(aAux,{ TRB->C1_SCORI,;
                TRB->C1_DATPRF,;
                TRB->C1_ITSCORI,;
                TRB->C1_FISCORI,;
                TRB->C1_NOMCOMP,;
                TRB->C1_APROV,;
                TRB->C1_CONDPAG,;
                TRB->C1_VUNIT,;
                TRB->C1_CODITE,;
                TRB->C1_CODGRP,;
                TRB->C1_SOLICIT,;
                TRB->C1_ITEMPED,;
                TRB->C1_PEDIDO,;
                TRB->C1_LOJA,;
                TRB->C1_FORNECE,;
                TRB->C1_COTACAO,;
                TRB->C1_EMISSAO,;
                TRB->C1_LOCAL,;
                TRB->C1_TOTAL,;
                TRB->C1_PRECO,;
                TRB->C1_QUANT,;
                TRB->C1_DESCRI,;
                TRB->C1_UM,;
                TRB->C1_PRODUTO,;
                TRB->C1_ITEM,;
                TRB->C1_NUM,;
                FWFilialName('01',TRB->C1_FILIAL)})
    Dbskip()
EndDo

If len(aAux) > 0
    Aadd(aCampos,{  "C1_SCORI",;
                    "C1_DATPRF",;
                    "C1_ITSCORI",;
                    "C1_FISCORI",;
                    "C1_NOMCOMP",;
                    "C1_APROV",;
                    "C1_CONDPAG",;
                    "C1_VUNIT",;
                    "C1_CODITE",;
                    "C1_CODGRP",;
                    "C1_SOLICIT",;
                    "C1_ITEMPED",;
                    "C1_PEDIDO",;
                    "C1_LOJA",;
                    "C1_FORNECE",;
                    "C1_COTACAO",;
                    "C1_EMISSAO",;
                    "C1_LOCAL",;
                    "C1_TOTAL",;
                    "C1_PRECO",;
                    "C1_QUANT",;
                    "C1_DESCRI",;
                    "C1_UM",;
                    "C1_PRODUTO",;
                    "C1_ITEM",;
                    "C1_NUM"})
    //JCAMAIL1(cFrom,cTo,cSubject,cBody,aAttach,lConfirm,cCC,cBCC)
    //JCAMAIL2(cPara,cAssunto,cBody,cAtach,lLog)
    For nX := 1 to len(aAux)
        oHtml := TWFHtml():New( cArqHTML )
        
        For nY := 1 to len(aCampos[1])
            aAuxCmp := FWSX3Util():GetFieldStruct( FwCutOff(aCampos[1,nY]) )
            
            If aAuxCmp[2] == "N"
                cConteudo := Transform(aAux[nX,nY],"@R 999,999,999.99")
            ElseIf aAuxCmp[2] == "D"
                cConteudo := cvaltochar(stod(aAux[nX,nY]))
            Else 
                cConteudo := FwCutOff(aAux[nX,nY],.t.)
            EndIf
            oHTML:ValByName(aCampos[1,nY],cConteudo)
        Next nY 

        cFileName    := CriaTrab(NIL,.F.) + ".htm"
        cFileName    := cPathHTML + "\" + cFileName 
        oHtml:SaveFile(cFileName)
        
        cRet         := WFLoadFile(cFileName)
        cMensagem    := StrTran(cRet,chr(13),"")
        cMensagem    := StrTran(cRet,chr(10),"")
        cMensagem    := OemtoAnsi(cMensagem)
        
        U_JCAMAIL2('alexandre.venancio@avsipro.com.br','Solicitação de compra empresa - '+FwCutOff(aAux[nX,27],.T.),cMensagem,'',.F.)
    Next nX 
EndIf

Return
