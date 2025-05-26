// Bibliotecas necess�rias
#Include "TOTVS.ch"
#Include "MSOLE.ch"

// Constantes do fonte
#Define SLASH_REMOTE     IIf(CValToChar(GetRemoteType()) $ "-1|2", "\", "/")
#Define SLASH_SERVER     IIf(IsSrvUnix(), "/", "\")
#Define OLEWDVISIBLE     "206"
#Define OLEWDWINDOWSTATE "207"
#Define OLEWDPRINTBACK   "208"

/*/{Protheus.doc} FT600IMP
    Ponto de entrada para impress�o customizada da proposta comercial.
    Na aus�ncia deste ponto a rotina padr�o FATR600 � acionada para gerar as impress�es.
    @type Function
    @version 12.1.27
    @author Natalia Perioto
    @since 08/10/2020
    @return Variant, Retorno nulo fixado
    @link https://tdn.totvs.com/pages/releaseview.action?pageId=254608590
    @obs Fun��o refatorada por Guilherme Bigois em 04/09/2022
/*/
User Function FT600IMP() As Variant
    // Vari�veis locais
    Local aArea     := {FwGetArea()}            // Conjunto de �reas e seus estados antes do desposicionamento
    Local aResponse := {}                       // Respostas do usu�rio na ParamBox() exibida
    Local nX        := 0                        // Contador de tabelas para restaura��o
    Local nAmount   := 0                        // Contador de documentos a serem impressos
    Local cTitle    := "Impress�o de propostas" // T�tulo das caixas de di�logo

    // Vari�veis privadas
    Private cProposta   := ADY->ADY_PROPOS
    Private cPRevisa    := ADY->ADY_PREVIS
    Private cDtEmissao  := DToC(ADY->ADY_DATA)
    Private cCodigo     := ADY->ADY_CODIGO
    Private cLoja       := ADY->ADY_LOJA
    Private cContra     := AD1->AD1_XNCTR
    Private cObsF       := ADY->ADY_OBS
    Private cObsRH      := MSMM(AD1->AD1_CODMEM)
    Private cNomVend    := Posicione("SA3", 1, FwXFilial("SA3") + ADY->ADY_VEND, "A3_NOME")
    Private cNome       := ""
    Private cEndereco   := ""
    Private cBairro     := ""
    Private cCidade     := ""
    Private cUF         := ""
    Private cDescEnt    := ""
    Private cCont       := ""
    Private cMailC      := ""
    Private cFoneC      := ""
    Private cCEP        := ""
    Private cCGC        := ""
    Private cInsc       := ""
    Private cVlrAn      := ""
    Private cVlrLib     := ""
    Private cVlrFrota   := ""
    Private cVlrMon     := ""
    Private cVlrBase    := ""
    Private cVlrCheck   := ""
    Private cVlrSof     := ""
    Private cVlrTor     := ""
    Private cVlrMob     := ""
    Private cVlrPrev    := ""
    Private cVlrCRC     := ""
    Private cVlrRat     := ""
    Private cVlrDed     := ""
    Private cVlrPA      := ""
    Private cVlrEst     := ""
    Private cVlrPrj     := ""
    Private cVlrLibF    := ""
    Private cVlrBaseF   := ""
    Private cVlrPAF     := ""
    Private cVlrBLOG    := ""
    Private cVlrAna     := ""
    Private cVlrEsc     := ""
    Private cVlrMRot    := ""
    Private cBkOff      := ""
    Private cViagemAv   := ""
    Private cBaseExt    := ""
    Private cCoordLog   := ""
    Private cVlrCol     := ""
    Private cVlrGIA     := ""
    Private cVlrSIP     := ""
    Private cVlrBDL     := ""
    Private cVlrCus     := ""
    Private cVlrTrn     := ""
    Private cVlrAnSin   := ""
    Private cVlrBco     := ""
    Private cVlrHReX    := ""
    Private cVlrADE     := ""
    Private cVlrImp     := ""
    Private cVlrPre     := ""
    Private cVlrSup     := ""
    Private cVlrSupLg   := ""
    Private cVlrHrt     := ""
    Private cVlrSDE     := ""
    Private cServs      := ""
    Private cVlrRDO     := ""
    Private cVlrBrl     := ""
    Private cVlrPav     := ""
    Private cVlrCoe     := ""
    Private cVlrBse     := ""
    Private cVlrItBRLog := ""
    Private cVlrSpLgEx  := ""
    Private aDescPrd    := {}
    Private cVlrVazio   := "R$ 0,00"
    Private lAbortPrint := .F.

    // Inicia a sequ�ncia de processamento
    BEGIN SEQUENCE
        // Exibe as perguntas ao usu�rio
        aResponse := QuestionDef()

        // Pausa a execu��o do processo se os par�metros n�o forem preenchidos
        If (Len(aResponse) == 0)
            BREAK
        EndIf

        // Busca dados do cliente ou prospect
        If (ADY->ADY_ENTIDA == "1")
            // Posiciona no cliente contido na proposta
            DBSelectArea("SA1")
            AAdd(aArea, FwGetArea())
            DBSetOrder(1)
            MsSeek(FwXFilial("SA1") + ADY->ADY_CODIGO + ADY->ADY_LOJA)

            // Gera exce��o se o cliente da proposta n�o for encontrado
            If (!Found())
                Help(NIL, NIL, "FT600IMP_CUSTOMER_NOT_FOUND", NIL, "O cliente " +  AllTrim(ADY->ADY_CODIGO) + "|" + AllTrim(ADY->ADY_LOJA) + " n�o foi encontrado na tabela SA1.",;
                    1, 0, NIL, NIL, NIL, NIL, .T., {"Entre em contato com o administrador do sistema para verificar o motivo da inexist�ncia do mesmo."})
                BREAK
            EndIf

            // Captura os dados do cliente
            cNome     := Replace(AllTrim(SA1->A1_NOME), "  ", " ")
            cEndereco := AllTrim(SA1->A1_END)
            cBairro   := AllTrim(SA1->A1_BAIRRO)
            cCidade   := AllTrim(SA1->A1_MUN)
            cUF       := AllTrim(SA1->A1_EST)
            cDescEnt  := AllTrim(SA1->A1_NREDUZ)
            cCEP      := AllTrim(SA1->A1_CEP)
            cCGC      := AllTrim(SA1->A1_CGC)
            cInsc     := Alltrim(SA1->A1_INSCR)
        Else
            // Posiciona no prospect contido na proposta
            DBSelectArea("SUS")
            AAdd(aArea, FwGetArea())
            DBSetOrder(1)
            MsSeek(FwXFilial("SUS") + ADY->ADY_CODIGO + ADY->ADY_LOJA)

            // Gera exce��o se o prospect da proposta n�o for encontrado
            If (!Found())
                Help(NIL, NIL, "FT600IMP_PROSPECT_NOT_FOUND", NIL, "O prospect " +  AllTrim(ADY->ADY_CODIGO) + "|" + AllTrim(ADY->ADY_LOJA) + " n�o foi encontrado na tabela SUS.",;
                    1, 0, NIL, NIL, NIL, NIL, .T., {"Entre em contato com o administrador do sistema para verificar o motivo da inexist�ncia do mesmo."})
                BREAK
            EndIf

            // Captura os dados do prospect
            cNome     := AllTrim(SUS->US_NOME)
            cEndereco := AllTrim(SUS->US_END)
            cBairro   := AllTrim(SUS->US_BAIRRO)
            cCidade   := AllTrim(SUS->US_MUN)
            cUF       := AllTrim(SUS->US_EST)
            cDescEnt  := AllTrim(SUS->US_NREDUZ)
            cCEP      := AllTrim(SUS->US_CEP)
            cCGC      := AllTrim(SUS->US_CGC)
        EndIf

        // Posiciona no contato da oportunidade
        DBSelectArea("AD9")
        AAdd(aArea, FwGetArea())
        DBSetOrder(1)
        MsSeek(FwXFilial("AD9") + ADY->ADY_OPORTU)

        // Posiciona no contato contido na oportunidade
        If (Found())
            DBSelectArea("SU5")
            AAdd(aArea, FwGetArea())
            DBSetOrder(1)
            MsSeek(FwXFilial("SU5") + AD9->AD9_CODCONT)

            // Gera exce��o se o contato da oportunidade n�o for encontrado
            If (!Found())
                Help(NIL, NIL, "FT600IMP_CONTACT_NOT_FOUND", NIL, "O contato " +  AllTrim(AD9->AD9_CODCONT) + " n�o foi encontrado na tabela SU5.",;
                    1, 0, NIL, NIL, NIL, NIL, .T., {"Entre em contato com o administrador do sistema para verificar o motivo da inexist�ncia do mesmo."})
                BREAK
            EndIf

            // Captura os dados do contato
            cCont  := AllTrim(SU5->U5_CONTAT)
            cMailC := AllTrim(SU5->U5_EMAIL)
            cFoneC := AllTrim(SU5->U5_DDD) + " " + AllTrim(SU5->U5_FCOM1)
        EndIf

        // Posiciona no primeiro item da proposta comercial
        DBSelectArea("ADZ")
        AAdd(aArea, FwGetArea())
        DBSetOrder(3) // ADZ_FILIAL + ADZ_PROPOS + ADZ_FOLDER + ADZ_ITEM
        MsSeek(FwXFilial("ADZ") + cProposta + cPRevisa)

        // Gera exce��o se os itens da proposta comercial n�o forem encontrados
        If (!Found())
            Help(NIL, NIL, "FT600IMP_PROSPECT_NOT_FOUND", NIL, "O prospect " +  AllTrim(ADY->ADY_CODIGO) + "|" + AllTrim(ADY->ADY_LOJA) + " n�o foi encontrado na tabela SUS.",;
                1, 0, NIL, NIL, NIL, NIL, .T., {"Entre em contato com o administrador do sistema para verificar o motivo da inexist�ncia do mesmo."})
            BREAK
        EndIf

        // Percorre os registro do proposta
        While (!EOF() .And. FwXFilial("ADZ") == ADZ_FILIAL .And. cProposta == ADZ_PROPOS)
            // Monta as vari�veis privadas
            If (ADZ_PRODUT == "SV0000000000001")
                cVlrAn := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000002")
                cVlrTrn := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf ADZ->ADZ_PRODUT == 'SV0000000000004'
                cVlrRDO := "R$ " + Alltrim(Transform(ADZ->ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000005")
                cVlrAnSin := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000006")
                cVlrAna := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000008")
                cBkOff := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000009")
                cVlrBco := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000010")
                cVlrBase := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000011")
                cVlrTor := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000012")
                cVlrGIA := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000013")
                cVlrSIP := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000014")
                cBaseExt := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000015")
                cVlrEst := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000016")
                cVlrCheck := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000017")
                cVlrImp := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000018")
                cVlrCol := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000019")
                cCoordLog := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000020")
                cVlrLibF := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
                cVlrLib := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000022")
                cVlrDed := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000023")
                cVlrRat := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000024")
                cVlrBaseF := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000025")
                cVlrBDL := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000027")
                cVlrFrota := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000028")
                cVlrMon := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000029")
                cVlrPrev := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000030")
                cVlrSof := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000031")
                cVlrPAF := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
                cVlrPav := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000032")
                cVlrPA := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000033")
                cVlrHReX := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000034")
                cVlrADE := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000035")
                cVlrPre := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000036")
                cVlrSDE := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000037")
                cVlrSup := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV2000000000037")
                cVlrSpLgEx := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV3000000000037")
                cVlrSupLg := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000038")
                cVlrCus := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000041")
                cVlrMob := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000042")
                cVlrHrt := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000048")
                cVlrBrl  := "R$ " + Alltrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
                cVlrBLOG := "R$ " + Alltrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000049")
                cVlrCRC := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000050")
                cVlrPrj := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000061")
                cVlrMRot := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000063")
                cVlrEsc := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000067")
                cVlrItBRLog := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000071")
                cVlrRDO := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            ElseIf (ADZ_PRODUT == "SV0000000000086")
                cViagemAv := "R$ " + AllTrim(Transform(ADZ_PRCVEN, "@E 999,999,999.99"))
            EndIf

            // Captura a descri��o do item
            AAdd(aDescPrd, AllTrim(Posicione("SB1", 1, FwXFilial("SB1") + ADZ_PRODUT, "B1_DESC")))

            // Salta para o pr�ximo registro
            DBSelectArea("ADZ")
            DBSkip()
        End

        // Percorre os itens da proposta
        For nX := 1 to Len(aDescPrd)
            // Apenas adiciona linhas n�o nulas
            If (!Empty(aDescPrd[nX]))
                cServs += AllTrim(aDescPrd[nX]) + IIf(nX != Len(aDescPrd), CRLF, "")
            EndIf
        Next nX

        // Verifica se o usu�rio selecionou algum documento para impress�o
        AEval(aResponse, {|x| nAmount += IIf(x == "1", 1, 0)})

        // Apenas inicia as impress�es se houver documentos � imprimir
        If (nAmount > 0)
            // Inicia uma barra de progress�o para status ao usu�rio
            Processa({|| PrintDocs(aResponse, nAmount)}, "Imprimindo documentos...", NIL, .F.)

            // Exibe mensagem de finaliza��o ao usu�rio
            If (!lAbortPrint)
                FwAlertSuccess("Processo de impress�o finalizado com sucesso!", cTitle)
            Else
                FwAlertWarning("Processo de impress�o cancelado pelo usu�rio.", cTitle)
            EndIf
        Else
            FwAlertInfo("Nenhum documento foi selecionado para impress�o.", cTitle)
        EndIf
    END SEQUENCE

    // Restaura o estado anterior das tabelas
    For nX := Len(aArea) To 1 Step -1
        FwRestArea(aArea[nX])
    Next nX

    // Remove os vetores da mem�ria
    FwFreeArray(aArea)
    FwFreeArray(aResponse)
Return (NIL)

/*/{Protheus.doc} PrintDocs
    Realiza a impress�o dos documentos selecionados pelo usu�rio na ParamBox().
    @type Function
    @version 12.1.33
    @author Guilherme Bigois
    @since 20/10/2022
    @param aResponse, Array, Respostas do usu�rio no ParamBox()
    @param nAmount, Numeric, Quantidade de documentos para impress�o
    @return Variant, Retorno nulo fixado
/*/
Static Function PrintDocs(aResponse As Array, nAmount As Numeric) As Variant
    // Adiciona o tamanho da barra de progres�o
    ProcRegua(nAmount)

    // MV_PAR01: Imprime Proposta Comercial
    If (!lAbortPrint .And. aResponse[1] == "1")
        IncProc("Imprimindo o arquivo PROPOSTA_" + cProposta + ".docx...")
        BRIMPCR1()
    EndIf

    // MV_PAR02: Imprime Minuta_Alarme
    If (!lAbortPrint .And. aResponse[2] == "1")
        IncProc("Imprimindo o arquivo MINUTA_ALARME_" + cProposta + ".docx...")
        BRIMPCR2()
    EndIf

    // MV_PAR03: Imprime Minuta_GR
    If (!lAbortPrint .And. aResponse[3] == "1")
        IncProc("Imprimindo o arquivo MINUTA_GR_" + cProposta + ".docx...")
        BRIMPCR3()
    EndIf

    // MV_PAR04: Imprime Minuta_Log�stico
    If (!lAbortPrint .And. aResponse[4] == "1")
        IncProc("Imprimindo o arquivo MINUTA_LOG�STICO_" + cProposta + ".docx...")
        BRIMPCR4()
    EndIf

    // MV_PAR05: Imprime Minuta_Perfil
    If (!lAbortPrint .And. aResponse[5] == "1")
        IncProc("Imprimindo o arquivo MINUTA_PERFIL_" + cProposta + ".docx...")
        BRIMPCR5()
    EndIf

    // MV_PAR06: Imprime FCC_FAT
    If (!lAbortPrint .And. aResponse[6] == "1")
        IncProc("Imprimindo o arquivo FCC_FAT_" + cProposta + ".docx...")
        BRIMPCR6()
    EndIf

    // MV_PAR07: Imprime FCC_OPER
    If (!lAbortPrint .And. aResponse[7] == "1")
        IncProc("Imprimindo o arquivo FCC_OPER_" + cProposta + ".docx...")
        BRIMPCR7()
    EndIf

    // MV_PAR08: Imprime FCC_RH
    If (!lAbortPrint .And. aResponse[8] == "1")
        IncProc("Imprimindo o arquivo FCC_RH_" + cProposta + ".docx...")
        BRIMPCR8()
    EndIf

    // MV_PAR09: Imprime Minuta_Servi�o
    // If (!lAbortPrint .And. aResponse[9] == "1")
    //     IncProc("Imprimindo o arquivo MINUTA_SERVI�O_" + cProposta + ".docx...")
    //     BRIMPCR9()
    // EndIf
Return (NIL)

/*/{Protheus.doc} BRIMPCR1
    Realiza a impress�o do contrato da proposta comercial.
    @type Function
    @version 12.1.27
    @author Natalia Perioto
    @since 08/10/2020
    @return Variant, Retorno nulo fixado
    @obs Fun��o refatorada por Guilherme Bigois em 04/09/2022
/*/
Static Function BRIMPCR1() As Variant
    // Vari�veis locais
    Local aData     As Array     // Dados para preenchimento no modelo
    Local cTemplate As Character // Nome do arquivo de modelo (.DOTX)
    Local cProposal As Character // C�digo da proposta atual

    // Inicializa��o de vari�veis
    aData     := {}
    cTemplate := "PROPOSTA"
    cProposal := cProposta

    // Monta o vetor de dados
    AAdd(aData, {"cCli1",    cCodigo})
    AAdd(aData, {"cNum1",    cProposta})
    AAdd(aData, {"cCli",     cNome})
    AAdd(aData, {"cCont",    cCont})
    AAdd(aData, {"cMail",    cMailC})
    AAdd(aData, {"cFone",    cFoneC})
    AAdd(aData, {"cDtEmi",   cDtEmissao})
    AAdd(aData, {"cNum",     cProposta})
    AAdd(aData, {"cContra",  cContra})
    AAdd(aData, {"cVend",    AllTrim(cNomVend)})
    AAdd(aData, {"cData",    CValToChar(Day(dDataBase)) + " de " + MesExtenso(dDataBase) + " de " + CValToChar(Year(dDataBase))})
    AAdd(aData, {"VlrAn",    IIf(Empty(cVlrAn),    cVlrVazio, cVlrAn)})
    AAdd(aData, {"VlrLib",   IIf(Empty(cVlrLib),   cVlrVazio, cVlrLib)})
    AAdd(aData, {"VlrFrota", IIf(Empty(cVlrFrota), cVlrVazio, cVlrFrota)})
    AAdd(aData, {"VlrMon",   IIf(Empty(cVlrMon),   cVlrVazio, cVlrMon)})
    AAdd(aData, {"VlrBase",  IIf(Empty(cVlrBase),  cVlrVazio, cVlrBase)})
    AAdd(aData, {"VlrCheck", IIf(Empty(cVlrCheck), cVlrVazio, cVlrCheck)})
    AAdd(aData, {"VlrSof",   IIf(Empty(cVlrSof),   cVlrVazio, cVlrSof)})
    AAdd(aData, {"VlrTor",   IIf(Empty(cVlrTor),   cVlrVazio, cVlrTor)})
    AAdd(aData, {"VlrMob",   IIf(Empty(cVlrMob),   cVlrVazio, cVlrMob)})
    AAdd(aData, {"VlrPrev",  IIf(Empty(cVlrPrev),  cVlrVazio, cVlrPrev)})
    AAdd(aData, {"VlrCRC",   IIf(Empty(cVlrCRC),   cVlrVazio, cVlrCRC)})
    AAdd(aData, {"VlrRat",   IIf(Empty(cVlrRat),   cVlrVazio, cVlrRat)})
    AAdd(aData, {"VlrDed",   IIf(Empty(cVlrDed),   cVlrVazio, cVlrDed)})
    AAdd(aData, {"VlrPA",    IIf(Empty(cVlrPA),    cVlrVazio, cVlrPA)})
    AAdd(aData, {"VlrEst",   IIf(Empty(cVlrEst),   cVlrVazio, cVlrEst)})
    AAdd(aData, {"VlrPrj",   IIf(Empty(cVlrPrj),   cVlrVazio, cVlrPrj)})
    AAdd(aData, {"VlrBLOG",  IIf(Empty(cVlrBLOG),  cVlrVazio, cVlrBLOG)})
    AAdd(aData, {"VlrAna",   IIf(Empty(cVlrAna),   cVlrVazio, cVlrAna)})
    AAdd(aData, {"VlrEsc",   IIf(Empty(cVlrEsc),   cVlrVazio, cVlrEsc)})
    AAdd(aData, {"VlrMRot",  IIf(Empty(cVlrMRot),  cVlrVazio, cVlrMRot)})
    AAdd(aData, {"cBkOff",   IIf(Empty(cBkOff),    cVlrVazio, cBkOff)})
    AAdd(aData, {"VlrBco",   IIf(Empty(cVlrBco),   cVlrVazio, cVlrBco)})
    AAdd(aData, {"VlrImp",   IIf(Empty(cVlrImp),   cVlrVazio, cVlrImp)})
    AAdd(aData, {"VlrPre",   IIf(Empty(cVlrPre),   cVlrVazio, cVlrPre)})
    AAdd(aData, {"VlrSup",   IIf(Empty(cVlrSup),   cVlrVazio, cVlrSup)})
    AAdd(aData, {"cVlrGIA",  IIf(Empty(cVlrGIA),   cVlrVazio, cVlrGIA)})
    AAdd(aData, {"cVlrSIP",  IIf(Empty(cVlrSIP),   cVlrVazio, cVlrSIP)})
    AAdd(aData, {"cCoordLog",IIf(Empty(cCoordLog), cVlrVazio, cCoordLog)})
    AAdd(aData, {"VlrPAF",   IIf(Empty(cVlrPAF),   cVlrVazio, cVlrPAF)})
    AAdd(aData, {"VlrSDE",   IIf(Empty(cVlrSDE),   cVlrVazio, cVlrSDE)})
    AAdd(aData, {"cVlrCus",  IIf(Empty(cVlrCus),   cVlrVazio, cVlrCus)})
    AAdd(aData, {"VlrHrt",   IIf(Empty(cVlrHrt),   cVlrVazio, cVlrHrt)})
    AAdd(aData, {"VlrTrn",   IIf(Empty(cVlrTrn),   cVlrVazio, cVlrTrn)})
    AAdd(aData, {"cBaseExt", IIf(Empty(cBaseExt),  cVlrVazio, cBaseExt)})
    AAdd(aData, {"VlrCol",   IIf(Empty(cVlrCol),   cVlrVazio, cVlrCol)})
    AAdd(aData, {"VlrRDO",   IIf(Empty(cVlrRDO),   cVlrVazio, cVlrRDO)})
    AAdd(aData, {"VlrADE",   IIf(Empty(cVlrADE),   cVlrVazio, cVlrADE)})
    AAdd(aData, {"VlrBDL",   IIf(Empty(cVlrBDL),   cVlrVazio, cVlrBDL)})

    // Imprime os dados no modelo
    PrintTemplate(cTemplate, cProposal, aData)
Return (NIL)

/*/{Protheus.doc} BRIMPCR2
    Realiza a impress�o do contrato MINUTA_ALARME.
    @type Function
    @version 12.1.27
    @author Natalia Perioto
    @since 08/10/2020
    @return Variant, Retorno nulo fixado
    @obs Fun��o refatorada por Guilherme Bigois em 04/09/2022
/*/
Static Function BRIMPCR2() As Variant
    // Vari�veis locais
    Local aData     As Array     // Dados para preenchimento no modelo
    Local cTemplate As Character // Nome do arquivo de modelo (.DOTX)
    Local cProposal As Character // C�digo da proposta atual

    // Inicializa��o de vari�veis
    aData     := {}
    cTemplate := "MINUTA_ALARME"
    cProposal := cProposta

    // Monta o vetor de dados
    AAdd(aData, {"cNumP",    cProposta})
    AAdd(aData, {"cNomCli",  cNome})
    AAdd(aData, {"cEnd",     cEndereco + " " + cBairro + " " + cCidade + " " + cUF + " CEP: " + cCEP})
    AAdd(aData, {"cCGC",     cCGC})
    AAdd(aData, {"cNomEmp",  AllTrim(SM0->M0_NOMECOM)})
    AAdd(aData, {"cEndEmp",  AllTrim(SM0->M0_ENDENT) + " " + AllTrim(SM0->M0_CIDENT) + " " + AllTrim(SM0->M0_ESTENT)  + " CEP: " + AllTrim(SM0->M0_CEPENT)})
    AAdd(aData, {"cCGCEmp",  AllTrim(SM0->M0_CGC)})
    AAdd(aData, {"cNomCli1", cNome})
    AAdd(aData, {"cNomEmp1", AllTrim(SM0->M0_NOMECOM)})
    AAdd(aData, {"cDtExt",   CValToChar(Day(dDataBase)) + " de " + MesExtenso(dDataBase) + " de " + CValToChar(Year(dDataBase))})
    AAdd(aData, {"cNomEmp2", AllTrim(SM0->M0_NOMECOM)})
    AAdd(aData, {"cNomCli2", cNome})
    AAdd(aData, {"VlrAn",    IIf(Empty(cVlrAn),    cVlrVazio, cVlrAn)})
    AAdd(aData, {"VlrLib",   IIf(Empty(cVlrLib),   cVlrVazio, cVlrLib)})
    AAdd(aData, {"VlrFrota", IIf(Empty(cVlrFrota), cVlrVazio, cVlrFrota)})
    AAdd(aData, {"VlrMon",   IIf(Empty(cVlrMon),   cVlrVazio, cVlrMon)})
    AAdd(aData, {"VlrBase",  IIf(Empty(cVlrBase),  cVlrVazio, cVlrBase)})
    AAdd(aData, {"VlrCheck", IIf(Empty(cVlrCheck), cVlrVazio, cVlrCheck)})
    AAdd(aData, {"VlrSof",   IIf(Empty(cVlrSof),   cVlrVazio, cVlrSof)})
    AAdd(aData, {"VlrTor",   IIf(Empty(cVlrTor),   cVlrVazio, cVlrTor)})
    AAdd(aData, {"VlrMob",   IIf(Empty(cVlrMob),   cVlrVazio, cVlrMob)})
    AAdd(aData, {"VlrPrev",  IIf(Empty(cVlrPrev),  cVlrVazio, cVlrPrev)})
    AAdd(aData, {"VlrCRC",   IIf(Empty(cVlrCRC),   cVlrVazio, cVlrCRC)})
    AAdd(aData, {"VlrRat",   IIf(Empty(cVlrRat),   cVlrVazio, cVlrRat)})
    AAdd(aData, {"VlrDed",   IIf(Empty(cVlrDed),   cVlrVazio, cVlrDed)})
    AAdd(aData, {"VlrPA",    IIf(Empty(cVlrPA),    cVlrVazio, cVlrPA)})
    AAdd(aData, {"VlrEst",   IIf(Empty(cVlrEst),   cVlrVazio, cVlrEst)})
    AAdd(aData, {"VlrPrj",   IIf(Empty(cVlrPrj),   cVlrVazio, cVlrPrj)})
    AAdd(aData, {"VlrBLOG",  IIf(Empty(cVlrBLOG),  cVlrVazio, cVlrBLOG)})
    AAdd(aData, {"VlrAna",   IIf(Empty(cVlrAna),   cVlrVazio, cVlrAna)})
    AAdd(aData, {"VlrEsc",   IIf(Empty(cVlrEsc),   cVlrVazio, cVlrEsc)})
    AAdd(aData, {"VlrMRot",  IIf(Empty(cVlrMRot),  cVlrVazio, cVlrMRot)})
    AAdd(aData, {"cBkOff",   IIf(Empty(cBkOff),    cVlrVazio, cBkOff)})
    AAdd(aData, {"VlrBco",   IIf(Empty(cVlrBco),   cVlrVazio, cVlrBco)})
    AAdd(aData, {"VlrImp",   IIf(Empty(cVlrImp),   cVlrVazio, cVlrImp)})
    AAdd(aData, {"VlrPre",   IIf(Empty(cVlrPre),   cVlrVazio, cVlrPre)})
    AAdd(aData, {"VlrSup",   IIf(Empty(cVlrSup),   cVlrVazio, cVlrSup)})
    AAdd(aData, {"cVlrGIA",  IIf(Empty(cVlrGIA),   cVlrVazio, cVlrGIA)})
    AAdd(aData, {"cVlrSIP",  IIf(Empty(cVlrSIP),   cVlrVazio, cVlrSIP)})
    AAdd(aData, {"cCoordLog",IIf(Empty(cCoordLog), cVlrVazio, cCoordLog)})
    AAdd(aData, {"VlrPAF",   IIf(Empty(cVlrPAF),   cVlrVazio, cVlrPAF)})
    AAdd(aData, {"VlrSDE",   IIf(Empty(cVlrSDE),   cVlrVazio, cVlrSDE)})
    AAdd(aData, {"cVlrCus",  IIf(Empty(cVlrCus),   cVlrVazio, cVlrCus)})
    AAdd(aData, {"VlrHrt",   IIf(Empty(cVlrHrt),   cVlrVazio, cVlrHrt)})
    AAdd(aData, {"VlrTrn",   IIf(Empty(cVlrTrn),   cVlrVazio, cVlrTrn)})
    AAdd(aData, {"cBaseExt", IIf(Empty(cBaseExt),  cVlrVazio, cBaseExt)})
    AAdd(aData, {"VlrCol",   IIf(Empty(cVlrCol),   cVlrVazio, cVlrCol)})
    AAdd(aData, {"VlrRDO",   IIf(Empty(cVlrRDO),   cVlrVazio, cVlrRDO)})
    AAdd(aData, {"VlrADE",   IIf(Empty(cVlrADE),   cVlrVazio, cVlrADE)})
    AAdd(aData, {"VlrBDL",   IIf(Empty(cVlrBDL),   cVlrVazio, cVlrBDL)})

    // Imprime os dados no modelo
    PrintTemplate(cTemplate, cProposal, aData)
Return (NIL)

/*/{Protheus.doc} BRIMPCR3
    Realiza a impress�o do contrato MINUTA_GR.
    @type Function
    @version 12.1.27
    @author Natalia Perioto
    @since 08/10/2020
    @return Variant, Retorno nulo fixado
    @obs Fun��o refatorada por Guilherme Bigois em 04/09/2022
/*/
Static Function BRIMPCR3() As Variant
    // Vari�veis locais
    Local aData     As Array     // Dados para preenchimento no modelo
    Local cTemplate As Character // Nome do arquivo de modelo (.DOTX)
    Local cProposal As Character // C�digo da proposta atual

    // Inicializa��o de vari�veis
    aData     := {}
    cTemplate := "MINUTA_GR"
    cProposal := cProposta

    // Monta o vetor de dados
    AAdd(aData, {"cProp",    cProposta})
    AAdd(aData, {"cNomCli",  cNome})
    AAdd(aData, {"cEndCli",  cEndereco + " " + cBairro + " " + cCidade + " " + cUF + " CEP: " + cCEP})
    AAdd(aData, {"cCNPJ",    cCGC})
    AAdd(aData, {"cNomEmp",  AllTrim(SM0->M0_NOMECOM)})
    AAdd(aData, {"cEndEmp",  AllTrim(SM0->M0_ENDENT) + " " + AllTrim(SM0->M0_CIDENT) + " " + AllTrim(SM0->M0_ESTENT)  + " CEP: " + AllTrim(SM0->M0_CEPENT)})
    AAdd(aData, {"cCGCEmp",  AllTrim(SM0->M0_CGC)})
    AAdd(aData, {"cDtExt",   CValToChar(Day(dDataBase)) + " de " + MesExtenso(dDataBase) + " de " + CValToChar(Year(dDataBase))})
    AAdd(aData, {"cNomEmp1", AllTrim(SM0->M0_NOMECOM)})
    AAdd(aData, {"cNomCli1", cNome})
    AAdd(aData, {"VlrAn",    IIf(Empty(cVlrAn),    cVlrVazio, cVlrAn)})
    AAdd(aData, {"VlrLib",   IIf(Empty(cVlrLib),   cVlrVazio, cVlrLib)})
    AAdd(aData, {"VlrFrota", IIf(Empty(cVlrFrota), cVlrVazio, cVlrFrota)})
    AAdd(aData, {"VlrMon",   IIf(Empty(cVlrMon),   cVlrVazio, cVlrMon)})
    AAdd(aData, {"VlrBase",  IIf(Empty(cVlrBase),  cVlrVazio, cVlrBase)})
    AAdd(aData, {"VlrCheck", IIf(Empty(cVlrCheck), cVlrVazio, cVlrCheck)})
    AAdd(aData, {"VlrSof",   IIf(Empty(cVlrSof),   cVlrVazio, cVlrSof)})
    AAdd(aData, {"VlrTor",   IIf(Empty(cVlrTor),   cVlrVazio, cVlrTor)})
    AAdd(aData, {"VlrMob",   IIf(Empty(cVlrMob),   cVlrVazio, cVlrMob)})
    AAdd(aData, {"VlrPrev",  IIf(Empty(cVlrPrev),  cVlrVazio, cVlrPrev)})
    AAdd(aData, {"VlrCRC",   IIf(Empty(cVlrCRC),   cVlrVazio, cVlrCRC)})
    AAdd(aData, {"VlrRat",   IIf(Empty(cVlrRat),   cVlrVazio, cVlrRat)})
    AAdd(aData, {"VlrDed",   IIf(Empty(cVlrDed),   cVlrVazio, cVlrDed)})
    AAdd(aData, {"VlrPA",    IIf(Empty(cVlrPA),    cVlrVazio, cVlrPA)})
    AAdd(aData, {"VlrEst",   IIf(Empty(cVlrEst),   cVlrVazio, cVlrEst)})
    AAdd(aData, {"VlrPrj",   IIf(Empty(cVlrPrj),   cVlrVazio, cVlrPrj)})
    AAdd(aData, {"VlrBLOG",  IIf(Empty(cVlrBLOG),  cVlrVazio, cVlrBLOG)})
    AAdd(aData, {"VlrAna",   IIf(Empty(cVlrAna),   cVlrVazio, cVlrAna)})
    AAdd(aData, {"VlrEsc",   IIf(Empty(cVlrEsc),   cVlrVazio, cVlrEsc)})
    AAdd(aData, {"VlrMRot",  IIf(Empty(cVlrMRot),  cVlrVazio, cVlrMRot)})
    AAdd(aData, {"cBkOff",   IIf(Empty(cBkOff),    cVlrVazio, cBkOff)})
    AAdd(aData, {"VlrBco",   IIf(Empty(cVlrBco),   cVlrVazio, cVlrBco)})
    AAdd(aData, {"VlrImp",   IIf(Empty(cVlrImp),   cVlrVazio, cVlrImp)})
    AAdd(aData, {"VlrPre",   IIf(Empty(cVlrPre),   cVlrVazio, cVlrPre)})
    AAdd(aData, {"VlrSup",   IIf(Empty(cVlrSup),   cVlrVazio, cVlrSup)})
    AAdd(aData, {"cVlrGIA",  IIf(Empty(cVlrGIA),   cVlrVazio, cVlrGIA)})
    AAdd(aData, {"cVlrSIP",  IIf(Empty(cVlrSIP),   cVlrVazio, cVlrSIP)})
    AAdd(aData, {"cCoordLog",IIf(Empty(cCoordLog), cVlrVazio, cCoordLog)})
    AAdd(aData, {"VlrPAF",   IIf(Empty(cVlrPAF),   cVlrVazio, cVlrPAF)})
    AAdd(aData, {"VlrSDE",   IIf(Empty(cVlrSDE),   cVlrVazio, cVlrSDE)})
    AAdd(aData, {"cVlrCus",  IIf(Empty(cVlrCus),   cVlrVazio, cVlrCus)})
    AAdd(aData, {"VlrHrt",   IIf(Empty(cVlrHrt),   cVlrVazio, cVlrHrt)})
    AAdd(aData, {"VlrTrn",   IIf(Empty(cVlrTrn),   cVlrVazio, cVlrTrn)})
    AAdd(aData, {"cBaseExt", IIf(Empty(cBaseExt),  cVlrVazio, cBaseExt)})
    AAdd(aData, {"VlrCol",   IIf(Empty(cVlrCol),   cVlrVazio, cVlrCol)})
    AAdd(aData, {"VlrRDO",   IIf(Empty(cVlrRDO),   cVlrVazio, cVlrRDO)})
    AAdd(aData, {"VlrADE",   IIf(Empty(cVlrADE),   cVlrVazio, cVlrADE)})
    AAdd(aData, {"VlrBDL",   IIf(Empty(cVlrBDL),   cVlrVazio, cVlrBDL)})
    AAdd(aData, {"VlrRDO",   IIf(Empty(cVlrRDO),   cVlrVazio, cVlrRDO)})

    // Imprime os dados no modelo
    PrintTemplate(cTemplate, cProposal, aData)
Return (NIL)

/*/{Protheus.doc} BRIMPCR4
    Realiza a impress�o do contrato MINUTA_LOGISTICO.
    @type Function
    @version 12.1.27
    @author Natalia Perioto
    @since 08/10/2020
    @return Variant, Retorno nulo fixado
    @obs Fun��o refatorada por Guilherme Bigois em 04/09/2022
/*/
Static Function BRIMPCR4() As Variant
    // Vari�veis locais
    Local aData     As Array     // Dados para preenchimento no modelo
    Local cTemplate As Character // Nome do arquivo de modelo (.DOTX)
    Local cProposal As Character // C�digo da proposta atual

    // Inicializa��o de vari�veis
    aData     := {}
    cTemplate := "MINUTA_LOGISTICO"
    cProposal := cProposta

    // Monta o vetor de dados
    AAdd(aData, {"cNumP",    cProposta})
    AAdd(aData, {"cNomCli",  cNome})
    AAdd(aData, {"cEnd",     cEndereco + " " + cBairro + " " + cCidade + " " + cUF + " CEP: " + cCEP})
    AAdd(aData, {"cCGC",     cCGC})
    AAdd(aData, {"cNomEmp",  AllTrim(SM0->M0_NOMECOM)})
    AAdd(aData, {"cEndEmp",  AllTrim(SM0->M0_ENDENT) + " " + AllTrim(SM0->M0_CIDENT) + " " + AllTrim(SM0->M0_ESTENT)  + " CEP: " + AllTrim(SM0->M0_CEPENT)})
    AAdd(aData, {"cCGCEmp",  AllTrim(SM0->M0_CGC)})
    AAdd(aData, {"cNomCli1", cNome})
    AAdd(aData, {"cNomEmp1", AllTrim(SM0->M0_NOMECOM)})
    AAdd(aData, {"cDtExt",   CValToChar(Day(dDataBase)) + " de " + MesExtenso(dDataBase) + " de " + CValToChar(Year(dDataBase))})
    AAdd(aData, {"VlrAn",    IIf(Empty(cVlrAn),    cVlrVazio, cVlrAn)})
    AAdd(aData, {"VlrLib",   IIf(Empty(cVlrLib),   cVlrVazio, cVlrLib)})
    AAdd(aData, {"VlrFrota", IIf(Empty(cVlrFrota), cVlrVazio, cVlrFrota)})
    AAdd(aData, {"VlrMon",   IIf(Empty(cVlrMon),   cVlrVazio, cVlrMon)})
    AAdd(aData, {"VlrBase",  IIf(Empty(cVlrBase),  cVlrVazio, cVlrBase)})
    AAdd(aData, {"VlrCheck", IIf(Empty(cVlrCheck), cVlrVazio, cVlrCheck)})
    AAdd(aData, {"VlrSof",   IIf(Empty(cVlrSof),   cVlrVazio, cVlrSof)})
    AAdd(aData, {"VlrTor",   IIf(Empty(cVlrTor),   cVlrVazio, cVlrTor)})
    AAdd(aData, {"VlrMob",   IIf(Empty(cVlrMob),   cVlrVazio, cVlrMob)})
    AAdd(aData, {"VlrPrev",  IIf(Empty(cVlrPrev),  cVlrVazio, cVlrPrev)})
    AAdd(aData, {"VlrCRC",   IIf(Empty(cVlrCRC),   cVlrVazio, cVlrCRC)})
    AAdd(aData, {"VlrRat",   IIf(Empty(cVlrRat),   cVlrVazio, cVlrRat)})
    AAdd(aData, {"VlrDed",   IIf(Empty(cVlrDed),   cVlrVazio, cVlrDed)})
    AAdd(aData, {"VlrPA",    IIf(Empty(cVlrPA),    cVlrVazio, cVlrPA)})
    AAdd(aData, {"VlrEst",   IIf(Empty(cVlrEst),   cVlrVazio, cVlrEst)})
    AAdd(aData, {"VlrPrj",   IIf(Empty(cVlrPrj),   cVlrVazio, cVlrPrj)})
    AAdd(aData, {"VlrBLOG",  IIf(Empty(cVlrBLOG),  cVlrVazio, cVlrBLOG)})
    AAdd(aData, {"VlrAna",   IIf(Empty(cVlrAna),   cVlrVazio, cVlrAna)})
    AAdd(aData, {"VlrEsc",   IIf(Empty(cVlrEsc),   cVlrVazio, cVlrEsc)})
    AAdd(aData, {"VlrMRot",  IIf(Empty(cVlrMRot),  cVlrVazio, cVlrMRot)})
    AAdd(aData, {"cBkOff",   IIf(Empty(cBkOff),    cVlrVazio, cBkOff)})
    AAdd(aData, {"VlrBco",   IIf(Empty(cVlrBco),   cVlrVazio, cVlrBco)})
    AAdd(aData, {"VlrImp",   IIf(Empty(cVlrImp),   cVlrVazio, cVlrImp)})
    AAdd(aData, {"VlrPre",   IIf(Empty(cVlrPre),   cVlrVazio, cVlrPre)})
    AAdd(aData, {"VlrSup",   IIf(Empty(cVlrSup),   cVlrVazio, cVlrSup)})
    AAdd(aData, {"cVlrGIA",  IIf(Empty(cVlrGIA),   cVlrVazio, cVlrGIA)})
    AAdd(aData, {"cVlrSIP",  IIf(Empty(cVlrSIP),   cVlrVazio, cVlrSIP)})
    AAdd(aData, {"cCoordLog",IIf(Empty(cCoordLog), cVlrVazio, cCoordLog)})
    AAdd(aData, {"VlrPAF",   IIf(Empty(cVlrPAF),   cVlrVazio, cVlrPAF)})
    AAdd(aData, {"VlrSDE",   IIf(Empty(cVlrSDE),   cVlrVazio, cVlrSDE)})
    AAdd(aData, {"cVlrCus",  IIf(Empty(cVlrCus),   cVlrVazio, cVlrCus)})
    AAdd(aData, {"VlrHrt",   IIf(Empty(cVlrHrt),   cVlrVazio, cVlrHrt)})
    AAdd(aData, {"VlrTrn",   IIf(Empty(cVlrTrn),   cVlrVazio, cVlrTrn)})
    AAdd(aData, {"cBaseExt", IIf(Empty(cBaseExt),  cVlrVazio, cBaseExt)})
    AAdd(aData, {"VlrCol",   IIf(Empty(cVlrCol),   cVlrVazio, cVlrCol)})
    AAdd(aData, {"VlrRDO",   IIf(Empty(cVlrRDO),   cVlrVazio, cVlrRDO)})
    AAdd(aData, {"VlrADE",   IIf(Empty(cVlrADE),   cVlrVazio, cVlrADE)})
    AAdd(aData, {"VlrBDL",   IIf(Empty(cVlrBDL),   cVlrVazio, cVlrBDL)})

    // Imprime os dados no modelo
    PrintTemplate(cTemplate, cProposal, aData)
Return (NIL)

/*/{Protheus.doc} BRIMPCR5
    Realiza a impress�o do contrato MINUTA_PERFIL.
    @type Function
    @version 12.1.27
    @author Natalia Perioto
    @since 08/10/2020
    @return Variant, Retorno nulo fixado
    @obs Fun��o refatorada por Guilherme Bigois em 04/09/2022
/*/
Static Function BRIMPCR5() As Variant
    // Vari�veis locais
    Local aData     As Array     // Dados para preenchimento no modelo
    Local cTemplate As Character // Nome do arquivo de modelo (.DOTX)
    Local cProposal As Character // C�digo da proposta atual

    // Inicializa��o de vari�veis
    aData     := {}
    cTemplate := "MINUTA_PERFIL"
    cProposal := cProposta

    // Monta o vetor de dados
    AAdd(aData, {"cNumP",    cProposta})
    AAdd(aData, {"cNomCli",  cNome})
    AAdd(aData, {"cEnd",     cEndereco + " " + cBairro + " " + cCidade + " " + cUF + " CEP: " + cCEP})
    AAdd(aData, {"cCGC",     cCGC})
    AAdd(aData, {"CNOMEMP",  AllTrim(SM0->M0_NOMECOM)})
    AAdd(aData, {"cEndEmp",  AllTrim(SM0->M0_ENDENT) + " " + AllTrim(SM0->M0_CIDENT) + " " + AllTrim(SM0->M0_ESTENT)  + " CEP: " + AllTrim(SM0->M0_CEPENT)})
    AAdd(aData, {"cCGCEmp",  AllTrim(SM0->M0_CGC)})
    AAdd(aData, {"cDtExt",   CValToChar(Day(dDataBase)) + " de " + MesExtenso(dDataBase) + " de " + CValToChar(Year(dDataBase))})
    AAdd(aData, {"CNOMEMP1", AllTrim(SM0->M0_NOMECOM)})
    AAdd(aData, {"cNomCli1", cNome})
    AAdd(aData, {"VlrAn",    IIf(Empty(cVlrAn),    cVlrVazio, cVlrAn)})
    AAdd(aData, {"VlrLib",   IIf(Empty(cVlrLib),   cVlrVazio, cVlrLib)})
    AAdd(aData, {"VlrFrota", IIf(Empty(cVlrFrota), cVlrVazio, cVlrFrota)})
    AAdd(aData, {"VlrMon",   IIf(Empty(cVlrMon),   cVlrVazio, cVlrMon)})
    AAdd(aData, {"VlrBase",  IIf(Empty(cVlrBase),  cVlrVazio, cVlrBase)})
    AAdd(aData, {"VlrCheck", IIf(Empty(cVlrCheck), cVlrVazio, cVlrCheck)})
    AAdd(aData, {"VlrSof",   IIf(Empty(cVlrSof),   cVlrVazio, cVlrSof)})
    AAdd(aData, {"VlrTor",   IIf(Empty(cVlrTor),   cVlrVazio, cVlrTor)})
    AAdd(aData, {"VlrMob",   IIf(Empty(cVlrMob),   cVlrVazio, cVlrMob)})
    AAdd(aData, {"VlrPrev",  IIf(Empty(cVlrPrev),  cVlrVazio, cVlrPrev)})
    AAdd(aData, {"VlrCRC",   IIf(Empty(cVlrCRC),   cVlrVazio, cVlrCRC)})
    AAdd(aData, {"VlrRat",   IIf(Empty(cVlrRat),   cVlrVazio, cVlrRat)})
    AAdd(aData, {"VlrDed",   IIf(Empty(cVlrDed),   cVlrVazio, cVlrDed)})
    AAdd(aData, {"VlrPA",    IIf(Empty(cVlrPA),    cVlrVazio, cVlrPA)})
    AAdd(aData, {"VlrEst",   IIf(Empty(cVlrEst),   cVlrVazio, cVlrEst)})
    AAdd(aData, {"VlrPrj",   IIf(Empty(cVlrPrj),   cVlrVazio, cVlrPrj)})
    AAdd(aData, {"VlrBLOG",  IIf(Empty(cVlrBLOG),  cVlrVazio, cVlrBLOG)})
    AAdd(aData, {"VlrAna",   IIf(Empty(cVlrAna),   cVlrVazio, cVlrAna)})
    AAdd(aData, {"VlrEsc",   IIf(Empty(cVlrEsc),   cVlrVazio, cVlrEsc)})
    AAdd(aData, {"VlrMRot",  IIf(Empty(cVlrMRot),  cVlrVazio, cVlrMRot)})
    AAdd(aData, {"cBkOff",   IIf(Empty(cBkOff),    cVlrVazio, cBkOff)})
    AAdd(aData, {"VlrBco",   IIf(Empty(cVlrBco),   cVlrVazio, cVlrBco)})
    AAdd(aData, {"VlrImp",   IIf(Empty(cVlrImp),   cVlrVazio, cVlrImp)})
    AAdd(aData, {"VlrPre",   IIf(Empty(cVlrPre),   cVlrVazio, cVlrPre)})
    AAdd(aData, {"VlrSup",   IIf(Empty(cVlrSup),   cVlrVazio, cVlrSup)})
    AAdd(aData, {"cVlrGIA",  IIf(Empty(cVlrGIA),   cVlrVazio, cVlrGIA)})
    AAdd(aData, {"cVlrSIP",  IIf(Empty(cVlrSIP),   cVlrVazio, cVlrSIP)})
    AAdd(aData, {"cCoordLog",IIf(Empty(cCoordLog), cVlrVazio, cCoordLog)})
    AAdd(aData, {"VlrPAF",   IIf(Empty(cVlrPAF),   cVlrVazio, cVlrPAF)})
    AAdd(aData, {"VlrSDE",   IIf(Empty(cVlrSDE),   cVlrVazio, cVlrSDE)})
    AAdd(aData, {"cVlrCus",  IIf(Empty(cVlrCus),   cVlrVazio, cVlrCus)})
    AAdd(aData, {"VlrHrt",   IIf(Empty(cVlrHrt),   cVlrVazio, cVlrHrt)})
    AAdd(aData, {"VlrTrn",   IIf(Empty(cVlrTrn),   cVlrVazio, cVlrTrn)})
    AAdd(aData, {"cBaseExt", IIf(Empty(cBaseExt),  cVlrVazio, cBaseExt)})
    AAdd(aData, {"VlrCol",   IIf(Empty(cVlrCol),   cVlrVazio, cVlrCol)})
    AAdd(aData, {"VlrRDO",   IIf(Empty(cVlrRDO),   cVlrVazio, cVlrRDO)})
    AAdd(aData, {"VlrADE",   IIf(Empty(cVlrADE),   cVlrVazio, cVlrADE)})
    AAdd(aData, {"VlrBDL",   IIf(Empty(cVlrBDL),   cVlrVazio, cVlrBDL)})

    // Imprime os dados no modelo
    PrintTemplate(cTemplate, cProposal, aData)
Return (NIL)

/*/{Protheus.doc} BRIMPCR6
    Realiza a impress�o do contrato FCC_FAT.
    @type Function
    @version 12.1.27
    @author Natalia Perioto
    @since 08/10/2020
    @return Variant, Retorno nulo fixado
    @obs Fun��o refatorada por Guilherme Bigois em 04/09/2022
/*/
Static Function BRIMPCR6() As Variant
    // Vari�veis locais
    Local aData     As Array     // Dados para preenchimento no modelo
    Local cTemplate As Character // Nome do arquivo de modelo (.DOTX)
    Local cProposal As Character // C�digo da proposta atual

    // Inicializa��o de vari�veis
    aData     := {}
    cTemplate := "FCC_FAT"
    cProposal := cProposta

    // Monta o vetor de dados
    AAdd(aData, {"cNumP",      cProposta})
    AAdd(aData, {"cEmp",       cCodigo})
    AAdd(aData, {"cTp",        ""})
    AAdd(aData, {"cDtEm",      cDtEmissao})
    AAdd(aData, {"cDtF",       ""})
    AAdd(aData, {"cNomCli",    cNome})
    AAdd(aData, {"cCGC",       cCGC})
    AAdd(aData, {"cEnd",       cEndereco})
    AAdd(aData, {"cCep",       cCEP})
    AAdd(aData, {"cBairro",    cBairro})
    AAdd(aData, {"cBair",      cCidade})
    AAdd(aData, {"cUF",        cUF})
    AAdd(aData, {"VlrAn",      IIf(Empty(cVlrAn),      cVlrVazio, cVlrAn)})
    AAdd(aData, {"VlrLibF",    IIf(Empty(cVlrLibF),    cVlrVazio, cVlrLibF)})
    AAdd(aData, {"VlrFrota",   IIf(Empty(cVlrFrota),   cVlrVazio, cVlrFrota)})
    AAdd(aData, {"VlrMon",     IIf(Empty(cVlrMon),     cVlrVazio, cVlrMon)})
    AAdd(aData, {"VlrRat",     IIf(Empty(cVlrRat),     cVlrVazio, cVlrRat)})
    AAdd(aData, {"VlrBaseF",   IIf(Empty(cVlrBaseF),   cVlrVazio, cVlrBaseF)})
    AAdd(aData, {"VlrPAF",     IIf(Empty(cVlrPAF),     cVlrVazio, cVlrPAF)})
    AAdd(aData, {"cVlrBLOG",   IIf(Empty(cVlrBLOG),    cVlrVazio, cVlrBLOG)})
    AAdd(aData, {"cDtHr",      DToC(dDataBase) + " " + Time()})
    AAdd(aData, {"cObsF",      cBkOff})
    AAdd(aData, {"cViagemAv",  IIf(Empty(cViagemAv),   cVlrVazio, cViagemAv)})
    AAdd(aData, {"cBaseExt",   IIf(Empty(cBaseExt),    cVlrVazio, cBaseExt)})
    AAdd(aData, {"cCoordLog",  IIf(Empty(cCoordLog),   cVlrVazio, cCoordLog)})
    AAdd(aData, {"VlrPA",      IIf(Empty(cVlrPA),      cVlrVazio, cVlrPA)})
    AAdd(aData, {"cVlrCheck",  IIf(Empty(cVlrCheck),   cVlrVazio, cVlrCheck)})
    AAdd(aData, {"cVlrCol",    IIf(Empty(cVlrCol),     cVlrVazio, cVlrCol)})
    AAdd(aData, {"VlrTrn",     IIf(Empty(cVlrTrn),     cVlrVazio, cVlrTrn)})
    AAdd(aData, {"cVlrCRC",    IIf(Empty(cVlrCRC),     cVlrVazio, cVlrCRC)})
    AAdd(aData, {"cVlrDed",    IIf(Empty(cVlrDed),     cVlrVazio, cVlrDed)})
    AAdd(aData, {"cVlrSof",    IIf(Empty(cVlrSof),     cVlrVazio, cVlrSof)})
    AAdd(aData, {"cVlrTor",    IIf(Empty(cVlrTor),     cVlrVazio, cVlrTor)})
    AAdd(aData, {"cVlrMob",    IIf(Empty(cVlrMob),     cVlrVazio, cVlrMob)})
    AAdd(aData, {"cVlrGIA",    IIf(Empty(cVlrGIA),     cVlrVazio, cVlrGIA)})
    AAdd(aData, {"cVlrSIP",    IIf(Empty(cVlrSIP),     cVlrVazio, cVlrSIP)})
    AAdd(aData, {"VlrPre",     IIf(Empty(cVlrPre),     cVlrVazio, cVlrPre)})
    AAdd(aData, {"cVlrPrev",   IIf(Empty(cVlrPrev),    cVlrVazio, cVlrPrev)})
    AAdd(aData, {"cVlrEst",    IIf(Empty(cVlrEst),     cVlrVazio, cVlrEst)})
    AAdd(aData, {"cVlrPrj",    IIf(Empty(cVlrPrj),     cVlrVazio, cVlrPrj)})
    AAdd(aData, {"cVlrCus",    IIf(Empty(cVlrCus),     cVlrVazio, cVlrCus)})
    AAdd(aData, {"cBkOff",     IIf(Empty(cBkOff),      cVlrVazio, cBkOff)})
    AAdd(aData, {"VlrBco",     IIf(Empty(cVlrBco),     cVlrVazio, cVlrBco)})
    AAdd(aData, {"cVlrAnSin",  IIf(Empty(cVlrAnSin),   cVlrVazio, cVlrAnSin)})
    AAdd(aData, {"VlrRDO",     IIf(Empty(cVlrRDO),     cVlrVazio, cVlrRDO)})
    AAdd(aData, {"VlrADE",     IIf(Empty(cVlrADE),     cVlrVazio, cVlrADE)})
    AAdd(aData, {"VlrBDL",     IIf(Empty(cVlrBDL),     cVlrVazio, cVlrBDL)})
    AAdd(aData, {"VlrSDE",     IIf(Empty(cVlrSDE),     cVlrVazio, cVlrSDE)})
    AAdd(aData, {"VlrHrt",     IIf(Empty(cVlrHrt),     cVlrVazio, cVlrHrt)})
    AAdd(aData, {"VlrCoe",     IIf(Empty(cVlrCoe),     cVlrVazio, cVlrCoe)})
    AAdd(aData, {"VlrBse",     IIf(Empty(cVlrBse),     cVlrVazio, cVlrBse)})
    AAdd(aData, {"VlrSupLg",   IIf(Empty(cVlrSupLg),   cVlrVazio, cVlrSupLg)})
    AAdd(aData, {"VlrImp",     IIf(Empty(cVlrImp),     cVlrVazio, cVlrImp)})
    AAdd(aData, {"VlrItBRLog", IIf(Empty(cVlrItBRLog), cVlrVazio, cVlrItBRLog)})
    AAdd(aData, {"VlrSpLgEx",  IIf(Empty(cVlrSpLgEx),  cVlrVazio, cVlrSpLgEx)})

    // Imprime os dados no modelo
    PrintTemplate(cTemplate, cProposal, aData)
Return (NIL)

/*/{Protheus.doc} BRIMPCR7
    Realiza a impress�o do contrato FCC_OPER.
    @type Function
    @version 12.1.27
    @author Natalia Perioto
    @since 08/10/2020
    @return Variant, Retorno nulo fixado
    @obs Fun��o refatorada por Guilherme Bigois em 04/09/2022
/*/
Static Function BRIMPCR7() As Variant
    // Vari�veis locais
    Local aData     As Array     // Dados para preenchimento no modelo
    Local cTemplate As Character // Nome do arquivo de modelo (.DOTX)
    Local cProposal As Character // C�digo da proposta atual

    // Inicializa��o de vari�veis
    aData     := {}
    cTemplate := "FCC_OPER"
    cProposal := cProposta

    // Monta o vetor de dados
    AAdd(aData, {"cNumP",   cProposta})
    AAdd(aData, {"cTp",     ""})
    AAdd(aData, {"cDtEm",   cDtEmissao})
    AAdd(aData, {"cDtFec",  ""})
    AAdd(aData, {"cNomCli", cNome})
    AAdd(aData, {"cCGC",    cCGC})
    AAdd(aData, {"cEnd",    cEndereco})
    AAdd(aData, {"cCep",    cCEP})
    AAdd(aData, {"cBairro", cBairro})
    AAdd(aData, {"cCity",   cCidade})
    AAdd(aData, {"cUF",     cUF})
    AAdd(aData, {"cServs",  cServs})
    AAdd(aData, {"cObsF",   cObsF})

    // Imprime os dados no modelo
    PrintTemplate(cTemplate, cProposal, aData)
Return (NIL)

/*/{Protheus.doc} BRIMPCR8
    Realiza a impress�o do contrato FCC_RH.
    @type Function
    @version 12.1.27
    @author Natalia Perioto
    @since 08/10/2020
    @return Variant, Retorno nulo fixado
    @obs Fun��o refatorada por Guilherme Bigois em 04/09/2022
/*/
Static Function BRIMPCR8() As Variant
    // Vari�veis locais
    Local aData     As Array     // Dados para preenchimento no modelo
    Local cTemplate As Character // Nome do arquivo de modelo (.DOTX)
    Local cProposal As Character // C�digo da proposta atual

    // Inicializa��o de vari�veis
    aData     := {}
    cTemplate := "FCC_RH"
    cProposal := cProposta

    // Monta o vetor de dados
    AAdd(aData, {"cNroP", cProposta})
    AAdd(aData, {"cTp",   ""})
    AAdd(aData, {"cDtEm", cDtEmissao})
    AAdd(aData, {"cDtF",  ""})
    AAdd(aData, {"cNomC", cNome})
    AAdd(aData, {"cInsc", cInsc})
    AAdd(aData, {"cCGC",  cCGC})
    AAdd(aData, {"cEnd",  cEndereco})
    AAdd(aData, {"cCity", cCidade})
    AAdd(aData, {"cUF",   cUF})
    AAdd(aData, {"cCep",  cCEP})
    AAdd(aData, {"cDtHr", DToC(dDataBase) + " " + Time()})
    //AAdd(aData, {"cObsF", cObsF})
    AAdd(aData, {"cObsRH", cObsRH})

    // Imprime os dados no modelo
    PrintTemplate(cTemplate, cProposal, aData)
Return (NIL)

/*/{Protheus.doc} BRIMPCR9
    Realiza a impress�o do contrato MINUTA_SERVICO.
    @type Function
    @version 12.1.27
    @author Natalia Perioto
    @since 08/10/2020
    @return Variant, Retorno nulo fixado
    @obs Fun��o refatorada por Guilherme Bigois em 04/09/2022
/*/
Static Function BRIMPCR9() As Variant
    // Vari�veis locais
    Local aData     As Array     // Dados para preenchimento no modelo
    Local cTemplate As Character // Nome do arquivo de modelo (.DOTX)
    Local cProposal As Character // C�digo da proposta atual

    // Inicializa��o de vari�veis
    aData     := {}
    cTemplate := "MINUTA_SERVICO"
    cProposal := cProposta

    // Monta o vetor de dados
    AAdd(aData, {"cNumP",    cProposta})
    AAdd(aData, {"cNomCli",  cNome})
    AAdd(aData, {"cEnd",     cEndereco + " " + cBairro + " " + cCidade + " " + cUF + " CEP: " + cCEP})
    AAdd(aData, {"cCGC",     cCGC})
    AAdd(aData, {"cNomEmp",  AllTrim(SM0->M0_NOMECOM)})
    AAdd(aData, {"cEndEmp",  AllTrim(SM0->M0_ENDENT) + " " + AllTrim(SM0->M0_CIDENT) + " " + AllTrim(SM0->M0_ESTENT)  + " CEP: " + AllTrim(SM0->M0_CEPENT)})
    AAdd(aData, {"cCGCEmp",  AllTrim(SM0->M0_CGC)})
    AAdd(aData, {"cNomCli1", cNome})
    AAdd(aData, {"cNomEmp1", AllTrim(SM0->M0_NOMECOM)})
    AAdd(aData, {"cDtExt",   CValToChar(Day(dDataBase)) + " de " + MesExtenso(dDataBase) + " de " + CValToChar(Year(dDataBase))})

    // Imprime os dados no modelo
    PrintTemplate(cTemplate, cProposal, aData)
Return (NIL)

/*/{Protheus.doc} PrintTemplate
    Realiza o preenchimento das vari�veis e imprime um modelo Microsoft Word (.DOTX)
    conforme nome e dados enviados via par�metro.
    @type Function
    @version 12.1.27
    @author Guilherme Bigois
    @since 04/09/2022
    @param cTemplate, Character, Nome do arquivo de modelo (.DOTX)
    @param cProposal, Character, C�digo da proposta atual
    @param aData, Array, Dados para preenchimento no modelo
    @return Variant, Retorno nulo fixado
/*/
Static Function PrintTemplate(cTemplate As Character, cProposal As Character, aData As array) As Variant
    // Vari�veis locais
    Local nX        As Numeric   // Contador dos dados para preenchimento no model
    Local oWord     As Object    // Auxiliar de montagem do .DOT
    Local cFile     As Character // Novo arquivo a ser gerado
    Local cSource   As Character // Origem dos arquivos modelo
    Local cTarget   As Character // Local para grava��o dos arquivos

    // Inicializa��o de vari�veis
    oWord   := OLE_CreateLink()
    cFile   := cTemplate + "_" + AllTrim(cProposal) + ".doc"
    cSource := GetTempPath() + "totvs_template"
    cTarget := AllTrim(SuperGetMV("RE_DIRGRP", .F., "C:\temp"))

    // Inicia a sequ�ncia de processamento
    BEGIN SEQUENCE
        // Gera exce��o caso ocorra qualquer erro na cria��o do diret�rio destino ou c�pia arquivo modelo
        If (!IsCopyOK(cSource, cTarget, cTemplate, cFile))
            BREAK
        EndIf

        // Inicia uma sequ�ncia de impress�o
        BeginMSOle()
            // Inicializa o arquivo e define as configura��es
            OLE_NewFile(oWord, cSource + SLASH_REMOTE + cTemplate + ".dotx")
            OLE_SetProperty(oWord, oleWdVisible,     .F.) // Exibe ou oculta a aplica��o Word
            OLE_SetProperty(oWord, oleWdWindowState, "1") // Define estado da janela (doc. n�o encontrada)
            OLE_SetProperty(oWord, oleWdPrintBack,   .F.) // Envia o Word para a �rea de transfer�ncia

            // Preenche as vari�veis do modelo
            For nX := 1 To Len(aData)
                OLE_SetDocumentVar(oWord, aData[nX][1], aData[nX][2])
            Next nX

            // Atualiza os valores no arquivo modelo e salva
            OLE_UpdateFields(oWord)
            OLE_SaveAsFile(oWord, cTarget + SLASH_REMOTE + cFile, "","",.F.)
        EndMSOle()

        // Fecha o link e abre o arquivo
        Sleep(1000)
        OLE_CloseLink(oWord)
        ShellExecute("OPEN", cFile, "", cTarget, 1)
    END SEQUENCE
Return (NIL)

/*/{Protheus.doc} IsCopyOK
    Realiza todas as valida��es necess�rias para disponibilizar os arquivos modelo na m�quina
    do usu�rio e criar os diret�rios para impress�o no novo arquivo.
    @type Function
    @version 12.1.27
    @author Guilherme Bigois
    @since 04/09/2022
    @param cSource, Character, Caminho do modelo que ser� preenchido e impresso
    @param cTarget, Character, Pasta destino do arquivo que ser� criado
    @param cTemplate, Character, Nome do arquivo modelo que ser� utilizado
    @param cFile, Character, Nome do arquivo que ser� posteriormente criado
    @return Logical, Flag de sucesso na valida��o
/*/
Static Function IsCopyOK(cSource As Character, cTarget As Character, cTemplate As Character, cFile As Character) As Logical
    // Vari�veis locais
    Local lOK  As Logical   // Flag de sucesso na valida��o
    Local cAux As Character // Diret�rio do arquivo modelo no servidor

    // Inicializa��o de vari�veis
    lOK  := .F.
    cAux := SLASH_SERVER + "dirdoc" + SLASH_SERVER + "dotx" + SLASH_SERVER + cTemplate + ".dotx"

    // Inicia a sequ�ncia de valida��o
    BEGIN SEQUENCE
        // Cria o diret�rio de destino das impress�es caso ele n�o exista
        If (!File(cTarget) .And. !FwMakeDir(cTarget))
            Help(NIL, NIL, "FT600IMP_CREATE_TARGET_DIR", NIL, "N�o foi poss�vel criar o diret�rio " + cTarget + ".",;
                1, 0, NIL, NIL, NIL, NIL, .F., {"Verifique as permiss�es do sistema para escrita neste diret�rio e tente novamente.", "Caso o erro persista, entre em contato com o administrador do sistema."})
            BREAK
        EndIf

        // Cria o diret�rio de origem dos arquivos de modelo caso ele n�o exista
        If (!File(cSource) .And. !FwMakeDir(cSource))
            Help(NIL, NIL, "FT600IMP_CREATE_SOURCE_DIR", NIL, "N�o foi poss�vel criar o diret�rio " + SLASH_REMOTE + "totvs_template em " + SubStr(cSource, 1, RAt(SLASH_REMOTE, cSource) - 1),;
                1, 0, NIL, NIL, NIL, NIL, .T., {"Verifique as permiss�es do sistema para escrita neste diret�rio e tente novamente.", "Caso o erro persista, entre em contato com o administrador do sistema."})
            BREAK
        EndIf

        // Gera exce��o caso o arquivo de modelo n�o exista no servidor e nem na m�quina do usu�rio
        If (!File(cAux) .And. !File(cSource + SLASH_REMOTE + cTemplate + ".dotx"))
            Help(NIL, NIL, "FT600IMP_TEMPLATE_NOT_FOUND", NIL, "O arquivo modelo " + cTemplate + ".dotx n�o foi encontrado no servidor e nem no diret�rio " + cSource,;
                1, 0, NIL, NIL, NIL, NIL, .T., {"Entre em contato com o administrador do sistema para o que o mesmo seja adicionado no servidor."})
            BREAK
        EndIf

        // Exibe mensagem informativa ao usu�rio para que o modelo seja adicionado no servidor pelos administradores
        If (!File(cAux))
            Help(NIL, NIL, "FT600IMP_TEMPLATE_NOT_IN_SERVER", NIL, "O arquivo modelo " + cTemplate + ".dotx presente em sua m�quina n�o existe no servidor.",;
                1, 0, NIL, NIL, NIL, NIL, .F., {"Entre em contato com o administrador do sistema para o que o mesmo seja adicionado no servidor."})

            // N�o gera exce��o por ser apenas informativo
            lOK := .T.
            BREAK
        EndIf

        // Gera exce��o se o arquivo n�o existir na m�quina do usu�rio e tamb�m n�o for poss�vel copiar do servidor
        If (!File(cSource + SLASH_REMOTE + cTemplate + ".dotx") .And. !__CopyFile(cAux, cSource + SLASH_REMOTE + cTemplate + ".dotx", NIL, NIL, .F.))
            Help(NIL, NIL, "FT600IMP_CANNOT_COPY_TEMPLATE", NIL, "O arquivo modelo " + cTemplate + ".dotx n�o pode ser copiado do servidor para " + cSource,;
                1, 0, NIL, NIL, NIL, NIL, .T., {"Entre em contato com o administrador do sistema para o que o mesmo seja adicionado no servidor."})
            BREAK
        EndIf

        // Define a flag de sucesso como .T. se n�o ocorrem erros
        lOK := .T.
    END SEQUENCE
Return (lOK)

/*/{Protheus.doc} QuestionDef
    Define, exibe e retorna um conjunto de perguntas para o usu�rio.
    @type Function
    @version 12.1.27
    @author Guilherme Bigois
    @since 04/09/2022
    @return Array, Valores preenchidos pelo usu�rio no Pergunte()
/*/
Static Function QuestionDef() As Array
    // Vari�veis locais
    Local nX        As Numeric // Contador do la�o de par�metros
    Local aAux      As Array   // Auxiliar de montagem
    Local aMVPar    As Array   // Vetor de par�metros MV_PAR
    Local aQuestion As Array   // Perguntas exibidas ao usu�rio
    Local aResponse As Array   // Respostas obtidas via Pergunte()

    // Inicializa��o de vari�veis
    nX        := 0
    aAux      := {}
    aMVPar    := {}
    aQuestion := {}
    aResponse := {}

    // Salva o estado dois MV_PAR
    For nX := 1 To 60
        aAdd(aMvPar, &("MV_PAR" + StrZero(nX, 2, 0)))
    Next nX

    // MV_PAR01: Imprime Proposta Comercial
    AAdd(aAux, 2)                            // [01] Tipo (1=Get | 2=Combo | 3=Radio | 4=Text+Checkbox | 5=Checkbox | 6=File | 7=Filter | 8=Password | 9=Text | 10=Range | 11=Multiget)
    AAdd(aAux, "Imprime Proposta Comercial") // [02] Descri��o
    AAdd(aAux, "1")                          // [03] Op��o inicial do combo
    AAdd(aAux, {"1=Sim", "2=N�o"})           // [04] Op��es do combo
    AAdd(aAux, 50)                           // [05] Tamanho do box
    AAdd(aAux, ".T.")                        // [06] Valida��o
    AAdd(aAux, .T.)                          // [07] Obrigat�rio?
    AAdd(aQuestion, aAux)
    aAux := {}

    // MV_PAR02: Imprime Minuta_Alarme
    AAdd(aAux, 2)                            // [01] Tipo (1=Get | 2=Combo | 3=Radio | 4=Text+Checkbox | 5=Checkbox | 6=File | 7=Filter | 8=Password | 9=Text | 10=Range | 11=Multiget)
    AAdd(aAux, "Imprime Minuta_Alarme")      // [02] Descri��o
    AAdd(aAux, "1")                          // [03] Op��o inicial do combo
    AAdd(aAux, {"1=Sim", "2=N�o"})           // [04] Op��es do combo
    AAdd(aAux, 50)                           // [05] Tamanho do box
    AAdd(aAux, ".T.")                        // [06] Valida��o
    AAdd(aAux, .T.)                          // [07] Obrigat�rio?
    AAdd(aQuestion, aAux)
    aAux := {}

    // MV_PAR03: Imprime Minuta_GR
    AAdd(aAux, 2)                            // [01] Tipo (1=Get | 2=Combo | 3=Radio | 4=Text+Checkbox | 5=Checkbox | 6=File | 7=Filter | 8=Password | 9=Text | 10=Range | 11=Multiget)
    AAdd(aAux, "Imprime Minuta_GR")          // [02] Descri��o
    AAdd(aAux, "1")                          // [03] Op��o inicial do combo
    AAdd(aAux, {"1=Sim", "2=N�o"})           // [04] Op��es do combo
    AAdd(aAux, 50)                           // [05] Tamanho do box
    AAdd(aAux, ".T.")                        // [06] Valida��o
    AAdd(aAux, .T.)                          // [07] Obrigat�rio?
    AAdd(aQuestion, aAux)
    aAux := {}

    // MV_PAR04: Imprime Minuta_Log�stico
    AAdd(aAux, 2)                            // [01] Tipo (1=Get | 2=Combo | 3=Radio | 4=Text+Checkbox | 5=Checkbox | 6=File | 7=Filter | 8=Password | 9=Text | 10=Range | 11=Multiget)
    AAdd(aAux, "Imprime Minuta_Log�stico")   // [02] Descri��o
    AAdd(aAux, "1")                          // [03] Op��o inicial do combo
    AAdd(aAux, {"1=Sim", "2=N�o"})           // [04] Op��es do combo
    AAdd(aAux, 50)                           // [05] Tamanho do box
    AAdd(aAux, ".T.")                        // [06] Valida��o
    AAdd(aAux, .T.)                          // [07] Obrigat�rio?
    AAdd(aQuestion, aAux)
    aAux := {}

    // MV_PAR05: Imprime Minuta_Perfil
    AAdd(aAux, 2)                            // [01] Tipo (1=Get | 2=Combo | 3=Radio | 4=Text+Checkbox | 5=Checkbox | 6=File | 7=Filter | 8=Password | 9=Text | 10=Range | 11=Multiget)
    AAdd(aAux, "Imprime Minuta_Perfil")      // [02] Descri��o
    AAdd(aAux, "1")                          // [03] Op��o inicial do combo
    AAdd(aAux, {"1=Sim", "2=N�o"})           // [04] Op��es do combo
    AAdd(aAux, 50)                           // [05] Tamanho do box
    AAdd(aAux, ".T.")                        // [06] Valida��o
    AAdd(aAux, .T.)                          // [07] Obrigat�rio?
    AAdd(aQuestion, aAux)
    aAux := {}

    // MV_PAR06: Imprime FCC_FAT
    AAdd(aAux, 2)                            // [01] Tipo (1=Get | 2=Combo | 3=Radio | 4=Text+Checkbox | 5=Checkbox | 6=File | 7=Filter | 8=Password | 9=Text | 10=Range | 11=Multiget)
    AAdd(aAux, "Imprime FCC_FAT")            // [02] Descri��o
    AAdd(aAux, "1")                          // [03] Op��o inicial do combo
    AAdd(aAux, {"1=Sim", "2=N�o"})           // [04] Op��es do combo
    AAdd(aAux, 50)                           // [05] Tamanho do box
    AAdd(aAux, ".T.")                        // [06] Valida��o
    AAdd(aAux, .T.)                          // [07] Obrigat�rio?
    AAdd(aQuestion, aAux)
    aAux := {}

    // MV_PAR07: Imprime FCC_OPER
    AAdd(aAux, 2)                            // [01] Tipo (1=Get | 2=Combo | 3=Radio | 4=Text+Checkbox | 5=Checkbox | 6=File | 7=Filter | 8=Password | 9=Text | 10=Range | 11=Multiget)
    AAdd(aAux, "Imprime FCC_OPER")           // [02] Descri��o
    AAdd(aAux, "1")                          // [03] Op��o inicial do combo
    AAdd(aAux, {"1=Sim", "2=N�o"})           // [04] Op��es do combo
    AAdd(aAux, 50)                           // [05] Tamanho do box
    AAdd(aAux, ".T.")                        // [06] Valida��o
    AAdd(aAux, .T.)                          // [07] Obrigat�rio?
    AAdd(aQuestion, aAux)
    aAux := {}

    // MV_PAR08: Imprime FCC_RH
    AAdd(aAux, 2)                            // [01] Tipo (1=Get | 2=Combo | 3=Radio | 4=Text+Checkbox | 5=Checkbox | 6=File | 7=Filter | 8=Password | 9=Text | 10=Range | 11=Multiget)
    AAdd(aAux, "Imprime FCC_RH")             // [02] Descri��o
    AAdd(aAux, "1")                          // [03] Op��o inicial do combo
    AAdd(aAux, {"1=Sim", "2=N�o"})           // [04] Op��es do combo
    AAdd(aAux, 50)                           // [05] Tamanho do box
    AAdd(aAux, ".T.")                        // [06] Valida��o
    AAdd(aAux, .T.)                          // [07] Obrigat�rio?
    AAdd(aQuestion, aAux)
    aAux := {}

    // MV_PAR09: Imprime Minuta_Servi�o
    // AAdd(aAux, 2)                            // [01] Tipo (1=Get | 2=Combo | 3=Radio | 4=Text+Checkbox | 5=Checkbox | 6=File | 7=Filter | 8=Password | 9=Text | 10=Range | 11=Multiget)
    // AAdd(aAux, "Imprime Minuta_Servi�o")     // [02] Descri��o
    // AAdd(aAux, "1")                          // [03] Op��o inicial do combo
    // AAdd(aAux, {"1=Sim", "2=N�o"})           // [04] Op��es do combo
    // AAdd(aAux, 50)                           // [05] Tamanho do box
    // AAdd(aAux, ".T.")                        // [06] Valida��o
    // AAdd(aAux, .T.)                          // [07] Obrigat�rio?
    // AAdd(aQuestion, aAux)
    // aAux := {}

    // Exibe a caixa de di�logo para o usu�rio
    ParamBox(aQuestion, "Informe os par�metros", @aResponse, NIL, NIL, NIL, NIL, NIL, NIL, NIL, .T., .T.)

    // Restaura o estado anterior dos MV_PAR
    For nX := 1 To Len(aMvPar)
        &("MV_PAR" + StrZero(nX, 2, 0)) := aMvPar[nX]
    Next nX

    // Limpa vetores da mem�ria
    FwFreeArray(aAux)
    FwFreeArray(aMVPar)
    FwFreeArray(aQuestion)
Return (aResponse)
