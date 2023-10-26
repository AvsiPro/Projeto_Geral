#INCLUDE "Totvs.ch"

/*/{Protheus.doc} F200TIT()
 	    Ponto de entrada F200TIT para alterar os dados do titulo após a baixa retorno CNAB
  	    06-MIT 44 FINANCEIRO FIN017- Gerar boleto de Adiantamento - RA
 		https://docs.google.com/document/d/1lEfWblcls4_Z28sdq9QI0cB5Mw0om2Fc/edit
*/

User Function F200TIT()

    Local aAreaSE1 := GetArea()

    DbSelectArea("SE1")

    If (SE1->E1_TIPO == "BA ")
        RecLock("SE1",.f.)
        SE1->E1_TIPO  := "RA "
        SE1->E1_SALDO := SE1->E1_VALOR
        SE1->E1_SITUACA := "0"
        MsUnlock()
    EndIf

    RestArea(aAreaSE1)

Return
