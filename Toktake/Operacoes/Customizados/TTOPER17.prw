#include "protheus.ch
#include "topconn.ch"
#include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTOPER17  บAutor  ณJackson E. de Deus  บ Data ณ  09/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ JOB Indicadores de Processo								  บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณJackson       ณ09/10/14ณ01.00 |Criacao                                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function TTOPER17()
    
Local lJob := .F.
Local aDados := {}
Private dDtIni
Private dDtFim
Private _cMail := ""

   
Prepare Environment  Empresa "01" Filial "01"

// pega os emails que serao considerados
_cMail := SuperGetMV("MV_XOPE002",.T.,"") 

cHoraIni := Time()
       
dDtIni := FirstDay(dDatabase)

If Day(dDatabase) <> 1
	dDtFim := dDatabase-1 
Else 
	dDtFim := dDtIni
EndIf

Proces( dDtIni,dDtFim )

cHoraFim := Time()
cTotal := ElapTime( cHoraIni, cHoraFim )
Conout("# TTOPER17 - " +"Tempo total de execucao: " +cTotal +"  #")

Reset Environment

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Proces  บAutor  ณJackson E. de Deus   บ Data ณ  02/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa atendente por atendente                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Proces(dDtIni,dDtFim,cMat,lRel,nOpcao)

Local cSql := ""
Local aAtend := {}
Local aDia := {}
Local aPeriod := {}
Local aDados := {}
Local aM := {}
Local aM2 := {}
Local aAXG := {}
Local nI, nJ, nY
Default cMat := ""
Default lRel := .F.
Default nOpcao := 1


// alterar consulta para buscar os dados de atendente/supervisor/gerente diretamente da tabela SZK
// pois a tabela de atendentes pode sofrer alteracoes cadastrais

cSql := "SELECT ZK_CODTEC, ZK_SUPERV, ZK_GEREN FROM " +RetSqlName("SZK")
cSql += " WHERE D_E_L_E_T_ = '' AND ZK_DTFIM BETWEEN '"+dtos(dDtIni)+"' AND '"+dtos(dDtFim)+"' "

// consulta relatorio
If !Empty(cMat) .And. lRel
	If nOpcao = 3
		cSql += " AND ZK_GEREN = '"+cMat+"' "
	ElseIf nOpcao = 2
		cSql += " AND ZK_SUPERV = '"+cMat+"' "		
	ElseIf nOpcao == 1 
		cSql += " AND ZK_CODTEC = '"+cMat+"' "
	EndIf
EndIf    

cSql += " GROUP BY ZK_CODTEC, ZK_SUPERV, ZK_GEREN "
cSql += " ORDER BY ZK_GEREN DESC, ZK_SUPERV DESC "


/*               
cSql := "SELECT AA1_CODTEC, AA1_NOMTEC, AA1_XSUPER, AA1_XGEREN FROM " +RetSqlName("AA1")
cSql += " WHERE D_E_L_E_T_ = '' AND AA1_XSUPER <> '' AND AA1_XGEREN <> '' "
                                        
If !Empty(cMat) .And. lRel
	If nOpcao == 1
		cSql += " AND AA1_CODTEC = '"+cMat+"' "
	ElseIf nOpcao == 2
		cSql += " AND AA1_XSUPER = '"+cMat+"' "
	ElseIf nOpcao == 3
		cSql += " AND AA1_XGEREN = '"+cMat+"' "		
	EndIf
EndIf

cSql += " ORDER BY AA1_XGEREN DESC,AA1_XSUPER DESC "
*/
If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf
                       
TcQuery cSql New Alias "TRB"
dbSelectArea("TRB")
While !EOF()
	AADD( aAtend, { TRB->ZK_CODTEC, TRB->ZK_SUPERV, TRB->ZK_GEREN } )	
	dbSkip()
End

TRB->( dbCloseArea() )

cAtend := ""
For nI := 1 To Len(aAtend)
	nPerc := Round( ( 100 / Len(aAtend) ) * nI, 2 )
	If lRel
		MsProcTxt( "Matrํcula: " +aAtend[nI][1] +" - " +cvaltochar(nPerc) +"%" )
	EndIf

	cAtend := aAtend[nI][1]
	aDia := {}   
	aPeriod := {}
	 
	// # alterar para buscar todo o pediodo e tratar ultimo dia na mesma chamada
	aDia :=	Dados( cAtend,dDtFim,dDtFim,.F. )		// dia
	aPeriod := Dados( cAtend,dDtIni,dDtFim,.T. )	// mes
	                
	If Len(aPeriod) > 0
		If Len(aDia) > 0
			For nJ := 1 To Len(aDia)
				nTp := aDia[nJ][1]
				nPosMes := Ascan( aPeriod, { |x| x[1] == nTp } )
				AADD( aAtend[nI], { nTp,;
									aDia[nJ][2],;			// indices totais dia
									aPeriod[nPosMes][2],;	// indices totais periodo
									aDia[nJ][3],;			// os atendidas dia
									aDia[nJ][4],; 			// os pendentes	
									aPeriod[nPosMes][3] })	// os atendidas acumulado
			Next nJ
		// sem atendimentos no dia
		Else
		
			nQtdCanc := QtdProg( aAtend[nI][1], dDtFim,.F.,2 )
			
			For nJ := 1 To Len(aPeriod)
				nTp := aPeriod[nJ][1]
				AADD( aAtend[nI], { nTp,;
									{ 0,0,0,nQtdCanc,0,0,0,0,0,0,0,0,0,0,0,0,0 },;		// indices totais dia
									aPeriod[nJ][2],;			// indices totais periodo
									{},;						// os atendidas dia
									{},;			 			// os pendentes dia	
									aPeriod[nJ][3] })			// os atendidas acumulado
			Next nJ
		EndIf
	EndIf		
Next nI

aRet := {}
For nI := 1 To Len(aAtend)
	If Len(aAtend[nI]) > 3
		AADD( aRet, aAtend[nI]  )
	EndIf
Next nI

// relatorio
If lRel
	Return aRet
EndIf


aSuper := {}
cSuper := ""
aGeren := {}
For nI := 1 To Len(aRet)
	cAtend := aRet[nI][1]
	If nI == 1
		cSuper := aRet[nI][2]
	EndIf		

	aDados := Aclone( aRet[nI] )
	MailTec(aDados,cAtend,dDtFim)
	AADD( aSuper, aDados )
	                     
	cSuper := aRet[nI][2]
	If nI <> Len(aRet)
		If cSuper <> aRet[nI+1][2]
			For nJ := 1 To Len(aSuper)
				If aSuper[nJ][4][1] == 1
					AADD( aM, { aSuper[nJ][1],;
								aSuper[nJ][4][2],;
								aSuper[nJ][4][3] } )
				ElseIf aSuper[nJ][4][1] == 2
					AADD( aM2, { aSuper[nJ][1],;
								aSuper[nJ][4][2],;
								aSuper[nJ][4][3] } )	
				EndIf	
			Next nI
           
			MailSuper(aM,aM2,cSuper,dDtFim)    
			aSuper := {}
			aM := {}
			aM2 := {}
		EndIf             
	Else
		For nJ := 1 To Len(aSuper)
			If aSuper[nJ][4][1] == 1
				AADD( aM, { aSuper[nJ][1],;
							aSuper[nJ][4][2],;
							aSuper[nJ][4][3] } )
			ElseIf aSuper[nJ][4][1] == 2
				AADD( aM2, { aSuper[nJ][1],;
							aSuper[nJ][4][2],;
							aSuper[nJ][4][3] } )	
			EndIf	
		Next nI
		MailSuper(aM,aM2,cSuper,dDtFim) 
		aSuper := {}
		aM := {}
		aM2 := {}  
	EndIf
	If Ascan( aAXG, { |x| x[1] == aRet[nI][3] } ) == 0
		AADD( aAXG, { aRet[nI][3] } )
	EndIf
Next nI

// gerente
For nI := 1 To Len(aAXG)
	For nJ := 1 To Len(aRet)
		If aRet[nJ][3] == aAXG[nI][1]
			AADD( aAXG[nI], aRet[nJ] )
		EndIf
	Next nJ
Next nI

For nY := 1 To Len(aAXG)
	aM := {}
	aM2 := {}
	cGeren := aAXG[nY][1]
	aRet := aClone(aAXG[nY])
	aDel( aRet, 1 )
	Asize( aRet, Len(aRet)-1 )

	For nI := 1 To Len(aRet)
		If aRet[nI][4][1] == 1
			AADD( aM, { aRet[nI][2],;
						aRet[nI][4][2],;
						aRet[nI][4][3] } )
		ElseIf aRet[nI][4][1] == 2
			AADD( aM2, { aRet[nI][2],;
						aRet[nI][4][2],;
						aRet[nI][4][3] } )	
		EndIf	
	Next nI
	
	// agrupa pontuais
	aSp := {}
	For nI := 1 To Len(aM)
		If Ascan( aSp, { |x| x[1] == aM[nI][1] } ) == 0
			AADD( aSp, { aM[nI][1] } )
		EndIf
	Next nI  
	
	For nI := 1 To Len(aSP)
		For nJ := 1 To Len(aM)
			If aSP[nI][1] == aM[nJ][1]
				AADD( aSP[nI], aM[nJ] )
			EndIf
		Next nJ
	Next nI
	aM := Aclone(aSP)
		
	
	// agrupa programadas
	aSp := {}
	For nI := 1 To Len(aM2)
		If Ascan( aSp, { |x| x[1] == aM2[nI][1] } ) == 0
			AADD( aSp, { aM2[nI][1] } )
		EndIf
	Next nI  
	
	For nI := 1 To Len(aSP)
		For nJ := 1 To Len(aM2)
			If aSP[nI][1] == aM2[nJ][1]
				AADD( aSP[nI], aM2[nJ] )
			EndIf
		Next nJ
	Next nI	
	aM2 := Aclone(aSP)
	MailGeren(aM,aM2,cGeren,dDtFim)
	aM := {}
	aM2 := {}
Next nY


Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDados     บAutor  ณJackson E. de Deus  บ Data ณ  09/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega os dados                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Dados(cCodAtend,dDataI,dDataF,lAcumulado)
     
Local cQuery := "" 
Local cCodPa := ""
Local cDescPA := ""     
Local aDados := {}	// pontuais - programadas
Local aMassa := {}
Local aAtends := {}
Local nI, nJ
Local nPos := 0
Local cCodAgente := ""
Local aPontual := {}
Local aProgram := {}
Local aAux := {}
Local aX := {}
Local aProg1 := {}
Local aProg2 := {}
Local nQtd := 0
Local cTmpIni := ""
Local cTmpAtend := ""
Local cTmpAux := ""
Local cTempo := ""
Local cTmpAux2 := ""
Local cTempo2 := ""
Local nQtdOSProg := 0
Local nMedia := 0 
Local nTotOS := 0
Local nMedia2 := 0 
Local nIndEfi := 0 
Local nProd := 0
Local nTmpMedio := 0
Local nAtendPrazo := 0
Local nQtdAtend := 0
Local nMediaPont := 0
Local nIndOci := 0  
Local nMaxTime := 0
Local nDias := 0
Local cEmpFunc := ""
Local cHrTurn1 := ""
Local cHrTurn2 := ""
Local cHrTurn3 := ""
Local cHrTurn4 := ""
Local nCorrec := 0
Local nTotCorrec := 0   
Local nTotSales := 0
Local nXTS := 0      
Local dDiaAnt := stod("")
//Local nTeste := 0

Local bError         := { |e| oError := e , Break(e) }
Local bErrorBlock    := ErrorBlock( bError )

Default lAcumulado := .F.

If dDataI = dDataF
	lAcumulado := .F.
EndIf


BEGIN SEQUENCE
                               
cQuery := "SELECT "
cQuery += "ZK_NUMOS, ZG_TPFORM, ZK_DTINI, ZK_HRINI, ZK_DTAGEND, ZK_HRAGEND, ZK_DTCRIAC, ZK_HRCRIAC, ZK_DTFIM, "
cQuery += " ZK_HRFIM, ZK_TMPDIA, ZK_TMPHORA, ZK_TMPINI, ZK_LATLNG1,ZK_LATLNG2, ZK_PATRIM, ZK_PATRIMD, ZK_TMPMAQ, "
cQuery += " ZK_CLIENTE, ZK_LOJA, ZK_PA, ZK_CODTEC, ZK_NOMTEC, ZK_AGENTE, ZK_SUPERV, ZK_SUPERVD, "
//cQuery += " ZK_PRAZOOK, ZK_REGOK, ZG_ROTA, A1_NREDUZ,ZK_HINITMK "
cQuery += " ZK_PRAZOOK, ZK_REGOK, ZG_ROTA, A1_NREDUZ,ZK_HINITMK,ZK_TURNTEC, ZK_ENTRA1, ZK_SAIDA1, ZK_ENTRA2, ZK_SAIDA2 "

cQuery += " FROM " +RetSqlName("SZK") +" SZK "
cQuery += " INNER JOIN " +RetSqlName("SZG") +" SZG ON "
cQuery += " ZK_FILIAL = ZG_FILIAL AND ZK_NUMOS = ZG_NUMOS AND ZG_TPFORM <> '1' "
cQuery += " INNER JOIN " +RetSqlName("SA1") +" SA1 ON "
cQuery += " A1_COD = ZK_CLIENTE AND A1_LOJA = ZK_LOJA AND SA1.D_E_L_E_T_ = '' "

