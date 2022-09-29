
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
¦¦¦Funçào    ¦TTFATR12() ¦ Autor ¦ FABIO SALES		    ¦ Data ¦04.01.2011¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ CUBAGEM    										          ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦FATURAMENTO                                             	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/  

User Function TTFATR12()
	Local oReport
	If cEmpAnt == "01"
		If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
			oReport := ReportDef()
			oReport:PrintDialog()	
		EndIf
	endif
Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦REPORTDEF() ¦ Autor ¦ FABIO SALES			¦ Data ¦04.01.2011¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ FUNCAO PRINCIPAL D EIMPRESSÀO   							  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ FATURAMENTO                                             	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function ReportDef()

	Local oReport
	Local oSection
	Private cPerg    := "CUBAGEM"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New("CUBAGEM","RELATORIO DE CUBAGEM","",{|oReport| PrintReport(oReport)},"ESTE RELATORIO IMPRIMIRÁ A CUBAGEM DOS PRODUTOS")
	
	/*-----------------------------|
	| seção dos dados do relatório |
	|-----------------------------*/
	
	oSection1 := TRSection():New(oReport,OemToAnsi("RELATORIO DE CUBAGEM"),{"TRB"})
	
	/*----------------------------------------------------------------------------------|
	|                       campo        alias  título       	 pic           tamanho  |
	|----------------------------------------------------------------------------------*/ 
		
	TRCell():New(oSection1,"FILIAL" ,"TRB","FILIAL	"			,"@!"			,02)
	TRCell():New(oSection1,"FINALID" ,"TRB","FINALIDADE_VENDA"	,"@!"			,20)
	TRCell():New(oSection1,"DOC" ,"TRB","DOCUMENTO"				,"@!"			,09)
	TRCell():New(oSection1,"SERIE" ,"TRB","SERIE"				,"@!"			,03)
	TRCell():New(oSection1,"EMISSA"	,"TRB","EMISSAO	"			,,08)  
	TRCell():New(oSection1,"VALBRUT"	,"TRB","VALOR_BRUTO	"	,"@E 999,999,999.99",16)
	TRCell():New(oSection1,"VALMERC"	,"TRB","VALOR_MERCAD"	,"@E 999,999,999.99",16)
	TRCell():New(oSection1,"VALFAT"	,"TRB","VALOR_FATURADO	"	,"@E 999,999,999.99",16)
	TRCell():New(oSection1,"ITEM" ,"TRB","ITEM	"				,"@!"				,04)
	TRCell():New(oSection1,"PRODUTO" ,"TRB","PRODUTO	"		,"@!"				,15)
	TRCell():New(oSection1,"DESC" ,"TRB","DESCRICAO	"			,"@!"			,30)
	TRCell():New(oSection1,"ALMOXER" ,"TRB","ALMOXERIFADO	"	,"@!"			,06)
	TRCell():New(oSection1,"QUANT"	,"TRB","QUANTIDADE	"		,"@E 999,999,999.99",16)
	TRCell():New(oSection1,"P_UNIDADE" ,"TRB","PRIM_UNIDADE	"	,"@!"			,03)
	TRCell():New(oSection1,"VALUNIT"	,"TRB","VALOR_UNITARIO"	,"@E 999,999,999.99",16)
	TRCell():New(oSection1,"TOTAL"	,"TRB","TOTAL	"			,"@E 999,999,999.99",16)
	TRCell():New(oSection1,"QUANTS"	,"TRB","QTDE_SEG	"		,"@E 999,999,999.99",16)
	TRCell():New(oSection1,"S_UNIDADE" ,"TRB","SEG_UNIDADE	"	,"@!"			,03)
	TRCell():New(oSection1,"PESOLIQ"  ,"TRB","PESO_LIQUIDO	"	,"@E 999,999,999.99",16)
	TRCell():New(oSection1,"PESOBRUT"  ,"TRB","PESO_BRUTO	"	,"@E 999,999,999.99",16)
	TRCell():New(oSection1,"TES" ,"TRB","TES	"				,"@!"		,03)
	TRCell():New(oSection1,"TEXTOTES" ,"TRB","TEXTO_TES	"		,"@!"		,20)
	TRCell():New(oSection1,"CODCLI" ,"TRB","COD_CLIENTE	"		,"@!"		,06)
	TRCell():New(oSection1,"LOJACLI" ,"TRB","LOJA_CLIENTE"		,"@!"		,03) 
	TRCell():New(oSection1,"RSOCIAL" ,"TRB","RAZAO_SOCIAL	"	,"@!"		,30) 
	TRCell():New(oSection1,"CODPA" ,"TRB","CODIGO_PA	"		,"@!"		,06)
	TRCell():New(oSection1,"DESC_PA" ,"TRB","DESCPA	"			,"@!"		,30)  
	TRCell():New(oSection1,"ENDERECO" ,"TRB","ENDERECO	"		,"@!"		,30)
	TRCell():New(oSection1,"BAIRRO" ,"TRB","BAIRRO"				,"@!"		,30)
	TRCell():New(oSection1,"CIDADE" ,"TRB","CIDADE	"			,"@!"		,30)
	TRCell():New(oSection1,"CEP" ,"TRB","CEP	"				,"@!"		,10)
	TRCell():New(oSection1,"UNIDFED" ,"TRB","UF	"				,"@!"		,03)
	TRCell():New(oSection1,"SITE" ,"TRB","SITE	"				,"@!"		,10)
	TRCell():New(oSection1,"ITEM_CON" ,"TRB","ITEM_CONTABIL	"	,"@!"		,20)	
	TRCell():New(oSection1,"COMPRIM"  ,"TRB","COMPRIMENTO	"	,"@E 999,999,999.99",14)
	TRCell():New(oSection1,"ALTURA"  ,"TRB","ALTURA"			,"@E 999,999,999.99",14)
	TRCell():New(oSection1,"LARGURA"  ,"TRB","LARGUIRA	"		,"@E 999,999,999.99",14) 
	TRCell():New(oSection1,"CUBAGEM"  ,"TRB","CUBAGEM	"		,"@E 999,999,999.99",14)	
	TRCell():New(oSection1,"P_UNI_CUB" ,"TRB","PR_UNID_CUBAGEM"	,"@!"		,03)
	TRCell():New(oSection1,"S_UNI_CUB" ,"TRB","SEG_UNID_CUBAGEM","@!"		,03)
	TRCell():New(oSection1,"FATCONV"	,"TRB","FATOR_CONVEÇÃO" ,"@E 999,999.99",16)
	TRCell():New(oSection1,"TIPCONV" ,"TRB","TIPO_CONVENCÇÃO","@!"		,03)
	TRCell():New(oSection1,"USUARIO" ,"TRB","USUARIO	"	,"@!"		,15)
			
