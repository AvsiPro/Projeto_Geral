#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC25  บAutor  ณJackson E. de Deus  บ Data ณ  20/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa dados das OS de abastecimento		              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTPROC25(aDados,cMsgErro)

Local aArea			:= GetArea()
Local lRet			:= .F.
Local nI			:= 0
Local aItens		:= {} 
Local nQtdDisp		:= 0 
Local nQtdMola		:= 0
Local nQtdSaldo		:= 0
Local nQtdAbast		:= 0
Local nQtdRetir		:= 0
Local nQtdAbOri		:= 0
Local nQtdAbOri2	:= 0
Local nCapNova		:= 0
Local aEsqMola		:= {{'A',1,10},{'B',11,20},{'C',21,30},{'D',31,40},{'E',41,50},{'F',51,60},{'I',51,60}}  
Local cTipBeb		:= POSICIONE("SB1",1,XFILIAL("SB1")+POSICIONE("SN1",2,XFILIAL("SN1")+aDados[ASCAN(aDados,{|X| X[1] == 'PATRIMONIO'}),02],"N1_PRODUTO"),"B1_XFAMILI")    
Local lBebida		:= cTipBeb $ "144/153"
Local lAbastec		:= .F.
Local lLeitura		:= .F.
Local lSangria		:= .F.
Local aLeitura		:= {}
Local aSangria		:= {}
Local nQtdTot		:= 0
Local nPos			:= 0
Local aMola			:= {}
Local lTroca		:= .F.
Local lGravaCont	:= .T.
Local cArmPat		:= ""
Local nErroSaldo	:= 0
Local lOk			:= .F.
Local cUsrExec		:= ""
Private _ORIGD := "TTPROC25"
Private _OPER1 := "SAIDA ROTA - ABASTECIDO"
Private _OPER2 := "ENTRADA PA - ABASTECIDO"
Private _OPER3 := "SAIDA ARMARIO - ABASTECIDO"
Private _OPER4 := "SAIDA PA - RETIRADO"
Private _OPER5 := "ENTRADA ROTA - RETIRADO"
Private _OPER6 := "ENTRADA ARMARIO - RETIRADO"
Private _OPER7 := "SAIDA PA - AVARIA"
Private _OPER8 := "ENTRADA ARMARIO - AVARIA"
Private _OPER9 := "ENTRADA MAQUINA - ABASTECIDO"
Private _OPER10 := "SAIDA MAQUINA - RETIRADO"
Private _OPER11 := "SAIDA MAQUINA - AVARIA"		
Private _ABAST		:= "A"
Private _RETIR		:= "R"
Private _AVAR		:= "D"
Private cTpEntre	:= ""
Private _lResid		:= .F.
Private _cArmP		:= ""	// armazem pa
Private _cArmA		:= ""	// armazem armario
Private _cArmM		:= ""	// armazem maquina
Private nPProduto	:= 1	// posicao do produto no array
Private nPMola		:= 2	// posicao da mola no array
Private nPSaldo		:= 3	// posicao do saldo no array
Private nPAbast		:= 4	// posicao da qtd abastecida no array
Private nPRetir		:= 5	// posicao da qtd retirada no array
Private nPRavar		:= 6	// posicao da qtd retirada por avaria
Private nPPrdNovo	:= 7	// posicao do saldo no array
Private nPSaldo2	:= 8	// posicao do saldo no array
Private nPAbast2	:= 9	// posicao da qtd abastecida no array
Private nPRetir2	:= 10	// posicao da qtd retirada no array
Private nPRavar2	:= 11	// posicao da qtd retirada por avaria
Private nPNewCap	:= 12	// posicao da nova quantidade - troca de capacidade
Private cNumChapa	:= ""               
Private cNumOS		:= ""
Private cCliOS		:= ""
Private cLjOS		:= "" 
Private cRota		:= ""
Private cArmazem	:= ""
Private lRota		:= .F.
Private _dDtFim		:= stod("") 
Private _cHoraFim	:= ""
Default aDados 		:= {}

If cEmpAnt <> "01"
	return
EndIF

If Len(aDados) == 0
	cMsgErro += "Dados nao informados." +CRLF
	Return lRet
EndIf


// validar se ja existe a rotina sendo executada por outro usuario
/*
If FindFunction( "U_XCExcSrv" )
	If U_XCExcSrv( _ORIGD,@cUsrExec )
		Conout( "TTPROC25 -> ROTINA EM EXECUCAO POR OUTRO USUARIO: " +cUsrExec )
		Return
	EndIf
EndIf
*/

nPos := Ascan(aDados,{|x| Alltrim(x[1]) == "NUMERO"})
If nPos > 0
	cNumOS := PadL(aDados[nPos][2],TamSx3("ZG_NUMOS")[1],"0")
	
	For nI := 1 To Len(aDados)
		If aDados[nI][1] == "ABASTECIMENTO"
			For nJ := 2 To Len(aDados[nI])
				aMola := {}
				aMola := Aclone( aDados[nI][nJ] )
				For nK := 1 To Len(aMola)
					If aMola[nK][1] == "DESCRICAO"
						cMola := aMola[nk][2]		
					ElseIf aMola[nK][1] == "PRODUTO"
						cProd := aMola[nk][2]		
					ElseIf aMola[nK][1] == "SALDO"
						nSaldo := Val(aMola[nk][2])
					ElseIf aMola[nK][1] == "RETIRADO"
						nRetir := Val(aMola[nk][2])
					ElseIf aMola[nK][1] == "DESCARTE"
						nDesc := Val(aMola[nk][2])
					ElseIf aMola[nK][1] == "ABASTECIDO"
						nAbast := Val(aMola[nk][2])
					ElseIf aMola[nK][1] == "PRODUTO_NOVO"
						cProdNovo := aMola[nk][2]
					ElseIf aMola[nK][1] == "SALDO_2"
						nSaldo2 := Val(aMola[nk][2])
					ElseIf aMola[nK][1] == "RETIRADO_2"
						nRetir2 := Val(aMola[nk][2])
					ElseIf aMola[nK][1] == "DESCARTE_2"
						nDesc2 := Val(aMola[nk][2])
					ElseIf aMola[nK][1] == "ABASTECIDO_2"
						nAbast2 := Val(aMola[nk][2])
					ElseIf aMola[nK][1] == "CAPACIDADE_NOVA"
						nCapNova :=  Val(aMola[nk][2])
					EndIf
				Next nK
				AADD( aItens, { cProd,cMola,nSaldo, nAbast, nRetir, nDesc, cProdNovo,nSaldo2,nAbast2,nRetir2,nDesc2,nCapNova  } )
			Next nJ  
			
		ElseIf aDados[nI][1] == "LEITURA"
			For nJ := 2 To Len(aDados[nI])
				If aDados[nI][nJ][1] == "CHKMAILCLI"  
					AADD( aLeitura, { aDados[nI][nJ][1], IIF(aDados[nI][nJ][2]=="S",.T.,.F.) } ) 
				Else 
					AADD( aLeitura, { aDados[nI][nJ][1], Val(aDados[nI][nJ][2])  } ) 
				EndIf
			Next nJ
			
		ElseIf aDados[nI][1] == "SANGRIA"
			For nJ := 2 To Len(aDados[nI])
				AADD( aSangria, { aDados[nI][nJ][1], aDados[nI][nJ][2]  } )
			Next nJ
		EndIf
	Next nI		
