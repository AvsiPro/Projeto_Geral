#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT24C  บAutor  ณJackson E. de Deus  บ Data ณ  29/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Inclusao de Orcamento                                      บฑฑ
ฑฑบ          ณ Abastecimento                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTFAT24C(cNumOS,cPatrim,cCodCli,cLoja,axItens,lReproc)

Local cCondPg		:= "020"	// condicao pagamento
Local cTransp		:= "000019"	// transportadora
Local cVend			:= "000001"	// vendedor
Local aCab			:= {}
Local aItens		:= {}
Local nOpcAuto		:= 3		// inclusao
Local cNumOrc		:= ""
Local cItem			:= "00"
Local cLocal		:= ""
Local cProduto		:= ""            
Local cDescProd		:= ""
Local nPrcPP		:= 0
Local nQuant		:= 0
Local nPreco		:= 0
Local cObsItem		:= ""
Local dDtFim		:= stod("")
Local nI			:= 0
Local nJ			:= 0
Local lBlqA1		:= .F.
Local aProdBlq		:= {}
Local nRecA1		:= 0
Local cTabela		:= If(cEmpAnt=="01",AllTrim(Posicione("SN1",2,xFilial("SN1")+AvKey(cPatrim,"N1_CHAPA"),"N1_XTABELA")),"")
Private lMsErroAuto	:= .F.

Default cCodCli		:= ""
Default cLoja		:= ""  
Default cPatrim		:= ""
Default axItens		:= {}
Default lReproc		:= .F.


If cEmpAnt <> "01"
	Return
EndIF

// reprocessamento - altera
If lReproc
	nOpcAuto := 4
EndIf

dbSelectArea("SZG")
dbSetOrder(1)
If dbSeek( xFilial("SZG") +AvKey(cNumOS,"ZG_NUMOS") )
	dDtFim := SZG->ZG_DATAFIM
EndIf


dbSelectArea("SA1")
dbSetOrder(1)
If dbSeek( xFilial("SA1") +AvKey(cCodCli,"A1_COD") +AvKey(cLoja,"A1_LOJA") )
	If AllTrim(SA1->A1_MSBLQL) == "1"
		If RecLock("SA1",.F.)
			SA1->A1_MSBLQL := "2"
			lBlqA1 := .T.
			nRecA1 := SA1->(Recno())
			SA1->(MsUnLock())
		EndIf
	EndIf
EndIf

// inclusao
If nOpcAuto == 3
	cNumOrc := GetSx8Num("SCJ","CJ_NUM")
// alteracao
ElseIf nOpcAuto == 4
	dbSelectArea("SCJ")
	dbSetOrder(6)
	If !dbSeek( xFilial("SCJ") +AvKey(cNumOS,"CJ_XNUMOS") ) 
		nOpcAuto := 3
		cNumOrc := GetSx8Num("SCJ","CJ_NUM")		
	Else
		cNumOrc := SCJ->CJ_NUM
	EndIf
EndIf	


	
// montar cabecalho
aCab := {{"CJ_FILIAL"		,xFilial("SCJ")	,Nil},;
			{"CJ_NUM"		,cNumOrc	,Nil},;
			{"CJ_CLIENTE"	,cCodCli	,Nil},;
			{"CJ_LOJA"		,cLoja		,Nil},;
			{"CJ_CLIENT"	,cCodCli	,Nil},;
			{"CJ_LOJAENT"	,cLoja		,Nil},;
			{"CJ_TABELA"	,cTabela	,Nil},;
			{"CJ_CONDPAG"	,cCondPg	,Nil},;
			{"CJ_TRANSP"	,cTransp	,Nil},;
			{"CJ_VEND1"		,cVend		,Nil},;
			{"CJ_EMISSAO"	,dDtFim		,Nil},; 
			{"CJ_VALIDA"	,dDtFim		,Nil},;	// ? 
			{"CJ_STATUS"	,"A"		,Nil},;
			{"CJ_TIPLIB"	,"1"		,Nil},;
			{"CJ_TPCARGA"	,"1"		,Nil},;
			{"CJ_TXMOEDA"	,1			,Nil},;
			{"CJ_USERORC"	,cUserName	,Nil},;
			{"CJ_DTINC"		,Date()		,Nil},;
			{"CJ_HRINC"		,Time()		,Nil},;
			{"CJ_XNUMOS"	,cNumOS		,Nil},;
			{"CJ_XPATRIM"	,cPatrim	,Nil}}
	        
