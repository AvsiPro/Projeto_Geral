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
ฆฆฆFun็เo    ฆTTCOMR11() ฆ Autor ฆ Jackson E. de Deus   ฆ Data ฆ26/03/2013ฆฆฆ
ฆฆ+----------+------------------------------------------------------------ฆฆฆ
ฆฆฆDescri็เo ฆ Relat๓rio de Pedidos Empenhados							  ฆฆฆ
ฆฆฆ			 ฆ Projeto: 120 - Relat๓rio Romaneio por Pedido Empenhado	  ฆฆฆ
ฆฆ+----------+------------------------------------------------------------ฆฆฆ
ฆฆฆUso       ฆ Logํstica			                                   	  ฆฆฆ
ฆฆ+-----------------------------------------------------------------------+ฆฆ
ฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆ
ฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏ
/*/

User Function TTESTR11()
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
ฆฆฆFun็เo    ฆREPORTDEF() ฆ Autor ฆ Jackson E. de Deus  ฆ Data ฆ26/03/2013ฆฆฆ
ฆฆ+----------+------------------------------------------------------------ฆฆฆ
ฆฆฆDescri็เo ฆ FUNCAO PRINCIPAL DE IMPRESSAO   							  ฆฆฆ
ฆฆฆ			 ฆ 															  ฆฆฆ
ฆฆ+----------+------------------------------------------------------------ฆฆฆ
ฆฆฆUso       ฆ Logํstica		                    	                  ฆฆฆ
ฆฆ+-----------------------------------------------------------------------+ฆฆ
ฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆ
ฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏฏ
/*/

Static Function ReportDef()

	Local oReport
	Local oSection
	Private cPerg    := "ESTR8"
	
	ValPerg(cPerg)
	
	Pergunte(cPerg,.T.)
	oReport := TReport():New("Pedidos Empenhados","Pedidos Empenhados","",{|oReport| PrintReport(oReport)},"Imprimirแ o relat๓rio")
	
	/*------------------------| 		    			           
	| se็ใo 1 - principal	  | 
	|------------------------*/                                    
	
	oSection1 := TRSection():New(oReport,OemToAnsi("Pedidos Empenhados"),{"TRB"})
	
	/*----------------------------------------------------------------------------------| 		    			           
	|                       campo        alias  tํtulo       	 pic           tamanho  | 
	|----------------------------------------------------------------------------------*/
	TRCell():New(oSection1	,"FILIAL"  		,"TRB"	,"FILIAL"					,"@!"					,02)    
	TRCell():New(oSection1	,"PEDIDO"		,"TRB"	,"PEDIDO"					,"@!"					,06)
	TRCell():New(oSection1	,"EMISSAO"		,"TRB"	,"EMISSAO"					,"@!"					,08)
	TRCell():New(oSection1	,"COD_CLI"		,"TRB"	,"CLIENTE"					,"@!"					,06)	
	TRCell():New(oSection1	,"CLIENTE"		,"TRB"	,"NOME"						,"@!"					,15)
	TRCell():New(oSection1	,"LJ_CLI"		,"TRB"	,"LOJA"						,"@!"					,04)			
	TRCell():New(oSection1	,"FINALIDADE"	,"TRB"	,"FINALIDADE"				,"@!"					,15)	
	TRCell():New(oSection1	,"PRODUTO" 		,"TRB"	,"PRODUTO"					,"@!"					,15)
	TRCell():New(oSection1	,"DESCRICAO"	,"TRB"	,"DESCRIวรO"				,"@!"					,30)
	TRCell():New(oSection1	,"UM"			,"TRB"	,"UM"						,"@!"					,03)	
	TRCell():New(oSection1	,"ARMLOCAL"		,"TRB"	,"ARMAZEM"					,"@!"					,06)		
	TRCell():New(oSection1	,"QTD_VEN"		,"TRB"	,"QTD VENDIDA"				,"@E 99,999,999,999.99"	,14)		 					                    
	TRCell():New(oSection1	,"QTD_EMP"		,"TRB"	,"QTD EMPENHADA NO PEDIDO"	,"@E 99,999,999,999.99"	,14)		 					                    
	TRCell():New(oSection1	,"QTD_RES"		,"TRB"	,"QTD RESERVADA NO ARMAZEM"	,"@E 99,999,999,999.99"	,14) 
	TRCell():New(oSection1	,"QTD_PED"		,"TRB"	,"QTD EMPENHADA EM PEDIDOS"	,"@E 99,999,999,999.99"	,14)
	TRCell():New(oSection1	,"QTD_ATU"		,"TRB"	,"QTD ATUAL NO ARMAZEM"		,"@E 99,999,999,999.99"	,14)	
			
