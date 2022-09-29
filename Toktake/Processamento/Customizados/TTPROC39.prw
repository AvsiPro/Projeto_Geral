#INCLUDE 'PROTHEUS.CH'

Static _cZLacre := "1"
Static _cZBanan := "2"
Static _cZGleen := "3"
Static _cZPOS	:= "4"
Static _cZSmart := "5"	// smart/caneta
Static _cZChave := "6"
Static _cZMoe	:= "7"
Static _cZCed	:= "8"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC39   บAutor  ณJackson E. de Deusบ  Data ณ  21/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณInclusao/alteracao de sistema de pagamento                  บฑฑ
ฑฑบ				Utilizar via StaticCall									  บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณJackson       ณ21/11/14ณ01.00 |Criacao                                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function TTPROC39(nOpcao,aDados)

Local lRet := .T.
          
If cEmpAnt <> "01"
	return
EndIF
                   
If nOpcao == 1
	tratarSP(aDados)	
ElseIf nOpcao == 2
	lRet := tratarSP2(aDados)
EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณtratarSP  บAutor  ณMicrosiga           บ Data ณ  11/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Tratamento para inclusao de sistema de pagamento no      บฑฑ
ฑฑบ          ณchamado tecnico.                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function tratarSP(aDados,cNumChapa)

Local aArea	:=	GetArea()
Local cPatr	:=	''//aDados[9,2]
Local aAuxDados := aClone(aDados)
Local cSisPg := ""

Default cNumChapa := ''

If !Empty(cNumChapa)
	cPatr := cNumChapa
Else
	aDados[9,2]
EndIf

aDados := {}
For nI := 1 To Len(aAuxDados)
	If aAuxDados[nI][1] $ "NSERIE_POS|NSERIE_CED|LACRE_CED|NSERIE_MOED|LACRE_MOED|GLEENVIEW|NSERIE_SMART"
		AADD( aDados, aAuxDados[nI] )
	EndIf
Next nI


dbSelectArea("SN1")
dbSetOrder(2)
dbSeek( xFilial("SN1") +AvKey(cPatr,"N1_CHAPA") )
cSisPg := SN1->N1_XSISPG

If Empty(cSisPg)
	cSisPg := "CE=0|MC=0|MS=0|VR=0|SM=0|PO=0|CI=0"
EndIf

