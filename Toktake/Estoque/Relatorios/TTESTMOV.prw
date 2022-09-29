
/*--------------------------|
|Biblioteca de funções		|
|--------------------------*/  
 #INCLUDE "RWMAKE.CH"      
 #INCLUDE "TOPCONN.CH"

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦TTESTMOV() ¦ Autor ¦ Fabio Sales		    ¦ Data ¦26.06.2012¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Relatório de todas as movimentações dos produtos das PAs	  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ TokeTake/Estoque                                           ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

User Function TTESTMOV()
	Local oReport
	
	If cEmpAnt <> "01"
		Return
	EndIf

	If TRepInUse()
		oReport := ReportDef()
		oReport:PrintDialog()
	EndIf
Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ReportDef	 ¦ Autor ¦ Fabio Sales		    ¦ Data ¦26.02.2012¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Função de impressão do relatório							  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ TokeTake/Estoqu                                      	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function ReportDef()

	Local oReport
	Local oSection
	Private cPerg    := "TTESTMOV"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)		

	oReport := TReport():New("DESPESAS","RELATORIO DE MOVIMENTACOES","",{|oReport| PrintReport(oReport)},"Eeste relatório imprimira as movimentações de saidas, entrdas e movimentações internas")	
	
	/*--------------------------------------|
	| Seção dados dos lançamentos contábeis |
	|--------------------------------------*/
	
	oSection1 := TRSection():New(oReport,OemToAnsi("Movimentações"),{"TRB"})
	
	/*------------------------------------------------------------------\
	|                       Campo   |   Alias|  Título   |   Pic|Tam	|
	\------------------------------------------------------------------*/				
	
	TRCell():New(oSection1,"FILIAL"		,"TRB","FILIAL"		,"@!",02)	
	TRCell():New(oSection1,"TABELA"		,"TRB","TABELA"		,"@!",03)	
	TRCell():New(oSection1,"NOTA"		,"TRB","NOTA"		,"@!",09)	
	TRCell():New(oSection1,"SERIE"		,"TRB","SERIE"		,"@!",03)	
	TRCell():New(oSection1,"PRODUTO"	,"TRB","PRODUTO"	,"@!",15)	
	TRCell():New(oSection1,"DESCRI"		,"TRB","DESCRÇÃO"	,"@!",35)	
	TRCell():New(oSection1,"ARMAZEM"	,"TRB","ARMAZEM(PA)","@!",06)	
	TRCell():New(oSection1,"CLIEFORN"	,"TRB","CLIE/FORN"	,"@!",06)		
	TRCell():New(oSection1,"LOJA"		,"TRB","LOJA"		,"@!",04)	
	TRCell():New(oSection1,"QTDE_ENT"	,"TRB","QTDE_ENT"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"QTDE_SAI"	,"TRB","QTDE_SAI"	,"@E 999,999.99",16)	
	TRCell():New(oSection1,"DTDATA"		,"TRB","DTDATA"		,"@!",10)	
	TRCell():New(oSection1,"TES"		,"TRB","TES"		,"@!",03)	
	TRCell():New(oSection1,"TM"			,"TRB","TM"			,"@!",03)	
	TRCell():New(oSection1,"TESTM"		,"TRB","DESCRIÇÃO(TES/TM)","@!",15)	
	TRCell():New(oSection1,"TIPO"		,"TRB","TIPO"		,"@!",10)			
	TRCell():New(oSection1,"HORA"		,"TRB","HORA"		,"@!",05)			
	
Return oReport

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦PrintReport ¦ Autor ¦ Fabio Sales		    ¦ Data ¦26.06.2012¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Função responsável pela impressão do relatório			  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ TokeTake/Estoque                                     	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function PrintReport(oReport)

	Local oSection1 := oReport:Section(1)
	
/*--------------------------------------------------------------------------------|
| Selecao dos dados a Serem Impressos // Carrega o Arquivo Temporario de Trabalho |
|--------------------------------------------------------------------------------*/
		                                                                            
	 MsAguarde({|| fSelDados()},"Selecionando Itens")                               
	                              
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

/*-------------------------------------------------------------|
| Selecao dos dados a serem impressos // criacao do temporario |
|-------------------------------------------------------------*/ 

