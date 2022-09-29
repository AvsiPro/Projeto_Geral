#INCLUDE "TECR480.CH"
#INCLUDE "REPORT.CH"

#DEFINE CHRCOMP If(aReturn[4]==1,15,18)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³TECR480   ³ Autor ³ Eduardo Riera         ³ Data ³ 07.10.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Relacao de Servicos 						                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³17/08/2006³Cleber M.      ³Bops 99267: Conversao para relatorio perso- ³±±
±±³          ³               ³nalizavel (Release 4).                      ³±±
±±³16/02/2007³Conrado Quilles³Bops 119542: Retirado ajuste no SX1.        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function TECR480()
Local oReport				//Objeto do relatorio personalizavel
Local aArea := GetArea()	//Guarda a area atual

If cEmpAnt == "10"
	return
EndIf

If !FindFunction("TRepInUse") .OR. !TRepInUse()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Executa versao anterior do fonte³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	TECR480R3()
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³                       PARAMETROS                                       ³
	//³                                                                        ³
	//³ MV_PAR01 : Nr.OS de       ?                                            ³
	//³ MV_PAR02 : Nr.OS Ate      ?                                            ³
	//³ MV_PAR03 : Data Inicio de ?                                            ³
	//³ MV_PAR04 : Data Inicio Ate?                                            ³
	//³ MV_PAR05 : Cliente de     ?                                            ³
	//³ MV_PAR06 : Cliente ate    ?                                            ³
	//³ MV_PAR07 : Tecnico de     ?                                            ³
	//³ MV_PAR08 : Tecnico Ate    ?                                            ³
	//³ MV_PAR09 : Produto de     ?                                            ³
	//³ MV_PAR10 : Produto ate    ?                                            ³
	//³ MV_PAR11 : Lista Quais    ? Atendido / Em Atendimento / Ambos          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Pergunte("ATR480",.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport := Tcr480RptDef()
	oReport:PrintDialog()
EndIf

RestArea( aArea )
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³Tcr480RptDef ºAutor  ³Cleber Martinez     º Data ³  17/08/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para informar as celulas que serao utilizadas no rela-  º±±
±±º          ³latorio                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TECR480 R4                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Tcr480RptDef()
Local oReport			// Objeto do relatorio
Local oSection1			// Objeto da secao 1
Local aOrdem	:=	{STR0005,STR0006,STR0007,STR0008}  //"OS"###"Tecnico"###"Cliente"###"Problema"
Local cAlias1	:= ""	// Pega o proximo Alias Disponivel

#IFDEF TOP
	cAlias1	:= GetNextAlias()
#ELSE 
	cAlias1	:= "AB9"
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define a criacao do objeto oReport  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE REPORT oReport NAME "TECR480" TITLE STR0001 PARAMETER "ATR480" ACTION {|oReport| Tcr480PrtRpt(oReport, aOrdem, cAlias1)} DESCRIPTION STR0002 + STR0003 + STR0004
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define a secao1 do relatorio  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFINE SECTION oSection1 OF oReport TITLE STR0032 TABLES "AB9","AB6","AB7","AAG","SA1","AA1","AB1","SZG" ORDERS aOrdem // "Serviços técnicos"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Define as celulas que irao aparecer na secao1  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		DEFINE CELL NAME "AB7_NUMOS" 	OF oSection1 ALIAS "AB7"
		DEFINE CELL NAME "AB7_ITEM" 	OF oSection1 ALIAS "AB7"
		DEFINE CELL NAME "AB9_SEQ" 		OF oSection1 ALIAS "AB9"
		DEFINE CELL NAME "AB9_CODTEC" 	OF oSection1 ALIAS "AB9"
		DEFINE CELL NAME "AA1_NOMTEC" 	OF oSection1 ALIAS "AA1"	// adicionado Jackson 18/12/2014
		DEFINE CELL NAME "AB9_CODCLI" 	OF oSection1 ALIAS "AB9"
		DEFINE CELL NAME "A1_NOME"	 	OF oSection1 ALIAS "SA1"	// adicionado Jackson 18/12/2014
		DEFINE CELL NAME "AB9_CODPRO" 	OF oSection1 ALIAS "AB9"
		DEFINE CELL NAME "AB9_XPATRI" 	OF oSection1 ALIAS "AB9"	// adicionado Jackson 18/12/2014
		DEFINE CELL NAME "AB1_NUMTMK" 	OF oSection1 ALIAS "AB1"	// adicionado Jackson 18/12/2014
		DEFINE CELL NAME "dDtAbert" 	OF oSection1 ALIAS " "  TITLE "Data abertura" ALIGN RIGHT	// adicionado Jackson 15/01/2015
		DEFINE CELL NAME "cHrAbert" 	OF oSection1 ALIAS " "  TITLE "Hora abertura" ALIGN RIGHT	// adicionado Jackson 15/01/2015
		DEFINE CELL NAME "nHrTotx"		OF oSection1 ALIAS " "  TITLE "Tempo até inicio at. tecnico" ALIGN RIGHT // adicionado Jackson 19/12/2014 
		DEFINE CELL NAME "AB9_DTCHEG" 	OF oSection1 ALIAS "AB9"
		DEFINE CELL NAME "AB9_HRCHEG" 	OF oSection1 ALIAS "AB9"
		DEFINE CELL NAME "AB9_DTINI" 	OF oSection1 ALIAS "AB9"
		DEFINE CELL NAME "AB9_HRINI" 	OF oSection1 ALIAS "AB9"
		DEFINE CELL NAME "AB9_DTFIM" 	OF oSection1 ALIAS "AB9"
		DEFINE CELL NAME "AB9_HRFIM" 	OF oSection1 ALIAS "AB9" 
		DEFINE CELL NAME "AB9_DTSAID" 	OF oSection1 ALIAS "AB9" 
		DEFINE CELL NAME "AB9_HRSAID" 	OF oSection1 ALIAS "AB9" 
		DEFINE CELL NAME "AB9_TRASLA" 	OF oSection1 ALIAS "AB9" ALIGN RIGHT
		DEFINE CELL NAME "nHrTotal2" 	OF oSection1 ALIAS " "  TITLE STR0030 ALIGN RIGHT //"Total Horas"
		DEFINE CELL NAME "nHrIniFim"	OF oSection1 ALIAS " "  TITLE "Tempo entre abertura e finalizacao" ALIGN RIGHT // adicionado Jackson 19/12/2014 		
		DEFINE CELL NAME "AB9_CODPRB" 	OF oSection1 ALIAS "AB9" 
		DEFINE CELL NAME "AAG_DESCRI" 	OF oSection1 ALIAS "AAG" 
		DEFINE CELL NAME "AB9_TIPO" 	OF oSection1 ALIAS "AB9" 
		DEFINE CELL NAME "AB7_MEMO1" 	OF oSection1 ALIAS "AB7" SIZE 170 TITLE "Problema"	 BLOCK {|| AllTrim(MSMM(AB7->AB7_MEMO1)) }	//"Laudo"
		DEFINE CELL NAME "AB9_MEMO1" 	OF oSection1 ALIAS "AB9" SIZE 170 TITLE STR0031 BLOCK {|| AllTrim(MSMM((cAlias1)->AB9_MEMO1)) }	//"Laudo"
		DEFINE CELL NAME "AB1_NRCHAM" 	OF oSection1 ALIAS "AB1"	// adicionado Jackson 18/12/2014
		DEFINE CELL NAME "AB9_XOSMOB" 	OF oSection1 ALIAS "AB9"	// adicionado Jackson 18/12/2014
		DEFINE CELL NAME "ZG_DESCFRM" 	OF oSection1 ALIAS "SZG"	// adicionado Jackson 18/12/2014
		DEFINE CELL NAME "ZG_RESPOST" 	OF oSection1 ALIAS "SZG"	// adicionado Jackson 18/12/2014
		
		oSection1:SetLineBreak()	                    
		oSection1:SetHeaderPage(.T.)
				
