#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} 
Cadastro das incorporações a serem executadas
@author  	Wagner Mobile Costa
@version 	P12
@since   	18/11/2020
@Parametros:
/*/
//-----------------------------------------------------------------------------
User Function TINCA001()
	Local oBrowse
	Local aArea	:= GetArea()
    Local cPermissao:= GetMV("TI_INCA001",,"") 

    If ! Empty(cPermissao) .AND. ! (__cUserID $ cPermissao)
        MsgAlert("Usuario sem permissão para acessar a rotina!!!")
        Return 
    EndIf 
	
	DbSelectArea("PGG")

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('PGG')
	oBrowse:SetDescription("Incorporador")
    oBrowse:SetMainProc("TINCA001")
	oBrowse:DisableDetails()
	oBrowse:Activate()

	RestArea(aArea)

Return NIL


//-----------------------------------------------------------------------------
/*/ {Protheus.doc} 
			Define as operacoes da aplicacao
@author  	Wagner Mobile Costa
@version 	P12
@since   	18/11/2020
@Parametros:
/*/
//-----------------------------------------------------------------------------
Static Function MenuDef()
	Local aRotina := {}

    ADD OPTION aRotina TITLE "Pesquisar"	        ACTION "PesqBrw"             	OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE "Visualizar" 	        ACTION "VIEWDEF.TINCA001" 		OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir"    	        ACTION "VIEWDEF.TINCA001" 		OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar"    	        ACTION "VIEWDEF.TINCA001"		OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluir"    	        ACTION "VIEWDEF.TINCA001"		OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE "Carrega Registros"    ACTION "U_TINCLG"				OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Simulação MultiThread" ACTION "U_TINCEXE(.T.)"	    	OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Executar MultiThread"  ACTION "U_TINCEXE(.F.)"			OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Simulação MonoThread" ACTION "U_TINCEXE(.T.,'mono')"	OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Executar MonoThread"  ACTION "U_TINCEXE(.F.,'mono')"	OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Monitor Job" 	        ACTION "U_TIncMom()"			OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Config. Incorporador" ACTION "U_TInccfg()"			OPERATION 3 ACCESS 0
    

Return aRotina


//-----------------------------------------------------------------------------
/*/ {Protheus.doc} 
			Contem a Construcao e Definicao do Modelo          
@author  	Wagner Mobile Costa
@version 	P12
@since   	18/11/2020
@Parametros:
/*/
//-----------------------------------------------------------------------------
Static Function ModelDef()
	Local oStruPGG := FWFormStruct( 1, 'PGG' )
	Local oStruPGH := FWFormStruct( 1, 'PGH' )
	Local oModel   := MPFormModel():New('TINCM001',, { |oModel| TINCA01POS(oModel)})
    Local oCommit  := TINCA001EV():New()
	
	oModel:AddFields( 'PGGMASTER',, oStruPGG)
	oModel:SetDescription("Incorporador")
	oModel:SetPrimaryKey( {} )

	oModel:AddGrid('PGHDETAIL', 'PGGMASTER', oStruPGH,;
                { |oModelGrid, nLine ,cAction,cField| VldGrid(oModelGrid, nLine, cAction, cField) })

	oModel:GetModel('PGHDETAIL'):SetUniqueLine({"PGH_CODROT"})
	oModel:SetRelation('PGHDETAIL', { { 'PGH_FILIAL', 'xFilial("PGH")' },;
									  { 'PGH_IDPROC', 'PGG_IDPROC'  } },; 
		                              PGH->(IndexKey(1)) )
	    
    oModel:GetModel('PGGMASTER'):SetDescription("Incorporador")
	oModel:GetModel('PGHDETAIL'):SetDescription("Tabelas Migrar")
    oModel:InstallEvent("TINCA001EV", /*cOwner*/, oCommit)

Return oModel


//-----------------------------------------------------------------------------
/*/ {Protheus.doc} 
			Construcao da View
@author  	Wagner Mobile Costa
@version 	P12
@since   	18/11/2020
@Parametros:
/*/
//-----------------------------------------------------------------------------
Static Function ViewDef()

	Local oModel  := FWLoadModel("TINCA001")
    Local oStruPGG := FWFormStruct(2, 'PGG')
    Local oStruPGH := FWFormStruct(2, 'PGH')
	Local oView

    oStruPGH:RemoveField('PGH_IDPROC')
    oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField('VIEW_PGG', oStruPGG, 'PGGMASTER')

	oView:CreateHorizontalBox('SUPERIOR', 25)
	oView:CreateHorizontalBox('INFERIOR', 75)

	OView:SetOwnerView('VIEW_PGG', 'SUPERIOR')

	oView:AddGrid('VIEW_PGH', oStruPGH, 'PGHDETAIL')

	OView:SetOwnerView('VIEW_PGH', 'INFERIOR')
	OView:EnableTitleView('VIEW_PGH', 'Processos a Migrar')

	oView:SetViewCanActivate({|oView| VldView(oView)})
    
	oView:AddUserButton( 'Registros Incorporação', 'CLIPS', {|oView| U_TINCMON(oView)} )

Return oView

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Validacao

@author  	Wagner Mobile Costa
@version 	P12
@since   	25/01/2021
/*/
//-----------------------------------------------------------------------------
Static Function VldView(oView)

    Local oModel	:= oView:GetModel()
    Local nOpc	    := oModel:GetOperation()
    Local oMdlPHG	:= oModel:GetModel("PGHDETAIL")
    Local lSemEdit  := .F.

    // Não permite edição caso já iniciou a simulação/execução
    If nOpc <> MODEL_OPERATION_INSERT
        PGH->(DbSeek(xFilial("PGH") + PGG->PGG_IDPROC))
        While PGH->PGH_FILIAL == xFilial("PGH") .And. PGH->PGH_IDPROC == PGG->PGG_IDPROC .And.;
            ! PGH->(Eof())
            If PGH->PGH_STEXEC <> "1"
                lSemEdit := .T.
            EndIF
            PGH->(DbSkip())
        EndDo
    EndIf
    
    oMdlPHG:SetNoInsertLine(lSemEdit)
    oMdlPHG:SetNoUpdateLine(lSemEdit)
    oMdlPHG:SetNoDeleteLine(lSemEdit)

Return .T.

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Validacao ação do GRID

@author  	Wagner Mobile Costa
@version 	P12
@since   	25/01/2021
/*/
//-----------------------------------------------------------------------------
Static Function VldGrid(oModelGrid, nLine, cAction, cField)

