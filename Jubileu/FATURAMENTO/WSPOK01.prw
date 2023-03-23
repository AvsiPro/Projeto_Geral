#INCLUDE "PROTHEUS.CH"
#INCLUDE "PARMTYPE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "AP5MAIL.CH"

#DEFINE CRLF CHR(13)+CHR(10)

/*/{Protheus.doc} WSPOK01
	author: Felipe Mayer - AVSI
	descri: Chama as API's para as representadas, roda uma representada por vez
	client: Jubileu
	date  : 21/01/2021
/*/

User Function WSPOK01()

	Private aPedOk  := {}
	Private aParc	  := {}
	Private cTokParc
	Private cTokPedOk
	Private cTokenPar
	Private cTokenPok
	//Private lpasta := .F.

	If Empty(FunName())
		RpcSetType(3)
		RPCSetEnv("01","0201")
	EndIf

	cTokPedOk := GetMv("MV_TOKPEOK")
	cTokParc  := GetMv("MV_TOKPARC")

	aPedOk := StrTokArr(cTokPedOk,",")
	aParc  := StrTokArr(cTokParc,",")
	Processa({||gerar() },"PedidosOK","Aguarde Processando",.F.)

return

Static Function Gerar()

	Local cFile := "c:\0\pedidook.txt"
	Local aAux  := {}
	Local nCont
	Local nX 	  := 0
	Local lDtPV := .F.

	aList1 := {}
	aList2B := {}
	aList3 := {}
	aList4 := {}

	Private nHandle	:=	FT_FUse(cFile)

	If nHandle > 0
		While !FT_FEOF()
			cLine	:= FT_FReadLn()
			Aadd(aAux,alltrim(cLine))
			FT_FSKIP()
		End
	EndIf

	For nX := 1 To Len(aPedOk)

		lDtPV := Iif(Len(aPedOk)==nX,.T.,.F.)
		cTokenPok	:=	aPedOk[nX]
		cTokenPar	:=	IF(len(aParc) > 1,aParc[nX],aParc[1])
		//u_WSPOK02(aPedOk[nX],IF (len(aParc) > 1,aParc[nX],aParc[1]),lDtPV) //chama representada 1=Ultrafarma / 2=OticasCarol para GET tabela de *****PRODUTOS*****
		//u_WSPOK03(cTokenPok,cTokenPar,lDtPV,"") //chama representada 1=Ultrafarma / 2=OticasCarol para GET tabela de *****CLIENTES*****
		If len(aAux) > 0
			For nCont := 1 to len(aAux)
				u_WSPOK04(cTokenPok,cTokenPar,lDtPV,aAux[nCont])
			Next nCont
		Else
			//lpasta := .T.
			u_WSPOK04(cTokenPok,cTokenPar,lDtPV,"") //chama representada 1=Ultrafarma / 2=OticasCarol para GET tabela de *****PEDIDOS*****
		EndIf
	Next nX

	oList1:SetArray(aList1)
	oList1:bLine := {||{ If(aList1[oList1:nAt,05],oOk,oNo),;
		aList1[oList1:nAt,01],;
		aList1[oList1:nAt,02],;
		aList1[oList1:nAt,03],;
		aList1[oList1:nAt,04]}}
	oList1:refresh()

	oDlg1:refresh()

Return

/*/{Protheus.doc} WSPOK02
	author: Felipe Mayer - AVSI
	descri: GET tabela de produtos para importacao - PedidoOk X Protheus
	client: Jubileu
	date  : 21/01/2021
/*/

User Function WSPOK02(cTokenPok,cTokenPar,lDtPV,cCodPro)

	Local lAtuDt		:= .T.
	Local OlRestCli 	:= Nil
	Local oJsonIM		:= Nil
	Local oProd			:= {}
	Local cRet 			:= ""
	Private aHeadProd 	:= {}
	Private nPgProd		:= 1
	Private cDtAtPrd
	Default cCodPro 	:= ""

	slURLHost	:= "https://api.pedidook.com.br"
	cDtAtPrd	:= GetMv("MV_XDTPROD")

	//clPathPrd	:= "/v1/produtos/?alterado_apos="+cDtAtPrd+"&excluido=false&pagina="+cValToChar(nPgProd)+If(!Empty(cCodPro),"&codigo="+cCodPro,"")
	If Empty(cCodPro)
		clPathPrd	:= "/v1/produtos/?excluido=false&pagina="+cValToChar(nPgProd)+If(!Empty(cCodPro),"&id="+CVALTOCHAR(cCodPro),"")
	Else
		clPathPrd	:= "/v1/produtos/"+CVALTOCHAR(cCodPro)
	EndIF

	OlRestCli	:= FWRest():New(slURLHost)

	Aadd(aHeadProd, "Content-type:application/json")
	Aadd(aHeadProd, "token_parceiro: "+cTokenPar)
	Aadd(aHeadProd, "token_pedidook: "+cTokenPok)

	OlRestCli:setPath(clPathPrd)

	If OlRestCli:GET(aHeadProd)
		cResPrd := OlRestCli:GetResult()

		If FWJsonDeserialize(cResPrd,@oJsonIM)
			oProd := oJsonIM:produto
			If valtype(oProd) == "O" //> 0
				cRet := fGeraProd(oProd)
			Else
				lAtuDt := .F.
			EndIf
		EndIf
	Else
		cResPrd := "Falha na Requisição : " + Alltrim(OlRestCli:GetLastError())
	EndIf

	If lAtuDt .And. lDtPV
		cDate := Year2Str(date())+"-"+Month2Str(date())+"-"+Day2Str(date())+"T"+Time()+".00"
		PutMv("MV_XDTPROD",cDate)
	EndIf

Return(cRet)

Static Function fGeraProd(oProd)

	// Local nX 	 := 0
	Local cGrupo := ''
	Local cCodRet := ''

	DbselectArea('SB1')
	DbSetOrder(14)

	//For nX := 1 To Len(oProd)
	cProd  := StrTran(oProd:CODIGO," ","")
	cGrupo := Iif(oProd:CATEGORIA != Nil,Posicione('SBM',2,xFilial('SBM')+oProd:CATEGORIA,'BM_GRUPO'),'')
	cCodRet := cProd

	If !SB1->(Dbseek(xFilial("SB1")+cValToChar(oProd:ID)))
		Reclock('SB1',.T.)
		SB1->B1_FILIAL := xFilial("SB1")
		SB1->B1_COD    := cProd
		SB1->B1_DESC   := fLimpCarac(Iif(oProd:NOME != Nil,oProd:NOME,""),.F.)
		SB1->B1_UM 	   := "UN"'
		SB1->B1_POSIPI := Iif(oProd:NCM != Nil,StrTran(oProd:NCM," ",""),"")
		SB1->B1_TIPO   := "ME"'
		SB1->B1_LOCPAD := '01'
		SB1->B1_CODBAR := Iif(oProd:CODIGO_BARRA != Nil,StrTran(oProd:CODIGO_BARRA," ",""),"")
		SB1->B1_GRUPO  := Alltrim(cGrupo)
		SB1->B1_XIDPOK	:= oProd:ID
		SB1->B1_PRV1	:= Iif(oProd:VENDA != Nil,oProd:VENDA,"")
		SB1->B1_DESBSE3 := Iif(oProd:REFERENCIA != Nil,oProd:REFERENCIA,"")
		//SB1->B1_BASE3	:=	Iif(oProd[nX]:CATEGORIA != Nil,oProd[nX]:CATEGORIA,"")
		SB1->B1_FABRIC	:=	Iif(oProd:MARCA != Nil,oProd:MARCA,"")
		SB1->B1_ORIGEM	:=	"0"
		SB1->B1_GRTRIB  := "001"

		Msunlock()

	Else
		Reclock('SB1',.F.)
		SB1->B1_DESC   := fLimpCarac(Iif(oProd:NOME != Nil,oProd:NOME,""),.F.)
		SB1->B1_POSIPI := Iif(oProd:NCM != Nil,StrTran(oProd:NCM," ",""),"")
		SB1->B1_CODBAR := Iif(oProd:CODIGO_BARRA != Nil,StrTran(oProd:CODIGO_BARRA," ",""),"")
		SB1->B1_GRUPO  := Alltrim(cGrupo)
		SB1->B1_GRTRIB := "001"
		Msunlock()
	EndIf
	//Next nX

	nPgProd++
	//fLoopPrd()

