#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} CRM980BFIL
Ponto de entrada para filtrar o cliente especifico a ser alterado pela rotina MENOTA
@type user function
@author user
@since 10/07/2025
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User function CRM980BFIL

    Local aArea   := FWGetArea()
    Local cFiltro := ""
    Local lZPE := type("cCliente") != "U" 
    
    If lZPE
        cFiltro := "SA1->A1_COD == '"+cCliente+"'"
    EndIf 
  
    FWRestArea(aArea)

Return cFiltro
