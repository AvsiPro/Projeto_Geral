#INCLUDE 'TOTVS.CH'

//-----------------------------------------------------------------------------------------------
/*/{Protheus.doc} INCCV8
Rotina para transferir o historico a receber de uma filial para outra

@author		By Wise
@since		01/09/2021
@version	1.0
/*/
//-----------------------------------------------------------------------------------------------
User Function INCCV8(cPar)
Local aPar      := {}
Local cIdProc   := ""
Local cCodRot   := ""
Local cTMP      := ""
Local cUNAtu    := ""
Local aArea     := GetArea()
Local aAreaPGG  := PGG->(GetArea())
Local aAreaPGH  := PGH->(GetArea())
Local cChave    := ""
Local cQuery    := ""
Local nRecno    := 0
Local aPergunte := {}
Local cChaveFK7 := ""
Local nTot      := 0
Local aIncRod	:= {}

FWJsonDeserialize(cPar, @aPar)
cIdProc := aPar[1]
cCodRot := aPar[2]
If Len(aPar) > 2
    aPergunte := aPar[3]
EndIF

PGG->(DbSetOrder(1))
PGG->(DbSeek(xFilial("PGG") + cIDProc ))

PGH->(DbSetOrder(1))
PGH->(DbSeek(xFilial("PGH") + cIDProc + cCodRot))

cUNAtu := PGG->PGG_FILORI
cUNNova:= PGG->PGG_FILDES

aIncRod := U_INCFUN1(cUNAtu)

If len(aIncRod) > 0
    
    cTMP := MontaQry(cUNAtu, @cQuery, cIDProc , cCodRot)
    If Empty(cTMP)
        MsgAlert("Não existem históricos na unidade " + cUNAtu)
        Return 
    EndIf 
    IF (cTMP)->(! Eof())
        nTot := (cTMP)->TOTREG
        ProcRegua(nTot)
    ENDIF
    While  (cTMP)->(! Eof())
        cChaveFK7:= STRTRAN((cTMP)->FK7_CHAVE,"|","")
        nRecno   := (cTMP)->RECORI 
        
        If ! IsBlind()
            IncProc("Gerando Histórico CV8: " + cChaveFK7   )
            ProcessMessage()
        EndIf

        cChave := ALLTRIM((cTMP)->CV8_PROC) + '-'
        cChave += strzero(nRecno,10)
        u_TILogNew(cIdProc, cCodRot, cChave, cQuery, "CV8", nRecno)

        (cTMP)->(DbSkip())
    EndDO
else
    MsgAlert("Não encontrado itens na tabela de De/Para da filial de origem - ZX5 tabela _INCDP")
EndIf

RestArea(aAreaPGH)
RestArea(aAreaPGG)
RestArea(aArea)

Return 


//-----------------------------------------------------------------------------------------------
/*/{Protheus.doc} MontaQry
Monta a query para gerar as informações dos registros CV8 que devem ser migrados

@author		By Wise
@since		01/09/2021
@version	1.0
/*/
//-----------------------------------------------------------------------------------------------


Static Function MontaQry(cUNAtu, cQuery, cIDProc , cCodRot)

Local cTMP      := GetNextAlias()

cQuery := "  "
cQuery += " SELECT COUNT(CV8_FILIAL) OVER (PARTITION BY ' ') TOTREG, CV8.R_E_C_N_O_ RECORI, CV8_DATA,CV8_HORA,CV8_USER,CV8_MSG,CV8_DET,CV8_PROC,FK7_FILIAL,FK7_IDDOC, FK7_ALIAS, FK7_CHAVE "
cQuery += " FROM " + RETSQLNAME("CV8") + " CV8 "
cQuery += " INNER JOIN " + RETSQLNAME("FK7") + " FK7 "
cQuery += " ON FK7.FK7_FILIAL = CV8.CV8_FILIAL AND CV8.CV8_PROC = FK7.FK7_IDDOC AND FK7.D_E_L_E_T_= ' ' AND FK7.FK7_ALIAS = 'SE1'"

