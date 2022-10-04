#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE "FWMVCDEF.CH"


//-------------------------------------------------------------------
/*/{Protheus.doc} PRTL044
Descricao: Servico API Rest Evento Envia Chamados
@author Felipe Mayer
@since 22/08/2022
@version 1.0

/*/
//-------------------------------------------------------------------
USER Function PRTL044()
Return

WsRestFul EnvChamdo DESCRIPTION "API REST - EVENTO Envia Chamados | PORTAL ROBSOL " 
	
    WSDATA COD_CLIENTE As String
	WSDATA LOJA_CLIENTE As String

	WsMethod GET Description "Retorna os chamados do cliente" WSSYNTAX "/EnvChamdo " 

End WsRestFul
//-------------------------------------------------------------------
/*/{Protheus.doc} Metodo Post | Evento ImplantaÃ§Ã£o 
Descricao: 	Servico Rest contendo o Metodo POST do evento de Envia Chamados
@author Felipe Mayer
@since 22/08/2022
@version 1.0

@Param:

/*/
//-------------------------------------------------------------------
WsMethod GET WsReceive COD_CLIENTE,LOJA_CLIENTE WsService EnvChamdo

    Local cCliente 	:= Self:COD_CLIENTE
	Local cLojCli 	:= Self:LOJA_CLIENTE
	Local aArea		:= GetArea()
	Local cVirg		:= ''

	::SetContentType("application/json charset=iso-8859-1")
	
	RpcSetType(3)
	RPCSetEnv("01","0101")
	
	conout("chegou aqui PRTL044")

	::SetResponse('{')
	::SetResponse('"items": [')

	cQuery := " SELECT * FROM "+RetSQLName("Z50")+" "
	cQuery += " WHERE Z50_CODCLI='"+cCliente+"' AND Z50_LOJCLI='"+cLojCli+"'"
	cQuery += " AND D_E_L_E_T_=' '"
	
	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf

	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

	DbSelectArea("TRB")

	While !EoF()
		::SetResponse(cVirg+'{')
		::SetResponse('"chamado":"' +AllTrim(TRB->Z50_CODIGO)+'",')
		::SetResponse('"nota":"' +AllTrim(TRB->Z50_NOTA)+'",')
		::SetResponse('"item":"'+AllTrim(TRB->Z50_ITEM)+'",')
		::SetResponse('"emissao":"'+cvaltochar(stod(TRB->Z50_EMISSA))+'",')
		::SetResponse('"produto":"'+AllTrim(TRB->Z50_PROD)+'",')
		::SetResponse('"descricao":"'+AllTrim(Posicione("SB1",1,xFilial("SB1")+TRB->Z50_PROD,"B1_DESC"))+'",')
		::SetResponse('"quantidade":"'+Alltrim(cValToChar(TRB->Z50_QUANT))+'",')
		::SetResponse('"defeito":"'+fComboDefeito(1,TRB->Z50_DEFEIT)+'",')
		::SetResponse('"tipodefeito":"'+fComboDefeito(2,TRB->Z50_TPDEFE)+'",')
		::SetResponse('"preco":"'+Alltrim(transform(TRB->Z50_PRECO,"@E 999,999,999.99"))+'",')
		::SetResponse('"status":"'+AllTrim(TRB->Z50_STATUS)+'"')
		::SetResponse('}')

		cVirg := ','
		Dbskip()
	EndDo
	
	::SetResponse(']')
	::SetResponse('}')

	RestArea(aArea)
	
Return .T.


Static Function fComboDefeito(nTipo,cProp)

Local cRet := ''

// 1-Defeito / 2-Tipo Defeito
If nTipo == 1
	If cProp == '1'
		cRet := 'Frontal'
	ElseIf cProp == '2'
		cRet := 'Hastes'
	ElseIf cProp == '3'
		cRet := 'Charneiras'
	ElseIf cProp == '4'
		cRet := 'Lentes'
	EndIf
Else
	If cProp == 'A'
		cRet := 'DESCASCANDO'
	ElseIf cProp == 'B'
		cRet := 'TRINCADO'
	ElseIf cProp == 'C'
		cRet := 'OXIDAÇÃO'
	ElseIf cProp == 'D'
		cRet := 'RISCADA'
	ElseIf cProp == 'E'
		cRet := 'QUEBRADA'
	ElseIf cProp == 'F'
		cRet := 'QUEBRADA NA SOLDA'
	ElseIf cProp == 'G'
		cRet := 'SOLTA'
	ElseIf cProp == 'H'
		cRet := 'PARAFUSO ESPANADO'
	ElseIf cProp == 'I'
		cRet := 'DEFEITO NA PONTEIRA'
	ElseIf cProp == 'J'
		cRet := 'TONALIDADES DIFERENTES'
	ElseIf cProp == 'L'
		cRet := 'MANCHADA'
	ElseIf cProp == 'M'
		cRet := 'DEFEITO NA MOLA'
	ElseIf cProp == 'N'
		cRet := 'SUPORTE DE PLAQUETAS'
	EndIf
EndIf


Return cRet
