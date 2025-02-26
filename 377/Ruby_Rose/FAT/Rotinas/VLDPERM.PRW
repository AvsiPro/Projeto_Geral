#Include "RwMake.ch"
#Include 'Protheus.ch'

/*/{Protheus.doc} VLDPERM
    (Função criada para desabilitar campos para edição)
    @author Paulo Lima
    @since 23/12/2021
    @version 1.0
    @return .T. ou .F.
    @.T.= habilita o campo, .F.= desabilita o campo
    /*/

User Function VLDPERM()

Local cGestor_Geral := lower(Alltrim(GetMv("ZZ_ACDGER"))) //lower(Alltrim(GetMv("ZZ_ACDGER")) +"everton.rosa")

    // Se usuário logado não estiver no parametro ZZ_ACDGER
	If !lower(UsrRetName(__CUSERID)) $ cGestor_Geral  
		// desabilita o campo para digitação
		Return(.F.)
	Endif

Return(.T.)
