#INCLUDE 'MNTA611.CH'
#INCLUDE 'TOTVS.CH'
#INCLUDE 'FWMVCDEF.CH'

//---------------------------------------------------------------------
/*/{Protheus.doc} MNTA611
Cadastro de Negociação

@type function
@author cristiano.kair
@since 05/10/2021

@param lOpenView, Lógico, usado para abrir a View diretamente

@return Nil
/*/
//---------------------------------------------------------------------
Function MNTA611(lOpenView)

	Local oBrowse
	Local lReturn	:= .T.

	Default lOpenView := .F.

	If TQF->TQF_TIPPOS == '3'

		Help( ' ', 1, STR0002,, STR0003, 1, 0 )  //'ATENÇÃO'###'Posto não conveniado!'
		lReturn := .F.

	EndIf

	If lReturn .And. TQF->TQF_ATIVO == '2'

		Help( ' ', 1, STR0002,, STR0022, 1, 0 ,,,,,, {STR0023}  )  //'ATENÇÃO'###'Posto esta Desativado.'###'Ative o Posto para realizar cadastro de Negociação ou Preço.'
		
		lReturn := .F.

	EndIf

	If lReturn

		oBrowse := FWMBrowse():New()
		oBrowse:SetAlias( 'TQG' )
		oBrowse:SetDescription( STR0001 ) // 'Negociação'
		oBrowse:SetMenuDef( 'MNTA611' )
		oBrowse:SetFilterDefault( 'TQG_FILIAL == "' + xFILIAL( 'TQF' ) + '" .And. TQG_CODPOS == TQF->TQF_CODIGO .And. TQG_LOJA == TQF->TQF_LOJA' )
		oBrowse:SetChgAll(.F.)

		If lOpenView

			oExecView := FWViewExec():New()
			oExecView:SetSource( 'MNTA611' )
			oExecView:SetModal( .F. )
			oExecView:SetOperation( 3 ) //Inclusão.
			oExecView:OpenView( .T. )

		Else

			oBrowse:Activate()
			
		EndIf
	
	EndIf

Return lReturn

//------------------------------------------------------------------------------
/*/{Protheus.doc} MenuDef
Inicializa o MenuDef com as suas opções

@type function
@author cristiano.kair
@since 05/10/2021

@return FWMVCMenu() Vai retornar as opções padrão do menu, como 'Incluir', 
'Alterar', e 'Excluir'
/*/
//------------------------------------------------------------------------------
Static Function MenuDef()

Return FWMVCMenu( 'MNTA611' )

//------------------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Regras de Modelagem da gravacao

@type function
@author cristiano.kair
@since 05/10/2021

@return oModel objeto do Modelo MVC
/*/
//------------------------------------------------------------------------------
Static Function ModelDef()

	Local oModel
	Local oStructTQG := FWFormStruct( 1, 'TQG', , .F. )
	Local bPreValid	 := { |oModel| PreValida( oModel )	} // Validação inicial
	Local bPosValid	 := { |oModel| ValidInfo( oModel )	}  // Validação final
	Local bCommit	 := { |oModel| CommitInfo( oModel ) } // Gravação do formulario
	
	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New( 'MNTA611', , bPosValid, bCommit, /*bCancel*/)

	// Validate model activation
	oModel:SetVldActivate( bPreValid )

	// Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:AddFields( 'MNTA611_TQG', Nil, oStructTQG )

	oModel:SetDescription( NgSX2Nome( 'TQG' ) )

Return oModel

//------------------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Regras de Interface com o Usuario

@type function
@author cristiano.kair
@since 05/10/2021

@return oView objeto da View MVC
/*/
//------------------------------------------------------------------------------
Static Function ViewDef()

	Local oModel := FWLoadModel( 'MNTA611' )
	Local oView  := FWFormView():New()

	// Objeto do model a se associar a view.
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'MNTA611_TQG' , FWFormStruct( 2, 'TQG' ) )

	// Inclusão de itens no Ações Relacionadas de acordo com o NGRightClick
	NGMVCUserBtn( oView )

Return oView

//------------------------------------------------------------------------------
/*/{Protheus.doc} PreValida
Pre validação para abertura do cadastro

@type function
@author cristiano.kair
@since 05/10/2021

