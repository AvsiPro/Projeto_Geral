
#INCLUDE "RWMAKE.CH"

/*/
_____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    � MTA500QRY() � Autor � Fabio Sales		� Data �23.04.2012���
��+----------+------------------------------------------------------------���
���Descri��o � Ponto de entrada utilizado para incluir uma condi��o na ro-���
���			 � tina de elimina��o de res�duo para o ambiente Top		  ���
��+----------+------------------------------------------------------------���
���Uso       � Faturamento/TokTake                                    	  ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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