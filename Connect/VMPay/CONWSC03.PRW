#INCLUDE "PROTHEUS.CH"
#INCLUDE "PARMTYPE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "TBICONN.CH"

/* 
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CONWSC03   �Autor  �Microsiga           � Data �  04/13/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �  WS Generico para consultas                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Busca o planograma de todas as maquinas                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION CONWSC03(cAtivo,nChamada,dDtini,dDtfim,cHori,cHorf)
                     
LOCAL aAuxP            :=    {}              
LOCAL nJ
//LOCAL nK
PRIVATE cToken         :=    "yVXxnxgOExcIaBQOQ9CFgK0cLgX22dJct7y85WXW" //Token Connect Vending
PRIVATE oRestClient    :=    FWRest():New("http://vmpay.vertitecnologia.com.br")
PRIVATE aHeader        :=    {}
PRIVATE aLinhas        :=    {}
PRIVATE aRetorno       :=    {}   
PRIVATE aCanister      :=    {}
PRIVATE nCanister      :=    0

//Buscar Maquinas                         
Maquinas()
nPosMaq := Ascan(aHeader,{|x| Alltrim(x[2]) == alltrim(cAtivo)})

IF nPosMaq > 0 
    IF nChamada == 1
        //Buscar Instala��es    
        Instalacoes(aHeader[nPosMaq,01],nPosMaq)       
        
        //Buscar id de Planogramas por maquina
        If len(aHeader[nPosMaq]) > 2
            aAuxP := Planograma(aHeader[nPosMaq,01],aHeader[nPosMaq,03],nPosMaq)
        EndIf
        
        //Buscar Planograma da maquina
        //PlanoMaq(aHeader[nPosMaq,01],aHeader[nPosMaq,03],aHeader[nPosMaq,04],nPosMaq)
        
        aList3 := {}
        aList6 := {}
        
        FOR nJ := 1 TO len(aAuxP)               
            
            If val(aAuxP[nJ,03]) > 0
                aAux2 := {}
                Aadd(aAux2,aAuxP[nJ,01])
                Aadd(aAux2,aAuxP[nJ,02])
                Aadd(aAux2,aAuxP[nJ,03])
                Aadd(aAux2,aAuxP[nJ,04])
                DbSelectArea("SB1")
                DbSetOrder(1)
                If !Dbseek(xFilial("SB1")+aAuxP[nJ,04])
                    Aadd(aAux2,"Produto nao encontrado")
                Else 
                    Aadd(aAux2,aAuxP[nJ,05])
                EndIF 
                Aadd(aAux2,aAuxP[nJ,06])
                Aadd(aAux2,aAuxP[nJ,07])
                Aadd(aAux2,aAuxP[nJ,08])
                Aadd(aAux2,'')
            
                IF len(aAux2) > 7
                    Aadd(aList3,aAux2)
                ENDIF
            EndIf
        NEXT nJ 
        
        IF len(aList3) < 1
            MsgAlert("N�o encontrado layout da maquina")
            Aadd(aList3,{.T.,'','','','','','','','','','','','','','','','','',''})
        ENDIF
        
        IF len(aList6) < 1
            Aadd(aList6,{.T.,'','','','','','','','','','','','','','','','','',''})
        ENDIF
        
        oList3:SetArray(aList3)
        oList3:bLine := {||{ IF(aList3[oList3:nAt,01],oOk,oNo),; 
                              Alltrim(aList3[oList3:nAt,02]),;
                              Strzero(val(aList3[oList3:nAt,03]),3),;
                              aList3[oList3:nAt,04],;
                              aList3[oList3:nAt,05],;
                              aList3[oList3:nAt,06],;
                              aList3[oList3:nAt,07],;
                              aList3[oList3:nAt,08],;
                              Transform(aList3[oList3:nAt,09],"@E 999,999.99")}}   
        
        // oList6:SetArray(aList6)
        // oList6:bLine := {||{ IF(aList6[oList6:nAt,01],oOk,oNo),; 
        //                          Alltrim(aList6[oList6:nAt,02]),;
        //                          aList6[oList6:nAt,03],;
        //                          aList6[oList6:nAt,04],;
        //                          aList6[oList6:nAt,05],;
        //                          aList6[oList6:nAt,06],;
        //                          aList6[oList6:nAt,07]}} 
                              
        oList3:refresh()
        // oList6:refresh()
        oDlg1:refresh()
    ELSE
        
        cDtCriac := Dtos(dDtini)
        cDtCriac := substr(cDtCriac,1,4)+"-"+substr(cDtCriac,5,2)+"-"+substr(cDtCriac,7,2)
        // data/hora inicial de venda
        //cDtCriac += " 00:01:00"
        
        cDtCriac += "T" +cHori+"-03:00" //"00:00-03:00"
        
        cDtCria2 := Dtos(dDtfim)
        cDtCria2 := substr(cDtCria2,1,4)+"-"+substr(cDtCria2,5,2)+"-"+substr(cDtCria2,7,2)
        // data/hora inicial de venda
        //cDtCriac += " 00:01:00"
        
        cDtCria2 += "T" +cHorf+"-03:00" //"00:00-03:00"

        Vendas(cDtCriac,aHeader[nPosMaq,01],nPosMaq,cDtCria2)
        RETURN(aHeader[nPosMaq])
    ENDIF
ENDIF
              
RETURN

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CONWSC03   �Autor  �Microsiga           � Data �  04/13/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Busca maquinas                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

STATIC FUNCTION Maquinas()

    LOCAL nX
    Local oJsonBody

    oRestClient:setPath("/api/v1/machines?access_token="+cToken) 

    IF oRestClient:Get(aHeader)
        cValor := oRestClient:GetResult("GET")

        cValor := DecodeUTF8(cValor, "cp1252")
/*
        FWJsonDeserialize(cValor,@oJsonBody)

        For nX := 1 to len(oJsonBody)
            If AttIsMemberOf(oJsonBody[nX] , "INSTALLATION") 
                Aadd(aHeader,{cvaltochar(oJsonBody[nX]:ID),;
                            oJsonBody[nX]:ASSET_NUMBER,;
                            cvaltochar(oJsonBody[nX]:INSTALLATION:ID)  })
            EndIf
        Next nX **/

        cValor := strtran(cValor,"[")
        cValor := strtran(cValor,"]")
        cValor := strtran(cValor,'"')
        
        aLinhas := strtokarr(cValor,"},{") 
        
        FOR nX := 1 TO len(aLinhas)
            
            IF "asset_number" $ Alltrim(aLinhas[nX]) 
                aAux1 := Strtokarr(aLinhas[nX],":")
                aAux2 := Strtokarr(aLinhas[nX-1],":")
                Aadd(aHeader,{aAux2[2],aAux1[2]})  
            ENDIF

        NEXT nX

    ENDIF

