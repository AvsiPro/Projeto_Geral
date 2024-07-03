#Include 'Protheus.ch'
  /*/{Protheus.doc} MNTA4351
    Ponto de entrada para inclusão de itens no menu de Retorno OS modelo 2.
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
User Function MNTA4351()
 
    aBtn := {"NG_ICO_ALTBEMM",{|| U_JCA2APRV()},"Aprovadores de Peças e Reabertura de O.S.","Aprovadores de Peças e Reabertura de O.S."}
     
Return aBtn