Return(cCodRet)

// Static Function fLoopPrd()

// 	Local OlRestCli 	:= Nil
// 	Local oJsonIM		:= Nil
// 	Local oProd			:= {}

// 	clPathPrd	:= "/v1/produtos/?alterado_apos="+cDtAtPrd+"&excluido=false&pagina="+cValToChar(nPgProd)
// 	OlRestCli := FWRest():New(slURLHost)

// 	OlRestCli:setPath(clPathPrd)

// 	If OlRestCli:GET(aHeadProd)
// 		cResCli := OlRestCli:GetResult()

// 		If FWJsonDeserialize(cResCli,@oJsonIM)
// 			oProd := oJsonIM:produtos
// 			If Len(oProd) > 0
// 				fGeraProd(oProd)
// 			EndIf
// 		EndIf
// 	Else
// 		cResCli := "Falha na Requisição : " + Alltrim(OlRestCli:GetLastError())
// 	EndIf

// Return

/*/{Protheus.doc} WSPOK03
	author: Felipe Mayer - AVSI
	descri: GET tabela de clientes para importacao - PedidoOk X Protheus
	client: Jubileu
	date  : 21/01/2021
/*/

User Function WSPOK03(cTokenPok,cTokenPar,lDtPV,cCodPOK,cVend)

	Local lAtuDt		:= .T.
	Local OlRestCli 	:= Nil
	Local oJsonIM		:= Nil
	Local oCli			:= {}
	Local cRet			:= ""
	Private aHeadCli 	:= {}
	Private nPgCli		:= 1
	Default cCodPOK		:= ""

	slURLHost	:= "https://api.pedidook.com.br"
	//cDtAtCli	:= GetMv("MV_XDTCLIE")

	//clPathCli	:= "/v1/clientes/?alterado_apos="+cDtAtCli+"&excluido=false&pagina="+cValToChar(nPgCli)+If(!Empty(cCodPOK),"&codigo="+cCodPOK,"")
	//clPathCli	:= "/v1/clientes/?excluido=false&pagina="+cValToChar(nPgCli)+If(!Empty(cCodPOK),"&codigo="+cCodPOK,"")
	clPathCli	:= "/v1/clientes/"+CVALTOCHAR(cCodPOk)
	OlRestCli   := FWRest():New(slURLHost)

	Aadd(aHeadCli, "Content-type:application/json")
	Aadd(aHeadCli, "token_parceiro: "+cTokenPar)
	Aadd(aHeadCli, "token_pedidook: "+cTokenPok)

	OlRestCli:setPath(clPathCli)

	If OlRestCli:GET(aHeadCli)
		cResCli := OlRestCli:GetResult()

		If FWJsonDeserialize(cResCli,@oJsonIM)
			oCli := oJsonIM:cliente
			If oCli > 0
				cRet := fGeraCli(oCli,cCodPOK,cVend)
			Else
				lAtuDt := .F.
			EndIf
		EndIf
	Else
		cResCli := "Falha na Requisição : " + Alltrim(OlRestCli:GetLastError())
	EndIf

	If lAtuDt .And. lDtPV
		cDate := Year2Str(date())+"-"+Month2Str(date())+"-"+Day2Str(date())+"T"+Time()+".00"
		PutMv("MV_XDTCLIE",cDate)
	EndIf
Return(cRet)

User Function WSPOK05(cTokenPok,cTokenPar,cCodPOK,cCliID)

	Local lAtuDt		:= .T.
	Local OlRestVen 	:= Nil
	Local oJsonIM		:= Nil
	Local oVen			:= {}
	Local cRet			:= ""
	Private aHeadVen 	:= {}
	Private nPgVen		:= 1
	Default cCodPOK		:= ""

	slURLHost	:= "https://api.pedidook.com.br"
	//cDtAtVen	:= GetMv("MV_XDTVenE")

	//clPathVen	:= "/v1/vendedores/?alterado_apos="+cDtAtVen+"&excluido=false&pagina="+cValToChar(nPgVen)+If(!Empty(cCodPOK),"&codigo="+cCodPOK,"")
	//clPathVen	:= "/v1/vendedores/?excluido=false&pagina="+cValToChar(nPgVen)+If(!Empty(cCodPOK),"&codigo="+cCodPOK,"")
	clPathVen	:= "/v1/vendedores/"+CVALTOCHAR(cCodPOK)
	OlRestVen   := FWRest():New(slURLHost)

	Aadd(aHeadVen, "Content-type:application/json")
	Aadd(aHeadVen, "token_parceiro: "+cTokenPar)
	Aadd(aHeadVen, "token_pedidook: "+cTokenPok)

	OlRestVen:setPath(clPathVen)

	If OlRestVen:GET(aHeadVen)
		cResVen := OlRestVen:GetResult()

		If FWJsonDeserialize(cResVen,@oJsonIM)
			oVen := oJsonIM:vendedor
			If oVen > 0
				cRet := fGeraVen(oVen,cCodPOK,cCliID)
			Else
				lAtuDt := .F.
			EndIf
		EndIf
	Else
		cResVen := "Falha na Requisição : " + Alltrim(OlRestVen:GetLastError())
	EndIf

Return(cRet)

Static Function fGeraVen(oVen,cCodPOK,cCliID)

	// Local nX 	 := 0
	Local lErro	 := .F.
	// Local cVldCod
	Local cVldCod2
	Local cCod := GetSxeNum("SA3","A3_COD")

	DbselectArea('SA3')
	DbSetOrder(9)

	cVldCod2 := Posicione('SA3',9,xFilial('SA3')+cValToChar(oVen:ID),'A3_COD')

	If !Empty(cVldCod2)
		lErro := .T.
	EndIf

	If !lErro

		//Cria Vendedor
		DbselectArea('SA3')
		DbSetOrder(9)
		
		//Verifica se vendedor existe, se não, cria vendedor
		If !SA3->(Dbseek(xFilial('SA3')+cValToChar(oVen:ID)))
			Reclock('SA3',.T.)
			SA3->A3_FILIAL 	:= xFilial('SA3')
			SA3->A3_COD 	:= cCod
			SA3->A3_NOME	:= fLimpCarac(Upper(oVen:nome),.F.)
			SA3->A3_XIDPOK	:= oVen:ID
			Msunlock()
		EndIf

		//Amarra Vendedor com Cliente
		DbselectArea('SA1')
		DbSetOrder(14)

		If SA1->(Dbseek(xFilial('SA1')+cValToChar(cCliID)))
			if SA1->A1_VEND != cCod
				Reclock('SA1',.F.)
				SA1->A1_VEND	:= cCod
				Msunlock()
			endif
		EndIf

	EndIf

Return(cCod)

