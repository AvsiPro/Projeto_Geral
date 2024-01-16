#INCLUDE "Protheus.ch"
#INCLUDE "RESTFUL.ch"

//ws para pesquisa de funcionários por departamento/centro de custo
// parametros empresa e centro de custo/departamento/parte do nome e 1 para CC e 2 para departamento
//CLASS
Class JWSSRA02
    data    RA_FILIAL
    data    RA_MAT
    data    RA_NOME
    data    RA_CIC
    data    RA_EMAIL
    data    RA_EMAIL2
    data    RA_DEPTO
    data    RA_CC
    data    RA_TPCONTR
    data    RA_TELEFON
    METHOD New()

EndClass

METHOD New() Class JWSSRA02

    Self:RA_FILIAL                := ""
    Self:RA_MAT               := ""
    Self:RA_NOME                := ""
    Self:RA_CIC              := ""
    Self:RA_EMAIL             := ""
    Self:RA_EMAIL2              := ""
    Self:RA_DEPTO                 := ""
    Self:RA_CC             := ""
    Self:RA_TPCONTR              := ""
    Self:RA_TELEFON                 := ""
Return

WSRESTFUL JWSSRA02 DESCRIPTION "Rest de Funcionários"
    WSMETHOD GET DESCRIPTION "Obtem dados dos funcionários por departamento ou centro de custo." WSSYNTAX "/JWSSRA02/{empresa/depccnome/tipo}"
ENDWSRESTFUL

