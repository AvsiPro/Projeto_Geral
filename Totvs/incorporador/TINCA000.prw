#INCLUDE 'TOTVS.CH'

//U_TILogNew(cId, cCodRot, cChave, cQuery, cTabOri, nRecOri)
//U_TILogBegin(cId, cCodRot, cChave, lSimula)
//U_TILogMsg(cId, cCodRot, cChave, cMsg)
//U_TILogEnd(cId, cCodRot, cChave, lSimula)
//U_TILogErro(cId, cCodRot, cChave, cErro, lSimula)




User Function TILogNew(cId, cCodRot, cChave, cQuery, cTabOri, nRecOri)

    PGI->(DbSetOrder(1))
    PGI->(RecLock("PGI", .T.))
    PGI->PGI_FILIAL := xFilial("PGI")
    PGI->PGI_IDPROC	:= cId
    PGI->PGI_CODROT	:= cCodRot 
    PGI->PGI_CHAVE	:= cChave
    PGI->PGI_TABORI	:= cTabOri
    PGI->PGI_RECORI	:= nRecOri
    PGI->PGI_STSIMU := "1"  // 1-Não Iniciado
    PGI->PGI_STEXEC	:= "1"  // 1-Não Iniciado
    PGI->(MsUnlock())

    PGH->(DbSetOrder(1))
    PGH->(DbSeek(xFilial("PGH") + cId + cCodRot))
    PGH->(RecLock("PGH", .F.))
    If At("Query: ", PGH->PGH_OBS) = 0
        PGH->PGH_OBS := AllTrim(PGH->PGH_OBS) + "Query: " + AllTrim(cQuery) + CRLF
    EndIF
    PGH->PGH_STSIMU	:= "1"  // 1-Não Iniciado
    PGH->PGH_STEXEC	:= "1"  // 1-Não Iniciado
    PGH->PGH_CUSER	:= __cUserId
    PGH->PGH_NUSER	:= UsrRetName(__cUserId)
    PGH->(MsUnlock())  

Return 


User Function TILogBegin(cId, cCodRot, cChave, lSimula)

    PGI->(DbSetOrder(1))
    PGI->(DbSeek(xFilial("PGI") + cId + cCodRot + cChave))
    PGI->(RecLock("PGI", .F.))
    
    If lSimula
        PGI->PGI_STSIMU := "2"
        If  Empty(PGI->PGI_DINI_S) //2=Em execução
            PGI->PGI_DINI_S  := Date()
            PGI->PGI_HINI_S  := Time() 
        EndIf 
        PGI->PGI_OBS	:= Alltrim(PGI->PGI_OBS) + "Simulação iniciada " + Dtoc(date()) + " " + Time() + CRLF
    Else 
        PGI->PGI_STEXEC := "2"
    
        If Empty(PGI->PGI_DTINI)//2=Em execução
            PGI->PGI_DTINI  := Date()
            PGI->PGI_HRINI  := Time() 
        EndIf 
        PGI->PGI_OBS	:= Alltrim(PGI->PGI_OBS) + "Atualização iniciada " + Dtoc(date()) + " " + Time() + CRLF
    EndIf 
    PGI->(MsUnlock())

Return  

User Function TILogMsg(cId, cCodRot, cChave, cMsg)

    PGI->(DbSetOrder(1))
    PGI->(DbSeek(xFilial("PGI") + cId + cCodRot + cChave))
    PGI->(RecLock("PGI", .F.))
    PGI->PGI_OBS	:= Alltrim(PGI->PGI_OBS) + cMsg + CRLF
    PGI->(MsUnlock())
    
Return  


