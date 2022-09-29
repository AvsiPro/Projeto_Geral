#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SF2460I  ºAutor  ³Luciano Santiago    º Data ³  23/09/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada apos a geracao da NF de saida para FLEGAR  º±±
±±º          ³os campos que identificam a NF como Remessa P/ Distribuicao º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TokTake                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SF2460I()

Local cMun := ""
Local cCep := ""

Local aCabSF1 :={}
Local aItemSD1:={}
Local aStruSF1:={}
Local aStruSD1:={}
Local cDado 		:= ""
Local cNomeCampo	:= ""
Local nPosicao 		:= 0
Local aColsSE1	:=	{}  
//Local cHolding	:=	If(cEmpAnt<>"10",Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_GRUECON"),"")    
Local lVerba	:=	.F.
Local cQuery	        
Local aAreaTrb	:=	{}
Local aVetorBx	:=	{}          
Local cVerbaH	:=	""	//GetMV("MV_XROTVER")
Local aArea		:= GetArea()
Private lMsErroAuto := .F.


// Tratamento para AMC
If cEmpAnt == "10"
	Return
EndIf


cVerbaH	:=	GetMV("MV_XROTVER")

/*
// comentado em 29/07/2016 - vamos ver se alguem grita - Jackson
//Inicio da rotina de verba de propaganda
If cVerbaH == "1"      
	//Comparando a principio pelo cliente 000001 toktake ate descobrir qual e a regra a ser utilizada nas regras de vendas.
	IF SF2->F2_CLIENTE <> '000001'  //.AND. CNUMEMP == "01"
	                       
		lVerba := IIF(Posicione("ZZC",1,xFilial("ZZC")+SC5->C5_XFINAL,"ZZC_DUPLI") == "S",.T.,.F.)
		
		If lVerba
			
			If cEmpant == "11"
				cQuery := "SELECT ZZJ_VERBA,ZZJ_DESC,ZZJ_PERC,ZZJ_TIPO,ZZJ_DTINI,ZZJ_DTFIM,ZZJ_HOLD,ZZE_NATUR,ROW_NUMBER()Over(ORDER BY ZZJ_VERBA) AS PARC"
			Else 
				cQuery := "SELECT ZZJ_VERBA,ZZJ_DESC,ZZJ_PERC,ZZJ_TIPO,ZZJ_DTINI,ZZJ_DTFIM,ZZJ_HOLD,ZZI_NATUR,ROW_NUMBER()Over(ORDER BY ZZJ_VERBA) AS PARC"
			EndIf
			
			cQuery += " FROM "+RetSQLName("ZZJ")+" ZZJ"
			
			If cEmpant == "11" 
				cQuery += " INNER JOIN "+RetSQLName("ZZE")+" ZZE ON ZZE_FILIAL=ZZJ_FILIAL AND ZZE_CODIGO=ZZJ_VERBA AND ZZE.D_E_L_E_T_<>'*'"
			Else
				cQuery += " INNER JOIN "+RetSQLName("ZZI")+" ZZI ON ZZI_FILIAL=ZZJ_FILIAL AND ZZI_CODIGO=ZZJ_VERBA AND ZZI.D_E_L_E_T_<>'*'"
			EndIf
			
			cQuery += "  WHERE ZZJ_FILIAL='"+xFilial("ZZJ")+"'" 
			cQuery += " 	AND (ZZJ_CODIGO='"+SF2->F2_CLIENTE+"'"
			If !empty(cHolding) 
				cQuery += " 	OR ZZJ_HOLD IN(SELECT ZZB_HOLDIN FROM "+RetSQLName("ZZB")+" WHERE ZZB_CODIGO='"+cHolding+"'))"
			Else
				cQuery += ")"
			EndIf
			cQuery += " 	AND ZZJ_TIPO='1'"
			cQuery += " 	AND ZZJ.D_E_L_E_T_<>'*'"   
		  	
		  	If Select('TRB') > 0
				dbSelectArea('TRB')
				dbCloseArea()
			EndIf
			
			MemoWrite("DP102TFIN.SQL",cQuery)
			DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
			
			DbSelectArea("TRB")  
		    
			While !EOF()
				aColsSE1 := {}
	
				aAdd(aColsSE1,{"E1_FILIAL" 	,xFilial("SE1")	,Nil}) // Codigo da Filial
				aAdd(aColsSE1,{"E1_PREFIXO"	,'VRC'      	,Nil}) // Prefixo do Titulo
				aAdd(aColsSE1,{"E1_NUM"    	,SF2->F2_DOC   	,Nil}) // Numero do Titulo
				aAdd(aColsSE1,{"E1_PARCELA"	,cvaltochar(TRB->PARC)	      	,Nil}) // Parcela do pedido
				aAdd(aColsSE1,{"E1_TIPO"   	,'NCC'      	,Nil}) // Tipo do Titulo
				aAdd(aColsSE1,{"E1_CLIENTE"	,SF2->F2_CLIENTE,Nil}) // Codigo do cliente
				aAdd(aColsSE1,{"E1_LOJA"	,SF2->F2_LOJA	,Nil}) // Loja do cliente
				aAdd(aColsSE1,{"E1_EMISSAO"	,dDataBase 		,Nil}) // Data de emissao
				aAdd(aColsSE1,{"E1_VENCTO"	,dDataBase 		,Nil}) // Data do vencimento
				aAdd(aColsSE1,{"E1_VENCREA"	,DataValida(dDataBase)  		,Nil}) // Vencimento Real
				aAdd(aColsSE1,{"E1_VALOR"	,SF2->F2_VALBRUT * (TRB->ZZJ_PERC / 100)    		,Nil}) // Valor do titulo
				aAdd(aColsSE1,{"E1_HIST"	,'VERBAS CONTRATUAIS NF '+SF2->F2_DOC+' CORRESP. '+Alltrim(TRB->ZZJ_DESC)  		,Nil}) // Historico
				
				If cEmpant == "11"                                                              
					aAdd(aColsSE1,{"E1_NATUREZ"	,TRB->ZZE_NATUR    	,Nil}) // Natureza do Titulo
				Else
					aAdd(aColsSE1,{"E1_NATUREZ"	,TRB->ZZI_NATUR    	,Nil}) // Natureza do Titulo
				EndIf
				
				aAdd(aColsSE1,{"E1_MOEDA"	,1		       		,Nil}) // Moeda do Titulo em real
				aAdd(aColsSE1,{"E1_MSFIL"	,xFilial("SF2")		,Nil}) // Filial de Origem
				aAdd(aColsSE1,{"E1_FILORIG"	,xFilial("SF2")		,Nil}) // Filial de Origem
				aAdd(aColsSE1,{"E1_ORIGEM"	,'FINA040'      	,Nil}) // Origem
				aAdd(aColsSE1,{"E1_CCD"		,'15711001'      	,Nil}) // Centro de Custo de Debito ESTE E O CCD passado pelo Alberto do financeiro.
				aAreaTrb := GetArea()
				MSExecAuto({|x,y| FINA040(x,y)},aColsSE1,3)
				
				If lMsErroAuto
					DisarmTransaction()
					MostraErro()
				Else
	                //Chamada da rotina que ira efetuar a compensacao do titulo de ncc sobre verbas contratuais com o titulo a receber gerado para o cliente.
					U_TTFINC05(SF2->F2_CLIENTE,SF2->F2_LOJA,xFilial("SF2")+Alltrim(SF2->F2_SERIE),'VRC',SF2->F2_DOC,SPACE(3),Cvaltochar(TRB->PARC)+space(3-len(CVALTOCHAR(TRB->PARC))),'NCC')
				Endif                
				RestArea(aAreaTrb)
				Dbskip()
			EndDo
	  
		EndIf
	EndIf
EndIf
*/


