#INCLUDE 'PROTHEUS.CH'
#include "topconn.ch"

User Function MT161PRO()

Local aPropostas := PARAMIXB[1]
Local aRet := aPropostas
Local nCont,nX,nJ
Local nSoma     :=  0

For nCont := 1 to len(aRet[1])
    nSoma := 0
    For nX := 2 to len(aRet[1,nCont])
        For nJ := 1 to len(aRet[1,nCont,nX])
            If aRet[1,nCont,nX,nJ,1]
                nSoma += aRet[1,nCont,nX,nJ,4]
            EndIf
        Next nJ
    Next nX

    aRet[1,nCont,1,7] := nSoma
    CalcImp(SC8->C8_NUM,1,aRet[1,nCont,1,1],aRet[1,nCont,1,2])
Next nCont 

Return aRet

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 20/03/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function CalcImp(cNumPed,nTipo,cFornec,cLoja)

Local aArea     := GetArea()
Local aAreaC5   := SF1->(GetArea())
Local aAreaB1   := SD1->(GetArea())
Local aAreaC6   := SB1->(GetArea())
Local cQryIte   := ""
Local nValPed   := 0
Local nNritem   := 0
Local nAtu

Default cNumPed := '000084'
Default nTipo   := 1
    
//Se for no Browse, já traz o valor total
If nTipo == 1
    //Seleciona agora os itens do pedido
    cQryIte := " SELECT "
    cQryIte += "    C8_ITEM, "
    cQryIte += "    C8_PRODUTO, "
    cQryIte += "    C8_QUANT, "
    cQryIte += "    C8_PRECO, "
    cQryIte += "    C8_VLDESC, "
    cQryIte += "    C8_VALFRE, "
    cQryIte += "    C8_DESPESA, "
    cQryIte += "    C8_SEGURO, "
    cQryIte += "    C8_TOTAL "
    cQryIte += " FROM "
    cQryIte += "    "+RetSQLName('SC8')+" SC8 "
    cQryIte += "    LEFT JOIN "+RetSQLName('SB1')+" SB1 ON ( "
    cQryIte += "        B1_FILIAL = '"+FWxFilial('SB1')+"' "
    cQryIte += "        AND B1_COD = SC8.C8_PRODUTO "
    cQryIte += "        AND SB1.D_E_L_E_T_ = ' ' "
    cQryIte += "    ) "
    cQryIte += " WHERE "
    cQryIte += "    C8_FILIAL = '"+FWxFilial('SC8')+"' "
    cQryIte += "    AND C8_NUM = '"+cNumPed+"' "
    cQryIte += "    AND C8_FORNECE = '"+cFornec+"' "
    cQryIte += "    AND C8_LOJA = '"+cLoja+"' "
    cQryIte += "    AND SC8.D_E_L_E_T_ = ' ' "
    cQryIte += " ORDER BY "
    cQryIte += "    C8_ITEM "
    
    cQryIte := ChangeQuery(cQryIte)
    
    TCQuery cQryIte New Alias "QRY_ITE"
        
    DbSelectArea('SC8')
    SC8->(DbSetOrder(1))
    SC8->(DbSeek(FWxFilial('SC8') + cNumPed))
    MaFisIni(SC8->C8_FORNECE,;                    // 1-Codigo Cliente/Fornecedor
        SC8->C8_LOJA,;                    // 2-Loja do Cliente/Fornecedor
        /*If(SC5->C5_TIPO$'DB',"F","C")*/'F',;               // 3-C:Cliente , F:Fornecedor
        /*SC5->C5_TIPO*/'N',;                                // 4-Tipo da NF
        /*SC5->C5_TIPOCLI*/NIL,;                           // 5-Tipo do Cliente/Fornecedor
        MaFisRelImp("MT100",{"SF1","SD1"}),;        // 6-Relacao de Impostos que suportados no arquivo
        ,;                                               // 7-Tipo de complemento
        .f.,;                                            // 8-Permite Incluir Impostos no Rodape .T./.F.
        "SB1",;                                        // 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
        "MATA103")                                    // 10-Nome da rotina que esta utilizando a funcao
        
    //Pega o total de itens
    QRY_ITE->(DbGoTop())
    While ! QRY_ITE->(EoF())
        nNritem++
        QRY_ITE->(DbSkip())
    EndDo
        
    //Preenchendo o valor total
    QRY_ITE->(DbGoTop())
    nTotIPI := 0
    nLinha := 1

    While ! QRY_ITE->(EoF())
        //Pega os tratamentos de impostos
        SB1->(DbSeek(FWxFilial("SB1")+QRY_ITE->C8_PRODUTO))
        //SC8->(DbSeek(FWxFilial("SC8")+cNumPed+QRY_ITE->C8_ITEM))
            
        MaFisAdd(   QRY_ITE->C8_PRODUTO,;                     // 1-Codigo do Produto                 ( Obrigatorio )
                    /*SC8->C8_TES*/ '001',;                         // 2-Codigo do TES                     ( Opcional )
                    QRY_ITE->C8_QUANT,;                      // 3-Quantidade                     ( Obrigatorio )
                    QRY_ITE->C8_PRECO,;                      // 4-Preco Unitario                 ( Obrigatorio )
                    QRY_ITE->C8_VLDESC,;                    // 5 desconto
                    /*SC8->C6_NFORI*/'',;                     // 6-Numero da NF Original             ( Devolucao/Benef )
                    /*SC8->C6_SERIORI*/'',;                    // 7-Serie da NF Original             ( Devolucao/Benef )
                    0,;                                    // 8-RecNo da NF Original no arq SD1/SD2
                    QRY_ITE->C8_VALFRE /*/nNritem*/,;                // 9-Valor do Frete do Item         ( Opcional )
                    QRY_ITE->C8_DESPESA /*/nNritem*/,;            // 10-Valor da Despesa do item         ( Opcional )
                    QRY_ITE->C8_SEGURO /*/nNritem*/,;            // 11-Valor do Seguro do item         ( Opcional )
                    0,;                                    // 12-Valor do Frete Autonomo         ( Opcional )
                    QRY_ITE->C8_TOTAL,;                     // 13-Valor da Mercadoria             ( Obrigatorio )
                    0,;                                    // 14-Valor da Embalagem             ( Opcional )
                    0,;                                     // 15-RecNo do SB1
                    0)                                     // 16-RecNo do SF4
            
        //nItem++
        nValSOL := MaFisRet(nLinha, "IT_VALSOL") 
        nValCMP := MaFisRet(nLinha, "IT_VALCMP")  //difal
        nLinha++
        QRY_ITE->(DbSkip())
    EndDo
        
    //Pegando totais
    nTotIPI   := MaFisRet(,'NF_VALIPI')
    nTotICM   := MaFisRet(,'NF_VALICM')
    nTotNF    := MaFisRet(,'NF_TOTAL')
    nTotFrete := MaFisRet(,'NF_FRETE')
    nTotISS   := MaFisRet(,'NF_VALISS')
        
    QRY_ITE->(DbCloseArea())
    MaFisEnd()
