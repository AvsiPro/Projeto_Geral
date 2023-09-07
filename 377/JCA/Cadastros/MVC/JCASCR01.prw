//Bibliotecas
#INCLUDE 'Protheus.ch'
#INCLUDE 'FWMVCDef.ch'
 
//Vari�veis Est�ticas
STATIC cTitulo    :=    "Cadastro de Marcas"
 
USER FUNCTION JCASCR01()

    LOCAL aArea      :=    GetArea()
    LOCAL oBrowse
    LOCAL cFunBkp    :=    FunName()
     
    SetFunName("JCASCR01")
     
    //Inst�nciando FWMBrowse - Somente com dicion�rio de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a tabela de cadastro de Autor/Interprete
    oBrowse:SetAlias("ZPM")
 
    //Setando a descri��o da rotina
    oBrowse:SetDescription(cTitulo)
     
    //Legendas
    oBrowse:AddLegend( "ZPM->ZPM_MSBLQL = '2'", "GREEN", "N�o bloqueado" )
    oBrowse:AddLegend( "ZPM->ZPM_MSBLQL = '1'", "RED",   "Bloqueado" )
     
    //Filtrando
    //oBrowse:SetFilterDefault("ZPM->ZPM_CODIGO >= '000000' .And. ZPM->ZPM_CODIGO <= 'ZZZZZZ'")
     
    //Ativa a Browse
    oBrowse:Activate()
     
    SetFunName(cFunBkp)
    RestArea(aArea)
RETURN Nil

 
STATIC FUNCTION MenuDef()

    LOCAL aRot    :=    {}
     
    //Adicionando op��es
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.JCASCR01' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Legenda'    ACTION 'U_ZPMLeg'        OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.JCASCR01' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.JCASCR01' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.JCASCR01' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
RETURN aRot

 
STATIC FUNCTION ModelDef()

    //Cria��o do objeto do modelo de dados
    LOCAL oModel    :=    Nil
     
    //Cria��o da estrutura de dados utilizada na interface
    LOCAL oStZPM    :=    FWFormStruct(1, "ZPM")
     
    //Editando caracter�sticas do dicion�rio
    oStZPM:SetProperty('ZPM_CODIGO',  MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.'))                                 //Modo de Edi��o
    oStZPM:SetProperty('ZPM_CODIGO',  MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("ZPM", "ZPM_CODIGO")'))      //Ini Padr�o
    oStZPM:SetProperty('ZPM_DESCRI',  MODEL_FIELD_VALID,   FwBuildFeature(STRUCT_FEATURE_VALID,   'Iif(Empty(M->ZPM_DESCRI), .F., .T.)')) //Valida��o de Campo
    oStZPM:SetProperty('ZPM_DESCRI',  MODEL_FIELD_OBRIGAT, Iif(RetCodUsr()!='000000', .T., .F.) )                                         //Campo Obrigat�rio
     
    //Instanciando o modelo, n�o � recomendado colocar nome da USER FUNCTION (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("JCASCR01M",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
     
    //Atribuindo formul�rios para o modelo
    oModel:AddFields("FORMZPM",/*cOwner*/,oStZPM)
     
    //Setando a chave prim�ria da rotina
    oModel:SetPrimaryKey({'ZPM_FILIAL','ZPM_CODIGO'})
     
    //Adicionando descri��o ao modelo
    oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)
     
    //Setando a descri��o do formul�rio
    oModel:GetModel("FORMZPM"):SetDescription("Formul�rio do Cadastro "+cTitulo)
RETURN oModel

 
STATIC FUNCTION ViewDef()
    // LOCAL aStruZPM    := ZPM->(DbStruct())
     
    //Cria��o do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
    LOCAL oModel    :=    FWLoadModel("JCASCR01")
     
    //Cria��o da estrutura de dados utilizada na interface do cadastro de Autor
    LOCAL oStZPM    :=    FWFormStruct(2, "ZPM")  //pode se usar um terceiro par�metro para filtrar os campos exibidos { |cCampo| cCampo $ 'SZPM_NOME|SZPM_DTAFAL|'}
     
    //Criando oView como nulo
    LOCAL oView     :=    Nil
 
    //Criando a view que ser� o retorno da fun��o e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Atribuindo formul�rios para interface
    oView:AddField("VIEW_ZPM", oStZPM, "FORMZPM")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
     
    //Colocando t�tulo do formul�rio
    oView:EnableTitleView('VIEW_ZPM', 'Dados - '+cTitulo )  
     
    //For�a o fechamento da janela na confirma��o
    oView:SetCloseOnOk({||.T.})
     
    //O formul�rio da interface ser� colocado dentro do container
    oView:SetOwnerView("VIEW_ZPM","TELA")
     
    /*
    //Tratativa para remover campos da visualiza��o
    FOR nAtual := 1 TO Len(aStruZPM)
        cCampoAux := Alltrim(aStruZPM[nAtual][01])
         
        //Se o campo atual n�o estiver nos que forem considerados
        IF Alltrim(cCampoAux) $ "ZPM_CODIGO;"
            oStZPM:RemoveField(cCampoAux)
        ENDIF
    NEXT
    */
RETURN oView

 
USER FUNCTION ZPMLeg()

    LOCAL aLegenda    :=    {}
     
    //Monta as cores
    AADD(aLegenda,{"BR_VERDE",        "N�o Bloqueado"  })
    AADD(aLegenda,{"BR_VERMELHO",    "Bloqueado"})
     
    BrwLegenda(cTitulo, "Status", aLegenda)
RETURN