RETURN       

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CONWSC03   �Autor  �Microsiga           � Data �  04/13/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Busca Instalacoes                                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

STATIC FUNCTION Instalacoes(cCod,nPos)

LOCAL nX

oRestClient:setPath("/api/v1/machines/"+Alltrim(cCod)+"/installations?access_token="+cToken) 

IF oRestClient:Get(aHeader)
    cValor     :=    oRestClient:GetResult("GET")
    cValor     :=    strtran(cValor,"[")
    cValor     :=    strtran(cValor,"]")
    cValor     :=    strtran(cValor,'"')
    
    aLinhas    :=    strtokarr(cValor,"},{") 
    IF len(aLinhas) > 0 
        FOR nX := len(aLinhas) TO 1 step -1
            IF substr(aLinhas[nX],1,3) == "id:"
                Aadd(aHeader[nPos],substr(aLinhas[nX],4)) 
                EXIT
            ENDIF
        NEXT nX
    ENDIF
ENDIF

RETURN            

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CONWSC03   �Autor  �Microsiga           � Data �  04/13/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Busca planogramas                                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

STATIC FUNCTION Planograma(cMaq,cInst,nPos)

LOCAL nJ
Local oJson
Local aMapa     :=  {}
Local aAux      :=  {}
 ///planograms
