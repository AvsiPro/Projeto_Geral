#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'

/*/{Protheus.doc} TINCWS01
Dummy Function
@author Alexandre Venancio
@since 01/03/2024
@version 1.0
/*/
User Function TINCWS01()

return .T.

/*/{Protheus.doc} Webhook Integrador

API de integração do Webhook Integrador
@author		Alexandre Venancio
@since		01/03/2024
/*/
WSRESTFUL WebHookInc DESCRIPTION 'API de integração do Webhook de Incorporações'

  WSMETHOD POST GeraP98 ;
      DESCRIPTION 'Gera a tabela transitoria dos registros de incorporação' ;
      WSSYNTAX '/api/backoffice/Incorporador/v1/WebHookInc/?{body}' ;
      PATH '/api/backoffice/Incorporador/v1/WebHookInc/' ;
      TTALK 'v1' ;
      PRODUCES APPLICATION_JSON
      
ENDWSRESTFUL


/*/{Protheus.doc} POST 
/api/backoffice/Incorporador/v1/WebHookInc
Gera a tabela transitoria dos registros de incorporação

@return lRet	, Lógico, Informa se o processo foi executado com sucesso.

@author		Alexandre Venancio
@since		01/03/2024
@version	1.0
/*/
WSMETHOD POST GeraP98 WSSERVICE WebHookInc

  Local lRet		    := .T.
  Local oResponse   := JsonObject():New()
  Local oBody       := JsonObject():New()
  Local oDataBase   := JsonObject():New()
  Local cBody       := self:GetContent()

  Local cErroAuto   := ''
  Local cErrBody    := ''
  Local cErroBlk    := ''
  Local oException  := ErrorBlock({|e| cErroBlk := + e:Description + e:ErrorStack, lRet := .F. })

  Local aFields     := {}
  Local nCont       := 0
  Local cPkLocal    := ''
  Local cTable      := ''
  Local cIndice     := ''
  Local keyType     := ''
  Local aJsons      := {}
  Local lJsonA      := .F.

  Begin Sequence

    If !Empty(cErrBody := oBody:fromJson(cBody))
      lRet := .F.
      oResponse['code'] := 4
      oResponse['status'] := 400
      oResponse['message'] := 'Falha ao tentar converter o conteúdo enviado.'
      oResponse['detailedMessage'] := 'Verifique se o conteudo enviado está formatado corretamente em JSON. Erro: ' + cErrBody
    Else

      // Valida atributos obrigatorios
      If Empty(oBody['table'])
        lRet := .F.
        oResponse['code'] := 3
        oResponse['status'] := 400
        oResponse['message'] := 'Deve ser enviada a tabela a ser carregada'
        oResponse['detailedMessage'] := 'Verifique se no conteúdo está sendo enviado a propriedade table.'
      Else
        cTable := oBody['table']

        If !ChkFile(cTable)
          lRet := .F.
          oResponse['code'] := 3
          oResponse['status'] := 400
          oResponse['message'] := 'Deve ser enviada a tabela a ser carregada'
          oResponse['detailedMessage'] := 'Verifique se no conteúdo está sendo enviado a propriedade table.'
          

        Else  
          // Busca conta através da PK enviada
          DbSelectArea(cTable)
          (cTable)->(DBSetOrder(1)) 

          cPkLocal    := Alltrim(oBody['pk'])
          cIndice     := Alltrim(oBody['indexProtheus'])
          // ***********  validar se a pk esta cadastrada na tabela de de/para para continuar  ****************  //

          lJsonA := oBody:GetJsonValue("fields", @aJsons,  @keyType)

          If lJsonA
            For nCont := 1 to len(aJsons)
              GrvTrsit(cTable,'{"table": "'+cTable+'", "pk": "'+cPkLocal+'", "indexProtheus": "'+aJsons[nCont]['indiceFinal']+'", "fields": '+aJsons[nCont]:toJson()+'}',cPkLocal,aJsons[nCont]['indiceFinal'])
            Next nCont 

            lRet := .T.
            oResponse['code'] := 1
            oResponse['status'] := 200
            oResponse['message'] := 'Registro recebido com sucesso.'
          Else 
              
              GrvTrsit(cTable,cBody,cPkLocal,cIndice)
              
              If !Empty(cErroAuto)
                  lRet := .F.
                  oResponse['code'] := 5
                  oResponse['status'] := 400
                  oResponse['message'] := 'Não foi possível incluir a conta em nossa base.'
                  oResponse['detailedMessage'] := cErroAuto
              else
                  lRet := .T.
                  oResponse['code'] := 1
                  oResponse['status'] := 200
                  oResponse['message'] := 'Registro recebido com sucesso.'
              EndIf
          EndIf
        EndIf
        
      EndIf
    EndIf

  End Sequence

  ErrorBlock(oException)

  If lRet 

    self:SetResponse( oResponse:toJson() )
  
  ElseIf !Empty(cErroBlk) .Or. !Empty(cErroAuto)
    oResponse['code'] := 1
    oResponse['status'] := 500
    oResponse['message'] := 'Aconteceu um erro inesperado no serviço!'
    oResponse['detailedMessage'] := cErroBlk + cErroAuto

    lRet := .F.
  EndIf

  If !lRet
    SetRestFault( oResponse['code'],;
                  oResponse['message'],;
                  .T.,;
                  oResponse['status'],;
                  oResponse['detailedMessage'];
                )
  EndIf

  oDataBase := nil
  oResponse := nil 
  oBody     := nil
  aFields   := nil