/*
axItens - estrutura
produto
qtd
preco
obs item
*/
For nI := 1  To Len(axItens)	              
	cItem := Soma1(cItem)		// tem que ser com soma1 pois ao chegar ao 100, utiliza-se letras
	cProduto := axItens[nI][1]
	cDescProd := AllTrim( Posicione("SB1",1,xFilial("SB1")+AvKey(cProduto,"B1_COD"),"B1_DESC" ) )
	nQuant := axItens[nI][2]
	nPreco := Round(axItens[nI][3],2)
	cObsItem := axItens[nI][4]
	cLocal := axItens[nI][5]
	nPrcPP := axItens[nI][6]
		
	dbSelectArea("SB1")
	dbSetOrder(1)
	If dbSeek( xFilial("SB1") +AvKey( cProduto,"B1_COD") )
		If AllTrim(SB1->B1_MSBLQL) == "1"
			RecLock("SB1",.F.)
			SB1->B1_MSBLQL := "2"
			SB1->(MsUnLock()) 
			AADD( aProdBlq, SB1->(Recno()) )
		EndIf
	EndIf
	
	AADD( aItens,{{"CK_FILIAL"	,xFilial("SCJ")					,Nil},;
					{"CK_NUM"		,cNumOrc					,Nil},;
					{"CK_CLIENTE"	,cCodCli					,Nil},;
					{"CK_LOJA"		,cLoja						,Nil},;
					{"CK_ITEM"		,cItem						,Nil},;
					{"CK_PRODUTO"	,cProduto					,Nil},;
					{"CK_DESCRI"	,cDescProd					,Nil},;		
					{"CK_LOCAL"		,cLocal						,Nil},;
					{"CK_QTDVEN"	,nQuant						,Nil},;
					{"CK_PRCVEN"	,nPreco						,Nil},;
					{"CK_PRUNIT"	,nPreco						,Nil},;
					{"CK_VALOR"		,Round( nQuant*nPreco,2 )	,Nil},;
					{"CK_OBS"		,cObsItem					,Nil},; 
					{"CK_XPRCPP"	,nPrcPP						,Nil}} )
							
Next nI
	

//MSExecAuto( { |x,y,z| MATA415(x,y,z) },aCab,aItens,nOpcAuto )
lMsErroAuto := .T.
If !lMsErroAuto
	If nOpcAuto == 3
		ConfirmSx8()
		CONOUT( "#TTFAT24C -> ORCAMENTO GERADO: " +cNumOrc +" - REF OS: " +cNumOS )
	ElseIf nOpcAuto == 4
		CONOUT( "#TTFAT24C -> ORCAMENTO ALTERADO: " +cNumOrc +" - REF OS: " +cNumOS )	
	EndIf
Else
	If nOpcAuto == 3
		dbSelectArea("SCJ")
		dbSetOrder(1)
		If !dbSeek( xFilial("SCJ") +AvKey(cNumOrc,"CJ_NUM") )
			GrvOrc(cNumOrc,aCab,aItens)
			ConfirmSx8()
		Else
			ConfirmSx8()
			CONOUT( "#TTFAT24C -> ORCAMENTO GERADO: " +cNumOrc +" - REF OS: " +cNumOS )
		EndIf
	ElseIf nOpcAuto == 4
		GrvOrc(cNumOrc,aCab,aItens,.T.)
	EndIf	
EndIf

// tratamento cliente bloqueado
If lBlqA1 .And. nRecA1 > 0
	dbSelectArea("SA1")
	dbgoTo(nRecA1)
	If Recno() == nRecA1
		If RecLock("SA1",.F.)
			SA1->A1_MSBLQL := "1"
		EndIf
	EndIf
EndIf

// tratamento produto bloqueado
dbSelectArea("SB1")
For nI := 1 To Len(aProdBlq)
	dbGoTo(aProdBlq[nI])
	If Recno() == aProdBlq[nI]
		RecLock("SB1",.F.)
		SB1->B1_MSBLQL := "1"
		SB1->(MsUnLock()) 
	EndIf
Next nI

Return cNumOrc
      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT24C  บAutor  ณMicrosiga           บ Data ณ  07/21/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GrvOrc(cNumOrc,aCab,aItens,lAltera)

Local nI,nJ
Default lAltera := .F.

// inclusao
If !lAltera
	Begin Transaction
		dbSelectArea("SCK")
		For nI := 1 To Len(aItens)
			If RecLock("SCK",.T.)
				For nJ := 1 To Len(aItens[nI])
					FieldPut(FieldPOs(aItens[nI][nJ][1]),aItens[nI][nJ][2])
				Next nJ
				SCK->(MsUnLock())
			EndIf	
		Next nI            
		
		dbSelectArea("SCJ")
		If RecLock("SCJ",.T.)
			For nI := 1 To Len(aCab)
				FieldPut(FieldPOs(aCab[nI][1]),aCab[nI][2])
			Next nI
			SCJ->(MsUnLock())
		EndIf	
	End Transaction
// Alteracao
Else 
	Begin Transaction
		dbSelectArea("SCK")
		dbSetOrder(1)
		If dbSeek( xFilial("SCK") +AvKey(cNumOrc,"CK_NUM") )
			// TERMINAR
			While SCK->CK_FILIAL == xFilial("SCK") .And. SCK->CK_NUM == cNumOrc .And. !EOF()
				SCK->(RecLock("SCK",.F.))
				SCK->(dbDelete())
				SCK->(MSUNLOCK())
				SCK->(dbSkip())
			End
			For nI := 1 To Len(aItens)
				If RecLock("SCK",.T.)
					For nJ := 1 To Len(aItens[nI])
						FieldPut(FieldPOs(aItens[nI][nJ][1]),aItens[nI][nJ][2])
					Next nJ
					SCK->(MsUnLock())
				EndIf	
			Next nI            
			
			dbSelectArea("SCJ")
			dbSetOrder(1)
			If dbSeek( xFilial("SCJ") +AvKey(cNumOrc,"CJ_NUM")  )
				RecLock("SCJ",.F.)
				For nI := 1 To Len(aCab)
					FieldPut(FieldPOs(aCab[nI][1]),aCab[nI][2])
				Next nI
				SCJ->(MsUnLock())
			EndIf	
		EndIf 		
	End Transaction
EndIf

Return