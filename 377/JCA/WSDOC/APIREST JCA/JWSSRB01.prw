#INCLUDE "Protheus.ch"
#INCLUDE "RESTFUL.CH"
#Include "rwmake.ch"
#Include "tbiconn.ch"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"


WSRESTFUL JWSSRB01 DESCRIPTION "Metodo GET e POST de dependentes do módulo RH"
    WSMETHOD GET DESCRIPTION "RETORNA TABELA SRB " WSSYNTAX "/JWSSRB01/{EMPRESA/MATRICULA}"
    WSMETHOD POST DESCRIPTION 'Atualiza SRA' WSSYNTAX '/JWSSRB01'
ENDWSRESTFUL

WSMETHOD GET WSSERVICE JWSSRB01
    LOCAL cQuery := ""
    LOCAL lRet := .T.
    LOCAL nLinha := 0
    LOCAL lFilok := .F.
    LOCAL oResponse     := JsonObject():New()
    LOCAL oCampo     := JsonObject():New()

    RpcClearEnv()
    RpcSetType(3)
    RPCSetEnv('01','00020087')

    ::SetContentType("application/json")

    IF !MyOpenSM0()
        lRet:= .F.
        oResponse['code'] := 1
        oResponse['status'] := 500
        oResponse['message'] := 'Falha ao abrir ambiente de trabalho!'
        oResponse['detailedMessage'] := ''
    ENDIF

    IF LEN(self:aURLParms) > 0
        MyOpenSM0()
        SM0->( DBGOTOP() )
        WHILE !SM0->( EOF() ) .and. !lFilok
            // IF padl(::aURLParms[1],2,"0") == ALLTRIM(SM0->M0_CODFIL)
            IF padl(::aURLParms[1],8,"0") == ALLTRIM(SM0->M0_CODFIL)
                cFilant := ALLTRIM(SM0->M0_CODFIL)
                lFilok := .T.
            ENDIF
            SM0->( DBSKIP() )
        ENDDO
        //
        IF !lFilok
            lRet := .F.
            oResponse['code'] := 2
            oResponse['status'] := 404
            oResponse['message'] := 'Confira a filial digitada.'
            oResponse['detailedMessage'] := ''
        ENDIF
    ENDIF

    IF lRet

        DBSELECTAREA("SRB")
        //CONSULTO SRB PELA EMPRESA E MATRICULA
        IF LEN(self:aURLParms) == 1
            cSeek := ::aURLParms[1]

            cQuery := "SELECT RB_FILIAL, RB_MAT,RB_COD,RB_NOME,RB_DTNASC,RB_TPDEP,RB_SEXO,RB_CIC, RB_TIPIR, RB_TIPSF, RB_INCT, RB_GRAUPAR, RB_MAE "
            cQuery += "FROM "+ RetSQLName('SRB')+" RB "
            cQuery += "WHERE RB_FILIAL ='" +xFilial('SRB')+"' AND RB.D_E_L_E_T_=''"

            IF Select("TMP")<>0
                DbSelectArea("TMP")
                DbCloseArea()
            ENDIF

            cQuery := ChangeQuery(cQuery)
            DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),'TMP',.F.,.T.	)

            dbSelectArea("TMP")
            TMP->(dbGoTop())
            oCampo['DADOS']   := {}
            nLinha := 0

            WHILE TMP->(!EOF())
                IF TMP->RB_FILIAL == cSeek
                    nLinha += 1

                    AADD( oCampo['DADOS'], JsonObject():New() )

                    oCampo['DADOS'][nLinha]["RB_FILIAL"]    :=  TMP->RB_FILIAL
                    oCampo['DADOS'][nLinha]["RB_MAT"]       :=  TMP->RB_MAT
                    oCampo['DADOS'][nLinha]["RB_COD"]       :=  TMP->RB_COD
                    oCampo['DADOS'][nLinha]["RB_NOME"]      :=  EncodeUTF8(TMP->RB_NOME,"cp1252")
                    oCampo['DADOS'][nLinha]["RB_DTNASC"]    :=  TMP->RB_DTNASC
                    oCampo['DADOS'][nLinha]["RB_TPDEP"]     :=  TMP->RB_TPDEP
                    oCampo['DADOS'][nLinha]["RB_SEXO"]      :=  TMP->RB_SEXO
                    oCampo['DADOS'][nLinha]["RB_CIC"]       :=  TMP->RB_CIC
                    oCampo['DADOS'][nLinha]["RB_TIPIR"]    :=  TMP->RB_TIPIR
                    oCampo['DADOS'][nLinha]["RB_TIPSF"]       :=  TMP->RB_TIPSF
                    oCampo['DADOS'][nLinha]["RB_MAE"]      :=  EncodeUTF8(TMP->RB_MAE,"cp1252")
                    oCampo['DADOS'][nLinha]["RB_INCT"]    :=  TMP->RB_INCT
                    oCampo['DADOS'][nLinha]["RB_GRAUPAR"]     :=  TMP->RB_GRAUPAR

                ENDIF
                TMP->( DBSKIP() )
            ENDDO
            dbSelectArea("TMP")
            dbCloseArea()
            IF nLinha > 0
                ::SetResponse(FWJsonSerialize(oCampo, .F., .F., .T.))
            ELSE
                lRet:= .F.
                oResponse['code'] := 2
                oResponse['status'] := 404
                oResponse['message'] := 'Não foi encontrado nenhum registro nessa empresa!'
                oResponse['detailedMessage'] := ''
            ENDIF
        ELSEIF LEN(self:aURLParms) == 2
            cSeek := ::aURLParms[2]

            cQuery := "SELECT RB_FILIAL, RB_MAT,RB_COD,RB_NOME,RB_DTNASC,RB_TPDEP,RB_SEXO,RB_CIC, RB_TIPIR, RB_TIPSF, RB_INCT, RB_GRAUPAR, RB_MAE "
            cQuery += "FROM "+ RetSQLName('SRB')+" RB "
            cQuery += "WHERE RB_FILIAL ='" +xFilial('SRB')+"' AND RB_MAT = '"+ cSeek +"' AND RB.D_E_L_E_T_=''"

            IF Select("TMP")<>0
                DbSelectArea("TMP")
                DbCloseArea()
            ENDIF

            cQuery := ChangeQuery(cQuery)
            DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),'TMP',.F.,.T.	)

            dbSelectArea("TMP")
            TMP->(dbGoTop())
            oCampo['DADOS']   := {}
            nLinha := 0

            WHILE TMP->(!EOF())
                IF TMP->RB_MAT == cSeek
                    nLinha += 1

                    AADD( oCampo['DADOS'], JsonObject():New() )

                    oCampo['DADOS'][nLinha]["RB_FILIAL"]    :=  TMP->RB_FILIAL
                    oCampo['DADOS'][nLinha]["RB_MAT"]       :=  TMP->RB_MAT
                    oCampo['DADOS'][nLinha]["RB_COD"]       :=  TMP->RB_COD
                    oCampo['DADOS'][nLinha]["RB_NOME"]      :=  EncodeUTF8(TMP->RB_NOME,"cp1252")
                    oCampo['DADOS'][nLinha]["RB_DTNASC"]    :=  TMP->RB_DTNASC
                    oCampo['DADOS'][nLinha]["RB_TPDEP"]     :=  TMP->RB_TPDEP
                    oCampo['DADOS'][nLinha]["RB_SEXO"]      :=  TMP->RB_SEXO
                    oCampo['DADOS'][nLinha]["RB_CIC"]       :=  TMP->RB_CIC
                    oCampo['DADOS'][nLinha]["RB_TIPIR"]    :=  TMP->RB_TIPIR
                    oCampo['DADOS'][nLinha]["RB_TIPSF"]       :=  TMP->RB_TIPSF
                    oCampo['DADOS'][nLinha]["RB_MAE"]      :=  EncodeUTF8(TMP->RB_MAE,"cp1252")
                    oCampo['DADOS'][nLinha]["RB_INCT"]    :=  TMP->RB_INCT
                    oCampo['DADOS'][nLinha]["RB_GRAUPAR"]     :=  TMP->RB_GRAUPAR

                ENDIF
                TMP->( DBSKIP() )
            ENDDO
            dbSelectArea("TMP")
            dbCloseArea()
            IF nLinha > 0
                ::SetResponse(FWJsonSerialize(oCampo, .F., .F., .T.))
            ELSE
                lRet:= .F.
                oResponse['code'] := 2
                oResponse['status'] := 404
                oResponse['message'] := 'Não foi encontrado nenhum dependente para essa matricula nessa empresa!'
                oResponse['detailedMessage'] := ''
            ENDIF
        ENDIF
    ENDIF

    IF !lRet
        SetRestFault( oResponse['code'],;
            oResponse['message'],;
            .T.,;
            oResponse['status'],;
            oResponse['detailedMessage'];
            )
    ENDIF

    RpcClearEnv()
