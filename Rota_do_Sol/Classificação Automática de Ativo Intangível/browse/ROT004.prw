#include "protheus.ch"
#include 'parmtype.ch'
#include "topconn.ch"

/*/{Protheus.doc} ROT004
Rotina utilizada para abrir consulta específicas para as entidades
CT1 - Conta contábil
CTT - Centro de Custo
CTD - Item Contábil
CTH - Classe de Valor


@author Alisson Hausmann
@since 07/05/2020
@param cEntidade, caracter, tabela da entidade (CT1, CTT, CTD, CTH)
@param cCContabil, caracter, codigo conta contabil
@param cCCusto, caracter, codigo centro de custo
@param cItemCtb, caracter, codigo item contabil
@param cClasseVlr, caracter, codigo classe de valor
@return logico, verdadeiro ou falso
/*/
User Function ROT004(cEntidade,cCContabil,cCCusto,cItemCtb,cClasseVlr)

    Local oDlg
    Local oListBox
    Local cGet := Space(50)
    Local oGet  := nil
    Local aData := {}
    Local cResultado := ""
    Local cTitulo := "Consulta Padrão"
    Local cCombo := "Codigo"
    Local aCombo := {"Codigo","Descricao"}
    Local cAlias := ""
    Local lExibeTodos := .F.
    Local lRet := .F.

    If cEntidade == "CTT" .AND. !Empty(cCContabil)
        lExibeTodos := MsgYesNo("Deseja exibir todos os centros de custo?","Atenção")
    Endif

    cAlias := getData(cEntidade,cCContabil,cCCusto,cItemCtb,cClasseVlr,lExibeTodos)

    While (cAlias)->(!eof())
        aAdd(aData, {ALLTRIM((cAlias)->CODIGO), ALLTRIM((cAlias)->DESCRICAO)} )
        (cAlias)->(DbSkip())
    EndDo
    (cAlias)->(DbCloseArea())

    If Len(aData) == 0
        aData := {{"","",""}}
    EndIf

    Define MsDialog oDlg Title cTitulo From 250,250 To 620,865 Pixel
    @ 025,005 Listbox oListBox Fields HEADER "Codigo","Descricao" ColSizes 60, 500 Size 300,140 Of oDlg Pixel
    oListBox:SetArray(aData)
    oListBox:bLine := {|| {aData[oListBox:nAT][1], aData[oListBox:nAT][2]}}
    oListBox:bLDblClick := {||lRet := .T.,cResultado:= aData[oListBox:nAt,1],getReg(cEntidade,cResultado,oListBox,oDlg)}

    @ 005,005 ComboBox oCombo Var cCombo Items aCombo Size 100,050 Pixel Of oDlg On Change ordenaReg(aData, oListBox, oDlg, cCombo)
    @ 005,108 MsGet oGet Var cGet Size 150,010 Of oDlg Pixel Picture "@!"
    @ 005,260 Button "Pesquisar" Size 045,012 Pixel Of oDlg Action filtraReg(cGet, aData, oListBox, oDlg, cCombo)

    DEFINE SBUTTON FROM 170,005 TYPE 1 ACTION (lRet := .T., cResultado:=aData[oListBox:nAt,1],getReg(cEntidade,cResultado,oListBox,oDlg)) ENABLE OF oDlg

    DEFINE SBUTTON FROM 170,036 TYPE 2 ACTION ( lRet := .F., oDlg:End() ) ENABLE OF oDlg

    Activate MsDialog oDlg ON INIT posicReg(cEntidade,cCContabil,cCCusto,cItemCtb,cClasseVlr,aData,oListBox,oDlg,cCombo) Centered

Return (lRet)

