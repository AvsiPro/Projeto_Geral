#include 'protheus.ch'
#include 'parmtype.ch'
#include "totvs.ch"
#include "fileio.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  *EMGCTS99 * �Autor  �Microsiga           � Data �  26/01/24  ���
�������������������������������������������������������������������������͹��
���Desc.     �  CHAMADA DE INTEGRACAO EMIVE X CIELO                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

ProcLogAtu("INICIO", "SE1 - Cria��o de pagamentos recorrentes ")

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
            ProofOfSale -	N�mero da autoriza��o, identico ao NSU.	Texto	6	Texto alfanum�rico
            Tid -	Id da transa��o na adquirente.	Texto	20	Texto alfanum�rico
            AuthorizationCode -	C�digo de autoriza��o.	Texto	6	Texto alfanum�rico
            SoftDescriptor -	Texto que ser� impresso na fatura bancaria do portador - Disponivel apenas para VISA/MASTER - nao permite caracteres especiais	Texto	13	Texto alfanum�rico
            PaymentId - 	N�mero de identifica��o do pagamento, necess�rio para opera��es como Consulta, Captura e Cancelamento.	Guid	36	xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
            ECI	- Eletronic Commerce Indicator. Representa o qu�o segura � uma transa��o.	Texto	2	Exemplos: 7
            Status -	Status da Transa��o. Veja a tabela completa de Status transacional.	Byte	�	2
            ReturnCode -	C�digo de retorno da Adquir�ncia.	Texto	32	Texto alfanum�rico
            ReturnMessage -	Mensagem de retorno da Adquir�ncia.	Texto	512	Texto alfanum�rico
            */

            /*
                Status
                0	NotFinished	Todos	Aguardando atualiza��o de status.
                1	Authorized	Todos	Pagamento apto a ser capturado ou definido como pago.
                2	PaymentConfirmed	Todos	Pagamento confirmado e finalizado.
                3	Denied	Cart�es de cr�dito e d�bito (transfer�ncia eletr�nica) e e-wallets.	Pagamento negado por Autorizador.
                10	Voided	Todos, exceto boleto	Pagamento cancelado.
                11	Refunded	Cart�es de cr�dito e d�bito e e-wallets.	Pagamento cancelado ap�s 23h59 do dia de autoriza��o.
                12	Pending	Cart�es de cr�dito e d�bito (transfer�ncia eletr�nica), e-wallets e pix.	Aguardando retorno da institui��o financeira.
                13	Aborted	Todos	Pagamento cancelado por falha no processamento ou por a��o do Antifraude.
                20	Scheduled	Cart�o de cr�dito e e-wallets.	Recorr�ncia agendada.
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
                cResult := "Transa��o autorizada nsu - "+aAux[1,1]
            ElseIf aAux[1,7] == 3 
                cResult := "Transa��o negada pelo autorizador"
                //FwLogMsg("INFO",,"",FunName(),"","01",OemToAnsi("Transa��o negada pelo autorizador"),0,0,{})            
                SE1->(RecLock("SE1",.F.))
                SE1->E1_ZNVEZES += 1
                SE1->(MsUnLock())
            EndIf 
        Else
            cResult := oRestClient:GetLastError()
            //FwLogMsg("INFO",,"",FunName(),"","01",OemToAnsi("Erro na integra��o"),0,0,{})
            
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
    Busca os titulos a serem efetuados a solicita��o de debito no cart�o
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
cRet += '    "SoftDescriptor": "123456789ABCD",' // - TEXTO QUE IR� APARECER NA FATURA DO CLIENTE
cRet += '    "CreditCard": {'
cRet += '      "CardToken": "'+cToken+'",'
cRet += '      "SecurityCode": "262",'  //Onde ficar� isso?
cRet += '      "Brand": "Visa"'         //Onde ficar� isso?
cRet += '    }'
cRet += '  }'
cRet += '}'

RestArea(aArea)

Return(cRet)
