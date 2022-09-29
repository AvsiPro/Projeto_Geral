
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
¦¦¦Funçào    ¦TTFATR06() ¦ Autor ¦ FABIO SALES		    ¦ Data ¦17.06.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ RELATORIO DE NOTAS SEM ROMANEIO				              ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ FATURAMENTO                                          	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

User Function TTFATR06()
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
¦¦¦Funçào    ¦REPORTDEF() ¦ Autor ¦ FABIO SALES		    ¦ Data ¦17.06.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ FUNCAO PRINCIPAL D EIMPRESSÀO   							  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ FATURAMENTO                                          	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function ReportDef()

	Local oReport
	Local oSection
	Private cPerg    := "TTFAR06"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New("TTFATR06","RELATORIO DE NOTAS SEM ROMANEIO","",{|oReport| PrintReport(oReport)},"ESTE RELATORIO IMPRIMIRAR TODAS AS NOTAS QUE NAO POSSUEM ROMANEIO")
	
	/*------------------------| 		    			           
	| seção das notas fiscais | 
	|------------------------*/
	
	oSection1 := TRSection():New(oReport,OemToAnsi("NOTAS SEM ROMANEIO"),{"TRB"})
	
	/*----------------------------------------------------------------------------------| 		    			           
	|                       campo        alias  título       	 pic           tamanho  | 
	|----------------------------------------------------------------------------------*/

	TRCell():New(oSection1,"FILIAL"		,"TRB","FILIAL	"		,"@!"			,02)
	TRCell():New(oSection1,"NOTA"		,"TRB","NOTA	"		,"@!"			,09)
	TRCell():New(oSection1,"ARMAZEM"	,"TRB","ARMAZEM_SAIDA"	,"@!"			,06)
	TRCell():New(oSection1,"DESCARMS"	,"TRB","DESC_ARMAZ_SAI"	,"@!"			,30)  
	TRCell():New(oSection1,"CODPA"		,"TRB","ARMAZEM_ENTREGA","@!"			,06)
	TRCell():New(oSection1,"DESCPA"		,"TRB","DESC_ARMAZ_ENT"	,"@!"			,30)
	TRCell():New(oSection1,"PEDIDO"		,"TRB","NUM_PEDIDO"		,"@!"			,06)
	TRCell():New(oSection1,"SERIE"		,"TRB","SERIE	"		,"@!"			,03)
	TRCell():New(oSection1,"EMISSAO"	,"TRB","EMISSAO	"		,    			,08)
	TRCell():New(oSection1,"COD_CLI"	,"TRB","COD_CLIENTE"	,"@!"			,06)
	TRCell():New(oSection1,"CLIENTE"	,"TRB","CLIENTE	"		,"@!"			,40)	
	TRCell():New(oSection1,"LOJA"		,"TRB","LOJA	"		,"@!"			,04)
	TRCell():New(oSection1,"CNPJ"		,"TRB","CNPJ/CPF "		,"@R 99.999.999/9999-99",14)
	TRCell():New(oSection1,"NATUREZA"	,"TRB","NATUREZA"		,"@!"			,10)	
	TRCell():New(oSection1,"ESTADO"		,"TRB","ESTADO	"		,"@!"			,02)
	TRCell():New(oSection1,"VEND1"		,"TRB","COD_VEND	"	,"@!"			,06)
	TRCell():New(oSection1,"NOMVEND1"	,"TRB","NOME_VEND	"	,"@!"			,40)
	TRCell():New(oSection1,"ROMANEIO"	,"TRB","ROMANEIO"		,"@!"			,10)
	TRCell():New(oSection1,"FINALID"	,"TRB","FINALID_VENDA"	,"@!"			,14)
					
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
	
	/*-----------------------------------------------------------------| 		    			           
	| seleção dos dados a serem impressos/carrega o arquivo temporário | 
	|-----------------------------------------------------------------*/
	
	MsAguarde({|| fSelDados()},"Selecionando Notas")
	
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

	Local clQuery
	Local clNomVe :=SPACE(40)
	Local clDescSai
	Local clLocal :=space(06)
	Local clCodPa :=space(06)
	Local clPedido:=space(06)
	Local clDescEnt
	 
	/*-------------------------------| 		    			           
	| criação do arquivo de trabalho |
	|-------------------------------*/
	
	_aStru	:= {}
		
	AADD(_aStru,{"FILIAL","C",02,0})
	AADD(_aStru,{"NOTA","C",09,0})
	AADD(_aStru,{"ARMAZEM","C",06,0})
	AADD(_aStru,{"DESCARMS"	,"C",30,0})
	AADD(_aStru,{"CODPA","C",06,0})
	AADD(_aStru,{"DESCPA"	,"C",30,0})
	AADD(_aStru,{"PEDIDO","C",06,0})
	AADD(_aStru,{"SERIE","C",03,0})
	AADD(_aStru,{"EMISSAO","D",08,0})
	AADD(_aStru,{"COD_CLI","C",06,0})
	AADD(_aStru,{"CLIENTE","C",40,0})	
	AADD(_aStru,{"LOJA","C",04,0})
	AADD(_aStru,{"CNPJ","C",14,0})
	AADD(_aStru,{"NATUREZA","C",10,0})
	AADD(_aStru,{"ESTADO","C",02,0})	
	AADD(_aStru,{"ROMANEIO","C",10,0})
	AADD(_aStru,{"FINALID","C",14,0})
	AADD(_aStru,{"VEND1","C",06,0})
	AADD(_aStru,{"NOMVEND1","C",40,0})
		
   	_cArq     := CriaTrab(_aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)
	                                            
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	IndRegua("TRB",_cIndice,"NOTA",,,"Selecionando Registros...")
	
	/*--------------------------------------------------------------| 		    			           
	| Montagem da query com os dados das notas fiscais sem romaneio |
	|--------------------------------------------------------------*/
		
	clQuery := " SELECT F2_FILIAL,F2_DOC,F2_SERIE,F2_EMISSAO,F2_CLIENTE,F2_LOJA,F2_EST,F2_XCARGA,F2_VEND1,A1_NATUREZ,A1_NOME,A1_CGC, "
	clQuery += "		'FINALID' = CASE WHEN F2_XFINAL='1' THEN 'VENDA DIRETA'  		"
	clQuery += "						 WHEN F2_XFINAL='2' THEN 'VENDA PA' 	    	" 
	clQuery += "						 WHEN F2_XFINAL='3' THEN 'TRANFERÊNCIA'  		" 
	clQuery += "						 WHEN F2_XFINAL='4' THEN 'ABASTECIMENTO' 		" 
	clQuery += "						 WHEN F2_XFINAL='5' THEN 'OUTRAS SAIDAS' END 	"
	clQuery += " FROM "+RetSQLName("SF2")+" AS SF2 INNER JOIN "+RetSQLName("SA1")+" AS SA1 ON								"
	clQuery += " 		F2_CLIENTE = A1_COD AND F2_LOJA=A1_LOJA AND SF2.D_E_L_E_T_ = SA1.D_E_L_E_T_                         "		
	clQuery += " WHERE 	(F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"')									" 
	clQuery += " AND 	(F2_DOC BETWEEN '"+MV_PAR03+"' 	 AND '"+MV_PAR04+"') AND 											" 
	clQuery += " 		(F2_SERIE BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"') AND											" 
	clQuery += " 		F2_FILIAL ='"+xFilial("SF2")+"' AND A1_FILIAL ='"+xFilial("SA1")+"' AND								" 
	clQuery += " 		F2_XCARGA='' AND SF2.D_E_L_E_T_='' 																	"	
	
	IF SELECT("ROM") > 0
		dbSelectArea("ROM")
		DbCloseArea()
	ENDIF
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,clQuery),"ROM",.F.,.T.)// Cria a query e da um nome para a mesma
	
	TcSetField("ROM","F2_EMISSAO","D",08,0)// Ajusta o campo para data
	
	dbSelectArea("ROM")
	dbGotop()
	
	Do While ROM->(!Eof())
		
	     MsProcTxt("Processando Item "+ ROM->F2_DOC)
	     
	    DBSELECTAREA("SD2")
	    DBSETORDER(3)
	    IF DBSEEK(xFilial("SD2")+ROM->F2_DOC + ROM->F2_SERIE )
	    	clLocal	:=SD2->D2_LOCAL
	        clPedido:=SD2->D2_PEDIDO
	    ENDIF	         
	    DBSELECTAREA("SC5")
	    DBSETORDER(3) 
	    
	    IF DBSEEK(XFILIAL("SC5")+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_PEDIDO)  
	     	clCodPa:=SC5->C5_XCODPA
	    ENDIF
	        
		DBSELECTAREA("ZZ1")
		DBSETORDER(1)
		IF DBSEEK(XFILIAL("ZZ1")+ clLocal)
			clDescSai:=ZZ1_DESCRI        // descricao do local de saida
		ENDIF
		
		DBSETORDER(1)
		IF DBSEEK(XFILIAL("ZZ1")+ clCodPa)
			clDescEnt:=ZZ1_DESCRI  // Descricao da PA de entrega
		ENDIF
	     
	 	DBSELECTAREA("SA3")
		DBSETORDER(1)
		IF DBSEEK(XFILIAL("SA3")+ ROM->F2_VEND1)
			clNomVe:=SA3->A3_NOME
		ENDIF
	           
	     DbSelectArea("TRB")
	     
	/*--------------------------| 		    			           
	| adciona registro em banco | 
	|--------------------------*/
	     
	     RecLock("TRB",.T.) 
	     	     	                      
	        TRB->FILIAL   	:= ROM->F2_FILIAL
	        TRB->NOTA		:= ROM->F2_DOC 
	        TRB->PEDIDO		:= clPedido
	        TRB->SERIE		:= ROM->F2_SERIE 
	     	TRB->COD_CLI	:= ROM->F2_CLIENTE
	     	TRB->LOJA		:= ROM->F2_LOJA
	      	TRB->CLIENTE	:= ROM->A1_NOME
	      	TRB->ESTADO		:= ROM->F2_EST         	      	
	      	TRB->NATUREZA	:= ROM->A1_NATUREZ
		    TRB->CNPJ		:= ROM->A1_CGC		    	      	
	        TRB->EMISSAO	:= ROM->F2_EMISSAO 	        
	        TRB->ROMANEIO   := ROM->F2_XCARGA
	        TRB->FINALID    := ROM->FINALID
	        TRB->VEND1	    := ROM->F2_VEND1
	        TRB->NOMVEND1	:= clNomVe 
	        TRB->ARMAZEM	:= clLocal
	        TRB->DESCARMS	:= clDescSai
	        TRB->CODPA		:= clCodPa
	        TRB->DESCPA		:= clDescEnt  
	        	        	         	        	     	        
	    MsUnlock()
		clLocal :=space(06)
		clCodPa :=space(06)
		clPedido:=space(06)
	    clNomVe :=SPACE(40)
		clDescSai :="" 
		clDescEnt :=""	      	
		
	      dbSelectArea("ROM")
	     DbSkip()
	Enddo
	dtVenc:=""
	
	If Select("ROM") > 0
		dbSelectArea("ROM")
		DbCloseArea()
	EndIf
	
Return

Static Function ValPerg(cPerg)

	PutSx1(cPerg,'01','Emissão de            ?','','','mv_ch1','D',8,0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'02','Emissão Ate           ?','','','mv_ch2','D',8,0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'03','Nota de               ?','','','mv_ch3','C',09,0,0,'G','','','','','mv_par03',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'04','Nota Ate              ?','','','mv_ch4','C',09,0,0,'G','','','','','mv_par04',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'05','Serie de              ?','','','mv_ch5','C',03,0,0,'G','','','','','mv_par05',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'06','Serie Ate             ?','','','mv_ch6','C',03,0,0,'G','','','','','mv_par06',,,'','','','','','','','','','','','','','') 

Return
