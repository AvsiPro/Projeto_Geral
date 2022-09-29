
/*--------------------------|
|Biblioteca de funções		|
|--------------------------*/  
 #INCLUDE "RWMAKE.CH"      
 #INCLUDE "TOPCONN.CH"

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦TTFINR07 ¦ Autor ¦ Alexandre Venancio  ¦ Data ¦17.07.2012¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Relatório de analise de liquidez financeira  			  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ TokeTake/Estoque                                           ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

User Function TTFINR07()
	Local oReport
	If cEmpAnt == "01"
		If TRepInUse()
			oReport := ReportDef()
			oReport:PrintDialog()
		EndIf
	eNDiF
Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ReportDef	 ¦ Autor ¦ Alexandre Venancio   ¦ Data ¦26.02.2012¦¦¦
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
	Private cPerg    := "TTFINR07"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)		

	oReport := TReport():New("LIQUIDEZ","RELATORIO DE ANALISE DE LIQUIDEZ","",{|oReport| PrintReport(oReport)},"Eeste relatório tem a finalidade de analisar a liquidez dos titulos a receber")	
	
	/*--------------------------------------|
	| Seção dados dos lançamentos contábeis |
	|--------------------------------------*/
	
	oSection1 := TRSection():New(oReport,OemToAnsi("Titulos"),{"TRB"})
	
	/*------------------------------------------------------------------\
	|                       Campo   |   Alias|  Título   |   Pic|Tam	|
	\------------------------------------------------------------------*/				
	
	TRCell():New(oSection1,"TITULO"			,"TRB","TITULO"		,"@!",09)	
	TRCell():New(oSection1,"PREFIXO"		,"TRB","PREFIXO" 	,"@!",03)
	TRCell():New(oSection1,"TIPO"			,"TRB","TIPO"		,"@!",03)	
	TRCell():New(oSection1,"EMISSAO"		,"TRB","EMISSAO"	,"@!",10)	
	TRCell():New(oSection1,"CLIENTE"		,"TRB","CLIENTE"	,"@!",06)	
	TRCell():New(oSection1,"RAZAO"			,"TRB","RAZAO"		,"@!",35)	
	TRCell():New(oSection1,"FANTASIA"		,"TRB","FANTASIA"	,"@!",25)	
	TRCell():New(oSection1,"GRUPOECON"		,"TRB","GRUPOECON"	,"@!",25)		
	TRCell():New(oSection1,"VENCTOORIG"		,"TRB","VENCTOORIG"	,"@!",10)
	TRCell():New(oSection1,"VENCTOREAL"		,"TRB","VENCTOREAL"	,"@!",10)
	TRCell():New(oSection1,"VALORORIG"		,"TRB","VALORORIG"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"SALDO"			,"TRB","SALDO"		,"@E 999,999.99",16)
	TRCell():New(oSection1,"BANCO"			,"TRB","BANCO"		,"@!",03)
	TRCell():New(oSection1,"CONTA"			,"TRB","CONTA"		,"@!",10)
	TRCell():New(oSection1,"CANHOTO"		,"TRB","CANHOTO"	,"@!",10)
	TRCell():New(oSection1,"DTBAIXA"		,"TRB","DTBAIXA"	,"@!",10)
	TRCell():New(oSection1,"MOTIVOBX"		,"TRB","MOTIVOBX"   ,"@!",35)
	TRCell():New(oSection1,"NATUREZA"		,"TRB","NATUREZA"	,"@!",30)
	TRCell():New(oSection1,"TELEFONES"		,"TRB","TELEFONES"	,"@!",60)
	TRCell():New(oSection1,"ENDERECO"		,"TRB","ENDERECO"	,"@!",80)
	TRCell():New(oSection1,"OCORRENCIA"		,"TRB","OCORRENCIA"	,"@!",20)
	TRCell():New(oSection1,"EMAIL"			,"TRB","EMAIL"		,"@!",60)

	
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

	AADD(aStru, {"TITULO"   ,"C",09,0})
	AADD(aStru, {"PREFIXO"  ,"C",03,0})
	AADD(aStru, {"TIPO"	   	,"C",03,0})
	AADD(aStru, {"EMISSAO"  ,"D",10,0})
	AADD(aStru, {"CLIENTE"  ,"C",06,0})
	AADD(aStru, {"RAZAO"    ,"C",35,0})
	AADD(aStru, {"FANTASIA" ,"C",25,0})
	AADD(aStru, {"GRUPOECON","C",25,0})
	AADD(aStru, {"VENCTOORIG","D",10,0})
	AADD(aStru, {"VENCTOREAL","D",10,0})
	AADD(aStru, {"VALORORIG","N",16,2})
	AADD(aStru, {"SALDO"    ,"N",16,2})
	AADD(aStru, {"BANCO"    ,"C",03,0})
	AADD(aStru, {"CONTA"    ,"C",10,0})
	AADD(aStru, {"CANHOTO"  ,"C",10,0})
	AADD(aStru, {"DTBAIXA"  ,"D",10,0})
	AADD(aStru, {"MOTIVOBX" ,"C",35,0})
	AADD(aStru, {"NATUREZA" ,"C",30,0})
	AADD(aStru, {"TELEFONES","C",60,0})
	AADD(aStru, {"ENDERECO","C",80,0})
	AADD(aStru, {"OCORRENCIA","C",20,0})
	AADD(aStru, {"EMAIL"	,"C",60,0})

   	_cArq     := CriaTrab(aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	//IndRegua("TRB",_cIndice,"Titulos",,,"Selecionando Registros...")
	                                           
	clsql:= "SELECT E1_NUM,E1_PREFIXO,E1_TIPO,E1_EMISSAO,E1_CLIENTE,A1_NOME,A1_NREDUZ,A1_GRUECON,E1_VENCORI,E1_VENCREA,E1_VALOR,E1_SALDO,E1_PORTADO,E1_CONTA,E1_BAIXA,E1_MOTIVO,E1_NATUREZ,E5_MOTBX,A1_TEL,A1_XTEL01"
	clsql+= " ,A1_DDD,A1_XTEL02,A1_XTEL03,A1_XTELCOB,F2_XRECENT,A1_END,A1_BAIRRO,A1_MUN,A1_EMAIL"
	clsql+= " FROM "+RetSQLName("SE1")+" E1"
	clsql+= "  INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA AND A1.D_E_L_E_T_=''"
	clsql+= "  LEFT JOIN "+RetSQLName("SE5")+" E5 ON E5_NUMERO=E1_NUM AND E5_PREFIXO=E1_PREFIXO AND E5_PARCELA=E1_PARCELA AND E5_TIPO=E1_TIPO AND E5_CLIFOR=E1_CLIENTE AND E5_LOJA=E1_LOJA AND E5.D_E_L_E_T_=''"
	clsql+= "  LEFT JOIN "+RetSQLName("SF2")+" F2 ON F2_FILIAL+F2_SERIE=E1_PREFIXO AND F2_DOC=E1_NUM AND F2_EMISSAO BETWEEN '"+Dtos(MV_PAR03)+"' AND '"+Dtos(MV_PAR04)+"' AND F2.D_E_L_E_T_=''"
	clsql+= " WHERE E1_VENCTO BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"'
	clsql+= " AND E1_EMISSAO BETWEEN '"+Dtos(MV_PAR03)+"' AND '"+Dtos(MV_PAR04)+"'
	clsql+= " AND E1_BAIXA BETWEEN '"+Dtos(MV_PAR05)+"' AND '"+Dtos(MV_PAR06)+"'"
	clsql+= " AND E1_TIPO BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'"
	clsql+= " AND E1_CLIENTE BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"'"
	clsql+= " AND E1.D_E_L_E_T_=''"
	 	 	
							
	If Select("FIN01") > 0
		dbSelectArea("FIN01")
		DbCloseArea()
	EndIf
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,clSql),"FIN01",.F.,.T.)	
	
	dbSelectArea("FIN01")
	dbGotop()	
	Do While FIN01->(!Eof())
		//MsProcTxt("Processando Item "+FIN01->NOTA)
			                                                           
		DbSelectArea("TRB")			
		RecLock("TRB",.T.)		
			TRB->TITULO		:= FIN01->E1_NUM
			TRB->PREFIXO	:= FIN01->E1_PREFIXO
			TRB->TIPO		:= FIN01->E1_TIPO
			TRB->EMISSAO	:= stod(FIN01->E1_EMISSAO)
			TRB->CLIENTE	:= FIN01->E1_CLIENTE
			TRB->RAZAO		:= FIN01->A1_NOME
			TRB->FANTASIA	:= FIN01->A1_NREDUZ
			TRB->GRUPOECON	:= FIN01->A1_GRUECON+" - "+Posicione("ZZB",1,xFilial("ZZB")+FIN01->A1_GRUECON,"ZZB_DIVISA")
			TRB->VENCTOORIG	:= stod(FIN01->E1_VENCORI)
			TRB->VENCTOREAL	:= stod(FIN01->E1_VENCREA)
			TRB->VALORORIG	:= FIN01->E1_VALOR
			TRB->SALDO		:= FIN01->E1_SALDO
			TRB->BANCO		:= FIN01->E1_PORTADO
			TRB->CONTA		:= FIN01->E1_CONTA
			TRB->CANHOTO	:= FIN01->F2_XRECENT
			TRB->DTBAIXA	:= stod(FIN01->E1_BAIXA)
			TRB->MOTIVOBX	:= FIN01->E5_MOTBX						
			TRB->NATUREZA	:= Alltrim(FIN01->E1_NATUREZ)+" - "+Posicione("SED",1,xFilial("SED")+FIN01->E1_NATUREZ,"ED_DESCRIC")
			TRB->TELEFONES	:= FIN01->A1_DDD+"/"+FIN01->A1_TEL+ "/"+FIN01->A1_XTEL01+ "/"+FIN01->A1_XTEL02+ "/"+FIN01->A1_XTEL03+ "/"+FIN01->A1_XTELCOB
			TRB->ENDERECO	:= Alltrim(FIN01->A1_END)+" / "+Alltrim(FIN01->A1_BAIRRO)+" / "+Alltrim(FIN01->A1_MUN)
			TRB->OCORRENCIA	:= ''
			TRB->EMAIL		:= Alltrim(FIN01->A1_EMAIL)
		MsUnlock()
				
		dbSelectArea("FIN01")
		DbSkip() 
	Enddo		