EndIf
 
dbSelectArea("SZG")
dbSetOrder(1)
If msSeek( xFilial("SZG") +AvKey(cNumOS,"ZG_NUMOS") )
	_dDtFim := SZG->ZG_DATAFIM
	_cHoraFim := SZG->ZG_HORAFIM
	cNumChapa := SZG->ZG_PATRIM
	If AllTrim(SZG->ZG_FORM) == "04" .OR. AllTrim(SZG->ZG_FORM) == "08"
		cRota := SZG->ZG_ROTA
		//If Empty(cCliOS)
			cCliOs := AllTrim(SZG->ZG_CLIFOR)
			cLjOs := AllTrim(SZG->ZG_LOJA)
		//EndIf
	EndIf

	// residente?
	dbSelectArea("AA1")
	dbSetOrder(1)
	If MSSeek( xFilial("AA1") +AvKey( SZG->ZG_CODTEC,"AA1_CODTEC" ) )
		If AllTrim(AA1->AA1_XARMOV) == "N"	// NAO EH ROTA MOVEL?
			_lResid := .T.
		EndIf
	EndIf
	
	If Empty(cRota)            
		If !Empty(AA1->AA1_LOCAL)
			If SubStr( AA1->AA1_LOCAL,1,2 ) == "R0"
				cRota := AA1->AA1_LOCAL
			EndIf
		EndIf
	EndIf
	
	If !Empty(cRota)
		If SubStr(cRota,1,1) == "R"	
			dbSelectArea("ZZ1")
			dbSetOrder(1)
			If MSSeek( xFilial("ZZ1") +AvKey(cRota,"ZZ1_COD") )
				cTpEntre := AllTrim(ZZ1->ZZ1_TIPO)
			EndIf
		EndIf
	EndIf
	
	// armazem maquina
	_cArmM := "M" +Alltrim(cNumChapa)		
EndIf

dbSelectArea("SN1")
dbSetOrder(2)
If msSeek( xFilial("SN1") +AvKey(cNumChapa,"N1_CHAPA") ) 
	cArmPat := SN1->N1_XPA
	If Empty(cArmPat)
		Conout("#TTPROC25 - ERRO - PATRIMONIO SEM PA -> " +cNumChapa +" - OS: " +cNumOS)
		Return
	EndIf
EndIf
	
// residente
If _lResid	
	_cArmA := "A"+SubStr(cArmPat,2)
	_cArmP := cArmPat
// rota movel
Else
	lRota := .T.
	cArmazem := cRota
	_cArmP := cArmPat
EndIf


// verificar se rota ou pa para bloquear movimentos caso armazem esteja bloqueado
dbSelectArea("ZZ1")
dbSetOrder(1)
If lRota
	If MSSeek( xFilial("ZZ1") +AvKey( cArmazem,"ZZ1_COD") )
		If AllTrim(ZZ1->ZZ1_MSBLQL) == "1"
			Conout("#TTPROC25 - ARMAZEM BLOQUEADO -> " +cArmazem +" - OS: " +cNumOS)
			Return
		EndIf
	EndIf	
Else
	If MSSeek( xFilial("ZZ1") +AvKey( _cArmA,"ZZ1_COD") )
		If AllTrim(ZZ1->ZZ1_MSBLQL) == "1"
			Conout("#TTPROC25 - ARMAZEM BLOQUEADO  -> " +cArmazem +" - OS: " +cNumOS)
			Return
		EndIf
	EndIf		
EndIf


       
dbSelectArea("SZN")
dbSetOrder(4)
If MSSeek( xFilial("SZN") +AvKey(cNumOS,"ZN_NUMOS") )
	lGravaCont := .F.
EndIf

If lGravaCont
	/*
	abastecimento + sangria + leitura
		- abastec(leitura)
		- sangria
		
	sangria + leitura
		- sangria
	
	abastecimento + leitura
		- abastec(leitura)
	*/	               

	If Len(aLeitura) > 0
		lLeitura := .T.
	EndIf
	If Len(aSangria) > 0
		lSangria := .T.
	EndIf
	If Len(aItens) > 0
		lAbastec := .T.
	EndIf
	
	If lLeitura// .And. lAbastec
		StaticCall( MXML003, ExecFrm2, cNumOS, aDados, "02" )	
	EndIf
	
								
	If ( lSangria .And. lLeitura ) .Or. ( lAbastec .And. lSangria .And. lLeitura )
		StaticCall( MXML003, ExecFrm2, cNumOS, aDados, "03" )
	EndIf	
EndIf


// Grava o mapa de produtos para o patrimonio/produto
If lBebida
	cAuxM := "00"
EndIf

cTmEnt := "100"
cTmSai := "600"
// residente
If _lResid
	cLocalDest := _cArmA
// rota movel	
Else
	cLocalDest := _cArmP
EndIf


