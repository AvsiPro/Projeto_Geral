// Bibliotecas necessárias
#Include "TOTVS.ch"

/*/{Protheus.doc} M410STTS
    Ponto de entrada para gravação complementar de pedido de venda.
    @type Function
    @version 12.1.33
    @author Guilherme Bigois
    @since 17/12/2022
    @return Variant, Retorno nulo fixado
    @link https://tdn.totvs.com/pages/releaseview.action?pageId=6784155
/*/
User Function M410STTS() As Variant
    // Variáveis locais
    Local cCustomerId As Character // Código do cliente + loja
    Local lRecISS     As Logical   // Flag de recolhimento de ISS
    Local aArea       As Array     // Área atualmente posicionada

    // Inicialização de variáveis
    cCustomerId := C5_CLIENTE + C5_LOJACLI
    lRecISS     := Posicione("SA1", 1, FwXFilial("SA1") + cCustomerId, "A1_RECISS") == "2"
    aArea       := FwGetArea()

    // Verifica se o cliente não recolhe o ISS
    If (lRecISS)
        // Grava o estado e município de prestação
        DBSelectArea("SC5")
        RecLock("SC5", .F.)
            C5_RECISS  := "2"
            C5_ESTPRES := "SP"
            C5_MUNPRES := "50308"
        MsUnlock()
    EndIf

    // Restaura a área anterior
    FwRestArea(aArea)
    FwFreeArray(aArea)
Return (NIL)
