#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Venâncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Criação do menu MVC                                          |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

User Function JESTC004()

Local oBrowse := FwLoadBrw("JESTC004")
    
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

    oBrowse:SetAlias("SX5")
    oBrowse:SetDescription("Cadastro de Ocorrencias JCA")

   // DEFINE DE ONDE SERÁ RETIRADO O MENUDEF
   oBrowse:SetMenuDef("JESTC004")
   oBrowse:SetFilterDefault( "SX5->X5_TABELA == '_J'" )


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
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.JESTC004' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    //ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_zMVC01Leg'     OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.JESTC004' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    //ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.zMVCMd1' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    //ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.zMVCMd1' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return (aRot)

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Venâncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Criação da regra de negócio                                  |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function ModelDef()

Local oModel   := MPFormModel():New("JESTC4")
Local oStruSC5 := FwFormStruct(1, "SX5")

//Local oStruSC6 := FwFormStruct(1, "Z30")
    
    // DEFINE SE OS SUBMODELOS SERÃO FIELD OU GRID
    oModel:AddFields("SX5MASTER", NIL, oStruSC5)
    //oModel:AddGrid("Z30DETAIL", "SX5MASTER", oStruSC6)
    
    oModel:SetPrimaryKey( { "X5_FILIAL", "X5_TABELA", "X5_CHAVE" } )

    // DEFINE A RELAÇÃO ENTRE OS SUBMODELOS
    //oModel:SetRelation("Z30DETAIL", {{"Z30_FILIAL", "FwXFilial('Z30')"}, {"Z30_CODGER", "A3_COD"}}, Z30->(IndexKey(1)))
    oStruSC5:SetProperty('X5_TABELA', MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, '"_J"'))
	oStruSC5:SetProperty('X5_CHAVE', MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, BuscaProx())) //'"_J"'
    
    oStruSC5:SetProperty("X5_CHAVE", MODEL_FIELD_WHEN, {|| .F.})
    
                                    //
    //oStruSC6:AddTrigger("ZY1_VEND", "ZY1_NVEND",{|| .T.}, {|| POSICIONE("SX5",1,XFILIAL("SX5")+oModel:GetValue('ZY1DETAIL','ZY1_VEND'),"A3_NOME") })
    //oStruSC5:AddTrigger("X5_CHAVE","X5_DESCRI",{|| .T.},{||"_J"})
    // DESCRIÇÃO DO MODELO
    oModel:SetDescription("Cadastro de Ocorrencias")

    // DESCRIÇÃO DOS SUBMODELOS
    oModel:GetModel("SX5MASTER"):SetDescription("Cabeçalho")
    //oModel:GetModel("Z30DETAIL"):SetDescription("Itens")
    
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
Local oStruSC5 := FwFormStruct(2, "SX5")
//Local oStruSC6 := FwFormStruct(2, "Z30")
Local oModel   := FwLoadModel("JESTC004")

    // REMOVE CAMPOS DA EXIBIÇÃO
    oStruSC5:RemoveField("X5_FILIAL")
    oStruSC5:RemoveField("X5_TABELA")
    oStruSC5:RemoveField("X5_DESCSPA")
    oStruSC5:RemoveField("X5_DESCENG")
    ///oStruSC5:RemoveField("X5_CHAVE")
    
    //oStruSC6:RemoveField("Z30_FILIAL")
    //oStruSC6:RemoveField("ZY1_CODIGO")

    
    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    // CRIA ESTRUTURA VISUAL DE CAMPOS
    oView:AddField("VIEW_SC5", oStruSC5, "SX5MASTER")

    // CRIA A ESTRUTURA VISUAL DAS GRIDS
    //oView:AddGrid("VIEW_SC6", oStruSC6, "Z30DETAIL")
    
    //oView:AddIncrementField( 'VIEW_SC6', 'ZY1_ITEM' )

    

    // CRIA BOXES HORIZONTAIS
    oView:CreateHorizontalBox("EMCIMA", 40)
    //oView:CreateHorizontalBox("MEIO", 60)
    
    // RELACIONA OS BOXES COM AS ESTRUTURAS VISUAIS
    oView:SetOwnerView("VIEW_SC5", "EMCIMA")
    //oView:SetOwnerView("VIEW_SC6", "MEIO")
    

    // DEFINE OS TÍTULOS DAS SUBVIEWS
    oView:EnableTitleView("VIEW_SC5")
    //oView:EnableTitleView("VIEW_SC6", "REPRESENTANTES", RGB(224, 30, 43))
    
Return (oView)


/*/{Protheus.doc} BuscaProx
    (long_description)
    @type  Static Function
    @author user
    @since 07/06/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function BuscaProx()

Local aArea := Getarea()
Local cQuery 
Local nRet  := '0'

cQuery := "SELECT COUNT(X5_CHAVE)+1 AS QTDX5 "
cQuery += " FROM " + RetSQLName("SX5")
cQuery += " WHERE X5_FILIAL='"+xFilial("SX5")+"' AND X5_TABELA='_J'"
cQuery += " AND D_E_L_E_T_=' ' "

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("JESTC004.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

nRet := STRZERO(TRB->QTDX5,6)

RestArea(aArea)

Return(nRet)
