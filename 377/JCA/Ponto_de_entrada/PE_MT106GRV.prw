#INCLUDE 'PROTHEUS.CH'

/*
    Ponto de entrada para validar saldo dos itens da pre-requisição e gravar vendas perdidas por falta de saldo.
    MIT 44_ESTOQUE_EST009 - Rotina para apurar as vendas perdidas e consulta
    MIT 44_ESTOQUE_EST012 - Processamento rotina gerar pre-requisição de forma automática
    
    Doc Mit
    https://docs.google.com/document/d/19LU8dgLuT44NOOVOlN3fwa9iECYmcjHm/edit
    Doc Entrega
    
    
*/

User Function MT106GRV

Local aArea     :=  GetArea()
Local cCodPai   :=  Posicione("SB1",1,xFilial("SB1")+SCP->CP_PRODUTO,"B1_XCODPAI")
Local lSldFil   :=  .F.
Local aAreaB1   :=  {}
Local cOsSTJ    :=  If(!Empty(SCP->CP_OP),Posicione("STJ",1,SCP->CP_FILIAL+SUBSTR(SCP->CP_OP,1,6),"TJ_TERMINO"),"")
Local cDtEnc    :=  If(cOsSTJ=="S",Posicione("STJ",1,SCP->CP_FILIAL+SUBSTR(SCP->CP_OP,1,6),"TJ_DTMRFIM"),"")

If !Empty(cOsSTJ) .And. cOsSTJ == "S"
    MsgAlert("OP/OS já encerrada em "+cvaltochar(cDtEnc)+" - Procure o setor responsável","MT106GRV")
    Return(.F.)
EndIF 

DbSelectArea("SB2")
DbSetOrder(1)

If Empty(cCodPai)

    DbSelectArea("SB1")
    DbSetOrder(1)

    While !EOF() .And. Substr(SB1->B1_COD,1,8) == Alltrim(cCodPai)

        aAreaB1 := GetArea()

        DbSelectArea("SB2")
        DbSetOrder(1)

        If Dbseek(SCP->CP_FILIAL+SB1->B1_COD+SCP->CP_LOCAL)
            nSaldo := SaldoSB2()

            If nSaldo >= SCP->CP_QUANT 
                lSldFil := .T.
            EndIf 
        EndIf

        RestArea(aAreaB1)
        
        Dbskip()
    EndDo
Else 
    DbSelectArea("SB2")
    DbSetOrder(1)

    If Dbseek(SCP->CP_FILIAL+SCP->CP_PRODUTO+SCP->CP_LOCAL)
        nSaldo := SaldoSB2()

        If nSaldo >= SCP->CP_QUANT 
            lSldFil := .T.
        EndIf 
    EndIf
EndIf 

If !lSldFil 
    cServ := Posicione("STJ",1,xFilial("STJ")+SUBSTR(SCP->CP_OP,1,6),"TJ_SERVICO")
    
    Reclock("ZPC",.T.)
    ZPC->ZPC_FILIAL := SCP->CP_FILIAL 
    ZPC->ZPC_CODIGO := SCP->CP_PRODUTO 
    ZPC->ZPC_REQUIS := SCP->CP_NUM 
    ZPC->ZPC_DATA   := dDatabase
    ZPC->ZPC_QUANT  := SCP->CP_QUANT 
    ZPC->ZPC_PREFIX := SCP->CP_OBS
    ZPC->ZPC_SOLICI := SCP->CP_XMATREQ
    ZPC->ZPC_STATUS := '1'
    ZPC->ZPC_ITEM   := SCP->CP_ITEM
    ZPC->ZPC_LOCAL  := SCP->CP_LOCAL
    ZPC->ZPC_ALMOXA := SCP->CP_CODSOLI
    ZPC->ZPC_TIPO   := SCP->CP_XTIPO
    ZPC->ZPC_OS     := SUBSTR(SCP->CP_OP,1,6)
    ZPC->ZPC_PLACA  := Posicione("ST9",1,xFilial("ST9")+Alltrim(SCP->CP_OBS),"T9_PLACA")
    ZPC->ZPC_ORIGEM := Posicione("STJ",1,xFilial("STJ")+SUBSTR(SCP->CP_OP,1,6),"TJ_ZCORIGE")
    ZPC->ZPC_PRECOR := If(!Empty(cServ),Posicione("STE",1,xFilial("STE")+cServ,"TE_CARACTE"),"")
    ZPC->(Msunlock())
EndIf 

RestArea(aArea)

Return
