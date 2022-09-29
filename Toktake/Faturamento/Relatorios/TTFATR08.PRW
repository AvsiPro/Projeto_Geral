
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ TTFATR08³ Autor ³ Fabio Sales            ³ Data ³ 31/01/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Comparativo Vendas x Custo                                  ±±
±±³          ³                                                             ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Faturamento                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function TTFATR08()
	Local oReport
	If cEmpAnt == "01"
		If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
			oReport := ReportDef()
			oReport:PrintDialog()	
		EndIf
	endif
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ REPORTDEF³ Autor ³ Fabio Sales           ³ Data ³ 31/01/10 ³±±
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
	Private _cQuebra := ' '
	Private cPerg    := "TTFATR08"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New("VENDAS E DEVOLUCOES","Vendas e Devoluções","",{|oReport| PrintReport(oReport)},"Este relatorio ira imprimir os produtod vendidos e devolvidos")
	
	// Seção  Dados da Nota Fiscal
	oSection1 := TRSection():New(oReport,OemToAnsi("vendas"),{"TRB"})
	//                      CAMPO   ALIAS  TITULO   PIC TAMANHO  
	
	TRCell():New(oSection1,"TIPO"		,"TRB","TIPO"		,"@!",20)	
	TRCell():New(oSection1,"FILIAL"		,"TRB","FILIAL	"	,"@!",02)
	TRCell():New(oSection1,"NOTA"		,"TRB","NOTA	"	,"@!",09)
	TRCell():New(oSection1,"SERIE"		,"TRB","SERIE	"	,"@!",03)
	TRCell():New(oSection1,"COD_CLI"	,"TRB","COD_CLI	"	,"@!",06)
	TRCell():New(oSection1,"CLIENTE"	,"TRB","CLIENTE	"	,"@!",40)
	TRCell():New(oSection1,"LOJA"		,"TRB","LOJA	"	,"@!",04)
	TRCell():New(oSection1,"PRODUTO"	,"TRB","COD_PROD"	,"@!",15)
	TRCell():New(oSection1,"DESCPRO"	,"TRB","DESC_PROD"	,"@!",30)
	TRCell():New(oSection1,"CODPC"		,"TRB","COD_PIS/CONFINS	","@!",03)
	TRCell():New(oSection1,"DESCPC"		,"TRB","DESC_PIS/CONFINS","@!",13)
	TRCell():New(oSection1,"TES"		,"TRB","TES		"	,"@!",03)
	TRCell():New(oSection1,"CFOP"		,"TRB","CFOP	"	,"@!",05)
	TRCell():New(oSection1,"NCM"		,"TRB","NCM		"	,"@!",10)
	TRCell():New(oSection1,"TOTAL"		,"TRB","TOT_MERC"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"GRUPTRIB"	,"TRB","GRUPO_TRIBUTAÇÃO"	,"@!",6)
	TRCell():New(oSection1,"DESCGRTRI"	,"TRB","DESC_GRUP_TRIB"	,"@!",30)	
	TRCell():New(oSection1,"PIS"   		,"TRB","PIS		"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"CONFINS"	,"TRB","CONFINS	"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"FINALID"	,"TRB","FINALID_TES","@!",30)
			
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
     Local clTipo
     Local clAPPC
     Local clTabSec3:="21"
     
	// Criacao arquivo de Trabalho
	_aStru	:= {}

	AADD(_aStru,{"TIPO","C",20,0})
	AADD(_aStru,{"CODPC","C",03,0})
	AADD(_aStru,{"DESCPC","C",13,0})				
	AADD(_aStru,{"NOTA","C",09,0})
	AADD(_aStru,{"SERIE","C",03,0})
	AADD(_aStru,{"COD_CLI","C",06,0})
	AADD(_aStru,{"CLIENTE","C",40,0})
	AADD(_aStru,{"PRODUTO","C",15,0})
	AADD(_aStru,{"DESCPRO","C",30,0})
	AADD(_aStru,{"TES","C",03,0})
	AADD(_aStru,{"CFOP","C",05,0})
	AADD(_aStru,{"NCM","C",10,0})
	AADD(_aStru,{"TOTAL","N",14,2})
	AADD(_aStru,{"PIS","N",14,2})
	AADD(_aStru,{"CONFINS","N",14,2})
	AADD(_aStru,{"FINALID","C",254,0})                                 
	AADD(_aStru,{"FILIAL","C",02,0})
	AADD(_aStru,{"LOJA","C",04,0})
	AADD(_aStru,{"GRUPTRIB","C",06,0})
	AADD(_aStru,{"DESCGRTRI","C",30,0})	

   	_cArq     := CriaTrab(_aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)
	                                            
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	IndRegua("TRB",_cIndice,"CLIENTE",,,"Selecionando Registros...")
	
	// Montagem da Query com dados das Notas Fiscais		
	// Seleciona as Notas Fiscais de Vendas e Devolução
		
	_cQuery := " SELECT "     
	_cQuery += " SD2.D2_TIPO AS TIPO , SD2.D2_CLIENTE, SD2.D2_DOC, SD2.D2_SERIE, SD2.D2_CF, SD2.D2_TES, SF4.F4_FINALID, SD2.D2_COD, "
	_cQuery += " SB1.B1_DESC,SB1.B1_GRTRIB,SB1.B1_XRTPC,SD2.D2_TOTAL,SD2.D2_VALIMP5, SD2.D2_VALIMP6,SD2.D2_FILIAL, SA1.A1_NOME, SA1.A1_LOJA "
	_cQuery += " FROM "
	_cQuery += " "+RetSQLName("SD2")+" AS SD2 LEFT OUTER JOIN "
	_cQuery += " "+RetSQLName("SA1")+" AS SA1 ON SD2.D2_CLIENTE = SA1.A1_COD AND SD2.D2_LOJA = SA1.A1_LOJA "
	_cQuery += " AND SD2.D_E_L_E_T_ = SA1.D_E_L_E_T_ LEFT OUTER JOIN "
	_cQuery += " "+RetSQLName("SB1")+" AS SB1 ON SD2.D2_COD = SB1.B1_COD "
	_cQuery += " AND SD2.D_E_L_E_T_ = SB1.D_E_L_E_T_ LEFT OUTER JOIN "
	_cQuery += " "+RetSQLName("SF4")+" AS SF4 ON SD2.D2_TES = SF4.F4_CODIGO AND SD2.D_E_L_E_T_ = SF4.D_E_L_E_T_ "
	_cQuery += " AND SD2.D2_FILIAL = SF4.F4_FILIAL "

	_cQuery += " WHERE "
	_cQuery += " (SD2.D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"') AND "
	_cQuery += " (SD2.D2_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"') AND (SD2.D2_DOC BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"') AND "                                          
	_cQuery += " SD2.D2_FILIAL ='"+xFilial("SD2")+"' AND SB1.B1_FILIAL ='"+xFilial("SB1")+"' AND SA1.A1_FILIAL ='"+xFilial("SA1")+"' AND SF4.F4_FILIAL ='"+xFilial("SF4")+"' AND (SD2.D2_TIPO IN( 'N','C')) AND (SF4.F4_DUPLIC = 'S') "
   
	_cQuery += " UNION ALL "
	
	_cQuery += " SELECT " 
	_cQuery += " SD1.D1_TIPO AS TIPO , SD1.D1_FORNECE, SD1.D1_DOC, SD1.D1_SERIE, SD1.D1_CF, SD1.D1_TES,SF4.F4_FINALID,SD1.D1_COD, "	
	_cQuery += " SB1.B1_DESC,SB1.B1_GRTRIB,SB1.B1_XRTPC,-SD1.D1_TOTAL,-SD1.D1_VALIMP5,-SD1.D1_VALIMP6,SD1.D1_FILIAL, SA1.A1_NOME, SA1.A1_LOJA "
	_cQuery += " FROM "
	_cQuery += " "+RetSQLName("SD1")+" AS SD1 LEFT JOIN "
	_cQuery += " "+RetSQLName("SB1")+" AS SB1 ON SD1.D1_COD = SB1.B1_COD AND SD1.D_E_L_E_T_ = SB1.D_E_L_E_T_ LEFT  JOIN "
	_cQuery += " "+RetSQLName("SA1")+" AS SA1 ON SD1.D1_FORNECE = SA1.A1_COD AND SD1.D1_LOJA = SA1.A1_LOJA "
	_cQuery += " AND SD1.D_E_L_E_T_ = SA1.D_E_L_E_T_ LEFT JOIN "
	_cQuery += " "+RetSQLName("SF4")+" AS SF4 ON SD1.D1_TES = SF4.F4_CODIGO AND SD1.D_E_L_E_T_ = SF4.D_E_L_E_T_ "
	_cQuery += " AND SD1.D1_FILIAL = SF4.F4_FILIAL  "

	_cQuery += " WHERE "
	_cQuery += " (SD1.D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"') AND "
	_cQuery += " (SD1.D1_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"') AND (SD1.D1_DOC BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"')  AND "
	_cQuery += " SD1.D1_FILIAL ='"+xFilial("SD1")+"' AND SB1.B1_FILIAL ='"+xFilial("SB1")+"' AND SA1.A1_FILIAL ='"+xFilial("SA1")+"' AND SF4.F4_FILIAL ='"+xFilial("SF4")+"' AND (SD1.D1_TIPO IN('C','D')) AND (SF4.F4_DUPLIC = 'S') "
	
	If Select("TSQL1") > 0
		dbSelectArea("TSQL1")
		DbCloseArea()
	EndIf
	
	//* Cria a Query e da Um Apelido
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TSQL1",.F.,.T.)
	
	// AJUSTA CASAS DECIMAIS NO RETORNO DA QUERY
	
	TcSetField("TSQL1","D2_TOTAL","N",14,2)
	
	dbSelectArea("TSQL1")
	dbGotop()
	
	Do While TSQL1->(!Eof())
	     MsProcTxt("Processando Item "+TSQL1->D2_COD)
	         
	     
	     IF TSQL1->TIPO=="N"
	     	clTipo:="VENDA"
	     ELSEIF TSQL1->TIPO=="C"
			clTipo:="COMP.VENDA"
		 ELSE
		 	clTipo:="DEVOLUCAO"
		 ENDIF
		 
		 IF  TSQL1->B1_XRTPC=="001"
	     	clAPPC:="ALÍQUOTA ZERO"
	     ELSEIF TSQL1->B1_XRTPC=="002"
			clAPPC:="CUMULATIVO"
		 ELSEIF TSQL1->B1_XRTPC=="003"
			clAPPC:="MONOFÁSICO"
		 ELSE
		 	clAPPC:=" "
		 ENDIF
		  
		 //condição para trazer o status da nota de saida.
		 		 
		 DBSELECTAREA("SX5")
	     DBSETORDER(1)
	     
	     IF DBSEEK(XFILIAL("SX5")+clTabSec3+TSQL1->B1_GRTRIB)
	     	clDescSec3:=X5_DESCRI
	     ENDIF
	   	          
	     DbSelectArea("TRB")
	     // ADICIONA REGISTRO EM BRANCO
	     RecLock("TRB",.T.)	     
	                       
	        TRB->TIPO		:= clTipo	     
	     	TRB->COD_CLI	:= TSQL1->D2_CLIENTE
	     	TRB->LOJA		:= TSQL1->A1_LOJA
	      	TRB->CLIENTE	:= TSQL1->A1_NOME
		    TRB->NOTA		:= TSQL1->D2_DOC
	    	TRB->PRODUTO	:= TSQL1->D2_COD
	        TRB->DESCPRO	:= TSQL1->B1_DESC	       
	        TRB->TOTAL		:= TSQL1->D2_TOTAL
	        TRB->CODPC		:= TSQL1->B1_XRTPC
	        TRB->DESCPC		:= clAPPC  
	        TRB->PIS		:= TSQL1->D2_VALIMP5
	        TRB->CONFINS	:= TSQL1->D2_VALIMP6	        
	        TRB->SERIE		:= TSQL1->D2_SERIE
	        TRB->CFOP		:= TSQL1->D2_CF 	       
	        TRB->TES		:= TSQL1->D2_TES
	        TRB->FINALID   	:= TSQL1->F4_FINALID 	       
	        TRB->FILIAL   	:= TSQL1->D2_FILIAL	       
	        TRB->GRUPTRIB	:= TSQL1->B1_GRTRIB
	        TRB->DESCGRTRI	:= clDescSec3	        
	        
	  	MsUnlock()
		clDescSec3  :=SPACE(30)
		clAPPC :=""		
	      dbSelectArea("TSQL1")
	     DbSkip()
	Enddo
	
	If Select("TSQL1") > 0
		dbSelectArea("TSQL1")
		DbCloseArea()
	EndIf
	
Return
Static Function ValPerg(cPerg)

	PutSx1(cPerg,'01','Emissao de            ?','','','mv_ch1','D',8,0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'02','Emissao Ate           ?','','','mv_ch2','D',8,0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'03','Produto de            ?','','','mv_ch3','C',15,0,0,'G','','SB1','','','mv_par03',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'04','Produto Ate           ?','','','mv_ch4','C',15,0,0,'G','','SB1','','','mv_par04',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'05','Nota de               ?','','','mv_ch5','C',09,0,0,'G','','','','','mv_par05',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'06','Nota Ate              ?','','','mv_ch6','C',09,0,0,'G','','','','','mv_par06',,,'','','','','','','','','','','','','','') 		
Return
