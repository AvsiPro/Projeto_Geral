  
/*--------------------------|
|Bibliotecas de Funções		|
|--------------------------*/  
 #INCLUDE "RWMAKE.CH"      // 
 #INCLUDE "TOPCONN.CH"     //
/*-------------------------*/

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦TTESTR08() ¦ Autor ¦ Fabio Sales		    ¦ Data ¦29.03.2012¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦Acompanhamento das entradas de materiais		          	  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Estoque/Custos/Compras                                  	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

User Function TTESTR08()
	Local oReport
	If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
		oReport := ReportDef()
		oReport:PrintDialog()	
	EndIf
Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ReportDef() ¦ Autor ¦ Fabio Sales		    ¦ Data ¦29.03.2012¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Função principal de impressão  							  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Estoque/Custos/Compras                                 	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function ReportDef()

	Local oReport
	Local oSection
	Private cPerg    := "TTESTR08"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New("TTESTR08","Relatório de pedido compra","",{|oReport| PrintReport(oReport)},"Este relatório irá mostrar a situação dos pedidos de compra")
		
	oSection1 := TRSection():New(oReport,OemToAnsi("Pedidos de compra"),{"TRB"})
	
	/*-------------------------------------------------------------------------------------\ 
	|                       campo        alias  título       	 	pic           tamanho  | 
	\-------------------------------------------------------------------------------------*/  		
						
	TRCell():New(oSection1,"STATU"		,"TRB","STATUS DO PEDIDO"	,"@!"			,40) 	
	TRCell():New(oSection1,"PRODUTO"	,"TRB","PRODUTO"			,"@!"			,15)
	TRCell():New(oSection1,"DESCPR"		,"TRB","DESC_PRODUTO"		,"@!"			,30)
	TRCell():New(oSection1,"UNIMED"   	,"TRB","UNI_MEDIDA"			,"@!"			,40)
	TRCell():New(oSection1,"LOCAL"		,"TRB","ARMAZEM"			,"@!"			,06)
	TRCell():New(oSection1,"SALDEST"	,"TRB","SALDO_ESTOQUE	"	,"@E 999,999.99",16)		
	TRCell():New(oSection1,"QTDEORI"	,"TRB","QTDE_ORIGEM	"		,"@E 999,999.99",16)	
	TRCell():New(oSection1,"QTDEPP"		,"TRB","QTDE_PENDENTE	"	,"@E 999,999.99",16)		
	TRCell():New(oSection1,"QTDEPN"		,"TRB","QTDE_PRE_NOTA	"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"QTDEAT"		,"TRB","QTDE_ATENDIDA	"	,"@E 999,999.99",16)		
	TRCell():New(oSection1,"PEDIDO"		,"TRB","PEDIDO"				,"@!"			,06)	
	TRCell():New(oSection1,"EMISSAO"	,"TRB","DT_EMISSAO"	,						,08)
	TRCell():New(oSection1,"DATPRF"		,"TRB","DATA_PREV_ENTREGA"	,				,08)
			
Return oReport

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦PrintReport() ¦ Autor ¦ Fabio Sales	    ¦ Data ¦21.03.2012¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Função responsável pela impressão do relatório			  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Estoque/Custos/Compras                                  	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function PrintReport(oReport)

	Local oSection1 := oReport:Section(1)
	
	/*-----------------------------------------------------------------| 		    			           
	| seleção dos dados a serem impressos/carrega o arquivo temporário | 
	|-----------------------------------------------------------------*/
	
	MsAguarde({|| fSelDados()},"Selecionando Itens")
	
	/*-------------------------| 		    			           
	| imprime a primeira seção | 
	|-------------------------*/
	
	DbSelectArea("TRB")
	DbGoTop()
	oReport:SetMeter(RecCount())
	oSection1:Init()
	While  !Eof() 
		If oReport:Cancel()
			Exit
		EndIf
		oSection1:PrintLine()
		DbSelectArea("TRB")
		DbSkip()
		oReport:IncMeter()
	EndDo
	oSection1:Finish()
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
		
