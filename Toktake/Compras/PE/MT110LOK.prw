#Include 'Protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT110LOK � Autor �   Cadubitski         �Data�  27/01/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para validar a linha digitada da           ���
���          �solicitacao de compras.                                     ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT110LOK()                                   

Local aArea		:= GetArea()
Local lRet		:= .T.
Local cconta	:= aCols[n, aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "C1_CONTA"})]
Local ccc    	:= aCols[n, aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "C1_CC"})]
Local cItCt    	:= aCols[n, aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "C1_ITEMCTA"})]
Local dEPC    	:= aCols[n, aScan(aHeader, {|_1| Upper(AllTrim(_1[2])) == "C1_DATPRF"})]

If cEmpAnt == "01" .or. cEmpAnt == "02"
	if substr(cconta,1,1)="4"
	   if empty(ccc)
		MsgInfo("Favor informar o Centro de Custo. Conta Contabil Despesas (Iniciando 4).","ATEN��O!!!")
		lRet := .F.
		Return(lRet)
	   endif
	endif   
	
	If substr(ccc,1,2)="03"
	   If empty(cItCt)
		MsgInfo("Favor informar o Item Contabil. Centro de Custo (Iniciando 03).","ATEN��O!!!")
		lRet := .F.
		Return(lRet)
	   EndIf
	EndIf   
	
	If dEPC <= dDataBase
	   If empty(dEPC)
		MsgInfo("Favor informar verificar a data informada para necessidade.","ATEN��O!!!")
		lRet := .F.
		Return(lRet)
	   EndIf
	EndIf
EndIf

RestArea(aArea)

Return(lRet)