Local lRet := .T.
Local cMsg := ""

If  (cAction == "DELETE" .Or. cAction == "CANSETVALUE") .And.;
    (oModelGrid:GetValue("PGH_QREG") > 0 .Or. oModelGrid:GetValue("PGH_STSIMU") <> "1" .Or.;
     oModelGrid:GetValue("PGH_STEXEC") <> "1")
    lRet := .F.
    If cAction == "DELETE"
        cMsg := "Carga de Registros já realizada"
        If oModelGrid:GetValue("PGH_STEXEC") <> "1"
            cMsg := "Execução já iniciada"
        ElseIf oModelGrid:GetValue("PGH_STSIMU") <> "1"
            cMsg := "Simulação já iniciada"
        EndIF
        cMsg := "Rotina: " + oModelGrid:GetValue("PGH_CODROT") + "-" + cMsg + " a exclusão não pode ser realizada !"
        Help(,, "Incorporador",, cMsg, 1, 0) 
    EndIf
EndIf

Return lRet

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Validacao

@author  	Wagner Mobile Costa
@version 	P12
@since   	18/11/2020
@return 	oModel
/*/
//-----------------------------------------------------------------------------
Static Function TINCA01POS(oModel)
	Local cError	 := ""
    Local nOperation := 0
    Local cGrpOri    := "" //ISSUE TIPDBP-1117
    Local cGrpDes    := "" //ISSUE TIPDBP-1117
    Local cFilOri    := ""
    Local cFilDes    := ""
    Local nPos       := 0
    Local oPGH
    Local oPGG
    Local cRet      := ""
    Local cID       := ""
    Local cIDDescr  := ""
    Local aApoio    :=  {}  //ISSUE TIPDBP-1117
    Local lGrpDif   :=  .F. //ISSUE TIPDBP-1117

	If oModel == Nil
		Return .F.
	EndIf

    aApoio := separa(U_ConcatZX5('_INCGR'),",")
    
	nOperation := oModel:GetOperation()

    oPGG := oModel:GetModel('PGGMASTER')

    cGrpOri    := oPGG:GetValue('PGG_GRPORI')
    cGrpDes    := oPGG:GetValue('PGG_GRPDES')
    lGrpDif    := cGrpOri <> cGrpDes
    cFilOri    := oPGG:GetValue('PGG_FILORI')
    cFilDes    := oPGG:GetValue('PGG_FILDES')
    cID        := oPGG:GetValue('PGG_IDPROC')
    cIDDescr   := oPGG:GetValue('PGG_DESCRI')

	If ! nOperation == MODEL_OPERATION_DELETE .and. cFilOri == cFilDes
        cError := "A filial de origem e destino não podem ser iguais!"
	EndIf
    
    oPGH := oModel:GetModel('PGHDETAIL')
    For nPos := 1 To oPGH:Length()
        oPGH:GoLine(nPos)
        If nOperation == MODEL_OPERATION_DELETE
            If oPGH:GetValue("PGH_STEXEC") <> "1"
                cError := "A rotina [" + oPGH:GetValue("PGH_CODROT") + "] já teve o status de execução iniciado. Processo não pode ser excluido !"
                Exit
            EndIF
        Else
            If ! FindFunction(oPGH:GetValue("PGH_FUNLOG"))
                cError := "A função [" + oPGH:GetValue("PGH_FUNLOG") + "] informada para rotina [" + oPGH:GetValue("PGH_CODROT") + "] não está compilada no repositorio !"
                Exit
            EndIF

            If ! FindFunction(oPGH:GetValue("PGH_FUNPRO"))
                cError := "A função [" + oPGH:GetValue("PGH_FUNPRO") + "] informada para rotina [" + oPGH:GetValue("PGH_CODROT") + "] não está compilada no repositorio !"
                Exit
            EndIF

            //ISSUE TIPDBP-1117
            If lGrpDif
                If len(aApoio) > 0
                    If Ascan(aApoio,{|x| Alltrim(upper(x)) == Alltrim(upper(oPGH:GetValue("PGH_FUNLOG"))) }) == 0
                        cError := "A função [" + oPGH:GetValue("PGH_FUNLOG") + "] informada para rotina [" + oPGH:GetValue("PGH_CODROT") + "] não está preparada para realizar a migração entre grupo de empresas !"
                        exit
                    EndIf 
                EndIf 
            EndIf 
        EndIf
    Next

    If ! Empty(cError)
        Help(,, "Incorporador",, cError, 1, 0) 
    Else
        cRet := SendToken(cID,__cUserID,cFilOri,cFilDes,cIDDescr) 
        If empty(cRet)   
            Help(,, "Incorporador",, "Problemas no envio de email com o Token.", 1, 0) 
        Endif
    EndIf

Return Empty(cError)


//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Execução da Transferencia

@author  	Wagner Mobile Costa
@version 	P12
@since   	19/11/2020
/*/
//-----------------------------------------------------------------------------

