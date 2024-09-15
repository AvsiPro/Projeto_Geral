#Include 'protheus.ch'
#Include 'parmtype.ch'
#Include "FWBROWSE.CH"
#Include "FWMVCDEF.CH"
#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "Totvs.Ch"


/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦                                                     
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ JGENX008 ¦ Autor ¦ Alexandre Venancio     ¦ Data ¦ 20/08/24¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descrição ¦ Rotina para tratar dados de vendas perdidas   		      ¦¦¦
¦¦¦          ¦                                                  		  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ JCA                                                        ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/

User Function JGENX008()

	Local aArea   := GetArea()
	Local cTitulo := "Vendas perdidas "
	Private oBrowse
    
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("ZPC")
	oBrowse:SetDescription(cTitulo)
    //oBrowse:SetFilterDefault("ZPC_SEQ == '001'")
    
	oBrowse:Activate()
	
	RestArea(aArea)
Return Nil

/*
    Menudef
*/
Static Function MenuDef()

	Local aRot := {}
	
	//Adicionando opções
	ADD OPTION aRot TITLE 'Visualizar' 	            ACTION 'VIEWDEF.JGENX008' 	OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Analise' 	            ACTION 'U_xGenx81()' 	        OPERATION MODEL_OPERATION_INSERT   ACCESS 0 //OPERATION 1

    ADD OPTION aRot TITLE 'Analise Sld Emp/Filial' 	ACTION 'U_JESTC001(ZPC->ZPC_CODIGO,4)' 	        OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Hist.Produto Filial' 	ACTION 'U_xGenx82()' 	        OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Troca Insumo'         	ACTION 'U_xGenx84()' 	        OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	ADD OPTION aRot TITLE 'Troca Motivo Vnd.Perdida' ACTION 'U_xGenx85()' 	        OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Gera Solic. Compra' 	    ACTION 'Processa({||U_xGenx86()},"Aguarde")' 	        OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1

Return aRot

/*
    ModelDef
*/
Static Function ModelDef()

	Local oModel 		:= Nil
	Local oStruZPC 		:= FWFormStruct(1, 'ZPC')
	//Local oStruZP2 		:= FWFormStruct(1, 'ZPC')
    
	//Criando o modelo e os relacionamentos
	oModel := MPFormModel():New('zMVCMd3M',,/*{||U_XXX()}*/)
	oModel:AddFields('ZPCMASTER',,oStruZPC)
    //oModel:AddGrid("ZPCDETAIL", "ZPCMASTER", oStruZP2)

    oModel:SetPrimaryKey({'ZPC_FILIAL','ZPC_CODIGO','ZPC_ITEM'})
	
	//oModel:SetRelation("ZPCDETAIL", {{"ZPC_FILIAL", "FwXFilial('ZPC')"}, {"ZPC_REQUIS", "ZPC_REQUIS"}, {"ZPC_ITEM", "ZPC_ITEM"}}, ZPC->(IndexKey(1)))

	//Setando as descrições
	oModel:SetDescription("Vendas Perdidas")
	oModel:GetModel('ZPCMASTER'):SetDescription('Processos')
    //oModel:GetModel("ZPCDETAIL"):SetDescription("Itens")
    
    

Return oModel

/*
    ViewDef
*/
Static Function ViewDef()
	Local oView		:= Nil
	Local oModel		:= FWLoadModel('JGENX008')
	Local oStruZPC		:= FWFormStruct(2, 'ZPC')
	//Local oStruZP2		:= FWFormStruct(2, 'ZPC')
    

	//oStruZP2:RemoveField("ZPC_FILIAL")
	//Criando a View
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	//Adicionando os campos do cabeçalho e o grid dos filhos
	oView:AddField('VIEW_ZPC',oStruZPC,'ZPCMASTER')
	//oView:AddGrid("VIEW_ZP2", oStruZP2, "ZPCDETAIL")

    //Setando o dimensionamento de tamanho
	oView:CreateHorizontalBox('CABEC',50)
	//oView:CreateHorizontalBox("MEIO", 60)
	
	//Amarrando a view com as box
	oView:SetOwnerView('VIEW_ZPC','CABEC')
	//oView:SetOwnerView("VIEW_ZP2", "MEIO")

	//Habilitando título
	oView:EnableTitleView('VIEW_ZPC','Processos')
	//oView:EnableTitleView("VIEW_ZP2", "REGRAS", RGB(224, 30, 43))

    //oView:CreateHorizontalBox('INFERIOR',50)
	//oView:CreateFolder('ABAS','INFERIOR')
	
    oView:SetCloseOnOk({||.T.})

    

Return oView


