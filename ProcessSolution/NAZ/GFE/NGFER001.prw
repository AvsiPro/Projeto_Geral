#INCLUDE "PROTHEUS.ch"
/*/--------------------------------------------------------------------------------------------------
{Protheus.doc} NGFER001
Relatorio de Documentos de Carga
Generico.

@sample
NGFER001()

@author Felipe M.
@since 14/10/09
@version 1.0
--------------------------------------------------------------------------------------------------/*/
User Function NGFER001()
	Local oReport                   //objeto que contem o relatorio
	Local aArea := GetArea()

	Private cAliasGW1, cAliasGWB, cAliasGWU
	Private aGWUPagar  := {}
	Private aGW8Tribp  := {}

	If TRepInUse() // teste padrão
		//-- Interface de impressao
		oReport := ReportDef()
		oReport:PrintDialog()
	EndIf

	RestArea( aArea )

Return

/*/--------------------------------------------------------------------------------------------------
{Protheus.doc} ReportDef
Relatorio de Documentos de Carga
Generico.

@sample
ReportDef()

@author Felipe M.
@since 14/10/09
@version 1.0
--------------------------------------------------------------------------------------------------/*/

Static Function ReportDef()
	Local oReport, oSection1
	Local aOrdem    := {}


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Criacao do componente de impressao                                      ³
	//³                                                                        ³
	//³TReport():New                                                           ³
	//³ExpC1 : Nome do relatorio                                               ³
	//³ExpC2 : Titulo                                                          ³
	//³ExpC3 : Pergunte                                                        ³
	//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
	//³ExpC5 : Descricao                                                       ³
	//³                                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:= TReport():New("NGFER001","Listagem de Documentos de Carga","NGFER001", {|oReport| ReportPrint(oReport)},"Documentos de Carga")  //"Documentos de Carga"###"Emite Documentos de Carga conforme os parâmetros informados."
	oReport:SetLandscape()   // define se o relatorio saira deitado
	oReport:HideParamPage()   // Desabilita a impressao da pagina de parametros.
	oReport:SetTotalInLine(.F.)
	oReport:SetColSpace(2,.F.)
	Pergunte("GFER040",.F.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Criacao da secao utilizada pelo relatorio                               ³
	//³                                                                        ³
	//³TRSection():New                                                         ³
	//³ExpO1 : Objeto TReport que a secao pertence                             ³
	//³ExpC2 : Descricao da seçao                                              ³
	//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
	//³        sera considerada como principal para a seção.                   ³
	//³ExpA4 : Array com as Ordens do relatório                                ³
	//³ExpL5 : Carrega campos do SX3 como celulas                              ³
	//³        Default : False                                                 ³
	//³ExpL6 : Carrega ordens do Sindex                                        ³
	//³        Default : False                                                 ³
	//³                                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Criacao da celulas da secao do relatorio                                ³
	//³                                                                        ³
	//³TRCell():New                                                            ³
	//³ExpO1 : Objeto TSection que a secao pertence                            ³
	//³ExpC2 : Nome da celula do relatório. O SX3 será consultado              ³
	//³ExpC3 : Nome da tabela de referencia da celula                          ³
	//³ExpC4 : Titulo da celula                                                ³
	//³        Default : X3Titulo()                                            ³
	//³ExpC5 : Picture                                                         ³
	//³        Default : X3_PICTURE                                            ³
	//³ExpC6 : Tamanho                                                         ³
	//³        Default : X3_TAMANHO                                            ³
	//³ExpL7 : Informe se o tamanho esta em pixel                              ³
	//³        Default : False                                                 ³
	//³ExpB8 : Bloco de código para impressao.                                 ³
	//³        Default : ExpC2                                                 ³
	//³                                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


	Aadd( aOrdem, "Sequência" ) // "Sequência" //"Codigo"

	/*Para exibição do gestão de empresas com tabela temporária:
	Deve-se usar obrigatoriamente uma tabela e não um alias (tabela temporária).
	Segundo o FW, é porque é necessário saber o modo de acesso da tabela utilizada para construir a opção.
	Com isso, usa-se GW1 na criação da TRSection.

	Quando usado gestão de empresa, o relatório é executado 1 vez para cada empresa/grupo/unidade de negócio/filial.
	Com isso, devee-se usar xFilial(tabela) para filtrar as informações pertinentes à filial em questão.
	Caso contrário, o relatório será impresso com documentos de todas as filiais várias vezes, sempre com o mesmo conteúdo,
	diferenciando apenas o cabeçalho.

	O SQL será montado de forma a otimizar a seleção dos dados, considerando xFilial(tabela) conforme mencionado acima.

	Na criação de TRCell, usa-se o campo e a tabela como parâmetros de forma a ser usado descrição, formato etc do campo
	na tela de configuração do relatório, usada para escolher os campos a serem impressos.
	Também é usado na impressão do relatório, como título do campo ou da coluna, dependendo da forma de impressão. */

	oSection1 := TRSection():New(oReport,"Documento de Cargas",{"GW1"},aOrdem)  //"Documento de Cargas". Usar GW1 e não (cAliasGW1) para que o gestão de empresas seja exibido.
	oSection1:SetLineStyle() //Define a impressao da secao em linha
	oSection1:SetTotalInLine(.F.)
	TRCell():New(oSection1,"GW1_FILIAL","GW1",/*cTitle*/,/*Picture*/,/*Size*/,/*lPixel*/)
	// TRCell():New(oSection1,"GW1_SERDC" ,"GW1",/*cTitle*/,/*Picture*/,/*Size*/,/*lPixel*/)
	// TRCell():New(oSection1,"GW1_NRDC"  ,"GW1",/*cTitle*/,/*Picture*/,/*Size*/,/*lPixel*/)
	TRCell():New(oSection1,"GW1_EMISDC","GW1",/*cTitle*/,/*Picture*/,/*Size*/,/*lPixel*/)
	TRCell():New(oSection1,"cNMEMIS"   ,"GW1"   ,"Nome Emis"   ,"@!",51,/*lPixel*/, {|| (cAliasGW1)->cNmEmis })   //"Nome Emis"
	//TRCell():New(oSection1,"GW1_CDTPDC","GW1",/*cTitle*/,/*Picture*/,/*Size*/,/*lPixel*/,)
	TRCell():New(oSection1,"GW1_DTEMIS","GW1",/*cTitle*/,/*Picture*/,/*Size*/,/*lPixel*/)
	// TRCell():New(oSection1,"GW1_SIT"   ,"GW1",/*cTitle*/,/*Picture*/,/*Size*/,/*lPixel*/)
	// TRCell():New(oSection1,"GW1_DTIMPL","GW1",/*cTitle*/,/*Picture*/,/*Size*/,/*lPixel*/)
	// TRCell():New(oSection1,"GW1_CDREM" ,"GW1","Remetente"   ,"@!",/*Size*/,/*lPixel*/) //"Remetente"
	TRCell():New(oSection1,"cNMFANREM" ,"GW1","Nome Remet." ,"@!",51,/*lPixel*/,{||(cAliasGW1)->cNMFANREM} ) 	//"Nome Remet."
	// TRCell():New(oSection1,"cUFREM"    ,"GW1","UF Remet."   ,"@!",3,/*lPixel*/,{||(cAliasGW1)->cUFREM} ) 	//"UF Remet."
	// TRCell():New(oSection1,"GW1_CDDEST","GW1","Destinatario","@!",/*Size*/,/*lPixel*/) 		//"Destinatario"
	// TRCell():New(oSection1,"cNMFANDEST","GW1","Nome Dest."  ,"@!",51,/*lPixel*/,{||(cAliasGW1)->cNMFANDEST} ) 	//"Nome Dest."
	// TRCell():New(oSection1,"cUFDEST"   ,"GW1","UF Dest.."   ,"@!",3,/*lPixel*/,{||(cAliasGW1)->cUFDEST} ) 	//"UF Dest.."
	// TRCell():New(oSection1,"GW1_NRROM","GW1",/*cTitle*/,/*Picture*/,/*Size*/,/*lPixel*/)
	// TRCell():New(oSection1,"dDTSAID"  ,"GW1","Dt Saída","@!"       ,11      ,/*lPixel*/,{||SToD((cAliasGW1)->dDTSAID)} )
	// TRCell():New(oSection1,"cHRSAID"  ,"GW1","Hr Saída","@!"       ,6       ,/*lPixel*/,{||(cAliasGW1)->cHRSAID      } )

	
	
Return(oReport)
/*************************************************************************************************************************************/


/*/--------------------------------------------------------------------------------------------------
{Protheus.doc} ReportPrint
Relatorio de Documentos de Carga
Generico.

@sample
ReportPrint(oReport,cAliasQry)

@author Felipe M.
@since 14/10/09
@version 1.0
--------------------------------------------------------------------------------------------------/*/
Static Function ReportPrint(oReport)
	Local oSection1  := oReport:Section(1)
	Local aSelFil	   := {}
	Local cAliasTot, cQuery, cSelect, cCount, cOrderBy, cFiltroSit
	Local lPrint

	//DC Atual
	Local cFilDcAtu	:= ''
	Local cCdTpDcAtu	:= ''
	Local cEmisDcAtu	:= ''
	Local cSerDcAtu	:= ''
	Local cNrDcAtu 	:= ''

	Private cAliasGW1
	Private cAliasGWB
	Private cAliasGWU
	Private aGWUPagar  := {}
	Private aGW8Tribp  := {}

	cFiltroSit := "''"
	cFiltroSit += If (MV_PAR19==1,",'1'","")
	cFiltroSit += If (MV_PAR20==1,",'2'","")
	cFiltroSit += If (MV_PAR21==1,",'3'","")
	cFiltroSit += If (MV_PAR22==1,",'4'","")
	cFiltroSit += If (MV_PAR23==1,",'5'","")
	cFiltroSit += If (MV_PAR24==1,",'6'","")
	cFiltroSit += If (MV_PAR25==1,",'7'","")

	aSelFil := oReport:GetGCList() //Utilizado pelo botão gestão de empresas, caso houver

	cAliasGW1 := GetNextAlias()
	cAliasTot := GetNextAlias()
	cAliasGWB := GetNextAlias()
	cAliasGWU := GetNextAlias()

	cCount := "SELECT COUNT(*) nCount "

	cSelect := "GW1.*, GWN.GWN_DTSAI dDTSAID, GWN.GWN_HRSAI cHRSAID, TRANSP.GU3_NMEMIT cNMEMIS, "
	cSelect += "REM.GU3_NMFAN cNMFANREM, CIDREM.GU7_CDUF cUFREM, "
	cSelect += "DEST.GU3_NMFAN cNMFANDEST, CIDDEST.GU7_CDUF cUFDEST "
	cSelect += ", GW8.* "

	cQuery := " FROM " + RetSQLName("GW1") + " GW1 "

	cQuery += "LEFT JOIN " + RetSQLName("GWN") + " GWN "
	cQuery += "AND GWN.GWN_NRROM = GW1.GW1_NRROM "
	cQuery += "AND GWN.GWN_DTSAI >= '" + DTOS(MV_PAR13) + "' AND GWN.GWN_DTSAI  <= '" + DTOS(MV_PAR14) + "' "
	cQuery += "AND GWN.D_E_L_E_T_ = ' ' "

	cQuery += "INNER JOIN " + RetSQLName("GU3") + " TRANSP ON "
	cQuery += "TRANSP.GU3_FILIAL = '" + xFilial("GU3") + "' "
	cQuery += "AND TRANSP.GU3_CDEMIT = GW1.GW1_EMISDC "
	cQuery += "AND TRANSP.D_E_L_E_T_ = ' ' "

	cQuery += "INNER JOIN " + RetSQLName("GU3") + " REM ON "
	cQuery += "REM.GU3_FILIAL = '" + xFilial("GU3") + "' "
	cQuery += "AND REM.GU3_CDEMIT = GW1.GW1_CDREM "
	cQuery += "AND REM.D_E_L_E_T_ = ' ' "

	cQuery += "INNER JOIN " + RetSQLName("GU7") + " CIDREM ON "
	cQuery += "CIDREM.GU7_FILIAL = '" + xFilial("GU7") + "' "
	cQuery += "AND CIDREM.GU7_NRCID = REM.GU3_NRCID "
	cQuery += "AND CIDREM.D_E_L_E_T_ = ' ' "

	cQuery += "INNER JOIN " + RetSQLName("GU3") + " DEST ON "
	cQuery += "DEST.GU3_FILIAL = '" + xFilial("GU3") + "' "
	cQuery += "AND DEST.GU3_CDEMIT = GW1.GW1_CDDEST "
	cQuery += "AND DEST.GU3_NRCID >= '" + MV_PAR28 + "' "
	cQuery += "AND DEST.GU3_NRCID <= '" + MV_PAR29 + "' "
	cQuery += "AND DEST.D_E_L_E_T_ = ' ' "

	cQuery += "INNER JOIN " + RetSQLName("GU7") + " CIDDEST ON "
	cQuery += "CIDDEST.GU7_FILIAL = '" + xFilial("GU7") + "' "
	cQuery += "AND CIDDEST.GU7_NRCID = DEST.GU3_NRCID "
	cQuery += "AND CIDDEST.GU7_CDUF >= '" + MV_PAR30 + "' "
	cQuery += "AND CIDDEST.GU7_CDUF <= '" + MV_PAR31 + "' "
	cQuery += "AND CIDDEST.D_E_L_E_T_ = ' ' "

	cQuery += "INNER JOIN " + RetSQLName("GW8") + " GW8 ON "
	cQuery += "GW8.GW8_FILIAL = GW1.GW1_FILIAL "
	cQuery += "AND GW8.GW8_CDTPDC = GW1.GW1_CDTPDC "
	cQuery += "AND GW8.GW8_EMISDC = GW1.GW1_EMISDC "
	cQuery += "AND GW8.GW8_SERDC = GW1.GW1_SERDC "
	cQuery += "AND GW8.GW8_NRDC = GW1.GW1_NRDC "

	cQuery += "WHERE GW1.GW1_FILIAL >= '" + MV_PAR01 + "' AND GW1.GW1_FILIAL <= '" + MV_PAR02 + "' "
	cQuery += "AND GW1.GW1_EMISDC   >= '" + MV_PAR03 + "' AND GW1.GW1_EMISDC <= '" + MV_PAR04 + "' "
	cQuery += "AND GW1.GW1_SERDC    >= '" + MV_PAR05 + "' AND GW1.GW1_SERDC  <= '" + MV_PAR06 + "' "
	cQuery += "AND GW1.GW1_NRDC     >= '" + MV_PAR07 + "' AND GW1.GW1_NRDC   <= '" + MV_PAR08 + "' "
	cQuery += "AND GW1.GW1_DTEMIS   >= '" + DTOS(MV_PAR09) + "' AND GW1.GW1_DTEMIS <= '" + DTOS(MV_PAR10) + "' "
	cQuery += "AND GW1.GW1_SIT IN (" + AllTrim(cFiltroSit) + ") "
	cQuery += "AND GW1.D_E_L_E_T_ = ' ' "

	If !Empty(aSelFil)
		cQuery += "AND GW1.GW1_FILIAL = '" + xFilial("GW1") + "' "
	EndIf

	

	cOrderBy := " ORDER BY GW1.GW1_FILIAL, GW1.GW1_CDTPDC, GW1.GW1_EMISDC, GW1.GW1_SERDC, GW1.GW1_NRDC"

	//Cursor cCount é usado para a barra de progressão
	cCount := cCount + cQuery
	ChangeQuery(cCount)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cCount),cAliasTot, .F., .T.)
	dbSelectArea((cAliasTot))
	(cAliasTot)->( dbGoTop() )
	oReport:SetMeter ((cAliasTot)->nCount)

	//Deve ser incluso o "%" para o Protheus identificar como expressão
	cSelect := "%" + cSelect + cQuery + cOrderBy + "%"

	oSection1:BeginQuery()
		BeginSql Alias cAliasGW1
		SELECT %Exp:cSelect%
		EndSql
	oSection1:EndQuery()

	While !oReport:Cancel() .AND. !(cAliasGW1)->(Eof())
		
		
			//Secção 1
			//Essa validação é feita pois os itens são selecionados no mesmo cursor do doc. de carga.
			If (cAliasGW1)->(GW1_FILIAL+GW1_CDTPDC+GW1_EMISDC+GW1_SERDC+GW1_NRDC) <> cFilDcAtu+cCdTpDcAtu+cEmisDcAtu+cSerDcAtu+cNrDcAtu
				cFilDcAtu	 := (cAliasGW1)->GW1_FILIAL
				cCdTpDcAtu	 := (cAliasGW1)->GW1_CDTPDC
				cEmisDcAtu	 := (cAliasGW1)->GW1_EMISDC
				cSerDcAtu	 := (cAliasGW1)->GW1_SERDC
				cNrDcAtu	 := (cAliasGW1)->GW1_NRDC

				oSection1:Init()
				oSection1:PrintLine()
			EndIf

			
			(cAliasGW1)->(dbSkip())		
		
    	oReport:Skipline()
    	oReport:IncMeter()

	EndDo

	oSection1:Finish()

	(cAliasGW1)->(dbCloseArea())
	(cAliasTot)->(dbCloseArea())

