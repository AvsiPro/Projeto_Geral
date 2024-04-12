//---------------------------------------------------
/*/{Protheus.doc} JCAFilt
Filtro para consulta padrão JCA1.
@type function

@author Alexandre Santos
@since 14/02/2024

@param 
@return string, condição SQL para filtro de tarefas.
/*/
//---------------------------------------------------
User Function JCAFilt()

    Local cReturn := "@"

    If FWIsInCallStack( 'MNTA435' )

        dbSelectArea( 'STJ' )
        dbSetOrder( 1 )
        msSeek( FwxFilial('STJ') + (cAliOS435)->TJ_ORDEM )

        cReturn +=	"TT9_FILIAL = " + ValToSQL( FWxFilial( 'TT9' ) ) + " AND "
        cReturn +=	"( TT9_CARACT <> '1' OR ( EXISTS ( "
        cReturn +=	                                   "SELECT "
        cReturn +=                                        "1 "
        cReturn +=                                     "FROM "
        cReturn +=                                        RetSQLName( 'ST5' ) + " ST5 "
        cReturn +=                                     "WHERE "
        cReturn +=                                       "ST5.T5_FILIAL  = " + ValToSQL( FWxFilial( 'ST5' ) ) + " AND "
        cReturn +=                                       "ST5.T5_CODBEM  = " + ValToSQL( STJ->TJ_CODBEM )     + " AND "
        cReturn +=                                       "ST5.T5_SERVICO = " + ValToSQL( STJ->TJ_SERVICO )    + " AND "
        cReturn +=                                       "ST5.T5_SEQRELA = " + ValToSQL( STJ->TJ_SEQRELA )    + " AND "
        cReturn +=                                       "ST5.T5_TAREFA  = TT9_TAREFA                             AND "
        cReturn +=                                       "ST5.T5_ATIVA   = '1'                                    AND "
        cReturn +=                                       "ST5.D_E_L_E_T_ = ' ' ) ) ) AND "
        cReturn +=	"D_E_L_E_T_ = ' '

    EndIf

Return cReturn
