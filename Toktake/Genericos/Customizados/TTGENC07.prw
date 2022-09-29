#INCLUDE "protheus.ch"                
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTGENC07  บAutor  ณMicrosiga           บ Data ณ  02/23/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTGENC07()

Local cCodPA := ""                
Local nTipo := If(cEmpAnt == "01",If(SZ9->Z9_TIPO=='1',16,17),0)
Local cClifor
Local cLoja
Local aTipoMaq := {} 
Local cHoraAgen := time()
Local cDtAgen	
//Local nAgente := 0
Local cChmOS := ""
Local aDoc	:=	{}  
Local lRet	:=	.T.  
Local lErro := .F.
Local nI             
Local aRECUD := {}
Local cNumTMK := SUC->UC_CODIGO
Local nRecB2 := 0
Local nRecB7 := 0
Local cTxtMsg := ""
Local aERROS := {}
Local aERROMM := {}  
Local aMob := {}
Local lNovoFrm := .F.
Local aDadosOS := {} 
Local cForm := ""
Local cDescFrm := ""
Local cLocal := ""
Local cCodTec := ""
Local cNomeTec := ""

IF cEmpAnt <> "01"
	Return
EndIF 

lRet := ConPad1(,,,"AA1",,,.F.)
If !lRet
	Return lRet
EndIf          

lNovoFrm := .T.

cCodTec := AA1->AA1_CODTEC
cNomeTec := AA1->AA1_NOMTEC
	
DbSelectArea("SUC")
DbSetOrder(1)
DbSeek( cFilAnt +cNumTMK ) //026026
cClifor := substr(UC_CHAVE,1,6)
cLoja 	:= substr(UC_CHAVE,7,4)
cCodCont := SUC->UC_CODCONT
	
DbSelectArea("SU5")
DbSetOrder(1)
If Dbseek( xFilial("SU5") +SUC->UC_CODCONT )
	cDadosCnt := "Contatos do Cliente - "+Alltrim(SU5->U5_CONTAT)+" - "+Alltrim(SU5->U5_FONE)+" "+Alltrim(SU5->U5_CELULAR)+" "+Alltrim(SU5->U5_FCOM1)+" "+Alltrim(SU5->U5_FCOM2)+chr(13)+Chr(10)+"Chamado Call Center OMM "+SUC->UC_CODIGO
EndIf

dbSelectArea("SUD")
dbSetOrder(1)
If dbSeek( SUC->UC_FILIAL+cNumTMK )
	While !EOF() .AND. SUD->UD_FILIAL == SUC->UC_FILIAL .AND. SUD->UD_CODIGO == cNumTMK
		AADD( aRECUD, Recno() )
		SUD->(dbSkip())
	End
EndIf

// validar base instalada
If !VldAA3(aRECUD)
	//Return .F.