For nX := 1 to len(aDados)
	// POS NSERIE
	If aDados[nX,1] == "NSERIE_POS" .And. !Empty(aDados[nX,02]) //"POS"
		dbSelectArea("ZZN")
		dbSetOrdeR(1)	// IDPDV
		If dbseek(xFilial("ZZN")+aDados[nX,02])
			If Empty(ZZN->ZZN_PATRIM)
				Reclock("ZZN",.F.)
				ZZN->ZZN_CLIENT	:=	SN1->N1_XCLIENT
				ZZN->ZZN_LOJA	:=	SN1->N1_XLOJA
				ZZN->ZZN_LOCALZ	:=	'1'
				ZZN->ZZN_PATRIM	:=	cPatr
				ZZN->(Msunlock())
				
				// ZZO - POS
				cQuery := "SELECT R_E_C_N_O_ AS REG FROM "+RetSQLName("ZZO")+" WHERE ZZO_LACRE='"+aDados[nX,02]+"' AND ZZO_TIPO='"+_cZPOS+"' AND ZZO_DATUTI='' AND D_E_L_E_T_=''"

				If Select("TRB") > 0
					dbSelectArea("TRB")
					DbCloseArea()
				EndIf
				
				MemoWrite("TTPROC26.SQL",cQuery)
				dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
				dbSelectArea("TRB")
		        
				If !Empty(TRB->REG)
					DbSelectArea("ZZO")
					Dbgoto(TRB->REG)
					Reclock("ZZO",.F.)
					ZZO->ZZO_DATUTI := ddatabase
					ZZO->ZZO_PATRIM := cPatr
					ZZO->(Msunlock())
				EndIf
				
				cSisPg := StrTran(cSisPg,"PO=0","PO=1")
			Else
				// tratamento - erro na inclusao - chamar programa -> envio email
				U_TTMAILN("microsiga","jdeus@toktake.com.br","ERRO POS","POS ja atrelado em outro patrimonio: " +ZZN->ZZN_PATRIM,{},.F.)
			EndIf	
		EndIf 
		
	// CEDULA NSERIE
	ElseIf aDados[nX,1] == "NSERIE_CED" /*"CEDULA"*/ .And. !Empty(aDados[nX,02])
		cQuery := "SELECT R_E_C_N_O_ AS REG FROM "+RetSQLName("ZZO")+" WHERE ZZO_LACRE='"+aDados[nX,02]+"' AND ZZO_TIPO='"+_cZCed+"' AND ZZO_DATUTI='' AND D_E_L_E_T_=''"

		If Select("TRB") > 0
			dbSelectArea("TRB")
			DbCloseArea()
		EndIf
		
		MemoWrite("TTPROC26.SQL",cQuery)
		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
		dbSelectArea("TRB")
        
		If !Empty(TRB->REG)
			DbSelectArea("ZZO")
			Dbgoto(TRB->REG)
			Reclock("ZZO",.F.)
			ZZO->ZZO_DATUTI := ddatabase
			ZZO->ZZO_PATRIM := cPatr
			ZZO->(Msunlock())
		EndIf
		cSisPg := StrTran(cSisPg,"CE=0","CE=1")	  
	// LACRE DO CEDULEIRO
	ElseIf aDados[nX,1] == "LACRE_CED" .And. !Empty(aDados[nX,02])
		cQuery := "SELECT R_E_C_N_O_ AS REG FROM "+RetSQLName("ZZO")+" WHERE ZZO_LACRE='"+aDados[nX,02]+"' AND ZZO_TIPO='"+_cZLacre+"' AND ZZO_DATUTI='' AND D_E_L_E_T_=''"
	
		If Select("TRB") > 0
			dbSelectArea("TRB")
			DbCloseArea()
		EndIf
		
		MemoWrite("TTPROC26.SQL",cQuery)
		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
		dbSelectArea("TRB")
        
		If !Empty(TRB->REG)
			DbSelectArea("ZZO")
			Dbgoto(TRB->REG)
			Reclock("ZZO",.F.)
			ZZO->ZZO_DATUTI := ddatabase
			ZZO->ZZO_PATRIM := cPatr
			ZZO->(Msunlock())
		EndIf
		CONOUT("LACRE CEDULA")
		
	// MOEDEIRO NSERIE
	ElseIf aDados[nX,1] == "NSERIE_MOED" /*"MOEDEIRO"*/ .And. !Empty(aDados[nX,02])
		cQuery := "SELECT R_E_C_N_O_ AS REG FROM "+RetSQLName("ZZO")+" WHERE ZZO_LACRE='"+aDados[nX,02]+"' AND ZZO_TIPO='"+_cZMoe+"' AND ZZO_DATUTI='' AND D_E_L_E_T_=''"

		If Select("TRB") > 0
			dbSelectArea("TRB")
			DbCloseArea()
		EndIf
		
		MemoWrite("TTPROC26.SQL",cQuery)
		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
		dbSelectArea("TRB")
        
		If !Empty(TRB->REG)
			DbSelectArea("ZZO")
			Dbgoto(TRB->REG)
			Reclock("ZZO",.F.)
			ZZO->ZZO_DATUTI := ddatabase
			ZZO->ZZO_PATRIM := cPatr
			ZZO->(Msunlock())
		EndIf
		If AllTrim(SZG->ZG_OBS) == "TROCO_MOEDEIRO|SIM"
			cSisPg := StrTran(cSisPg,"MC=0","MC=1")
		ElseIf AllTrim(SZG->ZG_OBS) == "TROCO_MOEDEIRO|NAO"
			cSisPg := StrTran(cSisPg,"MS=0","MS=1")           
		EndIf
	// LACRE DO MOEDEIRO
	ElseIf aDados[nX,1] == "LACRE_MOED" /*"LACRE_MOED"*/ .And. !Empty(aDados[nX,02])
		cQuery := "SELECT R_E_C_N_O_ AS REG FROM "+RetSQLName("ZZO")+" WHERE ZZO_LACRE='"+aDados[nX,02]+"' AND ZZO_TIPO='"+_cZLacre+"' AND ZZO_DATUTI='' AND D_E_L_E_T_=''"

		If Select("TRB") > 0
			dbSelectArea("TRB")
			DbCloseArea()
		EndIf
		
		MemoWrite("TTPROC26.SQL",cQuery)
		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
		dbSelectArea("TRB")
        
		If !Empty(TRB->REG)
			DbSelectArea("ZZO")
			Dbgoto(TRB->REG)
			Reclock("ZZO",.F.)
			ZZO->ZZO_DATUTI := ddatabase
			ZZO->ZZO_PATRIM := cPatr
			ZZO->(Msunlock())
		EndIf
		CONOUT("LACRE MOEDEIRO")
		
	// LACRE GLEENVIEW
	ElseIf aDados[nX,1] == "GLEENVIEW" /*"GLEENVIEW"*/ .And. !Empty(aDados[nX,02])
		cQuery := "SELECT R_E_C_N_O_ AS REG FROM "+RetSQLName("ZZO")+" WHERE ZZO_LACRE='"+aDados[nX,02]+"' AND ZZO_TIPO='"+_cZGleen+"' AND ZZO_DATUTI='' AND D_E_L_E_T_=''"

		If Select("TRB") > 0
			dbSelectArea("TRB")
			DbCloseArea()
		EndIf
		
		MemoWrite("TTPROC26.SQL",cQuery)
		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
		dbSelectArea("TRB")
        
		If !Empty(TRB->REG)
			DbSelectArea("ZZO")
			Dbgoto(TRB->REG)
			Reclock("ZZO",.F.)
			ZZO->ZZO_DATUTI := ddatabase
			ZZO->ZZO_PATRIM := cPatr
			ZZO->(Msunlock())
		EndIf
	
		CONOUT("GLEENVIEW")		
		
		
	// SMART NSERIE
	ElseIf aDados[nX,1] == "NSERIE_SMART" /*"SMART"*/ .And. !Empty(aDados[nX,02])
		cQuery := "SELECT R_E_C_N_O_ AS REG FROM "+RetSQLName("ZZO")+" WHERE ZZO_LACRE='"+aDados[nX,02]+"' AND ZZO_TIPO='"+_cZSmart+"' AND ZZO_DATUTI='' AND D_E_L_E_T_=''"

		If Select("TRB") > 0
			dbSelectArea("TRB")
			DbCloseArea()
		EndIf
		
		MemoWrite("TTPROC26.SQL",cQuery)
		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
		dbSelectArea("TRB")
        
		If !Empty(TRB->REG)
			DbSelectArea("ZZO")
			Dbgoto(TRB->REG)
			Reclock("ZZO",.F.)
			ZZO->ZZO_DATUTI := ddatabase
			ZZO->ZZO_PATRIM := cPatr
			ZZO->(Msunlock())
		EndIf
		cSisPg := StrTran(cSisPg,"SM=0","SM=1")
	EndIf	
