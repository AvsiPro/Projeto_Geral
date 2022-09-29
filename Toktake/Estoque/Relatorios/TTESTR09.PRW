  
/*-------------------------------|
|BIBLIOTECAS DE FUNวีES			 |
|-------------------------------*/  
 #INCLUDE "RWMAKE.CH"     	 	// 
 #INCLUDE "TOPCONN.CH"    		//
 #DEFINE CRLF CHR(13)+CHR(10)	//
/*------------------------------*/
                                            		
/*/
_____________________________________________________________________________
ฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆ
ฆฆ+-----------------------------------------------------------------------+ฆฆ
ฆฆฆFun็เo    ฆTTESTR09() ฆ Autor ฆ Jackson E. de Deus   ฆ Data ฆ20/03/2013ฆฆฆ
ฆฆ+----------+------------------------------------------------------------ฆฆฆ
ฆฆฆDescri็เo ฆ Relat๓rio de Conferencias de Entradas por Armaz้m		  ฆฆฆ
ฆฆฆ			 ฆ Projeto: 117 - Confer๊ncia de Entradas por Armaz้m		  ฆฆฆ
ฆฆ+----------+------------------------------------------------------------ฆฆฆ
ฆฆฆUso       ฆ Estoque/Custos                                          	  ฆฆฆ
ฆฆ+-----------------------------------------------------------------------+ฆฆ
ฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆ
ฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏ
/*/

User Function TTESTR09()
	Local oReport
	If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
		oReport := ReportDef()
		oReport:PrintDialog()	
	EndIf
Return

/*/
_____________________________________________________________________________
ฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆ
ฆฆ+-----------------------------------------------------------------------+ฆฆ
ฆฆฆFun็เo    ฆREPORTDEF() ฆ Autor ฆ Jackson E. de Deus  ฆ Data 20/03/2013 ฆฆฆ
ฆฆ+----------+------------------------------------------------------------ฆฆฆ
ฆฆฆDescri็เo ฆ FUNCAO PRINCIPAL DE IMPRESSAO   							  ฆฆฆ
ฆฆฆ			 ฆ 															  ฆฆฆ
ฆฆ+----------+------------------------------------------------------------ฆฆฆ
ฆฆฆUso       ฆ Estoque/Custos                     	                      ฆฆฆ
ฆฆ+-----------------------------------------------------------------------+ฆฆ
ฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆ
ฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏ
/*/

Static Function ReportDef()

	Local oReport
	Local oSection
	Private cPerg    := "ESTR99"
	
	ValPerg(cPerg)
	
	Pergunte(cPerg,.T.)
	oReport := TReport():New("Confer๊ncias de entradas por Armaz้m","Confer๊ncias de entradas por Armaz้m","",{|oReport| PrintReport(oReport)},"Imprimirแ o relat๓rio")
	
	/*------------------------| 		    			           
	| se็ใo 1 - principal	  | 
	|------------------------*/                                    
	
	oSection1 := TRSection():New(oReport,OemToAnsi("Confer๊ncias de entradas por Armaz้m"),{"TRB"})
	
	/*----------------------------------------------------------------------------------| 		    			           
	|                       campo        alias  tํtulo       	 pic           tamanho  | 
	|----------------------------------------------------------------------------------*/
	TRCell():New(oSection1	,"FILIAL"  		,"TRB"	,"FILIAL"			,"@!"					,02)    
	TRCell():New(oSection1	,"NUM_NOTA"		,"TRB"	,"NUM_NOTA"			,"@!"					,09)                                                                                    
	TRCell():New(oSection1	,"SERIE" 		,"TRB"	,"SERIE"			,"@!"					,03)   
	TRCell():New(oSection1	,"DT_NF"		,"TRB"	,"DT_DIGITACAO"		,"@!"					,08)  
	TRCell():New(oSection1	,"COD"   		,"TRB"	,"CำD. PRODUTO"		,"@!"					,15)
	TRCell():New(oSection1	,"DESCRICAO"	,"TRB"	,"DESCRIวรO"		,"@!"					,30)
	TRCell():New(oSection1	,"QTD_ENT"		,"TRB"	,"QTD ENTRADA"		,"@E 99,999,999,999.99"	,14)		 					                    
	TRCell():New(oSection1	,"UM"			,"TRB"	,"UM"				,"@!"					,03)	
	TRCell():New(oSection1	,"ARMLOCAL"		,"TRB"	,"ARMAZEM"			,"@!"					,06)		
	TRCell():New(oSection1	,"TES"			,"TRB"	,"TES"				,"@!"					,03)			 
	TRCell():New(oSection1	,"PEDIDO"		,"TRB"	,"PEDIDO"			,"@!"					,06)
	TRCell():New(oSection1	,"EMISSAO"		,"TRB"	,"EMISSAO_PEDIDO"	,"@!"					,08)
	TRCell():New(oSection1	,"NF_ORI"		,"TRB"	,"NF_ORI"			,"@!"					,09)                                                                                    
	TRCell():New(oSection1	,"SERIE_ORI" 	,"TRB"	,"SERIE_ORI"		,"@!"					,03) 
		
