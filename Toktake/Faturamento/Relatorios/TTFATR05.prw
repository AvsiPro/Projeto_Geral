
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
¦¦¦Função    ¦TTFATR05() ¦ Autor ¦ FABIO SALES		    ¦ Data ¦17.06.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ PEDIDOS DE VENDAS x NOTAS FISCAIS DE SAIDA                 ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦Historico	 ¦ Jackson E. de Deus 						¦ Data ¦2013.03.19¦¦¦
¦¦			 ¦ Adicionado parâmetro Filial De/Ate e PA De/Ate	  		  ¦¦¦
¦¦			 ¦ Projeto 123 - Acerto no relatório existente				  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ FATURAMENTO                                          	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/  

User Function TTFATR05()
	Local oReport
	//If cEmpAnt == "01"
		If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
			oReport := ReportDef()
			oReport:PrintDialog()
		EndIf
	//endif
Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦REPORTDEF ¦ Autor ¦ FABIO SALES		    ¦ Data ¦17.06.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ FUNÇAO PRINCIPAL DE IMPRESSAO   			                  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ FATURAMENTO                                          	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/  

Static Function ReportDef()

	Local oReport
	Local oSection
	Local clDesc	:="Este relatorio tem como finalidade mostrar a diferenca entre pedido e nota"
	Local clTitulo	:="PEDIDO x NOTAS"
	Local clProg	:="TTFATR05"
	Private cPerg	:= "PVNFS"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New(clProg,clTitulo,cPerg,{|oReport| PrintReport(oReport)},clDesc)
	
	/*-------------------------------| 		    			           
	| seção dados das notas fiscais | 
	|-------------------------------*/
	
	oSection1 := TRSection():New(oReport,OemToAnsi("Pedido X Nota"),{"TRB"})
	
	/*-------------------------------------------------------------------------------| 		    			           
	|						campo        alias  titulo            pic   		tam  |	  
	|-------------------------------------------------------------------------------*/
	                                                                    	
	TRCell():New(oSection1,"TIPO"		,"TRB","TIPO"			,"@!"			,35)
	TRCell():New(oSection1,"FILIAL"		,"TRB","FILIAL		"	,"@!"			,02)
	TRCell():New(oSection1,"COD_CLI"	,"TRB","COD_CLI/FOR	"	,"@!"			,06)
	TRCell():New(oSection1,"CLIENTE"	,"TRB","RAZ_SOCIAL	"	,"@!"			,40)
	TRCell():New(oSection1,"LOJA"		,"TRB","LOJA_CLI/FOR"	,"@!"			,04)
	TRCell():New(oSection1,"CIDADE"		,"TRB","CIDADE_CLI"		,"@!"			,30)
	TRCell():New(oSection1,"NUMPED"		,"TRB","NUM_PEDIDO	"	,"@!"			,06)
	TRCell():New(oSection1,"EMISSAO"	,"TRB","EMISSAO_PED "	,				,08)
	TRCell():New(oSection1,"DATAENT"	,"TRB","ENTREGA_PED "	,				,08)
	TRCell():New(oSection1,"NOTA"		,"TRB","COD_NOTA	"	,"@!"			,09)
	TRCell():New(oSection1,"SERIE"		,"TRB","SERIE		"	,"@!"			,03)
	TRCell():New(oSection1,"DATA_NF"	,"TRB","EMISSAO_NF	"	,				,08)
	TRCell():New(oSection1,"CODUSE"		,"TRB","COD_USE_PED	"	,"@!"			,06)
	TRCell():New(oSection1,"USUARIO"	,"TRB","USUARIO_PED	"	,"@!"			,40)
	TRCell():New(oSection1,"COD_VEND"	,"TRB","COD_VEND	"	,"@!"			,06)
	TRCell():New(oSection1,"NOME_VEND"	,"TRB","NOME_VEND	"	,"@!"			,40)
	TRCell():New(oSection1,"CODSUP"		,"TRB","COD_SUPERV	"	,"@!"			,06)
	TRCell():New(oSection1,"NOMSUP"		,"TRB","NOME_SUPERV	"	,"@!"			,40)
	TRCell():New(oSection1,"CODGER"		,"TRB","COD_GERENTE	"	,"@!"			,06)
	TRCell():New(oSection1,"NOMGER"		,"TRB","NOM_GERENTE "	,"@!"			,40)
	TRCell():New(oSection1,"CCUSTO"		,"TRB","CENTRO DE CUSTO","@!"			,09)
	TRCell():New(oSection1,"PRODUTO"	,"TRB","PRODUTO		"	,"@!"			,15)
	TRCell():New(oSection1,"STATU"	    ,"TRB","STATUS"			,"@!"			,15)
	TRCell():New(oSection1,"DESCPROD"	,"TRB","DESCPROD	"	,"@!"			,30)
	TRCell():New(oSection1,"ARMAZEM"	,"TRB","ARMAZEM_SAIDA"	,"@!"			,06)
	TRCell():New(oSection1,"DESCARMS"	,"TRB","DESC_ARMAZ_SAI"	,"@!"			,30)
	TRCell():New(oSection1,"ARM_ENT"	,"TRB","ARMAZEM_ENTREGA","@!"			,06)
	TRCell():New(oSection1,"DESCARME"	,"TRB","DESC_ARMAZ_ENT"	,"@!"			,30)
	TRCell():New(oSection1,"QUANT_PED"	,"TRB","QUANT_PED	"	,"@!"			,14)
	TRCell():New(oSection1,"QUANT_NOTA"	,"TRB","QUANT_NOTA	"	,"@!"			,14)
	TRCell():New(oSection1,"DIFER_QT"	,"TRB","DIFER_QUANT	"	,"@E 999,999.99",14)
	TRCell():New(oSection1,"PR_PEDIDO"	,"TRB","PR_PEDIDO	"	,"@E 999,999.99",14)
	TRCell():New(oSection1,"PR_NOTA"	,"TRB","PR_NOTA		"	,"@E 999,999.99",14)
	TRCell():New(oSection1,"DIFER_PR"	,"TRB","DIFER_PR	"	,"@E 999,999.99",14)
	TRCell():New(oSection1,"TOT_PEDIDO"	,"TRB","TOT_PEDIDO	"	,"@E 999,999.99",14)
	TRCell():New(oSection1,"TOT_NOTA"	,"TRB","TOT_NOTA	"	,"@E 999,999.99",14)
	TRCell():New(oSection1,"DIFER_TOT"	,"TRB","DIFER_TOT	"	,"@E 999,999.99",14)
	
	TRCell():New(oSection1,"OS"			,"TRB","OS ENTREGA"		,"@!"			,TamSx3("ZG_NUMOS")[1])
	TRCell():New(oSection1,"OSDATA"		,"TRB","DATA ENTREGA"	,				,08)                   
	TRCell():New(oSection1,"MOTOR"		,"TRB","MOTORISTA"		,"@!"			,TamSx3("ZG_AGENTED")[1])	
	TRCell():New(oSection1,"OSROTA"		,"TRB","ROTA_RETIRA"	,"@!"			,06)                   


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
	
	/*----------------------------------------------------------------------------| 		    			           
	|seleçao dos dados a serem impressos/carrega o arquivo temporario de trabalho | 
	|----------------------------------------------------------------------------*/
	
	MsAguarde({|| fSelDados()},"Selecionando Itens")
	
	/*-----------------------------|
	| impressao da primeira seçao  | 
	|-----------------------------*/
	
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

	/*----------------------------------------------------------------------------| 		    			           
	|seleçao dos dados a serem impressos/carrega o arquivo temporario de trabalho | 
	|----------------------------------------------------------------------------*/