Return lRet

/*/{Protheus.doc} GrvTrnsit
    (long_description)
    @type  Static Function
    @author user
    @since 01/03/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function GrvTrsit(cTable,cBody,cPk,cIndice)

  Local aArea := GetArea()
  Local cCodigo := '' //

  DbSelectArea("P98")
  DbSetOrder(2)
  If !Dbseek(xFilial("P98")+Avkey(cIndice,"P98_CODEXT")+cTable)

    cCodigo := GetSXenum("P98","P98_COD")
    Confirmsx8()
    Reclock("P98",.T.)
    P98->P98_FILIAL := xFilial("P98")
    P98->P98_COD    := cCodigo
    P98->P98_STATUS := '0'
  Else 
    Reclock("P98",.F.)
    P98->P98_STATUS := If(P98->P98_STATUS=="1","5","0")
  EndIf 

  P98->P98_DATA   := ddatabase 
  P98->P98_HORA   := cvaltochar(time())
  P98->P98_BODY   := cBody 
  P98->P98_CODEXT := cIndice 
  P98->P98_CALLBA := cPk
  P98->P98_TABELA := cTable

  P98->(Msunlock())

  RestArea(aArea)

Return
/*
  WS GET Para retornar os campos e suas validações para a versão web do integramais
*/
WSRESTFUL BuscaP96 DESCRIPTION 'API de integração do Webhook de Incorporações'

  WsData tabela	AS String
  
  WsMethod Get Description "Gera a consulta das tabelas a serem integradas para a versão web do Integramais" ;
    WsSyntax "/api/backoffice/Incorporador/v1/WebHookInc/BuscaP96" ;
    PATH '/api/backoffice/Incorporador/v1/WebHookInc/BuscaP96/' ;
    TTALK 'v1' ;
    PRODUCES APPLICATION_JSON
      
ENDWSRESTFUL