cQuery += " WHERE SZK.D_E_L_E_T_ = '' AND ZK_CODTEC = '" +cCodAtend +"'  "

// # deve ser alterado posteriormente para calcular tudo de de uma vez - periodo - forma atual: 2 calculos | um para o dia e outro para o acumulado
If !lAcumulado
	cQuery += " AND ZK_DTFIM = '"+dtos(dDataI)+"' "
Else
	cQuery += " AND ZK_DTFIM BETWEEN '"+dtos(dDataI)+"' AND '"+dtos(dDataF)+"' "
EndIf

cQuery += " ORDER BY ZK_AGENTE, ZK_DTFIM, ZK_HRFIM "

If Select("TRB") > 0
	TRB->( dbCloseArea() )
EndIf
                       
TcQuery cQuery New Alias "TRB"
dbSelectArea("TRB")

While !EOF()

	fRetPA(TRB->ZK_CLIENTE,TRB->ZK_LOJA,@cCodPa,@cDescPA)

	dbSelectArea("TRB")
	AADD( aMassa, { TRB->ZK_NUMOS,;
		 			ALLTRIM(cvaltochar(TRB->ZG_TPFORM)), ;
		 			TRB->ZK_CODTEC,;
		 			TRB->ZK_NOMTEC,;
		 			 TRB->ZK_SUPERV,;
		 			  TRB->ZK_SUPERVD,;
		 			  TRB->ZK_TMPINI,;
					TRB->ZK_TMPHORA,;
					 IIF(TRB->ZK_PRAZOOK=="0",.T.,.F.),;
					  stod(TRB->ZK_DTAGEND),;
					   TRB->ZK_HRAGEND,;
					    stod(TRB->ZK_DTCRIAC),;
					TRB->ZK_HRCRIAC,;
					 TRB->ZK_CLIENTE,;
					  TRB->ZK_LOJA,;
					   TRB->ZK_PATRIM,;
					   	TRB->ZK_PATRIMD,;
					   	 TRB->A1_NREDUZ,;
					Posicione("SN1",1,xFilial("SN1")+AvKey(TRB->ZK_PATRIM,"N1_CHAPA"),"N1_XLOCINS"),; 
					TRB->ZK_HRFIM,;
					 STOD(TRB->ZK_DTFIM),;
					  STOD(TRB->ZK_DTINI),;
					   TRB->ZK_HRINI,;
					    TRB->ZK_HINITMK,;
					     cCodPA,;
					      cDescPA })
	dbSkip()
End
       
aAux := aclone(aMassa)
aTot := {}       
For nI := 1 To Len(aAux)
	If nI == 1
		cAgente := aAux[nI][3]
	EndIf

	// pontuais
	If aAux[nI][2] == "5" .OR. aAux[nI][2] == "6" .OR. aAux[nI][2] == "7" .OR. aAux[nI][2] == "14" .OR. aAux[nI][2] == "15"
		AADD( aPontual, aAux[nI] )
	EndIf

	// abastecimentos e sangrias
	If aAux[nI][2] == "2" .OR. aAux[nI][2] == "4" .OR. aAux[nI][2] == "8"
		AADD( aProg1, aAux[nI] )
	// entregas
	ElseIf aAux[nI][2] == "13"
		AADD( aProg2, aAux[nI] )
	EndIf
Next nI

	
// Pontuais	
If Len(aPontual) > 0
	cTempo := ""
	aOsAtend := {}
	OSPend := {}
	aTot := { 0,0,0,0,0,0,0,0,0,0 }
	nTot := Len(aPontual)
 	nCnt := 0
	nTotPrazo := 0
	nTotAtraso := 0
	nTmpMed := 0	// tempo medio de atendimento
	nMaxDslc := 0
	nMaxTime := 0
	nTotTmpAtr := 0
	nAtdProg := 0
 	nTotSales := 0
 	aDias := {}
 	For nJ := 1 To Len(aPontual) 				
		lPrazoOK := aPontual[nJ][9]
		dDtIni := aPontual[nJ][22]
		cHrIni := aPontual[nJ][23]
		dDtFim := aPontual[nJ][21]
		cHrFim := aPontual[nJ][20]
		dDtAg := aPontual[nJ][10]
		cHrAg := aPontual[nJ][11]
		nTmpAtend := aPontual[nJ][8]
		cPatr := aPontual[nJ][16]
		cCodCli := aPontual[nJ][14]
		cLoja := aPontual[nJ][15]
		
		fHrTurn( aPontual[nJ][1],@cHrTurn1,@cHrTurn2,@cHrTurn3,@cHrTurn4 )
		
		lDataOk := .F.
		For nK := 1 To Len(aDias)
			If aDias[nK] == dDtFim
				lDataOk := .T.
			EndIf
		Next nK
		
		If !lDataOk
			AADD( aDias, dDtFim )
			nDias++
		EndIf
			 
		nTmpDeslc := 0
		nTmpAtras := 0
		If lPrazoOK
			nTotPrazo++
		Else            
			nTmpAtras := IntToHora(SubtHoras(dDtAg, cHrAg,dDtFim,cHrFim))
			nTotTmpAtr := SomaHoras(nTotTmpAtr,nTmpAtras)
			nTotAtraso++
		EndIf
	
  		// tempo medio
		nTmpMed := Somahoras(nTmpMed,nTmpAtend)
		
		If nJ == 1 .OR. dDiaAnt <> dDtFim
			If !Empty(cHrTurn1)
				cHrAnt := cHrTurn1
			Else
				cHrAnt := "08:00:00"			
			EndIf                   
		EndIf
		
		// tempo de atendimento
		nTmpUti := HoraToInt(nTmpAtend)
		If nTmpUti > nMaxTime
			nMaxTime := nTmpUti
		EndIf
		
		// tempo de deslocamento
  		nTmpDeslc := SubHoras( cHrIni,cHrAnt )
 		If nTmpDeslc > nMaxDslc		  		               
	  		nMaxDslc := nTmpDeslc  
	  	EndIf
  			  		
  		AADD( aPontual[nJ], IIF(ValType(nTmpAtend)=="C",HoraToInt(nTmpAtend),nTmpAtend) )	// 27 
  		AADD( aPontual[nJ], IIF(ValType(nTmpDeslc)=="C",HoraToInt(nTmpDeslc),nTmpDeslc) ) 	// 28
  		AADD( aPontual[nJ], IIF(ValType(nTmpAtras)=="C",HoraToInt(nTmpAtras),nTmpAtras) ) 	// 29
  		AADD( aPontual[nJ], 0 )																// 30
       	
       	cHrAnt := cHrFim
       	dDiaAnt := dDtFim
	Next nJ	

	// OS pendentes	   
	aOsPend := OSPend(cAgente,dDataF,lAcumulado)
	cTempo := 0
	nQtdAtras := 0
	cHrAtual := Time()
	For nJ := 1 To Len(aOsPend)
		cNumOs := aOsPend[nJ][1]
		dDtAg := aOsPend[nJ][2]
		cHrAg := aOsPend[nJ][3]
		
		// atrasada ?
		nTmpAtras := 0
		nTmpAtras := IntToHora(SubtHoras(dDtAg, cHrAg,dDataF,cHrAtual))
		cTempo := Somahoras( cTempo,nTmpAtras )
		nQtdAtras++

		
		AADD( aOSPend[nJ], IIF(ValType(nTmpAtras)=="C",HoraToInt(nTmpAtras),nTmpAtras)  )	// 11		
	Next nJ
	
	// coluna 2 - tempo medio OS EM ATRASO
	nMediaPont := 0
	If !lAcumulado// .And. cTempo > 0
		nMediaPont := cTempo/nQtdAtras
	Else
		nMediaPont := nTotTmpAtr/nTotAtraso
	EndIf
                            
	// coluna 3 - produtividade
	If !lAcumulado
		nDiasTrab := 1
	Else 
		nDiasTrab := nDias
	EndIf
	nProd := Round( nTot/nDiastrab,2 )
                                                     
	// coluna 4 - tempo medio atendimento - abertura finalizacao
	nTmpMedio := nTmpMed/nTot
	cTempo := nTmpMed	// tempo total execucao dos atendimentos
                                    
	// Atendimento da programacao das OS
	nQtdOSProg := QtdProg(cAgente, dDataF, lAcumulado, 1)
	nAtdProg := Round( (nTot/nQtdOSProg) * 100,2 )
               
    aTot[1] := nTot
    aTot[2] := nTotPrazo
    aTot[3] := nTotAtraso
    aTot[4] := nProd
    aTot[5] := nTmpMedio
    aTot[6] := nMediaPont
    aTot[7] := nMaxDslc
	aTot[8] := nMaxTime
	aTot[9] := nAtdProg
	aTot[10] := nTotSales

    // dados para relatorio
	AADD( aDados, { 1,;					// pontuais
					aTot,;				// totais
					aPontual,;			// OS finalizadas
					aOsPend })			// OS pendentes
EndIf			 
                         	
 
// Programadas - sangria abastecimento
If Len(aProg1) > 0
	aDias := {}
	For dDia := dDataI To dDataF
		AADD( aDias, {dDia,{}} )
	Next dDia

	For nI := 1 To Len(aDias)    
		dDia := aDias[nI][1]
		For nJ := 1 To Len(aProg1)
			If aProg1[nJ][21] == dDia
				AADD( aDias[nI][2], aProg1[nJ] )
			EndIf
		Next nJ
	Next nI

	// ABASTECIMENTO SANGRIA
	nTotDias := 0
	nQtd := 0
	nTmpMed := 0
	nIndEfi := 0
	nTmp := 0
	nTot := Len(aProg1) 
	nTotSales := 0
	nXTS := 0
	nSales := 0
	nTotPrazo := 0
	nTotAtraso := 0
	nTotPend := 0
	nTotCanc := 0
	nMaxDslc := 0
	nMaxTime := 0
	nAtdPrzo := 0
	nAtdProg := 0
	nPercAbast := 0
	nTmpTotal := 0 
	nTGasto := 0 
	nTeste := ""
	nTmpDesloc := ""
	nTotTurno := ""
	nTotCapac := 0
	nPrcTmp := 0
	nPrcTmpDsl := 0
	nTotCorrec := 0
	nAXS := 0
	
	aTot := { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 }
	
	// alterar logica para tratar por data todos os calculos
	// motivo - tempo deslocamento dia - sales dia - abastecimento dia
	aPatrSales := {}
	aAux := {}
	aOSAtend := {}
    For nI := 1 To Len(aDias)
    	If !Empty(aDias[nI][2])
			aOsAtend := Aclone(aDias[nI][2])
			
			cPatrAnt := ""
	
			dDiaAnt := stod("")
			For nJ := 1 To Len(aOsAtend)
				nCapcidade := 0
				
				lPrazoOK := aOsAtend[nJ][9]
				dDtIni := aOsAtend[nJ][22]
				cHrIni := aOsAtend[nJ][23]
				dDtFim := aOsAtend[nJ][21]
				cHrFim := aOsAtend[nJ][20]
				dDtAg := aOsAtend[nJ][10]
				cHrAg := aOsAtend[nJ][11]
				nTmpAtend := aOsAtend[nJ][8]
				cPatr := aOsAtend[nJ][16]
				cCodCli := aOsAtend[nJ][14]
				cLoja := aOsAtend[nJ][15]
				nCapcidade := RetCapac(cPatr)
				nCorrec := fCorrec( aOsAtend[nJ][1] )
				nAbast := 0
				nTmpDeslc := 0
				nTmpAtras := 0
				nTeste := 0
				nSales := 0
				//lSaleOk := .F.
							                         
				If aScan( aPatrSales, { |x| x[1] == cPatr } ) == 0
					AADD( aPatrSales, { cPatr,cCodCli,cLoja } )
				EndIf

				//If !lSaleOk
					//nSales := STATICCALL( TTPROR07,fTotItens,cCodCli,cLoja,dDtFim,dDtFim,cPatr,aOsAtend[nJ][1] )
				nSales := STATICCALL( TTPROR07,fTotItens,cCodCli,cLoja,dDtFim,dDtFim,cPatr,aOsAtend[nJ][1] )
					//nTotSales += nSales
				//EndIf
				nXTS += nSales
				
		  		// tempo medio
				nTmpMed := Somahoras(nTmpMed,nTmpAtend)
				
				If nJ == 1      		
					fHrTurn(aOsAtend[nJ][1],@cHrTurn1,@cHrTurn2,@cHrTurn3,@cHrTurn4)
					If Empty(cHrTurn2)
						cHrTurn2 := "12:00:00"
					EndIf					
					If !Empty(cHrTurn1)
						cHrAnt := cHrTurn1
					Else
						cHrAnt := "08:00:00"	
					EndIf
				EndIf
				  	    
				// tempo de deslocamento 
				// tempo entre finalizacao da anterior e proxima OS
		  		nTmpDeslc := IntToHora( SubtHoras(dDtFim, cHrAnt,dDtFim,cHrIni) ) //SubHoras( cHrIni,cHrAnt )
		  		If lPrazoOK
		  			nTotPrazo++
		  			nQtd++
		  		Else
			  		nTmpAtras := IntToHora(SubtHoras(dDtAg, cHrAg,dDtFim,cHrFim))
			  		nTotAtraso++
		  		EndIf
		  		
		  		If HoraToInt(nTmpDeslc) > nMaxDslc		  		               
		  			nMaxDslc := HoraToInt(nTmpDeslc)  
		  		EndIf
		  		
		  		// incrementa tempo total de deslocamento
		  		nTmpDesloc := SomaHoras(nTmpDesloc,nTmpDeslc)
		  		
				// tempo de atendimento
				cTmpAtend := StrTran( aOsAtend[nJ][8],".",":" )
				//nTmpUti := HoraToInt(cTmpAtend)
			                
				// tempo gasto
				cTempo := Somahoras(cTempo,cTmpAtend)
				
				nTGasto := IntToHora( SubtHoras(dDtIni,cHrIni,dDtFim,cHrFim) )
				If Empty(nTeste)
					nTeste := nTGasto
				Else
					nTeste := SomaHoras( nTeste, nTGasto ) //STATICCALL( XZZZ,SomaHr,nTeste,nTGasto )
				EndIf
			
				     
				
				// MAIOR TEMPO GASTO
				If HoraToInt(nTGasto) > nMaxTime
					nMaxTime := HoraToInt(nTGasto)
				EndIf
				              
				// tempo programado
				If nJ == 1
					If !Empty(cHrTurn1)
						cHrIni := cHrTurn1
					Else
						cHrIni := "08:00:00"	
					EndIf
					                 
					cHrAgAnt := aProg1[nJ][11]
					cTmpAux2 := SubHoras( cHrAgAnt,cHrIni ) 
				Else
					cHrAgAnt := aProg1[nJ-1][11]
					cTmpAux2 := SubHoras( aProg1[nJ][11], cHrAgAnt )        
				EndIf
				cTempo2 := Somahoras( cTempo2, cTmpAux2 )
				
				// percentual de abastecimento
				nAbast := Round( ( nSales/nCapcidade ) * 100, 2 )
				
				// incrementa capacidade total das maquinas
				nTotCapac += nCapcidade
				
				// total correcao
				nTotCorrec += nCorrec
								
		  		AADD( aOSAtend[nJ], IIF(ValType(nTmpAtend)=="C",HoraToInt(nTmpAtend),nTmpAtend)  )		// 27 
		  		AADD( aOSAtend[nJ], IIF(ValType(nTmpDeslc)=="C",HoraToInt(nTmpDeslc),nTmpDeslc)  ) 		// 28
		  		AADD( aOSAtend[nJ], IIF(ValType(nTmpAtras)=="C",HoraToInt(nTmpAtras),nTmpAtras)  ) 		// 29
		  		AADD( aOSAtend[nJ], nSales )															// 30 total sales
				AADD( aOSAtend[nJ], nAbast )															// 31 percentual abastecimento
				AADD( aOSAtend[nJ], nCorrec )															// 32 total correcoes numerador
		                                    
				AADD( aAux, aOSAtend[nJ] )
		
		  		cHrAnt := cHrFim
		  		dDiaAnt := dDtFim									
			Next nJ
			
	  		// acumula total de turno para os dias
	  		If !Empty(cHrTurn1)
				cTempoTurn := ElapTime( StrTran( cHrTurn1,".",":" ), IIF(!Empty(cHrTurn4),cHrTurn4,cHrTurn2) )
				nTotTurno := Somahoras( nTotTurno,cTempoTurn )
			Else
				nTotTurno := 0
				Conout( "POSICAO " +cvaltochar(nI) +" -> SEM HORARIO")
			EndIf
			
			// acumula total de dias trabalhados
			nTotDias++
			
			// ultimo dia
			If nI = Len(aDias)
				
			EndIf
		EndIf
    Next nI

	For nI := 1 To Len(aPatrSales)
		//nAxS := 0
		For dDia := dDataI To dDataF
			nTotSales += STATICCALL( TTPROR07,fTotItens,aPatrSales[nI][2],aPatrSales[nI][3],dDia,dDia,aPatrSales[nI][1] )
		Next dDia
	
		//nTotSales += nAXS
    Next nI
    
    If nTotSales <> nXTS
    	nTotSales := nXTS
    EndIf
    
    aProg1 := aClone(aAux)
    
    // tempo gasto - em horas
