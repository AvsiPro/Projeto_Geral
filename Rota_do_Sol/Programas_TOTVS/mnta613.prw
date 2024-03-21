#INCLUDE 'MNTA610.CH'
#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

//---------------------------------------------------------------------
/*/{Protheus.doc} MNTA613
Cadastro de Postos de Combustiveis
@type function

@author Cristiano Serafim Kair
@since 01/10/2021

@return Nil
/*/
//---------------------------------------------------------------------
Function MNTA613()

	Local oBrowse

	If !FindFunction( 'MNTAmIIn' ) .Or. MNTAmIIn(95)

		oBrowse	:= FWMBrowse():New()
		oBrowse:SetAlias( 'TQF' )
		oBrowse:SetMenuDef( 'MNTA613' )   // Indica qual o fonte que vai pegar o MenuDef
		oBrowse:SetDescription( STR0036 ) // 'Cadastro de Postos'
		oBrowse:Activate()

	EndIf

Return

//------------------------------------------------------------------------------
/*/{Protheus.doc} MenuDef
Inicializa o MenuDef com as suas op��es
@type function

@author Cristiano Serafim Kair
@since 01/10/2021

@return array, Array com o Menu MVC
/*/
//------------------------------------------------------------------------------
Static Function MenuDef()

	Local aRotina := {}

    // Adicionando op��es
    ADD OPTION aRotina TITLE STR0001 ACTION 'PesqBrw'         OPERATION 1                      ACCESS 0 // 'Pesquisar'
    ADD OPTION aRotina TITLE STR0002 ACTION 'VIEWDEF.MNTA613' OPERATION 2					   ACCESS 0 // 'Visualizar'
    ADD OPTION aRotina TITLE STR0003 ACTION 'VIEWDEF.MNTA613' OPERATION MODEL_OPERATION_INSERT ACCESS 0 // 'Incluir'
    ADD OPTION aRotina TITLE STR0004 ACTION 'VIEWDEF.MNTA613' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 // 'Alterar'
    ADD OPTION aRotina TITLE STR0005 ACTION 'VIEWDEF.MNTA613' OPERATION MODEL_OPERATION_DELETE ACCESS 0 // 'Excluir'
    ADD OPTION aRotina TITLE STR0006 ACTION 'MNTA611()' 	  OPERATION MODEL_OPERATION_INSERT ACCESS 0 // 'Negocia��o'
    ADD OPTION aRotina TITLE STR0007 ACTION 'MNTA612()' 	  OPERATION MODEL_OPERATION_INSERT ACCESS 0 // 'Pre�o'
	ADD OPTION aRotina TITLE STR0051 ACTION 'VIEWDEF.MNTA613' OPERATION 8  					   ACCESS 0 // 'Imprimir'

Return aRotina

//------------------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Regras de Modelagem da gravacao

@type function
@author Cristiano Serafim Kair
@since 01/10/2021

@return objeto, objeto do Modelo MVC
/*/
//------------------------------------------------------------------------------
Static Function ModelDef()

	Local oModel
	Local oStructTQF := FWFormStruct( 1, 'TQF' )
	
	// Cria o objeto do Modelo de Dados
	Local bPosValid	 := {|oModel| ValidInfo(oModel)	}  // Valida��o final
	Local bCommit	 := {|oModel| CommitInfo(oModel) } // Grava��o do formulario
	
	oModel := MPFormModel():New( 'MNTA613', /*bPreValid*/, bPosValid, bCommit, /*bCancel*/ )

	// Adiciona ao modelo uma estrutura de formul�rio de edi��o por campo
	oModel:AddFields( 'MNTA613_TQF', Nil, oStructTQF )

	oModel:SetDescription( NgSX2Nome( 'TQF' ) )

Return oModel

//------------------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Regras de Interface com o Usuario

@type function
@author Cristiano Serafim Kair
@since 01/10/2021

@return objeto, objeto da View MVC
/*/
//------------------------------------------------------------------------------
Static Function ViewDef()

	Local oModel := FWLoadModel( 'MNTA613' )
	Local oView  := FWFormView():New()

	// Objeto do model a se associar a view.
	oView:SetModel(oModel)

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'MNTA613_TQF' , FWFormStruct( 2, 'TQF' ) )
	oView:SetCloseOnOK({ || .T. })

	// Inclus�o de itens no A��es Relacionadas de acordo com o NGRightClick
	NGMVCUserBtn( oView )

Return oView

//---------------------------------------------------------------------
/*/{Protheus.doc} ValidInfo
P�s-valida��o do modelo de dados.

@author Cristiano Serafim Kair
@since 05/10/2021

@param  oModel, Objeto, Objeto principal da rotina, contem os valores informados.