RETURN lRet

WsMethod POST WsReceive RECEIVE WsService JWSSRB01

    LOCAL lRet          := .T.
    LOCAL lFilok        := .F.
    LOCAL cTpcpo        := "" //tipo de campo na base
    LOCAL cEmpf         := "" //esmpresa do cadastro
    LOCAL cCampo        := ""
    LOCAL xConteudo     := "" //conteudo
    LOCAL oResponse     := JsonObject():New()
    Local oAusenc
    LOCAL nI := 0
    LOCAL nC := 0
    Local nR := 0

    LOCAL aDepen       := {}
    PRIVATE cCodNv     := ""
    PRIVATE aLog := {}
    PRIVATE nTipo       := 0
    PRIVATE aTSRB       := {}
    PRIVATE cErro       := ""
    PRIVATE aErroRet    := {}
    PRIVATE dStart      := NIL
    PRIVATE cMatric     := "" //matricula
    PRIVATE cTipo       := ""
    PRIVATE dDataTransf
    PRIVATE cOper := ""
    PRIVATE cCodDep := ""

    RpcClearEnv()
    RpcSetType(3)
    //RPCSetEnv('99','01')
    RPCSetEnv('01','00020087')

    Self:SetContentType("application/json")

    oAusenc := JsonObject():New()

    cError := oAusenc:fromJson( self:getContent() )

    IF Empty(cError) .and. valtype(oAusenc["DEPENDENTE"]) == "A" .and.  LEN(self:aURLParms) > 0
        cOper := ::aURLParms[1]

        aDepen:= oAusenc:GetJSonObject('DEPENDENTE')
        For nI := 1 to len(aDepen)
            IF nI == 1
                IF !EMPTY(alltrim(oAusenc["DEPENDENTE"][nI]['EMPRESA'])) .OR. alltrim(oAusenc["DEPENDENTE"][nI]['EMPRESA']) != NIL
                    cEmpf := alltrim(oAusenc["DEPENDENTE"][nI]['EMPRESA'])
                    MyOpenSM0()
                    SM0->( DBGOTOP() )
                    WHILE !SM0->( EOF() ) .AND. !lFilok
                        IF padl(cEmpf,8,"0") == ALLTRIM(SM0->M0_CODFIL)
                            // IF padl(cEmpf,2,"0") == ALLTRIM(SM0->M0_CODFIL)
                            cFilant := ALLTRIM(SM0->M0_CODFIL)
                            cNumEmp := "01"+cFilant
                            lFilok := .T.

                        ENDIF
                        SM0->( DBSKIP() )
                    ENDDO

                    IF !lFilok
                        lRet := .F.
                        oResponse['code'] := 2
                        oResponse['status'] := 404
                        oResponse['message'] := 'Confira a empresa digitada.'
                        oResponse['detailedMessage'] := ''
                    ENDIF
                ELSE
                    lRet := .F.
                    oResponse['code'] := 3
                    oResponse['status'] := 404
                    oResponse['message'] := 'Confira a Empresa foi informada.'
                    oResponse['detailedMessage'] := ''
                ENDIF
            ENDIF
            //valida funcinario na empresa e se nÃ£o estÃ¡ demitido
            IF lRet
                IF !EMPTY(alltrim(oAusenc["DEPENDENTE"][nI]['MATRICULA'])) .OR. alltrim(oAusenc["DEPENDENTE"][nI]['MATRICULA']) != NIL
                    cMatric := alltrim(oAusenc["DEPENDENTE"][nI]['MATRICULA'])
                    cMatric :=  NewCGCCPF(cMatric)
                    IF LEN(cMatric) == 11 //CNPJ
                        cSeek := PADR(STRZERO( VAL(cMatric),11), TAMSX3('RA_CIC') [1]) //RA_FILIAL+RA_CIC 5
                        nInd := 5
                    ELSEIF LEN(ALLTRIM(cMatric)) == 6 //MATRICULA
                        cSeek := PADR(STRZERO( VAL(cMatric),6), TAMSX3('RA_MAT') [1]) //RA_FILIAL+RA_MAT+RA_NOME 1
                        nInd := 1
                    ELSE
                        lRet := .F.
                        oResponse['code'] := 3
                        oResponse['status'] := 404
                        oResponse['message'] := 'Parametro nÃ£o tem a quantidade de caracteres esperada. Matricula com 6 ou CPF com 11.'
                        oResponse['detailedMessage'] := ''
                    ENDIF
                ELSE
                    lRet := .F.
                    oResponse['code'] := 4
                    oResponse['status'] := 404
                    oResponse['message'] := 'Matricula nÃ£o foi informada'
                    oResponse['detailedMessage'] := ''
                ENDIF
            ENDIF

            IF lRet
                SRA->( DBSETORDER(nInd) )//::aURLParms[2]
                IF SRA->( DBSEEK( xFilial('SRA') + cSeek ) )
                    IF !SRA->RA_SITFOLH == 'D' //.AND. !SRA->RA_SITFOLH == 'F'
                        IF valtype(oAusenc["DEPENDENTE"][nI]['CAMPOS']) == "A"
                            //procura campo na SRA, pega tipo de campo.
                            nC := 0
                            For nC := 1 to len(oAusenc["DEPENDENTE"][nI]['CAMPOS'])
                                cCampo := ALLTRIM(oAusenc["DEPENDENTE"][1]['CAMPOS'][nC]["CAMPO"])
                                xConteudo := ALLTRIM(oAusenc["DEPENDENTE"][1]['CAMPOS'][nC]["CONTEUDO"])
                                CAMPO := ""

                                SX3->( DBSETORDER(1) )
                                SX3->( DBSEEK( 'SRB' ) )
                                WHILE !SX3->( EOF() ) .AND. SX3->X3_ARQUIVO == 'SRB' .AND. EMPTY(CAMPO)
                                    //valida tipo de campo e conteudo informado
                                    aAux := {}
                                    IF X3USO( SX3->X3_USADO) .AND. SX3->X3_CONTEXT != 'V' //.OR. ALLTRIM(SX3->X3_CAMPO) == "RA_FILIAL"
                                        IF alltrim(cCampo) ==  ALLTRIM(SX3->X3_CAMPO)
                                            CAMPO := ALLTRIM( SX3->X3_CAMPO)

                                            IF CAMPO == "RB_COD" .AND. (cOper == "2" .OR. cOper == "3")
                                                cCodDep := xConteudo
                                            ENDIF

                                            //CONVERTER PARA CARACTER
                                            cTpcpo := SX3->X3_TIPO
                                            IF cTpcpo == 'N'
                                                xConteudo := Val(StrTran(strtran(xConteudo,"."),",","."))
                                            ELSEIF cTpcpo == 'D'
                                                xConteudo := CTOD(xConteudo)
                                            ENDIF

                                            aAux := {CAMPO,xConteudo}
                                            aadd(aTSRB,aAux)
                                        ENDIF
                                    ENDIF
                                    SX3->( DBSKIP() )
                                ENDDO
                            NEXT nC

                            IF cOper $ "'2'/'3'" .AND. EMPTY(cCodDep)
                                lRet := .F.
                                oResponse['code'] := 8
                                oResponse['status'] := 404
                                oResponse['message'] := 'Para opecoes de alterarção ou exclusão, o código do dependente deve ser informado.'
                                oResponse['detailedMessage'] := ''
                            ENDIF

                            IF lRet

                                IF MYDEPEND()
                                    oResponse['data']   := {}
                                    AADD( oResponse['data'], JsonObject():New() )
                                    IF cOper == "1"
                                        oResponse['data'][1]["status"] := "INCLUIDO"
                                        oResponse['data'][1]["codigo"] := cCodNv
                                    ELSEIF cOper == "2"
                                        oResponse['data'][1]["status"] := "ALTERADO"
                                    ELSEIF cOper == "3"
                                        oResponse['data'][1]["status"] := "EXCLUIDO"
                                    ENDIF

                                    nR := 0
                                    FOR nR := 1 to len(aTSRB)

                                        oResponse['data'][1][aTSRB[nR,1]] := aTSRB[nR,2]

                                    NEXT nR
                                    ::SetResponse(FWJsonSerialize(oResponse, .F., .F., .T.))
                                ELSE
                                    lRet := .F.
                                    oResponse['code'] := 15
                                    oResponse['status'] := 404
                                    oResponse['message'] := cErro
                                    oResponse['detailedMessage'] := ''
                                ENDIF
                            ENDIF
                        ENDIF
                        //ENDIF
                    ELSE
                        lRet := .F.
                        oResponse['code'] := 7
                        oResponse['status'] := 404
                        oResponse['message'] := 'Funcionario demitido.'
                        oResponse['detailedMessage'] := ''
                    ENDIF
                ELSE
                    lRet := .F.
                    oResponse['code'] := 5
                    oResponse['status'] := 404
                    oResponse['message'] := 'Matricula nÃ£o encontrada'
                    oResponse['detailedMessage'] := ''
                ENDIF
            ENDIF
        NEXT nC
        //ENDIF
    ELSE
        lRet := .F.
        oResponse['code'] := 4
        oResponse['status'] := 404
        oResponse['message'] := 'Use incorreto do serviÃ§o.'
        oResponse['detailedMessage'] := ''
    ENDIF

    IF !lRet
        SetRestFault( oResponse['code'],;
            oResponse['message'],;
            .T.,;
            oResponse['status'],;
            oResponse['detailedMessage'];
            )
    ENDIF

    RpcClearEnv()

