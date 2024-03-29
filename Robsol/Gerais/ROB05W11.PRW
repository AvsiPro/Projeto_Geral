#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

// FUN��O PRINCIPAL
User Function ROB05W11()
    Local oBrowse := FwLoadBrw("ROB05W11")

    oBrowse:Activate()
Return (NIL)

// BROWSEDEF() SER� �TIL PARA FUTURAS HERAN�AS: FWLOADBRW()
Static Function BrowseDef()
    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias("Z11")
    oBrowse:SetDescription("Cadastro de Cores Haste")

    oBrowse:AddLegend("Z11_MSBLQL=='1'", "RED", "Bloqueado")
    oBrowse:AddLegend("Z11_MSBLQL=='2'", "GREEN" , "Ativo")

   // DEFINE DE ONDE SER� RETIRADO O MENUDEF
   oBrowse:SetMenuDef("ROB05W11")
Return (oBrowse)

// OPERA��ES DA ROTINA
Static Function MenuDef()
    // FUN��O PARA CRIAR MENUDEF
    Local aRotina := FWMVCMenu("ROB05W11")
Return (aRotina)

// REGRAS DE NEG�CIO
Static Function ModelDef()
    // INSTANCIA O MODELO
    Local oModel := MPFormModel():New("COMP011M")

    // INSTANCIA O SUBMODELO
    Local oStruZ11 := FwFormStruct(1, "Z11")

    // DEFINE O SUBMODELO COMO FIELD
    oModel:AddFields("Z11MASTER", NIL, oStruZ11)
    
    oModel:SetPrimaryKey( { "Z11_FILIAL", "Z11_CODCOR" } )
    
    // DESCRI��O DO MODELO
    oModel:SetDescription("Cadastro de Cores Haste")

    // DESCRI��O DO SUBMODELO
    oModel:GetModel("Z11MASTER"):SetDescription("Cadastro de Cores Haste")
    
Return (oModel)

// INTERFACE GR�FICA
Static Function ViewDef()
    // INSTANCIA A VIEW
    Local oView := FwFormView():New()

    // INSTANCIA AS SUBVIEWS
    Local oStruZ11 := FwFormStruct(2, "Z11")

    // RECEBE O MODELO DE DADOS
    Local oModel := FwLoadModel("ROB05W11")

    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    // CRIA ESTRUTURA VISUAL DE CAMPOS
    oView:AddField("VIEW_Z11", oStruZ11, "Z11MASTER")

    // CRIA BOX HORIZONTAL
    oView:CreateHorizontalBox("TELA" , 100)

    // RELACIONA OS BOX COM A ESTRUTURA VISUAL
    oView:SetOwnerView("VIEW_Z11", "TELA")
Return (oView)