@return l�gico, p�s valida��o do modelo
/*/
//---------------------------------------------------------------------
Static Function ValidInfo( oModel )

	Local nOperation := oModel:GetOperation()
	Local cAtivo 	 := oModel:GetValue( 'MNTA613_TQF', 'TQF_ATIVO' )
	Local lReturn	 := .T.

	If nOperation == MODEL_OPERATION_INSERT .Or. nOperation == MODEL_OPERATION_UPDATE

		If	oModel:GetValue( 'MNTA613_TQF', 'TQF_COMBOI' ) != '1' .And. Empty( oModel:GetValue( 'MNTA613_TQF', 'TQF_CNPJ' ) ) .And.;
			oModel:GetValue( 'MNTA613_TQF', 'TQF_CONVEN' ) != '4'

			Help( ' ', 1, STR0010, Nil,; // 'ATEN��O'
					STR0106 + " '" + AllTrim( FWSX3Util():GetDescription( 'TQF_CNPJ' ) ) + "'.", 1, 0 )// 'Para Postos, � obrigat�rio informar o campo'

			lReturn := .F.

		EndIf

		If lReturn .And. nOperation == MODEL_OPERATION_INSERT .And. !ExistChav('TQF', oModel:GetValue( 'MNTA613_TQF', 'TQF_CODIGO' ) + oModel:GetValue( 'MNTA613_TQF', 'TQF_LOJA' ) )

			lReturn := .F.

		EndIf

		If lReturn .And. oModel:GetValue( 'MNTA613_TQF', 'TQF_COMBOI' ) == '1' .And. Empty( oModel:GetValue( 'MNTA613_TQF', 'TQF_FROTA' ) )

			lReturn := MNTA613FRT()

		EndIf

		If lReturn .And. ExistBlock( 'MNTA6102' )

			If !ExecBlock( 'MNTA6102', .F., .F., { oModel } )

				lReturn := .F.

			EndIf

		EndIf

		If lReturn .And. nOperation == MODEL_OPERATION_UPDATE

			If cAtivo != TQF->TQF_ATIVO

				If cAtivo == '2' .And. Empty( oModel:GetValue( 'MNTA613_TQF', 'TQF_DTDESA' ) )
					Help( ' ', 1, STR0010, Nil, STR0088, 1, 0 ) // 'ATEN��O' // 'Posto estava Ativo(Sim) e passou para Ativa(N�o), ent�o � obrigat�rio informar a data de Desativa��o.'
					lReturn := .F.
				EndIf

				If lReturn .And. cAtivo == '1' .And. Empty( oModel:GetValue( 'MNTA613_TQF', 'TQF_DTREAT' ) )
					Help( ' ', 1, STR0010, , STR0089, 1, 0 ) // 'ATEN��O'### // 'Posto estava Ativo(N�o) e passou para Ativo(Sim) novamente, ent�o � obrigat�rio informar a data de Reativa��o.'
					lReturn := .F.
				EndIf

			EndIf

		Endif
	Endif

Return lReturn

//---------------------------------------------------------------------
/*/{Protheus.doc}  MNT613ATIV
Valida��o campo Desativa��o e Recadastramento

@type function
@author Cristiano Serafim Kair
@since 01/10/2021

@return L�gico, sempre .T.
/*/
//---------------------------------------------------------------------
Function MNT613ATIV()

	Local oModel := FWModelActive()
	Local cAtivo := oModel:GetValue( 'MNTA613_TQF', 'TQF_ATIVO' )
	Local oView
	
	If oModel:GetOperation() == MODEL_OPERATION_UPDATE .And. cAtivo != '2' .And. !IsBlind() .And. !MsgYesNo( STR0008, STR0010 ) // 'Deseja reativar o posto ?'###'ATENCAO'
		
		oView  := FWViewActive() // Ativa��o do View.
		oModel:SetValue( 'MNTA613_TQF', 'TQF_ATIVO', '2' )
		oView:Refresh()
		
	EndIf

Return .T.

//---------------------------------------------------------------------
/*/{Protheus.doc}  MNT613HIST
Grava historico do Posto na TQO

@type function
@author Cristiano Serafim Kair
@since 01/10/2021

