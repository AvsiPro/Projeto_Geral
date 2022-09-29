
#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"

/*/
|---------------------------------------------------------------------------|
| Função =   TTFATR11() | Autor /Fabio  Sales    |    º Data =  20/10/10    |
|---------------------------------------------------------------------------|
| Descrição = Relatório de Distribuição da Rota de Abastecimento            |
|---------------------------------------------------------------------------|
| Uso       = Faturamento/TokeTake                                          |
|---------------------------------------------------------------------------|
/*/
                                  
User Function TTFATR11()

//----------------------------------------------------------------------//
//                        Declaracao de Variaveis                       //
//----------------------------------------------------------------------//                         

	Local cDesc1		:= "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2		:= "da rotina de Rota de Abastecimento ."
	Local titulo		:= "R O T A   D E   A B A S T E C I M E N T O"
	Local nlLin         := 80
	Local clPerg		:= "TTFATR11"
	Local Cabec1		:= ""
	Local Cabec2		:= ""
	Local imprime		:= .T.
	Local aOrd			:= {}
	Local _cPa			:= ""
	Local _endent		:= ""
	Private lAbortPrint	:= .F.
	Private limite		:= 80
	Private tamanho		:= "G"
	Private nomeprog	:= "TTFATR11" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo		:= 18
	Private aReturn		:= { "Zebrado", 1, "Administracao", 1, 1, 1, "", 1}
	Private nLastKey	:= 0
	Private m_pag		:= 01
	Private wnrel		:= "TTFATR11" // Coloque aqui o nome do arquivo usado para impressao em disco  

//-----------------------------------------------------------------------------------//
//                 Crirá os parametro de perguntas na tabela SX1                     //
//-----------------------------------------------------------------------------------//

	PutSx1(clPerg,"01","Emissão de ?","","","mv_ch1","D",08,00,00,"G","","","","","mv_Par01","","","","","","","","","","","","","","","","",{"Data inicial para impressão"},{},{},"")
	PutSx1(clPerg,"02","Emissão Até?","","","mv_ch2","D",08,00,00,"G","","","","","mv_Par02","","","","","","","","","","","","","","","","",{"Data final para impressão"},{},{},"")
	PutSx1(clPerg,"03","Rota de  ?","","","mv_ch3","C",06,00,00,"G","","","","","mv_Par03","","","","","","","","","","","","","","","","",{"Numero inicial da Rota"},{},{},"")
	PutSx1(clPerg,"04","Rota Até ?","","","mv_ch4","C",06,00,00,"G","","","","","mv_Par04","","","","","","","","","","","","","","","","",{"Número final da Rota"},{},{},"")
	PutSx1(clPerg,"05","Nota de  ?","","","mv_ch5","C",09,00,00,"G","","","","","mv_Par05","","","","","","","","","","","","","","","","",{"Numero inicial da Nota"},{},{},"")
	PutSx1(clPerg,"06","Nota Até ?","","","mv_ch6","C",09,00,00,"G","","","","","mv_Par06","","","","","","","","","","","","","","","","",{"Número final da Nota"},{},{},"")
	PutSx1(clPerg,"07","Serie de ?","","","mv_ch7","C",03,00,00,"G","","","","","mv_Par07","","","","","","","","","","","","","","","","",{"Numero inicial da Série"},{},{},"")
	PutSx1(clPerg,"08","Serie Até ?","","","mv_ch8","C",03,00,00,"G","","","","","mv_Par08","","","","","","","","","","","","","","","","",{"Número final da Série"},{},{},"")

//----------------------------------------------------------------------//
//                 Monta a interface padrao com o usuario...            //
//----------------------------------------------------------------------//
If cEmpAnt == "01"
	If !Pergunte(clPerg,.T.)
		Return
	Else
		While (mv_par01 > mv_par02) .or. (mv_par03 > mv_par04) .or.(mv_par05 > mv_par06).or. (mv_par07 > mv_par08)
			If (mv_par03 > mv_par04)
				AVISO("MENSSAGEM","O parametro de rota esta em ordem incorreta o 1º parametro de ser menor que o 2º  ",{"OK",1})
			ElseIf(mv_par01 > mv_par02)
				AVISO("MENSSAGEM","o parametro de emissao está incorreto, o data de deve ser menor que o o data ate",{"OK",1})
			Elseif (mv_par05 > mv_par06)
				AVISO("MENSSAGEM","o parametro de emissao está incorreto, nota ate deve ser maoir do o que o data de",{"OK",1})
			else
		 		AVISO("MENSSAGEM","o parametro de emissao está incorreto, a serie de deve ser menor do que a serie ate",{"OK",1})
			endif
			If !Pergunte(clPerg,.T.)
				Return
			EndIf
		EndDo
	EndIf
	wnrel := SetPrint("SF2",NomeProg,,@titulo,cDesc1,cDesc2,"",.T.,aOrd,.T.,Tamanho)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,"")

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

