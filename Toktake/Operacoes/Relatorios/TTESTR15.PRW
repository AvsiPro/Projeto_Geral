#include "tbiconn.ch"
#include "protheus.ch"
#INCLUDE "COLORS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTESTR15  บAutor  ณJackson E. de Deus  บ Data ณ  27/03/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio fechamento Rota - movimentos                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTESTR15( cArmazem,dInicio,dFim,cHrIni, aGrid, aNFSaida,cNfD, cSerieD )

Local aArea := GetArea()
Local nSaldo := 0
Local nDif := 0
Local nTotSaida := 0
Local nTotAbast := 0
Local nTotRet := 0
Local nTotAvar := 0
Local nTotDev := 0
Local nTotDif := 0
Local nTotDifNg := 0
Local nTotDifPs := 0
Local nCustd := 0
Local nValue := 0
Local nTotValue := 0
Local nI
Local aNF := {}
Local aNFDev := {}
Local aRet := {}
Local aPergs := {}
Local nPercAb := 0
Local nPercRt := 0
Local nPercAv := 0
Local nPercDv := 0
Local nPercPer:= 0
Local nPercPerNg := 0
Local nPercPerPs := 0
Local nXDif := 0
Local aDifPs := {}
Local aDifNg := {}
Local nPosP := 0
Local cCodTec := ""
Local cEmpReg := ""
Local cEmpresa := ""
Local aDescart := {}
Local nPosAv := 0
Local nDescarte := 0 
Local cNFDev		:= ""
Local cSeriDev		:= ""
Local aItemDev		:= {}
Local cArmA			:= ""
Local cDescProd		:= "" 
Local aProds	:= {}
Local dIniCClo	:= dDatabase
Local cNumOS	:= ""
Local aCarga	:= {}
Local aAbast	:= {}
Local aRetir	:= {}
Local aDescarte := {}
Local aConfBom	:= {}
Local aConfRuim	:= {}
Local aExced	:= {}
Local aTotFica	:= {}
Local aQtdSldAnt := {}   
Local nTotDsnto := 0
Local _aLista1		:= {}
Local aDifNg		:= {}
Local cOSInvent		:= ""
Local cHrIniCC		:= ""
Local aPedido		:= {}
Private nColIni		:= 40
Private nColIni2	:= 70                   
Private nLin		:= 25
Private nColFim		:= 2400
Private nColFim2	:= 2360
Private _nPag		:= 0  
Private oFont1 := TFont():New('Arial',,-25,.T.,.T.)
Private oFont2 := TFont():New('Arial',,-15,.T.,.T.)
Private oFont3 := TFont():New('Arial',,-15,.T.,.F.)
Private oFont4 := TFont():New('Arial',,-20,.T.,.T.)
Private oFont5 := TFont():New('Courier new',,-10,.T.,.T.)                                                            
Private oFont6 := TFont():New('Courier new',,-10,.T.,.F.) 
Private _cHoraImp := Time()  
Private cDir := ""     
Private _nColIt1	:= 100
Private _nColIt2	:= 350
Private _nColIt3	:= 950
Private _nColIt4	:= 1100
Private _nColIt5	:= 1250
Private _nColIt6	:= 1400
Private _nColIt7	:= 1550
Private _nColIt8	:= 1700
Private _nColIt9	:= 1900
Private _nColIt10	:= 2150
Private _nColIt11	:= 2400
Private _nColIt12	:= 2650
Private _nColIt13	:= 2900
Private _nColIt14	:= 3100

                 
 
Default cArmazem := ""
Default dInicio := stod("")
Default dFim := stod("") 
Default aGrid := {}    

If cEmpAnt <> "01"
	Return
EndIF

