#INCLUDE "Protheus.ch"
#INCLUDE "RESTFUL.CH"
#Include "rwmake.ch"
#Include "tbiconn.ch"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"
#Include "TopConn.ch"

WSRESTFUL JWSTRA01 DESCRIPTION "Evento de transferencia"
    WSMETHOD POST DESCRIPTION 'Atualiza SRA' WSSYNTAX '/JWSTRA01'
ENDWSRESTFUL

WsMethod POST WsReceive RECEIVE WsService JWSTRA01

    LOCAL lRet          := .T.
    LOCAL lFilok        := .F.
    Local lD            := .F.
    LOCAL cTpcpo        := "" //tipo de campo na base
    //LOCAL cTpCon    := "" //analisa informa√ß√£o
    LOCAL cEmpf         := "" //esmpresa do cadastro
    LOCAL cCnpjO        := "" // cnpj origem
    LOCAL cCnpjD        := "" // cnpj destino
    LOCAL cCampo        := ""
    // LOCAL aCampo := {} // campo alterar
    LOCAL xConteudo     := "" //conteudo
    LOCAL oResponse     := JsonObject():New()
    Local oAusenc
    LOCAL aSM0 := {}
    LOCAL nI := 0
    LOCAL nC := 0
    Local nR := 0
    LOCAL nX := 0
    LOCAL aTransf       := {}
    PRIVATE cProcPer := ""
    PRIVATE nTipo       := 0
    PRIVATE aTSRA       := {}
    PRIVATE cErro       := ""
    PRIVATE aErroRet    := {}
    PRIVATE dStart      := NIL
    PRIVATE cMatric     := "" //matricula
    PRIVATE cTipo       := ""
    PRIVATE dDataTransf

    RpcClearEnv()
    RpcSetType(3)
    RPCSetEnv('01','00020087')
    //RPCSetEnv('01','0201')

    Self:SetContentType("application/json")

    oAusenc := JsonObject():New()

    cError := oAusenc:fromJson( self:getContent() )
    //lOk := .F.

    If Empty(cError) .and. valtype(oAusenc["TRANSF"]) == "A" //.and.  LEN(self:aURLParms) > 0
        //IF  ALLTRIM(::aURLParms[1]) == "1" //INCLUIR

        //1 INSERI 2 ALTERA 3 DELETA
        // nTipo := val(ALLTRIM(::aURLParms[1]))

        aTransf:= oAusenc:GetJSonObject('TRANSF')
        For nI := 1 to len(aTransf)
            IF nI == 1
                IF !EMPTY(alltrim(oAusenc["TRANSF"][nI]['EMPRESA'])) .OR. alltrim(oAusenc["TRANSF"][nI]['EMPRESA']) != NIL
                    cEmpf := alltrim(oAusenc["TRANSF"][nI]['EMPRESA'])
                    MyOpenSM0()
                    SM0->( DBGOTOP() )
                    WHILE !SM0->( EOF() ) .AND. !lFilok
                        IF padl(cEmpf,8,"0") == ALLTRIM(SM0->M0_CODFIL)
                            //IF padl(cEmpf,2,"0") == ALLTRIM(SM0->M0_CODFIL)
                            ConOut("achou empresa")
                            cFilant := ALLTRIM(SM0->M0_CODFIL)
                            cNumEmp := "01"+cFilant
                            lFilok := .T.
                            cCnpjO := SUBSTR(SM0->M0_CGC,1,8)
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
            //valida funcinario na empresa e se n√£o est√° demitido
            IF lRet
                ConOut("validando matricula 01")
                IF !EMPTY(alltrim(oAusenc["TRANSF"][nI]['MATRICULA'])) .OR. alltrim(oAusenc["TRANSF"][nI]['MATRICULA']) != NIL
                    cMatric := alltrim(oAusenc["TRANSF"][nI]['MATRICULA'])
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
                        oResponse['message'] := 'Parametro nao tem a quantidade de caracteres esperada. Matricula com 6 ou CPF com 11.'
                        oResponse['detailedMessage'] := ''
                    ENDIF
                ELSE
                    lRet := .F.
                    oResponse['code'] := 4
                    oResponse['status'] := 404
                    oResponse['message'] := 'Matricula nao foi informada'
                    oResponse['detailedMessage'] := ''
                ENDIF
            ENDIF

            //VALIDA DATA TRANSFERENCIA
            IF lRet
                ConOut("data trasnferencia")
                IF !EMPTY(alltrim(oAusenc["TRANSF"][nI]['DATA_TRANSF'])) .OR. alltrim(oAusenc["TRANSF"][nI]['DATA_TRANSF']) != NIL
                    dDataTransf := CTOD(alltrim(oAusenc["TRANSF"][nI]['DATA_TRANSF']))
                ELSE
                    lRet := .F.
                    oResponse['code'] := 4
                    oResponse['status'] := 404
                    oResponse['message'] := 'data de transferencia nao informada'
                    oResponse['detailedMessage'] := ''
                ENDIF
            ENDIF
            IF lRet
                ConOut("antes de pesquisar sra")
                SRA->( DBSETORDER(nInd) )//::aURLParms[2]
                IF SRA->( DBSEEK( xFilial('SRA') + cSeek ) )
                    IF !SRA->RA_SITFOLH == 'D' .AND. !SRA->RA_SITFOLH == 'F'
                        cMatric := SRA->RA_MAT
                        IF valtype(oAusenc["TRANSF"][nI]['CAMPOS']) == "A"
                            ConOut("ACHOU FUNCIONARIO")
                            //procura campo na SRA, pega tipo de campo.
                            nC := 0
                            For nC := 1 to len(oAusenc["TRANSF"][nI]['CAMPOS'])
                                cCampo := ALLTRIM(oAusenc["TRANSF"][1]['CAMPOS'][nC]["CAMPO"])
                                xConteudo := ALLTRIM(oAusenc["TRANSF"][1]['CAMPOS'][nC]["CONTEUDO"])
                                CAMPO := ""
                                ConOut("pegou campo" + cvaltochar(nC))
                                IF !(cCampo == "RE_DESL")

                                    SX3->( DBSETORDER(1) )
                                    SX3->( DBSEEK( 'SRA' ) )

                                    WHILE !SX3->( EOF() ) .AND. SX3->X3_ARQUIVO == 'SRA' .AND. EMPTY(CAMPO)
                                        ConOut("PEGOU SX3" + cvaltochar(nC))

                                        //valida tipo de campo e conteudo informado
                                        aAux := {}
                                        IF X3USO( SX3->X3_USADO) .AND. SX3->X3_CONTEXT != 'V' .OR. ALLTRIM(SX3->X3_CAMPO) == "RA_FILIAL"
                                            IF alltrim(cCampo) ==  ALLTRIM(SX3->X3_CAMPO)
                                                CAMPO := ALLTRIM( SX3->X3_CAMPO)
                                                ConOut("ACHOU CAMPO" + cvaltochar(nC))
                                                //CONVERTER PARA CARACTER
                                                cTpcpo := SX3->X3_TIPO
                                                IF cTpcpo == 'N'
                                                    xConteudo := Val(StrTran(strtran(xConteudo,"."),",","."))
                                                ELSEIF cTpcpo == 'D'
                                                    xConteudo := CTOD(xConteudo)
                                                    //VALIDA√á√ÉO CAMPO DATA DE INICIO SR8
                                                    //   IF CAMPO == "R8_DATAINI"
                                                    //       dStart := xConteudo
                                                    //    ENDIF
                                                ENDIF

                                                IF CAMPO == "RA_CC"
                                                    ConOut("PADL" + cvaltochar(nC))
                                                    xConteudo := padR(xConteudo,20)
                                                ENDIF

                                                IF CAMPO == "RA_PROCES"
                                                    cProcPer := xConteudo
                                                ENDIF

                                                IF CAMPO == "RA_FILIAL"
                                                    xConteudo := xConteudo
                                                    //Carrega informacoes das empresas -> posicoes #include 'FWCommand.CH'
                                                    aSM0    := FWLoadSM0()
                                                    ConOut("PEGOU FWLOADSM0" + cvaltochar(nC))

                                                    IF len(aSM0) > 0
                                                        ConOut("ASM0 OK" + cvaltochar(nC))
                                                    ENDIF

                                                    nX := 0
                                                    For nX := 1 To Len(aSM0)
                                                        If RTrim(aSM0[nX][2]) == RTrim(xConteudo)
                                                            cCnpjD := SUBSTR(aSM0[nX][18],1,8)
                                                            lRet    := .T.
                                                            ConOut("ANTES DO EXIT" + cvaltochar(nC))
                                                            Exit
                                                            ConOut("APOS O EXIT" + cvaltochar(nC))
                                                        EndIf
                                                    Next
                                                ENDIF

                                                aAux := {CAMPO,xConteudo}
                                                aadd(aTSRA,aAux)
                                            ENDIF
                                        ENDIF
                                        //CAMPO := ALLTRIM( SX3->X3_CAMPO)
                                        SX3->( DBSKIP() )
                                    ENDDO
                                ELSE
                                    //VARIVAL DE CONTROLE PARA CNPJ COM RAIZ DIFERENTE
                                    lD := .T.
                                    aAux := {CAMPO := cCampo,xConteudo}
                                    aadd(aTSRA,aAux)
                                ENDIF
                            NEXT nC
                            //VALIDA«√O DE CNPJ
                            IF cCnpjD != cCnpjO .AND. !lD
                                ConOut("VALIDOU CNPJ" + cvaltochar(nC))
                                lRet := .F.
                                oResponse['code'] := 15
                                oResponse['status'] := 404
                                oResponse['message'] := "Quando raiz diferente informar o campo tipo de demiss„o RE_DESL"
                                oResponse['detailedMessage'] := ''
                            ENDIF

                            IF lRet
                                IF MYTRANSF()
                                    oResponse['data']   := {}
                                    AADD( oResponse['data'], JsonObject():New() )

                                    oResponse['data'][1]["status"] := "Transferido"
                                    // FOR nR := 1 to len(aTSRA)

                                    //    oResponse['data'][nR][aTSRA[nR,1]] := aSra[nR,2]

                                    // NEXT nR
                                    ::SetResponse(FWJsonSerialize(oResponse, .F., .F., .T.))
                                ELSE
                                    lRet := .F.
                                    oResponse['code'] := 15
                                    oResponse['status'] := 404
                                    oResponse['message'] :=  EncodeUTF8(cErro,"cp1252")
                                    oResponse['detailedMessage'] := ''
                                ENDIF
                            ENDIF
                        ENDIF
                        //ENDIF
                    ELSE
                        lRet := .F.
                        oResponse['code'] := 7
                        oResponse['status'] := 404
                        oResponse['message'] := 'Funcionario demitido ou em situaÁ„o de ferias.'
                        oResponse['detailedMessage'] := ''
                    ENDIF
                ELSE
                    lRet := .F.
                    oResponse['code'] := 5
                    oResponse['status'] := 404
                    oResponse['message'] := 'Matricula n√£o encontrada'
                    oResponse['detailedMessage'] := ''
                ENDIF
            ENDIF
        NEXT nC
        //ENDIF
    ELSE
        lRet := .F.
        oResponse['code'] := 4
        oResponse['status'] := 404
        oResponse['message'] := 'Use incorreto do servi√ßo.'
        oResponse['detailedMessage'] := ''
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