// Final tratamento de verba de propaganda  
//Validacao para nao preencher o volume nas notas da luxor e sim trazer o que esta no campo c5_volume1
If substr(cNumEmp,1,2) != "02"
	SF2->F2_VOLUME1 := U_TTQTDNFS(SF2->F2_FILIAL,SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_EMISSAO,SF2->F2_CLIENTE,SF2->F2_LOJA)
EndIf

SF2->F2_XCODPA  := SC5->C5_XCODPA
SF2->F2_XNFABAS := SC5->C5_XNFABAS
SF2->F2_XSTATUS := "1"
If SM0->M0_CODIGO=='01' .OR. SM0->M0_CODIGO=='05' .OR. SM0->M0_CODIGO=="11"
	SF2->F2_XTPCARG := SC5->C5_XTPCARG
	SF2->F2_XGPV    := SC5->C5_XGPV
End

If SC5->C5_TIPO $ "D/B"
	cMun := Posicione("SA2",1,xFilial("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A2_COD_MUN")
	cCep := Posicione("SA2",1,xFilial("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A2_CEP")
Else
	cMun := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_COD_MUN")
	cCep := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_CEP")
EndIf

If SC5->C5_TPFRETE=="C"
	SF2->F2_TPFRETE := "0"
ElseIf SC5->C5_TPFRETE=="F"
	SF2->F2_TPFRETE := "1"
End

SF2->F2_XMUN	:= cMun
SF2->F2_XCEP	:= cCEP
SF2->F2_XFINAL	:= SC5->C5_XFINAL

// PALIATIVO PARA GRAVAR O CAMPO SF2->F2_ESPECI1
SF2->F2_ESPECI1 := SC5->C5_ESPECI1

//Grava data da geração da NF
dbSelectArea("SC5")
aAreaSC5 := GetArea()
RecLock("SC5",.F.)
SC5->C5_DTNF := DATE()
MsUnlock()
RestArea(aAreaSC5)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ REGRAS DE NEGICIO POR EMPRESA                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SM0->M0_CODIGO=='01' .OR. SM0->M0_CODIGO=='05'  .OR. SM0->M0_CODIGO=="11"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ CONTROLES TOK-TAKE FILIAL 01                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SM0->M0_CODFIL=='01'             
		//CONTROLE DE ENVIO DE BOLETOS E NOTA DE DEBITO PARA O CLIENTE POR EMAIL AO SER FATURADA.
		//ENTROU JUNTO COM O GESTAO DE CONTRATOS PARA FATURAMENTO DE LOCACAO - 04/09/2013 ALEXANDRE
		If Alltrim(SF2->F2_SERIE) == "D"
			U_TTFATR16(SF2->F2_DOC,SF2->F2_SERIE) 
		EndIf
			
//		SF2->F2_XACRPV  := SC5->C5_XACRPV
		If SF2->F2_TIPO == 'N'
			aAreaSE1 := GetArea()
			dbSelectArea("SE1")
			dbSetOrder(2)
			dbSeek(xFilial("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_PREFIXO+SF2->F2_DOC)
			If SF2->(F2_CLIENTE+F2_LOJA+F2_PREFIXO+F2_DOC) == SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM)
				RecLock("SE1",.F.)
				SE1->E1_XACRPV := SC5->C5_XACRPV
				MsUnlock()
			End
			RestArea(aAreaSE1)
		End
		dbSelectArea("SF2")
	End
End

//Alteracoes abaixo realizada em 28/01/10 por Cadu.
//Os tratamentos abaixo somente se for pedido de transferencia entre filiais.

If !Empty(SC5->C5_XFLDEST)
	
	SF2->F2_XTRANSF	:= SC5->C5_XFLDEST
	
	//Pega o CGC da filial corrente para localizar o fornecedor na filial de destino
	cCGC := SM0->M0_CGC
	
	//A filial de origem devera estar cadastrado como fornecedor tb.
	dbSelectArea("SA2")
	aAreaSA2 := GetArea()
	dbSetOrder(3)
	dbSeek(xFilial("SA2")+cCGC)
	
	cCodFor := SA2->A2_COD
	cLoja 	:= SA2->A2_LOJA
	cEst 	:= SA2->A2_EST
	
	RestArea(aAreaSA2)
	
	dbSelectArea("SF2")

	aCabSF1 := {{"F1_FILIAL"   ,SF2->F2_XTRANSF},;
				{"F1_TIPO"     ,SF2->F2_TIPO  },;
				{"F1_DOC"      ,SF2->F2_DOC   },;
				{"F1_SERIE"    ,SF2->F2_SERIE },;
				{"F1_EMISSAO"  ,dDataBase     },;
				{"F1_FORNECE"  ,cCodFor       },;
				{"F1_LOJA"     ,cLoja 	      },;
				{"F1_ESPECIE"  ,SF2->F2_ESPECIE } /* Alterado Por Fabio Sales em 11/06/2012 de 'NF' para SF2->F2_ESPECIE  */,;
				{"F1_FORMUL"   ,'N'           },;
				{"F1_DTDIGIT"  ,dDataBase     },;
				{"F1_EST"      ,cEst          },;
				{"F1_XTRANSF"  ,cFilAnt       },;
				{"F1_CGC"      ,cCGC	      } }
	
	dbSelectArea("SD2")
	aAreaSD2 := GetArea()
	dbSetOrder(3)
	cNota := SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA
	dbSeek(cNota)
	
	aItemSD1:={}
	
	While !EoF() .And. cNota == SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA
		
		AADD(aItemSD1,{	{"D1_FILIAL" , SF2->F2_XTRANSF },;
		{"D1_DOC"    , SD2->D2_DOC    },;
		{"D1_SERIE"  , SD2->D2_SERIE  },;
		{"D1_FORNECE", cCodFor        },;
		{"D1_LOJA"   , cLoja        },;
		{"D1_EMISSAO", SD2->D2_EMISSAO},;
		{"D1_TIPO"   , 'N'            },;
		{"D1_ITEM"   , SD2->D2_ITEM   },;
		{"D1_TP"     , SD2->D2_TP     },;
		{"D1_COD"    , SD2->D2_COD    },;
		{"D1_UM"     , SD2->D2_UM     },;
		{"D1_QUANT"  , SD2->D2_QUANT  },;
		{"D1_VUNIT"  , SD2->D2_PRCVEN },;
		{"D1_TOTAL"  , SD2->D2_TOTAL  },;
		{"D1_LOCAL"  , Alltrim(GetNewPar("MV_XTRAFIL","D00016")) },;
		{"D1_QTSEGUM", SD2->D2_QTSEGUM},;
		{"D1_DTDIGIT", dDataBase      }})
		dbSkip()
	EndDo
	
	RestArea(aAreaSD2)
	
	dbSelectArea("SF1")
	
	aStruSF1:=dbStruct()
	
	RecLock("SF1",.T.)
	For I := 1 To Len(aCabSF1)
		cDado      := aCabSF1[I][2]
		cNomeCampo := aCabSF1[I][1]
		nPosicao   := ASCAN(aStruSF1,{|x| ALLTRIM(x[1]) == cNomeCampo})
		If nPosicao > 0
			FieldPut(nPosicao,cDado)
		Endif
	Next
	MsUnLock()
	
	dbSelectArea("SD1")
	
	aStruSD1:=dbStruct()
	
	For I := 1 To Len(aItemSD1)
		RecLock("SD1",.T.)
		For J := 1 To Len(aItemSD1[I])
			cDado      := aItemSD1[I][J][2]
			cNomeCampo := aItemSD1[I][J][1]
			nPosicao   := ASCAN(aStruSD1,{|x| ALLTRIM(x[1]) == cNomeCampo})
			If nPosicao > 0
				FieldPut(nPosicao,cDado)
			Endif
		Next
		MsUnLock()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o Arquivo de Saldos  - SB2 - B2_NAOCLAS        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		U_AtuQtdClas(SF2->F2_XTRANSF,1)
		dbSelectArea("SD1")
	Next
	
EndIf   

//SimLog
//u_ttautfat(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA)
                                                           
/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Baixa canhoto de notas de doses³
//³Jackson 13/05/2015             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
// notas de doses - ja baixa canhoto no titulo - SOLICITADO POR CLAUDETE E MELAO
If Alltrim(SF2->F2_XNFABAS) == "2" .And. AllTrim(SF2->F2_XFINAL) <> "4" .And. SubStr(SC5->C5_NUM,1,1) == "E"
	If !Empty(SF2->F2_DUPL)
		DbSelectArea("SE1")
		DbsetOrder(1)
		If DbSeek( xFilial("SE1")+SF2->F2_FILIAL+Alltrim(SF2->F2_SERIE)+SF2->F2_DUPL )
			While !EOF() .And. SE1->E1_NUM == SF2->F2_DUPL .And. SE1->E1_PREFIXO == SF2->F2_FILIAL+Alltrim(SF2->F2_SERIE) .And.;
					SE1->E1_CLIENTE == SF2->F2_CLIENTE .And. SE1->E1_LOJA == SF2->F2_LOJA
				Reclock("SE1",.F.)
				SE1->E1_XRECENT := "S"
				SE1->E1_XRECASS := "S"
				SE1->E1_XHRENTR := Time()
				SE1->E1_XDTENTR := Date()
				SE1->(Msunlock())
				SE1->(dbSkip())
			EndDo
		EndIf
	EndIf	
EndIf 

RestArea(aArea)

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AtuQtdClas³ Rev.  ³ Rogerio Leite         ³ Data ³16.06.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua a gravacao do Arquivo SB2 nas operacoes da PRE-Nota ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 : 1 - Inclusao                                       ³±±
±±³          ³         2 - Exclusao                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SF2460I / MS520VLD                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AtuQtdClas(cFilFor,nOpc)

dbSelectArea("SB2")

If MsSeek(cFilFor+SD1->D1_COD+SD1->D1_LOCAL)
	RecLock("SB2",.F.)
Else
	CriaSB2Cls(SD1->D1_COD,SD1->D1_LOCAL,cFilFor)
EndIf

If nOpc == 1
	SB2->B2_NAOCLAS := SB2->B2_NAOCLAS + SD1->D1_QUANT
Else
	SB2->B2_NAOCLAS := SB2->B2_NAOCLAS - SD1->D1_QUANT
EndIf

SB2->(MsUnlock())

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CriaSB2Cls³ Autor ³ Rogerio Leite         ³ Data ³ 21/06/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao padrao para criar registros no arquivo de saldos em ³±±
±±³          ³ estoque (SB2)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CriaSB2(ExpC1,ExpC2)                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo do produto                                  ³±±
±±³          ³ ExpC2 = Codigo do almoxarifado                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CriaSB2Cls(cProduto,cLocal,cFilSB2)

LOCAL nOrdem:=SB2->(IndexOrd())

dbSelectArea("SB2")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria registro quando nao existir                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !dbSeek(cFilSB2+cProduto+cLocal)
	RecLock("SB2",.T.)
	SB2->B2_FILIAL:= cFilSB2
	SB2->B2_COD   := cProduto
	SB2->B2_LOCAL := cLocal
Endif

dbSetOrder(nOrdem)

Return()
