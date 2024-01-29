#include 'protheus.ch'
#include 'parmtype.ch'
#include "totvs.ch"
#include "fileio.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  *EMGCTS99 * ºAutor  ³Microsiga           º Data ³  26/01/24  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  CHAMADA DE INTEGRACAO EMIVE X CIELO                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function EMGCTS99(cTip,cPayord)
 
Local oRestClient 	
Local aHeader 		:=  {}
Local cConteudo		:=	''
Local nHandle 	
Local nCont
Local cUserAut      :=  ''
Local cPassAut      :=  ''
Local aAux          :=  {}

Private aLista      :=  {}

Default cPayord		:=	''

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","0101")
EndIf

nHandle 		:= fcreate('\spool\'+Alltrim(cTip)+'_'+dtos(ddatabase)+cvaltochar(strtran(time(),":"))+'.xml' , FO_READWRITE + FO_SHARED )

ProcLogIni( {},"EMGCTS99" )

ProcLogAtu("INICIO", "SE1 - Criação de pagamentos recorrentes ")

cServer		:= SuperGetMv("ES_URLGT" 	,.F.,"https://apisandbox.cieloecommerce.cielo.com.br")
cResource 	:= SuperGetMv("ES_ERPSKU" 	,.F.,"/1/sales")
cUserAut	:= SuperGetMv("ES_USERGT" 	,.F.,"52fe20ab-c8d8-4682-bb40-8c1c3afcbb58")
cPassAut	:= SuperGetMv("ES_PASSGT" 	,.F.,"OPRMJLNXRRVVRZWXDKZXGMJVNRAIRRTAPSZRXWCC")

//Busca titulos a serem cobrados
Busca()

If len(aLista) > 0
    For nCont := 1 to len(aLista)
        oRestClient 	:= FWRest():New(cServer)
        oJsonRes 	    := JsonObject():new() 

        AAdd(aHeader, "Content-Type: application/json")
        Aadd(aHeader, "MerchantId:"+AllTrim(cUserAut) )
        Aadd(aHeader, "MerchantKey:"+AllTrim(cPassAut) )

        //criar o token para os testes
        cToken := createToken(cServer,aHeader)
        //Json do titulo a ser cobrado
        cConteudo := _jsonEnvio(cToken,aLista[nCont])

        oRestClient:setPath(cResource)

        oRestClient:SetPostParams(cConteudo)

        IF oRestClient:Post(aHeader)
            aAux := {}
            cResult := oRestClient:GetResult()
            oJsonRes:FromJson(cResult)
            
            /*
            ProofOfSale -	Número da autorização, identico ao NSU.	Texto	6	Texto alfanumérico
            Tid -	Id da transação na adquirente.	Texto	20	Texto alfanumérico
            AuthorizationCode -	Código de autorização.	Texto	6	Texto alfanumérico
            SoftDescriptor -	Texto que será impresso na fatura bancaria do portador - Disponivel apenas para VISA/MASTER - nao permite caracteres especiais	Texto	13	Texto alfanumérico
            PaymentId - 	Número de identificação do pagamento, necessário para operações como Consulta, Captura e Cancelamento.	Guid	36	xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
            ECI	- Eletronic Commerce Indicator. Representa o quão segura é uma transação.	Texto	2	Exemplos: 7
            Status -	Status da Transação. Veja a tabela completa de Status transacional.	Byte	—	2
            ReturnCode -	Código de retorno da Adquirência.	Texto	32	Texto alfanumérico
            ReturnMessage -	Mensagem de retorno da Adquirência.	Texto	512	Texto alfanumérico
            */

            /*
                Status
                0	NotFinished	Todos	Aguardando atualização de status.
                1	Authorized	Todos	Pagamento apto a ser capturado ou definido como pago.
                2	PaymentConfirmed	Todos	Pagamento confirmado e finalizado.
                3	Denied	Cartões de crédito e débito (transferência eletrônica) e e-wallets.	Pagamento negado por Autorizador.
                10	Voided	Todos, exceto boleto	Pagamento cancelado.
                11	Refunded	Cartões de crédito e débito e e-wallets.	Pagamento cancelado após 23h59 do dia de autorização.
                12	Pending	Cartões de crédito e débito (transferência eletrônica), e-wallets e pix.	Aguardando retorno da instituição financeira.
                13	Aborted	Todos	Pagamento cancelado por falha no processamento ou por ação do Antifraude.
                20	Scheduled	Cartão de crédito e e-wallets.	Recorrência agendada.
            */
            oJsonAux := oJsonRes:GetJsonObject('Payment')
            Aadd(aAux,{ oJsonAux["ProofOfSale"] ,;              //01
                        oJsonAux["Tid"],;                       //02
                        oJsonAux["AuthorizationCode"],;         //03
                        oJsonAux["SoftDescriptor"],;            //04
                        oJsonAux["PaymentId"],;                 //05
                        oJsonAux["ECI"],;                       //06
                        oJsonAux["Status"],;                    //07
                        oJsonAux["ReturnCode"],;                //08
                        oJsonAux["ReturnMessage"]})             //09
            
            DbSelectArea("SE1")
            Dbgoto(aLista[nCont])

            ProcLogAtu("MENSAGEM", 'Prefixo/Titulo/Parcela/Tipo '+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO)

            If CVALTOCHAR(aAux[1,7]) $ '1/2' 
                SE1->(RecLock("SE1",.F.))
                SE1->E1_NSUTEF := aAux[1,1]
                SE1->(MsUnLock()) 
                cResult := "Transação autorizada nsu - "+aAux[1,1]
            ElseIf aAux[1,7] == 3 
                cResult := "Transação negada pelo autorizador"
                //FwLogMsg("INFO",,"",FunName(),"","01",OemToAnsi("Transação negada pelo autorizador"),0,0,{})            
                SE1->(RecLock("SE1",.F.))
                SE1->E1_ZNVEZES += 1
                SE1->(MsUnLock())
            EndIf 
        Else
            cResult := oRestClient:GetLastError()
            //FwLogMsg("INFO",,"",FunName(),"","01",OemToAnsi("Erro na integração"),0,0,{})
            
            DbSelectArea("SE1")
            Dbgoto(aLista[nCont])

			SE1->(RecLock("SE1",.F.))
			SE1->E1_ZNVEZES += 1
			SE1->(MsUnLock())

        EndIf  

        ProcLogAtu("MENSAGEM", cResult)

        FWrite(nHandle,cResult,10000)

    Next nCont

    
    ProcLogAtu("FIM")
    

EndIf 

FClose(nHandle)

Return

/*/{Protheus.doc} Busca
    Busca os titulos a serem efetuados a solicitação de debito no cartão
    @type  Static Function
    @author user
    @since 26/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Busca()

Local aArea     := GetArea()
Local cQuery 
Local cTipoPg   := Supergetmv("ES_TIPPAG",.F.,"CC")

cQuery := "SELECT E1.R_E_C_N_O_ AS RECSE1 "
cQuery += " FROM "+RetSQLName("SE1")+" E1"
cQuery += " WHERE D_E_L_E_T_ =' ' AND E1_SALDO > 0 "
cQuery += " AND E1_ZTPPAG IN('"+Alltrim(cTipoPg)+"') AND E1_NSUTEF=' '"
cQuery += " AND E1_FILIAL BETWEEN ' ' AND 'ZZZ' AND E1_ZNVEZES<6"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("Busca.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB") 

While !EOF()
    Aadd(aLista,TRB->RECSE1)
    Dbskip()
EndDo 

RestArea(aArea)

Return

/*/{Protheus.doc} createToken
    Criar o token para teste
    @type  Static Function
    @author user
    @since 26/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function createToken(cServer,aArray)

Local aArea     :=  GetArea()
Local cRet      := ''
Local cPath     := '/1/card'
Local oJsonRes 	:= JsonObject():new() 
Local oObjeto   := FWRest():New(cServer)

cRet := '{'
cRet += '  "CustomerName": "Comprador Teste Cielo",'
cRet += '  "CardNumber": "4376608866697392",'
cRet += '  "Holder": "Comprador T Cielo",'
cRet += '  "ExpirationDate": "12/2030",'
cRet += '  "Brand": "Visa"'
cRet += '}'

oObjeto:setPath(cPath)

oObjeto:SetPostParams(cRet)

IF oObjeto:Post(aArray)
    cResult := oObjeto:GetResult()
    oJsonRes:FromJson(cResult)
    cRet := oJsonRes["CardToken"]
Else
    cResult := oObjeto:GetLastError()
    cRet := ""
EndIf 

RestArea(aArea)

Return(cRet)

/*/{Protheus.doc} _jsonEnvio
    (long_description)
    @type  Static Function
    @author user
    @since 26/01/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function _jsonEnvio(cToken,nRecE1)

Local aArea := GetArea()
Local cRet  := ''

DbSelectArea("SE1")
DbGoto(nRecE1)

cRet := '{'
cRet += '  "MerchantOrderId": "2014111706",'  //qual enviar?
cRet += '  "Customer": {'
cRet += '    "Name": "Comprador Teste"' //  +Alltrim(Posicione("SA1",1,xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,"A1_NOME"))+
cRet += '  },'
cRet += '  "Payment": {'
cRet += '    "Type": "CreditCard",'
cRet += '    "Amount": '+cvaltochar(SE1->E1_VALOR)+','
cRet += '    "Installments": 1,'
cRet += '    "SoftDescriptor": "123456789ABCD",' // - TEXTO QUE IRÁ APARECER NA FATURA DO CLIENTE
cRet += '    "CreditCard": {'
cRet += '      "CardToken": "'+cToken+'",'
cRet += '      "SecurityCode": "262",'  //Onde ficará isso?
cRet += '      "Brand": "Visa"'         //Onde ficará isso?
cRet += '    }'
cRet += '  }'
cRet += '}'

RestArea(aArea)

Return(cRet)
