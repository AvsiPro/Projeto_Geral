#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FWMVCDEF.CH"
//#INCLUDE "CNTA130.CH"

/*/{Protheus.doc} EMGCTS04
Schedule para integrar via API com cartão de crédito
Especificação Funcional - MIT041 - GCT - RFP - 1.1
@author Desenvolvedores Grupo 377
@since 01.10.2023
/*/
User function EMGCTS04()
	
	Local cQry 				As Character
	Local lJob				As Logical
	Local cJobEmp			As Character
	Local cJobFil			As Character
	Local cAliasA			As Character
	Local oQry				As Object

	aArea		:= GetArea()
	lJob		:= Select( "SX6" ) == 0
	cJobEmp		:= '01'
	cJobFil		:= '0101'

	If lJob
		RpcSetEnv( cJobEmp, cJobFil )
	EndIf

	cQry := ""
	aHeader		:= {}
	cServer		:= SuperGetMv("ES_URLGT" 	,.F.,"https://apisandbox.cieloecommerce.cielo.com.br")
	cResource 	:= SuperGetMv("ES_ERPSKU" 	,.F.,"/erp_sku?ACTION=INSERT")
	cUserAut	:= SuperGetMv("ES_USERGT" 	,.F.,"79c5a351-2e76-449c-91f3-65c772b6332a")
	cPassAut	:= SuperGetMv("ES_PASSGT" 	,.F.,"GAVBXTPEFSXPGJTQLGWTXVKWJFQZOTQTYMNCYSRP")

	AAdd(aHeader, "Content-Type: application/json")
	Aadd(aHeader, "MerchantId "+AllTrim(cUserAut) )
	Aadd(aHeader, "MerchantKey "+AllTrim(cPassAut) )


	DbSelectArea("SE1")

	cQry := " SELECT R_E_C_N_O_ AS RECSE1 FROM ?  "+;
		" WHERE D_E_L_E_T_ <> '*' "+;
		" AND E1_SALDO > 0 "+;
		" AND E1_ZTPPAG = 'CC' "
		//" AND E1_RECORR = 'S' "+;
		
	cQry := ChangeQuery(cQry)
	oQry := FWPreparedStatement():New(cQry)

	oQry:SetUnsafe(1, RetSqlName( "SE1" ))

	cQry 	:= oQry:GetFixQuery()
	cAliasA	:= MPSysOpenQuery( cQry )

	(cAliasA)->(DbGoTop())
	While !(cAliasA)->(Eof())
		SE1->(DbGoTo((cAliasA)->RECSE1))
		cJson := '{'
		cJson += '	"FILIAL": "'+SE1->E1_FILIAL+'",'
		cJson += '	"Identificador único do cliente": "'+SE1->E1_NUM+'",'
		cJson += '	"Número do Cartão de Crédito": "'+SE1->E1_CARTAO+'",'
		cJson += '	"Data de Validade do Cartão de Crédito": "'+SE1->E1_VALIDADE+'",'
		cJson += '	"Nome do Cartão de Crédito": "'+SE1->E1_NOME+'",'
		cJson += '	"Bandeira do Cartão de Crédito": "'+SE1->E1_BANDE+'",'
		cJson += '	"Validador do Cartão de Crédito": "'+SE1->E1_VALID+'",'
		cJson += '	"Valor do pagamento": "'+SE1->E1_VALOR+'",'
		cJson += '	"CPF ou CNPJ do Cartão de Crédito": "'+SE1->E1_COD+'",'
		cJson += '}'

		//Cria Funcao REST
		oRest    	:= FwRest():New(cServer)
		oJsonRes 	:= JsonObject():new()
		oRest:SetPath(cResource)
		oRest:SetPostParams(EncodeUTF8(cJson, "cp1252"))

		If oRest:Post(aHeader)
			FwLogMsg("INFO",,"",FunName(),"","01","Integrado com sucesso",0,0,{})
		Else
			FwLogMsg("INFO",,"",FunName(),"","01",OemToAnsi("Erro na integração"),0,0,{})
			SE1->(RecLock("SE1",.F.))
			SE1->E1_ZNVEZES += 1
			SE1->(MsUnLock())
		EndIf

		(cAliasA)->(DbSkip())
	End
	(cAliasA)->(Dbclosearea())


Return