@return L�gico. Sempre .T.
/*/
//---------------------------------------------------------------------
Function MNT613HIST()

	Local oModel  := FWModelActive()
	Local cCodigo := oModel:GetValue( 'MNTA613_TQF', 'TQF_CODIGO' )
	Local cLoja   := oModel:GetValue( 'MNTA613_TQF', 'TQF_LOJA' )
	Local dDtdesa := oModel:GetValue( 'MNTA613_TQF', 'TQF_DTDESA' )

	dbSelectArea( 'TQO' )
	dbSetOrder(1) // TQO_FILIAL+TQO_CODPOS+TQO_LOJA+DTOS(TQO_DTDESA)
	If !dbSeek(xFILIAL( 'TQO' ) + cCodigo + cLoja + DTOS(dDtdesa) )
		RecLock( 'TQO', .T. )
		TQO->TQO_FILIAL	:= xFILIAL( 'TQO' )
		TQO->TQO_CODPOS	:= cCodigo
		TQO->TQO_NREDUZ	:= oModel:GetValue( 'MNTA613_TQF', 'TQF_NREDUZ' )
		TQO->TQO_LOJA	:= cLoja
		TQO->TQO_ATIVO	:= oModel:GetValue( 'MNTA613_TQF', 'TQF_ATIVO' )
		TQO->TQO_DTCAD	:= oModel:GetValue( 'MNTA613_TQF', 'TQF_DTCAD' )
		TQO->TQO_DTDESA	:= dDtdesa
		TQO->TQO_DTUMOD	:= DDATABASE
		TQO->TQO_USUARI	:= SUBSTR(cUSUARIO,7,15)
		TQO->( MsUnLock( ) )
	EndIf

Return .T.

//---------------------------------------------------------------------
/*/{Protheus.doc} CommitInfo
Persiste dados do modelo no banco de dados

@author Cristiano Serafim Kair
@since 08/08/2021
@param  oModel, Objeto, Objeto principal da rotina, contem os valores informados.

@return L�gico. Sempre .T.
/*/
//---------------------------------------------------------------------
Static Function CommitInfo( oModel )

	Local nOperation := oModel:GetOperation() // Opera��o de a��o sobre o Modelo
	Local cAtivo 	 := TQF->TQF_ATIVO
	Local cComboi	 := oModel:GetValue( 'MNTA613_TQF', 'TQF_COMBOI' )

	Begin Transaction

		If FWFormCommit( oModel )

			If nOperation == MODEL_OPERATION_UPDATE

				If cAtivo != TQF->TQF_ATIVO // Se houve altera��o de Ativo para Desativado ou visse e versa
					MsgRun( OemToAnsi( STR0013 ), OemToAnsi( STR0014 ), { || MNT613HIST() } ) // 'Gravando Historico'###'Aguarde...'
					If cAtivo == '1'
						oModel:ClearField('MNTA613_TQF', 'TQF_DTDESA')
					EndIf
				EndIf
			
			ElseIf nOperation == MODEL_OPERATION_INSERT

				If TQF->TQF_ATIVO == '1' .And. TQF->TQF_TIPPOS != '3'

					// Apenas Administradores podem incluir Negocia��o e Pre�o Negociado manualmente para Comboios
					If cComboi != '1' .Or. ( cComboi == '1' .And. FWIsAdmin() )

						If !IsBlind() .And. MsgYesNo( STR0015, STR0016 ) // 'Deseja incluir a Negocia��o ?'###'ATENC�O'

							MNTA611(.T.)

						EndIf

					EndIf

				EndIf

			EndIf
	
		EndIf

	End Transaction

Return .T.

//---------------------------------------------------------------------
/*/{Protheus.doc}  MNTA613POS
Valida��o do Posto.
@type function

@author Cristiano Serafim Kair
@since 01/10/2021
@version V12

@return L�gico. True se posto � v�lido para o cadastro
/*/
//---------------------------------------------------------------------
Function MNTA613POS()

	Local oModel  := FWModelActive()
	Local cCodigo := oModel:GetValue( 'MNTA613_TQF', 'TQF_CODIGO' )
	Local cloja   := oModel:GetValue( 'MNTA613_TQF', 'TQF_LOJA' )
	Local lAltera := oModel:GetOperation() != MODEL_OPERATION_UPDATE
 	Local lReturn := .T.

	cloja   := IIf( Empty( cloja ), SA2->A2_LOJA, cloja )

	If oModel:GetValue( 'MNTA613_TQF', 'TQF_COMBOI' ) != '1'

		If !ExistCpo( 'SA2', cCodigo, 1 )
			lReturn := .F.
		EndIf

		If lReturn .And. lAltera .And. NGIFDBSEEK( 'TQF', cCodigo + cloja, 1 )
			Help( ' ', 1, STR0010, Nil, STR0107, 1, 0 ) // 'ATEN��O'###'J� existe um Posto cadastrado com este c�digo. Favor alterar o C�digo do Posto ou cancelar a opera��o.'
			lReturn := .F.
		EndIf

	EndIf

Return lReturn

//---------------------------------------------------------------------
/*/{Protheus.doc}  MNT613DTDES
Valida data de desativacao nao pode ser menor que a data de
cadastramento do posto,nem menor que ultimo abast. e negoc.
@type function

@author Cristiano Serafim Kair
@since 01/10/2021
@version V12