Static Function fGeraCli(oCli,cCodPOK,cVend)

	Local nX 	 := 0
	Local lErro	 := .F.
	Local cVldCod
	Local cVldCod2
	Local cCod

	DbselectArea('SA1')
	DbSetOrder(3)

	//For nX := 1 To Len(oCli)
	//If !Empty(oCli[nX]:SEGMENTO)

	If oCli:SEGMENTO == "UF"
		//If oCli[nX]:SEGMENTO == "UF"
		cSeg 	:= "UF"
		//cCod 	:= cSeg+oCli[nX]:CODIGO
		cCod 	:= cSeg+Left(oCli:CNPJ_CPF,8)//+Right(oCli[nX]:CNPJ_CPF,3)
		cLojCli := oCli:CODIGO
		cLojProt := Right(oCli:CNPJ_CPF,4)//oCli[nX]:CODIGO
	ElseIf oCli:SEGMENTO == "OC"
		//ElseIf oCli[nX]:SEGMENTO == "OC"
		cSeg 	:= "OC"
		//cCod 	:= cSeg+oCli[nX]:CODIGO
		//cCod 	:= cSeg+Left(oCli[nX]:CNPJ_CPF,4)+Right(oCli[nX]:CNPJ_CPF,3)
		//cCod 	:= cSeg+Left(oCli[nX]:CNPJ_CPF,8)//+Right(oCli[nX]:CNPJ_CPF,3)
		cCod 	:= cSeg+Left(oCli:CNPJ_CPF,8)
		cLojCli := oCli:CODIGO
		cLojProt := Right(oCli:CNPJ_CPF,4)
	ElseIf oCli:SEGMENTO == "LP"
		cSeg 	:= "LP"
		//cCod 	:= cSeg+oCli[nX]:CODIGO
		//cCod 	:= cSeg+Left(oCli[nX]:CNPJ_CPF,4)+Right(oCli[nX]:CNPJ_CPF,3)
		cCod 	:= cSeg+Left(oCli:CNPJ_CPF,8)//+Right(oCli[nX]:CNPJ_CPF,3)
		cLojCli := oCli:CODIGO
		cLojProt := Right(oCli:CNPJ_CPF,4)
	ElseIf oCli:SEGMENTO == "MC"
		cSeg 	:= "MC"
		cCod 	:= cSeg+Left(oCli:CNPJ_CPF,8)//+Right(oCli[nX]:CNPJ_CPF,3)
		cLojCli := oCli:CODIGO
		cLojProt := Right(oCli:CNPJ_CPF,4)
	Else
		cSeg 	:= "MC"
		cCod 	:= cSeg+Left(oCli:CNPJ_CPF,8)//+Right(oCli[nX]:CNPJ_CPF,3)
		cLojCli := oCli:CODIGO
		cLojProt := Right(oCli:CNPJ_CPF,4)
		//Else
		//	lErro := .T.
		//	cErro := 'Favor verificar SEGMENTO'
	EndIf

	cVldCod := Posicione('SA1',1,xFilial('SA1')+cCod+cLojProt,'A1_CGC')

	If !Empty(cVldCod)
		cVldCod2 := Posicione('SA1',3,xFilial('SA1')+oCli[nX]:CNPJ_CPF,'A1_COD')

		If !Empty(cVldCod2)
			lErro := .T.
		Else
			cCod := cSeg+cValToChar(oCli[nX]:ID)
		EndIf
	EndIf

	If !lErro

		cDDD:= StrTran(oCli:telefone," ","")
		cDDD:= Iif(Left(cDDD,1)=="(",SubsTr(cDDD,2,2),Left(cDDD,2))

		cTel:= StrTran(oCli:telefone,"-","")
		cTel:= StrTran(cTel," ","")
		cTel:= Iif(Left(cTel,1)=="(",SubsTr(cTel,5),SubsTr(cTel,3))
		cCodMun := Posicione('CC2',2,xFilial('CC2')+fLimpCarac(Upper(oCli:ENDERECO:CIDADE),.F.),'CC2_CODMUN')
		cCodPOK := cCod

		DbselectArea('SA1')
		DbSetOrder(3)
		//If !SA1->(Dbseek(xFilial('SA1')+cValToChar(oCli[nX]:ID)))
		If !SA1->(Dbseek(xFilial('SA1')+oCli:CNPJ_CPF))
			Reclock('SA1',.T.)
			SA1->A1_FILIAL 	:= xFilial('SA1')
			SA1->A1_COD 	:= cCod
			SA1->A1_LOJA 	:= cLojProt//"01"
			SA1->A1_XSUBGRP := cSeg
			SA1->A1_XLOJCLI := cLojCli
			SA1->A1_NREDUZ	:= fLimpCarac(Upper(oCli:fantasia),.F.)//fLimpCarac(Upper(Iif(cSeg$"UF/OC",cCod+" - "+oCli[nX]:fantasia,oCli[nX]:fantasia)),.F.)
			SA1->A1_NOME	:= fLimpCarac(Upper(oCli:razao_social),.F.)
			SA1->A1_PESSOA	:= Iif(Len(oCli:CNPJ_CPF)>11,"J","F")
			SA1->A1_CGC		:= oCli:CNPJ_CPF
			SA1->A1_END		:= fLimpCarac(Upper(oCli:ENDERECO:LOGRADOURO)+", "+oCli:ENDERECO:NUMERO,.T.)
			SA1->A1_BAIRRO	:= fLimpCarac(Upper(oCli:ENDERECO:BAIRRO),.F.)
			SA1->A1_CEP		:= fLimpCarac(oCli:ENDERECO:CEP,.T.)
			SA1->A1_MUN		:= fLimpCarac(Upper(oCli:ENDERECO:CIDADE),.F.)
			SA1->A1_COD_MUN := cCodMun
			SA1->A1_EST		:= oCli:ENDERECO:UF
			SA1->A1_TIPO	:= "R"
			SA1->A1_INSCR	:= fLimpCarac(oCli:ie_rg,.F.)
			SA1->A1_EMAIL	:= Iif(len(oCli:CONTATOS)>0,oCli:CONTATOS[1]:EMAIL,"")
			SA1->A1_DDD		:= cDDD
			SA1->A1_TEL		:= cTel
			SA1->A1_XIDPOK	:= oCli:ID
			SA1->A1_NATUREZ := '11010001'
			SA1->A1_VEND    := cVend
			Msunlock()
		Else
			Reclock('SA1',.F.)
			SA1->A1_XSUBGRP := cSeg
			SA1->A1_END		:= fLimpCarac(Upper(oCli:ENDERECO:LOGRADOURO)+", "+oCli:ENDERECO:NUMERO,.T.)
			SA1->A1_BAIRRO	:= fLimpCarac(Upper(oCli:ENDERECO:BAIRRO),.F.)
			SA1->A1_CEP		:= fLimpCarac(oCli:ENDERECO:CEP,.T.)
			SA1->A1_MUN		:= fLimpCarac(Upper(oCli:ENDERECO:CIDADE),.F.)
			SA1->A1_EST		:= oCli:ENDERECO:UF
			SA1->A1_INSCR	:= fLimpCarac(oCli:ie_rg,.F.)
			SA1->A1_EMAIL	:= Iif(len(oCli:CONTATOS)>0,oCli:CONTATOS[1]:EMAIL,"")
			SA1->A1_DDD		:= cDDD
			SA1->A1_TEL		:= cTel
			SA1->A1_XIDPOK	:= oCli:ID
			Msunlock()
		EndIf
	EndIf
	//Else
	//	lErro := .T.
	//	cErro := 'Nao foi possivel cadastrar cliente, favor verificar ## SEGMENTO ##'
	//EndIf

	If lErro
		//envia Workflow erro
		//	u_WFLOGERR(oCli,cErro)
	EndIf
	//Next nX

	nPgCli++
	//fLoopCli()

