
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
¦¦¦Funçào    ¦TTCTBR02() ¦ Autor ¦ FABIO SALES		    ¦ Data ¦13.05.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ RELATORIO DE DESPESAS									  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ CONTABILIDADE                                         	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

User Function TTCTBR01()
	Local oReport
	If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
		oReport := ReportDef()
		oReport:PrintDialog()	
	EndIf
Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦REPORTDEF	 ¦ Autor ¦ FABIO SALES		    ¦ Data ¦13.05.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ FUNÇÃO PRINCIPAL DE IMPRESSÃO							  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ CONTABILIDADE                                         	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function ReportDef()

	Local oReport
	Local oSection
	Private cPerg    := "DESP"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New("DESPESAS","RELATORIO DE DESPESAS","",{|oReport| PrintReport(oReport)},"ESTE RELATORIO IMPRIMIRAR OS PLANOS DE CONTAS QUE COMEÇAM COM 3/4/5")
	
	/*--------------------------------------|
	| SEÇÃO DADOS DOS LANÇAMENTOS CONTÁBEIS |
	|--------------------------------------*/
	
	oSection1 := TRSection():New(oReport,OemToAnsi("LANÇAMENTO CONTÁBEIS"),{"TRB"})
	
	/*----------------------------------------------------------------------|
	|                       CAMPO   |	 ALIAS|  TITULO        |   PIC|TAM	|
	|----------------------------------------------------------------------*/
		
	TRCell():New(oSection1,"CODEMP"		,"TRB","COD. EMPRESA"		,"@!",02)	
	TRCell():New(oSection1,"EMPRESA"	,"TRB","EMPRESA"			,"@!",35)	
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
	TRCell():New(oSection1,"HISTORICO"	,"TRB","HISTORICO"			,"@!",30)
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
	TRCell():New(oSection1,"DES_NEGOC"	,"TRB","DESC_NEGOCIO"		,"@!",50)
	TRCell():New(oSection1,"DES_AREA"	,"TRB","DESC_AREA"			,"@!",50)
	TRCell():New(oSection1,"DES_CCRED"	,"TRB","DESC_CCRED"			,"@!",50)
	TRCell():New(oSection1,"DES_GESTOR"	,"TRB","DESC_GESTOR"		,"@!",50)
		
			
Return oReport

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦PrintReport ¦ Autor ¦ FABIO SALES		    ¦ Data ¦13.05.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ FUNÇÃO RESPONSAVEL PELA IMPRESSÀO DO RELATÓRIO			  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ CONTABILIDADE                                         	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function PrintReport(oReport)

	Local oSection1 := oReport:Section(1)
	
	/*--------------------------------------------------------------------------------|
	| Selecao dos dados a Serem Impressos // Carrega o Arquivo Temporario de Trabalho |
	|--------------------------------------------------------------------------------*/
		                                                                             //   
	 MsAguarde({|| fSelDados()},"Selecionando Itens")                                //
	/*------------------------------------------------------------------------------ */
	
	 
	/*----------------------------|
	| Impressao da Primeira secao |
	|----------------------------*/
	                             //
	                             //
	DbSelectArea("TRB")          //
	DbGoTop()                    //
	oReport:SetMeter(RecCount()) //
	oSection1:Init()             //
	While  !Eof()                //
		If oReport:Cancel()      //
			Exit                 //
		EndIf                    //
		oSection1:PrintLine()    //
		DbSelectArea("TRB")      //
		DbSkip()                 //
		oReport:IncMeter()       //
	EndDo                        //
	oSection1:Finish()           //
	If Sele("TRB") <> 0          //
		TRB->(DbCloseArea())     //
	Endif                        //
	/*---------------------------*/
		
Return

/*-------------------------------------------------------------|
| Selecao dos dados a serem impressos // criacao do temporario |
|-------------------------------------------------------------*/ 