//    If nTeste > 0
	If !Empty(nTeste)
    	aAXGT := {}
	    If "." $ cvaltochar(nTeste)
		    aAXGT := StrToKarr( cvaltochar(nTeste),"." )
	    EndIf                                           
	    If Empty(aAXGT)
	    	//cHrGT := StrZero(nTeste,2) +":00"
	    	cHrGT := nTeste
	    Else
	    	cHrGT := StrZero( Val(aAXGT[1]),2 ) +":" +StrZero( Val(aAXGT[2]),2)
	    EndIf
	Else
		cHrGT := StrZero(nTeste,2) +":00"           
    EndIf
     
    If ValType( nTeste ) == "C"
    	nTeste := HoraToInt( nTeste )
    EndIf
    
    cTempo := nTeste
    
	// Atendimento das OS no prazo                                      
	nQtdOSProg := QtdProg( cAgente, dDataF,lAcumulado,2 )
	nAtdPrzo := Round( ( nTotPrazo/nQtdOSProg) * 100,2 )
	
	// Atendimento da programacao das os
	nAtdProg := Round( (nTot/nQtdOSProg) * 100,2 )
	
	// Indice de eficiencia
	nIndEfi := Round( (cTempo2/cTempo) * 100,2 )
	
	// total pendente
	nTotPend := nQtdOSProg - nTot
	
	// total canceladas
	nTotCanc := OSCanc(cAgente, dDataF, lAcumulado)
	                   
	// percentual de abastecimento
	nPercAbast := Round( ( nTotSales / nTotCapac ) * 100,2 )
	
	// tempo total gasto em atendimento - horas turno * dias
	nTmpTotal := nTeste
				       
	// Programacao e controle de abastecimento - indice de ociosidade
	// tempo de execucao das os atendidas / tempo disponivel de trabalho (hora diaria - hora que sobrou apos finalizar tudo) * 100
	nIndOci := Round( (1-(cTempo/nTotTurno)) * 100,2 )	// rever arredondamento do calculo - funcoes subhoras somahoras
	
	// percentual de tempo gasto
	nPrcTmp := Round( (HoraToInt(cHrGT )/nTotTurno) * 100,2 )	//Round( (nTmpTotal/nTotTurno) * 100,2 )

	// percentual de tempo gasto em deslocamento
	nPrcTmpDsl := Round( (nTmpDesloc/nTotTurno) * 100,2 )		

    	
	aTot[1] := nTot
    aTot[2] := nTotPrazo
    aTot[3] := nTotAtraso
    aTot[4] := nTotPend
    aTot[5] := nTotCanc
    aTot[6] := nMaxDslc
	aTot[7] := nMaxTime
	aTot[8] := nAtdPrzo
	aTot[9] := nAtdProg
	aTot[10] := nTotSales
	aTot[11] := nIndOci
	aTot[12] := nPercAbast
	aTot[13] := nTmpTotal
	aTot[14] := nTmpDesloc
	aTot[15] := nPrcTmp
	aTot[16] := nPrcTmpDsl
	aTot[17] := nTotCorrec
			    	             	   
	// dados para relatorio
	AADD( aDados, { 2,;			// sangria abast
					aTot,;		// totais
					aProg1,;	// OS finalizadas prog
					{} })		// OS pendentes prog
			
EndIf		

     
// Entregas
If Len(aProg2) > 0
	nQtd := 0
	aTot := { Nil,Nil,0 }
	cTpForm := "13"
	For nJ := 1 To Len(aProg2)
		If aProg2[nJ][9]	// somente OS atendidas no prazo   
			nQtd++
		EndIf
	Next nJ
	
	// ( notas atendidas no prazo / total de notas ) * 100 
	nTotProg := TotProg(cAgente, dDataF)
	nAtendPrazo := Round( (nQtd/nTotProg) * 100,2 )
	
	// soma notas atendidas no mes - ate o momento
	nQtdAtend := Round( TotAtend(cAgente,dDataF,cTpForm),2 )	// form tipo 13                                                           
	
	aTot[1] := nAtendPrazo
	aTot[2] := nQtdAtend
	                       	
	// dados para relatorio
	AADD( aDados, { 3,;			// entregas
					aTot,;		// totais
					aProg2,;	// OS finalizadas
					{} })		// OS pendentes
EndIf


RECOVER
	ConOut( ProcName() + " " + Str(ProcLine()) + " " + oError:ErrorStack )
END SEQUENCE 


Return aDados


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfCorrec  บAutor  ณJackson E. de Deus   บ Data ณ  31/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna correcoes do numerador atual                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fCorrec(cNumOS)

Local csql := ""
Local nTot := 0

cSql := "SELECT ZL_DATA,COUNT(*) TOTAL FROM " +RetSqlName("SZL") +" WHERE ZL_MODULO = 'TTPROC30' AND ZL_DOCTO = '"+cNumOS+"' AND ZL_OBS LIKE '%Apontamento alterado%' AND D_E_L_E_T_ = '' GROUP BY ZL_DATA"

If Select("TRBA") > 0
	TRBA->(dbCloseArea())
EndIf                   

TcQuery cSql New Alias "TRBA"

dbSelectArea("TRBA")
While !EOF()
	nTot++
	TRBA->( dbSkip() )
End

Return nTot


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ OSPend  บAutor  ณJackson E. de Deus   บ Data ณ  06/02/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna OS pendentes para o agente	                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function OSPend(cAgente,dData,lAcumulado)
            
Local cSql := ""
Local aOS := {}  
Local lAtraso := .F.
Local cCodPA := ""
Local cDescPA := ""

cSql := "SELECT ZG_CLIFOR, ZG_LOJA, ZG_DATAINI DTAGEN, ZG_HORAINI HRAGEN, ZG_DTCRIAC DTCRIAC, ZG_HRCRIAC HRCRIAC, ZG_NUMOS, ZG_PATRIM, ZG_PATRIMD, ZG_ROTA, AB2_MEMO  "
cSql += " FROM " +RetSqlName("SZG") +" SZG"
cSql += " INNER JOIN " +RetSqlName("AB2") +" AB2 ON AB2_XOSMOB = ZG_NUMOS AND AB2.D_E_L_E_T_ = '' "
cSql += " WHERE "
cSql += " ZG_CODTEC = '"+cAgente+"' "

If lAcumulado
	cSql += " AND ZG_DATAINI < '"+dtos(dDAta)+"' "
Else
	cSql += " AND ZG_DATAINI = '"+dtos(dDAta)+"' "
EndIf

cSql += " AND SZG.D_E_L_E_T_ = '' AND ZG_STATUS NOT IN ('COPE','CTEC','CCLI','FIOK','INCO') "
cSql += " AND ZG_TPFORM IN ( '5','6','7' ) "	// formulario de chamado

If Select("TRB2") > 0
	TRB2->(dbCloseArea())
EndIf
                       
TcQuery cSql New Alias "TRB2"
dbSelectArea("TRB2")

While !EOF()              
	lAtraso := .F.
	cCodPA := ""
	cDescPA := ""
	fRetPA(TRB2->ZG_CLIFOR, TRB2->ZG_LOJA,@cCodPa,@cDescPA)
	
	cTime := Time()
	If STOD(TRB2->DTAGEN) < dData
		lAtraso := .T.	
	ElseIf STOD(TRB2->DTAGEN) == dData
		If TRB2->HRAGEN < cTime
			lAtraso := .T.
		EndIf	
	EndIf
	If lAtraso
		AADD( aOS, { TRB2->ZG_NUMOS, stod(TRB2->DTAGEN), TRB2->HRAGEN, stod(TRB2->DTCRIAC),;
	 			TRB2->HRCRIAC, TRB2->ZG_PATRIM, TRB2->ZG_PATRIMD, MSMM(TRB2->AB2_MEMO), cCodPA, cDescPA  } )
	EndIf			
	dbSkip()
End

TRB2->(dbcloseArea())

Return aOS


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fRetPA  บAutor  ณJackson E. de Deus   บ Data ณ  06/02/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna dados da PA do cliente							  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fRetPA(cCodCli,cLoja,cCodPa,cDescPA)

Local aArea := GetArea()
Local cSql := ""

cSql := "SELECT ZZ1_COD, ZZ1_DESCRI FROM " +RetSqlName("ZZ1") +" WHERE SUBSTRING(ZZ1_ITCONT,1,10) = '"+cCodCli+cLoja+"' AND D_E_L_E_T_ = '' AND ZZ1_FILIAL = '"+xFilial("ZZ1")+	"' "

If Select("TRB3") > 0
	TRB3->(dbCloseArea())
EndIf
                       
TcQuery cSql New Alias "TRB3"
dbSelectArea("TRB3")

If !EOF()
	cCodPa := AllTrim(TRB3->ZZ1_COD)
	cDesCPA := AllTrim(TRB3->ZZ1_DESCRI)
EndIf

RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Turno  บAutor  ณJackson E. de Deus    บ Data ณ  06/02/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna horarios de turno - inicio - almoco - fim          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Turno(cTurno,dData) 

Local aAuxHr := {"","","",""}
Local cSql := ""
Local aArea := GetArea()

cSql := "SELECT PJ_ENTRA1, PJ_SAIDA1, PJ_ENTRA2, PJ_SAIDA2 FROM " +"SPJ010"
cSql += " WHERE PJ_TURNO = '"+cTurno+"' AND PJ_DIA = '"+CVALTOCHAR(Dow(dData))+"' AND D_E_L_E_T_ = '' "

If Select("TRBP") > 0
	TRBP->(dbCloseArea())
