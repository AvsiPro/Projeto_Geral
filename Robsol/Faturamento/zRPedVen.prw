//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"

//Variáveis utilizadas no fonte inteiro
Static nPadLeft   := 0                                                                     //Alinhamento a Esquerda
Static nPadRight  := 1                                                                     //Alinhamento a Direita
Static nPadCenter := 2                                                                     //Alinhamento Centralizado
Static nPosCod    := 0000                                                                  //Posição Inicial da Coluna de Código do Produto 
Static nPosLote   := 0000                                                                  //Posição Inicial da Coluna de Lote
Static nPosDesc   := 0000                                                                  //Posição Inicial da Coluna de Descrição
Static nPosUnid   := 0000                                                                  //Posição Inicial da Coluna de Unidade de Medida
Static nPosQuan   := 0000                                                                  //Posição Inicial da Coluna de Quantidade
Static nPosVUni   := 0000                                                                  //Posição Inicial da Coluna de Valor Unitario
Static nPosVTot   := 0000                                                                  //Posição Inicial da Coluna de Valor Total
Static nPosEmba   := 0000                                                                  //Posição Inicial da Coluna de Quantidade na embalagem
Static nPosQtCx   := 0000                                                                  //Posição Inicial da Coluna de Quantidade de caixas
Static nPosDcto   := 0000                                                                  //Posição Inicial da Coluna de Desconto no item
Static nPosBIcm   := 0000                                                                  //Posição Inicial da Coluna de Base Calculo ICMS
Static nPosVIcm   := 0000                                                                  //Posição Inicial da Coluna de Valor ICMS
Static nPosVIPI   := 0000                                                                  //Posição Inicial da Coluna de Valor Ipi
Static nPosAIcm   := 0000                                                                  //Posição Inicial da Coluna de Aliquota ICMS
Static nPosAIpi   := 0000                                                                  //Posição Inicial da Coluna de Aliquota IPI
Static nPosSTUn   := 0000                                                                  //Posição Inicial da Coluna de Valor Unitário ST
Static nPosSTVl   := 0000                                                                  //Posição Inicial da Coluna de Valor Unitário + ST
Static nPosSTBa   := 0000                                                                  //Posição Inicial da Coluna de Base do ST
Static nPosSTTo   := 0000                                                                  //Posição Inicial da Coluna de Valor Total ST
Static nTamFundo  := 15                                                                    //Altura de fundo dos blocos com título
Static cEmpEmail  := IIf(IsBlind(), "pedidos@robsol.com.br" ,Alltrim(SuperGetMV("MV_X_EMAIL", .F., "pedidos@robsol.com.br")) )         //Parâmetro com o e-Mail da empresa
Static cEmpSite   := IIf(IsBlind(), "http://www.robsol.com.br", Alltrim(SuperGetMV("MV_X_HPAGE", .F., "http://www.robsol.com.br")))     //Parâmetro com o site da empresa
Static nCorAzul   := RGB(062, 179, 206)                                                    //Cor Azul usada nos Títulos
Static cNomeFont  := "Arial"                                                               //Nome da Fonte Padrão
Static oFontDet   := Nil                                                                   //Fonte utilizada na impressão dos itens
Static oFontDetN  := Nil                                                                   //Fonte utilizada no cabeçalho dos itens
Static oFontRod   := Nil                                                                   //Fonte utilizada no rodapé da página
Static oFontTit   := Nil                                                                   //Fonte utilizada no Título das seções
Static oFontCab   := Nil                                                                   //Fonte utilizada na impressão dos textos dentro das seções
Static oFontCabN  := Nil                                                                   //Fonte negrita utilizada na impressão dos textos dentro das seções
Static cMaskPad   := "@E 999,999.99"                                                       //Máscara padrão de valor 
Static cMaskTel   := "@R (99) 99999999"                                                    //Máscara de telefone / fax
Static cMaskCNPJ  := "@R 99.999.999/9999-99"                                               //Máscara de CNPJ
Static cMaskCEP   := "@R 99999-999"                                                        //Máscara de CEP
Static cMaskCPF   := "@R 999.999.999-99"                                                   //Máscara de CPF
Static cMaskQtd   := IIf(!IsBlind(),PesqPict("SC6", "C6_QTDVEN"),'')                                          //Máscara de quantidade
Static cMaskPrc   := IIf(!IsBlind(),PesqPict("SC6", "C6_PRUNIT"),'')                                          //Máscara de preço
Static cMaskVlr   := IIf(!IsBlind(),PesqPict("SC6", "C6_VALOR"),'')                                           //Máscara de valor
Static cMaskFrete := IIf(!IsBlind(),PesqPict("SC5", "C5_FRETE"),'')                                           //Máscara de frete
Static cMaskPBru  := IIf(!IsBlind(),PesqPict("SC5", "C5_PBRUTO"),'')                                         //Máscara de peso bruto
Static cMaskPLiq  := IIf(!IsBlind(),PesqPict("SC5", "C5_PESOL"),'')                                          //Máscara de peso liquido
Static cCodBar    := ""
Static cFretePed  := ""

/*/{Protheus.doc} zRPedVen
Impressão gráfica genérica de Pedido de Venda (em pdf)
@type function
@author Paulo Lima
@since 17/01/2022
@version 1.0
	@example
	u_zRPedVen()
/*/

User Function zRPedVen(cPedDe,cPedAt,cCliDe,cCliAt,cVndDe,cVndAt,lAPPA)
	Local aArea      := GetArea()
	Local aPergs     := {}
	Local aRetorn    := {}
	Local oProcess   := Nil
	//Variáveis usadas nas outras funções
	Private cLogoEmp := ''
	Private cLayout  := "1"
	Private cTipoBar := "1"
	Private cImpDupl := "1"
	Private cZeraPag := "1"

	Default cPedDe   := ''
	Default cPedAt   := ''
	Default cCliDe   := space(6) 
	Default cCliAt   := 'ZZZZZZ' 
	Default cVndDe   := space(6) 
	Default cVndAt   := 'ZZZZZZ' 
	Default lAPPA	 := .F.

	If !lAPPA
		aAreaC5  := SC5->(GetArea())
		cPedDe   := SC5->C5_NUM
		cPedAt   := SC5->C5_NUM
		cLogoEmp := fLogoEmp()
		
		//Adiciona os parametros para a pergunta
		aAdd(aPergs, {1, "Pedido De",  cPedDe, "", ".T.", "SC5", ".T.", 80, .T.})
		aAdd(aPergs, {1, "Pedido Até", cPedAt, "", ".T.", "SC5", ".T.", 80, .T.})
		aAdd(aPergs, {1, "Cliente De",  cCliDe, "", ".T.", "SA1", ".T.", 80, .F.})
		aAdd(aPergs, {1, "Cliente Até", cCliAt, "", ".T.", "SA1", ".T.", 80, .T.})
		aAdd(aPergs, {1, "Vendedor De",  cVndDe, "", ".T.", "SA3", ".T.", 80, .F.})
		aAdd(aPergs, {1, "Vendedor Até", cVndAt, "", ".T.", "SA3", ".T.", 80, .T.})
		//aAdd(aPergs, {2, "Layout",                         Val(cLayout),  {"1=Dados com ST",     "2=Dados com IPI"},                                       100, ".T.", .F.})
		//aAdd(aPergs, {2, "Código de Barras",               Val(cTipoBar), {"1=Número do Pedido", "2=Filial + Número do Pedido", "3=Sem Código de Barras"}, 100, ".T.", .F.})
		//aAdd(aPergs, {2, "Imprimir Previsão Duplicatas",   Val(cImpDupl), {"1=Sim",              "2=Não"},                                                 100, ".T.", .F.})
		//aAdd(aPergs, {2, "Zera a Página ao trocar Pedido", Val(cZeraPag), {"1=Sim",              "2=Não"},                                                 100, ".T.", .F.})
		
		//Se a pergunta for confirmada
		If ParamBox(aPergs, "Informe os parâmetros", @aRetorn, , , , , , , , .F., .F.)
			cPedDe   := aRetorn[1]
			cPedAt   := aRetorn[2]

			cCliDe	:= aRetorn[3]
			cCliAt	:= aRetorn[4]
			cVndDe	:= aRetorn[5]
			cVndAt	:= aRetorn[6]
			//cLayout  := cValToChar(aRetorn[3])
			//cTipoBar := cValToChar(aRetorn[3])
			//cImpDupl := cValToChar(aRetorn[5])
			//cZeraPag := cValToChar(aRetorn[6])
			
			//Função que muda alinhamento e fontes
			fMudaLayout()
			
			//Chama o processamento do relatório
			oProcess := MsNewProcess():New({|| fMontaRel(@oProcess,{cPedDe,cPedAt,cCliDe,cCliAt,cVndDe,cVndAt,lAPPA}) }, "Impressão Pedidos de Venda", "Processando", .F.)
			oProcess:Activate()
		EndIf
	Else
		RPCSetType(3)  
		RpcSetEnv('01','0101',,,,GetEnvServer(),{ })

		aAreaC5    := SC5->(GetArea())
		cLogoEmp   := fLogoEmp()
		cMaskQtd   := PesqPict("SC6", "C6_QTDVEN") //Máscara de quantidade
		cMaskPrc   := PesqPict("SC6", "C6_PRUNIT") //Máscara de preço
		cMaskVlr   := PesqPict("SC6", "C6_VALOR")  //Máscara de valor
		cMaskFrete := PesqPict("SC5", "C5_FRETE")  //Máscara de frete
		cMaskPBru  := PesqPict("SC5", "C5_PBRUTO") //Máscara de peso bruto
		cMaskPLiq  := PesqPict("SC5", "C5_PESOL")  //Máscara de peso liquido

		fMudaLayout()
		oProcess := MsNewProcess():New({|| fMontaRel(@oProcess,{cPedDe,cPedAt,cCliDe,cCliAt,cVndDe,cVndAt,lAPPA}) }, "Impressão Pedidos de Venda", "Processando", .F.)
	EndIf
	
	RestArea(aAreaC5)
	RestArea(aArea)
