#Include 'Totvs.ch'

/*/{Protheus.doc} JCAGFR02
   @description: Altera��o do c�digo do BEM da tabela ST9 e todos os seus relacionamentos
   @type: User Function
   @author: Felipe Mayer
   @since: 17/09/2023
/*/
User Function JCAGFR02()

Private cAntBem   := ST9->T9_CODBEM
Private cNovoBem  := ''
Private cMensagem := ''
Private lOk       := .F.

If !( Alltrim(SuperGetMV('FS_USUACBE', .F., '')) $ Alltrim(RetCodUsr()) )
    MsgStop('Usu�rio n�o tem permiss�o para atualizar c�digo do bem, verifique o par�metro FS_USUACBE')
    Return
EndIf

cNovoBem := fRemoveCarc(FWInputBox("Informe o novo c�digo do Bem", ""))

If Len(cNovoBem) > TamSx3('T9_CODBEM')[1]
    Help(,,"Tamanho n�o permitido",,;
        "O novo c�digo do bem deve conter um tamanho menor ou igual ao da configura��o do campo",1,0,,,,,,;
        {"Insira um c�digo de no m�ximo <b>"+cValToChar(TamSx3('T9_CODBEM')[1])+'</b> caracteres'};
    )
    Return
EndIf

If Empty(cNovoBem)
    MsgStop('Necess�rio preencher com algum c�digo')
    Return
EndIf

If fExistBem()
    MsgAlert('Codigo Bem j� Cadastrado')
Else

    Begin Transaction
        cQuery := " SELECT
        cQuery += "    X9_DOM AS [ORIGEM],
        cQuery += "    X9_CDOM AS [DESTINO],
        cQuery += "    X9_EXPDOM AS [CPO_ORIGEM],
        cQuery += "    X9_EXPCDOM AS [CPO_DESTINO]
        cQuery += " FROM SX9010 "
        cQuery += " WHERE D_E_L_E_T_ = ' ' AND X9_DOM = 'ST9'
        cQuery += " ORDER BY ORIGEM, DESTINO

        cAliasTMP := GetNextAlias()
        MPSysOpenQuery(cQuery, cAliasTMP)

        While (cAliasTMP)->(!EoF())
            fUpdateBem((cAliasTMP)->ORIGEM, (cAliasTMP)->DESTINO, (cAliasTMP)->CPO_ORIGEM, (cAliasTMP)->CPO_DESTINO)
            (cAliasTMP)->(DbSkip())
        EndDo
        
        (cAliasTMP)->(DbCloseArea())

        If lOk
            RecLock('ST9', .F.)
                ST9->T9_CODBEM  := PadR(cNovoBem,TamSx3('T9_CODBEM')[1])
                ST9->T9_XCODBEM := cAntBem
                ST9->T9_XUSUALT := UsrRetName(RetCodUsr())
                ST9->T9_XDTALT  := Date()
                ST9->T9_XHRALT  := SubStr(Time(),5)
            ST9->(MsUnlock())
        Else
            MsgAlert('O Bem n�o foi atualizado, consulte o Log')
        EndIf
    End Transaction

    ShowLog(cMensagem)

    lOk := .F.
    cMensagem := ''
    cNovoBem  := ''
EndIf

Return


/*/{Protheus.doc} fUpdateBem
   @description: 
   @type: Static Function
   @author: Felipe Mayer
   @since: 17/09/2023
/*/
Static Function fUpdateBem(cTabOri, cTabDes, cCposOri, cCposDes)
    
Local aArea := GetArea()
Local aCpoOri := Strtokarr(Alltrim(cCposOri),'+')
Local aCpoDes := Strtokarr(Alltrim(cCposDes),'+')
Local nX := 0
Local cSet := ''    
Local cWhere := ''
Local cCpoAux := ''

    For nX := 1 To Len(aCpoDes)
        If Alltrim(aCpoOri[nX]) == 'T9_CODBEM'
            cAux := cAntBem
        Else
            cAux := &(cTabOri+'->'+Alltrim(aCpoOri[nX]))
        EndIf

        cWhere += Alltrim(aCpoDes[nX]) + " = '"+cAux+"' "+Iif(nX == Len(aCpoDes),'',' AND ')
        cCpoAux += Alltrim(aCpoDes[nX]) + Iif(nX == Len(aCpoDes),'',' | ')
    Next nX

    For nX := 1 To Len(aCpoDes)
        If Alltrim(aCpoOri[nX]) == 'T9_CODBEM'
            cAux := cNovoBem
        Else
            cAux := &(cTabOri+'->'+Alltrim(aCpoOri[nX]))
        EndIf

	    cSet += Alltrim(aCpoDes[nX]) + " = '"+PadR(cAux,TamSx3(Alltrim(aCpoDes[nX]))[1])+"' "+Iif(nX == Len(aCpoDes),'',' , ')
    Next nX

	cQuery := " UPDATE "+RetSqlName(cTabDes)+" SET " + cSet
	cQuery += " WHERE " + cWhere
	
	If TCSQLExec(cQuery) < 0
        cMensagem += "Falha na atualiza��o do Bem!" + CRLF
        cMensagem += " TABELA DESTINO: "+cTabDes + CRLF
        cMensagem += " CAMPOS DESTINO: "+cCpoAux + CRLF + CRLF
        cMensagem += "/* ==== Mensagem: ===== */" + CRLF + CRLF
        cMensagem += TCSQLError()
    Else
        cMensagem += "Bem atualizado com sucesso!" + CRLF
        cMensagem += " TABELA DESTINO: "+cTabDes + CRLF
        cMensagem += " CAMPOS DESTINO: "+cCpoAux + CRLF + CRLF
        cMensagem += "/* ========= */" + CRLF + CRLF
        
        lOk := .T.
    EndIf

RestArea(aArea)

Return


/*/{Protheus.doc} fExistBem
   @description: 
   @type: Static Function
   @author: Felipe Mayer
   @since: 17/09/2023
/*/

Static Function fExistBem()

Local aArea := GetArea()    

    ST9->(DbSetOrder(1))
    lRet := ST9->(DbSeek(FWxFilial('ST9') + AvKey(cNovoBem,'T9_CODBEM')))

RestArea(aArea)

Return lRet


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
    cWord := Alltrim(Upper(cWord))
Return cWord
