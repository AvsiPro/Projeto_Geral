#include "rwmake.ch"
#include "protheus.ch" 

#define pula	chr(13)+chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT02C  บAutor  ณAlexandre Venancio  บ Data ณ  20/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Geracao da copia de um pv que deu retorno                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTFAT02C(cFil,cNF,cSerie,cCliente,cLoja)
                           
Local aArea			:=	GetArea()                           
Local lRet			:=	.T.
Local lLibEst		:= 	.T.
Local _nQtdLib 		:=	0  
Local nX			:= 	0
Local nQtdAtd		:=	0
Local nItem			:=	1
Local _aCabPV		:= 	{}
Local _aItemPV		:= 	{}
Local cQuery,cQuery2                
Local cTesAux		:= 	""
Local cPvAux		:= 	"" 
Local cNfAux		:= 	""

Local aRotina2  := {{"Incluir","A410Barra",0,3},;							// 
					{"Alterar","A410Barra",0,4}}								// 
Local aRotina3  := {{ OemToAnsi("delete"),"A410Deleta"	,0,5,21,NIL},;
					{ OemToAnsi("Residuo"),"Ma410Resid",0,2,0,NIL}}			//
    
Private lMsErroAuto := 	.F. 
Private lTesxArm	:= 	.T.   
Private cMsgMemo		:= ""
Private cAuxHist		:= ""  

Private aRotina := {	{	OemToAnsi("Pesquisar"),"AxPesqui"		,0,1,0 ,.F.},;		//
							{ OemToAnsi("Visual"),"A410Visual"	,0,2,0 ,NIL},;		//
							{ OemToAnsi("Incluir"),"A410Inclui"	,0,3,0 ,NIL},;		//
							{ OemToAnsi("Alterar"),"A410Altera"	,0,4,20,NIL},;		//
							{ OemToAnsi("Excluir"),IIf((Type("l410Auto") <> "U" .And. l410Auto),"A410Deleta",aRotina3),0,5,0,NIL},; // 
							{ OemToAnsi("Cod.barra"),aRotina2 		,0,3,0 ,NIL},;		//
							{ OemToAnsi("Copia"),"A410PCopia"	,0,6,0 ,NIL},;		//
							{ OemToAnsi("Dev. Compras"),"A410Devol"	,0,3,0 ,NIL},;		//
							{ OemToAnsi("Prep.Doc.Saํda"),"Ma410PvNfs"	,0,2,0 ,NIL},;		//
							{ OemToAnsi("Legenda"),"A410Legend"	,0,3,0 ,.F.},;		//
							{ "Conhecimento"           ,"MsDocument"	,0,4,0 ,NIL} }		//

If cEmpAnt <> "01"
	Return
EndIf

If Select('QUERY') > 0
	dbSelectArea('QUERY')
	dbCloseArea()
EndIf

