#Include 'Protheus.ch'
 
User Function MNTA420P()
 
    // Parâmetro
    nOPCX := ParamIxb[1] // Inclusão, Alteração ou Exclusão
 
    If nOPCX == 5
        Reclock("STJ",.F.)
        STJ->TJ_XSITUAC := ''
        STJ->(Msunlock())        
    EndIf
 
Return .T.
