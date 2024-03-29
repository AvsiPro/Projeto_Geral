#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "TbiConn.ch"

/*/{Protheus.doc} User Function CONEXEC020
    @type  Function
    @author user
    @since 27/12/2022
    @version 1
    /*/
User Function CONESA1()

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
    Local nY           := 1
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

	// Retorna o n�mero de linhas do arquivo
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

		// Pula para pr�xima linha
		FT_FSKIP()

	End

	// Fecha o Arquivo
	FT_FUSE()

    for nX := 1 to len(aAux)
        for nY := 1 to len(aAux[nX])
			if !(nY == 6 .OR. nY == 30)	
				aAux[nX,nY] := fLimpCarac(aAux[nX,nY])
			endif
        next
		EXEC030(aAux[nX])
    next

Return

Static Function EXEC030(aAux)

	Local nOpc := 3 // ----> Inclus�o
	Local oModel := Nil

	oModel := FWLoadModel("MATA030")

	oModel:SetOperation(nOpc)
	oModel:Activate()

	// DbSelectArea("SA1")
	// DbSetOrder(1)
	// if DBSEEK(xFilial("SA1")+aAux[1]+StrZero(val(aAux[2]), 4))
	// 	RETURN
	// endif

	if SubStr(aAux[1],1,9) + StrZero(val(aAux[2]),4) $ cCod
		RETURN
	endif

	cCod += SubStr(aAux[1],1,9) + StrZero(val(aAux[2]),4) + "/"

    //Cabe�alho
	oSA1Mod:= oModel:getModel("MATA030_SA1")
    oSA1Mod:setValue( "A1_COD",     SubStr(aAux[1],1,9) )                                     // Codigo 
    oSA1Mod:setValue( "A1_LOJA",    StrZero(val(aAux[2]), 4) )                                // Loja
    oSA1Mod:setValue( "A1_NOME",    SubStr(aAux[3],1,40) )                                    // Nome             
    oSA1Mod:setValue( "A1_PESSOA",  aAux[4] )                                                 // Pessoa F ou J
    oSA1Mod:setValue( "A1_NREDUZ",  SubStr(aAux[5],1,20) )                                    // Nome reduz. 
    oSA1Mod:setValue( "A1_END",     aAux[6] )                                                 // Endereco
    oSA1Mod:setValue( "A1_BAIRRO",  aAux[7] )                                                 // Bairro
    oSA1Mod:setValue( "A1_TIPO",    aAux[8] )                                                 // Tipo 
    oSA1Mod:setValue( "A1_EST",     aAux[9] )                                                 // Estado
    oSA1Mod:setValue( "A1_COD_MUN", Posicione("CC2",2,xFilial("CC2")+aAux[12],"CC2_CODMUN") ) // Codigo Municipio                
    oSA1Mod:setValue( "A1_MUN",     aAux[12] )                                                // Municipio
    oSA1Mod:setValue( "A1_CEP",     aAux[10] )                                                // CEP
    oSA1Mod:setValue( "A1_INSCR",   IF(aAux[19] == '',"ISENTO",aAux[19]) )                    // Inscricao Estadual
    oSA1Mod:setValue( "A1_CGC",     aAux[17] )                                                // CNPJ/CPF            
    oSA1Mod:setValue( "A1_PAIS",    "105" )                                                   // Pais            
    oSA1Mod:setValue( "A1_EMAIL",   IF(aAux[30] == "","SEM EMAIL",aAux[30]) )                 // E-Mail
    oSA1Mod:setValue( "A1_DDD",     SubStr(IF(aAux[16] == '',"99999999",aAux[16]),1,2) )      // DDD            
    oSA1Mod:setValue( "A1_TEL",     IF(aAux[16] == '',"99999999",SubStr(aAux[16],1,15)) )     // Fone                 
    oSA1Mod:setValue( "A1_BAIRROC", SubStr(aAux[22],1,30) )                                   // Bairro Cobran�a
    oSA1Mod:setValue( "A1_CEPC",    aAux[23] )                                                // CEP Cobran�a
    oSA1Mod:setValue( "A1_MUNC",    SubStr(aAux[24],1,15) )                                   // Munic�pio Cobran�a
    oSA1Mod:setValue( "A1_ESTC",    aAux[25] )                                                // Estado Cobran�a
    oSA1Mod:setValue( "A1_CEPE",    aAux[26] )                                                // CEP Entrega
    oSA1Mod:setValue( "A1_BAIRROE", SubStr(aAux[27],1,20) )                                   // Bairro Entrega
    oSA1Mod:setValue( "A1_MUNE",    SubStr(aAux[28],1,15) )                                   // Munic�pio Entrega
    oSA1Mod:setValue( "A1_ESTE",    aAux[29] )                                                // Estado Entrega

	If oModel:VldData()
		oModel:CommitData()
    else
        oModel:GetErrorMessage()
	Endif

	oModel:DeActivate()

	oModel:Destroy()

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
	cConteudo := StrTran(cConteudo, '�', '')
	cConteudo := StrTran(cConteudo, '�', '')
	cConteudo := StrTran(cConteudo, "�", "A")
	cConteudo := StrTran(cConteudo, "�", "E")
	cConteudo := StrTran(cConteudo, "�", "I")
	cConteudo := StrTran(cConteudo, "�", "O")
	cConteudo := StrTran(cConteudo, "�", "U")
	cConteudo := StrTran(cConteudo, "�", "A")
	cConteudo := StrTran(cConteudo, "�", "E")
	cConteudo := StrTran(cConteudo, "�", "I")
	cConteudo := StrTran(cConteudo, "�", "O")
	cConteudo := StrTran(cConteudo, "�", "U")
	cConteudo := StrTran(cConteudo, "�", "A")
	cConteudo := StrTran(cConteudo, "�", "O")
	cConteudo := StrTran(cConteudo, "�", "A")
	cConteudo := StrTran(cConteudo, "�", "O")
	cConteudo := StrTran(cConteudo, "�", "A")
	cConteudo := StrTran(cConteudo, "�", "E")
	cConteudo := StrTran(cConteudo, "�", "I")
	cConteudo := StrTran(cConteudo, "�", "O")
	cConteudo := StrTran(cConteudo, "�", "U")
	cConteudo := StrTran(cConteudo, "�", "A")
	cConteudo := StrTran(cConteudo, "�", "E")
	cConteudo := StrTran(cConteudo, "�", "I")
	cConteudo := StrTran(cConteudo, "�", "O")
	cConteudo := StrTran(cConteudo, "�", "U")
	cConteudo := StrTran(cConteudo, "�", "C")
	cConteudo := StrTran(cConteudo, "�", "C")
	cConteudo := StrTran(cConteudo, "�", "A")
	cConteudo := StrTran(cConteudo, "�", "A")
	cConteudo := StrTran(cConteudo, "�", ".")
	cConteudo := StrTran(cConteudo, "�", ".")
	cConteudo := StrTran(cConteudo, "�", "I")
	cConteudo := StrTran(cConteudo, "A�A�", "CA")

	//Se n�o for endere�o, retira tamb�m o - e a ,
	If !lEndereco
		cConteudo := StrTran(cConteudo, ",", "")
		cConteudo := StrTran(cConteudo, "-", "")
	EndIf

	RestArea(aArea)

Return cConteudo
