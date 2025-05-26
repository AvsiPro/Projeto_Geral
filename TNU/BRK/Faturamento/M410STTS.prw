// Bibliotecas necess�rias
#Include "TOTVS.ch"

/*/{Protheus.doc} M410STTS
    Ponto de entrada para grava��o complementar de pedido de venda.
    @type Function
    @version 12.1.33
    @author Guilherme Bigois
    @since 17/12/2022
    @return Variant, Retorno nulo fixado
    @link https://tdn.totvs.com/pages/releaseview.action?pageId=6784155
/*/
User Function M410STTS() As Variant
    // Vari�veis locais
    Local cCustomerId As Character // C�digo do cliente + loja
    Local lRecISS     As Logical   // Flag de recolhimento de ISS
    Local aArea       As Array     // �rea atualmente posicionada

    // Inicializa��o de vari�veis
    cCustomerId := C5_CLIENTE + C5_LOJACLI
    lRecISS     := Posicione("SA1", 1, FwXFilial("SA1") + cCustomerId, "A1_RECISS") == "2"
    aArea       := FwGetArea()

    // Verifica se o cliente n�o recolhe o ISS
    If (lRecISS)
        // Grava o estado e munic�pio de presta��o
        DBSelectArea("SC5")
        RecLock("SC5", .F.)
            C5_RECISS  := "2"
            C5_ESTPRES := "SP"
            C5_MUNPRES := "50308"
        MsUnlock()
    EndIf

    // Restaura a �rea anterior
    FwRestArea(aArea)
    FwFreeArray(aArea)
Return (NIL)
