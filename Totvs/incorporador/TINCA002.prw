#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'


//-----------------------------------------------------------------------------
/*/ {Protheus.doc} 
			Define as operacoes da aplicaecao
@author  	Wagner Mobile Costa
@version 	P12
@since   	18/11/2020
@Parametros:
/*/
//-----------------------------------------------------------------------------
Static Function MenuDef()
	Local aRotina := {}

	
    ADD OPTION aRotina TITLE "Atualizar Tela" ACTION "U_TINCRFSH"  	OPERATION MODEL_OPERATION_VIEW ACCESS 0
    ADD OPTION aRotina TITLE "Visualizar"     ACTION "VIEWDEF.TINCA002"  OPERATION MODEL_OPERATION_VIEW ACCESS 0
    ADD OPTION aRotina TITLE "Executar Linha" ACTION "U_TINExLn"  	OPERATION MODEL_OPERATION_VIEW ACCESS 0
    ADD OPTION aRotina TITLE "Executar Selecionados" ACTION "U_TINExSl(.F.,.F.)"  	OPERATION MODEL_OPERATION_VIEW ACCESS 0
    ADD OPTION aRotina TITLE "Marcar/Desmarcar Ocorrencias"   ACTION "U_TINISLn"  	OPERATION MODEL_OPERATION_VIEW ACCESS 0
    ADD OPTION aRotina TITLE "Ignora Linha"   ACTION "U_TINIgLn"  	OPERATION MODEL_OPERATION_VIEW ACCESS 0
    ADD OPTION aRotina TITLE "Ignora Selecionados"   ACTION "U_TINIgSl"  	OPERATION MODEL_OPERATION_VIEW ACCESS 0

Return aRotina


Static Function ModelDef()
	
	Local oStruPGI	:= FWFormStruct(1,'PGI')
	Local oModel	:= MPFormModel():New( 'TINCM002',,, )
	
	oModel:SetDescription("Registros Incorporação") 
	oModel:AddFields( 'PGIMASTER', , oStruPGI )
	oModel:SetPrimaryKey({})

Return oModel


Static Function ViewDef()
	
	Local oModel		:= FWLoadModel("TINCA002")
	Local oView			:= FWFormView():New()
	
	oStruPGI		:= FWFormStruct(2,'PGI' )
	
	oView:SetModel( oModel )
	oView:AddField('VIEW_PGI'	,oStruPGI	,'PGIMASTER')
	oView:CreateHorizontalBox('CABEC'	,100)
	oView:SetOwnerView('VIEW_PGI'		,'CABEC' )
	oView:SetCloseOnOk({||.T.})

Return oView



User Function TINExLn(cAlias, nRecno, nOpc)
    Local aPar    := {}
    Local cPar    := ""
    Local cIdProc := M->PGH_IDPROC
    Local cCodRot := M->PGH_CODROT
    Local cRotLog := Alltrim(M->PGH_FUNPRO)
    Local cChave  := ""
    Local lSimula := .F.
    Local bBloco  
    Local cFilter := PGI->(DbFilter())
    Local aPergunte := {}

    PGH->(DbSetOrder(1))
    PGH->(DbSeek(xFilial("PGH") + cIdProc + cCodRot))
    
	IF ! Empty(cFilter)
        PGI->(DbClearFil())
    EndIF
    PGI->(DbGoto(nRecno))

    If PGH->PGH_STEXEC == "1" // atualização não iniciada
        lSimula := .T.
    EndIf 
    
    cChave := Alltrim(PGI->PGI_CHAVE)

    If lSimula
        If ! MsgYesNO("Chave: " + cChave + CRLF + "Confirma a simulação desta linha?")
	        Return
        EndIf

        // Verifica se a rotina tem perguntas e carrega
        If ! U_TIncLSX1("PGJ_PERGSM", @aPergunte)
            Return
        EndIF
    Else
        If ! MsgYesNO("Chave: " + cChave + CRLF + "Confirma a execução desta linha?")
	        Return
        EndIf

        // Verifica se a rotina tem perguntas e carrega
        If ! U_TIncLSX1("PGJ_PERGEX", @aPergunte)
            Return
        EndIF
    EndIf 
    
    aPar := {cIdProc, cCodRot, cChave, lSimula, aPergunte }
    cPar := FwJsonSerialize(aPar)

    If ! "(" $ cRotLog
        cRotLog += "('" + cPar + "')"
    EndIf 
    bBloco := &("{ ||" + cRotLog + "}")

    Processa( bBloco ,,, .T.)

    // Atualiza status da incorporação
	IF ! Empty(cFilter)
        DbSelectArea("PGI")
        DbSetFilter({|| &cFilter}, cFilter)
        DbGoTop()
    EndIF
    U_TINCRFSH()