EndIf

	
For nI := 1 To Len(aRECUD)
	dbSelectArea("SUD")
	dbGoTo(aRECUD[nI])
	If Recno() == aRECUD[nI]
	    cItx := SUD->UD_ITEM
		cDtAgen := UD_XDTINST
		cLocFis	:= If(SZ9->Z9_TIPO=="1",UD_XLOCFIS,Posicione("SN1",2,xFilial("SN1")+SUD->UD_XNPATRI,"N1_XLOCINS"))
		aDoc := {SUD->UD_XNPATRI,SUD->UD_CODIGO,Alltrim(Posicione("SB1",1,xFilial("SB1")+SUD->UD_PRODUTO,"B1_ESPECIF")),cLocFis,cvaltochar(val(SUD->UD_XVOLT)*110)+"V",cDtAgen,SUD->UD_ITEM}
		cCodPA := SUD->UD_XPA		
		cnumos := ""
		cLocal := ""                                                                                                    
		
		// valida se ja foi criado o chamado de instalacao/remocao para esse item 
		cChmOS := VldChmOS(SUC->UC_FILIAL,SUC->UC_CHAVE,cNumTMK,SUD->UD_ITEM,SUD->UD_XNPATRI,SZ9->Z9_TIPO,cDtAgen)	
		If Empty(cChmOS)
			cChmOS := U_TTTMKA31(SUC->UC_FILIAL,cNumTMK,SUC->UC_CHAVE,cCodCont,cnumos,SUD->UD_PRODUTO,SUD->UD_XNPATRI,cCodTec,cDtAgen,SUD->UD_XCONTRA,SUD->UD_ITEM,SZ9->Z9_TIPO)          
		EndIf
			
		If !Empty(cChmOS)
			RegField(cChmOS,@nRecB2, @nRecB7)
			
			If nRecB2 == 0 .And. nRecB7 == 0
				STATICCALL( TTTMKA31, Tca300, cChmOS,SUC->UC_CHAVE,SUD->UD_PRODUTO,SUD->UD_XNPATRI,"",cCodTec,cDtAgen,SUD->UD_XCONTRA,cCodCont )
			EndIf
			
			RegField(cChmOS,@nRecB2, @nRecB7)
			 
			If nRecB2 > 0 .And. nRecB7 > 0
				dbSelectArea("AB2")
				dbGoTo(nRecB2)
				If Recno() == nRecB2
					dbSelectArea("SUD")
					dbGoTo(aRECUD[nI])
					If Recno() == aRECUD[nI]
						If RecLock("SUD",.F.)
							SUD->UD_XNRCHAM := AB2->AB2_NRCHAM
							SUD->(MsUnLock())
						EndIf
					EndIf
				EndIf
				
				// valida se ja existe a OS mobile gerada
				cNumOS := VldOS( nTipo,cCliFor,cLoja,cCodTec,cDtAgen, SUD->UD_XNPATRI )
				If Empty(cNumOS)
				
					If !lNovoFrm
						//cNumOS := U_WSKPF009(nTipo,cCliFor,cLoja,aDoc,val(AA1->AA1_PAGER),cHoraAgen,,cDtAgen,cDadosCnt,,cCodPA)
					Else
						If nTipo == 16
							cForm := "16"
							cDescFrm := "INSTALACAO"
						ElseIf nTipo == 17
							cForm := "17"
							cDescFrm := "REMOCAO"
						EndIf
						
						cEndereco := ""
						// PA
						If !Empty(cCodPA)
							dbSelectArea("ZZ1")
							dbSetOrder(1)
							If MsSeek( xFilial("ZZ1") +AvKey(cCodPA,"ZZ1_COD") )
								cEndereco := AllTrim(ZZ1->ZZ1_END) +"," +AllTrim(ZZ1->ZZ1_MUN) +"," +AllTrim(ZZ1->ZZ1_EST)
								cLocal := AllTrim(ZZ1->ZZ1_DESCRI)
							EndIf
						// CLIENTE
						Else
							dbSelectArea("SA1")
							dbSetOrder(1)
							If MsSeek( xFilial("ZZ1") +AvKey(cCliFor,"A1_COD") +AvKey(cLoja,"A1_LOJA") )
								cEndereco := AllTrim(SA1->A1_END) +"," +AllTrim(SA1->A1_MUN) +"," +AllTrim(SA1->A1_EST)
								cLocal := AllTrim(SA1->A1_NREDUZ)
							EndIf
						EndIf
						
						aDadosOS := { cForm,;
										cDescFrm,;
										cCodTec,;
										cNomeTec,;
										AllTrim(SUD->UD_XNPATRI),;
										Posicione("SN1",2,xFilial("SN1")+AvKey(SUD->UD_XNPATRI,"N1_CHAPA"),"N1_DESCRIC" ) ,;
										"",;
										"",;
										cDtAgen,;
										cHoraAgen,;
										Posicione("SA1",1,xFilial("SA1")+AvKey(cCliFor,"A1_COD") +AvKey(cLoja,"A1_LOJA") ,"A1_NREDUZ"),;
										cEndereco,;
										"",;
										AllTrim(cDadosCnt),;
										"",;
										AllTrim(cLocal),;
										"",;
										"",;
										"",;
										cCliFor,;
										cLoja,;
										{},;
										"" } 
										
						cNumOS := U_MOBILE(aDadosOS)
					EndIf
					
					If !Empty(cNumOs)// .And. !"false" $ Alltrim(cnumos)
						If Val(cNumOs) > 0
							RegField(cChmOS,@nRecB2, @nRecB7)
							If nRecB2 > 0 .And. nRecB7 > 0
								dbSelectArea("AB2")
								dbGoTo(nRecB2)
								If Recno() == nRecB2
									RecLock("AB2",.F.)
									AB2->AB2_XOSMOB := cnumos
									MsUnLock()
								EndIf
								
								dbSelectArea("AB7")
								dbGoTo(nRecB7)
								If Recno() == nRecB7
									RecLock("AB7",.F.)
									AB7->AB7_XOSMOB := cnumos
									MsUnLock()
								EndIf                              
							EndIf
						Else
							AADD( aERROS, cItx )		
						EndIf
					Else
						AADD( aERROS, cItx  )
					EndIf
				EndIf
				
				If !Empty(cNumOS)
					AADD(aMob, cNumOS)
					If nRecB2 > 0 .And. nRecB7 > 0
						dbSelectArea("AB2")
						dbGoTo(nRecB2)
						If Recno() == nRecB2						
							If Alltrim(AB2->AB2_XOSMOB) <> AllTrim(cNumOS)
								RecLock("AB2",.F.)
								AB2->AB2_XOSMOB := cNumOs
								MsUnLock()
							EndIf
						EndIf
						
						dbSelectArea("AB7")
						dbGoTo(nRecB7)
						If Recno() == nRecB7 
							If Alltrim(AB7->AB7_XOSMOB) <> AllTrim(cNumOS)
								RecLock("AB7",.F.)
								AB7->AB7_XOSMOB := cNumOs
								MsUnLock()
							EndIf
						EndIf                              
					EndIf
				EndIf
			Else
				lRet := .F.
				AADD( aERROMM, cItx ) 				
			EndIf                         										
		Else
			lRet := .F.
			AADD( aERROMM, cItx ) 
		EndIf
	EndIf	