EndIf

TcQuery cSql New Alias "TRBP"
dbSelectArea("TRBP")        
If !EOF() 
	aAuxHr[1] := IntToHora(TRBP->PJ_ENTRA1) +":00"
	aAuxHr[2] := IntToHora(TRBP->PJ_SAIDA1) +":00"
	aAuxHr[3] := IntToHora(TRBP->PJ_ENTRA2) +":00"
	aAuxHr[4] := IntToHora(TRBP->PJ_SAIDA2) +":00"
EndIf

RestArea(aArea)

Return aAuxHr



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetCapac  บAutor  ณJackson E. de Deus  บ Data ณ  19/02/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna a capacidade da maquina                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RetCapac(cPatr)

Local cSql := ""
Local cProduto := Posicione("SN1",2,xFilial("SN1")+AvKey(cPatr,"N1_CHAPA"),"N1_PRODUTO")
Local nCapac := 0                 

If Empty(cProduto)
	Return nCapac
EndIf

cSql := "SELECT ZZP_CAPAC FROM " +RetSqlName("ZZP")
cSql += " WHERE ZZP_CODIGO = '"+cProduto+"' "

If Select("TRB2") > 0
	TRB2->(dbCloseArea())
EndIf
                       
TcQuery cSql New Alias "TRB2"
dbSelectArea("TRB2")

If !EOF()
	nCapac := TRB2->ZZP_CAPAC
End

TRB2->(dbCloseArea())                      
      
Return nCapac

                                      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ChkQtd  บAutor  ณJackson E. de Deus   บ Data ณ  20/01/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ OS atrasada - chamado tecnico                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkQtd(cAgente, dData)

Local cSql := ""
Local cHora := ""
Local cTmpAtras := ""
Local nQtd := 0 
Local aRet := {}
Local cHrAux := "" 

cSql := "SELECT ZG_DATAINI, ZG_HORAINI "
cSql += " FROM SZG010 "
cSql += " WHERE ZG_AGENTE = '"+cAgente+"' AND ZG_DATAINI = '"+dtos(dDAta)+"' "
cSql += " AND ZG_TPFORM IN ('7','14','15') AND ZG_DATAFIM = '' AND ZG_HORAFIM = '' AND D_E_L_E_T_ = '' "
cSql += " AND ZG_STATUS NOT IN ('COPE','CTEC','CCLI','FIOK') "

If Select("TRB2") > 0
	TRB2->(dbCloseArea())
EndIf
                       
TcQuery cSql New Alias "TRB2"
dbSelectArea("TRB2")

cHora := Time()
While !EOF()
	If TRB2->ZG_HORAINI < cHora
		cHrAux := SubHoras( cHora, TRB2->ZG_HORAINI )
		cTmpAtras := SomaHoras( cHrAux, cTmpAtras ) 
		nQtd++
	EndIf
	dbSkip()
End
                      
If Empty(cTmpAtras)
	cTmpAtras:=0
EndIf
AADD(aRet, cTmpAtras)
AADD(aRet, nQtd)

Return aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ChkProd  บAutor  ณJackson E. de Deus  บ Data ณ  20/01/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o tempo medio ate atendimento                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkProd(cAgente,dData)
                                     
Local nQtdProg := 0
Local cSql := ""
Local cTmpAteIni := ""
Local aRet := {}
Local cTempo := ""
Local nQtd := 0
           
cSql := "SELECT ZK_DTCRIAC, ZK_HRCRIAC, ZK_DTFIM, ZK_HRFIM "
cSql += " FROM SZK010 SZK "
cSql += " INNER JOIN " +RetSqlName("SZG") +" SZG ON "
cSql += " ZK_NUMOS = ZG_NUMOS AND SZK.D_E_L_E_T_ = SZG.D_E_L_E_T_ "

cSql += " WHERE "
cSql += " ZK_AGENTE = '"+cAgente+"' "
cSql += " AND ZK_DTAGEND BETWEEN '"+dtos(FirstDay(dData))+"' AND '"+dtos(dData)+"' "
cSql += " AND ZK_DTFIM BETWEEN '"+dtos(FirstDay(dData))+"' AND '"+dtos(dData)+"' "
cSql += " AND SZK.D_E_L_E_T_ = '' "
cSql += " AND ZG_TPFORM = '7' "


If Select("TRB2") > 0
	TRB2->(dbCloseArea())
EndIf
                       
TcQuery cSql New Alias "TRB2"
dbSelectArea("TRB2")

While !EOF()
	//cTmpAteIni := TRB2->ZK_TMPINI
	cTempo := SomaHoras(cTempo,TRB2->ZK_HRCRIAC)
	nQtd++
	dbSkip()
End

If Empty(cTempo)
	cTempo:=0
EndIf
AADD(aRet, cTempo)
AADD(aRet, nQtd)               

Return aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ QtdProg  บAutor  ณJackson E. de Deus  บ Data ณ  20/01/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna a Qtd de OS programada sangria abastecimento       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function QtdProg(cAgente, dData, lAcumulado, nTpForms)

Local nQtd := 0
Local cSql := ""
Local cHora := ""
Local cTmpAtras := ""
Local nQtd := 0

If nTpForms == 1
	cForms := "('5','6','7','16','17')"
ElseIf nTpForms == 2
	cForms := "('2','3','4','8')"
EndIf

cSql := "SELECT COUNT(*) TOTAL "
cSql += " FROM " +RetSqlName("SZG")
cSql += " WHERE ZG_CODTEC = '"+cAgente+"' "
If !lAcumulado
	cSql += " AND ZG_DATAINI = '"+dtos(dDAta)+"' "
Else
	cSql += " AND ZG_DATAINI BETWEEN '"+dtos(FirstDay(dDAta))+"' AND '"+dtos(dData)+"' "
EndIf

cSql += " AND ZG_TPFORM IN " +cForms +" AND ZG_STATUS NOT IN ( 'COPE','CCLI' ) AND D_E_L_E_T_ = '' "	// trazer tambem as canceladas - 18/02 Sol. Gustavo
If Select("TRB2") > 0
	TRB2->(dbCloseArea())
EndIf
                       
TcQuery cSql New Alias "TRB2"
dbSelectArea("TRB2")

If !EOF()
	nQtd := TRB2->TOTAL
EndIf

Return nQtd


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณOSCanc  บAutor  ณJackson E. de Deus    บ Data ณ  06/02/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Total de OS Cancelada na data                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function OSCanc(cAgente, dData, lAcumulado)

Local nQtd := 0
Local cSql := ""
Local cHora := ""
Local cTmpAtras := ""
Local nQtd := 0

cSql := "SELECT COUNT(*) TOTAL "
cSql += " FROM " +RetSqlName("SZG")
cSql += " WHERE ZG_CODTEC = '"+cAgente+"' "
If !lAcumulado
	cSql += " AND ZG_DATAINI = '"+dtos(dDAta)+"' "
Else
	cSql += " AND ZG_DATAINI BETWEEN '"+dtos(FirstDay(dDAta))+"' AND '"+dtos(dData)+"' "
EndIf
	
cSql += " AND ZG_TPFORM NOT IN ( '5','6','7','16','17' ) AND ZG_STATUS IN ( 'CTEC','COPE','CCLI' ) AND D_E_L_E_T_ = '' "	// retirada opcao para trazer cancelada pelo agente CTEC - 18/02 - Sol. Gustavo

If Select("TRB2") > 0
	TRB2->(dbCloseArea())
EndIf
                       
TcQuery cSql New Alias "TRB2"
dbSelectArea("TRB2")

If !EOF()
	nQtd := TRB2->TOTAL
EndIf


Return nQtd         



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TotProg บAutor  ณJackson E. de Deus   บ Data ณ  20/01/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna a Qtd de OS programada de entrega                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TotProg(cAgente,dData)

Local nQtdProg := 0
Local cSql := ""
           
cSql := "SELECT COUNT(*) TOTAL "
cSql += " FROM SZG010 "

cSql += " WHERE ZG_CODTEC = '"+cAgente+"' AND ZG_DTCRIAC BETWEEN '"+dtos(FirstDay(dData))+"' AND '"+dtos(dData)+"' "
cSql += " AND D_E_L_E_T_ = '' "
cSql += " AND ZG_TPFORM = '13' "

If Select("TRB2") > 0
	TRB2->(dbCloseArea())
EndIf
                       
TcQuery cSql New Alias "TRB2"
dbSelectArea("TRB2")

If !EOF()
	nQtdProg := TRB2->TOTAL
EndIf               

Return nQtdProg
			

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TotAtend  บAutor  ณJackson E. de Deus บ Data ณ  20/01/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna a Qtd de OS atendidas                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TotAtend(cAgente,dData,cTpForm)

Local nQtd := 0
Local cSql := ""
           
cSql := "SELECT COUNT(*) TOTAL "
cSql += " FROM SZK010 SZK "
cSql += " INNER JOIN " +RetSqlName("SZG") +" SZG ON "
cSql += " ZK_NUMOS = ZG_NUMOS AND SZK.D_E_L_E_T_ = SZG.D_E_L_E_T_ "

cSql += " WHERE ZK_CODTEC = '"+cAgente+"' AND ZK_DTFIM BETWEEN '"+dtos(FirstDay(dData))+"' AND '"+dtos(dData)+"' "
cSql += " AND SZK.D_E_L_E_T_ = '' "
cSql += " AND ZG_TPFORM = '"+cTpForm+"' AND ZG_STATUS = 'FIOK' "

If Select("TRB2") > 0
	TRB2->(dbCloseArea())
EndIf
                       
TcQuery cSql New Alias "TRB2"
dbSelectArea("TRB2")

If !EOF()
	nQtd := TRB2->TOTAL
EndIf

Return nQtd


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FimOS  บAutor  ณJackson E. de Deus    บ Data ณ  20/01/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna a hora da ultima OS atendida no dia                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FimOS(cAgente,dData)
                
Local cHora := ""
Local cSql := ""
           
cSql := "SELECT TOP 1 ZK_HRFIM FROM " +RetSqlName("SZK") +" WHERE ZK_DTFIM = '"+dtos(dData)+"' "
cSql += "AND ZK_AGENTE = '"+cAgente+"' "
cSql += "ORDER BY ZK_HRFIM DESC "

If Select("TRB2") > 0
	TRB2->(dbCloseArea())
EndIf
                       
TcQuery cSql New Alias "TRB2"
dbSelectArea("TRB2")

If !EOF()
	cHora := TRB2->ZK_HRFIM
EndIf            

Return cHora



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfHrTurn  บAutor  ณJackson E. de Deus   บ Data ณ  19/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna os horarios do turno com base nas respostas da OS  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fHrTurn(cNumOS,cHrTurn1,cHrTurn2,cHrTurn3,cHrTurn4)

Local aArea := GetArea()

cHrTurn1 := ""
cHrTurn2 := ""
cHrTurn3 := ""
cHrTurn4 := ""

dbSelectArea("SZK")
dbSetOrder(1)
If dbSeek( xFilial("SZK") +AvKey(cNumOs,"ZK_NUMOS") )
	cHrTurn1 := SZK->ZK_ENTRA1
	cHrTurn2 := SZK->ZK_SAIDA1
	cHrTurn3 := SZK->ZK_ENTRA2
	cHrTurn4 := SZK->ZK_SAIDA2
	
	cHrTurn1 := StrTran( cHrTurn1,".",":"  )
	cHrTurn2 := StrTran( cHrTurn2,".",":"  )
	cHrTurn3 := StrTran( cHrTurn3,".",":"  )
	cHrTurn4 := StrTran( cHrTurn4,".",":"  )	
EndIf

RestArea(aArea)

Return
			

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MailTec  บAutor  ณJackson E. de Deus  บ Data ณ  20/01/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia o email para o atendente                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MailTec(aDados,cAtend,dData)

Local cRemete := "microsiga"
Local cdestino := _cMail //"lbsantos@toktake.com.br;jnascimento@toktake.com.br;cpomini@toktake.com.br"
Local cAssunto := "Indicadores"
Local cHtml := ""
Local aAttach := {}
Local aAux := {}
Local cAtend := aDados[1]
Local cSuper := aDados[2]
Local cGeren := aDados[3]
Local nI,nJ
Local aTot := {}
Local aTotAcm := {}
Local aOS := {}
Local aOsPend := {}
Local aInfo := {}
Local nTmpTotal := 0
Local nTmpDesloc := 0

For nI := 4 To Len(aDados)
	AADD( aInfo, aDados[nI] )
Next nI

// OS pontuais - chamados
For nI := 1 To Len(aInfo)
	If aInfo[nI][1] <> 1
		Loop
	EndIf
	
	cHtml := "<html>" +CRLF
	cHtml += "<head>"+CRLF
	cHtml += "<title>" +cAssunto +"</title>" +CRLF
				
	// Estilos
	cHtml += "<style type='text/css'>"	+CRLF
	cHtml += "	table.bordasimples {border-collapse: collapse;}"	+CRLF
	cHtml += "	table.bordasimples tr td {border:1px solid #999999 ;}"	+CRLF
	cHtml += "	body { background-color: #FFFFFF;"	+CRLF
	cHtml += "	color: #5D665B; "	+CRLF
	cHtml += "	margin: 10px;"	+CRLF
	cHtml += "	font-family: Georgia, 'Times New Roman', Times, serif;"	+CRLF
	cHtml += "	font-size: small;"	+CRLF
	//	cArqMail += "	line-height: 180%;"
	cHtml += " 	}"	+CRLF
	cHtml += "</style>"	+CRLF
	
	cHtml += "</head>"	+CRLF
	
	// Corpo
	cHtml += "<body>"	+CRLF
	
	cRota := Posicione("AA1",1,xFilial("AA1")+AvKey( cAtend,"AA1_CODTEC"),"AA1_LOCAL")
	cNomeTec := AllTrim(Posicione("AA1",1,xFilial("AA1")+AvKey( cAtend,"AA1_CODTEC"),"AA1_NOMTEC"))

	cTxtAtend := cNomeTec
	If !Empty(cRota)
		cTxtAtend += " - Rota " +cRota
	EndIf
	
	cHtml += "<p><strong>" +cTxtAtend +"</strong></p>"	+CRLF
