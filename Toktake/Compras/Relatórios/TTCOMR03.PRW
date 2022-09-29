  
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
¦¦¦Funçào    ¦TTCOMR03() ¦ Autor ¦ FABIO SALES		    ¦ Data ¦18.06.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ RELATÓRIO DE TODAS AS NOTAS FISCAIAS DE ENTRADA		      ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ COMPRAS                                          	  	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

User Function TTCOMR03()
	Local oReport
	If cEmpAnt == "01"
		If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
			oReport := ReportDef()
			oReport:PrintDialog()	
		EndIf
	EndIF
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
¦¦¦Uso       ¦ FATURAMENTO                                          	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function REPORTDEF()

	Local oReport
	Local oSection
	Local clDesc	:= "ESTE RELATORIO IRA IMPRIMIR TODAS AS NOTAS FISCAIS DE ENTRADA"
	Local clTit		:= "RELATORIO DE ENTRADAS"
	Private cPerg	:= "TTFATR02"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New("TTCOMR03",clTit,"",{|oReport| PrintReport(oReport)},clDesc)
	
	/*------------------------| 		    			           
	| seção das notas fiscais | 
	|------------------------*/
	
	oSection1 := TRSection():New(oReport,OemToAnsi("Notas de Entrada"),{"TRB"})
	
	/*----------------------------------------------------------------------------------| 		    			           
	|                       campo        alias  título       	 pic           tamanho  | 
	|----------------------------------------------------------------------------------*/

    
	TRCell():New(oSection1,"TIPO"		,"TRB","TIPO	"		,"@!"			,10)
	TRCell():New(oSection1,"FILIAL"		,"TRB","FILIAL	"		,"@!"			,02)
	TRCell():New(oSection1,"NOTA"		,"TRB","NOTA	"		,"@!"			,09)
	TRCell():New(oSection1,"SERIE"		,"TRB","SERIE	"		,"@!"			,03)
	TRCell():New(oSection1,"CONTROLE"	,"TRB"	,"CTRL DE ETIQUETA	","@!"		,10)		
	TRCell():New(oSection1,"EMISSAO"	,"TRB","EMISSAO	"		,    			,08)
	TRCell():New(oSection1,"DAT_DIGIT"	,"TRB","DATA_DIGIT"		,    			,08)
	TRCell():New(oSection1,"COD_FOR"	,"TRB","COD_FORN"		,"@!"			,06)
	TRCell():New(oSection1,"FORNECE"	,"TRB","FORNECEDOR	"	,"@!"			,40)	
	TRCell():New(oSection1,"LOJA"		,"TRB","LOJA	"		,"@!"			,04)
	TRCell():New(oSection1,"CNPJ"		,"TRB","CNPJ/CPF "		,"@R 99.999.999/9999-99",14)
	TRCell():New(oSection1,"NATUREZA"	,"TRB","NATUREZA"		,"@!"			,10)	
	TRCell():New(oSection1,"ESTADO"		,"TRB","ESTADO	"		,"@!"			,02)
	TRCell():New(oSection1,"PRODUTO"	,"TRB","COD_PROD"		,"@!"			,15)
	TRCell():New(oSection1,"DESCPRO"	,"TRB","DESC_PROD"		,"@!"			,30)
	TRCell():New(oSection1,"UNI_MED"	,"TRB","UNI_MED"		,"@!"			,02)
	TRCell():New(oSection1,"SUBGRUP"	,"TRB","SUB_GRUPO"		,"@!"			,04)
	TRCell():New(oSection1,"GRUPTRIB"	,"TRB","GRUP_TRIBUT"	,"@!"			,06)
	TRCell():New(oSection1,"LOCALPD"	,"TRB","ARMAZEM	"		,"@!"			,06)
	TRCell():New(oSection1,"DESCARME"	,"TRB","DESC_ARMAZ_ENT"	,"@!"			,30)		
	TRCell():New(oSection1,"TES"		,"TRB","TES		"		,"@!"			,03)
	TRCell():New(oSection1,"CFOP "		,"TRB","CFOP	"		,"@!"			,05)
	TRCell():New(oSection1,"QTDE"		,"TRB","QTDE	"		,"@E 999,999.99",16)
	TRCell():New(oSection1,"PR_UNIT"	,"TRB","PR_UNIT	"		,"@E 999,999.99",16)
	TRCell():New(oSection1,"PRCCOM"		,"TRB","PR_COMPRA"		,"@E 999,999.99",16)
	TRCell():New(oSection1,"TOTAL"		,"TRB","TOT_MERC"		,"@E 999,999.99",16)
	TRCell():New(oSection1,"DESCONTO"	,"TRB","DESCONTO"		,"@E 999,999.99",16)
	TRCell():New(oSection1,"FRETE"		,"TRB","FRETE	"		,"@E 999,999.99",16)
	TRCell():New(oSection1,"SEGURO"		,"TRB","SEGURO	"		,"@E 999,999.99",16)
	TRCell():New(oSection1,"DESPESAS"	,"TRB","DESPESAS"		,"@E 999,999.99",16)
	TRCell():New(oSection1,"VALTOT"		,"TRB","VALBRUT"		,"@E 999,999.99",16)
	TRCell():New(oSection1,"ALIQICM"	,"TRB","ALIQ_ICM "		,"@E 999,999.99",16)			
	TRCell():New(oSection1,"ICMS"		,"TRB","DESTACADO	"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"ICMS_ST"	,"TRB","ICMS_ST	"		,"@E 999,999.99",16) 
	
	TRCell():New(oSection1,"ICMSTRIB"	,"TRB"	,"ICMS_TRIBUTADO","@E 999,999.99",16)
	TRCell():New(oSection1,"ICMSISEN"	,"TRB"	,"ICMS_ISENTO	","@E 999,999.99",16)
	TRCell():New(oSection1,"ICMSOUTR"	,"TRB"	,"ICMS_OUTROS	","@E 999,999.99",16)
	
	TRCell():New(oSection1,"IMP_IMP"	,"TRB","IMP.IMPOTACAO "	,"@E 999,999.99",16)			
	TRCell():New(oSection1,"VALIRRF"	,"TRB","VALIRRF	"		,"@E 999,999.99",16)
	TRCell():New(oSection1,"VALIPI"		,"TRB","VALIPI	"		,"@E 999,999.99",16)
	TRCell():New(oSection1,"VALISS"		,"TRB","VALISS "		,"@E 999,999.99",16)			
	TRCell():New(oSection1,"VALINS"		,"TRB","VALISNS	"		,"@E 999,999.99",16)		
	TRCell():New(oSection1,"PIS"   		,"TRB","PIS		"		,"@E 999,999.99",16)
	TRCell():New(oSection1,"CONFINS"	,"TRB","CONFINS	"		,"@E 999,999.99",16)
	TRCell():New(oSection1,"VENCTO"		,"TRB","VENC_TITULO	"	,    			,08)
	TRCell():New(oSection1,"TEXTO"		,"TRB","TEXT_TES"		,"@!"			,30)
	TRCell():New(oSection1,"FINALID"	,"TRB","FINALID_TES"	,"@!"			,30)	
	TRCell():New(oSection1,"TECNCMQ"	,"TRB","TEC/NCM/QUAL"	,"@!"			,16)	
	TRCell():New(oSection1,"ITEMCONT"	,"TRB","ITEM_CONTAB	"	,"@!"			,20)
	TRCell():New(oSection1,"CONTACON"	,"TRB","CONTA_CONTAB"	,"@!"			,15)
	TRCell():New(oSection1,"CENTCUST"	,"TRB","CENTRO_CUSTO"	,"@!"			,30)
			
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
¦¦¦Uso       ¦ FATURAMENTO                                          	  ¦¦¦
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

	/*-----------------------------------------------------------------| 		    			           
	| seleção dos dados a serem impressos/carrega o arquivo temporário | 
	|-----------------------------------------------------------------*/

