#INCLUDE "PROTHEUS.CH"

User Function MT410TOK

Local aArea	:=	GetArea()
Local nPosLib	:= ASCAN(AHEADER,{|X| ALLTRIM(X[2]) == "C6_QTDLIB"})
Local nPosQtd	:= ASCAN(AHEADER,{|X| ALLTRIM(X[2]) == "C6_QTDVEN"})
Local nPosItm	:= ASCAN(AHEADER,{|X| ALLTRIM(X[2]) == "C6_ITEM"})
Local nCont 
Local nJ

Local aImpost	:= {}
Local nPosIm1	:= ASCAN(AHEADER,{|X| ALLTRIM(X[2]) == "C6_XVLIMP1"})
Local nPosIm2	:= ASCAN(AHEADER,{|X| ALLTRIM(X[2]) == "C6_XVLIMP2"})
Local nPosIm3	:= ASCAN(AHEADER,{|X| ALLTRIM(X[2]) == "C6_XVLIMP3"})

//Faz a chamada na static function para gerar o log de alteração Cabeçalho Pedidos de venda 
Processa({||LogSC5() },,,)

//Faz a chamada na static function para gerar o log de alteração Itens Pedidos de venda 
Processa({||LogSC6() },,,)

For nCont := 1 to len(aCols)
	aCols[nCont,nPosLib] := aCols[nCont,nPosQtd] 
Next nCont

Processa({||aImpost := _VlrImp(SC5->C5_NUM),"Validando impostos" },,,)

If len(aImpost) > 0
	//aRet,{nTotalST,nTotIPI,nVlrFCP,nTotVal
	For nCont := 1 to len(aCols)	
		For nJ := 1 to len(aImpost)
			If Alltrim(aCols[nCont,nPosItm]) == Alltrim(aImpost[nJ,01])	
				aCols[nCont,nPosIm1] := aImpost[nJ,02]
				aCols[nCont,nPosIm2] := aImpost[nJ,03]
				aCols[nCont,nPosIm3] := aImpost[nJ,04]
			endif
		Next nJ
	Next nCont
	nPosCab := Ascan(aImpost,{|x| Alltrim(x[1]) == '9999'})
	If nPosCab > 0
		M->C5_XTOTNF := aImpost[nPosCab,02]
		M->C5_XTOTFCP:= aImpost[nPosCab,04]
	EndIf
endif 


RestArea(aArea)

Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±º Ponto de Entrada 	 Felipe Mayer - AVSIPRO        Data: 08/01/2020	  º±±
±±ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ±±
±±ºDesc.        Static Function									          º±±
±±º  SC5        Geração de Log Cabeçalho Pedidos de venda                 º±±
±±ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ±±
±±ºUso          Intercoffee                                               º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function LogSC5()

Local lRet	:=	.T.          
Local lFound:=	.F.
Local aLogA	:=	{}
Local nX
Local Obs   :=  ''                       

If lRet .And. Altera
	dbSelectArea("SX3")
	SX3->(dbSetOrder(1))
   	SX3->(dbGoTop())
	If SX3->(dbSeek("SC5"))
		While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "SC5"
			If X3USO(X3_USADO).And.cNivel>=X3_NIVEL .And. X3_CONTEXT<>"V"
				If &(SX3->X3_ARQUIVO+"->"+SX3->X3_CAMPO) != &("M->"+SX3->X3_CAMPO) 
					lFound := .T.
					Aadd(aLogA,{SX3->X3_TITULO,&("M->"+SX3->X3_CAMPO),&(SX3->X3_ARQUIVO+"->"+SX3->X3_CAMPO)})
				EndIf
			EndIf
			SX3->(dbSkip())
		EndDo
	EndIf

	If len(aLogA) > 0
		For nX := 1 to len(aLogA)
			Obs		+=	"Alterado campo "+Alltrim(aLogA[nX,01])+" conteudo anterior "+Alltrim(cvaltochar(aLogA[nX,03]))+" conteudo atual "+Alltrim(cvaltochar(aLogA[nX,02]))+CRLF
		Next nX
	EndIF

    If !Empty(Obs)
        Obs := 'Alteracoes do usuario '+Alltrim(cusername)+' em '+cvaltochar(ddatabase)+' as '+cvaltochar(time())+CRLF+Obs
    
        M->C5_ZZMETMK := Alltrim(M->C5_ZZMETMK) + ' '+Obs
    EndIf
