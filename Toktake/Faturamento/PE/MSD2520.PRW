#INCLUDE "Protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MSD2520  ºAutor  ³Bruno Daniel Borges º Data ³  30/09/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada na exclusao da NFs de saida para estornar  º±±
±±º          ³o movimento interno de distribuicao                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Toktake                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MSD2520()

Local aAreaBKP   := GetArea()
Local cTMEntrega := ""	//GetMv("MV_XTMENT",,"501") 
Local cTM      := ""	//GetMv("MV_XTMSD3",,"001")
Local cTMBaixa := ""	//GetMv("MV_XLOG008",,"515")//
Local cCliEst  := ""	//GetMv("MV_XCLESTC")         
Local cPrdEst  := ""	//GetMv("MV_XPRESCF")
Local cTFord
Local cPFord
Local cSql		:= ""
 
	
// Tratamento para AMC
If cEmpAnt == "10"
	Return
EndIf	


cTMEntrega := GetMv("MV_XTMENT",,"501") 
cTM      := GetMv("MV_XTMSD3",,"001")
cTMBaixa := GetMv("MV_XLOG008",,"515")
cCliEst  := GetMv("MV_XCLESTC")         
cPrdEst  := GetMv("MV_XPRESCF")
	
		
If cEmpAnt == "01"
 	//Atualiza o status do patrimonio na movimentacao  Alexandre 05/07/13 Patrimonio
    If !Empty(GetAdvFVal( 'SC6', 'C6_XPATRIM', xFilial( 'SC6' ) + SD2->(D2_PEDIDO+D2_ITEM) ,1 , '' ))
    	DbSelectArea("SN1")
    	DbSetORder(2)
    	If DbSeek(xFilial("SN1")+GetAdvFVal( 'SC6', 'C6_XPATRIM', xFilial( 'SC6' ) + SD2->(D2_PEDIDO+D2_ITEM) ,1 , '' ))
    		If AllTrim(SN1->N1_XSTATTT) <> "3"
    			Reclock("SN1",.F.)
    			SN1->N1_XSTATTT := "5"
    			SN1->(Msunlock())          
    		EndIf
    	EndIf
    	DbSelectArea("SD2")
    EndIf
    
    /*BEGINDOC
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Estorno da mercadoria que foi movimentada para armazem da Rota/PA³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ENDDOC*/
    dbSelectArea("SC5")
	SC5->(dbSetOrder(1))
	If SC5->(dbSeek(xFilial("SC5")+SD2->D2_PEDIDO )) .And. !Empty(SC5->C5_XCODPA) .And. SC5->C5_XNFABAS == "1" .And. SC5->C5_TIPO == "N"
	 	// PA
		If SubStr(SC5->C5_XCODPA,1,1) == "P"
		 	// verifica se entrou no armazem
		 	If STATICCALL( TTFAT18C,CHKMOV,SD2->D2_DOC,SD2->D2_SERIE,SD2->D2_CLIENTE,SD2->D2_LOJA,SD2->D2_ITEM,SD2->D2_COD,SC5->C5_XCODPA,SD2->D2_QUANT,SD2->D2_EMISSAO,cTM )
		 		// verifica se ainda nao deu baixa do armazem
		 		//If !STATICCALL( TTFAT18C,CHKMOV,SD2->D2_DOC,SD2->D2_SERIE,SD2->D2_CLIENTE,SD2->D2_LOJA,SD2->D2_ITEM,SD2->D2_COD,SC5->C5_XCODPA,SD2->D2_QUANT,SD2->D2_EMISSAO,"516" )
					dbSelectArea("SD2")
					aMata240 := {}
					aAdd(aMata240, {})
					aAdd(aMata240[1], {'D3_TM'     ,"516"	   		,Nil})
					aAdd(aMata240[1], {'D3_COD'    ,SD2->D2_COD    ,Nil})
					aAdd(aMata240[1], {'D3_UM'     ,SD2->D2_UM     ,Nil})
					aAdd(aMata240[1], {'D3_QUANT'  ,SD2->D2_QUANT  ,Nil})
					//aAdd(aMata240[1], {'D3_CUSTO1' ,SD2->D2_PRCVEN ,Nil})
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
					aAdd(aMata240[1], {'D3_XORIGEM',"MSD2520"  		,Nil})
					                                               
					lMsErroAuto := .F.
					MSExecAuto({|x,y| mata240(x,y)},aMata240[1],3)
					If lMsErroAuto
						MostraErro()
					EndIf
				//EndIf
			EndIf
		EndIf
		
		dbSelectArea("SD2")
	EndIf
	
	/*BEGINDOC
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Estorno da baixa dos insumos da receita - estrutura³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ENDDOC*/ 
	If AllTrim(SF2->F2_XFINAL) == "J"
		cSql := "SELECT R_E_C_N_O_ D3REC FROM " +RetSqlName("SD3")
		cSql += " WHERE " 
		cSql += " D3_FILIAL = '"+xFilial("SD3")+"' AND D3_XNUMNF = '"+SD2->D2_DOC+"' AND D3_XSERINF = '"+SD2->D2_SERIE+"' "
		cSql += " AND D3_XCLIENT = '"+SD2->D2_CLIENTE+"' AND D3_XLOJCLI = '"+SD2->D2_LOJA+"' AND D3_XITEMNF = '"+SD2->D2_ITEM+"' "
		cSql += " AND D3_TM = '515' AND D_E_L_E_T_ = '' "
		If Select("TRBD3") > 0
			TRBD3->(dbCloseArea())
		EndIf
		
		TcQuery cSql New Alias "TRBD3"
		dbSelectArea("TRBD3")
		While TRBD3->(!EOF())
			If TRBD3->D3REC > 0
				dbSelectArea("SD3")
				dbGoTo(TRBD3->D3REC)
				If Recno() == TRBD3->D3REC
			 		// verifica se ainda nao deu baixa do insumo do armazem
			 		//If !STATICCALL( TTFAT18C,CHKMOV,SD2->D2_DOC,SD2->D2_SERIE,SD2->D2_CLIENTE,SD2->D2_LOJA,SD2->D2_ITEM,SD3->D3_COD,SD3->D3_LOCAL,SD3->D3_QUANT,SD3->D3_EMISSAO,"015" )
						aMata240 := {}
						aAdd(aMata240, {})
						aAdd(aMata240[1], {'D3_TM'     ,"010"					,Nil})
						aAdd(aMata240[1], {'D3_COD'    ,SD3->D3_COD				,Nil})
						aAdd(aMata240[1], {'D3_QUANT'  ,SD3->D3_QUANT			,Nil})
						aAdd(aMata240[1], {'D3_CUSTO1' ,SD3->D3_CUSTO1			,Nil})
						aAdd(aMata240[1], {'D3_LOCAL'  ,SD3->D3_LOCAL			,Nil})
						aAdd(aMata240[1], {'D3_EMISSAO',dDatabase				,Nil})
						aAdd(aMata240[1], {'D3_DOC'    ,SD2->D2_DOC				,Nil})
						aAdd(aMata240[1], {'D3_CC'     ,SC5->C5_XCCUSTO         ,Nil})
						aAdd(aMata240[1], {'D3_ITEMCTA',SC5->C5_XITEMCC			,Nil})
						aAdd(aMata240[1], {'D3_XNUMNF' ,SD2->D2_DOC    			,Nil})
						aAdd(aMata240[1], {'D3_XSERINF',SD2->D2_SERIE  			,Nil})
						aAdd(aMata240[1], {'D3_XCLIENT',SD2->D2_CLIENTE			,Nil})
						aAdd(aMata240[1], {'D3_XLOJCLI',SD2->D2_LOJA   			,Nil})
						aAdd(aMata240[1], {'D3_XITEMNF',SD2->D2_ITEM   			,Nil})
						aAdd(aMata240[1], {'D3_XORIGEM',"MSD2520"				,Nil})
						
						lMsErroAuto := .F.
						MSExecAuto({|x,y| mata240(x,y)},aMata240[1],3)
						
						If lMsErroAuto
							Conout("#MSD2520 -> ERRO AO ESTORNAR BAIXA DE INSUMO - NF: " +AllTrim(SD2->D2_DOC) + " - INSUMO: " +AllTrim(SD3->D3_COD))
						EndIf  
				   //EndIf
				EndIf	
			EndIf
			dbSelectArea("TRBD3")
			TRBD3->(dbSkip())
		End	
		TRBD3->(dbCloseArea())
	EndIf
	
	// Pedido de descarte
	dbSelectArea("SC5")
	dbSetOrder(1)
	If dbSeek(xFilial("SC5")+SD2->D2_PEDIDO )
		If SubStr(SC5->C5_XCODPA,1,1) == "R" .And. AllTrim(SC5->C5_XFINAL) == "L" .And. SC5->C5_CLIENTE == "000001"
			// subir quantidade do descarte
			STATICCALL( TTPROC25, MvB2Dst, 2, SC5->C5_XCODPA, SD2->D2_COD, SD2->D2_QUANT )
		EndIf
	EndIf    
EndIf


RestArea(aAreaBKP)

Return(Nil)