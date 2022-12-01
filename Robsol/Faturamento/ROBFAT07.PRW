#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOTVS.CH'

/*/{Protheus.doc} User Function ROBFAT07
    Tela para facilitar a inclusão de pedido de vendas para representantes
    @type  Function
    @author Diogo de Jesus Gasparini
    @since 14/11/2022
    @version 1
    @see 
    TES - 632/131
    VENDEDOR - 000059
    XCLASPV - 3
    NATUREZA - 11040005
    CONDIÇAO DE PAGAMENTO - 001
    Exemplo - 041601
    /*/
User Function ROBFAT07()

	Local nLarg
	Local nAlt
	//Local aItens2 := {'Tamanho Mala', 'Mala P', 'Mala G'}
	Local nX,nJ
	Local aRet    := {}
	Local cQuery
	Local nOpc    := 0
	Local nCont

	Private oDlg1,oGrp1,oBtn1,oBtn2,oBtn3,oBtn4,oBtn5,oBtn6,oBtn7,oList1,oList2,oList3,oComb1,oComb2,oSay1,oSay2,oSay3,oSay4
	Private aItens1        :=    {'Todos', 'Selecionados', 'Nao Selecionados'}
	Private oFont1         :=    TFont():New( 'Arial',, 20,, .T.,,,,, .T., )
	Private aList1         :=    {}
	Private aList2         :=    {}
	Private aList2B 	   :=    {}
	Private aList3         :=    {}
	Private aList3B        :=    {}
	Private cCombo1        :=    ''
	Private cCombo2        :=    ''
	Private oOk            :=    LoadBitmap(GetResources(),'br_verde')
	Private oNo            :=    LoadBitmap(GetResources(),'br_vermelho')
	//Private cMarca         :=    '1'
	Private lRet           :=    .F.
	Private lMsErroAuto    :=    .F.
	Private nQtdTot        :=    0
	Private nQtdNotas	   :=	 0
	Private nnXG1          :=    0
	Private nnXG2          :=    0
	Private aCliVnd		   := 	 {}
	Private cPedGer		   := 	''

	If Select("SM0") == 0
		RpcSetType(3)
		RPCSetEnv("01","0103")
	EndIf

	Processa({|| buscaGeren()},"Buscando Gerentes")
	Processa({|| buscaVend()},"Buscando Vendedores")
	//Processa({|| buscaProd()},"Buscando Produtos")

	cQuery := " "
	cQuery += " SELECT Z03_CODGRI FROM "+RetSQLName("Z03")
	cQuery += " WHERE Z03_FILIAL='"+xFilial("Z03")+"' AND D_E_L_E_T_=' '"
	cQuery += " AND Z03_MSBLQL<>'1'"
	
	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf

	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

	While !EOF()
		Aadd(aItens1, AllTrim(TRB->Z03_CODGRI))
		DBSKIP()
	End

	oDlg1      := MSDialog():New( 100, 200, 750, 1500, "",,, .F.,,,,,, .T.,,, .T. )
	oGrp1      := TGroup():New( 005, 005, 300, 645, "", oDlg1, CLR_BLACK, CLR_WHITE, .T., .F. )

	oList1     := TCBrowse():New( 012, 008, 190, 135,, {'', 'Codigo','Gerente','Regiao'}, {10,25,90,25},;
					oGrp1,,,, {|| Processa({|| Fhelp(oList1:nAt,1) /*buscaRepre(oList1:nAt)*/},"Aguarde")},,,,,,,,,, .T.,,,, .F., .T. )
	
	oList1:SetArray(aList1)
	oList1:bLine := {||{ 	If(aList1[oList1:nAt,01],oOk,oNo),;
							aList1[oList1:nAt,2],;
							aList1[oList1:nAt,3],;
							aList1[oList1:nAt,4]}}

	oList2     := TCBrowse():New( 012, 200, 440, 135,, {'','Codigo','Representante','Malas', 'Regioes'},,;
				 oGrp1,,,, {|| Processa({|| Fhelp(oList2:nAt,2) /*buscaProd(oList2:nAt)*/},"Aguarde")},;
				 			{|| editcol(oList2:nAt)},,,,,,,,, .T.,,,, .F., .T. )
	
	oList2:SetArray(aList2)
	oList2:bLine := {||{	If(aList2[oList2:nAt,01],oOk,oNo),;
								aList2[oList2:nAt,2],;
								aList2[oList2:nAt,3],;
								aList2[oList2:nAt,4],;
								aList2[oList2:nAt,5]}}

	oList3     := TCBrowse():New( 150, 008, 550, 145,, {'', 'Codigo', 'Descricao', 'Saldo 3', 'Saldo Estoque', 'Preco UN', 'Nota', 'Data de Emissao'}, {,,200,,},;
				 oGrp1,,,,, {|| selecProd(oList3:nAt)},,,,,,,,, .T.,,,, .F., .T. )
	
	oList3:SetArray(aList3)
	oList3:bLine := {||{ 	If(aList3[oList3:nAt,01],oOk,oNo),;
								aList3[oList3:nAt,2],;
								aList3[oList3:nAt,3],;
								aList3[oList3:nAt,4],;
								aList3[oList3:nAt,5],;
								aList3[oList3:nAt,6],;
								aList3[oList3:nAt,11],;
								SubStr(aList3[oList3:nAt,9], 7, 2) + "/" + SubStr(aList3[oList3:nAt,9], 5, 2) + "/" + SubStr(aList3[oList3:nAt,9],1,4)}}

	nLarg  := 052*1.5
	nAlt   := 012*1.5
	nLinha := 128

	//oComb1     := TComboBox():New( nLinha+26, 510, {|u| IF( PCount() > 0, cCombo1 := u, cCombo1 )}, aItens1, nLarg-25, nAlt, oGrp1,, {|| filtraLista()},, CLR_BLACK, CLR_WHITE, .T.,, "",,,,,,, )
	//oComb2     := TComboBox():New( nLinha+51, 510, {|u| IF( PCount() > 0, cCombo2 := u, cCombo2 )}, aItens2, nLarg-25, nAlt, oGrp1,,  {|| tipoDeMala()},, CLR_BLACK, CLR_WHITE, .T.,, "",,,,,,, )

	oBtn1      := TButton():New( nLinha+25,   564,  "Ok",                   oGrp1, {|| oDlg1:end(nOpc:=1)},      nLarg,    nAlt,,,,.T.,,"",,,,.F. )
	oBtn2      := TButton():New( nLinha+50,   564,  "Marcar Todos", 		oGrp1, {|| marcaTodos()},            nLarg,    nAlt,,,,.T.,,"",,,,.F. )
	oBtn7      := TButton():New( nLinha+75,   564,  "Excel",	            oGrp1, {|| fExcel()},       		 nLarg,    nAlt,,,,.T.,,"",,,,.F. )
	oBtn5      := TButton():New( nLinha+100,  564,  "Ir ao Início",         oGrp1, {|| oList3:GoTop()},          nLarg,    nAlt,,,,.T.,,"",,,,.F. )
	oBtn6      := TButton():New( nLinha+125,  564,  "Ir ao Fim",            oGrp1, {|| oList3:GoBottom()},       nLarg,    nAlt,,,,.T.,,"",,,,.F. )
	oBtn4      := TButton():New( nLinha+150,  564,  "Sair",                 oGrp1, {|| oDlg1:end(nOpc:=0)},      nLarg,    nAlt,,,,.T.,,"",,,,.F. )

	oSay1:= TSay():New( nLinha+180, 10, {||'Quantidade total de produtos: '}, oDlg1,,      ,,,, .T., CLR_BLACK,, 200, 20 )
	oSay2:= TSay():New( nLinha+177, 85, {||''},                               oDlg1,,oFont1,,,, .T., CLR_BLACK,, 200, 20 )
	oSay3:= TSay():New( nLinha+180, 140, {||'Quantidade de notas: '}, oDlg1,,      ,,,, .T., CLR_BLACK,, 200, 20 )
	oSay4:= TSay():New( nLinha+177, 195, {||''},                               oDlg1,,oFont1,,,, .T., CLR_BLACK,, 200, 20 )

	oDlg1:Activate( ,,, .T. )

	if nOpc == 1
		
		aPergs := {}
		aPefil := {}

		aAdd(aPergs,{2,"Filial do pedido?","3", {"1=0101","2=0102","3=0103"},80,'',.T.})

		If !ParamBox(aPergs ,"Parametros ",aPefil)
			cCodFil := '0103'
		Else
			cCodFil := aPefil[1]
		EndIf

		BEGIN TRANSACTION
		
		for nX := 1 to len(aList2)
			if aList2[nX,1]
				aRet := {}
				nQtdTot := 0
				nQtdNotas := 0

				Aadd(aRet, aList2[nX])
				for nJ := 1 to len(aList3B)
					if aList3B[nJ,1] .And. Alltrim(aList2[nX,06]) == Alltrim(aList3B[nJ,10])
						Aadd(aRet, aList3B[nJ])
						nQtdTot += aList3B[nJ,04]
					endif
				next nJ

				nQtdNotas := round(nQtdTot / 480,0)

				If len(aRet) > 1
					aCabitm := {}
					aAuxItm := {}
					Aadd(aCabitm,aRet[1])

					For nCont := 2 to len(aRet)
						Aadd(aAuxItm,aRet[nCont])
						If mod(len(aAuxItm),480) == 0
							Processa({|| geraPV(aCabitm,aAuxItm,cCodFil)}, "Gerando Pedido de Venda Nº" + CValToChar(nCont-1) + " Vendedor "+aList2[nX,03]+"...")
							aAuxItm := {}
						EndIf 
					Next nCont

					If len(aAuxItm) > 0
						Processa({|| geraPV(aCabitm,aAuxItm,cCodFil)}, "Gerando Ultimo Pedido de Venda Vendedor "+aList2[nX,03]+"...")
						aAuxItm := {}
					EndIf 
				EndIf 
			endif
		next nX 

		END TRANSACTION

		If !Empty(cPedGer)
			MsgAlert("Pedidos Gerados"+CRLF+cPedGer)
		EndIf 

	endif

