<<<<<<< HEAD
#Include 'Totvs.ch'

/*/{Protheus.doc} MT105MNU
   @description: 
   @type: User Function
   @author: Felipe Mayer
   @since: 20/09/2023
   @see: https://tdn.totvs.com/pages/releaseview.action?pageId=6087703
/*/

User Function MT105MNU()
    
Local aRet := {}
    
    aAdd(aRet,{'Libera por Tempo Previso','u_LIBREJ(1)', 0 , 2})
    aAdd(aRet,{'Rejeitar','u_LIBREJ(2)', 0 , 2})
    aAdd(aRet,{'Imprimir Requisição','U_JESTR001()', 0 , 2})

Return aRet


/*/{Protheus.doc} LIBREJ
   @description: 
   @type: User Function
   @author: Felipe Mayer
   @since: 20/09/2023
   @param: nOpt 1=liberar / 2=rejeitar
/*/
User Function LIBREJ(nOpt)

Local lAdm := RetCodUsr() == '000000'
    
    If Alltrim(SCP->CP_XORIGEM) == 'MNTA420'

        If !Empty(SCP->CP_PREREQU) .AND. !SCP->CP_STATSA $ 'BR'
            MsgAlert('Não é possível liberar ou rejeitar uma pré-requisição gerada.','MT105MNU')
        Else
            If nOpt == 1

                fTelaInsumo()
            ElseIf nOpt == 2

                ZPT->(DbSetOrder(1))
                lAprov := ZPT->(DbSeek( FWxFilial('ZPT') + AvKey(RetCodUsr(),'ZPT_USER') ))

                If ( lAprov .Or. lAdm )
                    cMsg := FWInputBox("Informe a justificativa da rejeição", "")

                    If Empty(cMsg)
                        MsgStop('Necessário preencher a justificativa da rejeição', 'MT105MNU')
                        lRet := .F.
                    Else
                        cMsgAux := 'Usuário Rejeição: '+UsrRetName(RetCodUsr()) + CRLF
                        cMsgAux += 'Data Rejeição: '+DToC(Date()) + CRLF
                        cMsgAux += 'Hora Rejeição: '+Left(Time(),5) + CRLF
                        cMsgAux += 'Justificativa: '+cMsg + CRLF
                        
                        RecLock('SCP', .F.)
                            SCP->CP_XMSGLIB := cMsgAux
                            SCP->CP_STATSA  := 'R'
                            SCP->CP_SALBLQ  := SCP->CP_QUANT
                        SCP->(MsUnlock())
                    EndIf
                Else
                    MsgStop('Usuário não possui permissão para rejeitar a solicitação.', 'MT105MNU')
                EndIf
            EndIf
        EndIf
    Else
        MsgStop('Somente é possível liberar ou rejeitar solicitações geradas na rotina O.S. Corretiva (MNTA420)','MT105MNU')
    EndIf

Return

  
Static Function fTelaInsumo()

