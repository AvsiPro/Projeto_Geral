#include 'protheus.ch'
#include 'parmtype.ch'
#include "totvs.ch"
#include "fileio.ch"

User function PRTWS01()
 
Local oRestClient 	:= FWRest():New("http://vmpay.vertitecnologia.com.br")
Local aHeader 		:= {"tenantId: 99,01"}
//Local nHandle 		:=	FT_FUse(cArqTxt)   
Local cValor		:=	''
Local nHandle 		:= fcreate('c:\temp\vmp_20172301.txt' , FO_READWRITE + FO_SHARED )         //'+dtos(ddatabase)+cvaltochar(strtran(time(),":"))+'
Local aLinhas		:=	{}
Local n				:=	0
Local aItens		:=	{} 
RpcSetType(3)
RpcSetEnv('00',' ')

/*
// inclui o campo Authorization no formato <usuario>:<senha> na base64
Aadd(aHeader, "Authorization: Basic " + Encode64("admin:123456"))
 
// chamada da classe exemplo de REST com retorno de lista
FWrite(nHandle,chr(13)+chr(10)+'Pick Lists '+chr(13)+chr(10)+chr(13)+chr(10),1000)

// chamada da classe exemplo de REST com retorno de lista
oRestClient:setPath("/api/v1/categories?access_token=AkH1cWGwYdvUy3KfKwHdTQaegWcD9SVCsGQ03trB")

If oRestClient:Get(aHeader)
   //MSGALERT("GET", oRestClient:GetResult())
   cValor := oRestClient:GetResult("GET")
   cValor := strtran(cValor,"[")
   cValor := strtran(cValor,"]")
   cValor := strtran(cValor,'"')
   
   aLinhas := strtokarr(cValor,"},{")
   For n := 1 to len(aLinhas)
   		If "id:" $ aLinhas[n] 
   		 	Aadd(aItens,{aLinhas[n],""})
   		Else
   			aItens[len(aItens),2] := aLinhas[n]
   		EndIf
   Next n
   
   For n := 1 to len(aItens)
   		FWrite(nHandle, aItens[n,1]+"-"+aItens[n,2] +chr(13)+chr(10), 1000) // Insere texto no arquivo
   Next n
   //fclose(nHandle) 
   
Else
   MSGALERT("GET", oRestClient:GetLastError())
EndIf
      
//Data de corte
cDtCriac := Date()-10
cDtCriac := DtoC(cDtCriac)
cDtCriac := StrTran(cDtCriac,"/","-")                                               
cDtCriac := If(len(SubStr(cDtCriac,7))==2,"20"+SubStr(cDtCriac,7),SubStr(cDtCriac,7)) +"-" +SubStr(cDtCriac,1,2)+"-" +SubStr(cDtCriac,4,2) 
// data/hora criacao/solicitacao
cDtCriac += "T" +"00:00-03:00"

//oRestClient:setPath("/api/v1/pick_lists?access_token=AkH1cWGwYdvUy3KfKwHdTQaegWcD9SVCsGQ03trB&updated_since="+cDtCriac) //2017-01-20T00:00:00-03:00")
oRestClient:setPath("/api/v1/pick_lists?access_token=AkH1cWGwYdvUy3KfKwHdTQaegWcD9SVCsGQ03trB")
//Aadd(aHeader,{"pending_only:true"})
If oRestClient:Get(aHeader)
   cValor := oRestClient:GetResult("GET")
   cValor := strtran(cValor,"[")
   cValor := strtran(cValor,"]")
   cValor := strtran(cValor,'"')
   
   aLinhas := strtokarr(cValor,"},{")
   For n := 1 to len(aLinhas)
   		/*If "id:" $ aLinhas[n] 
   		 	Aadd(aItens,{aLinhas[n],""})
   		Else
   			aItens[len(aItens),2] := aLinhas[n]
   		EndIf
   		If "url" $ aLinhas[n]
   			Aadd(aItens,substr(aLinhas[n],5))
   		EndIF
   Next n
   
   For n := 1 to len(aItens)
   		FWrite(nHandle, aItens[n] +chr(13)+chr(10), 1000) // Insere texto no arquivo
   Next n
   //fclose(nHandle) 
   
Else
   MSGALERT("GET", oRestClient:GetLastError())
EndIf
*/
oRestClient:setPath("/api/v1/clients?access_token=AkH1cWGwYdvUy3KfKwHdTQaegWcD9SVCsGQ03trB")

FWrite(nHandle,chr(13)+chr(10)+'Clientes '+chr(13)+chr(10)+chr(13)+chr(10),1000)
aItens := {}

