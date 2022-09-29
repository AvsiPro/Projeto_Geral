
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
¦¦¦Funçào    TTCTBR03() ¦ Autor ¦ FABIO SALES		    ¦ Data ¦14.07.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ RELATORIO DE RASTREAMENTO CONTÁBIL			              ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ CONTABILIDADE                                          	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/                        

User Function TTCTBR03()
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
¦¦¦Funçào    ¦REPORTDEF() ¦ Autor ¦ FABIO SALES		    ¦ Data ¦14.07.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ FUNCAO PRINCIPAL D EIMPRESSÀO   							  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ CONTABILIDADE                                          	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function ReportDef()

	Local oReport
	Local oSection
	Local clDesProg		:="RASTREAMENTO CONTÁBIL"
	Local clExpProg		:="ESTE RELATORIO IRÁ RASTREAR  OS LANÇAMENTOS PROVENIENTES DO CONTAS A PAGAR E MOVIMENTAÇÕES BANCÁRIAS"
	Private cPerg		:= "TTCTBR03"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport 			:= TReport():New("TTCTBR03",clDesProg,"",{|oReport| PrintReport(oReport)},clExpProg)
	
	/*------------------------| 		    			           
	| seção das notas fiscais | 
	|------------------------*/
	
	oSection1 := TRSection():New(oReport,OemToAnsi("CONTAS A PAGAR"),{"TRB"})
	
	/*----------------------------------------------------------------------------------| 		    			           
	|                       campo        alias  título       	 pic           tamanho  | 
	|----------------------------------------------------------------------------------*/
	TRCell():New(oSection1,"CLIENTE"	,"TRB","FORCLI	"		,"@!" 			,06)
	TRCell():New(oSection1,"LOJA"		,"TRB","LOJA	"		,"@!"			,03)
   //	TRCell():New(oSection1,"DESCCLI"	,"TRB","NOME_FORCLI	"	,"@!" 			,06)
	TRCell():New(oSection1,"TIPO"		,"TRB","TIPO"			,"@!"			,03)
	TRCell():New(oSection1,"SERPRE"		,"TRB","SER/PREF"		,"@!"			,03)
	TRCell():New(oSection1,"DOC"		,"TRB","DOC/TIT"		,"@!"			,09)
	TRCell():New(oSection1,"PARCELA"	,"TRB","PARCELA	"		,"@!"			,03)	
	TRCell():New(oSection1,"EMISSAO"	,"TRB","EMISSAO"		,				,08)
   //	TRCell():New(oSection1,"VLRDOC"		,"TRB","VALDOC"			,"@E 999,999.99",16)
	TRCell():New(oSection1,"CONTAD"		,"TRB","CONTA_DEB	"	,"@!"			,20)
	TRCell():New(oSection1,"DESCDEB"	,"TRB","DESC_DEBITO	"	,"@!"			,30)
	TRCell():New(oSection1,"VLRDEB"		,"TRB","VAL DEBITO"		,"@E 999,999.99",16)
	TRCell():New(oSection1,"CONTAC"		,"TRB","CONTA_CRE	"	,"@!"			,20)
	TRCell():New(oSection1,"DESCCRE"	,"TRB","DESC_CREDITO"	,"@!"			,30)
	TRCell():New(oSection1,"VLRCRED"	,"TRB","VAL CREDITO"	,"@E 999,999.99",16)	
	TRCell():New(oSection1,"VALDEB"	,"TRB","VALDEB_ORIGEM"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"VALCRED"	,"TRB","VALCRED_ORIGEM"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"HISTCONT"	,"TRB","HISTORI_CONTAB"	,"@!",30)	
	
	TRCell():New(oSection1,"ALIAS"		,"TRB","ALIAS"			,"@!"			,03)
		                                                                    						
