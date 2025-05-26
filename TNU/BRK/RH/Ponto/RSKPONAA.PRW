#Include "Protheus.ch"
#Include "TbiConn.Ch"
#Include "Colors.Ch"
#Include "TopConn.Ch"


// Opções do MessageBox
  #define MB_OK                       0
  #define MB_OKCANCEL                 1
  #define MB_YESNO                    4
  #define MB_ICONHAND                 16
  #define MB_ICONQUESTION             32
  #define MB_ICONEXCLAMATION          48
  #define MB_ICONASTERISK             64
  
  // Retornos possíveis do MessageBox
  #define IDOK			    1
  #define IDCANCEL		    2
  #define IDYES			    6
  #define IDNO			    7

User Function RSKREMO1(lBat)
// rogerio cfilremota guarda a filial do equipamento
//User Function RSKREMO1(lBat)

Local oSenha                    
Local aMeses   		:= { "JAN","FEV","MAR","ABR","MAI","JUN","JUL","AGO","SET","OUT","NOV","DEZ" } 
Local aSemana  		:= { "Domingo","2a. Feira","3a. Feira","4a. Feira","5a. Feira","6a. Feira","Sábado" }
Local aUsers   		:= {}
Local cMes     		:= aMeses[ Month(Date()) ]
Local cPassW   		:= ""
Local cUsuaW   		:= ""
Local cCodUsr  		:= ""
Local aParam1		:= {}
Local aRet1			:= {}
Local aParam2		:= {}
Local aRet2			:= {}
Private lGrv   	 	:= .F.
Private cTime    	:= Left(Time(),5)
Private cTpMarca 	:= ""
Private cTpSP8   	:= ""
Private cTpEnt   	
Private oDlg
Private oFnt1    	:= TFont():New("Arial",09,12,,.T.,,,,.T.,.F.)
Private oFnt2    	:= TFont():New("Arial",11,14,,.T.,,,,.T.,.F.)
Private oFnt3    	:= TFont():New("Arial",36,39,,.T.,,,,.T.,.F.)
Private oFnt4    	:= TFont():New("Arial",10,12,,.T.,,,,.T.,.F.)
// ASSUMIR A FILIAL DO FUNCIONARIO
Private cFilRemota  := "010101" 
Private CFILANT     := "010101" 
Private aTpEnt := {}
//Private cUserA      := Alltrim( SuperGetMv( "FS_USERADM", .F., "Admin" ))
//Private cPassA      := Alltrim( SuperGetMv( "FS_SENHARH", .F., "" ))

Default lBat        := .T.
// rogerio - cfilremota guardará a filial do funcionario

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre as Tabelas e Prepara Ambiente para ser usado via JOB ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lBat
// voltar depois
//	PREPARE ENVIRONMENT EMPRESA '01' FILIAL cFilRemota USER 'admin' PASSWORD '' TABLES 'SRA,SPJ,SR8' MODULO "SIGAPON"
//	PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01' USER 'admin' PASSWORD '' TABLES 'SRA,SPJ,SR8' MODULO "SIGAPON"
	PREPARE ENVIRONMENT EMPRESA '11' FILIAL cFilRemota USER 'admin' PASSWORD 'brasil#2021!' TABLES 'SRA,SPJ,SR8' MODULO "SIGAPON"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o Tipo da Marca - Especifico RISK                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//BUSCAR O TURNO NA TABELA SPJ(TURNO) OU SR6(VALIDA TORENCIA) PELO CAMPO SRA->RA_TNOTRAB

aUsers := AllUsers(.T.)
cPassW := Space(15) //Space( Len(aUsers[1,1,3]) )
aAdd(aTpEnt , "1E" )
aAdd(aTpEnt , "1S" )
aAdd(aTpEnt , "2E" )
aAdd(aTpEnt , "2S"  )
cTpEnt := aTpEnt[1]

	Define MsDialog oDlg Title "Marcação de Ponto Eletrônico - Risk Brasil" Of oMainWnd Pixel From 0,0 To 200,333 Color CLR_BLACK, CLR_WHITE
	
	@ 02,02 To 27,165 Of oDlg Pixel
	@ 05,05 Say "Matricula" 					Size  35,08 Of oDlg Pixel Font oFnt1 Color CLR_BLACK
	@ 11,05 MsGet oSenha Var cPassW PASSWORD 	Size  50,09 Of oDlg Pixel Font oFnt2 Color CLR_BLUE Valid RSKVldSen1(cPassW,@cUsuaW,@cCodUsr,@oUser)
		
	@ 05,60 Say "Usuário" 						Size  35,08 Of oDlg Pixel Font oFnt1 Color CLR_BLACK
	@ 11,60 MsGet oUser  Var cUsuaW           	Size 100,09 Of oDlg Pixel Font oFnt2 Color CLR_BLUE When .F.
	
	@ 30,02 To 60,72  Of oDlg Pixel
	@ 28,01 Say StrZero(Day(Date()),2)			Size  50,30 Of oDlg Pixel Center Font oFnt3 Color CLR_BLUE
	@ 24,32 Say cMes							Size  50,30 Of oDlg Pixel Center Font oFnt4 Color CLR_BLUE
	@ 39,32 Say Str(Year(Date()),4)			Size  50,15 Of oDlg Pixel Center Font oFnt4 Color CLR_BLUE
	@ 48,01 Say aSemana[Dow(Date())] 			Size  70,15 Of oDlg Pixel Center Font oFnt4 Color CLR_HBLUE
	
	@ 30,75 To 60,165 Of oDlg Pixel
	@ 30,76 Say cTime         					Size 87,30 Of oDlg Pixel Center Font oFnt3 Color CLR_BLUE
	
	@ 63,02 To 80,165  Of oDlg Pixel
	@ 63,07 Say "Ip Local: " Size 40,15 Of oDlg Pixel Center Font oFnt4 Color CLR_HBLUE
	@ 68,04 Say Alltrim(GetclientIP()) Size 55,15 Of oDlg Pixel Center Font oFnt4 Color CLR_HBLUE
	
	@ 63,75 To 80,165 Of oDlg Pixel
	@ 63,80 Say "Maquina: " Size 38,15 Of oDlg Pixel Center Font oFnt4 Color CLR_HBLUE
	@ 68,80 Say Alltrim(GetComputerName()) Size 80,15 Of oDlg Pixel Center Font oFnt4 Color CLR_HBLUE  
	
	@ 83,75 To 100,165 Of oDlg Pixel
	//@ 85,80 Say cTpMarca     					Size 80,15 Of oDlg Pixel Center Font oFnt4 Color CLR_HBLUE
	
	@ 83,02 To 100,72  Of oDlg Pixel
	@ 85,04 Say "Tipo Apto.: " Size 30,15 Of oDlg Pixel Center Font oFnt4 Color CLR_HBLUE
	oCombo := TComboBox():New(85,35,{|u|if(PCount()>0,cTpEnt:=u,cTpEnt)},aTpEnt,25,10,oDlg,,,,,,.T.,,,,,,,,,'cTpEnt')

	//@ 83,04 COMBOBOX oDlg VAR cTpEnt ITEMS aTpEnt SIZE 40, 013 PIXEL COLORS 0, 16777215

	Define SButton From 86,85  Type 1 Enable Of oDlg Pixel Action ( oDlg:End() )
	Define SButton From 86,118  Type 2 Enable Of oDlg Pixel Action { || oDlg:End() } 
	
	Activate MsDialog oDlg Center
	
	If lGrv
		DbSelectArea("SRA")
		DbSetOrder(1)
		If DbSeek(xFilial("SRA") + Alltrim(cPassW))
			If !Empty(SRA->RA_PASSAP)
				dbSelectArea("SP8")
				cAponta := RSKAponta1()	
				aAdd(aParam1,{8,"Entre com a senha: ",Space(10),"","","","",80,.T.})				
				If ParamBox(aParam1,"Informe a Senha para Apontamento",@aRet1,,,,,,,,.F.,.F.)
					If Alltrim(SRA->RA_PASSAP) == Alltrim(aRet1[1])
						If RSKVldSP81(cTpEnt)
							dDtAp := If(cTpEnt == "1E",Date(), SEARCHDT(SRA->RA_MAT) )
							cOrdem  := U_RSKOrdem(dDtAp)	
							RecLock("SP8",.T.)
							Replace P8_FILIAL	With xFilial("SP8")				

							Replace P8_MAT		With SRA->RA_MAT					
							Replace P8_DATA		With DATE()							
							Replace P8_HORA		With Val(StrTran(cTime,":","."))	
							Replace P8_CC		With SRA->RA_CC						
							Replace P8_ORDEM	With Alltrim(cOrdem)			
							Replace P8_TURNO	With SRA->RA_TNOTRAB				
							Replace P8_FLAG		With "I"							
							Replace P8_XLOCALI  With Alltrim(GetclientIP())  		
							Replace P8_XNOMMAQ  With Alltrim(GetComputerName())		
							Replace P8_APONTA	With "N"							
							Replace P8_TPMARCA	With cTpEnt						
							Replace P8_PAPONTA	With cAponta   
							//Replace P8_RELOGIO  With //campo customizado
							Replace P8_DATAAPO  With dDtAp
							//Replace P8_SEMANA   With //Semana do periodo
							//Replace P8_NUMREP   With SP0->SP0_REP
							Replace P8_TIPOREG With "O"
							Replace P8_EMPORG   With "11"
							Replace P8_FILORG   With xFilial("SP8")	 
							Replace P8_MATORG   With SRA->RA_MAT
							Replace P8_DATAALT  With Date() 
							Replace P8_HORAALT  With cTime
							Replace P8_USUARIO  With __cUserId //Usuário sistema         
							MsUnLock()
							MessageBox("Apontamento registrado com sucesso!","",MB_OK)	
						Else
							MessageBox("Você já efetuou o apontamento para este horário", "", MB_ICONEXCLAMATION)
						EndIf
					Else
						MessageBox("A senha digitada esta incorreta!","",MB_ICONHAND)//MsgInfo("A senha digitada esta incorreta!")
						MessageBox("Apontamento não efetuado!", "", MB_ICONEXCLAMATION)
					EndIf
				EndIf	
			Else
				nRet := MessageBox("Você não possui senha para apontamento, na proxima tela informe uma senha com no máximo 10 caracteres, esta senha será sua e intransferivel, será utilizada para efetuar seus apontamentos, guarde-a em local seguro!","",MB_OKCANCEL)
				
				If nRet == 1
					aAdd(aParam2,{1,"Informe a senha: ",Space(10),"","","","",0,.T.}) // Tipo caractere
				
					If ParamBox(aParam2,"Cadastro de Senha para Apontamento",@aRet2,,,,,,,,.F.,.F.)

						RecLock("SRA",.F.)
						SRA->RA_PASSAP:= aRet2[1]
						MsUnlock()

						MessageBox("Senha cadastrada! Informe novamente para confirmar apontamento!","",MB_OK)

						dbSelectArea("SP8")
						cAponta := RSKAponta1()				
						aAdd(aParam1,{8,"Entre com a senha: ",Space(10),"","","","",80,.T.})				
						If ParamBox(aParam1,"Informe a Senha para Apontamento",@aRet1,,,,,,,,.F.,.F.)
							If Alltrim(SRA->RA_PASSAP) == Alltrim(aRet1[1])
								If RSKVldSP81(cTpEnt)
									dDtAp := If(cTpEnt == "1E",Date(), SEARCHDT(SRA->RA_MAT) )
									cOrdem  := U_RSKOrdem(dDtAp)
									RecLock('SP8',.T.)
									// rogerio arrumado para filial corrente	Replace P8_FILIAL	With "01"							,;
									Replace 	P8_FILIAL	With xFilial("SP8")					
									replace		P8_MAT		With SRA->RA_MAT					
									replace		P8_DATA		With Date()						
									replace		P8_HORA		With Val(StrTran(cTime,":","."))	
									replace		P8_CC		With SRA->RA_CC						
									replace		P8_ORDEM	With Alltrim(cOrdem)				
									replace		P8_TURNO	With SRA->RA_TNOTRAB				
									replace		P8_FLAG		With "I"							
									replace		P8_APONTA	With "N"							
									replace		P8_XLOCALI  With Alltrim(getServerIP())  		
									replace		P8_XNOMMAQ  With Alltrim(GetComputerName())		
									replace		P8_TPMARCA	With cTpEnt						
									replace		P8_PAPONTA	With cAponta
									//Replace 	P8_RELOGIO  With //campo customizado
									Replace 	P8_DATAAPO  With dDtAp	
									//Replace 	P8_SEMANA   With //Semana do periodo
									//Replace 	P8_NUMREP   With SP0->SP0_REP
									Replace 	P8_TIPOREG With "O"
									Replace 	P8_EMPORG   With "11"
									Replace 	P8_FILORG   With xFilial("SP8")	 
									Replace 	P8_MATORG   With SRA->RA_MAT
									Replace 	P8_DATAALT  With Date() 
									Replace 	P8_HORAALT  With cTime 
									Replace 	P8_USUARIO  With __cUserId //Usuário sistema 
									MsUnLock()		
									MessageBox("Apontamento registrado com sucesso!","",MB_OK)
								Else
									MessageBox("Você já efetuou o apontamento para este horário", "", MB_ICONEXCLAMATION)
								EndIf
							Else
								MessageBox("A senha digitada esta incorreta!","",MB_ICONHAND)//MsgInfo("A senha digitada esta incorreta!")
								MessageBox("Apontamento não efetuado!", "", MB_ICONEXCLAMATION)
							EndIf
						EndIf	
					EndIf						
				EndIf							
			EndIf						
		EndIf
	EndIf