Return oReport

/*/
_____________________________________________________________________________
ฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆฆ
ฆฆ+-----------------------------------------------------------------------+ฆฆ
ฆฆฆFun็เo    ฆPrintReport() ฆ Autor ฆ Jackson E. de Deusฆ Data ฆ26/03/2013ฆฆฆ
ฆฆ+----------+------------------------------------------------------------ฆฆฆ
ฆฆฆDescri็เo ฆ FUNCAO RESPONSมVEL PELA IMPRESSรO DO RELATำRIO			  ฆฆฆ
ฆฆฆ			 ฆ 					   										  ฆฆฆ
ฆฆ+----------+------------------------------------------------------------ฆฆฆ
ฆฆฆUso       ฆ Logํstica                                              	  ฆฆฆ
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
ฑฑบPrograma  ณfSelDados  บAutor  ณJackson E. de Deus บ Data ณ  26/03/2013 บฑฑ
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

Local cQry := ""
Local dDtIni  
Local cXFinal	:= ""
Local _aStru	:= {}	
Local _cArq
Local _cIndice
	      
/*-------------------------------|
| cria็ใo do arquivo de trabalho |
|-------------------------------*/
AADD(_aStru	,{"FILIAL"		,"C",02,0})
AADD(_aStru	,{"PEDIDO"		,"C",06,0})
AADD(_aStru	,{"EMISSAO"		,"D",08,0})
AADD(_aStru	,{"COD_CLI"		,"C",06,0})
AADD(_aStru	,{"CLIENTE"		,"C",15,0})
AADD(_aStru	,{"LJ_CLI"		,"C",04,0})
AADD(_aStru	,{"FINALIDADE"	,"C",15,0})	// Finalidade - C5_XFINAL
AADD(_aStru	,{"PRODUTO"		,"C",15,0})
AADD(_aStru	,{"DESCRICAO"	,"C",30,0})	
AADD(_aStru	,{"UM"			,"C",03,0})
AADD(_aStru	,{"ARMLOCAL"	,"C",06,0})	  
AADD(_aStru	,{"QTD_VEN"		,"N",14,2})
AADD(_aStru	,{"QTD_EMP"		,"N",14,2})
AADD(_aStru	,{"QTD_ATU"		,"N",14,2})
AADD(_aStru	,{"QTD_RES"		,"N",14,2})
AADD(_aStru	,{"QTD_PED"		,"N",14,2})



		
_cArq     := CriaTrab(_aStru,.T.)
_cIndice  := CriaTrab(Nil,.F.)
	                                            
If Sele("TRB") <> 0
	TRB->(DbCloseArea())
Endif
	
dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
IndRegua("TRB",_cIndice,"PEDIDO",,,"Selecionando Registros...")


/*----------------------+
| 	Montagem da query	|
+-----------------------*/	
cQry += "SELECT DISTINCT "
cQry += "SC5.C5_FILIAL AS FILIAL, "
cQry += "SC5.C5_NUM AS PEDIDO, "
cQry += "SC5.C5_EMISSAO AS EMISSAO, "
cQry += "SC5.C5_XFINAL AS FINALIDADE, "
cQry += "SC5.C5_CLIENTE AS COD_CLI, "
cQry += "SC5.C5_LOJACLI AS LJ_CLI, "
cQry += "SA1.A1_NOME AS CLIENTE, " 
cQry += "SC6.C6_PRODUTO AS PRODUTO, "
cQry += "SB1.B1_DESC AS DESCRICAO, "
cQry += "SC6.C6_UM AS UM, "
cQry += "SC6.C6_LOCAL AS ARMLOCAL, "
cQry += "SC6.C6_QTDVEN AS QTD_VEN, "
cQry += "SC6.C6_QTDEMP AS QTD_EMP, "
cQry += "SB2.B2_QATU AS QTD_ATU,"
cQry += "SB2.B2_RESERVA AS QTD_RES, "
cQry += "SB2.B2_QPEDVEN AS QTD_PED "

        
cQry += "FROM "+RetSqlName("SC5")+" SC5 "

