#Include "TOTVS.ch"


/*/{Protheus.doc} ROBWS05
    @long_description Tela para rastreio nos correios
    @type User Function
    @author Felipe Mayer
    @since 13/12/2022
    @version 1
/*/
User Function ROBWS05()

    If Empty(FunName())
        RpcSetType(3)
        RPCSetEnv("01","0103")
    EndIf

    SetPrvt("oDlg1","oGrp1","oGrp2","oList","oMGet1","oBtn1")

    cRastro  := ''
    aList    := {}
    aPergs   := {}
    cPedDe   := Space(TamSX3('C5_NUM')[01])
    cPedAt   := Space(TamSX3('C5_NUM')[01])
    cNotDe   := Space(TamSX3('F2_DOC')[01])
    cNotAt   := Space(TamSX3('F2_DOC')[01])
    dDataDe  := Date()
    dDataAt  := Date()
    
    aAdd(aPergs, {1, "Pedido De",  cPedDe,  "", ".T.", "SC5", ".T.", 80,.F.})
    aAdd(aPergs, {1, "Pedido Até", cPedAt,  "", ".T.", "SC5", ".T.", 80,.T.})
    aAdd(aPergs, {1, "Nota De"  ,  cNotDe,  "", ".T.", "SF2", ".T.", 80,.F.})
    aAdd(aPergs, {1, "Nota Até",   cNotAt,  "", ".T.", "SF2", ".T.", 80,.T.})
    aAdd(aPergs, {1, "Emissão De", dDataDe, "", ".T.", ""   , ".T.", 80,.F.})
    aAdd(aPergs, {1, "Emissão Até",dDataAt, "", ".T.", ""   , ".T.", 80,.T.})
    
    If ParamBox(aPergs, "Informe os parâmetros")

        cQuery := " SELECT * FROM " + RetSQLName("SC5") + "  " 
        cQuery += " WHERE D_E_L_E_T_=''  " 
        cQuery += " AND C5_XETIQUE != ''  " 
        cQuery += " AND C5_NUM BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'  " 
        cQuery += " AND C5_NOTA BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'  
        cQuery += " AND C5_EMISSAO BETWEEN '"+DToS(mv_par05)+"' AND '"+DToS(mv_par06)+"'  " 

        cAliasTMP := GetNextAlias()
        MPSysOpenQuery(cQuery, cAliasTMP)

        While (cAliasTMP)->(!EoF())
            Aadd(aList, {;
                Alltrim((cAliasTMP)->C5_FILIAL),;
                Alltrim((cAliasTMP)->C5_NUM),;
                DToC(SToD((cAliasTMP)->C5_EMISSAO)),;
                Alltrim((cAliasTMP)->C5_XETIQUE),;
                Alltrim((cAliasTMP)->C5_CLIENTE),;
                Alltrim(Posicione("SA1",1,xFilial("SA1")+(cAliasTMP)->C5_CLIENTE+(cAliasTMP)->C5_LOJACLI,"A1_NOME")),;
                Alltrim((cAliasTMP)->C5_VEND1),;
                Alltrim(Posicione("SA3",1,xFilial("SA3")+(cAliasTMP)->C5_VEND1,"A3_NOME")),;
                Alltrim((cAliasTMP)->C5_CONDPAG),;
                Alltrim((cAliasTMP)->C5_NOTA),;
                Alltrim((cAliasTMP)->C5_SERIE);
            })

            (cAliasTMP) ->(DbSkip())
        EndDo

        If Len(aList) > 0
            oDlg1  := MSDialog():New( 092,217,732,1413,"Rastro",,,.F.,,,,,,.T.,,,.T. )
            oGrp1  := TGroup():New( 008,008,300,380,"Documentos",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
            oGrp2  := TGroup():New( 008,388,280,584,"Rastro",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
            oMGet1 := TMultiGet():New( 020,396,{|u| Alltrim(cRastro) },oGrp2,176,252,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.T.,,,.F.,,  )
            oBtn1  := TButton():New( 284,546,"Gravar",oDlg1,{|| fGravaRastro(aList[oList:nAt,01],aList[oList:nAt,02])},037,016,,,,.T.,,"",,,,.F. )

            oList := TCBrowse():New(020,016,352,272,,{'Filial','Documento','Emissão','Etiqueta','Cliente','Nome Cliente','Vendedor','Nome Vendedor','Cond Pgto','Nota','Serie'},;
            {40,40,40,40,40,60,40,60,40,40,40},oGrp1,,,,{|| fGetRastro(aList[oList:nAt,04])},{|| },,,,,,,.F.,,.T.,,.F.,,,)
        
            oList:SetArray(aList)
            oList:bLine := {||{;
                aList[oList:nAt,01],;
                aList[oList:nAt,02],;
                aList[oList:nAt,03],;
                aList[oList:nAt,04],;
                aList[oList:nAt,05],;
                aList[oList:nAt,06],;
                aList[oList:nAt,07],;
                aList[oList:nAt,08],;
                aList[oList:nAt,09],;
                aList[oList:nAt,10],;
                aList[oList:nAt,11]}}

            oDlg1:Activate(,,,.T.)
        EndIf
    EndIf

Return


/*/{Protheus.doc} fGetRastro
    @long_description Consulta o rastro
    @type User Function
    @author Felipe Mayer
    @since 13/12/2022
    @version 1
/*/
Static Function fGetRastro(cEtiqueta)

Local aHeader  := {}
Local aResult  := {}
Local aAux     := {}
Local nX       := 0
Local oRest    := FWRest():New("https://api.correios.com.br/srorastro/")
Local jJSON    := JsonObject():New()
   
    AAdd(aHeader, "Content-Type: application/json")
    AAdd(aHeader, "Authorization: Bearer "+fGeraToken())

    oRest:setPath("v1/objetos/"+cEtiqueta+"?resultado=T")

    If oRest:Get(aHeader)
        jJSON:fromJSON(oRest:GetResult())

        aAux := jJSON['objetos'][1]['eventos']
        
        If aAux == Nil
            aResult := {}
            cRastro := jJSON['objetos'][1]['mensagem']
        Else
            aResult := aClone(aAux)
            cRastro := ''
        EndIf
        
        For nX := 1 To Len(aResult)
            If aResult[nX]['unidade'] != nil
                cRastro += aResult[nX]['descricao']+CRLF+CRLF
                cRastro += 'de: ' + aResult[nX]['unidade']['tipo']+','
                cRastro += aResult[nX]['unidade']['endereco']['cidade'] + ' - '+ aResult[nX]['unidade']['endereco']['uf']+CRLF
            EndIf

            If aResult[nX]['unidadeDestino'] != nil
                cRastro += 'para: ' + aResult[nX]['unidadeDestino']['tipo']+','
                cRastro += aResult[nX]['unidadeDestino']['endereco']['cidade'] + ' - '+ aResult[nX]['unidadeDestino']['endereco']['uf']+CRLF
            EndIf

            If aResult[nX]['dtHrCriado'] != nil
                cRastro += SubsTr(aResult[nX]['dtHrCriado'],9,2)+'/'
                cRastro += SubsTr(aResult[nX]['dtHrCriado'],6,2)+'/'
                cRastro += SubsTr(aResult[nX]['dtHrCriado'],1,4)+'  '
                cRastro += SubsTr(aResult[nX]['dtHrCriado'],12,8)
            EndIf

            If nX < Len(aResult)
                cRastro += CRLF+CRLF+CRLF
            EndIf
        Next nX
    EndIf

    oMGet1:Refresh()
    oDlg1:Refresh()

Return


/*/{Protheus.doc} fGeraToken
    @long_description Gera o Token para consulta do rastro
    @type User Function
    @author Felipe Mayer
    @since 13/12/2022
    @version 1
/*/
Static Function fGeraToken()

Local cURI      := "https://api.correios.com.br/token"           // URI DO SERVIÇO REST
Local cResource := "/v1/autentica/cartaopostagem"                // RECURSO A SER CONSUMIDO
Local oRest     := FwRest():New(cURI)                            // CLIENTE PARA CONSUMO REST
Local aHeader   := {}                                            // CABEÇALHO DA REQUISIÇÃO
Local bObject   := {|| JsonObject():New()}
Local oJson     := Eval(bObject)
Local jJSON     := JsonObject():New()
Local cToken    := ''

    AAdd(aHeader, "Content-Type: application/json")
    AAdd(aHeader, "Authorization: Basic cm9ic29sODg4OnJvYnNvbDEyMw==")

    oJson["numero"] := StrTokArr(SuperGetMV("TI_CONTCOR",.F.,"9912446282/0077203780"),'/')[2]

    oRest:SetPath(cResource)
    oRest:SetPostParams(oJson:ToJson())

    If (oRest:Post(aHeader))
        jJSON:fromJSON(oRest:GetResult())
        cToken := jJSON['token']
    Else
        ConOut("POST Error: " + oRest:GetLastError())
    EndIf

Return cToken


/*/{Protheus.doc} fGravaRastro
    @long_description Grava o rastro
    @type User Function
    @author Felipe Mayer
    @since 13/12/2022
    @version 1
/*/
Static Function fGravaRastro(cFilC5,cPedido)

Default cPedido := ''

    If !Empty(cRastro)
        DbSelectArea('SC5')
        SC5->(DbSetOrder(1))

        If SC5->(DbSeek(AvKey(cFilC5,'C5_FILIAL')+AvKey(cPedido,'C5_NUM')))
            RecLock('SC5',.F.)
                SC5->C5_XRASTRO := cRastro
            SC5->(MsUnlock())

            MsgInfo('Rastro gravado com sucesso!')
        EndIf
    EndIf
    
Return