Return oReport

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦PrintReport() ¦ Autor ¦ FABIO SALES	    ¦ Data ¦04.01.2011¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ FUNCAO RESPONSÁVEL PELA IMPRESSÃO DO RELATÓRIO			  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ FATURAMENTO                                            	  ¦¦¦
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
Local ClQuery
Local clEnter:=Chr(10)+Chr(13)

	/*-------------------------------|
	| criação do arquivo de trabalho |
	|-------------------------------*/
	
	_aStru	:= {} 
						    
	AADD(_aStru,{"FILIAL" 	,"C"	,02,0})
	AADD(_aStru,{"FINALID" 	,"C"	,20,0})
	AADD(_aStru,{"DOC" 		,"C"	,09,0})
	AADD(_aStru,{"SERIE" 	,"C"	,03,0})
	AADD(_aStru,{"EMISSA"	,"C"	,15,0})
	AADD(_aStru,{"VALBRUT"	,"N"	,14,2})
	AADD(_aStru,{"VALMERC"	,"N"	,14,2})
	AADD(_aStru,{"VALFAT"	,"N"	,14,2})
	AADD(_aStru,{"ITEM" 	,"C"	,04,0})
	AADD(_aStru,{"PRODUTO" 	,"C"	,15,0})
	AADD(_aStru,{"DESC" 	,"C"	,30,0})
	AADD(_aStru,{"ALMOXER" 	,"C"	,06,0})
	AADD(_aStru,{"QUANT"	,"N"	,14,2})
	AADD(_aStru,{"P_UNIDADE","C"	,03,0})
	AADD(_aStru,{"VALUNIT"	,"N"	,14,2})
	AADD(_aStru,{"TOTAL"	,"N"	,14,2})
	AADD(_aStru,{"QUANTS"	,"N"	,14,2})
	AADD(_aStru,{"S_UNIDADE","C"	,03,0})
	AADD(_aStru,{"PESOLIQ" 	,"N"	,14,2})
	AADD(_aStru,{"PESOBRUT" ,"N"	,14,2})
	AADD(_aStru,{"TES" 		,"C"	,03,0})
	AADD(_aStru,{"TEXTOTES" ,"C"	,20,0})
	AADD(_aStru,{"CODCLI" 	,"C"	,06,0})
	AADD(_aStru,{"LOJACLI" 	,"C"	,04,0})
	AADD(_aStru,{"RSOCIAL" 	,"C"	,30,0})
	AADD(_aStru,{"CODPA" 	,"C"	,06,0})
	AADD(_aStru,{"DESC_PA" 	,"C"	,30,0})
	AADD(_aStru,{"ENDERECO" ,"C"	,30,0})
	AADD(_aStru,{"BAIRRO" 	,"C"	,30,0})
	AADD(_aStru,{"CIDADE" 	,"C"	,30,0})
	AADD(_aStru,{"CEP" 		,"C"	,10,0})
	AADD(_aStru,{"UNIDFED" 	,"C"	,03,0})
	AADD(_aStru,{"SITE" 	,"C"	,10,0})
	AADD(_aStru,{"ITEM_CON" ,"C"	,20,0})
	AADD(_aStru,{"COMPRIM"  ,"N"	,14,2})
	AADD(_aStru,{"ALTURA"  	,"N"	,14,2})
	AADD(_aStru,{"LARGURA"  ,"N"	,14,2})
	AADD(_aStru,{"CUBAGEM"  ,"N"	,14,2}) 	
	AADD(_aStru,{"P_UNI_CUB","C"	,3,0}) 
	AADD(_aStru,{"S_UNI_CUB","C"	,3,0}) 
	AADD(_aStru,{"FATCONV"	,"N"	,14,2}) 
	AADD(_aStru,{"TIPCONV" 	,"C"	,3,0}) 
	AADD(_aStru,{"USUARIO" 	,"C"	,15,0}) 

	
   	_cArq     := CriaTrab(_aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)
	                                            
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	IndRegua("TRB",_cIndice,"FILIAL",,,"Selecionando Registros...")
	                     
	/*-----------------------------------------------------|
	| Montagem da query com os titulos a receber em aberto |
	|-----------------------------------------------------*/

	ClQuery := " SELECT              " + clEnter
	ClQuery += " F2_FILIAL AS FILIAL " + clEnter
	ClQuery += " ,'FINALIDADE' = CASE WHEN F2_XFINAL='1' THEN 'VENDA DIRETA'     " + clEnter
	ClQuery += "                      WHEN F2_XFINAL='2' THEN 'VENDA PA'         " + clEnter
	ClQuery += "                      WHEN F2_XFINAL='3' THEN 'TRANSFERENCIA'    " + clEnter
	ClQuery += "                      WHEN F2_XFINAL='4' THEN 'ABASTECIMENTO'    " + clEnter
	ClQuery += "                      WHEN F2_XFINAL='5' THEN 'OUTRAS SAIDAS'    " + clEnter
	ClQuery += "                      WHEN F2_XFINAL='6' THEN 'VENDA SUBSIDIADA' " + clEnter
	ClQuery += "                      WHEN F2_XFINAL='7' THEN 'SHOWS/EVENTOS' 	 " + clEnter
	ClQuery += " END                " + clEnter
	ClQuery += " ,F2_DOC AS NF      " + clEnter
	ClQuery += " ,F2_SERIE AS SERIE " + clEnter
	ClQuery += " ,SUBSTRING(F2_EMISSAO,7,2)+'/'+SUBSTRING(F2_EMISSAO,5,2)+'/'+SUBSTRING(F2_EMISSAO,1,4) AS EMISSAO " + clEnter
	ClQuery += " ,F2_VALBRUT AS VALBRUTO " + clEnter
	ClQuery += " ,F2_VALMERC AS VALMERC  " + clEnter
	ClQuery += " ,F2_VALFAT AS VALFAT    " + clEnter
	ClQuery += " ,D2_ITEM AS ITEM        " + clEnter
	ClQuery += " ,D2_COD AS PRODUTO      " + clEnter
	ClQuery += " ,B1_DESC AS DESCRICAO   " + clEnter
	ClQuery += " ,D2_LOCAL AS ALMOX      " + clEnter
	ClQuery += " ,D2_QUANT AS QUANT    	 " + clEnter
	ClQuery += " ,ISNULL(ZZ9_PRIUNI,D2_UM) AS PRI_UNI " + clEnter
	ClQuery += " ,D2_PRCVEN AS VAL_UNIT      " + clEnter
	ClQuery += " ,D2_TOTAL AS TOTAL          " + clEnter
	ClQuery += " ,D2_QTSEGUM AS QUANT_SEGUM  " + clEnter
	ClQuery += " ,ISNULL(ZZ9_SEGUNI,D2_SEGUM) AS SEG_UNI " + clEnter
	ClQuery += " ,B1_PESO AS PESO_LIQ       " + clEnter
	ClQuery += " ,B1_PESBRU AS PESO_BRT     " + clEnter
	ClQuery += " ,D2_TES AS TES             " + clEnter
	ClQuery += " ,F4_TEXTO AS TEXTO         " + clEnter
	ClQuery += " ,F2_CLIENTE AS CODIGO      " + clEnter
	ClQuery += " ,F2_LOJA AS LOJA           " + clEnter
	ClQuery += " ,A1_NOME AS RAZAO          " + clEnter
	ClQuery += " ,F2_EMISSAO AS EMISSAO     " + clEnter
	ClQuery += " ,F2_XCODPA AS COD_PA       " + clEnter
	ClQuery += " ,ZZ1_DESCRI AS PA          " + clEnter
	ClQuery += " ,ZZ1_END AS ENDERECO       " + clEnter
	ClQuery += " ,'' AS COMPLEMENTO         " + clEnter
	ClQuery += " ,ZZ1_BAIRRO AS BAIRRO      " + clEnter
	ClQuery += " ,ZZ1_MUN AS CIDADE         " + clEnter
	ClQuery += " ,ZZ1_CEP AS CEP            " + clEnter
	ClQuery += " ,ZZ1_EST AS UF             " + clEnter
	ClQuery += " ,ZZ1_SITE AS SITE			" + clEnter
	ClQuery += " ,ZZ1_ITCONT AS IT_CONTABIL           " + clEnter
	ClQuery += " ,ISNULL(ZZ9_COMPRI,0) AS COMPRIMENTO " + clEnter
	ClQuery += " ,ISNULL(ZZ9_ALTURA,0) AS ALTURA  	  " + clEnter
	ClQuery += " ,ISNULL(ZZ9_LARGUR,0) AS LARGURA 	  " + clEnter
	ClQuery += " ,ISNULL((ZZ9_COMPRI*ZZ9_ALTURA*ZZ9_LARGUR),0) AS CUBAGEM " + clEnter
	ClQuery += " ,ISNULL(ZZ9_PRIUNI,0) AS PRI_UNI_CB " + clEnter
	ClQuery += " ,ISNULL(ZZ9_SEGUNI,0) AS SEG_UNI_CB " + clEnter
	ClQuery += " ,ISNULL(B1_CONV,0) AS FATOR      	 " + clEnter
	ClQuery += " ,ISNULL(B1_TIPCONV,0) AS TIP_CON 	 " + clEnter
	ClQuery += " ,C5_XNOMUSR AS USUARIO      		 " + clEnter
	ClQuery += " FROM  "+RetSqlName("SF2")+" AS SF2  " + clEnter
	ClQuery += " INNER JOIN  "+RetSqlName("SD2")+" AS SD2  " + clEnter
	ClQuery += " ON D2_FILIAL=F2_FILIAL      " + clEnter
	ClQuery += " AND D2_DOC=F2_DOC           " + clEnter
	ClQuery += " AND D2_SERIE=F2_SERIE       " + clEnter
	ClQuery += " AND D2_EMISSAO=F2_EMISSAO   " + clEnter
	ClQuery += " AND D2_TIPO=F2_TIPO         " + clEnter
	ClQuery += " AND D2_CLIENTE=F2_CLIENTE   " + clEnter
	ClQuery += " AND D2_LOJA=F2_LOJA         " + clEnter
	ClQuery += " AND SUBSTRING(D2_LOCAL,1,1)='D' " + clEnter
	ClQuery += " AND D2_LOCAL NOT IN ('D00016')  " + clEnter
	ClQuery += " AND SD2.D_E_L_E_T_=''           " + clEnter
	ClQuery += " INNER JOIN   "+RetSqlName("SC5")+" AS SC5 " + clEnter
	ClQuery += " ON C5_FILIAL=D2_FILIAL        " + clEnter
	ClQuery += " AND C5_NUM=D2_PEDIDO          " + clEnter
	ClQuery += " AND SC5.D_E_L_E_T_=''      "    + clEnter
	ClQuery += " INNER JOIN "+RetSqlName("SB1")+" AS SB1 " + clEnter
	ClQuery += " ON B1_COD=D2_COD              " + clEnter
	ClQuery += " AND SB1.D_E_L_E_T_=''      "    + clEnter
	ClQuery += " LEFT JOIN "+RetSqlName("ZZ9")+" AS ZZ9 " + clEnter 
	ClQuery += " ON ZZ9_COD=D2_COD             " + clEnter
	ClQuery += " AND ZZ9.D_E_L_E_T_=''         " + clEnter
	ClQuery += " INNER JOIN "+RetSqlName("SF4")+"  AS SF4 " + clEnter
	ClQuery += " ON F4_FILIAL=D2_FILIAL        " + clEnter
	ClQuery += " AND F4_CODIGO=D2_TES          " + clEnter
	ClQuery += " AND F4_ESTOQUE='S'            " + clEnter
	ClQuery += " AND SF4.D_E_L_E_T_=''      "    + clEnter
	ClQuery += " INNER JOIN "+RetSqlName("ZZ1")+" AS ZZ1  " + clEnter
	ClQuery += " ON ZZ1_FILIAL=F2_FILIAL       " + clEnter
	ClQuery += " AND ZZ1_COD=F2_XCODPA         " + clEnter
	ClQuery += " AND ZZ1.D_E_L_E_T_=''         " + clEnter
	ClQuery += " INNER JOIN "+RetSqlName("SA1")+" AS SA1 " + clEnter
	ClQuery += " ON A1_COD=F2_CLIENT           " + clEnter
	ClQuery += " AND A1_LOJA=F2_LOJENT         " + clEnter
	ClQuery += " AND SA1.D_E_L_E_T_=''      " + clEnter
	ClQuery += " WHERE SF2.D_E_L_E_T_=''    " + clEnter
	ClQuery += " AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'  " + clEnter
	ClQuery += " AND D2_COD BETWEEN '" + MV_PAR03 +"' AND '"+ MV_PAR04 +"'  			" + clEnter
	ClQuery += " AND D2_CLIENTE BETWEEN '" + MV_PAR05 +"' AND '"+ MV_PAR06 +"'  		" + clEnter
	ClQuery += " AND D2_LOJA BETWEEN '" + MV_PAR07 +"' AND '"+ MV_PAR08 +"'  			" + clEnter
	ClQuery += " AND F2_FILIAL BETWEEN '" + MV_PAR10 +"' AND '"+ MV_PAR11 +"'  			" + clEnter
	
	IF MV_PAR09==1 
		ClQuery += " AND F2_XFINAL IN('1','2') " + clEnter  && Venda PAs e Direta 
	ELSEIF  MV_PAR09==2
		ClQuery += " AND F2_XFINAL IN('3','4','5') " + clEnter  && Transferencia , abastecimento, outras saidas 
	ELSEIF  MV_PAR09==3
		ClQuery += " AND F2_XFINAL IN('6','7') " + clEnter  && Vendas Subsidiadas , Shows / Eventos
	ELSEIF  MV_PAR09==4
		ClQuery += " AND F2_XFINAL IN('4') " + clEnter  &&	Abatecimento
	ELSEIF  MV_PAR09==2
		ClQuery += " AND F2_XFINAL IN('1','2','3','4','5','6','7') " + clEnter  && Todas as finalidades
	EndIf
	
	ClQuery += " UNION " + clEnter 
	                                                        
	ClQuery += " SELECT                                                         " + clEnter
	ClQuery += " F2_FILIAL AS FILIAL                                            " + clEnter
	ClQuery += " ,'FINALIDADE' = CASE WHEN F2_XFINAL='1' THEN 'VENDA DIRETA'     " + clEnter
	ClQuery += "                      WHEN F2_XFINAL='2' THEN 'VENDA PA'         " + clEnter
	ClQuery += "                      WHEN F2_XFINAL='3' THEN 'TRANSFERENCIA'    " + clEnter
	ClQuery += "                      WHEN F2_XFINAL='4' THEN 'ABASTECIMENTO'    " + clEnter
	ClQuery += "                      WHEN F2_XFINAL='5' THEN 'OUTRAS SAIDAS'    " + clEnter
	ClQuery += "                      WHEN F2_XFINAL='6' THEN 'VENDA SUBSIDIADA' " + clEnter
	ClQuery += "                      WHEN F2_XFINAL='7' THEN 'SHOWS/EVENTOS' " + clEnter
	ClQuery += " END                      " + clEnter
	ClQuery += " ,F2_DOC AS NF            " + clEnter
	ClQuery += " ,F2_SERIE AS SERIE       " + clEnter
	ClQuery += " ,SUBSTRING(F2_EMISSAO,7,2)+'/'+SUBSTRING(F2_EMISSAO,5,2)+'/'+SUBSTRING(F2_EMISSAO,1,4) AS EMISSAO " + clEnter
	ClQuery += " ,F2_VALBRUT AS VALBRUTO                 " + clEnter
	ClQuery += " ,F2_VALMERC AS VALMERC                  " + clEnter
	ClQuery += " ,F2_VALFAT AS VALFAT                    " + clEnter
	ClQuery += " ,D2_ITEM AS ITEM                        " + clEnter
	ClQuery += " ,D2_COD AS PRODUTO                      " + clEnter
	ClQuery += " ,B1_DESC AS DESCRICAO                   " + clEnter
	ClQuery += " ,D2_LOCAL AS ALMOX                      " + clEnter
	ClQuery += " ,D2_QUANT AS QUANT                      " + clEnter
	ClQuery += " ,ISNULL(ZZ9_PRIUNI,D2_UM) AS PRI_UNI    " + clEnter
	ClQuery += " ,D2_PRCVEN AS VAL_UNIT                  " + clEnter
	ClQuery += " ,D2_TOTAL AS TOTAL                      " + clEnter
	ClQuery += " ,D2_QTSEGUM AS QUANT_SEGUM              " + clEnter
	ClQuery += " ,ISNULL(ZZ9_SEGUNI,D2_SEGUM) AS SEG_UNI " + clEnter
	ClQuery += " ,B1_PESO AS PESO_LIQ       " + clEnter
	ClQuery += " ,B1_PESBRU AS PESO_BRT     " + clEnter
	ClQuery += " ,D2_TES AS TES             " + clEnter
	ClQuery += " ,F4_TEXTO AS TEXTO         " + clEnter
	ClQuery += " ,F2_CLIENTE AS CODIGO      " + clEnter
	ClQuery += " ,F2_LOJA AS LOJA           " + clEnter
	ClQuery += " ,A1_NOME AS RAZAO          " + clEnter
	ClQuery += " ,F2_EMISSAO AS EMISSAO     " + clEnter
	ClQuery += " ,F2_XCODPA AS COD_PA       " + clEnter
	ClQuery += " ,'' AS PA                  " + clEnter
	ClQuery += " ,A1_END AS ENDERECO        " + clEnter
	ClQuery += " ,A1_COMPLEM AS COMPLEMENTO " + clEnter
	ClQuery += " ,A1_BAIRRO AS BAIRRO    " + clEnter
	ClQuery += " ,A1_MUN AS CIDADE       " + clEnter
	ClQuery += " ,A1_CEP AS CEP          " + clEnter
	ClQuery += " ,A1_EST AS UF           " + clEnter
	ClQuery += " ,'' AS SITE             " + clEnter
	ClQuery += " ,'' AS IT_CONTABIL      " + clEnter
	ClQuery += " ,ISNULL(ZZ9_COMPRI,0) AS COMPRIMENTO " + clEnter
	ClQuery += " ,ISNULL(ZZ9_ALTURA,0) AS ALTURA      " + clEnter
	ClQuery += " ,ISNULL(ZZ9_LARGUR,0) AS LARGURA     " + clEnter
	ClQuery += " ,ISNULL((ZZ9_COMPRI*ZZ9_ALTURA*ZZ9_LARGUR),0) AS CUBAGEM " + clEnter
	ClQuery += " ,ISNULL(ZZ9_PRIUNI,0) AS PRI_UNI_CB " + clEnter
	ClQuery += " ,ISNULL(ZZ9_SEGUNI,0) AS SEG_UNI_CB " + clEnter
	ClQuery += " ,ISNULL(B1_CONV,0) AS FATOR      " + clEnter
	ClQuery += " ,ISNULL(B1_TIPCONV,0) AS TIP_CON " + clEnter
	ClQuery += " ,C5_XNOMUSR AS USUARIO          " + clEnter
	ClQuery += " FROM "+RetSqlName("SF2")+" AS SF2  " + clEnter
	ClQuery += " INNER JOIN "+RetSqlName("SD2")+" AS SD2  " + clEnter
	ClQuery += " ON D2_FILIAL=F2_FILIAL          " + clEnter
	ClQuery += " AND D2_DOC=F2_DOC               " + clEnter
	ClQuery += " AND D2_SERIE=F2_SERIE           " + clEnter
	ClQuery += " AND D2_EMISSAO=F2_EMISSAO       " + clEnter
	ClQuery += " AND D2_TIPO=F2_TIPO             " + clEnter
	ClQuery += " AND D2_CLIENTE=F2_CLIENTE       " + clEnter
	ClQuery += " AND D2_LOJA=F2_LOJA             " + clEnter
	ClQuery += " AND SUBSTRING(D2_LOCAL,1,1)='D' " + clEnter
	ClQuery += " AND D2_LOCAL NOT IN ('D00016') " + clEnter
	ClQuery += " AND SD2.D_E_L_E_T_=''   " + clEnter
	ClQuery += " INNER JOIN "+RetSqlName("SC5")+" AS SC5 " + clEnter
	ClQuery += " ON C5_FILIAL=D2_FILIAL     " + clEnter
	ClQuery += " AND C5_NUM=D2_PEDIDO       " + clEnter
	ClQuery += " AND SC5.D_E_L_E_T_=''   " + clEnter
	ClQuery += " INNER JOIN "+RetSqlName("SB1")+" AS SB1  " + clEnter
	ClQuery += " ON B1_COD=D2_COD           " + clEnter
	ClQuery += " AND SB1.D_E_L_E_T_=''   " + clEnter
	ClQuery += " LEFT JOIN "+RetSqlName("ZZ9")+" AS ZZ9 " + clEnter
	ClQuery += " ON ZZ9_COD=D2_COD          " + clEnter
	ClQuery += " AND ZZ9.D_E_L_E_T_=''   " + clEnter
	ClQuery += " INNER JOIN "+RetSqlName("SF4")+" AS SF4 " + clEnter
	ClQuery += " ON F4_FILIAL=D2_FILIAL     " + clEnter
	ClQuery += " AND F4_CODIGO=D2_TES       " + clEnter
	ClQuery += " AND F4_ESTOQUE='S'         " + clEnter
	ClQuery += " AND SF4.D_E_L_E_T_=''   " + clEnter
	ClQuery += " INNER JOIN "+RetSqlName("SA1")+" AS SA1 " + clEnter
	ClQuery += " ON A1_COD=F2_CLIENT        " + clEnter
	ClQuery += " AND A1_LOJA=F2_LOJENT      " + clEnter
	ClQuery += " AND A1_ENDENT=''           " + clEnter
	ClQuery += " AND SA1.D_E_L_E_T_=''   " + clEnter
	ClQuery += " WHERE SF2.D_E_L_E_T_='' "  + clEnter
	ClQuery += " AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'  " + clEnter
	ClQuery += " AND D2_COD BETWEEN '" + MV_PAR03 +"' AND '"+ MV_PAR04 +"'  			" + clEnter
	ClQuery += " AND D2_CLIENTE BETWEEN '" + MV_PAR05 +"' AND '"+ MV_PAR06 +"'  		" + clEnter
	ClQuery += " AND D2_LOJA BETWEEN '" + MV_PAR07 +"' AND '"+ MV_PAR08 +"'  			" + clEnter
	ClQuery += " AND F2_FILIAL BETWEEN '" + MV_PAR10 +"' AND '"+ MV_PAR11 +"'  			" + clEnter
	
	IF MV_PAR09==1 
		ClQuery += " AND F2_XFINAL IN('1','2') " + clEnter  && Venda PAs e Direta 
	ELSEIF  MV_PAR09==2
		ClQuery += " AND F2_XFINAL IN('3','4','5') " + clEnter  && Transferencia , abastecimento, outras saidas 
	ELSEIF  MV_PAR09==3
		ClQuery += " AND F2_XFINAL IN('6','7') " + clEnter  && Vendas Subsidiadas , Shows / Eventos
	ELSEIF  MV_PAR09==4
		ClQuery += " AND F2_XFINAL IN('4') " + clEnter  &&	Abatecimento
	ELSEIF  MV_PAR09==2
		ClQuery += " AND F2_XFINAL IN('1','2','3','4','5','6','7') " + clEnter  && Todas as finalidades
	EndIf
	ClQuery += " AND F2_XCODPA=''  " + clEnter
	
	ClQuery += " UNION             " + clEnter
	
	ClQuery += " SELECT            "  + clEnter 
	
	ClQuery += " F2_FILIAL AS FILIAL                                                 " + clEnter
	ClQuery += " ,'FINALIDADE' = CASE WHEN F2_XFINAL='1' THEN 'VENDA DIRETA'         " + clEnter
	ClQuery += "                      WHEN F2_XFINAL='2' THEN 'VENDA PA'             " + clEnter
	ClQuery += "                      WHEN F2_XFINAL='3' THEN 'TRANSFERENCIA'        " + clEnter
	ClQuery += "                      WHEN F2_XFINAL='4' THEN 'ABASTECIMENTO'        " + clEnter
	ClQuery += "                      WHEN F2_XFINAL='5' THEN 'OUTRAS SAIDAS'        " + clEnter
	ClQuery += "                      WHEN F2_XFINAL='6' THEN 'VENDA SUBSIDIADA'     " + clEnter
	ClQuery += "                      WHEN F2_XFINAL='7' THEN 'SHOWS/EVENTOS'        " + clEnter
	ClQuery += " END                                                                 " + clEnter
	ClQuery += " ,F2_DOC AS NF                                                       " + clEnter
	ClQuery += " ,F2_SERIE AS SERIE                                                                                " + clEnter
	ClQuery += " ,SUBSTRING(F2_EMISSAO,7,2)+'/'+SUBSTRING(F2_EMISSAO,5,2)+'/'+SUBSTRING(F2_EMISSAO,1,4) AS EMISSAO " + clEnter
	ClQuery += " ,F2_VALBRUT AS VALBRUTO                 " + clEnter
	ClQuery += " ,F2_VALMERC AS VALMERC                  " + clEnter
	ClQuery += " ,F2_VALFAT AS VALFAT                    " + clEnter
	ClQuery += " ,D2_ITEM AS ITEM                        " + clEnter
	ClQuery += " ,D2_COD AS PRODUTO                      " + clEnter
	ClQuery += " ,B1_DESC AS DESCRICAO                   " + clEnter
	ClQuery += " ,D2_LOCAL AS ALMOX                      " + clEnter
	ClQuery += " ,D2_QUANT AS QUANT                      " + clEnter
	ClQuery += " ,ISNULL(ZZ9_PRIUNI,D2_UM) AS PRI_UNI    " + clEnter
	ClQuery += " ,D2_PRCVEN AS VAL_UNIT                  " + clEnter
	ClQuery += " ,D2_TOTAL AS TOTAL                      " + clEnter
	ClQuery += " ,D2_QTSEGUM AS QUANT_SEGUM              " + clEnter
	ClQuery += " ,ISNULL(ZZ9_SEGUNI,D2_SEGUM) AS SEG_UNI " + clEnter
	ClQuery += " ,B1_PESO AS PESO_LIQ       " + clEnter
	ClQuery += " ,B1_PESBRU AS PESO_BRT     " + clEnter
	ClQuery += " ,D2_TES AS TES             " + clEnter
	ClQuery += " ,F4_TEXTO AS TEXTO         " + clEnter
	ClQuery += " ,F2_CLIENTE AS CODIGO      " + clEnter
	ClQuery += " ,F2_LOJA AS LOJA           " + clEnter
	ClQuery += " ,A1_NOME AS RAZAO          " + clEnter
	ClQuery += " ,F2_EMISSAO AS EMISSAO     " + clEnter
	ClQuery += " ,F2_XCODPA AS COD_PA       " + clEnter
	ClQuery += ",'' AS PA                   " + clEnter
	ClQuery += " ,A1_ENDENT AS ENDERECO     " + clEnter
	ClQuery += " ,'' AS COMPLEMENTO         " + clEnter
	ClQuery += " ,A1_BAIRROE AS BAIRRO      " + clEnter
	ClQuery += " ,A1_MUNE AS CIDADE         " + clEnter
	ClQuery += " ,A1_CEPE AS CEP            " + clEnter
	ClQuery += " ,A1_ESTE AS UF             " + clEnter
	ClQuery += " ,'' AS SITE                " + clEnter
	ClQuery += " ,'' AS IT_CONTABIL                                       " + clEnter
	ClQuery += " ,ISNULL(ZZ9_COMPRI,0) AS COMPRIMENTO        			  " + clEnter
	ClQuery += " ,ISNULL(ZZ9_ALTURA,0) AS ALTURA                          " + clEnter
	ClQuery += " ,ISNULL(ZZ9_LARGUR,0) AS LARGURA                         " + clEnter
	ClQuery += " ,ISNULL((ZZ9_COMPRI*ZZ9_ALTURA*ZZ9_LARGUR),0) AS CUBAGEM " + clEnter
	ClQuery += " ,ISNULL(ZZ9_PRIUNI,0) AS PRI_UNI_CB " + clEnter
	ClQuery += " ,ISNULL(ZZ9_SEGUNI,0) AS SEG_UNI_CB " + clEnter
	ClQuery += " ,ISNULL(B1_CONV,0) AS FATOR      " + clEnter
	ClQuery += " ,ISNULL(B1_TIPCONV,0) AS TIP_CON " + clEnter
	ClQuery += " ,C5_XNOMUSR AS USUARIO           " + clEnter
	ClQuery += " FROM "+RetSqlName("SF2")+" AS SF2                     " + clEnter
	ClQuery += " INNER JOIN "+RetSqlName("SD2")+" AS SD2               " + clEnter
	ClQuery += " ON D2_FILIAL=F2_FILIAL           " + clEnter
	ClQuery += " AND D2_DOC=F2_DOC                " + clEnter
	ClQuery += " AND D2_SERIE=F2_SERIE            " + clEnter
	ClQuery += " AND D2_EMISSAO=F2_EMISSAO        " + clEnter
	ClQuery += " AND D2_TIPO=F2_TIPO              " + clEnter
	ClQuery += " AND D2_CLIENTE=F2_CLIENTE        " + clEnter
	ClQuery += " AND D2_LOJA=F2_LOJA              " + clEnter
	ClQuery += " AND SUBSTRING(D2_LOCAL,1,1)='D' " + clEnter
	ClQuery += " AND D2_LOCAL NOT IN ('D00016') " + clEnter
	ClQuery += " AND SD2.D_E_L_E_T_=''   " + clEnter
	ClQuery += " INNER JOIN "+RetSqlName("SC5")+" AS SC5          " + clEnter
	ClQuery += " ON C5_FILIAL=D2_FILIAL     " + clEnter
	ClQuery += " AND C5_NUM=D2_PEDIDO       " + clEnter
	ClQuery += " AND SC5.D_E_L_E_T_=''   " + clEnter
	ClQuery += " INNER JOIN "+RetSqlName("SB1")+" AS SB1         " + clEnter
	ClQuery += " ON B1_COD=D2_COD           " + clEnter
	ClQuery += " AND SB1.D_E_L_E_T_=''   " + clEnter
	ClQuery += " LEFT JOIN "+RetSqlName("ZZ9")+" AS ZZ9          " + clEnter
	ClQuery += " ON ZZ9_COD=D2_COD          " + clEnter
	ClQuery += " AND ZZ9.D_E_L_E_T_=''   " + clEnter
	ClQuery += " INNER JOIN "+RetSqlName("SF4")+" AS SF4         " + clEnter
	ClQuery += " ON F4_FILIAL=D2_FILIAL     " + clEnter
	ClQuery += " AND F4_CODIGO=D2_TES       " + clEnter
	ClQuery += " AND F4_ESTOQUE='S'         " + clEnter
	ClQuery += " AND SF4.D_E_L_E_T_=''   " + clEnter
	ClQuery += " INNER JOIN "+RetSqlName("SA1")+" AS SA1        " + clEnter
	ClQuery += " ON A1_COD=F2_CLIENT        " + clEnter
	ClQuery += " AND A1_LOJA=F2_LOJENT      " + clEnter
	ClQuery += " AND A1_ENDENT<>''          " + clEnter
	ClQuery += " AND SA1.D_E_L_E_T_=''   " + clEnter
	ClQuery += " WHERE SF2.D_E_L_E_T_='' " + clEnter
	ClQuery += " AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'  " + clEnter
	ClQuery += " AND D2_COD BETWEEN '" + MV_PAR03 +"' AND '"+ MV_PAR04 +"'  			" + clEnter
	ClQuery += " AND D2_CLIENTE BETWEEN '" + MV_PAR05 +"' AND '"+ MV_PAR06 +"'  		" + clEnter
	ClQuery += " AND D2_LOJA BETWEEN '" + MV_PAR07 +"' AND '"+ MV_PAR08 +"'  			" + clEnter
	ClQuery += " AND F2_FILIAL BETWEEN '" + MV_PAR10 +"' AND '"+ MV_PAR11 +"'  			" + clEnter
	
	IF MV_PAR09==1 
		ClQuery += " AND F2_XFINAL IN('1','2') " + clEnter  && Venda PAs e Direta 
	ELSEIF  MV_PAR09==2
		ClQuery += " AND F2_XFINAL IN('3','4','5') " + clEnter  && Transferencia , abastecimento, outras saidas 
	ELSEIF  MV_PAR09==3
		ClQuery += " AND F2_XFINAL IN('6','7') " + clEnter  && Vendas Subsidiadas , Shows / Eventos
	ELSEIF  MV_PAR09==4
		ClQuery += " AND F2_XFINAL IN('4') " + clEnter  &&	Abatecimento
	ELSEIF  MV_PAR09==2
		ClQuery += " AND F2_XFINAL IN('1','2','3','4','5','6','7') " + clEnter  && Todas as finalidades
	EndIf
	ClQuery += " AND F2_XCODPA=''  	" + clEnter 

	IF SELECT("CUBA") > 0                                                                                    
		dbSelectArea("CUBA")
		DbCloseArea()
	ENDIF
	
	MemoWrite("CUBAGEM.SQL",clQuery)//SALVA A QUERY NA PASTA SISTEM PARA CONSULTAS FUTURA
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,clQuery),"CUBA",.F.,.T.)
	
	/*--------------------------------------------------|
	| ajusta casas decimais e datas no retorno da query |
	|--------------------------------------------------*/
				
	dbSelectArea("CUBA")
	dbGotop()
		
	While CUBA->(!Eof())
	 			     	      		       
	 DbSelectArea("TRB")
	/*--------------------------|
	| adciona registro em banco |
	|--------------------------*/ 
	
	    RecLock("TRB",.T.) 
	    	    
			TRB->FILIAL		:= CUBA->FILIAL
			TRB->FINALID	:= CUBA->FINALIDADE
			TRB->DOC		:= CUBA->NF
			TRB->SERIE		:= CUBA->SERIE
			TRB->EMISSA		:= CUBA->EMISSAO
			TRB->VALBRUT	:= CUBA->VALBRUTO
			TRB->VALMERC	:= CUBA->VALMERC
			TRB->VALFAT		:= CUBA->VALFAT
			TRB->ITEM		:= CUBA->ITEM
			TRB->PRODUTO	:= CUBA->PRODUTO
			TRB->DESC		:= CUBA->DESCRICAO
			TRB->ALMOXER	:= CUBA->ALMOX
			TRB->QUANT		:= CUBA->QUANT
			TRB->P_UNIDADE	:= CUBA->PRI_UNI
			TRB->VALUNIT	:= CUBA->VAL_UNIT
			TRB->TOTAL		:= CUBA->TOTAL
			TRB->QUANTS		:= CUBA->QUANT_SEGUM
			TRB->S_UNIDADE	:= CUBA->SEG_UNI
			TRB->PESOLIQ	:= CUBA->PESO_LIQ
			TRB->PESOBRUT	:= CUBA->PESO_BRT
			TRB->TES		:= CUBA->TES
			TRB->TEXTOTES	:= CUBA->TEXTO
			TRB->CODCLI		:= CUBA->CODIGO
			TRB->LOJACLI	:= CUBA->LOJA
			TRB->RSOCIAL	:= CUBA->RAZAO
			TRB->CODPA		:= CUBA->COD_PA
			TRB->DESC_PA	:= CUBA->PA
			TRB->ENDERECO	:= CUBA->ENDERECO
			TRB->BAIRRO		:= CUBA->BAIRRO
			TRB->CIDADE		:= CUBA->CIDADE
			TRB->CEP		:= CUBA->CEP
			TRB->UNIDFED	:= CUBA->UF
			TRB->SITE		:= CUBA->SITE
			TRB->ITEM_CON	:= CUBA->IT_CONTABIL
			TRB->COMPRIM	:= CUBA->COMPRIMENTO
			TRB->ALTURA		:= CUBA->ALTURA
			TRB->LARGURA	:= CUBA->LARGURA
			TRB->CUBAGEM	:= CUBA->CUBAGEM
			TRB->P_UNI_CUB	:= CUBA->SEG_UNI_CB
			TRB->S_UNI_CUB	:= CUBA->PRI_UNI_CB
			TRB->FATCONV	:= CUBA->FATOR
			TRB->TIPCONV	:= CUBA->TIP_CON
			TRB->USUARIO	:= CUBA->USUARIO
		            
	      MsUnlock()	      
	      dbSelectArea("CUBA")
	      DBSKIP()  
	Enddo
	
	If Select("CUBA") > 0
		dbSelectArea("CUBA")
		DbCloseArea()
	EndIf
	
