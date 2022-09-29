#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ SF1100I  º Autor ³ Cadubitski         º Data ³  Jan/2010   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Ponto de Entrada para Gravação de Mensagem na NF de Entradaº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso		 ³                   										  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function SF1100I()

Local _aArea      := GetArea()
Local _aAreaSE2   := GetArea("SE2") 
Local lEdi1	 := .F.
Local nCont	 := 0
Local aOpc1 := {' 1=Maritima',' 2=Fluvial',' 3=Lacustre',' 4=Aerea',' 5=Postal',' 6=Ferroviaria',' 7=Rodoviaria',' 8=Conduto',' 9=Meios proprios','10=Entrada/Saida ficta'}	// CD5_VTRANS
Local aOpc2 := {}	// CD5_INTERM
Private cVTransp := ""
Private cfImp := ""
Private cMenNota  := If(cEmpAnt == "01",CriaVar("F1_XMENNOT",.F.),"")
Private cControl  := CriaVar("F1_CONTROL",.F.)
Private cTransp   := CriaVar("F1_TRANSP" ,.F.)
Private nValII    := If(Alltrim(cEmpAnt) $ "01/02",CriaVar("F1_XVALII" ,.F.),0)
Private nFrtImp   := If(Alltrim(cEmpAnt) $ "01/02",CriaVar("F1_XFRTIMP",.F.),0)
Private cFrtPre   := If(Alltrim(cEmpAnt) $ "01/02",CriaVar("F1_XFRTPRE",.F.),"")
Private nSiscom   := If(Alltrim(cEmpAnt) $ "01/02",CriaVar("F1_XSISCOM",.F.),0)
Private nValSeg   := If(Alltrim(cEmpAnt) $ "01/02",CriaVar("F1_XVALSEG",.F.),0)
Private cNumDI    := If(Alltrim(cEmpAnt) $ "01/02",CriaVar("F1_XDI"    ,.F.),"")
Private cDataDI   := If(Alltrim(cEmpAnt) $ "01/02",CriaVar("F1_XDTDI"  ,.F.),"")
Private cLocDesem := If(Alltrim(cEmpAnt) $ "01/02",CriaVar("F1_XLDESE" ,.F.),"")
Private cUfDesem  := If(Alltrim(cEmpAnt) $ "01/02",CriaVar("F1_XUFDES" ,.F.),"")
Private cDataDesem:= If(Alltrim(cEmpAnt) $ "01/02",CriaVar("F1_XDTDES" ,.F.),"")
Private nValBasC  := If(Alltrim(cEmpAnt) $ "01/02",CriaVar("F1_XVBC"   ,.F.),0)
Private nValDePad := If(Alltrim(cEmpAnt) $ "01/02",CriaVar("F1_XVDEPAD",.F.),0)
Private nValIof	  := If(Alltrim(cEmpAnt) $ "01/02",CriaVar("F1_XVIOF"  ,.F.),0)
Private cXForFix  := Space(10)
Private cXLojFix  := Space(04)
Private cXNomFix  := Space(40)
Private cXCCFix   := Space(15)
Private cFilial   := SF1->F1_FILIAL
Private cUserDig,cUserFF
Private nOpc := 2   

