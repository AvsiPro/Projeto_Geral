/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ�
��Programa  � MA415END � Autor � Artur Nucci Ferrari     � Data � 12/04/10 ��
��������������������������������������������������������������������������Ĵ�
��Descricao � Ponto de Entrada para Controles do pedido de venda           ��
��������������������������������������������������������������������������Ĵ�
��Uso       � Pedido de Venda                                              ��
��������������������������������������������������������������������������Ĵ�
��Empresa   � Tok Take                                                     ��
��������������������������������������������������������������������������Ĵ�
��Revisado  � Por            � Motivo                                      ��
��������������������������������������������������������������������������Ĵ�
��06/03/10  � Ricardo        � - Validar C.Custo no cab. pedido           -��
��          �                � - Validar Mes Referencia cab.pedido         ��
��������������������������������������������������������������������������Ĵ�
*/

#INCLUDE "PROTHEUS.CH"
#INCLUDE "TopConn.ch"
#INCLUDE "font.ch"
#INCLUDE "colors.ch"


User Function MA415END()

Local aArea    := GetArea()
Local cNumOrc  := SCJ->CJ_NUM
Local dDtEntr  := Dtos(SCJ->CJ_XDENTRE)
Local cUserOrc := Upper(AllTrim(cusername))
Local cXGPV    := ""
Local cTransp  := SCJ->CJ_TRANSP
Local cDescTr  := SCJ->CJ_DESCTRA


// Tratamento para AMC
If cEmpAnt == "10"
	Return .T.
EndIf


If !Empty(SCJ->CJ_XCODPA)
	cTransp := GetAdvFVal("ZZ1","ZZ1_TRANSP",xFilial("ZZ1")+SCJ->CJ_XCODPA,1,0)
	cDescTr := GetAdvFVal("SA4","A4_NREDUZ",xFilial("SA4")+cTransp,1,0)
End

dbSelectArea("SCJ")

RecLock("SCJ",.F.)
SCJ->CJ_TRANSP  := cTransp
SCJ->CJ_DESCTRA :=	cDescTr
SCJ->CJ_STATUS  := "A"
SCJ->CJ_XDESCPG := GetAdvFVal("SE4","E4_DESCRI",xFilial("SE4")+SCJ->CJ_CONDPAG,1,0)
SCJ->CJ_USERORC := Upper(AllTrim(cusername))
SCJ->CJ_DTINC   := DATE()
SCJ->CJ_HRINC   := TIME()
SCJ->CJ_XGPV    := U_TTUSRGPV()
MsUnLock()

cQuery1 := ""
cQuery1 := " UPDATE "+RetSqlName("SCK")
cQuery1 += " SET CK_LOCAL = 'D00026' ,"
cQuery1 += " CK_ENTREG = '"+dDtEntr+"', "
cQuery1 += " CK_XGPV = '"+cXGPV+"' "
cQuery1 += " WHERE CK_NUM = '"+cNumOrc+"' "
cQuery1 += " AND SUBSTRING(CK_PRODUTO,1,2)='21'"
TCSQLExec(cQuery1)
MemoWrite("MA415END1.sql",cQuery1)

cQuery2 := ""
cQuery2 := " UPDATE "+RetSqlName("SCK")
cQuery2 += " SET CK_LOCAL = 'D00006' "
cQuery2 += " WHERE CK_NUM = '"+cNumOrc+"' "
cQuery2 += " AND SUBSTRING(CK_PRODUTO,1,2)='22'"
MemoWrite("MA415END2.sql",cQuery2)
TCSQLExec(cQuery2)

RestArea(aArea)

Return