Return

/*/{Protheus.doc} Fhelp
	(long_description)
	@type  Static Function
	@author user
	@since 22/11/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function Fhelp(nLinha,nOpc)

Local aArea := GetArea()
Local nCont 

nQtdTot := 0
nQtdNotas := 0

If nOpc == 1
	aList2 := {}
	aList3 := {}
Else 
	aList3 := {}
EndIf 

If nOpc == 1
	For nCont := 1 to len(aList2B)
		If aList2B[nCont,09] == aList1[nLinha,02]
			Aadd(aList2,aList2B[nCont])
		EndIf 
	Next nCont
EndIF 

If len(aList2) < 1
	Aadd(aList2,{.F.,'','','',''})
Else 
	If nOpc == 1
		nLinha := 1
	ENDIF

	nPosB3	:=	Ascan(aList3B,{|x| Alltrim(x[10]) == Alltrim(aList2[nLinha,06])})
	If nPosB3 == 0
		Processa({|| buscaProd(aList2[nLinha,06])},"Aguarde")
	EndIf 
	//EndIf 

	For nCont := 1 to len(aList3B)
		If aList2[nLinha,06] == aList3B[nCont,10] .Or. Empty(aList3B[nCont,10])
			Aadd(aList3,aList3B[nCont])
		EndIf 
	Next nCont 

	If len(aList3) < 1
		Aadd(aList3,{.F.,'','','','','','','','','',''})
	EndIF 
ENDIF

oList2:SetArray(aList2)
oList2:bLine := {||{If(aList2[oList2:nAt,01],oOk,oNo),;
					aList2[oList2:nAt,2],;
					aList2[oList2:nAt,3],;
					aList2[oList2:nAt,4],;
					aList2[oList2:nAt,5]}}

oList3:SetArray(aList3)
oList3:bLine := {||{ 	If(aList3[oList3:nAt,01],oOk,oNo),;
						aList3[oList3:nAt,2],;
						aList3[oList3:nAt,3],;
						aList3[oList3:nAt,4],;
						aList3[oList3:nAt,5],;
						aList3[oList3:nAt,6],;
						aList3[oList3:nAt,11],;
						SubStr(aList3[oList3:nAt,9], 7, 2) + "/" + SubStr(aList3[oList3:nAt,9], 5, 2) + "/" + SubStr(aList3[oList3:nAt,9],1,4)}}

If nOpc == 1
	oList2:nAt := 1
EndIf 

Asort(aList3,,,{|x,y| X[7]+x[2] < Y[7]+y[2]})

oList3:nAt := 1

Aeval(aList3,{|x| nQtdTot += If(x[1],x[4],0)})

nQtdNotas := round(nQtdTot / 480,0)

oSay2:SetText("")
oSay2:SetText(nQtdTot)
oSay4:SetText("")
oSay4:SetText(nQtdNotas)

oList2:refresh()
oList3:refresh()
oDlg1:refresh()

RestArea(aArea)
	
Return

/*/{Protheus.doc} editcol
	(long_description)
	@type  Static Function
	@author user
	@since 22/11/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function editcol(nLinha)