cQuery := "SELECT D1_DOC,D1_COD,D1_ITEM,D1_NFORI,D1_SERIORI,D1_ITEMORI,D2_PEDIDO,D2_ITEMPV,D2_CLIENTE,D2_LOJA,D2_QUANT,"  
cQuery += " D1_TES,D1_VUNIT,D1_TOTAL,C5_CLIENTE,C5_CLIENT,C5_LOJAENT,C5_LOJACLI,D1_QUANT,D1_LOCAL,C5_TRANSP,C5_XFINAL,"
cQuery += " C5_TABELA,C5_CONDPAG,C5_TIPOCLI,C5_VEND1,C5_VEND3,C5_COMIS1,C5_COMIS3,C5_DESC1,C5_SEGURO,C5_DESPESA,C5_PESOL,"
cQuery += " C5_PBRUTO,C5_VOLUME1,C5_ESPECI1,C5_MENNOTA,C5_CONDPAG,C5_XNFABAS,C5_XCODPA,C5_XCCUSTO,C5_XITEMCC,"
cQuery += " C6_ITEM,C6_PRODUTO,C6_PRUNIT,C6_PRCVEN,C6_VALOR,C6_UM,C6_TES,C6_CF,C6_LOCAL,C6_DESCONT,"
cQuery += " C6_VALDESC,C6_CLI,C6_LOJA,C6_DESCRI,C6_CCUSTO,C6_ITEMCC"
cQuery += " FROM "+RetSQLName("SD1")+" D1"
cQuery += " INNER JOIN "+RetSQLName("SD2")+" D2 on D2_FILIAL=D1_FILIAL and D2_DOC=D1_NFORI and D2_SERIE=D1_SERIE and D2_ITEM=D1_ITEMORI and D2.D_E_L_E_T_<>'*'"
cQuery += " INNER JOIN "+RetSQLName("SC5")+" C5 on C5_FILIAL=D1_FILIAL and C5_NUM=D2_PEDIDO and C5.D_E_L_E_T_<>'*'"
cQuery += " INNER JOIN "+RetSQLName("SC6")+" C6 on C6_FILIAL=D1_FILIAL and C6_NUM=D2_PEDIDO and C6_ITEM=D2_ITEMPV and C6.D_E_L_E_T_<>'*'"
cQuery += " where D1_FILIAL='"+cFil+"' and D1_DOC='"+cNF+"' and D1_SERIE='"+cSerie+"' and D1_FORNECE='"+cCliente+"' and D1_LOJA='"+cLoja+"'"
cQuery += " and D1.D_E_L_E_T_<>'*'"

     
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QUERY', .F., .T.)

DbSelectArea("QUERY")

