#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Ven�ncio                                           |
 | Data:  06/09/2023                                                   |
 | Desc:  Cria��o do menu MVC                                          |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

User Function JCOMA002()

Local oBrowse := FwLoadBrw("JCOMA002")
    
oBrowse:AddLegend( "ZPM->ZPM_MSBLQL = '2'", "GREEN", "N�o bloqueado" )
oBrowse:AddLegend( "ZPM->ZPM_MSBLQL = '1'", "RED",   "Bloqueado" )

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

    oBrowse:SetAlias("ZPM")
    oBrowse:SetDescription("Cadastro de Marcas")

   // DEFINE DE ONDE SER� RETIRADO O MENUDEF
   oBrowse:SetMenuDef("JCOMA002")
   //oBrowse:SetFilterDefault( "ZPM->A3_XFUNCAO == '2'" )


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
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.JCOMA002' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_ZPMLEG'         OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.JCOMA002' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.JCOMA002' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.JCOMA002' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return (aRot)

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Ven�ncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Cria��o da regra de neg�cio                                  |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function ModelDef()

Local oModel   := MPFormModel():New("ZPMMRC")
Local oStruSC5 := FwFormStruct(1, "ZPM")

    
    // DEFINE SE OS SUBMODELOS SER�O FIELD OU GRID
    oModel:AddFields("ZPMMASTER", NIL, oStruSC5)
    //oModel:AddGrid("Z30DETAIL", "ZPMMASTER", oStruSC6)
    
    oModel:SetPrimaryKey( { "ZPM_FILIAL", "ZPM_COD" } )

    // DEFINE A RELA��O ENTRE OS SUBMODELOS
    //oModel:SetRelation("Z30DETAIL", {{"Z30_FILIAL", "FwXFilial('Z30')"}, {"Z30_CODGER", "A3_COD"}}, Z30->(IndexKey(1)))

    
    // DESCRI��O DO MODELO
    oModel:SetDescription("Cadastro de Marcas")

    // DESCRI��O DOS SUBMODELOS
    oModel:GetModel("ZPMMASTER"):SetDescription("Cabe�alho")
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
Local oStruSC5 := FwFormStruct(2, "ZPM")

Local oModel   := FwLoadModel("JCOMA002")

    // REMOVE CAMPOS DA EXIBI��O
    oStruSC5:RemoveField("ZPM_FILIAL")
        
    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    // CRIA ESTRUTURA VISUAL DE CAMPOS
    oView:AddField("VIEW_SC5", oStruSC5, "ZPMMASTER")

    // CRIA A ESTRUTURA VISUAL DAS GRIDS
    //oView:AddGrid("VIEW_SC6", oStruSC6, "Z30DETAIL")
    
    //oView:AddIncrementField( 'VIEW_SC6', 'ZY1_ITEM' )

    

    // CRIA BOXES HORIZONTAIS
    oView:CreateHorizontalBox("EMCIMA", 100)
    //oView:CreateHorizontalBox("MEIO", 60)
    
    // RELACIONA OS BOXES COM AS ESTRUTURAS VISUAIS
    oView:SetOwnerView("VIEW_SC5", "EMCIMA")
    //oView:SetOwnerView("VIEW_SC6", "MEIO")
    

    // DEFINE OS T�TULOS DAS SUBVIEWS
    oView:EnableTitleView("VIEW_SC5")
    //oView:EnableTitleView("VIEW_SC6", "REPRESENTANTES", RGB(224, 30, 43))
    
Return (oView)

USER FUNCTION ZPMLeg()

    LOCAL aLegenda    :=    {}
     
    //Monta as cores
    AADD(aLegenda,{"BR_VERDE"   ,    "N�o Bloqueado"    })
    AADD(aLegenda,{"BR_VERMELHO",    "Bloqueado"        })
     
    BrwLegenda(cTitulo, "Status", aLegenda)
RETURN
