#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'

/*/{Protheus.doc} TINTWS13
Dummy Function
@author Alexandre Venancio
@since 20/11/2022
@version 1.0
/*/
User Function TINTWS13()
return .T.

/*/{Protheus.doc} Contas

API de integração de Contas Contabeis
@author		Alexandre Venancio
@since		20/11/2022
/*/
WSRESTFUL ContasContabeis DESCRIPTION 'API de integração de Contas Contabeis'

	WSMETHOD POST CT1Ent ;
      DESCRIPTION 'Inclui um novo Plano de Contas (CT1,CVD e CTS)' ;
      WSSYNTAX '/api/backoffice/ContasContabeis/v1/CT1Ent/?{body}' ;
      PATH '/api/backoffice/ContasContabeis/v1/CT1Ent/' ;
      TTALK 'v1' ;
      PRODUCES APPLICATION_JSON
  
  WSMETHOD POST CTTEnt ;
      DESCRIPTION 'Inclui um novo Centro de Custos (CTT)' ;
      WSSYNTAX '/api/backoffice/ContasContabeis/v1/CTTEnt/?{body}' ;
      PATH '/api/backoffice/ContasContabeis/v1/CTTEnt/' ;
      TTALK 'v1' ;
      PRODUCES APPLICATION_JSON
  
  WSMETHOD POST CTDEnt ;
      DESCRIPTION 'Inclui um novo Item Contábil (CTD)' ;
      WSSYNTAX '/api/backoffice/ContasContabeis/v1/CTDEnt/?{body}' ;
      PATH '/api/backoffice/ContasContabeis/v1/CTDEnt/' ;
      TTALK 'v1' ;
      PRODUCES APPLICATION_JSON

  WSMETHOD POST SEDEnt ;
      DESCRIPTION 'Inclui uma nova Natureza (SED)' ;
      WSSYNTAX '/api/backoffice/ContasContabeis/v1/SEDEnt/?{body}' ;
      PATH '/api/backoffice/ContasContabeis/v1/SEDEnt/' ;
      TTALK 'v1' ;
      PRODUCES APPLICATION_JSON 

  WSMETHOD POST CTHEnt ;
      DESCRIPTION 'Inclui uma nova Classe de Valor (CTH)' ;
      WSSYNTAX '/api/backoffice/ContasContabeis/v1/CTHEnt/?{body}' ;
      PATH '/api/backoffice/ContasContabeis/v1/CTHEnt/' ;
      TTALK 'v1' ;
      PRODUCES APPLICATION_JSON    
      
ENDWSRESTFUL

/*/{Protheus.doc} POST 
/api/backoffice/ContasContabeis/v1/CT1Ent
Inclui um novo Plano de Contas completo (CT1, CVD e CTS)

@return lRet	, Lógico, Informa se o processo foi executado com sucesso.

@author		Alexandre Venancio
@since		20/11/2022
@version	1.0
/*/
WSMETHOD POST CT1Ent WSSERVICE ContasContabeis

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
Local aStruct     := {}
Local nCont       := 0
Local nTipReg     := 3

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
      
      // Busca conta através da PK enviada
      DbSelectArea(oBody['table'])
      (oBody['table'])->(DBSetOrder(1)) 

      //Estrutura dos campos da tabela que será importada
      aStruct := FWSX3Util():GetListFieldsStruct( oBody['table'] , .F. )

      If (oBody['table'])->(DbSeek((oBody['pk'])))
        //Caso exista atualiza
        nTipReg := 4
      EndIf  
          
      For nCont := 1 to len(aStruct)
        Aadd(aFields,{aStruct[nCont,01],;
                    If(aStruct[nCont,02]=="N",val(oBody['fields'][aStruct[nCont,01]]),oBody['fields'][aStruct[nCont,01]])})
      Next nCont

      //Segunda Tabela
      If oBody:HasProperty("CVD")
        aStruct := {}
        aStruct := FWSX3Util():GetListFieldsStruct( "CVD" , .F. )
        For nCont := 1 to len(aStruct)
          Aadd(aFields,{aStruct[nCont,01],;
                      If(aStruct[nCont,02]=="N",val(oBody['CVD'][1][aStruct[nCont,01]]),oBody['CVD'][1][aStruct[nCont,01]])})
        Next nCont

      EndIf 

      //Terceira Tabela
      If oBody:HasProperty("CTS")
        aStruct := {}
        aStruct := FWSX3Util():GetListFieldsStruct( "CTS" , .F. )
        For nCont := 1 to len(aStruct)
          Aadd(aFields,{aStruct[nCont,01],;
                      If(aStruct[nCont,02]=="N",val(oBody['CTS'][1][aStruct[nCont,01]]),oBody['CTS'][1][aStruct[nCont,01]])})
        Next nCont

      EndIf 

      If lRet
        oDataBase := U_TINTA006(aFields,@cErroAuto,nTipReg)
        
        If !Empty(cErroAuto)
          lRet := .F.
          oResponse['code'] := 5
          oResponse['status'] := 400
          oResponse['message'] := 'Não foi possível incluir a conta em nossa base.'
          oResponse['detailedMessage'] := cErroAuto
        EndIf
      EndIf
      
    EndIf
  EndIf

