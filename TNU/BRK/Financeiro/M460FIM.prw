// Bibliotecas necess�rias
#Include "TOTVS.ch"

/*/{Protheus.doc} M460FIM
    Ponto de entrada chamado ap�s a grava��o da NF de sa�da e fora da transa��o.
    @type Function
    @version 12.1.33
    @author Guilherme Bigois
    @since 20/12/2022
    @return Variant, Retorno nulo fixado
    @link https://tdn.totvs.com/pages/releaseview.action?pageId=6784180
/*/
User Function M460FIM() As Variant
    // Vari�veis locais
    Local nX    As Numeric // Contador de tabelas para restaura��o
    Local aArea As Array   // Estado das �reas anteriormente posicionadas
    Local nValLiq as Numeric
    Local cMnsNota as String

    // Inicializa��o de vari�veis
    nX       := 0
    cMnsNota := ""
    aArea    :={FwGetArea()}
    //nTaxValue := U_GetTaxValues()

    // Inicia a sequ�ncia de processamento
    BEGIN SEQUENCE
        // Posiciona o t�tulo a receber
        DBSelectArea("SE1")
        AAdd(aArea, FwGetArea())
        DBSetOrder(2) // E1_FILIAL + E1_CLIENTE + E1_LOJA + E1_PREFIXO + E1_NUM + E1_PARCELA
        MsSeek(FwXFilial() + SF2->(F2_CLIENTE + F2_LOJA + F2_PREFIXO + F2_DOC))

        // Para a execu��o caso n�o encontre o t�tulo a receber
        If (!Found())
            BREAK
        EndIf

        // Percorre todos os t�tulos a receber relacionados a nota fiscal de sa�da
        While (SE1->(!EOF() .And. E1_FILIAL + E1_CLIENTE + E1_LOJA + E1_PREFIXO + E1_NUM == FwXFilial() + SF2->(F2_CLIENTE + F2_LOJA + F2_PREFIXO + F2_DOC)))
            // Grava o valor l�quido removendo os impostos + decr�scimos e somando os acr�scimos no valor total no t�tulo principal
            If (AllTrim(SE1->E1_TIPO) == "NF")
                RecLock("SE1", .F.)
                    E1_XVALLIQ := E1_VALOR - U_GetTaxValues() + E1_ACRESC - E1_DECRESC
                MsUnlock()
                nValLiq := SE1->E1_XVALLIQ
            EndIf

            // Salta para o pr�ximo t�tulo
            DBSkip()
        End

    END SEQUENCE

    // Valdemir Rabelo 02/03/2023
    IF nValLiq > 0
        cMnsNota := Alltrim(SF2->F2_MENNOTA) + " | Valor Liquido: R$ "+CValToChar(nValLiq)+" "
        RecLock("SF2", .f.)
        SF2->F2_MENNOTA := cMnsNota
        MsUnlock()
        RecLock("SC5", .f.)
        SC5->C5_MENNOTA := cMnsNota
        MsUnlock()

    Endif 

    // Restaura as �reas anteriormente posicionadas
    For nX := Len(aArea) To 1 Step -1
        FwRestArea(aArea[nX])
    Next
    FwFreeArray(aArea)
Return (NIL)