@return L�gico. True se datas est�o dentro das regras.
/*/
//---------------------------------------------------------------------
Function MNT613DTDES()

	Local oModel	 := FWModelActive()
	Local dDtdesa	 := oModel:GetValue( 'MNTA613_TQF', 'TQF_DTDESA' )
	Local dDtreat	 := oModel:GetValue( 'MNTA613_TQF', 'TQF_DTREAT' )
	Local dDtUltAbas := ' '
	Local dDtUltPrec := ' '
	Local lReturn	 := .T.
	Local cAliasTQN	 := GetNextAlias()
	Local cAliasTQH	 := GetNextAlias()
	Local aArea		 := GetArea()

	If !Empty(dDtdesa).And. dDtdesa < TQF->TQF_DTCAD
		Help( ' ', 1, STR0016, , STR0079, 3,1 ) // 'ATENC�O'### // 'Data de Desativa��o do Posto n�o pode ser menor que a Data do Cadastramento.'
		lReturn := .F.
	EndIf

	// data da reativacao nao pode ser menor que a data do cadastramento
	If lReturn .And. !Empty(dDtreat) .And. dDtreat < TQF->TQF_DTCAD
		Help( ' ', 1, STR0016, , STR0080, 3, 1 ) // 'ATENC�O'###'Data de reativa��o do Posto n�o pode ser menor que a data do cadastramento.'
		lReturn := .F.
	EndIf

	If lReturn .And. !Empty(dDtreat) .And. dDtreat < TQF->TQF_DTDESA
		Help( ' ', 1, STR0016, , STR0101, 3, 1 ) // 'ATENC�O'###  // 'Data de reativa��o do posto n�o pode ser menor que a data de desativa��o.'
		lReturn := .F.
	EndIf

	// menor que ultimo abastecimento
	If lReturn

		BeginSql Alias cAliasTQN
			SELECT TQN.TQN_DTABAS
				FROM %table:TQN% TQN
			WHERE	TQN.TQN_FILIAL 	= %xFilial:TQN%
				AND	TQN.TQN_POSTO  	= %exp:TQF->TQF_CODIGO%
				AND TQN.TQN_LOJA 	= %exp:TQF->TQF_LOJA%
				AND TQN.%NotDel%
			ORDER BY TQN.TQN_DTABAS DESC, TQN.TQN_HRABAS DESC
		EndSql

		dDtUltAbas := ( cAliasTQN )->(TQN_DTABAS)

		( cAliasTQN )->( DbCloseArea() )

	EndIf

	If lReturn .And. !Empty(dDtdesa) .And. DTOS(dDtdesa) < dDtUltAbas
		Help( '', 1, STR0016, , STR0082, 3, 1 ) // 'Aten��o'###'Data de Desativa��o do Posto n�o pode ser menor que a Data do �ltimo Abastecimento.'
		lReturn := .F.
	EndIf

	If lReturn

		BeginSql Alias cAliasTQH
			SELECT TQH.TQH_DTNEG
				FROM %table:TQH% TQH
			WHERE	TQH.TQH_FILIAL 	= %xFilial:TQH%
				AND	TQH.TQH_CODPOS 	= %exp:TQF->TQF_CODIGO%
				AND TQH.TQH_LOJA 	= %exp:TQF->TQF_LOJA%
				AND TQH.%NotDel%
			ORDER BY TQH.TQH_DTNEG DESC, TQH.TQH_HRNEG DESC
		EndSql

		dDtUltPrec := ( cAliasTQH )->( TQH_DTNEG )

		( cAliasTQH )->( DbCloseArea() )

	EndIf

	If lReturn .And. !Empty(dDtdesa)
		If DTOS(dDtdesa) < dDtUltPrec
			Help( ' ', 1, STR0016, , STR0083, 3, 1 ) // 'ATENC�O'### // 'Data de Desativa��o do Posto n�o pode ser menor que a Data do �ltimo Pre�o Negociado.'
			lReturn := .F.
		EndIf
	EndIf

	RestArea( aArea )

Return lReturn

//---------------------------------------------------------------------
/*/{Protheus.doc}  MNA613DT
Validacao da data de Reativacao 
@type function

@author Cristiano Serafim Kair
@since 01/10/2021
@version V12

@return L�gico. True se data est� dentro das regras.
/*/
//---------------------------------------------------------------------
Function MNA613DT()

	Local oModel  := FWModelActive()
	Local lReturn := .T.

	If  oModel:GetValue( 'MNTA613_TQF', 'TQF_DTREAT' ) > dDataBase
		HELP( ' ', 1, STR0010, , STR0031, 3, 1 ) // 'ATEN��O'###'Data da Reativa��o n�o pode ser superior � data atual.'
		lReturn := .F.
	EndIf

	If  oModel:GetValue( 'MNTA613_TQF', 'TQF_DTDESA' ) > dDataBase
		HELP( ' ', 1, STR0010, , STR0026, 3, 1 ) // 'ATEN��O'###'Data da Desativa��o do posto n�o pode ser superior � data atual.'
		lReturn := .F.
	EndIf

Return lReturn

//---------------------------------------------------------------------
/*/{Protheus.doc}  MNT613DTCAD
Valida data do cadastramento do posto nao maior que Dt. corrente.
@type function

@author Cristiano Serafim Kair
@since 01/10/2021
@version V12

