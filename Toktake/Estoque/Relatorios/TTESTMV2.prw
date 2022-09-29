
/*--------------------------|
|Biblioteca de funções		|
|--------------------------*/  
 #INCLUDE "RWMAKE.CH"      
 #INCLUDE "TOPCONN.CH"

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦TTESTMV2() ¦ Autor ¦ Alexandre Venancio  ¦ Data ¦17.07.2012¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Relatório de todas as movimentações dos produtos das PAs	  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ TokeTake/Estoque                                           ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

User Function TTESTMV2()
	Local oReport
	If cEmpAnt <> "01"
		Return
	EndIf
	If TRepInUse()
		oReport := ReportDef()
		oReport:PrintDialog()
	EndIf
Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ReportDef	 ¦ Autor ¦ Fabio Sales		    ¦ Data ¦26.02.2012¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Função de impressão do relatório							  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ TokeTake/Estoqu                                      	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function ReportDef()

	Local oReport
	Local oSection
	Private cPerg    := "TTESTMV2"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)		

	oReport := TReport():New("DESPESAS","RELATORIO DE MOVIMENTACOES","",{|oReport| PrintReport(oReport)},"Eeste relatório imprimira as movimentações de saidas, entrdas e movimentações internas")	
	
	/*--------------------------------------|
	| Seção dados dos lançamentos contábeis |
	|--------------------------------------*/
	
	oSection1 := TRSection():New(oReport,OemToAnsi("Movimentações"),{"TRB"})
	
	/*------------------------------------------------------------------\
	|                       Campo   |   Alias|  Título   |   Pic|Tam	|
	\------------------------------------------------------------------*/				
	
	TRCell():New(oSection1,"FILA"		,"TRB","FILA"		,"@!",02)	
	TRCell():New(oSection1,"CLIENTE"	,"TRB","CLIENTE" 	,"@!",06)
	TRCell():New(oSection1,"LOJA"		,"TRB","LOJA"		,"@!",04)	
	TRCell():New(oSection1,"NOME"		,"TRB","NOME"		,"@!",35)	
	TRCell():New(oSection1,"DOCTO"		,"TRB","DOCTO"		,"@!",09)	
	TRCell():New(oSection1,"SERIE"		,"TRB","SERIE"		,"@!",03)	
	TRCell():New(oSection1,"CODPA"		,"TRB","CODIGO(PA)"	,"@!",06)	
	TRCell():New(oSection1,"DESCPA"		,"TRB","DESCRICAO PA","@!",25)		
	TRCell():New(oSection1,"ICMS"		,"TRB","ICMS"	,"@E 999,999.99",16)
	
Return oReport

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦PrintReport ¦ Autor ¦ Fabio Sales		    ¦ Data ¦26.06.2012¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Função responsável pela impressão do relatório			  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ TokeTake/Estoque                                     	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function PrintReport(oReport)

	Local oSection1 := oReport:Section(1)
	
/*--------------------------------------------------------------------------------|
| Selecao dos dados a Serem Impressos // Carrega o Arquivo Temporario de Trabalho |
|--------------------------------------------------------------------------------*/
		                                                                            
	 MsAguarde({|| fSelDados()},"Selecionando Itens")                               
	                              
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

/*-------------------------------------------------------------|
| Selecao dos dados a serem impressos // criacao do temporario |
|-------------------------------------------------------------*/ 

Static Function fSelDados()
 	
	/*---------------------------|     
	| Criacao arquivo de Trabalho|
	|---------------------------*/
     
	aStru	:= {} 

	AADD(aStru, {"FILA"   ,"C",02,0})
	AADD(aStru, {"CLIENTE"  ,"C",06,0})
	AADD(aStru, {"LOJA"   	,"C",04,0})
	AADD(aStru, {"NOME"   	,"C",35,0})
	AADD(aStru, {"DOCTO"  	,"C",09,0})
	AADD(aStru, {"SERIE"    ,"C",03,0})
	AADD(aStru, {"CODPA"    ,"C",06,0})
	AADD(aStru, {"DESCPA" 	,"C",25,0})
	AADD(aStru, {"ICMS"   	,"N",16,2})
		
   	_cArq     := CriaTrab(aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	//IndRegua("TRB",_cIndice,"NOTA",,,"Selecionando Registros...")
	                                           
	clsql:= "	SELECT F2_FILIAL FILA,F2_CLIENTE CLIENTE,F2_LOJA LOJA,A1_NOME NOME,F2_DOC DOCTO,F2_SERIE SERIE,F2_XCODPA CODPA,
	clsql+= "	ZZ1_DESCRI DESCPA,F2_VALICM ICMS"
	clsql+= "		FROM "+RetSQLName("SF2")+" F2" 
	clsql+= "		 INNER JOIN "+RetSQLName("SA1")+" A1 ON F2_CLIENTE=A1_COD AND F2_LOJA=A1_LOJA AND A1.D_E_L_E_T_<>'*'"
	clsql+= "		 INNER JOIN "+RetSQLName("ZZ1")+" Z1 ON F2_FILIAL=ZZ1_FILIAL AND F2_XCODPA=ZZ1_COD AND Z1.D_E_L_E_T_<>'*'"
	clsql+= "		WHERE LEFT(F2_XCODPA,1)='P' AND F2.D_E_L_E_T_=''"
	clsql+= "		AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"
	clsql+= "		AND F2_FILIAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"	 	 	
							
	If Select("JAPA01") > 0
		dbSelectArea("JAPA01")
		DbCloseArea()
	EndIf
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,clSql),"JAPA01",.F.,.T.)	
	
	dbSelectArea("JAPA01")
	dbGotop()	
	Do While JAPA01->(!Eof())
		//MsProcTxt("Processando Item "+JAPA01->NOTA)
			                                                           
		DbSelectArea("TRB")			
	     
		RecLock("TRB",.T.)		
			TRB->FILA		:= JAPA01->FILA
			TRB->CLIENTE	:= JAPA01->CLIENTE
			TRB->LOJA		:= JAPA01->LOJA
			TRB->NOME		:= JAPA01->NOME
			TRB->DOCTO		:= JAPA01->DOCTO
			TRB->SERIE		:= JAPA01->SERIE
			TRB->CODPA		:= JAPA01->CODPA
			TRB->DESCPA		:= JAPA01->DESCPA
			TRB->ICMS		:= JAPA01->ICMS
		MsUnlock()
				
		dbSelectArea("JAPA01")
		DbSkip() 
	Enddo		
Return

/*---------------------------------|
|Criação dos parâmetro de perguntas|
|---------------------------------*/

Static Function ValPerg(cPerg)	                                                                                                         
	PutSx1(cPerg,'01','Data de       	?','','','mv_ch1','D',8, 0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'02','Data ate      	?','','','mv_ch2','D',8, 0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')				   
	PutSx1(cPerg,'03','Filial  de   	?','','','mv_ch3','C',02,0,0,'G','','','','','mv_par03',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'04','Filial ate   	?','','','mv_ch4','C',02,0,0,'G','','','','','mv_par04',,,'','','','','','','','','','','','','','')	            	
Return nil
