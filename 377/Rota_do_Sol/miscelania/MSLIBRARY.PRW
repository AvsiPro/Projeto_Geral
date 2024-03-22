/**********************************************************************************
*               Biblioteca de Rotinas Diversas para o MICROSIGA                   *
*               PROTHEUS VERSAO 8/10                                              *
**********************************************************************************/
#Include "msobject.ch"
#Include "rwmake.ch"
#Include "topconn.ch"

#Define PROTHEUS8
//#Define PROTHEUS10

/**********************************************************************************
*	            TMSLibrary: Rotinas de Uso Geral                                  *
**********************************************************************************/
Class TMSLibrary 
	Var nSeed
	Method New() Constructor
	Method NTrim(nValor)  
	Method ReverteDesconto(nValor, nDesc)
	Method Random(nMax)
	Method SToC(cDate)
EndClass  
Method New() Class TMSLibrary
	Local oRet := Self
	oRet:nSeed := Seconds()
Return oRet
Method NTrim(nValor) Class TMSLibrary
	Local cRet := LTrim(Str(nValor))
Return cRet
Method ReverteDesconto(nValor, nDesc) Class TMSLibrary
	Local nRet := nValor * (100 / (100 - nDesc)) 
Return nRet
Method Random(nMax) Class TMSLibrary
	::nSeed := Aleatorio(nMax, ::nSeed + Seconds())
Return ::nSeed
Method SToC(cDate) Class TMSLibrary
	Local cRet := DToC(SToD(cDate))
Return cRet

/**********************************************************************************
*	            TPergunta: Atualização do SX1 (Dicionario de Dados - Perguntas)   *
**********************************************************************************/
Class TPergunta
	Var Grupo
	Var Lista
	Method New(cGrupo) Constructor
	Method AddGet(cDesc, cTipo, nTam, nDec, cDefault, cF3, cPicture, cValid)
	Method AddCombo(cDesc, aOpcao, nDefault)
	Method Update()
	Method Execute(lMostra)
EndClass    
Method New(cGrupo) Class TPergunta
	Local oRet := Self
	oRet:Grupo := Left(cGrupo + Space(10), 10)
	oRet:Lista := {}
Return oRet
Method AddGet(cDesc, cType, nSize, nDec, cDefault, cF3, cPicture, cValid) Class TPergunta
	Local oRet := Self
	AAdd(oRet:Lista, { cDesc, "G", cType, nSize, nDec, cDefault, 0, {}, cF3, cPicture, cValid })
Return oRet
Method AddCombo(cDesc, aOpcao, nDefault) Class TPergunta
	Local oRet := Self
	AAdd(oRet:Lista, { cDesc, "C", "N", 1, 0, "", nDefault, aOpcao, "", "", "" })
Return oRet
Method Update() Class TPergunta
	Local oRet := Self, I, J, cCampo1, cCampo2, cCampo3, cOrdem, oLib := TMSLibrary():New()
	DbSelectArea("SX1")
	DbSetOrder(1)
	For I := 1 To 99
		cOrdem := StrZero(I, 2, 0)
		If I > Len(oRet:Lista)
			If DbSeek(oRet:Grupo + cOrdem)
				RecLock("SX1", .F.)
				DbDelete()
				MsUnlock("SX1")
			EndIf
		Else 
			If DbSeek(oRet:Grupo + cOrdem)   
				RecLock("SX1", .F.)
			Else
				RecLock("SX1", .T.)
				SX1->X1_GRUPO := oRet:Grupo
				SX1->X1_ORDEM := cOrdem
			EndIf          
			SX1->X1_PERGUNT := SX1->X1_PERSPA  := SX1->X1_PERENG  := oRet:Lista[I, 1]
			SX1->X1_VARIAVL := "Mv_Ch" + SubStr("123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ", I, 1)
			SX1->X1_VAR01   := "MV_PAR" + cOrdem
			SX1->X1_GSC     := oRet:Lista[I, 2]
			SX1->X1_TIPO    := oRet:Lista[I, 3]
			SX1->X1_TAMANHO := oRet:Lista[I, 4]
			SX1->X1_DECIMAL := oRet:Lista[I, 5]
			If Empty(SX1->X1_CNT01)  .AND. oRet:Lista[I, 6] != Nil; SX1->X1_CNT01   := oRet:Lista[I, 6]; EndIf
			If Empty(SX1->X1_PRESEL) .AND. oRet:Lista[I, 7] != Nil; SX1->X1_PRESEL  := oRet:Lista[I, 7]; EndIf
			For J := 1 To 5				
				cCampo1  := "SX1->X1_DEF" + StrZero(J, 2, 0)
				cCampo2  := "SX1->X1_DEFSPA" + oLib:Ntrim(J)
				cCampo3  := "SX1->X1_DEFENG" + oLib:NTrim(J)
				If J > Len(oRet:Lista[I, 8])                               
					&cCampo1 := &cCampo2 := &cCampo3 := ""
				Else
					&cCampo1 := &cCampo2 := &cCampo3 := oRet:Lista[I, 8, J]
				EndIf
			Next		
			SX1->X1_F3      := oRet:Lista[I, 9]
			SX1->X1_PICTURE := oRet:Lista[I, 10]
			SX1->X1_VALID   := oRet:Lista[I, 11]
			MsUnlock("SX1")
		EndIf
	Next
