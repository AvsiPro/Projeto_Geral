
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ TTFATR20()¦ Autor ¦Fabio Sales 		  ¦ Data ¦ 25/10/2011 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descrição ¦ Relatorio Abastecimento X Transferência		              ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Abastecimento/Tok Take                                     ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"


User Function TTFATR20()
Local oReport
If cEmpAnt == "01"
	If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
		oReport := ReportDef()
		oReport:PrintDialog()
	EndIf
endif
Return

/*/
______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+------------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ ReportDef ¦ Autor ¦ Fabio Sales         ¦ Data ¦ 25/10/2011 ¦¦¦
¦¦+----------+-------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Função Principal de Impressão				        	   ¦¦¦
¦¦+----------+-------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Todas as saidas/TokeTake                                    ¦¦¦
¦¦+------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function ReportDef()

Local oReport
Local oSection
Private cPerg    := "TTFATR020"
ValPerg(cPerg)
Pergunte(cPerg,.T.)
oReport := TReport():New("TTFATR20","Abastecimento X Farturamento",cPerg,{|oReport| PrintReport(oReport)},"Este relatório irá imprimir os abastecimento X Faturamento")

/*------------------------|
| seção das notas fiscais |
|------------------------*/

oSection1 := TRSection():New(oReport,OemToAnsi("Saídas de Mercadoria"),{"TRB"})

/*----------------------------------------------------------------------------------|
|                       campo        alias  título       	 pic           tamanho  |
|----------------------------------------------------------------------------------*/

TRCell():New(oSection1,"FILIAL"		,"TRB"	,"FILIAL		"		,"@!"			,02)
TRCell():New(oSection1,"PA_ABS_DT"	,"TRB"	,"PA_ABST_DAT	"		,"@!"			,08)
TRCell():New(oSection1,"PA_ABS_PA"	,"TRB"	,"PA_ABST_PA	"		,"@!"			,06)
TRCell():New(oSection1,"DESC_PA"	,"TRB"	,"DESC_PA		"		,"@!"			,35)
TRCell():New(oSection1,"PA_ABS_C"	,"TRB"	,"PA_ABST_COD	"		,"@!"			,06)
TRCell():New(oSection1,"PA_ABS_D"	,"TRB"	,"PA_ABST.DES	"		,"@!"			,35)
TRCell():New(oSection1,"EST_REG"	,"TRB"	,"EST_REG		"		,"@E 999,999.99",16)
TRCell():New(oSection1,"EST_INI"	,"TRB"	,"EST_INI		"		,"@E 999,999.99",16)
TRCell():New(oSection1,"QTD_1_ABS"	,"TRB" 	,"QTD_1_ABST	"		,"@E 999,999.99",16)
TRCell():New(oSection1,"PRCAB"		,"TRB"	,"PRC_ABST		"		,"@E 999,999.99",16)
TRCell():New(oSection1,"TOTAB"		,"TRB"	,"TOT_ABST		"		,"@E 999,999.99",16)
TRCell():New(oSection1,"UM_ABS"		,"TRB"	,"UM_ABST		"		,"@!"			,03)
TRCell():New(oSection1,"QTD_2_ABS"	,"TRB"	,"QTD_2_ABST	"		,"@E 999,999.99",16)
TRCell():New(oSection1,"SEGUM_ABS"	,"TRB"	,"SEGUM_ABST	"		,"@!"			,03)
TRCell():New(oSection1,"QTD_1_FAT"	,"TRB"	,"QTD_1_FAT		"		,"@E 999,999.99",16)
TRCell():New(oSection1,"QTD_2_FAT"	,"TRB"	,"QTD_2_FAT		"		,"@E 999,999.99",16)
TRCell():New(oSection1,"PRCFAT"		,"TRB"	,"PRC_FAT		"		,"@E 999,999.99",16)
TRCell():New(oSection1,"TOTFAT"		,"TRB"	,"TOT_FAT		"		,"@E 999,999.99",16)

Return oReport


/*/
______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+------------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦PrintReport¦ Autor ¦ Fabio Sales         ¦ Data ¦ 25/10/2011 ¦¦¦
¦¦+----------+-------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressão do Relatório        				        	   ¦¦¦
¦¦+----------+-------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Abastecimento X Faturamento/TokeTake                                    ¦¦¦
¦¦+------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
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
Local clAnoMes:="" 

/*-------------------------------|
| criação do arquivo de trabalho |
|-------------------------------*/

_aStru	:= {}

