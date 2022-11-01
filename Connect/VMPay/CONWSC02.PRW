#INCLUDE "PROTHEUS.CH"
#INCLUDE "PARMTYPE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONWSC02   บAutor  ณMicrosiga           บ Data ณ  01/25/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Funcao que gera os pedidos de venda pelo pick list.      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

USER FUNCTION CONWSC02()
 
LOCAL oRestClient    :=    FWRest():New("http://vmpay.vertitecnologia.com.br")
LOCAL aHeader        :=    {} //{"tenantId: 99,01"}
LOCAL cValor         :=    ""
LOCAL nHandle        :=    fcreate('c:\temp\vmpay.txt' , FO_READWRITE + FO_SHARED )
LOCAL nHandle2       :=    fcreate('c:\temp\vmpay2.txt' , FO_READWRITE + FO_SHARED )     
LOCAL nHandle3       :=    fcreate('c:\temp\vmpay3.txt' , FO_READWRITE + FO_SHARED )     
LOCAL nHandle4       :=    fcreate('c:\temp\vmpay4.txt' , FO_READWRITE + FO_SHARED )     
// LOCAL aLinhas        :=    {}
LOCAL n              :=    0
// LOCAL j              :=    0
LOCAL aItens         :=    {}         
LOCAL aProdutos      :=    {}    
LOCAL aArray1        :=    {}  
// LOCAL aArray2        :=    {}
// LOCAL aArray3        :=    {}
LOCAL aArray4        :=    {}        
LOCAL aMolas         :=    {}
LOCAL aAux           :=    {}
LOCAL cId,cPlanId,cPending,nQtd,cGoodId,cProduto,cCodProt,cCodCl,cClProt,cLjProt,cNoCl,cNoFa,cEndCl,cIdP,cPlaItd := ''
LOCAL cDataP         :=    ctod(" / / ")
LOCAL cHoraP         :=    ""             
LOCAL cToken         :=    "yVXxnxgOExcIaBQOQ9CFgK0cLgX22dJct7y85WXW" // Token Connect Vending
LOCAL nX
LOCAL nMol
LOCAL nTora
// inclui o campo Authorization no formato <usuario>:<senha> na base64
//Aadd(aHeader, "Authorization: Basic " + Encode64("admin:yVXxnxgOExcIaBQOQ9CFgK0cLgX22dJct7y85WXW"))   

// chamada da classe exemplo de REST com retorno de lista
FWrite(nHandle,chr(13)+chr(10)+'Pick Lists '+chr(13)+chr(10)+chr(13)+chr(10),1000)
//Data de corte
cDtCriac := Date()
cDtCriac := Dtos(cDtCriac)
cDtCriac := substr(cDtCriac,1,4)+"-"+substr(cDtCriac,5,2)+"-"+substr(cDtCriac,7,2)
// data/hora criacao/solicitacao
cDtCriac += "T" +"00:00-03:00"

//Cabecalho
//Aadd(aProdutos,{'Patrimonio','ID_Pick','ID_Planogr.','Pendente','Quant.','Cod_VMPay','Cod_Prd_Amlabs','Cod_Prd_Protheus','CNPJ','Cliente_Protheus','Loja'})
                           
//Buscando os itens da Pick-List                           
oRestClient:setPath("/api/v1/pick_lists?access_token="+cToken+"&updated_since="+cDtCriac) 

