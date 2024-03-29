#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ�
��Programa  � MTA416PV � Autor � Artur Nucci Ferrari     � Data � 12/04/10 ��
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

User Function MTA416PV() 

Local aArea    := GetArea()

// Tratamento para AMC
If cEmpAnt == "10"
	Return
EndIf



RecLock("SCJ",.F.)
SCJ->CJ_USEREFT := Upper(AllTrim(cusername))
SCJ->CJ_DTEFT   := DATE()
SCJ->CJ_HREFT   := TIME()
MsUnLock()

M->C5_XDESCLI := GetAdvFval("SA1","A1_NREDUZ",xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,1)
M->C5_XFINAL  := SCJ->CJ_XFINAL
M->C5_XDTENTR := SCJ->CJ_XDENTRE
M->C5_XNFABAS := SCJ->CJ_XNFABAS
M->C5_XCODPA  := SCJ->CJ_XCODPA 
M->C5_XDCODPA := SCJ->CJ_DCODPA 
M->C5_XFINAL  := SCJ->CJ_XFINAL 
M->C5_TRANSP  := SCJ->CJ_TRANSP 
M->C5_XDESCPG := SCJ->CJ_XDESCPG
M->C5_DESCTAB := SCJ->CJ_DESCTAB
M->C5_XCCUSTO := SCJ->CJ_XCCUSTO
M->C5_DESCTRA := SCJ->CJ_DESCTRA
M->C5_DESCCC  := SCJ->CJ_DESCCC    
M->C5_XNUMORC := SCJ->CJ_NUM     
M->C5_MENNOTA := SCJ->CJ_MENNOTA  
M->C5_VEND1   := SCJ->CJ_VEND1
M->C5_CONDPAG := SCJ->CJ_CONDPAG
M->C5_XFLDEST := SCJ->CJ_XFLDEST            
M->C5_XGPV    := SCJ->CJ_XGPV

RestArea(aArea)
Return()