Local aArea :=	GetArea()

If aList2[nLinha,01]
	aList2[nLinha,01] := .F.
Else 
	aList2[nLinha,01] := .T.
EndIf 

nPos := Ascan(aList2B,{|x| x[2] == aList2[nLinha,02]})

If nPos > 0
	aList2B[nPos,01] := aList2[nLinha,01]
EndIF 

oList2:refresh()
oDlg1:refresh()

RestArea(aArea)
	
Return

/*/{Protheus.doc} buscaGeren
	(long_description)
	@type  Static Function
	@author user
	@since 22/11/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function buscaGeren()

	Local cQuery := ''

	cQuery := " "
	cQuery += " SELECT SA3.A3_COD,Z30.Z30_CODVEN,Z30.Z30_CODGER,SA3.A3_NOME,Z30.Z30_MALA,Z30.Z30_REGIAO "
	cQuery += " FROM " + RetSQLName("SA3") + " SA3 "
	cQuery += " LEFT JOIN " + RetSQLName("Z30") + " Z30 ON Z30.Z30_FILIAL=SA3.A3_FILIAL AND Z30.Z30_CODVEN = SA3.A3_COD AND Z30.D_E_L_E_T_=' ' "
	cQuery += " WHERE SA3.A3_FILIAL='"+xFilial("SA3")+"' AND SA3.A3_XFUNCAO = '2' AND SA3.D_E_L_E_T_=' '"

	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf

	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

	While !EOF()
		Aadd(aList1, { 	.F.,;
						TRB->A3_COD,;
						AllTrim(TRB->A3_NOME),;
						AllTrim(TRB->Z30_REGIAO)})
		DBSKIP()
	End

Return

/*/{Protheus.doc} buscaVend
	(long_description)
	@type  Static Function
	@author user
	@since 22/11/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/

Static Function buscaVend()

	Local cQuery := ''
	
	cQuery := " "
	cQuery += " SELECT DISTINCT SA3.A3_COD,Z30.Z30_CODVEN,Z30.Z30_CODGER,"
	cQuery += " SA3.A3_NOME,Z30.Z30_MALA,Z30.Z30_REGIAO,SA1.A1_COD,"
	cQuery += " SA1.A1_LOJA,SA1.A1_TIPO,Z30.Z30_CODGER "
	cQuery += " FROM   " + RetSQLName("SA3") + " SA3 "
	cQuery += " INNER JOIN " + RetSQLName("Z30") + " Z30 ON Z30.Z30_FILIAL='"+xFilial("Z30")+"' AND SA3.A3_COD = Z30.Z30_CODVEN AND Z30.D_E_L_E_T_=' ' "
	cQuery += " INNER JOIN " + RetSQLName("SA1") + " SA1 ON SA1.A1_FILIAL = SA3.A3_FILIAL AND SA1.A1_CGC = SA3.A3_CGC AND SA1.D_E_L_E_T_=' '"
	cQuery += " WHERE SA3.A3_FILIAL = '" + xFilial("SA3") + "'" // AND Z30.Z30_CODGER = '"+ cGeren +"' "
	cQuery += " AND  SA1.A1_TIPO = 'R' "
	cQuery += " AND  SA3.A3_XFUNCAO <> '2' "
	cQuery += " AND  SA3.A3_MSBLQL <> '1' "
	cQuery += " AND  Z30.Z30_MALA <> ' ' "
	cQuery += " AND  SA3.D_E_L_E_T_=' '"

	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf

	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

	While !EOF()
		If Ascan(aCliVnd,{|x| Alltrim(x) == Alltrim(TRB->A1_COD)}) == 0
			Aadd(aCliVnd,TRB->A1_COD)
		EndIf 

		Aadd(aList2b, { 	.F.,;						//1
						TRB->A3_COD,;					//2
						AllTrim(TRB->A3_NOME),;			//3
						AllTrim(TRB->Z30_MALA),;		//4
						AllTrim(TRB->Z30_REGIAO),;		//5
						TRB->A1_COD,;					//6
						TRB->A1_LOJA,;					//7
						TRB->A1_TIPO,;					//8
						TRB->Z30_CODGER})				//9
		DBSKIP()
	End

