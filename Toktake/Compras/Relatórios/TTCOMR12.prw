  
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
ฆฆฆFun็เo    ฆTTCOMR12() ฆ Autor ฆ Jackson E. de Deus   ฆ Data ฆ20/02/2013ฆฆฆ
ฆฆ+----------+------------------------------------------------------------ฆฆฆ
ฆฆฆDescri็เo ฆ Relat๓rio de Pedidos de Compras x Pr้-Notas				  ฆฆฆ
ฆฆฆ			 ฆ Projeto: 19 - Relat๓rio para Fแbrica DDC					  ฆฆฆ
ฆฆ+----------+------------------------------------------------------------ฆฆฆ
ฆฆฆUso       ฆ Compras                                              	  ฆฆฆ
ฆฆ+-----------------------------------------------------------------------+ฆฆ
ฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆ
ฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏ
/*/

User Function TTCOMR12()
	Local oReport
	If cEmpAnt == "01"
		If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
			oReport := ReportDef()
			oReport:PrintDialog()	
		EndIf
	Endif
Return

/*/
_____________________________________________________________________________
ฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆ
ฆฆ+-----------------------------------------------------------------------+ฆฆ
ฆฆฆFun็เo    ฆREPORTDEF() ฆ Autor ฆ Jackson E. de Deus  ฆ Data ฆ20/02/2013ฆฆฆ
ฆฆ+----------+------------------------------------------------------------ฆฆฆ
ฆฆฆDescri็เo ฆ FUNCAO PRINCIPAL DE IMPRESSAO   							  ฆฆฆ
ฆฆฆ			 ฆ 															  ฆฆฆ
ฆฆ+----------+------------------------------------------------------------ฆฆฆ
ฆฆฆUso       ฆ COMPRAS		                    	                      ฆฆฆ
ฆฆ+-----------------------------------------------------------------------+ฆฆ
ฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆ
ฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏ
/*/

Static Function ReportDef()

	Local oReport
	Local oSection
	Private cPerg    := "COMR12"
	
	ValPerg(cPerg)
	
	Pergunte(cPerg,.T.)
	oReport := TReport():New("Pedidos x Pr้-Notas","Relat๓rio de Pedidos x Pr้-Notas","",{|oReport| PrintReport(oReport)},"Imprimirแ o relat๓rio")
	
	/*------------------------| 		    			           
	| se็ใo 1 - principal	  | 
	|------------------------*/                                    
	
	oSection1 := TRSection():New(oReport,OemToAnsi("Pedidos x Pr้-Notas"),{"TRB"})
	
	/*----------------------------------------------------------------------------------| 		    			           
	|                       campo        alias  tํtulo       	 pic           tamanho  | 
	|----------------------------------------------------------------------------------*/
    
	TRCell():New(oSection1	,"COD"   		,"TRB"	,"CำD. PRODUTO"		,"@!"					,15)
	TRCell():New(oSection1	,"DESCRICAO"	,"TRB"	,"DESCRIวรO"		,"@!"					,30)
	TRCell():New(oSection1	,"UM"			,"TRB"	,"UM"				,"@!"					,03)	
	TRCell():New(oSection1	,"ARM_PED"		,"TRB"	,"ARMAZEM"			,"@!"					,06)		
	TRCell():New(oSection1	,"TOT_D5_D8"	,"TRB"	,"POSIวรO_ESTOQUE"	,"@E 99,999,999,999.99"	,14)		 	
	TRCell():New(oSection1	,"PEDIDO"		,"TRB"	,"PEDIDO"			,"@!"					,06)
	TRCell():New(oSection1	,"EMISSAO"		,"TRB"	,"EMISSAO_PEDIDO"	,"@!"					,08)
	TRCell():New(oSection1	,"PED_PEND"		,"TRB"	,"PENDENTE"			,"@!"					,03)		 		
	TRCell():New(oSection1	,"QTD_ENT"		,"TRB"	,"QTD ENTRADA"		,"@E 99,999,999,999.99"	,14)		 					                    
	TRCell():New(oSection1	,"PRE_NOTA"		,"TRB"	,"PRE_NOTA"			,"@!"					,03)
	TRCell():New(oSection1	,"NUM_NOTA"		,"TRB"	,"NUM_NOTA"			,"@!"					,09)                                                                                    
	TRCell():New(oSection1	,"SERIE" 		,"TRB"	,"SERIE"			,"@!"					,03)   
	TRCell():New(oSection1	,"DT_NF"		,"TRB"	,"DT_DIGITACAO"		,"@!"					,08)   
	TRCell():New(oSection1	,"ATENDIDO"		,"TRB"	,"ATENDIDO"			,"@!"					,11)   
   	TRCell():New(oSection1	,"SALDO_FIM"	,"TRB"	,"SALDO FINAL"		,"@E 99,999,999,999.99"	,14)
			
