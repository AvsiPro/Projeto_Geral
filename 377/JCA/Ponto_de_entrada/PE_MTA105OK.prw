#INCLUDE 'PROTHEUS.CH'
/////////////////////////////////////////////////////////////////////////////////
//    Ponto de entrada na rotina de solicita��o ao armazem                     // 
//                                                                             // 
//    Utilizado para validar se a pe�a que esta sendo incluida na os vinda do  //
// GFR entra na regra de bloqueio por tempo de uso ou contador de km           // 
/////////////////////////////////////////////////////////////////////////////////
// Alexandre Venancio - 10/06/24 - cria��o                                     //
/////////////////////////////////////////////////////////////////////////////////

User Function MTA105OK

Local aArea := GetArea()
Local lRet  := .T.

Local lBloq := .T.
Local nPosP := Ascan(aHeader,{|x| alltrim(x[2]) == "CP_PRODUTO"})
Local nPosO := Ascan(aHeader,{|x| alltrim(x[2]) == "CP_OP"})
Local nPosS := Ascan(aHeader,{|x| alltrim(x[2]) == "CP_SALBLQ"})
Local nPosX := Ascan(aHeader,{|x| alltrim(x[2]) == "CP_XORIGEM"})
Local nPosQ := Ascan(aHeader,{|x| alltrim(x[2]) == "CP_QUANT"})
Local nCont := 1

For nCont := 1 to len(aCols)
    
    iF !Empty(aCols[n,nPosP])
        cOrdem := SUBSTR(aCols[n,nPosO],1,6)
        cCodBem := Posicione("STJ",1,xFilial("STJ")+cOrdem,"TJ_CODBEM")
        cContad := Posicione("STJ",1,xFilial("STJ")+cOrdem,"TJ_POSCONT")
        If !Empty(cOrdem)
            lBloq := U_xvld105(aCols[nCont,nPosP],cCodBem,cOrdem,cContad)
        endif

        If !lBloq 
            
            If Funname() == "MATA105"
                MsgAlert("Item "+alltrim(aCols[nCont,nPosP])+" ser� bloqueado devido a regra de tempo x contadores","MTA105OK")
                aCols[nCont,nPosS] := aCols[nCont,nPosQ]
                aCols[nCont,nPosX] := Alltrim(Funname())
            EndIf 
        EndIf 
    EndIf 
Next nCont

RestArea(aArea)

Return(lRet)

