  
/*-------------------------------|
|BIBLIOTECAS DE FUNÇÕES		 |
|-------------------------------*/  
 #INCLUDE "RWMAKE.CH"      	// 
 #INCLUDE "TOPCONN.CH"    	//
 #DEFINE CRLF CHR(13)+CHR(10)	//
/*------------------------------*/
                                            		
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦TTCOMR11() ¦ Autor ¦ Jackson E. de Deus   ¦ Data ¦11/02/2013¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Relatório de Cadastro de Produtos			  ¦¦¦
¦¦¦			 ¦ 						  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Compras                                              	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

User Function TTCOMR11()
	Local oReport
	
	If cEmpAnt == "01"
	
		If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
			oReport := ReportDef()
			oReport:PrintDialog()	
		EndIf
	EndIf
Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦REPORTDEF() ¦ Autor ¦ Jackson E. de Deus  ¦ Data ¦13.04.2011¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ FUNCAO PRINCIPAL DE IMPRESSAO   				  ¦¦¦
¦¦¦			 ¦ 						  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ COMPRAS		                                          ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function ReportDef()

	Local oReport
	Local oSection
	Private cPerg    := "COMR11"
	
	ValPerg(cPerg)
	
	Pergunte(cPerg,.T.)
	oReport := TReport():New("Cadastro de Produtos","Relatório de Cadastro de Produtos","",{|oReport| PrintReport(oReport)},"Imprimirá o cadastro de produtos")
	
	/*------------------------| 		    			           
	| seção 1 - produtos	  | 
	|------------------------*/                                    
	
	oSection1 := TRSection():New(oReport,OemToAnsi("Cadastro de Produtos"),{"TRB"})
	
	/*----------------------------------------------------------------------------------| 		    			           
	|                       campo        alias  título       	 pic           tamanho  | 
	|----------------------------------------------------------------------------------*/
    
	TRCell():New(oSection1,"COD_PROD"		,"TRB"	,"CÓD. PRODUTO"			,"@!"	,15)
	TRCell():New(oSection1,"PRODUTO"		,"TRB"	,"PRODUTO"			,"@!"	,30)	
	TRCell():New(oSection1,"COD_SECAO"		,"TRB"	,"CÓD. SEÇÃO"			,"@!"	,04)
	TRCell():New(oSection1,"SECAO"			,"TRB"	,"SEÇÃO"			,"@!"	,20)
	TRCell():New(oSection1,"COD_LINHA"		,"TRB"	,"CÓD. LINHA"			,"@!"	,03)
	TRCell():New(oSection1,"LINHA"			,"TRB"	,"LINHA"			,"@!"  	,20)
	TRCell():New(oSection1,"COD_CATEG"		,"TRB"	,"CÓD. CATEGORIA"		,"@!" 	,04)
	TRCell():New(oSection1,"CATEGORIA"		,"TRB"	,"CATEGORIA"			,"@!"  	,40)
	TRCell():New(oSection1,"COD_SGRUPO"		,"TRB"	,"CÓD. SUBGRUPO"		,"@!"  	,04)
	TRCell():New(oSection1,"SUBGRUPO"		,"TRB"	,"SUBGRUPO"			,"@!"  	,20)
	TRCell():New(oSection1,"NCM"			,"TRB"	,"NCM"				,"@R 9999.99.99"  	,10)
	TRCell():New(oSection1,"COD_CLUSTE"		,"TRB"	,"CÓD. CLUSTER"			,"@!"  	,02)
	TRCell():New(oSection1,"CLUSTER"		,"TRB"	,"CLUSTER"			,"@!"  	,20) 
	TRCell():New(oSection1,"COD_AMPLI"		,"TRB"	,"COD AMPLI"			,"@!"  	,04) 	
	TRCell():New(oSection1,"AMPLITUDE"		,"TRB"	,"AMPLITUDE"			,"@!"  	,25) 
	TRCell():New(oSection1,"COD_TPNEG"		,"TRB"	,"COD TP NEG"			,"@!"  	,04) 
	TRCell():New(oSection1,"TPNEGOCIO"		,"TRB"	,"TP NEGOCIO"			,"@!"  	,25) 	
	TRCell():New(oSection1,"COD_CONSER"		,"TRB"	,"COD CONSERV"			,"@!"  	,04)
	TRCell():New(oSection1,"CONSERV"		,"TRB"	,"CONSERVACAO"			,"@!"  	,25)
	TRCell():New(oSection1,"COD_PREP"		,"TRB"	,"COD PREP"			,"@!"  	,04)
	TRCell():New(oSection1,"PREPARO"		,"TRB"	,"PREPARO"			,"@!"  	,25)	
	TRCell():New(oSection1,"COD_TPMAQ"		,"TRB"	,"COD TP MAQ"			,"@!"  	,04)
	TRCell():New(oSection1,"TPMAQUINA"		,"TRB"	,"TIPO MAQ"			,"@!"  	,25)			
	TRCell():New(oSection1,"COD_MOLA"		,"TRB"	,"COD MOLA"			,"@!"  	,04)	                                                            
	TRCell():New(oSection1,"MOLA"			,"TRB"	,"MOLA"			  	,"@!"  	,25)	                                
	TRCell():New(oSection1,"BLQ_GERAL"		,"TRB"	,"BLQ GERAL"			,"@!"  	,03)		
	TRCell():New(oSection1,"BLQ_COMPRA"		,"TRB"	,"BLQ COMPRAS"			,"@!"  	,03)
	TRCell():New(oSection1,"UM"				,"TRB"	,"UNID. MEDIDA"		,"@!"  	,02)
	TRCell():New(oSection1,"FATCONV"		,"TRB"	,"FAT CONV"			,"@E 9999.999"  	,08)
	TRCell():New(oSection1,"SEGUM"			,"TRB"	,"SEG UM"			,"@!"  	,02)
	TRCell():New(oSection1,"CUBAGEM"		,"TRB"	,"CUBAGEM"			,"@!"  	,03) 
	TRCell():New(oSection1,"COMPRIMENT"		,"TRB"	,"COMPRIMENTO"			,"@E 999,999.99"  	,10) 	
	//TRCell():New(oSection1,"COMPRIMENT",	"TRB"," ","@!",10,/*lPixel*/.T.,/*{|| code-block de impressao }*/,/*"RIGHT"*/,,/*"RIGHT"*/)
	TRCell():New(oSection1,"ESPESSURA"		,"TRB"	,"ESPESSURA"			,"@E 999,999.99"  	,10) 
	TRCell():New(oSection1,"LARGURA"		,"TRB"	,"LARGURA"			,"@E 999,999.99"  	,10) 
	TRCell():New(oSection1,"EAN"			,"TRB"	,"EAN"				,"@!"  	,15)
   
 	//oReport:Section(1):Cell("COMPRIMENT"):SetSize(10)
			