Return oReport

/*/
_____________________________________________________________________________
ฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆ
ฆฆ+-----------------------------------------------------------------------+ฆฆ
ฆฆฆFun็เo    ฆPrintReport() ฆ Autor ฆ Jackson E. de Deusฆ Data ฆ20/02/2013ฆฆฆ
ฆฆ+----------+------------------------------------------------------------ฆฆฆ
ฆฆฆDescri็เo ฆ FUNCAO RESPONSมVEL PELA IMPRESSรO DO RELATำRIO			  ฆฆฆ
ฆฆฆ			 ฆ 					   										  ฆฆฆ
ฆฆ+----------+------------------------------------------------------------ฆฆฆ
ฆฆฆUso       ฆ COMPRAS                                               	  ฆฆฆ
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
ฑฑบPrograma  ณfSelDados  บAutor  ณJackson E. de Deus บ Data ณ  20/02/2013 บฑฑ
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

AADD(_aStru	,{"COD"			,"C",15,0})
AADD(_aStru	,{"DESCRICAO"	,"C",30,0})	
AADD(_aStru	,{"UM"			,"C",03,0})
AADD(_aStru	,{"ARM_PED"		,"C",06,0})
AADD(_aStru	,{"TOT_D5_D8"	,"N",14,2})		             
AADD(_aStru	,{"PED_PEND"	,"C",03,0})		             		
AADD(_aStru	,{"QTD_ENT"		,"N",14,2})		                                   
AADD(_aStru	,{"PEDIDO"		,"C",06,0})		                                   
AADD(_aStru	,{"EMISSAO"		,"D",08,0})	                   
AADD(_aStru	,{"PRE_NOTA"	,"C",03,0})	   
AADD(_aStru	,{"NUM_NOTA"	,"C",09,0})	   
AADD(_aStru	,{"SERIE"		,"C",03,0})	   
AADD(_aStru	,{"DT_NF"   	,"D",08,0})	                      
AADD(_aStru	,{"ATENDIDO"	,"C",11,0})
AADD(_aStru	,{"SALDO_FIM"	,"N",14,2})		                                   	 

		
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
cQry += "SC7.C7_FILIAL,"                    		   		+ CRLF		// Filial
cQry += "SC7.C7_PRODUTO AS COD,"							+ CRLF		// Produto
cQry += "SB1.B1_DESC AS DESCRICAO,"							+ CRLF		// Descri็ใo
cQry += "SB1.B1_UM AS UM,"									+ CRLF		// Unidade de medida
cQry += "SC7.C7_LOCAL AS ARM_PED,"							+ CRLF		// Armazem

cQry += "("													+ CRLF		// Total armazem D00005 + D00008
cQry += "	SELECT"											+ CRLF
cQry += "		SUM(B2_QATU)" 								+ CRLF
cQry += "		FROM "+RetSQLName("SB2")+" "				+ CRLF
cQry += "		WHERE" 										+ CRLF
cQry += "			B2_LOCAL IN ('D00005','D00011') AND"	+ CRLF
cQry += "			B2_COD = SC7.C7_PRODUTO AND"			+ CRLF
cQry += "			B2_FILIAL = SC7.C7_FILIAL AND"			+ CRLF
cQry += "			D_E_L_E_T_ <> '*'"						+ CRLF
cQry += ") AS TOT_D5_D8,"							  		+ CRLF
/*		
cQry += "CASE SC7.C7_QUJE"									+ CRLF		// Sem entrada
cQry += "	WHEN '0' "										+ CRLF
cQry += "		THEN 'SIM'"									+ CRLF
cQry += "	ELSE"											+ CRLF
cQry += "		'NAO'"										+ CRLF
cQry += "END AS PED_PEND,"				  					+ CRLF
*/		
cQry += "SC7.C7_QUJE AS QTD_ENT,"							+ CRLF		// Qtd ja entregue
cQry += "SC7.C7_QTDACLA AS QTDACLA,"						+ CRLF
cQry += "SC7.C7_QUANT AS QUANT,"							+ CRLF
cQry += "SC7.C7_NUM AS PEDIDO,"								+ CRLF		// Numero do Pedido
cQry += "SC7.C7_EMISSAO AS EMISSAO,"						+ CRLF		// Dt emissao do pedido 

