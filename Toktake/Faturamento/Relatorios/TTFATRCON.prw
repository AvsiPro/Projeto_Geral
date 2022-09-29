
/*--------------------------|
|Biblioteca de funções		|
|--------------------------*/  
 #INCLUDE "RWMAKE.CH"      
 #INCLUDE "TOPCONN.CH"

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦TTFATRCON() ¦ Autor ¦ Fabio Sales		    ¦ Data ¦27.06.2012¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Relatório de conferencia de notas						  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ TokeTake/Faturamento	                                      ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

User Function TTFATRCON()
	Local oReport
	
	If cEmpAnt == "01"
		If TRepInUse()
			oReport := ReportDef()
			oReport:PrintDialog()
		EndIf
	endif
Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ReportDef	 ¦ Autor ¦ Fabio Sales		    ¦ Data ¦27.06.2012¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Função de impressão do relatório							  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ TokeTake/Faturamento		                               	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function ReportDef()

	Local oReport
	Local oSection
	Private cPerg    := "TTFATRCON"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)		

	oReport := TReport():New("TTFATRCON","CONFERENÇA DE NFS","",{|oReport| PrintReport(oReport)},"Eeste relatório imprimira as notas fiscais de saida de acordo com os parametros de usuários")	
	
	/*--------------------------------------|
	| Seção dados dos lançamentos contábeis |
	|--------------------------------------*/
	
	oSection1 := TRSection():New(oReport,OemToAnsi("Conferenças NFS"),{"TRB"})
	
	/*------------------------------------------------------------------\
	|                       Campo   |   Alias|  Título   |   Pic|Tam	|
	\------------------------------------------------------------------*/					
	
	TRCell():New(oSection1,"FILIAL"		,"TRB","FILIAL"		,"@!",02)	
	TRCell():New(oSection1,"NOTA"		,"TRB","N. FISCAL"	,"@!",09)	
	TRCell():New(oSection1,"SERIE"		,"TRB","SERIE"		,"@!",03)	
	TRCell():New(oSection1,"EMISSAO"	,"TRB","DT. EMISSAO",	 ,08)	
	TRCell():New(oSection1,"LOCALA"		,"TRB","ARMAZEM"	,"@!",06)	
	TRCell():New(oSection1,"DESCRI"		,"TRB","DESCRÇÃO"	,"@!",35)	
			
Return oReport

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦PrintReport ¦ Autor ¦ Fabio Sales		    ¦ Data ¦27.06.2012¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Função responsável pela impressão do relatório			  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ TokeTake/Faturamento                                 	  ¦¦¦
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
			
	AADD(aStru, {"FILIAL"	,"C",02,0})
	AADD(aStru, {"NOTA"  	,"C",09,0})
	AADD(aStru, {"SERIE"	,"C",03,0})
	AADD(aStru, {"EMISSAO"	,"D",08,0})
	AADD(aStru, {"LOCALA"	,"C",06,0})
	AADD(aStru, {"DESCRI"	,"C",35,0})
			
	
   	_cArq     := CriaTrab(aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)
	                                            
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	IndRegua("TRB",_cIndice,"NOTA",,,"Selecionando Registros...")
	
	/*----------------------------\
	| Itens das notas de entradas |
	\----------------------------*/				
	
	clsql := " SELECT D2_FILIAL,D2_DOC,D2_SERIE,D2_LOCAL,D2_EMISSAO,ZZ1_DESCRI, COUNT (*) FROM "+RetSqlName("SD2")+" SD2 INNER JOIN "+RetSqlName("ZZ1")+" ZZ1 ON "
	clsql += " D2_FILIAL=ZZ1_FILIAL AND D2_LOCAL=ZZ1_COD  WHERE D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND D2_FILIAL='"+xFilial("SD2")+"' "
	clsql += " AND SD2.D_E_L_E_T_ ='' AND D2_SERIE='2' AND D2_LOCAL BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' GROUP BY D2_FILIAL,D2_DOC,D2_SERIE,D2_LOCAL,D2_EMISSAO,"
	clsql += " ZZ1_DESCRI ORDER BY D2_DOC "
 
 
	If Select("MELAO") > 0
		dbSelectArea("MELAO")
		DbCloseArea()
	EndIf
	MemoWrite("MELAO.SQL",clSql) && Salva a query no sistem para consultas futuras
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,clsql),"MELAO",.F.,.T.)
	
	TcSetField("MELAO","D2_EMISSAO","D",08,0)	
	
	dbSelectArea("MELAO")
	dbGotop()	
	Do While MELAO->(!Eof())
		MsProcTxt("Processando Item "+MELAO->D2_DOC)
			                                                           
		DbSelectArea("TRB")			
	     
		RecLock("TRB",.T.)				
			TRB->FILIAL		:= MELAO->D2_FILIAL 
			TRB->NOTA		:= MELAO->D2_DOC
			TRB->SERIE		:= MELAO->D2_SERIE
			TRB->EMISSAO	:= MELAO->D2_EMISSAO			
			TRB->LOCALA		:= MELAO->D2_LOCAL
			TRB->DESCRI		:= MELAO->ZZ1_DESCRI
		MsUnlock()
				
		dbSelectArea("MELAO")
		DbSkip() 
	Enddo		
Return

/*---------------------------------|
|Criação dos parâmetro de perguntas|
|---------------------------------*/

Static Function ValPerg(cPerg)	                                                                                                         
	PutSx1(cPerg,'01','Emissao de       ?','','','mv_ch1','D',8, 0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'02','Emissao ate      ?','','','mv_ch2','D',8, 0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')				   
	PutSx1(cPerg,'03','Local   de   	?','','','mv_ch3','C',06,0,0,'G','','ZZ1','','','mv_par03',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'04','Local   ate   	?','','','mv_ch4','C',06,0,0,'G','','ZZ1','','','mv_par04',,,'','','','','','','','','','','','','','')	            	
Return nil
