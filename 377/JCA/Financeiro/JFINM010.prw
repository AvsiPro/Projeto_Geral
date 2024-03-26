#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "topconn.ch"

User Function JFINM010

Local aArea     := GetArea()
Local nCont 
Local aSm0      := {}
Local aGrupos   := {}

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","00020087")
EndIf

aSm0 := FWLoadSM0()

For nCont := 1 to len(aSm0)
    If Ascan(aGrupos,{|x| x == aSM0[nCont,03]+'-'+aSm0[nCont,17]}) == 0 
        Aadd(aGrupos,aSM0[nCont,03]+'-'+aSm0[nCont,17])
    EndIf 
Next nCont

Ddate := ctod("31/03/2024")
cTime := time()

cMilsHr := FWTimeStamp(4,Ddate,cTime)
//https://app.equals.com.br/api/agendaRecebimentos?agrupamento=1&diaBase=1711750020213
//ApiEnv04('https://app.equals.com.br/','api/adquirentes','')
ApiEnv04('https://app.equals.com.br/','api/agendaRecebimentos?agrupamento=1&diaBase='+cMilsHr+'213','')

RestArea(aArea)

Return



/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 12/03/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function ApiEnv04(cUrlDest,cPathDest,cJson)

Local oRest 
Local oJson     :=  ""
Local aHeader   :=  {}
Local cRetorno  :=  ""
Local lRet      :=  .T.
Local cUrlInt	:=	Alltrim(cUrlDest) 
Local cPath     :=  Alltrim(cPathDest)

AAdd(aHeader, "Content-Type: application/json")
AAdd(aHeader, "Authorization: Basic YWxleGFuZHJlLnZlbmFuY2lvQGdydXBvMzc3LmNvbS5icjpGRmxscm44QTYxVVZOdW5YNHNlMDRoaVhrTjlXQlpqUA==")

oRest := FWRest():New(cUrlInt)

oRest:SetPath(cPath)

oRest:SetPostParams(cJson)

If oRest:Get(aHeader)
    oJson := JsonObject():New()
    cRet  := oRest:GetResult()
    oJson:FromJson(cRet) 
    lRet := .T.
else
    cRetorno := Alltrim(oRest:GetLastError()) 
    cRet := Alltrim(oRest:cresult)
    oBody  := JsonObject():New()
    oBody:fromJson(cRet)
    lRet := .F.
Endif

Return(cRet)

/*
FWTimeStamp(nType,Ddate,cTime)

nTyPe. Define o retorno que você quer, sendo:

1 -Formato aaaammddhhmmss

2 - Formato dd/mm/aaaa-hh:mm:ss

3 - Fotmato UTC aaaa-mm-ddThh:mm:ss (Soment pega a hora local e coloca neste formato)

4 - Estampa de tempo em milissegundos desde 01/01/1970 00:00:00

5 - Formato UTC aaaa-mm-ddThh:mm:ss-+Time Zone (coloca a hora local + o timezone (ISO 8106))

6 - Formato UTC aaaa-mm-ddThh:mm:ssZ (Transforma a data atual em uma data e hora GMT 0)

dDate Data a ser usada. O padrao é a data atual

cTime Hora a ser usada. O padrao é a hora atual
*/
