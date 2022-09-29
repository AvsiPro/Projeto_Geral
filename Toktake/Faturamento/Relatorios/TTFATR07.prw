  
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
¦¦¦Funçào    ¦TTFATR07() ¦ Autor ¦ FABIO SALES		    ¦ Data ¦17.06.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ ITENS DE VENDAS x SALDOS EM ESTOQUE						  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ FATURAMENTO                                          	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/  

User Function TTFATR07()
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
	Private cPerg    := "TTFAT07"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New("TTFATR07","RELATORIO DE PEDIDO DE VENDAS EM ABERTO","",{|oReport| PrintReport(oReport)},"ESTE RELATORIO IMPRIMIRAR TODOS OS PEDIDO DE VENDAS EM ABERTO OU PACIALMENTE ABERTO")
	
	/*------------------------| 		    			           
	| seção das notas fiscais | 
	|------------------------*/ 
	
	oSection1 := TRSection():New(oReport,OemToAnsi("PEDIDOS DE VENDAS"),{"TRB"})
	
	/*----------------------------------------------------------------------------------| 		    			           
	|                       campo        alias  título       	 pic           tamanho  | 
	|----------------------------------------------------------------------------------*/
	
	TRCell():New(oSection1,"TIPO"		,"TRB","FINALIDAD_PED"	,"@!"			,15)
	TRCell():New(oSection1,"EMISSAO"	,"TRB","EMISSAO 	"	,				,08)
	TRCell():New(oSection1,"ENTREGA"	,"TRB","ENTREGA 	"	,				,08)
	TRCell():New(oSection1,"FILIAL"		,"TRB","FILIAL		"	,"@!"			,02)
	TRCell():New(oSection1,"PEDIDO"		,"TRB","PEDIDO		"	,"@!"			,06)
	TRCell():New(oSection1,"CLIENTE"	,"TRB","CLIENTE		"	,"@!"			,06)
	TRCell():New(oSection1,"LOJACLI"	,"TRB","LOJACLI		"	,"@!"			,04)
	TRCell():New(oSection1,"NOMECLI"	,"TRB","NOMECLI		"	,"@!"			,40)	
	TRCell():New(oSection1,"ARM_SAI"	,"TRB","ARMAZEM_SAIDA"	,"@!"			,06)
	TRCell():New(oSection1,"DESCARMS"	,"TRB","DESC_ARM_SAIDA"	,"@!"			,30)	 
	TRCell():New(oSection1,"ARM_ENT"	,"TRB","ARMAZEM_ENTREGA","@!"			,06)
	TRCell():New(oSection1,"DESCARME"	,"TRB","DESC_ARMAZEM"	,"@!"			,30)
	TRCell():New(oSection1,"CTRANSP"	,"TRB","TRANSPORTADORA"	,"@!"			,06)
	TRCell():New(oSection1,"DTRANSP"	,"TRB","DESC_TRANSP	"	,"@!"			,15)	
	TRCell():New(oSection1,"PRODUTO"	,"TRB","PRODUTO		"	,"@!"			,15)
	TRCell():New(oSection1,"DESCPROD"	,"TRB","DESC_PROD	"	,"@!"			,30)
	TRCell():New(oSection1,"QUANTPED"	,"TRB","QUANT_PED	"	,"@E 999,999,999.99",14)
	TRCell():New(oSection1,"QUANTEST"	,"TRB","QUANT_ESTOQUE"	,"@E 999,999,999.99",14)
	TRCell():New(oSection1,"PRCVEN"		,"TRB","PREÇO_UNITÁRIO" ,"@E 999,999,999.99",14)
	TRCell():New(oSection1,"VALOR"		,"TRB","TOATL"			,"@E 999,999,999.99",14)
	TRCell():New(oSection1,"QUANTENT"	,"TRB","QUANT_ENTREGUE"	,"@E 999,999,999.99",14)
	TRCell():New(oSection1,"DIVPEDENT"	,"TRB","PEDIDO - ENTREGA","@E 999,999,999.99",14)				
	TRCell():New(oSection1,"DIFERENCA"	,"TRB","PEDIDO - ESTOQUE","@E 999,999,999.99",14)
					
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
	
	MsAguarde({|| fSelDados()},"Selecionando Pedidos")
	
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
	Local clTransp:=SPACE(15)
	Local clArmEnt:=SPACE(30)
	Local clArmHSai:=SPACE(30)	      	
	 
	/*-------------------------------| 		    			           
	| criação do arquivo de trabalho | 
	|-------------------------------*/
	
	_aStru	:= {}
	
	AADD(_aStru,{"FILIAL"	,"C",02,0})
	AADD(_aStru,{"PEDIDO"	,"C",06,0})
	AADD(_aStru,{"TIPO"		,"C",15,0})
	AADD(_aStru,{"CLIENTE"	,"C",06,0})	
	AADD(_aStru,{"LOJACLI"	,"C",04,0})
	AADD(_aStru,{"NOMECLI"	,"C",40,0})
	AADD(_aStru,{"PRODUTO"	,"C",15,0})
	AADD(_aStru,{"DESCPROD"	,"C",30,0})
	AADD(_aStru,{"QUANTPED"	,"N",14,2})
	AADD(_aStru,{"QUANTEST"	,"N",14,2})
	AADD(_aStru,{"QUANTENT"	,"N",14,2})
	AADD(_aStru,{"DIVPEDENT","N",14,2})				
	AADD(_aStru,{"DIFERENCA","N",14,2})		
	AADD(_aStru,{"PRCVEN"	,"N",14,2})				
	AADD(_aStru,{"VALOR"	,"N",14,2})	
	AADD(_aStru,{"ARM_SAI"	,"C ",06,0})
	AADD(_aStru,{"DESCARMS"	,"C",30,0})	
	AADD(_aStru,{"ARM_ENT"	,"C ",06,0})
	AADD(_aStru,{"DESCARME"	,"C",30,0})
	AADD(_aStru,{"CTRANSP"	,"C ",06,0})
	AADD(_aStru,{"DTRANSP"	,"C",15,0})	
	AADD(_aStru,{"EMISSAO"	,"D",08,0})
	AADD(_aStru,{"ENTREGA"	,"D",08,0})
			
   	_cArq     := CriaTrab(_aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)
	                                            
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	IndRegua("TRB",_cIndice,"PEDIDO",,,"Selecionando Registros...")
	
	/*-----------------------------------------------------------------------------------------| 		    			           
	| Montagem da query com os dados dos pedidos de vendas e os seus devidos saldos em estoque | 
	|-----------------------------------------------------------------------------------------*/
	
	clQuery := " SELECT C6_FILIAL,C6_NUM,C6_CLI,C6_LOJA,A1_NOME,C6_PRODUTO,C6_DESCRI,C6_QTDVEN,C6_QTDENT,(C6_QTDVEN-C6_QTDENT)AS DIV,B2_QATU,(B2_QATU-C6_QTDVEN) AS DIVER, "
	clQuery += "		C6_LOCAL,C5_EMISSAO,C5_XDTENTR,C5_XCODPA,C5_TRANSP,C6_PRCVEN,C6_VALOR, "
	clQuery += " 		'TIPO' =CASE WHEN C5_XFINAL='1' THEN 'VENDA DIRETA' ELSE CASE WHEN C5_XFINAL='2' THEN 'VENDA PA' ELSE CASE WHEN C5_XFINAL='3' " 
	clQuery += " THEN 'TRANFERÊNCIA' ELSE CASE WHEN C5_XFINAL='4' THEN 'ABASTECIMENTO' ELSE 'OUTRAS SAIDAS' END END END END " 
	clQuery += " FROM 	"+RetSQLName("SC6")+" AS SC6 INNER JOIN "+RetSQLName("SC5")+" AS SC5 ON					"
	clQuery += " 		C6_FILIAL=C5_FILIAL AND C6_NUM=C5_NUM AND C6_CLI=C5_CLIENTE AND C6_LOJA=C5_LOJACLI 		"
	clQuery += " INNER JOIN "+RetSQLName("SB2")+" AS SB2 ON 	C6_FILIAL=B2_FILIAL AND                         "
	clQuery += "		C6_PRODUTO=B2_COD AND C6_LOCAL=B2_LOCAL INNER JOIN "+RetSqlName("SA1")+" AS SA1 ON		"
	clQuery += "		C6_CLI=A1_COD AND C6_LOJA=A1_LOJA														"
	clQuery += " WHERE 	(C5_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"')						"
	clQuery += " AND	(C5_XDTENTR BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"')						"
	clQuery += " AND 	(C6_NUM BETWEEN '"+MV_PAR05+"' 	 AND '"+MV_PAR06+"')	AND								"
	clQuery += " 		(C6_CLI BETWEEN '"+MV_PAR07+"'   AND '"+MV_PAR08+"') 	AND						    	"
	clQuery += " 		(C6_LOJA BETWEEN '"+MV_PAR09+"'  AND '"+MV_PAR10+"') 	AND						    	"
	clQuery += " 		 C6_FILIAL ='"+xFilial("SC6")+"' AND B2_FILIAL ='"+xFilial("SB2")+"' AND				"
	clQuery += " 		 C5_FILIAL ='"+xFilial("SC5")+"' AND A1_FILIAL ='"+xFilial("SA1")+"' AND				"	 
	
    IF MV_PAR11==1
    	clQuery += " C6_QTDENT=0 AND C6_BLQ='' "
    ELSEIF MV_PAR11==2
    	clQuery += " C6_BLQ='' AND C6_QTDVEN > C6_QTDENT  AND C6_QTDENT<>0 "
    ELSEIF MV_PAR11==3
    	clQuery += " ((C6_QTDENT=0 AND C6_BLQ='') OR (C6_BLQ ='' AND C6_QTDVEN > C6_QTDENT AND C6_QTDENT<>0)) "
    ENDIF
    
	clQuery += " AND SC6.D_E_L_E_T_='' AND SB2.D_E_L_E_T_='' AND SC5.D_E_L_E_T_='' AND SA1.D_E_L_E_T_=''	 "
	clQuery += " ORDER BY C6_NUM,C6_PRODUTO " 
	
	IF SELECT("ROM") > 0
		dbSelectArea("ROM")
		DbCloseArea()
	ENDIF
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,clQuery),"ROM",.F.,.T.)
   
	/*--------------------------------------------------| 		    			           
	| ajusta casas decimais e datas no retorno da query | 
	|--------------------------------------------------*/
		
	TcSetField("ROM","C5_EMISSAO","D",08,0)
	TcSetField("ROM","C5_XDTENTR","D",08,0)
	TcSetField("ROM","C6_QTDVEN" ,"N",14,2)
	TcSetField("ROM","B2_QATU"   ,"N",14,2)
	TcSetField("ROM","C6_QTDENT" ,"N",14,2)
	TcSetField("ROM","C6_PRCVEN"   ,"N",14,2)
	TcSetField("ROM","C6_VALOR" ,"N",14,2)
	
	
	dbSelectArea("ROM")
	dbGotop()
	
	Do While ROM->(!Eof())
	
		DBSELECTAREA("ZZ1")
		DBSETORDER(1)
		IF DBSEEK(XFILIAL("ZZ1")+ ROM->C5_XCODPA)
			clArmEnt:=ZZ1_DESCRI
		ENDIF
		IF DBSEEK(XFILIAL("ZZ1")+ ROM->C6_LOCAL)
			clArmSai:=ZZ1_DESCRI
		ENDIF  
		
		DBSELECTAREA("SA4")
		DBSETORDER(1)
		IF DBSEEK(XFILIAL("SA4")+ ROM->C5_TRANSP)
			clTransp:=SA4->A4_NREDUZ
		ENDIF
		
	     MsProcTxt("Processando Item "+ ROM->C6_PRODUTO)	    
	           
	     DbSelectArea("TRB")
	     
	/*--------------------------| 		    			           
	| adciona registro em banco | 
	|--------------------------*/
	     	     
		RecLock("TRB",.T.)
	     	     	     	                      
	        TRB->FILIAL   	:= ROM->C6_FILIAL
	        TRB->PEDIDO		:= ROM->C6_NUM
	        TRB->TIPO		:= ROM->TIPO
	        TRB->CLIENTE	:= ROM->C6_CLI
	        TRB->LOJACLI	:= ROM->C6_LOJA
	        TRB->NOMECLI	:= ROM->A1_NOME  
	        TRB->PRODUTO	:= ROM->C6_PRODUTO 
	     	TRB->DESCPROD	:= ROM->C6_DESCRI
	     	TRB->QUANTPED	:= ROM->C6_QTDVEN
	      	TRB->QUANTEST	:= ROM->B2_QATU
	      	TRB->QUANTENT	:= ROM->C6_QTDENT	
	      	TRB->PRCVEN		:= ROM->C6_PRCVEN
	      	TRB->VALOR		:= ROM->C6_VALOR
	      	TRB->DIVPEDENT	:= ROM->DIV
	      	TRB->DIFERENCA	:= ROM->DIVER	         	      	
	      	TRB->EMISSAO	:= ROM->C5_EMISSAO 
	      	TRB->ENTREGA	:= ROM->C5_XDTENTR  	
	      	TRB->ARM_ENT	:= ROM->C5_XCODPA
	      	TRB->DESCARME	:= clArmEnt	      	
	      	TRB->ARM_SAI	:= ROM->C6_LOCAL
	      	TRB->DESCARMS	:= clArmSai      	      	
	      	TRB->CTRANSP	:= ROM->C5_TRANSP 
	      	TRB->DTRANSP	:= clTransp
	      	   	        	         	        	     	         			          	              	        	         	        	     	        
	    MsUnlock()
	    clTransp:=SPACE(15)
	    clArmEnt:=SPACE(30)
	    clArmSai:=SPACE(30)	      	
		
	      dbSelectArea("ROM")
	     DbSkip()
	Enddo
	If Select("ROM") > 0
		dbSelectArea("ROM")
		DbCloseArea()
	EndIf
	