@return L�gico. True se data negocia��o menor que data atual
/*/
//---------------------------------------------------------------------
Function MNT613DTCAD()

	Local oModel  := FWModelActive()
	Local lReturn := .T.

	If oModel:GetValue( 'MNTA613_TQF', 'TQF_DTCAD' ) > dDataBase
		Help( '', 1, STR0016, , STR0096, 3, 1 ) // 'ATENC�O'###  // 'Data do cadastramento do Posto n�o pode ser maior que a Data corrente.'
		lReturn := .F.
	EndIf

Return lReturn

//---------------------------------------------------------------------
/*/{Protheus.doc}  MNA613ADM
Valida usu�rio se tem permiss�o de Administrador. Usada no MNTA611 e MNTA612
@type function

@author Cristiano Serafim Kair
@since 01/10/2021
@version V12

@param  oModel, Objeto, Objeto principal da rotina, contem os valores informados.

@return L�gico. True se for Administrador
/*/
//---------------------------------------------------------------------
Function MNA613ADM( oModel )

	Local nOpcX	  := oModel:GetOperation()
	Local lReturn := .T.

	// Apenas Administradores podem incluir Negocia��o e Pre�o Negociado manualmente para Comboios
	If TQF->TQF_COMBOI == '1' .And. TQF->TQF_CONVEN = '7' .And. !FWIsAdmin()

		If nOpcX == MODEL_OPERATION_INSERT

			If oModel:cSource == 'MNTA612'
				Help( '', 1, STR0010, ,; // 'ATEN��O'
						STR0104 + Chr( 10 ) + Chr( 13 ) +; // 'N�o � permitido incluir manualmente um Pre�o Negociado para um Comboio.'
						STR0103, 1 ,0 ,,,,,,; // 'Apenas Administradores possuem permiss�o para esta opera��o.'
						{STR0112} ) // 'Solicite a inclus�o para um administrador.'
			Else
				Help( '', 1, STR0010, ,; // 'ATEN��O'
						STR0105 + Chr( 10 ) + Chr( 13 ) +; // 'N�o � permitido incluir manualmente uma Negocia��o para um Comboio.'
						STR0103, 1 ,0 ,,,,,,; // 'Apenas Administradores possuem permiss�o para esta opera��o.'
						{STR0112} ) // 'Solicite a inclus�o para um administrador.'
			EndIf

			lReturn := .F.

		ElseIf nOpcX == MODEL_OPERATION_UPDATE

			If oModel:cSource == 'MNTA612'
				Help( '', 1, STR0010, ,; // 'ATEN��O'
						STR0116 + Chr( 10 ) + Chr( 13 ) +; // 'N�o � permitido alterar manualmente um Pre�o Negociado para um Comboio.'
						STR0103, 1 ,0 ,,,,,,; // 'Apenas Administradores possuem permiss�o para esta opera��o.'
						{STR0117} ) // 'Solicite a altera��o para um administrador.'
			Else
				Help( '', 1, STR0010, ,; // 'ATEN��O'
						STR0120 + Chr( 10 ) + Chr( 13 ) +; // 'N�o � permitido alterar manualmente uma Negocia��o para um Comboio.'
						STR0103, 1 ,0 ,,,,,,; // 'Apenas Administradores possuem permiss�o para esta opera��o.'
						{STR0117} ) // 'Solicite a altera��o para um administrador.'
			EndIf

			lReturn := .F.

		ElseIf nOpcX == MODEL_OPERATION_DELETE

			If oModel:cSource == 'MNTA612'
				Help( '', 1, STR0010, ,; // 'ATEN��O'
						STR0118 + Chr( 10 ) + Chr( 13 ) +; // 'N�o � permitido excluir manualmente um Pre�o Negociado para um Comboio.'
						STR0103, 1 ,0 ,,,,,,; // 'Apenas Administradores possuem permiss�o para esta opera��o.'
						{STR0119} ) // 'Solicite a exclus�o para um administrador.'
			Else
				Help( '', 1, STR0010, ,; // 'ATEN��O'
						STR0121 + Chr( 10 ) + Chr( 13 ) +; // 'N�o � permitido excluir manualmente uma Negocia��o para um Comboio.'
						STR0103, 1 ,0 ,,,,,,; // 'Apenas Administradores possuem permiss�o para esta opera��o.'
						{STR0119} ) // 'Solicite a exclus�o para um administrador.'
			EndIf

			lReturn := .F.

		EndIf
		
	EndIf

Return lReturn

//---------------------------------------------------------------------
/*/{Protheus.doc}  MNTA613LOJ
Valida��o da Loja do Posto.
@type function

@author Cristiano Serafim Kair
@since 01/10/2021
@version V12