Return oReport

/*/
_____________________________________________________________________________
ฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆ
ฆฆ+-----------------------------------------------------------------------+ฆฆ
ฆฆฆFun็เo    ฆPrintReport() ฆ Autor ฆ Jackson E. de Deusฆ Data ฆ20/03/2013ฆฆฆ
ฆฆ+----------+------------------------------------------------------------ฆฆฆ
ฆฆฆDescri็เo ฆ FUNCAO RESPONSมVEL PELA IMPRESSรO DO RELATำRIO			  ฆฆฆ
ฆฆฆ			 ฆ 					   										  ฆฆฆ
ฆฆ+----------+------------------------------------------------------------ฆฆฆ
ฆฆฆUso       ฆ Estoque/Custos                                          	  ฆฆฆ
ฆฆ+-----------------------------------------------------------------------+ฆฆ
ฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆ
ฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏ
/*/

Static Function PrintReport(oReport)

	Local oSection1 := oReport:Section(1)
	
	/*-----------------------------------------------------------------| 		    			           
	| sele็ใo dos dados a serem impressos/carrega o arquivo temporแrio | 
	|-----------------------------------------------------------------*/
	
	MsAguarde({|| fSelDados()},"Selecionando Itens")
	
	/*-------------------------| 		    			           
	| imprime a primeira se็ใo | 
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
	
	If Select("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
		
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSelDados  บAutor  ณJackson E. de Deus บ Data ณ  20/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Busca dados e alimenta แrea de trabalho temporแria.        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Estoque/Custos                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fSelDados()

Local cQry
Local dDtIni
Local _aStru := {}	
Local _cArq
Local _cIndice
	      
/*-------------------------------|
| cria็ใo do arquivo de trabalho |
|-------------------------------*/
AADD(_aStru	,{"FILIAL"		,"C",02,0})
AADD(_aStru	,{"COD"			,"C",15,0})
AADD(_aStru	,{"DESCRICAO"	,"C",30,0})	
AADD(_aStru	,{"QTD_ENT"		,"N",14,2})		
AADD(_aStru	,{"UM"			,"C",03,0})
AADD(_aStru	,{"ARMLOCAL"	,"C",06,0})	             	             		
AADD(_aStru	,{"TES"			,"C",03,0})                                   
AADD(_aStru	,{"NUM_NOTA"	,"C",09,0})	   
AADD(_aStru	,{"SERIE"		,"C",03,0})	   
AADD(_aStru	,{"DT_NF"   	,"D",08,0})	                      
AADD(_aStru	,{"PEDIDO"		,"C",06,0})		                                   
AADD(_aStru	,{"EMISSAO"		,"D",08,0})	                                    	 
AADD(_aStru	,{"NF_ORI"		,"C",09,0})	// Nf de Origem
AADD(_aStru	,{"SERIE_ORI"	,"C",03,0})	// Serie de Origem
		