/*/{Protheus.doc} xGenx81
Filtro do browse para analisar vendas perdidas 
@type user function
@author user
@since 01/09/2024
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function xGenx81()

Local aPergs  := {}
Local aRet    := {}
Local cFiltro := ""
Local cDtDe   := CTOD(' / / ')

aAdd(aPergs ,{1,"Filial de:"	,space(TamSx3("ZPC_FILIAL")[1]),"@!",".T.","SM0",".T.",70,.F.})
aAdd(aPergs ,{1,"Filial Até:"	,padr('zz',TamSx3("ZPC_FILIAL")[1]),"@!",".T.","SM0",".T.",70,.F.})
aAdd(aPergs ,{1,"Emissão de"    , cDtDe ,"@!",".T.","",".T.",60,.F.})
aAdd(aPergs ,{1,"Emissão Até"   , cDtDe ,"@!",".T.","",".T.",60,.F.})
aAdd(aPergs ,{1,"Produto de"    ,space(TamSx3("ZPC_CODIGO")[1])   ,"@!",".T.","SB1",".T.",80,.F.})
aAdd(aPergs ,{1,"Produto Até"	,padr('zz',TamSx3("ZPC_CODIGO")[1])   ,"@!",".T.","SB1",".T.",80,.F.})
aAdd(aPergs ,{1,"Usuário de"    ,space(TamSx3("ZPC_ALMOXA")[1])   ,"@!",".T.","SRA",".T.",80,.F.})
aAdd(aPergs ,{1,"Usuário Até"	,padr('zz',TamSx3("ZPC_ALMOXA")[1])   ,"@!",".T.","SRA",".T.",80,.F.})
aAdd(aPergs ,{2,"Veículo Parado?"	,"", {"1=Sim","2=Não","3=Ambos"},50,'',.T.})

	
If ParamBox(aPergs ,"Filtrar por",@aRet)
    cFiltro := "ZPC->ZPC_FILIAL >= '"+aRet[1]+"' .AND. ZPC->ZPC_FILIAL<='"+aRet[2]+"'"
    cFiltro += " .AND. ZPC->ZPC_DATA >= '"+DTOS(aRet[3])+"' .AND. ZPC->ZPC_DATA<='"+DTOS(aRet[4])+"'"
    cFiltro += " .AND. ZPC->ZPC_CODIGO >= '"+aRet[5]+"' .AND. ZPC->ZPC_CODIGO<='"+aRet[6]+"'"
    cFiltro += " .AND. ZPC->ZPC_ALMOXA >= '"+aRet[7]+"' .AND. ZPC->ZPC_ALMOXA<='"+aRet[8]+"'"
    
    If aRet[9] <> "3"
        cFiltro += " .AND. ZPC->ZPC_STATUS == '"+aRet[9]+"'"
    EndIf 

    oBrowse:SetFilterDefault(cFiltro)
EndIF 

Return 

/*/{Protheus.doc} xGenx82
Historico do produto
@type user function
@author user
@since 14/09/2024
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function xGenx82()

Local aArea := GetArea()

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1")+ZPC->ZPC_CODIGO)

//MATC050()
Processa({|| MC050Con()},"Aguarde")

RestArea(aArea)

Return

/*/{Protheus.doc} xGenx86
	Gerar solicitação de compras para os itens
	@type  Static Function
	@author user
	@since 15/09/2024
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
User Function xGenx86()

Local aArea := GetArea()
Private lMsErroAuto := .F.
Private aCabecalho := {}

If MsgYesNo("Gerar somente para o item selecionado?")
	If !Empty(ZPC->ZPC_SOLICC)
		MsgAlert("Solicitação de compras já gerada para este item!!!")
		Return 
	EndIf 
	
	lMsErroAuto	:=	.f.
	aCabecalho	:=	{}

	DbSelectArea("SB1")
	DbSetOrder(1)
	DbSeek(xFilial("SB1")+ZPC->ZPC_CODIGO)

	DbSelectArea("SCP")
	DbSetOrder(1)
	Dbseek(ZPC->ZPC_FILIAL+ZPC->ZPC_CODIGO+ZPC->ZPC_REQUIS)
	
	aCabecalho	:={	{ "C1_FILIAL"	, xFilial("SC1")	, NIL},;
					{ "C1_SOLICIT"	, UsrRetName(RetCodUsr())	, NIL},;
					{ "C1_EMISSAO"	, dDatabase	, NIL},;
					{ "C1_CCAPROC"	, '2'		, NIL},;
					{ "C1_GERACTR"	, '2'		, NIL},;
					{ "C1_TIPOEMP"	, '1'		, NIL},;
					{ "C1_ESPEMP"	, '1'		, NIL},;
					{ "C1_XTIPCOT"	, '3'		, NIL}}
	
	aItens		:=	{}				
	aAdd(aItens,	{	{"C1_ITEM"		, "0001"			  			, NIL},;
						{"C1_PRODUTO"	, ZPC->ZPC_CODIGO				, NIL},;
						{"C1_LOCAL"		, SB1->B1_LOCPAD				, NIL},;
						{"C1_DESCRI"	, SB1->B1_DESC					, NIL},;
						{"C1_QUANT"		, ZPC->ZPC_QUANT				, NIL},;
						{"C1_CC"		, SCP->CP_CC					, NIL},;
						{"C1_DATPRF"	, ddatabase+5					, NIL},;
						{"C1_CONTA"		, SCP->CP_CONTA					, NIL},;
						{ "C1_XTIPCOT"	, '3'							, NIL}})
						
	
	MSExecAuto({|X,Y,Z| Mata110(X,Y,Z)}, aCabecalho, aItens, 3) //insere a SC no novo numero
	
	If lMsErroAuto
		MsgStop("Problemas na execucao da Rotina Automatica MATA110 [INCLUSAO].")
		MostraErro()
		//DisarmTransaction()
		lRetorno	:=	.f.
	Else
		MsgAlert("Solicitação de compras gerada "+SC1->C1_NUM)
		Reclock("ZPC",.F.)
		ZPC->ZPC_SOLICC := SC1->C1_NUM+SC1->C1_ITEM
		ZPC->(Msunlock())
		ConfirmSx8()
	EndIf
Else 

EndIf 

RestArea(aArea)

Return 
