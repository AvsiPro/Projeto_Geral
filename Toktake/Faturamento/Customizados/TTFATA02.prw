#INCLUDE "PROTHEUS.CH"
#INCLUDE "TopConn.ch"
#INCLUDE "font.ch"
#INCLUDE "colors.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � TTFATA02 � Autor �    TOTVS              � Data �  OUT/2009���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Atribui numero de romaneio para notas selecionada.         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TTFATA02()

Local oDlg
Private _aItems := { "Notas de Saida","Notas de Devolu��o" }
Private _cCombo := _aItems[1]
Private _lNfSaida := .T.

If cEmpAnt == "10"
	Return
EndIf

/*
Notas de devolucao deverao estar sempre em romaneio separado pois a tabela do browse eh diferente
*/

// filtro - notas de saida ou notas de devolucao?
oDlg := MsDialog():New(000,000,210,318,"Romaneio de Carga",,,,,CLR_BLACK,CLR_HGRAY,,,.T.)
 			
	@ 05,60 Say "Tipo de Nota" Pixel  Of oDlg	 		
	
	oCBox1 := TComboBox():New( 20,50,{|u|if( PCount()>0,_cCombo:=u,_cCombo )},_aItems,070,15,oDlg,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,_cCombo)	
			
				
	opButton1 := tButton():New(065,010,"&Confirmar" 	,oDlg,{ || oDlg:End(),BrwIni() },70,20,,,,.T.)
	opButton2 := tButton():New(065,080,"&Sair" 			,oDlg,{ || oDlg:End() },70,20,,,,.T.)

oDlg:Activate(,,,.T.,,,)  

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BrwIni  �Autor  �Microsiga           � Data �  05/05/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function BrwIni()

Local aCores    := {}
Local cFiltro	:= ""
Local aIndex	:= {}
PRIVATE cCadastro := OemToAnsi( "Romaneio de Carga" )
PRIVATE aRotina   := MenuDef()
PRIVATE cMarca 	  := GetMark()
PRIVATE cNumCarg  := CriaVar("F2_XCARGA")
PRIVATE cPerg     := "TTFATA02  "
PRIVATE lFaz	  := .f. 
Private bFiltraBrw := Nil 


// tipo escolhido no combo
IIF(oCBOX1 <> NIL .Or. oCBOX1 == 0,nPos := oCBOX1:nAt,1)
If nPos == 2
	_lNfSaida := .F.
EndIf

// notas de saida
If _lNfSaida

	cCadastro := "Romaneio de Carga - Sa�da"
	
	// Gambiarra temporaria - campos customizados criados somente na tok take
	If cEmpAnt == "01"
		aCores    := {	{  '!Empty(F2_XCARGA) .AND. F2_XDEVENT=="1"'	, 'BR_PRETO'}	,;	// NF c/ Devolu��o Total
						{  '!Empty(F2_XCARGA) .AND. F2_XDEVENT=="2"'	, 'BR_MARROM'}	,;	// NF c/ Devolu��o Parcial
						{  'Empty(F2_XCARGA)'	                        , 'ENABLE'}	    ,;	// NF s/ Romaneio
						{  '!Empty(F2_XCARGA) .AND. Empty(F2_XMOTOR)'	, 'BR_AMARELO'}	,;	// NF c/ Romaneio selecionado
						{  '!Empty(F2_XCARGA) .AND. !Empty(F2_XMOTOR)'	, 'DISABLE'} } 		// NF c/ romaneio confirmado
	Else 
		aCores    := {	{  'Empty(F2_XCARGA)'	                        , 'ENABLE'}	    ,;	// NF s/ Romaneio
						{  '!Empty(F2_XCARGA) .AND. Empty(F2_XMOTOR)'	, 'BR_AMARELO'}	,;	// NF c/ Romaneio selecionado
						{  '!Empty(F2_XCARGA) .AND. !Empty(F2_XMOTOR)'	, 'DISABLE'} } 		// NF c/ romaneio confirmado
	EndIf
	
	DbSelectArea("SF2")
	DbSetOrder(1)
	
	cFiltro := "F2_TIPO == 'N'"
	bFiltraBrw := { || FilBrowse( "SF2" , @aIndex , @cFiltro ) }
	                                        
	Eval( bFiltraBrw )
	
	mBrowse(6,1,22,75,"SF2",,,,,,aCores)
	EndFilBrw( "SF2" , @aIndex )
// notas devolucao
Else

	cCadastro := "Romaneio de Carga - Devolu��o"

	aCores    := {	{  'Empty(F1_XCARGA)'	                        , 'ENABLE'}	    ,;	// NF s/ Romaneio
					{  '!Empty(F1_XCARGA) .AND. Empty(F1_XMOTOR)'	, 'BR_AMARELO'}	,;	// NF c/ Romaneio selecionado
					{  '!Empty(F1_XCARGA) .AND. !Empty(F1_XMOTOR)'	, 'DISABLE'} } 		// NF c/ romaneio confirmado
						
	DbSelectArea("SF1")
	DbSetOrder(1)  
	
	cFiltro := "F1_TIPO == 'D' .AND. F1_FORNECE = '000001' "	// DEVOLUCAO + TOK TAKE
	bFiltraBrw := { || FilBrowse( "SF1" , @aIndex , @cFiltro ) }
	                                        
	Eval( bFiltraBrw )
	mBrowse(6,1,22,75,"SF1",,,,,,aCores)
	EndFilBrw( "SF1" , @aIndex )
EndIf

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �TFATA021  � Autor �    TOTVS              � Data �  OUT/2009���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Inicio da rotina.                                          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TFATA021()

Local aRegs		:= {}
Local aArea		:= GetArea()

PRIVATE nValor  := 0
PRIVATE nNf		:= 0
Private aListBox := {}
Private oListBox

//+--------------------------+
//| Cria as perguntas em SX1 |
//+--------------------------+