Static Function fSelDados()
 	
	/*---------------------------|     
	| Criacao arquivo de Trabalho|
	|---------------------------*/
     
	aStru	:= {} 
		
	AADD(aStru, {"FILIAL"   ,"C",02,0})
	AADD(aStru, {"TABELA"   ,"C",03,0})
	AADD(aStru, {"NOTA"   	,"C",09,0})
	AADD(aStru, {"SERIE"   	,"C",03,0})
	AADD(aStru, {"PRODUTO"  ,"C",15,0})
	AADD(aStru, {"DESCRI"   ,"C",35,0})
	AADD(aStru, {"ARMAZEM"  ,"C",06,0})
	AADD(aStru, {"CLIEFORN" ,"C",06,0})
	AADD(aStru, {"LOJA"   	,"C",04,0})
	AADD(aStru, {"QTDE_ENT" ,"N",16,2})
	AADD(aStru, {"QTDE_SAI" ,"N",16,2})
	AADD(aStru, {"DTDATA"   ,"C",10,0})
	AADD(aStru, {"TES"   	,"C",03,0})
	AADD(aStru, {"TM"   	,"C",03,0})
	AADD(aStru, {"TESTM"   	,"C",15,0})
	AADD(aStru, {"TIPO"   	,"C",10,0})		
	AADD(aStru, {"HORA"   	,"C",05,0})	
		
   	_cArq     := CriaTrab(aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)
	                                            
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	IndRegua("TRB",_cIndice,"NOTA",,,"Selecionando Registros...")
	
	/*----------------------------\
	| Itens das notas de entradas |
	\----------------------------*/				

	clsql:= "	SELECT * FROM( SELECT D1_FILIAL [FILIAL],  "
	clSql+= "			'SD1-->(ITENS NOTAS DE ENTRADA)' [TABELA], "
	clSql+= "			D1_DOC    [NOTA], "
	clSql+= "			D1_SERIE  [SERIE], "
	clSql+= "			D1_COD    [PRODUTO], "  
	clSql+= "			B1_DESC   [DESCRI], "
	clSql+= "			D1_LOCAL  [ARMAZEM], "
	clSql+= "			D1_FORNECE [CLIEFORN], "    			
	clSql+= "			D1_LOJA	  [LOJA], "
	clSql+= "			D1_QUANT  [QTDE_ENT], "
	clSql+= "			0   	  [QTDE_SAI], "
	clSql+= "			SUBSTRING(D1_DTDIGIT,7,2)+'/'+ SUBSTRING(D1_DTDIGIT,5,2)+'/'+SUBSTRING(D1_DTDIGIT,1,4) [DTDATA], "
	clSql+= "			D1_TES    [TES], "
	clSql+= "			''     	  [TM],  "
	clSql+= "			F4_TEXTO  [TESTM], "
	clSql+= "			'ENTRADA' [TIPO], "
	clSql+= "			F1_HORA   [HORA] "
		clSql+= "	 FROM 	"+RetSqlName("SD1")+" SD1 "
	clSql+= "	 INNER JOIN "+RetSqlName("SB1")+" SB1 ON "
	clSql+= "			D1_COD=B1_COD "
	clSql+= "	 INNER JOIN "+RetSqlName("SF4")+" SF4 ON "
	clSql+= "			D1_FILIAL=F4_FILIAL "
	clSql+= "	 AND 	D1_TES	 =F4_CODIGO "
	
	clSql+= "	INNER JOIN "+RetSqlName("SF1")+" SF1 ON"
	clSql+= "		D1_FILIAL=F1_FILIAL AND D1_SERIE=F1_SERIE AND D1_DOC=F1_DOC AND D1_FORNECE=F1_FORNECE AND D1_LOJA=F1_LOJA"
	
	clSql+= "	 WHERE	SD1.D_E_L_E_T_='' "
	clSql+= "	 AND		SB1.D_E_L_E_T_='' "
	clSql+= "	 AND 	SF4.D_E_L_E_T_='' "
	clSql+= "	 AND 	F4_ESTOQUE='S' "
	clSql+= "	 AND D1_COD BETWEEN '' AND 'ZZZZZZZ' "
	clSql+= "	 AND D1_LOCAL BETWEEN 'P00000' AND 'PZZZZZ' "
	clSql+= "	 AND D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"'AND '"+DTOS(MV_PAR02)+"' "
	clSql+= "	 AND D1_FILIAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
				
	clSql+= "	 UNION ALL "
   
	/*--------------------------\
	| Itens das notas de saidas |
	\--------------------------*/ 
					                                                                          
	clSql+= "	 SELECT	D2_FILIAL  [FILIAL], "
	clSql+= "	        'SD2-->(ITENS NOTAS DE SAIDAS)' [TABELA], "
	clSql+= "			D2_DOC      [NOTA], "
	clSql+= "			D2_SERIE    [SERIE], "
	clSql+= "			D2_COD      [PRODUTO], "
	clSql+= "			B1_DESC     [DESCRI], "
	clSql+= "			D2_LOCAL AS [ARMAZEM], "
	clSql+= "			D2_CLIENTE  [CLIEFORN], "
	clSql+= "			D2_LOJA     [LOJA], "
	clSql+= "			D2_QTDEDEV	[QTDE_ENT], "
	clSql+= "			D2_QUANT    [QTDE_SAI], "
	clSql+= "			SUBSTRING(D2_EMISSAO,7,2)+'/'+ SUBSTRING(D2_EMISSAO,5,2)+'/'+SUBSTRING(D2_EMISSAO,1,4) [DTDATA], "
	clSql+= "			D2_TES      [TES], "
	clSql+= "			''      	[TM], "
	clSql+= "			F4_FINALID  [TESTM], "
	clSql+= "			CASE WHEN D2_TES='934' THEN 'DESCARTE' ELSE 'SAIDA' END AS   [TIPO]," //'SAIDA'    [TIPO], "
	clSql+= "			F2_HORA [HORA]"
	clSql+= "	 FROM 	"+RetSqlName("SD2")+" SD2 "
	clSql+= "	 INNER JOIN "+RetSqlName("SB1")+" SB1 ON "
	clSql+= "			D2_COD=B1_COD "
	clSql+= "	 INNER JOIN "+RetSqlName("SF4")+" SF4 ON "
	clSql+= "			D2_FILIAL=F4_FILIAL "
	clSql+= "	 AND		D2_TES	 =F4_CODIGO "
	clSql+= "	 INNER JOIN "+RetSqlName("SF2")+" SF2 ON "
	clSql+= "				D2_FILIAL=F2_FILIAL "
	
	clSql+= "	 AND		D2_DOC	 =F2_DOC "
	clSql+= "	 AND		D2_SERIE =F2_SERIE "
	clSql+= "	 AND		D2_CLIENTE	=F2_CLIENTE "
	clSql+= "	 AND		D2_LOJA	 =F2_LOJA "
	clSql+= "	 AND		D2_EMISSAO =F2_EMISSAO "
	clSql+= "	 WHERE	SD2.D_E_L_E_T_='' "
	clSql+= "	 AND		SB1.D_E_L_E_T_='' "
	clSql+= "	 AND		SF4.D_E_L_E_T_='' "
	clSql+= "	 AND		SF2.D_E_L_E_T_='' "
	clSql+= "	 AND 	F4_ESTOQUE='S' "
	clSql+= "	 AND D2_COD BETWEEN '' AND 'ZZZZZZZ' "
	clSql+= "	 AND D2_LOCAL BETWEEN 'P00000' AND 'PZZZZZ' "
	clSql+= "	 AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"'AND '"+DTOS(MV_PAR02)+"' "
	clSql+= "	 AND D2_FILIAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
				                                                                  
	clSql+= "	 UNION ALL " 
	
	/*-----------------------\
	| Movimentações internas |
	\-----------------------*/ 
		                                                  
	clSql+= "	 SELECT	D3_FILIAL [FILIAL], "
	clSql+= "			'SD3-->(MOVIMENTO INTERNO)' [TABELA], "
	clSql+= "			D3_DOC      [NOTA], "
	clSql+= "			''    		[SEIRE], "
	clSql+= "			D3_COD      [PRODUTO], "
	clSql+= "			B1_DESC     [DESCRI], "
	clSql+= "	        D3_LOCAL	[ARMEZEM], "
	clSql+= "			''			[CLIEFORN], "
	clSql+= "			''     		[LOJA], "
	clSql+= "			QTDE_ENT= CASE WHEN D3_TM<=499 "
	clSql+= "			THEN D3_QUANT ELSE 0 END, "
	clSql+= "			QTDE_SAI= CASE WHEN D3_TM > 499 "
	clSql+= "			THEN D3_QUANT ELSE 0 END, "
	clSql+= "			SUBSTRING(D3_EMISSAO,7,2)+'/'+ SUBSTRING(D3_EMISSAO,5,2)+'/'+SUBSTRING(D3_EMISSAO,1,4) [DTDATA], "
	clSql+= "			''      	[TES], "
	clSql+= "			D3_TM       [TM],  "
	clSql+= "			'TESTM'= CASE WHEN (D3_TM IN('999','499')  "
	clSql+= "				AND RIGHT(D3_CF,1)= '0') "
	clSql+= "						THEN 'Ajuste de inventário' "
	clSql+= "			WHEN 	(D3_TM IN('999','499')"
	clSql+= "					AND RIGHT(D3_CF,1)= '1') "
	clSql+= "						THEN 'Requisição para prodção' "
	clSql+= "			WHEN 	(D3_TM IN('999','499') "
	clSql+= "					AND RIGHT(D3_CF,1)= '2') "
	clSql+= "						THEN 'Requisição de Processos' "
	clSql+= "			WHEN	(D3_TM IN('999','499') "
	clSql+= "					AND RIGHT(D3_CF,1)= '3') "
	clSql+= "						THEN 'Requisição Mat.Indireto' "
	clSql+= "			WHEN 	(D3_TM IN('999','499') "
	clSql+= "					AND RIGHT(D3_CF,1)= '4') "
	clSql+= "						THEN 'Transferencias entre armazens' "
	clSql+= "			WHEN	(D3_TM IN('999','499') "
	clSql+= "					AND RIGHT(D3_CF,1) NOT IN ('0','1','2','3','4')) "
	clSql+= "						THEN 'Mov. automático do sistema' "
	clSql+= "			WHEN D3_TM NOT IN('999','499') "
	clSql+= "						THEN F5_TEXTO "
	clSql+= "			END, "
	clSql+= "			TIPO = CASE WHEN D3_TM <= '499' "
	clSql+= "			THEN 'ENTRADA' ELSE 'SAIDA' END, "
	clSql+= "			''   [HORA]"
	clSql+= "	 FROM 	"+RetSqlName("SD3")+" SD3 "
	clSql+= "	 INNER JOIN "+RetSqlName("SB1")+" SB1 ON  "
	clSql+= "			D3_COD=B1_COD "
	clSql+= "	 LEFT OUTER JOIN "+RetSqlName("SF5")+" SF5 ON "
	clSql+= "		D3_FILIAL =F5_FILIAL AND D3_TM=F5_CODIGO "
	clSql+= "	 WHERE	SD3.D_E_L_E_T_='' "
	clSql+= "	 AND	SB1.D_E_L_E_T_='' "
	clSql+= "	 AND	D3_ESTORNO ='' "
	clSql+= "	 AND D3_COD BETWEEN '' AND 'ZZZZZZ' "
	clSql+= "	 AND D3_LOCAL BETWEEN 'P00000' AND 'PZZZZZ' "
	clSql+= "	 AND D3_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"'AND '"+DTOS(MV_PAR02)+"' "
	clSql+= "	 AND D3_FILIAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' ) AS MOVS " 
	clSql+= "	 ORDER BY MOVS.FILIAL,MOVS.ARMAZEM ,MOVS.PRODUTO ,MOVS.DTDATA "	 	
							
	If Select("JAPA01") > 0
		dbSelectArea("JAPA01")
		DbCloseArea()
	EndIf
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,clSql),"JAPA01",.F.,.T.)	
	
	dbSelectArea("JAPA01")
	dbGotop()	
	Do While JAPA01->(!Eof())
		MsProcTxt("Processando Item "+JAPA01->NOTA)
			                                                           
		DbSelectArea("TRB")			
	     
		RecLock("TRB",.T.)		
			TRB->FILIAL		:= JAPA01->FILIAL
			TRB->TABELA		:= JAPA01->TABELA
			TRB->NOTA		:= JAPA01->NOTA
			TRB->SERIE		:= JAPA01->SERIE
			TRB->PRODUTO	:= JAPA01->PRODUTO
			TRB->DESCRI		:= JAPA01->DESCRI
			TRB->ARMAZEM	:= JAPA01->ARMAZEM
			TRB->CLIEFORN	:= JAPA01->CLIEFORN
			TRB->LOJA		:= JAPA01->LOJA
			TRB->QTDE_ENT	:= JAPA01->QTDE_ENT
			TRB->QTDE_SAI	:= JAPA01->QTDE_SAI
			TRB->DTDATA		:= JAPA01->DTDATA
			TRB->TES		:= JAPA01->TES
			TRB->TM			:= JAPA01->TM
			TRB->TESTM		:= JAPA01->TESTM
			TRB->TIPO		:= JAPA01->TIPO	
			TRB->HORA		:= JAPA01->HORA	
		MsUnlock()
				
		dbSelectArea("JAPA01")
		DbSkip() 
	Enddo		
Return

/*---------------------------------|
|Criação dos parâmetro de perguntas|
|---------------------------------*/

Static Function ValPerg(cPerg)	                                                                                                         
	PutSx1(cPerg,'01','Data de       	?','','','mv_ch1','D',8, 0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'02','Data ate      	?','','','mv_ch2','D',8, 0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')				   
	PutSx1(cPerg,'03','Filial  de   	?','','','mv_ch3','C',02,0,0,'G','','','','','mv_par03',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'04','Filial ate   	?','','','mv_ch4','C',02,0,0,'G','','','','','mv_par04',,,'','','','','','','','','','','','','','')	            	
Return nil
