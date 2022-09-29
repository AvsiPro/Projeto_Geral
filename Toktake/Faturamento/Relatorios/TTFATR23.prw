
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
¦¦¦Funçào    ¦TTFATR23() ¦ Autor ¦ Fabio Sales		    ¦ Data ¦21.12.2011¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Notas Fiscais de saídas          						  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Faturamento/TokTake                                     	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

User Function TTFATR23()
	Local oReport
	If cEmpAnt == "01"
		If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
			oReport := ReportDef()
			oReport:PrintDialog()
		EndIf
	endif
Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦REPORTDEF() ¦ Autor ¦ Fabio Sales		    ¦ Data ¦21.12.2011¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ FUNCAO PRINCIPAL DE EIMPRESSAO  							  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Faturamento/TokTake                                        ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function ReportDef()

	Local oReport
	Local oSection
	Private cPerg    := "TTFATR22"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New("TTFATR23","Notas de Saidas","",{|oReport| PrintReport(oReport)},"Este relatório imprimirar os dados das notas fiscais de saidas")
	
	/*------------------------| 		    			           
	| seção das notas fiscais | 
	|------------------------*/
	
	oSection1 := TRSection():New(oReport,OemToAnsi("Notas de Saidas"),{"TRB"})
	
	/*----------------------------------------------------------------------------------| 		    			           
	|                       campo        alias  título       	 pic           tamanho  | 
	|----------------------------------------------------------------------------------*/			

	TRCell():New(oSection1,"FILIAL"		,"TRB"  ,"FILIAL	"	,"@!"			,02)
	TRCell():New(oSection1,"CODCLI"		,"TRB"  ,"COD_CLIENTE"	,"@!"			,06)
	TRCell():New(oSection1,"LOJCLI"		,"TRB"  ,"LOJA	"		,"@!"			,04)
	TRCell():New(oSection1,"NOMECLI"	,"TRB"  ,"RAZAO SOCIAL"	,"@!"			,40)	
	TRCell():New(oSection1,"NUMPED"		,"TRB"  ,"PEDIDO	"	,"@!"			,06)	
	TRCell():New(oSection1,"ENDER"		,"TRB"  ,"ENDERECO	"	,"@!"			,35)
	TRCell():New(oSection1,"BAIRRO"		,"TRB"  ,"BAIRRO"		,"@!"			,25)
	TRCell():New(oSection1,"MUNIC"		,"TRB"  ,"MUNICIPIO"	,"@!"			,20)
	TRCell():New(oSection1,"ESTADO"		,"TRB"  ,"ESTADO"		,"@!"			,40)	
	TRCell():New(oSection1,"CEP"		,"TRB"  ,"CEP "			,"@R 99999-999",08)	
	TRCell():New(oSection1,"ROMAN"		,"TRB"  ,"ROMANEIO	"	,"@!"			,10)
	TRCell():New(oSection1,"PLACA"		,"TRB"  ,"PLACA"		,"@!"			,10)
	TRCell():New(oSection1,"MOTOR"		,"TRB"  ,"MOTORISTA"	,"@!"			,20)
	TRCell():New(oSection1,"LACRE"		,"TRB"  ,"LACRE"		,"@!"			,10)	
	TRCell():New(oSection1,"TRANSP"		,"TRB"  ,"COD_TRANSP	","@!"			,10)
	TRCell():New(oSection1,"TRANSN"		,"TRB"  ,"TRANSPORTADORA","@!"			,10)
	TRCell():New(oSection1,"NOTA"		,"TRB"  ,"NOTA"			,"@!"			,20)
	TRCell():New(oSection1,"SERIE"		,"TRB"  ,"SERIE"		,"@!"			,10)	
	TRCell():New(oSection1,"EMISSAO"	,"TRB"  ,"EMISSAO	"	,    			,08)
	TRCell():New(oSection1,"DATENTR"	,"TRB"  ,"DAT_ENTREGA"	,    			,08) 		
	TRCell():New(oSection1,"CODPA"		,"TRB"  ,"PA","@!"						,06)
	TRCell():New(oSection1,"DCODPA"		,"TRB"  ,"DESC_PA"			,"@!"		,35)
	TRCell():New(oSection1,"DTROM"		,"TRB"  ,"DAT_ROMANEIO"	,    			,08)
	TRCell():New(oSection1,"HOROM"		,"TRB"  ,"HOR_ROMANEIO"		,"@!"		,08)	
	TRCell():New(oSection1,"MENNOTA"	,"TRB"  ,"MSG_NOTA","@!"				,150)
	TRCell():New(oSection1,"GPV"		,"TRB"  ,"GPV"		,"@!"		,10)	
	
	
	
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
¦¦¦Uso       ¦ COMPRAS                                               	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function PrintReport(oReport)
	    
	Local oSection1 := oReport:Section(1)
	
	/*-----------------------------------------------------------------| 		    			           
	| seleção dos dados a serem impressos/carrega o arquivo temporário | 
	|-----------------------------------------------------------------*/
	
	MsAguarde({|| fSelDados()},"Selecionando Itens")
	
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
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
		
