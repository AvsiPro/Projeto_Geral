/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ�
��Programa  � MA440VLD � Autor � Artur Nucci Ferrari     � Data � 12/04/10 ��
��������������������������������������������������������������������������Ĵ�
��Descricao � Ponto de Entrada para validacao na liberacao do PV           ��
��          � Libera��o Manual                                             ��
��������������������������������������������������������������������������Ĵ�
��Uso       � Pedido de Venda                                              ��
��������������������������������������������������������������������������Ĵ�
��Empresa   � Tok Take                                                     ��
��������������������������������������������������������������������������Ĵ�
*/
#INCLUDE "RWMAKE.CH"

User Function MA440VLD()
Local nPosCod  := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_TES"  	})
Local nPosCodP := AScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO" })
Local dDtLib   := stod("")	//SuperGetMV("MV_XBLQLIB")
Local cxTESC   := ""	//GetNewPar("MV_XTESC","888")
Local cProduto := Space(1)
Local cMens    := ""
Local cRet     := .T.
Local cErro    := 0

MV_PAR06 := ddatabase+1
MV_PAR07 := ddatabase+1

 
// Tratamento para AMC
If cEmpAnt == "10"
	Return .T.
EndIf


dDtLib   := SuperGetMV("MV_XBLQLIB")
cxTESC   := GetNewPar("MV_XTESC","888")


//����������������������������������������������������������������������������Ŀ
//� BLOQUEIO DE FATURAMENTO                                                    �
//������������������������������������������������������������������������������
If date() <= dDtLib
	MsgBox ("Reservas de estoque para Pedido de Venda est�o bloqueadas.","Erro!!!","STOP")
	cRet := .F.
	Return(cRet)
End              
//����������������������������������������������������������������������������Ŀ
//� CONTROLE DE LIBERACAO DOS PEDIDOS DE VENDA                                 �
//������������������������������������������������������������������������������
If SC5->C5_XSTLIB<>0
	AVISO("MESSAGEM","Este pedido dever� passar pela aprova��o para ser liberado.",{"OK"},1)
	Return .F.
End                                                                             
//����������������������������������������������������������������������������Ŀ
//� CONTROLE DE LIBERACAO DOS PEDIDOS DE VENDA                                 �
//������������������������������������������������������������������������������
If SC5->C5_XDTENTR<DATE()
	AVISO("MESSAGEM","N�o � permitido libera��o de pedidos quan a data de entrega anterior ao dia de hoje.",{"OK"},1)
	Return .F.
End
//����������������������������������������������������������������������������Ŀ
//� CONTROLE DA TES 888                                                        �
//������������������������������������������������������������������������������
For I := 1 to Len(aCols)
	If aCols[i,nPosCod] = cXTESC //"888" TES de Reclassificacao de pedido.
		cErro := cErro +1
		cProduto := cProduto + aCols[i,nPosCodp] +" - "
	End
Next
//����������������������������������������������������������������������������Ŀ
//� CONTROLE DE ERRO                                                           �
//������������������������������������������������������������������������������
If cErro > 0
	cMens := "ATENCAO. Favor Reclassificar Pedido de Venda, Antes de Libera-lo. Produtos que necessitam de reclassificacao: "+cProduto
	Alert(cMens)
	cRet := .f.
Else
	cRet := .t.
EndIf
Return(cRet)