AADD(_aStru,{"FILIAL"		,"C",02,0})
AADD(_aStru,{"PA_ABS_DT"	,"C",06,0})
AADD(_aStru,{"PA_ABS_PA"	,"C",06,0})
AADD(_aStru,{"DESC_PA"		,"C",35,0})
AADD(_aStru,{"PA_ABS_C"		,"C",15,0})
AADD(_aStru,{"PA_ABS_D"		,"C",35,0})
AADD(_aStru,{"EST_REG"		,"N",14,4})
AADD(_aStru,{"EST_INI"		,"N",14,4})
AADD(_aStru,{"QTD_1_ABS"	,"N",14,4})
AADD(_aStru,{"UM_ABS"		,"C",03,0})
AADD(_aStru,{"QTD_2_ABS"	,"N",14,4})
AADD(_aStru,{"SEGUM_ABS"	,"C",03,0})
AADD(_aStru,{"QTD_1_FAT"	,"N",14,4})
AADD(_aStru,{"QTD_2_FAT"	,"N",14,4})
AADD(_aStru,{"PRCFAT"		,"N",14,4})
AADD(_aStru,{"TOTFAT"		,"N",14,4})
AADD(_aStru,{"PRCAB"		,"N",14,4})
AADD(_aStru,{"TOTAB"		,"N",14,4})

_cArq     := CriaTrab(_aStru,.T.)
_cIndice  := CriaTrab(Nil,.F.)

If Sele("TRB") <> 0
	TRB->(DbCloseArea())
Endif

dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
IndRegua("TRB",_cIndice,"FILIAL",,,"Selecionando Registros...")

/*---------------------------------------------------------------|
| Montagem com os dados das notas fiscais de vendas e devoluções |
|---------------------------------------------------------------*/
 
	clQuery:= " SELECT PA_ABST.FILIAL "
	clQuery+= "		,PA_ABST.DATA  AS DAT"
	clQuery+= "		,PA_ABST.PA "
	clQuery+= "		,ZZ1_DESCRI AS DESC_PA "
	clQuery+= "		,PA_ABST.CODIGO "
	clQuery+= "		,PA_ABST.DESCRICAO "
	clQuery+= "		,B2_XESTREG AS EST_REG "
	clQuery+= "		,'EST_INI' =CASE WHEN PA_ABST.DATA= '"+Left(Dtos(mv_par01),6)+"' THEN B9_QINI "
	clQuery+= "                  	WHEN PA_ABST.DATA<> '"+Left(Dtos(mv_par01),6)+"' THEN 0 "
	clQuery+= "					END "
	clQuery+= "		,PA_ABST.QUANT_1 AS QTD_1_ABST "
	clQuery+= "		,PA_ABST.UM AS UM_ABST "
	clQuery+= "		,PA_ABST.QUANT_2 AS QTD_2_ABST "
	clQuery+= "		,PA_ABST.SEGUM AS SEGUM_ABST "
	clQuery+= "		,ISNULL(PA_FAT.QUANT_1,0) AS QTD_1_FAT "
	clQuery+= "		,ISNULL(PA_FAT.QUANT_2,0) AS QTD_2_FAT " 
	clQuery+= "		,ISNULL(PA_FAT.P_UNIT ,0) AS PRNUNIFAT "
	clQuery+= "		,ISNULL(PA_FAT.TOTAL  ,0) AS TOTFAT "	
	clQuery+= "		,ISNULL(PA_ABST.P_UNIT ,0) AS PRNUNIAB "
	clQuery+= "		,ISNULL(PA_ABST.TOTAL  ,0) AS TOTAB "

	clQuery+= "	FROM PA_ABST "
	clQuery+= "	INNER JOIN "+RetSqlName("ZZ1")+" AS ZZ1 "
	clQuery+= "	ON ZZ1_FILIAL=PA_ABST.FILIAL "
	clQuery+= "		AND ZZ1_COD=PA_ABST.PA "
	clQuery+= "		AND ZZ1.D_E_L_E_T_='' "
	clQuery+= "		INNER JOIN "+RetSqlName("SB2")+" AS SB2 "
	clQuery+= "	ON B2_FILIAL=PA_ABST.FILIAL "
	clQuery+= "		AND B2_COD=PA_ABST.CODIGO "
	clQuery+= "		AND B2_LOCAL=PA_ABST.PA "
	clQuery+= "		AND SB2.D_E_L_E_T_='' "
	clQuery+= "	LEFT JOIN PA_FAT "
	clQuery+= "	ON PA_ABST.FILIAL=PA_FAT.FILIAL "
	clQuery+= "		AND PA_ABST.DATA=PA_FAT.DATA "
	clQuery+= "		AND PA_ABST.CODIGO=PA_FAT.CODIGO "
	clQuery+= "		AND  PA_ABST.PA=PA_FAT.PA "
	clQuery+= "	LEFT JOIN "+RetSqlName("SB9")+" AS SB9 "
	clQuery+= "	ON B9_FILIAL=PA_ABST.FILIAL "
	clQuery+= "		AND B9_COD=PA_ABST.CODIGO "
	clQuery+= "		AND B9_LOCAL=PA_ABST.PA "	
		
	If  SubStr(Dtos(mv_par01),5,2)="01"
		clAnoMes:=str(val(Substr(Dtos(mv_par01),1,4))- 1)+ '12'
	Else
		clAnoMes:=Substr(Dtos(mv_par01),1,4) +  Alltrim(StrZero(Val(SubStr(Dtos(mv_par01),5,2))-1,2))
	EndIf
				
	clQuery+= "		AND SUBSTRING(B9_DATA,1,6)='"+clAnoMes+"' "
	clQuery+= "		AND SB9.D_E_L_E_T_='' "
	clQuery+= "	WHERE PA_ABST.DATA BETWEEN '"+Left(Dtos(mv_par01),6)+"' AND '"+Left(Dtos(mv_par02),6)+"' "
	clQuery+= "	AND PA_ABST.PA BETWEEN '"+ mv_par03 + "' AND '"+mv_par04+"' "	
	clQuery+= "	ORDER BY 1,2,3,5 "

