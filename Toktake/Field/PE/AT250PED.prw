#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AT250PED  ºAutor  ³Microsiga           º Data ³  09/06/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  PE para calcular pro-rata nos contratos de servicos       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AT250PED

Local aArea		:=	GetArea()            
Local nPosCnt   :=	Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_CONTRT"})
Local nPosItm	:=	Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_ITCONTR"}) 
Local nPosVUn	:=	Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_PRCVEN"}) 
Local nPosVLs	:=	Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_PRUNIT"}) 
Local nPosVTo	:=	Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_VALOR"})  
Local nPosQtd	:=	Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_QTDVEN"})   
Local nPosAtv	:=	Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_NUMSERI"})
Local nCon		:=	0                           
Local nVlrPro	:=	0
Local nDiasMs	:=	day(lastday(ddatabase))
Local nDiasCb	:=	0                           
Local nNewVlr	:=	0     
Local cMesRef	:=	'Mes de Referencia do faturamento '+mesextenso(month(ddatabase))+"/"+cvaltochar(year(ddatabase))
 
If cEmpAnt == "10" 
	//Gravando a informação de referencia do faturamento do contrato. 
	M->C5_MENNOTA := Alltrim(M->C5_MENNOTA)+cMesRef
	
	DbSelectArea("AAN")
	DbSetOrder(1)
	
	For nCon:= 1 to len(aCols)
		If Dbseek(xFilial("AAN")+aCols[nCon,nPosCnt]+aCols[nCon,nPosItm])  
	        //Gravando o numero do Ativo no item do pedido de venda
	        aCols[nCon,nPosAtv] := AAN->AAN_XCBASE
	        
			//Valor Diario da locacao do equipamento em referencia a quantidade de dias no mes corrente
			nVlrPro := AAN->AAN_VLRUNI / nDiasMs 
	
			//Se o inicio da cobranca é maior que o primeiro dia do mes, então deve-se cobrar pro-rata.
			If AAN->AAN_INICOB > firstday(ddatabase)
				//Quantidade de dias a serem cobrados até o final do mês (segundo o Cassio os contratos sempre são cobrados do dia 01 ao ultimo dia do mes
				nDiasCb := lastday(ddatabase) - AAN->AAN_INICOB
				//Valor a ser cobrado com a pro-rata
				nNewVlr := nVlrPro * nDiasCb
				//Alterando o valor do faturamento no calculo do pro-rata.
				If nNewVlr > 0
					aCols[nCon,nPosVUn] := nNewVlr
					aCols[nCon,nPosVLs] := nNewVlr
					aCols[nCon,nPosVTo] := aCols[nCon,nPosVUn] * aCols[nCon,nPosQtd]
				EndIf
			ElseIf AAN->AAN_INICOB == firstday(ddatabase)
				//Cobrar o valor cheio para o mes todo
				nNewVlr := AAN->AAN_VLRUNI
			//Se o fim da cobranca é menor que o ultimo dia do mes, então deve-se cobrar pro-rata dos dias em que a maquina saiu.
			ElseIf AAN->AAN_FIMCOB < lastday(ddatabase)
				//Quantidade de dias a serem cobrados do primeiro até a data da saída da maquina do cliente.
				nDiasCb := AAN->AAN_FIMCOB - firstday(ddatabase)
				//Valor a ser cobrado com a pro-rata
				nNewVlr := nVlrPro * nDiasCb
				//Alterando o valor do faturamento no calculo do pro-rata.
				If nNewVlr > 0
					aCols[nCon,nPosVUn] := nNewVlr
					aCols[nCon,nPosVLs] := nNewVlr
					aCols[nCon,nPosVTo] := aCols[nCon,nPosVUn] * aCols[nCon,nPosQtd]
				EndIf
			ElseIf AAN->AAN_FIMCOB == lastday(ddatabase)
				nNewVlr := AAN->AAN_VLRUNI
			EndIf
		EndIF
	Next nCon
EndIf

RestArea(aArea)

Return