BEGIN TRANSACTION
	For nI := 1 To Len(aItens)
		lTroca		:= .F.
		nRecSZH		:= 0
		
		cProduto	:= aItens[nI][nPProduto]
		cPosicao	:= AllTrim(aItens[nI][2])
		cProdNovo	:= ""
		
		If lBebida
			cAuxM := Soma1(cAuxM) 
			cPosicao := cAuxM
		EndIf
	
		nQtdSaldo	:= aItens[nI][nPSaldo]
		nQtdAbast	:= aItens[nI][nPAbast]	// sai R ou P   entra P ou A e M
		nQtdRetir	:= aItens[nI][nPRetir]	// sai M e A ou P	entra R ou A e P
		nQtdAvari	:= aItens[nI][nPRavar]	// sai M e A ou P  entra R ou A e P
		
		nQtdAbOri := nQtdAbast
		
		cProdNovo	:= aItens[nI][nPPrdNovo]
		nSaldo2		:= aItens[nI][nPSaldo2]
		nAbast2		:= aItens[nI][nPAbast2]
		nRetir2		:= aItens[nI][nPRetir2]
		nAvar2		:= aItens[nI][nPRavar2] 
		
		nQtdAbOri2 := nAbast2
		
		
		// tratar a troca da capacidade da mola
		nCapN		:= aItens[nI][nPNewCap]
		
		// REGISTRO DA MOLA NO MAPA DA MAQUINA    
		nRecSZH := RecZH( cNumChapa,cProduto,cPosicao )
		
		// trocou produto ou trocou capacidade mola
		If !Empty(cProdNovo) .Or. nCapN > 0
			If !Empty(cProdNovo)
				lTroca := .T.
			EndIf
			
			// alterar o mapa aqui - SZH
			If nRecSZH > 0
				dbSelectArea("SZH")
				dbGoTo(nRecSZH)
				RecLock("SZH",.F.)
				
				// trocou produto
				If !Empty(cProdNovo)
					SZH->ZH_CODPROD := cProdNovo
				EndIf
				
				// trocou capacidade
				If nCapN > 0
					SZH->ZH_QUANT	:= nCapN
				EndIf
				
				MsUnLock()
				CONOUT("#TTPROC25 - MAPA ALTERADO MAQ:" +cNumChapa +" - MOLA:" +cPosicao)
			EndIf
		EndIf
		
		If Empty(cPosicao)
			Loop
		Else
			// bebida
			If lBebida
				nEsqM := Ascan(aEsqMola,{|x| x[1] = substr(cPosicao,1,1)})
				Do Case
					Case nEsqM == 1
						nEsqM := 0 + val(substr(cPosicao,2)) //,1))
						if nEsqM == 0
							nEsqM := 10
						endif
					Case nEsqM == 2
						nEsqM :=  val(substr(cPosicao,2)) //val('1' + substr(cPosicao,2,1))
						if nEsqM == 10
							nEsqM := 20
						else
							nEsqM := '1'+cvaltochar(nEsqM)
						endif
					Case nEsqM == 3
						nEsqM := val(substr(cPosicao,2)) //val('2' + ,1))
						if nEsqM == 10
							nEsqM := 30    
						else
							nEsqM := '2'+cvaltochar(nEsqM)
						endif
					Case nEsqM == 4
						nEsqM := val(substr(cPosicao,2)) //,1))
						if nEsqM == 10
							nEsqM := 40
						else
							nEsqM := '3'+cvaltochar(nEsqM)
						endif
					Case nEsqM == 5
						nEsqM := val(substr(cPosicao,2)) //,1))
						if nEsqM == 10
							nEsqM := 50
						else
							nEsqM := '4'+cvaltochar(nEsqM)
						endif
					Case nEsqM == 6
						nEsqM := val(substr(cPosicao,2)) //,1))
						if nEsqM == 10
							nEsqM := 60
						else
							nEsqM := '5'+cvaltochar(nEsqM)
						endif
					Case nEsqM == 7
					//Esta parte sera utilizada para controlar as molas de cafe
						nEsqM := val(substr(cPosicao,2)) //,1))
						if nEsqM == 10
							nEsqM := 60
						else
							nEsqM := '5'+cvaltochar(nEsqM)
						endif
				End Case
			
				nEsqM := cvaltochar(nEsqM)
			// snacks
			Else 
				nEsqM := cPosicao //cAuxM
			EndIf
		EndIf	
		     
		dbSelectArea("SZ6")
		dbSetOrder(1)
		
		If lRota
			nQtdTot := 0
			nQtdDisp := 0
			   
			If MSSeek( xFilial("SZ6") +AvKey(cRota,"Z6_LOCAL") +AvKey(cProduto,"Z6_COD") )
				nQtdDisp := SZ6->Z6_QATU
			EndIf
					
			//SldArmMov( cRota,cProduto,@nQtdTot,@nQtdDisp )		
			/*
			If nQtdAbast > nQtdDisp
				nQtdAbast := 0
			EndIf
			*/
		
		Else
			If MSSeek( xFilial("SZ6") +AvKey(_cArmA,"Z6_LOCAL") +AvKey(cProduto,"Z6_COD") )
				nQtdDisp := SZ6->Z6_QATU
			EndIf
			/*
			If nQtdAbast > nQtdDisp
				nQtdAbast := 0
				//nErroSaldo++
			EndIf
			*/	   
		EndIf
		
	    /*
		If nQtdAbast > nQtdDisp
			nQtdAbast := 0
			//nErroSaldo++
		EndIf
		*/	   
		
		
		dbSelectArea("SZ5")
		dbSetOrder(4)	// filial local os mola prod tipo data 
	  	// ABASTECIDO
		If nQtdAbast > 0
			// ROTA
			If lRota
				lOk := .F.

				If !ChkMovZ5( cRota, cProduto, _ABAST, cNumOS, cPosicao, _dDtFim, nQtdAbast, cTmSai )
					// SAI DO ARMAZEM ROTA
					lOk := U_MNTSZ5( cRota,cProduto,cTmSai,_dDtFim,nQtdAbast,cNumOS,cPosicao,_OPER1,_ORIGD,cNumChapa,_ABAST,.T. )									
					
					If lOk .And. !ChkMovZ5( cLocalDest, cProduto, _ABAST, cNumOS, cPosicao, _dDtFim , nQtdAbast, cTmEnt )
						// ENTRA NO ARMAZEM PA
						U_MNTSZ5( cLocalDest,cProduto,cTmEnt,_dDtFim,nQtdAbast,cNumOS,cPosicao,_OPER2,_ORIGD,cNumChapa,_ABAST,.T. )
					EndIf
					
					// baixa arm movel - sz7
					//If lRota .And. nQtdAbast > 0
						BXArmMov( cRota,cProduto,nQtdAbast )
					//EndIf 
					
				EndIf
				
			// PA
			Else
				If !ChkMovZ5( _cArmA, cProduto, _ABAST, cNumOS, cPosicao, _dDtFim,nQtdAbast, cTmSai ) 
					// SAI DO ARMAZEM ARMARIO
					U_MNTSZ5( _cArmA,cProduto,cTmSai,_dDtFim,nQtdAbast,cNumOS,cPosicao,_OPER3,_ORIGD,cNumChapa,_ABAST,.F. )
				EndIf
			EndIf
			
			// ENTRA NO ARMAZEM M - MAQUINA
			If !ChkMovZ5( _cArmM, cProduto, _ABAST, cNumOS, cPosicao, _dDtFim,nQtdAbast, cTmEnt ) 
				U_MNTSZ5( _cArmM,cProduto,cTmEnt,_dDtFim,nQtdAbast,cNumOS,cPosicao,_OPER9,_ORIGD,cNumChapa,_ABAST )
				    
				// saldo mola
				If nRecSZH > 0     
					dbGoTo(nRecSZH)
					RecLock("SZH",.F.) 
					SZH->ZH_SALDO := ( SZH->ZH_SALDO + nQtdAbast ) 
					SZH->( MsUnLock() )
				EndIf
				
			EndIf			      
	  	EndIf
	  	             
	  	// RETIRADO
	  	If nQtdRetir > 0
			// ROTA
			If lRota
				lOk := .F.
				
				If !ChkMovZ5( cLocalDest, cProduto, _RETIR, cNumOS, cPosicao, _dDtFim,nQtdRetir, cTmSai )
					// SAI DO ARMAZEM PA
					lOk := U_MNTSZ5( cLocalDest,cProduto,cTmSai,_dDtFim,nQtdRetir,cNumOS,cPosicao,_OPER4,_ORIGD,cNumChapa,_RETIR,.T. )	// sai pa
					
					If lOk .And. !ChkMovZ5( cRota, cProduto, _RETIR, cNumOS, cPosicao, _dDtFim,nQtdRetir, cTmEnt )
						// ENTRA NO ARMAZEM ROTA
						U_MNTSZ5( cRota,cProduto,cTmEnt,_dDtFim,nQtdRetir,cNumOS,cPosicao,_OPER5,_ORIGD,cNumChapa,_RETIR,.T.)	// entra rota
					EndIf
					
					SBArmMov( cRota,cProduto,nQtdRetir )
				EndIf
				
			// PA
			Else
				If !ChkMovZ5( _cArmA, cProduto, _RETIR, cNumOS, cPosicao, _dDtFim,nQtdRetir, cTmEnt ) 
					// ENTRA NO ARMAZEM ARMARIO
					U_MNTSZ5( _cArmA,cProduto,cTmEnt,_dDtFim,nQtdRetir,cNumOS,cPosicao,_OPER6,_ORIGD,cNumChapa,_RETIR,.F. )
				EndIf
			EndIf
			
			// SAI DO ARMAZEM M - MAQUINA
			If !ChkMovZ5( _cArmM, cProduto, _RETIR, cNumOS, cPosicao, _dDtFim,nQtdRetir, cTmSai ) 
				U_MNTSZ5( _cArmM,cProduto,cTmSai,_dDtFim,nQtdRetir,cNumOS,cPosicao,_OPER10,_ORIGD,cNumChapa,_RETIR )
				 
				// saldo mola
				If nRecSZH > 0     
					dbGoTo(nRecSZH)
					RecLock("SZH",.F.) 
					SZH->ZH_SALDO := ( SZH->ZH_SALDO - nQtdRetir ) 
					SZH->( MsUnLock() )
				EndIf
				
			EndIf	
	  	EndIf
		  	
	  	// DESCARTE/AVARIA
	  	If nQtdAvari > 0 
			// ROTA
			If lRota
				lOk := .F.
				
				If !ChkMovZ5( cLocalDest, cProduto, _AVAR, cNumOS, cPosicao, _dDtFim,nQtdAvari, cTmSai )
					// SAI DO ARMAZEM PA
					lOk := U_MNTSZ5( cLocalDest,cProduto,cTmSai,_dDtFim,nQtdAvari,cNumOS,cPosicao,_OPER7,_ORIGD,cNumChapa,_AVAR,.T. )
				EndIf
			
			// PA
			Else
				If !ChkMovZ5( _cArmA, cProduto, _AVAR, cNumOS, cPosicao, _dDtFim,nQtdAvari, cTmEnt )
					// ENTRA NO ARMAZEM ARMARIO -> GERA O MOVIMENTO PARA CONSULTA MAS NAO ATUALIZA O SALDO
					U_MNTSZ5( _cArmA,cProduto,cTmEnt,_dDtFim,nQtdAvari,cNumOS,cPosicao,_OPER8,_ORIGD,cNumChapa,_AVAR,.F.,"","",.F. )
				EndIf
			EndIf
			
			// SAI NO ARMAZEM M - MAQUINA
			If !ChkMovZ5( _cArmM, cProduto, _AVAR, cNumOS, cPosicao, _dDtFim,nQtdAvari, cTmSai ) 
				U_MNTSZ5( _cArmM,cProduto,cTmSai,_dDtFim,nQtdAvari,cNumOS,cPosicao,_OPER11,_ORIGD,cNumChapa,_AVAR )
				
				// saldo mola
				If nRecSZH > 0     
					dbGoTo(nRecSZH)
					RecLock("SZH",.F.) 
					SZH->ZH_SALDO := ( SZH->ZH_SALDO - nQtdAvari ) 
					SZH->( MsUnLock() )
				EndIf
				
			EndIf	
		EndIf
	  	        		
		// OPERACAO DO ABASTECIMENTO - SZ0
		dbSelectArea("SZ0")
		dbSetOrder(1)	// filial patrimonio mola cliente loja produto os	
		If !MSSeek( xFilial("SZ0") +AvKey(cNumChapa,"Z0_CHAPA") +AvKey(nEsqM,"Z0_MOLA") +AvKey(cCliOs,"Z0_CLIENTE") +AvKey(cLjOs,"Z0_LOJA") +AvKey(cProduto,"Z0_PRODUTO") +AvKey(cNumOS,"Z0_NUMOS") )
			Reclock("SZ0",.T.)
			SZ0->Z0_FILIAL	:=	xFilial("SZ0")
			SZ0->Z0_CHAPA	:=	cNumChapa
			SZ0->Z0_DATA	:= 	_dDtFim
			SZ0->Z0_CLIENTE	:=	cCliOs
			SZ0->Z0_LOJA	:=	cLjOs
			SZ0->Z0_MOLA	:=	nEsqM
			SZ0->Z0_SALDO	:=	nQtdSaldo	
			SZ0->Z0_ABAST	:=	nQtdAbast
			SZ0->Z0_ABAPONT :=  nQtdAbOri
			SZ0->Z0_RETIR	:=	nQtdRetir
			SZ0->Z0_AVARIA	:=	nQtdAvari
			SZ0->Z0_SLDMOV	:=	nQtdSaldo + nQtdAbast - nQtdRetir - nQtdAvari
			SZ0->Z0_NUMOS	:=	cNumOS      
			SZ0->Z0_PRODUTO	:=	cProduto
			SZ0->Z0_PA		:=	IIF( _lResid,_cArmA,cArmPat )
			SZ0->Z0_ARMORI	:=  IIF( lRota,cRota,_cArmA )
			SZ0->(Msunlock())
		EndIf
		
	
		
		// TROCA DE PRODUTO - SOMENTE ABASTECIMENTO
		If lTroca .And. cProdNovo <> cProduto	// tratamento para nao aceitar duplicidade de produto na mesma mola
			    
			dbSelectArea("SZ6")
			dbSetOrder(1)
		
			If lRota
				nQtdTot := 0
				nQtdDisp := 0
				
				If MSSeek( xFilial("SZ6") +AvKey( cRota,"Z6_LOCAL" ) +AvKey(cProdNovo,"Z6_COD") )
					nQtdDisp := SZ6->Z6_QATU
				EndIf
												
				//SldArmMov( cRota,cProdNovo,@nQtdTot,@nQtdDisp )
				/*
				If nAbast2 > nQtdDisp
					nAbast2 := 0     
				EndIf
				*/
			Else
				If MSSeek( xFilial("SZ6") +AvKey( _cArmA,"Z6_LOCAL" ) +AvKey(cProdNovo,"Z6_COD") )
					nQtdDisp := SZ6->Z6_QATU
				EndIf
				/*
				If nAbast2 > nQtdDisp
					nAbast2 := 0
					//nErroSaldo++
				EndIf
				*/
			EndIf	          
		
			/*
			If nAbast2 > nQtdDisp
				nAbast2 := 0
				//nErroSaldo++
			EndIf
			*/
				
			dbSelectArea("SZ5")
			dbSetOrder(4)	// filial local os mola prod tipo data 
						
			If nAbast2 > 0
				lOk := .F.
			
				// ROTA
				If lRota
				
					If !ChkMovZ5( cRota, cProdNovo, _ABAST, cNumOS, cPosicao, _dDtFim,nAbast2, cTmSai )
						// SAI DA ROTA
						lOk := U_MNTSZ5( cRota,cProdNovo,cTmSai,_dDtFim,nAbast2,cNumOS,cPosicao,_OPER1,_ORIGD,cNumChapa,_ABAST,.T. )			
						
						If lOk .And. !ChkMovZ5( cLocalDest, cProdNovo, _ABAST, cNumOS, cPosicao, _dDtFim,nAbast2, cTmEnt  )
							// ENTRA NA PA
							U_MNTSZ5( cLocalDest,cProdNovo,cTmEnt,_dDtFim,nAbast2,cNumOS,cPosicao,_OPER2,_ORIGD,cNumChapa,_ABAST,.T. )
						EndIf
						                                   
						// baixa saldo - sz7
						BXArmMov( cRota,cProdNovo,nAbast2 ) 
						
					EndIf
				// PA
				Else
					If !ChkMovZ5( _cArmA, cProdNovo, _ABAST, cNumOS, cPosicao, _dDtFim,nAbast2, cTmSai )
						// SAI DO ARMARIO
						U_MNTSZ5( _cArmA,cProdNovo,cTmSai,_dDtFim,nAbast2,cNumOS,cPosicao,_OPER3,_ORIGD,cNumChapa,_ABAST,.F. )
					EndIf
				EndIf
				
				// ENTRA NO ARMAZEM M - MAQUINA
				If !ChkMovZ5( _cArmM, cProduto, _ABAST, cNumOS, cPosicao, _dDtFim,nAbast2, cTmEnt ) 
					U_MNTSZ5( _cArmM,cProduto,cTmEnt,_dDtFim,nAbast2,cNumOS,cPosicao,_OPER9,_ORIGD,cNumChapa,_ABAST )
					      
					// saldo mola
					If nRecSZH > 0     
						dbGoTo(nRecSZH)
						RecLock("SZH",.F.) 
						SZH->ZH_SALDO := ( SZH->ZH_SALDO + nAbast2 ) 
						SZH->( MsUnLock() )
					EndIf
				
				EndIf			
		  	EndIf
		  	         
		 			
			dbSelectArea("SZ0")
			If !MSSeek( xFilial("SZ0") +AvKey(cNumChapa,"Z0_CHAPA") +AvKey(nEsqM,"Z0_MOLA") +AvKey(cCliOs,"Z0_CLIENTE") +AvKey(cLjOs,"Z0_LOJA") +AvKey(cProdNovo,"Z0_PRODUTO") +AvKey(cNumOS,"Z0_NUMOS") )
				Reclock("SZ0",.T.)
				SZ0->Z0_FILIAL	:=	xFilial("SZ0")
				SZ0->Z0_CHAPA	:=	cNumChapa
				SZ0->Z0_DATA	:= 	_dDtFim
				SZ0->Z0_CLIENTE	:=	cCliOs
				SZ0->Z0_LOJA	:=	cLjOs
				SZ0->Z0_MOLA	:=	nEsqM
				SZ0->Z0_SALDO	:=	nSaldo2	
				SZ0->Z0_ABAST	:=	nAbast2
				SZ0->Z0_ABAPONT :=  nQtdAbOri2
				SZ0->Z0_RETIR	:=	nRetir2
				SZ0->Z0_AVARIA	:=	nAvar2
				SZ0->Z0_SLDMOV	:=	( nSaldo2 + nAbast2 - nRetir2 - nAvar2 )
				SZ0->Z0_NUMOS	:=	cNumOS      
				SZ0->Z0_PRODUTO	:=	cProdNovo
				SZ0->Z0_PA		:= IIF( _lResid,_cArmA,cArmPat )
				SZ0->Z0_ARMORI	:= IIF( lRota,cRota,_cArmA )
				SZ0->(Msunlock())
			EndIf
		
			// baixa arm movel
			//If lRota .And. nAbast2 > 0						
			//	BXArmMov( cRota,cProdNovo,nAbast2 )
			//EndIf 		
		EndIf
	Next nI          

	dbSelectArea("SZG")
	If RecLock("SZG",.F.)
		SZG->ZG_PROC := "BR_VERDE"
		SZG->(MsUnLock())
	EndIf

