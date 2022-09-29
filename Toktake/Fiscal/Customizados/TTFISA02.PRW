/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ TTFISA02 ³ Autor ³ Artur Nucci Ferrari   ³ Data ³ 20/08/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ Ajuste para os NFE                                         ³±±
±±³Descricao ³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Modulo    ³ SIGAMDI                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nil => Nenhum                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil => Nenhum                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³ Manutencao Efetuada                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³                                               ³±±
±±³              ³  /  /  ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "AP5MAIL.CH"

User Function TTFISA02()

Static cUserLib  := Upper(AllTrim(cusername))

cCadastro := "Manutenção de Impostos - NFE"

IF !(cUserLib$('ADMINISTRADOR#VMIRANDA#GSANTOS#PCARDOSO#AVENANCIO'))
	MsgStop(AllTrim(cusername)+" não tem permissão para acessar esta rotina.", "Usuário sem Permissão")
	Return Nil
End

dbSelectArea("SF1")

aRotina   := { 	{ "Pesquisar"     ,'AxPesqui'    , 0, 1},;
{ "Visualizar"    ,'A100Visual'  , 0, 2},;
{ "Cabeçalho"     ,'AXALTERA'    , 0, 3},;
{ "Itens"         ,'U_FISA02()'    , 0, 3}}


dbSelectArea("SF1")
SC5->(dbSetOrder(1))
mBrowse( 6,1,22,75,"SF1")
Return(Nil)


User Function FISA02()
Local aArea	:= GetArea()
Local cFilial    := SF1->F1_FILIAL
Local cDoc       := SF1->F1_DOC
Local cSerie     := SF1->F1_SERIE
Local cFornece   := SF1->F1_FORNECE
Local cLoja      := SF1->F1_LOJA
Static nRecSF1   := SF1->(Recno())
aOriRotina := aRotina
aRotina   := { 	{ "Pesquisar"     ,'AxPesqui'    ,0,1},;
{ "Visualizar"  ,'AXVISUALl'  ,0,2},;
{ "Alterar"     ,'U_FISA02AI()' ,0,3}}
_cFil := " D1_FILIAL='"+cFilial+"' .AND. D1_DOC='"+cDoc+"'  .AND. D1_SERIE='"+cSerie+"'  .AND. D1_FORNECE='"+cFornece+"'  .AND. D1_LOJA='"+cLoja+"' "

dbSelectarea("SD1")
DBSETFILTER({|| &_cFil },_cFil)
mBrowse( 6,1,22,75,"SD1")
_cFil := ''
DBSETFILTER({|| &_cFil },_cFil)

dbSelectAre("SF1")
RestArea(aArea)
aRotina := aOriRotina
Return nil

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FISA02AI ºAutor  ³Artur Nucci Ferrari º Data ³  10/05/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao de controle da liberação                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FISA02AI()
Local _cDocumento := SD1->D1_DOC
Local _cSerie     := SD1->D1_SERIE
Local _cFornece   := SD1->D1_FORNECE
Local _cLoja      := SD1->D1_LOJA
Local _cNomeFor   := Posicione("SA2",1,xFilial("SA2")+_cFornece+_cLoja,"A2_NOME")
Local _dEmiss     := SD1->D1_EMISSAO
Local _dDigit     := SD1->D1_DTDIGIT
Local _cTES       := SD1->D1_TES
Local _cCFOP      := SD1->D1_CF
Local nValIT      := SD1->D1_TOTAL
Local nBasICM     := SD1->D1_BASEICM
Local nPerICM     := SD1->D1_PICM
Local nValICM     := SD1->D1_VALICM
Local nICMRet     := SD1->D1_ICMSRET
Local nBASIPI     := SD1->D1_BASEIPI
Local nPerIPI     := SD1->D1_IPI
Local nValIPI     := SD1->D1_VALIPI
Local nBasCOF     := SD1->D1_BASIMP5
Local nBasPIS     := SD1->D1_BASIMP6
Local nValCOF     := SD1->D1_VALIMP5
Local nValPIS     := SD1->D1_VALIMP6