Return

/*---------------------------------------------------------------------*
 | Func:  fMontaRel                                                    |
 | Desc:  Função principal que monta o relatório                       |
 *---------------------------------------------------------------------*/

Static Function fMontaRel(oProc,aParams)
	//Variáveis usada no controle das réguas
	Local nTotIte       := 0
	Local nItAtu        := 0
	Local nTotPed       := 0
	Local nPedAtu       := 0
	//Consultas SQL
	Local cQryPed       := ""
	Local cQryIte       := ""
	//Valores de Impostos
	Local nBasICM       := 0
	Local nValICM       := 0
	Local nValIPI       := 0
	Local nAlqICM       := 0
	Local nAlqIPI       := 0
	Local nValSol       := 0
	Local nBasSol       := 0
	Local nPrcUniSol    := 0
	Local nTotSol       := 0
	Local cPedDe := aParams[1]
	Local cPedAt := aParams[2]
	Local cCliDe := aParams[3]
	Local cCliAt := aParams[4]
	Local cVndDe := aParams[5]
	Local cVndAt := aParams[6]
	Local lAPPA  := aParams[7]

	//Variáveis do Relatório
	Local cNomeRel      := "pedido_venda_"+FunName()+"_"+RetCodUsr()+"_"+dToS(Date())+"_"+StrTran(Time(), ":", "-")
	Private oPrintPvt
	Private cHoraEx     := Time()
	Private nPagAtu     := 1
	Private aDuplicatas := {}
	//Linhas e colunas
	Private nLinAtu     := 0
	Private nLinFin     := 700 //780   --  alterado o tamanho do fonte de 7 para 10 no detalhes por isso tirei 80
	Private nColIni     := 010
	Private nColFin     := 570
	Private nColMeio    := (nColFin-nColIni)/2
	//Totalizadores
	Private nTotFrete   := 0
	Private nValorTot   := 0
	Private nTotalST    := 0
	Private nTotVal     := 0
	Private nTotIPI     := 0
	Private nValDesc	:= 0
	Private nQtdEmb		:= 0
	
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1)) //B1_FILIAL+B1_COD
	SB1->(DbGoTop())
	DbSelectArea("SC5")

	If !IsBlind()
		cTempPtch := GetTempPath()
	Else
		cTempPtch := 'C:\Temp\'
	EndIf

	//Criando o objeto de impressão
	oPrintPvt := FWMSPrinter():New(cNomeRel, IMP_PDF, .F., /*cStartPath*/, .T., , @oPrintPvt, , , , , .T.)
	oPrintPvt:cPathPDF := cTempPtch
	oPrintPvt:SetResolution(72)
	oPrintPvt:SetPortrait()
	oPrintPvt:SetPaperSize(DMPAPER_A4)
	oPrintPvt:SetMargin(60, 60, 60, 60)
	
	//Selecionando os pedidos
	cQryPed := " SELECT "                                        + CRLF
	cQryPed += "    C5_FILIAL, "                                 + CRLF
	cQryPed += "    C5_NUM, "                                    + CRLF
	cQryPed += "    C5_EMISSAO, "                                + CRLF
	cQryPed += "    C5_CLIENTE, "                                + CRLF
	cQryPed += "    C5_LOJACLI, "                                + CRLF
	cQryPed += "    C5_TABELA, "                                 + CRLF
	cQryPed += "    ISNULL(A1_NREDUZ, '') AS A1_NREDUZ, "        + CRLF
	cQryPed += "    ISNULL(A1_NOME, '') AS A1_NOME, "            + CRLF
	cQryPed += "    ISNULL(A1_PESSOA, '') AS A1_PESSOA, "        + CRLF
	cQryPed += "    ISNULL(A1_CGC, '') AS A1_CGC, "              + CRLF
	cQryPed += "    ISNULL(A1_END, '') AS A1_END, "              + CRLF
	cQryPed += "    ISNULL(A1_BAIRRO, '') AS A1_BAIRRO, "        + CRLF
	cQryPed += "    ISNULL(A1_MUN, '') AS A1_MUN, "              + CRLF
	cQryPed += "    ISNULL(A1_EST, '') AS A1_EST, "              + CRLF
	cQryPed += "    ISNULL(A1_CEP, '') AS A1_CEP, "              + CRLF
	cQryPed += "    ISNULL(A1_CONTATO, '') AS A1_CONTATO, "      + CRLF
	cQryPed += "    ISNULL(A1_DDD, '') AS A1_DDD, "              + CRLF
	cQryPed += "    ISNULL(A1_TEL, '') AS A1_TEL, "              + CRLF
	cQryPed += "    ISNULL(A1_END, '') AS A1_ENDENT, "           + CRLF
	cQryPed += "    ISNULL(A1_BAIRRO, '') AS A1_BAIRROE, "       + CRLF
	cQryPed += "    ISNULL(A1_MUN, '') AS A1_MUNE, "             + CRLF
	cQryPed += "    C5_CONDPAG, "                                + CRLF
	cQryPed += "    ISNULL(E4_DESCRI, '') AS E4_DESCRI, "        + CRLF
	cQryPed += "    C5_TRANSP, "                                 + CRLF
	cQryPed += "    ISNULL(A4_NOME, '') AS A4_NOME, "            + CRLF
	cQryPed += "    ISNULL(A4_END, '') AS A4_END, "              + CRLF
	cQryPed += "    ISNULL(A4_BAIRRO, '') AS A4_BAIRRO, "        + CRLF
	cQryPed += "    ISNULL(A4_MUN, '') AS A4_MUN, "              + CRLF
	cQryPed += "    ISNULL(A4_EST, '') AS A4_EST, "              + CRLF
	cQryPed += "    ISNULL(A4_CEP, '') AS A4_CEP, "              + CRLF
	cQryPed += "    ISNULL(A4_DDD, '') AS A4_DDD, "              + CRLF
	cQryPed += "    ISNULL(A4_TEL, '') AS A4_TEL, "              + CRLF
	cQryPed += "    C5_VEND1, "                                  + CRLF
	cQryPed += "    ISNULL(A3_NREDUZ, '') AS A3_NREDUZ, "        + CRLF
	cQryPed += "    C5_TPFRETE, "                                + CRLF
	cQryPed += "    C5_FRETE, "                                  + CRLF
	cQryPed += "    C5_PESOL, "                                  + CRLF
	cQryPed += "    C5_PBRUTO, "                                 + CRLF
	cQryPed += "    C5_MENNOTA, "                                + CRLF
	cQryPed += "    SC5.R_E_C_N_O_ AS C5REC "                    + CRLF
	cQryPed += " FROM "                                          + CRLF
	cQryPed += "    "+RetSQLName("SC5")+" SC5 "                  + CRLF
	cQryPed += "    LEFT JOIN "+RetSQLName("SA1")+" SA1 ON ( "   + CRLF
	cQryPed += "        A1_FILIAL   = '"+FWxFilial("SA1")+"' "   + CRLF
	cQryPed += "        AND A1_COD  = SC5.C5_CLIENTE "           + CRLF
	cQryPed += "        AND A1_LOJA = SC5.C5_LOJACLI "           + CRLF

	cQryPed += "    AND A1_COD >= '"+cCliDe+"' "     	         + CRLF
	cQryPed += "    AND A1_COD <= '"+cCliAt+"' "     	         + CRLF

	cQryPed += "        AND SA1.D_E_L_E_T_ = ' ' "               + CRLF
	cQryPed += "    ) "                                          + CRLF
	cQryPed += "    LEFT JOIN "+RetSQLName("SE4")+" SE4 ON ( "   + CRLF
	cQryPed += "        E4_FILIAL     = '"+FWxFilial("SE4")+"' " + CRLF
	cQryPed += "        AND E4_CODIGO = SC5.C5_CONDPAG "         + CRLF
	cQryPed += "        AND SE4.D_E_L_E_T_ = ' ' "               + CRLF
	cQryPed += "    ) "                                          + CRLF
	cQryPed += "    LEFT JOIN "+RetSQLName("SA4")+" SA4 ON ( "   + CRLF
	cQryPed += "        A4_FILIAL  = '"+FWxFilial("SA4")+"' "    + CRLF
	cQryPed += "        AND A4_COD = SC5.C5_TRANSP "             + CRLF
	cQryPed += "        AND SA4.D_E_L_E_T_ = ' ' "               + CRLF
	cQryPed += "    ) "                                          + CRLF
	cQryPed += "    LEFT JOIN "+RetSQLName("SA3")+" SA3 ON ( "   + CRLF
	cQryPed += "        A3_FILIAL  = '"+FWxFilial("SA3")+"' "    + CRLF
	cQryPed += "        AND A3_COD = SC5.C5_VEND1 "              + CRLF
	cQryPed += "        AND A3_COD>='"+cVndDe+"' AND A3_COD<='"+cVndAt+"'" + CRLF 
	
	cQryPed += "        AND SA3.D_E_L_E_T_ = ' ' "               + CRLF
	cQryPed += "    ) "                                          + CRLF
	cQryPed += " WHERE "                                         + CRLF
	cQryPed += "    C5_FILIAL   = '"+FWxFilial("SC5")+"' "       + CRLF
	cQryPed += "    AND C5_NUM >= '"+cPedDe+"' "                 + CRLF
	cQryPed += "    AND C5_NUM <= '"+cPedAt+"' "                 + CRLF
	cQryPed += "    AND SC5.D_E_L_E_T_ = ' ' "                   + CRLF

	TCQuery cQryPed New Alias "QRY_PED"
	TCSetField("QRY_PED", "C5_EMISSAO", "D")
	
	Count To nTotPed
	oProc:SetRegua1(nTotPed)
	
	//Somente se houver pedidos
	If nTotPed != 0
	
		//Enquanto houver pedidos
		QRY_PED->(DbGoTop())
		While ! QRY_PED->(EoF())
			If cZeraPag == "1"
				nPagAtu := 1
			EndIf
			nPedAtu++
			oProc:IncRegua1("Processando o pedido "+cValToChar(nPedAtu)+" de "+cValToChar(nTotPed)+"...")
			oProc:SetRegua2(1)
			oProc:IncRegua2("...")
			
			//Imprime o cabeçalho
			fImpCab()
			
			//Inicializa os calculos de impostos
			nItAtu   := 0
			nTotIte  := 0
			nTotalST := 0
			nTotIPI  := 0
			nQtdEmb  := 0
			SC5->(DbGoTo(QRY_PED->C5REC))
			MaFisIni(SC5->C5_CLIENTE,;                   // 01 - Codigo Cliente/Fornecedor
				SC5->C5_LOJACLI,;                        // 02 - Loja do Cliente/Fornecedor
				Iif(SC5->C5_TIPO $ "D;B", "F", "C"),;    // 03 - C:Cliente , F:Fornecedor
				SC5->C5_TIPO,;                           // 04 - Tipo da NF
				SC5->C5_TIPOCLI,;                        // 05 - Tipo do Cliente/Fornecedor
				MaFisRelImp("MT100", {"SF2", "SD2"}),;   // 06 - Relacao de Impostos que suportados no arquivo
				,;                                       // 07 - Tipo de complemento
				,;                                       // 08 - Permite Incluir Impostos no Rodape .T./.F.
				"SB1",;                                  // 09 - Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
				"MATA461")                               // 10 - Nome da rotina que esta utilizando a funcao
			
			//Seleciona agora os itens do pedido
			cQryIte := " SELECT "                                      + CRLF
			cQryIte += "    C6_PRODUTO, "                              + CRLF
			cQryIte += "    ISNULL(B1_DESC, '') AS B1_DESC, "          + CRLF
			cQryIte += "    C6_UM, "                                   + CRLF
			cQryIte += "    C6_ENTREG, "                               + CRLF
			cQryIte += "    C6_TES, "                                  + CRLF
			cQryIte += "    C6_QTDVEN, "                               + CRLF
			cQryIte += "    C6_SEGUM, "                                + CRLF
			  
			cQryIte += "    C6_PRUNIT, "                               + CRLF
			cQryIte += "    C6_VALDESC, "                              + CRLF
			cQryIte += "    C6_NFORI, "                                + CRLF
			cQryIte += "    C6_SERIORI, "                              + CRLF
			cQryIte += "    C6_VALOR, "                                + CRLF
			cQryIte += "    ISNULL(B1_CONV, '') AS B1_CONV, "          + CRLF
			cQryIte += "    C6_UNSVEN AS C6_UNSVEN, "                  + CRLF
			cQryIte += "    C6_LOTECTL AS C6_LOTECTL"                  + CRLF
			
			cQryIte += " FROM "                                        + CRLF
			cQryIte += "    "+RetSQLName("SC6")+" SC6 "                + CRLF
			cQryIte += "    LEFT JOIN "+RetSQLName("SB1")+" SB1 ON ( " + CRLF
			cQryIte += "        B1_FILIAL = '"+FWxFilial("SB1")+"' "   + CRLF
			cQryIte += "        AND B1_COD = SC6.C6_PRODUTO "          + CRLF
			cQryIte += "        AND SB1.D_E_L_E_T_ = ' ' "             + CRLF
			cQryIte += "    ) "                                        + CRLF
			cQryIte += " WHERE "                                       + CRLF
			cQryIte += "    C6_FILIAL = '"+FWxFilial("SC6")+"' "       + CRLF
			cQryIte += "    AND C6_NUM = '"+QRY_PED->C5_NUM+"' "       + CRLF
			cQryIte += "    AND SC6.D_E_L_E_T_ = ' ' "                 + CRLF
			cQryIte += " ORDER BY "                                    + CRLF
			cQryIte += "    C6_ITEM "                                  + CRLF
			TCQuery cQryIte New Alias "QRY_ITE"
			TCSetField("QRY_ITE", "C6_ENTREG", "D")
			Count To nTotIte
			nValorTot := 0
			nValDesc  := 0
			oProc:SetRegua2(nTotIte)
			
			//Enquanto houver itens
			QRY_ITE->(DbGoTop())
			While ! QRY_ITE->(EoF())
				nItAtu++
				oProc:IncRegua2("Calculando impostos - item "+cValToChar(nItAtu)+" de "+cValToChar(nTotIte)+"...")
				
				//Pega os tratamentos de impostos
				SB1->(DbSeek(FWxFilial("SB1")+QRY_ITE->C6_PRODUTO))
				MaFisAdd(QRY_ITE->C6_PRODUTO,;    // 01 - Codigo do Produto                    ( Obrigatorio )
					QRY_ITE->C6_TES,;             // 02 - Codigo do TES                        ( Opcional )
					QRY_ITE->C6_QTDVEN,;          // 03 - Quantidade                           ( Obrigatorio )
					QRY_ITE->C6_PRUNIT,;          // 04 - Preco Unitario                       ( Obrigatorio )
					QRY_ITE->C6_VALDESC,;         // 05 - Desconto
					QRY_ITE->C6_NFORI,;           // 06 - Numero da NF Original                ( Devolucao/Benef )
					QRY_ITE->C6_SERIORI,;         // 07 - Serie da NF Original                 ( Devolucao/Benef )
					0,;                           // 08 - RecNo da NF Original no arq SD1/SD2
					0,;                           // 09 - Valor do Frete do Item               ( Opcional )
					0,;                           // 10 - Valor da Despesa do item             ( Opcional )
					0,;                           // 11 - Valor do Seguro do item              ( Opcional )
					0,;                           // 12 - Valor do Frete Autonomo              ( Opcional )
					QRY_ITE->C6_VALOR,;           // 13 - Valor da Mercadoria                  ( Obrigatorio )
					0,;                           // 14 - Valor da Embalagem                   ( Opcional )
					SB1->(RecNo()),;              // 15 - RecNo do SB1
					0)                            // 16 - RecNo do SF4
				
				nQtdPeso := QRY_ITE->C6_QTDVEN*SB1->B1_PESO
				nQtdEmb	 := nQtdEmb + QRY_ITE->C6_QTDVEN
				nValDesc := nValDesc + QRY_ITE->C6_VALDESC
				MaFisLoad("IT_VALMERC", QRY_ITE->C6_VALOR, nItAtu)				
				MaFisAlt("IT_PESO", nQtdPeso, nItAtu)
				
				QRY_ITE->(DbSkip())
			EndDo
			
			//Altera dados da Nota
			MaFisAlt("NF_FRETE", SC5->C5_FRETE)
			MaFisAlt("NF_SEGURO", SC5->C5_SEGURO)
			MaFisAlt("NF_DESPESA", SC5->C5_DESPESA) 
			MaFisAlt("NF_AUTONOMO", SC5->C5_FRETAUT)
			If SC5->C5_DESCONT > 0
				MaFisAlt("NF_DESCONTO", Min(MaFisRet(, "NF_VALMERC")-0.01, SC5->C5_DESCONT+MaFisRet(, "NF_DESCONTO")) )
			EndIf
			If SC5->C5_PDESCAB > 0
				MaFisAlt("NF_DESCONTO", A410Arred(MaFisRet(, "NF_VALMERC")*SC5->C5_PDESCAB/100, "C6_VALOR") + MaFisRet(, "NF_DESCONTO"))
			EndIf
			
			//Enquanto houver itens
			oProc:IncRegua2("...")
			oProc:SetRegua2(nTotIte)
			nItAtu := 0
			QRY_ITE->(DbGoTop())
			While ! QRY_ITE->(EoF())
				nItAtu++
				oProc:IncRegua2("Imprimindo item "+cValToChar(nItAtu)+" de "+cValToChar(nTotIte)+"...")
				
				//Pega os tratamentos de impostos
				SB1->(DbSeek(FWxFilial("SB1")+QRY_ITE->C6_PRODUTO))
				
				//Pega os valores
				nBasICM    := MaFisRet(nItAtu, "IT_BASEICM")
				nValICM    := MaFisRet(nItAtu, "IT_VALICM")
				nValIPI    := MaFisRet(nItAtu, "IT_VALIPI")
				nAlqICM    := MaFisRet(nItAtu, "IT_ALIQICM")
				nAlqIPI    := MaFisRet(nItAtu, "IT_ALIQIPI")
				nValSol    := (MaFisRet(nItAtu, "IT_VALSOL") / QRY_ITE->C6_QTDVEN) 
				nBasSol    := MaFisRet(nItAtu, "IT_BASESOL")
				nPrcUniSol := QRY_ITE->C6_PRUNIT + nValSol
				nTotSol    := nPrcUniSol * QRY_ITE->C6_QTDVEN
				nTotalST   += MaFisRet(nItAtu, "IT_VALSOL")
				nTotIPI    += nValIPI
				
				//Imprime os dados
				If cLayout == "1"
					oPrintPvt:SayAlign(nLinAtu, nPosCod , QRY_ITE->C6_PRODUTO,                               oFontDet, 090, 45, , nPadLeft , )
					oPrintPvt:SayAlign(nLinAtu, nPosLote, QRY_ITE->C6_LOTECTL,                               oFontDet, 045, 07, , nPadLeft , )
					oPrintPvt:SayAlign(nLinAtu, nPosDesc, QRY_ITE->B1_DESC,                                  oFontDet, 250, 07, , nPadLeft , )
					oPrintPvt:SayAlign(nLinAtu, nPosUnid, QRY_ITE->C6_UM, 							         oFontDet, 035, 07, , nPadLeft , )
					oPrintPvt:SayAlign(nLinAtu, nPosEmba, Alltrim(Transform(QRY_ITE->B1_CONV, cMaskQtd)), 	 oFontDet, 035, 07, , nPadRight, )
					oPrintPvt:SayAlign(nLinAtu, nPosQuan, Alltrim(Transform(QRY_ITE->C6_QTDVEN, cMaskQtd)),  oFontDet, 035, 07, , nPadRight, )
					oPrintPvt:SayAlign(nLinAtu, nPosQtCx, Alltrim(Transform(QRY_ITE->C6_UNSVEN, cMaskQtd)),  oFontDet, 035, 07, , nPadRight, )
					oPrintPvt:SayAlign(nLinAtu, nPosVUni, Alltrim(Transform(QRY_ITE->C6_PRUNIT, cMaskPrc)),  oFontDet, 035, 07, , nPadRight, )
					oPrintPvt:SayAlign(nLinAtu, nPosDcto, Alltrim(Transform(QRY_ITE->C6_VALDESC, cMaskPad)), oFontDet, 035, 07, , nPadRight, )
					oPrintPvt:SayAlign(nLinAtu, nPosVTot, Alltrim(Transform(QRY_ITE->C6_VALOR, cMaskVlr)),   oFontDet, 060, 07, , nPadRight, )
				
				Else
					oPrintPvt:SayAlign(nLinAtu, nPosCod, QRY_ITE->C6_PRODUTO,                                oFontDet, 040, 07, , nPadLeft, )
					oPrintPvt:SayAlign(nLinAtu, nPosLote, QRY_ITE->C6_LOTECTL,                               oFontDet, 035, 07, , nPadLeft, )
					oPrintPvt:SayAlign(nLinAtu, nPosDesc, QRY_ITE->B1_DESC,                                  oFontDet, 200, 07, , nPadLeft, )
					oPrintPvt:SayAlign(nLinAtu, nPosUnid, QRY_ITE->C6_UM,                                    oFontDet, 030, 07, , nPadLeft, )
					oPrintPvt:SayAlign(nLinAtu, nPosQuan, Alltrim(Transform(QRY_ITE->C6_QTDVEN, cMaskQtd)),  oFontDet, 030, 07, , nPadRight, )
					oPrintPvt:SayAlign(nLinAtu, nPosVUni, Alltrim(Transform(QRY_ITE->C6_PRUNIT, cMaskPrc)),  oFontDet, 030, 07, , nPadRight, )
					oPrintPvt:SayAlign(nLinAtu, nPosVTot, Alltrim(Transform(QRY_ITE->C6_VALOR, cMaskVlr)),   oFontDet, 060, 07, , nPadRight, )
					oPrintPvt:SayAlign(nLinAtu, nPosBIcm, Alltrim(Transform(nBasICM, cMaskPad)),             oFontDet, 030, 07, , nPadRight, )
					oPrintPvt:SayAlign(nLinAtu, nPosVIcm, Alltrim(Transform(nValICM, cMaskPad)),             oFontDet, 030, 07, , nPadRight, )
					oPrintPvt:SayAlign(nLinAtu, nPosVIPI, Alltrim(Transform(nValIPI, cMaskPad)),             oFontDet, 030, 07, , nPadRight, )
					oPrintPvt:SayAlign(nLinAtu, nPosAIcm, Alltrim(Transform(nAlqICM, cMaskPad)),             oFontDet, 030, 07, , nPadRight, )
					//oPrintPvt:SayAlign(nLinAtu, nPosAIpi, Alltrim(Transform(nAlqIPI, cMaskPad)),             oFontDet, 030, 07, , nPadRight, )
				EndIf
				nLinAtu += 7
				
				//Se por acaso atingiu o limite da página, finaliza, e começa uma nova página
				If nLinAtu >= nLinFin
					fImpRod()
					fImpCab()
				EndIf
				
				nValorTot += QRY_ITE->C6_VALOR
				QRY_ITE->(DbSkip())
			EndDo
			nTotFrete := MaFisRet(, "NF_FRETE")
			nTotVal := MaFisRet(, "NF_TOTAL")
			fMontDupl()
			QRY_ITE->(DbCloseArea())
			MaFisEnd()
			
			//Imprime o total do pedido
			fImpTot()
			
			//Se tiver mensagem da observação
			If !Empty(QRY_PED->C5_MENNOTA)
				fMsgObs()
			EndIf
			
			//Se deverá ser impresso as duplicatas
			If cImpDupl == "1"
				fImpDupl()
			EndIf
			
			//Dados da Transportadora
			If !Empty(QRY_PED->A4_NOME)
				fTransp()
			EndIf	
			
			//Imprime o rodapé
			fImpRod()
			
			QRY_PED->(DbSkip())
		EndDo
		
		MAFISEND()
		//Gera o pdf para visualização
		oPrintPvt:Preview()
	
	Else
		MsgStop("Não há pedidos!", "Atenção")
	EndIf
	QRY_PED->(DbCloseArea())
