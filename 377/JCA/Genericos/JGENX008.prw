#Include 'protheus.ch'
#Include 'parmtype.ch'
#Include "FWBROWSE.CH"
#Include "FWMVCDEF.CH"
#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "Totvs.Ch"


/*
_____________________________________________________________________________
�����������������������������������������������������������������������������                                                     
��+-----------------------------------------------------------------------+��
���Programa  � JGENX008 � Autor � Alexandre Venancio     � Data � 20/08/24���
��+----------+------------------------------------------------------------���
���Descri��o � Rotina para tratar dados de vendas perdidas   		      ���
���          �                                                  		  ���
��+----------+------------------------------------------------------------���
��� Uso      � JCA                                                        ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
	
	//Adicionando op��es
	ADD OPTION aRot TITLE 'Visualizar' 	            ACTION 'VIEWDEF.JGENX008' 								OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Analise' 	            ACTION 'U_xGenx81()' 	        						OPERATION MODEL_OPERATION_INSERT   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Analise Sld Emp/Filial' 	ACTION 'U_JESTC001(ZPC->ZPC_CODIGO,0)'      			OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Hist.Produto Filial' 	ACTION 'Processa({||U_xGenx82()},"Aguarde")' 	        OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Troca Insumo'         	ACTION 'Processa({||U_xGenx84()},"Aguarde")' 	        OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	ADD OPTION aRot TITLE 'Troca Motivo Vd.Perdida' ACTION 'Processa({||U_xGenx85()},"Aguarde")' 	        OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
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

	//Setando as descri��es
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
	
	//Adicionando os campos do cabe�alho e o grid dos filhos
	oView:AddField('VIEW_ZPC',oStruZPC,'ZPCMASTER')
	//oView:AddGrid("VIEW_ZP2", oStruZP2, "ZPCDETAIL")

    //Setando o dimensionamento de tamanho
	oView:CreateHorizontalBox('CABEC',50)
	//oView:CreateHorizontalBox("MEIO", 60)
	
	//Amarrando a view com as box
	oView:SetOwnerView('VIEW_ZPC','CABEC')
	//oView:SetOwnerView("VIEW_ZP2", "MEIO")

	//Habilitando t�tulo
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
aAdd(aPergs ,{1,"Filial At�:"	,padr('zz',TamSx3("ZPC_FILIAL")[1]),"@!",".T.","SM0",".T.",70,.F.})
aAdd(aPergs ,{1,"Emiss�o de"    , cDtDe ,"@!",".T.","",".T.",60,.F.})
aAdd(aPergs ,{1,"Emiss�o At�"   , cDtDe ,"@!",".T.","",".T.",60,.F.})
aAdd(aPergs ,{1,"Produto de"    ,space(TamSx3("ZPC_CODIGO")[1])   ,"@!",".T.","SB1",".T.",80,.F.})
aAdd(aPergs ,{1,"Produto At�"	,padr('zz',TamSx3("ZPC_CODIGO")[1])   ,"@!",".T.","SB1",".T.",80,.F.})
aAdd(aPergs ,{1,"Usu�rio de"    ,space(TamSx3("ZPC_ALMOXA")[1])   ,"@!",".T.","SRA",".T.",80,.F.})
aAdd(aPergs ,{1,"Usu�rio At�"	,padr('zz',TamSx3("ZPC_ALMOXA")[1])   ,"@!",".T.","SRA",".T.",80,.F.})


aAdd(aPergs ,{1,"Frota de"    	,space(TamSx3("ZPC_PREFIX")[1])   ,"@!",".T.","",".T.",80,.F.})
aAdd(aPergs ,{1,"Frota At�"		,padr('zz',TamSx3("ZPC_PREFIX")[1])   ,"@!",".T.","",".T.",80,.F.})

aAdd(aPergs ,{2,"Ve�culo Parado?"	,"", {"1=Sim","2=N�o","3=Ambos"},50,'',.T.})

	
If ParamBox(aPergs ,"Filtrar por",@aRet)
    cFiltro := "ZPC->ZPC_FILIAL >= '"+aRet[1]+"' .AND. ZPC->ZPC_FILIAL<='"+aRet[2]+"'"
    cFiltro += " .AND. ZPC->ZPC_DATA >= '"+DTOS(aRet[3])+"' .AND. ZPC->ZPC_DATA<='"+DTOS(aRet[4])+"'"
    cFiltro += " .AND. ZPC->ZPC_CODIGO >= '"+aRet[5]+"' .AND. ZPC->ZPC_CODIGO<='"+aRet[6]+"'"
    cFiltro += " .AND. ZPC->ZPC_ALMOXA >= '"+aRet[7]+"' .AND. ZPC->ZPC_ALMOXA<='"+aRet[8]+"'"

	cFiltro += " .AND. ZPC->ZPC_PREFIX >= '"+aRet[9]+"' .AND. ZPC->ZPC_PREFIX<='"+aRet[10]+"'"
    
    If aRet[11] <> "3"
        cFiltro += " .AND. ZPC->ZPC_STATUS == '"+aRet[11]+"'"
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

/*/{Protheus.doc} xGenx84
	Troca de insumos
	@type  Static Function
	@author user
	@since 18/09/2024
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
User Function xGenx84()

