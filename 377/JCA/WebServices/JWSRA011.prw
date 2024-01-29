#Include 'Protheus.ch'
#Include 'RestFul.ch'
#Include "FwMvcDef.ch"
/*
    API
    Api de criação, alteração e exclusão de movimentos bancários vindos do Tracker

    MIT010 - Validação integracao Tracker x Protheus- 301123

    Doc Mit
    https://docs.google.com/document/d/1_In9fPnJO8Jq6myqN0So5MlXF_oQdFu0EXO2CVcnDiU/edit
    Doc Validação entrega
    
    
    
*/

User Function JWSRA011()

Return

WsRestFul JWSRA011 DESCRIPTION "API REST - Evento Cadastro de Movimentos Bancarios" 
	
	WsMethod POST Description "API REST - Evento Cadastro de Movimentos Bancarios - METODO POST "  WsSyntax "JWSRA011"

End WsRestFul


WsMethod POST WsReceive RECEIVE WsService JWSRA011

    Local cFilMov       As Character
    Local cTipOper      As Character
    Local dDataMov  	As Date 
	Local cMoeda		As Character
    Local nValor        As Numeric 
    Local cNatureza     As Character
    Local cBanco        As Character
    Local cAgencia      As Character
    Local cConta        As Character
    
    Local cCliente      As Character
    Local cLoja         As Character
    Local cHist         As Character
    Local cNomCli       As Character
    Local dEmissao      As Date 
    Local dVencto       As Date 
    Local dVenctoReal   As Date 
    
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
    Local lTitSE5    := .F.
    Local nCont      := 0   
    Local nX         := 0
    Local cTitPai    := ''
    Local lBaixaTt   := .F.
    
    Local aObrig1    := {'Filial','Data_Movimento','Moeda','Valor','Natureza','Banco','Agencia','Conta'}
    //Local aObrig2    := {'Filial','Prefixo','Titulo','Parcela','Tipo'}
    //Local aObrig3    := {'Filial','Prefixo','Titulo','Parcela','Tipo'}

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
            oBody:fromJson(cJson) 

            cTipOper    := oBody:getJsonText("TipoOperacao")
            
            lTitSE5     := oBody:GetJsonValue("Titulos", @aTitImp,  @keyType)
            
            If !lTitSE5
                cCode 	 := "#400"
                cMessage += "#erro_json "
                cResultAux += "Não foi informado os titulos no json para carga dos dados"
                lRet		:= .F.
            EndIf 
                         
            For nCont := 1 to len(aTitImp)
                cFilMov     := aTitImp[nCont]:getJsonText("Filial")
                dDataMov	:= aTitImp[nCont]:getJsonText("Data_Movimento")
                cMoeda      := aTitImp[nCont]:getJsonText("Moeda")
                cNatureza   := aTitImp[nCont]:getJsonText("Natureza")
                nValor      := aTitImp[nCont]:getJsonText("Valor")
                cBanco      := aTitImp[nCont]:getJsonText("Banco")
                cAgencia    := aTitImp[nCont]:getJsonText("Agencia")
                cConta      := aTitImp[nCont]:getJsonText("Conta")
                cCliente    := aTitImp[nCont]:getJsonText("Cliente")
                cLoja       := aTitImp[nCont]:getJsonText("Loja")
                cHist       := aTitImp[nCont]:getJsonText("Historico")

                
                If len(cCliente) > 6
                    DbSelectArea("SA1")
                    DbSetOrder(3)
                    If Dbseek(xFilial("SA1")+cCliente)
                        cCliente := SA1->A1_COD 
                        cLoja    := SA1->A1_LOJA
                    EndIF 
                EndIf 
                

                If cTipOper == "1"
                    For nCont := 1 to len(aObrig1)
                        lOk := aTitImp[nCont]:hasProperty(aObrig1[nCont])
                        If !lOk
                            cCode 	 := "#400"
                            cMessage += "#erro_cliente "
                            cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"campo_obrigatorio" : "'+"Campo nao informado "+aObrig1[nCont]+'"'
                        EndIf 
                    Next nCont
                /*ElseIf cTipOper == "2"
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
                    Next nCont */   
                Endif 

                cFilant := cFilMov

                If cTipOper $ "1/2"

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

                aVetSE1 := {}

                aAdd(aVetSE1, {"E1_FILIAL",  cFilMov,  Nil})
                aAdd(aVetSE1, {"E1_NUM",     cMoeda,           Nil})
                aAdd(aVetSE1, {"E1_PREFIXO", Avkey(dDataMov,"E1_PREFIXO"),          Nil})
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

                

                If cTipOper == "1"
                
                    DbSelectArea("SE1")
                    DbSetOrder(1)
                    If Dbseek(Avkey(cFilMov,"E1_FILIAL")+Avkey(dDataMov,"E1_PREFIXO")+Avkey(cMoeda,"E1_NUM")+Avkey(cParcela,"E1_PARCELA")+Avkey(cTipo,"E1_TIPO"))
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
                            cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"sucesso" : "'+"Titulo gerado com sucesso!!!"+'"'"
                            cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"recno" : "'+"Recno nr. "+cvaltochar(Recno())+'"'"
                        EndIf    

                        //Finaliza a transação
                        End Transaction

                        //Titulo de imposto
                        If lTitSE5 .And. len(aAuxImp) > 0 .And. lBaixaTt
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

                            /*If lBaixaTt
                                SE1->E1_BAIXA := SE1->E1_VENCREA
                            Else */
                                SE1->E1_SALDO := SE1->E1_VALOR 
                            //EndIF 

                            SE1->(Msunlock())

                            cMessage  += "sucesso "
                            cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"sucesso" : "'+"Titulo de imposto gerado com sucesso!!!"+'"'"
                            cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"recno" : "'+"Recno nr. "+cvaltochar(Recno())+'"'"
                        
                        Else
                            
                            
                            For nCont := 1 to len(aAuxImp)

                                nPos1 := Ascan(aAuxImp[nCont],{|x| x[1] == "E2_PREFIXO"})
                                nPos2 := Ascan(aAuxImp[nCont],{|x| x[1] == "E2_TIPO"})
                                nPos3 := Ascan(aAuxImp[nCont],{|x| x[1] == "E2_FORNECE"})
                                nPos4 := Ascan(aAuxImp[nCont],{|x| x[1] == "E2_LOJA"})
                                nPos5 := Ascan(aAuxImp[nCont],{|x| x[1] == "E2_VALOR"})

                                aVetSE2 := {}
                            //aAuxImp
                            
                                aAdd(aVetSE2, {"E2_FILIAL"  , cFilMov                   ,   Nil})
                                aAdd(aVetSE2, {"E2_NUM"     , cMoeda                   ,   Nil})
                                aAdd(aVetSE2, {"E2_PREFIXO" , aAuxImp[nCont,nPos1,02]   ,   Nil})
                                aAdd(aVetSE2, {"E2_PARCELA" , cParcela                  ,   Nil})
                                aAdd(aVetSE2, {"E2_TIPO"    , aAuxImp[nCont,nPos2,02]   ,   Nil})
                                aAdd(aVetSE2, {"E2_FORNECE" , aAuxImp[nCont,nPos3,02]   ,   Nil})
                                aAdd(aVetSE2, {"E2_LOJA"    , aAuxImp[nCont,nPos4,02]   ,   Nil})
                                aAdd(aVetSE2, {"E2_NATUREZ" , aAuxImp[nCont,nPos1,02]   ,   Nil})
                                aAdd(aVetSE2, {"E2_EMISSAO" , dDataBase                 ,   Nil})
                                aAdd(aVetSE2, {"E2_VENCTO"  , CTOD(dVencto)             ,   Nil})
                                aAdd(aVetSE2, {"E2_VENCREA" , CTOD(dVenctoReal)         ,   Nil})
                                aAdd(aVetSE2, {"E2_VALOR"   , aAuxImp[nCont,nPos5,02]   ,   Nil})
                                aAdd(aVetSE2, {"E2_MOEDA"   , 1                         ,   Nil})

                                lMsErroAuto := .F.

                                MSExecAuto({|x,y| FINA050(x,y)}, aVetSE2, 3)
                                                            
                                If lMsErroAuto
                                    cCode 	 := "#400"
                                    cMessage  := "falha "
                                    cResultAux := GetErro()
                                    DisarmTransaction()
                                else
                                    cMessage  += "sucesso "
                                    cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"sucesso" : "'+"Titulo de imposto a pagar gerado com sucesso!!!"+'"'"
                                    cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"recno" : "'+"Recno nr. "+cvaltochar(Recno())+'"'"
                                EndIf    
    
                            Next nCont 
                        EndIf 
                            
                    EndIf 
                ElseIf cTipOper == "2"
                    DbSelectArea("SE1")
                    DbSetOrder(1)
                    If !Dbseek(Avkey(cFilMov,"E1_FILIAL")+Avkey(dDataMov,"E1_PREFIXO")+Avkey(cMoeda,"E1_NUM")+Avkey(cParcela,"E1_PARCELA")+Avkey(cTipo,"E1_TIPO"))
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
                    If !Dbseek(Avkey(cFilMov,"E1_FILIAL")+Avkey(dDataMov,"E1_PREFIXO")+Avkey(cMoeda,"E1_NUM")+Avkey(cParcela,"E1_PARCELA")+Avkey(cTipo,"E1_TIPO"))
                        cCode 	 := "#400"
                        cMessage += "#titulo "
                        cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"titulo" : "'+"Este titulo nao se encontra na base de dados"+'"'"
                        lRet		:= .F.
                    EndIf

                    If lRet
                        Dbseek(Avkey(cFilMov,"E1_FILIAL")+Avkey(dDataMov,"E1_PREFIXO")+Avkey(cMoeda,"E1_NUM")+Avkey(cParcela,"E1_PARCELA")+Avkey(cTipo,"E1_TIPO"))
                        
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
            Next nCont
            
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
