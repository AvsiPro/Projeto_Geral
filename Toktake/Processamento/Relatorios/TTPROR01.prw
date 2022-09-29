#INCLUDE "TOPCONN.CH"    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROR01  บAutor  ณAlexandre Venancio  บ Data ณ  16/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorios de consulta de patrimonios 					  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTPROR01()
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
ฑฑบPrograma  ณTTPROR01  บAutor  ณMicrosiga           บ Data ณ  12/03/12   บฑฑ
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
	Local clTitulo	:="Patrimonios"
	Local clProg	:="TTPROR01"
	Private cPerg	:="TTPROR01"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New(clProg,clTitulo,cPerg,{|oReport| PrintReport(oReport)},clDesc)
	
	oSection1 := TRSection():New(oReport,OemToAnsi("Cnab"),{"TRB"})
	
                                                                    	
	TRCell():New(oSection1,"FILIAL"		,"TRB","FILIAL"			,"@!"	,02)	
	TRCell():New(oSection1,"PATRIMONIO"	,"TRB","PATRIMONIO"		,"@!"	,06)	
	TRCell():New(oSection1,"STATUS"		,"TRB","STATUS"			,"@!"	,15)
	TRCell():New(oSection1,"PRODUTO"	,"TRB","PRODUTO"		,"@!"	,16)	
	TRCell():New(oSection1,"MODELO"		,"TRB","MODELO"			,"@!"	,40)	
	TRCell():New(oSection1,"DTCOMPRA"	,"TRB","DTCOMPRA"		,		,08)	
	TRCell():New(oSection1,"CLIENTE"	,"TRB","CLIENTE"		,"@!"	,06)	
	TRCell():New(oSection1,"LOJA"		,"TRB","LOJA"			,"@!"	,04)	
	TRCell():New(oSection1,"NOME"		,"TRB","NOME"			,"@!"	,25)	
	TRCell():New(oSection1,"LOCAL_INS"	,"TRB","LOCAL_INS"		,"@!"	,75)
	TRCell():New(oSection1,"END"   		,"TRB","END"			,"@!"	,75)
	TRCell():New(oSection1,"BAIRRO"		,"TRB","BAIRRO"			,"@!"	,75)
	TRCell():New(oSection1,"CIDADE"		,"TRB","CIDADE"			,"@!"	,75)
	TRCell():New(oSection1,"ESTADO"		,"TRB","ESTADO"			,"@!"	,02)
	TRCell():New(oSection1,"DATA_INS"	,"TRB","DATA_INS"		,		,08)
	TRCell():New(oSection1,"DATA_REM"	,"TRB","DATA_REM"		,		,08)
	TRCell():New(oSection1,"TIPO"		,"TRB","TIPO"			,"@!"	,25)
	TRCell():New(oSection1,"TIPO_SERV"	,"TRB","TIPO_SERV"		,"@!"	,25) 
	
	// pa
	TRCell():New(oSection1,"PA"			,"TRB","PA"				,"@!"	,6) 	
	TRCell():New(oSection1,"NOMEPA"		,"TRB","NOMEPA"			,"@!"	,30) 	
	TRCell():New(oSection1,"ENDPA"		,"TRB","ENDPA"			,"@!"	,30) 	
	TRCell():New(oSection1,"CIDADEPA"	,"TRB","CIDADEPA"		,"@!"	,15) 
	TRCell():New(oSection1,"UFPA"		,"TRB","UFPA"			,"@!"	,2)
	
	// secao linha categoria subgrupo
 	TRCell():New(oSection1,"SECAO"		,"TRB","SECAO"			,"@!"	,20)
 	TRCell():New(oSection1,"LINHA"		,"TRB","LINHA"			,"@!"	,20)
 	TRCell():New(oSection1,"CATEG"		,"TRB","CATEGORIA"		,"@!"	,20)
 	TRCell():New(oSection1,"SUBGRP"		,"TRB","SUB_GRUPO"		,"@!"	,20)
 	
 	TRCell():New(oSection1,"CBASE"		,"TRB","CODIGO BEM"		,"@!"	,20)
 	TRCell():New(oSection1,"DESCRI"		,"TRB","DESCRICAO"		,"@!"	,30)
 	
 	
	

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROR01  บAutor  ณMicrosiga           บ Data ณ  12/03/12   บฑฑ
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
ฑฑบPrograma  ณTTPROR01  บAutor  ณMicrosiga           บ Data ณ  12/03/12   บฑฑ
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
	