Local aArea := GetArea()
Local aPergs := {}
Local aRet   := {}
Local cNewPrd:= space(TamSx3("ZPC_CODIGO")[1])
Local cPrdAtu:= ""
Local cDesMtv:= ""
Local cChvSCP:= ZPC->ZPC_FILIAL+ZPC->ZPC_CODIGO+ZPC->ZPC_REQUIS+ZPC->ZPC_ITEM
Local cChvSTL:= ""
Local lOk    := .t.
Local cBkpAtu:= ZPC->ZPC_CODIGO
PRIVATE CCODPAI:= Posicione("SB1",1,xFilial("SB1")+ZPC->ZPC_CODIGO,"B1_XCODPAI")

cPrdAtu := ZPC->ZPC_CODIGO + Alltrim(Posicione("SB1",1,xFilial("SB1")+ZPC->ZPC_CODIGO,"B1_DESC"))

aAdd(aPergs,{9,"Produto Atual = "+cPrdAtu,160,13,.T.})
aAdd(aPergs,{1,"Produto novo"	,  cNewPrd ,"@!","Existcpo('SB1')","SB1ZPC",".T.",90,.T.})

aAdd(aPergs,{11,"Informe o motivo","",".T.",".T.",.T.})
	
If ParamBox(aPergs ,"Op��es por",@aRet)
	cNewPrd := aRet[2]
	cDesMtv := aRet[3]

	DbSelectArea("SB2")
	DbSetOrder(1)
	If Dbseek(ZPC->ZPC_FILIAL+cNewPrd)
		nSaldo := SaldoSB2()
		If ZPC->ZPC_QUANT > nSaldo 
			MsgAlert("Produto sem saldo para atender esta demanda")
			lOk := .F.
		EndIf 
	Else 
		MsgAlert("Produto sem saldo cadastrado")
		lOk := .F.
	EndIf 

	If lOk 
		DbSelectArea("SCP")
		DbSetOrder(2)
		If Dbseek(cChvSCP)
			If SCP->CP_QUJE >= SCP->CP_QUANT
				MsgAlert("Item j� foi atendido na Solicita��o ao Armaz�m")
				lOk := .F.
			Else 
				Reclock("SCP",.F.)
				SCP->CP_PRODUTO := cNewPrd
				SCP->(Msunlock())
			EndIf 

			If lOk 
				cChvSTL := Substr(SCP->CP_OP,1,6)
				DbSelectArea("STL")
				DbSetOrder(1)
				If Dbseek(ZPC->ZPC_FILIAL+cChvSTL)
					While !EOF() .And. STL->TL_FILIAL == ZPC->ZPC_FILIAL .AND. STL->TL_ORDEM == cChvSTL
						If STL->TL_CODIGO == cBkpAtu .And. STL->TL_NUMSA == ZPC->ZPC_REQUIS .And. STL->TL_ITEMSA == ZPC->ZPC_ITEM 
							Reclock("STL",.F.)
							STL->TL_CODIGO := cNewPrd
							STL->(Msunlock())
							exit
						EndIf 
						Dbskip()
					EndDo
				EndIf 
				
				cCntAlt := "Alterado o produto da venda perdida, conteudo anterior - "+cBkpAtu+", conteudo informado - "+cNewPrd+", Motivo da troca - "+alltrim(cDesMtv)
				//xFil		  ,Modulo  ,     TipoMov       ,Prefixo, Docto    ,    cItem     , UserMov , DiaMov  ,      HoraMov     ,Valor,            Obs                              ,cCli     ,cLoja   ,cTabela,nQtdAtu,nVlTotA,nVlAnt,nQtdAnt,nTotAnt
				U_JGENX001(xFilial("SZL"),'Compras','Alt. Venda Perdida','',cvaltochar(ZPC->(Recno())),'',CUSERNAME,ddatabase,cvaltochar(time()),0,cCntAlt,''		  ,''	   ,'ZPC'  ,0      ,0      ,0     ,0      ,0)

				Reclock("ZPC",.F.)
				ZPC->ZPC_TIPO := 'XX'
				ZPC->(Msunlock())
			EndIf 
			//ZPC->ZPC_ITEM
		EndIf 
	EndIf 