WsMethod Get WsReceive tabela WsService BuscaP96

  Local lRet    := .T.
  Local cTable  := ""
  Local oResponse   := JsonObject():New()
  Local oBody       := JsonObject():New()
  Local cBody       := self:GetContent()
  Local cErroBlk    := ''
  Local oException  := ErrorBlock({|e| cErroBlk := e:Description + e:ErrorStack, lRet := .F. })
  Local aResult     := {}
  Local cCampo, cTitulo, cDescri, cTipo, cTamanh, cDecima, cDica, cPesqui, cValida, cFixo, cIndTbl
  Local oItem

  // Define o tipo de retorno do método
  ::SetContentType("application/json")

  If Len(::aURLParms) > 0
    cTable := ::aURLParms[1]
  Else
    cTable := IIf(::tabela == Nil, "", ::tabela)
  EndIf

  If !Empty(cErrBody := oBody:fromJson(cBody)) .And. Empty(cTable)
    lRet := .F.
    oResponse["code"] := 4
    oResponse["status"] := 400
    oResponse["message"] := "Falha ao tentar converter o conteúdo enviado."
    oResponse["detailedMessage"] := "Verifique se o conteúdo enviado está formatado corretamente em JSON. Erro: " + cErrBody
  Else
    //cTable := oBody["tabela"]
    If !ChkFile(cTable)
      lRet := .F.
      oResponse["code"] := 3
      oResponse["status"] := 400
      oResponse["message"] := "Tabela inexistente para consulta"
      oResponse["detailedMessage"] := "Verifique se no conteúdo está sendo enviado a propriedade tabela."
    Else  
      lRet := .T.
      oResponse["code"] := 1
      oResponse["status"] := 200
      oResponse["message"] := "Tabela a ser consultada " + cTable
      oResponse["detailedMessage"] := "Detalhes da tabela."

      cQuery := "SELECT P96_CAMPO,P96_TITULO,P96_DESCRI,P96_TIPO,P96_TAMANH,P96_DECIMA,P96_DICA,P96_PESQUI,P96_VALIDA,P96_FIXO,P96_INDTBL"
      cQuery += " FROM " + RetSQLName("P96")
      cQuery += " WHERE P96_FILIAL='" + xFilial("P96") + "' AND P96_TABELA='" + alltrim(cTable) + "' AND D_E_L_E_T_=' '"
      cQuery += " ORDER BY P96_SEQ "
      
      If Select('QRY') > 0
          dbSelectArea('QRY')
          dbCloseArea()
      EndIf

      DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "QRY", .F., .T. )

      DbSelectArea("QRY")

      While !EOF()
        cCampo  := alltrim(QRY->P96_CAMPO)
        cTitulo := alltrim(QRY->P96_TITULO)
        cDescri := alltrim(QRY->P96_DESCRI)
        cTipo   := alltrim(QRY->P96_TIPO)
        cTamanh := cvaltochar(QRY->P96_TAMANH)
        cDecima := cvaltochar(QRY->P96_DECIMA)
        cDica   := alltrim(QRY->P96_DICA)
        cPesqui := alltrim(QRY->P96_PESQUI)
        cValida := alltrim(QRY->P96_VALIDA)
        cFixo   := alltrim(QRY->P96_FIXO)
        cIndTbl := alltrim(QRY->P96_INDTBL)
        
        oItem := JsonObject():New()
        oItem["P96_CAMPO"]  := cCampo
        oItem["P96_TITULO"] := cTitulo
        oItem["P96_DESCRI"] := cDescri
        oItem["P96_TIPO"]   := cTipo
        oItem["P96_TAMANH"] := cTamanh
        oItem["P96_DECIMA"] := cDecima
        oItem["P96_DICA"]   := cDica
        oItem["P96_PESQUI"] := cPesqui
        oItem["P96_VALIDA"] := cValida
        oItem["P96_FIXO"]   := cFixo
        oItem["P96_INDTBL"] := cIndTbl
        
        aAdd(aResult, oItem)
        
        dbSkip()
      EndDo
      dbCloseArea()
      
      oResponse["data"] := aResult
    EndIf     
  EndIf 

  If lRet 
    self:SetResponse(oResponse:toJson())
  Else
    SetRestFault( oResponse["code"],;
                  oResponse["message"],;
                  .T.,;
                  oResponse["status"],;
                  oResponse["detailedMessage"] )
  EndIf

Return(lRet)


/*
  WS GET Para retornar os status de integrações das tabelas enviadas para o integramais
*/
WSRESTFUL CadP97 DESCRIPTION 'API de integração do Webhook de Incorporações'

  WsData cnpj	AS String
  
  WsMethod Get Description "Busca os cadastros disponíveis para integração pela versão web do Integramais com o Protheus" ;
    WsSyntax "/api/backoffice/Incorporador/v1/WebHookInc/CadP97" ;
    PATH '/api/backoffice/Incorporador/v1/WebHookInc/CadP97/' ;
    TTALK 'v1' ;
    PRODUCES APPLICATION_JSON
      
ENDWSRESTFUL

