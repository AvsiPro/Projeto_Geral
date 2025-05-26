#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'TOTVS.CH'

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} 
			Cadastro de Rotinas
@author  	Wagner Mobile
@version 	P12
@since   	22/01/2021
@Parametros:
/*/
//-----------------------------------------------------------------------------
User Function TINCA003()
	Local oBrowse
	Local aArea	:= GetArea()
	
	DbSelectArea("PGJ")

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('PGJ')
	oBrowse:SetDescription("Cadastro de Rotinas")
	oBrowse:DisableDetails()
	oBrowse:Activate()

	RestArea(aArea)

Return NIL

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} 
			Define as operacoes da aplicacao
@author  	Wagner Mobile
@version 	P12
@since   	22/01/2021
@Parametros:
/*/
//-----------------------------------------------------------------------------
Static Function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina TITLE "Pesquisar" 	ACTION "PesqBrw"            OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar"	ACTION "VIEWDEF.TINCA003" 	OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"      ACTION "VIEWDEF.TINCA003" 	OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"      ACTION "VIEWDEF.TINCA003"	OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"      ACTION "VIEWDEF.TINCA003"	OPERATION 5 ACCESS 0

Return aRotina

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} 
			Contem a Construcao e Definicao do Modelo          
@author  	Wagner Mobile
@version 	P12
@since   	22/01/2021
@Parametros:
/*/
//-----------------------------------------------------------------------------
Static Function ModelDef()
	Local oStruPGJ := FWFormStruct( 1, 'PGJ' )

    // Cria o objeto do Modelo de Dados
	Local oModel   := MPFormModel():New('TINCM003',,{ |oModel| TINCA03POS(oModel)},,)
	
	
	// Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:AddFields( 'PGJMASTER', /*cOwner*/, oStruPGJ, /*bPreValidacao*/, , /*bCarga*/ )
	
	//Adiciona Descricao
	oModel:SetDescription("Cadastro de Rotinas")
	
	//Ordem
	oModel:SetPrimaryKey( {} )

	oModel:GetModel('PGJMASTER'):SetDescription("Rotina")
Return oModel




//-----------------------------------------------------------------------------
/*/ {Protheus.doc} 
			Construcao da View
@author  	Wagner Mobile   
@version 	P12
@since   	22/01/2021
@Parametros:
/*/
//-----------------------------------------------------------------------------
Static Function ViewDef()

// Cria Objeto
	Local oModel  := FWLoadModel("TINCA003")

// Cria estrutura
	Local oStruct := FWFormStruct(2, 'PGJ')
	
//Interface       
	Local oView

//Cria Objeto de View
	oView := FWFormView():New()

//Define Qual Modelo
	oView:SetModel(oModel)

	oView:AddField('VIEW_PGJ', oStruct, 'PGJMASTER')
	oView:CreateHorizontalBox( 'TELA' , 100 )


Return oView


//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Validacao

@author Wagner Mobile
@version P12
@since   22/01/2021
@param oModel
/*/
//-----------------------------------------------------------------------------
Static Function TINCA03POS(oModel)

	Local nOperation  := 0
	Local aArea		  := GetArea()
	Local cPGJ_CODROT := oModel:GetModel('PGJMASTER'):GetValue('PGJ_CODROT')
	Local cPGJ_FUNLOG := oModel:GetModel('PGJMASTER'):GetValue('PGJ_FUNLOG')
	Local cPGJ_FUNPRO := oModel:GetModel('PGJMASTER'):GetValue('PGJ_FUNPRO')
	Local lRet		  := .T.

	If oModel == Nil	//-- É realizada chamada com modelo nulo para verificar se a função existe
		Return .F.
	EndIf

	nOperation := oModel:GetOperation()

	If nOperation == MODEL_OPERATION_DELETE
		BeginSQL Alias "QRY"
			SELECT 1 AS QUANTOS
			  FROM %table:PGH% PGH
			 WHERE PGH.PGH_FILIAL = %exp:xFilial('PGH')% AND PGH_CODROT = %exp:cPGJ_CODROT% AND PGH.%notDel%
		EndSql
		QRY->(DbGoTop())
    
		If QRY->QUANTOS > 0
			Help(,, "TINCA03POS",, "Registro em uso em processos de incorporação. Não pode ser excluido !", 1, 0)
			lRet := .F.
		EndIf
		QRY->(dbCloseArea())
	ELSE
		IF ALLTRIM(cPGJ_FUNLOG) == ALLTRIM(cPGJ_FUNPRO)
			Help(,, "TINCA03POS",, "Nome das rotinas não podem ser iguais !", 1, 0)
			lRet := .F.
		ENDIF
	EndIf

	RestArea(aArea)

Return lRet

//-----------------------------------------------------------------------------
/*/ {Protheus.doc} Function
Validacao existencia função no repositorio

@author Wagner Mobile
@version P12
@since   25/01/2021
@param   cRotina
@return  lRet
/*/
//-----------------------------------------------------------------------------
User Function TINCA03F(cRotina)

Local lRet := .T.

If ! FindFunction(cRotina)
	Help(,, "TINCA03FUN",, "Rotina [" + cRotina + "] não encontrada no repositorio", 1, 0)
	lRet := .F.
EndIF

Return lRet
