#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE 'Protheus.ch'
#INCLUDE 'FWMVCDef.ch'

/*/{Protheus.doc} User Function CONESN1
    @type  Function
    @author user
    @since 28/12/2022
    @version 1 
    /*/
User Function CONESN1()

	LOCAL aPerg        := {}
	LOCAL aLinha       := {}
	LOCAL aAux         := {}
	LOCAL cHandle      := ""
	LOCAL cLine        := ""
	LOCAL nHandle      := 0
    Local nX           := 1
    Local nLast        := 0

	Private nPosA1	
	Private aCabec	   := {}
	
	Private cChapa       := ""

	If Empty(FunName())
		RpcSetType(3)
		RPCSetEnv("01","0101")
	EndIf

	aAdd(aPerg,{6,"Buscar arquivo",Space(50),"","","",50,.T.,"Arquivos compativeis (*.csv*) |*.csv*"})

	If ParamBox(aPerg, "Informe o arquivo desejado!")

		cHandle  := MV_PAR01

	else
		MsgAlert("Operacao abortada!", "Erro!")
		RETURN
	ENDIF

	nHandle := FT_FUSE(cHandle)

	// Se houver erro de abertura abandona processamento
	if nHandle = -1
		return
	endif

	// Posiciona na primeria linha
	FT_FGoTop()

	// Retorna o número de linhas do arquivo
	nLast := FT_FLastRec()

	While !FT_FEOF()

		cLine := FT_FReadLn()

		aLinha  := Separa(cLine,';',.T.)

		If nX == 1
			aCabec := aLinha
			nPosA1 := Ascan(aCabec,{|x| x == "A1_CGC"})
			nX := 2
		Else
			if len(aLinha) > 1 .AND. AllTrim(aLinha[1]) != ""
				Aadd(aAux, aLinha)    
			endif
		EndIf
		// Pula para próxima linha
		FT_FSKIP()

	End

	// Fecha o Arquivo
	FT_FUSE()

    for nX := 1 to len(aAux)
    	EXECSN1(aAux[nX])
    next

Return

Static Function EXECSN1(aAux)
    
Local aArea 	:=	GetArea()
Local nCont 	:=	0

	DbSelectArea("SA1")
	DbSetOrder(3)
	DbSeek(xFilial("SA1")+strtran(strtran(strtran(aAux[nPosA1],".",""),"-",""),"/",""))

	dbSelectArea("SN1")
	DbSetOrder(2)
	if aAux[2] $ cChapa .OR. DbSeek(xFilial("SN1") + AvKey(aAux[2], "N1_CBASE"))
		return
	endif

	cChapa += aAux[2] + "/"

    DbSelectArea("SN1")
    RecLock("SN1", .T.)
        SN1->N1_FILIAL  := xFilial("SN1")   
        SN1->N1_PATRIM  := "N"
        SN1->N1_QUANTD  := 1
		SN1->N1_XCLIENT := SA1->A1_COD 
		SN1->N1_XLOJA   := SA1->A1_LOJA

		For nCont := 1 to len(aCabec)
			If substr(aCabec[nCont],1,2) == "N1"
				&(SN1->(aCabec[nCont])) := If(aCabec[nCont]=="N1_AQUISIC",ctod(aAux[nCont]),If(aCabec[nCont]=="N1_QUANTD",val(aAux[nCont]),aAux[nCont]))
			EndIf
		Next nCont
		/*
		SN1->N1_CBASE   := aAux[1]   
        SN1->N1_ITEM    := "0001"   
        SN1->N1_DESCRIC := aAux[2]  
        SN1->N1_CHAPA   := aAux[1]
        SN1->N1_PRODUTO := aAux[3]  
        SN1->N1_XNUMSER := aAux[5]
        SN1->N1_XALUGAD := IF(aAux[6] == "1", "S", "N")
		*/
    MsUnlock()
    DBCLOSEAREA()

    DbSelectArea("SN3")
    RecLock("SN3", .T.)
	SN3->N3_FILIAL  := xFilial("SN3")
	SN3->N3_ITEM    := "0001"
	SN3->N3_TIPO    := "01"
	SN3->N3_DINDEPR := dDataBase
	SN3->N3_HISTOR  := "INICIO"
	SN3->N3_CCONTAB := "1000"
	SN3->N3_CBASE   := aAux[2]
	
	For nCont := 1 to len(aCabec)
		If substr(aCabec[nCont],1,2) == "N3"
			&(SN3->(aCabec[nCont])) := If(aCabec[nCont] == "N3_VORIG1",val(aAux[nCont]),aAux[nCont])
		EndIf
	Next nCont
    MsUnlock()
    DBCLOSEAREA()

RestArea(aArea)

Return 
