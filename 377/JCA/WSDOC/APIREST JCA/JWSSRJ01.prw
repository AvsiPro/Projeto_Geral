#INCLUDE "Protheus.ch"
#INCLUDE "RESTFUL.ch"
#Include "rwmake.ch"
#Include "tbiconn.ch"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

//ws para pesquisa de funcionário especifico informando empresa e matricula/cpf
//AGUARDANDO CHAMADO TOTVS PARA FAZER ALTERAÇÃO DE USUARIO

WSRESTFUL JWSSRJ01 DESCRIPTION "EVENTO para manutneção e pesquisa de Funcoes" //GPEA030
    WSMETHOD GET DESCRIPTION "RETORNA TABELA SRJ " WSSYNTAX "/JWSSRJ01/{EMPRESA/COD_FUNCAO}"
    WSMETHOD POST DESCRIPTION "Incluir Funcoes SRJ"               WSSYNTAX "/JWSSRJ01/{1 inclui}" //GPEA133

ENDWSRESTFUL

WSMETHOD GET WSSERVICE JWSSRJ01

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
            IF padl(::aURLParms[1],8,"0") == ALLTRIM(SM0->M0_CODFIL)
                //  IF padl(::aURLParms[1],2,"0") == ALLTRIM(SM0->M0_CODFIL)
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

        DBSELECTAREA("SRJ")
        //CONSULTO SRB PELA EMPRESA E MATRICULA
        IF LEN(self:aURLParms) == 1
            cSeek := ALLTRIM(::aURLParms[1])

            cQuery := "SELECT RJ_FILIAL, RJ_FUNCAO, RJ_DESC, RJ_CODCBO, RJ_MSBLQL"
            cQuery += "FROM "+ RetSQLName('SRJ')+" RJ "
            cQuery += "WHERE RJ_FILIAL ='" +xFilial('SRJ')+"' AND RJ.D_E_L_E_T_=''"

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
                IF ALLTRIM(TMP->RJ_FILIAL) == SUBSTR(cSeek,1,4)
                    nLinha += 1

                    AADD( oCampo['DADOS'], JsonObject():New() )

                    oCampo['DADOS'][nLinha]["RJ_FILIAL"]        :=  TMP->RJ_FILIAL
                    oCampo['DADOS'][nLinha]["RJ_FUNCAO"]        :=  TMP->RJ_FUNCAO
                    oCampo['DADOS'][nLinha]["RJ_DESC"]          :=  EncodeUTF8(TMP->RJ_DESC,"cp1252")
                    oCampo['DADOS'][nLinha]["RJ_CODCBO"]        := TMP->RJ_CODCBO
                    oCampo['DADOS'][nLinha]["RJ_MSBLQL"]        :=  TMP->RJ_MSBLQL

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
                oResponse['message'] := 'NAo foi encontrado nenhum registro nessa empresa!'
                oResponse['detailedMessage'] := ''
            ENDIF

        ELSEIF LEN(self:aURLParms) == 2
            cSeek := ALLTRIM(::aURLParms[2])
            DBSELECTAREA("SRJ")
            SRJ->( DBSETORDER(1) )//::aURLParms[2]
            IF SRJ->( DBSEEK( xFilial('SRJ') + PADR(cSeek,5) ) )
                oCampo['DADOS']   := {}
                AADD( oCampo['DADOS'], JsonObject():New() )

                oCampo['DADOS'][1]["RJ_FILIAL"]         :=  SRJ->RJ_FILIAL
                oCampo['DADOS'][1]["RJ_FUNCAO"]         :=  SRJ->RJ_FUNCAO
                oCampo['DADOS'][1]["RJ_DESC"]           :=  EncodeUTF8(SRJ->RJ_DESC,"cp1252")
                oCampo['DADOS'][1]["RJ_CODCBO"]         := SRJ->RJ_CODCBO
                oCampo['DADOS'][1]["RJ_MSBLQL"]         :=  SRJ->RJ_MSBLQL

                ::SetResponse(FWJsonSerialize(oCampo, .F., .F., .T.))
            ELSE
                lRet:= .F.
                oResponse['code'] := 3
                oResponse['status'] := 404
                oResponse['message'] := 'Não foi encontrado nenhum registro com esse codigo :'+cSeek
                oResponse['detailedMessage'] := ''
            ENDIF
        ELSE
            lRet:= .F.
            oResponse['code'] := 2
            oResponse['status'] := 404
            oResponse['message'] := ''
            oResponse['detailedMessage'] := 'informe somente empresa ou empresa e codigo da funcao'
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


