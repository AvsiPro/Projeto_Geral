#INCLUDE 'PROTHEUS.CH'

/*
    Rotina para baixar solicita��o ao armazem atrav�s da rotina MATA105
    MIT 44_ESTOQUE_EST007 - Disponibilizar a fun��o MATA185_ na rotina MATA105

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

DbSelectArea("SCP")
DbSetOrder(1)
If Dbseek(xFilial("SCP")+cNumSCP)
    While !EOF() .AND. SCP->CP_FILIAL == CFILANT .AND. SCP->CP_NUM == cNumSCP
        Aadd(aITEM,{SCP->CP_ITEM,SCP->CP_PRODUTO,SCP->CP_UM,SCP->CP_QUANT,SCP->CP_LOCAL})
        Dbskip()
    EndDo
EndIf 

If len(aITEM)

    pergunte ('MTA185',.f.)

    if MV_PAR01 = 1
        conout ('o F12 da rotina mata185 "BAIXA POR ?" esta como "baixa por item"')
    else
        conout ('o F12 da rotina mata185 "BAIXA POR ?" esta como "baixa por Toda a pre-req"')
    endif

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

    // Baixa de Pr�-Requisi��es.    

    dbSelectArea("SCP")
    dbSetOrder(1)
    If SCP->(dbSeek(xFilial("SCP")+cNumSCP)) //+aITEM[nx]
        lMSHelpAuto := .F.
        lMsErroAuto := .F.
        MSExecAuto({|v,x,y,z| mata185(v,x,y)},aAutoSCP[1],aAutoSD3[1],1)  // 1 = BAIXA (ROT.AUT)

        If lMsErroAuto
            Mostraerro()
        EndIf
    Else
        Aviso("SIGAEST", "Req. nao encontrada", {" Ok "})  
    EndIf

EndIf 

RestArea(aArea)

Return
