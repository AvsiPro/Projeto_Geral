#INCLUDE "Protheus.ch"
#INCLUDE "RESTFUL.ch"
#Include "rwmake.ch"
#Include "tbiconn.ch"

WSRESTFUL JWSSRA01 DESCRIPTION "Rest de Funcionários"
    //médotdos
    // WSDATA  empresa        as STRING
    // WSDATA  matrciula        as STRING
    //  WSDATA  campo    as STRING
    //  WSDATA  conteudo          as STRING
    //WSDATA  municipio   as STRING

    WSMETHOD GET DESCRIPTION "Obtem dados do cadastro de funcionários." WSSYNTAX "/JWSSRA01/{empresa/matcpf}"
    WSMETHOD POST DESCRIPTION "Cadastros de Colaboradores"               WSSYNTAX "/JWSSRA01/{1 altera}"


ENDWSRESTFUL

WSMETHOD GET WSSERVICE JWSSRA01

    Local lRet := .T.
    Local cSeek := ""
    Local nInd := 0
    LOCAL lFilok := .f.
    // LOCAL cTpcpo := "" //tipo de campo na base
    LOCAL oResponse     := JsonObject():New()
    PRIVATE cCGCCPF := ""

    RpcClearEnv()
    RpcSetType(3)
    //RPCSetEnv('99','01')
    RPCSetEnv('01','00020087')

    ::SetContentType("application/json")

    IF !MyOpenSM0()
        lRet:= .F.
        oResponse['code'] := 1
        oResponse['status'] := 500
        oResponse['message'] := 'Falha ao abrir ambiente de trabalho!'
        oResponse['detailedMessage'] := ''
        //        SetRestFault( 500, "Falha ao abrir ambiente de trabalho!")
        RETURN lRet
    ENDIF

    If LEN(self:aURLParms) > 0
        MyOpenSM0()
        SM0->( DBGOTOP() )
        WHILE !SM0->( EOF() ) .AND. !lFilok
            // IF padl(::aURLParms[1],2,"0") == ALLTRIM(SM0->M0_CODFIL)
            IF padl(::aURLParms[1],8,"0") == ALLTRIM(SM0->M0_CODFIL)
                cFilant := ALLTRIM(SM0->M0_CODFIL)
                cNumEmp := "01"+cFilant
                lFilok := .t.
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

        IF LEN(self:aURLParms) == 2
            cCGCCPF := ::aURLParms[2]
            cCGCCPF :=  NewCGCCPF(cCGCCPF)
            IF LEN(cCGCCPF) == 11 //CNPJ
                cSeek := PADR(STRZERO( VAL(cCGCCPF),11), TAMSX3('RA_CIC') [1]) //RA_FILIAL+RA_CIC 5
                nInd := 5
            ELSEIF LEN(ALLTRIM(cCGCCPF)) == 6 //MATRICULA
                cSeek := PADR(STRZERO( VAL(cCGCCPF),6), TAMSX3('RA_MAT') [1]) //RA_FILIAL+RA_MAT+RA_NOME 1
                nInd := 1
            ELSE
                lRet := .F.
                oResponse['code'] := 3
                oResponse['status'] := 404
                oResponse['message'] := 'Parametro não tem a quantidade de caracteres esperada. Matricula com 6 ou CPF com 11.'
                oResponse['detailedMessage'] := ''
                //                SetRestFault( 404 , "Parametro não tem a quantidade de caracteres esperada. Matricula com 6 ou CPF com 11." )
            ENDIF
        ENDIF

        SRA->( DBSETORDER(nInd) )//::aURLParms[2]
        If SRA->( DBSEEK( xFilial('SRA') + cSeek ) ) .AND. lRet
            oResponse['data']   := {}
            AADD( oResponse['data'], JsonObject():New() )

            SX3->( DBSETORDER(1) )
            SX3->( DBSEEK( 'SRA' ) )
            WHILE !SX3->( EOF() ) .AND. SX3->X3_ARQUIVO == 'SRA'
                CAMPO := ALLTRIM( SX3->X3_CAMPO)
                IF X3USO( SX3->X3_USADO) .AND. SX3->X3_CONTEXT != 'V' .OR. CAMPO == "RA_FILIAL"
                    //CONVERTER PARA CARACTER
                    IF SX3->X3_TIPO     == 'C'
                        oResponse['data'][1][CAMPO] := ALLTRIM(SRA->&(CAMPO))
                    ELSEIF SX3->X3_TIPO == 'N'
                        oResponse['data'][1][CAMPO] := cValToChar(SRA->&(CAMPO))
                    ELSEIF SX3->X3_TIPO == 'D'
                        oResponse['data'][1][CAMPO] := substr(DTOS(SRA->&(CAMPO)),7,2)+"/"+substr(DTOS(SRA->&(CAMPO)),5,2)+"/"+substr(DTOS(SRA->&(CAMPO)),1,4)//DTOC(SRA->&(CAMPO))
                    ENDIF
                ENDIF
                SX3->( DBSKIP() )
            ENDDO
            ::SetResponse(FWJsonSerialize(oResponse, .F., .F., .T.))
        else
            lRet := .F.

            lRet := .F.
            oResponse['code'] := 5
            oResponse['status'] := 404
            oResponse['message'] := 'Colaboradores não locaizados.'
            oResponse['detailedMessage'] := ''
            //            SetRestFault( 404 , "Colaborador não locaizado." )
        EndIf
    else
        lRet := .F.
        oResponse['code'] := 5
        oResponse['status'] := 404
        oResponse['message'] := 'Uso incorreto do servico.'
        oResponse['detailedMessage'] := ''
        //        SetRestFault( 400 , "Uso incorreto do servico." )
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