WsMethod POST WsReceive RECEIVE WsService JWSSRJ01

    LOCAL lRet := .T.
    LOCAL lFilok := .F.
    LOCAL xConteudo := "" //conteudo
    LOCAL oResponse     := JsonObject():New()
    LOCAL oFunc
    LOCAL n  := 0
    LOCAL nI := 0
    LOCAL nC := 0
    LOCAL nR := 0
    LOCAL cTpcpo := "" //tipo de campo
    LOCAL cCampo := ""
    LOCAL aFunc := {}
    PRIVATE cOperacao :=   "" //ALTERAR
    PRIVATE aSrj := {}
    PRIVATE cErro := ""
    PRIVATE aErroRet := {}
    PRIVATE cEmpf := "" //esmpresa do cadastro
    PRIVATE cCodFunc := "" //CODIDO FA FUNÇÃO

    RpcClearEnv()
    RpcSetType(3)
    //    RPCSetEnv('99','01')
    RPCSetEnv('01','00020087')

    Self:SetContentType("application/json")

    oFunc := JsonObject():New()

    cError := oFunc:fromJson( self:getContent() )
    lOk := .F.

    If Empty(cError) .and. valtype(oFunc["FUNCAO"]) == "A" .and.  LEN(self:aURLParms) > 0
        cOperacao :=   ALLTRIM(::aURLParms[1]) //== "1" //INCLUIR
        If valtype(oFunc["FUNCAO"]) == "A"
            aFunc:= oFunc:GetJSonObject('FUNCAO')
            For nI := 1 to len(aFunc)
                IF nI == 1
                    IF !EMPTY(alltrim(oFunc["FUNCAO"][nI]["EMPRESA"])) .OR. alltrim(oFunc["FUNCAO"][nI]['EMPRESA']) != NIL
                        cEmpf := alltrim(oFunc["FUNCAO"][nI]["EMPRESA"])
                        MyOpenSM0()
                        SM0->( DBGOTOP() )
                        WHILE !SM0->( EOF() ) .AND. !lFilok
                            IF padl(cEmpf,8,"0") == ALLTRIM(SM0->M0_CODFIL)
                                //IF padl(cEmpf,2,"0") == ALLTRIM(SM0->M0_CODFIL)
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
                        oResponse['message'] := 'Confira se a Empresa foi informada.'
                        oResponse['detailedMessage'] := ''
                    ENDIF
                ENDIF
                //valida funcinario na empresa e se não está demitido
                IF lRet
                    IF !EMPTY(alltrim(oFunc["FUNCAO"][nI]['COD_FUNCAO'])) .OR. alltrim(oFunc["FUNCAO"][nI]['COD_FUNCAO']) != NIL
                        cCodFunc := alltrim(oFunc["FUNCAO"][nI]['COD_FUNCAO'])
                    ELSE
                        lRet := .F.
                        oResponse['code'] := 3
                        oResponse['status'] := 404
                        oResponse['message'] := 'Informe o codigo da funcao.'
                        oResponse['detailedMessage'] := ''
                    ENDIF
                ENDIF

                IF lRet
                    IF cOperacao == "1"
                        IF valtype(oFunc["FUNCAO"][nI]['CAMPOS']) == "A"
                            //procura campo na SRA, pega tipo de campo.
                            nC := 0
                            For nC := 1 to len(oFunc["FUNCAO"][nI]['CAMPOS'])
                                cCampo := ALLTRIM(oFunc["FUNCAO"][1]['CAMPOS'][nC]["CAMPO"])
                                xConteudo := ALLTRIM(oFunc["FUNCAO"][1]['CAMPOS'][nC]["CONTEUDO"])
                                CAMPO := ""

                                SX3->( DBSETORDER(1) )
                                SX3->( DBSEEK( 'SRJ' ) )
                                WHILE !SX3->( EOF() ) .AND. SX3->X3_ARQUIVO == 'SRJ' .AND. EMPTY(CAMPO)
                                    //valida tipo de campo e conteudo informado
                                    aAux := {}
                                    IF X3USO( SX3->X3_USADO) .AND. SX3->X3_CONTEXT != 'V' .or.  ALLTRIM(SX3->X3_CAMPO) == "RJ_MEMOREQ"
                                        IF alltrim(cCampo) ==  ALLTRIM(SX3->X3_CAMPO)
                                            CAMPO := ALLTRIM( SX3->X3_CAMPO)

                                            //CONVERTER PARA CARACTER
                                            cTpcpo := SX3->X3_TIPO
                                            IF cTpcpo == 'N'
                                                xConteudo := Val(StrTran(strtran(xConteudo,"."),",","."))
                                            ELSEIF cTpcpo == 'D'
                                                xConteudo := CTOD(xConteudo)
                                            ENDIF

                                            IF CAMPO == "RJ_MEMOREQ"
                                                xConteudo := SUBSTR(xConteudo,1,999)                                                                   "
                                            ENDIF

                                            IF CAMPO == "RJ_DESC"
                                                xConteudo := SUBSTR(xConteudo,1,20)
                                            ENDIF

                                            aAux := {CAMPO,xConteudo}
                                            aadd(aSrj,aAux)
                                        ENDIF
                                    ENDIF
                                    SX3->( DBSKIP() )
                                ENDDO
                            NEXT nC
                        ENDIF
                    ENDIF

                    IF MYFUNSR8()
                        oResponse['data']   := {}
                        AADD( oResponse['data'], JsonObject():New() )

                        oResponse['data'][1]['satus'] := "Registro atualizado com sucesso,cod funcao " + cCodFunc

                        nR := 0
                        FOR nR := 1 to len(aSrj)

                            oResponse['data'][1][aSrj[nR,1]] := aSrj[nR,2]

                        NEXT nR

                        ConOut("retornou ok")
                        ::SetResponse(FWJsonSerialize(oResponse, .F., .F., .T.))
                    ELSE
                        IF LEN(aErroRet) > 0

                            lRet := .F.
                            oResponse['code'] := 15
                            oResponse['status'] := 404

                            n := 0
                            FOR n := 1 to len(aErroRet)
                                IF n == 1
                                    cErro := aErroRet[n] + CHR(13)+CHR(10)
                                ENDIF
                                cErro +=  IF(!aErroRet[n] == NIL,aErroRet[n]+ CHR(13)+CHR(10),"")
                            NEXT n

                            oResponse['message'] := EncodeUTF8(cErro,"cp1252")
                            oResponse['detailedMessage'] := ''

                        ELSE
                            lRet := .F.
                            oResponse['code'] := 8
                            oResponse['status'] := 404
                            oResponse['message'] := 'Informe o codigo do FUNCAO COD_FUNCAO'
                            oResponse['detailedMessage'] := ''
                        ENDIF
                    ENDIF
                ENDIF
            NEXT nC
        ENDIF
    ENDIF

    If !lRet
        SetRestFault( oResponse['code'],;
            oResponse['message'],;
            .T.,;
            oResponse['status'],;
            oResponse['detailedMessage'];
            )
    EndIf

    RpcClearEnv()