While .T.
	DEFINE MSDIALOG oDlg TITLE "Alteração de Itens da NF de Entrada" FROM 0,0 TO 700,800 PIXEL
	@ 010,020 SAY "Fornecedor.:"
	@ 010,070 GET _cFornece  When .F.
	@ 010,100 GET _cLoja     When .F.
	@ 010,120 GET _cNomeFor When .F.
	
	@ 030,020 SAY "Documento"
	@ 030,080 GET _cDocumento When .F.
	@ 030,100 GET _cSerie When .F.
	@ 030,140 SAY "Emissao"
	@ 030,180 GET _dEmiss When .F.
	@ 030,250 SAY "Digitação"
	@ 030,300 GET _dDigit When .F.
	
	@ 050,020 SAY "TES"
	@ 050,110 GET _cTES F3 "SF4"	 VALID(Vazio(Alltrim(_cTES)).Or.ExistCpo("SF4",+Alltrim(_cTES)))  When .T.
	@ 050,160 SAY "CFOP
	@ 050,180 GET _cCFOP When .T.
	
	@ 070,020 SAY "Valor Item"
	@ 070,110 GET nValIT Picture "@E 999,999,999.99" When .T. SIZE 50, 7
	
	@ 090,020 SAY "Base ICMS"
	@ 090,110 GET nBasICM Picture "@E 999,999,999.99" When .T. SIZE 50, 7
	
	@ 110,020 SAY "% ICMS"
	@ 110,110 GET nPerICM Picture "@E 99.99" When .T. SIZE 50, 7
	
	@ 130,020 SAY "Valor ICMS"
	@ 130,110 GET nValICM Picture "@E 999,999,999.99" When .T. SIZE 50, 7
	
	@ 150,020 SAY "ICMS Retido"
	@ 150,110 GET nICMRet Picture "@E 999,999,999.99" When .T. SIZE 50, 7
	
	@ 170,020 SAY "Base IPI"
	@ 170,110 GET nBasIPI Picture "@E 999,999,999.99" When .T. SIZE 50, 7
	
	@ 190,020 SAY "% IPI"
	@ 190,110 GET nPerICM Picture "@E 99.99" When .T. SIZE 50, 7
	
	@ 210,020 SAY "Valor IPI"
	@ 210,110 GET nValIPI Picture "@E 999,999,999.99" When .T. SIZE 50, 7
	
	@ 230,020 SAY "Base COFINS"
	@ 230,110 GET nBasCOF Picture "@E 999,999,999.99" When .T. SIZE 50, 7
	
	@ 250,020 SAY "Base PIS"
	@ 250,110 GET nBasPIS Picture "@E 999,999,999.99" When .T. SIZE 50, 7
	
	@ 270,020 SAY "Valor COFINS"
	@ 270,110 GET nValCOF Picture "@E 999,999,999.99" When .T. SIZE 50, 7
	
	@ 290,020 SAY "Valor PIS"
	@ 290,110 GET nValPIS Picture "@E 999,999,999.99" When .T. SIZE 50, 7
	
	@ 010,300 BUTTON "Alterar"  ACTION 	Close(oDlg)
	ACTIVATE DIALOG oDlg CENTERED
	
	If MsgYesNo("Confirma alteração ?")
		RecLock("SD1",.F.)
		SD1->D1_TES      :=_cTES
		SD1->D1_CF       :=_cCFOP
		SD1->D1_TOTAL    :=nValIT
		SD1->D1_BASEICM  :=nBasICM
		SD1->D1_PICM     :=nPerICM
		SD1->D1_VALICM   :=nValICM
		SD1->D1_ICMSRET  :=nICMRet
		SD1->D1_BASEIPI  :=nBASIPI
		SD1->D1_IPI      :=nPerIPI
		SD1->D1_VALIPI   :=nValIPI
		SD1->D1_BASIMP5  :=nBasCOF
		SD1->D1_BASIMP6  :=nBasPIS
		SD1->D1_VALIMP5  :=nValCOF
		SD1->D1_VALIMP6  :=nValPIS
		
		
		MsUnLock()
		If MsgYesNo("Recalcula cabeçalho ?")
			U_CALCF1D1(SD1->(Recno()))
		Else
			Exit
		End
	Else
		Alert("Nenhuma alteração foi gravada.")
	End
	Exit
End
Return


User Function CALCF1D1(nRecSD1)
Local aAreaSF1 	 := SF1->(GetArea())
Local aAreaSD1 	 := SD1->(GetArea())
Local c_EOL	     := CHR(13)+CHR(10)
Local cFilial    := SD1->D1_FILIAL
Local cDocumento := SD1->D1_DOC
Local cSerie     := SD1->D1_SERIE
Local cFornece   := SD1->D1_FORNECE
Local cLoja      := SD1->D1_LOJA
Local cTipo      := SD1->D1_TIPO
Local cSequencia := ""

