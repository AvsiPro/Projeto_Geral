#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} U_BRINTGCT
Rotina para fazer a medição de contrato Utlizando WEBSERVICE
@author TOTVS NU
@since 02/07/2020
/*/
User Function BRINTGCT()
	Private cAliasCTR	:= GetNextAlias()
	Private aRotina		:= MENUDEF()
	Private cCadastro	:= OEMTOANSI("Medição de Contratos")
	Private cMsgBRSYST	:= ''
	Private cMsgPROTHE	:= ''
	Private Ltemqtd		:= .F.
	Private cTipo1		:= GetMv("BR_TPQMIN")
	Private cTipo2		:= GetMv("BR_TPEFV")
	Private cTipo3		:= GetMv("BR_TPFIXA")
	Public lAuto		:= .F.

	DbSelectArea("CN9")
	DbSelectArea("CNA")
	DbSelectArea("CNB")
	DbSelectArea("SA1")

	MBROWSE( 6, 1,22,75,"CN9",,,,,,)
	
Return( .T. )

/*/{Protheus.doc} MENUDEF
Definição do Menu
@author TOTVS NU
@since 02/07/2020
/*/
Static Function MENUDEF()
	Local aRotina := { 	{ OEMTOANSI("Pesquisar") , "AxPesqui"   , 0 , 1 ,,.F. },;
		{ OEMTOANSI("Periodo")   , "U_BRFILGCT" , 0 , 2       },;
		{ OEMTOANSI("Visualizar"), "U_BRVISGCT" , 0 , 3       } }
Return( aRotina )

/*/{Protheus.doc} BRFILGCT
Função para InFormar o Periodo da Medição
@author TOTVS NU
@since 02/07/2020
/*/
USER Function BRFILGCT(cAlias,nReg,nOpcx)
	Local oPanel := nil
	Local oDlg   := nil
	Local nOpca  := 0
	Local nX     := 0

	Private dDataDe   := CTOD( SPACE(08) )
	Private dDataAte  := CTOD( SPACE(08) )
	Private cContratD := Space(15)
	Private cContratA := Space(15)
	Private cTrbCTR   := "TRBCTR" 	//GetNextAlias()
	Private cNomeARQ  := ""
	Private cArqIND   := ""
	Private oTmpCTR   := nil
	Private aStrBRW   := {}
	Private aCposBRW  := {}
	Private aCposCTR  := {}
	Private oCheckBo1
	Private lSimula := .F.

	Private aRelat	:= {}

	Private cWorkSheet 	:= 'PreFat'
	Private cTable     	:= 'Previa_Faturamento'
	Private oExcel     	:= Nil
	Private cPath      	:= GetTempPath()
	Private cNameFile  	:= cPath + "REL"+DtoS(dDataBase)+StrTran(Time(),":","")+".XML"

	//Monta Tela de Parametros
	define MSDIALOG oDlg from 022,009 to 210,540 TITLE OEMTOANSI("InForme o Periodo da Medição") pixel STYLE DS_MODALFRAME

	oDlg:lMaximized := .F.
	oDlg:lEscClose  := .F.

	oPanel := TPANEL():NEW(0,0,'',oDlg,, .T., .T.,, ,20,20)
	oPanel:Align := CONTROL_ALIGN_ALLCLIENT

	@ 006, 005 to 078, 223 of oPanel pixel

	@ 012, 012 SAY OEMTOANSI("Data De ") SIZE 55, 07 of oPanel pixel
	@ 012, 066 SAY OEMTOANSI("Data Até") SIZE 55, 07 of oPanel pixel

	@ 022, 012 MSGET dDataDe  Valid If( !Empty(dDataDe),.T.,.F.)		                     SIZE 50, 11 of oPanel pixel HASBUTTON
	@ 022, 066 MSGET dDataAte Valid If( !Empty(dDataAte) .and. dDataAte >= dDataDe ,.T.,.F.) SIZE 50, 11 of oPanel pixel HASBUTTON

	@ 042, 012 SAY OEMTOANSI("Contrato De: ") SIZE 55, 07 of oPanel pixel
	@ 042, 066 SAY OEMTOANSI("Contrato Até") SIZE 55, 07 of oPanel pixel

	@ 052, 012 MSGET cContratD  SIZE 50, 11  F3 "CN9" of oPanel pixel HASBUTTON
	@ 052, 066 MSGET cContratA  SIZE 50, 11  F3 "CN9" of oPanel pixel HASBUTTON

	@ 025, 130 CHECKBOX oCheckBo1 VAR lSimula PROMPT "Simulação" SIZE 120, 010 OF oDlg COLORS 0, 16777215 PIXEL

	define SBUTTON from 07, 230 TYPE 1  ACTION ( nOpca := 0, If( CONFIRMA(), nOpca := 1, nOpca := 0 ), oDlg:end()) ENABLE of oDlg
	define SBUTTON from 21, 230 TYPE 2  ACTION ( nOpca := 0, oDlg:end() ) ENABLE of oDlg

	activate MSDIALOG oDlg centered

	If nOpca == 0
		Return()
	EndIf

	//Campos da MarkBrowse
	AADD( aStrBRW, {	"cMARK"			,;
		"CN9_NUMERO"	,;
		"CN9_DTINIC"	,;
		"CN9_DTFIM"		,;
		"CNA_NUMERO"	,;
		"CNA_REVISA"	,;
		"CNA_CLIENT"	,;
		"CNA_LOJACL"	,;
		"A1_NOME"		,;
		"A1_CGC"		,;
		"CN9_XMDCON"	,;
		"CNA_TIPPLA"	} )

	DbSelectArea( "SX3" )
	SX3->( DbSetOrder(02) )

	For nX := 01  to LEN( aStrBRW[01] )
		If aStrBRW[01][nX] == "cMARK"
			AADD( aCposBRW, { "cMARK", "", "", SX3->X3_PICTURE } )
			AADD( aCposCTR, { "cMARK", "C", 2, 0 } )
		Else
			SX3->( DbSeek( aStrBRW[01][nx]) )
			AADD( aCposBRW, { AllTrim(SX3->X3_CAMPO), "", AllTrim(SX3->X3_TITULO) ,SX3->X3_PICTURE } )
			AADD( aCposCTR, { AllTrim(SX3->X3_CAMPO), SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL } )
		EndIf
	next nX

	//Deleta Arquivo Temporario caso Exista
	If oTmpCTR <> nil
		oTmpCTR:DELETE()
	EndIf

	//Cria o Objeto do FwTemporaryTable
	//oTmpSE1 := FwTemporaryTable():New("TRBSE1")
	//Cria a estrutura do alias temporario
	//oTmpSE1:SetFields(aCampos)
	//Adiciona o indicie na tabela temporaria
	//oTmpSE1:AddIndex("1",{"E1CLINOME","E1PREFIXO","E1NUM","E1PARCELA"})
	//Criando a Tabela Temporaria
	//oTmpSE1:Create()
	oTmpCTR := FWTemporaryTable():NEW(cTrbCTR)
	oTmpCTR:SetFields(aCposCTR)
	oTmpCTR:AddIndex("01", {"CN9_NUMERO"} )
	oTmpCTR:AddIndex("02", {"CN9_NUMERO","CNA_NUMERO"} )
	oTmpCTR:AddIndex("03", {"CNA_CLIENT","CNA_LOJACL"} )
	oTmpCTR:Create()

	//Filtra os Registros conForme InFormacao dos Parametros
	If FILTRACTR()
		//Tela para Marcar os Contratos
		TELAMARK()

		//Gera Titulos e efetua as baixas
		PROCESSA( {|lEnd| GRMEDCTR()},  "Aguarde...","Gerando Medição...", .T. )
	EndIf

	oTmpCTR:DELETE()
	If lSimula .And. Len(aRelat) > 0
		oExcel := FWMSEXCEL():New() //Método para geração em XML

		oExcel:AddworkSheet( cWorkSheet )      //Adiciona uma Worksheet ( Planilha )
		oExcel:AddTable ( cWorkSheet, cTable ) //Adiciona uma tabela na Worksheet. Uma WorkSheet pode ter apenas uma tabela

		//Adiciona uma coluna a tabela de uma Worksheet.
		//AddColumn( cWorkSheet, cTable, < cColumn >     		, nAlign, nFormat, lTotal)
		oExcel:AddColumn( cWorkSheet, cTable, "Filial"			, 1     , 1     , .F. )
		oExcel:AddColumn( cWorkSheet, cTable, "Contrato"		, 1     , 1     , .F. )
		oExcel:AddColumn( cWorkSheet, cTable, "Revisao"			, 1     , 1     , .F. )
		oExcel:AddColumn( cWorkSheet, cTable, "Cliente"			, 1     , 1     , .F. )
		oExcel:AddColumn( cWorkSheet, cTable, "Loja"			, 1     , 1     , .F. )
		oExcel:AddColumn( cWorkSheet, cTable, "Nome"			, 1     , 1     , .F. )
		oExcel:AddColumn( cWorkSheet, cTable, "Planilha"		, 1     , 1     , .F. )
		oExcel:AddColumn( cWorkSheet, cTable, "Competencia"		, 1     , 1     , .F. )
		oExcel:AddColumn( cWorkSheet, cTable, "Item"			, 1     , 1     , .F. )
		oExcel:AddColumn( cWorkSheet, cTable, "Produto"			, 1     , 1     , .F. )
		oExcel:AddColumn( cWorkSheet, cTable, "Descricao"		, 1     , 1     , .F. )
		oExcel:AddColumn( cWorkSheet, cTable, "Quantidade"		, 1     , 2     , .F. )
		oExcel:AddColumn( cWorkSheet, cTable, "Vlr.Unitario"	, 1     , 3     , .F. )
		oExcel:AddColumn( cWorkSheet, cTable, "Vlr.Total"		, 1     , 3     , .F. )

		//nAlign  > Alinhamento da coluna ( 1-Left,2-Center,3-Right )
		//nFormat > Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )
		//lTotal  > Indica se a coluna deve ser totalizada
		For nX := 1 To Len(aRelat)
			oExcel:AddRow( cWorkSheet, cTable, {AllTrim(aRelat[nX][1]),;
				AllTrim(aRelat[nX][2]),;
				AllTrim(aRelat[nX][3]),;
				AllTrim(aRelat[nX][4]),;
				AllTrim(aRelat[nX][5]),;
				AllTrim(aRelat[nX][6]),;
				AllTrim(aRelat[nX][7]),;
				AllTrim(aRelat[nX][8]),;
				AllTrim(aRelat[nX][9]),;
				AllTrim(aRelat[nX][10]),;
				AllTrim(Posicione("SB1",1,xFilial("SB1")+aRelat[nX][10],"B1_DESC")),;
				aRelat[nX][12],;
				aRelat[nX][13],;
				aRelat[nX][14]})
		Next nX

		oExcel:Activate()              //Executa o XML
		oExcel:GetXMLFile( cNameFile ) //Salva o arquivo no diretório

		oExcel := MsExcel():New()               //Abre uma nova conexão com Excel
		oExcel:WorkBooks:Open(cNameFile)         //Abre uma planilha
		oExcel:SetVisible(.T.)                  //Visualiza a planilha
		oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas
	EndIf
Return

/*/{Protheus.doc} CONFIRMA
Função para confirmar o Periodo da Medição
@author TOTVS NU
@since 02/07/2020
/*/
Static Function CONFIRMA()
	Local lRet := .T.

	lRet := MSGYESNO( "Confirma Dados?", "Atenção" )
Return( lRet )

/*/{Protheus.doc} FILTRACTR
Função para Filtrar os Contatos
@author TOTVS NU
@since 02/07/2020
/*/
Static Function FILTRACTR()
	Local cAliasCTR		:= GetNextAlias()
	Local cCN9ESPCTR	:= "2"
	Local cCN9SITUAC	:= "05"
	Local lRet			:= .T.

	BeginSql Alias cAliasCTR
        COLUMN CN9_DTINIC AS DATE
        COLUMN CN9_DTFIM  AS DATE

        SELECT CN9_NUMERO, CN9_DTINIC, CN9_DTFIM, CN9_XMDCON, CNA_NUMERO, CNA_REVISA, CNA_CLIENT, CNA_LOJACL, A1_NOME, A1_CGC, CNA_TIPPLA
        FROM %TABLE:CN9% CN9 (NOLOCK) 
        INNER JOIN %TABLE:CNA% CNA (NOLOCK)
        ON CNA.%notDel%
        AND CNA.CNA_FILIAL = CN9.CN9_FILIAL
        AND CNA.CNA_CONTRA = CN9.CN9_NUMERO
        AND CNA.CNA_REVISA = CN9.CN9_REVISA
        AND CNA.CNA_TIPPLA IN (SELECT   CNL.CNL_CODIGO
        FROM    %Table:CNL% CNL
        WHERE   CNL.%NotDel%
        AND     CNL.CNL_FILIAL = %xFilial:CNL%
        AND     CNL.CNL_CTRFIX = '3' )
        INNER JOIN %TABLE:SA1% SA1 (NOLOCK)
        ON SA1.%notDel%
        AND SA1.A1_COD = CNA.CNA_CLIENT
        AND SA1.A1_LOJA = CNA.CNA_LOJACL
        AND SA1.A1_MSBLQL <> '1'
        WHERE CN9.%notDel% 
        AND CN9.CN9_FILIAL = %xFilial:CN9%
        AND CN9.CN9_ESPCTR = %EXP:cCN9ESPCTR%
        AND CN9.CN9_SITUAC = %EXP:cCN9SITUAC%
        AND (CN9.CN9_REVATU = '  '  OR  CN9.CN9_REVATU = '')  
        AND CN9.CN9_DTINIC <= %EXP:DTOS(dDataAte)%
        AND CN9.CN9_DTFIM > %EXP:DTOS(dDataDe)% 
        AND CN9.CN9_NUMERO >= %EXP:cContratD%
        AND CN9.CN9_NUMERO <= %EXP:cContratA%
        ORDER BY CN9_NUMERO, CNA_NUMERO
	EndSql

	//Processando as linhas GetLastQuery()[02]
	DbSelectArea( cAliasCTR )
	(cAliasCTR)->( DbGoTop() )
	While (cAliasCTR)->( !Eof() )
		DbSelectArea( cTrbCTR )
		(cTrbCTR)->( RecLock(cTrbCTR,.T.) )
		(cTrbCTR)->cMARK     := Space(02)
		(cTrbCTR)->CN9_NUMERO := (cAliasCTR)->CN9_NUMERO
		(cTrbCTR)->CN9_DTINIC := (cAliasCTR)->CN9_DTINIC
		(cTrbCTR)->CN9_DTFIM  := (cAliasCTR)->CN9_DTFIM
		(cTrbCTR)->CNA_NUMERO := (cAliasCTR)->CNA_NUMERO
		(cTrbCTR)->CNA_REVISA := (cAliasCTR)->CNA_REVISA
		(cTrbCTR)->CNA_CLIENT := (cAliasCTR)->CNA_CLIENT
		(cTrbCTR)->CNA_LOJACL := (cAliasCTR)->CNA_LOJACL
		(cTrbCTR)->A1_NOME    := (cAliasCTR)->A1_NOME
		(cTrbCTR)->A1_CGC     := (cAliasCTR)->A1_CGC
		(cTrbCTR)->CN9_XMDCON := (cAliasCTR)->CN9_XMDCON
		(cTrbCTR)->CNA_TIPPLA := (cAliasCTR)->CNA_TIPPLA
		(cTrbCTR)->( MsUnLock() )
		(cAliasCTR)->( DbSkip() )
	End
	(cAliasCTR)->( DbCloseArea() )

	//Valida se encontrou registros
	DbSelectArea( cTrbCTR )
	(cTrbCTR)->( DbGoTop() )
	If (cTrbCTR)->( Eof() )
		MsgAlert( "Não Foram Localizados Registros com a Data InFormada...", "Aviso" )
		lRet := .F.
	EndIf
Return( lRet )

/*/{Protheus.doc} TELAMARK
Função de tela para Selecionar os Contratos
@author TOTVS NU
@since 02/07/2020
/*/
Static Function TELAMARK()
	Local nOpca     := 0

	Private cMarca   := GetMark()
	Private oMark    := nil
	Private oPanel1  := nil
	Private oDlgTit  := nil
	Private lInverte := .F.
	Private aBotoes  := {}

	//Deixa Todos Registros Marcados
	//MARKCTR(cMarca, .T., "")

	//Monta Browse com os Titulos
	define MSDIALOG oDlgTit from 005,001 to 599,1339  TITLE OEMTOANSI("Selecione os Contratos") pixel STYLE DS_MODALFRAME

	oDlgTit:lMaximized := .F.
	oDlgTit:lEscClose  := .F.

	oPanel1 := TPANEL():NEW(0,0,'',oDlgTit,, .T., .T.,, ,20,20)
	oPanel1:Align := CONTROL_ALIGN_ALLCLIENT

	oMark:= MSSELECT():NEW( cTrbCTR, "cMARK",, aCposBRW, @lInverte, @cMarca,{ 30, 00, 295, 671 } )
	oMark:oBrowse:lhasMark := .T.
	oMark:oBrowse:lCanAllmark := .T.
	oMark:oBrowse:bAllMark := { || MARKCTR( cMarca, .T., oMark )}
	oMark:oBrowse:bLDblClick := {|| Iif(oMark:oBrowse:nColPos == 1 ,(MARKCTR( cMarca, .F., oMark )),(GrObsFPA((cTrbCTR)->( RECNO() ))))}

	oDlgTit:SetText( OEMTOANSI( "Selecione os Contratos" ) )

	activate MsDialog oDlgTit On Init ENCHOICEBAR( oDlgTit, { || If( VLDMARCA(), ODlgTit:end(), ) }, { || ODlgTit:end() }) centered

	If nOpca == 0
		lRet := .F.
	Else
		lRet := .T.
	EndIf
Return( lRet )

/*/{Protheus.doc} FILTRACTR
Função marcar os desmarcar todos os contratos
@author TOTVS NU
@since 02/07/2020
/*/
Static Function MARKCTR(cMarca, lTodos, oMark)
	Local nReg := (cTrbCTR)->( RECNO() )

	If lTodos
		(cTrbCTR)->( DbGoTop() )
	EndIf

	While !lTodos .or. !(cTrbCTR)->( Eof() )
		If (cTrbCTR)->cMARK == cMARCA
			(cTrbCTR)->( RecLock( cTrbCTR, .F. ) )
			(cTrbCTR)->cMARK := SPACE(02)
			(cTrbCTR)->( MsUnLock() )
		Else
			(cTrbCTR)->( RecLock( cTrbCTR, .F. ) )
			(cTrbCTR)->cMARK := cMarca
			(cTrbCTR)->( MsUnLock() )
		EndIf

		If lTodos
			(cTrbCTR)->( DbSkip() )
		Else
			exit
		EndIf
	End
	(cTrbCTR)->( DbGoTo(nReg) )
Return

/*/{Protheus.doc} FILTRACTR
Função Valida se algum contrato foi selecionado
@author TOTVS NU
@since 02/07/2020
/*/
Static Function VLDMARCA()
	Local lRet  := .F.
	Local aArea := (cTrbCTR)->( GETAREA() )

	DbSelectArea(cTrbCTR)
	(cTrbCTR)->( DbGoTop() )
	While (cTrbCTR)->( !Eof() )
		If !Empty((cTrbCTR)->cMARK)
			lRet := .T.
			exit
		EndIf

		(cTrbCTR)->( DbSkip() )
	End

	If !lRet
		MsgAlert( "Necessario selecionar um Contrato !!!", "Aviso" )
	EndIf

	RestArea( aArea )
Return( lRet )

/*/{Protheus.doc} GRMEDCTR
Função IdentIfica Contratos Selecionado 
@author TOTVS NU
@since 02/07/2020
/*/
Static Function GRMEDCTR()
	Local cA1CGC  := ""
	Local aMedCTR := {}
	Local ni      := 0


	//Le Registros a Faturar
	DbSelectArea( cTrbCTR )
	(cTrbCTR)->( DbSetOrder(01) )
	(cTrbCTR)->( DbGoTop() )

	PROCREGUA( (cTrbCTR)->(RECCOUNT()) )

	While (cTrbCTR)->( !Eof() )
		//VALIDA SE REGISTRO ESTA MARCADO
		If Empty( (cTrbCTR)->cMARK )
			(cTrbCTR)->( DbSkip() )
			loop
		EndIf

		If (cTrbCTR)->CN9_XMDCON == "1"
			DbSelectArea("CNC")
			DbSetOrder(3)
			DbSeek(xFilial("CNC")+(cTrbCTR)->CN9_NUMERO+(cTrbCTR)->CNA_REVISA)
			ncontaxmdcon := 1
			aCN9_XMDCON  := {}
			While CNC->CNC_NUMERO == (cTrbCTR)->CN9_NUMERO .AND. CNC->CNC_REVISA == (cTrbCTR)->CNA_REVISA .AND. !Eof()
				cA1CGC 		:= Left(POSICIONE("SA1",1,xFilial("SA1")+CNC->CNC_CLIENT+CNC->CNC_LOJACL,'A1_CGC'),8)

				if (Left((cTrbCTR)->A1_CGC,8) == cA1CGC)
					aMEDCTRtmp 	:= BRWSCTR(cA1CGC)

					For ni := 1 to len(aMEDCTRtmp)
						If ncontaxmdcon == 1
							aCN9_XMDCON := ACLONE(aMEDCTRtmp)
							exit
						Else
							aCN9_XMDCON[ni][2] := aCN9_XMDCON[ni][2] + aMEDCTRtmp[ni][2]
						EndIf
					next
				endif
				
				CNC->(DbSkip())
				ncontaxmdcon++
			End
			aMEDCTR := ACLONE(aCN9_XMDCON)
		Else
			cA1CGC := (cTrbCTR)->A1_CGC
			aMEDCTR := BRWSCTR(cA1CGC)
		EndIf

		If LEN(aMEDCTR) > 0
			If (cTrbCTR)->CNA_TIPPLA $ cTipo1
				VALIDACTR(aMEDCTR) //normal -> qtde minima
			ElseIf (cTrbCTR)->CNA_TIPPLA $ cTipo2
				MedEFV(aMEDCTR) //excedente ou faixa ou valor fechado
			ElseIf (cTrbCTR)->CNA_TIPPLA $ cTipo3
				MedFIX()//planilha fixa
			EndIf
		EndIf

		(cTrbCTR)->( DbSkip() )
	End

	If !Empty(cMsgBRSYST)
		U_zMsgLog(cMsgBRSYST , "RETORNO BRSYSTEM ")
	EndIf
Return()

/*/{Protheus.doc} BRWSCTR
Função Consulta Medição WBSERVICE
@author TOTVS NU
@since 02/07/2020
/*/
Static Function BRWSCTR(cA1CGC)
	Local oWS  := nil
	Local oRet := nil
	Local aRetorno := {}
	Local nNx      := 0
	Local cQry := ""
	Local cAliasA := GetNextAlias()

	Local cUsuario := "integra.erp.totvs"
	Local cSenha   := "3ZSQ9U9Y4PSD"

	Local cCNPJ        := cA1CGC
	Local cDataInicio  := Substr(DtoS(dDataDe),1,4)  + "-" + Substr(DtoS(dDataDe),5,2)  + "-" + Substr(DtoS(dDataDe),7,2)  + " " + "00:00"  //"2020-01-01 00:00"
	Local cDataTermino := Substr(DtoS(dDataAte),1,4) + "-" + Substr(DtoS(dDataAte),5,2) + "-" + Substr(DtoS(dDataAte),7,2) + " " + "23:59"  //"2020-02-01 00:00"


	oWS	:= WSEebServiceCTR():New()
	oWS:BuscarDadosTotvsBR( cUsuario,cSenha,cCNPJ,cDataInicio,cDataTermino )

	oRet := oWS:oWSRetornoIntegracaoTotvsBR
	If oRet:CMENSAGEMDERETORNO == "OK"
		cQry := " SELECT ZZ5_BRSYST, ZZ5_COD FROM "+RetSqlName("ZZ5")
		cQry += " WHERE D_E_L_E_T_ <> '*' "
		cQry := ChangeQuery(cQry)
		DbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), cAliasA, .F., .T.)

		(cAliasA)->(DbGoTop())
		While (cAliasA)->(!Eof())
			AADD( aRetorno,{ AllTrim((cAliasA)->ZZ5_BRSYST)	, &("oRet:" + cValToChar(AllTrim((cAliasA)->ZZ5_BRSYST))), AllTrim((cAliasA)->ZZ5_COD), cCNPJ } )

			(cAliasA)->(DbSkip())
		End
		(cAliasA)->(DbCloseArea())
	EndIf

	Ltemqtd := .f.
	cQtde   := ""
	For nNx :=1 to len(aRetorno)
		if ValType(aRetorno[nNx][2]) == "U" 
		   aRetorno[nNx][2] := 0
		endif 
		cMsgBRSYST += "Contrato: " +  (cTrbCTR)->CN9_NUMERO + " "+ aRetorno[nNx][1] + " Qtd: " + AllTrim(str(aRetorno[nNx][2])) + " Prd.: " + aRetorno[nNx][3] + Chr(13) + Chr(10)
		If aRetorno[nNx][2] > 0
			Ltemqtd := .t.
		EndIf
	Next nNx
Return( aRetorno )

/*/{Protheus.doc} VALIDACTR
Função Produtos retornados do WBSERVICE
@author TOTVS NU
@since 02/07/2020
/*/
Static Function VALIDACTR(aMedCTR)
	Local aProduto	:= {}
	Local aProdutos	:= {}
	Local aProdCTR	:= {}
	Local cNumMed	:= ""
	Local cCNPJ     := ""
	Local cNrContra	:= (cTrbCTR)->CN9_NUMERO
	Local cNrRevisa	:= (cTrbCTR)->CNA_REVISA
	Local cNrPlan	:= (cTrbCTR)->CNA_NUMERO
	Local cCompet	:= SPACE(TAMSX3("CND_COMPET")[1])
	Local cMoeda	:= SPACE(TAMSX3("CND_MOEDA" )[1])
	Local cProduto	:= SPACE(TAMSX3("CNE_PRODUT")[1])
	Local nQuant	:= 0
	Local nX		:= 0
	Local nY		:= 0
	Local nNx		:= 0
	Local nCont		:= 0
	Local nPos      := 0
	Local lRet		:= .T.
	Local aLog		:= {}
	Local lInc 		:= .F.

	//Busca Produtos no Contrato
	aProdCTR := VLDPRDCTR(cNrContra,cNrRevisa,cNrPlan )

	For nX := 1 to LEN( aProdCTR)
		cProduto := aProdCTR[nX][1]
		lInc := .F.
		For nNx := 1 to len(aMedCTR)
			If (aMedCTR[nNx][3] == cProduto) 
				//Pesquisa Produto no WS
				For nCont := 1 to Len(aProdCTR)
					If (AllTrim(aProdCTR[nCont][1]) == AllTrim(aMedCTR[nNx][3])) .AND. aMedCTR[nNx][2] > 0 
						lInc := .T.
						If aProdCTR[nCont][4] < aMedCTR[nNx][2]
							aProdCTR[nCont][4] := aMedCTR[nNx][2]
						EndIf
					EndIf
				Next nCont

				If lInc
					AADD( aProdutos, { aMedCTR[nNx][3], aMedCTR[nNx][2], aProdCTR[nX][2], aProdCTR[nX][3], aProdCTR[nX][4], aProdCTR[nX][5]} )
				EndIf

			EndIf
		Next nNx

		If !lInc
			AADD( aProdutos, { aProdCTR[nX][1], aProdCTR[nX][4], aProdCTR[nX][2], aProdCTR[nX][3], aProdCTR[nX][4], aProdCTR[nX][5]} )
		EndIf
	next nX

	For nNx := 1 to len(aProdutos)
		aadd(aProduto,{ aProdutos[nNx][1], aProdutos[nNx][2], aProdutos[nNx][3], aProdutos[nNx][4], aProdutos[nNx][5], aProdutos[nNx][6]})
	Next nNx

	aSort(aProduto,,, {|X,Y| X[3] < Y[3] })

	If !lInc
		For nNx :=1 to len(aMedCTR)
			If aMedCTR[nNx][2] > 0
				cMsgPROTHE += "Contrato: "+cNrContra+" "+aMedCTR[nNx][3] + " Qtd: " + AllTrim(str(aMedCTR[nNx][2])) + Chr(13) + Chr(10)
			EndIf
		Next nNx
	EndIf

	cCompet   := Substr(DtoS(dDataDe),5,2)  + "/" + Substr(DtoS(dDataDe),1,4)//Substr(DtoS(CN9->CN9_DTINIC),5,2) + "/" + Substr(DtoS(CN9->CN9_DTINIC),1,4)
	cMoeda    := "01"

	CNA->( DbSetOrder( 01 ) )
	CNA->( DbSeek( xFilial("CNA") + cNrContra + cNrRevisa + cNrPlan ) )

	SA1->( DbSetOrder( 01 ) )
	If !SA1->( DbSeek( xFilial("SA1") + CNA->CNA_CLIENT + CNA->CNA_LOJACL ) )
		aLog := {}
		aAdd(aLog,{xFilial("CND"),cNrContra,cNrRevisa,cNrPlan,cCompet,"","","Cliente/Loja: " + AllTrim(CNA->CNA_CLIENT) + "-" + AllTrim(CNA->CNA_LOJACL) + " Não Localizado"})
		GravaErro(aLog)
		lRet := .F.
	Else
		If SA1->A1_MSBLQL == "1"
			aLog := {}
			aAdd(aLog,{xFilial("CND"),cNrContra,cNrRevisa,cNrPlan,cCompet,"","","Cliente/Loja: " + AllTrim(SA1->A1_COD) + "-" + AllTrim(SA1->A1_LOJA) + " Esta Bloqueado"})
			GravaErro(aLog)
			lRet := .F.
		EndIf
	EndIf

	If lRet
		CN9->(DbSetOrder(1))
		If CN9->( DbSeek( xFilial("CN9") + cNrContra + cNrRevisa ) )
			nCompet  := 0
			aCompets := CtrCompets()
			nCompet := aScan(aCompets, {|x| AllTrim(x) == cCompet })

			If nCompet == 0
				aLog := {}
				aAdd(aLog,{xFilial("CND"),cNrContra,cNrRevisa,cNrPlan,cCompet,"","Competencia nao encontrada",""})
				GravaErro(aLog)
				Return
			EndIf

			oModel := FWLoadModel("CNTA121")
			oModel:SetOperation(MODEL_OPERATION_INSERT)
			If(oModel:CanActivate())
				oModel:Activate()
				oModel:SetValue("CNDMASTER","CND_CONTRA"    , CN9->CN9_NUMERO)
				oModel:SetValue("CNDMASTER","CND_RCCOMP"    , cValToChar(nCompet))
				oModel:SetValue("CNDMASTER","CND_XPERIO"    , 'Periodo de '+Substr(DtoS(dDataDe),7,2) + "/" + Substr(DtoS(dDataDe),5,2) + "/" + Substr(DtoS(dDataDe),1,4)+ ' até '+Substr(DtoS(dDataAte),7,2) + "/" + Substr(DtoS(dDataAte),5,2) + "/" + Substr(DtoS(dDataAte),1,4)      )
				oModel:SetValue("CNDMASTER","CND_XCLINM"    , AllTrim(SA1->A1_NOME)       )
				oModel:SetValue("CNDMASTER","CND_XNOMRE"    , AllTrim(SA1->A1_NREDUZ)       )

				aPlan := {}
				For nX := 1 To oModel:GetModel("CXNDETAIL"):Length()
					oModel:GetModel("CXNDETAIL"):GoLine(nX)
					aAdd(aPlan,Val(oModel:GetModel("CXNDETAIL"):GetValue("CXN_NUMPLA")))
				Next nX
				nPosPl := 0
				nPosPl := aScan(aPlan, {|x| x == Val(AllTrim(cNrPlan)) })

				If nPosPl == 0
					aLog := {}
					aAdd(aLog,{xFilial("CND"),cNrContra,cNrRevisa,cNrPlan,cCompet,cNumMed,"Planilha nao encontrada",""})
					GravaErro(aLog)
					Return
				EndIf

				oModel:GetModel("CXNDETAIL"):GoLine(nPosPl)
				oModel:SetValue("CXNDETAIL","CXN_CHECK" , .T.)//Marcar a planilha(nesse caso apenas uma)
				ntotquant := 0
				lCNB 	  := .F.
				CNB->(DbSetOrder(1))		// Valdemir Rabelo 27/12/2024
				For nY := 1 to LEN(aProduto)
					cProduto := aProduto[nY][01]
					nQuant   := aProduto[nY][02]
					nItem    := aProduto[nY][03]
					nVlrUnt  := aProduto[nY][04]
					nQmin    := aProduto[nY][05]
					ntabPrc  := aProduto[nY][06]
					lCNB 	 := CNB->( DbSeek( xFilial("CNB") + cNrContra + cNrRevisa + cNrPlan ) )

					If lCNB //.and. (CNB->CNB_XPCANC == "2") - Removido por Valdemir Rabelo 24/04/2025
						cMsgBRSYST += "Contrato: " +  cNrContra + " "+ cNrRevisa + " Qtd min. : " + AllTrim(str(nQmin)) + " Prd.: " + cProduto + Chr(13) + Chr(10)
					Endif 

					If nQmin > nQuant
						nQuant := nQmin
					EndIf					

					If lCNB       // Valdemir Rabelo 19/12/2024
					    nRegCNB   := CNB->( RECNO() )
						ntotquant := 0
						While cNrContra + cNrRevisa == CNB->CNB_CONTRA + CNB->CNB_REVISA .AND. CNB->(!Eof())
							If cProduto == CNB->CNB_PRODUT
								If (CNB->CNB_XPCANC $ "1/3")  // Valdemir Rabelo 19/12/2024
									nQuant := 0
									Exit								
								EndIf
							EndIf
							CNB->( DbSkip() )
						end
						CNB->( dbGoto(nRegCNB) )
					EndIf

					oModel:GetModel('CNEDETAIL'):GoLine(val(nItem))
					oModel:SetValue('CNEDETAIL' , 'CNE_PRODUT'  , cProduto  )
					oModel:SetValue('CNEDETAIL' , 'CNE_QUANT'   , nQuant )
					oModel:SetValue('CNEDETAIL' , 'CNE_TABPRC'  , ntabPrc   )
					ntotquant += nQuant
					If lSimula
						If aScan(aRelat ,{|x|, x[2] == cNrContra .and. x[3] == cNrRevisa .and. x[9] == nItem .and. x[10] == cProduto }) == 0
							aAdd(aRelat,{xFilial("CND"),cNrContra,cNrRevisa,SA1->A1_COD,SA1->A1_LOJA,SA1->A1_NOME,cNrPlan,cCompet,nItem,cProduto,SB1->B1_DESC,ntotquant,nVlrUnt,ntotquant*nVlrUnt})
						EndIf
					EndIf
				Next nY

				If !lSimula
					//If ntotquant <> 0        // Removido por Valdemir Rabelo 28/04/2025
						If (oModel:VldData())  /*Valida o modelo como um todo*/
							oModel:CommitData()
						EndIf
					//EndIf

					If(oModel:HasErrorMessage())
						aErro := oModel:GetErrorMessage()
						aLog := {}
						aAdd(aLog,{xFilial("CND"),cNrContra,cNrRevisa,cNrPlan,cCompet,"","",aErro[6]})
						GravaErro(aLog)
					Else
						cNumMed := CND->CND_NUMMED
						oModel:DeActivate()
						lRet := CN121Encerr(.T.) //Realiza o encerramento da medição
						aLog := {}
						aAdd(aLog,{xFilial("CND"),cNrContra,cNrRevisa,cNrPlan,cCompet,cNumMed,"OK",""})
						GravaErro(aLog)
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
Return()

