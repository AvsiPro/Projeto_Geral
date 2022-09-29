#INCLUDE "TOPCONN.CH"    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROR03  บAutor  ณAlexandre Venancio  บ Data ณ  16/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorios de OMMs pendentes 		 					  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTPROR03()
	Local oReport
	If cEmpAnt <> "01"
		return
	EndIF
	If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
		oReport := ReportDef()
		oReport:PrintDialog()
	Else
		Alert("Esta op็ใo ainda nใo estแ disponํvel")
	EndIf
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROR03  บAutor  ณMicrosiga           บ Data ณ  12/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ReportDef()

	Local oReport
	Local oSection
	Local clDesc	:="Este relat๓rio exibe os titulos com canhotos baixados que ainda nใo foram enviados ao banco"
	Local clTitulo	:="OMMs PENDENTES"
	Local clProg	:="TTPROR03"
	Private cPerg	:="TTPROR03"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New(clProg,clTitulo,cPerg,{|oReport| PrintReport(oReport)},clDesc)
	
	oSection1 := TRSection():New(oReport,OemToAnsi("OMM"),{"TRB"})
	
    TRCell():New(oSection1,"FILIAL"		,"TRB","FILIAL"			,"@!"	,02)
   	TRCell():New(oSection1,"COD_CLI"	,"TRB","COD_CLI" 		,"@!"	,10)
   	TRCell():New(oSection1,"NOME"		,"TRB","NOME"	 		,"@!"	,40)
	TRCell():New(oSection1,"OMM"		,"TRB","OMM"	 		,"@!"	,06)
	TRCell():New(oSection1,"ITEM"		,"TRB","ITEM"			,"@!"	,02)	
	TRCell():New(oSection1,"PRODUTO"	,"TRB","PRODUTO"		,"@!"	,15)	
	TRCell():New(oSection1,"MODELO"		,"TRB","MODELO"			,"@!"	,80)	
	TRCell():New(oSection1,"FLUXO"		,"TRB","FLUXO"			,"@!"	,100)
	TRCell():New(oSection1,"DATA_INI"	,"TRB","DATA_INI"		,		,08)
	TRCell():New(oSection1,"TAREFA"		,"TRB","TAREFA"	 		,"@!"	,06)
	TRCell():New(oSection1,"SEQUENCIA"	,"TRB","SEQUENCIA"		,"@!"	,03)
	TRCell():New(oSection1,"DESC_TAR"	,"TRB","DESC_TAR" 		,"@!"	,75)
	TRCell():New(oSection1,"AREA"		,"TRB","AREA"			,"@!"	,25)
	TRCell():New(oSection1,"DATA_TAR"	,"TRB","DATA_TAR"		,		,08)
	TRCell():New(oSection1,"DATA_PRE"	,"TRB","DATA_PRE"		,		,08)
	TRCell():New(oSection1,"USUARIO"	,"TRB","USUARIO"		,"@!"	,TamSX3("U7_NOME")[1])

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROR03  บAutor  ณMicrosiga           บ Data ณ  12/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PrintReport(oReport)

	Local oSection1 := oReport:Section(1)
	
	/*----------------------------------------------------------------------------| 		    			           
	|sele็ao dos dados a serem impressos/carrega o arquivo temporario de trabalho | 
	|----------------------------------------------------------------------------*/
	
	MsAguarde({|| fSelDados()},"Selecionando Itens")
	
	/*-----------------------------|
	| impressao da primeira se็ao  | 
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


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROR03  บAutor  ณMicrosiga           บ Data ณ  12/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fSelDados()
	
	/*------------------------------| 		    			           
	|criacao do arquivo de trabalho | 
	|------------------------------*/
	
	_aStru	:= {} 

	AADD(_aStru,{"FILIAL"	,"C",02,0})
	AADD(_aStru,{"COD_CLI"	,"C",10,0})
	AADD(_aStru,{"NOME"		,"C",40,0})
	AADD(_aStru,{"OMM"		,"C",06,0})
	AADD(_aStru,{"ITEM"		,"C",02,0})
	AADD(_aStru,{"PRODUTO"	,"C",15,0})
	AADD(_aStru,{"MODELO"	,"C",80,0})
	AADD(_aStru,{"FLUXO"	,"C",100,0})
	AADD(_aStru,{"DATA_INI" ,"D",08,2})
	AADD(_aStru,{"TAREFA"	,"C",06,0})
	AADD(_aStru,{"SEQUENCIA","C",03,0})
	AADD(_aStru,{"DESC_TAR" ,"C",75,0})
	AADD(_aStru,{"AREA"		,"C",25,0})
	AADD(_aStru,{"DATA_TAR" ,"D",08,2})
	AADD(_aStru,{"DATA_PRE" ,"D",08,2})
	AADD(_aStru,{"USUARIO"  ,"C",TamSX3("U7_NOME")[1],0})                            

		
	_cArq     := CriaTrab(_aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)
	
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	//IndRegua("TRB",_cIndice,"NOTA",,,"Selecionando Registros...")
	
	clQuery := " SELECT UD_FILIAL,UD_CODIGO,UD_ITEM,UD_PRODUTO,B1_ESPECIF,Z9_DESC,UD_DATA,UD_XTAREF,UD_XTARSEQ,Z9_TAREFA,Z9_AREA,UD_XTARDT,UD_XTARHR,UD_DATA+ROUND(Z9_SLA/24,0) AS PREV,UC_CHAVE,A1_NOME,U7_NOME "
	clQuery += " FROM "+RetSQLName("SUD")+" UD"  
	clQuery += " INNER JOIN "+RetSQLName("SUC")+" UC ON UC_FILIAL=UD_FILIAL AND UC_CODIGO=UD_CODIGO AND UC.D_E_L_E_T_='' AND UC_CODCANC = '' AND UC_STATUS = '2' "
	clQuery += " INNER JOIN "+RetSQLName("SU7")+" U7 ON U7_COD=UC_OPERADO AND U7.D_E_L_E_T_='' "
	clQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=UD_PRODUTO AND B1.D_E_L_E_T_='' "
	clQuery += " INNER JOIN "+RetSQLName("SZ9")+" Z9 ON Z9_COD=UD_XTAREF AND Z9_SEQ=UD_XTARSEQ AND Z9.D_E_L_E_T_='' "
	clQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_COD+A1_LOJA = UC_CHAVE AND A1.D_E_L_E_T_='' "
	If !Empty(MV_PAR03)
		clQuery += 	" AND Z9_AREA LIKE '%"+Alltrim(MV_PAR03)+"%'"
	
	EndIf
	
	clQuery += " WHERE UD_ASSUNTO='000007' AND UD_STATUS='1' "
	
	clQuery += " AND UD.D_E_L_E_T_ = '' "
	
	//Solicitado pelo Pericles do Processamento para poder filtrar ou nao por filial. - Alexandre 11/02/14
	If !empty(MV_PAR04)
		clQuery	+=	" AND UD_FILIAL='"+xFilial("SUD")+"'"
	EndIf
	
	If !empty(MV_PAR01)
		cPerini := substr(MV_PAR01,4,4)
		cPerini += substr(MV_PAR01,1,2)
		cPerFim := ""
		If !Empty(MV_PAR02)
			cPerFim := substr(MV_PAR02,4,4)
			cPerFim += substr(MV_PAR02,1,2)
		EndIf
		 
		clQuery += " AND UD_DATA BETWEEN '"+cPerini+"01' AND '"+if(!empty(cPerFim),dtos(lastday(stod(cPerFim+'01'))),dtos(lastday(stod(cPerini+'01'))))+"' AND UD.D_E_L_E_T_=''"
	EndIf
	
	
	
	clQuery += "ORDER BY UD_FILIAL,UD_CODIGO"
	

	/*--------------------------------------------|
	|verifica se a query existe, se existir fecha | 
	|--------------------------------------------*/
		
	If Select("TRBROTA") > 0
		dbSelectArea("TRBROTA")
		DbCloseArea()
	EndIf

	/*-------------------------------------------------------------|
	|salva a query na pasta sistem quando o programa for executado |
	|-------------------------------------------------------------*/
	
	MemoWrite("TTPROR03.SQL",clQuery)
	
	/*-----------------------------|
	|cria a query e dar um apelido |
	|-----------------------------*/
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,clQuery),"TRBROTA",.F.,.T.)
	
	dbSelectArea("TRBROTA")
	dbGotop()

	Do While TRBROTA->(!Eof())					    				
					
		//MsProcTxt("Processando Item "+TRBROTA->F2_XCODPA )
		DbSelectArea("TRB")
		
	/*----------------------------|
	|alimenta a tabela temporแria |
	|----------------------------*/
		
		RecLock("TRB",.T.)   
 
		TRB->FILIAL 	:= TRBROTA->UD_FILIAL
		TRB->COD_CLI	:= TRBROTA->UC_CHAVE
		TRB->NOME		:= TRBROTA->A1_NOME
		TRB->OMM		:= TRBROTA->UD_CODIGO
		TRB->ITEM		:= TRBROTA->UD_ITEM									
		TRB->PRODUTO	:= TRBROTA->UD_PRODUTO
		TRB->MODELO		:= TRBROTA->B1_ESPECIF
		TRB->FLUXO 		:= TRBROTA->Z9_DESC
		TRB->DATA_INI	:= stod(TRBROTA->UD_DATA)
		TRB->TAREFA		:= TRBROTA->UD_XTAREF
		TRB->SEQUENCIA	:= TRBROTA->UD_XTARSEQ
		TRB->DESC_TAR	:= TRBROTA->Z9_TAREFA
		TRB->AREA 		:= TRBROTA->Z9_AREA
		TRB->DATA_TAR	:= stod(TRBROTA->UD_XTARDT)
		TRB->DATA_PRE	:= stod(cvaltochar(TRBROTA->PREV))
		TRB->USUARIO	:= TRBROTA->U7_NOME		//Nome do usuario que fez a inclusao da OMM
					
		MsUnlock()	
		
		dbSelectArea("TRBROTA")
		DbSkip()
	Enddo	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINR08  บAutor  ณMicrosiga           บ Data ณ  12/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValPerg(cPerg)

PutSx1(cPerg,'01','M๊s/Ano De?','','','mv_ch1','C',7, 0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','') 
PutSx1(cPerg,'02','M๊s/Ano Ate?','','','mv_ch2','C',7, 0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','') 
PutSx1(cPerg,'03','Area?','','','mv_ch3','C',25, 0,0,'G','','','','','mv_par03',,,'','','','','','','','','','','','','','') 
PutSx1(cPerg,'04','Filial?','','','mv_ch4','C',2, 0,0,'G','','','','','mv_par04',,,'','','','','','','','','','','','','','') 

Return