Next nI

If !Empty(aERROMM)
	cTxtMsg := "Houve erro ao gerar o chamado!"
	For nI := 1 To Len(aERROMM)
		cTxtMsg += CRLF +"Item: " +aERROMM[nI]
	Next nI
	MsgAlert(cTxtMsg)
EndIf

If !Empty(aERROS)
	cTxtMsg := "Houve erro ao gerar a OS mobile!"
	For nI := 1 To Len(aERROS)
		cTxtMsg += CRLF +"Item: " +aERROS[nI]
	Next nI
	MsgAlert(cTxtMsg)
EndIf

If !Empty(aMob)
	cTxtMsg := "OS Mobile criadas:"
	For nI := 1 To Len(aMob)
		cTxtMsg += CRLF +"OS: " +aMob[nI]
	Next nI
	Aviso("TTGENC07",cTxtMsg,{"Ok"})
EndIf


Return(lRet)                          


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRegField  บAutor  ณMicrosiga           บ Data ณ  05/22/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RegField(cChmOS,nRecB2, nRecB7)

Local cSql := ""


cSql := "SELECT AB2.R_E_C_N_O_ B2REC, AB7.R_E_C_N_O_ B7REC FROM " +RetSqlName("AB1") + " AB1 "
cSql += "INNER JOIN " +RetSqlName("SUC") +" UC ON UC_FILIAL = AB1_FILIAL AND UC_CODIGO = AB1_NUMTMK "
cSql += "INNER JOIN " +RetSqlName("AB2") +" AB2 ON AB2.AB2_FILIAL = AB1.AB1_FILIAL AND AB2.AB2_NRCHAM = AB1.AB1_NRCHAM "
cSql += "INNER JOIN " +RetSqlName("AB7") +" AB7 ON AB7.AB7_FILIAL = AB2.AB2_FILIAL AND AB7_NRCHAM = AB2.AB2_NRCHAM+AB2.AB2_ITEM "
cSql += "WHERE "
cSql += "AB1_NUMTMK = '"+cChmOS+"' "
cSql += "AND AB1.D_E_L_E_T_ = '' "

If Select('TRBA') > 0
	dbSelectArea('TRBA')
	dbCloseArea()
EndIf       

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cSql),"TRBA",.F.,.T.)
dbSelectArea("TRBA")

nRecB2 := TRBA->B2REC
nRecB7 := TRBA->B7REC
                  
TRBA->(dbCloseArea())

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldChmOS  บAutor  ณMicrosiga           บ Data ณ  06/22/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldChmOS(cfils,ccliori,cNumTMK,cItem,cPatr,cTipo,cDtAgen)

Local cSql := ""
Local cAssunto := IF(cTipo=="1","000012","000013") 
Local cChmOs := ""

