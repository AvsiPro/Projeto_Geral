#include "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OM010TOK  ºAutor  ³Microsiga           º Data ³  04/22/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  PE utilizado para validar se em uma alteracao de tabela deº±±
±±º          ³vendas, algum patrimonio nao ficara sem referencia de valor.º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function OM010TOK()

Local aArea		:=	GetArea()
Local lRet		:=	.T. 
Local cQuery	:=	""  
Local aProds	:= {}
Local nX            
//Local nPosPRod  := Ascan(aHeader,{|x|AllTrim(x[2])=="DA1_CODPRO"})  //Alterado para a V12, pois esta tela mudou para MVC
Local nPos		:= 0
Local cProdP	:= ""
Local oModel 	:= PARAMIXB[1] 
Local oGridTab 	:= oModel:GetModel("DA1DETAIL")


// Tratamento para AMC
If cEmpAnt == "10"
	Return lRet
EndIf


If cEmpAnt == "01"
    //Nova validação do ponto de entrada para a V12 - Tela de Tabela de Preços virou MVC
	For nLin := 1 To Len(oGridTab:ADATAMODEL) 
	
		oGridTab:GoLine(nLin)
	
		If !oGridTab:IsDeleted() //.And. AllTrim(oGridTab:GetValue("DA1_CODPRO")) == "01"
			If Ascan( aProds, { |x| x == oGridTab:GetValue("DA1_CODPRO") } ) == 0
				Aadd( aProds, oGridTab:GetValue("DA1_CODPRO") )
			Else
				MsgAlert("Não é permitido produtos repetidos! Verifique.","OM010TOK")
				RestArea(aArea)
				Return .F.
			EndIf
		EndIf 
	Next nLin
	

	// validar produtos duplicados -> tive que fazer isso porque o pessoal nao consegue dar manutencao correta nesses cadastros
	/*For nX := 1 To Len(aCols)
		If aCols[nX][Len(aHeader)+1]
			Loop
		EndIf
		
		If Ascan( aProds, { |x| x == aCols[nX][nPosPRod] } ) == 0
			AADD( aProds, aCols[nX][nPosPRod]  )               
		Else
			MsgAlert("Não é permitido produtos repetidos! Verifique.","OM010TOK")
			RestArea(aArea)
			Return .F.
		EndIf
	Next nX */
	
	/*
	// validar alteracao -> algum patrimonio nao ficara sem referencia de valor
	cQuery := "SELECT N1_CHAPA"   
	For nX := 1 to 16
		cQuery += " ,N1_XP"+cvaltochar(nX)+" AS N"+cvaltochar(nx)
	Next nX
	cQuery += " FROM "+RetSQLName("SN1")+" N1"
	
	cQuery += " INNER JOIN " +RetSqlName("SB1") +" B1 ON "	// pegar somente maquinas de bebidas
	cQuery += " B1_COD = N1_PRODUTO AND B1.D_E_L_E_T_ = '' AND B1_XFAMILI IN ('144','153') "
		
	cQuery += " WHERE N1.D_E_L_E_T_='' AND N1_XTABELA='"+oGridTab:GetValue("DA1_CODTAB")+"' "
		
	If Select("TRB") > 0
		dbSelectArea("TRB")
		dbCloseArea()
	EndIf
	  
	cQuery:= ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
	
	DbSelectArea("TRB") 
	
	While !EOF()
	    For nX := 1 to 16
	    	cProdP := &("TRB->N"+cvaltochar(nX))
	    	cProdP := AllTrim(StrTran(cPRodP,CHR(9),""))	// AJUSTE EFETUADO PARA TRATAR O TAB
	    	If !Empty(cProdP)  
	    		//AllTrim(oGridTab:GetValue("DA1_CODPRO")) == "01"
	    		nPos := ASCAN( aCols,{|x| alltrim(x[2]) == cProdP .And. !x[Len(aHeader)+1] })
	    		
	    		If nPos == 0
		    		MsgAlert("O produto "+cProdP +" consta no Patrimônio "+TRB->N1_CHAPA+" amarrado a esta tabela e o mesmo não consta na tabela, favor verificar!!!","OM010TOK")
		    		RestArea(aArea)
		    		Return(.F.)	
		    	Else
		    		If aCols[ASCAN(ACOLS,{|X| alltrim(X[2]) == cProdP }),Len(aHeader)+1]
		    			MsgAlert("O Produto "+cProdP +" não poderá ser deletado da tabela pois consta referência a ele no Patrimônio "+AllTrim(TRB->N1_CHAPA)+", favor verificar!!!","OM010TOK")
		    			RestArea(aArea)
		    			Return(.F.)
		    		EndIf
		    	EndIf
	    	EndIf
	    Next nX
		DbSkip()
	EndDo */
EndIf

RestArea(aArea)

Return(lRet)