End Sequence

ErrorBlock(oException)

If !Empty(cErroBlk) .Or. !Empty(cErroAuto)

    lRet := .T.
    cErroBlk := ""

EndIf

If lRet
  
  self:SetResponse( oDataBase:toJson() )
 
ElseIf !Empty(cErroBlk)
  oResponse['code'] := 1
  oResponse['status'] := 500
  oResponse['message'] := 'Aconteceu um erro inesperado no serviço!'
  oResponse['detailedMessage'] := cErroBlk
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


/*/{Protheus.doc} POST 
/api/backoffice/ContasContabeis/v1/CTTEnt
Inclui um novo Centro de Custos (CTT)

@return lRet	, Lógico, Informa se o processo foi executado com sucesso.

@author		Alexandre Venancio
@since		20/11/2022
@version	1.0
/*/
WSMETHOD POST CTTEnt WSSERVICE ContasContabeis

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
Local aStruct     := {}
Local nCont       := 0
Local nTipReg     := 3

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
      
      // Busca conta através da PK enviada
      DbSelectArea(oBody['table'])
      (oBody['table'])->(DBSetOrder(1)) 

      //Estrutura dos campos da tabela que será importada
      aStruct := FWSX3Util():GetListFieldsStruct( oBody['table'] , .F. )

      If (oBody['table'])->(DbSeek((oBody['pk']))) 
        nTipReg := 4
      EndIf 

      For nCont := 1 to len(aStruct)
        Aadd(aFields,{aStruct[nCont,01],;
                    If(aStruct[nCont,02]=="N",val(oBody['fields'][aStruct[nCont,01]]),oBody['fields'][aStruct[nCont,01]])})
      Next nCont

      If lRet
        oDataBase := U_TINTA007(aFields,@cErroAuto,oBody['table'],nTipReg)
        
        If !Empty(cErroAuto)

          lRet := .F.
          oResponse['code'] := 5
          oResponse['status'] := 400
          oResponse['message'] := 'Não foi possível incluir a conta em nossa base.'
          oResponse['detailedMessage'] := cErroAuto
        EndIf
      EndIf
      
    EndIf
  EndIf

End Sequence

ErrorBlock(oException)

If !Empty(cErroBlk) .Or. !Empty(cErroAuto)

    lRet := .T.
    cErroBlk := ""

EndIf

If lRet
  
  self:SetResponse( oDataBase:toJson() )
 
ElseIf !Empty(cErroBlk)
  oResponse['code'] := 1
  oResponse['status'] := 500
  oResponse['message'] := 'Aconteceu um erro inesperado no serviço!'
  oResponse['detailedMessage'] := cErroBlk
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

/*/{Protheus.doc} POST 
/api/backoffice/ContasContabeis/v1/CTDEnt
Inclui um novo Item Contabil (CTD)

@return lRet	, Lógico, Informa se o processo foi executado com sucesso.

@author		Alexandre Venancio
@since		20/11/2022
@version	1.0
/*/
WSMETHOD POST CTDEnt WSSERVICE ContasContabeis

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
Local aStruct     := {}
Local nCont       := 0
Local nTipReg     := 3


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
      
      // Busca conta através da PK enviada
      DbSelectArea(oBody['table'])
      (oBody['table'])->(DBSetOrder(1)) 

      //Estrutura dos campos da tabela que será importada
      aStruct := FWSX3Util():GetListFieldsStruct( oBody['table'] , .F. )

      If (oBody['table'])->(DbSeek((oBody['pk']))) 
        nTipReg := 4
      EndIF        
    
      For nCont := 1 to len(aStruct)
        Aadd(aFields,{aStruct[nCont,01],;
                    If(aStruct[nCont,02]=="N",val(oBody['fields'][aStruct[nCont,01]]),oBody['fields'][aStruct[nCont,01]])})
      Next nCont

      If lRet
        oDataBase := U_TINTA008(aFields,@cErroAuto,oBody['table'],nTipReg)
        
        If !Empty(cErroAuto)

          lRet := .F.
          oResponse['code'] := 5
          oResponse['status'] := 400
          oResponse['message'] := 'Não foi possível incluir a conta em nossa base.'
          oResponse['detailedMessage'] := cErroAuto
        EndIf
      EndIf
      
    EndIf
  EndIf

End Sequence

