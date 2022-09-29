#include "protheus.ch"
#include "ApWebSrv.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#INCLUDE "XMLXFUN.CH"  

/*
TTMWS - Web Service para integracao com mobile
*/
WsService TTMWS Description "Integração Mobile"
                                                                
    // parametros de entrada - metodo SetAcompanhamentoOrdemServico
	WsData authCode		As String
	WsData clientCode	As String
	WsData Atendente	As String
	WsData Codigo		As String
	WsData Rota			As String
	WsData NF			As String
	WsData NFSer		As String
	WsData Armazem		As String
	WsData Produto		As String
	WsData Maquina		As String
	WsData Mapa			As String
	WsData Imei			As String
	WsData Manuf		As String
	WsData Model		As String
	WsData Apilvl		As String
	WsData Osver		As String
	WsData Keyunq		As String
	WsData Appver		As String
	WsData Idgcm		As String
	WsData Chip1		As String 
	WsData Tpdev		As String
	WsData RgOper		As String
	WsData idnumber		As String
	WsData values		As String	
	WsData dtHoraInicio	As String
	WsData LatInicio	As String
	WsData LngInicio	As String
	WsData dtHoraFim	As String
	WsData LatFim		As String
	WsData LngFim		As String
	
	// Retorno do metodo SetAcompanhamentoOrdemServico
	//WsData SetAcompanhamentoOrdemServicoResult	As String	 
    WsData StartDevolutionResult				As String
    WsData UpdMapMachineResult					As String
    WsData RegOutPutInvoiceResult				As String
    WsData testeXResult							As String   
 	WsData shootResult							As String 
 	WsData getEquipamentosResult				As String 
 	WsData getEquipamentosTotalResult			As String 
 	WsData getProdutosResult					As String
 	WsData getProdutosTotalResult				As String
 	WsData getStatusRTResult					As String
 	WsData getOSResult							As String
 	WsData DeviceRegisterResult					As String
 	WsData setUpdOSResult						As String
 	WsDAta getStckResult						As String
 	WsData getOSCancelResult					As String
 	WsData getProductsResult					As String
 	WsData getCapResult							As String
 	WsData setExpedienteResult					As String
 	WsData getMaquinasMapaResult				As String
	
	
	// metodos do web service
	//WsMethod SetAcompanhamentoOrdemServico		Description "Recebe os dados do sistema Mobile"
	WsMethod StartDevolution					Description ""
	WsMethod RegOutputInvoice					Description ""
	WsMethod UpdMapMachine						Description "Mapa de máquina"
	WsMethod DeviceRegister						Description "Registro"
	WsMethod testeX								Description "Resumo dos atendimentos do dia"	// recebe dados das OS dos agentes
	WsMethod getStatusRT						Description ""	// status das Rotas
	WsMethod getStck							Description ""
	WsMethod getOS								Description "Retorna as Ordens de Serviço"
	WsMethod setUpdOS							Description "Atualiza Ordem de Serviço"
	WsMethod getOSCancel						Description "Retorna as Ordens de Serviço canceladas"
	WsMethod getProducts						Description "Produtos Mix"
	WsMethod getCap								Description "Capacidades de maquinas"
	WsMethod setExpediente						Description "Expediente"
	WsMethod getMaquinasMapa					Description "Maquinas para Mapa"
	/*
	WsMethod shoot								Description "Geração das ordens de serviço"
	WsMethod getEquipamentos					Description "Listagem dos equipamentos"
	WsMethod getEquipamentosTotal				Description "Listagem dos equipamentos - total"
	WsMethod getProdutos						Description "Listagem dos produtos"	
	WsMethod getProdutosTotal					Description "Listagem dos produtos - total"	
	*/
EndWsService



/*
StartDevolution - Inicia devolucao de Rota
*/

WsMethod StartDevolution WsReceive Atendente, authCode, Rota WsSend StartDevolutionResult WsService TTMWS
          
