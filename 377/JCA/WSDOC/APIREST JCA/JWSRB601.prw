#INCLUDE "Protheus.ch"
#INCLUDE "RESTFUL.ch"

/*
    API
    Api GET Obtem dados das Faixas de salarios do modulo RH.
    Doc Mit   
    
*/

Class JWSJRB601
    data    RB6_TABELA
    data    RB6_DESCTA
    data    RB6_TIPOVL
    data    RB6_NIVEL
    data    RB6_FAIXA
    data    RB6_VALOR
    data    RB6_PTOMIN
    data    RB6_PTOMAX
    data    RB6_CLASSE
    
    data    RB6_DTREF
    data    RB6_COEFIC
    data    RB6_REGIAO
    data    RB6_ATUAL

    METHOD New()
EndClass

METHOD New() Class JWSJRB601
    Self:RB6_TABELA              := ""
    Self:RB6_DESCTA              := ""
    Self:RB6_TIPOVL         := ""
    Self:RB6_NIVEL        := ""
    Self:RB6_FAIXA         := ""
    Self:RB6_VALOR          := ""
    Self:RB6_PTOMIN             := ""
    Self:RB6_PTOMAX              := ""
    Self:RB6_CLASSE              := ""
    Self:RB6_DTREF        := ""
    Self:RB6_COEFIC         := ""
    Self:RB6_REGIAO          := ""
    Self:RB6_ATUAL          := ""
Return


WSRESTFUL JWSJRB601 DESCRIPTION "Rest de Faixas de salarios RB6  RH"
    WSMETHOD GET DESCRIPTION "Obtem dados das Faixas de salarios do modulo RH." WSSYNTAX "/JWSJRB601"
ENDWSRESTFUL

WSMETHOD GET WSSERVICE JWSJRB601
    //RETORNAR EMPRESA RESP, FILIAL RESP, MATRIC RESP E DEP SUPERIOR
    LOCAL lRet := .T.
    LOCAL aDepto := {}
    LOCAL cQuery := ""
    LOCAL oResponse     := JsonObject():New()
    PRIVATE cBusca := ""

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
        cQuery := "SELECT RB6_TABELA, RB6_DESCTA, RB6_TIPOVL, RB6_NIVEL , RB6_FAIXA , RB6_VALOR, RB6_PTOMIN, RB6_PTOMAX, RB6_CLASSE, RB6_DTREF, RB6_COEFIC, RB6_REGIAO, RB6_ATUAL  "
        cQuery += "FROM "+ RetSQLName('RB6')+" RB6 "
        cQuery += "WHERE RB6_FILIAL ='" +xFilial('RB6')+"' AND RB6.D_E_L_E_T_=''"

        If Select("TMP")<>0
            DbSelectArea("TMP")
            DbCloseArea()
        EndIf

        cQuery := ChangeQuery(cQuery)
        DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),'TMP',.F.,.T.	)

        dbSelectArea("TMP")
        TMP->(dbGoTop())

        While TMP->(!EOF())
            oDepto                 := JWSJRB601():New()
       
            oDepto:RB6_TABELA              := EncodeUTF8(ALLTRIM(TMP->RB6_TABELA), "cp1252")
            oDepto:RB6_DESCTA              := EncodeUTF8(ALLTRIM(TMP->RB6_DESCTA), "cp1252")
            oDepto:RB6_TIPOVL              := EncodeUTF8(ALLTRIM(TMP->RB6_TIPOVL ), "cp1252")
            oDepto:RB6_NIVEL               := EncodeUTF8(ALLTRIM(TMP->RB6_NIVEL), "cp1252")
            oDepto:RB6_FAIXA                := EncodeUTF8(ALLTRIM(TMP->RB6_FAIXA ), "cp1252")
            oDepto:RB6_VALOR                := EncodeUTF8(TRANSFORM(TMP->RB6_VALOR,"@E 999999.99"), "cp1252")
            oDepto:RB6_PTOMIN               := EncodeUTF8(CVALTOCHAR(TMP->RB6_PTOMIN), "cp1252")
            oDepto:RB6_PTOMAX               := EncodeUTF8(CVALTOCHAR(TMP->RB6_PTOMAX), "cp1252")
            oDepto:RB6_CLASSE               := EncodeUTF8(ALLTRIM(TMP->RB6_CLASSE ), "cp1252")
            oDepto:RB6_DTREF                := EncodeUTF8(ALLTRIM(TMP->RB6_DTREF), "cp1252")
            oDepto:RB6_COEFIC           := EncodeUTF8(ALLTRIM(TMP->RB6_COEFIC), "cp1252")
            oDepto:RB6_REGIAO          := EncodeUTF8(ALLTRIM(TMP->RB6_REGIAO), "cp1252")
            oDepto:RB6_ATUAL          := EncodeUTF8(ALLTRIM(TMP->RB6_ATUAL ), "cp1252")

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
