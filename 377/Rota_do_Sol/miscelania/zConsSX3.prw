//Bibliotecas
#Include "Protheus.ch"
 
/*/{Protheus.doc} zConsSX3
Função para consulta genérica do dicionário
@author Daniel Atilio
@since 30/09/2021
@version 1.0
    @return lRetorn, retorno se a consulta foi confirmada ou não
    @obs O retorno da consulta é pública (__cRetorn) para ser usada em consultas específicas
/*/
                                                                                                                                                           
 
User Function zConsSX3()
    Local aArea := GetArea()
    Local nTamBtn := 50
    Local cMarca := "OK"
    //Privates
    Private cAliasPvt     := "SX3"
    Private aCampos       := {"X3_ARQUIVO", "X3_CAMPO", "X3_TITULO", "X3_DESCRIC"}
    Private nTamanRet     := 300
    Private cCampoRet     := "X3_CAMPO"
    //MsSelect
    Private oMAux
    Private aHeadRegs := {}
    Private cAliasTmp := cAliasPvt
    //Tamanho da janela
    Private nJanLarg := 0800
    Private nJanAltu := 0500
    //Gets e Dialog
    Private oDlgMark
    Private oGetPesq, cGetPesq := Space(100)
    Private oGetReto, cGetReto := Space(nTamanRet)
    //Retorno
    Private lRetorn := .F.
    Public  __cRetorn := Space(nTamanRet)
     
    //Criando a estrutura para a MsSelect
    fCriaMsSel()

    DbSelectArea("SX3")
    SX3->(DbGoTop())
     
    //Criando a janela
    DEFINE MSDIALOG oDlgMark TITLE "Consulta de Dados" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
        //Pesquisar
        @ 003, 003 GROUP oGrpPesqui TO 025, (nJanLarg/2)-3 PROMPT "Pesquisar: "    OF oDlgMark COLOR 0, 16777215 PIXEL
            @ 010, 006 MSGET oGetPesq VAR cGetPesq SIZE (nJanLarg/2)-12, 010 OF oDlgMark COLORS 0, 16777215  VALID (fVldPesq())      PIXEL
         
        //Dados
        @ 028, 003 GROUP oGrpDados TO (nJanAltu/2)-28, (nJanLarg/2)-3 PROMPT "Dados: "    OF oDlgMark COLOR 0, 16777215 PIXEL
            oMAux := MsSelect():New( cAliasTmp, "",, aHeadRegs,, cMarca, { 035, 006, (nJanAltu/2)-28-028, (nJanLarg/2)-6 } ,,, )
            oMAux:bAval := { || ( fGetMkA( cMarca ), oMAux:oBrowse:Refresh() ) }
            oMAux:oBrowse:lHasMark := .T.
            oMAux:oBrowse:lCanAllMark := .F.
            oMAux:oBrowse:SetCSS(u_zCSSGrid())
            @ (nJanAltu/2)-28-025, 006 SAY oSayReto PROMPT "Retorno:"     SIZE 040, 007 OF oDlgMark COLORS RGB(0,0,0) PIXEL
            @ (nJanAltu/2)-28-015, 006 MSGET oGetReto VAR cGetReto SIZE (nJanLarg/2)-12, 010 OF oDlgMark COLORS 0, 16777215      PIXEL
         
            //Populando os dados da MsSelect
            fPopula()
         
        //Ações
        @ (nJanAltu/2)-25, 003 GROUP oGrpAcoes TO (nJanAltu/2)-3, (nJanLarg/2)-3 PROMPT "Ações: "    OF oDlgMark COLOR 0, 16777215 PIXEL
            @ (nJanAltu/2)-19, (nJanLarg/2)-((nTamBtn*1)+06) BUTTON oBtnConf PROMPT "Confirmar" SIZE nTamBtn, 013 OF oDlgMark ACTION(fConfirm())     PIXEL
            @ (nJanAltu/2)-19, (nJanLarg/2)-((nTamBtn*2)+09) BUTTON oBtnLimp PROMPT "Limpar" SIZE nTamBtn, 013 OF oDlgMark ACTION(fLimpar())     PIXEL
            @ (nJanAltu/2)-19, (nJanLarg/2)-((nTamBtn*3)+12) BUTTON oBtnCanc PROMPT "Cancelar" SIZE nTamBtn, 013 OF oDlgMark ACTION(fCancela())     PIXEL
         
        oMAux:oBrowse:SetFocus()
    //Ativando a janela
    ACTIVATE MSDIALOG oDlgMark CENTERED
     
    RestArea(aArea)
