#include 'protheus.ch'
#include 'parmtype.ch'
#include 'FwMvcDef.ch'
#INCLUDE 'FWBROWSE.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MVC001   ºAutor  ³Rodrigo Barreto   º Data ³  20/01/2023  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Menu DEF para conferência dos títulos de folha             º±±
±±º          ³										                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RobSol                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function MVC001()
	Local aArea := GetArea()
	Private oBrowse := FwMBrowse():New()

	oBrowse:SetAlias("ZZ1")
	oBrowse:SetDescription  ("Folha de Pagamento")

	// legendas
	oBrowse:AddLegend("ZZ1->ZZ1_DTPAG == ctod('  /  /   ') .AND. ZZ1->ZZ1_NUMBOR == '      ' ","GREEN", "Pendente") //verde
	oBrowse:AddLegend("ZZ1->ZZ1_DTPAG == ctod('  /  /   ') .AND. ZZ1->ZZ1_NUMBOR != '      ' ","YELLOW", "Bordero") //amarelo
	oBrowse:AddLegend("ZZ1->ZZ1_DTPAG == ctod('01/01/1990')","Black", "Erro no pag") //pretol
	oBrowse:AddLegend("ZZ1->ZZ1_DTPAG != ctod('  /  /   ') .AND. ZZ1->ZZ1_DTPAG != ctod('01/01/1990') ","RED", "Pago") //vermelho

	oBrowse:Activate()

	//oBrowse:Refresh(.t.)

	RestArea(aArea)
return Nil

// Construção da MenuDef
Static Function MenuDef()
	Local aRotina := {}

	Add OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MVC001'  		OPERATION 2 ACCESS 0
	Add OPTION aRotina TITLE 'Incluir' ACTION 'VIEWDEF.MVC001' 	   		OPERATION 3 ACCESS 0
	Add OPTION aRotina TITLE 'Alterar' ACTION 'VIEWDEF.MVC001'     		OPERATION 4 ACCESS 0
	Add OPTION aRotina TITLE 'Excluir' 	ACTION 'VIEWDEF.MVC001'     	OPERATION 5 ACCESS 0
	Add OPTION aRotina TITLE 'Importação' ACTION 'u_ImpFol()'     		OPERATION 6 ACCESS 0
	Add OPTION aRotina TITLE 'Excluir em lote' 	ACTION 'U_EXCFOL()'     	OPERATION 7 ACCESS 0
	ADD OPTION aRotina TITLE "Legenda" ACTION "U_LEGEN()" 					OPERATION 8 ACCESS 0

Return aRotina
// Criando a Model DEF

Static Function ModelDef()
	Local oModel := Nil
	Local oStZZ1 := FWFormStruct(1,"ZZ1")

	//Instanciando o modelo de dados
	oModel := MPFormModel():New("ZMODELLM", , , ,)
	//Atribuindo formulario para o modelo de dados.
	oModel:AddFields("FORMZZ1",,oStZZ1)
	//chave primaria da rotina
	oModel:SetPrimaryKey({'ZZ1_FILIAL','ZZ1_COD'})

	// Adicionando descricao ao modelo de dados.
	oModel:SetDescription("Título de folha")

	oModel:GetModel("FORMZZ1"):SetDescription("Formulário de cadastro")

Return oModel

//ViewDEf
Static Function ViewDef()
	local oView := Nil
	Local oModel := FWLoadModel("MVC001")
	Local oStZZ1 := FwFormStruct(2,"ZZ1")

	oView := FWFormView():New() //construindo o modelo de dados

	oView:SetModel(oModel) //Passando o modelo de dados informado

	oView:AddField("VIEW_ZZ1", oStZZ1, "FORMZZ1")

	oView:CreateHorizontalBox("TELA",100) //Criando um container com o identificador TELA

	oView:EnableTitleView("VIEW_ZZ1",'Dados View') //Adicionando titulo ao formulário

	oView:SetCloseOnOk({||.T.}) //força o fechamento da janela

	oView:SetOwnerView("VIEW_ZZ1","TELA") //adicionando o formulário da inerface ao container

	//retornando o objeto view
Return oView

User Function INFMVC()

	Local cMsg := "Finalizado"

	MsgInfo(cMsg)

Return

User Function LEGEN()
     
    Local aLegenda := {}
    aAdd( aLegenda, { "BR_VERDE"      ,     "Pendente" })
    aAdd( aLegenda, { "BR_AMARELO" ,      "Em Borderô" })
    aAdd( aLegenda, { "BR_VERMELHO"      ,      "Pago" })
	aAdd( aLegenda, { "BR_PRETO"      ,      "Erro no pagamento" })

     BrwLegenda( "Cnab folha", "Legenda", aLegenda )

Return Nil






