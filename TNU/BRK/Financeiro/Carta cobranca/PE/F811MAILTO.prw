// Bibliotecas necessárias
#Include "TOTVS.ch"

/*/{Protheus.doc} F811MAILTO
    Ponto de entrada para definição um endereço de e-mail alternativo para o envio da carta
    de cobrança, substituindo o endereço cadastrado no campo A1_EMAIL.
    @type Function
    @version 12.1.37
    @author Guilherme Bigois
    @since 28/07/2022
    @return Character, E-mail do cliente para envio da carta de cobrança
    @link https://tdn.totvs.com/display/public/PROT/DT_F811MAILTO_Ponto_de_Entrada
    @obs Quando o retorno do ponto for um caractere vazio, é utilizado o e-mail contido em A1_EMAIL
/*/
User Function F811MAILTO() As Character
    // Variáveis locais
    Local cMail As Character // E-mail do cliente para retorno do ponto

    // Inicialização de variáveis
    cMail := IIf(!Empty(SA1->A1_MAILFIN), SA1->A1_MAILFIN, NIL)
Return (cMail)
