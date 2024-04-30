#include 'protheus.ch'
#include 'parmtype.ch'
#Include 'topconn.ch'

/****************************************************************************
* Programa....: MS170QTD                                                  *
* Data........: 26/04/2024                                                  *
* Autor.......: Nei Carlos                                                  *
* Descrição...: Ponto de entrada para calcular a necessidade de compras     *
* por ponto do pedido pelo estoque maximo usando o produto pai e filho                          *
*                                                                           *
*                                                                           *
*****************************************************************************
* Alterado por:                                                             *
* Data........:                                                             *
* Motivo......:                                                             *
*                                                                           *
****************************************************************************/

User Function MS170QTD( )

    Local aArea  := GetArea()
    Local nSld   := 0
    Local nQuant := PARAMIXB
    
    nSld := QTDPRD(SB1->B1_COD)

    IF SBZ->BZ_EMAX >0 .AND. nSld <= SBZ->BZ_EMIN
         nQuant :=  IIF (SBZ->BZ_EMAX - nSld >0,SBZ->BZ_EMAX - nSld,0)    
     ElseIf SB1->B1_EMAX >0 .AND. nSld <= SB1->B1_EMIN
         nQuant :=  IIF (SB1->B1_EMAX - nSld >0,SB1->B1_EMAX - nSld,0)
     else
        nQuant := 0  
    ENDIF
    
    RestArea(aARea)
    
Return(nQuant)

Static FunctION QTDPRD(cProd)

    Local cQuery := ""
    Local nQuant := 0
    cQuery  += " SELECT SUM(QTD) QTD FROM " +CRLF
    cQuery  += "( " +CRLF
    cQuery  += "  SELECT  (B2_SALPEDI + B2_QATU ) QTD  FROM "+RETSQLNAME("SB2")+" SB2 " +CRLF
    cQuery  += "  LEFT JOIN "+RETSQLNAME("SBZ")+" SBZ ON BZ_FILIAL= B2_FILIAL AND BZ_COD = B2_COD AND SBZ.D_E_L_E_T_=' ' " +CRLF
    cQuery  += "  WHERE SUBSTRING(B2_COD,1,8)='"+SUBSTR(Alltrim(cProd),1,8)+"' AND SB2.D_E_L_E_T_ =' ' AND B2_FILIAL='"+XFILIAL("SB2")+"'" +CRLF
    cQuery  += " ) AS QRY "

    nQuant := MpSysExecScalar(cQuery,"QTD")

RETURN nQuant