Return

/*---------------------------------------------------------------------*
 | Func:  fImpCab                                                      |
 | Desc:  Função que imprime o cabeçalho                               |
 *---------------------------------------------------------------------*/

Static Function fImpCab()
	 
	Local nLinCab     := 025
	Local nLinCabOrig := nLinCab
	//Local nColMeiPed  := nColMeio+8+((nColMeio-nColIni)/2)
	Local lCNPJ       := (QRY_PED->A1_PESSOA != "F")
	Local cCliAux     := QRY_PED->C5_CLIENTE+" "+QRY_PED->C5_LOJACLI+" - "+QRY_PED->A1_NOME
	Local cCGC        := ""
	//Local cFretePed   := ""
	//Dados da empresa
	Local cEmpresa    := Iif(Empty(SM0->M0_NOMECOM), Alltrim(SM0->M0_NOME), Alltrim(SM0->M0_NOMECOM))
	Local cEmpTel     := SM0->M0_TEL //Alltrim(Transform(SubStr(SM0->M0_TEL, 3, Len(SM0->M0_TEL)), cMaskTel))
//	Local cEmpFax     := Alltrim(Transform(SubStr(SM0->M0_FAX, 3, Len(SM0->M0_FAX)), cMaskTel))
	Local cEmpCidade  := AllTrim(SM0->M0_CIDENT)+" / "+SM0->M0_ESTENT
	Local cEmpCnpj    := Alltrim(Transform(SM0->M0_CGC, cMaskCNPJ))
	Local cEmpCep     := Alltrim(Transform(SM0->M0_CEPENT, cMaskCEP))
	Local cEndereco   := Alltrim(QRY_PED->A1_END) + "  -  Bairro: " + Alltrim(QRY_PED->A1_BAIRRO)
	Local cMunicipio  := Alltrim(QRY_PED->A1_MUN) + " (" + QRY_PED->A1_EST + ")  -  CEP: " + cEmpCep
	Local cContato    := "( " + QRY_PED->A1_DDD + ") " + Alltrim(QRY_PED->A1_TEL) + "   -   Contato: " + Alltrim(QRY_PED->A1_CONTATO)

	//Iniciando Página
	oPrintPvt:StartPage()
	
	//Dados da Empresa
	oPrintPvt:Box(nLinCab, nColIni, nLinCab + 075, nColMeio-3)
	oPrintPvt:Line(nLinCab+nTamFundo, nColIni, nLinCab+nTamFundo, nColMeio-3)
	nLinCab += nTamFundo - 5
	oPrintPvt:SayAlign(nLinCab-10, nColIni+5, "Emitente:",                                      oFontTit,  060, nTamFundo, nCorAzul, nPadLeft, )
	nLinCab += 5
	oPrintPvt:SayBitmap(nLinCab+3, nColIni+5, cLogoEmp, 054, 054)
	oPrintPvt:SayAlign(nLinCab,    nColIni+65, "Empresa:",                                      oFontCabN, 060, 07, , nPadLeft, )
	oPrintPvt:SayAlign(nLinCab,    nColIni+95, cEmpresa,                                        oFontCab,  220, 07, , nPadLeft, )
	nLinCab += 7
	oPrintPvt:SayAlign(nLinCab,   nColIni+65, "CNPJ:",                                          oFontCabN, 060, 07, , nPadLeft, )
	oPrintPvt:SayAlign(nLinCab,   nColIni+87, cEmpCnpj,                                         oFontCab,  120, 07, , nPadLeft, )
	nLinCab += 7
	oPrintPvt:SayAlign(nLinCab,   nColIni+65, "Cidade:",                                        oFontCabN, 060, 07, , nPadLeft, )
	oPrintPvt:SayAlign(nLinCab,   nColIni+95, cEmpCidade,                                       oFontCab,  120, 07, , nPadLeft, )
	nLinCab += 7
	oPrintPvt:SayAlign(nLinCab,   nColIni+65, "CEP:",                                           oFontCabN, 060, 07, , nPadLeft, )
	oPrintPvt:SayAlign(nLinCab,   nColIni+85, cEmpCep,                                          oFontCab,  120, 07, , nPadLeft, )
	nLinCab += 7
	oPrintPvt:SayAlign(nLinCab,   nColIni+65, "Telefone:",                                      oFontCabN, 060, 07, , nPadLeft, )
	oPrintPvt:SayAlign(nLinCab,   nColIni+95, cEmpTel,                                          oFontCab,  120, 07, , nPadLeft, )
	nLinCab += 7
	//oPrintPvt:SayAlign(nLinCab,   nColIni+65, "FAX:",                                           oFontCabN, 060, 07, , nPadLeft, )
	//oPrintPvt:SayAlign(nLinCab,   nColIni+85, cEmpFax,                                          oFontCab,  120, 07, , nPadLeft, )
	nLinCab += 7
	oPrintPvt:SayAlign(nLinCab,   nColIni+65, "e-Mail:",                                        oFontCabN, 060, 07, , nPadLeft, )
	oPrintPvt:SayAlign(nLinCab,   nColIni+87, cEmpEmail,                                        oFontCab,  120, 07, , nPadLeft, )
	nLinCab += 7
	oPrintPvt:SayAlign(nLinCab,   nColIni+65, "Home Page:",                                     oFontCabN, 060, 07, , nPadLeft, )
	oPrintPvt:SayAlign(nLinCab,   nColIni+105, cEmpSite,                                        oFontCab,  120, 07, , nPadLeft, )
	nLinCab += 7
	
	//Dados do Pedido
	nLinCab := nLinCabOrig
	oPrintPvt:Box(nLinCab, nColMeio+3, nLinCab + 075, nColFin)
	oPrintPvt:Line(nLinCab+nTamFundo, nColMeio+3, nLinCab+nTamFundo, nColFin)
	nLinCab += nTamFundo - 5
	oPrintPvt:SayAlign(nLinCab-10, nColMeio+8,  "Pedido: " ,																oFontTit,  060, nTamFundo, nCorAzul, nPadLeft, )
	oPrintPvt:SayAlign(nLinCab-05, nColMeio+70, "No. " + QRY_PED->C5_NUM + " - Emissão: " +  dToC(QRY_PED->C5_EMISSAO),		oFontCabN,  210, 07, , nPadRight, )
	nLinCab += 5
	oPrintPvt:SayAlign(nLinCab,    nColMeio+8,  "Cliente:",                                  								oFontCabN, 060, 07, , nPadLeft, )
	oPrintPvt:SayAlign(nLinCab,    nColMeio+52, cCliAux,                                									oFontCab,  210, 07, , nPadLeft, )
	nLinCab += 7
	oPrintPvt:SayAlign(nLinCab,    nColMeio+8,  "Endereço:",                                  								oFontCabN, 060, 07, , nPadLeft, )
	oPrintPvt:SayAlign(nLinCab,    nColMeio+50, cEndereco,                      											oFontCab,  210, 07, , nPadLeft, )
	nLinCab += 7
	oPrintPvt:SayAlign(nLinCab,    nColMeio+8,  "Cidade:",                                     								oFontCabN, 060, 07, , nPadLeft, )
	oPrintPvt:SayAlign(nLinCab,    nColMeio+34, cMunicipio,                                       						 	oFontCab, 210, 07, , nPadLeft, )
	nLinCab += 7
	cCGC := QRY_PED->A1_CGC
	If lCNPJ
		cCGC := Iif(!Empty(cCGC), Alltrim(Transform(cCGC, cMaskCNPJ)), "-")
		oPrintPvt:SayAlign(nLinCab, nColMeio+8, "CNPJ:",                                        							oFontCabN, 060, 07, , nPadLeft, )
	Else
		cCGC := Iif(!Empty(cCGC), Alltrim(Transform(cCGC, cMaskCPF)), "-")
		oPrintPvt:SayAlign(nLinCab, nColMeio+8, "CPF:",                                         							oFontCabN, 060, 07, , nPadLeft, )
	EndIf
	oPrintPvt:SayAlign(nLinCab, nColMeio+32, cCGC,                                             		 						oFontCab,  060, 07, , nPadLeft, )
	nLinCab += 7
	oPrintPvt:SayAlign(nLinCab, nColMeio+8,  "Telefone:",                                    								oFontCabN, 060, 07, , nPadLeft, )
	oPrintPvt:SayAlign(nLinCab, nColMeio+52, cContato,     																	oFontCab,  210, 07, , nPadLeft, )
	nLinCab += 7
	oPrintPvt:SayAlign(nLinCab, nColMeio+8, "Tabela:",                                  									oFontCabN, 060, 07, , nPadLeft, )
	oPrintPvt:SayAlign(nLinCab, nColMeio+62, QRY_PED->C5_TABELA,       														oFontCab,  120, 07, , nPadLeft, )
	nLinCab += 7
	oPrintPvt:SayAlign(nLinCab, nColMeio+8, "Vendedor:",                                        							oFontCabN, 060, 07, , nPadLeft, )
	oPrintPvt:SayAlign(nLinCab, nColMeio+44, QRY_PED->C5_VEND1 + " "+QRY_PED->A3_NREDUZ,        							oFontCab,  120, 07, , nPadLeft, )
	nLinCab += 7
	oPrintPvt:SayAlign(nLinCab, nColMeio+8,  "Cond.Pagto.:",                                    oFontCabN, 060, 07, , nPadLeft, )
	oPrintPvt:SayAlign(nLinCab, nColMeio+52, QRY_PED->C5_CONDPAG +" - "+QRY_PED->E4_DESCRI,     oFontCab,  120, 07, , nPadLeft, )
	
	//oPrintPvt:SayAlign(nLinCab, nColMeio+8, "Frete:",                                           oFontCabN, 060, 07, , nPadLeft, )
	If QRY_PED->C5_TPFRETE == "C"
		cFretePed := "CIF"
	ElseIf QRY_PED->C5_TPFRETE == "F"
		cFretePed := "FOB"
	ElseIf QRY_PED->C5_TPFRETE == "T"
		cFretePed := "Terceiros"
	Else
		cFretePed := "Sem Frete"
	EndIf
	cFretePed += " - "+Alltrim(Transform(QRY_PED->C5_FRETE, cMaskFrete))
	//oPrintPvt:SayAlign(nLinCab, nColMeio+28, cFretePed,                                         oFontCab,  060, 07, , nPadLeft, )
	
	//Código de barras
	nLinCab := nLinCabOrig
	If cTipoBar $ "1;2"
		If cTipoBar == "1"
			cCodBar := QRY_PED->C5_NUM
		ElseIf cTipoBar == "2"
			cCodBar := QRY_PED->C5_FILIAL+QRY_PED->C5_NUM
		EndIf
	//	oPrintPvt:Code128C(nLinCab+30+nTamFundo, nColFin-80, cCodBar, 28)
	//6	oPrintPvt:SayAlign(nLinCab+32+nTamFundo, nColFin-80, cCodBar, oFontRod, 080, 07, , nPadLeft, )
	EndIf
	
	//Título
	nLinCab := nLinCabOrig + 080
	oPrintPvt:Box(nLinCab, nColIni, nLinCab + nTamFundo, nColFin)
	nLinCab += nTamFundo - 5
	oPrintPvt:SayAlign(nLinCab-10, nColIni, "Pedido de Venda:", oFontTit, nColFin-nColIni, nTamFundo, nCorAzul, nPadCenter, )
	
	//Linha Separatório
	nLinCab += 6
	
	//Cabeçalho com descrições das colunas
	nLinCab += 3
	If cLayout == "1"
		oPrintPvt:SayAlign(nLinCab, nPosCod,  "Cód.Prod.", oFontDetN, 045, 07, , nPadLeft, )
		oPrintPvt:SayAlign(nLinCab, nPosLote,  "No.Lote" , oFontDetN, 050, 07, , nPadLeft, )
		oPrintPvt:SayAlign(nLinCab, nPosDesc, "Descrição", oFontDetN, 250, 07, , nPadLeft, )
		oPrintPvt:SayAlign(nLinCab, nPosUnid, "Unid."    , oFontDetN, 035, 07, , nPadLeft, )
		oPrintPvt:SayAlign(nLinCab, nPosEmba, "Embal."   , oFontDetN, 035, 07, , nPadRight, )
		oPrintPvt:SayAlign(nLinCab, nPosQuan, "Quant."   , oFontDetN, 035, 07, , nPadRight, )
		oPrintPvt:SayAlign(nLinCab, nPosQtCx, "Qtd Cxs." , oFontDetN, 035, 07, , nPadRight, )
		oPrintPvt:SayAlign(nLinCab, nPosVUni, "Vl.Unit." , oFontDetN, 035, 07, , nPadRight, )
		oPrintPvt:SayAlign(nLinCab, nPosDcto, "Vl.Desc." , oFontDetN, 035, 07, , nPadRight, )
		oPrintPvt:SayAlign(nLinCab, nPosVTot, "Vl.Total",  oFontDetN, 060, 07, , nPadRight, )

	Else
		oPrintPvt:SayAlign(nLinCab, nPosCod, "Cód.Prod.",  oFontDetN, 040, 07, , nPadLeft, )
		oPrintPvt:SayAlign(nLinCab, nPosLote,  "No.Lote" , oFontDetN, 030, 07, , nPadLeft, )
		oPrintPvt:SayAlign(nLinCab, nPosDesc, "Descrição", oFontDetN, 200, 07, , nPadLeft, )
		oPrintPvt:SayAlign(nLinCab, nPosUnid, "Uni.Med.",  oFontDetN, 030, 07, , nPadLeft, )
		oPrintPvt:SayAlign(nLinCab, nPosQuan, "Quant.",    oFontDetN, 030, 07, , nPadRight, )
		oPrintPvt:SayAlign(nLinCab, nPosVUni, "Vl.Unit.",  oFontDetN, 030, 07, , nPadRight, )
		oPrintPvt:SayAlign(nLinCab, nPosVTot, "Vl.Total",  oFontDetN, 060, 07, , nPadRight, )
		oPrintPvt:SayAlign(nLinCab, nPosBIcm, "BC.ICMS",   oFontDetN, 030, 07, , nPadRight, )
		oPrintPvt:SayAlign(nLinCab, nPosVIcm, "Vl.ICMS",   oFontDetN, 030, 07, , nPadRight, )
		oPrintPvt:SayAlign(nLinCab, nPosVIPI, "Vl.IPI",    oFontDetN, 030, 07, , nPadRight, )
		oPrintPvt:SayAlign(nLinCab, nPosAIcm, "A.ICMS",    oFontDetN, 030, 07, , nPadRight, )
		//oPrintPvt:SayAlign(nLinCab, nPosAIpi, "A.IPI",     oFontDetN, 030, 07, , nPadRight, )
	EndIf
	
	//Atualizando a linha inicial do relatório
	nLinAtu := nLinCab + 8