Return(cCod)

// Static Function fLoopCli()

// 	Local OlRestCli 	:= Nil
// 	Local oJsonIM		:= Nil
// 	Local oCli			:= {}

// 	clPathCli := "/v1/clientes/?alterado_apos="+cDtAtCli+"&excluido=false&pagina="+cValToChar(nPgCli)
// 	OlRestCli := FWRest():New(slURLHost)

// 	OlRestCli:setPath(clPathCli)

// 	If OlRestCli:GET(aHeadCli)
// 		cResCli := OlRestCli:GetResult()

// 		If FWJsonDeserialize(cResCli,@oJsonIM)
// 			oCli := oJsonIM:clientes
// 			If Len(oCli) > 0
// 				fGeraCli(oCli)
// 			EndIf
// 		EndIf
// 	Else
// 		cResCli := "Falha na Requisição : " + Alltrim(OlRestCli:GetLastError())
// 	EndIf

// Return

/*/{Protheus.doc} WSPOK04
	author: Felipe Mayer - AVSI
	descri: GET tabela de pedidos para importacao - PedidoOk X Protheus
	client: Jubileu
	date  : 26/01/2021
/*/

User Function WSPOK04(cTokenPok,cTokenPar,lDtPV,cPedok)

	Local lAtuDt		:= .T.
	Local OlRestCli 	:= Nil
	Local oJsonIM		:= Nil
	Local oPedV			:= {}
	Local nCont			:= 0
	Local nCItem		:= 0
	Local nVlrTot		:= 0
	Local nVlrDsA		:= 0
	Local aDesc			:= {}
	// Local nPercDesc		:= 0
	// Local nPercAcrs		:= 0
	Private aHeadPedV 	:= {}
	Private nPgPedV		:= 1
	Private cDtAtPedV
	Default cPedok		:= ""
	//Default lpasta 		:= .T.

	slURLHost	:= "https://api.pedidook.com.br"
	cDtAtPedV	:= GetMv("MV_XDTPEDV")

	If Empty(cPedok)
		clPathPedV	:= "/v1/pedidos/?alterado_apos="+cDtAtPedV+"&excluido=false&pagina="+cValToChar(nPgPedV)
	Else
		clPathPedV	:= "/v1/pedidos/?excluido=false&pagina="+cValToChar(nPgPedV)+"&numero="+cPedok
	EndIf

	OlRestCli	:= FWRest():New(slURLHost)

	Aadd(aHeadPedV, "Content-type:application/json")
	Aadd(aHeadPedV, "token_parceiro: "+cTokenPar)
	Aadd(aHeadPedV, "token_pedidook: "+cTokenPok)

	OlRestCli:setPath(clPathPedV)

	If OlRestCli:GET(aHeadPedV)
		cResPedV := OlRestCli:GetResult()

		If FWJsonDeserialize(cResPedV,@oJsonIM)
			oPedV := oJsonIM:pedidos
			If Len(oPedV) > 0
				For nCont := 1 to len(oPedV)
					If !oPedV[nCont]:EXCLUIDO //.and. Upper(oPedV[nCont]:situacao) == "PENDENTE"
						Aadd(aList1,{cvaltochar(oPedV[nCont]:NUMERO),;
							stod(strtran(oPedV[nCont]:EMISSAO,"-")),;
							oPedV[nCont]:OBSERVACAO_CLIENTE,;
							oPedV[nCont]:OBSERVACAO_REPRESENTADA,;
							.T.})

						nVlrDsA		:= oPedV[nCont]:VALOR_DESCONTO_ACRESCIMO
						Aadd(aDesc,{nVlrDsA,cvaltochar(oPedV[nCont]:NUMERO)})

						For nCItem := 1 to len(oPedV[nCont]:ITENS)
							If !oPedV[nCont]:ITENS[nCItem]:EXCLUIDO
								Aadd(aList3B,{strzero(nCItem,2),;
									cvaltochar(oPedV[nCont]:ITENS[nCItem]:ID_PRODUTO),;
									cvaltochar(oPedV[nCont]:ITENS[nCItem]:QUANTIDADE),;
									Transform(oPedV[nCont]:ITENS[nCItem]:PRECO_BRUTO,"@E 999,999.99"),;
									Transform(oPedV[nCont]:ITENS[nCItem]:PRECO_LIQUIDO,"@E 999,999.99"),;
									cvaltochar(oPedV[nCont]:NUMERO)})

								nVlrTot	+= oPedV[nCont]:ITENS[nCItem]:QUANTIDADE * oPedV[nCont]:ITENS[nCItem]:PRECO_LIQUIDO

							EndIf
						Next nCItem
						Aadd(aDesc[nCont],nVlrTot)
						nVlrTot := 0
					endif
				Next nCont

				For nCont := 1 to len(aDesc)
					If aDesc[nCont,1] > 0
						Aadd(aDesc[nCont], aDesc[nCont,1]) //ROUND(nVlrDsA/nVlrTot,4) * 100
					ElseIf aDesc[nCont,1] < 0
						Aadd(aDesc[nCont],ROUND(((aDesc[nCont,1]*-1)/aDesc[nCont,3]) * 100,4))
					ElseIf aDesc[nCont,1] == 0
						Aadd(aDesc[nCont], 0)
					EndIf
				Next nCont
				/*If nVlrDsA > 0
					nPercAcrs 	:= nVlrDsA //ROUND(nVlrDsA/nVlrTot,4) * 100
				ElseIf nVlrDsA < 0
					nPercDesc	:= ROUND(((nVlrDsA*-1)/nVlrTot) * 100,4)
				EndIf */

				//fGeraPedV(oPedV,nPercDesc,nPercAcrs)
				fGeraPedV(oPedV,aDesc)
			Else
				lAtuDt := .F.
			EndIf
		EndIf
	Else
		cResPedV := "Falha na Requisição : " + Alltrim(OlRestCli:GetLastError())
	EndIf

	If lAtuDt .And. lDtPV
		cDate := Year2Str(date())+"-"+Month2Str(date())+"-"+Day2Str(date())+"T"+Time()+".00"
		PutMv("MV_XDTPEDV",cDate)
	EndIf

Return

