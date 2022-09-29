#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

// FUNÇÃO PRINCIPAL
User Function ROB05W08()
    Local oBrowse := FwLoadBrw("ROB05W08")

    oBrowse:Activate()
Return (NIL)

// BROWSEDEF() SERÁ ÚTIL PARA FUTURAS HERANÇAS: FWLOADBRW()
Static Function BrowseDef()
    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias("Z08")
    oBrowse:SetDescription("Cadastro de Operação")

    oBrowse:AddLegend("Z08_MSBLQL=='1'", "RED", "Bloqueado")
    oBrowse:AddLegend("Z08_MSBLQL=='2'", "GREEN" , "Ativo")

   // DEFINE DE ONDE SERÁ RETIRADO O MENUDEF
   oBrowse:SetMenuDef("ROB05W08")
Return (oBrowse)

// OPERAÇÕES DA ROTINA
Static Function MenuDef()
    // FUNÇÃO PARA CRIAR MENUDEF
    Local aRotina := FWMVCMenu("ROB05W08")
Return (aRotina)

// REGRAS DE NEGÓCIO
Static Function ModelDef()
    // INSTANCIA O MODELO
    Local oModel := MPFormModel():New("COMP011M")

    // INSTANCIA O SUBMODELO
    Local oStruZ08 := FwFormStruct(1, "Z08")

    // DEFINE O SUBMODELO COMO FIELD
    oModel:AddFields("Z08MASTER", NIL, oStruZ08)
    
    oModel:SetPrimaryKey( { "Z08_FILIAL", "Z08_CODOPE" } )
    
    // DESCRIÇÃO DO MODELO
    oModel:SetDescription("Cadastro de Operação")

    // DESCRIÇÃO DO SUBMODELO
    oModel:GetModel("Z08MASTER"):SetDescription("Cadastro de Operação")
    
Return (oModel)

// INTERFACE GRÁFICA
Static Function ViewDef()
    // INSTANCIA A VIEW
    Local oView := FwFormView():New()

    // INSTANCIA AS SUBVIEWS
    Local oStruZ08 := FwFormStruct(2, "Z08")

    // RECEBE O MODELO DE DADOS
    Local oModel := FwLoadModel("ROB05W08")

    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    // CRIA ESTRUTURA VISUAL DE CAMPOS
    oView:AddField("VIEW_Z08", oStruZ08, "Z08MASTER")

    // CRIA BOX HORIZONTAL
    oView:CreateHorizontalBox("TELA" , 100)

    // RELACIONA OS BOX COM A ESTRUTURA VISUAL
    oView:SetOwnerView("VIEW_Z08", "TELA")
Return (oView)