User Function TILogEnd(cId, cCodRot, cChave, lSimula, cMsgLog)

    DEFAULT cMsgLog := ""
    
    PGI->(DbSetOrder(1))
    PGI->(DbSeek(xFilial("PGI") + cId + cCodRot + cChave))
    PGI->(RecLock("PGI", .F.))
    
    If lSimula
        PGI->PGI_OBS	:= Alltrim(PGI->PGI_OBS) + "Simulação OK" + CRLF + cMsgLog

        PGI->PGI_DFIM_S := Date()
        PGI->PGI_HFIM_S := Time() 
        PGI->PGI_TIME_S := ElapTime(PGI->PGI_HINI_S,PGI->PGI_HFIM_S)
        PGI->PGI_STSIMU	:= "3"
    Else
        PGI->PGI_OBS	:= Alltrim(PGI->PGI_OBS) + "Atualização OK" + CRLF + cMsgLog
        PGI->PGI_DTFIM  := Date()
        PGI->PGI_HRFIM  := Time() 
        PGI->PGI_TIME	:= ElapTime(PGI->PGI_HRINI,PGI->PGI_HRFIM)
        PGI->PGI_STEXEC  := "3"
    EndIf 
    PGI->(MsUnlock())
    

Return  


User Function TILogErro(cId, cCodRot, cChave, cErro, lSimula)

    PGI->(DbSetOrder(1))
    PGI->(DbSeek(xFilial("PGI") + cId + cCodRot + cChave))
    PGI->(RecLock("PGI", .F.))
    
    PGI->PGI_OBS	:= Alltrim(PGI->PGI_OBS) + cErro //+ CRLF
    If lSimula
        PGI->PGI_DFIM_S := Date()
        PGI->PGI_HFIM_S := Time() 
        PGI->PGI_TIME_S := ElapTime(PGI->PGI_HINI_S,PGI->PGI_HFIM_S)
        PGI->PGI_STSIMU	:= "4"
    Else 
        PGI->PGI_DTFIM  := Date()
        PGI->PGI_HRFIM  := Time() 
        PGI->PGI_TIME	:= ElapTime(PGI->PGI_HRINI,PGI->PGI_HRFIM)
        PGI->PGI_STEXEC	:= "4"
    EndIf 
    PGI->(MsUnlock())

    PGH->(DbSetOrder(1))
    PGH->(DbSeek(xFilial("PGH") + cId + cCodRot))
    PGH->(RecLock("PGH", .F.))
    PGH->PGH_OBS := Alltrim(PGH->PGH_OBS) + "Ocorrencia chave:" + cChave + CRLF
    PGH->(MsUnlock())

Return  



