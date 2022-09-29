/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ TTFISA03 ³ Autor ³ Artur Nucci Ferrari   ³ Data ³ 20/08/09 ³±±
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

User Function TTFISA03()

Static cUserLib  := Upper(AllTrim(cusername))

cCadastro := "Manutenção de Impostos - NFS"

IF !(cUserLib$('ADMINISTRADOR#VMIRANDA#GSANTOS#PCARDOSO#AVENANCIO'))
	MsgStop(AllTrim(cusername)+" não tem permissão para acessar esta rotina.", "Usuário sem Permissão")
	Return Nil
End

dbSelectArea("SF2")

aRotina   := { 	{ "Pesquisar"     ,'AxPesqui'    , 0, 1},;
{ "Visualizar"    ,'A100Visual'  , 0, 2},;
{ "Cabeçalho"     ,'AXALTERA'    , 0, 3},;
{ "Itens"         ,'U_FISA03()'    , 0, 3}}


dbSelectArea("SF2")
SF2->(dbSetOrder(1))
mBrowse( 6,1,22,75,"SF2")
Return(Nil)


User Function FISA03()
Local aArea	:= GetArea()
Local cFilial    := SF2->F2_FILIAL
Local cDoc       := SF2->F2_DOC
Local cSerie     := SF2->F2_SERIE
Local cCliente   := SF2->F2_CLIENTE
Local cLoja      := SF2->F2_LOJA
Static nRecSF1   := SF2->(Recno())
aOriRotina := aRotina
aRotina   := { 	{ "Pesquisar"     ,'AxPesqui'    ,0,1},;
{ "Visualizar"  ,'AXVISUALl'  ,0,2},;
{ "Alterar"     ,'U_FISA03AI()' ,0,3}}
_cFil := " D2_FILIAL='"+cFilial+"' .AND. D2_DOC='"+cDoc+"'  .AND. D2_SERIE='"+cSerie+"'  .AND. D2_CLIENTE='"+cCliente+"'  .AND. D2_LOJA='"+cLoja+"' "

dbSelectarea("SD2")
DBSETFILTER({|| &_cFil },_cFil)
mBrowse( 6,1,22,75,"SD2")
_cFil := ''
DBSETFILTER({|| &_cFil },_cFil)

dbSelectAre("SF2")
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
User Function FISA03AI()
Local _cDocumento := SD2->D2_DOC
Local _cSerie     := SD2->D2_SERIE
Local _cCliente   := SD2->D2_CLIENTE
Local _cLoja      := SD2->D2_LOJA
Local _cNomeCli   := Posicione("SA1",1,xFilial("SA1")+_cCliente+_cLoja,"A1_NOME")
Local _dEmiss     := SD2->D2_EMISSAO
Local _cTES       := SD2->D2_TES
Local _cCFOP      := SD2->D2_CF
Local nValIT      := SD2->D2_TOTAL
Local nBasICM     := SD2->D2_BASEICM
Local nPerICM     := SD2->D2_PICM
Local nValICM     := SD2->D2_VALICM
Local nICMRet     := SD2->D2_ICMSRET
Local nBASIPI     := SD2->D2_BASEIPI
Local nPerIPI     := SD2->D2_IPI
Local nValIPI     := SD2->D2_VALIPI
Local nBasCOF     := SD2->D2_BASIMP5
Local nBasPIS     := SD2->D2_BASIMP6
Local nValCOF     := SD2->D2_VALIMP5
Local nValPIS     := SD2->D2_VALIMP6