IF oRestClient:Get(aHeader)
    cValor := oRestClient:GetResult("GET") 
    oObj := nil
    FWJsonDeserialize(cValor,@oObj)
    FOR nX := 1 TO len(oObj)
        Aadd(aItens,{substr(oObj[nX]:URL,36),oObj[nX]:INSTALLATION_ID,oObj[nX]:MACHINE_ID,oObj[nX]:ID}) // (PickList)
    NEXT nX
   
    FOR n := 1 TO len(aItens)      
        cClProt := ''
        FWrite(nHandle2, aItens[n,1] +chr(13)+chr(10), 1000)
        //Buscando o codigo do cliente                                                                             
        oRestClient:setPath(SUBSTR(aItens[n,1],1,at("PICK",UPPER(Alltrim(aItens[n,1])))-2)+"?access_token="+cToken)
        IF oRestClient:Get(aHeader)
            cCliente := oRestClient:GetResult("GET")
            cCliente := strtran(cCliente,"[")
            cCliente := strtran(cCliente,"]")
            cCliente := strtran(cCliente,'"')
            cCliente := strtran(cCliente,'{')
            cCliente := strtran(cCliente,'}')
            //Separando os dados para buscar o cliente pelo codigo do location_id
            aArray4 := strtokarr(cCliente,",")  
            FOR nMol := 1 TO len(aArray4)
                IF "good_id" $ Alltrim(aArray4[nMol]) .And. valtype(val(substr(aArray4[nMol+1],6))) == "N"
                    cID := IF(substr(aArray4[nMol-5],1,2)=="id",substr(aArray4[nMol-5],4),substr(aArray4[nMol-5],10))
                    Aadd(aMolas,{substr(aArray4[nMol],9),substr(aArray4[nMol+1],6),substr(aArray4[nMol+2],10),cvaltochar(val(substr(aArray4[nMol+3],11))),cID})
                ENDIF
            NEXT nMol
            //cLocId := ''
            //cLocId := cvaltochar(oObj:LOCATION_ID) 
            nPos := Ascan(aArray4,{|x| substr(upper(x),1,11) == "LOCATION_ID"})
            //IF !Empty(cLocId)
            IF nPos > 0
                cLocId := substr(aArray4[nPos],At(":",aArray4[nPos])+1)
                oRestClient:setPath("/api/v1/locations/"+cLocId+"?access_token="+cToken)
                IF oRestClient:Get(aHeader)
                    cCliente := oRestClient:GetResult("GET")
                    cCliente := strtran(cCliente,"[")
                    cCliente := strtran(cCliente,"]")
                    cCliente := strtran(cCliente,'"')
                    cCliente := strtran(cCliente,'{')
                    cCliente := strtran(cCliente,'}')
                    //Separando os dados para pegar o codigo do cliente do AMLabs
                    aArray4 := strtokarr(cCliente,",")
                    nPos := Ascan(aArray4,{|x| substr(upper(x),1,9) == "CLIENT_ID"})
                
                    IF nPos > 0 
                        cCodCl := substr(aArray4[nPos],At(":",aArray4[nPos])+1)   
                        oRestClient:setPath("/api/v1/clients/"+cCodCl+"?access_token=OrJ305kN0AtGIZ2YHCmiqg2atfOqVli8keGEN61y") 
                        IF oRestClient:Get(aHeader)
                            cCliente := oRestClient:GetResult("GET")
                            cCliente := strtran(cCliente,"[")
                            cCliente := strtran(cCliente,"]")
                            cCliente := strtran(cCliente,'"')
                            cCliente := strtran(cCliente,'{')
                            cCliente := strtran(cCliente,'}')  
                            aArray4 := strtokarr(cCliente,",")
                            nPos := Ascan(aArray4,{|x| substr(upper(x),1,4) == "CNPJ"})
                            IF nPos > 0     
                                cCodCl := substr(aArray4[nPos],At(":",aArray4[nPos])+1)   
                                IF Empty(cCodCl)
                                    cCodCl := ''
                                ENDIF
                                DbSelectArea("SA1")
                                DbSetOrder(3)
                                IF DbSeek(xFilial("SA1")+cCodCl)
                                    cClProt := SA1->A1_COD      
                                    cLjProt    := SA1->A1_LOJA  
                                    cNoCl    := SA1->A1_NOME
                                    cNoFa    := SA1->A1_NREDUZ
                                    cEndCl    := Alltrim(SA1->A1_END)+" - "+Alltrim(SA1->A1_BAIRRO)+" - "+Alltrim(SA1->A1_MUN)+" - "+Alltrim(SA1->A1_EST)
                                ENDIF
                                //cClProt := Posicione("SA1",3,xFilial("SA1")+cCodCl,"A1_COD")
                            ENDIF
                        ENDIF
                    ENDIF
                ENDIF
            ENDIF
        ENDIF   
        
        //Buscando o codigo do patrimonio
        aaux := strtokarr(aItens[n,1],"/")
        cUrl := "/"+aaux[1]+"/"+aaux[2]+"/"+aaux[3]+"/"+aaux[4]
        oRestClient:setPath(Alltrim(cUrl)+"?access_token="+cToken) 
        IF oRestClient:Get(aHeader)
            cPatrim := ''
            cPatrim := oRestClient:GetResult("GET")
            oObj := nil                   
            IF !FWJsonDeserialize(cPatrim,@oObj)
                FWJsonDeserialize(cPatrim,@oObj)
            ENDIF
            cPatrim := ''
            cPatrim := oObj:ASSET_NUMBER
        ENDIF
        
        //Buscando o Pick-List por maquina
        oRestClient:setPath(Alltrim(aItens[n,1])+"?access_token="+cToken) 
        
        IF oRestClient:Get(aHeader)
            cValor    :=    ''
            cValor    :=    oRestClient:GetResult("GET")
            oObj      :=    nil                    
            IF !FWJsonDeserialize(cValor,@oObj)
                FWJsonDeserialize(cValor,@oObj)
            ENDIF

            cIdP       :=    ''
            cIdP       :=    cvaltochar(oObj:PLANOGRAM_ID)
            
            cValor     :=    strtran(cValor,"[")
            cValor     :=    strtran(cValor,"]")
            cValor     :=    strtran(cValor,'"')
            cValor     :=    strtran(cValor,'{')
            cValor     :=    strtran(cValor,'}')
            aArray1    :=    strtokarr(cValor,",") 
            Aadd(aPick,{cPatrim,cValor,Alltrim(aItens[n])})    

            FWrite(nHandle, cValor + chr(13)+chr(10),10000)
            
            /*DbSelectArea("ZZA")
            DbSetOrder(1)
            IF Dbseek(xFilial("ZZA")+cIdP)
                loop
            ENDIF */
            //nPos := Ascan(aArray1,{|x| substr(upper(x),1,12) == "PLANOGRAM_ID"}) 
            aPrdI := oObj:ITEMS
            
            FOR nTora := 1 TO len(aPrdI)
                cId         :=    cvaltochar(aPrdI[nTora]:ID) 
                cPlanId     :=    oObj:PLANOGRAM_ID
                cPlaItd     :=    cvaltochar(aPrdI[nTora]:PLANOGRAM_ITEM_ID)
                cPending    :=    IF(oObj:PENDING,'true','false')
                nQtd        :=    cvaltochar(aPrdI[nTora]:QUANTITY) 
                cDataP      :=    Substr(oObj:CREATED_AT,1,10)           
                cDataP      :=    stod(strtran(cDataP,"-"))
                cHoraP      :=    Substr(oObj:CREATED_AT,12,5)
                cGoodId     :=    cvaltochar(aPrdI[nTora]:GOOD_ID)
                nInd        :=    Ascan(aMolas,{|x| cvaltochar(x[5]) == Alltrim(cPlaItd)}) 
                IF nInd > 0
                    cMola        :=    aMolas[nInd,02]
                    cCapacid     :=    aMolas[nInd,03]
                    cNivelPar    :=    aMolas[nInd,04]
                ENDIF
                //cProduto          
                oRestClient:setPath("/api/v1/products/"+Alltrim(cGoodId)+"?access_token="+cToken) 
                cValor2 := ''
                IF oRestClient:Get(aHeader)
                    cValor2 := oRestClient:GetResult("GET")  
                    oObj2 := nil
                    IF !FWJsonDeserialize(cValor2,@oObj2) 
                        FWJsonDeserialize(cValor2,@oObj2) 
                    ENDIF
                    
                    cProduto := Alltrim(oObj2:UPC_CODE)
                    cCodProt := cProduto
                    cUndMed  := Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_UM")
                        
                    IF cUndMed <> "UN"
                        nSgUn := Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_CONV")
                            
                        nQtd := cvaltochar(Round(val(nQtd) / nSgUn,2))
                    ENDIF
                    Aadd(aProdutos,{cPatrim,cId,cPlanId,cPending,nQtd,cGoodId,cProduto,cCodProt,cCodCl,cClProt,cLjProt,cNoCl,cNoFa,cEndCl,cMola,cIdP,cPlaItd,cDataP,cHoraP,cCapacid,cNivelPar})
                ENDIF      
            NEXT nTora
        ENDIF 
    NEXT n
ELSE
   MSGALERT("GET", oRestClient:GetLastError())
ENDIF     

fclose(nHandle) 
fclose(nHandle2) 
fclose(nHandle3) 
fclose(nHandle4) 

RETURN(aProdutos)
