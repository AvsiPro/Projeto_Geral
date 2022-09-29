
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ TTLOGR01 ¦ Autor ¦ Fabio Sales 		  ¦ Data ¦ 09/08/2011 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descrição ¦ Relatorio de dados do cliente por das notas que 			  ¦¦¦
¦¦¦			 ¦ que utilizaram cargas									  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Logística/TokeTake                                         ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

#INCLUDE "Rwmake.ch"
#INCLUDE "Topconn.ch"

User Function TTLOGR01()
	Local oReport
	Private apDadNot:={}
	If cEmpAnt == "01"
		If TRepInUse()
			oReport := ReportDef()
			oReport:PrintDialog()
		EndIf
	endif
Return

/*/
______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+------------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ ReportDef ¦ Autor ¦ Fabio Sales		   ¦ Data ¦ 09/08/2011 ¦¦¦
¦¦+----------+-------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Função Principal de Impressão				        	   ¦¦¦
¦¦+----------+-------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Logística/TokTake                                           ¦¦¦
¦¦+------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function ReportDef()

	Local oReport
	Local oSection
	Private cPerg    := "TTLOGR01"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New("TTLOGR01","Cliente de entregas",cPerg,{|oReport| PrintReport(oReport)},"Este relatório imprimirá os dados dos clientes das notas de saídas que utilizaram cargas")

/*------------------------|
| seção das notas fiscais |
|------------------------*/

	oSection1 := TRSection():New(oReport,OemToAnsi("Logística TokeTake"),{"TRB"})

/*----------------------------------------------------------------------------------|
|                       campo        alias  título       	 pic           tamanho  |
|----------------------------------------------------------------------------------*/
 
	TRCell():New(oSection1,"NOME"	,"TRB","RAZAO_SOCIAL"		,"@!"		,20)
	TRCell():New(oSection1,"ENDENT"	,"TRB","ENDEREÇO_ENTREGA"	,"@!"		,08)	
	TRCell():New(oSection1,"BAIRRO"	,"TRB","BAIRRO"				,"@!"		,02)
	TRCell():New(oSection1,"CIDADE"	,"TRB","CIDADE"				,"@!"		,35)
	TRCell():New(oSection1,"UF"		,"TRB","UF"					,"@!"		,09)
	TRCell():New(oSection1,"CEP"	,"TRB","CEP"				,"@!"		,04)
	TRCell():New(oSection1,"CNPJ"	,"TRB","CNPJ"				,			,08)
	TRCell():New(oSection1,"HORINI"	,"TRB","HOR. INICIAL"		,"@!"		,06)
	TRCell():New(oSection1,"HORFIM"	,"TRB","HOR. FINAL"			,"@!"		,35)

Return oReport