//	cHtml += "<br>"
	                    	
	// chamado          
	aTot := ainfo[nI][2]
	aTotAcm := ainfo[nI][3]
	aOS := ainfo[nI][4]    
	aOsPend := ainfo[nI][5]
	ASort( aOS, , , { |x,y| x[27] > y[27] } )
		  		 
	// TOTAIS
	cHtml += "<table class='bordasimples' cellpadding='4'>"
	cHtml += "	<tr style='background:#90AFFF'>"
	cHtml += "		<td style='color:#FFFFFF'><b>Indicadores</b></td>"
	cHtml += "		<td style='color:#FFFFFF'><b>Unidade</b></td>"
	cHtml += "		<td style='color:#FFFFFF'><b>Acumulado at้ " +dtoc(dData) +"</b></td>"
	cHtml += "		<td style='color:#FFFFFF'><b>Resultado " +dtoc(dData) +"</b></td>"
	cHtml += "	</tr>"
			
	cHtml += "	<tr>"
	cHtml += "		<td>OS finalizadas</td>"
	cHtml += "		<td>Qtd</td>"
	cHtml += "		<td>" +CValToChar(aTotAcm[1]) +"</td>"
	cHtml += "		<td>" +CValToChar(aTot[1]) +"</td>"
	cHtml += "	</tr>"
	cHtml += "	<tr>"
	cHtml += "		<td>OS finalizadas no prazo</td>"
	cHtml += "		<td>Qtd</td>"
	cHtml += "		<td>" +CValToChar(aTotAcm[2]) +"</td>"
	cHtml += "		<td>" +CValTochar(aTot[2]) +"</td>"
	cHtml += "	</tr>"
	cHtml += "	<tr>"
	cHtml += "		<td>OS finalizadas em atraso</td>"
	cHtml += "		<td>Qtd</td>"
	cHtml += "		<td>" +CValToChar(aTotAcm[3]) +"</td>"
	cHtml += "		<td>" +CValToChar(aTot[3]) +"</td>"
	cHtml += "	</tr>"
	cHtml += "	<tr>"
	cHtml += "		<td>Produtividade</td>"
	cHtml += "		<td>Qtd/Dia</td>"
	cHtml += "		<td>" +CValToChar(aTotAcm[4]) +"</td>"
	cHtml += "		<td>" +CValToChar(aTot[4]) +"</td>"
	cHtml += "	</tr>"
	cHtml += "	<tr>"
	cHtml += "		<td>Tempo m้dio de atendimento</td>"
	cHtml += "		<td>Hora</td>"
	cHtml += "		<td>" +IntToHora(aTotAcm[5]) +"</td>"
	cHtml += "		<td>" +IntToHora(aTot[5]) +"</td>"
	cHtml += "	</tr>"
	cHtml += "	<tr>"
	cHtml += "		<td>Tempo m้dio de OS em atraso</td>"
	cHtml += "		<td>Hora</td>"
	cHtml += "		<td>" +IntToHora(aTotAcm[6]) +"</td>"
	cHtml += "		<td>" +IntToHora(aTot[6]) +"</td>"
	cHtml += "	</tr>"
	cHtml += "</table>"
	
	// DETALHE OS PENDENTES
	cHtml += "<br><br>"	+CRLF
	cHtml += "<br>"	+CRLF
	cHtml += "<b>OS Pendentes</b>"	+CRLF 
	cHtml += "<br>"	+CRLF
	cHtml += "<table class='bordasimples' cellpadding='4'>"	+CRLF
	cHtml += "<tr style='background:#90AFFF'>"	+CRLF
	cHtml += 	"<td style='color:#FFFFFF'><b>Data agendada</b></td>"	+CRLF
	cHtml += 	"<td style='color:#FFFFFF'><b>Hora agendada</b></td>"	+CRLF
	cHtml += 	"<td style='color:#FFFFFF'><b>OS</b></td>"	+CRLF
	cHtml += 	"<td style='color:#FFFFFF'><b>PA Cliente</b></td>"	+CRLF        
	cHtml += 	"<td style='color:#FFFFFF'><b>Patrim๔nio</b></td>"	+CRLF
	cHtml += 	"<td style='color:#FFFFFF'><b>Modelo</b></td>"	+CRLF
	cHtml += 	"<td style='color:#FFFFFF'><b>Obs sobre o defeito</b></td>"	+CRLF
	cHtml += 	"<td style='color:#FFFFFF'><b>Tempo de atraso</b></td>"	+CRLF
	cHtml += "</tr>"	+CRLF
		
	For nJ := 1 To Len(aOsPend)
		cHtml += "<tr>"	+CRLF                                
		cHtml += 	"<td>" +dtoc(aOsPend[nJ][2]) +"</td>"	+CRLF
		cHtml += 	"<td>" +aOsPend[nJ][3] +"</td>"	+CRLF
		cHtml += 	"<td>" +aOsPend[nJ][1] +"</td>"	+CRLF
		cHtml += 	"<td>" +aOsPend[nJ][10] +"</td>"	+CRLF
		cHtml += 	"<td>" +aOsPend[nJ][6] +"</td>"	+CRLF
		cHtml += 	"<td>" +aOsPend[nJ][7] +"</td>"	+CRLF
		cHtml += 	"<td>" +aOsPend[nJ][8] +"</td>"	+CRLF
		cHtml += 	"<td>" +IntToHora(aOsPend[nJ][11]) +"</td>"	+CRLF
		cHtml += "</tr>"	+CRLF
	Next nJ
		
	cHtml += "</table>"	+CRLF

	
	// DETALHES -> OS atendidas do dia
	cHtml += "<br><br>"	+CRLF
	cHtml += "<b>OS finalizadas</b>"	+CRLF
	cHtml += "<br>"	+CRLF 
	cHtml += "<table class='bordasimples' cellpadding='4'>"	+CRLF
	cHtml += "<tr style='background:#90AFFF'>"	+CRLF
	cHtml += 	"<td style='color:#FFFFFF'><b>Data Hora de inicializa็ใo</b></td>"	+CRLF
	cHtml += 	"<td style='color:#FFFFFF'><b>Data Hora de finaliza็ใo</b></td>"	+CRLF
	cHtml += 	"<td style='color:#FFFFFF'><b>Data Hora agendada</b></td>"	+CRLF
	cHtml += 	"<td style='color:#FFFFFF'><b>PA Cliente</b></td>"	+CRLF
	cHtml += 	"<td style='color:#FFFFFF'><b>OS</b></td>"	+CRLF        
	cHtml += 	"<td style='color:#FFFFFF'><b>Patrim๔nio</b></td>"	+CRLF        
	cHtml += 	"<td style='color:#FFFFFF'><b>Modelo</b></td>"	+CRLF	
	cHtml += 	"<td style='color:#FFFFFF'><b>Tempo de deslocamento</b></td>"	+CRLF
	cHtml += 	"<td style='color:#FFFFFF'><b>Tempo utilizado</b></td>"	+CRLF
	cHtml += 	"<td style='color:#FFFFFF'><b>Tempo de atraso</b></td>"	+CRLF
	cHtml += "</tr>"	+CRLF
		
  	For nJ := 1 To Len(aOS)
		cHtml += "<tr>"	+CRLF                                
		cHtml += 	"<td>" +dtoc(aOS[nJ][22]) +" " +aOS[nJ][23]  +"</td>"	+CRLF
		cHtml += 	"<td>" +dtoc(aOS[nJ][21]) +" " +aOS[nJ][20] +"</td>"	+CRLF
		cHtml += 	"<td>" +dtoc(aOS[nJ][10]) +" " +aOS[nJ][11] +"</td>"	+CRLF
		cHtml += 	"<td>" +aOS[nJ][26] +"</td>"	+CRLF
		cHtml += 	"<td>" +aOS[nJ][1] +"</td>"	+CRLF
	    cHtml += 	"<td>" +aOS[nJ][16] +"</td>"	+CRLF
		cHtml += 	"<td>" +aOS[nJ][17] +"</td>"	+CRLF
		cHtml += 	"<td>" +IntToHora(aOS[nJ][28]) +"</td>"	+CRLF
		cHtml += 	"<td>" +IntToHora(aOS[nJ][27])  +"</td>"	+CRLF
		cHtml += 	"<td>" +IntToHora(aOS[nJ][29]) +"</td>"	+CRLF
		cHtml += "</tr>"	+CRLF
	Next nJ	    

	cHtml += "</table>"	+CRLF
	                     	
	cHtml += "<br>"	+CRLF
	cHtml += "<br>"	+CRLF
	
	cHtml += "<p>" +Replicate("_",35) +"</p>"	+CRLF
	cHtml += "<p>E-mail automแtico enviado via protheus.</p>"	+CRLF
	cHtml += "<p>Favor nใo responder.</p>"	+CRLF
	cHtml += "</body>"	+CRLF
	cHtml += "</html>"	+CRLF

	cAssunto := "OS PT " +"DIA" +" - " +cNomeTec
	
	U_TTMailN( cRemete,cDestino,cAssunto,cHtml,aAttach,.F. )
Next nI