Return oReport
  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³Tcr480PrtRptºAutor  ³Cleber Martinez     º Data ³  15/08/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para impressao do relatorio personalizavel             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³Nenhum                                                      	º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³oReport: Objeto TReport do relatorio personalizavel        	º±±
±±º          ³aOrdem:  Array com as ordens de impressao disponiveis      	º±±
±±º          ³cAlias1: Alias principal do relatorio                      	º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TECR480 R4                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Tcr480PrtRpt( oReport, aOrdem, cAlias1 )
Local oSection1 := oReport:Section(1)				// Define a secao 1 do relatorio
Local lImp    	:= .F. 								// Indica se algo foi impresso
Local lImpAb9   := .F. 								// Indica se algo foi impresso
Local nHrTotal1 := 0								// Total de horas de traslado
Local nHrTotal2 := 0								// Total de horas da chegada ate a saida
Local nHrTotal3 := 0								// Total de horas do inicio ate o termino do servico
Local aTotal    := { 0 , 0 , 0 , 0 , 0 , 0}		// Array com os totalizadores
Local nLoop     := 0 								// Usada em For...Next
Local aTotOcor  := {}								// Array com totalizador por Ocorrencia
Local nPosOcor  := 0 								// Posicao da Ocorrencia no array
Local nOrdem 	:= 1								// Ordem definida pelo usuario
Local cOrderBy	:= ""								// Chave de ordenacao
Local cIndexKey := ""								// Indice do filtro (CodeBase)
Local cQuebra 	:= ""								// Conteudo da quebra do relatorio
Local cFiltro	:= ""								// Filtro da tabela (CodeBase)
Local nLin 		:= 0								// Guarda a linha atual impressa
Local cHoraForm := ""                               // Guarda a hora formatada
Local nHrTotx	:= 0								// total horas do inicio do chamado tmk ate o inicio do atendimento (laudo)
Local cHrFrm	:= ""
Local dDtIniChm	:= stod("")
Local cHrIniChm := ""
Local nHrIniFim := 0 
Local dDtAbert  := stod("")
Local cHrAbert	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pega a ordem escolhida pelo usuario ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem := oSection1:GetOrder() 
If nOrdem <= 0
	nOrdem := 1
EndIf

Do Case
	Case ( nOrdem == 1 ) 
		// [ ORDEM DE SERVICO ] 
		cOrderBy := "% AB9_FILIAL,AB9_NUMOS,AB9_SEQ,AB9_DTINI %"
		cIndexKey := "AB9_FILIAL+AB9_NUMOS+AB9_SEQ+DTOS(AB9_DTINI)"
	Case ( nOrdem == 2 )
		// [ TECNICO ] 
		cOrderBy := "% AB9_FILIAL,AB9_CODTEC,AB9_DTINI %"
		cIndexKey := "AB9_FILIAL+AB9_CODTEC+DTOS(AB9_DTINI)"
	Case ( nOrdem == 3 ) 
		// [ CLIENTE ]   
		cOrderBy := "% AB9_FILIAL,AB9_CODCLI,AB9_DTINI %"
		cIndexKey := "AB9_FILIAL+AB9_CODCLI+DTOS(AB9_DTINI)"
	Case ( nOrdem == 4 ) 
		// [ OCORRENCIA ] 
		cOrderBy := "% AB9_FILIAL,AB9_CODPRB,AB9_DTINI %"
		cIndexKey := "AB9_FILIAL+AB9_CODPRB+DTOS(AB9_DTINI)"
EndCase

#IFDEF TOP
	DbSelectArea("AB9") 
	DbSetOrder(1)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Transforma parametros do tipo Range em expressao SQL para ser utilizada na query ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MakeSqlExpr("ATR480")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicializa a secao 1³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	BEGIN REPORT QUERY oSection1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query da secao1 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	BeginSql alias cAlias1
		SELECT	AB9_FILIAL,	AB9_SEQ,	AB9_CODTEC, AB9_CODCLI,
				AB9_CODPRO,	AB9_DTCHEG,	AB9_HRCHEG, AB9_DTINI,
				AB9_HRINI,	AB9_DTFIM,	AB9_HRFIM,	AB9_DTSAID,
				AB9_HRSAID,	AB9_TRASLA,	AB9_CODPRB,	AB9_MEMO1,
				AB9_NUMOS,	AB9_TIPO, AB9_XOSMOB,	AB9_XPATRI	//, AA1_NOMTEC, A1_NOME
		
		FROM %table:AB9% AB9	//, %table:AA1% AA1, %table:SA1% SA1
		
		WHERE	AB9_FILIAL = %xfilial:AB9%		AND
				AB9_NUMOS >= %exp:mv_par01%		AND  
				AB9_NUMOS <= %exp:mv_par02+"zz"%		AND
				AB9_DTINI >= %exp:DtoS(mv_par03)%		AND
				AB9_DTINI <= %exp:DtoS(mv_par04)%		AND
				AB9_CODCLI >= %exp:mv_par05%	AND
				AB9_CODCLI <= %exp:mv_par06%	AND
				AB9_CODTEC >= %exp:mv_par07%	AND
				AB9_CODTEC <= %exp:mv_par08%	AND
				AB9_CODPRO >= %exp:mv_par09%	AND
				AB9_CODPRO <= %exp:mv_par10%	AND
				AB9.%notDel%
				//AB9_CODTEC = AA1_CODTEC	AND
				//AB9_CODCLI = A1_COD	AND
				//AB9.%notDel% AND
				//SA1.%notDel% AND
				//AA1.%notDel%

		ORDER BY %exp:cOrderBy%
	EndSql
	
	END REPORT QUERY oSection1 