aAdd(aRegs,{cPerg,"01","Transportadora?"	,"","","mv_ch1","C",6,0,0,"G","","MV_PAR01",""		,"","","","",""		,"","","","","","","","","","","","","","","","","","","SA4"	,"",""	,"",""})
aAdd(aRegs,{cPerg,"02","Emissao De?"		,"","","mv_ch2","D",8,0,0,"G","","MV_PAR02",""		,"","","","",""		,"","","","","","","","","","","","","","","","","","",""		,"",""	,"",""})
aAdd(aRegs,{cPerg,"03","Emissao Ate?"		,"","","mv_ch3","D",8,0,0,"G","","MV_PAR03",""		,"","","","",""		,"","","","","","","","","","","","","","","","","","",""		,"",""	,"",""})
aAdd(aRegs,{cPerg,"04","Cliente de?"		,"","","mv_ch4","C",6,0,0,"G","","MV_PAR04",""		,"","","","",""		,"","","","","","","","","","","","","","","","","","","SA1"	,"",""	,"",""})
aAdd(aRegs,{cPerg,"05","Loja de?"			,"","","mv_ch5","C",4,0,0,"G","","MV_PAR05",""		,"","","","",""		,"","","","","","","","","","","","","","","","","","",""		,"",""	,"",""})
aAdd(aRegs,{cPerg,"06","Cliente ate?"		,"","","mv_ch6","C",6,0,0,"G","","MV_PAR06",""		,"","","","",""		,"","","","","","","","","","","","","","","","","","","SA1"	,"",""	,"",""})
aAdd(aRegs,{cPerg,"07","Loja ate?"			,"","","mv_ch7","C",4,0,0,"G","","MV_PAR07",""		,"","","","",""		,"","","","","","","","","","","","","","","","","","",""		,"",""	,"",""})
aAdd(aRegs,{cPerg,"08","Municipo?"			,"","","mv_ch8","C",5,0,0,"G","","MV_PAR08",""		,"","","","",""		,"","","","","","","","","","","","","","","","","","","CC2"	,"",""	,"",""})
aAdd(aRegs,{cPerg,"09","CEP De?"			,"","","mv_ch9","C",8,0,0,"G","","MV_PAR09",""		,"","","","",""		,"","","","","","","","","","","","","","","","","","",""		,"",""	,"",""})
aAdd(aRegs,{cPerg,"10","CEP Ate?"			,"","","mv_cha","C",8,0,0,"G","","MV_PAR10",""		,"","","","",""		,"","","","","","","","","","","","","","","","","","",""		,"",""	,"",""})
aAdd(aRegs,{cPerg,"11","Finalidade" 		,"","","mv_chb","N",1,0,0,"C","","MV_PAR11","Venda Direta","","","","","Venda PA","","","","","Transferencia","","","","","Abastecimento","","","","","Todas Nfs","","","","","","","",""})

U_CriaSx1(aRegs)

If !Pergunte(cPerg,.T.)
	Return()
Else
	TFATA02a()
Endif

RestArea(aArea)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �TFATA02a  � Autor �      TOTVS            � Data �  OUT/2009���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Executa montagem do array do listbox.                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function TFATA02a()

Local nTotRegs	:=0

Processa({|| TFATA02b(nTotRegs) },"Selecionando Notas...")

/*-------------------------------------------------------------------------------------|
| Condi��o inserida por F�bio Sales no dia 13/09/2011 para verificar se o array que    |
| alimenta o ListBox com os dados das notas fiscais de sa�da possui elementos.         |
|-------------------------------------------------------------------------------------*/ 
If Len(aListBox)==0
	Alert("N�o existem notas a serem romaneadas. Verifique os par�metros")
	Return()
EndIf                                                                     

TFATA02c(nTotRegs)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �TFATA02b  � Autor �       TOTVS           � Data � OUT/2009 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Monta array do listbox   conforme filtro.                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function TFATA02b(nTotRegs)

Local cAliasOri := Alias()
Local cQuery	:= ""
Local nCont		:= 0

If _lNfSaida
	cQuery := "SELECT F2_DOC NOTA,F2_SERIE SERIE,F2_CLIENTE CLIENTE,F2_LOJA LOJA,F2_EMISSAO EMISSAO,F2_EST ESTADO,F2_VALMERC VALOR,F2_TRANSP TRANSP,R_E_C_N_O_ REC,F2_TIPO TIPO"
	cQuery += " FROM  "+RetSqlName("SF2")
	cQuery += " WHERE F2_FILIAL = '"+xFilial("SF2")+"' "
	cQuery += " AND F2_TRANSP = '"+MV_PAR01+"' "
	cQuery += " AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
	cQuery += " AND F2_CLIENTE BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR06+"' "
	cQuery += " AND F2_LOJA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR07+"' "
	
	If !Empty(Alltrim(MV_PAR08))
		cQuery += " AND F2_XMUN = '"+Alltrim(MV_PAR08)+"' "
	EndIf
	
	cQuery += " AND F2_XCEP BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' "
	If Alltrim(Str(MV_PAR11)) <> "5"
		cQuery += " AND F2_XFINAL = '"+Alltrim(Str(MV_PAR11))+"' "
	Endif
	cQuery += " AND F2_SERIE = '2' "
	cQuery += " AND F2_XCARGA = '' "               
	cQuery += " AND F2_XVALDEV = 0 "               
	cQuery += " AND D_E_L_E_T_ <> '*' " 
	
	/*-----------------------------------------------------------------------------------------------------------------\
	| Incu�do por Fabio Sales em 15/05/2012 para ordenar as notas por numero e s�rie na rotina de separa��o de romaneio|
	\-----------------------------------------------------------------------------------------------------------------*/
	cQuery += " ORDER BY F2_DOC,F2_SERIE "
	
	U_MONTAQRY(cQuery,"QUERY")
	
	aEval(SF2->(dbStruct()), {|x| If(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField("QUERY",x[1],x[2],x[3],x[4]),Nil)})
	
	dbSelectArea("QUERY")
	
	nCont := RecCount("QUERY")
	
	ProcRegua(nCont)
	
	While !Eof()
		
		IncProc("Selecionando Notas... "+QUERY->NOTA+" / "+QUERY->SERIE )//Incrementa a regua
		
		nTotRegs++
		
		If QUERY->TIPO $ ("D/B")
			cNome := Posicione("SA2",1,xFilial("SA2")+QUERY->CLIENTE+QUERY->LOJA,"A2_NOME")
		Else
			cNome := Posicione("SA1",1,xFilial("SA1")+QUERY->CLIENTE+QUERY->LOJA,"A1_NOME")
		EndIF
		
		Aadd(aListBox,{.T.,;
		QUERY->NOTA,;
		QUERY->SERIE,;
		QUERY->CLIENTE,;
		QUERY->LOJA,;
		Alltrim(cNome),;
		Stod(QUERY->EMISSAO),;
		QUERY->ESTADO,;
		QUERY->VALOR,;
		QUERY->REC})
		
		//Carrego as variaveis a serem utilizadas no cabecalho
		nValor	+= QUERY->VALOR
		nNf 	+= 1
		
		dbSelectArea("QUERY")
		dbSkip()
	EndDo
	dbCloseArea()
	
	//Carrego as variaveis a serem utilizadas no cabecalho
	VerNumSeg()
	
	dbSelectArea(cAliasOri)