User Function TIAtuPGH(cID, cCodRot, lSimula)
	Local clAlias := GetNextAlias()
	Local cQuery := ""	
    Local aArea := GetArea()
    
    cQuery := MontaQry(cID, cCodRot, lSimula)

    dbUseArea( .T., __cRdd, TcGenQry( ,, cQuery ), clAlias, .T., .F. )
    If (clAlias)->(Eof())
        (clAlias)->(dbCloseArea())
        RestArea(aArea)
        Return 
    EndIf 

    PGH->(DbSetOrder(1))
    PGH->(DbSeek(xFilial("PGH") + cId + cCodRot))
    PGH->(RecLock("PGH", .F.))

    //1=Não iniciado;2=Em execução;3=Finalizado;4=Ocorrência                                                                          
    If lSimula 

        PGH->PGH_QREG   := (clAlias)->QREG
        
        PGH->PGH_QINI_S := (clAlias)->QINI_S
        PGH->PGH_QCON_S := (clAlias)->QCONC_S
        PGH->PGH_QERR_S := (clAlias)->QERRO_S
        PGH->PGH_QNPR_S := (clAlias)->QNPROC_S  
        PGH->PGH_QIGNO  := (clAlias)->QIGNORA

        If PGH->PGH_STSIMU == "1" .and. (PGH->PGH_QINI_S + PGH->PGH_QCON_S + PGH->PGH_QERR_S + PGH->PGH_QIGNO) > 0
            PGH->PGH_DINI_S	:= STOD(Left((clAlias)->DTHRINI_S, 8))
            PGH->PGH_HINI_S	:= Subs((clAlias)->DTHRINI_S, 9)  
            PGH->PGH_STSIMU := "2"
        EndIf     

        If (PGH->PGH_QINI_S + PGH->PGH_QCON_S + PGH->PGH_QERR_S + PGH->PGH_QIGNO) == PGH->PGH_QREG
            PGH->PGH_DFIM_S := STOD(Left((clAlias)->DTHRFIM_S, 8))
            PGH->PGH_HFIM_S := Subs((clAlias)->DTHRFIM_S, 9)  

            PGH->PGH_TIME_S := ElapTime(PGH->PGH_HINI_S,PGH->PGH_HFIM_S)

            If PGH->PGH_QERR_S > 0
                PGH->PGH_STSIMU := "4"
            Else
                PGH->PGH_STSIMU := "3"
            EndIf 
        EndIf 
    Else 
        
        PGH->PGH_QINICI := (clAlias)->QINI  
        PGH->PGH_QCONC  := (clAlias)->QCONC 
        PGH->PGH_QERRO  := (clAlias)->QERRO 
        PGH->PGH_QNPR   := (clAlias)->QNPROC

        PGH->PGH_DTINI	:= STOD(Left((clAlias)->DTHRINI, 8))
        PGH->PGH_HRINI	:= Subs((clAlias)->DTHRINI, 9) 

        If PGH->PGH_STEXEC == "1" .and. (PGH->PGH_QINICI + PGH->PGH_QCONC + PGH->PGH_QERRO + PGH->PGH_QIGNO) > 0
            PGH->PGH_STEXEC := "2" 
        EndIf 

        If (PGH->PGH_QINICI + PGH->PGH_QCONC + PGH->PGH_QERRO + PGH->PGH_QIGNO) == PGH->PGH_QREG
            PGH->PGH_DTFIM  := STOD(Left((clAlias)->DTHRFIM, 8))
            PGH->PGH_HRFIM  := Subs((clAlias)->DTHRFIM, 9) 
            
            PGH->PGH_TIME   := ElapTime(PGH->PGH_HRINI, PGH->PGH_HRFIM)

            If PGH->PGH_QERRO > 0
                PGH->PGH_STEXEC := "4" 
            Else 
                PGH->PGH_STEXEC := "3"
            EndIf 
        EndIf 
    EndIf 

    PGH->(MsUnlock())

    (clAlias)->(dbCloseArea())
    RestArea(aArea)
Return     

