#INCLUDE "PROTHEUS.CH"
#INCLUDE "PARMTYPE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONWSC03   ºAutor  ³Microsiga           º Data ³  04/13/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  WS Generico para consultas                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Busca o planograma de todas as maquinas                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION CONWSC03(cAtivo,nChamada,dDtini,dDtfim,cHori,cHorf)
                     
LOCAL aAuxP            :=    {}              
LOCAL nJ
LOCAL nK
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
        //Buscar Instalações    
        Instalacoes(aHeader[nPosMaq,01],nPosMaq)       
        
        //Buscar id de Planogramas por maquina
        Planograma(aHeader[nPosMaq,01],aHeader[nPosMaq,03],nPosMaq)
        
        //Buscar Planograma da maquina
        //PlanoMaq(aHeader[nPosMaq,01],aHeader[nPosMaq,03],aHeader[nPosMaq,04],nPosMaq)
        
        aRetorno := aHeader[nPosMaq] 
        nP := 0       
        FOR nJ := 1 TO len(aRetorno[4]) step 11  
            IF nJ+10 > len(aRetorno[4])
                EXIT
            ENDIF
                Aadd(aAuxP,{.F.,cAtivo,aRetorno[4,nJ+3],aRetorno[4,nJ+4],aRetorno[4,nJ+5],aRetorno[4,nJ+6],aRetorno[4,nJ+7],aRetorno[4,nJ+10]})
            //ENDIF
        NEXT nJ 
        
        aList3 := {}
        aList6 := {}
        
        FOR nJ := 1 TO len(aAuxP)               
            IF !"name:" $ aAuxP[nJ,03] 
                LOOP
            ENDIF
            aAux2 := {}
            Aadd(aAux2,aAuxP[nJ,01])
            Aadd(aAux2,aAuxP[nJ,02])
            //nPosn := Ascan(aAuxP[nJ],{|x| substr(x,1,3) == "upc"})
            aAux1 := strtokarr(aAuxP[nJ,len(aAuxP[nJ])],":")
            aAux3 := strtokarr(aAux1[2],"-")
            
            FOR nK := 3 TO len(aAuxP[nJ])-1
                aAux1 := strtokarr(aAuxP[nJ,nK],":")
                IF aAux1[1] == 'name' .And. val(aAux1[2]) <= 0 .And. !"_" $ aAux1[2]
                    LOOP
                ENDIF
                lValor := IF(aAux1[1]$"desired_price/capacity/par_level/alert_level",.T.,.F.)
                Aadd(aAux2,IF(lValor,val(aAux1[2]),aAux1[2]))
                IF nK == 3 
                    //cCodProt := Posicione("SB1",12,xFilial("SB1")+aAux3[1],"B1_COD")       
                       //cCodProt := ''
                    //IF Empty(cCodProt)
                    cCodProt := cvaltochar(val(Alltrim(aAux3[1])))
                    cDesc     := Alltrim(Posicione("SB1",1,xFilial("SB1")+cCodProt,"B1_DESC"))
                    /*ELSE
                        cDesc     := Alltrim(Posicione("SB1",12,xFilial("SB1")+aAux3[1],"B1_DESC"))
                    ENDIF*/
                    Aadd(aAux2,cCodProt)
                    Aadd(aAux2,cDesc)
                ENDIF
            NEXT nK
            Aadd(aAux2,'')
            IF len(aAux2) > 7
                Aadd(aList3,aAux2)
            ENDIF
        NEXT nJ 
        
        FOR nJ := 1 TO len(aCanister)
            aAux1 := strtokarr(aCanister[nJ],":")
            aCanister[nJ] := aAux1[2]
        NEXT nJ

        FOR nJ := 1 TO len(aCanister) step 6
            IF nJ + 5 <= len(aCanister)
                aAux2 := {}
                Aadd(aAux2,.F.)
                Aadd(aAux2,aCanister[nJ])
                Aadd(aAux2,aCanister[nJ+1])
                Aadd(aAux2,aCanister[nJ+2])
                Aadd(aAux2,aCanister[nJ+3])
                Aadd(aAux2,aCanister[nJ+5])
                Aadd(aAux2,cvaltochar(val(aCanister[nJ+2])-val(aCanister[nJ+5])))
                Aadd(aList6,aAux2)
            ENDIF
        NEXT nJ
    
        IF len(aList3) < 1
            Aadd(aList3,{.T.,'','','','','','','','','','','','','','','','','',''})
        ENDIF
        IF len(aList6) < 1
            Aadd(aList6,{.T.,'','','','','','','','','','','','','','','','','',''})
        ENDIF
        
        oList3:SetArray(aList3)
        oList3:bLine := {||{ IF(aList3[oList3:nAt,01],oOk,oNo),; 
                              Alltrim(aList3[oList3:nAt,02]),;
                              Strzero(val(aList3[oList3:nAt,03]),2),;
                              aList3[oList3:nAt,04],;
                              aList3[oList3:nAt,05],;
                              aList3[oList3:nAt,06],;
                              aList3[oList3:nAt,07],;
                              aList3[oList3:nAt,08],;
                              Transform(aList3[oList3:nAt,09],"@E 999,999.99")}}   
        
        oList6:SetArray(aList6)
        oList6:bLine := {||{ IF(aList6[oList6:nAt,01],oOk,oNo),; 
                                 Alltrim(aList6[oList6:nAt,02]),;
                                 aList6[oList6:nAt,03],;
                                 aList6[oList6:nAt,04],;
                                 aList6[oList6:nAt,05],;
                                 aList6[oList6:nAt,06],;
                                 aList6[oList6:nAt,07]}} 
                              
        oList3:refresh()
        oList6:refresh()
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONWSC03   ºAutor  ³Microsiga           º Data ³  04/13/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Busca maquinas                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC FUNCTION Maquinas()

