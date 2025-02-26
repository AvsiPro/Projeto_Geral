#INCLUDE "PROTHEUS.CH"

 /*/{Protheus.doc} 
    (long_description)
    @type  Function
    @author user
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function RRFAT03(nOpc)

Local aArea :=  GetArea()
Local cRet  :=  ''

If nOpc == 1
    cRet := xFuncax1()
ElseIf nOpc ==2 
    cRet := xFuncax2()
EndIf 

RestArea(aArea)

Return(cRet)

/*/{Protheus.doc} xFuncax1
    (long_description)
    @type  Static Function
    @author user
    @since 29/04/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function xFuncax1()

Local cRet := ''

DbSelectArea("SD2")
DbSetOrder(3)
DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE)

cRet := SD2->D2_PEDIDO


Return(cRet)

/*/{Protheus.doc} xFuncax1
    (long_description)
    @type  Static Function
    @author user
    @since 29/04/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function xFuncax2()

Local cRet := ''
Local aRet := {'N=Normal','C=Compl.Preco/Quantidade','I=Compl.ICMS','P=Compl.IPI','D=Dev.Compras','B=Utiliza Fornecedor'}
Local nPos

DbSelectArea("SD2")
DbSetOrder(3)
DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE)

DbSelectArea("SC5")
DbSetOrder(1)
Dbseek(xFilial("SC5")+SD2->D2_PEDIDO)
cRet := SC5->C5_TIPO

nPos := Ascan(aRet,{|x| substr(x,1,1) == Alltrim(cRet)})

If nPos > 0
    cRet := substr(aRet[nPos],3)
EndIf 

Return(cRet)
