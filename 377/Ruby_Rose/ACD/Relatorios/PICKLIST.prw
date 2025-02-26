#Include 'Protheus.ch'

User Function PICKLIST()

Local cPerg 	:= 'PICKLI'

ValidPerg(cPerg)
If !(Pergunte(cPerg,.T.))
	Return
Endif

if !Empty(mv_par01)
	//U_PL0001(mv_par01)  // Pick-List por OP
	MsgAlert("Para Desenvolver", "Analista")
else
	U_PL0002(mv_par02)  // Pick-List por Pedido de Venda
endif

Return

/*/
******************************************************************************************************************
******************************************************************************************************************
&& Funcao: ValidPerg(cPerg)
&& Descricao: Verifica a existencia do grupo de perguntas, caso nao exista cria.
******************************************************************************************************************
******************************************************************************************************************
/*/
Static Function ValidPerg(cPerg)

	Local sAlias := Alias()
	Local aRegs := {}
	Local i,j

	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))

	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs, {cPerg, "01", "Ordem Produção :","","","mv_ch1", "C", 11, 0, 0, "G", "", "mv_par01",  "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","","","",""}) //SC2ACD
	aAdd(aRegs, {cPerg, "02", "Pedido de Venda:","","","mv_ch1", "C", 06, 0, 0, "G", "", "mv_par02",  "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","","","",""})

	For i:=1 to Len(aRegs)
		If !dbSeek (cPerg + aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next
	dbSelectArea(sAlias)
Return
