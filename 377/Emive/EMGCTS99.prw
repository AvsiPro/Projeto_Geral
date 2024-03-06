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
Local lBaixa        :=  .T.
Local cBanco        :=  ''
Local cAgencia      :=  ''
Local cConta        :=  ''

Private aLista      :=  {}

Default cPayord		:=	''

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","02001")
EndIf

nHandle 		:= fcreate('\spool\'+Alltrim(cTip)+'_'+dtos(ddatabase)+cvaltochar(strtran(time(),":"))+'.xml' , FO_READWRITE + FO_SHARED )

ProcLogIni( {},"EMGCTS99" )

ProcLogAtu("INICIO", "SE1 - Criação de pagamentos recorrentes ")

cServer		:= SuperGetMv("ES_URLGT" 	,.F.,"https://apisandbox.cieloecommerce.cielo.com.br")
cResource 	:= SuperGetMv("ES_ERPSKU" 	,.F.,"/1/sales")
cUserAut	:= SuperGetMv("ES_USERGT" 	,.F.,"52fe20ab-c8d8-4682-bb40-8c1c3afcbb58")
cPassAut	:= SuperGetMv("ES_PASSGT" 	,.F.,"OPRMJLNXRRVVRZWXDKZXGMJVNRAIRRTAPSZRXWCC")

AAdd(aHeader, "Content-Type: application/json")
Aadd(aHeader, "MerchantId:"+AllTrim(cUserAut) )
Aadd(aHeader, "MerchantKey:"+AllTrim(cPassAut) )

//Busca titulos a serem cobrados
Busca()

If len(aLista) > 0
    For nCont := 1 to len(aLista)
        oRestClient 	:= FWRest():New(cServer)
        oJsonRes 	    := JsonObject():new() 

        //criar o token para os testes
        //Quando o campo da CN9 estiver com os tokens preenchidos, buscar de lá
        cToken := aLista[nCont,02] //createToken(cServer,aHeader)
        //Json do titulo a ser cobrado
        cConteudo := _jsonEnvio(cToken,aLista[nCont,01],aLista[nCont,04],aLista[nCont,05])

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
            Dbgoto(aLista[nCont,01])

            ProcLogAtu("MENSAGEM", 'Prefixo/Titulo/Parcela/Tipo '+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO)

            SE1->(RecLock("SE1",.F.))
            
            lBaixa := .F.

            If CVALTOCHAR(aAux[1,7]) $ '1/2' 
                SE1->E1_NSUTEF := aAux[1,1]
                cResult := "Transação autorizada nsu - "+aAux[1,1]
                lBaixa := .T.
            ElseIf aAux[1,7] == 3 
                cResult := "Transação negada pelo autorizador"
                SE1->E1_ZNVEZES += 1
            EndIf

            SE1->E1_ZRETADQ := aAux[1,8]
            SE1->E1_ZDESADQ := aAux[1,9]
        
            SE1->(MsUnLock()) 

            If lBaixa 
                DbSelectArea("SE1")
                Dbgoto(aLista[nCont,01])

                cBanco := Alltrim(Supergetmv("ES_BANCO",.F.,"341"))
                cAgencia := Alltrim(Supergetmv("ES_AGENCIA",.F.,"7766"))
                cConta := Alltrim(Supergetmv("ES_CONTA",.F.,"66554433"))

                DbSelectArea("SA6")
                DbSetOrder(1)
                Dbseek(xFilial("SA6")+Avkey(cBanco,"A6_COD")+Avkey(cAgencia,"A6_AGENCIA")+Avkey(cConta,"A6_NUMCON") )

                aBaixa := { {"E1_FILIAL"   ,SE1->E1_FILIAL                          ,Nil    },;
                            {"E1_PREFIXO"  ,SE1->E1_PREFIXO                         ,Nil    },;
                            {"E1_NUM"      ,SE1->E1_NUM                             ,Nil    },;
                            {"E1_TIPO"     ,SE1->E1_TIPO                            ,Nil    },;
                            {"E1_PARCELA"  ,SE1->E1_PARCELA                         ,Nil    },;
                            {"AUTMOTBX"    ,"NOR"                                   ,Nil    },;
                            {"AUTBANCO"    ,Avkey(cBanco,"A6_COD")                  ,Nil    },;
                            {"AUTAGENCIA"  ,Avkey(cAgencia,"A6_AGENCIA")            ,Nil    },;
                            {"AUTCONTA"    ,Avkey(cConta,"A6_NUMCON")               ,Nil    },;
                            {"AUTDTBAIXA"  ,ddatabase                               ,Nil    },;
                            {"AUTDTCREDITO",ddatabase                               ,Nil    },;
                            {"AUTHIST"     ,"COBRANCA RECORRENTE"                   ,Nil    },;
                            {"AUTJUROS"    ,0                                       ,Nil,.T.},;
                            {"AUTDESCONT"  ,0                                       ,Nil,.T.},;
                            {"AUTVALREC"   ,SE1->E1_SALDO                           ,Nil    }}

                lMsErroAuto := .F.

                MSExecAuto({|x,y| Fina070(x,y)},aBaixa,3)                  

                If lMsErroAuto
                    cMensagem := GetErro()
                else
                    cMensagem := "Baixa realizada com sucesso"
                EndIf

                ProcLogAtu("MENSAGEM", cMensagem)

            EndIf 
        Else
            cResult := oRestClient:GetLastError()
            
            DbSelectArea("SE1")
            Dbgoto(aLista[nCont,01])

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
//Local cTipoPg   := Supergetmv("ES_TIPPAG",.F.,"CC")  //Separar por /
Local cQtdVez   := Supergetmv("ES_QTDTEN",.F.,"6")   //Tipo Caracter

/*
cQuery := "SELECT E1.R_E_C_N_O_ AS RECSE1 "
cQuery += " FROM "+RetSQLName("SE1")+" E1"
cQuery += " WHERE D_E_L_E_T_ =' ' AND E1_SALDO > 0 "
cQuery += " AND E1_ZTPPAG IN('"+strtran(Alltrim(cTipoPg),"/","','")+"') AND E1_NSUTEF=' '"
cQuery += " AND E1_FILIAL BETWEEN ' ' AND 'ZZZ' AND E1_ZNVEZES<'"+ALLTRIM(cQtdVez)+"'"

//este tratamento de data, colocar somente quando for para a produção, ou terá que ficar alterando a data dos titulos na base de teste.
cQuery += " AND E1_VENCREA BETWEEN '"+dtos(ddatabase-(val(cQtdVez)+1))+"' and '"+dtos(ddatabase)+"'"
*/

/*
SELECT CNA_FILIAL,CNA_CONTRA,CNA_NUMERO,CNA_CRONOG,CNA_CLIENT,CNA_LOJACL,CN9_ZTOKEN,CNF_COMPET,CNF_VLPREV,CNF_VLREAL,CNF_DTREAL,CNF_DTVENC,CNF_NUMERO,CNF_PARCEL,E1_NUM,E1_PARCELA,E1_VALOR,E1.R_E_C_N_O_ AS RECNOSE1
FROM CNA010 CNA
INNER JOIN CN9010 CN9 ON CN9_FILIAL=CNA_FILIAL AND CN9_NUMERO=CNA_CONTRA AND CN9_SITUAC = '05' AND CN9_ESPCTR = '2' AND CN9_REVATU = ' ' AND CN9.D_E_L_E_T_=' ' AND CN9_ZTOKEN<>' '
INNER JOIN CNF010 CNF ON CNF_FILIAL=CNA_FILIAL AND CNF_CONTRA=CNA_CONTRA AND CNF_NUMPLA=CNA_NUMERO AND CNF.D_E_L_E_T_=' ' AND CNF_DTREAL BETWEEN '20240201' AND '20240201'
INNER JOIN SE1010 E1 ON E1_FILIAL=CNA_FILIAL AND E1_CLIENTE=CNA_CLIENT AND E1_LOJA=CNA_LOJACL AND E1_MDCONTR=CNA_CONTRA AND E1_MDCRON=CNF_NUMERO AND E1_MDPLANI=CNA_NUMERO AND E1.D_E_L_E_T_=' '
AND E1_EMISSAO BETWEEN '20240201' AND '20240201'
WHERE CNA_FILIAL='02001'
AND CNA.D_E_L_E_T_=' '*/

/*
cQuery := "SELECT CN9_ZTOKEN,E1.R_E_C_N_O_ AS RECSE1,CN9_ZDTVCA,CN9_ZDIGCA,CN9_ZBANCA"
cQuery += " FROM "+RetSQLName("CNA")+" CNA"
cQuery += " INNER JOIN "+RetSQLName("CN9")+" CN9 ON CN9_FILIAL=CNA_FILIAL AND CN9_NUMERO=CNA_CONTRA AND CN9_SITUAC = '05' AND CN9_ESPCTR = '2' AND CN9_REVATU = ' ' AND CN9.D_E_L_E_T_=' ' AND CN9_ZTOKEN<>' '"
cQuery += " INNER JOIN "+RetSQLName("CNF")+" CNF ON CNF_FILIAL=CNA_FILIAL AND CNF_CONTRA=CNA_CONTRA AND CNF_NUMPLA=CNA_NUMERO AND CNF.D_E_L_E_T_=' '"
cQuery += "     AND CNF_DTREAL BETWEEN '"+dtos(ddatabase-(val(cQtdVez)+1))+"' and '"+dtos(ddatabase)+"'"
cQuery += " INNER JOIN "+RetSQLName("SE1")+" E1 ON E1_FILIAL=CNA_FILIAL AND E1_CLIENTE=CNA_CLIENT AND E1_LOJA=CNA_LOJACL AND E1_MDCONTR=CNA_CONTRA AND E1_MDCRON=CNF_NUMERO AND E1_MDPLANI=CNA_NUMERO AND E1.D_E_L_E_T_=' '"
cQuery += "   AND E1_EMISSAO BETWEEN '"+dtos(ddatabase-(val(cQtdVez)+1))+"' and '"+dtos(ddatabase)+"'"
cQuery += "   AND E1_ZNVEZES<'"+ALLTRIM(cQtdVez)+"' AND E1_NSUTEF=' '"
cQuery += " WHERE CNA_FILIAL BETWEEN ' ' AND 'ZZZ'"
cQuery += " AND CNA.D_E_L_E_T_=' '"
*/

/*
    alterado em 04/03/2024 para a proxima query, pois o contrato gera venda assistida

cQuery := "SELECT CN9_ZTOKEN,E1.R_E_C_N_O_ AS RECSE1,CN9_ZDTVCA,CN9_ZDIGCA,CN9_ZBANCA" 
cQuery += " FROM "+RetSQLName("CND")+" CND"
cQuery += " INNER JOIN "+RetSQLName("CN9")+" CN9 ON CN9_FILIAL=CND_FILIAL "
cQuery += "       AND CN9_NUMERO=CND_CONTRA "
cQuery += "       AND CN9_SITUAC = '05' AND CN9_ESPCTR = '2' "
cQuery += "       AND CN9_REVATU = ' ' AND CN9.D_E_L_E_T_=' ' "
cQuery += "       AND CN9_ZTOKEN<>' ' AND CN9_REVISA=CND_REVISA"
cQuery += " INNER JOIN "+RetSQLName("CNA")+" CNA ON CNA_FILIAL=CND_FILIAL AND CNA_CONTRA=CN9_NUMERO AND CNA_REVISA=CN9_REVISA"
cQuery += " INNER JOIN "+RetSQLName("SC5")+" C5 ON C5_FILIAL=CND_FILIAL AND C5_MDCONTR=CND_CONTRA AND CND_NUMMED=C5_MDNUMED AND C5.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SE1")+" E1 ON E1_FILIAL=CND_FILIAL "
cQuery += "       AND E1_CLIENTE=CNA_CLIENT AND E1_LOJA=CNA_LOJACL "
cQuery += "       AND E1.D_E_L_E_T_=' ' "
cQuery += "       AND E1_EMISSAO BETWEEN '"+dtos(ddatabase-(val(cQtdVez)+1))+"' and '"+dtos(ddatabase)+"'" 
cQuery += "       AND E1_ZNVEZES<'6' AND E1_NSUTEF=' ' "
cQuery += "       AND E1_PEDIDO=C5_NUM AND E1_NUM=C5_NOTA AND E1_PREFIXO=C5_SERIE"
*/

cQuery := "SELECT CN9_ZTOKEN,SE1.R_E_C_N_O_ AS RECSE1,CN9_ZDTVCA,CN9_ZDIGCA,CN9_ZBANCA" 
cQuery += " FROM "+RetSQLName("SE1")+" SE1"
cQuery += " INNER JOIN "+RetSQLName("SL4")+" SL4 ON SL4.D_E_L_E_T_ <> '*' AND L4_FILIAL = E1_FILIAL AND SUBSTRING(L4_OBS,5,9) = E1_NUM"
cQuery += " INNER JOIN "+RetSQLName("SL1")+" SL1 ON SL1.D_E_L_E_T_ <> '*' AND L4_FILIAL = L1_FILIAL AND L4_NUM = L1_NUM AND L1_FORMPG='CC'"
cQuery += " INNER JOIN "+RetSQLName("CN9")+" CN9 ON CN9.D_E_L_E_T_ <> '*' AND L1_FILIAL = CN9_FILIAL AND L1_ZCONTRA = CN9_NUMERO AND L1_ZREVISA = CN9_REVISA AND CN9_ZTOKEN<>' '"
cQuery += " WHERE SE1.D_E_L_E_T_ <> '*'"
cQuery += "       AND E1_EMISSAO BETWEEN '"+dtos(ddatabase-(val(cQtdVez)+1))+"' and '"+dtos(ddatabase)+"'" 
cQuery += "       AND E1_ZNVEZES<'6' AND E1_NSUTEF=' ' "
cQuery += "       AND E1_PREFIXO = 'PED' AND E1_TIPO='CC'"
cQuery += "       AND E1_FILIAL BETWEEN ' ' AND 'ZZZ' "

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("Busca.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB") 

While !EOF()
    Aadd(aLista,{TRB->RECSE1,;
                TRB->CN9_ZTOKEN,;
                TRB->CN9_ZDTVCA,;
                TRB->CN9_ZDIGCA,;
                TRB->CN9_ZBANCA})
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
Static Function _jsonEnvio(cToken,nRecE1,cDigCt,cBande)

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
cRet += '      "SecurityCode": "262",'  //cDigCt
cRet += '      "Brand": "Visa"'         //cBande
cRet += '    }'
cRet += '  }'
cRet += '}'

RestArea(aArea)

Return(cRet)


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
