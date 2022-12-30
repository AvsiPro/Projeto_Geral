#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE 'Protheus.ch'
#INCLUDE 'FWMVCDef.ch'

/*/{Protheus.doc} User Function CONEAAM
    @type  Function
    @author user
    @since 28/12/2022
    @version 1 
    /*/
User Function CONEAAM()

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
		EXECAAM(aAux[nX])
    next

Return

Static Function EXECAAM(aAux)
    
    DbSelectArea("AAM")
    RecLock("AAM", .T.)
        AAM->AAM_FILIAL := xFilial("AAM")
        AAM->AAM_CONTRT := GetSXENum("AAM","AAM_CONTRT")
        AAM->AAM_CODCLI := aAux[1]
        AAM->AAM_LOJA   := aAux[2]
        AAM->AAM_TPCONT := aAux[3]
        AAM->AAM_INIVIG := aAux[4]
        AAM->AAM_FIMVIG := aAux[5]
        AAM->AAM_CPAGPV := aAux[7]
        AAM->AAM_XFORFA := aAux[8]
        AAM->AAM_XTIPFA := aAux[9]
        AAM->AAM_XTIPMI := aAux[10]
        AAM->AAM_XQTVLM := aAux[11]
        AAM->AAM_XCODTA := "001"
        AAM->AAM_XPRDCM := "DOSE COMP"
        AAM->AAM_CLASSI := "003"
        AAM->AAM_ABRANG := "1"
        AAM->AAM_STATUS := "1"
        AAM->AAM_REAAUT := "2"
        AAM->AAM_SELSER := "1"
        AAM->AAM_TAXCTR := "1"
        AAM->AAM_AGRNFC := "1"
        AAM->AAM_AJUOBR := "2"
        AAM->AAM_PCRPRD := "1"
        AAM->AAM_ESTAGR := "1"
    MsUnlock()

    DbSelectArea("AAN")
    RecLock("AAN", .T.)
		AAN->AAN_FILIAL := xFilial("AAN")
		AAN->AAN_CODPRO := "CONTRATO"
		AAN->AAN_DESCRI := "CONTRATO NOVO"
		AAN->AAN_QTD    := 1
    MsUnlock()

Return 
