#INCLUDE "RWMAKE.CH"

/*�����������������������������������������������������������������������������
���Programa  �CONVLD    �Autor  �Eduardo Augusto      � Data �  17/05/2013 	���
���������������������������������������������������������������������������͹��
���Desc.     � Fun��o para Convers�o da Representa��o Num�rica do C�digo de ���
���          � Barras - Linha Digit�vel (LD) em C�digo de Barras (CB).      ���
���			 �																���
���			 � Para utiliza��o dessa Fun��o, deve-se criar um Gatilho para o���
���			 � campo E2_CODBAR, Conta Dom�nio: E2_CODBAR, Tipo: Prim�rio,   ���
���			 � Regra: EXECBLOCK("CONVLD",.T.), Posiciona: N�o.   			���
���			 �                                                              ���          
���			 � Utilize tamb�m a Valida��o do Usu�rio para o Campo E2_CODBAR ���
���    		 � EXECBLOCK("CODBAR",.T.) para Validar a LD ou o CB.  			���
���������������������������������������������������������������������������͹��
���Uso       � Expressa Distribuidora de Medicamentos Ltda					���
�����������������������������������������������������������������������������*/

User Function CONVLD()
                      
SetPrvt("cStr")
	cStr := Alltrim(M->E2_CODBAR)
	If ValType(M->E2_CODBAR) == Nil .OR. Empty(M->E2_CODBAR)
		// Se o Campo est� em Branco n�o Converte nada.
		cStr := ""
	Else
		// Se o Tamanho do String for menor que 44, completa com zeros at� 47 d�gitos. Isso � necess�rio para Bloquetos que N�O t�m o vencimento e/ou o valor informados na LD.
		cStr := If(Len(cStr)<44,cStr + Repl("0",47-Len(cStr)),cStr)
	EndIf
Do Case
Case Len(cStr) == 47
	cStr := Substr(cStr,1,4) + Substr(cStr,33,15) + Substr(cStr,5,5) + Substr(cStr,11,10) + Substr(cStr,22,10)
Case Len(cStr) == 48
   cStr := Substr(cStr,1,11) + Substr(cStr,13,11) + Substr(cStr,25,11) + Substr(cStr,37,11)
OtherWise
	cStr := cStr + Space(48-Len(cStr))
EndCase
Return(cStr)