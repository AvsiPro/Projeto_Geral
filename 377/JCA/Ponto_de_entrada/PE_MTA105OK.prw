#INCLUDE 'PROTHEUS.CH'
/////////////////////////////////////////////////////////////////////////////////
//    Ponto de entrada na rotina de solicitação ao armazem                     // 
//                                                                             // 
//    Utilizado para validar se a peça que esta sendo incluida na os vinda do  //
// GFR entra na regra de bloqueio por tempo de uso ou contador de km           // 
/////////////////////////////////////////////////////////////////////////////////
// Alexandre Venancio - 10/06/24 - criação                                     //
/////////////////////////////////////////////////////////////////////////////////

User Function MTA105OK

Local aArea := GetArea()
Local lRet  := .T.

Local lBloq := .F.
Local nPosR := Ascan(aHeader,{|x| alltrim(x[2]) == "CP_REC_WT"})
Local nPosP := Ascan(aHeader,{|x| alltrim(x[2]) == "CP_PRODUTO"})
Local nPosO := Ascan(aHeader,{|x| alltrim(x[2]) == "CP_OP"})
Local nCont := 1

For nCont := 1 to len(aCols)
    If aCols[nCont,nPosR] == 0 .AND. !Empty(aCols[n,nPosP])
        cOrdem := SUBSTR(aCols[n,nPosO],1,6)
        cCodBem := Posicione("STJ",1,xFilial("STJ")+cOrdem,"TJ_CODBEM")
        If !Empty(cOrdem)
            lBloq := U_xvld105(aCols[nCont,nPosP],cCodBem)
        endif

        If lBloq 
            MsgAlert("Item "+alltrim(aCols[nCont,nPosP])+" será bloqueado devido a regra de tempo x contadores","MTA105LIN")
        EndIf 
    EndIf 
Next nCont

RestArea(aArea)

Return(lRet)