//Função para retornar os dados a serem exibidos
Static Function getData(cEntidade,cCContabil,cCCusto,cItemCtb,cClasseVlr,lExibeTodos)
    Local cAlias := GetNextAlias()
    Local cQuery := ""
    Local lVisualiza := !(INCLUI .or. ALTERA)
    Local cJoinCTA := "INNER"

    Default cCContabil := ""
    Default cCCusto := ""
    Default cItemCtb := ""
    Default cClasseVlr := ""
    Default lExibeTodos := .F.

    If (Empty(cCContabil) .AND. Empty(cCCusto) .AND. Empty(cItemCtb) .AND. Empty(cClasseVlr)) .OR. lExibeTodos .OR. lVisualiza
        cJoinCTA := "LEFT"
    Endif

    

    If cEntidade == "CT1"
        cQuery += " SELECT DISTINCT "+CRLF
        cQuery += "     CT1_CONTA       CODIGO "+CRLF
        cQuery += "     ,CT1_DESC01     DESCRICAO "+CRLF
        cQuery += " FROM "+RETSQLTAB("CT1")+" "+CRLF
        cQuery += " "+cJoinCTA+" JOIN "+RETSQLTAB("CTA")+" ON "+CRLF
        cQuery += "                 CTA_FILIAL = CT1_FILIAL "+CRLF
        cQuery += "                 AND CTA_CONTA = CT1_CONTA "+CRLF
        cQuery += "                 AND CTA.D_E_L_E_T_ = '' "+CRLF
        cQuery += " WHERE "+CRLF
        cQuery += "     CT1_BLOQ <> '1' "+CRLF
        cQuery += "     AND CT1_CLASSE <> '1' "+CRLF
        cQuery += "     AND CT1.D_E_L_E_T_ = '' "+CRLF
    Elseif cEntidade == "CTT"
        cQuery += " SELECT DISTINCT "+CRLF
        cQuery += "     CTT_CUSTO       CODIGO "+CRLF
        cQuery += "     ,CTT_DESC01     DESCRICAO "+CRLF
        cQuery += " FROM "+RETSQLTAB("CTT")+" "+CRLF
        cQuery += " "+cJoinCTA+" JOIN "+RETSQLTAB("CTA")+" ON "+CRLF
        cQuery += "                 CTA_FILIAL = CTT_FILIAL "+CRLF
        cQuery += "                 AND CTA_CUSTO = CTT_CUSTO "+CRLF
        cQuery += "                 AND CTA.D_E_L_E_T_ = '' "+CRLF
        cQuery += " WHERE "+CRLF
        cQuery += "     CTT_BLOQ <> '1' "+CRLF
        cQuery += "     AND CTT_CLASSE <> '1' "+CRLF
        cQuery += "     AND CTT.D_E_L_E_T_ = '' "+CRLF
    Elseif cEntidade == "CTD"
        cQuery += " SELECT DISTINCT "+CRLF
        cQuery += "     CTD_ITEM        CODIGO "+CRLF
        cQuery += "     ,CTD_DESC01     DESCRICAO "+CRLF
        cQuery += " FROM "+RETSQLTAB("CTD")+" "+CRLF
        cQuery += " "+cJoinCTA+" JOIN "+RETSQLTAB("CTA")+" ON "+CRLF
        cQuery += "                 CTA_FILIAL = CTD_FILIAL "+CRLF
        cQuery += "                 AND CTA_ITEM = CTD_ITEM "+CRLF
        cQuery += "                 AND CTA.D_E_L_E_T_ = '' "+CRLF
        cQuery += " WHERE "+CRLF
        cQuery += "     CTD_BLOQ <> '1' "+CRLF
        cQuery += "     AND CTD_CLASSE <> '1' "+CRLF
        cQuery += "     AND CTD.D_E_L_E_T_ = '' "+CRLF
    Elseif cEntidade == "CTH"
        cQuery += " SELECT DISTINCT "+CRLF
        cQuery += "     CTH_CLVL        CODIGO "+CRLF
        cQuery += "     ,CTH_DESC01     DESCRICAO "+CRLF
        cQuery += " FROM "+RETSQLTAB("CTH")+" "+CRLF
        cQuery += " "+cJoinCTA+" JOIN "+RETSQLTAB("CTA")+" ON "+CRLF
        cQuery += "                 CTA_FILIAL = CTH_FILIAL "+CRLF
        cQuery += "                 AND CTA_CLVL = CTH_CLVL "+CRLF
        cQuery += "                 AND CTA.D_E_L_E_T_ = '' "+CRLF
        cQuery += " WHERE "+CRLF
        cQuery += "     CTH_BLOQ <> '1' "+CRLF
        cQuery += "     AND CTH_CLASSE <> '1' "+CRLF
        cQuery += "     AND CTH.D_E_L_E_T_ = '' "+CRLF
    Endif

    If !Empty(cCContabil) .AND. cEntidade <> 'CT1' .AND. !lExibeTodos .AND. !lVisualiza
        cQuery += " AND CTA_CONTA = '"+cCContabil+"' "+CRLF
    Endif
    If !Empty(cCCusto) .AND. cEntidade <> 'CTT' .AND. !lExibeTodos .AND. !lVisualiza
        cQuery += " AND CTA_CUSTO = '"+cCCusto+"' "+CRLF
    Endif
    If !Empty(cItemCtb) .AND. cEntidade <> 'CTD' .AND. !lExibeTodos .AND. !lVisualiza
        cQuery += " AND CTA_ITEM = '"+cItemCtb+"' "+CRLF
    Endif
    If !Empty(cClasseVlr) .AND. cEntidade <> 'CTH' .AND. !lExibeTodos .AND. !lVisualiza
        cQuery += " AND CTA_CLVL = '"+cClasseVlr+"' "+CRLF
    Endif

    TCQUERY cQuery NEW ALIAS &(cAlias)

