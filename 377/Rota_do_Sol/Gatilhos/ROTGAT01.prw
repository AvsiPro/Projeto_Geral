#INCLUDE 'PROTHEUS.CH'

User Function Rotgat01

Local aArea  := GetArea()
Local cGrupo := M->N1_GRUPO

DbSelectArea("SNG")
DbSetOrder(1)
DbSeek(xFilial("SNG")+cGrupo)

If SNG->NG_CCONTAB <> SN3->N3_CCONTAB 
    //SN3->N3_CCONTAB := SNG->NG_CCONTAB
EndIf 

RestArea(aArea)

Return