Next nX
                 
dbSelectArea("SN1")
If AllTrim(cSisPg) <> AllTrim(SN1->N1_XSISPG)
	If RecLock("SN1",.F.) 
		SN1->N1_XSISPG := cSisPg
		SN1->(MSUNLOCK())
	EndIf
EndIf

RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณtratSP2  บAutor  ณJackson E. de Deus   บ Data ณ  21/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTratamento para alteracao do sistema de pagamento           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function tratSP2(aDados,cNumChapa,cMsgErro)

Local lRet := .F.
Local nI,nJ,nX     
Local LEITURA := 2
Local SANGRIA := 3
Local aAux := {}
Local aAux2 := {} 
Local aSZN := {}
Local cPatr	:= cNumChapa
Local cPosAnt := ""
Local cPosAtu := ""
Local cCedAnt := ""
Local cCedAtu := ""
Local cMoedAnt := ""
Local cMoedAtu := ""
Local cLacMdAnt := ""
Local cLacMdAtu := ""
Local cLacCdAnt := ""
Local cLacCdAtu := ""
Local cSmtAnt := ""
Local cSmtAtu := ""
Local cLGleeAnt := ""
Local cLGleeAtu := ""

Local aIniSZN := {}


AADD( aIniSZN, { "NUMEROOS", aDados[1][2] } )	// NUMEROOS
AADD( aIniSZN, { "AGENTE", aDados[2][2] } )		// AGENTE
AADD( aIniSZN, { "CLIENTE", aDados[3][2] } )	// CLIENTE
AADD( aIniSZN, { "LOJA", aDados[4][2] } )		// LOJA
AADD( aIniSZN, { "DATA", aDados[5][2] } )		// DATA
AADD( aIniSZN, { "HORA", aDados[6][2] } )		// HORA

For nI := 1 To Len(aDados)
	If aDados[nI][1] $ "POS|PLACA_ANTERIOR|PLACA_ATUAL|MOEDEIRO|CEDULA|SMART|GLEENVIEW"
		AADD( aAux2, aDados[nI] )
	EndIf	
Next nI

