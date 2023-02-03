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
        Processa({|| fQueryPro()},"Efetuando rastreamento")
    EndIf

Return


Static Function fQueryPro()

    SetPrvt("oDlg1","oGrp1","oGrp2","oList","oMGet1","oBtn1","oBtn2","oBtn3")

    cRastro  := ''
    aList    := {}

    cQuery := " SELECT * FROM " + RetSQLName("SC5") + "  " 
    cQuery += " WHERE D_E_L_E_T_=''  " 
    cQuery += " AND C5_FILIAL = '"+xFilial('SC5')+"'
    cQuery += " AND C5_TRANSP IN ('T3','"+Iif(cFilAnt == '0101','T1','T16')+"') " 
    cQuery += " AND C5_NUM BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'  " 
    cQuery += " AND C5_NOTA BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'  
    cQuery += " AND C5_EMISSAO BETWEEN '"+DToS(mv_par05)+"' AND '"+DToS(mv_par06)+"'  " 
    cQuery += " ORDER BY C5_NOTA,C5_TRANSP"

    cAliasTMP := GetNextAlias()
    MPSysOpenQuery(cQuery, cAliasTMP)

    While (cAliasTMP)->(!EoF())
          
        Aadd(aList, {;
            Alltrim((cAliasTMP)->C5_FILIAL),;
            Alltrim((cAliasTMP)->C5_NOTA)+'-'+Alltrim((cAliasTMP)->C5_SERIE),;
            Alltrim((cAliasTMP)->C5_NUM),;
            DToC(SToD((cAliasTMP)->C5_EMISSAO)),;
            Alltrim((cAliasTMP)->C5_XETIQUE),;
            Alltrim((cAliasTMP)->C5_CLIENTE),;
            Alltrim(Posicione("SA1",1,xFilial("SA1")+(cAliasTMP)->C5_CLIENTE+(cAliasTMP)->C5_LOJACLI,"A1_NOME")),;
            Iif(Alltrim((cAliasTMP)->C5_TRANSP) != Iif(cFilAnt == '0101','T1','T16'),fGetRastro(Alltrim((cAliasTMP)->C5_XETIQUE),.F.), fGetBras(Alltrim(SM0->M0_CGC),Alltrim((cAliasTMP)->C5_NOTA),.F.)),;
            Alltrim(Posicione("SA3",1,xFilial("SA3")+(cAliasTMP)->C5_VEND1,"A3_NOME")),;
            Alltrim((cAliasTMP)->C5_CONDPAG),;
            Alltrim((cAliasTMP)->C5_TRANSP),;
            Alltrim((cAliasTMP)->C5_NOTA);
        })
        (cAliasTMP) ->(DbSkip())
    EndDo

    If Len(aList) > 0
        oDlg1  := MSDialog():New( 092,217,732,1413,"Rastreio de Mercadorias",,,.F.,,,,,,.T.,,,.T. )
        oGrp1  := TGroup():New( 008,008,300,380,"Documentos",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
        oGrp2  := TGroup():New( 008,388,280,584,"Rastreio",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
        oMGet1 := TMultiGet():New( 020,396,{|u| Alltrim(cRastro) },oGrp2,176,252,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.T.,,,.F.,,  )
        oBtn1  := TButton():New( 284,450,"Gerar Relatório",oDlg1,{|| Processa({|| GeraPlan(aList)},"Aguarde, gerando relatório")},042,016,,,,.T.,,"",,,,.F. )
        oBtn2  := TButton():New( 284,500,"Fechar",oDlg1,{|| oDlg1:End()},037,016,,,,.T.,,"",,,,.F. )
        oBtn3  := TButton():New( 284,546,"Gravar",oDlg1,{|| fGravaRastro(aList[oList:nAt,01],aList[oList:nAt,02],aList[oList:nAt,08])},037,016,,,,.T.,,"",,,,.F. )

        oList := TCBrowse():New(020,016,352,272,,{'Filial','Nota','Pedido','Emissão','Etiqueta','Cliente','Nome Cliente','Ultimo Status','Vendedor','Cond Pgto','Transporte'},;
        {40,40,40,40,40,60,40,60,40,40,40,40},oGrp1,,,,{|| Iif(aList[oList:nAt,11] != Iif(cFilAnt == '0101','T1','T16'),fGetRastro(aList[oList:nAt,05],.T.), fGetBras(Alltrim(SM0->M0_CGC),aList[oList:nAt,12],.T.))},{|| },,,,,,,.F.,,.T.,,.F.,,,)
    
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
            Iif(aList[oList:nAt,11] == 'T3','Correrios','Braspress');
        }}

        oDlg1:Activate(,,,.T.)
    EndIf

Return

/*/{Protheus.doc} fGetRastro
    @long_description Consulta o rastro
    @type User Function
    @author Felipe Mayer
    @since 13/12/2022
    @version 1
/*/
Static Function fGetRastro(cEtiqueta,lRastrAll)

Local aHeader  := {}
Local aResult  := {}
Local aAux     := {}
Local nX       := 0
Local cRet     := ''
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

        If !lRastrAll
            If Empty(cRastro)
                If aResult[01]['unidade'] != nil
                    cRet := Alltrim(aResult[01]['descricao'])
                EndIf
            Else
                cRet := cRastro
            EndIf
        EndIf
        
        If lRastrAll
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

            cRet := cRastro
            oMGet1:Refresh()
            oDlg1:Refresh()
        EndIf
    EndIf