#ELSE

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Utilizar a funcao MakeAdvlExpr, somente quando for utilizar o range de parametros³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MakeAdvplExpr("ATR480")

	DbSelectArea( cAlias1 ) 
	DbSetOrder(1)
    
	cFiltro := "AB9_FILIAL=='"+xFilial("AB9")+"'.AND."
	cFiltro += "AB9_NUMOS>='"+MV_PAR01+"'.AND."
	cFiltro += "AB9_NUMOS<='"+MV_PAR02+"zz'.AND."
	cFiltro += "DTOS(AB9_DTINI)>='"+DTOS(MV_PAR03)+"'.AND."
	cFiltro += "DTOS(AB9_DTINI)<='"+DTOS(MV_PAR04)+"'.AND."
	cFiltro += "AB9_CODCLI>='"+MV_PAR05+"'.AND."
	cFiltro += "AB9_CODCLI<='"+MV_PAR06+"'.AND."
	cFiltro += "AB9_CODTEC>='"+MV_PAR07+"'.AND."
	cFiltro += "AB9_CODTEC<='"+MV_PAR08+"'"
	cFiltro += ".AND. AB9_CODPRO>='"+MV_PAR09+"'.AND. "
	cFiltro += "AB9_CODPRO<='"+MV_PAR10+"'"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Efetua o filtro de acordo com a expressao do arquivo AB9 (Atendimento da OS)						 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSection1:SetFilter( cFiltro, cIndexKey )

#ENDIF	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona a ordem escolhida ao titulo do relatorio          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetTitle(oReport:Title() + Space(05) + "[ " + AllTrim(Upper(aOrdem[nOrdem])) + " ]" )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Executa a impressao dos dados, de acordo com o filtro ou query³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetMeter((cAlias1)->(LastRec()))
DbSelectArea(cAlias1)

oSection1:Init()

