#INCLUDE "PROTHEUS.CH"  
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH" //tbiconn.ch

/*/{Protheus.doc} ZZATUPAR
	@author: Geanlucas Rodrigues de Sousa 
	@since: 06/05/2025
	@version: 1.0
	@description: Fun��o que atualiza parametros conforme selecionado  
/*/
User Function TINCWHAP()   

	Local aArea			:= FwGetArea()
	Local oDlg      	:= NIL
    Local oPanelBkg

	Private cAlias 		:= GetNextAlias()
	Private cAliasTab	:= GetNextAlias()
	Private cMarca		:= NIL

	Private oFont1
    Private oFontCabec
    Private oBrwTrb
	Private oStepWiz 	:= NIL
	
	/* Define o tipo e tamanho da fonte */
    Define Font oFont1     Name "Verdana" Size 9,18
    Define Font oFontCabec Name "Verdana" Bold Size 7,18 
     
    /* Tela Inicial do Wizard */
    DEFINE DIALOG oDlg TITLE 'Atualiza��o de Parametros' PIXEL STYLE nOR(  WS_VISIBLE ,  WS_POPUP )

	If Empty(FunName())
		RpcSetType(3)
		RPCSetEnv("00","00001000100")
	EndIf
 
    /* Define tamanho da Dialog que comportar� o Wizard */
    oDlg:nWidth  := 1100
    oDlg:nHeight := 620
     
    /* Define o tamanho do painel do Wizard */
    oPanelBkg:= tPanel():New(0,0,"",oDlg,,,,,,300,300)
    oPanelBkg:Align := CONTROL_ALIGN_ALLCLIENT
 
    /* Instancia a classe FWWizard */
	TelaWizard(oStepWiz, oDlg, oPanelBkg) 

	RestArea(aArea)  
Return

/*/{Protheus.doc} TelaWizard
	@author: Geanlucas Rodrigues de Sousa 
	@since: 06/05/2025
	@version: 1.0
	@description: Fun��o que atualiza parametros conforme selecionado  
/*/
Static Function TelaWizard(oStepWiz, oDlg, oPanelBkg)
 
    Local oNewPag
	Private aParametros := {}
	Private cFilterFil	:= Space(30)
	Private cFilterPar	:= Space(300)

    oStepWiz:= FWWizardControl():New(oPanelBkg)
    oStepWiz:ActiveUISteps()
 
    //*************************************//
    // 1 - Pagina de Sele��o de Parametros //
    //*************************************//
    /* Define a p�gina 1 com a fun��o de montagem dos objetos */
    oNewPag := oStepWiz:AddStep("1")
 
    /* Altera a descri��o do step */
    oNewPag:SetStepDescription("Filtros")
 
    /* Define o bloco de constru��o */
    oNewPag:SetConstruction({|Panel|fCriaStep1(Panel,@cFilterFil,@cFilterPar)})

	/* Define o bloco ao clicar no bot�o Pr�ximo */
	//oNewPag:SetNextAction({|| fValid()})
      
    /* Define o bloco ao clicar no bot�o Cancelar */
    oNewPag:SetCancelAction({|| .T., oDlg:End()})

	//*************************************//
    // 2 - Pagina de Sele��o de Parametros //
    //*************************************//
    /* Define a p�gina 2 com a fun��o de montagem dos objetos */
    oNewPag := oStepWiz:AddStep("2")
 
    /* Altera a descri��o do step */
    oNewPag:SetStepDescription("Sele��o de Par�metros")
 
    /* Define o bloco de constru��o */
    oNewPag:SetConstruction({|Panel|PagSelPars(Panel)})
 
    /* Define o bloco ao clicar no bot�o Pr�ximo */
    oNewPag:SetNextAction({|| GetMarkPar()})
     
    /* Define o bloco ao clicar no bot�o Cancelar */
    oNewPag:SetCancelAction({|| .T., oDlg:End()})
 
    //************************************//
    // 3 - Pagina de Altera��o Parametros //
    //************************************//
    /* Define a p�gina 3 com a fun��o de montagem dos objetos */
    oNewPag := oStepWiz:AddStep("3")
     
    /* Altera a descri��o do step */
    oNewPag:SetStepDescription("Altera��o de Parametros")

	/* Define o bloco de constru��o */
    oNewPag:SetConstruction({|Panel|fAtuPars(Panel, aParametros)})
     
    /* Define o bloco ao clicar no bot�o Pr�ximo */
    oNewPag:SetNextAction({|| fPutPar(), oDlg:End()})

    /* Define o bloco ao clicar no bot�o Cancelar */
    oNewPag:SetCancelAction({|| .T., oDlg:End()})
  
    /* Define o t�tulo da tela anterior */
    oNewPag:SetPrevTitle(" Voltar ") 
     
    /* Define se permite cancelar */
    oNewPag:SetCancelWhen({||.T.})
     
    /* Ativa o Wizard */
    oStepWiz:Activate()
	
    ACTIVATE DIALOG oDlg CENTER
     
    /* Destr�i o objeto no fechamento total do Wizard */
    oStepWiz:Destroy()

