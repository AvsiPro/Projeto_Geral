#INCLUDE "Protheus.ch"
#INCLUDE "RESTFUL.ch"
#include "FWMVCDEF.CH

/*
    API
   Get RETORNA Agregados RHM - Empresa/Matricula
    Doc Mit   
    
*/

WSRESTFUL JWSRHM01 DESCRIPTION "GET consulta de Agregados RHM"
    WSMETHOD GET DESCRIPTION "RETORNA Agregados RHM - Empresa/Matricula" WSSYNTAX "/JWSRHM01/{EMPRESA/MATRICULA/}"
ENDWSRESTFUL

WSMETHOD GET WSSERVICE JWSRHM01

    LOCAL lRet := .T.
    LOCAL cMatric := ""
    LOCAL cFiPesq := ""
    LOCAL cQuery := ""
    LOCAL nC := 0
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

            cQuery := "SELECT RHM_FILIAL, RHM_MAT, RHM_TPFORN, RHM_CODFOR, RHM_CODIGO,"
            cQuery += " RHM_NOME, RHM_TPCALC, RHM_DTNASC, RHM_CPF, RHM_TPPLAN, RHM_PLANO, "
            cQuery += " RHM_PERINI,RHM_PERFIM, RHM_DATFIM, RHM_PD  "
            cQuery += " FROM "+ RetSQLName('RHM')+" RHM "
            cQuery += " WHERE RHM_FILIAL ='" + cFiPesq +"' AND RHM_MAT = '"+ cMatric +"' AND RHM.D_E_L_E_T_=''"

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

            WHILE TMP->(!EOF())
                nC += 1

                oCampo['DADOS'][nC]["RHM_FILIAL"]   := TMP->RHM_FILIAL
                oCampo['DADOS'][nC]["RHM_MAT"]      := TMP->RHM_MAT
                oCampo['DADOS'][nC]["RHM_TPFORN"]   := TMP->RHM_TPFORN
                oCampo['DADOS'][nC]["RHM_CODFOR"]   := TMP->RHM_CODFOR
                oCampo['DADOS'][nC]["RHM_CODIGO"]   := TMP->RHM_CODIGO 
                oCampo['DADOS'][nC]["RHM_NOME"]     := TMP->RHM_NOME 
                oCampo['DADOS'][nC]["RHM_DTNASC"]   := substr(TMP->RHM_DTNASC,7,2)+"/"+substr(TMP->RHM_DTNASC,5,2)+"/"+substr(TMP->RHM_DTNASC,1,4)
                oCampo['DADOS'][nC]["RHM_CPF"]      := TMP->RHM_CPF 
                oCampo['DADOS'][nC]["RHM_TPCALC"]   := TMP->RHM_TPCALC
                oCampo['DADOS'][nC]["RHM_TPPLAN"]   := TMP->RHM_TPPLAN 
                oCampo['DADOS'][nC]["RHM_PLANO"]     := TMP->RHM_PLANO 
                oCampo['DADOS'][nC]["RHM_PERINI"]   := TMP->RHM_PERINI
                oCampo['DADOS'][nC]["RHM_PERFIM"]   := TMP->RHM_PERFIM 
                oCampo['DADOS'][nC]["RHM_DATFIM"]   := TMP->RHM_DATFIM
                oCampo['DADOS'][nC]["RHM_PD"]      := TMP->RHM_PD 

                TMP->( DBSKIP() )
            ENDDO
            dbSelectArea("TMP")
            dbCloseArea()
            IF nC == 0
                lRet := .F.
                oResponse['code'] := 3
                oResponse['status'] := 404
                oResponse['message'] := 'Nenhum agregado localizado.'
                oResponse['detailedMessage'] := ''
            ELSE
                ::SetResponse(FWJsonSerialize(oCampo, .F., .F., .T.))
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