WsMethod POST WsReceive RECEIVE WsService JWSSRA01

    LOCAL lRet := .T.
    LOCAL lFilok := .F.
    //LOCAL lTroca := .F.
    LOCAL cTpcpo := "" //tipo de campo na base
    //LOCAL cTpCon    := "" //analisa informação
    LOCAL cEmpf := "" //esmpresa do cadastro
    LOCAL cMatric := "" //matricula

    LOCAL cCampo := ""
    //LOCAL cNome := ""
    // LOCAL aCampo := {} // campo alterar
    LOCAL xConteudo := "" //conteudo
    LOCAL oResponse     := JsonObject():New()
    Local oContra
    LOCAL nI := 0
    LOCAL nC := 0
    Local nR := 0

    LOCAL aFunci := {}
    PRIVATE aSra := {}
    PRIVATE cErro := ""
    PRIVATE cUs := ""
    //LOCAL oJson := NIL

    RpcClearEnv()
    RpcSetType(3)
    //RPCSetEnv('99','01')
    RPCSetEnv('01','00020087')

    Self:SetContentType("application/json")

    IF !MyOpenSM0()
        lRet:= .F.
        oResponse['code'] := 1
        oResponse['status'] := 500
        oResponse['message'] := 'Falha ao abrir ambiente de trabalho!'
        oResponse['detailedMessage'] := ''
        //        SetRestFault( 500, "Falha ao abrir ambiente de trabalho!")
        // RETURN lRet
        SetRestFault( oResponse['code'],;
            oResponse['message'],;
            .T.,;
            oResponse['status'],;
            oResponse['detailedMessage'];
            )
    ENDIF

    oContra := JsonObject():New()

    cError := oContra:fromJson( self:getContent() )
    lOk := .F.

    If Empty(cError) .and. valtype(oContra["FUNCIONARIO"]) == "A" .and.  LEN(self:aURLParms) > 0
        IF  ALLTRIM(::aURLParms[1]) == "1" //ALTERAR
            If valtype(oContra["FUNCIONARIO"]) == "A"
                aFunci:= oContra:GetJSonObject('FUNCIONARIO')
                For nI := 1 to len(aFunci)
                    IF nI == 1
                        IF !EMPTY(alltrim(oContra["FUNCIONARIO"][nI]['EMPRESA'])) .OR. alltrim(oContra["FUNCIONARIO"][nI]['EMPRESA']) != NIL
                            cEmpf := alltrim(oContra["FUNCIONARIO"][nI]['EMPRESA'])
                            MyOpenSM0()
                            SM0->( DBGOTOP() )
                            WHILE !SM0->( EOF() ) .and. !lFilok
                                IF padl(cEmpf,8,"0") == ALLTRIM(SM0->M0_CODFIL)
                                    //    IF padl(cEmpf,2,"0") == ALLTRIM(SM0->M0_CODFIL)
                                    cFilant := ALLTRIM(SM0->M0_CODFIL)
                                    cNumEmp := "01"+cFilant
                                    lFilok := .t.
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
                    //valida funcinario na empresa e se não está demitido
                    IF lRet
                        IF !EMPTY(alltrim(oContra["FUNCIONARIO"][nI]['MATRICULA'])) .OR. alltrim(oContra["FUNCIONARIO"][nI]['MATRICULA']) != NIL
                            cMatric := alltrim(oContra["FUNCIONARIO"][nI]['MATRICULA'])
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
                                oResponse['message'] := 'Parametro não tem a quantidade de caracteres esperada. Matricula com 6 ou CPF com 11.'
                                oResponse['detailedMessage'] := ''
                            ENDIF
                            IF !EMPTY(alltrim(oContra["FUNCIONARIO"][nI]['USUARIO'])) .OR. alltrim(oContra["FUNCIONARIO"][nI]['USUARIO']) != NIL
                                cUs := alltrim(oContra["FUNCIONARIO"][nI]['USUARIO'])
                            ENDIF
                        ELSE
                            lRet := .F.
                            oResponse['code'] := 4
                            oResponse['status'] := 404
                            oResponse['message'] := 'Matricula não foi informada'
                            oResponse['detailedMessage'] := ''
                        ENDIF


                        IF lRet
                            SRA->( DBSETORDER(nInd) )//::aURLParms[2]
                            IF SRA->( DBSEEK( xFilial('SRA') + cSeek ) )
                                IF !SRA->RA_SITFOLH == 'D'
                                    IF valtype(oContra["FUNCIONARIO"][nI]['CAMPOS']) == "A"
                                        //procura campo na SRA, pega tipo de campo.
                                        nC := 0
                                        For nC := 1 to len(oContra["FUNCIONARIO"][nI]['CAMPOS'])
                                            cCampo := ALLTRIM(oContra["FUNCIONARIO"][1]['CAMPOS'][nC]["NOME"])
                                            xConteudo := ALLTRIM(oContra["FUNCIONARIO"][1]['CAMPOS'][nC]["ALTERACAO"])
                                            CAMPO := ""


                                            SX3->( DBSETORDER(1) )
                                            SX3->( DBSEEK( 'SRA' ) )
                                            WHILE !SX3->( EOF() ) .AND. SX3->X3_ARQUIVO == 'SRA' .AND. EMPTY(CAMPO)
                                                //valida tipo de campo e conteudo informado
                                                aAux := {}
                                                IF X3USO( SX3->X3_USADO) .AND. SX3->X3_CONTEXT != 'V' .OR. (ALLTRIM(SX3->X3_CAMPO) == "RA_TIPOALT" .OR. ALLTRIM(SX3->X3_CAMPO) == "RA_DATAALT")
                                                    IF alltrim(cCampo) ==  ALLTRIM(SX3->X3_CAMPO)
                                                        CAMPO := ALLTRIM( SX3->X3_CAMPO)

                                                        //CONVERTER PARA CARACTER
                                                        cTpcpo := SX3->X3_TIPO
                                                        IF cTpcpo == 'N'
                                                            xConteudo := Val(StrTran(strtran(xConteudo,"."),",","."))
                                                        ELSEIF cTpcpo == 'D'
                                                            xConteudo := CTOD(xConteudo)
                                                        ENDIF

                                                        //  IF CAMPO == "RA_NOME"
                                                        //      lTroca := .T.
                                                        //      cNome := PadR(xConteudo,TamSx3('RA_NOME')[1])
                                                        // ELSE
                                                        aAux := {SRA->RA_FILIAL,SRA->RA_MAT,SRA->RA_PROCES,CAMPO,xConteudo}
                                                        aadd(aSra,aAux)
                                                        // ENDIF
                                                    ENDIF
                                                ENDIF
                                                //CAMPO := ALLTRIM( SX3->X3_CAMPO)
                                                SX3->( DBSKIP() )

                                            ENDDO
                                        NEXT nC
                                        /*
                                        IF lTroca
                                            aSra[1,3] := cNome
                                        ENDIF
                                        */
                                        IF GP010AUT()
                                            oResponse['data']   := {}
                                            AADD( oResponse['data'], JsonObject():New() )

                                            FOR nR := 1 to len(aSra)

                                                oResponse['data'][1][aSra[nR,4]] := aSra[nR,5]

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
                                ELSE
                                    lRet := .F.
                                    oResponse['code'] := 7
                                    oResponse['status'] := 404
                                    oResponse['message'] := 'Funcionario está demitido.'
                                    oResponse['detailedMessage'] := ''
                                ENDIF
                            ELSE
                                lRet := .F.
                                oResponse['code'] := 5
                                oResponse['status'] := 404
                                oResponse['message'] := 'Matricula não encontrada'
                                oResponse['detailedMessage'] := ''
                            ENDIF
                        ENDIF
                    ENDIF
                NEXT nC
            ENDIF
            //INCLUIR
        ELSE
            lRet := .F.
            oResponse['code'] := 5
            oResponse['status'] := 404
            oResponse['message'] := 'INFORME 1 PARA ALTERAR'
            oResponse['detailedMessage'] := ''
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