Local cEmp := "01"
Local cCodFil := "01"
Local cRetorno := ""
Local cRota := ""
Local cAuth := ""
Local bError         := { |e| oError := e , Break(e) }
Local bErrorBlock    := ErrorBlock( bError )

	
Prepare Environment Empresa cEmp Filial cCodFil    

BEGIN SEQUENCE

	//conout(Atendente)
	//conout(authcode)

	If Empty(authCode) .Or. Empty(Rota)
		//conout("authcode vazio")
		cRetorno := "Requisição inválida!"
	Else
		dbSelectArea("AA1")
		dbSetOrder(1)
		If MsSeek( xFilial("AA1") +avKey(Atendente,"AA1_CODTEC")  )
			//conout("achou atendente " +AA1->AA1_CODTEC +"/" +AA1->AA1_LOCAL)
			//cRota := AllTrim(AA1->AA1_LOCAL)
			cAuth := AllTrim(AA1->AA1_XMAUTH)
						
			If Empty(cAuth)
				//conout("xmauth vazio")
				cRetorno := "Autenticação inválida!"
			Else
				If upper(AllTrim(authCode)) <> upper(AllTrim(cAuth))
					//conout("autherro - " +authCode) +"-" +cAuth
					cRetorno := "Autenticação inválida!"
				Else
					cRetorno := STATICCALL( TTPROC57, fInicia, Rota,Atendente )
				EndIf		
			EndIf
		Else
			cRetorno := "Rota não encontrada! :("	
		EndIf
	EndIf

	::StartDevolutionResult := '{ "status":"ok", "result": "'+cRetorno +'" }'
	
RECOVER
	::StartDevolutionResult := '{"status":"error","result":' +oError:ErrorStack +'}'   
	ConOut( ProcName() + " " + Str(ProcLine()) + " " + oError:ErrorStack )
END SEQUENCE 
    
Reset Environment

Return .T.


/*
RegOutputInvoice - Registro de saida de nota fiscal
*/
WsMethod RegOutPutInvoice WsReceive Atendente, authCode, NF WsSend RegOutPutInvoiceResult WsService TTMWS
          
Local cEmp := "01"
Local cCodFil := "01"
Local cRetorno := ""
Local cRota := ""
Local cAuth := ""
Local bError         := { |e| oError := e , Break(e) }
Local bErrorBlock    := ErrorBlock( bError )
Local nRecno := 0
	
Prepare Environment Empresa cEmp Filial cCodFil    

BEGIN SEQUENCE

	If Empty(Atendente) .Or. Empty(authCode) .Or. Empty(NF)
		cRetorno := "Requisição inválida!"
	Else
		dbSelectArea("AA1")
		dbSetOrder(1)
		If MsSeek( xFilial("AA1") +avKey(Atendente,"AA1_CODTEC")  )
			cAuth := AllTrim(AA1->AA1_XMAUTH)
						
			If Empty(cAuth)
				cRetorno := "Autenticação inválida!"
			Else
				If upper(AllTrim(authCode)) <> upper(AllTrim(cAuth))
					cRetorno := "Autenticação inválida!"
				Else
			    	cRetorno := StaticCall( TTFATC30, RegOut, NF )
				EndIf
			EndIf
		Else
			cRetorno := "Atendente inválido!"	
		EndIf		
	EndIf

	::RegOutPutInvoiceResult := '{ "status":"ok", "result": "'+cRetorno +'" }'
	
RECOVER
	::RegOutPutInvoiceResult := '{"status":"error","result":' +oError:ErrorStack +'}'   
	ConOut( ProcName() + " " + Str(ProcLine()) + " " + oError:ErrorStack )
END SEQUENCE 
    
Reset Environment

Return .T.


/*
UpdMapMachine - Atualizacao de mapa de maquina
*/
WsMethod UpdMapMachine WsReceive Atendente, authCode, Maquina, Mapa WsSend UpdMapMachineResult WsService TTMWS
          
Local cEmp := "01"
Local cCodFil := "01"
Local cRetorno := ""
Local cAuth := ""
Local bError         := { |e| oError := e , Break(e) }
Local bErrorBlock    := ErrorBlock( bError )
Local lRet := .F.
Local cPath := ""
Local cNomeArq := ""
Local cFile			:= ""
	
