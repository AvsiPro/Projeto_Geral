
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦RELDIVNOT() ¦ Autor ¦ Ricardo Souza	    ¦ Data ¦26.05.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Relatório de Divergencia									  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Compras		                                         	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

User Function TTBLQR001() 

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
¦¦¦Funçào    ¦REPORTDEF() ¦ Autor ¦ Ricardo Souza	    ¦ Data ¦26.05.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Relatório de divergencia									  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Compras		                                         	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function ReportDef()

	Local oReport
	Local oSection
	Private cPerg    := "TTBLQR001"
	ValPerg(cPerg)
	Pergunte(cPerg,.T.)
	oReport := TReport():New("TTBLQR001","Relatorio de Bloqueio","",{|oReport| PrintReport(oReport)},"Este relatório imprimirá as notas de com divergencia")
	
	// Seção  Dados da Nota Fiscal
	oSection1 := TRSection():New(oReport,OemToAnsi("Notas de Bloqueio"),{"TRB"})
	
	//----------------------CAMPO-----ALIAS--TITULO-----------PIC-TAMANHO
	
	TRCell():New(oSection1,"FILIAL"	 ,"TRB","FILIAL		"	 ,"@!",02)
	TRCell():New(oSection1,"FORN" 	 ,"TRB","FORNECEDOR "	 ,"@!",06)
	TRCell():New(oSection1,"LOJA"    ,"TRB","LOJA"	 		 ,"@!",04)
	TRCell():New(oSection1,"NOMEFOR"  ,"TRB","N. FORNECEDOR" ,"@!",04)
	TRCell():New(oSection1,"TITDOC"  ,"TRB","TIT/NOTA	"    ,"@!",09)
	TRCell():New(oSection1,"TIPO"	 ,"TRB","TIPO BLQ	"	 ,"@!",15)
	TRCell():New(oSection1,"PRODUTO" ,"TRB","PRODUTO"        ,"@!",15)
	TRCell():New(oSection1,"VALINF"	 ,"TRB","VAL. INFORM"	 ,"@!",15)
	TRCell():New(oSection1,"VALCOR"	 ,"TRB","VAL. CORRETO"	 ,"@!",15)
	TRCell():New(oSection1,"DIVER"	 ,"TRB","DIVERGENCIA"	 ,"@E 999,999,999.99",16)
	TRCell():New(oSection1,"USUARIO" ,"TRB","USUARIO"     	 ,"@!",15)	
	TRCell():New(oSection1,"VALTIT"	 ,"TRB","VALOR_TIT"	 	 ,"@E 999,999,999.99",16)
	TRCell():New(oSection1,"VENCREA" ,"TRB","VENC. DA 1º PARCELA"     ,,08)
	