// MSEXECAUTO INCLUSAI
Static Function GP010INC()

    Local aCabec     := {}
    Local cMatricula := ""
    local cNome := ""
    Local n          := 0
    //  Local nY := 0
    Local nx := 0
    //Local cErro := ""
    Local lSra  := .f.

    Private lMsErroAuto := .F.
    Private lAutoErrNoFile := .T.
    Private lMsHelpAuto :=.T.

    aCabec   := {}
    cMatricula := aSra[1,2]
    cNome := aSra[1,3]

    DbSelectArea("SRA")
    DbSetOrder(1)
    DbGotop()
    If DbSeek(xFilial("SRA")+cMatricula)

        aadd(aCabec,{"RA_FILIAL"             , xFilial("SRA")                                                 ,Nil        })
        aadd(aCabec,{"RA_MAT"               ,   cMatricula                                                  ,Nil        })
        aadd(aCabec,{'RA_NOME'             ,PadR(cNome,TamSx3('RA_NOME')[1])    ,Nil        })
        FOR n := 1 TO LEN(aSra)
            aadd(aCabec,{   aSra[n,4]           ,aSra[n,5]                                             ,Nil        })
        NEXT n
        aadd(aCabec,{"INDEX"              ,1                                                                      ,Nil        })

        // Opção igual a  4 - Alteração
        MSExecAuto({|x,y,k,w| GPEA010(x,y,k,w)},NIL,NIL,aCabec,4)

        If lMsErroAuto
            _aLog := GetAutoGRLog()
            CONOUT(GetAutoGRLog())
            conout("entrou na geracao do log")
            // For nx :=1 To Len(_aLog)
            conout(_aLog[1])

            aEr := {}
            aEr := SEPARA(_aLog[1],":",.T.)
            IF alltrim(aEr[1]) == "AJUDA"
                //If !Empty(cErro)
                //    cErro += CRLF
                //EndIf
                cErro += EncodeUTF8(aEr[2],"cp1252") //PADL(_aLog[nx],1,50)
                For nx :=1 To Len(_aLog)
                    IF  "INVALIDO" $ UPPER(ALLTRIM(_aLog[nX]))
                        cErro += EncodeUTF8(_aLog[nX],"cp1252")
                    ENDIF
                    //                    nPos := aScan(_aLog, {|x| AllTrim(Upper(x)) == "INVALIDO"})
                Next nx
            ENDIF
            //Next nx


            conout(cErro)

            //  SetRestFault(500, cErro)
            lRet    := .F.
            lSra := .F.
        Else
            lSra := .T.
        EndIf
    Endif