While !EOF()
    //Gravando o cabecalho do novo pedido de venda somente uma vez, pois a nota fiscal de saida so contem um cliente.
    If len(_aCabPV) == 0
		_cNumPed := GetSX8Num("SC5","C5_NUM")
		cTesAux	:= QUERY->d1_tes
		cAuxPv 	:= QUERY->d2_pedido
		cNfAux	:= QUERY->d1_nfori+QUERY->d1_seriori	

		_aCabPV:=	{{"C5_NUM"    ,_cNumPed    			,Nil},; // Numero do pedido
					 {"C5_TIPO"   ,"N"					,Nil},; // Tipo de pedido
					 {"C5_CLIENTE",QUERY->C5_CLIENTE	,Nil},; // Codigo do cliente
					 {"C5_CLIENT" ,QUERY->C5_CLIENT		,Nil},; // Codigo do cliente
					 {"C5_LOJAENT",QUERY->C5_LOJAENT	,Nil},; // Loja para entrada
					 {"C5_LOJACLI",QUERY->C5_LOJACLI	,Nil},; // Loja do cliente
					 {"C5_EMISSAO",dDatabase			,Nil},; // Data de emissao
					 {"C5_TABELA" ,QUERY->C5_TABELA		,Nil},; // Codigo da Tabela de Preco
					 {"C5_CONDPAG",QUERY->C5_CONDPAG	,Nil},; // Codigo da condicao de pagamanto*
					 {"C5_INCISS" ,"N"         			,Nil},; // ISS Incluso
					 {"C5_TIPLIB" ,"1"         			,Nil},; // Tipo de Liberacao
					 {"C5_LIBEROK","S"         			,Nil},; // Liberacao Total           
					 {"C5_XDTENTR",DDATABASE+1			,Nil},;         
					 {"C5_TRANSP" ,QUERY->C5_TRANSP		,Nil},;
					 {"C5_CONDPAG",QUERY->C5_CONDPAG	,Nil},;
					 {"C5_TIPOCLI",QUERY->C5_TIPOCLI	,Nil},;
					 {"C5_VEND1"  ,QUERY->C5_VEND1		,Nil},;
					 {"C5_FILIAL" ,xFilial("SC5")		,Nil},;
					 {"C5_COMIS1" ,QUERY->C5_COMIS1		,Nil},;
					 {"C5_COMIS3" ,QUERY->C5_COMIS3		,Nil},;
					 {"C5_TPFRET" ,"F" 					,Nil},; 
					 {"C5_SEGURO" ,QUERY->C5_SEGURO		,Nil},;
					 {"C5_DESPESA",QUERY->C5_DESPESA	,Nil},;
					 {"C5_PESOL"  ,QUERY->C5_PESOL		,Nil},;
					 {"C5_PBRUTO" ,QUERY->C5_PBRUTO		,Nil},;
					 {"C5_VOLUME1",QUERY->C5_VOLUME1	,Nil},;
					 {"C5_ESPECI1",QUERY->C5_ESPECI1	,Nil},;
					 {"C5_XNFABAS",QUERY->C5_XNFABAS	,Nil},;
					 {"C5_XCODPA" ,QUERY->C5_XCODPA		,Nil},;
					 {"C5_XFINAL" ,QUERY->C5_XFINAL		,Nil},;
					 {"C5_XCCUSTO",QUERY->C5_XCCUSTO	,Nil},;
					 {"C5_XITEMCC",QUERY->C5_XITEMCC	,Nil},;
					 {"C5_MENNOTA",QUERY->C5_MENNOTA	,Nil}}  

	EndIf
						
   	AAdd(_aItemPV,{{"C6_NUM"	 ,_cNumped        			,Nil},; // Numero do Pedido
					{"C6_ITEM"   ,StrZero(nItem,2)			,Nil},; 	// Numero do Item no Pedido 
 					{"C6_PRODUTO",QUERY->C6_PRODUTO			,Nil},; 	// Codigo do Produto
				   	{"C6_QTDVEN" ,QUERY->D1_QUANT			,Nil},; 	// Quantidade Vendida
					{"C6_QTDLIB" ,_nQtdLib		 			,Nil},; 	// Quantidade Liberada
					{"C6_PRCVEN" ,QUERY->C6_PRCVEN		 	,Nil},; 	// Preco Unitario Liquido
					{"C6_VALOR"  ,round(QUERY->C6_PRCVEN*QUERY->D1_QUANT,2)	 		,Nil},; 	// Valor Total do Item
					{"C6_ENTREG" ,dDataBase+1 				,Nil},; 	// Data da Entrega
					{"C6_UM"     ,QUERY->C6_UM				,Nil},; 	// Unidade de Medida Primar.
					{"C6_TES"    ,QUERY->C6_TES			 	,Nil},; 	// Tipo de Entrada/Saida do Item  // mudar a TES
					{"C6_CF"     ,QUERY->C6_CF 				,Nil},; 	// Codigo Fiscal                  // mudar o CF
					{"C6_LOCAL"  ,QUERY->C6_LOCAL	 		,Nil},; 	// Almoxarifado                   // Local
					{"C6_DESCONT",QUERY->C6_DESCONT			,Nil},; 	// Percentual de Desconto
					{"C6_VALDESC",QUERY->C6_VALDESC			,Nil},; 	// Valor de desconto
					{"C6_CLI"    ,QUERY->C6_CLI				,Nil},; 	// Cliente
					{"C6_LOJA"   ,QUERY->C6_LOJA	  		,Nil},; 	// Loja do Cliente
					{"C6_DESCRI" ,QUERY->C6_DESCRI			,Nil},;    
					{"C6_CCUSTO" ,QUERY->C6_CCUSTO			,Nil},;
					{"C6_ITEMCC" ,QUERY->C6_ITEMCC			,Nil},;
					{"C6_FILIAL" ,xFilial("SC6") 			,Nil}})
				

		//Zerando as variaveis novamente.
		_nQtdLib := 0	
		lLibEst  := .T.	
		nItem++             
	DbSkip()
EndDo
  
//ConfirmSX8()
 
MSExecAuto({|x,y,z|MATA410(x,y,z)},_aCabPv,_aItemPV,3)
// Mostra Erro na geracao de Rotinas automaticas
If lMsErroAuto
	RollBackSx8()
	MostraErro()
Else
	MSGAlert("Pedido de retorno copiado "+_cNumPed,"_GERAPVRET") 
EndIf

If Select('QUERY') > 0
	dbSelectArea('QUERY')
	dbCloseArea()
EndIf
                        
RestArea(aArea)
    
Return(lRet)            