//Static Function fGeraPedV(oPedV,nPercDesc,nPercAcrs)
Static Function fGeraPedV(oPedV,aDesc)

	Local nX 	 	 := 0
	Local nY	 	 := 0
	Local nOpcX      := 0
	Local nCount     := 0
	Local aCabec     := {}
	Local aItens     := {}
	Local aLinha     := {}
	Local aErroAuto  := {}
	Local lErro  	 := .F.
	// Local lOK 		 := .F.
	LOCAL lMsErroAuto    := .F.
	// lOCAL nVlrDsA1		:= 0
	local nPosAux := 0

	Default cF4TES 	  := '501'
	Default cE4Codigo := '001'
	//Default lpasta 	:= .T.

	ConOut("Inicio: " + Time())
	ConOut(Repl("-",80))

	For nX := 1 To Len(oPedV)

		If !oPedV[nX]:excluido .And. Upper(oPedV[nX]:situacao) == "PENDENTE" //.And. Upper(oPedV[nX]:status) == "PEDIDO"

			Aadd(aList2B,{'','','','',.F.,'','','',''})

			dbSelectArea("SE4")
			dbSetOrder(3)

			DbselectArea('SC5')
			DbSetOrder(10)

			If !Dbseek("0101"+avkey(cValToChar(oPedV[nX]:NUMERO),"C5_XIDPOK")) .and.;
					!Dbseek("0201"+avkey(cValToChar(oPedV[nX]:NUMERO),"C5_XIDPOK")) .and.;
					!Dbseek("0301"+avkey(cValToChar(oPedV[nX]:NUMERO),"C5_XIDPOK")) .and.;
					!Dbseek("0401"+avkey(cValToChar(oPedV[nX]:NUMERO),"C5_XIDPOK")) .and.;
					!Dbseek("0501"+avkey(cValToChar(oPedV[nX]:NUMERO),"C5_XIDPOK")) .and.;
					!Dbseek("0601"+avkey(cValToChar(oPedV[nX]:NUMERO),"C5_XIDPOK")) .and.;
					!Dbseek("0701"+avkey(cValToChar(oPedV[nX]:NUMERO),"C5_XIDPOK")) .and.;
					!Dbseek("0801"+avkey(cValToChar(oPedV[nX]:NUMERO),"C5_XIDPOK")) .and.;
					!Dbseek("0901"+avkey(cValToChar(oPedV[nX]:NUMERO),"C5_XIDPOK"))

				//inclusao

				aCabec   := {}
				aItens   := {}
				aLinha   := {}
				lErro	 := .F.
				cItem	 := "01"
				//cE4Codigo := "001"

				//quando não vier condição  de pagamento
				If oPedV[nX]:ID_COND_PAGTO == Nil
					cE4Codigo := "001"
				Else
					//procurar na se4 pelo id no campo que vc vai criar
					dbSelectArea("SE4")
					dbSetOrder(3)

					If Dbseek(xFilial("SE4")+Avkey(cvaltochar(oPedV[nX]:ID_COND_PAGTO),"E4_XIDPOK"))
						cE4Codigo := SE4->E4_CODIGO
					Else
						cE4Codigo := CondPgto(oPedV[nX]:ID_COND_PAGTO)
					EndIf

					If Empty(cE4Codigo)
						cE4Codigo := "001"
					EndIf
				EndIf

				cDoc 	:= fGeraDoc()//GetSxeNum("SC5", "C5_NUM")
				cA1Cod  := Posicione('SA1',14,xFilial('SA1')+cValToChar(oPedV[nX]:id_cliente),'A1_COD')
				cA1Loja := Posicione('SA1',14,xFilial('SA1')+cValToChar(oPedV[nX]:id_cliente),'A1_LOJA')
				cA3Cod  := Posicione('SA3',9,xFilial('SA3')+cValToChar(oPedV[nX]:id_vendedor),'A3_COD')

				If Empty(cA1Cod)
					//Chamar API Cliente.
					cA1Cod := U_WSPOK03(cTokenPok,cTokenPar,.T.,cValToChar(oPedV[nX]:id_cliente),cA3Cod)
					cA1Loja := Posicione('SA1',14,xFilial('SA1')+cValToChar(oPedV[nX]:id_cliente),'A1_LOJA')
				EndIf

				If Empty(cA3Cod)
					//Chamar API Vendedor.
					cA3Cod := U_WSPOK05(cTokenPok,cTokenPar,cValToChar(oPedV[nX]:id_vendedor),oPedV[nX]:id_cliente)
				EndIf

				If !Empty(cA1Cod)
					cRazao := Posicione('SA1',14,xFilial('SA1')+cValToChar(oPedV[nX]:id_cliente),'A1_NOME')

					aList2B[len(aList2B),02] := cRazao
					aList2B[len(aList2B),06] := cvaltochar(oPedV[nX]:NUMERO)

					aadd(aCabec, {"C5_NUM"		, cDoc		,		Nil})
					aadd(aCabec, {"C5_TIPO"		, "N"		,		Nil})
					aadd(aCabec, {"C5_CLIENTE"	, cA1Cod	,		Nil})
					aadd(aCabec, {"C5_XRAZAO"	, cRazao	,		Nil})
					aadd(aCabec, {"C5_LOJACLI"	, cA1Loja	,		Nil})
					aadd(aCabec, {"C5_LOJAENT"	, cA1Loja	,		Nil})
					aadd(aCabec, {"C5_CONDPAG"	, cE4Codigo	,		Nil})

					//aDesc[nPosAux,2]
					nPosAux := Ascan(aDesc,{|x| x[2] == cvaltochar(oPedV[nX]:NUMERO)})
					If nPosAux > 0 //.and. nPosAux > 0
						//SEGURO 29/09 ELIZA solicitou 2% do valor total
						aadd(aCabec, {"C5_SEGURO"	, (aDesc[nPosAux,3])/100*2	, Nil})
						//aadd( aBnm3[nPosAux],aF2[x])
						If aDesc[nPosAux,1] < 0
							aadd(aCabec, {"C5_DESC1"	, aDesc[nPosAux,4]	,		Nil})
							aadd(aCabec, {"C5_DESPESA"	, 0 ,		Nil})
						ElseIf aDesc[nPosAux,1] > 0
							aadd(aCabec, {"C5_DESC1"	, 0	,		Nil})
							aadd(aCabec, {"C5_DESPESA"	, aDesc[nPosAux,4] ,		Nil})
						ElseIf	aDesc[nPosAux,1] == 0
							aadd(aCabec, {"C5_DESC1"	, 0	,		Nil})
							aadd(aCabec, {"C5_DESPESA"	, 0 ,		Nil})
						EndIf
						//aadd( aVetor[nPosAux],aF2[x])
					EndIf

					aadd(aCabec, {"C5_XIDPOK"	, oPedV[nX]:NUMERO,	Nil})

					For nY := 1 To Len(oPedV[nX]:itens)
						If !oPedV[nX]:itens[nY]:excluido
							Aadd(aList4B,{'','','','',.F.,'','','',''})

							dbselectarea('SB1')
							dbsetorder(14)

							aList4B[len(aList4B),01] := cItem //StrZero(nY,2)

							If dbseek(avkey(xFilial('SB1'),'B1_FILIAL')+avkey(cValToChar(oPedV[nX]:itens[nY]:id_produto),"B1_XIDPOK"))

								//cF4TES := MaTesInt(2,"01",cA1Cod,cA1Loja,"C",SB1->B1_COD,"C6_TES")
								dbSelectArea("SB2")
								dbSetOrder(1)
								If !dbSeek(xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD)
									CriaSB2(SB1->B1_COD,SB1->B1_LOCPAD)
								EndIf

								aList4B[len(aList4B),02] := SB1->B1_COD
								aList4B[len(aList4B),03] := SB1->B1_DESC
								aList4B[len(aList4B),04] := cvaltochar(oPedV[nX]:itens[nY]:quantidade)
								aList4B[len(aList4B),05] := .T.
								aList4B[len(aList4B),06] := cvaltochar(oPedV[nX]:NUMERO)

								aLinha := {}
								// StrZero(nY,2)
								aadd(aLinha,{"C6_ITEM",   cItem, Nil})
								aadd(aLinha,{"C6_PRODUTO", SB1->B1_COD,   Nil})
								aadd(aLinha,{"C6_QTDVEN",  oPedV[nX]:itens[nY]:quantidade,        Nil})
								aadd(aLinha,{"C6_PRCVEN",  oPedV[nX]:itens[nY]:preco_liquido,     Nil})
								aadd(aLinha,{"C6_PRUNIT",  oPedV[nX]:itens[nY]:preco_liquido,     Nil})
								aadd(aLinha,{"C6_VALOR",   oPedV[nX]:itens[nY]:preco_liquido*oPedV[nX]:itens[nY]:quantidade, Nil})
								If Upper(oPedV[nX]:status) <> "PEDIDO"
									aadd(aLinha,{"C6_TES","503",        Nil})
								Else
									aadd(aLinha,{"C6_TES",     cF4TES,        Nil})
								EndIf
								aadd(aLinha,{"C6_XIDPOK",  oPedV[nX]:NUMERO,  Nil})

								/*If oPedV[nX]:itens[nY]:PERCENTUAL_DESCONTO_ACRESCIMO < 0
									aadd(aLinha,{"C6_VALDESC", (oPedV[nX]:itens[nY]:PERCENTUAL_DESCONTO_ACRESCIMO * -1) * oPedV[nX]:itens[nY]:preco_liquido , NIL})
								EndIf*/
								aadd(aItens, aLinha)

								cItem := Soma1(cItem)

							Else
								cCod := u_WSPOK02(cTokenPok,cTokenPar,.T.,oPedV[nX]:itens[nY]:id_produto)
								If !Empty(cCod)
									DbSelectArea("SB1")
									DbSetOrder(1)
									DbSeek(xFilial("SB1")+cCod)

									dbSelectArea("SB2")
									dbSetOrder(1)
									If !dbSeek(xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD)
										CriaSB2(SB1->B1_COD,SB1->B1_LOCPAD)
									EndIf

									aList4B[len(aList4B),02] := SB1->B1_COD
									aList4B[len(aList4B),03] := SB1->B1_DESC
									aList4B[len(aList4B),04] := cDoc
									aList4B[len(aList4B),05] := .T.
									aList4B[len(aList4B),06] := cvaltochar(oPedV[nX]:NUMERO)

									aLinha := {}
									aadd(aLinha,{"C6_ITEM",    StrZero(nY,2), Nil})
									aadd(aLinha,{"C6_PRODUTO", SB1->B1_COD,   Nil})
									aadd(aLinha,{"C6_QTDVEN",  oPedV[nX]:itens[nY]:quantidade,        Nil})
									aadd(aLinha,{"C6_PRCVEN",  oPedV[nX]:itens[nY]:preco_liquido,     Nil})
									aadd(aLinha,{"C6_PRUNIT",  oPedV[nX]:itens[nY]:preco_liquido,     Nil})
									aadd(aLinha,{"C6_VALOR",   oPedV[nX]:itens[nY]:preco_liquido*oPedV[nX]:itens[nY]:quantidade, Nil})
									If Upper(oPedV[nX]:status) <> "PEDIDO"
										aadd(aLinha,{"C6_TES","503",        Nil})
									Else
										aadd(aLinha,{"C6_TES",     cF4TES,        Nil})
									EndIf
									//aadd(aLinha,{"C6_TES",     cF4TES,        Nil})
									aadd(aLinha,{"C6_XIDPOK",  oPedV[nX]:id,  Nil})

									/*If oPedV[nX]:itens[nY]:PERCENTUAL_DESCONTO_ACRESCIMO < 0
										aadd(aLinha,{"C6_VALDESC", (oPedV[nX]:itens[nY]:PERCENTUAL_DESCONTO_ACRESCIMO * -1) * oPedV[nX]:itens[nY]:preco_liquido , NIL})
									EndIf*/

									aadd(aItens, aLinha)

									cItem := Soma1(cItem)
								Else
									lErro := .T.
									aList2B[len(aList2B),01] := ''
									aList2B[len(aList2B),05] := .F.
									//alerta de produto não encontrado no pedidosok
									aList4B[len(aList4B),02] := ''
									aList4B[len(aList4B),03] := 'Produto não encontrado'
									aList4B[len(aList4B),04] := ''
									aList4B[len(aList4B),05] := .F.
									aList4B[len(aList4B),06] := cvaltochar(oPedV[nX]:NUMERO)
								EndIf
							EndIf
						EndIf

					Next nY

					If !lErro
						lMsErroAuto := .F.
						nOpcX := 3
						MSExecAuto({|a, b, c, d| MATA410(a, b, c, d)}, aCabec, aItens, nOpcX, .F.)

						If !lMsErroAuto
							aList2B[len(aList2B),01] := SC5->C5_NUM
							aList2B[len(aList2B),05] := .T.
							//If nPercDesc > 0
							If aCabec[8,2] > 0
								aList2B[len(aList2B),03] += " # CAMPO DESCONTO 1 DEVE SER REVALIDADO "
							EndIf
							ConOut("Incluido com sucesso! " + cDoc)
							//ConfirmSx8()
						Else
							RollbackSX8()
							ConOut("Erro na inclusao!")
							aList2B[len(aList2B),01] := ''
							aList2B[len(aList2B),05] := .F.

							aErroAuto := GetAutoGRLog()
							For nCount := 1 To Len(aErroAuto)
								cLogErro += StrTran(StrTran(aErroAuto[nCount], "<", ""), "-", "") + " "
								ConOut(cLogErro)
								msgalert(cLogErro)
							Next nCount
						EndIf
					Else
						ConOut("Erro na geração por item inválido")
						aList2B[len(aList2B),01] := ''
						aList2B[len(aList2B),03] := "Erro na geração por item inválido"
						aList2B[len(aList2B),05] := .F.

						aList4B[len(aList4B),02] := ''
						aList4B[len(aList4B),03] := 'Produto não encontrado'
						aList4B[len(aList4B),04] := ''
						aList4B[len(aList4B),05] := .F.
						aList4B[len(aList4B),06] := cvaltochar(oPedV[nX]:NUMERO)
					EndIF
				Else
					Conout("Cliente não encontrado na base do pedidosok")
					aList2B[len(aList2B),01] := ''
					aList2B[len(aList2B),03] := "Cliente não encontrado na base do pedidosok"
					aList2B[len(aList2B),05] := .F.
				endIf
				/*
			Else //alteracao
				Aadd(aList2B,{'','','','',.F.,'','','',''})

				aCabec   := {}
				aItens   := {}
				aLinha   := {}
				lErro	 := .F.

				cDoc 	:= SC5->C5_NUM

				cRazao := Posicione('SA1',14,xFilial('SA1')+cValToChar(oPedV[nX]:id_cliente),'A1_NOME')

				aList2B[len(aList2B),01] := SC5->C5_NUM
				aList2B[len(aList2B),02] := cRazao
				aList2B[len(aList2B),03] := 'Pedido gerado anteriormente'
				aList2B[len(aList2B),05] := .T.
				aList2B[len(aList2B),06] := cvaltochar(oPedV[nX]:NUMERO)

				DbSelectArea("SC6")
				DbSetOrder(1)
				If Dbseek(SC5->C5_FILIAL+SC5->C5_NUM)
					While !EOF() .AND. SC6->C6_FILIAL == SC5->C5_FILIAL .AND. SC6->C6_NUM == SC5->C5_NUM
						Aadd(aList4B,{'','','','',.F.,'','','',''})
						aList4B[len(aList4B),01] := SC6->C6_ITEM
						aList4B[len(aList4B),02] := SC6->C6_PRODUTO
						aList4B[len(aList4B),03] := SC6->C6_DESCRI
						aList4B[len(aList4B),04] := cvaltochar(SC6->C6_QTDVEN)
						aList4B[len(aList4B),05] := .T.
						aList4B[len(aList4B),06] := cvaltochar(oPedV[nX]:NUMERO)
						Dbskip()
					EndDo
				EndIf

				/*
				aadd(aCabec, {"C5_NUM",     cDoc,      Nil})
				aadd(aCabec, {"C5_TIPO",    "N",       Nil})
				aadd(aCabec, {"C5_CLIENTE", cA1Cod,    Nil})
				aadd(aCabec, {"C5_LOJACLI", cA1Loja,   Nil})
				aadd(aCabec, {"C5_LOJAENT", cA1Loja,   Nil})
				aadd(aCabec, {"C5_CONDPAG", cE4Codigo, Nil})
				aadd(aCabec, {"C5_XIDPOK",  oPedV[nX]:id, Nil})

				For nY := 1 To Len(oPedV[nX]:itens)

					dbselectarea('SC6')
					dbsetorder(16)

					cCodProd := Posicione('SB1',14,xFilial('SB1')+cValToChar(oPedV[nX]:itens[nY]:id_produto),'B1_COD')

					If Dbseek(xFilial('SC6')+avkey(cValToChar(oPedV[nX]:id),"C6_XIDPOK")+cCodProd)

						cDel := Iif(oPedV[nX]:itens[nY]:excluido,'S','N')
						aLinha := {}

						aadd(aLinha,{"LINPOS",     "C6_ITEM",    SC6->C6_ITEM})
						aadd(aLinha,{"AUTDELETA",  cDel,           Nil})
						aadd(aLinha,{"C6_PRODUTO", SC6->C6_PRODUTO,   Nil})
						aadd(aLinha,{"C6_QTDVEN",  oPedV[nX]:itens[nY]:quantidade,        Nil})
						aadd(aLinha,{"C6_PRCVEN",  oPedV[nX]:itens[nY]:preco_liquido,     Nil})
						aadd(aLinha,{"C6_PRUNIT",  oPedV[nX]:itens[nY]:preco_liquido,     Nil})
						aadd(aLinha,{"C6_VALOR",   oPedV[nX]:itens[nY]:preco_liquido*oPedV[nX]:itens[nY]:quantidade,     Nil})
						aadd(aLinha,{"C6_TES",     cF4TES,        Nil})
						aadd(aItens, aLinha)
					Else
						lErro := .T.
					EndIf

				Next nY

				If !lErro
					nOpcX := 4
					MSExecAuto({|a, b, c, d| MATA410(a, b, c, d)}, aCabec, aItens, nOpcX, .F.)

					If !lMsErroAuto
						ConOut("atualizado com sucesso! " + cDoc)
					Else
						RollbackSX8()
						ConOut("Erro na atualizacao!")

						aErroAuto := GetAutoGRLog()
						For nCount := 1 To Len(aErroAuto)
							cLogErro += StrTran(StrTran(aErroAuto[nCount], "<", ""), "-", "") + " "
							ConOut(cLogErro)
						Next nCount
					EndIf
				EndIf
				*/
			EndIf


		EndIf
	Next nX

	nPgPedV++
	fLoopPedV()