Return oRet
Method Execute(lMostra) Class TPergunta
	Local lRet := Pergunte(::Grupo, lMostra)
Return lRet

/**********************************************************************************
*	            TWorkFile: Criação de Arquivos DBF temporarios                    *
**********************************************************************************/
Class TWorkFile
	Var Alias
	Var Lista
	Var NomArq
	Method New(cAlias) Constructor
	Method AddField(cName, cType, nSize, nDec)
	Method Create()
	Method SortOn(cIndexKey)                 
	Method Display(cTitle, aColInfo)
	Method AppendRecord(aValues)
EndClass
Method New(cAlias) Class TWorkFile
	Local oRet := Self
	oRet:Alias := cAlias
	oRet:Lista := {}
Return oRet
Method AddField(cName, cType, nSize, nDec) Class TWorkFile
	Local oRet := Self
	AAdd(oRet:Lista, { cName, cType, nSize, nDec })
Return oRet
Method Create() Class TWorkFile
	Local oRet := Self   
	If Select(oRet:Alias) != 0
		(oRet:Alias)->(DbCloseArea())
	EndIf
	oRet:NomArq := CriaTrab(oRet:Lista)
	DbUseArea(.T., , oRet:NomArq, oRet:Alias, Nil, .F.)
Return oRet
Method SortOn(cIndexKey) Class TWorkFile
	Local oRet := Self
	IndRegua(oRet:Alias, oRet:NomArq, cIndexKey, , , "")
Return oRet
Method Display(cTitle, aColInfo) Class TWorkFile
	Local oDlg, oGrp, oBtn, oBrw, I, J, cBlock, cAlign, oRet := Self
	(oRet:Alias)->(DbGoTop())
	oDlg := MSDialog():New(0, 0, 550, 700, cTitle,,,,,,,,, .T.)
	oGrp := TGroup():New(010/2, 010/2, 480/2, 690/2,, oDlg, ,, .T.)
	oGrp := TGroup():New(490/2, 010/2, 540/2, 690/2,, oDlg, ,, .T.)
	oBtn := TButton():New(500/2, 620/2, "Fechar",  oDlg, { || oDlg:End() }, 060/2, 025/2,,,, .T.,,,, { || .T. })
	oBrw := MSSelBR():New(020/2, 020/2, 660/2, 450/2,,,, oDlg,,,,,,,,,,,,, oRet:Alias, .T.)
	For I := 1 To Len(oRet:Lista)
		J := AScan(aColInfo, { |Item| Item[1] == oRet:Lista[I, 1] })
		If J != 0
			cBlock := "{ || "
			If     oRet:Lista[I, 2] == "D"
				cBlock += "DToC(" + oRet:Alias + "->" + oRet:Lista[I, 1] + ")"
				cAlign := "CENTER"
			ElseIf oRet:Lista[I, 2] == "N"
				cBlock += "LTrim(Str(" + oRet:Alias + "->" + oRet:Lista[I, 1] + ", " + LTrim(Str(oRet:Lista[I, 3])) + ", " + LTrim(Str(oRet:Lista[I, 4])) + "))"
				cAlign := "RIGHT"
			Else
				cBlock += oRet:Alias + "->" + oRet:Lista[I, 1]
				cAlign := "LEFT"
			EndIf
			cBlock += " }"
			oBrw:AddColumn(TCColumn():New(aColInfo[J, 2], &cBlock,,,, cAlign,, .F., .F.,,,, .F.))
		EndIf
	Next
	oDlg:Activate(,,, .T., { || .T. /*OnClose*/ },, { || NIL /*OnShow*/ })
