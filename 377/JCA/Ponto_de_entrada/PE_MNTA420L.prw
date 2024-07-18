#Include 'Totvs.ch'

/*/{Protheus.doc} MNTA420L
   @description: Filtros browse mnta420
   @type: User Function
   @author: Felipe Mayer
   @since: 20/09/2023
/*/
User Function MNTA420L()

cRet := " TJ_SITUACA = 'L' OR "
cRet += " TJ_SITUACA = 'C' OR "
cRet += " TJ_SITUACA = 'P' "

cFilMbrSTJ := StrTran(cFilMbrSTJ,"TJ_SITUACA = 'L'", cRet)

Return ''


