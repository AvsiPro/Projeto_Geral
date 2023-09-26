#INCLUDE 'PROTHEUS.CH'

User Function JCAGAT03

Local cCodBar := M->E2_LINDIG
Local cFatVct := STRZERO(M->E2_VENCTO - CtoD("07/10/1997"),4)
Local nVlrT   := M->E2_VALOR //M->E2_SALDO - M->E2_DECRESC - M->E2_DESCONT
Local nVlrCBr := 0
Local cFatCBr := ''
Local lRet    := .T.

If !Empty(cCodBar)
    IF LEN(ALLTRIM(cCodBar))==47
        /*_cRetorno := Substr(cCodBar,1,4) + ; // BANCO + MOEDA
        Substr(cCodBar,33,1) + ; // DV GERAL
        Substr(cCodBar,34,4) + ; // FATOR VENCIMENTO
        StrZero(Val(Alltrim(Substr(cCodBar,38,10))),10) + ; // VALOR
        Substr(cCodBar,5,5) + ; // CAMPO LIVRE
        Substr(cCodBar,11,10) + ;
        Substr(cCodBar,22,10)*/
        cFatCBr := Substr(cCodBar,34,4)
        nVlrCBr := VAL(Alltrim(Substr(cCodBar,38,8))+"."+RIGHT(Alltrim(Substr(cCodBar,38,10)),2))

    ELSE
        cFatCBr := Substr(cCodBar,6,4)
        nVlrCBr := VAL(Alltrim(Substr(cCodBar,10,8))+"."+RIGHT(Alltrim(Substr(cCodBar,10,10)),2))
        //Val(Alltrim(Substr(cCodBar,10,10)))

        /*
        _cRetorno := Left(cCodbar,11)
        _cRetorno += SubStr(cCodbar,13,11)
        _cRetorno += SubStr(cCodbar,25,11)
        _cRetorno += SubStr(cCodbar,37,11)
        */
    ENDIF

    If cFatCBr <> cFatVct
        MsgAlert("Data do título divergente do boleto")
    EndIf 


    If nVlrT <> nVlrCBr
        MsgAlert("Valor do titulo divergente do boleto")
        lRet := .F.
    EndIf 
EndIf 

// Substituido pelo assistente de conversao do AP5 IDE em 13/06/01 ==> __Return(_cRetorno)
Return(lRet)