Return 



User Function TINExSl(lMonoTrd, lSimula)
Default lMonoTrd := .F.

If ! lSimula
    If  PGH->PGH_STEXEC == "1"
        PGH->(RecLock("PGH", .F.))
        PGH->PGH_STEXEC := "2"
        PGH->(MsUnLock())
    EndIf 
EndIf 

MsgRun( "Aguarde... Executando Registros Marcados", "Executando/Simulando", {|| IntTINExSl(lMonoTrd) } )

Return

Static Function IntTINExSl(lMonoTrd)
    Local aPar    := {}
    Local cPar    := ""
    Local cIdProc := M->PGH_IDPROC
    Local cCodRot := M->PGH_CODROT
    Local cRotLog := ""
    Local cChave  := ""
    Local lSimula := .F.
    Local bBloco  
    Local cFilter := PGI->(DbFilter())
    Local aPergunte := {}
    Local lRegLib  := .T.

    PGH->(DbSetOrder(1))
    PGH->(DbSeek(xFilial("PGH") + cIdProc + cCodRot))
    
	IF ! Empty(cFilter)
        PGI->(DbClearFil())
    EndIF

    If PGH->PGH_STSIMU <> "3" // simulacao nao finalizada
        lSimula := .T.
    EndIf 
        
    // Verifica se a rotina tem perguntas e carrega
    If ! U_TIncLSX1("PGJ_PERGSM", @aPergunte)
        Return
    EndIF

    PGI->(DbSeek(xFilial("PGI") + cIdProc + cCodRot))

    While PGI->(PGI_FILIAL + PGI_IDPROC + PGI_CODROT) == xFilial("PGI") + cIdProc + cCodRot
        If lMonoTrd
            lRegLib := If(lSimula, PGI->PGI_STSIMU == "1", PGI->PGI_STEXEC == "1") 
        Else
            lRegLib := If(lSimula, PGI->PGI_STSIMU $ "4,5", PGI->PGI_STEXEC $ "4,5") .And. PGI->PGI_OK == oBrowsePGI:cMark
        ENDIF
        IF lRegLib    
            cChave := Alltrim(PGI->PGI_CHAVE)
            aPar := {cIdProc, cCodRot, cChave, lSimula, aPergunte}
            cPar := FwJsonSerialize(aPar)

            cRotLog := Alltrim(M->PGH_FUNPRO)
            If ! "(" $ cRotLog
                cRotLog += "('" + cPar + "')"
            EndIf 
            bBloco := &("{ ||" + cRotLog + "}")

            nRecno := PGI->(Recno())
            Processa( bBloco ,,, .T.)
            PGI->(DbGoto(nRecno))
        EndIF
        PGI->(DbSkip())
    EndDo

    // Atualiza status da incorporação
	IF ! Empty(cFilter)
        DbSelectArea("PGI")
        DbSetFilter({|| &cFilter}, cFilter)
        DbGoTop()
    EndIF
    U_TINCRFSH()

Return 

User Function TINISLn

    MarkAll("PGI", oBrowsePGI)

Return

User Function TINIgSl(cAlias, nRecno, nOpc)
    Local cIdProc := M->PGH_IDPROC
    Local cCodRot := M->PGH_CODROT
    Local lSimula := .F.

    PGH->(DbSetOrder(1))
    PGH->(DbSeek(xFilial("PGH") + cIdProc + cCodRot))
    
    If PGH->PGH_STEXEC == "1" // atualização não iniciada
        lSimula := .T.
    EndIf 

    If ! lSimula
        MsgStop("Opção disponivel em momento de simulação!!!")
        Return 
    EndIf 

    PGI->(DbSeek(xFilial("PGI") + cIdProc + cCodRot))

    While PGI->(PGI_FILIAL + PGI_IDPROC + PGI_CODROT) == xFilial("PGI") + cIdProc + cCodRot
        If PGI->PGI_STSIMU = "4" .And. PGI->PGI_OK == oBrowsePGI:cMark
            PGI->(RecLock("PGI", .F.))
            PGI->PGI_STSIMU := "5"
            PGI->(MsUnLock())
        EndIF
        PGI->(DbSkip())
    EndDo

    U_TINCRFSH()
Return