Return

/*/{Protheus.doc} fCriaStep1
	@type  Static Function
	@author Geanlucas Sousa
	@since 06/05/2025
	@description: Fun��o para filtrar a Filial e os Parametros.
/*/

Static Function fCriaStep1(oPanel,cFilterFil,cFilterPar)
	
	Local cInsert1		:= 'Insira a Filial:'
	Local cInsert2		:= 'Insira o Parametro:'
	Private oTGet2,oSay2
	Private oTGet1,oSay1

    Define Font oFontSay Name "Verdana" Bold Size 10,18 
    Define Font oFontGet Name "Verdana" Size 9,18 

	oSay1:= TSay():New(10,10,{||cInsert1},oPanel,,oFontSay,,,,.T.,,,200,20)
	oTGet1 := TGet():New( 10,90,{|u| if( PCount() > 0, cFilterFil := u, cFilterFil ) },oPanel,200,012,"@!",,0,,oFontGet,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cFilterFil,,,, )
	oTGet1:cPlaceHold := "Ex.: 0101000100"
	
	oSay2:= TSay():New(30,10,{||cInsert2},oPanel,,oFontSay,,,,.T.,,,200,20)
	oTGet2 := TGet():New( 30,90,{|u| if( PCount() > 0, cFilterPar := u, cFilterPar ) },oPanel,200,012,"@!",,0,,oFontGet,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cFilterPar,,,, )
	oTGet2:cPlaceHold := "Ex.: MV_TIAAAAA/MV_TIBBBB/MV_TICCCC"

Return

 
/*/{Protheus.doc} PagSelPars
	@type  Static Function
	@author Geanlucas Sousa
	@since 06/05/2025
	@description: Fun��o para definir o bloco de constru��o do Step Sele��o de Parametros.
/*/
Static Function PagSelPars(oPanel)

	Local aPars		:= {}
	Local cTipo		:= ""

	cTipo := "Parametros"
	aPars := TableTemp(cTipo, oPanel)

Return aPars

