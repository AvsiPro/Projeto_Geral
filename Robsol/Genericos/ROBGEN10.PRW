#INCLUDE 'PROTHEUS.CH'
#include "fileio.ch"
#include "topconn.ch"
#include "tbiconn.ch"

User Function ROBGEN10()

Private cArqTxt 	:=	'C:\000\CUSTO0101.txt'
Private nHandle1 	

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","0101")
Endif

nHandle1 	:=	FT_FUse(cArqTxt)

FT_FGoTop()

While !FT_FEOF() 
	cLine	:= FT_FReadLn() // Retorna a linha corrente  
    aAux    := separa(cLine,";")
    /*DbSelectArea("SB9")
    DbSetOrder(1)
    If Dbseek(aAux[1]+Avkey(AAux[2],"B9_COD")+'10120221231')
        While !EOF() .AND. Alltrim(SB9->B9_COD) == Alltrim(aAux[2]) .AND. SB9->B9_DATA == CTOD('31/12/2022')
            RecLock("SB9", .F.)
            SB9->B9_CM1     :=  val(aAux[3])
            SB9->B9_VINI1   :=  SB9->B9_QINI * SB9->B9_CM1
            SB9->(MsUnlock())
            Dbskip()
        EndDo 
    ENDIF*/
    DbSelectArea("SB2")
    DbSetOrdeR(1)
    If DbSeek(aAux[1]+Avkey(aAux[2],"B2_COD"))
        While !EOF() .AND. SB2->B2_FILIAL == aAux[1] .And. Alltrim(SB2->B2_COD) == aAux[2]
            RecLock("SB2", .F.)
            SB2->B2_CM1     :=  val(aAux[3])
            SB2->(Msunlock())
            Dbskip()
        EndDo 
    EndIf 
    FT_FSKIP()
End

RETURN
