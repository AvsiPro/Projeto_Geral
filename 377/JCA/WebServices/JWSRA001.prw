#Include 'Protheus.ch'
#Include 'RestFul.ch'
#Include "FwMvcDef.ch"


User Function JWSRA001()

Return

WsRestFul JWSRA001 DESCRIPTION "API REST - Evento Cadastro de Titulos" 
	
	WsMethod POST Description "API REST - Evento Cadastro de Titulos - METODO POST "  WsSyntax "JWSRA001"

End WsRestFul


WsMethod POST WsReceive RECEIVE WsService JWSRA001

    Local cTipOper      As Character
    Local cPrefixo  	As Character 
	Local cTitulo		As Character
    Local cParcela      As Character
    Local cTipo         As Character 
    Local cNatureza     As Character
    Local cCliente      As Character
    Local cLoja         As Character
    Local cHist         As Character
    Local cNomCli       As Character
    Local dEmissao      As Date 
    Local dVencto       As Date 
    Local dVenctoReal   As Date 
    Local nValor        As Numeric 


	Local cCode	     := "#200"
	Local cMessage	 := ''
    Local cResult    := ''
    Local cResultAux := ''
	Local lRet	     := .T.
    Local cVirgula   := ','

    Local cJson      := ::GetContent()
    Local oParser

    Private lMsErroAuto := .F.
    Private aVetSE1     := {}

	oBody  := JsonObject():New()

	If !FwJsonDeserialize(cJson,@oParser)
		cCode 		:= "#500"
		cMessage	:= "Formato Json nao reconhecido. Revisar a estrutura e layout informado."
		lRet		:= .F.
	Else

        RpcSetType(3)
        //RPCSetEnv('01','00020087')
        RPCSetEnv('00','00001000100')
        
        If lRet
            oBody  := JsonObject():New()
            oBody:fromJson(cJson) //oJsonIM:Body

            cTipOper    := oBody:getJsonText("TipoOperacao")
            cPrefixo	:= oBody:getJsonText("Prefixo")
            cTitulo     := oBody:getJsonText("Titulo")
            cParcela	:= oBody:getJsonText("Parcela")
            cTipo 	    := oBody:getJsonText("Tipo")
            cNatureza   := oBody:getJsonText("Natureza")
            cCliente    := oBody:getJsonText("Cliente")
            cLoja       := oBody:getJsonText("Loja")
            dEmissao    := oBody:getJsonText("Emissao")
            dVencto     := oBody:getJsonText("Vencto")
            dVenctoReal := oBody:getJsonText("Vencto_Real")
            nValor      := oBody:getJsonText("Valor")
            cHist       := oBody:getJsonText("Historico")

            If cTipOper == "1"
                
                
                DbSelectArea("SA1")
                DbSetOrder(1)
                If !Dbseek(xFilial("SA1")+Avkey(cCliente,"A1_COD")+Avkey(cLoja,"A1_LOJA"))
                    cCode 	 := "#400"
                    cMessage += "#erro_cliente "
                    cResultAux += '"cliente" : "'+"Cliente/Loja Inexistente ou nao informado"+'"'
                    lRet		:= .F.
                else
                    cNomCli := SA1->A1_NOME
                EndIf

                DbSelectArea("SED")
                DBSetOrder(1)
                If !Dbseek(xFilial("SED")+Avkey(cNatureza,"ED_CODIGO"))
                    cCode 	 := "#400"
                    cMessage += "#erro_natureza "
                    cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"natureza" : "'+"Natureza Inexistente ou nao informada"+'"'"
                    lRet		:= .F.
                EndIf

                DbSelectArea("SX5")
                DbSetOrder(1)
                If !Dbseek(xFilial("SX5")+"05"+Avkey(cTipo,"X5_CHAVE"))
                    cCode 	 := "#400"
                    cMessage += "#tipo_titulo "
                    cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"tipo" : "'+"Tipo de titulo Inexistente ou nao informada"+'"'"
                    lRet		:= .F.
                EndIf 
                
                If empty(ctod(dEmissao))
                    cCode 	 := "#400"
                    cMessage += "#erro_data_emissao "
                    cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"emissao" : "'+"Data de Emissao invalida"+'"'"
                    lRet		:= .F.
                EndIf 

                If empty(ctod(dVencto))
                    cCode 	 := "#400"
                    cMessage += "#erro_data_vencto "
                    cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"vencimento" : "'+"Data de Vencimento invalida"+'"'"
                    lRet		:= .F.
                EndIf

                If empty(ctod(dEmissao))
                    cCode 	 := "#400"
                    cMessage += "#erro_data_vencto_real "
                    cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"vencimento_real" : "'+"Data de Vencimento Real invalida"+'"'"
                    lRet		:= .F.
                EndIf

                dDtEm := datavalida(ctod(dEmissao))
                dDtVc := datavalida(ctod(dVencto))
                dDtVr := datavalida(ctod(dVenctoReal))
                
                If dDtVc < dDtEm .or. dDtVr < dDtEm .or. dDtVr < dDtVc
                    cCode 	 := "#400"
                    cMessage += "#erro_vencto_x_emissao "
                    cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"vencimento_x_emissao" : "'+"Data de Vencimento menor que a data de emissao ou Vencimento real menor que o Vencimento"+'"'"
                    lRet		:= .F.
                EndIf 

                If val(nValor) <= 0
                    cCode 	 := "#400"
                    cMessage += "#erro_valor "
                    cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"valor" : "'+"Valor informado invalido"+'"'"
                    lRet		:= .F.
                EndIf 

                DbSelectArea("SE1")
                DbSetOrder(1)
                If Dbseek(xFilial("SE1")+Avkey(cPrefixo,"E1_PREFIXO")+Avkey(cTitulo,"E1_NUM")+Avkey(cParcela,"E1_PARCELA")+Avkey(cTipo,"E1_TIPO"))
                    cCode 	 := "#400"
                    cMessage += "#titulo "
                    cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"titulo" : "'+"Este titulo ja se encontra na base de dados"+'"'"
                    lRet		:= .F.
                EndIf 

                If lRet
                    aVetSE1 := {}

                    aAdd(aVetSE1, {"E1_FILIAL",  FWxFilial("SE1"),  Nil})
                    aAdd(aVetSE1, {"E1_NUM",     cTitulo,           Nil})
                    aAdd(aVetSE1, {"E1_PREFIXO", cPrefixo,          Nil})
                    aAdd(aVetSE1, {"E1_PARCELA", cParcela,          Nil})
                    aAdd(aVetSE1, {"E1_TIPO",    cTipo,             Nil})
                    aAdd(aVetSE1, {"E1_NATUREZ", cNatureza,         Nil})
                    aAdd(aVetSE1, {"E1_CLIENTE", cCliente,          Nil})
                    aAdd(aVetSE1, {"E1_LOJA",    cLoja,             Nil})
                    aAdd(aVetSE1, {"E1_NOMCLI",  cNomCli,           Nil})
                    aAdd(aVetSE1, {"E1_EMISSAO", CTOD(dEmissao),    Nil})
                    aAdd(aVetSE1, {"E1_VENCTO",  CTOD(dVencto),     Nil})
                    aAdd(aVetSE1, {"E1_VENCREA", CTOD(dVenctoReal), Nil})
                    aAdd(aVetSE1, {"E1_VALOR",   VAL(nValor),       Nil})
                    //aAdd(aVetSE1, {"E1_VALJUR",  nValJuros,         Nil})
                    //aAdd(aVetSE1, {"E1_PORCJUR", nPorcJuros,        Nil})
                    aAdd(aVetSE1, {"E1_HIST",    cHist,             Nil})
                    aAdd(aVetSE1, {"E1_MOEDA",   1,                 Nil})
                    
                    //Inicia o controle de transação
                    Begin Transaction
                        //Chama a rotina automática
                        lMsErroAuto := .F.
                        MSExecAuto({|x,y| FINA040(x,y)}, aVetSE1, 3)
                        
                        //Se houve erro, mostra o erro ao usuário e desarma a transação
                        If lMsErroAuto
                            cResultAux := GetErro()
                            DisarmTransaction()
                        else
                            cMessage  += "sucesso "
                            cResultAux += '"sucesso" : "'+"Titulo gerado com sucesso!!!"+'"'"
                            cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"recno" : "'+"Recno nr. "+cvaltochar(Recno())+'"'"
                        EndIf
                    //Finaliza a transação
                    End Transaction
                EndIf 

            EndIf 
            
        EndIf

	EndIf

    cResult := '{'
    cResult += '"status" : {'
    cResult += '"code" : "'+cCode+'",'
    cResult += '"message" : "'+cMessage+'"'
    cResult += '},'
    cResult += '"result" : {'
    cResult += cResultAux
    cResult += '}'
    cResult += '}'

    ::SetContentType('application/json')
    ::SetResponse(cResult)

	RpcClearEnv()

Return lRet


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
