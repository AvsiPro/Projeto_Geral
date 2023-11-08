#INCLUDE "PROTHEUS.CH"

User Function MT161OK()

Local lRetPE    := .T.
Local aPropPE   := PARAMIXB[1]
//Local cTpDocPE  := PARAMIXB[2]
Local nCont1    := 1
Local nCont2    := 1
Local nCont3    := 1
Local nCont4    := 1
Local nCont5    := 1
Local aAux      := {}
Local aAux2     := {}
Local aDados    := {}
Local lCotOk    := .t. //valc1qtd(SC8->C8_NUM)
Local aItensV   := {}

If lCotOk
    //Primeiro são as paginas da tela de propostas
    For nCont1 := 1 to len(aPropPE)
        //Segundo são os itens de cada proposta
        For nCont2 := 1 to len(aPropPE[nCont1])
            aAux := {}
            For nCont3 := 1 to len(aPropPE[nCont1][nCont2])
                If len(aPropPE[nCont1][nCont2][nCont3]) > 0
                    If valtype(aPropPE[nCont1][nCont2][nCont3][1]) == "C"
                        For nCont4 := 1 to len(aPropPE[nCont1][nCont2][nCont3])
                            Aadd(aAux,aPropPE[nCont1][nCont2][nCont3][nCont4])
                        Next nCont4
                    Else 
                        For nCont4 := 1 to len(aPropPE[nCont1][nCont2][nCont3])
                            aAux2 := {}
                            For nCont5 := 1 to len(aPropPE[nCont1][nCont2][nCont3][nCont4])
                                Aadd(aAux2,aPropPE[nCont1][nCont2][nCont3][nCont4][nCont5])
                            Next nCont5
                            Aadd(aAux,aAux2)
                        Next nCont4
                    EndIf
                EndIf
            Next nCont3
            Aadd(aDados,aAux)
        Next nCont2
    Next nCont1

    For nCont1 := 1 to len(aDados)
        For nCont2 := 1 to len(aDados[nCont1])
            If Valtype(aDados[nCont1,nCont2]) == "A"
                //For nCont3 := 1 to len(aDados[nCont1][nCont2])
                    If aDados[nCont1,nCont2,1]
                        Aadd(aItensV,{  aDados[nCont1,nCont2,3],;
                                        aDados[nCont1,nCont2,4],;
                                        aDados[nCont1,nCont2,13],;
                                        round(aDados[nCont1,nCont2,4] / aDados[nCont1,nCont2,13],0)})
                    EndIf 
                //Next nCont3
            EndIf 
        Next nCont2 
    Next nCont1

    If len(aItensV) > 0
        
        lCotOk := valc1qtd(SC8->C8_NUM,aItensV)
        If lCotOk
            gravar(aDados)
        Else 
            lRetPE := lCotOk
        EndIf 
    EndIf
EndIf 

Return lRetPE

//CABEÇALHO DA PROPOSTA//
//aArray[n]         : Número da página
//aArray[n,p]       : Posição do pedido na página (1,2)
//aArray[n,p,1,x]   : Dados do cabeçalho da proposta 
//aArray[n,p,1,1 ]  : Cod Fornecedor 
//aArray[n,p,1,2 ]  : Loja 
//aArray[n,p,1,3 ]  : Nome 
//aArray[n,p,1,4 ]  : Proposta 
//aArray[n,p,1,5 ]  : Condição de pagamento 
//aArray[n,p,1,6 ]  : Frete 
//aArray[n,p,1,7 ]  : Valor total da proposta


//ITENS DA PROPOSTA// 
//aArray[n,p,2,x]       : Itens da proposta 
//aArray[n,p,2,x,1]     : Flag vencedor normal
//aArray[n,p,2,x,2]     : Item da cotação (C8_ITEM)
//aArray[n,p,2,x,3]     : Código do produto 
//aArray[n,p,2,x,4]     : Valor total
//aArray[n,p,2,x,5]     : Data de entrega
//aArray[n,p,2,x,6]     : Observações (C8_OBS)
//aArray[n,p,2,x,7]     : Filial Entrega (C8_FILENT)
//aArray[n,p,2,x,8]     : Flag finalizado 
//aArray[n,p,2,x,9]     : Recno SC8 
//aArray[n,p,2,x,10]    : Identificador (C8_IDENT)
//aArray[n,p,2,x,11]    : Total de Itens da Cotação
//aArray[n,p,2,x,12]    : Numero da Proposta (SC8->C8_NUMPRO)
//aArray[n,p,2,x,13]    : Preco Unitario (SC8->C8_PRECO)
//aArray[n,p,2,x,14]    : Flag vencedor auditoria

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 09/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function gravar(aDados)

Local aArea :=  GetArea()
Local nCont :=  1
Local nCont2:=  1

DbSelectArea("ZPS")

