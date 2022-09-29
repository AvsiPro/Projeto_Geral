  
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ TTFATR04³ Autor ³ Fabio Sales            ³ Data ³ 29/03/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ RELATORIO DE COMPRAS		                                   ±±
±±³          ³                                                             ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ COMPRAS                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function TTCOMR04()
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
±±³Fun‡…o    ³ REPORTDEF³ Autor ³ Fabio Sales           ³ Data ³ 29/03/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao Principal de Impressao                               ±±
±±³          ³                                                             ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ COMPRAS                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ReportDef()

	Local oReport
	Local oSection
	Private cPerg    := "TTCOMR04"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New("TTCOMR04","RELATORIO DE COMPRAS","",{|oReport| PrintReport(oReport)},"ESTE RELATORIO IMPRIMIRAR AS NOTAS DE COMPRAS")
	
	// Seção  Dados da Nota Fiscal
	oSection1 := TRSection():New(oReport,OemToAnsi("Nota de Entrada"),{"TRB"})
	//                      CAMPO   ALIAS  TITULO   PIC TAMANHO
	
	TRCell():New(oSection1,"FILIAL"		,"TRB","FILIAL	"	,"@!",02)
	TRCell():New(oSection1,"NOTA"		,"TRB","NOTA	"	,"@!",09)
	TRCell():New(oSection1,"SERIE"		,"TRB","SERIE	"	,"@!",03)	
	TRCell():New(oSection1,"DAT_DIGIT"	,"TRB","DATA_DIGIT"	,    ,08)
	TRCell():New(oSection1,"COD_FOR"	,"TRB","COD_FORN"	,"@!",06)
	TRCell():New(oSection1,"FORNECE"	,"TRB","FORNECEDOR	"	,"@!",40)	
	TRCell():New(oSection1,"LOJA"		,"TRB","LOJA	"	,"@!",04)
	TRCell():New(oSection1,"PRODUTO"	,"TRB","COD_PROD"	,"@!",15)
	TRCell():New(oSection1,"DESCPRO"	,"TRB","DESC_PROD"	,"@!",30)
	TRCell():New(oSection1,"CODPC"		,"TRB","COD_PIS/CONFINS	","@!",03)
	TRCell():New(oSection1,"DESCPC"		,"TRB","DESC_PIS/CONFINS","@!",13)
	TRCell():New(oSection1,"TES"		,"TRB","TES		"	,"@!",03)
	TRCell():New(oSection1,"CFOP "		,"TRB","CFOP	"	,"@!",05)
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
±±³Fun‡…o    ³ PrintReport³ Autor ³ Fabio Sales         ³ Data ³ 29/03/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao Responsável pela impessão do relatório               ±±
±±³          ³                                                             ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ COMPRAS                                                    ³±±
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

     Local clTabSec3:="21"
     Local clDescSec3   :=SPACE(30)
     Local clAPPC
          
	// Criacao arquivo de Trabalho
	_aStru	:= {}
		
 	AADD(_aStru,{"CODPC","C",03,0})
	AADD(_aStru,{"DESCPC","C",13,0})
	AADD(_aStru,{"NOTA","C",09,0})
	AADD(_aStru,{"SERIE","C",03,0})
	AADD(_aStru,{"COD_FOR","C",06,0})
	AADD(_aStru,{"FORNECE","C",40,0})	
	AADD(_aStru,{"LOJA","C",04,0})
	AADD(_aStru,{"PRODUTO","C",15,0})
	AADD(_aStru,{"DESCPRO","C",30,0})	
	AADD(_aStru,{"TES","C",03,0})
	AADD(_aStru,{"CFOP","C",05,0})
	AADD(_aStru,{"GRUPTRIB","C",06,0})
	AADD(_aStru,{"DESCGRTRI","C",30,0})                                 
	AADD(_aStru,{"TOTAL","N",14,2})
	AADD(_aStru,{"PIS","N",14,2})
	AADD(_aStru,{"CONFINS","N",14,2})
	AADD(_aStru,{"FINALID","C",254,0})                                 
	AADD(_aStru,{"FILIAL","C",02,0})
	AADD(_aStru,{"DAT_DIGIT","D",08,0})
		
   	_cArq     := CriaTrab(_aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)
	                                            
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	IndRegua("TRB",_cIndice,"FORNECE",,,"Selecionando Registros...")
	
	// Montagem da Query com dados das Notas Fiscais		
	
	clQuery := " SELECT D1_FILIAL,D1_DOC,D1_COD,D1_SERIE,D1_DTDIGIT,D1_FORNECE,D1_LOJA,A2_NOME,B1_DESC, "
	clQuery += " B1_GRTRIB,B1_XRTPC,D1_TES,D1_CF,D1_TOTAL,D1_VALIMP5,D1_VALIMP6, F4_FINALID "
	clQuery += " FROM "+RetSQLName("SD1")+" AS SD1 INNER JOIN "+RetSQLName("SB1")+" AS SB1 ON "
	clQuery += " D1_COD = B1_COD AND SD1.D_E_L_E_T_ = SB1.D_E_L_E_T_ "
	clQuery += " INNER JOIN "+RetSQLName("SA2")+" AS SA2 ON D1_FORNECE = A2_COD AND "                                                                            
	clQuery += " D1_LOJA = A2_LOJA AND SD1.D_E_L_E_T_ = SA2.D_E_L_E_T_ "
	clQuery += " INNER JOIN "+RetSQLName("SF4")+" AS SF4 ON "
	clQuery += " D1_TES =F4_CODIGO AND SD1.D_E_L_E_T_ = SF4.D_E_L_E_T_  "
	clQuery += " WHERE (D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"')  "
	clQuery += " AND (D1_DOC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"') AND "
	clQuery += " (D1_SERIE BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"') AND "
	clQuery += " SD1.D1_FILIAL ='"+xFilial("SD1")+"' AND SB1.B1_FILIAL ='"+xFilial("SB1")+"' AND "
	clQuery += " SA2.A2_FILIAL ='"+xFilial("SA2")+"' AND SF4.F4_FILIAL ='"+xFilial("SF4")+"' AND "
	clQuery += " D1_TIPO ='N' AND (SF4.F4_DUPLIC = 'S') "
	clQuery += " AND SD1.D_E_L_E_T_='' "
		
	IF SELECT("COMP") > 0
		dbSelectArea("COMP")
		DbCloseArea()
	ENDIF
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,clQuery),"COMP",.F.,.T.)
	
	// AJUSTA CASAS DECIMAIS NO RETORNO DA QUERY
	
	TcSetField("COMP","D1_TOTAL"	,"N",14,2)
	TcSetField("COMP","D1_VALIMP5"	,"N",14,2)
	TcSetField("COMP","D1_VALIMP6"	,"N",14,2)
	TcSetField("COMP","D1_DTDIGIT"	,"D",08,0)
		
	dbSelectArea("COMP")
	dbGotop()
	
	Do While COMP->(!Eof())
	
	
		MsProcTxt("Processando Item "+COMP->D1_COD)
	     
		IF COMP->B1_XRTPC=="001"
	     	clAPPC:="ALÍQUOTA ZERO"
		ELSEIF COMP->B1_XRTPC=="002"
			clAPPC:="CUMULATIVO"
		ELSEIF COMP->B1_XRTPC=="003"
			clAPPC:="MONOFÁSICO"
		ELSE
		 	clAPPC:=" "
		ENDIF
		
		DBSELECTAREA("SX5")
		DBSETORDER(1)
	     
		IF DBSEEK(XFILIAL("SX5")+clTabSec3+COMP->B1_GRTRIB)
			clDescSec3:=X5_DESCRI
		ENDIF	     
	           
		DbSelectArea("TRB")
	     // ADICIONA REGISTRO EM BRANCO
	     RecLock("TRB",.T.)
	     
	                       
	     	TRB->CODPC		:= COMP->B1_XRTPC
	        TRB->DESCPC		:= clAPPC  
	     	TRB->COD_FOR	:= COMP->D1_FORNECE
	      	TRB->FORNECE	:= COMP->A2_NOME	      	
	      	TRB->LOJA		:= COMP->D1_LOJA	        	      	
		    TRB->NOTA		:= COMP->D1_DOC
	    	TRB->PRODUTO	:= COMP->D1_COD
	        TRB->DESCPRO	:= COMP->B1_DESC	        
	        TRB->TOTAL		:= COMP->D1_TOTAL	       
	        TRB->PIS		:= COMP->D1_VALIMP5
	        TRB->CONFINS	:= COMP->D1_VALIMP6	        	       
	        TRB->SERIE		:= COMP->D1_SERIE
	        TRB->CFOP		:= COMP->D1_CF 
	        TRB->TES		:= COMP->D1_TES	       
	        TRB->FINALID   	:= COMP->F4_FINALID 	       
	        TRB->FILIAL   	:= COMP->D1_FILIAL
	        TRB->DAT_DIGIT	:= COMP->D1_DTDIGIT	        	        
	        TRB->GRUPTRIB  	:= COMP->B1_GRTRIB
	        TRB->DESCGRTRI	:= clDescSec3    
	        	        	         	        	     	        
	    MsUnlock()
		clDescSec3  :=SPACE(30)
	      dbSelectArea("COMP")
	     DbSkip()
	Enddo
	
	If Select("COMP") > 0
		dbSelectArea("COMP")
		DbCloseArea()
	EndIf
	
Return

Static Function ValPerg(cPerg)

	PutSx1(cPerg,'01','DTDIGIT de            ?','','','mv_ch1','D',8,0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'02','DTDIGIT Ate           ?','','','mv_ch2','D',8,0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'03','Nota de               ?','','','mv_ch3','C',09,0,0,'G','','','','','mv_par03',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'04','Nota Ate              ?','','','mv_ch4','C',09,0,0,'G','','','','','mv_par04',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'05','Serie de              ?','','','mv_ch5','C',03,0,0,'G','','','','','mv_par05',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'06','Serie Ate             ?','','','mv_ch6','C',03,0,0,'G','','','','','mv_par06',,,'','','','','','','','','','','','','','') 

Return