WSMETHOD GET WSSERVICE JWSSRA02

    LOCAL lRet := .T.
    LOCAL cSeek := ""
    LOCAL nInd := 0
    LOCAL lFilok := .f.
    LOCAL aFunc := {}
    LOCAL cQuery := ""
    LOCAL oResponse     := JsonObject():New()
    PRIVATE cBusca := ""

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
        //valido se filial digitada existe na base
        MyOpenSM0()
        SM0->( DBGOTOP() )
        WHILE !SM0->( EOF() ) .or. !lFilok
            //            IF padl(::aURLParms[1],2,"0") == ALLTRIM(SM0->M0_CODFIL)
            IF padl(::aURLParms[1],8,"0") == ALLTRIM(SM0->M0_CODFIL)
                cFilant := ALLTRIM(SM0->M0_CODFIL)
                lFilok := .t.
            ENDIF
            SM0->( DBSKIP() )
        ENDDO

        IF !lFilok
            lRet := .F.
            oResponse['code'] := 2
            oResponse['status'] := 404
            oResponse['message'] := 'Confira a filial digitada.'
            oResponse['detailedMessage'] := ''
        ELSE
            IF LEN(self:aURLParms) == 3

                cBusca := ::aURLParms[2]
                cBusca :=  NewCGCCPF(cBusca)

                IF ALLTRIM(self:aURLParms[3]) == "2"//departamento
                    IF VAL(cBusca) == 0
                        //retorno erro com regra do parametro 2
                        lRet := .F.
                        oResponse['code'] := 2
                        oResponse['status'] := 404
                        oResponse['message'] := 'pesquisa por departamento confira o segundo parametro.'
                        oResponse['detailedMessage'] := 'informe um departamento válido'
                    ELSE
                        cSeek := PADR(STRZERO( VAL(cBusca),9), TAMSX3('RA_DEPTO') [1]) //RA_FILIAL+RA_DEPTO+RA_MAT 21
                        nInd := 21
                    ENDIF

                ELSEIF ALLTRIM(self:aURLParms[3]) == "1" //centro de custo
                    IF VAL(cBusca) == 0
                        //retorno erro com regra do parametro 2
                        lRet := .F.
                        lRet := .F.
                        oResponse['code'] := 4
                        oResponse['status'] := 404
                        oResponse['message'] := 'pesquisa por centro de custo confira o segundo parametro.'
                        oResponse['detailedMessage'] := 'informe um departamento válido'
                        //SetRestFault( 404, "pesquisa por centro de custo confira o segundo parametro." )
                    ELSE
                        // cSeek := PADR(STRZERO( VAL(cBusca),9), TAMSX3('RA_CC') [1]) //RA_FILIAL+RA_CC+RA_MAT 2
                        cSeek := PADR(STRZERO( VAL(cBusca),9), TAMSX3('RA_CC') [1]) //RA_FILIAL+RA_CC+RA_MAT 2
                        nInd := 2
                    ENDIF
                ELSEIF ALLTRIM(self:aURLParms[3]) == "3" //PARTE DO NOME

                    cSeek := UPPER(ALLTRIM(self:aURLParms[2]))

                    cQuery := "SELECT RA_FILIAL, RA_MAT, RA_NOME, RA_CIC, RA_EMAIL, RA_EMAIL2, RA_DEPTO, RA_CC, RA_TPCONTR, RA_TELEFON "
                    cQuery += "FROM "+ RetSQLName('SRA')+" RA "
                    cQuery += "WHERE RA_FILIAL ='" +xFilial('SRA')+"' AND RA_NOME LIKE '%"+ cSeek +"%' AND RA.D_E_L_E_T_=''"

                    If Select("TMP")<>0
                        DbSelectArea("TMP")
                        DbCloseArea()
                    EndIf

                    cQuery := ChangeQuery(cQuery)
                    DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),'TMP',.F.,.T.	)

                    dbSelectArea("TMP")
                    TMP->(dbGoTop())

                    While TMP->(!EOF())
                        oFunc                 := JWSSRA02():New()
                        oFunc:RA_FILIAL         := ALLTRIM(TMP->RA_FILIAL)
                        oFunc:RA_MAT         := ALLTRIM(TMP->RA_MAT)
                        oFunc:RA_NOME             := ALLTRIM(TMP->RA_NOME)
                        oFunc:RA_CIC               := ALLTRIM(TMP->RA_CIC)
                        oFunc:RA_EMAIL             := ALLTRIM(TMP->RA_EMAIL)
                        oFunc:RA_EMAIL2            := ALLTRIM(TMP->RA_EMAIL2)
                        oFunc:RA_DEPTO             := ALLTRIM(TMP->RA_DEPTO)
                        oFunc:RA_CC               := ALLTRIM(TMP->RA_CC)
                        oFunc:RA_TPCONTR            := ALLTRIM(TMP->RA_TPCONTR)
                        oFunc:RA_TELEFON            := ALLTRIM(TMP->RA_TELEFON)

                        AADD( aFunc, oFunc)

                        TMP->( DBSKIP() )
                    ENDDO
                    dbSelectArea("TMP")
                    dbCloseArea()
                    ::SetResponse(FWJsonSerialize(aFunc, .F., .T.))
                ELSE
                    lRet := .F.
                    oResponse['code'] := 5
                    oResponse['status'] := 404
                    oResponse['message'] := 'confira os parametros informados.'
                    oResponse['detailedMessage'] := '1° código da empresa / 2° centro de custo, departamento ou parte do nome / 3° 1 para centro de custo, 2 para departamento e 3 para parte do nome.'
                ENDIF
            ENDIF
        ENDIF

        IF lRet .AND. (ALLTRIM(self:aURLParms[3]) == "1" .OR. ALLTRIM(self:aURLParms[3]) == "2")
            SRA->( DBSETORDER(nInd) )
            If SRA->( DBSEEK( xFilial('SRA') + cSeek ) )
                WHILE !SRA->( EOF() ) .AND. IF(nInd == 2, SRA->RA_CC == cSeek,SRA->RA_DEPTO == cSeek)
                    oFunc                 := JWSSRA02():New()

                    oFunc                 := JWSSRA02():New()
                    oFunc:RA_FILIAL         := ALLTRIM(SRA->RA_FILIAL)
                    oFunc:RA_MAT         := ALLTRIM(SRA->RA_MAT)
                    oFunc:RA_NOME             := ALLTRIM(SRA->RA_NOME)
                    oFunc:RA_CIC               := ALLTRIM(SRA->RA_CIC)
                    oFunc:RA_EMAIL             := ALLTRIM(SRA->RA_EMAIL)
                    oFunc:RA_EMAIL2            := ALLTRIM(SRA->RA_EMAIL2)
                    oFunc:RA_DEPTO             := ALLTRIM(SRA->RA_DEPTO)
                    oFunc:RA_CC               := ALLTRIM(SRA->RA_CC)
                    oFunc:RA_TPCONTR            := ALLTRIM(SRA->RA_TPCONTR)
                    oFunc:RA_TELEFON            := ALLTRIM(SRA->RA_TELEFON)

                    AADD( aFunc, oFunc)

                    SRA->( DBSKIP() )
                ENDDO
                ::SetResponse(FWJsonSerialize(aFunc, .F., .T.))
            else
                lRet := .F.
                oResponse['code'] := 5
                oResponse['status'] := 404
                oResponse['message'] := 'Colaboradores não locaizados.'
                oResponse['detailedMessage'] := ''
                //                SetRestFault( 404, "Colaborador não locaizado." )
            EndIf
        ENDIF
    else
        lRet := .F.
        oResponse['code'] := 5
        oResponse['status'] := 404
        oResponse['message'] := 'Uso incorreto do servico.'
        oResponse['detailedMessage'] := ''
        //SetRestFault( 400, "Uso incorreto do servico." )
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

//----------------------------------------------------------
// Funcao Auxiliar para retirar a máscara do campo CNPJ/CPF:
//----------------------------------------------------------
Static Function NewCGCCPF(cBusca)

    LOCAL aInvChar := {"/",".","-"}
    LOCAL nI

    For nI:=1 to Len(aInvChar)
        cBusca := StrTran(cBusca,aInvChar[nI])
    Next

Return cBusca

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
