
#INCLUDE"RWMAKE.CH"
/*--------------------------------------------------------------------------|
|Programa->	|TTFATR10()| Autor ->|Fabio Sales       | Data | 24.07.10		|
|---------------------------------------------------------------------------|
|Descrição->|Pedidos de vendas em aberto X saldos em estoque			 	| 
|---------------------------------------------------------------------------|
|Uso->		|Faturamento/Estoque											|
|--------------------------------------------------------------------------*/

User Function TTFATR10()

	Local cDesc1  		:= "pedidos de vendas em aberto X saldo em Estoque"
	Local cDesc2		:= ""
	Local titulo		:= "PEDIDOS DE VENDAS / SALDO EM ESTOQUE"
	Local nLin 			:= 80                      
   	Local Cabec1       	:= "PRODUTO |"+SPACE(8)+"DESCRIÇÃO |"+SPACE(27)+"UNI_MED| LOCAL  | SALD_ESTOQUE  | QTDE_PEDIDO   | DIFERENÇA DE ESTOQ |QTDE FATURADA   | QTDE A FATURAR  "   																	
	Local imprime      	:= .T.
	Local aOrd 			:= {}
	Private cPerg		:="TTFATR10"
	Private lAbortPrint := .F.
	Private limite      := 80
	Private tamanho     := "G"
	Private nomeprog    := "TTFATR10" 
	Private nTipo       := 18
	Private aReturn     := { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
   	Private nLastKey    := 0
   	Private m_pag      	:= 01
    Private wnrel      	:= "TTFATR10" // Coloque aqui o nome do arquivo usado para impressao em disco				                           

If cEmpAnt == "01"  
	 AjustaSX1()
	Pergunte(cPerg,.F.)
		wnrel := SetPrint(,NomeProg,cPerg,@titulo,cDesc1 ,cDesc2 ,"",.T.,aOrd,.T.,Tamanho)

	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,"")
	
	If nLastKey == 27
	   Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
		
/*------------------------------------------------------------------------|
|Processamento. RPTSTATUS monta janela com a regua de processamento.      |
|-------------------------------------------------------------------------*/
		
	RptStatus({|| RunReport(Cabec1,"",Titulo,nLin) },Titulo)
endif
Return

/*--------------------------------------------------------------------------|
|Fução->	|RUNREPORT | Autor ->|Fabio Sales          | Data | 26.01.10	|
|---------------------------------------------------------------------------|
|Descrição->|Função auxiliar chamada  pelaRPTSTATUS.A função RPTSTATUS.     | 
|   		|Monta a janela com a regua de processamento                    | 
|---------------------------------------------------------------------------|
|Uso->		|Faturamento													|
|--------------------------------------------------------------------------*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

    Local clQuery
    Local nlDif
    Local clNomCli
    Local alped:={}
	Local alNeg:={}
	Local clEstado
	Local clMunic
   
/*-----------------------------------------------------------------------|
| SETREGUA -> Indica quantos registros serao processados para a regua    |
|------------------------------------------------------------------------*/          
                                                                                                       
	SetRegua(RecCount())
	