/*/{Protheus.doc} MYTRANSF
    C√≥digo que exemplifica a execu√ß√£o do ExecAuto de Aus√™ncias do M√≥dulo de Gest√£o de Pessoal;
    √â poss√≠vel usar a rotina autom√°tica via ExecAuto utilizando a estrutura MVC
@author PHILIPE.POMPEU
@since 26/04/2016
@version P12
@param cMat, caractere, Matr√≠cula do Funcion√°rio
@param nTipo, num√©rico, tipo do teste
@return nil, nulo
/*/
static Function MYTRANSF()//(cMat,nTipo)
    Local aArea    := GetArea()
    Local aAutoItens := {}
    Local aCampos := {}
    local lOk := .T.
    Local n := 0
    local nx := 0
    Local cPeri := ""
    local cQuerPer := ""
    local cQuerTr := ""
    Private lMsErroAuto := .F.
    Private lAutoErrNoFile := .T.
    Private lMsHelpAuto :=.T.
    Private lAuyomato := .T.

    //PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "GPE"

    ConOut(Repl("-",80))
    ConOut("Inicio: "+Time())
    ConOut(PadC("Rotina Automatica Transferencia de funcionarios - SRA",80))

    cQuerTr := " SELECT MAX(RE_DATA) AS ULT_TRANS "
    cQuerTr += " FROM "+ RetSQLName('SRE')+" RE "
    cQuerTr += " WHERE RE_MATD = '" +cMatric+ "' AND RE.D_E_L_E_T_=''"

    If Select("TMP1")<>0
        DbSelectArea("TMP1")
        DbCloseArea()
    EndIf

    cQuerTr := ChangeQuery(cQuerTr)
    DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuerTr),'TMP1',.F.,.T.	)

    dbSelectArea("TMP1")
    TMP1->(dbGoTop())

    IF TMP1->(!EOF())
        dDTtrs := stod(TMP1->ULT_TRANS)
        IF dDataTransf <= dDTtrs
            cErro := "Data da atual transferenCia n„o pode ser menor que a ˙ltima transferencia realizada. Data da ultima transferencia "+ dtoc(dDTtrs)
            lOk := .F.
        ENDIF
    ENDIF

    IF lOk
        //Verifica se a data de trasnferencia est· dentrO do periodo ativo
        cQuerPer := " SELECT MIN(RFQ_PERIOD) AS PERIOD "
        cQuerPer += " FROM "+ RetSQLName('RFQ')+" RFQ "
        cQuerPer += " WHERE RFQ_FILIAL = '" +xFilial('RFQ')+ "' AND RFQ_PROCES = '"+cProcPer+"' AND RFQ.D_E_L_E_T_='' AND RFQ_STATUS = '1'"

        //VALIDA DATA DA ULTIMA TRANSFERENCIA

        If Select("TMP")<>0
            DbSelectArea("TMP")
            DbCloseArea()
        EndIf

        cQuerPer := ChangeQuery(cQuerPer)
        DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuerPer),'TMP',.F.,.T.	)

        dbSelectArea("TMP")
        TMP->(dbGoTop())

        IF TMP->(!EOF())
            cPeri := TMP->PERIOD
            IF AnoMes(dDataTransf) != cPeri
                cErro := "Transferencias n„o s„o permitidas em meses Posteriores ou Anteriores ao atual mÍs de calculo da folha"
                lOk := .F.
            ENDIF
        ELSE
            cErro := "N„o foi localizado periodo ativo para o processo informado"
            lOk := .F.
        ENDIF
    ENDIF

    If lOk
        FOR n := 1 TO LEN(aTSRA)
            aAdd( aCampos, {aTSRA[n,1]  ,  aTSRA[n,2]  } )
        NEXT n
        aAdd( aAutoItens, { cFilant, cMatric , aCampos } )

        // Begin Transaction
        //chamada ExecAuto

        MSExecAuto( {|x,y,z,w| GPEA180(x,y,z,w)}, 6, aAutoItens, dDataTransf, .T. )

        If !lMsErroAuto
            ConOut("Transferencia efetuada!")

        Else
            If !IsBlind()
                _aLog := GetAutoGRLog()//MostraErro('Null')
                varinfo("aLogAuto",_aLog)
            Else
                _aLog := GetAutoGRLog()// MostraErro() //caso acionada via interface.
                varinfo("aLogAuto",_aLog)
            EndIf
            lOk := .F.
            ConOut("Erro na Transferencia!")
            CONOUT(GetAutoGRLog())
            conout("entrou na geracao do log")
            // For nx :=1 To Len(_aLog)
            conout(_aLog[1])

            //  aEr := {}
            //   aEr := SEPARA(_aLog[1],":",.T.)

            //  cErro += EncodeUTF8(aEr[2],"cp1252") //PADL(_aLog[nx],1,50)
            For nx := 1 To Len(_aLog)
                IF _aLog[nX] != NIL
                    cErro += EncodeUTF8(_aLog[nX],"cp1252")
                ENDIF
                //            cErro += EncodeUTF8(_aLog[nX],"cp1252")

            Next nx

            IF EMPTY(cErro)
                cErro := EncodeUTF8("Erro n„o identificado nos retornos padrıes do Protheus.","cp1252")
            ENDIF
            //  ENDIF
            //  DisarmTransaction()
        EndIf
        // End Transaction
    ENDIF
    ConOut("Fim : "+Time())
    ConOut(Repl("-",80))

    //RESET ENVIRONMENT
    RestArea(aArea)


Return lOk

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

//----------------------------------------------------------
// Funcao Auxiliar para retirar a m√°scara do campo CNPJ/CPF:
//----------------------------------------------------------
Static Function NewCGCCPF(cCGCCPF)

    LOCAL aInvChar := {"/",".","-"}
    LOCAL nI

    For nI:=1 to Len(aInvChar)
        cCGCCPF := StrTran(cCGCCPF,aInvChar[nI])
    Next

Return cCGCCPF
