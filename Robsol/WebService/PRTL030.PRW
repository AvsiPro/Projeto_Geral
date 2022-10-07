#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RESTFUL.CH'
#INCLUDE "FWMVCDEF.CH"


//-------------------------------------------------------------------
/*/{Protheus.doc} PRTL030
Descricao: Serviço API Rest Evento Pedidos

@author Alexandre Venancio
@since 21/09/2021
@version 1.0

@Param:

/*/
//-------------------------------------------------------------------
USER Function PRTL030()
Return

// Serviço.
WsRestFul Sales DESCRIPTION "API REST - EVENTO Pedidos | PORTAL ROBSOL " 
	
	WSDATA CODIGO As String 
	WSDATA PAGINA As String 
	WSDATA VENDEDOR As String
	WSDATA STATUS As String
	WSDATA EMISSAO As String
	WSDATA CLIENTE As String
	WSDATA FILTRO As String
	WSDATA RAZAO As String
	WSDATA CNPJ As String

	WsMethod GET Description "Retorna o Cliente especifico ou cadastro todo" WSSYNTAX "/Sales || /Sales/{CODIGO}" 

End WsRestFul
//-------------------------------------------------------------------
/*/{Protheus.doc} Metodo Post | Evento Implantação 
Descricao: 	Serviço Rest contendo o Metodo POST do evento de 
				Portal Robsol

@author Alexandre Venancio
@since 21/09/2021
@version 1.0

@Param:

/*/
//-------------------------------------------------------------------
WsMethod GET WsReceive CODIGO,VENDEDOR,PAGINA,STATUS,EMISSAO,CLIENTE,CNPJ,FILTRO,RAZAO WsService Sales

	Local cCode 	:= Self:CODIGO
	Local CodVend 	:= Self:VENDEDOR
	Local cPage 	:= Self:PAGINA
	Local cStatus	:= Self:STATUS
	Local cEmissao 	:= Self:EMISSAO
	Local cCliente  := Self:CLIENTE
	Local cFilter	:= Self:FILTRO
	Local cRazao	:= Self:RAZAO
	Local cCnpj 	:= Self:CNPJ
	Local aArea		:= GetArea()
	Local nCont		:= 0
	Local cVirg		:= ''
	Local aAux		:= {}

	lRet					:= .T.

	::SetContentType("application/json")
	
	RpcSetType(3)
	RPCSetEnv("01",'0103')
	
	conout("chegou aqui PRTL030")

	DbSelectArea("SC5")
	SC5->(DBSetOrder(1))
	SC5->(DBGoTOP())
	
	DbSelectArea("SC6")
	SC6->(DBSetOrder(1))
	SC6->(DBGoTOP())

	conout(cStatus)
	conout(cEmissao)
	conout(cCliente)
	conout('Pedido ' +If(cCode<>nil,cCode,''))
	conout(cFilter)
	conout(cRazao)
	conout('Vendedor '+CodVend)
	
	If !Empty(cStatus) .Or. !Empty(cEmissao) .Or. !Empty(cCliente)
		cCode := ""
	EndIf

	If !Empty(cCode) .AND. Empty(cFilter)
		cFilpsq := ''

		/*If SC5->(DBSeek(cCode)) //xFilial("SC5")+cCode
			cFilpsq := xFilial("SC5")
		ElseIf SC5->(DBSeek(cCode)) //'0103'+cCode
			cFilpsq := '0103'
		Endif */
		If SC5->(DBSeek(cCode))
			
			::SetResponse('{')
			::SetResponse('"items" : [')
            
            SC6->(DBSeek(SC5->C5_FILIAL+SC5->C5_NUM))
            
            cVirg := ""
			While !EOF() .And. SC6->C6_FILIAL == SC5->C5_FILIAL .AND. SC6->C6_NUM == SC5->C5_NUM
				::SetResponse(cVirg+'{')
                ::SetResponse('"codigo":"'+Alltrim(SC6->C6_PRODUTO)+'",')
                ::SetResponse('"descricao":"'+Alltrim(Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_DESC"))+'",')
                ::SetResponse('"quantidade":"'+cvaltochar(SC6->C6_QTDVEN)+'",')
                ::SetResponse('"valor_unit":"'+Transform(SC6->C6_PRCVEN,"@E 999,999,999.99")+'",')
                ::SetResponse('"valor_total":"'+Transform(SC6->C6_VALOR,"@E 999,999,999.99")+'",')
				::SetResponse('"id":"'+cvaltochar(SC6->(Recno()))+'"')
                ::SetResponse('}')
                cVirg := ',' 
				
				DBSkip()
			EndDo

			::SetResponse(']')
			::SetResponse('}')
		Else
			::SetResponse('{"codigo":"'+cCode+'","Erro":"Pedido nao encontrado"}')
		EndIf
	ELSE
		::SetResponse('{')
		::SetResponse('"items": [')

		If !Empty(cStatus) .Or. !Empty(cEmissao) .Or. !Empty(cCliente)
			cQuery := "SELECT *"
			cQuery += " FROM ( SELECT "
		Else
			cQuery := "SELECT TOP(150) *"
			cQuery += " FROM( SELECT TOP("+If(!Empty(cPage),cvaltochar(val(cPage)*150),'150')+") "
		EndIf

		cQuery += " C5_FILIAL,C5_NUM,C5_CLIENTE,C5_LOJACLI,A1_NOME,A1_NREDUZ,A1_END,A1_MUN,C5_CONDPAG,C5_VEND1,"
		cQuery += " C5_EMISSAO,C5_NOTA,C5_SERIE,C5_OK,C5.R_E_C_N_O_ AS RECC5,A1_CGC"
		cQuery += " FROM "+RetSQLName("SC5")+" C5"
		cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=C5_CLIENTE AND A1_LOJA=C5_LOJACLI AND A1.D_E_L_E_T_=' '"

		If !Empty(cRazao)
			cQuery += " AND A1_NOME LIKE '%"+Alltrim(upper(cRazao))+"%'"
		EndIf 

		If !Empty(cCnpj)
			cQuery += " AND A1_CGC LIKE'%"+Alltrim(cCnpj)+"%'"
		EndIf 

		If !Empty(cCliente)
			cQuery += " AND A1_COD+A1_LOJA = '"+cCliente+"'"
		endIf	

		//cQuery += " WHERE C5_FILIAL='"+xFilial("SC5")+"' AND C5_VEND1='"+CodVend+"' AND C5.D_E_L_E_T_=' '"
		cQuery += " WHERE C5_FILIAL BETWEEN ' ' AND 'ZZ' AND C5_VEND1='"+CodVend+"' AND C5.D_E_L_E_T_=' '"

		If !Empty(cEmissao)
			cQuery += " AND C5_EMISSAO='"+dtos(ctod(cEmissao))+"'"
		ENDIF

		If !Empty(cStatus)
			cQuery += " AND C5_NOTA "+If(cStatus=="Faturado","<>' '","=' '")
		EndIf

		If !Empty(cCode)
			cQuery += " AND C5_NUM='"+cCode+"'"	
		EndIf 

		If !Empty(cStatus) .Or. !Empty(cEmissao) .Or. !Empty(cCliente)
			cQuery += " ) TMP"
		ELSE
			cQuery += " ORDER BY C5_EMISSAO DESC,C5_NUM) TMP"
		ENDIF
		
		cQuery += " ORDER BY C5_EMISSAO DESC,C5_NUM DESC"

		conout(cQuery)

		If Select('TRB') > 0
			dbSelectArea('TRB')
			dbCloseArea()
		EndIf

		DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

		DbSelectArea("TRB")

		While !EOF()
			Aadd(aAux,{	TRB->C5_NUM,TRB->C5_CLIENTE+TRB->C5_LOJACLI,TRB->A1_NOME,;
						TRB->A1_NREDUZ,TRB->C5_EMISSAO,TRB->C5_NOTA,TRB->C5_SERIE,;
						TRB->C5_OK,TRB->RECC5,TRB->A1_CGC,TRB->C5_FILIAL})
			Dbskip()
		EndDo

		Asort(aAux,,,{|x,y| x[2] < y[2]})

		For nCont := 1 to len(aAux)
			cDtFat := ''
			If !Empty(aAux[nCont,06])
				cDtFat := Posicione("SF2",1,aAux[nCont,11]+aAux[nCont,06]+aAux[nCont,07],"F2_EMISSAO")
			EndIf 

			::SetResponse(cVirg+'{')
			::SetResponse('"codigo":"'+aAux[nCont,11]+aAux[nCont,01]+'",')
			::SetResponse('"status":"'+If(!Empty(aAux[nCont,06]),'Faturado em '+cvaltochar(cDtFat),(If(aAux[nCont,08]=="3","Pendencias","Em Aberto")))+'",')
			::SetResponse('"emissao":"'+cvaltochar(stod(aAux[nCont,05]))+'",')
			::SetResponse('"razao_social":"'+Alltrim(aAux[nCont,03])+'",')
			::SetResponse('"cliente":"'+Alltrim(aAux[nCont,04])+'",')
			::SetResponse('"cnpj":"'+Alltrim(aAux[nCont,10])+'",')
			::SetResponse('"nota":"'+Alltrim(aAux[nCont,06])+'",')
			::SetResponse('"serie":"'+Alltrim(aAux[nCont,07])+'",')
			::SetResponse('"id":"'+cvaltochar(aAux[nCont,09])+'",')
			::SetResponse('"dtemisped":"'+aAux[nCont,05]+'"')
			::SetResponse('}')
			cVirg := ','
		Next nCont
		
		::SetResponse(']')
		::SetResponse('}')
	EndIf

	RestArea(aArea)

	
Return lRet
