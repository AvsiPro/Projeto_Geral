#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

// FUN��O PRINCIPAL
User Function ROB05W02()
    Local oBrowse := FwLoadBrw("ROB05W02")

    oBrowse:Activate()
Return (NIL)

// BROWSEDEF() SER� �TIL PARA FUTURAS HERAN�AS: FWLOADBRW()
Static Function BrowseDef()
    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias("Z02")
    oBrowse:SetDescription("Cadastro de Proprietarios")

    oBrowse:AddLegend("Z02_MSBLQL=='1'", "RED", "Bloqueado")
    oBrowse:AddLegend("Z02_MSBLQL=='2'", "GREEN" , "Ativo")

   // DEFINE DE ONDE SER� RETIRADO O MENUDEF
   oBrowse:SetMenuDef("ROB05W02")
Return (oBrowse)

// OPERA��ES DA ROTINA
Static Function MenuDef()
    // FUN��O PARA CRIAR MENUDEF
    Local aRotina := FWMVCMenu("ROB05W02")
Return (aRotina)

// REGRAS DE NEG�CIO
Static Function ModelDef()
    // INSTANCIA O MODELO
    Local oModel := MPFormModel():New("COMP011M")

    // INSTANCIA O SUBMODELO
    Local oStruZ02 := FwFormStruct(1, "Z02")

    // DEFINE O SUBMODELO COMO FIELD
    oModel:AddFields("Z02MASTER", NIL, oStruZ02)
    
    oModel:SetPrimaryKey( { "Z02_FILIAL", "Z02_IDPROP" } )
    
    // DESCRI��O DO MODELO
    oModel:SetDescription("Cadastro de Proprietarios")

    // DESCRI��O DO SUBMODELO
    oModel:GetModel("Z02MASTER"):SetDescription("Cadastro de Proprietarios")
    
Return (oModel)

// INTERFACE GR�FICA
Static Function ViewDef()
    // INSTANCIA A VIEW
    Local oView := FwFormView():New()

    // INSTANCIA AS SUBVIEWS
    Local oStruZ02 := FwFormStruct(2, "Z02")

    // RECEBE O MODELO DE DADOS
    Local oModel := FwLoadModel("ROB05W02")

    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    // CRIA ESTRUTURA VISUAL DE CAMPOS
    oView:AddField("VIEW_Z02", oStruZ02, "Z02MASTER")

    // CRIA BOX HORIZONTAL
    oView:CreateHorizontalBox("TELA" , 100)

    // RELACIONA OS BOX COM A ESTRUTURA VISUAL
    oView:SetOwnerView("VIEW_Z02", "TELA")
Return (oView)