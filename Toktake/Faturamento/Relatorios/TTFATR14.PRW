
/*--------------------------|
|BIBLIOTECAS DE FUNÇÕES		|
|--------------------------*/  
 #INCLUDE "RWMAKE.CH"      // 
 #INCLUDE "TOPCONN.CH"     //
/*-------------------------*/

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦TTFATR08() ¦ Autor ¦ FABIO SALES		    ¦ Data ¦17.06.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ VENDAS E DEVOLUÇÕES						                  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ FATURAMENTO                                          	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/ 

User Function TTFATR14()
	Local oReport
	If cEmpAnt == "01"
		If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
			oReport := ReportDef()
			oReport:PrintDialog()	
		EndIf
	endif
Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦REPORTDEF ¦ Autor ¦ FABIO SALES		    ¦ Data ¦17.06.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ FUNÇAO PRINCIPAL DE IMPRESSAO   			                  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ FATURAMENTO                                          	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/  

Static Function ReportDef()

	Local oReport
	Local oSection
	Private cPerg    := "TTFATR14"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New("VENDAS E FINANCEIRO","Vendas e Financeiro","",{|oReport| PrintReport(oReport)},"Impressão das notas de saidas X Financeiro")
	
	/*------------------------| 		    			           
	| seção das notas fiscais | 
	|------------------------*/
	
	oSection1 := TRSection():New(oReport,OemToAnsi("vendas"),{"TRB"})
	
	/*----------------------------------------------------------------------------------| 		    			           
	|                       campo        alias  título       	 pic           tamanho  | 
	|----------------------------------------------------------------------------------*/
	
	TRCell():New(oSection1,"TIPO"		,"TRB","TIPO"			,"@!"			,20)
	TRCell():New(oSection1,"STATUPG"	,"TRB","STATUS_PAGAMENTO","@!"			,20)	
	TRCell():New(oSection1,"DTBAIXA"	,"TRB","DATA_BAIXA"     ,			    ,08)	
	TRCell():New(oSection1,"FILIAL"		,"TRB","FILIAL	"		,"@!"			,02)
	TRCell():New(oSection1,"NOTA"		,"TRB","NOTA	"		,"@!"			,09)
	TRCell():New(oSection1,"SERIE"		,"TRB","SERIE	"		,"@!"			,03)
	TRCell():New(oSection1,"EMISSAO"	,"TRB","EMISSAO	"		,				,08)
	TRCell():New(oSection1,"PEDIDO"		,"TRB","NUM_PED	"		,"@!"			,06)
	TRCell():New(oSection1,"COD_CLI"	,"TRB","COD_CLI	"		,"@!"			,06)
	TRCell():New(oSection1,"CLIENTE"	,"TRB","CLIENTE	"		,"@!"			,40)
	TRCell():New(oSection1,"LOJA"		,"TRB","LOJA	"		,"@!"			,04)
	TRCell():New(oSection1,"PRODUTO"	,"TRB","COD_PROD"		,"@!"			,15)
	TRCell():New(oSection1,"DESCPRO"	,"TRB","DESC_PROD"		,"@!"			,30)
	TRCell():New(oSection1,"QTDE"	    ,"TRB","QUANTIDADE"		,"@E 999,999,999.99",16)
	TRCell():New(oSection1,"PR_UNIT"	,"TRB","PR_UNITÁRIO"	,"@E 999,999,999.99",16)
	TRCell():New(oSection1,"TOTAL"		,"TRB","TOT_MERC"		,"@E 999,999,999.99",16)
	TRCell():New(oSection1,"FRETE"   	,"TRB","FRETE	"		,"@E 999,999,999.99",16)
	TRCell():New(oSection1,"DESPESA"	,"TRB","DESPESAS"		,"@E 999,999,999.99",16)
	TRCell():New(oSection1,"SEGURO"   	,"TRB","SEGURO	"		,"@E 999,999,999.99",16)
	TRCell():New(oSection1,"DESCONTO"	,"TRB","DESCONTOS"		,"@E 999,999,999.99",16)	
	TRCell():New(oSection1,"PIS"   		,"TRB","PIS		"		,"@E 999,999,999.99",16)
	TRCell():New(oSection1,"CONFINS"	,"TRB","CONFINS	"		,"@E 999,999,999.99",16)
	TRCell():New(oSection1,"ICMS"		,"TRB","VAL_ICMS"		,"@E 999,999,999.99",16)
	TRCell():New(oSection1,"ICMS_ST"	,"TRB","VAL_ICMS_ST"	,"@E 999,999,999.99",16)	  	
	TRCell():New(oSection1,"TES"		,"TRB","TES		"		,"@!"			,03)
	TRCell():New(oSection1,"CFOP"		,"TRB","CFOP	"		,"@!"			,05)
	TRCell():New(oSection1,"NCM"		,"TRB","NCM		"		,"@!"			,10)
	TRCell():New(oSection1,"FINALID"	,"TRB","FINALID_TES"	,"@!"			,30)
			
