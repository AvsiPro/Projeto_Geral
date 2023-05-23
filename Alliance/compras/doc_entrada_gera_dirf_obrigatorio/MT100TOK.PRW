#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT100TOK ºAutor  ³ Marcelo Amaral     º Data ³  05/11/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Esse Ponto de Entrada é chamado 2 vezes dentro da rotina    ±±
±±º          ³ A103Tudok(). Para o controle do número de vezes em que ele é±±
±±º          ³ chamado foi criada a variável lógica lMT100TOK, que quando  ±±
±±º          ³ for definida como (.F.) o ponto de entrada será chamado     ±±
±±º          ³ somente uma vez.											   ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObjetivo  ³ Valida a inclusão de NF                                    º±±
±±º          ³                                                             ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT100TOK()

Local lRet := PARAMIXB[1]
Local aArea := GetArea()
Local nValIrrf := Mafisret(,"NF_VALIRR")

lMT100TOK := .F.

if !lRet
    RestArea(aArea)
    Return lRet
endif

If nValIrrf > 0 .and. cDirf == "2"
    Aviso("Dirf","Duplicata com Valor de IRRF. Favor preencher o campo Gera Dirf com Sim.",{"OK"})
    lRet := .F.
    RestArea(aArea)
    Return lRet
EndIf

If nValIrrf > 0 .and. Empty(cCodRet)
    Aviso("Cod. de Retenção","Duplicata com Valor de IRRF. Favor preencher campo Cod. de Retenção.",{"OK"})
    lRet := .F.
    RestArea(aArea)
    Return lRet
EndIf

RestArea(aArea)

Return lRet
