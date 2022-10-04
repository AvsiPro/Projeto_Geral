#include 'protheus.ch'
#include 'parmtype.ch'
#include "totvs.ch"
#include "fileio.ch"
#INCLUDE  'TBICONN.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPRTWS02   บAutor  ณMicrosiga           บ Data ณ  01/25/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Funcao que gera os pedidos de venda pelo pick list.      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User function PRTWS02()
 
Local oRestClient 	:= FWRest():New("http://vmpay.vertitecnologia.com.br")
Local aHeader 		:= {} //{"tenantId: 99,01"}
//Local nHandle 		:=	FT_FUse(cArqTxt)   
Local cValor		:=	''
Local nHandle 		:= fcreate('c:\temp\vmpay.txt' , FO_READWRITE + FO_SHARED )
Local nHandle2 		:= fcreate('c:\temp\vmpay2.txt' , FO_READWRITE + FO_SHARED )     
Local nHandle3		:= fcreate('c:\temp\vmpay3.txt' , FO_READWRITE + FO_SHARED )     
Local nHandle4		:= fcreate('c:\temp\vmpay4.txt' , FO_READWRITE + FO_SHARED )     
Local aLinhas		:=	{}
Local n				:=	0
Local j				:=	0
Local aItens		:=	{}         
Local aProdutos		:=	{}    
Local aArray1		:=	{}  
Local aArray2		:=	{}
Local aArray3		:=	{}
Local aArray4		:=	{}        
Local aMolas		:=	{}
Local aAux			:=	{}
Local cId,cPlanId,cPending,nQtd,cGoodId,cProduto,cCodProt,cCodCl,cClProt,cLjProt,cNoCl,cNoFa,cEndCl,cIdP,cPlaItd := ''
Local cDataP		:=  ctod(" / / ")
Local cHoraP		:=	''
// inclui o campo Authorization no formato <usuario>:<senha> na base64
//Aadd(aHeader, "Authorization: Basic " + Encode64("admin:AkH1cWGwYdvUy3KfKwHdTQaegWcD9SVCsGQ03trB"))
//PREPARE ENVIRONMENT EMPRESA "00" FILIAL "01" MODULO "FAT" TABLES "SA1"        

 
// chamada da classe exemplo de REST com retorno de lista
FWrite(nHandle,chr(13)+chr(10)+'Pick Lists '+chr(13)+chr(10)+chr(13)+chr(10),1000)
//Data de corte
cDtCriac := Date()
cDtCriac := Dtos(cDtCriac)
//cDtCriac := StrTran(cDtCriac,"/","-")                                               
//cDtCriac := If(len(SubStr(cDtCriac,7))==2,"20"+SubStr(cDtCriac,7),SubStr(cDtCriac,7)) +"-" +SubStr(cDtCriac,1,2)+"-" +SubStr(cDtCriac,4,2) 
cDtCriac := substr(cDtCriac,1,4)+"-"+substr(cDtCriac,5,2)+"-"+substr(cDtCriac,7,2)
// data/hora criacao/solicitacao
cDtCriac += "T" +"00:00-03:00"

//Cabecalho
//Aadd(aProdutos,{'Patrimonio','ID_Pick','ID_Planogr.','Pendente','Quant.','Cod_VMPay','Cod_Prd_Amlabs','Cod_Prd_Protheus','CNPJ','Cliente_Protheus','Loja'})
	           			
//Buscando os itens da Pick-List	           			
oRestClient:setPath("/api/v1/pick_lists?access_token=AkH1cWGwYdvUy3KfKwHdTQaegWcD9SVCsGQ03trB&updated_since="+cDtCriac) 

