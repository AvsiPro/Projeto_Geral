#include "TOTVS.CH"
#include "fileio.ch"
#Include "Restful.Ch"
#include "FWMVCDEF.CH"
#Include "topconn.ch"
#Include "tbiconn.ch"
#include "fileio.ch"

User Function ROBCMS05

Local cArqTxt   :=  'C:\000\999.txt'
Local aCabec    :=  {}
Local aItens    :=  {}
Local nPos      :=  0
Local nX        :=  0
Private nHandle :=	FT_FUse(cArqTxt) 

RpcSetType(3)
RPCSetEnv("01","0104")

If nHandle > 0
    While !FT_FEOF()                                              
        cLine	:= FT_FReadLn() // Retorna a linha corrente  
        aAux    := StrTokArr(cLine,";")
        If nPos == 0
            Aadd(aCabec,aAux)
            nPos++
        Else
            Aadd(aItens,aAux)
        EndIf 
        FT_FSKIP()
    ENDDO
EndIf

DbSelectArea("Z32")

For nX := 1 to len(aItens)
    Reclock("Z32",.T.)
    For nPos := 1 to len(aCabec[1])
        aAux := FWSX3Util():GetFieldStruct( aCabec[1,nPos] )
        &("Z32->"+Alltrim(aCabec[1,nPos])) := If(aAux[2]=="N",val(aItens[nX,nPos]),If(aAux[2]=="D",stod(aItens[nX,nPos]),aItens[nX,nPos]))
    Next nPos
    Z32->(Msunlock())
Next nX 

Return
