#INCLUDE "Protheus.ch"
#INCLUDE "RESTFUL.CH"
#Include "rwmake.ch"
#Include "tbiconn.ch"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"


WSRESTFUL JWSSR801 DESCRIPTION "Evento de consulta e atualiza√cao de ausencias"
    WSMETHOD GET DESCRIPTION "RETORNA SR8" WSSYNTAX "/JWSSR801/{EMPRESA/matricula/}"
    WSMETHOD POST DESCRIPTION 'Arualiza SR8' WSSYNTAX '/JWSSR801/{1 ALTERACAO 2 PARA INCLUSAO}'
ENDWSRESTFUL

WsMethod POST WsReceive RECEIVE WsService JWSSR801

    LOCAL lRet := .T.
    LOCAL lFilok := .f.
    LOCAL cTpcpo := "" //tipo de campo na base
    LOCAL cEmpf := "" //esmpresa do cadastro
    LOCAL cCampo := ""
    LOCAL xConteudo := "" //conteudo
    LOCAL oResponse     := JsonObject():New()
    Local oAusenc
    LOCAL n := 0
    LOCAL nI := 0
    LOCAL nC := 0
    Local nR := 0
    LOCAL aFunci := {}
    PRIVATE nTipo := 0
    PRIVATE aSr8 := {}
    PRIVATE cErro := ""
    PRIVATE aErroRet := {}
    PRIVATE dStart := NIL
    PRIVATE cMatric := "" //matricula
    PRIVATE cTipo := ""

    RpcClearEnv()
    RpcSetType(3)
    //RPCSetEnv('99','01')
    RPCSetEnv('01','00020087')

    Self:SetContentType("application/json")

    oAusenc := JsonObject():New()

    cError := oAusenc:fromJson( self:getContent() )

    If Empty(cError) .and. valtype(oAusenc["AUSENCIA"]) == "A" .and.  LEN(self:aURLParms) > 0

        //1 INSERI 2 ALTERA 3 DELETA
        nTipo := val(ALLTRIM(::aURLParms[1]))

        aFunci:= oAusenc:GetJSonObject('AUSENCIA')
        For nI := 1 to len(aFunci)
            IF nI == 1
                IF !EMPTY(alltrim(oAusenc["AUSENCIA"][nI]['EMPRESA'])) .OR. alltrim(oAusenc["AUSENCIA"][nI]['EMPRESA']) != NIL
                    cEmpf := alltrim(oAusenc["AUSENCIA"][nI]['EMPRESA'])
                    MyOpenSM0()
                    SM0->( DBGOTOP() )
                    WHILE !SM0->( EOF() ) .AND. !lFilok
                        IF padl(cEmpf,8,"0") == ALLTRIM(SM0->M0_CODFIL)
                            //IF padl(cEmpf,2,"0") == ALLTRIM(SM0->M0_CODFIL)
                            cFilant := ALLTRIM(SM0->M0_CODFIL)
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
            //valida funcinario na empresa e se n√£o est√° demitido
            IF lRet
                IF !EMPTY(alltrim(oAusenc["AUSENCIA"][nI]['MATRICULA'])) .OR. alltrim(oAusenc["AUSENCIA"][nI]['MATRICULA']) != NIL
                    cMatric := alltrim(oAusenc["AUSENCIA"][nI]['MATRICULA'])
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
                        oResponse['message'] := 'Parametro n√£o tem a quantidade de caracteres esperada. Matricula com 6 ou CPF com 11.'
                        oResponse['detailedMessage'] := ''
                    ENDIF
                ELSE
                    lRet := .F.
                    oResponse['code'] := 4
                    oResponse['status'] := 404
                    oResponse['message'] := 'Matricula n√£o foi informada'
                    oResponse['detailedMessage'] := ''
                ENDIF
            ENDIF

            IF lRet
                SRA->( DBSETORDER(nInd) )//::aURLParms[2]
                IF SRA->( DBSEEK( xFilial('SRA') + cSeek ) )
                    IF !SRA->RA_SITFOLH == 'D'
                        IF valtype(oAusenc["AUSENCIA"][nI]['CAMPOS']) == "A"
                            //procura campo na SRA, pega tipo de campo.
                            nC := 0
                            For nC := 1 to len(oAusenc["AUSENCIA"][nI]['CAMPOS'])
                                cCampo := ALLTRIM(oAusenc["AUSENCIA"][1]['CAMPOS'][nC]["CAMPO"])
                                xConteudo := ALLTRIM(oAusenc["AUSENCIA"][1]['CAMPOS'][nC]["CONTEUDO"])
                                CAMPO := ""

                                SX3->( DBSETORDER(1) )
                                SX3->( DBSEEK( 'SR8' ) )
                                WHILE !SX3->( EOF() ) .AND. SX3->X3_ARQUIVO == 'SR8' .AND. EMPTY(CAMPO)
                                    //valida tipo de campo e conteudo informado
                                    aAux := {}
                                    IF X3USO( SX3->X3_USADO) .AND. SX3->X3_CONTEXT != 'V'
                                        IF alltrim(cCampo) ==  ALLTRIM(SX3->X3_CAMPO)
                                            CAMPO := ALLTRIM( SX3->X3_CAMPO)

                                            //CONVERTER PARA CARACTER
                                            cTpcpo := SX3->X3_TIPO
                                            IF cTpcpo == 'N'
                                                xConteudo := Val(StrTran(strtran(xConteudo,"."),",","."))
                                            ELSEIF cTpcpo == 'D'
                                                xConteudo := CTOD(xConteudo)
                                                //VALIDA√á√ÉO CAMPO DATA DE INICIO SR8
                                                IF CAMPO == "R8_DATAINI"
                                                    dStart := xConteudo
                                                ENDIF
                                            ENDIF
                                            IF CAMPO == "R8_TIPOAFA"
                                                cTipo := xConteudo
                                                xConteudo := padl(xConteudo,3,"0")
                                            ENDIF
                                            aAux := {CAMPO,xConteudo}
                                            aadd(aSr8,aAux)
                                        ENDIF
                                    ENDIF
                                    //CAMPO := ALLTRIM( SX3->X3_CAMPO)
                                    SX3->( DBSKIP() )

                                ENDDO
                            NEXT nC

                            IF MvcSR8()
                                oResponse['data']   := {}
                                AADD( oResponse['data'], JsonObject():New() )

                                IF  nTipo == 1
                                    oResponse['data'][1]["status"] := "Incluido"
                                ELSEIF  nTipo == 2
                                    oResponse['data'][1]["status"] := "Alterado"
                                ELSEIF  nTipo == 3
                                    oResponse['data'][1]["status"] := "Deletado"
                                ENDIF

                                FOR nR := 1 to len(aSr8)

                                    oResponse['data'][1][aSr8[nR,1]] := aSr8[nR,2]

                                NEXT nR
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
                                    oResponse['message'] := 'erro nao localizado no protheus.'
                                    oResponse['detailedMessage'] := ''
                                ENDIF

                            ENDIF
                        ENDIF
                    ELSE
                        lRet := .F.
                        oResponse['code'] := 7
                        oResponse['status'] := 404
                        oResponse['message'] := 'Funcionario esta demitido.'
                        oResponse['detailedMessage'] := ''
                    ENDIF
                ELSE
                    lRet := .F.
                    oResponse['code'] := 5
                    oResponse['status'] := 404
                    oResponse['message'] := 'Matricula nao encontrada'
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

