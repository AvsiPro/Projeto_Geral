
#INCLUDE 'PROTHEUS.CH'
/////////////////////////////////////////////////////////////////////////////////
//    Ponto de entrada na rotina de solicita��o ao armazem                     // 
//                                                                             // 
//    Utilizado para validar se a pe�a que esta sendo incluida na os vinda do  //
// GFR entra na regra de bloqueio por tempo de uso ou contador de km           // 
/////////////////////////////////////////////////////////////////////////////////
// Alexandre Venancio - 17/07/24 - cria��o                                     //
/////////////////////////////////////////////////////////////////////////////////

User Function MT105FIM()

Local lBloq := .F. 
Local nPosI := Ascan(aHeader,{|x| alltrim(x[2]) == "CP_ITEM"})
Local nPosS := Ascan(aHeader,{|x| alltrim(x[2]) == "CP_SALBLQ"})
Local nPosX := Ascan(aHeader,{|x| alltrim(x[2]) == "CP_XORIGEM"})
Local nPosQ := Ascan(aHeader,{|x| alltrim(x[2]) == "CP_QUANT"})
Local nPosO := Ascan(aHeader,{|x| alltrim(x[2]) == "CP_OP"})
Local nPosP := Ascan(aHeader,{|x| alltrim(x[2]) == "CP_PRODUTO"})

Local nCont := 0
Local cItens:= ""
Local cBarra := ""

If Funname() == "MATA105" 
    For nCont := 1 to len(aCols)
        If aCols[nCont,nPosS] == aCols[nCont,nPosQ] .And. !Empty(aCols[nCont,nPosX]) .And. !Empty(aCols[nCont,nPosO])
            DbSelectArea("SCP")
            DbSetOrder(1)
            If Dbseek(xFilial("SCP")+CA105num+aCols[nCont,nPosI])
                Reclock("SCP",.F.)
                SCP->CP_STATSA  := 'B'
                SCP->(MsUnlock())
                lBloq := .T.
                cItens += cBarra + Alltrim(aCols[nCont,nPosP])
                cBarra := "/"

            EndIf 
                
        EndIf 
    Next nCont 

    If lBloq
        MsgAlert("Item(ns) "+cItens+" ser�(�o) bloqueado(s) devido a regra de tempo x contadores","MT105FIM")
    EndIf 

EndIf 

Return