Prepare Environment Empresa cEmp Filial cCodFil    

BEGIN SEQUENCE

	If Empty(Atendente) .Or. Empty(authCode) .Or. Empty(Maquina) .Or. Empty(Mapa)
		cRetorno := "Requisição inválida!"
		lRet := .F.
	Else
		dbSelectArea("AA1")
		dbSetOrder(1)
		If MsSeek( xFilial("AA1") +avKey(Atendente,"AA1_CODTEC")  )
			cAuth := AllTrim(AA1->AA1_XMAUTH)
						
			If Empty(cAuth)
				cRetorno := "Autenticação inválida!"
				lRet := .F.
			Else
				If upper(AllTrim(authCode)) <> upper(AllTrim(cAuth))
					cRetorno := "Autenticação inválida!"
					lRet := .F.
				Else
				
			    	cPath := "\system\"	//	"\_mobile\data\data_agents\"+Atendente +"\"
					cNomeArq := Maquina +"_" +dtos(date()) +StrTran(Time(),":","") +".csv"
					cFile := cPath+cNomeArq
					
					MemoWrite( cFile, Mapa ) 
					
					lRet := U_MBM003(Maquina,cFile,Atendente,@cRetorno) 
				EndIf
			EndIf
		Else
			cRetorno := "Atendente inválido!"
			lRet := .F.	
		EndIf	
	EndIf
	
	If lRet
		::UpdMapMachineResult := '{ "status":"ok", "result": "'+cRetorno +'" }'
	Else 
		::UpdMapMachineResult := '{ "status":"error", "result": "'+cRetorno +'" }'	
	EndIf
	
RECOVER
	::UpdMapMachineResult := '{"status":"error","result":' +oError:ErrorStack +'}'   
	ConOut( ProcName() + " " + Str(ProcLine()) + " " + oError:ErrorStack )
END SEQUENCE 
    
Reset Environment

Return .T.

/*
Status dos atendimentos do dia
*/
WsMethod testeX WsReceive Atendente WsSend testeXResult WsService TTMWS

Local cEmp := "01"
Local cCodFil := "01"
Local cRetorno := ""
Local bError         := { |e| oError := e , Break(e) }
Local bErrorBlock    := ErrorBlock( bError )
Local cSql := ""
Local aOS := {}
Local oObj
Local oItem
Local cJson := ""
Local aAux := {}
Local aAx := {}
Local nOk := 0
Local nTot := 0 
Local aJson := {}
	
Prepare Environment Empresa cEmp Filial cCodFil
	
BEGIN SEQUENCE

	cSql := "SELECT ZG_AGENTED, ZG_STATUS "
	cSql += "FROM SZG010 "
	cSql += "WHERE ZG_DATAINI = '"+DTOS(Date())+"' "
	cSql += "AND ZG_TPFORM IN ('2','3','8') "
	cSql += "ORDER BY ZG_AGENTED DESC "
	
	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf
	TcQuery cSql New Alias "TRB"
	dbSelectArea("TRB")
	While !EOF()
		AADD( aAux, { AllTrim(TRB->ZG_AGENTED), AllTrim(TRB->ZG_STATUS) } )
		dbSkip()
	End
	For nI := 1 To Len(aAux)
		If Ascan( aAx, { |x| x[1] == aAux[nI][1] } ) == 0
			AADD( aAx, { aAux[nI][1], 0, 0 } )
		EndIf
	Next nI
	For nI := 1 To Len(aAx)
		nTot := 0
		nOk := 0
		For nJ := 1 To Len(aAux)
			If aAux[nJ][1] == aAx[nI][1]
				If aAux[nJ][2] == "FIOK"
					nOk++
				EndIf
				nTot++
			EndIf
		Next nJ
		aAx[nI][2] := nTot
		aAx[nI][3] := Round((nOk/nTot) * 100,2)
	Next nI

	// -> nome total percentual concluido
	oObj := JsonObject():New()
	If Len(aAx) > 0   	      
		aSort( aAx,,, { |x, y| x[1] < y[1] /*.And. x[3] > y[3]*/ } )
		For nI := 1 To Len(aAx)
			oItem := JsonObject():New()
			oItem:PutVal("atendente", AllTrim(aAx[nI][1]) )
			oItem:PutVal("total", aAx[nI][2] )
			oItem:PutVal("percentual", aAx[nI][3] )
			AADD(aJson,oItem)
		Next nI
		oObj:PutVal("ALIST",aJson)
		cJson := oObj:ToJson()
	Else
		oObj:PutVal("ALIST",aJson)
		cJson := oObj:ToJson()
	EndIf
	::testeXResult := cJson	
	
