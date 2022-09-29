#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TTESTA01 บAutor  ณLuciano R. Santiago บ Data ณ  08/25/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cadastro de armazens                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TokTake                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TTESTA01()

If cEmpAnt <> "01"
	Return
EndIf

AxCadastro("ZZ1","Cadastro de Locais de Estoque/Armaz้ns - Tok Take",,"U_TTESTAOK()")
/*adiciona chamada no aRotina
 aadd(aRotAdic,{ "Adicional","U_Adic", 0 , 6 })
 
AxCadastro("SA1", "Clientes", "U_DelOk()", "U_COK()", aRotAdic, bPre, bOK, bTTS, bNoTTS, , , aButtons, , ) */

Return(Nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTESTA01  บAutor  ณAlexandre Venancio  บ Data ณ  04/04/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao para nao permitir nomes de PAs iguais.           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTESTAOK()

Local lRet	:=	.T. 
Local cQuery 
Local lAlt	:=	.F.
Local cCampo

cQuery := "SELECT ZZ1_COD,ZZ1_DESCRI FROM "+RetSQLName("ZZ1")
cQuery += " WHERE ZZ1_FILIAL='"+xFilial("ZZ1")+"' AND D_E_L_E_T_=''"
cQuery += " AND ZZ1_DESCRI='"+M->ZZ1_DESCRI+"'"
cQuery += " AND ZZ1_MSBLQL<>'1' AND ZZ1_COD<>'"+M->ZZ1_COD+"'"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("TTESTA01.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
	MsgAlert("Esta descri็ใo jแ esta sendo utilizada na PA "+TRB->ZZ1_COD+" - "+TRB->ZZ1_DESCRI,"TTESTA01")
	lRet	:= .F.
	DbSkip()
EndDo         

If Altera
	dbSelectArea("SX3")
	SX3->(DbSetOrder(1))
	DbSeek("ZZ1")
	While !eof() .AND. SX3->X3_ARQUIVO == "ZZ1"
			cCampo := alltrim(SX3->X3_CAMPO) 
			IF Alltrim(M->&(cCampo)) != Alltrim(ZZ1->&(cCampo))
            	lAlt := .T.
			ENDIF
		SX3->(dbskip())
	EndDo         
	
	If !Alltrim(cusername) $ Alltrim(Getmv("MV_XTPA01")) .AND. Alltrim(cusername) != "TORCIOLI"
		If lAlt
			M->ZZ1_MSBLQL := "1" 
		EndIf
	Else 
		M->ZZ1_MSBLQL := "2" 	
	EndIf
EndIf


// criar o armazem na nova tabela NNR
If lRet
	dbSelectArea("NNR")
	dbSetOrder(1)
	If !MSSeek( xFilial("NNR") +AvKey(M->ZZ1_COD,"NNR_CODIGO") )
		RecLock("NNR",.T.)
		NNR->NNR_FILIAL := xFilial("NNR")
		NNR->NNR_CODIGO := M->ZZ1_COD
		NNR->NNR_DESCRI := M->ZZ1_DESCRI
		MsUnLock()
	EndIf
EndIf


Return(lRet)