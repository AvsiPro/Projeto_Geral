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

User Function JCOMA003()

Local oBrowse := FwLoadBrw("JCOMA003")
    
//oBrowse:AddLegend( "ZPV->ZPV_MSBLQL = '2'", "GREEN", "Não bloqueado" )
//oBrowse:AddLegend( "ZPV->ZPV_MSBLQL = '1'", "RED",   "Bloqueado" )

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

    oBrowse:SetAlias("ZPV")
    oBrowse:SetDescription("Cadastro de Motivos Venda Perdida")

   // DEFINE DE ONDE SERÁ RETIRADO O MENUDEF
   oBrowse:SetMenuDef("JCOMA003")
   

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
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.JCOMA003' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_ZPVLEG'         OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.JCOMA003' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.JCOMA003' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.JCOMA003' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return (aRot)

/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Alexandre Venâncio                                           |
 | Data:  01/08/2021                                                   |
 | Desc:  Criação da regra de negócio                                  |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/

Static Function ModelDef()

Local oModel   := MPFormModel():New("ZPVBLQ")
Local oStruSC5 := FwFormStruct(1, "ZPV")
   
    // DEFINE SE OS SUBMODELOS SERÃO FIELD OU GRID
    oModel:AddFields("ZPVMASTER", NIL, oStruSC5)
    //oModel:AddGrid("Z30DETAIL", "ZPVMASTER", oStruSC6)
    
    oModel:SetPrimaryKey( { "ZPV_FILIAL", "ZPV_CODIGO" } )

    // DESCRIÇÃO DO MODELO
    oModel:SetDescription("Cadastro de Bloqueio de Marcas por filial")
    
    // DESCRIÇÃO DOS SUBMODELOS
    oModel:GetModel("ZPVMASTER"):SetDescription("Cabeçalho")

    
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
Local oStruSC5 := FwFormStruct(2, "ZPV")

Local oModel   := FwLoadModel("JCOMA003")

    // REMOVE CAMPOS DA EXIBIÇÃO
    //oStruSC5:RemoveField("ZPV_FILIAL")
        
    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    // CRIA ESTRUTURA VISUAL DE CAMPOS
    oView:AddField("VIEW_SC5", oStruSC5, "ZPVMASTER")

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

USER FUNCTION ZPVLeg()

    LOCAL aLegenda    :=    {}
     
    //Monta as cores
    AADD(aLegenda,{"BR_VERDE",        "Não Bloqueado"  })
    AADD(aLegenda,{"BR_VERMELHO",    "Bloqueado"})
     
    BrwLegenda(cTitulo, "Status", aLegenda)
RETURN

User function xJCOMA03

Local aArea := GetArea()
Local lRet  := .F.
Local nPosP := Ascan(aHeader,{|x| alltrim(x[2]) == "CP_PRODUTO"})
Local nPosQ := Ascan(aHeader,{|x| alltrim(x[2]) == "CP_QUANT"})
Local nPosL := Ascan(aHeader,{|x| alltrim(x[2]) == "CP_LOCAL"})
Local nSaldo:= 0

DbSelectArea("SB2")
DbSetOrder(1)
If Dbseek(xfilial("SB2")+aCols[n,nPosP]+aCols[n,nPosL])
    nSaldo := SaldoSB2()

    If aCols[n,nPosQ] > nSaldo
        lRet := .T.
    EndIf 
Else 
    If aCols[n,nPosQ] > 0
        lRet := .T.
    EndIf 
EndIf 

RestArea(aArea)

Return(lRet)