Return

/*---------------------------------------------------------------------*
 | Func:  fImpRod                                                      |
 | Desc:  Função que imprime o rodapé                                  |
 *---------------------------------------------------------------------*/

Static Function fImpRod()
	Local nLinRod:= nLinFin + 10
	Local cTexto := ""
	
	//oPrintPvt:Code128C(nLinRod-9, nColIni, cCodBar, 28)
	//Linha Separatória
	oPrintPvt:Line(nLinRod, nColIni, nLinRod, nColFin)
	nLinRod += 3
	
	//Dados da Esquerda
	cTexto := "Pedido: "+QRY_PED->C5_NUM+"    |    "+dToC(dDataBase)+"     "+cHoraEx+"     "+FunName()+"     "+cUserName
	oPrintPvt:SayAlign(nLinRod, nColIni,    cTexto, oFontRod, 250, 07, , nPadLeft, )
	
	//Direita
	cTexto := "Página "+cValToChar(nPagAtu)
	oPrintPvt:SayAlign(nLinRod, nColFin-40, cTexto, oFontRod, 040, 07, , nPadRight, )
	
	//Finalizando a página e somando mais um
	oPrintPvt:EndPage()
	nPagAtu++
Return

/*---------------------------------------------------------------------*
 | Func:  fLogoEmp                                                     |
 | Desc:  Função que retorna o logo da empresa (igual a DANFE)         |
 *---------------------------------------------------------------------*/

