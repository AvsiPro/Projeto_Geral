#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMBM000    บAutor  ณJackson E. de Deus  บ Data ณ  14/12/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ativa/Desativa aparelho e atendente                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MBM000(Atendente,imei, manuf, model, apilvl, osver, appver, idgcm, chip1, tpdev,RgOper)
           
Local cJson := ""
Local oObj
Local aJson := {}
Local oItem 
Local KeyUnq := Imei
Local cNome := ""
Local cTipo := ""
Local cDevCarga := ""

If cEmpAnt <> "01"
	Return
EndIf
     
If AllTrim(idgcm) == "XYZ"
	idgcm := ""
EndIf

If AllTrim(chip1) == "XYZ"
	chip1 := ""
EndIf

/*
ativacao
	se aparelho esta livre           
    se ja esta para esse atendente

desativacao           
	se aparelho esta para esse atendente
*/

// Ativar
If RgOper == "1"
	dbSelectArea("SZS")
	
	// verifica se atendente ja nao esta em outro aparelho
	dbSetOrder(2)
	If msSeek( xFilial("SZS") +AvKey(Atendente,"ZS_CODTEC") )
		If AllTrim(SZS->ZS_IDUNQ) <> AllTrim(KeyUnq)
			oObj := JsonObject():New()		
			oObj:PutVal("status","error")
			oObj:PutVal("result","Atendente jแ ativado em outro aparelho!")
			
			cJson := oObj:ToJson()
			Return cJson 
		EndIf
	EndIf
	
	
	dbSetOrder(1)  // 1 - filial uniq / 2 - filial atendente / 3 - filial chip
	If msSeek( xFilial("SZS") +AvKey(keyunq,"ZS_IDUNQ") )
		// com atendente ja associado
		//If !Empty(SZS->ZS_CODTEC)
			// ja registrado para esse atendente
			/*
			If upper(AllTrim(SZS->ZS_CODTEC)) == upper(AllTrim(Atendente))
				oObj := JsonObject():New()
				oObj:PutVal("status","ok")
				oObj:PutVal("result","Ativado!")
				
				cJson := oObj:ToJson()
			
			// ja registrado para outro atendente
			Else
				oObj := JsonObject():New()		
				oObj:PutVal("status","error")
				oObj:PutVal("result","Jแ ativado para outro atendente! Entre em contato com a central.")
				
				cJson := oObj:ToJson()
			EndIf
			*/
		// sem atendente associado	
		//Else
			RecLock("SZS",.F.)
			SZS->ZS_VDROID	:= osver
			SZS->ZS_VAPI	:= apilvl
			SZS->ZS_VAPP	:= appver
			SZS->ZS_IDGCM	:= idgcm
			SZS->ZS_CODTEC := Atendente
			SZS->ZS_DTREG := Date()
			SZS->ZS_HRREG := Time()
			MsUnLock()
			
			
		//EndIf
	Else
		RecLock("SZS",.T.)
		SZS->ZS_FILIAL	:= xFilial("SZS")
		SZS->ZS_MARCA	:= manuf         
		SZS->ZS_MODEL	:= model
		SZS->ZS_VDROID	:= osver
		SZS->ZS_VAPI	:= apilvl
		SZS->ZS_VAPP	:= appver
		SZS->ZS_IDGCM	:= idgcm
		SZS->ZS_DTREG	:= Date()
		SZS->ZS_HRREG	:= Time()
		SZS->ZS_IDUNQ	:= keyunq
		SZS->ZS_CHIP	:= chip1 
		SZS->ZS_TIPO	:= tpdev
		SZS->ZS_CODTEC	:= Atendente
		MsUnLock()
	EndIf
	
	dbSelectArea("AA1")
	dbSetOrder(1)
	If msSeek( xFilial("AA1") +AvKey(Atendente,"AA1_CODTEC") )
		cNome := AllTrim(AA1->AA1_NOMTEC)
		// rota
		If AllTrim(AA1->AA1_XARMOV) == "S"
			cTipo := "ROTA"
		// residente/itinerante
		ElseIf AllTrim(AA1->AA1_XARMOV) == "N"
			If AllTrim(AA1->AA1_XITINE) == "N"
				cTipo := "RESID"                  
			ElseIf AllTrim(AA1->AA1_XITINE) == "S"
				cTipo := "ITINE"
			EndIf
		EndIf
	EndIf
	
	// armazem vinculado - ZZ1
	cQuery := "SELECT ZZ1_DEVCAR FROM " +RetSqlName("ZZ1")
	cQuery += " WHERE ZZ1_XATEND = '"+Atendente+"' AND D_E_L_E_T_ = '' "
	MpSysOpenQuery( cQuery,"TRB" )
	dbSelectArea("TRB")
	If TRB->ZZ1_DEVCAR == "T"
		cDevCarga := "s"
	Else 
		cDevCarga := "n"
	EndIf
	
	
	
	oObj := JsonObject():New()
	oObj:PutVal("status","ok")
	oObj:PutVal("result","Ativado!")
	
	oItem := JsonObject():New()
	oItem:PutVal("nome", cNome )
	oItem:PutVal("tipo", cTipo )
	oItem:PutVal("rota", AA1->AA1_LOCAL )
	oItem:PutVal("devcarga",cDevCarga)
	
	
	AADD(aJson,oItem)        
	oObj:PutVal("lista",aJson)
	
	cJson := oObj:ToJson()		

// desativar	
Else
	dbSelectArea("SZS")
	dbSetOrder(1)  // 1 - filial uniq / 2 - filial atendente / 3 - filial chip
	If !msSeek( xFilial("SZS") +AvKey(keyunq,"ZS_IDUNQ") )
		oObj := JsonObject():New()		
		oObj:PutVal("status","error")
		oObj:PutVal("result","Aparelho nใo encontrado!")
		
		cJson := oObj:ToJson()
	Else
		If !Empty(SZS->ZS_CODTEC)
			// registrado para esse atendente - OK
			If upper(AllTrim(SZS->ZS_CODTEC)) == upper(AllTrim(Atendente))
				RecLock("SZS",.F.)
				SZS->ZS_CODTEC := ""
				SZS->ZS_DTREG := STOD("")
				SZS->ZS_HRREG := ""
				MsUnLock()
				
				oObj := JsonObject():New()
				oObj:PutVal("status","ok")
				oObj:PutVal("result","Desativado!")
				
				cJson := oObj:ToJson()
			
			// registrado para outro atendente - NAO
			Else
				oObj := JsonObject():New()		
				oObj:PutVal("status","ok")
				oObj:PutVal("result","Jแ ativado para outro atendente!")
				
				cJson := oObj:ToJson()
			EndIf
		EndIf
	EndIf
EndIf

conout("json:" +cjson)
	   
Return cJson