cQry += "INNER JOIN "
cQry += "( "
cQry += "	SELECT "
cQry += "			C6_FILIAL, "
cQry += "			C6_NUM, "
cQry += "			C6_CLI, "
cQry += "			C6_LOJA, "
cQry += "			C6_PRODUTO, "
cQry += "			C6_UM, "
cQry += "			C6_LOCAL, "
cQry += "			C6_NOTA, "
cQry += "			C6_QTDVEN, "
cQry += "			C6_QTDEMP, "
cQry += "			D_E_L_E_T_ "
cQry += "	FROM "+RetSqlName("SC6")+" " 
cQry += "	WHERE "
cQry += "		D_E_L_E_T_ <> '*' "
cQry += ") SC6 "
cQry += "ON "
cQry += "	SC5.C5_FILIAL	= SC6.C6_FILIAL AND "
cQry += "	SC5.C5_NUM		= SC6.C6_NUM AND "
cQry += "	SC5.C5_CLIENTE	= SC6.C6_CLI AND "
cQry += "	SC5.C5_LOJACLI	= SC6.C6_LOJA AND "
cQry += "	SC5.D_E_L_E_T_	= SC6.D_E_L_E_T_ "
    
  
cQry += "INNER JOIN " 
cQry += "  ( "
cQry += "	SELECT "
cQry += "          A1_FILIAL, "
cQry += "          A1_COD, "
cQry += "          A1_LOJA, "
cQry += "          A1_NOME, "
cQry += "          D_E_L_E_T_ "
cQry += "	FROM "+RetSqlName("SA1")+" "
cQry += "          WHERE D_E_L_E_T_ <> '*' "
cQry += "  ) SA1 "
cQry += "ON "
cQry += "  SC5.C5_CLIENTE = SA1.A1_COD AND "
cQry += "  SC5.C5_LOJACLI = SA1.A1_LOJA AND "
cQry += "  SC5.D_E_L_E_T_ = SA1.D_E_L_E_T_ "

cQry += "INNER JOIN  "
cQry += "  (  "
cQry += "    SELECT "
cQry += "          B1_COD, "
cQry += "          B1_DESC,  "
cQry += "          D_E_L_E_T_ "
cQry += "          FROM " +RetSqlName("SB1")+" "
cQry += "          WHERE D_E_L_E_T_ <> '*'   "
cQry += "  ) SB1 "
cQry += "ON  "
cQry += "  SB1.B1_COD		= SC6.C6_PRODUTO AND "
cQry += "  SB1.D_E_L_E_T_	= SC6.D_E_L_E_T_ "


cQry += "INNER JOIN "
cQry += "  ( "
cQry += "    SELECT "
cQry += "			B2_FILIAL, "
cQry += "			B2_COD, "
cQry += "			B2_LOCAL, "
cQry += "			B2_QATU,  "
cQry += "			B2_RESERVA,  "
cQry += "			B2_QPEDVEN, "
cQry += "			D_E_L_E_T_ "
cQry += "	FROM " +RetSqlName("SB2")+" "
cQry += "	WHERE D_E_L_E_T_ <> '*'  "
cQry += "  ) SB2 "
cQry += "ON  "
cQry += "	SB2.B2_FILIAL	= SC6.C6_FILIAL AND "
cQry += "	SB2.B2_LOCAL	= SC6.C6_LOCAL AND "
cQry += "	SB2.B2_COD		= SC6.C6_PRODUTO AND "
cQry += "	SB2.D_E_L_E_T_	= SC6.D_E_L_E_T_ "


cQry += "WHERE "


// Filial De - At้ 
cQry += "SC5.C5_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND"			+ CRLF


// Armaz้m De - At้
cQry += "SC6.C6_LOCAL >= '" +(Mv_Par03)+ "' AND"			+ CRLF	

If Mv_Par04 != Space(6)
	cQry += "SC6.C6_LOCAL <= '" +(Mv_Par04)+ "' AND"		+ CRLF	
Else
	cQry += "SC6.C6_LOCAL <= 'ZZZZZZ' AND"					+ CRLF	
EndIf
 
// C๓digo De - At้
cQry += "SC6.C6_PRODUTO >= '" +(Mv_Par05)+ "' AND"			+ CRLF	

If Mv_Par06 != Space(15)
	cQry += "SC6.C6_PRODUTO <= '" +(Mv_Par06)+ "' AND"		+ CRLF	
Else
	cQry += "SC6.C6_PRODUTO <= 'ZZZZZZZZZZZZZZZ' AND"		+ CRLF	
EndIf 

// Emissao De - At้
If DTOC(Mv_Par07) != ""
	cQry += "SC5.C5_EMISSAO >= '"+DTOS(Mv_Par07)+"' AND"	+ CRLF
Else                   
	dDtIni := (dDatabase - dDatabase + 1)
	cQry += "SC5.C5_EMISSAO >= '"+DTOS(dDtIni)+"' AND"		+ CRLF