RETURN lRet

STATIC FUNCTION MyOpenSM0()
    LOCAL lOpen := .F.
    LOCAL i := 0

    IF !EMPTY(  SELECT('SM0'))
        lOpen := .T.
    ELSE

        FOR i := 1 TO 20
            dbUseArea(  .T., , 'SIGAMAT.EMP',   'SMO',  .T.,    .F.)
            IF !EMPTY(  SELECT('SM0'))
                lOpen := .T.
                dbSetIndex('SIGAMAT.IND')
                EXIT
            ENDIF
            Sleep(500)
        NEXT
    ENDIF
RETURN lOpen

STATIC Function MYDEPEND()

    Local oModel
    Local oMdlSRB
    local lOk := .T.
    Local nCod := 0
    Local n := 0
    Local aSeek := {}
    //PRIVATE lAutomato := .T.

    aEval({'SRA','SRB'},{|x|CHKFILE(x)})
    SRA->(DbSetOrder(1))

    IF SRA->(DbSeek(xFilial("SRA") + cMatric))
        ConOut("ACHOU MATRICULA!")
        IF cOper $ "'1','2'"
            oModel := FWLoadModel("GPEA020")
            oModel:SetOperation(MODEL_OPERATION_UPDATE)
        ELSE
            ConOut("ENTROU NA EXCLUSAO")
            oModel := FWLoadModel("GPEA020")
            oModel:SetOperation(MODEL_OPERATION_UPDATE)
        ENDIF
        /*
        oModel := FWLoadModel("GPEA020")
        oModel:SetOperation(MODEL_OPERATION_UPDATE)*/

        IF (oModel:Activate())

            IF cOper $ "'2'/'3'"
                dbSelectArea("SRB")
                dbSetOrder(1)
                IF !SRB->(DbSeek(xFilial("SRB") + cMatric + cCodDep))
                    lOk := .F.
                    ConOut("DEPENDENTE Nao encontrado")
                    cErro := "DEPENDENTE Nao encontrado"
                ELSE
                    lOk := .T.
                    ConOut("DEPENDENTE encontrado")
                ENDIF
            ENDIF
            oMdlSRB := oModel:GetModel("GPEA020_SRB") //instanciamento do modelo

            IF cOper == "1" //Exemplo Inclusão de novo registro
                IF(oMdlSRB:Length() > 1)
                    nCod := oMdlSRB:AddLine()
                ELSE
                    IF(oMdlSRB:IsInserted())
                        nCod := 1
                    ELSE
                        nCod := oMdlSRB:AddLine()
                    ENDIF
                ENDIF

                oMdlSRB:SetValue("RB_COD" , StrZero(nCod,2))
                cCodNv := StrZero(nCod,2)
                n := 0
                FOR n := 1 TO LEN(aTSRB)
                    oMdlSRB:SetValue(   aTSRB[n,1]  ,  aTSRB[n,2]      )
                NEXT n

            ELSEIF cOper $ "'2'/'3'" .AND. lOk  //Exemplo alteração de registro existente
                ConOut("ENTROU NO PROCESSO 2 OU 3")
                //RB_FILIAL+RB_MAT+RB_COD
                aSeek := {}// RHM_FILIAL+RHM_MAT+RHM_TPFORN+RHM_CODFOR+RHM_CODIGO
                aAdd(aSeek,{"RB_FILIAL" ,xFilial("SRB")})
                aAdd(aSeek,{"RB_MAT"        ,    cMatric })
                aAdd(aSeek,{"RB_COD"    ,cCodDep})

                oMdlSRB:GoLine(1)
                IF oMdlSRB:SeekLine(aSeek) .And. !oMdlSRB:IsDeleted()
                    ConOut("ACHOU O DEPENDENTE E POSICIONOU")
                    //Campos a serem alterados
                    IF cOper == "2"
                        n := 0
                        FOR n := 1 TO LEN(aTSRB)
                            oMdlSRB:SetValue(   aTSRB[n,1]  ,  aTSRB[n,2]      )
                        NEXT n

                    ELSE
                        oMdlSRB:DeleteLine()
                    ENDIF
                ENDIF
                //Possibilita uso do método DeleteLine() para exclusão do registro posicionado
            ENDIF
        ENDIF

        IF lOK
            IF(oModel:VldData())
                IF (oModel:CommitData())
                    IF cOper== '1'
                        ConOut("Dependente Incluido")
                    ELSEIF cOper == '2'
                        ConOut("Alteracao concluida")
                    ELSE
                        ConOut("EXCLUSAO concluida")
                    ENDIF
                    lOk := .T.
                ELSE
                    aLog := oModel:GetErrorMessage()
                    lOk := .F.
                ENDIF
            ELSE
                ConOut("não validou comit")
                aLog := oModel:GetErrorMessage()
                lOk := .F.
            ENDIF

            IF Len(aLog) > 0 .AND. !lOK
                n := 0
                For n :=1 To Len(aLog)
                    IF aLog[n] != NIL
                        cErro += EncodeUTF8(aLog[n],"cp1252")
                    ENDIF
                Next n

                IF EMPTY(cErro)
                    cErro := EncodeUTF8("Erro não identificado nos retornos padrões do Protheus.","cp1252")
                ENDIF

                aEval(aLog, {|x|conOut(x)})
            ENDIF
        ENDIF

    ELSE
        ConOut("Funcionario nao encontrado")
        cErro := "Funcionario nao encontrado"
        lOk := .F.
    ENDIF
Return  lOk

//----------------------------------------------------------
// Funcao Auxiliar para retirar a máscara do campo CNPJ/CPF:
//----------------------------------------------------------
Static Function NewCGCCPF(cCGCCPF)

    LOCAL aInvChar := {"/",".","-"}
    LOCAL nI

    For nI:=1 to Len(aInvChar)
        cCGCCPF := StrTran(cCGCCPF,aInvChar[nI])
    Next

Return cCGCCPF