If cEmpAnt == "01" .or. cEmpAnt == "02"
	
	cFornece := SF1->F1_FORNECE
	cLoja    := SF1->F1_LOJA
	cNum     := SF1->F1_DOC
	cPrefixo := SF1->F1_PREFIXO
	cSerie   := SF1->F1_SERIE
	cTipo    := SF1->F1_TIPO
	cEstFor  := GetAdvFval("SA2","A2_EST" ,xFilial("SA2")+cFornece+cLoja,1)
	cFRec    := SF1->(RECNO())
	                          
	
	
	While !empty(procname(nCont))
		If alltrim(UPPER(procname(nCont))) $ "U_TTTMKA50"
			lEdi1 := .T.
			Exit
		EndIf 
		nCont++
	EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Fundo Fixo                                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (SM0->M0_CODIGO)=="01"
		cUserDig  := Upper(AllTrim(cusername))
		cUserFF   := AllTrim(SuperGetMv("MV_XUSERFF"))
		IF cUserDig$(cUserFF)
			nOpc := Aviso("Atenção","Esta entrada de NF é de Fundo Fixo ?",{"Sim","Não"})
			If nOpc = 1
				_aAreaSA2 := GetArea("SA2")
				@ 127,112 To 350,730 DIALOG _oObjeto1 TITLE "Fundo Fixo"
				
				@ 010,005 Say "Código :"
				@ 010,055 GET cXForFix PICTURE "@!"  When .T.  F3 "SA2FIX"  SIZE 70,07 VALID IIf(!Empty(cXForFix),cXNomFix:=Posicione("SA2",1,xFilial("SA2")+cXForFix,"A2_NOME"),cXNomFix:="")
				
				@ 070,005 Say "Razâo Social:"
				@ 070,055 GET cXNomFix PICTURE "@!" When .F. SIZE 200,12
				
				@ 010,260 BMPBUTTON TYPE 1 ACTION Close(_oObjeto1)   // Botao de confirmacao
				ACTIVATE DIALOG _oObjeto1 CENTERED
				If !Empty(cXForFix)
					cXForFix := SA2->A2_COD
					cXLojFix := SA2->A2_LOJA
					cXCCFix  := SA2->A2_CONTA
				End
				RestArea(_aAreaSA2)
			End
		End
	End
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Transportadora                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF cEstFor == "EX"
		
		dbSelectArea("SX3")
		dbSetOrder(2)
		
		//If dbSeek ("CD5_VTRANS")  
		//	aOpc1 := StrToKarr(SX3->X3_CBOX,";") //#cBoxVTrans()
		//EndIf                                  
			
		If dbSeek ("CD5_INTERM")
			aOpc2 := StrToKarr(SX3->X3_CBOX,";")
		EndIf
		
		cVTransp := aOpc1[1] 
		cfImp := aOpc2[1] 
	
		While .T.
			@ 127,112 To 800,700 DIALOG _oObjeto1 TITLE "NFE - Importação"
			
			@ 010,005 Say "Numero DI: "
			@ 010,100 GET cNumDI Picture '@!' Size 50,12
			
			@ 030,005 Say "Data DI: "
			@ 030,100 GET cDataDI Picture '@!' Size 50,12
			
			@ 050,005 Say "Local Desembaraço: "
			@ 050,100 GET cLocDesem Picture '@!' Size 50,12
			
			@ 070,005 Say "UF Desembaraço: "
			@ 070,100 GET cUfDesem Picture '@!' Size 50,12
			
			@ 090,005 Say "Data Desembaraço: "
			@ 090,100 GET cDataDesem Picture '@!' Size 50,12
			
			@ 110,005 Say "Base de Calculo: "
			@ 110,100 GET nValBasC Picture '@E 999,999,999.99'  Valid !Empty(nValBasC) Size 50,12
			
			@ 130,005 Say "Despesa: "
			@ 130,100 GET nValDePad Picture '@E 999,999,999.99'  Size 50,12
			
			@ 150,005 Say "IOF: "
			@ 150,100 GET nValIof Picture '@E 999,999,999.99'  Size 50,12
			
			@ 170,005 Say "Imposto de Importação: "
			@ 170,100 GET nValII  Picture '@E 999,999,999.99'  Size 50,12
			
			@ 190,005 Say "Frete de Importação: "
			@ 190,100 GET nFrtImp Picture '@E 999,999,999.99'  Size 50,12
			
			@ 210,005 Say "Frete Presumindo (S/N): "
			@ 210,100 GET cFrtPre Picture '@!' Valid cFrtPre$('S#N')
			
			@ 230,005 Say "SISCOMEX: "
			@ 230,100 GET nSisCom Picture '@E 999,999,999.99'  Size 50,12
			
			@ 250,005 Say "Seguro: "
			@ 250,100 GET nValSeg Picture '@E 999,999,999.99' Size 50,12
			
			@ 270,005 Say "Transportadora :"
			@ 270,100 GET cTransp Picture "@!" Valid .T. F3 "SA4"
			 
			// via transp
			@ 290,005 Say "Via transporte :"
			//oCB1 := TComboBox():New( 290,100,{|u|if( PCount()>0,cCombo1:=u,cVTransp )},aOpc1,070,15,oPanel,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,cVTransp)	
			oCombo1 := TComboBox():New(290,100,{|u|if( PCount()>0,cVTransp:=u,cVTransp )},aOpc1,070,15,_oObjeto1,,,,,,.T.,,"",,,,,,,'cVTransp') // Alterado
			
			// forma import
			@ 310,005 Say "Forma importação:"
			//oCB2 := TComboBox():New( 310,100,{|u|if( PCount()>0,cfImp:=u,cfImp )},aOpc2,070,15,oPanel,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,cfImp)	
			oCombo2 := TComboBox():New( 310,100,{|u|if( PCount()>0,cfImp:=u,cfImp )},aOpc2,088,15,_oObjeto1,,,,,,.T.,,"",,,,,,,cfImp)	// Alterado
			
			
			@ 310,240 BMPBUTTON TYPE 1 ACTION Close(_oObjeto1)   // Botao de confirmacao
			ACTIVATE DIALOG _oObjeto1 CENTERED
			Exit
		End
	End
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Mensagem Nota Fiscal                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	  
	If !lEdi1                                       
		If SM0->M0_CODIGO $ "01/02"
			DEFINE MSDIALOG oDlg TITLE "Mensagem para Nota Fiscal de Entrada" FROM 0,0 TO 300,500 PIXEL
			@ 017,020 GET cMenNota Size 200,100 MEMO
			//@ 017,20 GET cMennota Size 200,400
			@ 121,180 BUTTON "Ok" SIZE 40,10 ACTION Grava()
			ACTIVATE DIALOG oDlg CENTERED
		EndIf
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Contas a Pagar                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SM0->M0_CODIGO $ "01/02" 
	dbSelectArea("SE2")
	dbSetOrder(6)
	nOrder   := IndexOrd()
	nRecno   := Recno()
	If dbSeek(xFilial("SE2")+cFornece+cLoja+cPrefixo+cNum)
		While !Eof() .and. cFornece == SE2->E2_FORNECE .and. cLoja == SE2->E2_LOJA .AND. ;
			cPrefixo == SE2->E2_PREFIXO .and. cNum == SE2->E2_NUM
			RecLock("SE2",.f.)
			If nOpc = 1
				If Empty(cXForFix)                                                       // Alterado em 27/09/05
					REPLACE SE2->E2_FORNECE WITH cXForFix
					REPLACE SE2->E2_LOJA    WITH cXLojFix
					REPLACE SE2->E2_FORORI WITH cFornece
					REPLACE SE2->E2_LOJORI WITH cLoja
				End
			End
			REPLACE SE2->E2_DTNFINC  WITH date()
			REPLACE SE2->E2_CONTROL  WITH Replicate( '0', 10-Len(Alltrim(cControl)) ) + AllTrim(cControl)
			//---Incluido pelo Fabio Sales em 03/03/2011---//
			If SE2->E2_VENCREA < dDataBase                 //
				REPLACE SE2->E2_VENCREA With dDataBase + 1 //
			EndIf                                          //
			//---------------------------------------------//
			If cEstFor == "EX"
				REPLACE SE2->E2_VALOR WITH SF1->(F1_VALBRUT-(F1_VALICM+F1_VALIPI+F1_VALIMP5+F1_VALIMP6+F1_XVALII+F1_XSISCOM+F1_XFRTIMP+F1_SEGURO))
				REPLACE SE2->E2_SALDO WITH SF1->(F1_VALBRUT-(F1_VALICM+F1_VALIPI+F1_VALIMP5+F1_VALIMP6+F1_XVALII+F1_XSISCOM+F1_XFRTIMP+F1_SEGURO))
			End
			MsUnLock()
			dbSkip()
		End
	End
	dbSetOrder(nOrder)
	dbGoTo(nRecno)
