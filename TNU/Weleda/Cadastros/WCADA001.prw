#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

/*---------------------------------------------------------------------*
 | Func:  Cadastro de API´s                                            |
 | Autor: Alexandre Venâncio                                           |
 | Data:  07/04/2025                                                   |
 | Desc:  Cadastro de API´s para integração                            |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

User Function WCADA001()

Local oBrowse := FwLoadBrw("WCADA001")
    
oBrowse:Activate()

Return (NIL)

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Venâncio                                           |
 | Data:  07/04/2025                                                   |
 | Desc:  Criação do Browse                                            |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function BrowseDef()

Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias("Z90")
    oBrowse:SetDescription("Cadastro de APIs")

   // DEFINE DE ONDE SERÁ RETIRADO O MENUDEF
   oBrowse:SetMenuDef("WCADA001")
   //oBrowse:SetFilterDefault( "SA3->A3_XFUNCAO == '2'" )


Return (oBrowse)

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Venâncio                                           |
 | Data:  07/04/2025                                                   |
 | Desc:  Criação do menu DEF                                          |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function MenuDef()

Local aRot := {}
     
    //Adicionando opções
    //ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_zMVC01Leg'           OPERATION 6                         ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Visualizar'          ACTION 'VIEWDEF.WCADA001'   OPERATION MODEL_OPERATION_VIEW      ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Incluir'             ACTION 'VIEWDEF.WCADA001'   OPERATION MODEL_OPERATION_INSERT    ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'             ACTION 'VIEWDEF.WCADA001'   OPERATION MODEL_OPERATION_UPDATE    ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'             ACTION 'VIEWDEF.WCADA001'   OPERATION MODEL_OPERATION_DELETE    ACCESS 0 //OPERATION 5
    ADD OPTION aRot TITLE 'Validar Modelo'      ACTION 'FWMsgRun(,{||U_WGENM001(Z90->Z90_COD,.T.)},"","Processando")' OPERATION MODEL_OPERATION_VIEW      ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Executar Integração' ACTION 'FWMsgRun(,{||U_WGENM002(Z90->Z90_COD)    },"","Processando")' OPERATION MODEL_OPERATION_VIEW      ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Importar Json'       ACTION 'FWMsgRun(,{||U_WGENM003()                },"","Processando")' OPERATION MODEL_OPERATION_VIEW      ACCESS 0 //OPERATION 3
    
Return (aRot)

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Venâncio                                           |
 | Data:  07/04/2025                                                   |
 | Desc:  Criação da regra de negócio                                  |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function ModelDef()

//Local bVldPos  := {|| U_Z91bPos()} // Validação do clicar em confirmar
Local oModel   := MPFormModel():New("JCASC4",,/*bVldPos*/)
Local oStruSC5 := FwFormStruct(1, "Z90")
Local oStruSC6 := FwFormStruct(1, "Z91")
    
    // DEFINE SE OS SUBMODELOS SERÃO FIELD OU GRID
    oModel:AddFields("Z90MASTER", NIL, oStruSC5)
    oModel:AddGrid("Z91DETAIL", "Z90MASTER", oStruSC6)
    
    oModel:SetPrimaryKey( { "Z90_FILIAL", "Z90_COD" } )

    // DEFINE A RELAÇÃO ENTRE OS SUBMODELOS
    oModel:SetRelation("Z91DETAIL", {{"Z91_FILIAL", "Z90_FILIAL"}, {"Z91_COD", "Z90_COD"}}, Z91->(IndexKey(1)))

    //oStruSC6:AddTrigger("Z91_COD", "Z91_DESC",{|| .T.}, {|| POSICIONE("SB1",1,XFILIAL("SB1")+oModel:GetValue('Z91DETAIL','Z91_PRODUT'),"B1_DESC") })
    
    // DESCRIÇÃO DO MODELO
    oModel:SetDescription("Cadastro de APIs")

    // DESCRIÇÃO DOS SUBMODELOS
    oModel:GetModel("Z90MASTER"):SetDescription("Cabeçalho")
    oModel:GetModel("Z91DETAIL"):SetDescription("Itens")
    
Return (oModel)


/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Venâncio                                           |
 | Data:  07/04/2025                                                   |
 | Desc:  Criação // INTERFACE GRÁFICA                                 |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
Static Function ViewDef()

Local oView    := FwFormView():New()
Local oStruSC5 := FwFormStruct(2, "Z90")
Local oStruSC6 := FwFormStruct(2, "Z91")
Local oModel   := FwLoadModel("WCADA001")

    // REMOVE CAMPOS DA EXIBIÇÃO
    oStruSC5:RemoveField("Z90_FILIAL")
    oStruSC6:RemoveField("Z91_FILIAL")
    oStruSC6:RemoveField("Z91_COD")

    
    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    // CRIA ESTRUTURA VISUAL DE CAMPOS
    oView:AddField("VIEW_SC5", oStruSC5, "Z90MASTER")

    // CRIA A ESTRUTURA VISUAL DAS GRIDS
    oView:AddGrid("VIEW_SC6", oStruSC6, "Z91DETAIL")
    
    oView:AddIncrementField( 'VIEW_SC6', 'Z91_ITEM' )

    

    // CRIA BOXES HORIZONTAIS
    oView:CreateHorizontalBox("EMCIMA", 40)
    oView:CreateHorizontalBox("MEIO", 60)
    
    // RELACIONA OS BOXES COM AS ESTRUTURAS VISUAIS
    oView:SetOwnerView("VIEW_SC5", "EMCIMA")
    oView:SetOwnerView("VIEW_SC6", "MEIO")
    

    // DEFINE OS TÍTULOS DAS SUBVIEWS
    oView:EnableTitleView("VIEW_SC5")
    oView:EnableTitleView("VIEW_SC6", "Itens API", RGB(224, 30, 43))

    oView:AddUserButton( 'Validar Query', 'CLIPS', {|oView| /*U_TINCMON(oView)*/} )
    oView:AddUserButton( 'Importar Json', 'CLIPS', {|oView| U_WGENM003(oView,oStruSC6)} )
    
Return (oView)