/*------------------------------------------------------------------------|
| Query para trazer as quantidades de itens requisitados para produção    |
|------------------------------------------------------------------------*/ 

	clQuery := " SELECT B2_COD,C6_FILIAL,C6_DESCRI,B2_LOCAL,B2_QATU,C6_UM,C6_NUM,C6_CLI,C6_LOJA,C6_ENTREG,C6_QTDVEN,C6_QTDENT,(C6_QTDVEN-C6_QTDENT) AS QTDFALTA,C5_XCODPA "
	clQuery += " FROM 	"+RetSqlName("SC6")+" AS SC6,"+RetSqlName("SB2")+" AS SB2,"+RetSqlName("SC5")+" AS SC5,"+RetSqlName("SF4")+" AS SF4,"+RetSqlName("SB1")+" AS SB1	"
	clQuery += " WHERE  C6_PRODUTO=B2_COD AND C6_LOCAL=B2_LOCAL AND C6_FILIAL= B2_FILIAL " 
	clQuery += "	AND C6_NUM=C5_NUM AND C6_CLI=C5_CLIENTE AND C6_LOJA=C5_LOJACLI AND C6_FILIAL=C5_FILIAL "
	clQuery += " 	AND C6_TES=F4_CODIGO AND C6_FILIAL=F4_FILIAL AND B2_COD=B1_COD AND SB2.D_E_L_E_T_='' AND SC6.D_E_L_E_T_='' " 
	clQuery += "  	AND SC5.D_E_L_E_T_='' AND SF4.D_E_L_E_T_='' AND SB1.D_E_L_E_T_='' AND F4_ESTOQUE='S' "  
	clQuery += " 	AND C6_BLQ='' AND B2_COD BETWEEN 		"
	clQuery += " 		'"+MV_PAR01+"' AND '"+MV_PAR02+"' AND C6_NUM BETWEEN '"+MV_PAR03+"' 	"
	clQuery += "	AND '"+MV_PAR04+"' AND C6_ENTREG BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"'	"
	clQuery += "	AND C6_LOCAL BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'	"
	clQuery += "	AND C6_FILIAL BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"'	"	
	clQuery += " ORDER BY B2_COD "
		
	If Select("SQL") > 0
		dbSelectArea("SQL")
		SQL->(DbCloseArea())
	EndIf 
	
	MemoWrite("TTESR01.SQL",clQuery)

   	clQuery:= ChangeQuery(clQuery)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,clQuery),'SQL',.T.,.T.)
	
/*------------------------------------------------------------------------|
| Query para para imprimir os pedidos após a impressa de todos os itens   |
|------------------------------------------------------------------------*/ 
	                                                                       
	
	clQuery := " SELECT B2_COD,C6_FILIAL,C6_DESCRI,B2_LOCAL,B2_QATU,C6_UM,C6_NUM,C6_CLI,C6_LOJA,C6_ENTREG,(C6_QTDVEN-C6_QTDENT) AS QTDFALTA,C5_XCODPA "
	clQuery += " FROM 	"+RetSqlName("SC6")+" AS SC6,"+RetSqlName("SB2")+" AS SB2,"+RetSqlName("SC5")+" AS SC5,"+RetSqlName("SF4")+" AS SF4,"+RetSqlName("SB1")+" AS SB1	"
	clQuery += " WHERE   C6_PRODUTO=B2_COD AND C6_LOCAL=B2_LOCAL AND C6_FILIAL= B2_FILIAL " 
	clQuery += "	AND  C6_NUM=C5_NUM AND C6_CLI=C5_CLIENTE AND C6_LOJA=C5_LOJACLI AND C6_FILIAL=C5_FILIAL "	
	clQuery += "	AND  C6_TES=F4_CODIGO AND C6_FILIAL=F4_FILIAL AND B2_COD=B1_COD	AND  SB2.D_E_L_E_T_='' AND SC6.D_E_L_E_T_='' "  
	clQuery += "  	AND  SC5.D_E_L_E_T_='' AND SF4.D_E_L_E_T_='' AND SB1.D_E_L_E_T_='' AND F4_ESTOQUE='S' "
	clQuery += " 	AND  C6_BLQ='' AND B2_COD BETWEEN "
	clQuery += " 		 '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND C6_NUM BETWEEN '"+MV_PAR03+"' 	"
	clQuery += "	AND  '"+MV_PAR04+"' AND C6_ENTREG BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"'	"
	clQuery += "	AND  C6_LOCAL BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'	 "
	clQuery += "	AND  C6_FILIAL BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' "
	clQuery += " ORDER BY C6_NUM "
		
	If Select("PEDI") > 0
		dbSelectArea("PEDI")
		PEDI->(DbCloseArea())
	EndIf 
	
	MemoWrite("PEDI.SQL",clQuery)

   	clQuery:= ChangeQuery(clQuery)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,clQuery),'PEDI',.T.,.T.)
	TcSetField("PEDI","C6_ENTREG","D",8)

		
	DBSELECTAREA("SQL")
	DBGOTOP()
	While SQL->(!EOF())
	
		nlQatu		:=0 //saldo atual em estoque
		nlQtdFalt	:=0 //qtde em aberto do pedido
		nlDif		:=0 //estoque - item pedido em aberto 
		nlQtdVen 	:=0 // qtde do pedido
		nlQtdEnt 	:=0 // qtde aberto do pedido 
		
	  	If lAbortPrint
	      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Endif

