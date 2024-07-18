
#INCLUDE 'PROTHEUS.CH'
/////////////////////////////////////////////////////////////////////////////////
//    Ponto de entrada na rotina de solicitação ao armazem                     // 
//                                                                             // 
//    Utilizado para validar se a peça que esta sendo incluida na os vinda do  //
// GFR entra na regra de bloqueio por tempo de uso ou contador de km           // 
/////////////////////////////////////////////////////////////////////////////////
// Alexandre Venancio - 17/07/24 - criação                                     //
/////////////////////////////////////////////////////////////////////////////////

User Function MT105FIM()

Local nOpcao := PARAMIXB 
Local nPosI := Ascan(aHeader,{|x| alltrim(x[2]) == "CP_ITEM"})
Local nPosS := Ascan(aHeader,{|x| alltrim(x[2]) == "CP_SALBLQ"})
Local nPosX := Ascan(aHeader,{|x| alltrim(x[2]) == "CP_XORIGEM"})
Local nPosQ := Ascan(aHeader,{|x| alltrim(x[2]) == "CP_QUANT"})
Local nPosO := Ascan(aHeader,{|x| alltrim(x[2]) == "CP_OP"})
Local nCont := 0

If Funname() == "MATA105" .And. nOpcao == 1
    For nCont := 1 to len(aCols)
        If aCols[nCont,nPosS] == aCols[nCont,nPosQ] .And. !Empty(aCols[nCont,nPosX]) .And. !Empty(aCols[nCont,nPosO])
            DbSelectArea("SCP")
            DbSetOrder(1)
            If Dbseek(xFilial("SCP")+CA105num+aCols[nCont,nPosI])
                Reclock("SCP",.F.)
                SCP->CP_STATSA  := 'B'
                SCP->(MsUnlock())
            EndIf 
        EndIf 
    Next nCont 
EndIf 

Return
