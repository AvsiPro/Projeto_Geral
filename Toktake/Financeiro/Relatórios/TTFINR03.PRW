
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
¦¦¦Funçào    ¦TTFINR01() ¦ Autor ¦ FABIO SALES		    ¦ Data ¦30.07.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ CONTAS A PAGAR,CONTAS A RECEBER E PEDIDOS DE COMPRAS EM    ¦¦¦
¦¦¦			 ¦ ABERTO													  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ FINANCEIRO E COMPRAS                                    	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/  

User Function TTFINR03()
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
¦¦¦Funçào    ¦REPORTDEF() ¦ Autor ¦ FABIO SALES		    ¦ Data ¦30.07.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ CONTAS A PAGAR,CONTAS A RECEBER E PEDIDOS DE COMPRAS EM    ¦¦¦
¦¦¦			 ¦ ABERTO.													  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ FINANCEIRO E COMPRAS                                    	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function ReportDef()

	Local oReport
	Local oSection
	Local clProg	:="TTFINR03" 
	Local clTit 	:="(CONTAS A PAGAR,RECEBER,PEDIDOS DE COMPRAS)ABERTO OU PACIALMENTE ABERTO"
	Local clDesc	:="ESTE RELATORIO IMPRIMIRÁ AS CONTAS A PAGAR,RECEBER E OS PEDIDOS DE COMPRAS EM ABERTO"
	Private cPerg	:="TTFINR3"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New(clProg,clTit,"",{|oReport| PrintReport(oReport)},clDesc)
	
	/*-------------------------| 		    			           
	| seção dos titulo a pagar | 
	|-------------------------*/
	
	oSection1 := TRSection():New(oReport,OemToAnsi("FINANCEIRO E COMPRAS"),{"TRB"})
	
	/*----------------------------------------------------------------------------------| 		    			           
	|                       campo        alias  título       	 pic           tamanho  | 
	|----------------------------------------------------------------------------------*/	
	                                                                               
	TRCell():New(oSection1,"TIPOFIN"	,"TRB","TIPOFIN		"	,"@!"			,02)
	TRCell():New(oSection1,"FILIAL"		,"TRB","FILIAL		"	,"@!"			,02)
	TRCell():New(oSection1,"NUMERO"		,"TRB","NUMERO		"	,"@!"			,09)
	TRCell():New(oSection1,"PREFIXO"	,"TRB","PREFIXO		"	,"@!"			,03)		
	TRCell():New(oSection1,"PARCELA"	,"TRB","PARCELA		"	,"@!"			,03)
	TRCell():New(oSection1,"TIPO"		,"TRB","TIPO		"	,"@!"			,03)
	TRCell():New(oSection1,"VALOR"		,"TRB","VAL_TITULO	"	,"@E 999,999.99",16)	
	TRCell():New(oSection1,"VALLIQ"		,"TRB","VAL_PAG/REC	"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"SALDO"		,"TRB","VAL_A_PAG/REC"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"DESCONTO"	,"TRB","DESCONTO	"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"JUROS"		,"TRB","JUROS		"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"MULTA"		,"TRB","MULTA		"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"NATUREZA"	,"TRB","NATUREZA	"	,"@!"			,10) 
	TRCell():New(oSection1,"DESCRINAT"	,"TRB","DESC_NAT	"	,"@!"			,10) 	
	TRCell():New(oSection1,"FORNECE"	,"TRB","FOR/CLI		"	,"@!"			,06)	
	TRCell():New(oSection1,"LOJA"		,"TRB","LOJA		"	,"@!"			,04)
	TRCell():New(oSection1,"NOMFOR"		,"TRB","NOM_FOR/CLI " 	,"@!"			,30)
	TRCell():New(oSection1,"CONTA"		,"TRB","C_CONTABIL	"	,				,09)
	TRCell():New(oSection1,"INCLUSAO"		,"TRB","DT_INCLUSÃO		"	,			,08)			
	TRCell():New(oSection1,"EMISSAO"	,"TRB","EMISSAO		"	,				,08)
	TRCell():New(oSection1,"VENCREAL"	,"TRB","VENC_REAL/PREVISTO	"	,		,08)	
	TRCell():New(oSection1,"NUMPED"		,"TRB"  ,"PEDIDO"		,"@!"			,06)
	TRCell():New(oSection1,"CODFOR"		,"TRB"  ,"COD_FORN"		,"@!"			,06)
	TRCell():New(oSection1,"LOJFOR"		,"TRB"  ,"LOJA	"		,"@!"			,04)
	TRCell():New(oSection1,"NOMEFOR"	,"TRB"  ,"FORNECEDOR"	,"@!"			,40)		
	TRCell():New(oSection1,"CNPJ"		,"TRB"  ,"CNPJ/CPF "	,"@R 99.999.999/9999-99",14)
	TRCell():New(oSection1,"EMISSAOP"	,"TRB"  ,"EMISSAO	"	,    			,08)
	TRCell():New(oSection1,"DATLIB"		,"TRB"  ,"LIBER_PEDIDO	"	,    		,08)	
	TRCell():New(oSection1,"DATENTR"	,"TRB"  ,"DAT_ENTREGA"	,    			,08)
	TRCell():New(oSection1,"TOTAL"		,"TRB"  ,"TOTAL_PED(R$)"		,"@E 999,999,999.99",16)
	TRCell():New(oSection1,"TOTPG"		,"TRB"  ,"TOTAL_ENTRADA(R$)"	,"@E 999,999,999.99",16)
	TRCell():New(oSection1,"TOTALP"		,"TRB"  ,"SALDO_ATUAL(R$)"		,"@E 999,999,999.99",16)	
			
