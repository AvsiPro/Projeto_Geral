/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±
±³Programa  ³ TTFATA12 ³ Autor ³ Artur Nucci Ferrari     ³ Data ³ 18/02/03 ³±
±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±
±³Descricao ³ Digitacao da data do Recebimento do Canhoto da NF.           ³±
±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±
±³Uso       ³ Faturamento                                                  ³±
±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±
±³Empresa   ³ TokTake                                                      ³±
±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#include "rwmake.ch" 

User Function TTFATA12()      
SetPrvt("CTITULO,CCADASTRO,LEND,CDELFUNC,AROTINA,AF2BROW")
cTitulo := "Data do Recebimento de Mercadorias no Cliente"
cCadastro := OEMTOANSI (cTitulo)
lEnd := .F.
CdelFunc := ".T."
aRotina := {   { "Pesquisar" ,"AxPesqui"                    , 0, 1},;
               { "Canhoto"   ,'ExecBlock("LD0001H",.F.,.F.)', 0, 4}}  // PARA EXECBLOC

aF2Brow:={{"NFiscal"   ,"F2_DOC"    },;
          {"Serie"     ,"F2_SERIE"  },;
          {"Emissao"   ,"F2_EMISSAO"},;
          {"Cliente"   ,"F2_CLIENTE"},;
          {"Lj"        ,"F2_LOJA"   },;       
          {"Romaneio"  ,"F2_XCARGA" },;          
          {"Placa"     ,"F2_XPLACA" },;          
          {"Motorista" ,"F2_XMOTOR" },;          
          {"Lacre"     ,"F2_XLACRE" },;                    
          {"Vl.Devolucao","F2_XVALDEV"},;
          {"Tp.Dev."   ,"F2_XDEV"},;
          {"Canhoto"   ,"F2_XRECENT"},;
          {"Ass    "   ,"F2_XRECASS"},;
          {"Dt.Entrega","F2_XDTENTR"},;
          {"Hr.Entrega","F2_XHRENTR"}}

dbSelectArea("SF2")
DbSetOrder(1)

mBrowse( 6,1,22,75,"SF2",aF2Brow)

Return()


User Function LD0001H()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava Area Inicial                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local _cAlias  := Alias()
Local _nIndex  := IndexOrd()
Local _nReg    := Recno()
Local cDoc     := SF2->F2_DOC
Local cSerie   := SF2->F2_SERIE
Local cPrefix  := SF2->F2_PREFIXO
Local cTipo    := SF2->F2_TIPO
Local cEmissao := SF2->F2_EMISSAO
Local cRoman   := SF2->F2_XCARGA
Local cPlaca   := SF2->F2_XPLACA
Local cMotor   := SF2->F2_XMOTOR
Local cLacre   := SF2->F2_XLACRE
Local cRecEnt  := SF2->F2_XRECENT
Local cRecAss  := SF2->F2_XRECASS
Local dDat     := SF2->F2_XDTENTR
Local cHor     := SF2->F2_XHRENTR
Local cDev     := SF2->F2_XDEV
Local nValDev  := SF2->F2_XVALDEV
Local cCliente := ""
Local cPedido  := ""
Local cCondPag := ""
If cTipo$"N/P/I"
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
	cCliente := SA1->A1_NOME
Else
	dbSelectArea("SA2")
	dbSetOrder(1)
	dbSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA)
	cCliente := SA2->A2_NOME
End
dbSelectArea("SD2")
dbSetOrder(3)
dbSeek(xFilial("SD2")+cDoc+cSerie)
cPedido := SD2->D2_PEDIDO
dbSelectArea("SC5")
dbSetOrder(1)
dbSeek(xFilial("SC5")+cPedido)
cCondPag := SC5->C5_CONDPAG

dbSelectArea("SF2")
While !Eof()
	@ 127,112 To 450,730 DIALOG _oObjeto TITLE "Data do Recebimento da Mercadoria pelo Cliente"
	@ 020,005 Say "Nota Fiscal  : " + SF2->F2_DOC + "-" + SF2->F2_SERIE
	@ 030,005 Say "Emissao      : " + Dtoc(SF2->F2_EMISSAO)
	@ 040,005 Say "Cliente      : " + SF2->F2_CLIENTE + "/" + SF2->F2_LOJA + "-" + cCliente
	@ 050,005 Say "Romaneio     : " + cRoman
	@ 070,005 Say "Tipo Devolução [" + cDev + "] - Valor : "
	@ 070,120 Say nValDev  PICTURE "@E 999,999,999,999.99"  SIZE 50,50 Object oGt
	@ 090,005 Say "Data da Entrega:" SIZE(50,50)
	@ 090,060 GET dDat PICTURE "99/99/9999" VALID .t. SIZE 50,50 Object oGt	
	@ 090,120 Say "Hora da Entrega:" SIZE(50,50)
	@ 090,175 GET cHor Pict "99:99"
	@ 110,005 Say "Canhoto:" SIZE(50,50)
	@ 110,060 GET cRecEnt Valid cRecEnt$("S/N")
	@ 110,175 Say "S/N"                                                        
	@ 130,005 Say "Assinatura:" SIZE(50,50)
	@ 130,060 GET cRecAss Valid cRecAss$("S/N")
	@ 130,175 Say "S/N"

	@ 040,260 BMPBUTTON TYPE 1 ACTION Close(_oObjeto)   // Botao de confirmacao
	ACTIVATE DIALOG _oObjeto CENTERED