Return

/*---------------------------------|
|Criação dos parâmetro de perguntas|
|---------------------------------*/

Static Function ValPerg(cPerg)	                                                                                                         
	PutSx1(cPerg,'01','Vencto de       	?','','','mv_ch1','D',8, 0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'02','Vencto ate      	?','','','mv_ch2','D',8, 0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')				   
	PutSx1(cPerg,'03','Emissao de   	?','','','mv_ch3','D',8,0,0,'G','','','','','mv_par03',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'04','Emissao ate   	?','','','mv_ch4','D',8,0,0,'G','','','','','mv_par04',,,'','','','','','','','','','','','','','')	            	
	PutSx1(cPerg,'05','Dt Baixa de   	?','','','mv_ch5','D',8,0,0,'G','','','','','mv_par05',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'06','Dt Baixa ate   	?','','','mv_ch6','D',8,0,0,'G','','','','','mv_par06',,,'','','','','','','','','','','','','','')	            	
	PutSx1(cPerg,'07','Tipo de		   	?','','','mv_ch7','C',03,0,0,'G','','','','','mv_par07',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'08','Tipo ate 	  	?','','','mv_ch8','C',03,0,0,'G','','','','','mv_par08',,,'','','','','','','','','','','','','','')	            	
	PutSx1(cPerg,'09','Cliente de	   	?','','','mv_ch9','C',06,0,0,'G','','','','','mv_par09',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'10','Cliente ate 	  	?','','','mv_chA','C',06,0,0,'G','','','','','mv_par10',,,'','','','','','','','','','','','','','')	            	
Return nil