// OS programadas - sangria abast leitura
For nI := 1 To Len(aInfo)	
	If aInfo[nI][1] <> 2
		Loop
	EndIf
	
	cHtml := "<html>" +CRLF
	cHtml += "<head>"+CRLF
	cHtml += "<title>" +cAssunto +"</title>" +CRLF
				
	// Estilos
	cHtml += "<style type='text/css'>"	+CRLF
	cHtml += "	table.bordasimples {border-collapse: collapse;}"	+CRLF
	cHtml += "	table.bordasimples tr td {border:1px solid #999999 ;}"	+CRLF
	cHtml += "	body { background-color: #FFFFFF;"	+CRLF
	cHtml += "	color: #5D665B; "	+CRLF
	cHtml += "	margin: 10px;"	+CRLF
	cHtml += "	font-family: Georgia, 'Times New Roman', Times, serif;"	+CRLF
	cHtml += "	font-size: small;"	+CRLF
	//	cArqMail += "	line-height: 180%;"
	cHtml += " 	}"	+CRLF
	cHtml += "</style>"	+CRLF
	
	cHtml += "</head>"	+CRLF
	
	// Corpo
	cHtml += "<body>"	+CRLF
	
	
	cRota := Posicione("AA1",1,xFilial("AA1")+AvKey( cAtend,"AA1_CODTEC"),"AA1_LOCAL")
	cNomeTec := AllTrim(Posicione("AA1",1,xFilial("AA1")+AvKey( cAtend,"AA1_CODTEC"),"AA1_NOMTEC"))

	cTxtAtend := cNomeTec
	If !Empty(cRota)
		cTxtAtend += " - Rota " +cRota
	EndIf
	
	cHtml += "<p><strong>" +cTxtAtend +"</strong></p>"	+CRLF
						
	aTot := aInfo[nI][2]
	aTotAcm := aInfo[nI][3]
	aOS := aClone(aInfo[nI][4])
	nTmpTotal := aTot[13]
	nTmpDesloc := aTot[14]
				
	cHtml += "<table class='bordasimples' cellpadding='4'>"
	cHtml += "	<tr style='background:#90AFFF'>"
	cHtml += "		<td style='color:#FFFFFF'><b>Indicadores</b></td>"
	cHtml += "		<td style='color:#FFFFFF'><b>Unidade</b></td>"
	cHtml += "		<td style='color:#FFFFFF'><b>Acumulado at้ " +dtoc(dData) +"</b></td>"
	cHtml += "		<td style='color:#FFFFFF'><b>Resultado " +dtoc(dData) +"</b></td>"
	cHtml += "	</tr>"
			
	cHtml += "	<tr>"
	cHtml += "		<td>OS finalizadas</td>"
	cHtml += "		<td>Qtd</td>"
	cHtml += "		<td>" +CVALTOCHAR(aTotAcm[1]) +"</td>"
	cHtml += "		<td>" +CVALTOCHAR(aTot[1]) +"</td>"
	cHtml += "	</tr>"
	cHtml += "	<tr>"
	cHtml += "		<td>OS finalizadas no prazo</td>"
	cHtml += "		<td>Qtd</td>"
	cHtml += "		<td>" +CVALTOCHAR(aTotAcm[2]) +"</td>"
	cHtml += "		<td>" +CVALTOCHAR(aTot[2]) +"</td>"
	cHtml += "	</tr>"
	cHtml += "	<tr>"
	cHtml += "		<td>OS finalizadas em atraso</td>"
	cHtml += "		<td>Qtd</td>"
	cHtml += "		<td>" +CVALTOCHAR(aTotAcm[3]) +"</td>"
	cHtml += "		<td>" +CVALTOCHAR(aTot[3]) +"</td>"
	cHtml += "	</tr>"
	cHtml += "	<tr>"
	cHtml += "		<td>OS nใo finalizadas/canceladas agente</td>" 
	cHtml += "		<td>Qtd</td>"
	cHtml += "		<td>" +CVALTOCHAR(aTotAcm[4]) +"</td>"
	cHtml += "		<td>" +CVALTOCHAR(aTot[4]) +"</td>"
	cHtml += "	</tr>"
	cHtml += "	<tr>"
	cHtml += "		<td>OS canceladas</td>"
	cHtml += "		<td>Qtd</td>"
	cHtml += "		<td>" +CVALTOCHAR(aTotAcm[5]) +"</td>"
	cHtml += "		<td>" +CVALTOCHAR(aTot[5])+ "</td>"
	cHtml += "	</tr>"
	cHtml += "	<tr>"
	cHtml += "		<td>Maior tempo de deslocamento</td>"
	cHtml += "		<td>Hora</td>"
	cHtml += "		<td>" +IntToHora(aTotAcm[6]) +"</td>"
	cHtml += "		<td>" +IntToHora(aTot[6]) +"</td>"
	cHtml += "	</tr>"
	
	cHtml += "	<tr>"
	cHtml += "		<td>Maior tempo gasto</td>"
	cHtml += "		<td>Hora</td>"
	cHtml += "		<td>" +IntToHora(aTotAcm[7]) +"</td>"
	cHtml += "		<td>" +IntToHora(aTot[7]) +"</td>"
	cHtml += "	</tr>"
	
	cHtml += "	<tr>"
	cHtml += "		<td>Atendimento das OS no prazo</td>"
	cHtml += "		<td>%</td>"
	cHtml += "		<td>" +CVALTOCHAR(aTotAcm[8]) +"</td>"
	cHtml += "		<td>" +CVALTOCHAR(aTot[8])  +"</td>"
	cHtml += "	</tr>"
	
	cHtml += "	<tr>"
	cHtml += "		<td>Atendimento da QTD de OS programada</td>"
	cHtml += "		<td>%</td>"
	cHtml += "		<td>" +CVALTOCHAR(aTotAcm[9]) +"</td>"
	cHtml += "		<td>" +CVALTOCHAR(aTot[9])  +"</td>"
	cHtml += "	</tr>"
	
	cHtml += "	<tr>"
	cHtml += "		<td>Total sale</td>"
	cHtml += "		<td>Qtd</td>"
	cHtml += "		<td>" +Transform( aTotAcm[10], "@E 999,999,999,999" ) +"</td>"
	cHtml += "		<td>" +Transform( aTot[10], "@E 999,999,999,999" ) 	+"</td>"
	cHtml += "	</tr>"
	
	cHtml += "	<tr>"
	cHtml += "		<td>Abastecimento</td>"
	cHtml += "		<td>%</td>"
	cHtml += "		<td>" +Transform( aTotAcm[12], "@E 999,999,999,999" ) +"</td>"
	cHtml += "		<td>" +Transform( aTot[12], "@E 999,999,999,999" ) 	+"</td>"
	cHtml += "	</tr>"
	
	cHtml += "	<tr>"
	cHtml += "		<td>Tempo gasto</td>"
	cHtml += "		<td>%</td>"
	cHtml += "		<td>" +CVALTOCHAR( aTotAcm[15] ) +"</td>"
	cHtml += "		<td>" +CVALTOCHAR( aTot[15] ) 	+"</td>"
	cHtml += "	</tr>"
	
	cHtml += "	<tr>"
	cHtml += "		<td>Tempo de deslocamento</td>"
	cHtml += "		<td>%</td>"
	cHtml += "		<td>" +CVALTOCHAR( aTotAcm[16] ) +"</td>"
	cHtml += "		<td>" +CVALTOCHAR( aTot[16] ) 	+"</td>"
	cHtml += "	</tr>"
	
	cHtml += "	<tr>"
	cHtml += "		<td>Total de Corre็๕es</td>"
	cHtml += "		<td>Qtd</td>"
	cHtml += "		<td>" +CVALTOCHAR( aTotAcm[17] ) +"</td>"
	cHtml += "		<td>" +CVALTOCHAR( aTot[17] ) 	+"</td>"
	cHtml += "	</tr>"
		
	cHtml += "</table>"
	 
		
	// DETALHES OS PROGRAMADAS
	cHtml += "<br><br>"	+CRLF
	cHtml += "<b>OS finalizadas</b>"	+CRLF
	cHtml += "<br>"	+CRLF 
	cHtml += "<table class='bordasimples' cellpadding='4'>"	+CRLF
	cHtml += "<tr style='background:#90AFFF'>"	+CRLF
	cHtml += 	"<td style='color:#FFFFFF'><b>Hora de inicializa็ใo</b></td>"	+CRLF
	cHtml += 	"<td style='color:#FFFFFF'><b>Hora de finaliza็ใo</b></td>"	+CRLF
	cHtml += 	"<td style='color:#FFFFFF'><b>Hora agendada de t้rmino</b></td>"	+CRLF 
	cHtml += 	"<td style='color:#FFFFFF'><b>OS</b></td>"	+CRLF 
	cHtml += 	"<td style='color:#FFFFFF'><b>PA Cliente</b></td>"	+CRLF 
	cHtml += 	"<td style='color:#FFFFFF'><b>Patrim๔nio</b></td>"	+CRLF 
	cHtml += 	"<td style='color:#FFFFFF'><b>Modelo</b></td>"	+CRLF 		
	cHtml += 	"<td style='color:#FFFFFF'><b>Tempo gasto</b></td>"	+CRLF 
	cHtml += 	"<td style='color:#FFFFFF'><b>Tempo deslocamento</b></td>"	+CRLF 
	cHtml += 	"<td style='color:#FFFFFF'><b>Tempo atraso</b></td>"	+CRLF 
	cHtml += 	"<td style='color:#FFFFFF'><b>SALE</b></td>"	+CRLF 
	cHtml += 	"<td style='color:#FFFFFF'><b>Abastecimento</b></td>"	+CRLF 
	cHtml += 	"<td style='color:#FFFFFF'><b>Corre็๕es de Apontamentos</b></td>"	+CRLF
	cHtml += "</tr>"	+CRLF                                         
	              
	For nJ := 1 To Len(aOS)
		dDtIni := aOS[nJ][22]
		dDtFim := aOS[nJ][21]
		dDtAg := aOS[nJ][10]
  		cHrAg := aOS[nJ][11]
  		cHrIni := aOS[nJ][23]
  		cHrFim := aOS[nJ][20]	
  		cTmpAtend := aOS[nJ][27]
  		cTmpDeslc := aOS[nJ][28]
  		cTmpAtras := aOS[nJ][29]
  		nSale := aOS[nJ][30]
  		nAbast := aOS[nJ][31]
  		nCorrec := aOS[nJ][32]

  		// converte
  		cTmpAtend := StrTran(IntToHora(cTmpAtend),".",":")
  		cTmpDeslc := StrTran(IntToHora(cTmpDeslc),".",":")
  		cTmpAtras := StrTran(IntToHora(cTmpAtras),".",":")

		cHtml += "<tr>"	+CRLF
		cHtml += 	"<td>" +dtoc(dDtIni) +" " +StrTran(cHrIni,".",":")  +"</td>"	+CRLF
		cHtml += 	"<td>" +dtoc(dDtFim) +" " +StrTran(cHrFim,".",":")  +"</td>"	+CRLF
		cHtml += 	"<td>" +dtoc(dDtAg) +" " +StrTran(cHrAg,".",":")	+"</td>"	+CRLF
		cHtml += 	"<td>" +aOS[nJ][1]	+"</td>"	+CRLF
		cHtml += 	"<td>" +aOS[nJ][26]	+"</td>"	+CRLF
		cHtml += 	"<td>" +aOS[nJ][16]	+"</td>"	+CRLF
		cHtml += 	"<td>" +aOS[nJ][17]	+"</td>"	+CRLF
		cHtml += 	"<td>" +cTmpAtend	+"</td>"	+CRLF
		cHtml += 	"<td>" +cTmpDeslc	+"</td>"	+CRLF
		cHtml += 	"<td>" +cTmpAtras	+"</td>"	+CRLF
		cHtml += 	"<td>" +Transform( nSale, "@E 999,999,999,999" )	+"</td>"	+CRLF
		cHtml += 	"<td>" +cvaltochar(nAbast)	+"</td>"	+CRLF
		cHtml += 	"<td>" +cvaltochar(nCorrec) +"</td>"	+CRLF                                                         		
		cHtml += "</tr>"	+CRLF
	Next nJ
	    
	// ultima linha com somente total de tempo e deslocamento
	cHtml += "<tr>"	+CRLF
	cHtml += 	"<td></td>"	+CRLF
	cHtml += 	"<td></td>"	+CRLF
	cHtml += 	"<td></td>"	+CRLF
	cHtml += 	"<td></td>"	+CRLF
	cHtml += 	"<td></td>"	+CRLF
	cHtml += 	"<td></td>"	+CRLF
	cHtml += 	"<td></td>"	+CRLF
	cHtml += 	"<td>" +IntToHora(nTmpTotal) +"</td>"	+CRLF
	cHtml += 	"<td>" +IntToHora(nTmpDesloc) +"</td>"	+CRLF
	cHtml += 	"<td></td>"	+CRLF
	cHtml += 	"<td></td>"	+CRLF
	cHtml += 	"<td></td>"	+CRLF
	cHtml += 	"<td></td>"	+CRLF                                                            		
	cHtml += "</tr>"	+CRLF
		    
	cHtml += "</table>"	+CRLF
	
	cHtml += "<br>"	+CRLF
	cHtml += "<br>"	+CRLF
	
	cHtml += "<p>" +Replicate("_",35) +"</p>"	+CRLF
	cHtml += "<p>E-mail automแtico enviado via protheus.</p>"	+CRLF
	cHtml += "<p>Favor nใo responder.</p>"	+CRLF
	cHtml += "</body>"	+CRLF
	cHtml += "</html>"	+CRLF

	cAssunto := "OS PR " +"DIA" + " - " +cNomeTec
		
	U_TTMailN(cRemete,cDestino,cAssunto,cHtml,aAttach,.F.)       
Next nI

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMailSuper  บAutor  ณJackson E. de Deus บ Data ณ  05/02/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia email para supervisor	                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MailSuper(aM,aM2,cSuper,dData)

Local cRemete := "microsiga"
Local cdestino := AllTrim( Posicione( "AA1",1,xFilial("AA1")+AvKey( cSuper,"AA1_CODTEC"),"AA1_EMAIL" ) )
Local cAssunto := "Indicadores"
Local cHtml := ""
Local aAttach := {}                                
Local cNomAtend := ""
Local cNomSuper := AllTrim( Posicione( "AA1",1,xFilial("AA1")+AvKey( cSuper,"AA1_CODTEC"),"AA1_NOMTEC" ) )
Local nI

If Empty(cdestino)
	cdestino := "jnascimento@toktake.com.br"
EndIf

cDestino += ";" +_cMail //";lbsantos@toktake.com.br;jnascimento@toktake.com.br;cpomini@toktake.com.br"

//Local aM := {}
//Local aM2 := {}
//ASort( aDados, , , { |x,y| x[1] > y[1] } )
                 
cHtml := "<html>" +CRLF
cHtml += "<head>"+CRLF
cHtml += "<title>" +cAssunto +"</title>" +CRLF
					
// Estilos
cHtml += "<style type='text/css'>"	+CRLF
cHtml += "	table.bordasimples {border-collapse: collapse;}"	+CRLF
cHtml += "	table.bordasimples tr td {border:1px solid #999999 ;}"	+CRLF
cHtml += "	body { background-color: #FFFFFF;"	+CRLF
cHtml += "	color: #5D665B; "	+CRLF
cHtml += "	margin: 10px;"	+CRLF
cHtml += "	font-family: Georgia, 'Times New Roman', Times, serif;"	+CRLF
cHtml += "	font-size: small;"	+CRLF
//	cArqMail += "	line-height: 180%;"
cHtml += " 	}"	+CRLF
cHtml += "</style>"	+CRLF

cHtml += "</head>"	+CRLF
	
// Corpo
cHtml += "<body>"	+CRLF