@param  oModel, Objeto, Objeto principal da rotina, contem os valores informados.
@return Lógica. Valida se é administrador e se tem negociação com o posto e loja
/*/
//------------------------------------------------------------------------------
Static Function PreValida( oModel )

	Local nOperation := oModel:GetOperation()
	Local aArea      := GetArea()
	Local lReturn	 := .T.
	Local cAliasTQN

	If !MNA613ADM( oModel )

		lReturn := .F.

	EndIf

	If lReturn .And. ( nOperation == MODEL_OPERATION_DELETE .Or. nOperation == MODEL_OPERATION_UPDATE )

		cAliasTQN  := GetNextAlias()

		// Verifica na TQN se já tem abastecimento com o Posto e Loja da Negociação
		BeginSql Alias cAliasTQN
			SELECT TQN.TQN_DTABAS, TQN.TQN_HRABAS
				FROM %table:TQN% TQN
			WHERE	TQN.TQN_FILIAL 	= %xFilial:TQN%
				AND	TQN.TQN_POSTO 	= %exp:TQG->TQG_CODPOS%
				AND TQN.TQN_LOJA  	= %exp:TQG->TQG_LOJA%
				AND TQN.TQN_DTABAS 	>= %exp:TQG->TQG_DTNEG%
				AND TQN.TQN_HRABAS 	>= %exp:TQG->TQG_HRNEG%
				AND TQN.%NotDel%
			GROUP BY TQN.TQN_DTABAS, TQN.TQN_HRABAS
		EndSql

		If ( cAliasTQN )->( TQN_DTABAS ) >= DtoS( TQG->TQG_DTNEG )

			Help( ' ', 1, STR0002, , STR0019, 3, 1 )  //'ATENÇÃO'###'Não é possível alterar ou excluir negociação com abastecimento existente.'
			lReturn := .F.

		EndIf

		( cAliasTQN )->( DbCloseArea() )

	EndIf

	RestArea(aArea)

Return lReturn

//---------------------------------------------------------------------
/*/{Protheus.doc} ValidInfo
Pós-validação do modelo de dados.

@author Cristiano Serafim Kair
@since 05/10/2021

@param  oModel, Objeto, Objeto principal da rotina, contem os valores informados.

@return lógico, pós validação do modelo
/*/
//---------------------------------------------------------------------
Static Function ValidInfo( oModel )

	Local aArea 	 := GetArea()
	Local nOperation := oModel:GetOperation() // Operação de ação sobre o Modelo
	Local lReturn	 := .T.
	Local cAliasTQH

	// Verifica se tem um preço com data igual ou superior para o posto+loja
	If nOperation == MODEL_OPERATION_DELETE

		cAliasTQH := GetNextAlias()

		BeginSql Alias cAliasTQH
			SELECT Count(TQH_DTNEG) total
				FROM %table:TQH% TQH
			WHERE	TQH.TQH_FILIAL 	=  %xFilial:TQH%
				AND	TQH.TQH_CODPOS 	=  %exp:TQG->TQG_CODPOS%
				AND TQH.TQH_LOJA 	=  %exp:TQG->TQG_LOJA%
				AND TQH.TQH_DTNEG 	=  %exp:DtoS(TQG->TQG_DTNEG)%
				AND TQH.TQH_HRNEG 	>= %exp:TQG->TQG_HRNEG%
				AND TQH.%NotDel%
		EndSql

		If ( cAliasTQH )->total > 0

			Help( '', 1, STR0002, , STR0021, 3, 1 ) // 'ATENCÃO'### //'Exclusão não permitida. Já existe preço relacionado a este posto.'
			lReturn := .F.
			
		EndIf

		( cAliasTQH )->( DbCloseArea() )

	EndIf

	RestArea( aArea )

	If lReturn .And. nOperation == MODEL_OPERATION_INSERT .Or. nOperation == MODEL_OPERATION_UPDATE

		lReturn := MNA611OBRI() // Valida campos referente ao faturamento da Negociação

	EndIf

Return lReturn

//---------------------------------------------------------------------
/*/{Protheus.doc} CommitInfo
Persiste dados do modelo no banco de dados

@author Cristiano Serafim Kair
@since 08/08/2021