_cArq     := CriaTrab(_aStru,.T.)
_cIndice  := CriaTrab(Nil,.F.)
	                                            
If Sele("TRB") <> 0
	TRB->(DbCloseArea())
Endif
	
dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
IndRegua("TRB",_cIndice,"COD",,,"Selecionando Registros...")


/*----------------------+
| 	Montagem da query	|
+-----------------------*/	

cQry := "SELECT	DISTINCT"									+ CRLF	 
cQry += "SD1.D1_FILIAL AS FILIAL,"             		   		+ CRLF		// Filial
cQry += "SD1.D1_COD AS COD,"								+ CRLF		// Produto
cQry += "SB1.B1_DESC AS DESCRICAO,"							+ CRLF		// Descri็ใo
cQry += "SD1.D1_QUANT AS QTD_ENT,"							+ CRLF		// Qtd
cQry += "SD1.D1_TES AS TES,"								+ CRLF		// Qtd
cQry += "SB1.B1_UM AS UM,"									+ CRLF		// Unidade de medida
cQry += "SD1.D1_LOCAL AS ARMLOCAL,"							+ CRLF		// Armazem
cQry += "SC7.C7_NUM AS PEDIDO,"								+ CRLF		// Numero do Pedido
cQry += "SC7.C7_EMISSAO AS EMISSAO,"						+ CRLF		// Emissao do Pedido
cQry += "SD1.D1_DOC AS NUM_NOTA,"							+ CRLF		// Numero da NF
cQry += "SD1.D1_SERIE AS SERIE,"							+ CRLF		// Serie da NF
cQry += "SD1.D1_DTDIGIT AS DT_NF,"							+ CRLF		// Dt da digita็ใo
cQry += "SD1.D1_NFORI AS NF_ORI,"							+ CRLF		// Nf de origem
cQry += "SD1.D1_SERIORI AS SERIE_ORI "						+ CRLF		// Serie de origem
						
cQry += "FROM "+RetSQLName("SD1")+" AS SD1"					+ CRLF	


/*------------------------------------------------+
| Jun็ใo com SF1 - Cabe็alho das notas de entrada |
+------------------------------------------------*/  
cQry += "INNER JOIN "+RetSQLName("SF1")+" AS SF1 ON"		+ CRLF
cQry += "SD1.D1_FILIAL	= SF1.F1_FILIAL		AND"			+ CRLF
cQry += "SD1.D1_DOC		= SF1.F1_DOC		AND"			+ CRLF
cQry += "SD1.D1_SERIE	= SF1.F1_SERIE		AND"			+ CRLF
cQry += "SD1.D1_TIPO	= SF1.F1_TIPO		AND"			+ CRLF
cQry += "SD1.D1_FORNECE = SF1.F1_FORNECE	AND"			+ CRLF
cQry += "SD1.D1_LOJA	= SF1.F1_LOJA		AND"			+ CRLF
cQry += "SD1.D_E_L_E_T_ = SF1.D_E_L_E_T_"					+ CRLF

/*--------------------------------------+
| Jun็ใo com SB1 - Cadastro de Produtos |
+--------------------------------------*/  				
cQry += "INNER JOIN "+RetSQLName("SB1")+" AS SB1 ON"		+ CRLF
cQry += "SD1.D1_COD 	= SB1.B1_COD AND"					+ CRLF
cQry += "SD1.D_E_L_E_T_ = SB1.D_E_L_E_T_"					+ CRLF

/*---------------------------------+
| Jun็ใo com SB2 - Saldos por Lote |
+---------------------------------*/  
cQry += "LEFT JOIN "+RetSQLName("SB2")+" AS SB2 ON"			+ CRLF
cQry += "SD1.D1_COD		= SB2.B2_COD AND"					+ CRLF
cQry += "SD1.D1_FILIAL	= SB2.B2_FILIAL AND"				+ CRLF
cQry += "SD1.D_E_L_E_T_ = SB2.D_E_L_E_T_"					+ CRLF

