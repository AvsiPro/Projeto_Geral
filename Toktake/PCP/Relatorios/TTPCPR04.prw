
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
¦¦¦Funçào    ¦TTPCPR04() ¦ Autor ¦ FABIO SALES		    ¦ Data ¦27.12.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ COMPRAS x CONSUMOS								          ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ PCP x COMPRAS                                         	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

User Function TTPCPR04()
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
¦¦¦Funçào    ¦REPORTDEF() ¦ Autor ¦ FABIO SALES		    ¦ Data ¦22.12.2010¦¦¦
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
	Private cPerg    := "TTPCPR04"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New("TTPCPR04","RELATORIO DE COMPRAS X CONSUMO","",{|oReport| PrintReport(oReport)},"ESTE RELATORIO IMPRIMIRÁ AS CCOMPRAS X O CONSUMO DAS OPs")
	
	/*-------------------------|
	| seção dos titulo a pagar |
	|-------------------------*/
	
	oSection1 := TRSection():New(oReport,OemToAnsi("PRODUÇÃO"),{"TRB"})
	
	/*----------------------------------------------------------------------------------|
	|                       campo        alias  título       	 pic           tamanho  |
	|----------------------------------------------------------------------------------*/
	
	TRCell():New(oSection1,"PERIODO"	,"TRB","PERIODO "	,"@!",35)			 			
	TRCell():New(oSection1,"PRODAC"		,"TRB","PRODUTO_ACABADO	"	,"@!",15)			 	
	TRCell():New(oSection1,"DESCPRODAC"	,"TRB","DESCRICAO_PA	"		,"@!",35)		
	TRCell():New(oSection1,"TIPOAC"		,"TRB","TIPO_PA	"			,"@!",10)					
	TRCell():New(oSection1,"UNIMEDAC"	,"TRB","UNID_MED_PA"		,"@!",10)
	TRCell():New(oSection1,"QTDEAC"		,"TRB","QTDE_PRODUZIDA"	,"@E 999,999,999.99",14)
	TRCell():New(oSection1,"SEGUNIDAC"	,"TRB","SEG_UNIMED_PA	"	,"@!",15)	
	TRCell():New(oSection1,"TIPCONV"	,"TRB","TIP_CONV_PA	"	,"@!",15)
	TRCell():New(oSection1,"CONV"		,"TRB","FATOR_CONV_PA"		,"@E 999,999,999.99",14)
	TRCell():New(oSection1,"QTDESEGUN"	,"TRB","QTDE_PROD_SEG_UN"	,"@E 999,999,999.99",14)	  	
	TRCell():New(oSection1,"PRODMP"		,"TRB","INSUMO	"	,"@!",15)			 	
	TRCell():New(oSection1,"DESCPRODMP"	,"TRB","DESCRICAO_INSUMO	"		,"@!",35)		
	TRCell():New(oSection1,"TIPOMP"		,"TRB","TIPO_INSUMO	"			,"@!",10)					
	TRCell():New(oSection1,"UNIMEDMP"	,"TRB","UNID_MED_INSUMO"		,"@!",10)
	TRCell():New(oSection1,"QTDEMP"		,"TRB","QTDE_CONSUMIDA"	,"@E 999,999,999.99",14)
	TRCell():New(oSection1,"QTDECOMP"	,"TRB","QTDE_COMPRADA"	,"@E 999,999,999.99",14) 
	
