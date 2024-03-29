//Bibliotecas
#INCLUDE 'Protheus.ch'
#INCLUDE 'FWMVCDef.ch'
#include "topconn.ch"
#include "tbiconn.ch"
#include "fileio.ch"
#include "topconn.ch"
#include "parmtype.ch"

//Vari�veis Est�ticas
STATIC cTitulo    :=    "Configura��o de Leiaute de Maquinas"
 
USER FUNCTION Z08Tela()
   
    LOCAL aArea      :=    GetArea()
    LOCAL oBrowse
    LOCAL cFunBkp    :=    FunName()
     
    SetFunName("Z08Tela")
     
    //Inst�nciando FWMBrowse - Somente com dicion�rio de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a tabela de cadastro de Autor/Interprete
    oBrowse:SetAlias("Z08")
 
    //Setando a descri��o da rotina
    oBrowse:SetDescription(cTitulo)
     
    //Legendas
    oBrowse:AddLegend( "Z08->Z08_MSBLQL = '2'", "GREEN" ,    "N�o bloqueado"    )
    oBrowse:AddLegend( "Z08->Z08_MSBLQL = '1'", "RED"   ,    "Bloqueado"        )
     
    //Filtrando
    oBrowse:SetFilterDefault("Z08->Z08_SEQUEN = '01'")
     
    //Ativa a Browse
    oBrowse:Activate()
     
    SetFunName(cFunBkp)
    RestArea(aArea)
RETURN Nil

 
STATIC FUNCTION MenuDef()
    LOCAL aRot    :=    {}
     
    //Adicionando op��es
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'U_CONOPC05(1)'        OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Legenda'    ACTION 'U_Z08Leg'               OPERATION 6                      ACCESS 0 //OPERATION X
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'U_CONOPC05(0)'          OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.Z08Tela'        OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'U_Z08EXC(Z08->Z08_COD)' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
    ADD OPTION aRot TITLE 'Importar'   ACTION 'U_Z08IMP()'             OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 5
 
RETURN aRot
 
STATIC FUNCTION ModelDef()
    
    //Cria��o do objeto do modelo de dados
    LOCAL oModel    :=    Nil
     
    //Cria��o da estrutura de dados utilizada na interface
    LOCAL oStZ08    :=    FWFormStruct(1, "Z08")
     
    //Editando caracter�sticas do dicion�rio
    oStZ08:SetProperty('Z08_COD',   MODEL_FIELD_WHEN,    FwBuildFeature(STRUCT_FEATURE_WHEN,    '.T.'))                                 //Modo de Edi��o
    oStZ08:SetProperty('Z08_COD',   MODEL_FIELD_INIT,    FwBuildFeature(STRUCT_FEATURE_INIPAD,  'GetSXENum("Z08", "Z08_CODIGO")'))         //Ini Padr�o

    //Instanciando o modelo, n�o � recomendado colocar nome da USER FUNCTION (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("Z08TelaM",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
     
    //Atribuindo formul�rios para o modelo
    oModel:AddFields("FORMZ08",/*cOwner*/,oStZ08)
     
    //Setando a chave prim�ria da rotina
    oModel:SetPrimaryKey({'Z08_FILIAL','Z08_CODIGO'})
     
    //Adicionando descri��o ao modelo
    oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)
     
    //Setando a descri��o do formul�rio
    oModel:GetModel("FORMZ08"):SetDescription("Formul�rio do Cadastro "+cTitulo)