Return oReport

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦PrintReport() ¦ Autor ¦ FABIO SALES	    ¦ Data ¦17.06.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ FUNCAO RESPONSÁVEL PELA IMPRESSÃO DO RELATÓRIO			  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ FATURAMENTO                                          	  ¦¦¦
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

	/*-----------------------------------------------------------------| 		    			           
	| seleção dos dados a serem impressos/carrega o arquivo temporário | 
	|-----------------------------------------------------------------*/
	
Static Function fSelDados()
     Local clTipo
     Local clStatus
     Local dtBaixa
     Local nlValLiq:=0
	 Local nlValSal:=0
     
	/*-------------------------------| 		    			           
	| criação do arquivo de trabalho | 
	|-------------------------------*/  
	
	_aStru	:= {}

	AADD(_aStru,{"TIPO","C",20,0})
	AADD(_aStru,{"DESCPC","C",13,0})				
	AADD(_aStru,{"NOTA","C",09,0})
	AADD(_aStru,{"SERIE","C",03,0})
	AADD(_aStru,{"COD_CLI","C",06,0})
	AADD(_aStru,{"CLIENTE","C",40,0})
	AADD(_aStru,{"PRODUTO","C",15,0})
	AADD(_aStru,{"DESCPRO","C",30,0})
	AADD(_aStru,{"TES","C",03,0})
	AADD(_aStru,{"CFOP","C",05,0})
	AADD(_aStru,{"NCM","C",10,0})
	AADD(_aStru,{"TOTAL","N",14,2})
	AADD(_aStru,{"PIS","N",14,2})
	AADD(_aStru,{"CONFINS","N",14,2})
	AADD(_aStru,{"DESCONTO","N",14,2})
	AADD(_aStru,{"FRETE","N",14,2})
	AADD(_aStru,{"SEGURO","N",14,2})
	AADD(_aStru,{"DESPESA","N",14,2})	
	AADD(_aStru,{"ICMS_ST","N",14,2})	
	AADD(_aStru,{"FINALID","C",254,0})                                 
	AADD(_aStru,{"FILIAL","C",02,0})
	AADD(_aStru,{"LOJA","C",04,0}) 
	AADD(_aStru,{"ICMS","N",14,2})                                 
	AADD(_aStru,{"QTDE","N",14,2})
	AADD(_aStru,{"PR_UNIT","N",14,2})
	AADD(_aStru,{"PEDIDO","C",06,0})
	AADD(_aStru,{"STATUPG","C",30,0})	
	AADD(_aStru,{"DTBAIXA","D",8,0})
	AADD(_aStru,{"EMISSAO","D",8,0})

   	_cArq     := CriaTrab(_aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)
	                                            
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	IndRegua("TRB",_cIndice,"CLIENTE",,,"Selecionando Registros...")
	                                               
	/*------------------------------------------------------------------------| 		    			           
	| Montagem da query com os dados das notas fiscais de vendas e devolucoes |
	|------------------------------------------------------------------------*/ 
		
	_cQuery := " SELECT "     
	_cQuery += " SD2.D2_TIPO AS TIPO , SD2.D2_CLIENTE AS CLIFOR, SD2.D2_DOC AS DOC, SD2.D2_SERIE AS SERIE, SD2.D2_CF AS CF, SD2.D2_TES AS TES, SF4.F4_FINALID AS FINALID, SD2.D2_COD AS COD,SD2.D2_PEDIDO AS PEDIDO,SD2.D2_QUANT AS QUANT, "
	_cQuery += " SD2.D2_PRUNIT AS PRUNIT,SD2.D2_VALICM AS VALICM,SB1.B1_DESC,SD2.D2_TOTAL AS TOTAL,SD2.D2_VALIMP5 AS VALIMP5, SD2.D2_VALIMP6 AS VALIMP6,SD2.D2_FILIAL AS FILIAL, SA1.A1_NOME AS NOMFORCLI, SA1.A1_LOJA AS LOJA, "
	_cQuery += " SD2.D2_DESCON AS DESCON,SD2.D2_VALFRE AS VALFRE, SD2.D2_SEGURO AS SEGURO,SD2.D2_DESPESA AS DESPESA,SD2.D2_ICMSRET AS ICMSRET,SD2.D2_EMISSAO AS EMISSAO,'STATUSPG'=CASE WHEN E1_VALLIQ=0 AND E1_BAIXA='' THEN 'ABERTO' "
	_cQuery += " ELSE CASE WHEN E1_VALLIQ > 0 AND E1_SALDO > 0 THEN 'PACIAL ABERTO'  ELSE CASE WHEN E1_SALDO=0 THEN 'PAGO' END END END,E1_BAIXA AS BAIXA " 
	_cQuery += " FROM "
	_cQuery += " "+RetSQLName("SD2")+" AS SD2 INNER JOIN "
	_cQuery += " "+RetSQLName("SA1")+" AS SA1 ON SD2.D2_CLIENTE = SA1.A1_COD AND SD2.D2_LOJA = SA1.A1_LOJA "
	_cQuery += " INNER JOIN "+RetSQLName("SB1")+" AS SB1 ON SD2.D2_COD = SB1.B1_COD 	"
	_cQuery += " INNER JOIN "+RetSQLName("SF4")+" AS SF4 ON SD2.D2_TES = SF4.F4_CODIGO	"
	_cQuery += " AND SD2.D2_FILIAL = SF4.F4_FILIAL INNER JOIN "+RetSQLName("SE1")+" AS SE1 ON "
	_cQuery += " D2_DOC=E1_NUM AND (D2_FILIAL + D2_SERIE)=E1_PREFIXO AND D2_CLIENTE=E1_CLIENTE AND D2_LOJA=E1_LOJA "
	_cQuery += " WHERE "
	_cQuery += " (SD2.D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"') AND "
	_cQuery += " (SD2.D2_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"') AND (SD2.D2_DOC BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"') AND "	
	_cQuery += " (SD2.D2_SERIE BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"') AND (SD2.D2_CLIENTE BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"') AND "
	_cQuery += " (SD2.D2_LOJA BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"') AND  SD2.D2_FILIAL ='"+xFilial("SD2")+"' "	                                          
	_cQuery += " AND SB1.B1_FILIAL ='"+xFilial("SB1")+"' AND SA1.A1_FILIAL ='"+xFilial("SA1")+"' AND  SE1.E1_FILIAL ='"+xFilial("SE1")+"' "
	_cQuery += " AND SF4.F4_FILIAL ='"+xFilial("SF4")+"' AND (SD2.D2_TIPO IN( 'N','C')) AND (SF4.F4_DUPLIC = 'S') AND SE1.E1_TIPO='NF' "
	_cQuery += " AND SD2.D_E_L_E_T_='' AND SA1.D_E_L_E_T_='' AND SB1.D_E_L_E_T_='' AND SF4.D_E_L_E_T_='' " 
	
	_cQuery += " UNION ALL "
	
	_cQuery += " SELECT "                                                                                                                              
	_cQuery += " SD1.D1_TIPO AS TIPO , SD1.D1_FORNECE AS CLIFOR, SD1.D1_DOC AS DOC, SD1.D1_SERIE AS SERIE, SD1.D1_CF AS CF, SD1.D1_TES AS TES, SF4.F4_FINALID AS FINALID, SD1.D1_COD AS COD,SD1.D1_PEDIDO AS PEDIDO,-SD1.D1_QUANT AS QUANT, "
	_cQuery += " -SD1.D1_VUNIT AS PRUNIT,-SD1.D1_VALICM AS VALICM,SB1.B1_DESC,-SD1.D1_TOTAL AS TOTAL,-SD1.D1_VALIMP5 AS VALIMP5, -SD1.D1_VALIMP6 AS VALIMP6,SD1.D1_FILIAL AS FILIAL, SA1.A1_NOME AS NOMFORCLI, SA1.A1_LOJA AS LOJA, "
	_cQuery += " '' AS DESCON,-SD1.D1_VALFRE AS VALFRE,- SD1.D1_SEGURO AS SEGURO,-SD1.D1_DESPESA AS DESPESA,-SD1.D1_ICMSRET AS ICMSRET,SD1.D1_DTDIGIT AS EMISSAO,'' AS  STATUSPG,'' AS BAIXA "
	_cQuery += " FROM "
	_cQuery += " "+RetSQLName("SD1")+" AS SD1 INNER JOIN "
	_cQuery += " "+RetSQLName("SA1")+" AS SA1 ON SD1.D1_FORNECE = SA1.A1_COD AND SD1.D1_LOJA = SA1.A1_LOJA "
	_cQuery += "  INNER JOIN "+RetSQLName("SB1")+" AS SB1 ON SD1.D1_COD = SB1.B1_COD    "
	_cQuery += "  INNER JOIN "+RetSQLName("SF4")+" AS SF4 ON SD1.D1_TES = SF4.F4_CODIGO "
	_cQuery += " AND SD1.D1_FILIAL = SF4.F4_FILIAL "
	_cQuery += " WHERE "
	_cQuery += " (SD1.D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"') AND "
	_cQuery += " (SD1.D1_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"') AND (SD1.D1_DOC BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"') AND "	
	_cQuery += " (SD1.D1_SERIE BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"') AND (SD1.D1_FORNECE BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"') AND "
	_cQuery += " (SD1.D1_LOJA BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"') AND  "	                                          
	_cQuery += " SD1.D1_FILIAL ='"+xFilial("SD1")+"' AND SB1.B1_FILIAL ='"+xFilial("SB1")+"' AND SA1.A1_FILIAL ='"+xFilial("SA1")+"' AND "
	_cQuery += " SF4.F4_FILIAL ='"+xFilial("SF4")+"' AND (SD1.D1_TIPO IN( 'D','C')) AND (SF4.F4_DUPLIC = 'S') "
	_cQuery += " AND SD1.D_E_L_E_T_='' AND SA1.D_E_L_E_T_='' AND SB1.D_E_L_E_T_='' AND SF4.D_E_L_E_T_=''"

	If Select("TSQL1") > 0
		dbSelectArea("TSQL1")
		DbCloseArea()
	EndIf
	
	/*------------------------------| 		    			           
	| cria a query e dar um apelido |
	|-------------------------------*/
	MemoWrite("TTFATR14.SQL",_cQuery) //Salva a Query na pasta sistem para consultas futuras	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TSQL1",.F.,.T.)
	
	/*---------------------------------------------| 		    			           
	| ajusta as casas decimais no retorno da query | 
	|---------------------------------------------*/
		
	TcSetField("TSQL1","TOTAL","N",14,2) 
	TcSetField("TSQL1","EMISSAO","D",08,0)
	TcSetField("TSQL1","BAIXA","D",08,0)
	TcSetField("TSQL1","PRUNIT","N",14,2) 
	TcSetField("TSQL1","QUANT","N",14,2) 
	TcSetField("TSQL1","VALICM","N",14,2) 
	TcSetField("TSQL1","VALIMP5","N",14,2) 
	TcSetField("TSQL1","VALIMP6","N",14,2)
	TcSetField("TSQL1","DESCON","N",14,2) 
	TcSetField("TSQL1","VALFRE","N",14,2) 
	TcSetField("TSQL1","SEGURO","N",14,2) 
	TcSetField("TSQL1","DESPESA","N",14,2)
	TcSetField("TSQL1","ICMSRET","N",14,2)    
	
		
	dbSelectArea("TSQL1")
	dbGotop()
	
	Do While TSQL1->(!Eof())
	     MsProcTxt("Processando Item "+TSQL1->COD)
	         	     
	     IF TSQL1->TIPO=="N"
	     	 clTipo:="VENDA"		
		 ELSEIF TSQL1->TIPO=="D"
		 	clTipo:="DEVOLUÇÃO"
		 ENDIF
		 		   	          
	     DbSelectArea("TRB")
	     
	/*--------------------------| 		    			           
	| adciona registro em banco | 
	|--------------------------*/
	    
	     RecLock("TRB",.T.)	     	                       
	        TRB->TIPO		:= clTipo	     
	     	TRB->COD_CLI	:= TSQL1->CLIFOR
	     	TRB->LOJA		:= TSQL1->LOJA
	      	TRB->CLIENTE	:= TSQL1->NOMFORCLI
		    TRB->NOTA		:= TSQL1->DOC
	    	TRB->PRODUTO	:= TSQL1->COD
	        TRB->DESCPRO	:= TSQL1->B1_DESC	       
	        TRB->TOTAL		:= TSQL1->TOTAL
	        TRB->PIS		:= TSQL1->VALIMP5
	        TRB->CONFINS	:= TSQL1->VALIMP6
	        TRB->DESCONTO	:= TSQL1->DESCON
	        TRB->FRETE		:= TSQL1->VALFRE	        
	        TRB->SEGURO		:= TSQL1->SEGURO
	        TRB->DESPESA	:= TSQL1->DESPESA
	        TRB->ICMS_ST	:= TSQL1->ICMSRET	        	        
	        TRB->SERIE		:= TSQL1->SERIE
	        TRB->CFOP		:= TSQL1->CF 	       
	        TRB->TES		:= TSQL1->TES
	        TRB->FINALID   	:= TSQL1->FINALID 	       
	        TRB->FILIAL   	:= TSQL1->FILIAL	 	        
	        TRB->PEDIDO		:= TSQL1->PEDIDO	        
	        TRB->QTDE		:= TSQL1->QUANT
	        TRB->PR_UNIT	:= TSQL1->PRUNIT	        
	        TRB->ICMS   	:= TSQL1->VALICM
	        TRB->EMISSAO   	:= TSQL1->EMISSAO	        
	        TRB->DTBAIXA   	:= TSQL1->BAIXA
	        TRB->STATUPG	:= TSQL1->STATUSPG	              	         
	  	MsUnlock()
	      dbSelectArea("TSQL1")
	     DbSkip()
	Enddo
	
	If Select("TSQL1") > 0
		dbSelectArea("TSQL1")
		DbCloseArea()
	EndIf
	
