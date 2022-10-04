//Bibliotecas
#INCLUDE 'Protheus.ch'
#INCLUDE 'FWMVCDef.ch'
 
//Variáveis Estáticas
STATIC cTitulo    :=    "Cadastro de Tipo"
 
USER FUNCTION Z03Tela()

    LOCAL aArea      :=    GetArea()
    LOCAL oBrowse
    LOCAL cFunBkp    :=    FunName()
     
    SetFunName("Z03Tela")
     
    //Instânciando FWMBrowse - Somente com dicionário de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a tabela de cadastro de Autor/Interprete
    oBrowse:SetAlias("Z03")
 
    //Setando a descrição da rotina
    oBrowse:SetDescription(cTitulo)
     
    //Legendas
    oBrowse:AddLegend( "Z03->Z03_MSBLQL = '2'", "GREEN",    "Não bloqueado" )
    oBrowse:AddLegend( "Z03->Z03_MSBLQL =  '1'", "RED",    "Bloqueado" )
     
    //Filtrando
    //oBrowse:SetFilterDefault("Z03->Z03_CODIGO >= '000000' .And. Z03->Z03_CODIGO <= 'ZZZZZZ'")
     
    //Ativa a Browse
    oBrowse:Activate()
     
    SetFunName(cFunBkp)
    RestArea(aArea)
RETURN Nil

 
STATIC FUNCTION MenuDef()
    
    LOCAL aRot    :=    {}
     
    //Adicionando opções
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.Z03Tela' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Legenda'    ACTION 'U_Z03Leg'      OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.Z03Tela' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.Z03Tela' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.Z03Tela' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
RETURN aRot

 
STATIC FUNCTION ModelDef()
   
    //Criação do objeto do modelo de dados
    LOCAL oModel    :=    Nil
     
    //Criação da estrutura de dados utilizada na interface
    LOCAL oStZ03    :=    FWFormStruct(1, "Z03")
     
    //Editando características do dicionário
    oStZ03:SetProperty('Z03_CODIGO',   MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.'))                                 //Modo de Edição
    oStZ03:SetProperty('Z03_CODIGO',   MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("Z03", "Z03_CODIGO")'))         //Ini Padrão
    oStZ03:SetProperty('Z03_DESCRI',  MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'Iif(Empty(M->Z03_DESCRI), .F., .T.)'))   //Validação de Campo
    oStZ03:SetProperty('Z03_DESCRI',  MODEL_FIELD_OBRIGAT, Iif(RetCodUsr()!='000000', .T., .F.) )                                         //Campo Obrigatório
     
    //Instanciando o modelo, não é recomendado colocar nome da USER FUNCTION (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("Z03TelaM",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
     
    //Atribuindo formulários para o modelo
    oModel:AddFields("FORMZ03",/*cOwner*/,oStZ03)
     
    //Setando a chave primária da rotina
    oModel:SetPrimaryKey({'Z03_FILIAL','Z03_CODIGO'})
     
    //Adicionando descrição ao modelo
    oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)
     
    //Setando a descrição do formulário
    oModel:GetModel("FORMZ03"):SetDescription("Formulário do Cadastro "+cTitulo)
RETURN oModel

 
STATIC FUNCTION ViewDef()
    // LOCAL aStruZ03    := Z03->(DbStruct())
     
    //Criação do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
    LOCAL oModel    :=    FWLoadModel("Z03Tela")
     
    //Criação da estrutura de dados utilizada na interface do cadastro de Autor
    LOCAL oStZ03    :=    FWFormStruct(2, "Z03")  //pode se usar um terceiro parâmetro para filtrar os campos exibidos { |cCampo| cCampo $ 'SZ03_NOME|SZ03_DTAFAL|'}
     
    //Criando oView como nulo
    LOCAL oView     :=    Nil
 
    //Criando a view que será o retorno da função e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Atribuindo formulários para interface
    oView:AddField("VIEW_Z03", oStZ03, "FORMZ03")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
     
    //Colocando título do formulário
    oView:EnableTitleView('VIEW_Z03', 'Dados - '+cTitulo )  
     
    //Força o fechamento da janela na confirmação
    oView:SetCloseOnOk({||.T.})
     
    //O formulário da interface será colocado dentro do container
    oView:SetOwnerView("VIEW_Z03","TELA")
     
    /*
    //Tratativa para remover campos da visualização
    For nAtual := 1 To Len(aStruZ03)
        cCampoAux := Alltrim(aStruZ03[nAtual][01])
         
        //Se o campo atual não estiver nos que forem considerados
        If Alltrim(cCampoAux) $ "Z03_CODIGO;"
            oStZ03:RemoveField(cCampoAux)
        EndIf
    Next
    */
RETURN oView

 
USER FUNCTION Z03Leg()
    // LOCAL aLegenda := {}
     
    // //Monta as cores
    // AADD(aLegenda,{"BR_VERDE",        "Menor ou igual a 5"  })
    // AADD(aLegenda,{"BR_VERMELHO",    "Maior que 5"})
     
    // BrwLegenda(cTitulo, "Status", aLegenda)
RETURN