Local aArea := GetArea()
//Fontes
Local cFontUti    := "Tahoma"
Local oFontSub    := TFont():New(cFontUti,,-20)
Local oFontBtn    := TFont():New(cFontUti,,-14)
//Janela e componentes
Private oDlgGrp
Private oPanGrid
Private oGetGrid
Private aHeaderGrid := {}
Private aColsGrid := {}
//Tamanho da janela
Private aTamanho := MsAdvSize()
Private nJanLarg := aTamanho[5] / 1.5
Private nJanAltu := aTamanho[6] / 1.7
  
    //Monta o cabecalho
    fMontaHead()
  
    //Criando a janela
    DEFINE MSDIALOG oDlgGrp TITLE "" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
        //Labels gerais
        @ 006, 005 SAY "Insumos da Ultima Requisição" SIZE 200, 030 FONT oFontSub  OF oDlgGrp COLORS RGB(031,073,125) PIXEL
  
        //Botões
        @ 006, (nJanLarg/2-001)-(0052*01) BUTTON oBtnFech  PROMPT "Fechar"   SIZE 050, 018 OF oDlgGrp ACTION (oDlgGrp:End())   FONT oFontBtn PIXEL
        @ 006, (nJanLarg/2-001)-(0052*02) BUTTON oBtnLege  PROMPT "Aprovar"  SIZE 050, 018 OF oDlgGrp ACTION (fLiberar()) PIXEL
  
        //Dados
        @ 024, 003 GROUP oGrpDad TO (nJanAltu/2-003), (nJanLarg/2-003) PROMPT "" OF oDlgGrp COLOR 0, 16777215 PIXEL
        oGrpDad:oFont := oFontBtn
            oPanGrid := tPanel():New(033, 006, "", oDlgGrp, , , , RGB(000,000,000), RGB(254,254,254), (nJanLarg/2 - 13),     (nJanAltu/2 - 45))
            oGetGrid := FWBrowse():New()
            oGetGrid:DisableFilter()
            oGetGrid:DisableConfig()
            oGetGrid:DisableReport()
            oGetGrid:DisableSeek()
            oGetGrid:DisableSaveConfig()
            oGetGrid:SetFontBrowse(oFontBtn)
            oGetGrid:SetDataArray()
            oGetGrid:lHeaderClick :=.f.
            oGetGrid:SetColumns(aHeaderGrid)
            oGetGrid:SetArray(aColsGrid)
            oGetGrid:SetOwner(oPanGrid)
            oGetGrid:Activate()
  
        FWMsgRun(, {|oSay| fMontDados(oSay) }, "Processando", "Buscando")
    ACTIVATE MsDialog oDlgGrp CENTERED
  
    RestArea(aArea)
Return


Static Function fLiberar()

mv_par01 := 1 //mv_par01 Liberacao de SA 1- Por Item,2- Por Solicitacao
A107Lib()
oDlgGrp:End()

Return

  
Static Function fMontaHead()
    Local nAtual
    Local aHeadAux := {}
  
    //Adicionando colunas
    //[1] - Titulo
    //[2] - Tipo
    //[3] - Tamanho
    //[4] - Decimais
    //[5] - Máscara
    aAdd(aHeadAux, {"Ordem Serv.",       "C", TamSX3('TL_ORDEM')[01],   0, ""})
    aAdd(aHeadAux, {"Tarefa",            "C", TamSX3('TL_TAREFA')[01],    0, ""})
    aAdd(aHeadAux, {"Nome Tarefa",       "C", TamSX3('TL_NOMTAR')[01],  0, ""})
    aAdd(aHeadAux, {"Tipo Insumo",       "C", TamSX3('TL_TIPOREG')[01],  0, ""})
    aAdd(aHeadAux, {"Nome T.Insum",      "C", TamSX3('TL_NOMTREG')[01],  0, ""})
    aAdd(aHeadAux, {"Codigo Insumo",     "C", TamSX3('TL_CODIGO')[01],  0, ""})
    aAdd(aHeadAux, {"Nome Insumo",       "C", TamSX3('TL_NOMCODI')[01],  0, ""})
    aAdd(aHeadAux, {"Almoxarifado",      "C", TamSX3('TL_LOCAL')[01],  0, ""})
    aAdd(aHeadAux, {"Data Inicio",       "D", TamSX3('TL_DTINICI')[01],  0, ""})
    aAdd(aHeadAux, {"Hora Inicio",       "C", TamSX3('TL_HOINICI')[01],  0, ""})
    aAdd(aHeadAux, {"Data Fim",          "D", TamSX3('TL_DTFIM')[01],  0, ""})
    aAdd(aHeadAux, {"Hora Fim",          "C", TamSX3('TL_HOFIM')[01],  0, ""})
    aAdd(aHeadAux, {"Recno",             "N", 18, 0, "@E 999,999,999,999,999,999"})
  
    //Percorrendo e criando as colunas
    For nAtual := 1 To Len(aHeadAux)
        aAdd(aHeaderGrid, FWBrwColumn():New())
        aHeaderGrid[nAtual]:SetData(&("{||oGetGrid:oData:aArray[oGetGrid:At(),"+Str(nAtual)+"]}"))
        aHeaderGrid[nAtual]:SetTitle( aHeadAux[nAtual][1] )
        aHeaderGrid[nAtual]:SetType(aHeadAux[nAtual][2] )
        aHeaderGrid[nAtual]:SetSize( aHeadAux[nAtual][3] )
        aHeaderGrid[nAtual]:SetDecimal( aHeadAux[nAtual][4] )
        aHeaderGrid[nAtual]:SetPicture( aHeadAux[nAtual][5] )
    Next