Return

/*/{Protheus.doc} buscaRepre
	(long_description)
	@type  Static Function
	@author user
	@since 22/11/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/

Static Function buscaRepre(nLinha)

	Local cQuery := ''
	Local cGeren := aList1[nLinha,2]
	
	aList2 := {}

	cQuery := " "
	cQuery += " SELECT DISTINCT SA3.A3_COD,Z30.Z30_CODVEN,Z30.Z30_CODGER,SA3.A3_NOME,Z30.Z30_MALA,Z30.Z30_REGIAO,SA1.A1_COD,SA1.A1_LOJA,SA1.A1_TIPO "
	cQuery += " FROM   " + RetSQLName("SA3") + " SA3 "
	cQuery += " INNER JOIN " + RetSQLName("Z30") + " Z30 ON Z30.Z30_FILIAL='"+xFilial("Z30")+"' AND SA3.A3_COD = Z30.Z30_CODVEN AND Z30.D_E_L_E_T_=' ' "
	cQuery += " INNER JOIN " + RetSQLName("SA1") + " SA1 ON SA1.A1_FILIAL = SA3.A3_FILIAL AND SA1.A1_CGC = SA3.A3_CGC AND SA1.D_E_L_E_T_=' '"
	cQuery += " WHERE SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND Z30.Z30_CODGER = '"+ cGeren +"' "
	cQuery += " AND  SA1.A1_TIPO = 'R' "
	cQuery += " AND  SA3.A3_XFUNCAO <> '2' "
	cQuery += " AND  SA3.A3_MSBLQL <> '1' "
	cQuery += " AND  Z30.Z30_MALA <> ' ' "
	cQuery += " AND  SA3.D_E_L_E_T_=' '"

	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf

	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

	While !EOF()
		Aadd(aList2, { 	.F.,;
						TRB->A3_COD,;
						AllTrim(TRB->A3_NOME),;
						AllTrim(TRB->Z30_MALA),;
						AllTrim(TRB->Z30_REGIAO),;
						TRB->A1_COD,;
						TRB->A1_LOJA,;
						TRB->A1_TIPO})
		DBSKIP()
	End

	If aList1[nLinha,1]
		aList1[nLinha,1] := .F.
	Else
		aList1[nLinha,1] := .T.
	EndIf

	Aeval(aList1,{|x| x[1] := If(Alltrim(x[2])<>Alltrim(aList1[nLinha,02]),.f.,.t.)})

	oList1:SetArray(aList1)
	oList1:bLine := {||{If(aList1[oList1:nAt,01],oOk,oNo),;
						aList1[oList1:nAt,2],;
						aList1[oList1:nAt,3],;
						aList1[oList1:nAt,4]}}

	oList1:Refresh()

	oList2:SetArray(aList2)
	oList2:bLine := {||{If(aList2[oList2:nAt,01],oOk,oNo),;
						aList2[oList2:nAt,2],;
						aList2[oList2:nAt,3],;
						aList2[oList2:nAt,4],;
						aList2[oList2:nAt,5]}}

	oList2:Refresh()
	oDlg1:refresh()

Return

/*/{Protheus.doc} buscaProd
	(long_description)
	@type  Static Function
	@author user
	@since 22/11/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function buscaProd(cCli)

	Local cQuery    :=  ""
	
	cQuery := " "
	cQuery += " SELECT BM_XMODELO,B1_COD,B1_DESC,B2_QATU,B1_PRV1,BM_XMODELO,B1_LOCPAD,B6_SALDO,B6_PRUNIT,B6_DOC,B6_EMISSAO,B6_CLIFOR "+CRLF
	cQuery += " FROM " + RetSQLName("SB6") + " SB6 "+CRLF
	cQuery += " INNER JOIN " + RetSQLName("SB1") + " SB1 ON B1_FILIAL = '" + xFilial("SB1") + "' AND B6_PRODUTO = B1_COD AND SB1.B1_MSBLQL <> '1' AND SB1.D_E_L_E_T_ = ' '"+CRLF
	cQuery += " INNER JOIN " + RetSQLName("SBM") + " SBM ON BM_FILIAL = '" + xFilial("SBM") + "' AND BM_GRUPO = B1_GRUPO AND SBM.D_E_L_E_T_=' '"+CRLF
	cQuery += " INNER JOIN " + RetSQLName("SB2") + " SB2 ON B2_FILIAL = B6_FILIAL AND B2_COD = B1_COD AND B2_LOCAL = B6_LOCAL AND SB2.D_E_L_E_T_=' '"+CRLF
	cQuery += " WHERE " 
	//"B6_CLIFOR = '" + aList2[nLinha,6] + "'"
	cQuery += " B6_CLIFOR = '"+cCli+"'"

	cQuery += " AND B6_TIPO = 'E' AND B6_SALDO > '0' "+CRLF
	cQuery += " AND B6_PODER3 = 'R' "+CRLF
	cQuery += " AND B6_FILIAL = '" + xFilial("SB6") + "' "+CRLF
	cQuery += " AND SB6.D_E_L_E_T_ = ' ' "+CRLF
	cQuery += " ORDER BY B1_COD "+CRLF

	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf
	

	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

	While !EOF()
		nPosAux := Ascan(aList3B,{|x| Alltrim(x[2])+Alltrim(x[10]) == Alltrim(TRB->B1_COD)+Alltrim(TRB->B6_CLIFOR)}) 
		if nPosAux == 0
			Aadd(aList3B, { 	.T.,;					//1
							AllTrim(TRB->B1_COD),;		//2
							AllTrim(TRB->B1_DESC),;		//3
							TRB->B6_SALDO,;				//4
							TRB->B2_QATU,;				//5
							TRB->B6_PRUNIT,;			//6
							TRB->BM_XMODELO,;			//7
							TRB->B1_LOCPAD,;			//8
							TRB->B6_EMISSAO,;			//9
							TRB->B6_CLIFOR,;			//10
							TRB->B6_DOC})     			//11

		else
			aList3B[nPosAux,04] += TRB->B6_SALDO
		endif

		DBSKIP()
	End

	cQuery := " "

	cQuery += " SELECT SB1.B1_COD, SB1.B1_DESC, SB2.B2_QATU,SB1.B1_PRV1,SBM.BM_XMODELO,SB1.B1_LOCPAD "
	cQuery += " FROM " + RetSQLName("SB1") + " SB1 "
	cQuery += " INNER JOIN " + RetSQLName("SBM") + " SBM ON SB1.B1_FILIAL = SBM.BM_FILIAL AND SB1.B1_GRUPO = SBM.BM_GRUPO AND SBM.D_E_L_E_T_=' '"
	cQuery += " INNER JOIN " + RetSQLName("SB2") + " SB2 ON SB2.B2_FILIAL = '" + xFilial("SB2") + "' AND SB1.B1_COD = SB2.B2_COD AND B2_LOCAL = B1_LOCPAD AND SB2.D_E_L_E_T_=' '"
	cQuery += " WHERE SB2.B2_QATU > '50' AND SB2.B2_LOCAL = '101' "
	cQuery += " AND SB1.B1_PRV1 > '0' "
	cQuery += " AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' "
	cQuery += " AND SB1.B1_MSBLQL <> '1' "
	cQuery += " AND SB1.D_E_L_E_T_=' '"
	cQuery += " ORDER BY SB1.B1_COD "

	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf
	
	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

	While !EOF()
		if Ascan(aList3B,{|x| Alltrim(x[2]) == Alltrim(TRB->B1_COD)}) == 0
			Aadd(aList3B, { 	.F.,;
							AllTrim(TRB->B1_COD),;
							AllTrim(TRB->B1_DESC),;
							0001,;
							TRB->B2_QATU,;
							TRB->B1_PRV1,;
							TRB->BM_XMODELO,;
							TRB->B1_LOCPAD,;
							"",;
							cCli,;
							""})
		endif
		DBSKIP()
	End

