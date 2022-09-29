#INCLUDE "Protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MSD2460  ºAutor  ³Luciano Santiago    º Data ³  23/09/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada no faturamento do item da NF para geracao  º±±
±±º          ³do movimento interno de transferencia para o armazem        º±±
±±º          ³EM TRANSITO                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TOKTAKE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MSD2460()

Local aAreaBKP := GetArea()
Local cTM      := ""	//GetMv("MV_XTMSD3",,"001")
Local cCliEst  := ""	//GetMv("MV_XCLESTC")         
Local cPrdEst  := ""	//GetMv("MV_XPRESCF")
Local cTFord    
Local cPFord
Local aInsumos := {}
Local cCliExec := ""	//SuperGetMV("MV_XLOG007",.T.,"")	// clientes PA excecoes - sem conferencia cega - ja movimenta estoque para PA conforme processo anterior
Local cFilEntr := ""	//SuperGetMV("MV_XLOG008",.T.,"")	// filiais com controle de entrega at
Local cPaExec  := ""	//SuperGetMV("MV_XLOG009",.T.,"")	// PA excecoes - ja movimenta estoque para PA conforme processo anterior
Local cMailResp:= ""	//SuperGetMV("MV_XLOG001",.T.,"")
Local cCliPA   := ""
Local cLjPA    := ""
Local cProdCmpl := "1001896"	// criar parametro
Local cHtml		:= ""
Local nI 
Local cUM		:= ""
Local cArmA		:= ""

cCusto := ''
cItem  := ''
cCLVL  := ''


// Tratamento para AMC
If cEmpAnt == "10"
	Return
EndIf


cTM      := GetMv("MV_XTMSD3",,"001")
cCliEst  := GetMv("MV_XCLESTC")         
cPrdEst  := GetMv("MV_XPRESCF")
cCliExec := SuperGetMV("MV_XLOG007",.T.,"")	// clientes PA excecoes - sem conferencia cega - ja movimenta estoque para PA conforme processo anterior
cFilEntr := SuperGetMV("MV_XLOG008",.T.,"")	// filiais com controle de entrega at
cPaExec  := SuperGetMV("MV_XLOG009",.T.,"")	// PA excecoes - ja movimenta estoque para PA conforme processo anterior
cMailResp:= SuperGetMV("MV_XLOG001",.T.,"")


