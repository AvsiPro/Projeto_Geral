#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} MA410MNU()
 	    Rotina para incluir titulo do tipo BA no financeiro
        Chamada através do PE MA410MNU
  	    06-MIT 44 FINANCEIRO FIN017- Gerar boleto de Adiantamento - RA
 		https://docs.google.com/document/d/1lEfWblcls4_Z28sdq9QI0cB5Mw0om2Fc/edit
*/

USER FUNCTION JFINM017()

	LOCAL aArea := GetArea()
	LOCAL cCondPag := SC5->C5_CONDPAG

	//verifica se condição de pagamento tem adiantamento
	dbSelectArea("SE4")
	SE4->(dbSetOrder(1))
	IF SE4->(dbSeek(xFilial("SE4")+cCondPag))
		IF SE4->E4_CTRADT == "1"
			FINA040(,3)
		ELSE
			ALERT("Pedido não possui condição de pagamento que permita adiantamento.")
		ENDIF
	ELSE
		ALERT("Condição de pagamento não localizada.")
	ENDIF

	RestArea(aArea)
RETURN