ErrorBlock(oException)

If !Empty(cErroBlk) .Or. !Empty(cErroAuto)

    lRet := .T.
    cErroBlk := ""

EndIf

If lRet
  
  self:SetResponse( oDataBase:toJson() )
 
ElseIf !Empty(cErroBlk)
  oResponse['code'] := 1
  oResponse['status'] := 500
  oResponse['message'] := 'Aconteceu um erro inesperado no serviço!'
  oResponse['detailedMessage'] := cErroBlk
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

/*/{Protheus.doc} POST 
/api/backoffice/ContasContabeis/v1/SEDEnt
Inclui uma nova Natureza (SED)

@return lRet	, Lógico, Informa se o processo foi executado com sucesso.

@author		
@since		21/12/2022
@version	1.0
/*/
WSMETHOD POST SEDEnt WSSERVICE ContasContabeis

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
Local aStruct     := {}
Local nCont       := 0
Local nTipReg     := 3

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
      
      // Busca conta através da PK enviada
      DbSelectArea(oBody['table'])
      (oBody['table'])->(DBSetOrder(1)) 

      //Estrutura dos campos da tabela que será importada
      aStruct := FWSX3Util():GetListFieldsStruct( oBody['table'] , .F. )

      If (oBody['table'])->(DbSeek((oBody['pk']))) 
        nTipReg := 4
      EndIf 

      For nCont := 1 to len(aStruct)
        Aadd(aFields,{aStruct[nCont,01],;
                    If(aStruct[nCont,02]=="N",val(oBody['fields'][aStruct[nCont,01]]),oBody['fields'][aStruct[nCont,01]])})
      Next nCont

      If lRet
        oDataBase := U_TINTA009(aFields,@cErroAuto,oBody['table'],nTipReg)
        
        If !Empty(cErroAuto)

          lRet := .F.
          oResponse['code'] := 5
          oResponse['status'] := 400
          oResponse['message'] := 'Não foi possível incluir a conta em nossa base.'
          oResponse['detailedMessage'] := cErroAuto
        EndIf
      EndIf
      
    EndIf
  EndIf

End Sequence

ErrorBlock(oException)

If !Empty(cErroBlk) .Or. !Empty(cErroAuto)

    lRet := .T.
    cErroBlk := ""

EndIf

If lRet
  
  self:SetResponse( oDataBase:toJson() )
 
ElseIf !Empty(cErroBlk)
  oResponse['code'] := 1
  oResponse['status'] := 500
  oResponse['message'] := 'Aconteceu um erro inesperado no serviço!'
  oResponse['detailedMessage'] := cErroBlk
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

/*/{Protheus.doc} POST 
/api/backoffice/ContasContabeis/v1/CTHEnt
Inclui uma nova Classe de Valor (CTH)

@return lRet	, Lógico, Informa se o processo foi executado com sucesso.

@author		Alexandre Venancio
@since		20/11/2022
@version	1.0
/*/
WSMETHOD POST CTHEnt WSSERVICE ContasContabeis

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
Local aStruct     := {}
Local nCont       := 0
Local nTipReg     := 3

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
      
      // Busca conta através da PK enviada
      DbSelectArea(oBody['table'])
      (oBody['table'])->(DBSetOrder(1)) 

      //Estrutura dos campos da tabela que será importada
      aStruct := FWSX3Util():GetListFieldsStruct( oBody['table'] , .F. )

      If (oBody['table'])->(DbSeek((oBody['pk']))) 
        nTipReg := 4
      EndIF        
    
      For nCont := 1 to len(aStruct)
        Aadd(aFields,{aStruct[nCont,01],;
                    If(aStruct[nCont,02]=="N",val(oBody['fields'][aStruct[nCont,01]]),oBody['fields'][aStruct[nCont,01]])})
      Next nCont

      If lRet
        oDataBase := U_TINTA010(aFields,@cErroAuto,oBody['table'],nTipReg)
        
        If !Empty(cErroAuto)

          lRet := .F.
          oResponse['code'] := 5
          oResponse['status'] := 400
          oResponse['message'] := 'Não foi possível incluir a conta em nossa base.'
          oResponse['detailedMessage'] := cErroAuto
        EndIf
      EndIf
      
    EndIf
  EndIf

End Sequence

ErrorBlock(oException)

If !Empty(cErroBlk) .Or. !Empty(cErroAuto)

    lRet := .T.
    cErroBlk := ""

EndIf

If lRet
  
  self:SetResponse( oDataBase:toJson() )
 
ElseIf !Empty(cErroBlk)
  oResponse['code'] := 1
  oResponse['status'] := 500
  oResponse['message'] := 'Aconteceu um erro inesperado no serviço!'
  oResponse['detailedMessage'] := cErroBlk
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
