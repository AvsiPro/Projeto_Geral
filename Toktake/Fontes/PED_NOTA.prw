#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ COMPVEN³ Autor ³ Fabio Sales             ³ Data ³ 02/02/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pedido de compra x Nota de entrada                          ±±
±±³          ³                                                             ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Faturamento                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PED_NOTA()
	Local oReport
	If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
		oReport := ReportDef()
		oReport:PrintDialog()	
	EndIf
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ REPORTDEF³ Autor ³ Fabio Sales           ³ Data ³ 02/02/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao Principal de Impressao                               ±±
±±³          ³                                                             ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Faturamento                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ReportDef()

	Local oReport
	Local oSection
   	Private cPerg    := "PED_NOT"
	ValPerg(cPerg)
   	Pergunte(cPerg,.T.)
	oReport := TReport():New("PED_NOTA","PEDIDO X NOTA ",cPerg,{|oReport| PrintReport(oReport)},"Este relatorio tem como finalidade mostrar a diferenca entre pedido e nota")
	
//	 Seção  Dados da Nota Fiscal
	oSection1 := TRSection():New(oReport,OemToAnsi("Pedido X Nota"),{"TRB"})
	//                      CAMPO   ALIAS  TITULO   PIC TAMANHO
	
	TRCell():New(oSection1,"FILIAL"		,"TRB","FILIAL		","@!",02)
	TRCell():New(oSection1,"COD_FOR"	,"TRB","FORNECEDOR	","@!",06)
	TRCell():New(oSection1,"FORNECE"	,"TRB","RAZ_SOCIAL	","@!",40)
	TRCell():New(oSection1,"LOJA"		,"TRB","LOJA		","@!",04)
	TRCell():New(oSection1,"NUMPED"		,"TRB","NUM_PEDIDO	","@!",06)
	TRCell():New(oSection1,"EMISSAO"	,"TRB","DATA		",,08)
	TRCell():New(oSection1,"NOTA"		,"TRB","COD_NOTA	","@!",09)
	TRCell():New(oSection1,"SERIE"		,"TRB","SERIE		","@!",03)
	TRCell():New(oSection1,"DATA_NF"	,"TRB","DATA_NF		",,08)
	TRCell():New(oSection1,"QUANT_PED"	,"TRB","QUANT_PED	","@!",14)
	TRCell():New(oSection1,"QUANT_NOTA"	,"TRB","QUANT_NOTA	","@!",14)
	TRCell():New(oSection1,"DIFER_QT"	,"TRB","DIFER_QUANT	","@E 999,999.99",14)
	TRCell():New(oSection1,"PR_PEDIDO"	,"TRB","PR_PEDIDO	","@E 999,999.99",14)
	TRCell():New(oSection1,"PR_NOTA"	,"TRB","PR_NOTA		","@E 999,999.99",14)
	TRCell():New(oSection1,"DIFER_PR"	,"TRB","DIFER_PR	","@E 999,999.99",14)
	TRCell():New(oSection1,"TOT_PEDIDO"	,"TRB","TOT_PEDIDO	","@E 999,999.99",14)
	TRCell():New(oSection1,"TOT_NOTA"	,"TRB","TOT_NOTA	","@E 999,999.99",14)
	TRCell():New(oSection1,"DIFER_TOT"	,"TRB","DIFER_TOT	","@E 999,999.99",14)
				
Return oReport

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PrintReport³ Autor ³ Fabio Sales         ³ Data ³ 31/01/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao Responsável pela impessão do relatório               ±±
±±³          ³                                                             ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Faturamento                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function PrintReport(oReport)

	Local oSection1 := oReport:Section(1)
	
	// Selecao dos dados a Serem Impressos // Carrega o Arquivo Temporario de Trabalho
	
	MsAguarde({|| fSelDados()},"Selecionando Itens")
	
	// Impressao da Primeira secao 
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

// Selecao dos dados a serem impressos // criacao do temporario