Return

	/*-----------------------------------------------------------| 		    			           
	| seleciona os dados a serem impressos/criacao do temporário | 
	|-----------------------------------------------------------*/ 

Static Function fSelDados() 
	
	/*-------------------------------| 		    			           
	| criação do arquivo de trabalho |
	|-------------------------------*/
	
	_aStru	:= {} 			
	
	AADD(_aStru,{"FILIAL" ,"C",02,0})
	AADD(_aStru,{"CODCLI" ,"C",06,0})
	AADD(_aStru,{"LOJCLI" ,"C",04,0})
	AADD(_aStru,{"NOMECLI","C",40,0})	
	AADD(_aStru,{"NUMPED" ,"C",06,0})	
	AADD(_aStru,{"ENDER"  ,"C",35,0})
	AADD(_aStru,{"BAIRRO" ,"C",25,0})
	AADD(_aStru,{"MUNIC"  ,"C",20,0})
	AADD(_aStru,{"ESTADO" ,"C",20,0})	
	AADD(_aStru,{"CEP"   ,"C",08,0})	
	AADD(_aStru,{"ROMAN"  ,"C",10,0})
	AADD(_aStru,{"PLACA"  ,"C",10,0})
	AADD(_aStru,{"MOTOR"  ,"C",20,0})
	AADD(_aStru,{"LACRE"  ,"C",10,0})	
	AADD(_aStru,{"TRANSP" ,"C",10,0})
	AADD(_aStru,{"TRANSN" ,"C",10,0})
	AADD(_aStru,{"NOTA"   ,"C",20,0})
	AADD(_aStru,{"SERIE"  ,"C",10,0})	
	AADD(_aStru,{"EMISSAO","D",08,0})
	AADD(_aStru,{"DATENTR","D",08,0})	
	AADD(_aStru,{"CODPA"  ,"C",06,0})
	AADD(_aStru,{"DCODPA" ,"C",35,0})
	AADD(_aStru,{"DTROM"  ,"D",08,0})    
	AADD(_aStru,{"HOROM"  ,"C",08,0}) 	
	AADD(_aStru,{"MENNOTA"  ,"C",150,0})	
	AADD(_aStru,{"GPV"  ,"C",10,0})	
			
   	_cArq     := CriaTrab(_aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)
	                                            
	If Select("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	IndRegua("TRB",_cIndice,"NOTA",,,"Selecionando Registros...")
		                     	
	_clQuery:= " SELECT  D2_FILIAL    "
	_clQuery+= "		,D2_DOC       "
	_clQuery+= "		,D2_EMISSAO   "
	_clQuery+= "		,D2_SERIE     "
	_clQuery+= "		,D2_PEDIDO    "
	_clQuery+= "		,D2_CLIENTE   "
	_clQuery+= "		,D2_LOJA      "
	_clQuery+= "		,A1_NOME      "
	_clQuery+= "		,F2_XCARGA    "
	_clQuery+= "		,F2_XPLACA    "
	_clQuery+= "		,F2_XMOTOR    "
	_clQuery+= "		,F2_XLACRE    "
	_clQuery+= "		,A1_END       "
	_clQuery+= "		,A1_BAIRRO    "
	_clQuery+= "		,A1_MUN       "
	_clQuery+= "		,A1_EST       "
	_clQuery+= "		,A1_CEP       "
	_clQuery+= "		,F2_TRANSP    "
	_clQuery+= "		,A4_NOME      "
	_clQuery+= "		,C5_XDTENTR	  "
	_clQuery+= "		,C5_XNFABAS   " 
	_clQuery+= "		,C5_XCODPA    " 
	_clQuery+= "		,C5_XDCODPA   "	
	_clQuery+= "		,F2_XDTROM    " 
	_clQuery+= "		,F2_XHORROM   "	
	_clQuery+= "		,C5_MENNOTA   " 
	_clQuery+= "		,C5_XGPV      " 
	_clQuery+= "		,COUNT(*) AS TOTAL "
	_clQuery+= "FROM "+RetSqlName("SD2")+" AS SD2  "
	_clQuery+= "INNER JOIN "+RetSqlName("SF2")+" AS SF2  "
	_clQuery+= "	ON D2_FILIAL=F2_FILIAL "
	_clQuery+= "	AND D2_DOC=F2_DOC      "
	_clQuery+= "	AND D2_CLIENTE=F2_CLIENTE "
	_clQuery+= "	AND D2_LOJA=F2_LOJA       "
	_clQuery+= "	AND D2_TIPO=F2_TIPO       "
	_clQuery+= "	AND D2_EMISSAO=F2_EMISSAO "
	_clQuery+= "LEFT OUTER JOIN "+RetSqlName("SA1")+" AS SA1 "
	_clQuery+= "	ON D2_CLIENTE=A1_COD      "
	_clQuery+= "	AND D2_LOJA=A1_LOJA       "
	_clQuery+= "INNER JOIN "+RetSqlName("SC5")+" AS SC5  "
	_clQuery+= "	ON D2_FILIAL=C5_FILIAL    "
	_clQuery+= "	AND D2_PEDIDO=C5_NUM      "
	_clQuery+= "	AND D2_CLIENTE=C5_CLIENTE "
	_clQuery+= "	AND D2_LOJA=C5_LOJACLI    "
	_clQuery+= "	AND D2_TIPO=C5_TIPO       "
	_clQuery+= "LEFT OUTER JOIN "+RetSqlName("SA4")+" AS SA4  "
	_clQuery+= "	ON F2_TRANSP =A4_COD      "
	_clQuery+= " WHERE D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"'  AND '"+DTOS(MV_PAR02)+"' "
	_clQuery+= " 	AND D2_FILIAL BETWEEN '"+MV_PAR03+"'  AND '"+MV_PAR04+"' "            
	_clQuery+= " 	AND F2_XDTROM BETWEEN '"+DTOS(MV_PAR05)+"'  AND '"+DTOS(MV_PAR06)+"' "		 
	_clQuery+= "	AND SD2.D_E_L_E_T_ ='' "
	_clQuery+= "	AND D2_SERIE = '2'  " 
	_clQuery+= "	AND D2_TIPO='N'     "
	_clQuery+= "GROUP BY D2_FILIAL      "
	_clQuery+= "	,D2_DOC             "
	_clQuery+= "	,D2_EMISSAO 	    "
	_clQuery+= "	,D2_SERIE           "
	_clQuery+= "	,D2_PEDIDO          "
	_clQuery+= "	,D2_CLIENTE         "
	_clQuery+= "	,D2_LOJA            "
	_clQuery+= "	,A1_NOME            "
	_clQuery+= "	,F2_XCARGA          "
	_clQuery+= "	,F2_XPLACA          "
	_clQuery+= "	,F2_XMOTOR          "
	_clQuery+= "	,F2_XLACRE          "
	_clQuery+= "	,A1_END             "
	_clQuery+= "	,A1_BAIRRO          "
	_clQuery+= "	,A1_MUN             "
	_clQuery+= "	,A1_EST             "
	_clQuery+= "	,A1_CEP             "
	_clQuery+= "	,F2_TRANSP          "
	_clQuery+= "	,A4_NOME            "
	_clQuery+= "	,C5_XDTENTR         " 
	_clQuery+= "	,C5_XNFABAS         " 
	_clQuery+= "	,C5_XCODPA          " 
	_clQuery+= "	,C5_XDCODPA         "	
	_clQuery+= "	,F2_XDTROM          " 
	_clQuery+= "	,F2_XHORROM         " 
	_clQuery+= "	,C5_MENNOTA         " 
	_clQuery+= "	,C5_XGPV         " 
				
	If Select("SAID") > 0
		DbSelectArea("SAID")
		DbCloseArea()
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_clQuery),"SAID",.F.,.T.)
	
	/*--------------------------------------------------| 		    			           
	| ajusta casas decimais e datas no retorno da query |
	|--------------------------------------------------*/
	
	TcSetField("SAID","D2_EMISSAO"	,"D",08,0)
	TcSetField("SAID","C5_XDTENTR"	,"D",08,0) 
	TcSetField("SAID","F2_XDTROM"	,"D",08,0) 
			
	dbSelectArea("SAID")
	dbGotop()
		
	Do While SAID->(!Eof())	
		
     	MsProcTxt("Processando Item "+SAID->D2_DOC)
	           
	    DbSelectArea("TRB")
	    
	/*--------------------------|
	| adciona registro em banco |
	|--------------------------*/
	    
	    RecLock("TRB",.T.)
		     	                   	        
		 TRB->FILIAL 	:= SAID->D2_FILIAL
		 TRB->CODCLI	:= SAID->D2_CLIENTE
		 TRB->LOJCLI	:= SAID->D2_LOJA
		 TRB->NOMECLI	:= SAID->A1_NOME
		 TRB->NUMPED	:= SAID->D2_PEDIDO
		 If SAID->C5_XNFABAS = "1" 		
 	 		DbSelectArea("ZZ1")
	 		DbSetOrder(1)
	 		DbSeek(SAID->D2_FILIAL + SAID->C5_XCODPA)	 						
			TRB->ENDER	:= alltrim(zz1->ZZ1_END)
			TRB->BAIRRO	:= alltrim(zz1->ZZ1_BAIRRO)
		 	TRB->MUNIC	:= alltrim(zz1->ZZ1_MUN)
		 	TRB->ESTADO	:= alltrim(zz1->ZZ1_EST)
		 	TRB->CEP	:= alltrim(zz1->ZZ1_CEP)
		 Else		 
			 TRB->ENDER		:= SAID->A1_END
			 TRB->BAIRRO	:= SAID->A1_BAIRRO
			 TRB->MUNIC		:= SAID->A1_MUN
			 TRB->ESTADO	:= SAID->A1_EST
			 TRB->CEP		:= SAID->A1_CEP				 
		 EndIf							
		 TRB->CEP		:= SAID->A1_CEP
		 TRB->ROMAN		:= SAID->F2_XCARGA
		 TRB->PLACA		:= SAID->F2_XPLACA
		 TRB->MOTOR		:= SAID->F2_XMOTOR
		 TRB->LACRE		:= SAID->F2_XLACRE
		 TRB->TRANSP	:= SAID->F2_TRANSP
		 TRB->TRANSN	:= SAID->A4_NOME
		 TRB->NOTA		:= SAID->D2_DOC
		 TRB->SERIE		:= SAID->D2_SERIE
		 TRB->EMISSAO	:= SAID->D2_EMISSAO
		 TRB->DATENTR	:= SAID->C5_XDTENTR 		 
		 TRB->CODPA		:= SAID->C5_XCODPA
		 TRB->DCODPA	:= SAID->C5_XDCODPA
		 TRB->DTROM		:= SAID->F2_XDTROM
		 TRB->HOROM		:= SAID->F2_XHORROM
	 	 TRB->MENNOTA	:=SAID->C5_MENNOTA
	 	 TRB->GPV       :=SAID->C5_XGPV
		             
  		SAID->(DbSkip())
	EndDo	
Return

Static Function ValPerg(cPerg)

	PutSx1(cPerg,'01','Emissao de            ?','','','mv_ch1','D',8,0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'02','Emissao Ate           ?','','','mv_ch2','D',8,0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')		
	PutSx1(cPerg,'03','Filial  de            ?','','','mv_ch3','C',02,0,0,'G','','SM0','','','mv_par03',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'04','Filial  ate           ?','','','mv_ch4','C',02,0,0,'G','','SM0','','','mv_par04',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'05','Saida de              ?','','','mv_ch5','D',8,0,0,'G','','','','','mv_par05',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'06','Saida Ate             ?','','','mv_ch6','D',8,0,0,'G','','','','','mv_par06',,,'','','','','','','','','','','','','','')
Return
