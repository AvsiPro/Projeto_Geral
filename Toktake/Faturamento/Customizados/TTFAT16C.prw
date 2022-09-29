#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTFAT16C  ºAutor  ³Jackson E. de Deus  º Data ³  04/03/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera pedido de venda para nova entrega - com base em pedidoº±±
±±º     	 ³ original.								                  º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³Versao| Alteracao realizada                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Jackson       ³04/03/15³01.00 |Criacao                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function TTFAT16C(cNumNF,cSerie,cCli,cLj)

Local cSql := ""
Local lCanc := .F.
Local cPed := ""
Local aPed := {}
Local nI
Local aSC5 := {}
Local aSC6 := {}
Local lVldPedido := .F.
Local cNumPed := ""
Local cRemete := "microsiga"
Local cDestino := If(cEmpAnt=="01",SuperGetMV("MV_XLOG002",.T.,""),"")
Local cAssunto := "Pedido a faturar"
Local cHtml := ""
Local aAttach := {}
Private lMsErroAuto := .F.

If cEmpAnt <> "01"
	Return
EndIf

cSql := "SELECT D2_PEDIDO FROM " +RetSqlName("SD2") 
cSql += " WHERE D2_DOC = '"+cNumNF+"' AND D2_SERIE = '"+cSerie+"' AND D2_CLIENTE = '"+cCli+"' AND D2_LOJA = '"+cLj+"' "
cSql += " AND D_E_L_E_T_ = '' ORDER BY D2_ITEM "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

TcQuery cSql New Alias "TRB"
dbSelectArea("TRB")
While !EOF()
	AADD( aPed, TRB->D2_PEDIDO )
	dbSkip()
End 

For nI := 1 To Len(aPed)
	If nI = 1
		cPed := aPed[nI]
		Loop
	EndIf	
	If aPed[nI] <> cPed
		lCanc := .T.
		Exit
	EndIf
Next nI

If lCanc
	Return
EndIf     


