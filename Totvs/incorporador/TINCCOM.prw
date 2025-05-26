#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

User Function INCCOM1(cPar)
    Local aPar      := {}
    Local cIdProc   := ""
    Local cCodRot   := ""
    Local aArea     := GetArea()
    Local aAreaPGG  := PGG->(GetArea())
    Local aAreaPGH  := PGH->(GetArea())
    Local cChave    := ""
    
    Local nL        := 1
    Local nM        := 1
    Local cAlias    := ""
    Local cQuery    := "select * from..."
    Local nRecno    := 0
    Local aPergunte := {}
    Local aDados    := {}
    Local aAux      := {}
    Local aChave    := {"ZXO_FILIAL","ZXO_EMPORI","ZXO_CLIENT","ZXO_LOJA","ZXO_DOC","ZXO_SERIE","ZXO_PARCEL","ZXO_VEND","ZXO_PRODUT","ZXO_ITEM","ZXO_CODPAP","ZXO_TIPCOM","ZXO_REVISA"}
	Local aCabec    := {}
    Local aIncRod	:= {}

    Private lAbortPrint := .F.

    FWJsonDeserialize(cPar, @aPar)
    cIdProc := aPar[1]
    cCodRot := aPar[2]
    If Len(aPar) > 2
        aPergunte := aPar[3]
    EndIF
    
    PGG->(DbSetOrder(1))
    PGG->(DbSeek(xFilial("PGH") + cIDProc ))

    PGH->(DbSetOrder(1))
    PGH->(DbSeek(xFilial("PGH") + cIDProc + cCodRot))

    cUNAtu := PGG->PGG_FILORI
    cUNNova:= PGG->PGG_FILDES

    aIncRod := U_INCFUN1(cUNAtu)

    If len(aIncRod) > 0
        cTargetFile := Alltrim(MV_PAR01)

        oFile := FWFileReader():New( cTargetFile )

        If (oFile:Open())
        
            While (oFile:hasLine())
                cTexto := oFile:GetLine()
                If !Empty(cTexto)
                    If nL == 1
                        Aadd(aCabec,Separa(cTexto, ";", .T.))
                    Else
                        AADD(aDados, Separa(cTexto, ";", .T.))
                    EndIf
                EndIf
                nL++
            EndDo

            oFile:Close()
        else
            MsgAlert("Arquivo não encontrado!!!")
            Return
        EndIf

        nPosIdS :=  Ascan(aCabec[1],{|x| x == "IDSEQ"})
        nPosLok :=  Ascan(aCabec[1],{|x| x == "LOOKUP"})

        FreeObj(oFile)
        oFile := Nil

        nTot := len(aDados)
        ProcRegua(nTot)
        
        cAlias := "ZXO"

        For nL := 1 to len(aDados)
            aAux := Separa(aDados[nL,nPosLok], "|", .T.)

            IncProc("processando linha " + Str(nL, 6)   )
            ProcessMessage()

            cChave := ""
            For nM := 2 to len(aAux)-1
                cChave += Avkey(aAux[nM],aChave[nM])
            Next nM
            
            nIdSeq := aDados[nL,nPosIdS]

            nRecno := REGTBZO(aAux,aChave,nIdSeq)
            cChave += strzero(nRecno,8)

            
            PGI->(DbSetOrder(1))
            IF !PGI->(DbSeek(xFilial("PGI") + cIdProc + cCodRot + cChave))
            
                
                cQuery := ""
                u_TILogNew(cIdProc, cCodRot, cChave, cQuery, cAlias, nRecno)
                
                Aeval(aAux,{|x| cQuery += x +";"})
                
                PGI->(DbSetOrder(1))
                PGI->(DbSeek(xFilial("PGI") + cIdProc + cCodRot + cChave))
                PGI->(RecLock("PGI", .F.))
                PGI->PGI_OBS	:= Alltrim(PGI->PGI_OBS) + cQuery
                PGI->(MsUnlock())
                
            ENDIF
        Next nL
    else
        MsgAlert("Não encontrado itens na tabela de De/Para da filial de origem - ZX5 tabela _INCDP")
    EndIf
    
    RestArea(aAreaPGH)
    RestArea(aAreaPGG)
    RestArea(aArea)