Return oReport

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦PrintReport() ¦ Autor ¦ FABIO SALES	    ¦ Data ¦14.07.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ FUNCAO RESPONSÁVEL PELA IMPRESSÃO DO RELATÓRIO			  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ CONTABILIDADE                                          	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function PrintReport(oReport)

	Local oSection1 := oReport:Section(1)
	
	/*-----------------------------------------------------------------| 		    			           
	| seleção dos dados a serem impressos/carrega o arquivo temporário | 
	|-----------------------------------------------------------------*/
	
	MsAguarde({|| fSelDados()},"Selecionando contas")
	
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
                    
	Local clDescDeb :=space(30)
	Local clDescCred:=space(30)
	Local nCont		:=1
	 
	/*-------------------------------| 		    			           
	| criação do arquivo de trabalho | 
	|-------------------------------*/
	_aStru	:= {}
	
	AADD(_aStru,{"ALIAS"	,"C",03,0})	
	AADD(_aStru,{"TIPO"		,"C",03,0})
	AADD(_aStru,{"SERPRE"	,"C",03,0})
	AADD(_aStru,{"DOC"		,"C",09,0})
	AADD(_aStru,{"PARCELA"	,"C",03,0})
	AADD(_aStru,{"CLIENTE"	,"C",09,0})
   //	AADD(_aStru,{"DESCCLI"	,"C",40,0})
	AADD(_aStru,{"LOJA"		,"C",03,0})
	AADD(_aStru,{"EMISSAO"	,"D",08,0})
   //	AADD(_aStru,{"VLRDOC"	,"N",14,2})
	AADD(_aStru,{"CONTAD"	,"C",20,0})
	AADD(_aStru,{"DESCDEB"	,"C",30,0})
	AADD(_aStru,{"VLRDEB"	,"N",14,2})
	AADD(_aStru,{"CONTAC"	,"C",20,0})
	AADD(_aStru,{"DESCCRE"	,"C",30,0})
	AADD(_aStru,{"HISTCONT"	,"C",30,0})
	AADD(_aStru,{"VLRCRED"	,"N",14,2})	
	AADD(_aStru,{"VALDEB"	,"N",14,2})
	AADD(_aStru,{"VALCRED"	,"N",14,2}) 
			
   	_cArq     := CriaTrab(_aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)        
	                                            
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	IndRegua("TRB",_cIndice,"EMISSAO",,,"Selecionando Registros...")
	
	/*-----------------------------------------------------------------------------------------------|
	 |	Montagem da query para trazer os lancamentos correspodentes as contas a pagar e fazer o 	 |
	 |  o rastreamento.                                                                              |
	 |-----------------------------------------------------------------------------------------------*/                                           
		
	clQuery := " SELECT "
	clQuery += " 	MOVDET.ALIAS, MOVDET.TIPO, MOVDET.SERPREF, MOVDET.DOC, MOVDET.PARC, MOVDET.CLIENTE, MOVDET.LOJA, " 
	clQuery += " 	MOVDET.VALOR, MOVDET.EMISSAO, MOVDET.R_E_C_N_O_, BASECTB.CT2REC, BASECTB.DTEMIS, SUM(BASECTB.VRDEB) AS VRDEB, SUM(BASECTB.VRCRED) AS VRCRED, "
	clQuery += " 	BASECTB.LOTE, BASECTB.SBLOTE, BASECTB.DOC, BASECTB.CTK_TABORI, BASECTB.CTK_RECORI, BASECTB.CTK_DATA, BASECTB.CTK_LOTE, "
	clQuery += " 	BASECTB.CTK_SBLOTE, BASECTB.CTK_ROTINA,BASECTB.CT2_DEBITO,BASECTB.CT2_CREDIT,BASECTB.CT2_HIST "
	clQuery += " FROM "
	clQuery += " ( "
	
	clQuery += " SELECT   "
	clQuery += " 	'SF2' AS ALIAS, F2_TIPO AS TIPO, F2_SERIE AS SERPREF, F2_DOC AS DOC, ' ' AS PARC, F2_CLIENTE AS CLIENTE, F2_LOJA AS LOJA, "
	clQuery += "     F2_VALBRUT AS VALOR, F2_EMISSAO AS EMISSAO, R_E_C_N_O_  "
	clQuery += " FROM "
	clQuery += "    "+RetSQLName("SF2")+" AS SF2 "
	clQuery += " WHERE  "
	clQuery += "     (D_E_L_E_T_ <> '*') AND (F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"') "
	     
	clQuery += "    UNION " 
	  
	clQuery += " SELECT "
	clQuery += " 	'SF1' AS ALIAS, F1_TIPO AS TIPO, F1_SERIE AS SERPREF, F1_DOC AS DOC, ' ' AS PARC, F1_FORNECE AS CLIENTE, F1_LOJA AS LOJA, F1_VALBRUT AS VALOR, F1_DTDIGIT AS EMISSAO, R_E_C_N_O_  "
	clQuery += " FROM "
	clQuery += "    "+RetSQLName("SF1")+" AS SF1 "
	clQuery += " WHERE  "
	clQuery += "     (D_E_L_E_T_ <> '*')  AND (F1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"') "
	     
	clQuery += " UNION   "
	  
	clQuery += " SELECT "
	clQuery += "     'SE1' AS ALIAS, E1_TIPO AS TIPO, E1_PREFIXO AS SERPREF, E1_NUM AS DOC, E1_PARCELA AS PARC, E1_CLIENTE AS CLIENTE, E1_LOJA AS LOJA, E1_VALOR AS VALOR, E1_EMISSAO AS EMISSAO, R_E_C_N_O_  "
	clQuery += " FROM "
	clQuery += "    "+RetSQLName("SE1")+" AS SE1 "
	clQuery += " WHERE  "
	clQuery += "     (D_E_L_E_T_ <> '*') AND (E1_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"') "
	      
	clQuery += " UNION ALL  "
	  
	clQuery += "    SELECT "
	clQuery += "     'SE2' AS ALIAS, E2_TIPO AS TIPO, E2_PREFIXO AS SERPREF, E2_NUM AS DOC, E2_PARCELA AS PARC, E2_FORNECE AS CLIENTE, E2_LOJA AS LOJA, E2_VALOR AS VALOR, E2_EMISSAO AS EMISSAO, R_E_C_N_O_  "
	clQuery += " FROM "
	clQuery += "    SE2030 AS SE2 "
	clQuery += " WHERE  "
	clQuery += "     (D_E_L_E_T_ <> '*') AND (E2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"') "
	        
	clQuery += " UNION ALL " 
	  
	clQuery += " SELECT  "
	clQuery += "     'SE5' AS ALIAS, E5_TIPO AS TIPO, E5_PREFIXO AS SERPREF, E5_NUMERO AS DOC, E5_PARCELA AS PARC, E5_CLIFOR AS CLIENTE, E5_LOJA AS LOJA, E5_VALOR AS VALOR, E5_DATA AS EMISSAO, R_E_C_N_O_  "
	clQuery += " FROM "
	clQuery += " 	"+RetSQLName("SE5")+" AS SE5 "
	clQuery += " WHERE "
	clQuery += "     (D_E_L_E_T_ <> '*') AND (E5_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"') " 
	     
	clQuery += "     ) AS MOVDET RIGHT OUTER JOIN "
	clQuery += " (SELECT "
	clQuery += "       CT2.R_E_C_N_O_ AS CT2REC, CT2.CT2_DATA AS DTEMIS, "
	clQuery += "       CASE WHEN (CT2_DEBITO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"') THEN (CT2_VALOR) ELSE 0 END AS 'VRDEB',   "
	clQuery += "       CASE WHEN (CT2_CREDIT BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"') THEN (CT2_VALOR) ELSE 0 END AS 'VRCRED', "
	clQuery += "       CT2.CT2_LOTE AS LOTE, "
	clQuery += "       CT2.CT2_SBLOTE AS SBLOTE, CT2.CT2_DOC AS DOC, CT2.CT2_LINHA AS LINHA, CTK.CTK_TABORI, CTK.CTK_RECORI, CTK.CTK_DATA, CTK.CTK_LOTE, "
	clQuery += "       CTK.CTK_SBLOTE, CTK.CTK_ROTINA,CT2_DEBITO,CT2_CREDIT,CT2_HIST  "
	clQuery += " FROM "
	clQuery += "       "+RetSQLName("CTK")+" AS CTK RIGHT OUTER JOIN "
	clQuery += "       "+RetSQLName("CT2")+" AS CT2 ON CTK.D_E_L_E_T_ = CT2.D_E_L_E_T_ AND CTK.CTK_RECDES = CT2.R_E_C_N_O_  "
	  
	clQuery += " WHERE "
	clQuery += "       (CT2.D_E_L_E_T_ <> '*') AND (CT2.CT2_DEBITO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"') AND (CT2.CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"') OR "
	clQuery += "       (CT2.D_E_L_E_T_ <> '*') AND (CT2.CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"') AND (CT2.CT2_CREDIT BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"') "
	clQuery += " GROUP BY "
	clQuery += "       CT2.R_E_C_N_O_, CT2.CT2_DATA, CT2.CT2_VALOR, CT2.CT2_LOTE, CT2.CT2_SBLOTE, CT2.CT2_DOC, CT2.CT2_LINHA, CTK.CTK_TABORI, "
	clQuery += " 	      CTK.CTK_RECORI, CTK.CTK_DATA, CTK.CTK_LOTE, CTK.CTK_SBLOTE, CTK.CTK_ROTINA, CT2_VALOR, CT2_DEBITO, CT2_CREDIT,CT2_HIST "
	clQuery += "       ) AS BASECTB "
	clQuery += " ON MOVDET.ALIAS = BASECTB.CTK_TABORI AND MOVDET.R_E_C_N_O_ = BASECTB.CTK_RECORI AND BASECTB.CTK_TABORI<> 'SRZ'  "
	clQuery += " GROUP BY "
	clQuery += "    MOVDET.ALIAS, MOVDET.TIPO, MOVDET.SERPREF, MOVDET.DOC, MOVDET.PARC, MOVDET.CLIENTE, MOVDET.LOJA, "
	clQuery += "    MOVDET.VALOR, MOVDET.EMISSAO, MOVDET.R_E_C_N_O_, BASECTB.CT2REC, BASECTB.DTEMIS, "
	clQuery += "    BASECTB.LOTE, BASECTB.SBLOTE, BASECTB.DOC, BASECTB.CTK_TABORI, BASECTB.CTK_RECORI, BASECTB.CTK_DATA, BASECTB.CTK_LOTE, "
	clQuery += "    BASECTB.CTK_SBLOTE, BASECTB.CTK_ROTINA,BASECTB.CT2_DEBITO,BASECTB.CT2_CREDIT,BASECTB.CT2_HIST  "
	clQuery += " ORDER BY ALIAS, MOVDET.R_E_C_N_O_ "
	    															
	/*---------------------------------------------| 		    			           
	| Verifica se a Query Existe, se existir fecha |
	|---------------------------------------------*/ 
	                                            
	If Select("TSQL1") > 0
		dbSelectArea("TSQL1")
		DbCloseArea()
	EndIf 
	
	
	MemoWrite("TTCTBR003.SQL",clQuery)
	
	/*---------------------------------------------| 		    			           
	| cria a query e dar um apelido                | 
	|---------------------------------------------*/
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,clQuery),"TSQL1",.F.,.T.)
	
	/*------------------------------------------------------| 		    			           
	| ajusta as casas decimais e datas no retorno da query  | 
	|-------------------------------------------------------*/
	
	TcSetField("TSQL1","DTEMIS" ,"D",08,0)
   //	TcSetField("TSQL1","VALOR"	,"N",14,2)
	TcSetField("TSQL1","VRDEB"	,"N",14,2)
	TcSetField("TSQL1","VRCRED"	,"N",14,2)
	
	dbSelectArea("TSQL1")
	TSQL1->(dbGotop())
	Do While TSQL1->(!Eof())
	
	
	
	/*-----------------------------------------------|
	|	POSICIONA E EXTRAI A DESCRICAO DA CONTA CONT |
	|-----------------------------------------------*/
	                                             	//
		DBSELECTAREA("CT1")                      	//
		DBSETORDER(1)                            	//
		IF DBSEEK(XFILIAL("CT1")+ TSQL1->CT2_DEBITO)//
			clDescDeb:=CT1->CT1_DESC01           	//
		ENDIF                                    	//
		IF DBSEEK(XFILIAL("CT1")+ TSQL1->CT2_CREDIT)//
			clDescCred:=CT1->CT1_DESC01          	//
		ENDIF                                    	//
	//------------------------------------------------ 		
		
	/*------------------------------------| 		    			           
	| Mostra o processamento do registro  | 
	|------------------------------------*/
		
		MsProcTxt("Processando Item "+ STR(nCont) )
			
	/*----------------------------| 		    			           
	| adiciona registro em banco  | 
	|----------------------------*/
	
		   DbSelectArea("TRB")  
			RecLock("TRB",.T.)
					
				TRB->ALIAS	:= TSQL1->CTK_TABORI					     	     		     
		     	TRB->TIPO	:= TSQL1->TIPO
		     	TRB->SERPRE	:= TSQL1->SERPREF
		      	TRB->DOC	:= TSQL1->DOC	      	
		      	TRB->PARCELA:= TSQL1->PARC
		     	TRB->CLIENTE:= TSQL1->CLIENTE
		      	TRB->LOJA	:= TSQL1->LOJA	      	
			    TRB->EMISSAO:= TSQL1->DTEMIS
		       //	TRB->VLRDOC	:= TSQL1->VALOR
		    	TRB->CONTAD	:= TSQL1->CT2_DEBITO
		        TRB->DESCDEB:= clDescDeb	      	    
		        TRB->VLRDEB := TSQL1->VRDEB
		        IF TSQL1->VRDEB=0
		        	TRB->VALCRED:= TSQL1->VALOR	
		        ELSEIF TSQL1->VRCRED=0
		        	TRB->VALDEB:= TSQL1->VALOR
		        ENDIF	 
		        TRB->CONTAC	:= TSQL1->CT2_CREDIT
		        TRB->DESCCRE:= clDescCred	      	
		        TRB->VLRCRED:= TSQL1->VRCRED
		        TRB->HISTCONT:= TSQL1->CT2_HIST
		                  	        	           	        
			MsUnlock()
			clDescDeb :=space(30)
			clDescCred:=space(30)		
			nCont++
	        DbSelectArea("TSQL1")
		 	DbSkip()
		Enddo
		
	If Select("TSQL1") > 0
		dbSelectArea("TSQL1")
		DbCloseArea()
	EndIf
	
Return

Static Function ValPerg(cPerg)

	PutSx1(cPerg,'01','Emissao de   ?','','','mv_ch1','D',8, 0,0,'G','','','','','mv_par01',,,'','','','','','','','','','',{"periodo inicial para impressao"},'','','')
	PutSx1(cPerg,'02','Emissao Ate  ?','','','mv_ch2','D',8, 0,0,'G','','','','','mv_par02',,,'','','','','','','','','','',{"periodo final para impressao"},'','','')
	PutSx1(cPerg,'03','Conta de     ?','','','mv_ch3','C',15,0,0,'G','','CT1','','','mv_par03',,,'','','','','','','','','','',{"conta inicial para impressao"},'','','')
	PutSx1(cPerg,'04','Conta ate    ?','','','mv_ch4','C',15,0,0,'G','','CT1','','','mv_par04',,,'','','','','','','','','','',{"conta final para impressao"},'','','')
Return