WSMETHOD GET WSSERVICE JWSSR801

    LOCAL lRet := .T.
    LOCAL nC := 0
    LOCAL lFilok := .F.
    LOCAL cSeek := ""
    LOCAL aSR8 := {}
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

    If LEN(self:aURLParms) > 0
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

        //DBSELECTAREA("SR8")
        //CONSULTO SR8 PELA EMPRESA E MATRICULA
        IF LEN(self:aURLParms) == 2
            cSeek := ::aURLParms[2]
            cSeek :=  NewCGCCPF(cSeek)
            IF LEN(cSeek) == 11 //CNPJ
                cSeek := PADR(STRZERO( VAL(cSeek),11), TAMSX3('RA_CIC') [1]) //RA_FILIAL+RA_CIC 5
                nInd := 5
            ELSEIF LEN(ALLTRIM(cSeek)) == 6 //MATRICULA
                cSeek := PADR(STRZERO( VAL(cSeek),6), TAMSX3('RA_MAT') [1]) //RA_FILIAL+RA_MAT+RA_NOME 1
                nInd := 1
            ELSE
                lRet := .F.
                oResponse['code'] := 3
                oResponse['status'] := 404
                oResponse['message'] := 'Parametro n„o tem a quantidade de caracteres esperada. Matricula com 6 ou CPF com 11.'
                oResponse['detailedMessage'] := ''
                //                SetRestFault( 404 , "Parametro n„o tem a quantidade de caracteres esperada. Matricula com 6 ou CPF com 11." )
            ENDIF

            SRA->( DBSETORDER(nInd) )//::aURLParms[2]
            If SRA->( DBSEEK( xFilial('SRA') + cSeek ) ) .AND. lRet
                //cSeek := ::aURLParms[2]
                DBSELECTAREA("SR8")
                SR8->( DBSETORDER(1) )//::aURLParms[2] R8_FILIAL+R8_MAT+DTOS(R8_DATAINI)+R8_TIPO
                IF SR8->( DBSEEK( xFilial("SR8") + cSeek) ) //.AND. lRet]
                    // oCampo['DADOS']   := {}
                    // nLinha := 0
                    WHILE !SR8->( EOF() ) .AND. cSeek == SR8->R8_MAT

                        AADD(aSR8,{SR8->R8_MAT,SR8->R8_DATA,SR8->R8_SEQ,SR8->R8_TIPOAFA,SR8->R8_PD,SR8->R8_DATAINI,SR8->R8_DURACAO,SR8->R8_DATAFIM})

                        SR8->( DBSKIP() )
                    ENDDO
                    //aSort(aSR8, , , {|x, y| x[1] < y[1]})
                    DBSELECTAREA("RCM")
                    IF LEN(aSR8) > 0
                        oCampo['DADOS']   := {}

                        nC := 0

                        FOR nC := 1 to LEN(aSR8)
                            AADD( oCampo['DADOS'], JsonObject():New() )

                            oCampo['DADOS'][nC]["R8_MAT"]       := aSR8[nC,1]
                            oCampo['DADOS'][nC]["R8_DATA"]      := substr(dtos(aSR8[nC,2]),7,2)+"/"+substr(dtos(aSR8[nC,2]),5,2)+"/"+substr(dtos(aSR8[nC,2]),1,4)
                            oCampo['DADOS'][nC]["R8_SEQ"]       := aSR8[nC,3]
                            oCampo['DADOS'][nC]["R8_TIPOAFA"]   := aSR8[nC,4]
                            oCampo['DADOS'][nC]["R8_DESCTP "]   := EncodeUTF8(posicione('RCM',1,xFilial('RCM')+alltrim(aSR8[nC][4]),'RCM_DESCRI'),"cp1252")
                            oCampo['DADOS'][nC]["R8_PD"]        := aSR8[nC,5]
                            oCampo['DADOS'][nC]["R8_DATAINI"]   := substr(dtos(aSR8[nC,6]),7,2)+"/"+substr(dtos(aSR8[nC,6]),5,2)+"/"+substr(dtos(aSR8[nC,6]),1,4)
                            oCampo['DADOS'][nC]["R8_DURACAO"]   := aSR8[nC,7]
                            oCampo['DADOS'][nC]["R8_DATAFIM"]   := substr(dtos(aSR8[nC,8]),7,2)+"/"+substr(dtos(aSR8[nC,8]),5,2)+"/"+substr(dtos(aSR8[nC,8]),1,4)

                        NEXT nC
                    ELSE
                        lRet:= .F.
                        oResponse['code'] := 2
                        oResponse['status'] := 404
                        oResponse['message'] := 'N„o foi encontrado nenhum registro para essa matricula!'
                        oResponse['detailedMessage'] := ''

                    ENDIF

                    ::SetResponse(FWJsonSerialize(oCampo, .F., .F., .T.))

                    SR8->(DbCloseArea())
                    RCM->(DbCloseArea())
                ELSE
                    lRet:= .F.
                    oResponse['code'] := 2
                    oResponse['status'] := 404
                    oResponse['message'] := 'N„o foi encontrado nenhum registro para essa tabela nessa empresa!'
                    oResponse['detailedMessage'] := ''
                ENDIF
            ELSE
                lRet:= .F.
                oResponse['code'] := 3
                oResponse['status'] := 404
                oResponse['message'] := 'Informe empresa e matricula ou verifique se a matricula est· na empresa informada!'
                oResponse['detailedMessage'] := ''

            ENDIF
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