Return
  
Static Function fMontDados(oSay)
    Local aArea := GetArea()
    Local nAtual := 0
    Local nTotal := 0
  
    Private LCORRET := .F. //variavel NGNOMETAR nao apagar 
    //Zera a grid
    aColsGrid := {}
      
    //Montando a query
    oSay:SetText("Montando a consulta")

    cQuery := " SELECT STL.R_E_C_N_O_ AS RECSTL, * FROM "+RetSqlName("SCP")+" SCP
    cQuery += " INNER JOIN "+RetSqlName("STL")+" STL
    cQuery += " 	ON TL_FILIAL = CP_FILIAL
    cQuery += " 	AND TL_NUMSA = CP_NUM
    cQuery += " 	AND TL_ITEMSA = CP_ITEM
    cQuery += " 	AND STL.D_E_L_E_T_ = ''
    cQuery += " INNER JOIN "+RetSqlName("STJ")+" STJ
    cQuery += " 	ON  TJ_FILIAL = TL_FILIAL
    cQuery += " 	AND TJ_ORDEM = TL_ORDEM
    cQuery += " 	AND STJ.D_E_L_E_T_ = ''
    cQuery += " WHERE SCP.D_E_L_E_T_ = ''
    cQuery += " 	AND CP_FILIAL = '"+FWxFilial('SCP')+"'
    cQuery += " 	AND CP_XORIGEM = 'MNTA420'
    cQuery += " 	AND CP_NUM = '"+SCP->CP_NUM+"'
    cQuery += " 	AND CP_ITEM = '"+SCP->CP_ITEM+"'

    //Executando a query
    oSay:SetText("Executando a consulta")
    PLSQuery(cQuery, "QRYTMP")
  
    //Se houve dados
    If ! QRYTMP->(EoF())
        //Pegando o total de registros
        DbSelectArea("QRYTMP")
        Count To nTotal
        QRYTMP->(DbGoTop())
  
        //Enquanto houver dados
        While ! QRYTMP->(EoF())
  
            //Muda a mensagem na regua
            nAtual++
            oSay:SetText("Adicionando registro " + cValToChar(nAtual) + " de " + cValToChar(nTotal) + "...")
            
            aAdd(aColsGrid, {;
                QRYTMP->TL_ORDEM,;
                QRYTMP->TL_TAREFA,;
                NGNOMETAR(QRYTMP->TJ_CODBEM+QRYTMP->TJ_SERVICO+QRYTMP->TJ_SEQRELA,QRYTMP->TL_TAREFA,TAMSX3('TL_NOMTAR')[1]),;
                QRYTMP->TL_TIPOREG,;
                TIPREGBRW(QRYTMP->TL_TIPOREG),;
                QRYTMP->TL_CODIGO,;
                NOMINSBRW(QRYTMP->TL_TIPOREG,QRYTMP->TL_CODIGO),;
                QRYTMP->TL_LOCAL,;
                QRYTMP->TL_DTINICI,;
                QRYTMP->TL_HOINICI,;
                QRYTMP->TL_DTFIM,;
                QRYTMP->TL_HOFIM,;
                QRYTMP->RECSTL,;
                .F.;
            })

            QRYTMP->(DbSkip())
        EndDo
  
    Else  
        aAdd(aColsGrid, {"","","","","","","","","","","","",0,.F.})
    EndIf

    QRYTMP->(DbCloseArea())
  
    //Define o array
    oSay:SetText("Atribuindo os dados na tela")
    oGetGrid:SetArray(aColsGrid)
    oGetGrid:Refresh()
  
    RestArea(aArea)
Return
=======
#Include 'Totvs.ch'