oRestClient:setPath("/api/v1/machines/"+Alltrim(cMaq)+"/installations/"+cInst+"?access_token="+cToken) 
        
IF oRestClient:Get(aHeader)
    cValor    :=    oRestClient:GetResult("GET")
    cValor := DecodeUTF8(cValor, "cp1252")
    oJson := JsonObject():New()
    oJson2:= JsonObject():New()
    oJson3:= JsonObject():New()

    ret := oJson:FromJson(cValor)
    
    //lret := oJson:GetJsonValue("current_planogram", @keyVal,  @keyType)
    ret := oJson2:FromJson(oJson:GetJsonText("current_planogram"))

    aMapa := oJson2["items"]
    
    For nJ :=  1 to len(aMapa)
        aAxCd := aMapa[nJ]:GetJsonObject('good')
        aCodPrd := strtokarr(aAxCd:GetJsonText('upc_code_name'),"#")

        Aadd(aAux,{,;
            aHeader[nPos,2],;
            aMapa[nJ]:GetJsonText('name'),;
            If(len(aCodPrd)>1,Alltrim(aCodPrd[2]),aAxCd:GetJsonText('upc_code_name')),; //aAxCd:GetJsonText('upc_code'),; //aMapa[nJ]:GetJsonText('id'),;
            If(len(aCodPrd)>1,Alltrim(aCodPrd[1]),aAxCd:GetJsonText('upc_code_name')),; //aAxCd:GetJsonText('name'),;
            aMapa[nJ]:GetJsonText('planogram_id'),;
            aMapa[nJ]:GetJsonText('good_id'),;
            aMapa[nJ]:GetJsonText('capacity'),;
            aMapa[nJ]:GetJsonText('par_level'),;
            aMapa[nJ]:GetJsonText('alert_level'),;
            aMapa[nJ]:GetJsonText('desired_price'),;
        })
    Next nJ

ENDIF

RETURN(aAux)        


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CONWSC03   �Autor  �Microsiga           � Data �  04/13/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

STATIC FUNCTION PlanoMaq(cMaq,cInst,cPlan,nPos)

LOCAL nJ

oRestClient:setPath("/api/v1/machines/"+Alltrim(cMaq)+"/installations/"+cInst+"/planograms/"+cPlan+"?access_token="+cToken) 

IF oRestClient:Get(aHeader)
    cValor    :=    oRestClient:GetResult("GET")
    cValor    :=    strtran(cValor,"[")
    cValor    :=    strtran(cValor,"]")
    cValor    :=    strtran(cValor,'"')
    
    aLinhas := strtokarr(cValor,"},{")
    IF len(aLinhas) > 0
            //items: inicia
        lInicio    :=    .F.
        lFim       :=    .F.
        aAux       :=    {}
        
        FOR nJ := 1 TO len(aLinhas)
            IF "items:" $ aLinhas[nJ]
                lInicio := .T.
            ENDIF
            
            /*IF "unit_symbol:" $ aLinhas[nJ]
                //lInicio := .F.
                lFim     := .F.
            ENDIF   */
            
            IF lInicio
                IF "id:" $ substr(aLinhas[nJ],1,3)  //.And. Ascan(aAux,{|x| substr(x,1,3) == substr(aLinhas[nJ],1,3)}) == 0
                    //IF !lFim
                        Aadd(aAux,aLinhas[nJ])    
                        //lFim := .T.
                    //ENDIF
                    
                ELSEIF "planogram_id:" $ aLinhas[nJ]
                    Aadd(aAux,aLinhas[nJ])
                ELSEIF "good_id:" $ aLinhas[nJ]
                    Aadd(aAux,aLinhas[nJ])
                ELSEIF "name:" $ aLinhas[nJ]
                    IF val(substr(aLinhas[nJ],6)) > 0 .And. valtype(val(aLinhas[nJ+1])) == "N" .And. val(aLinhas[nJ+1]) > 0
                        Aadd(aAux,Alltrim(aLinhas[nJ])+","+aLinhas[nJ+1])
                    ELSE
                        Aadd(aAux,aLinhas[nJ])
                    ENDIF
                ELSEIF "capacity:" $ aLinhas[nJ]
                    Aadd(aAux,aLinhas[nJ])
                ELSEIF "par_level:" $ aLinhas[nJ]
                    Aadd(aAux,aLinhas[nJ])
                ELSEIF "alert_level:" $ aLinhas[nJ]
                    Aadd(aAux,aLinhas[nJ])  
                ELSEIF "desired_price:" $ aLinhas[nJ]
                    Aadd(aAux,aLinhas[nJ])  
                ENDIF
            ENDIF
        NEXT nJ
        //unit_symbol: finaliza
        Aadd(aHeader[nPos],aAux)
    ENDIF