User Function TINCLG()
    Local lRet := .T.
    Private lAbortPrint := .F.

    If Select("QRY") > 0
        QRY->(DbCloseArea())
    EndIf

    BeginSQL Alias "QRY"
        SELECT PGG_IDPROC, PGG_DESCRI, PGH_CODROT, PGH_DESC,
               CASE WHEN PGH_STSIMU = '1' AND PGH_QREG > 0 THEN 'Carga Registros Realizada' 
                    WHEN PGH_STSIMU = '1' THEN 'Simulação Não Iniciada'
                    WHEN PGH_STSIMU = '2' THEN 'Simulação Em Execução' 
                    WHEN PGH_STSIMU = '4' THEN 'Simulação com Ocorrencias' ELSE ' ' End AS STSSIMU,
               CASE WHEN PGH_STEXEC = '1' THEN 'Execução Não Iniciada'
                    WHEN PGH_STEXEC = '2' THEN 'Execução Em Execução' ELSE ' ' End AS STSEXEC 
          FROM %table:PGG% PGG
          JOIN %table:PGH% PGH ON PGH_FILIAL = PGG_FILIAL AND PGH_IDPROC = PGG_IDPROC 
           AND ((PGH_STSIMU IN ('1', '2', '4') OR PGH_STEXEC IN ('1', '2')) AND PGH_QREG > 0) 
           AND PGH.%notDel%
         WHERE PGG_FILIAL = %exp:xFilial('PGG')% AND PGG_IDPROC <> %exp:PGG->PGG_IDPROC% 
           AND PGG_FILORI = %exp:PGG->PGG_FILORI% AND PGG.%notDel%
         ORDER BY PGG_IDPROC, PGH_CODROT
    EndSql

    If ! Empty(QRY->PGG_IDPROC)
        MsgAlert("Processo " + QRY->PGG_IDPROC + "/" + Alltrim(QRY->PGG_DESCRI) + " - Rotina: " +;
                               QRY->PGH_CODROT + "/" + Alltrim(QRY->PGH_DESC) + " - Status: " +;
                               Alltrim(QRY->STSSIMU) + If(Empty(QRY->STSSIMU), QRY->STSEXEC, "") +;
                               " deve ser finalizado para que o processo atual possa ser iniciado !" )
        lRet := .F.
    EndIf
    QRY->(DbCloseArea())
    If ! lRet
        Return .F.
    EndIf

    If ! MsgYesNO("Confirma a geração dos registros para Incorporação ?")
	    Return
    EndIf
    
    Processa({|| IncLog() },,,.T.)
    
    
Return 


Static Function IncLog()   
    Local cId     := PGG->PGG_IDPROC
    Local cRotLog := ""
    Local aPar    := {}
    Local cPar    := ""
    Local bBloco  := {|| .t. }
    Local cBloco  := ""
    Local np      := 0
    Local aPergunte := {}

    ProcRegua(1)

    PGH->(DbSetOrder(1))
    PGH->(DbSeek(xFilial("PGH") + cId))
    While PGH->( !Eof() .and. PGH_FILIAL + PGH_IDPROC == xFilial("PGH") + cId)
        cRotLog := Alltrim(PGH->PGH_FUNLOG)
        
        np:= At("(", cRotLog)
        If np > 0
            cRotLog := Left(cRotLog, np -1)
        EndIf 

        If Empty(cRotLog)
            PGH->(DbSkip())
            Loop 
        EndIf   

        PGI->(DbSetOrder(1))
        If PGI->(DbSeek(xFilial("PGI") + PGH->PGH_IDPROC + PGH->PGH_CODROT))
            PGH->(DbSkip())
            Loop 
        EndIf 
    
        // Verifica se a rotina tem perguntas e carrega
        If ! U_TIncLSX1("PGJ_PERGLD", @aPergunte)
            Return
        EndIF

        aPar := {PGH->PGH_IDPROC, PGH->PGH_CODROT, aPergunte}
        cPar := FwJsonSerialize(aPar)

        cBloco := "{ ||" + cRotLog + "('" + cPar + "')}"
        bBloco := &(cBloco)

        Processa( bBloco ,,, .T.)
        
        U_TINCRFSH()

        PGH->(DbSkip())
    End 
               

Return 

User Function TINCEXE(lSimula,cMono)
    
    Local aPergunte := LoadSX1(lSimula)
    Default cMono := ""
    Private lAbortPrint := .F.
    
    If aPergunte == Nil
        Return
    EndIf

    // Início da Rotina de verificação do Token

    If !lSimula // Já passou na simulação
        If !GetToken(PGG->PGG_IDPROC+__cUserID+PGG->PGG_FILORI+PGG->PGG_FILDES)
            MsgAlert("Resposta incorreta ou processo cancelado.")
            Return .F.
        Endif
    Endif

    IncStart(lSimula, aPergunte,cMono)

Return 

/*/{Protheus.doc} LoadSX1
    (long_description)
    @since 12/02/2021
    @version version
    @param lSimula, Logico, Indica se a execução será para simulação
/*/
Static Function LoadSX1(lSimula)

    Local cPGJ_PERG  := If(lSimula, "PGJ_PERGSM", "PGJ_PERGEX")
    Local aPergunte  := {}
    // Verifica se as rotinas tem grupo de perguntas vinculado [PGJ_PERGSM ou PGJ_PERGEX]
    // Rotinas
    PGJ->(DbSetOrder(1))

    // Rotinas do Processo
    PGH->(DbSetOrder(1))
    PGH->(DbSeek(xFilial("PGH") + PGG->PGG_IDPROC))
    While PGH->( !Eof() .and. PGH_FILIAL + PGH_IDPROC == xFilial("PGH") + PGG->PGG_IDPROC)

        If lSimula
            If PGH->PGH_STSIMU == "3" //concluido
                PGH->(DbSkip())
                Loop 
            EndIf  
        Else
            If PGH->PGH_STSIMU != "3"
               Exit 
            EndIf 
            If PGH->PGH_STEXEC == "3" //concluido
                PGH->(DbSkip())
                Loop 
            EndIf  
        EndIf

        // Verifica se a rotina tem perguntas e carrega
        If ! U_TIncLSX1(cPGJ_PERG, @aPergunte)
            Return
        EndIF

        PGH->(DbSkip())
    EndDo

Return aPergunte

/*
 Funcoes para uso em multithread
*/


User Function TIncMom()
    Local cTitulo := "Incorporador"
    Local cChave := "INCORPORADOR"
    Local cRotJob:= "U_TINCJOB"
    Local cRotThr:= "U_TINCTHR"
    Local cRotPar:= "U_TINCPAR"
    Local cRotErr:= "U_TINCERR" 
    Local cRotEnd:= "U_TINCEND" 
    Local nqThread := 10

    U_TGCVJMON(cTitulo, cChave, nqThread, cRotJob, cRotThr, cRotPar, cRotErr, cRotEnd )
    
Return 


