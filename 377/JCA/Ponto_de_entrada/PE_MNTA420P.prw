#Include 'Protheus.ch'
/*
    PE para limpar campo que indica que uma OP esta bloqueada ao cancelar uma OS 
    utilizado em conjunto com os PE´s de legendas
    Alexandre 01/12/24    
    
*/
User Function MNTA420P()
 
    // Parâmetro
    nOPCX := ParamIxb[1] // Inclusão, Alteração ou Exclusão
 
    If nOPCX == 5
        Reclock("STJ",.F.)
        STJ->TJ_XSITUAC := ''
        STJ->(Msunlock())        
    EndIf
 
Return .T.
