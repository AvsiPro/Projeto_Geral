#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCTBR06  บAutor  ณAlexandre Venancio  บ Data ณ  07/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao criada para melhorar o relatorio de Despesas de todasฑฑ
ฑฑบ          ณas empresas, fizeram com view e estava uma merda.           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTCTBR06(cIni,cFim)

Local aArea	:=	GetArea()
Local cQuery:=	''
Local cEmp	:=	'' 
Local aAux	:=	{} 
Local aRet	:=	{}
Default cIni	:=	"01"
Default	cFim	:=	"13"

//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" // MODULO "COM" //TABLES "SB1"

//If cEmpAnt <> "01"
//	Return
//EndIf

dbSelectArea("SM0")
dbSetOrder(1)
dbGoTop()
         
While !EOF()
	If Ascan(aAux,{|x| x[1] == SM0->M0_CODIGO}) == 0 .And. SM0->M0_CODIGO >= cIni .And. SM0->M0_CODIGO <= cFim
	    Aadd(aAux,{SM0->M0_CODIGO,Alltrim(SM0->M0_NOME)})
	EndIf
	dbskip()
EndDo

For nX := 1 to len(aAux)

	cQuery := " SELECT "
	cQuery += " EMP.CT2_EMPORI AS CODEMP"
	cQuery += ",'"+aAux[nX,02]+"' AS EMPRESA"
	cQuery += " ,EMP.CT2_FILORI AS FILIAL"
	cQuery += " ,EMP.DTEMIS AS EMISSAO"
	cQuery += " ,EMP.CT2_DOC AS DOC"
	cQuery += " ,EMP.CT2_CCD AS CCD"
	cQuery += " ,CUSTODEB.DESCCUSTDEB AS CUSTOD"
	cQuery += " ,EMP.CT2_CCC AS CCC"
	cQuery += " ,CUSTOCRED.DESCCUSTCRED AS CUSTOC"
	cQuery += " ,EMP.CT2_ITEMD AS ITEMD"
	cQuery += " ,ITEMDEBITO.DESCITEMD AS DESCITEMD"
	cQuery += " ,EMP.CT2_ITEMC AS ITEMC"
	cQuery += " ,ITEMCREDITO.DESCITEMC AS DESCITEMC"
	cQuery += " ,EMP.HISTORICO AS HISTORICO"
	cQuery += " ,EMP.LP AS LP"
	cQuery += " ,EMP.CT2_ATIVDE AS ATIVDE"
	cQuery += " ,EMP.CT2_ATIVCR AS ATIVCR"
	cQuery += " ,EMP.VRDEB AS VALDEB"
	cQuery += " ,EMP.VRCRED AS VALCRED"
	cQuery += " ,EMP.DEBITO AS DEBITO"
	cQuery += " ,CONTDEB.DESCCONTDEB AS DESCDEB
	cQuery += " ,EMP.CREDITO AS CREDITO"
	cQuery += " ,CONTCRED.DESCCONTCRED  AS DESCCRED"
	cQuery += " FROM ( "
	cQuery += "  SELECT CT2_EMPORI"
	cQuery += " ,CT2_FILORI"
	cQuery += " ,CT2_DATA AS DTEMIS"
	cQuery += " ,CT2_DOC"
	cQuery += " ,CT2_CCD"
	cQuery += " ,CT2_CCC"
	cQuery += " ,CT2_ITEMD"
	cQuery += " ,CT2_ITEMC"
	cQuery += " ,CT2_HIST AS HISTORICO"
	cQuery += " ,CT2_LP AS LP"
	cQuery += " ,CT2_ATIVDE"
	cQuery += " ,CT2_ATIVCR"
	cQuery += " ,VRDEB  = CASE WHEN"
	cQuery += " ( CT2_DEBITO LIKE '3%' OR CT2_DEBITO LIKE '4%' OR CT2_DEBITO LIKE '5%') THEN CT2_VALOR ELSE 0 END"
	cQuery += " ,VRCRED = CASE WHEN"
	cQuery += " ( CT2_CREDIT LIKE '3%' OR CT2_CREDIT LIKE '4%' OR CT2_CREDIT LIKE '5%') THEN CT2_VALOR ELSE 0 END"
	cQuery += " ,DEBITO = CASE WHEN"
	cQuery += " ( CT2_DEBITO LIKE '3%' OR CT2_DEBITO LIKE '4%' OR CT2_DEBITO LIKE '5%') THEN CT2_DEBITO ELSE '' END"
	cQuery += " ,CREDITO= CASE WHEN"
	cQuery += " ( CT2_CREDIT LIKE '3%' OR CT2_CREDIT LIKE '4%' OR CT2_CREDIT LIKE '5%') THEN CT2_CREDIT ELSE '' END"
	cQuery += "	FROM CT2"+aAux[nX,01]+"0 AS CT2"
	cQuery += "	WHERE  CT2.D_E_L_E_T_ <> '*'"
	cQuery += "	AND (CT2_DEBITO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' OR CT2_CREDIT BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"')"
	cQuery += "	AND (CT2_CCD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' OR CT2_CCC BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' )"
	cQuery += "	AND (CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"')"
	cQuery += "	AND (CT2_FILIAL BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"')"
	cQuery += " AND ((CT2_DEBITO LIKE '3%' OR CT2_DEBITO LIKE '4%' OR CT2_DEBITO LIKE '5%') OR (CT2_CREDIT LIKE '3%' OR CT2_CREDIT LIKE '4%' OR CT2_CREDIT LIKE '5%'))"
	cQuery += " ) AS EMP"
	cQuery += " LEFT JOIN  (SELECT CT1_DESC01 AS DESCCONTDEB,CT1_CONTA  AS CONTAD"
	cQuery += " FROM CT1"+aAux[nX,01]+"0 WHERE CT1"+aAux[nX,01]+"0.D_E_L_E_T_ ='')AS CONTDEB ON EMP.DEBITO=CONTDEB.CONTAD"
	cQuery += " LEFT JOIN  (SELECT CT1_DESC01 AS DESCCONTCRED,CT1_CONTA AS CONTAC"
	cQuery += " FROM CT1"+aAux[nX,01]+"0 WHERE CT1"+aAux[nX,01]+"0.D_E_L_E_T_ ='') AS CONTCRED ON EMP.CREDITO=CONTCRED.CONTAC"
	cQuery += " LEFT JOIN  (SELECT CTT_DESC01 AS DESCCUSTDEB,CTT_CUSTO  AS CUSTOD"
	cQuery += " FROM CTT010 WHERE CTT010.D_E_L_E_T_ ='') AS CUSTODEB ON EMP.CT2_CCD =CUSTODEB.CUSTOD"
	cQuery += " LEFT JOIN  (SELECT CTT_DESC01 AS DESCCUSTCRED,CTT_CUSTO AS CUSTOC"
	cQuery += " FROM CTT010 WHERE CTT010.D_E_L_E_T_ ='') AS CUSTOCRED ON EMP.CT2_CCC =CUSTOCRED.CUSTOC"
	cQuery += " LEFT JOIN  (SELECT CTD_DESC01 AS DESCITEMD,CTD_ITEM  AS ITEMD"
	cQuery += " FROM CTD010 WHERE CTD010.D_E_L_E_T_ ='' ) AS ITEMDEBITO ON EMP.CT2_ITEMD = ITEMDEBITO.ITEMD"
	cQuery += " LEFT JOIN  (SELECT CTD_DESC01 AS DESCITEMC ,CTD_ITEM  AS ITEMC"
	cQuery += " FROM CTD010 WHERE CTD010.D_E_L_E_T_ ='') AS ITEMCREDITO ON EMP.CT2_ITEMC =ITEMCREDITO.ITEMC"
	
	Aadd(aRet,cQuery)
	cQuery := ""
Next nX

//Reset Environment

RestArea(aArea)

Return(aRet)