Return oReport

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦PrintReport() ¦ Autor ¦ FABIO SALES	    ¦ Data ¦30.07.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ FUNCAO RESPONSÁVEL PELA IMPRESSÃO DO RELATÓRIO			  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ FINANCEIRO E COMPRAS                                    	  ¦¦¦
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

	Local clDescNat
	Local alParc 
	Local clvenclec
	Local clPed

	/*-------------------------------| 		    			           
	| criação do arquivo de trabalho |
	|-------------------------------*/
	
	_aStru	:= {}
	
	AADD(_aStru,{"TIPOFIN"	,"C",20,0})		    
	AADD(_aStru,{"FILIAL"	,"C",02,0})
	AADD(_aStru,{"NUMERO"	,"C",09,0})
	AADD(_aStru,{"PREFIXO"	,"C",03,0})		
	AADD(_aStru,{"PARCELA"	,"C",03,0})
	AADD(_aStru,{"TIPO"		,"C",03,0})	
	AADD(_aStru,{"NATUREZA"	,"C",10,0})
	AADD(_aStru,{"DESCRINAT","C",35,0})	
	AADD(_aStru,{"FORNECE"	,"C",06,0})	
	AADD(_aStru,{"LOJA"		,"C",04,0})
	AADD(_aStru,{"NOMFOR"	,"C",30,0})
	AADD(_aStru,{"EMISSAO"	,"D",8,0})
	AADD(_aStru,{"INCLUSAO"	,"D",8,0})
	AADD(_aStru,{"VENCREAL"	,"D",8,0}) 
	AADD(_aStru,{"VALOR"	,"N",14,2})
	AADD(_aStru,{"DESCONTO"	,"N",14,2})
	AADD(_aStru,{"JUROS"	,"N",14,2})	
	AADD(_aStru,{"SALDO"	,"N",14,2})
	AADD(_aStru,{"MULTA"	,"N",14,2})	
	AADD(_aStru,{"VALLIQ"	,"N",14,2})
	
	AADD(_aStru,{"CODFOR"	,"C",06,0})	
	AADD(_aStru,{"LOJFOR"	,"C",04,0})
	AADD(_aStru,{"NOMEFOR"	,"C",30,0})
	AADD(_aStru,{"CNPJ"		,"C",14,0})
	AADD(_aStru,{"EMISSAOP"	,"D",8,0})
	AADD(_aStru,{"DATENTR"	,"D",8,0}) 
	AADD(_aStru,{"DATLIB"	,"D",8,0})
	AADD(_aStru,{"NUMPED"	,"C",06,0})	
	AADD(_aStru,{"TOTALP"	,"N",14,2})
	AADD(_aStru,{"TOTAL"	,"N",14,2})
	AADD(_aStru,{"TOTPG"	,"N",14,2})
	AADD(_aStru,{"CONTA"	,"C",09,0})

   	_cArq     := CriaTrab(_aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)
	                                            
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	IndRegua("TRB",_cIndice,"NUMERO",,,"Selecionando Registros...")
	                     
	/*-------------------------------------------| 		    			           
	| Montagem da query com os titulos em aberto |
	|-------------------------------------------*/

	cQuery := " SELECT 'SE2' AS TAB, 'CONTAS A PAGAR' AS TIPO,E2_MSFIL AS MSFIL,E2_PREFIXO AS PRE,E2_NUM AS NUM,E2_PARCELA AS PARC,'' AS C7_COND,'' AS C7_DATPRF,E2_USERLGI,E2_EMIS1 AS INCLUI,"
	cQuery += " E2_TIPO AS TIP,E2_NATUREZ AS NAT,E2_FORNECE AS FORCLI,E2_LOJA AS LOJA,E2_NOMFOR AS NOMFORCLI,E2_DESCONT AS DESC01,E2_MULTA AS MULT, "
	cQuery += " E2_JUROS AS JURO,E2_EMISSAO AS EMIS,E2_VENCTO AS VCTO,E2_VENCREA AS VENCREAL,E2_VALOR AS VLR,E2_SALDO AS SALD,(E2_VALOR-E2_SALDO) AS VALPAG, "
	cQuery += " '' C7_NUM,''AS TOTAL,'' AS TOTPG,'' AS TOTPED,'' AS C7_LOCAL,'' AS C7_FORNECE,'' AS C7_LOJA,''  AS A2_NOME,'' AS A2_CGC, "
	cQuery += " '' AS C7_EMISSAO,'' AS C7_DATPRF,'' AS C7_COND, A2_CONTA AS CONTA FROM "+RetSqlName("SE2")+" SE2,"+RetSqlName("SA2")+" SA2  "
	cQuery += " WHERE  E2_FORNECE=A2_COD AND E2_LOJA=A2_LOJA AND SE2.D_E_L_E_T_='' AND SA2.D_E_L_E_T_='' AND E2_SALDO <>0 "		//TITULOS ABERTOS E PACIALMENTE ABERTO
	cQuery += " AND E2_EMIS1   BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'  "
	cQuery += " AND E2_VENCREA BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'  "
	cQuery += " AND E2_NUM     BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "
	cQuery += " AND E2_PREFIXO BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'  "
	cQuery += " AND A2_NATUREZ BETWEEN '"+MV_PAR13+"' AND '"+MV_PAR14+"'  "
	cQuery += " AND A2_CONTA   BETWEEN '"+MV_PAR17+"' AND '"+MV_PAR18+"'  "
	cQuery += " AND E2_MSFIL   BETWEEN '"+MV_PAR21+"' AND '"+MV_PAR22+"'  "
	//cQuery += " AND E2_EMIS1   BETWEEN '"+MV_PAR21+"' AND '"+MV_PAR22+"'  "
	
	cQuery += " UNION "
		                                                         
	cQuery += " SELECT 'SE1' AS TAB,'CONTAS A RECEBER' AS TIPO,E1_MSFIL AS MSFIL,E1_PREFIXO AS PRE,E1_NUM AS NUM,E1_PARCELA AS PARC,'' AS C7_COND,'' AS C7_DATPRF,'' E2_USERLGI,E1_EMISSAO AS INCLUI, "
	cQuery += " E1_TIPO AS TIP,E1_NATUREZ AS NAT,E1_CLIENTE AS FORCLI,E1_LOJA AS LOJA,E1_NOMCLI AS NOMFORCLI,E1_DESCONT AS DESC01,E1_MULTA AS MULT, "
	cQuery += " E1_JUROS AS JURO,E1_EMISSAO AS EMIS,E1_VENCTO AS VCTO,E1_VENCREA AS VENCREAL,E1_VALOR AS VLR,E1_SALDO AS SALD,(E1_VALOR-E1_SALDO)AS VALPAG, 
	cQuery += " E1_PEDIDO AS C7_NUM,''AS TOTAL,'' AS TOTPG,'' AS TOTPED,'' AS C7_LOCAL,'' AS C7_FORNECE,'' AS C7_LOJA,''  AS A2_NOME,'' AS A2_CGC, "
	cQuery += " '' AS C7_EMISSAO,'' AS C7_DATPRF,'' AS C7_COND, A1_CONTA AS CONTA FROM "+RetSqlName("SE1")+" SE1,"+RetSqlName("SA1")+" SA1  "
	cQuery += " WHERE E1_CLIENTE=A1_COD AND E1_LOJA=A1_LOJA AND SE1.D_E_L_E_T_='' AND SA1.D_E_L_E_T_='' AND E1_SALDO <>0 "		//TITULOS ABERTOS E PACIALMENTE ABERTO
	cQuery += " AND E1_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'  "
	cQuery += " AND E1_VENCREA BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'  "
	cQuery += " AND E1_NUM     BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "
	cQuery += " AND E1_PREFIXO BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'  "
	cQuery += " AND A1_NATUREZ BETWEEN '"+MV_PAR15+"' AND '"+MV_PAR16+"'  "
	cQuery += " AND A1_CONTA   BETWEEN '"+MV_PAR19+"' AND '"+MV_PAR20+"'  "
	cQuery += " AND E1_MSFIL   BETWEEN  '"+MV_PAR21+"' AND '"+MV_PAR22+"' "
	
	cQuery += " UNION "
	
	cQuery += " SELECT 'SC7' AS TAB,'PEDIDOS DE COMPRAS' AS TIPO,C7_FILIAL AS MSFIL,'' AS PRE,'' AS NUM,'' AS PARC,C7_COND,C7_DATPRF,'' AS E2_USERLGI,'' AS INCLUI,'' AS TIP,A2_NATUREZ AS NAT,'' AS FORCLI,'' AS LOJA, "
	cQuery += " '' AS NOMFORCLI,'' AS DESC01,'' AS MULT, '' AS JURO,'' AS EMIS,'' AS VCTO,'' AS VENCREAL,'' AS VLR,'' AS SALD,'' AS VALPAG,
	cQuery += " C7_NUM ,SUM(C7_TOTAL) AS TOTAL,SUM(C7_QUJE * C7_PRECO)AS TOTPG,SUM((C7_QUANT-C7_QUJE)*C7_PRECO) AS TOTPED,C7_LOCAL,C7_FORNECE,C7_LOJA,A2_NOME,A2_CGC,C7_EMISSAO,C7_DATPRF,C7_COND,'' AS CONTA "
	cQuery += " FROM "+RetSQLName("SC7")+" AS SC7 INNER JOIN "+RetSQLName("SA2")+" AS SA2 ON	"
	cQuery += " A2_COD=C7_FORNECE AND A2_LOJA=C7_LOJA AND SC7.D_E_L_E_T_=SA2.D_E_L_E_T_ "	
	cQuery += " WHERE (C7_DATPRF BETWEEN '"+DTOS(MV_PAR09)+"' AND '"+DTOS(MV_PAR10)+"')	" 
	cQuery += " AND (C7_NUM BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"') 				"
	cQuery += " AND A2_NATUREZ BETWEEN '"+MV_PAR13+"' AND '"+MV_PAR14+"'  "
	cQuery += " AND C7_FILIAL   BETWEEN  '"+MV_PAR21+"' AND '"+MV_PAR22+"'  		"
	cQuery += " AND C7_CONAPRO <>'B' AND C7_QUJE < C7_QUANT AND C7_RESIDUO = ' '	"
	cQuery += " AND C7_ENCER='' AND SC7.D_E_L_E_T_='' AND SA2.D_E_L_E_T_=''			"
	cQuery += " GROUP BY C7_FILIAL,C7_NUM,C7_LOCAL,C7_FORNECE,C7_LOJA,A2_NOME, 		"
	cQuery += " A2_CGC,A2_NATUREZ,C7_EMISSAO,C7_DATPRF,C7_COND ORDER BY C7_NUM "
			
	
	IF SELECT("FIN") > 0
		dbSelectArea("FIN")
		DbCloseArea()
	ENDIF
	MemoWrite("TTFINR03.SQL",cQuery)
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"FIN",.F.,.T.)
	
	/*--------------------------------------------------| 		    			           
	| ajusta casas decimais e datas no retorno da query |
	|--------------------------------------------------*/ 	
	
	TcSetField("FIN","TOTPED","N",14,2)
	TcSetField("FIN","TOTAL","N",14,2)
	TcSetField("FIN","TOTPG","N",14,2)
	TcSetField("FIN","SALD 	","N",14,2)
	TcSetField("FIN","VALPAG","N",14,2)	
	TcSetField("FIN","DESC01","N",14,2)
	TcSetField("FIN","JURO ","N",14,2)
	TcSetField("FIN","MULT ","N",14,2)
	TcSetField("FIN","EMIS"	,"D",08,0)
	TcSetField("FIN","VENCREAL","D",08,0)
	TcSetField("FIN","C7_EMISSAO","D",08,0)
	TcSetField("FIN","C7_DATPRF","D",08,0)
	TcSetField("FIN","INCLUI","D",08,0)	
			
	dbSelectArea("FIN")
	dbGotop()
		
	While FIN->(!Eof())
	 
		DBSELECTAREA("SED")
		DBSETORDER(1)
		IF DBSEEK(XFILIAL("SED")+FIN->NAT)
		   clDescNat:=SED->ED_DESCRIC 
		ENDIF 	      		       
		DbSelectArea("TRB")
 		
 		IF !EMPTY(FIN->C7_DATPRF)
			alParc := CONDICAO(FIN->TOTPED,FIN->C7_COND,,FIN->C7_DATPRF)
			clvenclec:=alParc[1,1]
		Else
			clvenclec :=FIN->VENCREAL  	
		EndIf  
		
		IF FIN->TAB=="SE2"
			DBSELECTAREA("SD1")
			DBSETORDER(1)
			DBSEEK(FIN->MSFIL + FIN->NUM + FIN->PRE + FIN->FORCLI + FIN->LOJA)
			clPed:=SD1->D1_PEDIDO			
		ENDIF
		
	     
	/*--------------------------|
	| adciona registro em banco |
	|--------------------------*/
	
	    RecLock("TRB",.T.)	
	        
	    	TRB->TIPOFIN	:= FIN->TIPO
	     	TRB->FILIAL		:= FIN->MSFIL
	     	TRB->NUMERO		:= FIN->NUM
	     	TRB->PREFIXO	:= FIN->PRE
	      	TRB->PARCELA	:= FIN->PARC
	      	TRB->TIPO		:= FIN->TIP
	      	TRB->NATUREZA	:= FIN->NAT 
	      	TRB->DESCRINAT	:= clDescNat
	        TRB->FORNECE	:= FIN->FORCLI	        
	        TRB->LOJA		:= FIN->LOJA
	        TRB->NOMFOR		:= FIN->NOMFORCLI       
	        TRB->EMISSAO	:= FIN->EMIS
	        TRB->VENCREAL	:= clvenclec
	        TRB->VALOR 		:= FIN->VLR
	        TRB->SALDO 		:= FIN->SALD
	        TRB->VALLIQ		:= FIN->VALPAG 	        
	        TRB->MULTA 		:= FIN->MULT 
	        TRB->DESCONTO 	:= FIN->DESC01
	        TRB->JUROS		:= FIN->JURO 		        
	    	TRB->TOTALP		:= FIN->TOTPED
	    	TRB->TOTAL		:= FIN->TOTAL	        	      	
	    	TRB->TOTPG		:= FIN->TOTPG
	    	IF FIN->TAB=="SC7" .OR. FIN->TAB=="SE1"	        	      		        	      	
	      		TRB->NUMPED		:= FIN->C7_NUM
	     	ELSE
	     		TRB->NUMPED		:= clPed
	     	ENDIF
		    TRB->CODFOR		:= FIN->C7_FORNECE
	    	TRB->LOJFOR		:= FIN->C7_LOJA
	        TRB->NOMEFOR	:= FIN->A2_NOME
	        TRB->CNPJ		:= FIN->A2_CGC
	        TRB->EMISSAOP	:= FIN->C7_EMISSAO
	        TRB->DATENTR	:= FIN->C7_DATPRF
	        TRB->CONTA		:= FIN->CONTA  
	        TRB->INCLUSAO   := FIN->INCLUI 	        	        
	        TRB->DATLIB  	:= DataLib(FIN->MSFIL,FIN->C7_NUM)
	            
	      MsUnlock()
	      clDescNat:=""
	      clPed:=""
	    	      
	      dbSelectArea("FIN")
	      DBSKIP()  
	Enddo
	
	If Select("FIN") > 0
		dbSelectArea("FIN")
		DbCloseArea()
	EndIf
	
