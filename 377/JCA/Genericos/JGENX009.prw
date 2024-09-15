#Include 'protheus.ch'
#Include 'fwmvcdef.ch'
 
#define cNomeArq "zProjetoMvc"
#define cTab    "SB1"
 
//-------------------------------------------------------------------
/*/{Protheus.doc} Eduardo Paro de Simoni
    Função principal da rotina MVC. 
-------------------------------------------------------------------*/
USER Function JGENX008()
    FWExecView( 'GRID Sem Cabeçalho', "VIEWDEF."+cNomeArq+"", MODEL_OPERATION_INSERT, , { || .T. }, , 30 )
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
//-------------------------------------------------------------------/*/
Static Function ModelDef()
    local oModel    as object
    local oStrCampo as object
    local oStrGrid  as object
 
    // Estrutura Fake de Field
    oStrCampo := FWFormModelStruct():New()

    //Adiciona uma estrutura que represente uma tabela, essa tabela
    oStrCampo:AddTable( 'ZPC' , { 'ZPC_FILIAL' } , "Grid_Eduardo" , {|| ''} ) 

    //Adiciona um campo a estrutura.
    oStrCampo:AddField( 'ZPC_FILIAL' , 'ZPC_REQUIS' , 'ZPC_ITEM' , 'C' , 15 ) 

    //Estrutura de Grid
    oStrGrid := FWFormStruct( 1, cTab )

    oModel   := MPFormModel():New( 'MIDMAIN' )

    //Atribuindo formulários para o modelo
    oModel:AddFields('CABEC', , oStrCampo )
    oModel:AddGrid( 'GRID', 'CABEC', oStrGrid )
    
    //Setando a chave primária da rotina
    oModel:SetRelation( 'GRID', { { 'ZPC_REQUIS', 'ZPC_REQUIS' } } )
    
    //Adicionando descrição ao modelo
    oModel:SetDescription( "Grid_Eduardo" )

    oModel:SetPrimaryKey( { 'ZPC_REQUIS' } )
    oStrGrid:AddField('SELECT', ' ', 'SELECT', 'L', 1, 0, , , {}, .F.,FWBuildFeature( STRUCT_FEATURE_INIPAD, ".F."))

    // Necessário que haja alguma alteração na estrutura 
    oModel:SetActivate( { | oModel | FwFldPut( "ZPC_REQUIS", "FAKE" ) } )

Return oModel

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Função estática do ViewDef
//-------------------------------------------------------------------/*/
Static Function ViewDef()
    local oView    as object
    local oModel   as object
    local oStrCabec  as object
    local oStrGrid as object
    
    // Instancia a Estrutura
    oStrCabec := FWFormViewStruct():New()
    oStrCabec:AddField( 'ZPC_FILIAL' , '01' , 'ZPC_REQUIS' , 'ZPC_ITEM',{},'@!'  )
    
    // Instancia a Estrutura
    oStrGrid := FWFormStruct( 2, cTab )
    oStrGrid:AddField( 'SELECT','01','SELECT','SELECT',, 'Check')
    
    // Carrega o Modelo
    oModel  := FWLoadModel( cNomeArq )

    // Instancia a VIEW
    oView   := FwFormView():New()

    // Seta o Modelo da View
    oView:SetModel( oModel )
    
    // Estrutura visual dos campos
    oView:AddField('CAB', oStrCabec, 'CABEC')
    
    // Estrutura visual das grids
    oView:AddGrid('GRID', oStrGrid, 'GRID')
    
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox( 'CABEC', 0 )
    oView:CreateHorizontalBox( 'GRID', 100 )
    
    oView:SetOwnerView('CAB' , 'CABEC' )
    oView:SetOwnerView('GRID', 'GRID')

    oView:SetDescription( "Grid_Eduardo" )
    
Return oView