Return cAlias

//Função para ordenar os registros
Static Function ordenaReg(aData, oListBox, oDlg, cCombo)

    If cCombo == "Codigo"
        aData := aSort(aData,,, {|x, y| x[1] < y[1]})
    Else
        aData := aSort(aData,,, {|x, y| x[2] < y[2]})
    Endif

    oListBox:Refresh()
    oDlg:Refresh()
return

//Função para filtrar o registro
Static Function filtraReg(cGet, aData, oListBox, oDlg, cCombo)
    Local nPos := 0
    Local cOpc := "Codigo"

    cOpc :=	IIf(!Empty(cCombo) , cCombo , cOpc)
    If !Empty(cGet)
        If cOpc == "Codigo"
            aData := aSort(aData,,, {|x, y| Substr(x[1],01,Len(Alltrim(cGet))) < Substr(y[1],01,Len(Alltrim(cGet)))})
            nPos :=	aScan( aData , { |x| Substr(x[1],01,Len(Alltrim(cGet))) == Alltrim(UPPER(cGet)) } )
        Else
            aData := aSort(aData,,, {|x, y| Substr(x[2],01,Len(Alltrim(cGet))) < Substr(y[2],01,Len(Alltrim(cGet)))})
            nPos :=	aScan( aData , { |x| Substr(x[2],01,Len(Alltrim(cGet))) == Alltrim(UPPER(cGet)) } )
        Endif

        If nPos > 0
            oListBox:nAt := nPos
            oListBox:Refresh()
            oDlg:Refresh()
        Endif
    Endif

Return

//Função para posicionar e obter o registro
Static Function getReg(cEntidade, cResultado, oListBox, oDlg)

    If Empty(cResultado)
        DbSelectArea(cEntidade)
        &(cEntidade + "->(DbGoTo(-1))")
    ElseIf cEntidade == "CT1"
        DbSelectArea("CT1")
        CT1->(DbSetOrder(1))
        CT1->(MsSeek(XFILIAL("CT1")+cResultado))
    Elseif cEntidade == "CTT"
        DbSelectArea("CTT")
        CTT->(DbSetOrder(1))
        CTT->(MsSeek(XFILIAL("CTT")+cResultado))
    Elseif cEntidade == "CTD"
        DbSelectArea("CTD")
        CTD->(DbSetOrder(1))
        CTD->(MsSeek(XFILIAL("CTD")+cResultado))
    Elseif cEntidade == "CTH"
        DbSelectArea("CTH")
        CTH->(DbSetOrder(1))
        CTH->(MsSeek(XFILIAL("CTH")+cResultado))
    Endif

    oListBox:Refresh()
    oDlg:End()
Return

//Função para posicionar registro no F3 se já tiver conteúdo no campo
Static Function posicReg(cEntidade,cCContabil,cCCusto,cItemCtb,cClasseVlr,aData,oListBox,oDlg,cCombo)
    Local cValor := ""

    If cEntidade == "CT1"
        cValor := cCContabil
    Elseif cEntidade == "CTT"
        cValor := cCCusto
    Elseif cEntidade == "CTD"
        cValor := cItemCtb
    Elseif cEntidade == "CTH"
        cValor := cClasseVlr
    Endif

    filtraReg(cValor, aData, oListBox, oDlg, cCombo)
Return