RECOVER
	::testeXResult := '{"status":"error","result":' +oError:ErrorStack +'}'   
	ConOut( ProcName() + " " + Str(ProcLine()) + " " + oError:ErrorStack )
END SEQUENCE 
    
Reset Environment

Return .T.    


/*
Status das Rotas
*/
WsMethod getStatusRT WsReceive Atendente,authCode WsSend getStatusRTResult WsService TTMWS

Local cEmp := "01"
Local cCodFil := "01"
Local cRetorno := ""
Local bError         := { |e| oError := e , Break(e) }
Local bErrorBlock    := ErrorBlock( bError )
Local cSql := ""
Local oObj
Local oItem
Local cJson := ""
Local aAx := {}
Local nTot := 0 
Local nSld := 0
Local aJson := {}
Local aRT := {}
Local lRet := .T.
	
Prepare Environment Empresa cEmp Filial cCodFil
	
BEGIN SEQUENCE

	If Empty(Atendente) .Or. Empty(authCode)
		cRetorno := "Requisição inválida!"
		::getStatusRTResult := '{ "status":"ok", "result": "'+cRetorno +'" }' 
		lRet := .F.
	Else
		lRet := AuthMB(Atendente,AuthCode,@cRetorno)
		If lRet
			cJson := U_MBM004(@cRetorno)
			If !Empty(cJson)
				::getStatusRTResult := cJson
			Else
				::getStatusRTResult := '{ "status":"ok", "result": "'+cRetorno +'" }' 
			EndIf
		Else
			::getStatusRTResult := '{ "status":"ok", "result": "'+cRetorno +'" }' 
		EndIf
	EndIf
	

RECOVER
	::getStatusRTResult := '{"status":"error","result":' +oError:ErrorStack +'}'   
	ConOut( ProcName() + " " + Str(ProcLine()) + " " + oError:ErrorStack )
END SEQUENCE 
    
Reset Environment

Return .T.    


/*
Retorna as OS
*/
WsMethod getOS WsReceive Atendente,authCode WsSend getOSResult WsService TTMWS

Local cEmp := "01"
Local cCodFil := "01"
Local cRetorno := ""
Local bError         := { |e| oError := e , Break(e) }
Local bErrorBlock    := ErrorBlock( bError )
Local cSql := ""
Local oObj
Local oItem
Local cJson := ""
Local aAx := {}
Local nTot := 0 
Local nSld := 0
Local aJson := {}
Local aRT := {}
Local lRet := .T.
	
Prepare Environment Empresa cEmp Filial cCodFil
	
BEGIN SEQUENCE

	If Empty(Atendente) .Or. Empty(authCode)
		cRetorno := "Requisição inválida!"
		::getOSResult := '{ "status":"error", "result": "'+cRetorno +'" }' 
		lRet := .F.
	Else
		lRet := AuthMB(Atendente,AuthCode,@cRetorno)
		If lRet
			cJson := U_MBM005(Atendente,@cRetorno)
			If !Empty(cJson)
				::getOSResult := cJson
			Else
				::getOSResult := '{ "status":"error", "result": "'+cRetorno +'" }' 
			EndIf
		Else
			::getOSResult := '{ "status":"error", "result": "'+cRetorno +'" }' 
		EndIf
	EndIf
	
RECOVER
	::getOSResult := '{"status":"error","result":' +oError:ErrorStack +'}'   
	ConOut( ProcName() + " " + Str(ProcLine()) + " " + oError:ErrorStack )
