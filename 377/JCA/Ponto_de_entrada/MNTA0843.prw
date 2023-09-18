#Include 'Totvs.ch'
#Include "FwMVCDef.ch"

/*/{Protheus.doc} MNTA0843
   @description: Ponto de Entrada do menu MNTA084
   @type: User Function
   @author: Felipe Mayer
   @since: 17/09/2023
/*/
User Function MNTA0843()

Local aRotina := PARAMIXB[1]

    ADD OPTION aRotina Title 'Alterar Cod Bem' Action 'u_JCAGFR02()'   OPERATION 9 ACCESS 0

Return aRotina