Return

/*/{Protheus.doc} selecProd
	(long_description)
	@type  Static Function
	@author user
	@since 22/11/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function selecProd(nLinha)

	Local nX
	Local nPos
	Local nColPos := oList3:nColpos
	Local cBkpCol := aList3[nLinha,nColPos]

	if nColPos == 4
		leditcell(aList3,oList3,'@E 9,999',4)
		if !(aList3[nLinha,4] == cBkpCol)
			if aList3[nLinha,4] > aList3[nLinha,5]
				aList3[nLinha,4] := aList3[nLinha,5]
			endif

			aList3[nLinha,1] := .T.

			for nX := 1 to len(aList3B)
				if AScan(aList3B[nX], aList3[nLinha,2]) > 0
					nPos := AScan(aList3B[nX], aList3[nLinha,2])
					aList3B[nX] := aList3[nLinha]
				endif
			next
		endif
    elseif nColPos == 6
        leditcell(aList3,oList3,'@E 9,999.99',6)
		if !(aList3[nLinha,6] == cBkpCol)
			aList3[nLinha,1] := .T.

			for nX := 1 to len(aList3B)
				if AScan(aList3B[nX], aList3[nLinha,2]) > 0
					nPos := AScan(aList3B[nX], aList3[nLinha,2])
					aList3B[nX] := aList3[nLinha]
				endif
			next
		endif
	else
		if aList3[nLinha,1] == .T.
			aList3[nLinha,1] := .F.
			for nX := 1 to len(aList3B)
				if AScan(aList3B[nX], aList3[nLinha,2]) > 0
					nPos := AScan(aList3B[nX], aList3[nLinha,2])
					aList3B[nX] := aList3[nLinha]
				endif
			next
		else
			aList3[nLinha,1] := .T.
			for nX := 1 to len(aList3B)
				if AScan(aList3B[nX], aList3[nLinha,2]) > 0
					nPos := AScan(aList3B[nX], aList3[nLinha,2])
					aList3B[nX] := aList3[nLinha]
				endif
			next
		endif
	endif

	oList3:SetArray(aList3)
	oList3:bLine := {||{If(aList3[oList3:nAt,01],oOk,oNo),;
						aList3[oList3:nAt,2],;
						aList3[oList3:nAt,3],;
						aList3[oList3:nAt,4],;
						aList3[oList3:nAt,5],;
						aList3[oList3:nAt,6],;
						aList3[oList3:nAt,11],;
						SubStr(aList3[oList3:nAt,9], 7, 2) + "/" + SubStr(aList3[oList3:nAt,9], 5, 2) + "/" + SubStr(aList3[oList3:nAt,9],1,4)}}
	
	oList3:Refresh()

	//qtdTot()

Return
/*/{Protheus.doc} marcaTodos
	(long_description)
	@type  Static Function
	@author user
	@since 22/11/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function marcaTodos()

	Local nX

	for nX := 1 to len(aList3)
		If !aList3[nX,1]
			aList3[nX,1] := .T.
		EndIf 
		nPos := Ascan(aList3B,{|x| Alltrim(x[2]) == Alltrim(aList3[nX,02])})
		If nPos > 0
			aList3B[nPos,01] := aList3[nX,1] //.T.
		EndIf
	next

	oList3:SetArray(aList3)
	oList3:bLine := {||{If(aList3[oList3:nAt,01],oOk,oNo),;
						aList3[oList3:nAt,2],;
						aList3[oList3:nAt,3],;
						aList3[oList3:nAt,4],;
						aList3[oList3:nAt,5],;
						aList3[oList3:nAt,6],;
						aList3[oList3:nAt,11],;
						SubStr(aList3[oList3:nAt,9], 7, 2) + "/" + SubStr(aList3[oList3:nAt,9], 5, 2) + "/" + SubStr(aList3[oList3:nAt,9],1,4)}}
	
	oList3:Refresh()

	nQtdTot := 0
	nQtdNotas := 0

	Aeval(aList3,{|x| nQtdTot += If(x[1],x[4],0)})

	nQtdNotas := round(nQtdTot / 480,0)

	oSay2:SetText("")
	oSay2:SetText(nQtdTot)
	oSay4:SetText("")
	oSay4:SetText(nQtdNotas)

	oList3:refresh()
	oDlg1:refresh()

