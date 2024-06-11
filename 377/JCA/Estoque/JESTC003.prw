#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Venâncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Criação do menu MVC                                          |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

User Function JESTC003()

Local oBrowse := FwLoadBrw("JESTC003")
    
oBrowse:Activate()

Return (NIL)

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Venâncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Criação do Browse                                            |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function BrowseDef()

Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias("ZPJ")
    oBrowse:SetDescription("Cadastro de Caixa de Ferramentas")

   // DEFINE DE ONDE SER RETIRADO O MENUDEF
   oBrowse:SetMenuDef("JESTC003")
   oBrowse:SetFilterDefault( "ZPJ->ZPJ_ITEM == '0001'" )


Return (oBrowse)

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Venâncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Criação do menu DEF                                          |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function MenuDef()

Local aRot := {}
     
    //Adicionando opções
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.JESTC003' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    //ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_zMVC01Leg'     OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.JESTC003' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    //ADD OPTION aRot TITLE 'Regras'    ACTION 'VIEWDEF.JESTC003' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.JESTC003' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.JESTC003' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return (aRot)

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Venâncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Criação da regra de negócio                                  |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function ModelDef()

Local oModel   := MPFormModel():New("JESTC3")
Local oStruSC5 := FwFormStruct(1, "ZPJ")
Local oStruSC6 := FwFormStruct(1, "ZPJ")
    
    // DEFINE SE OS SUBMODELOS SERÃO FIELD OU GRID
    oModel:AddFields("ZPJMASTER", NIL, oStruSC5)
    oModel:AddGrid("ZPJDETAIL", "ZPJMASTER", oStruSC6)
    
    oModel:SetPrimaryKey( { "ZPJ_FILIAL", "ZPJ_CODBOX", "ZPJ_ITEM" } )

    // DEFINE A RELAÇÃO ENTRE OS SUBMODELOS
    oModel:SetRelation("ZPJDETAIL", {{"ZPJ_FILIAL", "FwXFilial('ZPJ')"}, {"ZPJ_CODBOX", "ZPJ_CODBOX"}}, ZPJ->(IndexKey(1)))

    //oStruSC6:AddTrigger("ZPJ_CODFER", "ZPJ_DESCRI",{|| .T.}, {|| Alltrim(POSICIONE("ZPI",1,XFILIAL("ZPI")+oModel:GetValue('ZPJDETAIL','ZPJ_CODFER'),"ZPI_DESCRI")) })
    
    // DESCRIÇÃO DO MODELO
    oModel:SetDescription("Cadastro de Caixa de Ferramentas")

    // DESCRIÇÃO DOS SUBMODELOS
    oModel:GetModel("ZPJMASTER"):SetDescription("Cabe�alho")
    oModel:GetModel("ZPJDETAIL"):SetDescription("Itens")
    
Return (oModel)


/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Venâncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Criação // INTERFACE GRÝFICA                                 |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
Static Function ViewDef()

Local oView    := FwFormView():New()
Local oStruSC5 := FwFormStruct(2, "ZPJ")
Local oStruSC6 := FwFormStruct(2, "ZPJ")
Local oModel   := FwLoadModel("JESTC003")

    // REMOVE CAMPOS DA EXIBIÇÃO
    oStruSC5:RemoveField("ZPJ_FILIAL")
    oStruSC5:RemoveField("ZPJ_ITEM")
    oStruSC5:RemoveField("ZPJ_CODFER")
    oStruSC5:RemoveField("ZPJ_DESCFE")
    
    
    oStruSC6:RemoveField("ZPJ_FILIAL")
    oStruSC6:RemoveField("ZPJ_CODBOX")
    oStruSC6:RemoveField("ZPJ_DESCRI")
    
    
    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    // CRIA ESTRUTURA VISUAL DE CAMPOS
    oView:AddField("VIEW_SC5", oStruSC5, "ZPJMASTER")

    // CRIA A ESTRUTURA VISUAL DAS GRIDS
    oView:AddGrid("VIEW_SC6", oStruSC6, "ZPJDETAIL")
    
    oView:AddIncrementField( 'VIEW_SC6', 'ZPJ_ITEM' )

    

    // CRIA BOXES HORIZONTAIS
    oView:CreateHorizontalBox("EMCIMA", 40)
    oView:CreateHorizontalBox("MEIO", 60)
    
    // RELACIONA OS BOXES COM AS ESTRUTURAS VISUAIS
    oView:SetOwnerView("VIEW_SC5", "EMCIMA")
    oView:SetOwnerView("VIEW_SC6", "MEIO")
    

    // DEFINE OS TÝTULOS DAS SUBVIEWS
    oView:EnableTitleView("VIEW_SC5")
    oView:EnableTitleView("VIEW_SC6", "REGRAS", RGB(224, 30, 43))
    
Return (oView)
