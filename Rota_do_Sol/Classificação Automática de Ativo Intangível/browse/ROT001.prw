#include "totvs.ch"
#include "fwmvcdef.ch"
#Include "TopConn.ch"


#define MVC_MAIN_ID       "ROT001"
#define MVC_MODEL_ID      "mAplic"
#define MVC_VIEW_ID       "vAplic"
#define TITLE_MODEL       "Combinações Contábeis"
#define ALIAS_FORM		  "Z05"

#define ID_MODEL_FORM	  ALIAS_FORM + "FORM"

#define ID_VIEW_FORM		"VIEW_FORM"

#define INCLUSAO 	3
#define ALTERACAO	4
#define EXCLUSAO	5

/*/{Protheus.doc} CombCont
//Tela para cadastro das combinações contábeis
@author Gustavo
@since 10/03/2020
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
user function ROT001()
	

	Local aArea   := GetArea()
	local oBrowse := FwMbrowse():new()

	oBrowse:setAlias(ALIAS_FORM)
	oBrowse:setDescription(TITLE_MODEL)

 	oBrowse:AddLegend( "Z05->Z05_STATUS <> '1'", "RED"  ,  "Combinacao nao Integrada" )
 	oBrowse:AddLegend( "Z05->Z05_STATUS == '1'", "GREEN",  "Combinacao Gerou Finalizada" )

	oBrowse:activate()

	RestArea(aArea)
	
return

/**
* Opções do browse
*/
static function menuDef()

	local aOpcoes := {}
	local cViewId := "viewDef."+MVC_MAIN_ID

	ADD OPTION aOpcoes TITLE "Pesquisar"   ACTION "PesqBrw" OPERATION 1 ACCESS 0
	ADD OPTION aOpcoes TITLE "Visualizar"  ACTION cViewId   OPERATION 2 ACCESS 0
	ADD OPTION aOpcoes TITLE "Incluir"     ACTION cViewId   OPERATION 3 ACCESS 0
	ADD OPTION aOpcoes TITLE "Alterar"     ACTION cViewId   OPERATION 4 ACCESS 0
	ADD OPTION aOpcoes TITLE "Excluir"     ACTION cViewId   OPERATION 5 ACCESS 0
	ADD OPTION aOpcoes TITLE "Integracao"  ACTION "u_ROT002"   OPERATION 6 ACCESS 0

return aOpcoes

/**
* Modelagem
*/
static function modelDef()
	
	local oModel 		:= MpFormModel():new(MVC_MODEL_ID, nil  ,{|oModel|fIsCanSave(oModel) })
	local oStrucForm   	:= FwFormStruct(1, ALIAS_FORM)		

	oModel:addFields(ID_MODEL_FORM, nil, oStrucForm)
	oModel:setPrimaryKey({"Z05_FILIAL","Z05_CBASE"})
	oModel:setDescription(TITLE_MODEL)
	oModel:getModel(ID_MODEL_FORM):setDescription(TITLE_MODEL)	

return oModel