/*/
______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+------------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦PrintReport¦ Autor ¦ Fabio Sales		   ¦ Data ¦ 01/07/2011 ¦¦¦
¦¦+----------+-------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressão do Relatório        				        	   ¦¦¦
¦¦+----------+-------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Logística/TokeTake                                          ¦¦¦
¦¦+------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/                                                                                                                           
Static Function PrintReport(oReport)
	Local oSection1 := oReport:Section(1)
	
	/*-----------------------------------------------------------------|
	| seleção dos dados a serem impressos/carrega o arquivo temporário |
	|-----------------------------------------------------------------*/
	
	MsAguarde({|| fSelDados()},"Selecionando Notas")
	
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
	If Select("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
    U_Impreltxt(apDadNot)
Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦fSelDados ¦ Autor ¦ Fabio Sales		  ¦ Data ¦ 01/07/2011 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descrição ¦Criação da tabela temporária e Alimentação da mesma por 	  ¦¦¦
¦¦¦			 ¦meio de Vews cridas previamentes							  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Logística/Tok Take                                         ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function fSelDados()

/*-------------------------------|
| criação do arquivo de trabalho |
|-------------------------------*/

	_aStru	:= {}
	
		AADD(_aStru,{"NOME"		,"C",35,0})
		AADD(_aStru,{"ENDENT"	,"C",60,0})
		AADD(_aStru,{"BAIRRO"	,"C",35,0})
		AADD(_aStru,{"CIDADE"	,"C",20,0})
		AADD(_aStru,{"UF"		,"C",15,0})
		AADD(_aStru,{"CEP"		,"C",10,0})
		AADD(_aStru,{"CNPJ"		,"C",20,0})
		AADD(_aStru,{"HORINI"	,"C",10,0})
		AADD(_aStru,{"HORFIM"	,"C",10,0})
	
	_cArq     := CriaTrab(_aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)
	
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	IndRegua("TRB",_cIndice,"NOME",,,"Selecionando Registros...")
	
	/*---------------------------------------------------------------|
	| Montagem com os dados das notas fiscais de vendas e devoluções |
	|---------------------------------------------------------------*/
	 
	_cQuery:= " SELECT	   "
	_cQuery+= "	D2_DOC     "
	_cQuery+= "	,D2_SERIE  "
	_cQuery+= "	,D2_COD    "
	_cQuery+= "	,D2_UM     "
	_cQuery+= "	,B1_DESC   "
	_cQuery+= "	,D2_QUANT  "
	_cQuery+= "	,D2_TOTAL  "
	_cQuery+= "	,D2_CLIENTE "
	_cQuery+= "	,D2_FILIAL	"
	_cQuery+= "	,A1_COD     "
	_cQuery+= "	,A1_LOJA    "
	_cQuery+= "	,A1_NOME    "
	_cQuery+= "	,A1_ENDENT  "
	_cQuery+= "	,A1_BAIRROE "
	_cQuery+= "	,A1_CEPE    "
	_cQuery+= "	,A1_MUNE    "
	_cQuery+= "	,A1_ESTE    "
	_cQuery+= "	,A1_CGC     "
	_cQuery+= "	,A1_PESSOA  "
	_cQuery+= "	,'06:00' AS HOR_INI "
	_cQuery+= "	,'19:00' AS HOR_FIN "
	_cQuery+= "	,(D2_QUANT * B1_PESO)   AS PESOLIQ	"
	_cQuery+= "	,(D2_QUANT * B1_PESBRU) AS PESOBRUT	"
	_cQuery+= "FROM "+RetSqlName("SD2")+" AS SD2 "
	_cQuery+= "INNER JOIN "+RetSqlName("SB1")+" AS SB1 "
	_cQuery+= " ON D2_COD=B1_COD "
	_cQuery+= "INNER JOIN "+RetSqlName("SA1")+" AS SA1 "
	_cQuery+= "	ON D2_CLIENTE=A1_COD    "
	_cQuery+= "	 AND D2_LOJA=A1_LOJA    "
	_cQuery+= "INNER JOIN "+RetSqlName("SF2")+" AS SF2 "
	_cQuery+= "	ON D2_FILIAL=F2_FILIAL  "
	_cQuery+= "	AND D2_DOC=F2_DOC       "
	_cQuery+= "	AND D2_SERIE=F2_SERIE   "
	_cQuery+= "	AND D2_CLIENTE=F2_CLIENTE "
	_cQuery+= "	AND D2_LOJA=F2_LOJA       "
	_cQuery+= "	AND D2_EMISSAO = F2_EMISSAO "
	_cQuery+= "	AND D2_TIPO=F2_TIPO         "
	_cQuery+= "	AND SD2.D_E_L_E_T_ =''   "
	_cQuery+= "	AND F2_XCARGA <> '' "
	_cQuery+= "	AND D2_EMISSAO BETWEEN '"+Dtos(MV_PAR03)+"' AND '"+Dtos(MV_PAR04)+"' "
	_cQuery+= "	AND F2_XCARGA BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'  "    
	_cQuery+= "ORDER BY  "
	_cQuery+= "	 A1_COD  "
	_cQuery+= "	,A1_LOJA "
	_cQuery+= "	,A1_NOME "
	
	If Select("LOGIST") > 0
		dbSelectArea("LOGIST")
		DbCloseArea()
	EndIf
	
	/*-----------------------------|
	|cria a query e dar um apelido |
	|-----------------------------*/
	
	MemoWrite("TTLOGR01.sql",_cQuery) // Salva a Query na pasta sistem para consultas futuras
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"LOGIST",.F.,.T.)
	
	/*-----------------------------------------------------|
	| ajusta as casas decimais e datas no retorno da query |
	|-----------------------------------------------------*/
	
	dbSelectArea("LOGIST")
	dbGotop()
	
	Do While LOGIST->(!Eof())
		MsProcTxt("Processando Cliente  "+LOGIST->A1_NOME)
			
		DbSelectArea("TRB")
		
		clCli:=LOGIST->A1_COD;clLoja:=LOGIST->A1_LOJA 		
	
		/*---------------------------|
		| adiciona registro em banco |
		|---------------------------*/
		 
		RecLock("TRB",.T.)								
			TRB->NOME	:= LOGIST->A1_NOME
			TRB->ENDENT	:= LOGIST->A1_ENDENT
			TRB->BAIRRO	:= LOGIST->A1_BAIRROE
			TRB->CIDADE	:= LOGIST->A1_MUNE
			TRB->UF		:= LOGIST->A1_ESTE
			TRB->CEP	:= LOGIST->A1_CEPE
			If LOGIST->A1_PESSOA=='J' 
				TRB->CNPJ	:= StrZero(Val(LOGIST->A1_CGC),14)
			Else
				TRB->CNPJ	:= StrZero(Val(LOGIST->A1_CGC),11)
			EndIf
			TRB->HORINI	:= LOGIST->HOR_INI
			TRB->HORFIM	:= LOGIST->HOR_FIN	
		MsUnlock()
					
		While LOGIST->A1_COD==clCli .And. LOGIST->A1_LOJA==clLoja
				AADD(apDadNot,{	LOGIST->D2_DOC,	;
								LOGIST->A1_CGC,	;
								LOGIST->D2_UM,	;
								LOGIST->D2_COD,	;
								LOGIST->D2_QUANT,;
								LOGIST->D2_TOTAL,;
								LOGIST->B1_DESC,;
								LOGIST->PESOLIQ,;
								LOGIST->PESOBRUT})
			dbSelectArea("LOGIST")
			DbSkip()
		EndDo
	Enddo
Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ValPerg() ¦ Autor ¦ Fabio Sales		  ¦ Data ¦ 01/07/2011 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descrição ¦Verifica na SX1 através da variável cPerg se existe os parâ-¦¦¦
¦¦¦			 ¦metros de perguntas,se não existir não será criado.		  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Logística/Tok Take                                         ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function ValPerg(cPerg)
	PutSx1(cPerg,'01','Romaneio  de          ?','','','mv_ch1','C',10,0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'02','Romaneio  ate         ?','','','mv_ch2','C',10,0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'03','Emissao de            ?','','','mv_ch3','D',8,0,0,'G','','','','','mv_par03',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'04','Emissao Ate           ?','','','mv_ch4','D',8,0,0,'G','','','','','mv_par04',,,'','','','','','','','','','','','','','')
Return