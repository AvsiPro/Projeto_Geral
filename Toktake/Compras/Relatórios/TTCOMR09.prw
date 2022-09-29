
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
¦¦¦Funçào    ¦TTCOMR09() ¦ Autor ¦ FABIO SALES		    ¦ Data ¦20.05.2011¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ NOTAS COM TITULOS BLOQUEADOS	POR DIVERGENCIA		          ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦COMPRAS	                                             	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/  

User Function TTCOMR09()
	Local oReport
	If cEmpAnt == "01"
		If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
			oReport := ReportDef()
			oReport:PrintDialog()	
		EndIf
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
	Private cPerg    := "TTCOMR09"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New("BLOQUEIO","RELATORIO DE NOTAS BLOQUEADAS","",{|oReport| PrintReport(oReport)},"ESTE RELATORIO IMPRIMIRÁ AS NOTAS BLOQUEADAS")
	
	/*-------------------------| 		    			           
	| seção dos titulo a pagar | 
	|-------------------------*/
	
	oSection1 := TRSection():New(oReport,OemToAnsi("NOTAS BLOQUEADAS"),{"TRB"})
	
	/*----------------------------------------------------------------------------------| 		    			           
	|                       campo        alias  título       	 pic           tamanho  | 
	|----------------------------------------------------------------------------------*/ 
		
	TRCell():New(oSection1,"FILIAL"		,"TRB","FILIAL	"			,"@!"			,02)
	TRCell():New(oSection1,"NOTA"		,"TRB","NOTA"				,"@!"			,09)
	TRCell():New(oSection1,"SERIE"		,"TRB","SERIE"				,"@!"			,03)
	TRCell():New(oSection1,"FORNECE"	,"TRB","COD.FORN	"		,"@!"			,06)
	TRCell():New(oSection1,"NOME"		,"TRB","FORNECEDOR	"		,"@!"			,35)				
	TRCell():New(oSection1,"LOJA"		,"TRB","LOJA		"		,"@!"			,04)
	TRCell():New(oSection1,"PRODUTO"	,"TRB","PRODUTO	"			,"@!"			,15)
	TRCell():New(oSection1,"DESC"		,"TRB","DESC_PROD	"		,"@!"			,30)	
	TRCell():New(oSection1,"QTDE_N"		,"TRB","QTDE_NOTA	"		,"@E 999,999,999.9999",14)
	TRCell():New(oSection1,"QTDE_P"		,"TRB","QTDE_PEDIDO	"		,"@E 999,999,999.9999",14)
	TRCell():New(oSection1,"QTDE_N_P"	,"TRB","DIF_QTDE_NOTA_PEDIDO","@E 999,999,999.9999",14)		
	TRCell():New(oSection1,"QTDE_C"		,"TRB","QTDE_ENTREGUE	"	,"@E 999,999,999.9999",14)	
	TRCell():New(oSection1,"QTDE_N_C"	,"TRB","DIF_QTDE_NOTA_CONFER","@E 999,999,999.9999",14)	
	TRCell():New(oSection1,"VALUNITN"	,"TRB","VAL.UNIT.NOTA	"	,"@E 999,999,999.9999",14)		
	TRCell():New(oSection1,"VALUNITP"	,"TRB","VAL.UNIT.PEDIDO	"	,"@E 999,999,999.9999",14)	
	TRCell():New(oSection1,"DIFVUNIT"	,"TRB","DIF_VALUNIT"		,"@E 999,999,999.9999",14)				
	TRCell():New(oSection1,"DESCONTO"	,"TRB","DESCONTO"			,"@E 999,999,999.9999",14)		
	TRCell():New(oSection1,"CONDPGN"	,"TRB","COND.PGTO_NOTA"		,"@!"			,04)		
	TRCell():New(oSection1,"CONDPGP"	,"TRB","COND.PGTO_PEDIDO"	,"@!"			,04)	
	TRCell():New(oSection1,"ENTRADA"	,"TRB","DT.ENTRADA"			,,08)	
	TRCell():New(oSection1,"MOTIVO1"	,"TRB","MOTIVO1"			,"@!"			,100)	
	TRCell():New(oSection1,"MOTIVO2"	,"TRB","MOTIVO2"			,"@!"			,100)	
	TRCell():New(oSection1,"MOTIVO3"	,"TRB","MOTIVO3"			,"@!"			,100)	
	TRCell():New(oSection1,"MOTIVO4"	,"TRB","MOTIVO4"			,"@!"			,100)	
			
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

	Local alParc 
	Local clvenclec

	/*-------------------------------| 		    			           
	| criação do arquivo de trabalho |
	|-------------------------------*/
	
	_aStru	:= {} 
				    	
	AADD(_aStru,{"FILIAL"	,"C",02,0})	
	AADD(_aStru,{"NOTA"		,"C",09,0})	
	AADD(_aStru,{"SERIE"	,"C",03,0})	
	AADD(_aStru,{"FORNECE"	,"C",06,0})	
	AADD(_aStru,{"NOME"		,"C",35,0})	
	AADD(_aStru,{"LOJA"		,"C",04,0})	
	AADD(_aStru,{"PRODUTO"	,"C",15,0})	
	AADD(_aStru,{"DESC"		,"C",35,0})	
	AADD(_aStru,{"QTDE_N"	,"N",14,4})
	AADD(_aStru,{"QTDE_P"	,"N",14,4})
	AADD(_aStru,{"QTDE_N_P"	,"N",14,4})
	AADD(_aStru,{"QTDE_C"	,"N",14,4})
	AADD(_aStru,{"QTDE_N_C"	,"N",14,4})
	AADD(_aStru,{"VALUNITN"	,"N",14,4})
	AADD(_aStru,{"VALUNITP"	,"N",14,4})
	AADD(_aStru,{"DIFVUNIT"	,"N",14,4})
	AADD(_aStru,{"DESCONTO"	,"N",14,4})
	AADD(_aStru,{"CONDPGN"	,"C",04,0})	
	AADD(_aStru,{"CONDPGP"	,"C",04,0})		
	AADD(_aStru,{"ENTRADA"	,"D",8,0})
	AADD(_aStru,{"MOTIVO1"	,"C",100,0})	
	AADD(_aStru,{"MOTIVO2"	,"C",100,0})	
	AADD(_aStru,{"MOTIVO3"	,"C",100,0})	
	AADD(_aStru,{"MOTIVO4"	,"C",100,0})	
		
   	_cArq     := CriaTrab(_aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)
	                                            
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	IndRegua("TRB",_cIndice,"NOTA",,,"Selecionando Registros...")
	                     
	/*-----------------------------------------------------| 		    			           
	| Montagem da query com os titulos a receber em aberto |
	|-----------------------------------------------------*/

	clDiverg := " SELECT D1_FILIAL "
	clDiverg += " ,D1_DOC     "
	clDiverg += " ,D1_SERIE   "
	clDiverg += " ,D1_FORNECE "
	clDiverg += " ,D1_LOJA    "
	clDiverg += " ,A2_NOME    "
	clDiverg += " ,D1_COD     "
	clDiverg += " ,B1_DESC    "
	clDiverg += " ,D1_QUANT   "
	clDiverg += " ,C7_QUANT   "
	clDiverg += " ,D1_XCLASPN "
	clDiverg += " ,F1_COND    "
	clDiverg += " ,C7_COND    "
	clDiverg += " ,D1_VUNIT   "
	clDiverg += " ,C7_PRECO   "
	clDiverg += " ,D1_VALDESC "
	clDiverg += " ,D1_TOTAL   "
	clDiverg += " ,C7_FORNECE "
	clDiverg += " ,C7_LOJA    "
	clDiverg += " ,D1_PEDIDO  "
	clDiverg += " ,C7_NUM     "
	clDiverg += " ,F4_ESTOQUE "
	clDiverg += " ,D1_DTDIGIT "	
	clDiverg += " FROM "+RetSqlName("SD1")+" AS SD1 INNER JOIN "+RetSqlName("SF1")+" AS SF1 "
	clDiverg += " ON D1_FILIAL=F1_FILIAL     "
	clDiverg += " AND D1_SERIE=F1_SERIE      "
	clDiverg += " AND D1_DOC=F1_DOC          "
	clDiverg += " AND D1_FORNECE=F1_FORNECE  "
	clDiverg += " AND D1_LOJA=F1_LOJA        "
	clDiverg += " AND D1_DTDIGIT =F1_DTDIGIT "
	clDiverg += " INNER JOIN "+RetSqlName("SB1")+" AS SB1 ON D1_COD=B1_COD       "
	clDiverg += " INNER JOIN "+RetSqlName("SA2")+" AS SA2 ON D1_FORNECE =A2_COD  "
	clDiverg += " AND D1_LOJA=A2_LOJA                      "
	clDiverg += " INNER JOIN "+RetSqlName("SF4")+" AS SF4 ON D1_FILIAL=F4_FILIAL "
	clDiverg += " AND D1_TES=F4_CODIGO LEFT JOIN "+RetSqlName("SC7")+"  AS SC7"
	clDiverg += " ON D1_FORNECE=C7_FORNECE "
	clDiverg += " AND D1_COD=C7_PRODUTO    "
	clDiverg += " AND D1_PEDIDO=C7_NUM     "
	clDiverg += " AND D1_ITEMPC =C7_ITEM   "
	clDiverg += " AND SF1.D_E_L_E_T_='' "
	clDiverg += " WHERE F1_XSTDIV ='B' "
	clDiverg += " AND D1_DTDIGIT BETWEEN '"+ Dtos(MV_PAR01) + "' AND'"+Dtos(MV_PAR02)+"' ORDER BY D1_DOC "
	
	IF SELECT("BLQNOTA") > 0                                                                                    
		dbSelectArea("BLQNOTA")
		DbCloseArea()
	ENDIF
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,clDiverg),"BLQNOTA",.F.,.T.)
	
	/*--------------------------------------------------| 		    			           
	| ajusta casas decimais e datas no retorno da query |
	|--------------------------------------------------*/

	TcSetField("BLQNOTA","C7_QUANT"		,"N",14,4)
	TcSetField("BLQNOTA","C7_PRECO"		,"N",14,4)
	TcSetField("BLQNOTA","D1_QUANT"		,"N",14,4)
	TcSetField("BLQNOTA","D1_VUNIT"		,"N",14,4)	
	TcSetField("BLQNOTA","D1_XCLASPN"	,"N",14,2)		
	TcSetField("BLQNOTA","D1_DTDIGIT"	,"D",08,0)
				
	dbSelectArea("BLQNOTA")
	dbGotop()
		
	While BLQNOTA->(!Eof())
	      
	     DbSelectArea("TRB")
	/*--------------------------|
	| adciona registro em banco |
	|--------------------------*/
	    RecLock("TRB",.T.) 
	    	    	     				    	
		TRB->FILIAL		:= BLQNOTA->D1_FILIAL
		TRB->NOTA		:= BLQNOTA->D1_DOC
		TRB->SERIE		:= BLQNOTA->D1_SERIE
		TRB->FORNECE	:= BLQNOTA->D1_FORNECE
		TRB->NOME		:= BLQNOTA->A2_NOME
		TRB->LOJA		:= BLQNOTA->D1_LOJA
		TRB->PRODUTO	:= BLQNOTA->D1_COD
		TRB->DESC		:= BLQNOTA->B1_DESC
		TRB->QTDE_N		:= BLQNOTA->D1_QUANT
		TRB->QTDE_P		:= BLQNOTA->C7_QUANT
		TRB->QTDE_N_P	:= BLQNOTA->(D1_QUANT - C7_QUANT)
		TRB->QTDE_C		:= BLQNOTA->D1_XCLASPN
		TRB->QTDE_N_C	:= BLQNOTA->(D1_QUANT - D1_XCLASPN)
		TRB->VALUNITN	:= BLQNOTA->D1_VUNIT
		TRB->VALUNITP	:= BLQNOTA->C7_PRECO
		TRB->DIFVUNIT	:= (BLQNOTA->D1_VUNIT - (BLQNOTA->C7_PRECO +(BLQNOTA->D1_VALDESC / BLQNOTA->D1_QUANT)))
		TRB->DESCONTO	:= BLQNOTA->D1_VALDESC
		TRB->CONDPGN	:= BLQNOTA->F1_COND
		TRB->CONDPGP	:= BLQNOTA->C7_COND
		TRB->ENTRADA	:= BLQNOTA->D1_DTDIGIT
		If !Empty(BLQNOTA->D1_PEDIDO)
			If ((BLQNOTA->D1_VUNIT - (BLQNOTA->C7_PRECO +(BLQNOTA->D1_VALDESC / BLQNOTA->D1_QUANT))) / BLQNOTA->C7_PRECO) * 100  > GetMv("MV_XDIVPC")
				TRB->MOTIVO1	:= "O valor na nota está maior do que o pedido" 
			Else
				TRB->MOTIVO1	:= ""
			EndIf
			If (BLQNOTA->(D1_QUANT - C7_QUANT)/ BLQNOTA->C7_QUANT) * 100 > GetMv("MV_XDIVNF1")
				TRB->MOTIVO2 := "A quantidade da nota está maior do que o permidido a mais que o pedido"
			Else
					TRB->MOTIVO2 := ""
			EndIf 
			If  BLQNOTA->F1_COND <> BLQNOTA->C7_COND
				TRB->MOTIVO3	:= "condição de pagamento diferente"
			Else
				TRB->MOTIVO3	:=""
			EndIf
			If ((BLQNOTA->D1_QUANT - BLQNOTA->D1_XCLASPN)/BLQNOTA->D1_QUANT) * 100 > GetMv("MV_XDIVNF3") .OR.;
				((BLQNOTA->D1_QUANT - BLQNOTA->D1_XCLASPN)/BLQNOTA->D1_QUANT) * 100 < GetMv("MV_XDIVNF3")
				TRB->MOTIVO4	:= "A quantidade entregue está maior ou menor que o permitido"
			Else
				TRB->MOTIVO4	:= ""
			EndIf
		Else
			TRB->MOTIVO1:="Nota Fiscal sem pedido"
			TRB->MOTIVO2:=""
			TRB->MOTIVO3:=""
			TRB->MOTIVO4:="" 
		EndIf
	   	           	    	        	            
	 	MsUnlock()
	    	      
	  	dbSelectArea("BLQNOTA")
	   	DBSKIP()  
	Enddo	
	If Select("BLQNOTA") > 0
		dbSelectArea("BLQNOTA")
		DbCloseArea()
	EndIf	
Return

Static Function ValPerg(cPerg) 
	PutSx1(cPerg,'01','Entrada de       ?','','','mv_ch1','D',08,0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'02','Entrada ate      ?','','','mv_ch2','D',08,0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')		
Return
