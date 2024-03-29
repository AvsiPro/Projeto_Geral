#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

// FUN��O PRINCIPAL
User Function ROB05W01()
    Local oBrowse := FwLoadBrw("ROB05W01")

    oBrowse:Activate()
Return (NIL)

// BROWSEDEF() SER� �TIL PARA FUTURAS HERAN�AS: FWLOADBRW()
Static Function BrowseDef()
    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias("Z01")
    oBrowse:SetDescription("Cadastro de Bandeiras de Clientes")

    oBrowse:AddLegend("Z01_MSBLQL=='1'", "RED", "Bloqueado")
    oBrowse:AddLegend("Z01_MSBLQL=='2'", "GREEN" , "Ativo")

   // DEFINE DE ONDE SER� RETIRADO O MENUDEF
   oBrowse:SetMenuDef("ROB05W01")
Return (oBrowse)

// OPERA��ES DA ROTINA
Static Function MenuDef()
    // FUN��O PARA CRIAR MENUDEF
    Local aRotina := FWMVCMenu("ROB05W01")
Return (aRotina)

// REGRAS DE NEG�CIO
Static Function ModelDef()
    // INSTANCIA O MODELO
    Local oModel := MPFormModel():New("COMP011M")

    // INSTANCIA O SUBMODELO
    Local oStruZ01 := FwFormStruct(1, "Z01")

    // DEFINE O SUBMODELO COMO FIELD
    oModel:AddFields("Z01MASTER", NIL, oStruZ01)
    
    oModel:SetPrimaryKey( { "Z01_FILIAL", "Z01_CODBAN" } )
    
    // DESCRI��O DO MODELO
    oModel:SetDescription("Cadastro de Bandeiras de Clientes")

    // DESCRI��O DO SUBMODELO
    oModel:GetModel("Z01MASTER"):SetDescription("Cadastro de Bandeiras de Clientes")
    
Return (oModel)

// INTERFACE GR�FICA
Static Function ViewDef()
    // INSTANCIA A VIEW
    Local oView := FwFormView():New()

    // INSTANCIA AS SUBVIEWS
    Local oStruZ01 := FwFormStruct(2, "Z01")

    // RECEBE O MODELO DE DADOS
    Local oModel := FwLoadModel("ROB05W01")

    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    // CRIA ESTRUTURA VISUAL DE CAMPOS
    oView:AddField("VIEW_Z01", oStruZ01, "Z01MASTER")

    // CRIA BOX HORIZONTAL
    oView:CreateHorizontalBox("TELA" , 100)

    // RELACIONA OS BOX COM A ESTRUTURA VISUAL
    oView:SetOwnerView("VIEW_Z01", "TELA")
Return (oView)