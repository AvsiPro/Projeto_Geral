//Bibliotecas
#INCLUDE 'Protheus.ch'
#INCLUDE 'FWMVCDef.ch'
 
//Variáveis Estáticas
STATIC cTitulo    :=    "Cadastro de Embalagem Connect"
 
USER FUNCTION Z05Tela()
   
    LOCAL aArea      :=    GetArea()
    LOCAL oBrowse
    LOCAL cFunBkp    :=    FunName()
     
    SetFunName("Z05Tela")
     
    //Instânciando FWMBrowse - Somente com dicionário de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a tabela de cadastro de Autor/Interprete
    oBrowse:SetAlias("Z05")
 
    //Setando a descrição da rotina
    oBrowse:SetDescription(cTitulo)
     
    //Legendas
    oBrowse:AddLegend( "Z05->Z05_MSBLQL = '2'", "GREEN",    "Não bloqueado" )
    oBrowse:AddLegend( "Z05->Z05_MSBLQL =  '1'", "RED",    "Bloqueado" )
     
    //Filtrando
    //oBrowse:SetFilterDefault("Z05->Z05_CODIGO >= '000000' .And. Z05->Z05_CODIGO <= 'ZZZZZZ'")
     
    //Ativa a Browse
    oBrowse:Activate()
     
    SetFunName(cFunBkp)
    RestArea(aArea)
RETURN Nil

 
STATIC FUNCTION MenuDef()
    LOCAL aRot    :=    {}
     
    //Adicionando opções
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.Z05Tela' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Legenda'    ACTION 'U_Z05Leg'      OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.Z05Tela' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.Z05Tela' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.Z05Tela' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
RETURN aRot

 
STATIC FUNCTION ModelDef()
    
    //Criação do objeto do modelo de dados
    LOCAL oModel    :=    Nil
     
    //Criação da estrutura de dados utilizada na interface
    LOCAL oStZ05    :=    FWFormStruct(1, "Z05")
     
    //Editando características do dicionário
    oStZ05:SetProperty('Z05_CODIGO',   MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.'))                                 //Modo de Edição
    oStZ05:SetProperty('Z05_CODIGO',   MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("Z05", "Z05_CODIGO")'))         //Ini Padrão
    oStZ05:SetProperty('Z05_DESCRI',  MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'Iif(Empty(M->Z05_DESCRI), .F., .T.)'))   //Validação de Campo
    oStZ05:SetProperty('Z05_DESCRI',  MODEL_FIELD_OBRIGAT, Iif(RetCodUsr()!='000000', .T., .F.) )                                         //Campo Obrigatório
     
    //Instanciando o modelo, não é recomendado colocar nome da USER FUNCTION (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("Z05TelaM",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
     
    //Atribuindo formulários para o modelo
    oModel:AddFields("FORMZ05",/*cOwner*/,oStZ05)
     
    //Setando a chave primária da rotina
    oModel:SetPrimaryKey({'Z05_FILIAL','Z05_CODIGO'})
     
    //Adicionando descrição ao modelo
    oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)
     
    //Setando a descrição do formulário
    oModel:GetModel("FORMZ05"):SetDescription("Formulário do Cadastro "+cTitulo)
RETURN oModel

 
STATIC FUNCTION ViewDef()
    // LOCAL aStruZ05    := Z05->(DbStruct())
     
    //Criação do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
    LOCAL oModel    :=    FWLoadModel("Z05Tela")
     
    //Criação da estrutura de dados utilizada na interface do cadastro de Autor
    LOCAL oStZ05    :=    FWFormStruct(2, "Z05")  //pode se usar um terceiro parâmetro para filtrar os campos exibidos { |cCampo| cCampo $ 'SZ05_NOME|SZ05_DTAFAL|'}
     
    //Criando oView como nulo
    LOCAL oView     :=    Nil
 
    //Criando a view que será o retorno da função e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Atribuindo formulários para interface
    oView:AddField("VIEW_Z05", oStZ05, "FORMZ05")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
     
    //Colocando título do formulário
    oView:EnableTitleView('VIEW_Z05', 'Dados - '+cTitulo )  
     
    //Força o fechamento da janela na confirmação
    oView:SetCloseOnOk({||.T.})
     
    //O formulário da interface será colocado dentro do container
    oView:SetOwnerView("VIEW_Z05","TELA")
     
    /*
    //Tratativa para remover campos da visualização
    For nAtual := 1 To Len(aStruZ05)
        cCampoAux := Alltrim(aStruZ05[nAtual][01])
         
        //Se o campo atual não estiver nos que forem considerados
        If Alltrim(cCampoAux) $ "Z05_CODIGO;"
            oStZ05:RemoveField(cCampoAux)
        EndIf
    Next
    */
RETURN oView

 
USER FUNCTION Z05Leg()
    // LOCAL aLegenda := {}
     
    // //Monta as cores
    // AADD(aLegenda,{"BR_VERDE",        "Menor ou igual a 5"  })
    // AADD(aLegenda,{"BR_VERMELHO",    "Maior que 5"})
     
    // BrwLegenda(cTitulo, "Status", aLegenda)
RETURN
