#INCLUDE "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT100TOK �Autor  � Marcelo Amaral     � Data �  05/11/2021 ���
�������������������������������������������������������������������������͹��
���Desc.     � Esse Ponto de Entrada � chamado 2 vezes dentro da rotina    ��
���          � A103Tudok(). Para o controle do n�mero de vezes em que ele 鱱
���          � chamado foi criada a vari�vel l�gica lMT100TOK, que quando  ��
���          � for definida como (.F.) o ponto de entrada ser� chamado     ��
���          � somente uma vez.											   ��
�������������������������������������������������������������������������͹��
���Objetivo  � Valida a inclus�o de NF                                    ���
���          �                                                             ��
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
    Aviso("Cod. de Reten��o","Duplicata com Valor de IRRF. Favor preencher campo Cod. de Reten��o.",{"OK"})
    lRet := .F.
    RestArea(aArea)
    Return lRet
EndIf

RestArea(aArea)

Return lRet