@return L�gico. Retorna .T. se n�o existe Posto+Loja j� cadastrados como Posto.
/*/
//---------------------------------------------------------------------
Function MNTA613LOJ()

	Local oModel  := FWModelActive()
	Local cCodigo := oModel:GetValue( 'MNTA613_TQF', 'TQF_CODIGO' )
	Local cLoja   := oModel:GetValue( 'MNTA613_TQF', 'TQF_LOJA' )
	Local lAltera := oModel:GetOperation() != MODEL_OPERATION_UPDATE
 	Local lReturn := .T.

	If oModel:GetValue( 'MNTA613_TQF', 'TQF_COMBOI' ) != '1'

		If !Empty(cLoja) .And. !ExistCpo( 'SA2', cCodigo + cLoja, 1)
			lReturn := .F.
		EndIf

		If lReturn .And. lAltera .And. NGIFDBSEEK( 'TQF', cCodigo + cLoja, 1 )
			Help( NIL, 1, STR0010,; // 'ATEN��O'
						NIL, STR0108,; // 'J� existe um Posto/Loja cadastrado com estes c�digos.'
						1, 0, NIL, NIL, NIL, NIL, NIL, {STR0114} ) // 'Favor alterar o C�digo do Posto/Loja, ou cancelar a opera��o.'
			lReturn := .F.
		EndIf

	EndIf

Return lReturn

//---------------------------------------------------------------------
/*/{Protheus.doc}  MNTA613CMB
Realiza as devidas altera��es no cadastro de acordo com a flag do COMBOIO.
@type function

@author Cristiano Serafim Kair
@since 01/10/2021
@version V12

@return L�gico. Sempre .T.
/*/
//---------------------------------------------------------------------
Function MNTA613CMB()

	Local oModel  := FWModelActive()

	// Se for Comboio, define o Posto como Posto Interno; caso contr�rio, define como Posto Conveniado
	If oModel:GetValue( 'MNTA613_TQF', 'TQF_COMBOI' ) == '1'
		oModel:SetValue( 'MNTA613_TQF', 'TQF_TIPPOS', '2' )
	Else
		// Limpa o conte�do do campo da Frota caso o posto n�o seja um Comboio
		oModel:ClearField( 'MNTA613_TQF', 'TQF_FROTA' )
	EndIf

Return .T.

//---------------------------------------------------------------------
/*/{Protheus.doc}  MNTA613FRT
Valida��o da Frota (C�digo do Bem) quando o Posto � um Comboio
@type function

@author Cristiano Serafim Kair
@since 01/10/2021
@version V12

@param lBloqueia, L�gico, Indica se deve impedir a continuidade da rotina

@return L�gico. True se a Frota informada est� liberada para uso.
/*/
//---------------------------------------------------------------------
Function MNTA613FRT(lBloqueia)

	Local oModel    := FWModelActive()
	Local cComboio  := oModel:GetValue( 'MNTA613_TQF', 'TQF_COMBOI' )
	Local cFrota    := oModel:GetValue( 'MNTA613_TQF', 'TQF_FROTA' )
	Local lComboio  := (cComboio == '1' )
	Local aAreaTQF  := TQF->( GetArea() )
	Local lReturn	:= .T.
	Local cAliasTQF	:= GetNextAlias()
	Local lPosto	:= .F.

	Default lBloqueia := .T.

	// Valida o preenchimento do campo
	If Empty(cFrota)
		If !lComboio
			lReturn := .T.
		Else
			Help( NIL, 1, STR0010,; // 'ATEN��O'
					NIL, STR0111,; // 'N�o foi informada a frota relacionada ao comboio.'
					1, 0, NIL, NIL, NIL, NIL, NIL, {STR0109} ) // 'Quando o Posto for um Comboio, � obrigat�rio informar a Frota relacionada a ele.'
			lReturn := !lBloqueia
		EndIf
	ElseIf lComboio .And. !ExistCpo( 'ST9', cFrota, 1)
		lReturn := .F.
	EndIf

	// Valida se a Frota n�o est� relacionada a outro posto
	If lReturn .And. lComboio

		BeginSql Alias cAliasTQF
			SELECT COUNT(TQF_FROTA) total, TQF.TQF_CODIGO
				FROM %table:TQF% TQF
			WHERE	TQF.TQF_FILIAL 	= %xFilial:TQF%
				AND	TQF.TQF_COMBOI 	= %exp:cComboio%
				AND TQF.TQF_FROTA 	= %exp:cFrota%
				AND TQF.%NotDel%
			GROUP BY TQF.TQF_CODIGO
		EndSql

		// Verifica se o posto que encontrou � o mesmo posto que estamos posicionados na TQF
		lPosto := ( cAliasTQF )->( TQF_CODIGO ) != TQF->TQF_CODIGO

		If lPosto .And. ( cAliasTQF )->(total) >= 1
			Help( NIL, 1, STR0010,; // 'ATEN��O'
					NIL, STR0110,; // 'Esta Frota j� est� relacionada � outro posto.'
					1, 0, NIL, NIL, NIL, NIL, NIL, {STR0113} ) // 'Selecione outra frota para relacionamento.'
			lReturn := !lBloqueia
		EndIf

		( cAliasTQF )->( DbCloseArea() )

	EndIf

	RestArea(aAreaTQF)

Return lReturn

//---------------------------------------------------------------------
/*/{Protheus.doc}  MNA613VLD
Fun��o acumuladora dos valid da TQF
@type function

