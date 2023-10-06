<<<<<<< HEAD:377/JCA/Ponto_de_entrada/MNTA420I.prw
#Include 'Totvs.ch'
#Include 'FwMVCDef.ch'

/*/{Protheus.doc} MNTA420I
   @description: menudef mnta420
   @type: User Function
   @author: Felipe Mayer
   @since: 20/09/2023
/*/
User Function MNTA420I()
    
Local aRot := ParamIxb[1]

aAdd(aRot, { 'Legenda' , "u_LEG420()" , 0 , 9,0, .F. })

Return aRot


User Function LEG420()

Local aLegenda := {}

    aAdd(aLegenda,{"BR_VERMELHO", "Bloqueado" })
    aAdd(aLegenda,{"BR_AMARELO" , "Pendente" })
    aAdd(aLegenda,{"BR_VERDE" , "Liberado" })
    aAdd(aLegenda,{"BR_CINZA" , "Cancelado" })
    
    BrwLegenda('', "Status", aLegenda)

Return
=======
#Include 'Totvs.ch'
#Include 'FwMVCDef.ch'

/*/{Protheus.doc} MNTA420I
   @description: menudef mnta420
   @type: User Function
   @author: Felipe Mayer
   @since: 20/09/2023
/*/
User Function MNTA420I()
    
Local aRot := ParamIxb[1]

aAdd(aRot, { 'Legenda' , "u_LEG420()" , 0 , 9,0, .F. })

Return aRot


User Function LEG420()

Local aLegenda := {}

    aAdd(aLegenda,{"BR_VERMELHO", "Bloqueado"  })
    aAdd(aLegenda,{"BR_AMARELO" , "Pendente" })
    aAdd(aLegenda,{"BR_VERDE" , "Liberado" })
    aAdd(aLegenda,{"BR_CINZA" , "Cancelado" })
    
    BrwLegenda('', "Status", aLegenda)

Return
>>>>>>> 84be52ac3e12fd7d921443d11854559d89637e8a:377/JCA/Ponto_de_entrada/PE_MNTA420I.prw