For nCont := 1 to len(aDados)
    If len(aDados[nCont]) > 2
        For nCont2 := 8 to len(aDados[nCont])
            Reclock("ZPS",.T.)
            //ZPS->ZPS_CODIGO := GetSXENum("ZPS","ZPS_CODIGO")
            ZPS->ZPS_COTACA := SC8->C8_NUM
            ZPS->ZPS_FORNEC := aDados[nCont,01]
            ZPS->ZPS_LOJA   := aDados[nCont,02]
            ZPS->ZPS_CONDPG := aDados[nCont,05]
            ZPS->ZPS_FRETE  := aDados[nCont,06]
            ZPS->ZPS_VLTOTP := aDados[nCont,07]

            ZPS->ZPS_FLAGWI := aDados[nCont,nCont2,01]
            ZPS->ZPS_ITEMCO := aDados[nCont,nCont2,02]
            ZPS->ZPS_PRODUT := aDados[nCont,nCont2,03]
            ZPS->ZPS_QUANT  := aDados[nCont,nCont2,11]
            ZPS->ZPS_VLRUNI := aDados[nCont,nCont2,13]
            ZPS->ZPS_VLRTOT := aDados[nCont,nCont2,04]
            ZPS->ZPS_FILENT := aDados[nCont,nCont2,07]
            ZPS->ZPS_DTENTR := aDados[nCont,nCont2,05]
            ZPS->ZPS_QTITPR := aDados[nCont,nCont2,11]
            ZPS->ZPS_OBSERV := aDados[nCont,nCont2,06]
            ZPS->(Msunlock())
        Next nCont2
        
    EndIf
Next nCont 

RestArea(aArea)

Return

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 03/10/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function valc1qtd(cCotacao,aItensV)

Local aArea := GetArea()
Local cQuery 
Local lRet  := .T.
Local aItem := {}
Local nCont := 1
Local cMsg  := ""
Local aAux  := {}

cQuery := "SELECT C8_NUMSC,C8_PRODUTO,B1_XCODPAI,C1_QUANT,SUM(C8_QUANT) AS QTDC8"
cQuery += " FROM "+RetSQLName("SC8")+" C8"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL=' ' AND B1_COD=C8_PRODUTO AND B1.D_E_L_E_T_=' '" 
cQuery += " INNER JOIN "+RetSQLName("SC1")+" C1 ON C1_FILIAL=C8_FILIAL AND C1_NUM=C8_NUMSC AND C1.D_E_L_E_T_=' ' AND C1_PRODUTO=B1_XCODPAI AND C1_COTACAO<>C8_NUM"
cQuery += " WHERE C8_FILIAL='"+xFilial("SC8")+"' AND C8_NUM='"+cCotacao+"' AND C8.D_E_L_E_T_=' '"
cQuery += " GROUP BY C8_NUMSC,C8_PRODUTO,B1_XCODPAI,C1_QUANT"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("JCAJOB01.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

While !EOF()
    Aadd(aItem,{    TRB->C8_PRODUTO,;
                    TRB->B1_XCODPAI,;
                    TRB->C1_QUANT,;
                    TRB->QTDC8,;
                    0})
    Dbskip()
EndDo 


For nCont := 1 to len(aItensV)
    nSoma := 0
    //Aeval(aItem,{|x| nSoma += IF(Alltrim(x[2])==substr(aItensV[nCont,01],1,8),x[4],0)})
    nPosc1 := Ascan(aItem,{|x| alltrim(x[2]) == substr(aItensV[nCont,01],1,8)})
    If nPosc1 > 0
        nSoma := aItem[nPosc1,03]
    EndIf 

    nPos := Ascan(aItem,{|x| alltrim(x[1]) == alltrim(aItensV[nCont,01])})
    If nPos > 0
        nPos2 := Ascan(aAux,{|x| alltrim(x[1]) == alltrim(aItem[nPos,02])})

        If nPos2 == 0
            Aadd(aAux,{aItem[nPos,02],aItem[nPos,3],round(aItensV[nCont,02] / aItensV[nCont,03],0),nSoma}) //round(aItensV[nCont,04],2)})
        Else 
            aAux[nPos2,3] += round(aItensV[nCont,02] / aItensV[nCont,03],0)
            //aAux[nPos2,4] += round(aItensV[nCont,04],2)
        EndIf
    EndIf 
Next nCont

For nCont := 1 to len(aAux)
    If aAux[nCont,03] > aAux[nCont,04] 
        If Empty(cMsg)
            cMsg := "Divergência na quantidade de itens selecionados com a quantidade de itens da solicitação de compra"
        ENDIF

        cMsg += CRLF + "Quantidade Solicitação item "+aAux[nCont,01]+" - "+cvaltochar(aAux[nCont,02])
        cMsg += CRLF + "Quantidade aprovada na cotação para o item total (somando todas as marcas selecionadas) "+cvaltochar(aAux[nCont,03])
        lRet := .F.
    EndIf 
Next nCont 

If !Empty(cMsg)
    MsgAlert(cMsg,"PE_MT161OK")
EndIf 

RestArea(aArea)


Return(lRet)
