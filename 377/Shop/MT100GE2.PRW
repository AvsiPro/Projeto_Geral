#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} MT100GE2
Complementa a gravação na tabela dos títulos financeiros a pagar
@type function
@version  1.00
@author rodolfo cesar
@since 10/05/2022
@return variant, nil
/*/
User Function MT100GE2()
    Local aAreaAtu   := GetArea()
    Local nOpc       := PARAMIXB[2]
    Local aParcelSe2 := PARAMIXB[5]
    Local nRecnoSe2  := SE2->(RecNo())
    Local nX         := 0 

    If nOpc == 1 //.. inclusaoo
        For nX := 1 to Len(aParcelSe2)
            If  aParcelSe2[nX, 2] < dDatabase
                //SE2 está posicionado na ordem 6
                If SE2->(MsSeek(xFilial("SE2") + SE2->( E2_FORNECE + E2_LOJA + E2_PREFIXO + E2_NUM + aParcelSe2[nX, 1] + E2_TIPO )))
                    If SE2->E2_VENCREA < dDatabase
                        RecLock("SE2",.F.)
                        SE2->E2_VENCREA := dDatabase + 3
                        SE2->E2_HIST    := "Vencto corrigido em "+Dtoc(dDatabase)+"-MT100GE2"
                        SE2->(MsUnLock())
                    Endif
                    //Altera natureza de titulos de reembolso incluídos automaticamente
                    //Necessario devido a rotina automatica nao entrar no PE NFECTSEV
                    If "MATA094" $ Funname() .and. SE2->E2_PREFIXO == "RD0"
                        RecLock("SE2",.F.)
                        SE2->E2_NATUREZ := GetMv("SC_NATRD")
                        SE2->(MsUnLock())
                    Endif 
                Endif
            Endif
        Next
    Endif

    SE2->(dbGoTo( nRecnoSe2 ))
    RestArea( aAreaAtu )

Return
