
/*--------------------------|
|Biblioteca de funções		|
|--------------------------*/  
 #INCLUDE "RWMAKE.CH"      
 #INCLUDE "TOPCONN.CH"

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦TTCTBR05() ¦ Autor ¦ Fabio Sales		    ¦ Data ¦28.07.2011¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Relatório de despesas de todas as empresas				  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ TokeTake/Contabilidade                                     ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

User Function TTCTBR05()
	Local oReport
	//If cEmpAnt <> "01"
	//	Return
	//EndIf
	If TRepInUse()
		oReport := ReportDef()
		oReport:PrintDialog()
	EndIf
Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ReportDef	 ¦ Autor ¦ Fabio Sales		    ¦ Data ¦28.07.2011¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Função de impressão do relatório							  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ TokeTake/Contabilidade                                 	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function ReportDef()

	Local oReport
	Local oSection
	Private cPerg    := "RELCTB"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)		

	oReport := TReport():New("DESPESAS","RELATORIO DE DESPESAS","",{|oReport| PrintReport(oReport)},"ESTE RELATORIO IMPRIME OS PLANOS DE CONTAS QUE COMEÇAM COM 3/4/5")
	
	/*--------------------------------------|
	| Seção dados dos lançamentos contábeis |
	|--------------------------------------*/
	
	oSection1 := TRSection():New(oReport,OemToAnsi("LANÇAMENTO CONTÁBEIS"),{"TRB"})
	
	/*----------------------------------------------------------------------|
	|                       Campo   |	 Alias|  Título        |   Pic|Tam	|
	|----------------------------------------------------------------------*/
				
	TRCell():New(oSection1,"CODEMP"	,"TRB","COD. EMPRESA"			,"@!",02)	
	TRCell():New(oSection1,"DESCEMP"	,"TRB","EMPRESA"			,"@!",35)
	TRCell():New(oSection1,"FILIAL"		,"TRB","FILIAL"				,"@!",02)	
	TRCell():New(oSection1,"NOMFIL"		,"TRB","DESC_FILIAL"		,"@!",35)
	TRCell():New(oSection1,"DTEMIS"		,"TRB","DATA"				,,08)
	TRCell():New(oSection1,"DOC"		,"TRB","NUM_DOCUMENTO"		,"@!",06)	
	TRCell():New(oSection1,"ATIVDEB"	,"TRB","ATIV_DEB"			,"@!",09)
	TRCell():New(oSection1,"ATIVCRED"	,"TRB","ATIV_CRED"			,"@!",09)	
	TRCell():New(oSection1,"DEBITO"		,"TRB","CONTA DEBITO"		,"@!",15)
	TRCell():New(oSection1,"DESC_DEB"	,"TRB","DESC_CONT_DEBITO"	,"@!",40)
	TRCell():New(oSection1,"CREDITO"	,"TRB","CONTA CREDITO"		,"@!",15)
	TRCell():New(oSection1,"DESC_CRED"	,"TRB","DESC_CONT_CREDITO"	,"@!",40)	
	TRCell():New(oSection1,"VRDEB"		,"TRB","VR DEBITO	"		,"@E 999,999.99",16)
	TRCell():New(oSection1,"VRCRED"		,"TRB","VR CREDITO"			,"@E 999,999.99",16)
	TRCell():New(oSection1,"HISTORICO"	,"TRB","HISTORICO"			,"@!",90)
	TRCell():New(oSection1,"CCD"		,"TRB","CENT_CUSTO_DEBITO"	,"@!",09)
	TRCell():New(oSection1,"DES_CCUSTD"	,"TRB","DESC_CCUSTO_DEBITO"	,"@!",40)
	TRCell():New(oSection1,"CCC"		,"TRB","CENT_CUSTO_CREDITO"	,"@!",09)
	TRCell():New(oSection1,"DES_CCUSTC"	,"TRB","DESC_CCUSTO_CREDITO","@!",40)	
	TRCell():New(oSection1,"ITEMD"		,"TRB","ITEM_CONTAB_DEB"	,"@!",20)
	TRCell():New(oSection1,"ITEMDR"		,"TRB","ITEM_DEB_REDUZ"		,"@!",06)	
	TRCell():New(oSection1,"DES_ITEMD"	,"TRB","DESC_ITEM_DEBITO"	,"@!",40)
	TRCell():New(oSection1,"ITEMC"		,"TRB","ITEM_CONTAB_CRED"	,"@!",20)
	TRCell():New(oSection1,"ITEMCR"		,"TRB","ITEM_CRED_REDUZ"	,"@!",06)
	TRCell():New(oSection1,"DES_ITEMC"	,"TRB","DESC_ITEM_CREDITO"	,"@!",40)
