#INCLUDE 'totvs.ch'
#INCLUDE 'protheus.ch'

User Function zCNPJSA2()
    
	LOCAL oModelx        :=    FWModelActive()
	LOCAL oRestClient    :=    FWRest():New("https://brasilapi.com.br/api")
	LOCAL oJson          :=    JsonObject():New()
	LOCAL cCnpj          :=    M->A2_CGC
	LOCAL aAdependency

	aAdependency := omodelx:ADEPENDENCY

	oModelxDet := oModelx:GetModel(aAdependency[1,1])
	cCnpj := StrTran(StrTran(StrTran(StrTran(cCnpj, " ", ""), "-", ""), ".", ""), "/", "")

	oRestClient:setPath("/cnpj/v1/" + cCnpj)
	IF oRestClient:Get()

		oJson:FromJson(oRestClient:CRESULT)

		oModelxDet:SetValue('A2_NOME',SubStr(oJson["razao_social"], 1, 40)) 
		oModelxDet:SetValue('A2_NREDUZ',SubStr(oJson["razao_social"], 1, 20)) 
		oModelxDet:SetValue('A2_BAIRRO',oJson["bairro"])
		oModelxDet:SetValue('A2_END',SubStr(oJson["descricao_tipo_de_logradouro"] + " " + oJson["logradouro"] + " " + oJson["numero"], 1, 80))
		oModelxDet:SetValue('A2_EST',oJson["uf"])
		oModelxDet:SetValue('A2_CEP',oJson["cep"])
		oModelxDet:SetValue('A2_COD_MUN',cValToChar(oJson["codigo_municipio"]))
		oModelxDet:SetValue('A2_MUN',oJson["municipio"])
		oModelxDet:SetValue('A2_TEL',substr(oJson["ddd_telefone_1"], 3))
		oModelxDet:SetValue('A2_DDD',substr(oJson["ddd_telefone_1"], 1, 2))

	ELSE
		MsgAlert("Não foi possível consultar o CNPJ:" + cCnpj + ".", "Erro!")
	ENDIF

	FreeObj(oRestClient)
Return 