END SEQUENCE 
    
Reset Environment

Return .T.  

/*
DeviceRegister  
*/
WsMethod DeviceRegister WsReceive Atendente,authCode,imei,manuf,model,apilvl,osver,appver,idgcm,chip1,tpdev,RgOper WsSend DeviceRegisterResult WsService TTMWS

Local cEmp := "01"
Local cCodFil := "01"
Local cRetorno := ""
Local bError         := { |e| oError := e , Break(e) }
Local bErrorBlock    := ErrorBlock( bError )
Local cJson := ""
Local lRet := .T.
	
Prepare Environment Empresa cEmp Filial cCodFil
	
BEGIN SEQUENCE

	If Empty(Atendente) .Or. Empty(authCode)
		cRetorno := "Requisição inválida!"
		::DeviceRegisterResult := '{ "status":"error", "result": "'+cRetorno +'" }' 
		lRet := .F.
	Else
		lRet := AuthMB(Atendente,AuthCode,@cRetorno)
		If lRet
			cJson := U_MBM000(Atendente,imei,manuf,model,apilvl,osver,appver,idgcm,chip1,tpdev,RgOper)
			If !Empty(cJson)
				::DeviceRegisterResult := cJson
			Else
				::DeviceRegisterResult := '{ "status":"error", "result": "'+cRetorno +'" }' 
			EndIf
		Else
			::DeviceRegisterResult := '{ "status":"error", "result": "'+cRetorno +'" }' 
		EndIf
	EndIf
	

RECOVER
	::DeviceRegisterResult := '{"status":"error","result":' +oError:ErrorStack +'}'   
	ConOut( ProcName() + " " + Str(ProcLine()) + " " + oError:ErrorStack )
END SEQUENCE 
    
Reset Environment

Return .T.  


/*
setUpdOS  
*/
WsMethod setUpdOS WsReceive Atendente,authCode,idnumber,values WsSend setUpdOSResult WsService TTMWS

Local cEmp := "01"
Local cCodFil := "01"
Local cRetorno := ""
Local bError         := { |e| oError := e , Break(e) }
Local bErrorBlock    := ErrorBlock( bError )
Local cJson := ""
Local lRet := .T.
	
Prepare Environment Empresa cEmp Filial cCodFil
	
BEGIN SEQUENCE

	If Empty(Atendente) .Or. Empty(authCode) .Or. Empty(idnumber) .Or. Empty(values)
		cRetorno := "Requisição inválida!"
		::setUpdOSResult := '{ "status":"error", "result": "'+cRetorno +'" }' 
		lRet := .F.
	Else
		lRet := AuthMB(Atendente,AuthCode,@cRetorno)
		If lRet
			conout( "OS RECEBIDA VIA MOBILE: " +idnumber )
			cJson := U_MBM006(Atendente,idnumber,values)
		
			::setUpdOSResult := cJson
		Else
			::setUpdOSResult := '{ "status":"error", "result": "'+cRetorno +'" }' 
		EndIf
	EndIf
	
RECOVER
	::setUpdOSResult := '{"status":"error","result":' +oError:ErrorStack +'}'   
	ConOut( ProcName() + " " + Str(ProcLine()) + " " + oError:ErrorStack )
END SEQUENCE 
    
Reset Environment

Return .T.


/*
getOSCancel
*/
WsMethod getOSCancel WsReceive Atendente,authCode WsSend getOSCancelResult WsService TTMWS

Local cEmp := "01"
Local cCodFil := "01"
Local cRetorno := ""
Local bError         := { |e| oError := e , Break(e) }
Local bErrorBlock    := ErrorBlock( bError )
Local cJson := ""
Local lRet := .T.
	
Prepare Environment Empresa cEmp Filial cCodFil
	