/*--------------------------------------------+
| Jun็ใo com SC7 - Pedidos de Compra		  |
+--------------------------------------------*/ 
cQry += "LEFT JOIN "+RetSQLName("SC7")+" AS SC7 ON"			+ CRLF
cQry += "SC7.C7_FILIAL	= SD1.D1_FILIAL	AND"				+ CRLF
cQry += "SC7.C7_PRODUTO = SD1.D1_COD	AND"				+ CRLF
cQry += "SC7.C7_NUM		= SD1.D1_PEDIDO	AND"				+ CRLF
cQry += "SC7.D_E_L_E_T_ = SD1.D_E_L_E_T_"					+ CRLF 
                                                                  

/*--------------------------------------------+
| Jun็ใo com SF4 - TES						  |
+--------------------------------------------*/ 
cQry += "INNER JOIN "+RetSQLName("SF4")+" AS SF4 ON"		+ CRLF
cQry += "SF4.F4_FILIAL	= SD1.D1_FILIAL	AND"				+ CRLF
cQry += "SF4.F4_CODIGO	= SD1.D1_TES	AND"				+ CRLF
cQry += "SF4.D_E_L_E_T_ = SD1.D_E_L_E_T_"					+ CRLF


/*--------------------------------------------+
| Jun็ใo com SD2 - Itens das NFs de saida	  |
+--------------------------------------------*/ 
cQry += "LEFT JOIN "+RetSqlName("SD2")+" AS SD2 ON"						+ CRLF
cQry += "SD2.D2_DOC = SD1.D1_NFORI"							+ CRLF
cQry += "AND SD2.D2_SERIE = SD1.D1_SERIORI"					+ CRLF
cQry += "AND SD2.D_E_L_E_T_ = SD1.D_E_L_E_T_"				+ CRLF


cQry += "WHERE"												+ CRLF

// Filial De - At้ 
cQry += "SD1.D1_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND"			+ CRLF

// Armaz้m De - At้
cQry += "SD1.D1_LOCAL >= '" +(Mv_Par03)+ "' AND"			+ CRLF	

If Mv_Par04 != Space(6)
	cQry += "SD1.D1_LOCAL <= '" +(Mv_Par04)+ "' AND"		+ CRLF	
Else
	cQry += "SD1.D1_LOCAL <= 'ZZZZZ' AND"					+ CRLF	
EndIf
 
// C๓digo De - At้
cQry += "SD1.D1_COD >= '" +(Mv_Par05)+ "' AND"			+ CRLF	

If Mv_Par06 != Space(15)
	cQry += "SD1.D1_COD <= '" +(Mv_Par06)+ "' AND"		+ CRLF	
Else
	cQry += "SD1.D1_COD <= 'ZZZZZZZZZZZZZZZ' AND"		+ CRLF	
EndIf 

// Digita็ใo De - At้
If DTOC(Mv_Par07) != ""
	cQry += "SD1.D1_DTDIGIT >= '"+DTOS(Mv_Par07)+"' AND"	+ CRLF
Else                   
	dDtIni := (dDatabase - dDatabase + 1)
	cQry += "SD1.D1_DTDIGIT >= '"+DTOS(dDtIni)+"' AND"		+ CRLF
EndIf  

If DTOC(Mv_Par08) != ""
	cQry += "SD1.D1_DTDIGIT <= '"+DTOS(Mv_Par08)+"' AND"	+ CRLF
Else
	cQry += "SD1.D1_DTDIGIT <= '"+DTOS(dDatabase)+"' AND"	+ CRLF
EndIf    

                                                                  
// Tipo de NF
cQry += "SD1.D1_TIPO IN ('N','D') AND"					+ CRLF


// TES Movimenta Estoque
cQry += "SF4.F4_ESTOQUE = 'S' AND"							+ CRLF 

// TES Movimenta Estoque
cQry += "SD1.D_E_L_E_T_ = '' "							+ CRLF 