cQry += "CASE SF1.F1_STATUS"								+ CRLF		// Status [Pr้-Nota ou Doc classificado]
cQry += "	WHEN ''"										+ CRLF
cQry += "		THEN 'SIM'"									+ CRLF
cQry += "	ELSE"											+ CRLF
cQry += "		'NAO'"										+ CRLF
cQry += "END AS PRE_NOTA,"				   					+ CRLF

cQry += "SD1.D1_DOC AS NUM_NOTA,"							+ CRLF		// Numero da NF
cQry += "SD1.D1_SERIE AS SERIE,"							+ CRLF		// Serie da NF
cQry += "SD1.D1_DTDIGIT AS DT_NF,"							+ CRLF		// Dt da digita็ใo
/*				
cQry += "CASE SC7.C7_ENCER"									+ CRLF		// Finalizado ou parcial 
cQry += "	WHEN 'E'"										+ CRLF
cQry += "		THEN 'FINALIZADO'"							+ CRLF
cQry += "	ELSE"											+ CRLF
cQry += "		'PARCIAL'"									+ CRLF
cQry += "END ATENDIDO,"										+ CRLF
*/
cQry += "("													+ CRLF		// Saldo no armazem selecionado
cQry += "	SELECT"											+ CRLF
cQry += "		SUM(B2_QATU)" 								+ CRLF
cQry += "		FROM "+RetSQLName("SB2")+" "				+ CRLF
cQry += "		WHERE"  									+ CRLF
cQry += "			B2_LOCAL = SC7.C7_LOCAL AND" 			+ CRLF
cQry += "			B2_COD = SC7.C7_PRODUTO AND" 			+ CRLF
cQry += "			B2_FILIAL = SC7.C7_FILIAL AND"			+ CRLF
cQry += "			D_E_L_E_T_ <> '*'" 						+ CRLF
cQry += ") AS TOT_ARMAZEM"									+ CRLF

						
cQry += "FROM "+RetSQLName("SC7")+" AS SC7"					+ CRLF	

/*--------------------------------------------+
| Jun็ใo com SD1 - Itens das notas de entrada |
+--------------------------------------------*/ 
cQry += "LEFT JOIN "+RetSQLName("SD1")+" AS SD1 ON"			+ CRLF
cQry += "SC7.C7_FILIAL = SD1.D1_FILIAL AND"					+ CRLF
cQry += "SC7.C7_PRODUTO = SD1.D1_COD AND"					+ CRLF
cQry += "SC7.C7_NUM = SD1.D1_PEDIDO AND"					+ CRLF
cQry += "SC7.D_E_L_E_T_ = SD1.D_E_L_E_T_"					+ CRLF