BEGIN SEQUENCE

	If Empty(Atendente) .Or. Empty(authCode)
		cRetorno := "Requisição inválida!"
		::getOSCancelResult := '{ "status":"error", "result": "'+cRetorno +'" }' 
		lRet := .F.
	Else
		lRet := AuthMB(Atendente,AuthCode,@cRetorno)
		If lRet
			cJson := U_MBM007(Atendente)	//U_MBM006(idnumber,values)
		
			::getOSCancelResult := cJson
		Else
			::getOSCancelResult := '{ "status":"error", "result": "'+cRetorno +'" }' 
		EndIf
	EndIf
	
RECOVER
	::getOSCancelResult := '{"status":"error","result":' +oError:ErrorStack +'}'   
	ConOut( ProcName() + " " + Str(ProcLine()) + " " + oError:ErrorStack )
END SEQUENCE 
    
Reset Environment

Return .T.


/*
getStck  
*/
WsMethod getStck WsReceive Atendente,authCode,Armazem,Produto WsSend getStckResult WsService TTMWS

Local cEmp := "01"
Local cCodFil := "01"
Local cRetorno := ""
Local bError         := { |e| oError := e , Break(e) }
Local bErrorBlock    := ErrorBlock( bError )
Local cJson := ""
Local lRet := .T.
	
Prepare Environment Empresa cEmp Filial cCodFil
	
BEGIN SEQUENCE

	If Empty(Atendente) .Or. Empty(authCode) .Or. Empty(Armazem) .Or. Empty(Produto)
		cRetorno := "Requisição inválida!"
		::getStckResult := '{ "status":"error", "result": "'+cRetorno +'" }' 
		lRet := .F.
	Else
		lRet := AuthMB(Atendente,AuthCode,@cRetorno)
		If lRet
			cJson := U_MBM008(Armazem,Produto)
		
			::getStckResult := cJson
		Else
			::getStckResult := '{ "status":"error", "result": "'+cRetorno +'" }' 
		EndIf
	EndIf
	
RECOVER
	::getStckResult := '{"status":"error","result":' +oError:ErrorStack +'}'   
	ConOut( ProcName() + " " + Str(ProcLine()) + " " + oError:ErrorStack )
END SEQUENCE 
    
Reset Environment

Return .T.

  
//getProducts  
WsMethod getProducts WsReceive Atendente,AuthCode WsSend getProductsResult WsService TTMWS

Local cEmp := "01"
Local cCodFil := "01"
Local cRetorno := ""
Local bError         := { |e| oError := e , Break(e) }
Local bErrorBlock    := ErrorBlock( bError )
Local cJson := ""
Local lRet := .T.
	
Prepare Environment Empresa cEmp Filial cCodFil
	
BEGIN SEQUENCE
	If Empty(Atendente) .Or. Empty(AuthCode)
		cRetorno := "Requisição inválida!"
		::getProductsResult := '{ "status":"error", "result": "'+cRetorno +'" }' 
	Else
		lRet := AuthMB( Atendente,AuthCode,@cRetorno )
		If lRet
			cJson := U_MBM001()		
			::getProductsResult := cJson
		Else
			::getProductsResult := '{ "status":"error", "result": "'+cRetorno +'" }' 
		EndIf
	EndIf
	
RECOVER
	::getProductsResult := '{"status":"error","result":' +oError:ErrorStack +'}'   
	ConOut( ProcName() + " " + Str(ProcLine()) + " " + oError:ErrorStack )
END SEQUENCE 
    
Reset Environment

Return .T.


// getCap
WsMethod getCap WsReceive Atendente,AuthCode WsSend getCapResult WsService TTMWS

Local cEmp := "01"
Local cCodFil := "01"
Local cRetorno := ""
Local bError         := { |e| oError := e , Break(e) }
Local bErrorBlock    := ErrorBlock( bError )
Local cJson := ""
Local lRet := .T.
	
Prepare Environment Empresa cEmp Filial cCodFil
	
BEGIN SEQUENCE
	If Empty(Atendente) .Or. Empty(AuthCode)
		cRetorno := "Requisição inválida!"
		::getCapResult := '{ "status":"error", "result": "'+cRetorno +'" }' 
	Else
		lRet := AuthMB( Atendente,AuthCode,@cRetorno )
		If lRet
			cJson := U_MBM002()		
			::getCapResult := cJson
		Else
			::getCapResult := '{ "status":"error", "result": "'+cRetorno +'" }' 
		EndIf
	EndIf
	
