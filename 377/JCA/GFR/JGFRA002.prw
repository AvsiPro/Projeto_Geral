//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include "TopConn.ch"


//Vari�veis Est�ticas
Static cTitulo := "Cadastro de Pe�as por Tempo e Contador"

User Function JGFRA002()
    Local aArea   := GetArea()
    Local oBrowse
     
    //Inst�nciando FWMBrowse - Somente com dicion�rio de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a tabela de cadastro de Autor/Interprete
    oBrowse:SetAlias("ZPO")
 
    //Setando a descri��o da rotina
    oBrowse:SetDescription(cTitulo)

    //Ativa a Browse
    oBrowse:Activate()
     
    RestArea(aArea)
Return Nil
 
Static Function MenuDef()
    Local aRot := {}
     
    //Adicionando op��es
    ADD OPTION aRot TITLE 'Visualizar'  ACTION 'VIEWDEF.JGFRA002' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Incluir'     ACTION 'VIEWDEF.JGFRA002' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'     ACTION 'VIEWDEF.JGFRA002' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'     ACTION 'VIEWDEF.JGFRA002' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
    ADD OPTION aRot TITLE 'Aprovadores de pe�as e Rebertura de OS' ACTION 'u_JCA2APRV()'     OPERATION 9 ACCESS 0
 
Return aRot
 
Static Function ModelDef()
    //Cria��o do objeto do modelo de dados
    Local oModel := Nil
     
    //Cria��o da estrutura de dados utilizada na interface
    Local oStZPO := FWFormStruct(1, "ZPO")
     
    //Instanciando o modelo, n�o � recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("JCASC2M",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
     
    //Atribuindo formul�rios para o modelo
    oModel:AddFields("FORMZPO",/*cOwner*/,oStZPO)
     
    //Setando a chave prim�ria da rotina
    oModel:SetPrimaryKey({'ZPO_FILIAL','ZPO_CODIGO'})
     
    //Adicionando descri��o ao modelo
    oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)
     
    //Setando a descri��o do formul�rio
    oModel:GetModel("FORMZPO"):SetDescription("Formul�rio do Cadastro "+cTitulo)
Return oModel


Static Function ViewDef()
     
    //Cria��o do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
    Local oModel := FWLoadModel("JGFRA002")
     
    //Cria��o da estrutura de dados utilizada na interface do cadastro de Autor
    Local oStZPO := FWFormStruct(2, "ZPO")  //pode se usar um terceiro par�metro para filtrar os campos exibidos { |cCampo| cCampo $ 'SZPO_NOME|SZPO_DTAFAL|'}
     
    //Criando oView como nulo
    Local oView := Nil
 
    //Criando a view que ser� o retorno da fun��o e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Atribuindo formul�rios para interface
    oView:AddField("VIEW_ZPO", oStZPO, "FORMZPO")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
     
    //Colocando t�tulo do formul�rio
    oView:EnableTitleView('VIEW_ZPO', 'Dados - '+cTitulo )  
     
    //For�a o fechamento da janela na confirma��o
    oView:SetCloseOnOk({||.T.})
     
    //O formul�rio da interface ser� colocado dentro do container
    oView:SetOwnerView("VIEW_ZPO","TELA")

Return oView


User Function JCA2APRV()

Local aArea := GetArea()
//Local aGrup := UsrRetGrp(PswChave(RetCodUsr()),RetCodUsr())
//Local nCont 
Local lAdm := .F.

If Empty(FunName())
   RpcSetType(3)
   RpcSetEnv('01','00020087')
EndIf

Private cAprv := SuperGetMV("TI_JAPROVB",.F.,"000000/000347")

lAdm := RetCodUsr() $ cAprv

If !lAdm
    MsgAlert('Usu�rio n�o possui permiss�o para cadastrar aprovadores.',"JGFRA002 - JCA2APRV")
    Return
EndIf
/*

    Em 10/06/24 foi solicitado para que fosse criado um parametro para controlar quem pode
    incluir usu�rios aprovadores.

ZPT->(DbSetOrder(1))
lAprov := ZPT->(DbSeek( FWxFilial('ZPT') + AvKey(RetCodUsr(),'ZPT_USER') ))

//lAdm := RetCodUsr() == '000000'
For nCont := 1 to len(aGrup)
    If aGrup[nCont] == "000000"
        lAdm := .T.
    endif 
Next nCont 

If !(lAprov .OR. lAdm )
    MsgAlert('Usu�rio n�o possui permiss�o para cadastrar aprovadores.')
    Return
EndIf
*/

