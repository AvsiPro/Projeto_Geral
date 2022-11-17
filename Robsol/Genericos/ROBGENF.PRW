

#INCLUDE 'PROTHEUS.CH'
#include "fileio.ch"
#include "topconn.ch"
#include "tbiconn.ch"

User function Robgenf

Local aCabec        :=  {}
Local aItens        :=  {}
Local ncont         :=  1
Local nX            :=  1
Private cArqTxt 	:=	'c:\000\CD5IMP2.csv'
Private nHandle1 	:=	FT_FUse(cArqTxt)

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","0103")
Endif

// Posiciona na primeria linha
FT_FGoTop()

While !FT_FEOF() 
	cLine	:= FT_FReadLn() // Retorna a linha corrente  
    aAux    := separa(cLine,";")
    if ncont == 1
        Aadd(aCabec,aAux)
    Else 
        Aadd(aItens,aAux)
    EndIf 
    nCont++
    FT_FSKIP()
End

DbSelectArea("CD5")

    For nCont := 1 to len(aItens)
        Reclock("CD5",.T.)
        For nX := 1 to len(aCabec[1])
            aAux := FWSX3Util():GetFieldStruct( aCabec[1,nX] )
            if len(aAux) > 0
                If aAux[2] == "N"
                    &("CD5->"+aCabec[1,nX]) := val(aItens[nCont,nX])
                ElseIf aAux[2] == "D"  
                    &("CD5->"+aCabec[1,nX]) := ctod(aItens[nCont,nX])

                Else
                    &("CD5->"+aCabec[1,nX]) := aItens[nCont,nX]
                EndIf 
            EndIf
        Next nX
        CD5->(MsUnlock())
    Next nCont 

return
