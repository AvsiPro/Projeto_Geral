/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Funcao    � FA080TIT � Autor � Artur Nucci Ferrari    � Data � 18/11/04 ���
��������������������������������������������������������������������������Ĵ��
���Descricao � Controle na Baixa de Pagamento                              ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Tok Take                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

#include "rwmake.ch"

User Function Fa080tit()
Local _cAlias  := Alias()
Local _nIndex  := IndexOrd()
Local _nReg    := Recno()
Local cRet := .T.
Local _nDias := 2
If Dow(date())==2
	_nDias := 3
End

If dbaixa<>ddatabase
	MsgBox ("A data do pagamento deve ser a mesma da data base do sistema. Baixa nao Realizada","Atencao!!!","ALERT")
	cRet := .F.
End


If ddebito<>ddatabase
	MsgBox ("A data do d�bito deve ser a mesma da data base do sistema. Baixa nao Realizada","Atencao!!!","ALERT")
	cRet := .F.
End
If SM0->M0_CODIGO=="01"
		If SE2->E2_XTIPLIB=='D'
			If SE2->E2_SALDO==SE2->E2_VALOR
				MsgBox ("Este t�tulo deve estar compensado com uma Nota de Devolu��o. Baixa nao Realizada","Atencao!!!","ALERT")
				cRet := .F.
			End
		ElseIf SE2->E2_XTIPLIB=='N'
			If ((SE2->E2_SALDO+SE2->E2_ACRESC)-SE2->E2_DECRESC)==SE2->E2_VALOR
				MsgBox ("Este t�tulo deve estar compensado com uma Nota de D�bito (NDF). Baixa nao Realizada","Atencao!!!","ALERT")
				cRet := .F.
			End
		End

	If cRet
		If !(SE2->E2_TIPO$'RA/NCF')
			If U_TT_TEA("P",SE2->E2_FORNECE,SE2->E2_LOJA) > 0
				IF MsgBox ("Existem t�tulos que podem ser compensados. Deseja continuar com a baixa ?","Escolha","YESNO")
					cRet := .T.
				Else
					cRet := .F.
				End
			End
		End
	End
End

//�������������������������������������������������������������Ŀ
//� Retorna Area Inicial                                        �
//���������������������������������������������������������������

dbSelectArea(_cAlias)
dbSetOrder(_nIndex)
dbGoTo(_nReg)
Return(cRet)