//----------------------------------------------------------------------//
// Processamento. RPTSTATUS monta janela com a regua de processamento.  //
//----------------------------------------------------------------------//

	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nlLin) },Titulo)
endif
Return

/*
|---------------------------------------------------------------------------|
|ºFunção =   RUNREPORT | Autor /Fabio  Sales    |    º Data =  20/10/10     |
|---------------------------------------------------------------------------|
|ºDescrição = Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS    |
|          	  monta a janela com a regua de processamento.                  |
|---------------------------------------------------------------------------|
| Uso       = Faturamento                                                   |
|---------------------------------------------------------------------------|
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nlLin)
                                                                                                                             
	Local clNomeResp :=""
    Local clDescRota   :=""      && Nome do motorista responsável pela distribuição da mercadoria nos pontos de abastecimento
	Local clRota     :=""		&& Rota de abastecimento
	Local clRg		 :=""                              
	Local clCodMat	 :=""
	Local clEmpres	 :=""
	Local clCpf		 :=""
	Local clDescRot  :=""       && Descrição da Rota
	Local clQuery    :=""       && Variaevel que irá receber a consulta do banco de dados
	Local clDescPa   :=""       && Descrição da PA
	Local nlQitemNot:=0     && Totalizador das quantidades dos itens da nota
	Local nlQitemDis:=0     && Totalizador das quantidades dos itens da distribuição
	Local nlQtdeRt	:=0     && Totalizadpr das quantidades dos itens do retorno
	Local nlTotTotal:=0
	Local alDif		:={}    && Matriz dos produtos que apresentam divergencia
	Local alNota	:={}    && Matriz com dados das notas para impressão no boleto de pagamento
	Local alboleto  :={}    && Matriz com dados dos produtos divergentes para impressão do boleto de pagamento
	Local alSd3		:={}	&& Matriz com dados dos produtos distribuidos
	
//----------------------------------------------------------------------//
// SETREGUA -> Indica quantos registros serao processados para a regua  //
//----------------------------------------------------------------------//

	SetRegua(RecCount())

&& --> Query com os dadsos das notas fiscais de saida de abastecimento <-- &&
&& --> notas de entradas de retorno de abastecimento e movimentação    <-- &&
&& --> interna <-- &&

	clQuery := " SELECT * FROM  "
	clQuery += " 	(SELECT	SF2.F2_XCODPA, "
	clQuery += " 		SF2.F2_DOC,  	"
	clQuery += " 		SF2.F2_SERIE, 	"
	clQuery += " 		SD2.D2_COD, 	"
	clQuery += " 		SB1.B1_DESC,    "
	clQuery += " 		SF2.F2_EMISSAO, "
	clQuery += " 		SD3.D3_LOCAL,   "
	clQuery += " 		SD3.D3_ESTORNO, "
	clQuery += " 		SD3.D3_DOC,		"
	clQuery += " 		SD3.D3_XPATRI,  "
	clQuery += " 		SF2.F2_CLIENTE, "
	clQuery += " 		SF2.F2_LOJA, 	"
	clQuery += " 		SF2.F2_XCARGA, 	"
	clQuery += " 		SF2.F2_XPLACA, 	"
	clQuery += " 		SF2.F2_XMOTOR, 	"
	clQuery += " 		SD2.D2_QUANT,   "
	clQuery += " 		SD2.D2_ITEM,    "
	clQuery += " 		SD1.D1_ITEM,    "
	clQuery += " 		SD3.D3_QUANT,   "
	clQuery += " 		SD1.D1_QUANT,   "
	clQuery += " 		SD2.D2_PRCVEN,  "
	clQuery += " 		SD2.D2_TOTAL    "
	clQuery += " 	FROM "+RetSqlName("SF2")+" AS SF2    		"
	clQuery += " 	INNER JOIN "+RetSqlName("SD2")+" AS SD2 ON "
	clQuery += " 		SF2.F2_FILIAL=SD2.D2_FILIAL 	  		"
	clQuery += " 		AND SF2.F2_DOC=SD2.D2_DOC 		  		"
	clQuery += " 		AND SF2.F2_SERIE=SD2.D2_SERIE 	  		"
	clQuery += " 		AND SF2.F2_CLIENTE=SD2.D2_CLIENTE 		"
	clQuery += " 		AND SF2.F2_LOJA=SD2.D2_LOJA 	  		"
	clQuery += " 		AND SF2.F2_EMISSAO=SD2.D2_EMISSAO 		"
	clQuery += " 		LEFT OUTER JOIN "+RetSqlName("SD3")+" AS SD3 ON "
	clQuery += " 		SD2.D2_FILIAL=SD3.D3_FILIAL       		"
	clQuery += " 		AND SD2.D2_DOC=SD3.D3_XNUMNF      		"
	clQuery += " 		AND SD2.D2_SERIE=SD3.D3_XSERINF   		"
	clQuery += " 		AND SD2.D2_CLIENTE=SD3.D3_XCLIENT 		"
	clQuery += " 		AND SD2.D2_LOJA=SD3.D3_XLOJCLI    		"
	clQuery += " 		AND SD2.D2_COD=SD3.D3_COD 	      		"
	clQuery += " 		AND SD2.D2_ITEM=SD3.D3_XITEMNF    		"
	clQuery += " 		AND SD3.D3_XTIPO='A'          	  		"
	clQuery += " 		AND LEFT(D3_LOCAL,1)='P'  	      		"
	clQuery += " 		AND SD3.D_E_L_E_T_=''     	      		"
	clQuery += " 	LEFT OUTER JOIN "+RetSqlName("SD1")+" AS SD1 ON "
	clQuery += " 		SD2.D2_FILIAL=SD1.D1_FILIAL 	  		"
	clQuery += " 		AND SD2.D2_DOC=SD1.D1_NFORI 	  		"	
	clQuery += " 		AND D2_SERIE=D1_SERIORI   		  		"	
	clQuery += " 		AND SD2.D2_COD=SD1.D1_COD		  		"	
	clQuery += " 		AND SD2.D2_ITEM=SD1.D1_ITEMORI 	  		"	
	clQuery += " 		AND SD2.D2_CLIENTE=SD1.D1_FORNECE 		"	
	clQuery += " 		AND SD2.D2_LOJA=SD1.D1_LOJA 	  		"	
	clQuery += " 		AND SD1.D_E_L_E_T_=''  			  		"
	clQuery += " 	INNER JOIN "+RetSqlName("SB1")+" AS SB1 ON  "
	clQuery += " 		SD2.D2_COD=SB1.B1_COD             	   	"             
	clQuery += " 	INNER JOIN "+RetSqlName("SD3")+" ROT ON     "
	clQuery += " 		SD3.D3_FILIAL=ROT.D3_FILIAL            	"
	clQuery += " 		AND SD3.D3_COD=ROT.D3_COD              	"
	clQuery += " 		AND SD3.D3_XNUMNF=ROT.D3_XNUMNF        	"
	clQuery += " 		AND SD3.D3_XSERINF=ROT.D3_XSERINF      	"
	clQuery += " 		AND SD3.D3_XCLIENT=ROT.D3_XCLIENT      	"
	clQuery += " 		AND SD3.D3_XLOJCLI=ROT.D3_XLOJCLI    	"
   	clQuery += " 		AND SD3.D3_XITEMNF=ROT.D3_XITEMNF      	"
	clQuery += " 		AND SD3.D3_DOC=ROT.D3_DOC              	"
	clQuery += " 		AND SD3.D3_QUANT=ROT.D3_QUANT           "
	clQuery += " 		AND ROT.D3_ESTORNO=''                  	"
	clQuery += " 		AND ROT.D3_TM > '500'				   	"
	clQuery += " 		AND ROT.D_E_L_E_T_=''				   	"
	clQuery += " 		AND SUBSTRING(ROT.D3_LOCAL,1,1)='R'	"	 	
	clQuery += " 	WHERE SF2.F2_FILIAL='"+xFilial("SF2")+"'  	"
	clQuery += " 		AND SF2.F2_XFINAL='4' 		  		   	"
	clQuery += " 		AND LEFT(SF2.F2_XCODPA,1)='R' 		   	"	
	clQuery += " 		AND SF2.F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
	clQuery += " 		AND SF2.F2_XCODPA BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' " 
	clQuery += " 		AND SF2.F2_DOC    BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
	clQuery += " 		AND SF2.F2_SERIE  BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
	clQuery += " 		AND SF2.D_E_L_E_T_='' AND SD2.D_E_L_E_T_='' "
	clQuery += " 		AND SB1.D_E_L_E_T_='' 	 					"
		
	clQuery += " 	UNION 				 "
	
	clQuery += " 	SELECT SF2.F2_XCODPA   " 
	clQuery += " 	,SF2.F2_DOC         "
	clQuery += " 	,SF2.F2_SERIE       "
	clQuery += " 	,SD2.D2_COD	      	"
	clQuery += " 	,SB1.B1_DESC        "
	clQuery += " 	,SF2.F2_EMISSAO     "
	clQuery += " 	,'' AS 'D3_LOCAL'   "
	clQuery += " 	,'' AS 'D3_ESTORNO' "
	clQuery += " 	,'' AS 'D3_DOC'     "
	clQuery += " 	,'' AS 'D3_XPATRI'  "
	clQuery += " 	,SF2.F2_CLIENTE     "
	clQuery += " 	,SF2.F2_LOJA        "
	clQuery += " 	,SF2.F2_XCARGA      "
	clQuery += " 	,SF2.F2_XPLACA      "
	clQuery += " 	,SF2.F2_XMOTOR      "
	clQuery += " 	,SD2.D2_QUANT       "
	clQuery += " 	,SD2.D2_ITEM        "
	clQuery += " 	,SD1.D1_ITEM        "
	clQuery += " 	,'' AS 'D3_QUANT'   "
	clQuery += " 	,SD1.D1_QUANT   "
	clQuery += " 	,SD2.D2_PRCVEN      "
	clQuery += " 	,SD2.D2_TOTAL       "
	clQuery += " 	FROM "+RetSqlName("SF2")+" AS SF2 "
	clQuery += " 	INNER JOIN "+RetSqlName("SD2")+" AS SD2  "
	clQuery += " 	ON SF2.F2_FILIAL=SD2.D2_FILIAL    "
	clQuery += " 	AND SF2.F2_DOC=SD2.D2_DOC         "
	clQuery += " 	AND SF2.F2_SERIE=SD2.D2_SERIE     "
	clQuery += " 	AND SF2.F2_CLIENTE=SD2.D2_CLIENTE "
	clQuery += " 	AND SF2.F2_LOJA=SD2.D2_LOJA       "
	clQuery += " 	AND SF2.F2_EMISSAO=SD2.D2_EMISSAO "
	clQuery += " 	LEFT OUTER JOIN "+RetSqlName("SD1")+" AS SD1 ON "
	clQuery += " 		SD2.D2_FILIAL=SD1.D1_FILIAL 	  		"
	clQuery += " 		AND SD2.D2_DOC=SD1.D1_NFORI 	  		"	
	clQuery += " 		AND D2_SERIE=D1_SERIORI   		  		"	
	clQuery += " 		AND SD2.D2_COD=SD1.D1_COD		  		"	
 	clQuery += " 		AND SD2.D2_ITEM=SD1.D1_ITEMORI 	  		"	
	clQuery += " 		AND SD2.D2_CLIENTE=SD1.D1_FORNECE 		"	
	clQuery += " 		AND SD2.D2_LOJA=SD1.D1_LOJA 	  		"	
	clQuery += " 		AND SD1.D_E_L_E_T_=''  			  		"
	clQuery += " 	INNER JOIN "+RetSqlName("SB1")+" AS SB1  "
	clQuery += " 	ON SD2.D2_COD=SB1.B1_COD                 "
	clQuery += " 	WHERE SF2.F2_FILIAL='"+xFilial("SF2")+"' "
	clQuery += " 	AND SF2.F2_XFINAL='4'                    "
	clQuery += " 	AND LEFT(SF2.F2_XCODPA,1)='R'            "
	clQuery += " 	AND SF2.F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
	clQuery += " 	AND SF2.F2_XCODPA  BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' " 
	clQuery += " 	AND SF2.F2_DOC     BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
	clQuery += " 	AND SF2.F2_SERIE   BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
	clQuery += " 	AND (SD2.D2_QUANT = SD2.D2_XSLDPA + SD1.D1_QUANT OR SD2.D2_QUANT=SD2.D2_XSLDPA)   "
	clQuery += " 	AND SF2.D_E_L_E_T_=' '    "
	clQuery += " 	AND SD2.D_E_L_E_T_=' '    "
	clQuery += " 	AND SB1.D_E_L_E_T_=' '	) AS RABAS ORDER BY RABAS.F2_XCODPA,RABAS.F2_DOC,RABAS.F2_SERIE,RABAS.D2_COD,RABAS.D2_ITEM "
		  	
	clQuery := ChangeQuery(clQuery)
	MemoWrite("ROTA.SQL",clQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,clQuery),'ROTA',.T.,.T.)

	TcSetField("ROTA","F2_EMISSAO","D",8)
	TcSetField("ROTA","D2_QUANT","N",14,2)
	TcSetField("ROTA","D1_QUANT","N",14,2)
	TcSetField("ROTA","D3_QUANT","N",14,2)
	TcSetField("ROTA","D2_PRCVEN","N",14,4)
	TcSetField("ROTA","D2_TOTAL","N",14,2)

//----------------------------------------------------------------------//
//				³ Verifica o cancelamento pelo usuario...               //
//----------------------------------------------------------------------//

	ROTA->(DbGoTop())
	While ROTA->(!Eof())
	
		If nlLin > 65
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.F.)
			nlLin :=8
		EndIf
	
		If lAbortPrint
			@nlLin,00 Psay "*** CANCELADO PELO OPERADOR ***"
			Exit
		EndIf
	 
&&***************************imprime dados das Rotas******************************&&
	
		clRota:=ROTA->F2_XCODPA
		DbSelectArea("ZZ1")
		DbSetOrder(1)
		DbSeek(XFilial("ZZ1")+ROTA->F2_XCODPA)  
		clDescRot:=ZZ1_DESCRI	&&Descrição da Rota
	 
		@ nlLin++,095 Psay	"NUM DA ROTA: " + ROTA->F2_XCODPA + "  -->>  " + clDescRot 
		@ nlLin++,00 Psay __PrtThinLine()

&&**********************************************************imprime dados das notas**************************************************************&&
	
		While ROTA->F2_XCODPA == clRota
			If nlLin > 65
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.F.)
				nlLin :=8
			ENDIF 
			clNota :=ROTA->F2_DOC  
			clSerie:=ROTA->F2_SERIE
			clCli:= ROTA->F2_CLIENTE
			clLoj:=ROTA->F2_LOJA
			@ nlLin++,00 Psay "NOTA / SERIE --->  " + ROTA->F2_DOC +" / " + ROTA->F2_SERIE +Space(10)+" EMISSAO  --->  " + DTOC(ROTA->F2_EMISSAO) +Space(10)+ "CLIENTE / LOJA ->  " + ROTA->F2_CLIENTE + " / " + ROTA->F2_LOJA
			@ nlLin++,00 Psay "ROMANEIO -->  " + ROTA->F2_XCARGA +Space(10) +" PLACA DO CARRO -->  " + ROTA->F2_XPLACA +Space(10)+ " MOTORISTA -->  "+ROTA->F2_XMOTOR
			@ nlLin++,00 Psay __PrtThinLine()
			nlLin+=2
		
&&**********************************************************************itens da nota fiscal de saida de abastecimento**********************************************************************&&

			AADD(alNota,{clNota,clSerie,ROTA->F2_EMISSAO})
			
		
			While ROTA->F2_DOC==clNota .AND. ROTA->F2_SERIE==clSerie
				clProd	 :=ROTA->D2_COD
				clDesc	 :=ROTA->B1_DESC			
				nlQtdeDist:=0
				nlVunit :=ROTA->D2_PRCVEN
				@ nlLin,00  Psay "PRODUTO --> "+ROTA->D2_COD + "DESCRIÇÃO --> " + ROTA->B1_DESC + "|P.A."+Space(7)+"|DESC_PA"+Space(33)+"|PATRIMONIO | QUANTIDADE   |VLR_UNITARIO   |TOTAL"
				nlLin++
				@ nlLin,000 Psay Replicate("-",220)
				nlLin++			           
				QTDE1:=0 						&& quantidade do produto de saida
				QTDE2:=0						&& total do produto na saida						
				QTDE3:=0 						&& total do produto no retorno				
				clCtrlD:=""
				clCtrlR:=""
				clNf:=ROTA->F2_DOC				
				While ROTA->D2_COD==clProd .AND. ROTA->F2_DOC==clNf 			 	
		 			For nI := 1 to Len(alSd3)
			 			if ROTA->D2_COD==alSd3[nI][9] .AND. ROTA->D1_ITEM=alSd3[nI][8]
			 				clCtrlD:="S"
			 			EndIf
			 			if ROTA->D2_COD==alSd3[nI][9] .AND. ROTA->D2_ITEM=alSd3[nI][7]
			 				clCtrlR:="S"
		 				EndIf
					Next nI
							
					IF clCtrlR==""																																																				
						//QTDE3:=QTDE3 + ROTA->D1_QUANT
						nlprunit:=ROTA->D2_PRCVEN
			 			QTDE1:=QTDE1 + ROTA->D2_QUANT  
			 			QTDE2:=QTDE2 + ROTA->D2_TOTAL
			 		ENDIF
					clCtrlD:="" 	
					clCtrlR:=""
			 		nlQitemNot:=nlQitemNot + ROTA->D2_QUANT
					clItem	 :=ROTA->D2_ITEM
					
					While ROTA->D2_COD==clProd .AND. ROTA->D2_ITEM==clItem  .AND. ROTA->F2_DOC==clNf
						IF DbSeek(XFilial("ZZ1")+ ROTA->D3_LOCAL)
							clDescPa:= ZZ1->ZZ1_DESCRI
						EndIf
						IF QTDE1 <> 0 .AND. ROTA->D3_QUANT <> 0 								
							AADD(alSd3,{ROTA->D3_LOCAL,clDescPa,ROTA->D3_XPATRI,ROTA->D3_QUANT,ROTA->D2_PRCVEN,(ROTA->D2_PRCVEN * ROTA->D3_QUANT,),ROTA->D2_ITEM,ROTA->D1_ITEM,ROTA->D2_COD,ROTA->D3_QUANT})
						EndIf
	 					ROTA->(DbSKip())
	 				EndDo
	 				
	 			EndDo
	 			@ nlLin,00  Psay "REMESSA --> "
				@ nlLin,130 Psay  QTDE1    Picture "@E 999,999,999.99"   && quantidade de remessa/produto
				@ nlLin,145 Psay  nlprunit Picture "@E 999,999,999.9999" && preço unitário
				@ nlLin,161 Psay  QTDE2    Picture "@E 999,999,999.99"   && total de remessa/produto
				nlLin++
				If nlLin > 65
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.F.)
					nlLin :=8
				EndIf
											
&&***********************************Explosão dos itesns distribuidos nas PAs*********************************&&

				For nI := 1 to Len(alSd3)
					nlQtdeDist:=nlQtdeDist +  alSd3[nI][4] 
					@ nlLin,00  Psay "ABASTECIMENTO-->" 					
					@ nlLin,71  Psay  alSd3[nI][1] 								&& Codigo da PA
					@ nlLin,83  Psay alSd3[nI][2] 								&& Descrição da PA			
					@ nlLin,124 Psay alSd3[nI][3] 								&& Codigo do patrimônio
					@ nlLin,130 Psay alSd3[nI][4] Picture  "@E 999,999,999.99"  && qtde distribuido na PA
					@ nlLin,145 Psay alSd3[nI][5] Picture "@E 999,999,999.9999" && preço unitário do produto
					@ nlLin,161 Psay alSd3[nI][6] Picture "@E 999,999,999.99"   && total do produto
					nlLin++
					If nlLin > 65
						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.F.)
						nlLin :=8
					EndIf
				Next nI
				alSd3:={}
				clDescPa:=""

&&**********************Retornos e diferenças entre produtos da nota e distribuidos por item***************************&&
 				If nlLin > 65
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.F.)
					nlLin :=8
				EndIf	
							
				QTDE3:= QtdRet(clNota,clSerie,clProd,clCli,clLoj) 
																		
		 		nlQtdeDi:=(QTDE1 -(QTDE3 + nlQtdeDist))
		 		nlQitemDis:= nlQitemDis + nlQtdeDist
		 		@ nlLin++,00 Psay Replicate("-",220)
		 		@ nlLin,00   Psay "RETORNO--> "
		 		@ nlLin,130  Psay QTDE3 Picture "@E 999,999,999.99"
		 		@ nlLin,145  Psay nlVunit  picture  "@E 999,999,999.9999"
		 		@ nlLin,161  Psay (QTDE3 * nlVunit)  Picture "@E 999,999,999.99"
		 		nlLin++
		 		If nlLin > 65
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.F.)
					nlLin :=8
				EndIf
		 		@ nlLin,000  Psay "DIF(FALTA/SOBRA) --> " 
		 		@ nlLin,130  Psay nlQtdeDi Picture "@E 999,999,999.99"
		 		@ nlLin,145  Psay nlVunit  Picture  "@E 999,999,999.9999"
		 		@ nlLin,161  Psay (nlQtdeDi * nlVunit)  Picture "@E 999,999,999.99"
		 		nlQtdeRt:= nlQtdeRt + QTDE3
		 		nlLin+=2
		 		@ nlLin,00   Psay Replicate("=",220)
		 		nlLin+=4
		 		If nlQtdeDi <> 0
		 			AADD(alDif,{clProd,clDesc,nlQtdeDi,nlVunit,(nlQtdeDi * nlVunit)})
		 		EndIf
				QTDE3 		:=0
				QTDE1 		:=0
				If nlLin > 65
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.F.)
					nlLin :=8
				EndIf		                                          
		 	EndDo 
	 	
&&*********************Produtos que apresentam divergencia entre a qtde da nota e a qtde distribuida*********************&&

		 	If Len(alDif) > 0
	 			If nlLin > 65
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.F.)
					nlLin :=8
				EndIf 
				@ nlLin,00 Psay "PRODUTO     |DESCRIÇÃO"+Space(26)+"QTDE_DIFERENÇA  |VLR_UNITARIO   |TOT_DIFERENÇA(R$)"
				nlLin++
				@ nlLin,00 Psay replicate("_",220)
				nlLin+=2
				For nI := 1 To Len(alDif)
					If nlLin > 65
						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.F.)
						nlLin :=8
					EndIf 
					@ nlLin,000 Psay alDif[nI][1]
					@ nlLin,013 Psay alDif[nI][2]
					@ nlLin,048 Psay alDif[nI][3] Picture "@E 999,999,999.99"
					@ nlLin,065 Psay alDif[nI][4] Picture "@E 999,999,999.9999"
					@ nlLin,081 Psay alDif[nI][5] Picture "@E 999,999,999.99"
					nlTotTotal += alDif[nI][5]
					nlLin++
					AADD(alboleto,{alDif[nI][1],alDif[nI][2],alDif[nI][3],alDif[nI][4],alDif[nI][5]}) 
				Next nI
			EndIf 
		
&&*************************Totalizador dos itens da nota e distribuidos****************************&&

			@ nlLin,00  Psay Replicate("_",220)
			nlLin++ 
			@ nlLin,00  Psay "TOTAL DE ITENS DA NOTA--> "
			@ nlLin,026 Psay nlQitemNot Picture "@E 999,999,999.99"
			@ nlLin,43  Psay "TOTAL DE ITENS DA DISTRIBUIDOS--> "
			@ nlLin,075 Psay nlQitemDis Picture "@E 999,999,999.99"		
			@ nlLin,92  Psay "TOTAL DE ITENS DE RETORNO DE ABASTECIMENTO"
			@ nlLin,133 Psay nlQtdeRt Picture "@E 999,999,999.99"		
			@ nlLin,148 Psay "DIFERENÇA DE ITENS(NOTA - (RETORNO + DISTRIBUIDOS)--> "
			@ nlLin,202 Psay (nlQitemNot - (nlQitemDis + nlQtdeRt )) Picture "@E 999,999,999.99"			
			nlLin++
			@ nlLin,00  Psay Replicate("_",220)
			nlLin++
		
&&*****************Limpando as Variáveis******************&&

			nlprunit	:=0	 		
		 	nlVunit		:=0  
	 		QTDE3 		:=0
			QTDE1 		:=0
			nlQtdeDist	:=0
			nlQtdeDi  	:=0
			nlQitemDis	:=0
			nlQitemNot	:=0
			nlQtdeRt  	:=0
			alDif     	:={}	
	 		nlLin 	  	:= 66
		 EndDo
	 
&&********************************************************Impressão do Boleto de Cobrança por divergencia de produtos nas rotas******************************************************&&

		 If Len(alboleto) > 0
			 nllin:=8 
			 
			 @ nlLin,90 Psay "AUTORIZAÇÃO DE DESCONTO EM FOLHA DE PAGAMENTO"
			 
			 DbSelectArea("ZZ7")
			 DbSetOrder(1)
		     If DbSeek(XFilial("ZZ7")+clRota)
		     	clNomeResp	:= ZZ7->ZZ7_RESP
		     	clNomeResp	:= alltrim(clNomeResp)
		     	clCpf		:= SUBSTR(TRIM(ZZ7->ZZ7_CPF),1,3)+"."+ SUBSTR(TRIM(ZZ7->ZZ7_CPF),4,3) +"."+ SUBSTR(TRIM(ZZ7->ZZ7_CPF),7,3)+"-"+ SUBSTR(TRIM(ZZ7->ZZ7_CPF),10,2)
		     	clRg 		:= ZZ7->ZZ7_RG
		     	clEmpres	:= ZZ7->ZZ7_EMPRES
		     	clEmpres	:= alltrim(clEmpres)
		     	clCodMat	:= ZZ7->ZZ7_CODMAT
		     EndIf
			 nllin+=5
			 @ nlLin,30 Psay "Eu, "+ clNomeResp +",portador do RG :"+ clRg +",CPF :"+ clCpf +", Matrícula :"+ clCodMat +", funcionário da Empresa "+ clEmpres 
			 nllin++
			 @ nlLin,30 Psay "autorizo o desconto em folha de pagamento, no valor total de R$ "+ Alltrim(TransForm(nlTotTotal,"@E 999,999,999.99")) +" , em _____ parcelas, referente à diferença na distribuição de produtos."
			 nllin+=5
			 @ nlLin,30 Psay "Nº Da Rota   :  "+clRota+" "
			 nllin+=2
			 @ nlLin,30 Psay "Nº Das Notas :   "
			 nlCol:=48
			 For nI := 1 To Len(alNota)		 		 
				 @ nlLin,nlCol Psay alNota[nI][1]+"/"+alNota[nI][2]+","		 
				 clEmissa:=alNota[nI][3]		 
				 nlCol+=15		  
			 Next nI
			 alNota:={}
			 nllin+=2
			 @ nlLin,30 Psay "Data da Emissão Das Notas Fiscais :  "+dtoc(clEmissa)
			 nllin+=2	 
			 @ nlLin,30 Psay "Data Da Ocorrencia :  "+ Dtoc(Datavalida(clEmissa + 1))
			 nllin+=4
			 @ nlLin,90 Psay "PRODUTOS QUE SE ENCONTRAM COM DIVERGÊNCIA NESTA ROTA"
			 nllin+=1
			 @ nlLin,90 Psay "----------------------------------------------------"
			 nllin+=2
			 @ nlLin,30 Psay "PRODUTO"+SPACE(8)+"| DESCRIÇÃO"+SPACE(26)+"| QUANT_DIVERGE | VALOR_UNITÁRIO   | VALOR_TOTAL |"&& QUANT_DIFERÊNCIA | VAL_UNITÁRIO  | TOTAL_DIVERGENTE |"
			 nlLin++
			 @ nlLin,30 Psay Replicate("_",160)
			 nlLin+=2
			 For nI := 1 to Len(alboleto)
				 @ nlLin,030 Psay alboleto[nI][1]
				 @ nlLin,047 Psay alboleto[nI][2]
				 @ nlLin,084 Psay alboleto[nI][3] Picture "@E 999,999,999.99"
				 @ nlLin,100 Psay alboleto[nI][4] Picture "@E 999,999,999.9999"
				 @ nlLin,122 Psay alboleto[nI][5] Picture "@E 999,999,999.99"
				 nlLin++ 
				 IF nlLin >65
				 	nllin:=8
				 	@ nlLin,30 Psay "PRODUTO        | DESCRIÇÃO                          | QUANT_DIVERGE | VALOR_UNITÁRIO   | VALOR_TOTAL |" 
			 		nlLin++
			 		@ nlLin,30 Psay Replicate("_",160)
			 		nlLin+=2
				 EndIf		 
			 Next nI
			 @ nlLin,30 Psay Replicate("-",160)
			 nlLin++ 
			 @ nlLin,030 Psay "TOTAL A DESCONTAR R$ "+Space(71)+transform(nlTotTotal,"@E 999,999,999.99")+" "
			 nlLin++
			 @ nlLin,30 Psay Replicate("-",160)

			 @ 067,140 Psay  "_____________________________________________"
			 @ 068,30  Psay  "Responsável pela apuração :  Processamento."	 
			 @ 068,150 Psay  "Assinatura do funcionário"
			 
			 nllin:=61
			 nlTotTotal:=0
		 EndIf 
		 nlTotTotal:=0		 
     	 clNomeResp	:=""
     	 clCpf		:=""
     	 clRg 		:=""
     	 clEmpres	:=""
     	 clCodMat	:=""
		 alboleto:={}
	EndDo
		
//----------------------------------------------------------------------//
//                 Finaliza a execucao do relatorio...                  //
//----------------------------------------------------------------------//

	Set Device To Screen
                                                   	
//----------------------------------------------------------------------//
// Se impressao em disco, chama o gerenciador de impressao...           //
//----------------------------------------------------------------------//

	If aReturn[5]==1
		dbCommitAll()
		Set Printer To
		OurSpool(wnrel)                                		
	EndIf	
	MS_FLUSH()
	ROTA->(dbCloseArea())                                
Return  

/*/
______________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+------------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦QtdRet()¦ Autor ¦ Fabio Sales  ¦ 	  Data ¦        17/01/2012 ¦¦¦
¦¦+----------+-------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ função para retornar a quantidade de produtos retornados    ¦¦¦
¦¦¦			 ¦ pela rota de abastecimento								   ¦¦¦
¦¦+----------+-------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Faturamento / TokeTake                                      ¦¦¦
¦¦+------------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/    

