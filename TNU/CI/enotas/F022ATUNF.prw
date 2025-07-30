#include "totvs.ch"
#include 'TBICONN.CH'

/*/{Protheus.doc} F022ATUNF
Este ponto de entrada foi disponibilizado para que seja possível customizar a gravação de 
campos próprios nas tabelas SF2/SF1/SE1 (ou tabela desejada) , 
a partir do refreh no monitor de notas fiscais de serviço, pela rotina FISA022. 
https://tdn.totvs.com/pages/releaseview.action?pageId=235336799

PARAMIXB
[1] - cSerie - Série da nota
[2] - cNumero - Número da nota
[3] - cProtocolo - Protocolo de autorização
[4] - cRPS - Número do RPS
[5] - cNota - Número da NFS-e gerada pela prefeitura após a autorização
[6] - aMsg - Retorno da Prefeitura, com mensagem e Nº
[7] - cURLNfse - Número do RPS

@type function
@version 12.1.2210 
@author Odair Junior
@since 07/02/2024
/*/
User Function F022ATUNF()
	Local aArea := GetArea()
	Local cSerie     := PARAMIXB[1]
	Local cNumero    := PARAMIXB[2]
	Local cProtocolo := PARAMIXB[3]
	Local cRPS       := PARAMIXB[4]
	Local cAliasQry  := getNextAlias()
	Local nRecZPC    := 0

	If !Empty(cProtocolo)

		beginSQL alias cAliasQry
        SELECT TOP 1 R_E_C_N_O_ AS RECNO
        FROM %Table:ZPC% ZPC
        WHERE ZPC_IDPVTR = %Exp:FWxFilial('ZPC')%
          AND ZPC_NOTA  = %Exp:cNumero%
		  AND ZPC_SERIE = %Exp:cSerie%
		  AND ZPC_CODNFE = ''
          AND ZPC.%notDel%
		endSQL

		If (cAliasQry)->(!EoF())
			nRecZPC := (cAliasQry)->RECNO
		EndIF

		(cAliasQry)->( dbCloseArea() )

		If nRecZPC > 0
			DbSelecArea('ZPC')
			ZPC->(DbGoTo(nRecZPC))

			RECLOCK( "ZPC", .F. )
			ZPC->ZPC_DTNOTA := SF2->F2_EMISSAO
			ZPC->ZPC_NFELET := cRPS
			ZPC->ZPC_CODNFE := cProtocolo
			ZPC->ZPC_EMINFE := SF2->F2_EMINFE
			ZPC->(MSUNLOCK())
		EndIf
	EndIf

	RestArea(aArea)

Return Nil

