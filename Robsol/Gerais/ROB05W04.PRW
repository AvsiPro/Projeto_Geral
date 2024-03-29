#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

// FUN��O PRINCIPAL
User Function ROB05W04()
    Local oBrowse := FwLoadBrw("ROB05W04")

    oBrowse:Activate()
Return (NIL)

// BROWSEDEF() SER� �TIL PARA FUTURAS HERAN�AS: FWLOADBRW()
Static Function BrowseDef()
    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias("Z04")
    oBrowse:SetDescription("Cadastro de Genero")

    oBrowse:AddLegend("Z04_MSBLQL=='1'", "RED", "Bloqueado")
    oBrowse:AddLegend("Z04_MSBLQL=='2'", "GREEN" , "Ativo")

   // DEFINE DE ONDE SER� RETIRADO O MENUDEF
   oBrowse:SetMenuDef("ROB05W04")
Return (oBrowse)

// OPERA��ES DA ROTINA
Static Function MenuDef()
    // FUN��O PARA CRIAR MENUDEF
    Local aRotina := FWMVCMenu("ROB05W04")
Return (aRotina)

// REGRAS DE NEG�CIO
Static Function ModelDef()
    // INSTANCIA O MODELO
    Local oModel := MPFormModel():New("COMP011M")

    // INSTANCIA O SUBMODELO
    Local oStruZ04 := FwFormStruct(1, "Z04")

    // DEFINE O SUBMODELO COMO FIELD
    oModel:AddFields("Z04MASTER", NIL, oStruZ04)
    
    oModel:SetPrimaryKey( { "Z04_FILIAL", "Z04_CODGEN" } )
    
    // DESCRI��O DO MODELO
    oModel:SetDescription("Cadastro de Genero")

    // DESCRI��O DO SUBMODELO
    oModel:GetModel("Z04MASTER"):SetDescription("Cadastro de Genero")
    
Return (oModel)

// INTERFACE GR�FICA
Static Function ViewDef()
    // INSTANCIA A VIEW
    Local oView := FwFormView():New()

    // INSTANCIA AS SUBVIEWS
    Local oStruZ04 := FwFormStruct(2, "Z04")

    // RECEBE O MODELO DE DADOS
    Local oModel := FwLoadModel("ROB05W04")

    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    // CRIA ESTRUTURA VISUAL DE CAMPOS
    oView:AddField("VIEW_Z04", oStruZ04, "Z04MASTER")

    // CRIA BOX HORIZONTAL
    oView:CreateHorizontalBox("TELA" , 100)

    // RELACIONA OS BOX COM A ESTRUTURA VISUAL
    oView:SetOwnerView("VIEW_Z04", "TELA")
Return (oView)