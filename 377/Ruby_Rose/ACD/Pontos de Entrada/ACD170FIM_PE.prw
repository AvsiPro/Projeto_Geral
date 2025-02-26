#Include "RwMake.ch"
#Include 'Protheus.ch'
#Include 'Topconn.ch'
#INCLUDE 'APVT100.CH'

 /*/{Protheus.doc} ACD170FIM
Ponto-de-Entrada: ACD170FIM - Geração ou Exclusão da Nota de Saída.

@author    Paulo Lima
@since    16/12/2021
@return    Nil
/*/
User Function ACD170FIM()

	U_GerExNS(1)					// 1 - Processo normal / 2 - Reimpressão.
Return