Static Function fSelDados()

	Local clDescEnt
	Local dtVenc
     
	/*-------------------------------| 		    			           
	| criação do arquivo de trabalho |
	|-------------------------------*/
	
	_aStru	:= {}

	AADD(_aStru,{"NOTA","C",09,0})
	AADD(_aStru,{"SERIE","C",03,0})
	AADD(_aStru,{"COD_FOR","C",06,0})
	AADD(_aStru,{"FORNECE","C",40,0})	
	AADD(_aStru,{"LOJA","C",04,0})
	AADD(_aStru,{"CNPJ","C",14,0})
	AADD(_aStru,{"NATUREZA","C",10,0})	
	AADD(_aStru,{"PRODUTO","C",15,0})
	AADD(_aStru,{"DESCPRO","C",30,0})
	AADD(_aStru,{"UNI_MED","C",02,0})
	AADD(_aStru,{"SUBGRUP","C",04,0})
	AADD(_aStru,{"GRUPTRIB","C",06,0})  
	AADD(_aStru,{"LOCALPD","C",06,0})
	AADD(_aStru,{"DESCARME","C ",06,0})
	AADD(_aStru,{"TES","C",03,0})
	AADD(_aStru,{"CFOP","C",05,0})
	AADD(_aStru,{"QTDE","N",14,2})
	AADD(_aStru,{"PRCCOM","N",14,2})
	AADD(_aStru,{"ALIQICM","N",05,2})
	AADD(_aStru,{"IMP_IMP","N",14,2})
	AADD(_aStru,{"VALIRRF","N",14,2})
	AADD(_aStru,{"VALIPI","N",14,2})
	AADD(_aStru,{"VALISS","N",14,2})
	AADD(_aStru,{"VALINS","N",14,2})
   //	AADD(_aStru,{"CONTROLE","C",10,0})
	AADD(_aStru,{"ICMSTRIB","N",14,2})
	AADD(_aStru,{"ICMSISEN","N",14,2})
	AADD(_aStru,{"ICMSOUTR","N",14,2})
	AADD(_aStru,{"TECNCMQ","C",16,0})
	AADD(_aStru,{"ITEMCONT","C",20,0})                                 
	AADD(_aStru,{"CONTACON","C",20,0})
	AADD(_aStru,{"CENTCUST","C",9,0})
	AADD(_aStru,{"TOTAL","N",14,2})
	AADD(_aStru,{"ICMS","N",14,2})
	AADD(_aStru,{"ICMS_ST","N",14,2})
	AADD(_aStru,{"PIS","N",14,2})
	AADD(_aStru,{"CONFINS","N",14,2})
	AADD(_aStru,{"TEXTO","C",20,0})
	AADD(_aStru,{"FINALID","C",254,0})
	AADD(_aStru,{"TIPO","C",15,0})                                 
	AADD(_aStru,{"PR_UNIT","N",14,2})
	AADD(_aStru,{"DESCONTO","N",14,2})
	AADD(_aStru,{"FRETE","N",14,2})
	AADD(_aStru,{"SEGURO","N",14,2})
	AADD(_aStru,{"DESPESAS","N",14,2})
	AADD(_aStru,{"VALTOT","N",14,2})
	AADD(_aStru,{"FILIAL","C",02,0})
	AADD(_aStru,{"ESTADO","C",02,0})
	AADD(_aStru,{"CONTROLE","C",10,0})
	AADD(_aStru,{"EMISSAO","D",08,0})
	AADD(_aStru,{"DAT_DIGIT","D",08,0})
	AADD(_aStru,{"VENCTO","D",08,0})
	
   	_cArq     := CriaTrab(_aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)
	                                            
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	IndRegua("TRB",_cIndice,"FORNECE",,,"Selecionando Registros...")
	
	/*-----------------------------------------------------------------------------------| 		    			           
	| Montagem da query com os dados das notas fiscais de entrada que movimentam estoque |
	|-----------------------------------------------------------------------------------*/
	
	clQuery := " SELECT D1_TIPO,D1_FILIAL,D1_DOC,D1_SERIE,D1_EMISSAO,D1_DTDIGIT,D1_FORNECE,D1_LOJA,A2_NOME,A2_EST,A2_CGC,A2_NATUREZ,D1_COD,B1_DESC,B1_UM,B1_XSUBGRU,B1_GRTRIB,D1_LOCAL,D1_TES, "
	clQuery += " D1_CONTA,D1_ITEMCTA,D1_CC,D1_CF,D1_QUANT,D1_VUNIT,D1_TOTAL,D1_VALDESC,D1_VALFRE,D1_SEGURO,D1_DESPESA,D1_PICM,D1_VALICM,D1_ICMSRET,D1_VALIMP5, "
	clQuery += " SFT.FT_VALICM AS VALICMTRIB ,SFT.FT_ISENICM AS ISENICM ,SFT.FT_OUTRICM AS OUTRICM,SFT.FT_CODISS AS CODISS, "
	clQuery += " D1_VALIMP6,D1_VALIPI,D1_II,D1_VALIRR,D1_VALISS,D1_VALINS,D1_TEC,F4_TEXTO, "
	clQuery += " F4_FINALID,(D1_TOTAL + D1_SEGURO + D1_VALFRE + D1_DESPESA) AS VALBRUT,F1_CONTROL "
	clQuery += " FROM "+RetSQLName("SD1")+" AS SD1 INNER JOIN "+RetSQLName("SB1")+" AS SB1 ON "
	clQuery += " D1_COD = B1_COD AND SD1.D_E_L_E_T_ = SB1.D_E_L_E_T_ "
	clQuery += " INNER JOIN "+RetSQLName("SA2")+" AS SA2 ON D1_FORNECE = A2_COD AND "                                                                            
	clQuery += " D1_LOJA = A2_LOJA AND SD1.D_E_L_E_T_ = SA2.D_E_L_E_T_ "
	clQuery += " INNER JOIN "+RetSQLName("SF4")+" AS SF4 ON "              	
	clQuery += " D1_FILIAL=F4_FILIAL AND D1_TES =F4_CODIGO AND SD1.D_E_L_E_T_ = SF4.D_E_L_E_T_ INNER JOIN    "
	clQuery += " "+RetSQLName("SF1")+" AS SF1 ON D1_FILIAL=F1_FILIAL AND D1_DOC=F1_DOC AND D1_SERIE=F1_SERIE "
	clQuery += " AND D1_FORNECE=F1_FORNECE AND D1_LOJA=F1_LOJA  AND SD1.D_E_L_E_T_=SF1.D_E_L_E_T_ "
		
	clQuery += " LEFT OUTER JOIN "+RetSQLName("SFT")+" AS SFT ON D1_FILIAL=FT_FILIAL AND D1_DOC = FT_NFISCAL " 
	clQuery += " AND D1_SERIE=FT_SERIE AND D1_EMISSAO=FT_EMISSAO "
	clQuery += " AND D1_FORNECE=FT_CLIEFOR AND D1_LOJA=FT_LOJA AND D1_COD=FT_PRODUTO "
	clQuery += " AND D1_ITEM=FT_ITEM AND FT_TIPOMOV = 'E'  AND SFT.D_E_L_E_T_<>'*' "
	
	clQuery += " WHERE (D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"')  "
	clQuery += " AND (D1_DOC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"') AND "
	clQuery += " (D1_SERIE BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"') AND "
	clQuery += " SD1.D1_FILIAL BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'  "
	clQuery += " AND SD1.D_E_L_E_T_='' "
	
	
	IF SELECT("COMP03") > 0
		dbSelectArea("COMP03")
		DbCloseArea()
	ENDIF 
	
	MemoWrite("ENTRADAS.SQL",clQuery)	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,clQuery),"COMP03",.F.,.T.)
	
	/*---------------------------------------------------| 		    			           
	| ajusta casas decimais e datas no retorno de querys |
	|---------------------------------------------------*/
	
	TcSetField("COMP03","D1_TOTAL"	,"N",14,2)
	TcSetField("COMP03","D1_QUANT"	,"N",14,2)
	TcSetField("COMP03","D1_VALDESC"	,"N",14,2)
	TcSetField("COMP03","D1_VALFRE"	,"N",14,2)
	TcSetField("COMP03","D1_SEGURO"	,"N",14,2)
	TcSetField("COMP03","D1_DESPESA"	,"N",14,2)
	TcSetField("COMP03","D1_VALICM"	,"N",14,2)
	TcSetField("COMP03","D1_ICMSRET"	,"N",14,2)
	TcSetField("COMP03","D1_VALICM"	,"N",14,2)
	TcSetField("COMP03","D1_PICM"		,"N",05,2)
	TcSetField("COMP03","D1_II"		,"N",14,2)
	TcSetField("COMP03","D1_VALIRR"	,"N",14,2)
	TcSetField("COMP03","D1_VALISS"	,"N",14,2)
	TcSetField("COMP03","D1_VALINS"	,"N",14,2)
	TcSetField("COMP03","D1_VALIMP5"	,"N",14,2)
	TcSetField("COMP03","D1_VALIMP6"	,"N",14,2)
	TcSetField("COMP03","D1_VALIPI"	,"N",14,2)                                        
	TcSetField("COMP03","D1_EMISSAO"	,"D",08,0)
	TcSetField("COMP03","D1_DTDIGIT"	,"D",08,0)

	

	
	dbSelectArea("COMP03")
	dbGotop()
	
	Do While COMP03->(!Eof())
	
		DBSELECTAREA("SE2")
		DBSETORDER(6)
	    IF DBSEEK(XFILIAL("SE2")+COMP03->D1_FORNECE+COMP03->D1_LOJA+COMP03->D1_SERIE+COMP03->D1_DOC)
	    	dtVenc:=SE2->E2_VENCREA
	    ENDIF 
	    
	    DBSELECTAREA("ZZ1")
		DBSETORDER(1)
		IF DBSEEK(COMP03->D1_FILIAL + COMP03->D1_LOCAL)
			clDescEnt:=ZZ1_DESCRI
		ENDIF
		
	     MsProcTxt("Processando Item "+COMP03->D1_COD)
	           
	     DbSelectArea("TRB")
	     
	/*--------------------------| 		    			           
	| adciona registro em banco |
	|--------------------------*/
	     
	     RecLock("TRB",.T.) 
	     
	      
	     	TRB->TIPO		:= IIF(COMP03->D1_TIPO=='D',"DEVOLUÇÃO",IIF(COMP03->D1_TIPO=='N',"COMPRAS",COMP03->D1_TIPO))                 
	        TRB->DESCARME	:= clDescEnt           //DESCRIÇÃO DO ARMAZEM DE ENTREGA
	     	TRB->COD_FOR	:= COMP03->D1_FORNECE
	     	IF COMP03->D1_TIPO=='N'
		     	DBSELECTAREA("SA1")
		     	DBSETORDER(1)
		     	IF DBSEEK(XFILIAL("SA1")+ COMP03->D1_FORNECE + COMP03->D1_LOJA)
		     		TRB->FORNECE	:= SA1->A1_NOME
		     		TRB->NATUREZA	:= SA1->A1_NATUREZ
			    	TRB->CNPJ		:= SA1->A1_CGC
		     	ENDIF
		     ELSE
		     	TRB->FORNECE	:= COMP03->A2_NOME
		     	TRB->NATUREZA	:= COMP03->A2_NATUREZ
			    TRB->CNPJ		:= COMP03->A2_CGC		     
		     ENDIF 
	      	      	
	      	TRB->LOJA		:= COMP03->D1_LOJA	    	      	
		    TRB->NOTA		:= COMP03->D1_DOC
	    	TRB->PRODUTO	:= COMP03->D1_COD
	        TRB->DESCPRO	:= COMP03->B1_DESC
	        TRB->UNI_MED	:= COMP03->B1_UM
	        TRB->SUBGRUP	:= COMP03->B1_XSUBGRU
	        TRB->QTDE		:= COMP03->D1_QUANT
	        TRB->PRCCOM		:= COMP03->D1_VUNIT
	        TRB->TOTAL		:= COMP03->D1_TOTAL
	        TRB->ICMS_ST	:= COMP03->D1_ICMSRET
	        TRB->ICMS		:= COMP03->D1_VALICM
	        
	        IF Empty(COMP03->CODISS) 
	        	TRB->ICMSTRIB:= COMP03->VALICMTRIB
	        ELSE
	        	TRB->ICMSTRIB:=0
	        ENDIF
	        
	        TRB->ICMSISEN	:= COMP03->ISENICM
	        TRB->ICMSOUTR	:= COMP03->OUTRICM
	        
	        TRB->PIS		:= COMP03->D1_VALIMP5
	        TRB->CONFINS	:= COMP03->D1_VALIMP6	        
	        TRB->LOCALPD	:= COMP03->D1_LOCAL
	        TRB->SERIE		:= COMP03->D1_SERIE
	        TRB->CFOP		:= COMP03->D1_CF 
	        TRB->TES		:= COMP03->D1_TES
	        TRB->TEXTO		:= COMP03->F4_TEXTO
	        TRB->FINALID   	:= COMP03->F4_FINALID 
	        TRB->PR_UNIT	:= COMP03->D1_VUNIT
	        TRB->DESCONTO	:= COMP03->D1_VALDESC
	        TRB->FRETE		:= COMP03->D1_VALFRE 
	        TRB->SEGURO		:= COMP03->D1_SEGURO
	        TRB->DESPESAS	:= COMP03->D1_DESPESA
	        TRB->VALTOT		:= COMP03->VALBRUT
	        TRB->FILIAL   	:= COMP03->D1_FILIAL
	        TRB->ESTADO		:= COMP03->A2_EST
	        TRB->DAT_DIGIT	:= COMP03->D1_DTDIGIT	        
	        TRB->EMISSAO	:= COMP03->D1_EMISSAO	        
	        TRB->ALIQICM   	:= COMP03->D1_PICM
	        TRB->ITEMCONT	:= COMP03->D1_ITEMCTA
	        TRB->CONTACON	:= COMP03->D1_CONTA
	        TRB->CENTCUST	:= COMP03->D1_CC 
	        TRB->IMP_IMP	:= COMP03->D1_II
	        TRB->VALIRRF	:= COMP03->D1_VALIRR
	        TRB->VALISS		:= COMP03->D1_VALISS
	        TRB->VALINS   	:= COMP03->D1_VALINS
	        TRB->VALIPI   	:= COMP03->D1_VALIPI
	        TRB->GRUPTRIB  	:= COMP03->B1_GRTRIB
	        TRB->TECNCMQ	:= COMP03->D1_TEC
	        TRB->VENCTO		:= dtVenc
	        TRB->CONTROLE	:= COMP03->F1_CONTROL 	        	        
	        
	      MsUnlock()	
	      dbSelectArea("COMP03")
	     DbSkip()
	Enddo
	dtVenc:=""
	
	If Select("COMP03") > 0
		dbSelectArea("COMP03")
		DbCloseArea()
	EndIf
	