While .T.
	DEFINE MSDIALOG oDlg TITLE "Alteração de Itens da NF de Saida" FROM 0,0 TO 700,800 PIXEL
	@ 010,020 SAY "Cliente.:"
	@ 010,070 GET _cCliente  When .F.
	@ 010,100 GET _cLoja     When .F.
	@ 010,120 GET _cNomeCli When .F.
	
	@ 030,020 SAY "Documento"
	@ 030,080 GET _cDocumento When .F.
	@ 030,100 GET _cSerie When .F.
	@ 030,140 SAY "Emissao"
	@ 030,180 GET _dEmiss When .F.

	
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
		RecLock("SD2",.F.)
		SD2->D2_TES      :=_cTES
		SD2->D2_CF       :=_cCFOP
		SD2->D2_TOTAL    :=nValIT
		SD2->D2_BASEICM  :=nBasICM
		SD2->D2_PICM     :=nPerICM
		SD2->D2_VALICM   :=nValICM
		SD2->D2_ICMSRET  :=nICMRet
		SD2->D2_BASEIPI  :=nBASIPI
		SD2->D2_IPI      :=nPerIPI
		SD2->D2_VALIPI   :=nValIPI
		SD2->D2_BASIMP5  :=nBasCOF
		SD2->D2_BASIMP6  :=nBasPIS
		SD2->D2_VALIMP5  :=nValCOF
		SD2->D2_VALIMP6  :=nValPIS 
		MsUnLock()
		If MsgYesNo("Recalcula cabeçalho ?")
			U_CALCF2D2(SD1->(Recno()))
		Else
			Exit
		End
	Else
		Alert("Nenhuma alteração foi gravada.")
	End
	Exit
End
Return


User Function CALCF2D2(nRecSD1)
Local aAreaSF2 	 := SF2->(GetArea())
Local aAreaSD2 	 := SD2->(GetArea())
Local c_EOL	     := CHR(13)+CHR(10)
Local cFilial    := SD2->D2_FILIAL
Local cDocumento := SD2->D2_DOC
Local cSerie     := SD2->D2_SERIE
Local cFornece   := SD2->D2_FORNECE
Local cLoja      := SD2->D2_LOJA
Local cTipo      := SD2->D2_TIPO

cQuery := "SELECT SUM(D2_TOTAL) AS VALMERC " + c_EOL 
cQuery += ",SUM(D2_BASEICM) AS BASEICM " + c_EOL 
cQuery += ",SUM(D2_VALICM) AS VALICM " + c_EOL 
cQuery += ",SUM(D2_ICMSRET) AS ICMSRET " + c_EOL 
cQuery += ",SUM(D2_BASEIPI) AS BASEIPI " + c_EOL 
cQuery += ",SUM(D2_VALIPI) AS VALIPI " + c_EOL 
cQuery += ",SUM(D2_BASIMP5) AS BASIMP5 " + c_EOL 
cQuery += ",SUM(D2_BASIMP6) AS BASIMP6 " + c_EOL 
cQuery += ",SUM(D2_VALIMP5) AS VALIMP5 " + c_EOL 
cQuery += ",SUM(D2_VALIMP6) AS VALIMP6 " + c_EOL 
cQuery += "FROM SD2010 " + RetSqlName("SD1") + c_EOL
cQuery += "WHERE D_E_L_E_T_='' " + c_EOL 
cQuery += "AND D2_FILIAL='" + cFilial + "' " + c_EOL 
cQuery += "AND D2_DOC='" + cDocumento + "' " + c_EOL 
cQuery += "AND D2_SERIE='" + cSerie + "' " + c_EOL 
cQuery += "AND D2_CLIENTE='" + cCliente + "' " + c_EOL 
cQuery += "AND D2_LOJA='" + cLoja + "' " + c_EOL 
cQuery += "AND D2_TIPO='" + cTipo + "' " + c_EOL 
MemoWrite("CALCF2D2.sql",cQuery)

IF SELECT("TRB") > 0
	dbSelectArea("TRB")
	DbCloseArea()
ENDIF

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
dbSelectArea("SF2")
dbSeek(xFilial("SF2")+cDocumento+cSerie+cCliente+cLoja+cTipo)
RecLock("SF2",.F.)   
SF2->F2_DTLANC   :="" 
SF2->F2_VALMERC  :=TRB->VALMERC
SF2->F2_BASEICM  :=TRB->BASEICM
SF2->F2_VALICM   :=TRB->VALICM
SF2->F2_ICMSRET  :=TRB->ICMSRET
SF2->F2_BASEIPI  :=TRB->BASEIPI
SF2->F2_VALIPI   :=TRB->VALIPI
SF2->F2_BASIMP5  :=TRB->BASIMP5
SF2->F2_BASIMP6  :=TRB->BASIMP6
SF2->F2_VALIMP5  :=TRB->VALIMP5
SF2->F2_VALIMP6  :=TRB->VALIMP6
MsUnlock()
dbSelectArea("SD1")
dbGoTo(nRecSD1)
RestArea(aAreaSD1)
RestArea(aAreaSF1)
Return                          