//Solicitado pelo Ronaldo em 19/10 para nao levar historico de jobs, somente de ligações para os clientes e titulos em aberto
cQuery += " INNER JOIN " + RETSQLNAME("SE1") + " SE1 "
cQuery += " ON SE1.E1_FILIAL=FK7_FILTIT AND SE1.E1_PREFIXO=FK7_PREFIX AND SE1.E1_NUM=FK7_NUM AND SE1.E1_PARCELA=FK7_PARCEL "
cQuery += " AND SE1.E1_TIPO=FK7_TIPO AND SE1.E1_CLIENTE=FK7_CLIFOR AND SE1.E1_LOJA=FK7_LOJA  AND SE1.D_E_L_E_T_=' '  AND SE1.E1_SALDO>0 "          
cQuery += " AND SE1.E1_FILIAL='"+cUNAtu+"'  AND E1_TIPO NOT LIKE '%-%' "

cQuery += " WHERE CV8_FILIAL='" + cUNAtu + "'"

cQuery += " AND UPPER(CV8_MSG) NOT LIKE '%REGUA%' "

cQuery += " AND CV8.D_E_L_E_T_ = ' ' "


DbUseArea(.T., "TOPCONN", TcGenQry(NIL, NIL, cQuery), cTMP, .T., .F.)
If (cTMP)->(Eof())		
    (cTMP)->(DbCloseArea())
    Return ""
EndIf

Return cTMP


//-----------------------------------------------------------------------------------------------
/*/{Protheus.doc} INCCV82
Rotina para transferir o CV8 de uma filial para outra

@author		By Wise
@since		01/09/2021
@version	1.0
/*/
//-----------------------------------------------------------------------------------------------

User Function INCCV82(cPar)
Local cId         := ""
Local cCodRot     := ""
Local cChave      := ""
Local lSimula     := .F.
Local aPar        := {}
Local cMsg        := ""  
Local aAreaCV8    := CV8->(GetArea())
Local cObs        := ""
Local cMsgLog     := ""
Local lRet        := .T.
Local aCposAlt    := {}
Local cCV8        := ""
Local cProcCV8    := ""
Local cUpd        := ""
Local nRenCv8     := 0

FWJsonDeserialize(cPar, @aPar)
cId     := aPar[1]
cCodRot := aPar[2]
cChave  := aPar[3]
lSimula := aPar[4]

PGG->(DbSetOrder(1))
PGG->(DbSeek(xFilial("PGG") + cId ))

cUNAtu  := PGG->PGG_FILORI
cUNNova := PGG->PGG_FILDES
cObs    := PGG->PGG_DESCRI
cCV8    := Left(cChave,32)
nRenCv8 := VAL(substr(cChave,34))

U_TILogBegin(cId, cCodRot, cChave, lSimula)

