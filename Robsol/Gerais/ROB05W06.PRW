#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

// FUN��O PRINCIPAL
User Function ROB05W06()
    Local oBrowse := FwLoadBrw("ROB05W06")

    oBrowse:Activate()
Return (NIL)

// BROWSEDEF() SER� �TIL PARA FUTURAS HERAN�AS: FWLOADBRW()
Static Function BrowseDef()
    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias("Z06")
    oBrowse:SetDescription("Cadastro de Materiais")

    oBrowse:AddLegend("Z06_MSBLQL=='1'", "RED", "Bloqueado")
    oBrowse:AddLegend("Z06_MSBLQL=='2'", "GREEN" , "Ativo")

   // DEFINE DE ONDE SER� RETIRADO O MENUDEF
   oBrowse:SetMenuDef("ROB05W06")
Return (oBrowse)

// OPERA��ES DA ROTINA
Static Function MenuDef()
    // FUN��O PARA CRIAR MENUDEF
    Local aRotina := FWMVCMenu("ROB05W06")
Return (aRotina)

// REGRAS DE NEG�CIO
Static Function ModelDef()
    // INSTANCIA O MODELO
    Local oModel := MPFormModel():New("COMP011M")

    // INSTANCIA O SUBMODELO
    Local oStruZ06 := FwFormStruct(1, "Z06")

    // DEFINE O SUBMODELO COMO FIELD
    oModel:AddFields("Z06MASTER", NIL, oStruZ06)
    
    oModel:SetPrimaryKey( { "Z06_FILIAL", "Z06_CODMAT" } )
    
    // DESCRI��O DO MODELO
    oModel:SetDescription("Cadastro de Materiais")

    // DESCRI��O DO SUBMODELO
    oModel:GetModel("Z06MASTER"):SetDescription("Cadastro de Materiais")
    
Return (oModel)

// INTERFACE GR�FICA
Static Function ViewDef()
    // INSTANCIA A VIEW
    Local oView := FwFormView():New()

    // INSTANCIA AS SUBVIEWS
    Local oStruZ06 := FwFormStruct(2, "Z06")

    // RECEBE O MODELO DE DADOS
    Local oModel := FwLoadModel("ROB05W06")

    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    // CRIA ESTRUTURA VISUAL DE CAMPOS
    oView:AddField("VIEW_Z06", oStruZ06, "Z06MASTER")

    // CRIA BOX HORIZONTAL
    oView:CreateHorizontalBox("TELA" , 100)

    // RELACIONA OS BOX COM A ESTRUTURA VISUAL
    oView:SetOwnerView("VIEW_Z06", "TELA")
Return (oView)