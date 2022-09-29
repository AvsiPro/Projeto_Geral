#Include "PROTHEUS.CH"                    

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AMCFAT03 �Autor  �Ronaldo G. de Jesus � Data �  08/05/17   ���
�������������������������������������������������������������������������͹��
���Descricao � Verifica se a saldo suficiente para atendimento.           ���
���          � Saldo em Estoque.                                          ���
�������������������������������������������������������������������������͹��
���Uso       � AMC		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function AMCFAT03()    

Local aProd := aScan(aHeader,{|x|ALLTrim(x[2])=="C6_PRODUTO"})
Local aAmz := aScan(aHeader,{|x|ALLTrim(x[2])=="C6_LOCAL"})  
Local cProd := aCols[n][aProd]
Local cAmz := aCols[n][aAmz]
Local nQtdPed := M->C6_QTDVEN
Local nQtdAut := 0
Local nQtdRes := 0
Local nPedRes := 0

//Local nQtdAut := Posicione("SB2",1,xFilial("SB2")+cProd+cAmz,"B2_QATU")  
If cEmpAnt <> "10"
	Return(nQtdPed)
EndIf

	 nQtdAut := CalcEst(cProd,cAmz,dDataBase) //Posicione("SB2",1,xFilial("SB2")+cProd+cAmz,"B2_QATU-B2_QEMP-B2_RESERVA-B2_QEMPSA")
	 nQtdRes := Posicione("SB2",1,xFilial("SB2")+cProd+cAmz,"B2_RESERVA")
	 nPedRes := Posicione("SB2",1,xFilial("SB2")+cProd+cAmz,"B2_QPEDVEN")

If nQtdPed > nQtdAut[1]
   //Alert("! Quantidade em Estoque INSUFICIENTE")
   MsgAlert("Quantidade insuficiente em estoque para atender esta solicita��o"+chr(13)+chr(10)+chr(13)+chr(10)+;
   "Codigo do Produto: "+Alltrim(cProd)+chr(13)+chr(10)+;
   "Armazem Solicitado: "+Alltrim(cAmz)+chr(13)+chr(10)+;   
   "Saldo Total Dispon�vel: "+cvaltochar(nQtdAut[1])+chr(13)+chr(10)+;
   "Saldo Total Pedidos de Vendas: "+cvaltochar(nPedRes)+chr(13)+chr(10)+;
   "Saldo Total Reservado: "+cvaltochar(nQtdRes),"AMCFAT03 - Saldo Insuficiente")
   
   //nQtdPed := 0
EndIf

Return (nQtdPed)


/*
Local aProd := aScan(aHeader,{|x|ALLTrim(x[2])=="C6_PRODUTO"})
Local aAmz := aScan(aHeader,{|x|ALLTrim(x[2])=="C6_LOCAL"})  
Local cProd := aCols[n][aProd]
Local cAmz := aCols[n][aAmz]
Local nQtdPed := M->C6_QTDVEN
Local lRetorno := .F.


//Local nQtdAut := Posicione("SB2",1,xFilial("SB2")+cProd+cAmz,"B2_QATU")  

Local nQtdAut := CalcEst (cProd,cAmz,DDATABASE)	

If nQtdPed > nQtdAut
   MsgAlert("Quantidade insuficiente em estoque para atender esta solicita��o"+chr(13)+chr(10)+"Saldo Dispon�vel "+cvaltochar(nQtdAut),"AMCFAT03 - Saldo Insuficiente")
   //nQtdPed := 0   
Else
	lRetorno := .T.      
EndIf

Return lRetorno                  
*/   