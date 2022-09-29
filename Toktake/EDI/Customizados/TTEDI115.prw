#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"                
#INCLUDE "TOPCONN.CH"  
#INCLUDE "RWMAKE.CH"  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTEDI115  บAutor  ณAlexandre Venancio  บ Data ณ  05/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina criada para importacao dos abastecimentos de rotas  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTEDI115()  
                         
Local nOpca := 0
Local aRegs			:={}
Local aSays 		:= {}
Local aButtons 		:= {}                                            
Local nPed			:= 0
Local cCadastro 	:= "TOKTAKE - Importacao de Pedidos Processamento"
Local lRet			:= .T.       
Local lGerouPv		:= .T.
Local cQuery		:= ""
Local cNumPed		:= ""  
Local aAreaC5		:= {}
Private cPergCal    := "TTEDI115"   
Private cTab		:= ""
Private aList		:= {}  
Private aItens		:= {}
Private aCabec		:= {}      
Private aC5			:= {}
Private aC6			:= {} 
Private aEmail		:= {} 
Private aParamU		:= {}
Private lMsErroAuto		:= .F.
Private lMsHelpAuto 	:= .T.
Private lAutoErrNoFile	:= .F.     
Private cTipTab		:= ""
 
aAdd(aRegs,{cPergCal,"01","Arquivo      ?","","","mv_ch1","C",99,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","DIR",""})

//Prepare Environment Empresa "01" Filial "01" Tables "SC5/SC6" 

If cEmpAnt <> "01"
	Return
EndIf

ValidPerg(aRegs,cPergCal) 
Pergunte(cPergCal,.F.)
             
aAdd(aSays,cCadastro)   
aAdd(aButtons, { 5,.T.,{|| Pergunte(cPergCal,.T. ) } } )
aAdd(aButtons, { 1,.T.,{|o| nOpca := 1,FechaBatch() }} )
aAdd(aButtons, { 2,.T.,{|o| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )          

If nOpca == 1
	Processa({|lEnd| lRet := LerArquivo()},OemToAnsi("Lendo Arquivo"))
 
	If lRet
		Distribuir()	
	EndIf
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTEDI115  บAutor  ณAlexandre Venancio  บ Data ณ  05/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao do arquivo                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function LerArquivo()

Local aAux	:=	{}           
Local nCont	:=	1 
Local aCabec:= {}                                                          
Local nHandle 	:= FT_FUse(MV_PAR01)       
Local lRet	:=	.T.

// Posiciona na primeria linha
FT_FGoTop()

If nHandle < 0
	MsgAlert("Arquivo nใo encontrado","TTEDI115")
	Return(.F.)
EndIf

While !FT_FEOF() 
	cLine	:= FT_FReadLn() // Retorna a linha corrente  
	aAux    := StrTokArr(cLine,";")   
	                                                      
	//  1	 2		  3 	   4	   5	 6		7        8
	//Nota Serie	Filial	Armazem	Produto	Qtd	Patrimonio Status                 
	If nCont > 1
		If len(aAux) <> 7 
			Msgalert("Registro invแlido na linha "+cvaltochar(nCont),"TTEDI115")
			Return(.F.)
		EndIf
		
		If Posicione("SF2",1,Strzero(val(aAux[03]),2)+Strzero(val(aAux[01]),9)+aAux[02],"F2_DOC") == ""
			Msgalert("Nota Fiscal invแlida na linha "+cvaltochar(nCont),"TTEDI115")
			Return(.F.)
		ElseIf Posicione("SB1",1,xFilial("SB1")+aAux[05],"B1_DESC") == ""
			Msgalert("Produto invแlido na linha "+cvaltochar(nCont),"TTEDI115")
			Return(.F.)
		ElseIf val(aAux[06]) < 1
			Msgalert("Quantidade invแlida na linha "+cvaltochar(nCont),"TTEDI115")
			Return(.F.) 
		ElseIf Posicione("ZZ1",1,Strzero(val(aAux[03]),2)+aAux[04],"ZZ1_DESCRI") == ""
			MsgAlert("PA invแlida na linha "+cvaltochar(nCont),"TTEDI110")
			Return(.F.)
		ElseIf empty(aAux[07])
			MsgAlert("Patrimonio invแlido na linha "+cvaltochar(nCont),"TTEDI115")
			Return(.F.)
		EndIf
		Aadd(aList,{Strzero(val(aAux[01]),9),If(len(aAux[02])<3,aAux[02]+space(3-len(aAux[02])),aAux[02]),Strzero(val(aAux[03]),2),aAux[04],aAux[05],aAux[06],aAux[07],.F.})
	EndIf
	
	nCont++
	FT_FSKIP()
End

FT_FUSE()   

Return(lRet) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTEDI115  บAutor  ณMicrosiga           บ Data ณ  05/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Distribuir os itens da rota para as PAs                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Distribuir()

Local cTMEntrega := GetMv("MV_XTMENT",,"501")
Local cTMDistrib := GetMv("MV_XTMSD3",,"001")
Local nX		:=	0
Local _cItem	:=	""
Local _lRet		:=	.T.

_cDocumento          := GetSx8Num("SD3","D3_DOC")

For nX := 1 to len(aList)      
	//Se nใo existir o local ORIGEM criado no SB2
	/*dbSelectArea("SB2")
	dbSetOrder(1)
	If !dbSeek(xFilial("SB2")+produto+localorigem)
		CriaSB2(prod,localorigem)
	Endif
	
	//Se nใo existir o local DESTINO criado no SB2
	dbSelectArea("SB2")
	dbSetOrder(1)
	If !dbSeek(xFilial("SB2")+aList[nX,05]+aList[nX,04])
		CriaSB2(aList[nX,05],aList[nX,04])
	Endif */
	
	//Saida do local original
	aMta240Ent := {}
	aMta240Sai := {}
	Aadd(aMta240Sai, {})
	Aadd(aMta240Ent, {})

	//  1	 2		  3 	   4	   5	 6		7        8
	//Nota Serie	Filial	Armazem	Produto	Qtd	Patrimonio Status               
	
	_cItem := ''
	_cCliente	:=	Posicione("SF2",1,aList[nX,03]+aList[nX,01]+aList[nX,02],"F2_CLIENTE")
	_cLoja		:=	Posicione("SF2",1,aList[nX,03]+aList[nX,01]+aList[nX,02],"F2_LOJA")
	_cLocalOrig := 	Posicione("SF2",1,aList[nX,03]+aList[nX,01]+aList[nX,02],"F2_XCODPA")

	DbSelectArea("SD2")
	DbSetOrder(3)
	If DbSeek(aList[nX,03]+aList[nX,01]+aList[nX,02]+_cCliente+_cLoja+aList[nX,05])
		While !EOF() .And. SD2->D2_DOC == aList[nX,01] .AND. SD2->D2_SERIE = aList[nX,02] .AND. SD2->D2_COD = aList[nX,05]
	
			If SD2->D2_XSLDPA <= 0
				clProd:=SD2->D2_COD
				nlConskip:=0
				SD2->(dbSkip())
				_cItem := SD2->D2_ITEM
				nlConskip++
				If SD2->D2_COD==clProd .And. D2_XSLDPA <= 0
					SD2->(dbSkip())
					nlConskip++
				ElseIf SD2->D2_COD==clProd .And. SD2->D2_XSLDPA > 0												
					Exit
				Else
					SD2->(dbSkip(nlConskip *(-1)))
					MsgStop("Produto "+clProd+" com quantidade TOTAL jแ distribuํda na NF "+aList[nX,01])
					_lRet := .F.
					Exit
				EndIf
			Else 
				_cItem := SD2->D2_ITEM  
				_lRet 	:=	.T.
				Exit
			EndIf
			
			DbSkip()
		EndDo
	EndIf    
	
	If _lRet   
		Aadd(aMta240Sai[1], {'D3_TM'     ,cTMEntrega  									   			,Nil})
		Aadd(aMta240Sai[1], {'D3_COD'    ,aList[nX,05]												,Nil})
		Aadd(aMta240Sai[1], {'D3_UM'     ,Posicione("SB1",1,xFilial("SB1")+aList[nX,05],"B1_UM")	,Nil})
		Aadd(aMta240Sai[1], {'D3_QUANT'  ,val(aList[nX,06])   										,Nil})
		Aadd(aMta240Sai[1], {'D3_LOCAL'  ,_cLocalOrig												,Nil})
		Aadd(aMta240Sai[1], {'D3_EMISSAO',dDataBase													,Nil})
		Aadd(aMta240Sai[1], {'D3_DOC'    ,_cDocumento  												,Nil})
		Aadd(aMta240Sai[1], {'D3_CONTA'  ,""           												,Nil})
		dbSelectArea("ZZ1")
		If dbSeek(xFilial("ZZ1")+aList[nX,04])
			Aadd(aMta240Sai[1], {'D3_CC'     ,ZZ1->ZZ1_CCUSTO,       Nil}) //Tratar
			Aadd(aMta240Sai[1], {'D3_CLVL'   ,ZZ1->ZZ1_CLVALO,       Nil}) //Tratar
			Aadd(aMta240Sai[1], {'D3_ITEMCTA',ZZ1->ZZ1_ITCONT,       Nil}) //Tratar
		Endif
		MsUnLock()                
		 
		
		Aadd(aMta240Sai[1], {'D3_XNUMNF' ,aList[nX,01]							     				,Nil})
		Aadd(aMta240Sai[1], {'D3_XSERINF',aList[nX,02]								  				,Nil})
		Aadd(aMta240Sai[1], {'D3_XCLIENT',_cCliente													,Nil})
		Aadd(aMta240Sai[1], {'D3_XLOJCLI',_cLoja   													,Nil})
		Aadd(aMta240Sai[1], {'D3_XITEMNF',_cItem											  		,Nil})
		Aadd(aMta240Sai[1], {'D3_XORIGEM',"TTEDI115"										  		,Nil})
		    
		
		//Agora a entrada no novo local de estoque
		Aadd(aMta240Ent[1], {'D3_TM'     ,cTMDistrib     													,Nil})
		Aadd(aMta240Ent[1], {'D3_COD'    ,aList[nX,05]			   											,Nil})
		Aadd(aMta240Ent[1], {'D3_UM'     ,Posicione("SB1",1,xFilial("SB1")+aList[nX,05],"B1_UM")			,Nil})
		Aadd(aMta240Ent[1], {'D3_QUANT'  ,val(aList[nX,06])	   											,Nil})
		Aadd(aMta240Ent[1], {'D3_LOCAL'  ,aList[nX,04]														,Nil})
		Aadd(aMta240Ent[1], {'D3_EMISSAO',dDataBase															,Nil})
		Aadd(aMta240Ent[1], {'D3_DOC'    ,_cDocumento    													,Nil})
		Aadd(aMta240Sai[1], {'D3_CONTA'  ,""             													,Nil}) //Tratar
		
		dbSelectArea("ZZ1")
		If dbSeek(xFilial("ZZ1")+aList[nX,04])
			Aadd(aMta240Ent[1], {'D3_CC'     ,ZZ1->ZZ1_CCUSTO,       Nil}) //Tratar
			Aadd(aMta240Ent[1], {'D3_CLVL'   ,ZZ1->ZZ1_CLVALO,       Nil}) //Tratar
			Aadd(aMta240Ent[1], {'D3_ITEMCTA',ZZ1->ZZ1_ITCONT,       Nil}) //Tratar
		Endif
		
		Aadd(aMta240Ent[1], {'D3_XNUMNF' ,aList[nX,01]										     			,Nil})
		Aadd(aMta240Ent[1], {'D3_XSERINF',aList[nX,02] 										 			,Nil})
		Aadd(aMta240Ent[1], {'D3_XCLIENT',_cCliente		   													,Nil})
		Aadd(aMta240Ent[1], {'D3_XLOJCLI',_cLoja   															,Nil})
		Aadd(aMta240Ent[1], {'D3_XITEMNF',_cItem														 	,Nil})
		
		Aadd(aMta240Ent[1], {'D3_XTIPO',"A"  						,Nil}) 	//Utilizado para informar o tipo do movimento A=Abastecimento,
		//esse campo e utilizado para filtro na rotina de impressao da notinha de
		//abastecimento TTFATR01.
		Aadd(aMta240Ent[1], {'D3_XPATRI',aList[nX,07]														,Nil})//Numero do Patrimonio
		Aadd(aMta240Ent[1], {'D3_XORIGEM',"TTFATA01INC"														,Nil})
		
		If Len(aMta240Sai) > 0 .And. Len(aMta240Ent) > 0
			_lAuto      := .T.
			_lAutoSai 	:= .T.
			_lAutoEnt   := .T.
			lMsErroAuto := .F.
			MSExecAuto({|x,y| mata240(x,y)},aMta240Sai[1],3)
			If lMsErroAuto
				MostraErro()
				_lAutoSai := .F.
			Else
				MSExecAuto({|x,y| mata240(x,y)},aMta240Ent[1],3)
				If lMsErroAuto
					MostraErro()
					_lAutoEnt := .F.
				EndIf
			EndIf
			
			_lAuto   := .F.
			
			_cArea := GetArea()
			
			If _lAutoSai .And. _lAutoEnt
				dbSelectArea("SD2")
				SD2->(dbSetOrder(3))
				If SD2->(dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA+aList[nX,05]+space(15-len(aList[nX,05]))+_cItem))
					SD2->(RecLock("SD2",.F.))
					SD2->D2_XSLDPA	-= val(aList[nX,06])
					SD2->(MsUnLock())
				Endif          
				aList[nX,08] := .T.   
				//  1	 2		  3 	   4	   5	 6		7        8
				//Nota Serie	Filial	Armazem	Produto	Qtd	Patrimonio Status               
				cQuery := "SELECT SUM(D2_XSLDPA) AS TOT FROM "+RetSQLName("SD2")
				cQuery += "	WHERE D2_FILIAL='"+aList[nX,03]+"' AND D2_DOC='"+aList[nX,01]+"' AND D2_SERIE='"+aList[nX,02]+"' AND D_E_L_E_T_=''"
				
				If Select('TRB') > 0
					dbSelectArea('TRB')
					dbCloseArea()
				EndIf
				
				MemoWrite("TTFINC10.SQL",cQuery)
				DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
				
				DbSelectArea("TRB")

				If TRB->TOT == 0
					DbSelectArea("SF2")
					DbSetOrder(1)
					If DbSeek(aList[nX,03]+aList[nX,01]+aList[nX,02])
						RecLock("SF2",.F.)
						SF2->F2_XSTATUS := "2"
						MsUnLock()
					EndIf
				EndIf

				
			Else
				aList[nX,08] := .F.
			EndIf
			RestArea(_cArea)
		Endif
	Else
		aList[nX,08] := .F.
	EndIf
Next nX

GeraPDF()

Return   


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTEDI115  บAutor  ณMicrosiga           บ Data ณ  05/14/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraPDF()

Local aArquivos := {}
Local cMsg		:= "Distribui็ใo da Rota"
Local lAdjustToLegacy := .F. 
Local lDisableSetup  := .T.
Local cLogoD	:= GetSrvProfString("Startpath","") + "DANFE01.BMP" 
Local nTotal	:= 0
Private oPrinter      


oFont1 := TFont():New( "Courier New", , -18, .T.)

If oPrinter == Nil
	lPreview := .T.
	oPrinter := FWMSPrinter():New("Rota.rel", 6, lAdjustToLegacy, , lDisableSetup)

	// Ordem obrigแtoria de configura็ใo do relat๓rio
	oPrinter:SetResolution(72)
	oPrinter:SetPortrait()
	oPrinter:SetPaperSize(DMPAPER_A4)
	oPrinter:SetMargin(60,60,60,60) 
	// nEsquerda, nSuperior, nDireita, nInferior 
	oPrinter:cPathPDF := "\SPOOL\" 
EndIf       

oPrinter:Box(10,10,510,850)
oPrinter:Say( 30, 250, "Notas Distribuidas pela Rota", oFont1, 1400, CLR_HRED)
oPrinter:SayBitmap(015,015,cLogoD,055,056)
                       
//  1	 2		  3 	   4	   5	 6		7        8
//Nota Serie	Filial	Armazem	Produto	Qtd	Patrimonio Status                 

oPrinter:Say(090, 15,'FL',oFont1)
oPrinter:Say(090, 30,'Nota',oFont1)
oPrinter:Say(090, 80,'Serie',oFont1)
oPrinter:Say(090, 105,'PA',oFont1)
oPrinter:Say(090, 150,'Produto',oFont1)
oPrinter:Say(090, 200,'Qtd',oFont1)
oPrinter:Say(090, 250,'Patrimonio',oFont1)

oPrinter:Say(100, 15, Replicate("-", 300), oFont1)

nLin := 110             
Asort(aList,,,{|x,y| x[8] > y[8]})

For nX := 1 to len(aList) 
	If aList[nX,08]
	   	oPrinter:Say(nLin, 15,aList[nX,03],oFont1)
	   	oPrinter:Say(nLin, 30,aList[nX,01],oFont1)
	   	oPrinter:Say(nLin, 80,aList[nX,02],oFont1)
	   	oPrinter:Say(nLin, 105,aList[nX,04],oFont1)
	   	oPrinter:Say(nLin, 150,aList[nX,05],oFont1)
	   	oPrinter:Say(nLin, 200,cvaltochar(aList[nX,06]),oFont1)
	   	oPrinter:Say(nLin, 250,aList[nX,07],oFont1)
	Else
		exit
	EndIf
	nLin := nLin + 10
Next nX
                           
nLin := nLin + 20

oPrinter:Say(nLin, 15, Replicate("-", 500), oFont1)
nLin := nLin + 10
oPrinter:Say(nLin, 15,'Nใo Importados',oFont1)
nLin := nLin + 20

oPrinter:Say(nLin, 15,'FL',oFont1)
oPrinter:Say(nLin, 30,'Nota',oFont1)
oPrinter:Say(nLin, 80,'Serie',oFont1)
oPrinter:Say(nLin, 105,'PA',oFont1)
oPrinter:Say(nLin, 150,'Produto',oFont1)
oPrinter:Say(nLin, 200,'Qtd',oFont1)
oPrinter:Say(nLin, 250,'Patrimonio',oFont1)
                 
nLin := nLin + 10
oPrinter:Say(nLin, 15, Replicate("-", 300), oFont1)

nLin := nLin + 10
For nX := 1 to len(aList) 
	If !aList[nX,08]
	   	oPrinter:Say(nLin, 15,aList[nX,03],oFont1)
	   	oPrinter:Say(nLin, 30,aList[nX,01],oFont1)
	   	oPrinter:Say(nLin, 80,aList[nX,02],oFont1)
	   	oPrinter:Say(nLin, 105,aList[nX,04],oFont1)
	   	oPrinter:Say(nLin, 150,aList[nX,05],oFont1)
	   	oPrinter:Say(nLin, 200,cvaltochar(aList[nX,06]),oFont1)
	   	oPrinter:Say(nLin, 250,aList[nX,07],oFont1)
	 	nLin := nLin + 10
	 EndIf
Next nX
       
oPrinter:EndPage()

oPrinter:Preview()

//Aadd(aArquivos,{"\spool\TTEDI110.XML",'Content-ID: <ID_pedidox.xml>'}) 
Aadd(aArquivos,{"\spool\Rota.pdf",'Content-ID: <ID_pedido.pdf>'}) 

U_TTMAILN('microsiga@toktake.com.br',Alltrim(cusername)+'@toktake.com.br','Importador de Rotas',cMsg,aArquivos,.F.)


FreeObj(oPrinter)  

oPrinter := Nil	
  

Return                                            