Static Function fSelDados()

    /*----------------------------
    |VARIAVEIS ADCIONAIS		 |
    |---------------------------*/
    Local clDescEmp  :=Space(35)// Descrição da Empresa de origem    
    Local clDescFil  :=Space(35)// Descrição da filial de origem    
	Local clDescCred :=SPACE(40)// DESCRICAO DA CONTA CREDITO
	Local clDescDeb  :=SPACE(40)// DESCRICAO DA CONTA DEBITO       
	Local clDescCcd  :=SPACE(40)// DESCRICAO DO CENTRO DE CUSTO DEBITO
	Local clDescCcc  :=SPACE(40)// DESCRICAO DO CENTRO DE CUSTO CREDITO
	Local clDescIted :=SPACE(40)// DESCRICAO DO ITEM CONTABIL DEBITO
	Local clDescItec :=SPACE(40)// DESCRICAO DO ITEM CONTABIL CREDITO  
	Local cNegoc     :=SPACE(50)
	Local cAreal     :=SPACE(50)    
	Local cCcRed	 :=SPACE(50)
	Local cGestor	 :=SPACE(50)
	Local cDescCC := ""
	/*--------------------------*/
	
	/*---------------------------|     
	| Criacao arquivo de Trabalho|
	|---------------------------*/
     
	aStru	:= {}
	AADD(aStru, {"CODEMP"   	,"C",02,0})
	AADD(aStru, {"EMPRESA"   	,"C",35,0})
	AADD(aStru, {"FILIAL"   	,"C",02,0})
	AADD(aStru, {"NOMFIL"   	,"C",35,0})
	AADD(aStru, {"DTEMIS"   	,"D",08,0})
	AADD(aStru, {"DEBITO"    	,"C",15,0})
	AADD(aStru, {"CREDITO"    	,"C",15,0})
	AADD(aStru, {"VRDEB"  		,"N",16,2})
	AADD(aStru, {"VRCRED"  		,"N",16,2})
	AADD(aStru, {"HISTORICO"  	,"C",30,0})	
	AADD(aStru, {"CCD"    		,"C",09,0})
	AADD(aStru, {"CCC"    		,"C",09,0})
	AADD(aStru, {"ITEMD"  		,"C",20,0})
	AADD(aStru, {"ITEMC"  		,"C",20,0})
	
	AADD(aStru, {"ITEMDR"  		,"C",06,0})
	AADD(aStru, {"ITEMCR"  		,"C",06,0})
	
	AADD(aStru, {"DOC"  		,"C",06,0})
	
	AADD(aStru, {"ATIVDEB"  	,"C",09,0})	
	AADD(aStru, {"ATIVCRED"  		,"C",09,0})	
		
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
	
	/*--------------------------------------------------------------------------------------------|
	| MONTAGEM DA QUERY PARA EXTRAIR AS CONTAS CONTABEIS DE IMPOSTOS E DADOS REFERENTES AS MESMAS.| 
	|--------------------------------------------------------------------------------------------*/ 		
	
	cQuery := " SELECT 	CT2_EMPORI,CT2_FILORI, CT2_DATA AS DTEMIS,CT2_DOC,CT2_CCD,CT2_CCC,CT2_ITEMD,CT2_ITEMC, CT2_HIST AS HISTORICO,CT2_LP AS LP,CT2_ATIVDE,CT2_ATIVCR, "
	cQuery += " 'VRDEB'  = CASE WHEN ( CT2_DEBITO LIKE '3%' OR CT2_DEBITO LIKE '4%' OR CT2_DEBITO LIKE '5%') THEN CT2_VALOR ELSE 0 END, "
	cQuery += " 'VRCRED' = CASE WHEN ( CT2_CREDIT LIKE '3%' OR CT2_CREDIT LIKE '4%' OR CT2_CREDIT LIKE '5%') THEN CT2_VALOR ELSE 0 END, " 
	cQuery += " 'DEBITO' = CASE WHEN ( CT2_DEBITO LIKE '3%' OR CT2_DEBITO LIKE '4%' OR CT2_DEBITO LIKE '5%') THEN CT2_DEBITO ELSE '' END, "
	cQuery += " 'CREDITO'= CASE WHEN ( CT2_CREDIT LIKE '3%' OR CT2_CREDIT LIKE '4%' OR CT2_CREDIT LIKE '5%') THEN CT2_CREDIT ELSE '' END " 
	cQuery += " FROM "+RetSqlName("CT2")+" AS CT2 "
	cQuery += " WHERE  CT2.D_E_L_E_T_ <> '*' AND CT2_DC IN ('1','2','3')AND "  
	cQuery += " (( CT2_DEBITO LIKE '3%' OR CT2_DEBITO LIKE '4%' OR CT2_DEBITO LIKE '5%') OR ( CT2_CREDIT LIKE '3%' OR CT2_CREDIT LIKE '4%' OR CT2_CREDIT LIKE '5%')) "
	cQuery += " AND (CT2_DEBITO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' OR CT2_CREDIT BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' ) AND  "
	cQuery += " CT2_FILIAL='"+xFilial("CT2")+"'AND  CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
	cQuery += " AND (CT2_CCD BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' OR CT2_CCC BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' ) "
	cQuery += " AND (CT2_FILORI BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"') "
	cQuery += " ORDER BY CT2_DATA,CT2_DOC " 
	
	
	IF SELECT("DESP") > 0
		dbSelectArea("DESP")
		DbCloseArea()
	ENDIF
	MemoWrite("TTCTBR01.SQL",cQuery)//SALVA A QUERY NA PASTA SISTEM PARA CONSULTAS FUTURA
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"DESP",.F.,.T.)
	
	TcSetField("DESP","DTEMIS"	,"D",08,0)
	
	dbSelectArea("DESP")
	dbGotop()
	
	Do While DESP->(!Eof())
	
	/*-----------------------------------------------|
	|	POSICIONA E EXTRAI A DESCRICAO DA CONTA CONT |
	|-----------------------------------------------*/
	                                             	//
		DBSELECTAREA("CT1")                      	//
		DBSETORDER(1)                            	//
		IF DBSEEK(XFILIAL("CT1")+ DESP->DEBITO)     //
			clDescDeb:=CT1->CT1_DESC01           	//
		ENDIF                                    	//
		IF DBSEEK(XFILIAL("CT1")+ DESP->CREDITO)    //
			clDescCred:=CT1->CT1_DESC01          	//
		ENDIF                                    	//
	//------------------------------------------------
 
                                                 
	/*-----------------------------------------------|		
	|	POSICIONA E EXTRAI A DESCRICAO DO CENTRO CUST|
	|-----------------------------------------------*/		
		DBSELECTAREA("CTT")                      	//
		DBSETORDER(1)                            	//
		IF DBSEEK(XFILIAL("CTT")+ DESP->CT2_CCD)  	//
			clDescCcd:=CTT->CTT_DESC01           	//
			cNegoc	:= CTT->CTT_NEGOC
			cAreal	:= CTT->CTT_AREA
			cCcRed 	:= CTT->CTT_CCREDZ
			cGestor := If(cEmpAnt == "01" .or. cEmpAnt=="02",CTT->CTT_XGESTO,"")
		ENDIF                                    	//
		IF DBSEEK(XFILIAL("CTT")+ DESP->CT2_CCC)  	//
			clDescCcc:=CTT->CTT_DESC01           	//
			cNegoc	:= CTT->CTT_NEGOC
			cAreal	:= CTT->CTT_AREA
			cCcRed	:= CTT->CTT_CCREDZ
			cGestor := If(cEmpAnt == "01" .or. cEmpAnt=="02",CTT->CTT_XGESTO,"")			
		ENDIF                                    	//
	//------------------------------------------------
 
 		                                         
 	/*-----------------------------------------------|		
 	|	POSICIONA E EXTRAI E DESCRICAO DOS ITENC CONT|
 	|-----------------------------------------------*/		
		DBSELECTAREA("CTD")                      	//
		DBSETORDER(1)                            	//
		IF DBSEEK(XFILIAL("CTD")+ DESP->CT2_ITEMD)	// 
			clDescIted:=CTD->CTD_DESC01         	//
		ENDIF                                    	//
		IF DBSEEK(XFILIAL("CTD")+ DESP->CT2_ITEMC)	//
			clDescItec:=CTD->CTD_DESC01         	//
		ENDIF                                    	//
	//------------------------------------------------
	  
	
	/*-----------------------------------------------|		
 	|	  Posiciona e traz a descrição da filial	 |
 	|-----------------------------------------------*/		
		DbSelectArea("SM0")                         //
		_aAreaSM0:= GetArea()                       //
		DBSETORDER(1)                               //
		IF DBSEEK(cEmpAnt + DESP->CT2_FILORI)       //
			clDescFil:= SM0->M0_FILIAL              //
			clDescEmp:= SM0->M0_NOME                //
		ENDIF                                       //
		RestArea(_aAreaSM0)    		                //
	//------------------------------------------------
	                                                
           
		DbSelectArea("TRB")
	     
		RecLock("TRB",.T.)                  
	    TRB->CODEMP		:= DESP->CT2_EMPORI
		TRB->EMPRESA	:= clDescEmp 
		TRB->FILIAL		:= DESP->CT2_FILORI		
		TRB->NOMFIL		:= clDescFil		
		TRB->DTEMIS		:= DESP->DTEMIS
		TRB->DEBITO		:= DESP->DEBITO
		TRB->CREDITO	:= DESP->CREDITO
		TRB->VRDEB		:= DESP->VRDEB
		TRB->VRCRED		:= DESP->VRCRED
		TRB->HISTORICO	:= DESP->HISTORICO 
		TRB->CCD		:= DESP->CT2_CCD
		TRB->CCC		:= DESP->CT2_CCC
		TRB->ITEMD		:= DESP->CT2_ITEMD
		TRB->ITEMC		:= DESP->CT2_ITEMC		
		TRB->ITEMDR		:= Right(Trim(DESP->CT2_ITEMD),6)
		TRB->ITEMCR		:= Right(Trim(DESP->CT2_ITEMC),6)
		TRB->DOC		:= DESP->CT2_DOC				
		TRB->ATIVDEB		:= DESP->CT2_ATIVDE		
		TRB->ATIVCRED		:= DESP->CT2_ATIVCR				
		TRB->DESC_DEB	:= clDescDeb
		TRB->DESC_CRED	:= clDescCred		
		TRB->DES_CCUSTD	:= clDescCcd
		TRB->DES_CCUSTC	:= clDescCcc
		TRB->DES_ITEMD	:= clDescIted
		TRB->DES_ITEMC	:= clDescItec
		TRB->DES_NEGOC	:= cNegoc+" - "+Posicione("SX5",1,xFilial("SX5")+"XI"+cNegoc,"X5_DESCRI")
		TRB->DES_AREA  	:= cAreal+" - "+Posicione("SX5",1,xFilial("SX5")+"XK"+cAreal,"X5_DESCRI")
		//TRB->DES_CCRED	:= cCcRed+" - "+Posicione("ZZH",1,xFilial("ZZH")+cCcRed,"ZZH_DESCRI")
		cDescCC := RetCC(cCcRed)
		TRB->DES_CCRED	:= cCcRed+" - "+cDescCC
		TRB->DES_GESTOR := UsrFullName(cGestor)

		MsUnlock()
		
	    clDescFil  :=Space(35)
	    clDescEmp  :=Space(35)
		clDescCred :=SPACE(40)
		clDescDeb  :=SPACE(40)       
		clDescCcd  :=SPACE(40)
		clDescCcc  :=SPACE(40)
		clDescIted :=SPACE(40)
		clDescItec :=SPACE(40)
		cNegoc	   :=SPACE(50)
		cAreal	   :=SPACE(50) 
		cCcRed	   :=SPACE(50)
		cGestor	   :=SPACE(50)
			
		dbSelectArea("DESP")
		DbSkip() // Pula para o próximo registro
	Enddo
	
	If Select("DESP") > 0
		dbSelectArea("DESP")
		DbCloseArea()
	EndIf
	