User Function TINIgLn(cAlias, nRecno, nOpc)
    Local cIdProc := M->PGH_IDPROC
    Local cCodRot := M->PGH_CODROT
    Local cChave  := ""
    Local lSimula := .F.

    PGH->(DbSetOrder(1))
    PGH->(DbSeek(xFilial("PGH") + cIdProc + cCodRot))
    
    PGI->(DbGoto(nRecno))

    If PGH->PGH_STEXEC == "1" // atualização não iniciada
        lSimula := .T.
    EndIf 

    If ! lSimula
        MsgStop("Opção disponivel em momento de simulação!!!")
        Return 
    EndIf 
    
    cChave := Alltrim(PGI->PGI_CHAVE)
    
    If PGI->PGI_STSIMU <> "5"
        If ! MsgYesNO("Chave: " + cChave + CRLF + "Deseja ignorar essa linha na simulação")
            Return
        EndIf
        PGI->(RecLock("PGI", .F.))
        PGI->PGI_STSIMU := "5"
        PGI->(MsUnLock())

    Else 
        If ! MsgYesNO("Chave: " + cChave + CRLF + "Deseja disponibilizar essa linha para a simulação?")
            Return
        EndIf
        PGI->(RecLock("PGI", .F.))
        PGI->PGI_STSIMU := "1"
        PGI->(MsUnLock())

        PGH->(RecLock("PGH", .F.))
        PGH->PGH_STSIMU := "2"      // Em andamento
        PGH->PGH_DFIM_S := Ctod("")
        PGH->PGH_HFIM_S := ""
        PGH->PGH_TIME_S := ""
        PGH->(MsUnLock())
    EndIf 

    U_TINCRFSH()

Return     

User Function TINCMON(oView)

	Local aCoors 		:= FWGetDialogSize(oMainWnd)
	Local oFWLayer		:= NIL
	Local oPanelPGH		:= NIL
	Local cFiltro       := ""
    Local oModel        := FwModelActive()
    Local cIdProc       := oModel:GetModel('PGHDETAIL'):GetValue('PGH_IDPROC')
    Local cCodRot       := oModel:GetModel('PGHDETAIL'):GetValue('PGH_CODROT')
    Local lSimula       := .F.
    
	Private oEncCab		:= NIL
	Private oBrowsePGI	:= NIL
	Private cCadastro	:= "Transações - Processamentos em Lote"
	Private oDlgPrinc	:= NIL
    
    If oView <> Nil .And. oView:oModel:nOperation == MODEL_OPERATION_INSERT
        Help(,, "Incorporador",, "Opção não disponivel durante a inclusão !", 1, 0) 
        Return .F.
    EndIf

    PGH->(DbSetOrder(1))
    PGH->(DbSeek(xFilial("PGH") + cIdProc + cCodRot))

    PGI->(DbSetOrder(1))
    PGI->(DbSeek(xFilial("PGI") + cIdProc + cCodRot))

	
	CursorWait()

    If PGH->PGH_STEXEC == "1" // atualização não iniciada
        lSimula := .T.
    EndIf 

    U_TIAtuPGH(PGH->PGH_IDPROC, PGH->PGH_CODROT, lSimula) 
	
	RegToMemory("PGH",.F.,.T.,.T.)
	
	DEFINE MSDIALOG oDlgPrinc Title cCadastro From aCoors[1], aCoors[2] To aCoors[3], aCoors[4] PIXEL	

		oFWLayer := FWLayer():New()
		oFWLayer:Init(oDlgPrinc, .F., .T.)

		oFWLayer:AddLine("UP", 50, .F.)
		oFWLayer:AddCollumn("CABEC", 100, .T., "UP")
		oPanelPGH := oFWLayer:GetColPanel("CABEC", "UP")
		
        oEncCab:= 	MSMGet():New("PGH",PGH->(Recno()),2,,,,,{0,0,0,0},,,,,,oPanelPGH,,,,,,,,,,,,.T.)
		oEncCab:oBox:Align := CONTROL_ALIGN_ALLCLIENT
		
		oFWLayer:AddLine("DOWN", 50, .F.)
		oFWLayer:AddCollumn("ALL" , 100, .T., "DOWN")
		oPanelCN9 := oFWLayer:GetColPanel("ALL", "DOWN")

		oBrowsePGI	:= FWMarkBrowse():New()
    	oBrowsePGI:SetFieldMark( "PGI_OK" )
        oBrowsePGI:SetValid({ || ValidMark() })
		oBrowsePGI:SetOwner(oPanelCN9)
    	oBrowsePGI:SetAllMark( {|| MarkAll("PGI", oBrowsePGI)} )
		oBrowsePGI:SetDescription("Registros Incorporação ") 
		oBrowsePGI:SetMenuDef("TINCA002")
        oBrowsePGI:oBrowse:SetMainProc("TINCA002")
        oBrowsePGI:DisableDetails()
		oBrowsePGI:SetAlias("PGI")
		oBrowsePGI:Alias("PGI")
		oBrowsePGI:SetProfileID("2")
		oBrowsePGI:ForceQuitButton()
 
        oBrowsePGI:SetTopFun("FWxFilial('PGI')+PGH->PGH_IDPROC+PGH->PGH_CODROT")
        oBrowsePGI:SetBotFun("FWxFilial('PGI')+PGH->PGH_IDPROC+PGH->PGH_CODROT")

	//	oBrowsePGI:SetFilterDefault( "PGI_IDPROC + PGI_CODROT == PGH_IDPROC + PGH_CODROT ")
        If lSimula
            oBrowsePGI:AddLegend( "PGI_STSIMU=='1'", "WHITE" , "Não iniciado" )
		    oBrowsePGI:AddLegend( "PGI_STSIMU=='2'", "YELLOW", "Em simulação" )
		    oBrowsePGI:AddLegend( "PGI_STSIMU=='3'", "GREEN" , "Concluido" )
            oBrowsePGI:AddLegend( "PGI_STSIMU=='4'", "RED"   , "Ocorrencia" )
            oBrowsePGI:AddLegend( "PGI_STSIMU=='5'", "BLACK" , "Ignorado" )
        Else
            oBrowsePGI:AddLegend( "PGI_STEXEC=='1'", "WHITE"  , "Não iniciado" )
		    oBrowsePGI:AddLegend( "PGI_STEXEC=='2'", "YELLOW" , "Em atualização" )
		    oBrowsePGI:AddLegend( "PGI_STEXEC=='3'", "GREEN"  , "Concluido" )
            oBrowsePGI:AddLegend( "PGI_STEXEC=='4'", "RED"    , "Ocorrencia" )
            oBrowsePGI:AddLegend( "PGI_STSIMU=='5'", "BLACK"  , "Ignorado" )
        EndIf

		oBrowsePGI:Activate()
		
	ACTIVATE MSDIALOG oDlgPrinc CENTER

	oBrowsePGI	:= NIL
	oEncCab		:= Nil
	
	CursorArrow()
	
