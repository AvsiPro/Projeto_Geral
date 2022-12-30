#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE 'Protheus.ch'
#INCLUDE 'FWMVCDef.ch'

/*/{Protheus.doc} User Function CONEXEC020
    @type  Function
    @author user
    @since 27/12/2022
    @version 1 CONTRATO
    /*/
User Function CONESB1()

	// LOCAL oRestClient  := FWRest():New("https://brasilapi.com.br/api")
	// LOCAL oJson        := JsonObject():New()
	// LOCAL cCnpj        := M->A2_CGC
	LOCAL aPerg        := {}
	LOCAL aLinha       := {}
	LOCAL aAux         := {}
	// LOCAL aRet         := {}
	LOCAL cHandle      := ""
	LOCAL cLine        := ""
	LOCAL nRecno       := 0
	LOCAL nHandle      := 0
    Local nX           := 1
    // Local nY           := 1
    Local nLast        := 0

	Private cCod       := ""

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

        if len(aLinha) > 1 .AND. AllTrim(aLinha[1]) != ""
            Aadd(aAux, aLinha)    
        endif

		// Pula para próxima linha
		FT_FSKIP()

	End

	// Fecha o Arquivo
	FT_FUSE()

    for nX := 1 to len(aAux)
        // for nY := 1 to len(aAux[nX])
		// 	if nY == 6
		// 		aAux[nX,nY] := fLimpCarac(aAux[nX,nY])
		// 	endif
        // next
		EXEC010(aAux[nX])
    next

Return

Static Function EXEC010(aAux)

	Local nOpc := 3 // ----> Inclusão
	Local oModel := Nil

	oModel := FWLoadModel("MATA010")

	oModel:SetOperation(nOpc)
	oModel:Activate()

// B1_ORIGEM SOBE COM 0

	if aAux[1] $ cCod
		RETURN
	endif

	cCod += aAux[1] + "/"

    //Cabeçalho
    oModel:SetValue("SB1MASTER","B1_COD"       ,aAux[1])
    oModel:SetValue("SB1MASTER","B1_XCARACT"   ,SubStr(aAux[1],1,1))
    oModel:SetValue("SB1MASTER","B1_XTIPOCN"   ,SubStr(aAux[1],2,3))

    DbSelectArea("Z01")
    DBSEEK(xFilial("Z01")+SubStr(aAux[1],2,3))

    oModel:SetValue("SB1MASTER","B1_XDSCTIP"   ,Z01->Z01_DESCRI)

    DBCLOSEAREA()

    oModel:SetValue("SB1MASTER","B1_XFABRIC"   ,SubStr(aAux[1],5,2))

    DbSelectArea("Z04")
    DBSEEK(xFilial("Z04")+SubStr(aAux[1],5,2))

    oModel:SetValue("SB1MASTER","B1_XDSCFAB"   ,Z04->Z04_DESCRI)

    DBCLOSEAREA()

    oModel:SetValue("SB1MASTER","B1_XSUBTIP"   ,SubStr(aAux[1],7,2))

    DbSelectArea("Z03")
    DBSEEK(xFilial("Z03")+SubStr(aAux[1],7,2))

    oModel:SetValue("SB1MASTER","B1_XDSCSUB"   ,Z03->Z03_DESCRI)

    DBCLOSEAREA()

    oModel:SetValue("SB1MASTER","B1_DESC"      ,SubStr(aAux[2],1,60))
    oModel:SetValue("SB1MASTER","B1_X_DESC"    ,aAux[3])

    DBSELECTAREA("SX5")
    DBSEEK(xFilial("SX5")+"02"+aAux[4])

    oModel:SetValue("SB1MASTER","B1_TIPO"      ,SubStr(SX5->X5_CHAVE,1,2))

    DBCLOSEAREA()

    oModel:SetValue("SB1MASTER","B1_UM"        ,aAux[5])
    oModel:SetValue("SB1MASTER","B1_LOCPAD"    ,StrZero(val(aAux[6]),2))
    oModel:SetValue("SB1MASTER","B1_ORIGEM"    ,aAux[7])
    // oModel:SetValue("SB1MASTER","B1_POSIPI"    ,StrZero(Val(aAux[8]),8))

	If oModel:VldData()
		oModel:CommitData()
    else
        oModel:GetErrorMessage()
	Endif

	oModel:DeActivate()

	oModel:Destroy()

    DbSelectArea("SB1")
    if DBSEEK(xFilial("SB1")+aAux[1])
        RecLock("SB1", .F.)
            SB1->B1_POSIPI := StrZero(Val(aAux[8]),8)
        MsUnlock()
    endif
    DBCLOSEAREA()

Return

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
