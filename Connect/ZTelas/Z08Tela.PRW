//Bibliotecas
#INCLUDE 'Protheus.ch'
#INCLUDE 'FWMVCDef.ch'
 
//Variáveis Estáticas
STATIC cTitulo    :=    "Inclusão Manual de Leitura"
 
USER FUNCTION Z08Tela()
   
    LOCAL aArea      :=    GetArea()
    LOCAL oBrowse
    LOCAL cFunBkp    :=    FunName()
     
    SetFunName("Z08Tela")
     
    //Instânciando FWMBrowse - Somente com dicionário de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a tabela de cadastro de Autor/Interprete
    oBrowse:SetAlias("Z08")
 
    //Setando a descrição da rotina
    oBrowse:SetDescription(cTitulo)
     
    //Legendas
    oBrowse:AddLegend( "Z08->Z08_MSBLQL = '2'", "GREEN",    "Não bloqueado" )
    oBrowse:AddLegend( "Z08->Z08_MSBLQL =  '1'", "RED",    "Bloqueado" )
     
    //Filtrando
    oBrowse:SetFilterDefault("Z08->Z08_SEQUEN = '01'")
     
    //Ativa a Browse
    oBrowse:Activate()
     
    SetFunName(cFunBkp)
    RestArea(aArea)
RETURN Nil

 
STATIC FUNCTION MenuDef()
    LOCAL aRot    :=    {}
     
    //Adicionando opções
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.Z08Tela'        OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Legenda'    ACTION 'U_Z08Leg'               OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'U_CONOPC05'             OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.Z08Tela'        OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'U_Z08EXC(Z08->Z08_COD)' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
    ADD OPTION aRot TITLE 'Importar'   ACTION 'U_Z08IMP()'             OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 5
 
