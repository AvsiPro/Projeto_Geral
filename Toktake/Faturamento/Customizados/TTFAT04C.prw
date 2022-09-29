
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTFAT04C  ºAutor  ³Jackson E. de Deus  º Data ³  08/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Desenvolvido com base no TTFATG10 de Alexandre Venancio    º±±
±±º          ³ Atualiza Peso Liq. e Bruto com base em todos os itens      º±±
±±º			 ³ Projeto: 97 - Cálculo Peso na digitação do PV			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TTFAT04C() 

Local aArea		:=	GetArea()
Local nPosP		:=	Ascan(aHeader,{|x| x[2] = "C6_PRODUTO"})
Local nPosQtd	:=	Ascan(aHeader,{|x| x[2] = "C6_QTDVEN"}) 
Local cPBr		:=	0
Local cPLq		:=	0                                           
Local nI
Local nJ
Local lIsIN		:= .F.  
Local _cProd
Local _nQtdVen
Local aFuncs	:= {}
Local cFuncoes	:= SuperGetMV("MV_XNOFUNC",.F.,"")

// Atualiza Peso Liquido e Peso Bruto no cabeçalho
If Len(aCols) >= 1
	
	// Zera valores dos campos de peso bruto no cabeçalho
	M->C5_PESOL := 0
	M->C5_PBRUTO := 0
	
	// Atualiza valores
	For nI := 1 To Len(aCols)
		If !aCols[nI][Len(aHeader)+1]             
		
			_cProd := aCols[nI][nPosP]		// Produto
			_nQtdVen := aCols[nI][nPosQtd]	// Qtd
			
			cPesL	:=	Posicione("SB1",1,xFilial("SB1")+Acols[nI,nPosP],"B1_PESO")		// Peso Liquido
			cPesB	:=	Posicione("SB1",1,xFilial("SB1")+Acols[nI,nPosP],"B1_PESBRU")	// Peso Bruto
			cConv	:=	Posicione("SB1",1,xFilial("SB1")+Acols[nI,nPosP],"B1_CONV")		// Fat. Conversao
			cUndP	:=	Posicione("SB1",1,xFilial("SB1")+Acols[nI,nPosP],"B1_UM")		// Unidade de Medida
		
			//If cUndP == "CX"
			//	cPBr := (_nQtdVen / cConv) * cPesB
			//	cPLq := (_nQtdVen / cConv) * cPesL
			//Else
				cPBr := _nQtdVen * cPesB
				cPLq := _nQtdven * cPesL
			//EndIf
			
			M->C5_PESOL 	+=	cPLq
			M->C5_PBRUTO	+=	cPBr
			
		EndIf
	Next nI
EndIf    

      
// Refresh para atualizar o valor dos campos de peso no cabeçalho
// Verifica pilha de execução
aFuncs := STRTOKARR(cFuncoes,"#")
For nJ := 1 To Len(aFuncs)
	If IsInCallStack(aFuncs[nJ]) 
		lIsIN := .T.
	EndIf
Next nJ

// Se não estiver existir nenhuma função de exceção na pilha, atualiza o peso bruto
If !lIsIN
	oGetDad:oBrowse:Refresh() 
	GetDRefresh()  
EndIf


RestArea(aArea)

Return