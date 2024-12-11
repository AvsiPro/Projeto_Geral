#INCLUDE 'PROTHEUS.CH'
/*
    Ponto de entrada para validar o tudo ok da rotina de cadastro de endere�amento
    MIT EST002
    Alterado o escopo desta MIT, agora ser� tratado o cadastro de endere�amento padr�o para configurar
    o endere�o dos itens atrav�s do produto principal.
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
            MsgAlert("Somente produtos 'PAI' podem ser configurados no cadastro de endere�amento")
            lOk := .F.
        Else 
            If SB1->B1_TIPO <> 'MC'
                MsgAlert("Somente produtos do tipo MC pode ser configurados no cadastro de endere�amento")
                lOk := .F.
            EndIf 

            If lOk .AND. M->BE_CODPRO <> SBE->BE_CODPRO
                DbSelectArea("SBE")
                DbSetOrder(7)
                If Dbseek(xFilial("SBE")+M->BE_CODPRO)
                    MsgAlert("Produto j� cadastrado no endere�o "+SBE->BE_LOCALIZ+" para esta filial, verifique!!!")
                    lOk := .F.
                EndIf 
            EndIf 

        EndIf 
    EndIf 

    If lOk .And. M->BE_STATUS == '3'
        If !Empty(M->BE_CODPRO)
            MsgAlert("Para completar o bloqueio deste cadastro, o c�digo do produto esta sendo retirado deste endere�o")
        EndIf 
    ElseIf lOk .And. M->BE_STATUS <> '2'
        M->BE_STATUS := '2'
    EndIf 
EndIf 

iF !Empty(M->BE_CODPRO) .AND. M->BE_CODPRO <> SBE->BE_CODPRO
    If (lOk .And. INCLUI) .OR. (lOk .And. M->BE_LOCALIZ <> SBE->BE_LOCALIZ)
        If !MsgYesNo("O Produto "+M->BE_CODPRO+" e seus filhos ser�o associados ao endere�o "+M->BE_LOCALIZ+CRLF+"Confirma?")
            lOk := .F.
        EndIf
    EndIf 
ENDIF

RestArea(aArea)

Return(lOk)