/*/{Protheus.doc} TableTemp
	@type  Static Function
	@author Geanlucas Sousa
	@since 06/05/2025
	@version version
	@description: Fun��o para Criar Tabela Tempor�ria
/*/
Static Function TableTemp(cTipo, oPanel)

	Local aFields 		:= {}
	Local aParametros	:= {}
	Local aPar			:= {}
	Local nTotal		:= 0
	Local nX			:= 0
	Public oTempTable

	aParametros := GetPars()
	nTotal		:= len(aParametros)

	//Se o alias estiver aberto, fechar para evitar erros com alias aberto
    If (Select(cAlias) <> 0)
        dbSelectArea(cAlias)
        (cAlias)->(dbCloseArea())
    EndIf

	//Cria��o do objeto
	oTempTable := FWTemporaryTable():New( cAlias )

	//Monta os campos da tabela
	aAdd(aFields,{"TR_OK"  		,"C",001,0}) // Este campo ser� usado para marcar/desmarcar
  	aAdd(aFields,{"TR_FIL" 		,"C",011,0}) // Nome Campo Temporario, Tipo do Campo, Tamanho do Campo, Decimal.
	aAdd(aFields,{"TR_PAR"		,"C",015,0}) // Nome Campo Temporario, Tipo do Campo, Tamanho do Campo, Decimal.
  	aAdd(aFields,{"TR_TIPO" 	,"C",001,0}) // Nome Campo Temporario, Tipo do Campo, Tamanho do Campo, Decimal.
	aAdd(aFields,{"TR_DESCRI"	,"C",150,0}) // Nome Campo Temporario, Tipo do Campo, Tamanho do Campo, Decimal.
	aAdd(aFields,{"TR_CONTEUD"	,"C",150,0}) // Nome Campo Temporario, Tipo do Campo, Tamanho do Campo, Decimal.

	oTemptable:SetFields( aFields )
	oTempTable:AddIndex("1", {"TR_FIL"},{"TR_PAR"} )
	oTempTable:AddIndex("2", {"TR_PAR"} )

	//Cria��o da tabela
	oTempTable:Create()

	// Popular Tabela Tempor�ria
	If nTotal > 0
		For nX := 1 To nTotal
			If RecLock(cAlias,.T.)
				(cAlias)->TR_OK  	 := ""
				(cAlias)->TR_FIL 	 := AllTrim(aParametros[nX][1])
				(cAlias)->TR_PAR	 := AllTrim(aParametros[nX][2])
				(cAlias)->TR_TIPO 	 := AllTrim(aParametros[nX][3])
				(cAlias)->TR_DESCRI	 := AllTrim(aParametros[nX][4])
				(cAlias)->TR_CONTEUD := AllTrim(aParametros[nX][5])
				MsUnLock()
			Endif
		Next nX
	EndIf

	If (cAlias)->(!Eof())
		aPar := CriaMarkBrowse(cTipo, oPanel)
	EndIf

Return aPar

/*/{Protheus.doc} GetPars
	@type  Static Function
	@author Geanlucas Sousa
	@since 06/05/2025
	@description: Busca Parametros do conforme Grupo de Usuarios
/*/
Static Function GetPars()

	Local aArea	    	:= FwGetArea()
	Local cNewAls		:= GetNextAlias()
	Local aParametros 	:= {}
	Local cQuery		:= ""
	Local cSX6			:= "SX6"+cEmpAnt+"0"

	If !Empty(cFilterPar)
		If '/' $(cFilterPar)
			cFilterPar := FormatIn(cParam, '/')
		ElseIf ';' $(cFilterPar)
			cFilterPar := FormatIn(cParam, ';')
		ElseIf ',' $(cFilterPar)
			cFilterPar := FormatIn(cParam, ',')
		ElseIf '|' $(cFilterPar)
			cFilterPar := FormatIn(cParam, '|')
		EndIf
	EndIf

	cQuery := " SELECT X6_FIL AS CCPOFX,X6_VAR AS CPOXPM, X6_TIPO AS CPOTP, "+CRLF
	cQuery += " 	X6_DESCRIC||' '||X6_DESC1||' '||X6_DESC2 AS CDSCMG, "+CRLF
	cQuery += " 	X6_CONTEUD AS CCNTPR "+CRLF		
	cQuery += " FROM "+cSX6+" SX6 "+CRLF				
	cQuery += " WHERE SX6.D_E_L_E_T_ = ' ' "+CRLF

	If !Empty(cFilterFil)
		cQuery += " 	AND X6_FIL = '"+cFilterFil+"' "+CRLF
	EndIf

	If !Empty(cFilterPar)
		cQuery += " 	AND X6_VAR IN "+ cFilterPar +CRLF
	EndIf

	cQuery += " ORDER BY X6_VAR "+CRLF
	
	TcQuery cQuery New Alias &cNewAls

	If !(cNewAls)->(EOF())
		DbSelectArea(cNewAls)
		DbGoTop()
		Do While !EOF()
			aAdd(aParametros,{(cNewAls)->CCPOFX, (cNewAls)->CPOXPM, (cNewAls)->CPOTP, (cNewAls)->CDSCMG, (cNewAls)->CCNTPR})
			(cNewAls)->(DbSkip())
		EndDo
	EndIf

	(cNewAls)->(DbCloseArea())

	RestArea(aArea)