User Function TINCPAR(cChave)
    Local aParamBox := {}
    Local aCombo    := {"Sim","Não"}
    Local aRet      := {}
    Local aRetPar   := {}
    Local cIdProc   := Space(6)
    Local cSimula   := ""
    Local aPergunte := {}
    
    PRIVATE lMsHelpAuto := .F.

    MV_PAR01 := ""
    MV_PAR02 := .T. 
    
    aAdd(aParamBox,{1,"ID processo" , cIdProc , "999999"    ,              ,  , , 50, .T.})
    aAdd(aParamBox,{2,"Simulação"   , "Sim" , aCombo , 50 ,"" ,.F.})
    
    If ! ParamBox(aParamBox, "Parametros - Monitor", @aRet) 
        Return {}
    EndIf

    cIdProc := MV_PAR01
    cSimula := mv_par02

    PGH->(DbSetOrder(1))
    If ! PGH->(DbSeek(xFilial("PGH") + cIdProc))
        MsgAlert("Processo incorporador com id " + cIdProc + " não encontrado!")
        Return {}
    EndIf 

    aPar := U_JLoadPar(cChave) 

    aPergunte := LoadSX1(Left(cSimula, 1) == "S")
    If aPergunte == Nil
        Return {}
    ElseIf Len(aPar) > 3 .And. Len(aPar[3]) > 0 .And. Len(aPergunte) = 0
        aPergunte := AClone(aPar[3])
    EndIf

    aRetPar := {cIdProc, cSimula, aPergunte }

Return aclone(aRetPar)

User Function TINCEND(cChave)
    Local aPar := {} 

    aPar := U_JLoadPar(cChave) 
    If len(aPar) == 0
        Return 
    EndIf 

    PGG->(DbSetOrder(1))
    PGG->(DbSeek(xFilial("PGG") + aPar[1]))
    U_TPGHRFSH()

Return 


Static Function IncStart(lSimula, aPergunte, cMono)
    Local nqThread  := 10
    Local cChave    := "INCORPORADOR"
    Local cChaveSrv := "SRV_" + cChave
    Local cRotJob   := "U_TINCJOB"
    Local cRotThr   := "U_TINCTHR"
    Local cRotErr   := "U_TINCERR"
    Local cRotEnd   := "U_TINCEND"
    Local aPar      := {}
    Local cIdProc   := PGG->PGG_IDPROC
	Default cMono   := ""

    Private lAbortPrint := .F.

    If ! U_JOnLine(cChave)
        U_JMsg(cChaveSrv, "Iniciando....") 
        
        aPar := {cIdProc, If(lSimula,"S","N"), aPergunte, cMono}
        
        U_JSavePar(cChave, aPar)     
        
        If ! U_JGetPar(cChave, nqThread, cRotJob, cRotThr, NIL, cRotErr, cRotEnd)
            Return
        EndIf 
    Else 
        MsgAlert("Job em execução...")
    EndIf         
    
    U_TIncRun()
   
    
    If lAbortPrint
        Return
    EndIf
    
Return




User Function TINCJOB(cChave, aRetPar)
    Local cChaveSrv := "SRV_" + cChave 
    Local cIDProc   := ""
    Local lSimula   := .F.
    Local aPergunte := {}
    Local lMonoTrd  := .F.
  
    If len(aRetPar) == 0
        Return 
    EndIf 

    cIdProc   := Left(aRetPar[1], 6)
    lSimula   := Left(aRetPar[2], 1) == "S"
    If Len(aRetPar) > 0
        aPergunte := AClone(aRetPar[3])
    EndIf

    If Len(aRetPar) >= 4 .And. lower(aRetPar[4])=="mono"
        lMonoTrd := .T.
    ENDIF   

    If lSimula
        FWMonitorMsg(cChaveSrv + " - Simulação ")
    Else
        FWMonitorMsg(cChaveSrv + " - Execução ")
    EndIf 

    // Processos
    PGG->(DbSetOrder(1))
    PGG->(DbSeek(xFilial("PGG") + cIdProc))

    // Rotinas do Processo
    PGH->(DbSetOrder(1))
    PGH->(DbSeek(xFilial("PGH") + cIdProc))

    While PGH->( !Eof() .and. PGH_FILIAL + PGH_IDPROC == xFilial("PGH") + cIdProc)

        If U_TGCVJEXIT(cChave)
            Return 
        EndIf

        If lSimula
            If PGH->PGH_STSIMU == "3" //concluido
                PGH->(DbSkip())
                Loop 
            EndIf  
        Else
            If PGH->PGH_STSIMU != "3"
               Exit 
            EndIf 
            If PGH->PGH_STEXEC == "3" //concluido
                PGH->(DbSkip())
                Loop 
            EndIf  
        EndIf 

        FWMonitorMsg(cChaveSrv + "ID " + PGH->PGH_IDPROC + " Rotina " +  PGH->PGH_CODROT + " " + Alltrim(PGH->PGH_DESC))
        If lSimula
            U_JSaveArq(cChaveSrv + ".log", "[SIMULACAO]")
        Else 
            U_JSaveArq(cChaveSrv + ".log", "[ATUALIZACAO]")
        EndIf 
        U_JSaveArq(cChaveSrv + ".log", "ID " + PGH->PGH_IDPROC + " Rotina " +  PGH->PGH_CODROT + " " + Alltrim(PGH->PGH_DESC) +" "+ Time())
        U_JMsg(cChaveSrv, "ID " + PGH->PGH_IDPROC + " Rotina " +  PGH->PGH_CODROT + " " + Alltrim(PGH->PGH_DESC))

        IF lMonoTrd
            RegToMemory("PGH",.F.)
            U_TINExSl(lMonoTrd, lSimula) //Roda em MonoThread
        Else
            ProcThrPGI(cChave, lSimula, aPergunte)
        EndIf
                
        PGH->(DbSkip())
    End 

Return

