#Include "RwMake.ch"
#Include 'Protheus.ch'

/*/{Protheus.doc} VLDPERM
    (Fun��o criada para desabilitar campos para edi��o)
    @author Paulo Lima
    @since 23/12/2021
    @version 1.0
    @return .T. ou .F.
    @.T.= habilita o campo, .F.= desabilita o campo
    /*/

User Function VLDPERM()

Local cGestor_Geral := lower(Alltrim(GetMv("ZZ_ACDGER"))) //lower(Alltrim(GetMv("ZZ_ACDGER")) +"everton.rosa")

    // Se usu�rio logado n�o estiver no parametro ZZ_ACDGER
	If !lower(UsrRetName(__CUSERID)) $ cGestor_Geral  
		// desabilita o campo para digita��o
		Return(.F.)
	Endif

Return(.T.)
