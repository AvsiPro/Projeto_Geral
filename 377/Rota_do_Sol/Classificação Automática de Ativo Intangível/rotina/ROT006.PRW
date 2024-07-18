
#include 'PROTHEUS.CH'

/*/{Protheus.doc} ROT006
Estorno de classificação de Ativo Fixo
@type user function
@author user
@since 21/05/2024
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function ROT006()

Local aArea     := GetArea()
Local cCodBem   := SN1->N1_CBASE
Local cItemBem  := SN1->N1_ITEM
Local lDeprec   := .F.

If MsgYesNo("Confirma o estorno da classificação deste ativo?")
    DbSelectArea("SN4")
    DbSetOrder(1)
    If Dbseek(xFilial("SN4")+cCodBem+cItemBem)
        While !EOF() .AND. SN4->N4_CBASE == cCodBem .and. SN4->N4_ITEM == cItemBem
            lDeprec := Alltrim(SN4->N4_ORIGEM) == 'ATFA050'
            If lDeprec
                MsgAlert("Não é permitido estornar classificação de bem que já tenha sido depreciado")
                exit 
            EndIF 
            Dbskip()
        EndDo 
    EndIf 

    If !lDeprec
        DbSelectArea("SN1")
        DbSetOrdeR(1)
        If Dbseek(xFilial("SN1")+cCodBem+cItemBem)

            If !Empty(SN1->N1_GRUPO) .And. SN1->N1_STATUS <> '0'
                Reclock("SN1",.F.)
                SN1->N1_CHAPA := ''
                SN1->N1_GRUPO := ''
                SN1->N1_CHAPA := ''
                SN1->N1_STATUS := '0'
                SN1->N1_DTCLASS := CTOD(' / / ')
                SN1->(Msunlock())
            Else 
                MsgAlert("Ativo não se encontra classificado")
                lDeprec := .T.
            EndIf 
        EndIf

        If !lDeprec
            DbSelectArea("SN3")
            DbSetOrdeR(1)
            If Dbseek(xFilial("SN3")+cCodBem+cItemBem)
                Reclock("SN3",.F.)
                SN3->N3_HISTOR  := ''
                SN3->N3_CCONTAB := ''
                SN3->N3_CDEPREC := ''
                SN3->N3_CCDEPR  := ''
                SN3->N3_TXDEPR1 := 0
                SN3->N3_VRDBAL1 := 0
                SN3->N3_VRDMES1 := 0
                SN3->N3_VRDACM1 := 0
                SN3->(Msunlock())
            EndIf 

            MsgAlert("Estorno realizado com sucesso!!!")
        endIF 
    EndIf 
EndIf

RestArea(aArea)

Return