Return

/*/--------------------------------------------------------------------------------------------------
Função criada para carregar em arrays os campos que são código/descrição.
Isso evita de fazer um select para cada DC impresso.
--------------------------------------------------------------------------------------------------/*/
Static Function CrtSX3cBox()
Local cBox

	cBox := GetSx3Cache("GWU_PAGAR","X3_CBOX")
	aGWUPagar := StrToKArr(cBox, ";")
	
	cBox := GetSx3Cache("GW8_TRIBP","X3_CBOX")
	aGW8Tribp := StrToKArr(cBox, ";")

Return nil

/*/--------------------------------------------------------------------------------------------------
Função criada para ler a descrição de um campo a partir do código para um determinado campo.
Isso evita de fazer um select para cada DC impresso.
--------------------------------------------------------------------------------------------------/*/
Static Function GetSX3cBox(cCampo, cValor)

	Do Case
		Case Upper(cCampo) == "GWU_PAGAR"
			Return GetArVal(aGWUPagar, cValor)
		Case Upper(cCampo) == "GW8_TRIBP"
			Return GetArVal(aGW8Tribp, cValor)
	EndCase

Return ''

/*/--------------------------------------------------------------------------------------------------
Função criada para procurar um código em um array passado por parâmetro e retornar a descrição.
Permite a reutilização de código.
--------------------------------------------------------------------------------------------------/*/
Static Function GetArVal(aArray, cValor)
Local nInd

	For nInd := 1 To Len(aArray)
		If Substr(aArray[nInd], 1, At("=",aArray[nInd]) - 1) == cValor
			Return Substr(aArray[nInd], At("=",aArray[nInd]) + 1, Len(aArray[nInd]))
		EndIf
	Next nInd

Return ''