EndIf

Return(lRet)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±º Ponto de Entrada 	 Felipe Mayer - AVSIPRO        Data: 08/01/2020	  º±±
±±ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ±±
±±ºDesc.        Static Function									          º±±
±±º  SC6        Geração de Log Itens Pedidos de venda                 	  º±±
±±ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ±±
±±ºUso          Intercoffee                                               º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function LogSC6()

Local lOk := .T.
Local nPosPrd	:= ASCAN(AHEADER,{|X| ALLTRIM(X[2]) == "C6_PRODUTO"})
Local nPosItm	:= ASCAN(AHEADER,{|X| ALLTRIM(X[2]) == "C6_ITEM"})
Local nPosQtd	:= ASCAN(AHEADER,{|X| ALLTRIM(X[2]) == "C6_QTDVEN"})
Local nPosVlr	:= ASCAN(AHEADER,{|X| ALLTRIM(X[2]) == "C6_PRCVEN"})
Local nPosTes	:= ASCAN(AHEADER,{|X| ALLTRIM(X[2]) == "C6_TES"})
Local nPosOpr	:= ASCAN(AHEADER,{|X| ALLTRIM(X[2]) == "C6_OPER"})
Local nPosLoc	:= ASCAN(AHEADER,{|X| ALLTRIM(X[2]) == "C6_LOCAL"})
Local nPosEnt	:= ASCAN(AHEADER,{|X| ALLTRIM(X[2]) == "C6_ENTREG"})
Local nPosEnd	:= ASCAN(AHEADER,{|X| ALLTRIM(X[2]) == "C6_LOCALIZ"})
Local nPosLot	:= ASCAN(AHEADER,{|X| ALLTRIM(X[2]) == "C6_LOTECTL"})
Local c6num 	:= ''
Local lAux  	:= .T.
Local nX
Local Obs   :=  ''