Return

/*--------------------------------------------------------------------------\
|   função utilizada para retornar a data da liberação do pedido de compra  |
|---------------------------------------------------------------------------*/

Static Function DataLib(Filial,Pedido)

	Local dlData
	Local datPed:=""
	
	datped:=" SELECT TOP 1 CR_DATALIB   FROM "+RetSqlName("SCR")+" AS SCR "
	datPed+=" WHERE CR_NUM='"+Pedido+"' AND CR_FILIAL ='"+Filial+"'   "
	datPed+=" AND SCR.D_E_L_E_T_ ='' AND CR_NIVEL ='01' "
	
	If Select("DATPC") > 0
		DbSelectArea("DATPC")
		DbCloseArea()
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,datPed),"DATPC",.F.,.T.)
	
	TcSetField("DATPC","CR_DATALIB","D",08,0)
	
	dbSelectArea("DATPC")
	If DATPC->(!Eof())
		dlData := DATPC->CR_DATALIB
	Else
		dlData:=Ctod(Space(8))
	Endif
	 
Return(dlData)

/*-------------------------------------\
|   Criação dos parâmetro de perguntas |
|-------------------------------------*/
		
Static Function ValPerg(cPerg)

	PutSx1(cPerg,'01','Digitação    De  ?','','','mv_ch1','D',08,0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'02','Digitação    Ate ?','','','mv_ch2','D',08,0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')
	
	PutSx1(cPerg,'03','Vencimento De  ?','','','mv_ch3','D',08,0,0,'G','','','','','mv_par03',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'04','Vencimento Ate ?','','','mv_ch4','D',08,0,0,'G','','','','','mv_par04',,,'','','','','','','','','','','','','','')
	
	PutSx1(cPerg,'05','Titutlo    De  ?','','','mv_ch5','C',09,0,0,'G','','','','','mv_par05',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'06','Titutlo    Ate ?','','','mv_ch6','C',09,0,0,'G','','','','','mv_par06',,,'','','','','','','','','','','','','','')
	
	PutSx1(cPerg,'07','Prefixo    De  ?','','','mv_ch7','C',03,0,0,'G','','','','','mv_par07',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'08','Prefixo    Ate ?','','','mv_ch8','C',03,0,0,'G','','','','','mv_par08',,,'','','','','','','','','','','','','','')
	
	PutSx1(cPerg,'09','Entrega 	  de  ?','','','mv_ch9','D',8,0,0,'G','','','','','mv_par09',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'10','Entrega    Ate ?','','','mv_chA','D',8,0,0,'G','','','','','mv_par10',,,'','','','','','','','','','','','','','')
   
	PutSx1(cPerg,'11','Pedido     de  ?','','','mv_chB','C',06,0,0,'G','','','','','mv_par11',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'12','Pedido     Ate ?','','','mv_chC','C',06,0,0,'G','','','','','mv_par12',,,'','','','','','','','','','','','','','')
	
	PutSx1(cPerg,'13','NatuFor   de  ?','','','mv_chD','C',10,0,0,'G','','SED','','','mv_par13',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'14','NatuFor   Ate ?','','','mv_chE','C',10,0,0,'G','','SED','','','mv_par14',,,'','','','','','','','','','','','','','')
	
	PutSx1(cPerg,'15','NatuCli   de  ?','','','mv_chF','C',10,0,0,'G','','SED','','','mv_par15',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'16','NatuCli   Ate ?','','','mv_chG','C',10,0,0,'G','','SED','','','mv_par16',,,'','','','','','','','','','','','','','')
	
	PutSx1(cPerg,'17','Contafor   de  ?','','','mv_chH','C',10,0,0,'G','','CT1','','','mv_par17',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'18','Contafor   Ate ?','','','mv_chI','C',10,0,0,'G','','CT1','','','mv_par18',,,'','','','','','','','','','','','','','')
	
	PutSx1(cPerg,'19','Contacli   de  ?','','','mv_chJ','C',10,0,0,'G','','CT1','','','mv_par19',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'20','Contacli   Ate ?','','','mv_chL','C',10,0,0,'G','','CT1','','','mv_par20',,,'','','','','','','','','','','','','','')
	
	PutSx1(cPerg,'21','Filial   de   ?','','','mv_chM','C',02,0,0,'G','','SM0','','','mv_par21',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'22','Filial   Ate  ?','','','mv_chN','C',02,0,0,'G','','SM0','','','mv_par22',,,'','','','','','','','','','','','','','')      
	
Return
