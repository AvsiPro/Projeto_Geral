#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH" 

User Function MT410TOK()

Local _nX       := 0
Local _nOPC     := PARAMIXB[1]
Local nPosTOT   := ASCAN(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})
Local nPosQTD   := ASCAN(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
Local nPosDSC   := ASCAN(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"})
Local _nTotQTD  := 0
Local _nTotVAL  := 0
Local _nTotDSC  := 0

Local lRet      := .T.

Default _PMantLiB := .F.

If _nOPC == 3 //.OR. _nOPC == 4 //3=Inclusão / 4=Alteração
    For _nX := 1 To LEN(aCols)
        _nTotQTD += aCols[_nX][nPosQTD]
        _nTotVAL += aCols[_nX][nPosTOT]
        _nTotDSC += aCols[_nX][nPosDSC]
    Next _nX

	M->C5_XQUANT    := _nTotQTD
	M->C5_XTOTAL    := _nTotVAL
	M->C5_XTOTDES   := _nTotDSC
EndIf


If _nOPC == 4 .And. _PMantLiB
    nPosItm := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_ITEM" })
    nPosLib := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDLIB" })
	nPosPrd := Ascan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO" })
	

    SC9->(DbSetOrder(2))
	SC6->(DbSetOrder(1))
	For _nX := 1 To Len(aCols)
		lTrcPrd := .F.
		SC6->(DbSeek(xFilial("SC6")+M->C5_NUM+aCols[_nX,nPosItm]))
		If SC6->C6_PRODUTO <> aCols[_nX,nPosPrd]
			lTrcPrd := .T.
		EndIf 
		If SC9->(DbSeek(xFilial('SC9')+M->C5_CLIENTE+M->C5_LOJACLI+M->C5_NUM+aCols[_nX,nPosItm]))
			IF lTrcPrd
				A460Estorna(.T.)
			EndIf 
			aCols[_nX,nPosLib] := SC9->C9_QTDLIB
		EndIf
	Next _nX

	_PMantLiB := .F.
EndIf

//Faz a chamada na static function para gerar o log de alteração Cabeçalho Pedidos de venda 
Processa({||LogSC5() },,,)

//Faz a chamada na static function para gerar o log de alteração Itens Pedidos de venda 
Processa({||LogSC6() },,,)

Return lRet


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±º Ponto de Entrada 	 Alexandre Venancio - AVSIPRO        Data: 08/01/2020	  º±±
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
			//ROBGEN11(xFil,Modulo,TipoMov,Prefixo,Docto,Serie,UserMov,DiaMov,HoraMov,Valor,Obs,cCli,cLoja,cTabela)
			xFil 	:= xFilial("SC5")
			Modulo 	:= "Cabecalho Ped. Venda"
			TipoMov := "Alteracao"
			Prefixo	:=	""
			Docto	:=	SC5->C5_NUM
			Serie	:=	""
			UserMov	:=	cusername
			DiaMov	:=	ddatabase
			HoraMov	:=	time()
			Valor	:=	0
			Obs		:=	"Alterado campo "+Alltrim(aLogA[nX,01])+" conteudo anterior "+Alltrim(cvaltochar(aLogA[nX,03]))+" conteudo atual "+Alltrim(cvaltochar(aLogA[nX,02]))
			cCli	:=	M->C5_CLIENTE
			cLoja	:=	M->C5_LOJACLI
			cTabela	:=	"SC5" 
			U_ROBGEN11(xFil,Modulo,TipoMov,Prefixo,Docto,Serie,UserMov,DiaMov,HoraMov,Valor,Obs,cCli,cLoja,cTabela)
		Next nX
	EndIF
	
EndIf

Return(lRet)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±º Ponto de Entrada 	 Alexandre Venancio - AVSIPRO        Data: 08/01/2020	  º±±
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
Local c6num 	:= ''
Local lAux  	:= .T.
Local nX

If Altera

	c6num := M->C5_NUM
	
	DBSelectArea("SC6")
	DbSetOrder(1)
	For nX := 1 to len(aCols)
		If DbSeek(xFilial("SC6")+c6num+aCols[nX,nPosItm])
						
			xFil 	:= xFilial("SC6")
			Modulo 	:= "Itens Ped. Venda"
			TipoMov := "Alteracao"
			Prefixo	:=	""
			Docto	:=	SC6->C6_NUM
			Serie	:=	""
			UserMov	:=	cusername
			DiaMov	:=	ddatabase
			HoraMov	:=	time()
			Valor	:=	0
			cCli	:=	M->C5_CLIENTE
			cLoja	:=	M->C5_LOJACLI
			cTabela	:=	"SC6" 
		
			If aCols[nX,nPosPrd] <> SC6->C6_PRODUTO
				Obs	:=	"Alterado campo Produto - conteudo anterior "+Alltrim(SC6->C6_PRODUTO)+" conteudo atual "+Alltrim(aCols[nX,nPosPrd])+' - no item '+aCols[nX,nPosItm]
				U_ROBGEN11(xFil,Modulo,TipoMov,Prefixo,Docto,Serie,UserMov,DiaMov,HoraMov,Valor,Obs,cCli,cLoja,cTabela)
				lAux := .F.
			EndIF
			
			If aCols[nX,nPosQtd] <> SC6->C6_QTDVEN .AND. lAux  = .T.
				Obs	:=	"Alterado campo Quantidade - conteudo anterior "+Alltrim(cvaltochar(SC6->C6_QTDVEN))+" conteudo atual "+Alltrim(cvaltochar(aCols[nX,nPosQtd]))+' - no item '+aCols[nX,nPosItm]
				U_ROBGEN11(xFil,Modulo,TipoMov,Prefixo,Docto,Serie,UserMov,DiaMov,HoraMov,Valor,Obs,cCli,cLoja,cTabela)
			EndIF
			
			If aCols[nX,nPosVlr] <> SC6->C6_PRCVEN .AND. lAux  = .T.
				Obs	:=	"Alterado campo Valor Unitario - conteudo anterior "+Alltrim(cvaltochar(SC6->C6_PRCVEN))+" conteudo atual "+Alltrim(cvaltochar(aCols[nX,nPosVlr]))+' - no item '+aCols[nX,nPosItm]
				U_ROBGEN11(xFil,Modulo,TipoMov,Prefixo,Docto,Serie,UserMov,DiaMov,HoraMov,Valor,Obs,cCli,cLoja,cTabela)
			EndIf
			
			If aCols[nX,nPosTes] <> SC6->C6_TES .AND. lAux  = .T.
				Obs	:=	"Alterado campo TES - conteudo anterior "+Alltrim(cvaltochar(SC6->C6_TES))+" conteudo atual "+Alltrim(cvaltochar(aCols[nX,nPosTes]))+' - no item '+aCols[nX,nPosItm]
				U_ROBGEN11(xFil,Modulo,TipoMov,Prefixo,Docto,Serie,UserMov,DiaMov,HoraMov,Valor,Obs,cCli,cLoja,cTabela)
			EndIf
			
			If aCols[nX,nPosOpr] <> SC6->C6_OPER .AND. lAux  = .T.
				Obs	:=	"Alterado campo Tp. Operacao - conteudo anterior "+Alltrim(cvaltochar(C6_OPER))+" conteudo atual "+Alltrim(cvaltochar(aCols[nX,nPosOpr]))+' - no item '+aCols[nX,nPosItm]
				U_ROBGEN11(xFil,Modulo,TipoMov,Prefixo,Docto,Serie,UserMov,DiaMov,HoraMov,Valor,Obs,cCli,cLoja,cTabela)
			EndIf
			
			If aCols[nX,nPosLoc] <> SC6->C6_LOCAL .AND. lAux  = .T.
				Obs	:=	"Alterado campo Armazem - conteudo anterior "+Alltrim(cvaltochar(C6_LOCAL))+" conteudo atual "+Alltrim(cvaltochar(aCols[nX,nPosLoc]))+' - no item '+aCols[nX,nPosItm]
				U_ROBGEN11(xFil,Modulo,TipoMov,Prefixo,Docto,Serie,UserMov,DiaMov,HoraMov,Valor,Obs,cCli,cLoja,cTabela)
			EndIf
			
			If aCols[nX,nPosEnt] <> SC6->C6_ENTREG .AND. lAux  = .T.
				Obs	:=	"Alterado campo Entrega - conteudo anterior "+Alltrim(DTOC(C6_ENTREG))+" conteudo atual "+Alltrim(DTOC(aCols[nX,nPosEnt]))+' - no item '+aCols[nX,nPosItm]
				U_ROBGEN11(xFil,Modulo,TipoMov,Prefixo,Docto,Serie,UserMov,DiaMov,HoraMov,Valor,Obs,cCli,cLoja,cTabela)
			EndIf
			
		EndIf
	Next nX		
EndIf

Return lOk
