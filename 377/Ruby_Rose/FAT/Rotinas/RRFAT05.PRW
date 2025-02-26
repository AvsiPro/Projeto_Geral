#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} User Function RRFAT05
nOpcdescription)
    @type  Function
    @author user
    @since 30/04/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function RRFAT05(nOpc,nOp2)

Local aArea :=  GetArea()
Local cRet 
Default nOp2 := 0

cRet := xSldB2(nOpc,nOp2)

RestArea(aArea)

Return(cRet)

/*/{Protheus.doc} xSldB2
    (long_description)
    @type  Static Function
    @author user
    @since 30/04/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function xSldB2(nOpc,nOp2)
    
Local aArea :=  GetArea()
Local cRet  

If nOpc == 1
    DbSelectArea("SB2")
    DbSetOrder(1)
    If Dbseek(xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD)
        cRet := SaldoSb2()
    else
        cRet := 0
    EndIf 
ElseIf nOpc == 2
    /*DbSelectArea("DA0")
    DbSetOrder(1)
    DbSeek(xFilial("DA0")+strzero(nOp2,3))
    cRet := Alltrim(DA0->DA0_DESCRI)+*/
    cRet := ' R$ '
    DbSelectArea("DA1")
    DbSetOrder(1)
    DbSeek(xFilial("DA1")+strzero(nOp2,3)+SB1->B1_COD)
    cRet += Transform(DA1->DA1_PRCVEN,"@E 999,999.99")
EndIf 

RestArea(aArea)

Return(cRet)
