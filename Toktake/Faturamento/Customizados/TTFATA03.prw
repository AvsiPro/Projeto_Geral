#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ TTFATA03 ³ Autor ³    TOTVS              ³ Data ³  OUT/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna o ultimo preco de compra.                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Gatilho no C6_PRODUTO                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TTFATA03(cTipo)

Local aArea	 	:= GetArea()
Local aAreaSB1 	:= SB1->(GetArea())
Local cQuery 	:= ""
Local nRet	 	:= 0
Local nLucro 	:= GetMv("MV_XLUCRO")
Local nLucrot 	:= GetMv("MV_XLUCROT") //Item alterado para transferencia em 07/04/2011 conforme OSR.
Local nCustoD	:= 0                         
Local cTipoP	:= ''
Local nCustoM	:= 0
Local ArmPad	:= ""
Local nPosPrc	:= 0
Local nPrcTab	:= 0

//O bloco abaixo foi comentado por mudanca de conceito conforme pedido pelo Sr. Odair no dia 05/01/2010
/*
cQuery := "SELECT B9_FILIAL,B9_COD,B9_LOCAL,B9_DATA,B9_VINI1,B9_QINI "
cQuery += " FROM "+RetSqlName("SB9")+" SB9 "
cQuery += " WHERE B9_FILIAL = '"+xFilial("SB9")+"' "
cQuery += " AND B9_COD = '"+M->C6_PRODUTO+"' "
cQuery += " AND B9_LOCAL = '"+GDFieldGet("C6_LOCAL", n)+"' "
cQuery += " AND B9_DATA = '"+Dtos(GetMv("MV_ULMES"))+"' "
cQuery += " AND SB9.D_E_L_E_T_ <> '*' "

U_MONTAQRY(cQuery,"TRB")

If Select("TRB") > 0

If !Empty(TRB->B9_VINI1)
If SubStr(M->C6_PRODUTO,1,2)$("21/22") .or. M->C5_XFINAL == "3" //Se for produto acabado ou for transferencia
nRet := (TRB->B9_VINI1/TRB->B9_QINI) //Custo Medio
Else
nRet := (TRB->B9_VINI1/TRB->B9_QINI)*nLucro //Custo Medio + Margem
EndIf
Else
Aviso("Verificação Custo","O item informado não tem seu custo calculado.",{"Ok"},,"Atenção:")
EndIf

EndIf
*/
//If cempant <> '11'
	//If cTipo<>"1"
	If !Empty(M->C5_TABELA)
		nPosPrc := Ascan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"}) 
		nPrcTab := aCols[n][nPosPrc]
		nRet := nPrcTab
	Else
		nCustoD := GetAdvFVal("SB1","B1_CUSTD",xFilial("SB1")+M->C6_PRODUTO,1,0)
		ArmPad	:= Posicione("SB1",1,xFilial("SB1")+M->C6_PRODUTO,"B1_LOCPAD")
		cTipoP	:= Posicione("SB1",1,xFilial("SB1")+M->C6_PRODUTO,"B1_XSECAO")
		                   
		If xFilial("SC5") == "01" .OR. Alltrim(cTipoP) $ "005/007"// .And. AllTrim(SC5->C5_XFINAL) == "3"
			If Empty(nCustoD)
				Aviso("Verificação Custo","Este produto não possui custo standard informado. Procure o departamento de custo.",{"Ok"},,"TTFATA03")
				//M->C6_PRODUTO := ""
				GDFieldPut("C6_PRODUTO",CriaVar("C6_PRODUTO",.f.),n)
			Else
				dbSelectArea("SB2")
				dbSetOrder(1)
				If MSSeek( xFilial("SB2") +AvKey(M->C6_PRODUTO,"B1_COD") +Avkey(ArmPad ,"B2_LOCAL") )
					nCustoM := SB2->B2_CM1
				EndIf
				
				If nCustoM > 0
					nRet := nCustoM
				Else
					nRet := nCustoD					
				EndIf
				//If SubStr(M->C6_PRODUTO,1,2)$("21/22") .or. M->C5_XFINAL == "3" //Se for produto acabado ou for transferencia
					//nRet := nCustoD//*nLucrot  //Custo Standar + Margem
				//Else
				//	nRet := nCustoD*nLucro   //Custo Standar + Margem
				//EndIf
			EndIf
		EndIf
	EndIf	
	/*
	Else
		nCustoD := GetAdvFVal("SB1","B1_CUSTD",xFilial("SB1")+M->CK_PRODUTO,1,0)
		
		If Empty(nCustoD)
			Aviso("Verificação Custo","Este produto não possui custo standard informado. Procure o Departamento de custo.",{"Ok"},,"TTFATA03")
			//M->C6_PRODUTO := ""
			GDFieldPut("CK_PRODUTO",CriaVar("CK_PRODUTO",.f.),n)
		Else
			//If SubStr(M->CK_PRODUTO,1,2)$("21/22") .or. M->CJ_XFINAL == "3" //Se for produto acabado ou for transferencia
				nRet := nCustoD//*nLucrot//Custo Standar + Margem
			//Else
			//	nRet := nCustoD*nLucro //Custo Standar + Margem
			//EndIf
		EndIf
		
	End
	*/
//EndIf

RestArea(aAreaSB1)
RestArea(aArea)

Return(nRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ TFAT03a  ³ Autora ³   Cadu               ³ Data ³  Jan/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se dever executar a rotina assima                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Gatilho no C6_PRODUTO campo X7_CONDIC                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TFAT03a(cTipo)

Local lRet := .F.

If cTipo<>"1"
	If (M->C5_XNFABAS == "1" .or. M->C5_XFINAL == "3") .OR. (CEMPANT == "11" .AND. M->C5_XFINAL == "1")
		lRet := .T.
	EndIf
Else
	If M->CJ_XNFABAS == "1" .or. M->CJ_XFINAL == "3"
		lRet := .T.
	EndIf
End

Return(lRet)