If Altera

	c6num := M->C5_NUM
	
	DBSelectArea("SC6")
	DbSetOrder(1)
	For nX := 1 to len(aCols)
		If DbSeek(xFilial("SC6")+c6num+aCols[nX,nPosItm])
						
		
			If aCols[nX,nPosPrd] <> SC6->C6_PRODUTO
				Obs	+=	"Alterado campo Produto - conteudo anterior "+Alltrim(SC6->C6_PRODUTO)+" conteudo atual "+Alltrim(aCols[nX,nPosPrd])+' - no item '+aCols[nX,nPosItm]+CRLF
			EndIF
			
			If aCols[nX,nPosQtd] <> SC6->C6_QTDVEN .AND. lAux  = .T.
				Obs	+=	"Alterado campo Quantidade - conteudo anterior "+Alltrim(cvaltochar(SC6->C6_QTDVEN))+" conteudo atual "+Alltrim(cvaltochar(aCols[nX,nPosQtd]))+' - no item '+aCols[nX,nPosItm]+CRLF
			EndIF
			
			If aCols[nX,nPosVlr] <> SC6->C6_PRCVEN .AND. lAux  = .T.
				Obs	+=	"Alterado campo Valor Unitario - conteudo anterior "+Alltrim(cvaltochar(SC6->C6_PRCVEN))+" conteudo atual "+Alltrim(cvaltochar(aCols[nX,nPosVlr]))+' - no item '+aCols[nX,nPosItm]+CRLF
			EndIf
			
			If aCols[nX,nPosTes] <> SC6->C6_TES .AND. lAux  = .T.
				Obs	+=	"Alterado campo TES - conteudo anterior "+Alltrim(cvaltochar(SC6->C6_TES))+" conteudo atual "+Alltrim(cvaltochar(aCols[nX,nPosTes]))+' - no item '+aCols[nX,nPosItm]+CRLF
			EndIf
			
			If aCols[nX,nPosEnd] <> SC6->C6_LOCALIZ .AND. lAux  = .T.
				Obs	+=	"Alterado campo Localizacao - conteudo anterior "+Alltrim(cvaltochar(C6_LOCALIZ))+" conteudo atual "+Alltrim(cvaltochar(aCols[nX,nPosEnd]))+' - no item '+aCols[nX,nPosItm]+CRLF
			EndIf
			
            If aCols[nX,nPosLot] <> SC6->C6_LOTECTL .AND. lAux  = .T.
				Obs	+=	"Alterado campo Localizacao - conteudo anterior "+Alltrim(cvaltochar(C6_LOTECTL))+" conteudo atual "+Alltrim(cvaltochar(aCols[nX,nPosLot]))+' - no item '+aCols[nX,nPosItm]+CRLF
			EndIf

			If aCols[nX,nPosOpr] <> SC6->C6_OPER .AND. lAux  = .T.
				Obs	+=	"Alterado campo Tp. Operacao - conteudo anterior "+Alltrim(cvaltochar(C6_OPER))+" conteudo atual "+Alltrim(cvaltochar(aCols[nX,nPosOpr]))+' - no item '+aCols[nX,nPosItm]+CRLF
			EndIf
			
			If aCols[nX,nPosLoc] <> SC6->C6_LOCAL .AND. lAux  = .T.
				Obs	+=	"Alterado campo Armazem - conteudo anterior "+Alltrim(cvaltochar(C6_LOCAL))+" conteudo atual "+Alltrim(cvaltochar(aCols[nX,nPosLoc]))+' - no item '+aCols[nX,nPosItm]+CRLF
			EndIf
			
			If aCols[nX,nPosEnt] <> SC6->C6_ENTREG .AND. lAux  = .T.
				Obs	+=	"Alterado campo Entrega - conteudo anterior "+Alltrim(DTOC(C6_ENTREG))+" conteudo atual "+Alltrim(DTOC(aCols[nX,nPosEnt]))+' - no item '+aCols[nX,nPosItm]+CRLF
			EndIf
			
		EndIf
	Next nX		
EndIf

If !Empty(Obs)
    Obs := 'Alteracoes do usuario '+Alltrim(cusername)+' em '+cvaltochar(ddatabase)+' as '+cvaltochar(time())+CRLF+Obs
    M->C5_ZZMETMK := Alltrim(M->C5_ZZMETMK) + ' '+Obs
EndIf

Return lOk