END TRANSACTION

RestArea(aArea)

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkMovZ5  บAutor  ณJackson E. de Deus  บ Data ณ  04/25/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se movimento SZ5 ja existe                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkMovZ5( cArmazem, cProduto, cTipo, cNumOs, cMola, dData, nQtd,cTM )

Local lExiste := .F.
Local cQuery := ""

cQuery := "SELECT COUNT(*) TOTAL FROM " +RetSqlName("SZ5")
cQuery += " WHERE Z5_LOCAL = '"+cArmazem+"' AND Z5_COD = '"+cProduto+"' AND Z5_TIPO = '"+cTipo+"' "
cQuery += " AND Z5_NUMOS = '"+cNumOs+"' AND Z5_MOLA = '"+cMola+"' AND Z5_EMISSAO = '"+DTOS(dData)+"' "
cQuery += " AND Z5_QUANT = '"+CVALTOCHAR(nQtd)+"' AND Z5_TM = '"+cTM+"' "
cQuery += " AND D_E_L_E_T_ = '' "	

MpSysOpenQuery( cQuery, "TRBZ5" )

dbSelectArea("TRBZ5")
If TRBZ5->TOTAL > 0
	lExiste := .T.
EndIf

TRBZ5->( dbCloseArea() )


Return lExiste



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGeraPedidoบAutor  ณMicrosiga           บ Data ณ  23/04/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Pedido de Descarte referente aos itens apontados como avariaฑฑ
ฑฑบ          ณ na OS                                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GeraPedido(cCodCli,cLjCli,cArmazem,cNumOS,aItens,cMsgNF)

