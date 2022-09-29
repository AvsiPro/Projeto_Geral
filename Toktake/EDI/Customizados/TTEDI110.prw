#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"                
#INCLUDE "TOPCONN.CH"  
#INCLUDE "RWMAKE.CH"  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTEDI110  บAutor  ณAlexandre Venancio  บ Data ณ  03/21/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Nova rotina para importacao de pedidos do processamento.   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTEDI110()  
                         
Local nOpca := 0
Local aRegs			:={}
Local aSays 		:= {}
Local aButtons 		:= {}                                            
Local nPed			:= 0
Local cCadastro 	:= "TOKTAKE - Importacao de Pedidos Processamento"
Local lRet			:= .T.       
Local lGerouPv		:= .T.
Local cQuery		:= ""
Local cNumPed		:= ""  
Local aAreaC5		:= {}
Private cPergCal    := "TTEDI110"   
Private cTab		:= ""
Private aList		:= {}  
Private aItens		:= {}
Private aCabec		:= {}      
Private aC5			:= {}
Private aC6			:= {} 
Private aEmail		:= {} 
Private aParamU		:= {}
Private lMsErroAuto		:= .F.
Private lMsHelpAuto 	:= .T.
Private lAutoErrNoFile	:= .F.     
Private cTipTab		:= ""
 