Return




User Function TINCRFSH()
	
	CursorWait()

	If PGH->PGH_STEXEC == "1" 
        U_TIAtuPGH(PGH->PGH_IDPROC, PGH->PGH_CODROT, .T.)  // ATUALIZA QUANDO ESTIVER EM SIMULAÇÃO 
    Else
        U_TIAtuPGH(PGH->PGH_IDPROC, PGH->PGH_CODROT, .F.)  // ATUALIZA QUANDO ESTIVER EM ATUALIZAÇÃO  
    EndIf 
	
	PGH->(DbSkip(0))
    If Type("oEncCab") == "O"
	    oEncCab:Refresh()
    EndIf 
	
	CursorArrow()
Return

User Function TPGHRFSH()

    Local cId     := PGG->PGG_IDPROC

    PGH->(DbSetOrder(1))
    PGH->(DbSeek(xFilial("PGH") + cId))
    While PGH->( !Eof() .and. PGH_FILIAL + PGH_IDPROC == xFilial("PGH") + cId)
        U_TINCRFSH()                
        PGH->(DbSkip())
    End 

Return

Static Function ValidMark
Local lRet := .T. 

If PGH->PGH_STEXEC == "3" .OR. PGH->PGH_STEXEC == "4"
    lRet := PGI->PGI_STEXEC == "4" .Or. PGI->PGI_STEXEC == "5"    
ElseIf PGH->PGH_STSIMU == "3" .OR. PGH->PGH_STSIMU == "4"
    lRet := PGI->PGI_STSIMU == "4" .Or. PGI->PGI_STSIMU == "5"
EndIf

Return lRet

Static Function MarkAll(cAlias, oBrowse)

MsgRun( "Aguarde... Marcando Registros", "Marcar Todos", {|| EMarkAll(cAlias, oBrowse) } )

Return

Static Function EMarkAll(cAlias, oBrowse)

Local nCurrRec := oBrowse:At()
Local aArea := GetArea()

oBrowse:GoTop(.T.)
DbSelectArea(cAlias)
DbGoTop()

While ! (cAlias)->(Eof())
    
    If PGH->PGH_STEXEC == "3" .OR. PGH->PGH_STEXEC == "4"
        If (PGI->PGI_STEXEC <> "4" .And. PGI->PGI_STEXEC <> "5")
            DbSkip()
            Loop
        EndIF
    ElseIf PGH->PGH_STSIMU == "3" .OR. PGH->PGH_STSIMU == "4"         
        If (PGI->PGI_STSIMU <> "4" .And. PGI->PGI_STSIMU <> "5")
            DbSkip()
            Loop
        EndIF
    EndIf

	oBrowse:MarkRec()

	DbSkip()
EndDo

oBrowse:GoTo( nCurrRec, .T. )
RestArea(aArea)

Return