Local aStatus	:=	{"1=Disponivel","2=Em transito","3=Em cliente","4=Manutencao","5=Empenhado","6=Em remocao","7=Em Transf.","8=Baixado","9=Extraviada"}
Local aRet		:=	{}                           
Local aServico	:=	{'Locacao','Servico de Cafe','LA','SA','Kit-Lanche','Serv. Cafe + Locacao','LA + Locacao','SA + Locacao','SC tudo pago'}
Local ctpServ	:= ""
Local cStatus	:= ""

	/*------------------------------| 		    			           
	|criacao do arquivo de trabalho | 
	|------------------------------*/
	
	_aStru	:= {} 

	AADD(_aStru,{"FILIAL"	,"C",02,0})
	AADD(_aStru,{"PATRIMONIO","C",06,0})
	AADD(_aStru,{"STATUS"	,"C",15,0})
	AADD(_aStru,{"PRODUTO"	,"C",16,0})
	AADD(_aStru,{"MODELO"	,"C",40,0})
	AADD(_aStru,{"DTCOMPRA"	,"D",08,0})	
	AADD(_aStru,{"CLIENTE"	,"C",06,0})
	AADD(_aStru,{"LOJA"		,"C",04,0})
	AADD(_aStru,{"NOME"		,"C",25,0})
	AADD(_aStru,{"LOCAL_INS","C",75,2})
	AADD(_aStru,{"END"		,"C",75,0})
	AADD(_aStru,{"BAIRRO"	,"C",75,0})
	AADD(_aStru,{"CIDADE"	,"C",75,0}) 
	AADD(_aStru,{"ESTADO"	,"C",02,0})
	AADD(_aStru,{"DATA_INS" ,"D",08,0})
	AADD(_aStru,{"DATA_REM" ,"D",08,0})
	AADD(_aStru,{"TIPO"		,"C",25,0})
	AADD(_aStru,{"TIPO_SERV","C",25,0}) 
	
	AADD(_aStru,{"PA","C",6,0}) 
	AADD(_aStru,{"NOMEPA","C",30,0}) 
	AADD(_aStru,{"ENDPA","C",30,0}) 
	AADD(_aStru,{"CIDADEPA","C",15,0}) 
	AADD(_aStru,{"UFPA","C",2,0}) 
	
	// secao linha categoria  
	AADD(_aStru,{"SECAO","C",20,0})	// B1_XSECAOT 
	AADD(_aStru,{"LINHA","C",20,0})	// B1_XFAMLIT
	AADD(_aStru,{"CATEG","C",20,0})	// B1_XGRUPOT
	AADD(_aStru,{"SUBGRP","C",20,0}) // B1_XSUBGRT
	
	AADD(_aStru,{"CBASE","C",20,0})
	AADD(_aStru,{"DESCRI","C",30,0})	
	
	
			
	_cArq     := CriaTrab(_aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)
	
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	//IndRegua("TRB",_cIndice,"NOTA",,,"Selecionando Registros...")  
		
	clQuery := " SELECT N1_FILIAL,N1_CBASE,N1_DESCRIC,N1_CHAPA, N1_BAIXA, N1_XSTATTT,N1_DESCRIC,N1_XCLIENT,N1_XLOJA,"
	clQuery += "A1_NOME,A1_END,A1_BAIRRO,A1_MUN,A1_EST,N1_XLOCINS,N1_PRODUTO,N1_AQUISIC,N1_XTPSERV, "
	clQuery += "N1_XPA, ZZ1_DESCRI, ZZ1_END, ZZ1_MUN, ZZ1_EST, B1_DESC, B1_XSECAOT, B1_XFAMLIT, B1_XGRUPOT,B1_XSUBGRT "
	
	clQuery += " FROM "+RetSQLName("SN1")+" N1"   
	
	If !Empty(MV_PAR06)
		clQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_COD=N1_XCLIENT AND A1_LOJA=N1_XLOJA AND A1.D_E_L_E_T_='' AND A1_EST='"+MV_PAR06+"'"
	Else
		clQuery += " LEFT JOIN "+RetSQLName("SA1")+" A1 ON A1_COD=N1_XCLIENT AND A1_LOJA=N1_XLOJA AND A1.D_E_L_E_T_=''"
	EndIf
	
	// dados pa
	clQuery += " LEFT JOIN " +RetSqlName("ZZ1") +" ZZ1 ON ZZ1_COD = N1_XPA AND ZZ1.D_E_L_E_T_ = '' "
	        
	// dados sb1
	clQuery += " INNER JOIN " +RetSqlName("SB1") +" SB1 ON B1_COD = N1_PRODUTO AND SB1.D_E_L_E_T_ = '' "
	
	clQuery += " WHERE N1.D_E_L_E_T_=''"
	
	If !empty(MV_PAR03)
		aP := strtokarr(MV_PAR03,",")
		If len(aP) > 1 
			clQuery += " AND N1_CHAPA IN ('"
			cBar	:=	''
			For nX := 1 to len(aP)
		 		clQuery += cBar + aP[nX]
		 		cBar := "','"
		 	Next nX                        
		 	clQuery += "')"
		Else
			clQuery += " AND N1_CHAPA ='"+Alltrim(MV_PAR03)+"'"
		EndIf
	EndIf
	
	IF !Empty(MV_PAR01)
		clQuery += " AND N1_XSTATTT = '"+MV_PAR01+"'"
	EndIf
	
	IF !Empty(MV_PAR02)
		clQuery += " AND N1_XCLIENT = '"+MV_PAR02+"'"
	EndIf
	
	If MV_PAR07 == 1
		clQuery += " AND N1_PRODUTO IN(SELECT B1_COD FROM "+RetSQLName("SB1")+" WHERE B1_XSECAO='026' AND D_E_L_E_T_='')"
	EndIf
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
	
	MemoWrite("TTPROR01.SQL",clQuery)
	
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
		aRet	:=	DataIR(TRBROTA->N1_CHAPA)
		//Rodrigo solicitou a alteracao para trazer os patrimonios por data da instalacao no relatorio = Alexandre 11/02/14
		If !Empty(MV_PAR04) .AND. !EMPTY(MV_PAR05)
			If aRet[1] < MV_PAR04 .or. aRet[1] > MV_PAR05  
		   		dbSelectArea("TRBROTA")  
				DbSkip()
				loop
			EndIf
		EndIf
		    
		ctpServ := ""
		If !Empty(TRBROTA->N1_XTPSERV)		          
			ctpServ := aServico[val(TRBROTA->N1_XTPSERV)]
		EndIf
		
		
		RecLock("TRB",.T.)
		
		If !Empty(TRBROTA->N1_BAIXA)
			cStatus := "Baixado"
		Else
			cStatus := iif( !Empty(TRBROTA->N1_XSTATTT),aStatus[val(TRBROTA->N1_XSTATTT)],"" ) 
		EndIf
		   
		
		TRB->FILIAL 	:= TRBROTA->N1_FILIAL
		TRB->PATRIMONIO	:= TRBROTA->N1_CHAPA									
		TRB->STATUS	 	:= cStatus
		TRB->PRODUTO	:= TRBROTA->N1_PRODUTO
		TRB->MODELO		:= TRBROTA->B1_DESC
		TRB->DTCOMPRA	:= STOD(TRBROTA->N1_AQUISIC)
		TRB->CLIENTE 	:= TRBROTA->N1_XCLIENT
		TRB->LOJA	 	:= TRBROTA->N1_XLOJA
		TRB->NOME	 	:= TRBROTA->A1_NOME
		TRB->LOCAL_INS	:= TRBROTA->N1_XLOCINS
		TRB->END		:= TRBROTA->A1_END
		TRB->BAIRRO		:= TRBROTA->A1_BAIRRO
		TRB->CIDADE		:= TRBROTA->A1_MUN 
		TRB->ESTADO		:= TRBROTA->A1_EST
		TRB->DATA_INS 	:= aRet[1]
		TRB->DATA_REM	:= aRet[2] 
		TRB->TIPO		:= iif( !Empty(TRBROTA->N1_PRODUTO),Posicione("SB1",1,xFilial("SB1")+TRBROTA->N1_PRODUTO,"B1_XSECAOT"), "")
		TRB->TIPO_SERV	:= ctpServ
		
		TRB->PA			:= TRBROTA->N1_XPA
		TRB->NOMEPA		:= TRBROTA->ZZ1_DESCRI
		TRB->ENDPA		:= TRBROTA->ZZ1_END
		TRB->CIDADEPA	:= TRBROTA->ZZ1_MUN
		TRB->UFPA		:= TRBROTA->ZZ1_EST
		
		// secao linha categoria subgrupo
		TRB->SECAO		:= TRBROTA->B1_XSECAOT
		TRB->LINHA		:= TRBROTA->B1_XFAMLIT
		TRB->CATEG		:= TRBROTA->B1_XGRUPOT
		TRB->SUBGRP		:= TRBROTA->B1_XSUBGRT
		
		TRB->CBASE		:= TRBROTA->N1_CBASE
		TRB->DESCRI		:= TRBROTA->N1_DESCRIC
		

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

