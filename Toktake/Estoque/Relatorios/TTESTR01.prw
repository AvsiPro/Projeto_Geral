  
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ TTESTR01³ Autor ³ Fabio Sales            ³ Data ³ 29/03/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ SALDO ESTOQUE											   ±±
±±³          ³                                                             ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ ESTOQUE                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function TTESTR01()
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
±±³Fun‡…o    ³ REPORTDEF³ Autor ³ Fabio Sales           ³ Data ³ 29/03/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao Principal de Impressao                               ±±
±±³          ³                                                             ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Compras                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ReportDef()

	Local oReport
	Local oSection
	Private cPerg    := "TTEST01"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New("TTESTR01","RELATORIO DE SALDO EM ESTOQUE","",{|oReport| PrintReport(oReport)},"ESTE RELATORIO IMPRIMIR OS SAUDOS FISICOS DOESTOQUE")
	
	// Seção  Dados da Nota Fiscal
	oSection1 := TRSection():New(oReport,OemToAnsi("SALDO EM ESTOQUE"),{"TRB"})
	//                      CAMPO   	 ALIAS  TITULO   		PIC TAMANHO
	
	TRCell():New(oSection1,"FILIAL"		,"TRB","FILIAL		"	,"@!",02)
	TRCell():New(oSection1,"LOC"		,"TRB","ARMAZEM	"	,"@!",06)
	TRCell():New(oSection1,"DESCARM"	,"TRB","DESC_ARMAZEM"	,"@!",30)		
	TRCell():New(oSection1,"COD"		,"TRB","PRODUTO		"	,"@!",15)
	TRCell():New(oSection1,"DESCRI"		,"TRB","DESC_PROD	"	,"@!",30)
	TRCell():New(oSection1,"TIPO"		,"TRB","TIPO		"	,"@!",02)	
	TRCell():New(oSection1,"GRUPO"		,"TRB","GRUPO		"	,"@!",04)
	TRCell():New(oSection1,"XSUBGRU"	,"TRB","SUBGRUPO	"	,"@!",04)			
	TRCell():New(oSection1,"UM"			,"TRB","UNID_MED 	"	,"@!",02)
	TRCell():New(oSection1,"QATU"		,"TRB","SALDO ATUAL	"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"CUSTD"		,"TRB","CUST_STAND	"	,"@E 999,999.99",16)	
	TRCell():New(oSection1,"URPC"		,"TRB","PRÇO_ULTMA_COMP","@E 999,999.99",16)
			
