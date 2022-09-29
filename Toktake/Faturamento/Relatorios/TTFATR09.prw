
/*--------------------------|
|Bibliotecas de funções		|
|--------------------------*/  
 #INCLUDE "RWMAKE.CH"      // 
 #INCLUDE "TOPCONN.CH"     //
/*-------------------------*/

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦TTFATR09() ¦ Autor ¦ Fabio Sales		    ¦ Data ¦17.06.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Relatório de transferências não classificadas              ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Faturamento/TokeTake                                       ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/                        

User Function TTFATR09()
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
¦¦¦Funçào    ¦REPORTDEF() ¦ Autor ¦ Fabio Sales		    ¦ Data ¦17.06.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Função principal de impressão   							  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Faturamento/TokeTake	                                      ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function ReportDef()

	Local oReport
	Local oSection
	Local clDesProg:="TRANSFERENCIA EM TRANSITO"
	Local clExpProg:="ESTE RELATORIO IRÁ IMPRIMIR AS NOTAS DE TRANSFERENCIAS NÃO CLASSIFICADAS"
	Private cPerg    := "TTFTR09"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New("TTFATR09",clDesProg,"",{|oReport| PrintReport(oReport)},clExpProg)
	
	/*------------------------------------------| 		    			           
	| seção das notas fiscais de transferências | 
	|------------------------------------------*/
	
	oSection1 := TRSection():New(oReport,OemToAnsi("NOTAS DE SAIDA"),{"TRB"})
	
	/*----------------------------------------------------------------------------------|
	|                       Campo        Alias  Título       	 Pic           Tamanho  | 
	|----------------------------------------------------------------------------------*/
	
	TRCell():New(oSection1,"TIPO"		,"TRB","TIPO"			 ,"@!" 			 ,20)
	TRCell():New(oSection1,"FILIAL1"	,"TRB","FILIAL_SAIDA"	 ,"@!" 			 ,02)
	TRCell():New(oSection1,"FILIAL2"	,"TRB","FILIAL_DESTINO"	 ,"@!" 			 ,02)
	TRCell():New(oSection1,"NOTA"		,"TRB","NOTA"			 ,"@!" 			 ,09)
	TRCell():New(oSection1,"SERIE"		,"TRB","SERIE"			 ,"@!" 			 ,03)
	TRCell():New(oSection1,"EMISSAO"	,"TRB","EMISSAO"		 ,	   			 ,08)
	TRCell():New(oSection1,"TOTAL1"		,"TRB","TOT_MERC_SAI"	 ,"@E 999,999.99",16)
	TRCell():New(oSection1,"TOTAL2"		,"TRB","TOT_MERC_ENT"	 ,"@E 999,999.99",16)
	TRCell():New(oSection1,"VALICM1"	,"TRB","VAL_ICMS_SAIDA"	 ,"@E 999,999.99",16)		                                                                    		
	TRCell():New(oSection1,"VALICM2"	,"TRB","VAL_ICMS_ENTRADA","@E 999,999.99",16)		                                                                    			
	TRCell():New(oSection1,"COD_CLI"	,"TRB","COD_CLI"		 ,"@!"           ,06)
	TRCell():New(oSection1,"CLIENTE"	,"TRB","CLIENTE"		 ,"@!" 			 ,40)
	TRCell():New(oSection1,"LOJACLI"	,"TRB","LOJA"			 ,"@!" 			 ,04)	
	TRCell():New(oSection1,"COD_FOR"	,"TRB","COD_FORN"	 	 ,"@!" 			 ,06)
	TRCell():New(oSection1,"FORNECEDOR"	,"TRB","FORNECEDOR"	 	 ,"@!" 			 ,40)
	TRCell():New(oSection1,"LOJAFOR"	,"TRB","LOJA"			 ,"@!" 			 ,04)
	TRCell():New(oSection1,"ESTADO"		,"TRB","ESTADO"			 ,"@!" 			 ,02)
				