/*------------------------------------------------+
| Jun็ใo com SF1 - Cabe็alho das notas de entrada |
+------------------------------------------------*/  
cQry += "INNER JOIN "+RetSQLName("SF1")+" AS SF1 ON"		+ CRLF
cQry += "SD1.D1_FILIAL = SF1.F1_FILIAL AND"					+ CRLF
cQry += "SD1.D1_DOC = SF1.F1_DOC AND"						+ CRLF
cQry += "SD1.D1_SERIE = SF1.F1_SERIE AND"					+ CRLF
cQry += "SD1.D1_FORNECE = SF1.F1_FORNECE AND"				+ CRLF
cQry += "SD1.D1_LOJA = SF1.F1_LOJA AND"						+ CRLF
cQry += "SD1.D_E_L_E_T_ = SF1.D_E_L_E_T_"					+ CRLF

/*--------------------------------------+
| Jun็ใo com SB1 - Cadastro de Produtos |
+--------------------------------------*/  				
cQry += "INNER JOIN "+RetSQLName("SB1")+" AS SB1 ON"		+ CRLF
cQry += "SC7.C7_PRODUTO = SB1.B1_COD AND"					+ CRLF
cQry += "SC7.D_E_L_E_T_ = SB1.D_E_L_E_T_"					+ CRLF

/*---------------------------------+
| Jun็ใo com SB2 - Saldos por Lote |
+---------------------------------*/  
cQry += "INNER JOIN "+RetSQLName("SB2")+" AS SB2 ON"		+ CRLF
cQry += "SC7.C7_PRODUTO = SB2.B2_COD AND"					+ CRLF
cQry += "SC7.C7_FILIAL = SB2.B2_FILIAL AND"					+ CRLF
cQry += "SC7.D_E_L_E_T_ = SB2.D_E_L_E_T_"					+ CRLF
 

cQry += "WHERE"												+ CRLF 
cQry += "SC7.C7_FILIAL =  '"+xFilial("SC7")+"' AND"			+ CRLF

// Emissใo De - At้
If DTOC(Mv_Par01) != ""
	cQry += "SC7.C7_EMISSAO >= '"+DTOS(Mv_Par01)+"' AND"	+ CRLF
Else                   
	dDtIni := (dDatabase - dDatabase + 1)
	cQry += "SC7.C7_EMISSAO >= '"+DTOS(dDtIni)+"' AND"		+ CRLF
EndIf             


If DTOC(Mv_Par02) != ""
	cQry += "SC7.C7_EMISSAO <= '"+DTOS(Mv_Par02)+"' AND"	+ CRLF
Else
	cQry += "SC7.C7_EMISSAO <= '"+DTOS(dDatabase)+"' AND"	+ CRLF
EndIf    
                   
// C๓digo De - At้
cQry += "SC7.C7_PRODUTO >= '" +(Mv_Par03)+ "' AND"			+ CRLF	

If Mv_Par04 != Space(15)
	cQry += "SC7.C7_PRODUTO <= '" +(Mv_Par04)+ "' AND"		+ CRLF	
Else
	cQry += "SC7.C7_PRODUTO <= 'ZZZZZZZZZZZZZZZ' AND"		+ CRLF	
EndIf


// Armaz้m De - At้
cQry += "SC7.C7_LOCAL >= '" +(Mv_Par05)+ "' AND"			+ CRLF	

If Mv_Par06 != Space(6)
	cQry += "SC7.C7_LOCAL <= '" +(Mv_Par06)+ "' AND"		+ CRLF	
Else
	cQry += "SC7.C7_LOCAL <= 'ZZZZZ' AND"					+ CRLF	
EndIf	


// Considera somente Pedido com Pr้ Nota?
// Sim ou Nใo
If Mv_Par07 == 1
	cQry += "SF1.F1_STATUS <> 'A' "							+ CRLF	
Else
	cQry += "SF1.F1_STATUS IN ('A', '') "					+ CRLF
EndIf