RETURN lRet


STATIC FUNCTION MYFUNSR8()

    LOCAL aArea    := GetArea()
    LOCAL oModel
    LOCAL oMdlMdl
    LOCAL n := 0
    local aError := {}
    // LOCAL cFuncao := "12536"
    LOCAL lSra := .T.
    PRIVATE lMsErroAuto := .F.
    PRIVATE lAutoErrNoFile := .T.
    PRIVATE lMsHelpAuto :=.T.
    PRIVATE lAuyomato := .T.

    CONOUT("Inicio: "+TIME())
    oModel := FWLoadModel("GPEA030")
    oModel:SetOperation(MODEL_OPERATION_INSERT)
    oModel:Activate()
    oMdlMdl := oModel:GetModel("GPEA030_SRJ") //instanciamento do modelo

    dbSelectArea("SRJ")
    dbSetOrder(1) //RJ_FILIAL+RJ_FUNCAO
    If !SRJ->(DbSeek(PADR(SUBSTR(CFILANT,1,4),8) + PADR(cCodFunc,5) )) //M7_FILIAL+M7_MAT+M7_TPVALE+M7_CODIGO
        /*  if !oMdlMdl:SetValue("RJ_FILIAL", PADR(SUBSTR(CFILANT,1,4),8) )
            aError := oModel:GetErrorMessage()

            ConOut(aError[MODEL_MSGERR_IDFORM])
            ConOut(aError[MODEL_MSGERR_IDFIELD])
            ConOut(aError[MODEL_MSGERR_IDFORMERR])
            ConOut(aError[MODEL_MSGERR_IDFIELDERR])
            ConOut(aError[MODEL_MSGERR_ID])
            ConOut(aError[MODEL_MSGERR_MESSAGE])
            ConOut(aError[MODEL_MSGERR_SOLUCTION])
        endif*/

        //        oMdlMdl:LoadValue("RJ_FILIAL", PADR(SUBSTR(CFILANT,1,4),8) )
        oMdlMdl:SetValue("RJ_FUNCAO", cCodFunc )    //-- Código
        n := 0
        FOR n := 1 TO LEN(aSrj)
            oMdlMdl:SetValue(   aSrj[n,1]  ,  aSrj[n,2]      )
        NEXT n
        //  SA1->A1_OBS := MSMM(Olist:AARRAY[nAtu][9],,,dtoc(Date()) + ": " + ALLTRIM(Olist:AARRAY[nAtu][8]) +" ",1,40,.F.,'SA1','A1_OBS',,.f.)
        //   FWMemoVirtual( oStructSRJ,{ {'RJ_DESCREQ','RJ_MEMOREQ', "RDY"} } )
        //If(INCLUI,"",MSMM(SRJ->RJ_DESCREQ,80,,,,,,,,"RDY"))
    ELSE
        aErroRet := {"Codigo da funcao ja existe",cCodFunc}
        lSra := .F.
    ENDIF

    IF lSra
        IF oModel:VldData()
            oModel:CommitData()
            lSra := .T.
            ConOut("ok")
            /*   DbSelectArea("SB1")
    if DBSEEK(xFilial("SB1")+aAux[1])
        RecLock("SB1", .F.)
            SB1->B1_POSIPI := StrZero(Val(aAux[8]),8)
        MsUnlock()
    endif
            DBCLOSEAREA()*/
        Else
            aErroRet := oModel:GetErrorMessage()
            lSra := .F.
        EndIf
    ENDIF

    oModel:DeActivate()
    CONOUT("Fim: "+TIME())
    RestArea(aArea)

Return lSra

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