WsMethod Get WsReceive cnpj WsService CadP97

  Local lRet    := .T.
  Local cCnpj  := ""
  Local oResponse   := JsonObject():New()
  Local oBody       := JsonObject():New()
  Local cBody       := self:GetContent()
  Local cErroBlk    := ''
  Local oException  := ErrorBlock({|e| cErroBlk := e:Description + e:ErrorStack, lRet := .F. })
  Local aResult     := {}
  Local oItem
  
  // Define o tipo de retorno do método
  ::SetContentType("application/json")
 

  If Len(::aURLParms) > 0
    cCnpj := ::aURLParms[1]
  Else
    cCnpj := IIf(::cnpj == Nil, "", ::cnpj)
  EndIf

  If !Empty(cErrBody := oBody:fromJson(cBody)) .And. Empty(cCnpj)
    lRet := .F.
    oResponse["code"] := 4
    oResponse["status"] := 400
    oResponse["message"] := "Falha ao tentar converter o conteúdo enviado."
    oResponse["detailedMessage"] := "Verifique se o conteúdo enviado está formatado corretamente em JSON. Erro: " + cErrBody
  Else
    //cCnpj := oBody["cnpj"]
    If Empty(cCnpj)
      lRet := .F.
      oResponse["code"] := 3
      oResponse["status"] := 400
      oResponse["message"] := "Não informado cnpj para consulta"
      oResponse["detailedMessage"] := "Verifique se no conteúdo está sendo enviado a propriedade tabela."
    Else  
      lRet := .T.
      
      cQuery := " SELECT P97_CNPJ, P97_FILORI, P97_FILDES, P97_CODIGO, P97_TABELA, COUNT(*) "
      cQuery += " FROM "+RetSQLName("P97")
      cQuery += " WHERE P97_FILIAL='" + FWXFILIAL("P97") + "' AND D_E_L_E_T_=' ' AND P97_CNPJ='"+cCnpj+"' "
      cQuery += " GROUP BY P97_CNPJ, P97_FILORI, P97_FILDES, P97_CODIGO, P97_TABELA "
      cQuery += " ORDER BY 5 "
      
      If Select('QRY') > 0
          dbSelectArea('QRY')
          dbCloseArea()
      EndIf

      DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "QRY", .F., .T. )

      DbSelectArea("QRY")

      If !Empty(QRY->P97_CNPJ)
        oResponse["code"] := 1
        oResponse["status"] := 200
        oResponse["message"] := EncodeUTF8("Status das integrações ")
        oResponse["detailedMessage"] := "Detalhes "

        cCnpjLib  := alltrim(QRY->P97_CNPJ)
        cFilOrig  := alltrim(QRY->P97_FILORI)
        cFilDest  := alltrim(QRY->P97_FILDES)
        cCodigo   := alltrim(QRY->P97_CODIGO)
                
        oItem := JsonObject():New()
        oItem["CNPJ"]               := cCnpjLib
        oItem["Filial_Origem"]      := cFilOrig
        oItem["Filial_Destino"]     := cFilDest
        oItem["Codigo_Integracao"]  := cCodigo
        
        aAdd(aResult,oItem)
        oResponse["cadastro"] := aResult

        aResult := {}

        While !EOF()
          
          oItens := JsonObject():New()
          oItens["TABELA"]      := alltrim(QRY->P97_TABELA)
          aAdd(aResult, oItens)
          
          dbSkip()
        EndDo
        dbCloseArea()
        
        oResponse["data"] := aResult
      Else 
        lRet := .F.
        oResponse["code"] := 4
        oResponse["status"] := 400
        oResponse["message"] := "Falha na consulta" 
        oResponse["detailedMessage"] := EncodeUTF8("CNPJ não cadastrado para integrações")
      EndIf 
    EndIf     
  EndIf 

  If lRet 
    //self:SetResponse(oResponse:toJson())
    self:SetResponse(oResponse:toJson("UTF-8"))
  Else
    SetRestFault( oResponse["code"],;
                  oResponse["message"],;
                  .T.,;
                  oResponse["status"],;
                  oResponse["detailedMessage"] )
  EndIf

Return(lRet)

/*
  WS GET Para retornar os status de integrações das tabelas enviadas para o integramais
*/

