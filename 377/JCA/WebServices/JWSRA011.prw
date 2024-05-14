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
    Local cTitulo       As Character
    Local cPrefixo      As Character
    Local cParcela      As Character
    Local cCliente      As Character
    Local cLoja         As Character
    Local cHist         As Character
    Local cNomCli       As Character
    Local cTipo         As Character
    Local cMovimento    As Character
    Local nRecEnv       As Numeric

	Local cCode	     := "#200"
	Local cMessage	 := ''
    Local cResult    := ''
    Local cResultAux := ''
	Local lRet	     := .T.
    Local cVirgula   := ','

    Local cJson      := ::GetContent()
    Local oParser
    Local aTitImp    := {}
    Local keyType    := ""
    Local lTitSE5    := .F.
    Local nCont      := 0   
    Local nX         := 0
    
    Local aObrig1    := {'Filial','Data_Movimento','Moeda','Valor','Natureza','Banco','Agencia','Conta'}
    Local aObrig2    := {'Recno'}
    Local aObrig3    := {'Recno'}

    Private lMsErroAuto := .F.
    Private aVetSE5     := {}

	oBody  := JsonObject():New()

	If !FwJsonDeserialize(cJson,@oParser)
		cCode 		:= "#500"
		cMessage	:= "Formato Json nao reconhecido. Revisar a estrutura e layout informado."
		lRet		:= .F.
	Else

        RpcSetType(3)
        RPCSetEnv('01','00020087')
        //RPCSetEnv('T1','D MG 01')
        
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
                cMovimento	:= aTitImp[nCont]:getJsonText("Movimento")
                cMoeda      := aTitImp[nCont]:getJsonText("Moeda")
                cNatureza   := aTitImp[nCont]:getJsonText("Natureza")
                nValor      := aTitImp[nCont]:getJsonText("Valor")
                cBanco      := aTitImp[nCont]:getJsonText("Banco")
                cAgencia    := aTitImp[nCont]:getJsonText("Agencia")
                cConta      := aTitImp[nCont]:getJsonText("Conta")
                cCliente    := aTitImp[nCont]:getJsonText("Cliente")
                cLoja       := aTitImp[nCont]:getJsonText("Loja")
                cTipo       := aTitImp[nCont]:getJsonText("Tipo")
                cTitulo     := aTitImp[nCont]:getJsonText("Titulo")
                cParcela    := aTitImp[nCont]:getJsonText("Parcela")
                cPrefixo    := aTitImp[nCont]:getJsonText("Prefixo")
                cHist       := aTitImp[nCont]:getJsonText("Historico")
                nRecEnv     := aTitImp[nCont]:getJsonText("Recno")
                
                If len(cCliente) > 6
                    DbSelectArea("SA1")
                    DbSetOrder(3)
                    If Dbseek(xFilial("SA1")+cCliente)
                        cCliente := SA1->A1_COD 
                        cLoja    := SA1->A1_LOJA
                    Else 
                        cCliente := SuperGetMV("TI_CLIPAD",.F.,"999999")
                        cLoja    := "01"
                    EndIF 
                EndIf 
                
                DbSelectArea("SE5")
                DbSetOrder(10)
                If Dbseek(Avkey(cFilMov,"E5_FILIAL")+Avkey(cTitulo,"E5_DOCUMEN"))
                    cCode 	 := "#400"
                    cMessage += "#erro_titulo "
                    cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"titulo_duplicado" : "'+"Titulo ja esta na base "+cTitulo+'"'
                    lRet := .F.
                EndIf 


                If cTipOper == "1"
                    For nX := 1 to len(aObrig1)
                        lOk := aTitImp[nCont]:hasProperty(aObrig1[nX])
                        If !lOk
                            cCode 	 := "#400"
                            cMessage += "#erro_cliente "
                            cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"campo_obrigatorio" : "'+"Campo nao informado "+aObrig1[nX]+'"'
                        EndIf 
                    Next nX
                ElseIf cTipOper == "2"
                    For nX := 1 to len(aObrig2)
                        lOk := aTitImp[nCont]:hasProperty(aObrig2[nX])
                        If !lOk
                            cCode 	 := "#400"
                            cMessage += "#erro_cliente "
                            cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"campo_obrigatorio" : "'+"Campo nao informado "+aObrig2[nX]+'"'
                        EndIf
                    Next nX
                ElseIf cTipOper == "3"
                    For nX := 1 to len(aObrig3)
                        lOk := aTitImp[nCont]:hasProperty(aObrig3[nX])
                        If !lOk
                            cCode 	 := "#400"
                            cMessage += "#erro_cliente "
                            cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"campo_obrigatorio" : "'+"Campo nao informado "+aObrig3[nX]+'"'
                        EndIf
                    Next nX    
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

                    If !Empty(cTipo)
                        DbSelectArea("SX5")
                        DbSetOrder(1)
                        If !Dbseek(xFilial("SX5")+"05"+Avkey(cTipo,"X5_CHAVE"))
                            cCode 	 := "#400"
                            cMessage += "#tipo_titulo "
                            cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"tipo" : "'+"Tipo de titulo Inexistente ou nao informada"+'"'"
                            lRet		:= .F.
                        EndIf 
                    Endif 
                    
                    If empty(ctod(dDataMov))
                        cCode 	 := "#400"
                        cMessage += "#erro_data_emissao "
                        cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"emissao" : "'+"Data de Emissao invalida"+'"'"
                        lRet		:= .F.
                    EndIf 

                    dDtEm := datavalida(ctod(dDataMov))
                                        
                    If val(nValor) <= 0
                        cCode 	 := "#400"
                        cMessage += "#erro_valor "
                        cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"valor" : "'+"Valor informado invalido"+'"'"
                        lRet		:= .F.
                    EndIf
                Else 
                    If val(nRecEnv) <= 0
                        cCode 	 := "#400"
                        cMessage += "#erro_renoc "
                        cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"recno" : "'+"Nao foi informado o Recno da transacao"+'"'"
                        lRet		:= .F.
                    EndIf  
                EndIf

                aVetSE5 := {}
                //cMovimento
                aAdd(aVetSE5, {"E5_FILIAL"  , cFilMov                     ,  Nil})
                aAdd(aVetSE5, {"E5_MOEDA"   , cMoeda                      ,  Nil})
                aAdd(aVetSE5, {"E5_DATA"    , ctod(dDataMov)              ,  Nil})
                aAdd(aVetSE5, {"E5_VALOR"   , val(nValor)                 ,  Nil})
                aAdd(aVetSE5, {"E5_NATUREZ" , cNatureza                   ,  Nil})
                aAdd(aVetSE5, {"E5_BANCO"   , cBanco                      ,  Nil})
                aAdd(aVetSE5, {"E5_AGENCIA" , cAgencia                    ,  Nil})
                aAdd(aVetSE5, {"E5_CONTA"   , cConta                      ,  Nil})
                
                If !Empty(cCliente) .And. cCliente <> 'null'                    
                    aAdd(aVetSE5, {"E5_CLIFOR"  , cCliente                    ,  Nil})
                ENDIF

                If !Empty(cLoja) .And. cLoja <> 'null'
                    aAdd(aVetSE5, {"E5_LOJA"    , cLoja                       ,  Nil})
                EndIf 

                If !Empty(cHist) .And. cHist <> 'null'
                    aAdd(aVetSE5, {"E5_HISTOR"  , cHist                       ,  Nil})
                EndIf 

                If !Empty(cNomCli) .And. cNomCli <> 'null'
                    aAdd(aVetSE5, {"E5_BENEF"   , cNomCli                     ,  Nil})
                EndIf 
                
                If !Empty(cParcela) .And. cParcela <> 'null'
                    aAdd(aVetSE5, {"E5_PARCELA" , Avkey(cParcela,"E5_PARCELA"),  Nil})
                EndIf 

                If !Empty(cTipo) .And. cTipo <> 'null'
                    aAdd(aVetSE5, {"E5_TIPO"    , Avkey(cTipo,"E5_TIPO")      ,  Nil})
                Endif 
                
                If !Empty(cPrefixo) .And. cPrefixo <> 'null'
                    aAdd(aVetSE5, {"E5_PREFIXO" , Avkey(cPrefixo,"E5_PREFIXO"),  Nil})
                EndIf 

                If !Empty(cTitulo) .And. cTitulo <> 'null'
                    aAdd(aVetSE5, {"E5_NUMERO"  , Avkey(cTitulo,"E5_NUMERO")    ,  Nil})
                    aAdd(aVetSE5, {"E5_DOCUMEN" , Avkey(cTitulo,"E5_DOCUMEN")   ,  Nil})
                EndIf 
                
                If cTipOper == "1"
                
                    /*DbSelectArea("SE1")
                    DbSetOrder(1)
                    If Dbseek(Avkey(cFilMov,"E1_FILIAL")+Avkey(dDataMov,"E1_PREFIXO")+Avkey(cMoeda,"E1_NUM")+Avkey(cParcela,"E1_PARCELA")+Avkey(cTipo,"E1_TIPO"))
                        cCode 	 := "#400"
                        cMessage += "#titulo "
                        cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"titulo" : "'+"Este titulo ja se encontra na base de dados"+'"'"
                        lRet		:= .F.
                    EndIf */

                    If lRet
                        //Inicia o controle de transação
                        Begin Transaction
                        //Chama a rotina automática
                        lMsErroAuto := .F.
                        MSExecAuto({|x,y,z| FINA100(x,y,z)},0, aVetSE5, 4)
                        

                        //Se houve erro, mostra o erro ao usuário e desarma a transação
                        If lMsErroAuto
                            cCode 	 := "#400"
                            cMessage  := "falha "
                            cResultAux := GetErro()
                            DisarmTransaction()
                        else
                            cMessage  += "sucesso "
                            cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"'+cvaltochar(nCont)+'.sucesso" : "'+"Titulo gerado com sucesso!!!"+'"'"
                            cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"'+cvaltochar(nCont)+'.recno" : "'+"Recno nr. "+cvaltochar(SE5->(Recno()))+'"'"
                        EndIf    

                        //Finaliza a transação
                        End Transaction

                            
                    EndIf 
                ElseIf cTipOper == "2"
                    DbSelectArea("SE5")
                    DbGoto(val(nRecEnv))
                    If SE5->(Recno()) <> val(nRecEnv)
                        cCode 	 := "#400"
                        cMessage += "#recno "
                        cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"recno" : "'+"Recno não encontrado"+'"'"
                        lRet		:= .F.
                    EndIf

                    /*DbSetOrder(1)
                    If !Dbseek(Avkey(cFilMov,"E1_FILIAL")+Avkey(dDataMov,"E1_PREFIXO")+Avkey(cMoeda,"E1_NUM")+Avkey(cParcela,"E1_PARCELA")+Avkey(cTipo,"E1_TIPO"))
                        cCode 	 := "#400"
                        cMessage += "#titulo "
                        cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"titulo" : "'+"Este titulo não se encontra na base de dados"+'"'"
                        lRet		:= .F.
                    EndIf*/

                    If lRet
                        DbGoto(val(nRecEnv))
                        Reclock("SE5",.F.)
                        For nX := 1 to len(aVetSE5)
                            &("SE5->"+aVetSE5[nX,01]) := aVetSE5[nX,02]
                        Next nX 

                        SE5->(Msunlock())

                        cMessage  += "sucesso "
                        cResultAux += '"sucesso" : "'+"Titulo alterado com sucesso!!!"+'"'"
                        cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"recno" : "'+"Recno nr. "+cvaltochar(Recno())+'"'"
                    
                        /*
                        //Inicia o controle de transação
                        Begin Transaction
                        //Chama a rotina automática
                        lMsErroAuto := .F.
                        MSExecAuto({|x,y,z| FINA100(x,y,z)}, 0, aVetSE5, 4)
                        
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
                        End Transaction*/
                    EndIf
                ElseIf cTipOper == "3"

                    DbSelectArea("SE5")
                    DbGoto(val(nRecEnv))

                    If SE5->(Recno()) <> val(nRecEnv)
                        cCode 	 := "#400"
                        cMessage += "#recno "
                        cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"recno" : "'+"Recno não encontrado"+'"'"
                        lRet		:= .F.
                    EndIf

                    If lRet
                        DbGoto(val(nRecEnv))
                        Reclock("SE5",.F.)
                        DbDelete()
                        SE5->(Msunlock())
                        cMessage  += "sucesso "
                        cResultAux += '"sucesso" : "'+"Titulo excluido com sucesso!!!"+'"'"
                        cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"recno" : "'+"Recno nr. "+cvaltochar(nRecEnv)+'"'"
                        
                        /*
                        //Feito via Reclock, na documentação do Caio diz para excluir e se usar com execauto a rotina cancela o lançamento.
                        Begin Transaction
                        //Chama a rotina automática
                        lMsErroAuto := .F.
                        MSExecAuto({|x,y,z| FINA100(x,y,z)}, 0, aVetSE5, 5)
                        
                        //Se houve erro, mostra o erro ao usuário e desarma a transação
                        If lMsErroAuto
                            cCode 	 := "#400"
                            cMessage  := "falha "
                            cResultAux := GetErro()
                            DisarmTransaction()
                        else
                            cMessage  += "sucesso "
                            cResultAux += '"sucesso" : "'+"Titulo excluido com sucesso!!!"+'"'"
                            cResultAux += If(!Empty(cResultAux),cVirgula,'')+'"recno" : "'+"Recno nr. "+cvaltochar(SE5->(Recno()))+'"'"
                        EndIf    

                        //Finaliza a transação
                        End Transaction*/
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
