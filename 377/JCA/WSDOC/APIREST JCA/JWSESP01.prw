#INCLUDE "Protheus.ch"
#INCLUDE "RESTFUL.CH"
#Include "rwmake.ch"
#Include "tbiconn.ch"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

/*
    API
    Api GET Consulta especifica de campos do rh que n�o possuem tabela no sistema
    Alguns campos retornam lista de op��es que n�o possuem tabela.
    Doc Mit   
    
*/

WSRESTFUL JWSESP01 DESCRIPTION "Metodo GET para consulta especifica de campos do RH"
    WSMETHOD GET DESCRIPTION "RETORNA Consulta especifica de campos" WSSYNTAX "/JWSESP01/{CAMPO}"
ENDWSRESTFUL

WSMETHOD GET WSSERVICE JWSESP01

    LOCAL lRet := .T.
    LOCAL nLinha := 0
    LOCAL aConteudo := {}
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

    If LEN(self:aURLParms) > 0
        cSeek := ::aURLParms[1]
    ELSE
        lRet := .F.
        oResponse['code'] := 2
        oResponse['status'] := 404
        oResponse['message'] := 'Informe um campo no parametro'
        oResponse['detailedMessage'] := ''
    ENDIF

    IF lRet
        oCampo['DADOS']   := {}
        IF alltrim(cSeek) == "RA_CLASEST"

            AADD(aConteudo,{"1","Refugiado"})
            AADD(aConteudo,{"2","Solicitante de Ref�gio"})
            AADD(aConteudo,{"3","Perman�ncia no Brasil em raz�o de reuni�o familiar"})
            AADD(aConteudo,{"4","Beneficiado pelo acordo entre paises do Mercosul"})
            AADD(aConteudo,{"5","Dependente de agente diplom�tico e/ou consular de pa�ses que mant�m acordo de reciprocidade para o exerc�cio de atividade remunerada no Brasil "})
            AADD(aConteudo,{"6","Beneficiado pelo Tratado de Amizade, Coopera��o e Consulta entre a Rep�blica Federativa do Brasil e a Rep�blica Portuguesa"})
            AADD(aConteudo,{"7","Outra condi��o"})

            nLinha := 0

            FOR nLinha := 1 to LEN(aConteudo)

                AADD( oCampo['DADOS'], JsonObject():New() )

                oCampo['DADOS'][nLinha]["CODIGO"]        :=  aConteudo[nLinha,1]
                oCampo['DADOS'][nLinha]["DESCRIC"]       := EncodeUTF8(aConteudo[nLinha,2],"cp1252")

            next nLinha

            ::SetResponse(FWJsonSerialize(oCampo, .F., .F., .T.))
        ELSEIF alltrim(cSeek) == "RB_TPDEP"

            AADD(aConteudo,{"01","C�njuge."})
            AADD(aConteudo,{"02","Companheiro(a) com o(a) qual tenha filho ou viva h� mais de 5 (cinco) anos ou possua Declara��o de Uni�o Est�vel."})
            AADD(aConteudo,{"03","Filho(a) ou enteado(a)."})
            AADD(aConteudo,{"04","Filho(a) ou enteado(a) universit�rio(a) ou cursando escola t�cnica de 2� grau (V�lido at� 26/04/2023) "})
            AADD(aConteudo,{"05","Filho(a) ou enteado(a) em qualquer idade, quando incapacitado f�sica e/ou mentalmente para o trabalho "})
            AADD(aConteudo,{"06","Irm�o(�), neto(a) ou bisneto(a) sem arrimo dos pais, do(a) qual detenha a guarda judicial"})
            AADD(aConteudo,{"07","Irm�o(�), neto(a) ou bisneto(a) sem arrimo dos pais se ainda estiver cursando estabelecimento de n�vel superior ou escola t�cnica de 2� grau, desde que tenha detido sua guarda judicial (V�lido at� 26/04/2023)"})
            AADD(aConteudo,{"08","Irm�o(�), neto(a) ou bisneto(a) sem arrimo dos pais, do(a) qual detenha a guarda judicial, em qualquer idade, quando incapacitado f�sica e/ou mentalmente para o trabalho"})
            AADD(aConteudo,{"09","Pais, av�s e bisav�s"})
            AADD(aConteudo,{"10","Menor pobre que crie e eduque e do qual detenha a guarda judicial"})
            AADD(aConteudo,{"11","A pessoa absolutamente incapaz, da qual seja tutor ou curador"})
            AADD(aConteudo,{"12","Ex-c�njuge "})
            AADD(aConteudo,{"13","Agregado\Outros (N�o Usado)"})
            AADD(aConteudo,{"99","Agregado/Outros."})

            nLinha := 0

            FOR nLinha := 1 to LEN(aConteudo)

                AADD( oCampo['DADOS'], JsonObject():New() )

                oCampo['DADOS'][nLinha]["CODIGO"]        :=  aConteudo[nLinha,1]
                oCampo['DADOS'][nLinha]["DESCRIC"]       := EncodeUTF8(aConteudo[nLinha,2],"cp1252")

            NEXT nLinha
            ::SetResponse(FWJsonSerialize(oCampo, .F., .F., .T.))
        ELSEIF alltrim(cSeek) == "RHL_TPPLAN"

            AADD(aConteudo,{"1","Faixa Salarial."})
            AADD(aConteudo,{"2","Faixa Etaria."})
            AADD(aConteudo,{"3","Valor Fixo."})
            AADD(aConteudo,{"4","% S/ Salario."})
            AADD(aConteudo,{"5","Salarial/Etaria. "})
            AADD(aConteudo,{"6","Salarial/Tempo. "})

            nLinha := 0

            FOR nLinha := 1 to LEN(aConteudo)

                AADD( oCampo['DADOS'], JsonObject():New() )

                oCampo['DADOS'][nLinha]["CODIGO"]        :=  aConteudo[nLinha,1]
                oCampo['DADOS'][nLinha]["DESCRIC"]       := EncodeUTF8(aConteudo[nLinha,2],"cp1252")

            NEXT nLinha
            ::SetResponse(FWJsonSerialize(oCampo, .F., .F., .T.))
        ELSEIF alltrim(cSeek) == "RHK_TPPLAN"

            AADD(aConteudo,{"1","Faixa Salarial."})
            AADD(aConteudo,{"2","Faixa Etaria."})
            AADD(aConteudo,{"3","Valor Fixo."})
            AADD(aConteudo,{"4","% S/ Salario."})
            AADD(aConteudo,{"5","Salarial/Etaria. "})
            AADD(aConteudo,{"6","Salarial/Tempo. "})

            nLinha := 0

            FOR nLinha := 1 to LEN(aConteudo)

                AADD( oCampo['DADOS'], JsonObject():New() )

                oCampo['DADOS'][nLinha]["CODIGO"]        :=  aConteudo[nLinha,1]
                oCampo['DADOS'][nLinha]["DESCRIC"]       := EncodeUTF8(aConteudo[nLinha,2],"cp1252")

            NEXT nLinha
            ::SetResponse(FWJsonSerialize(oCampo, .F., .F., .T.))
                ELSEIF alltrim(cSeek) == "RHM_TPPLAN"

            AADD(aConteudo,{"1","Faixa Salarial."})
            AADD(aConteudo,{"2","Faixa Etaria."})
            AADD(aConteudo,{"3","Valor Fixo."})
            AADD(aConteudo,{"4","% S/ Salario."})
            AADD(aConteudo,{"5","Salarial/Etaria. "})
            AADD(aConteudo,{"6","Salarial/Tempo. "})

            nLinha := 0

            FOR nLinha := 1 to LEN(aConteudo)

                AADD( oCampo['DADOS'], JsonObject():New() )

                oCampo['DADOS'][nLinha]["CODIGO"]        :=  aConteudo[nLinha,1]
                oCampo['DADOS'][nLinha]["DESCRIC"]       := EncodeUTF8(aConteudo[nLinha,2],"cp1252")

            NEXT nLinha
            ::SetResponse(FWJsonSerialize(oCampo, .F., .F., .T.))
        ELSE
            lRet:= .F.
            oResponse['code'] := 2
            oResponse['status'] := 404
            oResponse['message'] := 'N�o foi encontrado nenhum registro para esse campo'
            oResponse['detailedMessage'] := ''
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