RECOVER
	::getCapResult := '{"status":"error","result":' +oError:ErrorStack +'}'   
	ConOut( ProcName() + " " + Str(ProcLine()) + " " + oError:ErrorStack )
END SEQUENCE 
    
Reset Environment


Return .T.

// setExpediente
WsMethod setExpediente WsReceive Atendente,AuthCode,dthorainicio,latInicio,lngInicio,dthorafim,latFim,lngFim WsSend setExpedienteResult WsService TTMWS

Local cEmp := "01"
Local cCodFil := "01"
Local cRetorno := ""
Local bError         := { |e| oError := e , Break(e) }
Local bErrorBlock    := ErrorBlock( bError )
Local cJson := ""
Local lRet := .T.
	
Prepare Environment Empresa cEmp Filial cCodFil
	
BEGIN SEQUENCE
	If Empty(Atendente) .Or. Empty(AuthCode)
		cRetorno := "Requisição inválida!"
		::setExpedienteResult := '{ "status":"error", "result": "'+cRetorno +'" }' 
	Else
		lRet := AuthMB( Atendente,AuthCode,@cRetorno )
		If lRet
			cJson := U_MBM009(Atendente,dthorainicio,latInicio,lngInicio,dthorafim,latFim,lngFim)		
			::setExpedienteResult := cJson
		Else
			::setExpedienteResult := '{ "status":"error", "result": "'+cRetorno +'" }' 
		EndIf
	EndIf
	
RECOVER
	::setExpedienteResult := '{"status":"error","result":' +oError:ErrorStack +'}'   
	ConOut( ProcName() + " " + Str(ProcLine()) + " " + oError:ErrorStack )
END SEQUENCE 
    
Reset Environment


Return .T.



// getMaquinasMapa
WsMethod getMaquinasMapa WsReceive Atendente,AuthCode WsSend getMaquinasMapaResult WsService TTMWS

Local cEmp := "01"
Local cCodFil := "01"
Local cRetorno := ""
Local bError         := { |e| oError := e , Break(e) }
Local bErrorBlock    := ErrorBlock( bError )
Local cJson := ""
Local lRet := .T.
	
Prepare Environment Empresa cEmp Filial cCodFil
	
BEGIN SEQUENCE
	If Empty(Atendente) .Or. Empty(AuthCode)
		cRetorno := "Requisição inválida!"
		::getMaquinasMapaResult := '{ "status":"error", "result": "'+cRetorno +'" }' 
	Else
		lRet := AuthMB( Atendente,AuthCode,@cRetorno )
		If lRet
			cJson := U_MBM010(Atendente)		
			::getMaquinasMapaResult := cJson
		Else
			::getMaquinasMapaResult := '{ "status":"error", "result": "'+cRetorno +'" }' 
		EndIf
	EndIf
	
RECOVER
	::getMaquinasMapaResult := '{"status":"error","result":' +oError:ErrorStack +'}'   
	ConOut( ProcName() + " " + Str(ProcLine()) + " " + oError:ErrorStack )
END SEQUENCE 
    
Reset Environment


Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AuthMB   ºAutor  ³Jackson E. de Deus   º Data ³  16/12/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Autenticacao mobile                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AuthMB(Atendente,AuthCode,cRetorno)
                
Local lAuth := .T.
Local aArea := GetArea()

dbSelectArea("AA1")
dbSetOrder(1)
If !MsSeek( xFilial("AA1") +avKey(Atendente,"AA1_CODTEC")  )
	cRetorno := "Atendente inexistente :("
	lAuth := .F.
	Return lAuth
EndIf

If upper(AllTrim(AuthCode)) <> upper(AllTrim(AA1->AA1_XMAUTH))
	cRetorno := "Autenticação inválida!"
	lAuth := .F.
	Return lAuth
EndIf

RestArea(aArea)           

Return lAuth