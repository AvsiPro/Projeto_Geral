//Bibliotecas
#INCLUDE 'Protheus.ch'
#INCLUDE 'FWMVCDef.ch'
 
//Vari�veis Est�ticas
STATIC cTitulo    :=    "Cadastro de Embalagem Connect"
 
USER FUNCTION Z05Tela()
   
    LOCAL aArea      :=    GetArea()
    LOCAL oBrowse
    LOCAL cFunBkp    :=    FunName()
     
    SetFunName("Z05Tela")
     
    //Inst�nciando FWMBrowse - Somente com dicion�rio de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a tabela de cadastro de Autor/Interprete
    oBrowse:SetAlias("Z05")
 
    //Setando a descri��o da rotina
    oBrowse:SetDescription(cTitulo)
     
    //Legendas
    oBrowse:AddLegend( "Z05->Z05_MSBLQL = '2'", "GREEN",    "N�o bloqueado" )
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
     
    //Adicionando op��es
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.Z05Tela' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Legenda'    ACTION 'U_Z05Leg'      OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.Z05Tela' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.Z05Tela' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.Z05Tela' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
RETURN aRot

 
STATIC FUNCTION ModelDef()
    
    //Cria��o do objeto do modelo de dados
    LOCAL oModel    :=    Nil
     
    //Cria��o da estrutura de dados utilizada na interface
    LOCAL oStZ05    :=    FWFormStruct(1, "Z05")
     
    //Editando caracter�sticas do dicion�rio
    oStZ05:SetProperty('Z05_CODIGO',   MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.'))                                 //Modo de Edi��o
    oStZ05:SetProperty('Z05_CODIGO',   MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("Z05", "Z05_CODIGO")'))         //Ini Padr�o
    oStZ05:SetProperty('Z05_DESCRI',  MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'Iif(Empty(M->Z05_DESCRI), .F., .T.)'))   //Valida��o de Campo
    oStZ05:SetProperty('Z05_DESCRI',  MODEL_FIELD_OBRIGAT, Iif(RetCodUsr()!='000000', .T., .F.) )                                         //Campo Obrigat�rio
     
    //Instanciando o modelo, n�o � recomendado colocar nome da USER FUNCTION (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("Z05TelaM",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
     
    //Atribuindo formul�rios para o modelo
    oModel:AddFields("FORMZ05",/*cOwner*/,oStZ05)
     
    //Setando a chave prim�ria da rotina
    oModel:SetPrimaryKey({'Z05_FILIAL','Z05_CODIGO'})
     
    //Adicionando descri��o ao modelo
    oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)
     
    //Setando a descri��o do formul�rio
    oModel:GetModel("FORMZ05"):SetDescription("Formul�rio do Cadastro "+cTitulo)
RETURN oModel

 
STATIC FUNCTION ViewDef()
    // LOCAL aStruZ05    := Z05->(DbStruct())
     
    //Cria��o do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
    LOCAL oModel    :=    FWLoadModel("Z05Tela")
     
    //Cria��o da estrutura de dados utilizada na interface do cadastro de Autor
    LOCAL oStZ05    :=    FWFormStruct(2, "Z05")  //pode se usar um terceiro par�metro para filtrar os campos exibidos { |cCampo| cCampo $ 'SZ05_NOME|SZ05_DTAFAL|'}
     
    //Criando oView como nulo
    LOCAL oView     :=    Nil
 
    //Criando a view que ser� o retorno da fun��o e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Atribuindo formul�rios para interface
    oView:AddField("VIEW_Z05", oStZ05, "FORMZ05")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
     
    //Colocando t�tulo do formul�rio
    oView:EnableTitleView('VIEW_Z05', 'Dados - '+cTitulo )  
     
    //For�a o fechamento da janela na confirma��o
    oView:SetCloseOnOk({||.T.})
     
    //O formul�rio da interface ser� colocado dentro do container
    oView:SetOwnerView("VIEW_Z05","TELA")
     
    /*
    //Tratativa para remover campos da visualiza��o
    For nAtual := 1 To Len(aStruZ05)
        cCampoAux := Alltrim(aStruZ05[nAtual][01])
         
        //Se o campo atual n�o estiver nos que forem considerados
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