//Objetos da Janela
Private oDlgPvt
Private oMsGetZPT
Private aHeadZPT := {}
Private aColsZPT := {}
Private oBtnSalv
Private oBtnFech
//Tamanho da Janela
Private    nJanLarg    := 700
Private    nJanAltu    := 500
//Fontes
Private    cFontUti   := "Tahoma"
Private    oFontSub   := TFont():New(cFontUti,,-20)
Private    oFontSubN  := TFont():New(cFontUti,,-20,,.T.)
Private    oFontBtn   := TFont():New(cFontUti,,-14)
     
    //Criando o cabe�alho da Grid
    //              T�tulo      Campo        M�scara                        Tamanho                   Decimal      Valid                    Usado  Tipo F3   Combo
    aAdd(aHeadZPT, {"Filial",   "ZPT_FILIAL", "",                           TamSX3("ZPT_FILIAL")[01], 0,           "NaoVazio()",            ".T.", "C", "SM0",""} )
    aAdd(aHeadZPT, {"Usu�rio",  "ZPT_USER",   "",                           TamSX3("ZPT_USER")[01],   0,           "u_USRGAT(ReadVar())",   ".T.", "C", "USR",""} )
    aAdd(aHeadZPT, {"Nome",     "ZPT_NOME",   "",                           TamSX3("ZPT_NOME")[01],   0,           ".F.",                   ".F.", "C", ""   ,""} )
    aAdd(aHeadZPT, {"Tipo Acesso","ZPT_ROTINA",   "",                       TamSX3("ZPT_ROTINA")[01], 0,           ".T.",                   ".F.", "C", ""   ,""} )
    aAdd(aHeadZPT, {"Recno",    "XX_RECNO",  "@E 999,999,999,999,999,999",  018,                      0,           ".F.",                   ".F.", "N", ""   ,""} )
 
    Processa({|| fCarAcols()}, "Processando")
 
    //Cria��o da tela com os dados que ser�o informados
    DEFINE MSDIALOG oDlgPvt TITLE "Usu�rios Aprovadores" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
        //Labels gerais
        @ 004, 003 SAY "Usu�rios Aprovadores"                SIZE 200, 030 FONT oFontSub  OF oDlgPvt COLORS RGB(031,073,125) PIXEL
        @ 014, 003 SAY "Pe�as por tempo fora do previsto"    SIZE 200, 030 FONT oFontSubN OF oDlgPvt COLORS RGB(031,073,125) PIXEL
         
        //Bot�es
        @ 006, (nJanLarg/2-001)-(0052*01) BUTTON oBtnFech  PROMPT "Fechar"  SIZE 050, 018 OF oDlgPvt ACTION (oDlgPvt:End()) FONT oFontBtn PIXEL
        @ 006, (nJanLarg/2-001)-(0052*02) BUTTON oBtnSalv  PROMPT "Salvar"  SIZE 050, 018 OF oDlgPvt ACTION (fSalvar())     FONT oFontBtn PIXEL
         
        //Grid dos grupos
        oMsGetZPT := MsNewGetDados():New(;
            029,;                //nTop      - Linha Inicial
            003,;                //nLeft     - Coluna Inicial
            (nJanAltu/2)-3,;     //nBottom   - Linha Final
            (nJanLarg/2)-3,;     //nRight    - Coluna Final
            GD_INSERT + GD_UPDATE + GD_DELETE,; //nStyle    - Estilos para edi��o da Grid (GD_INSERT = Inclus�o de Linha; GD_UPDATE = Altera��o de Linhas; GD_DELETE = Exclus�o de Linhas)
            "AllwaysTrue()",;    //cLinhaOk  - Valida��o da linha
            ,;                   //cTudoOk   - Valida��o de todas as linhas
            "",;                 //cIniCpos  - Fun��o para inicializa��o de campos
            ,;                   //aAlter    - Colunas que podem ser alteradas
            ,;                   //nFreeze   - N�mero da coluna que ser� congelada
            9999,;               //nMax      - M�ximo de Linhas
            ,;                   //cFieldOK  - Valida��o da coluna
            ,;                   //cSuperDel - Valida��o ao apertar '+'
            ,;                   //cDelOk    - Valida��o na exclus�o da linha
            oDlgPvt,;            //oWnd      - Janela que � a dona da grid
            aHeadZPT,;           //aHeader   - Cabe�alho da Grid
            aColsZPT)            //aCols     - Dados da Grid
         
    ACTIVATE MSDIALOG oDlgPvt CENTERED
     
    RestArea(aArea)
Return
 
/*------------------------------------------------*
 | Func.: fCarAcols                               |
 | Desc.: Fun��o que carrega o aCols              |
 *------------------------------------------------*/
 
Static Function fCarAcols()