aAdd(aRegs,{cPergCal,"01","Arquivo      ?","","","mv_ch1","C",150,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","DIR",""})
aAdd(aRegs,{cPergCal,"02","Filial       ?","","","mv_ch2","C",002,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","ZZZ",""})
aAdd(aRegs,{cPergCal,"03","Finalidade   ?","","","mv_ch3","C",001,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","ZZC",""})
//aAdd(aRegs,{cPergCal,"04","Tabela	    ?","","","mv_ch4","C",003,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","DA1",""})
aAdd(aRegs,{cPergCal,"04","M๊s Ref.	    ?","","","mv_ch4","C",005,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","Z9",""})
aAdd(aRegs,{cPergCal,"05","Centro Custo?","","","mv_ch5","C",020,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
//aAdd(aRegs,{cPergCal,"07","Cond. Pagto ?","","","mv_ch7","C",003,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SE4",""})
//aAdd(aRegs,{cPergCal,"08","Forma Pagto ?","","","mv_ch8","C",005,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","Z8",""})

If cEmpAnt <> "01"
	Return
EndIf

ValidPerg(aRegs,cPergCal) 
Pergunte(cPergCal,.F.)
             
aAdd(aSays,cCadastro)   
aAdd(aButtons, { 5,.T.,{|| Pergunte(cPergCal,.T. ) } } )
aAdd(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch() }} )
aAdd(aButtons, { 2,.T.,{|o| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )

If nOpca == 1
	Processa({|lEnd| lRet := LerArquivo()},OemToAnsi("Lendo Arquivo"))
	If lRet
		For nLinha := 1 to len(aList) 
			If Ascan(aCabec,{|x| x[4,2]+x[5,2]+x[10,2]+Alltrim(x[24,2]) == aList[nLinha,01]+aList[nLinha,02]+aList[nLinha,06]+AllTrim(aList[nLinha,05])}) == 0
				If Alltrim(Upper(cTipTab)) == "TABELA"
					cTab := If(len(aList[nLinha,07])<3,replicate("0",3-len(aList[nLinha,07]))+aList[nLinha,07],aList[nLinha,07])
				Else
					cTab := space(3)
				EndIF
				Processa({|lEnd| lRet := MontaCab(nLinha,++nPed)},OemToAnsi("Montando Cabe็alhos dos Pedidos"))
				Processa({|lEnd| lRet := MontaItem(nLinha,nPed)},OemToAnsi("Montando Itens dos Pedidos"))
			Else                                                                            
				Processa({|lEnd| lRet := MontaItem(nLinha,nPed)},OemToAnsi("Montando Itens dos Pedidos"))
			EndIf                                                                                         

			If !lRet
				exit
			EndIF
		Next nLinha
		If lRet
			Processa({|lEnd| lRet := GeraPed()},OemToAnsi("Gerando os Pedidos, aguarde!!!"))
		EndIf
	EndIf
EndIf	
  
If len(aEmail) > 0
	GeraPDF()
EndIf

Return  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTEDI110  บAutor  ณMicrosiga           บ Data ณ  03/26/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Geracao do pedido de venda.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GeraPed()

Local aArea		:=	GetArea()
Local nContc6	:= 0       
Local aAjuste	:=	{}
Local aAux		:=	{}

For nLinha := 1 to len(aCabec)  
	aC5 := {}
	aC6 := {}                       
	nContc6 := 0
	cQuery := "SELECT MAX(C5_NUM) AS ULTIMO FROM "+RetSQLName("SC5")+" WHERE C5_FILIAL='"+MV_PAR02+"' AND C5_NUM LIKE 'E%' AND D_E_L_E_T_=''"
	 
	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf       
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
	dbSelectArea("TRB")
	cNumPed := Soma1(TRB->ULTIMO)
                              
	For nP := 1 to len(aCabec[nLinha])
		Aadd(aC5,aCabec[nLinha,nP])    
	Next nP
	
	aAjuste := {}
	aAux 	:= {}
	For nLinha2 := 1 to len(aItens)
		If aItens[nLinha2,01,02]+cvaltochar(aItens[nLinha2,02,02]) == aCabec[nLinha,01,02]+cvaltochar(aCabec[nLinha,02,02])
			Aadd(aC6,aItens[nLinha2])
			aC6[len(aC6),2,2] := cNumPed            
			aC6[len(aC6),3,2] := strzero(++nContc6,2)	
			//Gambiarra para resolver o problema das 4 casas decimais dos pedidos do nerso da capitinga
			aAux := StrtokArr(cvaltochar(aC6[len(aC6),10,2]),".")
			If len(aAux) > 1
				If len(aAux[2]) > 2
					Aadd(aAjuste,{aC6[len(aC6),1,2],cNumPed,aC6[len(aC6),3,2],aC6[len(aC6),4,2],aC6[len(aC6),10,2],aC6[len(aC6),11,2],aC6[len(aC6),12,2]})
					aC6[len(aC6),10,2] := Round(aC6[len(aC6),10,2],2)
					aC6[len(aC6),11,2] := Round(aC6[len(aC6),10,2]*aC6[len(aC6),06,2],2)  //Round(aC6[len(aC6),11,2],2)
					aC6[len(aC6),12,2] := Round(aC6[len(aC6),12,2],2)
				EndIf
			EndIf
		EndIf
	Next nLinha2                                  

	aC5[02,02] := cNumPed
	
	If len(aC6) > 0 .And. len(aC5) > 0
		aParamU := {}
		Aadd(aParamU,{MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04,MV_PAR05})
		aAreaC5 := GetArea()
		
		MsExecAuto({|x, y, z| MATA410(x, y, z)}, aC5, aC6, 3)                    
		
		If lMsErroAuto
			MostraErro()
		EndIf           
		
		If len(aAjuste) > 0  
			DbSelectArea("SC6")
			DbSetOrder(1)    
			For nX := 1 to len(aAjuste)
				If DbSeek(aAjuste[nX,1]+aAjuste[nX,2]+aAjuste[nX,3]+aAjuste[nX,4])
					Reclock("SC6",.F.)
					SC6->C6_PRCVEN := aAjuste[nX,5]
					SC6->C6_VALOR  := aAjuste[nX,6]
					SC6->C6_PRUNIT := aAjuste[nX,7]
					SC6->(Msunlock())
				EndIf
			Next nX 
			DbSelectArea("SC9")
			DbSetOrder(1)
			For nX := 1 to len(aAjuste)
				If DbSeek(aAjuste[nX,1]+aAjuste[nX,2]+aAjuste[nX,3])
					Reclock("SC9",.F.)
					SC9->C9_PRCVEN := aAjuste[nX,5]
					SC9->(Msunlock())
				EndIf
			Next nX 
		EndIf
		
		RestArea(aAreaC5)
		
		MV_PAR01 := aParamU[1,1]
		MV_PAR02 := aParamU[1,2]
		MV_PAR03 := aParamU[1,3]
		MV_PAR04 := aParamU[1,4]
		MV_PAR05 := aParamU[1,5]
		
		cQuery := "SELECT C5_FILIAL,C5_NUM,C5_XFINAL,ZZC_FINAL,C5_XNOMUSR,C5_XDATINC,C5_XHRINC,C5_XCODPA,C5_CLIENTE,C5_LOJACLI,"
		cQuery += " (SELECT SUM(C6_VALOR) FROM "+RetSQLName("SC6")+" WHERE C6_FILIAL='"+MV_PAR02+"'
		cQuery += " 	AND C6_NUM='"+cNumPed+"' AND D_E_L_E_T_='') AS TOTAL"
		cQuery += "  FROM "+RetSQLName("SC5")+" C5"
		cQuery += "  INNER JOIN ZZC010 ZZC ON ZZC_CODIGO=C5_XFINAL AND ZZC.D_E_L_E_T_=''"
		cQuery += "  WHERE C5_FILIAL='"+MV_PAR02+"' AND C5_NUM='"+cNumPed+"'"
		cQuery += "  AND C5.D_E_L_E_T_=''"
		
		If Select('TRB') > 0
			dbSelectArea('TRB')
			dbCloseArea()
		EndIf       
		
		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
		dbSelectArea("TRB")
		
		Aadd(aEmail,{TRB->C5_FILIAL,TRB->C5_NUM,TRB->C5_XFINAL,TRB->ZZC_FINAL,TRB->C5_XNOMUSR,TRB->C5_XDATINC,TRB->C5_XHRINC,TRB->TOTAL,TRB->C5_XCODPA,TRB->C5_CLIENTE,TRB->C5_LOJACLI})
		aC6 := {}
		aC5 := {}  
		aAjuste := {}
		aAux := {}
		nContc6 := 0
	EndIf
	
Next nLinha

If len(aC6) > 0 .And. len(aC5) > 0
	Aadd(aParamU,{MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04,MV_PAR05})
	aAreaC5 := GetArea()
	
	MsExecAuto({|x, y, z| MATA410(x, y, z)}, aC5, aC6, 3)                    
	
	If len(aAjuste) > 0  
		DbSelectArea("SC6")
		DbSetOrder(1)    
		For nX := 1 to len(aAjuste)
			If DbSeek(aAjuste[nX,1]+aAjuste[nX,2]+aAjuste[nX,3]+aAjuste[nX,4])
				Reclock("SC6",.F.)
				SC6->C6_PRCVEN := aAjuste[nX,5]
				SC6->C6_VALOR  := aAjuste[nX,6]
				SC6->C6_PRUNIT := aAjuste[nX,7]
			EndIf
		Next nX
	EndIf
	RestArea(aAreaC5)
	
	MV_PAR01 := aParamU[1,1]
	MV_PAR02 := aParamU[1,2]
	MV_PAR03 := aParamU[1,3]
	MV_PAR04 := aParamU[1,4]
	MV_PAR05 := aParamU[1,5]

	cQuery := "SELECT C5_FILIAL,C5_NUM,C5_XFINAL,ZZC_FINAL,C5_XNOMUSR,C5_XDATINC,C5_XHRINC,C5_XCODPA,C5_CLIENTE,C5_LOJACLI,"
	cQuery += " (SELECT SUM(C6_VALOR) FROM "+RetSQLName("SC6")+" WHERE C6_FILIAL='"+MV_PAR02+"'
	cQuery += " 	AND C6_NUM='"+cNumPed+"' AND D_E_L_E_T_='') AS TOTAL"
	cQuery += "  FROM "+RetSQLName("SC5")+" C5"
	cQuery += "  INNER JOIN ZZC010 ZZC ON ZZC_CODIGO=C5_XFINAL AND ZZC.D_E_L_E_T_=''"
	cQuery += "  WHERE C5_FILIAL='"+MV_PAR02+"' AND C5_NUM='"+cNumPed+"'"
	cQuery += "  AND C5.D_E_L_E_T_=''"
	
	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf       
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
	dbSelectArea("TRB")
	
	Aadd(aEmail,{TRB->C5_FILIAL,TRB->C5_NUM,TRB->C5_XFINAL,TRB->ZZC_FINAL,TRB->C5_XNOMUSR,TRB->C5_XDATINC,TRB->C5_XHRINC,TRB->TOTAL,TRB->C5_XCODPA,TRB->C5_CLIENTE,TRB->C5_LOJACLI})
	aC6 := {}
	aC5 := {}

EndIf

RestArea(aArea)

Return     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTEDI110  บAutor  ณMicrosiga           บ Data ณ  03/21/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Validacao do arquivo CSV                                  บฑฑ
ฑฑบ          ณ O arquivo deve estar obrigatoriamente nesta ordem de camposบฑฑ
ฑฑบ          ณ Cod Cliente - Loja cliente - Produto - Qtd - Msg Nota -    บฑฑ
ฑฑบ          ณ Tabela de Preco - Cond Pagto - Forma Pagto                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function LerArquivo()

Local aAux	:=	{}           
Local nCont	:=	1 
Local aCabec:= {}                                                          
Local nHandle 	:= FT_FUse(MV_PAR01)       
Local lRet	:=	.T.

// Posiciona na primeria linha
FT_FGoTop()

If nHandle < 0
	MsgAlert("Arquivo nใo encontrado","TTEDI110")
	Return(.F.)
EndIf

While !FT_FEOF() 
	cLine	:= FT_FReadLn() // Retorna a linha corrente  
	aAux    := StrTokArr(cLine,";")                    
	If nCont > 1
		If len(aAux) <> 9 .AND. len(aAux) <> 11  //If len(aAux) <> 9 
			Msgalert("Registro invแlido na linha "+cvaltochar(nCont),"TTEDI110")
			Return(.F.)
		EndIf
		
		If Posicione("SA1",1,xFilial("SA1")+Strzero(val(aAux[01]),6)+Strzero(val(aAux[02]),4),"A1_NOME") == ""
			Msgalert("Cliente invแlido na linha "+cvaltochar(nCont),"TTEDI110")
			Return(.F.)
		ElseIf Posicione("SB1",1,xFilial("SB1")+aAux[03],"B1_DESC") == ""
			Msgalert("Produto invแlido na linha "+cvaltochar(nCont),"TTEDI110")
			Return(.F.)
		ElseIf val(aAux[04]) < 1
			Msgalert("Quantidade invแlida na linha "+cvaltochar(nCont),"TTEDI110")
			Return(.F.) 
		ElseIf Posicione("ZZ1",1,MV_PAR02+aAux[06],"ZZ1_DESCRI") == ""
			MsgAlert("PA invแlida na linha "+cvaltochar(nCont),"TTEDI110")
			Return(.F.) 
		ElseIf Posicione("DA0",1,xFilial("DA0")+aAux[07],"DA0_DESCRI") == ""
			MsgAlert("Tabela invแlida na linha "+cvaltochar(nCont),"TTEDI110")
			Return(.F.)
		ElseIf Posicione("SE4",1,xFilial("SE4")+aAux[08],"E4_DESCRI") == ""
			MsgAlert("Condi็ใo de pagamento invแlida na linha "+cvaltochar(nCont),"TTEDI110")
			Return(.F.)
		ElseIf !existcpo("SX5","Z8"+aAux[09])
			MsgAlert("Forma de Pagamento invแlida na linha "+cvaltochar(nCont),"TTEDI110")
			Return(.F.)
		EndIf
		
		// arquivo comum
		If Len(aAux) == 9		
			Aadd(aList,{Strzero(val(aAux[01]),6),Strzero(val(aAux[02]),4),aAux[03],aAux[04],aAux[05],aAux[06],aAux[07],aAux[08],aAux[09]})
		// arquivo ford - colunas de pedido de compra e item do pedido de compra
		ElseIf Len(aAux) == 11
			Aadd(aList,{Strzero(val(aAux[01]),6),Strzero(val(aAux[02]),4),aAux[03],aAux[04],aAux[05],aAux[06],aAux[07],aAux[08],aAux[09], aAux[10], aAux[11]})		
		EndIf		
	Else
		cTipTab := aAux[07]
	EndIf
	
	nCont++
	FT_FSKIP()
End

FT_FUSE()   

//Ordenando pela chave para geracao dos pedidos
//CODIGO CLIENTE + LOJA DO CLIENTE + PA DO CLIENTE + MENSAGEM PARA A NOTA
//Asort(aList,,,{|x,y| x[1]+x[2]+Alltrim(x[6])+x[4] < y[1]+y[2]+Alltrim(y[6])+y[4]})

Return(lRet)       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTEDI110  บAutor  ณMicrosiga           บ Data ณ  03/21/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Montando os cabecalhos dos pedidos a serem gerados.        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MontaCab(nLinha,nPed)

Local aArea	:=	GetArea() 
Local aCab2	:= {}  
Local lRet	:=	.T.      
Local cVend := Posicione("SA1",1,xFilial("SA1")+aList[nLinha,01]+aList[nLinha,02],"A1_VEND")

If Empty(cVend)
	cVend := '000073'
EndIf

Aadd(aCab2,{"C5_FILIAL"	,MV_PAR02				,Nil}) 
Aadd(aCab2,{"C5_NUM"    ,nPed					,Nil})	   //GETSXENUM("SC5","C5_NUM")
Aadd(aCab2,{"C5_TIPO"	,"N"					,Nil})   
Aadd(aCab2,{"C5_CLIENTE",aList[nLinha,01]		,Nil})
Aadd(aCab2,{"C5_LOJACLI",aList[nLinha,02]		,Nil})
Aadd(aCab2,{"C5_CLIENT"	,aList[nLinha,01]		,Nil})
Aadd(aCab2,{"C5_LOJAENT",aList[nLinha,02]		,Nil})
Aadd(aCab2,{"C5_XDTENTR",DDATABASE+10 			,Nil}) 
Aadd(aCab2,{"C5_XNFABAS","2"					,Nil})   
Aadd(aCab2,{"C5_XCODPA"	,aList[nLinha,06]		,Nil})
Aadd(aCab2,{"C5_XFINAL"	,MV_PAR03				,Nil})   							
Aadd(aCab2,{"C5_TRANSP"	,"000019"				,Nil})          
Aadd(aCab2,{"C5_XTPCARG","1"					,Nil})         
Aadd(aCab2,{"C5_XHRPREV","00:00"				,Nil})         
Aadd(aCab2,{"C5_CONDPAG",aList[nLinha,08]		,Nil})                                 //Posicione("SA1",1,xFilial("SA1")+aList[nLinha,01]+aList[nLinha,02],"A1_COND")
Aadd(aCab2,{"C5_TABELA"	,cTab					,Nil})
Aadd(aCab2,{"C5_XCCUSTO",MV_PAR05				,Nil})                             //Posicione("ZZ1",1,MV_PAR02+aList[nLinha,06],"ZZ1_CCUSTO")
Aadd(aCab2,{"C5_XITEMCC",If(MV_PAR03=="8",'0000010001SERVLOC',Posicione("ZZ1",1,MV_PAR02+aList[nLinha,06],"ZZ1_ITCONT")),Nil})       
Aadd(aCab2,{"C5_MOEDA"	,1						,Nil})         
Aadd(aCab2,{"C5_FRETE"	,0						,Nil})         
Aadd(aCab2,{"C5_TXMOEDA",0						,Nil})        
Aadd(aCab2,{"C5_EMISSAO",DDATABASE				,Nil})      
Aadd(aCab2,{"C5_XGPV"	,"PRO-A"				,Nil})        
Aadd(aCab2,{"C5_MENNOTA",aList[nLinha,05]		,Nil})      
Aadd(aCab2,{"C5_ESPECI1",'UN'	 		  		,Nil})        
Aadd(aCab2,{"C5_XHRINC" ,cvaltochar(TIME())	,Nil})     
Aadd(aCab2,{"C5_XDATINC",DATE()					,Nil})     
Aadd(aCab2,{"C5_XNOMUSR",cUserName 				,Nil}) 
Aadd(aCab2,{"C5_XCODUSR",__cUserId 		   		,Nil})
Aadd(aCab2,{"C5_XDESCLI",Posicione("SA1",1,xFilial("SA1")+aList[nLinha,01]+aList[nLinha,02],"A1_NOME"),Nil})  
Aadd(aCab2,{"C5_TPFRETE","C"					,Nil})
Aadd(aCab2,{"C5_TIPOCLI",Posicione("SA1",1,xFilial("SA1")+aList[nLinha,01]+aList[nLinha,02],"A1_TIPO"),Nil})
Aadd(aCab2,{"C5_TIPLIB" ,"1"				  	,Nil})                    
Aadd(aCab2,{"C5_VEND1"  ,cVend					,Nil})                    
Aadd(aCab2,{"C5_XTPPAG" ,aList[nLinha,09]		,Nil})                    	
Aadd(aCab2,{"C5_XMESREF",MV_PAR04				,Nil})  

Aadd(aCabec,aCab2)
			
RestArea(aArea)

Return(lRet) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTEDI100  บAutor  ณMicrosiga           บ Data ณ  11/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Montando os itens dos pedidos a serem gerados.            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MontaItem(nLinha,nPed)

Local aArea	:=	GetArea()
Local cOpera:=	''
Local cTes	:=	space(3)
Local nCsv	:=	0       
Local nPrc	:= 	If(Alltrim(Upper(cTipTab))=="TABELA",Posicione("DA1",1,xFilial("DA1")+cTab+aList[nLinha,03],"DA1_PRCVEN"),val(strtran(aList[nLinha,07],",","."))) 
Local lRet	:=	.T.
Local lTesBLQ := .F.
Local lTesOK := .F.            

                                                        
If nPrc <= 0
	MsgAlert("O Produto "+aList[nLinha,03]+" nใo foi encontrado na tabela de pre็o "+cTab+" linha "+cvaltochar(nLinha),"TTEDI110")
	Return(.F.)
EndIf

cTpCli  := Posicione("SA1",1,xFilial("SA1")+aList[nLinha,01]+aList[nLinha,02],"A1_TIPO")
cxFinal := MV_PAR03
cEPP    := Posicione("SA1",1,xFilial("SA1") + aList[nLinha,01]+aList[nLinha,02]," A1_XEPP")   

cOpera  := U_TTOPERA('PRO-A',cTpCli,cxFinal,cEPP)  

If Empty(cOpera)
	cOpera := '21'
EndIf

If !Empty(cOpera)
	//Buscando a TES a ser informada no item do pv.
	aAreaF4 := GetArea()
	cQueryX := "SELECT FM_TS,F4_CF"
	cQueryX += " FROM "+RetSQLName("SFM")+" FM"
	cQueryX += "	INNER JOIN "+RetSQLName("SF4")+" F4 ON F4_FILIAL=FM_FILIAL AND F4_CODIGO=FM_TS AND F4.D_E_L_E_T_=''"
	cQueryX += " WHERE FM_TIPO='"+cOpera+"' AND FM_FILIAL='"+MV_PAR02+"' AND FM_GRPROD='"+Posicione("SB1",1,xFilial("SB1")+aList[nLinha,03],"B1_GRTRIB")+"' AND FM.D_E_L_E_T_=''"
	cQueryX += " AND FM_EST='"+Posicione("SA1",1,xFilial("SA1")+aList[nLinha,01]+aList[nLinha,02],"A1_EST")+"'"

	If Select('TRB2') > 0
		dbSelectArea('TRB2')
		dbCloseArea()
	EndIf       
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQueryX),"TRB2",.F.,.T.)
	dbSelectArea("TRB2")
	cTes := If(Empty(TRB2->FM_TS),space(3),TRB2->FM_TS) 

	RestArea(aAreaF4)
EndIf                                         

If Empty(cTes) 
	MsgAlert("Nใo foi encontrada nenhuma TES que atenda ao produto "+aList[nLinha,03]+" "+Posicione("SB1",1,xFilial("SB1")+aList[nLinha,03],"B1_DESC"),"TTEDI110")
	While Empty(cTes)
		cTes := TesInf()
	End	
EndIf

// Verifica se TES esta bloqueada
While !lTesOK 
	dbSelectArea("SF4")
	dbSetOrder(1)
	dbSeek( xFilial("SF4") +AvKey(cTes,"F4_CODIGO") ) 
	If AllTrim(SF4->F4_MSBLQL) == "2"
		lTesOK := .T.
		Exit
	EndIf	         

	MsgAlert("A Tes " +cTes  +" estแ bloqueada." +CRLF +"Escolha outra que esteja desbloqueada na tela a seguir.","TTEDI110")
	cTes := TesInf()
End	



If Posicione("SB1",1,xFilial("SB1")+aList[nLinha,03],"B1_TIPCONV") =="M"
	nCsv := val(aList[nLinha,04]) * Posicione("SB1",1,xFilial("SB1")+aList[nLinha,03],"B1_CONV")
Else
	nCsv := val(aList[nLinha,04]) / Posicione("SB1",1,xFilial("SB1")+aList[nLinha,03],"B1_CONV")
EndIf

If Posicione("SB1",1,xFilial("SB1")+aList[nLinha,03],"B1_MSBLQL") == "1"
	MSGALERT("BLOQUEADO " + aList[nLinha,03])
EndIF

If nPrc <= 0 .or. Empty(cTes)
	Msgalet("em branco pre็o "+cvaltochar(nPrc)+" Tes "+cTes)
EndIf

Aadd(aItens,{{"C6_FILIAL"	,MV_PAR02				,Nil},;
				{"C6_NUM"	,nPed					,Nil},; //GETSXENUM()
				{"C6_ITEM"	,''						,Nil},; //CONTADOR
				{"C6_PRODUTO",aList[nLinha,03]		,Nil},;
				{"C6_XPRDORI",aList[nLinha,03]		,Nil},;
				{"C6_QTDVEN",val(aList[nLinha,04])	,Nil},;
				{"C6_XQTDORI",val(aList[nLinha,04])	,Nil},;
				{"C6_TPOP"	,"F" 					,Nil},;
				{"C6_UNSVEN",nCsv 					,Nil},;
				{"C6_PRCVEN",nPrc					,Nil},; 
				{"C6_VALOR"	,nPrc*val(aList[nLinha,04]),Nil},; 
				{"C6_PRUNIT",nPrc					,Nil},;
				{"C6_TES"	,cTes 			   		,Nil},;
				{"C6_VALDESC",0						,Nil},;
				{"C6_CLI"	,aList[nLinha,01]		,Nil},;
				{"C6_LOJA"	,aList[nLinha,02]		,Nil},;
				{"C6_LOCAL"	,aList[nLinha,06]		,Nil},;  		
				{"C6_CCUSTO",MV_PAR05				,Nil},;              //Posicione("ZZ1",1,MV_PAR02+aList[nLinha,06],"ZZ1_CCUSTO")
				{"C6_ITEMCC",IF(MV_PAR03=="8",'0000010001SERVLOC',Posicione("ZZ1",1,MV_PAR02+aList[nLinha,06],"ZZ1_ITCONT"))			,Nil},;
				{"C6_XGPV"	,'PRO-A'				,Nil},;
				{"C6_ENTREG",DDATABASE+10			,Nil},;
				{"C6_XDTEORI",DDATABASE+10			,Nil},;
				{"C6_UM"	,Posicione("SB1",1,xFilial("SB1")+aList[nLinha,03],"B1_UM") 		,Nil},;
				{"C6_SEGUM"	,Posicione("SB1",1,xFilial("SB1")+aList[nLinha,03],"B1_SEGUM") 	,Nil},;
				{"C6_XHRINC" ,TIME() 				,Nil},;
				{"C6_XDATINC",DATE()		 		,Nil},;
				{"C6_XUSRINC",cUsername 	 		,Nil}})

// arquivo com colunas de pedido de compra e item do pedido de compra
If Len(aList[nLinha]) == 11
	AADD( aItens[Len(aItens)], 	{"C6_NUMPCOM"		,aList[nLinha,10]  		,Nil} )
	AADD( aItens[Len(aItens)], 	{"C6_ITEMPC"	,aList[nLinha,11] 		,Nil} )
EndIf
				
RestArea(aArea)

Return(lRet)                                                       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTEDI110  บAutor  ณMicrosiga           บ Data ณ  03/25/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Geracao do PDF para os pedidos de vendas gerados pela      บฑฑ
ฑฑบ          ณimportacao                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GeraPDF()

Local aArquivos := {}
Local cMsg		:= "Pedidos Gerados"
Local lAdjustToLegacy := .F. 
Local lDisableSetup  := .T.
Local cLogoD	:= GetSrvProfString("Startpath","") + "DANFE01.BMP" 
Local nTotal	:= 0
Private oPrinter      


oFont1 := TFont():New( "Courier New", , -18, .T.)

If oPrinter == Nil
	lPreview := .T.
	oPrinter := FWMSPrinter():New("Pedido.rel", 6, lAdjustToLegacy, , lDisableSetup)

	// Ordem obrigแtoria de configura็ใo do relat๓rio
	oPrinter:SetResolution(72)
	oPrinter:SetPortrait()
	oPrinter:SetPaperSize(DMPAPER_A4)
	oPrinter:SetMargin(60,60,60,60) 
	// nEsquerda, nSuperior, nDireita, nInferior 
	oPrinter:cPathPDF := "\SPOOL\" 
EndIf       

oPrinter:Box(10,10,510,850)
oPrinter:Say( 30, 250, "Pedidos Faturados", oFont1, 1400, CLR_HRED)
oPrinter:SayBitmap(015,015,cLogoD,055,056)

oPrinter:Say(090, 15,'FL',oFont1)
oPrinter:Say(090, 30,'PEDIDO',oFont1)
oPrinter:Say(090, 70,'CLIENTE',oFont1)
oPrinter:Say(090, 180,'FINALIDADE',oFont1)
oPrinter:Say(090, 350,'USUARIO',oFont1)
oPrinter:Say(090, 410,'DATA',oFont1)
oPrinter:Say(090, 460,'HORA',oFont1)
oPrinter:Say(090, 510,'VALOR PEDIDO',oFont1)

oPrinter:Say(100, 15, Replicate("-", 500), oFont1)

nLin := 110             

//		1				2			3				4				5				6			7				8			9				10				11			
//TRB->C5_FILIAL,TRB->C5_NUM,TRB->C5_XFINAL,TRB->ZZC_FINAL,TRB->C5_XNOMUSR,TRB->C5_XDATINC,TRB->C5_XHRINC,TRB->TOTAL,TRB->C5_XCODPA,TRB->C5_CLIENTE,TRB->C5_LOJACLI
For nX := 1 to len(aEmail)
   	oPrinter:Say(nLin, 15,aEmail[nX,01],oFont1)
   	oPrinter:Say(nLin, 30,aEmail[nX,02],oFont1)
   	oPrinter:Say(nLin, 70,Alltrim(Posicione("SA1",1,xFilial("SA1")+aEmail[nX,10]+aEmail[nX,11],"A1_NREDUZ")),oFont1)
   	oPrinter:Say(nLin, 180,aEmail[nX,03],oFont1)
   	oPrinter:Say(nLin, 190,Alltrim(aEmail[nX,04]),oFont1)
   	oPrinter:Say(nLin, 350,aEmail[nX,05],oFont1)
   	oPrinter:Say(nLin, 410,cvaltochar(stod(aEmail[nX,06])),oFont1)
   	oPrinter:Say(nLin, 460,aEmail[nX,07],oFont1)
   	oPrinter:Say(nLin, 510,Transform(aEmail[nX,08],"@E 999,999,999.99"),oFont1)
   	nTotal += aEmail[nX,08]
	nLin := nLin + 10
Next nX
                           
nLin := nLin + 20

oPrinter:Say(nLin, 15, Replicate("-", 500), oFont1)
nLin := nLin + 10
oPrinter:Say(nLin, 15,'TOTAL',oFont1)
oPrinter:Say(nLin, 510,Transform(nTotal,"@E 999,999,999.99"),oFont1)
       
oPrinter:EndPage()

oPrinter:Preview()

//Fui obrigado a chamar desta forma pois esta apresentando um erro que nao mostra na tela e congela a rotina.
u_TTEDIPDF(aEmail[01,01],aEmail[01,02],aEmail[len(aEmail),02])
Aadd(aArquivos,{"\spool\TTEDI110.XML",'Content-ID: <ID_pedidox.xml>'}) 
Aadd(aArquivos,{"\spool\Pedido.pdf",'Content-ID: <ID_pedido.pdf>'}) 

U_TTMAILN('microsiga@toktake.com.br',Alltrim(cusername)+'@toktake.com.br','Importador de Pedidos',cMsg,aArquivos,.F.)


FreeObj(oPrinter)  

oPrinter := Nil	
  

Return                                            

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTEDI110  บAutor  ณMicrosiga           บ Data ณ  03/27/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Permite reimprimir o pdf dos pedidos gerados pela importac.บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTEDIPDF(cF,cPed1,cPed2)
         
Local cQuery
Private aEmail	:=	{}

cQuery := "SELECT C5_FILIAL,C5_NUM,C5_XFINAL,ZZC_FINAL,C5_XNOMUSR,C5_XDATINC,C5_XHRINC,C5_XCODPA,C5_CLIENTE,C5_LOJACLI"
cQuery += "  FROM "+RetSQLName("SC5")+" C5"
cQuery += "  INNER JOIN ZZC010 ZZC ON ZZC_CODIGO=C5_XFINAL AND ZZC.D_E_L_E_T_=''"
cQuery += "  WHERE C5_FILIAL='"+cF+"' AND C5_NUM BETWEEN '"+cPed1+"' AND '"+cPed2+"'"
cQuery += "  AND C5.D_E_L_E_T_=''"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf       

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
dbSelectArea("TRB")

While !EOF()
	Aadd(aEmail,{TRB->C5_FILIAL,TRB->C5_NUM,TRB->C5_XFINAL,TRB->ZZC_FINAL,TRB->C5_XNOMUSR,TRB->C5_XDATINC,TRB->C5_XHRINC,0,TRB->C5_XCODPA,TRB->C5_CLIENTE,TRB->C5_LOJACLI})
	Dbskip()
EndDo

cQuery := " SELECT C6_FILIAL,C6_NUM,SUM(C6_VALOR) AS TOTAL FROM "+RetSQLName("SC6")+" WHERE C6_FILIAL='"+cF+"'
cQuery += " 	AND C6_NUM BETWEEN '"+cPed1+"' AND '"+cPed2+"' AND D_E_L_E_T_=''"
cQuery += " GROUP BY C6_FILIAL,C6_NUM"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf       

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
dbSelectArea("TRB")
     
While !EOF()
    aEmail[Ascan(aEmail,{|x| x[1]+x[2] == TRB->C6_FILIAL+TRB->C6_NUM}),08] := TRB->TOTAL
	Dbskip()
EndDo

//GeraPDF()
GeraExc()

Return                                        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTEDI110  บAutor  ณMicrosiga           บ Data ณ  03/27/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GeraExc()

Local oReport

oReport := ReportDef()
oReport:PrintDialog()

Return
	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO13    บAutor  ณMicrosiga           บ Data ณ  03/27/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ReportDef()

	Local oReport
	Local oSection
	Local clDesc	:="Este relat๓rio exibe os titulos com canhotos baixados que ainda nใo foram enviados ao banco"
	Local clTitulo	:="Pedidos_Importados"
	Local clProg	:="TTEDI110"
	Private cPerg	:="TTEDI110"
	//ValPerg(cPerg)
	//Pergunte(cPerg,.T.)
	oReport := TReport():New(clProg,clTitulo,'',{|oReport| PrintReport(oReport)},clDesc)
	
	oSection1 := TRSection():New(oReport,OemToAnsi("Importador"),{"TRB"})
	
	/*-------------------------------------------------------------------------------| 		    			           
	|						campo        alias  titulo            pic   		tam  |	  
	|-------------------------------------------------------------------------------*/
	                                                                    	
	TRCell():New(oSection1,"FILIAL"		,"TRB","FILIAL"		,"@!"	,02)	
	TRCell():New(oSection1,"PEDIDO"		,"TRB","PEDIDO"		,"@!"	,06)	
	TRCell():New(oSection1,"CLIENTE"	,"TRB","CLIENTE"	,"@!"	,50)
	TRCell():New(oSection1,"COD_FIN"	,"TRB","COD_FIN"	,"@!"	,01)	
	TRCell():New(oSection1,"FINALID"	,"TRB","FINALID"	,"@!"	,25)		
	TRCell():New(oSection1,"USUARIO"	,"TRB","USUARIO"	,"@!"	,15)	
	TRCell():New(oSection1,"DAT_GER"	,"TRB","DAT_GER"	,		,08)	
	TRCell():New(oSection1,"HORA"		,"TRB","HORA"		,"@!"	,05)	
	TRCell():New(oSection1,"COD_PA"		,"TRB","COD_PA"		,"@!"	,06)	
	TRCell():New(oSection1,"DESC_PA"	,"TRB","DESC_PA"	,"@!"	,25)	
	TRCell():New(oSection1,"VLR_PED"	,"TRB","VLR_PED"	,"@E 999,999,999.99"	,15)

Return oReport	                                                                       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO13    บAutor  ณMicrosiga           บ Data ณ  03/27/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PrintReport(oReport)

	Local oSection1 := oReport:Section(1)
	
	/*----------------------------------------------------------------------------| 		    			           
	|sele็ao dos dados a serem impressos/carrega o arquivo temporario de trabalho | 
	|----------------------------------------------------------------------------*/
	
	MsAguarde({|| fSelDados()},"Selecionando Itens")
	
	/*-----------------------------|
	| impressao da primeira se็ao  | 
	|-----------------------------*/
	
	DbSelectArea("TRB")
	DbGoTop()
	oReport:SetMeter(RecCount())
	oSection1:Init()         
	While  !Eof()
		If oReport:Cancel()
			Exit
		EndIf
		oSection1:PrintLine()
		DbSelectArea("TRB")
		DbSkip()            
		oReport:IncMeter()
	EndDo
	oSection1:Finish()		
	If Sele("TRB") <> 0
		TRB->(DbCloseArea())
	Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINR08  บAutor  ณMicrosiga           บ Data ณ  12/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fSelDados()
	
	/*------------------------------| 		    			           
	|criacao do arquivo de trabalho | 
	|------------------------------*/
	
	Private _aStru	:= {} 

	AADD(_aStru,{"FILIAL"	,"C",02,0})
	AADD(_aStru,{"PEDIDO"	,"C",06,0})
	AADD(_aStru,{"CLIENTE"	,"C",50,0})
	AADD(_aStru,{"COD_FIN"	,"C",01,0})
	AADD(_aStru,{"FINALID"	,"C",25,0})
	AADD(_aStru,{"USUARIO"	,"C",15,0})
	AADD(_aStru,{"DAT_GER"	,"D",08,0})
	AADD(_aStru,{"HORA"		,"C",05,0})
	AADD(_aStru,{"COD_PA"	,"C",06,0})
	AADD(_aStru,{"DESC_PA"	,"C",25,0})
	AADD(_aStru,{"VLR_PED" 	,"N",15,2})
	
	_cArq     := CriaTrab(_aStru,.T.)
	_cIndice  := CriaTrab(Nil,.F.)
	
	If Select("TRB") <> 0
		TRB->(DbCloseArea())
	Endif 
	
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)
	DbSelectArea("TRB")
		
	/*----------------------------|
	|alimenta a tabela temporแria |
	|----------------------------*/
	For nX := 1 to len(aEmail)
		
		RecLock("TRB",.T.) 
//		1				2			3				4				5				6			7				8			9				10				11			
//TRB->C5_FILIAL,TRB->C5_NUM,TRB->C5_XFINAL,TRB->ZZC_FINAL,TRB->C5_XNOMUSR,TRB->C5_XDATINC,TRB->C5_XHRINC,TRB->TOTAL,TRB->C5_XCODPA,TRB->C5_CLIENTE,TRB->C5_LOJACLI

		TRB->FILIAL 	:= aEmail[nX,01]
		TRB->PEDIDO		:= aEmail[nX,02]									
		TRB->CLIENTE	:= Posicione("SA1",1,xFilial("SA1")+aEmail[nX,10]+aEmail[nX,11],"A1_NREDUZ")
		TRB->COD_FIN	:= aEmail[nX,03]
		TRB->FINALID 	:= aEmail[nX,04]
		TRB->USUARIO 	:= aEmail[nX,05]
		TRB->DAT_GER 	:= STOD(aEmail[nX,06])
		TRB->HORA	 	:= aEmail[nX,07]
		TRB->COD_PA		:= aEmail[nX,09]
		TRB->DESC_PA 	:= Posicione("ZZ1",1,xFilial("ZZ1")+aEmail[nX,09],"ZZ1_DESCRI")
		TRB->VLR_PED	:= aEmail[nX,08]
					
		MsUnlock()	
	Next nX
Return	

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTEDI110  บAutor  ณMicrosiga           บ Data ณ  04/25/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TesInf()

Local cTes	:=	space(3)

Local oDlg1,oSay1,oGet1,oBtn1

oDlg1      := MSDialog():New( 091,232,226,498,"Entrada manual de TES",,,.F.,,,,,,.T.,,,.T. )
oSay1      := TSay():New( 016,008,{||"Informe a TES"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oGet1      := TGet():New( 016,056,{|u| If(PCount()>0,cTes:=u,cTes)},oDlg1,060,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SF4","",,)
oBtn1      := TButton():New( 036,044,"Confirmar",oDlg1,{||oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.) 

Return(cTes)