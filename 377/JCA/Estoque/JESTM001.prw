#INCLUDE 'PROTHEUS.CH'

/*
    Rotina para baixar solicitação ao armazem através da rotina MATA105
    MIT 44_ESTOQUE_EST007 - Disponibilizar a função MATA185_ na rotina MATA105

    DOC MIT
    https://docs.google.com/document/d/1dlQRDeN7U-eV75WHKPuRECyNwm4zM9VL/edit
    DOC Entrega
    
    
*/

User Function JESTM001(cNumSCP)

Local aArea     :=  Getarea()    

Local aITEM         := {}
Local nx
Local aLinhasSCP    := {}
Local aLinhasSD3    := {}
Local aAutoSCP      := {}
Local aAutoSD3      := {}
Local cD3TM         := '501'
Local aAux2         := {}

DbSelectArea("SCP")
DbSetOrder(1)
If Dbseek(xFilial("SCP")+cNumSCP)
    While !EOF() .AND. SCP->CP_FILIAL == CFILANT .AND. SCP->CP_NUM == cNumSCP
        If Empty(SCP->CP_XTIPO) .And. SCP->CP_STATUS <> 'E'
            Aadd(aITEM,{SCP->CP_ITEM,SCP->CP_PRODUTO,SCP->CP_UM,SCP->CP_QUANT,SCP->CP_LOCAL})
        EndIf 
        Dbskip()
    EndDo
EndIf 

If len(aITEM)

    pergunte ('MTA185',.f.)

    /*if MV_PAR01 = 1
        conout ('o F12 da rotina mata185 "BAIXA POR ?" esta como "baixa por item"')
    else
        conout ('o F12 da rotina mata185 "BAIXA POR ?" esta como "baixa por Toda a pre-req"')
    endif*/

    For nX := 1 to len(aITEM)

        aadd(aLinhasSCP,{"CP_NUM"       ,cNumSCP               ,Nil})
        aadd(aLinhasSCP,{"CP_ITEM"      ,aITEM[nX,01]       ,Nil})
        aadd(aLinhasSCP,{"CP_PRODUTO"   ,aITEM[nX,02]       ,Nil})
        aadd(aLinhasSCP,{"CP_UM"        ,aITEM[nX,03]       ,Nil})
        aadd(aLinhasSCP,{"CP_QUANT"     ,aITEM[nX,04]       ,Nil})

        aAdd(aAutoSCP,aClone(aLinhasSCP))
        aLinhasSCP:= {}

        aadd(aLinhasSD3,{"D3_TM"        ,cD3TM              ,Nil})
        aadd(aLinhasSD3,{"D3_COD"       ,aITEM[nX,02]       ,Nil})
        aadd(aLinhasSD3,{"D3_LOCAL"     ,aITEM[nX,05]       ,Nil})
        aadd(aLinhasSD3,{"D3_EMISSAO"   ,ddatabase          ,Nil})
        
        aAdd(aAutoSD3,aClone(aLinhasSD3))
        aLinhasSD3:={}
    Next nX
    //1 = "Baixar"
    //2 = "Estorno"
    //5 = "Excluir"
    //6 = "Encerrar"

    dbSelectArea("SCP")
    dbSelectArea("SCQ")
    dbSelectArea("SD3")

    // Baixa de Pré-Requisições.    

    dbSelectArea("SCP")
    dbSetOrder(1)
    For nX := 1 to len(aAutoSCP)
        nPosItm := Ascan(aAutoSCP[nX],{|x| x[1] == "CP_ITEM"})

        If SCP->(dbSeek(xFilial("SCP")+cNumSCP+aAutoSCP[nX,nPosItm,02])) //+aITEM[nx]
            lMSHelpAuto := .F.
            lMsErroAuto := .F.
            MV_PAR01 := 1
            MV_PAR02 := 2
            MV_PAR03 := 'N'

            nSaldo := 0
            DbSelectArea("SB2")
            DbSetOrder(1)
            If Dbseek(xFilial("SB2")+SCP->CP_PRODUTO+SCP->CP_LOCAL)
                nSaldo := SaldoSB2()
                aAux2  := {}

                If nSaldo < SCP->CP_QUANT
                    Aadd(aAux2,{ SCP->CP_PRODUTO,;
                        Posicione("SB1",1,xFilial("SB1")+SCP->CP_PRODUTO,"B1_DESC"),;
                        SCP->CP_QUANT,;
                        (nSaldo - SCP->CP_QUANT) * (-1),;
                        "",;
                        "",;
                        SCP->(Recno())})
                    
                    //U_JGENX006(aAux2)

                EndIf 
            EndIf 

            MSExecAuto({|v,x,y,z| mata185(v,x,y)},aAutoSCP[nx],aAutoSD3[nx],1)  // 1 = BAIXA (ROT.AUT)

            If lMsErroAuto
                Mostraerro()
            Else
                MsgAlert("Processo de baixa finalizado!!!")
            EndIf
        Else
            Aviso("SIGAEST", "Req. nao encontrada", {" Ok "})  
        EndIf
    Next nX

    
EndIf 



RestArea(aArea)

Return
