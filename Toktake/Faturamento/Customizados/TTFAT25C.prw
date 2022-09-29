#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTFAT25C  �Autor  �Jackson E. de Deus  � Data �  22/09/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Faturamento automatico e transmissao de notas              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTFAT25C()

Local cArquivo		:= Nil
Local _afields		:= LoadField(@cArquivo)
Local nTempo		:= 60000
Local aSize			:= {}
Local oLayer		:= FwLayer():New()
Private aRotina		:= {}
Private cCadastro	:= "Faturamento Tok Take" 
Private cMark		:= GetMark()
Private _lRefresh	:= .F.
Private aColors		:= {}

If cEmpAnt <> "01"
	Return
EndIf

aColors := {{"EMPTY(TRB1->NOTA)","BR_VERMELHO"},;
			{"!EMPTY(TRB1->NOTA)","BR_PINK"},;
			{"!EMPTY(TRB1->NOTA) .AND. !Empty(TRB1->XMLENV)","BR_VERDE"}}
			

aRotina := {{ "Visualizar"			, "STATICCALL(TTFAT25C,VerPed)"		, 0, 2 },;
			{ "Faturar"				, "STATICCALL(TTFAT25C,FatPeds)"	, 0, 3 },;
			{ "Transmitir notas"	, "STATICCALL(TTFAT25C,NFECONN)"	, 0, 6 },;
			{ "Monitor sefaz"		, "SpedNFe1Mnt"						, 0, 6 },;                 
			{ "Marcar Todos"		, "STATICCALL(TTFAT25C,MarkAll)"	, 0, 4 },;               
			{ "Desmarcar Todos"		, "STATICCALL(TTFAT25C,UnMarkkAll)"	, 0, 4 },;
			{ "Inverter Todos"		, "STATICCALL(TTFAT25C,InvMark)"	, 0, 4 }} 

LoadPeds()
dbSelectArea("TRB1")
dbSetOrder(1)

