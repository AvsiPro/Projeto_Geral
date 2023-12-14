#INCLUDE 'PROTHEUS.CH'

/*
    Validação do cnpj digitado em clientes e fornecedores
    MIT 44_FIN025_Financeiro_validação Situação CNPJ_

    Doc Mit
    https://docs.google.com/document/d/1imKeAR8nz74uzzmSI91bKU_HoZKgKY2P/edit
    Doc Entrega
    
    
*/

User Function JGENX003(cCnpjInf)

Local aArea := GetArea()
Local aListCli := {}
Local cMsg  :=  ""

cSearch := cCnpjInf

fConsulBraApi(cSearch, @aListCli)

If len(aListCli) > 0
    If aListCli[12] <> "2"
        cMsg := "Atenção para a situação cadastral para o CNPJ informado"+CRLF 
        cMsg += "Código Situação "+aListCli[12]+CRLF 
        cMsg += aListCli[14]+CRLF
        cMsg += aListCli[15]+CRLF 
        cMsg += "Data da atualização cadastral "+cvaltochar(aListCli[13])

        MsgAlert(cMsg)
    EndIf
EndIf 

RestArea(aArea)

Return 
/*/{Protheus.doc} User Function nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 26/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function fConsulBraApi(cSearch, aListCli)
			
	oRestClient  := FWRest():New("https://brasilapi.com.br/api")
	oRestClient:setPath("/cnpj/v1/" + cSearch)

	If oRestClient:Get()
		oJsonCNPJ := JsonObject():New()
		oJsonCNPJ:FromJson(oRestClient:CRESULT)

		aAdd(aListCli , JsonObject():New() )

		cIdAux := '{"SA1",'+;
			'"Nao Cadastrado",'+;
			'"'+Alltrim(EncodeUTF8(oJsonCNPJ["cnpj"]))+'"'+;
		'}'
		
		//fGeraResult(;
			//@aListCli,;
			//1,;
			aListCli := {;
				Encode64(cIdAux),;
				Alltrim(EncodeUTF8(SubStr(oJsonCNPJ["descricao_tipo_de_logradouro"] + " " + oJsonCNPJ["logradouro"] + " " + oJsonCNPJ["numero"], 1, 80))),;
				Alltrim(EncodeUTF8(oJsonCNPJ["bairro"])),;
				Alltrim(EncodeUTF8(oJsonCNPJ["complemento"])),;
				Alltrim(EncodeUTF8(oJsonCNPJ["cnpj"])),;
				Alltrim(EncodeUTF8(oJsonCNPJ["razao_social"])),;
				Alltrim(EncodeUTF8(oJsonCNPJ["nome_fantasia"])),;
				Alltrim(EncodeUTF8(oJsonCNPJ["municipio"])),;
				Alltrim(EncodeUTF8(oJsonCNPJ["uf"])),;
				Alltrim(EncodeUTF8(oJsonCNPJ["cep"])),;
				Alltrim(EncodeUTF8(oJsonCNPJ["ddd_telefone_1"])),;
				EncodeUTF8(cvaltochar(oJsonCNPJ["situacao_cadastral"])),;
				stod(strtran(oJsonCNPJ["data_situacao_cadastral"],"-")),;
				Alltrim(EncodeUTF8(oJsonCNPJ["descricao_situacao_cadastral"])),;
				Alltrim(EncodeUTF8(oJsonCNPJ["descricao_motivo_situacao_cadastral"]));
			};
		//)
	EndIf

Return

/*/{Protheus.doc} User Function nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 26/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function fGeraResult(aListCli, nAux, aListAux)

	aListCli[nAux]['id']	            	:= aListAux[1]
	aListCli[nAux]['code']	            	:= aListAux[2]
	aListCli[nAux]['branch']            	:= aListAux[3]
	aListCli[nAux]['address']           	:= aListAux[4]
	aListCli[nAux]['district']          	:= aListAux[5]
	aListCli[nAux]['complement']        	:= aListAux[6]
	aListCli[nAux]['cnpj']              	:= aListAux[7]
	aListCli[nAux]['state_regist']      	:= aListAux[8]
	aListCli[nAux]['name']              	:= aListAux[9]
	aListCli[nAux]['short_name']        	:= aListAux[10]
	aListCli[nAux]['city']              	:= aListAux[11]
	aListCli[nAux]['uf']                	:= aListAux[12]
	aListCli[nAux]['cep']               	:= aListAux[13]
	aListCli[nAux]['contact']           	:= aListAux[14]
	aListCli[nAux]['email']             	:= aListAux[15]
	aListCli[nAux]['phone']             	:= aListAux[16]
	aListCli[nAux]['last_purchase']     	:= aListAux[17]
	aListCli[nAux]['first_purchase']    	:= aListAux[18]
	aListCli[nAux]['risk']              	:= aListAux[19]
	aListCli[nAux]['credit_limit']      	:= aListAux[20]
	aListCli[nAux]['balance']           	:= aListAux[21]
	aListCli[nAux]['biggest_purchase']  	:= aListAux[22]
	aListCli[nAux]['amount_purchases']  	:= aListAux[23]
	aListCli[nAux]['amount_delays']     	:= aListAux[24]
	aListCli[nAux]['biggest_delays']    	:= aListAux[25]
	aListCli[nAux]['late_payments']     	:= aListAux[26]
	aListCli[nAux]['financial']				:= '' //fTitulos(aListAux[2],aListAux[3])
	aListCli[nAux]['another_address']   	:= ''
	aListCli[nAux]['another_cep']   		:= ''
	aListCli[nAux]['another_district']  	:= ''
	aListCli[nAux]['payment']  				:= aListAux[27]
	aListCli[nAux]['payment_description']  	:= aListAux[28]
	aListCli[nAux]['allowed_region']  	  	:= aListAux[29]
	aListCli[nAux]['priceTable']  	  		:= aListAux[30]

Return