Return oReport

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦PrintReport() ¦ Autor ¦ Jackson E. de Deus¦ Data ¦11.02.2013¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ FUNCAO RESPONSÁVEL PELA IMPRESSÃO DO RELATÓRIO		  ¦¦¦
¦¦¦			 ¦ 						  ¦¦¦
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



Static Function fSelDados()

Local cQuery
Local _aStru := {}	
Local _cArq
Local _cIndice
	      
/*-------------------------------|
| criação do arquivo de trabalho |
|-------------------------------*/
/*
AADD(_aStru,{"COD_PROD"			,"C",15,0})
AADD(_aStru,{"PRODUTO"			,"C",30,0})	
AADD(_aStru,{"COD_SECAO"		,"C",04,0})
AADD(_aStru,{"SECAO"			,"C",20,0})
AADD(_aStru,{"COD_LINHA"		,"C",03,0})
AADD(_aStru,{"LINHA"			,"C",20,0})
AADD(_aStru,{"COD_CATEG"		,"C",04,0})
AADD(_aStru,{"CATEGORIA"		,"C",40,0})
AADD(_aStru,{"COD_SGRUPO"		,"C",04,0})
AADD(_aStru,{"SUBGRUPO"			,"C",20,0})
AADD(_aStru,{"NCM"			,"C",10,0})
AADD(_aStru,{"COD_CLUSTE"		,"C",02,0})
//AADD(_aStru,{"CLUSTER"		,"TRB"	,"CLUSTER"			,"C"  	,20,0})
AADD(_aStru,{"BLQ_GERAL"		,"C",03,0})	// Converte de 1 - 2 para Sim - Nao		
AADD(_aStru,{"BLQ_COMPRA"		,"C",03,0})	// Converte de T - F para Sim - Nao		
AADD(_aStru,{"SEGUM"			,"C",02,0})
AADD(_aStru,{"FATCONV"			,"C",08,0})
AADD(_aStru,{"CUBAGEM"			,"C",03,0}) 
AADD(_aStru,{"EAN"				,"C",15,0})	

		
_cArq     := CriaTrab(_aStru,.T.)
_cIndice  := CriaTrab(Nil,.F.)
	                                            
If Sele("TRB") <> 0
	TRB->(DbCloseArea())
Endif
	
dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
IndRegua("TRB",_cIndice,"COD_PROD",,,"Selecionando Registros...")

*/
/*------------------------------------------------------------------|
| Montagem da query do cadastro de produtos			    |
|------------------------------------------------------------------*/

