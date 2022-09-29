#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT18C    บAutor  ณJackson E. de Deusบ Data ณ  06/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Faz a entrada no armazem PA/A		                      บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณJackson       ณ06/04/15ณ01.00 |Criacao                                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function TTFAT18C( cNumNf,cSerie,cCliente,cLoja,axItens )

Local aArea			:= GetArea()
Local aMata240		:= {}
Local cCusto		:= ""
Local cItem			:= ""
Local cCLVL 		:= ""
Local cTM			:= If(cEmpAnt=="01",GetMv( "MV_XTMSD3",,"001" ),"") 
Local dData			:= stod("")
Local nPos			:= 0
Local nQuant		:= 0
Local cArmA			:= ""
Default axItens		:= {}	// quando entrada parcial
Private lMsErroAuto	:= .F.

If cEmpAnt <> "01"	
	Return
EndIF

dbSelectArea("SF2")
dbsetOrder(2)
If dbSeek( cFilAnt +AvKey(cCliente,"F2_CLIENTE") +AvKey(cLoja,"F2_LOJA") +AvKey(cNumNF,"F2_DOC") +AvKey(cSerie,"F2_SERIE") )
	If AllTrim(SF2->F2_TIPO) == "N" .And. !Empty(SF2->F2_XCODPA) .And. AllTrim(SF2->F2_XNFABAS) == "1" .And. AllTrim(SF2->F2_XFINAL) == "4"
		dData := dDatabase	//SF2->F2_EMISSAO
		    		
		If SubStr( SF2->F2_XCODPA,1,1 ) == "P"
			cArmA := "A" +SubStr( SF2->F2_XCODPA,2 )                   
		EndIf
		
		dbSelectArea("SD2")
		dbSetOrder(3)	// doc serie cliente loja produto item
		If dbSeek( cFilAnt +AvKey(cNumNF,"D2_DOC") +AvKey(cSerie,"D2_SERIE") +AvKey(cCliente,"F2_CLIENTE") +AvKey(cLoja,"F2_LOJA")  )
			While SD2->D2_FILIAL == SF2->F2_FILIAL .And. SD2->D2_DOC == SF2->F2_DOC .And. SD2->D2_SERIE == SF2->F2_SERIE .And.;
				SD2->D2_CLIENTE == SF2->F2_CLIENTE .And. SD2->D2_LOJA == SF2->F2_LOJA
			    
			    nQuant := SD2->D2_QUANT
			    
			    // ajusta rota nao movimentada
			    If SubStr(SF2->F2_XCODPA,1,1) == "R"
			    	If SD2->D2_XSLDPA == 0
			    		RecLock("SD2",.F.)
			    		SD2->D2_XSLDPA := SD2->D2_QUANT
			    		MsUnLock()	
			    	EndIf                 
			    	If Empty(SD2->D2_XCODPA)
			    		RecLock("SD2",.F.)
			    		SD2->D2_XCODPA := SF2->F2_XCODPA
			    		MsUnLock()
			    	EndIf
			    EndIf
			    
			   
			    // verifica se ja houve movimentacao anteriormente
			    If SubStr( SF2->F2_XCODPA,1,1 ) == "P"
				    If !ChkMov( cNumNF,cSerie,cCliente,cLoja,SD2->D2_ITEM,SD2->D2_COD,SF2->F2_XCODPA,nQuant,dData,cTM )
						dbSelectArea("SB2")
						dbSetOrder(1)
						If !dbSeek( xFilial("SB2") +SD2->D2_COD +SF2->F2_XCODPA )
							CriaSB2( SD2->D2_COD,SF2->F2_XCODPA )
						EndIf
					    
						aMata240 := {}
						aAdd(aMata240, {})
						aAdd(aMata240[1], {'D3_FILIAL' ,cFilAnt	        ,Nil})
						aAdd(aMata240[1], {'D3_TM'     ,cTM		        ,Nil})
						aAdd(aMata240[1], {'D3_COD'    ,SD2->D2_COD    ,Nil})
						aAdd(aMata240[1], {'D3_UM'     ,SD2->D2_UM     ,Nil})
						aAdd(aMata240[1], {'D3_QUANT'  ,nQuant  		,Nil})
						aAdd(aMata240[1], {'D3_LOCAL'  ,SF2->F2_XCODPA ,Nil})
						aAdd(aMata240[1], {'D3_EMISSAO',SD2->D2_EMISSAO,Nil})
						//aAdd(aMata240[1], {'D3_DOC'    ,SD2->D2_DOC    ,Nil})
						aAdd(aMata240[1], {'D3_CONTA'  ,SD2->D2_CONTA  ,Nil})
						aAdd(aMata240[1], {'D3_CC'     ,SD2->D2_CCUSTO ,Nil})
						aAdd(aMata240[1], {'D3_CLVL'   ,SD2->D2_CLVL   ,Nil})
						aAdd(aMata240[1], {'D3_ITEMCTA',SD2->D2_ITEMCC ,Nil})
						
						aAdd(aMata240[1], {'D3_XNUMNF' ,SD2->D2_DOC    ,Nil})
						aAdd(aMata240[1], {'D3_XSERINF',SD2->D2_SERIE  ,Nil})
						aAdd(aMata240[1], {'D3_XCLIENT',SD2->D2_CLIENTE,Nil})
						aAdd(aMata240[1], {'D3_XLOJCLI',SD2->D2_LOJA   ,Nil})
						aAdd(aMata240[1], {'D3_XITEMNF',SD2->D2_ITEM   ,Nil})
						//aAdd(aMata240[1], {'D3_XSLDONF',nQuant		  ,Nil})
						aAdd(aMata240[1], {'D3_XORIGEM',"TTFAT18C"		,Nil})
						
						lMsErroAuto := .F.
						MSExecAuto({|x,y| mata240(x,y)},aMata240[1],3)
						If lMsErroAuto
							Conout("# TTFAT18C " +"ERRO AO DAR ENTRADA NO ARMAZEM PA " +"|" +"NF: " +cNumNF +" SERIE: " +cSerie +" ITEM: "+SD2->D2_ITEM )
						EndIf
				    EndIf    
				EndIf				    
			    
			            
				// ENTRAR ARMAZEM A
				If !Empty( cArmA )
					If !ExistSZ5( cArmA,SD2->D2_COD,cTM,dData,nQuant,"TTFAT18C",SF2->F2_DOC, SD2->D2_ITEM )
						U_MntSZ5( cArmA,SD2->D2_COD,cTM,dData,nQuant,"","","ENTRADA DE MERCADORIA","TTFAT18C","","",.F.,SF2->F2_DOC, SD2->D2_ITEM )
					EndIf
				EndIf
				
							
				// ENTRAR ARMAZEM ROTA SZ6
				If SubStr(SF2->F2_XCODPA,1,1) == "R"
					dbSelectArea("SB2")
					dbSetOrder(1)
					If !MSSeek( xFilial("SB2") +AvKey(SD2->D2_COD,"B2_COD") +AvKey(SF2->F2_XCODPA,"B2_LOCAL") )
						CriaSB2( SD2->D2_COD,SF2->F2_XCODPA )
					EndIf
					
					dbSelectArea("SZ6")
					dbSetOrder(1)
					If !MsSeek( xFilial("SZ6") +AvKey(SF2->F2_XCODPA,"Z6_LOCAL") +AvKey(SD2->D2_COD,"Z6_COD") )
						//STATICCALL( ESTXFUN,CRIASZ6,SD2->D2_COD,SF2->F2_XCODPA )
						U_CRIASZ6(SD2->D2_COD,SF2->F2_XCODPA)
					EndIf
					
					dbSelectArea("SD2")						
					If !ExistSZ5( SF2->F2_XCODPA,SD2->D2_COD,cTM,dData,nQuant,"TTFAT18C",SF2->F2_DOC,SD2->D2_ITEM )
						U_MntSZ5( SF2->F2_XCODPA,SD2->D2_COD,cTM,dData,nQuant,"","","ENTRADA DE MERCADORIA","TTFAT18C","","",.T.,SF2->F2_DOC, SD2->D2_ITEM )
					EndIf
				EndIf
						
				dbSelectArea("SD2")
	
				dbSkip()
			End
		EndIf		
	EndIf	
