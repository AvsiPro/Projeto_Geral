#Include 'PROTHEUS.CH'
/*
    Ponto de entrada para incluir itens ao menu da rotina de endereçamento
    MIT EST002
    Alterado o escopo desta MIT, agora será tratado o cadastro de endereçamento padrão para configurar
    o endereço dos itens através do produto principal.
    Aqui ficará a parte de alteração de endereço de um produto
    29/05/2024
*/
User Function MTA015MNU()

Local aRotUser := aRotina

AAdd( aRotUser, { 'Novo Endereço', "Processa( {|| U_xMta105() }, 'Aguarde...', '',.F.)", 0, 2,0 } )
    
Return aRotUser

/*/{Protheus.doc} nomeFunction
Tela para troca de endereçamento de um produto.
@author user
@since 29/05/2024
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
/*/
User Function xMta105()

Local aArea := GetArea()
Local nOpcao := 0

Private oDlg1,oGrp1,oSay1,oSay2,oSay3,oSay4,oGet2,oGrp2,oSay5,oSay6,oGet1,oBtn1


If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","00090276")
EndIf

Private cCodigo := space(TamSX3("B1_COD")[1])
Private cEndere := space(TamSX3("BE_LOCALIZ")[1])
Private cEndAtu := ''

oDlg1      := MSDialog():New( 235,377,555,1001,"Troca de endereço",,,.F.,,,,,,.T.,,,.T. )
    
    oGrp1      := TGroup():New( 008,044,064,272,"Dados atuais",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    
        oSay1      := TSay():New( 020,072,{||"Código"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)
        oGet1      := TGet():New( 020,140,{|u| If(Pcount()>0,cCodigo:=u,cCodigo)},oGrp1,064,008,'@!',{|| validcpo(1)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","",,)
        
        oSay2      := TSay():New( 036,052,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,166,008)
        oSay3      := TSay():New( 048,072,{||"Endereço Atual"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
        oSay4      := TSay():New( 048,112,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,136,008)
    
    oGrp2      := TGroup():New( 072,016,124,288,"Novo endereço",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    
        oSay5      := TSay():New( 088,084,{||"Endereço"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
        oGet2      := TGet():New( 088,140,{|u| If(Pcount()>0,cEndere:=u,cEndere)},oGrp2,064,008,'',{||validcpo(2)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SBE","",,)
    
        oSay6      := TSay():New( 108,048,{||""},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,208,008)
    
    oBtn1      := TButton():New( 132,088,"Confirmar",oDlg1,{||oDlg1:end(nOpcao := 1)},037,012,,,,.T.,,"",,,,.F. )
    oBtn2      := TButton():New( 132,188,"Cancelar",oDlg1,{||oDlg1:end(nOpcao := 0)},037,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

If nOpcao == 1
    If !Empty(cCodigo) .And. !Empty(cEndere) .And. !Empty(cEndAtu)
        If MsgYesNo("O Produto "+cCodigo+" e seus filhos serão associados ao endereço "+cEndere+CRLF+"Confirma?")
            DbSelectArea("SBE")
            DbSetOrder(7)
            If Dbseek(xFilial("SBE")+cCodigo)
                Reclock("SBE",.F.)
                SBE->BE_CODPRO := ''
                SBE->BE_STATUS := '1'
                SBE->(Msunlock())
            EndIf 

            DbSelectArea("SBE")
            DbSetOrder(9)
            If Dbseek(xFilial("SBE")+cEndere)
                Reclock("SBE",.F.)
                SBE->BE_CODPRO := cCodigo
                SBE->BE_STATUS := '2'
                SBE->BE_XLOCANT:= cEndAtu
                SBE->(Msunlock())
            EndIf 
        EndIf 
    EndIf 
EndIf 

RestArea(aArea)

Return

/*/{Protheus.doc} validcpo(1)
    valida o campo informado
    @type  Static Function
    @author user
    @since 29/05/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function validcpo(nCpo)

Local lRet := .T.

If nCpo == 1
    cEndAtu := ''

    oSay2:settext("")
    oSay4:settext("")
    
    If !Empty(cCodigo)
        DbSelectArea("SB1")
        DbSetOrder(1)
        If Dbseek(xFilial("SB1")+cCodigo)
            If !Empty(SB1->B1_XCODPAI)
                MsgAlert("Somente códigos PAI podem ser atribuidos a um endereço")
                lRet := .F.
            Else 
                oSay2:settext(SB1->B1_DESC)

                DbSelectArea("SBE")
                DbSetOrder(7)
                If Dbseek(xFilial("SBE")+cCodigo)
                    oSay4:settext(SBE->BE_LOCALIZ+" - "+SBE->BE_DESCRIC)
                    cEndAtu := SBE->BE_LOCALIZ
                Else 
                    MsgAlert("Produto ainda sem endereço cadastrado para a filial")
                    lRet := .f.
                EndIf 
            EndIf 
        Else 
            MsgAlert("Produto não encontrado")
            lRet := .F.
        EndIf 
    EndIf 
Else 
    oSay6:settext("")

    If !Empty(cEndere)
        DbSelectArea("SBE")
        DbSetOrder(9)
        If Dbseek(xFilial("SBE")+cEndere)
            If !Empty(SBE->BE_CODPRO)
                MsgAlert("Endereço já ocupado pelo produto "+SBE->BE_CODPRO)
                lRet := .F.
            else 
                oSay6:settext(SBE->BE_DESCRIC)
            EndIf 
        Else 
            MsgAlert("Endereço inexistente","PE_MTA015MNU")
            lRet := .F.
        EndIf 
    EndIf 

EndIf 

Return(lRet)
