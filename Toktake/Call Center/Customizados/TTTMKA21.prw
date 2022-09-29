#INCLUDE "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTMTKA21  ºAutor  ³Jackson E. de Deus  º Data ³  11/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Valida contrato digitado na OMM.                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TTTMKA21()

Local lRet := .T.
Local aArea := GetArea()
Local nPosContr := If(cEmpAnt=="01",Ascan(aHeader,{|x|AllTrim(x[2])=="UD_XCONTRA"}),0)
Local nPosItem :=  If(cEmpAnt=="01",Ascan(aHeader,{|x|AllTrim(x[2])=="UD_ITEM"}),"")
Local cContrato := If(cEmpAnt=="01",M->UD_XCONTRA,"")
Local cCodCli := ""
Local cTpLocac	:= If(cEmpAnt=="01",SuperGetMV("MV_XTMK020",.T.,""),"")		// Tipo de contrato de locacao

If cEmpAnt <> "01"
	Return
EndIf

If Empty(cContrato)
	Return lRet
EndIf

              
dbSelectArea("CN9")
dbSetOrder(1)
If !dbSeek( Avkey("01","CN9_FILIAL") +AvKey(cContrato, "CN9_NUMERO") +AvKey("","CN9_REVISA") )
	Aviso("TTTMKA21","O contrato informado não existe." +CRLF +"Informe um contrato válido.",{"Ok"} ) 
	lRet := .F.
Else                              
	dbSelectArea("SUC")
	cCodCli := SubStr(SUC->UC_CHAVE,1,6)

	If AllTrim(CN9->CN9_CLIENT) <> AllTrim(cCodCli)
		Aviso("TTTMKA04","O contrato informado não pertence ao cliente da OMM." +CRLF +"Contrato: " +oMsGD:Acols[oMsGD:nAt][nPosContr],{"Ok"})
		lRet := .F.
		Return lRet
	EndIf
    
	dbSelectArea("SUD")
	aAreaSUD := GEtArea()
	dbSeek( xFilial("SUD") +SUC->UC_CODIGO +oMsGD:Acols[oMsGD:nAt][nPosItem])
	If AllTrim(SUD->UD_XTPCONT) == "1"
		If AllTrim(CN9->CN9_TPCTO) <> AllTrim(cTpLocac)
			Aviso("TTTMKA21","O contrato informado é inválido." +CRLF +"Informe um contrato de locação.",{"Ok"})
			lRet := .F.
			Return lRet
		EndIf
	EndIf
	RestArea(aAreaSUD) 
EndIf

                       
RestArea(aArea)

Return lRet