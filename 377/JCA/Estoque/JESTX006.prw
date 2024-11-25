#INCLUDE 'PROTHEUS.CH'
/*
    Função para informar produto filho com menor sado

    Chamdo da validaçãod de usuario do campo CP_PRODUTO
    
    DOC MIT
    
    DOC ENTREGA
    
*/
User Function JEST006A()
Local aArea 	:=	GetArea()
Local cProd     := &(ReadVar())
Local cLocal    := Posicione("SB1",1,xFilial("SB1")+cProd,"B1_LOCPAD")
Local nQtd      := 0
Local nPProduto := aScan(aHeader,{|x| AllTrim(x[2])=="CP_PRODUTO"})
Local nPLocal	:= aScan(aHeader,{|x| AllTrim(x[2])=="CP_LOCAL"})

If FunName() == "MATA105"
    MenorSaldo(@cProd,@cLocal,nQtd,.f.)
    M->CP_PRODUTO           := cProd
    M->CP_LOCAL             := cLocal
    aCols[n][nPProduto]     := cProd
    aCols[n][nPLocal]       := cLocal
Endif

RestArea(aArea)

Return .t.


/*
    Função para validar a quantidade informada na solicitação de compras
    Verifica se a quantidade informada é menor ou igual que o saldo do produto
    
     Chamdo da validaçãod de usuario do campo CP_QUANT

    DOC MIT
    
    DOC ENTREGA
    
*/
User Function JEST006B()
Local aArea 	:=	GetArea()
Local nPProduto := aScan(aHeader,{|x| AllTrim(x[2])=="CP_PRODUTO"})
Local nPLocal	:= aScan(aHeader,{|x| AllTrim(x[2])=="CP_LOCAL"})
Local cProd     := aCols[n][nPProduto]
Local cLocal    := aCols[n][nPLocal] 
Local nQtd      := &(ReadVar())
Local nQtdVld   := &(ReadVar())
Local lRet      := .t.

If FunName() == "MATA105"
    MenorSaldo(cProd,cLocal,@nQtd,.t.)

    IF nQtdVld > nQtd
        Help( ,, "HELP","JESTX006B", "Não existe saldo suficiente para a solicitação.", 1, 0)      
        lRet := .f.
    Endif
Endif
RestArea(aArea)

Return lRet


/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 01/12/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function MenorSaldo(cCodProd,cLocal,nQtd,lVldQtd)

Local aArea         := GetArea()
Local cQuery        := ""
Local cAliasQry     := GetNextAlias()

If Select(cAliasQry) <> 0
    (cAliasQry)->(dbCloseArea())
EndIf

cQuery := "SELECT SB2.B2_FILIAL,SB2.B2_COD,SB2.B2_LOCAL,SB2.B2_QATU "
cQuery += " FROM "+RetSQLName("SB2")+" SB2 "
cQuery += " WHERE "
cQuery += " SB2.B2_FILIAL='"+FWxFilial("SB2")+"' " 
If lVldQtd
    cQuery += " AND SB2.B2_COD = '"+cCodProd+"' "
Else
    cQuery += " AND SB2.B2_COD IN(SELECT SB1.B1_COD FROM "+RetSQLName("SB1")+" SB1 WHERE SB1.B1_FILIAL='"+xFilial("SB1")+"' AND SB1.D_E_L_E_T_ <> '*' "
    cQuery += " AND (SB1.B1_XCODPAI='"+cCodProd+"')) "
    //cQuery += " AND (SB1.B1_COD='"+cCodProd+"' OR SB1.B1_XCODPAI='"+cCodProd+"'))
Endif
If lVldQtd .and. !Empty(cLocal)
    cQuery += " AND SB2.B2_LOCAL = '"+cLocal+"' "
Endif    
cQuery += " AND SB2.B2_QATU > 0 "
cQuery += " AND SB2.D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY SB2.B2_QATU "

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), cAliasQry, .F., .T. )

//'Codigo','Armazem','Qtd Disponível','Saldo Atual','Qtd. Ped.Venda','Qtd.Empenhada','Qtd.Prevista Entrada','Qtd Empenhada S.A.','Qtd.Reservada','Qt.Ter.Ns.Pd','Qtd.Ns.Pd.Ter','Saldo Pod.3','Qtd.Emp.NF','Qtd.a Endere','Qtd.Emp.Prj.','Empen.Previ'

If  !(cAliasQry)->(EOF())
    cCodProd := (cAliasQry)->B2_COD
    cLocal   := (cAliasQry)->B2_LOCAL
    nQtd     := (cAliasQry)->B2_QATU       
Endif

(cAliasQry)->(dbCloseArea())

RestArea(aArea)
    
Return Nil
