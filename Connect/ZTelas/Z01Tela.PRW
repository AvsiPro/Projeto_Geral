//Bibliotecas
#INCLUDE 'Protheus.ch'
#INCLUDE 'FWMVCDef.ch'
 
//Vari�veis Est�ticas
STATIC cTitulo    :=    "Cadastro de Tipo Connect"
 
USER FUNCTION Z01Tela()

    LOCAL aArea      :=    GetArea()
    LOCAL oBrowse
    LOCAL cFunBkp    :=    FunName()
     
    SetFunName("Z01Tela")
     
    //Inst�nciando FWMBrowse - Somente com dicion�rio de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a tabela de cadastro de Autor/Interprete
    oBrowse:SetAlias("Z01")
 
    //Setando a descri��o da rotina
    oBrowse:SetDescription(cTitulo)
     
    //Legendas
    oBrowse:AddLegend( "Z01->Z01_MSBLQL = '2'", "GREEN", "N�o bloqueado" )
    oBrowse:AddLegend( "Z01->Z01_MSBLQL = '1'", "RED",   "Bloqueado" )
     
    //Filtrando
    //oBrowse:SetFilterDefault("Z01->Z01_CODIGO >= '000000' .And. Z01->Z01_CODIGO <= 'ZZZZZZ'")
     
    //Ativa a Browse
    oBrowse:Activate()
     
    SetFunName(cFunBkp)
    RestArea(aArea)
RETURN Nil

 
STATIC FUNCTION MenuDef()

    LOCAL aRot    :=    {}
     
    //Adicionando op��es
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.Z01Tela' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Legenda'    ACTION 'U_Z01Leg'        OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.Z01Tela' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.Z01Tela' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.Z01Tela' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
RETURN aRot

 
STATIC FUNCTION ModelDef()

    //Cria��o do objeto do modelo de dados
    LOCAL oModel    :=    Nil
     
    //Cria��o da estrutura de dados utilizada na interface
    LOCAL oStZ01    :=    FWFormStruct(1, "Z01")
     
    //Editando caracter�sticas do dicion�rio
    oStZ01:SetProperty('Z01_CODIGO',  MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.'))                                 //Modo de Edi��o
    oStZ01:SetProperty('Z01_CODIGO',  MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("Z01", "Z01_CODIGO")'))      //Ini Padr�o
    oStZ01:SetProperty('Z01_DESCRI',  MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'Iif(Empty(M->Z01_DESCRI), .F., .T.)')) //Valida��o de Campo
    oStZ01:SetProperty('Z01_DESCRI',  MODEL_FIELD_OBRIGAT, Iif(RetCodUsr()!='000000', .T., .F.) )                                         //Campo Obrigat�rio
     
    //Instanciando o modelo, n�o � recomendado colocar nome da USER FUNCTION (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("Z01TelaM",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
     
    //Atribuindo formul�rios para o modelo
    oModel:AddFields("FORMZ01",/*cOwner*/,oStZ01)
     
    //Setando a chave prim�ria da rotina
    oModel:SetPrimaryKey({'Z01_FILIAL','Z01_CODIGO'})
     
    //Adicionando descri��o ao modelo
    oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)
     
    //Setando a descri��o do formul�rio
    oModel:GetModel("FORMZ01"):SetDescription("Formul�rio do Cadastro "+cTitulo)
RETURN oModel

 
STATIC FUNCTION ViewDef()
    // LOCAL aStruZ01    := Z01->(DbStruct())
     
    //Cria��o do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
    LOCAL oModel    :=    FWLoadModel("Z01Tela")
     
    //Cria��o da estrutura de dados utilizada na interface do cadastro de Autor
    LOCAL oStZ01    :=    FWFormStruct(2, "Z01")  //pode se usar um terceiro par�metro para filtrar os campos exibidos { |cCampo| cCampo $ 'SZ01_NOME|SZ01_DTAFAL|'}
     
    //Criando oView como nulo
    LOCAL oView     :=    Nil
 
    //Criando a view que ser� o retorno da fun��o e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Atribuindo formul�rios para interface
    oView:AddField("VIEW_Z01", oStZ01, "FORMZ01")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
     
    //Colocando t�tulo do formul�rio
    oView:EnableTitleView('VIEW_Z01', 'Dados - '+cTitulo )  
     
    //For�a o fechamento da janela na confirma��o
    oView:SetCloseOnOk({||.T.})
     
    //O formul�rio da interface ser� colocado dentro do container
    oView:SetOwnerView("VIEW_Z01","TELA")
     
    /*
    //Tratativa para remover campos da visualiza��o
    FOR nAtual := 1 TO Len(aStruZ01)
        cCampoAux := Alltrim(aStruZ01[nAtual][01])
         
        //Se o campo atual n�o estiver nos que forem considerados
        IF Alltrim(cCampoAux) $ "Z01_CODIGO;"
            oStZ01:RemoveField(cCampoAux)
        ENDIF
    NEXT
    */
RETURN oView

 
USER FUNCTION Z01Leg()

    LOCAL aLegenda    :=    {}
     
    //Monta as cores
    AADD(aLegenda,{"BR_VERDE",        "N�o Bloqueado"  })
    AADD(aLegenda,{"BR_VERMELHO",    "Bloqueado"})
     
    BrwLegenda(cTitulo, "Status", aLegenda)
RETURN
