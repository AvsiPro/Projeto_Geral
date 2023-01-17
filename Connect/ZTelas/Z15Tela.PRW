//Bibliotecas
#INCLUDE 'Protheus.ch'
#INCLUDE 'FWMVCDef.ch'
 
//Variáveis Estáticas
STATIC cTitulo    :=    "Inclusao/Retirada de Maquinas Connect"
/*/{Protheus.doc} 
    (long_description)
    @type  Static Function
    @author user
    @since 16/01/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
USER FUNCTION Z15Tela()

    LOCAL aArea      :=    GetArea()
    LOCAL oBrowse
    LOCAL cFunBkp    :=    FunName()
     
    SetFunName("Z15Tela")
     
    //Instânciando FWMBrowse - Somente com dicionário de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a tabela de cadastro de Autor/Interprete
    oBrowse:SetAlias("Z15")
 
    //Setando a descrição da rotina
    oBrowse:SetDescription(cTitulo)
     
    //Legendas
    oBrowse:AddLegend( "Z15->Z15_STATUS = 'A'", "GREEN" , "Ativo" )
    oBrowse:AddLegend( "Z15->Z15_STATUS = 'B'", "RED"   , "Encerrado" )
    oBrowse:AddLegend( "Z15->Z15_STATUS = 'C'", "YELLOW", "Em Preparacao" )
     
    //Filtrando
    //oBrowse:SetFilterDefault("Z15->Z15_CODIGO >= '000000' .And. Z15->Z15_CODIGO <= 'ZZZZZZ'")
     
    //Ativa a Browse
    oBrowse:Activate()
     
    SetFunName(cFunBkp)
    RestArea(aArea)
RETURN Nil
/*/{Protheus.doc} StatCnt
    (long_description)
    @type  Static Function
    @author user
    @since 16/01/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
STATIC FUNCTION MenuDef()

    LOCAL aRot    :=    {}
     
    //Adicionando opções
    ADD OPTION aRot TITLE 'Visualizar'          ACTION 'VIEWDEF.Z15Tela' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Legenda'             ACTION 'U_Z15Leg'        OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Incluir'             ACTION 'VIEWDEF.Z15Tela' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'             ACTION 'VIEWDEF.Z15Tela' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'             ACTION 'VIEWDEF.Z15Tela' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
    ADD OPTION aRot TITLE 'Atribuir Ativo'      ACTION 'U_Z15Chama(1)'   OPERATION 7                      ACCESS 0 //OPERATION 7
    ADD OPTION aRot TITLE 'Retirar Ativo'       ACTION 'U_Z15Chama(2)'   OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 7
    ADD OPTION aRot TITLE 'Confirmar Instalação'ACTION 'U_Z15Chama(3)'   OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 7
    
RETURN aRot
/*/{Protheus.doc} StatCnt
    (long_description)
    @type  Static Function
    @author user
    @since 16/01/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/ 
STATIC FUNCTION ModelDef()

    //Criação do objeto do modelo de dados
    LOCAL oModel    :=    Nil
     
    //Criação da estrutura de dados utilizada na interface
    LOCAL oStZ15    :=    FWFormStruct(1, "Z15")
     
    //Instanciando o modelo, não é recomendado colocar nome da USER FUNCTION (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("Z15TelaM",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
     
    //Atribuindo formulários para o modelo
    oModel:AddFields("FORMZ15",/*cOwner*/,oStZ15)
     
    //Setando a chave primária da rotina
    oModel:SetPrimaryKey({'Z15_FILIAL','Z15_CONTRA'})
     
    //Adicionando descrição ao modelo
    oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)
     
    //Setando a descrição do formulário
    oModel:GetModel("FORMZ15"):SetDescription("Formulário do Cadastro "+cTitulo)
RETURN oModel
/*/{Protheus.doc} StatCnt
    (long_description)
    @type  Static Function
    @author user
    @since 16/01/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
STATIC FUNCTION ViewDef()
    // LOCAL aStruZ15    := Z15->(DbStruct())
     
    //Criação do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
    LOCAL oModel    :=    FWLoadModel("Z15Tela")
     
    //Criação da estrutura de dados utilizada na interface do cadastro de Autor
    LOCAL oStZ15    :=    FWFormStruct(2, "Z15")  //pode se usar um terceiro parâmetro para filtrar os campos exibidos { |cCampo| cCampo $ 'SZ15_NOME|SZ15_DTAFAL|'}
     
    //Criando oView como nulo
    LOCAL oView     :=    Nil
 
    //Criando a view que será o retorno da função e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Atribuindo formulários para interface
    oView:AddField("VIEW_Z15", oStZ15, "FORMZ15")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
     
    //Colocando título do formulário
    oView:EnableTitleView('VIEW_Z15', 'Dados - '+cTitulo )  
     
    //Força o fechamento da janela na confirmação
    oView:SetCloseOnOk({||.T.})
     
    //O formulário da interface será colocado dentro do container
    oView:SetOwnerView("VIEW_Z15","TELA")
     
RETURN oView
/*/{Protheus.doc} StatCnt
    (long_description)
    @type  Static Function
    @author user
    @since 16/01/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
USER FUNCTION Z15Leg()

    LOCAL aLegenda    :=    {}
     
    //Monta as cores
    AADD(aLegenda,{"BR_VERDE",           "Ativo"     })
    AADD(aLegenda,{"BR_VERMELHO",        "Encerrado" })
    AADD(aLegenda,{"BR_AMARELO",        "Em Preparacao" })
     
    BrwLegenda(cTitulo, "Status", aLegenda)
RETURN
/*/{Protheus.doc} StatCnt
    (long_description)
    @type  Static Function
    @author user
    @since 16/01/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
User Function Z15Chama(nOpc)

Local aArea :=  GetArea()

if nOpc == 1
    If Z15->Z15_STATUS == "B"
        MsgAlert("Chamado já finalizado","Z15TELA")
    ElseIf Z15->Z15_STATUS == "C"
        MsgAlert("Já foi atribuído um ativo para este chamado","Z15TELA")
    Else
        U_CONFSC03(Z15->Z15_CONTRA,Z15->Z15_CLIENT,Z15->Z15_LOJA)
    EndIf
elseif nOpc == 2
    If Z15->Z15_STATUS == "B"
        MsgAlert("Chamado já finalizado","Z15TELA")
    ElseIf Z15->Z15_STATUS == "C"
        MsgAlert("Já foi atribuído um ativo para este chamado","Z15TELA")
    Else
        U_CONFSC04(Z15->Z15_CONTRA)
    EndIf 
elseif nOpc == 3
    aPergs  :=  {}
    aRet    :=  {}
    dDtCnf  :=  ctod(" / / ")            

    aAdd(aPergs ,{1, "Data Inst./Desinst."       , dDtCnf, "", "", "", "", 040, .T.})

    IF ParamBox(aPergs ,"Informe a data de instalação/desinstalação da maquina no cliente.",@aRet)
        dDtCnf := aRet[1]
        If MsgYesNo("Confirma a instalação da maquina no cliente?")
            
        EndIf 
    EndIf
endif

RestArea(aArea)

Return 
