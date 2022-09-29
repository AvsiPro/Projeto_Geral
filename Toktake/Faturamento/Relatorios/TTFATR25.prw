
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
¦¦¦Função    ¦TTFATR023() ¦ Autor ¦ Fabio Sales		    ¦ Data ¦05.06.2012¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Relatório com as notas das rotas.		                  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Faturamento                                          	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/  

User Function TTFATR25()
	Local oReport
	If cEmpAnt == "01"
		If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
			oReport := ReportDef()
			oReport:PrintDialog()
		Else
			Alert("Esta opção ainda não está disponível")
		EndIf
	endif
Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦REPORTDEF ¦ Autor ¦ Fabio Sales		    ¦ Data ¦05.06.2012¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Função principal de impressão   			                  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Faturamento                                          	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/  

Static Function ReportDef()

	Local oReport
	Local oSection
	Local clDesc	:="Este relatório imprimirá somente as notas das rotas"
	Local clTitulo	:="ROTA"
	Local clProg	:="TTFATR25"
	Private cPerg	:="TTFATR25"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New(clProg,clTitulo,cPerg,{|oReport| PrintReport(oReport)},clDesc)
	
	/*-------------------------------| 		    			           
	| seção dados das notas fiscaias | 
	|-------------------------------*/
	
	oSection1 := TRSection():New(oReport,OemToAnsi("Rota"),{"TRB"})
	
	/*-------------------------------------------------------------------------------| 		    			           
	|						campo        alias  titulo            pic   		tam  |	  
	|-------------------------------------------------------------------------------*/
	                                                                    	
	TRCell():New(oSection1,"EMISSAO","TRB","EMISSAO "		,		,08)	
	TRCell():New(oSection1,"ROTA"	,"TRB","ROTA	"		,"@!"	,06)	
	TRCell():New(oSection1,"DROTA"	,"TRB","DESCR_ROTA	"	,"@!"	,30)
	TRCell():New(oSection1,"NOTA"	,"TRB","NOTA	"		,"@!"	,09)	
	TRCell():New(oSection1,"CARGA"	,"TRB","ROMANEIO"		,"@!"	,10)		
	TRCell():New(oSection1,"TRANSP"	,"TRB","TRANSPORTADORA"	,"@!"	,06)	
	TRCell():New(oSection1,"MOTOR"	,"TRB","MOTORISTA"		,"@!"	,30)	
	TRCell():New(oSection1,"PLACA"	,"TRB","PLACA	"		,"@!"	,06)	
	TRCell():New(oSection1,"PROD"	,"TRB","PRODUTO	"		,"@!"	,15)	
	TRCell():New(oSection1,"DESCRI"	,"TRB","DESCRIÇÃO"		,"@!"	,40)	
	TRCell():New(oSection1,"QTDE"	,"TRB","QUANTIDADE	"	,"@E 999,999.99",14)
	TRCell():New(oSection1,"PRUNIT"	,"TRB","PRC_UNIT	"	,"@E 999,999.99",14)
	TRCell():New(oSection1,"TOTAL"	,"TRB","TOTAL		"	,"@E 999,999.99",14)	 

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
	
	/*------------------------------| 		    			           
	|criacao do arquivo de trabalho | 
	|------------------------------*/
	
	_aStru	:= {} 
				                                                                    	
	AADD(_aStru,{"EMISSAO"	,"D",08,0})
	AADD(_aStru,{"ROTA"		,"C",06,0})
	AADD(_aStru,{"DROTA"	,"C",30,0})
	AADD(_aStru,{"NOTA"		,"C",09,0})
	AADD(_aStru,{"CARGA"	,"C",10,0})
	AADD(_aStru,{"TRANSP"	,"C",06,0})
	AADD(_aStru,{"MOTOR"	,"C",40,0})
	AADD(_aStru,{"PLACA"	,"C",08,0})
	AADD(_aStru,{"PROD"		,"C",15,0})
	AADD(_aStru,{"DESCRI"	,"C",40,0})
	AADD(_aStru,{"QTDE" 	,"N",14,2})
	AADD(_aStru,{"PRUNIT" 	,"N",14,2})
	AADD(_aStru,{"TOTAL" 	,"N",14,2})
		
	_cArq     := CriaTrab(_aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)
	
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	IndRegua("TRB",_cIndice,"NOTA",,,"Selecionando Registros...")
	
	clQuery := " SELECT F2_DOC,F2_SERIE,F2_XCODPA,F2_EMISSAO,F2_XCARGA,F2_XMOTOR,F2_TRANSP,F2_XPLACA, D2_COD,B1_DESC,D2_QUANT, "
	clQuery += " D2_PRCVEN,D2_TOTAL  FROM "+RetSqlName("SF2")+" AS SF2 INNER JOIN "+RetSqlName("SD2")+" AS SD2 ON F2_FILIAL=D2_FILIAL  "
	clQuery += " AND F2_DOC=D2_DOC AND F2_SERIE=D2_SERIE AND F2_CLIENTE =D2_CLIENTE AND F2_LOJA=D2_LOJA AND F2_EMISSAO =D2_EMISSAO AND  "
	clQuery += " F2_TIPO=D2_TIPO INNER JOIN "+RetSqlName("SB1")+" AS SB1 ON D2_COD=B1_COD  WHERE LEFT(F2_XCODPA,1)='R' AND F2_XFINAL='4' "	
	clQuery += " AND SF2.D_E_L_E_T_ ='' AND SF2.D_E_L_E_T_ ='' AND F2_EMISSAO BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"' "
	clQuery += " AND F2_XCODPA BETWEEN '"+Upper(mv_par03)+"' AND '"+Upper(mv_par04)+"' AND D2_DOC BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
	clQuery += " AND D2_COD BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' AND F2_FILIAL BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' ORDER BY "
	clQuery += " F2_EMISSAO,F2_XCODPA,F2_DOC "
	
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
	
	MemoWrite("TTFATR25.SQL",clQuery)
	
	/*-----------------------------|
	|cria a query e dar um apelido |
	|-----------------------------*/
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,clQuery),"TRBROTA",.F.,.T.)
	
	/*--------------------------------------------|
	|ajusta as casas decimais no retorno da query |
	|--------------------------------------------*/
	
	TcSetField("TRBROTA","D2_TOTAL"		,"N",14,2)
	TcSetField("TRBROTA","D2_QUANT"		,"N",14,2)
	TcSetField("TRBROTA","D2_PRCVEN"	,"N",14,2)
	TcSetField("TRBROTA","F2_EMISSAO"	,"D",08,0)	
	
	dbSelectArea("TRBROTA")
	dbGotop()

	Do While TRBROTA->(!Eof())					    				
					
		MsProcTxt("Processando Item "+TRBROTA->F2_XCODPA )
		DbSelectArea("TRB")
		
	/*----------------------------|
	|alimenta a tabela temporária |
	|----------------------------*/
		
		RecLock("TRB",.T.) 
				
		TRB->EMISSAO := TRBROTA->F2_EMISSAO
		TRB->ROTA	 := TRBROTA->F2_XCODPA									
		TRB->DROTA	 := Posicione("ZZ1",1,XFilial("ZZ1")+TRBROTA->F2_XCODPA,"ZZ1_DESCRI")		
		TRB->NOTA	 := TRBROTA->F2_DOC
		TRB->CARGA	 := TRBROTA->F2_XCARGA
		TRB->TRANSP	 := TRBROTA->F2_TRANSP
		TRB->MOTOR	 := TRBROTA->F2_XMOTOR
		TRB->PLACA	 := TRBROTA->F2_XPLACA
		TRB->PROD	 := TRBROTA->D2_COD
		TRB->DESCRI	 := TRBROTA->B1_DESC
		TRB->QTDE	 := TRBROTA->D2_QUANT
		TRB->PRUNIT	 := TRBROTA->D2_PRCVEN
		TRB->TOTAL	 := TRBROTA->D2_TOTAL
					
		MsUnlock()	
		
		dbSelectArea("TRBROTA")
		DbSkip()
	Enddo	
Return

Static Function ValPerg(cPerg)

	PutSx1(cPerg,'01','Emissão de  ?','','','mv_ch1','D',8, 0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'02','Emissão Ate ?','','','mv_ch2','D',8, 0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'03','Rota de     ?','','','mv_ch3','C',06,0,0,'G','','ZZ1','','','mv_par03',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'04','Rota Ate    ?','','','mv_ch4','C',06,0,0,'G','','ZZ1','','','mv_par04',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'05','Nota de     ?','','','mv_ch5','C',09,0,0,'G','','','','','mv_par05',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'06','Nota Ate    ?','','','mv_ch6','C',09,0,0,'G','','','','','mv_par06',,,'','','','','','','','','','','','','','')	
	PutSx1(cPerg,'07','Produto de  ?','','','mv_ch7','C',15,0,0,'G','','SB1','','','mv_par07',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'08','Produto Ate ?','','','mv_ch8','C',15,0,0,'G','','SB1','','','mv_par08',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'09','Filial de   ?','','','mv_ch9','C',02,0,0,'G','','SM0','','','mv_par09',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'10','Filial Ate  ?','','','mv_cha','C',02,0,0,'G','','SM0','','','mv_par10',,,'','','','','','','','','','','','','','')
	
Return