#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "COMXFUN.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "rwmake.ch"

/*/{Protheus.doc} GFR002
Tela de consulta produto pai x filho
@type function
@version  
@author Group377
@since 07/06/2024
@return variant, return_description
/*/

User function GFR002()
Local nCod      := aScan( aHeaIns, { |x| AllTrim( Upper( x[2] ) ) == 'TL_CODIGO'  } )
Local nLocal    := aScan( aHeaIns, { |x| AllTrim( Upper( x[2] ) ) == 'TL_LOCAL'  } ) 
Local nDesc    := aScan( aHeaIns, { |x| AllTrim( Upper( x[2] ) ) == 'TL_NOMCODI'  } ) 
Local cProduto  := ""
Local cAlmox    := ""

Private oMark
Private oListBox1

	If ALLTRIM(M->TL_TIPOREG) == "P" .and. nCod <> 0 .and. nLocal <> 0
		cProduto := M->TL_CODIGO
		cAlmox   := M->TL_LOCAL

		cAlias	:= GetNextAlias()
		BeginSql Alias cAlias
			SELECT * FROM %Table:SB1% B1 
			WHERE B1.%NotDel%
			AND B1_XCODPAI = ' '
			AND B1_COD = %Exp:cProduto%
		EndSql 

		dbSelectArea(cAlias)
		(cAlias)->(DbGoTop())

		If !(cAlias)->(Eof())
			If MaView(@cProduto,,@cAlmox)
				oGet:aCOLS[oGet:nAt,nCod] 	:= cProduto
				oGet:aCOLS[oGet:nAt,nLocal] := cAlmox
				oGet:aCOLS[oGet:nAt,nDesc] := POSICIONE("SB1",1,XFILIAL("SB1")+cProduto,"B1_DESC")
				M->TL_CODIGO := cProduto
				M->TL_LOCAL	 := cAlmox
			Endif
		EndIf 

	Endif

Return .T.

Static Function MaView(cProduto,cFilCon,cAlmox)

	Local aArea		:= GetArea()
	Local aAreaSB1	:= SB1->(GetArea())
	Local aAreaSB2	:= SB2->(GetArea())
	Local aAreaSM0	:= SM0->(GetArea())
	Local aViewB2	:= {}
	Local _aViewB2 := {}
	Local aStruSB2  := {}
	Local aNewSaldo := {}
	Local nTotDisp	:= 0
	Local nSaldo	:= 0
	Local nQtPV		:= 0
	Local nQemp		:= 0
	Local nSalpedi	:= 0
	Local nReserva	:= 0
	Local nQempSA	:= 0
	Local nSaldoSB2:=0
	Local nQtdTerc :=0
	Local nQtdNEmTerc:=0
	Local nSldTerc :=0
	Local nQEmpN :=0
	Local nQAClass :=0
	Local nQEmpPrj  := 0
	Local nQEmpPre  := 0
	Local nX        := 0
	Local nB2_QATU  := 0,nB2_QPEDVEN := 0,nB2_QEMP := 0,nB2_SALPEDI := 0,nB2_QEMPSA := 0,nB2_RESERVA :=0
	Local nB2_QTNP  := 0,nB2_QNPT := 0,	nB2_QTER := 0,nB2_QEMPN := 0,nB2_QACLASS := 0,nB2_QPRJ := 0, nB2_QPRE := 0
	Local cArqQRB
	Local nI

	Local cFilialSB2:= xFilial("SB2")
	Local cFilialSB1:= xFilial("SB1")
	Local lViewSB2  := .T.
	Local nAtIni    := 1
	Local nHdl      := GetFocus()
	Local aCampos	:= {}
	Local lRet      := .f.

	Static lViewSB2PE
	Static lViewSaldo

	DEFAULT cAlmox := ""

	Private oListBox, oDlg, oBold
	
