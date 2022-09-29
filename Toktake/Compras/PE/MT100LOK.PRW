/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MT100LOK ³ Autor ³ Artur Nucci Ferrari   ³ Data ³ 01/05/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ponto de entrada para atualizar os itens da Producao       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#include 'rwmake.ch'

User Function MT100LOK()

Local lRet 		:= .T.
Local clAtEst   :=""

//Local clFin
//Local clCod		:= aCols[n,	aScan(aHeader, {|_1| Upper(alltrim(_1[2])) == "D1_TES"})]
Local cTESPC    := If(cEmpAnt == "01",AllTrim(SuperGetMv("MV_XNFENPC")),"")
Local cRegraTes := If(cEmpAnt == "01",AllTrim(SuperGetMv("MV_XF4RCCE")),"")
Local cProd  	:= aCols[n,	aScan(aHeader, {|_1| Upper(alltrim(_1[2])) == "D1_COD"})]
Local cTes  	:= aCols[n,	aScan(aHeader, {|_1| Upper(alltrim(_1[2])) == "D1_TES"})]
Local cltipo	:= CTIPO //aCols[n,	aScan(aHeader, {|_1| Upper(alltrim(_1[2])) == "D1_TIPO"})]
Local nlDiv		:= If(cEmpAnt == "01",if(aScan(aHeader, {|_1| Upper(alltrim(_1[2])) == "D1_XCLASPN"})>0,aCols[n,	aScan(aHeader, {|_1| Upper(alltrim(_1[2])) == "D1_XCLASPN"})],0),"")
Local cconta	:= aCols[n, aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "D1_CONTA"})]
Local ccc    	:= aCols[n, aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "D1_CC"})]
Local cItCt    	:= aCols[n, aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "D1_ITEMCTA"})]
Local cRateio   := aCols[n, aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "D1_RATEIO"})] 
Local cLocNf	:= aCols[n, aScan(aHeader, {|_1| Upper(Alltrim(_1[2])) == "D1_LOCAL"})]

Local cPedido	:= aCols[n, aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == 'D1_PEDIDO'})]
Local nItem     := aCols[n, aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == 'D1_ITEMPC'})]

Local cB1PIS     := If(cEmpAnt == "01",GetAdvFval("SB1","B1_XPISCOF" ,xFilial("SB1")+cProd,1),"")
Local cNCM       := GetAdvFval("SB1","B1_POSIPI" ,xFilial("SB1")+cProd,1)
Local cF4PIS     := GetAdvFval("SF4","F4_PISCOF" ,xFilial("SF4")+cTes,1)
Local cF4DUP     := GetAdvFval("SF4","F4_DUPLIC" ,xFilial("SF4")+cTes,1)
Local cF4Regra   := GetAdvFval("SF4","F4_REGRA" ,xFilial("SF4")+cTes,1)

Local cUserLib  := Upper(AllTrim(cusername))
Local cCADVIP   := If(cEmpAnt == "01",AllTrim(SuperGetMv("MV_XNFESPC")),"")

// Alteracao para atender o item 151 da lista de pendencias
//Compensar um titulo a receber do cliente com o titulo referente a devolução.  Alexandre 24/08/2012

Local cNfOri    	:= aCols[n, aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "D1_NFORI"})]
Local cSeriOri    	:= aCols[n, aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "D1_SERIORI"})]
/*       verificar
If cTipo == "D" .and. cFormul == "S"
	If Empty(Posicione("SF2",1,xFilial("SF2")+cNfOri+cSeriOri,"F2_DOC"))
		MsgAlert("Nota Fiscal de Origem não encontrada","MT100LOK")
		lRet:= .F.
		Return(lRet)
	EndIf
EndIf
*/
//Final alteracao item 151 da lista de pendencias.       

If cEmpAnt == "01"     
	//Alteração para nao finalizar mais a pre-nota com o armazem d00018
	If ALTERA .And. cLocNf == "D00018"
		aCols[n, aScan(aHeader, {|_1| Upper(Alltrim(_1[2])) == "D1_LOCAL"})] := Posicione("SB1",1,xFilial("SB1")+cProd,"B1_LOCPAD")
	EndIf
	
	If cltipo=="N"
		IF !(cUserLib$(cCADVIP))
			If cF4DUP=="S"
				If Empty(cPedido)
					MsgStop("Informe o Pedido de Compras de Origem.", "NFE")
					lRet := .F.
					Return(lRet)
				Endif
				If Empty(nItem)
					MsgStop("Informe o Item do Pedido de Compras de Origem.", "NFE")
					lRet := .F.
					Return(lRet)
				End
			End
		End
	End
	
	If Empty(cNCM)
		MsgInfo("Este produto não tem o NCM cadastrado. Faça a alteração pelo cadastro de produtos.","ATENÇÃO!!!")
		lRet := .F.
		Return(lRet)
	End
