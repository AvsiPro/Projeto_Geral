#include "TOTVS.CH"
#Include "Restful.Ch"
#include "FWMVCDEF.CH"
#Include "topconn.ch"
#Include "tbiconn.ch"

User Function TINTA004(cCodApi,lTeste)

Local aArea     :=  GetArea()
Local aConfig   :=  {}
Local aAux      :=  {}
Local aJson     :=  {}
Local nCont
Local aTeste    :=  {}
Local nJ
Local nY

Private cCodP36   :=  ''

Private aDestinos   :=  {}
Private aEnvios     :=  {}

Default cCodApi :=  '000024' 
Default lTeste  :=  .F.

If Empty(FunName())
    RpcSetType(3)
    RPCSetEnv("00","00001000100")
EndIf

DbSelectArea("PAJ")
DbSetOrder(1)
If Dbseek(xFilial("PAJ")+cCodApi)
    Aadd(aConfig,PAJ->PAJ_CODIGO)
    Aadd(aConfig,PAJ->PAJ_DESCRI)
    Aadd(aConfig,PAJ->PAJ_URL)
    Aadd(aConfig,PAJ->PAJ_ENDPOI)
    Aadd(aConfig,PAJ->PAJ_LIMITE)
    Aadd(aConfig,PAJ->PAJ_TABELA)
    Aadd(aConfig,PAJ->PAJ_QUERY)
    Aadd(aConfig,PAJ->PAJ_JSON)
    Aadd(aConfig,PAJ->PAJ_CAMPOS)
    Aadd(aConfig,PAJ->PAJ_ULTEXE)
    cCodP36 := PAJ->PAJ_CODP36
    aDestinos := Separa(PAJ->PAJ_DESTIN,"&")
    

    If len(aDestinos) > 0   
        For nY := 1 to len(aDestinos)
            aBkLin  :=  Separa(aDestinos[nY],"|")
            aAux    := {}
            For nJ := 1 to len(aBkLin)
                Aadd(aAux,aBkLin[nJ])
            Next nJ
            If len(aAux) > 0
                Aadd(aEnvios,aAux)
            Endif
        Next nY
    EndIf

    Aadd(aConfig,aEnvios)
    Aadd(aConfig,PAJ->PAJ_CODP36)
ENDIF

If len(aConfig) > 0
    If lTeste
        //Executar a Query
        Processa({|| aAux := Buscadados(aConfig[7],aConfig[9],aConfig[10],lTeste)},"Buscando dados")
        If len(aAux) > 0
            //Montar Json
            Processa({|| aJson := MontaJson(aAux,aConfig[8],aConfig[9],aConfig[5])},"Montando Json")
            //Enviar para WS
            If len(aJson) > 0
                cUrlDest := aConfig[3]
                cPathDest:= aConfig[4]

                For nCont := 1 to len(aJson)
                    Processa({|| Aadd(aTeste,ApiEnv04(cUrlDest,cPathDest,aJson[nCont]))},"Aguarde")
                Next nCont

                cResult := ''
                For nCont := 1 to len(aTeste)
                    cResult += aTeste[nCont,1]+CRLF 
                Next nCont 

                If !Empty(cResult)
                    MsgAlert("Resultado"+CRLF+cResult)
                EndIf
            EndIf
        EndIf 
    Else
        //Buscar os itens a serem enviados para a fila da p37
        aAux := Buscadados(aConfig[7],aConfig[9],aConfig[10],lTeste)
            
        For nJ := 1 to len(aConfig[11])
            //Executar a Query
            If len(aAux) > 0
                //Montar Json
                aJson := MontaJson(aAux,aConfig[8],aConfig[9],aConfig[11,nJ,4]) //aConfig[5]
            EndIf

            //Enviar para ws
            //Agora gravaremos na fila da p37
            If len(aJson) > 0
                cUrlDest := Alltrim(aConfig[11,nJ,2]) //aConfig[3]
                cPathDest:= Alltrim(aConfig[11,nJ,3]) //aConfig[4]

                For nCont := 1 to len(aJson)
                    //ApiEnv04(cUrlDest,cPathDest,aJson[nCont])
                    GeraP37(cUrlDest,cPathDest,aJson[nCont],aConfig[12])
                Next nCont
            EndIf
        Next nJ
    EndIf 
EndIf 

DbSelectArea("PAJ")
DbSetOrder(1)
If Dbseek(xFilial("PAJ")+cCodApi)
    RecLock("PAJ", .F.)
    PAJ->PAJ_ULTEXE := dtos(ddatabase)+strtran(cvaltochar(time()),":")
    PAJ->(MsUnlock())        
ENDIF

RestArea(aArea)

