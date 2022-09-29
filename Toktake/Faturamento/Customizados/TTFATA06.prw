
#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTFATA06() � Autor � Fabio Sales      � Data �  27/10/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para cadastro dos respons�veis pelas entregas das	  ���
���			 � rotas de abastecimento.									  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Faturamento                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function TTFATA06()

	Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
	Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
	Private cString := "ZZ7" 
		
	dbSelectArea(cString)
	dbSetOrder(1)
		
	AxCadastro(cString,"Cadastro dos Respons�veis pelas Rotas",cVldExc,cVldAlt)
Return