Static Function ProcThrPGI(cChave, lSimula, aPergunte)
    Local cRotLog   := Alltrim(PGH->PGH_FUNPRO)
    Local cIdProc   := PGH->PGH_IDPROC
    Local cCodRot   := PGH->PGH_CODROT
    Local cChavePGI := ""

    Local aPar      := {}
    Local cPar      := ""
    Local aParThr   := {}
    Local cParThr   := ""    
    Local aArea     := GetArea()
    Local aAreaPGI  := PGI->(GetArea())
    LOCAL cBloco    := ""
    Local np        := 0 

    Private lAbortPrint := .F.
    

    If ! lSimula
        If  PGH->PGH_STEXEC == "1"
            PGH->(RecLock("PGH", .F.))
            PGH->PGH_STEXEC := "2"
            PGH->(MsUnLock())
        EndIf 
    EndIf 

    np:= At("(", cRotLog)
    If np > 0
        cRotLog := Left(cRotLog, np -1)
    EndIf 

    ProcRegua(1)
    PGJ->(DbSetOrder(1))

    PGI->(DbSetOrder(1))
    PGI->(DbSeek(xFilial("PGI") + cIDProc + cCodRot))

    While  PGI->(! Eof() .and. PGI_FILIAL + PGI_IDPROC + PGI_CODROT == xFilial("PGI") + cIDProc + cCodRot )
        cChavePGI := Alltrim(PGI->PGI_CHAVE)
		cBloco    := ""

        If U_TGCVJEXIT(cChave)
            Return 
        EndIf

		If lAbortPrint
			exit
        EndIf 
        If lSimula
            If PGI->PGI_STSIMU == "3"  // concluido
                PGI->(DbSkip())
                Loop 
            EndIf
        Else 
            If PGI->PGI_STSIMU == "5" // ignorado na simulação
                PGI->(RecLock("PGI", .F.))
                PGI->PGI_STEXEC := "5"
                PGI->(MsUnLock())
                PGI->(DbSkip())
                Loop 
            EndIf
            If PGI->PGI_STEXEC == "3"  // concluido
                PGI->(DbSkip())
                Loop 
            EndIf
        EndIf 

        aPar := {cIdProc, cCodRot, cChavePGI, lSimula, aPergunte}
        cPar := FwJsonSerialize(aPar)
        
        cBloco := "{ ||" + cRotLog + "('" + cPar + "')}"
         

        aParThr := {cBloco}
        cParThr := FwJsonSerialize(aParThr)

        // distribui o conteudo do parametro para a proxima thread disponivel
        If ! U_TGCVJDIS(cChave, cParThr)
            // tenta novamente
			Sleep(100)
            Loop
        EndIf


        PGI->(DbSkip())
    End
    
    RestArea(aAreaPGI)
    RestArea(aArea)

Return 

static __nSeq := 0

User Function TINCTHR(cChaveTHR, cDir, cPar)
    Local cRetorno:= ""
    Local cBloco 
    Local bBloco 
    Local aPar := {}
    
    FWJsonDeserialize(cPar, @aPar)
    cBloco := aPar[1]
        
    bBloco := &(cBloco)
    
    cRetorno := "   Processando solicitação [" + Alltrim(Str(++__nSeq)) + "]  Geração " + Time() 
    FWMonitorMsg(cChaveTHR + cRetorno)
    cRetorno := Eval(bBloco)
 
Return cRetorno


User Function TINCERR(cChave, cPar, cErro)
    
    cErro += "interferindo na mensagem de erro" + CRLF

Return cErro



User Function TIncRun()
    Local cTitulo := "Incorporador"
    Local cChave := "INCORPORADOR"

    Local oPanel1
    Local oDlg                 
    Local lOk   := .F.    
    
    Local oTimer  

    Local oRodaPe 
    Local oFontB := TFont():New('Consolas',, 16,, .T.,,,,, .F., .F.)  
           
    Private lOnline := .F.

    lOnline:= U_JOnLine(cChave)
    
    
    DEFINE MSDIALOG oDlg TITLE "Processando Threads - " + cTitulo  FROM 0, 0 TO 380, 560 PIXEL OF oMainWnd

        oPanel1 :=TPanel():New( 010, 010, ,oDlg, , , , , , 14, 14, .F.,.T. )
        oPanel1 :align := CONTROL_ALIGN_TOP

        oBPS1  := THButton():New(002, 002, "Ocultar"   , oPanel1, {|| oDlg:End()   }, 50, 10, oFontB, "Fechar essa janela e permitir a execução do job") 
        oBPS2  := THButton():New(002, 052, "Finalizar" , oPanel1, {|| Finaliza(cChave)         }, 40, 10, oFontB, "Parar o serviço de execução do job") 
        oBPS3  := THButton():New(002, 092, "Monitor"   , oPanel1, {|| U_TIncMom()  }, 40, 10, oFontB, "Monitor threads") 

         
        oRodaPe:= TSimpleEditor():New( 0,0,oDlg, 40, 40 )
        oRodaPe:Align := CONTROL_ALIGN_ALLCLIENT
        
        DEFINE TIMER oTimer INTERVAL 1000 ACTION AtuTela2(oTimer, oDlg, cTitulo, cChave, oRodaPe ) OF oDlg

    ACTIVATE MSDIALOG oDlg ON INIT (AtuTela2(oTimer, oDlg,  cTitulo, cChave, oRodaPe), oTimer:Activate())  CENTERED
    
 
Return  lOk    

Static Function AtuTela2(oTimer, oDlg, cTitulo, cChave, oRodaPe)
    Local cChaveSrv := "SRV_" + cChave 
    
    If oTimer == NIL
        Return
    EndIf 
    
    oTimer:Deactivate()   
    lOnline:= U_JOnLine(cChave)
    
    cMsgSrv := U_JMsg(cChaveSrv)

    oRodaPe:Load(MontaHtml(cChaveSrv, cMsgSrv, lOnline))
    oRodaPe:Refresh()

    oDlg:cCaption := "Processamento Threads  - " + cTitulo + " - " + Time() +If(lOnline," - (On Line) ", " - (Off Line)")
  
    oTimer:Activate()

Return

Static Function Finaliza(cChave)
    If MsgYesNo("Confirma a desativação do serviço")
        U_JSaveArq("SRV_" + cChave + ".fim", "Fim") 
    Endif

Return 

