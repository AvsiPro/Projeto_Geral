#INCLUDE "Totvs.ch"
#INCLUDE "protheus.ch"

USER FUNCTION zCNPJSA1()

	LOCAL oModelx        :=    FWModelActive()
	LOCAL oRestClient    :=    FWRest():New("https://brasilapi.com.br/api")
	LOCAL o1RestClient   :=    FWRest():New("https://publica.cnpj.ws/cnpj")
	LOCAL oJson          :=    JsonObject():New()
	LOCAL oJson1         :=    JsonObject():New()
	LOCAL cCnpj          :=    M->A1_CGC
	LOCAL aAdependency

	aAdependency := omodelx:ADEPENDENCY

	oModelxDet := oModelx:GetModel(aAdependency[1,1])
	cCnpj := StrTran(StrTran(StrTran(StrTran(cCnpj, " ", ""), "-", ""), ".", ""), "/", "")

	oRestClient:setPath("/cnpj/v1/" + cCnpj)
	o1RestClient:setPath("/" + cCnpj)
	IF oRestClient:Get()

		oJson:FromJson(oRestClient:CRESULT)

		oModelxDet:SetValue('A1_NOME',SubStr(oJson["razao_social"], 1, 40)) 
		oModelxDet:SetValue('A1_NREDUZ',SubStr(oJson["razao_social"], 1, 20)) 
		oModelxDet:SetValue('A1_BAIRRO',oJson["bairro"])
		oModelxDet:SetValue('A1_END',SubStr(oJson["descricao_tipo_de_logradouro"] + " " + oJson["logradouro"] + " " + oJson["numero"], 1, 80))
		oModelxDet:SetValue('A1_EST',oJson["uf"])
		oModelxDet:SetValue('A1_CEP',oJson["cep"])
		oModelxDet:SetValue('A1_COD_MUN',cValToChar(oJson["codigo_municipio"]))
		oModelxDet:SetValue('A1_MUN',oJson["municipio"])
		oModelxDet:SetValue('A1_TEL',substr(oJson["ddd_telefone_1"], 3))
		oModelxDet:SetValue('A1_DDD',substr(oJson["ddd_telefone_1"], 1, 2))
		oModelxDet:SetValue('A1_COD_MUN',SubStr(cValToChar(oJson["codigo_municipio_ibge"]), 3))
		oModelxDet:SetValue('A1_TIPO',"F")

		if o1RestClient:Get()

			oJson1:FromJson(o1RestClient:CRESULT)
			if len(oJson1["estabelecimento","inscricoes_estaduais"]) > 0
				oModelxDet:SetValue('A1_INSCR',oJson1["estabelecimento","inscricoes_estaduais",1,"inscricao_estadual"])	
			endif
					
		endif

	ELSE
		MsgAlert("Não foi possível consultar o CNPJ:" + cCnpj + ".", "Erro!")
	ENDIF

	FreeObj(oRestClient)
RETURN


