#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFATC90  บAutor  ณJackson E. de Deusบ   Data ณ  15/12/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ajuste de estoque - INVENTARIO				              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTFATC90()

Local aPergs := {}
Local aRet := {} 
Local cArmazem := ""
Local cArmA := "" 
Local cOSMobile := ""
Local nTpOper := 0

If cEmpAnt <> "01"
	Return
EndIf

/*
Tipos de inventario
Inventario ROTA
	- Armazem R -> SB2
		- zerar
		- considerar saldo do armazem movel - SZ7 ( equaliza )
	- Armazem Movel -> SZ7
	- Armazem R - SZ6
	
Inventario PA
	- Armazem A -> SZ6
		- zerar
		- considerar saldo contado OS mobile
	- Armazem P - SB2
*/

aAdd(aPergs ,{1,"Rota/PA"	,space(TamSx3("ZZ1_COD")[1]),"@!",".T.","ZZ1",".T.",60,.F.})
aAdd(aPergs ,{3,"Op็ใo"		,1,{"Zerar","Usa SZ7","Usa OS Invent"},50,"",.F.})
aAdd(aPergs ,{1,"OS "		,space(TamSx3("ZG_NUMOS")[1]),"@!",".T.","",".T.",60,.F.})


If ParamBox(aPergs ,"Inventario",@aRet)
	cArmazem := aRet[1]

	If Empty(cArmazem)
		MsgAlert("Informe um armazem vแlido!")
		Return
	EndIf   

	If aRet[2] == 1
		nTpOper := 1
	ElseIf aRet[2] == 2
		nTpOper := 2
	ElseIf aRet[2] == 3
		nTpOper := 3
		cOSMobile := aRet[3]
		If Empty(cOSMobile)
			MsgAlert("Informe a OS de inventario!")
			Return
		EndIf
	EndIf                            
EndIf

If nTpOper <> 0 
	CursorWait()
	MsAguarde( { || ExecF(nTpOper,cArmazem, cOSMobile) }, "Aguarde." )
	CursorArrow()
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExecF  บAutor  ณJackson E. de Deus     บ Data ณ  15/12/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Executa o inventario                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ExecF(nTpOper, cArmazem,cOSMobile)

Local aDadosWS := {}
Local cMsgErro := "" 
Local axItens := {}
Local aItens := {}
Local aItensDs := {}
Local nI, nJ
Local cArmaA := ""

// zerar o saldo         
If nTpOper == 1
	//STATICCALL( TTPROC57, Invent, cArmazem )
	
// equaliza com SZ7
ElseIf nTpOper == 2
	//STATICCALL( TTPROC57, Invent, cArmazem )
	//STATICCALL( TTPROC57, Invent2, cArmazem )
	
// equaliza com OS de inventario
ElseIf nTpOper == 3
	dbSelectArea("SZG")
	dbSetOrder(1)
	If msSeek( xFilial("SZG") +AvKey(cOSMobile,"ZG_NUMOS") )
		If alltrim(SZG->ZG_FORM) == "21"
			aDadosWS := U_MXML000(SZG->ZG_RESPOST)
			For nI := 1 To Len(aDadosWS)          
				If aDadosWS[nI][1] == "INVENTARIO"
					For nJ := 2 To Len(aDadosWS[nI])
						AADD( axItens, ACLONE(aDadosWS[nI][nJ]) )
					Next nJ
				EndIf	
			Next nI
			For nI := 1 To Len(axItens)	// verificar
				AADD( aItens, { axitens[nI][1][2], Val(axItens[nI][2][2]) } )
				AADD( aItensDs, { axitens[nI][1][2], Val(axItens[nI][3][2]) } )
			Next nI
				
			If !Empty(aItens)
				
				If SubStr( cArmazem,1,1 ) == "P"
					cArmaA := "A"+SubStr( cArmazem,2 )
					
					GravaZC( cArmaA,SZG->ZG_DATAFIM,aItens,aItensDs,SZG->ZG_NUMOS )
								
					If !Empty(cArmaA)
						AjustaSZ6( cArmaA,aItens )
					EndIf
				EndIf
				
				If AllTrim(SZG->ZG_NUMOS) == SZG->ZG_NUMOS
					RecLock("SZG",.F.)
					SZG->ZG_PROC := "BR_VERDE"
					MsUnLock()
				EndIf				
			EndIf
		EndIf	                                
	EndIf