// 		FALTOU B1_XTNEGO -- TIPO DE NEGOCIO
//		B1_XTNEGOT  -- DESCRICAO TIPO DE NEGOCIO
	
cQuery := "SELECT" 							+ CRLF
cQuery += "			B1_COD AS COD_PROD," 			+ CRLF 						//	-- CODIGO
cQuery += "			B1_DESC AS PRODUTO," 			+ CRLF						//	-- DESCRICAO
cQuery += "			B1_XSECAO AS COD_SECAO," 		+ CRLF						//	-- COD SECAO
cQuery += "			B1_XSECAOT AS SECAO," 			+ CRLF						//	-- DESC SECAO
cQuery += "			B1_XFAMILI AS COD_LINHA," 		+ CRLF						//	-- COD LINHA
cQuery += "			B1_XFAMLIT AS LINHA," 			+ CRLF						//	-- DESC LINHA
cQuery += "			B1_GRUPO AS COD_CATEG,"			+ CRLF	   					//	-- COD CATEGORIA
cQuery += "			B1_XGRUPOT AS CATEGORIA,"		+ CRLF						//	-- DESC CATEGORIA
cQuery += "			B1_XSUBGRU AS COD_SGRUPO," 		+ CRLF						//	-- COD SUGRUPO
cQuery += "			B1_XSUBGRT AS SUBGRUPO," 		+ CRLF						//	-- DESC SUBGRUPO
cQuery += "			B1_POSIPI AS NCM," 			+ CRLF						//	-- NCM
cQuery += "			B1_XCLUST AS COD_CLUSTE," 		+ CRLF						//	-- COD CLUSTER
cQuery += "			B1_XCLUSTD AS CLUSTER," 		+ CRLF						//	-- CLUSTER
cQuery += "			B1_XAMPLI AS COD_AMPLI,"		+ CRLF						//	-- COD AMPLITUDE 
cQuery += "			B1_DSAMPLI AS AMPLITUDE,"		+ CRLF						//	-- DESC AMPLITUDE
cQuery += "			B1_XTNEGO AS COD_TPNEG,"		+ CRLF						//	-- COD TIPO NEGOCIO
cQuery += "			B1_XTNEGOT AS TPNEGOCIO,"		+ CRLF						//	-- DESC TIPO NEGOCIO
cQuery += "			B1_XCONSER AS COD_CONSER,"		+ CRLF						//	-- COD CONSERVACAO
cQuery += "			B1_DSCONS AS CONSERV,"			+ CRLF						//	-- DESC CONSERVACAO
cQuery += "			B1_XPREPAR AS COD_PREP,"		+ CRLF						//	-- COD PREPARO
cQuery += "			B1_DSPREP AS PREPARO,"			+ CRLF						//	-- DESC PREPARO
cQuery += "			B1_XTPMAQ AS COD_TPMAQ,"		+ CRLF						//	-- COD TP MAQUINA
cQuery += "			B1_DSTPMAQ AS TPMAQUINA,"		+ CRLF						//	-- DESC TP MAQUINA
cQuery += "			B1_XMOLA AS COD_MOLA,"			+ CRLF						//	-- COD MOLA
cQuery += "			B1_DSMOLA AS MOLA,"			+ CRLF						//	-- DESC MOLA