RESET ENVIRONMENT
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³ RSKVldSen ³ Autor ³ Rogerio Silva	        ³ Data ³11/12/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao³ Valida a senha do Functionario                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MIR RISK                        				          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RSKVldSen1(cPassW,cUsuaW,cCodUsr,oUser)
Local lRet  := .T.

DbSelectArea("SRA")
DbSetOrder(1)
If DbSeek(xFilial("SRA") + Alltrim(cPassW))
	cUsuaW  := Alltrim(SRA->RA_NOME)
	oUser:Refresh()
	DbSelectArea("SPJ")
	DbSetOrder(1)
	If Dbseek(xFilial("SPJ") + SRA->RA_TNOTRAB + '01' + ALLTRIM(STR(DOW(DATE()))))
		If cTime >= IntToHora(SPJ->PJ_ENTRA1) .And. cTime <= IntToHora(SPJ->PJ_SAIDA1-0.01)
			cTpMarca := "1a. Entrada"
			cTpSP8   := "1E"
		EndIf
		If cTime >= IntToHora(SPJ->PJ_SAIDA1) .And. cTime <= IntToHora(SPJ->PJ_ENTRA2-0.01) //Menos 1 Minuto
			cTpMarca := "1a. Saída"  
			cTpSP8   := "1S"
		EndIf
		If cTime >= IntToHora(SPJ->PJ_ENTRA2) .And. cTime <= IntToHora(SPJ->PJ_SAIDA2-0.01) //Menos 1 Minuto
			cTpMarca := "2a. Entrada"
			cTpSP8   := "2E"
		EndIf
		If cTime >= IntToHora(SPJ->PJ_SAIDA2)
			cTpMarca := "2a. Saída"
			cTpSP8   := "2S"
		EndIf
		lGrv := .T.
		oDlg:Refresh()
	Else
		MessageBox("Turno não cadastrado, consulte o departamento pessoal!","", MB_ICONEXCLAMATION)
		lGrv := .F.
	EndIf	
Else
	MessageBox("A matricula informada é inválida!","", MB_ICONEXCLAMATION)
	lGrv := .F.
