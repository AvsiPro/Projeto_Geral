//Bibliotecas
#Include "TOTVS.ch"
#Include "TopConn.ch"

Static cObserv   := "" //Essa vari�vel ser� usada no rodap�, para exibir mensagens de aviso
Static nTransQry := 1  //Define se o texto da query ir� passar por transforma��o, exemplo, 0 - N�o; 1 - Tudo mai�sculo (SQL Server e Oracle); 2 - Tudo min�sculo (Postgre)

/*/{Protheus.doc} User Function zTiSQL
Fun��o do Terminal de Informa��o para executar queries SQL em bases Protheus
@type  Function
@author Atilio
@since 19/12/2020
@version version
@example
    u_zTiSQL()
@obs Fun��o ideal para ser usada em ambientes TCloud, pode ser colocado um atalho ao iniciar o sistema via AfterLogin
    User Function AfterLogin()
        SetKey(K_SH_F11, { || u_zTiSQL() }) //Shift + F11
    Return
@see https://terminaldeinformacao.com
/*/

User Function zTiSQL()
    Local aArea
    Local cEmpAux := "01"
    Local cFilAux := "010101"
    Local cUsrAux := "Admin"
    Local cPswAux := "@Totvs2020@"
    Private lProgInic := .F.

    //Se vier direto do programa inicial, prepara o ambiente
    If Select("SX2") == 0
        RPCSetType(3)
		RPCSetEnv(cEmpAux, cFilAux, cUsrAux, cPswAux, "", "")
        lContinua := .T.
        lProgInic := .T.

    //Sen�o, se vier de dentro do SIGAMDI / SIGAADV, verifica se � admin
    Else
        lContinua := FWIsAdmin()
    EndIf
    aArea := GetArea()

    //Se deu tudo certo, abre a tela
    If lContinua
        fMontaTela()
    Else
        MsgStop("Somente usu�rios admin podem acessar a rotina!", "Aten��o")
    EndIf

    RestArea(aArea)
Return

/*/{Protheus.doc} fMontaTela
Fun��o que realiza a montagem da tela
@type  Function
@author Daniel Atilio
@since 19/12/2020
@version version
@see https://terminaldeinformacao.com
/*/