@author Cristiano Serafim Kair
@since 01/10/2021
@version V12

@param cCampo, Caracter, campo a ser validado

@return L�gico. True se existe chave com os argumentos.
/*/
//---------------------------------------------------------------------
Function MNA613VLD( cCampo )

	Local oModel  := FWModelActive()
	Local lReturn := .T.

	Do Case

		Case cCampo == 'TQF_COMBOI'

			lReturn := Pertence( '12' ) .And. MNTA613CMB()

		Case cCampo == 'TQF_CNPJ'

			lReturn := Vazio() .Or. CGC( oModel:GetValue( 'MNTA613_TQF', 'TQF_CNPJ' ) )

		Case cCampo == 'TQF_CODIGO'

			lReturn := Vazio() .Or. MNTA613POS()

		Case cCampo == 'TQF_LOJA'

			lReturn := Vazio() .Or. MNTA613LOJ()

		Case cCampo == 'TQF_TIPPOS'

			lReturn := Pertence( '123' )

		Case cCampo == 'TQF_CONVEN'

			lReturn := Pertence( '1234567' )

		Case cCampo == 'TQF_ATIVO'

			lReturn := Pertence( '12' ) .AND. MNT613ATIV()

		Case cCampo == 'TQF_CODFIL'

			lReturn := EXISTCPO( 'SM0',SM0->M0_CODIGO + oModel:GetValue( 'MNTA613_TQF', 'TQF_CODFIL' ) )

		Case cCampo == 'TQF_DTCAD'

			lReturn := MNT613DTCAD()

		Case cCampo == 'TQF_DTDESA'

			lReturn := MNT613DTDES() .AND. MNA613DT()

		Case cCampo == 'TQF_DTREAT'

			lReturn := MNT613DTDES() .AND. MNA613DT()

		Case cCampo == 'TQF_LANMAN'

			lReturn := Pertence( '12' )

		Case cCampo == 'TQF_FROTA'

			lReturn := MNTA613FRT()

	EndCase

Return lReturn

//---------------------------------------------------------------------
/*/{Protheus.doc}  MNA613WHEN
Fun��o acumuladora dos when da TQF
@type function

@author Cristiano Serafim Kair
@since 01/10/2021
@version V12

@param cCampo, Caracter, campo a ser validado

@return L�gico. True se existe chave com os argumentos.
/*/
//---------------------------------------------------------------------
Function MNA613WHEN( cCampo )

	Local lReturn := .T.
	Local oModel  := FWModelActive()
	Local cComboi := oModel:GetValue( 'MNTA613_TQF', 'TQF_COMBOI' )
	Local cTippos := oModel:GetValue( 'MNTA613_TQF', 'TQF_TIPPOS' )
	Local cAtivo  := oModel:GetValue( 'MNTA613_TQF', 'TQF_ATIVO' )
	Local lInclui := oModel:GetOperation() == MODEL_OPERATION_INSERT

	Do Case

		Case cCampo == 'TQF_CNPJ'

			lReturn := cComboi == '1'
			
		Case cCampo == 'TQF_NREDUZ'

			lReturn := cComboi == '1'
			
		Case cCampo == 'TQF_CIDADE'

			lReturn := cComboi == '1'
			
		Case cCampo == 'TQF_BAIRRO'

			lReturn := cComboi == '1'
			
		Case cCampo == 'TQF_ESTADO'

			lReturn := cComboi == '1'
			
		Case cCampo == 'TQF_TIPPOS'

			lReturn := lInclui .And. cComboi == '2'
			
		Case cCampo == 'TQF_CONVEN'

			lReturn := cTippos != '3'
			
		Case cCampo == 'TQF_ATIVO'

			lReturn := cTippos != '3'
			
		Case cCampo == 'TQF_DTDESA'

			lReturn := cAtivo == '2'
			
		Case cCampo == 'TQF_DTREAT'

			lReturn := cAtivo != '2'
			
		Case cCampo == 'TQF_USUARI'

			lReturn := IIf( FunName() == 'MNTA656', lTrava656, .T. )
			
		Case cCampo == 'TQF_FROTA'

			lReturn := cComboi == '1'

	EndCase

Return lReturn

//---------------------------------------------------------------------
/*/{Protheus.doc}  MNT613FN
Gatilho para campo telefone c/DDD e Fone do SA2
@type function

@author Cristiano Serafim Kair
@since 01/10/2021
@version V12