@param  oModel, Objeto, Objeto principal da rotina, contem os valores informados.
@return Lógico - Retorna verdadeiro caso validacoes estejam corretas
/*/
//---------------------------------------------------------------------
Static Function CommitInfo( oModel )

	If FWFormCommit( oModel )
	
		If oModel:GetOperation() == MODEL_OPERATION_INSERT .And. !IsBlind() .And. MsgYesNo( STR0020, STR0002 ) // 'Deseja incluir Preço?'###'ATENCÃO'

			MNTA612(.T.)

		EndIf

	EndIf

Return .T.

//---------------------------------------------------------------------
/*/{Protheus.doc}  MNA611OBRI
Valida campos referente ao faturamento da Negociação
@type function

@author Cristiano Serafim Kair
@since 01/10/2021
@version V12

@return Lógico. True se campos estão dentro das regras.
/*/
//---------------------------------------------------------------------
Static Function MNA611OBRI()

	Local lReturn := .T.
	Local oModel  := FWModelActive()

	If TQF->TQF_TIPPOS != '2' // Quando o posto não foi um Posto Interno

		If Empty( oModel:GetValue( 'MNTA611_TQG', 'TQG_PRAZO' ) )
			Help( '', 1, STR0002, , STR0011, 3, 1 ) //'ATENCÃO'###'Para tipos de postos conveniados ou não conveniados deve-se informar o Prazo de Pagamento.'
			lReturn := .F.
		EndIf

		If lReturn .And. Empty( oModel:GetValue( 'MNTA611_TQG', 'TQG_DIAFAT' ) )
			Help( '', 1, STR0002, , STR0012, 3, 1 ) //'ATENCÃO'###'Para tipos de postos conveniados ou não conveniados deve-se informar o Dia de Faturamento.'
			lReturn := .F.
		EndIf

		If lReturn .And. Empty( oModel:GetValue( 'MNTA611_TQG', 'TQG_DIALIM' ) )
			Help( '', 1, STR0002, , STR0013, 3, 1 ) //'ATENCÃO'###'Para tipos de postos conveniados ou não conveniados deve-se informar o prazo limite de Emissão da Nota Fiscal.'
			lReturn := .F.
		EndIf

	EndIf

Return lReturn

//---------------------------------------------------------------------
/*/{Protheus.doc}  MNT611VALD
Valida a data Negociacao,nao pode ser menor que a ultima
@type function

@author Cristiano Serafim Kair
@since 01/10/2021
@version V12

@return Lógico. True se data está dentro das regras
/*/
//---------------------------------------------------------------------
Function MNT611VALD()

	Local aArea		:= GetArea()
	Local cAliasTQG := GetNextAlias()
	Local lReturn	:= .T.
	Local oModel	:= FWModelActive()
	Local dDtneg	:= DtoS( oModel:GetValue( 'MNTA611_TQG', 'TQG_DTNEG' ) )
	Local dHrneg	:= oModel:GetValue( 'MNTA611_TQG', 'TQG_HRNEG' )

	BeginSql Alias cAliasTQG
		SELECT TQG.TQG_DTNEG, TQG.TQG_HRNEG
			FROM %table:TQG% TQG
		WHERE	TQG.TQG_FILIAL 	= %xFilial:TQG%
			AND	TQG.TQG_CODPOS 	= %exp:TQF->TQF_CODIGO%
			AND TQG.TQG_LOJA 	= %exp:TQF->TQF_LOJA%
			AND TQG.%NotDel%
		ORDER BY TQG.TQG_DTNEG DESC, TQG.TQG_HRNEG DESC
	EndSql

	If dDtneg < ( cAliasTQG )->(TQG_DTNEG) .Or. ( dDtneg == ( cAliasTQG )->(TQG_DTNEG) .And. dHrneg < ( cAliasTQG )->(TQG_HRNEG) )
		Help( '', 1, STR0002, , STR0009, 3, 1 ) //'ATENCÃO'###'Data e Hora da Negociação não pode ser menor que a última Negociação cadastrada.'
		lReturn := .F.
	EndIf

	( cAliasTQG )->( DbCloseArea() )

	RestArea(aArea)

Return lReturn

//---------------------------------------------------------------------
/*/{Protheus.doc}  MNA611CAD
Valida data negociacao nao pode ser menor que a data do
cadastramento do posto e cadastros nao menor que Dt. corrente
@type function