/*/{Protheus.doc} VLDPRDCTR
description Função Retorna os Produtos da Planilha
@type Static Function
@version 
@author TOTVS NU
@since 02/07/2020
@param cSEDCodigo, character, param_description
@Return Return_type, Return_description
/*/
Static Function VLDPRDCTR(cNrContra,cNrRevisa,cNrPlan )
	Local cAliasCNB		:= GetNextAlias()
	Local cCNBCONTRA	:= cNrContra
	Local cCNBNUMERO	:= cNrPlan
	Local cCNBREVISA	:= cNrRevisa
	Local aRetorno2		:= {}
//	Local cTipoExc		:= '1'
//	Local cTipoExc2		:= '3'     // Valdemir Rabelo 19/12/2024

//		AND CNB.CNB_XPCANC <> %EXP:cTipoExc%
//		AND CNB.CNB_XPCANC <> %EXP:cTipoExc2%

	BeginSql Alias cAliasCNB
		COLUMN CN9_DTINIC AS DATE
		COLUMN CN9_DTFIM  AS DATE

		SELECT CNB_CONTRA, CNB_NUMERO, CNB_ITEM, CNB_PRODUT, CNB_QUANT, CNB_VLUNIT, CNB_XQMIN, CNB_TABPRC
		FROM %TABLE:CNB% CNB (NOLOCK) 
		WHERE CNB.%notDel% 
		AND CNB.CNB_FILIAL = %xFilial:CNB%
		AND CNB.CNB_CONTRA = %EXP:cCNBCONTRA%
		AND CNB.CNB_NUMERO = %EXP:cCNBNUMERO%
		AND CNB.CNB_REVISA = %EXP:cCNBREVISA%
		ORDER BY CNB_NUMERO, CNB_ITEM

	EndSql

	//Processando as linhas GetLastQuery()[02]
	DbSelectArea( cAliasCNB )
	(cAliasCNB)->( DbGoTop() )
	ncontaitem := 1
	While (cAliasCNB)->( !Eof() )
		AADD( aRetorno2, { (cAliasCNB)->CNB_PRODUT, strzero(ncontaitem,3) /*(cAliasCNB)->CNB_ITEM*/, (cAliasCNB)->CNB_VLUNIT, (cAliasCNB)->CNB_XQMIN, (cAliasCNB)->CNB_TABPRC })

		ncontaitem++

		(cAliasCNB)->( DbSkip() )
	End
	(cAliasCNB)->( DbCloseArea() )