Return
Static Function ValPerg(cPerg)

	PutSx1(cPerg,'01','Emissao de            ?','','','mv_ch1','D',8,0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'02','Emissao Ate           ?','','','mv_ch2','D',8,0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'03','Produto de            ?','','','mv_ch3','C',15,0,0,'G','','SB1','','','mv_par03',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'04','Produto Ate           ?','','','mv_ch4','C',15,0,0,'G','','SB1','','','mv_par04',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'05','Nota de               ?','','','mv_ch5','C',09,0,0,'G','','SF2','','','mv_par05',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'06','Nota Ate              ?','','','mv_ch6','C',09,0,0,'G','','SF2','','','mv_par06',,,'','','','','','','','','','','','','','') 		
	PutSx1(cPerg,'07','Serie de              ?','','','mv_ch7','C',03,0,0,'G','','','','','mv_par07',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'08','Serie Ate             ?','','','mv_ch8','C',03,0,0,'G','','','','','mv_par08',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'09','Cliente de            ?','','','mv_ch9','C',06,0,0,'G','','SA1','','','mv_par09',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'10','Cliente Ate           ?','','','mv_cha','C',06,0,0,'G','','SA1','','','mv_par10',,,'','','','','','','','','','','','','','') 		
	PutSx1(cPerg,'11','Loja de               ?','','','mv_chb','C',04,0,0,'G','','','','','mv_par11',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'12','Loja Ate              ?','','','mv_chc','C',04,0,0,'G','','','','','mv_par12',,,'','','','','','','','','','','','','','') 		 		
Return