Return lRetorn

Static Function fCriaMsSel()
    Local aAreaX3 := SX3->(GetArea())
 
    //Zerando o cabeçalho e a estrutura
    aHeadRegs := {}

    //                        Campo                Titulo            Mascara
    aAdd( aHeadRegs, {    "X3_ARQUIVO",     ,    "Tabela",        "@!" } )
    aAdd( aHeadRegs, {    "X3_CAMPO",     ,    "Campo",         "@!" } )
    aAdd( aHeadRegs, {    "X3_TITULO",     ,    "Titulo",        "@!" } )
    aAdd( aHeadRegs, {    "X3_DESCRIC",     ,    "Descricao",     "@!" } )
     
    RestArea(aAreaX3)
Return
 
Static Function fConfirm()
    //Setando o retorno conforme get e finalizando a tela
    lRetorn := .T.
    __cRetorn := cGetReto
     
    //Se o tamanho for menor, adiciona
    If Len(__cRetorn) < nTamanRet
        __cRetorn += Space(nTamanRet - Len(__cRetorn))
     
    //Senão se for maior, diminui
    ElseIf Len(__cRetorn) > nTamanRet
        __cRetorn := SubStr(__cRetorn, 1, nTamanRet)
    EndIf
     
    oDlgMark:End()
Return
 
Static Function fLimpar()
    //Zerando gets
    cGetPesq := Space(100)
    cGetReto := Space(nTamanRet)
    oGetPesq:Refresh()
    oGetReto:Refresh()
 
    //Atualiza grid
    fPopula()
     
    //Setando o foco na pesquisa
    oGetPesq:SetFocus()
Return
 
Static Function fCancela()
    //Setando o retorno em branco e finalizando a tela
    lRetorn := .F.
    __cRetorn := Space(nTamanRet)
    oDlgMark:End()
Return

Static Function fVldPesq()
    Local lRet := .T.
     
    //Se tiver apóstrofo ou porcentagem, a pesquisa não pode prosseguir
    If "'" $ cGetPesq .Or. "%" $ cGetPesq
        lRet := .F.
        MsgAlert("<b>Pesquisa inválida!</b><br>A pesquisa não pode ter <b>'</b> ou <b>%</b>.", "Atenção")
    EndIf
     
    //Se houver retorno, atualiza grid
    If lRet
        fPopula()
    EndIf
Return lRet
 
Static Function fPopula()
    Local cFiltro   := ""
    Local cPesquisa := ""

    //Se tiver vazio, limpa o filtro
    If Empty(cGetPesq)
        SX3->(DbClearFilter())
        SX3->(DbGoTop())

    //Senão, será filtrado os campos
    Else
        cPesquisa := Alltrim(Upper(cGetPesq))
        
        //Se for 3, filtra só a tabela
        If Len(cPesquisa) == 3
            cFiltro += "Upper(X3_ARQUIVO) == '" + cPesquisa + "' "
        Else
            cFiltro += "'" + cPesquisa + "' $ Upper(X3_ARQUIVO) .Or. "
            cFiltro += "'" + cPesquisa + "' $ Upper(X3_CAMPO)   .Or. "
            cFiltro += "'" + cPesquisa + "' $ Upper(X3_TITULO)  .Or. "
            cFiltro += "'" + cPesquisa + "' $ Upper(X3_DESCRIC) "
        EndIf
        SX3->(DbSetFilter({|| &(cFiltro)}, cFiltro))
    EndIf
    SX3->(DbGoTop())
    oMAux:oBrowse:Refresh()

Return

Static Function fGetMkA(cMarca)
    Local cChave  := Alltrim(SX3->X3_CAMPO) + ", "
     
    //Se o tamanho do retorno +chave for maior que o retorno
    If Len(Alltrim(cGetReto) + cChave) > nTamanRet
        MsgAlert("Tamanho de Retorno Excedido!", "Atenção")
        
    //Atualiza chave
    Else
        cGetReto := Alltrim(cGetReto)+cChave
    EndIf
    cGetReto := cGetReto + Space(nTamanRet - Len(cGetReto))
     
    oGetReto:Refresh()
    oMAux:oBrowse:Refresh()
Return