Static Function fMontaTela()
    Local nLinObj := 0
    Local nLargBtn := 60
    Local cPastaTemp := GetTempPath()
    //Blocos de c�digo chamados pelos bot�es
    Local bExecutar := {|| fZeraLog(), fExecutar() }
    Local bHistoric := {|| fZeraLog(), fAbreHist() }
    Local bAbrir    := {|| fZeraLog(), fAbrir() }
    Local bSalvar   := {|| fZeraLog(), fSalvar() }
    Local bFechar   := {|| oDlgSQL:End() }
	Local bExportar := {|| fZeraLog(), fExportar() }
	Local bIndentar := {|| fZeraLog(), fIndentar() }
	Local bSelect   := {|| fZeraLog(), fGerSelect() }
	Local bUpdate   := {|| fZeraLog(), fGerUpdate() }
    Local bAjuda    := {|| fZeraLog(), fAjuda() }
    Local bCampos   := {|| fZeraLog(), fConsSX3()}
    //Fontes
    Private cFontPad    := "Tahoma"
    Private oFontBtn    := TFont():New(cFontPad, , -14)
	Private oFontBtnN   := TFont():New(cFontPad, , -14, , .T.)
    Private oFontMod    := TFont():New(cFontPad, , -38)
	Private oFontSub    := TFont():New(cFontPad, , -20)
	Private oFontSubN   := TFont():New(cFontPad, , -20, , .T.)
    //Caminho do arquivo que guarda a �ltima execu��o de query
    Private cUltPasta  := cPastaTemp
    Private cLastQry   := cPastaTemp + "ztisql.txt"
    Private cPastaHist := cPastaTemp + "historico_zTiSQL\"
    //Objetos da Janela
    Private lCentered
    Private oBtnExe
    Private oBtnHis
    Private oBtnAbr
    Private oBtnSal
    Private oBtnFec
	Private oBtnExp
	Private oBtnInd
	Private oBtnSel
	Private oBtnUpd
    Private oSayModulo, cSayModulo := 'CFG'
    Private oSayTitulo, cSayTitulo := 'zTiSQL - Execucao de Queries SQL'
    Private oSaySubTit, cSaySubTit := 'https://terminaldeinformacao.com'
    Private oDlgSQL
    Private oPanSQL
    Private oPanResult
    Private oEditSQL, cEditSQL := "Digite aqui sua query (F3 para selecionar campos do Dicion�rio)..."
    Private oSayLog, cSayLog
    //Tamanho da janela
    Private aTamanho
    Private nJanLarg
    Private nJanAltu
    Private nJanAltMei
    Private nPosTop
    Private nPosLeft
    //Resultados da query
    Private oEditResult
    Private oMResult
    Private aHeadResu  := {}
    Private lEmExecucao := .F.
    Private cAliasResu  := ""

    //Se vier do programa inicial, a dimens�o ser� diferente
    If lProgInic
        aTamanho  := GetScreenRes()
        nJanLarg  := aTamanho[1]
        nJanAltu  := aTamanho[2] - 80
        lCentered := .F.
        nPosTop   := 0
        nPosLeft  := -10
    Else
        aTamanho  := MsAdvSize()
        nJanLarg  := aTamanho[5]
        nJanAltu  := aTamanho[6]
        lCentered := .T.
        nPosTop   := 0
        nPosLeft  := 0
    EndIf
    nJanAltMei := nJanAltu/4

    //Se existir o arquivo, busca o conte�do
    If File(cLastQry)
        oFile   := FwFileReader():New(cLastQry)
        If oFile:Open()
            //Busca o conte�do do arquivo
            cArqConteu := oFile:FullRead()
            cEditSQL   := cArqConteu
            oFile:Close()
        EndIf
    EndIf

	//Define os atalhos do F3 e F5
    SetKey(VK_F3, bCampos)
	SetKey(VK_F5, bExecutar)

    //Cria a janela
    oDlgSQL := TDialog():New(nPosTop, nPosLeft, nJanAltu, nJanLarg, cSayTitulo, , , , , CLR_BLACK, RGB(250, 250, 250), , , .T.)
        //T�tulos e SubT�tulos
        oSayModulo := TSay():New(004, 003, {|| cSayModulo}, oDlgSQL, "", oFontMod,  , , , .T., RGB(149, 179, 215), , 200, 30, , , , , , .F., , )
        oSayTitulo := TSay():New(004, 045, {|| cSayTitulo}, oDlgSQL, "", oFontSub,  , , , .T., RGB(031, 073, 125), , 200, 30, , , , , , .F., , )
        oSaySubTit := TSay():New(014, 045, {|| cSaySubTit}, oDlgSQL, "", oFontSubN, , , , .T., RGB(031, 073, 125), , 300, 30, , , , , , .F., , )

		//Bot�es
        oBtnExe := TButton():New(001, (nJanLarg/2) - (nLargBtn * 5), "[F5] Executar",      oDlgSQL, bExecutar, nLargBtn,   012, , oFontBtnN, , .T., , , , , , )
        oBtnHis := TButton():New(001, (nJanLarg/2) - (nLargBtn * 4), "Ver Hist�rico",      oDlgSQL, bHistoric, nLargBtn,   012, , oFontBtn,  , .T., , , , , , )
        oBtnAbr := TButton():New(001, (nJanLarg/2) - (nLargBtn * 3), "Abrir .sql",         oDlgSQL, bAbrir,    nLargBtn,   012, , oFontBtn,  , .T., , , , , , )
        oBtnSal := TButton():New(001, (nJanLarg/2) - (nLargBtn * 2), "Salvar .sql",        oDlgSQL, bSalvar,   nLargBtn,   012, , oFontBtn,  , .T., , , , , , )
        oBtnFec := TButton():New(001, (nJanLarg/2) - (nLargBtn * 1), "Fechar",             oDlgSQL, bFechar,   nLargBtn,   012, , oFontBtn,  , .T., , , , , , )
        oBtnAju := TButton():New(015, (nJanLarg/2) - (nLargBtn * 5), "Ajuda / Help",       oDlgSQL, bAjuda,    nLargBtn,   012, , oFontBtn,  , .T., , , , , , )
		oBtnExp := TButton():New(015, (nJanLarg/2) - (nLargBtn * 4), "Export. Resultado",  oDlgSQL, bExportar, nLargBtn,   012, , oFontBtn,  , .T., , , , , , )
		oBtnInd := TButton():New(015, (nJanLarg/2) - (nLargBtn * 3), "Indentar Query",     oDlgSQL, bIndentar, nLargBtn,   012, , oFontBtn,  , .T., , , , , , )
		oBtnSel := TButton():New(015, (nJanLarg/2) - (nLargBtn * 2), "Gerar Select",       oDlgSQL, bSelect,   nLargBtn,   012, , oFontBtn,  , .T., , , , , , )
		oBtnUpd := TButton():New(015, (nJanLarg/2) - (nLargBtn * 1), "Gerar Update",       oDlgSQL, bUpdate,   nLargBtn,   012, , oFontBtn,  , .T., , , , , , )

        //Observa��o
        nLinObj := 028
        oSayObs := TSay():New(nLinObj, 003, {|| "Para executar queries: ou 1 = Selecione o texto e aperte F5, ou 2 = Aperte F5 que ir� executar todo o texto digitado"}, oDlgSQL, "", oFontBtn, , , , .T., RGB(150, 150, 150), , (nJanLarg/2) - 6, 10, , , , , , .F., , )

        //Cria o editor de consulta SQL
		nLinObj := 038
        oPanSQL := tPanel():New(nLinObj, 3, "", oDlgSQL, , , , RGB(000,000,000), RGB(254,254,254), (nJanLarg/2) - 3, nJanAltMei - 26)
            oEditSQL := TSimpleEditor():Create(oPanSQL)
            oEditSQL:lAutoIndent := .T.
            oEditSQL:TextFamily("Consolas")
            oEditSQL:nWidth := oPanSQL:nWidth
            oEditSQL:nHeight := oPanSQL:nHeight
            oEditSQL:TextFormat(2) //1=Html; 2=Plain Text
            oEditSQL:TextSize(11)
            oEditSQL:Load(cEditSQL)
            oEditSQL:Refresh()

        //Cria o Painel que conter� o resultado
        nLinObj := nJanAltMei + 12
        oPanResult := tPanel():New(nLinObj, 3, "", oDlgSQL, , , , RGB(000,000,000), RGB(200,200,200), (nJanLarg/2) - 3, (nJanAltu/2) - nLinObj - 10)

        //Log dos erros
        nLinObj := (nJanAltu/2) - 10
        oSayLog := TSay():New(nLinObj, 003, {|| cSayLog}, oDlgSQL, "", oFontBtn, , , , .T., RGB(254, 0, 0), , (nJanLarg/2) - 6, 10, , , , , , .F., , )

    //Ativa e exibe a janela
    oDlgSQL:Activate(, , , lCentered, {|| .T.}, , )
Return

/*/{Protheus.doc} fExecutar
Fun��o que executa a instru��o SQL
@type  Function
@author Daniel Atilio
@since 19/12/2020
@version version
@see https://terminaldeinformacao.com
/*/

