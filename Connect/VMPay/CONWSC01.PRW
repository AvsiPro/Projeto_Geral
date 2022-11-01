#INCLUDE "PROTHEUS.CH"
#INCLUDE "PARMTYPE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "FILEIO.CH"

USER FUNCTION CONWSC01() 
 
LOCAL oRestClient    :=    FWRest():New("http://vmpay.vertitecnologia.com.br")
LOCAL aHeader        :=    {"tenantId: 99,01"}
// LOCAL nHandle        :=    FT_FUse(cArqTxt)   
LOCAL cValor         :=    ""
LOCAL nHandle        :=    fcreate("c:\temp\vmp_20172301.txt" , FO_READWRITE + FO_SHARED )  //'+dtos(ddatabase)+cvaltochar(strtran(time(),":"))+'
LOCAL aLinhas        :=    {}
LOCAL n              :=    0
LOCAL aItens         :=    {} 
LOCAL cToken         :=    "yVXxnxgOExcIaBQOQ9CFgK0cLgX22dJct7y85WXW" //Token Connect Vending
LOCAL j

    IF Select("SM0") == 0
        RpcSetType(3)
        RPCSetEnv("01","0101")
    ENDIF

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

RETURN
