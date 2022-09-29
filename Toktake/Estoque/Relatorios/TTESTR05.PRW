
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
¦¦¦Funçào    ¦TTESTR05() ¦ Autor ¦ FABIO SALES		    ¦ Data ¦22.12.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ RELATÓRIO DE MOVIMENTAÇÕES						          ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ ESTOQUE/CUSTOS                                          	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

User Function TTESTR05()
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
	Private cPerg    := "TTESTR05"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New("TTESTR05","RELATORIO DE MOVIMENTAÇÕES","",{|oReport| PrintReport(oReport)},"ESTE RELATORIO IMPRIMIRAR TODDAS AS MOVIMENTAÇÕES QUE ALIMENTARAM ESTOQUE")
	
	/*-------------------------|
	| seção dos titulo a pagar |
	|-------------------------*/
	
	oSection1 := TRSection():New(oReport,OemToAnsi("MOVIMENTAÇÕES"),{"TRB"})
	
	/*----------------------------------------------------------------------------------|
	|                       campo        alias  título       	 pic           tamanho  |
	|----------------------------------------------------------------------------------*/
	
			
	TRCell():New(oSection1,"FILIAL"		,"TRB","FILIAL	"		,"@!",02)		 	
	TRCell():New(oSection1,"DOC"		,"TRB","DOCUMENTO	"	,"@!",09)	
	TRCell():New(oSection1,"SERIE"		,"TRB","SERIE	"		,"@!",04)					
	TRCell():New(oSection1,"ARMAZEN"	,"TRB","ARMAZEN"		,"@!",06)	
	TRCell():New(oSection1,"DESCARM"	,"TRB","DESC_ARMAZEN"	,"@!",35)	
	TRCell():New(oSection1,"PRODUTO"	,"TRB","PRODUTO	"		,"@!",15)	
	TRCell():New(oSection1,"DESC_PRO"	,"TRB","DESCR_PRODUTO"	,"@!",35)	
	TRCell():New(oSection1,"TES"		,"TRB","TES"			,"@!",04)
	TRCell():New(oSection1,"TM"			,"TRB","TIPO_MOVIMENTO"	,"@!",04)		
	TRCell():New(oSection1,"DESC_TESTM","TRB","DESC_TES/TM	"	,"@!",35)			
	TRCell():New(oSection1,"TIPO"		,"TRB","CATEGORIA"		,"@!",09)
	&&TRCell():New(oSection1,"FINALID"	,"TRB","TIPO"			,"@!",30)
	TRCell():New(oSection1,"FINAVEND"	,"TRB","FINALIDADE_VENDA" ,"@!",30)	
	TRCell():New(oSection1,"DATA_INI" 	,"TRB","DATA_INICIAL"	,	 ,08)
	TRCell():New(oSection1,"SALDO_INI"	,"TRB","SALDO INICIAL"	,"@E 999,999,999.99",14)
	TRCell():New(oSection1,"DATA_MOV" 	,"TRB","DATA_MOVIMENTOS",	 ,08)			
	TRCell():New(oSection1,"QTDE_SAI"	,"TRB","QTDE_SAIDA	"	,"@E 999,999,999.99",14)	
	TRCell():New(oSection1,"QTDE_ENT"	,"TRB","QTDE_ENTRADA"	,"@E 999,999,999.99",14)
	TRCell():New(oSection1,"SALDO"		,"TRB","SALDO_ATUAL	"	,"@E 999,999,999.99",14)

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
	
	Local clFilial	:=""
	Local clArmazen :=""
	Local clCod		:=""	 
	Local alSaldoIni:= {}
	Local nlQtdIni  := 0
	Local nlSaldat  := 0 

	/*-------------------------------|
	| criação do arquivo de trabalho |
	|-------------------------------*/
	
	_aStru	:= {} 
				
	AADD(_aStru,{"DATA_INI"	,"D",8,0})
	AADD(_aStru,{"DATA_MOV"	,"D",8,0})	 				    
	AADD(_aStru,{"FILIAL"	,"C",02,0})
	&&AADD(_aStru,{"FINALID"	,"C",30,0})
	AADD(_aStru,{"FINAVEND"	,"C",30,0})
	AADD(_aStru,{"SALDO_INI","N",14,2})	
	AADD(_aStru,{"QTDE_SAI","N",14,2})	
	AADD(_aStru,{"QTDE_ENT","N",14,2})	
	AADD(_aStru,{"SALDO","N",14,2})		
	AADD(_aStru,{"DOC"	,"C",09,0})
	AADD(_aStru,{"SERIE","C",04,0})			
	AADD(_aStru,{"ARMAZEN","C",06,0})	
	AADD(_aStru,{"DESCARM","C",35,0})			
	AADD(_aStru,{"PRODUTO"	,"C",15,0})	
	AADD(_aStru,{"DESC_PRO"	,"C",35,0})	
	AADD(_aStru,{"TES"	,"C",03,0})	
	AADD(_aStru,{"TM"	,"C",03,0})
	AADD(_aStru,{"DESC_TESTM"	,"C",35,0})
	AADD(_aStru,{"TIPO"	,"C",09,0})
	
   	_cArq     := CriaTrab(_aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)
	                                            
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	IndRegua("TRB",_cIndice,"PRODUTO",,,"Selecionando Registros...")
	                     
	/*-----------------------------------------------------|
	| Montagem da query com os titulos a receber em aberto |
	|-----------------------------------------------------*/

	clQuery := " SELECT * FROM( SELECT D1_FILIAL  AS FILIAL, " + chr(10) + chr(13)
	clQuery += "        FINALID=CASE WHEN D1_TIPO='D'   " 	+ chr(10) + chr(13)
	clQuery += "        THEN 'DEVOLUÇÃO DE VENDA' END,   " 	+ chr(10) + chr(13)
	clQuery += "		D1_DOC     AS DOC,      " 			+ chr(10) + chr(13)
	clQuery += "		''     AS 	FINAVEND,   " 			+ chr(10) + chr(13)
	clQuery += "		D1_SERIE   AS SERIE,    " 			+ chr(10) + chr(13)
	clQuery += "		D1_COD     AS COD,      " 			+ chr(10) + chr(13)
	clQuery += "		D1_LOCAL   AS ARMAZEN,  " 			+ chr(10) + chr(13)
	clQuery += "		D1_FORNECE AS CLIFOR,   " 			+ chr(10) + chr(13)
	clQuery += "		D1_LOJA	   AS LOJA,     " 			+ chr(10) + chr(13)
	clQuery += "		D1_QUANT   AS QTDE_ENT, " 			+ chr(10) + chr(13)
	clQuery += "		0   	   AS QTDE_SAI, " 			+ chr(10) + chr(13)
	clQuery += "		D1_DTDIGIT AS DTDATA,   " 			+ chr(10) + chr(13)
	clQuery += "		D1_TES     AS TES,    	" 			+ chr(10) + chr(13)
	clQuery += "		''     	   AS  TM,    	" 			+ chr(10) + chr(13)	
	clQuery += "		D1_CF      AS CF,       " 			+ chr(10) + chr(13)
	clQuery += "		B1_DESC    AS DESCRI,   " 			+ chr(10) + chr(13)
	clQuery += "		F4_TEXTO   AS DESCTMTES, " 			+ chr(10) + chr(13)
	clQuery += "		'ENTRADA'  AS TIPO      " 			+ chr(10) + chr(13)
	clQuery += " FROM 	"+RetSQLName("SD1")+" SD1   " 		+ chr(10) + chr(13)
	clQuery += " INNER JOIN "+RetSQLName("SB1")+" SB1 ON " 	+ chr(10) + chr(13)
	clQuery += "		D1_COD=B1_COD               " 		+ chr(10) + chr(13)
	clQuery += " INNER JOIN "+RetSQLName("SF4")+" SF4 ON " 	+ chr(10) + chr(13)
	clQuery += "		D1_FILIAL=F4_FILIAL         " 		+ chr(10) + chr(13)
	clQuery += " AND 	D1_TES	 =F4_CODIGO         " 		+ chr(10) + chr(13)
	clQuery += " WHERE	SD1.D_E_L_E_T_=''        " 			+ chr(10) + chr(13)
	clQuery += " AND		SB1.D_E_L_E_T_=''    " 			+ chr(10) + chr(13)
	clQuery += " AND 	SF4.D_E_L_E_T_=''        " 			+ chr(10) + chr(13)
	clQuery += " AND 	F4_ESTOQUE='S'           " 			+ chr(10) + chr(13)
	clQuery += " AND D1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' " 			   + chr(10)+ chr(13)
	clQuery += " AND D1_LOCAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' " 			   + chr(10)+ chr(13)
	clQuery += " AND D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR05)+"'AND '"+DTOS(MV_PAR06)+"' " + chr(10)+ chr(13)
	clQuery += " AND D1_FILIAL = '"+XFILIAL("SD1")+"' " 	+ chr(10)+ chr(13)
			
	clQuery += " UNION ALL                       " 			+ chr(10) + chr(13)
	                                                                          
	clQuery += " SELECT	D2_FILIAL   AS FILIAL,   " 			+ chr(10)+ chr(13)
	clQuery += "        FINALID=CASE WHEN D2_TIPO='D'   " 	+ chr(10) + chr(13)
	clQuery += "        THEN 'DEVOLUÇÃO DE COMPRA' END,   " + chr(10) + chr(13)
	clQuery += "		D2_DOC      AS DOC,      " 			+ chr(10)+ chr(13)
	clQuery += "		F2_XFINAL   AS FINAVEND, " 			+ chr(10)+ chr(13)
	clQuery += "		D2_SERIE    AS SERIE,    " 			+ chr(10)+ chr(13)
	clQuery += "		D2_COD      AS COD,      " 			+ chr(10)+ chr(13)
	clQuery += "		D2_LOCAL AS ARMAZEN,       " 		+ chr(10)+ chr(13)
	clQuery += "		D2_CLIENTE  AS CLIFOR,   " 			+ chr(10)+ chr(13)
	clQuery += "		D2_LOJA     AS LOJA,     " 			+ chr(10)+ chr(13)
	clQuery += "		0    		AS QTDE_ENT, " 			+ chr(10)+ chr(13)	
	clQuery += "		D2_QUANT    AS QTDE_SAI, " 			+ chr(10)+ chr(13)
	clQuery += "		D2_EMISSAO  AS DTDATA,   " 			+ chr(10)+ chr(13)
	clQuery += "		D2_TES      AS TES,    	 " 			+ chr(10)+ chr(13)
	clQuery += "		''      	AS TM,    	 " 			+ chr(10)+ chr(13)
	clQuery += "		D2_CF       AS CF,       " 			+ chr(10)+ chr(13)
	clQuery += "		B1_DESC     AS DESCRI,   " 			+ chr(10)+ chr(13)
	clQuery += "		F4_FINALID    AS DESCTMTES, " 		+ chr(10)+ chr(13)
	clQuery += "		'SAIDA'         AS TIPO      " 		+ chr(10)+ chr(13)
	clQuery += " FROM 	"+RetSQLName("SD2")+" SD2 " 		+ chr(10)+ chr(13)
	clQuery += " INNER JOIN "+RetSQLName("SB1")+" SB1 ON " 	+ chr(10)+ chr(13)
	clQuery += "		D2_COD=B1_COD               " 		+ chr(10)+ chr(13)
	clQuery += " INNER JOIN "+RetSQLName("SF4")+" SF4 ON " 	+ chr(10)+ chr(13)
	clQuery += "		D2_FILIAL=F4_FILIAL      " 			+ chr(10)+ chr(13)
	clQuery += " AND		D2_TES	 =F4_CODIGO  " 			+ chr(10)+ chr(13)
	
	clQuery += " INNER JOIN "+RetSQLName("SF2")+" SF2 ON " 	+ chr(10)+ chr(13)
	clQuery += "			D2_FILIAL=F2_FILIAL      " 		+ chr(10)+ chr(13)
	clQuery += " AND		D2_DOC	 =F2_DOC  " 			+ chr(10)+ chr(13)
	clQuery += " AND		D2_SERIE =F2_SERIE  " 			+ chr(10)+ chr(13)
	clQuery += " AND		D2_CLIENTE	=F2_CLIENTE  " 		+ chr(10)+ chr(13)
	clQuery += " AND		D2_LOJA	 =F2_LOJA  " 			+ chr(10)+ chr(13)
	clQuery += " AND		D2_EMISSAO =F2_EMISSAO  " 		+ chr(10)+ chr(13)	
	clQuery += " WHERE	SD2.D_E_L_E_T_=''        " 			+ chr(10)+ chr(13)
	clQuery += " AND		SB1.D_E_L_E_T_=''    " 			+ chr(10)+ chr(13)
	clQuery += " AND		SF4.D_E_L_E_T_=''    " 			+ chr(10)+ chr(13)
	clQuery += " AND		SF2.D_E_L_E_T_=''    " 			+ chr(10)+ chr(13)	
	clQuery += " AND 	F4_ESTOQUE='S'           " 			+ chr(10)+ chr(13)
	clQuery += " AND D2_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' " 				+ chr(10)+ chr(13)
	clQuery += " AND D2_LOCAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' " 				+ chr(10)+ chr(13)
	clQuery += " AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"' " + chr(10)+ chr(13)
	clQuery += " AND D2_FILIAL = '"+XFILIAL("SD2")+"' " 	+ chr(10)+ chr(13)
			                                                                  
	clQuery += " UNION ALL                       " + chr(10)+ chr(13)
	                                                  
	clQuery += " SELECT	D3_FILIAL   AS FILIAL,   " + chr(10)+ chr(13)
	clQuery += "        'MOVIMENTOS INTERNOS' AS FINALID,  " + chr(10)+ chr(13)
	clQuery += "		D3_DOC      AS DOC,      " + chr(10)+ chr(13)
	clQuery += "		''      	AS FINAVEND, " + chr(10)+ chr(13)
	clQuery += "		''    		AS SERIE,    " + chr(10)+ chr(13)
	clQuery += "		D3_COD      AS COD,      " + chr(10)+ chr(13)
	clQuery += "                    D3_LOCAL  AS ARMAZEN, " + chr(10)+ chr(13)
	clQuery += "		''  		AS CLIFOR,   " 			+ chr(10)+ chr(13)
	clQuery += "		''     		AS LOJA,     " 			+ chr(10)+ chr(13)
	clQuery += "		QTDE_ENT= CASE WHEN D3_TM<=499 " 	+ chr(10)+ chr(13)
	clQuery += "		THEN D3_QUANT ELSE 0 END, " 		+ chr(10)+ chr(13)
	clQuery += "		QTDE_SAI= CASE WHEN D3_TM > 499 " 	+ chr(10)+ chr(13)
	clQuery += "		THEN D3_QUANT ELSE 0 END, " 		+ chr(10)+ chr(13)	
	clQuery += "		D3_EMISSAO  AS DTDATA,   " 			+ chr(10)+ chr(13)
	clQuery += "		''      	AS TES,    " 			+ chr(10)+ chr(13)	
	clQuery += "		D3_TM      	AS TM,    " 			+ chr(10)+ chr(13)	
	clQuery += "		D3_CF       AS CF,       " 			+ chr(10)+ chr(13)
	clQuery += "		B1_DESC     AS DESCRI,   " 			+ chr(10)+ chr(13)
	clQuery += "		'DESCTMTES'= CASE WHEN (D3_TM IN('999','499') " + chr(10)+ chr(13)
	clQuery += "			AND RIGHT(D3_CF,1)= '0')                  " + chr(10)+ chr(13)
	clQuery += "					THEN 'Ajuste de inventário'       " + chr(10)+ chr(13)
	clQuery += "		WHEN 	(D3_TM IN('999','499')                " + chr(10)+ chr(13)
	clQuery += "				AND RIGHT(D3_CF,1)= '1')              " + chr(10)+ chr(13)
	clQuery += "					THEN 'Requisição para prodção'    " + chr(10)+ chr(13)
	clQuery += "		WHEN 	(D3_TM IN('999','499')                " + chr(10)+ chr(13)
	clQuery += "				AND RIGHT(D3_CF,1)= '2')              " + chr(10)+ chr(13)
	clQuery += "					THEN 'Requisição de Processos'    " + chr(10)+ chr(13)
	clQuery += "		WHEN	(D3_TM IN('999','499')                " + chr(10)+ chr(13)
	clQuery += "				AND RIGHT(D3_CF,1)= '3')              " + chr(10)+ chr(13)
	clQuery += "					THEN 'Requisição Mat.Indireto'    " + chr(10)+ chr(13)
	clQuery += "		WHEN 	(D3_TM IN('999','499')                " + chr(10)+ chr(13)
	clQuery += "				AND RIGHT(D3_CF,1)= '4')              " + chr(10)+ chr(13)
	clQuery += "					THEN 'Transferencias entre armazens'   " 		+ chr(10)+ chr(13)
	clQuery += "		WHEN	(D3_TM IN('999','499')                        " 	+ chr(10)+ chr(13)
	clQuery += "				AND RIGHT(D3_CF,1) NOT IN ('0','1','2','3','4'))  " + chr(10)+ chr(13)
	clQuery += "					THEN 'Mov. automático do sistema'		  " 	+ chr(10)+ chr(13)
	clQuery += "		END,                            " 	+ chr(10)+ chr(13)
	clQuery += "		TIPO = CASE WHEN D3_TM <= '499' " 	+ chr(10)+ chr(13)
	clQuery += "		THEN 'ENTRADA' ELSE 'SAIDA' END     " 	  	+ chr(10)+ chr(13)
	clQuery += " FROM 	"+RetSQLName("SD3")+" SD3       " 	+ chr(10)+ chr(13)
	clQuery += " INNER JOIN "+RetSQLName("SB1")+" SB1 ON  " + chr(10)+ chr(13)
	clQuery += "		D3_COD=B1_COD             " 		+ chr(10)+ chr(13)
	clQuery += " WHERE	SD3.D_E_L_E_T_=''      " 			+ chr(10)+ chr(13)
	clQuery += " AND	SB1.D_E_L_E_T_=''  " 			+ chr(10)+ chr(13)
	clQuery += " AND	D3_ESTORNO =''  " 			+ chr(10)+ chr(13)
	clQuery += " AND D3_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' " 				+ chr(10)+ chr(13)
	clQuery += " AND D3_LOCAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' " 				+ chr(10)+ chr(13)
	clQuery += " AND D3_EMISSAO BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"' " + chr(10)+ chr(13)
	clQuery += " AND D3_FILIAL='"+XFILIAL("SD3")+"') AS MOVS " 	+ chr(10)+ chr(13)
	clQuery += " ORDER BY MOVS.FILIAL,MOVS.ARMAZEN,MOVS.COD,MOVS.DTDATA " + chr(10)+ chr(13)	
	
	IF SELECT("ALC") > 0                                                                                    
		dbSelectArea("ALC")
		DbCloseArea()
	ENDIF
	MemoWrite("TTESTR06.SQL",clQuery)	 	                                                               			
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,clQuery),"ALC",.F.,.T.)
	
	/*--------------------------------------------------|
	| ajusta casas decimais e datas no retorno da query |
	|--------------------------------------------------*/

	TcSetField("ALC","QTDE_SAI","N",14,2)
	TcSetField("ALC","QTDE_ENT","N",14,2)
	TcSetField("ALC","SALDO_INI","N",14,2)
	TcSetField("ALC","SALDO","N",14,2)	
	TcSetField("ALC","DTDATA","D",08,0)			
			
	dbSelectArea("ALC")
	dbGotop()
		
	While ALC->(!Eof())
	 
	 		
	 	clFilial 	:= ALC->FILIAL
	 	clArmazen	:= ALC->ARMAZEN
	 	clCod	 	:= ALC->COD
	 	alSaldoIni 	:= CalcEst(ALC->COD,ALC->ARMAZEN,MV_PAR05)
	 	nlQtdIni   	:= nlQtdIni   + alSaldoIni[1]	
	    nlSaldat	:= nlQtdIni
	 	WHILE ALC->FILIAL==clFilial .AND. ALC->ARMAZEN==clArmazen .AND. ALC->COD==clCod
	 	
	 		IF TRIM(ALC->TIPO)=="ENTRADA"
	 			nlSaldat :=(nlSaldat) + (ALC->QTDE_ENT)
	 		ELSE 
	 			nlSaldat :=(nlSaldat) - (ALC->QTDE_SAI)
	 		ENDIF	     	      		       
			DbSelectArea("TRB")
	
			RecLock("TRB",.T.)
		    	    
				TRB->DATA_INI 	:= MV_PAR05
				TRB->DATA_MOV 	:= ALC->DTDATA
				TRB->FILIAL		:= ALC->FILIAL
				TRB->SALDO_INI	:= nlQtdIni
				TRB->QTDE_SAI	:= ALC->QTDE_SAI
				TRB->QTDE_ENT	:= ALC->QTDE_ENT
				TRB->SALDO		:= 	nlSaldat
				TRB->DOC		:= ALC->DOC
				TRB->SERIE		:= ALC->SERIE
				TRB->ARMAZEN	:= ALC->ARMAZEN
				&&TRB->FINALID	:= ALC->FINALID
								
				If ALC->FINAVEND="1"  
			     	TRB->FINAVEND:="Venda Direta"
				ElseIf ALC->FINAVEND="2"  
			      	TRB->FINAVEND:="Venda PA"
				ElseIf ALC->FINAVEND="3"  
			      	TRB->FINAVEND:="Transferência"
				ElseIf ALC->FINAVEND="4"  
		      		TRB->FINAVEND:="Abastecimento"
				ElseIf ALC->FINAVEND="5"  
		      		TRB->FINAVEND:="Outras Saídas"
		  		ELSE
		  			TRB->FINAVEND:=""
				EndIf
			 
				DBSELECTAREA("ZZ1")
				DBSETORDER(1)
				IF DBSEEK(ALC->FILIAL + ALC->ARMAZEN)
					TRB->DESCARM :=ZZ1->ZZ1_DESCRI
				ENDIF
				TRB->PRODUTO :=ALC->COD
				TRB->DESC_PRO:=ALC->DESCRI
				TRB->TES     :=ALC->TES
				TRB->TM      :=ALC->TM
				IF (ALC->TM =="499") .OR. (ALC->TM =="999")
					TRB->DESC_TESTM :=ALC->DESCTMTES
				ELSE
					IF !EMPTY(ALC->TM) 					
						DBSELECTAREA("SF5")
						DBSETORDER(1)
						IF DBSEEK(ALC->FILIAL + ALC->TM )
							TRB->DESC_TESTM :=SF5->F5_TEXTO
						ENDIF
					ELSE
						TRB->DESC_TESTM :=ALC->DESCTMTES
					ENDIF				
				ENDIF
				TRB->TIPO:=ALC->TIPO					            
			MsUnlock()
	    	      
	      dbSelectArea("ALC")
	      DBSKIP()
		EndDo 
		clFilial	:=""
		clArmazen   :=""
		clCod		:=""	 
		alSaldoIni  := {}
		nlQtdIni    := 0 
		nlSaldat    := 0 
	EndDo
	
	If Select("ALC") > 0
		dbSelectArea("ALC")
		DbCloseArea()
	EndIf
	
