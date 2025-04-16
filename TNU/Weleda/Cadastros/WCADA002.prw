#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

/*---------------------------------------------------------------------*
 | Func:  Cadastro de API´s                                            |
 | Autor: Alexandre Venâncio                                           |
 | Data:  07/04/2025                                                   |
 | Desc:  Cadastro de API´s para integração                            |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

User Function WCADA002()

Local oBrowse := FwLoadBrw("WCADA002")
    
oBrowse:AddLegend( "Z92->Z92_STATUS", "GREEN", "Processado com sucesso" )
oBrowse:AddLegend( "!Z92->Z92_STATUS", "RED" , "Erro no processamento" )

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

    oBrowse:SetAlias("Z92")
    oBrowse:SetDescription("Dados de integração de APIs")

   // DEFINE DE ONDE SERÁ RETIRADO O MENUDEF
   oBrowse:SetMenuDef("WCADA002")
   

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
    ADD OPTION aRot TITLE 'Visualizar'              ACTION 'VIEWDEF.WCADA002' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Legenda'                 ACTION 'u_Z92LEG()'         OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Validar Json Envio'      ACTION 'FWMsgRun(,{||U_xWcada2(Z92->Z92_COD)},"","Processando")'          OPERATION MODEL_OPERATION_VIEW      ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Validar Json Retorno'    ACTION 'FWMsgRun(,{||U_xWcada3(Z92->Z92_COD)},"","Processando")'          OPERATION MODEL_OPERATION_VIEW      ACCESS 0 //OPERATION 3
    //ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.WCADA002' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    //ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.WCADA002' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    //ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.WCADA002' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return (aRot)

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Venâncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Criação da regra de negócio                                  |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function ModelDef()

Local oModel   := MPFormModel():New("Z92BLQ")
Local oStruSC5 := FwFormStruct(1, "Z92")

    
    // DEFINE SE OS SUBMODELOS SERÃO FIELD OU GRID
    oModel:AddFields("Z92MASTER", NIL, oStruSC5)
    //oModel:AddGrid("Z30DETAIL", "Z92MASTER", oStruSC6)
    
    oModel:SetPrimaryKey( { "Z92_FILIAL", "Z92_COD" } )

    // DESCRIÇÃO DO MODELO
    oModel:SetDescription("Dados de integrações de APIs")

    // DESCRIÇÃO DOS SUBMODELOS
    oModel:GetModel("Z92MASTER"):SetDescription("Cabeçalho")
    
Return (oModel)


/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Venâncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Criação // INTERFACE GRÁFICA                                 |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
Static Function ViewDef()

Local oView    := FwFormView():New()
Local oStruSC5 := FwFormStruct(2, "Z92")

Local oModel   := FwLoadModel("WCADA002")

    // REMOVE CAMPOS DA EXIBIÇÃO
    //oStruSC5:RemoveField("Z92_FILIAL")
        
    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    // CRIA ESTRUTURA VISUAL DE CAMPOS
    oView:AddField("VIEW_SC5", oStruSC5, "Z92MASTER")

    // CRIA A ESTRUTURA VISUAL DAS GRIDS
    //oView:AddGrid("VIEW_SC6", oStruSC6, "Z30DETAIL")
    
    //oView:AddIncrementField( 'VIEW_SC6', 'ZY1_ITEM' )

    

    // CRIA BOXES HORIZONTAIS
    oView:CreateHorizontalBox("EMCIMA", 100)
    //oView:CreateHorizontalBox("MEIO", 60)
    
    // RELACIONA OS BOXES COM AS ESTRUTURAS VISUAIS
    oView:SetOwnerView("VIEW_SC5", "EMCIMA")
    //oView:SetOwnerView("VIEW_SC6", "MEIO")
    

    // DEFINE OS TÍTULOS DAS SUBVIEWS
    oView:EnableTitleView("VIEW_SC5")
    //oView:EnableTitleView("VIEW_SC6", "REPRESENTANTES", RGB(224, 30, 43))
    
Return (oView)

USER FUNCTION Z92Leg()

    LOCAL aLegenda    :=    {}
     
    //Monta as cores
    AADD(aLegenda,{"BR_VERDE"   ,   "Processado com sucesso"  })
    AADD(aLegenda,{"BR_VERMELHO",   "Erro no processamento"})
     
    BrwLegenda("Legendas de integração", "Status", aLegenda)
RETURN

/*
    Validar json enviado na integração para o registro posicionado
*/
User Function xWcada2(cCodigo)

Local aArea := GetArea()
Local cJson := Z92->Z92_JSONEN

U__VerJson(cJson)

RestArea(aArea)

Return


/*
    Validar json enviado na integração para o registro posicionado
*/
User Function xWcada3(cCodigo)

Local aArea := GetArea()
Local cJson := Z92->Z92_JSONRE

U__VerJson(cJson)

RestArea(aArea)

Return
