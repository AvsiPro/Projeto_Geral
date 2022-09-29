
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
¦¦¦Funçào    ¦TTCOMR06() ¦ Autor ¦ FABIO SALES		    ¦ Data ¦15.10.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ PEDIDOS DE COMPRAS PEDENTES DE APROVAÇÃO			          ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ COMPRAS                                               	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

User Function TTCOMR06()
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
¦¦¦Descriçào ¦ FUNCAO PRINCIPAL DE EIMPRESSAO  							  ¦¦¦
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
	Private cPerg    := "PEDCOMP"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New("PEDCOMP","RELATORIO DE PEDIDO","",{|oReport| PrintReport(oReport)},"ESTE RELATORIO IMPRIMIR OS PEDIDOS DE COMPRAS PENDENTES DE APROVAÇÃO")
	
	/*------------------------| 		    			           
	| seção das notas fiscais | 
	|------------------------*/
	
	oSection1 := TRSection():New(oReport,OemToAnsi("Pedido de Compra"),{"TRB"})
	
	/*----------------------------------------------------------------------------------| 		    			           
	|                       campo        alias  título       	 pic           tamanho  | 
	|----------------------------------------------------------------------------------*/	
	
	TRCell():New(oSection1,"TIPO"		,"TRB"  ,"TIPO	"		,"@!"			,20)
	TRCell():New(oSection1,"FILIAL"		,"TRB"  ,"FILIAL	"	,"@!"			,02)
	TRCell():New(oSection1,"NUMPED"		,"TRB"  ,"PEDIDO	"	,"@!"			,09)
	TRCell():New(oSection1,"TOTAL"		,"TRB"  ,"TOTAL"		,"@E 999,999,999.99",16)
	TRCell():New(oSection1,"TOTENT"		,"TRB"  ,"TOTAL DE ENTRADAS","@E 999,999,999.99",16)
	TRCell():New(oSection1,"DIFER"		,"TRB"  ,"DIFERENCA"	,"@E 999,999,999.99",16)	
	TRCell():New(oSection1,"CODFOR"		,"TRB"  ,"COD_FORN"		,"@!"			,06)
	TRCell():New(oSection1,"LOJFOR"		,"TRB"  ,"LOJA	"		,"@!"			,04)
	TRCell():New(oSection1,"NOMEFOR"	,"TRB"  ,"FORNECEDOR"	,"@!"			,40)		
	TRCell():New(oSection1,"CNPJ"		,"TRB"  ,"CNPJ/CPF "	,"@R 99.999.999/9999-99",14)
	TRCell():New(oSection1,"NATUREZ"	,"TRB"  ,"NATUREZA"		,"@!"			,10)
	TRCell():New(oSection1,"CONPG"		,"TRB"  ,"CONDPG	"	,"@!"			,03)
	TRCell():New(oSection1,"EMISSAO"	,"TRB"  ,"EMISSAO	"	,    			,08)
	TRCell():New(oSection1,"DATENTR"	,"TRB"  ,"DAT_ENTREGA"	,    			,08)
	TRCell():New(oSection1,"VENCTO"		,"TRB"  ,"VENC_PREVISTO",    			,08)
	
	/*-----------------------------------------\
	| incluido em 28/03/2012 por Fabio Sales   |
	\-----------------------------------------*/
		
	TRCell():New(oSection1,"COMPRAD"		,"TRB"  ,"COMPRADOR	"	,"@!"		,06)
	TRCell():New(oSection1,"NOMCOMP"		,"TRB"  ,"NOME_COMPRASDOR"	,"@!"	,35)
				
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
 
	Local cnTotEnt:=0
	Local cnDifer :=0 
	Local clTipo  :=""
	Local cFILIAL	
	Local cNUMPED	
	Local cCODFOR	
    Local cLOJFOR	
    Local cNOMEFOR	
    Local cCNPJ		
    Local cNATUREZ	
    Local dEMISSAO	
    Local dDATENTR	
    Local cCONPG	
    Local nTOTAL:=0
    Local aParc
    Local alParc
    Local nTOT2	:= 0
	Local cnTotent2:= 0 
	
	/*-------------------------------| 		    			           
	| criação do arquivo de trabalho |
	|-------------------------------*/
	
	_aStru	:= {}
	
	AADD(_aStru,{"TIPO","C",20,0})		    		    
	AADD(_aStru,{"FILIAL","C",02,0})
	AADD(_aStru,{"NUMPED","C",06,0})
	AADD(_aStru,{"TOTAL","N",14,2})
	AADD(_aStru,{"TOTENT","N",14,2})		
	AADD(_aStru,{"DIFER","N",14,2})					
	AADD(_aStru,{"CODFOR","C",06,0})
	AADD(_aStru,{"LOJFOR","C",04,0})
	AADD(_aStru,{"NOMEFOR","C",40,0})		
	AADD(_aStru,{"CNPJ","C",14,0})
	AADD(_aStru,{"NATUREZ","C",10,0})
	AADD(_aStru,{"CONPG","C",03,0})  	
	AADD(_aStru,{"EMISSAO","D",08,0})
	AADD(_aStru,{"DATENTR","D",08,0})
	AADD(_aStru,{"VENCTO","D",08,0})	
	AADD(_aStru,{"COMPRAD","C",20,0})		    		    
	AADD(_aStru,{"NOMCOMP","C",20,0})		    		    
		
   	_cArq     := CriaTrab(_aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)
	                                            
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	IndRegua("TRB",_cIndice,"CODFOR",,,"Selecionando Registros...")
	
	/*------------------------------------------------------------------| 		    			           
	| Montagem da query para a montagem dos dados do pedidos de compras |
	|------------------------------------------------------------------*/
	                     	
	clQuery := " SELECT (C7_QUJE * C7_PRECO) AS TOTENT,  "
	clQuery += " C7_FILIAL,C7_NUM,C7_PRODUTO,C7_QUJE,C7_TOTAL,C7_QUANT,C7_LOCAL,C7_FORNECE,C7_LOJA,A2_NOME, "
	clQuery	+= " A2_CGC,A2_NATUREZ,C7_EMISSAO,C7_USER,Y1_NOME,C7_DATPRF,C7_COND,C7_RESIDUO,C7_CONAPRO "
	clQuery	+= " FROM "+RetSQLName("SC7")+" AS SC7 INNER JOIN "+RetSQLName("SA2")+" AS SA2 ON	"
	clQuery	+= " A2_COD=C7_FORNECE AND A2_LOJA=C7_LOJA AND SC7.D_E_L_E_T_=SA2.D_E_L_E_T_ 		"
	clQuery	+= " INNER JOIN "+RetSqlName("SY1")+" AS SY1 ON C7_FILIAL=Y1_FILIAL AND C7_USER=Y1_USER "	
	clQuery	+= " WHERE (C7_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"')		"
	clQuery	+= " AND (C7_NUM BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"') AND						"
	clQuery	+= " (C7_FORNECE BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"') AND						" 
	clQuery	+= " (C7_FILIAL  BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"') 						"
	clQuery	+= " AND  C7_CONAPRO = 'B' AND C7_RESIDUO='' AND C7_ENCER=''	"
	clQuery	+= " AND SC7.D_E_L_E_T_=''	"
	clQuery += " AND SA2.D_E_L_E_T_=''	"
	clQuery += " AND SY1.D_E_L_E_T_=''	"
	clQuery	+= " ORDER BY C7_NUM		" 
	
	IF SELECT("PEDI") > 0
		dbSelectArea("PEDI")
		DbCloseArea()
	ENDIF
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,clQuery),"PEDI",.F.,.T.)
	
	/*--------------------------------------------------| 		    			           
	| ajusta casas decimais e datas no retorno da query |
	|--------------------------------------------------*/
	
	TcSetField("PEDI","C7_EMISSAO"	,"D",08,0)
	TcSetField("PEDI","C7_DATPRF"	,"D",08,0)
	TcSetField("PEDI","C7_TOTAL"	,"N",14,2)
		
	dbSelectArea("PEDI")
	dbGotop()
		
	Do While PEDI->(!Eof())
			
		cFILIAL		:= PEDI->C7_FILIAL
		cNUMPED		:= PEDI->C7_NUM
		cCODFOR		:= PEDI->C7_FORNECE
    	cLOJFOR		:= PEDI->C7_LOJA      	
        cNOMEFOR	:= PEDI->A2_NOME
        cCNPJ		:= PEDI->A2_CGC
        cNATUREZ	:= PEDI->A2_NATUREZ
        cEMISSAO	:= PEDI->C7_EMISSAO
        cDATENTR	:= PEDI->C7_DATPRF
        cCONPG		:= PEDI->C7_COND                
        cCOMP		:= PEDI->C7_USER
        cNOMC		:= PEDI->Y1_NOME          
        
		DO WHILE (PEDI->C7_FILIAL==cFILIAL) .AND.(PEDI->C7_NUM==cNUMPED).AND.(PEDI->C7_FORNECE==cCODFOR).AND.(PEDI->C7_LOJA==cLOJFOR).AND. (PEDI->C7_EMISSAO==cEMISSAO)
		
			nTOT2	  := nTOT2 + PEDI->C7_TOTAL
			cnTotent2 := cnTotent2 + PEDI->TOTENT
		   			
		PEDI->(DBSKIP())
		ENDDO
		cnDifer := nTOT2 - cnTotent2
		alParc  := CONDICAO(nTOT2,cCONPG,,cDATENTR) 
		
     	MsProcTxt("Processando Item "+PEDI->C7_NUM)
	           
	    DbSelectArea("TRB")
	    
	/*--------------------------|
	| adciona registro em banco |
	|--------------------------*/
	    
	    RecLock("TRB",.T.)
	     	                   	             
        TRB->VENCTO		:= alParc[1,1]
    	TRB->TOTAL		:= nTOT2	        	      	
        TRB->TOTENT		:= cnTotent2
        TRB->DIFER		:= cnDifer	    
	    TRB->TIPO		:= clTipo
     	TRB->FILIAL		:= cFILIAL
      	TRB->NUMPED		:= cNUMPED
	    TRB->CODFOR		:= cCODFOR
    	TRB->LOJFOR		:= cLOJFOR
        TRB->NOMEFOR	:= cNOMEFOR
        TRB->CNPJ		:= cCNPJ
        TRB->NATUREZ	:= cNATUREZ
        TRB->EMISSAO	:= cEMISSAO
        TRB->DATENTR	:= cDATENTR
        TRB->CONPG		:= cCONPG                        
  		TRB->COMPRAD	:= cCOMP
		TRB->NOMCOMP	:= cNOMC
                     	                
      	MsUnlock()
      	      
      	nTOT2		:= 0
		cnTot2  	:= 0
		cnTotent2   := 0
        cnTotEnt	:= 0
        cnDifer     := 0
        clTipo		:= ""
      	cFILIAL		:= ""
		cNUMPED		:= ""
		cCODFOR		:= ""
    	cLOJFOR		:= ""
        cNOMEFOR	:= ""
        cCNPJ		:= ""
        cNATUREZ	:= ""
        cEMISSAO	:= ""
        cDATENTR	:= ""
        cCONPG		:= ""
        cCOMP		:= ""
        cNOMC		:= ""
        nTOTAL		:=0
		alParc 		:={}
		aParc		:={}	
  	DBSELECTAREA("PEDI")  
	ENDDO	
	If Select("PEDI") > 0
		dbSelectArea("PEDI")
		DbCloseArea()
	EndIf	
Return
Static Function ValPerg(cPerg)

	PutSx1(cPerg,'01','Emissao de            ?','','','mv_ch1','D',8,0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'02','Emissao Ate           ?','','','mv_ch2','D',8,0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'03','Pedido de             ?','','','mv_ch3','C',06,0,0,'G','','','','','mv_par03',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'04','Pedido Ate            ?','','','mv_ch4','C',06,0,0,'G','','','','','mv_par04',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'05','Fornecedor de         ?','','','mv_ch5','C',06,0,0,'G','','SA2','','','mv_par05',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'06','Fornecedor Ate        ?','','','mv_ch6','C',06,0,0,'G','','SA2','','','mv_par06',,,'','','','','','','','','','','','','','') 	
	PutSx1(cPerg,'07','Filial de         	 ?','','','mv_ch7','C',02,0,0,'G','','SM0','','','mv_par07',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'08','Filial Ate        	 ?','','','mv_ch8','C',02,0,0,'G','','SM0','','','mv_par08',,,'','','','','','','','','','','','','','') 

Return
