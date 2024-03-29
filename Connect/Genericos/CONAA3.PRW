#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE 'Protheus.ch'
#INCLUDE 'FWMVCDef.ch'

/*/{Protheus.doc} User Function CONAA3
    @type  Function
    @author user
    @since 28/12/2022
    @version 1 
    /*/
User Function CONAA3()

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
        // for nY := 1 to len(aAux[nX])
        // if nY == 6
        // aAux[nX,nY] := fLimpCarac(aAux[nX,nY])
        // endif
        // next
        EXECSN12(aAux[nX])
    next

Return

Static Function EXECSN12(aAux)
    
    dbSelectArea("SN1")
    DbSetOrder(2)

    if aAux[1] $ cCod .OR. !DbSeek(xFilial("SN1")+aAux[1])
        MsgAlert("Ativo " + aAux[1] + " n�o encontrado na SN1, ou registro duplicado!", "Erro!")
        return
    endif

    cCod += aAux[1]
    cCod += "/"

    RecLock("NNR", .T.)
        NNR->NNR_CODIGO := aAux[1] //Codigo do Local C Real 2
        NNR->NNR_DESCRI := aAux[1] //Descricao do Local C Real 20
        NNR->NNR_CODCLI := aAux[1] //Codigo do Cliente C Real 6
        NNR->NNR_LOJCLI := aAux[1] //Loja do Cliente C Real 2
        NNR->NNR_TIPO   := "1" //Tipo de Armazem C Real 1
        NNR->NNR_MRP    := "1" //Entra no calculo MRP? C Real 1
        NNR->NNR_ARMALT := "2" //Verifica Saldo Alternativ C Real 1
        NNR->NNR_XEND   := aAux[1]
        NNR->NNR_XBAIRR := aAux[1]
        NNR->NNR_XMUN   := aAux[1]
        NNR->NNR_XCEP   := aAux[1]
    MsUnlock()

    RecLock("AA3", .T.)                                        
        AA3->AA3_FILIAL := xFilial("AA3")               
        AA3->AA3_CODCLI := aAux[1]               
        AA3->AA3_LOJA   := aAux[1]
        AA3->AA3_NOMCLI := Posicione("SA1",1,xFilial("SA1")+aAux[1]+aAux[2],"A1_NOME")
        AA3->AA3_CODPRO := aAux[1]
        AA3->AA3_DESPRO := Posicione("SB1",1,xFilial("SB1")+aAux[1],"B1_DESC")
        AA3->AA3_NUMSER := aAux[1]
        AA3->AA3_DTVEN  := dDataBase
        AA3->AA3_DTGAR  := dDataBase
        AA3->AA3_CBASE  := aAux[1]
        AA3->AA3_ITEM   := '0001'
        AA3->AA3_CHAPA  := aAux[1]
        AA3->AA3_EQALOC := "2"
        AA3->AA3_MANPRE := "2"
        AA3->AA3_EQ3    := "2"
        AA3->AA3_FILORI := xFilial(AA3)
        AA3->AA3_EXIGNF := "1"
        AA3->AA3_OSMONT := "2"
        AA3->AA3_HMEATV := "2"
        AA3->AA3_STATUS := "01"
        AA3->AA3_DESSTA := "EQUIPAMENTO EM CLIENTE"
        AA3->AA3_MSBLQL := "2"
        AA3->AA3_XPTVEN := ""
    MsUnlock()

    RecLock("AA4", .T.)
        AA4->AA4_FILIAL := xFilial("AA4") //Filial do Sistema C Real 2
        AA4->AA4_CODCLI := aAux[1] //Codigo do Cliente C Real 6
        AA4->AA4_LOJA   := aAux[1] //Loja do Cliente C Real 2
        AA4->AA4_CODPRO := aAux[1] //Codigo do Produto/Eqto C Real 15
        AA4->AA4_NUMSER := aAux[1] //Ident. Unico C Real 20
        AA4->AA4_PRODAC := aAux[1] //Produto / Acessorio C Real 15
        AA4->AA4_NSERAC := aAux[1] //Acs Ident. Unico Acessorio C Real 20
        AA4->AA4_DTINST := dDataBase //Data da Instalacao D Real 8
        AA4->AA4_DTGAR  := dDataBase //Data de Garantia D Real 8
    MsUnlock()

    RecLock("SN1", .F.)
        SN1->N1_XCLIENT := aAux[1]
        SN1->N1_XLOJA   := aAux[1]
    MsUnlock()
    
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
