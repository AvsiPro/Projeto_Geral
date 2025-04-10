//Bibliotecas
#Include "TOTVS.ch"
 
/*/{Protheus.doc} WZSTAMP
Criação de campos S_T_A_M_P_ e I_N_S_D_T
@type user function
@author Alexandre Venancio
@since 09/04/2025
@param cTabAlias, Caractere, Alias da tabela (exemplo SB1)
@param lStamp, Lógico, Se .T. tenta criar o campo S_T_A_M_P_
@param lInsDt, Lógico, Se .T. tenta criar o campo I_N_S_D_T_
@example
u_zStamp("SB1")
 
/*/
User Function WZSTAMP(cTabAlias, lStamp, lInsDt)

    Local cTabSQL     := ""
    Local lOkStamp    := .F.
    Local lOkInsDt    := .F.
    Default cTabAlias := ""
    Default lStamp    := .T.
    Default lInsDt    := .T.
 
    //Se veio algum alias e ele existir na base
    If ! Empty(cTabAlias) .And. ExisteSX2(cTabAlias)
         
        //Valida se consegue ativar o recurso no BD
        lOkStamp    := (lStamp .And. (TCConfig('SETAUTOSTAMP = ON') == 'OK') .And. (TCConfig('SETUSEROWSTAMP = ON') == 'OK'))
        lOkInsDt    := (lInsDt .And. (TCConfig('SETAUTOINSDT = ON') == 'OK') .And. (TCConfig('SETUSEROWINSDT = ON') == 'OK'))
        If lOkStamp .Or. lOkInsDt
 
            //Busca o nome real da tabela, exemplo SB1 => SB1010
            cTabSQL := RetSQLName(cTabAlias)
 
            //Se a tabela já estiver aberta, fecha para depois abrir em modo exclusivo
            If Select(cTabAlias) > 0
                (cTabAlias)->(DbCloseArea())
            EndIf
 
            //Tenta Abrir em modo Exclusivo
            USE (cTabSQL) ALIAS (cTabAlias) EXCLUSIVE NEW VIA "TOPCONN"
            
            If ! NetErr()
 
                //Aciona o Refresh na tabela
                TCRefresh(cTabSQL)
 
            Else
                FWAlertError('Tabela "' + cTabAlias + '" - não foi possível abrir em modo Exclusivo', 'Falha #1')
            EndIf
            (cTabAlias)->(DbCloseArea())
 
            //Desativa os recursos
            TCConfig('SETAUTOSTAMP = OFF')
            TCConfig('SETUSEROWSTAMP = OFF')
 
        //Senão, não será possível criar os campos
        Else
            FWAlertError('Não foi possível ativar os recursos no BD', 'Falha #2')
        EndIf
    EndIf
 
Return
