/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � FA070TIT � Autor � Artur Nucci Ferrari   � Data � 23/09/08 ���
�������������������������������������������������������������������������Ĵ��
���          � P.E. para bloquear baixa fora da data base do sistema      ���
���Descricao �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Modulo    � SIGAFIM                                                    ���
�������������������������������������������������������������������������Ĵ��
���Parametros� nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Codigo do grupo de aprovacao                               ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  � Manutencao Efetuada                           ���
�������������������������������������������������������������������������Ĵ��
���              �  /  /  �                                               ���
���              �  /  /  �                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#include "RWMAKE.CH"
User Function FA070TIT()
Local _aAliasAtu := GetArea()
Local _lReturn := .T.   
Local _nDias := 2 
Local nCont	:=	0
Local lFlag :=	.F.

If Dow(date())==2
   _nDias := 3
End           
                 /*
While !empty(procname(nCont))
	If "M460FIM" $ alltrim(procname(nCont))
		lFlag	:= .T.
		Exit
	EndIf   
	nCont++
EndDo
                   */

If cEmpAnt == "01"
	If  dDataBase#ddtcredito
		MsgBox ("A data do cr�dito tem que ser igual a data base do sistema. Baixa n�o ser� realizada.","Aten��o!!!","ALERT")
		_lReturn := .F.
	End
	If nDescont>0
		MsgBox ("Para descontos no t�tulo utilize a NCC. Baixa n�o ser� realizada.","Aten��o!!!","ALERT")
		_lReturn := .F.
	End 
	If _lReturn
		If !(SE1->E1_TIPO$'NCC/NDC') //.And. !lFlag  //Validacao para nao passar por esta parte quando for baixa parcial dos titulos de verbas contratuais.
			If U_TT_TEA("R",SE1->E1_CLIENTE,SE1->E1_LOJA) > 0
				IF MsgBox ("Existem t�tulos que podem ser compensados. Deseja continuar com a baixa ?","Escolha","YESNO")
					_lReturn := .T.
				Else
					_lReturn := .F.
				End
			End
		End
	End
EndIF

RestArea(_aAliasAtu)
Return _lReturn

