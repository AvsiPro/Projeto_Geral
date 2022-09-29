#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

// FUNÇÃO PRINCIPAL
User Function ROB05W09()
    Local oBrowse := FwLoadBrw("ROB05W09")

    oBrowse:Activate()
Return (NIL)

// BROWSEDEF() SERÁ ÚTIL PARA FUTURAS HERANÇAS: FWLOADBRW()
Static Function BrowseDef()
    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias("Z09")
    oBrowse:SetDescription("Cadastro de Formato")

    oBrowse:AddLegend("Z09_MSBLQL=='1'", "RED", "Bloqueado")
    oBrowse:AddLegend("Z09_MSBLQL=='2'", "GREEN" , "Ativo")

   // DEFINE DE ONDE SERÁ RETIRADO O MENUDEF
   oBrowse:SetMenuDef("ROB05W09")
Return (oBrowse)

// OPERAÇÕES DA ROTINA
Static Function MenuDef()
    // FUNÇÃO PARA CRIAR MENUDEF
    Local aRotina := FWMVCMenu("ROB05W09")
Return (aRotina)

// REGRAS DE NEGÓCIO
Static Function ModelDef()
    // INSTANCIA O MODELO
    Local oModel := MPFormModel():New("COMP011M")

    // INSTANCIA O SUBMODELO
    Local oStruZ09 := FwFormStruct(1, "Z09")

    // DEFINE O SUBMODELO COMO FIELD
    oModel:AddFields("Z09MASTER", NIL, oStruZ09)
    
    oModel:SetPrimaryKey( { "Z09_FILIAL", "Z09_CODFOR" } )
    
    // DESCRIÇÃO DO MODELO
    oModel:SetDescription("Cadastro de Formatar")

    // DESCRIÇÃO DO SUBMODELO
    oModel:GetModel("Z09MASTER"):SetDescription("Cadastro de Formatar")
    
Return (oModel)

// INTERFACE GRÁFICA
Static Function ViewDef()
    // INSTANCIA A VIEW
    Local oView := FwFormView():New()

    // INSTANCIA AS SUBVIEWS
    Local oStruZ09 := FwFormStruct(2, "Z09")

    // RECEBE O MODELO DE DADOS
    Local oModel := FwLoadModel("ROB05W09")

    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    // CRIA ESTRUTURA VISUAL DE CAMPOS
    oView:AddField("VIEW_Z09", oStruZ09, "Z09MASTER")

    // CRIA BOX HORIZONTAL
    oView:CreateHorizontalBox("TELA" , 100)

    // RELACIONA OS BOX COM A ESTRUTURA VISUAL
    oView:SetOwnerView("VIEW_Z09", "TELA")
Return (oView)