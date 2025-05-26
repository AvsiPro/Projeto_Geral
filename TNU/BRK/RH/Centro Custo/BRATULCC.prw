#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.ch"

 /*/{Protheus.doc} BRATULCC
    (Atualiza Centro du custo)
    @type  User Function
    @author Natalia Perioto
    @since 11/08/2021
    /*/

User Function BRATULCC()

    Processa({|| BRATULC1()}, "Atualizando Centro de Custo...")

Return


Static Function BRATULC1()

DbSelectArea("SRA")
SRA->(DbSetorder(1))
SRA->(Dbgotop())

While SRA->(!EOF())

    RecLock("SRA", .F.)
    SRA->RA_XDESCCC := POSICIONE("CTT",1,XFILIAL("CTT")+SRA->RA_CC,'CTT_DESC01')
    MsUnlock()

    SRA->(DbSkip())
EndDo   
    
    
Return
