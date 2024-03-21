#INCLUDE 'PROTHEUS.CH'
#include "topconn.ch"

User Function MT161CPO()
 
Local aPropostas := PARAMIXB[1] // Array com os dados das propostas dos Fornecedores
Local aItens     := PARAMIXB[2] // Array com os dados da grid "Produtos"
Local aCampos    := {"C8_DIFAL"} // Array com os campos adicionados na grid "Item da Proposta"
Local aCposProd  := {"C8_QTSEGUM","C8_SEGUM"} // Array com os campos adicionados na grid "Produtos"
Local aRetorno   := {}
Local nX         := 0
Local nY         := 0
Local nZ         := 0
Local nCount     := 0
Local aAreaSC8   := SC8->(GetArea())
 
For nX := 1 To Len(aPropostas)
    For nY := 1 To Len(aPropostas[nX])
        For nZ := 1 To Len(aPropostas[nX][nY][2])
            nCount++
 
            //C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO
            If Len(aPropostas[nX][nY][1]) > 0

                cConteudo := CalcImp(SC8->C8_NUM,1,aPropostas[1,nY,1,1],aPropostas[1,nY,1,2],aPropostas[1,nY,1,3])
                AADD(aPropostas[nX][nY][2][nZ],cConteudo )
                
            Else
                AADD(aPropostas[nX][nY][2][nZ],0)
            EndIf
        Next nZ
    Next nY
Next nX
 
For nX := 1 To Len(aItens)
    //C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO
    AADD(aItens[nX], Posicione("SC8",1,SC8->C8_FILIAL+SC8->C8_NUM+aItens[nX][10]+aItens[nX][11]+aItens[nX][12]+aItens[nX][13], "C8_QTSEGUM"))
    AADD(aItens[nX], Posicione("SC8",1,SC8->C8_FILIAL+SC8->C8_NUM+aItens[nX][10]+aItens[nX][11]+aItens[nX][12]+aItens[nX][13], "C8_SEGUM"))
Next nX
 
AADD(aRetorno, aPropostas)
AADD(aRetorno, aCampos)
AADD(aRetorno, aItens)
AADD(aRetorno, aCposProd)
 
RestArea(aAreaSC8)
 
Return aRetorno


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
Static Function CalcImp(cNumPed,nTipo,cFornec,cLoja,cNomFor)

Local aArea     := GetArea()
Local aAreaC5   := SF1->(GetArea())
Local aAreaB1   := SD1->(GetArea())
Local aAreaC6   := SB1->(GetArea())
Local cQryIte   := ""
Local nValPed   := 0
Local nNritem   := 0
Local cCodFor   :=  ''
Local cLojFor   :=  ''
Local nValCMP   := 0
Local lCriaFor  := .F.

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
    cQryIte += "    C8_TOTAL, "
    cQryIte += "    C8_XEST "
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
    
    If !Empty(cFornec)
        cQryIte += "    AND C8_FORNECE = '"+cFornec+"' "
        cQryIte += "    AND C8_LOJA = '"+cLoja+"' "
    Else 
        cQryIte += "    AND C8_FORNOME = '"+cNomFor+"' "
    EndIf 
    cQryIte += "    AND SC8.D_E_L_E_T_ = ' ' "
    cQryIte += " ORDER BY "
    cQryIte += "    C8_ITEM "
    
    cQryIte := ChangeQuery(cQryIte)
    
    TCQuery cQryIte New Alias "QRY_ITE"
        
    DbSelectArea('SC8')

    IF !Empty(cFornec)
        SC8->(DbSetOrder(1))
        SC8->(DbSeek(FWxFilial('SC8') + cNumPed))
    Else 
        SC8->(DbSetOrder(8))
        SC8->(DbSeek(FWxFilial('SC8') + cNumPed + cFornec + cLoja + cNomFor))
    EndIF 

    If Empty(SC8->C8_FORNECE) .And. !Empty(SC8->C8_XEST)
        //Criando um cadastro temporário de fornecedor apenas para carregar
        //o Difal se ele for de um estado diferente de onde esta sendo 
        //realizada a cotação (Filial)
        //If SM0->M0_ESTENT <> SC8->C8_XEST
            lCriaFor := .T.
            DbSelectArea("SA2")
            DbSetOrder(1)
            If !Dbseek(xFilial("SA2")+'999XXX')
                Reclock("SA2",.T.)
                SA2->A2_COD := '999XXX'
                SA2->A2_LOJA := '01'
            Else 
                Reclock("SA2",.F.)
            EndIf 

            SA2->A2_NOME := SC8->C8_FORNOME
            SA2->A2_EST  := SC8->C8_XEST 
            SA2->A2_MSBLQL := '2'
            SA2->(Msunlock())
            
            cCodFor := '999XXX'
            cLojFor := '01'
        //EndIF 
    Else 
        cCodFor := SC8->C8_FORNECE
        cLojFor := SC8->C8_LOJA
    EndIF 

    MaFisIni(cCodFor,;                    // 1-Codigo Cliente/Fornecedor
        cLojFor,;                    // 2-Loja do Cliente/Fornecedor
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
            
        nValSOL := MaFisRet(nLinha, "IT_VALSOL") 
        nValCMP += MaFisRet(nLinha, "IT_VALCMP")  //difal
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

EndIf
    
//Atualiza o retorno
nValPed := nTotNF + nTotIPI + nTotFrete + nTotISS + nValCMP

If lCriaFor 
    DbSelectArea("SA2")
    DbSetOrder(1)
    IF Dbseek(xFilial("SA2")+'999XXX')
        Reclock("SA2",.F.)
        SA2->A2_MSBLQL := '1'
        SA2->A2_NOME   := 'NAO USAR'
        SA2->(Msunlock())
    EndIf   
EndIf 

RestArea(aAreaC6)
RestArea(aAreaB1)
RestArea(aAreaC5)
RestArea(aArea)    

Return(nValPed)