// tratamento remocao itens - remover os itens que estavam sendo utilizados
For nX := 1 to len(aAux2)
	aSZN := {}
	// tratamento remocao POS
	If aAux2[nX,1] == "POS"
		If Len(aAux2[nX]) > 1
			For nI := 2 To Len(aAux2[nX])
				If aAux2[nX][nI][1] == "NSERIE_POS_ANT"
					cPosAnt := aAux2[nX][nI][2]
				ElseIf aAux2[nX][nI][1] == "NSERIE_POS_ATU"
					cPosAtu := aAux2[nX][nI][2]
				EndIf
			Next nI
			
			// ZZN - POS
			If !Empty(cPosAnt)
				dbSelectArea("ZZN")
				dbSetOrder(1)	// IDPDV
				If dbseek( xFilial("ZZN") +cPosAnt )
					If AllTrim(ZZN->ZZN_PATRIM) == AllTrim(cPatr)
						Reclock("ZZN",.F.)
						ZZN->ZZN_CLIENT	:= ""
						ZZN->ZZN_LOJA	:= ""
						ZZN->ZZN_LOCALZ	:= "3"
						ZZN->ZZN_PATRIM	:= ""
						ZZN->(Msunlock())
				        
						// ZZO - lacres
						cQuery := "SELECT R_E_C_N_O_ AS REG FROM "+RetSQLName("ZZO")+" WHERE ZZO_LACRE='"+cvaltochar(cPosAnt)+"' AND ZZO_TIPO='"+_cZPOS+"' AND ZZO_DATRET = '' AND D_E_L_E_T_='' AND ZZO_PATRIM = '"+cPatr+"'"
						If Select("TRB") > 0
							TRB->(dbCloseArea())
						EndIf
					
						dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
						dbSelectArea("TRB")
						If !Empty(TRB->REG)
							dbSelectArea("ZZO")
							dbGoto(TRB->REG)
							Reclock("ZZO",.F.)
							ZZO->ZZO_DATRET := ddatabase
							ZZO->(Msunlock())
						EndIf
					EndIf	
				EndIf
			EndIf
		
			If Empty(cPosAtu)
				dbSelectArea("SN1") 
				DbSetOrder(2)
				If dbseek(xFilial("SN1")+cPatr)
					cSisPg := SN1->N1_XSISPG
					cSisPg := StrTran(cSisPg,"PO=1","PO=0")
					If RecLock("SN1",.F.) 
						SN1->N1_XSISPG := cSisPg
						SN1->(MSUNLOCK())
					EndIf
				EndIf
			EndIf
		EndIf
	
		 //aqui
	// tratamento inclusao/remocao PLACA - LEITURA
	ElseIf aAux2[nX,1] $ "PLACA_ANTERIOR|PLACA_ATUAL"
		If Len(aAux2[nX]) > 1
			aSZN := aclone(aIniSZN)
			AADD( aSZN, { "NUMERO_DO_ATIVO", cPatr } )
			For nI := 2 To Len(aAux2[nX])
				AADD( aSZN, { aAux2[nX][nI][1], aAux2[nX][nI][2] } )
			Next nI                                                  
			If !Empty(aSZN)
				Ajusta(@aSZN)
				
				If aAux2[nX,1] == "PLACA_ANTERIOR" 
					AADD( aSZN, { "TROCA_PLACA","1"  } )
				ElseIf aAux2[nX,1] == "PLACA_ATUAL"
					AADD( aSZN, { "TROCA_PLACA","2"  } )
				EndIf
				
				lRet := U_TTPROC17(LEITURA,,aSZN,@cMsgErro,.T.)	// grava leitura SZN
				If !lRet
					Conout("# TTPROC39/tratSP2 -> Erro ao gravar a Leitura em U_TTPROC17 #")
					//Return lRet
				EndIf
			EndIf
		EndIf

	// tratamento remocao Aceitador de CEDULA - gravar sangria	
	ElseIf aAux2[nX,1] == "CEDULA"
		If Len(aAux2[nX]) > 1
			For nI := 2 To Len(aAux2[nX])
				If aAux2[nX][nI][1] == "NSERIE_CED_ANT"
					cCedAnt := aAux2[nX][nI][2]
				ElseIf aAux2[nX][nI][1] == "NSERIE_CED_ATU"
					cCedAtu := aAux2[nX][nI][2]
				ElseIf aAux2[nX][nI][1] == "LACRE_CED_ANT"
					cLacCdAnt := aAux2[nX][nI][2]            
				ElseIf aAux2[nX][nI][1] == "LACRE_CED_ATU"
					cLacCdAtu := aAux2[nX][nI][2]            
				EndIf
			Next nI
			
			aSZN := Aclone(aIniSZN)
			AADD( aSZN, { "PATRIMONIO", cPatr } )
			For nI := 2 To Len(aAux2[nX])
				If ! aAux2[nX][nI][1] $ "NSERIE_CED_ANT|NSERIE_CED_ATU"
					AADD( aSZN, { aAux2[nX][nI][1], aAux2[nX][nI][2]  } )
				EndIf
			Next nI        
	        
			// aceitador de cedula anterior
			If !Empty(cCedAnt)
				cQuery := "SELECT R_E_C_N_O_ AS REG FROM "+RetSQLName("ZZO")+" WHERE ZZO_LACRE='"+cCedAnt+"' AND ZZO_TIPO='"+_cZCed+"' AND ZZO_DATRET = '' AND D_E_L_E_T_='' AND ZZO_PATRIM = '"+cPatr+"' "
				If Select("TRB") > 0
					TRB->(dbCloseArea())
				EndIf
				dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
				dbSelectArea("TRB")
				If !Empty(TRB->REG)
					DbSelectArea("ZZO")
					Dbgoto(TRB->REG)
					Reclock("ZZO",.F.)
					ZZO->ZZO_DATRET := ddatabase
					ZZO->(Msunlock())
				EndIf
			
			EndIf
			
			// lacre cedula anterior
			If !Empty(cLacCdAnt)
				cQuery := "SELECT R_E_C_N_O_ AS REG FROM "+RetSQLName("ZZO")+" WHERE ZZO_LACRE='"+cLacCdAnt+"' AND ZZO_TIPO='"+_cZLacre+"' AND ZZO_DATRET = '' AND D_E_L_E_T_='' AND ZZO_PATRIM = '"+cPatr+"' "
				If Select("TRB") > 0
					TRB->(dbCloseArea())
				EndIf
				dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
				dbSelectArea("TRB")
				If !Empty(TRB->REG)
					DbSelectArea("ZZO")
					Dbgoto(TRB->REG)
					Reclock("ZZO",.F.)
					ZZO->ZZO_DATRET := ddatabase
					ZZO->(Msunlock())
				EndIf
			EndIf
			
			// aceitador de cedulas atual vazio - remove do sistema de pagamento
			If Empty(cCedAtu)
				dbSelectArea("SN1") 
				DbSetOrder(2)
				If dbseek(xFilial("SN1")+cPatr)
					cSisPg := SN1->N1_XSISPG
					cSisPg := StrTran(cSisPg,"CE=1","CE=0")
					If RecLock("SN1",.F.) 
						SN1->N1_XSISPG := cSisPg
						SN1->(MSUNLOCK())
					EndIf
				EndIf
			EndIf		
		EndIf

	// tratamento remocao MOEDEIRO - gravar sangria
	ElseIf aAux2[nX,1] == "MOEDEIRO"
		If Len(aAux2[nX]) > 1
			For nI := 2 To Len(aAux2[nX])
				If aAux2[nX][nI][1] == "NSERIE_MOED_ANT"
					cMoedAnt := aAux2[nX][nI][2]
				ElseIf aAux2[nX][nI][1] == "NSERIE_MOED_ATU"
					cMoedAtu := aAux2[nX][nI][2]            
				ElseIf aAux2[nX][nI][1] == "LACRE_MOED_ANT"	//LACRE_MOED_ANT
					cLacMdAnt := aAux2[nX][nI][2]            
				ElseIf aAux2[nX][nI][1] == "LACRE_MOED_ATU"
					cLacMdAtu := aAux2[nX][nI][2]            
				EndIf
			Next nI

			// campos do numero de serie do moedeiro estao faltando no formulario do equipe remota
			If !Empty(cMoedAnt)
				cQuery := "SELECT R_E_C_N_O_ AS REG FROM "+RetSQLName("ZZO")+" WHERE ZZO_LACRE='"+cMoedAnt+"' AND ZZO_TIPO='"+_cZMoe+"' AND ZZO_DATRET='' AND D_E_L_E_T_='' AND ZZO_PATRIM = '"+cPatr+"' "
				If Select("TRB") > 0
					TRB->(dbCloseArea())
				EndIf
			
				dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
				dbSelectArea("TRB")
				If !Empty(TRB->REG)
					DbSelectArea("ZZO")
					Dbgoto(TRB->REG)
					Reclock("ZZO",.F.)
					ZZO->ZZO_DATRET := ddatabase
					ZZO->(Msunlock())
				EndIf
			EndIf
			// lacre anterior
			If !Empty(cLacMdAnt)
				cQuery := "SELECT R_E_C_N_O_ AS REG FROM "+RetSQLName("ZZO")+" WHERE ZZO_LACRE='"+cLacMdAnt+"' AND ZZO_TIPO='"+_cZLacre+"' AND ZZO_DATRET='' AND D_E_L_E_T_='' AND ZZO_PATRIM = '"+cPatr+"' "
				If Select("TRB") > 0
					TRB->(dbCloseArea())
				EndIf
			
				dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
				dbSelectArea("TRB")
				If !Empty(TRB->REG)
					DbSelectArea("ZZO")
					Dbgoto(TRB->REG)
					Reclock("ZZO",.F.)
					ZZO->ZZO_DATRET := ddatabase
					ZZO->(Msunlock())
				EndIf
			EndIf
			
			// retirou moedeiro anterior e nao colocou outro
			If Empty(cMoedAtu)
				dbSelectArea("SN1") 
				DbSetOrder(2)
				If dbseek(xFilial("SN1")+cPatr)
					cSisPg := SN1->N1_XSISPG
					cSisPg := StrTran(cSisPg,"MC=1","MC=0")
					cSisPg := StrTran(cSisPg,"MS=1","MS=0")
					If RecLock("SN1",.F.) 
						SN1->N1_XSISPG := cSisPg
						SN1->(MSUNLOCK())
					EndIf
				EndIf
			EndIf
		EndIf
			
	// tratamento remocao SMART
	ElseIf aAux2[nX,1] == "SMART"
		If Len(aAux2[nX]) > 1
			For nI := 2 To Len(aAux2[nX])
				If aAux2[nX][nI][1] == "NSERIE_SMART_ANT"
					cSmtAnt := aAux2[nX][nI][2]
				ElseIf aAux2[nX][nI][1] == "NSERIE_SMART_ATU"
					cSmtAtu := aAux2[nX][nI][2]
				EndIf
			Next nI
			
			If !Empty(cSmtAnt)
				cQuery := "SELECT R_E_C_N_O_ AS REG FROM "+RetSQLName("ZZO")+" WHERE ZZO_LACRE='"+cSmtAnt+"' AND ZZO_TIPO='"+_cZSmart+"' AND ZZO_DATRET = '' AND D_E_L_E_T_='' AND ZZO_PATRIM = '"+cPatr+"' "
	
				If Select("TRB") > 0
					TRB->(dbCloseArea())
				EndIf
				dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
				dbSelectArea("TRB")
				If !Empty(TRB->REG)
					DbSelectArea("ZZO")
					Dbgoto(TRB->REG)
					Reclock("ZZO",.F.)
					ZZO->ZZO_DATRET := ddatabase
					ZZO->(Msunlock())
				EndIf
			EndIf
			// retirou smart anterior e nao colocou outro
			If Empty(cSmtAtu)
				dbSelectArea("SN1") 
				DbSetOrder(2)
				If dbseek(xFilial("SN1")+cPatr)
					cSisPg := SN1->N1_XSISPG
					cSisPg := StrTran(cSisPg,"SM=1","SM=0")
					If RecLock("SN1",.F.) 
						SN1->N1_XSISPG := cSisPg
						SN1->(MSUNLOCK())
					EndIf
				EndIf
			EndIf
		EndIf
	// GLEENVIEW
	ElseIf aAux2[nX,1] == "GLEENVIEW"
		If Len(aAux2[nX]) > 1
			For nI := 2 To Len(aAux2[nX])
				If aAux2[nX][nI][1] == "LACRE_GLEEN_ANT"	// LACRE_GLEEN_ANT
					cLGleeAnt := aAux2[nX][nI][2]
				ElseIf aAux2[nX][nI][1] == "LACRE_GLEEN_ATU"	// LACRE_GLEEN_ATU
					cLGleeAtu := aAux2[nX][nI][2]
				EndIf
			Next nI
			If !Empty(cLGleeAnt)
				cQuery := "SELECT R_E_C_N_O_ AS REG FROM "+RetSQLName("ZZO")+" WHERE ZZO_LACRE='"+cLGleeAnt+"' AND ZZO_TIPO='"+_cZGleen+"' AND ZZO_DATRET = '' AND D_E_L_E_T_='' AND ZZO_PATRIM = '"+cPatr+"' "
	
				If Select("TRB") > 0
					TRB->(dbCloseArea())
				EndIf
				dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
				dbSelectArea("TRB")
				If !Empty(TRB->REG)
					DbSelectArea("ZZO")
					Dbgoto(TRB->REG)
					Reclock("ZZO",.F.)
					ZZO->ZZO_DATRET := ddatabase
					ZZO->(Msunlock())
				EndIf
			EndIf
		EndIf			
	EndIf