/*------------------------------------------------------------------------|
|        		Impressao do cabecalho do relatorio. . .                  |  
|-------------------------------------------------------------------------*/
		If nLin > 66 
		      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		      nLin := 8
		Endif
		@nLin,00 PSAY SQL->B2_COD 
		@nLin,17 PSAY SQL->C6_DESCRI
		@nLin,55 PSAY SQL->C6_UM 
		@nLin,64 PSAY SQL->B2_LOCAL 
	   
		nlQatu	:=SQL->B2_QATU
		clCod	:=SQL->B2_COD 
		clLocal	:=SQL->B2_LOCAL
		 
		WHILE SQL->B2_COD ==clCod .AND. SQL->B2_LOCAL==clLocal 	
					
		    AADD(alped,{SQL->C6_NUM,SQL->B2_COD,SQL->B2_LOCAL,SQL->C6_QTDVEN,SQL->C6_QTDENT,SQL->QTDFALTA,SQL->C6_CLI,SQL->C6_LOJA,SQL->C5_XCODPA,SQL->C6_FILIAL,SQL->C6_UM})		                                          
			nlQtdFalt:=nlQtdFalt +  SQL->QTDFALTA 
			nlQtdVen :=nlQtdVen  +	SQL->C6_QTDVEN
			nlQtdEnt :=nlQtdEnt  +	SQL->C6_QTDENT			 
		
	    	SQL->(DBSKIP())
		ENDDO	 
		nlDif:=nlQatu-nlQtdFalt
		
		@nLin,73  PSAY nlQatu	 PICTURE "@E 999,999.99" //saldo atual no estoque
		@nLin,89  PSAY nlQtdVen	 PICTURE "@E 999,999.99" //quantidade do pedido
		@nLin,105  PSAY nlDif	 PICTURE "@E 999,999.99" //diferença entre estoque e quantidade a faturar		
		@nLin,129 PSAY nlQtdEnt  PICTURE "@E 999,999.99" //quantidade entregue(faturado)
		@nLin,147 PSAY nlQtdFalt PICTURE "@E 999,999.99" //quantidade a faturar	
		   
		IF nlDif < 0
			For nI := 1 to Len(alPed)
				AADD(alNeg,{alPed[nI][1],alPed[nI][2],alPed[nI][3],alPed[nI][4],alPed[nI][5],alPed[nI][6],alPed[nI][7],alPed[nI][8],alPed[nI][9],alPed[nI][10],alPed[nI][11]})		                                          		   
			Next nI
		endif
		alped:={}
		nLin++		
	ENDDO
	@nLin,00 PSAY __PrtThinLine()
	nLin++
	@nLin,00 PSAY "PEDIDO |CLIENTE |LOJA |NOMECLI"+SPACE(35)+"|DATA DE ENTREGA|FILIAL  |EST_CLI |MUN_CLI"
	nLin++
	@nLin,00 PSAY REPLICATE("_",110)
	nLin++ 
	
	DBSELECTAREA("PEDI")
	DBGOTOP()
	While PEDI->(!EOF())
		If nLin > 62
			Cabec(Titulo,"","",NomeProg,Tamanho,nTipo)   
			nLin := 8
			@nLin,00 PSAY __PrtThinLine()
			nLin++
			@nLin,00 PSAY "PEDIDO |CLIENTE |LOJA |NOMECLI"+SPACE(35)+"|DATA DE ENTREGA|FILIAL  |EST_CLI |MUN_CLI"
			nLin++
			@nLin,00 PSAY REPLICATE("_",110)
			nLin++
		Endif
		@nLin,00 PSAY PEDI->C6_NUM
		@nLin,08 PSAY PEDI->C6_CLI
		@nLin,17 PSAY PEDI->C6_LOJA 
		DBSELECTAREA("SA1")
		DBSETORDER(1)
		IF DBSEEK(XFILIAL("SA1")+PEDI->C6_CLI + PEDI->C6_LOJA)			
			@nLin,23 PSAY A1_NOME
			clEstado:=SA1->A1_EST
			clMunic :=SA1->A1_MUN
		EndIf
		@nLin,66 PSAY PEDI->C6_ENTREG
		@nLin,83 PSAY PEDI->C6_FILIAL
		@nLin,92 PSAY clEstado 
		@nLin,101 PSAY clMunic
		clEstado:=""
		clMunic :=""		
		
		clPed	:=PEDI->C6_NUM
		clLoja	:=PEDI->C6_LOJA		
		WHILE PEDI->C6_NUM==clPed .AND.PEDI->C6_LOJA==clLoja 
			PEDI->(DBSKIP())
		ENDDO
		nLin++
	ENDDO 	
	@nLin,00 PSAY __PrtThinLine()	
	nLin++
	@nLin,40 PSAY "PEDIDOS QUE CONTRIBUEM PARA AS QUANTIDADES NEGATIVAS"
	nLin++
	@nLin,00 PSAY __PrtThinLine()
	nLin++
	@nLin,00 PSAY "PEDIDO |PRODUTO    |UNI_MED| ARMAZ_S |DESC_ARMAZ_SAI"+SPACE(12)+"|QTDE"+SPACE(10)+"|CLIENTE|LOJA|NOMECLI"+SPACE(36)+"| ARMAZ_E| DESC_ARMAZ"+SPACE(20)+"|FILIAL|EST_CLI |MUN_CLI" 
	//@nLin,00 PSAY "PEDIDO |PRODUTO |LOCAL |QTDE             " 
	nLin++ 
	@nLin,00 PSAY REPLICATE("_",205)
	nLin++	
	For nI := 1 to Len(alNeg)
		If alNeg[nI][6]<>0
			If nLin > 66
				Cabec(Titulo,"","",NomeProg,Tamanho,nTipo)   
				nLin := 8
				@nLin,00 PSAY __PrtThinLine()	
				nLin++
				@nLin,40 PSAY "PEDIDOS QUE CONTRIBUEM PARA AS QUANTIDADES NEGATIVAS"
				nLin++
				@nLin,00 PSAY __PrtThinLine()                                     
				nLin++  
				@nLin,00 PSAY "PEDIDO |PRODUTO    |UNI_MED| ARMAZ_S |DESC_ARMAZ_SAI"+SPACE(12)+"|QTDE"+SPACE(10)+"|CLIENTE|LOJA|NOMECLI"+SPACE(36)+"| ARMAZ_E| DESC_ARMAZ"+SPACE(20)+"|FILIAL|EST_CLI |MUN_CLI" 
				nLin++ 
				@nLin,00 PSAY REPLICATE("_",205)
				nLin++		
			Endif		                                          		   		                                          	
			@nLin,00 PSAY alNeg[nI][1] // numero do pedido
			@nLin,08 PSAY alNeg[nI][2] // codigo do produto
			@nLin,21 PSAY alNeg[nI][11] // 1º unidade de medida do produto
			@nLin,30 PSAY alNeg[nI][3] // local de armazem
			DBSELECTAREA("ZZ1")
			DBSETORDER(1)
			DBSEEK(XFILIAL("ZZ1")+alNeg[nI][3])
			@nLin,39 PSAY ZZ1->ZZ1_DESCRI   // descricao do armazem
			@nLin,67 PSAY alNeg[nI][6] PICTURE "@E 999,999.99" // qtde em aberto
			 
			@nLin,81 PSAY alNeg[nI][7]   // cliente
			@nLin,90 PSAY alNeg[nI][8]   // loja
			DBSELECTAREA("SA1")
			DBSETORDER(1)
			DBSEEK(XFILIAL("SA1")+alNeg[nI][7]+alNeg[nI][8])
			@nLin,99 PSAY SA1->A1_NOME  // nome do cliente
			@nLin,138 PSAY trim(alNeg[nI][9]) // codigo da PA
			clEstado :=SA1->A1_EST  	//Estado do cliente
			clMunic :=SA1->A1_MUN		//municipio do cliente
			DBSELECTAREA("ZZ1")
			DBSETORDER(1)
			DBSEEK(XFILIAL("ZZ1")+alNeg[nI][9]) 
			@nLin,146 PSAY ZZ1->ZZ1_DESCRI	//nome da PA 
			@nLin,178 PSAY alNeg[nI][10] 	//nome da PA 
			@nLin,185 PSAY clEstado
			@nLin,194 PSAY clMunic			
			nLin++  // atribue 1 a variável nLin
		EndIf
		clEstado:=""
		clMunic :=""
	Next nI
	alNeg:={}

	SET DEVICE TO SCREEN