Local lRet := .F.
Local cNumPed := ""
Local lVldPedido := .F.
Local cMenNota := ""
Local cXGPV := "PCA"
Local nItem := "01"
Local aAux := {}
Local nCustStd := 0
Local nPreco := 0
Local cUM := ""
Local cSegUM := ""
Local aSC5 := {}
Local aSC6 := {}
Local lSimula := .F.
Local nVol := 0
Local nI
Private lMsErroAuto		:= .F.
Private lMsHelpAuto 	:= .T.
Private lAutoErrNoFile	:= .F.

Default cCodCli := ""
Default cLjCli := ""
Default cArmazem := ""
Default cNumOs := ""
Default aItens := {}
Default cMsgNF := ""

If Empty(cCodCli) .Or. Empty(cLjCli) .Or. Empty(cArmazem) .Or. Empty(aItens)
	Return
EndIf



// Gera o pedido de venda
While !lVldPedido
	cNumPed := GetSX8NUM("SC5","C5_NUMERO")
	lVldPedido := VldNumPed(cNumPed,cFilAnt)
	If !lVldPedido
		RollBackSx8()
	EndIf
End

If !Empty(cMsgNF)
	cMenNota := cMsgNF
Else
	cMenNota := "Descarte referente ao armazem " +cArmazem
EndIf


