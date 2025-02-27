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
Local aTarefas  :=  {}

//Solicitado pelo Toninho em 19/08 para validar se todas as tarefas da STN est�o na STL
DbSelectArea("STN")
DBSetOrder(1)
If Dbseek(xFilial("STN")+cOrdem)
    //aqui que valida se a ocorrencia tem solu��o campo Solucao TN_SOLUCAO preenchido
    While !EOF() .AND. STN->TN_FILIAL == xFilial("STN") .AND. STN->TN_ORDEM == cOrdem
        If Empty(STN->TN_SOLUCAO)
            lSoluc := .F.
        EndIf 
        If Ascan(aTarefas,{|x| alltrim(x[1]) == Alltrim(STN->TN_TAREFA)}) == 0
            Aadd(aTarefas,{STN->TN_TAREFA,.f.})
        EndIf 
        Dbskip()
    EndDo 

    If !lSoluc
        Msgalert("N�o foram apontadas Solu��es na ordem de servi�os","MNT40011")
        lRet := .F.
    EndIF 
EndIF 

DbSelectArea("STL")
DBSetOrder(1)
If Dbseek(xFilial("STL")+cOrdem)
    While !EOF() .And. STL->TL_ORDEM == cOrdem 
        nPos := Ascan(aBaixSCP,{|x| x[1]+x[2]+x[3] == STL->TL_CODIGO+STL->TL_NUMSA+STL->TL_ITEMSA})
        If STL->TL_TIPOREG == "P" .And. nPos == 0
            Aadd(aBaixSCP,{STL->TL_CODIGO,STL->TL_NUMSA,STL->TL_ITEMSA})
        EndIf 

        nPos := Ascan(aTarefas,{|x| alltrim(x[1]) == alltrim(STL->TL_TAREFA)})
        
        If nPos > 0 .And. STL->TL_TIPOREG == "M"
            aTarefas[nPos,02] := .t.
        endIf 

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
            MsgAlert("N�o foi apontado m�o de obra na ordem de servi�o para a tarefa "+aMaoObra[nCont,01],"MNT40011")
            lRet := .F.
        EndIF
    Next nCont  

    cMsg := ""

    For nCont := 1 to len(aTarefas)
        If !aTarefas[nCont,02]
            cMsg += "Tarefa "+aTarefas[nCont,01]+" sem apontamento de m�o de obra "+CRLF
        EndIf 
    Next nCont 

    If !Empty(cMsg)
        MsgAlert(cMsg,"MNT40011")
        lRet := .F.
    EndIF 

    cMsgBaixa := ""
    cSCPSTL   := ""
    cBarraC   := ""
    cNumSCP   := ""
    DbSelectArea("SCP")
    DbSetOrder(2)
    For nCont := 1 to len(aBaixSCP)
        If Dbseek(xfilial("SCP")+aBaixSCP[nCont,01]+aBaixSCP[nCont,02]+aBaixSCP[nCont,03])
            cSCPSTL += cBarraC + aBaixSCP[nCont,01]+aBaixSCP[nCont,02]+aBaixSCP[nCont,03]
            cNumSCP := aBaixSCP[nCont,02]
            cBarraC := "/"
            If SCP->CP_STATUS <> 'E' .and. Empty(SCP->CP_XTIPO)
                cMsgBaixa += "Produto "+aBaixSCP[nCont,01]+" sem baixa na solicita��o ao armaz�m."+CRLF 
            EndIf 
        EndIf 
    Next nCont 

    DbSelectArea("SCP")
    DbSetOrder(5)
    If Dbseek(xFilial("SCP")+cOrdem)
        While !EOF() .AND. SCP->CP_FILIAL == xFilial("SCP") .And. Alltrim(SCP->CP_NUMOS) == cOrdem
            If !SCP->CP_PRODUTO+SCP->CP_NUM+SCP->CP_ITEM $ cSCPSTL
                If SCP->CP_STATUS <> 'E' .and. Empty(SCP->CP_XTIPO)
                    cMsgBaixa += "Produto "+SCP->CP_PRODUTO+" sem baixa na solicita��o ao armaz�m."+CRLF 
                EndIf 
            EndIf 
            Dbskip()
        EndDo
    EndIf  

    If !Empty(cMsgBaixa)
        Msgalert(cMsgBaixa,"MNT40011")
        lRet := .F.
    EndIf 
Else
    MsgAlert("N�o foram apontados os detalhes da ordem de servi�os","MNT40011")
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

//Valida��o solicitada pelo Toninho 01/11
/*
Quando do retorno mod.2, se tem uma ocorr�ncia cadastrada, o usu�rio dever� associar o insumo a suas ocorr�ncias. 
Hoje n�o est� realizando a valida��o se esta associa��o est� sendo realizada. 
*/
cOcorIns := ""
cBarra   := ""
For nCont := 1 to len(aCobrw3)
    If !Empty(aCobrw3[nCont,02]) .And. len(aCobrw3[nCont,11]) < 1
        cOcorIns += cBarra + " Ocorrencia "+aCobrw3[nCont,02]+" "+aCobrw3[nCont,03]+" sem associa��o com o insumo"
        cBarra := "/"
    EndIf 
Next nCont 

If !Empty(cOcorIns)

    MsgAlert(cOcorIns,"MNT40011")
    lRet := .F. 

EndIf 

RestArea(aArea)

Return(lRet)
