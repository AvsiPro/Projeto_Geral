/*
    Complemento do saldo do produto somando os filhos no momento da solicita�ao por ponto de pedido
*/
User Function MT170SLD( )

Local nQuant    := PARAMIXB[1]
Local cProd     := PARAMIXB[2]
// procura itens filho para nova composi��o do saldo
Local aAux      := U__SearchSon(cProd)
//Local cLocal    := PARAMIXB[3]     
Local nSldNew   := 0
Local nNewSaldo := nQuant

If len(aAux) > 0
    //Buscando saldo dos filhos
    nSldNew := sldFilho(aAux)
    nNewSaldo += nSldNew 

//-- Manipula��o pelo usu�rio do saldo do produto
/*
1 � C�lculo do Saldo

O sistema se utiliza do arquivo SB2 (Saldos F�sicos e Financeiros) para obter o saldo e o faz da seguinte maneira:

Campos:

Qatu    = Somat�ria do saldo atual de todos os almoxarifados
Salped = Somat�ria da quantidade a entrar (Ordem de Produ��o, Pedidos de Compras e Solicita��es de Compras) de todos os almoxarifados.
Qpedven = Somat�ria de toda a quantidade � sair (Ex: Pedido da Venda, Empenhos para OP, Empenhos de OPs etc..) de todos os almoxarifados.
Estseg = Estoque de Seguran�a

A f�rmula que comp�e o Saldo = Qatu+Salped-Qpedven-Estseg

*/

EndIf 

Return (nNewSaldo)

/*/{Protheus.doc} sldFilho
    (long_description)
    @type  Static Function
    @author user
    @since 30/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function sldFilho(aAux)

Local aArea := GetArea()
Local cQuery:= ""
Local nRet  := 0
Local nCont := 0
Local cClaus:= ""
Local cBarra:= ""

For nCont := 1 to len(aAux)
    cClaus += cBarra + aAux[nCont,01]
    cBarra := "','" 
Next nCont 

cQuery := "SELECT SUM(B2_QATU+B2_SALPEDI-B2_QPEDVEN) AS SALDO"
cQuery += " FROM "+RetSQLName("SB2")+" B2"
cQuery += " WHERE B2_FILIAL='"+xFilial("SB2")+"'"

cQuery += " AND B2_COD IN('"+cClaus+"')"

cQuery += " AND B2.D_E_L_E_T_=' '"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB")

nRet := TRB->SALDO

RestArea(aArea)

Return(nRet)
/*
User Function MS170QTD( )

Local nQuant := PARAMIXB

nQuant := nQuant + 10

Return(nQuant)

*/