PutSx1(cPerg,'01','Status?','','','mv_ch1','C',1, 0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','')
PutSx1(cPerg,'02','Cliente?','','','mv_ch2','C',6, 0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')
PutSx1(cPerg,'03','Patrimonio?','','','mv_ch3','C',50, 0,0,'G','','','','','mv_par03',,,'','','','','','','','','','','','','','')
PutSx1(cPerg,'04','Instala็ใo de?','','','mv_ch4','D',8, 0,0,'G','','','','','mv_par04',,,'','','','','','','','','','','','','','')
PutSx1(cPerg,'05','Instala็ใo ate?','','','mv_ch5','D',8, 0,0,'G','','','','','mv_par05',,,'','','','','','','','','','','','','','')
PutSx1(cPerg,'06','Estado?','','','mv_ch6','C',2, 0,0,'G','','','','','mv_par06',,,'','','','','','','','','','','','','','')
//PutSx1(cPerg,'07','Somente Maquinas?','','','mv_ch7','N',1, 0,0,'G','','','','','mv_par06',,,'','','','','','','','','','','','','','')


Return                                        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROR01  บAutor  ณMicrosiga           บ Data ณ  07/29/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function DataIR(cPatr)
            
Local aArea	:=	GetArea()
Local cQuery
Local aRet	:=	{}
                  
cQuery := "SELECT TOP 1 ZD_CLIENTE,ZD_LOJA,ZD_DATAINS,ZD_DATAREM FROM "+RetSQLName("SZD")
cQuery += " WHERE ZD_PATRIMO='"+cPatr+"' ORDER BY R_E_C_N_O_ DESC"
            
If Select("TRB2") > 0
	dbSelectArea("TRB2")
	DbCloseArea()
EndIf

/*-------------------------------------------------------------|
|salva a query na pasta sistem quando o programa for executado |
|-------------------------------------------------------------*/

MemoWrite("TTPROR0x.SQL",cQuery)

/*-----------------------------|
|cria a query e dar um apelido |
|-----------------------------*/

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB2",.F.,.T.)

dbSelectArea("TRB2")

Aadd(aRet,STOD(TRB2->ZD_DATAINS))
Aadd(aRet,STOD(TRB2->ZD_DATAREM))


RestArea(aArea)

Return(aRet)