If oRestClient:Get(aHeader)
   //MSGALERT("GET", oRestClient:GetResult())
   cValor := oRestClient:GetResult("GET")
   cValor := strtran(cValor,"[")
   cValor := strtran(cValor,"]")
   cValor := strtran(cValor,'"')
   
   aLinhas := strtokarr(cValor,",{")
   For n := 1 to len(aLinhas)
   		If "id:" $ aLinhas[n] .And. !"_id:" $ aLinhas[n] 
   		 	Aadd(aItens,{aLinhas[n]})
   		Else
   			Aadd(aItens[len(aItens)],aLinhas[n])
   		EndIf
   Next n
   
   For n := 1 to len(aItens)
   		For j := 1 to len(aItens[n])
   			If SUBSTR(aitens[n,j],1,3) $ "id:"
	   			FWrite(nHandle, aItens[n,j]+"-",1000)
	   		ElseIf SUBSTR(aitens[n,j],1,5) $ "cnpj:"
	   			FWrite(nHandle, aItens[n,j]+"-",1000)
	   			aaux := strtokarr(aItens[n,j],":")
	   			DbSelectArea("SA1")
	   			DbSetOrder(3)
	   			If Dbseek(xFilial("SA1")+aaux[2])
	   				FWrite(nHandle, SA1->A1_COD+"/"+SA1->A1_LOJA,1000)
	   			EndIf
	   		endif
   		Next j
   		FWrite(nHandle,chr(13)+chr(10),10)
   Next n
   //fclose(nHandle) 
   
Else
   MSGALERT("GET", oRestClient:GetLastError())
EndIf

//Locais de venda
/*
oRestClient:setPath("/api/v1/locations?access_token=AkH1cWGwYdvUy3KfKwHdTQaegWcD9SVCsGQ03trB")

FWrite(nHandle,chr(13)+chr(10)+'Locais '+chr(13)+chr(10)+chr(13)+chr(10),1000)
aItens := {}

If oRestClient:Get(aHeader)
   //MSGALERT("GET", oRestClient:GetResult())
   cValor := oRestClient:GetResult("GET")
   cValor := strtran(cValor,"[")
   cValor := strtran(cValor,"]")
   cValor := strtran(cValor,'"')
   
   aLinhas := strtokarr(cValor,",{")
   For n := 1 to len(aLinhas)
   		If "id:" $ aLinhas[n] .And. !"_id:" $ aLinhas[n] 
   		 	Aadd(aItens,{aLinhas[n]})
   		Else
   			Aadd(aItens[len(aItens)],aLinhas[n])
   		EndIf
   Next n
   
   For n := 1 to len(aItens)
   		For j := 1 to len(aItens[n])
   			FWrite(nHandle, aItens[n,j]+"-",1000)
   		Next j
   		FWrite(nHandle,chr(13)+chr(10),10)
   Next n
   //fclose(nHandle) 
   
Else
   MSGALERT("GET", oRestClient:GetLastError())
EndIf 

/* 
 //GET /api/v1/manufacturers
oRestClient:setPath("/api/v1/manufacturers?access_token=AkH1cWGwYdvUy3KfKwHdTQaegWcD9SVCsGQ03trB")

FWrite(nHandle,chr(13)+chr(10)+'Fornecedores '+chr(13)+chr(10)+chr(13)+chr(10),1000)
aItens := {}

If oRestClient:Get(aHeader)
   //MSGALERT("GET", oRestClient:GetResult())
   cValor := oRestClient:GetResult("GET")
   cValor := strtran(cValor,"[")
   cValor := strtran(cValor,"]")
   cValor := strtran(cValor,'"')
   
   aLinhas := strtokarr(cValor,",{")
   For n := 1 to len(aLinhas)
   		If "id:" $ aLinhas[n] .And. !"_id:" $ aLinhas[n] 
   		 	Aadd(aItens,{aLinhas[n]})
   		Else
   			Aadd(aItens[len(aItens)],aLinhas[n])
   		EndIf
   Next n
   
   For n := 1 to len(aItens)
   		For j := 1 to len(aItens[n])
   			FWrite(nHandle, aItens[n,j]+"-",1000)
   		Next j
   		FWrite(nHandle,chr(13)+chr(10),10)
   Next n
   //fclose(nHandle) 
   
Else
   MSGALERT("GET", oRestClient:GetLastError())
EndIf
 
//GET /api/v1/machines/[machine_id]/installations
oRestClient:setPath("/api/v1/id:01334/installations?access_token=AkH1cWGwYdvUy3KfKwHdTQaegWcD9SVCsGQ03trB")

FWrite(nHandle,chr(13)+chr(10)+'Maquinas '+chr(13)+chr(10)+chr(13)+chr(10),1000)
aItens := {}

If oRestClient:Get(aHeader)
   //MSGALERT("GET", oRestClient:GetResult())
   cValor := oRestClient:GetResult("GET")
   cValor := strtran(cValor,"[")
   cValor := strtran(cValor,"]")
   cValor := strtran(cValor,'"')
   
   aLinhas := strtokarr(cValor,",{")
   For n := 1 to len(aLinhas)
   		If "id:" $ aLinhas[n] .And. !"_id:" $ aLinhas[n] 
   		 	Aadd(aItens,{aLinhas[n]})
   		Else
   			Aadd(aItens[len(aItens)],aLinhas[n])
   		EndIf
   Next n
   
   For n := 1 to len(aItens)
   		For j := 1 to len(aItens[n])
   			FWrite(nHandle, aItens[n,j]+"-",1000)
   		Next j
   		FWrite(nHandle,chr(13)+chr(10),10)
   Next n
   //fclose(nHandle) 
   
Else
   MSGALERT("GET", oRestClient:GetLastError())
EndIf
 */
return