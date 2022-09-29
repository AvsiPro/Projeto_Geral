
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
¦¦¦Funçào    ¦TTLUXR001() ¦ Autor ¦ FABIO SALES		    ¦ Data ¦18.06.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ CONTROLE DE ALÇADA								          ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦COMPRAS	                                             	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/  

User Function TTLUXR001()
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
¦¦¦Funçào    ¦REPORTDEF() ¦ Autor ¦ FABIO SALES		    ¦ Data ¦17.06.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ FUNCAO PRINCIPAL D EIMPRESSÀO   							  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ COMPRAS                                               	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function ReportDef()

	Local oReport
	Local oSection
	Private cPerg    := "TTLUXO001"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New("TTLUXO001","PEDIDOS DE VENDAS LIBERADOS","",{|oReport| PrintReport(oReport)},"PEDIDOS DE VENDAS LIBERADOS E NÃO FATURADOS")
	
	/*-------------------------| 		    			           
	| seção dos titulo a pagar | 
	|-------------------------*/
	
	oSection1 := TRSection():New(oReport,OemToAnsi("PEDIDOS DE VENDAS"),{"TRB"})
	
	/*----------------------------------------------------------------------------------| 		    			           
	|                       campo        alias  título       	 pic           tamanho  | 
	|----------------------------------------------------------------------------------*/ 
	
		
	TRCell():New(oSection1,"NOTA"		,"TRB","NOTA	"		,"@!"			,09)
	TRCell():New(oSection1,"SERIE"		,"TRB","SERIE"			,"@!"			,04)
	TRCell():New(oSection1,"CLIENTE"	,"TRB","COD_CLIENTE	"	,"@!"			,06)
	TRCell():New(oSection1,"LOJA"		,"TRB","LOJA	"		,"@!"			,04)				
	TRCell():New(oSection1,"NOME"		,"TRB","RAZAO_SOCIAL"	,"@!"			,30)
	TRCell():New(oSection1,"PEDIDO"		,"TRB","PEDIDO"			,"@!"			,10)		
	TRCell():New(oSection1,"EMISSAO"	,"TRB","EMISSAO	"		,,08)	
	TRCell():New(oSection1,"TES"		,"TRB","TES	"			,"@!"			,09)
	TRCell():New(oSection1,"FINALID"	,"TRB","FINALIDADE_TES"	,"@!"			,04)
	TRCell():New(oSection1,"ITEM"		,"TRB","ITEM	"		,"@!"			,06)
	TRCell():New(oSection1,"CODIDO"		,"TRB","CODIGO	"		,"@!"			,04)				
	TRCell():New(oSection1,"DESC_PROD"	,"TRB","DESC_PROD"		,"@!"			,40)
	TRCell():New(oSection1,"CONPAG"		,"TRB","C. PAGAMENTO"	,"@!"			,10)	
	TRCell():New(oSection1,"D_CONDPG"  	,"TRB","DESC_CONDPG"	,"@!"			,10)
	TRCell():New(oSection1,"MOEDA"		,"TRB","MOEDA"			,"@!"			,35)
   //	TRCell():New(oSection1,"VALFAT"		,"TRB","VALOR_FATURADO"	,"@E 999,999,999.99",14)	 
	TRCell():New(oSection1,"QTD"		,"TRB","QTDE_NF	"		,"@E 999,999,999.99",14)	
	TRCell():New(oSection1,"VALOR"		,"TRB","PRECO_VENDA	"	,"@E 999,999,999.99",14)
	TRCell():New(oSection1,"TABELA"		,"TRB","PRECO_TABELA"	,"@E 999,999,999.99",14)				
	TRCell():New(oSection1,"TOTAL"		,"TRB","TOTAL_NF"		,"@E 999,999,999.99",14)	
	TRCell():New(oSection1,"DESCONTO"	,"TRB","DESCONTO"		,"@E 999,999,999.99",14)		
	TRCell():New(oSection1,"QTD_PV"		,"TRB","QTDE_P. VENDA"	,"@E 999,999,999.99",14)	
	TRCell():New(oSection1,"PRECO"		,"TRB","PRECO_PV"		,"@E 999,999,999.99",14) 		
	TRCell():New(oSection1,"TOTAL_PV"	,"TRB","TOTAL_PV"		,"@E 999,999,999.99",14) 	
	TRCell():New(oSection1,"COTACAO"	,"TRB","COTACAO	"		,"@E 999,999,999.99",14) 		
	TRCell():New(oSection1,"VAL_MOEDA"	,"TRB","VALOR_MOEDA"	,"@E 999,999,999.99",14)	 						
	TRCell():New(oSection1,"OBS"		,"TRB","MENSSAGEM"		,"@!"			,35)	
	TRCell():New(oSection1,"USER_LIB"	,"TRB","USUARIO_LIB"	,"@!"			,35)
	TRCell():New(oSection1,"DTLIB"		,"TRB","DATA_LIBERAÇÃO"	,,08)				
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
¦¦¦Uso       ¦ COMPRAS                                               	  ¦¦¦
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
	Local CTRL:= chr(10) + chr(13)

	/*-------------------------------| 		    			           
	| criação do arquivo de trabalho |
	|-------------------------------*/
	
	_aStru	:= {} 
	
		AADD(_aStru,{"NOTA"		,"C",09,0})	     	
	 	AADD(_aStru,{"SERIE"		,"C",04,0})    	
	  	AADD(_aStru,{"CLIENTE"		,"C",06,0})	     	
	   	AADD(_aStru,{"LOJA"		,"C",04,0})	      	
	    AADD(_aStru,{"NOME"		,"C",30,0})
	    AADD(_aStru,{"VALFAT"		,"N",14,2})        	      		        	      	
	    AADD(_aStru,{"EMISSAO"		,"D",8,0}) 	        	        	        
	    AADD(_aStru,{"TES"			,"C",03,0})
     	AADD(_aStru,{"FINALID"	,"C",030,0})
      	AADD(_aStru,{"ITEM"		,"C",04,0})	        
       	AADD(_aStru,{"CODIGO"		,"C",15,0})  
        AADD(_aStru,{"DESC_PROD"	,"C",30,0})
        AADD(_aStru,{"QTD"			,"N",14,2})
        AADD(_aStru,{"VALOR"		,"N",14,2})
        AADD(_aStru,{"TOTAL"		,"N",14,2})	        	        
        AADD(_aStru,{"TABELA"		,"N",14,2})
        AADD(_aStru,{"DESCONTO"	,"N",14,2})	 	        
        AADD(_aStru,{"PEDIDO"		,"C",06,0})
        AADD(_aStru,{"QTD_PV"		,"N",14,2})
   	    AADD(_aStru,{"PRECO"		,"N",14,2})
   	    AADD(_aStru,{"TOTAL_PV"	,"N",14,2}) 	        
        AADD(_aStru,{"COTACAO"		,"N",14,2})
        AADD(_aStru,{"CONDPAG"		,"C",04,0})
        AADD(_aStru,{"D_CONDPG"	,"C",30,0})
        AADD(_aStru,{"MOEDA"		,"N",2,0})	        	        
        AADD(_aStru,{"VAL_MOEDA"	,"N",14,2})      
        AADD(_aStru,{"OBS"			,"C",30,0})
        AADD(_aStru,{"USER_LIB"	,"C",20,0})
   	    AADD(_aStru,{"DTLIB"		,"D",8,0})  
				    	
   	_cArq     := CriaTrab(_aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)
	                                            
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	IndRegua("TRB",_cIndice,"CODIGO",,,"Selecionando Registros...")
	                     
	/*-----------------------------------------------------|
	| Montagem da query com os titulos a receber em aberto |
	|-----------------------------------------------------*/

	clQuery := " SELECT F2_DOC AS NF,F2_SERIE AS SERIE,C5_CLIENTE AS CLIENTE,C5_LOJACLI AS LOJA,A1_NOME AS RAZAO,F2_VALFAT AS VAL_FAT,F2_EMISSAO AS EMISSAO " + CTRL
	clQuery += "		,D2_TES AS TES,F4_TEXTO AS FINALIDADE,D2_ITEM AS ITEM,D2_COD AS CODIGO,C6_DESCRI AS PRODUTO " 		+ CTRL
	clQuery += "		,D2_QUANT AS QTD,D2_PRCVEN AS VALOR,D2_TOTAL AS TOTAL_N,D2_PRUNIT AS TABELA,D2_DESCON AS DESCONTO " + CTRL 
	clQuery += "		,C6_NUM AS PEDIDO,C6_QTDVEN AS QTD_PV,C6_PRCVEN AS PRECO_PV,C6_VALOR AS TOTAL_PV,C6_XVALMD1 AS COTACAO " 	+ CTRL
	clQuery += "		,C5_CONDPAG AS CONDPAG,E4_DESCRI AS DESCRICAO,C5_MOEDA AS MOEDA,C5_TXMOEDA AS VAL_MOEDA " 					+ CTRL
	clQuery += "		,C5_TABELA AS TABELA,C5_MENNOTA AS OBS,C5_XLIB01 AS USER_LIB ,C5_XDAT01 AS DATA_LIB,C5_XHR01 AS HORA_LIB " 	+ CTRL
	clQuery += "FROM SC5020 INNER JOIN SC6020 ON C6_FILIAL=C5_FILIAL AND C6_NUM=C5_NUM AND SC6020.D_E_L_E_T_='' " + CTRL
	clQuery += "		INNER JOIN SE4020 ON E4_CODIGO=C5_CONDPAG AND SE4020.D_E_L_E_T_='' " 	+ CTRL
	clQuery += "		INNER JOIN SD2020 ON D2_FILIAL=C6_FILIAL AND D2_PEDIDO=C6_NUM " 		+ CTRL
	clQuery += "			AND D2_COD=C6_PRODUTO AND D2_ITEMPV=C6_ITEM AND  SD2020.D_E_L_E_T_='' " 					+ CTRL
	clQuery += "		INNER JOIN SF4020 ON F4_FILIAL=D2_FILIAL AND F4_CODIGO=D2_TES AND SF4020.D_E_L_E_T_='' "	+ CTRL
	clQuery += "		INNER JOIN SF2020 ON F2_FILIAL=D2_FILIAL AND F2_DOC=D2_DOC AND F2_SERIE=D2_SERIE " 	+ CTRL
	clQuery += "			AND F2_CLIENTE=D2_CLIENTE AND F2_LOJA=D2_LOJA AND F2_TIPO=D2_TIPO " + CTRL
	clQuery += "			AND C5_EMISSAO=D2_EMISSAO  " + CTRL
	clQuery += "		INNER JOIN SA1020 ON A1_COD=C5_CLIENTE AND A1_LOJA=C5_LOJACLI AND SA1020.D_E_L_E_T_='' " + CTRL
	clQuery += "		WHERE SC5020.D_E_L_E_T_=''  " + CTRL
	clQuery += "			AND C5_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' " + CTRL    
	clQuery += "			AND C5_LIBEROK <>''  AND C5_NOTA <>'' " + CTRL        
	
	If Mv_Par03==2
	
		clQuery += " UNION " 
				                                   
		clQuery += " SELECT '' AS NF,'' AS SERIE,C5_CLIENTE AS CLIENTE,C5_LOJACLI AS LOJA,A1_NOME AS RAZAO, '' AS VAL_FAT,C5_EMISSAO AS EMISSAO " + CTRL
		clQuery += "		,C6_TES AS TES,F4_TEXTO AS FINALIDADE,C6_ITEM AS ITEM,C6_PRODUTO AS CODIGO,C6_DESCRI AS PRODUTO " 		+ CTRL
		clQuery += "		,'' AS QTD,'' AS VALOR,'' AS TOTAL_N,'' AS TABELA,'' AS DESCONTO " + CTRL 
		clQuery += "		,C6_NUM AS PEDIDO,C6_QTDVEN AS QTD_PV,C6_PRCVEN AS PRECO_PV,C6_VALOR AS TOTAL_PV,C6_XVALMD1 AS COTACAO " 	+ CTRL
		clQuery += "		,C5_CONDPAG AS CONDPAG,E4_DESCRI AS DESCRICAO,C5_MOEDA AS MOEDA,C5_TXMOEDA AS VAL_MOEDA " 					+ CTRL
		clQuery += "		,C5_TABELA AS TABELA,C5_MENNOTA AS OBS,C5_XLIB01 AS USER_LIB ,C5_XDAT01 AS DATA_LIB,C5_XHR01 AS HORA_LIB " 	+ CTRL
		clQuery += "FROM SC5020 INNER JOIN SC6020 ON C6_FILIAL=C5_FILIAL AND C6_NUM=C5_NUM AND SC6020.D_E_L_E_T_='' " + CTRL
		clQuery += "		INNER JOIN SE4020 ON E4_CODIGO=C5_CONDPAG AND SE4020.D_E_L_E_T_='' " 	+ CTRL
		clQuery += "		INNER JOIN SF4020 ON F4_FILIAL=C6_FILIAL AND F4_CODIGO=C6_TES AND SF4020.D_E_L_E_T_='' "	+ CTRL
		clQuery += "		INNER JOIN SA1020 ON A1_COD=C5_CLIENTE AND A1_LOJA=C5_LOJACLI AND SA1020.D_E_L_E_T_='' " + CTRL
		clQuery += "		WHERE SC5020.D_E_L_E_T_=''  " + CTRL
		clQuery += "			AND C5_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' " + CTRL
		clQuery += "			AND C5_LIBEROK <>''  AND C5_NOTA ='' " + CTRL        
	Endif 
	
	IF SELECT("LUXO") > 0                                                                                    
		dbSelectArea("LUXO")
		DbCloseArea()
	ENDIF
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,clQuery),"LUXO",.F.,.T.)
	
	/*--------------------------------------------------|
	| ajusta casas decimais e datas no retorno da query |
	|--------------------------------------------------*/
	

	TcSetField("LUXO","VAL_FAT","N",14,2)
	TcSetField("LUXO","QTD","N",14,2)
	TcSetField("LUXO","VALOR ","N",14,2)
	TcSetField("LUXO","TOTAL_N","N",14,2)
	TcSetField("LUXO","TABELA","N",14,2)	
	TcSetField("LUXO","DESCONTO","N",14,2)	
	TcSetField("LUXO","QTD_PV","N",14,2)	
	TcSetField("LUXO","PRECO_PV","N",14,2)
	TcSetField("LUXO","TOTAL_PV","N",14,2)
	TcSetField("LUXO","COTACAO","N",14,2)
	TcSetField("LUXO","VAL_MOEDA","N",14,2)		
	TcSetField("LUXO","DATA_LIB","D",08,0)
	TcSetField("LUXO","EMISSAO","D",08,0)
				
	dbSelectArea("LUXO")
	dbGotop()
		
	While LUXO->(!Eof())
		     	      		       
	     DbSelectArea("TRB")
	/*--------------------------|
	| adciona registro em banco |
	|--------------------------*/
	    RecLock("TRB",.T.) 
	    	    
	     	TRB->NOTA		:= LUXO->NF	     	
	     	TRB->SERIE		:= LUXO->SERIE	     	
	     	TRB->CLIENTE	:= LUXO->CLIENTE	     	
	      	TRB->LOJA		:= LUXO->LOJA	      	
	      	TRB->NOME		:= LUXO->RAZAO
	      	TRB->VALFAT		:= LUXO->VAL_FAT	        	      		        	      	
	        TRB->EMISSAO	:= LUXO->EMISSAO	        	        	        
	        TRB->TES		:= LUXO->TES
	        TRB->FINALID	:= LUXO->FINALIDADE
	        TRB->ITEM		:= LUXO->ITEM	        
	        TRB->CODIGO		:= LUXO->CODIGO	        
	        TRB->DESC_PROD	:= LUXO->PRODUTO
	        TRB->QTD		:= LUXO->QTD
	        TRB->VALOR		:= LUXO->VALOR
	        TRB->TOTAL 		:= LUXO->TOTAL_N	        	        
	        TRB->TABELA		:= LUXO->TABELA
	        TRB->DESCONTO	:= LUXO->DESCONTO	 	        
	        TRB->PEDIDO 	:= LUXO->PEDIDO
	        TRB->QTD_PV		:= LUXO->QTD_PV
   	        TRB->PRECO		:= LUXO->PRECO_PV 
   	        TRB->TOTAL_PV	:= LUXO->TOTAL_PV  	        
	        TRB->COTACAO	:= LUXO->COTACAO
	        TRB->CONDPAG 	:= LUXO->CONDPAG
	        TRB->D_CONDPG	:= LUXO->DESCRICAO
	        TRB->MOEDA		:= LUXO->MOEDA	        	        
	        TRB->VAL_MOEDA	:= LUXO->VAL_MOEDA	        
	        TRB->OBS  		:= LUXO->OBS
	        TRB->USER_LIB	:= LUXO->USER_LIB
   	        TRB->DTLIB		:= LUXO->DATA_LIB 
   	        	            
	      MsUnlock()
	    	      
	      dbSelectArea("LUXO")
	      DBSKIP()  
	Enddo
	
	If Select("LUXO") > 0
		dbSelectArea("LUXO")
		DbCloseArea()
	EndIf
	
Return

Static Function ValPerg(cPerg) 
	PutSx1(cPerg,'01','Emissão de      ?','','','mv_ch1','D',08,0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'02','Emissão ate     ?','','','mv_ch2','D',08,0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'03','Status do Pedido	?','','','mv_ch3','N',1,0,1,'C','','','','','mv_par03',"Faturados","","","","Fatuados/Liberados","","","","","","","","","","","")		
Return