dbSelectArea("SC5")
dbSetOrder(1)
If dbSeek( xFilial("SC5") +AvKey(cPed,"C5_NUM") )
	While !lVldPedido
		cNumPed := GetSX8NUM("SC5","C5_NUMERO")
		If FindFunction("U_TTCNTA05")
			lVldPedido := STATICCALL(TTCNTA05,VldNumPed,cNumPed,cFilAnt)
		Else
			lVldPedido := .T.
		EndIf
	End

	dbSelectArea("SC6")
	dbSetOrder(1)
	If dbSeek( xFilial("SC6") +AvKey(cPed,"C6_NUM") )
		While SC6->C6_FILIAL == SC5->C5_FILIAL .And.;
		 		SC6->C6_NUM == SC5->C5_NUM .And. SC6->C6_CLI == SC5->C5_CLIENTE .And. SC6->C6_LOJA == SC5->C5_LOJACLI .And.;
		 		 !EOF()
		 		 
				Aadd(aSC6,{{"C6_FILIAL"	 	,SC6->C6_FILIAL								,Nil},;		// Filial
							{"C6_ITEM"   	,SC6->C6_ITEM 								,Nil},;		// Numero do Item
							{"C6_PRODUTO"	,SC6->C6_PRODUTO							,Nil},;		// Codigo do Produto
							{"C6_NUM"    	,cNumPed									,Nil},;		// Numero do Pedido de venda
							{"C6_QTDVEN" 	,SC6->C6_QTDVEN								,Nil},; 	// Quantidade Vendida
							{"C6_XQTDORI"	,SC6->C6_XQTDORI							,Nil},;
							{"C6_TPOP"		,SC6->C6_TPOP								,Nil},;
							{"C6_PRCVEN"	,SC6->C6_PRCVEN		  						,Nil},;		// Preco Unitario Liquido
							{"C6_PRUNIT"	,SC6->C6_PRUNIT		  						,Nil},;		// Preco Unitario Liquido
							{"C6_VALOR"		,Round(SC6->C6_QTDVEN*SC6->C6_PRCVEN,6)		,Nil},; 	// Valor Total do Item
							{"C6_TES"		,SC6->C6_TES								,Nil},; 	// Tipo de Entrada/Saida do Item  // mudar a TES
							{"C6_CLI"		,SC6->C6_CLI								,Nil},; 	// Cliente
							{"C6_LOJA"		,SC6->C6_LOJA		  						,Nil},; 	// Loja do Cliente
							{"C6_LOCAL"		,SC6->C6_LOCAL 								,Nil},; 	// Armazem - PA
							{"C6_CCUSTO"	,SC6->C6_CCUSTO							  	,Nil},;		// CENTRO DE CUSTO ??
							{"C6_ITEMCC"	,SC6->C6_ITEMCC								,Nil},;
							{"C6_XGPV"		,SC6->C6_XGPV			 					,Nil},; 	// Grupo do Pedido de Venda
							{"C6_ENTREG"	,SC6->C6_ENTREG+1 							,Nil},; 	// Data da Entrega							
							{"C6_XDTEORI"	,SC6->C6_ENTREG								,Nil},;
							{"C6_UM"		,SC6->C6_UM									,Nil},; 	// Unidade de Medida Primar.
							{"C6_SEGUM"		,SC6->C6_SEGUM						   		,Nil},;		// Segunda Unidade de medida
							{"C6_XHRINC"	,TIME()										,Nil},;		// Hora da inclusao
							{"C6_XDATINC"	,Date()		 								,Nil},;		// Data da inclusao
							{"C6_XUSRINC"	,cUsername 	 								,Nil}})		// Login do usuario
	
			dbSkip()
		End
	EndIf              
	
	dbSelectArea("SC5")
	
	Aadd(aSC5, {"C5_FILIAL" 	,SC5->C5_FILIAL			,Nil}) 			// Filial
	Aadd(aSC5, {"C5_NUM"    	,cNumPed				,Nil})			// Numero do Pedido
	Aadd(aSC5, {"C5_TIPO"   	,SC5->C5_TIPO      		,Nil})			// Tipo do Pedido
	Aadd(aSC5, {"C5_CLIENTE"	,SC5->C5_CLIENTE 		,Nil})			// Cliente para faturamento
	Aadd(aSC5, {"C5_LOJACLI"	,SC5->C5_LOJACLI		,Nil})			// Loja do cliente
	Aadd(aSC5, {"C5_CLIENT"		,SC5->C5_CLIENT 		,Nil})			// Cliente para entrega
	Aadd(aSC5, {"C5_LOJAENT"	,SC5->C5_LOJAENT		,Nil})			// Loja para entrada
	Aadd(aSC5, {"C5_XDTENTR"	,SC5->C5_XDTENTR+1		,Nil})			// Data da entrega
	Aadd(aSC5, {"C5_XNFABAS"	,SC5->C5_XNFABAS		,Nil})			// Nf Abastecimento - NAO
	Aadd(aSC5, {"C5_XCODPA"		,SC5->C5_XCODPA			,Nil})
	Aadd(aSC5, {"C5_XFINAL" 	,SC5->C5_XFINAL			,Nil})			// Finalidade de venda - Insumos p/ Locacao Fechamento
	Aadd(aSC5, {"C5_TRANSP" 	,SC5->C5_TRANSP			,Nil})			// Transportadora -> Tok Take
	Aadd(aSC5, {"C5_XTPCARG"	,SC5->C5_XTPCARG		,Nil})      
	Aadd(aSC5, {"C5_XHRPREV"	,SC5->C5_XHRPREV		,Nil})  
	Aadd(aSC5, {"C5_CONDPAG"	,SC5->C5_CONDPAG		,Nil})			// Codigo da condicao de pagamanto*
	Aadd(aSC5, {"C5_MOEDA"		,SC5->C5_MOEDA 			,Nil})			// Moeda
	Aadd(aSC5, {"C5_FRETE"		,SC5->C5_FRETE 			,Nil})			// Frete
	Aadd(aSC5, {"C5_TXMOEDA"	,SC5->C5_TXMOEDA 		,Nil})			// Tx da Moeda
	Aadd(aSC5, {"C5_EMISSAO"	,dDatabase				,Nil})			// Data de emissao
	Aadd(aSC5, {"C5_MENNOTA"	,SC5->C5_MENNOTA		,Nil})			// Msg da nota
	Aadd(aSC5, {"C5_ESPECI1"	,SC5->C5_ESPECI1		,Nil})			// Especie
	Aadd(aSC5, {"C5_XRINC"		,TIME()					,Nil})			// Hora da inclusao
	Aadd(aSC5, {"C5_XDATINC"	,DATE()					,Nil})			// Data da inclusao
	Aadd(aSC5, {"C5_XNOMUSR"	,cUserName				,Nil}) 			// Login do usuario
	Aadd(aSC5, {"C5_XCODUSR"	,__cUserID				,Nil})			// Codigo do usuario
	Aadd(aSC5, {"C5_XDESCLI"	,SC5->C5_XDESCLI		,Nil})  
	Aadd(aSC5, {"C5_TPFRETE" 	,SC5->C5_TPFRETE 		,Nil})			// Tipo de Frete: CIF
	Aadd(aSC5, {"C5_TIPOCLI"	,SC5->C5_TIPOCLI		,Nil})			// Tipo de Cliente
	Aadd(aSC5, {"C5_TIPLIB" 	,"1"			     	,Nil})			// Tipo de Liberacao
