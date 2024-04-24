#INCLUDE 'PROTHEUS.CH'
/*
    Validação de campo para verificar o valor do titulo a pagar bate com o conteudo do codigo de barras
    MIT 44_FIN026_Financeiro_validar_codigo_de_barras_ (1)

    Doc Mit
    https://docs.google.com/document/d/1_1QlKdzd5oXVsNZMi9g1JZT0OPcw4WLb/edit
    Doc Entrega
    https://docs.google.com/document/d/1LRrGvZksOgesN1Xzlgwzhv0snKAkWnYO/edit
    
*/
User Function JFING001

Local cCodBar := M->E2_LINDIG
Local nVlrT   := M->E2_VALOR 
Local nVlrCBr := 0
Local cFatCBr := ''
Local lRet    := .T.

If !Empty(cCodBar)
    IF LEN(ALLTRIM(cCodBar))==47
        cFatCBr := Substr(cCodBar,34,4)
        nVlrCBr := VAL(Alltrim(Substr(cCodBar,38,8))+"."+RIGHT(Alltrim(Substr(cCodBar,38,10)),2))

    ELSE
        cFatCBr := Substr(cCodBar,6,4)
        nVlrCBr := VAL(Alltrim(Substr(cCodBar,10,8))+"."+RIGHT(Alltrim(Substr(cCodBar,10,10)),2))
        
    ENDIF

    
    If nVlrT <> nVlrCBr
        MsgAlert("Valor do titulo divergente do boleto")
        lRet := .F.
    EndIf 
EndIf 

Return(lRet)
