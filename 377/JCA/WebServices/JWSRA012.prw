#Include 'Protheus.ch'
#Include 'RestFul.ch'
#Include "FwMvcDef.ch"
/*
    API
    API para consultar status financeiro do cliente pelo cnpj

    Doc Mit
   
    Doc Validação entrega
    
    
    
*/

User Function JWSRA012()

Return

WsRestFul JWSRA012 DESCRIPTION "API REST - Consultar status financeiro de cliente" 
	
	WsMethod GET Description "API REST - Consultar status financeiro de cliente - METODO GET "  WsSyntax "JWSRA012"

End WsRestFul


WsMethod GET WSSERVICE JWSRA012

    LOCAL lRet      := .T.
    LOCAL oBody     
    Local cJson     := ::GetContent()
    Local cCnpj     :=  ''
    Local cCod      :=  ''
    Local cLoja     :=  ''
    Local aAux      :=  .F.
    Local nLinha 
    Local nCont
    Local oResponse     := JsonObject():New()
    Local oCampo        := JsonObject():New()

    RpcClearEnv()
    RpcSetType(3)
    RPCSetEnv('01','00020087')
    //RPCSetEnv('T1','D MG 01')

	::SetContentType("application/json")

    If lRet
        oBody  := JsonObject():New()
        oBody:fromJson(cJson) 

        cCnpj    := oBody:getJsonText("cnpj")

        
        If Empty(cCnpj)
            lRet		:= .F.
            oResponse['code'] := "#400"
            oResponse['status'] := 500
            oResponse['message'] := '#erro_json'
            oResponse['detailedMessage'] := 'Não foi informado o cnpj para consulta'
        Else 
            DbSelectArea("SA1")
            DbSetOrder(3)
            If Dbseek(xFilial("SA1")+cCnpj)
                cCod := SA1->A1_COD 
                cLoja:= SA1->A1_LOJA 
                
                oCampo['DADOS']   := {}
                    
                aAux := Busca(cCod,cLoja)
                nLinha := 1

                If len(aAux) < 1
                    AADD( oCampo['DADOS'], JsonObject():New() )
                    oCampo['DADOS'][nLinha]["INADIMPLENTE"] := .F.
                Else 

                    For nCont := 1 to len(aAux)
                        AADD( oCampo['DADOS'], JsonObject():New() )
                        oCampo['DADOS'][nLinha]["INADIMPLENTE"] := .T.
                        oCampo['DADOS'][nLinha]["TITULOS"] := {}
                        AADD( oCampo['DADOS'][nLinha]["TITULOS"], JsonObject():New() )
                        // E1_NUM,E1_PREFIXO,E1_PARCELA,E1_VENCREA,E1_VALOR
                        oCampo['DADOS'][nLinha]["TITULOS"][1]["TITULO"] := aAux[nCont,01]
                        oCampo['DADOS'][nLinha]["TITULOS"][1]["PREFIXO"] := aAux[nCont,02]
                        oCampo['DADOS'][nLinha]["TITULOS"][1]["PARCELA"] := aAux[nCont,03]
                        oCampo['DADOS'][nLinha]["TITULOS"][1]["VENCIMENTO"] := cvaltochar(aAux[nCont,04])
                        oCampo['DADOS'][nLinha]["TITULOS"][1]["VALOR"] := aAux[nCont,05]
                        nLinha++
                    Next nCont 
                EndIf 
                
                ::SetResponse(FWJsonSerialize(oCampo, .F., .F., .T.))
            else
                lRet		:= .F.
                oResponse['code'] := "#400"
                oResponse['status'] := 500
                oResponse['message'] := '#erro_cnpj'
                oResponse['detailedMessage'] := 'CNPJ não encontrado na base'
            EndIf 

            
        EndIf 
                        
        
        
    EndIf

	
    If !lRet
        /*cResult := '{'
        cResult += '"status" : {'
        cResult += '"code" : "'+cCode+'",'
        cResult += '"message" : "'+cMessage+'"'
        cResult += '},'
        cResult += '"result" : {'
        cResult += cResultAux
        cResult += '}'
        cResult += '}'*/

        ::SetResponse(FWJsonSerialize(oResponse, .F., .F., .T.))
        //::SetContentType('application/json')
        //::SetResponse(cResult)
    EndIf

	RpcClearEnv()

