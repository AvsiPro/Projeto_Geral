#Include "RwMake.ch"
#Include 'Protheus.ch'
#Include 'Topconn.ch'
#INCLUDE 'APVT100.CH'

 /*/{Protheus.doc} ACD170FIM
Ponto-de-Entrada: ACD170FIM - Gera��o ou Exclus�o da Nota de Sa�da.

@author    Paulo Lima
@since    16/12/2021
@return    Nil
/*/
User Function ACD170FIM()

	U_GerExNS(1)					// 1 - Processo normal / 2 - Reimpress�o.
Return
