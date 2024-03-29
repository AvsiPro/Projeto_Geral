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
Private aCombo    := {'Vendedor','Cliente', 'Administrador'}
Private cCombo1   := aCombo[1]
Private xGetPesq  := space(20)
Private cNome     := space(120)
Private cUser     := space(80)
Private cPass     := space(80)
Private cCgc      := ''
Private cCod      := ''
Private cLoj      := ''
Private aEmpresas := FWLoadSM0( .f. , .f. )
Private aFilial   := {}
Private cCombo2   := ''

    If Empty(FunName())
        RpcSetType(3)
        RPCSetEnv("01","04")
    EndIf

    Aeval(aEmpresas,{|x| Aadd(aFilial,x[2])})
    cCombo2 := aFilial[1]

    SetPrvt("oDlg1","oList0","oCmb1","oCmb2","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6")

    fDados()

    If Len(aList0) <= 0
        aAdd(aList0,{'','','','',''})
    EndIf

    oDlg1  := MSDialog():New( 086,213,550,1408,"Usu�rios E-JUB Web e Mobile",,,.F.,,,,,,.T.,,,.T. )

    oSay1  := TSay():New( 036,012,{||"Perfil"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oCmb1  := TComboBox():New(044,012,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},aCombo,060,012,oDlg1,,{||fComboType()},,,,.T.,,,,,,,,,'cCombo1')

    oSay6  := TSay():New( 036,080,{||"Filial Faturamento"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oCmb2  := TComboBox():New(044,080,{|u|if(PCount()>0,cCombo2:=u,cCombo2)},aFilial,060,012,oDlg1,,{||/*fComboType()*/},,,,.T.,,,,,,,,,'cCombo2')

    oSay2  := TSay():New( 064,012,{||"Buscar "+cCombo1},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
    oGet1  := TGet():New( 072,012,{|u|if(PCount()>0,xGetPesq:=u,xGetPesq)},oDlg1,060,012,'',{ || fBuscaNome() },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,cConsP,"",,)

    oSay3  := TSay():New( 064,080,{||"Nome"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    oGet2  := TGet():New( 072,080,{|u|if(PCount()>0,cNome:=u,cNome)},oDlg1,150,012,'',{ ||  },CLR_BLACK,CLR_WHITE,,,,.T.,"",,{|| .F. },.F.,.F.,,.F.,.F.,"","",,)

    oSay4  := TSay():New( 102,012,{||"Usu�rio"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
    oGet3  := TGet():New( 110,012,{|u|if(PCount()>0,cUser:=u,cUser)},oDlg1,130,012,'',{ ||  },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

    oSay5  := TSay():New( 130,012,{||"Senha"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
    oGet4  := TGet():New( 138,012,{|u|if(PCount()>0,cPass:=u,cPass)},oDlg1,130,012,'',{ ||  },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

    oList0 := TCBrowse():New(020,240,350,180,,{'Perfil','Usu�rio','Senha','Nome','Token'},{35,100,70,120,120},oDlg1,,,,{|| },{|| },,,,,,,.F.,,.T.,,.F.,,,)

    oList0:SetArray(aList0)
    oList0:bLine := {||{;
        aList0[oList0:nAt,01],;
        aList0[oList0:nAt,02],;
        aList0[oList0:nAt,03],;
        aList0[oList0:nAt,04],;
        aList0[oList0:nAt,05];
    }}

    oBtn1 := TButton():New( 165,012,"Cadastrar",oDlg1,{|| fCadastra()},037,012,,,,.T.,,"",,,,.F. )
    
    oBtn3 := TButton():New( 165,052,"Carga Clientes",oDlg1,{|| Processa({|| fCarga()},"Aguarde")},037,012,,,,.T.,,"",,,,.F. )
    
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
        MsgStop('Necess�rio selecionar um '+cCombo1)
        Return
    
    ElseIf Empty(Alltrim(cUser))
        MsgStop('Necess�rio digitar o Usu�rio para cadastro')
        Return

    ElseIf Empty(Alltrim(cPass))
        MsgStop('Necess�rio digitar a Senha para cadastro')
        Return

    ElseIf !ExistCpo(cConsP, xGetPesq)
        Return
    EndIf

    cTokGrv := Encode64('{"'+cConsP+'","'+Alltrim(cNome)+'","'+Alltrim(cCgc)+'"}')

    If cCombo1 == 'Cliente'
        cTypeAux := 'C'
    ElseIf cCombo1 == 'Vendedor'
        cTypeAux := 'V'
    Else
        cTypeAux := 'A'
    EndIf

    RecLock('Z01', .T.)
        Z01->Z01_TYPE := cTypeAux
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
                SA3->A3_FILFUN := cCombo2
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

    oGet1:destroy()
    oGet1 := TGet():New( 072,012,{|u|if(PCount()>0,xGetPesq:=u,xGetPesq)},oDlg1,060,012,'',{ || fBuscaNome() },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,cConsP,"",,)

    oList0:refresh()
    oCmb1:refresh()
    oSay2:refresh()
    oGet1:refresh()
    oGet2:refresh()
    oGet3:refresh()
    oGet4:refresh()
    oDlg1:refresh()

    MsgInfo('Usu�rio cadastrado com sucesso')
    
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

    If cType $ 'V/A'
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
        
        If (cAliasSQL)->Z01_TYPE == 'C'
            cTypeAux := 'Cliente'
        ElseIf (cAliasSQL)->Z01_TYPE == 'V'
            cTypeAux := 'Vendedor'
        Else
            cTypeAux := 'Administrador'
        EndIf

        Aadd(aList0,{;
            cTypeAux,;
            Alltrim((cAliasSQL)->Z01_USER),;
            Alltrim((cAliasSQL)->Z01_PASS),;
            fTokenUsr((cAliasSQL)->Z01_TYPE, (cAliasSQL)->Z01_TOKEN),;
            Alltrim((cAliasSQL)->Z01_TOKEN);
        })
        (cAliasSQL)->(DbSkip())
    EndDo
    
Return

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 30/08/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function fCarga()

Local aAux := {}
Local nCont 

cTypeAux := 'Cliente'

cQuery := " SELECT A1_NREDUZ,A1_CGC FROM "+RetSQLName("SA1")
cQuery += " WHERE A1_FILIAL='"+xFilial("SA1")+"' AND A1_CGC NOT IN(SELECT Z01_USER FROM "+RetSQLName("Z01")+" WHERE D_E_L_E_T_='')
cQuery += " AND A1_NREDUZ NOT LIKE 'REPRESENTANTE%'"

cAliasSQL := GetNextAlias()
MPSysOpenQuery(cQuery,cAliasSQL)

cConsP := 'SA1'

While (cAliasSQL)->(!EoF())
    Aadd(aAux,{;
        Alltrim((cAliasSQL)->A1_CGC),;
        '1234',;
        Alltrim((cAliasSQL)->A1_NREDUZ),;
        cTokGrv := Encode64('{"'+cConsP+'","'+Alltrim((cAliasSQL)->A1_NREDUZ)+'","'+Alltrim((cAliasSQL)->A1_CGC)+'"}');
        })
    (cAliasSQL)->(DbSkip())
EndDo

For nCont := 1 to len(aAux)
    DbSelectArea("Z01")
    RecLock('Z01', .T.)
    Z01->Z01_TYPE := 'C'
    Z01->Z01_USER := fRemoveCarc(aAux[nCont,01])
    Z01->Z01_PASS := fRemoveCarc(aAux[nCont,02])
    Z01->Z01_TOKEN := aAux[nCont,04]
    Z01->(MsUnlock())

    DbSelectArea("SA1")
    SA1->(DbSetOrder(3))
    If SA1->(DbSeek(xFilial('SA1')+aAux[nCont,01]))
        RecLock('SA1', .F.)
            SA1->A1_TOKEN := aAux[nCont,04]
        SA1->(MsUnlock())
    EndIf
Next nCont 


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

    oGet1:destroy()
    oGet1 := TGet():New( 072,012,{|u|if(PCount()>0,xGetPesq:=u,xGetPesq)},oDlg1,060,012,'',{ || fBuscaNome() },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,cConsP,"",,)

    oList0:refresh()
    oCmb1:refresh()
    oSay2:refresh()
    oGet1:refresh()
    oGet2:refresh()
    oGet3:refresh()
    oGet4:refresh()
    oDlg1:refresh()

    MsgInfo('Usu�rio cadastrado com sucesso')

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

    oGet1:destroy()
    oGet1 := TGet():New( 072,012,{|u|if(PCount()>0,xGetPesq:=u,xGetPesq)},oDlg1,060,012,'',{ || fBuscaNome() },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,cConsP,"",,)
    oGet1:refresh()
    oSay2:refresh()
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
    cWord := strtran(cWord,"�","a")
	cWord := strtran(cWord,"�","a")
	cWord := strtran(cWord,"�","a")
	cWord := strtran(cWord,"�","a")
    cWord := strtran(cWord,"�","")
    cWord := strtran(cWord,"%","")
    cWord := strtran(cWord,"*","")     
    cWord := strtran(cWord,"&","")
    cWord := strtran(cWord,"$","")
    cWord := strtran(cWord,"#","")
    cWord := strtran(cWord,"�","") 
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
    cWord := StrTran(cWord, '�', '')
    cWord := StrTran(cWord, '�', '')
    cWord := Alltrim(Lower(cWord))
Return cWord