Return oReport

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PrintReport³ Autor ³ Fabio Sales         ³ Data ³ 29/03/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao Responsável pela impessão do relatório               ±±
±±³          ³                                                             ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Compras                                                    ³±±
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
			    
	AADD(_aStru,{"FILIAL"	,"C",02,0})
	AADD(_aStru,{"COD"		,"C",15,0})
	AADD(_aStru,{"DESCRI"	,"C",30,0})		
	AADD(_aStru,{"TIPO"		,"C",02,0})
	AADD(_aStru,{"GRUPO"	,"C",04,0})
	AADD(_aStru,{"UM"		,"C",02,0})	
	AADD(_aStru,{"LOC"		,"C",06,0})
	AADD(_aStru,{"DESCARM"	,"C",30,0})
	AADD(_aStru,{"QATU"		,"N",14,2})
	AADD(_aStru,{"CUSTD"	,"N",14,2})
	AADD(_aStru,{"URPC"		,"N",14,2})
	AADD(_aStru,{"XSUBGRU"	,"C",04,0})
	
   	_cArq     := CriaTrab(_aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)
	                                            
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	IndRegua("TRB",_cIndice,"COD",,,"Selecionando Registros...")
	                     
	// Montagem da Query com dados dos pedido de compras em aberto		
	// Seleciona os pedidos de compras e aberto	
	
	cQuery := "SELECT B2_COD,B1_TIPO,B1_GRUPO ,B1_XSUBGRU,B1_DESC,B1_CUSTD, 	"       
	cQuery += "B1_UM,B2_LOCAL,ZZ1_DESCRI,B2_FILIAL,B2_QATU,B1_UPRC "
	cQuery += " FROM "+RetSqlName("SB2")+" SB2, "+RetSqlName("SB1")+" SB1, "+RetSqlName("ZZ1")+" ZZ1 "
	cQuery += " WHERE"
	cQuery += " B2_FILIAL ='"+xFilial("SB2")+"' AND B1_FILIAL ='"+xFilial("SB1")+"'AND ZZ1_FILIAL ='"+xFilial("ZZ1")+"' " "
	cQuery += " AND B2_LOCAL BETWEEN '" + mv_par01 + "' AND '"  + mv_par02 + "' "
	cQuery += " AND B1_COD 	 BETWEEN '" + mv_par03 + "' AND '"  + mv_par04 + "' "
	cQuery += " AND B1_TIPO  BETWEEN '" + mv_par05 + "' AND '"  + mv_par06 + "' "
	cQuery += " AND B1_GRUPO BETWEEN '" + mv_par07 + "' AND '"  + mv_par08 + "' "
	cQuery += " AND B1_COD  = B2_COD "
	cQuery += " AND ZZ1_COD  = B2_LOCAL "
	cQuery += " AND SB2.D_E_L_E_T_ = ' ' "
	cQuery += " AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY B2_LOCAL "
		
	IF SELECT("SALD") > 0
		dbSelectArea("SALD")
		DbCloseArea()
	ENDIF
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"SALD",.F.,.T.)
	
	// AJUSTA CASAS DECIMAIS NO RETORNO DA QUERY
	
	TcSetField("SALD","B2_QATU"	,"N",14,2)
	TcSetField("SALD","B1_UPRC"	,"N",14,2)
	TcSetField("SALD","B1_CUSTD","N",14,2)
		
	dbSelectArea("SALD")
	dbGotop()
		
	While SALD->(!Eof())
		     	      		       
	     DbSelectArea("TRB")
	     // ADICIONA REGISTRO EM BRANCO
	    RecLock("TRB",.T.)
	     	TRB->FILIAL		:= SALD->B2_FILIAL
	     	TRB->COD		:= SALD->B2_COD
	     	TRB->DESCRI		:= SALD->B1_DESC
	      	TRB->TIPO		:= SALD->B1_TIPO
	      	TRB->GRUPO		:= SALD->B1_GRUPO
	      	TRB->XSUBGRU	:= SALD->B1_XSUBGRU	        	      		        	      	
	        TRB->UM			:= SALD->B1_UM	        
	        TRB->LOC		:= SALD->B2_LOCAL
	        TRB->DESCARM	:= SALD->ZZ1_DESCRI
	        TRB->QATU		:= SALD->B2_QATU
	        TRB->URPC		:= SALD->B1_UPRC
	        TRB->CUSTD		:= SALD->B1_CUSTD
	        
	      MsUnlock()
	      
	      
	      dbSelectArea("SALD")
	      DBSKIP()  
	Enddo
	
	If Select("SALD") > 0
		dbSelectArea("SALD")
		DbCloseArea()
	EndIf
	
Return

Static Function ValPerg(cPerg)

	PutSx1(cPerg, '01', 'Armazem de         ?','' ,'' , 'mv_ch1', 'C', 06, 0, 0, 'G', '', '', '', '', 'mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg, '02', 'Armazem Ate        ?','' ,'' , 'mv_ch2', 'C', 06, 0, 0, 'G', '', '', '', '', 'mv_par02',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg, '03', 'Produto de         ?','' ,'' , 'mv_ch3', 'C', 15, 0, 0,'G', '', 'SB1', '', '', 'mv_par03',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg, '04', 'Produto Ate        ?','' ,'' , 'mv_ch4', 'C', 15, 0, 0,'G', '', 'SB1', '', '', 'mv_par04',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg, '05', 'Tipo    de         ?','' ,'' , 'mv_ch5', 'C', 02, 0,0, 'G', '', '2','','','mv_par05',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg, '06', 'Tipo    Ate        ?','' ,'' , 'mv_ch6', 'C', 02, 0,0, 'G', '', '2','','','mv_par06',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg, '07', 'Grupo   de         ?','' ,'' , 'mv_ch7', 'C', 04, 0, 0, 'G', '', 'SBM','',''  , 'mv_par07',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg, '08', 'Grupo   Ate        ?','' ,'' , 'mv_ch8', 'C', 04, 0, 0, 'G', '', 'SBM', '', '', 'mv_par08',,,'','','','','','','','','','','','','','')

Return
