#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE 'Protheus.ch'
#INCLUDE 'FWMVCDef.ch'

/*/{Protheus.doc} User Function CONESN1
    @type  Function
    @author user
    @since 28/12/2022
    @version 1 
    /*/
User Function CONESN1()

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

	Private cChapa       := ""

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
		EXECSN1(aAux[nX])
    next

Return

Static Function EXECSN1(aAux)
    
	if aAux[1] $ cChapa
		return
	endif

	cChapa += aAux[1] + "/"

    DbSelectArea("SN1")
    RecLock("SN1", .T.)
        SN1->N1_FILIAL  := xFilial("SN1")   
        SN1->N1_PATRIM  := "N"
        SN1->N1_CBASE   := aAux[1]   
        SN1->N1_ITEM    := "0001"   
        SN1->N1_QUANTD  := 1
        SN1->N1_DESCRIC := aAux[2]  
        SN1->N1_CHAPA   := aAux[1]
        SN1->N1_PRODUTO := aAux[3]  
        SN1->N1_XNUMSER := aAux[5]
        SN1->N1_XALUGAD := IF(aAux[6] == "1", "S", "N")
    MsUnlock()
    DBCLOSEAREA()

    DbSelectArea("SN3")
    RecLock("SN3", .T.)
        SN3->N3_FILIAL  := xFilial("SN3")
        SN3->N3_CBASE   := aAux[1]
        SN3->N3_ITEM    := "0001"
        SN3->N3_TIPO    := "01"
        SN3->N3_DINDEPR := dDataBase
        SN3->N3_HISTOR  := "INICIO"
        SN3->N3_CCONTAB := "1000"
        SN3->N3_VORIG1  := val(aAux[4])
    MsUnlock()
    DBCLOSEAREA()

Return 
