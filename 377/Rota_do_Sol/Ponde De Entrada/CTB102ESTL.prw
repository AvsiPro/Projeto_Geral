#INCLUDE "PROTHEUS.CH" 

User Function CTB102ESTL() 
// nopc = 5 -> exclusao// nopc = 6 -> estorno
//Local nOpc := ParamIXB[1] 
Local lRet   := .T. 

IF CT2->CT2_ZZINTA == '1'
    cBase := CT2->CT2_ZZCAI
    cItem := CT2->CT2_ZZITAI
    cFilB := CT2->CT2_ZZFILA

    aAreaCT2 := GetArea()
    DbSelectArea("SN1")
    DbSetorder(1)
    If Dbseek(cFilB+Avkey(cBase,"N1_CBASE")+cItem)
        Reclock("SN1",.F.)
        SN1->(DbDelete())
        SN1->(Msunlock())
    EndIf 
    DbSelectArea("SN3")
    DbSetorder(1)
    If Dbseek(cFilB+Avkey(cBase,"N3_CBASE")+cItem)
        Reclock("SN3",.F.)
        SN3->(DbDelete())
        SN3->(Msunlock())
    EndIf 
    DbSelectArea("SN4")
    DbSetorder(1)
    If Dbseek(cFilB+Avkey(cBase,"N4_CBASE")+cItem)
        Reclock("SN4",.F.)
        SN4->(DbDelete())
        SN4->(Msunlock())
    EndIf 
    
    RestArea(aAreaCT2)

    Reclock("CT2",.F.)
    CT2->CT2_ZZINTA := ''
    CT2->(Msunlock())
EndIf  

Return( lRet )