Return oReport

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦PrintReport() ¦ Autor ¦ FABIO SALES	    ¦ Data ¦22.12.2010¦¦¦
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

	Local clQuery	:=""
	Local cQuery 	:=""
 	Local clProdAc	:=""
 	Local clCtrl	:="" 

	/*-------------------------------|
	| criação do arquivo de trabalho |
	|-------------------------------*/
	
	_aStru	:= {} 
				
	AADD(_aStru,{"PRODAC"	,"C",15,0})	
	AADD(_aStru,{"DESCPRODAC"	,"C",35,0})
	AADD(_aStru,{"TIPOAC"	,"C",10,0})
	AADD(_aStru,{"UNIMEDAC"	,"C",10,0})	
	AADD(_aStru,{"QTDEAC","N",14,2}) 	
	AADD(_aStru,{"PRODMP"	,"C",15,0})	
	AADD(_aStru,{"DESCPRODMP"	,"C",35,0})
	AADD(_aStru,{"TIPOMP"	,"C",10,0})
	AADD(_aStru,{"UNIMEDMP"	,"C",10,0})	
	AADD(_aStru,{"QTDEMP","N",14,2})
	AADD(_aStru,{"QTDECOMP","N",14,2})
	AADD(_aStru,{"PERIODO"	,"C",35,0})
	AADD(_aStru,{"SEGUNIDAC","C",03,0})
	AADD(_aStru,{"TIPCONV","C",03,0})
	AADD(_aStru,{"CONV","N",14,3})
	AADD(_aStru,{"QTDESEGUN","N",14,3})	 
		
   	_cArq     := CriaTrab(_aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)
	                                            
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	IndRegua("TRB",_cIndice,"PRODAC",,,"Selecionando Registros...")
	                     
	/*-----------------------------------------------------|
	| Montagem da query com os titulos a receber em aberto |
	|-----------------------------------------------------*/
		
	&& query  ddas mercadorias de entrada que movimentam estoque.
			
	clQuery:= " SELECT													" + CHR(10)+CHR(13)
	clQuery+= " 		C2_PRODUTO,										" + CHR(10)+CHR(13)
	clQuery+= " 		D4_COD,											" + CHR(10)+CHR(13)
	clQuery+= "                            SUM(D3_QUANT) AS QUANTD3,	" + CHR(10)+CHR(13)
	clQuery+= " 		SUM(D4_QTDEORI/C2_QUANT * D3_QUANT) AS TOTUTIL 	" + CHR(10)+CHR(13)
	clQuery+= " FROM "+RetSQLName("SC2")+" SC2 INNER JOIN "+RetSQLName("SD4")+" SD4 " + CHR(10)+CHR(13)
	clQuery+= " 	ON (C2_NUM+C2_ITEM+C2_SEQUEN)=D4_OP 				" + CHR(10)+CHR(13)
	clQuery+= " INNER JOIN "+RetSQLName("SD3")+" SD3 					" + CHR(10)+CHR(13)
	clQuery+= " 	ON (C2_NUM+C2_ITEM+C2_SEQUEN)=D3_OP 				" + CHR(10)+CHR(13)
	clQuery+= " 		AND C2_PRODUTO=D3_COD 							" + CHR(10)+CHR(13)
	clQuery+= " INNER JOIN "+RetSQLName("SB1")+" AS TABD4 				" + CHR(10)+CHR(13)
	clQuery+= " 	ON D4_COD=TABD4.B1_COD								" + CHR(10)+CHR(13)
	clQuery+= " INNER JOIN "+RetSQLName("SB1")+" AS TABC2				" + CHR(10)+CHR(13)
	clQuery+= " 	ON C2_PRODUTO=TABC2.B1_COD							" + CHR(10)+CHR(13)
	clQuery+= " 	WHERE TABD4.B1_TIPO NOT IN ('MO','GG')				" + CHR(10)+CHR(13)
	clQuery+= " 		AND D3_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '" + DTOS(MV_PAR04)+"'	 " + CHR(10)+CHR(13)
	clQuery+= " 		AND C2_PRODUTO BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'		 " + CHR(10)+CHR(13)
	clQuery+= " 		AND D3_ESTORNO='' 					" + CHR(10)+CHR(13)
	clQuery+= " 		AND SD4.D_E_L_E_T_='' 				" + CHR(10)+CHR(13)
	clQuery+= " 		AND SD3.D_E_L_E_T_=''				" + CHR(10)+CHR(13)
	clQuery+= " 		AND SC2.D_E_L_E_T_=''				" + CHR(10)+CHR(13)
	clQuery+= " 		AND TABD4.D_E_L_E_T_=''				" + CHR(10)+CHR(13)
	clQuery+= " 		AND TABC2.D_E_L_E_T_=''				" + CHR(10)+CHR(13)
	clQuery+= " GROUP BY  C2_PRODUTO,	" + CHR(10)+CHR(13)
	clQuery+= " 		D4_COD			" + CHR(10)+CHR(13)
	&&clQuery+= " ORDER BY C2_PRODUTO,	" + CHR(10)+CHR(13)
	&&clQuery+= " 		D4_COD			" + CHR(10)+CHR(13)
	
	IF SELECT("ALC") > 0                                                                                    
		dbSelectArea("ALC")
		DbCloseArea()
	ENDIF
	MemoWrite("TTPCPR04.SQL",clQuery)	 	                                                               			
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,clQuery),"ALC",.F.,.T.)
	
	/*--------------------------------------------------|
	| ajusta casas decimais e datas no retorno da query |
	|--------------------------------------------------*/

	TcSetField("ALC","C2_QUANT","N",14,2)
	TcSetField("ALC","QUANTD3","N",14,2)
	TcSetField("ALC","TOTUTIL","N",14,2)
	TcSetField("ALC","D3_EMISSAO","D",08,0)			
			
	dbSelectArea("ALC")
	dbGotop()
		
	While ALC->(!Eof())	 
	 	clProdAc:=ALC->C2_PRODUTO
	 	clCtrl	:="X"
	 	WHILE ALC->C2_PRODUTO==clProdAc   		       
			DbSelectArea("TRB")	
			RecLock("TRB",.T.)
			
			//--------------Produtos acabados--------------//
						
				TRB->PERIODO := SUBSTR(DTOS(MV_PAR03),7,2) +"/" +SUBSTR(DTOS(MV_PAR03),5,2)+ "/" +SUBSTR(DTOS(MV_PAR03),1,4) +" ATE "+ SUBSTR(DTOS(MV_PAR04),7,2) +"/" +SUBSTR(DTOS(MV_PAR04),5,2)+ "/" +SUBSTR(DTOS(MV_PAR04),1,4)	    	    
				TRB->PRODAC  := ALC->C2_PRODUTO
				DBSELECTAREA("SB1")
				DBSETORDER(1)
				IF DBSEEK(XFILIAL("SB1")+ALC->C2_PRODUTO )
					TRB->DESCPRODAC := SB1->B1_DESC 
					TRB->TIPOAC		:= SB1->B1_TIPO 
					TRB->UNIMEDAC	:= SB1->B1_UM 
					TRB->SEGUNIDAC	:= SB1->B1_SEGUM
					TRB->TIPCONV	:= SB1->B1_TIPCONV
					TRB->CONV		:= SB1->B1_CONV
					TRB->QTDEAC 	:= ALC->QUANTD3
					
					IF SB1->B1_TIPCONV=="M"
				   		TRB->QTDESEGUN	:= ALC->QUANTD3 * SB1->B1_CONV
				 	ELSEIF  SB1->B1_TIPCONV=="D"
						TRB->QTDESEGUN	:= ALC->QUANTD3 / SB1->B1_CONV
					ENDIF	  				
			   ENDIF
				
			//----------Produtos Matérias Primas----------//
				
				TRB->PRODMP 	:= ALC->D4_COD
				DBSELECTAREA("SB1")
				DBSETORDER(1)
				IF DBSEEK(XFILIAL("SB1")+ALC->D4_COD ) 			
					TRB->DESCPRODMP := SB1->B1_DESC
					TRB->TIPOMP		:= SB1->B1_TIPO
					TRB->UNIMEDMP	:= SB1->B1_UM				
					TRB->QTDEMP 	:= ALC->TOTUTIL
			    ENDIF 
			    			    
			    //--------Filtra os Materias Primas compradas no periodo da Produção--------//
			    
				cQuery:= " SELECT					" + CHR(10)+CHR(13)
				cQuery+= " 		D1_COD,		" + CHR(10)+CHR(13)
				cQuery+= "         SUM(D1_QUANT) AS QUANTD1					" + CHR(10)+CHR(13)
				cQuery+= " FROM "+RetSQLName("SD1")+" SD1 INNER JOIN "+RetSQLName("SF4")+ 	" SF4 " + CHR(10)+CHR(13)
				cQuery+= " 	ON 		D1_FILIAL=F4_FILIAL " + CHR(10)+ CHR(13) 
				cQuery+= "  		AND D1_TES=F4_CODIGO 	" + CHR(10)+CHR(13)		
				cQuery+= " 	WHERE 						" + CHR(10)+CHR(13)
				cQuery+= " 		D1_DTDIGIT BETWEEN '"+ DTOS(MV_PAR03) +"' AND '" + DTOS(MV_PAR04) + "'	" + CHR(10)+CHR(13)
				cQuery+= " 		AND D1_COD = '"+ ALC->D4_COD +"'	" + CHR(10)+CHR(13)
				cQuery+= " 		AND F4_ESTOQUE='S' 							" + CHR(10)+CHR(13)		
				cQuery+= " 		AND SD1.D_E_L_E_T_=''	" + CHR(10)+CHR(13)
				cQuery+= " 		AND SF4.D_E_L_E_T_=''	" + CHR(10)+CHR(13)
				cQuery+= " GROUP BY  D1_COD	" + CHR(10)+CHR(13)
				cQuery+= " ORDER BY D1_COD		" + CHR(10)+CHR(13)
				
				IF SELECT("ALC2") > 0                                                                                    
					dbSelectArea("ALC2")
					DbCloseArea()
				ENDIF
				MemoWrite("TTPCPR0.SQL",cQuery)	 	                                                               			
				dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"ALC2",.F.,.T.)
				TcSetField("ALC2","QUANTD1","N",14,2) 
				DBSELECTAREA("ALC2")   
				TRB->QTDECOMP 	:= ALC2->QUANTD1
				If Select("ALC2") > 0
					dbSelectArea("ALC2")
					DbCloseArea()
				EndIf		            
			MsUnlock()	    	      
	      dbSelectArea("ALC")
	      DBSKIP()
		EndDo
		clProdAc :=""
	EndDo
	
	If Select("ALC") > 0
		dbSelectArea("ALC")
		DbCloseArea()
	EndIf
	
Return

Static Function ValPerg(cPerg) 

	PutSx1(cPerg,"01","Produto de?","","","mv_ch1","C",10,00,00,"G","","SB1","","","mv_Par01","","","","","","","","","","","","","","","","",{"Codigo inicial que "+ chr(10) + chr(13) + " se deseja imprimir"},{},{},"")
	PutSx1(cPerg,"02","Produto Ate?","","","mv_ch2","C",10,00,00,"G","","SB1","","","mv_Par02","","","","","","","","","","","","","","","","",{"Codigo ate que "+ chr(10) + chr(13) + "se deseja imprimir"},{},{},"")		
	PutSx1(cPerg,"03","Data de ?","","","mv_ch3","D",08,00,00,"G","","","","","mv_Par03","","","","","","","","","","","","","","","","",{" Informe Data inicial "+ chr(10) + chr(13) + " para impressão"},{},{},"")
	PutSx1(cPerg,"04","'Data Ate?","","","mv_ch4","D",08,00,00,"G","","","","","mv_Par04","","","","","","","","","","","","","","","","",{"Informe a data final "+ chr(10) + chr(13) + "para impressão"},{},{},"")			   		
	
Return