Return lSra
// MSEXEC AUTO ALTERAÇÃO
Static Function GP010AUT()

    Local aCabec     := {}
    Local cMatricula := ""
    local cProces := ""
    Local n          := 0
    Local dAlter
    Local cTpAlter := ""
    Local nx := 0
    //Local cErro := ""
    Local lSra  := .F.
    Local lSr7  := .F.
    Private lMsErroAuto := .F.
    Private lAutoErrNoFile := .T.
    Private lMsHelpAuto := .T.

    aCabec   := {}
    cMatricula := aSra[1,2]
    cProces := aSra[1,3]

    DbSelectArea("SRA")
    DbSetOrder(1)
    DbGotop()
    If DbSeek(xFilial("SRA")+cMatricula)

        aadd(aCabec,{"RA_FILIAL"            ,   xFilial("SRA") ,Nil        })
        aadd(aCabec,{"RA_MAT"               ,   cMatricula     ,Nil        })
        aadd(aCabec,{"RA_PROCES"            ,   cProces        ,Nil        })
        //aadd(aCabec,{'RA_NOME'              ,   PadR(cNome,TamSx3('RA_NOME')[1])    ,Nil        })
        FOR n := 1 TO LEN(aSra)
            IF alltrim(aSra[n,4]) $ "RA_DATAALT|RA_TIPOALT"
                lSr7 := .T. // ATUALIZA SR7
                IF alltrim(aSra[n,4]) == "RA_DATAALT"
                    dAlter := aSra[n,5]
                ELSEIF alltrim(aSra[n,4]) == "RA_TIPOALT"
                    cTpAlter := alltrim(aSra[n,5])
                ENDIF
            ENDIF

            IF alltrim(aSra[n,4]) == "RA_NOME"
                aadd(aCabec,{   aSra[n,4]   ,PadR(aSra[n,5],TamSx3('RA_NOME')[1]) ,Nil        })
            ELSE
                aadd(aCabec,{   aSra[n,4]   ,aSra[n,5]          ,Nil        })
            ENDIF
        NEXT n

        aadd(aCabec,{"INDEX"                ,15                 ,Nil        })

        // Opção igual a  4 - Alteração
        MSExecAuto({|x,y,k,w| GPEA010(x,y,k,w)},NIL,NIL,aCabec,4)

        If lMsErroAuto
            _aLog := GetAutoGRLog()
            CONOUT(GetAutoGRLog())
            conout("entrou na geracao do log")
            // For nx :=1 To Len(_aLog)
            conout(_aLog[1])

            aEr := {}
            aEr := SEPARA(_aLog[1],":",.T.)
            IF alltrim(aEr[1]) == "AJUDA"
                //If !Empty(cErro)
                //    cErro += CRLF
                //EndIf
                cErro += EncodeUTF8(aEr[2],"cp1252") //PADL(_aLog[nx],1,50)
                For nx :=1 To Len(_aLog)
                    IF  "INVALIDO" $ UPPER(ALLTRIM(_aLog[nX]))
                        cErro += EncodeUTF8(_aLog[nX],"cp1252")
                    ENDIF
                    //                    nPos := aScan(_aLog, {|x| AllTrim(Upper(x)) == "INVALIDO"})
                Next nx
            ENDIF
            //Next nx
            conout(cErro)
            //  SetRestFault(500, cErro)
            lRet    := .F.
            lSra := .F.
        Else
            lSra := .T.
            IF lSr7
                DbSelectArea("SR7")
                DbSetOrder(1)
                DbGotop()
                If DbSeek(xFilial("SR7")+cMatricula+DTOS(dAlter)+cTpAlter)
                    //R7_FILIAL+R7_MAT+DTOS(R7_DATA)+R7_TIPO
                    reclock("SR7",.F.)
                    SR7->R7_USUARIO := cUs
                    SR7->(msunlock())
                ENDIF
            ENDIF
        EndIf
    Endif

Return lSra
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

