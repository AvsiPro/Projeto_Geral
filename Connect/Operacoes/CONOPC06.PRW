#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "TBICONN.CH"

User Function CONOPC06()
    
    Local aCabec  := {} //Array para o cabeçalho do atendimento
    Local aItem   := {} //Array auxiliar para os itens da O.S
    Local aItens  := {} //Array para o item da O.S
    Local aAtivos := {} //Array para o item da O.S
    Local lRet    := .F. //Retorno da função
    Local cQuery  := ""
    Local nX      := ""

    Private lMsHelpAuto := .T. // Controle interno do ExecAuto
    Private lMsErroAuto := .F. // Informa a ocorrência de erros no ExecAuto
    Private lAutoErrNoFile := .T. // Loga Erros do Execauto na array
    Private INCLUI := .T. // Variavel necessária para o ExecAuto identificar que se trata de uma inclusão
    Private ALTERA := .F. // Variavel necessária para o ExecAuto identificar que se trata de uma inclusão

    BEGIN TRANSACTION

    DbSelectArea("AB1")
    DbSetOrder(1)
    if !DbSeek(xFilial("AB1") + Z15->Z15_NRCHAM)
        MsgAlert("Chamado técnico não encontrado!", "Erro!")
        Return
    EndIf

    cQuery := " SELECT AB2_NUMOS, AB2_XCBASE FROM " + RetSQLName("AB2") + " " 
    cQuery += " WHERE AB2_NRCHAM = '" + Z15->Z15_NRCHAM + "' "
    cQuery += " AND AB2_FILIAL = '" + xFilial("AB2") + "' "

    If Select("TRB") > 0
        DbSelectArea("TRB")
        DbCloseArea()
    EndIf

    DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)

    while !EOF()
        Aadd(aAtivos, {TRB->AB2_NUMOS, TRB->AB2_XCBASE} )

        DbSkip()
    end

    if len(aAtivos) < 1
        MsgAlert("Chamado técnico sem ativos vinculado!", "Erro!")
        Return
    endif

    for nX := 1 to len(aAtivos)

        aCabec := {}

        //Adiciona itens para o cabeçalho do Atendimento
        aAdd(aCabec, { "AB9_NUMOS"  ,AvKey(aAtivos[nX,01], "AB9_NUMOS")     ,Nil }) // Numero da O.S + Item
        aAdd(aCabec, { "AB9_SEQ"    ,"01"                                   ,Nil }) // Sequencia de Atendimento
        aAdd(aCabec, { "AB9_CODTEC" ,AvKey("00000000000001", "AB9_CODTEC")  ,Nil }) // Codigo do Técnico
        aAdd(aCabec, { "AB9_DTCHEG" ,ddatabase                              ,Nil }) // Data de Chegada
        aAdd(aCabec, { "AB9_HRCHEG" ,SubStr(cValToChar(Time()),1,5)         ,Nil }) // Hora de Chegada
        aAdd(aCabec, { "AB9_DTSAID" ,ddatabase                              ,Nil }) // Data de Saida
        aAdd(aCabec, { "AB9_HRSAID" ,SubStr(cValToChar(Time()),1,5)         ,Nil }) // Hora de Saida
        aAdd(aCabec, { "AB9_DTINI"  ,ddatabase                              ,Nil }) // Data de Inicio
        aAdd(aCabec, { "AB9_HRINI"  ,SubStr(cValToChar(Time()),1,5)         ,Nil }) // Hora de Inicio
        aAdd(aCabec, { "AB9_DTFIM"  ,ddatabase                              ,Nil }) // Data de Fim
        aAdd(aCabec, { "AB9_HRFIM"  ,SubStr(cValToChar(Time()),1,5)         ,Nil }) // Hora de Fim
        aAdd(aCabec, { "AB9_CODPRB" ,"000002"                               ,Nil }) // Codigo da Ocorrencia
        aAdd(aCabec, { "AB9_TIPO"   ,"1"                                    ,Nil }) // Tipo(1= Encerrado,2=Aberta)
        aAdd(aCabec, { "AB9_TOTFAT" ,"000:00"                               ,Nil }) // Horas Faturadas

        aItem := {}
        aItens := {}

        dbSelectArea("SN1")
        DbSetOrder(2)
        if !DbSeek(xFilial("SN1") + AvKey(aAtivos[nX,02], "N1_CBASE"))
            MsgAlert("Ativo não encontrado no cadastro de ativos!", "Erro!")
            Return
        endif

        DbSelectArea("SB1")
        DbSetOrder(1)
        if !DbSeek(xFilial("SB1") + SN1->N1_PRODUTO)
            MsgAlert("Produto do ativo não encontrado no cadastro de produtos!", "Erro!")
            Return
        EndIf

        DbSelectArea("SN3")
        DbSetOrder(1)
        if !DbSeek(xFilial("SN3") + SN1->N1_CBASE /* + "0001" + "01" + AvKey("", "N3_BAIXA") + AvKey("", "N3_SEQ")*/)
            MsgAlert("Valores não encontrados na SN3", "Erro!")
            Return
        EndIf

        //Itens do Atendimento da O.S
        aAdd(aItem, { "ABA_ITEM"   ,"01"                             ,Nil }) // Item
        aAdd(aItem, { "ABA_CODPRO" ,SN1->N1_PRODUTO                  ,Nil }) // Cod. do Produto
        aAdd(aItem, { "ABA_DESCRI" ,avKey(SB1->B1_DESC,"ABA_DESCRI") ,Nil }) // Cod. do Produto
        aAdd(aItem, { "ABA_QUANT"  ,1                                ,Nil }) // Quantidade usada
        aAdd(aItem, { "ABA_NUMSER" ,SN1->N1_CBASE                    ,Nil }) // Cod. do servico
        aAdd(aItem, { "ABA_CODSER" ,"000001"                         ,Nil }) // Cod. do servico
        aAdd(aItem, { "ABA_LOCAL"  ,"01"                             ,Nil }) // Cod. do servico
        aAdd(aItens,aItem)
        
        //Executa ExecAuto
        TECA460(aCabec,aItens,3) // 3-Incluir ; 4-Alterar ; 5-Excluir

        If !lMsErroAuto
            lRet := .T.
            MsgInfo("Atendimento da OS " + aAtivos[nX,01] + " feito com sucesso!", "Êxito!")
        Else
            // MostraErro()
            lRet := .F.
            MsgAlert("Não foi possível atender OS", "Erro!")
        EndIf

        if lRet
            
            DbSelectArea("AB7")
            DbSetOrder(1)
            if !DbSeek(xFilial("AB7") +  AvKey(aAtivos[nX,01], "AB7_NUMOS") + SubStr(aAtivos[nX,01], 7))
                MsgAlert("Problemas ao achar AB7!", "Erro!")
                Return
            EndIf

            RecLock("AB7", .F.)
                AB7->AB7_QTDSEP := 1
            MsUnlock()

            DbSelectArea("AB8")
            DbSetOrder(1)
            if !DbSeek(xFilial("AB8") + AvKey(aAtivos[nX,01], "AB7_NUMOS") + SubStr(aAtivos[nX,01], 7) + "000001")
                MsgAlert("Problemas ao achar AB8!", "Erro!")
                Return
            EndIf

            RecLock("AB8", .F.)
                AB8->AB8_QUANT  := 01
                AB8->AB8_VUNIT  := SN3->N3_VORIG1
                AB8->AB8_TOTAL  := AB8->AB8_QUANT * AB8->AB8_VUNIT
                AB8->AB8_PRCLIS := SN3->N3_VORIG1
                AB8->AB8_NUMSER := SN1->N1_XNUMSER
            MsUnlock()

            RecLock("Z15", .F.)            
                Z15->Z15_STATUS := "D"
            MsUnlock()

            MsgInfo("OS " + aAtivos[nX,01] + " pronta para efetivar!", "Fim!")

        endif
    next

    END TRANSACTION

Return 