EndIf

Return


Static Function GravaZC( cArmazem,dDia,aItens,aItensDs,cOsMobile )

Local nI
Local cDoc := ""


cDoc := NextNumZC()

dbSelectArea("SZC")
dbSetOrder(2) // filial local produto data

For nI := 1 To Len( aItens )
	If !MsSeek( xFilial("SZC") +AvKey(cArmazem,"ZC_LOCAL") +AvKey(aItens[nI][1],"ZC_COD") +AvKey(dtos(dDia),"ZC_DATA") )
		RecLock("SZC",.T.)
		SZC->ZC_FILIAL := xFilial("SZC")
		SZC->ZC_INVENT := cDoc
		SZC->ZC_DATA := dDia
		SZC->ZC_LOCAL := cArmazem
		SZC->ZC_COD := aItens[nI][1]
		SZC->ZC_QTD := aItens[nI][2]
		SZC->ZC_TIPO := "1"
		SZC->ZC_NUMOS := cOsMobile
		MsUnLock()
	EndIf
Next nI


Return


Static Function NextNumZC()

Local aArea := GetArea()
Local cDoc := ""
Local cQuery := ""

cQuery := "SELECT MAX(ZC_INVENT) DOC FROM " +RetSqlName("SZC")

If Select("TRBZ") > 0
	TRBZ->( dbCloseArea() )
EndIf
                        
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBZ",.F.,.T.)  

dbSelectArea("TRBZ")

If !Empty(TRBZ->DOC)
	cDoc := SOMA1(TRBZ->DOC)
Else
	cDoc := PadL("1",TamSx3("ZC_INVENT")[1],"0")	
EndIf

TRBZ->(dbCloseArea())

RestArea(aArea)

Return cDoc


Static Function AjustaSZ6(cArmazem,aItens)


Local cQuery := ""
Local aInvent := {}
Local nI
Local cTm := ""
Local nPos := 0
Local nContado := 0
Local nQtdMov := 0
Local nQtdZ6 := 0

cQuery := "SELECT * FROM " +RetSqlName("SZ6")
cQuery += " WHERE Z6_FILIAL = '"+xFilial("SZ6")+"' "
cQuery += " AND Z6_LOCAL = '"+cArmazem+"'  "
cQuery += " AND D_E_L_E_T_ = '' "

If Select("TRB2") > 0
	TRB2->(dbCloseArea())
EndIf
	
MpSysOpenQuery( cQuery,"TRB2" )  
dbSelectArea("TRB2")
While TRB2->(!EOF())	
	AADD( aInvent, { TRB2->Z6_COD, TRB2->Z6_QATU } )	
	TRB2->(dbSkip())
End                                          

TRB2->(dbCloseArea())

For nI := 1 To Len(aItens)
	nPos := AScan( aInvent, { |x| alltrim(x[1]) == alltrim(aItens[nI][1]) } )
	nContado := aItens[nI][2]
	nQtdMov := 0
	If nPos > 0
		nQtdZ6 := aInvent[nPos][2]
	EndIf
	
	// sz6 zero e contagem zero - pula
	If nQtdZ6 == 0 .And. nContado == 0
		Loop
	EndIf
	
	// sz6 igual contagem - pula
	If nQtdZ6 == nContado
		Loop
	EndIf
	
	// sz6 negativa mas contagem maior ou igual a zero - sobe saldo
	If nQtdZ6 < 0 .And. nContado == 0 
		cTm := "015"
		nQtdMov := ABS(nQtdZ6)
	EndIf
	
	If nContado > 0
		cTm := "015"
		nQtdMov := nContado
	EndIf
	
	// sz6 positiva mas contagem eh zero - desce saldo
	If nQtdZ6 > 0 .And. nContado == 0
		cTm := "515"
		nQtdMov := nQtdZ6
	EndIf
	
	If nQtdZ6 > nContado
		cTm := "515"
		nQtdMov := nQtdZ6 - nContado
	EndIf
	

	U_MntSZ5(cArmazem,aItens[nI][1],cTm,dDatabase,nQtdMov,"","","AJUSTE ESTOQUE","TTFATC90","","") 
	
Next nI


Return