Return cRet


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
Static Function fGravaRastro(cFilC5,cPedido,cUltSts)

Default cPedido := ''

    If !Empty(cUltSts)
        DbSelectArea('SC5')
        SC5->(DbSetOrder(1))

        If SC5->(DbSeek(AvKey(cFilC5,'C5_FILIAL')+AvKey(cPedido,'C5_NUM')))
            RecLock('SC5',.F.)
                SC5->C5_XRASTRO := cUltSts
            SC5->(MsUnlock())

            MsgInfo('Status do rastreio gravado com sucesso!')
        EndIf
    EndIf
    
Return



Static Function GeraPlan(aList)

Local oExcel 	:= FWMSEXCEL():New()
Local cDir 		:= cGetFile(, OemToAnsi("Selecione o diretório de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 
Local cArqXls 	:= "rastreio_"+dtos(ddatabase)+strtran(time(),":")+".xls" 
Local nX        := 0
Local cTitle    := 'Rastreio_Correrios'

    If Empty(cDir)
        Return
    EndIf

    oExcel:AddworkSheet('rastreio') 
    oExcel:AddTable('rastreio',cTitle)
    oExcel:AddColumn('rastreio',cTitle,"Filial",1,1)
    oExcel:AddColumn('rastreio',cTitle,"Nota",1,1) 
    oExcel:AddColumn('rastreio',cTitle,"Pedido",1,1) 
    oExcel:AddColumn('rastreio',cTitle,"Emissão",1,1) 
    oExcel:AddColumn('rastreio',cTitle,"Etiqueta",1,1) 
    oExcel:AddColumn('rastreio',cTitle,"Cliente",1,1)
    oExcel:AddColumn('rastreio',cTitle,"Nome Cliente",1,1)
    oExcel:AddColumn('rastreio',cTitle,"Ultimo Status",1,1)
    oExcel:AddColumn('rastreio',cTitle,"Vendedor",1,1)
    oExcel:AddColumn('rastreio',cTitle,"Cond Pgto",1,1)

    For nX := 1 to len(aList) 
            oExcel:AddRow('rastreio',cTitle,{;
                aList[nX,01],;
                aList[nX,02],;
                aList[nX,03],; 
                aList[nX,04],;
                aList[nX,05],;
                aList[nX,06],;
                aList[nX,07],;
                aList[nX,08],;
                aList[nX,09],;
                aList[nX,10];
            }) 
    Next nX

    oExcel:Activate()
    oExcel:GetXMLFile(cDir+cArqXls)

    oExcelApp := MsExcel():New()
    oExcelApp:Destroy()

    If File(cDir+cArqXls)
        MsgInfo('Relatório gerado com sucesso!<br><b>'+cDir+cArqXls+'</b>')
    EndIf

	
Return



Static Function fGetBras(cCnpj,cDoc,lAll)

Local aHeader  := {}
Local nMaxTent := 10
Local nCntTent := 0
Local nX       := 0
Local cRet     := ''

Default cCnpj := '23824405000301'
Default cDoc  := '00005428'

cUrlInt := Alltrim(SuperGetmv('TI_APIBRAS',.F.,"https://api.braspress.com")) 
oRest   := FWRest():New(cUrlInt)
jJSON   := JsonObject():New()
cUsrId  := Alltrim(SuperGetmv('TI_USRBRAS',.F.,"ROB301_PRD:igYY3I38ROu42Wmq"))

aadd(aHeader,'Content-Type: application/json; charset=utf-8')
aadd(aHeader,'Authorization: Basic ' + Encode64(cUsrId))
aadd(aheader,'Cookie: JSESSIONID=998EA0B48034ADA3FAE84FB1AB0D4B6B')

oRest:setPath("/v3/tracking/byNf/"+Alltrim(cCnpj)+"/"+Alltrim(StrTran(cDoc,'0',''))+"/json")

While .T.
    nCntTent++

    If oRest:Get(aHeader)
        jJSON:fromJSON(oRest:GetResult())
        
        aTimeLine := jJSON['conhecimentos'][1]['timeLine']

        If aTimeLine != Nil
            For nX := 1 To Len(aTimeLine)
                If lAll
                    cRet += 'Data: ' + aTimeLine[nX]['data'] + CRLF
                    cRet += 'Descrição: '+ aTimeLine[nX]['descricao'] + CRLF + CRLF
                Else
                    If nX == Len(aTimeLine)
                        cRet := aTimeLine[nX]['data'] + '-' + aTimeLine[nX]['descricao']
                        Exit
                    EndIf
                EndIf
            Next nX
        Else
            cRet := 'Erro ao consultar Braspress, tente novamente'
        EndIf

        Exit
    EndIf

    If nCntTent == nMaxTent
        cRet := 'Erro ao consultar Braspress, tente novamente'
        Exit
    EndIf
EndDo

If Empty(cRet)
    cRet := 'Erro ao consultar Braspress, tente novamente'
EndIf

cRastro := cRet

Return cRet