/*
//Esta rotina tem a finalidade de efetuar o lançamento automático de funcionários
//através do mecanismo de rotina automática.
//Nesse exemplo, a chamada da função U_GP010AUT deve ser realizada
//a partir do menu, como demonstrado no extrato de um arquivo (*.XNU) qualquer:
/*  ... Parte anterior do menu ....
Rotina Auto		Rotina Auto		Rotina Auto        U_GP010AUT		1		xxxxxxxxxx		07		0	 	... Continuacao do menu ...*/
/*
User Function GP010AUT()

LOCAL aCabec   := {}
PRIVATE lMsErroAuto := .F.

//### Primeiro Funcionario ######################################### //
//-- Inclusão de 1 funcionário da matricula '880001'

aCabec   := {}
aadd(aCabec,{"RA_FILIAL" 		,"01 "								,Nil		})
aadd(aCabec,{"RA_MAT" 			,"880001"							,Nil		})
aadd(aCabec,{'RA_NOME'			,'FUNCIONARIO ROTINA AUTOMATICA'	,Nil		})
aadd(aCabec,{'RA_SEXO'			,'F'								,Nil		})
aadd(aCabec,{'RA_ESTCIVI'		,'C'								,Nil		})
aadd(aCabec,{'RA_NATURAL'		,'SP'								,Nil		})
aadd(aCabec,{'RA_NACIONA'		,'10'								,Nil		})
aadd(aCabec,{'RA_NASC'			,Stod('19731215')					,Nil		})
aadd(aCabec,{'RA_CC'			,'100100004'						,Nil		})
aadd(aCabec,{'RA_ADMISSA'		,Stod('20080505')					,Nil		})
aadd(aCabec,{'RA_OPCAO'			,Stod('20080505')					,Nil		})
aadd(aCabec,{'RA_BCDPFGT'		,'34100'							,Nil		})
aadd(aCabec,{'RA_CTDPFGT'		,'222285'							,Nil		})
aadd(aCabec,{'RA_HRSMES'		,220 								,Nil		})
aadd(aCabec,{'RA_HRSEMAN'		,44 								,Nil		})
aadd(aCabec,{'RA_CODFUNC'		,'00001'							,Nil		})
aadd(aCabec,{'RA_CATFUNC'		,'M'								,Nil		})
aadd(aCabec,{'RA_TIPOPGT'		,'M'								,Nil		})
aadd(aCabec,{'RA_TIPOADM'		,'9A'								,Nil		})
aadd(aCabec,{'RA_VIEMRAI'		,'10'								,Nil		})
aadd(aCabec,{'RA_GRINRAI'		,'50'								,Nil		})
aadd(aCabec,{'RA_HOPARC'		,'1'								,Nil		})
aadd(aCabec,{'RA_COMPSAB'		,'1'								,Nil		})
aadd(aCabec,{'RA_NUMCP'			,'1234567'							,Nil		})
aadd(aCabec,{'RA_SERCP'			,'150'								,Nil		})
aadd(aCabec,{'RA_TNOTRAB'		,'001'								,Nil		})
aadd(aCabec,{'RA_ADTPOSE'		,'***N**'							,Nil		})

U_Envia(aCabec)

Return(.T.)

//-- Função criada para exemplificar a chamada da execução da rotina de cadastro de funcionários

USER Function Envia(aCabec)
LOCAL nX

//-- Faz a chamada da rotina de cadastro de funcionários (opção 3)

MSExecAuto({|x,y,k,w| GPEA010(x,y,k,w)},NIL,NIL,aCabec,3)  //-- Opcao 3 - Inclusao registro

//-- Retorno de erro na execução da rotina

If lMsErroAuto
MostraErro()EndIfReturn(.T.)

RA_ITEM	,	C	,20,0,	Item
RA_ADMISSA	,	D	,8,0,	Data Admis.
RA_ALTADM	,	C	,1,0,	Alt.Admissao
RA_DEPIR	,	C	,2,0,	Dep. I.R.
RA_TIPOADM	,	C	,2,0,	Tipo Admiss.
RA_DEPSF	,	C	,2,0,	Dep.Sal.Fam.
RA_DEMISSA	,	D	,8,0,	Dt. Demissao
RA_OPCAO	,	D	,8,0,	Dt.Op.FGTS
RA_ALTOPC	,	C	,1,0,	Alt.Op ao
RA_BCDPFGT	,	C	,8,0,	Bco.Ag. FGTS
RA_CTDPFGT	,	C	,12,0,	Cta.Dep.FGTS
RA_CHAPA	,	C	,5,0,	Cod. Chapa.
RA_TNOTRAB	,	C	,3,0,	Turno Trab.
RA_LOCBNF	,	C	,4,0,	LOCAL Benef.
RA_PERFGTS	,	N	,5,2,	% Dep.Fgts
RA_BCDEPSA	,	C	,8,0,	Bco.Ag.D.Sal
RA_DESCTUR	,	C	,50,0,	Desc.Turno
RA_TPCTSAL	,	C	,1,0,	Tipo Cta Sal
RA_CTDEPSA	,	C	,12,0,	Cta.Dep.Sal.
RA_TPPREVI	,	C	,1,0,	Tp Previden.
RA_SITFOLH	,	C	,1,0,	Sit. Folha
RA_PROCES	,	C	,5,0,	Cod Processo
RA_HRSMES	,	N	,8,4,	Hrs. Mensais
RA_CATFUNC	,	C	,1,0,	Cat. Func.
RA_HRSEMAN	,	N	,5,2,	Hrs.Semanais
RA_HRSDIA	,	N	,7,4,	Horas Dia
RA_CODFUNC	,	C	,5,0,	Cod. Funcao
RA_DESCFUN	,	C	,20,0,	Desc.Funcao
RA_SALARIO	,	N	,12,2,	Sal rio
RA_ANTEAUM	,	N	,12,2,	Sal.Base.Dis
RA_PGCTSIN	,	C	,1,0,	Con.Sindical
RA_ADCPERI	,	C	,1,0,	Possui Per.?
RA_TIPOALT	,	C	,3,0,	Tpo.Alt.Sal.
RA_DATAALT	,	D	,8,0,	Dta.Alt.Sal.
RA_TPCONTR	,	C	,1,0,	Tp.Cont.Trab
RA_CESTAB	,	C	,1,0,	Cesta Basica
RA_DTFIMCT	,	D	,8,0,	Dt Term Cont
RA_TIPOCON	,	C	,1,0,	TpContDeterm
RA_VALEREF	,	C	,3,0,	Cd.Val.Ref.
RA_VALEALI	,	C	,3,0,	Cd.Val.Alim.
RA_HOPARC	,	C	,1,0,	Ct.T.Parcial
RA_CLAURES	,	C	,1,0,	Clau. Assec.
RA_SEGUROV	,	C	,2,0,	Seguro Vida
RA_PERCADT	,	N	,3,0,	% Adiantam.
RA_SINDICA	,	C	,2,0,	C. Sindicato
RA_PENSALI	,	N	,8,5,	% Pens.Alim.
RA_DESCSIN	,	C	,40,0,	Desc.Sindica
RA_CBO	,	C	,5,0,	C.B.O.  1994
RA_CODCBO	,	C	,6,0,	C.B.O. 2002
RA_ALTCBO	,	C	,1,0,	Alt. CBO
RA_TIPOPGT	,	C	,1,0,	Tipo Pgto.
RA_VIEMRAI	,	C	,2,0,	Vin.Emp.RAIS
RA_CATEG	,	C	,2,0,	Categ. SEFIP
RA_CATEFD	,	C	,3,0,	Cat. eSocial
RA_PERICUL	,	N	,6,2,	Hrs.Peric.
RA_VCTOEXP	,	D	,8,0,	Ven. Exper.1
RA_INSMIN	,	N	,6,2,	Hrs.Ins.Min.
RA_VCTEXP2	,	D	,8,0,	Vc.Exp.2Per.
RA_INSMED	,	N	,6,2,	Hrs.Ins.Med.
RA_EXAMEDI	,	D	,8,0,	Ven.Exa.Med.
RA_DTVTEST	,	D	,8,0,	Dt.Vto.Estab
RA_ADCINS	,	C	,1,0,	Possui Insal
RA_AFASFGT	,	C	,2,0,	Cod.Afa.FGTS
RA_ASSIST	,	C	,1,0,	Contr. Assis
RA_CONFED	,	C	,1,0,	Contr Confed
RA_MENSIND	,	C	,1,0,	Mens Sindica
RA_RESCRAI	,	C	,2,0,	Cd.Resc.RAIS
RA_MESESAN	,	N	,3,0,	Mes.Trab.Ant
RA_MESTRAB	,	C	,2,0,	Nr.Mes.Trab.
RA_FTINSAL	,	N	,6,2,	Multip.Insal
RA_CLASSEC	,	C	,2,0,	Classe Inss
RA_OCORREN	,	C	,2,0,	Ocorrencia
RA_PERCSAT	,	N	,8,4,	% Acid.Trab.
RA_CARGO	,	C	,5,0,	Cargo
RA_DCARGO	,	C	,30,0,	Desc. Cargo
RA_CODTIT	,	C	,2,0,	Titulac o
RA_POSTO	,	C	,9,0,	Cod. Posto
RA_DEPTO	,	C	,9,0,	Cod. Depto.
RA_ALTNOME	,	C	,1,0,	Alt.Nome
RA_CODRET	,	C	,4,0,	Cod.Retencao
RA_DDEPTO	,	C	,30,0,	Desc. Depto
RA_CRACHA	,	C	,12,0,	Nr. Cracha
RA_FECREI	,	D	,8,0,	Dt. Reinteg.
RA_REGRA	,	C	,2,0,	Regra Apont.
RA_DEMIANT	,	D	,8,0,	Dt. Dem. Ant
RA_MOLEST	,	D	,8,0,	Dt Afast Mol
RA_COMPSAB	,	C	,1,0,	Comp. S bado
RA_EAPOSEN	,	C	,1,0,	Aposentado
RA_NJUD14	,	C	,20,0,	ProcMenor 14
RA_SEQTURN	,	C	,2,0,	Seq.Ini.Turn
RA_TPREINT	,	C	,1,0,	Tp.Rein.eSoc
RA_SENHA	,	C	,6,0,	Senha
RA_NRPROC	,	C	,20,0,	Id. Proc.Jud
RA_NRLEIAN	,	C	,14,0,	Lei Anistia
RA_DTEFRET	,	D	,8,0,	Data Efeito
RA_DTEFRTN	,	D	,8,0,	Dt Efev Ret
RA_CIC	,	C	,11,0,	CPF
RA_NIVEL	,	C	,2,0,	Nivel Resp.
RA_PIS	,	C	,12,0,	P.I.S.
RA_ALTPIS	,	C	,1,0,	Alt.PIS
RA_TPRCBT	,	C	,1,0,	TP Recebim.
RA_TCFMSG	,	C	,6,0,	Mensagem
RA_RG	,	C	,15,0,	R.G.
RA_INSSSC	,	C	,1,0,	Desc.Inss.SC
RA_DTRGEXP	,	D	,8,0,	D t.Emis.RG
RA_RGUF	,	C	,2,0,	 UF do RG
RA_RGORG	,	C	,3,0,	Org.Emissor
RA_RGEXP	,	C	,6,0,	Orgao exp RG
RA_ORGEMRG	,	C	,5,0,	Org Emis RG
RA_DISTSN	,	C	,1,0,	Distrib.Doc.
RA_COMPLRG	,	C	,20,0,	Complem. RG
RA_BHFOL	,	C	,1,0,	B.H. p/ Folh
RA_NUMCP	,	C	,7,0,	Cart.Profis.
RA_SERCP	,	C	,5,0,	S rie Cart.
RA_UFCP	,	C	,2,0,	UF Cart.Prof
RA_ACUMBH	,	C	,1,0,	Acum.B.Horas
RA_DTCPEXP	,	D	,8,0,	Dt.Emis.CTPS
RA_OKTRANS	,	C	,2,0,	Marca Transf
RA_ALTCP	,	C	,1,0,	Alt.Car.Prof
RA_TABELA	,	C	,3,0,	Tabela Sal.
RA_TABNIVE	,	C	,2,0,	Nivel Tabela
RA_HABILIT	,	C	,11,0,	Cart.Habil.
RA_TABFAIX	,	C	,2,0,	Faixa Tabela
RA_CNHORG	,	C	,20,0,	CNH Emissor
RA_DTEMCNH	,	D	,8,0,	CNH DtEmis
RA_DTVCCNH	,	D	,8,0,	CNH Dt Val
RA_RECPFNC	,	C	,1,0,	Receb FNC
RA_TIPENDE	,	C	,1,0,	Tip.Endere o
RA_RESEXT	,	C	,1,0,	Res.Exterior
RA_TITULOE	,	C	,12,0,	Tit.Eleit.
RA_ZONASEC	,	C	,8,0,	Zona Eleit
RA_PAISEXT	,	C	,5,0,	Pa s Res Ext
RA_PAISEXN	,	C	,20,0,	N. Pa s Res
RA_SECAO	,	C	,4,0,	Se  o Eleit.
RA_LOGRTP	,	C	,4,0,	Tipo Lograd
RA_MEMOTCF	,	M	,80,0,	Mensagem
RA_REGISTR	,	C	,6,0,	No.Registro
RA_LOGRTPD	,	C	,10,0,	Des.Tp.Logr
RA_FICHA	,	C	,8,0,	Cod. Funcion
RA_LOGRDSC	,	C	,80,0,	Descr.Lograd
RA_SERVENT	,	C	,6,0,	C d. Servent
RA_LOGRNUM	,	C	,10,0,	NrLogradouro
RA_CODACER	,	C	,2,0,	C d. Acervo
RA_ENDEREC	,	C	,30,0,	Endere o
RA_REGCIVI	,	C	,2,0,	Reg. Civil
RA_CLASEST	,	C	,2,0,	Class. Estra
RA_TPLIVRO	,	C	,1,0,	Tipo Livro
RA_NUMENDE	,	C	,6,0,	Num.Endere o
RA_MSBLQL	,	C	,1,0,	Reg.Habilita
RA_COMPLEM	,	C	,30,0,	Compl.Ender.
RA_TIPCERT	,	C	,1,0,	Tip. Certid.
RA_EMICERT	,	D	,8,0,	Data Emiss o
RA_BAIRRO	,	C	,15,0,	Bairro
RA_ESTADO	,	C	,2,0,	Estado
RA_MATCERT	,	C	,32,0,	Termo/Matric
RA_LIVCERT	,	C	,8,0,	Livro
RA_CODMUN	,	C	,5,0,	Cod Municip
RA_FOLCERT	,	C	,4,0,	Folha
RA_CODMUNE	,	C	,80,0,	Nom Municip
RA_MUNICIP	,	C	,20,0,	Municipio
RA_CARCERT	,	C	,30,0,	Cart rio
RA_CEP	,	C	,8,0,	Cep
RA_UFCERT	,	C	,2,0,	UF
RA_CDMUCER	,	C	,5,0,	Cod.Mun.Cert
RA_CPOSTAL	,	C	,9,0,	Caixa Postal
RA_CEPCXPO	,	C	,8,0,	CEP C.Postal
RA_MUNCERT	,	C	,20,0,	Munic pio
RA_NUMEPAS	,	C	,15,0,	Num. Passap.
RA_ALTEND	,	C	,1,0,	Alterou End.
RA_EMISPAS	,	C	,15,0,	Emissor Pass
RA_DDDFONE	,	C	,2,0,	DDD Telefone
RA_TIPAMED	,	C	,1,0,	Tipo As. Med
RA_UFPAS	,	C	,2,0,	UF Passaport
RA_TELEFON	,	C	,20,0,	Telefone
RA_ASMEDIC	,	C	,2,0,	Cod.Ass.Med.
RA_DDDCELU	,	C	,2,0,	DDD Celular
RA_DEMIPAS	,	D	,8,0,	Dt Emis Pass
RA_DPASSME	,	C	,2,0,	Dep.Ass.Med.
RA_DVALPAS	,	D	,8,0,	Dt Val Pass
RA_TPASODO	,	C	,1,0,	Tp Ass Odon
RA_NUMCELU	,	C	,10,0,	Num. Celular
RA_CODPAIS	,	C	,5,0,	Cd.Pais Emis
RA_CHIDENT	,	C	,25,0,	Ch.Identific
RA_ASODONT	,	C	,2,0,	Cod As Odont
RA_PAISPAS	,	C	,20,0,	Pa s Emiss o
RA_NUMRIC	,	C	,12,0,	Numero RIC
RA_EMISRIC	,	C	,10,0,	Emissor RIC
RA_UFRIC	,	C	,2,0,	UF RIC
RA_CDMURIC	,	C	,5,0,	Cod.Mun. RIC
RA_NUMINSC	,	C	,11,0,	Num Insc Aut
RA_SERVICO	,	C	,60,0,	Tp Serv Aut
RA_MUNIRIC	,	C	,20,0,	Nome Mun.RIC
RA_DEXPRIC	,	D	,8,0,	Dt.Exped RIC
RA_CATCNH	,	C	,1,0,	CNH Categ.
RA_CODIGO	,	C	,14,0,	Cod Profiss
RA_UFCNH	,	C	,2,0,	CNH UF
RA_OCEMIS	,	C	,20,0,	OrgClEmissor
RA_OCDTEXP	,	D	,8,0,	OrgCl DtEmis
RA_RESERVI	,	C	,12,0,	Nr.Reservis.
RA_OCDTVAL	,	D	,8,0,	OrgCl Dt Val
RA_CODUNIC	,	C	,30,0,	C d. nico
RA_PRCFCH	,	C	,5,0,	Proc.Fechado
RA_PERFCH	,	C	,6,0,	Per. Fechado
RA_ROTFCH	,	C	,3,0,	Rot. Fechado
RA_NUPFCH	,	C	,2,0,	Num Pag Fech
RA_RNE	,	C	,14,0,	N mero RNE
RA_RNEORG	,	C	,20,0,	Org.Emis.RNE
RA_RNEDEXP	,	D	,8,0,	Dt.Exp.RNE
RA_DATCHEG	,	D	,8,0,	Data Chegada
RA_ANOCHEG	,	C	,2,0,	Ano Chegada
RA_NUMNATU	,	C	,10,0,	Naturalizac.
RA_DATNATU	,	D	,8,0,	D.Naturaliza
RA_CASADBR	,	C	,1,0,	Casado Bras.
RA_FILHOBR	,	C	,1,0,	Filho Bras.
RA_INSSAUT	,	C	,1,0,	Calc. INSS
RA_REGIME	,	C	,1,0,	Regime
RA_FWIDM	,	C	,34,0,	IDM
RA_DESEPS	,	C	,254,0,	Desc Rem Var
RA_INSMAX	,	N	,6,2,	Hrs. Insal.
RA_ADCCONF	,	N	,6,2,	% Adc.Conf.
RA_ADCTRF	,	N	,6,2,	%Adc.Trf.
RA_PLSAUDE	,	C	,1,0,	Pl.Sa de
RA_RHEXP	,	C	,6,0,	Contr.Exp.RH
RA_ADTPOSE	,	C	,6,0,	Adc.Tmp.Serv
RA_TPJORNA	,	C	,1,0,	Tp Reg.J.Tra
RA_FITIPEN	,	C	,8,0,	Fil.Tit.Pens
RA_MATIPEN	,	C	,6,0,	Mat.Tit.Pens
RA_TIPOPEN	,	C	,1,0,	Tp.Pensionis
RA_APOSENT	,	D	,8,0,	Dt.Aposent.
RA_SUBCARR	,	N	,12,2,	Sub.Carreira
RA_DTNOMEA	,	D	,8,0,	Dt. Nomeacao
RA_DEFETIV	,	D	,8,0,	Dt.Efetivac.
RA_CODCON	,	C	,4,0,	Cod.Concurso
RA_ADICEDI	,	C	,1,0,	Tp.Adi/Cedid
RA_JORNRED	,	N	,5,2,	Jorn.Reduz.
RA_TPSBCOM	,	C	,1,0,	Tp.Subs.Com.
RA_DTHREST	,	D	,8,0,	Dt.Hor.Estd.
RA_TPCUEST	,	C	,1,0,	Tp.Curso Est
RA_ANOSEME	,	N	,2,0,	Ano/Sem.Est.
RA_PERESTU	,	C	,1,0,	Per. Estud.
RA_PLAPRE	,	C	,14,0,	Num. Insc.
RA_BLOQADM	,	C	,1,0,	Bloq. Admis.
RA_HABILMT	,	C	,1,0,	Cota Def.
RA_DTINCON	,	D	,8,0,	Dt Prim CNH
RA_DTCAGED	,	D	,8,0,	Data Caged
RA_CTRLEMA	,	N	,4,0,	Ctr.Vitalic.
RA_MATMIG	,	C	,20,0,	Mat Migra  o
RA_AUTMEI	,	C	,1,0,	MEI
RA_USRADM	,	C	,6,0,	Usr Adm
RA_TIPCTA	,	C	,1,0,	Tp. Inscr.
RA_CTPCD	,	C	,1,0,	Cota Def
RA_DESCEP	,	C	,1,0,	Ctr Mat TSV
RA_TIPOVIA	,	C	,1,0,	Tempo Resid.
RA_XPROTOC	,	C	,11,0,	N  Protocolo
RA_XDTCAD	,	D	,8,0,	Dt Cad ANTT
RA_XCERTCR	,	D	,8,0,	Venc Cert ES
RA_XCETCRF	,	D	,8,0,	Venc Cert FE
RA_XRES168	,	C	,20,0,	N  Res. 168
RA_XDTEXPE	,	D	,8,0,	Dt Exped 168
RA_XDTVENC	,	D	,8,0,	Dt Vct R 168
RA_XACADEM	,	C	,1,0,	Academia?
RA_XASSOC	,	C	,1,0,	AF 1001 ?
RA_XVTDESC	,	C	,1,0,	Desconta VT
RA_DTENTRA	,	D	,8,0,	Dt Ini Benef
RA_TIPINF	,	C	,1,0,	Incapacitado
RA_DTREC	,	D	,8,0,	Dt Rec Incap
RA_XBASEOP	,	C	,30,0,	Base Operac
RA_XPRATAC	,	C	,1,0,	Prata d Casa
RA_DIASCT	,	N	,6,0,	Qtd Dias CT
RA_USERLGI	,	C	,17,0,	Log de Inclu
RA_USERLGA	,	C	,17,0,	Log de Alter
RA_AUXUNIF	,	C	,1,0,	AUX UNIFORME
RA_MSEXP	,	C	,8,0,	Ident.Exp.
RA_XMSEXP1	,	C	,8,0,	Log API Glob
RA_XMSEXP2	,	C	,8,0,	Log API Glob
RA_XMSEXP3	,	C	,8,0,	Log API Glob
RA_XMSEXP4	,	C	,8,0,	Log API Glob
RA_TOXEMIS	,	D	,8,0,	Emis toxicol
RA_TOXVENC	,	D	,8,0,	Venc Toxicol
RA_SEGVIDA	,	C	,1,0,	Segur Vida?
RA_XLOCVA	,	C	,4,0,	Loc.Bn.VA VR


*/