While !oReport:Cancel() .AND. !(cAlias1)->(Eof())

	oReport:IncMeter()
	If oReport:Cancel()
		Exit
	EndIf

	If ( 	(cAlias1)->AB9_CODPRO >= MV_PAR09 .AND.;
			(cAlias1)->AB9_CODPRO <= MV_PAR10 .AND.;
			If(MV_PAR11==1, (cAlias1)->AB9_TIPO=="1", .T.) .AND.;
			If(MV_PAR11==2, (cAlias1)->AB9_TIPO!="1", .T.) )
	
		Do Case
			Case ( nOrdem == 2 )
				cQuebra := (cAlias1)->AB9_CODTEC
			Case ( nOrdem == 3 )
				cQuebra := (cAlias1)->AB9_CODCLI
			Case ( nOrdem == 4 )
				cQuebra := (cAlias1)->AB9_CODPRB
		EndCase
		
		dbSelectArea("AB7")
		dbSetOrder(1)
		MsSeek(xFilial("AB7")+(cAlias1)->AB9_NUMOS)
		
		dbSelectArea("AB6")
		dbSetOrder(1)
		MsSeek(xFilial("AB6")+AB7->AB7_NUMOS)
		
		dbSelectArea("AAG")
		dbSetOrder(1)
		MsSeek(xFilial("AAG")+(cAlias1)->AB9_CODPRB)
		
		dbSelectArea("AA1")
		dbSetOrder(1)
		MsSeek( xFilial("AA1")+(cAlias1)->AB9_CODTEC )
		
		dbSelectArea("SA1")
		dbSetOrder(1)
		MsSeek( xFilial("SA1")+AB7->AB7_CODCLI +AB7->AB7_LOJA )
		
		dbSelectArea("SZG")
		dbSetOrder(1)
		MsSeek( xFilial("SZG")+(cAlias1)->AB9_XOSMOB )
		
		dbSelectArea("AB1")
		dbSetOrder(1)
		MsSeek( xFilial("AB2") +Substr(AB7->AB7_NRCHAM,1,8) )
		
		// CALL CENTER / CHAMADO TECNICO
		If !Empty(AB1->AB1_NUMTMK)
			dbSelectArea("SUC")
			dbSetOrder(1)
			If dbSeek( xFilial("SUC") +AB1->AB1_NUMTMK ) 
				dDtIniChm := SUC->UC_DATA
				cHrIniChm := SUC->UC_INICIO
			EndIf                          
		// pega data e hora do chamado tecnico
		Else
			dDtIniChm := AB1->AB1_EMISSA
			cHrIniChm := AB1->AB1_HORA	
		EndIf
		
		dDtAbert := dDtIniChm
		cHrAbert := cHrIniChm	
		
		oSection1:Cell("dDtAbert"):SetValue(DTOC(dDtAbert))

		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calcula as horas e atualiza o valor das celulas ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nHrTotal1 := SubtHoras(dDataBase,"00:00",dDataBase,(cAlias1)->AB9_TRASLA)
		nHrTotal2 := SubtHoras((cAlias1)->AB9_DTCHEG,(cAlias1)->AB9_HRCHEG,(cAlias1)->AB9_DTSAID,(cAlias1)->AB9_HRSAID)
		nHrTotal3 := SubtHoras((cAlias1)->AB9_DTINI,(cAlias1)->AB9_HRINI,(cAlias1)->AB9_DTFIM,(cAlias1)->AB9_HRFIM)
		nHrTotx := SubtHoras(dDtIniChm, cHrIniChm,(cAlias1)->AB9_DTINI,(cAlias1)->AB9_HRINI )	// total horas do chamado tmk ate o inicio do atendimento
		nHrIniFim := SomaHoras(nHrTotx,nHrTotal2)	// total horas do chamado tmk ate a finalizacao do atendimento
		 
		If mv_par13 == 1
			oSection1:Cell("cHrAbert"):SetValue(Transform(cHrAbert,TM(cHrAbert,8)))
			
			oSection1:Cell("nHrTotal2"):SetValue(Transform(nHrTotal2,TM(nHrTotal2,8)))
			oSection1:Cell("nHrTotx"):SetValue(Transform(nHrTotx,TM(nHrTotx,8)))
			oSection1:Cell("nHrIniFim"):SetValue(Transform(nHrIniFim,TM(nHrIniFim,8)))
		Else
			oSection1:Cell("cHrAbert"):SetValue(cHrAbert)
			                                   
			cHoraForm := LimpaZeros(IntToHora(nHrTotal2,6))
			oSection1:Cell("nHrTotal2"):SetValue(cHoraForm)

			cHrFrm := LimpaZeros(IntToHora(nHrTotx,6))
			oSection1:Cell("nHrTotx"):SetValue(cHrFrm)
			
			cHrTotX := LimpaZeros(IntToHora(nHrIniFim,6))
			oSection1:Cell("nHrIniFim"):SetValue(cHrTotX)		
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime a secao 1 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        oSection1:PrintLine()
		
		lImp 	:= .T.
		lImpAb9 := .T.
		           
		aTotal[1] += nHrTotal1
		aTotal[2] += nHrTotal1
		aTotal[3] += nHrTotal2
		aTotal[4] += nHrTotal2
		aTotal[5] += nHrTotal3
		aTotal[6] += nHrTotal3
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Incrementa o total por ocorrencia ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Empty( nPosOcor := AScan( aTotOcor, { |x| x[1] == AAG->AAG_CODPRB } ) ) 
			AAdd( aTotOcor, { AAG->AAG_CODPRB, AAG->AAG_DESCRI, nHrTotal1, nHrTotal2, nHrTotal3 } )
		Else
			aTotOcor[ nPosOcor, 3 ] += nHrTotal1
			aTotOcor[ nPosOcor, 4 ] += nHrTotal2
			aTotOcor[ nPosOcor, 5 ] += nHrTotal3		
		EndIf 		
		
	EndIf	
	dbSelectArea(cAlias1)
	dbSkip()
	    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime os Totais por Quebra ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Do Case
		Case ( nOrdem == 2 )
			If ( cQuebra != (cAlias1)->AB9_CODTEC .AND. lImpAb9 )

				dbSelectArea("AA1")
				dbSetOrder(1)
				MsSeek(xFilial("AA1")+cQuebra)
				
				oReport:SkipLine()
				nLin := oReport:Row()
				oReport:PrintText( STR0018+cQuebra+" "+AA1->AA1_NOMTEC, nLin  ) //"TOTAL DO TECNICO: "
				
				If mv_par13 == 1
					oReport:PrintText( Transform(aTotal[1], TM(aTotal[1],5)), nLin, oSection1:Cell("AB9_TRASLA"):ColPos() )
					oReport:PrintText( Transform(aTotal[3], TM(aTotal[3],8)), nLin, oSection1:Cell("nHrTotal2"):ColPos() )				
				Else  
					oReport:PrintText( InttoHora(aTotal[1],2), nLin, oSection1:Cell("AB9_TRASLA"):ColPos() )
					cHoraForm := LimpaZeros(IntToHora(aTotal[3],6))
					oReport:PrintText(cHoraForm, nLin, oSection1:Cell("nHrTotal2"):ColPos() )				
				EndIf	
					
				If mv_par13 == 1
					oReport:PrintText( STR0019 + " " + Transform(aTotal[5], TM(aTotal[5],8)), nLin, oSection1:Cell("AB9_CODPRB"):ColPos() )	//"HORAS UTEIS"
				Else
				   cHoraForm := LimpaZeros(IntToHora(aTotal[5],6))
				   oReport:PrintText( STR0019 + " " + cHoraForm, nLin, oSection1:Cell("AB9_CODPRB"):ColPos() )	//"HORAS UTEIS"	
				EndIf
				oReport:SkipLine()
				oReport:SkipLine()
				
				aTotal[1] := 0
				aTotal[3] := 0
				aTotal[5] := 0
				lImpAb9 	:= .F.
			EndIf
		Case ( nOrdem == 3 )
			If ( cQuebra != (cAlias1)->AB9_CODCLI .AND. lImpAb9)

				dbSelectArea("SA1")
				dbSetOrder(1)
				MsSeek(xFilial("SA1")+cQuebra)
				
				oReport:SkipLine()
				nLin := oReport:Row()
				oReport:PrintText( STR0020+cQuebra+" "+SA1->A1_NOME, nLin  ) //"TOTAL DO CLIENTE: "
								
				If mv_par13 == 1
					oReport:PrintText( Transform(aTotal[1], TM(aTotal[1],5)), nLin, oSection1:Cell("AB9_TRASLA"):ColPos() )
					oReport:PrintText( Transform(aTotal[3], TM(aTotal[3],8)), nLin, oSection1:Cell("nHrTotal2"):ColPos() )				
				Else
					oReport:PrintText( InttoHora(aTotal[1],2), nLin, oSection1:Cell("AB9_TRASLA"):ColPos() )
					cHoraForm := LimpaZeros(IntToHora(aTotal[3],6))
					oReport:PrintText(cHoraForm, nLin, oSection1:Cell("nHrTotal2"):ColPos() )
				EndIf	                                  
                
				If mv_par13 == 1				
					oReport:PrintText( STR0021 + " " + Transform(aTotal[5], TM(aTotal[5],8)), nLin, oSection1:Cell("AB9_CODPRB"):ColPos() )	//"HORAS UTEIS"
				Else  
				   cHoraForm := LimpaZeros(IntToHora(aTotal[5],6))
				   oReport:PrintText( STR0021 + " " + cHoraForm, nLin, oSection1:Cell("AB9_CODPRB"):ColPos() )	//"HORAS UTEIS"	
				EndIf
				oReport:SkipLine()
				oReport:SkipLine()
				
				aTotal[1] := 0
				aTotal[3] := 0
				aTotal[5] := 0
				lImpAb9 	:= .F.
			EndIf
		Case ( nOrdem == 4 )
			If ( cQuebra != (cAlias1)->AB9_CODPRB .AND. lImpAb9)
				dbSelectArea("AAG")
				dbSetOrder(1)
				MsSeek(xFilial("AAG")+cQuebra)

				oReport:SkipLine()
				nLin := oReport:Row()
				oReport:PrintText( STR0022+cQuebra+" "+AAG->AAG_DESCRI, nLin  ) //"TOTAL DA OCORRENCIA/PROBLEMA: "
				
				If mv_par13 == 1
					oReport:PrintText( Transform(aTotal[1], TM(aTotal[1],5)), nLin, oSection1:Cell("AB9_TRASLA"):ColPos() )
					oReport:PrintText( Transform(aTotal[3], TM(aTotal[3],8)), nLin, oSection1:Cell("nHrTotal2"):ColPos() )				
				Else
					oReport:PrintText( InttoHora(aTotal[1],2), nLin, oSection1:Cell("AB9_TRASLA"):ColPos() )
					cHoraForm := LimpaZeros(IntToHora(aTotal[3],6))
					oReport:PrintText(cHoraForm, nLin, oSection1:Cell("nHrTotal2"):ColPos() )
				EndIf	        

				If mv_par13 == 1
					oReport:PrintText( STR0023 + " " + Transform(aTotal[5], TM(aTotal[5],8)), nLin, oSection1:Cell("AB9_CODPRB"):ColPos() )	//"HORAS UTEIS"
				Else
					cHoraForm := LimpaZeros(IntToHora(aTotal[5],6))
					oReport:PrintText( STR0023 + " " + cHoraForm, nLin, oSection1:Cell("AB9_CODPRB"):ColPos() )	//"HORAS UTEIS"
				EndIf										
				oReport:SkipLine()
				oReport:SkipLine()
				
				aTotal[1] := 0
				aTotal[3] := 0
				aTotal[5] := 0
				lImpAb9 	:= .F.
			EndIf
	EndCase
	dbSelectArea(cAlias1)