Static Function MontaQry(cIDProc, cCodRot, lSimula)
    Local cQuery := ""

    If lSimula
        cQuery := " "
        cQuery += " SELECT  PGI_CODROT, " 
        cQuery += "         (SELECT COUNT(1)        FROM " + RetSQLName("PGI") + " A WHERE  A.PGI_FILIAL = '" + FWxFilial("PGI") + "' AND A.PGI_IDPROC = '" + cIDProc + "'                         AND A.PGI_CODROT = PGI.PGI_CODROT AND A.D_E_L_E_T_ = ' ' )  AS QREG    ,  " 
        cQuery += "         (SELECT COUNT(1)        FROM " + RetSQLName("PGI") + " A WHERE  A.PGI_FILIAL = '" + FWxFilial("PGI") + "' AND A.PGI_IDPROC = '" + cIDProc + "' AND A.PGI_STSIMU =  '2' AND A.PGI_CODROT = PGI.PGI_CODROT AND A.D_E_L_E_T_ = ' ' )  AS QINI_S  ,  " 
        cQuery += "         (SELECT COUNT(1)        FROM " + RetSQLName("PGI") + " A WHERE  A.PGI_FILIAL = '" + FWxFilial("PGI") + "' AND A.PGI_IDPROC = '" + cIDProc + "' AND A.PGI_STSIMU =  '3' AND A.PGI_CODROT = PGI.PGI_CODROT AND A.D_E_L_E_T_ = ' ' )  AS QCONC_S ,  " 
        cQuery += "         (SELECT COUNT(1)        FROM " + RetSQLName("PGI") + " A WHERE  A.PGI_FILIAL = '" + FWxFilial("PGI") + "' AND A.PGI_IDPROC = '" + cIDProc + "' AND A.PGI_STSIMU =  '4' AND A.PGI_CODROT = PGI.PGI_CODROT AND A.D_E_L_E_T_ = ' ' )  AS QERRO_S ,  " 
        cQuery += "         (SELECT COUNT(1)        FROM " + RetSQLName("PGI") + " A WHERE  A.PGI_FILIAL = '" + FWxFilial("PGI") + "' AND A.PGI_IDPROC = '" + cIDProc + "' AND A.PGI_STSIMU =  '1' AND A.PGI_CODROT = PGI.PGI_CODROT AND A.D_E_L_E_T_ = ' ' )  AS QNPROC_S,  " 
        cQuery += "         (SELECT COUNT(1)        FROM " + RetSQLName("PGI") + " A WHERE  A.PGI_FILIAL = '" + FWxFilial("PGI") + "' AND A.PGI_IDPROC = '" + cIDProc + "' AND A.PGI_STSIMU =  '5' AND A.PGI_CODROT = PGI.PGI_CODROT AND A.D_E_L_E_T_ = ' ' )  AS QIGNORA ,  "     
        cQuery += "         (SELECT MIN(PGI_DINI_S || PGI_HINI_S) FROM " + RetSQLName("PGI") + " A WHERE  A.PGI_FILIAL = '" + FWxFilial("PGI") + "' AND A.PGI_IDPROC = '" + cIDProc + "' AND A.PGI_HINI_S <> ' ' AND A.PGI_CODROT = PGI.PGI_CODROT AND A.D_E_L_E_T_ = ' ' )  AS DTHRINI_S ,  " 
        cQuery += "         (SELECT MAX(PGI_DFIM_S || PGI_HFIM_S) FROM " + RetSQLName("PGI") + " A WHERE  A.PGI_FILIAL = '" + FWxFilial("PGI") + "' AND A.PGI_IDPROC = '" + cIDProc + "' AND A.PGI_HFIM_S <> ' ' AND A.PGI_CODROT = PGI.PGI_CODROT AND A.D_E_L_E_T_ = ' ' )  AS DTHRFIM_S   " 
        cQuery += " FROM   " + RetSQLName("PGI") + " PGI   " 
        cQuery += " WHERE  PGI_FILIAL = '" + FWxFilial("PGI") + "' AND PGI_IDPROC = '" + cIDProc + "' AND PGI_CODROT = '" + cCodRot + "' AND PGI.D_E_L_E_T_ = ' '  " 
        cQuery += " GROUP BY PGI_CODROT   " 
        cQuery += " ORDER BY PGI_CODROT  " 
    Else 

        cQuery := " "
        cQuery += " SELECT PGI_CODROT, " 
        cQuery += "         (SELECT COUNT(1)        FROM " + RetSQLName("PGI") + " A WHERE  A.PGI_FILIAL = '" + FWxFilial("PGI") + "' AND A.PGI_IDPROC = '" + cIDProc + "' AND A.PGI_STEXEC =  '2' AND A.PGI_CODROT = PGI.PGI_CODROT AND A.D_E_L_E_T_ = ' ' )  AS QINI  ,  " 
        cQuery += "         (SELECT COUNT(1)        FROM " + RetSQLName("PGI") + " A WHERE  A.PGI_FILIAL = '" + FWxFilial("PGI") + "' AND A.PGI_IDPROC = '" + cIDProc + "' AND A.PGI_STEXEC =  '3' AND A.PGI_CODROT = PGI.PGI_CODROT AND A.D_E_L_E_T_ = ' ' )  AS QCONC ,  " 
        cQuery += "         (SELECT COUNT(1)        FROM " + RetSQLName("PGI") + " A WHERE  A.PGI_FILIAL = '" + FWxFilial("PGI") + "' AND A.PGI_IDPROC = '" + cIDProc + "' AND A.PGI_STEXEC =  '4' AND A.PGI_CODROT = PGI.PGI_CODROT AND A.D_E_L_E_T_ = ' ' )  AS QERRO ,  " 
        cQuery += "         (SELECT COUNT(1)        FROM " + RetSQLName("PGI") + " A WHERE  A.PGI_FILIAL = '" + FWxFilial("PGI") + "' AND A.PGI_IDPROC = '" + cIDProc + "' AND A.PGI_STEXEC =  '1' AND A.PGI_CODROT = PGI.PGI_CODROT AND A.D_E_L_E_T_ = ' ' )  AS QNPROC,  " 
        cQuery += "         (SELECT MIN(PGI_DTINI || PGI_HRINI)  FROM " + RetSQLName("PGI") + " A WHERE  A.PGI_FILIAL = '" + FWxFilial("PGI") + "' AND A.PGI_IDPROC = '" + cIDProc + "' AND A.PGI_HRINI  <> ' ' AND A.PGI_CODROT = PGI.PGI_CODROT AND A.D_E_L_E_T_ = ' ' )  AS DTHRINI ,  " 
        cQuery += "         (SELECT MAX(PGI_DTFIM || PGI_HRFIM)  FROM " + RetSQLName("PGI") + " A WHERE  A.PGI_FILIAL = '" + FWxFilial("PGI") + "' AND A.PGI_IDPROC = '" + cIDProc + "' AND A.PGI_HRFIM  <> ' ' AND A.PGI_CODROT = PGI.PGI_CODROT AND A.D_E_L_E_T_ = ' ' )  AS DTHRFIM   "        
        cQuery += " FROM   " + RetSQLName("PGI") + " PGI   " 
        cQuery += " WHERE  PGI_FILIAL = '" + FWxFilial("PGI") + "' AND PGI_IDPROC = '" + cIDProc + "' AND PGI_CODROT = '" + cCodRot + "' AND PGI.D_E_L_E_T_ = ' '  " 
        cQuery += " GROUP BY PGI_CODROT   " 
        cQuery += " ORDER BY PGI_CODROT  " 

    EndIf 