/*/{Protheus.doc} nomeStaticFunction
	(long_description)
	@type  Static Function
	@author user
	@since date
	@version version
	@param param, param_type, param_descr
	@return return, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function _VlrImp(cPedido)

Local aArea	:=	GetArea()
Local aRet  :=  {}
Local nTotVal := 0
//Local cUFDest	:=	Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST")

DbSelectArea("SC5")
DbSetOrder(1)
If Dbseek(xFilial("SC5")+cPedido)
	MaFisIni(SC5->C5_CLIENTE,;                   // 01 - Codigo Cliente/Fornecedor
					SC5->C5_LOJACLI,;                        // 02 - Loja do Cliente/Fornecedor
					Iif(SC5->C5_TIPO $ "D;B", "F", "C"),;    // 03 - C:Cliente , F:Fornecedor
					SC5->C5_TIPO,;                           // 04 - Tipo da NF
					SC5->C5_TIPOCLI,;                        // 05 - Tipo do Cliente/Fornecedor
					MaFisRelImp("MT100", {"SF2", "SD2"}),;   // 06 - Relacao de Impostos que suportados no arquivo
					,;                                       // 07 - Tipo de complemento
					,;                                       // 08 - Permite Incluir Impostos no Rodape .T./.F.
					"SB1",;                                  // 09 - Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
					"MATA461")                               // 10 - Nome da rotina que esta utilizando a funcao
	
	DbSelectArea("SC6")
	DbSetOrder(1)
	Dbseek(SC5->C5_FILIAL+SC5->C5_NUM)

	nItAtu := 0
	nQtdEmb := 0
	nValDesc := 0

	While !EOF() .AND. SC5->C5_FILIAL == SC6->C6_FILIAL .AND. SC5->C5_NUM == SC6->C6_NUM 
		DbselectArea("SB1")
		DbSetOrder(1)
		nItAtu++
		SB1->(DbSeek(FWxFilial("SB1")+SC6->C6_PRODUTO))
		MaFisAdd(SC6->C6_PRODUTO,;    // 01 - Codigo do Produto                    ( Obrigatorio )
			SC6->C6_TES,;             // 02 - Codigo do TES                        ( Opcional )
			SC6->C6_QTDVEN,;          // 03 - Quantidade                           ( Obrigatorio )
			SC6->C6_PRCVEN,;          // 04 - Preco Unitario                       ( Obrigatorio )
			SC6->C6_VALDESC,;         // 05 - Desconto
			SC6->C6_NFORI,;           // 06 - Numero da NF Original                ( Devolucao/Benef )
			SC6->C6_SERIORI,;         // 07 - Serie da NF Original                 ( Devolucao/Benef )
			0,;                           // 08 - RecNo da NF Original no arq SD1/SD2
			0,;                           // 09 - Valor do Frete do Item               ( Opcional )
			0,;                           // 10 - Valor da Despesa do item             ( Opcional )
			0,;                           // 11 - Valor do Seguro do item              ( Opcional )
			0,;                           // 12 - Valor do Frete Autonomo              ( Opcional )
			SC6->C6_VALOR,;           // 13 - Valor da Mercadoria                  ( Obrigatorio )
			0,;                           // 14 - Valor da Embalagem                   ( Opcional )
			SB1->(RecNo()),;              // 15 - RecNo do SB1
			0)                            // 16 - RecNo do SF4
		
		nQtdPeso := SC6->C6_QTDVEN*SB1->B1_PESO
		nQtdEmb	 := nQtdEmb + SC6->C6_UNSVEN
		nValDesc := nValDesc + SC6->C6_VALDESC
		MaFisLoad("IT_VALMERC", SC6->C6_VALOR, nItAtu)				
		MaFisAlt("IT_PESO", nQtdPeso, nItAtu)
		DbSelectArea("SC6")
		Dbskip()
	EndDo 

	//Altera dados da Nota
	MaFisAlt("NF_FRETE", SC5->C5_FRETE)
	MaFisAlt("NF_SEGURO", SC5->C5_SEGURO)
	MaFisAlt("NF_DESPESA", SC5->C5_DESPESA) 
	MaFisAlt("NF_AUTONOMO", SC5->C5_FRETAUT)
	If SC5->C5_DESCONT > 0
		MaFisAlt("NF_DESCONTO", Min(MaFisRet(, "NF_VALMERC")-0.01, SC5->C5_DESCONT+MaFisRet(, "NF_DESCONTO")) )
	EndIf
	If SC5->C5_PDESCAB > 0
		MaFisAlt("NF_DESCONTO", A410Arred(MaFisRet(, "NF_VALMERC")*SC5->C5_PDESCAB/100, "C6_VALOR") + MaFisRet(, "NF_DESCONTO"))
	EndIf

	nItAtu := 0
	nTotalST := 0
	nTotIPI := 0
	nBasICM := 0
	nValICM := 0

	DbSelectArea("SC6")
	DbSetOrder(1)
	Dbseek(SC5->C5_FILIAL+SC5->C5_NUM)
	While !EOF() .AND. SC5->C5_FILIAL == SC6->C6_FILIAL .AND. SC5->C5_NUM == SC6->C6_NUM 
		nItAtu++

		SB1->(DbSeek(FWxFilial("SB1")+SC6->C6_PRODUTO))
				
		//Pega os valores
		nBasICM    += MaFisRet(nItAtu, "IT_BASEICM") 
		nValICM    += MaFisRet(nItAtu, "IT_VALICM")
		nValIPI    := MaFisRet(nItAtu, "IT_VALIPI")
		nAlqICM    := MaFisRet(nItAtu, "IT_ALIQICM")
		nAlqIPI    := MaFisRet(nItAtu, "IT_ALIQIPI")
		nValSol    := (MaFisRet(nItAtu, "IT_VALSOL") / SC6->C6_QTDVEN) 
		nBasSol    := MaFisRet(nItAtu, "IT_BASESOL")
		
		/*If Alltrim(cUFDest) == "MG"
			If Posicione("SF4",1,xFilial("SF4")+SC6->C6_TES,"F4_ISEFEMG") == "2"
				nVlrFCP    := MaFisRef(nItAtu, "IT_VALFECP") //IT_VFECPST
			ELSE
				nVlrFCP    := 0
			ENDIF 
		Else*/
			nVlrFCP    := 0
		//Endif 
		
		nPrcUniSol := SC6->C6_PRCVEN + nValSol
		nTotSol    := nPrcUniSol * SC6->C6_QTDVEN
		nTotalST   := MaFisRet(nItAtu, "IT_VALSOL")
		nTotIPI    := nValIPI

		Aadd(aRet,{SC6->C6_ITEM,nTotalST,nTotIPI,nVlrFCP})
		DbSelectArea("SC6")
		dbskip()
	EndDo
	
	nTotVal := MaFisRet(, "NF_TOTAL") + MaFisRet(, "NF_DESCONTO")
	nVlFcp := MaFisRet(, "NF_VFECPST")
	Aadd(aRet,{'9999',nTotVal,0,nVlFcp})
	MaFisEnd()
	