Return

Static Function ValPerg(cPerg) 

	PutSx1(cPerg,'01','Emissao de            ?','','','mv_ch1','D',8,0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'02','Emissao Ate           ?','','','mv_ch2','D',8,0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')	
	PutSx1(cPerg,'03','Produto de            ?','','','mv_ch3','C',15,0,0,'G','','SB1','','','mv_par03',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'04','Produto Ate           ?','','','mv_ch4','C',15,0,0,'G','','SB1','','','mv_par04',,,'','','','','','','','','','','','','','')	
	PutSx1(cPerg,'05','Cliente de  ?','','','mv_ch5','C',06,0,0,'G','','SA1','','','mv_par05',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'06','Cliente Ate ?','','','mv_ch6','C',06,0,0,'G','','SA1','','','mv_par06',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'07','Loja de     ?','','','mv_ch7','C',04,0,0,'G','','','','','mv_par07',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'08','Loja Ate    ?','','','mv_ch8','C',04,0,0,'G','','','','','mv_par08',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'09','Tipo de Saida  ?','','','mv_ch9','N',1,0,1,'C','','','','','mv_par09',"Vendas(PA/DIR)","","","","Abas/Trans/Outras","","","Ven.Subs_Shows/event","","","Abastecimento","","","Todas","","")	
	PutSx1(cPerg,'10','Filial de     ?','','','mv_chB','C',02,0,0,'G','','SM0','','','mv_par10',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'11','Filial ate    ?','','','mv_ch8','C',02,0,0,'G','','SM0','','','mv_par11',,,'','','','','','','','','','','','','','')
		
Return