Return oReport

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦PrintReport() ¦ Autor ¦ Fabio Sales	    ¦ Data ¦17.06.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Função responsável pela impressão do relatório			  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Faturamento                                          	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function PrintReport(oReport)

	Local oSection1 := oReport:Section(1)
	
	/*-----------------------------------------------------------------| 		    			           
	| seleção dos dados a serem impressos/carrega o arquivo temporário | 
	|-----------------------------------------------------------------*/
	
	MsAguarde({|| fSelDados()},"Selecionando notas")
	
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
	Local linebreak := chr(13)

	/*-------------------------------| 		    			           
	| criação do arquivo de trabalho | 
	|-------------------------------*/
	
	_aStru	:= {}
	
	/*---------------------------------------|
	|     Array  Campo       Tipo  Tam  Dec  | 
	|---------------------------------------*/
		
	AADD(_aStru,{"TIPO"		 ,"C"  ,20 ,0})	
	AADD(_aStru,{"NOTA"		 ,"C"  ,09 ,0})
	AADD(_aStru,{"SERIE"	 ,"C"  ,03 ,0})
	AADD(_aStru,{"COD_CLI"	 ,"C"  ,06 ,0})
	AADD(_aStru,{"CLIENTE"	 ,"C"  ,40 ,0})
	AADD(_aStru,{"LOJACLI"	 ,"C"  ,04 ,0})
	AADD(_aStru,{"COD_FOR"	 ,"C"  ,06 ,0})
	AADD(_aStru,{"FORNECEDOR","C"  ,40 ,0})
	AADD(_aStru,{"LOJAFOR"	 ,"C"  ,04 ,0})
	AADD(_aStru,{"TOTAL1"	 ,"N"  ,14 ,2})
	AADD(_aStru,{"TOTAL2"	 ,"N"  ,14 ,2})
	AADD(_aStru,{"VALICM1"	 ,"N"  ,14 ,2})
	AADD(_aStru,{"VALICM2"	 ,"N"  ,14 ,2})	
	AADD(_aStru,{"FILIAL1"	 ,"C"  ,02 ,0})
	AADD(_aStru,{"FILIAL2"	 ,"C"  ,02 ,0})
	AADD(_aStru,{"ESTADO"	 ,"C"  ,02 ,0})
	AADD(_aStru,{"EMISSAO"	 ,"D"  ,08 ,0})
		
   	_cArq     := CriaTrab(_aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)        
	                                            
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	IndRegua("TRB",_cIndice,"NOTA",,,"Selecionando Registros...")
	
	/*-------------------------------------------------------|
	 |	Montagem da query com os dados das notas fiscais     |
	 |  de entradas e saidas de filiais distintas   		 |
	 |	filtrando apenas as notas de saidas de      		 |
	 |  transferência e relacionando com as notas de		 |
	 |  entradas da filial que esta recebendo a transferência|	                                             |
	 |------------------------------------------------------*/
		
	clQuery := " SELECT D1_COD 	" + linebreak
	clQuery += "	,D2_COD 	" + linebreak
	clQuery += "	,F2_FILIAL  " + linebreak
	clQuery += "	,F1_FILIAL  " + linebreak
	clQuery += "	,F2_DOC     " + linebreak
	clQuery += "	,F2_SERIE   " + linebreak
	clQuery += "	,F1_DOC     " + linebreak
	clQuery += "	,F1_SERIE   " + linebreak
	clQuery += "	,F2_CLIENTE " + linebreak
	clQuery += "	,F2_EMISSAO " + linebreak
	clQuery += "	,A1_NOME    " + linebreak
	clQuery += "	,A2_NOME    " + linebreak
	clQuery += "	,F2_LOJA    " + linebreak
	clQuery += "	,F2_XFINAL  " + linebreak
	clQuery += "	,F1_FORNECE " + linebreak
	clQuery += "	,F1_LOJA    " + linebreak
	clQuery += "	,F2_VALMERC " + linebreak
	clQuery += "	,F1_VALMERC " + linebreak
	clQuery += "	,F1_VALICM  " + linebreak
	clQuery += "	,F2_VALICM  " + linebreak
	clQuery += "	,F2_XTRANSF " + linebreak
	clQuery += "	,F1_XTRANSF " + linebreak
	clQuery += " FROM "+RetSqlName("SF2")+" AS SF2, " + linebreak
	clQuery += "	  "+RetSqlName("SD2")+" AS SD2, " + linebreak
	clQuery += "      "+RetSqlName("SF1")+" AS SF1, " + linebreak
	clQuery += "	  "+RetSqlName("SD1")+" AS SD1, " + linebreak
	clQuery += "      "+RetSqlName("SA1")+" AS SA1, " + linebreak
	clQuery += "	  "+RetSqlName("SA2")+" AS SA2  " + linebreak
	clQuery += " WHERE  F2_DOC=D2_DOC         " + linebreak
	clQuery += "	AND F2_SERIE=D2_SERIE     " + linebreak
	clQuery += "	AND F2_CLIENTE=D2_CLIENTE " + linebreak
	clQuery += " 	AND F2_LOJA=D2_LOJA       " + linebreak
	clQuery += "	AND F2_EMISSAO=D2_EMISSAO " + linebreak
	clQuery += "	AND F2_FILIAL=D2_FILIAL	  " + linebreak
	clQuery += " 	AND F2_DOC=F1_DOC         " + linebreak
	clQuery += "	AND F2_SERIE=F1_SERIE     " + linebreak
	clQuery += "	AND F2_FILIAL=F1_XTRANSF  " + linebreak
	clQuery += " 	AND	F1_DOC=D1_DOC         " + linebreak
	clQuery += "	AND F1_SERIE=D1_SERIE     " + linebreak
	clQuery += "	AND F1_FORNECE=D1_FORNECE " + linebreak
	clQuery += " 	AND F1_LOJA=D1_LOJA       " + linebreak
	clQuery += "	AND F1_FILIAL=D1_FILIAL   " + linebreak
	clQuery += "	AND F1_DTDIGIT=D1_DTDIGIT " + linebreak
	clQuery += " 	AND F2_XFINAL='3'         " + linebreak
	clQuery += "	AND D1_TES=''             " + linebreak
	clQuery += "	AND SF2.D_E_L_E_T_<>'*'   " + linebreak
	clQuery += " 	AND F2_CLIENTE=A1_COD     " + linebreak
	clQuery += "	AND F2_LOJA=A1_LOJA       " + linebreak
	clQuery += "	AND F1_FORNECE=A2_COD     " + linebreak
	clQuery += "	AND F1_LOJA=A2_LOJA       " + linebreak
	clQuery += " 	AND D2_DOC=D1_DOC         " + linebreak
	clQuery += "	AND D2_SERIE=D1_SERIE     " + linebreak
	clQuery += "	AND D2_COD=D1_COD         " + linebreak
	clQuery += "	AND D2_ITEM=D1_ITEM       " + linebreak
	clQuery += " 	AND F1_LOJA=A2_LOJA       " + linebreak
	clQuery += "	AND SA1.D_E_L_E_T_<>'*'   " + linebreak
	clQuery += "	AND SA2.D_E_L_E_T_<>'*'	  " + linebreak
	clQuery += " 	AND SD2.D_E_L_E_T_<>'*'   " + linebreak
	clQuery += "	AND SF1.D_E_L_E_T_<>'*'   " + linebreak
	clQuery += "	AND SD1.D_E_L_E_T_<>'*'	  " + linebreak
	clQuery += " 	AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'	" + linebreak
	clQuery += " 	AND F2_DOC     BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' 				" + linebreak
	clQuery += " 	AND F2_SERIE   BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' 				" + linebreak
	clQuery += " 	AND F2_FILIAL  BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' 				" + linebreak
	clQuery += " 	AND F1_FILIAL  BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"'				" + linebreak
	clQuery += " ORDER BY F2_DOC															" + linebreak
	
	/*---------------------------------------------| 		    			           
	| Verifica se a Query Existe, se existir fecha |
	|---------------------------------------------*/ 
	                                            
	If Select("TSQL1") > 0
		dbSelectArea("TSQL1")
		DbCloseArea()
	EndIf
	
	/*-----------------------------------------------------------------| 		    			           
	| cria uma uma tabela temporária a partir da Query desenhada acima | 
	|-----------------------------------------------------------------*/
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,clQuery),"TSQL1",.F.,.T.)
	
	/*-------------------------------------------------------|
	| ajusta os campos numéricos e datas no retorno da query | 
	|--------------------------------------------------------|
	|           Alias   Campo        Tipo Tam Dec		     | 
	|-------------------------------------------------------*/
	
	TcSetField("TSQL1","F2_EMISSAO" ,"D"  ,08 ,0)
	TcSetField("TSQL1","F2_VALMERC" ,"N"  ,14 ,2)
	TcSetField("TSQL1","F1_VALMERC" ,"N"  ,14 ,2)
	TcSetField("TSQL1","F1_VALICM"  ,"N"  ,14 ,2)
	TcSetField("TSQL1","F2_VALICM"  ,"N"  ,14 ,2)
	
	dbSelectArea("TSQL1")
	dbGotop()
	Do While TSQL1->(!Eof())
	
		clDoc	:=TSQL1->F2_DOC
		clSerie :=TSQL1->F2_SERIE
		clfilsai:=TSQL1->F2_FILIAL
		clfilent:=TSQL1->F1_FILIAL
		 		
	    IF TSQL1->F2_XFINAL=='3'
	    	clTipo:="TRANSFERÊNCIA"
	    ENDIF
     
		DbSelectArea("TRB")
			
	/*----------------------------| 		    			           
	| adiciona registro em banco  | 
	|----------------------------*/
		     
			RecLock("TRB",.T.)
					
				TRB->TIPO		:= clTipo					     	     		     
		     	TRB->COD_CLI	:= TSQL1->F2_CLIENTE
		     	TRB->LOJACLI	:= TSQL1->F2_LOJA
		      	TRB->CLIENTE	:= TSQL1->A1_NOME	      	
		      	TRB->COD_FOR	:= TSQL1->F1_FORNECE
		     	TRB->LOJAFOR	:= TSQL1->F1_LOJA
		      	TRB->FORNECEDOR	:= TSQL1->A2_NOME	      	
			    TRB->NOTA		:= TSQL1->F2_DOC
		    	TRB->SERIE		:= TSQL1->F2_SERIE
		        TRB->TOTAL1		:= TSQL1->F2_VALMERC
		        TRB->TOTAL2		:= TSQL1->F1_VALMERC     
		        TRB->FILIAL1   	:= TSQL1->F2_FILIAL
		        TRB->FILIAL2   	:= TSQL1->F1_FILIAL      
		        TRB->EMISSAO	:= TSQL1->F2_EMISSAO		        
		        TRB->VALICM1   	:= TSQL1->F2_VALICM      
		        TRB->VALICM2	:= TSQL1->F1_VALICM
		                  	        	           	        
			MsUnlock()
	        WHILE (TSQL1->F2_DOC==clDoc) .AND. (TSQL1->F2_SERIE==clSerie) .AND. (TSQL1->F2_FILIAL= clfilsai) .AND. (TSQL1->F1_FILIAL== clfilent)
		      	dbSelectArea("TSQL1")
		     	DbSkip()
		 	ENDDO
	    	clDoc	:=""
			clSerie :=""
			clfilsai:=""
			clfilent:=""
		 	
		Enddo
	If Select("TSQL1") > 0
		dbSelectArea("TSQL1")
		DbCloseArea()
	EndIf
	
Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ValPerg() ¦ Autor ¦ Fabio Sales	    	¦ Data ¦17.06.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Cria os parâmetro de perguntas na tabela SX1 caso		  ¦¦¦
¦¦¦			 ¦ não eexista												  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Faturamento/TokTake                                     	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function ValPerg(cPerg)

	PutSx1(cPerg,'01','Emissao de   ?','','','mv_ch1','D',8, 0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'02','Emissao Ate  ?','','','mv_ch2','D',8, 0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'03','Nota de      ?','','','mv_ch3','C',09,0,0,'G','','','','','mv_par03',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'04','Nota Ate     ?','','','mv_ch4','C',09,0,0,'G','','','','','mv_par04',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'05','Serie de     ?','','','mv_ch5','C',03,0,0,'G','','','','','mv_par05',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'06','Serie Ate 	?','','','mv_ch6','C',03,0,0,'G','','','','','mv_par06',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'07','Fil_Sai_de   ?','','','mv_ch7','C',02,0,0,'G','','','','','mv_par07',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'08','Fil_Sai_Ate  ?','','','mv_ch8','C',02,0,0,'G','','','','','mv_par08',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'09','Fil_Des_De   ?','','','mv_ch9','C',02,0,0,'G','','','','','mv_par09',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'10','Fil_Des_Ate 	?','','','mv_chA','C',02,0,0,'G','','','','','mv_par10',,,'','','','','','','','','','','','','','')
	
Return