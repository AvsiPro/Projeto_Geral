#INCLUDE "Protheus.ch"
#INCLUDE "RESTFUL.ch"
#include "FWMVCDEF.CH

/*
    API
    GET Obtem os dados da SM7
    Doc Mit  
    
*/


WSRESTFUL JWSBENVT DESCRIPTION "Rest de VT - va - vr - GESTÃO DE PESSOAS"
    WSMETHOD GET DESCRIPTION "Obtem os dados da SM7" WSSYNTAX "/JWSBENVT/{EMPRESA/MATRICULA/}"
ENDWSRESTFUL


WSMETHOD GET WSSERVICE JWSBENVT
    LOCAL lRet := .T.
    LOCAL cTabela := ""
    LOCAL aCampos := {}
    LOCAL nX := 0
    LOCAL nLinha := 0
    LOCAL lFilok := .F.
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
        cTabela := "SM7"//UPPER(ALLTRIM(::aURLParms[2]))
        oStruSTAB  := FWFormStruct( 1, cTabela , /* bAvalCampo */, /* lViewUsado */ )
        aFields   := oStruSTAB:aFields//oStruTAB:GetStruct():GetFields()
        nX := 0
        For nX := 1 To Len( aFields )
            AADD(aCampos,{aFields[nX,3],aFields[nX,4]})
        Next nX
        //CONSULTO SM7 PELA EMPRESA E MATRICULA
        IF LEN(self:aURLParms) == 2
            cSeek := ::aURLParms[2]
            SM7->( DBSETORDER(1) )//::aURLParms[2]
            IF SM7->( DBSEEK( xFilial(cTabela) + cSeek ) ) //.AND. lRet]
                oCampo['DADOS']   := {}
                nLinha := 0
                WHILE !SM7->( EOF() ) .AND. SM7->M7_MAT == cSeek
                    AADD( oCampo['DADOS'], JsonObject():New() )

                    nLinha += 1

                    //verifica tipo de beneficio
                    IF SM7->M7_TPVALE == "0"
                        oCampo['DADOS'][nLinha]["DESC_TIPO"] :=  EncodeUTF8("Vale Transporte","cp1252")
                        //buscar dados na tabela SRN
                        SRN->( DBSETORDER(1) )//::aURLParms[2]
                        IF SRN->( DBSEEK( xFilial('SRN') + SM7->M7_CODIGO ) )
                            oCampo['DADOS'][nLinha]["DESC_CODIGO"] :=  EncodeUTF8(SRN->RN_DESC,"cp1252")
                        ENDIF
                        //BUSCA DADOS NA RFO tipo 1
                    ELSEIF SM7->M7_TPVALE == "1"
                        oCampo['DADOS'][nLinha]["DESC_TIPO"] :=  EncodeUTF8("Vale Refeição","cp1252")
                        RFO->( DBSETORDER(1) )//::aURLParms[2]
                        IF RFO->( DBSEEK( xFilial('RFO') + "1" +SM7->M7_CODIGO ) )
                            oCampo['DADOS'][nLinha]["DESC_CODIGO"] :=  EncodeUTF8(RFO->RFO_DESCR,"cp1252")
                        ENDIF
                        //BUSCA DADOS NA RFO tipo 2
                    ELSEIF  SM7->M7_TPVALE == "2"
                        oCampo['DADOS'][nLinha]["DESC_TIPO"] :=  EncodeUTF8("Vale Alimentação","cp1252")
                        RFO->( DBSETORDER(1) )//::aURLParms[2]
                        IF RFO->( DBSEEK( xFilial('RFO') + "2" +SM7->M7_CODIGO ) )
                            oCampo['DADOS'][nLinha]["DESC_CODIGO"] :=  EncodeUTF8(RFO->RFO_DESCR,"cp1252")
                        ENDIF
                    ENDIF

                    FOR nX := 1 to len(aCampos)
                        IF aCampos[nX,2]=="C"
                            oCampo['DADOS'][nLinha][aCampos[nX,1]] :=  EncodeUTF8(SM7->&(aCampos[nX,1]),"cp1252")
                        ELSEIF aCampos[nX,2]=="D"
                            oCampo['DADOS'][nLinha][aCampos[nX,1]] :=  DTOS(SM7->&(aCampos[nX,1]))
                        ELSEIF aCampos[nX,2]=="N"
                            oCampo['DADOS'][nLinha][aCampos[nX,1]] :=  SM7->&(aCampos[nX,1])
                        ENDIF
                    NEXT nX
                    SM7->( DBSKIP() )
                ENDDO
                ::SetResponse(FWJsonSerialize(oCampo, .F., .F., .T.))
            ELSE
                lRet:= .F.
                oResponse['code'] := 2
                oResponse['status'] := 404
                oResponse['message'] := 'Não foi encontrado nenhum beneficio de VT para esse usuário!'
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
