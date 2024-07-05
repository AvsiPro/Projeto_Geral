 /*/{Protheus.doc} MNT40011
    Ponto de entrada para realizar o bloqueio de encerramento de OS
    na falta de apontamentos.
    @type  Function
    @author user
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function MNT40011

Local aArea     := GetArea()
Local lRet      := .T.
Local cOrdem    := STJ->TJ_ORDEM
Local lMObr     := .F.
Local lSoluc    := .T.
Local lExect    := .T.

DbSelectArea("STL")
DBSetOrder(1)
If Dbseek(xFilial("STL")+cOrdem)
    While !EOF() .And. STL->TL_ORDEM == cOrdem 
        If STL->TL_TIPOREG == "M"
            lMObr := .T.
        EndIF 
        Dbskip()
    EndDo 

    If !lMObr
        MsgAlert("N�o foi apontado m�o de obra na ordem de servi�o","MNT40011")
        lRet := .F.
    EndIF 
Else
    MsgAlert("N�o foram apontados os detalhes da ordem de servi�os","MNT40011")
    lRet := .F.
EndIF 

DbSelectArea("STN")
DBSetOrder(1)
If Dbseek(xFilial("STN")+cOrdem)
    //aqui que valida se a ocorrencia tem solu��o campo Solucao TN_SOLUCAO preenchido
    While !EOF() .AND. STN->TN_FILIAL == xFilial("STN") .AND. STN->TN_ORDEM == cOrdem
        If Empty(STN->TN_SOLUCAO)
            lSoluc := .F.
        EndIf 
        Dbskip()
    EndDo 

    If !lSoluc
        Msgalert("N�o foram apontadas Solu��es na ordem de servi�os","MNT40011")
        lRet := .F.
    EndIF 
Else
    MsgAlert("N�o foram apontadas as ocorr�ncias da ordem de servi�os","MNT40011")
    lRet := .F.
EndIF 

DbSelectArea("STQ")
DBSetOrder(1)
If DbSeek(xFilial("STQ")+cOrdem)
    //aqui precisa ver o executante na linha
    While !Eof() .And. STQ->TQ_FILIAL == xFilial("STQ") .And. STQ->TQ_ORDEM == cOrdem
        If Empty(STQ->TQ_CODFUNC)
            lExect := .F.
        ENDIF 
        Dbskip()   
    EndDo

    If !lExect
        MsgAlert("N�o foram apontados executantes das tarefas na ordem de servi�os","MNT40011")
        lRet := .F.
    EndIf 
/*else 
    MsgAlert("N�o foram apontadas as etapas da ordem de servi�os","MNT40011")
    lRet := .F.*/
EndIf 

RestArea(aArea)

Return(lRet)