WSRESTFUL StatusP98 DESCRIPTION 'API de integração do Webhook de Incorporações'

  WsData cnpj	AS String
  
  WsMethod Get Description "Gera a consulta dos status das tabelas a serem integradas com a versão web do Integramais" ;
    WsSyntax "/api/backoffice/Incorporador/v1/WebHookInc/StatusP98" ;
    PATH '/api/backoffice/Incorporador/v1/WebHookInc/StatusP98/' ;
    TTALK 'v1' ;
    PRODUCES APPLICATION_JSON
      
ENDWSRESTFUL

WsMethod Get WsReceive cnpj WsService StatusP98

  Local lRet    := .T.
  Local cCnpj  := ""
  Local oResponse   := JsonObject():New()
  Local oBody       := JsonObject():New()
  Local cBody       := self:GetContent()
  Local cErroBlk    := ''
  Local cTabela,cStatus,nQtd
  Local oException  := ErrorBlock({|e| cErroBlk := e:Description + e:ErrorStack, lRet := .F. })
  Local aResult     := {}
  Local oItem
  Local aStatus     := {{'0','Aguardando'},{'1','Executado com sucesso'},{'2','Erro de execução'},{'3','Em execução'},{'5','Reenviado e aguardando execução'}}

  // Define o tipo de retorno do método
  ::SetContentType("application/json")
 

  If Len(::aURLParms) > 0
    cCnpj := ::aURLParms[1]
  Else
    cCnpj := IIf(::cnpj == Nil, "", ::cnpj)
  EndIf

  If !Empty(cErrBody := oBody:fromJson(cBody)) .And. Empty(cCnpj)
    lRet := .F.
    oResponse["code"] := 4
    oResponse["status"] := 400
    oResponse["message"] := "Falha ao tentar converter o conteúdo enviado."
    oResponse["detailedMessage"] := "Verifique se o conteúdo enviado está formatado corretamente em JSON. Erro: " + cErrBody
  Else
    //cCnpj := oBody["cnpj"]
    If Empty(cCnpj)
      lRet := .F.
      oResponse["code"] := 3
      oResponse["status"] := 400
      oResponse["message"] := "Não informado cnpj para consulta"
      oResponse["detailedMessage"] := "Verifique se no conteúdo está sendo enviado a propriedade tabela."
    Else  
      lRet := .T.
      oResponse["code"] := 1
      oResponse["status"] := 200
      oResponse["message"] := EncodeUTF8("Status das integrações ")
      oResponse["detailedMessage"] := "Detalhes "

      cQuery := " SELECT P98_TABELA, P98_STATUS, COUNT(*) AS QTD FROM "+RetSQLName("P98")
      cQuery += " WHERE P98_FILIAL='" + FWXFILIAL("P98") + "' AND P98_CALLBA='"+cCnpj+"' "
      cQuery += " GROUP BY P98_TABELA, P98_STATUS "
      cQuery += " ORDER BY 1 "
      
      If Select('QRY') > 0
          dbSelectArea('QRY')
          dbCloseArea()
      EndIf

      DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "QRY", .F., .T. )

      DbSelectArea("QRY")

      While !EOF()
        nPos := Ascan(aStatus,{|x| x[1] == QRY->P98_STATUS})
        cTabela  := alltrim(QRY->P98_TABELA)
        cStatus := alltrim(aStatus[nPos,2])
        nQtd := cvaltochar(QRY->QTD)
                
        oItem := JsonObject():New()
        oItem["TABELA"]     := cTabela
        oItem["STATUS"]     := EncodeUTF8(cStatus)
        oItem["QUANTIDADE"] := nQtd
        
        
        aAdd(aResult, oItem)
        
        dbSkip()
      EndDo
      dbCloseArea()
      
      oResponse["data"] := aResult
    EndIf     
  EndIf 

  If lRet 
    //self:SetResponse(oResponse:toJson())
    self:SetResponse(oResponse:toJson("UTF-8"))
  Else
    SetRestFault( oResponse["code"],;
                  oResponse["message"],;
                  .T.,;
                  oResponse["status"],;
                  oResponse["detailedMessage"] )
  EndIf

Return(lRet)