Next nX

// tratamento inclusao itens 
If !Empty(cPosAtu)
	AADD( aAux, {"NSERIE_POS", cPosAtu} )
EndIf                          
If !Empty(cMoedAtu)
	AADD( aAux, {"NSERIE_MOED", cMoedAtu} )
	If !Empty(cLacMdAtu)
		AADD( aAux, {"LACRE_MOED", cLacMdAtu} )
	EndIf	
EndIf	 
If !Empty(cCedAtu)
	AADD( aAux, {"NSERIE_CED", cCedAtu} )
	If !Empty(cLacCdAtu)
		AADD( aAux, {"LACRE_CED", cLacCdAtu })
	EndIf
EndIf                       
If !Empty(cSmtAtu)
	AADD( aAux, {"NSERIE_SMART", cSmtAtu} )
EndIf
If !Empty(cLGleeAtu)
	AADD( aAux, {"GLEENVIEW", cLGleeAtu} )
EndIf   

                            
If !Empty(aAux)
	tratarSP(aAux,cPatr)
EndIf

lRet := .T.
                                                       
Return lRet      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjusta  บAutor  ณJackson E. de Deus    บ Data ณ  21/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAjusta os nomes dos campos do Array para envio a funcao     บฑฑ
ฑฑบ          ณU_TTPROC17                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Ajusta(aSZN)