Else
    MaFisIni(SC5->C5_CLIENTE,;                    // 1-Codigo Cliente/Fornecedor
        SC5->C5_LOJACLI,;                    // 2-Loja do Cliente/Fornecedor
        If(SC5->C5_TIPO$'DB',"F","C"),;               // 3-C:Cliente , F:Fornecedor
        SC5->C5_TIPO,;                                // 4-Tipo da NF
        SC5->C5_TIPOCLI,;                           // 5-Tipo do Cliente/Fornecedor
        MaFisRelImp("MT100",{"SF2","SD2"}),;        // 6-Relacao de Impostos que suportados no arquivo
        ,;                                               // 7-Tipo de complemento
        ,;                                            // 8-Permite Incluir Impostos no Rodape .T./.F.
        "SB1",;                                        // 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
        "MATA461")                                    // 10-Nome da rotina que esta utilizando a funcao
        
        
    nNritem := Len(aCols)
        
    //Preenchendo o valor total
    nTotIPI := 0
    For nAtu := 1 To Len(aCols)
        //Pega os tratamentos de impostos
        SB1->(DbSeek(FWxFilial("SB1")+aCols[nAtu][GDFieldPos("C6_PRODUTO")]))
            
        MaFisAdd(    aCols[nAtu][GDFieldPos("C6_PRODUTO")],;                     // 1-Codigo do Produto                 ( Obrigatorio )
                    aCols[nAtu][GDFieldPos("C6_TES")],;                         // 2-Codigo do TES                     ( Opcional )
                    aCols[nAtu][GDFieldPos("C6_QTDVEN")],;                      // 3-Quantidade                     ( Obrigatorio )
                    aCols[nAtu][GDFieldPos("C6_PRCVEN")],;                      // 4-Preco Unitario                 ( Obrigatorio )
                    aCols[nAtu][GDFieldPos("C6_VALDESC")],;                    // 5 desconto
                    aCols[nAtu][GDFieldPos("C6_NFORI")],;                     // 6-Numero da NF Original             ( Devolucao/Benef )
                    aCols[nAtu][GDFieldPos("C6_SERIORI")],;                    // 7-Serie da NF Original             ( Devolucao/Benef )
                    0,;                                    // 8-RecNo da NF Original no arq SD1/SD2
                    M->C5_FRETE/nNritem,;                // 9-Valor do Frete do Item         ( Opcional )
                    M->C5_DESPESA/nNritem,;            // 10-Valor da Despesa do item         ( Opcional )
                    M->C5_SEGURO/nNritem,;            // 11-Valor do Seguro do item         ( Opcional )
                    0,;                                    // 12-Valor do Frete Autonomo         ( Opcional )
                    aCols[nAtu][GDFieldPos("C6_VALOR")],;                     // 13-Valor da Mercadoria             ( Obrigatorio )
                    0,;                                    // 14-Valor da Embalagem             ( Opcional )
                    0,;                                     // 15-RecNo do SB1
                    0)                                     // 16-RecNo do SF4
            
    Next
        
    //Pegando totais
    nTotIPI   := MaFisRet(,'NF_VALIPI')
    nTotICM   := MaFisRet(,'NF_VALICM')
    nTotNF    := MaFisRet(,'NF_TOTAL')
    nTotFrete := MaFisRet(,'NF_FRETE')
    nTotISS   := MaFisRet(,'NF_VALISS')
        
    MaFisEnd()
EndIf
    
//Atualiza o retorno
nValPed := nTotNF + nTotIPI + nTotFrete + nTotISS
    
RestArea(aAreaC6)
RestArea(aAreaB1)
RestArea(aAreaC5)
RestArea(aArea)    
Return