Static Function fSelDados()

	Local clNomVe :=SPACE(40)
	Local clSuper :=SPACE(06)
	Local clGeren :=SPACE(06)
	Local clNomSup:=SPACE(40)
	Local clNomGer:=SPACE(40)
	Local clNomeCli:=SPACE(40)
	Local clDescEnt:=SPACE(30)
	Local clDescSai:=SPACE(30)
	Local clDescFin:=SPACE(30)
	
	/*------------------------------| 		    			           
	|criacao do arquivo de trabalho | 
	|------------------------------*/
	
	_aStru	:= {}
	
	AADD(_aStru,{"TIPO","C",35,0})
	AADD(_aStru,{"FILIAL","C",02,0})
	AADD(_aStru,{"COD_CLI","C",06,0})
	AADD(_aStru,{"CLIENTE","C",40,0})
	AADD(_aStru,{"LOJA","C",04,0})
	AADD(_aStru,{"NUMPED","C",06,0})
	AADD(_aStru,{"EMISSAO","D",08,0})
	AADD(_aStru,{"DATAENT","D",08,0})
	AADD(_aStru,{"NOTA","C",09,0})
	AADD(_aStru,{"SERIE","C",03,0})
	AADD(_aStru,{"DATA_NF","D",08,0})
	AADD(_aStru,{"PRODUTO","C",15,0})
	AADD(_aStru,{"STATU","C",15,0})
	AADD(_aStru,{"DESCPROD","C",30,0})
	AADD(_aStru,{"QUANT_PED","N",14,2})
	AADD(_aStru,{"QUANT_NOTA","N",14,2})
	AADD(_aStru,{"DIFER_QT","N",14,2})
	AADD(_aStru,{"PR_PEDIDO","N",14,2})
	AADD(_aStru,{"PR_NOTA","N",14,2})
	AADD(_aStru,{"DIFER_PR","N",14,2})
	AADD(_aStru,{"TOT_PEDIDO","N",14,2})
	AADD(_aStru,{"TOT_NOTA","N",14,2})
	AADD(_aStru,{"DIFER_TOT","N",14,2})
	AADD(_aStru,{"USUARIO","C",40,0})
	AADD(_aStru,{"CODUSE","C",06,0})
	AADD(_aStru,{"COD_VEND","C",06,0})
	AADD(_aStru,{"NOME_VEND","C",40,0})
	AADD(_aStru,{"CODSUP","C",06,0})
	AADD(_aStru,{"CODGER","C",06,0})
	AADD(_aStru,{"NOMSUP","C",40,0})
	AADD(_aStru,{"NOMGER","C",40,0})
	AADD(_aStru,{"CCUSTO","C",09,0})
	AADD(_aStru,{"ARMAZEM","C",06,0})
	AADD(_aStru,{"DESCARMS"	,"C",30,0})
	AADD(_aStru,{"ARM_ENT","C ",06,0})
	AADD(_aStru,{"DESCARME","C",30,0})
	AADD(_aStru,{"CIDADE","C",30,0})  
	                                  
	AADD(_aStru,{"OS","C",TamSx3("ZG_NUMOS")[1],0})  
	AADD(_aStru,{"OSDATA","D",8,0})  
	AADD(_aStru,{"MOTOR","C",TamSx3("ZG_AGENTED")[1],0})  	
	AADD(_aStru,{"OSROTA","C",06,0})	

	_cArq     := CriaTrab(_aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)
	
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	IndRegua("TRB",_cIndice,"NUMPED",,,"Selecionando Registros...")
	
	/*--------------------------------------------------------------------------------| 		    			           
	|montagem da query com os dados dos pedidos de vendas e as notas fiscais de saida | 
	|--------------------------------------------------------------------------------*/

	clQuery := " SELECT C5_EMISSAO,C5_XDTENTR,C5_VEND1,C5_XCODPA,C5_XFINAL AS XFINAL,C6_FILIAL,C6_CLI,C6_LOJA,C6_NUM,D2_DOC,D2_SERIE,D2_COD,D2_CCUSTO,C6_PRODUTO,D2_TOTAL,F2_VEND1,D2_QUANT,C6_DESCRI,D2_EMISSAO, "
	clQuery += "        (D2_QUANT-C6_QTDVEN) AS DIVQUANT,C6_QTDVEN,D2_PRCVEN,C6_PRCVEN, (D2_PRCVEN - C6_PRCVEN)AS DIVPRCVEN,(D2_TOTAL-C6_VALOR) AS DIVTOT,D2_LOCAL	,C6_VALOR,	"
	clQuery += "        'TIPO' ='',F2_XFINAL AS FINALID,C5_XNOMUSR,C5_XCODUSR,'STATU'=CASE WHEN (C6_BLQ='R') THEN 'RES.ELIMINADO' ELSE CASE WHEN (C6_BLQ='' AND C6_NOTA='' AND C6_QTDENT=0) THEN 'ABERTO' " 
	clQuery += " ELSE CASE WHEN (C6_BLQ='' AND C6_QTDVEN>C6_QTDENT AND C6_QTDENT<>0) THEN 'PACIAL/ABERTO' ELSE CASE WHEN ((C6_BLQ='' OR C6_BLQ='N') AND C6_QTDVEN=C6_QTDENT)THEN 'ENCERRADO' END END END END "
	
	// os mobile
	clQuery += " ,'OS' = ZG_NUMOS, 'OSDATA' = ZG_DATAFIM, 'MOTOR' = ZG_AGENTED, 'OSROTA' = C5_MENNOTA "
	
	clQuery += " FROM "+RetSqlName("SC6")+" AS SC6 "

	clQuery += " LEFT OUTER JOIN "+RetSqlName("SD2")+" AS SD2 ON "
	clQuery += " C6_FILIAL=D2_FILIAL "
	clQuery += " AND C6_NUM=D2_PEDIDO "
	clQuery += " AND C6_ITEM=D2_ITEMPV "
	clQuery += " AND C6_CLI=D2_CLIENTE "
	clQuery += " AND C6_LOJA=D2_LOJA "
	clQuery += " AND SD2.D_E_L_E_T_<>'*' "

	clQuery += " LEFT OUTER JOIN "+RetSqlName("SC5")+" AS SC5 ON "
	clQuery += " C6_FILIAL=C5_FILIAL "
	clQuery += " AND C6_NUM=C5_NUM "
	clQuery += " AND C6_CLI=C5_CLIENTE "
	clQuery += " AND C6_LOJA=C5_LOJACLI "
	//clQuery += " AND C5_XCODPA=D2_XCODPA "
	clQuery += " AND SC5.D_E_L_E_T_<>'*' "

	clQuery += " LEFT OUTER JOIN "+RetSqlName("SF2")+" AS SF2 ON "
	clQuery += " D2_FILIAL=F2_FILIAL "
	clQuery += " AND D2_DOC=F2_DOC "
	clQuery += " AND D2_SERIE=F2_SERIE "
	clQuery += " AND D2_CLIENTE=F2_CLIENTE "
	clQuery += " AND D2_LOJA=F2_LOJA "
	clQuery += " AND D2_EMISSAO=F2_EMISSAO "
	clQuery += " AND SF2.D_E_L_E_T_<>'*' "
	
	clQuery += " LEFT OUTER JOIN "+RetSqlName("SA3")+" AS SA3 ON "
	clQuery += " C5_VEND1=A3_COD "
	clQuery += " AND SA3.D_E_L_E_T_<>'*' " 
	
	// OS Mobile
	clQuery += "LEFT JOIN " +RetSqlName("SZG") +" ON ZG_FILIAL = C6_FILIAL AND ZG_DOC = D2_DOC AND ZG_SERIE = D2_SERIE AND ZG_CLIFOR = C6_CLI AND ZG_LOJA = C6_LOJA AND ZG_FORM = '13' "
	
	clQuery += " WHERE "
	IIF (MV_PAR05==1,clQuery += " (D2_QUANT-C6_QTDVEN)<>0 AND ",;
	IIF(MV_PAR05==2,clQuery += " (D2_PRCVEN-C6_PRCVEN)<>0 AND " ,;  								//traz diferenças por quantidades e preço de vendas repectivamente
	IIF (MV_PAR05==3,clQuery += " ((D2_QUANT-C6_QTDVEN)<>0 OR (D2_PRCVEN-C6_PRCVEN)<>0) AND ",)))	// todos os tipos de diferença ou todos inclusive os que não possuem diferença.
	clQuery += " C5_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
	clQuery += " AND C6_PRODUTO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
	clQuery += " AND C6_NUM     BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR07+"' "
	clQuery += " AND C6_CLI     BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"' "
	clQuery += " AND C6_LOJA    BETWEEN '"+MV_PAR10+"' AND '"+MV_PAR11+"' "
	clQuery += " AND C5_XCCUSTO BETWEEN '"+MV_PAR12+"' AND '"+MV_PAR13+"' "
	clQuery += " AND C5_XCODUSR BETWEEN '"+MV_PAR14+"' AND '"+MV_PAR15+"' "
	clQuery += " AND C5_XDTENTR BETWEEN '"+DTOS(MV_PAR17)+"' AND '"+DTOS(MV_PAR18)+"' "
	clQuery += " AND C6_FILIAL BETWEEN '"+MV_PAR19+"' AND '"+MV_PAR20+"' "							// Adicionado por Jackson E. de Deus - 19/03/2013
	clQuery += " AND C5_XCODPA BETWEEN '"+MV_PAR21+"' AND '"+MV_PAR22+"' "							// Adicionado por Jackson E. de Deus - 19/03/2013
	clQuery += " AND SC6.D_E_L_E_T_<>'*' "
	
	
	If MV_PAR16==1 
	
		/*--------------------------------------------------------------------------------| 		    			           
		|		 		clausula union all->usada para unir as duas querys 				  | 
		|--------------------------------------------------------------------------------*/
	    
		clQuery += " UNION ALL "
		
		/*--------------------------------------------------------------------------------| 		    			           
		|		 montagem da query com os dados das notas de devoluções de vendas 		  | 
		|--------------------------------------------------------------------------------*/
		
		clQuery += " SELECT '' AS C5_EMISSAO,'' AS C5_XDTENTR,'' AS C5_VEND1,'' AS C5_XCODPA ,'' AS XFINAL,D1_FILIAL AS C6_FILIAL,D1_FORNECE AS C6_CLI,D1_LOJA AS C6_LOJA,'' AS C6_NUM,D1_DOC AS D2_DOC,D1_SERIE AS D2_SERIE, "
		clQuery += " D1_COD AS D2_COD,'' AS D2_CCUSTO,''AS C6_PRODUTO,-D1_TOTAL AS D2_TOTAL,'' AS F2_VEND1,-D1_QUANT AS D2_QUANT,B1_DESC AS C6_DESCRI,D1_EMISSAO AS D2_EMISSAO,	"
		clQuery += "        'DIVQUANT'=0,'C6_QTDVEN'=0,-D1_VUNIT AS D2_PRCVEN,'C6_PRCVEN'=0,'DIVPRCVEN'=0,'DIVTOT'=0,D1_LOCAL AS D2_LOCAL,'C6_VALOR'=0,	"
		clQuery += "        'TIPO' =CASE WHEN D1_TIPO='D' THEN 'DEVOLUÇÃO'  END,'' AS FINALID,'' AS C5_XNOMUSR,'' AS C5_XCODUSR,'STATU'='' "
		
		// OS
	  	clQuery += " ,'OS' = '', 'OSDATA' = '', 'MOTOR' = '', 'OSROTA' = '' "
		
		clQuery += " FROM "+RetSqlName("SD1")+" AS SD1 "

		clQuery += " INNER JOIN "+RetSqlName("SB1")+" AS SB1 ON "
		clQuery += " D1_COD=B1_COD "

		clQuery += " WHERE  "
		clQuery += " D1_FILIAL BETWEEN '"+MV_PAR19+"' AND '"+MV_PAR20+"' "
		clQuery += " AND D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
		clQuery += " AND D1_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
		clQuery += " AND D1_FORNECE BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"' "
		clQuery += " AND D1_LOJA    BETWEEN '"+MV_PAR10+"' AND '"+MV_PAR11+"' "
		clQuery += " AND D1_TIPO = 'D' "
		clQuery += " AND SB1.D_E_L_E_T_<>'*' "
		clQuery += " AND SD1.D_E_L_E_T_<>'*' " 
		
	EndIf
	
	/*--------------------------------------------|
	|verifica se a query existe, se existir fecha | 
	|--------------------------------------------*/
		
	If Select("PVNS") > 0
		dbSelectArea("PVNS")
		DbCloseArea()
	EndIf

	/*-------------------------------------------------------------|
	|salva a query na pasta sistem quando o programa for executado | 
	|-------------------------------------------------------------*/
	
	MemoWrite("SALES.SQL",CLQUERY)
	
	/*-----------------------------|
	|cria a query e dar um apelido |
	|-----------------------------*/
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,clQuery),"PVNS",.F.,.T.)
	
	/*--------------------------------------------|
	|ajusta as casas decimais no retorno da query |
	|--------------------------------------------*/
	
	TcSetField("PVNS","D2_TOTAL","N",14,2)
	TcSetField("PVNS","D2_QUANT","N",14,2)
	TcSetField("PVNS","D2_PRCVEN","N",14,2)
	TcSetField("PVNS","C6_VALOR","N",14,2)
	TcSetField("PVNS","C6_QTDVEN","N",14,2)
	TcSetField("PVNS","C6_PRCVEN","N",14,2)	
	TcSetField("PVNS","D2_EMISSAO","D",08,0)
	TcSetField("PVNS","C5_EMISSAO","D",08,0)
	TcSetField("PVNS","C5_XDTENTR","D",08,0)
	
	
	dbSelectArea("PVNS")
	dbGotop()

	Do While PVNS->(!Eof())
	
		DBSELECTAREA("ZZ1")
		DBSETORDER(1)
		IF DBSEEK(XFILIAL("ZZ1")+ PVNS->D2_LOCAL)
			clDescSai:=ZZ1_DESCRI
		ENDIF
		IF DBSEEK(XFILIAL("ZZ1")+ PVNS->C5_XCODPA)
			clDescEnt:=ZZ1_DESCRI
		ENDIF
	
	/*-------------------|
	|variaveis adcionais |
	|-------------------*/
		
		clNomeCli := Posicione("SA1",1,xFilial("SA1")+PVNS->C6_CLI+PVNS->C6_LOJA,"A1_NOME")
		clCidade  := Posicione("SA1",1,xFilial("SA1")+PVNS->C6_CLI+PVNS->C6_LOJA,"A1_MUN")
		clCidade  := Alltrim(clCidade)
		clNomeCli := Alltrim(clNomeCli)
		
		DBSELECTAREA("SA3")
		DBSETORDER(1)
		IF DBSEEK(XFILIAL("SA3")+ PVNS->C5_VEND1)
			clNomVe:=SA3->A3_NOME
			clSuper:=SA3->A3_SUPER
			clGeren:=SA3->A3_GEREN
		ENDIF
		
		IF DBSEEK(XFILIAL("SA3")+ clSuper )
			clNomSup:=SA3->A3_NOME
		ENDIF
		
		IF DBSEEK(XFILIAL("SA3")+ clGeren )
			clNomGer:=SA3->A3_NOME
		ENDIF
		
		DBSELECTAREA("ZZC")
		DbSetOrder(1)
		IF DBSEEK(XFILIAL("ZZC")+ PVNS->XFINAL )
			clDescFin:=ZZC->ZZC_FINAL
		ELSE
			clDescFin:=PVNS->TIPO 		//Para os casos de devoluções
		ENDIF
		
		
		MsProcTxt("Processando Item "+PVNS->C6_NUM )
		DbSelectArea("TRB")
		
	/*----------------------------|
	|alimenta a tabela temporária |
	|----------------------------*/
		
		RecLock("TRB",.T.)
		
		TRB->TIPO		:= clDescFin
		TRB->FILIAL		:= PVNS->C6_FILIAL
		TRB->COD_CLI	:= PVNS->C6_CLI
		TRB->CLIENTE	:= clNomeCli
		TRB->LOJA		:= PVNS->C6_LOJA 
		TRB->CIDADE		:= clCidade
		TRB->NUMPED		:= PVNS->C6_NUM
		TRB->EMISSAO	:= PVNS->C5_EMISSAO
		TRB->DATAENT	:= PVNS->C5_XDTENTR
		TRB->NOTA 		:= PVNS->D2_DOC
		TRB->PRODUTO	:= PVNS->C6_PRODUTO
		TRB->STATU		:= PVNS->STATU      //Mostra o status do item de venda
		TRB->DESCPROD 	:= PVNS->C6_DESCRI
		TRB->SERIE		:= PVNS->D2_SERIE
		TRB->DATA_NF	:= PVNS->D2_EMISSAO
		TRB->QUANT_PED	:= PVNS->C6_QTDVEN
		TRB->QUANT_NOTA	:= PVNS->D2_QUANT
		TRB->DIFER_QT	:= PVNS->DIVQUANT
		TRB->PR_PEDIDO	:= PVNS->C6_PRCVEN
		TRB->PR_NOTA	:= PVNS->D2_PRCVEN
		TRB->DIFER_PR	:= PVNS->DIVPRCVEN
		TRB->TOT_PEDIDO := PVNS->C6_VALOR
		TRB->TOT_NOTA	:= PVNS->D2_TOTAL
		TRB->DIFER_TOT	:= PVNS->DIVTOT
		TRB->CODUSE		:= PVNS->C5_XCODUSR  // Codigo do usuario
		TRB->USUARIO	:= PVNS->C5_XNOMUSR  // Nome do usuario
		TRB->COD_VEND	:= PVNS->C5_VEND1    // Codigo do vendedor
		TRB->NOME_VEND	:= clNomVe           // Nome do vendedor
		TRB->CODSUP		:= clSuper           // Codigo do supervisor
		TRB->CODGER		:= clGeren           // Codigo do gerente
		TRB->NOMSUP		:= clNomSup          // Nome do supervisor
		TRB->NOMGER		:= clNomGer          // Noeme do gerente
		TRB->CCUSTO		:= PVNS->D2_CCUSTO 
		TRB->ARMAZEM	:= PVNS->D2_LOCAL
        TRB->ARM_ENT	:= PVNS->C5_XCODPA     //ARMAZEM DE ENTREGA
        TRB->DESCARME	:= clDescEnt           //DESCRIÇÃO DO ARMAZEM DE ENTREGA
        TRB->DESCARMS	:= clDescSai	       //DESCRICAO DO ARMAZEM DE SAIDA 
        
        // os e data
        TRB->OS			:= PVNS->OS
        TRB->OSDATA		:= STOD(PVNS->OSDATA)
        TRB->MOTOR		:= PVNS->MOTOR 
        If "PA/ROTA:" $ Alltrim(UPPER(PVNS->OSROTA))
        	nloc := At("PA/ROTA:",Alltrim(UPPER(PVNS->OSROTA)))
        	cVlr := substr(Alltrim(PVNS->OSROTA),nloc+9,6)
        Else
        	cVlr := ''
        EndIf
        TRB->OSROTA		:= cVlr
        	
		
		MsUnlock()
		
		clNomVe :=SPACE(40)
		clSuper :=SPACE(06)
		clGeren :=SPACE(06)
		clNomSup:=SPACE(40)
		clNomGer:=SPACE(40)
		clDescEnt:=SPACE(30)
		clDescSai:=SPACE(30)
		clDescFin:=SPACE(30)
		
		dbSelectArea("PVNS")
		DbSkip()
	Enddo
	
	If Select("PVNS") > 0
		dbSelectArea("PVNS")
		DbCloseArea()
	EndIf
	