cSql := "SELECT UD_CODIGO FROM " +RetSqlName("SUD") +" SUD "
cSql += "INNER JOIN " +RetSqlName("SUC") +" SUC ON "
cSql += "UC_FILIAL = UD_FILIAL "
cSql += "AND UC_CODIGO = UD_CODIGO "
cSql += "AND UC_CHAVE = '"+ccliori+"' "
cSql += "AND UC_PENDENT <= '"+DTOS(cDtAgen)+"' "
cSql += "AND UC_CODCANC = '' "
cSql += "AND SUC.D_E_L_E_T_ = SUD.D_E_L_E_T_ "
cSql += "WHERE UD_FILIAL = '"+cfils+"' "
cSql += "AND UD_VENDA = '"+cNumTMK+"' "
cSql += "AND UD_ITEMVDA = '"+cItem+"' "
cSql += "AND UD_XNPATRI = '"+cPatr+"' "
cSql += "AND UD_ASSUNTO = '"+cAssunto+"' "
cSql += "AND SUD.D_E_L_E_T_ = '' "

If Select("TRBD") > 0
	TRBD->(DBCLOSEAREA())
EndIf
                        
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cSql),"TRBD",.F.,.T.)
dbSelectArea("TRBD")
If !EOF()
	cChmOs := TRBD->UD_CODIGO
EndIf         

Return cChmOs


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldOS	    บAutor  ณMicrosiga           บ Data ณ  06/22/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldOS(nTipo,cCliFor,cLoja,cCodTec,cDtAgen,cPatrimo)
             
Local cNumOS := ""
Local cSql := ""

cSql := "SELECT ZG_NUMOS FROM " +RetSqlName("SZG") 
cSql += " WHERE ZG_TPFORM = '"+cvaltochar(nTipo)+"' AND ZG_CLIFOR = '"+cCliFor+"' AND ZG_LOJA = '"+cLoja+"' "
cSql += " AND ZG_CODTEC = '"+cCodTec+"' AND ZG_DATAINI = '"+DTOS(cDtAgen)+"' AND ZG_PATRIM = '"+cPatrimo+"' "
cSql += " AND D_E_L_E_T_ = '' AND ZG_STATUS NOT IN ('COPE','CTEC') "

If Select("TRBD") > 0
	TRBD->(DBCLOSEAREA())
EndIf
                        
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cSql),"TRBD",.F.,.T.)
dbSelectArea("TRBD")
If !EOF()
	cNumOS := TRBD->ZG_NUMOS
EndIf   

Return cNumOS


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldAA3    บAutor  ณMicrosiga           บ Data ณ  08/26/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldAA3(aRECUD)

Local lRet := .T.           
Local cQuery := ""
Local nI
Local aErro := {}
Local cPatrimo := ""
Local cMsg := ""


For nI := 1 To Len(aRecUD)	
	dbSelectArea("SUD")
	dbGoTo(aRecUD[nI])
	cPatrimo := SUD->UD_XNPATRI
	cNrCham := SUD->UD_XNRCHAM
	cQuery := "SELECT AB7_NUMOS FROM " +RetSqlName("AB7")
	cQuery += " WHERE AB7_FILIAL = '"+xFilial("AB7")+"' AND AB7_NUMSER = '"+cPatrimo+"' AND AB7_TIPO NOT IN ( '4','5' ) AND D_E_L_E_T_ = '' "
	cQuery += " AND AB7_NRCHAM NOT LIKE '%"+cNrCham+"%' "
	
	MpSysOpenQuery( cQuery,"TRB" )
	dbSelectArea("TRB")
	
	While !EOF()
		AADD( aErro, { cPatrimo ,TRB->AB7_NUMOS } )
		dbSkip()
	End
	TRB->( dbCloseArea() )
Next nI  

If !Empty(aErro)
	lRet := .F.

	cMsg := "Aten็ใo, ้ preciso incluir o laudo das Ordens de Servi็o abaixo: " +CRLF
	For nI := 1 To Len( aErro )
		cMsg += "Patrim๔nio: " +aErro[nI][1] + " - Ordem de Servi็o: " +aErro[nI][2] +CRLF
	Next nI
	
	MsgAlert( cMsg, "TTGENC07" )
EndIf

Return lRet