/*/{Protheus.doc} MT105MNU
   @description: 
   @type: User Function
   @author: Felipe Mayer
   @since: 20/09/2023
   @see: https://tdn.totvs.com/pages/releaseview.action?pageId=6087703
/*/

User Function MT105MNU()
    
Local aRet := {}
    
    aAdd(aRet,{'Libera por Tempo Previso','u_LIBREJ(1)', 0 , 2})
    aAdd(aRet,{'Rejeitar','u_LIBREJ(2)', 0 , 2})
    aAdd(aRet,{'Impressão Requisição','U_JESTR001()', 0 , 2})

Return aRet


/*/{Protheus.doc} LIBREJ
   @description: 
   @type: User Function
   @author: Felipe Mayer
   @since: 20/09/2023
   @param: nOpt 1=liberar / 2=rejeitar
/*/
User Function LIBREJ(nOpt)

Local lAdm := RetCodUsr() == '000000'
    
    If Alltrim(SCP->CP_XORIGEM) == 'MNTA420'

        If !Empty(SCP->CP_PREREQU) .AND. !SCP->CP_STATSA $ 'BR'
            MsgAlert('Não é possível liberar ou rejeitar uma pré-requisição gerada.','MT105MNU')
        Else
            If nOpt == 1

                fTelaInsumo()
            ElseIf nOpt == 2

                ZPT->(DbSetOrder(1))
                lAprov := ZPT->(DbSeek( FWxFilial('ZPT') + AvKey(RetCodUsr(),'ZPT_USER') ))

                If ( lAprov .Or. lAdm )
                    cMsg := FWInputBox("Informe a justificativa da rejeição", "")

                    If Empty(cMsg)
                        MsgStop('Necessário preencher a justificativa da rejeição', 'MT105MNU')
                        lRet := .F.
                    Else
                        cMsgAux := 'Usuário Rejeição: '+UsrRetName(RetCodUsr()) + CRLF
                        cMsgAux += 'Data Rejeição: '+DToC(Date()) + CRLF
                        cMsgAux += 'Hora Rejeição: '+Left(Time(),5) + CRLF
                        cMsgAux += 'Justificativa: '+cMsg + CRLF
                        
                        RecLock('SCP', .F.)
                            SCP->CP_XMSGLIB := cMsgAux
                            SCP->CP_STATSA  := 'R'
                            SCP->CP_SALBLQ  := SCP->CP_QUANT
                        SCP->(MsUnlock())
                    EndIf
                Else
                    MsgStop('Usuário não possui permissão para rejeitar a solicitação.', 'MT105MNU')
                EndIf
            EndIf
        EndIf
    Else
        MsgStop('Somente é possível liberar ou rejeitar solicitações geradas na rotina O.S. Corretiva (MNTA420)','MT105MNU')
    EndIf

Return

  
Static Function fTelaInsumo()

