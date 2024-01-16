#INCLUDE "Protheus.ch"
#INCLUDE "RESTFUL.ch"
#include "FWMVCDEF.CH"

/*
    API
    Get obtem dados da RFO
    Doc Mit   
    
*/

Class JWSRFO01
    data    RFO_FILIAL
    data    RFO_TPVALE
    data    RFO_CODIGO
    data    RFO_DESCR
    data    RFO_TPBEN
    METHOD New()
EndClass

METHOD New() Class JWSRFO01
    Self:RFO_FILIAL              := ""
    Self:RFO_TPVALE               := ""
    Self:RFO_CODIGO             := ""
    Self:RFO_DESCR               := ""
    Self:RFO_TPBEN               := ""
Return

WSRESTFUL JWSRFO01 DESCRIPTION "Rest de VT - GESTÃO DE PESSOAS"
    WSMETHOD GET DESCRIPTION "Obtem os dados da RFO" WSSYNTAX "/JWSRFO01/{EMPRESA/TIPO DE BENEFICIO/}"
ENDWSRESTFUL

WSMETHOD GET WSSERVICE JWSRFO01
    LOCAL lRet := .T.
    LOCAL cTabela := ""
    LOCAL aCampos := {}
    LOCAL nX := 0
    LOCAL nLinha := 0
    LOCAL lFilok := .F.
    LOCAL oResponse     := JsonObject():New()
    LOCAL oCampo     := JsonObject():New()
    local oFunc
    LOCAL cQuery := ""
    LOCAL aRFO := {}

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
            IF padl(::aURLParms[1],8,"0") == ALLTRIM(SM0->M0_CODFIL)
            //IF padl(::aURLParms[1],2,"0") == ALLTRIM(SM0->M0_CODFIL)
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

        IF lRet
            cTabela := "RFO"//UPPER(ALLTRIM(::aURLParms[2]))
            oStruSTAB  := FWFormStruct( 1, cTabela , /* bAvalCampo */, /* lViewUsado */ )
            aFields   := oStruSTAB:aFields//oStruTAB:GetStruct():GetFields()
            nX := 0
            For nX := 1 To Len( aFields )
                AADD(aCampos,{aFields[nX,3],aFields[nX,4]})
            Next nX
            //CONSULTO RFO PELA EMPRESA E MATRICULA
            IF LEN(self:aURLParms) == 2
                cSeek := ALLTRIM(::aURLParms[2])
                RFO->( DBSETORDER(1) )//::aURLParms[2]
                IF RFO->( DBSEEK( xFilial(cTabela) + cSeek ) ) //.AND. lRet]
                    oCampo['DADOS']   := {}
                    nLinha := 0
                    WHILE !RFO->( EOF() ) .AND. RFO->RFO_TPVALE == cSeek
                        AADD( oCampo['DADOS'], JsonObject():New() )

                        nLinha += 1

                        FOR nX := 1 to len(aCampos)
                            IF aCampos[nX,2]=="C"
                                oCampo['DADOS'][nLinha][aCampos[nX,1]] :=  EncodeUTF8(RFO->&(aCampos[nX,1]),"cp1252")
                            ELSEIF aCampos[nX,2]=="D"
                                oCampo['DADOS'][nLinha][aCampos[nX,1]] :=  RFO->&(aCampos[nX,1])
                            ELSEIF aCampos[nX,2]=="N"
                                oCampo['DADOS'][nLinha][aCampos[nX,1]] :=  RFO->&(aCampos[nX,1])
                            ENDIF
                        NEXT nX
                        RFO->( DBSKIP() )
                    ENDDO
                    ::SetResponse(FWJsonSerialize(oCampo, .F., .F., .T.))
                ELSE
                    lRet:= .F.
                    oResponse['code'] := 2
                    oResponse['status'] := 404
                    oResponse['message'] := 'Não foi encontrado nenhum registro para esse código e empresa informado!'
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
    ELSE
        cQuery := "SELECT RFO_FILIAL, RFO_TPVALE, RFO_CODIGO, RFO_DESCR, RFO_TPBEN "
        cQuery += "FROM "+ RetSQLName('RFO')+" RFO "
        cQuery += "WHERE RFO.D_E_L_E_T_=''"

        If Select("TMP")<>0
            DbSelectArea("TMP")
            DbCloseArea()
        EndIf

        cQuery := ChangeQuery(cQuery)
        DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),'TMP',.F.,.T.	)

        dbSelectArea("TMP")
        TMP->(dbGoTop())

        While TMP->(!EOF())
            oFunc                 := JWSRFO01():New()

            oFunc:RFO_FILIAL              := ALLTRIM(TMP->RFO_FILIAL)
            oFunc:RFO_TPVALE              := EncodeUTF8(ALLTRIM(TMP->RFO_TPVALE), "cp1252")
            oFunc:RFO_CODIGO              := ALLTRIM(TMP->RFO_CODIGO)
            oFunc:RFO_DESCR                := ALLTRIM(TMP->RFO_DESCR)
            oFunc:RFO_TPBEN              :=ALLTRIM(TMP->RFO_TPBEN)

            AADD( aRFO, oFunc)

            TMP->( DBSKIP() )
        ENDDO
        dbSelectArea("TMP")
        dbCloseArea()
        ::SetResponse(FWJsonSerialize(aRFO, .F., .T.))

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
