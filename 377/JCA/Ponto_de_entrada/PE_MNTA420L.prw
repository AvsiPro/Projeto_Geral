<<<<<<< HEAD:377/JCA/Ponto_de_entrada/MNTA420L.prw
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
cRet += " TJ_SITUACA = 'B' "

cFilMbrSTJ := StrTran(cFilMbrSTJ,"TJ_SITUACA = 'L'", cRet)

Return ''


=======
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
cRet += " TJ_SITUACA = 'B' "

cFilMbrSTJ := StrTran(cFilMbrSTJ,"TJ_SITUACA = 'L'", cRet)

Return ''


>>>>>>> 84be52ac3e12fd7d921443d11854559d89637e8a:377/JCA/Ponto_de_entrada/PE_MNTA420L.prw