Return

/*/{Protheus.doc} filtraLista
	(long_description)
	@type  Static Function
	@author user
	@since 22/11/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function filtraLista()

	Local nX

	aList3 := {}

	if cCombo1 == 'Todos'
		aList3 := aList3B
	elseif cCombo1 == 'Selecionados'
		for nX := 1 to len(aList3B)
			if aList3B[nX,1]
				Aadd(aList3, aList3B[nX])
			endif
		next
	elseif cCombo1 == 'Nao Selecionados'
		for nX := 1 to len(aList3B)
			if !aList3B[nX,1]
				Aadd(aList3, aList3B[nX])
			endif
		next
	else
		for nX := 1 to len(aList3B)
			if aList3B[nX,7] == cCombo1
				Aadd(aList3, aList3B[nX])
			endif
		next
	endif

	oList3:SetArray(aList3)
	oList3:bLine := {||{If(aList3[oList3:nAt,01],oOk,oNo),;
						aList3[oList3:nAt,2],;
						aList3[oList3:nAt,3],;
						aList3[oList3:nAt,4],;
						aList3[oList3:nAt,5],;
						aList3[oList3:nAt,6],;
						aList3[oList3:nAt,11],;
						SubStr(aList3[oList3:nAt,9], 7, 2) + "/" + SubStr(aList3[oList3:nAt,9], 5, 2) + "/" + SubStr(aList3[oList3:nAt,9],1,4)}}
	
	oList3:Refresh()

	//qtdTot()

Return

/*/{Protheus.doc} geraPV
	(long_description)
	@type  Static Function
	@author user
	@since 22/11/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function geraPV(aRet,aItQb,cFilGer)

	Local aArea     :=    GetArea()
	Local aCabec    :=    {}
	Local aItens    :=    {}
	Local aLinha    :=    {}
	Local cDoc      :=    GetSxeNum("SC5", "C5_NUM")
	Local nPos        :=    1
	//Local nPos      :=    3
	Local cItem     :=    '01'
	Local cPathL    :=    'C:\Temp\'
	//Local cValid

	aadd(aCabec, { "C5_NUM"     ,cDoc       ,Nil })
	aadd(aCabec, { "C5_TIPO"    ,"N"        ,Nil })
	aadd(aCabec, { "C5_CLIENTE" ,aRet[1,6]  ,Nil })
	aadd(aCabec, { "C5_LOJACLI" ,aRet[1,7]  ,Nil })
	aadd(aCabec, { "C5_EMISSAO" ,dDatabase  ,Nil }) // Data de emissao
	aadd(aCabec, { "C5_TIPOCLI" ,aRet[1,8]  ,Nil }) // Tipo de cliente
	aadd(aCabec, { "C5_TIPOPV"  ,'1'        ,Nil })
	aadd(aCabec, { "C5_MOEDA"   ,1          ,Nil }) // Moeda
	aadd(aCabec, { "C5_CONDPAG" ,'001'      ,Nil })
	aadd(aCabec, { "C5_NATUREZ" ,"11040005" ,Nil })
	aadd(aCabec, { "C5_VEND1"   ,"000059"   ,Nil })
	aadd(aCabec, { "C5_XCLASPV" ,"3"        ,Nil })

	FOR nPos := 1 to len(aItQb)

		aLinha := {}

		aadd(aLinha,{ "C6_ITEM"    ,cItem        ,Nil })
		aadd(aLinha,{ "C6_PRODUTO" ,aItQb[nPos,2] ,Nil })
		aadd(aLinha,{ "C6_QTDVEN"  ,aItQb[nPos,4] ,Nil })
		aadd(aLinha,{ "C6_PRCVEN"  ,aItQb[nPos,6] ,Nil })
		aadd(aLinha,{ "C6_PRUNIT"  ,aItQb[nPos,6] ,Nil })
		aadd(aLinha,{ "C6_TES"     ,'632'        ,Nil })
		aadd(aLinha,{ "C6_LOCAL"   ,aItQb[nPos,8] ,Nil })

		cItem := Soma1(cItem)
		aadd(aItens, aLinha)

	NEXT nPos

	lMsErroAuto := .F.

	MSExecAuto({|a, b, c| MATA410(a, b, c)}, aCabec, aItens, 3)

	If lMsErroAuto
		MostraErro(cPathL,"01_erro.txt")
		RollbackSXE()
		ConOut("Erro na inclusão!")
		lRet := .F.
	Else
		ConOut("Incluído com sucesso! " + cDoc)
		//ConfirmSX8()
		cPedGer += cDoc + " / "
		lRet := .T.
	EndIf

	RestAreA(aArea)