Return( aRetorno2 )

/*/{Protheus.doc} GravaErro
Grava Log de erro - tabela ZZ3
@author Totvs Nações Unidas
@since 05.01.2024
/*/
Static Function GravaErro(aLog As Array)
	Local aArea As Array

	aArea := GetArea()

	DbSelectArea("ZZ3")
	RecLock("ZZ3",.T.)
	ZZ3->ZZ3_FILIAL	 := aLog[1][1]
	ZZ3->ZZ3_NUMCTR	 := aLog[1][2]
	ZZ3->ZZ3_REVISA	 := aLog[1][3]
	ZZ3->ZZ3_NUMPLA	 := aLog[1][4]
	ZZ3->ZZ3_COMPET	 := aLog[1][5]
	ZZ3->ZZ3_NUMMED	 := aLog[1][6]
	ZZ3->ZZ3_SITUAC	 := aLog[1][7]
	ZZ3->ZZ3_LOGMED	 := aLog[1][8]
	MsUnLock()

	RestArea(aArea)
	FWFreeArray(aArea)
Return

/*/Protheus.doc GrObsFPA
	@(long_description) Funcao para gravar o campo de observações da Tabela FPA.
	@type Function SetCssImg
	@author Eduardo Silva
	@since 24/10/2023
	@version 12.1.2210
/*/
Static Function GrObsFPA(nReg)
	Local oDlg1
	Local oMultiGet
	Local cTexto := ""

	(cTrbCTR)->( DbGoTo(nReg) )

	DbSelectArea("ZZ3")
	ZZ3->( DbSetOrder( 1 ) )
	ZZ3->( DbSeek( xFilial("ZZ3") + (cTrbCTR)->CN9_NUMERO+(cTrbCTR)->CNA_REVISA+(cTrbCTR)->CNA_NUMERO+ZZ3_COMPET ) )

	cTexto := ZZ3->ZZ3_LOGMED

	Define Dialog oDlg1 Title "Log da Medição" From 180, 180 To 450, 700 Pixel
	@005,005 Get oMultiGet Var cTexto Of oDlg1 MULTILINE Size 250, 110 Colors 0, 16777215 HSCROLL Pixel
	oBtnPesq := TButton():New( 120, 195,"Confirmar",oDlg1,{||oDlg1:End()},060,013,,,,.T.,,"",,,,.F. )
	oBtnPesq:SetCss(SetCssImg("","Primary"))
	Activate Dialog oDlg1 Centered