Return

//Static Function fLoopPedV(nPercDesc,nPercAcrs)
Static Function fLoopPedV()

	Local OlRestCli 	:= Nil
	Local oJsonIM		:= Nil
	Local oPedV			:= {}
	//Local aDesc			:= {}
	Local nCont			:= 0
	Local nCItem		:= 0
	Local nVlrTot		:= 0
	Local nVlrDsA		:= 0
	Local aDesc			:= {}
	// Local nPercDesc		:= 0
	// Local nPercAcrs		:= 0

	clPathPedV	:= "/v1/pedidos/?alterado_apos="+cDtAtPedV+"&excluido=false&pagina="+cValToChar(nPgPedV)
	OlRestCli := FWRest():New(slURLHost)

	OlRestCli:setPath(clPathPedV)

	If OlRestCli:GET(aHeadPedV)
		cResPedV := OlRestCli:GetResult()

		If FWJsonDeserialize(cResPedV,@oJsonIM)
			oPedV := oJsonIM:pedidos
			If Len(oPedV) > 0
				For nCont := 1 to len(oPedV)
					If !oPedV[nCont]:EXCLUIDO
						Aadd(aList1,{cvaltochar(oPedV[nCont]:NUMERO),;
							stod(strtran(oPedV[nCont]:EMISSAO,"-")),;
							oPedV[nCont]:OBSERVACAO_CLIENTE,;
							oPedV[nCont]:OBSERVACAO_REPRESENTADA,;
							.T.})

						nVlrDsA		:= oPedV[nCont]:VALOR_DESCONTO_ACRESCIMO
						Aadd(aDesc,{nVlrDsA,cvaltochar(oPedV[nCont]:NUMERO)})

						For nCItem := 1 to len(oPedV[nCont]:ITENS)
							If !oPedV[nCont]:ITENS[nCItem]:EXCLUIDO
								Aadd(aList3B,{strzero(nCItem,2),;
									cvaltochar(oPedV[nCont]:ITENS[nCItem]:ID_PRODUTO),;
									cvaltochar(oPedV[nCont]:ITENS[nCItem]:QUANTIDADE),;
									Transform(oPedV[nCont]:ITENS[nCItem]:PRECO_BRUTO,"@E 999,999.99"),;
									Transform(oPedV[nCont]:ITENS[nCItem]:PRECO_LIQUIDO,"@E 999,999.99"),;
									cvaltochar(oPedV[nCont]:NUMERO)})

								nVlrTot	+= oPedV[nCont]:ITENS[nCItem]:QUANTIDADE * oPedV[nCont]:ITENS[nCItem]:PRECO_LIQUIDO

							EndIf
						Next nCItem
						Aadd(aDesc[nCont],nVlrTot)
						nVlrTot := 0
					endif
				Next nCont

				For nCont := 1 to len(aDesc)
					If aDesc[nCont,1] > 0
						Aadd(aDesc[nCont], aDesc[nCont,1]) //ROUND(nVlrDsA/nVlrTot,4) * 100
					ElseIf aDesc[nCont,1] < 0
						Aadd(aDesc[nCont],ROUND(((aDesc[nCont,1]*-1)/aDesc[nCont,3]) * 100,4))
					ElseIf aDesc[nCont,1] == 0
						Aadd(aDesc[nCont], 0)
					EndIf
				Next nCont
				/*If nVlrDsA > 0
					nPercAcrs 	:= nVlrDsA //ROUND(nVlrDsA/nVlrTot,4) * 100
				ElseIf nVlrDsA < 0
					nPercDesc	:= ROUND(((nVlrDsA*-1)/nVlrTot) * 100,4)
				EndIf */

				//fGeraPedV(oPedV,nPercDesc,nPercAcrs)
				fGeraPedV(oPedV,aDesc)
			Else
				lAtuDt := .F.
			EndIf
			//fGeraPedV(oPedV,nPercDesc,nPercAcrs)
			//fGeraPedV(oPedV,aDesc)
			//EndIf
		EndIf
	Else
		cResPedV := "Falha na Requisição : " + Alltrim(OlRestCli:GetLastError())
	EndIf