cTpCli := Posicione("SA1",1,xFilial("SA1")+cCodCli+cLjCli,"A1_TIPO")
cDescCli := Posicione("SA1",1,xFilial("SA1")+cCodCli+cLjCli,"A1_NREDUZ")
//cCusto := "70500002"	//"70500007" 
cItemCC := Posicione("ZZ1",1,xFilial("ZZ1") +cArmazem,"ZZ1_ITCONT")		  
cMesRef	:=	cvaltochar(strzero(month(dDatabase),2))+"/"+substr(cvaltochar(year(dDatabase)),3)

// Separa os produtos - somente os que foram retirados por avaria/descarte
For nI := 1 To Len(aItens)
	If aItens[nI][2] > 0
		AADD(aAux, { aItens[nI][1],;
					 aItens[nI][2],;
					  0,;
					  "",;
					  "" } )	     
	EndIf			  
Next nI 
       
// Busca preco/UM
For nI := 1 To Len(aAux)
	cProduto := aAux[nI][1]
	nCustStd := Posicione("SB1",1,xFilial("SB1")+AvKey(cProduto,"B1_COD"), "B1_CUSTD" )
	cUM := Posicione("SB1",1,xFilial("SB1")+AvKey(cProduto,"B1_COD"), "B1_UM" )
	cSegUM := Posicione("SB1",1,xFilial("SB1")+AvKey(cProduto,"B1_COD"), "B1_SEGUM" )
	
	nPreco := nCustStd	//Round( nCustStd * 1.42, 4 )
	
	aAux[nI][3] := nPreco
	aAux[nI][4] := cUM
	aAux[nI][5] := cSegUM	
Next nI


For nI := 1 To Len(aAux)
	cProduto := aAux[nI][1]
	nQtd := aAux[nI][2]
	cCusto := "70500007"
	cItemCC := Posicione("ZZ1",1,xFilial("ZZ1") +cArmazem,"ZZ1_ITCONT")		  
	nPreco := aAux[nI][3]
	cUM := aAux[nI][4]
	cSegUM := aAux[nI][5]
	
	nVol += nQtd

	Aadd(aSC6,{{"C6_FILIAL"	 	, cFilAnt					,Nil},;
				{"C6_NUM"    	, cNumPed					,Nil},;
				{"C6_ITEM"   	, nItem 					,Nil},;
				{"C6_PRODUTO"	, cProduto					,Nil},;
				{"C6_XPRDORI"	, cProduto		 			,Nil},;
				{"C6_QTDVEN" 	, nQtd						,Nil},; 
				{"C6_TPOP"		, "F" 						,Nil},;	
				{"C6_PRCVEN"	, nPreco		  			,Nil},;
				{"C6_VALOR"		, Round(nQtd*nPreco,6)		,Nil},;
				{"C6_PRUNIT"	, nPreco					,Nil},;			
				{"C6_TES"		, "934"						,Nil},;
				{"C6_CLI"		, cCodCli					,Nil},;
				{"C6_LOJA"		, cLjCli					,Nil},;
				{"C6_LOCAL"		, cArmazem					,Nil},;
				{"C6_CCUSTO"	, cCusto	 				,Nil},;
				{"C6_ITEMCC"	, cItemCC					,Nil},;
				{"C6_XGPV"		, cXGPV						,Nil},;
				{"C6_ENTREG"	, dDatabase					,Nil},;
				{"C6_XHRINC"	, Time()					,Nil},;
				{"C6_XDATINC"	, Date()					,Nil},;
				{"C6_XUSRINC"	, cUsername					,Nil}})
					
	nItem := Soma1(nItem)
Next nI


Aadd(aSC5, {"C5_FILIAL" 	,xFilial("SC5")		,Nil})
Aadd(aSC5, {"C5_NUM"    	,cNumPed			,Nil})
Aadd(aSC5, {"C5_TIPO"   	,"N"      			,Nil})
Aadd(aSC5, {"C5_CLIENTE"	,cCodCli 			,Nil})
Aadd(aSC5, {"C5_LOJACLI"	,cLjCli				,Nil})
Aadd(aSC5, {"C5_CLIENT"		,cCodCli 			,Nil})
Aadd(aSC5, {"C5_LOJAENT"	,cLjCli				,Nil})
Aadd(aSC5, {"C5_XDTENTR"	,dDatabase			,Nil})
Aadd(aSC5, {"C5_XNFABAS"	,"2"				,Nil})
Aadd(aSC5, {"C5_XCODPA"		,cArmazem			,Nil})
Aadd(aSC5, {"C5_XFINAL" 	,"L"				,Nil})
Aadd(aSC5, {"C5_TRANSP" 	,"000019"			,Nil})
Aadd(aSC5, {"C5_XTPCARG"	,"1"				,Nil})      
Aadd(aSC5, {"C5_XHRPREV"	,"00:00"			,Nil})  
Aadd(aSC5, {"C5_CONDPAG"	,"001"				,Nil})
Aadd(aSC5, {"C5_MOEDA"		,1 					,Nil})
Aadd(aSC5, {"C5_FRETE"		,0 					,Nil})
Aadd(aSC5, {"C5_TXMOEDA"	,0 					,Nil})
Aadd(aSC5, {"C5_EMISSAO"	,dDatabase			,Nil})
Aadd(aSC5, {"C5_MENNOTA"	,cMenNota			,Nil})
Aadd(aSC5, {"C5_ESPECI1"	,"UN"				,Nil})
Aadd(aSC5, {"C5_XRINC"		,Time()				,Nil})
Aadd(aSC5, {"C5_XDATINC"	,Date()				,Nil})
Aadd(aSC5, {"C5_XNOMUSR"	,cUserName			,Nil})
Aadd(aSC5, {"C5_XCODUSR"	,__cUserID			,Nil})
Aadd(aSC5, {"C5_XDESCLI"	,cDescCli			,Nil})  
Aadd(aSC5, {"C5_TPFRET" 	,"C" 				,Nil})	
Aadd(aSC5, {"C5_TIPOCLI"	,cTpCli				,Nil})	
Aadd(aSC5, {"C5_TIPLIB" 	,"1"         		,Nil})	
Aadd(aSC5, {"C5_VEND1"  	,"000023"			,Nil})
Aadd(aSC5, {"C5_XDESCLI"	,cDescCli			,Nil})
Aadd(aSC5, {"C5_VOLUME1"	,nVol				,Nil})
Aadd(aSC5, {"C5_XGPV"	 	,cXGPV				,Nil})
Aadd(aSC5, {"C5_XCCUSTO"	,cCusto				,Nil})
Aadd(aSC5, {"C5_XITEMCC"	,cItemCC			,Nil})
Aadd(aSC5, {"C5_XMESREF"	,cMesRef			,Nil})

	
MsExecAuto({|x, y, z| MATA410(x, y, z)}, aSC5, aSC6, 3,lSimula)                    

dbSelectArea("SC5")
dbSetOrder(1)
If MSSeek( xFilial("SC5") +AvKey(cNumPed,"C5_NUM") )
	ConfirmSX8()
Else
	If lMsErroAuto
		MostraErro()
	EndIf
	RollBackSX8()
	cNumPed := ""
EndIf


Return cNumPed


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldNumPed  บAutor  ณJackson E. de Deus บ Data ณ  18/02/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida o numero do pedido                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldNumPed(cNumPed,cFilAnt)

