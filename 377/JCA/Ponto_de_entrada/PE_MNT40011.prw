 #INCLUDE 'PROTHEUS.CH'
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
//Local lMObr     := .F.
Local lSoluc    := .T.
Local lExect    := .T.
Local aMaoObra  := {}
Local aBaixSCP  := {}
Local nCont 

DbSelectArea("STL")
DBSetOrder(1)
If Dbseek(xFilial("STL")+cOrdem)
    While !EOF() .And. STL->TL_ORDEM == cOrdem 
        nPos := Ascan(aBaixSCP,{|x| x[1]+x[2]+x[3] == STL->TL_CODIGO+STL->TL_NUMSA+STL->TL_ITEMSA})
        If STL->TL_TIPOREG == "P" .And. nPos == 0
            Aadd(aBaixSCP,{STL->TL_CODIGO,STL->TL_NUMSA,STL->TL_ITEMSA})
        EndIf 

        nPos := Ascan(aMaoObra,{|x| x[1] == STL->TL_TAREFA}) 
        If nPos == 0
            Aadd(aMaoObra,{STL->TL_TAREFA,If(STL->TL_TIPOREG == "M",.T.,.F.)})
        Else 
            If !aMaoObra[nPos,02]
                aMaoObra[nPos,02] := If(STL->TL_TIPOREG == "M",.T.,.F.)
            EndIf 
        EndIf 
        /*If STL->TL_TIPOREG == "M"
            lMObr := .T.
        EndIF*/ 
        Dbskip()
    EndDo 

    For nCont := 1 to len(aMaoObra)
        //If !lMObr
        If !aMaoObra[nCont,02]
            MsgAlert("Não foi apontado mão de obra na ordem de serviço para a tarefa "+aMaoObra[nCont,01],"MNT40011")
            lRet := .F.
        EndIF
    Next nCont  

    cMsgBaixa := ""

    DbSelectArea("SCP")
    DbSetOrder(2)
    For nCont := 1 to len(aBaixSCP)
        If Dbseek(xfilial("SCP")+aBaixSCP[nCont,01]+aBaixSCP[nCont,02]+aBaixSCP[nCont,03])
            If SCP->CP_STATUS <> 'E' .and. Empty(SCP->CP_XTIPO)
                cMsgBaixa += "Produto "+aBaixSCP[nCont,01]+" sem baixa na solicitação ao armazém."+CRLF 
            EndIf 
        EndIf 
    Next nCont 

    If !Empty(cMsgBaixa)
        Msgalert(cMsgBaixa,"MNT40011")
        lRet := .F.
    EndIf 
Else
    MsgAlert("Não foram apontados os detalhes da ordem de serviços","MNT40011")
    lRet := .F.
EndIF 

DbSelectArea("STN")
DBSetOrder(1)
If Dbseek(xFilial("STN")+cOrdem)
    //aqui que valida se a ocorrencia tem solução campo Solucao TN_SOLUCAO preenchido
    While !EOF() .AND. STN->TN_FILIAL == xFilial("STN") .AND. STN->TN_ORDEM == cOrdem
        If Empty(STN->TN_SOLUCAO)
            lSoluc := .F.
        EndIf 
        Dbskip()
    EndDo 

    If !lSoluc
        Msgalert("Não foram apontadas Soluções na ordem de serviços","MNT40011")
        lRet := .F.
    EndIF 
/*Else
    MsgAlert("Não foram apontadas as ocorrências da ordem de serviços","MNT40011")
    lRet := .F.*/
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
        MsgAlert("Não foram apontados executantes das tarefas na ordem de serviços","MNT40011")
        lRet := .F.
    EndIf 
/*else 
    MsgAlert("Não foram apontadas as etapas da ordem de serviços","MNT40011")
    lRet := .F.*/
EndIf 

RestArea(aArea)

Return(lRet)