//	TRCell():New(oSection1,"DES_NEGOC"	,"TRB","DESC_ITEM_CREDITO"	,"@!",40)
	TRCell():New(oSection1,"DES_NEGOC"	,"TRB","DESC_NEGOCIO"		,"@!",50)
	TRCell():New(oSection1,"DES_AREA"	,"TRB","DESC_AREA"			,"@!",50)
	TRCell():New(oSection1,"DES_CCRED"	,"TRB","DESC_CCRED"			,"@!",50)
	TRCell():New(oSection1,"DES_GESTOR"	,"TRB","DESC_GESTOR"		,"@!",50)
			
Return oReport

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦PrintReport ¦ Autor ¦ Fabio Sales		    ¦ Data ¦27.07.2011¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Função responsável pela impressão do relatório			  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ TokeTake/Contabilidade                                  	  ¦¦¦
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
	 
/*----------------------------|
| Impressao da Primeira secao |
|----------------------------*/
	                             	                             
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
/*---------------------------*/
		
Return

/*-------------------------------------------------------------|
| Selecao dos dados a serem impressos // criacao do temporario |
|-------------------------------------------------------------*/ 

Static Function fSelDados()
Local cQuery :=""
Local clDescFil:=""
Local  clBreak :=Chr(13)  
Local cNegoc  := ""
Local cAreal  := "" 
Local aQuery  := {}
Local cCcRed	 :=SPACE(50)
Local cGestor	 :=SPACE(50)
 	
	/*---------------------------|     
	| Criacao arquivo de Trabalho|
	|---------------------------*/
     
	aStru	:= {}					

	AADD(aStru, {"CODEMP"   	,"C",02,0})
	AADD(aStru, {"DESCEMP"   	,"C",35,0})
	AADD(aStru, {"FILIAL"   	,"C",02,0})
	AADD(aStru, {"NOMFIL"   	,"C",35,0})
	AADD(aStru, {"DTEMIS"   	,"D",08,0})
	AADD(aStru, {"DEBITO"    	,"C",15,0})
	AADD(aStru, {"CREDITO"    	,"C",15,0})
	AADD(aStru, {"VRDEB"  		,"N",16,2})
	AADD(aStru, {"VRCRED"  		,"N",16,2})
	AADD(aStru, {"HISTORICO"  	,"C",90,0})	
	AADD(aStru, {"CCD"    		,"C",09,0})
	AADD(aStru, {"CCC"    		,"C",09,0})
	AADD(aStru, {"ITEMD"  		,"C",20,0})
	AADD(aStru, {"ITEMC"  		,"C",20,0})	
	AADD(aStru, {"ITEMDR"  		,"C",06,0})
	AADD(aStru, {"ITEMCR"  		,"C",06,0})	
	AADD(aStru, {"DOC"  		,"C",06,0})	
	AADD(aStru, {"ATIVDEB"  	,"C",09,0})	
	AADD(aStru, {"ATIVCRED"  	,"C",09,0})			
	AADD(aStru, {"DESC_DEB"  	,"C",40,0})	
	AADD(aStru, {"DESC_CRED"    ,"C",40,0})
	AADD(aStru, {"DES_CCUSTD"    ,"C",40,0})
	AADD(aStru, {"DES_CCUSTC"  	,"C",40,0})
	AADD(aStru, {"DES_ITEMD"  	,"C",40,0})
	AADD(aStru, {"DES_ITEMC"  	,"C",40,0})
	AADD(aStru, {"DES_NEGOC"  	,"C",50,0})
	AADD(aStru, {"DES_AREA"  	,"C",50,0})
	AADD(aStru, {"DES_CCRED"  	,"C",50,0}) 
	AADD(aStru, {"DES_GESTOR"  	,"C",50,0}) 
	
   	_cArq     := CriaTrab(aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)
	                                            
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	IndRegua("TRB",_cIndice,"DTEMIS",,,"Selecionando Registros...")
	
	/*-----------------------------------------------------------|
	| Chamada da vew para extração dos dados de todas as empresas| 
	|-----------------------------------------------------------*/			
	/*
	cQuery:=" SELECT * "
	cQuery+="		FROM DESPESA  " 
	cQuery+="			WHERE (DEBITO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' OR CREDITO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"') " 	
	cQuery+="			AND (CCD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' OR CCC BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' ) "
	cQuery+="			AND (EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"') "
	cQuery+="			AND (CODEMP BETWEEN  '"+MV_PAR07+"' AND '"+MV_PAR08+"') "
	cQuery+="			AND (FILIAL BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"') "		
	*/
	aQuery := U_TTCTBR06(MV_PAR07,MV_PAR08)
	
	For nP := 1 to len(aQuery)						
		
		If Select("DESPESA") > 0
			dbSelectArea("DESPESA")
			DbCloseArea()
		EndIf
		MemoWrite("RELCTB01.SQL",aQuery[nP]) && Salva a query no sistem para consultas futuras
		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,aQuery[nP]),"DESPESA",.F.,.T.)
		
		TcSetField("DESPESA","EMISSAO"	,"D",08,0)
		
		dbSelectArea("DESPESA")
		dbGotop()	
		Do While DESPESA->(!Eof())
			
		/*-----------------------------------------------|		
	 	|	  Posiciona e traz a descrição da filial	 |
	 	&&----------------------------------------------*/		
			If !Empty(DESPESA->FILIAL)
				DbSelectArea("SM0")                         
				_aAreaSM0:= GetArea()                       
				DbSetOrder(1)                               
				If DbSeek(DESPESA->CODEMP + DESPESA->FILIAL)
					clDescFil:=SM0->M0_FILIAL               
				EndIf                                       
				RestArea(_aAreaSM0)    		                
			Else
				clDescFil := "Matriz"
			EndIf
		&&------------------------------------------------
			If !Empty(DESPESA->CCD)
				DBSELECTAREA("CTT")                      	//
				DBSETORDER(1)                            	//
				IF DBSEEK(XFILIAL("CTT")+ DESPESA->CCD)  	//
					cNegoc	:= CTT->CTT_NEGOC
					cAreal	:= CTT->CTT_AREA
					cCcRed 	:= CTT->CTT_CCREDZ
					cGestor := CTT->CTT_XGESTO
				ENDIF
			Else
				cNegoc	:= ''
				cAreal	:= ''
				cCcRed 	:= ''
				cGestor := ''
			EndIf
			
			If !Empty(DESPESA->CCC)
				DBSELECTAREA("CTT")                      	//
				DBSETORDER(1)                                           	//
				IF DBSEEK(XFILIAL("CTT")+ DESPESA->CCC)  	//
					cNegoc	:= CTT->CTT_NEGOC
					cAreal	:= CTT->CTT_AREA
					cCcRed 	:= CTT->CTT_CCREDZ
					cGestor := CTT->CTT_XGESTO
				ENDIF
			Else
				cNegoc	:= ''
				cAreal	:= ''
				cCcRed 	:= ''
				cGestor := ''
			EndIf                                    	//
	
		                                                           
			DbSelectArea("TRB")			
		     
			RecLock("TRB",.T.)
		    TRB->CODEMP		:= DESPESA->CODEMP
			TRB->DESCEMP	:= DESPESA->EMPRESA
			TRB->FILIAL		:= DESPESA->FILIAL
			TRB->NOMFIL		:= clDescFil
			TRB->DTEMIS		:= DESPESA->EMISSAO
			TRB->DEBITO		:= DESPESA->DEBITO
			TRB->CREDITO	:= DESPESA->CREDITO
			TRB->VRDEB		:= DESPESA->VALDEB
			TRB->VRCRED		:= DESPESA->VALCRED
			TRB->HISTORICO	:= DESPESA->HISTORICO
			TRB->CCD		:= DESPESA->CCD
			TRB->CCC		:= DESPESA->CCC
			TRB->ITEMD		:= DESPESA->ITEMD
			TRB->ITEMC		:= DESPESA->ITEMC
			TRB->ITEMDR		:= Right(Trim(DESPESA->ITEMD),6)
			TRB->ITEMCR		:= Right(Trim(DESPESA->ITEMC),6)
			TRB->DOC		:= DESPESA->DOC
			TRB->ATIVDEB	:= DESPESA->ATIVDE
			TRB->ATIVCRED	:= DESPESA->ATIVCR
			TRB->DESC_DEB	:= DESPESA->DESCDEB
			TRB->DESC_CRED	:= DESPESA->DESCCRED
			TRB->DES_CCUSTD	:= DESPESA->CUSTOD
			TRB->DES_CCUSTC	:= DESPESA->CUSTOC
			TRB->DES_ITEMD	:= DESPESA->DESCITEMD
			TRB->DES_ITEMC	:= DESPESA->DESCITEMC
	 		TRB->DES_NEGOC	:= cNegoc+" - "+Posicione("SX5",1,xFilial("SX5")+"XI"+cNegoc,"X5_DESCRI")
	 		TRB->DES_AREA	:= cAreal+" - "+Posicione("SX5",1,xFilial("SX5")+"XK"+cAreal,"X5_DESCRI")
			TRB->DES_CCRED	:= cCcRed+" - "+If(cempant<>"10",Posicione("ZZH",1,xFilial("ZZH")+cCcRed,"ZZH_DESCRI"),"")
			TRB->DES_GESTOR := UsrFullName(cGestor)
	
			MsUnlock()
			
		    clDescFil  :=Space(35)	  
			cNegoc	   :=SPACE(50)
			cAreal	   :=SPACE(50) 
			cCcRed	   :=SPACE(50)
			cGestor	   :=SPACE(50)
					
			dbSelectArea("DESPESA")
			DbSkip() 
		Enddo
	Next nX		
