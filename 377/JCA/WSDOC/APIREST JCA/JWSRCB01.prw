#INCLUDE "Protheus.ch"
#INCLUDE "RESTFUL.ch"
#include "FWMVCDEF.CH"

/*
    API
    Api de GET RCB e RCC
    Doc Mit   
*/

Class JWSRCB01
    data    TABELA
    data    CAMPO
    data    DESCRICAO
    data    CONTEUDO
    data    SEQUEN
    METHOD New()
EndClass

METHOD New() Class JWSRCB01
    Self:TABELA              := ""
    Self:CAMPO              := ""
    Self:DESCRICAO         := ""
    Self:CONTEUDO         := ""
    Self:SEQUEN         := ""
Return

WSRESTFUL JWSRCB01 DESCRIPTION "GET para as tabelas S do módulo RH"
    WSMETHOD GET DESCRIPTION "RETORNA TABELA RCB e RCC" WSSYNTAX "/JWSRCB01/{EMPRESA/TABELA/}"
ENDWSRESTFUL

WSMETHOD GET WSSERVICE JWSRCB01

    LOCAL lRet := .T.
    LOCAL nX := 0
    LOCAL nLinha := 0
    LOCAL lFilok := .F.
    LOCAL aRCB := {}
    LOCAL aRet := {}
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
            IF padl(::aURLParms[1],8,"0") == ALLTRIM(SM0->M0_CODFIL)
                cFilant := ALLTRIM(SM0->M0_CODFIL)
                lFilok := .T.
            ENDIF
            SM0->( DBSKIP() )
        ENDDO

        IF !lFilok
            lRet := .F.
            oResponse['code'] := 2
            oResponse['status'] := 404
            oResponse['message'] := 'Confira a filial digitada.'
            oResponse['detailedMessage'] := ''
        ENDIF
    ENDIF

    IF lRet

        DBSELECTAREA("RCB")
        //CONSULTO RCB PELA EMPRESA E MATRICULA
        IF LEN(self:aURLParms) == 1
            //cSeek := ::aURLParms[1]
            RCB->( DBSETORDER(1) )//::aURLParms[2]
            IF RCB->( DBSEEK( xFilial("RCB") ) ) //.AND. lRet]
                oCampo['DADOS']   := {}
                nLinha := 0
                WHILE !RCB->( EOF() )

                    IF RCB->RCB_ORDEM == "01"
                        nLinha += 1

                        AADD( oCampo['DADOS'], JsonObject():New() )

                        oCampo['DADOS'][nLinha]["RCB_FILIAL"] :=  RCB->RCB_FILIAL
                        oCampo['DADOS'][nLinha]["RCB_CODIGO"] :=  RCB->RCB_CODIGO
                        oCampo['DADOS'][nLinha]["RCB_DESC"] :=  EncodeUTF8(RCB->RCB_DESC,"cp1252")
                    ENDIF

                    RCB->( DBSKIP() )
                ENDDO

                ::SetResponse(FWJsonSerialize(oCampo, .F., .F., .T.))
            ELSE
                lRet:= .F.
                oResponse['code'] := 2
                oResponse['status'] := 404
                oResponse['message'] := 'Não foi encontrado nenhum registro nessa empresa!'
                oResponse['detailedMessage'] := ''
            ENDIF
        ELSEIF LEN(self:aURLParms) == 2
            cSeek := ::aURLParms[2]
            RCB->( DBSETORDER(1) )//::aURLParms[2]
            IF RCB->( DBSEEK( xFilial("RCB") + cSeek) ) //.AND. lRet]

                // oCampo['DADOS']   := {}
                // nLinha := 0
                WHILE !RCB->( EOF() ) .AND. cSeek == RCB->RCB_CODIGO

                    AADD(aRCB,{RCB->RCB_ORDEM,RCB->RCB_CODIGO,RCB->RCB_CAMPOS,RCB->RCB_TIPO,RCB->RCB_TAMAN,RCB->RCB_DECIMA,RCB->RCB_DESCPO})

                    RCB->( DBSKIP() )
                ENDDO
                aSort(aRCB, , , {|x, y| x[1] < y[1]})

                //oCampo['DADOS']   := {}

                //RCC_FILIAL+RCC_CODIGO+RCC_FIL+RCC_CHAVE+RCC_SEQUEN
                DBSELECTAREA("RCC")
                //CONSULTO RCB PELA EMPRESA E MATRICULA
                RCC->( DBSETORDER(1) )//::aURLParms[2]
                IF RCC->( DBSEEK( xFilial("RCC") +  cSeek ))//+ cFilant) ) //.AND. lRet]
                    WHILE !RCC->( EOF() ) .and. cSeek == RCC->RCC_CODIGO
                        cConte := RCC->RCC_CONTEU
                        nX := 0
                        nTam := 0
                        FOR nX := 1 to LEN(aRCB)
                            oDepto                 := JWSRCB01():New()
                            // nLinha += 1

                            // AADD( oCampo['DADOS'], JsonObject():New() )
                            oDepto:TABELA               := ALLTRIM(aRCB[nX,2])
                            oDepto:CAMPO                := EncodeUTF8(ALLTRIM(aRCB[nX,3]), "cp1252")
                            oDepto:DESCRICAO            := ALLTRIM(aRCB[nX,7])
                            oDepto:CONTEUDO             := EncodeUTF8( SUBSTR(cConte,IIF(nX==1,nTam,nTam+1),aRCB[nX,5] ),"cp1252")
                            oDepto:SEQUEN               := RCC->RCC_SEQUEN
                            
                            nTam += aRCB[nX,5]

                            AADD( aRet, oDepto)

                        NEXT nx
                        RCC->( DBSKIP() )
                    ENDDO

                ENDIF

                ::SetResponse(FWJsonSerialize(aRet, .F., .T.))

            ELSE
                lRet:= .F.
                oResponse['code'] := 2
                oResponse['status'] := 404
                oResponse['message'] := 'Não foi encontrado nenhum registro para essa tabela nessa empresa!'
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