// Ordena
cQry += "ORDER BY SD1.D1_DTDIGIT, SD1.D1_DOC"			


cQry := ChangeQuery(cQry)

		                                                                		
If Select("TSQL") > 0
	TSQL->(DbCloseArea())
EndIf 
	
MemoWrite("TRBSC7.SQL",cQry) 
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQry),"TSQL",.F.,.T.)


/*
TcSetField("TRB","COMPRIMENT"	,"N",9,3) 
TcSetField("TRB","ESPESSURA"	,"N",9,3)
TcSetField("TRB","LARGURA"		,"N",9,3)
*/
TcSetField("TSQL","EMISSAO"		,"D",08,0)
TcSetField("TSQL","DT_NF"		,"D",08,0)


//TcSetField("TSQL","TOT_D5_D8"	,"C",08,0)
//TcSetField("TSQL","QTD_ENT"		,"C",08,0)


/*---------------------------------+
|	Alimenta tabela temporแria	   |
+---------------------------------*/ 
dbSelectArea("TSQL")
dbGotop()
Do While TSQL->(!Eof())	
	
	RecLock("TRB",.T.)
		TRB->FILIAL		:= TSQL->FILIAL
		TRB->COD		:= TSQL->COD
		TRB->DESCRICAO	:= TSQL->DESCRICAO
		TRB->QTD_ENT	:= TSQL->QTD_ENT	
		TRB->UM	   		:= TSQL->UM
		TRB->ARMLOCAL	:= TSQL->ARMLOCAL
		TRB->TES		:= TSQL->TES
		TRB->NUM_NOTA	:= TSQL->NUM_NOTA
		TRB->SERIE		:= TSQL->SERIE			
		TRB->DT_NF		:= TSQL->DT_NF
  		TRB->PEDIDO		:= TSQL->PEDIDO			
		TRB->EMISSAO	:= TSQL->EMISSAO
       	TRB->NF_ORI		:= TSQL->NF_ORI
		TRB->SERIE_ORI	:= TSQL->SERIE_ORI
         
	MsUnlock() 

	    
    dbSelectArea("TSQL")
    DbSkip()
	    
	Enddo
	
If Select("TSQL") > 0
	dbSelectArea("TSQL")
	DbCloseArea()
EndIf	

 				
Return
 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValPerg  บAutor  ณJackson E. de Deus   บ Data ณ  20/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se existe a pergunta, se nใo existir, cria.       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValPerg(cPerg)
    
	PutSx1(cPerg,'01','Filial de ?'		,'Filial de ?'	,'Filial de ?'  	,'mv_ch0','C',2,0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'02','Filial Ate ?'	,'Filial Ate ?'	,'Filial Ate ?'		,'mv_ch1','C',2,0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','') 		
	PutSx1(cPerg,'03','Armazem de ?'	,'Armazem de ?'	,'Armazem de ?'		,'mv_ch2','C',6,0,0,'G','','ZZ1','','','mv_par03',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'04','Armazem Ate ?'	,'Armazem Ate ?','Armazem Ate ?'	,'mv_ch3','C',6,0,0,'G','','ZZ1','','','mv_par04',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'05','Produto de ?'	,'Produto de ?'	,'Produto de ?'		,'mv_ch4','C',15,0,0,'G','','SB1','','','mv_par05',,,'','','','','','','','','','','','','','') 	
	PutSx1(cPerg,'06','Produto Ate ?'	,'Produto Ate ?','Produto Ate ?'	,'mv_ch5','C',15,0,0,'G','','SB1','','','mv_par06',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'07','Data de ?'		,'Data de ?'	,'Data de ?'  		,'mv_ch6','D',8,0,0,'G','','','','','mv_par07',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'08','Data Ate ?'		,'Data Ate ?'	,'Data Ate ?'		,'mv_ch7','D',8,0,0,'G','','','','','mv_par08',,,'','','','','','','','','','','','','','') 		
	
Return