Return

Static Function ValPerg(cPerg)

	PutSx1(cPerg,'01','Emissão de  ?','','','mv_ch1','D',8, 0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'02','Emissão Ate ?','','','mv_ch2','D',8, 0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'03','Produto de  ?','','','mv_ch3','C',15,0,0,'G','','SB1','','','mv_par03',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'04','Produto Ate ?','','','mv_ch4','C',15,0,0,'G','','SB1','','','mv_par04',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'05','Diferença   ?','','','mv_ch5','N',1 ,0,1,'C','','','','','mv_par05',"Quantidade",'','','',"Valor",'','',"QuantVal",'','',"Todos",'','','','','')
	PutSx1(cPerg,'06','Pedido de   ?','','','mv_ch6','C',06,0,0,'G','','SC6','','','mv_par06',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'07','Pedido Ate  ?','','','mv_ch8','C',06,0,0,'G','','SC6','','','mv_par07',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'08','Cliente de  ?','','','mv_ch9','C',06,0,0,'G','','SA1','','','mv_par08',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'09','Cliente Ate ?','','','mv_cha','C',06,0,0,'G','','SA1','','','mv_par09',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'10','Loja de     ?','','','mv_chb','C',04,0,0,'G','','','','','mv_par10',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'11','Loja Ate    ?','','','mv_chc','C',04,0,0,'G','','','','','mv_par11',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'12','C.Custo de  ?','','','mv_chd','C',09,0,0,'G','','CTT','','','mv_par12',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'13','C.Custo ate ?','','','mv_che','C',09,0,0,'G','','CTT','','','mv_par13',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'14','Usuário de  ?','','','mv_chf','C',06,0,0,'G','','','','','mv_par14',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'15','Usuário ate ?','','','mv_chg','C',06,0,0,'G','','','','','mv_par15',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'16','Devolução   ?','','','mv_chh','N',1 ,0,1,'C','','','','','mv_par16',"Sim",'','','',"Nao",'','','','','','','','','','','')
	PutSx1(cPerg,'17','Entrega de  ?','','','mv_chi','D',8, 0,0,'G','','','','','mv_par17',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'18','Entrega Ate ?','','','mv_chj','D',8, 0,0,'G','','','','','mv_par18',,,'','','','','','','','','','','','','','')    	
	PutSx1(cPerg,'19','Filial De ?','','','mv_chk','C',02,0,0,'G','','','','','mv_par19',,,'','','','','','','','','','','','','','')	
	PutSx1(cPerg,'20','filial Ate ?','','','mv_chl','C',02,0,0,'G','','','','','mv_par20',,,'','','','','','','','','','','','','','')	
	PutSx1(cPerg,'21','Armazem PA De ?','','','mv_chm','C',06,0,0,'G','','','','','mv_par21',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'22','Armazem PA Ate ?','','','mv_chn','C',06,0,0,'G','','','','','mv_par22',,,'','','','','','','','','','','','','','')

Return