// Ordena
cQry += "ORDER BY SC7.C7_EMISSAO, SC7.C7_NUM"			



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
		TRB->COD		:= TSQL->COD
		TRB->DESCRICAO	:= TSQL->DESCRICAO
		TRB->UM	   		:= TSQL->UM
		TRB->ARM_PED	:= TSQL->ARM_PED
		TRB->TOT_D5_D8	:= TSQL->TOT_D5_D8
		
		/*
		TRB->PED_PEND	:= TSQL->PED_PEND  
  		Alterada regra para Pedido pendente, conforme m๓dulo Compras
  		Pendente -> C7_QUJE==0 .And. C7_QTDACLA==0
  		*/
		
		If TSQL->QTD_ENT == 0 .And. TSQL->QTDACLA == 0
			TRB->PED_PEND := 'SIM'
		Else	
			TRB->PED_PEND := 'NAO'
		EndIf
		
		TRB->QTD_ENT	:= TSQL->QTD_ENT
  		TRB->PEDIDO		:= TSQL->PEDIDO			
		TRB->EMISSAO	:= TSQL->EMISSAO
		TRB->PRE_NOTA	:= TSQL->PRE_NOTA		
		TRB->NUM_NOTA	:= TSQL->NUM_NOTA
		TRB->SERIE		:= TSQL->SERIE			
		TRB->DT_NF		:= TSQL->DT_NF
		
		/*			
		TRB->ATENDIDO	:= TSQL->ATENDIDO			
        Alterada regra para Pedido Atendido, conforme m๓dulo Compras
        Pedido Parcialmente Atendido	-> C7_QUJE <> 0 .And. C7_QUJE < C7_QUANT     
		Pedido Atendido					-> C7_QUJE >= C7_QUANT 
        */
        
        // -> Parcilmente atendido
        If TSQL->QTD_ENT <> 0 .And. TSQL->QTD_ENT < TSQL->QUANT
        	TRB->ATENDIDO := "PARCIAL"
		// -> Atendido
        ElseIf TSQL->QTD_ENT >= TSQL->QUANT
        	TRB->ATENDIDO := "FINALIZADO"
        EndIf
        
        // -> Saldo Final
        TRB->SALDO_FIM := TSQL->TOT_D5_D8 + TSQL->TOT_ARMAZEM
        
         
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
ฑฑบPrograma  ณValPerg  บAutor  ณJackson E. de Deus   บ Data ณ  20/02/2013 บฑฑ
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

	PutSx1(cPerg,'01','Data de ?'		,'Data de ?'	,'Data de ?'  		,'mv_ch0','D',8,0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'02','Data Ate ?'		,'Data Ate ?'	,'Data Ate ?'		,'mv_ch1','D',8,0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','') 		
	PutSx1(cPerg,'03','Produto de ?'	,'Produto de ?'	,'Produto de ?'		,'mv_ch2','C',15,0,0,'G','','SB1','','','mv_par03',,,'','','','','','','','','','','','','','') 	
	PutSx1(cPerg,'04','Produto Ate ?'	,'Produto Ate ?','Produto Ate ?'	,'mv_ch3','C',15,0,0,'G','','SB1','','','mv_par04',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'05','Armazem de ?'	,'Armazem de ?'	,'Armazem de ?'		,'mv_ch4','C',6,0,0,'G','','ZZ1','','','mv_par05',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'06','Armazem Ate ?'	,'Armazem Ate ?','Armazem Ate ?'	,'mv_ch5','C',6,0,0,'G','','ZZ1','','','mv_par06',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'07','Considera apenas Pr้-Nota:' 		,'Considera apenas Pr้-Nota:'	,'Considera apenas Pr้-Nota:'	,'mv_ch6','N',1,0,1,'C', "", "", "", "", "mv_par07", "Sim", "Sim", "Sim", "1", "Nใo", "Nใo", "Nใo", "", "", "", "", "", "", "", "", "")      

Return