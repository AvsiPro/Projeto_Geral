#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

/*
    Rotina para Cadastro de produto x marcas por empresa
    MIT 44_ESTOQUE_EST021 - Cadastro de produto x marcas por empresa

    DOC MIT
    https://docs.google.com/document/d/118_XuS6Plsqk-B29zyMZ3jNdqYkyMp0D/edit
    DOC Entrega
    https://docs.google.com/document/d/1s6Z8YMCWilkdT6hk0uwbhuAPfE4FsWRO/edit
    
*/

User Function JCOMA001()

Local oBrowse := FwLoadBrw("JCOMA001")
    
//oBrowse:AddLegend( "ZPN->ZPN_MSBLQL = '2'", "GREEN", "N�o bloqueado" )
//oBrowse:AddLegend( "ZPN->ZPN_MSBLQL = '1'", "RED",   "Bloqueado" )

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

    oBrowse:SetAlias("ZPN")
    oBrowse:SetDescription("Cadastro de Produtos x Marcas")

   // DEFINE DE ONDE SER� RETIRADO O MENUDEF
   oBrowse:SetMenuDef("JCOMA001")
   

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
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.JCOMA001' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_ZPNLEG'         OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.JCOMA001' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.JCOMA001' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.JCOMA001' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return (aRot)

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Ven�ncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Cria��o da regra de neg�cio                                  |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function ModelDef()

Local oModel   := MPFormModel():New("ZPNBLQ")
Local oStruSC5 := FwFormStruct(1, "ZPN")

    
    // DEFINE SE OS SUBMODELOS SER�O FIELD OU GRID
    oModel:AddFields("ZPNMASTER", NIL, oStruSC5)
    //oModel:AddGrid("Z30DETAIL", "ZPNMASTER", oStruSC6)
    
    oModel:SetPrimaryKey( { "ZPN_FILIAL", "ZPN_COD" } )

    // DESCRI��O DO MODELO
    oModel:SetDescription("Cadastro de Bloqueio de Marcas por filial")

    // DESCRI��O DOS SUBMODELOS
    oModel:GetModel("ZPNMASTER"):SetDescription("Cabe�alho")
    
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
Local oStruSC5 := FwFormStruct(2, "ZPN")

Local oModel   := FwLoadModel("JCOMA001")

    // REMOVE CAMPOS DA EXIBI��O
    //oStruSC5:RemoveField("ZPN_FILIAL")
        
    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    // CRIA ESTRUTURA VISUAL DE CAMPOS
    oView:AddField("VIEW_SC5", oStruSC5, "ZPNMASTER")

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

USER FUNCTION ZPNLeg()

    LOCAL aLegenda    :=    {}
     
    //Monta as cores
    AADD(aLegenda,{"BR_VERDE",        "N�o Bloqueado"  })
    AADD(aLegenda,{"BR_VERMELHO",    "Bloqueado"})
     
    BrwLegenda(cTitulo, "Status", aLegenda)
RETURN
