
#INCLUDE "RWMAKE.CH"

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ MTA500QRY() ¦ Autor ¦ Fabio Sales		¦ Data ¦23.04.2012¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Ponto de entrada utilizado para incluir uma condição na ro-¦¦¦
¦¦¦			 ¦ tina de eliminação de resíduo para o ambiente Top		  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Faturamento/TokTake                                    	  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

User Function  MTA500QRY()

Local clAreAtu	:= GetArea()
Local clReturn	:= ""	//" C6_XGPV='"+U_TTUSRGPV(Alltrim(cUserName))+"' "


// Tratamento para AMC
If cEmpAnt == "10"
	Return clReturn
EndIf

If cEmpAnt == "01"
	clReturn	:= " C6_XGPV='"+U_TTUSRGPV(Alltrim(cUserName))+"' "
EndIf


Return clReturn	