cQuery := "SELECT SUM(D1_TOTAL) AS VALMERC " + c_EOL
cQuery += ",SUM(D1_BASEICM) AS BASEICM " + c_EOL
cQuery += ",SUM(D1_VALICM) AS VALICM " + c_EOL
cQuery += ",SUM(D1_ICMSRET) AS ICMSRET " + c_EOL
cQuery += ",SUM(D1_BASEIPI) AS BASEIPI " + c_EOL
cQuery += ",SUM(D1_VALIPI) AS VALIPI " + c_EOL
cQuery += ",SUM(D1_BASIMP5) AS BASIMP5 " + c_EOL
cQuery += ",SUM(D1_BASIMP6) AS BASIMP6 " + c_EOL
cQuery += ",SUM(D1_VALIMP5) AS VALIMP5 " + c_EOL
cQuery += ",SUM(D1_VALIMP6) AS VALIMP6 " + c_EOL
cQuery += "FROM "+ RetSqlName("SD1") +" "+ RetSqlName("SD1") + c_EOL
cQuery += "WHERE D_E_L_E_T_='' " + c_EOL
cQuery += "AND D1_FILIAL='" + cFilial + "' " + c_EOL
cQuery += "AND D1_DOC='" + cDocumento + "' " + c_EOL
cQuery += "AND D1_SERIE='" + cSerie + "' " + c_EOL
cQuery += "AND D1_FORNECE='" + cFornece + "' " + c_EOL
cQuery += "AND D1_LOJA='" + cLoja + "' " + c_EOL
cQuery += "AND D1_TIPO='" + cTipo + "' " + c_EOL
MemoWrite("CALCF1D1.sql",cQuery)

IF SELECT("TRB") > 0
	dbSelectArea("TRB")
	DbCloseArea()
ENDIF

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
dbSelectArea("SF1")
dbSeek(xFilial("SF1")+cDocumento+cSerie+cFornece+cLoja+cTipo)
RecLock("SF1",.F.)
SF1->F1_DTLANC   :=CTOD('')
SF1->F1_VALMERC  :=TRB->VALMERC
SF1->F1_BASEICM  :=TRB->BASEICM
SF1->F1_VALICM   :=TRB->VALICM
SF1->F1_ICMSRET  :=TRB->ICMSRET
SF1->F1_BASEIPI  :=TRB->BASEIPI
SF1->F1_VALIPI   :=TRB->VALIPI
SF1->F1_BASIMP5  :=TRB->BASIMP5
SF1->F1_BASIMP6  :=TRB->BASIMP6
SF1->F1_VALIMP5  :=TRB->VALIMP5
SF1->F1_VALIMP6  :=TRB->VALIMP6
MsUnlock()
/*
cQuery := "SELECT DISTINCT CT2_SEQUEN " + c_EOL
cQuery += "FROM CT2010 " + c_EOL
cQuery += "WHERE D_E_L_E_T_='' " + c_EOL
cQuery += "AND CT2_LOTE='008810' " + c_EOL
cQuery += "AND SUBSTRING(CT2_KEY,01,2)='"+cFilial+"' " + c_EOL
cQuery += "AND SUBSTRING(CT2_KEY,03,9)='"+cDocumento+"' " + c_EOL
cQuery += "AND SUBSTRING(CT2_KEY,12,3)='"+cSerie+"' " + c_EOL
cQuery += "AND SUBSTRING(CT2_KEY,15,6)='"+cFornece+"' " + c_EOL
cQuery += "AND SUBSTRING(CT2_KEY,21,4)='"+cLoja+"' " + c_EOL
MemoWrite("CALCF1D1_CT2_SEQUEN.sql",cQuery)
IF SELECT("TRB") > 0
	dbSelectArea("TRB")
	DbCloseArea()
ENDIF
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
cSequencia := TRB->CT2_SEQUEN

If !Empty(cSequencia)
	cQuery := "UPDATE CT2010 SET D_E_L_E_T_='*',R_E_C_D_E_L_=R_E_C_N_O_ " + c_EOL
	cQuery += "WHERE D_E_L_E_T_='' " + c_EOL
	cQuery += "AND CT2_SEQUEN='"+cSequencia+"' " + c_EOL
	cQuery += "AND CT2_LOTE='008810' " + c_EOL
	MemoWrite("CALCF1D1_UPDATE.sql",cQuery)
	TcSqlExec(cQuery)
End
*/
dbSelectArea("SD1")
dbGoTo(nRecSD1)
RestArea(aAreaSD1)                                	
RestArea(aAreaSF1)
Return


