#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROG02  บAutor  ณMicrosiga           บ Data ณ  06/25/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Busca o ultimo contador para o patrimonio.                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTPROG02(cPat,dDtNumAnt)

Local aArea	:=	GetArea()
Local cRet	:=	space(6)
Local cQuery 
Local oDlg1,oSay1,oGet1,oBtn1
Local lOk	:=	.F.                
Local nCont	:=	0
Local lAchou	:=	.F.
                        
If cEmpAnt <> "01"
	return
EndIF

While !empty(procname(nCont))
	If alltrim(UPPER(procname(nCont))) $ "U_TTPROC15|U_TTPROC17|U_TTTMKA04|U_TTPROC30|U_TTPROC25|U_MXML001|U_MXML004"
		lAchou := .T.
		Exit
	EndIf 
	nCont++
EndDo                                                
    /*
	cQuery := "SELECT TOP 1 ZN_PATRIMO,ZN_NUMATU AS CONT"
	cQuery += "	FROM "+RetSQLName("SZN")
	cQuery += "	WHERE D_E_L_E_T_='' AND ZN_PATRIMO='"+cPat+"' " //AND ZN_TIPINCL<>'SANGRIA'"
	cQuery += " ORDER BY ZN_DATA DESC, ZN_HORA DESC"
	*/
	cQuery := "SELECT TOP 5 ZN_PATRIMO,ZN_NUMATU AS CONT, ZN_TRPLACA, ZN_DATA "
	cQuery += "	FROM "+RetSQLName("SZN")
	cQuery += "	WHERE D_E_L_E_T_='' AND ZN_PATRIMO='"+cPat+"' " //AND ZN_TIPINCL<>'SANGRIA'"
	cQuery += " ORDER BY ZN_DATA DESC, ZN_HORA DESC, ZN_NUMATU DESC"
	                    	
	If Select("TRB") > 0
		dbSelectArea("TRB")
		dbCloseArea()
	EndIf
	  
	MemoWrite("TTPROC14.SQL",cQuery)
	
	cQuery:= ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
	
	DbSelectArea("TRB")
	If Empty(TRB->ZN_TRPLACA)
		cRet := TRB->CONT
		dDtNumAnt := STOD(TRB->ZN_DATA)
	Else 
		If AllTrim(TRB->ZN_TRPLACA) == "1"	// placa antiga?
			While !EOF()
				If AllTrim(TRB->ZN_TRPLACA) == "2" .Or. Empty(TRB->ZN_TRPLACA)	// placa nova ou sem reg de troca
					cRet := TRB->CONT
					dDtNumAnt := STOD(TRB->ZN_DATA)
					Exit
				EndIf	
				dbSkip()    
			End			
		EndIf	
	EndIf 
	/*	
	If !Empty(TRB->CONT)
		cRet	:=	TRB->CONT 
	Else 
	*/
	If Empty(cRet)    
		If !lAchou
			MsgAlert("Nใo foi encontrado o numerador anterior para este Patrim๔nio","TTPROC14 - NumAnt")
		    While !lOk
				oDlg1      := MSDialog():New( 091,232,258,528,"Numerador de Maquinas",,,.F.,,,,,,.T.,,,.T. )
				oSay       := TSay():New( 018,008,{||"Patrim๔nio: "+cPat},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,008)
				oSay1      := TSay():New( 028,008,{||"Informe o Numerador Anterior"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,008)
				oGet1      := TGet():New( 028,084,{|u| If(Pcount()>0,cRet:=u,cRet)},oDlg1,044,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
				oBtn1      := TButton():New( 052,048,"OK",oDlg1,{||oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )
				
				oDlg1:Activate(,,,.T.) 
				
				If !empty(cRet)
					lOk := .T.
					cRet	:=	val(cRet)
				EndIf
			Enddo
		Else
			cRet := 0	
		EndIF
	EndIf
	
RestArea(aArea)

Return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROCG02 บAutor  ณMicrosiga           บ Data ณ  08/15/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function TTPROG03()

Local aArea	:=	GetArea()
Local cRet	:=	''
Local nCont	:=	0
Local lAchou	:=	.F.
                                  
While !empty(procname(nCont))
	If alltrim(UPPER(procname(nCont))) $ "U_TTPROC15"
		lAchou := .T.
		Exit
	EndIf 
	nCont++
EndDo                                                
                  
If lAchou
	cRet	:=	"SANGRIA"
EndIf

RestArea(aArea)

Return(cRet)
