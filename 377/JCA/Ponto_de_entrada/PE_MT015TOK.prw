#INCLUDE 'PROTHEUS.CH'
/*
    Ponto de entrada para validar o tudo ok da rotina de cadastro de endereçamento
    MIT EST002
    Alterado o escopo desta MIT, agora será tratado o cadastro de endereçamento padrão para configurar
    o endereço dos itens através do produto principal.
    29/05/2024
*/
User Function MT015TOK

Local aArea := GetArea()
Local lOk   := .T.

If lOk 
    DbSelectArea("SB1")
    DbSetOrder(1)
    If Dbseek(xFilial("SB1")+M->BE_CODPRO)
        If !Empty(SB1->B1_ZMARCA) .Or. !Empty(SB1->B1_XCODPAI)
            MsgAlert("Somente produtos 'PAI' podem ser configurados no cadastro de endereçamento")
            lOk := .F.
        Else 
            If SB1->B1_TIPO <> 'MC'
                MsgAlert("Somente produtos do tipo MC pode ser configurados no cadastro de endereçamento")
                lOk := .F.
            EndIf 

            If lOk .AND. M->BE_CODPRO <> SBE->BE_CODPRO
                DbSelectArea("SBE")
                DbSetOrder(7)
                If Dbseek(xFilial("SBE")+M->BE_CODPRO)
                    MsgAlert("Produto já cadastrado no endereço "+SBE->BE_LOCALIZ+" para esta filial, verifique!!!")
                    lOk := .F.
                EndIf 
            EndIf 

        EndIf 
    EndIf 

    If lOk .And. M->BE_STATUS == '3'
        If !Empty(M->BE_CODPRO)
            MsgAlert("Para completar o bloqueio deste cadastro, o código do produto esta sendo retirado deste endereço")
        EndIf 
    ElseIf lOk .And. M->BE_STATUS <> '2'
        M->BE_STATUS := '2'
    EndIf 
EndIf 

iF !Empty(M->BE_CODPRO) .AND. M->BE_CODPRO <> SBE->BE_CODPRO
    If (lOk .And. INCLUI) .OR. (lOk .And. M->BE_LOCALIZ <> SBE->BE_LOCALIZ)
        If !MsgYesNo("O Produto "+M->BE_CODPRO+" e seus filhos serão associados ao endereço "+M->BE_LOCALIZ+CRLF+"Confirma?")
            lOk := .F.
        EndIf
    EndIf 
ENDIF

RestArea(aArea)

Return(lOk)