If cEmpAnt == "01"
	//Atualiza o status do patrimonio na movimentacao  Alexandre 05/07/13 Patrimonio
    If !Empty(GetAdvFVal( 'SC6', 'C6_XPATRIM', xFilial( 'SC6' ) + SD2->(D2_PEDIDO+D2_ITEM) ,1 , '' ))
    	DbSelectArea("SN1")
    	DbSetORder(2)
    	If DbSeek(xFilial("SN1")+GetAdvFVal( 'SC6', 'C6_XPATRIM', xFilial( 'SC6' ) + SD2->(D2_PEDIDO+D2_ITEM) ,1 , '' ))
    		If AllTrim(SN1->N1_XSTATTT) != "3"
	    		Reclock("SN1",.F.)
	    		SN1->N1_XSTATTT := "2"
	    		SN1->(Msunlock())                
    		EndIf
    	EndIf
    	DbSelectArea("SD2")
    EndIf
    
    /*
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ8¿
	//³Faz a baixa dos insumos                     ³
	//³Incluido por Jackson E. de Deus - 26/11/2013³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ8Ù
	*/
	dbSelectArea("SC5")
	dbSetOrder(1)
	If dbSeek( xFilial("SC5") +AvKey(SD2->D2_PEDIDO,"C5_NUM") )
		If AllTrim(SC5->C5_XFINAL) == "J" //.And. !Empty(SC5->C5_XCODPA)
			// desconsiderar produto dose complementar
			If ! AllTrim(SD2->D2_COD) $ cProdCmpl
				nCusto := 0
				
				cQuery := "SELECT G1_COMP, G1_TRT, G1_QUANT, B1_UM, B1_CUSTD CUSTOB1, B1_UPRC ULTPRCB1, B2_CM1, "
				cQuery += "( SELECT TOP 1 B9_CM1 FROM " +RetSqlName("SB9") +" WHERE B9_FILIAL = '"+SD2->D2_FILIAL+"' AND B9_LOCAL = B2_LOCAL AND B9_COD = G1_COMP AND D_E_L_E_T_ = '' ORDER BY B9_DATA DESC ) CUSTOB9 "
				cQuery += " FROM " +RetSqlName("SG1")  +" SG1 "	// ADICIONAR ULTIMO PRECO DE COMPRA B1_UPRC
				cQuery += "INNER JOIN " +RetSqlName("SB1") +" SB1 ON SB1.B1_COD = SG1.G1_COMP "
				cQuery += "INNER JOIN " +RetSqlName("SB2") +" SB2 ON SB2.B2_FILIAL = '"+SD2->D2_FILIAL+"' AND SB2.B2_COD = SG1.G1_COMP AND SB2.B2_LOCAL = '"+SD2->D2_LOCAL+"' "
				cQuery += "WHERE G1_COD = '"+SD2->D2_COD+"' AND SG1.D_E_L_E_T_ = '' ORDER BY G1_TRT "
				If Select("TRBSG1") > 0
					TRBSG1->(dbCloseArea())
				EndIf
				
				TcQuery cQuery New Alias "TRBSG1"
				dbSelectArea("TRBSG1")
				While TRBSG1->(!EOF())
					If !Empty(TRBSG1->CUSTOB9)
						nCusto := TRBSG1->CUSTOB9
					ElseIf !Empty(TRBSG1->B2_CM1)
						nCusto := TRBSG1->B2_CM1
					ElseIf !Empty(TRBSG1->ULTPRCB1)
						nCusto := TRBSG1->ULTPRCB1
					ElseIf !Empty(TRBSG1->CUSTOB1)
						nCusto := TRBSG1->CUSTOB1			
					Else
						nCusto := 0.01	
					EndIf
					
					//If nCusto < 0
					//	nCusto := 0.01
					//EndIf
										
					AADD(aInsumos, { TRBSG1->G1_TRT, TRBSG1->G1_COMP, TRBSG1->G1_QUANT, nCusto } )
					TRBSG1->(dbSkip())
				End
				
			    For nI := 1 To Len(aInsumos)
					aMata240 := {}          
				
					nCusto := Round((SD2->D2_QUANT * aInsumos[nI][3]) * aInsumos[nI][4],6)
								
					cUM := Posicione( "SB1",1,xFilial("SB1") +AvKey(aInsumos[nI][2],"B1_COD"),"B1_UM" )
					
					aAdd(aMata240, {})
					aAdd(aMata240[1], {'D3_FILIAL' 	,xFilial("SD3")						,Nil})
					aAdd(aMata240[1], {'D3_TM'     	,"515"								,Nil})
					aAdd(aMata240[1], {'D3_COD'    	,aInsumos[nI][2]					,Nil})
					aAdd(aMata240[1], {'D3_UM'     	,cUM								,Nil})
					aAdd(aMata240[1], {'D3_QUANT'  	,SD2->D2_QUANT * aInsumos[nI][3]	,Nil})
					aAdd(aMata240[1], {'D3_CUSTO1' 	,nCusto								,Nil})	// qtd do pedido * qtd do insumo da estrutura * custo do insumo
					aAdd(aMata240[1], {'D3_LOCAL'  	,SD2->D2_LOCAL						,Nil})
					aAdd(aMata240[1], {'D3_EMISSAO'	,SD2->D2_EMISSAO					,Nil})
					aAdd(aMata240[1], {'D3_DOC'    	,SD2->D2_DOC						,Nil})
					aAdd(aMata240[1], {'D3_CC'     	,SC5->C5_XCCUSTO                 	,Nil})
					aAdd(aMata240[1], {'D3_ITEMCTA'	,SC5->C5_XITEMCC					,Nil})
					aAdd(aMata240[1], {'D3_XNUMNF' 	,SD2->D2_DOC    					,Nil})	// novo
					aAdd(aMata240[1], {'D3_XSERINF'	,SD2->D2_SERIE  					,Nil})	// novo
					aAdd(aMata240[1], {'D3_XCLIENT'	,SD2->D2_CLIENTE					,Nil})	// novo
					aAdd(aMata240[1], {'D3_XLOJCLI'	,SD2->D2_LOJA   					,Nil})	// novo
					aAdd(aMata240[1], {'D3_XITEMNF'	,SD2->D2_ITEM   					,Nil})	// novo
					aAdd(aMata240[1], {'D3_XCTADES'	,"N"			   					,Nil})	// novo
					aAdd(aMata240[1], {'D3_XORIGEM'	,"MSD2460"							,Nil})
					
					lMsErroAuto := .F.
					
					MSExecAuto({|x,y| mata240(x,y)},aMata240[1],3)
					
					If lMsErroAuto
						Conout("#MSD2460 -> ERRO AO BAIXAR INSUMO: NF " +AllTrim(SD2->D2_DOC) +" - INSUMO: " +aInsumos[nI][2])
					EndIf
				Next nI
				TRBSG1->(dbCloseArea())
				dbSelectArea("SD2")
			EndIf	
		EndIf
	EndIf
	
		
    // PA -> saida do armazem da nota e entrada de mercadoria na PA
	/*
	Alterado para movimentar somente quando for para ROTA - Armazem iniciando em R
	Ou para PA para clientes que sao excecao - nao precisam de Ordem de Servico de entrega - fleury delboni
	Ou para filial que nao esta no controle de entregas
	Ou para PA excecao - nao precisa de Ordem de Servico de entrega
	-> Controle de Entregas Mobile - Jackson 27/05/2015
	*/
	If !Empty(SC5->C5_XCODPA) .And. SC5->C5_XNFABAS=="1" .AND. SC5->C5_TIPO == "N"
		If SubStr(SC5->C5_XCODPA,1,1) == "P"
			dbSelectArea("ZZ1")
			dbSetOrder(1)
			If dbSeek( xFilial("ZZ1") +AvKey(SC5->C5_XCODPA,"ZZ1_COD") )
				cCliPA := SubStr( ZZ1->ZZ1_ITCONT,1,6 )
				cLjPA := SubStr( ZZ1->ZZ1_ITCONT, 7,4 )
			EndIf
			//cArmA := "A" +SubStr( SC5->C5_XCODPA,2 )
		EndIf
	
		//If SubStr(SC5->C5_XCODPA,1,1) == "R" .Or.;	// comentado pois a mercadoria soh entra na rota ao registrar a saida ttfatc30
		If	 ( SubStr(SC5->C5_XCODPA,1,1) == "P" .And. cCliPA $ cCliExec ) .Or. ;
			 ( SubStr(SC5->C5_XCODPA,1,1) == "P" .And. .Not. cFilAnt $ cFilEntr  ) .Or. ;
			 SC5->C5_XCODPA $ cPaExec
			
			SD2->(RecLock("SD2",.F.))
			SD2->D2_XSLDPA	:= SD2->D2_QUANT                                                            
			SD2->D2_XCODPA  := SC5->C5_XCODPA
			dbSelectArea("ZZ1")
			If dbSeek(xFilial("ZZ1")+SC5->C5_XCODPA)
				dbSelectArea("SD2")
				cCusto := ZZ1->ZZ1_CCUSTO
				cItem  := ZZ1->ZZ1_ITCONT
				cCLVL  := ZZ1->ZZ1_CLVALO
			Endif
			SD2->(MsUnLock())
							
			dbSelectArea("SB2")
			dbSetOrder(1)
			If !dbSeek(xFilial("SB2")+SD2->D2_COD+SC5->C5_XCODPA)
				CriaSB2(SD2->D2_COD,SC5->C5_XCODPA)
			Endif
			
			dbSelectArea("SD2")
			
			aMata240 := {}
			aAdd(aMata240, {})
			aAdd(aMata240[1], {'D3_TM'     ,cTM			   ,Nil})
			aAdd(aMata240[1], {'D3_COD'    ,SD2->D2_COD    ,Nil})
			aAdd(aMata240[1], {'D3_UM'     ,SD2->D2_UM     ,Nil})
			aAdd(aMata240[1], {'D3_QUANT'  ,SD2->D2_QUANT  ,Nil})
			aAdd(aMata240[1], {'D3_LOCAL'  ,SC5->C5_XCODPA ,Nil})
			aAdd(aMata240[1], {'D3_EMISSAO',SD2->D2_EMISSAO,Nil})
			aAdd(aMata240[1], {'D3_DOC'    ,SD2->D2_DOC    ,Nil})
			aAdd(aMata240[1], {'D3_CONTA'  ,SD2->D2_CONTA  ,Nil})
			aAdd(aMata240[1], {'D3_CC'     ,SD2->D2_CCUSTO ,Nil})
			aAdd(aMata240[1], {'D3_CLVL'   ,SD2->D2_CLVL   ,Nil})
			aAdd(aMata240[1], {'D3_ITEMCTA',SD2->D2_ITEMCC ,Nil})
			
			aAdd(aMata240[1], {'D3_XNUMNF' ,SD2->D2_DOC    ,Nil})
			aAdd(aMata240[1], {'D3_XSERINF',SD2->D2_SERIE  ,Nil})
			aAdd(aMata240[1], {'D3_XCLIENT',SD2->D2_CLIENTE,Nil})
			aAdd(aMata240[1], {'D3_XLOJCLI',SD2->D2_LOJA   ,Nil})
			aAdd(aMata240[1], {'D3_XITEMNF',SD2->D2_ITEM   ,Nil})
			aAdd(aMata240[1], {'D3_XSLDONF',SD2->D2_QUANT  ,Nil})
			aAdd(aMata240[1], {'D3_XORIGEM',"MSD2460"  		,Nil})
			
			lMsErroAuto := .F.                              
			For nI := 1 To 3
				MSExecAuto( {|x,y| mata240(x,y)},aMata240[1],3 )
				If !lMsErroAuto
					Exit
				EndIf
			Next nI
			If lMsErroAuto
				conout("# MSD2460 -> ERRO AO MOVIMENTAR ESTOQUE PARA ARMAZEM : " +SD2->D2_DOC + "/" +SD2->D2_SERIE)
				
				cHtml := "<html>"
				cHtml += "<body>"
				cHtml += "Houve erro ao movimentar a mercadoria para o armazém de destino. <br>"
				chtml += "Armazém de destino: " +SC5->C5_XCODPA +"<br>"
				cHtml += "Nota fiscal: " +SF2->F2_DOC +"/" +SF2->F2_SERIE +"<br>"
				cHtml += "Item: " +SD2->D2_ITEM +"<br>"
				cHtml += "Produto: " +AllTrim(SD2->D2_COD) +"<br>"
				cHtml += "Pedido: " +AllTrim(SC5->C5_NUM) +"<br><br>"
				cHtml += "Verificar o pedido de venda gerado: <br>"
				cHtml += "# Conta contábil <br>"
				cHtml += "# Centro de custo"
				cHtml += "</body>"
				cHtml += "</html>"     
				
				U_TTMAILN("microsiga",cMailResp,"FATURAMENTO - MOVIMENTACAO",cHtml,{},.F.)
				//MostraErro()
			EndIf
	
			dbSelectArea("SD2")
		EndIf
	EndIf
EndIf


SD2->(RecLock("SD2",.F.))
If !Empty(cCusto)
	SD2->D2_CCUSTO := cCusto
	SD2->D2_ITEMCC := cItem
	SD2->D2_CLVL   := cCLVL
Else
	SD2->D2_CCUSTO := SC6->C6_CCUSTO
	SD2->D2_ITEMCC := SC6->C6_ITEMCC
	SD2->D2_CLVL   := SC6->C6_CLVL
End
SD2->( MsUnLock() )


RestArea(aAreaBKP)

Return(Nil)