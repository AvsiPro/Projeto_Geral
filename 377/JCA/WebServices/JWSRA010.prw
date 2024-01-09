#Include 'Protheus.ch'
#Include 'RestFul.ch'
#Include "FwMvcDef.ch"
/*
    API
    Api de criação, alteração e exclusão de titulos vindos do Tracker

    MIT010 - Validação integracao Tracker x Protheus- 17112023

    Doc Mit
    https://docs.google.com/document/d/1CwjfS34PgB-FUvuLgjWIiNG90xdgbbcb2eF2--mJ38U/edit
    Doc Validação entrega
    
    
    
*/

User Function JWSRA010()

Return

WsRestFul JWSRA010 DESCRIPTION "API REST - Evento Cadastro de Titulos" 
	
	WsMethod POST Description "API REST - Evento Cadastro de Titulos - METODO POST "  WsSyntax "JWSRA010"

End WsRestFul


WsMethod POST WsReceive RECEIVE WsService JWSRA010

    Local cFilMov       As Character
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
    Local aTitImp    := {}
    Local aAuxImp    := {}
    Local keyType    := ""
    Local lTitImp    := .F.
    Local nCont      := 0   
    Local nX         := 0
    Local cTitPai    := ''
    Local lBaixaTt   := .F.
    Local nMulta     := 0
    Local nJuros     := 0
    Local nDesconto  := 0
    Local aObrig1    := {'Filial','Prefixo','Titulo','Parcela','Tipo','Cliente','Emissao','Vencto','Valor'}
    Local aObrig2    := {'Filial','Prefixo','Titulo','Parcela','Tipo'}
    Local aObrig3    := {'Filial','Prefixo','Titulo','Parcela','Tipo'}

    Private lMsErroAuto := .F.
    Private aVetSE1     := {}

	oBody  := JsonObject():New()

	If !FwJsonDeserialize(cJson,@oParser)
		cCode 		:= "#500"
		cMessage	:= "Formato Json nao reconhecido. Revisar a estrutura e layout informado."
		lRet		:= .F.
	Else

        RpcSetType(3)
        RPCSetEnv('01','00020087')
        
        If lRet
            oBody  := JsonObject():New()
            oBody:fromJson(cJson) //oJsonIM:Body

            cTipOper    := oBody:getJsonText("TipoOperacao")
            cFilMov     := oBody:getJsonText("Filial")
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

            nMulta      := oBody:getJsonText("Multa")
            nJuros      := oBody:getJsonText("Juros")
            nDesconto   := oBody:getJsonText("Desconto")

            If cTipOper == "1"
                For nCont := 1 to len(aObrig1)
                    lOk := oBody:hasProperty(aObrig1[nCont])
                    If !lOk
                        cCode 	 := "#400"
                        cMessage += "#erro_cliente "
                        cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"campo_obrigatorio" : "'+"Campo nao informado "+aObrig1[nCont]+'"'
                    EndIf 
                Next nCont
            ElseIf cTipOper == "2"
                For nCont := 1 to len(aObrig2)
                    lOk := oBody:hasProperty(aObrig2[nCont])
                    If !lOk
                        cCode 	 := "#400"
                        cMessage += "#erro_cliente "
                        cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"campo_obrigatorio" : "'+"Campo nao informado "+aObrig2[nCont]+'"'
                    EndIf
                Next nCont
            ElseIf cTipOper == "3"
                For nCont := 1 to len(aObrig3)
                    lOk := oBody:hasProperty(aObrig3[nCont])
                    If !lOk
                        cCode 	 := "#400"
                        cMessage += "#erro_cliente "
                        cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"campo_obrigatorio" : "'+"Campo nao informado "+aObrig3[nCont]+'"'
                    EndIf
                Next nCont    
            Endif 

            cFilant := cFilMov

            If cTipOper $ "1/2"
                lTitImp := oBody:GetJsonValue("Impostos", @aTitImp,  @keyType)

                DbSelectArea("SA1")
                DbSetOrder(1)
                If !Dbseek(xFilial("SA1")+Avkey(cCliente,"A1_COD")+Avkey(cLoja,"A1_LOJA"))
                    cCode 	 := "#400"
                    cMessage += "#erro_cliente "
                    cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"cliente" : "'+"Cliente/Loja Inexistente ou nao informado"+'"'
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
                    lRet	:= .F.
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
            EndIf

            If lTitImp .And. keyType == "A"

                cTitPai := Avkey(cPrefixo,"E1_PREFIXO")+Avkey(cTitulo,"E1_NUM")+Avkey(cParcela,"E1_PARCELA")+Avkey(cTipo,"E1_TIPO")+Avkey(cCliente,"E1_CLIENTE")+Avkey(cLoja,"E1_LOJA")

                For nCont := 1 to len(aTitImp)
                    aAux := {}

                    lBaixaTt := upper(aTitImp[nCont]:getJsonText("Retido_Por")) == "CLIENTE"

                    If !Empty(aTitImp[nCont]:getJsonText("Tipo_Imposto"))
                        Aadd(aAux,{"E1_TIPO",substr(aTitImp[nCont]:getJsonText("Tipo_Imposto"),1,2)+'-',Nil})
                        //Aadd(aAux,{"E1_PREFIXO",aTitImp[nCont]:getJsonText("Tipo_Imposto"),Nil})
                    Else 
                        cCode 	 := "#400"
                        cMessage += "#Tipo_Titulo_imposto "
                        cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"tipo_titulo" : "'+"Tipo de titulo de imposto invalido"+'"'"
                        lRet		:= .F.
                    EndIf

                    If !Empty(ctod(aTitImp[nCont]:getJsonText("Emissao")))
                        Aadd(aAux,{"E1_EMISSAO",ctod(aTitImp[nCont]:getJsonText("Emissao")),Nil})
                    Else 
                        cCode 	 := "#400"
                        cMessage += "#erro_data_emissao_imposto "
                        cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"emissao" : "'+"Data de Emissao do titulo de imposto invalida"+'"'"
                        lRet		:= .F.
                    EndIf

                    If !Empty(ctod(aTitImp[nCont]:getJsonText("Vencto")))
                        Aadd(aAux,{"E1_VENCTO",ctod(aTitImp[nCont]:getJsonText("Vencto")),Nil})
                    Else 
                        cCode 	 := "#400"
                        cMessage += "#erro_data_vencto_imposto "
                        cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"vencimento" : "'+"Data de Vencimento do titulo de imposto invalida"+'"'"
                        lRet		:= .F.
                    EndIf

                    If !Empty(ctod(aTitImp[nCont]:getJsonText("Vencto_Real")))
                        Aadd(aAux,{"E1_VENCREA",ctod(aTitImp[nCont]:getJsonText("Vencto_Real")),Nil})
                    Else 
                        cCode 	 := "#400"
                        cMessage += "#erro_data_vencto_real_imposto "
                        cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"vencimento_real" : "'+"Data de Vencimento Real do titulo de imposto invalida"+'"'"
                        lRet		:= .F.
                    EndIf

                    If val(aTitImp[nCont]:getJsonText("Valor")) > 0 .And. val(aTitImp[nCont]:getJsonText("Valor")) < val(nValor)
                        Aadd(aAux,{"E1_VALOR",val(aTitImp[nCont]:getJsonText("Valor")),Nil})
                    Else 
                        cCode 	 := "#400"
                        cMessage += "#erro_valor "
                        cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"valor" : "'+"Valor do titulo de imposto invalido"+'"'"
                        lRet		:= .F.
                    EndIf

                    If !Empty(aTitImp[nCont]:getJsonText("Historico"))
                        Aadd(aAux,{"E1_HIST",aTitImp[nCont]:getJsonText("Historico"),Nil})
                    Else 
                        Aadd(aAux,{"E1_HIST","",Nil})
                    EndIf

                    If lRet 
                        Aadd(aAuxImp,aAux)
                    EndIf

                Next nCont
            EndIf 

            aVetSE1 := {}

            aAdd(aVetSE1, {"E1_FILIAL",  cFilMov,  Nil})
            aAdd(aVetSE1, {"E1_NUM",     cTitulo,           Nil})
            aAdd(aVetSE1, {"E1_PREFIXO", Avkey(cPrefixo,"E1_PREFIXO"),          Nil})
            aAdd(aVetSE1, {"E1_PARCELA", Avkey(cParcela,"E1_PARCELA"),          Nil})
            aAdd(aVetSE1, {"E1_TIPO",    Avkey(cTipo,"E1_TIPO")      ,          Nil})
            
            aAdd(aVetSE1, {"E1_CLIENTE", cCliente,          Nil})
            aAdd(aVetSE1, {"E1_LOJA",    cLoja,             Nil})

            If cTipOper <> '3'
                aAdd(aVetSE1, {"E1_NOMCLI",  cNomCli,           Nil})
                
                aAdd(aVetSE1, {"E1_NATUREZ", cNatureza,         Nil})
                
                aAdd(aVetSE1, {"E1_EMISSAO", CTOD(dEmissao),    Nil})
                aAdd(aVetSE1, {"E1_VENCTO",  CTOD(dVencto),     Nil})
                aAdd(aVetSE1, {"E1_VENCREA", CTOD(dVenctoReal), Nil})
                aAdd(aVetSE1, {"E1_VALOR",   VAL(nValor),       Nil})
                aAdd(aVetSE1, {"E1_HIST",    cHist,             Nil})
                aAdd(aVetSE1, {"E1_MOEDA",   1,                 Nil})
            EndIf 

            If nMulta <> 'null'
                aAdd(aVetSE1, {"E1_VALJUR",  val(nMulta),         Nil})
            EndIF 

            If nJuros <> 'null'
                aAdd(aVetSE1, {"E1_ACRESC",  val(nJuros),         Nil})
            EndIF

            If nDesconto <> 'null'
                aAdd(aVetSE1, {"E1_DECRESC", val(nDesconto),      Nil})
            EndIF  

            If cTipOper == "1"
               
                DbSelectArea("SE1")
                DbSetOrder(1)
                If Dbseek(Avkey(cFilMov,"E1_FILIAL")+Avkey(cPrefixo,"E1_PREFIXO")+Avkey(cTitulo,"E1_NUM")+Avkey(cParcela,"E1_PARCELA")+Avkey(cTipo,"E1_TIPO"))
                    cCode 	 := "#400"
                    cMessage += "#titulo "
                    cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"titulo" : "'+"Este titulo ja se encontra na base de dados"+'"'"
                    lRet		:= .F.
                EndIf 

                If lRet
                    //Inicia o controle de transação
                    Begin Transaction
                    //Chama a rotina automática
                    lMsErroAuto := .F.
                    MSExecAuto({|x,y| FINA040(x,y)}, aVetSE1, 3)
                    
                    //Se houve erro, mostra o erro ao usuário e desarma a transação
                    If lMsErroAuto
                        cCode 	 := "#400"
                        cMessage  := "falha "
                        cResultAux := GetErro()
                        DisarmTransaction()
                    else
                        cMessage  += "sucesso "
                        cResultAux += '"sucesso" : "'+"Titulo gerado com sucesso!!!"+'"'"
                        cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"recno" : "'+"Recno nr. "+cvaltochar(Recno())+'"'"
                    EndIf    

                    //Finaliza a transação
                    End Transaction

                    //Titulo de imposto
                    If lTitImp .And. len(aAuxImp) > 0
                        For nCont := 1 to len(aAuxImp)
                            For nX := 1 to len(aAuxImp[nCont])
                                nPosAux := Ascan(aVetSE1,{|x| x[1] == aAuxImp[nCont,nX,01] })
                                If nPosAux > 0
                                    aVetSE1[nPosAux,02] := aAuxImp[nCont,nX,02]
                                EndIf
                            Next nX
                        Next nCont

                        aAdd(aVetSE1, {"E1_TITPAI",cTitPai,Nil})
                        
                        DbSelectArea("SE1")
                        Reclock("SE1",.T.)

                        SE1->E1_FILIAL := CFILANT

                        For nCont := 1 to len(aVetSE1)
                            &("SE1->"+aVetSE1[nCont,01]) := aVetSE1[nCont,02]
                        Next nCont

                        If lBaixaTt
                            SE1->E1_BAIXA := SE1->E1_VENCREA
                        Else 
                            SE1->E1_SALDO := SE1->E1_VALOR 
                        EndIF 

                        SE1->(Msunlock())

                        cMessage  += "sucesso "
                        cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"sucesso" : "'+"Titulo de imposto gerado com sucesso!!!"+'"'"
                        cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"recno" : "'+"Recno nr. "+cvaltochar(Recno())+'"'"
                    
                        
                    EndIf 
                        
                EndIf 
            ElseIf cTipOper == "2"
                DbSelectArea("SE1")
                DbSetOrder(1)
                If !Dbseek(Avkey(cFilMov,"E1_FILIAL")+Avkey(cPrefixo,"E1_PREFIXO")+Avkey(cTitulo,"E1_NUM")+Avkey(cParcela,"E1_PARCELA")+Avkey(cTipo,"E1_TIPO"))
                    cCode 	 := "#400"
                    cMessage += "#titulo "
                    cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"titulo" : "'+"Este titulo não se encontra na base de dados"+'"'"
                    lRet		:= .F.
                EndIf

                If lRet
                    //Inicia o controle de transação
                    Begin Transaction
                    //Chama a rotina automática
                    lMsErroAuto := .F.
                    MSExecAuto({|x,y| FINA040(x,y)}, aVetSE1, 4)
                    
                    //Se houve erro, mostra o erro ao usuário e desarma a transação
                    If lMsErroAuto
                        cCode 	 := "#400"
                        cMessage  := "falha "
                        cResultAux := GetErro()
                        DisarmTransaction()
                    else
                        cMessage  += "sucesso "
                        cResultAux += '"sucesso" : "'+"Titulo alterado com sucesso!!!"+'"'"
                        cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"recno" : "'+"Recno nr. "+cvaltochar(Recno())+'"'"
                    EndIf    

                    //Finaliza a transação
                    End Transaction
                EndIf
            ElseIf cTipOper == "3"
                DbSelectArea("SE1")
                DbSetOrder(1)
                If !Dbseek(Avkey(cFilMov,"E1_FILIAL")+Avkey(cPrefixo,"E1_PREFIXO")+Avkey(cTitulo,"E1_NUM")+Avkey(cParcela,"E1_PARCELA")+Avkey(cTipo,"E1_TIPO"))
                    cCode 	 := "#400"
                    cMessage += "#titulo "
                    cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"titulo" : "'+"Este titulo nao se encontra na base de dados"+'"'"
                    lRet		:= .F.
                EndIf

                If lRet
                    Dbseek(Avkey(cFilMov,"E1_FILIAL")+Avkey(cPrefixo,"E1_PREFIXO")+Avkey(cTitulo,"E1_NUM")+Avkey(cParcela,"E1_PARCELA")+Avkey(cTipo,"E1_TIPO"))
                    /*While !EOF() .AND. SE1->E1_FILIAL == Avkey(cFilMov,"E1_FILIAL") .AND. SE1->E1_PREFIXO == Avkey(cPrefixo,"E1_PREFIXO") .AND. SE1->E1_NUM == Avkey(cTitulo,"E1_NUM") .AND. SE1->E1_PARCELA == Avkey(cParcela,"E1_PARCELA") .AND. SE1->E1_CLIENTE == cCliente
                        Reclock("SE1",.F.)
                        SE1->(DbDelete())
                        SE1->(Msunlock())
                        Dbskip()
                    EndDo*/ 
                    //Inicia o controle de transação
                    Begin Transaction
                    //Chama a rotina automática
                    lMsErroAuto := .F.
                    MSExecAuto({|x,y| FINA040(x,y)}, aVetSE1, 5)
                    
                    //Se houve erro, mostra o erro ao usuário e desarma a transação
                    If lMsErroAuto
                        cCode 	 := "#400"
                        cMessage  := "falha "
                        cResultAux := GetErro()
                        DisarmTransaction()
                    else
                        cMessage  += "sucesso "
                        cResultAux += '"sucesso" : "'+"Titulo alterado com sucesso!!!"+'"'"
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