Static Function fLogoEmp()
	Local cGrpCompany := AllTrim(FWGrpCompany())
	Local cCodEmpGrp  := AllTrim(FWCodEmp())
	Local cUnitGrp    := AllTrim(FWUnitBusiness())
	Local cFilGrp     := AllTrim(FWFilial())
	Local cLogo       := ""
	Local cCamFim     := IIf(!IsBlind(),GetTempPath(),'C:\Temp\')  
	Local cStart      := GetSrvProfString("Startpath", "")

	//Se tiver filiais por grupo de empresas
	If !Empty(cUnitGrp)
		cDescLogo	:= cGrpCompany + cCodEmpGrp + cUnitGrp + cFilGrp
		
	//Senão, será apenas, empresa + filial
	Else
		cDescLogo	:= cEmpAnt + cFilAnt
	EndIf
	
	//Pega a imagem
	cLogo := cStart + "lgrl01.bmp" //"LG_ROSE" + cDescLogo + ".BMP"
	
	//Se o arquivo não existir, pega apenas o da empresa, desconsiderando a filial
	If !File(cLogo)
		cLogo	:= cStart + "LG_ROSE" + ".BMP"
	EndIf
	
	//Copia para a temporária do s.o.
	If IsBlind()
		__CopyFile(cLogo, cCamFim)
	Else
		CpyS2T(cLogo, cCamFim)
	EndIf
	
	cLogo := cCamFim + StrTran(cLogo, cStart, "")
	
	//Se o arquivo não existir na temporária, espera meio segundo para terminar a cópia
	If !File(cLogo)
		Sleep(500)
	EndIf
Return cLogo

/*---------------------------------------------------------------------*
 | Func:  fMudaLayout                                                  |
 | Desc:  Função que muda as variáveis das colunas do layout           |
 *---------------------------------------------------------------------*/

Static Function fMudaLayout()
	oFontRod   := TFont():New(cNomeFont, , -06, , .F.)
	oFontTit   := TFont():New(cNomeFont, , -13, , .T.)
	oFontCab   := TFont():New(cNomeFont, , -07, , .F.)
	oFontCabN  := TFont():New(cNomeFont, , -07, , .T.)
	
	If cLayout == "1"
		nPosCod  := 0010 //Código do Produto 
		nPosLote := 0050 //Número do Lote do Produto
		nPosDesc := 0105 //Descrição
		nPosUnid := 0295 //Unidade de Medida
		nPosEmba := 0310 //Quantidade na embalabem
		nPosQuan := 0355 //Quantidade
		nPosQtCx := 0400 //Quantidade de Caixas
		nPosVUni := 0445 //Valor Unitário
		nPosDcto := 0480 //Valor do Desconto do item
		nPosVTot := 0500 //Valor Total
		
/*/
		nPosCod  := 0010 //Código do Produto 
		nPosLote := 0040 //Número do Lote do Produto
		nPosDesc := 0075 //Descrição
		nPosQuan := 0275 //Quantidade
		nPosVUni := 0300 //Valor Unitario
		nPosSTUn := 0325 //Valor Unitário ST
		nPosSTVl := 0350 //Valor Unitário + ST
		nPosSTBa := 0375 //Base do ST
		nPosVTot := 0400 //Valor Total
		nPosSTTo := 0450 //Valor Total ST
		nPosBIcm := 0500 //Base Calculo ICMS
		nPosVIcm := 0525 //Valor ICMS
		//nPosAIcm := 0520 //Aliquota ICMS
/*/




		oFontDet   := TFont():New(cNomeFont, , -10, , .F.)
		oFontDetN  := TFont():New(cNomeFont, , -10, , .T.)
		
	Else
		nPosCod  := 0010 //Código do Produto 
		nPosLote := 0040 //Número do Lote do Produto
		nPosDesc := 0080 //Descrição
		nPosUnid := 0280 //Unidade de Medida
		nPosQuan := 0310 //Quantidade
		nPosVUni := 0340 //Valor Unitario
		nPosVTot := 0370 //Valor Total
		nPosBIcm := 0430 //Base Calculo ICMS
		nPosVIcm := 0460 //Valor ICMS
		nPosVIPI := 0490 //Valor Ipi
		nPosAIcm := 0520 //Aliquota ICMS
		//nPosAIpi := 0520 //Aliquota IPI
		
		oFontDet   := TFont():New(cNomeFont, , -07, , .F.)
		oFontDetN  := TFont():New(cNomeFont, , -07, , .T.)
	EndIf
Return

/*---------------------------------------------------------------------*
 | Func:  fImpTot                                                      |
 | Desc:  Função para imprimir os totais                               |
 *---------------------------------------------------------------------*/

Static Function fImpTot()
	nLinAtu += 24
	
	//Se atingir o fim da página, quebra
	If nLinAtu + 150 >= nLinFin
		fImpRod()
		fImpCab()
	EndIf
	
	//Cria o grupo de Total
	oPrintPvt:Box(nLinAtu, nColIni, nLinAtu + 045, nColFin)
	oPrintPvt:Line(nLinAtu+nTamFundo, nColIni, nLinAtu+nTamFundo, nColFin)
	nLinAtu += nTamFundo - 5
	oPrintPvt:SayAlign(nLinAtu-10, nColIni+5, "Totais:",                                         oFontTit,  060, nTamFundo, nCorAzul, nPadLeft, )
	nLinAtu += 5
	oPrintPvt:SayAlign(nLinAtu, nColIni+0005, "Valor do Frete: ",                                oFontCab,  080, 07, , nPadLeft, )
	oPrintPvt:SayAlign(nLinAtu, nColIni+0095, Alltrim(Transform(nTotFrete, cMaskFrete)),         oFontCabN, 080, 07, , nPadRight, )
	oPrintPvt:SayAlign(nLinAtu, nColMeio+105, "Valor Total dos Produtos: ",                                      oFontCab,  080, 07, , nPadLeft, )
	oPrintPvt:SayAlign(nLinAtu, nColMeio+195, Alltrim(Transform(nValorTot+nValDesc, cMaskVlr)), 			 oFontCabN, 080, 07, , nPadRight, )
	nLinAtu += 7
	oPrintPvt:SayAlign(nLinAtu, nColIni+0005, "Percentual de Desconto : ",                    oFontCab,  080, 07, , nPadLeft, )
	oPrintPvt:SayAlign(nLinAtu, nColIni+0095, Alltrim(Transform((ROUND(nValDesc/(nValorTot+nValDesc),2))*100, cMaskVlr)),            oFontCabN, 080, 07, , nPadRight, )
	oPrintPvt:SayAlign(nLinAtu, nColMeio+105, "Valor Desconto: ",                                oFontCab,  080, 07, , nPadLeft, )
	oPrintPvt:SayAlign(nLinAtu, nColMeio+195, Alltrim(Transform(nValDesc, cMaskVlr)), 			 oFontCabN, 080, 07, , nPadRight, )
	nLinAtu += 7
	oPrintPvt:SayAlign(nLinAtu, nColIni+0005, "Peso.Líq.:",                    					 oFontCab,  080, 07, , nPadLeft, )
	oPrintPvt:SayAlign(nLinAtu, nColIni+0095, Alltrim(Transform(QRY_PED->C5_PESOL, cMaskPLiq)),  oFontCabN, 080, 07, , nPadRight, )
	oPrintPvt:SayAlign(nLinAtu, nColMeio+105, "Total de Itens: ",                                oFontCab,  080, 07, , nPadLeft, )
	oPrintPvt:SayAlign(nLinAtu, nColMeio+195, Alltrim(Transform(nQtdEmb, cMaskVlr)),            oFontCabN, 080, 07, , nPadRight, )
	nLinAtu += 7
	oPrintPvt:SayAlign(nLinAtu, nColIni+0005, "Peso.Bru:",                                oFontCab,  080, 07, , nPadLeft, )
	oPrintPvt:SayAlign(nLinAtu, nColIni+0095, Alltrim(Transform(QRY_PED->C5_PBRUTO, cMaskPBru)),            oFontCabN, 080, 07, , nPadRight, )
	oPrintPvt:SayAlign(nLinAtu, nColMeio+105, "Valor Total do Pedido: ",                         oFontCab,  080, 07, , nPadLeft, )
	oPrintPvt:SayAlign(nLinAtu, nColMeio+195, Alltrim(Transform(nValorTot, cMaskVlr)),             oFontCabN, 080, 07, , nPadRight, )
	nLinAtu += 10
//nTotVal+nValDesc

/*/
	nLinAtu += 5
	oPrintPvt:SayAlign(nLinAtu, nColIni+0005, "Valor do Frete: ",                                oFontCab,  080, 07, , nPadLeft, )
	oPrintPvt:SayAlign(nLinAtu, nColIni+0095, Alltrim(Transform(nTotFrete, cMaskFrete)),         oFontCabN, 080, 07, , nPadRight, )
	oPrintPvt:SayAlign(nLinAtu, nColMeio+005, "Peso.Líq.:",                                      oFontCab,  080, 07, , nPadLeft, )
	oPrintPvt:SayAlign(nLinAtu, nColMeio+095, Alltrim(Transform(QRY_PED->C5_PESOL, cMaskPLiq)),  oFontCabN, 080, 07, , nPadRight, )
	nLinAtu += 7
	oPrintPvt:SayAlign(nLinAtu, nColIni+0005, "Valor Total dos Produtos: ",                      oFontCab,  080, 07, , nPadLeft, )
	oPrintPvt:SayAlign(nLinAtu, nColIni+0095, Alltrim(Transform(nValorTot, cMaskVlr)),           oFontCabN, 080, 07, , nPadRight, )
	oPrintPvt:SayAlign(nLinAtu, nColMeio+005, "Peso.Bru:",                                       oFontCab,  080, 07, , nPadLeft, )
	oPrintPvt:SayAlign(nLinAtu, nColMeio+095, Alltrim(Transform(QRY_PED->C5_PBRUTO, cMaskPBru)), oFontCabN, 080, 07, , nPadRight, )
	nLinAtu += 7
	oPrintPvt:SayAlign(nLinAtu, nColIni+0005, "Valor do ICMS Substituição: ",                    oFontCab,  080, 07, , nPadLeft, )
	oPrintPvt:SayAlign(nLinAtu, nColIni+0095, Alltrim(Transform(nTotalST, cMaskVlr)),            oFontCabN, 080, 07, , nPadRight, )
	oPrintPvt:SayAlign(nLinAtu, nColMeio+005, "Total de Caixas:",                                oFontCab,  080, 07, , nPadLeft, )
	oPrintPvt:SayAlign(nLinAtu, nColMeio+095, Alltrim(Transform(nQtdEmb, cMaskVlr)),             oFontCabN, 080, 07, , nPadRight, )
	nLinAtu += 7
	oPrintPvt:SayAlign(nLinAtu, nColIni+0005, "Valor Desconto: ",                                oFontCab,  080, 07, , nPadLeft, )
	oPrintPvt:SayAlign(nLinAtu, nColIni+0095, Alltrim(Transform(nValDesc, cMaskVlr)),            oFontCabN, 080, 07, , nPadRight, )
	oPrintPvt:SayAlign(nLinAtu, nColMeio+005, "Valor Total do Pedido: ",                         oFontCab,  080, 07, , nPadLeft, )
	oPrintPvt:SayAlign(nLinAtu, nColMeio+095, Alltrim(Transform(nTotVal, cMaskVlr)),             oFontCabN, 080, 07, , nPadRight, )
	nLinAtu += 10

/*/









Return

/*---------------------------------------------------------------------*
 | Func:  fMsgObs                                                      |
 | Desc:  Função para imprimir mensagem de observação                  |
 *---------------------------------------------------------------------*/

Static Function fMsgObs()
	Local aMsg  := {"", "", ""}
	Local nQueb := 100
	Local cMsg  := Alltrim(QRY_PED->C5_MENNOTA)
	nLinAtu += 4
	
	//Se atingir o fim da página, quebra
	If nLinAtu + 40 >= nLinFin
		fImpRod()
		fImpCab()
	EndIf
	
	//Quebrando a mensagem
	If Len(cMsg) > nQueb
		aMsg[1] := SubStr(cMsg,    1, nQueb)
		aMsg[1] := SubStr(aMsg[1], 1, RAt(' ', aMsg[1]))
		
		//Pegando o restante e adicionando nas outras linhas
		cMsg := Alltrim(SubStr(cMsg, Len(aMsg[1])+1, Len(cMsg)))
		If Len(cMsg) > nQueb
			aMsg[2] := SubStr(cMsg,    1, nQueb)
			aMsg[2] := SubStr(aMsg[2], 1, RAt(' ', aMsg[2]))
			
			cMsg := Alltrim(SubStr(cMsg, Len(aMsg[2])+1, Len(cMsg)))
			aMsg[3] := cMsg
		Else
			aMsg[2] := cMsg
		EndIf
	Else
		aMsg[1] := cMsg
	EndIf
	
	//Cria o grupo de Observação
	oPrintPvt:Box(nLinAtu, nColIni, nLinAtu + 038, nColFin)
	oPrintPvt:Line(nLinAtu+nTamFundo, nColIni, nLinAtu+nTamFundo, nColFin)
	nLinAtu += nTamFundo - 5
	oPrintPvt:SayAlign(nLinAtu-10, nColIni+5, "Observação:",                oFontTit,  100, nTamFundo, nCorAzul, nPadLeft, )
	nLinAtu += 5
	oPrintPvt:SayAlign(nLinAtu, nColIni+0005, aMsg[1],                      oFontCab,  400, 07, , nPadLeft, )
	nLinAtu += 7
	oPrintPvt:SayAlign(nLinAtu, nColIni+0005, aMsg[2],                      oFontCab,  400, 07, , nPadLeft, )
	nLinAtu += 7
	oPrintPvt:SayAlign(nLinAtu, nColIni+0005, aMsg[3],                      oFontCab,  400, 07, , nPadLeft, )
	nLinAtu += 10
Return

/*---------------------------------------------------------------------*
 | Func:  fTransp                                                      |
 | Desc:  Função para imprimir a Transportadora                        |
 *---------------------------------------------------------------------*/

Static Function fTransp()
	nLinAtu += 24
	
	//Se atingir o fim da página, quebra
	If nLinAtu + 40 >= nLinFin
		fImpRod()
		fImpCab()
	EndIf
	
	//Cria o grupo de Transportadora
	oPrintPvt:Box(nLinAtu, nColIni, nLinAtu + 038, nColFin)
	oPrintPvt:Line(nLinAtu+nTamFundo, nColIni, nLinAtu+nTamFundo, nColFin)
	nLinAtu += nTamFundo - 5
	oPrintPvt:SayAlign(nLinAtu-10, nColIni+5, "Dados da Transportadora: " + QRY_PED->A4_NOME,               				oFontTit,  700, nTamFundo, nCorAzul, nPadLeft, )
	nLinAtu += 5
	oPrintPvt:SayAlign(nLinAtu, nColIni+0005, "Endereço: " + QRY_PED->A4_END ,                     							oFontCab,  400, 07, , nPadLeft, )
	oPrintPvt:SayAlign(nLinAtu, nColMeio+0005, "Bairro: " + QRY_PED->A4_BAIRRO ,                     						oFontCab,  400, 07, , nPadLeft, )
	nLinAtu += 7
	oPrintPvt:SayAlign(nLinAtu, nColIni+0005, "Municipio: " +ALLTRIM(QRY_PED->A4_MUN) + " - (" + QRY_PED->A4_EST + ")",		oFontCab,  400, 07, , nPadLeft, )
	oPrintPvt:SayAlign(nLinAtu, nColMeio+0005, "CEP: " + QRY_PED->A4_CEP ,													oFontCab,  400, 07, , nPadLeft, )
	nLinAtu += 7
	oPrintPvt:SayAlign(nLinAtu, nColIni+0005, "Telefone:" + " (" +QRY_PED->A4_DDD + ") " + QRY_PED->A4_TEL ,   				oFontCab,  400, 07, , nPadLeft, )
	oPrintPvt:SayAlign(nLinAtu, nColMeio+0005, "Tipo do Frete:" + cFretePed,   												oFontCab,  400, 07, , nPadLeft, )
	nLinAtu += 10

	If !Empty(QRY_PED->A1_ENDENT)
		oPrintPvt:SayAlign(nLinAtu, nColIni+0005, "Endereço de entrega:" + " (" +QRY_PED->A1_ENDENT + ") " ,   				oFontCab,  400, 07, , nPadLeft, )
		nLinAtu += 7
		oPrintPvt:SayAlign(nLinAtu, nColMeio+0005, "Bairro:" + QRY_PED->A1_BAIRROE 						   , 				oFontCab,  400, 07, , nPadLeft, )
		nLinAtu += 7
		oPrintPvt:SayAlign(nLinAtu, nColMeio+0005, "Municipio:" + QRY_PED->A1_MUNE				   		   , 				oFontCab,  400, 07, , nPadLeft, )
	EndIf

Return

/*---------------------------------------------------------------------*
 | Func:  fMontDupl                                                    |
 | Desc:  Função que monta o array de duplicatas                       |
 *---------------------------------------------------------------------*/

Static Function fMontDupl()
	Local aArea    := GetArea()
	Local lDtEmi   := SuperGetMv("MV_DPDTEMI", .F., .T.)
	Local nAcerto  := 0
	Local aEntr    := {}
	Local aDupl    := {}
	Local aDuplTmp := {}
	Local nItem    := 0
	Local nAux     := 0
	
	aDuplicatas := {}
	
	//Posiciona na condição de pagamento
	DbSelectarea("SE4")
	SE4->(DbSetOrder(1))
	SE4->(DbSeek(xFilial("SE4")+SC5->C5_CONDPAG))
	
	//Se na planilha financeira do Pedido de Venda as duplicatas serão separadas pela Emissão
	If lDtEmi
		//Se não for do tipo 9
		If (SE4->E4_TIPO != "9")
			//Pega as datas e valores das duplicatas
			aDupl := Condicao(MaFisRet(, "NF_BASEDUP"), SC5->C5_CONDPAG, MaFisRet(, "NF_VALIPI"), SC5->C5_EMISSAO, MaFisRet(, "NF_VALSOL"))
			
			//Se tiver dados, percorre os valores e adiciona dados na última parcela
			If Len(aDupl) > 0
				For nAux := 1 To Len(aDupl)
					nAcerto += aDupl[nAux][2]
				Next nAux
				aDupl[Len(aDupl)][2] += MaFisRet(, "NF_BASEDUP") - nAcerto
			EndIf
		
		//Adiciona uma única linha
		Else
			aDupl := {{Ctod(""), MaFisRet(, "NF_BASEDUP"), PesqPict("SE1", "E1_VALOR")}}
		EndIf
		
	Else
		//Percorre os itens
		nItem := 0
		QRY_ITE->(DbGoTop())
		While ! QRY_ITE->(EoF())
			nItem++
			
			//Se tiver entrega
			If !Empty(QRY_ITE->C6_ENTREG)
				
				//Procura pela data de entrega no Array
				nPosEntr := Ascan(aEntr, {|x| x[1] == QRY_ITE->C6_ENTREG})
				
				//Se não encontrar cria a Linha, do contrário atualiza os valores
 				If nPosEntr == 0
					aAdd(aEntr, {QRY_ITE->C6_ENTREG, MaFisRet(nItem, "IT_BASEDUP"), MaFisRet(nItem, "IT_VALIPI"), MaFisRet(nItem, "IT_VALSOL")})
				Else
					aEntr[nPosEntr][2]+= MaFisRet(nItem, "IT_BASEDUP")
					aEntr[nPosEntr][2]+= MaFisRet(nItem, "IT_VALIPI")
					aEntr[nPosEntr][2]+= MaFisRet(nItem, "IT_VALSOL")
				EndIf
			EndIf
			
			QRY_ITE->(DbSkip())
		EndDo
		
		//Se não for Condição do tipo 9
		If (SE4->E4_TIPO != "9")
			
			//Percorre os valores conforme data de entrega
			For nItem := 1 to Len(aEntr)
				nAcerto  := 0
				aDuplTmp := Condicao(aEntr[nItem][2], SC5->C5_CONDPAG, aEntr[nItem][3], aEntr[nItem][1], aEntr[nItem][4])
				
				//Atualiza o valor da última parcela
				For nAux := 1 To Len(aDuplTmp)
					nAcerto += aDuplTmp[nAux][2]
				Next nAux
				aDuplTmp[Len(aDuplTmp)][2] += aEntr[nItem][2] - nAcerto
				
				//Percorre o temporário e adiciona no duplicatas
				aEval(aDuplTmp, {|x| aAdd(aDupl, {aEntr[nItem][1], x[1], x[2]})})
			Next
			
		Else
	    	aDupl := {{Ctod(""), MaFisRet(, "NF_BASEDUP"), PesqPict("SE1", "E1_VALOR")}}
		EndIf
	EndIf
	
	//Se não tiver duplicatas, adiciona em branco
	If Len(aDupl) == 0
		aDupl := {{Ctod(""), MaFisRet(, "NF_BASEDUP"), PesqPict("SE1", "E1_VALOR")}}
	EndIf
	
	aDuplicatas := aClone(aDupl)
	RestArea(aArea)
Return

/*---------------------------------------------------------------------*
 | Func:  fImpDupl                                                     |
 | Desc:  Função para imprimir as duplicatas                           |
 *---------------------------------------------------------------------*/

Static Function fImpDupl()
	Local nLinhas := NoRound(Len(aDuplicatas)/2, 0) + 1
	Local nAtual  := 0
	Local nLinDup := 0
	Local nLinLim := nLinAtu + ((nLinhas+1)*7) + nTamFundo
	Local nColAux := nColIni
	nLinAtu += 24
	
	//Se atingir o fim da página, quebra
	If nLinLim+5 >= nLinFin
		fImpRod()
		fImpCab()
	EndIf
	
	//Cria o grupo de Duplicatas
	oPrintPvt:Box(nLinAtu, nColIni, nLinLim, nColFin)
	oPrintPvt:Line(nLinAtu+nTamFundo, nColIni, nLinAtu+nTamFundo, nColFin)
	nLinAtu += nTamFundo - 5
	oPrintPvt:SayAlign(nLinAtu-10, nColIni+5, "Duplicatas:",                oFontTit,  100, nTamFundo, nCorAzul, nPadLeft, )
	nLinAtu += 5
	nLinDup := nLinAtu
	
	//Percorre as duplicatas
	For nAtual := 1 To Len(aDuplicatas)
		oPrintPvt:SayAlign(nLinDup, nColAux+0005, StrZero(nAtual, 3)+", no dia "+dToC(aDuplicatas[nAtual][1])+":", oFontCab,  080, 07, , nPadLeft, )
		oPrintPvt:SayAlign(nLinDup, nColAux+0095, Alltrim(Transform(aDuplicatas[nAtual][2], cMaskVlr)),            oFontCabN, 080, 07, , nPadRight, )
		nLinDup += 7
		
		//Se atingiu o numero de linhas, muda para imprimir na coluna do meio
		If nAtual == nLinhas
			nLinDup := nLinAtu
			nColAux := nColMeio
		EndIf
	Next
	
	nLinAtu += (nLinhas*7) + 3
Return