EndIF

If SM0->M0_CODIGO=='01' //.OR. SM0->M0_CODIGO=='05' .OR. SM0->M0_CODIGO=='11'
	If !(cTes$(cTESPC))
		If cF4DUP=='S'
			If cF4PIS=='4' .AND. cB1PIS=='S'
				MsgInfo("Este produto tem crédito de PIS/COFINS, e a TES não credita. Altere para uma TES com crédito de PIS/COFINS.","ATENÇÃO!!!")
				lRet := .F.
				Return(lRet)
			End
			
			If cF4PIS=='3' .AND. cB1PIS=='N'
				MsgInfo("Este produto não tem crédito de PIS/COFINS, e a TES está creditando. Altere para uma TES sem crédito de PIS/COFINS.","ATENÇÃO!!!")
				lRet := .F.
				Return(lRet)
			End
			
			If Empty(cB1PIS)
				MsgInfo("Este produto está sem a configuração de crédito de PIS/COFINS, procure o Depto. Fiscal.","ATENÇÃO!!!")
				lRet := .F.
				Return(lRet)
			End
		End
	End
	//	If cF4DUP=='S' .AND. Empty(cCC)
	//	If Empty(cconta)
	//		MsgInfo("A Conta Contábil não está preenchida, procure o Depto. de Contabilidade.","ATENÇÃO!!!")
	//		lRet := .F.
	//		Return(lRet)
	//	End
	
	If cRateio<>'1'
		If (cF4Regra$cRegraTes)     
			If type("CUFORIG") == "U"
				If Empty(cCC) //   notas de despesa de importacao nao tem este campo habilitado .AND. M->CUFORIG <>'EX' //SF1->F1_EST<>'EX' Alterado para fazer a validação correta - 27/01/2012 Alexandre
					MsgInfo("Esta TES exige o uso do Centro de Custo, favor preencher.","ATENÇÃO!!!")
					lRet := .F.
					Return(lRet)
				End
			Else
				If Empty(cCC) .AND. M->CUFORIG <>'EX' //SF1->F1_EST<>'EX' Alterado para fazer a validação correta - 27/01/2012 Alexandre
					MsgInfo("Esta TES exige o uso do Centro de Custo, favor preencher.","ATENÇÃO!!!")
					lRet := .F.
					Return(lRet)
				End
			EndIf			
		End
		//If !(SubStr(cConta,1,1)$'1#2')
		//	If SF1->F1_XTRANSF = ""
		//		If Empty(cCC)
		//			MsgInfo("Esta TES exige o uso do Centro de Custo, favor preencher.","ATENÇÃO!!!")
		//			lRet := .F.
		//			Return(lRet)
		//		End
		//	EndIf
		//End
		//	If SubStr(cCC,1,1)='7' .AND. Empty(cItCt)
		//		MsgInfo("Centros de Custo que iniciam com [7] devem ter o Item Contábil preenchido.","ATENÇÃO!!!")
		//		lRet := .F.
		//		Return(lRet)
		//	End
		If SubStr(cCC,1,2)='03' .AND. Empty(cItCt)
			MsgInfo("Centros de Custo que iniciam com [03] devem ter o Item Contábil preenchido.","ATENÇÃO!!!")
			lRet := .F.
			Return(lRet)
		End
	End
End



/*--------------------------------------------------------------------------------------------------------------------&&
&&Código ultilizado para não deixar o campo da qtde da pre nota vazio na classificação  da nota de entrada            &&
&&--------------------------------------------------------------------------------------------------------------------&&
&&Autor------------------------->>Ricardo Souza|Data------------------------------------------->>08/10/2010------------&&
&&--------------------------------------------------------------------------------------------------------------------*/
If cEmpAnt == "01"
	DbSelectArea("SF4")
	If DbSeek(Xfilial("SF4")+ cTes)
		clAtEst:=SF4->F4_ESTOQUE
	EndIf
	If 	GetMv("MV_XDIVNF")==.T.
		If	clTipo=="N"
			If Empty(nlDiv)
				Aviso("Alerta","O campo da qtde física é obrigatório, preencha-o com a qtde física do produto ",{"OK"},1)
				lRet:=.F.
				Return(lRet)
			EndIf
		EndIf
	EndIf
	
	//------------------------------>>Termina aquir o codigo incrementado por Ricardo Souza<<-------------------------------&&
EndIF
Return(lRet)
