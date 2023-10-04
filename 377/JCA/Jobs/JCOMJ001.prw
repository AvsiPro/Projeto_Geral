#INCLUDE 'PROTHEUS.CH'
/*
    Job que faz verificação de solicitações de compras perto da data de entrega
    MIT 44_COMPRAS COM013 _ Workflow Compradores - Solicitação de Compra

    Doc Mit
    https://docs.google.com/document/d/11M9mO4K4g0u4fKVXEKy0rUvwpnvDN1-m/edit
    Doc Entrega
    https://docs.google.com/document/d/1wMKXeqRVfl-fXWk7_09PjV39MBnOyTx0/edit
    
*/
User Function JCOMJ001

Local cQuery 
Local cArqHTML
Local oHtml
Local cPathHTML
Local nX,nY 
Local nDias
Local aAuxEnv     :=  {}
Private aAux      :=  {}
Private aCampos   :=  {}

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","00020087")
EndIf

cArqHTML    := "\workflow\Aviso_Compra.html"
cPathHTML   := GetMV("MV_WFDIR") 
nDias       := SUPERGETMV( "JC_DIASSC", .F., 2 )
    
sDiaRef := dtos(datavalida(ddatabase + nDias))

cQuery := "SELECT C1_FILIAL,C1_SCORI,C1_DATPRF,C1_ITSCORI,C1_FISCORI,'' AS C1_NOMCOMP,C1_APROV"  	 
cQuery += ",C1_CONDPAG,C1_VUNIT,'' AS C1_CODITE,'' AS C1_CODGRP,C1_SOLICIT,C1_ITEMPED"
cQuery += ",C1_PEDIDO,C1_LOJA,C1_FORNECE,C1_COTACAO,C1_EMISSAO,C1_LOCAL,C1_TOTAL,C1_PRECO"
cQuery += ",C1_QUANT,C1_DESCRI,C1_UM,C1_PRODUTO,C1_ITEM,C1_NUM"
cQuery += " FROM "+RetSQLName("SC1")
cQuery += " WHERE D_E_L_E_T_=' '"
cQuery += " AND C1_DATPRF='"+sDiaRef+"'"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("JCOMJ001.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

WHILE !EOF()
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
    
    For nX := 1 to len(aAux)
        If Ascan(aAuxEnv,{|x| x == aAux[nX,26]}) == 0
            Aadd(aAuxEnv,aAux[nX,26])
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

            cConteudo := linhassc(aAux[nX,26])
            oHTML:ValByName('linhasc',cConteudo)

            cFileName    := CriaTrab(NIL,.F.) + ".htm"
            cFileName    := cPathHTML + "\" + cFileName 
            oHtml:SaveFile(cFileName)
            
            cRet         := WFLoadFile(cFileName)
            cMensagem    := StrTran(cRet,chr(13),"")
            cMensagem    := StrTran(cRet,chr(10),"")
            cMensagem    := OemtoAnsi(cMensagem)
            
            cEmailTst := SUPERGETMV( "TI_EMAILTST", .F., "alexandre.venancio@avsipro.com.br" )
            //DEFINIR DESTINATARIO DE EMAIL DE ONDE VAI PEGAR
            U_JGENX002(cEmailTst,'Solicitação de compra empresa - '+FwCutOff(aAux[nX,27],.T.),cMensagem,'',.F.)
        EndIf
    Next nX 
EndIf

Return 

/*/{Protheus.doc} linhassc
    (long_description)
    @type  Static Function
    @author user
    @since 24/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function linhassc(cNumCot)

Local aArea := GetArea()
Local cRet  := ''
Local nCont := 1
Local cLinha := ''
Local nY 

cLinha := "<tr>"
cLinha += "	<td width=150><strong>!C1_LOCAL!</strong></td>"
cLinha += "	<td width=150><strong>!C1_ITEM!</strong></td>"
cLinha += "	<td width=150><strong>!C1_PRODUTO!</strong></td>
cLinha += "	<td width=350><strong>!C1_DESCRI!</strong></td>
cLinha += "	<td width=150><strong>!C1_QUANT!</strong></td>
cLinha += "	<td width=150><strong>!C1_PRECO!</strong></td>
cLinha += "	<td width=150><strong>!C1_TOTAL!</strong></td>
cLinha += "	<td width=150><strong>!C1_UM!</strong></td>
cLinha += "	<td width=150><strong>!C1_VUNIT!</strong></td>
cLinha += "	<td width=150><strong>!C1_ITEMPED!</strong></td>
cLinha += "	<td width=150><strong>!C1_PEDIDO!</strong></td>
cLinha += " </tr>"

For nCont := 1 to len(aAux)
    If aAux[nCont,26] == cNumCot
        cRet += cLinha
        For nY := 1 to len(aCampos[1])
            aAuxCmp := FWSX3Util():GetFieldStruct( FwCutOff(aCampos[1,nY]) )
            
            If aAuxCmp[2] == "N"
                cConteudo := Transform(aAux[nCont,nY],"@R 999,999,999.99")
            ElseIf aAuxCmp[2] == "D"
                cConteudo := cvaltochar(stod(aAux[nCont,nY]))
            Else 
                cConteudo := FwCutOff(aAux[nCont,nY],.t.)
            EndIf
            cRet := strtran(cRet,'!'+alltrim(aCampos[1,nY])+'!',cConteudo)
        Next nY 
    EndIf
Next nCont

RestArea(aArea)

Return(cRet)
