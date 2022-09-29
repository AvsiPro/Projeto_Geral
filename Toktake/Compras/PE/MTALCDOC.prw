#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTALCDOC  ºAutor  ³CADUBITSKI	         º Data ³  10/02/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para gravar campos especificos no SCR     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MTALCDOC()

Local aArea 	:= GetArea()
Local aAreaSA2 	:= SA2->(GetArea())
Local aAreaSC7 	:= SC7->(GetArea())
Local aAreaSF1 	:= SF1->(GetArea())
Local aAreaSCR 	:= SCR->(GetArea())
Local cDoc		:= Alltrim(ParamIxb[1][1]) //Numero do documento
Local cTipo		:= Alltrim(ParamIxb[1][2]) //NF ou PC
Local cNome		:= ""
Local cStatus	:= ""
Local cNaturez	:= ""
Local cCod		:= ""
Local cLoja		:= ""
Local cDatPrev  := ctod("  /  /  ")

If cEmpAnt == "01"
	dbSelectArea("SCR")
	dbSetOrder(1)
	dbGoTop()
	
	If dbSeek(xFilial("SCR")+cTipo+cDoc)
	
		While !Eof() .and. Alltrim(SCR->CR_TIPO)+Alltrim(SCR->CR_NUM) == cTipo+cDoc
	
			cNome	:= ""
			cStatus	:= ""
			cNaturez:= ""
			cCod	:= ""
			cLoja	:= ""
			cDatPrev:= ctod("  /  /  ")
			
			If Alltrim(Upper(FunName())) == "MATA121"
				cStatus := "AL"
			Else
				If SCR->CR_STATUS == "02"
					cStatus := "PA"
				EndIf
			EndIf
			
			If cTipo == "NF"
				dbSelectArea("SF1")
				dbSetOrder(1)
				If dbSeek(xFilial("SF1")+cDoc)
					cNome 	:= GetAdvFVal("SA2","A2_NOME",xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,1,0) 
					cNaturez:= GetAdvFVal("SA2","A2_NATUREZ",xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,1,0) 
					cCod	:= SF1->F1_FORNECE
					cLoja	:= SF1->F1_LOJA
				EndIf
			Else
				dbSelectArea("SC7")
				dbSetOrder(1)
				If dbSeek(xFilial("SC7")+cDoc)
					cNome 	:= GetAdvFVal("SA2","A2_NOME",xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,1,0) 
					cNaturez:= GetAdvFVal("SA2","A2_NATUREZ",xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,1,0) 
					cCod	:= SC7->C7_FORNECE
					cLoja	:= SC7->C7_LOJA
					cDatPrev:= SC7->C7_DATPRF
				EndIf
			EndIf
			
			dbSelectArea("SCR")
			
			RecLock("SCR",.F.)
				If FieldPos("CR_XSTATUS") > 0
					SCR->CR_XSTATUS	:= cStatus
				EndIf
				If FieldPos("CR_XFORNEC") > 0
					SCR->CR_XFORNEC	:= Alltrim(cNome)
				EndIf
				If FieldPos("CR_XNAT") > 0
					SCR->CR_XNAT	:= Alltrim(cNaturez)
				EndIf
				If FieldPos("CR_XUSER") > 0
					SCR->CR_XUSER 	:= Alltrim(cUserName)
				EndIf
				If FieldPos("CR_XDATENT") > 0
					SCR->CR_XDATENT := cDatPrev  
				EndIf
				If SCR->(FieldPos("CR_XCOD")) > 0 .and. SCR->(FieldPos("CR_XLOJA")) > 0
					SCR->CR_XCOD 	:= cCod
					SCR->CR_XLOJA	:= cLoja
				EndIf
			MsUnLock()         
			
			dbSkip()
	
		EndDo
	
	EndIf
EndIF


RestArea(aAreaSCR)
RestArea(aAreaSF1)
RestArea(aAreaSC7)
RestArea(aAreaSA2)
RestArea(aArea)

Return()