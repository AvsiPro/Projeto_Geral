#Include "PROTHEUS.CH"
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FINA200   �Autor  �Anderson Lima  - DD � Data �  17/08/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para realizar alteracoes nas variaveis    ���
���          � do arquivo de retorno                                      ���
�������������������������������������������������������������������������͹��
���Uso       � ADT - FINANCEIRO                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function FA200POS(cBanco)

	Local aValores 	:= PARAMIXB[1]
	Local aTitulo	:= {}
	Local xAlias	:= Alias()
	Local cDescri	:= ""
	Local cTipoRet	:= "R"
	Local cRetBanc  := Padr(aValores[1][14],3)
	Local aAreaAtu	:= GetArea()
	Local aAreaSE1	:= SE1->( GetArea() )
	Local cChave	:=  substr(cNumTit,1,15)
	Local cBan		:= MV_PAR06

If cNsNum <> ""
	Dbselectarea("SE1")
	DbSetOrder(29)
	If DbSeek(xFilial("SE1")+cNsNum)

		RecLock("SE1",.F.)
		Replace SE1->E1_OCORREN With SEB->EB_REFBAN

		cDescri :=posicione("SEB",1,xFILIAL("SEB")+SE1->E1_PORTADO+PADR(SE1->E1_OCORREN,3)+cTipoRet,"EB_DESCRI")//Pega descricao da ocorrencia
		cNumTit:=SE1->E1_IDCNAB
		// Grava a descricao da ocorrencia e o numero do banco na SE1
	
	EndIf
EndIF
	SE1->(MsUnlock())
	RestArea(aAreaAtu)
	RestArea(aAreaSE1)
Return
