#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Ven�ncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Cria��o do menu MVC                                          |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

User Function JESTC002()

Local oBrowse := FwLoadBrw("JESTC002")
    
oBrowse:Activate()

Return (NIL)

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Ven�ncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Cria��o do Browse                                            |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function BrowseDef()

Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias("ZPI")
    oBrowse:SetDescription("Cadastro de Ferramentas JCA")

   // DEFINE DE ONDE SER� RETIRADO O MENUDEF
   oBrowse:SetMenuDef("JESTC002")
   //oBrowse:SetFilterDefault( "ZPI->A3_XFUNCAO == '2'" )


Return (oBrowse)

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Ven�ncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Cria��o do menu DEF                                          |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function MenuDef()

Local aRot := {}
     
    //Adicionando op��es
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.JESTC002' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    //ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_zMVC01Leg'     OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.JESTC002' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    //ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.zMVCMd1' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    //ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.zMVCMd1' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return (aRot)

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Ven�ncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Cria��o da regra de neg�cio                                  |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function ModelDef()

Local oModel   := MPFormModel():New("JESTC2")
Local oStruSC5 := FwFormStruct(1, "ZPI")
//Local oStruSC6 := FwFormStruct(1, "Z30")
    
    // DEFINE SE OS SUBMODELOS SER�O FIELD OU GRID
    oModel:AddFields("ZPIMASTER", NIL, oStruSC5)
    //oModel:AddGrid("Z30DETAIL", "ZPIMASTER", oStruSC6)
    
    oModel:SetPrimaryKey( { "ZPI_FILIAL", "ZPI_CODFER" } )

    // DEFINE A RELA��O ENTRE OS SUBMODELOS
    //oModel:SetRelation("Z30DETAIL", {{"Z30_FILIAL", "FwXFilial('Z30')"}, {"Z30_CODGER", "A3_COD"}}, Z30->(IndexKey(1)))

    //oStruSC6:AddTrigger("ZY1_VEND", "ZY1_NVEND",{|| .T.}, {|| POSICIONE("ZPI",1,XFILIAL("ZPI")+oModel:GetValue('ZY1DETAIL','ZY1_VEND'),"A3_NOME") })
    
    // DESCRI��O DO MODELO
    oModel:SetDescription("Cadastro de Equipes")

    // DESCRI��O DOS SUBMODELOS
    oModel:GetModel("ZPIMASTER"):SetDescription("Cabe�alho")
    //oModel:GetModel("Z30DETAIL"):SetDescription("Itens")
    
Return (oModel)


/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Ven�ncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Cria��o // INTERFACE GR�FICA                                 |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
Static Function ViewDef()

Local oView    := FwFormView():New()
Local oStruSC5 := FwFormStruct(2, "ZPI")
//Local oStruSC6 := FwFormStruct(2, "Z30")
Local oModel   := FwLoadModel("JESTC002")

    // REMOVE CAMPOS DA EXIBI��O
    oStruSC5:RemoveField("ZPI_FILIAL")
    //oStruSC6:RemoveField("Z30_FILIAL")
    //oStruSC6:RemoveField("ZY1_CODIGO")

    
    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    // CRIA ESTRUTURA VISUAL DE CAMPOS
    oView:AddField("VIEW_SC5", oStruSC5, "ZPIMASTER")

    // CRIA A ESTRUTURA VISUAL DAS GRIDS
    //oView:AddGrid("VIEW_SC6", oStruSC6, "Z30DETAIL")
    
    //oView:AddIncrementField( 'VIEW_SC6', 'ZY1_ITEM' )

    

    // CRIA BOXES HORIZONTAIS
    oView:CreateHorizontalBox("EMCIMA", 40)
    //oView:CreateHorizontalBox("MEIO", 60)
    
    // RELACIONA OS BOXES COM AS ESTRUTURAS VISUAIS
    oView:SetOwnerView("VIEW_SC5", "EMCIMA")
    //oView:SetOwnerView("VIEW_SC6", "MEIO")
    

    // DEFINE OS T�TULOS DAS SUBVIEWS
    oView:EnableTitleView("VIEW_SC5")
    //oView:EnableTitleView("VIEW_SC6", "REPRESENTANTES", RGB(224, 30, 43))
    
Return (oView)