Return aParametros

/*/{Protheus.doc} CriaMarkBrows
	@type  Static Function
	@author Geanlucas Sousa
	@since 06/05/2025
	@description: Cria a Tela de marca��o dos Parametros
/*/
Static Function CriaMarkBrowse(cTipo, oPanel)

	Local aPar		:= {}
	Local aSeek 	:= {}
	Private cTitulo := "Selecione o(s) parametro(s)"
	Public oBrowse 	:= NIL
	
    aAdd(aSeek, { "Parametro" 	,{{"","C",015,0,"Parametro"	,""}} })
	aAdd(aSeek, { "Filial"  	,{{"","C",011,0,"Filial"	,""}} })
	
	oBrowse := FWMarkBrowse():New()
	oBrowse:SetDescription(cTitulo) //Titulo da Janela
	oBrowse:SetAlias(cAlias) //Indica o alias da tabela que ser� utilizada no Browse
	oBrowse:SetFieldMark("TR_OK") //Indica o campo que dever� ser atualizado com a marca no registro
	//oBrowse:SetMark("TB",cAlias,"TR_OK") // Define a Marca que vai ser adicionado no TR_OK
	oBrowse:oBrowse:SetDBFFilter(.T.)
	oBrowse:oBrowse:SetUseFilter(.T.) //Habilita a utiliza��o do filtro no Browse
	oBrowse:oBrowse:SetFixedBrowse(.T.)
	oBrowse:SetWalkThru(.F.) //Habilita a utiliza��o da funcionalidade Walk-Thru no Browse
	oBrowse:SetAmbiente(.T.) //Habilita a utiliza��o da funcionalidade Ambiente no Browse
	oBrowse:SetTemporary() //Indica que o Browse uttiliza tabela tempor�ria
	oBrowse:oBrowse:SetSeek(.T.,aSeek) //Habilita a utiliza��o da pesquisa de registros no Browse
	oBrowse:oBrowse:SetFilterDefault("") //Indica o filtro padr�o do Browse
	oBrowse:ForceQuitButton(.T.)
	oBrowse:SetIgnoreARotina(.T.) // Ignora o Menu Padr�o do Browse.
	oBrowse:DisableReport() // Desabilita Op��o de Imprimir o Browse;
	//oBrowse:DisableFilter() // Desabilita o Filtro.
	oBrowse:DisableConfig() // Desabilita a Configura��o do Browse.
	//oBrowse:DisableSeek() // Desabilita a Pesquisa no Browse.
	oBrowse:DisableDetails() 
	oBrowse:SetMenuDef("")
	
	// Cria as Colunas no Browse
	CriaColuna(oBrowse)
	
	//Indica o Code-Block executado no clique do header da coluna de marca/desmarca
	oBrowse:bAllMark := { || MDRegistro(oBrowse:Mark()), oBrowse:Refresh(.T.)  }
	
	//Quando Clicar no bot�o fechar do browse Atribui .T. para a vari�vel lCancel.
	oBrowse:oBrowse:bBeforeClose := {|| lCancel := .T. }

	//M�todo de ativa��o da classe
	oBrowse:Activate(oPanel)
	oBrowse:oBrowse:Setfocus() //Seta o foco na grade