ENDIF

RestArea(aAreA)

Return(aRet)
/*
		rotina para ajustar cabeçalho do pedido com valor total
		e impostos
		feito para tratar os relatorios do khaled
*/
User function xajuspv

Local aArea	:=	GetArea()
Local oProcess   := Nil

If Empty(FunName())
	RpcSetType(3)
    RPCSetEnv("02","01")
EndIf	

If alltrim(UPPER(cusername)) $ 'ADMINISTRADOR'
	oProcess := MsNewProcess():New({|| fMontaRel(@oProcess) }, "Ajustando os Pedidos de Venda", "Processando", .F.)
	oProcess:Activate()
else
	MsgAlert("Somente o usuário admin tem permissão para executar esta rotina")

EndIf


RestArea(aArea)

Return

/*/{Protheus.doc} fMontaRel
	(long_description)
	@type  Static Function
	@author user
	@since 03/06/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function fMontaRel(oProc)

Local aArea	:=	GetArea()	
Local aImpost 	:=	{}

DbSelectArea("SC5")
DbGotop()

Count To nTotPed
oProc:SetRegua1(nTotPed)

DbGotop()

While !EOF()
	aAreaC5 := GetArea()
	aImpost := {}
	oProc:IncRegua1("Processando o pedido "+SC5->C5_NUM+" ...")
	oProc:SetRegua2(1)
	oProc:IncRegua2("...")
	
	aImpost := _VlrImp(SC5->C5_NUM)
	RestArea(aAreaC5)
	DbSelectArea("SC6")
	DbSetOrder(1)
	DbSeek(SC5->C5_FILIAL+SC5->C5_NUM)
	While !EOF() .AND. SC5->C5_FILIAL == SC6->C6_FILIAL .AND. SC5->C5_NUM == SC6->C6_NUM
		//aRet,{nTotalST,nTotIPI,nVlrFCP,nTotVal
		nPos := Ascan(aImpost,{|x| Alltrim(x[1]) == Alltrim(SC6->C6_ITEM)})
		If nPos > 0
			RecLock("SC6", .F.)
			SC6->C6_XVLIMP1 := aImpost[nPos,02]
			SC6->C6_XVLIMP2 := aImpost[nPos,03]
			SC6->C6_XVLIMP3 := aImpost[nPos,04]
			SC6->(MsUnlock())
		endif
		Dbskip()
	EndDo 	

	nPosCab := Ascan(aImpost,{|x| Alltrim(x[1]) == '9999'})
	If nPosCab > 0
		Reclock("SC5",.F.)
		SC5->C5_XTOTNF := aImpost[nPosCab,02]
		SC5->C5_XTOTFCP:= aImpost[nPosCab,04]
		SC5->(MsUnlock())
	EndIf
	DbSelectArea("SC5")
	Dbskip()
EndDo 

RestArea(aArea)

Return