// notas devolucao	
Else

	// TODO: MONTAR CONSULTA
	cQuery := "SELECT F1_DOC NOTA,F1_SERIE SERIE,F1_FORNECE CLIENTE,F1_LOJA LOJA,F1_EMISSAO EMISSAO,F1_EST ESTADO,F1_VALMERC VALOR,F1_TRANSP TRANSP,R_E_C_N_O_ REC,F1_TIPO TIPO"
	cQuery += " FROM  "+RetSqlName("SF1")
	cQuery += " WHERE F1_FILIAL = '"+xFilial("SF1")+"' "
	cQuery += " AND F1_TIPO = 'D' "
	cQuery += " AND F1_EMISSAO BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' " 
	cQuery += " AND D_E_L_E_T_ = '' "
	cQuery += " AND F1_FORNECE = '000001' "	// somente tok take
	
	MpSysOpenQuery( cQuery,"QUERY" ) 
	
	dbSelectArea("QUERY")
	
	nCont := RecCount("QUERY")
	
	ProcRegua(nCont)
	
	While !Eof()
		
		IncProc("Selecionando Notas... "+QUERY->NOTA+" / "+QUERY->SERIE )//Incrementa a regua
		
		nTotRegs++
		
		cNome := Posicione("SA2",1,xFilial("SA2")+QUERY->CLIENTE+QUERY->LOJA,"A2_NOME")
	
		
		Aadd(aListBox,{.T.,;
						QUERY->NOTA,;
						QUERY->SERIE,;
						QUERY->CLIENTE,;
						QUERY->LOJA,;
						Alltrim(cNome),;
						Stod(QUERY->EMISSAO),;
						QUERY->ESTADO,;
						QUERY->VALOR,;
						QUERY->REC})
		
		//Carrego as variaveis a serem utilizadas no cabecalho
		nValor	+= QUERY->VALOR
		nNf 	+= 1
		
		dbSelectArea("QUERY")
		dbSkip()
	EndDo
	dbCloseArea()
	
	VerNumSeg() 

	dbSelectArea(cAliasOri)
EndIf	

Return

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �TFATA02c   � Autor �     TOTVS             � Data �  OUT/2009���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Mostra o Browse para marcacao das Notas                     ���
��������������������������������������������������������������������������Ĵ��
��� Uso      �                                                             ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Static Function TFATA02c(nTotRegs)

LOCAL aSize 	:= MsAdvSize()
LOCAL aObjects 	:= {}
LOCAL cTransp	:= ""

PRIVATE lInverte:=.F., oDlg , oDlg1
PRIVATE inclui := .T.,nOpca:=0

PRIVATE oValor := 0

AAdd( aObjects, { 100, 100, .T., .T. } )
aInfo := { aSize[1],aSize[2],aSize[3],aSize[4],3,3}
aObj  := MsObjSize( aInfo, aObjects, .T. )

cTransp := Posicione("SA4",1,xFilial("SA4")+MV_PAR01,"A4_NOME")

DEFINE MSDIALOG oDlg TITLE OemToAnsi("Romaneio de Carga.") From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	cAlias:=Alias()
	
	@ 026, 030 SAY "TRANSP.:"  SIZE 20, 7 OF oDlg PIXEL
	@ 025, 060 MsGet oTransp	VAR cTransp	 When .f. SIZE 150, 7 OF oDlg PIXEL
	
	@ 015, 260 SAY "ROMANEIO:"  SIZE 50, 7 OF oDlg PIXEL
	@ 025, 260 MsGet oId	VAR cNumCarg	 When .f. SIZE 40, 7 OF oDlg PIXEL
	
	@ 015, 350 SAY "VALOR SELECIONADO"  SIZE 50, 7 OF oDlg PIXEL
	@ 025, 350 MsGet oValor	VAR nValor	Picture "@E 999,999,999.99" When .f. SIZE 50, 7 OF oDlg PIXEL
	
	@ 015, 450 SAY "NOTAS" SIZE 50, 7 OF oDlg PIXEL
	@ 025, 450 MsGet oNf	VAR nNf	Picture "@E 999,999" When .f. SIZE 25, 7 OF oDlg PIXEL
	
	// Chamada da ListBox
	fListBox()

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nopca:=1,If(TFATA02OK(),oDlg:End(),)},{||nopca:=0,oDlg:End()})

If nOpca == 1
	
	Processa( {|lEnd| FT02Make(@lEnd,nTotRegs)},cCadastro,OemToAnsi( "Atualizando Notas Selecionadas..." ),.F. )
	
	If lFaz
		Aviso( "Atencao !","As notas selecionadas receberam o romaneio numero "+cNumCarg+".",{"Ok"} )
	EndIf
	
EndIf

Return

/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   �fListBox()  � Autor �   Cadubitski          � Data �13/01/2010���
����������������������������������������������������������������������������Ĵ��
���Descricao  � Montagem da ListBox                                          ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
Static Function fListBox()

Local oOk 	   := LoadBitmap( GetResources(), "LBOK" )//"CHECKED"
Local oNo 	   := LoadBitmap( GetResources(), "LBNO" )//"UNCHECKED"


	// Para editar os Campos da ListBox inclua a linha abaixo          
	// na opcao de DuploClick da mesma, ou onde for mais conveniente   
	// lembre-se de mudar a picture respeitando a coluna a ser editada 
	// PS: Para habilitar o DuploClick selecione a op��o MarkBrowse da 
	//     ListBox para SIM.                                           
	// lEditCell( aListBox, oListBox, "@!", oListBox:ColPos )          

	@ C(038),C(010) ListBox oListBox Fields ;
		HEADER "","NOTA","SERIE","CLIENTE","LOJA","NOME","EMISSAO","EST","VALOR";
		Size C(470),C(170) Of oDlg Pixel;
		ColSizes 50,50,30,40,30,150,50,50;
	On DBLCLICK ( FT02Escol(oListBox:nAt,aListBox) , oListBox:Refresh() )
	                      
	oListBox:bHeaderClick := {|oObj,nCol| MarkAll(oListBox:nAt,aListBox),oObj:Refresh()}	//Marca de desmarca todos
	
	oListBox:SetArray(aListBox)

	oListBox:bLine := {|| {;
	If(aListBox[oListBox:nAT,1],oOk,oNo),;
		aListBox[oListBox:nAT,02],;
		aListBox[oListBox:nAT,03],;
		aListBox[oListBox:nAT,04],;
		aListBox[oListBox:nAT,05],;
		aListBox[oListBox:nAT,06],;
		aListBox[oListBox:nAT,07],;
		aListBox[oListBox:nAT,08],;
		Transform(aListBox[oListBox:nAT,09],PesqPict("SF2","F2_VALMERC"))}}