If oRestClient:Get(aHeader)
	cValor := oRestClient:GetResult("GET")
	cValor := strtran(cValor,"[")
	cValor := strtran(cValor,"]")
	cValor := strtran(cValor,'"')
	
	aLinhas := strtokarr(cValor,"},{")
	For n := 1 to len(aLinhas)
		//Pegando somente as urls de cada maquina para fazer a chamada para cada uma delas.
		If "url" $ aLinhas[n]
			If !"false" $ aLinhas[n-1] 
				Aadd(aItens,substr(aLinhas[n],40))
			EndIf
		EndIF
	Next n

   
	For n := 1 to len(aItens)      
		cClProt := ''
		FWrite(nHandle2, aItens[n] +chr(13)+chr(10), 1000)
		//Buscando o codigo do cliente
		oRestClient:setPath(SUBSTR(aItens[n],1,at("PICK",UPPER(Alltrim(aItens[n])))-2)+"?access_token=AkH1cWGwYdvUy3KfKwHdTQaegWcD9SVCsGQ03trB")
		If oRestClient:Get(aHeader)
			cCliente := oRestClient:GetResult("GET")
			cCliente := strtran(cCliente,"[")
			cCliente := strtran(cCliente,"]")
			cCliente := strtran(cCliente,'"')
			cCliente := strtran(cCliente,'{')
			cCliente := strtran(cCliente,'}')
			//Separando os dados para buscar o cliente pelo codigo do location_id
			aArray4 := strtokarr(cCliente,",")  
			For nMol := 1 to len(aArray4)
				If "good_id" $ Alltrim(aArray4[nMol]) .And. valtype(val(substr(aArray4[nMol+1],6))) == "N"
					Aadd(aMolas,{substr(aArray4[nMol],9),substr(aArray4[nMol+1],6),substr(aArray4[nMol+2],10),cvaltochar(val(substr(aArray4[nMol+3],11)))})
				EndIF
			Next nMol
			nPos := Ascan(aArray4,{|x| substr(upper(x),1,11) == "LOCATION_ID"})
			If nPos > 0
				cLocId := substr(aArray4[nPos],At(":",aArray4[nPos])+1)
				oRestClient:setPath("/api/v1/locations/"+cLocId+"?access_token=AkH1cWGwYdvUy3KfKwHdTQaegWcD9SVCsGQ03trB")
				If oRestClient:Get(aHeader)
					cCliente := oRestClient:GetResult("GET")
					cCliente := strtran(cCliente,"[")
					cCliente := strtran(cCliente,"]")
					cCliente := strtran(cCliente,'"')
					cCliente := strtran(cCliente,'{')
					cCliente := strtran(cCliente,'}')
					//Separando os dados para pegar o codigo do cliente do AMLabs
					aArray4 := strtokarr(cCliente,",")
					nPos := Ascan(aArray4,{|x| substr(upper(x),1,9) == "CLIENT_ID"})
					If nPos > 0 
						cCodCl := substr(aArray4[nPos],At(":",aArray4[nPos])+1)   
						oRestClient:setPath("/api/v1/clients/"+cCodCl+"?access_token=AkH1cWGwYdvUy3KfKwHdTQaegWcD9SVCsGQ03trB") 
						If oRestClient:Get(aHeader)
							cCliente := oRestClient:GetResult("GET")
							cCliente := strtran(cCliente,"[")
							cCliente := strtran(cCliente,"]")
							cCliente := strtran(cCliente,'"')
							cCliente := strtran(cCliente,'{')
							cCliente := strtran(cCliente,'}')  
							aArray4 := strtokarr(cCliente,",")
							nPos := Ascan(aArray4,{|x| substr(upper(x),1,4) == "CNPJ"})
							If nPos > 0     
								cCodCl := substr(aArray4[nPos],At(":",aArray4[nPos])+1)   
								If Empty(cCodCl)
									cCodCl := ''
								EndIf
								DbSelectArea("SA1")
								DbSetOrder(3)
								If DbSeek(xFilial("SA1")+cCodCl)
									cClProt := SA1->A1_COD      
									cLjProt	:= SA1->A1_LOJA  
									cNoCl	:= SA1->A1_NOME
									cNoFa	:= SA1->A1_NREDUZ
									cEndCl	:= Alltrim(SA1->A1_END)+" - "+Alltrim(SA1->A1_BAIRRO)+" - "+Alltrim(SA1->A1_MUN)+" - "+Alltrim(SA1->A1_EST)
								EndIf
								//cClProt := Posicione("SA1",3,xFilial("SA1")+cCodCl,"A1_COD")
							EndIf
						EndIf
					EndIf
				EndIF
			EndIf
		EndIf   		
        
		//Buscando o codigo do patrimonio
		aaux := strtokarr(aItens[n],"/")
		cUrl := "/"+aaux[1]+"/"+aaux[2]+"/"+aaux[3]+"/"+aaux[4]
		oRestClient:setPath(Alltrim(cUrl)+"?access_token=AkH1cWGwYdvUy3KfKwHdTQaegWcD9SVCsGQ03trB") 
		If oRestClient:Get(aHeader)
			cPatrim := oRestClient:GetResult("GET")
			cPatrim := strtran(cPatrim,"[")
			cPatrim := strtran(cPatrim,"]")
			cPatrim := strtran(cPatrim,'"')
			cPatrim := strtran(cPatrim,'{')
			cPatrim := strtran(cPatrim,'}') 
			aArray1 := strtokarr(cPatrim,",")
			nPos := Ascan(aArray1,{|x| substr(upper(x),1,12) == "ASSET_NUMBER"})
			IF nPos > 0
				cPatrim := substr(aArray1[nPos],at(":",aArray1[nPos])+1) 
			EndIF
		EndIf
		
   		//Buscando o Pick-List por maquina
		oRestClient:setPath(Alltrim(aItens[n])+"?access_token=AkH1cWGwYdvUy3KfKwHdTQaegWcD9SVCsGQ03trB") 
		
		If oRestClient:Get(aHeader)
			cValor := oRestClient:GetResult("GET")
			cValor := strtran(cValor,"[")
			cValor := strtran(cValor,"]")
			cValor := strtran(cValor,'"')
			cValor := strtran(cValor,'{')
			cValor := strtran(cValor,'}')
			FWrite(nHandle, cValor + chr(13)+chr(10),10000)
			aArray1 := strtokarr(cValor,",") 
			Aadd(aPick,{cPatrim,cValor,Alltrim(aItens[n])})	

			cIdP 	:=	substr(aArray1[1],4)
			/* VALIDAR AQUI */ 
			DbSelectArea("SZ0")
			DbSetOrder(1)
			If Dbseek(xFilial("SZ0")+cIdP)
				loop
			EndIf
			nPos := Ascan(aArray1,{|x| substr(upper(x),1,12) == "PLANOGRAM_ID"})
			nPos2:= Ascan(aArray1,{|x| substr(upper(x),1,8) == "ITEMS:ID"})
			IF nPos2 > 0
				cId := substr(aArray1[nPos2],at("id:",aArray1[nPos2])+3)
				//aArray1[1]
				For nJ := 2 to len(aArray1)
					If cId != aArray1[nJ] .And. Substr(upper(aArray1[nJ]),1,3) == "ID:"
						cCodProt := ''
						cCapacid := ''
						cNivelPar := ''
						//Buscando a mola e o codigo do produto no Protheus pelo codigo antigo
						If Ascan(aMolas,{|x| Alltrim(x[1]) == Alltrim(cGoodId)}) > 0
							cMola := aMolas[Ascan(aMolas,{|x| Alltrim(x[1]) == Alltrim(cGoodId)}),02]
							cCapacid := aMolas[Ascan(aMolas,{|x| Alltrim(x[1]) == Alltrim(cGoodId)}),03]
							cNivelPar := aMolas[Ascan(aMolas,{|x| Alltrim(x[1]) == Alltrim(cGoodId)}),04]
						Else
							cMola := ''
						EndIf
						cCodProt := Posicione("SB1",12,xFilial("SB1")+cProduto,"B1_COD")
						If Empty(cCodProt)
							cCodProt := cProduto   
						EndIf                                  
						
						Aadd(aProdutos,{cPatrim,cId,cPlanId,cPending,nQtd,cGoodId,cProduto,cCodProt,cCodCl,cClProt,cLjProt,cNoCl,cNoFa,cEndCl,cMola,cIdP,cPlaItd,cDataP,cHoraP,cCapacid,cNivelPar})
						cId := substr(aArray1[nJ],4)
						//cPlanId := ''
						//cPending := ''
						nQtd	:= ''
						cGoodId := ''
						cProduto := ''
						cCodProt := ''   
						//cClProt := ''
			           		
					EndIf
	           			
	           		If Substr(upper(aArray1[nJ]),1,13) == "PLANOGRAM_ID:"
	           			cPlanId := Substr(aArray1[nJ],14)
	           		ElseIf Substr(upper(aArray1[nJ]),1,18) == "PLANOGRAM_ITEM_ID:"
	           			cPlaItd := Substr(aArray1[nJ],19)
	           		ElseIf Substr(upper(aArray1[nJ]),1,8) == "PENDING:"
	           			cPending := Substr(aArray1[nJ],9)
	           		ElseIf Substr(upper(aArray1[nJ]),1,9) == "QUANTITY:" 
	           			nQtd	:=	Substr(aArray1[nJ],10)           
	           		ElseIf Substr(upper(aArray1[nJ]),1,7) == "CREATED"
	           			cDataP	:=	Substr(aArray1[nJ],12,10)           
	           			cDataP	:=	stod(strtran(cDataP,"-"))
	           			cHoraP	:=	Substr(aArray1[nJ],23,5)
	           		ElseIf Substr(upper(aArray1[nJ]),1,8) == "GOOD_ID:"     
	           		   cGoodId := Substr(aArray1[nJ],9)   
	           		   //Buscando o c๓digo do produto pelo good_id
	           		   oRestClient:setPath("/api/v1/products/"+Alltrim(cGoodId)+"?access_token=AkH1cWGwYdvUy3KfKwHdTQaegWcD9SVCsGQ03trB") 
				   	   
				   	   oRestClient:Get(aHeader)
					   cValor2 := oRestClient:GetResult("GET")
					   cValor2 := strtran(cValor2,"[")
					   cValor2 := strtran(cValor2,"]")
					   cValor2 := strtran(cValor2,'"')
					   cValor2 := strtran(cValor2,'{')
					   cValor2 := strtran(cValor2,'}')  
					   aArray2:= strtokarr(cValor2,",")
					   nPos := Ascan(aArray2,{|x| substr(upper(x),1,9) == "UPC_CODE:"})
					   If nPos > 0
							aArray3 := strtokarr(aArray2[nPos],":")
					   		If len(aArray3) == 2
							   FWrite(nHandle4, aArray3[2] + chr(13)+chr(10),10000)  
							   cProduto := aArray3[2]
							EndIf
					   EndIF  
	           		EndIf
				Next nJ
    
				//Buscando o codigo do produto no Protheus pelo codigo antigo
				DbSelectArea("SB1")
				DbSetOrder(12)
				cCodProt := ''
				If Dbseek(xFilial("SB1")+cProduto)
					cCodProt := SB1->B1_COD
				EndIF
				
				If Ascan(aMolas,{|x| Alltrim(x[1]) == Alltrim(cGoodId)}) > 0
					cMola := aMolas[Ascan(aMolas,{|x| Alltrim(x[1]) == Alltrim(cGoodId)}),02]
					cCapacid := aMolas[Ascan(aMolas,{|x| Alltrim(x[1]) == Alltrim(cGoodId)}),03]
					cNivelPar := aMolas[Ascan(aMolas,{|x| Alltrim(x[1]) == Alltrim(cGoodId)}),04]
				Else
					cMola := ''
				EndIf
				Aadd(aProdutos,{cPatrim,cId,cPlanId,cPending,nQtd,cGoodId,cProduto,cCodProt,cCodCl,cClProt,cLjProt,cNoCl,cNoFa,cEndCl,cMola,cIdP,cPlaItd,cvaltochar(cDataP),cHoraP,cCapacid,cNivelPar})
   
			EndIF
		EndIf 
	Next n