Static Function fExecutar()
    Local cComeco    := ""
    Local cTextoSel  := oEditSQL:RetTextSel()
    Local lContinua  := .T.
    Local cTexto     := oEditSQL:RetText()
    Local lInto      := .F.
    Local nPosicao   := 0
    Local cTextoNov  := ""
    Local lApostrofo := .F.
    Local cCaractere := ""
    Local cApenasSel := ""
	
	cObserv := ""
    
    //Se estiver em execu��o, avisa que n�o � poss�vel
    If lEmExecucao
        cSayLog := "Existe uma query em execu��o na mem�ria, aguarde o t�rmino!"
        oSayLog:Refresh()
        MsgStop(cSayLog, "Aten��o")

    //Sen�o executa a query
    Else
        lEmExecucao := .T.
        //Se existir texto selecionado
        If ! Empty(cTextoSel)
            //Substitui o caractere interroga��o por espa�o vazio (-enter- e -tab-)
            cTextoSel := StrTran(cTextoSel, "?", ' ')
			
			//Como o m�todo RetTextSel traz interroga��o tanto para enter quanto para tab, se substituir por CRLF pode ser que a query tenha muitos -enters- no resultado final
			//  Ent�o dessa forma � avisado o usu�rio para utilizar /* e */
			//  Do contr�rio, se voc� quiser usar o CRLF, na linha acima do StrTran, ao inv�s do ' ', coloque CRLF
			If "--" $ cTextoSel
				cObserv += "Ao inv�s de -- tente utilizar /* e */ ;"
			EndIf

        //Sen�o, ser� todo o texto digitado
        Else
            cTextoSel := cTexto
        EndIf
        
        //Grava o texto na tempor�ria do S.O. (arquivo tempor�rio)
        fSalvArq(cLastQry)

        //Grava o log na pasta do hist�rico
        fSalvHis(cTextoSel)

        //Se houver texto selecionado
        If ! Empty(cTextoSel)

            //Busca o come�o da query, at� o primeiro espa�o
            cComeco := Alltrim(Upper(cTextoSel))
            cComeco := SubStr(cComeco, 1, At(' ', cComeco))

            //Verifica se tem " INTO " na query, por causa do SELECT INTO no SQL SERVER
            lInto := " INTO " $ cTextoSel

            //Se a query � para ser transformada
            If nTransQry != 0
                For nPosicao := 1 To Len(cTextoSel)
                    cCaractere := SubStr(cTextoSel, nPosicao, 1)

                    //Se for um ap�strofo
                    If cCaractere == "'"
                        lApostrofo := ! lApostrofo

                    //Se n�o estiver dentro de um ap�strofo
                    ElseIf ! lApostrofo
                        //Se for mai�sculo
                        If nTransQry == 1
                            cCaractere := Upper(cCaractere)

                        //Se for min�sculo
                        ElseIf nTransQry == 2
                            cCaractere := Lower(cCaractere)
                        EndIf
                    EndIf

                    cTextoNov += cCaractere
                Next

                cTextoSel := cTextoNov
            EndIf

            //Se n�o for Select Into
            If ! lInto
                cApenasSel := Left( cTextoSel, RAt("FROM", Upper(cTextoSel))-1 )

                //Tratativa de campos de Log
                If "_USERGI" $ Upper(cApenasSel) .Or. "_USERLGI" $ Upper(cApenasSel) .Or."_USERGA" $ Upper(cApenasSel) .Or. "_USERLGA" $ Upper(cApenasSel) 
                    If FWAlertYesNo("Foi encontrado campos de Log (LGI/LGA) no Select. Deseja j� traduzir seu conte�do?", "Confirma?")
                        cTextoSel := fTrataLG(cTextoSel)
                    EndIf
                EndIf
            EndIf

            //Se a query for um Select
            If "SELECT" $ cComeco .And. ! lInto
                //Se n�o tiver WHERE nem TOP
                If ! "WHERE" $ Upper(cTextoSel) .And. ! "TOP " $ Upper(cTextoSel)
                    lContinua := MsgYesNo("N�o foi encontrado os comandos WHERE e TOP na query, isso pode causar uma lentid�o na busca, deseja continuar?", "Executar SELECT")
                EndIf

                //Se for continuar, chama a execu��o da query
                If lContinua
                    RptStatus({|| fSelecionar(cTextoSel)}, "Processando", "Buscando Registros...")
                EndIf

            //Se for uma manipula��o
            ElseIf "UPDATE" $ cComeco .Or. "INSERT" $ cComeco .Or. "DELETE" $ cComeco .Or. lInto
                lContinua := MsgYesNo("Comandos de manipula��o de dados podem ser prejudiciais para integridade de dados na base, voc� deseja continuar?", "Aten��o")

                //Se for continuar, chama a execu��o da query
                If lContinua
                    RptStatus({|| fManipular(cTextoSel)}, "Processando", "Atualizando Registros...")
                EndIf

            //Sen�o, n�o encontrou
            Else
                cSayLog := "Comando n�o reconhecido!"
                oSayLog:Refresh()
                MsgStop(cSayLog, "Aten��o")
            EndIf
        Else
            cSayLog := "Selecione o texto da query que ser� executada"
            oSayLog:Refresh()
            MsgInfo(cSayLog, "Aten��o")
        EndIf

        lEmExecucao := .F.
    EndIf
    
Return

/*/{Protheus.doc} fAbrir
Fun��o para abrir um arquivo
@type  Function
@author Daniel Atilio
@since 19/12/2020
@version version
@see https://terminaldeinformacao.com
/*/

