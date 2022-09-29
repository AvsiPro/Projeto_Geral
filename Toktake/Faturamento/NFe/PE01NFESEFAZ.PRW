#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PE01NFESEFAZºAutor  ³Jackson E. de Deusº Data ³  10/03/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE para manipulacao dos dados da NFE - nfesefaz	          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION PE01NFESEFAZ()

Local aProd		:= PARAMIXB[1]
Local cMensCli	:= PARAMIXB[2]
Local cMensFis	:= PARAMIXB[3]
Local aDest		:= PARAMIXB[4] 
Local aNota   	:= PARAMIXB[5]
Local aInfoItem	:= PARAMIXB[6]
Local aDupl		:= PARAMIXB[7]
Local aTransp	:= PARAMIXB[8]
Local aEntrega	:= PARAMIXB[9]
Local aRetirada	:= PARAMIXB[10]
Local aVeiculo	:= PARAMIXB[11]
Local aReboque	:= PARAMIXB[12]
Local aNfVinc	:= PARAMIXB[13]
Local aArea		:= GetArea()
Local aRetorno	:= {}
Local cEndEnt	:= ""
Local cCodPA	:= ""
Local cOurPed	:= ""


// mensagem - dados adicionais
If AllTrim( Alias() ) == "SD1"
	// nada
Else
	If cEmpAnt == "01"
		If AllTrim(SF2->F2_XNFABAS) == "1"
			If !Empty(SF2->F2_XCODPA)
				cCodPa := "P.A.: "+AllTrim(SF2->F2_XCODPA)
				dbSelectArea("ZZ1")
				dbSetOrder(1)
				If MsSeek(xFilial("ZZ1") +AvKey(SF2->F2_XCODPA,"ZZ1_COD"))
					cCodPa += " - " +AllTrim(ZZ1->ZZ1_DESCRI)
					cEndEnt := "End.Entrega: "+Alltrim(ZZ1->ZZ1_END) +" - " +Alltrim(ZZ1->ZZ1_BAIRRO) +" - " +Alltrim(ZZ1->ZZ1_MUN) +" - " +Alltrim(ZZ1->ZZ1_EST) +" - " +Alltrim(ZZ1->ZZ1_CEP)
				EndIf
			EndIf
		EndIf
	ElseIf cEmpAnt == "10"
		DbSelectArea("SA1")
		DbSetOrder(1)
		If DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
			If !Empty(SA1->A1_ENDENT)
				cEnd1 := strtran(Alltrim(SA1->A1_ENDENT),"º","")
				cEnd1 := strtran(Alltrim(SA1->A1_ENDENT),"ª","")
				cEnd2 := Alltrim(SA1->A1_BAIRROE)
				cEnd3 := Alltrim(SA1->A1_MUNE)
				cEndEnt := "End. Entrega: "+cvaltochar(cEnd1)+" - " +cvaltochar(cEnd2)+" - " +cvaltochar(cEnd3)
			EndIf
		EndIf  
	EndIf
	
	If !SF2->F2_TIPO $ "BD"
		cOurPed := " - Pedido: " +SD2->D2_PEDIDO +" Cod.Cli.: " +SF2->F2_CLIENTE+SF2->F2_LOJA
		If !Empty(cCodPa)
			cOurPed += " " +cCodPa +" " +cEndEnt
		EndIf
		
		cMensCli += AllTrim(cOurPed) //+ Space(125 - Len(AllTrim(cOurPed))) +CRLF
		If Empty(cEndEnt)
			cMensCli += " - Nome Fantasia : "+Alltrim(Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_NREDUZ"))
		Else
			cMensCli += cEndEnt
		EndIf
	EndIf

EndIf  



aadd(aRetorno,aProd)
aadd(aRetorno,cMensCli)
aadd(aRetorno,cMensFis)
aadd(aRetorno,aDest)
aadd(aRetorno,aNota)
aadd(aRetorno,aInfoItem)
aadd(aRetorno,aDupl)
aadd(aRetorno,aTransp)
aadd(aRetorno,aEntrega)
aadd(aRetorno,aRetirada)
aadd(aRetorno,aVeiculo)
aadd(aRetorno,aReboque)
aadd(aRetorno,aNFVinc)

RestArea(aArea)
              
RETURN aRetorno