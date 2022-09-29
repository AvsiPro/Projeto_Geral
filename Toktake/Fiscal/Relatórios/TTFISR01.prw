  
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ TTFISR01³ Autor ³ Fabio Sales            ³ Data ³ 29/03/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ RELATORIO DO LIVRO FISCAL                                   ±±
±±³          ³                                                             ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ LIVROS FISCAIS                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function TTFISR01()
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
±±³Uso       ³ Livros Fiscais                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ReportDef()

	Local oReport
	Local oSection
	Private cPerg    := "TTFISR01"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New("TTFISR01","RELATORIO DE LIVROS FISCAIS","",{|oReport| PrintReport(oReport)},"ESTE RELATORIO IMPRIMIRAR OS LANÇAMENTOS FISCAIS PROVENIENTES DAS NOTAS DE SAÍDAS")
	
	// Seção  Dados da Nota Fiscal
	oSection1 := TRSection():New(oReport,OemToAnsi("LIVROS FISCAIS"),{"TRB"})
	//                      CAMPO   ALIAS  TITULO   PIC TAMANHO
                                                               
	TRCell():New(oSection1,"TIPO"		,"TRB","TIPO	"	,"@!",15)
	TRCell():New(oSection1,"FILIAL"		,"TRB","FILIAL	"	,"@!",02)
	TRCell():New(oSection1,"NOTA"		,"TRB","NOTA	"	,"@!",09)
	TRCell():New(oSection1,"SERIE"		,"TRB","SERIE	"	,"@!",03)
	TRCell():New(oSection1,"ENTRADA"	,"TRB","EMISSAO	"	,    ,08)	
	TRCell():New(oSection1,"CODCLI"		,"TRB","COD_CLIENTE","@!",06)
	TRCell():New(oSection1,"CLIENTE"	,"TRB","CLIENTE	"	,"@!",40)	
	TRCell():New(oSection1,"LOJA"		,"TRB","LOJA	"	,"@!",04)
	TRCell():New(oSection1,"CNPJ"		,"TRB","CNPJ/CPF "	,"@R 99.999.999/9999-99",14)
	TRCell():New(oSection1,"NATUREZA"	,"TRB","NATUREZA"	,"@!",10)	
	TRCell():New(oSection1,"ESTADO"		,"TRB","ESTADO	"	,"@!",02)	
	TRCell():New(oSection1,"CFOP "		,"TRB","CFOP	"	,"@!",05)	
	TRCell():New(oSection1,"TOTAL"		,"TRB","TOT_MERC"	,"@E 999,999.99",16)	
	TRCell():New(oSection1,"VALBRUT"	,"TRB","TOTBRUT"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"VALNOT"		,"TRB","TOTNOT	"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"VALCONT"	,"TRB","VAL_CONT_LIVRO	"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"ICMS"		,"TRB","ICMS	"	,"@E 999,999.99",16)
	TRCell():New(oSection1,"ICMS_ST"	,"TRB","ICMS_ST	"	,"@E 999,999.99",16)

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
±±³Uso       ³ Livros Fiscais                                             ³±±
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
	           
	AADD(_aStru,{"TIPO","C",15,0})
	AADD(_aStru,{"FILIAL","C",02,0})
	AADD(_aStru,{"ENTRADA","D",08,0})	
	AADD(_aStru,{"NOTA","C",09,0})
	AADD(_aStru,{"SERIE","C",03,0})
	AADD(_aStru,{"CODCLI","C",06,0})
	AADD(_aStru,{"CLIENTE","C",40,0})	
	AADD(_aStru,{"LOJA","C",04,0})
	AADD(_aStru,{"CNPJ","C",14,0})
	AADD(_aStru,{"NATUREZA","C",10,0})
	AADD(_aStru,{"ESTADO","C",02,0})		
	AADD(_aStru,{"CFOP","C",05,0})	
	AADD(_aStru,{"TOTAL","N",14,2})
	AADD(_aStru,{"VALBRUT","N",14,2})
	AADD(_aStru,{"VALNOT","N",14,2})
	AADD(_aStru,{"ICMS","N",14,2})
	AADD(_aStru,{"ICMS_ST","N",14,2})
	AADD(_aStru,{"VALCONT","N",14,2})

		
   	_cArq     := CriaTrab(_aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)
	                                            
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	IndRegua("TRB",_cIndice,"NOTA",,,"Selecionando Registros...")
	
	// Montagem da Query com dados das Notas Fiscais		
	// Seleciona as Notas FiscaiS de Compras e Devoluções	
	
	clQuery := " SELECT		F3_FILIAL, F2_EMISSAO, F3_NFISCAL,F3_SERIE,F3_CLIEFOR,F3_LOJA,F3_CFO,F3_VALCONT,		"
	clQuery += " 			(F2_VALMERC + F2_ICMSRET) AS TOTNOT,													"
	clQuery += "			F2_VALBRUT,F2_VALMERC,F2_VALFAT,F3_BASEICM,F3_VALICM,F3_ICMSRET,	'TIPO' =CASE		"
	clQuery += "  		 	WHEN F2_XFINAL='1' THEN 'VENDA DIRETA' ELSE CASE WHEN F2_XFINAL='2' THEN 'VENDA PA'		"
	clQuery += "			ELSE CASE WHEN F2_XFINAL='3'THEN 'TRANFERÊNCIA' ELSE CASE WHEN F2_XFINAL='4' THEN		" 
	clQuery += "			'ABASTECIMENTO' ELSE 'OUTRAS SAIDAS' END END END END,A1_NOME,A1_CGC,A1_NATUREZ,F2_EST	"	 
	clQuery += " FROM		"+RetSqlName("SF3")+" AS SF3,"+RetSqlName("SF2")+" AS SF2,"+RetSqlName("SA1")+" AS SA1	"
	clQuery += " WHERE		F3_FILIAL='"+xFilial("SF3")+"' AND F2_FILIAL='"+xFilial("SF2")+"' AND A1_FILIAL='"+xFilial("SA1")+"' "
	clQuery += " AND		F3_NFISCAL=F2_DOC AND F3_SERIE=F2_SERIE AND F3_CLIEFOR=F2_CLIENTE AND F3_LOJA=F2_LOJA	"
	clQuery += " AND		F2_CLIENTE=A1_COD AND F2_LOJA=A1_LOJA AND F3_CFO > 5000                                 "
	clQuery += " AND		F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'						"
	clQuery += " AND		F2_DOC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'										"
	clQuery += " AND		F2_SERIE BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'										"
	IF MV_PAR07==1
		clQuery += " AND F2_XFINAL ='3' "  // TRASNFERENÇA
	ELSEIF MV_PAR07==2    
		clQuery += " AND F2_XFINAL ='4' "  // ABASTECIMENTO
	ELSEIF MV_PAR07==3
		clQuery += " AND F2_XFINAL ='2' "  // VENDA PA
	ELSEIF MV_PAR07==4
		clQuery += " AND F2_XFINAL ='1' "  // VENDA DIRETA
	ELSEIF MV_PAR07==5
		clQuery += " AND F2_XFINAL ='5' "  // OUTRAS SAIDAS
	ENDIF
	clQuery += " AND		SF3.D_E_L_E_T_='' AND SF2.D_E_L_E_T_='' AND SA1.D_E_L_E_T_=''
	clQuery += " ORDER BY	F3_NFISCAL 
	
	
	IF SELECT("FISC") > 0
		dbSelectArea("FISC")
		DbCloseArea()
	ENDIF
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,clQuery),"FISC",.F.,.T.)
	
	// AJUSTA CASAS DECIMAIS NO RETORNO DA QUERY
	
	TcSetField("FISC","F2_VALMERC"	,"N",14,2)
	TcSetField("FISC","F2_VALBRUT"	,"N",14,2)
	TcSetField("FISC","F3_ICMSRET"	,"N",14,2)
	TcSetField("FISC","F3_VALICM"	,"N",14,2)
	TcSetField("FISC","F3_VALCONT"	,"N",14,2)
	TcSetField("FISC","F2_EMISSAO"	,"D",08,0)
	
	dbSelectArea("FISC")
	dbGotop()
	
	Do While FISC->(!Eof())
	           
	     DbSelectArea("TRB")
	     // ADICIONA REGISTRO EM BRANCO
	     RecLock("TRB",.T.)
	    	                  
	    	TRB->TIPO		:= FISC->TIPO        
	     	TRB->FILIAL		:= FISC->F3_FILIAL
	      	TRB->NOTA		:= FISC->F3_NFISCAL	      	
	      	TRB->SERIE		:= FISC->F3_SERIE
	      	TRB->CODCLI		:= FISC->F3_CLIEFOR
	      	TRB->CLIENTE	:= FISC->A1_NOME
		    TRB->LOJA		:= FISC->F3_LOJA
		    TRB->CNPJ		:= FISC->A1_CGC 
	    	TRB->NATUREZA	:= FISC->A1_NATUREZ
	        TRB->ESTADO	 	:= FISC->F2_EST
	        TRB->CFOP		:= FISC->F3_CFO
	        TRB->ENTRADA	:= FISC->F2_EMISSAO	        	        
	        TRB->TOTAL		:= FISC->F2_VALMERC
	        TRB->VALBRUT	:= FISC->F2_VALBRUT
	        TRB->VALNOT		:= FISC->TOTNOT	        
	        TRB->VALCONT	:= FISC->F3_VALCONT	        
	        TRB->ICMS_ST	:= FISC->F3_ICMSRET
	        TRB->ICMS		:= FISC->F3_VALICM
	        	           	        	         	        	     	        
	    MsUnlock()
	      
	      dbSelectArea("FISC")
	     DbSkip()
	Enddo
	dtVenc:=""
	
	If Select("FISC") > 0
		dbSelectArea("FISC")
		DbCloseArea()
	EndIf
	
Return

Static Function ValPerg(cPerg)

	PutSx1(cPerg,'01','Emissão	De            ?','','','mv_ch1','D',8,0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'02','Emisão	Ate           ?','','','mv_ch2','D',8,0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'03','Nota de                ?','','','mv_ch3','C',09,0,0,'G','','','','','mv_par03',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'04','Nota Ate               ?','','','mv_ch4','C',09,0,0,'G','','','','','mv_par04',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'05','Serie de               ?','','','mv_ch5','C',03,0,0,'G','','','','','mv_par05',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'06','Serie Ate              ?','','','mv_ch6','C',03,0,0,'G','','','','','mv_par06',,,'','','','','','','','','','','','','','') 
	PutSx1(cPerg,'07','Tipo de Saida		  ?','','','mv_ch7','N',1,0,1,'C','','','','','mv_par07',"TRANSFERENCIA","","","","ABASTECIMENTO","","","VENDA PA","","","VENDA DIRETA","","","OUTRAS SAIDAS","","")
Return
