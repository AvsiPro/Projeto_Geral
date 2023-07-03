#Include 'Totvs.ch'

/*/{Protheus.doc} JUBPAP08
   @description: cadastro de usuario e-jub
   @type: User Function
   @author: Felipe Mayer
   @since: 03/07/2023
/*/
User Function JUBPAP08()

Private aList0    := {}
Private lCliente  := .F.
Private cConsP    := 'SA3'
Private aCombo    := {'Vendedor','Cliente'}
Private cCombo1   := aCombo[1]
Private xGetPesq  := space(20)
Private cNome     := space(120)
Private cUser     := space(80)
Private cPass     := space(80)
Private cCgc      := ''
Private cCod      := ''
Private cLoj      := ''

    If Empty(FunName())
        RpcSetType(3)
        RPCSetEnv("01","04")
    EndIf

    SetPrvt("oDlg1","oList0","oCmb1","oSay1","oSay2","oSay3","oSay4","oSay5")

    fDados()

    If Len(aList0) <= 0
        aAdd(aList0,{'','','','',''})
    EndIf

    oDlg1  := MSDialog():New( 086,213,550,1408,"Usuários E-JUB Web e Mobile",,,.F.,,,,,,.T.,,,.T. )

    oSay1  := TSay():New( 036,012,{||"Perfil"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oCmb1  := TComboBox():New(044,012,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},aCombo,060,012,oDlg1,,{||fComboType()},,,,.T.,,,,,,,,,'cCombo1')

    oSay2  := TSay():New( 064,012,{||"Buscar "+cCombo1},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
    oGet1  := TGet():New( 072,012,{|u|if(PCount()>0,xGetPesq:=u,xGetPesq)},oDlg1,060,012,'',{ || fBuscaNome() },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,cConsP,"",,)

    oSay3  := TSay():New( 064,080,{||"Nome"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oGet2  := TGet():New( 072,080,{|u|if(PCount()>0,cNome:=u,cNome)},oDlg1,150,012,'',{ ||  },CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|| .F. },.F.,.F.,,.F.,.F.,"","",,)

    oSay4  := TSay():New( 102,012,{||"Usuário"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
    oGet3  := TGet():New( 110,012,{|u|if(PCount()>0,cUser:=u,cUser)},oDlg1,130,012,'',{ ||  },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

    oSay5  := TSay():New( 130,012,{||"Senha"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
    oGet4  := TGet():New( 138,012,{|u|if(PCount()>0,cPass:=u,cPass)},oDlg1,130,012,'',{ ||  },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

    oList0 := TCBrowse():New(020,240,350,180,,{'Perfil','Usuário','Senha','Nome','Token'},{35,100,70,120,120},oDlg1,,,,{|| },{|| },,,,,,,.F.,,.T.,,.F.,,,)

    oList0:SetArray(aList0)
    oList0:bLine := {||{;
        aList0[oList0:nAt,01],;
        aList0[oList0:nAt,02],;
        aList0[oList0:nAt,03],;
        aList0[oList0:nAt,04],;
        aList0[oList0:nAt,05];
    }}

    oBtn1 := TButton():New( 165,012,"Cadastrar",oDlg1,{|| fCadastra()},037,012,,,,.T.,,"",,,,.F. )
    oBtn2 := TButton():New( 210,550,"Fechar",oDlg1,{|| oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )

    oDlg1:Activate(,,,.T.)

Return


/*/{Protheus.doc} fCadastra
   @description: cadastra o usuario
   @type: Static Function
   @author: Felipe Mayer
   @since: 03/07/2023
/*/
Static Function fCadastra()
    
    If Empty(Alltrim(xGetPesq))
        MsgStop('Necessário selecionar um '+cCombo1)
        Return
    
    ElseIf Empty(Alltrim(cUser))
        MsgStop('Necessário digitar o Usuário para cadastro')
        Return

    ElseIf Empty(Alltrim(cPass))
        MsgStop('Necessário digitar a Senha para cadastro')
        Return
    EndIf

    cTokGrv := Encode64('{"'+Iif(cCombo1 == 'Cliente','SA1','SA3')+'","'+Alltrim(cNome)+'","'+Alltrim(cCgc)+'"}')

    RecLock('Z01', .T.)
        Z01->Z01_TYPE := Iif(cCombo1 == 'Cliente','C','V')
        Z01->Z01_USER := fRemoveCarc(cUser)
        Z01->Z01_PASS := fRemoveCarc(cPass)
        Z01->Z01_TOKEN := cTokGrv
    Z01->(MsUnlock())

    If cCombo1 == 'Cliente'
        SA1->(DbSetOrder(1))
        If SA1->(DbSeek(xFilial('SA1')+cCod+cLoj))
            RecLock('SA1', .F.)
                SA1->A1_TOKEN := cTokGrv
            SA1->(MsUnlock())
        EndIf
    Else
        SA3->(DbSetOrder(1))
        If SA3->(DbSeek(xFilial('SA3')+cCod))
            RecLock('SA3', .F.)
                SA3->A3_TOKEN := cTokGrv
            SA3->(MsUnlock())
        EndIf
    EndIf
    
    fDados()

    oList0:SetArray(aList0)
    oList0:bLine := {||{;
        aList0[oList0:nAt,01],;
        aList0[oList0:nAt,02],;
        aList0[oList0:nAt,03],;
        aList0[oList0:nAt,04],;
        aList0[oList0:nAt,05];
    }}

    cCombo1  := aCombo[1]
    lCliente := .F.
    cConsP   := 'SA3'
    xGetPesq := Space(TamSx3('A3_COD')[1])
    cNome    := space(120)
    cUser    := space(80)
    cPass    := space(80)

    oList0:refresh()
    oCmb1:refresh()
    oSay2:refresh()
    oGet1:refresh()
    oGet2:refresh()
    oGet3:refresh()
    oGet4:refresh()
    oDlg1:refresh()

    MsgInfo('Usuário cadastrado com sucesso')
    
Return


/*/{Protheus.doc} fTokenUsr
   @description: Busca nome por token
   @type: Static Function
   @author: Felipe Mayer
   @since: 03/07/2023
/*/
Static Function fTokenUsr(cType, cToken)

Local cName := ''
Local aArea := GetArea()

    If cType == 'V'
        cQuery := " SELECT A3_NREDUZ NOME FROM "+RetSqlName('SA3')+" "
        cQuery += " WHERE A3_TOKEN = '"+cToken+"' "
    Else
        cQuery := " SELECT A1_NREDUZ NOME FROM "+RetSqlName('SA1')+" "
        cQuery += " WHERE A1_TOKEN = '"+cToken+"' "
    EndIf

    cQuery += " AND D_E_L_E_T_ = ' ' "

    cAliasTMP := GetNextAlias()
    MPSysOpenQuery(cQuery, cAliasTMP)

    If (cAliasTMP)->(!EoF())
        cName := Alltrim((cAliasTMP)->NOME)
    EndIf

    (cAliasTMP)->(DbCloseArea())

    RestArea(aArea)

Return cName


/*/{Protheus.doc} fDados
   @description: busca dados de login
   @type: Static Function
   @author: Felipe Mayer
   @since: 03/07/2023
/*/
Static Function fDados()

    aList0 := {}

    cQuery := " SELECT * FROM "+RetSqlName('Z01')+" "
    cQuery += " WHERE D_E_L_E_T_ = '' "

    cAliasSQL := GetNextAlias()
	MPSysOpenQuery(cQuery,cAliasSQL)

    While (cAliasSQL)->(!EoF())
        Aadd(aList0,{;
            Iif((cAliasSQL)->Z01_TYPE == 'V','Vendedor', 'Cliente'),;
            Alltrim((cAliasSQL)->Z01_USER),;
            Alltrim((cAliasSQL)->Z01_PASS),;
            fTokenUsr((cAliasSQL)->Z01_TYPE, (cAliasSQL)->Z01_TOKEN),;
            Alltrim((cAliasSQL)->Z01_TOKEN);
        })
        (cAliasSQL)->(DbSkip())
    EndDo
    
Return


/*/{Protheus.doc} fBuscaNome
   @description: Busca nome
   @type: Static Function
   @author: Felipe Mayer
   @since: 29/06/2023
/*/
Static Function fBuscaNome()
    cNome := Posicione(cConsP, 1, xFilial(cConsP)+xGetPesq, if(cConsP == 'SA1', 'A1_NREDUZ', 'A3_NREDUZ'))
    cCgc  := Posicione(cConsP, 1, xFilial(cConsP)+xGetPesq, if(cConsP == 'SA1', 'A1_CGC', 'A3_CGC'))
    cCod  := Posicione(cConsP, 1, xFilial(cConsP)+xGetPesq, if(cConsP == 'SA1', 'A1_COD', 'A3_COD'))
    cLoj  := Posicione(cConsP, 1, xFilial(cConsP)+xGetPesq, if(cConsP == 'SA1', 'A1_LOJA', ''))

    cUser := cCgc
    
    oGet2:refresh()
    oGet3:refresh()
    oDlg1:refresh()
Return


/*/{Protheus.doc} fComboType
   @description: seleciona cliente ou vendedor
   @type: Static Function
   @author: Felipe Mayer
   @since: 29/06/2023
/*/
Static Function fComboType()

    lCliente := Iif(cCombo1 == 'Cliente',.T.,.F.)
    cConsP   := Iif(lCliente, 'SA1', 'SA3')
    xGetPesq := Iif(lCliente, Space(TamSx3('A1_COD')[1]), Space(TamSx3('A3_COD')[1]))
    cNome    := space(120)
    cUser    := space(80)
    cPass    := space(80)

    oSay2:refresh()
    oGet1:refresh()
    oGet2:refresh()
    oGet3:refresh()
    oGet4:refresh()
    oDlg1:refresh()
Return


/*/{Protheus.doc} fRemoveCarc
   @description: remove caracteres especiais
   @type: Static Function
   @author: Felipe Mayer
   @since: 03/07/2023
/*/
Static Function fRemoveCarc(cWord)
    cWord := FwCutOff(cWord, .T.)
    cWord := strtran(cWord,"ã","a")
	cWord := strtran(cWord,"á","a")
	cWord := strtran(cWord,"à","a")
	cWord := strtran(cWord,"ä","a")
    cWord := strtran(cWord,"º","")
    cWord := strtran(cWord,"%","")
    cWord := strtran(cWord,"*","")     
    cWord := strtran(cWord,"&","")
    cWord := strtran(cWord,"$","")
    cWord := strtran(cWord,"#","")
    cWord := strtran(cWord,"§","") 
    cWord := strtran(cWord,",","")
    cWord := StrTran(cWord, "'", "")
    cWord := StrTran(cWord, "#", "")
    cWord := StrTran(cWord, "%", "")
    cWord := StrTran(cWord, "*", "")
    cWord := StrTran(cWord, "&", "E")
    cWord := StrTran(cWord, ">", "")
    cWord := StrTran(cWord, "<", "")
    cWord := StrTran(cWord, "!", "")
    cWord := StrTran(cWord, "@", "")
    cWord := StrTran(cWord, "$", "")
    cWord := StrTran(cWord, "(", "")
    cWord := StrTran(cWord, ")", "")
    cWord := StrTran(cWord, "_", "")
    cWord := StrTran(cWord, "=", "")
    cWord := StrTran(cWord, "+", "")
    cWord := StrTran(cWord, "{", "")
    cWord := StrTran(cWord, "}", "")
    cWord := StrTran(cWord, "[", "")
    cWord := StrTran(cWord, "]", "")
    cWord := StrTran(cWord, "?", "")
    cWord := StrTran(cWord, "\", "")
    cWord := StrTran(cWord, "|", "")
    cWord := StrTran(cWord, ":", "")
    cWord := StrTran(cWord, ";", "")
    cWord := StrTran(cWord, '"', '')
    cWord := StrTran(cWord, '°', '')
    cWord := StrTran(cWord, 'ª', '')
    cWord := Alltrim(Lower(cWord))
Return cWord