Return cQuery

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Rotina para carga das perguntas de uma rotina

@version 	P12
@param      cPGJ_PERG (Caractere) = Campo com grupo de Perguntas do SX1 da tabela PGJ
            aPergunte (Array)= Matriz para carga das perguntas por rotina, abaixo a estrutura do Array
            { PGJ_PERGUNTE, { X1_ORDEM, X1_PERGUNT, Conteudo de cX1_VAR01 }  }
@since   	11/12/2021
/*/
//-----------------------------------------------------------------------------

User Function TIncLSX1(cPGJ_PERG, aPergunte)

    Local aSX1      := {}
    Local aTmp      := {}
    Local nSx1      := 0
    Local xRet      := Nil
    Local cPergunte := ""
    Local cDescri   := ""
    Local oObjSX1
    Local cMsg      :=  If(cPGJ_PERG == "PGJ_PERGLD", "Carga", If(cPGJ_PERG == "PGJ_PERGSM", "Simulação",;
                        If(cPGJ_PERG == "PGJ_PERGEX", "Execução", "")))
    Local nPergunte
    
    If PGJ->(DbSeek(xFilial("PGH") + PGH->PGH_CODROT)) .And. ! Empty((cPergunte := &("PGJ->" + cPGJ_PERG)))
        If ! Pergunte(cPergunte, .T.)
            Return .F.
        EndIf

        oObjSX1 := FWSX1Util():New()
        oObjSX1:AddGroup(AllTrim(cPergunte))
        oObjSX1:SearchGroup()
        aTmp := oObjSX1:GetGroup(AllTrim(cPergunte))

        If Len(aTmp) > 0
            For nSX1 := 1 To Len(aTmp[2])
                xRet    := &(AllTrim(aTmp[2][nSX1]:cX1_VAR01))
                cDescri := ""
                If aTmp[2][nSX1]:cX1_TIPO = "N" .And. aTmp[2][nSX1]:cX1_GSC = "C"
                    If xRet == 1 .And. ! Empty(aTmp[2][nSX1]:cX1_DEF01)
                        cDescri := AllTrim(aTmp[2][nSX1]:cX1_DEF01)
                    ElseIf xRet == 2 .And. ! Empty(aTmp[2][nSX1]:cX1_DEF02)
                        cDescri := AllTrim(aTmp[2][nSX1]:cX1_DEF02)
                    ElseIf xRet == 3 .And. ! Empty(aTmp[2][nSX1]:cX1_DEF03)
                        cDescri := AllTrim(aTmp[2][nSX1]:cX1_DEF03)
                    ElseIf xRet == 4 .And. ! Empty(aTmp[2][nSX1]:cX1_DEF04)
                        cDescri := AllTrim(aTmp[2][nSX1]:cX1_DEF04)
                    ElseIf xRet == 5 .And. ! Empty(aTmp[2][nSX1]:cX1_DEF05)
                        cDescri := AllTrim(aTmp[2][nSX1]:cX1_DEF05)
                    EndIf
                EndIf
                Aadd(aSX1, { aTmp[2][nSX1]:cX1_ORDEM, AllTrim(aTmp[2][nSX1]:cX1_PERGUNT), xRet, cDescri })
            Next
            Aadd(aPergunte, { PGH->PGH_CODROT, AClone(aSX1) })
        EndIf

        If Len(aPergunte) > 0 .And. (nPos := Ascan(aPergunte, { |x| x[1] == PGH->PGH_CODROT })) > 0
            cMsg := cMsg + " Iniciada em " + Dtoc(date()) + " " + Time() + " - Perguntas:" + CRLF
            For nPergunte := 1 To Len(aPergunte[nPos][2])
                If nPergunte > 1
                    cMsg += CRLF
                EndIf
                cMsg += aPergunte[nPos][2][nPergunte][1] + "-" + aPergunte[nPos][2][nPergunte][2]
                If ! Empty(aPergunte[nPos][2][nPergunte][4])
                    xRet := aPergunte[nPos][2][nPergunte][4]
                Else
                    xRet := aPergunte[nPos][2][nPergunte][3]
                    If ValType(xRet) = "N"
                        xRet := AllTrim(Str(xRet))
                    ElseIf ValType(xRet) = "D"
                        xRet := Dtoc(xRet)
                    ElseIf ValType(xRet) = "L"
                        xRet := If(xRet, "Sim", "Nao")
                    EndIf
                EndIF
                cMsg += ": " + xRet
            Next
            PGH->(RecLock("PGH", .F.))
            PGH->PGH_OBS := AllTrim(PGH->PGH_OBS) + AllTrim(cMsg) + CRLF
            PGH->(MsUnLock())
        EndIf
    EndIf

    Return .T.

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Rotina para recuperar o conteudo de uma pergunta armazenada pela função 

@version 	P12
@param      cPGH_CODROT (Caractere) = Código da Rotina da tabela PGJ
            aPergunte (Array)= Matriz para carga das perguntas por rotina, abaixo a estrutura do Array
            { PGJ_PERGUNTE, { X1_ORDEM, X1_PERGUNT, Conteudo de cX1_VAR01 }  }
@since   	11/12/2021
/*/
//-----------------------------------------------------------------------------

User Function TIncISX1(cPGH_CODROT, aPergunte, cX1_ORDEM)

Local nPergunte := 1
Local nRot      := 1
Local xRet      := Nil

For nRot := 1 To Len(aPergunte)
    If aPergunte[nRot][1] == cPGH_CODROT
        For nPergunte := 1 To Len(aPergunte[nRot][2])
            If aPergunte[nRot][2][nPergunte][1] = cX1_ORDEM
                xRet := aPergunte[nRot][2][nPergunte][3]
            EndIF
        Next
    EndIf
Next

Return xRet