Local nI,nJ
Local aRelacao := {}
       
aRelacao := 	{{	"MOEDA_RETIRADO"																,	"MOEDA_RETIRADO"			},;
				{	"CEDULA_RETIRADO"																,	"CEDULA_RETIRADO"			},;
				{	"QUANTIDADE_R0,05"																,	"QUANTIDADE R0,05"			},;
				{	"QUANTIDADE_R0,10"																, 	"QUANTIDADE R0,10"			},;
				{	"QUANTIDADE_R0,25"																,	"QUANTIDADE R0,25"			},;
				{	"QUANTIDADE_R0,50"																,	"QUANTIDADE R0,50"			},;
				{	"QUANTIDADE_R1,00"																,	"QUANTIDADE R1,00"			},;
				{	"TROCO"																			,	"TROCO_MOEDA"				},;
				{	"BANANINHA"																		,	If(Upper(AllTrim(GetEnvServer())) == "JVVXC9_TESTE","BANANINHA","NUMERO")},;
				{	"MOEDA_COLOCADO"																,	"MOEDA_COLOCADO"			},; 
				{	"CEDULA_COLOCADO"																,	If(Upper(AllTrim(GetEnvServer())) == "JVVXC9_TESTE","CEDULA_-_LACRE_COLOCADO","CEDULA_COLOCADO")},;
				{	"NSERIE_POS_MOED|NSERIE_POS_CED"												,	"NUMERO_DE_SERIE_DO_POS"	},;
				{	"TOTAL_CASH_MOED|TOTAL_CASH_CED|TOTAL_CASH_PLACA_ANT|TOTAL_CASH_PLACA_ATU"		,	"TOTAL_COFRE_/_VALOR_VISOR"	},;
				{	"TOTAL_SALES_MOED|TOTAL_SALES_CED|TOTAL_SALES_PLACA_ANT|TOTAL_SALES_PLACA_ATU"	,	"TOTAL_DE_SELECOES"			},;
				{	"CONTADOR_01_MOED|CONTADOR_01_CED"												,	"CONTADOR 01"				},;
				{	"CONTADOR_02_MOED|CONTADOR_02_CED"												,	"CONTADOR 02"				},;
				{	"CONTADOR_03_MOED|CONTADOR_03_CED"												,	"CONTADOR 03"				},;
				{	"CONTADOR_04_MOED|CONTADOR_04_CED"												,	"CONTADOR 04"				},;
				{	"CONTADOR_05_MOED|CONTADOR_05_CED"												,	"CONTADOR 05"				},;
				{	"TESTES_MOED|TESTES_CED|TESTES_PLACA_ANT|TESTES_PLACA_ATU"						,	"NUMERO_TESTES"				},;
				{	"PARCIAL_MOED|PARCIAL_CED|PARCIAL_PLACA_ANT|PARCIAL_PLACA_ATU"					,	"PARCIAL"					}}


For nI := 8 To Len(aSZN)
	For nJ := 1 To Len(aRelacao)
		If aSZN[nI][1] $ aRelacao[nJ][1]
			aSZN[nI][1] := aRelacao[nJ][2]
			Exit
		EndIf
	Next nJ
Next nI

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSisPgto  บAutor  ณMicrosiga           บ Data ณ  07/14/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SisPgto(cOsMobile,aMnt)

Local cMaquina := ""
Local cSisPg := "CE=0|MC=0|MS=0|VR=0|SM=0|PO=0|CI=0"
//Local aMnt	:= {}
Local nPos := 0
Local nI,nJ
Local nNumAnt := 0
Local cPosAnt := ""
Local cPosAtu := ""
Local cLacMdAnt := ""
Local cLacMdAtu := ""
Local cLacCedAnt := ""
Local cLacCedAtu := ""
Local cSmartAnt := ""
Local cSmartAtu := ""
Local cGleenvAnt := ""
Local cGleenvAtu := ""
Local aPlacaAnt := {}
Local aPlacaAtu := {}
Local nCnt1 := 0
Local nCnt2 := 0
Local lMoedTroco := .F.

dbSelectArea("SZG")
dbSetOrder(1)
If MsSeek( xFilial("SZG") +AvKey(cOsMobile,"ZG_NUMOS") )
	cMaquina := SZG->ZG_PATRIM
EndIf                         

dbSelectArea("SN1")
dbSetOrder(2)
MSSeek( xFilial("SN1") +AvKey(cMaquina,"N1_CHAPA") )
cSisPg := AllTrim(SN1->N1_XSISPG)
/*
nPos := Ascan(aDados,{|x| Alltrim(x[1]) == "MANUTENCAO"})
If nPos > 0
	aMnt := Aclone( aDados[nPos][2] )
EndIf 
*/
If Empty(aMnt)
	Return
EndIf     

// POS
nPos := Ascan(aMnt,{|x| Alltrim(UPPER(x[1])) == "POS_ANT"})
If nPos > 0
	cPosAnt := aMnt[nPos][2]
EndIf

