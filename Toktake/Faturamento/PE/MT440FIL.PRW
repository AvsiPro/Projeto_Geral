/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ�
��Programa  � MT440FIL � Autor � Artur Nucci Ferrari     � Data � 09/08/10 ��
��������������������������������������������������������������������������Ĵ�
��Descricao � Ponto de Entrada para Controles da Liberacao do P.V.         ��
��Descricao � Manual e Automatica                                          ��
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
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

User Function MT440FIL()

Local cUserLB := Upper(AllTrim(cusername))
Local cUserNF := ""	//AllTrim(SuperGetMv("MV_XUSRNFS"))
Local dDtBloq := stod("")	//SuperGetMV("MV_XBLQFAT")
Local cFil    := ""
Local cXGPV   := ""
Local _dDtLim := DTOC(Date()+1)


// Tratamento para AMC
If cEmpAnt == "10"
	Return .T.
EndIf


cUserNF := AllTrim(SuperGetMv("MV_XUSRNFS"))
dDtBloq := SuperGetMV("MV_XBLQFAT")


If date() <= dDtBloq
	cRet := " SC6->C6_FILIAL='@#' "
	Return(cRet)
End

If SM0->M0_CODIGO=="01" .OR. SM0->M0_CODIGO=="11"
	// Domingo
	If Dow(ddatabase)==6
		_dDtLim  := DTOC(Date()+3)
		// S�bado
	ElseIf Dow(ddatabase)==7
		_dDtLim  := DTOC(Date()+2)
	End
	If SC5->C5_CLIENTE<>'000570'
		IF !(Upper(cUserLB)$('ADMINISTRADOR#ADMIN'))		
			If Alltrim(cUserLB)=="EFLOR"
				cFil := " !Empty(SC6->C6_TES) .AND. SC6->C6_TES <> '888' .AND. SC6->C6_ENTREG>=Date() .AND. SC6->C6_ENTREG<=CTOD('"+ _dDtLim +"') .AND. SC5->C5_XSTLIB==0 .AND. SUBSTR(SC6->C6_PRODUTO,1,1)='2' "
			ElseIf Alltrim(cUserLB)=="JARIBEIRO"
				cFil := " !Empty(SC6->C6_TES) .AND. SC6->C6_TES <> '888' .AND. SC6->C6_ENTREG>=Date() .AND. SC6->C6_ENTREG<=CTOD('"+ _dDtLim +"') .AND. SC5->C5_XSTLIB==0 .AND. SUBSTR(SC6->C6_PRODUTO,1,1)='1' "
			Else
			End	
			//			If !(cUserLB$(cUserNF))
			//				cXGPV := U_TTUSRGPV(cUserLB)
			//				cFil := " !Empty(SC6->C6_TES) .AND. SC6->C6_TES <> '888' .AND. SC6->C6_ENTREG>=Date() .AND. SC6->C6_ENTREG<=CTOD('"+ _dDtLim +"') .AND. SC5->C5_XSTLIB==0 .AND. AllTrim(SC6->C6_XGPV)=='"+ALLTRIM(cXGPV)+"' "
			//			Else
			//				cFil := " !Empty(SC6->C6_TES) .AND. SC6->C6_TES <> '888' .AND. SC6->C6_ENTREG>=Date() .AND. SC6->C6_ENTREG<=CTOD('"+ _dDtLim +"') .AND. SC5->C5_XSTLIB==0 "
			//			End
		Else
			cFil := " !Empty(SC6->C6_TES) .AND.  SC6->C6_TES <> '888' .AND. SC6->C6_ENTREG>=Date() .AND. SC5->C5_XSTLIB==0 "
		End
	End
Else
	cFil := " !Empty(SC6->C6_TES) .AND. SC6->C6_TES <> '888' .AND. SC6->C6_ENTREG>=Date() .AND. SC5->C5_XSTLIB==0"
End
Return(cFil)

