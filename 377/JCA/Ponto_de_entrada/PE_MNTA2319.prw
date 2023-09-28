#INCLUDE 'PROTHEUS.CH'

User function MNTA2319

LOCAL aArea     := GetArea()
Local aPneu     := Paramixb
Local aRet      := {}
Local aStatus   := {'61','59','53','60'}
Local nPos      := Ascan(aStatus,{|x| x == TQY_STATUS })

DbSelectArea("ST9")
DbSetOrder(1)
If Dbseek(xFilial("ST9")+aPneu[1])
    If nPos == 1
        Aadd(aRet,ST9->T9_XMATNOV)
    ElseIf nPos == 2    
        Aadd(aRet,ST9->T9_XMATUSA)
    ElseIf nPos == 3
        Aadd(aRet,ST9->T9_XMATCON)
    ElseIf nPos == 4
        Aadd(aRet,ST9->T9_XMATREF)
    EndIf 
    
    Aadd(aRet,Posicione("SB1",1,xFilial("SB1")+aRet[1],"B1_LOCPAD"))

    DbSelectArea("SB2")
    DbSetOrder(1)
    If !DbSeek(xFilial("SB2")+aRet[1]+aRet[2])
        CriaSB2(aRet[1],aRet[2])
    EndIf
EndIf 

RestArea(aArea)

Return(aRet)