Return

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    � FT02Make  � Autor �    TOTVS              � Data � OUT/2009 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Atualiza as notas selecionadas com o numero do seguro.      ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
��� Uso      �                                                             ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

Static Function FT02Make(lEnd,nTotRegs)

Local cTitulo := "Confirma��o"
Local cReg	  := ""

If MsgYesNo("Confirma a execu��o?",cTitulo)
	
	For nX:=1 to Len(aListBox)
		
		If !aListBox[nX,1]//Se nao estiver marcado pula
			Loop
		EndIf
		
		If Empty(cReg)
			cReg := Alltrim(Str(aListBox[nX,10]))
		Else
			cReg +=","+Alltrim(Str(aListBox[nX,10]))
		EndIf
		      //aListBox[nX,02],aListBox[nX,03],aListBox[nX,04],aListBox[nX,05]
	Next
	
	If !Empty(cReg)
	             
		// nota saida
		If _lNfSaida
		
			//Funcao para achar o ultimo numero da ser utilizado
			VerNumSeg()
			
			cQuery := ""
			cQuery := " UPDATE "+RetSqlName("SF2")
			cQuery += " SET F2_XCARGA 	= '"+cNumCarg+"' "
			cQuery += " WHERE R_E_C_N_O_ IN ("+cReg+") "
			
			TCSQLExec(cQuery) 	//executo o update na string cUpdate
			//TCSQLExec("COMMIT")	//por GARANTIA dou um COMMIT
			
			lFaz := .t.
		// nota devolucao
		Else
		
			//Funcao para achar o ultimo numero da ser utilizado
			VerNumSeg()
			
			cQuery := ""
			cQuery := " UPDATE "+RetSqlName("SF1")
			cQuery += " SET F1_XCARGA 	= '"+cNumCarg+"' "
			cQuery += " WHERE R_E_C_N_O_ IN ("+cReg+") "
			
			TCSQLExec(cQuery) 	//executo o update na string cUpdate
			//TCSQLExec("COMMIT")	//por GARANTIA dou um COMMIT
			
			lFaz := .t.
			
		EndIf
		
	EndIf
	
Endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun��o   �TFATA02OK � Autor �    Totvs              � Data �  OUT/2009���
�������������������������������������������������������������������������Ĵ��
��� Descri��o� Confirmacao antes de executar.                             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � TFATA02OK                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function TFATA02OK()

Local lRet 	:= .t.

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FT02Escol  � Autor �      TOTVS          � Data �  OUT/2009���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Escolhe as NFs.                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FT02Escol(nAt,aListBox)

aListBox[oListBox:nAt,1] := !(aListBox[oListBox:nAt,1])

//Chama a rotina de atualizacao das variaveis de valores por selecao de cada registro
AtuVlr("1",oListBox:nAt,aListBox)

oDlg:Refresh()

Return(aListBox)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FT02MarkAll� Autor �     Totvs           � Data �  OUT/2009���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Inverte as NFs Marcadas/Desmarcadas                        ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MarkAll(nAt,aListBox)

For nX:=1 to Len(aListBox)
	aListBox[nX,1] := !(aListBox[nX,1])
Next

//Chama a rotina de atualizacao das variaveis de valores por selecao de todos registro
AtuVlr("2",oListBox:nAt,aListBox)

oDlg:Refresh()

Return(.T.)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �AtuVlr    � Autor � Microsiga             � Data �  Fev/2008���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
STATIC FUNCTION AtuVlr(cOpc,nAt,aListBox)

LOCAL nRecno:=Recno()

If cOpc == "1" //Selecao por registro
	
	If aListBox[oListBox:nAt,1]
		nValor 	+= aListBox[oListBox:nAt,9]
		nNf 	+= 1
	Else
		nValor 	-= aListBox[oListBox:nAt,9]
		nNf 	-= 1
	EndIf
	
Else
	
	For nX:=1 to Len(aListBox)
		If aListBox[nX,1]
			nValor 	+= aListBox[nX,9]
			nNf 	+= 1
		Else
			nValor 	-= aListBox[nX,9]
			nNf 	-= 1
		EndIf
	Next
	
EndIf

oValor	:Refresh()
oNf		:Refresh()
oDlg	:Refresh()

Return()

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �VerNota   � Autor � Microsiga             � Data �  Fev/2008���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
USER FUNCTION VerNota()

Local aArea2 	:= GetArea()
Local aAreaSF2 	:= Nil
Local aAreaSF1	:= Nil

