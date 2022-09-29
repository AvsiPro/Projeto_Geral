#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTOPER09  �Autor  �Jackson E. de Deus  � Data �  12/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna inf. sobre o sistema de pagamento da maquina       ���
���          �															  ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  �Versao| Alteracao realizada                    ���
�������������������������������������������������������������������������Ĵ��
���Jackson       �12/08/14�01.00 |Criacao                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function TTOPER09(cPatrimo,cSisPg)

Local aSisPg := {"","","",""}             
Local cLacre := ""
Local cMoeTroco := ""
Local cLog := ""
Local cTroco := ""
Local aAuxPg := {}
Local aAux2 := {}
Local cProduto := ""
Local nJ                    
Default cPatrimo := ""
Default cSisPg := ""

If cEmpAnt <> "01"
	Return
EndIF	

If Empty(cPatrimo)
	Return aSisPg
EndIf            

If Empty(cSisPg)
	cSisPg := Posicione( "SN1", 2, xFilial("SN1") +AvKey(cPatrimo,"N1_CHAPA"), "N1_XSISPG" )
EndIf


cProduto := Posicione( "SN1", 2, xFilial("SN1") +AvKey(cPatrimo,"N1_CHAPA"), "N1_PRODUTO" )

aAuxPg := StrToKarr(cSisPg,"|")
// Log
If AllTrim(cProduto) == "8001406"
	clacre := "Lacres com cedula"
	cLog := "sim"
	//clacre := ""
	//cMoeTroco := "n�o"
	//cTroco := "n�o"
	If !Empty(aAuxPg)                 		
		If allTrim(aAuxPg[2]) == "MC=1"
			cMoeTroco := "sim"
			cTroco := "sim"
		Else 
			cMoeTroco := "n�o"
			cTroco := "n�o"
		EndIf	
	EndIf
Else
	cLog := "n�o"
	If LEN(aAuxPg) > 1
		// verifica cedula CE=?
		If AllTrim(aAuxPg[1]) == "CE=1"
			clacre := "Lacres com cedula"
			
			// verifica moedeiro com troco MC=?
			If allTrim(aAuxPg[2]) == "MC=1"
				cMoeTroco := "sim"
				cTroco := "sim"
			Else
				cMoeTroco := "n�o"
				cTroco := "n�o"
			EndIf
		ElseIf allTrim(aAuxPg[2]) == "MC=1" .Or. allTrim(aAuxPg[3]) == "MS=1"
			clacre := "Lacres sem cedulas"
			
			// verifica moedeiro com troco MC=?
			If allTrim(aAuxPg[2]) == "MC=1"
				// verifica moedeiro sem troco MS=?
				cMoeTroco := "sim"
				cTroco := "sim"
			EndIf
			If allTrim(aAuxPg[3]) == "MS=1"
				cMoeTroco := "n�o"
				cTroco := "n�o"
			EndIf

		Else
			clacre := ""
		EndIf
	EndIf	
EndIf

// verifica tipo de pagamento da maquina - Se SMART ou CANETA o LOG = SIM
For nJ := 1 To Len(aAuxPg)
	If aAuxPg[nJ] $ "SM=1|CA=1"
		cLog := "sim"
		Exit
	EndIf
Next nJ

aSisPg[1] := clacre
aSisPg[2] := cMoeTroco
aSisPg[3] := cLog
aSisPg[4] := cTroco


Return aSisPg
