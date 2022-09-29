#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT19C  บAutor  ณJackson E. de Deus  บ Data ณ  06/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Movimenta estoque - Faz a baixa da qtd que faltou na dev.  บฑฑ
ฑฑบ          ณ Controle de Entregas                                       บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณJackson	       ณ06/04/15ณ01.00 |Criacao                               ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function TTFAT19C( cNumNF,cSerie,cCliente,cLoja )
                          
Local aArea := GetArea()
Local aMata240 := {}
Local cProduto := ""
Local cCusto := ""
Local cItem  := ""
Local cCLVL  := ""
Local cTM	 := If(cEmpAnt=="01",GetMv("MV_XLOG003",,"515"),"")
Local aAux	 := {} 
Local dData  := stod("")
Local nI 
Local lEstOk := .T.
Local lClass := .F.
Private lMsErroAuto := .F.

If cEmpAnt <> "01"
	Return
EndIF

dbSelectArea("SF1")
dbSetOrder(1)	// forn loja nf serie tipo
If dbSeek( xFilial("SF1") +AvKey(cNumNF,"F1_DOC") +AvKey(cSerie,"F1_SERIE") +AvKey(cCliente,"F1_FORNECE") +AvKey(cLoja,"F1_LOJA") +AvKey("D","F1_TIPO")  )
	If !Empty(SF1->F1_STATUS)
		lClass := .T.
	EndIf
		
	If lClass
		dbSelectArea("SD1")
		dbSetOrder(1)	// doc serie cliente loja produto item
		If dbSeek( xFilial("SD1") +AvKey(cNumNF,"D1_DOC") +AvKey(cSerie,"D1_SERIE") +AvKey(cCliente,"D1_FORNECE") +AvKey(cLoja,"D1_LOJA")  )
			While SD1->D1_FILIAL == SF1->F1_FILIAL .And. SD1->D1_DOC == SF1->F1_DOC .And. SD1->D1_SERIE == SF1->F1_SERIE .And.;
				SD1->D1_FORNECE == SF1->F1_FORNECE .And. SD1->D1_LOJA == SF1->F1_LOJA
				
				cProduto := SD1->D1_COD
				cItem := PadL( cvaltochar(val(SD1->D1_ITEM)) , TamSx3("D3_XITEMNF")[1], "0" )

				// Verifica Nf de Origem
				dbSelectArea("SF2")
				dbsetOrder(2)
				If dbSeek( xFilial("SF2") +AvKey(cCliente,"F2_CLIENTE") +AvKey(cLoja,"F2_LOJA") +AvKey(SD1->D1_NFORI,"F2_DOC") +AvKey(SD1->D1_SERIORI,"F2_SERIE") )
					If !Empty(SF2->F2_XCODPA) .And. AllTrim(SF2->F2_XNFABAS) == "1" .And. AllTrim(SF2->F2_XFINAL) == "4"
						
						dData := SF2->F2_EMISSAO
						
						// verifica se ja houve a movimentacao anteriormente
					    If ChkMov(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA,cItem,cProduto,SD1->D1_LOCAL,SD1->D1_QUANT,dData,cTM)
				    		dbSelectArea("SD1")
					    	SD1->(dbSkip())
					    	Loop
					    EndIf
						
						dbSelectArea("SD2")
						dbSetOrder(3)	// doc serie cliente loja produto item
						If dbSeek( xFilial("SD2") +AvKey(SF2->F2_DOC,"D2_DOC") +AvKey(SF2->F2_SERIE,"D2_SERIE") +AvKey(SF2->F2_CLIENTE,"F2_CLIENTE") +AvKey(SF2->F2_LOJA,"F2_LOJA") +AvKey(cProduto,"D2_COD") +AvKey(cItem,"D2_ITEM")  )
							aAux := {}                                                                                                            
										
							aAdd(aAux, {'D3_TM'     	,cTM			,Nil})
							aAdd(aAux, {'D3_COD'    	,SD1->D1_COD    ,Nil})
							aAdd(aAux, {'D3_UM'     	,SD1->D1_UM     ,Nil})
							aAdd(aAux, {'D3_QUANT'  	,SD1->D1_QUANT	,Nil})
							aAdd(aAux, {'D3_LOCAL'  	,SD1->D1_LOCAL	,Nil})
							aAdd(aAux, {'D3_EMISSAO'	,SD1->D1_DTDIGIT,Nil})
							aAdd(aAux, {'D3_DOC'    	,SD1->D1_DOC    ,Nil})
							aAdd(aAux, {'D3_CUSTO1'		,SD1->D1_TOTAL	,Nil})
							aAdd(aAux, {'D3_XNUMNF' 	,SD1->D1_DOC    ,Nil})
							aAdd(aAux, {'D3_XSERINF'	,SD1->D1_SERIE  ,Nil})
							aAdd(aAux, {'D3_XCLIENT'	,SD1->D1_FORNECE,Nil})
							aAdd(aAux, {'D3_XLOJCLI'	,SD1->D1_LOJA   ,Nil})
							aAdd(aAux, {'D3_XITEMNF'	,cItem		    ,Nil})
							aAdd(aAux, {'D3_XORIGEM'	,"TTFAT19C"  	,Nil})
							
							aAdd(aMata240, aAux)
							
							dbSelectArea("SD1")
							SD1->(dbSkip())
						EndIf
					EndIf	
				EndIf
			End
		EndIf
		
		BeginTran()
		For nI := 1 To Len(aMata240)
			lMsErroAuto := .F.
			MSExecAuto({|x,y| mata240(x,y)},aMata240[nI],3)
			If lMsErroAuto
				lEstOk := .F.
				Conout( "#TTFAT19C - " +"ERRO AO DAR BAIXA DE PRODUTOS " +"NF: " +cNumNF +"/" +cSerie )
				//MostraErro()
			EndIf                   
		Next nI
		
		If lEstOk
			EndTran()
		Else
			DisarmTransation()
			MsgAlert("Houve erro ao gerar as baixas dos produtos." ,"TTFAT14C")
		EndIf	
	EndIf
EndIf


RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkMov  บAutor  ณJackson E. de Deus	 บ Data ณ  24/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se ja houve a baixa do estoque                    บฑฑ
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
cSql += " AND D3_XITEMNF = '"+cItem+"' AND D3_COD = '"+cProduto+"' AND D3_EMISSAO >= '"+DTOS(dData)+"' "
cSql += " AND D3_LOCAL = '"+cLocal+"' AND D3_TM = '"+cTM+"' AND D3_QUANT = '"+CVALTOCHAR(nQuant)+"' AND D_E_L_E_T_ = '' "

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