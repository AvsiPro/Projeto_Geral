
#Include 'Protheus.ch'
/*
    Ponto de entrada documento de entrada no momento da confirmação de inclusão
    Utilizado para gerar a movimentação bancaria das PA´s IPA
    Alexandre Venancio 10/06/2025 TNU
*/
USER FUNCTION MTA103OK() 

Local lRet   := ParamIxb[1]  
Local nPosPc := Ascan(aHeader,{|x| alltrim(x[2]) == "D1_PEDIDO"})
Local nCont  := 0
Local aPcF   := {}

Public aTitF  := {}
Public lBxPP := .F.

If nPosPc > 0
    For nCont := 1 to len(aCols)
        If Ascan(aPcF,aCols[nCont,nPosPc]) == 0
            Aadd(aPcF,aCols[nCont,nPosPc])
        EndIf 
    Next nCont 

    For nCont := 1 to len(aPcF)
        DbselectArea("FIE")
        DbSetOrder(1)
        If Dbseek(xFilial("FIE")+"P"+aPcF[nCont])
            If Ascan(aTitF,{|x| x[1] == FIE->FIE_FILIAL+FIE->FIE_PREFIX+FIE->FIE_NUM+FIE->FIE_PARCEL+'PP '+FIE->FIE_FORNEC+FIE->FIE_LOJA}) == 0
                AadD(aTitF,{FIE->FIE_FILIAL+FIE->FIE_PREFIX+FIE->FIE_NUM+FIE->FIE_PARCEL+'PP '+FIE->FIE_FORNEC+FIE->FIE_LOJA,.F.,0,0,'',0})
            EndIf
        EndIf 
    Next nCont 

    For nCont := 1 to len(aTitF)
        DbselectArea("SE2")
        DbSetOrder(1)
        If Dbseek(aTitF[nCont,01])
            
            
            //Se existir, Compensa o titulo de PP para o mesmo banco.
            //Se não existir, compensa contra o CX1
            DbselectArea("SE5")
            DbSetOrder(7)
            If Dbseek(SE2->E2_FILIAL+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA)
                Reclock("SE5",.F.)
                aTitF[nCont,05] := SE5->E5_TIPODOC
                aTitF[nCont,06] := SE5->(Recno())
                SE5->E5_TIPO := 'PA '
                SE5->E5_TIPODOC := 'PA '
                SE5->(Msunlock())
            Else
                Reclock("SE5",.T.)
                SE5->E5_FILIAL  := SE2->E2_FILIAL
                SE5->E5_DATA    := ddatabase
                SE5->E5_TIPO    := 'PA ' //SE2->E2_TIPO
                SE5->E5_MOEDA   := '01'
                SE5->E5_VALOR   := SE2->E2_VALOR
                SE5->E5_NATUREZ := SE2->E2_NATUREZ
                SE5->E5_BANCO   := 'CX1'
                SE5->E5_AGENCIA := ''
                SE5->E5_CONTA   := ''
                SE5->E5_RECPAG  := 'P'
                SE5->E5_BENEF   := Posicione("SA2",1,xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,"A2_NREDUZ")
                SE5->E5_TIPODOC := 'PA ' //SE2->E2_TIPO
                SE5->E5_VLMOED2 := SE2->E2_VALOR
                SE5->E5_PREFIXO := SE2->E2_PREFIXO
                SE5->E5_NUMERO  := SE2->E2_NUM
                SE5->E5_PARCELA := SE2->E2_PARCELA
                SE5->E5_CLIFOR  := SE2->E2_FORNECE
                SE5->E5_LOJA    := SE2->E2_LOJA
                SE5->E5_DTDIGIT := ddatabase
                SE5->E5_MOTBX   := 'NOR'
                SE5->E5_DTDISPO := ddatabase
                SE5->E5_FILORIG := SE2->E2_FILIAL
                SE5->E5_FORNECE := SE2->E2_FORNECE
                SE5->E5_ORIGEM  := 'FINA750'
                SE5->(Msunlock())
            EndIf 

            lBxPP := .T.
            aTitF[nCont,02] := .T.
            Reclock("SE2",.F.)
            aTitF[nCont,03] := SE2->E2_SALDO
            aTitF[nCont,04] := SE2->(Recno())
            SE2->E2_TIPO := 'PA '
            SE2->E2_SALDO := SE2->E2_VALOR
            SE2->(Msunlock())
        EndIf 
    Next nCont 
EndIf 

Return (lRet)
