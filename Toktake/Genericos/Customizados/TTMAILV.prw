#INCLUDE 'PROTHEUS.CH'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTMAILN   �Autor  �Alexandre Venancio  � Data �  09/15/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Validacoes diversas de contatos de clientes.              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTMAILV(cEmail)

Local aArea		:=	GetArea()
Local lRet		:=	.T.
Local aEmails	:= 	strtokarr(cEmail,";")
Local aAux		:=	{}

For nX := 1 to len(aEmails)
	aAux := strtokarr(aEmails[nX],"@")
	If len(aAux) < 2
		MsgAlert("Email inv�lido "+aEmails[nX],"TTMAILV")
		lRet := .F.
		exit 
	Else
		if !"." $ aAux[2]
			MsgAlert("Email inv�lido "+aEmails[nX],"TTMAILV")
			lRet := .F.
			exit 
		EndIf
	EndIf
Next nX

RestArea(aArea)

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTMAILV   �Autor  �Microsiga           � Data �  09/15/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Validando o nome do contato cadastrado.                   ���
���          �obrigatorio nome e sobrenome                                ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTNOMCT(cCampo)

Local aArea	:=	GetArea()
Local lRet	:=	.T.
Local aAux	:=	{}

If cCampo == "U5_CONTAT"
	aAux := strtokarr(M->U5_CONTAT," ")
	If len(aAux) < 2
		MsgAlert("Preencha o nome e sobrenome do contato","TTMAILV - TTNOMCT")
		lRet := .F.
	EndIf
	
	M->U5_CONTAT := Alltrim(M->U5_CONTAT)+SPACE(30-LEN(Alltrim(M->U5_CONTAT)))
EndIf
	            
RestArea(aArea)

Return(lRet)