End
oSection1:Finish()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime o Total Geral e Total por Ocorrencia ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( lImp )
	oReport:SkipLine()
	oReport:ThinLine()
	nLin := oReport:Row()
	oReport:PrintText( STR0024, nLin  ) //"TOTAL GERAL"

	If mv_par13 == 1
		oReport:PrintText( Transform(aTotal[2], TM(aTotal[2],5)), nLin, oSection1:Cell("AB9_TRASLA"):ColPos() )
		oReport:PrintText( Transform(aTotal[4], TM(aTotal[4],8)), nLin, oSection1:Cell("nHrTotal2"):ColPos() )				
	Else
		oReport:PrintText( InttoHora(aTotal[2],2), nLin, oSection1:Cell("AB9_TRASLA"):ColPos() )   
        cHoraForm := LimpaZeros(IntToHora(aTotal[4],6))
		oReport:PrintText( cHoraForm, nLin, oSection1:Cell("nHrTotal2"):ColPos() )  	
	EndIf	        

	If mv_par13 == 1				
		oReport:PrintText( STR0025+" "+Transform(aTotal[6], TM(aTotal[6],8)), nLin, oSection1:Cell("AB9_CODPRB"):ColPos() )	//"HORAS UTEIS"	
	Else
		cHoraForm := LimpaZeros(IntToHora(aTotal[6],6))
		oReport:PrintText( STR0025+" "+ cHoraForm, nLin, oSection1:Cell("AB9_CODPRB"):ColPos() )	//"HORAS UTEIS"
	EndIf							
				
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Lista os totais por ocorrencia ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:SkipLine()
	oReport:SkipLine()
	oReport:PrintText( STR0028 ) //"TOTAL POR OCORRENCIA"
	oReport:SkipLine()
		
	ASort( aTotOcor, , , { |x,y| y[1] > x[1] } ) 
	
	For nLoop := 1 to Len( aTotOcor ) 	
		                   
		nLin := oReport:Row()
		        
		oReport:PrintText( aTotOcor[nLoop,1] + "-" + Left(aTotOcor[nLoop,2], 30), nLin, oSection1:Cell("AB9_DTFIM"):ColPos() )
        
		If mv_par13 == 1
			oReport:PrintText( Transform(aTotOcor[nLoop,3], TM(aTotOcor[nLoop,3], 5)), nLin, oSection1:Cell("AB9_TRASLA"):ColPos() )	
			oReport:PrintText( Transform(aTotOcor[nLoop,4], TM(aTotOcor[nLoop,4], 8)), nLin, oSection1:Cell("nHrTotal2"):ColPos() )	
		Else
			oReport:PrintText( IntToHora(aTotOcor[nLoop,3],2), nLin, oSection1:Cell("AB9_TRASLA"):ColPos() )
			cHoraForm := LimpaZeros(IntToHora(aTotOcor[nLoop,4],6))
			oReport:PrintText( cHoraForm, nLin, oSection1:Cell("nHrTotal2"):ColPos() )
		EndIf	        
	
		If mv_par13 == 1				
			oReport:PrintText( STR0025 + " " + Transform(aTotOcor[nLoop,5], TM(aTotOcor[nLoop,5],8)), nLin, oSection1:Cell("AB9_CODPRB"):ColPos() )	//"HORAS UTEIS"
		Else  
			cHoraForm := (LimpaZeros(IntToHora(aTotOcor[nLoop,5],6)))
			oReport:PrintText( STR0025 + " " + cHoraForm, nLin, oSection1:Cell("AB9_CODPRB"):ColPos() )	//"HORAS UTEIS"	
		EndIf
	
        oReport:SkipLine()
	
	Next nLoop
	
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³TECR480R3 ³ Autor ³ Eduardo Riera         ³ Data ³ 07.10.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relacao de Ordem de Servico por Produto                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³16/02/2007³Conrado Quilles³Bops 119542: Retirado ajuste no SX1.        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function TECR480R3()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define Variaveis                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local Titulo  := OemToAnsi(STR0001) //"Relacao de Servicos"  // Titulo do Relatorio
Local cDesc1  := OemToAnsi(STR0002) //"   Este programa ira imprimir a Relacao dos Servicos efetuados analisando "  // Descricao 1
Local cDesc2  := OemToAnsi(STR0003) //"os tempos de atendimento , conforme os parametros solicitados."  // Descricao 2
Local cDesc3  := OemToAnsi(STR0004) //""  // Descricao 3
Local cString := "AB9"  // Alias utilizado na Filtragem
Local lDic    := .F. // Habilita/Desabilita Dicionario
Local lComp   := .F. // Habilita/Desabilita o Formato Comprimido/Expandido
Local lFiltro := .T. // Habilita/Desabilita o Filtro
Local wnrel   := "TECR480"  // Nome do Arquivo utilizado no Spool
Local nomeprog:= "TECR480"  // nome do programa

