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
¦¦¦Funçào    ¦TTFINR05() ¦ Autor ¦ FABIO SALES		    ¦ Data ¦23.02.2011¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ CONTAS A PAGAR									          ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ FINANCEIRO                                              	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/  

User Function TTFINR05()
	Local oReport
	If cEmpAnt == "01"
		If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
			oReport := ReportDef()
			oReport:PrintDialog()	
		EndIf
	eNDiF
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
	Private cPerg    := "TTFIN05"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New("TTFINR05","Ralatorio das notas de Bloqueios","",{|oReport| PrintReport(oReport)},"Este relatorio imprimirá os titulos das notas liberadas como debito")
	
	/*-------------------------| 		    			           
	| seção dos titulo a pagar | 
	|-------------------------*/
	
	oSection1 := TRSection():New(oReport,OemToAnsi("Notas Liberadas como Debitos"),{"TRB"})
	
	/*----------------------------------------------------------------------------------| 		    			           
	|                       campo        alias  título       	 pic           tamanho  | 
	|----------------------------------------------------------------------------------*/
		
	TRCell():New(oSection1,"FILIAL"		,"TRB","FILIAL		"		,"@!"			,02)
	TRCell():New(oSection1,"TITULO"		,"TRB","TIT_DOC		"		,"@!"			,09)
	TRCell():New(oSection1,"TIPO"		,"TRB","TIPO		"		,"@!"			,04)
	TRCell():New(oSection1,"PREFIXO"	,"TRB","PREFIXO/SERIE	"	,"@!"			,03)
	TRCell():New(oSection1,"PARCELAS"	,"TRB","PARCELAS		"	,"@!"			,04)
	TRCell():New(oSection1,"FORNECE"	,"TRB","COD_FORNECE		"	,"@!"			,06)
	TRCell():New(oSection1,"LOJA"		,"TRB","LOJA			"	,"@!"			,04)
	TRCell():New(oSection1,"NOMFOR"		,"TRB","FORNECEDOR	"		,"@!"			,035)
	TRCell():New(oSection1,"NATUREZ"	,"TRB","NATUREZ		"		,"@!"			,20)		
	TRCell():New(oSection1,"DTCLAS"		,"TRB","INCLUSÃO	"		,				,08)
	TRCell():New(oSection1,"EMISSAO"	,"TRB","EMISSAO		"		,				,08)
	TRCell():New(oSection1,"VCTO"		,"TRB","VENCIMENTO	"		,				,08)
	TRCell():New(oSection1,"VENCREA"	,"TRB","VENC_REAL	"		,				,08)
	TRCell():New(oSection1,"VALOR"		,"TRB","VAL_TITULO	"		,"@E 999,999.99",18)
	TRCell():New(oSection1,"VALLIQ"		,"TRB","VALOR_LIQUIDO	"	,"@E 999,999.99",18)
	TRCell():New(oSection1,"SALDO"		,"TRB","SALDO		"		,"@E 999,999.99",18)
	TRCell():New(oSection1,"DESCONTO"	,"TRB","DESCONTO	"		,"@E 999,999.99",18)
	TRCell():New(oSection1,"MULTA"		,"TRB","MULTA		"		,"@E 999,999.99",18)
	TRCell():New(oSection1,"JUROS"		,"TRB","JUROS		"		,"@E 999,999.99",18)
	TRCell():New(oSection1,"MOTILIB"	,"TRB","MOTIVO_LIB_TIT	"	,"@!"			,70)
	TRCell():New(oSection1,"PRODUTO"	,"TRB","PRODUTO	"			,"@!"			,15)
	TRCell():New(oSection1,"DESCP"		,"TRB","DESC_PROD	"		,"@!"			,35)
	TRCell():New(oSection1,"UMNOTA"		,"TRB","UNIMED_NOTA	"		,"@!"			,03)
	TRCell():New(oSection1,"UMPC"		,"TRB","UNIMED_PC	"		,"@!"			,03)	
	TRCell():New(oSection1,"QUANTD1"	,"TRB","QUANT_NOTA		"	,"@E 999,999.99",18)
	TRCell():New(oSection1,"QUANTFIS"	,"TRB","QUANT_FISICO	"	,"@E 999,999.99",18) 
	TRCell():New(oSection1,"DIVQUANT"	,"TRB","DIVQUANT_NOTFIS	"	,"@E 999,999.99",18)
	TRCell():New(oSection1,"TOTALD1"	,"TRB","TOTAL_NOTA		"	,"@E 999,999.99",18)
	TRCell():New(oSection1,"TOTFIS"		,"TRB","TOTAL_FISICO	"	,"@E 999,999.99",18)
	TRCell():New(oSection1,"DIVTOT"		,"TRB","DIV_TOT_NOTFIS	"	,"@E 999,999.99",18)
	TRCell():New(oSection1,"TOTPED"		,"TRB","TOTAL_PC	"		,"@E 999,999.99",18)
	TRCell():New(oSection1,"DIFTOTNPC"	,"TRB","DIF_TOT_PC		"	,"@E 999,999.99",18)
	TRCell():New(oSection1,"QUANTC7"	,"TRB","QUANT_PC	"		,"@E 999,999.99",18)
	TRCell():New(oSection1,"DIF_NPC"	,"TRB","DIV.NOT_PC	"		,"@E 999,999.99",18)
	TRCell():New(oSection1,"VALORD1"	,"TRB","V.UNIT_NOTA		"	,"@E 999,999.99",18)
	TRCell():New(oSection1,"PRECOC7"	,"TRB","PRECO_PC	"		,"@E 999,999.99",18)
	TRCell():New(oSection1,"DIVPRN"		,"TRB","DIVPRN		"		,"@E 999,999.99",18)
	TRCell():New(oSection1,"DEBITO"		,"TRB","VAL. N.DEBITO"		,"@E 999,999.99",18)
			
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

	Local clQuery 

	/*-------------------------------| 		    			           
	| criação do arquivo de trabalho |
	|-------------------------------*/
	
	_aStru	:= {}
		
	AADD(_aStru,{"TITULO"	,"C",09,0})
	AADD(_aStru,{"TIPO"		,"C",04,0})
	AADD(_aStru,{"NATUREZ"	,"C",20,0})
	AADD(_aStru,{"NOMFOR"	,"C",40,0})
	AADD(_aStru,{"DESCONTO"	,"N",14,4})
	AADD(_aStru,{"MULTA"	,"N",14,4})
	AADD(_aStru,{"JUROS"	,"N",14,4})
	AADD(_aStru,{"EMISSAO"	,"D",8,0})
	AADD(_aStru,{"VCTO"		,"D",8,0})
	AADD(_aStru,{"VENCREA"	,"D",8,0})
	AADD(_aStru,{"VALOR"	,"N",14,4})
	AADD(_aStru,{"SALDO"	,"N",14,4})
	AADD(_aStru,{"VALLIQ"	,"N",14,4})
	AADD(_aStru,{"PREFIXO"	,"C",03,0})
	AADD(_aStru,{"PARCELAS"	,"C",03,0})
	AADD(_aStru,{"FORNECE"	,"C",06,0})
	AADD(_aStru,{"LOJA"		,"C",04,0})
	AADD(_aStru,{"PRODUTO"	,"C",15,0})
	AADD(_aStru,{"UMNOTA"	,"C",03,0})
	AADD(_aStru,{"UMPC"		,"C",03,0})
	AADD(_aStru,{"DESCP"	,"C",35,0})
	AADD(_aStru,{"MOTILIB"	,"C",80,0})
	AADD(_aStru,{"QUANTD1"	,"N",14,4})
	AADD(_aStru,{"QUANTFIS"	,"N",14,4})
	AADD(_aStru,{"TOTALD1"	,"N",14,4})
	AADD(_aStru,{"VALORD1"	,"N",14,4})
	AADD(_aStru,{"TOTFIS"	,"N",14,4})
	AADD(_aStru,{"DIVTOT"	,"N",14,4})
	AADD(_aStru,{"DIVQUANT"	,"N",14,4})
	AADD(_aStru,{"FILIAL"	,"C",02,0})
	AADD(_aStru,{"DTCLAS"	,"D",8,0})
	AADD(_aStru,{"QUANTC7"	,"N",14,4})
	AADD(_aStru,{"DIF_NPC"	,"N",14,4})
	AADD(_aStru,{"PRECOC7"	,"N",14,4})
	AADD(_aStru,{"DIVPRN"	,"N",14,4}) 	
	AADD(_aStru,{"TOTPED"	,"N",14,4})
	AADD(_aStru,{"DIFTOTNPC","N",14,4})
	AADD(_aStru,{"DEBITO","N",14,4}) 
	
		
   	_cArq     := CriaTrab(_aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)
	                                            
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	IndRegua("TRB",_cIndice,"TITULO",,,"Selecionando Registros...")
	                     
	/*-------------------------------------------| 		    			           
	| Montagem da query com os titulos em aberto |
	|-------------------------------------------*/

	clQuery := " SELECT 	E2_NUM      AS TITULO,		"
	clQuery += "			E2_TIPO     AS TIPO,        "
	clQuery += "			E2_NATUREZ  AS NATUREZ,     "
	clQuery += "			E2_NOMFOR   AS NOMFOR ,     "
	clQuery += "			E2_DESCONT  AS DESCONTO,    "
	clQuery += "			E2_MULTA    AS MULTA,       "
	clQuery += "			E2_JUROS    AS JUROS,       "
	clQuery += "			E2_EMISSAO  AS EMISSAO,     "
	clQuery += "			E2_VENCTO   AS VCTO,        "
	clQuery += "			E2_VENCREA  AS VENCREA,     "
	clQuery += "			E2_VALOR    AS VALOR,       "
	clQuery += "			E2_SALDO    AS SALDO,       "
	clQuery += "			E2_VALLIQ   AS VALLIQ,      "	
	clQuery += "			E2_PREFIXO  AS PREFIXO, 	"
	clQuery += "			E2_PARCELA  AS PARCELAS, 	"
	clQuery += "			E2_FORNECE  AS FORNECE, 	"
	clQuery += "			E2_LOJA     AS LOJA,		"
	clQuery += "			E2_XMOTLIB  AS MOTIlIB, 	"
	clQuery += "			D1_COD      AS CODP,        "
	clQuery += "			D1_UM       AS UMNOTA,      "
	clQuery += "			D1_QUANT    AS QUANTD1,   	"
	clQuery += "			D1_XCLASPN  AS QUANTFIS, 	"
	clQuery += "			D1_TOTAL    AS TOTALD1,   	"
	clQuery += "			D1_VUNIT	AS VALORD1,   	"
	clQuery += "			D1_XTOTPRE  AS TOTFIS, 		"
	clQuery += "			D1_XDIVTOT  AS DIVTOT, 		"
	clQuery += "			D1_XDIVER 	AS DIVQUANT,  	"
	clQuery += "			D1_FILIAL   AS FILIAL,		"
	clQuery += "			D1_DTDIGIT  AS DTCLAS,		"
	clQuery += "			C7_UM       AS UMPC,        "	
	clQuery += "			C7_QUANT	AS QUANTC7,   	"
	clQuery += "			(D1_QUANT-C7_QUANT) AS DIF_NPC, "
	clQuery += "			C7_PRECO	AS PRECOC7,             "
	clQuery += "			(D1_VUNIT -C7_PRECO)AS DIVPRNOTPC,  "
	clQuery += "			(D1_QUANT * C7_PRECO)AS TOTPED,   "
	clQuery += "			(D1_TOTAL -(D1_QUANT * C7_PRECO))AS DIFTOTNPC,   "
	clQuery += "			((D1_QUANT * D1_VUNIT) - (D1_QUANT * C7_PRECO)) AS DEBITO "		 	
	clQuery += " FROM 		"+RetSqlName("SE2")+" SE2 INNER JOIN "+RetSqlName("SD1")+" SD1 ON E2_NUM=D1_DOC AND E2_PREFIXO=D1_SERIE AND E2_FORNECE=D1_FORNECE AND E2_LOJA=D1_LOJA  "
	clQuery += " AND 		E2_MSFIL=D1_FILIAL  AND SD1.D_E_L_E_T_=''  LEFT OUTER JOIN "+RetSqlName("SC7")+" SC7 ON D1_FORNECE=C7_FORNECE AND  D1_LOJA=C7_LOJA AND D1_PEDIDO=C7_NUM AND SC7.D_E_L_E_T_='' "
	clQuery += " AND 		D1_ITEMPC=C7_ITEM AND D1_FILIAL=C7_FILIAL WHERE E2_XTIPLIB='N'  AND SE2.D_E_L_E_T_='' AND E2_EMIS1 BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'  AND  "
	clQuery += " 			E2_VENCREA BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'  AND E2_NUM BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND "
	clQuery += " 			E2_PREFIXO BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' ORDER BY D1_FILIAL,E2_NUM,E2_PREFIXO,E2_PARCELA,E2_FORNECE,E2_LOJA "
	
	IF SELECT("FIN") > 0
		dbSelectArea("FIN")
		DbCloseArea()
	ENDIF
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,clQuery),"FIN",.F.,.T.)                               
	
	/*--------------------------------------------------| 		    			           
	| ajusta casas decimais e datas no retorno da query |
	|--------------------------------------------------*/
	
	&& Ajuste dos campos de valores e datas
	
	TcSetField("FIN","DESCONTO"	,"N",14,4)
	TcSetField("FIN","MULTA"	,"N",14,4)
	TcSetField("FIN","JUROS"	,"N",14,4)	
	TcSetField("FIN","VALOR"	,"N",14,4)
	TcSetField("FIN","SALDO"	,"N",14,4)           
	TcSetField("FIN","VALLIQ"	,"N",14,4) 	
	TcSetField("FIN","QUANTD1"	,"N",14,4)	
	TcSetField("FIN","QUANTFIS"	,"N",14,4)
	TcSetField("FIN","TOTALD1"	,"N",14,4)
	TcSetField("FIN","VALORD1"	,"N",14,4)	
	TcSetField("FIN","TOTFIS"	,"N",14,4)
	TcSetField("FIN","DIVTOT"	,"N",14,4)
	TcSetField("FIN","DIVQUANT"	,"N",14,4)
	TcSetField("FIN","QUANTC7"	,"N",14,4)
	TcSetField("FIN","DIF_NPC"	,"N",14,4)
	TcSetField("FIN","TOTPED"	,"N",14,4)
	TcSetField("FIN","DIFTOTNPC","N",14,4)
	TcSetField("FIN","DEBITO"	,"N",14,4)
	TcSetField("FIN","EMISSAO"	,"D",08,0)
	TcSetField("FIN","VCTO"		,"D",08,0)
	TcSetField("FIN","DTCLAS"	,"D",08,0)
	TcSetField("FIN","VENCREA"	,"D",08,0)
			
	dbSelectArea("FIN")
	dbGotop()
		
	While FIN->(!Eof())
	     
	/*--------------------------|
	| adciona registro em banco |
	|--------------------------*/
	
		DbSelectArea("TRB")
	
	    RecLock("TRB",.T.)

		TRB->TITULO	 := FIN->TITULO
		TRB->TIPO	 := FIN->TIPO
		TRB->NATUREZ := FIN->NATUREZ
		TRB->NOMFOR	 := FIN->NOMFOR 
		TRB->DESCONTO:= FIN->DESCONTO
		TRB->MULTA	 := FIN->MULTA
		TRB->JUROS	 := FIN->JUROS
		TRB->EMISSAO := FIN->EMISSAO
		TRB->VCTO	 := FIN->VCTO
		TRB->VENCREA := FIN->VENCREA
		TRB->VALOR   := FIN->VALOR
		TRB->SALDO	 := FIN->SALDO
		TRB->VALLIQ	 := FIN->VALLIQ
		TRB->PREFIXO := FIN->PREFIXO
		TRB->PARCELAS:= FIN->PARCELAS
		TRB->FORNECE := FIN->FORNECE
		TRB->LOJA	 := FIN->LOJA
		TRB->MOTILIB := FIN->MOTIlIB
		TRB->QUANTD1 := FIN->QUANTD1
		TRB->QUANTFIS:= FIN->QUANTFIS
		TRB->TOTALD1 := FIN->TOTALD1
		TRB->VALORD1 := FIN->VALORD1
		TRB->TOTFIS  := FIN->TOTFIS
		TRB->DIVTOT  := FIN->DIVTOT
		TRB->DIVQUANT:= FIN->DIVQUANT
		TRB->FILIAL	 := FIN->FILIAL
		TRB->DTCLAS	 := FIN->DTCLAS
		TRB->QUANTC7 := FIN->QUANTC7
		TRB->DIF_NPC := FIN->DIF_NPC
		TRB->PRECOC7 := FIN->PRECOC7
		TRB->DIVPRN	 := FIN->DIVPRNOTPC 		
		TRB->TOTPED	 := FIN->TOTPED
		TRB->DIFTOTNPC:=FIN->DIFTOTNPC
		TRB->DEBITO	  :=FIN->DEBITO		
		TRB->PRODUTO  :=FIN->CODP
		DbSelectArea("SB1")
	   	DbSetOrder(1)
		If DbSeek(xFilial("SB1") + FIN->CODP)
			TRB->DESCP  :=SB1->B1_DESC
		EndIf
		TRB->UMNOTA  :=FIN->UMNOTA
		TRB->UMPC  :=FIN->UMPC			   	
	  	     	     						            	             
	 	MsUnlock()
	 	
	 	clFilial:=FIN->FILIAL; clCodfor:=FIN->FORNECE; clLoja:=FIN->LOJA; clDoc:=FIN->TITULO; clPref:=FIN->PREFIXO;clParc:=FIN->PARCELAS
	   	While FIN->FILIAL==clFilial .And. FIN->FORNECE== clCodfor .And.  FIN->LOJA==clLoja .And. FIN->TITULO==clDoc .And. FIN->PREFIXO==clPref .And. FIN->PARCELAS==clParc 	    		       	      
	    	dbSelectArea("FIN")
			DBSKIP()
		Enddo
		clFilial:=""; clCodfor:=""; clLoja:=""; clDoc:=""; clPref:="";clParc:=""	  	     
	Enddo
	
	If Select("FIN") > 0
		dbSelectArea("FIN")
		DbCloseArea()
	EndIf
	
Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦VALPERG(CPERG) ¦ Autor ¦ FABIO SALES	    ¦ Data ¦23.02.2011¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Criará a perguntas dos parametros				          ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ FINANCEIRO                                              	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/ 

Static Function ValPerg(cPerg)
	PutSx1(cPerg,'01','Inclusão   de      ?','','','mv_ch1','D',08,0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'02','Inclusão   ate     ?','','','mv_ch2','D',08,0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'03','Vencimento de      ?','','','mv_ch3','D',08,0,0,'G','','','','','mv_par03',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'04','Vencimento ate     ?','','','mv_ch4','D',08,0,0,'G','','','','','mv_par04',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'05','Titulo     de      ?','','','mv_ch5','C',09,0,0,'G','','','','','mv_par05',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'06','Titulo     ate     ?','','','mv_ch6','C',09,0,0,'G','','','','','mv_par06',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'07','Prefixo    de      ?','','','mv_ch7','C',03,0,0,'G','','','','','mv_par07',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'08','Prefixo    ate     ?','','','mv_ch8','C',03,0,0,'G','','','','','mv_par08',,,'','','','','','','','','','','','','','')	
Return