Return

Static Function ValPerg(cPerg)

	PutSx1(cPerg,'01','Emissão de            ?','','','mv_ch1','D',8,0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'02','Emissão Ate           ?','','','mv_ch2','D',8,0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'03','Entrega de            ?','','','mv_ch3','D',8,0,0,'G','','','','','mv_par03',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'04','Entrega Ate           ?','','','mv_ch4','D',8,0,0,'G','','','','','mv_par04',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'05','Pedido de             ?','','','mv_ch5','C',06,0,0,'G','','','','','mv_par05',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'06','Pedido Ate            ?','','','mv_ch6','C',06,0,0,'G','','','','','mv_par06',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'07','Cliente de            ?','','','mv_ch7','C',06,0,0,'G','','','','','mv_par07',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'08','Cliente Ate           ?','','','mv_ch8','C',06,0,0,'G','','','','','mv_par08',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'09','Loja de             	 ?','','','mv_ch9','C',06,0,0,'G','','','','','mv_par09',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'10','Loja Ate           	 ?','','','mv_cha','C',06,0,0,'G','','','','','mv_par10',,,'','','','','','','','','','','','','','')  
	PutSx1(cPerg,'11','Tipo de Pedido      	 ?','','','mv_chb','N',1 ,0,1,'C','','','','','mv_par11',"Aberto","","","","Pacial","","","Ambos","","","","","","","","")   
Return