/*/{Protheus.doc} MvcSR8
    C√≥digo que exemplifica a execu√ß√£o do ExecAuto de Aus√™ncias do M√≥dulo de Gest√£o de Pessoal;
    √â poss√≠vel usar a rotina autom√°tica via ExecAuto utilizando a estrutura MVC
@author PHILIPE.POMPEU
@since 26/04/2016
@version P12
@param cMat, caractere, Matr√≠cula do Funcion√°rio
@param nTipo, num√©rico, tipo do teste
@return nil, nulo
/*/
static Function MvcSR8()//(cMat,nTipo)
    Local oModel    := Nil
    Local oSubMdl   := Nil
    Local nTam      := 0
    Local nSeq      := 0
    lOCAL n := 0
    local lOk := .T.
    Local aSeek:= {}

    Private cProcesso := ""

    SRA->(DbSetOrder(1))

    //dStart := cToD("18/04/2016")
    nTam    := TamSx3("R8_SEQ")[1]

    if(SRA->(DbSeek(xFilial("SRA") + cMatric)))
        if(nTipo == 1) /*Exemplo Insert instanciando o Model manualmente*/
            oModel := FWLoadModel("GPEA240")
            oModel:SetOperation(4)
            if(oModel:Activate())
                oSubMdl := oModel:GetModel("GPEA240_SR8")
                //dStart := dStart + 1
                if(oSubMdl:Length() > 1)
                    nSeq := oSubMdl:AddLine()
                else
                    if(oSubMdl:IsInserted())
                        nSeq := 1
                    else
                        nSeq := oSubMdl:AddLine()
                    endIf
                endIf

                oSubMdl:SetValue("R8_SEQ"   , StrZero(nSeq,nTam))

                FOR n := 1 TO LEN(aSr8)
                    oSubMdl:SetValue( aSr8[n,1]  ,  aSr8[n,2]      )
                NEXT n

                if(oModel:VldData())
                    oModel:CommitData()
                    lOk := .T.
                else
                    aErroRet := oModel:GetErrorMessage()
                    aLog := oModel:GetErrorMessage()
                    aEval(aLog,{|x|ConOut(x)})
                    lOk := .F.
                endIf
            endIf
        elseif(nTipo == 2 .OR. nTipo == 3)/*Exemplo Update instanciando o Model manualmente*/

            oModel := FWLoadModel("GPEA240")
            IF nTipo == 3 //EXCLUS√O
                oModel:SetOperation(MODEL_OPERATION_UPDATE) //MODEL_OPERATION_DELETE
            ELSE //ALTERA«√O
                oModel:SetOperation(4)
            ENDIF

            if(oModel:Activate())
                oSubMdl := oModel:GetModel("GPEA240_SR8")
                //dStart := dStart + 1

                aAdd(aSeek,{"R8_FILIAL" ,xFilial("SR8")})
                aAdd(aSeek,{"R8_MAT"        ,    cMatric })
                aAdd(aSeek,{"R8_DATAINI"    ,dStart})

                oSubMdl:GoLine(1)//Volta ao topo pra pra buscar!!
                if oSubMdl:SeekLine(aSeek) .And. !oSubMdl:IsDeleted()
                    IF nTipo == 3
                        oSubMdl:DeleteLine()
                    else
                        //nSeq := oSubMdl:AddLine()
                        oSubMdl:SetValue("R8_FILIAL", xFilial("SR8"))
                        oSubMdl:SetValue("R8_MAT"   , SRA->RA_MAT)
                        // oSubMdl:SetValue("R8_SEQ"   , StrZero(nSeq,nTam))
                        // oSubMdl:SetValue("R8_TIPOAFA"   , cTipo )
                        // oSubMdl:SetValue("R8_DATAINI", dStart)

                        FOR n := 1 TO LEN(aSr8)
                            oSubMdl:SetValue( aSr8[n,1]  ,  aSr8[n,2]      )
                        NEXT n
                    endif

                    if(oModel:VldData())
                        oModel:CommitData()
                        lOk := .T.
                    else
                        aErroRet := oModel:GetErrorMessage()
                        aLog := oModel:GetErrorMessage()
                        aEval(aLog,{|x|ConOut(x)})
                        lOk := .F.
                    endIf
                else
                    AADD(aErroRet,"Registro n„o localizado.")
                    AADD(aErroRet,"Possiveis causas: ")
                    AADD(aErroRet,"Data de inicio deve ser igual a data de inicio do registro que deseja alterar/deletar.")
                    AADD(aErroRet,"Se quiser alterar a data de inicio, o recomendado È Deletar o registro com a opÁ„o 3, depois incluir um novo registro com a opÁ„o 1.")

                    lOk := .F.
                endIf
            endif
        endIf
    else
        ConOut("Matricula invalida -> "+cMatric)
    endIf
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
