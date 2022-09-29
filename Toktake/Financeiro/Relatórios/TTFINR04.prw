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
¦¦¦Funçào    ¦TTFINR04() ¦ Autor ¦ FABIO SALES		    ¦ Data ¦31.07.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ CONTAS PAGAS E  CONTAS RECEBIDAS					          ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ FINANCEIRO                                              	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/  

User Function TTFINR04()
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
¦¦¦Funçào    ¦REPORTDEF() ¦ Autor ¦ FABIO SALES		    ¦ Data ¦31.07.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ FUNCAO PRINCIPAL D EIMPRESSÀO   							  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ FINANCEIRO                                              	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function ReportDef()

	Local oReport
	Local oSection
	Local clTit	  :="Relatório de contas pagas e recebidas"
	Local clDescri:="Este relatório irá imprimir todas as contas pagas e recebidas"
	Local clProg  :="TTFINR04"
	Private cPerg :="TTFINR04"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New(clProg,clTit,"",{|oReport| PrintReport(oReport)},clDescri)
	
	/*-------------------------| 		    			           
	| seção dos titulo a pagar | 
	|-------------------------*/
	
	oSection1 := TRSection():New(oReport,OemToAnsi("CONTAS PAGAS E RECEBIDAS"),{"TRB"})
	
	/*----------------------------------------------------------------------------------| 		    			           
	|                       campo        alias  título       	 pic           tamanho  | 
	|----------------------------------------------------------------------------------*/	
	                                                                               
	TRCell():New(oSection1,"TIPOFIN"	,"TRB","STATUS_CONTA"	,"@!"			,20)
	TRCell():New(oSection1,"FILIAL"		,"TRB","FILIAL		"	,"@!"			,02)
	TRCell():New(oSection1,"NUMERO"		,"TRB","NUMERO		"	,"@!"			,09)
	TRCell():New(oSection1,"PREFIXO"	,"TRB","PREFIXO		"	,"@!"			,03)		
	TRCell():New(oSection1,"PARCELA"	,"TRB","PARCELA		"	,"@!"			,03)
	TRCell():New(oSection1,"TIPO"		,"TRB","TIPO		"	,"@!"			,03)
	TRCell():New(oSection1,"VALOR"		,"TRB","VAL_TITULO	"	,"@E 999,999.99",16)	
	TRCell():New(oSection1,"VALPG"		,"TRB","VAL_TOT_PAGO(RECEBIDO)","@E 999,999.99",16)
	TRCell():New(oSection1,"SALDO"		,"TRB","VAL_A_PAGAR(RECEBER)","@E 999,999.99",16)
	TRCell():New(oSection1,"DESCONTO"	,"TRB","DESCONTO	"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"JUROS"		,"TRB","JUROS		"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"MULTA"		,"TRB","MULTA		"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"ACRESC"		,"TRB","ACRESSIMOS	"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"DECRESC"	,"TRB","DECRESSIMOS	"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"NATUREZA"	,"TRB","NATUREZA	"	,"@!"			,10)
	TRCell():New(oSection1,"DESCRINAT"	,"TRB","DESC_NAT	"	,"@!"			,10) 	
	TRCell():New(oSection1,"FORNECE"	,"TRB","FORCEDOR	"	,"@!"			,06)	
	TRCell():New(oSection1,"LOJA"		,"TRB","LOJA		"	,"@!"			,04)
	TRCell():New(oSection1,"NOMFOR"		,"TRB","NOM_FORNECEDOR" ,"@!"			,30)			
	TRCell():New(oSection1,"EMISSAO"	,"TRB","EMISSAO		"	,				,08)
	TRCell():New(oSection1,"VENCREAL"	,"TRB","VENC_REAL	"	,				,08)
	TRCell():New(oSection1,"DTBAIXA"	,"TRB","DATA DA BAIXA	"	,			,08)	
			
Return oReport

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦PrintReport() ¦ Autor ¦ FABIO SALES	    ¦ Data ¦31.07.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ FUNCAO RESPONSÁVEL PELA IMPRESSÃO DO RELATÓRIO			  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ FINANCEIRO                                              	  ¦¦¦
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