Return 



User Function INCCOM2(cPar)

    Local cUNAtu      := ""
    Local cUNNova     := ""
    Local cMsg        := ""  

    Local cId         := ""
    Local cCodRot     := ""
    Local cChave      := ""
    Local lSimula     := .F.
    Local aPar        := {}
    Local aPergunte   := {}
    Local cPerg       := ""
    Local lSemInc     := .F.
    Local cPreDest
    Local aParDePa    := {}
    
    FWJsonDeserialize(cPar, @aPar)
    cId     := aPar[1]
    cCodRot := aPar[2]
    cChave  := aPar[3]
    lSimula := aPar[4]

    If Len(aPar) > 4
        aPergunte := aPar[5]
        cPerg := U_TIncISX1(cCodRot, aPergunte, "01")
        lSemInc := U_TIncISX1(cCodRot, aPergunte, "02") == 1
    EndIF    

    PGG->(DbSetOrder(1))
    PGG->(DbSeek(xFilial("PGG") + cId ))

    cUNAtu  := PGG->PGG_FILORI
    cUNNova := PGG->PGG_FILDES
    
    cPreDest    := '' //Alltrim(SuperGetMV("TI_PRFDEST",,"",cUNNova))
    aParDePa    := U_INCFUN1(cUNAtu)

    U_TILogBegin(cId, cCodRot, cChave, lSimula)

    Begin Transaction

        If ! lSimula 

            AtuComs(cId, cCodRot, cChave, cPreDest, aParDePa)
            
        EndIf 

    End Transaction

    If ! Empty(cPerg)
        cPerg := "Pergunta: " + cPerg
        IF ! Empty(cMsg)
            cMsg += cPerg
        EndIF
    EndIf

    If ! Empty(cMsg)
        U_TILogErro(cId, cCodRot, cChave, cMsg, lSimula)
    Else
        U_TILogEnd(cId, cCodRot, cChave, lSimula, cPerg)
    EndIf 


Return cMsg

