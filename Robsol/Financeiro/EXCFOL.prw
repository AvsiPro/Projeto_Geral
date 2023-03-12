#include 'protheus.ch'
#include 'parmtype.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EXCFOL  �Autor  �Rodrigo Barreto   � Data �  20/01/2023   ���
�������������������������������������������������������������������������͹��
���Desc.     �Exclue registros da tabela ZZ1 conforme ID				���
���          �										                     ���
�������������������������������������������������������������������������͹��
���Uso       � RobSol                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function EXCFOL()

	Local aArea    := GetArea()
	Local aPergs := {}
	Local cIdTit := Space(9)
	Private lOK := .T.

	aAdd(aPergs, {1, "Informe o ID dos t�tulos ",			 		cIdTit,  "",  ".T.",   "",  ".T.", 80,  .T.})

	If ParamBox(aPergs, "Informe os par�metros")
		Processa({||EXCZZ1()},,"Processando...")
		If lOK
			MsgAlert('ATEN��O: Registros de ID  '+ MV_PAR01 + ', exclu�dos! Exclua o t�tulo principal no contas a Pagar.')
		EndIf
	EndIf

	restArea(aArea)
return

//Deletar registros
Static Function EXCZZ1

	Local cIdZZ1 := MV_PAR01
	//Local lOK := .T.

	DbSelectArea("ZZ1")
	ZZ1->(DbSetOrder(2)) //Filial+Ordem Producao
	if ZZ1->(DbSeek(xFilial("ZZ1")+cIDZZ1)) //cGet1 = Numero da Ordem de Produ��o
		While ZZ1->(DbSeek(xFilial("ZZ1")+cIDZZ1))
			ZZ1->(RecLock("ZZ1",.F.))
			ZZ1->(DbDelete())
			ZZ1->(MsUnLock())
		EndDo
	else
		alert("Registro n�o localiado, verifique a filial logada.")
		lOk := .F.
	EndIf

return lOk
