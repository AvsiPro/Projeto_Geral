#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

// FUNÇÃO PRINCIPAL
User Function ROB05W11()
    Local oBrowse := FwLoadBrw("ROB05W11")

    oBrowse:Activate()
Return (NIL)

// BROWSEDEF() SERÁ ÚTIL PARA FUTURAS HERANÇAS: FWLOADBRW()
Static Function BrowseDef()
    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias("Z11")
    oBrowse:SetDescription("Cadastro de Cores Haste")

    oBrowse:AddLegend("Z11_MSBLQL=='1'", "RED", "Bloqueado")
    oBrowse:AddLegend("Z11_MSBLQL=='2'", "GREEN" , "Ativo")

   // DEFINE DE ONDE SERÁ RETIRADO O MENUDEF
   oBrowse:SetMenuDef("ROB05W11")
Return (oBrowse)

// OPERAÇÕES DA ROTINA
Static Function MenuDef()
    // FUNÇÃO PARA CRIAR MENUDEF
    Local aRotina := FWMVCMenu("ROB05W11")
Return (aRotina)

// REGRAS DE NEGÓCIO
Static Function ModelDef()
    // INSTANCIA O MODELO
    Local oModel := MPFormModel():New("COMP011M")

    // INSTANCIA O SUBMODELO
    Local oStruZ11 := FwFormStruct(1, "Z11")

    // DEFINE O SUBMODELO COMO FIELD
    oModel:AddFields("Z11MASTER", NIL, oStruZ11)
    
    oModel:SetPrimaryKey( { "Z11_FILIAL", "Z11_CODCOR" } )
    
    // DESCRIÇÃO DO MODELO
    oModel:SetDescription("Cadastro de Cores Haste")

    // DESCRIÇÃO DO SUBMODELO
    oModel:GetModel("Z11MASTER"):SetDescription("Cadastro de Cores Haste")
    
Return (oModel)

// INTERFACE GRÁFICA
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