Static Function MontaHtml(cChaveSrv, cMsgSrv, lOnline)
    Local aInfo := U_JSrvGetInfo(cChaveSrv)

    Local nTCapa   := aInfo[1]
    Local nLimite  := aInfo[2]
    Local nCount   := aInfo[3]
    Local nQtdGo   := aInfo[4]
    Local nQtdProc := aInfo[5]
    Local nQtdErro := aInfo[6]
    Local cIdProc  := Subs(cMsgSrv, 4, 6)
    Local aQtdes   := BuscQtd(cIdProc)

    Local nQtdDoc   :=  0
    Local nQtdIniS  :=  0
    Local nQtdConS  :=  0
    Local nQtdocoS  :=  0
    Local nQtdNProS :=  0
    Local nQtdIgnora:=  0
    Local nQtdIni   :=  0
    Local nQtdCon   :=  0
    Local nQtdOco   :=  0
    Local nQtdNPro  :=  0
    Local nPSimu    :=  0
    Local nPExec    :=  0



    nQtdDoc   := aQtdes[1]
    nQtdIniS  := aQtdes[2]
    nQtdConS  := aQtdes[3]
    nQtdOcoS  := aQtdes[4]
    nQtdNProS := aQtdes[5]
    nQtdIgnora:= aQtdes[6]
    nQtdIni   := aQtdes[7]
    nQtdCon   := aQtdes[8]
    nQtdOco   := aQtdes[9]
    nQtdNPro  := aQtdes[10]

    nPSimu := Int((nQtdConS + nQtdIgnora) / nQtdDoc * 100)
    nPExec := Int((nQtdCon  + nQtdIgnora) / nQtdDoc * 100)

    cHtml := ""
    cHtml += "<br>" + CRLF
    If lOnline
        cHtml += "<font COLOR='GREEN'><b>On Line</b></font>"
    Else 
        cHtml += "<font COLOR='RED'><b>OFF Line</b></font>"
    EndIf 

    cHtml += "<br>" + CRLF
    cHtml += "   <table width=100% border=0 cellspacing=0 cellpadding=2 bordercolor='666633'>" + CRLF
    cHtml += "      <tr><td width='150' align='LEFT'><b>Mensagem</b></td>                <td width='300' align='LEFT'> " + cMsgSrv  +"</td></tr>" + CRLF
    cHtml += "      <tr><td width='150' align='LEFT'><b>ID</b></td>                      <td width='100' align='LEFT'> " + cIDProc  +"</td></tr>" + CRLF
    cHtml += "      <tr><td width='150' align='LEFT'><b>Qtde documentos</b></td>         <td width='100' align='LEFT'> " + Alltrim(Transform(nQtdDoc    , "@e 99,999,999,999"))  +"</td></tr>" + CRLF
    cHtml += "      <tr><td width='150' align='LEFT'><b>Qtde ignorados </b></td>         <td width='100' align='LEFT'> " + Alltrim(Transform(nQtdIgnora , "@e 99,999,999,999"))  +"</td></tr>" + CRLF
    cHtml += "   </table>" + CRLF
    
    cHtml += "<br>" + CRLF
	
    cHtml += "   <table width=100% border=1 cellspacing=0 cellpadding=2 bordercolor='666633'>" + CRLF
    cHtml += "      <tr>" + CRLF
    cHtml += "      <td width='100' align='LEFT'> </td>" + CRLF
    cHtml += "      <td width='100' align='LEFT'><b>Concluidos     </b></td> " + CRLF
    cHtml += "      <td width='100' align='LEFT'><b>Ocorrencias    </b></td> " + CRLF
    cHtml += "      <td width='100' align='LEFT'><b>Não processados</b></td> " + CRLF
    cHtml += "      <td width='100' align='LEFT'><b>% Conclusão    </b></td> " + CRLF
    cHtml += "      </tr>" + CRLF
    cHtml += "      <tr>" + CRLF
    cHtml += "      <td width='100' align='LEFT'><b>Simulação      </b></td>"+ CRLF
    cHtml += "      <td width='100' align='LEFT'> " + Alltrim(Transform(nQtdConS  , "@e 99,999,999,999"))  +"</td>" + CRLF
    cHtml += "      <td width='100' align='LEFT'> " + Alltrim(Transform(nQtdOcoS  , "@e 99,999,999,999"))  +"</td>" + CRLF
    cHtml += "      <td width='100' align='LEFT'> " + Alltrim(Transform(nQtdNProS , "@e 99,999,999,999"))  +"</td>" + CRLF
    cHtml += "      <td width='100' align='LEFT'> " + Alltrim(Transform(nPSimu , "@e 999"))  +"</td>" + CRLF
    cHtml += "      </tr>" + CRLF
    cHtml += "      <tr>" + CRLF
    cHtml += "      <td width='100' align='LEFT'><b>Efetivação     </b></td>" + CRLF
    cHtml += "      <td width='100' align='LEFT'> " + Alltrim(Transform(nQtdCon  , "@e 99,999,999,999"))  +"</td>" + CRLF
    cHtml += "      <td width='100' align='LEFT'> " + Alltrim(Transform(nQtdOco  , "@e 99,999,999,999"))  +"</td>" + CRLF
    cHtml += "      <td width='100' align='LEFT'> " + Alltrim(Transform(nQtdNPro , "@e 99,999,999,999"))  +"</td>" + CRLF
    cHtml += "      <td width='100' align='LEFT'> " + Alltrim(Transform(nPExec   , "@e 999"))  +"</td>" + CRLF
    cHtml += "      </tr>" + CRLF
    cHtml += "   </table>" + CRLF
    cHtml += "<br>" + CRLF
    cHtml += "<br>" + CRLF

    cHtml += "<b>Job em Execução - Threads</b>" + CRLF
    cHtml += "   <table width=100% border=1 cellspacing=0 cellpadding=2 bordercolor='666633'>" + CRLF
    cHtml += "      <tr><td width='150' align='LEFT'><b>Capacidade</b></td>      <td width='150' align='LEFT'> " + Alltrim(Transform(nTCapa  , "@e 99,999,999,999"))  +"</td></tr>" + CRLF
    cHtml += "      <tr><td width='150' align='LEFT'><b>Disponibilidade</b></td> <td width='150' align='LEFT'> " + Alltrim(Transform(nLimite , "@e 99,999,999,999"))  +"</td></tr>" + CRLF
    cHtml += "      <tr><td width='150' align='LEFT'><b>Iniciadas</b></td>       <td width='150' align='LEFT'> " + Alltrim(Transform(nCount  , "@e 99,999,999,999"))  +"</td></tr>" + CRLF
    cHtml += "      <tr><td width='150' align='LEFT'><b>Distribuidos</b></td>    <td width='150' align='LEFT'> " + Alltrim(Transform(nQtdGo  , "@e 99,999,999,999"))  +"</td></tr>" + CRLF
    cHtml += "      <tr><td width='150' align='LEFT'><b>Processados</b></td>     <td width='150' align='LEFT'> " + Alltrim(Transform(nQtdProc, "@e 99,999,999,999"))  +"</td></tr>" + CRLF
    cHtml += "      <tr><td width='150' align='LEFT'><b>Erros</b></td>           <td width='150' align='LEFT'> " + Alltrim(Transform(nQtdErro, "@e 99,999,999,999"))  +"</td></tr>" + CRLF
    cHtml += "   </table>" + CRLF