Return

/*/{Protheus.doc} geraPDEeDE
	(long_description)
	@type  Static Function
	@author user
	@since 22/11/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function geraPDEeDE(aRet)

	Local nX
	Local nPos        := 3
	Local cItem       := '01'
	Local aCabec      := {}
	Local aItens      := {}
	Local aLinha      := {}
	Local lMsErroAuto := .F.
	Local cDoc        := GetSxeNum("SF1","F1_DOC")
	Local cValid

	// [2]aList2 [1].F. [2]TRB->A3_COD [3]AllTrim(TRB->A3_NOME) [4]AllTrim(TRB->Z30_MALA) [5]AllTrim(TRB->Z30_REGIAO) [6]TRB->A1_COD [7]TRB->A1_LOJA [8]TRB->A1_TIPO
	// [3+]aList3 [1].F. [2]AllTrim(TRB->B1_COD) [3]AllTrim(TRB->B1_DESC) [4]0001 [5]TRB->B2_QATU [6]TRB->B1_PRV1 [7]TRB->BM_XMODELO [8]TRB->B1_LOCPAD

	aAdd( aCabec, {'F1_TIPO'    ,'N'       ,NIL} )
	aAdd( aCabec, {'F1_FORMUL'  ,'N'       ,NIL} )
	aAdd( aCabec, {'F1_DOC'     ,cDoc      ,NIL} )
	aAdd( aCabec, {"F1_SERIE"   ,"01"      ,NIL} )
	aAdd( aCabec, {"F1_EMISSAO" ,dDataBase ,NIL} )
	aAdd( aCabec, {'F1_FORNECE' ,aRet[2,6] ,NIL} )
	aAdd( aCabec, {'F1_LOJA'    ,aRet[2,7] ,NIL} )
	aAdd( aCabec, {"F1_ESPECIE" ,"NF"      ,NIL} )
	aAdd( aCabec, {"F1_COND"    ,'001'     ,NIL} )
	aAdd( aCabec, {"F1_STATUS"  ,''        ,NIL} )

	cValid := SubStr(aRet[nPos,2], 1, 2)

	if nnXG2 != 0
		nnXG2 := nnXG2 - 3
	endif

	For nX := 3 to Len(aRet)

		nPos := nnXG2 + nX

		if nPos > len(aRet) .OR. cValid != SubStr(aRet[nPos,2], 1, 2)
			if cValid == "MA"
			else
				EXIT
			endif
		endif

		aItens := {}

		aAdd( aItens ,{'D1_ITEM'  ,cItem                     ,NIL} )
		aAdd( aItens ,{'D1_COD'   ,aRet[nPos,2]              ,NIL} )
		aAdd( aItens ,{"D1_QUANT" ,aRet[nPos,4]              ,Nil} )
		aAdd( aItens ,{"D1_VUNIT" ,aRet[nPos,6]              ,Nil} )
		aAdd( aItens ,{"D1_TOTAL" ,aRet[nPos,4]*aRet[nPos,6] ,Nil} )
		aAdd( aItens ,{"D1_TES"   ,'632'                     ,NIL} )

		cItem := Soma1(cItem)
		aAdd( aLinha ,aItens )

		cValid := SubStr(aRet[nnXG2 + nX,2], 1, 2)

	NEXT nX

	nnXG2 += nX

	// lMsErroAuto := .F.

	// MSExecAuto( {|x,y,z,a,b| MATA140(x,y,z,a,b)} ,aCabec ,aLinha ,3 , , )

	// If lMsErroAuto
	//     MostraErro(cPathL,"02_erro.txt")
	// Else
	//     MsgInfo("Pré - Documento de Entrada concluído com sucesso!", "Êxito!")
	// EndIf

	lMsErroAuto := .F.

	MSExecAuto( {|x,y,z| MATA103(x,y,z)} ,aCabec ,aLinha ,3 )

	If lMsErroAuto
		MostraErro(cPathL,"03_erro.txt")
	Else
		MsgInfo("Documento de Entrada concluído com sucesso!", "Êxito!")
	EndIf

Return

/*/{Protheus.doc} qtdTot
	(long_description)
	@type  Static Function
	@author user
	@since 22/11/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function qtdTot()

	Local nX
	Local nY
	Local nProd
	Local nAux
	Local nAux1

	nQtdNotas := 0

	for nX := 4 to len(aItens1)

		nProd := 0

		for nY := 1 to len(aList3B)
			if aList3B[nY,1] .AND. aList3B[nY,7] == aItens1[nX]
				nProd++
			endif
		next

		nAux  := nProd / 487
		nAux1 := Round(nProd / 487, 0)

		if nAux > nAux1 .AND. nProd != 0
			nAux1++
		endif

		nQtdNotas += nAux1

	next

	oSay4:SetText(nQtdNotas)
	oSay4:CtrlRefresh()

	nQtdTot := 0

	for nX := 1 to len(aList3B)
		if aList3B[nX,1]
			nQtdTot += aList3B[nX,4]
		endif
	next

	oSay2:SetText(nQtdTot)
	oSay2:CtrlRefresh()