//	Aadd(aSC5, {"C5_LIBEROK"	,"S"         			,Nil})			// Liberado Total
	Aadd(aSC5, {"C5_VEND1"  	,SC5->C5_VEND1			,Nil})			// Vendedor
	Aadd(aSC5, {"C5_VOLUME1"	,SC5->C5_VOLUME1		,Nil})			// Volume
	Aadd(aSC5, {"C5_XGPV"	 	,SC5->C5_XGPV			,Nil}) 			// Grupo do Pedido de Venda
	
	MSExecAuto({|x,y,z|MATA410(x,y,z)},aSC5,aSC6,3)
	If lMsErroAuto
		RollBackSx8()
		Conout("#TTFAT16C - NF: " +cNumNF +"/" +cSerie +" - Erro ao gerar pedido de venda")
	Else
		ConfirmSX8()
		            
		If !Empty(cDestino)
			cHtml := "<html>" +CRLF
			cHtml += "<head>"+CRLF
			cHtml += "<title>" +cAssunto +"</title>" +CRLF
			cHtml += "<style type='text/css'>"	+CRLF
			cHtml += "	table.bordasimples {border-collapse: collapse;}"	+CRLF
			cHtml += "	table.bordasimples tr td {border:1px solid #999999 ;}"	+CRLF
			cHtml += "	body { background-color: #FFFFFF;"	+CRLF
			cHtml += "	color: #5D665B; "	+CRLF
			cHtml += "	margin: 10px;"	+CRLF
			cHtml += "	font-family: Georgia, 'Times New Roman', Times, serif;"	+CRLF
			cHtml += "	font-size: small;"	+CRLF
			//	cArqMail += "	line-height: 180%;"
			cHtml += " 	}"	+CRLF
			cHtml += "</style>"	+CRLF
			cHtml += "</head>"	+CRLF
			cHtml += "<body>"	+CRLF
			cHtml += "<br>"
			cHtml += "<p>Notificação de pedido para faturamento.</p>"
			cHtml += "<p>Pedido: " +cNumPed +" </p>"
			cHtml += "<br>"
			cHtml += "<p>___________________________________</p>"
			cHtml += "<p>E-mail automático enviado via protheus.</p>"
			cHtml += "<p>Favor não responder.</p>"
			cHtml += "</body>"
			cHtml += "</html>"
			
			U_TTMailN(cRemete,cDestino,cAssunto,cHtml,aAttach,.F.)
	   EndIf		
	EndIf	
EndIf


Return