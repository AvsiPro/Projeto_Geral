#INCLUDE "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MS520VLD �Autor  �Bruno Daniel Borges � Data �  25/09/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para validar a exclusao de NFs de Saida    ���
���          �que foram DISTRIBUIDAS                                      ���
�������������������������������������������������������������������������͹��
���Uso       � Toktake                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MS520VLD()

Local aAreaBKP := GetArea()

Local cUsrAut   := ""	//Upper(AllTrim(SuperGetMV("MV_XADMFIS")))
Local cUserLib  := Upper(AllTrim(cusername))


// Tratamento para AMC
If cEmpAnt == "10"
	Return .T.
EndIf

cUsrAut   := Upper(AllTrim(SuperGetMV("MV_XADMFIS")))

IF !(cUserLib$(cUsrAut))
	//Nao permitir a exclusao de uma nota fiscal de saida do tipo transferencia entre filiais.
	If !Empty(Alltrim(SF2->F2_XTRANSF))
		MsgAlert("Aten��o, a nota fiscal "+Alltrim(SF2->F2_DOC)+" � relativa a transferencia para filial "+Alltrim(SF2->F2_XTRANSF)+". Exclus�o n�o permitida.")
		Return(.F.)
	EndIf
	//Nao permitir a exclusao de uma nota fiscal com carga gerada.
	If !Empty(SF2->F2_XCARGA)
		MsgAlert("Aten��o, a nota fiscal "+Alltrim(SF2->F2_DOC)+" possui o n�mero de romaneio "+Alltrim(SF2->F2_XCARGA)+" gerado. Primeiro estorne o romaneio antes de excluir a NF.")
		Return(.F.)
	EndIf
End

//Apenas NFs de abastecimento
//If SF2->F2_XNFABAS == "1"
If SF2->F2_XNFABAS == "1" .And. AllTrim(SF2->F2_XFINAL) <> "4"        // Alterado - desconsiderar finalidade 4 -> Abastecimento PA <- Controle de Entregas - Jackson 08/04/2015
	dbSelectArea("SD2")
	SD2->(dbSetOrder(3))
	SD2->(dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
	While SD2->(!Eof()) .And. SD2->D2_FILIAL + SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE + SD2->D2_LOJA == xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA
		If SD2->D2_XSLDPA <> SD2->D2_QUANT
			RestArea(aAreaBKP)
			MsgAlert("Aten��o, a nota fiscal " + SF2->F2_DOC + " � uma nota fiscal de ABASTECIMENTO e distribui��es de seus itens foram localizadas. Primeiro estorne as distribui��es antes de excluir a NF.")
			Return(.F.)
		EndIf
		SD2->(dbSkip())
	EndDo
EndIf

RestArea(aAreaBKP)

Return(.T.)