@return Caracter. Telefone puxando da SA2
/*/
//---------------------------------------------------------------------
Function MNT613FN()

	cTEL := AllTrim(SA2->A2_DDD+SA2->A2_TEL)

	n := AT("-",cTEL)
	If n > 0
		cTEL := SUBSTR(cTEL,1,n-1)+SUBSTR(cTEL,n+1,Len(cTel))
	EndIf

	nTAM := LEN(ALLTRIM(cTEL))
	If SubStr(cTEL,1,1) == "0"
		cTEL := SubStr(cTEL,2,nTAM)
	EndIf

	If nTAM <= 8
		cTEL := "xx"+cTEL
	EndIf

Return cTEL

//---------------------------------------------------------------------
/*/{Protheus.doc}  MNA613RELA
Rela��o da tabela TQF
@type function

@author Cristiano Serafim Kair
@since 01/10/2021
@version V12

@param cCampo, Caracter, campo a ser validado

@return Caracter. Valor do Rela��o do campo em quest�o.
/*/
//---------------------------------------------------------------------
Function MNA613RELA( cCampo )

	Local xRet
	Local oModel  := FWModelActive()
	Local lInclui
	
	// Tratativa no cen�rio em que a TQF est� sendo chamada em outro Fonte
	// Ex: MNTA615
	If oModel != Nil
		lInclui := oModel:GetOperation() == MODEL_OPERATION_INSERT
	Else
		lInclui := Inclui
	EndIf

	Do Case

		Case cCampo == 'TQF_COMBOI'

			xRet := IIf(lInclui, "2", TQF->TQF_COMBOI)
			
		Case cCampo == 'TQF_LOJA'

			xRet := SA2->(VDISP(TQF->TQF_CODIGO,'A2_LOJA'))
			
		Case cCampo == 'TQF_POSTO'

			xRet := SA2->(VDISP(TQF->TQF_CODIGO+TQF->TQF_LOJA,'A2_NOME'))
			
		Case cCampo == 'TQF_NREDUZ'

			xRet := SA2->(VDISP(TQF->TQF_CODIGO+TQF->TQF_LOJA,'A2_NREDUZ'))
			
		Case cCampo == 'TQF_CIDADE'

			xRet := SA2->(VDISP(TQF->TQF_CODIGO+TQF->TQF_LOJA,'A2_MUN'))
			
		Case cCampo == 'TQF_BAIRRO'

			xRet := SA2->(VDISP(TQF->TQF_CODIGO+TQF->TQF_LOJA,'A2_BAIRRO'))
			
		Case cCampo == 'TQF_ESTADO'

			xRet := SA2->(VDISP(TQF->TQF_CODIGO+TQF->TQF_LOJA,'A2_EST'))
			
		Case cCampo == 'TQF_TIPPOS'

			xRet := IIf(lInclui,'1',TQF->TQF_TIPPOS)
			
		Case cCampo == 'TQF_CONVEN'

			xRet := IIf(lInclui,'1',TQF->TQF_CONVEN)
			
		Case cCampo == 'TQF_ATIVO'

			xRet := IIf(lInclui,'1',TQF->TQF_ATIVO)
			
		Case cCampo == 'TQF_DTCAD'

			xRet := dDataBase
			
		Case cCampo == 'TQF_LANMAN'

			xRet := IIf(lInclui,'1',TQF->TQF_LANMAN)
			
		Case cCampo == 'TQF_DTUMOD'

			xRet := dDataBase
			
		Case cCampo == 'TQF_USUARI'

			xRet := SUBSTR( cUSUARIO, 7, 15 )

	EndCase

Return xRet

//---------------------------------------------------------------------
/*/{Protheus.doc}  MNA613GAT
Gatilhos da tabela TQF
@type function

@author Cristiano Serafim Kair
@since 01/10/2021
@version V12

@param cDomain,  Caracter, campo que est� gatilhando
@param cCDomain, Caracter, campo a receber o valor do gatilho

@return Indefinido. Valor do Gatilho do campo em quest�o.
/*/
//---------------------------------------------------------------------
Function MNA613GAT( cDomain, cCDomain )

	Local xRet
	Local oModel := FWModelActive()

	Do Case

		Case cDomain == 'TQF_TIPPOS' .And. cCDomain == 'TQF_CONVEN'

			If oModel:GetValue( 'MNTA613_TQF', 'TQF_TIPPOS' ) == '3'

				xRet := '4'

			Else 

				xRet := oModel:GetValue( 'MNTA613_TQF', 'TQF_CONVEN' )

			EndIf

		Case cDomain == 'TQF_ATIVO' .And. cCDomain == 'TQF_DTDESA'

			If oModel:GetValue( 'MNTA613_TQF', 'TQF_ATIVO' ) == '1'
			
				xRet := CtoD('  /  /  ')

			Else

				xRet := oModel:GetValue( 'MNTA613_TQF', 'TQF_DTDESA' )

			EndIf

	EndCase

Return xRet
