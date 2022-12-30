#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "TbiConn.ch"

/*/{Protheus.doc} User Function CONEXEC020
    @type  Function
    @author user
    @since 27/12/2022
    @version 1
    /*/
User Function CONESA2()

	LOCAL oRestClient  := FWRest():New("https://brasilapi.com.br/api")
	LOCAL oJson        := JsonObject():New()
	// LOCAL cCnpj        := M->A2_CGC
	LOCAL aPerg        := {}
	LOCAL aLinha       := {}
	LOCAL aAux         := {}
	LOCAL aRet         := {}
	LOCAL cHandle      := ""
	LOCAL cLine        := ""
	LOCAL nRecno       := 0
	LOCAL nHandle      := 0
    Local nX           := 1
    Local nLast        := 0

	If Empty(FunName())
		RpcSetType(3)
		RPCSetEnv("01","0101")
	EndIf

	aAdd(aPerg,{6,"Buscar arquivo",Space(50),"","","",50,.T.,"Arquivos compativeis (*.csv*) |*.csv*"})

	If ParamBox(aPerg, "Informe o arquivo desejado!")

		cHandle  := MV_PAR01

	else
		MsgAlert("Operacao abortada!", "Erro!")
		RETURN
	ENDIF

	nHandle := FT_FUSE(cHandle)

	// Se houver erro de abertura abandona processamento
	if nHandle = -1
		return
	endif

	// Posiciona na primeria linha
	FT_FGoTop()

	// Retorna o número de linhas do arquivo
	nLast := FT_FLastRec()

	While !FT_FEOF()

		nRecno := FT_FRecno()

		if nRecno == 1
			FT_FSKIP()
			nRecno := FT_FRecno()
		endif

		cLine := FT_FReadLn()

		aLinha  := Separa(cLine,';',.T.)

        if len(aLinha) > 1
            Aadd(aAux, {aLinha[2]})    
        endif

		// Pula para próxima linha
		FT_FSKIP()

	End

	// Fecha o Arquivo
	FT_FUSE()

    for nX := 1 to len(aAux)

        cCnpj := StrTran(StrTran(StrTran(StrTran(aAux[nX,1], " ", ""), "-", ""), ".", ""), "/", "")

        oRestClient  := FWRest():New("https://brasilapi.com.br/api")
        oRestClient:setPath("/cnpj/v1/" + cCnpj)
        
        IF oRestClient:Get()

            oJson:FromJson(oRestClient:CRESULT)

            aadd(aAux[nX], SubStr(oJson["razao_social"], 1, 40))
            aadd(aAux[nX], SubStr(oJson["razao_social"], 1, 20))
            aadd(aAux[nX], SubStr(oJson["descricao_tipo_de_logradouro"] + " " + oJson["logradouro"] + " " + oJson["numero"], 1, 80))
            aadd(aAux[nX], oJson["bairro"])
            aadd(aAux[nX], oJson["uf"])
            aadd(aAux[nX], SubStr(cValToChar(oJson["codigo_municipio_ibge"]), 3))
            aadd(aAux[nX], oJson["municipio"])
            aadd(aAux[nX], oJson["cep"])
            aadd(aAux[nX], substr(oJson["ddd_telefone_1"], 3))
            aadd(aAux[nX], substr(oJson["ddd_telefone_1"], 1, 2))
            aadd(aAux[nX], oJson["email"])
        ELSE
            MsgAlert("Não foi possível consultar o CNPJ:" + cCnpj + ".", "Erro!")
        ENDIF

        FreeObj(oRestClient)
    next

    for nX := 1 to len(aAux)
        if len(aAux[nX]) > 1
            aAux[nX,1] := StrTran(StrTran(StrTran(StrTran(aAux[nX,1], " ", ""), "-", ""), ".", ""), "/", "")
            Aadd(aRet, aAux[nX])
        endif
    next

    for nX := 1 to len(aRet)
        EXEC020(aRet[nX])
    next

Return

Static Function EXEC020(aAux)

	Local nOpc := 3 // ----> Inclusão
	Local oModel := Nil

    if aAux[12] == Nil
        aAux[12] := "SEM EMAIL"
    endif

	oModel := FWLoadModel('MATA020')

	oModel:SetOperation(nOpc)
	oModel:Activate()

    //Cabeçalho
	oModel:SetValue('SA2MASTER','A2_COD' ,SubStr(aAux[1],1,8))      //aAux[1]
	oModel:SetValue('SA2MASTER','A2_LOJA' ,SubStr(aAux[1],9,4))    //aAux[2]
	oModel:SetValue('SA2MASTER','A2_NOME' ,aAux[2])    //aAux[3]
	oModel:SetValue('SA2MASTER','A2_NREDUZ' ,aAux[3]) //aAux[4]
	oModel:SetValue('SA2MASTER','A2_END' ,aAux[4])      //aAux[5]
	oModel:SetValue('SA2MASTER','A2_BAIRRO' ,aAux[5]) //aAux[6]
	oModel:SetValue('SA2MASTER','A2_EST' ,aAux[6])      //aAux[7]
	oModel:SetValue('SA2MASTER','A2_COD_MUN',aAux[7]) //aAux[8]
	oModel:SetValue('SA2MASTER','A2_MUN' ,aAux[8])      //aAux[9]
	oModel:SetValue('SA2MASTER','A2_CGC' ,aAux[1])      //aAux[10]
	oModel:SetValue('SA2MASTER','A2_TIPO' ,"J")      //aAux[9]
	oModel:SetValue('SA2MASTER','A2_CEP' ,aAux[9])      //aAux[9]
	oModel:SetValue('SA2MASTER','A2_TEL' ,"J")      //aAux[9]
	oModel:SetValue('SA2MASTER','A2_PAIS' ,"105")      //aAux[9]
	oModel:SetValue('SA2MASTER','A2_EMAIL' ,aAux[12])      //aAux[9]

	If oModel:VldData()
		oModel:CommitData()
	Endif

	oModel:DeActivate()

	oModel:Destroy()

Return