Private Tamanho := "G" // P/M/G
Private Limite  := 220 // 80/132/220
Private aOrdem  := {STR0005,STR0006,STR0007,STR0008}  //"OS"###"Tecnico"###"Cliente"###"Problema"
Private cPerg   := "ATR480"  // Pergunta do Relatorio
Private aReturn := { STR0009, 1,STR0010, 1, 2, 1, "",1 } //"Zebrado"###"Administracao"
						//[1] Reservado para Formulario
						//[2] Reservado para N§ de Vias
						//[3] Destinatario
						//[4] Formato => 1-Comprimido 2-Normal
						//[5] Midia   => 1-Disco 2-Impressora
						//[6] Porta ou Arquivo 1-LPT1... 4-COM1...
						//[7] Expressao do Filtro
						//[8] Ordem a ser selecionada
						//[9]..[10]..[n] Campos a Processar (se houver)
Private lEnd    := .F.// Controle de cancelamento do relatorio
Private m_pag   := 1  // Contador de Paginas
Private nLastKey:= 0  // Controla o cancelamento da SetPrint e SetDefault

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica as Perguntas Seleciondas                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                       PARAMETROS                                       ³
//³                                                                        ³
//³ MV_PAR01 : Nr.OS de       ?                                            ³
//³ MV_PAR02 : Nr.OS Ate      ?                                            ³
//³ MV_PAR03 : Data Inicio de ?                                            ³
//³ MV_PAR04 : Data Inicio Ate?                                            ³
//³ MV_PAR05 : Cliente de     ?                                            ³
//³ MV_PAR06 : Cliente ate    ?                                            ³
//³ MV_PAR07 : Tecnico de     ?                                            ³
//³ MV_PAR08 : Tecnico Ate    ?                                            ³
//³ MV_PAR09 : Produto de     ?                                            ³
//³ MV_PAR10 : Produto ate    ?                                            ³
//³ MV_PAR11 : Lista Quais    ? Atendido / Em Atendimento / Ambos          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia para a SetPrinter                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,lDic,aOrdem,lComp,Tamanho,lFiltro)
If ( nLastKey==27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	Set Filter to
	Return
Endif
SetDefault(aReturn,cString)
If ( nLastKey==27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	Set Filter to
	Return
Endif
#IFDEF WINDOWS
	RptStatus({|lEnd| ImpDet(@lEnd,wnRel,cString,nomeprog,Titulo)},Titulo)
#ELSE
	ImpDet(.F.,wnrel,cString,nomeprog,Titulo)
#ENDIF

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ ImpDet   ³ Autor ³ Eduardo Riera         ³ Data ³02.07.1998³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Controle de Fluxo do Relatorio.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ImpDet(lEnd,wnrel,cString,nomeprog,Titulo)

Local li      	:= 100 // Contador de Linhas
Local lImp    	:= .F. // Indica se algo foi impresso
Local lImpAb9   := .F. // Indica se algo foi impresso
Local cbCont  	:= 0   // Numero de Registros Processados
Local cbText  	:= ""  // Mensagem do Rodape
Local cQuebra 	:= Nil  // Quebra
Local cQuery  	:= ""
Local cArqInd 	:= CriaTrab(,.F.)
Local cMemo   	:= ""
Local nHrTotal1 := 0
Local nHrTotal2 := 0
Local nHrTotal3 := 0
Local aTotal    := { 0 , 0 , 0 , 0 , 0 , 0}
Local nMemCount := 0 
Local nLoop     := 0 
Local cLinha    := ""
Local aTotOcor  := {}
Local nPosOcor  := 0 

//
//                                    1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21       22
//                          0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Local cCabec1 := STR0011 //"O.SERVICO SEQ TECNICO CLIENTE   PRODUTO/EQTO    <   CHEGADA    > <    INICIO    > <     FIM      > <     SAIDA    > TRASL    TOTAL PROBLEMA/OCORRENCIA                   LAUDO                                    STATUS"
Local cCabec2 := STR0012 //"                                                DATA       HORA  DATA       HORA  DATA       HORA  DATA       HORA           HORAS"
//                          XXXXXX-XX 999 XXXXXXX XXXXXX-XX XXXXXXXXXXXXXXX 99/99/9999 99:99 99/99/9999 99:99 99/99/9999 99:99 99/99/9999 99:99 99:99 99999999 999999-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXX
dbSelectArea("AB9")
SetRegua(LastRec())
cQuery := "AB9_FILIAL=='"+xFilial("AB9")+"'.AND."
cQuery += "AB9_NUMOS>='"+MV_PAR01+"'.AND."
cQuery += "AB9_NUMOS<='"+MV_PAR02+"zz'.AND."
cQuery += "DTOS(AB9_DTINI)>='"+DTOS(MV_PAR03)+"'.AND."
cQuery += "DTOS(AB9_DTINI)<='"+DTOS(MV_PAR04)+"'.AND."
cQuery += "AB9_CODCLI>='"+MV_PAR05+"'.AND."
cQuery += "AB9_CODCLI<='"+MV_PAR06+"'.AND."
cQuery += "AB9_CODTEC>='"+MV_PAR07+"'.AND."
cQuery += "AB9_CODTEC<='"+MV_PAR08+"'"
#IFDEF TOP
	cQuery += ".AND.AB9_CODPRO>='"+MV_PAR09+"'.AND."
	cQuery += "AB9_CODPRO<='"+MV_PAR10+"'"
#ENDIF	
Do Case
	Case ( aReturn[8] == 1 )
		cChave := "AB9_FILIAL+AB9_NUMOS+AB9_SEQ+DTOS(AB9_DTINI)"
		Titulo += STR0013 //" [ ORDEM DE SERVICO ] "
	Case ( aReturn[8] == 2 )
		cChave := "AB9_FILIAL+AB9_CODTEC+DTOS(AB9_DTINI)"
		Titulo += STR0014 //" [ TECNICO ] "
	Case ( aReturn[8] == 3 )
		cChave := "AB9_FILIAL+AB9_CODCLI+DTOS(AB9_DTINI)"
		Titulo += STR0015 //" [ CLIENTE ] "
	Case ( aReturn[8] == 4 )
		cChave := "AB9_FILIAL+AB9_CODPRB+DTOS(AB9_DTINI)"
		Titulo += STR0016 //" [ OCORRENCIA ] "

EndCase              

aTotOcor := {} 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Esta IndRegua fornece bom desempenho para o TOP e o ADS,³
//³com grande volume de dados.                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IndRegua("AB9",cArqInd,cChave,,cQuery)
dbGotop()
While ( !Eof() ) //IndRegua
	#IFNDEF WINDOWS
		If LastKey() = 286
			lEnd := .T.
		EndIf
	#ENDIF
	If lEnd
		@ Prow()+1,001 PSAY STR0017 //"CANCELADO PELO OPERADOR"
		Exit
	EndIf
	If ( li > 60 )
		li := cabec(Titulo,cCabec1,cCabec2,nomeprog,Tamanho,CHRCOMP)
		li++
	EndIf
	If ( 	AB9->AB9_CODPRO >= MV_PAR09 .AND.;
			AB9->AB9_CODPRO <= MV_PAR10 .AND.;
			If(MV_PAR11==1,AB9->AB9_TIPO=="1",.T.).AND.;
			If(MV_PAR11==2,AB9->AB9_TIPO!="1",.T.) )
		Do Case
			Case ( aReturn[8] == 2 )
				cQuebra := AB9->AB9_CODTEC
			Case ( aReturn[8] == 3 )
				cQuebra := AB9->AB9_CODCLI
			Case ( aReturn[8] == 4 )
				cQuebra := AB9->AB9_CODPRB
		EndCase
		dbSelectArea("AB7")
		dbSetOrder(1)
		MsSeek(xFilial("AB7")+AB9->AB9_NUMOS)
		
		dbSelectArea("AB6")
		dbSetOrder(1)
		MsSeek(xFilial("AB6")+AB7->AB7_NUMOS)
		
		dbSelectArea("AAG")
		dbSetOrder(1)
		MsSeek(xFilial("AAG")+AB9->AB9_CODPRB)
		
		cMemo     := AllTrim(MSMM(AB9->AB9_MEMO1))
		nMemCount := MlCount( cMemo ) 		
		
		nHrTotal1 := SubtHoras(dDataBase,"00:00",dDataBase,AB9->AB9_TRASLA)
		nHrTotal2 := SubtHoras(AB9->AB9_DTCHEG,AB9->AB9_HRCHEG,AB9->AB9_DTSAID,AB9->AB9_HRSAID)
		nHrTotal3 := SubtHoras(AB9->AB9_DTINI,AB9->AB9_HRINI,AB9->AB9_DTFIM,AB9->AB9_HRFIM)
            		
		@ Li,000 PSAY AB7->AB7_NUMOS+"-"+AB7->AB7_ITEM
		@ Li,010 PSAY AB9->AB9_SEQ
		@ Li,014 PSAY AB9->AB9_CODTEC
		@ Li,022 PSAY AB9->AB9_CODCLI
		@ Li,032 PSAY AB9->AB9_CODPRO
		@ Li,048 PSAY AB9->AB9_DTCHEG
		@ Li,059 PSAY AB9->AB9_HRCHEG
		@ Li,065 PSAY AB9->AB9_DTINI
		@ Li,076 PSAY AB9->AB9_HRINI
		@ Li,082 PSAY AB9->AB9_DTFIM
		@ Li,093 PSAY AB9->AB9_HRFIM
		@ Li,099 PSAY AB9->AB9_DTSAID
		@ Li,110 PSAY AB9->AB9_HRSAID
		@ Li,116 PSAY AB9->AB9_TRASLA   
		If mv_par13 == 1
			@ Li,122 PSAY nHrTotal2				PICTURE TM(nHrTotal1,8,1)
		Else	  
			//Efetua o alinhamento do total de horas                                                     
			If nHrTotal2 < 100
				@ Li,125 PSAY IntToHora(nHrTotal2,2)
			Else                                    
				@ Li,124 PSAY IntToHora(nHrTotal2,2)
			Endif			
		Endif			
		@ Li,131 PSAY AB9->AB9_CODPRB
		@ Li,138 PSAY SubStr(AAG->AAG_DESCRI,1,30)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exibe o campo memo     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		@ Li,169 PSAY If( !Empty( nMemCount ), MemoLine( cMemo, 40, 1 ), "" )  
		@ Li,210 PSAY SubStr(X3Combo("AB9_TIPO",AB9->AB9_TIPO),1,10)
		
		lImp 	:= .T.
		lImpAb9 := .T.
		           
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exibe o campo memo     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nMemCount := MlCount( cMemo, 40 ) 
		
		If  nMemCount > 1    
			Li++
			For nLoop := 2 To nMemCount                
				cLinha := MemoLine( cMemo, 40, nLoop ) 			
				If ( li > 60 )	
					li := cabec(Titulo,cCabec1,cCabec2,nomeprog,Tamanho,CHRCOMP)
					li++
				EndIf
				@ Li,169 PSAY cLinha
				li++
			Next nLoop 
		EndIf 	
		
		Li++
		aTotal[1] += nHrTotal1
		aTotal[2] += nHrTotal1
		aTotal[3] += nHrTotal2
		aTotal[4] += nHrTotal2
		aTotal[5] += nHrTotal3
		aTotal[6] += nHrTotal3
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Incrementa o total por ocorrencia ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Empty( nPosOcor := AScan( aTotOcor, { |x| x[1] == AAG->AAG_CODPRB } ) ) 
			AAdd( aTotOcor, { AAG->AAG_CODPRB, AAG->AAG_DESCRI, nHrTotal1, nHrTotal2, nHrTotal3 } )
		Else
			aTotOcor[ nPosOcor, 3 ] += nHrTotal1
			aTotOcor[ nPosOcor, 4 ] += nHrTotal2
			aTotOcor[ nPosOcor, 5 ] += nHrTotal3		
		EndIf 		
		
	EndIf	
	dbSelectArea("AB9")
	dbSkip()
	Do Case
		Case ( aReturn[8] == 2 )
			If ( cQuebra != AB9->AB9_CODTEC .AND. lImpAb9)
				Li++
				dbSelectArea("AA1")
				dbSetOrder(1)
				MsSeek(xFilial("AA1")+cQuebra)
				@ Li,000 PSAY STR0018+cQuebra+" "+AA1->AA1_NOMTEC 	//"TOTAL DO TECNICO: "
				
				If mv_par13 == 1
					@ Li,116 PSAY aTotal[1]    PICTURE TM(aTotal[1],5)
					@ Li,122 PSAY aTotal[3] 	PICTURE TM(aTotal[3],8)
				Else
					@ Li,119 PSAY InttoHora(aTotal[1],2)
					@ Li,125 PSAY InttoHora(aTotal[3],2)
				Endif	
					
				@ Li,135 PSAY STR0019   //"HORAS UTEIS"
				If mv_par13 == 1				
					@ Li,150 PSAY aTotal[5]
				Else
					@ Li,150 PSAY InttoHora(aTotal[5],2)
				Endif						
				Li+=2
				aTotal[1] := 0
				aTotal[3] := 0
				aTotal[5] := 0
				lImpAb9 	:= .F.
			EndIf
		Case ( aReturn[8] == 3 )
			If ( cQuebra != AB9->AB9_CODCLI .AND. lImpAb9)
				Li++
				dbSelectArea("SA1")
				dbSetOrder(1)
				MsSeek(xFilial("SA1")+cQuebra)
				@ Li,000 PSAY STR0020+cQuebra+" "+SA1->A1_NOME 	//"TOTAL DO CLIENTE: "
				
				If mv_par13 == 1
					@ Li,116 PSAY aTotal[1]    PICTURE TM(aTotal[1],5)
					@ Li,122 PSAY aTotal[3] 	PICTURE TM(aTotal[3],8)
				Else
					@ Li,119 PSAY InttoHora(aTotal[1],2)
					@ Li,125 PSAY InttoHora(aTotal[3],2)
				Endif	                                  

				@ LI,135 PSAY STR0021   //"HORAS UTEIS"
				
				If mv_par13 == 1				
					@ Li,150 PSAY aTotal[5]		PICTURE TM(aTotal[5],8)
				Else                                                 
					@ Li,150 PSAY IntToHora(aTotal[5],2)
				Endif	
				Li+=2
				aTotal[1] := 0
				aTotal[3] := 0
				aTotal[5] := 0
				lImpAb9 	:= .F.
			EndIf
		Case ( aReturn[8] == 4 )
			If ( cQuebra != AB9->AB9_CODPRB .AND. lImpAb9)
				Li++
				dbSelectArea("AAG")
				dbSetOrder(1)
				MsSeek(xFilial("AAG")+cQuebra)
				@ Li,000 PSAY STR0022+cQuebra+" "+AAG->AAG_DESCRI 	//"TOTAL DA OCORRENCIA/PROBLEMA: "
				
				If mv_par13 == 1								
					@ Li,116 PSAY aTotal[1]    PICTURE TM(aTotal[1],5)
					@ Li,122 PSAY aTotal[3] 	PICTURE TM(aTotal[3],8)
				Else	
					@ Li,119 PSAY InttoHora(aTotal[1],2)
					@ Li,125 PSAY IntToHora(aTotal[3],2)
				Endif                                   
				
				@ LI,135 PSAY STR0023   //"HORAS UTEIS"
				If mv_par13 == 1												
					@ Li,150 PSAY aTotal[5]		PICTURE TM(aTotal[5],8)
				Else	                                               
					@ Li,150 PSAY InttoHora(aTotal[5],2)
				Endif	
				Li+=2
				aTotal[1] := 0
				aTotal[3] := 0
				aTotal[5] := 0
				lImpAb9 	:= .F.
			EndIf
	EndCase
	dbSelectArea(cString)
	cbCont++
	IncRegua()
End

If ( lImp )
	@ Li,000 PSAY STR0024 	//"TOTAL GERAL"                     
	If mv_par13 == 1
		@ Li,116 PSAY aTotal[2]    PICTURE TM(aTotal[2],5)
		@ Li,122 PSAY aTotal[4] 	PICTURE TM(aTotal[4],8)
	Else
		@ Li,119 PSAY InttoHora(aTotal[2],2)
		@ Li,125 PSAY InttoHora(aTotal[4],2)
	Endif	
	@ LI,135 PSAY STR0025   //"HORAS UTEIS"
	If mv_par13 == 1	
		@ Li,150 PSAY aTotal[6]		PICTURE TM(aTotal[6],8)
	Else                                                 
		@ Li,150 PSAY IntToHora(aTotal[6],2)
	Endif	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Lista os totais por ocorrencia ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Li+=2                                  
	
	@ Li,000 PSAY STR0028
	
	Li++
	
	ASort( aTotOcor, , , { |x,y| y[1] > x[1] } ) 
	
	For nLoop := 1 to Len( aTotOcor ) 	
		
		If lEnd
			@ Prow()+1,001 PSAY STR0017 //"CANCELADO PELO OPERADOR"
			Exit
		EndIf
		If ( li > 60 )
			li := cabec(Titulo,cCabec1,cCabec2,nomeprog,Tamanho,CHRCOMP)
			li++                                            

			@ Li,000 PSAY STR0028 + If( nLoop > 1, STR0029, "" ) 
			Li++ 			
				
		EndIf                                                      
		
		@ Li,076 PSAY aTotOcor[ nLoop, 1 ] + "-" + Left( aTotOcor[ nLoop, 2 ], 30 ) 
		If mv_par13 == 1
			@ Li,116 PSAY aTotOcor[ nLoop, 3 ] PICTURE TM(aTotal[2],5)
			@ Li,122 PSAY aTotOcor[ nLoop, 4 ] PICTURE TM(aTotal[4],8)
		Else
			@ Li,119 PSAY IntToHora(aTotOcor[ nLoop, 3 ],2)
			@ Li,125 PSAY IntToHora(aTotOcor[ nLoop, 4 ],2)
   	Endif
	
		@ LI,135 PSAY STR0025   //"HORAS UTEIS"           
		If mv_par13 == 1		
			@ Li,150 PSAY aTotOcor[ nLoop, 5 ] PICTURE TM(aTotal[6],8)
		Else                                                          
			@ Li,150 PSAY IntToHora(aTotOcor[ nLoop, 5 ],2)
		Endif	
	   
		Li++ 
	
	Next nLoop 	
	
	Roda(cbCont,cbText,Tamanho)
	
EndIf
Set Device To Screen
Set Printer To
dbSelectArea("AB9")
RetIndex("AB9")
dbClearFilter()
Ferase(cArqInd+OrdBagExt())
dbSelectArea(cString)
dbClearFilter()
If ( aReturn[5] = 1 )
	dbCommitAll()
	OurSpool(wnrel)
EndIf
MS_FLUSH()
Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LimpaZerosºAutor  ³Vendas/CRM          º Data ³  07/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Formata a hora retirando zeros a esquerda                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function LimpaZeros(cValor)
Local aVetor := {}
Local cHoraFormatada := ''
aVetor:= strtokarr(cValor,':')
cHoraFormatada := cValToChar(val(aVetor[1]))+ ":" + cValToChar(aVetor[2])
Return (cHoraFormatada)   


