#include 'totvs.ch'

//---------------------------------------------------
/*/{Protheus.doc} MNTA1800
Atualiza data e contador da manuteção.
@type function

@author Alexandre Santos
@since 14/02/2024

@param 
@return
/*/
//---------------------------------------------------
User Function MNTA1800()

    Local cAlsSTF := GetNextAlias()
    Local cCodBem := ParamIXB[1]
    Local cCodSer := ParamIXB[2]
    Local nRecST5 := ParamIXB[3]

    dbSelectArea( 'ST5' )
    dbGoTo( nRecST5 )
 
    BeginSQL Alias cAlsSTF

        SELECT
            MAX( ST5.T5_DTULTMA ) AS T5_DTULTMA,
            MAX( ST5.T5_CONMANU ) AS T5_CONMANU
        FROM
            %table:STF% STF
        INNER JOIN
            %table:ST5% ST5 ON
                ST5.T5_FILIAL  = STF.TF_FILIAL        AND
                ST5.T5_CODBEM  = STF.TF_CODBEM        AND
                ST5.T5_SERVICO = STF.TF_SERVICO       AND
                ST5.T5_SEQRELA = STF.TF_SEQRELA       AND
                ST5.T5_TAREFA  = %exp:ST5->T5_TAREFA% AND  
                ST5.%NotDel%
        WHERE
            STF.TF_FILIAL  = %xFilial:STF% AND
            STF.TF_CODBEM  = %exp:cCodBem% AND
            STF.TF_SERVICO = %exp:cCodSer% AND 
            STF.TF_ATIVO   = 'N'           AND
            STF.%NotDel%

    EndSQL

    If (cAlsSTF)->( !EoF() )

        RecLock( 'ST5', .F. )

            ST5->T5_DTULTMA := SToD( (cAlsSTF)->T5_DTULTMA )
            ST5->T5_CONMANU := (cAlsSTF)->T5_CONMANU

        MsUnLock()

    EndIf

    (cAlsSTF)->( dbCloseArea() )

Return