@author Cristiano Serafim Kair
@since 01/10/2021
@version V12

@return Lógico. True se data está dentro das regras
/*/
//---------------------------------------------------------------------
Function MNA611CAD()

	Local oModel  := FWModelActive()
	Local cDtneg  := oModel:GetValue( 'MNTA611_TQG', 'TQG_DTNEG' )
	Local lReturn := .T.

	If cDtneg < TQF->TQF_DTCAD
		Help( '', 1, STR0002, , STR0017, 3, 1 )  //'ATENCÃO'### //'Data da Negociação não pode ser menor que a data de cadastramento do posto.'
		lReturn :=  .F.
	EndIf

	If lReturn .And. cDtneg > dDataBase
		Help( '', 1, STR0002, , STR0018, 3, 1 )  //'ATENCÃO'### //'Data da Negociação não pode ser maior que a data corrente'
		lReturn :=  .F.
	EndIf

Return lReturn

//---------------------------------------------------------------------
/*/{Protheus.doc}  MNA611EXCH
Valida chave na tabela de Negociacao de Preco
@type function

@author Cristiano Serafim Kair
@since 01/10/2021
@version V12

@return Lógico. True se existe chave com os argumentos.
/*/
//---------------------------------------------------------------------
Function MNA611EXCH()
	
	Local oModel := FWModelActive()
	Local dDtneg := oModel:GetValue( 'MNTA611_TQG', 'TQG_DTNEG' )
	Local cHrneg := oModel:GetValue( 'MNTA611_TQG', 'TQG_HRNEG' )

Return EXISTCHAV( 'TQG', TQF->TQF_CODIGO + TQF->TQF_LOJA + DTOS( dDtneg ) + cHrneg )

//---------------------------------------------------------------------
/*/{Protheus.doc}  MNA611VLD
Função acumuladora dos valid da TQG
@type function

@author Cristiano Serafim Kair
@since 01/10/2021
@version V12

@param cCampo, Caracter, campo a ser validado

@return Lógico. True se campos foram validados
/*/
//---------------------------------------------------------------------
Function MNA611VLD( cCampo )

	Local oModel  := FWModelActive()
	Local lReturn := .T.

	Do Case

		Case cCampo == 'TQG_DTNEG'

			lReturn := MNA611CAD() .And. MNA611EXCH()

		Case cCampo == 'TQG_HRNEG'

			lReturn := NGVALHORA( oModel:GetValue( 'MNTA611_TQG', 'TQG_HRNEG' ) ) .And. MNT611VALD() .And. MNA611EXCH()

		Case cCampo == 'TQG_PRAZO'

			lReturn := Positivo( oModel:GetValue( 'MNTA611_TQG', 'TQG_PRAZO' ) )

		Case cCampo == 'TQG_DIAFAT'

			lReturn := Positivo( oModel:GetValue( 'MNTA611_TQG', 'TQG_DIAFAT' ) )

		Case cCampo == 'TQG_DIALIM'

			lReturn := Positivo( oModel:GetValue( 'MNTA611_TQG', 'TQG_DIALIM' ) )

	EndCase

Return lReturn

//---------------------------------------------------------------------
/*/{Protheus.doc}  MNA611RELA
Relação da tabela TQG
@type function

@author Cristiano Serafim Kair
@since 01/10/2021
@version V12

@param cCampo, Caracter, campo a ser validado

@return Indefinido. Valor do Relação do campo em questão.
/*/
//---------------------------------------------------------------------
Function MNA611RELA( cCampo )

	Local xRet

	Do Case

		Case cCampo == 'TQG_CODPOS'

			xRet := TQF->TQF_CODIGO

		Case cCampo == 'TQG_LOJA'

			xRet := TQF->TQF_LOJA

		Case cCampo == 'TQG_DTNEG'

			xRet := dDataBase

		Case cCampo == 'TQG_ORDENA'

			If !IsInCallStack("MNTA656")

                xRet := INVERTE( TQG->TQG_DTNEG )

            Else

                xRet := Space(TAMSX3("TQG_DTNEG")[1])

            EndIf

	EndCase

Return xRet