/*-------------------------------------------------------------------------
|        Se impressao em disco, chama o gerenciador de impressao...       |
|--------------------------------------------------------------------------*/

	If aReturn[5]==1
	   dbCommitAll()
	   SET PRINTER TO
	   OurSpool(wnrel)
	Endif
	dbclosearea()
	MS_FLUSH()
Return

/*--------------------------------------------------------------------------|
|Programa->	AjustaSX1() | Autor ->|Fabio Sales         | Data | 26.01.10	|
|---------------------------------------------------------------------------|
|Descrição->|Parametro de perguntas do relatórios  							| 
|---------------------------------------------------------------------------|
|Uso->		|Faturamento													|
|--------------------------------------------------------------------------*/
		       
Static Function AjustaSX1()
	
	PutSx1(cPerg,"01","Produto de?","","","mv_ch1","C",15,00,00,"G","","SB1","","","mv_Par01","","","","","","","","","","","","","","","","",{"Digite o código inicial do produto para o filtro"},{},{},"")
	PutSx1(cPerg,"02","Produto Ate","","","mv_ch2","C",15,00,00,"G","","SB1","","","mv_Par02","","","","","","","","","","","","","","","","",{"Digite o código final do produto para o filtro"},{},{},"")
	PutSx1(cPerg,"03","Num de ?","","","mv_ch3","C",06,00,00,"G","","SC6","","","mv_Par03","","","","","","","","","","","","","","","","",{"Digite o pedido inicial para o filtro"},{},{},"")
 	PutSx1(cPerg,"04","Num ate?","","","mv_ch4","C",06,00,00,"G","","SC6","","","mv_Par04","","","","","","","","","","","","","","","","",{"Digite o pedido final para o filtro"},{},{},"")
	PutSx1(cPerg,"05","Data de ?","","","mv_ch5","D",08,00,00,"G","","","","","mv_Par05","","","","","","","","","","","","","","","","",{"Digite a data inicial de entrega para o filtro"},{},{},"")
	PutSx1(cPerg,"06","'Data Ate?","","","mv_ch6","D",08,00,00,"G","","","","","mv_Par06","","","","","","","","","","","","","","","","",{"Digite a data final de entrega para o filtro"},{},{},"")
	PutSx1(cPerg,"07","Armazem de?","","","mv_ch7","C",06,00,00,"G","","ZZ1","","","mv_Par07","","","","","","","","","","","","","","","","",{"Digite o código inicio do armazem"},{},{},"")
	PutSx1(cPerg,"08","Armazem Ate","","","mv_ch8","C",06,00,00,"G","","ZZ1","","","mv_Par08","","","","","","","","","","","","","","","","",{"Digite o código final d armazem"},{},{},"")
	PutSx1(cPerg,"09","Filial de?","","","mv_ch9","C",02,00,00,"G","","SM0","","","mv_Par09","","","","","","","","","","","","","","","","",{"Codigo inicial da filial que se deseja filtrar"},{},{},"")
	PutSx1(cPerg,"10","Filial Ate","","","mv_chA","C",02,00,00,"G","","SM0","","","mv_Par10","","","","","","","","","","","","","","","","",{"Digite final da filial que deseja filtrar"},{},{},"")
	
Return