Return

/*---------------------------------|
|Criação dos parâmetro de perguntas|
|---------------------------------*/

Static Function ValPerg(cPerg)
	                                                                                                         
	PutSx1(cPerg,'01','Data de       	?','','','mv_ch1','D',8, 0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'02','Data ate      	?','','','mv_ch2','D',8, 0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'03','Grupo de         ?','','','mv_ch3','C',15,0,0,'G','','','','','mv_par03',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'04','Grupo Ate        ?','','','mv_ch4','C',15,0,0,'G','','','','','mv_par04',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'05','C.Custo de       ?','','','mv_ch5','C',09,0,0,'G','','','','','mv_par05',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'06','C.Custo ate		?','','','mv_ch6','C',09,0,0,'G','','','','','mv_par06',,,'','','','','','','','','','','','','','')	
	PutSx1(cPerg,"07","Empresa De 		?","","","mv_ch7","C",02,00,00,"G","","","","","mv_Par07","","","","","","","","","","","","","","","","",,,,"")
	PutSx1(cPerg,"08","Empresa Ate		?","","","mv_ch8","C",02,00,00,"G","","","","","mv_Par08","","","","","","","","","","","","","","","","",,,,"")				   
	PutSx1(cPerg,'09','Filial  de   	?','','','mv_ch9','C',02,0,0,'G','','','','','mv_par09',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'10','Filial ate   	?','','','mv_chA','C',02,0,0,'G','','','','','mv_par10',,,'','','','','','','','','','','','','','')	            
	
Return nil