Return cHtml 


Static Function BuscQtd(cIdProc)
    Local clAlias := GetNextAlias()
	Local cQuery := ""	
    Local aArea  := GetArea()
    Local aQtdes := {}    
    cQuery := MontaQry(cIDProc) 
    
    dbUseArea( .T., __cRdd, TcGenQry( ,, cQuery ), clAlias, .T., .F. )
    If (clAlias)->(Eof())
        (clAlias)->(dbCloseArea())
        RestArea(aArea)
        Return {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
    EndIf 

    aadd(aQtdes, (clAlias)->QREG    )    
    aadd(aQtdes, (clAlias)->QINI_S  )    
    aadd(aQtdes, (clAlias)->QCONC_S )    
    aadd(aQtdes, (clAlias)->QERRO_S )    
    aadd(aQtdes, (clAlias)->QNPROC_S)    
    aadd(aQtdes, (clAlias)->QIGNORA )    
    aadd(aQtdes, (clAlias)->QINI    )    
    aadd(aQtdes, (clAlias)->QCONC   )    
    aadd(aQtdes, (clAlias)->QERRO   )    
    aadd(aQtdes, (clAlias)->QNPROC  )    
   
    (clAlias)->(dbCloseArea())
    RestArea(aArea)
Return aQtdes



Static Function MontaQry(cIDProc) 
    Local cQuery := ""

    cQuery := " "
    cQuery += " SELECT  " 
    cQuery += "         (SELECT COUNT(1)        FROM " + RetSQLName("PGI") + " A WHERE  A.PGI_FILIAL = '" + FWxFilial("PGI") + "' AND A.PGI_IDPROC = '" + cIDProc + "'                         AND A.D_E_L_E_T_ = ' ' )  AS QREG    ,  " 
    cQuery += "         (SELECT COUNT(1)        FROM " + RetSQLName("PGI") + " A WHERE  A.PGI_FILIAL = '" + FWxFilial("PGI") + "' AND A.PGI_IDPROC = '" + cIDProc + "' AND A.PGI_STSIMU =  '2' AND A.D_E_L_E_T_ = ' ' )  AS QINI_S  ,  " 
    cQuery += "         (SELECT COUNT(1)        FROM " + RetSQLName("PGI") + " A WHERE  A.PGI_FILIAL = '" + FWxFilial("PGI") + "' AND A.PGI_IDPROC = '" + cIDProc + "' AND A.PGI_STSIMU =  '3' AND A.D_E_L_E_T_ = ' ' )  AS QCONC_S ,  " 
    cQuery += "         (SELECT COUNT(1)        FROM " + RetSQLName("PGI") + " A WHERE  A.PGI_FILIAL = '" + FWxFilial("PGI") + "' AND A.PGI_IDPROC = '" + cIDProc + "' AND A.PGI_STSIMU =  '4' AND A.D_E_L_E_T_ = ' ' )  AS QERRO_S ,  " 
    cQuery += "         (SELECT COUNT(1)        FROM " + RetSQLName("PGI") + " A WHERE  A.PGI_FILIAL = '" + FWxFilial("PGI") + "' AND A.PGI_IDPROC = '" + cIDProc + "' AND A.PGI_STSIMU =  '1' AND A.D_E_L_E_T_ = ' ' )  AS QNPROC_S,  " 
    cQuery += "         (SELECT COUNT(1)        FROM " + RetSQLName("PGI") + " A WHERE  A.PGI_FILIAL = '" + FWxFilial("PGI") + "' AND A.PGI_IDPROC = '" + cIDProc + "' AND A.PGI_STSIMU =  '5' AND A.D_E_L_E_T_ = ' ' )  AS QIGNORA ,  "     
    cQuery += "         (SELECT COUNT(1)        FROM " + RetSQLName("PGI") + " A WHERE  A.PGI_FILIAL = '" + FWxFilial("PGI") + "' AND A.PGI_IDPROC = '" + cIDProc + "' AND A.PGI_STEXEC =  '2' AND A.D_E_L_E_T_ = ' ' )  AS QINI    ,  " 
    cQuery += "         (SELECT COUNT(1)        FROM " + RetSQLName("PGI") + " A WHERE  A.PGI_FILIAL = '" + FWxFilial("PGI") + "' AND A.PGI_IDPROC = '" + cIDProc + "' AND A.PGI_STEXEC =  '3' AND A.D_E_L_E_T_ = ' ' )  AS QCONC   ,  " 
    cQuery += "         (SELECT COUNT(1)        FROM " + RetSQLName("PGI") + " A WHERE  A.PGI_FILIAL = '" + FWxFilial("PGI") + "' AND A.PGI_IDPROC = '" + cIDProc + "' AND A.PGI_STEXEC =  '4' AND A.D_E_L_E_T_ = ' ' )  AS QERRO   ,  " 
    cQuery += "         (SELECT COUNT(1)        FROM " + RetSQLName("PGI") + " A WHERE  A.PGI_FILIAL = '" + FWxFilial("PGI") + "' AND A.PGI_IDPROC = '" + cIDProc + "' AND A.PGI_STEXEC =  '1' AND A.D_E_L_E_T_ = ' ' )  AS QNPROC     " 
    cQuery += " FROM   " + RetSQLName("PGI") + " PGI   " 
    cQuery += " WHERE  PGI_FILIAL = '" + FWxFilial("PGI") + "' AND PGI_IDPROC = '" + cIDProc + "' AND PGI.D_E_L_E_T_ = ' '  " 

Return cQuery

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Validacao permissão acesso campo

@author Wagner Mobile
@version P12
@since   25/01/2021
@return  lRet
/*/
//-----------------------------------------------------------------------------
User Function TINCA01W()

    Local lRet        := .F.
    Local aArea       := GetArea()
    Local cPGH_CODROT := FWFLDGET("PGH_CODROT")

    DbSelectArea("PGJ")
    DbSetOrder(1)
    If DbSeek(xFilial() + cPGH_CODROT) .And. PGJ->PGJ_EDIT == "1"
        lRet := .T.
    EndIF

    RestArea(aArea)

Return lRet

/*/{Protheus.doc} TINCA001EV
    (long_description)
    @since 10/02/2021
    @version version
/*/
Class TINCA001EV FROM FWModelEvent
    Method New() CONSTRUCTOR
    Method AfterTTS()

ENDCLASS

/*/{Protheus.doc} New
    (long_description)
    @since 10/02/2021
    @version version
/*/
Method New() Class TINCA001EV

Return


/*/{Protheus.doc} AfterTTS
    (long_description)
    @since 10/02/2021
    @version version
    @param oModel, objeto, Objeto Model
    @param cModelId, objeto, Id do submodelo
/*/
Method AfterTTS(oModel, cModelId) Class TINCA001EV

Local cPGG_IDPROC := PGG->PGG_IDPROC

    If oModel:GetOperation() == MODEL_OPERATION_DELETE
        TCSQLEXEC("DELETE FROM " + RetSQlName("PGI") + " WHERE PGI_FILIAL = '" + xFilial("PGI") + "' " +;
                     "AND PGI_IDPROC = '" + cPGG_IDPROC + "'")
    EndIF

Return

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} 
			Cria e envia Token de segurança para o email do usuário logado
@author  	Julio Saraiva
@version 	P12
@since   	09/11/2021
@Parametros:
/*/
//-----------------------------------------------------------------------------
Static Function SendToken(cId,cUser,cFILORI,cFILDES,cDesc)
Local cRet      := ""
Local cAux      := ""
Local aUser := FWSFALLUSERS({cUser})
Local cEmailInc := Alltrim(aUser[1,5]) //Alltrim(PswRet()[1,14])
Local cUsrInc2  := Alltrim(aUser[1,4]) //Alltrim(PswRet()[1,4])
Local cAssunto  := "Token Incorporador | Id Processamento: " + cID + " | " + cDesc
Local cNmFilOri := " ["+AllTrim(GetAdvFVal( "SM0", "M0_FILIAL" , cEmpAnt + cFILORI, 1, "" ))+"]"
Local cNmFilDes := " ["+AllTrim(GetAdvFVal( "SM0", "M0_FILIAL" , cEmpAnt + cFILDES, 1, "" ))+"]"

Local cPathHTML := GetMV("MV_WFDIR")
Local cFileName := ""
Local cArqHTML  := "\workflow\TINCA001.html"
Local oHtml
Local cTexto    := ""

If ! File(cArqHtml)
    If ! Isblind()
	    MsgInfo("Arquivo [" + cArqHTML + "] não encontrado !")
    EndIf 
	//RestArea(aArea)
	Return
EndIf

oHtml := TWFHtml():New( cArqHTML )

cAux    := Encode64(cId+cUser+cFILORI+cFILDES)

If !Empty(cAux)
    MsgAlert("Enviando email para: "+ cEmailInc +" com o token.")
Endif

oHTML:ValByName("CUSRINC2"	,cUsrInc2)   // variáveis utilizadas no html
oHTML:ValByName("CID"	    ,cID)
oHTML:ValByName("CDESC"	    ,cDesc)
oHTML:ValByName("CFILORI"	,cFILORI)
oHTML:ValByName("CNMFILORI"	,cNmFilOri)
oHTML:ValByName("CFILDES"	,cFILDES)
oHTML:ValByName("CNMFILDES"	,cNmFilDes)
oHTML:ValByName("CAUX"	    ,cAux)

cFileName := CriaTrab(NIL,.F.) + ".htm"
cFileName := cPathHTML + "\" + cFileName 
oHtml:SaveFile(cFileName)
cRet      := WFLoadFile(cFileName)
ctexto    := StrTran(cRet,chr(13),"")
ctexto    := StrTran(cRet,chr(10),"")
cTexto    := OemtoAnsi(cTexto)

u_xSendMail(cEmailInc,cAssunto,cTexto)

Return cAux

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} 
			Validação do Token de segurança 
