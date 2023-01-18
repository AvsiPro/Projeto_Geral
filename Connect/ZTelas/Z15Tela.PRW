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
    oBrowse:AddLegend( "Z15->Z15_STATUS = 'A'", "GREEN" ,         "Ativo" )
    oBrowse:AddLegend( "Z15->Z15_STATUS = 'B'", "BLACK"   ,   "Encerrado" )
    oBrowse:AddLegend( "Z15->Z15_STATUS = 'C'", "YELLOW", "Em Preparacao" )
    oBrowse:AddLegend( "Z15->Z15_STATUS = 'D'", "RED",      "A Confirmar" )
     
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
    ADD OPTION aRot TITLE 'Atender Pedido'      ACTION 'U_CONOPC06()'    OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 7
    
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
    AADD(aLegenda,{"BR_VERDE",                        "Ativo" })
    AADD(aLegenda,{"BR_VERMELHO",                 "Encerrado" })
    AADD(aLegenda,{"BR_AMARELO",              "Em Preparacao" })
    AADD(aLegenda,{"BR_PRETO",         "Pendente Confirmacao" })
     
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

        if Z15->Z15_STATUS != "D"
            MsgAlert("Pedido não está em estágio de confirmação!", "Erro!")
            Return
        endif

        cQuery := " "
        cQuery += " SELECT *   " 
        cQuery += " FROM   " + RetSQLName("Z15") + "   " 
        cQuery += " INNER JOIN " + RetSQLName("AB1") + " ON Z15_NRCHAM = AB1_NRCHAM AND AB1_FILIAL = '" + xFilial("AB1") + "' " 
        cQuery += " INNER JOIN " + RetSQLName("AB2") + " ON AB1_NRCHAM = AB2_NRCHAM AND AB2_FILIAL = '" + xFilial("AB2") + "' " 
        cQuery += " INNER JOIN " + RetSQLName("AB7") + " ON AB7_NUMOS = SUBSTRING(AB2_NUMOS , 1 , 6) AND AB7_FILIAL = '" + xFilial ("AB7") + "' " 
        cQuery += "        AND AB7_ITEM = SUBSTRING(AB2_NUMOS , 7 , 2)   " 
        cQuery += " INNER JOIN " + RetSQLName("AB8") + " ON AB8_NUMOS = AB7_NUMOS AND AB8_FILIAL = '" + xFilial("AB8") + "' "
        cQuery += " INNER JOIN " + RetSQLName("SC5") + " ON C5_NUM = SUBSTRING(AB8_NUMPV , 1 , 6) AND C5_FILIAL = '" + xFilial("SC5") + "' "
        cQuery += " INNER JOIN " + RetSQLName("SC6") + " ON C6_NUM = C5_NUM AND C6_FILIAL = '" + xFilial("SC6") + "' "
        cQuery += "        AND C6_ITEM = SUBSTRING(AB8_NUMPV , 7 , 2)   " 
        cQuery += " WHERE  C6_NOTA != ' '   " 
        cQuery += "        AND C6_DATFAT != ' '   " 
        cQuery += "        AND C6_SERIE != ' '   " 
        cQuery += "        AND C6_CONTRT = '" + Z15->Z15_CONTRA + "'   " 
        cQuery += "        AND C5_CLIENTE = '" + Z15->Z15_CLIENT + " '   " 
        cQuery += "        AND C5_LOJACLI = " + Z15->Z15_LOJA + "   " 
        cQuery += "        AND SUBSTRING(C6_NUMOS, 1, 6) = AB8_NUMOS   " 
        cQuery += "        AND SUBSTRING(C6_NUMOS, 7, 2) = AB8_ITEM   " 

        if Select("TRB") > 0
            DbSelectArea("TRB")
            DbCloseArea()
        endif

		cQuery := ChangeQuery(cQuery)

		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)

        if AllTrim(TRB->C6_NUM) == ''
            MsgAlert("Pedido não faturado!", "Erro!")
            Return
        endif

        aAdd(aPergs ,{1, "Data Inst./Desinst."       , dDtCnf, "", "", "", "", 040, .T.})

        IF ParamBox(aPergs ,"Informe a data de instalação/desinstalação da maquina no cliente.",@aRet)
            dDtCnf := aRet[1]
            If MsgYesNo("Confirma a instalação da maquina no cliente?")
                RecLock("Z16", .T.)
                    Z16->Z16_FILIAL := xFilial("Z16")
                    Z16->Z16_CODIGO := GetSXENum("Z16", "Z16_CODIGO")
                    Z16->Z16_CBASE  := Z15->Z15_CBASE
                    Z16->Z16_CLIENT := Z15->Z15_CLIENT
                    Z16->Z16_LOJA   := Z15->Z15_LOJA
                    if Z15->Z15_TIPO == "A"
                        Z16->Z16_DTINCL := dDtCnf
                    elseif Z15->Z15_TIPO == "B"    
                        Z16->Z16_DTREMO := dDtCnf
                    endif
                    Z16->Z16_CONTRA := Z15->Z15_CONTRA
                    Z16->Z16_CHAMAD := Z15->Z15_NRCHAM
                MsUnlock()

                ConfirmSX8()

                RecLock("Z15", .F.)
                    Z15->Z15_STATUS := "B"
                MsUnlock()

                MsgInfo("Instalação Confirmada!", "Fim!")

            EndIf 
        EndIf
    endif

    RestArea(aArea)

Return 