Local lRet := .T.
Local cQuery := ""

cQuery := "SELECT COUNT(*) TOTAL FROM " +RetSqlName("SC5")
cQuery += " WHERE C5_FILIAL = '"+cFilAnt+"' AND C5_NUM = '"+cNumPed+"' AND D_E_L_E_T_ = '' "

If Select("TRBC5") > 0
	TRBC5->( dbCloseArea() )
EndIf                       

TcQuery cQuery New Alias "TRBC5"
                               
dbSelectArea("TRBC5")
If !EOF()
	If TRBC5->TOTAL > 0
		lRet := .F.
	EndIf
EndIf

dbCloseArea()

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFatura  บAutor  ณJackson E. de Deus    บ Data ณ  18/02/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera o orcamento                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Fatura(cNumOS)

Local aRet := {"",""}
Local lTrcTab := .F.
Local cNumChapa := ""
Local cCliOS := "" 
Local aAux1t := {}
Local cTabela := ''
Local nTp := 0
Default cNumOS := ""

If Empty(cNumOS)
	Return aRet
EndIf

aRet := U_TTFAT20C(cNumOS)

dbSelectArea("SZG")
dbSetOrder(1)
If msSeek( xFilial("SZG") +AvKey(cNumOS,"ZG_NUMOS") )
	If CVALTOCHAR(SZG->ZG_TPFORM) $ '4/8/18/19/21/22'               
		cNumChapa := AllTrim( SZG->ZG_PATRIM )
		cCliOS := AllTrim(SZG->ZG_CLIFOR)
		_dDtFim := SZG->ZG_DATAFIM
		//Troca de tabela de pre็o
		If !Empty(SZG->ZG_VALIDAR)
			lTrcTab := .T.
		EndIf
	EndIf
EndIf
	
//Caso tenha sido uma OS de troca de tabela, apos a geracao dos pedidos e orcamentos para o cliente no preco antigo para esta leitura
//sera alterado a tabela de preco no patrimonio e apagado o conteudo do campo ZE_TABELA do registro que gerou esta os para o abastecedor.
If lTrcTab// .And. !Empty(aRet[1])	// troca tabela e gerou orcamento
	cQuery := "SELECT R_E_C_N_O_ AS REC,ZE_TABELA FROM "+RetSQLName("SZE")
	cQuery += " WHERE ZE_FILIAL='"+xFilial("SZE")+"' AND ZE_CHAPA='"+cNumChapa+"' AND ZE_CLIENTE='"+cCliOS+"'"
	cQuery += " AND ZE_MENSAL LIKE '"+Substr(dtos(_dDtFim),1,6)+"%' AND ZE_TABELA<>'' AND D_E_L_E_T_=''"

	If Select("TRB") > 0
		dbSelectArea("TRB")
		dbCloseArea()
	EndIf
	  
	MemoWrite("TTPROC25.SQL",cQuery)
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
	                   
	aAux1t := {}
	cTabela := ''
	DbSelectArea("TRB")
	While !EOF()
		Aadd(aAux1t,TRB->REC)
		cTabela := TRB->ZE_TABELA
		Dbskip()
	EndDo                               
	
	
	DbSelectArea("SN1")
	DbSetORder(2)
	If msSeek(xFilial("SN1")+cNumChapa)
		Reclock("SN1",.F.)
		SN1->N1_XTABELA := cTabela
		SN1->(Msunlock())
	EndIf

	//Apos as alteracoes, limpar o campo
	If len(aAux1t) > 0
		DbSelectArea("SZE")
		For nTp := 1 to len(aAux1t)
			Dbgoto(aAux1t[nTp])
			Reclock("SZE",.F.)
			SZE->ZE_TABELA := SPACE(3)
			SZE->(Msunlock())
		Next nTp
	EndIf
	TRB->(dbCloseArea())
EndIf
	  
Return aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSldArmMov  บAutor  ณJackson E. de Deus บ Data ณ  10/07/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o saldo total e disponivel do produto              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SldArmMov( cArmazem,cProduto,nQtdTot,nQtdDisp )

Local cSql := ""

cSql := "SELECT * FROM " +RetSqlName("SZ7")
cSql += " WHERE "          
cSql += " Z7_ARMMOV = '"+cArmazem+"' "
cSql += " AND Z7_COD = '"+cProduto+"' "
cSql += " AND Z7_STATUS IN ( '1','2' ) "
cSql += " AND Z7_RETORNO = '' "
cSql += " AND D_E_L_E_T_= '' "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),'TRB',.F.,.T.)   

dbSelectArea("TRB")
While !EOF()                  
	nQtdDisp += TRB->Z7_QATU
	nQtdTot += TRB->Z7_QUANT	
	dbSkip()
End

TRB->(dbCloseArea())

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBXArmMov  บAutor  ณJackson E. de Deus  บ Data ณ  10/07/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Baixa saldo do produto                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function BXArmMov( cArmazem,cProduto,nQtdAbast )

Local aArea := Getarea()
Local cSql := ""
Local nQtdMv := 0
Local nSaldo := 0 
Local nBaixa := 0
Local nQtdFalta := 0
Local nI
Local aProds := {}

cSql := "SELECT Z7_QUANT, Z7_QATU, R_E_C_N_O_ Z7REC FROM " +RetSqlName("SZ7")
cSql += " WHERE "          
cSql += " Z7_ARMMOV = '"+cArmazem+"' "
cSql += " AND Z7_COD = '"+cProduto+"' "
cSql += " AND Z7_STATUS IN ( '1','2' ) "
cSql += " AND Z7_RETORNO = '' "
cSql += " AND D_E_L_E_T_= '' "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),'TRB',.F.,.T.)   

dbSelectArea("TRB")
While !EOF()
	If TRB->Z7_QATU > 0
		AADD( aProds, { TRB->Z7_QATU, Z7REC }  )		
	EndIf
	dbSkip()
End

For nI := 1 To Len(aProds)
	nSaldo += aProds[nI][1]
Next nI

If nSaldo >= nQtdAbast
	While nBaixa < nQtdAbast
		For nI := 1 To Len(aProds)		
			nQtdFalta := nQtdAbast - nBaixa
		
			dbSelectArea("SZ7")
			dbGoTo(aProds[nI][2])
			
			If SZ7->Z7_QATU >= nQtdFalta
				nQtdMv := nQtdFalta
			ElseIf SZ7->Z7_QATU <= nQtdFalta
			 	nQtdMv := SZ7->Z7_QATU
			EndIf
                	
			If RecLock("SZ7",.F.)
				SZ7->Z7_QATU := SZ7->Z7_QATU - nQtdMv
				SZ7->(MsUnLock())
			EndIf                          
		
			nBaixa += nQtdMv	
		Next nI
	End
EndIf

TRB->(dbCloseArea())

RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSBArmMov  บAutor  ณJackson E. de Deus  บ Data ณ  11/03/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Sobe saldo do produto no armazem movel                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SBArmMov(cArmazem,cProduto,nQuant)