Return aPar

/*/{Protheus.doc} MDRegistro
	@type  Static Function
	@author Geanlucas Sousa
	@since 06/05/2025
	@description: Fun��o para marcar/desmarcar todos os registros do grid
/*/
Static Function MDRegistro(cMarca)

    Local cAliasTRB := cAlias
    Local aAreaTRB  := (cAliasTRB)->( GetArea() )

	If (cAliasTRB)->TR_OK == "  "
		dbSelectArea(cAliasTRB)
		(cAliasTRB)->( dbGoTop() )
		While !(cAliasTRB)->( Eof() )
			RecLock( (cAliasTRB), .F. )
			(cAliasTRB)->TR_OK := cMarca
			MsUnlock()
			(cAliasTRB)->( dbSkip() )
		EndDo
	Else
		dbSelectArea(cAliasTRB)
		(cAliasTRB)->( dbGoTop() )
		While !(cAliasTRB)->( Eof() )
			RecLock( (cAliasTRB), .F. )
			(cAliasTRB)->TR_OK := "  "
			MsUnlock()
			(cAliasTRB)->( dbSkip() )
		EndDo
	EndIf
	
    RestArea( aAreaTRB )
Return .T.

/*/{Protheus.doc} GetMarkPar
	@type  Static Function
	@author Geanlucas Sousa
	@since 06/05/2025
	@description: Cria segunda tabela com os parametros marcados 
/*/
Static Function GetMarkPar()

	Local aArea	:= GetArea()
	Local lRet	:= .F.
	
	cMarca	:= oBrowse:Mark()

	(cAlias)->(DbGoTop())
	Do While !(cAlias)->(EOF())
		If oBrowse:IsMark(cMarca)
			aAdd(aParametros,{(cAlias)->TR_FIL, (cAlias)->TR_PAR, (cAlias)->TR_TIPO, (cAlias)->TR_DESCRI, (cAlias)->TR_CONTEUD})
			lRet := .T.
		EndIf
		(cAlias)->(DbSkip())
	EndDo

	If !lRet
		MsgAlert("Nenhum Parametros foi selecionado !", "Aten��o!")
	EndIf

	RestArea(aArea)
 
Return (lRet)
 
/*/{Protheus.doc} fAtuPars
	@type  Static Function
	@author Geanlucas Sousa
	@since 06/05/2025
	@description: Monta grid de atualiza��o dos parametros
/*/
Static Function fAtuPars(oPanel, aParametros)

	Local aArea := GetArea()
	
	oBrwTrb := FWBrowse():New()
	oBrwTrb:SetOwner(oPanel)
	oBrwTrb:SetDataArray()
	oBrwTrb:SetArray(aParametros)

	// Definicao das colunas
	oBrwTrb:addColumn({"Filial"		, {|| aParametros[oBrwTrb:nAt, 1]}, "C", "@!"	, 1, 011,, .F. ,				, .F.,, "FILIAL"	,, .F., .T.,, "FILIAL" 		})
	oBrwTrb:addColumn({"Parametro"	, {|| aParametros[oBrwTrb:nAt, 2]}, "C", "@!"	, 1, 015,, .F. ,				, .F.,, "PARAMETRO"	,, .F., .T.,, "PARAMETRO" 	})
	oBrwTrb:addColumn({"Tipo"		, {|| aParametros[oBrwTrb:nAt, 3]}, "C", "@!"	, 1, 001,, .F. ,				, .F.,, "TIPO"		,, .F., .T.,, "TIPO" 		})
	oBrwTrb:addColumn({"Descricao"	, {|| aParametros[oBrwTrb:nAt, 4]}, "C", "@!"	, 1, 150,, .F. ,				, .F.,, "DESCRICAO"	,, .F., .T.,, "DESCRICAO" 	})
	oBrwTrb:addColumn({"Conteudo"	, {|| aParametros[oBrwTrb:nAt, 5]}, "C", "@!"	, 1, 150,, .T. , 				, .F.,, "CONTEUDO"	,, .F., .T.,, "CONTEUDO" 	})
	
	oBrwTrb:DisableReport()
	oBrwTrb:DisableConfig()
	
	oBrwTrb:SetEditCell(.T.)
	oBrwTrb:acolumns[5]:SetReadVar('Parametro')
	oBrwTrb:acolumns[5]:SetValid({|| fAlteraCont(aParametros[oBrwTrb:nAt, 1],aParametros[oBrwTrb:nAt, 2], PARAMETRO)})
	
	oBrwTrb:Activate()
	oBrwTrb:Refresh()

    RestArea(aArea)

