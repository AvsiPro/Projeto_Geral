#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'
#INCLUDE "totvs.ch"
#INCLUDE "fileio.ch"

USER FUNCTION PRTWS01() 
 
LOCAL oRestClient    :=    FWRest():New("http://vmpay.vertitecnologia.com.br")
LOCAL aHeader 		   :=    {"tenantId: 99,01"}
//LOCAL nHandle   	  :=    FT_FUse(cArqTxt)   
LOCAL cValor		   :=   	''
LOCAL nHandle 		   :=    fcreate('c:\temp\vmp_20172301.txt' , FO_READWRITE + FO_SHARED )         //'+dtos(ddatabase)+cvaltochar(strtran(time(),":"))+'
LOCAL aLinhas		   :=   	{}
LOCAL n				   :=   	0
LOCAL aItens		   :=   	{} 
LOCAL cToken		   :=	   "tH3FkJ7cB2P0GwwOGbmMpJvoHsQJtMZD2nX1Ihmj" //"IwhyqNsJNpP1wAhSBwG4YJNmcleFIXOFkTQn1j0h"
LOCAL j

   IF Select("SM0") == 0
      RpcSetType(3)
      RPCSetEnv("01","0101")
   ENDIF

/*
// inclui o campo Authorization no formato <usuario>:<senha> na base64
Aadd(aHeader, "Authorization: Basic " + Encode64("admin:123456"))
 
// chamada da classe exemplo de REST com retorno de lista
FWrite(nHandle,chr(13)+chr(10)+'Pick Lists '+chr(13)+chr(10)+chr(13)+chr(10),1000)

// chamada da classe exemplo de REST com retorno de lista
oRestClient:setPath("/api/v1/categories?access_token=AkH1cWGwYdvUy3KfKwHdTQaegWcD9SVCsGQ03trB")

IF oRestClient:Get(aHeader)
   //MSGALERT("GET", oRestClient:GetResult())
   cValor := oRestClient:GetResult("GET")
   cValor := strtran(cValor,"[")
   cValor := strtran(cValor,"]")
   cValor := strtran(cValor,'"')
   
   aLinhas := strtokarr(cValor,"},{")
   FOR n := 1 TO len(aLinhas)
   		IF "id:" $ aLinhas[n] 
   		 	Aadd(aItens,{aLinhas[n],""})
   		ELSE
   			aItens[len(aItens),2] := aLinhas[n]
   		ENDIF
   NEXT n
   
   FOR n := 1 TO len(aItens)
   		FWrite(nHandle, aItens[n,1]+"-"+aItens[n,2] +chr(13)+chr(10), 1000) // Insere texto no arquivo
   NEXT n
   //fclose(nHandle) 
   
ELSE
   MSGALERT("GET", oRestClient:GetLastError())
ENDIF
      
//Data de corte
cDtCriac := Date()-10
cDtCriac := DtoC(cDtCriac)
cDtCriac := StrTran(cDtCriac,"/","-")                                               
cDtCriac := IF(len(SubStr(cDtCriac,7))==2,"20"+SubStr(cDtCriac,7),SubStr(cDtCriac,7)) +"-" +SubStr(cDtCriac,1,2)+"-" +SubStr(cDtCriac,4,2) 
// data/hora criacao/solicitacao
cDtCriac += "T" +"00:00-03:00"

//oRestClient:setPath("/api/v1/pick_lists?access_token=AkH1cWGwYdvUy3KfKwHdTQaegWcD9SVCsGQ03trB&updated_since="+cDtCriac) //2017-01-20T00:00:00-03:00")
oRestClient:setPath("/api/v1/pick_lists?access_token=AkH1cWGwYdvUy3KfKwHdTQaegWcD9SVCsGQ03trB")
//Aadd(aHeader,{"pending_only:true"})
IF oRestClient:Get(aHeader)
   cValor := oRestClient:GetResult("GET")
   cValor := strtran(cValor,"[")
   cValor := strtran(cValor,"]")
   cValor := strtran(cValor,'"')
   
   aLinhas := strtokarr(cValor,"},{")
   FOR n := 1 TO len(aLinhas)
   		/*IF "id:" $ aLinhas[n] 
   		 	Aadd(aItens,{aLinhas[n],""})
   		ELSE
   			aItens[len(aItens),2] := aLinhas[n]
   		ENDIF
   		IF "url" $ aLinhas[n]
   			Aadd(aItens,substr(aLinhas[n],5))
   		ENDIF
   NEXT n
   
   FOR n := 1 TO len(aItens)
   		FWrite(nHandle, aItens[n] +chr(13)+chr(10), 1000) // Insere texto no arquivo
   NEXT n
   //fclose(nHandle) 
   
ELSE
   MSGALERT("GET", oRestClient:GetLastError())
ENDIF
*/
oRestClient:setPath("/api/v1/clients?access_token="+cToken)

FWrite(nHandle,chr(13)+chr(10)+'Clientes '+chr(13)+chr(10)+chr(13)+chr(10),1000)
aItens := {}