Static Function fAbrir()
    Local aArea   := GetArea()
    Local cDirIni := cUltPasta
    Local cTipArq := "Arquivos query (*.sql) | Arquivos texto (*.txt)"
    Local cTitulo := "Selecione um arquivo"
    Local lSalvar := .F.
    Local cArqSel := ""
    Local oFile
    Local cArqConteu := ""
 
    //Chama a fun��o para buscar arquivos
    cArqSel := tFileDialog(;
        cTipArq,;  // Filtragem de tipos de arquivos que ser�o selecionados
        cTitulo,;  // T�tulo da Janela para sele��o dos arquivos
        ,;         // Compatibilidade
        cDirIni,;  // Diret�rio inicial da busca de arquivos
        lSalvar,;  // Se for .T., ser� uma Save Dialog, sen�o ser� Open Dialog
        ;          // Se n�o passar par�metro, ir� pegar apenas 1 arquivo; Se for informado GETF_MULTISELECT ser� poss�vel pegar mais de 1 arquivo; Se for informado GETF_RETDIRECTORY ser� poss�vel selecionar o diret�rio
    )

    //Se o arquivo existir
    If ! Empty(cArqSel) .And. File(cArqSel)

        //Tenta abrir o arquivo
        oFile   := FwFileReader():New(cArqSel)
        If oFile:Open()
            //Busca o conte�do do arquivo
            cArqConteu  := oFile:FullRead()
            oEditSQL:Load(cArqConteu)
            oEditSQL:Refresh()
            oFile:Close()

            cUltPasta := SubStr(cArqSel, 1, RAt("\", cArqSel))
        Else
            cSayLog := "N�o foi poss�vel abrir o arquivo"
            oSayLog:Refresh()
            MsgStop(cSayLog, "Aten��o")
        EndIf
    EndIf
 
    RestArea(aArea)
Return

/*/{Protheus.doc} fSalvar
Fun��o para salvar um arquivo acionado pelo bot�o
@type  Function
@author Daniel Atilio
@since 19/12/2020
@version version
@see https://terminaldeinformacao.com
/*/

Static Function fSalvar()
    Local aArea   := GetArea()
    Local cDirIni := cUltPasta
    Local cTipArq := "Arquivos query (*.sql) | Arquivos texto (*.txt)"
    Local cTitulo := "Digite um nome do arquivo e selecione o local"
    Local lSalvar := .T.
    Local cArqSel := ""
 
    //Chama a fun��o para buscar arquivos
    cArqSel := tFileDialog(;
        cTipArq,;  // Filtragem de tipos de arquivos que ser�o selecionados
        cTitulo,;  // T�tulo da Janela para sele��o dos arquivos
        ,;         // Compatibilidade
        cDirIni,;  // Diret�rio inicial da busca de arquivos
        lSalvar,;  // Se for .T., ser� uma Save Dialog, sen�o ser� Open Dialog
        ;          // Se n�o passar par�metro, ir� pegar apenas 1 arquivo; Se for informado GETF_MULTISELECT ser� poss�vel pegar mais de 1 arquivo; Se for informado GETF_RETDIRECTORY ser� poss�vel selecionar o diret�rio
    )

    //Se o arquivo existir
    If ! Empty(cArqSel)
        //Salva o arquivo
        fSalvArq(cArqSel)

        //Atualiza a �ltima pasta
        cUltPasta := SubStr(cArqSel, 1, RAt("\", cArqSel))
    EndIf
 
    RestArea(aArea)
Return

/*/{Protheus.doc} fSalvArq
Fun��o que salva o arquivo em uma pasta
@type  Function
@author Daniel Atilio
@since 19/12/2020
@version version
@see https://terminaldeinformacao.com
/*/

Static Function fSalvArq(cArquivo)
    Local oFWriter
    Local cTexto   := oEditSQL:RetText()
    
    //Grava o arquivo com o conte�do textual
    oFWriter := FWFileWriter():New(cArquivo, .T.)
    oFWriter:Create()
    oFWriter:Write(cTexto)
    oFWriter:Close()
Return

/*/{Protheus.doc} fSalvHis
Fun��o que salva o arquivo na pasta de hist�rico
@type  Function
@author Daniel Atilio
@since 09/07/2022
@version version
@see https://terminaldeinformacao.com
/*/

Static Function fSalvHis(cTexto)
    Local oFWriter
    Local cArquivo := cPastaHist + Left(cTexto, 3) + "_" + dToS(Date()) + "_" + StrTran(Time(), ":", "-") + ".txt"
    
    //Se a pasta n�o existir, ser� criada
    If ! ExistDir(cPastaHist)
        MakeDir(cPastaHist)
    EndIf

    //Grava o arquivo com o conte�do textual
    oFWriter := FWFileWriter():New(cArquivo, .T.)
    oFWriter:Create()
    oFWriter:Write(cTexto)
    oFWriter:Close()
Return

/*/{Protheus.doc} fConsSX3
Fun��o para abrir a lista de campos do dicion�rio
@type  Function
@author Daniel Atilio
@since 19/12/2020
@version version
@see https://terminaldeinformacao.com
/*/

Static Function fConsSX3()
    Local lOk     := .F.
    Local aCampos := {}
    Local cTexto  := ""
    Local nAtual
    
    //Chama a consulta
    lOk := u_zConsSX3()

    //Se a consulta for confirmada
    If lOk
        //Se existir o retorno
        If ! Empty(__cRetorn)
            __cRetorn := Alltrim(__cRetorn)
            aCampos := StrTokArr(__cRetorn, ",")

            //Percorre os campos
            For nAtual := 1 To Len(aCampos)
                If ! Empty(aCampos[nAtual])
                    cTexto += "    " + aCampos[nAtual] + "," + CRLF
                EndIf
            Next

            //Atualiza o texto, com o que j� existia
            cEditSQL := cTexto + CRLF + oEditSQL:RetText()
            oEditSQL:Load(cEditSQL)
            oEditSQL:Refresh()
        EndIf
    EndIf
Return

/*/{Protheus.doc} fGerSelect
Fun��o que gera uma query SQL
@type  Function
@author Daniel Atilio
@since 19/12/2020
@version version
@see https://terminaldeinformacao.com
/*/

Static Function fGerSelect()
    Local aPergs   := {}
    Local cTabela  := Space(20)
    Local cCampos  := Space(100)
    Local nLinhas  := 0
    Local nOrden   := 1
    Local cQuery   := ""
    
    //Adiciona os par�metros
    aAdd(aPergs, {1, "Tabela",                          cTabela, "@!",     ".T.",        "", ".T.", 070, .T.})
    aAdd(aPergs, {1, "Campos (separados por v�rgula)",  cCampos, "@!",     ".T.",        "", ".T.", 110, .F.})
    aAdd(aPergs, {1, "N�mero de Linhas (SQL Server)",   nLinhas, "@E 999", "Positivo()", "", ".T.", 040, .F.})
    aAdd(aPergs, {2, "Ordena��o",                       nOrden,  {"1=Sem Ordena��o", "2=RecNo Decrescente", "3=RecNo Crescente"},   090, ".T.", .F.})

    //Se a pergunta foi confirmada
    If ParamBox(aPergs, "Informe os par�metros", , , , , , , , , .F., .F.)
        cTabela := Alltrim(MV_PAR01)
        cCampos := Alltrim(MV_PAR02)
        nLinhas := MV_PAR03
        nOrden  := Val(cValToChar(MV_PAR04))

        //Monta a query
        cQuery := " SELECT " + CRLF

        //Se houver quantidade de linhas
        If nLinhas > 0
            cQuery += " TOP " + cValToChar(nLinhas) + " " + CRLF
        EndIf

        //Se houver campos
        If ! Empty(cCampos)
            cQuery += "     " + cCampos + " " + CRLF
        Else
            cQuery += "     * " + CRLF
        EndIf

        //Agora monta o from
        cQuery += " FROM " + CRLF

        //Se o alias tiver s� 3 no tamanho, busca com RetSQLName
        If Len(cTabela) == 3
            cQuery += "     " + RetSQLName(cTabela) + " T " + CRLF

        //Sen�o, ser� o nome da tabela inteira
        Else
            cQuery += "     " + cTabela + " " + CRLF
        EndIf

        //Agora por �ltimo, monta o WHERE default
        cQuery += " WHERE " + CRLF
        
        //Se a tabela for de 3 caracteres, filtra o campo de filial
        If Len(cTabela) == 3
            cQuery += "     " + IIf(SubStr(cTabela, 1, 1) == "S", SubStr(cTabela, 2), cTabela) + "_FILIAL = '" + FWxFilial(cTabela) + "' AND " + CRLF
        EndIf

        //Filtro de campo deletado
        cQuery += "     T.D_E_L_E_T_ = '' " + CRLF

        //Se a ordena��o for diferente da padr�o
        If nOrden != 1
            cQuery += " ORDER BY " + CRLF

            //Se for decrescente
            If nOrden == 2
                cQuery += "     T.R_E_C_N_O_ DESC " + CRLF

            //Se for crescente
            ElseIf nOrden == 3
                cQuery += "     T.R_E_C_N_O_ ASC " + CRLF
            EndIf
        EndIf

        //Atualiza o texto, com o que j� existia
        cEditSQL := cQuery + CRLF + oEditSQL:RetText()
        oEditSQL:Load(cEditSQL)
        oEditSQL:Refresh()
    EndIf
Return

/*/{Protheus.doc} fAjuda
Fun��o que abre a p�gina online de help
@type  Function
@author Daniel Atilio
@since 19/12/2020
@version version
@see https://terminaldeinformacao.com
/*/

Static Function fAjuda()
    Local cLink := "https://terminaldeinformacao.com/ztisql"

    //Abre o link no navegador padr�o
    ShellExecute("Open", cLink, "", "", 1)
Return

/*/{Protheus.doc} fManipular
Executa uma query de manipula��o na base de dados
@type  Function
@author Daniel Atilio
@since 19/12/2020
@version version
@see https://terminaldeinformacao.com
/*/

Static Function fManipular(cQuery)
    Local nStatus   := 0
    Local cMensagem := ""
    Local cInicio   := Time()
    Local cTermino  := ""
    Local aQuery    := {}
    Local nAtual    := 0

    //Se a grid existe, exclui ela
    If Type("oMResult") != "U"
        oMResult := Nil
        FreeObj(oMResult)
    EndIf

    //Se o label existe, exclui ele
    If Type("oEditResult") != "U"
        oEditResult := Nil
        FreeObj(oEditResult)
    EndIf

    //Se tiver ponto e v�rgula, quebra a query para poder executar mais de um comando
    If ";" $ cQuery
        aQuery := StrTokArr(cQuery, ";")
    Else
        aQuery := {cQuery}
    EndIf

    //Define a r�gua
    SetRegua(1 + Len(aQuery))
    IncRegua()

    //Agora ir� executar as queries
    For nAtual := 1 To Len(aQuery)
        If ! Empty(aQuery[nAtual])
            nStatus  := TCSQLExec(aQuery[nAtual])

            //Se houve erro
            If (nStatus < 0)
                cMensagem += "#" + cValToChar(nAtual) + " Erro na execu��o da query: " + CRLF + CRLF
                cMensagem += TCSQLError()
                cMensagem += CRLF + CRLF
            Else
                cMensagem += "#" + cValToChar(nAtual) + " Comando executado com sucesso!" + CRLF
            EndIf
        EndIf
    Next
    cTermino := Time()

    //Cria o label avisando do resultado
    oEditResult := TSimpleEditor():Create(oPanResult)
    oEditResult:lAutoIndent := .T.
    oEditResult:TextFamily("Consolas")
    oEditResult:nWidth := oPanResult:nWidth
    oEditResult:nHeight := oPanResult:nHeight
    oEditResult:TextFormat(2) //1=Html; 2=Plain Text
    oEditResult:TextSize(09)
    oEditResult:Load(cMensagem)
    oEditResult:Refresh()
    oEditResult:lReadOnly := .T.

    //Atualiza o log com o tempo total
    fAtuLog(cInicio, cTermino, 0)
Return

/*/{Protheus.doc} fZeraLog
Fun��o acionada para zerar o log do rodap�
@type  Function
@author Daniel Atilio
@since 19/12/2020
@version version
@see https://terminaldeinformacao.com
/*/

Static Function fZeraLog()
    cSayLog := ""
    oSayLog:Refresh()
Return

/*/{Protheus.doc} fZeraLog
Fun��o para atualizar o log com o tempo de execu��o da query
@type  Function
@author Daniel Atilio
@since 19/12/2020
@version version
@see https://terminaldeinformacao.com
/*/

Static Function fAtuLog(cInicio, cTermino, nQtdLinhas)
    cSayLog := "Inicio: " + cInicio
    cSayLog += " | Termino: " + cTermino
    cSayLog += " | Tempo Total: " + ElapTime(cInicio, cTermino)
    If nQtdLinhas != 0
        cSayLog += " | Quantidade de Linhas: " + cValToChar(nQtdLinhas)
    EndIf
    If ! Empty(cObserv)
        cSayLog += " | Obs: " + cObserv
    EndIf
    oSayLog:Refresh()
Return

/*/{Protheus.doc} fGerUpdate
Fun��o que gera uma query SQL de atualiza��o (update)
@type  Function
@author Daniel Atilio
@since 19/12/2020
@version version
@see https://terminaldeinformacao.com
/*/

Static Function fGerUpdate()
    Local aPergs     := {}
    Local cTabela    := Space(20)
    Local cCampo     := Space(20)
    Local cConteud   := Space(100)
    Local cQuery     := ""
    Local cTipoCampo := ""
    
    //Adiciona os par�metros
    aAdd(aPergs, {1, "Tabela",                                        cTabela,  "@!",     ".T.",        "", ".T.", 070, .T.})
    aAdd(aPergs, {1, "Campo",                                         cCampo,   "@!",     ".T.",        "", ".T.", 100, .T.})
    aAdd(aPergs, {1, "Conte�do",                                      cConteud, "",       ".T.",        "", ".T.", 100, .T.})
    
    //Se a pergunta foi confirmada
    If ParamBox(aPergs, "Informe os par�metros", , , , , , , , , .F., .F.)
        cTabela   := Alltrim(MV_PAR01)
        cCampo    := Alltrim(MV_PAR02)
        cConteud  := Alltrim(MV_PAR03)

        //Monta a query
        cQuery := " UPDATE " + CRLF

        //Se o alias tiver s� 3 no tamanho, busca com RetSQLName
        If Len(cTabela) == 3
            cQuery += "     " + RetSQLName(cTabela) + " " + CRLF

        //Sen�o, ser� o nome da tabela inteira
        Else
            cQuery += "     " + cTabela + " " + CRLF
        EndIf

        //Agora monta a atualiza��o
        cQuery += " SET " + CRLF
        cQuery += "     " + cCampo + " = "

        //Se o campo existe no dicion�rio
        If GetSX3Cache(cCampo, "X3_TITULO") != ""
            //Busca o tipo do campo
            cTipoCampo := GetSX3Cache(cCampo, "X3_TIPO")

            //Se for data
            If cTipoCampo == 'D'
                //Se o conte�do tiver barra
                If "/" $ cConteud
                    cConteud := dToS(cToD(cConteud))
                EndIf
            EndIf

            //Se o tipo do campo for caractere ou data
            If cTipoCampo $ 'C,D'
                //Se o conte�do j� tiver ap�strofo
                If "'" $ cConteud
                    cQuery += cConteud
                Else
                    cQuery += "'" + cConteud + "'"
                EndIf

            //Sen�o, atualiza com conte�do default
            Else
                cQuery += cConteud
            EndIf

        //Sen�o, pega exatamente como o usu�rio digitou
        Else
            cQuery += cConteud
        EndIf
        cQuery += " " + CRLF

        //Agora por �ltimo, monta o WHERE default
        cQuery += " WHERE " + CRLF
        
        //Se a tabela for de 3 caracteres, filtra o campo de filial
        If Len(cTabela) == 3
            cQuery += "     " + IIf(SubStr(cTabela, 1, 1) == "S", SubStr(cTabela, 2), cTabela) + "_FILIAL = '" + FWxFilial(cTabela) + "' AND " + CRLF
        EndIf

        //Filtro de campo deletado
        cQuery += "     D_E_L_E_T_ = '' " + CRLF

        //Atualiza o texto, com o que j� existia
        cEditSQL := cQuery + CRLF + oEditSQL:RetText()
        oEditSQL:Load(cEditSQL)
        oEditSQL:Refresh()
    EndIf
Return

/*/{Protheus.doc} fSelecionar
Executa uma query de sele��o na base de dados
@type  Function
@author Daniel Atilio
@since 19/12/2020
@version version
@see https://terminaldeinformacao.com
/*/

Static Function fSelecionar(cQuery)
    Local nStatus   := 0
    Local cMensagem := ""
    Local cInicio   := Time()
    Local cTermino  := ""
    Local aEstrut   := {}
    Local nCampo    := 0
    Local cCampo
    Local cTitulo
    Local cMascara
    Local nQtdLinhas := 0
    Local cAliasGrid := GetNextAlias()
    Local cMsgCpoGrd := ""
    Local nTamanCpo  := 0
    Local cTipoCpo   := ""

    SetRegua(3)

    //Se tiver aberto o alias, fecha ele
    If Select(cAliasGrid) > 0
        (cAliasGrid)->(DbCloseArea())
    EndIf
    cAliasResu := cAliasGrid

    //Se a grid existe, exclui ela
    If Type("oMResult") != "U"
        oMResult := Nil
        FreeObj(oMResult)
    EndIf

    //Se o label existe, exclui ele
    If Type("oEditResult") != "U"
        oEditResult := Nil
        FreeObj(oEditResult)
    EndIf

    //Agora ir� executar a query
    IncRegua()
    nStatus  := TCSQLExec(cQuery)
    cTermino := Time()

    //Se houve erro
    If (nStatus < 0)
        cMensagem := "Erro na execu��o da query de SELECT: " + CRLF + CRLF
        cMensagem += TCSQLError()

        //Cria o label avisando do resultado
        oEditResult := TSimpleEditor():Create(oPanResult)
        oEditResult:lAutoIndent := .T.
        oEditResult:TextFamily("Consolas")
        oEditResult:nWidth := oPanResult:nWidth
        oEditResult:nHeight := oPanResult:nHeight
        oEditResult:TextFormat(2) //1=Html; 2=Plain Text
        oEditResult:TextSize(09)
        oEditResult:Load(cMensagem)
        oEditResult:Refresh()
        oEditResult:lReadOnly := .T.
    Else

        //Executa a query
        IncRegua()
        TCQuery cQuery New Alias "TMP_SQL"
        Count To nQtdLinhas
        TMP_SQL->(DbGoTop())
        cTermino := Time()
        
        //Percorre a estrutura e retira campos reservados
        aEstrutTmp   := TMP_SQL->(DbStruct())
        aEstrut      := {}
        For nCampo := 1 To Len(aEstrutTmp)
            cCampo    := Alltrim(aEstrutTmp[nCampo][1])
            cTipoCpo  := aEstrutTmp[nCampo][2]
            nTamanCpo := aEstrutTmp[nCampo][3]

            //Se o campo n�o for um reservado, adiciona na estrutura que ser� usada na grid
            If ! cCampo $ "R_E_C_N_O_ , R_E_C_D_E_L_ , D_E_L_E_T_, S_T_A_M_P_, I_N_S_D_T_, D_E_L_E_T_E_D_"
                If Len(cCampo) <= 10
                    aAdd(aEstrut, aClone(aEstrutTmp[nCampo]))
                Else
                    cObserv += "Campo '" + cCampo + "' maior que 10 caracteres; "
                EndIf

                //Caso algum campo tenha sido alterado na SX3
                If cTipoCpo == "C" .And. nTamanCpo > 254
                    If Empty(cMsgCpoGrd)
                        cMsgCpoGrd := "Campos maiores que 254 caracteres (conte�do cortado na grid): " + cCampo
                    Else
                        cMsgCpoGrd += ", " + cCampo
                    EndIf
                EndIf
            EndIf
        Next

        //Se existem campos grandes, adiciona na observa��o do rodap�
        If ! Empty(cMsgCpoGrd)
            cObserv += cMsgCpoGrd
        EndIf

        //Percorre a estrutura, para montar o cabe�alho da grid
        aHeadResu := {}
        For nCampo := 1 To Len(aEstrut)
            cCampo := aEstrut[nCampo][1]

            //Se o campo existir no dicion�rio, busca o t�tulo e a m�scara dele
            If GetSX3Cache(cCampo, "X3_TITULO") != ""
                cTitulo  := Alltrim(GetSX3Cache(cCampo, "X3_TITULO")) + " (" + Alltrim(cCampo) + ")"
                cMascara := GetSX3Cache(cCampo, "X3_PICTURE")
            Else
                cTitulo  := cCampo
                cMascara := ""
            EndIf

            //Adiciona no cabe�alho que ser� usado na grid
            aAdd(aHeadResu, {cCampo, , cTitulo, cMascara})
        Next

        //Cria a tempor�ria que vai ser usada na grid
        oTempTable := FWTemporaryTable():New(cAliasGrid)
        oTempTable:SetFields(aEstrut)
		oTempTable:Create()

        //Agora copia os dados da query para a tempor�ria
        DbSelectArea(cAliasGrid)
        Append From TMP_SQL
        TMP_SQL->(DbCloseArea())
        (cAliasGrid)->(DbGoTop())

        //Cria a grid
        oMResult := MsSelect():New(cAliasGrid, /*cCampo*/, /*cCpo*/, aHeadResu, /*lInv*/, /*cMar*/, {0, 0, oPanResult:nHeight / 2, oPanResult:nWidth / 2}, /*cTopFun*/, /*cBotFun*/, oPanResult)
        oMResult:oBrowse:SetCSS(u_zCSSGrid())
        oMResult:oBrowse:Refresh()
    EndIf

    //Atualiza o log com o tempo total
    fAtuLog(cInicio, cTermino, nQtdLinhas)
Return

/*/{Protheus.doc} fExportar
Fun��o para exportar o resultado da query para arquivo
@type  Function
@author Daniel Atilio
@since 19/12/2020
@version version
@see https://terminaldeinformacao.com
/*/

Static Function fExportar()
    Local aArea     := GetArea()
    Local cDirIni   := cUltPasta
    Local cTipArq   := "Planilha do Excel - requer PRINTER mais novo (*.xlsx) | Planilha do Excel em XML (*.xml) | Arquivo texto (*.txt)"
    Local cTitulo   := "Selecione um local para gerar"
    Local lSalvar   := .T.
    Local cArqSel   := ""
    Local cExtensao := ""
    Local cPasta    := ""
    Local cArquivo  := ""
    Private cDelim  := ""
 
    //Se tiver grid
    If Type("oMResult") != "U"
        //Chama a fun��o para buscar arquivos
        cArqSel := tFileDialog(;
            cTipArq,;  // Filtragem de tipos de arquivos que ser�o selecionados
            cTitulo,;  // T�tulo da Janela para sele��o dos arquivos
            ,;         // Compatibilidade
            cDirIni,;  // Diret�rio inicial da busca de arquivos
            lSalvar,;  // Se for .T., ser� uma Save Dialog, sen�o ser� Open Dialog
            ;          // Se n�o passar par�metro, ir� pegar apenas 1 arquivo; Se for informado GETF_MULTISELECT ser� poss�vel pegar mais de 1 arquivo; Se for informado GETF_RETDIRECTORY ser� poss�vel selecionar o diret�rio
        )

        //Se o arquivo existir
        If ! Empty(cArqSel)
            //Pega a extens�o do arquivo
            cExtensao := Alltrim(Upper(cArqSel))
            cExtensao := SubStr(cExtensao, RAt(".", cExtensao) + 1)

            //Separa a pasta do arquivo
            cPasta   := SubStr(cArqSel, 1, RAt('\', cArqSel))
            cArquivo := StrTran(cArqSel, cPasta, '')

            //Se for texto
            If cExtensao == "TXT"
                DbSelectArea(cAliasResu)
                (cAliasResu)->(DbGoTop())

                //Realiza a exporta��o
                Copy To (cPasta + cArquivo) DELIMITED WITH (cDelim)

                //Abre o arquivo
                ShellExecute("OPEN", cArquivo, "", cPasta, 1)
            
            //Sen�o, se for planilha do Excel antiga
            ElseIf cExtensao == "XML"
                RptStatus({|| fExcel(cArqSel, 1)}, "Exportando", "Gerando Excel...")

            //Sen�o, se for planilha do Excel
            ElseIf cExtensao == "XLSX"
                RptStatus({|| fExcel(cArqSel, 2)}, "Exportando", "Gerando Excel...")

                //Abre o arquivo
                ShellExecute("OPEN", cArquivo, "", cPasta, 1)
            EndIf

            cUltPasta := SubStr(cArqSel, 1, RAt("\", cArqSel))
        EndIf

    Else
        cSayLog := "Para acionar a exporta��o, execute um SELECT"
        oSayLog:Refresh()
        MsgStop(cSayLog, "Aten��o")
    EndIf

    RestArea(aArea)
Return

/*/{Protheus.doc} fExcel
Fun��o para o Excel da tabela tempor�ria
@type  Function
@author Daniel Atilio
@since 19/12/2020
@version version
@see https://terminaldeinformacao.com
/*/

Static Function fExcel(cArquivo, nTipo)
	Local oFWMsExcel
	Local cWorkSheet := "zTiSQL"
	Local cTitulo    := "Exportacao de dados"
	Local nTotal := 0
    Local nCampo
    Local aLinha
	
    //Define o tamanho da r�gua
	DbSelectArea(cAliasResu)
    (cAliasResu)->(DbGoTop())
    Count To nTotal
    SetRegua(nTotal)
    (cAliasResu)->(DbGoTop())
	
	//Cria a planilha do excel
    If nTipo == 1
        oFWMsExcel := FwMsExcel():New()
    ElseIf nTipo == 2
	    oFWMsExcel := FwMsExcelXlsx():New()
    EndIf
	
	//Criando a aba da planilha
	oFWMsExcel:AddworkSheet(cWorkSheet)
	
	//Criando a Tabela e as colunas
	oFWMsExcel:AddTable(cWorkSheet, cTitulo)
    For nCampo := 1 To Len(aHeadResu)
        //Pega o tipo do campo
        nTipo  := 1 //General
        nAlign := 1 //Left
        If GetSX3Cache(aHeadResu[nCampo][1], "X3_TIPO") == "N"
            nTipo  := 2 //Number
            nAlign := 3 //Right
        EndIf

        //Adiciona a coluna
        oFWMsExcel:AddColumn(cWorkSheet, cTitulo, aHeadResu[nCampo][3], nAlign, nTipo, .F.)
    Next
	
	//Percorrendo os dados da query
	While !((cAliasResu)->(EoF()))
		
		//Incrementando a regua
		IncRegua()

        //Cria uma nova linha
        aLinha := {}
        For nCampo := 1 To Len(aHeadResu)
            aAdd(aLinha, (cAliasResu)->(&(aHeadResu[nCampo][1])))
        Next
		
		//Adicionando uma nova linha
		oFWMsExcel:AddRow(cWorkSheet, cTitulo, aClone(aLinha))
		
		(cAliasResu)->(DbSkip())
	EndDo
	
	//Ativando o arquivo e gerando
	oFWMsExcel:Activate()
	oFWMsExcel:GetXMLFile(cArquivo)
    oFWMsExcel:DeActivate()

    //Se for em XML, for�a abrir pelo Excel
    If nTipo == 1
        //Abrindo o excel e abrindo o arquivo xml
        oExcel := MsExcel():New()
        oExcel:WorkBooks:Open(cArquivo)
        oExcel:SetVisible(.T.)
        oExcel:Destroy()
    EndIf
Return

/*/{Protheus.doc} fExcel
Fun��o para abrir uma URL com a query para indenta��o
@type  Function
@author Daniel Atilio
@since 19/12/2020
@version version
@see https://terminaldeinformacao.com
/*/

Static Function fIndentar()
    Local cTextoSel := oEditSQL:RetTextSel()
    Local cLink     := "https://www.freeformatter.com/sql-formatter.html?sqlString="

    //Se tiver vazio o texto selecionado, mostra a mensagem
    If Empty(cTextoSel)
        cSayLog := "Selecione o texto para que seja poss�vel indentar!"
        oSayLog:Refresh()
        MsgStop(cSayLog, "Aten��o")
    Else
        //Substitui o caractere interroga��o por espa�o vazio (-enter- e -tab-)
        cTextoSel := StrTran(cTextoSel, "?", '')

        //No link, ser� enviado a query
        cLink += cTextoSel
        ShellExecute("Open", cLink, "", "", 1)
    EndIf
Return

/*/{Protheus.doc} fAbreHist
Fun��o para abrir a pasta do hist�rico de queries executadas
@type  Function
@author Daniel Atilio
@since 09/07/2022
@version version
@see https://terminaldeinformacao.com
/*/

Static Function fAbreHist()	
    ShellExecute("open", "explorer.exe", cPastaHist, "C:\", 1)
Return

/*/{Protheus.doc} fTrataLG
Fun��o para tratar os logs de inclus�o e altera��o no Select
@type  Function
@author Daniel Atilio
@since 09/07/2022
@version version
@see https://terminaldeinformacao.com
/*/

Static Function fTrataLG(cQuery)
    Local nPosCorte  := RAt("FROM", Upper(cQuery))-1
    Local cApenasSel := Left(cQuery, nPosCorte)
    Local cRestante  := SubStr(cQuery, nPosCorte)
    Local cConvLGI   := "RTRIM( SUBSTRING(XXXXXXXXXX, 11, 1) + SUBSTRING(XXXXXXXXXX, 15, 1) + SUBSTRING(XXXXXXXXXX, 19, 1) + SUBSTRING(XXXXXXXXXX, 02, 1) + SUBSTRING(XXXXXXXXXX, 06, 1) + SUBSTRING(XXXXXXXXXX, 10, 1) + SUBSTRING(XXXXXXXXXX, 14, 1) + SUBSTRING(XXXXXXXXXX, 01, 1) + SUBSTRING(XXXXXXXXXX, 18, 1) + SUBSTRING(XXXXXXXXXX, 05, 1) + SUBSTRING(XXXXXXXXXX, 09, 1) + SUBSTRING(XXXXXXXXXX, 13, 1) + SUBSTRING(XXXXXXXXXX, 17, 1) + SUBSTRING(XXXXXXXXXX, 04, 1) + SUBSTRING(XXXXXXXXXX, 08, 1) ) + ' no dia ' + CONVERT(VARCHAR(10),CAST(DATEADD(DAY,CONVERT(INT,CONCAT(ASCII(SUBSTRING(XXXXXXXXXX,12,1)) - 50, ASCII(SUBSTRING(XXXXXXXXXX,16,1)) - 50)),'1996-01-01') AS DATETIME),103) AS XXXXXXXXXX"
    Local cConvLGA   := "RTRIM( SUBSTRING(XXXXXXXXXX, 11, 1) + SUBSTRING(XXXXXXXXXX, 15, 1) + SUBSTRING(XXXXXXXXXX, 19, 1) + SUBSTRING(XXXXXXXXXX, 02, 1) + SUBSTRING(XXXXXXXXXX, 06, 1) + SUBSTRING(XXXXXXXXXX, 10, 1) + SUBSTRING(XXXXXXXXXX, 14, 1) + SUBSTRING(XXXXXXXXXX, 01, 1) + SUBSTRING(XXXXXXXXXX, 18, 1) + SUBSTRING(XXXXXXXXXX, 05, 1) + SUBSTRING(XXXXXXXXXX, 09, 1) + SUBSTRING(XXXXXXXXXX, 13, 1) + SUBSTRING(XXXXXXXXXX, 17, 1) + SUBSTRING(XXXXXXXXXX, 04, 1) + SUBSTRING(XXXXXXXXXX, 08, 1) ) + CASE WHEN SUBSTRING(XXXXXXXXXX, 03, 1) != ' ' THEN + ' no dia ' + CONVERT(VARCHAR,DATEADD(DAY,((ASCII(SUBSTRING(XXXXXXXXXX,12,1)) - 50) * 100 + (ASCII(SUBSTRING(XXXXXXXXXX,16,1)) - 50)),'19960101'),112) ELSE '' END AS XXXXXXXXXX"
    Local nPosicao   := 1
    Local cCampo     := ""
    Local cExpressao := ""

    //Percorre todo o texto, e onde tiver o campo, ser� realizado a tratativa
    While nPosicao < Len(cApenasSel)
        //Encontra o nome do campo
        cCampo := ""
        If SubStr(cApenasSel, nPosicao, 7) == "_USERGI" .Or.  SubStr(cApenasSel, nPosicao, 7) == "_USERGA"
            cCampo := SubStr(cApenasSel, nPosicao - 3, 10)

        ElseIf SubStr(cApenasSel, nPosicao, 8) == "_USERLGI" .Or. SubStr(cApenasSel, nPosicao, 8) == "_USERLGA"
            cCampo := SubStr(cApenasSel, nPosicao - 2, 10)
        EndIf

        //Se houver o campo, faz a convers�o
        If ! Empty(cCampo)
            If Right(cCampo, 2) == "GI"
                cExpressao := StrTran(cConvLGI, "XXXXXXXXXX", cCampo)
                cApenasSel := StrTran(cApenasSel, cCampo, cExpressao)
                nPosicao += Len(cConvLGI) - 3

            ElseIf Right(cCampo, 2) == "GA"
                cExpressao := StrTran(cConvLGA, "XXXXXXXXXX", cCampo)
                cApenasSel := StrTran(cApenasSel, cCampo, cExpressao)
                nPosicao += Len(cConvLGA) - 3
            EndIf
        EndIf

        nPosicao++
    EndDo

    cQuery := cApenasSel + cRestante
Return cQuery