EndIf 

RestArea(aArea)

Return

/*/{Protheus.doc} xGenx85
	Troca do motivo de venda perdida
	@type  Static Function
	@author user
	@since 18/09/2024
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
User Function xGenx85()

Local aArea  := GetArea()
Local aPergs := {}
Local aRet   := {}
Local aMotivo:= {}
Local cMotAtu:= ""
Local cMotNew:= ""
Local cDesMtv:= ""
Local cCntAlt:= ""

DbselectArea("ZPV")
DbGotop()
While !EOF()
	Aadd(aMotivo,Alltrim(ZPV->ZPV_CODIGO)+"="+Alltrim(ZPV->ZPV_DESCRI))
	Dbskip()
EndDo 

If !Empty(ZPC->ZPC_TIPO)
	nPosAtu := Ascan(aMotivo,{|x| substr(x,1,len(ZPC->ZPC_TIPO)) == ZPC->ZPC_TIPO})

	cMotAtu := ZPC->ZPC_TIPO + If(nPosAtu>0,substr(aMotivo[nPosAtu],len(ZPC->ZPC_TIPO)+1),"")
EndIf 

aAdd(aPergs,{9,"Conte�do Atual = "+cMotAtu,80,7,.T.})
aAdd(aPergs,{2,"Selecione o novo Motivo?"	,"", aMotivo,80,'',.T.})
aAdd(aPergs,{11,"Informe o motivo","",".T.",".T.",.T.})
	
If ParamBox(aPergs ,"Op��es por",@aRet)
	cMotNew := aRet[2]
	cDesMtv := aRet[3]
	Reclock("ZPC",.F.)
	ZPC->ZPC_TIPO := cMotNew
	ZPC->(Msunlock())
	cCntAlt := "Alterado o motivo da venda perdida, conteudo anterior - "+cMotAtu+", conteudo informado - "+cMotNew+if(ascan(aMotivo,{|x| cmotnew $ x})>0,aMotivo[ascan(aMotivo,{|x| cmotnew $ x})],"")+", Motivo da troca - "+alltrim(cDesMtv)
				//xFil		  ,Modulo  ,     TipoMov       ,Prefixo, Docto    ,    cItem     , UserMov , DiaMov  ,      HoraMov     ,Valor,            Obs                              ,cCli     ,cLoja   ,cTabela,nQtdAtu,nVlTotA,nVlAnt,nQtdAnt,nTotAnt
	U_JGENX001(xFilial("SZL"),'Compras','Alt. Venda Perdida','',cvaltochar(ZPC->(Recno())),'',CUSERNAME,ddatabase,cvaltochar(time()),0    ,cCntAlt,''		  ,''	   ,'ZPC'  ,0      ,0      ,0     ,0      ,0)
EndIf 

RestArea(aArea)

Return

/*/{Protheus.doc} xGenx86
	Gerar solicita��o de compras para os itens
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
		MsgAlert("Solicita��o de compras j� gerada para este item!!!")
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
		MsgAlert("Solicita��o de compras gerada "+SC1->C1_NUM)
		Reclock("ZPC",.F.)
		ZPC->ZPC_SOLICC := SC1->C1_NUM+SC1->C1_ITEM
		ZPC->(Msunlock())
		ConfirmSx8()
	EndIf
Else 

EndIf 

RestArea(aArea)

Return 