EndIf
Return(lRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³ RSKVldSP8 ³ Autor ³ Rogerio Silva	        ³ Data ³11/12/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao³ Valida se Ja foi Registrado as Marcas do Funcionario       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MIR RISK                				                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RSKVldSP81(cTpEnt)
Local aAreaAnt := GetArea()
Local lRet     := .T.
SP8->(dbSetOrder(2))
If SP8->(dbSeek(xFilial("SP8")+SRA->RA_MAT+DtoS(Date()) ))
	While !SP8->(Eof()) .And. xFilial("SP8")+SRA->RA_MAT+DtoS(Date()) ==SP8->(P8_FILIAL+P8_MAT+DtoS(P8_DATA))
		If Left(DtoC(Date()),2)+cTpEnt == SP8->(P8_ORDEM+P8_TPMARCA)
			lRet := .F.
			Exit
		EndIf
		SP8->(dbSkip())
	EndDo
EndIf
RestArea(aAreaAnt)
Return(lRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³ RSKAponta ³ Autor ³ Rogerio Silva	        ³ Data ³11/12/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao³ Cria o Periodo de Apontamento                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MIR RISK				                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RSKAponta1()
Local dDtIni   := CtoD("")//StoD(Str(Year(Date()),4) + StrZero(Month(Date()),2) + "16")
Local dDtFim   := CtoD("")
Local cPeriodo := Alltrim(GetMv( "MV_PONMES") )
Local nDia    := 0
Local nDiaIni := 0
Local nDiaFim := 0


nDia    := DAY(date())
nDiaIni := Val(SubStr(cPeriodo,7,2))
nDiaFim := Val(SubStr(cPeriodo,16,2))

If nDia > nDiaIni .or. nDia = nDiaIni

	If Month(Date()) <> 12
		dDtIni := ALLTRIM(Str(Year(Date()),4)) + ALLTRIM(StrZero(Month(Date()),2)) + ALLTRIM(str(nDiaIni))
		dDtFim := ALLTRIM(Str(Year(Date()),4)) + ALLTRIM(StrZero(Month(Date()) +1,2)) + ALLTRIM(str(nDiaFim))
	Else
		dDtIni := ALLTRIM(Str(Year(Date()),4)) + ALLTRIM(StrZero(Month(Date()),2)) + ALLTRIM(str(nDiaIni))
		dDtFim := ALLTRIM(Str(Year(Date())+1,4)) + '01' + ALLTRIM(str(nDiaFim))
	EndIf	


ElseIf nDia < nDiaIni

	If (Month(Date()) -1) <> 12

		dDtIni := ALLTRIM(Str(Year(Date()),4)) + ALLTRIM(StrZero(Month(Date()) -1 ,2)) + ALLTRIM(str(nDiaIni))
		dDtFim := ALLTRIM(Str(Year(Date()),4)) + ALLTRIM(StrZero(Month(Date()),2)) + ALLTRIM(str(nDiaFim))
	Else
		dDtIni := ALLTRIM(Str(Year(Date())-1,4)) + '12' + ALLTRIM(str(nDiaIni))
		dDtFim := ALLTRIM(Str(Year(Date()),4)) + ALLTRIM(StrZero(Month(Date()),2)) + ALLTRIM(str(nDiaFim))
	EndIf	

Endif


Return(dDtIni+dDtFim)      

// ROGERIO 0002
User Function RSKREMO2(lBat)
// rogerio cfilremota guarda a filial do equipamento
//User Function RSKREMO1(lBat)

Local oSenha                    
Local aMeses   		:= { "JAN","FEV","MAR","ABR","MAI","JUN","JUL","AGO","SET","OUT","NOV","DEZ" } 
Local aSemana  		:= { "Domingo","2a. Feira","3a. Feira","4a. Feira","5a. Feira","6a. Feira","Sábado" }
Local aUsers   		:= {}
Local cMes     		:= aMeses[ Month(Date()) ]
Local cPassW   		:= ""
Local cUsuaW   		:= ""
Local cCodUsr  		:= ""
Local aParam1		:= {}
Local aRet1			:= {}
Local aParam2		:= {}
Local aRet2			:= {}
Private lGrv   	 	:= .F.
Private cTime    	:= Left(Time(),5)
Private cTpMarca 	:= ""
Private cTpSP8   	:= ""
Private oDlg
Private oFnt1    	:= TFont():New("Arial",09,12,,.T.,,,,.T.,.F.)
Private oFnt2    	:= TFont():New("Arial",11,14,,.T.,,,,.T.,.F.)
Private oFnt3    	:= TFont():New("Arial",36,39,,.T.,,,,.T.,.F.)
Private oFnt4    	:= TFont():New("Arial",10,12,,.T.,,,,.T.,.F.)
// ASSUMIR A FILIAL DO FUNCIONARIO
Private cFilRemota  := "020101" 
Private CFILANT     := "020101"     
//Private cUserA      := Alltrim( SuperGetMv( "FS_USERADM", .F., "Admin" ))
//Private cPassA      := Alltrim( SuperGetMv( "FS_SENHARH", .F., "" ))
Private aTpEnt := {}

Default lBat        := .T.
// rogerio - cfilremota guardará a filial do funcionario

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre as Tabelas e Prepara Ambiente para ser usado via JOB ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lBat
// voltar depois
//	PREPARE ENVIRONMENT EMPRESA '01' FILIAL cFilRemota USER 'admin' PASSWORD '' TABLES 'SRA,SPJ,SR8' MODULO "SIGAPON"
//	PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01' USER 'admin' PASSWORD '' TABLES 'SRA,SPJ,SR8' MODULO "SIGAPON"
	PREPARE ENVIRONMENT EMPRESA '11' FILIAL cFilRemota USER 'admin' PASSWORD 'brasil#2021!' TABLES 'SRA,SPJ,SR8' MODULO "SIGAPON"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o Tipo da Marca - Especifico RISK                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//BUSCAR O TURNO NA TABELA SPJ(TURNO) OU SR6(VALIDA TORENCIA) PELO CAMPO SRA->RA_TNOTRAB

aUsers := AllUsers(.T.)
cPassW := Space(15) //Space( Len(aUsers[1,1,3]) )
aAdd(aTpEnt , "1E" )
aAdd(aTpEnt , "1S" )
aAdd(aTpEnt , "2E" )
aAdd(aTpEnt , "2S"  )
cTpEnt := aTpEnt[1]

Define MsDialog oDlg Title "Marcação de Ponto Eletrônico - Risk Brasil" Of oMainWnd Pixel From 0,0 To 200,333 Color CLR_BLACK, CLR_WHITE
	
	@ 02,02 To 27,165 Of oDlg Pixel
	@ 05,05 Say "Matricula" 					Size  35,08 Of oDlg Pixel Font oFnt1 Color CLR_BLACK
	@ 11,05 MsGet oSenha Var cPassW PASSWORD 	Size  50,09 Of oDlg Pixel Font oFnt2 Color CLR_BLUE Valid RSKVldSen2(cPassW,@cUsuaW,@cCodUsr,@oUser)
		
	@ 05,60 Say "Usuário" 						Size  35,08 Of oDlg Pixel Font oFnt1 Color CLR_BLACK
	@ 11,60 MsGet oUser  Var cUsuaW           	Size 100,09 Of oDlg Pixel Font oFnt2 Color CLR_BLUE When .F.
	
	@ 30,02 To 60,72  Of oDlg Pixel
	@ 28,01 Say StrZero(Day(Date()),2)			Size  50,30 Of oDlg Pixel Center Font oFnt3 Color CLR_BLUE
	@ 24,32 Say cMes							Size  50,30 Of oDlg Pixel Center Font oFnt4 Color CLR_BLUE
	@ 39,32 Say Str(Year(Date()),4)			Size  50,15 Of oDlg Pixel Center Font oFnt4 Color CLR_BLUE
	@ 48,01 Say aSemana[Dow(Date())] 			Size  70,15 Of oDlg Pixel Center Font oFnt4 Color CLR_HBLUE
	
	@ 30,75 To 60,165 Of oDlg Pixel
	@ 30,76 Say cTime         					Size 87,30 Of oDlg Pixel Center Font oFnt3 Color CLR_BLUE
	
	@ 63,02 To 80,165  Of oDlg Pixel
	@ 63,07 Say "Ip Local: " Size 40,15 Of oDlg Pixel Center Font oFnt4 Color CLR_HBLUE
	@ 68,04 Say Alltrim(GetclientIP()) Size 55,15 Of oDlg Pixel Center Font oFnt4 Color CLR_HBLUE
	
	@ 63,75 To 80,165 Of oDlg Pixel
	@ 63,80 Say "Maquina: " Size 38,15 Of oDlg Pixel Center Font oFnt4 Color CLR_HBLUE
	@ 68,80 Say Alltrim(GetComputerName()) Size 80,15 Of oDlg Pixel Center Font oFnt4 Color CLR_HBLUE  
	
	@ 83,75 To 100,165 Of oDlg Pixel
	//@ 85,80 Say cTpMarca     					Size 80,15 Of oDlg Pixel Center Font oFnt4 Color CLR_HBLUE
	
	@ 83,02 To 100,72  Of oDlg Pixel
	@ 85,04 Say "Tipo Apto.: " Size 30,15 Of oDlg Pixel Center Font oFnt4 Color CLR_HBLUE
	oCombo := TComboBox():New(85,35,{|u|if(PCount()>0,cTpEnt:=u,cTpEnt)},aTpEnt,25,10,oDlg,,,,,,.T.,,,,,,,,,'cTpEnt')

	//@ 83,04 COMBOBOX oDlg VAR cTpEnt ITEMS aTpEnt SIZE 40, 013 PIXEL COLORS 0, 16777215

	Define SButton From 86,85  Type 1 Enable Of oDlg Pixel Action ( oDlg:End() )
	Define SButton From 86,118  Type 2 Enable Of oDlg Pixel Action { || oDlg:End() } 
	
	Activate MsDialog oDlg Center
	
	If lGrv
		DbSelectArea("SRA")
		DbSetOrder(1)
		If DbSeek(xFilial("SRA") + Alltrim(cPassW))
			If !Empty(SRA->RA_PASSAP)
				dbSelectArea("SP8")
				cAponta := RSKAponta2()			
				aAdd(aParam1,{8,"Entre com a senha: ",Space(10),"","","","",80,.T.})				
				If ParamBox(aParam1,"Informe a Senha para Apontamento",@aRet1,,,,,,,,.F.,.F.)
					If Alltrim(SRA->RA_PASSAP) == Alltrim(aRet1[1])
						If RSKVldSP82(cTpEnt)
							dDtAp := If(cTpEnt == "1E",Date(), SEARCHDT(SRA->RA_MAT) )
							cOrdem  := U_RSKOrdem(dDtAp)
							RecLock("SP8",.T.)
							Replace P8_FILIAL	With xFilial("SP8")				
							Replace P8_MAT		With SRA->RA_MAT					
							Replace P8_DATA		With Date()					
							Replace P8_HORA		With Val(StrTran(cTime,":","."))	
							Replace P8_CC		With SRA->RA_CC						
							Replace P8_ORDEM	With Alltrim(cOrdem)				
							Replace P8_TURNO	With SRA->RA_TNOTRAB				
							Replace P8_FLAG		With "I"							
							Replace P8_XLOCALI  With Alltrim(GetclientIP())  		
							Replace P8_XNOMMAQ  With Alltrim(GetComputerName())		
							Replace P8_APONTA	With "N"							
							Replace P8_TPMARCA	With cTpEnt							
							Replace P8_PAPONTA	With cAponta  
							//Replace P8_RELOGIO  With //campo customizado
							Replace P8_DATAAPO  With dDtAp
							//Replace P8_SEMANA   With //Semana do periodo
							//Replace P8_NUMREP   With SP0->SP0_REP
							Replace P8_TIPOREG  With "O"
							Replace P8_EMPORG   With "11"
							Replace P8_FILORG   With xFilial("SP8")	 
							Replace P8_MATORG   With SRA->RA_MAT
							Replace P8_DATAALT  With Date() 
							Replace P8_HORAALT  With cTime
							Replace P8_USUARIO  With __cUserId //Usuário sistema                       
							MsUnLock()
							MessageBox("Apontamento registrado com sucesso!","",MB_OK)	
						Else
							MessageBox("Você já efetuou o apontamento para este horário", "", MB_ICONEXCLAMATION)
						EndIf
					Else
						MessageBox("A senha digitada esta incorreta!","",MB_ICONHAND)//MsgInfo("A senha digitada esta incorreta!")
						MessageBox("Apontamento não efetuado!", "", MB_ICONEXCLAMATION)
					EndIf
				EndIf	
			Else
				nRet := MessageBox("Você não possui senha para apontamento, na proxima tela informe uma senha com no máximo 10 caracteres, esta senha será sua e intransferivel, será utilizada para efetuar seus apontamentos, guarde-a em local seguro!","",MB_OKCANCEL)
				
				If nRet == 1
					aAdd(aParam2,{1,"Informe a senha: ",Space(10),"","","","",0,.T.}) // Tipo caractere
				
					If ParamBox(aParam2,"Cadastro de Senha para Apontamento",@aRet2,,,,,,,,.F.,.F.)

						RecLock("SRA",.F.)
						SRA->RA_PASSAP:= aRet2[1]
						MsUnlock()

						MessageBox("Senha cadastrada! Informe novamente para confirmar apontamento!","",MB_OK)

						dbSelectArea("SP8")
						cAponta := RSKAponta2()			
						aAdd(aParam1,{8,"Entre com a senha: ",Space(10),"","","","",80,.T.})				
						If ParamBox(aParam1,"Informe a Senha para Apontamento",@aRet1,,,,,,,,.F.,.F.)
							If Alltrim(SRA->RA_PASSAP) == Alltrim(aRet1[1])
								If RSKVldSP82(cTpEnt)
									dDtAp := If(cTpEnt == "1E",Date(), SEARCHDT(SRA->RA_MAT) )
									cOrdem  := U_RSKOrdem(dDtAp)
									RecLock('SP8',.T.)
									// rogerio arrumado para filial corrente	Replace P8_FILIAL	With "01"							,;
									Replace P8_FILIAL	With xFilial("SP8")					
									replace		P8_MAT		With SRA->RA_MAT					
									replace		P8_DATA		With Date()							
									replace		P8_HORA		With Val(StrTran(cTime,":","."))	
									replace		P8_CC		With SRA->RA_CC						
									replace		P8_ORDEM	With Alltrim(cOrdem)				
									replace		P8_TURNO	With SRA->RA_TNOTRAB				
									replace		P8_FLAG		With "I"							
									replace		P8_APONTA	With "N"							
									replace		P8_XLOCALI  With Alltrim(getServerIP())  		
									replace		P8_XNOMMAQ  With Alltrim(GetComputerName())		
									replace		P8_TPMARCA	With cTpEnt							
									replace		P8_PAPONTA	With cAponta
									//Replace 	P8_RELOGIO  With //campo customizado
									Replace 	P8_DATAAPO  With dDtAp	
									//Replace 	P8_SEMANA   With //Semana do periodo
									//Replace		P8_NUMREP   With SP0->SP0_REP
									Replace 	P8_TIPOREG  With "O"
									Replace 	P8_EMPORG   With "11"
									Replace 	P8_FILORG   With xFilial("SP8")	 
									Replace 	P8_MATORG   With SRA->RA_MAT
									Replace 	P8_DATAALT  With Date() 
									Replace 	P8_HORAALT  With cTime
									Replace 	P8_USUARIO  With __cUserId //Usuário sistema 
									MsUnLock()		
									MessageBox("Apontamento registrado com sucesso!","",MB_OK)
								Else
									MessageBox("Você já efetuou o apontamento para este horário", "", MB_ICONEXCLAMATION)
								EndIf
							Else
								MessageBox("A senha digitada esta incorreta!","",MB_ICONHAND)//MsgInfo("A senha digitada esta incorreta!")
								MessageBox("Apontamento não efetuado!", "", MB_ICONEXCLAMATION)
							EndIf
						EndIf	
					EndIf						
				EndIf							
			EndIf						
		EndIf
	EndIf
RESET ENVIRONMENT
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³ RSKVldSen ³ Autor ³ Rogerio Silva	        ³ Data ³11/12/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao³ Valida a senha do Functionario                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MIR RISK                        				          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RSKVldSen2(cPassW,cUsuaW,cCodUsr,oUser)
Local lRet  := .T.

DbSelectArea("SRA")
DbSetOrder(1)
If DbSeek(xFilial("SRA") + Alltrim(cPassW))
	cUsuaW  := Alltrim(SRA->RA_NOME)
	oUser:Refresh()
	DbSelectArea("SPJ")
	DbSetOrder(1)
	If Dbseek(xFilial("SPJ") + SRA->RA_TNOTRAB)
		If cTime >= IntToHora(SPJ->PJ_ENTRA1) .And. cTime <= IntToHora(SPJ->PJ_SAIDA1-0.01)
			cTpMarca := "1a. Entrada"
			cTpSP8   := "1E"
		EndIf
		If cTime >= IntToHora(SPJ->PJ_SAIDA1) .And. cTime <= IntToHora(SPJ->PJ_ENTRA2-0.01) //Menos 1 Minuto
			cTpMarca := "1a. Saída"  
			cTpSP8   := "1S"
		EndIf
		If cTime >= IntToHora(SPJ->PJ_ENTRA2) .And. cTime <= IntToHora(SPJ->PJ_SAIDA2-0.01) //Menos 1 Minuto
			cTpMarca := "2a. Entrada"
			cTpSP8   := "2E"
		EndIf
		If cTime >= IntToHora(SPJ->PJ_SAIDA2)
			cTpMarca := "2a. Saída"
			cTpSP8   := "2S"
		EndIf
		lGrv := .T.
		oDlg:Refresh()
	Else
		MessageBox("Turno não cadastrado, consulte o departamento pessoal!","", MB_ICONEXCLAMATION)
		lGrv := .F.
	EndIf	
Else
	MessageBox("A matricula informada é inválida!","", MB_ICONEXCLAMATION)
	lGrv := .F.
EndIf
Return(lRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³ RSKVldSP8 ³ Autor ³ Rogerio Silva	        ³ Data ³11/12/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao³ Valida se Ja foi Registrado as Marcas do Funcionario       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MIR RISK                				                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RSKVldSP82(cTpEnt)
Local aAreaAnt := GetArea()
Local lRet     := .T.
SP8->(dbSetOrder(2))
If SP8->(dbSeek(xFilial("SP8")+SRA->RA_MAT+DtoS(Date()) ))
	While !SP8->(Eof()) .And. xFilial("SP8")+SRA->RA_MAT+DtoS(Date()) ==SP8->(P8_FILIAL+P8_MAT+DtoS(P8_DATA))
		If Left(DtoC(Date()),2)+cTpEnt == SP8->(P8_ORDEM+P8_TPMARCA)
			lRet := .F.
			Exit
		EndIf
		SP8->(dbSkip())
	EndDo
EndIf
RestArea(aAreaAnt)
Return(lRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³ RSKAponta ³ Autor ³ Rogerio Silva	        ³ Data ³11/12/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao³ Cria o Periodo de Apontamento                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MIR RISK				                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RSKAponta2()
Local dDtIni   := CtoD("")//StoD(Str(Year(Date()),4) + StrZero(Month(Date()),2) + "16")
Local dDtFim   := CtoD("")
Local cPeriodo := Alltrim(GetMv( "MV_PONMES") )
Local nDia    := 0
Local nDiaIni := 0
Local nDiaFim := 0

nDia    := DAY(date())
nDiaIni := Val(SubStr(cPeriodo,7,2))
nDiaFim := Val(SubStr(cPeriodo,16,2))

If nDia > nDiaIni .or. nDia = nDiaIni

	If Month(Date()) <> 12
		dDtIni := ALLTRIM(Str(Year(Date()),4)) + ALLTRIM(StrZero(Month(Date()),2)) + ALLTRIM(str(nDiaIni))
		dDtFim := ALLTRIM(Str(Year(Date()),4)) + ALLTRIM(StrZero(Month(Date()) +1,2)) + ALLTRIM(str(nDiaFim))
	Else
		dDtIni := ALLTRIM(Str(Year(Date()),4)) + ALLTRIM(StrZero(Month(Date()),2)) + ALLTRIM(str(nDiaIni))
		dDtFim := ALLTRIM(Str(Year(Date())+1,4)) + '01' + ALLTRIM(str(nDiaFim))
	EndIf	


ElseIf nDia < nDiaIni

	If (Month(Date()) -1) <> 12

		dDtIni := ALLTRIM(Str(Year(Date()),4)) + ALLTRIM(StrZero(Month(Date()) -1 ,2)) + ALLTRIM(str(nDiaIni))
		dDtFim := ALLTRIM(Str(Year(Date()),4)) + ALLTRIM(StrZero(Month(Date()),2)) + ALLTRIM(str(nDiaFim))
	Else
		dDtIni := ALLTRIM(Str(Year(Date())-1,4)) + '12' + ALLTRIM(str(nDiaIni))
		dDtFim := ALLTRIM(Str(Year(Date()),4)) + ALLTRIM(StrZero(Month(Date()),2)) + ALLTRIM(str(nDiaFim))
	EndIf	

Endif


Return(dDtIni+dDtFim)  

// ROGERIO 0003

User Function RSKREMO3(lBat)
// rogerio cfilremota guarda a filial do equipamento
//User Function RSKREMO1(lBat)

Local oSenha                    
Local aMeses   		:= { "JAN","FEV","MAR","ABR","MAI","JUN","JUL","AGO","SET","OUT","NOV","DEZ" } 
Local aSemana  		:= { "Domingo","2a. Feira","3a. Feira","4a. Feira","5a. Feira","6a. Feira","Sábado" }
Local aUsers   		:= {}
Local cMes     		:= aMeses[ Month(Date()) ]
Local cPassW   		:= ""
Local cUsuaW   		:= ""
Local cCodUsr  		:= ""
Local aParam1		:= {}
Local aRet1			:= {}
Local aParam2		:= {}
Local aRet2			:= {}
Private lGrv   	 	:= .F.
Private cTime    	:= Left(Time(),5)
Private cTpMarca 	:= ""
Private cTpSP8   	:= ""
Private oDlg
Private oFnt1    	:= TFont():New("Arial",09,12,,.T.,,,,.T.,.F.)
Private oFnt2    	:= TFont():New("Arial",11,14,,.T.,,,,.T.,.F.)
Private oFnt3    	:= TFont():New("Arial",36,39,,.T.,,,,.T.,.F.)
Private oFnt4    	:= TFont():New("Arial",10,12,,.T.,,,,.T.,.F.)
// ASSUMIR A FILIAL DO FUNCIONARIO
Private cFilRemota  := "030101"  
Private CFILANT     := "030101"    
//Private cUserA      := Alltrim( SuperGetMv( "FS_USERADM", .F., "Admin" ))
//Private cPassA      := Alltrim( SuperGetMv( "FS_SENHARH", .F., "" ))
Private aTpEnt := {}
Default lBat        := .T.
// rogerio - cfilremota guardará a filial do funcionario

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre as Tabelas e Prepara Ambiente para ser usado via JOB ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lBat
// voltar depois
//	PREPARE ENVIRONMENT EMPRESA '01' FILIAL cFilRemota USER 'admin' PASSWORD '' TABLES 'SRA,SPJ,SR8' MODULO "SIGAPON"
//	PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01' USER 'admin' PASSWORD '' TABLES 'SRA,SPJ,SR8' MODULO "SIGAPON"
	PREPARE ENVIRONMENT EMPRESA '11' FILIAL cFilRemota USER 'admin' PASSWORD 'brasil#2021!' TABLES 'SRA,SPJ,SR8' MODULO "SIGAPON"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o Tipo da Marca - Especifico RISK                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//BUSCAR O TURNO NA TABELA SPJ(TURNO) OU SR6(VALIDA TORENCIA) PELO CAMPO SRA->RA_TNOTRAB

aUsers := AllUsers(.T.)
cPassW := Space(15) //Space( Len(aUsers[1,1,3]) )
aAdd(aTpEnt , "1E" )
aAdd(aTpEnt , "1S" )
aAdd(aTpEnt , "2E" )
aAdd(aTpEnt , "2S"  )
cTpEnt := aTpEnt[1]


Define MsDialog oDlg Title "Marcação de Ponto Eletrônico - Risk Brasil" Of oMainWnd Pixel From 0,0 To 200,333 Color CLR_BLACK, CLR_WHITE
	
	@ 02,02 To 27,165 Of oDlg Pixel
	@ 05,05 Say "Matricula" 					Size  35,08 Of oDlg Pixel Font oFnt1 Color CLR_BLACK
	@ 11,05 MsGet oSenha Var cPassW PASSWORD 	Size  50,09 Of oDlg Pixel Font oFnt2 Color CLR_BLUE Valid RSKVldSen3(cPassW,@cUsuaW,@cCodUsr,@oUser)
		
	@ 05,60 Say "Usuário" 						Size  35,08 Of oDlg Pixel Font oFnt1 Color CLR_BLACK
	@ 11,60 MsGet oUser  Var cUsuaW           	Size 100,09 Of oDlg Pixel Font oFnt2 Color CLR_BLUE When .F.
	
	@ 30,02 To 60,72  Of oDlg Pixel
	@ 28,01 Say StrZero(Day(Date()),2)			Size  50,30 Of oDlg Pixel Center Font oFnt3 Color CLR_BLUE
	@ 24,32 Say cMes							Size  50,30 Of oDlg Pixel Center Font oFnt4 Color CLR_BLUE
	@ 39,32 Say Str(Year(Date()),4)			Size  50,15 Of oDlg Pixel Center Font oFnt4 Color CLR_BLUE
	@ 48,01 Say aSemana[Dow(Date())] 			Size  70,15 Of oDlg Pixel Center Font oFnt4 Color CLR_HBLUE
	
	@ 30,75 To 60,165 Of oDlg Pixel
	@ 30,76 Say cTime         					Size 87,30 Of oDlg Pixel Center Font oFnt3 Color CLR_BLUE
	
	@ 63,02 To 80,165  Of oDlg Pixel
	@ 63,07 Say "Ip Local: " Size 40,15 Of oDlg Pixel Center Font oFnt4 Color CLR_HBLUE
	@ 68,04 Say Alltrim(GetclientIP()) Size 55,15 Of oDlg Pixel Center Font oFnt4 Color CLR_HBLUE
	
	@ 63,75 To 80,165 Of oDlg Pixel
	@ 63,80 Say "Maquina: " Size 38,15 Of oDlg Pixel Center Font oFnt4 Color CLR_HBLUE
	@ 68,80 Say Alltrim(GetComputerName()) Size 80,15 Of oDlg Pixel Center Font oFnt4 Color CLR_HBLUE  
	
	@ 83,75 To 100,165 Of oDlg Pixel
	//@ 85,80 Say cTpMarca     					Size 80,15 Of oDlg Pixel Center Font oFnt4 Color CLR_HBLUE
	
	@ 83,02 To 100,72  Of oDlg Pixel
	@ 85,04 Say "Tipo Apto.: " Size 30,15 Of oDlg Pixel Center Font oFnt4 Color CLR_HBLUE
	oCombo := TComboBox():New(85,35,{|u|if(PCount()>0,cTpEnt:=u,cTpEnt)},aTpEnt,25,10,oDlg,,,,,,.T.,,,,,,,,,'cTpEnt')

	//@ 83,04 COMBOBOX oDlg VAR cTpEnt ITEMS aTpEnt SIZE 40, 013 PIXEL COLORS 0, 16777215

	Define SButton From 86,85  Type 1 Enable Of oDlg Pixel Action ( oDlg:End() )
	Define SButton From 86,118  Type 2 Enable Of oDlg Pixel Action { || oDlg:End() } 
	
	Activate MsDialog oDlg Center
	
	If lGrv
		DbSelectArea("SRA")
		DbSetOrder(1)
		If DbSeek(xFilial("SRA") + Alltrim(cPassW))
			If !Empty(SRA->RA_PASSAP)
				dbSelectArea("SP8")
				cAponta := RSKAponta3()				
				aAdd(aParam1,{8,"Entre com a senha: ",Space(10),"","","","",80,.T.})				
				If ParamBox(aParam1,"Informe a Senha para Apontamento",@aRet1,,,,,,,,.F.,.F.)
					If Alltrim(SRA->RA_PASSAP) == Alltrim(aRet1[1])
						If RSKVldSP83(cTpEnt)
							dDtAp := If(cTpEnt == "1E",Date(), SEARCHDT(SRA->RA_MAT) )
							cOrdem  := U_RSKOrdem(dDtAp)
							RecLock("SP8",.T.)
							Replace P8_FILIAL	With xFilial("SP8")				
							Replace P8_MAT		With SRA->RA_MAT					
							Replace P8_DATA		With Date()						
							Replace P8_HORA		With Val(StrTran(cTime,":","."))	
							Replace P8_CC		With SRA->RA_CC						
							Replace P8_ORDEM	With Alltrim(cOrdem)				
							Replace P8_TURNO	With SRA->RA_TNOTRAB				
							Replace P8_FLAG		With "I"							
							Replace P8_XLOCALI  With Alltrim(GetclientIP())  		
							Replace P8_XNOMMAQ  With Alltrim(GetComputerName())		
							Replace P8_APONTA	With "N"							
							Replace P8_TPMARCA	With cTpEnt						
							Replace P8_PAPONTA	With cAponta     
							//Replace P8_RELOGIO  With //campo customizado
							Replace P8_DATAAPO  With dDtAp
							//Replace P8_SEMANA   With //Semana do periodo
							//Replace P8_NUMREP   With SP0->SP0_REP
							Replace P8_TIPOREG  With "O"
							Replace P8_EMPORG   With "11"
							Replace P8_FILORG   With xFilial("SP8")	 
							Replace P8_MATORG   With SRA->RA_MAT
							Replace P8_DATAALT  With Date() 
							Replace P8_HORAALT  With cTime
							Replace P8_USUARIO  With __cUserId //Usuário sistema                    
							MsUnLock()
							MessageBox("Apontamento registrado com sucesso!","",MB_OK)	
						Else
							MessageBox("Você já efetuou o apontamento para este horário", "", MB_ICONEXCLAMATION)
						EndIf
					Else
						MessageBox("A senha digitada esta incorreta!","",MB_ICONHAND)//MsgInfo("A senha digitada esta incorreta!")
						MessageBox("Apontamento não efetuado!", "", MB_ICONEXCLAMATION)
					EndIf
				EndIf	
			Else
				nRet := MessageBox("Você não possui senha para apontamento, na proxima tela informe uma senha com no máximo 10 caracteres, esta senha será sua e intransferivel, será utilizada para efetuar seus apontamentos, guarde-a em local seguro!","",MB_OKCANCEL)
				
				If nRet == 1
					aAdd(aParam2,{1,"Informe a senha: ",Space(10),"","","","",0,.T.}) // Tipo caractere
				
					If ParamBox(aParam2,"Cadastro de Senha para Apontamento",@aRet2,,,,,,,,.F.,.F.)

						RecLock("SRA",.F.)
						SRA->RA_PASSAP:= aRet2[1]
						MsUnlock()

						MessageBox("Senha cadastrada! Informe novamente para confirmar apontamento!","",MB_OK)

						dbSelectArea("SP8")
						cAponta := RSKAponta3()			
						aAdd(aParam1,{8,"Entre com a senha: ",Space(10),"","","","",80,.T.})				
						If ParamBox(aParam1,"Informe a Senha para Apontamento",@aRet1,,,,,,,,.F.,.F.)
							If Alltrim(SRA->RA_PASSAP) == Alltrim(aRet1[1])
								If RSKVldSP83(cTpEnt)
									dDtAp := If(cTpEnt == "1E",Date(), SEARCHDT(SRA->RA_MAT) )
									cOrdem  := U_RSKOrdem(dDtAp)
									RecLock('SP8',.T.)
									// rogerio arrumado para filial corrente	Replace P8_FILIAL	With "01"							,;
									Replace P8_FILIAL	With xFilial("SP8")					
									replace		P8_MAT		With SRA->RA_MAT					
									replace		P8_DATA		With Date() 							
									replace		P8_HORA		With Val(StrTran(cTime,":","."))	
									replace		P8_CC		With SRA->RA_CC						
									replace		P8_ORDEM	With Alltrim(cOrdem)				
									replace		P8_TURNO	With SRA->RA_TNOTRAB				
									replace		P8_FLAG		With "I"							
									replace		P8_APONTA	With "N"							
									replace		P8_XLOCALI  With Alltrim(getServerIP())  		
									replace		P8_XNOMMAQ  With Alltrim(GetComputerName())		
									replace		P8_TPMARCA	With cTpEnt							
									replace		P8_PAPONTA	With cAponta
									//Replace 	P8_RELOGIO  With //campo customizado
									Replace 	P8_DATAAPO  With dDtAp	
									//Replace 	P8_SEMANA   With //Semana do periodo
									//Replace 	P8_NUMREP   With SP0->SP0_REP
									Replace 	P8_TIPOREG  With "O"
									Replace 	P8_EMPORG   With "11"
									Replace 	P8_FILORG   With xFilial("SP8")	 
									Replace 	P8_MATORG   With SRA->RA_MAT
									Replace 	P8_DATAALT  With Date() 
									Replace 	P8_HORAALT  With cTime
									Replace 	P8_USUARIO  With __cUserId //Usuário sistema 
									MsUnLock()		
									MessageBox("Apontamento registrado com sucesso!","",MB_OK)
								Else
									MessageBox("Você já efetuou o apontamento para este horário", "", MB_ICONEXCLAMATION)
								EndIf
							Else
								MessageBox("A senha digitada esta incorreta!","",MB_ICONHAND)//MsgInfo("A senha digitada esta incorreta!")
								MessageBox("Apontamento não efetuado!", "", MB_ICONEXCLAMATION)
							EndIf
						EndIf	
					EndIf						
				EndIf							
			EndIf						
		EndIf
	EndIf

RESET ENVIRONMENT
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³ RSKVldSen ³ Autor ³ Rogerio Silva	        ³ Data ³11/12/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao³ Valida a senha do Functionario                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MIR RISK                        				          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RSKVldSen3(cPassW,cUsuaW,cCodUsr,oUser)
Local lRet  := .T.

DbSelectArea("SRA")
DbSetOrder(1)
If DbSeek(xFilial("SRA") + Alltrim(cPassW))
	cUsuaW  := Alltrim(SRA->RA_NOME)
	oUser:Refresh()
	DbSelectArea("SPJ")
	DbSetOrder(1)
	If Dbseek(xFilial("SPJ") + SRA->RA_TNOTRAB)
		If cTime >= IntToHora(SPJ->PJ_ENTRA1) .And. cTime <= IntToHora(SPJ->PJ_SAIDA1-0.01)
			cTpMarca := "1a. Entrada"
			cTpSP8   := "1E"
		EndIf
		If cTime >= IntToHora(SPJ->PJ_SAIDA1) .And. cTime <= IntToHora(SPJ->PJ_ENTRA2-0.01) //Menos 1 Minuto
			cTpMarca := "1a. Saída"  
			cTpSP8   := "1S"
		EndIf
		If cTime >= IntToHora(SPJ->PJ_ENTRA2) .And. cTime <= IntToHora(SPJ->PJ_SAIDA2-0.01) //Menos 1 Minuto
			cTpMarca := "2a. Entrada"
			cTpSP8   := "2E"
		EndIf
		If cTime >= IntToHora(SPJ->PJ_SAIDA2)
			cTpMarca := "2a. Saída"
			cTpSP8   := "2S"
		EndIf
		lGrv := .T.
		oDlg:Refresh()
	Else
		MessageBox("Turno não cadastrado, consulte o departamento pessoal!","", MB_ICONEXCLAMATION)
		lGrv := .F.
	EndIf	
Else
	MessageBox("A matricula informada é inválida!","", MB_ICONEXCLAMATION)
	lGrv := .F.
EndIf
Return(lRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³ RSKVldSP8 ³ Autor ³ Rogerio Silva	        ³ Data ³11/12/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao³ Valida se Ja foi Registrado as Marcas do Funcionario       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MIR RISK                				                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RSKVldSP83(cTpEnt)
Local aAreaAnt := GetArea()
Local lRet     := .T.
SP8->(dbSetOrder(2))
If SP8->(dbSeek(xFilial("SP8")+SRA->RA_MAT+DtoS(Date()) ))
	While !SP8->(Eof()) .And. xFilial("SP8")+SRA->RA_MAT+DtoS(Date()) ==SP8->(P8_FILIAL+P8_MAT+DtoS(P8_DATA))
		If Left(DtoC(Date()),2)+cTpEnt == SP8->(P8_ORDEM+P8_TPMARCA)
			lRet := .F.
			Exit
		EndIf
		SP8->(dbSkip())
	EndDo
EndIf
RestArea(aAreaAnt)
Return(lRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³ RSKAponta ³ Autor ³ Rogerio Silva	        ³ Data ³11/12/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao³ Cria o Periodo de Apontamento                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MIR RISK				                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RSKAponta3()
Local dDtIni   := CtoD("")//StoD(Str(Year(Date()),4) + StrZero(Month(Date()),2) + "16")
Local dDtFim   := CtoD("")
Local cPeriodo := Alltrim(GetMv( "MV_PONMES") )
Local nDia    := 0
Local nDiaIni := 0
Local nDiaFim := 0

nDia    := DAY(date())
nDiaIni := Val(SubStr(cPeriodo,7,2))
nDiaFim := Val(SubStr(cPeriodo,16,2))

If nDia > nDiaIni .or. nDia = nDiaIni

	If Month(Date()) <> 12
		dDtIni := ALLTRIM(Str(Year(Date()),4)) + ALLTRIM(StrZero(Month(Date()),2)) + ALLTRIM(str(nDiaIni))
		dDtFim := ALLTRIM(Str(Year(Date()),4)) + ALLTRIM(StrZero(Month(Date()) +1,2)) + ALLTRIM(str(nDiaFim))
	Else
		dDtIni := ALLTRIM(Str(Year(Date()),4)) + ALLTRIM(StrZero(Month(Date()),2)) + ALLTRIM(str(nDiaIni))
		dDtFim := ALLTRIM(Str(Year(Date())+1,4)) + '01' + ALLTRIM(str(nDiaFim))
	EndIf	


ElseIf nDia < nDiaIni

	If (Month(Date()) -1) <> 12

		dDtIni := ALLTRIM(Str(Year(Date()),4)) + ALLTRIM(StrZero(Month(Date()) -1 ,2)) + ALLTRIM(str(nDiaIni))
		dDtFim := ALLTRIM(Str(Year(Date()),4)) + ALLTRIM(StrZero(Month(Date()),2)) + ALLTRIM(str(nDiaFim))
	Else
		dDtIni := ALLTRIM(Str(Year(Date())-1,4)) + '12' + ALLTRIM(str(nDiaIni))
		dDtFim := ALLTRIM(Str(Year(Date()),4)) + ALLTRIM(StrZero(Month(Date()),2)) + ALLTRIM(str(nDiaFim))
	EndIf	

Endif


Return(dDtIni+dDtFim)   

// ROGERIO 0004
User Function RSKREMO4(lBat)
// rogerio cfilremota guarda a filial do equipamento
//User Function RSKREMO1(lBat)

Local oSenha                    
Local aMeses   		:= { "JAN","FEV","MAR","ABR","MAI","JUN","JUL","AGO","SET","OUT","NOV","DEZ" } 
Local aSemana  		:= { "Domingo","2a. Feira","3a. Feira","4a. Feira","5a. Feira","6a. Feira","Sábado" }
Local aUsers   		:= {}
Local cMes     		:= aMeses[ Month(Date()) ]
Local cPassW   		:= ""
Local cUsuaW   		:= ""
Local cCodUsr  		:= ""
Local aParam1		:= {}
Local aRet1			:= {}
Local aParam2		:= {}
Local aRet2			:= {}
Private lGrv   	 	:= .F.
Private cTime    	:= Left(Time(),5)
Private cTpMarca 	:= ""
Private cTpSP8   	:= ""
Private oDlg
Private oFnt1    	:= TFont():New("Arial",09,12,,.T.,,,,.T.,.F.)
Private oFnt2    	:= TFont():New("Arial",11,14,,.T.,,,,.T.,.F.)
Private oFnt3    	:= TFont():New("Arial",36,39,,.T.,,,,.T.,.F.)
Private oFnt4    	:= TFont():New("Arial",10,12,,.T.,,,,.T.,.F.)
// ASSUMIR A FILIAL DO FUNCIONARIO
Private cFilRemota  := "040101"
Private CFILANT     := "040101"  
//Private cUserA      := Alltrim( SuperGetMv( "FS_USERADM", .F., "Admin" ))
//Private cPassA      := Alltrim( SuperGetMv( "FS_SENHARH", .F., "" ))    
Private aTpEnt := {}
Default lBat        := .T.
// rogerio - cfilremota guardará a filial do funcionario

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre as Tabelas e Prepara Ambiente para ser usado via JOB ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lBat
// voltar depois
//	PREPARE ENVIRONMENT EMPRESA '01' FILIAL cFilRemota USER 'admin' PASSWORD '' TABLES 'SRA,SPJ,SR8' MODULO "SIGAPON"
//	PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01' USER 'admin' PASSWORD '' TABLES 'SRA,SPJ,SR8' MODULO "SIGAPON"
	PREPARE ENVIRONMENT EMPRESA '11' FILIAL cFilRemota USER 'admin' PASSWORD 'brasil#2021!' TABLES 'SRA,SPJ,SR8' MODULO "SIGAPON"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o Tipo da Marca - Especifico RISK                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//BUSCAR O TURNO NA TABELA SPJ(TURNO) OU SR6(VALIDA TORENCIA) PELO CAMPO SRA->RA_TNOTRAB

aUsers := AllUsers(.T.)
cPassW := Space(15) //Space( Len(aUsers[1,1,3]) )
aAdd(aTpEnt , "1E" )
aAdd(aTpEnt , "1S" )
aAdd(aTpEnt , "2E" )
aAdd(aTpEnt , "2S"  )
cTpEnt := aTpEnt[1]


Define MsDialog oDlg Title "Marcação de Ponto Eletrônico - Risk Brasil" Of oMainWnd Pixel From 0,0 To 200,333 Color CLR_BLACK, CLR_WHITE
	
	@ 02,02 To 27,165 Of oDlg Pixel
	@ 05,05 Say "Matricula" 					Size  35,08 Of oDlg Pixel Font oFnt1 Color CLR_BLACK
	@ 11,05 MsGet oSenha Var cPassW PASSWORD 	Size  50,09 Of oDlg Pixel Font oFnt2 Color CLR_BLUE Valid RSKVldSen4(cPassW,@cUsuaW,@cCodUsr,@oUser)
		
	@ 05,60 Say "Usuário" 						Size  35,08 Of oDlg Pixel Font oFnt1 Color CLR_BLACK
	@ 11,60 MsGet oUser  Var cUsuaW           	Size 100,09 Of oDlg Pixel Font oFnt2 Color CLR_BLUE When .F.
	
	@ 30,02 To 60,72  Of oDlg Pixel
	@ 28,01 Say StrZero(Day(Date()),2)			Size  50,30 Of oDlg Pixel Center Font oFnt3 Color CLR_BLUE
	@ 24,32 Say cMes							Size  50,30 Of oDlg Pixel Center Font oFnt4 Color CLR_BLUE
	@ 39,32 Say Str(Year(Date()),4)			Size  50,15 Of oDlg Pixel Center Font oFnt4 Color CLR_BLUE
	@ 48,01 Say aSemana[Dow(Date())] 			Size  70,15 Of oDlg Pixel Center Font oFnt4 Color CLR_HBLUE
	
	@ 30,75 To 60,165 Of oDlg Pixel
	@ 30,76 Say cTime         					Size 87,30 Of oDlg Pixel Center Font oFnt3 Color CLR_BLUE
	
	@ 63,02 To 80,165  Of oDlg Pixel
	@ 63,07 Say "Ip Local: " Size 40,15 Of oDlg Pixel Center Font oFnt4 Color CLR_HBLUE
	@ 68,04 Say Alltrim(GetclientIP()) Size 55,15 Of oDlg Pixel Center Font oFnt4 Color CLR_HBLUE
	
	@ 63,75 To 80,165 Of oDlg Pixel
	@ 63,80 Say "Maquina: " Size 38,15 Of oDlg Pixel Center Font oFnt4 Color CLR_HBLUE
	@ 68,80 Say Alltrim(GetComputerName()) Size 80,15 Of oDlg Pixel Center Font oFnt4 Color CLR_HBLUE  
	
	@ 83,75 To 100,165 Of oDlg Pixel
	//@ 85,80 Say cTpMarca     					Size 80,15 Of oDlg Pixel Center Font oFnt4 Color CLR_HBLUE
	
	@ 83,02 To 100,72  Of oDlg Pixel
	@ 85,04 Say "Tipo Apto.: " Size 30,15 Of oDlg Pixel Center Font oFnt4 Color CLR_HBLUE
	oCombo := TComboBox():New(85,35,{|u|if(PCount()>0,cTpEnt:=u,cTpEnt)},aTpEnt,25,10,oDlg,,,,,,.T.,,,,,,,,,'cTpEnt')

	//@ 83,04 COMBOBOX oDlg VAR cTpEnt ITEMS aTpEnt SIZE 40, 013 PIXEL COLORS 0, 16777215

	Define SButton From 86,85  Type 1 Enable Of oDlg Pixel Action ( oDlg:End() )
	Define SButton From 86,118  Type 2 Enable Of oDlg Pixel Action { || oDlg:End() } 
	
	Activate MsDialog oDlg Center
	
	If lGrv
		DbSelectArea("SRA")
		DbSetOrder(1)
		If DbSeek(xFilial("SRA") + Alltrim(cPassW))
			If !Empty(SRA->RA_PASSAP)
				dbSelectArea("SP8")
				cAponta := RSKAponta4()			
				aAdd(aParam1,{8,"Entre com a senha: ",Space(10),"","","","",80,.T.})				
				If ParamBox(aParam1,"Informe a Senha para Apontamento",@aRet1,,,,,,,,.F.,.F.)
					If Alltrim(SRA->RA_PASSAP) == Alltrim(aRet1[1])
						If RSKVldSP84(cTpEnt)
							dDtAp := If(cTpEnt == "1E",Date(), SEARCHDT(SRA->RA_MAT) )
							cOrdem  := U_RSKOrdem(dDtAp)
							RecLock("SP8",.T.)
							Replace P8_FILIAL	With xFilial("SP8")				
							Replace P8_MAT		With SRA->RA_MAT					
							Replace P8_DATA		With Date() 							
							Replace P8_HORA		With Val(StrTran(cTime,":","."))	
							Replace P8_CC		With SRA->RA_CC						
							Replace P8_ORDEM	With Alltrim(cOrdem)				
							Replace P8_TURNO	With SRA->RA_TNOTRAB				
							Replace P8_FLAG		With "I"							
							Replace P8_XLOCALI  With Alltrim(GetclientIP())  		
							Replace P8_XNOMMAQ  With Alltrim(GetComputerName())		
							Replace P8_APONTA	With "N"							
							Replace P8_TPMARCA	With cTpEnt						
							Replace P8_PAPONTA	With cAponta    
							//Replace P8_RELOGIO  With //campo customizado
							Replace P8_DATAAPO  With dDtAp	
							//Replace P8_SEMANA   With //Semana do periodo
							//Replace P8_NUMREP   With SP0->SP0_REP
							Replace P8_TIPOREG With "O"
							Replace P8_EMPORG   With "11"
							Replace P8_FILORG   With xFilial("SP8")	 
							Replace P8_MATORG   With SRA->RA_MAT
							Replace P8_DATAALT  With Date() 
							Replace P8_HORAALT  With cTime
							Replace P8_USUARIO  With __cUserId //Usuário sistema                     
							MsUnLock()
							MessageBox("Apontamento registrado com sucesso!","",MB_OK)	
						Else
							MessageBox("Você já efetuou o apontamento para este horário", "", MB_ICONEXCLAMATION)
						EndIf
					Else
						MessageBox("A senha digitada esta incorreta!","",MB_ICONHAND)//MsgInfo("A senha digitada esta incorreta!")
						MessageBox("Apontamento não efetuado!", "", MB_ICONEXCLAMATION)
					EndIf
				EndIf	
			Else
				nRet := MessageBox("Você não possui senha para apontamento, na proxima tela informe uma senha com no máximo 10 caracteres, esta senha será sua e intransferivel, será utilizada para efetuar seus apontamentos, guarde-a em local seguro!","",MB_OKCANCEL)
				
				If nRet == 1
					aAdd(aParam2,{1,"Informe a senha: ",Space(10),"","","","",0,.T.}) // Tipo caractere
				
					If ParamBox(aParam2,"Cadastro de Senha para Apontamento",@aRet2,,,,,,,,.F.,.F.)

						RecLock("SRA",.F.)
						SRA->RA_PASSAP:= aRet2[1]
						MsUnlock()

						MessageBox("Senha cadastrada! Informe novamente para confirmar apontamento!","",MB_OK)

						dbSelectArea("SP8")
						cAponta := RSKAponta4()			
						aAdd(aParam1,{8,"Entre com a senha: ",Space(10),"","","","",80,.T.})				
						If ParamBox(aParam1,"Informe a Senha para Apontamento",@aRet1,,,,,,,,.F.,.F.)
							If Alltrim(SRA->RA_PASSAP) == Alltrim(aRet1[1])
								If RSKVldSP84(cTpEnt)
									dDtAp := If(cTpEnt == "1E",Date(), SEARCHDT(SRA->RA_MAT) )
									cOrdem  := U_RSKOrdem(dDtAp)
									RecLock('SP8',.T.)
									// rogerio arrumado para filial corrente	Replace P8_FILIAL	With "01"							,;
									Replace P8_FILIAL	With xFilial("SP8")					
									replace		P8_MAT		With SRA->RA_MAT					
									replace		P8_DATA		With date()							
									replace		P8_HORA		With Val(StrTran(cTime,":","."))	
									replace		P8_CC		With SRA->RA_CC						
									replace		P8_ORDEM	With Alltrim(cOrdem)				
									replace		P8_TURNO	With SRA->RA_TNOTRAB				
									replace		P8_FLAG		With "I"							
									replace		P8_APONTA	With "N"							
									replace		P8_XLOCALI  With Alltrim(getServerIP())  		
									replace		P8_XNOMMAQ  With Alltrim(GetComputerName())		
									replace		P8_TPMARCA	With cTpEnt						
									replace		P8_PAPONTA	With cAponta
									//Replace 	P8_RELOGIO  With //campo customizado
									Replace 	P8_DATAAPO  With dDtAp
									//Replace 	P8_SEMANA   With //Semana do periodo
									//Replace 	P8_NUMREP   With SP0->SP0_REP
									Replace 	P8_TIPOREG With "O"
									Replace 	P8_EMPORG   With "11"
									Replace 	P8_FILORG   With xFilial("SP8")	 
									Replace 	P8_MATORG   With SRA->RA_MAT
									Replace 	P8_DATAALT  With Date() 
									Replace 	P8_HORAALT  With cTime
									Replace 	P8_USUARIO  With __cUserId //Usuário sistema 
									MsUnLock()		
									MessageBox("Apontamento registrado com sucesso!","",MB_OK)
								Else
									MessageBox("Você já efetuou o apontamento para este horário", "", MB_ICONEXCLAMATION)
								EndIf
							Else
								MessageBox("A senha digitada esta incorreta!","",MB_ICONHAND)//MsgInfo("A senha digitada esta incorreta!")
								MessageBox("Apontamento não efetuado!", "", MB_ICONEXCLAMATION)
							EndIf
						EndIf	
					EndIf						
				EndIf							
			EndIf						
		EndIf
	EndIf
RESET ENVIRONMENT
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³ RSKVldSen ³ Autor ³ Rogerio Silva	        ³ Data ³11/12/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao³ Valida a senha do Functionario                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MIR RISK                        				          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RSKVldSen4(cPassW,cUsuaW,cCodUsr,oUser)
Local lRet  := .T.

DbSelectArea("SRA")
DbSetOrder(1)
If DbSeek(xFilial("SRA") + Alltrim(cPassW))
	cUsuaW  := Alltrim(SRA->RA_NOME)
	oUser:Refresh()
	DbSelectArea("SPJ")
	DbSetOrder(1)
	If Dbseek(xFilial("SPJ") + SRA->RA_TNOTRAB)
		If cTime >= IntToHora(SPJ->PJ_ENTRA1) .And. cTime <= IntToHora(SPJ->PJ_SAIDA1-0.01)
			cTpMarca := "1a. Entrada"
			cTpSP8   := "1E"
		EndIf
		If cTime >= IntToHora(SPJ->PJ_SAIDA1) .And. cTime <= IntToHora(SPJ->PJ_ENTRA2-0.01) //Menos 1 Minuto
			cTpMarca := "1a. Saída"  
			cTpSP8   := "1S"
		EndIf
		If cTime >= IntToHora(SPJ->PJ_ENTRA2) .And. cTime <= IntToHora(SPJ->PJ_SAIDA2-0.01) //Menos 1 Minuto
			cTpMarca := "2a. Entrada"
			cTpSP8   := "2E"
		EndIf
		If cTime >= IntToHora(SPJ->PJ_SAIDA2)
			cTpMarca := "2a. Saída"
			cTpSP8   := "2S"
		EndIf
		lGrv := .T.
		oDlg:Refresh()
	Else
		MessageBox("Turno não cadastrado, consulte o departamento pessoal!","", MB_ICONEXCLAMATION)
		lGrv := .F.
	EndIf	
Else
	MessageBox("A matricula informada é inválida!","", MB_ICONEXCLAMATION)
	lGrv := .F.
EndIf
Return(lRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³ RSKVldSP8 ³ Autor ³ Rogerio Silva	        ³ Data ³11/12/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao³ Valida se Ja foi Registrado as Marcas do Funcionario       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MIR RISK                				                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RSKVldSP84(cTpEnt)
Local aAreaAnt := GetArea()
Local lRet     := .T.
SP8->(dbSetOrder(2))
If SP8->(dbSeek(xFilial("SP8")+SRA->RA_MAT+DtoS(Date()) ))
	While !SP8->(Eof()) .And. xFilial("SP8")+SRA->RA_MAT+DtoS(Date()) ==SP8->(P8_FILIAL+P8_MAT+DtoS(P8_DATA))
		If Left(DtoC(Date()),2)+cTpEnt == SP8->(P8_ORDEM+P8_TPMARCA)
			lRet := .F.
			Exit
		EndIf
		SP8->(dbSkip())
	EndDo
EndIf
RestArea(aAreaAnt)
Return(lRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³ RSKAponta ³ Autor ³ Rogerio Silva	        ³ Data ³11/12/2017³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao³ Cria o Periodo de Apontamento                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MIR RISK				                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RSKAponta4()
Local dDtIni   := CtoD("")//StoD(Str(Year(Date()),4) + StrZero(Month(Date()),2) + "16")
Local dDtFim   := CtoD("")
Local cPeriodo := Alltrim(GetMv( "MV_PONMES") )
Local nDia    := 0
Local nDiaIni := 0
Local nDiaFim := 0

nDia    := DAY(date())
nDiaIni := Val(SubStr(cPeriodo,7,2))
nDiaFim := Val(SubStr(cPeriodo,16,2))

If nDia > nDiaIni .or. nDia = nDiaIni

	If Month(Date()) <> 12
		dDtIni := ALLTRIM(Str(Year(Date()),4)) + ALLTRIM(StrZero(Month(Date()),2)) + ALLTRIM(str(nDiaIni))
		dDtFim := ALLTRIM(Str(Year(Date()),4)) + ALLTRIM(StrZero(Month(Date()) +1,2)) + ALLTRIM(str(nDiaFim))
	Else
		dDtIni := ALLTRIM(Str(Year(Date()),4)) + ALLTRIM(StrZero(Month(Date()),2)) + ALLTRIM(str(nDiaIni))
		dDtFim := ALLTRIM(Str(Year(Date())+1,4)) + '01' + ALLTRIM(str(nDiaFim))
	EndIf	


ElseIf nDia < nDiaIni

	If (Month(Date()) -1) <> 12

		dDtIni := ALLTRIM(Str(Year(Date()),4)) + ALLTRIM(StrZero(Month(Date()) -1 ,2)) + ALLTRIM(str(nDiaIni))
		dDtFim := ALLTRIM(Str(Year(Date()),4)) + ALLTRIM(StrZero(Month(Date()),2)) + ALLTRIM(str(nDiaFim))
	Else
		dDtIni := ALLTRIM(Str(Year(Date())-1,4)) + '12' + ALLTRIM(str(nDiaIni))
		dDtFim := ALLTRIM(Str(Year(Date()),4)) + ALLTRIM(StrZero(Month(Date()),2)) + ALLTRIM(str(nDiaFim))
	EndIf	

Endif


Return(dDtIni+dDtFim)  

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³ SEARCHDT ³ Autor ³ Natalia Perioto	   ³ Data ³28/06/2021³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao³ Procura Data da 1º Entrada                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³  RISK				                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function SEARCHDT(cMat)
Local dDataApo
Local cQuery := ""
Local _cAlias		:= GetNextAlias()

cQuery := " SELECT MAX(SP8.P8_DATAAPO) AS DTREF "
cQuery += " FROM "+RetSqlName('SP8')+" SP8 "
cQuery += " WHERE SP8.P8_FILIAL = '"+xFilial("SP8")+"' "
cQuery += " AND SP8.P8_MAT      ='"+(cMat)+"'  "
cQuery += " AND SP8.D_E_L_E_T_  <> '*'  "

TCQUERY cQuery NEW ALIAS (_cAlias)

dDataApo := stod((_cAlias)->DTREF)


Return dDataApo

User Function RSKORDEM(dDiaAp)

Local nOrd    AS NUMERIC
Local nDia    AS NUMERIC
Local nUltDia AS NUMERIC
Local nStart  AS NUMERIC
Local cOrd    AS CHARACTER 

cOrd := ""
nDia    := Day(dDiaAp)
nUltDia := Last_Day(MonthSub( dDiaAp, 1 ))


If nDia >= 16

	nOrd := (nDia - 16) + 1

Else

	nStart := (nUltDia - 16) + 1
	
	nOrd := nStart + nDia 



Endif

cOrd := StrZero( nOrd, 2)

Return cOrd