Return

Static Function ValPerg(cPerg)

	PutSx1(cPerg, '01', 'DTDIGIT de            ?','' ,'' , 'mv_ch1', 'D', 8, 0, 0, 'G', '', '', '', '', 'mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg, '02', 'DTDIGIT Ate           ?','' ,'' , 'mv_ch2', 'D', 8, 0, 0, 'G', '', '', '', '', 'mv_par02',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg, '03', 'Nota de               ?','' ,'' , 'mv_ch3', 'C', 09, 0, 0, 'G', '', '', '', '', 'mv_par03',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg, '04', 'Nota Ate              ?','' ,'' , 'mv_ch4', 'C', 09, 0, 0, 'G', '', '', '', '', 'mv_par04',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg, '05', 'Serie de              ?','' ,'' , 'mv_ch5', 'C', 03, 0, 0, 'G', '', '', '', '', 'mv_par05',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg, '06', 'Serie Ate             ?','' ,'' , 'mv_ch6', 'C', 03, 0, 0, 'G', '', '', '', '', 'mv_par06',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg, '07','Filial de     		   ?','',''	 , 'mv_ch7', 'C', 02, 0, 0, 'G','','SM0','','','mv_par07',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg, '08','Filial ate             ?','',''	 , 'mv_ch8', 'C', 02, 0, 0, 'G','','SM0','','','mv_par08',,,'','','','','','','','','','','','','','')
Return
