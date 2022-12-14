//Bibliotecas
#INCLUDE 'Protheus.ch'
#INCLUDE 'FWMVCDef.ch'
 
//Vari?veis Est?ticas
STATIC cTitulo    :=    "Inclusao/Retirada de Maquinas Connect"
 
USER FUNCTION Z15Tela()

    LOCAL aArea      :=    GetArea()
    LOCAL oBrowse
    LOCAL cFunBkp    :=    FunName()
     
    SetFunName("Z15Tela")
     
    //Inst?nciando FWMBrowse - Somente com dicion?rio de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a tabela de cadastro de Autor/Interprete
    oBrowse:SetAlias("Z15")
 
    //Setando a descri??o da rotina
    oBrowse:SetDescription(cTitulo)
     
    //Legendas
    oBrowse:AddLegend( "Z15->Z15_STATUS = 'A'", "GREEN", "Ativo" )
    oBrowse:AddLegend( "Z15->Z15_STATUS = 'B'", "RED",   "Encerrado" )
    oBrowse:AddLegend( "Z15->Z15_STATUS = 'B'", "YELLOW",   "Em Preparacao" )
     
    //Filtrando
    //oBrowse:SetFilterDefault("Z15->Z15_CODIGO >= '000000' .And. Z15->Z15_CODIGO <= 'ZZZZZZ'")
     
    //Ativa a Browse
    oBrowse:Activate()
     
    SetFunName(cFunBkp)
    RestArea(aArea)
RETURN Nil
 
STATIC FUNCTION MenuDef()

    LOCAL aRot    :=    {}
     
    //Adicionando op??es
    ADD OPTION aRot TITLE 'Visualizar'        ACTION 'VIEWDEF.Z15Tela' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Legenda'           ACTION 'U_Z15Leg'        OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Incluir'           ACTION 'VIEWDEF.Z15Tela' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'           ACTION 'VIEWDEF.Z15Tela' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'           ACTION 'VIEWDEF.Z15Tela' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
    ADD OPTION aRot TITLE 'Atribuir Ativo'    ACTION 'U_Z15Chama(1)'   OPERATION 7                      ACCESS 0 //OPERATION 7
    ADD OPTION aRot TITLE 'Retirar Ativo'     ACTION 'U_Z15Chama(2)'   OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 7
 
RETURN aRot
 
STATIC FUNCTION ModelDef()

    //Cria??o do objeto do modelo de dados
    LOCAL oModel    :=    Nil
     
    //Cria??o da estrutura de dados utilizada na interface
    LOCAL oStZ15    :=    FWFormStruct(1, "Z15")
     
    //Editando caracter?sticas do dicion?rio
    // oStZ15:SetProperty('Z15_CODIGO',  MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.'))                                 //Modo de Edi??o
    // oStZ15:SetProperty('Z15_CODIGO',  MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("Z15", "Z15_CODIGO")'))      //Ini Padr?o
    // oStZ15:SetProperty('Z15_DESCRI',  MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'Iif(Empty(M->Z15_DESCRI), .F., .T.)')) //Valida??o de Campo
    // oStZ15:SetProperty('Z15_DESCRI',  MODEL_FIELD_OBRIGAT, Iif(RetCodUsr()!='000000', .T., .F.) )                                         //Campo Obrigat?rio
     
    //Instanciando o modelo, n?o ? recomendado colocar nome da USER FUNCTION (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("Z15TelaM",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
     
    //Atribuindo formul?rios para o modelo
    oModel:AddFields("FORMZ15",/*cOwner*/,oStZ15)
     
    //Setando a chave prim?ria da rotina
    oModel:SetPrimaryKey({'Z15_FILIAL','Z15_CONTRA'})
     
    //Adicionando descri??o ao modelo
    oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)
     
    //Setando a descri??o do formul?rio
    oModel:GetModel("FORMZ15"):SetDescription("Formul?rio do Cadastro "+cTitulo)
RETURN oModel

 
STATIC FUNCTION ViewDef()
    // LOCAL aStruZ15    := Z15->(DbStruct())
     
    //Cria??o do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
    LOCAL oModel    :=    FWLoadModel("Z15Tela")
     
    //Cria??o da estrutura de dados utilizada na interface do cadastro de Autor
    LOCAL oStZ15    :=    FWFormStruct(2, "Z15")  //pode se usar um terceiro par?metro para filtrar os campos exibidos { |cCampo| cCampo $ 'SZ15_NOME|SZ15_DTAFAL|'}
     
    //Criando oView como nulo
    LOCAL oView     :=    Nil
 
    //Criando a view que ser? o retorno da fun??o e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Atribuindo formul?rios para interface
    oView:AddField("VIEW_Z15", oStZ15, "FORMZ15")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
     
    //Colocando t?tulo do formul?rio
    oView:EnableTitleView('VIEW_Z15', 'Dados - '+cTitulo )  
     
    //For?a o fechamento da janela na confirma??o
    oView:SetCloseOnOk({||.T.})
     
    //O formul?rio da interface ser? colocado dentro do container
    oView:SetOwnerView("VIEW_Z15","TELA")
     
    /*
    //Tratativa para remover campos da visualiza??o
    FOR nAtual := 1 TO Len(aStruZ15)
        cCampoAux := Alltrim(aStruZ15[nAtual][01])
         
        //Se o campo atual n?o estiver nos que forem considerados
        IF Alltrim(cCampoAux) $ "Z15_CODIGO;"
            oStZ15:RemoveField(cCampoAux)
        ENDIF
    NEXT
    */
RETURN oView
 
USER FUNCTION Z15Leg()

    LOCAL aLegenda    :=    {}
     
    //Monta as cores
    AADD(aLegenda,{"BR_VERDE",           "Ativo"     })
    AADD(aLegenda,{"BR_VERMELHO",        "Encerrado" })
    AADD(aLegenda,{"BR_AMARELO",        "Em Preparacao" })
     
    BrwLegenda(cTitulo, "Status", aLegenda)
RETURN

User Function Z15Chama(nOpc)

    if nOpc == 1
        U_CONFSC03(Z15->Z15_CONTRA)
    elseif nOpc == 2
        U_CONFSC04(Z15->Z15_CONTRA)
    endif

Return 
