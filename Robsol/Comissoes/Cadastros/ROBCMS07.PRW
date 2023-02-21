#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

// FUNÇÃO PRINCIPAL
User Function ROBCMS07()
    /*Local oBrowse := FwLoadBrw("ROBCMS07") // NAVEGADOR

    // ATIVAÇÃO DA TELA
    oBrowse:Activate()
*/
    Local oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("Z54")
    oBrowse:SetDescription('Cadastro de Metas')
                
    oBrowse:Activate()

Return (NIL)

// NAVEGADOR (BROWSER)
Static Function BrowseDef()
    
    Local oBrowse := FwMBrowse():New() // OBJETO DO NAVEGADOR

    // DEFINE A TABELA PRINCIPAL E A DESCRIÇÃO
    oBrowse:SetAlias("Z54")
    oBrowse:SetDescription("Cadastro de Campanhas")

    // DEFINE DE QUAL FONTE SERÁ UTILIZADO O MENUDEF
    oBrowse:SetMenuDef("ROBCMS07")

Return (oBrowse)

// OPERAÇÕES DA ROTINA (AROTINA)
Static Function MenuDef()

Local aRot := {}

    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.ROBCMS07' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.ROBCMS07' OPERATION MODEL_OPERATION_INSERT ACCESS 0
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.ROBCMS07' OPERATION MODEL_OPERATION_UPDATE ACCESS 0
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.ROBCMS07' OPERATION MODEL_OPERATION_DELETE ACCESS 0
    
Return(aRot)

// REGRA DE NEGÓCIOS (MODEL)
Static Function ModelDef()

    // INSTANCIA O MODELO
    Local oModel := MPFormModel():New("RCMS07")

    // INSTANCIA OS SUBMODELOS
    Local oStruSB1 := FwFormStruct(1, "Z54")
    Local oStruSB5 := FwFormStruct(1, "Z55")

    // DEFINE O CAMPO B5_COD COMO OBRIGATÓRIO
    oStruSB5:SetProperty("Z55_CODIGO", MODEL_FIELD_OBRIGAT, .F.)

    // DEFINE SE OS SUBMODELOS SERÃO FIELD OU GRID
    oModel:AddFields("MD_MASTERSB1", NIL, oStruSB1)
    oModel:AddGrid("MD_DETAILSB5", "MD_MASTERSB1", oStruSB5)

    // DEFINE A RELAÇÃO ENTRE OS SUBMODELOS (CSUBMODELO, {ARELATION1, ARELATION2}, CINDEX)
    oModel:SetRelation("MD_DETAILSB5", {{"Z55_FILIAL", "FwXFilial('Z55')"}, {"Z55_CODIGO" , "Z54_CODIGO"}}, Z55->(IndexKey(1)))
    oModel:SetPrimaryKey({})

    // DESCRIÇÃO DO MODELO
    oModel:SetDescription("Cadastro de Produtos Customizado")

    // DESCRIÇÃO DOS SUBMODELOS
    oModel:GetModel("MD_MASTERSB1"):SetDescription("Cabeçalho das Campanhas")
    oModel:GetModel("MD_DETAILSB5"):SetDescription("Itens das Campanhas")

Return (oModel)

// INTERFACE GRÁFICA (VIEW)
Static Function ViewDef()

    // INSTANCIA A VIEW
    Local oView := FwFormView():New()

    // RECEBE O MODELO DE DADOS
    Local oModel := FwLoadModel("ROBCMS07")

    // INSTANCIA AS SUBVIEWS
    Local oStruSB1 := FwFormStruct(2, "Z54")
    Local oStruSB5 := FwFormStruct(2, "Z55")

    // REMOVE O CAMPO DA VISÃO
    oStruSB5:RemoveField("Z55_CODIGO")

    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    // CRIA ESTRUTURA VISUAL DE CAMPOS
    oView:AddField("VW_MASTERSB1", oStruSB1, "MD_MASTERSB1")
    oView:AddGrid( 'MD_DETAILSB5', oStruSB5, 'MD_DETAILSB5' ) 

    // CRIA BOXES HORIZONTAIS
    oView:CreateHorizontalBox("BOX_SUPERIOR", 70)
    oView:CreateHorizontalBox("BOX_INFERIOR", 30)

    // RELACIONA OS BOXES COM AS ESTRUTURAS VISUAIS
    oView:SetOwnerView("VW_MASTERSB1", "BOX_SUPERIOR")
    oView:SetOwnerView("MD_DETAILSB5", "BOX_INFERIOR")

    oView:EnableTitleView("MD_MASTERSB1", "Dados Brutos do Produto")
    oView:EnableTitleView("MD_DETAILSB5", "Dados Científicos do Produto")

Return (oView)