// pontuais
If Len(aM) > 0
	cHtml += 	"<br>"
	cHtml += 	"<table class='bordasimples' cellpadding='4'>"
	cHtml +=		"<caption>" +cNomSuper +"</caption>"
	cHtml += 			"<thead>"
	cHtml +=				"<tr>"
	cHtml +=					"<td></td>"
	cHtml +=					"<td colspan='2'>Produtividade - Qtd</td>"
	cHtml +=					"<td colspan='2'>Tempo m้dio at้ o atendimento - Hora</td>"
	cHtml +=					"<td colspan='2'>Tempo m้dio de OS em atraso - Hora</td>"
	//cHtml += 					"<td colspan='2'></td>"
	cHtml +=				"<tr>"
	cHtml +=			"</thead>"
	cHtml += 		"<tr style='background:#90AFFF'>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Atendente</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Consolidado at้ " +dtoc(dData) +"</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Resultado " +dtoc(dData) +"</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Consolidado at้ " +dtoc(dData) +"</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Resultado " +dtoc(dData) +"</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Consolidado at้ " +dtoc(dData) +"</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Resultado " +dtoc(dData) +"</b></td>"
	//cHtml +=			"<td style='color:#FFFFFF'><b>Consolidado at้ " +dtoc(dData) +"</b></td>"
	//cHtml +=			"<td style='color:#FFFFFF'><b>Resultado " +dtoc(dData) +"</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Maior tempo gasto do dia</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Maior tempo de deslocamento do dia</b></td>"
	cHtml += 		"</tr>"
	
	For nI := 1 To Len(aM)	
		cNomAtend := AllTrim( Posicione( "AA1",1, xFilial("AA1") +AvKey( aM[nI][1], "AA1_CODTEC" ), "AA1_NOMTEC" ) )
		cHtml += "<tr>"	+CRLF
		cHtml += 	"<td>" +cNomAtend  +"</td>"	+CRLF
		cHtml += 	"<td>"  +CVALTOCHAR(aM[nI][3][4]) +"</td>"	+CRLF
		cHtml += 	"<td>"  +CVALTOCHAR(aM[nI][2][4]) +"</td>"	+CRLF
		
		cHtml += 	"<td>"  +IntToHora(aM[nI][3][5]) +"</td>"	+CRLF
		cHtml += 	"<td>"  +IntToHora(aM[nI][2][5]) +"</td>"	+CRLF
		
		cHtml += 	"<td>" 	+IntToHora(aM[nI][3][6]) +"</td>"	+CRLF
		cHtml += 	"<td>" 	+IntToHora(aM[nI][2][6]) +"</td>"	+CRLF
		
		//cHtml += 	"<td>" 	+CVALTOCHAR(aM[nI][3][6]) +"</td>"	+CRLF
		//cHtml += 	"<td>" 	+CVALTOCHAR(aM[nI][2][6]) +"</td>"	+CRLF
		
		cHtml += 	"<td>" 	+IntToHora(aM[nI][3][7]) +"</td>"	+CRLF
		cHtml += 	"<td>" 	+IntToHora(aM[nI][2][7]) +"</td>"	+CRLF
		cHtml += "</tr>"	+CRLF
	Next nI
	cHtml += 	"</table>"
EndIf

// programadas
If Len(aM2) > 0
	If Len(aM) > 0
		cHtml += 	"<br><br>"
	EndIf
	
	cHtml += 	"<table class='bordasimples' cellpadding='4'>"
	cHtml +=		"<caption>" +cNomSuper +"</caption>"
	cHtml += 			"<thead>"
	cHtml +=				"<tr>"
	cHtml +=					"<td></td>"
	cHtml +=					"<td colspan='2'>Indice de ociosidade - %</td>"
	cHtml +=					"<td colspan='2'>Atendimento das OS no prazo - %</td>"
	cHtml +=					"<td colspan='2'>Atendimento da programa็ใo das OS - %</td>"
	cHtml += 					"<td colspan='2'>Total Sale - Qtd</td>"
	cHtml += 					"<td colspan='2'>Abastecimento - %</td>"
	cHtml += 					"<td colspan='2'>Tempo gasto - %</td>"
	cHtml += 					"<td colspan='2'>Tempo de deslocamento - %</td>"
	cHtml +=				"<tr>"
	cHtml +=			"</thead>"
	cHtml += 		"<tr style='background:#90AFFF'>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Atendente</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Consolidado at้ " +dtoc(dData) +"</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Resultado " +dtoc(dData) +"</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Consolidado at้ " +dtoc(dData) +"</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Resultado " +dtoc(dData) +"</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Consolidado at้ " +dtoc(dData) +"</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Resultado " +dtoc(dData) +"</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Consolidado at้ " +dtoc(dData) +"</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Resultado " +dtoc(dData) +"</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Consolidado at้ " +dtoc(dData) +"</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Resultado " +dtoc(dData) +"</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Consolidado at้ " +dtoc(dData) +"</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Resultado " +dtoc(dData) +"</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Consolidado at้ " +dtoc(dData) +"</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Resultado " +dtoc(dData) +"</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Maior tempo gasto do dia</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Maior tempo de deslocamento do dia</b></td>"
	cHtml += 		"</tr>"

	For nI := 1 To Len(aM2)	
		cNomAtend := AllTrim( Posicione( "AA1",1, xFilial("AA1") +AvKey( aM2[nI][1], "AA1_CODTEC" ), "AA1_NOMTEC" ) )
		cHtml += "<tr>"	+CRLF
		cHtml += 	"<td>" +cNomAtend  +"</td>"	+CRLF
		cHtml += 	"<td>"  +CVALTOCHAR(aM2[nI][3][11]) +"</td>"	+CRLF
		cHtml += 	"<td>"  +CVALTOCHAR(aM2[nI][2][11]) +"</td>"	+CRLF
		
		cHtml += 	"<td>"  +CVALTOCHAR(aM2[nI][3][8]) +"</td>"	+CRLF
		cHtml += 	"<td>"  +CVALTOCHAR(aM2[nI][2][8]) +"</td>"	+CRLF
		
		cHtml += 	"<td>" 	+CVALTOCHAR(aM2[nI][3][9]) +"</td>"	+CRLF
		cHtml += 	"<td>" 	+CVALTOCHAR(aM2[nI][2][9]) +"</td>"	+CRLF
		
		cHtml += 	"<td>" 	+Transform(aM2[nI][3][10],"@E 999,999,999,999") +"</td>" +CRLF
		cHtml += 	"<td>" 	+Transform(aM2[nI][2][10],"@E 999,999,999,999") +"</td>" +CRLF
		
		cHtml += 	"<td>" 	+CVALTOCHAR(aM2[nI][3][12]) +"</td>" +CRLF
		cHtml += 	"<td>" 	+CVALTOCHAR(aM2[nI][2][12]) +"</td>" +CRLF
		
		cHtml += 	"<td>" 	+CVALTOCHAR(aM2[nI][3][15]) +"</td>" +CRLF
		cHtml += 	"<td>" 	+CVALTOCHAR(aM2[nI][2][15]) +"</td>" +CRLF
		
		cHtml += 	"<td>" 	+CVALTOCHAR(aM2[nI][3][16]) +"</td>" +CRLF
		cHtml += 	"<td>" 	+CVALTOCHAR(aM2[nI][2][16]) +"</td>" +CRLF
		
		cHtml += 	"<td>" 	+IntToHora(aM2[nI][3][7]) +"</td>"	+CRLF
		cHtml += 	"<td>" 	+IntToHora(aM2[nI][2][7]) +"</td>"	+CRLF		
		cHtml += "</tr>"	+CRLF
	Next nI
	
	// Media Total supervisor
	aMedia := MediaSup(aM2)
	cHtml += "<tr>"	+CRLF
	cHtml += 	"<td>" +"RESULTADO SUPERVISOR"  +"</td>"	+CRLF
	cHtml += 	"<td>"  +CVALTOCHAR(aMedia[1][1]) +"</td>"	+CRLF
	cHtml += 	"<td>"  +CVALTOCHAR(aMedia[1][2]) +"</td>"	+CRLF
	
	cHtml += 	"<td>"  +CVALTOCHAR(aMedia[1][3]) +"</td>"	+CRLF
	cHtml += 	"<td>"  +CVALTOCHAR(aMedia[1][4]) +"</td>"	+CRLF
	
	cHtml += 	"<td>" 	+CVALTOCHAR(aMedia[1][5]) +"</td>"	+CRLF
	cHtml += 	"<td>" 	+CVALTOCHAR(aMedia[1][6]) +"</td>"	+CRLF
	
	cHtml += 	"<td>" 	+Transform(aMedia[1][7],"@E 999,999,999,999") +"</td>" +CRLF
	cHtml += 	"<td>" 	+Transform(aMedia[1][8],"@E 999,999,999,999") +"</td>" +CRLF
	
	cHtml += 	"<td>" 	+CVALTOCHAR(aMedia[1][9]) +"</td>" +CRLF
	cHtml += 	"<td>" 	+CVALTOCHAR(aMedia[1][10]) +"</td>" +CRLF
	
	cHtml += 	"<td>" 	+CVALTOCHAR(aMedia[1][11]) +"</td>" +CRLF
	cHtml += 	"<td>" 	+CVALTOCHAR(aMedia[1][12]) +"</td>" +CRLF
	
	cHtml += 	"<td>" 	+CVALTOCHAR(aMedia[1][13]) +"</td>" +CRLF
	cHtml += 	"<td>" 	+CVALTOCHAR(aMedia[1][14]) +"</td>" +CRLF
	cHtml += "</tr>"	+CRLF
		
		
	cHtml += 	"</table>"
EndIf

cHtml += "<br>"
cHtml += "<br>"
cHtml += "<p>___________________________________</p>"
cHtml += "<p>E-mail automแtico enviado via protheus.</p>"
cHtml += "<p>Favor nใo responder.</p>"
cHtml += "</body>"
cHtml += "</html>"

cAssunto := "OS " +"ACUMULADA" + " - " +cNomSuper

If Len(aM) > 0 .Or. Len(aM2) > 0
	U_TTMailN(cRemete,cDestino,cAssunto,cHtml,aAttach,.F.)   
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMailGeren บAutor  ณMicrosiga           บ Data ณ  04/07/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MailGeren(aM,aM2,cGeren,dData)

Local cRemete := "microsiga"
Local cdestino := AllTrim( Posicione( "AA1",1,xFilial("AA1")+AvKey( cGeren,"AA1_CODTEC"),"AA1_EMAIL" ) )
Local cNomGeren := AllTrim( Posicione( "AA1",1,xFilial("AA1")+AvKey( cGeren,"AA1_CODTEC"),"AA1_NOMTEC" ) )
Local cAssunto := "Indicadores"
Local cHtml := ""
Local aAttach := {}                                
Local nI,nJ
Local nTotAtend := 0
Local nProd1 := 0
Local nProd2 := 0
Local nTmpM1 := 0
Local nTmpM2 := 0
Local nTmpM3 := 0
Local nTmpM4 := 0
Local nInd1 := 0
Local nInd2 := 0
Local nAtd1 := 0
Local nAtd2 := 0
Local nAtdPg1 := 0
Local nAtdPg2 := 0
Local nSales1 := 0
Local nSales2 := 0
Local nAbast := 0
Local nAbst1 := 0
Local nAbst2 := 0
Local nTmpG1 := 0
Local nTmpG2 := 0
Local nTmpD1 := 0
Local nTmpD2 := 0
Local nGInd1 := 0
Local nGInd2 := 0
Local nGAtd1 := 0
Local nGAtd2 := 0
Local nGAtdPg1 := 0
Local nGAtdPg2 := 0
Local nGProd1 := 0
Local nGProd2 := 0
Local nGnTmp1 := 0
Local nGnTmp2 := 0
Local nGnTmp3 := 0
Local nGnTmp4 := 0

If Empty(cdestino)
	cdestino := "jnascimento@toktake.com.br"
EndIf

cDestino += ";" +_cMail  //"jnascimento@toktake.com.br;cpomini@toktake.com.br;lbsantos@toktake.com.br"

cHtml := "<html>" +CRLF
cHtml += "<head>"+CRLF
cHtml += "<title>" +cAssunto +"</title>" +CRLF
					
// Estilos
cHtml += "<style type='text/css'>"	+CRLF
cHtml += "	table.bordasimples {border-collapse: collapse;}"	+CRLF
cHtml += "	table.bordasimples tr td {border:1px solid #999999 ;}"	+CRLF
cHtml += "	body { background-color: #FFFFFF;"	+CRLF
cHtml += "	color: #5D665B; "	+CRLF
cHtml += "	margin: 10px;"	+CRLF
cHtml += "	font-family: Georgia, 'Times New Roman', Times, serif;"	+CRLF
cHtml += "	font-size: small;"	+CRLF
//	cArqMail += "	line-height: 180%;"
cHtml += " 	}"	+CRLF
cHtml += "</style>"	+CRLF

cHtml += "</head>"	+CRLF