@author  	Julio Saraiva
@version 	P12
@since   	09/11/2021
@Parametros:
/*/
//-----------------------------------------------------------------------------
Static Function GetToken(cToken)
Local lRet := .F.
Local cResp  := Space(100)
//Local cCodigo:= ""

Local oDlg 
Local oPesq 
Local oOk
Local oCancel

Local lPesq := .F.

//cCodigo := encode64(cToken)

DEFINE MSDIALOG oDlg TITLE "Informe o Token... "   FROM 0, 0 TO 100, 300 OF GetWndDefault() STYLE DS_MODALFRAME STATUS  PIXEL

    DEFINE SBUTTON oOk     FROM 030, 50 TYPE 01 OF oDlg ENABLE ACTION ( lPesq := .T. , oDlg:End() )
    DEFINE SBUTTON oCancel FROM 030, 80 TYPE 02 OF oDlg ENABLE ACTION ( oDlg:End() )
    @ 10,10  MSGET oPesq VAR cResp	SIZE 130,010 OF oDlg PIXEL  

ACTIVATE MSDIALOG oDlg CENTERED //ON INIT EnchoiceBar( oDlg , bSet15 , bSet24 )

IF DECODE64(ALLTRIM(cResp)) == cToken .AND. lPesq
    lRet := .T.
EndIF

Return lRet