EndIf
		

RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkMov  บAutor  ณJackson E. de Deus    บ Data ณ  06/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se ja houve a movimentacao para a PA              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkMov(cNumNF,cSerie,cCliente,cLoja,cItem,cProduto,cLocal,nQuant,dData,cTM)

Local lExiste := .F.
Local cSql := ""
Local aArea := GetArea()

cSql := "SELECT COUNT(*) TOTAL FROM " +RetSqlName("SD3")
cSql += " WHERE D3_XNUMNF = '"+cNumNF+"' AND D3_XSERINF = '"+cSerie+"' AND D3_XCLIENT = '"+cCliente+"' AND D3_XLOJCLI = '"+cLoja+"' "
cSql += " AND D3_XITEMNF = '"+cItem+"' AND D3_COD = '"+cProduto+"' "
cSql += " AND D3_LOCAL = '"+cLocal+"' AND D3_TM = '"+cTM+"' AND D3_QUANT = '"+CVALTOCHAR(nQuant)+"' AND D3_EMISSAO >= '"+DTOS(dData)+"'  AND D_E_L_E_T_ = '' "

If Select("TRBX") > 0
	TRBX->(dbCloseArea())
EndIf   
               
TcQuery cSql New Alias "TRBX"
dbSelectArea("TRBX")
If !EOF()
	If TRBX->TOTAL > 0
		lExiste := .T.
	EndIf
EndIf

TRBX->(dbCloseArea())
                        
RestArea(aArea)

Return lExiste


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT18C  บAutor  ณMicrosiga           บ Data ณ  01/16/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ExistSZ5( cLocal,cProduto,cTM,dData,nQuant,cOrigem,cNumNF,cItem )

Local lExiste := .F.
Local cQuery := ""


cQuery := "SELECT COUNT(*) TOTAL FROM " +RetSqlName("SZ5")   
cQuery += " WHERE Z5_FILIAL = '"+xFilial("SZ5")+"' "
cQuery += " AND Z5_LOCAL = '"+cLocal+"' AND Z5_COD = '"+cProduto+"' "
cQuery += " AND Z5_TM = '"+cTm+"' "
cQuery += " AND Z5_EMISSAO = '"+DTOS(dData)+"' "
cQuery += " AND Z5_QUANT = '"+CVALTOCHAR(nQuant)+"' "
cQuery += " AND Z5_ORIGEM = '"+cOrigem+"' "
cQuery += " AND D_E_L_E_T_ = '' " 
cQuery += " AND Z5_NF = '"+cNumNF+"' "
cQuery += " AND Z5_NFITEM = '"+cItem+"' "


MpSysOpenQuery(cQuery,"TRBZ5")

dbSelectArea("TRBZ5")
If !EOF()
	If TRBZ5->TOTAL > 0
		lExiste := .T.
	EndIf
EndIf

TRBZ5->(dbCloseArea())


Return lExiste							