LOCAL nX

oRestClient:setPath("/api/v1/machines?access_token="+cToken) 

IF oRestClient:Get(aHeader)
    cValor := oRestClient:GetResult("GET")
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONWSC03   ºAutor  ³Microsiga           º Data ³  04/13/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Busca Instalacoes                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONWSC03   ºAutor  ³Microsiga           º Data ³  04/13/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Busca planogramas                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC FUNCTION Planograma(cMaq,cInst,nPos)

LOCAL nJ

 ///planograms
oRestClient:setPath("/api/v1/machines/"+Alltrim(cMaq)+"/installations/"+cInst+"?access_token="+cToken) 
        
IF oRestClient:Get(aHeader)
    cValor    :=    oRestClient:GetResult("GET")
    cValor    :=    strtran(cValor,"[")
    cValor    :=    strtran(cValor,"]")
    cValor    :=    strtran(cValor,'"')
    
    aLinhas := strtokarr(cValor,"},{")
    IF len(aLinhas) > 0
        //Aadd(aHeader[nPos],substr(aLinhas[1],4))
        lInicio      :=    .F.
        lFim         :=    .F.
        aAux         :=    {}
        lCanister    :=    .F.
        
        FOR nJ := 1 TO len(aLinhas)
            IF "items:" $ aLinhas[nJ]
                lInicio := .T.
            ENDIF
            
            IF "type:Canister" $ aLinhas[nJ] .And. !lCanister
                lCanister := .T.
                lInicio := .F.
                //Aadd(aAux,aLinhas[nJ])
                //nCanister := len(aAux)
            ENDIF
            
            IF lInicio
                IF "id:" $ substr(aLinhas[nJ],1,3)  //.And. Ascan(aAux,{|x| substr(x,1,3) == substr(aLinhas[nJ],1,3)}) == 0
                    Aadd(aAux,aLinhas[nJ])    
                ELSEIF "planogram_id:" $ aLinhas[nJ]
                    Aadd(aAux,aLinhas[nJ])
                ELSEIF "good_id:" $ aLinhas[nJ]
                    Aadd(aAux,aLinhas[nJ])
                ELSEIF "name:" $ aLinhas[nJ] 
                    IF val(substr(aLinhas[nJ],6)) > 0 .And. valtype(val(aLinhas[nJ+1])) == "N" .And. val(aLinhas[nJ+1]) > 0
                        //CORRIGIR AQUI PARA QUANDO FOR MAIS DE 2 MOLAS PARA O MESMO PRODUTO.
                        lFim := .F.
                        nPing := nJ
                        cMolas := Alltrim(aLinhas[nPing])
                        cBarra := ','                   
                        nPing++
                        WHILE !lFim
                            IF valtype(val(aLinhas[nPing])) == "N" .And. val(aLinhas[nPing]) > 0
                                cMolas += cBarra + Alltrim(aLinhas[nPing])
                                nPing++
                            ELSE
                                lFim := .T.
                            ENDIF
                        ENDDO
                        //Aadd(aAux,Alltrim(aLinhas[nJ])+","+aLinhas[nJ+1])
                        Aadd(aAux,cMolas)
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
            
            IF lCanister 
                IF "name:" $ aLinhas[nJ] .And. Ascan(aCanister,{|x| Alltrim(x) == Alltrim(aLinhas[nJ])}) == 0 .And. !"upc_code_name:" $ aLinhas[nJ]  
                    Aadd(aCanister,aLinhas[nJ])    
                ELSEIF "capacity:" $ aLinhas[nJ]
                    Aadd(aCanister,aLinhas[nJ])    
                ELSEIF "par_level:" $ aLinhas[nJ]
                    Aadd(aCanister,aLinhas[nJ])    
                ELSEIF "alert_level:" $ aLinhas[nJ]
                    Aadd(aCanister,aLinhas[nJ])    
                ELSEIF "desired_price:" $ aLinhas[nJ]
                    Aadd(aCanister,aLinhas[nJ])    
                ELSEIF "current_balance:" $ aLinhas[nJ]
                    Aadd(aCanister,aLinhas[nJ])    
                ENDIF
            ENDIF
        NEXT nJ
        //unit_symbol: finaliza
 
        Aadd(aHeader[nPos],aAux)
    ENDIF
