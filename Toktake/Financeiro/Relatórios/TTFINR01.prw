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
¦¦¦Funçào    ¦TTFINR01() ¦ Autor ¦ FABIO SALES		    ¦ Data ¦18.06.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ CONTAS A PAGAR									          ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ FINANCEIRO                                              	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/  

User Function TTFINR01()
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
¦¦¦Funçào    ¦REPORTDEF() ¦ Autor ¦ FABIO SALES		    ¦ Data ¦17.06.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ FUNCAO PRINCIPAL D EIMPRESSÀO   							  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ COMPRAS                                               	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function ReportDef()

	Local oReport
	Local oSection
	Private cPerg    := "TTFIN01"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New("TTFINR01","RELATORIO DE CONTAS A PAGAR EM ABERTO","",{|oReport| PrintReport(oReport)},"ESTE RELATORIO IMPRIMIRAR AS CONTAS A PAGAR EM ABERTO")
	
	/*-------------------------| 		    			           
	| seção dos titulo a pagar | 
	|-------------------------*/
	
	oSection1 := TRSection():New(oReport,OemToAnsi("CONTAS A PAGAR EM ABERTO"),{"TRB"})
	
	/*----------------------------------------------------------------------------------| 		    			           
	|                       campo        alias  título       	 pic           tamanho  | 
	|----------------------------------------------------------------------------------*/	
	
	TRCell():New(oSection1,"FILIAL"		,"TRB","FILIAL		"	,"@!"			,02)
	TRCell():New(oSection1,"NUMERO"		,"TRB","NUMERO		"	,"@!"			,09)
	TRCell():New(oSection1,"PREFIXO"	,"TRB","PREFIXO		"	,"@!"			,03)		
	TRCell():New(oSection1,"PARCELA"	,"TRB","PARCELA		"	,"@!"			,03)
	TRCell():New(oSection1,"TIPO"		,"TRB","TIPO		"	,"@!"			,03)
	TRCell():New(oSection1,"VALOR"		,"TRB","VAL_TITULO	"	,"@E 999,999.99",16)	
	TRCell():New(oSection1,"VALLIQ"		,"TRB","VAL_PAGO	"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"SALDO"		,"TRB","VAL_A_PAGAR	"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"DESCONTO"	,"TRB","DESCONTO	"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"JUROS"		,"TRB","JUROS		"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"MULTA"		,"TRB","MULTA		"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"NATUREZA"	,"TRB","NATUREZA	"	,"@!"			,10)
	TRCell():New(oSection1,"FORNECE"	,"TRB","FORCEDOR	"	,"@!"			,06)	
	TRCell():New(oSection1,"LOJA"		,"TRB","LOJA		"	,"@!"			,04)
	TRCell():New(oSection1,"NOMFOR"		,"TRB","NOM_FORNECEDOR" ,"@!"			,30)			
	TRCell():New(oSection1,"EMISSAO"	,"TRB","EMISSAO		"	,				,08)
	TRCell():New(oSection1,"VENCREAL"	,"TRB","VENC_REAL	"	,				,08)
	TRCell():New(oSection1,"DINCLU"		,"TRB","DATA_INCLUSÃO"	,				,08)
			
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

	Local cCampo 
	Local cUserLG                               
	Local cUsuarioI
	Local cDataI   

	/*-------------------------------| 		    			           
	| criação do arquivo de trabalho |
	|-------------------------------*/
	
	_aStru	:= {}
			    
	AADD(_aStru,{"FILIAL"	,"C",02,0})
	AADD(_aStru,{"NUMERO"	,"C",09,0})
	AADD(_aStru,{"PREFIXO"	,"C",03,0})		
	AADD(_aStru,{"PARCELA"	,"C",03,0})
	AADD(_aStru,{"TIPO"		,"C",03,0})	
	AADD(_aStru,{"NATUREZA"	,"C",10,0})
	AADD(_aStru,{"FORNECE"	,"C",06,0})	
	AADD(_aStru,{"LOJA"		,"C",04,0})
	AADD(_aStru,{"NOMFOR"	,"C",30,0})
	AADD(_aStru,{"EMISSAO"	,"D",8,0})
	AADD(_aStru,{"VENCREAL"	,"D",8,0})
	AADD(_aStru,{"DINCLU"	,"D",8,0})	
	AADD(_aStru,{"VALOR"	,"N",14,2})
	AADD(_aStru,{"DESCONTO"	,"N",14,2})
	AADD(_aStru,{"JUROS"	,"N",14,2})	
	AADD(_aStru,{"SALDO"	,"N",14,2})
	AADD(_aStru,{"MULTA"	,"N",14,2})	
	AADD(_aStru,{"VALLIQ"	,"N",14,2})
	
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

	cQuery := " SELECT E2_MSFIL,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_NATUREZ,E2_FORNECE,E2_LOJA,E2_NOMFOR,E2_DESCONT,E2_MULTA, "
	cQuery += " E2_JUROS,E2_EMISSAO,E2_VENCTO,E2_VENCREA,E2_VALOR,E2_SALDO,(E2_VALOR - E2_SALDO) AS VALPAG,E2_USERLGI,E2_DTNFINC FROM "+RetSqlName("SE2")+" SE2  "
	cQuery += " WHERE  D_E_L_E_T_=''  "
	IF MV_PAR09==1                                                        
		cQuery += " AND E2_SALDO=E2_VALOR  "						//TITULOS ABERTOS
	ELSEIF MV_PAR09==2
		cQuery += " AND E2_SALDO < E2_VALOR AND E2_SALDO > 0  " 	//TITULOS PACIALMENTE EM ABERTO
	ELSEIF MV_PAR09==3
		cQuery += " AND E2_SALDO <> 0 "								//TITULOS ABERTOS E PACIALMENTE ABERTO
	ELSEIF MV_PAR09==4
		cQuery += " AND E2_SALDO = 0 AND E2_BAIXA<>'' "				//TITULOS BAIXADOS
	ELSEIF MV_PAR09==5
		cQuery += " AND E2_SALDO >= 0 "								//TODOS
	ENDIF
	cQuery += " AND E2_FILIAL ='"+xFilial("SE2")+"'  "
	cQuery += " AND E2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'  "
	cQuery += " AND E2_VENCREA BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'  "
	cQuery += " AND E2_NUM     BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'  "
	cQuery += " AND E2_PREFIXO BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'  "
	cQuery += " ORDER BY E2_NUM  " 
	
	IF SELECT("FIN") > 0
		dbSelectArea("FIN")
		DbCloseArea()
	ENDIF
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"FIN",.F.,.T.)
	
	/*--------------------------------------------------| 		    			           
	| ajusta casas decimais e datas no retorno da query |
	|--------------------------------------------------*/
	
	TcSetField("FIN","E2_VALOR 	","N",14,2)
	TcSetField("FIN","E2_SALDO 	","N",14,2)
	TcSetField("FIN","VALPAG","N",14,2)	
	TcSetField("FIN","E2_DESCONT","N",14,2)
	TcSetField("FIN","E2_JUROS 	","N",14,2)
	TcSetField("FIN","E2_MULTA ","N",14,2)
	TcSetField("FIN","E2_EMISSAO","D",08,0)
	TcSetField("FIN","E2_VENCREA","D",08,0)
	TcSetField("FIN","E2_DTNFINC","D",08,0)
			
	dbSelectArea("FIN")
	dbGotop()
		
	While FIN->(!Eof())
	
	IF !EMPTY(FIN->E2_DTNFINC)
	/*		
		cCampo :="FIN->E2_USERLGI"
		cUserLG :=Embaralha(&cCampo,1)
		cUsuarioI:= If(!Empty(cUserLg),Subs(cUserLg,1,15),"")
		cDataI   :=IIF(!Empty(cUserLg),CTOD("01/01/96") + Load2in4(Substr(cUserLg,16)),"")
	*/	
	&&ELSE
		cDataI:=FIN->E2_DTNFINC
	ENDIF
		     	      		       
	     DbSelectArea("TRB")
	     
	/*--------------------------|
	| adciona registro em banco |
	|--------------------------*/
	
	    RecLock("TRB",.T.)
	    
	     	TRB->FILIAL		:= FIN->E2_MSFIL
	     	TRB->NUMERO		:= FIN->E2_NUM
	     	TRB->PREFIXO	:= FIN->E2_PREFIXO
	      	TRB->PARCELA	:= FIN->E2_PARCELA
	      	TRB->TIPO		:= FIN->E2_TIPO
	      	TRB->NATUREZA	:= FIN->E2_NATUREZ	        	      		        	      	
	        TRB->FORNECE	:= FIN->E2_FORNECE	        
	        TRB->LOJA		:= FIN->E2_LOJA 
	        DbSelectArea("SA2")
	        DbSetOrder(1)
	        If DbSeek(Xfilial("SA2")+ FIN->E2_FORNECE + FIN->E2_LOJA)
	        	TRB->NOMFOR		:=SA2->A2_NOME
	        Else
	        	TRB->NOMFOR		:= "ERRO NA CAD. FOPRNECEDOR"
	        EndIf
	        
	        TRB->EMISSAO	:= FIN->E2_EMISSAO
	        TRB->VENCREAL	:= FIN->E2_VENCREA
	        TRB->DINCLU		:= cDataI      
	   		TRB->VALOR 		:= FIN->E2_VALOR 
	        TRB->SALDO 		:= FIN->E2_SALDO 
	        TRB->VALLIQ		:= FIN->VALPAG
	        TRB->MULTA 		:= FIN->E2_MULTA 
	        TRB->DESCONTO 	:= FIN->E2_DESCONT 
	        TRB->JUROS		:= FIN->E2_JUROS
			                
	      MsUnlock()
	      cDataI:=CTOD(SPACE(8))
	      	      
	      dbSelectArea("FIN")
	      DBSKIP()  
	Enddo
	
	If Select("FIN") > 0
		dbSelectArea("FIN")
		DbCloseArea()
	EndIf
	
Return

Static Function ValPerg(cPerg)

	PutSx1(cPerg,'01','EMISSAO    DE      ?','','','mv_ch1','D',08,0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'02','EMISSAO    ATE     ?','','','mv_ch2','D',08,0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'03','VENCIMENTO DE      ?','','','mv_ch3','D',08,0,0,'G','','','','','mv_par03',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'04','VENCIMENTO ATE     ?','','','mv_ch4','D',08,0,0,'G','','','','','mv_par04',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'05','TITULO     DE      ?','','','mv_ch5','C',09,0,0,'G','','','','','mv_par05',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'06','TITULO     ATE     ?','','','mv_ch6','C',09,0,0,'G','','','','','mv_par06',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'07','PREFIXO    DE      ?','','','mv_ch7','C',03,0,0,'G','','','','','mv_par07',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'08','PREFIXO    ATE     ?','','','mv_ch8','C',03,0,0,'G','','','','','mv_par08',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'09','STATUS DO TÍTULO   ?','','','mv_ch9','N',01,0,1,'C','','','','','mv_par09',"ABERTO","","","","PACIAL_ABERTO","","","ABERTO/PACIAL_ABERTO","","","BAIXADOS","","","TODOS","","")   
	
Return