cQuery += "			CASE B1_MSBLQL "			+ CRLF						//	-- BLOQUEIO GERAL
cQuery += "				WHEN '1' "			+ CRLF 
cQuery += "					THEN 'SIM' "		+ CRLF 
cQuery += "				ELSE 'NAO' "			+ CRLF 
cQuery += "			END AS BLQ_GERAL, "			+ CRLF

cQuery += "			CASE B1_XBLQCOM "			+ CRLF						//	-- BLOQUEIO COMPRAS 
cQuery += "				WHEN 'T' "			+ CRLF 
cQuery += "					THEN 'SIM' "		+ CRLF 
cQuery += "				ELSE 'NAO' "			+ CRLF 
cQuery += "			END AS BLQ_COMPRA, "			+ CRLF
cQuery += "			B1_UM AS UM," 		   		+ CRLF						//	-- UNIDADE DE MEDIDA	
cQuery += "			B1_SEGUM AS SEGUM," 			+ CRLF						//	-- SEGUNDA UNIDADE DE MEDIDA
cQuery += "			B1_CONV AS FATCONV," 			+ CRLF						//	-- FATOR CONVERSAO

cQuery += "			CASE B1_XCBGEM "			+ CRLF						//	-- CUBAGEM  
cQuery += "				WHEN 'T' "			+ CRLF 
cQuery += "					THEN 'SIM' "		+ CRLF 
cQuery += "				ELSE 'NAO' "			+ CRLF 
cQuery += "			END AS CUBAGEM, "			+ CRLF

cQuery += "			B1_CODBAR AS EAN," 			+ CRLF						//	-- EAN - B1_VEREAN?
cQuery += "			B5_COMPR AS COMPRIMENT,"		+ CRLF						//	-- COMPRIMENTO
cQuery += "			B5_ESPESS AS ESPESSURA,"		+ CRLF						//	-- ESPESSURA
cQuery += "			B5_LARG AS LARGURA" 			+ CRLF						//	-- LARGURA


cQuery += "FROM "+RetSQLName("SB1")+" AS SB1 "

// Junção com tabela de complemento de produtos - SB5
cQuery += "INNER JOIN "+RetSQLName("SB5")+" AS SB5  "			+ CRLF
cQuery += "ON SB1.B1_COD = SB5.B5_COD "					+ CRLF

cQuery += "WHERE "                                			+ CRLF
cQuery += "			B1_COD >= '"+MV_PAR01+"' AND "		+ CRLF

// Se segundo parametro estiver vazio, preenche com ZZZZ
If Mv_Par02 == Space(15)
	Mv_Par02 := "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"
EndIf

cQuery += "			B1_COD <= '"+MV_PAR02+"' AND "		+ CRLF
cQuery += "			SB1.D_E_L_E_T_ <> '*' AND "		+ CRLF
cQuery += "			SB5.D_E_L_E_T_ <> '*' "		

cQuery := ChangeQuery(cQuery)

		                                                                		
IF SELECT("TRB") > 0
	dbSelectArea("TRB")
	DbCloseArea()
ENDIF 
	
MemoWrite("TRBSB1.SQL",cQuery) 
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

/*
TcSetField("TRB","COMPRIMENT"	,"N",9,3) 
TcSetField("TRB","ESPESSURA"	,"N",9,3)
TcSetField("TRB","LARGURA"		,"N",9,3)
*/

 				
Return
 

Static Function ValPerg(cPerg)

	PutSx1(cPerg,'01','Produto de ?'	,'','','mv_ch0','C',15,0,0,'G','','SB1','','','mv_par01',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'02','Produto Ate?'	,'','','mv_ch1','C',15,0,0,'G','','SB1','','','mv_par02',,,'','','','','','','','','','','','','','') 		

Return