Return

/*------------------------------------------------------------|
|CRIAÇÃO DOS PARAMETROS PARA DEFINIÇÃO DAS PERGUNTAS		  |
|------------------------------------------------------------*/

Static Function ValPerg(cPerg)

	PutSx1(cPerg,'01','Data de            ?','','','mv_ch1','D',8,0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'02','Data ate           ?','','','mv_ch2','D',8,0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'03','Grupo de           ?','','','mv_ch3','C',15,0,0,'G','','CT1','','','mv_par03',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'04','Grupo ate          ?','','','mv_ch4','C',15,0,0,'G','','CT1','','','mv_par04',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'05','C.custo de         ?','','','mv_ch5','C',09,0,0,'G','','CTT','','','mv_par05',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'06','C.Custo ate        ?','','','mv_ch6','C',09,0,0,'G','','CTT','','','mv_par06',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'07','Filial de          ?','','','mv_ch7','C',02,0,0,'G','','SM0','','','mv_par07',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'08','Filial ate         ?','','','mv_ch8','C',02,0,0,'G','','SM0','','','mv_par08',,,'','','','','','','','','','','','','','')

Return nil


Static Function RetCC(cCcRed)

Local cQuery
cQuery := "SELECT ZZH_DESCRI FROM ZZH010 WHERE ZZH_CODIGO = '"+cCcRed+"' AND D_E_L_E_T_ = '' "
If Select("TRBCC") > 0
	TRBCC->(dbCloseArea())
EndIf                     
tcquery cquery new alias "TRBCC"

dbSelectArea("TRBCC")     
     
Return TRBCC->ZZH_DESCRI
