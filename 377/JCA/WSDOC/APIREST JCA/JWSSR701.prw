#INCLUDE "Protheus.ch"
#INCLUDE "RESTFUL.ch"
#include "FWMVCDEF.CH


WSRESTFUL JWSSR701 DESCRIPTION "GET consulta de ultima promoção"
    WSMETHOD GET DESCRIPTION "RETORNA Data mais recente na SR7" WSSYNTAX "/JWSSR701/{EMPRESA/MATRICULA/}"
ENDWSRESTFUL

WSMETHOD GET WSSERVICE JWSSR701

    LOCAL lRet := .T.
    LOCAL cMatric := ""
    LOCAL cFiPesq := ""
    LOCAL cQuery := ""
    LOCAL oResponse     := JsonObject():New()
    LOCAL oCampo     := JsonObject():New()

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
    ENDIF

    IF lRet
        If LEN(self:aURLParms) > 0
            cFiPesq := ALLTRIM(::aURLParms[1])
        ELSE
            lRet := .F.
            oResponse['code'] := 3
            oResponse['status'] := 404
            oResponse['message'] := 'Informe empresa e matricula.'
            oResponse['detailedMessage'] := ''
        ENDIF
    ENDIF

    IF lRet
        IF LEN(self:aURLParms) > 1
            cMatric := ALLTRIM(::aURLParms[2])

            cQuery := "SELECT MAX(R7_DATA) AS ULTPRO "
            cQuery += "FROM "+ RetSQLName('SR7')+" R7 "
            cQuery += "WHERE R7_FILIAL ='" + cFiPesq +"' AND R7_MAT = '"+ cMatric +"' AND R7.D_E_L_E_T_=''"

            IF Select("TMP")<>0
                DbSelectArea("TMP")
                DbCloseArea()
            ENDIF

            cQuery := ChangeQuery(cQuery)
            DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),'TMP',.F.,.T.	)

            dbSelectArea("TMP")
            TMP->(dbGoTop())

            oCampo['DADOS']   := {}
            AADD( oCampo['DADOS'], JsonObject():New() )

            IF TMP->(!EOF())
                   oCampo['DADOS'][1]["DTPROMO"] := substr(TMP->ULTPRO,7,2)+"/"+substr(TMP->ULTPRO,5,2)+"/"+substr(TMP->ULTPRO,1,4)//DTOC(STOD(TMP->ULTPRO))
            ELSE
                oCampo['DADOS'][1]["DTPROMO"] := ""
            ENDIF

            ::SetResponse(FWJsonSerialize(oCampo, .F., .F., .T.))

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
