#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "topconn.ch"
#Include 'RestFul.ch'

/*
    Job para integração com a Equals para lançamento dos movimentos bancarios por dia conciliados

    Não tem MIT
    
*/
User Function JFINM010

Local aArea     := GetArea()
Local nCont 
Local aSm0      := {}
Local aGrupos   := {}
Local aItens    := {}
Local aSeries   := {}
Local nSeries   
Private aValores  := {}
Private aCabec  := {}

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

Ddate := ddatabase
cTime := time()

cMilsHr := FWTimeStamp(4,Ddate,cTime)
//https://app.equals.com.br/api/agendaRecebimentos?agrupamento=1&diaBase=1711750020213
//ApiEnv04('https://app.equals.com.br/','api/adquirentes','')
aItens := ApiEnv04('https://app.equals.com.br/','api/agendaRecebimentos?agrupamento=1&diaBase='+cMilsHr+'213','')

For nCont := 1 to len(aItens)
    cId := aItens[nCont]:id
    cAdiq := aItens[nCont]:nome
    aSeries := aItens[nCont]:series
    For nSeries := 1 to len(aSeries)
        cAgencia := aSeries[nSeries]:agencia
        cConta   := aSeries[nSeries]:conta
        dDiaPgto := aSeries[nSeries]:data
        nVlrBrut := aSeries[nSeries]:valor 
        nVlrLiq  := aSeries[nSeries]:liquido

        aBco := BuscaBco(cvaltochar(cAgencia),cConta)
        cBanco := ''
        cFilLct:= ''

        If len(aBco) > 0
            cBanco := aBco[1,2]
            cFilLct:= aBco[1,1]
        EndIf 

        If nVlrLiq > 0
            Aadd(aValores,{cId,;
                            cAdiq,;
                            cBanco,;
                            cvaltochar(cAgencia),;
                            cConta,;
                            stod(strtran(dDiaPgto,"-")),;
                            nVlrBrut,;
                            nVlrLiq,;
                            cFilLct})
        EndIf 
    Next nSeries

Next nCont 

If len(aValores) > 0

    Aadd(aCabec,{'ID',;
                'Adquirente',;
                'Banco',;
                'Agencia',;
                'Conta',;
                'Data_Pagto',;
                'Valor_Bruto',;
                'Valor_Liquido',;
                'Filial_Conta'})

    GeraPlan()
EndIf 

RestArea(aArea)

Return

/*/{Protheus.doc} BuscaBco
    (long_description)
    @type  Static Function
    @author user
    @since 28/03/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function BuscaBco(cAgencia,cConta)

Local aArea := GetArea()
Local cQuery 
Local aRet  := {}

cQuery := "SELECT A6_FILIAL,A6_COD "
cQuery += " FROM "+RetSQLName("SA6")
cQuery += " WHERE D_E_L_E_T_=' '"
cQuery += " AND A6_AGENCIA='"+cAgencia+"' AND rtrim(A6_NUMCON)+rtrim(A6_DVCTA)='"+Alltrim(cConta)+"'"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("JFISM001.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

Aadd(aRet,{TRB->A6_FILIAL,TRB->A6_COD})

RestArea(aArea)

Return(aRet)

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
Local oParser

AAdd(aHeader, "Content-Type: application/json")
AAdd(aHeader, "Authorization: Basic YWxleGFuZHJlLnZlbmFuY2lvQGdydXBvMzc3LmNvbS5icjpGRmxscm44QTYxVVZOdW5YNHNlMDRoaVhrTjlXQlpqUA==")

oRest := FWRest():New(cUrlInt)

oRest:SetPath(cPath)

oRest:SetPostParams(cJson)

If oRest:Get(aHeader)
    oJson := JsonObject():New()
    cRet  := oRest:GetResult()
    FwJsonDeserialize(cRet,@oParser) //nao esta fazendo pelo objeto jsonobject 
    oJson:FromJson(cRet) 
    lRet := .T.
else
    cRetorno := Alltrim(oRest:GetLastError()) 
    cRet := Alltrim(oRest:cresult)
    oBody  := JsonObject():New()
    oBody:fromJson(cRet)
    FwJsonDeserialize(cRet,@oParser)  //nao esta fazendo pelo objeto jsonobject 
    lRet := .F.
Endif

Return(oParser)

/*/{Protheus.doc} GeraPlan
    (long_description)
    @type  Static Function
    @author user
    @since 04/08/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function GeraPlan()

Local oExcel 	:= FWMSEXCEL():New()
Local cDir 		:= ""
Local cArqXls 	:= "Relacao_"+dtos(ddatabase)+strtran(time(),":")+".xls" 
Local nX,nY 
Local aAux      :=  {}
//Local cGuia     :=  'Conciliação'
Local cExterno  :=  'Relacao_Pagamentos'

cDir := cGetFile(, OemToAnsi("Selecione o diretório de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 

If Empty(cDir)
	Return
EndIf

oExcel:AddworkSheet(cExterno) 
oExcel:AddTable (cExterno,cExterno)

For nX := 1 to len(aCabec[1])
    oExcel:AddColumn(cExterno,cExterno,aCabec[1,nX],1,1)
Next nX


For nX := 1 to len(aValores)
    aAux := {}
    For nY := 1 to len(aCabec[1])
        Aadd(aAux,aValores[nX,nY])
    Next nY

    oExcel:AddRow(cExterno,cExterno,aAux)
Next nX



oExcel:Activate()

oExcel:GetXMLFile(cDir +cArqXls)

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(cDir +cArqXls)     //Abre uma planilha
oExcelApp:SetVisible(.T.)        
oExcelApp:Destroy()

	
    
Return(cDir+cArqXls)
