#INCLUDE "Protheus.ch"
#INCLUDE "RESTFUL.ch"

//ws para retorno de DEPARTAMENTOS DO RH
// parametros empresa e centro de custo
//CLASS

Class JWSSQB01
    data    COD_DEPTO
    data    DES_DEPTO
    data    EMP_RESP_DEPTO
    data    FIL_RESP_DEPTO
    data    MAT_RESP_DEPTO
    data    DEP_SUP_DEPTO
    METHOD New()
EndClass

METHOD New() Class JWSSQB01
    Self:COD_DEPTO              := ""
    Self:DES_DEPTO              := ""
    Self:EMP_RESP_DEPTO         := ""
    Self:FIL_RESP_DEPTO         := ""
    Self:MAT_RESP_DEPTO         := ""
    Self:DEP_SUP_DEPTO          := ""
Return

WSRESTFUL JWSSQB01 DESCRIPTION "Rest de Departamentos RH"
    WSMETHOD GET DESCRIPTION "Obtem dados dos departamento do modulo RH." WSSYNTAX "/JWSSQB01"
ENDWSRESTFUL

WSMETHOD GET WSSERVICE JWSSQB01
    //RETORNAR EMPRESA RESP, FILIAL RESP, MATRIC RESP E DEP SUPERIOR
    LOCAL lRet := .T.
    LOCAL aDepto := {}
    LOCAL cQuery := ""
    LOCAL oResponse     := JsonObject():New()
    PRIVATE cBusca := ""

    ::SetContentType("application/json")

    IF !MyOpenSM0()
        lRet:= .F.
        oResponse['code'] := 1
        oResponse['status'] := 500
        oResponse['message'] := 'Falha ao abrir ambiente de trabalho!'
        oResponse['detailedMessage'] := ''
    ENDIF

    IF lRet
        cQuery := "SELECT QB_DEPTO, QB_DESCRIC, QB_EMPRESP, QB_FILRESP, QB_MATRESP, QB_DEPSUP "
        cQuery += "FROM "+ RetSQLName('SQB')+" QB "
        cQuery += "WHERE QB_FILIAL ='" +xFilial('SQB')+"' AND QB.D_E_L_E_T_=''"

        If Select("TMP")<>0
            DbSelectArea("TMP")
            DbCloseArea()
        EndIf

        cQuery := ChangeQuery(cQuery)
        DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),'TMP',.F.,.T.	)

        dbSelectArea("TMP")
        TMP->(dbGoTop())

        While TMP->(!EOF())
            oDepto                 := JWSSQB01():New()

            oDepto:COD_DEPTO              := ALLTRIM(TMP->QB_DEPTO)
            oDepto:DES_DEPTO              := EncodeUTF8(ALLTRIM(TMP->QB_DESCRIC), "cp1252")
            oDepto:EMP_RESP_DEPTO         := ALLTRIM(TMP->QB_EMPRESP)
            oDepto:FIL_RESP_DEPTO         := ALLTRIM(TMP->QB_FILRESP)
            oDepto:MAT_RESP_DEPTO         := ALLTRIM(TMP->QB_MATRESP)
            oDepto:DEP_SUP_DEPTO          := ALLTRIM(TMP->QB_DEPSUP)

            AADD( aDepto, oDepto)

            TMP->( DBSKIP() )
        ENDDO
        dbSelectArea("TMP")
        dbCloseArea()
        ::SetResponse(FWJsonSerialize(aDepto, .F., .T.))

    ENDIF

    If !lRet
        SetRestFault( oResponse['code'],;
            oResponse['message'],;
            .T.,;
            oResponse['status'],;
            oResponse['detailedMessage'];
            )
    EndIf

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