RETURN oModel

 
STATIC FUNCTION ViewDef()
    // LOCAL aStruZ08    := Z08->(DbStruct())
     
    //Cria��o do objeto do modelo de dados da Interface do Cadastro de Autor/Interprete
    LOCAL oModel    :=    FWLoadModel("Z08Tela")
     
    //Cria��o da estrutura de dados utilizada na interface do cadastro de Autor
    LOCAL oStZ08    :=    FWFormStruct(2, "Z08")  //pode se usar um terceiro par�metro para filtrar os campos exibidos { |cCampo| cCampo $ 'SZ08_NOME|SZ08_DTAFAL|'}
     
    //Criando oView como nulo
    LOCAL oView     :=    Nil
 
    //Criando a view que ser� o retorno da fun��o e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Atribuindo formul�rios para interface
    oView:AddField("VIEW_Z08", oStZ08, "FORMZ08")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
     
    //Colocando t�tulo do formul�rio
    oView:EnableTitleView('VIEW_Z08', 'Dados - '+cTitulo )  
     
    //For�a o fechamento da janela na confirma��o
    oView:SetCloseOnOk({||.T.})
     
    //O formul�rio da interface ser� colocado dentro do container
    oView:SetOwnerView("VIEW_Z08","TELA")
     
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
    Local aAux2  := {}
    Local aItens := {}
    Local cArqT  :=	"C:\00\" + dtos(dDataBase) + StrTran(Time(),":","") + ".txt"
    Local nX     := 0
    Local lErro  := .F.
    Local cErro  := ""
    Local cMsg   := ""
    Local cAux   := ""
    Local nHandle
    Local nLast
    Local cLine
    Local nRecno
    Local nHandle3 :=	fcreate(cArqT, FO_READWRITE + FO_SHARED )

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

    // Retorna o n�mero de linhas do arquivo
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

        // Pula para pr�xima linha
        FT_FSKIP()

    End

    aAux := {}

    // Fecha o Arquivo
    FT_FUSE()

    for nX := 1 to len(aItens)
        
        //verifica se a data na linha � maior que a data atual
        if CTOD(aItens[nX,2]) > dDataBase
            lErro  := .T.
            cMsg  := "A data da leitura na linha " + cValToChar(nX + 1) + " (data: " + aItens[nX,2] + ") � maior do que a data do sistema, deseja prosseguir assim mesmo?"
            if !MsgYesNo(cMsg, "Aten��o!")
                cErro  := "A data da leitura na linha " + cValToChar(nX + 1) + " (data: " + aItens[nX,2] + ") � maior do que a data do sistema"
                EXIT
            endif
            lErro := .F.
        endif

        cQuery := " "
        cQuery += " SELECT N1_XCLIENT,N1_XLOJA,AAN_XCBASE " 
        cQuery += " FROM   " + RetSQLName("SN1") + " SN1 " 
        cQuery += " INNER JOIN " + RetSQLName("AAN") + " AAN ON AAN_FILIAL = '" + xFilial("AAN") + "' AND AAN_XCBASE = N1_CBASE " 
        cQuery += " INNER JOIN " + RetSQLName("AAM") + " AAM ON AAM_FILIAL = AAN_FILIAL AND AAN_CONTRT = AAN_CONTRT " 
        cQuery += " WHERE  N1_CBASE = '" + aItens[nX,1] + "' " 
        cQuery += " AND SN1.D_E_L_E_T_ = ' ' " 
        cQuery += " AND AAN.D_E_L_E_T_ = ' ' " 
        cQuery += " AND AAM.D_E_L_E_T_ = ' ' " 
        cQuery += " AND N1_FILIAL = '" + xFilial("SN1") + "' " 

        if Select("TRB") > 0
            dbSelectArea('TRB')
            dbCloseArea()
        endif
        
        DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

        if AllTrim(TRB->N1_XCLIENT) == ''
            lErro := .T.
            cErro := "O numero de s�rie informado na linha " + cValToChar(nX + 1) + " (numero de s�rie: " + aItens[nX,1] + ") n�o tem cliente vinculado!"
            EXIT
        endif

        cQuery := " "
        cQuery += " SELECT * " 
        cQuery += " FROM " + RetSQLName("Z07") + " " 
        cQuery += " WHERE Z07_CHAPA = '" + aItens[nX,1] + "' " 
        cQuery += " AND Z07_SELECA = '" + aItens[nX,3] + "' " 
        cQuery += " AND D_E_L_E_T_ = ' ' " 
        cQuery += " AND Z07_FILIAL = '" + xFilial("Z07") + "' " 

        if Select("TRB") > 0
            dbSelectArea('TRB')
            dbCloseArea()
        endif
        
        DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

        if AllTrim(TRB->Z07_SELECA) != aItens[nX,3]
            lErro := .T.
            cErro := "A sele��o informada na linha " + cValToChar(nX + 1) + " (sele��o: " + aItens[nX,3] + ") n�o foi encontrada no cadastro do mapa!" 
            EXIT
        endif

        cQuery := " "
        cQuery += " SELECT MAX(Z08_DATA) AS DATA1 " 
        cQuery += " FROM   " + RetSQLName("Z08") + " " 
        cQuery += " WHERE  Z08_NUMSER = '" + aItens[nX,1] + "' " 
        cQuery += " AND Z08_SELECA = '" + aItens[nX,3] + "' " 
        cQuery += " AND D_E_L_E_T_ = ' ' " 
        cQuery += " AND Z08_MSBLQL != '1' " 
        cQuery += " AND Z08_FILIAL = '" + xFilial("Z08") + "' " 

        if Select("TRB") > 0
            dbSelectArea('TRB')
            dbCloseArea()
        endif
        
        DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

        if TRB->DATA1 > DTOS(CTOD(aItens[nX,2]))

            cQuery := " "
            cQuery += " SELECT Z08_COD " 
            cQuery += " FROM   " + RetSQLName("Z08") + " " 
            cQuery += " WHERE  Z08_NUMSER = '" + aItens[nX,1] + "' " 
            cQuery += " AND Z08_SELECA = '" + aItens[nX,3] + "' " 
            cQuery += " AND Z08_DATA = '" + DTOS(CTOD(aItens[nX,2])) + "' " 
            cQuery += " AND D_E_L_E_T_ = ' ' " 
            cQuery += " AND Z08_MSBLQL != '1' " 
            cQuery += " AND Z08_FILIAL = '" + xFilial("Z08") + "' " 

            if Select("TRB") > 0
                dbSelectArea('TRB')
                dbCloseArea()
            endif
            
            DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

            lErro := .T.
            cMsg  := "A data da leitura na linha " + cValToChar(nX + 1) + " (data: " + aItens[nX,2] + ") � menor do que a data da �ltima leitura (" + TRB->Z08_COD + "), deseja prosseguir assim mesmo?"
            if !MsgYesNo(cMsg, "Aten��o!")
                cErro := "A data da leitura na linha " + cValToChar(nX + 1) + " (data: " + aItens[nX,2] + ") � menor do que a data da �ltima leitura (" + TRB->Z08_COD + ")"
                EXIT    
            endif
            lErro := .F.
        endif

        if TRB->DATA1 == DTOS(CTOD(aItens[nX,2]))

            cQuery := " "
            cQuery += " SELECT Z08_COD " 
            cQuery += " FROM   " + RetSQLName("Z08") + " " 
            cQuery += " WHERE  Z08_NUMSER = '" + aItens[nX,1] + "' " 
            cQuery += " AND Z08_SELECA = '" + aItens[nX,3] + "' " 
            cQuery += " AND Z08_DATA = '" + DTOS(CTOD(aItens[nX,2])) + "' " 
            cQuery += " AND D_E_L_E_T_ = ' ' " 
            cQuery += " AND Z08_MSBLQL != '1' " 
            cQuery += " AND Z08_FILIAL = '" + xFilial("Z08") + "' " 

            if Select("TRB") > 0
                dbSelectArea('TRB')
                dbCloseArea()
            endif
            
            DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

            lErro := .T.
            cMsg  := "A data da leitura na linha " + cValToChar(nX + 1) + " (data: " + aItens[nX,2] + ") � igual a data da �ltima leitura (" + TRB->Z08_COD + "), deseja prosseguir assim mesmo?"
            if !MsgYesNo(cMsg, "Aten��o!")
                cErro := "A data da leitura na linha " + cValToChar(nX + 1) + " (data: " + aItens[nX,2] + ") � igual a data da �ltima leitura (" + TRB->Z08_COD + ")"
                EXIT    
            endif
            lErro := .F.
        endif

        //SELECT Z07_CODPRO,Z07_CLIENT,Z07_LOJA,Z07_CODMAQ FROM Z07010 WHERE Z07_CHAPA = '0669' AND Z07_SELECA = '01'
        //SELECT AAM_CONTRT,AAN_ITEM,AAM_CODCLI,AAM_LOJA FROM AAM010 IINER JOIN AAN010 ON AAN_CONTRT = AAM_CONTRT WHERE AAN_XCBASE = '0669'    
    
        cQuery := " "
        cQuery += " SELECT Z07_CODPRO,Z07_CLIENT,Z07_LOJA,Z07_CODMAQ,AAM_CONTRT,AAN_ITEM,AAM_CODCLI,AAM_LOJA "
        cQuery += " FROM " + RetSQLName("AAM") + " AAM "
        cQuery += " INNER JOIN " + RetSQLName("AAN") + " AAN "
        cQuery += " ON AAN_CONTRT = AAM_CONTRT "
        cQuery += " AND AAN_XCBASE = '" + aItens[nX,1] + "' "
        cQuery += " AND AAN_FILIAL = AAM_FILIAL "
        cQuery += " INNER JOIN " + RetSQLName("Z07") + " Z07 "
        cQuery += " ON Z07_CHAPA = AAN_XCBASE "
        cQuery += " AND Z07_SELECA = '" + aItens[nX,3] + "' "
        cQuery += " WHERE AAM.D_E_L_E_T_ = ' ' "
        cQuery += " AND AAN.D_E_L_E_T_ = ' ' "
        cQuery += " AND Z07.D_E_L_E_T_ = ' ' "
        cQuery += " AND Z07_FILIAL = '"+xFilial("Z07")+"' "
        cQuery += " AND AAM_FILIAL = '"+xFilial("AAM")+"' "

        if Select("TRB") > 0
            dbSelectArea('TRB')
            dbCloseArea()
        endif
        
        DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

        Aadd(aAux, {aItens[nX,1],;
                    aItens[nX,2],;
                    aItens[nX,3],;
                    aItens[nX,4],;
                    AllTrim(TRB->Z07_CODPRO),;
                    AllTrim(TRB->AAM_CONTRT),;
                    AllTrim(TRB->AAN_ITEM),;
                    AllTrim(TRB->Z07_CODMAQ),;
                    AllTrim(TRB->Z07_CLIENT),;
                    AllTrim(TRB->Z07_LOJA),;
                    AllTrim(TRB->AAM_CODCLI),;
                    AllTrim(TRB->AAM_LOJA)})

    next

    if lErro
        fwrite(nHandle3, "----------" + CRLF)
        fwrite(nHandle3, "Erro ao importar leituras manuais (Z08Tela.PRW) " + Time() + " Usuario: " + cUsername + CRLF)
        fwrite(nHandle3, cErro + CRLF)
        fwrite(nHandle3, "----------" + CRLF)
        FCLOSE(nHandle3)
        ShellExecute("open", cArqT, "00\", "C:\", 1)
        RETURN
    else
        FCLOSE(nHandle3)
    endif

    cAux := aAux[1,1]
    Aadd(aAux2, {})

    for nX := 1 to len(aAux)
        if aAux[nX,1] == cAux
            Aadd(aAux2[len(aAux2)], aAux[nX])
        else
            Aadd(aAux2, {})
            Aadd(aAux2[len(aAux2)], aAux[nX])
        endif
        cAux := aAux[nX,1]
    next

    for nX := 1 to len(aAux2)

        oDlg1      := MSDialog():New( 050,100,600,1000,"Importacao de Leituras",,,.F.,,,,,,.T.,,,.T. )
            
        oGrp1      := TGroup():New( 05,05,225,450,"Leituras",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
        
            //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{124,048,304,352},,, oGrp3 ) 
            oList1            := TCBrowse():New(15,15,425,200,, {'Numero de Serie','Data','Selecao','Qtd Lida','Cod Produto','Cod Contrato','Item Contrato','Cod Maquina','Cod Cliente','Loja CLiente','Cod Cliente Pag','Loja Cliente Pag'},,oGrp1,,,,,,, ,,,  ,,.F.,,.T.,,.F.,,,)
            
            oList1:SetArray(aAux2[nX])
            oList1:bLine := {||{aAux2[nX,oList1:nAt,01],; 
                                aAux2[nX,oList1:nAt,02],;
                                aAux2[nX,oList1:nAt,03],; 
                                aAux2[nX,oList1:nAt,04],;
                                aAux2[nX,oList1:nAt,05],;
                                aAux2[nX,oList1:nAt,06],;
                                aAux2[nX,oList1:nAt,07],;
                                aAux2[nX,oList1:nAt,08],;
                                aAux2[nX,oList1:nAt,09],;
                                aAux2[nX,oList1:nAt,10],;
                                aAux2[nX,oList1:nAt,11],;
                                aAux2[nX,oList1:nAt,12]}} 

            oBtn1      := TButton():New( 250,200,"Salvar Leitura",oDlg1,{|| oDlg1:end(nOpc:=1)},037,012,,,,.T.,,"",,,,.F. )
            oBtn2      := TButton():New( 250,250,"Cancelar",oDlg1,{|| oDlg1:end(nOpc:=0)},037,012,,,,.T.,,"",,,,.F. )

        oDlg1:Activate(,,,.T.)

        if nOpc == 1
            Z08SALVA(aAux2[nX])
        endif

    next

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
            Z08->Z08_PRODUT    := aItens[nX,5] //C
            Z08->Z08_CONTRT    := aItens[nX,6] //C
            Z08->Z08_ITEM      := aItens[nX,7] //C
            Z08->Z08_QTDLID    := val(aItens[nX,4]) //N *
            // Z08->Z08_VLRLID    := val(aItens[nX,8]) //N
            Z08->Z08_DTDIGI    := dDataBase    //D
            Z08->Z08_PERIOD    := cvaltochar(month(ctod(aItens[nX,2]))) + SubStr(cvaltochar(year(ctod(aItens[nX,2]))), 3, 2) //C
            Z08->Z08_MAQUIN    := aItens[nX,8]  //C
            Z08->Z08_CODCLI    := aItens[nX,9] //C
            Z08->Z08_LOJACL    := aItens[nX,10] //C
            Z08->Z08_CLIPAG    := aItens[nX,11] //C
            Z08->Z08_MSBLQL    := "2" //C
        MsUnlock()

        cSeq := Soma1(cSeq)

    next

    Confirmsx8()

Return 
