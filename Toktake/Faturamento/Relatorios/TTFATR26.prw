
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
¦¦¦Descriçào ¦ Relatório com as notas devoluções         		          ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Faturamento                                          	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/  

User Function TTFATR26()
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
	Local clTitulo	:="DEVOLUÇÃO"
	Local clProg	:="TTFATR26"
	Private cPerg	:="TTFATR26"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New(clProg,clTitulo,cPerg,{|oReport| PrintReport(oReport)},clDesc)
	
	/*-------------------------------| 		    			           
	| seção dados das notas fiscaias | 
	|-------------------------------*/
	
	oSection1 := TRSection():New(oReport,OemToAnsi("Devolução"),{"TRB"})
	
	/*-------------------------------------------------------------------------------| 		    			           
	|						campo        alias  titulo            pic   		tam  |	  
	|-------------------------------------------------------------------------------*/

	TRCell():New(oSection1,"TIPO"	,"TRB","TIPO	"		,"@!"	,15)
	TRCell():New(oSection1,"FILIAL"	,"TRB","FILIAL	"		,"@!"	,02)
	TRCell():New(oSection1,"DTDEV"	,"TRB","DT_DEVOLUÇÃO "	,		,08)	
	TRCell():New(oSection1,"NOTA"	,"TRB","NOTA	"		,"@!"	,09)	
	TRCell():New(oSection1,"SERIE"	,"TRB","SERIE	"		,"@!"	,03)		
	TRCell():New(oSection1,"NFORI"	,"TRB","NF_ORIGEM"		,"@!"	,09)	
	TRCell():New(oSection1,"SERIORI","TRB","SERIE_ORIGEM"	,"@!"	,03)	
	TRCell():New(oSection1,"CLIENTE","TRB","CLIENTE"		,"@!"	,06)
	TRCell():New(oSection1,"LOJA"	,"TRB","LOJA"			,"@!"	,04)
	TRCell():New(oSection1,"NOME"	,"TRB","NOME"			,"@!"	,04)		
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
			
	AADD(_aStru,{"TIPO"		,"C",15,0})
	AADD(_aStru,{"FILIAL"	,"C",02,0})	
	AADD(_aStru,{"DTDEV"	,"D",08,0})
	AADD(_aStru,{"NOTA"		,"C",09,0})
	AADD(_aStru,{"SERIE"	,"C",03,0})
	AADD(_aStru,{"NFORI"	,"C",09,0})
	AADD(_aStru,{"SERIORI"	,"C",03,0})
	AADD(_aStru,{"CLIENTE"	,"C",06,0})
	AADD(_aStru,{"LOJA"		,"C",04,0})
	AADD(_aStru,{"NOME"		,"C",40,0})
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
		                                   	
	clQuery := " SELECT 'DEVOLUCAO' AS TIPO,F1_FILIAL, F1_DOC,F1_SERIE,D1_NFORI,D1_SERIORI,F1_DTDIGIT,D1_COD,B1_DESC,D1_QUANT,D1_VUNIT, "
	clQuery += " D1_FORNECE,D1_LOJA,D1_TOTAL  FROM "+RetSqlName("SF1")+" AS SF1 INNER JOIN "+RetSqlName("SD1")+" AS SD1 ON F1_FILIAL=D1_FILIAL AND "
	clQuery += " F1_DOC=D1_DOC AND F1_SERIE=D1_SERIE AND F1_FORNECE =D1_FORNECE AND F1_LOJA=D1_LOJA AND F1_DTDIGIT =D1_DTDIGIT AND F1_TIPO=D1_TIPO "
	clQuery += " INNER JOIN "+RetSqlName("SB1")+" AS SB1 ON D1_COD=B1_COD INNER JOIN "+RetSqlName("SF4")+" AS SF4 ON D1_FILIAL=F4_FILIAL AND "
	clQuery += " D1_TES=F4_CODIGO WHERE SF1.D_E_L_E_T_ ='' AND SD1.D_E_L_E_T_ ='' AND F1_DTDIGIT BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"' "
	clQuery += " AND D1_COD BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND D1_FILIAL BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND D1_TIPO='D' AND "
	clQuery += " F4_ESTOQUE='S' ORDER BY F1_DOC,F1_SERIE,D1_COD "
	
	/*--------------------------------------------|
	|verifica se a query existe, se existir fecha | 
	|--------------------------------------------*/
		
	If Select("TRBDEVE") > 0
		dbSelectArea("TRBDEVE")
		DbCloseArea()
	EndIf

	/*-------------------------------------------------------------|
	|salva a query na pasta sistem quando o programa for executado |
	|-------------------------------------------------------------*/
	
	MemoWrite("TTFATR26.SQL",clQuery)
	
	/*-----------------------------|
	|cria a query e dar um apelido |
	|-----------------------------*/
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,clQuery),"TRBDEVE",.F.,.T.)
	
	/*--------------------------------------------|
	|ajusta as casas decimais no retorno da query |
	|--------------------------------------------*/
	
	TcSetField("TRBDEVE","D1_TOTAL"		,"N",14,2)
	TcSetField("TRBDEVE","D1_QUANT"		,"N",14,2)
	TcSetField("TRBDEVE","D1_VUNIT"		,"N",14,2)
	TcSetField("TRBDEVE","F1_DTDIGIT"	,"D",08,0)	
	
	dbSelectArea("TRBDEVE")
	dbGotop()

	Do While TRBDEVE->(!Eof())					    				
					
		MsProcTxt("Processando Item "+TRBDEVE->D1_COD )
		DbSelectArea("TRB")
		
	/*----------------------------|
	|alimenta a tabela temporária |
	|----------------------------*/
		
		RecLock("TRB",.T.) 
			
		TRB->TIPO	:= TRBDEVE->TIPO
		TRB->FILIAL	:= TRBDEVE->F1_FILIAL
		TRB->DTDEV	:= TRBDEVE->F1_DTDIGIT
		TRB->NOTA	:= TRBDEVE->F1_DOC
		TRB->SERIE	:= TRBDEVE->F1_SERIE
		TRB->NFORI	:= TRBDEVE->D1_NFORI
		TRB->SERIORI:= TRBDEVE->D1_SERIORI
		TRB->CLIENTE:= TRBDEVE->D1_FORNECE
		TRB->LOJA	:= TRBDEVE->D1_LOJA
		If cEmpant=="2"
			TRB->NOME	:= Posicione("SA1",1,TRBDEVE->F1_FILIAL+TRBDEVE->D1_FORNECE+TRBDEVE->D1_LOJA,"A1_NOME")
		Else
			TRB->NOME	:= Posicione("SA1",1,Xfilial("SA1")+TRBDEVE->D1_FORNECE+TRBDEVE->D1_LOJA,"A1_NOME")
		EndIf
		TRB->PROD	:= TRBDEVE->D1_COD
		TRB->DESCRI	:= TRBDEVE->B1_DESC
		TRB->QTDE	:= TRBDEVE->D1_QUANT
		TRB->PRUNIT	:= TRBDEVE->D1_VUNIT
		TRB->TOTAL	:= TRBDEVE->D1_TOTAL
				                           	
		MsUnlock()	
		
		dbSelectArea("TRBDEVE")
		DbSkip()
	Enddo	
Return

Static Function ValPerg(cPerg)

	PutSx1(cPerg,'01','Devolução de  ?','','','mv_ch1','D',8, 0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'02','Devolução Ate ?','','','mv_ch2','D',8, 0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'03','Produto Ate 	 ?','','','mv_ch3','C',15,0,0,'G','','SB1','','','mv_par03',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'04','Produto Ate 	 ?','','','mv_ch4','C',15,0,0,'G','','SB1','','','mv_par04',,,'','','','','','','','','','','','','','')	
	PutSx1(cPerg,'05','Filial de 	 ?','','','mv_ch5','C',02,0,0,'G','','SM0','','','mv_par05',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'06','Filial Ate 	 ?','','','mv_ch6','C',02,0,0,'G','','SM0','','','mv_par06',,,'','','','','','','','','','','','','','')
		
Return