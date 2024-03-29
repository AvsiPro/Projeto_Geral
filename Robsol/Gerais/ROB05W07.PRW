#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

// FUN��O PRINCIPAL
User Function ROB05W07()
    Local oBrowse := FwLoadBrw("ROB05W07")

    oBrowse:Activate()
Return (NIL)

// BROWSEDEF() SER� �TIL PARA FUTURAS HERAN�AS: FWLOADBRW()
Static Function BrowseDef()
    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias("Z07")
    oBrowse:SetDescription("Cadastro de Cores Arma��o")

    oBrowse:AddLegend("Z07_MSBLQL=='1'", "RED", "Bloqueado")
    oBrowse:AddLegend("Z07_MSBLQL=='2'", "GREEN" , "Ativo")

   // DEFINE DE ONDE SER� RETIRADO O MENUDEF
   oBrowse:SetMenuDef("ROB05W07")
Return (oBrowse)

// OPERA��ES DA ROTINA
Static Function MenuDef()
    // FUN��O PARA CRIAR MENUDEF
    Local aRotina := FWMVCMenu("ROB05W07")
Return (aRotina)

// REGRAS DE NEG�CIO
Static Function ModelDef()
    // INSTANCIA O MODELO
    Local oModel := MPFormModel():New("COMP011M")

    // INSTANCIA O SUBMODELO
    Local oStruZ07 := FwFormStruct(1, "Z07")

    // DEFINE O SUBMODELO COMO FIELD
    oModel:AddFields("Z07MASTER", NIL, oStruZ07)
    
    oModel:SetPrimaryKey( { "Z07_FILIAL", "Z07_CODCOR" } )
    
    // DESCRI��O DO MODELO
    oModel:SetDescription("Cadastro de Cores Arma��o")

    // DESCRI��O DO SUBMODELO
    oModel:GetModel("Z07MASTER"):SetDescription("Cadastro de Cores Arma��o")
    
Return (oModel)

// INTERFACE GR�FICA
Static Function ViewDef()
    // INSTANCIA A VIEW
    Local oView := FwFormView():New()

    // INSTANCIA AS SUBVIEWS
    Local oStruZ07 := FwFormStruct(2, "Z07")

    // RECEBE O MODELO DE DADOS
    Local oModel := FwLoadModel("ROB05W07")

    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    // CRIA ESTRUTURA VISUAL DE CAMPOS
    oView:AddField("VIEW_Z07", oStruZ07, "Z07MASTER")

    // CRIA BOX HORIZONTAL
    oView:CreateHorizontalBox("TELA" , 100)

    // RELACIONA OS BOX COM A ESTRUTURA VISUAL
    oView:SetOwnerView("VIEW_Z07", "TELA")
Return (oView)