Else
   MSGALERT("GET", oRestClient:GetLastError())
EndIf     
/*
For nX := 1 to len(aProdutos)
	FWrite(nHandle3, aProdutos[nX,01]+","+aProdutos[nX,02]+","+aProdutos[nX,03]+","+aProdutos[nX,04]+","+aProdutos[nX,05]+","+aProdutos[nX,06]+","+aProdutos[nX,07]+","+aProdutos[nX,08]+","+aProdutos[nX,09]+","+aProdutos[nX,10]+","+aProdutos[nX,11]+","+aProdutos[nX,12] +","+aProdutos[nX,13] +","+aProdutos[nX,14]+","+aProdutos[nX,15]+","+aProdutos[nX,16]+","+aProdutos[nX,17]+","+aProdutos[nX,18]+","+aProdutos[nX,19]+ chr(13)+chr(10),1000)
Next nX
*/
fclose(nHandle) 
fclose(nHandle2) 
fclose(nHandle3) 
fclose(nHandle4) 
/*
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
   			FWrite(nHandle, aItens[n,j]+"-",1000)
   		Next j
   		FWrite(nHandle,chr(13)+chr(10),10)
   Next n
   //fclose(nHandle) 
   
Else
   MSGALERT("GET", oRestClient:GetLastError())
EndIf
 
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
return(aProdutos)