/**
* Interface Visual
*/
static function viewDef()

	local oView  := FwFormView():new()
	local oModel := FwLoadModel(MVC_MAIN_ID)
	local oStructCab 	:= FWFormStruct( 2, ALIAS_FORM)

	oView:setModel(oModel)
	oView:addField(ID_VIEW_FORM, oStructCab, ID_MODEL_FORM)

	//Criando um container com nome tela com 100%
	oView:CreateHorizontalBox('MASTER',100)
	
	//Criando grupos
	oStructCab:AddGroup( 'GRUPO01', 'Código do Bem'				, '',2 )
	oStructCab:AddGroup( 'GRUPO02', 'Investimento'				, '',2 )
	oStructCab:AddGroup( 'GRUPO03', 'informações contábeis ativo'		, '',2 )
	//oStructCab:AddGroup( 'GRUPO04', 'Despesas de Depreciação'	, '',2 )
	
	oStructCab:SetProperty( "Z05_CBASE" , MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
	oStructCab:SetProperty( "Z05_STATUS", MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
	
	oStructCab:SetProperty( "Z05_CCINVE", MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )
	oStructCab:SetProperty( "Z05_ITINVE", MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )
	oStructCab:SetProperty( "Z05_CLINVE", MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )
	oStructCab:SetProperty( "Z05_CTINVE", MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )	//-20230221
	
	oStructCab:SetProperty( "Z05_CCDEPR", MVC_VIEW_GROUP_NUMBER, 'GRUPO03' )//7
	oStructCab:SetProperty( "Z05_ITDEPR", MVC_VIEW_GROUP_NUMBER, 'GRUPO03' )//8
	//oStructCab:SetProperty( "Z05_CLDEPR", MVC_VIEW_GROUP_NUMBER, 'GRUPO03' )
	oStructCab:SetProperty( "Z05_CTDEPR", MVC_VIEW_GROUP_NUMBER, 'GRUPO03' )//9
	
	//oStructCab:SetProperty( "Z05_CCDESP", MVC_VIEW_GROUP_NUMBER, 'GRUPO04' )
	//oStructCab:SetProperty( "Z05_ITDESP", MVC_VIEW_GROUP_NUMBER, 'GRUPO04' )
	//oStructCab:SetProperty( "Z05_CLDESP", MVC_VIEW_GROUP_NUMBER, 'GRUPO04' )
	//oStructCab:SetProperty( "Z05_CTDESP", MVC_VIEW_GROUP_NUMBER, 'GRUPO04' )

	//Colocando título do formulário
	oView:EnableTitleView(ID_VIEW_FORM, 'Cadastro Combinações Contábeis' )

	//O formulário da interface será colocado dentro do container
	oView:SetOwnerView(ID_VIEW_FORM,'MASTER')	

return oView

/**
* Verifica sw pode salvar o modelo INCLUSÃO/EXCLUSÃO
**/
static function fIsCanSave(oModel)

	local lCanSave 			:= .T.
	local oModelZ05			:=	FWModelActive()
	local cCodBemZ05		:= oModelZ05:getValue(ID_MODEL_FORM, "Z05_CBASE")
	local cZ05_STATUS 		:= oModelZ05:getValue(ID_MODEL_FORM, "Z05_STATUS")
	local cCCINVE			:= oModelZ05:getValue(ID_MODEL_FORM, "Z05_CCINVE")
	local cITINVE			:= oModelZ05:getValue(ID_MODEL_FORM, "Z05_ITINVE")
	local cCLINVE			:= oModelZ05:getValue(ID_MODEL_FORM, "Z05_CLINVE")
	local cCTINVE			:= oModelZ05:getValue(ID_MODEL_FORM, "Z05_CTINVE")	//-20230221
	local lExistCombZ05  	:= .F.

	DbSelectArea("Z04")
	DbSetOrder(1)
	If !DbSeek(xFilial("Z04") + cCodBemZ05) .Or. Z04->Z04_BLOQ == 'S'
		lCanSave := .F.
		Help(NIL, NIL, "HELP", NIL, "Registro Bloqueado Para Novas Combinações", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Operacao Bloqueada!"})
	Else	
		If cZ05_STATUS == '1' 
			if oModelZ05:getOperation() == 3 .Or. oModelZ05:getOperation() == 4
				lExistCombZ05	:= fExistCombZ05(oModelZ05:getOperation(),cCodBemZ05, cCCINVE, cITINVE, cCLINVE, cCTINVE)	
				lCanSave := !lExistCombZ05	
			EndIf
		EndIf
	EndIf
return lCanSave

/**
* Verifica se já existe a compinação contábil gravada na Z05
**/
static function fExistCombZ05(nTpOper,cCodBemZ05, cCCINVE, cITINVE, cCLINVE, cCTINVE)	

	local lExisteCombZ05 := .F.
	local cQuery		 := ""
	local cAlias		 := getNextAlias()
	cQuery := "SELECT Z05.Z05_CBASE Z05_CBASE FROM " + retSqlName("Z05") + " Z05" 	+ CRLF
	cQuery += " WHERE 1 = 1 " 													+ CRLF
	cQuery += " AND Z05.Z05_FILIAL ='"+fwxFilial("Z05")+"' " 					+ CRLF
	cQuery += " AND Z05.Z05_CCINVE ='"+cCCINVE+"' " 							+ CRLF
	cQuery += " AND Z05.Z05_ITINVE ='"+cITINVE+"' " 							+ CRLF
	cQuery += " AND Z05.Z05_CLINVE ='"+cCLINVE+"' " 							+ CRLF
	cQuery += " AND Z05.Z05_CTINVE ='"+cCTINVE+"' " 							+ CRLF
	cQuery += " AND Z05.D_E_L_E_T_ =' ' AND Z05.Z05_STATUS = '1' " 				+ CRLF
	TCQUERY cQuery NEW ALIAS (cAlias)
	if (cAlias)->(!eof())
		iF nTpOper == 4 .And. (cAlias)->Z05_CBASE == cCodBemZ05 
			lExisteCombZ05 := .F.
		Else	
			lExisteCombZ05 := .T.
			Help(NIL, NIL, "HELP", NIL, "Código " + allTrim((cAlias)->Z05_CBASE) + " já com as combinações contábeis", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Utilize uma outra combinação."})
		EndIf
	EndIf
	(cAlias)->(dbCloseArea())
return lExisteCombZ05

