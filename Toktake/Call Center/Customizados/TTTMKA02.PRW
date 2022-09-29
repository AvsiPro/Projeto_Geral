#Include 'rwmake.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTTMKA02  บAutor  ณMarcio Domingos     บ Data ณ  31/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Consulta de estoque de todas as Filiais / Armaz้ns do      บฑฑ
ฑฑบ          ณ produto selecionado no atendimento Televendas.             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOKTAKE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
   
User Function TTTMKA02()
Local _aArea		:= GetArea()
Private _nPosProd	:= ASCAN(AHEADER   	,{|x| UPPER(ALLTRIM(x[2])) == "UD_PRODUTO"})
Private _nPosLocal	:= ASCAN(AHEADER	,{|x| UPPER(ALLTRIM(x[2])) == "UD_LOCAL"})  

//PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" TABLES "SB1","SB2","SM0"       

If cEmpAnt <> "01"
	Return .T.
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ<ฟ
//ณSe o o produto nใo for preenchido exibe mensagemณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ<ู

If Empty(aCols[n,_nPosProd])
	MsgBox("Favor informar o produto !")
	Return .T.
Endif	

// Cadastro de Produtod
DbSelectArea("SB1")
DbSetOrder(1) // B1_FILIAL + B1_COD
DbGotop()
If DbSeek( xFilial("SB1")+aCols[n,_nPosProd])
	
	MostraSB2(aCols[n,_nPosProd])
	
Endif

Return .T.                         


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMostraSB2  บAutor  ณMarcio Domingos    บ Data ณ  31/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Apresenta tela com as filais e armaz้ns do produto         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOKTAKE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MostraSB2(_cProduto)   
Local _cArqTrab	:= CriaTrab(Nil,.F.)                
Local _aArea	:= GetArea()  
Local _cDescri	:= Space(TamSx3("ZZ1_DESCRI")[1])   
Local _lOK		:= .F.                              
Local _aAreaSM0	

_aFields	:= 	{	{"Filial"  				,"C",TamSx3("B2_FILIAL")[1],00},;
					{"Localx"  				,"C",TamSx3("B2_LOCAL")[1],00},;                                              
					{"Descr"  				,"C",TamSx3("ZZ1_DESCRI")[1],00},;					
					{"Saldo"  				,"N",TamSx3("B2_QATU")[1],00}}   
					

DbCreate(_cArqTrab,_aFields)
DbUseArea(.T.,,_cArqTrab,"TMP",.T.,.F.)  


DbSelectArea("SM0")    
_aAreaSM0	:= GetArea()
DbSetOrder(1)
DbGotop()

DbSeek(cEmpAnt)

Do While 	SM0->M0_CODIGO = cEmpAnt	.And. !Eof()

	DbSelectArea("SB2")
	DbSetOrder(1)
	DbGoTop()
	DbSeek(SM0->M0_CODFIL+_cProduto)
	
	Do While 	SB2->B2_FILIAL 	= 	SM0->M0_CODFIL	.And.;
				SB2->B2_COD		=	_cProduto		.And. SB2->B2_QATU > 0 .AND. !Eof()
				
		DbSelectArea("ZZ1")
		DbSetOrder(1)
		DbGotop()
		
		If DbSeek(xFilial("ZZ1")+SB2->B2_LOCAL)
			_cDescri := ZZ1->ZZ1_DESCRI
		Endif					
			
		RecLock("TMP",.T.)  
		TMP->Filial		:= SM0->M0_CODFIL
		TMP->Localx		:= SB2->B2_LOCAL
		TMP->Descr		:= _cDescri
		TMP->Saldo		:= SB2->B2_QATU
		MsUnlock()
		
		DbSelectArea("SB2")
		DbSkip()
		
	Enddo		
	
	DbSelectArea("SM0")
	DbSkip()

Enddo  

DbSelectArea("TMP")
DbGotop()	                               

@ 0,0 To 315,600 Dialog _oDlg Title "Caracterํsticas do Produto"  
@ 05,005 Say "Produto:"
@ 05,030 Get SB1->B1_COD When .F. Size 40,8
@ 05,080 Say "Descri็ใo"
@ 05,110 Get SB1->B1_DESC When .F. Size 185,8
@ 01.5,01 LISTBOX oLbx VAR nLbx FIELDS TMP->Filial, TMP->Localx, TMP->Descr, TMP->Saldo  HEADER "Filial","Armazem","Descri็ใo","Saldo Atual" ALIAS "TMP" On DblClick (_lOK:=.T.,Close(_oDlg)) SIZE 285,120 OF _oDlg 
@ 145,235 BmpButton Type 1 Action (_lOK:=.T.,Close(_oDlg))
@ 145,265 BmpButton Type 2 Action (_lOK:=.F.,Close(_oDlg))
Activate Dialog _oDlg Centered    


DbSelectArea("TMP")
Use 
FErase(_cArqTrab)   

RestArea(_aAreaSM0)           
RestArea(_aArea)
Return .T.