EndIf  

If DTOC(Mv_Par08) != ""
	cQry += "SC5.C5_EMISSAO <= '"+DTOS(Mv_Par08)+"' AND"	+ CRLF
Else
	cQry += "SC5.C5_EMISSAO <= '"+DTOS(dDatabase)+"' AND"	+ CRLF
EndIf    
                                    
// Itens nใo faturados
cQry += "SC6.C6_NOTA = ' ' AND " + CRLF 

// Quantidade Empenhada maior que 0
cQry += "SC6.C6_QTDEMP > 0 " + CRLF                                                                 

// Ordena
cQry += "ORDER BY SC5.C5_EMISSAO, SC6.C6_LOCAL, SC6.C6_PRODUTO"			


cQry := ChangeQuery(cQry)

		                                                                		
If Select("TSQL") > 0
	TSQL->(DbCloseArea())
EndIf 
	
MemoWrite("TRBSC7.SQL",cQry) 
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQry),"TSQL",.F.,.T.)


TcSetField("TSQL","EMISSAO"		,"D",08,0)


/*---------------------------------+
|	Alimenta tabela temporแria	   |
+---------------------------------*/ 
dbSelectArea("TSQL")
dbGotop()
Do While TSQL->(!Eof())

	MsProcTxt("Pedido: " +TSQL->PEDIDO +" - " +"Produto: " +TSQL->PRODUTO)	
	
	RecLock("TRB",.T.)
		TRB->FILIAL		:= TSQL->FILIAL
		TRB->PEDIDO		:= TSQL->PEDIDO
		TRB->EMISSAO	:= TSQL->EMISSAO
		TRB->COD_CLI	:= TSQL->COD_CLI	
		TRB->CLIENTE	:= TSQL->CLIENTE
		TRB->LJ_CLI		:= TSQL->LJ_CLI
		
		// Busca Finalidade do Pedido
		dbSelectArea("ZZC")
		dbSetOrder(1)
		dbSeek(xFilial("ZZC") + AvKey(TSQL->FINALIDADE,"ZZC_CODIGO") )                  
		cXFinal 		:= ZZC->ZZC_FINAL
		TRB->FINALIDADE	:= cXFinal
		
		ZZC->(dbCloseArea())
		
		TRB->PRODUTO	:= TSQL->PRODUTO
		TRB->DESCRICAO	:= TSQL->DESCRICAO			
		TRB->UM			:= TSQL->UM
  		TRB->ARMLOCAL	:= TSQL->ARMLOCAL
		TRB->QTD_VEN	:= TSQL->QTD_VEN
		TRB->QTD_EMP	:= TSQL->QTD_EMP
		TRB->QTD_ATU	:= TSQL->QTD_ATU		 
		TRB->QTD_RES	:= TSQL->QTD_RES
		TRB->QTD_PED	:= TSQL->QTD_PED
		
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
ฑฑบPrograma  ณValPerg  บAutor  ณJackson E. de Deus   บ Data ณ  26/03/2013 บฑฑ
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
    
	PutSx1(cPerg,'01','Filial de ?'			,'Filial de ?'	,'Filial de ?'  	,'mv_ch0','C',2,0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'02','Filial Ate ?'		,'Filial Ate ?'	,'Filial Ate ?'		,'mv_ch1','C',2,0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','') 		
	PutSx1(cPerg,'03','Armazem de ?'		,'Armazem de ?'	,'Armazem de ?'		,'mv_ch2','C',6,0,0,'G','','ZZ1','','','mv_par03',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'04','Armazem Ate ?'		,'Armazem Ate ?','Armazem Ate ?'	,'mv_ch3','C',6,0,0,'G','','ZZ1','','','mv_par04',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'05','Produto de ?'		,'Produto de ?'	,'Produto de ?'		,'mv_ch4','C',15,0,0,'G','','SB1','','','mv_par05',,,'','','','','','','','','','','','','','') 	
	PutSx1(cPerg,'06','Produto Ate ?'		,'Produto Ate ?','Produto Ate ?'	,'mv_ch5','C',15,0,0,'G','','SB1','','','mv_par06',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'07','Data Emissใo De ?'	,'Data Emissใo De ?'	,'Data Emissใo De  ?'  		,'mv_ch6','D',8,0,0,'G','','','','','mv_par07',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'08','Data Emissใo Ate ?'	,'Data Emissใo Ate ?'	,'Data Emissใo Ate ?'		,'mv_ch7','D',8,0,0,'G','','','','','mv_par08',,,'','','','','','','','','','','','','','') 		
	

Return