ENDIF

RETURN           


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONWSC03   ºAutor  ³Microsiga           º Data ³  04/13/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONWSC03   ºAutor  ³Microsiga           º Data ³  04/14/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Produto                                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONWSC03   ºAutor  ³Microsiga           º Data ³  05/31/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Vendas por maquina com data inicial                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC FUNCTION Vendas(cDtCriac,cMaquina,nPos,cDtCria2)

LOCAL cValor    :=    'res'
LOCAL nPage     :=    1
LOCAL nX
///api/v1/vends/?access_token=AkH1cWGwYdvUy3KfKwHdTQaegWcD9SVCsGQ03trB&start_date=31-05-2017%2000:00:00&machine_id=227
aAux     :=    {}
        
WHILE nPage > 0
    oRestClient:setPath("/api/v1/vends/?access_token="+cToken+"&start_date="+cDtCriac+"&end_date="+cDtCria2+"&machine_id="+cMaquina+"&page="+cvaltochar(nPage)) 
    
    IF oRestClient:Get(aHeader)
        cValor := oRestClient:GetResult("GET")
        cValor := strtran(cValor,"[")
        cValor := strtran(cValor,"]")
        cValor := strtran(cValor,'"')
        
        IF !Empty(cValor)
            nPage++ 
        ELSE
            nPage := 0
        ENDIF
        
        aLinhas := strtokarr(cValor,"},{")      
        FOR nX := 1 TO len(aLinhas)     
            IF "occurred_at:" $ aLinhas[nX]
                Aadd(aAux,stod(strtran(substr(alinhas[nX],13,10),"-")))
            ELSEIF "coil:" $ aLinhas[nX]
                Aadd(aAux,substr(aLinhas[nX],6))
            ELSEIF "quantity:" $ aLinhas[nX]
                Aadd(aAux,substr(aLinhas[nX],10))
            ELSEIF "value:" $ aLinhas[nX]
                Aadd(aAux,substr(aLinhas[nX],7))
            ELSEIF "upc_code:" $ aLinhas[nX]
                Aadd(aAux,substr(aLinhas[nX],10))    
                Aadd(aHeader[nPos],aAux)
                aAux := {}
            ENDIF 
        NEXT nX
    ELSE
        nPage := 0
    ENDIF
ENDDO 

RETURN
