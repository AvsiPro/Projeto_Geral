#Include "TOTVS.CH"
#Include "RWMAKE.CH"

/*/{Protheus.doc} FA200FIL
Ponto de entrada para substituição da pesquisa do Título a Receber.

paramixb: aValores (consultar TDN - https://tdn.totvs.com/x/kKL8J)

@type       Function
@author     TOTVS
@since      26/09/2022
@return     Nil
/*/
User Function FA200FIL()

    LOCAL _cNsNum   := Padr(Alltrim(cNsNum),15)
    LOCAL aAreaSE1  := GetArea()
    LOCAL nIndex    := IndexOrd()
    LOCAL _cConta   := SEE->EE_CONTA

    cNumTit := SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA
    cEspecie:= SE1->E1_TIPO

    //Sua forma para pesquisa do título a receber
    SE1->(DbSelectArea("SE1"))
    SE1->(DbSetOrder(29))

    If SE1->(DbSeek(xFilial("SE1")+Avkey(alltrim(_cNsNum),"E1_NUMBCO") + AVKEY(alltrim(_cConta),"E1_CONTA")))//SubStr(cNumeroTit, 1, 10)))
        cNumTit  := SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA
        cEspecie := SE1->E1_TIPO
    Else
        //Só é permitida a manipulação da variável lHelp. Caso queira que o help seja exibido, lHelp deve receber .T.
        lHelp       := .f.
       
        //Variáveis permitidas para uso, mas que NÃO devem ser manipuladas
        //cNumTit     := ""
        //cEspecie    := ""
    EndIf
Return
