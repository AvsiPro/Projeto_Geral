#Include 'Protheus.ch'
 
User Function MNTA420P()
 
    // Par�metro
    nOPCX := ParamIxb[1] // Inclus�o, Altera��o ou Exclus�o
 
    If nOPCX == 5
        Reclock("STJ",.F.)
        STJ->TJ_XSITUAC := ''
        STJ->(Msunlock())        
    EndIf
 
Return .T.
