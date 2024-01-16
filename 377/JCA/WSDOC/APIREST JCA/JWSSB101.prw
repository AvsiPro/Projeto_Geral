#INCLUDE "Protheus.ch"
#INCLUDE "RESTFUL.CH"
#Include "rwmake.ch"
#Include "tbiconn.ch"

/*
    API
    Get Retorna o produto cadastrado no sistema SB1
    Doc Mit   
    
*/

WSRESTFUL Produto DESCRIPTION "API de gestão de Produtos"
    WSMETHOD GET DESCRIPTION 'Retorna o produto cadastrado no sistema' WSSYNTAX '/Produto/{id}'
ENDWSRESTFUL

WSMETHOD GET WSSERVICE Produto
    LOCAL lRet          := .T.
    LOCAL nOrd :=   0
    local  cSeek  := ""
    local n  := 0
    LOCAL oResponse     := JsonObject():New()


    RpcClearEnv()
    RpcSetType(3)
    //RPCSetEnv('99','01')
    RPCSetEnv('01','00020087')

    ::SetContentType("application/json")

    IF !MyOpenSM0()
        lRet:= .F.
        SetRestFault( 500, "Falha ao abrir ambiente de trabalho!")
    ELSE
        IF LEN( ::aURLParms) > 0
            cSeek := ALLTRIM(::aURLParms[1])
            IF LEN(cSeek) > 4
                cSeek := PADR( cSeek , tamsx3('B1_COD')[1])
                nOrd := 1
            ELSE
                cSeek := PADR( cSeek , tamsx3('B1_GRUPO')[1])
                nOrd := 4
            ENDIF
            SB1->( DBSETORDER(nOrd) )
            IF SB1->( DBSEEK( xFilial('SB1') + cSeek ))
                oResponse['data'] := {}

                while !SB1->(eof()) .AND. IIF(nOrd == 1,alltrim(cSeek) == alltrim(SB1->B1_COD),alltrim(cSeek) == alltrim(SB1->B1_GRUPO))
                    n += 1
                    //oResponse['data'] := {}
                    AADD( oResponse['data'], JsonObject():New() )

                    SX3->( DBSETORDER(1) )
                    SX3->( DBSEEK( 'SB1' ) )
                    WHILE !SX3->( EOF() ) .AND. SX3->X3_ARQUIVO == 'SB1'
                        CAMPO := ALLTRIM( SX3->X3_CAMPO)
                        IF X3USO( SX3->X3_USADO) .AND. SX3->X3_CONTEXT != 'V'
                            //CONVERTER PARA CARACTER
                            IF !EMPTY(ALLTRIM(SB1->&(CAMPO)))
                                IF SX3->X3_TIPO     == 'C'
                                    oResponse['data'][n][CAMPO] := EncodeUTF8(ALLTRIM(SB1->&(CAMPO)),"cp1252")
                                ELSEIF SX3->X3_TIPO == 'N'
                                    oResponse['data'][n][CAMPO] := cValToChar(SB1->&(CAMPO))
                                ELSEIF SX3->X3_TIPO == 'D'
                                    oResponse['data'][n][CAMPO] := DTOC(SB1->&(CAMPO))
                                ENDIF
                            ENDIF
                        ENDIF
                        SX3->( DBSKIP() )
                    ENDDO
                    SB1->( DBSKIP() )
                ENDDO

                ::SetResponse(FWJsonSerialize(oResponse, .F., .F., .T.))
            ELSE
                lRet := .F.
                SetRestFault(404, 'Produto nao encontrado')
            ENDIF
        ELSE
            lRet := .F.
            SetRestFault(400,   "Uso Incorreto do servico")
        ENDIF
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
