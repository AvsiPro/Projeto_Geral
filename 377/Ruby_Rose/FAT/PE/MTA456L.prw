#include "rwmake.ch"
#include "totvs.ch"

 /*/{Protheus.doc}	MTA456L
PE executado ap�s a grava��o de todas as libera��es do pedido de vendas (Libera��o Manual) tabela SC9.

@author				Paulo Lima
@since				17/12/2013
@return				Nil
/*/
User Function MTA456L()
 	U_GeraOSep("SC5")		// Fun��o que gera os registros na tabela CB7 e CB8 baseados na SC5.
 	
 	U_bloqCredEst(SC9->C9_PEDIDO)
Return