Return

/*/{Protheus.doc} fAtuPars
	@type  Static Function
	@author Geanlucas Sousa
	@since 06/05/2025
	@description: Fun��o que cria as colunas do grid
/*/

Static Function CriaColuna(oBrowse)
	
	local aHeader 	:= {}
	Local nI		:= 0
	Local oColumn 	:= NIL
	
    aADD(aHeader,{"TR_FIL" 		,"Filial"		,01,"@!"	,0,011,0})
	aADD(aHeader,{"TR_PAR"		,"Parametro"	,02,"@!"	,1,015,0})
	aADD(aHeader,{"TR_TIPO"		,"Tipo"			,03,"@!"	,1,001,0})
	aADD(aHeader,{"TR_DESCRI"	,"Descri��o"	,04,"@!"	,1,100,0})
	aADD(aHeader,{"TR_CONTEUD"	,"Conteudo" 	,05,"@!"	,1,100,0})

	For nI := 1 To len(aHeader)
		oColumn := FWBrwColumn():New()
		oColumn:SetData(&("{||" + aHeader[nI][1] +"}"))
		oColumn:SetTitle(aHeader[nI][2] )
		oColumn:SetSize(aHeader[nI][6] )
		oBrowse:SetColumns({oColumn})
	Next nI
Return

/*/{Protheus.doc} fAlteraCont ()
	@type  Static Function
	@author Geanlucas Sousa
	@since 06/05/2025
	@description: Altera conteudo do campo na tabela temporaria.
/*/
Static Function fAlteraCont(cFil, cPar, cConteudo)

	Local lRet 	:= .T.
	Local nLine	:= oBrwTrb:nAt
	Local nCol	:= oBrwTrb:colPos()
	
	oBrwTrb:oData:aArray[nLine, nCol] := cConteudo

Return lRet

/*/{Protheus.doc} fPutPar ()
	@type  Static Function
	@author Geanlucas Sousa
	@since 06/05/2025
	@description: Altera conteudo dos Parametros.
/*/
Static Function fPutPar()

	Local aArea     := GetArea()
	Local lRet		:= .F.
	Local cAls		:= "SX6"
	Local cX6CONT	:= "SX6->X6_CONTEUD"
	Local cX6CSPA	:= "SX6->X6_CONTSPA"
	Local cX6CENG	:= "SX6->X6_CONTENG"
	Local nI		:= 0

	If Len(aParametros) > 0 
		Begin Transaction
			For nI := 1 To Len(aParametros)
				DbSelectArea(cAls)
				DbSetOrder(1)
				If (cAls)->(DbSeek(aParametros[nI][1]+aParametros[nI][2]))
					RecLock(cAls,.F.)
					&(cX6CONT) := aParametros[nI][5]
					&(cX6CSPA) := aParametros[nI][5]
					&(cX6CENG) := aParametros[nI][5]
					lRet := .T.
				EndIf
			Next nI
			(cAls)->(DbCloseArea())
		End Transaction
	EndIf

	If lRet
		MsgInfo("Parametro(s) atualizado(s)", 'Sucesso!')
	Else
		MsgInfo("Parametro(s) n�o atualizado(s)", 'Aten��o!')
	EndIf

	RestArea(aArea)

Return lRet