nPos := Ascan(aMnt,{|x| Alltrim(UPPER(x[1])) == "POS_ATU"})
If nPos > 0
	cPosAtu := aMnt[nPos][2]
EndIf
              
// removeu
If !Empty(cPosAnt)
	dbSelectArea("ZZN")
	dbSetOrder(1)	// IDPDV
	If dbseek( xFilial("ZZN") +cPosAnt )
		If AllTrim(ZZN->ZZN_PATRIM) == AllTrim(cMaquina)
			Reclock("ZZN",.F.)
			ZZN->ZZN_CLIENT	:= ""
			ZZN->ZZN_LOJA	:= ""
			ZZN->ZZN_LOCALZ	:= "3"
			ZZN->ZZN_PATRIM	:= ""
			ZZN->(Msunlock())
		EndIf	
	EndIf	
	cSisPg := StrTran(cSisPg,"PO=1","PO=0")
EndIf

// incluiu                            
If !Empty(cPosAtu)
	dbSelectArea("ZZN")
	dbSetOrdeR(1)	// IDPDV
	If MSSeek(xFilial("ZZN")+cPosAtu)
		If Empty(ZZN->ZZN_PATRIM)
			Reclock("ZZN",.F.)
			ZZN->ZZN_CLIENT	:= SN1->N1_XCLIENT
			ZZN->ZZN_LOJA	:= SN1->N1_XLOJA
			ZZN->ZZN_LOCALZ	:= "1"
			ZZN->ZZN_PATRIM	:= cMaquina
			ZZN->(Msunlock())
		EndIf	
	EndIf
	cSisPg := StrTran(cSisPg,"PO=0","PO=1") 	
EndIf


// MOEDEIRO
nPos := Ascan(aMnt,{ |x| Alltrim(UPPER(x[1])) == "MOED_LAC_ANT"} )
If nPos > 0
	cLacMdAnt := aMnt[nPos][2]
EndIf

nPos := Ascan(aMnt,{ |x| Alltrim(UPPER(x[1])) == "MOED_LAC_ATU"} )
If nPos > 0
	cLacMdAtu := aMnt[nPos][2]
EndIf


If "MC=SIM" $ SZG->ZG_OBSRET 
	lMoedTroco := .T.
EndIf
    
If !Empty(cLacMdAnt)
	//If lMoedTroco
		cSisPg := StrTran(cSisPg,"MC=1","MC=0") 
	//Else
		cSisPg := StrTran(cSisPg,"MS=1","MS=0") 
	//EndIf
EndIf              

If !Empty(cLacMdAtu)
	If lMoedTroco
		cSisPg := StrTran(cSisPg,"MC=0","MC=1") 
	Else
		cSisPg := StrTran(cSisPg,"MS=0","MS=1") 
	EndIf
EndIf

// CEDULA
nPos := Ascan(aMnt,{ |x| Alltrim(UPPER(x[1])) == "CED_LAC_ANT"} )
If nPos > 0
	cLacCedAnt := aMnt[nPos][2]
EndIf

nPos := Ascan(aMnt,{ |x| Alltrim(UPPER(x[1])) == "CED_LAC_ATU"} )
If nPos > 0
	cLacCedAtu := aMnt[nPos][2]
EndIf
     
If !Empty(cLacCedAnt)
	cSisPg := StrTran(cSisPg,"CE=1","CE=0")	 
EndIf              

If !Empty(cLacCedAtu)
	cSisPg := StrTran(cSisPg,"CE=0","CE=1")	 
EndIf

 
// SMART
nPos := Ascan(aMnt,{ |x| Alltrim(UPPER(x[1])) == "SMART_NSERIE_ANT"} )
If nPos > 0
	cSmartAnt := aMnt[nPos][2]
EndIf

nPos := Ascan(aMnt,{ |x| Alltrim(UPPER(x[1])) == "SMART_NSERIE_ATU"} )
If nPos > 0
	cSmartAtu := aMnt[nPos][2]
EndIf
     
If !Empty(cSmartAnt)
	cSisPg := StrTran(cSisPg,"CE=1","CE=0")	 
EndIf              

If !Empty(cSmartAtu)
	cSisPg := StrTran(cSisPg,"CE=0","CE=1")	 
EndIf


// GLEENVIEW  
nPos := Ascan(aMnt,{ |x| Alltrim(UPPER(x[1])) == "GLEENV_ANT"} )
If nPos > 0                                                
	cGleenvAnt := aMnt[nPos][2]
EndIf

nPos := Ascan(aMnt,{ |x| Alltrim(UPPER(x[1])) == "GLEENV_ATU"} )
If nPos > 0
	cGleenvAtu := aMnt[nPos][2]
EndIf

dbSelectArea("SN1")
If MSSeek( xFilial("SN1") +AvKey(cMaquina,"N1_CHAPA") )
	If RecLock("SN1",.F.)
		SN1->N1_XSISPG := cSisPg
		MsUnLock()
	EndIf
EndIf
     