Return

/*/Protheus.doc SetCssImg
	@(long_description) Funcao para setar CSS e Imagem nos Botoes
	@type Function SetCssImg
	@author Eduardo Silva
	@since 14/08/2021
	@version 12.1.27
/*/
Static Function SetCssImg(cImg,cTipo)
	Local cCssRet	:= ""
	Default cImg	:= "rpo:yoko_sair.png"
	Default cTipo	:= "Botao Branco"
	If cTipo == "Primary"
		cCssRet := "QPushButton {"
		cCssRet += " color:#fff;background-color:#007bff;border-color:#007bff "
		cCssRet += "}"
	EndIf
	If cTipo == "Danger"
		cCssRet := "QPushButton {"
		cCssRet += " color:#fff;background-color:#dc3545;border-color:#dc3545 "
		cCssRet += "}"
	EndIf
	If cTipo == "Success"
		cCssRet := "QPushButton {"
		cCssRet += " color:#fff;background-color:#28a745;border-color:#28a745 "
		cCssRet += "}"
	EndIf
	If cTipo == "Second"
		cCssRet := "QPushButton {"
		cCssRet += " color:#fff;background-color:#5F9EA0;border-color:#5F9EA0 "
		cCssRet += "}"
	EndIf
Return cCssRet


Static Function MedEFV(aMEDCTR)
	Local aProduto	:= {}
	Local aProdCTR	:= {}
	Local cNumMed	:= ""
	Local cNrContra	:= (cTrbCTR)->CN9_NUMERO
	Local cNrRevisa	:= (cTrbCTR)->CNA_REVISA
	Local cNrPlan	:= (cTrbCTR)->CNA_NUMERO
	Local cCompet	:= SPACE(TAMSX3("CND_COMPET")[1])
	Local cMoeda	:= SPACE(TAMSX3("CND_MOEDA" )[1])
	Local cProduto	:= SPACE(TAMSX3("CNE_PRODUT")[1])
	Local nQuant	:= 0
	Local nX		:= 0
	Local nY		:= 0
	Local lRet		:= .T.
	Local aLog		:= {}
	Local cQry 		:= ""
	Local cAliasA 	:= GetNextAlias()
	Local nPos		:= 0

	//Busca Produtos no Contrato
	aProdCTR := VLDPRDEFV(cNrContra,cNrRevisa,cNrPlan )
	/*
	For nX := 1 to LEN( aProdCTR)
		nPos := aScan(aMedCTR ,{|x|, x[3] == aProdCTR[nX][1] })
		If nPos > 0 .And. aScan(aProduto ,{|x|, x[1] == aProdCTR[nX][1] }) = 0
			aAdd(aProduto, { aMedCTR[nPos][3], aMedCTR[nPos][2], aProdCTR[nX][2], aProdCTR[nX][3], aMedCTR[nPos][2], aProdCTR[nX][5]})
		EndIf
	next nX
	*/

	For nX := 1 To Len(aProdCtr)
		For nY := 1 To Len(aMedCTR)
			If aProdCtr[nX][1] == aMedCTR[nY][3]
				If aProdCtr[nX][4] < aMedCTR[nY][2]
					aProdCtr[nX][4] := aMedCTR[nY][2]
				EndIf
				If Len(aProduto) == 0
					aAdd(aProduto, { aMedCTR[nY][3], aProdCtr[nX][4], aProdCTR[nX][2], aProdCTR[nX][3], aMedCTR[nY][2], aProdCTR[nX][5]})
				Else
					nPos := aScan(aProduto ,{|x|, x[1] == aProdCTR[nX][1] })
					If nPos > 0
						If aProduto[nPos][2] < aMedCTR[nY][2]
							aProduto[nPos][2] := aMedCTR[nY][2]
							aProduto[nPos][5] := aMedCTR[nY][2]
						EndIf
					EndIf
				EndIf
			EndIf
		Next nY
	Next nX

	cCompet   := Substr(DtoS(dDataDe),5,2)  + "/" + Substr(DtoS(dDataDe),1,4)//Substr(DtoS(CN9->CN9_DTINIC),5,2) + "/" + Substr(DtoS(CN9->CN9_DTINIC),1,4)
	cMoeda    := "01"

	CNA->( DbSetOrder( 01 ) )
	CNA->( DbSeek( xFilial("CNA") + cNrContra + cNrRevisa + cNrPlan ) )

	SA1->( DbSetOrder( 01 ) )
	If !SA1->( DbSeek( xFilial("SA1") + CNA->CNA_CLIENT + CNA->CNA_LOJACL ) )
		aLog := {}
		aAdd(aLog,{xFilial("CND"),cNrContra,cNrRevisa,cNrPlan,cCompet,"","","Cliente/Loja: " + AllTrim(CNA->CNA_CLIENT) + "-" + AllTrim(CNA->CNA_LOJACL) + " Não Localizado"})
		GravaErro(aLog)
		lRet := .F.
	Else
		If SA1->A1_MSBLQL == "1"
			aLog := {}
			aAdd(aLog,{xFilial("CND"),cNrContra,cNrRevisa,cNrPlan,cCompet,"","","Cliente/Loja: " + AllTrim(SA1->A1_COD) + "-" + AllTrim(SA1->A1_LOJA) + " Esta Bloqueado"})
			GravaErro(aLog)
			lRet := .F.
		EndIf
	EndIf

	If lRet
		CN9->(DbSetOrder(1))
		If CN9->( DbSeek( xFilial("CN9") + cNrContra + cNrRevisa ) )
			nCompet  := 0
			aCompets := CtrCompets()
			nCompet := aScan(aCompets, {|x| AllTrim(x) == cCompet })

			If nCompet == 0
				aLog := {}
				aAdd(aLog,{xFilial("CND"),cNrContra,cNrRevisa,cNrPlan,cCompet,"","Competencia nao encontrada",""})
				GravaErro(aLog)
				Return
			EndIf

			oModel := FWLoadModel("CNTA121")
			oModel:SetOperation(MODEL_OPERATION_INSERT)
			If(oModel:CanActivate())
				oModel:Activate()
				oModel:SetValue("CNDMASTER","CND_CONTRA"    , CN9->CN9_NUMERO)
				oModel:SetValue("CNDMASTER","CND_RCCOMP"    , cValToChar(nCompet))
				oModel:SetValue("CNDMASTER","CND_XPERIO"    , 'Periodo de '+Substr(DtoS(dDataDe),7,2) + "/" + Substr(DtoS(dDataDe),5,2) + "/" + Substr(DtoS(dDataDe),1,4)+ ' até '+Substr(DtoS(dDataAte),7,2) + "/" + Substr(DtoS(dDataAte),5,2) + "/" + Substr(DtoS(dDataAte),1,4)      )
				oModel:SetValue("CNDMASTER","CND_XCLINM"    , AllTrim(SA1->A1_NOME)       )
				oModel:SetValue("CNDMASTER","CND_XNOMRE"    , AllTrim(SA1->A1_NREDUZ)       )

				aPlan := {}
				For nX := 1 To oModel:GetModel("CXNDETAIL"):Length()
					oModel:GetModel("CXNDETAIL"):GoLine(nX)
					aAdd(aPlan,Val(oModel:GetModel("CXNDETAIL"):GetValue("CXN_NUMPLA")))
				Next nX
				nPosPl := 0
				nPosPl := aScan(aPlan, {|x| x == Val(AllTrim(cNrPlan)) })

				If nPosPl == 0
					aLog := {}
					aAdd(aLog,{xFilial("CND"),cNrContra,cNrRevisa,cNrPlan,cCompet,cNumMed,"Planilha nao encontrada",""})
					GravaErro(aLog)
					Return
				EndIf

				oModel:GetModel("CXNDETAIL"):GoLine(nPosPl)
				oModel:SetValue("CXNDETAIL","CXN_CHECK" , .T.)//Marcar a planilha(nesse caso apenas uma)

				For nY := 1 to LEN(aProduto)
					cProduto := aProduto[nY][01]
					nQuant   := aProduto[nY][02]
					nItem    := aProduto[nY][03]
					nVlrUnt  := aProduto[nY][04]
					nQmin    := aProduto[nY][05]
					cTipo  	 := aProduto[nY][06]

					If cTipo == "E"
						cQry := " SELECT ZZ4_QTINI,ZZ4_VLUNIT FROM "+RetSqlName("ZZ4")
						cQry += " WHERE D_E_L_E_T_ <> '*' "
						cQry += " AND ZZ4_CONTRA = '"+cNrContra+"' "
						cQry += " AND ZZ4_PRODUT = '"+cProduto+"' "
						cQry := ChangeQuery(cQry)
						DbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), cAliasA, .F., .T.)

						(cAliasA)->(DbGoTop())
						nQtdIni := (cAliasA)->ZZ4_QTINI
						nVlUnit := (cAliasA)->ZZ4_VLUNIT
						(cAliasA)->(DbCloseArea())

						If nQuant > nQtdIni
							nQuant -= nQtdIni

							oModel:GetModel('CNEDETAIL'):GoLine(val(nItem))
							oModel:SetValue('CNEDETAIL' , 'CNE_QUANT'   , nQuant+1    )
						EndIf
						If lSimula
							aAdd(aRelat,{xFilial("CND"),cNrContra,cNrRevisa,SA1->A1_COD,SA1->A1_LOJA,SA1->A1_NOME,cNrPlan,cCompet,oModel:GetModel("CNEDETAIL"):GetValue("CNE_ITEM"),oModel:GetModel("CNEDETAIL"):GetValue("CNE_PRODUT"),oModel:GetModel("CNEDETAIL"):GetValue("CNE_DESCRI"),1,oModel:GetModel("CNEDETAIL"):GetValue("CNE_VLUNIT"),oModel:GetModel("CNEDETAIL"):GetValue("CNE_VLTOT")})
						EndIf
					ElseIf cTipo == "F"
						cQry := " SELECT ZZ4_QTINI,ZZ4_VLUNIT FROM "+RetSqlName("ZZ4")
						cQry += " WHERE D_E_L_E_T_ <> '*' "
						cQry += " AND ZZ4_CONTRA = '"+cNrContra+"' "
						cQry += " AND ZZ4_PRODUT = '"+cProduto+"' "
						cQry += " AND '"+AllTrim(Str(nQuant))+"' BETWEEN ZZ4_QTINI AND ZZ4_QTFIM "
						cQry := ChangeQuery(cQry)
						DbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), cAliasA, .F., .T.)

						(cAliasA)->(DbGoTop())
						nQtdIni := (cAliasA)->ZZ4_QTINI
						nVlUnit := (cAliasA)->ZZ4_VLUNIT
						(cAliasA)->(DbCloseArea())

						/*
						cQry := " SELECT CNB_ITEM FROM "+RetSqlName("CNB")
						cQry += " WHERE D_E_L_E_T_ <> '*'
						cQry += " AND CNB_CONTRA = '"+cNrContra+"' "
						cQry += " AND CNB_REVISA = '"+cNrRevisa+"' "
						cQry += " AND CNB_NUMERO = '"+cNrPlan+"' "
						cQry += " AND CNB_PRODUT = '"+cProduto+"' "
						cQry += " AND CNB_VLUNIT = '"+AllTrim(Str(nVlUnit))+"'
						cQry := ChangeQuery(cQry)
						DbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), cAliasA, .F., .T.)

						(cAliasA)->(DbGoTop())
						cItem := (cAliasA)->CNB_ITEM
						(cAliasA)->(DbCloseArea())
						*/
						For nX := 1 To oModel:GetModel('CNEDETAIL'):Length()
							oModel:GetModel('CNEDETAIL'):GoLine(nX)
							If oModel:GetModel('CNEDETAIL'):GetValue("CNE_VLUNIT") == nVlUnit
								oModel:SetValue( 'CNEDETAIL' , 'CNE_QUANT'	, nQuant)
								If lSimula
									aAdd(aRelat,{xFilial("CND"),cNrContra,cNrRevisa,SA1->A1_COD,SA1->A1_LOJA,SA1->A1_NOME,cNrPlan,cCompet,oModel:GetModel("CNEDETAIL"):GetValue("CNE_ITEM"),oModel:GetModel("CNEDETAIL"):GetValue("CNE_PRODUT"),oModel:GetModel("CNEDETAIL"):GetValue("CNE_DESCRI"),1,oModel:GetModel("CNEDETAIL"):GetValue("CNE_VLUNIT"),oModel:GetModel("CNEDETAIL"):GetValue("CNE_VLTOT")})
								EndIf
							Else
								oModel:SetValue( 'CNEDETAIL' , 'CNE_QUANT'	, 0)
							EndIf
						Next nX
					ElseIf cTipo == "V"
						cQry := " SELECT ZZ4_VLUNIT FROM "+RetSqlName("ZZ4")
						cQry += " WHERE D_E_L_E_T_ <> '*' "
						cQry += " AND ZZ4_CONTRA = '"+cNrContra+"' "
						cQry += " AND ZZ4_PRODUT = '"+cProduto+"' "
						cQry += " AND '"+AllTrim(Str(nQuant))+"' BETWEEN ZZ4_QTINI AND ZZ4_QTFIM "
						cQry := ChangeQuery(cQry)
						DbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), cAliasA, .F., .T.)

						(cAliasA)->(DbGoTop())
						nVlUnit := (cAliasA)->ZZ4_VLUNIT
						(cAliasA)->(DbCloseArea())

						/*
						cQry := " SELECT CNB_ITEM FROM "+RetSqlName("CNB")
						cQry += " WHERE D_E_L_E_T_ <> '*'
						cQry += " AND CNB_CONTRA = '"+cNrContra+"' "
						cQry += " AND CNB_REVISA = '"+cNrRevisa+"' "
						cQry += " AND CNB_NUMERO = '"+cNrPlan+"' "
						cQry += " AND CNB_PRODUT = '"+cProduto+"' "
						cQry += " AND CNB_VLUNIT = '"+AllTrim(Str(nVlUnit))+"'
						cQry := ChangeQuery(cQry)
						DbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), cAliasA, .F., .T.)

						(cAliasA)->(DbGoTop())
						cItem := (cAliasA)->CNB_ITEM
						(cAliasA)->(DbCloseArea())
						*/
						For nX := 1 To oModel:GetModel('CNEDETAIL'):Length()
							oModel:GetModel('CNEDETAIL'):GoLine(nX)
							If oModel:GetModel('CNEDETAIL'):GetValue("CNE_VLUNIT") == nVlUnit
								oModel:SetValue( 'CNEDETAIL' , 'CNE_QUANT'	, 1)
								If lSimula
									aAdd(aRelat,{xFilial("CND"),cNrContra,cNrRevisa,SA1->A1_COD,SA1->A1_LOJA,SA1->A1_NOME,cNrPlan,cCompet,oModel:GetModel("CNEDETAIL"):GetValue("CNE_ITEM"),oModel:GetModel("CNEDETAIL"):GetValue("CNE_PRODUT"),oModel:GetModel("CNEDETAIL"):GetValue("CNE_DESCRI"),1,oModel:GetModel("CNEDETAIL"):GetValue("CNE_VLUNIT"),oModel:GetModel("CNEDETAIL"):GetValue("CNE_VLTOT")})
								EndIf
							Else
								oModel:SetValue( 'CNEDETAIL' , 'CNE_QUANT'	, 0)
							EndIf
						Next nX

						//oModel:GetModel('CNEDETAIL'):GoLine(val(cItem))
						//oModel:SetValue( 'CNEDETAIL' , 'CNE_QUANT'	, 1)
					EndIf
				Next nY

				If !lSimula
					If (oModel:VldData())  /*Valida o modelo como um todo*/
						oModel:CommitData()
					EndIf

					If(oModel:HasErrorMessage())
						aErro := oModel:GetErrorMessage()
						aLog := {}
						aAdd(aLog,{xFilial("CND"),cNrContra,cNrRevisa,cNrPlan,cCompet,"","",aErro[6]})
						GravaErro(aLog)
					Else
						cNumMed := CND->CND_NUMMED
						oModel:DeActivate()
						lRet := CN121Encerr(.T.) //Realiza o encerramento da medição
						aLog := {}
						aAdd(aLog,{xFilial("CND"),cNrContra,cNrRevisa,cNrPlan,cCompet,cNumMed,"OK",""})
						GravaErro(aLog)
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
Return