Return oRet
Method AppendRecord(aValues) Class TWorkFile
	Local SaveArea := GetArea(), nI
	RecLock(::Alias, .T.)       
	For nI := 1 To Len(aValues)
		&(::Alias+"->"+::Lista[nI, 1]) := aValues[nI]
	Next
	MsUnlock(::Alias)
Return RestArea(SaveArea)


Class TMSLog          
	Var Custom
	Var LogID       
	Method New(aCustom) Constructor
	Method AddLog(aLogData)
	Method Display()
EndClass
Method New(aCustom) Class TMSLog
	Local I, oRet := Self, oLog := TWorkFile():New("LOG")
	If aCustom == Nil; aCustom := {}; EndIf
	AAdd(aCustom, {"LOG_TEXTO", 100, "Log"})	
	oRet:Custom := {}
	oLog:AddField("LOG_ID",    "N",  10, 0)
	oLog:AddField("LOG_DATA",  "D",  08, 0)
	oLog:AddField("LOG_HORA",  "C",  08, 0)
	oRet:Custom := aCustom 
	For I := 1 To Len(oRet:Custom)
		oLog:AddField(oRet:Custom[I, 1], "C", oRet:Custom[I, 2], 0)
	Next
	oLog:Create()
	oLog:SortOn("LOG_ID")
	oRet:LogID := 0
Return oRet
Method AddLog(aLogData) Class TMSLog
	Local SaveArea := GetArea(), I, cField
	RecLock("LOG", .T.)
	LOG->LOG_ID    := ++::LogID
	LOG->LOG_DATA  := Date()
	LOG->LOG_HORA  := Time()        
	For I := 1 To Len(::Custom)
		cField  := "LOG->" + ::Custom[I, 1]
		&cField := Left(aLogData[I], ::Custom[I, 2])
	Next
	MsUnlock("LOG")	
Return RestArea(SaveArea)
Method Display(lShowDH) Class TMSLog
	Local oDlg, oGrp, oBtn, oBrw, I, cBlock
	If lShowDH == Nil; lShowDH := .F.; EndIf
	LOG->(DbGoTop())
	oDlg := MSDialog():New(0, 0, 550, 700, "Log",,,,,,,,, .T.)
	oGrp := TGroup():New(010/2, 010/2, 480/2, 690/2,, oDlg, ,, .T.)
	oGrp := TGroup():New(490/2, 010/2, 540/2, 690/2,, oDlg, ,, .T.)
	oBtn := TButton():New(500/2, 620/2, "Fechar",  oDlg, { || oDlg:End() }, 060/2, 025/2,,,, .T.,,,, { || .T. })
	oBrw := MSSelBR():New(020/2, 020/2, 660/2, 450/2,,,, oDlg,,,,,,,,,,,,, "LOG", .T.)
	If lShowDH
		oBrw:AddColumn(TCColumn():New("Data/Hora", {|| DToC(LOG->LOG_DATA)+" "+LOG->LOG_HORA },,,, "CENTER",, .F., .F.,,,, .F.))
	EndIf
	For I := 1 To Len(::Custom)
		cBlock := "{ || LOG->"+::Custom[I, 1]+" }"
		oBrw:AddColumn(TCColumn():New(::Custom[I, 3], &cBlock,,,, "LEFT"  ,, .F., .F.,,,, .F.))
	Next
	oDlg:Activate(,,, .T., { || .T. /*OnClose*/ },, { || NIL /*OnShow*/ })
Return