Local aArea  := GetArea()
Local cQry   := ""
Local nAtual := 0
Local nTotal := 0
    
    //Seleciona dados do documento de entrada
    cQry := " SELECT R_E_C_N_O_ AS RECZPT, * FROM "+RetSqlName("ZPT")+" "
    cQry += " WHERE D_E_L_E_T_ = ' ' "

    TCQuery cQry New Alias "QRYTMP"
     
    //Setando o tamanho da r�gua
    Count To nTotal
    ProcRegua(nTotal)
     
    //Enquanto houver dados
    QRYTMP->(DbGoTop())
    While ! QRYTMP->(EoF())
     
        //Atualizar r�gua de processamento
        nAtual++
        IncProc("Adicionando " + Alltrim(QRYTMP->ZPT_NOME) + " (" + cValToChar(nAtual) + " de " + cValToChar(nTotal) + ")...")
         
        //Adiciona o item no aCols
        aAdd(aColsZPT, { ;
            QRYTMP->ZPT_FILIAL,;
            QRYTMP->ZPT_USER,;
            QRYTMP->ZPT_NOME,;
            QRYTMP->ZPT_ROTINA,;
            QRYTMP->RECZPT,;
            .F.;
        })
         
        QRYTMP->(DbSkip())
    EndDo
    QRYTMP->(DbCloseArea())
     
    RestArea(aArea)
Return
 
 
/*--------------------------------------------------------*
 | Func.: fSalvar                                         |
 | Desc.: Fun��o que percorre as linhas e faz a grava��o  |
 *--------------------------------------------------------*/
 
Static Function fSalvar()

Local aColsAux := oMsGetZPT:aCols
Local nPosFil  := aScan(aHeadZPT, {|x| Alltrim(x[2]) == "ZPT_FILIAL"})
Local nPosUsr  := aScan(aHeadZPT, {|x| Alltrim(x[2]) == "ZPT_USER"})
Local nPosNom  := aScan(aHeadZPT, {|x| Alltrim(x[2]) == "ZPT_NOME"})
Local nPosRot  := aScan(aHeadZPT, {|x| Alltrim(x[2]) == "ZPT_ROTINA"})
Local nPosRec  := aScan(aHeadZPT, {|x| Alltrim(x[2]) == "XX_RECNO"})
Local nPosDel  := Len(aHeadZPT) + 1
Local nLinha   := 0
     
    DbSelectArea('ZPT')
     
    //Percorrendo todas as linhas
    For nLinha := 1 To Len(aColsAux)
     
        //Posiciona no registro
        If aColsAux[nLinha][nPosRec] != 0
            ZPT->(DbGoTo(aColsAux[nLinha][nPosRec]))
        EndIf
         
        //Se a linha estiver exclu�da
        If aColsAux[nLinha][nPosDel]
             
            //Se n�o for uma linha nova
            If aColsAux[nLinha][nPosRec] != 0
                RecLock("ZPT", .F.)
                    DbDelete()
                ZPT->(MsUnlock())
            EndIf
             
        //Se a linha for inclu�da
        ElseIf aColsAux[nLinha][nPosRec] == 0
            RecLock('ZPT', .T.)
            ZPT->ZPT_FILIAL  := aColsAux[nLinha][nPosFil]
            ZPT->ZPT_USER    := aColsAux[nLinha][nPosUsr]
            ZPT->ZPT_NOME    := aColsAux[nLinha][nPosNom]
            ZPT->ZPT_ROTINA  := aColsAux[nLinha][nPosRot]
            ZPT->(MsUnlock())
            aColsAux[nLinha][nPosRec] := ZPT->(Recno())
       //Sen�o, ser� altera��o
        Else
            RecLock('ZPT', .F.)
            ZPT->ZPT_FILIAL  := aColsAux[nLinha][nPosFil]
            ZPT->ZPT_USER    := aColsAux[nLinha][nPosUsr]
            ZPT->ZPT_NOME    := aColsAux[nLinha][nPosNom]
            ZPT->ZPT_ROTINA  := aColsAux[nLinha][nPosRot]
            SBM->(MsUnlock())
        EndIf
         
    Next
    
    MsgInfo('Altera��oes Salvas')
    oDlgPvt:Refresh()
Return


/*/{Protheus.doc} fMarkNow
    @type Static Function
    @author Felipe Mayer
    @since 20/02/2023
    @Desc 
/*/
User Function USRGAT(cCampo)

Local lRet    := .T.
Local nPosNom := aScan(oMsGetZPT:aHeader,{|x| AllTrim(x[2]) == "ZPT_NOME"})

    oMsGetZPT:aCols[oMsGetZPT:nAt][nPosNom] := UsrFullName(&(cCampo))

    oMsGetZPT:Refresh()
    oDlgPvt:Refresh()

Return lRet
