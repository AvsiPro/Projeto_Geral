
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
¦¦¦Funçào    ¦TTFINR02() ¦ Autor ¦ FABIO SALES		    ¦ Data ¦18.06.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ CONTAS A RECEBER									          ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ FINANCEIRO                                              	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/  

User Function TTFINR02()
	Local oReport
	If cEmpAnt == "01"
		If TRepInUse()	
			oReport := ReportDef()
			oReport:PrintDialog()	
		EndIf
	eNDIF
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
	Private cPerg    := "TTFIN02"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New("TTFINR02","RELATORIO DE CONTAS A RECEBER EM ABERTO","",{|oReport| PrintReport(oReport)},"ESTE RELATORIO IMPRIMIRAR AS CONTAS A RECEBER EM ABERTO")
	
	/*-------------------------| 		    			           
	| seção dos titulo a pagar | 
	|-------------------------*/
	
	oSection1 := TRSection():New(oReport,OemToAnsi("CONTAS A RECEBER EM ABERTO"),{"TRB"})
	
	/*----------------------------------------------------------------------------------| 		    			           
	|                       campo        alias  título       	 pic           tamanho  | 
	|----------------------------------------------------------------------------------*/	
	       
	TRCell():New(oSection1,"FILIAL"		,"TRB","FILIAL		"	,"@!"			,02)
	TRCell():New(oSection1,"NUMERO"		,"TRB","NUMERO		"	,"@!"			,09)
	TRCell():New(oSection1,"PREFIXO"	,"TRB","PREFIXO		"	,"@!"			,03)		
	TRCell():New(oSection1,"PARCELA"	,"TRB","PARCELA		"	,"@!"			,03)
	TRCell():New(oSection1,"TIPO"		,"TRB","TIPO		"	,"@!"			,03)
	TRCell():New(oSection1,"VALOR"		,"TRB","VAL_TITULO	"	,"@E 999,999.99",16)	
	TRCell():New(oSection1,"VALLIQ"		,"TRB","VAL_RECEBIDO"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"SALDO"		,"TRB","VAL_A_RECEBER"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"MULTA"		,"TRB","MULTA		"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"DESCONTO"	,"TRB","DESCONTO	"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"JUROS"		,"TRB","JUROS		"	,"@E 999,999.99",16)	
	TRCell():New(oSection1,"NATUREZA"	,"TRB","NATUREZA	"	,"@!"			,10)
	TRCell():New(oSection1,"CCUSTO"		,"TRB","CEN. CUSTO	"	,"@!"			,10)
	TRCell():New(oSection1,"NCUSTO"		,"TRB","DESC. C.CUSTO"	,"@!"			,30)
	TRCell():New(oSection1,"CLIENTE"	,"TRB","CLIENTE	"		,"@!"			,06)	
	TRCell():New(oSection1,"LOJA"		,"TRB","LOJACLI		"	,"@!"			,04)
	TRCell():New(oSection1,"NOMCLI"		,"TRB","NOM_CLIENTE	"	,"@!"			,30)			
	TRCell():New(oSection1,"EMISSAO"	,"TRB","EMISSAO		"	,				,08)
	TRCell():New(oSection1,"VENCREAL"	,"TRB","VENC_REAL	"	,				,08)
	TRCell():New(oSection1,"HISTORICO"	,"TRB","HIST_TITULO	"	,				,256)
	TRCell():New(oSection1,"SITUACA"	,"TRB","SITUACAO_TITULO",				,15)
	TRCell():New(oSection1,"COD_PA"		,"TRB","CODIGO_PA"		,				,06)
	TRCell():New(oSection1,"DSCPPA"		,"TRB","DESCRICAO_PA"	,				,15)
				
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

	Local clSit
    Local clCcusto
    Local clCusto :=""
	Local clNcusto:=""  
	/*-------------------------------| 		    			           
	| criação do arquivo de trabalho |
	|-------------------------------*/
	
	_aStru	:= {}
			    
	AADD(_aStru,{"FILIAL"	,"C",02,0})
	AADD(_aStru,{"NUMERO"	,"C",09,0})
	AADD(_aStru,{"PREFIXO"	,"C",03,0})		
	AADD(_aStru,{"PARCELA"	,"C",03,0})
	AADD(_aStru,{"TIPO"		,"C",03,0})	
	AADD(_aStru,{"CCUSTO"	,"C",10,0})	
	AADD(_aStru,{"NCUSTO"	,"C",30,0})
	AADD(_aStru,{"NATUREZA"	,"C",10,0})
	AADD(_aStru,{"CLIENTE"	,"C",06,0})	
	AADD(_aStru,{"LOJA"		,"C",04,0})
	AADD(_aStru,{"NOMCLI"	,"C",30,0})   
	AADD(_aStru,{"HISTORICO","C",256,0})
	AADD(_aStru,{"SITUACA"  ,"C",15,0})
	AADD(_aStru,{"EMISSAO"	,"D",8 ,0})
	AADD(_aStru,{"VENCREAL"	,"D",8 ,0}) 
	AADD(_aStru,{"VALOR"	,"N",14,2})
	AADD(_aStru,{"SALDO"	,"N",14,2})
	AADD(_aStru,{"VALLIQ"	,"N",14,2})
	AADD(_aStru,{"JUROS"	,"N",14,2})	
	AADD(_aStru,{"MULTA"	,"N",14,2})
	AADD(_aStru,{"DESCONTO"	,"N",14,2})
	AADD(_aStru,{"COD_PA"   ,"C",06,0})
	AADD(_aStru,{"DSCPPA"  ,"C",35,0})
						
   	_cArq     := CriaTrab(_aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)
	                                            
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	IndRegua("TRB",_cIndice,"NUMERO",,,"Selecionando Registros...")
	                     
	/*-----------------------------------------------------| 		    			           
	| Montagem da query com os titulos a receber em aberto |
	|-----------------------------------------------------*/

	cQuery := " SELECT E1_MSFIL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_NATUREZ,E1_CLIENTE,E1_LOJA,E1_NOMCLI,E1_MULTA,E1_JUROS,E1_SITUACA,E1_XCODPA,E1_XNOMPA, "
	cQuery += " E1_DESCONT,E1_EMISSAO,E1_VENCTO,E1_VENCREA,E1_VALOR,E1_SALDO,(E1_VALOR - E1_SALDO)AS VALREC,E1_HIST FROM "+RetSqlName("SE1")+" SE1  "
	cQuery += " WHERE  D_E_L_E_T_=''  "
	IF MV_PAR09==1                                                        
		cQuery += "AND E1_SALDO=E1_VALOR AND E1_STATUS='A'  "	//TITULOS ABERTOS
	ELSEIF MV_PAR09==2
		cQuery += " AND E1_SALDO > 0 AND E1_SALDO < E1_VALOR " 	//TITULOS PACIALMENTE EM ABERTO
	ELSEIF MV_PAR09==3
		cQuery += "AND E1_SALDO <> 0 "							//TITULOS ABERTOS E PACIALMENTE ABERTO
	ELSEIF MV_PAR09==4
		cQuery += "AND E1_SALDO = 0 OR E1_STATUS ='B' "			//TITULOS BAIXADOS
	ELSEIF MV_PAR09==5
		cQuery += "AND E1_SALDO >= 0 "							//TODOS
	ENDIF
	cQuery += " AND E1_FILIAL ='"+xFilial("SE1")+"'  "
	cQuery += " AND E1_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'  "
	cQuery += " AND E1_VENCREA BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'  "
	cQuery += " AND E1_NUM     BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "
	cQuery += " AND E1_PREFIXO BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'  "
	cQuery += " ORDER BY E1_NUM  " 
	
	IF SELECT("FIN") > 0
		dbSelectArea("FIN")
		DbCloseArea()
	ENDIF
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"FIN",.F.,.T.)
	
	/*--------------------------------------------------| 		    			           
	| ajusta casas decimais e datas no retorno da query |
	|--------------------------------------------------*/
	
	TcSetField("FIN","E1_VALOR 	","N",14,2)
	TcSetField("FIN","E1_SALDO 	","N",14,2)
	TcSetField("FIN","VALREC","N",14,2)
	TcSetField("FIN","E1_EMISSAO","D",08,0)
	TcSetField("FIN","E1_VENCREA","D",08,0)
	TcSetField("FIN","E1_DESCONT","N",14,2)
	TcSetField("FIN","E1_JUROS 	","N",14,2)
	TcSetField("FIN","E1_MULTA ","N",14,2)
			
	dbSelectArea("FIN")
	dbGotop()
		
	While FIN->(!Eof())
		clCcusto:=""
		clNcusto:=""
		     	      		       
	     DbSelectArea("TRB")
	/*--------------------------|
	| adciona registro em banco |
	|--------------------------*/
	    RecLock("TRB",.T.)
	    
	     	TRB->FILIAL		:= FIN->E1_MSFIL
	     	TRB->NUMERO		:= FIN->E1_NUM
	     	TRB->PREFIXO	:= FIN->E1_PREFIXO
	      	TRB->PARCELA	:= FIN->E1_PARCELA
	      	TRB->TIPO		:= FIN->E1_TIPO
	      	TRB->NATUREZA	:= FIN->E1_NATUREZ	        	      		        	      	
	        TRB->CLIENTE	:= FIN->E1_CLIENTE	        
	        TRB->LOJA		:= FIN->E1_LOJA
	        TRB->NOMCLI		:= FIN->E1_NOMCLI
	        TRB->EMISSAO	:= FIN->E1_EMISSAO
	        TRB->VENCREAL	:= FIN->E1_VENCREA 
	        
	        IF TRIM(FIN->E1_TIPO)<> "NF"	         
		    	TRB->VALOR 		:= -(FIN->E1_VALOR) 
	        	TRB->SALDO 		:= -(FIN->E1_SALDO) 
	        	TRB->VALLIQ		:= -(FIN->VALREC) 
	        	TRB->MULTA 		:= -(FIN->E1_MULTA) 
	        	TRB->DESCONTO	:= -(FIN->E1_DESCONT) 
	        	TRB->JUROS		:= -(FIN->E1_JUROS)
	        ELSE	
		        TRB->VALOR 		:= FIN->E1_VALOR 
		        TRB->SALDO 		:= FIN->E1_SALDO 
		        TRB->VALLIQ		:= FIN->VALREC 
		        TRB->MULTA 		:= FIN->E1_MULTA 
		        TRB->DESCONTO	:= FIN->E1_DESCONT 
		        TRB->JUROS		:= FIN->E1_JUROS
	        ENDIF          	       
	        	        
	        if FIN->E1_SITUACA =="0"
				clSit := "Carteira"
			ElseIf FIN->E1_SITUACA =="1"
				clSit := "Cob.Simples" 
			ElseIf FIN->E1_SITUACA =="2"
				clSit := "Descontada" 
			ElseIf FIN->E1_SITUACA =="3"
				clSit := "Caucionada" 
			ElseIf FIN->E1_SITUACA =="4"
				clSit := "Vinculada" 
			ElseIf FIN->E1_SITUACA =="5"
				clSit := "Advogado" 
			ElseIf FIN->E1_SITUACA =="6"
				clSit := "Judicial" 
			EndIf
									 	 	        
	        TRB->SITUACA := clSit
	        
	        TRB->HISTORICO	:= FIN->E1_HIST 
	        TRB->COD_PA :=FIN->E1_XCODPA	       	        
			TRB->DSCPPA :=FIN->E1_XNOMPA			                           
	        If Trim(FIN->E1_TIPO)=="NF" 
				clCusto:= " SELECT   F2_DOC "
				clCusto+= "		,D2_CCUSTO AS CCUSTO  "
				clCusto+= "		,COUNT(*) AS TOT "
				clCusto+= " FROM "+RetSqlName("SD2")+" AS SD2  "
				clCusto+= " INNER JOIN "+RetSqlName("SF4")+" AS SF4 "
				clCusto+= "		ON D2_FILIAL=F4_FILIAL "
				clCusto+= "		AND D2_TES=F4_CODIGO   "
				clCusto+= " INNER JOIN "+RetSqlName("SF2")+" AS SF2 "
				clCusto+= "		ON	D2_FILIAL=F2_FILIAL "
				clCusto+= "		AND D2_DOC=F2_DOC       "
				clCusto+= "		AND D2_SERIE=F2_SERIE   "
				clCusto+= "		AND D2_CLIENTE=F2_CLIENTE  "
				clCusto+= "		AND D2_LOJA=F2_LOJA        "
				clCusto+= "		AND D2_EMISSAO =F2_EMISSAO " 
				clCusto+= "		AND D2_TIPO=F2_TIPO    "
				clCusto+= " WHERE	D2_FILIAL 	='" + FIN->E1_MSFIL +"'  	"
				clCusto+= "		AND D2_DOC		='" + FIN->E1_NUM + "'      "
				clCusto+= "		AND F2_PREFIXO	='" + FIN->E1_PREFIXO + "'  "
				clCusto+= "		AND D2_CLIENTE	='" + FIN->E1_CLIENTE + "'  "
				clCusto+= "		AND D2_LOJA		='" + FIN->E1_LOJA + "'     "
				clCusto+= "		AND D2_EMISSAO 	='" + Dtos(FIN->E1_EMISSAO) + "' "
				clCusto+= "		AND SD2.D_E_L_E_T_=''  "
				clCusto+= " GROUP BY F2_DOC,D2_CCUSTO  "
			ElseIf Trim(FIN->E1_TIPO)=="NCC"			
				clCusto:= " SELECT   F1_DOC "
				clCusto+= "		,D1_CC  AS CCUSTO "
				clCusto+= "		,COUNT(*) AS TOT "
				clCusto+= " FROM "+RetSqlName("SD1")+" AS SD1  "
				clCusto+= " INNER JOIN "+RetSqlName("SF4")+" AS SF4 "
				clCusto+= "		ON D1_FILIAL=F4_FILIAL "
				clCusto+= "		AND D1_TES=F4_CODIGO   "
				clCusto+= " INNER JOIN "+RetSqlName("SF1")+" AS SF1 "
				clCusto+= "		ON	D1_FILIAL=F1_FILIAL "
				clCusto+= "		AND D1_DOC=F1_DOC       "
				clCusto+= "		AND D1_SERIE=F1_SERIE   "
				clCusto+= "		AND D1_FORNECE=F1_FORNECE  "
				clCusto+= "		AND D1_LOJA=F1_LOJA        "
				clCusto+= "		AND D1_DTDIGIT =F1_DTDIGIT " 
				clCusto+= "		AND D1_TIPO=F1_TIPO    "
				clCusto+= " WHERE	D1_FILIAL 	='" + FIN->E1_MSFIL +"'  	"
				clCusto+= "		AND D1_DOC		='" + FIN->E1_NUM + "'      "
				clCusto+= "		AND F1_PREFIXO	='" + FIN->E1_PREFIXO + "'  "
				clCusto+= "		AND D1_FORNECE	='" + FIN->E1_CLIENTE + "'  "
				clCusto+= "		AND D1_LOJA		='" + FIN->E1_LOJA + "'     "
				clCusto+= "		AND D1_DTDIGIT 	='" + Dtos(FIN->E1_EMISSAO) + "' "
				clCusto+= "		AND SD1.D_E_L_E_T_=''  "
				clCusto+= " GROUP BY F1_DOC,D1_CC  " 			
			EndIf
			If Trim(FIN->E1_TIPO) $ "NCC/NF"			
				IF SELECT("CUSTO") > 0
					dbSelectArea("CUSTO")
					DbCloseArea()
				ENDIF
					
				dbUseArea(.T.,"TOPCONN",TCGENQRY(,,clCusto),"CUSTO",.F.,.T.)
				dbSelectArea("CUSTO")
				dbGotop()
				While CUSTO->(!Eof())
		        	clCcusto:=CUSTO->CCUSTO
		        	DbSelectArea("CTT")
		        	DbSetOrder(1)
		        	If DbSeek(Xfilial("CTT")+clCcusto)
		        		clNcusto:=CTT->CTT_DESC01
		        	EndIf
		  		  CUSTO->(DBSKIP())  
				Enddo
			EndIf
			TRB->CCUSTO :=clCcusto
			TRB->nCUSTO :=clNcusto
	        	            
	      MsUnlock()
	      clSit:=""	    	      
	      dbSelectArea("FIN")
	      FIN->(DBSKIP())  
	Enddo
	
	If Select("FIN") > 0
		dbSelectArea("FIN")
		DbCloseArea()
	EndIf
	
Return

Static Function ValPerg(cPerg)

	PutSx1(cPerg,'01','EMISSAO    DE      ?','','','mv_ch1','D',08,0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'02','EMISSAO    ATE     ?','','','mv_ch2','D',08,0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'03','VENCIMENTO DE      ?','','','mv_ch3','D',08,0,0,'G','','','','','mv_par03',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'04','VENCIMENTO ATE     ?','','','mv_ch4','D',08,0,0,'G','','','','','mv_par04',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'05','TITULO     DE      ?','','','mv_ch5','C',09,0,0,'G','','','','','mv_par05',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'06','TITULO     ATE     ?','','','mv_ch6','C',09,0,0,'G','','','','','mv_par06',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'07','PREFIXO    DE      ?','','','mv_ch7','C',03,0,0,'G','','','','','mv_par07',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'08','PREFIXO    ATE     ?','','','mv_ch8','C',03,0,0,'G','','','','','mv_par08',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'09','STATUS DO TÍTULO   ?','','','mv_ch9','N',01,0,1,'C','','','','','mv_par09',"ABERTO","","","","PACIAL_ABERTO","","","ABERTO/PACIAL_ABERTO","","","BAIXADOS","","","TODOS","","")   
	
Return
