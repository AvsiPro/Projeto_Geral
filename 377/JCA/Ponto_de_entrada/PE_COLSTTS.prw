#INCLUDE 'PROTHEUS.CH'

/*
    O Ponto de Entrada COLSTTS permite adicionar informações complementares depois
     da inclusão do documento nas tabelas Cabeçalho das NF de Entrada (SF1) / 
     Itens das NF de Entrada (SD1).

    Utilizado para manipular o xml da nota e gravar a informação da origem no produto
    no campo DT_ZORIG para posteriormente levar para o D1_ZORIG  e finalmente alterar
    o campo D1_CLASFIS de acordo com a origem do produto informada no xml.

    Solicitado pela usuária Priscila para o Analista Caio por email.

    Finalização 23/04/2024 - Venancio

*/
User Function COLSTTS()

Local aArea     := GetArea()
Local cDoc      := SF1->F1_DOC
Local cSer      := SF1->F1_SERIE
Local cFor      := SF1->F1_FORNECE
Local cLoj      := SF1->F1_LOJA 
Local aAjuste   := {}
Local nCont 

aAjuste := BuscaDT(cFor,cLoj,cDoc,cSer)

DbSelectArea("SD1")
DbSetOrder(1)

For nCont := 1 to len(aAjuste)
    //SDT->DT_ITEM,SDT->DT_COD,SDT->DT_ZORIG
    //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
    If Dbseek(xFilial("SD1")+cDoc+cSer+cFor+cLoj+aAjuste[nCont,02]+aAjuste[nCont,01])
        Reclock("SD1",.F.)
        SD1->D1_ZORIG := aAjuste[nCont,03]
        SD1->(Msunlock())
    EndIf 
Next nCont 

RestArea(aArea)

Return


/*/{Protheus.doc} BuscaDT
    (long_description)
    @type  Static Function
    @author user
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function BuscaDT(cFor,cLoj,cDoc,cSer)
//DT_FILIAL+DT_FORNEC+DT_LOJA+DT_DOC+DT_SERIE+DT_ITEM
Local aArea := GetArea()
Local aRet  := {}

DbSelectArea("SDT")¨
DbSetOrdeR(8)

If Dbseek(xFilial("SDT")+cFor+cLoj+cDoc+cSer)
    While !EOF() .AND. SDT->DT_FORNEC == cFor .And. SDT->DT_LOJA == cLoj .And. SDT->DT_DOC == cDoc .And. SDT->DT_SERIE == cSer 
        Aadd(aRet,{SDT->DT_ITEM,SDT->DT_COD,SDT->DT_ZORIG})
        Dbskip()
    EndDo 
EndIF 

RestArea(aArea)

Return(aRet)