Static Function AtuComs(cId, cCodRot, cChave, cPreDest, aParDePa)

    Local aArea         :=  GetArea()
    Local lRet          :=  .T.
    Local nPosDP        :=  0
    Local aAreaZXO      :=  {}
    //Local cParExcP      :=  Alltrim(SuperGetMV("TI_PAREXPR",,"UNE/001"))
    
    Private aCposAlt    :=  {}

    u_TILogMsg(cId, cCodRot, cChave, "Atualizando comissões ZXO e ZPX")

    cAliasZPX := GetNextAlias()
    
    PGI->(DbSetOrder(1))
    PGI->(DbSeek(xFilial("PGI") + cId + cCodRot + cChave))

    If PGI->PGI_RECORI > 0
        DbSelectArea("ZXO")
        ZXO->(DbGoto(PGI->PGI_RECORI))
        cPreDest := ''
        nPosDP := Ascan(aParDePa,{|x| Alltrim(x[1]) == Alltrim(ZXO->ZXO_SERIE)})

        If nPosDp > 0
            cPreDest := Alltrim(aParDePa[nPosDP,02])
        EndIf
        
        aCposAlt := { 	{ "ZXO_EMPFAT"  , cEmpAnt + PGG->PGG_FILDES } ,;
                        { "ZXO_EMPORI"  , cEmpAnt + PGG->PGG_FILDES } ,;
                        { "ZXO_SERIE"   , If(!Empty(cPreDest),cPreDest,ZXO->ZXO_SERIE)  },;
                        { "ZXO_GERADO"  , "Z" } }  // Codigo da filial que recebera o titulo

        //{ "ZXO_SERIE"   , If(Empty(cPreDest) .Or. (ZXO->ZXO_SERIE $ cParExcP),ZXO->ZXO_SERIE,cPreDest)   },;
                        

        If !(lRet := DuplicReg("ZXO",aCposAlt) > 0)
            U_TILogErro(cId, cCodRot, cChave, cMsg, lSimula)
        EndIf

        aAreaZXO := GetArea()

        BeginSql Alias cAliasZPX
            SELECT R_E_C_N_O_ RECNOZPX
            FROM %table:ZPX%
            WHERE ZPX_FILIAL = %xFilial:ZPX%
            AND ZPX_DOC = %exp:ZXO->ZXO_DOC%
            AND ZPX_SERIE = %exp:ZXO->ZXO_SERIE%
            AND ZPX_TIPO = %exp:ZXO->ZXO_TIPO%
            AND ZPX_ITEM = %exp:ZXO->ZXO_ITEM%
            AND ZPX_CLIENT = %exp:ZXO->ZXO_CLIENT%
            AND ZPX_LOJA = %exp:ZXO->ZXO_LOJA%
            AND ZPX_PARCEL = %exp:ZXO->ZXO_PARCEL%
            AND ZPX_EMPFAT = %exp:ZXO->ZXO_EMPFAT%
            AND ZPX_VEND   = %exp:ZXO->ZXO_VEND%
            AND ZPX_GC     = %exp:ZXO->ZXO_GC%
            AND ZPX_CODPAP = %exp:ZXO->ZXO_CODPAP%
            AND ZPX_TIPAGN = %exp:ZXO->ZXO_TIPAGN%
            AND %notDel%
        EndSql

        // Transfere ZPX
        While !(cAliasZPX)->(Eof())
            ZPX->(DbGoto((cAliasZPX)->RECNOZPX))

            aCposAlt := { 	{ "ZPX_EMPFAT"  , cEmpAnt + PGG->PGG_FILDES } ,;
                            { "ZPX_SERIE"   , If(!Empty(cPreDest),cPreDest,ZPX->ZPX_SERIE)    } ,;
                            { "ZPX_GERADO"  , "Z" } }  // Codigo da filial que recebera o titulo

            //{ "ZPX_SERIE" , If(Empty(cPreDest) .Or. (!ZPX->ZPX_SERIE $ cParExcP),ZPX->ZPX_SERIE,cPreDest)   } ,;
            
            If !(lRet := DuplicReg("ZPX",aCposAlt) > 0)
                U_TILogErro(cId, cCodRot, cChave, cMsg, lSimula)
            EndIf

            RecLock("ZPX", .F.)
            ZPX->ZPX_FILIAL := PGG->PGG_FILORI
            MsUnLock()
            (cAliasZPX)->(DBSkip())
        End

        (cAliasZPX)->(DBCloseArea())

        RestArea(aAreaZXO)

        ZXO->(DbGoto(PGI->PGI_RECORI))
        RecLock("ZXO", .F.)
        ZXO->ZXO_FILIAL := PGG->PGG_FILORI
        MsUnLock()
    EndIf

    RestArea(aArea)

Return 



 /*/{Protheus.doc} REGTBZO()
    (long_description)
    @type  Function
    @author user
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
static Function REGTBZO(aAux,aChave,nIdSeq)

Local cQuery := ""
Local nCont  := 0
Local nRet   := 0

cQuery := "SELECT R_E_C_N_O_ AS REGISTRO FROM "+RetSQLName("ZXO")
cQuery += " WHERE ZXO_IDSEQ='"+cvaltochar(nIdSeq)+"'"
cQuery += " AND ZXO_FILIAL = '  ' AND D_E_L_E_T_=' '"

For nCont := 2 to len(aChave)
    cQuery += " AND "+aChave[nCont]+" = '"+If(!Empty(aAux[nCont]),aAux[nCont]," ")+"'"
Next nCont
//ZXO_EMPORI='0002501002000' AND ZXO_CLIENT='TFBRKG' AND ZXO_LOJA='00' AND ZXO_DOC='000005122' AND ZXO_SERIE='UNE' AND ZXO_PARCEL='   ' AND ZXO_VEND='ASE764' AND ZXO_PRODUT='BMV.8041' AND ZXO_ITEM='01'"

If Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

nRet := TRB->REGISTRO

Return(nRet)

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

	RecLock( cArquiv1, .T., , .T. )
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