Return
/*/{Protheus.doc} APICustJur
    (long_description)
    @type  Static Function
    @author user
    @since 17/01/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function ApiEnv04(cUrlDest,cPathDest,cJAux)

Local oRest 
Local oJson     :=  ""
Local aHeader   :=  {}
Local cRetorno  :=  ""
Local lRet      :=  .T.
Local aRet      :=  {}


Local cUrlInt	:=	Alltrim(cUrlDest) 

Local cPath     :=  Alltrim(cPathDest)

oRest := FWRest():New(cUrlInt)

oRest:SetPath(cPath)

//aadd(aHeader,'Content-Type : application/json')

oRest:SetPostParams(cJAux)

If oRest:Post(aHeader)
    oJson := JsonObject():New()
    cRet  := oRest:GetResult()
    oRet := oJson:FromJson(cRet)
    lRet := .T.
else
    cRetorno := Alltrim(oRest:GetLastError()) 
    cRet := Alltrim(oRest:cresult)
    oBody  := JsonObject():New()
    oBody:fromJson(cRet)
    lRet := .F.
Endif

Aadd(aRet,cRet)

Return(aRet)

/*/{Protheus.doc} Buscadados(aConfig[7],aConfig[9])
    (long_description)
    @type  Static Function
    @author user
    @since 10/05/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Buscadados(cQry,cCampos,cStamp,lTeste)

Local aArea :=  GetArea()
Local aRet  :=  {}
Local cQuery 
Local aAux    := {}
Local aCampos := separa(cCampos,"|")
Local nCont 

cQuery := strtran(cQry,'CTIMESTAMP',cStamp)

If lTeste
    cQuery += " AND ROWNUM < 10"
EndIf 

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    aAux := {}
    For nCont := 1 to len(aCampos)-1
        Aadd(aAux,&('TRB->'+aCampos[nCont]))
    Next nCont
    Aadd(aRet,aAux)
    Dbskip()
EndDo 

RestArea(aArea)

Return(aRet) 

/*/{Protheus.doc} MontaJson(aAux,aConfig[8])
    (long_description)
    @type  Static Function
    @author user
    @since 25/05/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function MontaJson(aArray,cTemplate,cCampos,nLimite)

Local aArea     :=  GetArea()
Local aCampos   :=  separa(cCampos,"|")
Local nCont  
Local cJsonChg  :=  cTemplate
Local nK        :=  0
Local aRet      :=  {}
Local cTipCp    :=  {}

If val(nLimite) > 1
    cJsonChg := "["+CRLF+cJsonChg
EndIf 

For nK := 1 to len(aArray)
    For nCont := 1 to len(aCampos)
        If !Empty(aCampos[nCont])
            //cJsonChg := strtran(cJsonChg,"%"+aCampos[nCont]+"%",Alltrim(aArray[nK,nCont]))
            cTipCp := FWSX3Util():GetFieldType( aCampos[nCont] )
            cJsonChg := strtran(cJsonChg,"%"+aCampos[nCont]+"%",If(cTipCp<>"C",cvaltochar(aArray[nK,nCont]),aArray[nK,nCont]))
        EndIf 
    Next nCont 
    
    //Json em lote (nLimite determina a quantidade de itens por lote)
    If val(nLimite) > 1
        If nK >= val(nLimite)  .Or. nK+1 == len(aArray)
            cJsonChg += CRLF+"]"
            Aadd(aRet,cJsonChg)
            cJsonChg  :=  cTemplate
            cJsonChg := "["+CRLF+cJsonChg
        Else    
            cJsonChg += ","+CRLF+cTemplate
        EndIf 
    Else
        Aadd(aRet,cJsonChg)
        cJsonChg  :=  cTemplate
    EndIf
Next nK

RestArea(aArea)

Return(aRet)

/*/{Protheus.doc} GeraP37
    (long_description)
    @type  Static Function
    @author user
    @since 30/09/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function GeraP37(cUrlDest,cPathDest,cJson,cCodApi)
    
Local aArea     :=  GetArea()
Local cCodP37   :=  GetSxEnum("P37","P37_COD")

ConfirmSX8()

DbSelectArea("P37")
Reclock("P37",.T.)
P37->P37_FILIAL	:=  xFilial("P37")
P37->P37_COD	:=  cCodP37
P37->P37_DATA	:=  dDataBase
P37->P37_HORA	:=  cvaltochar(time())
P37->P37_URL	:=  cUrlDest
P37->P37_PATH	:=	cPathDest
P37->P37_BODY	:=  cJson
P37->P37_METHOD	:=	'POST'
P37->P37_CALLBA	:=	'U_TINTA004'
P37->P37_ASYNC1	:=	'S'
P37->P37_CODAPI	:=	cCodP36
P37->P37_STATUS	:=	'1'
P37->P37_TIPORE	:=	'1'
P37->(MsUnlock())

RestArea(aArea)

Return


/*/{Protheus.doc} User Function xTint04
    (long_description)
    @type  Function
    @author user
    @since 21/11/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function xTint04()
    
Local aArea     :=  GetArea()
Local cQuery 
Local nX 
Local aItens    :=  {}

If Empty(FunName())
    RpcSetType(3)
    RPCSetEnv("00","00001000100")
EndIf

cQuery := "SELECT PAJ_CODIGO FROM "+RetSQLName("PAJ")
cQuery += " WHERE D_E_L_E_T_=' '"

If Select('QUERY') > 0
    dbSelectArea('QUERY')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "QUERY", .F., .T. )

DbSelectArea("QUERY")

While !EOF()
    Aadd(aItens,QUERY->PAJ_CODIGO)
    Dbskip()
EndDo 

For nX := 1 to len(aItens)
    U_TINTA004(aItens[nX],.F.)
Next nX 

RestArea(aArea)

Return
