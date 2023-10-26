#include "rwmake.ch"
#include "protheus.ch"

/*/{Protheus.doc} MA410MNU()
 	    MA410MNU -Ponto de entrada p/ incluir item no Menu (aRotina)
        https://tdn.totvs.com/display/public/PROT/MA410MNU

  	    06-MIT 44 FINANCEIRO FIN017- Gerar boleto de Adiantamento - RA
 		https://docs.google.com/document/d/1lEfWblcls4_Z28sdq9QI0cB5Mw0om2Fc/edit
*/

USER FUNCTION MA410MNU()
	aAdd(aRotina,{'Adiantamento BA',"U_JFINM017('SC5',SC5->(RecNo()),4)" , 0 , 6,0,NIL})
Return

