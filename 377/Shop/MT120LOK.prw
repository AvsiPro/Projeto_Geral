/*
{Protheus.doc} MT120LOK()
//TODO Descrição:
O ponto de entrada MT120LOK() permite validar cada linha incluída na tela do pedido de compras.

Eventos
Ponto de entrada para validação dos itens do pedido de compra
Obriga a inclusão do item somente se estiver cadastrado no Produto x Fornecedor.

@author Henrique Dutra
@since 18/11/2020
@version 1

@history 18/11/2020,Henrique Dutra, função criada para alertar o usuário que o produto não existe cadastrado para o fornecedor.
@history 08/11/2022, Inserido validação do campo observação e modalidade de pagamento.
*/

User Function  MT120LOK()

Local lValido   := .T.
/*
Local nPosItem  := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_ITEM'})
Local nPosSc    := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_NUMSC'})
Local cProd     := aCols[n][nPosPrd]
Local cNumsc    := aCols[n][nPosSc]



If !FunName() == "MATA161" //Ignora a rotina de analise de cotação, pois nem sempre o produto possui amarração (Produto x Fornecedor)
    
    dbSelectArea("SA5")
    dbSetOrder(1)
        dbGotop()

            //Valida se o produto está cadastrado "Produto x Fornecedor", se foi gerado através de solicitação de compras, ignora o erro.
            If !SA5->(dbSeek(xFilial("SA5")+ cA120Forn + cA120Loj + Alltrim(cProd))) .And. Empty(cNumsc)
                MsgAlert("Produto x Fornecedor não cadastrado. Por Gentileza, solicitar o cadastro junto a controladoria.")
                lValido := .F.   
            EndIf

EndIf

*/
    Local aArea      := GetArea()
    Local aGrupoRD   := StrTokArr(GetMv("SC_GRPRD"),";")
    Local nPosPrd    := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_PRODUTO'})
    Local nPosItem   := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_ITEM'})
    Local nPosObsPc  := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_XOBSCMP'})
    Local nPosModPag := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_XMODPAG'})
    Local nPosGct    := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_CONTRA'})
    Local nPosXlinK  := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_XLINK'})
    Local nMod       := 0
    Local nAux       := 0
    Local cConRbd    := SuperGetMV("SC_CONDRD",.f.,"D04")

    //Valida digitação do campo de observação
    If Empty( aCols[n][nPosObsPc] )
        If Empty( aCols[n][nPosGct])
            Help(   , ,'Sem Observação' ,, 'O campo Obs Compra não pode ser vazio!', 1,0,NIL, NIL, NIL, NIL, NIL, {"Preencha o campo Obs Compra do item! "+aCols[n][nPosItem]})
            lValido := .F.
        Endif      
    EndIf
    //Valida digitação do campo modalidade de pagamento
    If n == 1
        //Se tiver mais de 1 item replica o conteúdo campo C7_XMODPAG para todos os itens  
        If Empty(aCols[n][nPosModPag])
            If Empty( aCols[n][nPosGct])
                Help(   , ,'Sem Modalidade de Pagamento' ,, 'O campo Mod Pagamento não pode ser vazio!', 1,0,NIL, NIL, NIL, NIL, NIL, {"Preencha o campo Mod Pagto do item! "+aCols[n][nPosItem]})
                lValido := .F.
            Else
                aCols[n][nPosModPag] := '2'
            Endif
        Endif
        //Valida o preenchimento do link do documento
        cProdAtu := aCols[n   ,nPosPrd]
        SB1->(MsSeek(xFilial("SB1") + cProdAtu ))
        cGrupAtu := SB1->B1_GRUPO
        If aScan(aGrupoRD,{|x| AllTrim(x) == cGrupAtu }) > 0 
            If Empty(aCols[n][nPosXlinK])
                If !IsBlind()
                    Help(   , ,'Sem Link do Documento' ,, 'O Link do documento não foi informado!', 1,0,NIL, NIL, NIL, NIL, NIL, {"Gerar o link no Safedoc com os comprovantes e incluir no pedido!"})
                Else
                    Conout("O link do documento nao foi informado")
                Endif
                lValido := .F.
            Endif   
        Endif
    ElseIf n >1 
        nAux := n -1
        If Empty(aCols[n][nPosModPag])
            For nMod := n to len(aCols)
                aCols[n,nPosModPag] := aCols[nAux][nPosModPag]
            Next
        Endif
        //Preenche o link do documento informado na primeira linha
        If Empty(aCols[n][nPosXlinK])
            For nMod := n to len(aCols)
                aCols[n,nPosXlinK] := aCols[nAux][nPosXlinK]
            Next
        Endif

        //Valida se o produto e de reembolso
        cProdAnt := aCols[nAux,nPosPrd]
        cProdAtu := aCols[n   ,nPosPrd]
        SB1->(MsSeek(xFilial("SB1") + cProdAnt ))
        cGrupAnt := SB1->B1_GRUPO 
        SB1->(MsSeek(xFilial("SB1") + cProdAtu ))
        cGrupAtu := SB1->B1_GRUPO

        If aScan(aGrupoRD,{|x| AllTrim(x) == cGrupAnt }) > 0 
            If cGrupAnt <> cGrupAtu
                If !IsBlind()
                    ApMsgStop("Para pedidos de reembolso, todos os produtos devem ser do grupo de Serviços de Reembolso","Produto Invalido")
                    lValido := .F.
                Else
                    Conout("Para pedidos de reembolso, todos os produtos devem ser do grupo de Serviços de Reembolso...")
                Endif
            Endif 
        Endif

        If aScan(aGrupoRD,{|x| AllTrim(x) == cGrupAtu }) > 0 
            If cCondicao <> cConRbd
                If !IsBlind()
                    MsgAlert("Para pedidos de reembolso, obrigatoriamente a condição de pagamento deve ser a "+cConRbd+"."+CRLF+"Seu pedido esta sendo alterado para esta condição de pagamento.","MT120LOK")
                    cCondicao := cConRbd
                EndIf 
            EndIf 
            If cGrupAnt <> cGrupAtu
                If !IsBlind()
                    ApMsgStop("Para pedidos de reembolso, todos os produtos devem ser do grupo de Serviços de Reembolso","Produto Invalido")
                    lValido := .F.
                Else
                    Conout("Para pedidos de reembolso, todos os produtos devem ser do grupo de Serviços de Reembolso...")
                Endif
            Endif 
        Endif
    EndIf
    
    RestArea(aArea)

Return(lValido) 


