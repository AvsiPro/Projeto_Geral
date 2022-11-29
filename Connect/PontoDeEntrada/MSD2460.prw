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
	Local cTMEst      :=  GetMv("MV_XTESD3",,"501")
	Local _aCab1 := {}
	Local _aItem := {}
	Local _atotitem:={}
	Local n := 0

	Private aEst := {} //estrutura produto
	Private aAuxest := {}
	Private lMsHelpAuto := .t. // se .t. direciona as mensagens de help
	Private lMsErroAuto := .f. //necessario a criacao

	DbSelectArea("SC5")
	DbSetOrder(1)
	Dbseek(xFilial("SC5")+SD2->D2_PEDIDO)

	If SC5->C5_XTPPED == "A" //.AND. SC5->C5_ZZADEST $ cRota


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
	Else
		RestArea(aArea)
		Return(Nil)
	EndIf

	SC5->(DBCloseArea())
	
	MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab1,_atotitem,3)
	//MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab1,_atotitem,3)

	If lMsErroAuto
		Mostraerro()
		DisarmTransaction()
		break
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
