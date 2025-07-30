#include "PROTHEUS.CH"

/*/{Protheus.doc} CIJOBCF1
	Jobs de execução de integração de notas com o e-notas
	@type function
	@author TNU
	@since 07/2025
	@param cAlias, character, param_description
	@return logical, return_description
/*/

/*-------------------------------------------------------*/
/*                 Criação 18/07/25                      */
/*                                                       */
/*-------------------------------------------------------*/


User Function CIJOBCF1()

    Default cEmpJob := '01'
	Default cFilJob := '000101'

    If Empty(FunName())
        RpcSetType(3)
        RpcSetEnv(cEmpJob, cFilJob)
    EndIf 

	cSumario := CRLF
    cSumario += "+----------------------------------------------+" + CRLF
    cSumario += "| [CIJOBCF1] - Iniciando Execucao - "+DtoC(date())+" "+time()+" |" + CRLF
    cSumario += "+----------------------------------------------+" + CRLF
    Conout(cSumario)

    Conout("[CIJOBCF1] - Chamada da função jEnvENotas()")
    
    U_jEnvENotas()
    
    Conout("[CIJOBCF1] - Retorno da função jEnvENotas()")

    cSumario := CRLF
    cSumario += "+----------------------------------------------+" + CRLF
    cSumario += "| [CIJOBCF1] - Finalizando Execucao - "+DtoC(date())+" "+time()+" |" + CRLF
    cSumario += "+----------------------------------------------+" + CRLF
    Conout(cSumario)

    conout(cSumario)

Return