MarkBrow( "TRB1", "PED_OK",,_afields,, cMark,"STATICCALL(TTFAT25C,INVMARK)",,,,"STATICCALL(TTFAT25C,MARK)",{ || },,,aColors,,,,.F. )

    
If File("\system\" +cArquivo +"." +OrdbagExt())
	MsErase("\system\" +cArquivo +"." +OrdbagExt())
EndIf

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VerPed  �Autor  �Jackson E. de Deus    � Data �  22/09/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Visualizar pedido                                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function VerPed()

Local aArea := GetArea()
dbSelectArea("SC5")
dbSetOrder(1)
If dbSeek( xFilial("SC5") +AvKey(TRB1->PEDIDO,"C5_NUM") ) 	
	A410Visual("SC5",Recno(),2)      
EndIf                   

RestArea(aArea)

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MarkAll �Autor  �Jackson E. de Deus    � Data �  22/09/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Marca todos                                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function MarkAll()                              

Local oMark := GetMarkBrow()

DbSelectArea("TRB1")

DbGotop()
While !Eof()
	If Empty(TRB1->NOTA)        
		If RecLock( "TRB1", .F. )                
			TRB1->PED_OK := cMark                
			MsUnLock()        
		EndIf               
	EndIf
	dbSkip()
Enddo          

MarkBRefresh()
//oMark:oBrowse:Gotop()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �UnMarkkAll  �Autor  �Jackson E. de Deus� Data �  22/09/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Desmarca todos                                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function UnMarkkAll()

Local oMark := GetMarkBrow()

DbSelectArea("TRB1")
DbGotop()
While !Eof()        
	IF RecLock( "TRB1", .F. )                
		TRB1->PED_OK := SPACE(2)                
		MsUnLock()        
	EndIf        
	dbSkip()
Enddo

MarkBRefresh()
//oMark:oBrowse:Gotop()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Mark  �Autor  �Jackson E. de Deus      � Data �  22/09/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Marca o registro posicionado                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Mark()

If IsMark( 'PED_OK', cMark )        
	RecLock( 'TRB1', .F. )
	TRB1->PED_OK := SPACE(2)                
	MsUnLock()
Else        
	RecLock( 'TRB1', .F. )                
	TRB1->PED_OK := cMark        
	MsUnLock()
EndIf

MarkBRefresh()

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �InvMark  �Autor  �Jackson E. de Deus   � Data �  22/09/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Inverte a marca                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function InvMark()

Local oMark := GetMarkBrow()

DbSelectArea("TRB1")
DbGotop()
While !Eof()        
	If RecLock( "TRB1", .F. )                
		If IsMark( "PED_OK", cMark )        
			TRB1->PED_OK := SPACE(2)
		Else        
			TRB1->PED_OK := cMark
		EndIf               
		MsUnLock()        
	EndIf        
	dbSkip()
Enddo

MarkBRefresh()
//oMark:oBrowse:Gotop()

Return 




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LoadField  �Autor  �Jackson E. de Deus � Data �  22/09/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cria a tabela temporaria	                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function LoadField(cArquivo)

Local aFields := {}
Local cIndice := ""
Local _afields := {}
Local cChave := ""

AADD(_afields,{"PED_OK","",""})
AADD(_afields,{"PEDIDO","","Pedido"})
AADD(_afields,{"CLIENTE","","Cliente"})
AADD(_afields,{"LOJA","","Loja"})
AADD(_afields,{"DATAPED","","Emissao"})
AADD(_afields,{"TOTAL","","Total"})
AADD(_afields,{"NOTA","","Nota"})
AADD(_afields,{"SERIE","","Serie"})
//AADD(_afields,{"XMLENV","","Transmitida?"})


AADD( aFields,{"PED_OK"		,"C"	,2,0})
//AADD( aFields,{"XMLENV"		,"C"	,8,0})
AADD( aFields,{"PEDIDO"		,"C"	,TamSx3("C5_NUM")[1],0})
AADD( aFields,{"CLIENTE"	,"C"	,TamSx3("A1_COD")[1],0})
AADD( aFields,{"LOJA"		,"C"	,TamSx3("A1_LOJA")[1],0})
AADD( aFields,{"DATAPED"	,"D"	,8,0})
AADD( aFields,{"TOTAL"		,"N"	,8,0})
AADD( aFields,{"NOTA"		,"C"	,TamSx3("F2_DOC")[1],0})
AADD( aFields,{"SERIE"		,"C"	,TamSx3("F2_SERIE")[1],0})
//AADD( aFields,{"STATUS"		,"C"	,10,0})


If Select("TRB1") > 0
	TRB1->(dbCloseArea())
EndIf

cArquivo := CriaTrab(aFields,.T.)
cArqTrab1 := Subs(cArquivo,1,7)+"A"
cArqTrab2 := Subs(cArquivo,2,7)+"B"
	
dbUseArea(.T.,__cRDDNTTS,cArquivo,"TRB1",.F.,.F.)
//IndRegua("TRB1",cIndice,"PEDIDO") 
//cChave := "PEDIDO"
//IndRegua("TRB1",cArquivo,cChave,,,"Selecionando Registros...")
//dbSetIndex(cIndice+OrdBagExt())


IndRegua("TRB1",cArqTrab2,"Pedido",,,"Selecionando Registros...")
IndRegua("TRB1",cArqTrab1,"Cliente+Loja",,,"Selecionando Registros...")
                                 
dbSetIndex(cArqTrab2+OrdBagExt())
dbSetIndex(cArqTrab1+OrdBagExt())
DbSetOrder(1)  


Return _afields


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LoadPeds  �Autor  �Jackson E. de Deus  � Data �  22/09/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Carrega os pedidos                                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function LoadPeds()

Local cQuery := ""
Local oMark := GetMarkBrow()

cQuery := "SELECT * FROM SC5010 WHERE C5_FILIAL = '"+xFilial("SC5")+"' AND C5_EMISSAO >= '20160101' AND C5_CLIENTE = '000001' "
cQuery += " AND C5_XFINAL = 'S' AND D_E_L_E_T_ = '' " //AND C5_NOTA = ''  "

MPSysOpenQuery( cQuery,"TRB" )
dbSelectArea("TRB")

While TRB->(!EOF())
	dbSelectArea("TRB1")
	RecLock("TRB1",.T.)
	TRB1->PED_OK	:= ""
	TRB1->PEDIDO	:= TRB->C5_NUM
	TRB1->CLIENTE	:= TRB->C5_CLIENTE
	TRB1->LOJA		:= TRB->C5_LOJACLI
	TRB1->DATAPED	:= STOD(TRB->C5_EMISSAO)
	TRB1->TOTAL		:= 0
	TRB1->NOTA		:= TRB->C5_NOTA
	TRB1->SERIE		:= TRB->C5_SERIE
	TRB1->(MsUnLock())

	dbSelectArea("TRB")		
	dbSkip()
End


//MarkBRefresh()      
//oMark:oBrowse:Gotop()

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FatPeds  �Autor  �Jackson E. de Deus   � Data �  22/09/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fatura os pedidos                                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function FatPeds()

Local aPedido := {}
Local lEnd := .F.
Local oMark := GetMarkBrow()
Local cHrIni := Time()
Local cHrFim := ""
	
DbSelectArea("TRB1")
DbGotop()
While !Eof()
	If PED_OK == cMark .And. Empty(TRB1->NOTA)       
		AADD( aPedido, { TRB1->PEDIDO, "", "" } )
	EndIf
	dbSkip()
Enddo

If ! Empty( aPedido )
	Processa( { || Fatura( @aPedido ) },"Faturando pedidos...","Aguarde..." )
	
	dbSelectArea("TRB1")
	dbGoTop()
	While !EOF()    
		If PED_OK == cMark
			nPos := Ascan( aPedido, { |x| x[1] == TRB1->PEDIDO .And. !Empty(x[2]) } )
			If nPos > 0
				RecLock("TRB1",.F.)
				TRB1->NOTA := aPedido[nPos][2]
				TRB1->SERIE := "2"
				MsUnLock()
			EndIf
		EndIf
		TRB1->( dbSkip() )
	End
     
	//oMark:oBrowse:Gotop()
	MarkBRefresh() 
EndIf

Conout("#TTFAT25C - TOTAL PEDIDO: " +CVALTOCHAR(LEN(APEDIDO)) +" - TEMPO TOTAL -> " +ElapTime(cHrIni,Time()) )

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Fatura  �Autor  �Jackson E. de Deus  � Data �  22/09/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fatura o pedido                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Fatura( aPedido )

Local aArea := GetArea()
Local cNota := ""
Local nI

ProcRegua( Len(aPedido) )

For nI := 1 To Len(aPedido)
	IncProc( "Pedido " +aPedido[nI][1] )	
	cNota := ProcFat( aPedido[nI][1] )
	If !Empty(cNota)
		aPedido[nI][2] := cNota
		aPedido[nI][2] := "2  "
	EndIf 
Next nI		 

RestArea( aArea )

Return 


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ProcFat  �Autor  �Jackson E. de Deus  � Data �  06/30/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Processa o faturamento do pedido                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ProcFat( cNumPed )

Local cTES := "" 
Local cCondPag := ""
Local lBlqCrd := .F.
Local lBlqEst := .F.
Local cNumNF := "" 
Local cSerie := "2"
Local aPVlNFs := {}
Local nI
Private lMsErroAuto := .F.

dbSelectArea("SC5")
dbSetOrder(1)
If dbSeek( xFilial("SC5") +AvKey(cNumPed,"C5_NUM") )
	cCondPag := SC5->C5_CONDPAG
	dbSelectArea("SC6")
	dbSetOrder(1)
	If dbSeek( xFilial("SC6") +AvKey(cNumPed,"C6_NUM") )
		While SC6->(!EOF()) .And. SC6->C6_NUM == cNumPed
			MaLibDoFat( SC6->(RecNo()),SC6->C6_QTDVEN,,,@lBlqCrd,@lBlqEst,.F.,.F. )
			SC6->(dBSkip())
		EndDo
	EndIf
	
	DbSelectArea("SC9")
	DbSetOrder(1)
	If DbSeek( xFilial("SC9")+cNumPed )
		While SC9->(!EOF()) .And. SC9->(C9_FILIAL+C9_PEDIDO) == xFilial("SC9")+cNumPed
			If Empty(SC9->C9_BLCRED) .And. Empty(SC9->C9_BLEST)
			    cTES := Posicione("SC6",1,xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO,"C6_TES")
				Aadd( aPVlNFs,{ SC9->C9_PEDIDO,;
								SC9->C9_ITEM,;
								SC9->C9_SEQUEN,;
								SC9->C9_QTDLIB,;
								SC9->C9_PRCVEN,;
								SC9->C9_PRODUTO,;
								.F.,;
								SC9->(RecNo()),;
								SC5->(Recno(Posicione("SC5",1,xFilial("SC5")+SC9->C9_PEDIDO,""))),;
								SC6->(Recno(Posicione("SC6",1,xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM,""))),;
								SE4->(Recno(Posicione("SE4",1,xFilial("SE4")+cCondPag,""))),;
								SB1->(Recno(Posicione("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO,""))),;
								SB2->(Recno(Posicione("SB2",1,xFilial("SB2")+SC9->C9_PRODUTO,""))),;
								SF4->(Recno(Posicione("SF4",1,xFilial("SF4")+cTES,""))) })
								
			EndIf
			DbSelectArea("SC9")
			DbSkip()
		End
	EndIf
	
	If Len(aPVlNFs) > 0
		Posicione("SA1",1,xFilial("SA1")+SC9->C9_CLIENTE+SC9->C9_LOJA,"")			
		cNumNF := MAPVLNFS(aPVlNFs,cSerie, .F., .F., .f., .f., .F., 0, 0, .f., .F.)	
	EndIf   	
EndIf	

Return cNumNF
                
  

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NFECONN  �Autor  �Microsiga           � Data �  09/20/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function NFECONN()

Local aNotas := {}
Local lEnd := .F.


DbSelectArea("TRB1")
DbGotop()
While !Eof() 
	If PED_OK == cMark .And. !Empty( TRB1->NOTA ) .And. !Empty( TRB1->SERIE )
		AADD( aNotas, { TRB1->NOTA, TRB1->SERIE } )
	EndIf
	dbSkip()
Enddo

If ! Empty( aNotas )
	Processa( { || NfeTrans( aNotas ) },"Transmitindo notas...","Aguarde..." )
	_lRefresh := .T.
EndIf

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NfeTrans  �Autor  �Jackson E. de Deus  � Data �  22/09/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Transmite as notas                                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function NfeTrans( aNotas )

Local cAmbiente := ""
Local cRetorno	:= ""
Local cIdEnt := StaticCall(SPEDNFE,GetIdEnt)

If GetEnvServer() $ "JVVXC9#CONP#SCHEDULE"
	cAmbiente := "1"
Else
	cAmbiente := "2"
EndIf

ProcRegua(Len(aNotas))

For nI := 1 To Len( aNotas )
	IncProc( aNotas[nI][1] +"/" +aNotas[nI][2] )
	
	AutoNfeEnv( cEmpAnt,cFilAnt,"0",cAmbiente,aNotas[nI][2],aNotas[nI][1],aNotas[nI][1] )
	//cRetorno := SpedNFeTrf("SF2","2  ",aNotas[nI][1],aNotas[nI][1],cIdEnt,cAmbiente,cModalidade,cVersao,@lEnd,.F.,.T.)
Next nI

Return