Static Function QtdRet(_Nota,_Serie,_Prod,_cliente,_loja)

	Local _aArea := GetArea() // Salva a Area Atual
	Local _nQuant:= 0
	Local _nRetorno:=0
/*-----------------------------------------------------------|
| Montagem da query com os dados do ultimo fechamento do mes |
|-----------------------------------------------------------*/

	clQry := " SELECT  D1_COD,SUM(D1_QUANT) AS QTD FROM "+RetSqlName("SD1")+" AS SD1 WHERE SD1.D_E_L_E_T_=''  "
	clQry += " AND D1_COD='"+_Prod+"'  AND D1_NFORI='"+_Nota+"' AND D1_SERIORI='"+_Serie+"' "
	clQry += " AND D1_FORNECE='"+_cliente+"' AND D1_LOJA='"+_loja+"' "
	clQry += " GROUP BY D1_COD "  

/*-------------------------------------------|
|verifica se a query existe se existir fecha |
|-------------------------------------------*/

	If Select("ROT1") > 0
		dbSelectArea("ROT1")
		DbCloseArea()
	EndIf

/*---------------------------------------|
| cria a query e dar um apelido para ela |
|---------------------------------------*/

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,clQry),"ROT1",.F.,.T.)

/*--------------------------------------------------|
| ajusta casas decimais e datas no retorno da query |
|--------------------------------------------------*/

	TcSetField("ROT1","QTD","N",14,2)
	
	dbSelectArea("ROT1")
	
	While ROT1->(!Eof())
		_nQuant = _nQuant + ROT1->QTD
		ROT1->(DbSkip())
	EndDo

	_nRetorno := _nQuant

/*----------------------|
| restaura a area atual |
|----------------------*/

	RestArea(_aArea)

Return(_nRetorno)