Return

	/*-----------------------------------------------------------| 		    			           
	| seleciona os dados a serem impressos/criacao do temporário | 
	|-----------------------------------------------------------*/ 

Static Function fSelDados()
   
	Local clQuery
     
	/*-------------------------------| 		    			           
	| criação do arquivo de trabalho |
	|-------------------------------*/
	
	aStru	:= {}
		
	AADD(aStru, {"STATU"  	,"C",40,0})
	AADD(aStru, {"PRODUTO"  ,"C",15,0})
	AADD(aStru, {"DESCPR"  	,"C",35,0})
	AADD(aStru, {"UNIMED"  	,"C",02,0})
	AADD(aStru, {"LOCAL"  	,"C",06,0})
	AADD(aStru, {"QTDEORI"	,"N",14,2})	
	AADD(aStru, {"QTDEPP"	,"N",14,2})	
	AADD(aStru, {"SALDEST"	,"N",14,2})
	AADD(aStru, {"QTDEPN"	,"N",14,2})
	AADD(aStru, {"QTDEAT"	,"N",14,2})
	AADD(aStru, {"PEDIDO"  	,"C",15,0})
	AADD(aStru, {"EMISSAO"  ,"D",08,0})
	AADD(aStru, {"DATPRF"   ,"D",08,0})	
	
   	_cArq     := CriaTrab(aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)
	                                            
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	IndRegua("TRB",_cIndice,"PRODUTO",,,"Selecionando Registros...")
	
	/*-------------------| 		    			           
	| Montagem da query  |
	|-------------------*/    
	
	clQry := " SELECT C7_FILIAL "
	clQry += "	,'STATU' = CASE WHEN(C7_RESIDUO = 'R' AND C7_QUJE=0) THEN 'Resido total eliminado' ELSE "
	clQry += "	CASE WHEN C7_RESIDUO ='' AND C7_QUANT > C7_QUJE AND C7_QUJE<>0 THEN 'Pedido parcialmente atendido' ELSE "
	clQry += "	CASE WHEN C7_RESIDUO='S' AND C7_QUJE<>0 THEN 'Pedido parc. atendido e res. eliminado' ELSE "
	clQry += "	CASE WHEN C7_QUANT=C7_QUJE THEN 'Pedido total atendido' ELSE 'Pedido não atendido' END END END END "
	clQry += "	,C7_PRODUTO,B1_DESC,B1_UM,C7_QUANT,'QTDEPP'=CASE WHEN C7_RESIDUO='' THEN C7_QUANT - C7_QUJE ELSE 0 END "
	clQry += "	,'QTDEPN'=CASE WHEN (C7_QUANT<>C7_QUJE AND C7_QTDACLA<>0) THEN C7_QTDACLA ELSE 0 END "
	clQry += "	,'QTDEAT'=CASE WHEN C7_QUJE<>0 THEN C7_QUJE ELSE 0 END "
	clQry += "	,C7_NUM,C7_LOCAL,C7_EMISSAO ,C7_DATPRF,C7_RESIDUO  FROM "+RetSqlName("SC7")+" AS SC7 "
	clQry += " INNER JOIN "+RetSqlName("SB1")+" AS SB1 ON C7_PRODUTO=B1_COD "
	clQry += " WHERE C7_PRODUTO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND SC7.D_E_L_E_T_='' "
	clQry += " AND C7_NUM BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	clQry += " AND C7_DATPRF BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"'	"
	 	 
	If MV_PAR07==1 
		clQry += " AND C7_QUANT > C7_QUJE AND C7_QUJE<>0 "
	ElseIf MV_PAR07==2
		clQry += " AND C7_QUANT = C7_QUJE "
	Elseif MV_PAR07==3
		clQry += " AND C7_QUJE=0 "
	EndIf
	       	
	If Select("PEDID") > 0
		dbSelectArea("PEDID")
		DbCloseArea()
	EndIf
	MemoWrite("TTESTR08.SQL",clQry)
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,clQry),"PEDID",.F.,.T.)
	
	/*--------------------------------------------------| 		    			           
	| ajusta casas decimais e datas no retorno da query |
	|--------------------------------------------------*/
	 		
	TcSetField("PEDID","QTDEPP"	 	,"N",14,2)
	TcSetField("PEDID","C7_QUANT"	,"N",14,2)
	TcSetField("PEDID","QTDEPN"	 	,"N",14,2)
	TcSetField("PEDID","QTDEAT"	 	,"N",14,2)
	TcSetField("PEDID","C7_DATPRF"	,"D",08,0)
	TcSetField("PEDID","C7_EMISSAO"	,"D",08,0)
	
	dbSelectArea("PEDID")
	dbGotop()	
	Do While PEDID->(!Eof())
		DbSelectArea("TRB")
		RecLock("TRB",.T.)								
				TRB->STATU		:= PEDID->STATU
				TRB->PRODUTO	:= PEDID->C7_PRODUTO
				TRB->DESCPR		:= PEDID->B1_DESC
				TRB->UNIMED		:= PEDID->B1_UM
				TRB->LOCAL		:= PEDID->C7_LOCAL
				TRB->PEDIDO		:= PEDID->C7_NUM				
				TRB->SALDEST	:= Posicione("SB2",1,PEDID->C7_FILIAL+PEDID->C7_PRODUTO+PEDID->C7_LOCAL,"B2_QATU")
				TRB->QTDEORI	:= PEDID->C7_QUANT
				TRB->QTDEPP		:= PEDID->QTDEPP
				TRB->QTDEPN		:= PEDID->QTDEPN
				TRB->QTDEAT		:= PEDID->QTDEAT
				TRB->EMISSAO	:= PEDID->C7_EMISSAO
				TRB->DATPRF		:= PEDID->C7_DATPRF
	 	MsUnlock()
	 	dbSelectArea("PEDID")
     	DbSkip() // Pula para o próximo registro
	Enddo	