IF oRestClient:Get(aHeader)
   //MSGALERT("GET", oRestClient:GetResult())
   cValor := oRestClient:GetResult("GET")
   cValor := strtran(cValor,"[")
   cValor := strtran(cValor,"]")
   cValor := strtran(cValor,'"')
   
   aLinhas := strtokarr(cValor,",{")
   FOR n := 1 TO len(aLinhas)
   		IF "id:" $ aLinhas[n] .And. !"_id:" $ aLinhas[n] 
   		 	Aadd(aItens,{aLinhas[n]})
   		ELSE
   			Aadd(aItens[len(aItens)],aLinhas[n])
   		ENDIF
   NEXT n
   
   FOR n := 1 TO len(aItens)
   		FOR j := 1 TO len(aItens[n])
   			IF SUBSTR(aitens[n,j],1,3) $ "id:"
	   			FWrite(nHandle, aItens[n,j]+"-",1000)
	   		ElseIf SUBSTR(aitens[n,j],1,5) $ "cnpj:"
	   			FWrite(nHandle, aItens[n,j]+"-",1000)
	   			aaux := strtokarr(aItens[n,j],":")
	   			DbSelectArea("SA1")
	   			DbSetOrder(3)
	   			IF Dbseek(xFilial("SA1")+aaux[2])
	   				FWrite(nHandle, SA1->A1_COD+"/"+SA1->A1_LOJA,1000)
	   			ENDIF
	   		ENDIF
   		NEXT j
   		FWrite(nHandle,chr(13)+chr(10),10)
   NEXT n
   //fclose(nHandle) 
   
ELSE
   MSGALERT("GET", oRestClient:GetLastError())
ENDIF

//Locais de venda
/*
oRestClient:setPath("/api/v1/locations?access_token=AkH1cWGwYdvUy3KfKwHdTQaegWcD9SVCsGQ03trB")

FWrite(nHandle,chr(13)+chr(10)+'Locais '+chr(13)+chr(10)+chr(13)+chr(10),1000)
aItens := {}

IF oRestClient:Get(aHeader)
   //MSGALERT("GET", oRestClient:GetResult())
   cValor := oRestClient:GetResult("GET")
   cValor := strtran(cValor,"[")
   cValor := strtran(cValor,"]")
   cValor := strtran(cValor,'"')
   
   aLinhas := strtokarr(cValor,",{")
   FOR n := 1 TO len(aLinhas)
   		IF "id:" $ aLinhas[n] .And. !"_id:" $ aLinhas[n] 
   		 	Aadd(aItens,{aLinhas[n]})
   		ELSE
   			Aadd(aItens[len(aItens)],aLinhas[n])
   		ENDIF
   NEXT n
   
   FOR n := 1 TO len(aItens)
   		FOR j := 1 TO len(aItens[n])
   			FWrite(nHandle, aItens[n,j]+"-",1000)
   		NEXT j
   		FWrite(nHandle,chr(13)+chr(10),10)
   NEXT n
   //fclose(nHandle) 
   
ELSE
   MSGALERT("GET", oRestClient:GetLastError())
ENDIF 

/* 
 //GET /api/v1/manufacturers
oRestClient:setPath("/api/v1/manufacturers?access_token=AkH1cWGwYdvUy3KfKwHdTQaegWcD9SVCsGQ03trB")

FWrite(nHandle,chr(13)+chr(10)+'Fornecedores '+chr(13)+chr(10)+chr(13)+chr(10),1000)
aItens := {}

IF oRestClient:Get(aHeader)
   //MSGALERT("GET", oRestClient:GetResult())
   cValor := oRestClient:GetResult("GET")
   cValor := strtran(cValor,"[")
   cValor := strtran(cValor,"]")
   cValor := strtran(cValor,'"')
   
   aLinhas := strtokarr(cValor,",{")
   FOR n := 1 TO len(aLinhas)
   		IF "id:" $ aLinhas[n] .And. !"_id:" $ aLinhas[n] 
   		 	Aadd(aItens,{aLinhas[n]})
   		ELSE
   			Aadd(aItens[len(aItens)],aLinhas[n])
   		ENDIF
   NEXT n
   
   FOR n := 1 TO len(aItens)
   		FOR j := 1 TO len(aItens[n])
   			FWrite(nHandle, aItens[n,j]+"-",1000)
   		NEXT j
   		FWrite(nHandle,chr(13)+chr(10),10)
   NEXT n
   //fclose(nHandle) 
   
ELSE
   MSGALERT("GET", oRestClient:GetLastError())
ENDIF
 
//GET /api/v1/machines/[machine_id]/installations
oRestClient:setPath("/api/v1/id:01334/installations?access_token=AkH1cWGwYdvUy3KfKwHdTQaegWcD9SVCsGQ03trB")

FWrite(nHandle,chr(13)+chr(10)+'Maquinas '+chr(13)+chr(10)+chr(13)+chr(10),1000)
aItens := {}

IF oRestClient:Get(aHeader)
   //MSGALERT("GET", oRestClient:GetResult())
   cValor := oRestClient:GetResult("GET")
   cValor := strtran(cValor,"[")
   cValor := strtran(cValor,"]")
   cValor := strtran(cValor,'"')
   
   aLinhas := strtokarr(cValor,",{")
   FOR n := 1 TO len(aLinhas)
   		IF "id:" $ aLinhas[n] .And. !"_id:" $ aLinhas[n] 
   		 	Aadd(aItens,{aLinhas[n]})
   		ELSE
   			Aadd(aItens[len(aItens)],aLinhas[n])
   		ENDIF
   NEXT n
   
   FOR n := 1 TO len(aItens)
   		FOR j := 1 TO len(aItens[n])
   			FWrite(nHandle, aItens[n,j]+"-",1000)
   		NEXT j
   		FWrite(nHandle,chr(13)+chr(10),10)
   NEXT n
   //fclose(nHandle) 
   
ELSE
   MSGALERT("GET", oRestClient:GetLastError())
ENDIF
 */
RETURN