//	If Empty(dDat)
//		MsgBox("Nao foi registrada nenhuma alteracao.","Informacao!","INFO")
//		dbSelectArea("SF2")
//		dbSelectArea(_cAlias)
//		dbSetOrder(_nIndex)
//		dbGoTo(_nReg)
//		Return()
	If !Empty(dDat) .AND. dDat < SF2->F2_EMISSAO
		MsgBox("Favor verificar a data de entrega, nao pode ser menor que a data de emissao da nota fiscal.","Atencao!","ALERT")
		Loop
	Else
		Exit
	End
End
//aCond := Condicao(nValFat,cCondPag,,dDat)
//ALERT(aCond[1,1]) // DATA
//ALERT(aCond[1,2]) // VALOR
RecLock("SF2",.F.)
REPLACE SF2->F2_XDTENTR WITH dDat
REPLACE SF2->F2_XHRENTR WITH cHor
REPLACE SF2->F2_XRECENT WITH cRecEnt
REPLACE SF2->F2_XRECASS WITH cRecAss
MsUnlock()     


//  *****************************************************************  //
//     R O T I N A   D E   B A I X A   D E   C A N H O T O 
//
//     Alteracao para gravar os dados do canhoto no titulo a receber
//  liberando o titulo para ser enviado ao banco pelo cnab.
//                                                                       
//  *****************************************************************  //
DbSelectArea("SE1")
DbsetOrder(1)
If DbSeek(xFilial("SE1")+SF2->F2_FILIAL+Alltrim(SF2->F2_SERIE)+SF2->F2_DOC)
	While !EOF() .And. SE1->E1_NUM == SF2->F2_DOC .AND. SE1->E1_PREFIXO == SF2->F2_FILIAL+Alltrim(SF2->F2_SERIE)
		Reclock("SE1",.F.)
		SE1->E1_XRECENT := cRecEnt
		SE1->E1_XRECASS := cRecAss
		SE1->E1_XHRENTR := cHor
		SE1->E1_XDTENTR := dDat
		SE1->(Msunlock())
		DBSKIP()
	EndDo
EndIf                           
	

dbSelectArea("SF2")
dbSelectArea(_cAlias)
dbSetOrder(_nIndex)
dbGoTo(_nReg)
Return()


/*
If cFrete == "C"
	//	If dDat > dDatPrev
	//		REPLACE SF2->F2_VENCAJU WITH (SF2->F2_VENCREA+(dDat-dDatPrev))
	//	Else
	REPLACE SF2->F2_VENCAJU WITH aCond[1,1]
	//	End
ElseIf cFrete == "F"
	REPLACE SF2->F2_VENCAJU WITH SF2->F2_VENCREA
End
*/

/*
dbSelectArea("SE1")
dbSetOrder(1)
If dbSeek(xFilial("SE1")+cPrefix+cDoc)
	While !Eof() .and. SE1->E1_NUM == cDoc .and. SE1->E1_PREFIXO == cPrefix
		_DATREAL := SE1->E1_VENCREA
		_PARCELA := SE1->E1_PARCELA
		_PARCELA := IF(Empty(_PARCELA),'1',_PARCELA)
		//		ALERT(_PARCELA)
		_NovVencto := aCond[Val(_PARCELA),1]
		
		RecLock("SE1",.F.)
	//	If SE1->E1_ALTVEN == 'N'
	//		REPLACE SE1->E1_COMENT  WITH AllTrim(SE1->E1_COMENT) + " Alt. Bloq. Lead Time" + Space(50)
	//	Else
			If  cFrete == "C"
			//	REPLACE SE1->E1_VENCAJU WITH _NovVencto
			//	REPLACE SE1->E1_VENCREA WITH DataValida(_NovVencto)
			//	If _NovVencto > SE1->E1_VENCTO
			//		REPLACE SE1->E1_COMENT  WITH " Vencto ajust. Lead Time"+ Space(50)
			//	Else
			//		REPLACE SE1->E1_COMENT  WITH " Nao houve alteracao no Vencto. Lead Time" + Space(50)
			//	End
		  	End
	  //	End
		//If SE1->E1_SITUACA=='B'
		//	REPLACE SE1->E1_SITUACA WITH "0"
		//End
		MsUnlock()
		dbSkip()
		Loop
	End
End  
*/