// pontuais
If Len(aM) > 0
	cHtml += 	"<br>"
	cHtml += 	"<table class='bordasimples' cellpadding='4'>"
	cHtml +=		"<caption>" +cNomGeren +"</caption>"
	cHtml += 			"<thead>"
	cHtml +=				"<tr>"
	cHtml +=					"<td></td>"
	cHtml +=					"<td colspan='2'>Produtividade - Qtd</td>"
	cHtml +=					"<td colspan='2'>Tempo m้dio at้ o atendimento - Hora</td>"
	cHtml +=					"<td colspan='2'>Tempo m้dio de OS em atraso - Hora</td>"
	//cHtml += 					"<td colspan='2'></td>"
	cHtml +=				"<tr>"
	cHtml +=			"</thead>"
	cHtml += 		"<tr style='background:#90AFFF'>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Atendente</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Consolidado at้ " +dtoc(dData) +"</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Resultado " +dtoc(dData) +"</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Consolidado at้ " +dtoc(dData) +"</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Resultado " +dtoc(dData) +"</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Consolidado at้ " +dtoc(dData) +"</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Resultado " +dtoc(dData) +"</b></td>"
	cHtml += 		"</tr>"
		
	For nI := 1 To Len(aM)
		cAtend := AllTrim( Posicione( "AA1",1, xFilial("AA1") +AvKey( aM[nI][1], "AA1_CODTEC" ), "AA1_NOMTEC" ) )
		nTotAtend := 0
		nProd1 := 0
		nProd2 := 0
		nTmpM1 := 0
		nTmpM2 := 0
		nTmpM3 := 0
		nTmpM4 := 0
		For nJ := 2 To Len(aM[nI])                                                                                       
		    
			// somatorio/media supervisor
			nTotAtend++
			nProd1 += aM[nI][nJ][3][4]
			nProd2 += aM[nI][nJ][2][4]
			nTmpM1 += aM[nI][nJ][3][5]
			nTmpM2 += aM[nI][nJ][2][5]
			nTmpM3 += aM[nI][nJ][3][6]
			nTmpM4 += aM[nI][nJ][2][6]
			
			// fechou supervisor?
			If nJ = Len(aM[nI])
				nTmpM1 := nTmpM1/nTotAtend
				nTmpM2 := nTmpM2/nTotAtend
				nTmpM3 := nTmpM3/nTotAtend
				nTmpM4 := nTmpM4/nTotAtend
				
				// totalizador gerente
				nGProd1 += nProd1
				nGProd2 += nProd2
				nGnTmp1 += nTmpM1
				nGnTmp2 += nTmpM2
				nGnTmp3 += nTmpM3
				nGnTmp4 += nTmpM4
				
				
				cHtml += "<tr>"	+CRLF
				cHtml += 	"<td>" +cAtend  +"</td>"	+CRLF
				cHtml += 	"<td>"  +CVALTOCHAR(nProd1) +"</td>"	+CRLF
				cHtml += 	"<td>"  +CVALTOCHAR(nProd2) +"</td>"	+CRLF
				
				cHtml += 	"<td>"  +IntToHora(nTmpM1) +"</td>"	+CRLF
				cHtml += 	"<td>"  +IntToHora(nTmpM2) +"</td>"	+CRLF
				
				cHtml += 	"<td>" 	+IntToHora(nTmpM3) +"</td>"	+CRLF
				cHtml += 	"<td>" 	+IntToHora(nTmpM4) +"</td>"	+CRLF		
				cHtml += "</tr>"	+CRLF			
			EndIf
		Next nJ
		// ultimo
		If nI = Len(aM)
			nGTotAtd := Len(aM)
			nGnTmp1 := nGnTmp1/nGTotAtd
			nGnTmp2 := nGnTmp2/nGTotAtd
			nGnTmp3 := nGnTmp3/nGTotAtd
			nGnTmp4 := nGnTmp4/nGTotAtd
			
			cHtml += "<tr>"	+CRLF
			cHtml += 	"<td>RESULTADO GERENTE</td>"	+CRLF
			cHtml += 	"<td>"  +CVALTOCHAR(nGProd1) +"</td>"	+CRLF
			cHtml += 	"<td>"  +CVALTOCHAR(nGProd2) +"</td>"	+CRLF
			
			cHtml += 	"<td>"  +IntToHora(nGnTmp1) +"</td>"	+CRLF
			cHtml += 	"<td>"  +IntToHora(nGnTmp2) +"</td>"	+CRLF
			
			cHtml += 	"<td>" 	+IntToHora(nGnTmp3) +"</td>"	+CRLF
			cHtml += 	"<td>" 	+IntToHora(nGnTmp4) +"</td>"	+CRLF
			cHtml += "</tr>"	+CRLF			
		EndIf
	Next nI
	cHtml += "</table>"	+CRLF	
EndIf	
			                      
// programadas
If Len(aM2) > 0
	If Len(aM) > 0
		cHtml += 	"<br><br>"
	EndIf
	
	cHtml += 	"<table class='bordasimples' cellpadding='4'>"
	cHtml +=		"<caption>" +cNomGeren +"</caption>"
	cHtml += 			"<thead>"
	cHtml +=				"<tr>"
	cHtml +=					"<td></td>"
	cHtml +=					"<td colspan='2'>Indice de ociosidade - %</td>"
	cHtml +=					"<td colspan='2'>Atendimento das OS no prazo - %</td>"
	cHtml +=					"<td colspan='2'>Atendimento da programa็ใo das OS - %</td>"
	cHtml += 					"<td colspan='2'>Total Sale - Qtd</td>"
	cHtml +=				"<tr>"
	cHtml +=			"</thead>"
	cHtml += 		"<tr style='background:#90AFFF'>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Atendente</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Consolidado at้ " +dtoc(dData) +"</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Resultado " +dtoc(dData) +"</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Consolidado at้ " +dtoc(dData) +"</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Resultado " +dtoc(dData) +"</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Consolidado at้ " +dtoc(dData) +"</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Resultado " +dtoc(dData) +"</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Consolidado at้ " +dtoc(dData) +"</b></td>"
	cHtml +=			"<td style='color:#FFFFFF'><b>Resultado " +dtoc(dData) +"</b></td>"
	cHtml += 		"</tr>"
	
	For nI := 1 To Len(aM2)
		cAtend := AllTrim( Posicione( "AA1",1, xFilial("AA1") +AvKey( aM2[nI][1], "AA1_CODTEC" ), "AA1_NOMTEC" ) )
		nInd1 := 0
		nInd2 := 0
		nAtd1 := 0
		nAtd2 := 0
		nAtdPg1 := 0
		nAtdPg2 := 0
		nSales1 := 0
		nSales2 := 0
		For nJ := 2 To Len(aM2[nI])                                                                                       
			// somatorio/media supervisor
			nTotAtend++
			nInd1 += aM2[nI][nJ][3][11]
			nInd2 += aM2[nI][nJ][2][11]
			nAtd1 += aM2[nI][nJ][3][2]
			nAtd2 += aM2[nI][nJ][2][2]
			nAtdPg1 += aM2[nI][nJ][3][9]
			nAtdPg2 += aM2[nI][nJ][2][9]
			nSales1 += aM2[nI][nJ][3][10]
			nSales2 += aM2[nI][nJ][2][10]
				
			// fechou supervisor?
			If nJ = Len(aM2[nI])
				nInd1 := nInd1/nTotAtend
				nInd2 := nInd2/nTotAtend
				nAtd1 := nAtd1/nTotAtend
				nAtd2 := nAtd2/nTotAtend
				nAtdPg1 := nAtdPg1/nTotAtend
				nAtdPg2 := nAtdPg2/nTotAtend
				 
				// totalizador gerente
				nGInd1 += nInd1
				nGInd2 += nInd2
				nGAtd1 += nAtd1
				nGAtd2 += nAtd2
				nGAtdPg1 += nAtdPg1
				nGAtdPg2 += nAtdPg2
				
				cHtml += "<tr>"	+CRLF
				cHtml += 	"<td>" +cAtend  +"</td>"	+CRLF
				cHtml += 	"<td>"  +CVALTOCHAR( Round(nInd1,2) ) +"</td>"	+CRLF
				cHtml += 	"<td>"  +CVALTOCHAR( Round(nInd2,2) ) +"</td>"	+CRLF
				
				cHtml += 	"<td>"  +CVALTOCHAR( Round(nAtd1,2) ) +"</td>"	+CRLF
				cHtml += 	"<td>"  +CVALTOCHAR( Round(nAtd2,2) ) +"</td>"	+CRLF
				
				cHtml += 	"<td>" 	+CVALTOCHAR( Round(nAtdPg1,2) ) +"</td>"	+CRLF
				cHtml += 	"<td>" 	+CVALTOCHAR( Round(nAtdPg2,2) ) +"</td>"	+CRLF
				
				cHtml += 	"<td>" 	+Transform( nSales1,"@E 999,999,999,999" ) +"</td>" +CRLF
				cHtml += 	"<td>" 	+Transform( nSales2,"@E 999,999,999,999" ) +"</td>" +CRLF		
				cHtml += "</tr>"	+CRLF
			EndIf
		Next nJ
			
	  	// fechamento gerente
		If nI = Len(aM2)
			nTotAtend := Len(aM2)
			nGInd1 := nGInd1/nTotAtend
			nGInd2 := nGInd2/nTotAtend
			nGAtd1 := nGAtd1/nTotAtend
			nGAtd2 := nGAtd2/nTotAtend
			nGAtdPg1 := nGAtdPg1/nTotAtend
			nGAtdPg2 := nGAtdPg2/nTotAtend
			
			cHtml += "<tr>"	+CRLF
			cHtml += 	"<td>RESULTADO GERENTE</td>"	+CRLF
			cHtml += 	"<td>"  +CVALTOCHAR( Round(nGInd1,2) ) +"</td>"	+CRLF
			cHtml += 	"<td>"  +CVALTOCHAR( Round(nGInd2,2) ) +"</td>"	+CRLF
			
			cHtml += 	"<td>"  +CVALTOCHAR( Round(nGAtd1,2) ) +"</td>"	+CRLF
			cHtml += 	"<td>"  +CVALTOCHAR( Round(nGAtd2,2) ) +"</td>"	+CRLF
			
			cHtml += 	"<td>" 	+CVALTOCHAR( Round(nGAtdPg1,2) ) +"</td>"	+CRLF
			cHtml += 	"<td>" 	+CVALTOCHAR( Round(nGAtdPg2,2) ) +"</td>"	+CRLF
			
			cHtml += 	"<td>" 	+Transform( nSales1,"@E 999,999,999,999" ) +"</td>" +CRLF
			cHtml += 	"<td>" 	+Transform( nSales2,"@E 999,999,999,999" ) +"</td>" +CRLF	
			cHtml += "</tr>"	+CRLF
		EndIf			
	Next nI
	cHtml += "</table>"	+CRLF	
EndIf

cHtml += "<br>"
cHtml += "<br>"
cHtml += "<p>___________________________________</p>"
cHtml += "<p>E-mail automแtico enviado via protheus.</p>"
cHtml += "<p>Favor nใo responder.</p>"
cHtml += "</body>"
cHtml += "</html>"

cAssunto := "OS " +"ACUMULADA" + " - " +cNomGeren

If Len(aM) > 0 .Or. Len(aM2) > 0
	U_TTMailN(cRemete,cDestino,cAssunto,cHtml,aAttach,.F.)   
EndIf                   

Return

// media supervisor calculo 
Static Function MediaSup(aM2)

Local nI
Local aMedia := {}
Local cAtend := ""
Local nInd1 := 0
Local nInd2 := 0
Local nAtd1 := 0
Local nAtd2 := 0
Local nAtdPg1 := 0
Local nAtdPg2 := 0
Local nSales1 := 0
Local nSales2 := 0
Local nAbst1 := 0
Local nAbst2 := 0
Local nTmpG1 := 0
Local nTmpG2 := 0
Local nTmpD1 := 0
Local nTmpD2 := 0
Local nTtOc := 0
Local nTtOp := 0
Local nTtPo := 0
Local nTtSl := 0
Local nTtAb := 0
Local nTtTg := 0
Local nTtTd := 0
Local nTotAtend := 0	
	
For nI := 1 To Len(aM2)
	cAtend := AllTrim( Posicione( "AA1",1, xFilial("AA1") +AvKey( aM2[nI][1], "AA1_CODTEC" ), "AA1_NOMTEC" ) )

	nInd1 += aM2[nI][3][11]	//
	nInd2 += aM2[nI][2][11]	//
	nAtd1 += aM2[nI][3][8]		//
	nAtd2 += aM2[nI][2][8]		//
	nAtdPg1 += aM2[nI][3][9]	//
	nAtdPg2 += aM2[nI][2][9]	//
	nSales1 += aM2[nI][3][10]	//
	nSales2 += aM2[nI][2][10]	//
	nAbst1 += aM2[nI][3][12]	//
	nAbst2 += aM2[nI][2][12]	//
	nTmpG1 += aM2[nI][3][15]	//
	nTmpG2 += aM2[nI][2][15]	//
	nTmpD1 += aM2[nI][3][16]	//
	nTmpD2 += aM2[nI][2][16]	//
			
	nTtOc++
	nTtOp++  
	nTtPo++
	//nTtSl++
	nTtAb++
	nTtTg++
	nTtTd++
			
	// tratamento
	If aM2[nI][2][11] == 0
		nTtOc--
	EndIf
	
	If aM2[nI][2][8] == 0
		nTtOp--
	EndIf
	
	If aM2[nI][2][9] == 0
		nTtPo--
	EndIf
	
	/*If aM2[nI][2][10] == 0
		nTtSl--        
	EndIf*/
	
	If aM2[nI][2][12] == 0
		nTtAb--
	EndIf
	           
	If aM2[nI][2][15] == 0
		nTtTg--
	EndIf
                       
	If aM2[nI][2][16] == 0
		nTtTd--
	EndIf

	If nI = Len(aM2)
		nTotAtend := Len(aM2)
		nInd1 := nInd1/nTotAtend
		nInd2 := nInd2/nTtOc
		nAtd1 := nAtd1/nTotAtend
		nAtd2 := nAtd2/nTtOp
		nAtdPg1 := nAtdPg1/nTotAtend
		nAtdPg2 := nAtdPg2/nTtPo
		nAbst1 := nAbst1/nTotAtend
		nAbst2 := nAbst2/nTtAb
		nTmpG1 := nTmpG1/nTotAtend 
		nTmpG2 := nTmpG2/nTtTg
		nTmpD1 := nTmpD1/nTotAtend
		nTmpD2 := nTmpD2/nTtTd
		
		AADD( aMedia, { nInd1,;
						nInd2,;
						nAtd1,;
						nAtd2,;
						nAtdPg1,;
						nAtdPg2,;
						nSales1,;
						nSales2,;
						nAbst1,;
						nAbst2,;
						nTmpG1,;
						nTmpG2,;
						nTmpD1,;
						nTmpD2 } )
	EndIf
Next nI

Return aMedia