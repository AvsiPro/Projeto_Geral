#INCLUDE 'PROTHEUS.CH'
#Include 'TopConn.ch'
#include 'tbiconn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MSD2460   ºAutor  ³Microsiga           º Data ³  31/10/2022  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE utilizado para movimentar o armazem movel ao faturar    º±±
±±º          ³nf de abastecimento PA	                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CONNECT                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MSD2460()

	Local aArea			:=	GetArea()
	Local cTM			:=	GetMv("MV_XTMSD3",,"001")
	Local cTMEst      	:=  GetMv("MV_XTESD3",,"501")
	Local _aCab1 		:= 	{}
	Local _aItem 		:= 	{}
	Local _atotitem		:=	{}
	Local n := 0

	Private aEst 		:= {} //estrutura produto
	Private aAuxest 	:= {}
	Private lMsHelpAuto := .t. // se .t. direciona as mensagens de help
	Private lMsErroAuto := .f. //necessario a criacao

	DbSelectArea("SC5")
	DbSetOrder(1)
	Dbseek(xFilial("SC5")+SD2->D2_PEDIDO)

	If SC5->C5_XTPPED == "A" 


		_aCab1 := {{"D3_DOC" ,SD2->D2_DOC, NIL},;
					{"D3_TM" ,cTM , NIL},;
					{"D3_CC" ,"        ", NIL},;
					{"D3_EMISSAO" ,ddatabase, NIL}}

		_aItem:={{"D3_COD" ,SD2->D2_COD ,NIL},;
				{"D3_UM" ,SD2->D2_UM ,NIL},;
				{"D3_QUANT" , SD2->D2_QUANT ,NIL},;
				{"D3_LOCAL" ,SC5->C5_XCODPA ,NIL},;
				{"D3_LOTECTL" ,"",NIL},;
				{"D3_LOCALIZ" , "",NIL}}

			aadd(_atotitem,_aitem)

	//Faturamento de doses movimenta a SD3 pelos itens da estrutura
	ElseIf SC5->C5_XTPPED == "F"
		
		U_BusSG1(SD2->D2_COD,SD2->D2_QUANT)
		
		_aCab1 := {{"D3_DOC" ,SD2->D2_DOC, NIL},;
					{"D3_TM" ,cTMEst , NIL},;
					{"D3_CC" ,"        ", NIL},;
					{"D3_EMISSAO" ,ddatabase, NIL}}


		For n := 1 to len(aAuxEst)

			_aItem:={{"D3_COD" ,aAuxEst[n][2][1] ,NIL},;
					{"D3_UM" ,SB1->B1_UM ,NIL},;
					{"D3_QUANT" , aAuxEst[n][3][1] ,NIL},;
					{"D3_LOCAL" ,SC5->C5_XCODPA ,NIL},;
					{"D3_LOTECTL" ,"",NIL},;
					{"D3_LOCALIZ" , "",NIL}}

			aadd(_atotitem,_aitem)
		Next
	//Faturamento de pedidos de remessa de maquina
	ElseIf SC5->C5_XTPPED == "I"
		atucontr(SC6->C6_CONTRT,SC6->C6_PRODUTO,SC6->C6_NUMSERI)
	Else
		RestArea(aArea)
		Return
	EndIf

	SC5->(DBCloseArea())
	
	If len(_aCab1) > 0 .And. Len(_atotitem) > 0
		MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab1,_atotitem,3)
		
		If lMsErroAuto
			Mostraerro()
			DisarmTransaction()
			break
		EndIf
	EndIf 

	RestArea(aArea)

Return

//Busca os insumos e as quantidade na estrutura do produto 
User function BusSG1(cCodProd,cQtd)

	Local cQuer := ""

	//G1_FILIAL+G1_COD+G1_COMP+G1_TRT
	cQuer := " SELECT G1_COD,G1_COMP,G1_QUANT FROM "+RetSqlName('SG1')+" G1 "
	cQuer += " Where G1.D_E_L_E_T_='' AND G1_COD = '"+ alltrim(cCodProd) +"' "

	TcQuery cQuer New Alias "TMP"
	TMP->(DbGoTop())

	While TMP->(!Eof())

		aEst := {{TMP->G1_COD},;
				{TMP->G1_COMP},;
				{TMP->G1_QUANT * CqTD}}
		//quantidade do item multiplicar pela quantidade da estrutura

		aadd(aAuxest,aEst)

		TMP->(DbSkip())
	EndDo

	TMP->(DbCloseArea())

Return(aAuxest)

/*/{Protheus.doc} atucontr
	(long_description)
	@type  Static Function
	@author user
	@since 05/12/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function atucontr(cContr,cProd,cAtivo)

Local aArea :=	GetArea()
Local cProx :=	""
Local cQuery 

cQuery := "SELECT CONVERT(VARCHAR,MAX(AAN_ITEM)+1) AS NEWITM"
cQuery += " FROM "+RetSQLName("AAN")
cQuery += " WHERE AAN_FILIAL='"+xFilial("AAN")+"'"
cQuery += " AND AAN_CONTRT='"+cContr+"' AND D_E_L_E_T_=' '"

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("MSD2460.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")   

cProx := STRZERO(VAL(TRB->NEWITM),2)

cQuery := "SELECT COUNT(*) AS QTD" 
cQuery += " FROM "+RetSQLName("AAN")
cQuery += " WHERE AAN_FILIAL='"+xFilial("AAN")+"'"
cQuery += " AND AAN_CONTRT='"+cContr+"' AND D_E_L_E_T_=' '"
cQuery += " AND AAN_CODPRO='"+cProd+"' AND AAN_XCBASE='"+cAtivo+"'"

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("MSD2460.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")

If TRB->QTD == 0
	DbSelectArea("AAN")
	Reclock("AAN",.T.)
	AAN->AAN_FILIAL := xFilial("AAN")
	AAN->AAN_CONTRT := cContr
	AAN->AAN_ITEM	:= cProx
	AAN->AAN_CODPRO	:= cProd 
	AAN->AAN_QUANT	:= 1
	AAN->AAN_VLRUNI	:= 0.01
	AAN->AAN_VALOR	:= 0.01
	AAN->AAN_CONPAG	:= '001'
	AAN->AAN_DATA 	:= DDATABASE
	AAN->AAN_INICOB	:= DDATABASE+1
	AAN->AAN_FIMCOB	:= CTOD('31/12/2030')
	AAN->AAN_XCBASE	:= cAtivo 
	AAN->(MsUnlock())

	DbSelectArea("SC6")
	RecLock("SC6", .F.)
	SC6->C6_ITCONTR := cProx
	SC6->(MsUnlock())
EndIf 

RestArea(aArea)

Return
