#INCLUDE "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTCOMC05  �Autor  �Jackson E. de Deus  � Data �  04/18/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida Esp�cie da Nota Fiscal.                             ���
���          � Para Nota de Devolu��o com fornecedor Tok Take, se torna   ���
���          � obrigat�rio a esp�cie 'SPED'								  ���
�������������������������������������������������������������������������͹��
���Uso       � Documento de Entrada                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTCOMC05()

Local lRet 		:= .T.
Local cForns	:= If(cEmpAnt == "01",SuperGetMV("MV_XVLDESP",.T.,"000001"),"")      
Local aForns	:= {}                                     

If cEmpAnt == "01"
	
	aForns := STRTOKARR(cForns,"#")
	
	// Verifica fornecedores Tok Take em que se deve utilizar Esp�cie SPED obrigatoriamente quando Devolu��o
	For nI := 1 To Len(aForns)
		If M->CA100FOR == aForns[nI]
			If cTipo == "D"
				If  !M->F1_ESPECIE $ "SPED"
					lRet := .F.
				EndIf
			EndIf
			
			Exit 
				 
		EndIf
	Next nI
EndIF


Return lRet