ENDIF

RETURN

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CONWSC03   �Autor  �Microsiga           � Data �  04/14/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Produto                                                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

STATIC FUNCTION Produto(cProd)

oRestClient:setPath("/api/v1/products/"+cProd+"?access_token="+cToken) 

IF oRestClient:Get(aHeader)
    cValor     :=    oRestClient:GetResult("GET")
    cValor     :=    strtran(cValor,"[")
    cValor     :=    strtran(cValor,"]")
    cValor     :=    strtran(cValor,'"')
    
    aLinhas    :=    strtokarr(cValor,"},{") 
ENDIF

RETURN

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CONWSC03   �Autor  �Microsiga           � Data �  05/31/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Vendas por maquina com data inicial                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

STATIC FUNCTION Vendas(cDtCriac,cMaquina,nPos,cDtCria2)

LOCAL cValor    :=    'res'
LOCAL nPage     :=    1
LOCAL nX
///api/v1/vends/?access_token=AkH1cWGwYdvUy3KfKwHdTQaegWcD9SVCsGQ03trB&start_date=31-05-2017%2000:00:00&machine_id=227
Local aAux     :=    {}
Local aAux2    :=   {}

WHILE nPage > 0
    oRestClient:setPath("/api/v1/vends/?access_token="+cToken+"&start_date="+cDtCriac+"&end_date="+cDtCria2+"&machine_id="+cMaquina+"&page="+cvaltochar(nPage)) 
    
    IF oRestClient:Get(aHeader)
        cValor := oRestClient:GetResult("GET")

        cValor := DecodeUTF8(cValor, "cp1252")
        FWJsonDeserialize(cValor, @aAux2)
        
        oJson := JsonObject():New()
        
        ret := oJson:FromJson(cValor)
        
        
        cValor := strtran(cValor,"[")
        cValor := strtran(cValor,"]")
        cValor := strtran(cValor,'"')
        
        
        IF !Empty(cValor)
            nPage++ 
        ELSE
            nPage := 0
        ENDIF
        
        aLinhas := strtokarr(cValor,"},{")

        For nX := 1 to len(aAux2)
            If aAux2[nX]:GOOD:CATEGORY_ID != NIL
                
                Aadd(aAux,aAux2[nX]:COIL)
                Aadd(aAux,aAux2[nX]:OCCURRED_AT)
                Aadd(aAux,cvaltochar(aAux2[nX]:QUANTITY))
                Aadd(aAux,cvaltochar(aAux2[nX]:VALUE))
                
                If aAux2[nX]:GOOD:NAME != NIL
                    aCod := separa(aAux2[nX]:GOOD:NAME,"#")
                    //Aadd(aAux,If(aAux2[nX]:GOOD:UPC_CODE==nil,'null',aAux2[nX]:GOOD:UPC_CODE))
                        Aadd(aAux,Alltrim(aCod[2]))
                    //EndIf 
                    
                ELSE
                        Aadd(aAux,'Item Nao encontrado')
                    
                EndIf

                Aadd(aHeader[nPos],aAux)
            ENDIF
             
            aAux := {}
        Next nX       
        
    ELSE
        nPage := 0
    ENDIF
ENDDO 

RETURN