Static Function VLDPRDEFV(cNrContra,cNrRevisa,cNrPlan )
	Local cAliasCNB		:= GetNextAlias()
	Local cCNBCONTRA	:= cNrContra
	Local cCNBNUMERO	:= cNrPlan
	Local cCNBREVISA	:= cNrRevisa
	Local cTipoExc		:= '1'
	Local cTipoExc2		:= '3'
	Local aRetorno2		:= {}

	BeginSql Alias cAliasCNB
		COLUMN CN9_DTINIC AS DATE
		COLUMN CN9_DTFIM  AS DATE

		SELECT DISTINCT CNB_CONTRA, CNB_NUMERO, CNB_ITEM, CNB_PRODUT, CNB_QUANT, CNB_VLUNIT, CNB_XQMIN, CNB_XTPREC
		FROM %TABLE:CNB% CNB (NOLOCK) 
		WHERE CNB.%notDel% 
		AND CNB.CNB_FILIAL = %xFilial:CNB%
		AND CNB.CNB_CONTRA = %EXP:cCNBCONTRA%
		AND CNB.CNB_NUMERO = %EXP:cCNBNUMERO%
		AND CNB.CNB_REVISA = %EXP:cCNBREVISA%
		AND CNB.CNB_XPCANC <> %EXP:cTipoExc%
		AND CNB.CNB_XPCANC <> %EXP:cTipoExc2%
		ORDER BY CNB_NUMERO, CNB_ITEM
	EndSql

	//Processando as linhas GetLastQuery()[02]
	DbSelectArea( cAliasCNB )
	(cAliasCNB)->( DbGoTop() )
	ncontaitem := 1
	While (cAliasCNB)->( !Eof() )
		AADD( aRetorno2, { (cAliasCNB)->CNB_PRODUT, strzero(ncontaitem,3) /*(cAliasCNB)->CNB_ITEM*/, (cAliasCNB)->CNB_VLUNIT, (cAliasCNB)->CNB_XQMIN, (cAliasCNB)->CNB_XTPREC })

		ncontaitem++

		(cAliasCNB)->( DbSkip() )
	End
	(cAliasCNB)->( DbCloseArea() )