// nota de saida
If _lNfSaida
	aAreaSF2 	:= SF2->(GetArea())

	dbSelectArea("SF2")
	dbSetOrder(1)
	If dbSeek(xFilial("SF2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
		nRecNo := RECNO()
		SF2->(Mc090Visual("SF2",nRecNo,2))
	Else
		Aviso("Aten��o","Nota n�o localizada!",{"Ok"})
	EndIf
	
	RestArea(aAreaSF2)
	RestArea(aArea2)
// nota de devolucao
Else
	aAreaSF1 	:= SF1->(GetArea())
	                
	// visualizar a nota de entrada
	dbSelectArea("SF1")
	dbSetOrder(1)
	If MSSeek(xFilial("SF1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
		dbSelectArea("SD1")
		dbSetOrder(1)                     
		If dbSeek( xFilial("SD1") +AvKey(SF1->F1_DOC,"D1_DOC") +AvKey(SF1->F1_SERIE,"D1_SERIE") +AvKey(SF1->F1_FORNECE,"D1_FORNECE") +AvKey(SF1->F1_LOJA,"D1_LOJA")  )
			A103NFiscal('SF1',SF1->( Recno() ),1)
		EndIf
	EndIf
	
	RestArea(aAreaSF1)
	RestArea(aArea2)	
EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �VerNumSeg � Autor � Microsiga             � Data �  Fev/2008���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static FUNCTION VerNumSeg()

cQuery := ""

// notas de saida
If _lNfSaida
	cQuery := "SELECT ISNULL(MAX(F2_XCARGA),' ') AS XCARGA "
	cQuery += " FROM "+RetSqlName("SF2")
	cQuery += " WHERE F2_FILIAL = '"+xFilial("SF2")+"' "
	cQuery += " AND F2_XCARGA <> ' ' "
	cQuery += " AND D_E_L_E_T_ <> '*' "
	
	U_MONTAQRY(cQuery,"TRC")
	
	cNumCarg := Soma1(TRC->XCARGA)
	
	If Select("TRC") > 0
		dbCloseArea("TRC")
	EndIf	
// notas de devolucao
Else
	// TODO: MONTAR CONSULTA  
	cQuery := "SELECT ISNULL(MAX(F1_XCARGA),' ') AS XCARGA "
	cQuery += " FROM "+RetSqlName("SF1")
	cQuery += " WHERE F1_FILIAL = '"+xFilial("SF1")+"' "
	cQuery += " AND F1_XCARGA <> ' ' "
	cQuery += " AND D_E_L_E_T_ <> '*' "
	
	U_MONTAQRY(cQuery,"TRC")
	
	cNumCarg := Soma1(TRC->XCARGA)
	
	If Select("TRC") > 0
		dbCloseArea("TRC")
	EndIf
EndIf

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �TFATA022  � Autor �    TOTVS              � Data �  Jun/2009���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Estorno do processo                                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TFATA022()

Local cCarga := ""	//SF2->F2_XCARGA
Local nExec := 0

If _lNfSaida

	cCarga := SF2->F2_XCARGA

	//Verifica se eh uma carga valida
	If Empty(cCarga)
		Aviso("Estorno Vazio","Romaneio n�o � valido!",{"Ok"})
	Else
		//Verifica se nao eh um romaneio confirmado
		If Empty(SF2->F2_XPLACA)
			//Chama rotina para estono
			If MsgNoYes("Confirma o estorno do romaneio "+Alltrim(cCarga)+"?","Estorno")
				nExec := EstCarga(cCarga)
				If nExec >= 0
					Aviso("Estono","Carga estornada!",{"Ok"})
				EndIf
			EndIf
		Else
			If cusername $ "ADMIN|JDEUS"
				If MsgNoYes("Confirma o estorno do romaneio "+Alltrim(cCarga)+"?","Estorno")
					nExec := EstCarga(cCarga)
					If nExec >= 0
						Aviso("Estorno","Carga estornada!",{"Ok"})
					EndIf
				EndIf	
			Else  
				Aviso("Estorno","Usu�rio sem permiss�o para estornar o romaneio.",{"Ok"})
				//Aviso("Estorno","Romaneio confirmado n�o pode ser estornado!",{"Ok"})
			EndIf
		EndIf	
	EndIf
//nota devolucao
Else

	cCarga := SF1->F1_XCARGA

	//Verifica se eh uma carga valida
	If Empty(cCarga)
		Aviso("Estorno Vazio","Romaneio n�o � valido!",{"Ok"})
	Else
		//Verifica se nao eh um romaneio confirmado
		If Empty(SF1->F1_XPLACA)
			//Chama rotina para estono
			If MsgNoYes("Confirma o estorno do romaneio "+Alltrim(cCarga)+"?","Estorno")
				nExec := EstCarga(cCarga)
				If nExec >= 0
					Aviso("Estono","Carga estornada!",{"Ok"})
				EndIf
			EndIf
		Else
			If cusername $ "ADMIN|JDEUS"
				If MsgNoYes("Confirma o estorno do romaneio "+Alltrim(cCarga)+"?","Estorno")
					nExec := EstCarga(cCarga)
					If nExec >= 0
						Aviso("Estorno","Carga estornada!",{"Ok"})
					EndIf
				EndIf	
			Else  
				Aviso("Estorno","Usu�rio sem permiss�o para estornar o romaneio.",{"Ok"})
				//Aviso("Estorno","Romaneio confirmado n�o pode ser estornado!",{"Ok"})
			EndIf
		EndIf	
	EndIf

EndIf


Return

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �EstCarga  � Autor �       TOTVS           � Data � Jun/2009  ���
��������������������������������������������������������������������������Ĵ��
���Descricao � Funcao para estornar a carga seleciona pelo usuario.        ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Parametros� ExpA1: Numero do seguro/carga                               ���
��������������������������������������������������������������������������Ĵ��
���Retorno   � Codigo da carga.                                            ���
��������������������������������������������������������������������������Ĵ��
���Uso       �                                                             ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Static Function EstCarga(cCarga)

Local cQuery := ""
Local nExec := 0

If _lNfSaida

	cQuery := " UPDATE "+RetSqlName("SF2")
	cQuery += " SET F2_XCARGA = ' ', F2_XPLACA = '', F2_XLACRE = '', F2_XMOTOR = '' "
	cQuery += " WHERE F2_FILIAL = '"+xFilial("SF2")+"' "
	cQuery += " AND F2_XCARGA = '"+cCarga+"' "
	cQuery += " AND D_E_L_E_T_ <> '*' "
	
	nExec := TCSQLExec(cQuery) 	//executo o update na string cUpdate
	
Else
	// TODO: MONTAR CONSULTA PARA NOTAS DE DEVOLUCAO
	cQuery := " UPDATE "+RetSqlName("SF1")
	cQuery += " SET F1_XCARGA = ' ', F1_XPLACA = '', F1_XLACRE = '', F1_XMOTOR = '' "
	cQuery += " WHERE F1_FILIAL = '"+xFilial("SF1")+"' "
	cQuery += " AND F1_XCARGA = '"+cCarga+"' "
	cQuery += " AND D_E_L_E_T_ <> '*' "
	
	nExec := TCSQLExec(cQuery) 	//executo o update na string cUpdate
EndIf


Return nExec

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �TFATA023  � Autor �    TOTVS              � Data �  Jun/2009���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Confirmacao do romaneio                                    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TFATA023()

Local cCarga	:= IIF( _lNfSaida,SF2->F2_XCARGA,SF1->F1_XCARGA ) 
Local cPlaca	:= CriaVar("F2_XPLACA")
Local cLacre	:= CriaVar("F2_XLACRE")
Local cMotor	:= CriaVar("F2_XMOTOR") 
Local nOpc
Local cUsrAut   := Upper(AllTrim(SuperGetMV("MV_XROMUSR")))
Local cUserLib  := Upper(AllTrim(cusername))                
Local lAtvBlq	:= SuperGetMV( "MV_XLOG005",.T.,.F. )
Local nExec		:= 0 
Local lMtOk		:= .T.
Local cxPlaca	:= IIF( _lNfSaida,SF2->F2_XPLACA,SF1->F1_XPLACA ) 
Private cNomM	:= ""

IF !(cUserLib$(cUsrAut))
	MsgStop(AllTrim(cusername)+" n�o tem permiss�o para acessar esta rotina.", "Usu�rio sem Permiss�o")
	Return .F.
End                   

If _lNfSaida
	dbSelectArea("SF2")
Else 
	dbSelectArea("SF1")
EndIf

//Verifica se eh uma carga valida
If Empty(cCarga)
	Aviso("Confirma��o Vazio","Romaneio n�o � valido!",{"Ok"})
Else
	//Verifica se nao eh um romaneio confirmado
	If Empty(cxPlaca)
		
		DEFINE MSDIALOG oDlg FROM U_C(254),U_C(324) TO U_C(430),U_C(644) PIXEL TITLE "Confirma��o do Romaneio"
		
		@U_C(007),U_C(012) SAY "Romaneio"           		 	SIZE U_C(026),U_C(8) OF oDlg PIXEL
		@U_C(017),U_C(011) MsGet oCarga	 VAR cCarga	When .f. 	SIZE U_C(035),U_C(9) OF oDlg PIXEL
		
		@U_C(034),U_C(011) SAY "C�digo Motorista"      		 	SIZE U_C(043),U_C(8) OF oDlg PIXEL
		@U_C(044),U_C(011) MsGet oMotor VAR cMotor	When .t.  	Valid(!Empty(Alltrim(cMotor)) .and. xnome(Alltrim(cMotor)) .and. existcpo("DA4",cMotor)) SIZE U_C(030),U_C(9) F3 "DA4" OF oDlg PIXEL
		                                                                                                                             
		@U_C(034),U_C(068) SAY "Nome Motorista"        		 	SIZE U_C(043),U_C(8) OF oDlg PIXEL
		@U_C(044),U_C(067) MsGet oMotor2 VAR cNomM	When .f. 	SIZE U_C(81),U_C(9) OF oDlg PIXEL
                                                                                                  
		@U_C(007),U_C(068) SAY "Veiculo"           			 	SIZE U_C(015),U_C(8) OF oDlg PIXEL                                                               
		@U_C(017),U_C(067) MsGet oPlaca	 VAR cPlaca	When .t. Valid(!Empty(Alltrim(cPlaca)) .and. existcpo("DA3",cPlaca))	SIZE U_C(030),U_C(9) F3 "DA3" OF oDlg PIXEL
	
		//@U_C(007),U_C(111) SAY "Lacre"           			 	SIZE U_C(015),U_C(8) OF oDlg PIXEL
		//@U_C(017),U_C(111) MsGet oLacre	 VAR cLacre	When .t. 	Valid(!Empty(Alltrim(cLacre))) SIZE U_C(030),U_C(9) OF oDlg PIXEL
		
		
		DEFINE SBUTTON FROM U_C(067),U_C(078) TYPE 1 OF oDlg ENABLE ACTION (nOpc := 1, oDlg:End())
		DEFINE SBUTTON FROM U_C(067),U_C(121) TYPE 2 OF oDlg ENABLE ACTION (nOpc := 2, oDlg:End())
		
		ACTIVATE MSDIALOG oDlg CENTERED
		
		If nOpc == 1
			If lAtvBlq .And. !_lNfSaida	// para notas de devolucao nao precisa validar
				lMtOk := MotorLib(cMotor)
				If !lMtOk
					MsgAlert("O motorista n�o pode ter mais de 2 romaneios em aberto!")
				EndIf
			EndIf
			
			If lMtOk
				If MsgNoYes("Deseja confirmar o romaneio "+Alltrim(cCarga)+"?","Confirma��o")
					nExec := ConfCarg(cCarga,cPlaca,cLacre,cMotor,cNomM)
					If nExec >= 0
						Aviso("Confirma��o","Romaneio confirmado!",{"Ok"})
					EndIf
				EndIf
			EndIf	
		EndIf	
	Else
		Aviso("Confirma��o","Romaneio j� confirmado!",{"Ok"})
	EndIf	
EndIf

Return

      
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTFATA02  �Autor  �Microsiga           � Data �  04/06/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function xnome(cMotor)

cNomM := Posicione( "DA4",1,xFilial("DA4")+cMotor,"DA4_NOME" )
                            
Return .T.
/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �ConfCarg  � Autor �       TOTVS           � Data � Jun/2009  ���
��������������������������������������������������������������������������Ĵ��
���Descricao � Funcao para confirmar a carga seleciona pelo usuario.       ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Parametros� ExpA1: Numero da carga                                      ���
��������������������������������������������������������������������������Ĵ��
���Retorno   � Codigo da carga.                                            ���
��������������������������������������������������������������������������Ĵ��
���Uso       �                                                             ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Static Function ConfCarg(cCarga,cPlaca,cLacre,cMotor,cNomM)
                   
Local aArea	 := GetArea()
Local cQuery := "" 
Local nTam := TamSx3("F2_XMOTOR")[1]
Local nExec := 0
Local cXMotor := Alltrim(cMotor)+"-"+Alltrim(cNomM)

If Len(cXMotor) > nTam
	cXMotor := SubStr(cXMotor,1,nTam)
EndIf

If _lNfSaida
	cQuery := " UPDATE "+RetSqlName("SF2")
	cQuery += " SET F2_XPLACA = '"+Transform(cPlaca,"@R XXX-9999")+"', "
	cQuery += " F2_XLACRE = '"+cLacre+"', "
	cQuery += " F2_XMOTOR = '"+cXMotor+"' " 
	
	If cEmpAnt=="01"  .OR. cEmpAnt=="02"
		cQuery += " ,F2_XDTROM ='"+Dtos(dDataBase)+"' " // incluido por fabio sales em 23/12/2011 para gravar a data da gera��o do romaneio
		cQuery += " ,F2_XHORROM = '"+Time()+"' "  		//incluido por fabio sales em 23/12/2011 para gravar a hora da gera��o do romaneio
	EndIf
	
	cQuery += " WHERE F2_FILIAL = '"+xFilial("SF2")+"' "
	cQuery += " AND F2_XCARGA = '"+cCarga+"' "
	cQuery += " AND D_E_L_E_T_ <> '*' " 
	
	
	nExec := TCSQLExec(cQuery)	// < 0)
	If nExec < 0
		MsgStop( "ERRO " +CRLF + TCSQLError() )
	EndIf
	
	RestArea(aArea)
// nota devolucao
Else

	cQuery := " UPDATE "+RetSqlName("SF1")
	cQuery += " SET F1_XPLACA = '"+Transform(cPlaca,"@R XXX-9999")+"', "
	cQuery += " F1_XLACRE = '"+cLacre+"', "
	cQuery += " F1_XMOTOR = '"+cXMotor+"' " 
	
	If cEmpAnt=="01"  .OR. cEmpAnt=="02"
		cQuery += " ,F1_XDTROM ='"+Dtos(dDataBase)+"' " // incluido por fabio sales em 23/12/2011 para gravar a data da gera��o do romaneio
		cQuery += " ,F1_XHORROM = '"+Time()+"' "  		//incluido por fabio sales em 23/12/2011 para gravar a hora da gera��o do romaneio
	EndIf
	
	cQuery += " WHERE F1_FILIAL = '"+xFilial("SF1")+"' "
	cQuery += " AND F1_XCARGA = '"+cCarga+"' "
	cQuery += " AND D_E_L_E_T_ <> '*' " 
	
	
	nExec := TCSQLExec(cQuery)	// < 0)
	If nExec < 0
		MsgStop( "ERRO " +CRLF + TCSQLError() )
	EndIf
	
	RestArea(aArea)

EndIf	
	

Return nExec



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �TFATA024  � Autor �    TOTVS              � Data �  Jun/2009���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Manutencao do romaneio                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TFATA024()

Local cPlaca   := IIF( _lNfSaida,SF2->F2_XPLACA,SF1->F1_XPLACA ) 
Local cCarga   := IIF( _lNfSaida,SF2->F2_XCARGA,SF1->F1_XCARGA ) 	//SF2->F2_XCARGA
Local cTransp  := IIF( _lNfSaida,SF2->F2_TRANSP,SF1->F1_TRANSP ) 	//SF2->F2_TRANSP
Local cDoc     := IIF( _lNfSaida,SF2->F2_DOC,SF1->F1_DOC )			//SF2->F2_DOC
Local cSer     := IIF( _lNfSaida,SF2->F2_SERIE,SF1->F1_SERIE )		//SF2->F2_SERIE
Local cCli     := IIF( _lNfSaida,SF2->F2_CLIENTE,SF1->F1_FORNECE )	//SF2->F2_CLIENTE
Local cLoja    := IIF( _lNfSaida,SF2->F2_LOJA,SF1->F1_LOJA )		//SF2->F2_LOJA
Local cTipo    := IIF( _lNfSaida,SF2->F2_TIPO,SF1->F1_TIPO )		//SF2->F2_TIPO
Local cCliente := IIF( _lNfSaida,GetAdvFval( "SA1","A1_NREDUZ",xFilial("SA1")+cCli+cLoja,1 ),GetAdvFval( "SA2","A2_NREDUZ",xFilial("SA1")+cCli+cLoja,1 ) )		//GetAdvFval( "SA1","A1_NREDUZ",xFilial("SA1")+cCli+cLoja,1 )
Local nOpc
Local cUsrAut   := Upper(AllTrim(SuperGetMV("MV_XROMUSR")))
Local cUserLib  := Upper(AllTrim(cusername))


IF !(cUserLib$(cUsrAut))
	MsgStop(AllTrim(cusername)+" n�o tem permiss�o para acessar esta rotina.", "Usu�rio sem Permiss�o")
	Return()
End


If !Empty(cPlaca)
	Aviso("Romaneio confirmado","Exclus�o n�o � valida!",{"Ok"})
Else
		
	DEFINE MSDIALOG oDlg FROM U_C(254),U_C(324) TO U_C(430),U_C(644) PIXEL TITLE "Manuten��o do Romaneio"
	
	@U_C(007),U_C(012) SAY "Romaneio"           		 	SIZE U_C(026),U_C(8) OF oDlg PIXEL
	@U_C(017),U_C(011) MsGet oCarga	  VAR cCarga	When .f. 	SIZE U_C(035),U_C(9) OF oDlg PIXEL
	
	@U_C(007),U_C(068) SAY "NF"             			 	SIZE U_C(015),U_C(8) OF oDlg PIXEL
	@U_C(017),U_C(067) MsGet oDoc     VAR cDoc	    When .f. SIZE U_C(030),U_C(9) OF oDlg PIXEL
	
	@U_C(007),U_C(111) SAY "Transp."           			 	SIZE U_C(015),U_C(8) OF oDlg PIXEL
	@U_C(017),U_C(111) MsGet oTtansp  VAR cTransp	When .f. 	SIZE U_C(030),U_C(9) OF oDlg PIXEL
	
	@U_C(034),U_C(011) SAY "Cliente"             		 	SIZE U_C(023),U_C(8) OF oDlg PIXEL
	@U_C(044),U_C(011) MsGet oCliente VAR cCliente	When .f. 	SIZE U_C(138),U_C(9) OF oDlg PIXEL
	
	DEFINE SBUTTON FROM U_C(067),U_C(078) TYPE 1 OF oDlg ENABLE ACTION (nOpc := 1, oDlg:End())
	DEFINE SBUTTON FROM U_C(067),U_C(121) TYPE 2 OF oDlg ENABLE ACTION (nOpc := 2, oDlg:End())
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
	If nOpc == 1
		//Chama rotina para confirmacao
		If MsgNoYes("Deseja excluir a NF "+Alltrim(cDoc)+" do romaneio "+Alltrim(cCarga)+"?","Confirma��o")
		   ManuCarg(cDoc,cSer,cCli,cLoja,cTipo)
   			Aviso("Confirma��o","Exclus�o confirmada!",{"Ok"})
		EndIf
	EndIf
			
EndIf

Return

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �ManuCarg  � Autor �       TOTVS           � Data � Jun/2009  ���
��������������������������������������������������������������������������Ĵ��
���Descricao � Funcao para confirmar a carga seleciona pelo usuario.       ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Parametros� ExpA1: Numero da carga                                      ���
��������������������������������������������������������������������������Ĵ��
���Retorno   � Codigo da carga.                                            ���
��������������������������������������������������������������������������Ĵ��
���Uso       �                                                             ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Static Function ManuCarg(cDoc,cSer,cCli,cLoja,cTipo)

Local cQuery := ""


If _lNfSaida
	cQuery := " UPDATE "+RetSqlName("SF2")
	cQuery += " SET F2_XCARGA = '', "
	cQuery += " F2_XPLACA = '', "
	cQuery += " F2_XLACRE = '', "
	cQuery += " F2_XMOTOR = '' "
	cQuery += " WHERE F2_FILIAL = '"+xFilial("SF2")+"' "
	cQuery += " AND F2_DOC = '"+cDoc+"' "
	cQuery += " AND F2_SERIE = '"+cSer+"' "
	cQuery += " AND F2_CLIENTE = '"+cCli+"' "
	cQuery += " AND F2_LOJA = '"+cLoja+"' "
	cQuery += " AND F2_TIPO = '"+cTipo+"' "
	cQuery += " AND D_E_L_E_T_ <> '*' "
	
	TCSQLExec(cQuery) 	//executo o update na string cUpdate

Else
	cQuery := " UPDATE "+RetSqlName("SF1")
	cQuery += " SET F1_XCARGA = '', "
	cQuery += " F1_XPLACA = '', "
	cQuery += " F1_XLACRE = '', "
	cQuery += " F1_XMOTOR = '' "
	cQuery += " WHERE F1_FILIAL = '"+xFilial("SF1")+"' "
	cQuery += " AND F1_DOC = '"+cDoc+"' "
	cQuery += " AND F1_SERIE = '"+cSer+"' "
	cQuery += " AND F1_FORNECE = '"+cCli+"' "
	cQuery += " AND F1_LOJA = '"+cLoja+"' "
	cQuery += " AND F1_TIPO = '"+cTipo+"' "
	cQuery += " AND D_E_L_E_T_ <> '*' "
	
	TCSQLExec(cQuery) 	//executo o update na string cUpdate
EndIf

Return



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FTA02LEG  � Autor �     TOTVS            � Data � OUT/2009 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Cria uma janela contendo a legenda da mBrowse              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function FTA02LEG()

BrwLegenda(cCadastro,"Legenda",{{"ENABLE"		,"NF s/ Romaneio"},;
								{"BR_AMARELO"	,"NF c/ Romaneio"},;
								{"BR_PRETO"	    ,"NF c/ Devolu��o total"},;
								{"BR_MARROM"	,"NF c/ Devolu��o parcial"},;
								{"DISABLE"		,"Romaneio Confirmado"}	})
Return(.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MenuDef   � Autor � Microsiga             � Data �  Fev/2008���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function MenuDef()

Local aRotina := {  { "Pesquisar" 	,"AxPesqui"		, 0 , 1 },;
					{ "Visualizar"	,"U_VerNota()" 	, 0 , 2 },;
					{ "Selecionar"	,"U_TFATA021()"	, 0 , 3 },;
					{ "Estornar"	,"U_TFATA022()"	, 0 , 4 },;
					{ "Manuten��o"	,"U_TFATA024()"	, 0 , 4 },;
					{ "Confirmar"	,"U_TFATA023()"	, 0 , 5 },;
					{ "Relatorio"	,"U_TELREL()"	, 0 , 6 },;
					{ "Legenda"		,"U_FTA02LEG()"	, 0 , 7 },;
					{ "Rom x Mot" 	,"U_TTFAT03C()" , 0 , 8 },;
					{ "Notas x OS" 	,"U_TTFATR29()" , 0 , 9 },;
					{ "Painel"		,"U_TTFAT14C()"	, 0 ,10 },;
					{ "OS Mobile"	,"U_TTFAT17C()"	, 0 ,11 } }

Return (aRotina)

/*/
|---------------------------------------------------------------------------|
| Fun��o =   TELREL() | Autor /Fabio  Sales    |    � Data =  18/02/10      |
|---------------------------------------------------------------------------|
| Descri��o = TELA PARA CHAMAR OS RELATORIOS DE ROMANEIOS                   |
|---------------------------------------------------------------------------|
| Uso       = Faturamento                                                   |
|---------------------------------------------------------------------------|
/*/

User Function TELREL()
	oDlg := MsDialog():New(C(00),C(00),C(100),C(270),"RELATORIOS DE ROMANEIOS",,,,,CLR_WHITE,CLR_BLUE,,,.T.)
	
	Define FONT opFONT2 NAME "COURIER" Size 0,-15
		
	/*********************************************
	*     Desenho dos bot�es dos realat�rios     *
	*********************************************/
	
	@020,005  Button "ROMANEIO DE CARGA"	Size  80,10 Action ROMCARGA()	Pixel  FONT opFONT2 Of oDlg
	@020,090  Button "ROMANEIO POR NOTA"	Size  80,10 Action ROMNOTA()	Pixel  FONT opFONT2 Of oDlg
	
	oDlg:Activate(,,,.T.,,,) //concluindo o desenho da tela
Return()

/*/
|---------------------------------------------------------------------------|
| Fun��o =   ROMCARGA() | Autor /Fabio  Sales    |    � Data =  18/02/10    |
|---------------------------------------------------------------------------|
| Descri��o = REALIZA A CHAMADA DO RELATORIO DE ROMANEIO DE CARGA           |
|---------------------------------------------------------------------------|
| Uso       = Faturamento                                                   |
|---------------------------------------------------------------------------|
/*/
Static Function ROMCARGA()
	U_ROMCARG( _lNfSaida )
Return Nil

/*/
|---------------------------------------------------------------------------|
| Fun��o =   ROMCARGA() | Autor /Fabio  Sales    |    � Data =  18/02/10    |
|---------------------------------------------------------------------------|
| Descri��o = REALIZA A CHAMADA DO RELATORIO DE ROMANEIO POR NOTA           |
|---------------------------------------------------------------------------|
| Uso       = Faturamento                                                   |
|---------------------------------------------------------------------------|
/*/
Static Function ROMNOTA ()
	U_ROMNOT( _lNfSaida )
Return Nil
            
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTFATA02  �Autor  �Microsiga           � Data �  06/22/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function MotorLib(cMotor)

Local aArea	:=	GetArea()
Local cQuery  
Local nRom	:=	0
Local lRom	:=	.T.
Local aDtRom := {}
Local nPos := 0

cQuery := "SELECT F2_XCARGA,F2_XDTROM,COUNT(*) NF_ROM,(CASE WHEN F2_XRECENT='S' THEN SUM(1) ELSE 0 END ) CANHOTOS"
cQuery += " FROM "+RetSQLName("SF2")
cQuery += " WHERE F2_EMISSAO >= '20160101' AND D_E_L_E_T_='' AND F2_TRANSP='000019' AND SUBSTRING(F2_XMOTOR,1,6)= '"+cMotor+"'"
cQuery += " AND F2_XDTROM <> '"+DTOS(DATE())+"' AND F2_XDEVENT = '' " 
cQuery += " GROUP BY F2_XCARGA,F2_XDTROM,F2_XRECENT"

If Select("TRB") > 0   
	dbSelectArea("TRB")
	dbCloseArea()
EndIf


cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

dbSelectArea("TRB") 

While !EOF()
	If TRB->NF_ROM - TRB->CANHOTOS > 0
		nRom++
		nPOs := Ascan( aDtRom, { |x| x == TRB->F2_XDTROM } )
		If nPos == 0
			AADD( aDtRom, TRB->F2_XDTROM  ) 
		EndIf	
	EndIf
	dbskip()
EndDo          
         
If Len(aDtRom) > 2
	lRom := .F.
EndIf

RestArea(aArea)

Return(lRom)