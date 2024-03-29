#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

// FUN��O PRINCIPAL
User Function ROB05W03()
    Local oBrowse := FwLoadBrw("ROB05W03")

    oBrowse:Activate()
Return (NIL)

// BROWSEDEF() SER� �TIL PARA FUTURAS HERAN�AS: FWLOADBRW()
Static Function BrowseDef()
    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias("Z03")
    oBrowse:SetDescription("Cadastro de Griffe")

    oBrowse:AddLegend("Z03_MSBLQL=='1'", "RED", "Bloqueado")
    oBrowse:AddLegend("Z03_MSBLQL=='2'", "GREEN" , "Ativo")

   // DEFINE DE ONDE SER� RETIRADO O MENUDEF
   oBrowse:SetMenuDef("ROB05W03")
Return (oBrowse)

// OPERA��ES DA ROTINA
Static Function MenuDef()
    // FUN��O PARA CRIAR MENUDEF
    Local aRotina := FWMVCMenu("ROB05W03")
Return (aRotina)

// REGRAS DE NEG�CIO
Static Function ModelDef()
    // INSTANCIA O MODELO
    Local oModel := MPFormModel():New("COMP011M")

    // INSTANCIA O SUBMODELO
    Local oStruZ03 := FwFormStruct(1, "Z03")

    // DEFINE O SUBMODELO COMO FIELD
    oModel:AddFields("Z03MASTER", NIL, oStruZ03)
    
    oModel:SetPrimaryKey( { "Z03_FILIAL", "Z03_CODGRI" } )
    
    // DESCRI��O DO MODELO
    oModel:SetDescription("Cadastro de Griffe")

    // DESCRI��O DO SUBMODELO
    oModel:GetModel("Z03MASTER"):SetDescription("Cadastro de Griffe")
    
Return (oModel)

// INTERFACE GR�FICA
Static Function ViewDef()
    // INSTANCIA A VIEW
    Local oView := FwFormView():New()

    // INSTANCIA AS SUBVIEWS
    Local oStruZ03 := FwFormStruct(2, "Z03")

    // RECEBE O MODELO DE DADOS
    Local oModel := FwLoadModel("ROB05W03")

    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    // CRIA ESTRUTURA VISUAL DE CAMPOS
    oView:AddField("VIEW_Z03", oStruZ03, "Z03MASTER")

    // CRIA BOX HORIZONTAL
    oView:CreateHorizontalBox("TELA" , 100)

    // RELACIONA OS BOX COM A ESTRUTURA VISUAL
    oView:SetOwnerView("VIEW_Z03", "TELA")
Return (oView)