//                                                                        Ŀ
//  Verifica a filial de pesquisa do saldo                                  
//                                                                          
	If !Empty(cFilCon)
		If !Empty(cFilialSB2)
			cFilialSB2 := cFilCon
		EndIf
		dbSelectArea("SM0")
		dbSetOrder(1)
		MsSeek(cEmpAnt+cFilCon)
	EndIf

//                                                                        Ŀ
//  Posiciona o cadastro de produtos                                        
//                                                                          
	dbSelectArea('SB1')
	dbSetOrder(1)
	If MsSeek(cFilialSB1+cProduto) .And. lViewSB2
		cCursor  := "MAVIEWSB2"
		lQuery   := .T.
		aStruSB2 := SB2->(dbStruct())

		cQuery := ""
		cQuery += "SELECT * FROM "+RetSqlName("SB2")+" WHERE "
		cQuery += "B2_FILIAL='"+cFilialSB2+"' AND "
		cQuery += "B2_COD = '"+cProduto+"' AND "
		cQuery += "B2_STATUS <> '2' AND "
		cQuery += "D_E_L_E_T_ = ' ' "
		cQuery += "ORDER BY B2_LOCAL "

		cQuery := ChangeQuery(cQuery)

		SB2->(dbCommit())

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cCursor,.T.,.T.)

		For nX := 1 To Len(aStruSB2)
			If aStruSB2[nX][2]<>"C"
				TcSetField(cCursor,aStruSB2[nX][1],aStruSB2[nX][2],aStruSB2[nX][3],aStruSB2[nX][4])
			EndIf
		Next nX

		dbSelectArea(cCursor)
		While ( !Eof() )

			nSaldoSB2:=SaldoSB2(,,,,,cCursor)

			nB2_QATU    := (cCursor)->B2_QATU
			nB2_QPEDVEN := (cCursor)->B2_QPEDVEN
			nB2_QEMP    := (cCursor)->B2_QEMP
			nB2_SALPEDI := (cCursor)->B2_SALPEDI
			nB2_QEMPSA  := (cCursor)->B2_QEMPSA
			nB2_RESERVA := (cCursor)->B2_RESERVA
			nB2_QTNP    := (cCursor)->B2_QTNP
			nB2_QNPT    := (cCursor)->B2_QNPT
			nB2_QTER    := (cCursor)->B2_QTER
			nB2_QEMPN   := (cCursor)->B2_QEMPN
			nB2_QACLASS := (cCursor)->B2_QACLASS
			nB2_QPRJ 	:= (cCursor)->B2_QEMPPRJ
			nB2_QPRE 	:= (cCursor)->B2_QEMPPRE

			If lViewSaldo
				aNewSaldo := {}
				aAdd(aNewSaldo,{nSaldoSB2,nB2_QATU,nB2_QPEDVEN,nB2_QEMP,nB2_SALPEDI,nB2_QEMPSA,nB2_RESERVA,nB2_QTNP,;
					nB2_QNPT,nB2_QTER,nB2_QEMPN,nB2_QACLASS,nB2_QPRJ,nB2_QPRE})

				If ValType(aNewSaldo:=ExecBlock("MVIEWSALDO",.F.,.F.,{(cCursor)->B2_COD,(cCursor)->B2_LOCAL,aNewSaldo}))=="A" .And. Len(aNewSaldo) > 0
					nSaldoSB2   := aNewSaldo[1,1]
					nB2_QATU    := aNewSaldo[1,2]
					nB2_QPEDVEN := aNewSaldo[1,3]
					nB2_QEMP    := aNewSaldo[1,4]
					nB2_SALPEDI := aNewSaldo[1,5]
					nB2_QEMPSA  := aNewSaldo[1,6]
					nB2_RESERVA := aNewSaldo[1,7]
					nB2_QTNP    := aNewSaldo[1,8]
					nB2_QNPT    := aNewSaldo[1,9]
					nB2_QTER    := aNewSaldo[1,10]
					nB2_QEMPN   := aNewSaldo[1,11]
					nB2_QACLASS := aNewSaldo[1,12]
					nB2_QPRJ    := aNewSaldo[1,13]
					nB2_QPRE    := aNewSaldo[1,14]
				Endif
			EndIf

			aAdd(aViewB2,{TransForm((cCursor)->B2_LOCAL,PesqPict("SB2","B2_LOCAL")),;
				TransForm(nSaldoSB2,PesqPict("SB2","B2_QATU")),;
				TransForm(nB2_QATU,PesqPict("SB2","B2_QATU")),;
				TransForm(nB2_QPEDVEN,PesqPict("SB2","B2_QPEDVEN")),;
				TransForm(nB2_QEMP,PesqPict("SB2","B2_QEMP")),;
				TransForm(nB2_SALPEDI,PesqPict("SB2","B2_SALPEDI")),;
				TransForm(nB2_QEMPSA,PesqPict("SB2","B2_QEMPSA")),;
				TransForm(nB2_RESERVA,PesqPict("SB2","B2_RESERVA")),;
				TransForm(nB2_QTNP,PesqPict("SB2","B2_QTNP")),;
				TransForm(nB2_QNPT,PesqPict("SB2","B2_QNPT")),;
				TransForm(nB2_QTER,PesqPict("SB2","B2_QTER")),;
				TransForm(nB2_QEMPN,PesqPict("SB2","B2_QEMPN")),;
				TransForm(nB2_QACLASS,PesqPict("SB2","B2_QACLASS")),;
				TransForm(nB2_QPRJ,PesqPict("SB2","B2_QEMPPRJ")),;
				TransForm(nB2_QPRE,PesqPict("SB2","B2_QEMPPRE"))})

			cAlias	:= GetNextAlias()
			BeginSql Alias cAlias
				SELECT
					B1_COD,
					B1_DESC,
					B2_LOCAL,
					B1_XCODPAI,
					B2_QATU,
					B2_QPEDVEN,
					B2_QEMP,
					B2_SALPEDI,
					B2_QEMPSA,
					B2_RESERVA,
					B2_QTNP,
					B2_QNPT,
					B2_QTER,
					B2_QEMPN,
					B2_QACLASS,
					B2_QEMPPRJ,
					B2_QEMPPRE
				FROM 
					%Table:SB1% B1 
				INNER JOIN 
					%Table:SB2% B2 
					ON B2_COD = B1_COD 
					AND B2_FILIAL = %Exp:cFilAnt%
					AND B2.%NotDel% 
				WHERE 
					B1.%NotDel% AND
					B1_XCODPAI = %Exp:cProduto%
				ORDER BY
					B1_COD
			EndSql 
			
			dbSelectArea(cAlias)
			(cAlias)->(DbGoTop())

				While !(cAlias)->(Eof()).and. ALLTRIM((cAlias)->B1_XCODPAI) == ALLTRIM(cProduto)

					//IF SB2->(DBSEEK( XFILIAL("SB2")+ ALLTRIM((cAlias)->B1_COD) ))
						aAdd(_aViewB2,{(cAlias)->B1_COD,;
							(cAlias)->B1_DESC,;
							(cAlias)->B2_LOCAL,;
							(cAlias)->B2_QATU,;
							(cAlias)->B2_QATU,;
							(cAlias)->B2_QPEDVEN,;
							(cAlias)->B2_QEMP,;
							(cAlias)->B2_SALPEDI,;
							(cAlias)->B2_QEMPSA,;
							(cAlias)->B2_RESERVA,;
							(cAlias)->B2_QTNP,;
							(cAlias)->B2_QNPT,;
							(cAlias)->B2_QTER,;
							(cAlias)->B2_QEMPN,;
							(cAlias)->B2_QACLASS,;
							(cAlias)->B2_QEMPPRJ,;
							(cAlias)->B2_QEMPPRE})
					//ENDIF
					(cAlias)->(DBSKIP())
					cProduto := ALLTRIM((cAlias)->B1_XCODPAI)
				ENDDO
			_nAtIni := Len(_aViewB2)

			If !Empty(cAlmox) .And. cAlmox == (cCursor)->B2_LOCAL
				nAtIni := Len(aViewB2)
			EndIf

			nTotDisp	+= nSaldoSB2
			nSaldo		+= nB2_QATU
			nQtPV		+= nB2_QPEDVEN
			nQemp		+= nB2_QEMP
			nSalpedi	+= nB2_SALPEDI
			nReserva	+= nB2_RESERVA
			nQempSA		+= nB2_QEMPSA
			nQtdTerc	+= nB2_QTNP
			nQtdNEmTerc	+= nB2_QNPT
			nSldTerc	+= nB2_QTER
			nQEmpN		+= nB2_QEMPN
			nQAClass	+= nB2_QACLASS
			nQEmpPrj    += nB2_QPRJ
			nQEmpPre    += nB2_QPRE
			dbSelectArea(cCursor)
			dbSkip()
		EndDo
		If lQuery
			dbSelectArea(cCursor)
			dbCloseArea()
			dbSelectArea("SB2")
		EndIf

		If !Empty(aViewB2)

			DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
			DEFINE MSDIALOG oDlg FROM 000,000  TO 700,600 TITLE STR0045 Of oMainWnd PIXEL //"Saldos em Estoque"
			@ 023,004 To 24,296 Label "" of oDlg PIXEL
			@ 113,004 To 114,296 Label "" of oDlg PIXEL
			oListBox := TWBrowse():New( 30,2,297,39,,{STR0046,STR0047,STR0048,STR0049,STR0050,STR0051,STR0052,STR0053,RetTitle("B2_QTNP"),RetTitle("B2_QNPT"),RetTitle("B2_QTER"),RetTitle("B2_QEMPN"),RetTitle("B2_QACLASS"),RetTitle("B2_QEMPPRJ"),RetTitle("B2_QEMPPRE")},{17,55,55,55,55,55,55,55},oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)  //"Local"###"Qtd.Disponivel"###"Sld.Atual"###"Qtd.Pedido de Vendas"###"Qtd. Empenhada"###"Qtd. Prevista Entrada"###"Qtd.Empenhada S.A."###"Qtd. Reservada"
			oListBox:SetArray(aViewB2)
			oListBox:bLine := { || aViewB2[oListBox:nAT]}
			oListBox:nAt   := Max(1,nAtIni)

			If !Empty(_aViewB2)

				oListBox1 := TWBrowse():New( 70,2,297,129,,{"Cod Prod Filho","Nome Prod Filho",STR0046,STR0047,STR0048,STR0049,STR0050,STR0051,STR0052,STR0053,RetTitle("B2_QTNP"),RetTitle("B2_QNPT"),RetTitle("B2_QTER"),RetTitle("B2_QEMPN"),RetTitle("B2_QACLASS"),RetTitle("B2_QEMPPRJ"),RetTitle("B2_QEMPPRE")},{17,55,55,55,55,55,55,55},oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)  //"Local"###"Qtd.Disponivel"###"Sld.Atual"###"Qtd.Pedido de Vendas"###"Qtd. Empenhada"###"Qtd. Prevista Entrada"###"Qtd.Empenhada S.A."###"Qtd. Reservada"
				oListBox1:SetArray(_aViewB2)
				oListBox1:bLine := { || _aViewB2[oListBox1:nAT]}
				oListBox1:nAt   := Max(1,nAtIni)

				AAdd(aCampos,{"TR_OK"  	,"C",TamSX3("E2_OK")[1],0})//Este campo ser  usado para marcar/desmarcar
				AAdd(aCampos,{"TR_PRODFIL","C",TamSX3("B2_COD")[1],0}) 
				AAdd(aCampos,{"TR_NOMPRD","C",TamSX3("B1_DESC")[1],0}) 
				AAdd(aCampos,{"TR_LOCAL","C",	TamSX3("B2_LOCAL")[1]	,0}) 
				AAdd(aCampos,{"TR_QTDISP","N",	TamSX3("B2_QATU")[1]	,0}) 
				AAdd(aCampos,{"TR_SLDAT","N",	 TamSX3("B2_QEMPPRE")[1],0})
				AAdd(aCampos,{"TR_QTDPED","N",	 TamSX3("B2_QEMPPRJ")[1],0})
				AAdd(aCampos,{"TR_QEMP","N",	 TamSX3("B2_QACLASS")[1],0})
				AAdd(aCampos,{"TR_SALPED","N",	 TamSX3("B2_QEMPN")[1],0})
				AAdd(aCampos,{"TR_QEMPSA","N",	 TamSX3("B2_QTER")[1],0}) 
				AAdd(aCampos,{"TR_RESERV","N",	 TamSX3("B2_QNPT")[1],0})
				AAdd(aCampos,{"TR_QTNP","N",	 TamSX3("B2_QTNP")[1],0})
				AAdd(aCampos,{"TR_QNPT","N",	 TamSX3("B2_RESERVA")[1],0})
				AAdd(aCampos,{"TR_QTER","N",	TamSX3("B2_QEMPSA")[1],0})
				AAdd(aCampos,{"TR_QEMPN","N",	 TamSX3("B2_SALPEDI")[1],0})
				AAdd(aCampos,{"TR_QACLASS","N",	 TamSX3("B2_QEMP")[1],0})
				AAdd(aCampos,{"TR_QEMPPRJ","N",	 TamSX3("B2_QPEDVEN")[1],0})
				AAdd(aCampos,{"TR_QEMPPRE","N",	 TamSX3("B2_QATU")[1],0})
 
				If (Select("QRB") > 0)
					dbSelectArea("QRB")
					QRB->(dbCloseArea())
				Endif

				cArqQRB   :=  FWOpenTemp("QRB",aCampos)

				for nI := 1 to len (_aViewB2)
					If RecLock("QRB",.t.)
						QRB->TR_OK    		:= "  "
						QRB->TR_PRODFIL 	:= 	_aViewB2[nI][01]
						QRB->TR_NOMPRD 		:=	_aViewB2[nI][02]
						QRB->TR_LOCAL	 	:= 	_aViewB2[nI][03]
						QRB->TR_QTDISP 		:= 	_aViewB2[nI][04]
						QRB->TR_SLDAT	 	:= 	_aViewB2[nI][05]
						QRB->TR_QTDPED 		:= 	_aViewB2[nI][06]
						QRB->TR_QEMP	 	:= 	_aViewB2[nI][07]
						QRB->TR_SALPED 		:= 	_aViewB2[nI][08]
						QRB->TR_QEMPSA 		:= 	_aViewB2[nI][09]
						QRB->TR_RESERV		:=	_aViewB2[nI][10]
						QRB->TR_QTNP		:=	_aViewB2[nI][11]
						QRB->TR_QNPT		:=	_aViewB2[nI][12]
						QRB->TR_QTER		:=	_aViewB2[nI][13]
						QRB->TR_QEMPN		:=	_aViewB2[nI][14]
						QRB->TR_QACLASS		:=	_aViewB2[nI][15]
						QRB->TR_QEMPPRJ		:=	_aViewB2[nI][16]
						QRB->TR_QEMPPRE		:=	_aViewB2[nI][17]
						MsUnLock()
					Endif
				Next nI


				oMark := FWMarkBrowse():New()
				oMark:SetAlias("QRB") //Indica o alias da tabela que ser  utilizada no Browse
				oMark:SetFieldMark("TR_OK") //Indica o campo que dever  ser atualizado com a marca no registro
				oMark:SetOwner( oListBox1 )
				oMark:SetAmbiente(.T.) //Habilita a utiliza  o da funcionalidade Ambiente no Browse
				oMark:SetTemporary() //Indica que o Browse utiliza tabela tempor ria
				oMark:SetMenuDef( '' )
				oMark:IsInvert( .T. )
				oMark:DisableDetails()
				oMark:SetIgnoreARotina(.T.)
				oMark:SetWalkThru(.F.)
				oMark:SetValid({|| VldQtd() })
				//oMark:SetAfterMark({|| VldQtd(_aViewB2) })

				oMark:SetColumns(MCFG006TIT("TR_PRODFIL"	,"Cod Prod Filho"		,02,PesqPict("SB1","B2_COD"))		,1,020,0)
				oMark:SetColumns(MCFG006TIT("TR_NOMPRD"	,"Nome Prod Filho"		,03,PesqPict("SB2","B1_DESC"))		,1,040,0)
				oMark:SetColumns(MCFG006TIT("TR_LOCAL"	,STR0046				,04,PesqPict("SB2","B2_LOCAL"))		,1,016,0)
				oMark:SetColumns(MCFG006TIT("TR_QTDISP"	,STR0047				,05,PesqPict("SB2","B2_QATU"))		,1,016,0)
				oMark:SetColumns(MCFG006TIT("TR_SLDAT"	,STR0048				,06,PesqPict("SB2","B2_QATU"))	,1,016,0)
				oMark:SetColumns(MCFG006TIT("TR_QTDPED"	,STR0049				,07,PesqPict("SB2","B2_QPEDVEN"))		,1,016,0)
				oMark:SetColumns(MCFG006TIT("TR_QEMP"		,STR0050				,08,PesqPict("SB2","B2_QEMP"))	,1,016,0)
				oMark:SetColumns(MCFG006TIT("TR_SALPED"	,STR0051				,09,PesqPict("SB2","B2_SALPEDI"))	,1,016,0)
				oMark:SetColumns(MCFG006TIT("TR_QEMPSA"	,STR0052				,10,PesqPict("SB2","B2_QEMPSA"))	,1,016,0)
				oMark:SetColumns(MCFG006TIT("TR_RESERV"	,STR0053				,11,PesqPict("SB2","B2_RESERVA"))		,1,016,0)
				oMark:SetColumns(MCFG006TIT("TR_QTNP"		,RetTitle("B2_QTNP")	,12,PesqPict("SB2","B2_QTNP"))		,1,016,0)
				oMark:SetColumns(MCFG006TIT("TR_QNPT"		,RetTitle("B2_QNPT")	,13,PesqPict("SB2","B2_QNPT"))		,1,016,0)
				oMark:SetColumns(MCFG006TIT("TR_QTER"		,RetTitle("B2_QTER")	,14,PesqPict("SB2","B2_QTER"))		,1,016,0)
				oMark:SetColumns(MCFG006TIT("TR_QEMPN"	,RetTitle("B2_QEMPN")	,15,PesqPict("SB2","B2_QEMPN"))	,1,016,0)
				oMark:SetColumns(MCFG006TIT("TR_QACLASS"	,RetTitle("B2_QACLASS")	,16,PesqPict("SB2","B2_QACLASS"))	,1,016,0)
				oMark:SetColumns(MCFG006TIT("TR_QEMPPRJ"	,RetTitle("B2_QEMPPRJ")	,17,PesqPict("SB2","B2_QEMPPRJ"))	,1,016,0)
				oMark:SetColumns(MCFG006TIT("TR_QEMPPRE"	,RetTitle("B2_QEMPPRE"),18,PesqPict("SB2","B2_QEMPPRE"))	,1,016,0)
				oMark:SetColumns(MCFG006TIT("TR_OK"		,""						,01,PesqPict("SE2","E2_OK"))		,0,002,0)
				
				//oMark:bAllMark := { || MCFG6Invert(oMark:Mark(),lMarcar := !lMarcar ), oMark:Refresh(.T.)  }
									
				oMark:Activate()
			EndIf

			@ 004,010 SAY SM0->M0_CODIGO+"/"+FWCodFil()+" - "+SM0->M0_FILIAL+"/"+SM0->M0_NOME  Of oDlg PIXEL SIZE 245,009
			@ 014,010 SAY Alltrim(cProduto)+ " - "+SB1->B1_DESC Of oDlg PIXEL SIZE 245,009 FONT oBold
			//@ 104,010 SAY STR0054 Of oDlg PIXEL SIZE 30 ,9 FONT oBold  //"TOTAL "

			@ 205,007 SAY STR0055 of oDlg PIXEL //"Quantidade Disponivel    "
			@ 204,075 MsGet nTotDisp Picture PesqPict("SB2","B2_QATU") of oDlg PIXEL SIZE 070,009 When .F.

			@ 205,155 SAY STR0059 of oDlg PIXEL //"Quantidade Empenhada "
			@ 204,223 MsGet nQemp Picture PesqPict("SB2","B2_QEMP") of oDlg PIXEL SIZE 070,009 When .F.

			@ 220,007 SAY STR0056 of oDlg PIXEL //"Saldo Atual   "
			@ 219,075 MsGet nSaldo Picture PesqPict("SB2","B2_QATU") of oDlg PIXEL SIZE 070,009 When .F.

			@ 220,155 SAY STR0060 of oDlg PIXEL //"Qtd. Entrada Prevista"
			@ 219,223 MsGet nSalPedi Picture PesqPict("SB2","B2_SALPEDI") of oDlg PIXEL SIZE 070,009 When .F.

			@ 235,007 SAY STR0057 of oDlg PIXEL //"Qtd. Pedido de Vendas  "
			@ 234,075 MsGet nQtPv Picture PesqPict("SB2","B2_QPEDVEN") of oDlg PIXEL SIZE 070,009 When .F.

			@ 235,155 SAY STR0061 of oDlg PIXEL //"Qtd. Reservada  "
			@ 234,223 MsGet nReserva Picture PesqPict("SB2","B2_RESERVA") of oDlg PIXEL SIZE 070,009 When .F.

			@ 250,007 SAY STR0058 of oDlg PIXEL //"Qtd. Empenhada S.A."
			@ 249,075 MsGet nQEmpSA Picture PesqPict("SB2","B2_QEMPSA") of oDlg PIXEL SIZE 070,009 When .F.

			@ 250,155 SAY RetTitle("B2_QTNP") of oDlg PIXEL
			@ 249,223 MsGet nQtdTerc Picture PesqPict("SB2","B2_QTNP") of oDlg PIXEL SIZE 070,009 When .F.

			@ 265,007 SAY RetTitle("B2_QNPT") of oDlg PIXEL
			@ 264,075 MsGet nQtdNEmTerc Picture PesqPict("SB2","B2_QNPT") of oDlg PIXEL SIZE 070,009 When .F.

			@ 265,155 SAY RetTitle("B2_QTER") of oDlg PIXEL
			@ 264,223 MsGet nSldTerc Picture PesqPict("SB2","B2_QTER") of oDlg PIXEL SIZE 070,009 When .F.

			@ 280,007 SAY RetTitle("B2_QEMPN") of oDlg PIXEL
			@ 279,075 MsGet nQEmpN Picture PesqPict("SB2","B2_QEMPN") of oDlg PIXEL SIZE 070,009 When .F.

			@ 280,155 SAY RetTitle("B2_QACLASS") of oDlg PIXEL
			@ 279,223 MsGet nQAClass Picture PesqPict("SB2","B2_QACLASS") of oDlg PIXEL SIZE 070,009 When .F.

			@ 295,007 SAY RetTitle("B2_QEMPPRJ") of oDlg PIXEL
			@ 294,075 MsGet nQEmpPrj Picture PesqPict("SB2","B2_QEMPPRJ") of oDlg PIXEL SIZE 070,009 When .F.

			@ 295,155 SAY RetTitle("B2_QEMPPRE") of oDlg PIXEL
			@ 294,223 MsGet nQEmpPre Picture PesqPict("SB2","B2_QEMPPRE") of oDlg PIXEL SIZE 070,009 When .F.

			@ 321,194  BUTTON "Confirmar" SIZE 045,010  FONT oDlg:oFont ACTION retorna()  OF oDlg PIXEL  //"Voltar"
			@ 321,244  BUTTON STR0016 SIZE 045,010  FONT oDlg:oFont ACTION (oDlg:End())  OF oDlg PIXEL  //"Voltar"

			ACTIVATE MSDIALOG oDlg CENTERED
		EndIf
	EndIf

	IF QRB->TR_OK <> NIL
		QRB->(DBGotop())
		Do While !QRB->(Eof())
			If !Empty(Alltrim(QRB->TR_OK))
				cProduto := QRB->TR_PRODFIL
				cAlmox   := QRB->TR_LOCAL
				lRet     := .t.
				Exit
			Endif
			QRB->(DBSkip())
		EndDo
	EndIf 
	RestArea(aAreaSM0)
	RestArea(aAreaSB2)
	RestArea(aAreaSB1)
	RestArea(aArea)
	SetFocus(nHdl)