If Select("ABFAT") > 0
	dbSelectArea("ABFAT")
	DbCloseArea()
EndIf

/*-----------------------------|
|cria a query e dar um apelido |
|-----------------------------*/

MemoWrite("TTFATR20.SQL",clQuery) // Salva a Query na pasta sistem para consultas futuras
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,clQuery),"ABFAT",.F.,.T.)

/*-----------------------------------------------------|
| ajusta as casas decimais e datas no retorno da query |
|-----------------------------------------------------*/

dbSelectArea("ABFAT")
dbGotop()

Do While ABFAT->(!Eof())
	MsProcTxt("Processando Filial  "+ABFAT->FILIAL)	
	DbSelectArea("TRB")
	
	/*---------------------------|
	| adiciona registro em banco |
	|---------------------------*/
	
	RecLock("TRB",.T.)
		
	TRB->FILIAL		:= ABFAT->FILIAL 
	TRB->PA_ABS_DT	:= ABFAT->DAT 
	TRB->PA_ABS_PA	:= ABFAT->PA 
	TRB->DESC_PA	:= ABFAT->DESC_PA
	TRB->PA_ABS_C	:= ABFAT->CODIGO
	TRB->PA_ABS_D	:= ABFAT->DESCRICAO
	TRB->EST_REG	:= ABFAT->EST_REG
	TRB->EST_INI	:= ABFAT->EST_INI
	TRB->QTD_1_ABS	:= ABFAT->QTD_1_ABST
	TRB->UM_ABS		:= ABFAT->UM_ABST
	TRB->QTD_2_ABS	:= ABFAT->QTD_2_ABST
	TRB->SEGUM_ABS	:= ABFAT->UM_ABST
	TRB->QTD_1_FAT	:= ABFAT->QTD_1_FAT
	TRB->QTD_2_FAT	:= ABFAT->QTD_2_FAT
	TRB->PRCFAT		:= ABFAT->PRNUNIFAT
	TRB->TOTFAT     := ABFAT->TOTFAT 	
	TRB->PRCAB		:= ABFAT->PRNUNIAB
	TRB->TOTAB      := ABFAT->TOTAB		
			
	dbSelectArea("ABFAT")	
	DbSkip()
Enddo

If Select("ABFAT") > 0
	dbSelectArea("ABFAT")
	DbCloseArea()
EndIf
Return

/*/
______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+------------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ValPerg¦ Autor ¦ Fabio Sales 		¦ Data ¦        25/10/2011 ¦¦¦
¦¦+----------+-------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Criam as perguntas, caso as mesmas não existam na SX1   	   ¦¦¦
¦¦+----------+-------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Abastecimento X Faturamento / TokeTake                      ¦¦¦
¦¦+------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/                                                                                                                           

Static Function ValPerg(cPerg)
	PutSx1(cPerg,'01','Emissao de            ?','','','mv_ch1','D',8,0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'02','Emissao Ate           ?','','','mv_ch2','D',8,0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,"03","PA de   				 ?","","","mv_ch3","C",06,00,00,"G","","ZZ1","","","mv_Par03","","","","","","","","","","","","","","","","",{"Digite a PA inicial"},{},{},"")
	PutSx1(cPerg,"04","PA Ate  				 ?","","","mv_ch4","C",06,00,00,"G","","ZZ1","","","mv_Par04","","","","","","","","","","","","","","","","",{"Digite a PA final"},{},{},"")
Return
