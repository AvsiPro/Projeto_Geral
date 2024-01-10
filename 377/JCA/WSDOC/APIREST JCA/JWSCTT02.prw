#INCLUDE "Protheus.ch"
#INCLUDE "RESTFUL.ch"

/*
    API
    GET de obtem os centros de custos cadastrados no Protheus
    Doc Mit   
    
*/

Class JWSCTT02
    data    COD_CCUSTO
    data    DES_CCUSTO
    data    CLA_CCUSTO
    data    SUP_CCUSTO
    METHOD New()
EndClass

METHOD New() Class JWSCTT02
    Self:COD_CCUSTO              := ""
    Self:DES_CCUSTO               := ""
    Self:CLA_CCUSTO             := ""
    Self:SUP_CCUSTO               := ""
Return

WSRESTFUL JWSCTT02 DESCRIPTION "Rest de Centro de custo"
    WSMETHOD GET DESCRIPTION "Obtem os centros de custos cadastrados no Protheus." WSSYNTAX "/JWSCTT02"
ENDWSRESTFUL


WSMETHOD GET WSSERVICE JWSCTT02
    LOCAL lRet := .T.
    LOCAL aCusto := {}
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
        cQuery := "SELECT CTT_CUSTO, CTT_DESC01,CTT_CLASSE,CTT_CCSUP "
        cQuery += "FROM "+ RetSQLName('CTT')+" CTT "
        cQuery += "WHERE CTT_FILIAL ='" +xFilial('CTT')+"'AND CTT_BLOQ <> '1' AND CTT.D_E_L_E_T_=''"

        If Select("TMP")<>0
            DbSelectArea("TMP")
            DbCloseArea()
        EndIf

        cQuery := ChangeQuery(cQuery)
        DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),'TMP',.F.,.T.	)

        dbSelectArea("TMP")
        TMP->(dbGoTop())

        While TMP->(!EOF())
            oFunc                 := JWSCTT02():New()

            oFunc:COD_CCUSTO              := ALLTRIM(TMP->CTT_CUSTO)
            oFunc:DES_CCUSTO              := EncodeUTF8(ALLTRIM(TMP->CTT_DESC01), "cp1252")
            oFunc:CLA_CCUSTO              := ALLTRIM(TMP->CTT_CLASSE)
            oFunc:SUP_CCUSTO              := ALLTRIM(TMP->CTT_CCSUP)

            AADD( aCusto, oFunc)

            TMP->( DBSKIP() )
        ENDDO
        dbSelectArea("TMP")
        dbCloseArea()
        ::SetResponse(FWJsonSerialize(aCusto, .F., .T.))

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