Return oReport

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦PrintReport() ¦ Autor ¦ Ricardo Souza 	¦ Data ¦26.05.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦Descriçào ¦ Funcao Responsável pela impessão do relatório				  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Compras		                                         	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
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
	Local c_EOL	     := CHR(13)+CHR(10)
	
	// Criacao arquivo de Trabalho
	_aStru	:= {}

	AADD(_aStru,{"FILIAL"	,"C",02,0})
	AADD(_aStru,{"FORN"		,"C",06,0})
	AADD(_aStru,{"LOJA"		,"C",04,0})
	AADD(_aStru,{"TITDOC"	,"C",09,0})
	AADD(_aStru,{"TIPO"		,"C",15,0})
	AADD(_aStru,{"PRODUTO"	,"C",15,0})
	AADD(_aStru,{"NOMEFOR"	,"C",35,0})
	AADD(_aStru,{"VALINF"	,"C",15,0})
	AADD(_aStru,{"VALCOR"	,"C",15,0})
	AADD(_aStru,{"DIVER"	,"N",14,2})
	AADD(_aStru,{"USUARIO"	,"C",15,0})	
	AADD(_aStru,{"VALTIT"	,"N",14,2})
	AADD(_aStru,{"VENCREA"	,"D",08,0})

	_cArq     := CriaTrab(_aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)
	
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	IndRegua("TRB",_cIndice,"FORN + LOJA + TITDOC + PRODUTO ",,,"Selecionando Registros...")
	
	// Seleciona as notas bloqueadas,desbloqueadas e ambas
	
	clbql:= " SELECT Z4_FILIAL 	"
	clBql+= " ,Z4_CHAVENF 		"
	clBql+= " ,Z4_ITEM 			"
	clBql+= " ,Z4_DATA 			"
	clBql+= " ,Z4_HORA 			"
	clBql+= " ,Z4_USER 			"
	clBql+= " ,Z4_PEDIDO 		"
	clBql+= " ,Z4_FORNECE 		"
	clBql+= " ,Z4_LOJA    "
	clBql+= " ,Z4_NOME    "
	clBql+= " ,Z4_PRODUTO "
	clBql+= " ,Z4_DESC    "
	clBql+= " ,D1_DTDIGIT    "	
	clBql+= " ,'OPER'= CASE WHEN Z4_OPER = '1' THEN 'Preço' ELSE CASE WHEN Z4_OPER='2' THEN 'Qtde_NFxPC' ELSE CASE WHEN Z4_OPER='4' THEN 'Confer. Cega' ELSE 'Cond. Pgto' END END END "    
	clBql+= " ,'VALCOR'=CASE WHEN Z4_OPER = '1' THEN C7_PRECO ELSE CASE WHEN Z4_OPER='2' THEN C7_QUANT ELSE CASE WHEN Z4_OPER='4' THEN D1_QUANT ELSE 0 END END END "
	clBql+= " ,'VALINF'=CASE WHEN Z4_OPER = '1' THEN (D1_TOTAL -D1_VALDESC)/D1_QUANT ELSE CASE WHEN Z4_OPER='2' THEN D1_QUANT - D1_VALDESC ELSE CASE WHEN Z4_OPER='4' THEN D1_XCLASPN ELSE 0 END END END "
	clBql+= " ,Z4_VLRCORR "
	clBql+= " ,Z4_VLRINF  "	
	clBql+= " ,Z4_OBS     "
	clBql+= " ,Z4_STATUS  "
	clBql+= " ,Z4_CTRL	  "	
	clBql+= " FROM " + RetSqlName("SZ4") + " AS SZ4 "
	clBql+= " INNER JOIN " + RetSqlName("SD1") + " AS SD1 "
	clBql+= " 	ON Z4_CHAVENF=D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_TIPO "
	clBql+= " 	AND Z4_PRODUTO=D1_COD AND Z4_ITEM=D1_ITEM " 
	clBql+= " 	OR Z4_CHAVENF+Z4_ITEM+Z4_PRODUTO=D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_TIPO+'XXXXXXXXXXX' "
	clBql+= " INNER JOIN " + RetSqlName("SF1") + " AS SF1 "
	clBql+= " 	ON D1_FILIAL=F1_FILIAL AND D1_DOC=F1_DOC AND D1_SERIE=F1_SERIE "
	clBql+= " 	AND D1_FORNECE=F1_FORNECE AND D1_LOJA=F1_LOJA AND D1_TIPO=F1_TIPO "
	clBql+= " 	AND D1_DTDIGIT=F1_DTDIGIT "	 
	clBql+= " INNER JOIN " + RetSqlName("SF4") + " AS SF4 "
	clBql+= " 	ON D1_FILIAL=F4_FILIAL AND D1_TES=F4_CODIGO "
	clBql+= " INNER JOIN " + RetSqlName("SC7") + " AS SC7 "
	clBql+= " ON D1_PEDIDO=C7_NUM AND D1_FORNECE=C7_FORNECE AND D1_COD=C7_PRODUTO "	
	clBql+= " AND D1_ITEMPC=C7_ITEM"
	clBql+= " WHERE "
	If MV_PAR01==1
		clBql+= " F1_XSTDIV='B' " 
	ElseIf MV_PAR01==2
		clBql+= " F1_XSTDIV='L' "
	Else
		clBql+= " F1_XSTDIV IN ('B','L') "	
	EndIf
		clBql+= " AND Z4_DATA BETWEEN '"+Dtos(MV_PAR02)+"' AND '"+Dtos(MV_PAR03)+"' "
	If MV_PAR04==1
		clBql+= " AND F4_ESTOQUE='S' "
	ElseIf MV_PAR04==2
		clBql+= " AND F4_ESTOQUE='N' "
	Else
		clBql+= " AND F4_ESTOQUE IN('S','N') "
	EndIf 
	If !Empty(MV_PAR05)
		clBql+= " AND D1_FORNECE='"+MV_PAR05+"' "	
	EndIf
	clBql+= " AND SZ4.D_E_L_E_T_=''	"
	clBql+= " ORDER BY Z4_FORNECE,Z4_LOJA,SUBSTRING(Z4_CHAVENF,3,9),Z4_PRODUTO	
	
	MemoWrite("TTBLQR001.sql",clBql)
	
	IF SELECT("BLQTIT") > 0
		dbSelectArea("BLQTIT")
		DbCloseArea()
	ENDIF
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,clBql),"BLQTIT",.F.,.T.)
	
	TcSetField("BLQTIT","Z4_DATA","D",08,0)
	TcSetField("BLQTIT","VALCOR","N",14,2)
	TcSetField("BLQTIT","VALINF","N",14,2)
	
	dbSelectArea("BLQTIT")
	dbGotop()
	
	While BLQTIT->(!Eof())
		
		DbSelectArea("TRB")
		
		// Adciona Registro na tabela
		
		RecLock("TRB",.T.)
		
			TRB->FILIAL :=LEFT(BLQTIT->Z4_CHAVENF,2) 		// Filial
			TRB->FORN   :=SubStr(BLQTIT->Z4_CHAVENF,15,06)  // Fornecedor
			TRB->LOJA   :=SubStr(BLQTIT->Z4_CHAVENF,21,04)  // Loja
			TRB->NOMEFOR:= BLQTIT->Z4_NOME 					// Nome			
			TRB->TITDOC :=SubStr(BLQTIT->Z4_CHAVENF,03,09)	// Nº Documento		 
			TRB->TIPO   := BLQTIT->OPER		                // Tipo de Bloqueio
			TRB->PRODUTO:= BLQTIT->Z4_PRODUTO               // Produto
			TRB->VALINF := BLQTIT->Z4_VLRINF                // Vlr Informado
			TRB->VALCOR := BLQTIT->Z4_VLRCORR               // Vlr Correto
			TRB->DIVER  := BLQTIT->VALINF - BLQTIT->VALCOR  // Divergência
			TRB->USUARIO:= BLQTIT->Z4_USER                  // Usuário
			
			clBql1:= " SELECT E2_NUM,E2_FORNECE,E2_LOJA,SUM(E2_VALOR) AS TOTAL,MIN(E2_VENCREA) AS VENCREA "
			clBql1+= " FROM " + RetSqlName("SE2") + " AS SE2 "
			clBql1+= " WHERE E2_NUM ='"+SubStr(BLQTIT->Z4_CHAVENF,03,09)+"' "
			clBql1+= " 		AND E2_FORNECE ='"+SubStr(BLQTIT->Z4_CHAVENF,15,06)+"' "
			clBql1+= " 		AND E2_LOJA ='"+SubStr(BLQTIT->Z4_CHAVENF,21,04)+"' "
			clBql1+= " 		AND E2_MSFIL ='"+LEFT(BLQTIT->Z4_CHAVENF,2)+"' "
			clBql1+= " 		AND E2_EMIS1 ='"+BLQTIT->D1_DTDIGIT+"' "
			clBql1+= " 		AND E2_TIPO='NF' AND SE2.D_E_L_E_T_='' " 
			clBql1+= " 		GROUP BY E2_NUM,E2_FORNECE,E2_LOJA  "
			
			IF SELECT("BLQTIT1") > 0
				dbSelectArea("BLQTIT1")
				DbCloseArea()
			ENDIF
			
			dbUseArea(.T.,"TOPCONN",TCGENQRY(,,clBql1),"BLQTIT1",.F.,.T.)
	
			TcSetField("BLQTIT1","VENCREA","D",08,0)
			TcSetField("BLQTIT1","TOTAL","N",14,2)
			
			dbSelectArea("BLQTIT1")
			dbGotop()
			While BLQTIT1->(!Eof())
			
				TRB->VALTIT := BLQTIT1->TOTAL                   // Total do titulo
				TRB->VENCREA:= BLQTIT1->VENCREA                 // 1º Vencimento real do título 
						
			BLQTIT1->(DBSKIP())
			Enddo
		MsUnlock()
		
		dbSelectArea("BLQTIT")
		BLQTIT->(DBSKIP())
	Enddo
	
	If Select("BLQTIT") > 0
		dbSelectArea("BLQTIT")
		DbCloseArea()
	EndIf

Return

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ValPerg() ¦ Autor ¦ Ricardo Souza    		¦ Data ¦26.05.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦Descriçào  ¦Cria as perguntas do relatório caso não exista			  ¦¦¦
¦¦¦			 ¦ 															  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Compras		                                         	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function ValPerg(cPerg)
	PutSx1(cPerg,'01','Status		     ?','','','mv_ch1','N',1 ,0,1,'C','','','','','mv_par01',"Bloqueado"," "," ","","Liberado","","","ambos","","","","","","","","")   
	PutSx1(cPerg,'02','Data de           ?','','','mv_ch2','D',8,0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'03','Data ate          ?','','','mv_ch3','D',8,0,0,'G','','','','','mv_par03',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'04','Tipo 		     ?','','','mv_ch4','N',1,0,1,'C','','','','','mv_par04',"Compras"," "," ","","Serviço","","","Ambos","","","","","","","","")   
	PutSx1(cPerg,'06','Fornecedor	     ?','','','mv_ch5', 'C', 06, 0, 0, 'G', '', 'SA1','','','mv_par05',,,'','','','','','','','','','','','','','')
Return
