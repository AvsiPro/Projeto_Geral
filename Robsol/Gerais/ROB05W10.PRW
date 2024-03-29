#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

// FUN��O PRINCIPAL
User Function ROB05W10()
    Local oBrowse := FwLoadBrw("ROB05W10")

    oBrowse:Activate()
Return (NIL)

// BROWSEDEF() SER� �TIL PARA FUTURAS HERAN�AS: FWLOADBRW()
Static Function BrowseDef()
    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias("Z10")
    oBrowse:SetDescription("Cadastro de Materiais Haste")

    oBrowse:AddLegend("Z10_MSBLQL=='1'", "RED", "Bloqueado")
    oBrowse:AddLegend("Z10_MSBLQL=='2'", "GREEN" , "Ativo")

   // DEFINE DE ONDE SER� RETIRADO O MENUDEF
   oBrowse:SetMenuDef("ROB05W10")
Return (oBrowse)

// OPERA��ES DA ROTINA
Static Function MenuDef()
    // FUN��O PARA CRIAR MENUDEF
    Local aRotina := FWMVCMenu("ROB05W10")
Return (aRotina)

// REGRAS DE NEG�CIO
Static Function ModelDef()
    // INSTANCIA O MODELO
    Local oModel := MPFormModel():New("COMP011M")

    // INSTANCIA O SUBMODELO
    Local oStruZ10 := FwFormStruct(1, "Z10")

    // DEFINE O SUBMODELO COMO FIELD
    oModel:AddFields("Z10MASTER", NIL, oStruZ10)
    
    oModel:SetPrimaryKey( { "Z10_FILIAL", "Z10_CODMAT" } )
    
    // DESCRI��O DO MODELO
    oModel:SetDescription("Cadastro de Materiais Haste")

    // DESCRI��O DO SUBMODELO
    oModel:GetModel("Z10MASTER"):SetDescription("Cadastro de Materiais Haste")
    
Return (oModel)

// INTERFACE GR�FICA
Static Function ViewDef()
    // INSTANCIA A VIEW
    Local oView := FwFormView():New()

    // INSTANCIA AS SUBVIEWS
    Local oStruZ06 := FwFormStruct(2, "Z10")

    // RECEBE O MODELO DE DADOS
    Local oModel := FwLoadModel("ROB05W10")

    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    // CRIA ESTRUTURA VISUAL DE CAMPOS
    oView:AddField("VIEW_Z10", oStruZ06, "Z10MASTER")

    // CRIA BOX HORIZONTAL
    oView:CreateHorizontalBox("TELA" , 100)

    // RELACIONA OS BOX COM A ESTRUTURA VISUAL
    oView:SetOwnerView("VIEW_Z10", "TELA")
Return (oView)