Return lRet

/*/{Protheus.doc} Busca
    Busca titulos em aberto do cliente
    @type  Static Function
    @author user
    @since 11/03/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Busca(cCod,cLoja)

Local aRet  := {}
Local cQuery 

cQuery := "SELECT E1_NUM,E1_PREFIXO,E1_PARCELA,E1_VENCREA,E1_VALOR"
cQuery += " FROM "+RetSQLName("SE1")
cQuery += " WHERE E1_FILIAL BETWEEN ' ' AND 'ZZZ' AND E1_CLIENTE='"+cCod+"' AND E1_LOJA='"+cLoja+"'"
cQuery += " AND D_E_L_E_T_=' '"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("JCAJOB01.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB") 

While !EOF()
    Aadd(aRet,{TRB->E1_NUM,TRB->E1_PREFIXO,TRB->E1_PARCELA,stod(TRB->E1_VENCREA),TRB->E1_VALOR})
    Dbskip()
EndDo 

Return(aRet)

Static Function fRemoveCarc(cWord)
    cWord := FwCutOff(cWord, .T.)
    cWord := strtran(cWord,"ã","a")
	cWord := strtran(cWord,"á","a")
	cWord := strtran(cWord,"à","a")
	cWord := strtran(cWord,"ä","a")
    cWord := strtran(cWord,"º","")
    cWord := strtran(cWord,"%","")
    cWord := strtran(cWord,"*","")     
    cWord := strtran(cWord,"&","")
    cWord := strtran(cWord,"$","")
    cWord := strtran(cWord,"#","")
    cWord := strtran(cWord,"§","") 
    cWord := strtran(cWord,",","")
    cWord := StrTran(cWord, "'", "")
    cWord := StrTran(cWord, "#", "")
    cWord := StrTran(cWord, "%", "")
    cWord := StrTran(cWord, "*", "")
    cWord := StrTran(cWord, "&", "E")
    cWord := StrTran(cWord, ">", "")
    cWord := StrTran(cWord, "<", "")
    cWord := StrTran(cWord, "!", "")
    cWord := StrTran(cWord, "@", "")
    cWord := StrTran(cWord, "$", "")
    cWord := StrTran(cWord, "(", "")
    cWord := StrTran(cWord, ")", "")
    cWord := StrTran(cWord, "_", "")
    cWord := StrTran(cWord, "=", "")
    cWord := StrTran(cWord, "+", "")
    cWord := StrTran(cWord, "{", "")
    cWord := StrTran(cWord, "}", "")
    cWord := StrTran(cWord, "[", "")
    cWord := StrTran(cWord, "]", "")
    cWord := StrTran(cWord, "?", "")
    cWord := StrTran(cWord, "\", "")
    cWord := StrTran(cWord, "|", "")
    cWord := StrTran(cWord, ":", "")
    cWord := StrTran(cWord, ";", "")
    cWord := StrTran(cWord, '"', '')
    cWord := StrTran(cWord, '°', '')
    cWord := StrTran(cWord, 'ª', '')
    cWord := Alltrim(Lower(cWord))
Return cWord

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 24/11/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function GetErro()

Local cPath	:= GetSrvProfString("Startpath","")
Local cArq	:= "Erro_Rot_Auto_"+Dtos(dDataBase)+"_"+StrTran(Time(),":","_")+Alltrim(Str(ThreadID()))+".txt"
Local cRet	:= ""

MostraErro( cPath , cArq )

cRet := StrTran(MemoRead(  cPath + '\' + cArq ),Chr(13) + Chr(10)," ")
cRet := StrTran(cRet, '"', "'")

fErase(cArq)

Return cRet