Return

Static Function ValPerg(cPerg)

	PutSx1(cPerg,"01","Produto de   ?","","","mv_ch1","C",15,00,00,"G","","SB1","","","mv_Par01","","","","","","","","","","","","","","","","",{"Informe o produto, que apartir do qual Você deseja imprimi"},{},{},"")
	PutSx1(cPerg,"02","Produto ate  ?","","","mv_ch2","C",15,00,00,"G","","SB1","","","mv_Par02","","","","","","","","","","","","","","","","",{"Informe o produto final a imprimir para compor o intervalo"},{},{},"")
	PutSx1(cPerg,"03","Pedido de    ?","","","mv_ch3","C",06,00,00,"G","","","","","mv_Par03","","","","","","","","","","","","","","","","",{"Informe o pedido, que apartir do qual Você deseja imprimi"},{},{},"")
	PutSx1(cPerg,"04","Pedido ate   ?","","","mv_ch4","C",06,00,00,"G","","","","","mv_Par04","","","","","","","","","","","","","","","","",{"Informe o pedido final a imprimir para compor o intervalo"},{},{},"")
	PutSx1(cPerg,"05","Entrega prev. de  ?","","","mv_ch5","D",08,00,00,"G","","","","","mv_Par05","","","","","","","","","","","","","","","","",{"Informe a entrega prevista de"},{},{},"")
	PutSx1(cPerg,"06","Entrega prev. ate ?","","","mv_ch6","D",08,00,00,"G","","","","","mv_Par06","","","","","","","","","","","","","","","","",{"Informe a entrega prevista ate"},{},{},"")	
	PutSx1(cPerg,'07','Status   ?','','','mv_ch7','N',1,0,1,'C','','','','','mv_par07',"Atendido Parcial","","","","Total Atendido","","","não atendido","","","todos","","","","","")
	
Return nil
