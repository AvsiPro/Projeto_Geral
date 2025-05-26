// Bibliotecas necess�rias
#Include "TOTVS.ch"

/*/{Protheus.doc} F811MAILTO
    Ponto de entrada para defini��o um endere�o de e-mail alternativo para o envio da carta
    de cobran�a, substituindo o endere�o cadastrado no campo A1_EMAIL.
    @type Function
    @version 12.1.37
    @author Guilherme Bigois
    @since 28/07/2022
    @return Character, E-mail do cliente para envio da carta de cobran�a
    @link https://tdn.totvs.com/display/public/PROT/DT_F811MAILTO_Ponto_de_Entrada
    @obs Quando o retorno do ponto for um caractere vazio, � utilizado o e-mail contido em A1_EMAIL
/*/
User Function F811MAILTO() As Character
    // Vari�veis locais
    Local cMail As Character // E-mail do cliente para retorno do ponto

    // Inicializa��o de vari�veis
    cMail := IIf(!Empty(SA1->A1_MAILFIN), SA1->A1_MAILFIN, NIL)
Return (cMail)
