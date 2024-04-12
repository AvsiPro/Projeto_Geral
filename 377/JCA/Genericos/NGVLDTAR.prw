#include 'protheus.ch'

//---------------------------------------------------
/*/{Protheus.doc} MNTA1803
Validação de tarefa.
@type function

@author Alexandre Santos
@since 14/02/2024

@param 
@return
/*/
//---------------------------------------------------
User Function NGVLDTAR()

    Local cPrefix := ParamIXB[1]
    Local cCodTar := ParamIXB[2]
    Local lRet    := .F.

    dbSelectArea( 'TT9' )
    dbSetOrder( 1 )
    If msSeek( FWxFilial( 'TT9' ) + cCodTar )

        If TT9->TT9_CARACT == '1'

            lRet := ExistCPO( 'ST5', cPrefix + cCodTar, 1 )

        Else

            lRet := .T.

        EndIf

    Else

        lRet := ExistCPO( 'TT9', cCodTar, 1 )

    EndIf

Return lRet