Local aArea := GetArea()
//Fontes
Local cFontUti    := "Tahoma"
Local oFontSub    := TFont():New(cFontUti,,-20)
Local oFontBtn    := TFont():New(cFontUti,,-14)
//Janela e componentes
Private oDlgGrp
Private oPanGrid
Private oGetGrid
Private aHeaderGrid := {}
Private aColsGrid := {}
//Tamanho da janela
Private aTamanho := MsAdvSize()
Private nJanLarg := aTamanho[5] / 1.5
Private nJanAltu := aTamanho[6] / 1.7
  
    //Monta o cabecalho
    fMontaHead()
  
    //Criando a janela
    DEFINE MSDIALOG oDlgGrp TITLE "" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
        //Labels gerais
        @ 006, 005 SAY "Insumos da Ultima Requisição" SIZE 200, 030 FONT oFontSub  OF oDlgGrp COLORS RGB(031,073,125) PIXEL
  
        //Botões
        @ 006, (nJanLarg/2-001)-(0052*01) BUTTON oBtnFech  PROMPT "Fechar"   SIZE 050, 018 OF oDlgGrp ACTION (oDlgGrp:End())   FONT oFontBtn PIXEL
        @ 006, (nJanLarg/2-001)-(0052*02) BUTTON oBtnLege  PROMPT "Aprovar"  SIZE 050, 018 OF oDlgGrp ACTION (fLiberar()) PIXEL
  
        //Dados
        @ 024, 003 GROUP oGrpDad TO (nJanAltu/2-003), (nJanLarg/2-003) PROMPT "" OF oDlgGrp COLOR 0, 16777215 PIXEL
        oGrpDad:oFont := oFontBtn
            oPanGrid := tPanel():New(033, 006, "", oDlgGrp, , , , RGB(000,000,000), RGB(254,254,254), (nJanLarg/2 - 13),     (nJanAltu/2 - 45))
            oGetGrid := FWBrowse():New()
            oGetGrid:DisableFilter()
            oGetGrid:DisableConfig()
            oGetGrid:DisableReport()
            oGetGrid:DisableSeek()
            oGetGrid:DisableSaveConfig()
            oGetGrid:SetFontBrowse(oFontBtn)
            oGetGrid:SetDataArray()
            oGetGrid:lHeaderClick :=.f.
            oGetGrid:SetColumns(aHeaderGrid)
            oGetGrid:SetArray(aColsGrid)
            oGetGrid:SetOwner(oPanGrid)
            oGetGrid:Activate()
  
        FWMsgRun(, {|oSay| fMontDados(oSay) }, "Processando", "Buscando")
    ACTIVATE MsDialog oDlgGrp CENTERED
  
    RestArea(aArea)
Return


Static Function fLiberar()

mv_par01 := 1 //mv_par01 Liberacao de SA 1- Por Item,2- Por Solicitacao
A107Lib()
oDlgGrp:End()

Return

  
Static Function fMontaHead()
    Local nAtual
    Local aHeadAux := {}
  
    //Adicionando colunas
    //[1] - Titulo
    //[2] - Tipo
    //[3] - Tamanho
    //[4] - Decimais
    //[5] - Máscara
    aAdd(aHeadAux, {"Ordem Serv.",       "C", TamSX3('TL_ORDEM')[01],   0, ""})
    aAdd(aHeadAux, {"Tarefa",            "C", TamSX3('TL_TAREFA')[01],    0, ""})
    aAdd(aHeadAux, {"Nome Tarefa",       "C", TamSX3('TL_NOMTAR')[01],  0, ""})
    aAdd(aHeadAux, {"Tipo Insumo",       "C", TamSX3('TL_TIPOREG')[01],  0, ""})
    aAdd(aHeadAux, {"Nome T.Insum",      "C", TamSX3('TL_NOMTREG')[01],  0, ""})
    aAdd(aHeadAux, {"Codigo Insumo",     "C", TamSX3('TL_CODIGO')[01],  0, ""})
    aAdd(aHeadAux, {"Nome Insumo",       "C", TamSX3('TL_NOMCODI')[01],  0, ""})
    aAdd(aHeadAux, {"Almoxarifado",      "C", TamSX3('TL_LOCAL')[01],  0, ""})
    aAdd(aHeadAux, {"Data Inicio",       "D", TamSX3('TL_DTINICI')[01],  0, ""})
    aAdd(aHeadAux, {"Hora Inicio",       "C", TamSX3('TL_HOINICI')[01],  0, ""})
    aAdd(aHeadAux, {"Data Fim",          "D", TamSX3('TL_DTFIM')[01],  0, ""})
    aAdd(aHeadAux, {"Hora Fim",          "C", TamSX3('TL_HOFIM')[01],  0, ""})
    aAdd(aHeadAux, {"Recno",             "N", 18, 0, "@E 999,999,999,999,999,999"})
  
    //Percorrendo e criando as colunas
    For nAtual := 1 To Len(aHeadAux)
        aAdd(aHeaderGrid, FWBrwColumn():New())
        aHeaderGrid[nAtual]:SetData(&("{||oGetGrid:oData:aArray[oGetGrid:At(),"+Str(nAtual)+"]}"))
        aHeaderGrid[nAtual]:SetTitle( aHeadAux[nAtual][1] )
        aHeaderGrid[nAtual]:SetType(aHeadAux[nAtual][2] )
        aHeaderGrid[nAtual]:SetSize( aHeadAux[nAtual][3] )
        aHeaderGrid[nAtual]:SetDecimal( aHeadAux[nAtual][4] )
        aHeaderGrid[nAtual]:SetPicture( aHeadAux[nAtual][5] )
    Next
