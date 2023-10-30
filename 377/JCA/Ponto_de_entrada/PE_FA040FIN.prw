#include "rwmake.ch"
#include "protheus.ch"

/*/{Protheus.doc} FA040FIN()
 	    Ponto de entrada FA040FIN
        https://tdn.totvs.com/display/public/mp/FA040FIN+-+Trata+dados+--+11843

  	    06-MIT 44 FINANCEIRO FIN017- Gerar boleto de Adiantamento - RA
 		https://docs.google.com/document/d/1lEfWblcls4_Z28sdq9QI0cB5Mw0om2Fc/edit
*/

USER FUNCTION FA040FIN()
    LOCAL aFArea := GetArea()

    //GERA FIE PEDIDOS X ADIANTAMENTOS PARA TITULOS CRIADOS ATRAVÉS DA ROTINA JADFIN01
    IF FUNNAME() == "MATA410" .AND. ALLTRIM(SE1->E1_TIPO) == "BA"
        DbSelectArea("FIE")
        DbSetOrder(2)
        IF !Dbseek(xFilial("FIE")+"R"+SE1->E1_CLIENTE + SE1->E1_LOJA + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + "RA " + SC5->C5_NUM )
            //AvKey(cCodFor,"D1_FORNECE")+AvKey(cLojFor,"D1_LOJA")+AvkEY(aItens[nX,01],"D1_COD")+STRZERO(Nx,4))
            Reclock("FIE",.T.)
            FIE_FILIAL := SE1->E1_FILIAL
            FIE_CART  := "R"
            FIE_PEDIDO := SC5->C5_NUM
            FIE_PREFIX := SE1->E1_PREFIXO
            FIE_NUM  :=  SE1->E1_NUM
            FIE_PARCEL := SE1->E1_PARCELA
            FIE_TIPO  := "RA "
            FIE_CLIENT := SE1->E1_CLIENTE
            FIE_LOJA  := SE1->E1_LOJA
            FIE_VALOR := SE1->E1_VALOR
            FIE_SALDO := SE1->E1_VALOR
            FIE_FILORI := SE1->E1_FILIAL
            Msunlock()
        ELSE
            Reclock("FIE",.F.)
            FIE_CART  := "R"
            FIE_PEDIDO := SC5->C5_NUM
            FIE_PREFIX := SE1->E1_PREFIXO
            FIE_NUM  :=  SE1->E1_NUM
            FIE_PARCEL := SE1->E1_PARCELA
            FIE_TIPO  := "RA "
            FIE_CLIENT := SE1->E1_CLIENTE
            FIE_LOJA  := SE1->E1_LOJA
            FIE_VALOR := SE1->E1_VALOR
            FIE_SALDO := SE1->E1_VALOR
            FIE_FILORI := SE1->E1_FILIAL
        ENDIF
    ENDIF
    RestArea(aFArea)
Return