Local clDescNat

	/*-------------------------------| 		    			           
	| criação do arquivo de trabalho |
	|-------------------------------*/
	
	_aStru	:= {}
	
	AADD(_aStru,{"TIPOFIN"	,"C",20,0})		    
	AADD(_aStru,{"FILIAL"	,"C",02,0})
	AADD(_aStru,{"NUMERO"	,"C",09,0})
	AADD(_aStru,{"PREFIXO"	,"C",03,0})		
	AADD(_aStru,{"PARCELA"	,"C",03,0})
	AADD(_aStru,{"TIPO"		,"C",03,0})	
	AADD(_aStru,{"NATUREZA"	,"C",10,0})
	AADD(_aStru,{"DESCRINAT","C",35,0})	
	AADD(_aStru,{"FORNECE"	,"C",06,0})	
	AADD(_aStru,{"LOJA"		,"C",04,0})
	AADD(_aStru,{"NOMFOR"	,"C",30,0})
	AADD(_aStru,{"EMISSAO"	,"D",8,0})
	AADD(_aStru,{"VENCREAL"	,"D",8,0})
	AADD(_aStru,{"DTBAIXA"	,"D",8,0})
	AADD(_aStru,{"VALOR"	,"N",14,2})
	AADD(_aStru,{"DESCONTO"	,"N",14,2})
	AADD(_aStru,{"JUROS"	,"N",14,2})	
	AADD(_aStru,{"SALDO"	,"N",14,2})
	AADD(_aStru,{"MULTA"	,"N",14,2})	
	AADD(_aStru,{"VALPG"	,"N",14,2}) 
	AADD(_aStru,{"ACRESC"	,"N",14,2})	
	AADD(_aStru,{"DECRESC"	,"N",14,2})
	
   	_cArq     := CriaTrab(_aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)
	                                            
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	IndRegua("TRB",_cIndice,"NUMERO",,,"Selecionando Registros...")
	                     
	/*-------------------------------------------| 		    			           
	| Montagem da query com os titulos em aberto |
	|-------------------------------------------*/	

	cQuery := " SELECT 'CONTAS PAGAS' AS TIPO, E2_MSFIL AS MSFIL,E2_PREFIXO AS PREFIXO,E2_NUM AS NUM,E2_PARCELA AS PARCELA,E2_TIPO AS TIPO2, "
	cQuery += " E2_NATUREZ AS NATUREZ,E2_FORNECE AS FORCLI,E2_LOJA AS LOJA,A2_NOME AS NOMFORCLI,E2_DESCONT AS DESCONT,E2_MULTA AS MULTA, "
	cQuery += " E2_JUROS AS JUROS,E2_EMISSAO AS EMISSAO,E2_VENCTO AS VENCTO,E2_VENCREA AS VENCREA,E2_VALOR AS VALOR,E2_SALDO AS SALDO, "
	cQuery += " (E2_VALOR-E2_SALDO) AS VALPG,E2_ACRESC AS ACRESC,E2_DECRESC AS DECRESC, E2_BAIXA AS DTBAIXA FROM "+RetSqlName("SE2")+" SE2  "
	cQuery += " INNER JOIN "+RetSqlName("SA2")+" SA2 ON E2_FORNECE=A2_COD AND E2_LOJA=A2_LOJA  "
	
	cQuery += " WHERE  SE2.D_E_L_E_T_=''  "
	cQuery += "	AND SA2.D_E_L_E_T_='' 	"
	cQuery += "	AND E2_SALDO <> E2_VALOR "
	cQuery += " AND E2_FILIAL ='"+xFilial("SE2")+"'  "
	cQuery += " AND A2_FILIAL ='"+xFilial("SA2")+"'  "
	cQuery += " AND E2_BAIXA   BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'  "
	cQuery += " AND E2_NUM     BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'  "
	cQuery += " AND E2_PREFIXO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "
	cQuery += " AND E2_NATUREZ BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'  " 
	cQuery += " AND E2_FORNECE BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"'  "
	cQuery += " AND E2_LOJA BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"'  "
	 
	
	cQuery += " UNION "
	
	cQuery += " SELECT 'CONTAS RECEBIDAS' AS TIPO, E1_MSFIL AS MSFIL,E1_PREFIXO AS PREFIXO,E1_NUM AS NUM,E1_PARCELA AS PARCELA,E1_TIPO AS TIPO2, "
	cQuery += " E1_NATUREZ AS NATUREZ,E1_CLIENTE AS FORCLI,E1_LOJA AS LOJA,A1_NOME AS NOMFORCLI,E1_DESCONT AS DESCONT,E1_MULTA AS MULTA, "
	cQuery += " E1_JUROS AS JUROS,E1_EMISSAO AS EMISSAO,E1_VENCTO AS VENCTO,E1_VENCREA AS VENCREA,E1_VALOR AS VALOR,E1_SALDO AS SALDO, "
	cQuery += " (E1_VALOR-E1_SALDO) AS VALPG,E1_ACRESC AS ACRESC,E1_DECRESC AS DECRESC,E1_BAIXA AS DTBAIXA  FROM "+RetSqlName("SE1")+" SE1  "
	cQuery += " INNER JOIN "+RetSqlName("SA1")+" SA1 ON E1_CLIENTE=A1_COD AND E1_LOJA=A1_LOJA "
	cQuery += " WHERE  SE1.D_E_L_E_T_=''  "
	cQuery += "	AND    SA1.D_E_L_E_T_=''  	  "
	cQuery += "	AND  E1_SALDO <> E1_VALOR  "
	cQuery += " AND  E1_FILIAL ='"+xFilial("SE1")+"'  "
	cQuery += " AND  A1_FILIAL ='"+xFilial("SA1")+"'  "
	cQuery += " AND  E1_BAIXA   BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'  "
	cQuery += " AND  E1_NUM     BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'  "
	cQuery += " AND  E1_PREFIXO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "
	cQuery += " AND  E1_NATUREZ BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'  " 
	cQuery += " AND  E1_CLIENTE BETWEEN '"+MV_PAR13+"' AND '"+MV_PAR14+"'  " 
	cQuery += " AND  E1_LOJA    BETWEEN '"+MV_PAR15+"' AND '"+MV_PAR16+"'  " 
	
	
	IF SELECT("FIN") > 0
		dbSelectArea("FIN")
		DbCloseArea()
	ENDIF
	
	MemoWrite("TTFINR04.SQL",cQuery)
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"FIN",.F.,.T.)
	
	/*--------------------------------------------------| 		    			           
	| ajusta casas decimais e datas no retorno da query |
	|--------------------------------------------------*/
	
	TcSetField("FIN","VALOR"	,"N",14,2)
	TcSetField("FIN","SALDO"	,"N",14,2)
	TcSetField("FIN","VALPG"	,"N",14,2)	
	TcSetField("FIN","DESCONT"	,"N",14,2)
	TcSetField("FIN","JUROS"	,"N",14,2)
	TcSetField("FIN","MULTA"	,"N",14,2)
	TcSetField("FIN","ACRESC"	,"N",14,2)
	TcSetField("FIN","DECRESC"	,"N",14,2)
	TcSetField("FIN","EMISSAO"	,"D",08,0)
	TcSetField("FIN","VENCREA"	,"D",08,0)
	TcSetField("FIN","DTBAIXA"	,"D",08,0)
			
	dbSelectArea("FIN")
	dbGotop()
		
	While FIN->(!Eof())
	
		DBSELECTAREA("SED")
		DBSETORDER(1)
		IF DBSEEK(XFILIAL("SED")+FIN->NATUREZ)
		   clDescNat:=SED->ED_DESCRIC 
		ENDIF 
		     	      		       
	 	DbSelectArea("TRB")
	     
	/*--------------------------|
	| adciona registro em banco |
	|--------------------------*/
	
	    RecLock("TRB",.T.)
	        
	    	TRB->TIPOFIN	:= FIN->TIPO
	     	TRB->FILIAL		:= FIN->MSFIL
	     	TRB->NUMERO		:= FIN->NUM
	     	TRB->PREFIXO	:= FIN->PREFIXO
	      	TRB->PARCELA	:= FIN->PARCELA
	      	TRB->TIPO		:= FIN->TIPO2
	      	TRB->NATUREZA	:= FIN->NATUREZ
	      	TRB->DESCRINAT	:= clDescNat	        	      		        	      	
	        TRB->FORNECE	:= FIN->FORCLI	        
	        TRB->LOJA		:= FIN->LOJA
	        TRB->NOMFOR		:= FIN->NOMFORCLI
	        TRB->EMISSAO	:= FIN->EMISSAO
	        TRB->VENCREAL	:= FIN->VENCREA
	        TRB->DTBAIXA	:= FIN->DTBAIXA
	        TRB->VALOR 		:= FIN->VALOR 
	        TRB->SALDO 		:= FIN->SALDO 
	        TRB->VALPG		:= FIN->VALPG 	        
	        TRB->MULTA 		:= FIN->MULTA 
	        TRB->DESCONTO 	:= FIN->DESCONT 
	        TRB->JUROS		:= FIN->JUROS 
	        TRB->ACRESC 	:= FIN->ACRESC 
	        TRB->DECRESC	:= FIN->DECRESC 
	            
	      MsUnlock()
	      clDescNat:=""
	    	      
	      dbSelectArea("FIN")
	      DBSKIP()  
	Enddo
	
	If Select("FIN") > 0
		dbSelectArea("FIN")
		DbCloseArea()
	EndIf
	
