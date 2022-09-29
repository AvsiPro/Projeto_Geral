#INCLUDE "PROTHEUS.CH"

 /*/{Protheus.doc} nomeFunction
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
User Function OM010MNU

Local aArea :=  GetArea()

aadd(aRotina,{'Importar Itens Tabela','U_ROBGEN05' , 0 , 3,0,NIL})

RestArea(aArea)

Return
