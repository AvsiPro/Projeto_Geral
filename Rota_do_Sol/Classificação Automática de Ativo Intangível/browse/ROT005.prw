#include "totvs.ch"
#include "fwmvcdef.ch"
#Include "TopConn.ch"


/*/{Protheus.doc} CombCont
//Tela para cadastro das combinações contábeis
@author Gustavo
@since 10/03/2020
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
user function ROT005()
	
	Local aArea   := GetArea()
	local oBrowse := FwMbrowse():new()

	oBrowse:setAlias("Z04")
	oBrowse:setDescription("Ativo Construção")

	oBrowse:activate()

	RestArea(aArea)
	
return

/**
* Opções do browse
*/
static function menuDef()

	local aOpcoes := {}
	local cViewId := "viewDef.ROT005"

	ADD OPTION aOpcoes TITLE "Pesquisar"   ACTION "PesqBrw" OPERATION 1 ACCESS 0
	ADD OPTION aOpcoes TITLE "Visualizar"  ACTION cViewId   OPERATION 2 ACCESS 0
	ADD OPTION aOpcoes TITLE "Incluir"     ACTION cViewId   OPERATION 3 ACCESS 0
	ADD OPTION aOpcoes TITLE "Alterar"     ACTION cViewId   OPERATION 4 ACCESS 0
	ADD OPTION aOpcoes TITLE "Excluir"     ACTION cViewId   OPERATION 5 ACCESS 0

return aOpcoes

/**
* Modelagem
*/
static function modelDef()
	
	local oModel 		:= MpFormModel():new("zMRet005", nil  ,{|oModel|fIsCanSave(oModel) })
	
	local oStrucForm   	:= FwFormStruct(1, "Z04")		

	oModel:addFields("Z04MASTER", nil, oStrucForm)
	oModel:setPrimaryKey({"Z04_FILIAL","Z04_CBASE"})
	oModel:setDescription("Ativo Construção")
	oModel:getModel("Z04MASTER"):setDescription("Ativo Construção")	

return oModel

/**
* Interface Visual
*/
static function viewDef()

	local oView  := FwFormView():new()
	local oModel := FwLoadModel("ROT005")
	local oStructCab 	:= FWFormStruct( 2, "Z04")

	oView:setModel(oModel)
	oView:addField("VIEW_FORM", oStructCab, "Z04MASTER")

	//Criando um container com nome tela com 100%
	oView:CreateHorizontalBox('MASTER',100)
	
	//Criando grupos
	//oStructCab:AddGroup( 'GRUPO01', 'Código do Bem'				, '',2 )
	//oStructCab:AddGroup( 'GRUPO02', 'Investimento'				, '',2 )
	//oStructCab:AddGroup( 'GRUPO03', 'Depreciação Acumulada'		, '',2 )
	//oStructCab:AddGroup( 'GRUPO04', 'Despesas de Depreciação'	, '',2 )
	
	//oStructCab:SetProperty( "Z04_CBASE" , MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
	//oStructCab:SetProperty( "Z04_ITEM"  , MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
	//oStructCab:SetProperty( "Z04_STATUS", MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
	
	//oStructCab:SetProperty( "Z04_CCINVE", MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )
	//oStructCab:SetProperty( "Z04_ITINVE", MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )
	//oStructCab:SetProperty( "Z04_CLINVE", MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )
	//oStructCab:SetProperty( "Z04_CTINVE", MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )	//-20230221
	
	//oStructCab:SetProperty( "Z04_CCDEPR", MVC_VIEW_GROUP_NUMBER, 'GRUPO03' )
	//oStructCab:SetProperty( "Z04_ITDEPR", MVC_VIEW_GROUP_NUMBER, 'GRUPO03' )
	//oStructCab:SetProperty( "Z04_CLDEPR", MVC_VIEW_GROUP_NUMBER, 'GRUPO03' )
	
	//oStructCab:SetProperty( "Z04_CCDESP", MVC_VIEW_GROUP_NUMBER, 'GRUPO04' )
	//oStructCab:SetProperty( "Z04_ITDESP", MVC_VIEW_GROUP_NUMBER, 'GRUPO04' )
	//oStructCab:SetProperty( "Z04_CLDESP", MVC_VIEW_GROUP_NUMBER, 'GRUPO04' )

	//Colocando título do formulário
	oView:EnableTitleView("VIEW_FORM", 'Cadastro Combinações Contábeis' )

	//O formulário da interface será colocado dentro do container
	oView:SetOwnerView("VIEW_FORM",'MASTER')	

return oView

/**
* Verifica sw pode salvar o modelo INCLUSÃO/EXCLUSÃO
**/
static function fIsCanSave(oModel)
	local lCanSave 			:= .T.
	local oModelZ04			:=	FWModelActive()
	local cCodBemZ04		:= oModelZ04:getValue("Z04MASTER", "Z04_CBASE")

	DbSelectArea("Z05")
	DbSetOrder(1)
	iF DbSeek(xFilial("Z05") + cCodBemZ04)
		lCanSave := .F.
		Help(NIL, NIL, "HELP", NIL, "Integracao ja realizada Com as combinações contábeis", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Utilize uma outra combinação."})
	EndIf
return lCanSave