Return

/*/{Protheus.doc} tipoDeMala
	(long_description)
	@type  Static Function
	@author user
	@since 22/11/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function tipoDeMala()

	Local cQuery := ""
	Local nX
	Local aAux   := {}
	Local aAux2  := {}

	if Upper(cCombo2) == "MALA P"
		nAux := 2
	elseif Upper(cCombo2) == "MALA G"
		nAux := 1
	else
		//buscaProd(oList2:nAt)
        aList2[oList2:nAt,1] := .T.
        
        oList2:SetArray(aList2)
        oList2:bLine := {||{If(aList2[oList2:nAt,01],oOk,oNo),;
            aList2[oList2:nAt,2],;
            aList2[oList2:nAt,3],;
            aList2[oList2:nAt,4],;
            aList2[oList2:nAt,5],;
            aList2[oList2:nAt,6]}}
        oList2:Refresh()

        qtdTot()
		RETURN
	endif

	cQuery := " "
	cQuery += " SELECT B1_COD,B1_DESC,B1_LOCPAD,B2_QATU,B1_PRV1 FROM SB1010 "
	cQuery += " INNER JOIN SB2010 ON B2_FILIAL = '" + xFilial("SB2") + "' AND B2_COD = B1_COD "
	cQuery += " WHERE B1_COD IN ('MALA', 'MALA P') "
	cQuery += " AND B1_FILIAL = '" + xFilial("SB1") + "' "
	cQuery += " AND B2_QATU > '0' "

	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf

	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

	While !EOF()
		Aadd(aAux, { .T., AllTrim(TRB->B1_COD), AllTrim(TRB->B1_DESC), 1, TRB->B2_QATU, 000000, "",TRB->B1_LOCPAD,"",""})
		DBSKIP()
	End

	if nAux == 1
		Aadd(aAux2, aAux[1])
	else
		Aadd(aAux2, aAux[2])
	endif

	for nX := 1 to len(aList3B)
		Aadd(aAux2, aList3B[nX])
	next

	aList3B := aAux2
    aList3  := aList3B

	oList3:SetArray(aList3)
	oList3:bLine := {||{If(aList3[oList3:nAt,01],oOk,oNo),;
							aList3[oList3:nAt,2],;
							aList3[oList3:nAt,3],;
							aList3[oList3:nAt,4],;
							aList3[oList3:nAt,5],;
							aList3[oList3:nAt,6],;
							aList3[oList3:nAt,11],;
							SubStr(aList3[oList3:nAt,9], 7, 2) + "/" + SubStr(aList3[oList3:nAt,9], 5, 2) + "/" + SubStr(aList3[oList3:nAt,9],1,4)}}
	
	oList3:Refresh()

	//qtdTot()
    
Return

/*/{Protheus.doc} fExcel()
	(long_description)
	@type  Static Function
	@author user
	@since 22/11/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function fExcel()

Local oExcel 	:= FWMSEXCEL():New()
//Local cTitulo 	:= "Conferencia Comissao"
Local cDir 		:= ""
Local nX 
Local cArqXls 	:= "conferencia_"+dtos(ddatabase)+strtran(time(),":")+".xls" 

cDir := cGetFile(, OemToAnsi("Selecione o diretório de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 

If Empty(cDir)
	Return
EndIf

oExcel:AddworkSheet("Conferencia") 

oExcel:AddTable ("Conferencia","Representantes")

oExcel:AddColumn("Conferencia","Representantes","Mala",1,1)        //01
oExcel:AddColumn("Conferencia","Representantes","Descricao",1,1)            //02
oExcel:AddColumn("Conferencia","Representantes","Saldo Terc",1,1)      //10
oExcel:AddColumn("Conferencia","Representantes","Saldo Est",1,1)      //10
oExcel:AddColumn("Conferencia","Representantes","Preco",1,1)      //10
oExcel:AddColumn("Conferencia","Representantes","Emissao",1,1)      //10

For nX := 1 to len(aList3)
	If aList3[nX,01]
		oExcel:AddRow("Conferencia","Representantes",{  aList3[nX,02],;
														aList3[nX,03],;
														aList3[nX,04],;
														aList3[nX,05],;
														aList3[nX,06],;
														aList3[nX,07]})
	EndIf
Next nX

oExcel:Activate()

oExcel:GetXMLFile(cDir +cArqXls)

WinExec('Explorer.exe /select,"' + substr(cDir,1,len(cDir)-1) + '"', 1)

oExcelApp := MsExcel():New()
oExcelApp:Destroy()

Return