RETURN aRot

 
STATIC FUNCTION ModelDef()
    
    //Criação do objeto do modelo de dados
    LOCAL oModel    :=    Nil
     
    //Criação da estrutura de dados utilizada na interface
    LOCAL oStZ08    :=    FWFormStruct(1, "Z08")
     
    //Editando características do dicionário
    oStZ08:SetProperty('Z08_COD',   MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.'))                                 //Modo de Edição
    oStZ08:SetProperty('Z08_COD',   MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("Z08", "Z08_CODIGO")'))         //Ini Padrão

    //Instanciando o modelo, não é recomendado colocar nome da USER FUNCTION (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("Z08TelaM",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
     
    //Atribuindo formulários para o modelo
    oModel:AddFields("FORMZ08",/*cOwner*/,oStZ08)
     
    //Setando a chave primária da rotina
    oModel:SetPrimaryKey({'Z08_FILIAL','Z08_CODIGO'})
     
    //Adicionando descrição ao modelo
    oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)
     
    //Setando a descrição do formulário
    oModel:GetModel("FORMZ08"):SetDescription("Formulário do Cadastro "+cTitulo)
RETURN oModel

 
STATIC FUNCTION ViewDef()
    // LOCAL aStruZ08    := Z08->(DbStruct())
     
    //Criação do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
    LOCAL oModel    :=    FWLoadModel("Z08Tela")
     
    //Criação da estrutura de dados utilizada na interface do cadastro de Autor
    LOCAL oStZ08    :=    FWFormStruct(2, "Z08")  //pode se usar um terceiro parâmetro para filtrar os campos exibidos { |cCampo| cCampo $ 'SZ08_NOME|SZ08_DTAFAL|'}
     
    //Criando oView como nulo
    LOCAL oView     :=    Nil
 
    //Criando a view que será o retorno da função e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Atribuindo formulários para interface
    oView:AddField("VIEW_Z08", oStZ08, "FORMZ08")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
     
    //Colocando título do formulário
    oView:EnableTitleView('VIEW_Z08', 'Dados - '+cTitulo )  
     
    //Força o fechamento da janela na confirmação
    oView:SetCloseOnOk({||.T.})
     
    //O formulário da interface será colocado dentro do container
    oView:SetOwnerView("VIEW_Z08","TELA")
     
    /*
    //Tratativa para remover campos da visualização
    For nAtual := 1 To Len(aStruZ08)
        cCampoAux := Alltrim(aStruZ08[nAtual][01])
         
        //Se o campo atual não estiver nos que forem considerados
        If Alltrim(cCampoAux) $ "Z08_CODIGO;"
            oStZ08:RemoveField(cCampoAux)
        EndIf
    Next
    */
RETURN oView

 
USER FUNCTION Z08Leg()
    // LOCAL aLegenda := {}
     
    // //Monta as cores
    // AADD(aLegenda,{"BR_VERDE",        "Menor ou igual a 5"  })
    // AADD(aLegenda,{"BR_VERMELHO",    "Maior que 5"})
     
    // BrwLegenda(cTitulo, "Status", aLegenda)
RETURN

USER FUNCTION Z08EXC(CCOD)

Local aArea :=  GetArea()
Local lRet  :=  .F.

DbSelectArea("Z08")
DbSetOrder(1)
While !EOF() .AND. Z08->Z08_COD == CCOD 
    Reclock("Z08",.F.)
    DBDelete()
    Z08->(MsUnlock())
    lRet := .T.
    Dbskip()
EndDo 

If lRet 
    MsgAlert("Registro deletado com sucesso!!!")
EndIf 

RestArea(aArea)

RETURN 

// Z08_COD,Z08_SEQUENCIA,Z08_NUMSER,Z08_DATA,Z08_SELECA,Z08_PRODUT,Z08_CONTRT,Z08_ITEM,Z08_QTDLID,Z08_VLRLID,Z08_DTDIGI,Z08_PERIOD,Z08_MAQUIN,Z08_CODCLI,Z08_LOJACL,Z08_NOME,Z08_CLIPAG
User Function Z08IMP()
    
    Local aPerg  := {}
    Local aAux   := {}
    Local aItens := {}
    Local nX := 0
    Local nHandle  
    Local nLast
    Local cLine
    Local nRecno

    aAdd(aPerg,{6,"Buscar arquivo",Space(50),"","","",50,.T.,"Arquivos compativeis (*.csv*) |*.csv*"})
    
    If ParamBox(aPerg, "Informe o arquivo desejado!")
        
        cHandle  := MV_PAR01

    else
        MsgAlert("Operacao abortada!", "Saida!")
        RETURN
    ENDIF

    nHandle := FT_FUSE(cHandle)

    // Se houver erro de abertura abandona processamento
    if nHandle = -1
        return
    endif

    // Posiciona na primeria linha
    FT_FGoTop()

    // Retorna o número de linhas do arquivo
    nLast := FT_FLastRec()

    While !FT_FEOF()

        nRecno := FT_FRecno()

        if nRecno == 1
            FT_FSKIP()
            nRecno := FT_FRecno()
        endif

        cLine := FT_FReadLn()

        aAux  := Separa(cLine,';',.T.) 

        Aadd(aItens, aAux)

        // Pula para próxima linha
        FT_FSKIP()

    End

    // Fecha o Arquivo
    FT_FUSE()

    for nX := 1 to len(aItens)
        
        aAux := {}

        //SELECT Z07_CODPRO,Z07_CLIENT,Z07_LOJA,Z07_CODMAQ FROM Z07010 WHERE Z07_CHAPA = '0669' AND Z07_SELECA = '01'
        //SELECT AAM_CONTRT,AAN_ITEM,AAM_CODCLI,AAM_LOJA FROM AAM010 IINER JOIN AAN010 ON AAN_CONTRT = AAM_CONTRT WHERE AAN_XCBASE = '0669'    
    
        cQuery := " "
        cQuery += " SELECT Z07_CODPRO,Z07_CLIENT,Z07_LOJA,Z07_CODMAQ,AAM_CONTRT,AAN_ITEM,AAM_CODCLI,AAM_LOJA "
        cQuery += " FROM AAM010 "
        cQuery += " INNER JOIN AAN010 "
        cQuery += " ON AAN_CONTRT = AAM_CONTRT "
        cQuery += " AND AAN_XCBASE = '" + aItens[nX,1] + "' "
        cQuery += " INNER JOIN Z07010 "
        cQuery += " ON Z07_CHAPA = AAN_XCBASE "
        cQuery += " AND Z07_SELECA = '" + aItens[nX,3] + "' "

        if Select("TRB") > 0
            dbSelectArea('TRB')
            dbCloseArea()
        endif
        
        DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

        Aadd(aAux, {aItens[nX,1],aItens[nX,2],aItens[nX,3],aItens[nX,4],TRB->Z07_CODPRO,TRB->AAM_CONTRT,TRB->AAN_ITEM,TRB->Z07_CODMAQ,TRB->Z07_CLIENT,TRB->Z07_LOJA,TRB->AAM_CODCLI,TRB->AAM_LOJA})

    next

    oDlg1      := MSDialog():New( 050,100,600,1000,"Importacao de Leituras",,,.F.,,,,,,.T.,,,.T. )
        
    oGrp1      := TGroup():New( 05,05,225,450,"Leituras",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    
        //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{124,048,304,352},,, oGrp3 ) 
        oList1            := TCBrowse():New(15,15,425,200,, {'Numero de Serie','Data','Selecao','Produto','Contrato','Item','Qtd Lida','Vlr Lido','Maquina','COD Cliente','Loja CLiente','COD Cliente Pagante'},,oGrp1,,,,,,, ,,,  ,,.F.,,.T.,,.F.,,,)
        
        oList1:SetArray(aItens)
        oList1:bLine := {||{aItens[oList1:nAt,01],; 
                            aItens[oList1:nAt,02],;
                            aItens[oList1:nAt,03],; 
                            aItens[oList1:nAt,04],;
                            aItens[oList1:nAt,05],;
                            aItens[oList1:nAt,06],;
                            aItens[oList1:nAt,07],;
                            aItens[oList1:nAt,08],;
                            aItens[oList1:nAt,09],;
                            aItens[oList1:nAt,10],;
                            aItens[oList1:nAt,11],;
                            aItens[oList1:nAt,12]}} 

        oBtn1      := TButton():New( 250,200,"Salvar Leitura",oDlg1,{|| oDlg1:end(nOpc:=1)},037,012,,,,.T.,,"",,,,.F. )
        oBtn2      := TButton():New( 250,250,"Cancelar",oDlg1,{|| oDlg1:end(nOpc:=0)},037,012,,,,.T.,,"",,,,.F. )

    oDlg1:Activate(,,,.T.)

    if nOpc == 1
        Z08SALVA(aItens)
    endif

Return 

Static Function Z08SALVA(aItens)
    
    Local nX
    Local cSeq := "01"
    Local cCod := GetSxeNum("Z08", "Z08_COD")

    for nX := 1 to len(aItens)

        RecLock("Z08", .T.)
            Z08->Z08_FILIAL    := xFilial("Z08")
            Z08->Z08_COD       := cCod         //C
            Z08->Z08_SEQUENCIA := cSeq         //C
            Z08->Z08_NUMSER    := aItens[nX,1] //C *
            Z08->Z08_DATA      := CTOD(aItens[nX,2]) //D *
            Z08->Z08_SELECA    := aItens[nX,3] //C *
            Z08->Z08_PRODUT    := aItens[nX,4] //C
            Z08->Z08_CONTRT    := aItens[nX,5] //C
            Z08->Z08_ITEM      := aItens[nX,6] //C
            Z08->Z08_QTDLID    := val(aItens[nX,7]) //N *
            Z08->Z08_VLRLID    := val(aItens[nX,8]) //N
            Z08->Z08_DTDIGI    := dDataBase    //D
            Z08->Z08_PERIOD    := cvaltochar(month(ctod(aItens[nX,2]))) + SubStr(cvaltochar(year(ctod(aItens[nX,2]))), 3, 2) //C
            Z08->Z08_MAQUIN    := aItens[nX,9]  //C
            Z08->Z08_CODCLI    := aItens[nX,10] //C
            Z08->Z08_LOJACL    := aItens[nX,11] //C
            Z08->Z08_CLIPAG    := aItens[nX,12] //C
        MsUnlock()

        cSeq := Soma1(cSeq)

    next

Return 