Return( aRetorno2 )

Static Function MedFIX()
	Local cNumMed	:= ""
	Local cNrContra	:= (cTrbCTR)->CN9_NUMERO
	Local cNrRevisa	:= (cTrbCTR)->CNA_REVISA
	Local cNrPlan	:= (cTrbCTR)->CNA_NUMERO
	Local cCompet	:= SPACE(TAMSX3("CND_COMPET")[1])
	Local cMoeda	:= SPACE(TAMSX3("CND_MOEDA" )[1])
	Local lRet		:= .T.
	Local aLog		:= {}
	Local nX 		:= 0

	cCompet   := Substr(DtoS(dDataDe),5,2)  + "/" + Substr(DtoS(dDataDe),1,4)//Substr(DtoS(CN9->CN9_DTINIC),5,2) + "/" + Substr(DtoS(CN9->CN9_DTINIC),1,4)
	cMoeda    := "01"

	CNA->( DbSetOrder( 01 ) )
	CNA->( DbSeek( xFilial("CNA") + cNrContra + cNrRevisa + cNrPlan ) )

	SA1->( DbSetOrder( 01 ) )
	If !SA1->( DbSeek( xFilial("SA1") + CNA->CNA_CLIENT + CNA->CNA_LOJACL ) )
		aLog := {}
		aAdd(aLog,{xFilial("CND"),cNrContra,cNrRevisa,cNrPlan,cCompet,"","","Cliente/Loja: " + AllTrim(CNA->CNA_CLIENT) + "-" + AllTrim(CNA->CNA_LOJACL) + " Não Localizado"})
		GravaErro(aLog)
		lRet := .F.
	Else
		If SA1->A1_MSBLQL == "1"
			aLog := {}
			aAdd(aLog,{xFilial("CND"),cNrContra,cNrRevisa,cNrPlan,cCompet,"","","Cliente/Loja: " + AllTrim(SA1->A1_COD) + "-" + AllTrim(SA1->A1_LOJA) + " Esta Bloqueado"})
			GravaErro(aLog)
			lRet := .F.
		EndIf
	EndIf

	If lRet
		CN9->(DbSetOrder(1))
		If CN9->( DbSeek( xFilial("CN9") + cNrContra + cNrRevisa ) )
			nCompet  := 0
			aCompets := CtrCompets()
			nCompet := aScan(aCompets, {|x| AllTrim(x) == cCompet })

			If nCompet == 0
				aLog := {}
				aAdd(aLog,{xFilial("CND"),cNrContra,cNrRevisa,cNrPlan,cCompet,cNumMed,"Competencia nao encontrada",""})
				GravaErro(aLog)
				Return
			EndIf

			oModel := FWLoadModel("CNTA121")
			oModel:SetOperation(MODEL_OPERATION_INSERT)
			If(oModel:CanActivate())
				oModel:Activate()
				oModel:SetValue("CNDMASTER","CND_CONTRA"    , CN9->CN9_NUMERO)
				oModel:SetValue("CNDMASTER","CND_RCCOMP"    , cValToChar(nCompet))
				oModel:SetValue("CNDMASTER","CND_XPERIO"    , 'Periodo de '+Substr(DtoS(dDataDe),7,2) + "/" + Substr(DtoS(dDataDe),5,2) + "/" + Substr(DtoS(dDataDe),1,4)+ ' até '+Substr(DtoS(dDataAte),7,2) + "/" + Substr(DtoS(dDataAte),5,2) + "/" + Substr(DtoS(dDataAte),1,4)      )
				oModel:SetValue("CNDMASTER","CND_XCLINM"    , AllTrim(SA1->A1_NOME)       )
				oModel:SetValue("CNDMASTER","CND_XNOMRE"    , AllTrim(SA1->A1_NREDUZ)       )

				aPlan := {}
				For nX := 1 To oModel:GetModel("CXNDETAIL"):Length()
					oModel:GetModel("CXNDETAIL"):GoLine(nX)
					aAdd(aPlan,Val(oModel:GetModel("CXNDETAIL"):GetValue("CXN_NUMPLA")))
				Next nX
				nPosPl := 0
				nPosPl := aScan(aPlan, {|x| x == Val(AllTrim(cNrPlan)) })

				If nPosPl == 0
					aLog := {}
					aAdd(aLog,{xFilial("CND"),cNrContra,cNrRevisa,cNrPlan,cCompet,cNumMed,"Planilha nao encontrada",""})
					GravaErro(aLog)
					Return
				EndIf

				oModel:GetModel("CXNDETAIL"):GoLine(nPosPl)
				oModel:SetValue("CXNDETAIL","CXN_CHECK" , .T.)

				For nX := 1 To oModel:GetModel("CNEDETAIL"):Length() 
					oModel:GetModel("CNEDETAIL"):GoLine(nX)
					//CNB->(DbSetOrder(1))
					CNB->(DbSetOrder(1))
					If CNB->( DbSeek( xFilial("CNB") + cNrContra + cNrRevisa + cNrPlan) )
						While cNrContra + cNrRevisa == CNB->CNB_CONTRA + CNB->CNB_REVISA .AND. !Eof()
							If oModel:GetModel("CNEDETAIL"):GetValue("CNE_PRODUT") == CNB->CNB_PRODUT .And. oModel:GetModel("CNEDETAIL"):GetValue("CNE_ITEM") == CNB->CNB_ITEM
								If CNB->CNB_XPCANC $ "1/3"    // Valdemir Rabelo 19/12/2024
									oModel:SetValue( 'CNEDETAIL' , 'CNE_QUANT'  , 0)
								Else
									oModel:SetValue( 'CNEDETAIL' , 'CNE_QUANT'  , 1)
									If lSimula
										aAdd(aRelat,{xFilial("CND"),cNrContra,cNrRevisa,SA1->A1_COD,SA1->A1_LOJA,SA1->A1_NOME,cNrPlan,cCompet,oModel:GetModel("CNEDETAIL"):GetValue("CNE_ITEM"),oModel:GetModel("CNEDETAIL"):GetValue("CNE_PRODUT"),oModel:GetModel("CNEDETAIL"):GetValue("CNE_DESCRI"),1,oModel:GetModel("CNEDETAIL"):GetValue("CNE_VLTOT"),oModel:GetModel("CNEDETAIL"):GetValue("CNE_VLTOT")})
									EndIf
								EndIf
							EndIf
							CNB->(DbSkip())
						end
					EndIf
				Next nX

				If !lSimula
					If (oModel:VldData())  /*Valida o modelo como um todo*/
						oModel:CommitData()
					EndIf

					If(oModel:HasErrorMessage())
						aErro := oModel:GetErrorMessage()
						aLog := {}
						aAdd(aLog,{xFilial("CND"),cNrContra,cNrRevisa,cNrPlan,cCompet,"","",aErro[6]})
						GravaErro(aLog)
					Else
						cNumMed := CND->CND_NUMMED
						oModel:DeActivate()
						lRet := CN121Encerr(.T.) //Realiza o encerramento da medição
						aLog := {}
						aAdd(aLog,{xFilial("CND"),cNrContra,cNrRevisa,cNrPlan,cCompet,cNumMed,"OK",""})
						GravaErro(aLog)
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
Return