Return

/*/{Protheus.doc} fLimpCarac
Função que limpa os caracteres especiais dentro de um campo
@type function
@author Felipe Mayer
@since 05/02/2021
@version 1.0
@param lEndereco, Lógico, Define se o campo é endereço (caso sim, o traço e vírgula serão ignorados)
    @example
    fLimpCarac()
/*/

Static Function fLimpCarac(cConteudo,lEndereco)

	Local aArea       := GetArea()
	Default lEndereco := .F.

	//Retirando caracteres
	cConteudo := StrTran(cConteudo, "'", "")
	cConteudo := StrTran(cConteudo, "#", "")
	cConteudo := StrTran(cConteudo, "%", "")
	cConteudo := StrTran(cConteudo, "*", "")
	cConteudo := StrTran(cConteudo, "&", "E")
	cConteudo := StrTran(cConteudo, ">", "")
	cConteudo := StrTran(cConteudo, "<", "")
	cConteudo := StrTran(cConteudo, "!", "")
	cConteudo := StrTran(cConteudo, "@", "")
	cConteudo := StrTran(cConteudo, "$", "")
	cConteudo := StrTran(cConteudo, "(", "")
	cConteudo := StrTran(cConteudo, ")", "")
	cConteudo := StrTran(cConteudo, "_", "")
	cConteudo := StrTran(cConteudo, "=", "")
	cConteudo := StrTran(cConteudo, "+", "")
	cConteudo := StrTran(cConteudo, "{", "")
	cConteudo := StrTran(cConteudo, "}", "")
	cConteudo := StrTran(cConteudo, "[", "")
	cConteudo := StrTran(cConteudo, "]", "")
	cConteudo := StrTran(cConteudo, "/", "")
	cConteudo := StrTran(cConteudo, "?", "")
	cConteudo := StrTran(cConteudo, ".", "")
	cConteudo := StrTran(cConteudo, "\", "")
	cConteudo := StrTran(cConteudo, "|", "")
	cConteudo := StrTran(cConteudo, ":", "")
	cConteudo := StrTran(cConteudo, ";", "")
	cConteudo := StrTran(cConteudo, '"', '')
	cConteudo := StrTran(cConteudo, '°', '')
	cConteudo := StrTran(cConteudo, 'ª', '')
	cConteudo := StrTran(cConteudo, "á", "A")
	cConteudo := StrTran(cConteudo, "é", "E")
	cConteudo := StrTran(cConteudo, "í", "I")
	cConteudo := StrTran(cConteudo, "ó", "O")
	cConteudo := StrTran(cConteudo, "ú", "U")
	cConteudo := StrTran(cConteudo, "Á", "A")
	cConteudo := StrTran(cConteudo, "É", "E")
	cConteudo := StrTran(cConteudo, "Í", "I")
	cConteudo := StrTran(cConteudo, "Ó", "O")
	cConteudo := StrTran(cConteudo, "Ú", "U")
	cConteudo := StrTran(cConteudo, "ã", "A")
	cConteudo := StrTran(cConteudo, "õ", "O")
	cConteudo := StrTran(cConteudo, "Ã", "A")
	cConteudo := StrTran(cConteudo, "Õ", "O")
	cConteudo := StrTran(cConteudo, "â", "A")
	cConteudo := StrTran(cConteudo, "ê", "E")
	cConteudo := StrTran(cConteudo, "î", "I")
	cConteudo := StrTran(cConteudo, "ô", "O")
	cConteudo := StrTran(cConteudo, "û", "U")
	cConteudo := StrTran(cConteudo, "Â", "A")
	cConteudo := StrTran(cConteudo, "Ê", "E")
	cConteudo := StrTran(cConteudo, "Î", "I")
	cConteudo := StrTran(cConteudo, "Ô", "O")
	cConteudo := StrTran(cConteudo, "Û", "U")
	cConteudo := StrTran(cConteudo, "ç", "C")
	cConteudo := StrTran(cConteudo, "Ç", "C")
	cConteudo := StrTran(cConteudo, "à", "A")
	cConteudo := StrTran(cConteudo, "À", "A")
	cConteudo := StrTran(cConteudo, "º", ".")
	cConteudo := StrTran(cConteudo, "ª", ".")
	cConteudo := StrTran(cConteudo, "¡", "I")
	cConteudo := StrTran(cConteudo, "A‡Aƒ", "CA")

	//Se não for endereço, retira também o - e a ,
	If !lEndereco
		cConteudo := StrTran(cConteudo, ",", "")
		cConteudo := StrTran(cConteudo, "-", "")
	EndIf

	RestArea(aArea)

Return cConteudo

Static Function CondPgto(cCondPg)

	Local cRet		:= ""
	Local oJsonC	:=	Nil
	Local oPedC		:= 	Nil
	Local nX := 0

	slURLHost		:= "https://api.pedidook.com.br"

	clPathPedV	:= "/v1/condicoes_pagamento/"+cvaltochar(cCondPg)
	OlRestCli	:= FWRest():New(slURLHost)
	aHeadPedV	:= {}

	Aadd(aHeadPedV, "Content-type: application/json")
	Aadd(aHeadPedV, "token_parceiro: "+cTokenPar)
	Aadd(aHeadPedV, "token_pedidook: "+cTokenPok)

	OlRestCli:setPath(clPathPedV)

	If OlRestCli:GET(aHeadPedV)
		cResPedV := OlRestCli:GetResult()

		If FWJsonDeserialize(cResPedV,@oJsonC)
			oPedC := oJsonC:CONDICAO_PAGAMENTO:PRAZOS

			dbselectarea('SE4')
			dbsetorder(3)
			If Len(oPedC) > 0 .and. !Dbseek(xFilial('SE4')+cvaltochar(cCondPg))
				ASORT(oPedC,,,{|x,y| x < y })
				//assim Aeval(oPedC,{|x| cCondP += cvaltochar(x)+","})
				//ou For
				cAux := ""
				For nX := 1 to len(oPedC)
					If cAux == ""
						cAux := cValtoChar(oPedC[nX])
					Else
						cAux += ','+cValtoChar(oPedC[nX])
					EndIf
				Next nX

				cCodPag := ""
				cCodPag	:= GetSxeNum("SE4", "E4_CODIGO")
				DbSelectArea("SE4")
				Reclock("SE4",.T.)
				//campos a serem preenchidos
				SE4->E4_FILIAL 	:= xFilial("SE4")
				SE4->E4_TIPO 	:= "1"
				SE4->E4_CODIGO  := cCodPag
				SE4->E4_TIPO 	:= "1"
				SE4->E4_COND 	:=  cAux
				SE4->E4_DESCRI 	:= cAux
				SE4->E4_XIDPOK 	:= cvaltochar(cCondPg)
				SE4->(Msunlock())

				ConfirmSx8()
				cRet  := cCodPag
			Else
				//lAtuDt := .F.
				cRet := SE4->E4_CODIGO
			EndIf
		EndIf
	Else
		cResPedV := "Falha na Requisição : " + Alltrim(OlRestCli:GetLastError())
	EndIf

Return(cRet)

//GERA PROXIMO NUMERO PEDIDO DE VENDA

Static Function fGeraDoc()

	Local cQuery := ''
	Local cRet	 := ''
	Local cAlias := GetNextAlias()

	cQuery := " SELECT MAX(C5_NUM) AS NUM FROM "+RetSqlName('SC5')+" WHERE D_E_L_E_T_=' ' AND C5_FILIAL='"+xFilial('SC5')+"'"

	TcQuery (cQuery) ALIAS (cAlias) NEW

	cRet := StrZero(Val((cAlias)->NUM)+1,TamSx3('C5_NUM')[1])

	(cAlias)->(dbClosearea())

	//TCUnlink() //NUNCA MAIS USE ESSA PORRA

Return cRet

//gerar desconto
User function Desc1(nVlrDsA1)

	Default nVlDra1:= 0

	If nVlrDsA1 > 0
		nPercAcrs 	:= nVlrDsA1 //ROUND(nVlrDsA/nVlrTot,4) * 100
	ElseIf nVlrDsA1 < 0
		nPercDesc	:= ROUND(((nVlrDsA*-1)/nVlrTot) * 100,4)
	EndIf

return(nPercAcrs,nPercAcrs)