If ! FwIsInCallStack( "U_TTPROC57" )
	/*cArmazem := "R01001"
	dInicio := dDatabase
	dFim := dDatabase*/
	
	aAdd(aPergs ,{1,"Armazem"	,space(TamSx3("ZZ1_COD")[1]),"@!",".T.","ZZ1",".T.",100,.F.})
	aAdd(aPergs ,{1,"Data Inicio",dDatabase,"99/99/99","","","",100,.F.})
	aAdd(aPergs ,{1,"Data Fim",dDatabase,"99/99/99","","","",100,.F.})
	
	If !ParamBox(aPergs ,"Imprimir Fechamento",@aRet)
		Return
	Else
		If Empty(aRet[1]) .Or. Empty(aRet[2])
			MsgAlert("Informe os parโmetros!")
			Return
		EndIf
		
		// diretorio para salvar
		cDir := cGetFile(, OemToAnsi("Selecione o diret๓rio de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 
		If Empty(cDir)                                          
			Aviso(cPerg,"Escolha um diret๓rio vแlido.",{"Ok"})
		EndIf
		
		cArmazem := aRet[1]
		dInicio := aRet[2]
		dFim := aRet[3]
		   
	EndIf	
EndIf


// tecnico - configurar no cadastro da PA/ROTA
cQuery := "SELECT ZZ1_XATEND CODTEC, AA1_XEMPRE EMPRESA FROM " +RetSqlName("ZZ1") +" ZZ1 " 
cQuery += " INNER JOIN " +RetSqlName("AA1") +" AA1 ON AA1_CODTEC = ZZ1_XATEND AND AA1.D_E_L_E_T_ = '' "
cQuery += " WHERE ZZ1_COD = '"+cArmazem+"' AND ZZ1.D_E_L_E_T_ = '' "



MpSysOpenQuery( cQuery,"TRB" )
dbSelectArea("TRB")
If !EOF()
	cCodTec := TRB->CODTEC
	cEmpReg := TRB->EMPRESA
EndIf

TRB->(dbCloseArea())

// identificar empresa de registro do funcionario
If !Empty(cEmpReg)
	OpenSm0(cEmpReg)
	cEmpresa := AllTrim( SM0->M0_NOME ) 
EndIf


oPrint := TMSPrinter():New("Distribui็ใo")  
oPrint:SetPortrait()  
oPrint:SetPaperSize(9)
oPrint:Setup()     
oPrint:StartPage()  


CursorWait()

// cabecalho
CabecR( cArmazem,dInicio,dFim,cCodTec )




_aLista1 := {}

If FwIsInCallStack( "U_TTPROC57" )
	_aLista1 := Aclone( aGrid )
	cOSInvent := _cOsInvent
	
	cHrIniCC := cHrIni
	                
	aNF := Aclone( aNFSaida )
	cNFDev	:= cNfD
	cSeriDev := cSerieD
Else
	STATICCALL( TTPROC57, fProdsArm, cArmazem, @aProds )
	
	// inicio do ciclo e OS do inventario
	STATICCALL( TTPROC57, LoadIni, cArmazem,dDatabase,@dIniCClo,@cNumOS,@cHrIniCC )
	
	// movimentos SZ5
	STATICCALL( TTPROC57, MovSZ5, cArmazem, dInicio,dFim,@aCarga,@aAbast,@aRetir,@aDescarte )
	
	// itens contados no inventario
	STATICCALL( TTPROC57, ItensInv, cNumOS, @aConfBom, @aConfRuim, @aExced, @aTotFica )
	
	// itens contados no inventario anterior
	STATICCALL( TTPROC57, SldAntZC,cArmazem,dInicio, @aQtdSldAnt)
	
	For nI := 1 To Len( aProds )
		AADD( _aLista1, { "",;
						aProds[nI][1],;
						aProds[nI][2],;
						0,;
						0,;
						0,;
						0,;
						0,;
						0,;
						0,;
						0,;
						0,;
						0,;
						0,;
						0 } )
	Next nI 
	
	
	cOSInvent := cNUmOS
	
	
	STATICCALL( TTPROC57, ChkNfDv, cArmazem,@cNfDev,@cSeriDev,dInicio,cHrIniCC,dFim )
EndIf

cArm := cArmazem    
If SubStr( cArmazem,1,1 ) == "P"
	cArm := "A" +SubStr( cArmazem,2 )
EndIf



If ! FwIsInCallStack( "U_TTPROC57" )
	dbSelectArea("SZ6")
	dbSetOrder(1)
	For nI := 1 To Len( _aLista1 )
		                
		cProduto := _aLista1[nI][2]
		nSaldoAnt := 0
		nQt := 0
		nAbast := 0        
		nQAtu := 0
		nRetir := 0
		nDescarte := 0 
		nEstoque := 0
		nConfBom := 0
		nConfRuim := 0   
		nDevOS := 0
		nDivAvar := 0
		nDivTot := 0
		nDesconto := 0
		
		
		// qtd total de carga recebida
		For nJ := 1 To Len(aCarga)
			If AllTrim(cProduto) == AllTrim(aCarga[nJ][1])
				nQt += aCarga[nJ][2]
			EndIf
		Next nJ
		
		// qtd utilizada do produto
		For nJ := 1 To Len(aAbast)
			If AllTrim(cProduto) == AllTrim(aAbast[nJ][1])
				nAbast += aAbast[nJ][3]
			EndIf
		Next nJ
		
		// retirado
		For nJ := 1 To Len(aRetir)
			If AllTrim(cProduto) == AllTrim(aRetir[nJ][1])
				nRetir += aRetir[nJ][2]
			EndIf
		Next nJ
		
		// saldo
	    dbSelectArea( "SZ6" )
	    If MsSeek( xFilial("SZ6") +AvKey( cArm ,"Z6_LOCAL") +AvKey( cProduto,"Z6_COD") )
			nQAtu := SZ6->Z6_QATU
	    EndIf
		
		// conferido bom
		For nJ := 1 To Len( aConfBom )
			If AllTrim(cProduto) == AllTrim(aConfBom[nJ][1])
				nConfBom := aConfBom[nJ][2]
				Exit
			EndIf
		Next nJ
		
		// conferido ruim
		For nJ := 1 To Len( aConfRuim )
			If AllTrim(cProduto) == AllTrim(aConfRuim[nJ][1])
				nConfRuim := aConfRuim[nJ][2]
				Exit
			EndIf
		Next nJ
		
		
		// contagem descarte maquinas
		For nJ := 1 To Len( aDescarte )
			If AllTrim(cProduto) == aDescarte[nJ][1]
				nDescarte += aDescarte[nJ][2]
			EndIf
		Next nJ          
		
		nPos := AScan( aExced, { |x| AllTrim(x[1]) == AllTrim(cProduto) } )
		If nPos > 0
			nDevOs := aExced[nPos][2] 
		EndIf
			
		// saldo estoque anterior
		nPos := AScan( aQtdSldAnt, { |x|  AllTrim(x[1]) == AllTrim(cProduto)  } )
		If nPos > 0
			nSaldoAnt := aQtdSldAnt[nPos][2]
		EndIf
		
		// divergencia avarias
		nDivAvar := ( nConfRuim - nDescarte )    
		nDivBom := ( nConfBom - nQAtu )
	   
		// divergencias totais -> se Diverg๊ncia de Avarias > 0, soma, senใo nใo soma
		nDivTot := ( nConfBom - nQAtu )
		If nDivAvar > 0
			nDivTot += nDivAvar
		EndIf
		                    
		// desconto       
		If _aLista1[nI][13] > 0
			nDesconto := _aLista1[nI][13]
		EndIf                            
		
		If _aLista1[nI][12] < 0
			nDesconto += _aLista1[nI][12]
		EndIf
		        
		_aLista1[nI][4] := nSaldoAnt	
		_aLista1[nI][5] := nQt
		_aLista1[nI][6] := nAbast
		_aLista1[nI][7] := nRetir
		_aLista1[nI][8] := nQAtu
		_aLista1[nI][9] := nConfBom
		_aLista1[nI][10] := nDevOS
		_aLista1[nI][11] := nDescarte
		_aLista1[nI][12] := nConfRuim
		_aLista1[nI][13] := nDivAvar  
		_aLista1[nI][14] := nDivTot
		_aLista1[nI][15] := nDesconto	                               
		                     
		
		// totalizadores 
		/* 
		nTotSaida += nQt  
		nTotAbast += nAbast
		nTotRet += nRetir
		nTotAvar += nDescarte
		nTotDev += nDevOS
		nTotDif += nDivTot
		nTotDsnto += nDesconto
		*/                           
			
	Next nI
EndIf

// totalizadores
For nI := 1 To Len( _aLista1 )
               
	nDesc := 0
	nCustD := 0
	nValue := 0
	nPosP := 0

	// DESCONTO
	If _aLista1[nI][15] < 0
		nDesc := _aLista1[nI][15]
		nCustd := Posicione( "SB1",1,xFilial("SB1") +AvKey(_aLista1[nI][2],"B1_COD"),"B1_CUSTD" )
	  	nValue := ( nDesc * nCustD )
	 
		nPosP := AScan( aDifNg, { |x| x[1] == _aLista1[nI][2] } )
		If nPosP == 0
			AADD( aDifNg, { _aLista1[nI][2],AllTrim(_aLista1[nI][3]), ABS(nDesc), nCustd, ABS(nDesc)*nCustd  } )
		Else
			aDifNg[nPosP][3] += ABS(nDesc)
			aDifNg[nPosP][5] += (aDifNg[nPosP][3] * nValue) 
		EndIf 
	EndIf
	
	// valor total
	nTotValue += nValue
	

	// TOTALIZADORES  
	nTotSaida += _aLista1[nI][5]  
	nTotAbast += _aLista1[nI][6] 
	nTotRet += _aLista1[nI][7] 
	nTotAvar += _aLista1[nI][11] 
	nTotDev += _aLista1[nI][10] 
	nTotDif += _aLista1[nI][14] 
	nTotDsnto += _aLista1[nI][15]   
Next nI

                       

nPercAb := Round( (nTotAbast/nTotSaida)*100, 2 )
nPercRt := Round( (nTotRet/nTotSaida)*100, 2 )
nPercAv := Round( (nTotAvar/nTotSaida)*100, 2 )
nPercDv := Round( (nTotDev/nTotSaida)*100, 2 )
//nPercPer:= Round( (nTotDif/nTotSaida)*100, 2 )

nPercPer:= Round( (nTotDsnto/nTotSaida)*100, 2 )
//nPercPerNg := Round( ABS(nTotDifNg/nTotSaida)*100, 2 )
//nPercPerPs := Round( (nTotDifPs/nTotSaida)*100, 2 )


// totalizador
oPrint:Say(nLin,nColIni2+100, "Consolidado", oFont5,200,CLR_BLACK )  
nLin += 50

oPrint:Say(nLin,nColIni2+100, "Total entrada itens ", oFont5,200,CLR_BLACK ) 
oPrint:Say(nLin,nColIni2+600, CVALTOCHAR(nTotSaida), oFont5,200,CLR_BLACK )  	
nLin += 40

oPrint:Say(nLin,nColIni2+100, "Total abastecido ", oFont5,200,CLR_BLACK )  	
oPrint:Say(nLin,nColIni2+600, CVALTOCHAR(nTotAbast), oFont5,200,CLR_BLACK )  
oPrint:Say(nLin,nColIni2+1000, CVALTOCHAR(nPercAb) +"%", oFont5,200,CLR_BLACK )
nLin += 40

oPrint:Say(nLin,nColIni2+100, "Total retirado " , oFont5,200,CLR_BLACK )  	
oPrint:Say(nLin,nColIni2+600, CVALTOCHAR(nTotRet), oFont5,200,CLR_BLACK ) 
oPrint:Say(nLin,nColIni2+1000, CVALTOCHAR(nPercRt) +"%", oFont5,200,CLR_BLACK )
nLin += 40

oPrint:Say(nLin,nColIni2+100, "Total descarte " , oFont5,200,CLR_BLACK )  	
oPrint:Say(nLin,nColIni2+600, CVALTOCHAR(nTotAvar), oFont5,200,CLR_BLACK )
//oPrint:Say(nLin,nColIni2+1000, CVALTOCHAR(nPercAv) +"%", oFont5,200,CLR_BLACK )	// comentado pois o descarte em sua maioria sai da PA
nLin += 40

oPrint:Say(nLin,nColIni2+100, "Total devolvido ", oFont5,200,CLR_BLACK )  	
oPrint:Say(nLin,nColIni2+600, CVALTOCHAR(nTotDev), oFont5,200,CLR_BLACK ) 
oPrint:Say(nLin,nColIni2+1000, CVALTOCHAR(nPercDv) +"%", oFont5,200,CLR_BLACK )
nLin += 40

oPrint:Say(nLin,nColIni2+100, "Total desconto ", oFont5,200,CLR_BLACK )  	
oPrint:Say(nLin,nColIni2+600, CVALTOCHAR(nTotDsnto), oFont5,200,CLR_BLACK ) 
oPrint:Say(nLin,nColIni2+1000, CVALTOCHAR(nPercPer) +"%", oFont5,200,CLR_BLACK )
nLin += 40

oPrint:Say(nLin,nColIni2+100, "Total em R$ ", oFont5,200,CLR_BLACK ) 
oPrint:Say(nLin,nColIni2+600, AllTrim( Transform( nTotValue, PesqPict("SD2","D2_TOTAL") ) ), oFont5,200,CLR_BLACK )

nLin += 40




// OS Inventario
nLin += 40
oPrint:Say(nLin,nColIni2+100, "OS Inventแrio: " +cOSInvent, oFont5,200,CLR_BLACK )  

// notas fiscais de saida e devolucao
nLin += 40
oPrint:Say(nLin,nColIni2+100, "Notas fiscais saํda", oFont5,200,CLR_BLACK )  
oPrint:Say(nLin,nColIni2+600, "Notas fiscais devolu็ใo", oFont5,200,CLR_BLACK )  

nLinNF := nLin
nLin += 40

For nI := 1  To Len(aNF)
	
	If nLin >= 2000
		RodaR()
		
		oPrint:EndPage()             
  		oPrint:StartPage()
  
		CabecR(cArmazem,dInicio,dFim,cCodTec)
  	EndIf
  	
  	oPrint:Say(nLin,nColIni2+100, aNF[nI][1] +"/" +aNF[nI][2], oFont6,200,CLR_BLACK )  
	nLin += 40	
 
Next nI

nLin := nLinNF 
nLin += 40
  	
	
If nLin >= 2000
	RodaR()
	
	oPrint:EndPage()             
	oPrint:StartPage()
  
	CabecR(cArmazem,dInicio,dFim,cCodTec)
EndIf
  	
oPrint:Say(nLin,nColIni2+600, cNfDev +"/" +cSeriDev, oFont6,200,CLR_BLACK )  
//nLin += 40


nLin := nLinNF 

// pedidos gerados - descarte/perda
STATICCALL( TTPROC57, PedCiclo, cArmazem,dInicio,cHrIniCC,dFim,@aPedido ) 	

oPrint:Say(nLin,nColIni2+1200, "Pedidos gerados", oFont5,200,CLR_BLACK )

nLin += 40  

For nI := 1 To Len( aPedido )
	oPrint:Say(nLin,nColIni2+1200, aPedido[nI][1] +" -> TOTAL: " +cvaltochar(aPedido[nI][2]) , oFont6,200,CLR_BLACK )
	nLin += 40    
Next nI
 	

// finaliza pagina
RodaR()
oPrint:EndPage()             

// nova pagina
oPrint:StartPage()
CabecR(cArmazem,dInicio,dFim,cCodTec)
	
CorpoR()


For nI := 1 To Len( _aLista1 )

	If nLin >= 2000
		RodaR()
		
		oPrint:EndPage()             
  		oPrint:StartPage()
  
		CabecR( cArmazem,dInicio,dFim,cCodTec )
		
		CorpoR()
  	EndIf       
  	

	cProduto := _aLista1[nI][2]
	cDescProd := SubStr( AllTrim(_aLista1[nI][3]),1,20 )  	
  	nEstAnt := _aLista1[nI][4]
  	nSaida := _aLista1[nI][5]
  	nAbast := _aLista1[nI][6]
  	nRetirado := _aLista1[nI][7]
  	nSaldo := _aLista1[nI][8]
  	nConfBom := _aLista1[nI][9]
  	nDevProd := _aLista1[nI][10]
  	nDescarte := _aLista1[nI][11]
  	nDescApur := _aLista1[nI][12]
  	nDivAvar := _aLista1[nI][13]
  	nDivTot := _aLista1[nI][14]
  	nDesconto := _aLista1[nI][15]
  	
	// printa
  	oPrint:Say(nLin,nColIni+_nColIt1, cProduto , oFont6,200,CLR_BLACK )
	oPrint:Say(nLin,nColIni+_nColIt2, cDescProd, oFont6,200,CLR_BLACK ) 
	oPrint:Say(nLin,nColIni+_nColIt3, CVALTOCHAR(nEstAnt), oFont6,200,CLR_BLACK ) 
	oPrint:Say(nLin,nColIni+_nColIt4, CVALTOCHAR(nSaida), oFont6,200,CLR_BLACK )
	oPrint:Say(nLin,nColIni+_nColIt5, CVALTOCHAR(nAbast), oFont6,200,CLR_BLACK )
	oPrint:Say(nLin,nColIni+_nColIt6, CVALTOCHAR(nRetirado), oFont6,200,CLR_BLACK )
	oPrint:Say(nLin,nColIni+_nColIt7, CVALTOCHAR(nSaldo), oFont6,200,CLR_BLACK )            
	oPrint:Say(nLin,nColIni+_nColIt8, CVALTOCHAR(nConfBom), oFont6,200,CLR_BLACK )            
	oPrint:Say(nLin,nColIni+_nColIt9, CVALTOCHAR(nDevProd), oFont6,200,CLR_BLACK ) 
	oPrint:Say(nLin,nColIni+_nColIt10, CVALTOCHAR(nDescarte), oFont6,200,CLR_BLACK )
	oPrint:Say(nLin,nColIni+_nColIt11, CVALTOCHAR(nDescApur), oFont6,200,CLR_BLACK ) 
	oPrint:Say(nLin,nColIni+_nColIt12, CVALTOCHAR(nDivAvar), oFont6,200,CLR_BLACK ) 
	oPrint:Say(nLin,nColIni+_nColIt13, CVALTOCHAR(nDivTot), oFont6,200,CLR_BLACK ) 
	oPrint:Say(nLin,nColIni+_nColIt14, CVALTOCHAR(nDesconto), oFont6,200,CLR_BLACK )  
	
	nLin += 40      

Next nI       


// colocar aqui os descontos, caso tenha
// negativo     
If !Empty(aDifNg)
	ImpDesc(cCodTec,cEmpresa,aDifNg)
EndIf


// rodape
RodaR()

// preview - abre tela
oPrint:Preview() 

RestArea(aArea)
   
CursorArrow()

Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTESTR15  บAutor  ณMicrosiga           บ Data ณ  04/24/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CabecR(cArmazem,dInicio,dFim,cCodTec)

Local cNomeAtend := Posicione( "AA1",1,xFilial("AA1") +AvKey(cCodTec,"AA1_CODTEC"),"AA1_NOMTEC" )
Local cNomeArm	:= AllTrim( Posicione( "ZZ1",1,xFilial("ZZ1") +AvKey(cArmazem,"ZZ1_COD"),"ZZ1_DESCRI" ) )

_nPag++

nLin := 20
oPrint:Say(nLin,nColIni2,"Apura็ใo",oFont5,300,CLR_BLACK )
oPrint:Say(nLin,nColIni2+300,"Armaz้m " +cArmazem +" - " +cNomeArm ,oFont5,300,CLR_BLACK )
oPrint:Say(nLin,nColIni2+1300,"Inํcio: " +dtoc(dInicio) +" - Fim: " +dtoc(dFim) ,oFont5,300,CLR_BLACK )
oPrint:Say(nLin,nColIni2+2300,"Atendente: " +cNomeAtend,oFont5,300,CLR_BLACK )


nLin += 60
oPrint:Line( nLin,nColIni2,nLin,nColFim+900 )

nLin := 200

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTESTR15  บAutor  ณMicrosiga           บ Data ณ  04/24/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CorpoR()


oPrint:Say(nLin,nColIni2+1400,"Distribui็ใo de produtos",oFont5,300,CLR_BLACK )
nLin += 150  

oPrint:Say(nLin,nColIni+_nColIt1, "C๓digo", oFont6,200,CLR_BLACK )
oPrint:Say(nLin,nColIni+_nColIt2, "Descri็ใo", oFont6,200,CLR_BLACK ) 
oPrint:Say(nLin,nColIni+_nColIt3, "EST A.", oFont6,200,CLR_BLACK ) 
oPrint:Say(nLin,nColIni+_nColIt4, "Carga", oFont6,200,CLR_BLACK )
oPrint:Say(nLin,nColIni+_nColIt5, "Abast.", oFont6,200,CLR_BLACK )
oPrint:Say(nLin,nColIni+_nColIt6, "Ret.", oFont6,200,CLR_BLACK )
oPrint:Say(nLin,nColIni+_nColIt7, "Saldo", oFont6,200,CLR_BLACK )
oPrint:Say(nLin,nColIni+_nColIt8, "Contado", oFont6,200,CLR_BLACK )
oPrint:Say(nLin,nColIni+_nColIt9, "Devolvido", oFont6,200,CLR_BLACK )
oPrint:Say(nLin,nColIni+_nColIt10, "Avar. Maq", oFont6,200,CLR_BLACK )
oPrint:Say(nLin,nColIni+_nColIt11, "Avar. Apur", oFont6,200,CLR_BLACK )
oPrint:Say(nLin,nColIni+_nColIt12, "Div. Apur", oFont6,200,CLR_BLACK )
oPrint:Say(nLin,nColIni+_nColIt13, "Div. Tot", oFont6,200,CLR_BLACK )
oPrint:Say(nLin,nColIni+_nColIt14, "Desconto", oFont6,200,CLR_BLACK )



nLin += 40


Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTESTR15  บAutor  ณMicrosiga           บ Data ณ  04/24/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RodaR()


If nLin < 2200
	nLin := 2200
EndIf

oPrint:Line( nLin,nColIni2+2100,nLin,nColFim+500 )
nLin += 10

oPrint:Say(nLin,nColIni2+100, "Responsแvel pela apura็ใo : " +UsrFullName(__cUserID) , oFont6,200,CLR_BLACK )
oPrint:Say(nLin,nColIni2+2200, "Assinatura do funcionแrio" , oFont6,200,CLR_BLACK )


nLin += 30
oPrint:Say(nLin,nColIni2+100, "Data Hora impressใo: " +dtoc(Date()) +" " +_cHoraImp , oFont6,200,CLR_BLACK )
nLin += 30
oPrint:Say(nLin,nColIni2+100, "p. " +cvaltochar(_nPag) , oFont5,200,CLR_BLACK )


Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTESTR15  บAutor  ณMicrosiga           บ Data ณ  04/24/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ImpDesc(cCodTec,cEmpresa,aProds)

Local cNomeAtend := Posicione( "AA1",1,xFilial("AA1") +AvKey(cCodTec,"AA1_CODTEC"),"AA1_NOMTEC" )
Local nTotal := 0
Local nI

oPrint:EndPage()             
oPrint:StartPage()


For nI := 1 To Len(aProds)
	nTotal += aProds[nI][5]
Next nI


nLin := 200
oPrint:Say(nLin,nColIni2+1100,"AUTORIZAวรO DE DESCONTO EM FOLHA DE PAGAMENTO",oFont5,300,CLR_BLACK )
nLin += 150  
			 
oPrint:Say(nLin,nColIni2+100, "Eu, "+cNomeAtend  +",Matrํcula :" +cCodTec +", funcionแrio da Empresa "+ cEmpresa,oFont6,1400,CLR_BLACK )                                                                 	
nLin += 60   

oPrint:Say(nLin,nColIni2+100, "autorizo o desconto em folha de pagamento, no valor total de R$ "+ Alltrim( TransForm(nTotal,PesqPict("SD2","D2_TOTAL") )) +" , em _____ parcelas, referente เ diferen็a na distribui็ใo de produtos.",oFont6,1400,CLR_BLACK )                                                                 	
nLin += 150   

//oPrint:Say(nLin,nColIni2+100, "Nota fiscal: " +cNumNF +"/" +cSerie,oFont6,1400,CLR_BLACK )                                                                 	
//nLin += 60 

//oPrint:Say(nLin,nColIni2+100, "Data de emissใo: "+dtoc(dDtEmissao),oFont6,1400,CLR_BLACK )
//nLin += 60                                                       	                                        

oPrint:Say(nLin,nColIni2+100, "Data da ocorr๊ncia:  "+ Dtoc(Date()),oFont6,1400,CLR_BLACK )
nLin += 200                                                       	                                        

oPrint:Say(nLin,nColIni2+1100, "PRODUTOS QUE SE ENCONTRAM COM DIVERGสNCIA",oFont6,1400,CLR_BLACK )
nLin += 50                                                       	                                         
oPrint:Say(nLin,nColIni2+1100, "----------------------------------------------------",oFont6,1400,CLR_BLACK )

nLin += 60 

oPrint:Say(nLin,nColIni2+100, "PRODUTO", oFont6,200,CLR_BLACK )
oPrint:Say(nLin,nColIni2+500, "DESCRIวรO", oFont6,200,CLR_BLACK )
oPrint:Say(nLin,nColIni2+1500, "QTD", oFont6,200,CLR_BLACK )
oPrint:Say(nLin,nColIni2+1700, "VALOR UNITARIO", oFont6,200,CLR_BLACK )
oPrint:Say(nLin,nColIni2+2200, "VALOR TOTAL", oFont6,200,CLR_BLACK )
nLin += 60 

oPrint:Line( nLin,nColIni2+100,nLin,nColFim+200 )
nLin += 20 

// item diferenca produto descricao valor 
For nI := 1 to Len( aProds )
	If nLin >= 2300
		oPrint:Say(nLin,nColIni2+2000, "CONTINUA PROX PAG. ---> ", oFont6,200,CLR_BLACK )
		oPrint:EndPage()             
  		oPrint:StartPage()
        
		nLin := 200
		
  		oPrint:Say(nLin,nColIni2+1200,"AUTORIZAวรO DE DESCONTO EM FOLHA DE PAGAMENTO",oFont5,300,CLR_BLACK )                  
  		nLin += 150
  		oPrint:Say(nLin,nColIni2+100, "PRODUTO", oFont6,200,CLR_BLACK )
		oPrint:Say(nLin,nColIni2+500, "DESCRIวรO", oFont6,200,CLR_BLACK )
		oPrint:Say(nLin,nColIni2+1500, "QTD", oFont6,200,CLR_BLACK )
		oPrint:Say(nLin,nColIni2+1700, "VALOR UNITARIO", oFont6,200,CLR_BLACK )
		oPrint:Say(nLin,nColIni2+2200, "VALOR TOTAL", oFont6,200,CLR_BLACK )
		nLin += 60 
		
		oPrint:Line( nLin,nColIni2+100,nLin,nColFim+200 )
		nLin += 20 
	EndIf
	
	oPrint:Say(nLin,nColIni2+100, aProds[nI][1] , oFont6,200,CLR_BLACK )
	oPrint:Say(nLin,nColIni2+500, aProds[nI][2], oFont6,200,CLR_BLACK )
	oPrint:Say(nLin,nColIni2+1500, CVALTOCHAR(aProds[nI][3]), oFont6,200,CLR_BLACK )
	oPrint:Say(nLin,nColIni2+1700, Transform( aProds[nI][4], PesqPict("SD2","D2_TOTAL") ), oFont6,200,CLR_BLACK )
	oPrint:Say(nLin,nColIni2+2200, Transform( aProds[nI][5], PesqPict("SD2","D2_TOTAL") ), oFont6,200,CLR_BLACK )
	nLin += 30

Next nI
nLin += 20
	
oPrint:Line( nLin,nColIni2+100,nLin,nColFim+200 )
nLin += 50 

oPrint:Say(nLin,nColIni2+100, "TOTAL A DESCONTAR R$ ", oFont6,200,CLR_BLACK )
oPrint:Say(nLin,nColIni2+2200, Transform(nTotal,PesqPict("SD2","D2_TOTAL")), oFont6,200,CLR_BLACK )
nLin += 50 

oPrint:Line( nLin,nColIni2+100,nLin,nColFim+200 )
   	 
   	   		
Return