Local aArea := Getarea()
Local cSql := ""
Local nQtdMv := 0
Local nSubiu := 0
Local nQPerm := 0
Local nI
Local aProds := {}
Local nSubiu := 0

cSql := "SELECT R_E_C_N_O_ Z7REC FROM " +RetSqlName("SZ7")
cSql += " WHERE "          
cSql += " Z7_ARMMOV = '"+cArmazem+"' "
cSql += " AND Z7_COD = '"+cProduto+"' "
cSql += " AND Z7_STATUS IN ('1','2') "
cSql += " AND Z7_RETORNO = '' "  
//cSql += " AND Z7_QATU+"+cvaltochar(nQuant) +" <= Z7_QUANT "	//cSql += " AND Z7_QATU < Z7_QUANT "
cSql += " AND D_E_L_E_T_= '' "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),'TRB',.F.,.T.)   

dbSelectArea("TRB")
While !EOF()
	AADD( aProds, { Z7REC }  )		
	dbSkip()
End

If !Empty(aProds)
	For nI := 1 To Len(aProds)		
		dbSelectArea("SZ7")
		dbGoTo(aProds[nI][1])
		
		If nSubiu == nQuant
			Exit
		EndIf
		
		nQPerm := ( SZ7->Z7_QUANT - SZ7->Z7_QATU )
		If nQPerm < nQuant 
			nQtdMv := ( nQuant - nQPerm )
		ElseIf nQPerm >= nQuant
			nQtdMv :=  nQuant
		EndIf        
			
		If RecLock("SZ7",.F.)
			SZ7->Z7_QATU := (SZ7->Z7_QATU + nQtdMv)
			SZ7->(MsUnLock())
		EndIf                          		
		
		nSubiu += nQtdMv
	Next nI
// nao encontrou	
Else
	CONOUT("#TTPROC25 - PROBLEMA AO SUBIR O SALDO: " +cArmazem +"/" +cProduto)
	//InputZS7(cArmazem,cProduto,nQuant)
EndIf	


TRB->(dbCloseArea())

RestArea(aArea)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRecZH  บAutor  ณJackson E. de Deus     บ Data ณ  17/02/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna o Recno da mola                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RecZH(cNumChapa,cProduto,cPosicao)

Local nRecno := 0
Local cQuery := ""

cQuery := "SELECT R_E_C_N_O_ RECSZH FROM " +RetSqlName("SZH")
cQuery += " WHERE ZH_CHAPA = '"+cNumChapa+"' AND ZH_CODPROD = '"+cProduto+"' AND ZH_MOLA = '"+cPosicao+"' AND ZH_STATUS = '3' AND ZH_MSBLQL <> '1' "

If Select("TRBX") > 0
	TRBX->(dbCloseArea())
EndIf   
               
TcQuery cQuery New Alias "TRBX"
dbSelectArea("TRBX")
If !EOF()
	nRecno := TRBX->RECSZH
EndIf

TRBX->(dbCloseArea())
		
Return nRecno


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC25  บAutor  ณJackson E. de Deus  บ Data ณ  28/04/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Inclui um registro no armazem movel da rota                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function InputZS7(cRota,cProduto,nQtdRetir)

Local cQuery := ""
Local lEntAtu := .F.
Local lEntAnt := .F.


cQuery := "SELECT TOP 1 SD2.R_E_C_N_O_ D2REC,* FROM " +RetSqlName("SF2") + " SF2 "
cQuery += " INNER JOIN " +RetSqlName("SD2") + " SD2 ON "
cQuery += " F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA "

// join armazem movel
cQuery += " INNER JOIN " +RetSqlName("SZ7") +" SZ7 ON "
cQuery += " Z7_FILIAL = D2_FILIAL "
cQuery += " AND Z7_DOC = D2_DOC "
cQuery += " AND Z7_SERIE = D2_SERIE "
cQuery += " AND Z7_COD = D2_COD "
cQuery += " AND Z7_ARMMOV = F2_XCODPA "
cQuery += " AND Z7_ARMORI = D2_LOCAL "

// where
cQuery += " WHERE F2_XCODPA = '"+cRota+"' AND F2_SERIE = '2' AND F2_FILIAL = '"+xFilial("SF2")+"' "
cQuery += " AND SF2.D_E_L_E_T_ = '' AND D2_COD = '"+cProduto+"' AND F2_DTIMP <> '' "
cQuery += " AND Z7_NFREUSO = '' AND Z7_STATUS = '3' "

cQuery += " ORDER BY F2_EMISSAO DESC "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf
                       
TcQuery cQuery New Alias "TRB"

dbSelectArea("TRB")
If !EOF()
	dbSelectArea("SD2")
	dbGoTo(TRB->D2REC)
	     
	dbSelectArea("SZ7")	
  	If RecLock("SZ7",.T.)
  		SZ7->Z7_FILIAL	:= xFilial("SZ7")
  		SZ7->Z7_DOC		:= SD2->D2_DOC	
  		SZ7->Z7_SERIE	:= SD2->D2_SERIE
  		SZ7->Z7_EMISSAO	:= STOD(TRB->F2_EMISSAO)
  		SZ7->Z7_SAIDA	:= Date()	// somente para snacks
  		SZ7->Z7_CLIENTE	:= SD2->D2_CLIENTE
  		SZ7->Z7_LOJA	:= SD2->D2_LOJA	
  		SZ7->Z7_TPENTRE	:= Posicione("ZZ1",1,xFilial("ZZ1")+AvKey(cRota,"ZZ1_COD"),"ZZ1_TIPO")
  		SZ7->Z7_ARMMOV	:= cRota
  		SZ7->Z7_ITEM	:= SD2->D2_ITEM	
  		SZ7->Z7_COD		:= SD2->D2_COD	
  		SZ7->Z7_QUANT	:= SD2->D2_QUANT
  		SZ7->Z7_QATU	:= nQtdRetir
  		SZ7->Z7_ARMORI	:= SD2->D2_LOCAL
  		SZ7->Z7_STATUS	:= "1" 
  		SZ7->Z7_NFREUSO	:= "1"     			
  		SZ7->(MsUnLock()) 
  	EndIf	
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMvB2Dst  บAutor  ณJackson E. de Deus   บ Data ณ  01/09/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza a quantidade de descarte da SB2                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MvB2Dst( nTpMov, cArmazem, cProduto, nQuant )

Local aArea := GetArea()

// somente armazem de rota
If SubStr(cArmazem,1,1) <> "R"
	Return
EndIf

dbSelectArea("SB2")
dbSetOrder(2)
If MsSeek( xFilial("SB2") +AvKey(cArmazem,"B2_LOCAL") +AvKey(cProduto,"B2_COD") )
	// baixa
	If nTpMov == 1
		If ( SB2->B2_QEMPSA - nQuant ) >= 0
			RecLock("SB2",.F.)
			SB2->B2_QEMPSA -= nQuant
			MsUnLock()                     
		EndIf
	// sobe
	ElseIf nTpMov == 2
		RecLock("SB2",.F.)
		SB2->B2_QEMPSA += nQuant
		MsUnLock()
	EndIf
EndIf

RestArea(aArea)

Return