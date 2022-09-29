#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

// FUNÇÃO PRINCIPAL
User Function ROB05W05()
    Local oBrowse := FwLoadBrw("ROB05W05")

    oBrowse:Activate()
Return (NIL)

// BROWSEDEF() SERÁ ÚTIL PARA FUTURAS HERANÇAS: FWLOADBRW()
Static Function BrowseDef()
    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias("Z05")
    oBrowse:SetDescription("Cadastro de Linha")

    oBrowse:AddLegend("Z05_MSBLQL=='1'", "RED", "Bloqueado")
    oBrowse:AddLegend("Z05_MSBLQL=='2'", "GREEN" , "Ativo")

   // DEFINE DE ONDE SERÁ RETIRADO O MENUDEF
   oBrowse:SetMenuDef("ROB05W05")
Return (oBrowse)

// OPERAÇÕES DA ROTINA
Static Function MenuDef()
    // FUNÇÃO PARA CRIAR MENUDEF
    Local aRotina := FWMVCMenu("ROB05W05")
Return (aRotina)

// REGRAS DE NEGÓCIO
Static Function ModelDef()
    // INSTANCIA O MODELO
    Local oModel := MPFormModel():New("COMP011M")

    // INSTANCIA O SUBMODELO
    Local oStruZ05 := FwFormStruct(1, "Z05")

    // DEFINE O SUBMODELO COMO FIELD
    oModel:AddFields("Z05MASTER", NIL, oStruZ05)
    
    oModel:SetPrimaryKey( { "Z05_FILIAL", "Z05_CODLIN" } )
    
    // DESCRIÇÃO DO MODELO
    oModel:SetDescription("Cadastro de Linha")

    // DESCRIÇÃO DO SUBMODELO
    oModel:GetModel("Z05MASTER"):SetDescription("Cadastro de Linha")
    
Return (oModel)

// INTERFACE GRÁFICA
Static Function ViewDef()
    // INSTANCIA A VIEW
    Local oView := FwFormView():New()

    // INSTANCIA AS SUBVIEWS
    Local oStruZ05 := FwFormStruct(2, "Z05")

    // RECEBE O MODELO DE DADOS
    Local oModel := FwLoadModel("ROB05W05")

    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    // CRIA ESTRUTURA VISUAL DE CAMPOS
    oView:AddField("VIEW_Z05", oStruZ05, "Z05MASTER")

    // CRIA BOX HORIZONTAL
    oView:CreateHorizontalBox("TELA" , 100)

    // RELACIONA OS BOX COM A ESTRUTURA VISUAL
    oView:SetOwnerView("VIEW_Z05", "TELA")
Return (oView)