Return lRet

Static Function retorna()

	Private cPara := ""

	IF QRB->TR_OK <> NIL
		QRB->( DbGoTop() )
		nCont:=0
		While !QRB->(Eof())
			If !Empty(QRB->TR_OK)  //Se diferente de vazio,   porque foi marcado
				cPara += Alltrim(QRB->TR_PRODFIL)
				nCont++
			Endif
			QRB->( dbSkip() )
		EndDo

		if nCont == 0
			Alert("Selecione pelo menos um produto!")
			return
		Endif
	else 
		cProduto := M->TL_CODIGO  
	EndIf 
	
	oDlg:End()

Return 

/*
Static Function SelectOne(oMark, aArquivo)
	aArquivo[oMark:nAt,1] := !aArquivo[oMark:nAt,1]
	oMark:Refresh()
Return .T.


Static Function SelectAll(oMark, nCol, aArquivo)
	Local _ni := 1
	For _ni := 1 to len(aArquivo)
		aArquivo[_ni,1] := lMarker
	Next
	oMark:Refresh()
	lMarker:=!lMarker
Return .T.
*/
Static Function VldQtd()

	Local lRet := .T.
	local nReg       := 0

	nReg := QRB->(Recno())
	
	QRB->(DBGOTOP())
	While !QRB->(Eof())
		If QRB->(Recno()) <> nReg
			RECLOCK("QRB",.F.)
				QRB->TR_OK := ' '
			QRB->(MSUNLOCK())
		EndIf 
		QRB->(dbSkip())
	EndDo

	oMark:oBrowse:Refresh()
	QRB->(dbGoTo(nReg))
	
Return lRet


//Fun  o para criar as colunas do grid
Static Function MCFG006TIT(cCampo,cTitulo,nArrData,cPicture,nAlign,nSize,nDecimal)
    Local aColumn
    Local bData 	:= {||}
    Default nAlign 	:= 1
    Default nSize 	:= 20
    Default nDecimal:= 0
    Default nArrData:= 0  
        
    If nArrData > 0
        bData := &("{||" + cCampo +"}") 
    EndIf
    
  
 
    aColumn := {cTitulo,bData,,cPicture,nAlign,nSize,nDecimal,.F.,{||.T.},.F.,{||.T.},NIL,{||.T.},.F.,.F.,{}}
Return {aColumn}