Return

Static Function ValPerg(cPerg) 

	PutSx1(cPerg,"01","Produto de?","","","mv_ch1","C",10,00,00,"G","","SB1","","","mv_Par01","","","","","","","","","","","","","","","","",{"Codigo inicial que "+ chr(10) + chr(13) + " se deseja imprimir"},{},{},"")
	PutSx1(cPerg,"02","Produto Ate?","","","mv_ch2","C",10,00,00,"G","","SB1","","","mv_Par02","","","","","","","","","","","","","","","","",{"Codigo ate que "+ chr(10) + chr(13) + "se deseja imprimir"},{},{},"")		
	PutSx1(cPerg,"03","Armazen de?","","","mv_ch3","C",06,00,00,"G","","SZ1","","","mv_Par03","","","","","","","","","","","","","","","","",{"Armazen inicial que "+ chr(10) + chr(13) + " se deseja imprimir"},{},{},"")
	PutSx1(cPerg,"04","Armazen Ate?","","","mv_ch4","C",06,00,00,"G","","SZ1","","","mv_Par04","","","","","","","","","","","","","","","","",{"Armazen final que "+ chr(10) + chr(13) + "se deseja imprimir"},{},{},"")		
	PutSx1(cPerg,"05","Data de ?","","","mv_ch5","D",08,00,00,"G","","","","","mv_Par05","","","","","","","","","","","","","","","","",{" Informe Data inicial "+ chr(10) + chr(13) + " para impressão"},{},{},"")
	PutSx1(cPerg,"06","'Data Ate?","","","mv_ch6","D",08,00,00,"G","","","","","mv_Par06","","","","","","","","","","","","","","","","",{"Informe a data final "+ chr(10) + chr(13) + "para impressão"},{},{},"")			   		
Return