// PLACA
/* Placa anterior */
aPlacaAnt := { {"TESTES_ANT", "ZN_BOTTEST",0 },;
				{"CASH_ANT","ZN_COTCASH",0},;
				{"PARCIAL_ANT","ZN_PARCIAL",0},;
				{"SALE_ANT","ZN_NUMATU",0},;
				{"P1_ANT","ZN_BOTAO01",0},; 
				{"P2_ANT","ZN_BOTAO02",0},; 
				{"P3_ANT","ZN_BOTAO03",0},; 
				{"P4_ANT","ZN_BOTAO04",0},; 
				{"P5_ANT","ZN_BOTAO05",0},; 
				{"P6_ANT","ZN_BOTAO06",0},; 
				{"P7_ANT","ZN_BOTAO07",0},; 
				{"P8_ANT","ZN_BOTAO08",0},; 
				{"P9_ANT","ZN_BOTAO09",0},; 
				{"P10_ANT","ZN_BOTAO10",0},; 
				{"P11_ANT","ZN_BOTAO11",0},; 
				{"P12_ANT","ZN_BOTAO12",0},; 
				{"P13_ANT","ZN_BOTAO13",0},; 
				{"P14_ANT","ZN_BOTAO14",0},; 
				{"P15_ANT","ZN_BOTAO15",0},; 
				{"P16_ANT","ZN_BOTAO16",0} } 
				

aPlacaAtu := { {"TESTES_ATU", "ZN_BOTTEST",0 },;
				{"CASH_ATU","ZN_COTCASH",0},;
				{"PARCIAL_ATU","ZN_PARCIAL",0},;
				{"SALE_ATU","ZN_NUMATU",0},;
				{"P1","ZN_BOTAO01",0},; 
				{"P2","ZN_BOTAO02",0},; 
				{"P3","ZN_BOTAO03",0},; 
				{"P4","ZN_BOTAO04",0},; 
				{"P5","ZN_BOTAO05",0},; 
				{"P6","ZN_BOTAO06",0},; 
				{"P7","ZN_BOTAO07",0},; 
				{"P8","ZN_BOTAO08",0},; 
				{"P9","ZN_BOTAO09",0},; 
				{"P10","ZN_BOTAO10",0},; 
				{"P11","ZN_BOTAO11",0},; 
				{"P12","ZN_BOTAO12",0},; 
				{"P13","ZN_BOTAO13",0},; 
				{"P14","ZN_BOTAO14",0},; 
				{"P15","ZN_BOTAO15",0},; 
				{"P16","ZN_BOTAO16",0} } 
				


For nI := 1 To Len(aPlacaAnt)
	For nJ := 1  To Len(aMnt)
		If aMnt[nJ][1] == aPlacaAnt[nI][1]
			If !Empty(aMnt[nJ][2])
				aPlacaant[nI][3] := Val(aMnt[nJ][2])
				nCnt1++                              
			EndIf
		EndIf
	Next nJ
Next nI

For nI := 1 To Len(aPlacaAtu)
	For nJ := 1  To Len(aMnt)
		If aMnt[nJ][1] == aPlacaAtu[nI][1]
			If !Empty(aMnt[nJ][2])
				aPlacaAtu[nI][3] := Val(aMnt[nJ][2])
				nCnt2++
			EndIf
		EndIf
	Next nJ
Next nI

// gravar
If nCnt1 > 0 .And. nCnt2 > 0
	AADD( aPlacaAnt, { "","ZN_TRPLACA","1" } ) 
	AADD( aPlacaAtu, { "","ZN_TRPLACA","2" } )
	
	nNumAnt := U_TTPROG02(cMaquina)
	If Valtype(nNumAnt) == "C" 
		nNumAnt := Val(nNumAnt)
	EndIf

	dbSelectArea("SZN")
	dbSetOrder(4)
	If !MsSeek( xFilial("SZN") +AvKey(cOsMobile,"ZN_NUMOS") )
		// placa anterior
		If Reclock("SZN",.T.)
			SZN->ZN_FILIAL	:= xFilial("SZN")
			SZN->ZN_TIPINCL	:= "LEITURA CF"
			SZN->ZN_DATA	:= SZG->ZG_DATAFIM
			SZN->ZN_PATRIMO	:= cMaquina
			SZN->ZN_TIPMAQ	:= Posicione("SB1",1,xFilial("SB1")+Posicione("SN1",2,xFilial("SN1")+cMaquina,"N1_PRODUTO"),"B1_ESPECIF")
			SZN->ZN_CLIENTE	:= SZG->ZG_CLIFOR
			SZN->ZN_LOJA	:= SZG->ZG_LOJA
			SZN->ZN_NUMANT	:= nNumAnt
			
			SZN->ZN_HORA	:= SZG->ZG_HORAFIM
			SZN->ZN_NUMOS	:= cOsMobile
		
			For nI := 1 To Len(aPlacaAnt)
				&("SZN->"+aPlacaAnt[nI][2]) := aPlacaAnt[nI][3]
			Next nI
		
			SZN->(Msunlock())
		EndIf
		
		// placa nova
		If RecLock("SZN",.T.)
			SZN->ZN_FILIAL	:= xFilial("SZN")
			SZN->ZN_TIPINCL	:= "LEITURA CF"
			SZN->ZN_DATA	:= SZG->ZG_DATAFIM
			SZN->ZN_PATRIMO	:= cMaquina
			SZN->ZN_TIPMAQ	:= Posicione("SB1",1,xFilial("SB1")+Posicione("SN1",2,xFilial("SN1")+cMaquina,"N1_PRODUTO"),"B1_ESPECIF")
			SZN->ZN_CLIENTE	:= SZG->ZG_CLIFOR
			SZN->ZN_LOJA	:= SZG->ZG_LOJA
			SZN->ZN_NUMANT	:= 0
			
			SZN->ZN_HORA	:= SZG->ZG_HORAFIM
			SZN->ZN_NUMOS	:= cOsMobile
		
			For nI := 1 To Len(aPlacaAtu)
				&("SZN->"+aPlacaAtu[nI][2]) := aPlacaAtu[nI][3]
			Next nI
		
			SZN->(Msunlock())
		EndIf
	EndIf	 
EndIf


Return 