Static Function fSelDados()

	// Criacao arquivo de Trabalho
	_aStru	:= {} 
					
	AADD(_aStru,{"FILIAL","C",02,0})
	AADD(_aStru,{"COD_FOR","C",06,0})
	AADD(_aStru,{"FORNECE","C",40,0})
	AADD(_aStru,{"LOJA","C",04,0})
	AADD(_aStru,{"NUMPED","C",06,0})
	AADD(_aStru,{"EMISSAO","D",08,0})
	AADD(_aStru,{"NOTA","C",09,0})
	AADD(_aStru,{"SERIE","C",03,0})
	AADD(_aStru,{"DATA_NF","D",08,0})
	AADD(_aStru,{"QUANT_PED","N",14,2})
	AADD(_aStru,{"QUANT_NOTA","N",14,2})
	AADD(_aStru,{"DIFER_QT","N",14,2})
	AADD(_aStru,{"PR_PEDIDO","N",14,2})
	AADD(_aStru,{"PR_NOTA","N",14,2})
	AADD(_aStru,{"DIFER_PR","N",14,2})
	AADD(_aStru,{"TOT_PEDIDO","N",14,2})
	AADD(_aStru,{"TOT_NOTA","N",14,2})
	AADD(_aStru,{"DIFER_TOT","N",14,2})
	
   	_cArq     := CriaTrab(_aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)
	                                            
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	IndRegua("TRB",_cIndice,"FORNECE",,,"Selecionando Registros...")
	
	// Montagem da Query com dados dos pedidos de compras e nota fiscal de entrada//		
	
	_cQuery :=" SELECT C7_FILIAL,C7_FORNECE,						"
	_cQuery+="C7_LOJA,C7_NUM,C7_EMISSAO,							"
	_cQuery+=" D1_DOC,D1_SERIE,D1_DTDIGIT,C7_QUANT,					"
	_cQuery+="D1_QUANT,(D1_QUANT-C7_QUANT) AS DIFER_QUANT, 			"
	_cQuery+=" C7_PRECO,D1_VUNIT,(D1_VUNIT-C7_PRECO) AS DIFER_VAL,	"
	_cQuery+=" C7_TOTAL,D1_TOTAL,(D1_TOTAL-C7_TOTAL) AS DIFER_TOTAL	"
	_cQuery+= "FROM "+RetSQLName("SC7")+" SC7, "+RetSQLName("SD1")+" SD1 "
   	_cQuery+= "WHERE C7_FILIAL ='"+xFilial("SC7")+"'	"	
	_cQuery+= "AND D1_FILIAL   ='"+xFilial("SD1")+"'	"	
   	_cQuery+=" AND D1_FILIAL=C7_FILIAL 	"
	_cQuery+=" AND D1_PEDIDO=C7_NUM		"
	_cQuery+=" AND D1_ITEMPC=C7_ITEM	"
	IF MV_PAR05==1       
   	  	_cQuery+= "AND	(D1_QUANT-C7_QUANT)<>0	"
 	ELSEIF MV_PAR05==2
	 	_cQuery+= "AND	(D1_VUNIT-C7_PRECO)<>0	"
	ELSEIF MV_PAR05==3
	 	_cQuery+= "AND ((D1_QUANT-C7_QUANT)<>0 OR (D1_VUNIT-C7_PRECO)<>0)	"
	ELSE                                                                     
	ENDIF
	_cQuery+= " AND D1_DTDIGIT	BETWEEN '"+DTOS(MV_PAR01)+"'   AND '"+DTOS(MV_PAR02)+"'	"
	_cQuery+= " AND D1_COD   	BETWEEN '"+MV_PAR03+"'    AND '"+MV_PAR04+"'	"
	_cQuery+= " AND D1_DOC   	BETWEEN '"+MV_PAR06+"'    AND '"+MV_PAR07+"'	"
                                                                     
	_cQuery+= " AND	SC7.D_E_L_E_T_=''	"
	_cQuery+= " AND	SD1.D_E_L_E_T_=''   "                                                                                                                "
		                                                                                                 
	//* Verifica se a Query Existe, se existir fecha//
	If Select("TSQL2") > 0
		dbSelectArea("TSQL2")
		DbCloseArea()
	EndIf
	
	//* Cria a Query e da Um Apelido
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TSQL2",.F.,.T.)
	
	// ajusta casas decimais no retorn da query//
	
	TcSetField("TSQL2","D1_TOTAL","N",14,2)
	TcSetField("TSQL2","D1_QUANT","N",14,2)
	TcSetField("TSQL2","D1_VUNIT","N",14,2)
	TcSetField("TSQL2","C7_TOTAL","N",14,2)
	TcSetField("TSQL2","C7_QUANT","N",14,2)
	TcSetField("TSQL2","C7_PRECO","N",14,2)
	TcSetField("TSQL2","C7_EMISSAO","D",08,0)
	TcSetField("TSQL2","D1_DTDIGIT","D",08,0)	
	
	dbSelectArea("TSQL2")
	dbGotop()
	
	Do While TSQL2->(!Eof())
	     MsProcTxt("Processando Item "+TSQL2->C7_NUM )
	         
	    // Variaveis adicionais
	     _cNomeFor	:= Posicione("SA2",1,xFilial("SA2")+TSQL2->C7_FORNECE,"A2_NOME")
	     _cNomeFor  := Alltrim(_cNomeFor)
	     
	     DbSelectArea("TRB")
	     // alimenta a tabela temporaria//
	     RecLock("TRB",.T.)
	     
	     	TRB->FILIAL		:= TSQL2->C7_FILIAL
	      	TRB->COD_FOR	:= TSQL2->C7_FORNECE
		    TRB->FORNECE	:= _cNomeFor
	    	TRB->LOJA		:= TSQL2->C7_LOJA
	        TRB->NUMPED		:= TSQL2->C7_NUM
	        TRB->EMISSAO	:= TSQL2->C7_EMISSAO
	        TRB->NOTA 		:= TSQL2->D1_DOC
	        TRB->SERIE		:= TSQL2->D1_SERIE
	        TRB->DATA_NF	:= TSQL2->D1_DTDIGIT
	        TRB->QUANT_PED	:= TSQL2->C7_QUANT
	        TRB->QUANT_NOTA	:= TSQL2->D1_QUANT
	        TRB->DIFER_QT	:= TSQL2->DIFER_QUANT
	        TRB->PR_PEDIDO	:= TSQL2->C7_PRECO
	        TRB->PR_NOTA	:= TSQL2->D1_VUNIT
	        TRB->DIFER_PR	:= TSQL2->DIFER_VAL
	        TRB->TOT_PEDIDO := TSQL2->C7_TOTAL 
	        TRB->TOT_NOTA	:= TSQL2->D1_TOTAL
	        TRB->DIFER_TOT	:= TSQL2->DIFER_TOTAL
	          
	      MsUnlock()	
	      dbSelectArea("TSQL2")
	     DbSkip()
	Enddo
	
	If Select("TSQL2") > 0
		dbSelectArea("TSQL2")
		DbCloseArea()
	EndIf
	