Return
  
Static Function fMontDados(oSay)
    Local aArea := GetArea()
    Local nAtual := 0
    Local nTotal := 0
  
    Private LCORRET := .F. //variavel NGNOMETAR nao apagar 
    //Zera a grid
    aColsGrid := {}
      
    //Montando a query
    oSay:SetText("Montando a consulta")

    cQuery := " SELECT STL.R_E_C_N_O_ AS RECSTL, * FROM "+RetSqlName("SCP")+" SCP
    cQuery += " INNER JOIN "+RetSqlName("STL")+" STL
    cQuery += " 	ON TL_FILIAL = CP_FILIAL
    cQuery += " 	AND TL_NUMSA = CP_NUM
    cQuery += " 	AND TL_ITEMSA = CP_ITEM
    cQuery += " 	AND STL.D_E_L_E_T_ = ''
    cQuery += " INNER JOIN "+RetSqlName("STJ")+" STJ
    cQuery += " 	ON  TJ_FILIAL = TL_FILIAL
    cQuery += " 	AND TJ_ORDEM = TL_ORDEM
    cQuery += " 	AND STJ.D_E_L_E_T_ = ''
    cQuery += " WHERE SCP.D_E_L_E_T_ = ''
    cQuery += " 	AND CP_FILIAL = '"+FWxFilial('SCP')+"'
    cQuery += " 	AND CP_XORIGEM = 'MNTA420'
    cQuery += " 	AND CP_NUM = '"+SCP->CP_NUM+"'
    cQuery += " 	AND CP_ITEM = '"+SCP->CP_ITEM+"'

    //Executando a query
    oSay:SetText("Executando a consulta")
    PLSQuery(cQuery, "QRYTMP")
  
    //Se houve dados
    If ! QRYTMP->(EoF())
        //Pegando o total de registros
        DbSelectArea("QRYTMP")
        Count To nTotal
        QRYTMP->(DbGoTop())
  
        //Enquanto houver dados
        While ! QRYTMP->(EoF())
  
            //Muda a mensagem na regua
            nAtual++
            oSay:SetText("Adicionando registro " + cValToChar(nAtual) + " de " + cValToChar(nTotal) + "...")
            
            aAdd(aColsGrid, {;
                QRYTMP->TL_ORDEM,;
                QRYTMP->TL_TAREFA,;
                NGNOMETAR(QRYTMP->TJ_CODBEM+QRYTMP->TJ_SERVICO+QRYTMP->TJ_SEQRELA,QRYTMP->TL_TAREFA,TAMSX3('TL_NOMTAR')[1]),;
                QRYTMP->TL_TIPOREG,;
                TIPREGBRW(QRYTMP->TL_TIPOREG),;
                QRYTMP->TL_CODIGO,;
                NOMINSBRW(QRYTMP->TL_TIPOREG,QRYTMP->TL_CODIGO),;
                QRYTMP->TL_LOCAL,;
                QRYTMP->TL_DTINICI,;
                QRYTMP->TL_HOINICI,;
                QRYTMP->TL_DTFIM,;
                QRYTMP->TL_HOFIM,;
                QRYTMP->RECSTL,;
                .F.;
            })

            QRYTMP->(DbSkip())
        EndDo
  
    Else  
        aAdd(aColsGrid, {"","","","","","","","","","","","",0,.F.})
    EndIf

    QRYTMP->(DbCloseArea())
  
    //Define o array
    oSay:SetText("Atribuindo os dados na tela")
    oGetGrid:SetArray(aColsGrid)
    oGetGrid:Refresh()
  
    RestArea(aArea)
Return
>>>>>>> b3349244d7734cf999320414fd7ddc6418c1fc96