Return	

Static Function ValPerg(cPerg)

	PutSx1(cPerg,'01','Baixado    De      ?','','','mv_ch1','D',08,0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'02','Baixado    Ate     ?','','','mv_ch2','D',08,0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'03','Titulo     De      ?','','','mv_ch3','C',09,0,0,'G','','','','','mv_par03',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'04','Titutlo    Ate     ?','','','mv_ch4','C',09,0,0,'G','','','','','mv_par04',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'05','Prefixo    De      ?','','','mv_ch5','C',03,0,0,'G','','','','','mv_par05',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'06','Prefixo 	  Ate	  ?','','','mv_ch6','C',03,0,0,'G','','','','','mv_par06',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'07','Natureza   De      ?','','','mv_ch7','C',10,0,0,'G','','SED','','','mv_par07',,,'','','','','','','','','','','','','','')	
	PutSx1(cPerg,'08','Natureza   Ate     ?','','','mv_ch8','C',10,0,0,'G','','SED','','','mv_par08',,,'','','','','','','','','','','','','','')	
	PutSx1(cPerg,'09','Fornecedor   De      ?','','','mv_ch9','C',06,0,0,'G','','SA2','','','mv_par09',,,'','','','','','','','','','','','','','')	
	PutSx1(cPerg,'10','Fornecedor   Ate     ?','','','mv_cha','C',06,0,0,'G','','SA2','','','mv_par10',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'11','Loja   		De      ?','','','mv_chb','C',04,0,0,'G','','','','','mv_par11',,,'','','','','','','','','','','','','','')	
	PutSx1(cPerg,'12','Loja   		Ate     ?','','','mv_chc','C',04,0,0,'G','','','','','mv_par12',,,'','','','','','','','','','','','','','')			
	PutSx1(cPerg,'13','Cliente 		De      ?','','','mv_chd','C',06,0,0,'G','','SA1','','','mv_par13',,,'','','','','','','','','','','','','','')	
	PutSx1(cPerg,'14','Cliente		Ate     ?','','','mv_che','C',06,0,0,'G','','SA1','','','mv_par14',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'15','Loja			De      ?','','','mv_chf','C',04,0,0,'G','','','','','mv_par15',,,'','','','','','','','','','','','','','')	
	PutSx1(cPerg,'16','Loja			Ate     ?','','','mv_ch','C',04,0,0,'G','','','','','mv_par16',,,'','','','','','','','','','','','','','')
					
Return



 cCpo := PADR(aDados[i,6],20)
    cLin := Stuff(cLin,30,20,cCpo)
fWrite(nHdl,cLin+chr(13)+chr(10))