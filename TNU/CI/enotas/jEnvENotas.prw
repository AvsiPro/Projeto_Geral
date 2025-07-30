#include "totvs.ch"
#include "tbiconn.ch"

/*/{Protheus.doc} jEnvENotas
Job de envio de RPS para o E-Notas
@type function
@version 1.0
@author Cristiam Rossi
@since 10/04/2021
/*/

/*
+------------------------------------------------------------------------------------+
|                Historico de Alteraçoes                                             |
|                                                                                    |
| 24/10/2024 - Alterada data de selecao de F2_EMISSAO >= '20240901'                  |
| 31/01/2025 - Alterada data de selecao de F2_EMISSAO >= '20250101' e F2_NFELETR = ''|
|                                                                                    |
+------------------------------------------------------------------------------------+
*/

user function jEnvENotas()
local nMaxLife := 5    // 5 minutos
local nI
local cFileTmp
local nHdl
local nHdlJ
local cSumario := CRLF

   makeDir("/E-NOTAS")

    if ( nHdlJ := fCreate( "/E-NOTAS/jEnvENotas.lck" ) ) == -1
        RpcClearEnv()       // Job em execu  o
        return nil          // sair
    endif

    cSumario += "+---------------------------------------------+" + CRLF
    cSumario += "| JOB JEnvENotas - Inicio - "+DtoC(date())+" "+time()+" |" + CRLF
    cSumario += "+---------------------------------------------+" + CRLF

    if ! RpcSetEnv("01","01")
        cSumario += "! falha ao conectar empresa/filial" + CRLF
    else
        aFiliais := getFiliais()

        for nI := 1 to len( aFiliais )

            cFileTmp := "/E-NOTAS/jFilial_"+aFiliais[nI]+".lck"
            cSumario += "Filial "+aFiliais[nI]
            if ( nHdl := fCreate( cFileTmp ) ) != -1
                cSumario += " iniciado"+CRLF
                fClose( nHdl )
                startJob("U_jEnvRPS",GetEnvServer(),.F., aFiliais[nI], nMaxLife)  // iniciar JOB U_jEnvRPS(aFiliais[nI], nMaxLife)
            else
                cSumario += " em execu  o"+CRLF
            endif

        next
	endif

    fClose( nHdlJ )

    cSumario += CRLF
    cSumario += "+----------------------------------------------+" + CRLF
    cSumario += "| JOB JEnvENotas - Termino - "+DtoC(date())+" "+time()+" |" + CRLF
    cSumario += "+----------------------------------------------+" + CRLF

    conout(cSumario)

    RpcClearEnv()
return nil


/*/{Protheus.doc} getFiliais
Recupera a Filiais usu rias do E-Notas
@type function
@version 1.0
@author Cristiam Rossi
@since 17/04/2021
@return array, Filiais usu rias do E-Notas
/*/
static function getFiliais()
local aArea     := getArea()
local cAliasQry := getNextAlias()
local aRet      := {}

    beginSQL alias cAliasQry
        select ZPA_FILEMP FILIAL
        from %Table:ZPA% ZPA
        where ZPA_FILIAL = ' '
        and ZPA_ENOTAS = 'S'
        and ZPA.%notDel%
    endSQL

    while ! (cAliasQry)->( eof() )
        aAdd( aRet, (cAliasQry)->FILIAL )
        (cAliasQry)->( dbSkip() )
    endDo
    (cAliasQry)->( dbCloseArea() )

    restArea( aArea )
return aRet


/*/{Protheus.doc} jEnvRPS
Rotina Thread que envia RPS de uma Filiais p/ E-Notas
@type function
@version 1.0
@author Cristiam Rossi
@since 08/04/2021
@param _Filial, character, Filial a ser processada, envio dos RPS
@param nMaxLife, numeric, Tempo de vida da Thread em minutos
/*/
user function jEnvRPS( _Filial, nMaxLife )
local   nMaxSecs       := seconds() + nMaxLife * 60
local   cAliasQry      := getNextAlias()
local   cSumario       := CRLF
local   cFileTmp       := "/E-NOTAS/jFilial_"+_Filial+".lck"
local   nHdl
local   nSend          := 0
local   _RPSno         := ""

//RpcClearEnv()

    cSumario += "+----------------------------------------------+" + CRLF
    cSumario += "| Thread jFilial_"+_Filial +" "+ DtoC(date())+" "+time()+space(6)+"|" + CRLF
    cSumario += "+----------------------------------------------+" + CRLF

    if ( nHdl := fCreate( cFileTmp ) ) == -1
        cSumario += "falha ao criar semaforo: "+cFileTmp+CRLF
        conout(cSumario)
        return nil
    endif

    if ! RpcSetEnv("01",_Filial)
        cSumario += "falha ao abrir empresa/filial: "+_Filial+CRLF
        conout(cSumario)
        return nil
    endif

    _RPSno := padR( SuperGetMv("ES_RPSNO"  ,,"S  "), 3 )

    beginSQL alias cAliasQry
        select distinct F2_FILIAL, F2_DOC, F2_SERIE, ZPE_STATUS
        from %Table:SF2% SF2
        left join %table:ZPE% ZPE
        on ZPE_FILIAL=F2_FILIAL
        and ZPE_DOC=F2_DOC
        and ZPE_SERIE=F2_SERIE
        and ZPE_LAST=' '
        and ZPE.D_E_L_E_T_=' '
        INNER JOIN %table:ZPA% ZPA
                ON ZPA_FILEMP = F2_FILIAL
               AND ZPA_ENOTAS = 'S'
      where F2_FILIAL=%Exp:_Filial%
        and F2_SERIE != %Exp:_RPSno%
        and F2_EMISSAO >= '20250101'
        and F2_DOC     > ZPA_DOC
        and SF2.D_E_L_E_T_=' '
        and isnull(ZPE_STATUS,' ') = ' '
      order by F2_FILIAL, F2_DOC, F2_SERIE
    endSQL

//   and isnull(ZPE_STATUS,' ') in (' ','1','5')
//   and isnull(ZPE_STATUS,' ') = ' '

    while ! (cAliasQry)->( eof() )
        if nMaxSecs < seconds()     // caducou o tempo
            cSumario += "tempo de vida do job expirou"+CRLF
            exit
        endif

        if (cAliasQry)->(ZPE_STATUS) == "4" 
             Loop 
	    (cAliasQry)->(DbSkip())
        endif
        
        CONOUT("RPS: " + (cAliasQry)->F2_DOC )
        /*
        if U_sndENotas( (cAliasQry)->F2_FILIAL, (cAliasQry)->F2_DOC, (cAliasQry)->F2_SERIE, .T. )
            nSend++
        endif
*/
        (cAliasQry)->( dbSkip() )
    endDo
    (cAliasQry)->( dbCloseArea() )

    cSumario += "E-Notas RPS enviados: "+cValToChar(nSend) + CRLF

    cSumario += "+----------------------------------------------+" + CRLF
    cSumario += "| Thread finalizada "+ DtoC(date())+" "+time()+space(10)+"|" + CRLF
    cSumario += "+----------------------------------------------+" + CRLF

    conout(cSumario)

    RpcClearEnv()
return nil