Return    
    
Static Function ValPerg(cPerg)

	PutSx1(cPerg, '01', 'Data de     ?','' ,'' , 'mv_ch1', 'D', 8, 0, 0, 'G', '', '', '', '', 'mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg, '02', 'Data Ate    ?','' ,'' , 'mv_ch2', 'D', 8, 0, 0, 'G', '', '', '', '', 'mv_par02',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg, '03', 'Produto de  ?','' ,'' , 'mv_ch3', 'C', 15, 0,0, 'G', '', 'SB1', '', '', 'mv_par03',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg, '04', 'Produto Ate ?','' ,'' , 'mv_ch4', 'C', 15, 0,0, 'G', '', 'SB1', '', '', 'mv_par04',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg, '05', 'Diferença   ?','' ,'' , 'mv_ch5', 'N', 1 , 0,1 ,'C', '',    '', '', '','mv_par05',"Quantidade"," "," ","","Valor","","","QuantVal","","","Todos","","","","","")   
	PutSx1(cPerg, '06', 'Nota de     ?','' ,'' , 'mv_ch6', 'C', 09, 0,0, 'G', '', '', '', '', 'mv_par06',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg, '07', 'Nota Ate    ?','' ,'' , 'mv_ch7', 'C', 09, 0,0, 'G', '', '', '', '', 'mv_par07',,,'','','','','','','','','','','','','','') 
	
Return