EndIf


RestArea(_aAreaSE2)
RestArea(_aArea)
Return(.t.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Funcao para gravar no SF1³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function Grava()

DbSelectArea("SF1")

Reclock("SF1",.F.)
SF1->F1_TRANSP  := cTransp
SF1->F1_XVALII  := nValII
SF1->F1_XFRTIMP := nFrtImp
SF1->F1_XFRTPRE := cFrtPre
SF1->F1_XSISCOM := nSiscom
SF1->F1_XVALSEG := nValSeg
SF1->F1_MENNOTA	:= Alltrim(cMenNota)	// ADICIONADO POR JACKSON EM 04/08/2016 - TAMANHO DO CAMPO AUMENTADO PARA 254 CARACTERES - PADRAO 60
SF1->F1_XMENNOT := Alltrim(cMenNota)
SF1->F1_CONTROL := Replicate( '0', 10-Len(Alltrim(cControl)) ) + AllTrim(cControl)
SF1->F1_XDI     := cNumDI
SF1->F1_XDTDI   := cDataDI
SF1->F1_XLDESE  := cLocDesem
SF1->F1_XUFDES  := cUfDesem
SF1->F1_XDTDES  := cDataDesem
SF1->F1_XVBC    := nValBasC
SF1->F1_XVDEPAD := nValDePad
SF1->F1_XVIOF   := nValIof
If nOpc = 1
	SF1->F1_XFORFIX := cXForFix
	SF1->F1_XLOJFIX := cXLojFix
	SF1->F1_XCCFF   := cXCCFix
End
MsUnlock()

//	Correcao para gravar os dados na tabela CD5 que e o correto para notas de importacao, do contrario
//	Apresenta erro no Sped Pis Cofins para estas notas fiscais. Alexandre 30/04/2012  
If !empty(cNumDI)
	U_TTFIS01DI('CD5',SF1->F1_FILIAL,SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA,cNumDI,cVTransp,cfImp)
EndIf

Close(oDlg)

Return()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega Variaveis                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFRec    := SF1->(RECNO())
cMot     := SF1->F1_MOTIVO
cHist    := SF1->F1_HIST
cMen     := SF1->F1_MENS
cControl := SF1->F1_CONTROL
cFornece := SF1->F1_FORNECE
cLoja    := SF1->F1_LOJA
cPrefixo := SF1->F1_SERIE
cNum     := SF1->F1_DOC
cNatur   := Space(10)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Motivo da Devolucao                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF SF1->F1_TIPO == "D"
	While Empty(cMot)
		@ 127,112 To 350,730 DIALOG _oObjeto1 TITLE "Cadastro do Motivo da Devolucao"
		@ 010,005 Say "Atencao !!!"
		@ 030,005 Say "Como esta e uma nota de devolucao,"
		@ 040,005 Say "deve-se cadastrar o motivo, fazendo"
		@ 050,005 Say "assim uma classificacao."
		@ 080,005 Say "Motivo :"
		@ 080,025 GET cMot PICTURE "@!" VALID .t. F3 "MOT"
		@ 040,260 BMPBUTTON TYPE 1 ACTION Close(_oObjeto1)   // Botao de confirmacao
		ACTIVATE DIALOG _oObjeto1 CENTERED
	End
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava dados SF1                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RecLock("SF1",.f.)
SF1->F1_MOTIVO := cMOT
SF1->F1_CONTROL:= cControl
SF1->F1_HIST   := AllTrim(cHist)
SF1->F1_MENS   := AllTrim(cMen)
MsUnlock()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Contas a Pagar                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE2")
dbSetOrder(6)
nOrder   := IndexOrd()
nRecno   := Recno()
If dbSeek(xFilial("SE2")+cFornece+cLoja+cPrefixo+cNum)
	While !Eof() .and. cFornece == SE2->E2_FORNECE .and. cLoja == SE2->E2_LOJA .AND. ;
		cPrefixo == SE2->E2_PREFIXO .and. cNum == SE2->E2_NUM
		RecLock("SE2",.f.)                                                        // Alterado em 27/09/05
		REPLACE SE2->E2_DTNFINC  WITH date()
		REPLACE SE2->E2_CONTROL  WITH cControl
		MsUnLock()
		dbSkip()
	End
End
dbSetOrder(nOrder)
dbGoTo(nRecno)