Begin Transaction
    

    If ! lSimula 
        DbSelectArea("CV8")
        CV8->(DbGoto(nRenCv8))

        u_TILogMsg(cId, cCodRot, cChave, "Atualizando CV8")
		aCposAlt := { 	{ "CV8_FILIAL"  , cUNNova }} // Codigo da filial que recebera o titulo

        If !(lRet := DuplicReg("CV8",aCposAlt) > 0) // Duplica a CV8 na filial destino
            U_TILogMsg(cId, cCodRot, cChave, "Erro na criação do registro na filial de destino")
            DisarmTransaction()
            //ProcLog(@cCabecCsv,@nHdlCsv,"CV8",aResp,"3", "Erro na criação do registro na filial de destino")
        EndIf

        If lRet

            FK7->(DbSetOrder(1))
            If FK7->(DbSeek(cUNAtu + cCV8))

                aProcCV8 := StrToArray(FK7->FK7_CHAVE,"|")
                /*
                    //Chave para ser gravada na FK7.
                cChave := SE1->E1_FILIAL + "|" +  SE1->E1_PREFIXO + "|" + SE1->E1_NUM + "|" + SE1->E1_PARCELA + "|" + SE1->E1_TIPO + "|" +SE1->E1_CLIENTE + "|" + SE1->E1_LOJA
                
                //Grava FK7 - Auxiliar da SE1|SE2
                cIdDoc := FinGrvFK7('SE1', cChave, SE1->E1_FILORIG)
                */
                //cProcCV8 := cUNNova+"|"+aProcCV8[2]+"|"+aProcCV8[3]+Space(9-Len(aProcCV8[3]))+"|"+aProcCV8[4]+Space(3-Len(aProcCV8[4]))+"|"+aProcCV8[5]+Space(3-Len(aProcCV8[5]))+"|"+aProcCV8[6]+"|00"
                cProcCV8 := cUNNova+"|"+U_From2Inc(aProcCV8[2],cUNAtu)+"|"+aProcCV8[3]+Space(9-Len(aProcCV8[3]))+"|"+aProcCV8[4]+Space(3-Len(aProcCV8[4]))+"|"+aProcCV8[5]+Space(3-Len(aProcCV8[5]))+"|"+aProcCV8[6]+"|00"
                cChaveFK7 := FINGRVFK7( "SE1", cProcCV8 ,cUNNova )
                U_TILogMsg(cId, cCodRot, cChave, cChaveFK7)   

                cUpd := " UPDATE "+RetSqlName("CV8")+" SET CV8_PROC = '"+cChaveFK7+"' "
                cUpd += " WHERE CV8_FILIAL = '" + cUNNova + "' " 
                cUpd += " AND CV8_PROC = '" + cCV8 + "' "

                If TCSQLExec(cUpd) < 0
                    U_TILogMsg(cId, cCodRot, cChave, "Erro na ATUALIZAÇÃO" + cChave)
                    DisarmTransaction()
                Else
                    TCSQLExec("COMMIT;")
                EndIf
            Else
                U_TILogMsg(cId, cCodRot, cChave, "Registro não localizado na FK7 !")
                DisarmTransaction()
            Endif 

        Endif

    EndIf 

End Transaction

If ! Empty(cMsg)
    U_TILogErro(cId, cCodRot, cChave, cMsg, lSimula)
Else
    U_TILogEnd(cId, cCodRot, cChave, lSimula, cMsgLog)
EndIf 

RestArea(aAreaCV8)

Return cMsg



/*/{Protheus.doc} DuplicReg
Funcao para duplicação de registros 

@author		Claudio Donizete
@since		25/07/2018
@version	1.0
/*/
Static Function DuplicReg(cArquiv1, aCposAlt)
Local aArea   		:= GetArea()
Local aArea1   		:= (cArquiv1)->(GetArea())
Local aCampos  		:= {}
Local nCampos		:= 0
Local nContador		:= 0
Local nElem			:= 0
Local nReturn		:= 0

If Len(aCposAlt) <= 0
    Return(nReturn)
EndIf

dbSelectArea(cArquiv1)
nCampos := FCOUNT()
For nContador := 1 To nCampos
    nElem	:= aScan(aCposAlt, { |x| AllTrim(x[1]) == FieldName(nContador) })
    If nElem > 0
        aAdd(aCampos, {FieldName(nContador), aCposAlt[nElem,2]		})
    Else
        aAdd(aCampos, {FieldName(nContador), FieldGet(nContador)	})
    EndIf
Next

RecLock( cArquiv1, .t. )
For nContador := 1 To nCampos
    // dbSelectArea(cArquiv2 )
    // FieldPut(FieldPos(aCampos[nContador, 1],aCampos[nContador, 2]) )
    cVar 		:= (cArquiv1+"->"+aCampos[nContador,1])
    &cVar		:= aCampos[nContador, 2]
Next
MsUnlock()
nReturn := RECNO()

(cArquiv1)->(RestArea(aArea1))
RestArea(aArea)

Return(nReturn)
