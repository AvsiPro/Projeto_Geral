#include "totvs.ch"
#include "topconn.ch"
#include "tbiconn.ch"


User Function TTPROR41(cPatr,nRecSang,nRecAudt,aArraux)

Local oDlg
Local nOpca			:= 0
Local oGrp
Local oBtn1
Local oBtn2
Local nI			:= 0
Local cPerg			:= "TTPROR41"
Private nColIni		:= 40
Private nColIni2	:= 70                   
Private nLin		:= 25
Private nColFim		:= 2400
Private nColFim2	:= 2360      
Private aDados		:= {}
Private cNumChapa	:= ""
Private nRecS		:= 0 
Private nRecAdt		:= 0
Default cPatr		:= ""
Default nRecSang	:= 0
Default nRecAudt	:= 0   
Default aArraux		:= {}
    
If cEmpAnt <> "01"
	return
EndIF
    
If Empty(cPatr) .And. Empty(cCliente) .And. Empty(cLoja) 
	ValPerg(cPerg)
	Pergunte(cPerg,.T.,"Configure os parโmetros") 
	
	DEFINE MSDIALOG oDlg FROM  96,9 TO 310,592 TITLE OemToAnsi("Auditoria") PIXEL
		@ 18, 6 TO 66, 287 LABEL "" OF oDlg  PIXEL
		@ 29, 15 SAY OemToAnsi("Relat๓rio de auditoria de mแquina") SIZE 268, 8 OF oDlg PIXEL
		@ 38, 15 SAY OemToAnsi("") SIZE 268, 8 OF oDlg PIXEL
		@ 48, 15 SAY OemToAnsi("Configure os parametros") SIZE 268, 8 OF oDlg PIXEL
		DEFINE SBUTTON FROM 80, 190 TYPE 5 ACTION Pergunte(cPerg,.T.) ENABLE OF oDlg
		DEFINE SBUTTON FROM 80, 223 TYPE 1 ACTION (oDlg:End(),nOpca:=1) ENABLE OF oDlg
		DEFINE SBUTTON FROM 80, 255 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTER

	If nOpca == 1
		If Empty(MV_PAR01) //.And. Empty(MV_PAR02) .And. Empty(MV_PAR03)
			Aviso("TTPROR41","Preencha o parametro patrim๔nio.",{"Ok"})
			Return
		EndIf
		
		cNumChapa := MV_PAR01
		
		Processa({ || Imprime(aArraux)},"Buscando dados...")     
	EndIf
Else
	cNumChapa := cPatr
	nRecS := nRecSang 
	nRecAdt := nRecAudt
	Processa({ || Imprime(aArraux)},"Buscando dados...")    
EndIf



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImprime    บAutor  ณJackson E. de Deus บ Data ณ  18/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Faz a impressao do relatorio                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Imprime(aArraux)
           
Local aCbit	:=	{"Data","Tipo","Ajuste","Limite_Troco","Troco_Abastecido","Troco_Sangrado","Valor_Sangrado","Contador_Cash","Venda","Fundo_Troco"}
RetDados()

If Len(aDados) == 0
	Aviso("TTPROC40 - Imprime","Nใo hแ dados para os parโmetros informados.",{"Ok"})
	//Return
EndIf

oFont1 := TFont():New('Arial',,-25,.T.,.T.)
oFont2 := TFont():New('Arial',,-15,.T.,.T.)
oFont3 := TFont():New('Arial',,-15,.T.,.F.)
oFont4 := TFont():New('Arial',,-20,.T.,.T.)
oFont5 := TFont():New('Arial',,-10,.T.,.T.)                                                            
oFont6 := TFont():New('Arial',,-10,.T.,.F.) 
                                                               
oPrint := TMSPrinter():New("Auditoria de mแquina")  
oPrint:SetPortrait()  
oPrint:SetPaperSize(9)
oPrint:Setup()     
oPrint:StartPage()                  
                                                                          
ProcRegua(Len(aDados))     
//For nI := 1 To Len(aDados)				  
	cCliente := aDados[2][2][4] +"/" +aDados[2][2][5] +" - " +aDados[2][2][6]
	cEnd := aDados[2][2][7] +", " +aDados[2][2][8] +" - " +aDados[2][2][9]
	cMaquina := aDados[2][2][1] +" - " +aDados[2][2][2]		                      
	cLocFis := aDados[2][2][3]
	cNumOsAdt := aDados[2][2][14]
	cAudit := aDados[2][2][17]
	cDtAdt := DTOC(aDados[2][2][11])
	cHrAdt := aDados[2][2][15]
	cAgAdt := aDados[2][2][16]
	cCntCshAdt := aDados[2][2][22]
	cCntSleAdt := cvaltochar(aDados[2][2][18])
	
	cNumOsAbst := aDados[1][2][3]
	cAbast := aDados[1][2][5]
	cDtAbst := DTOC(aDados[1][2][6])
	cHrAbst := aDados[1][2][7]
	cAgAbst := aDados[1][2][4]
	cCntCshAbt := aDados[1][2][8]
	cCntSleAbt := cvaltochar(aDados[1][2][9])
	
	nFdoAnt := aDados[1][2][2]
	nCed := aDados[2][2][23]
	nMOeda := aDados[2][2][24]
	nPos := aDados[2][2][25]
	nTotSangr := nCed+nMoeda+nPos
	nTrocoAbst := aDados[2][2][19]
	nFdoTroco := aDados[2][2][21]
	nVlAjus := aDados[2][2][26]      
	
	nVenda := (val(aDados[2][2][22]) - val(aDados[1][2][8])) /100

	// valor ajuste
	If nVlAjus < 0
		cColor := CLR_RED
	Else
		cColor := CLR_BLUE
	EndIf
	
	// cabecalho
	Cabec()
	
	// Tipo de servico
	nLin += 5
	
	// box dados do atendimento
	nLinIniBox := nLin	              

	oPrint:Say(nLin,nColIni2,"Fundo de troco anterior" ,oFont2,1400,CLR_BLACK )
 	oPrint:Say(nLin,nColIni2+1500,AllTrim(Transform(nFdoAnt,PESQPICT("SF2","F2_VALBRUT"))) ,oFont2,1400,CLR_BLACK )
	nLin += 100                                                   
			
	// Colunas gerais 
	oPrint:Say(nLin,nColIni2,"C้dula",oFont2,300,CLR_BLACK )
	oPrint:Say(nLin,nColIni2+1500,AllTrim(Transform(nCed,PESQPICT("SF2","F2_VALBRUT"))) ,oFont2,1400,CLR_BLACK ) 
	nLin += 100   
	oPrint:Say(nLin,nColIni2,"Moeda",oFont2,300,CLR_BLACK )  
	oPrint:Say(nLin,nColIni2+1500,AllTrim(Transform(nMoeda,PESQPICT("SF2","F2_VALBRUT"))) ,oFont2,1400,CLR_BLACK )
	nLin += 100   
	oPrint:Say(nLin,nColIni2,"Moedeiro",oFont2,300,CLR_BLACK )  
	oPrint:Say(nLin,nColIni2+1500,AllTrim(Transform(0,PESQPICT("SF2","F2_VALBRUT"))) ,oFont2,1400,CLR_BLACK )    //trocaraqui
	nLin += 100   
	oPrint:Say(nLin,nColIni2,"POS",oFont2,300,CLR_BLACK )        
	oPrint:Say(nLin,nColIni2+1500,AllTrim(Transform(nPos,PESQPICT("SF2","F2_VALBRUT"))) ,oFont2,1400,CLR_BLACK )
	nLin += 100
	
	oPrint:Line( nLin,nColIni,nLin,nColFim )
	nLin += 100                                               

	oPrint:Say(nLin,nColIni2,"Total Sangria",oFont2,300,CLR_BLACK ) 
	oPrint:Say(nLin,nColIni2+1500,AllTrim(Transform(nTotSangr,PESQPICT("SF2","F2_VALBRUT"))) ,oFont2,1400,CLR_BLACK )
	nLin += 100
	                                                                                                                           
	oPrint:Line( nLin,nColIni,nLin,nColFim )
	nLin += 100                                               

	oPrint:Say(nLin,nColIni2,"Venda",oFont2,300,CLR_BLACK ) 
	oPrint:Say(nLin,nColIni2+1500,AllTrim(Transform(nVenda,PESQPICT("SF2","F2_VALBRUT"))) ,oFont2,1400,CLR_BLACK )            
	nLin += 100
	
	oPrint:Line( nLin,nColIni,nLin,nColFim )
	nLin += 100
	                                               
	oPrint:Say(nLin,nColIni2,"Falta Apurada",oFont2,300,CLR_BLACK )
	oPrint:Say(nLin,nColIni2+1500, AllTrim(Transform(nVlAjus,PESQPICT("SF2","F2_VALBRUT"))) ,oFont4,1400, cColor )                                                                 
	nLin += 100   

	oPrint:Line( nLin,nColIni,nLin,nColFim )                 
	nLin += 50   
	
/*	oPrint:Say(nLin,nColIni2,"Troco abastecido",oFont2,300,CLR_BLACK )
	oPrint:Say(nLin,nColIni2+1500,AllTrim(Transform(nTrocoAbst,PESQPICT("SF2","F2_VALBRUT"))) ,oFont2,1400,CLR_BLACK )                                                                 
	nLin += 100
	                                  
	oPrint:Line( nLin,nColIni,nLin,nColFim )               
	nLin += 100   
		
	oPrint:Say(nLin,nColIni2,"Fundo de troco",oFont2,300,CLR_BLACK )
	oPrint:Say(nLin,nColIni2+1500,AllTrim(Transform(nFdoTroco,PESQPICT("SF2","F2_VALBRUT"))),oFont2,1400,CLR_BLACK )                                                                 	
	nLin += 100   
 */ 
 //Data	Tipo	Ajuste	Limite_Troco	Troco_Abastecido	Troco_Sangrado	Valor_Sangrado	Contador_Cash	Venda	Fundo_Troco
 	npulo := 20	     
    For nT := 1 to 10
    	oPrint:Say(nLin,nColIni2+nPulo,cvaltochar(aCbit[nT]),oFont5,300,CLR_BLACK )
   		nPulo += 200
   	Next nT
   	nLin += 30
   	
 	For nX := 1 to len(aArraux)
 		//oPrint:Say(nLin,nColIni2,"Falta Apurada",oFont2,300,CLR_BLACK )
   		//oPrint:Say(nLin,nColIni2+1500, AllTrim(Transform(nVlAjus,PESQPICT("SF2","F2_VALBRUT"))) ,oFont4,1400, cColor ) 
   		npulo := 20
   		For nP := 2 to 11                                                                
	   		oPrint:Say(nLin,nColIni2+nPulo,cvaltochar(aArraux[nX,nP]),oFont5,300,CLR_BLACK )
	   		nPulo += 200
	   	Next nP
  		nLin += 30   

 	Next nX
   	// rodape 	
   	Roda()
//Next nI     

oPrint:Preview()  

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCabec  บAutor  ณJackson E. de Deus     บ Data ณ  18/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta o cabecalho da pagina                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Cabec()

nLin := 25
                    
// cabecalho
oBrush1 := TBrush():New( , CLR_GRAY )
oPrint:FillRect( {nLin, nColIni, nLin+120, nColFim}, oBrush1 )  
oBrush1:End()     
nLin += 10
oPrint:Say(nLin,nColIni2,"Auditoria de Mแquina" ,oFont1,1400,CLR_BLACK )
nLin += 140
                             
oPrint:Say( nLin,nColIni,"Cliente",oFont3,1400,CLR_BLACK )
oPrint:Say( nLin,nColIni+300,cCliente,oFont3,1400,CLR_BLACK )
nLin += 60

oPrint:Say( nLin,nColIni,"Endere็o",oFont3,1400,CLR_BLACK )
oPrint:Say( nLin,nColIni+300,cEnd,oFont3,1400,CLR_BLACK )
nLin += 60

oPrint:Say( nLin,nColIni,"Patrim๔nio",oFont3,1400,CLR_BLACK )
oPrint:Say( nLin,nColIni+300,cMaquina,oFont3,1400,CLR_BLACK )
nLin += 60

oPrint:Say( nLin,nColIni,"Local fํsico",oFont3,1400,CLR_BLACK )
oPrint:Say( nLin,nColIni+300,cLocFis,oFont3,1400,CLR_BLACK )
nLin += 100

oPrint:Line( nLin,nColIni,nLin,nColFim )

nLin += 100

Return
   
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRoda    บAutor  ณJackson E. de Deus    บ Data ณ  18/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta o rodape da pagina - sem uso no momento              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Roda()

If nLin < 3000
	nLin := 3000
EndIf

nLin += 10                         
oPrint:Say( nLin,nColIni,"ฺltima leitura de auditoria",oFont5,300,CLR_BLACK )
nLin += 40              	

nColAx := nColIni2
nLinAx := nLin

// Box
oPrint:Box( nLin,40,nLin+110,300 ) 
oPrint:Box( nLin,305,nLin+110,800 ) 
oPrint:Box( nLin,805,nLin+110,1050 ) 
oPrint:Box( nLin,1055,nLin+110,1250 ) 
oPrint:Box( nLin,1255,nLin+110,1500 ) 
oPrint:Box( nLin,1505,nLin+110,2100 ) 
oPrint:Box( nLin,2105,nLin+110,nColFim ) 

nLin += 60
oPrint:Say( nLin,50,"OS",oFont5,300,CLR_BLACK )
oPrint:Say( nLin,310,"Auditor",oFont5,300,CLR_BLACK )
oPrint:Say( nLin,810,"Dia",oFont5,300,CLR_BLACK )
oPrint:Say( nLin,1060,"Hora",oFont5,300,CLR_BLACK )
oPrint:Say( nLin,1260,"Agente",oFont5,300,CLR_BLACK )
oPrint:Say( nLin,1510,"Cont. Cash",oFont5,300,CLR_BLACK )
oPrint:Say( nLin,2110,"Cont. Sale",oFont5,300,CLR_BLACK )

nLin := nLinAx
nColIni2 := nColAx

oPrint:Say( nLin,50,cNumOsAdt,oFont6,300,CLR_BLACK )
oPrint:Say( nLin,310,cAudit,oFont6,300,CLR_BLACK )
oPrint:Say( nLin,810,cDtAdt,oFont6,300,CLR_BLACK )
oPrint:Say( nLin,1060,cHrAdt,oFont6,300,CLR_BLACK )
oPrint:Say( nLin,1260,cAgAdt,oFont6,300,CLR_BLACK )
oPrint:Say( nLin,1510,cCntCshAdt,oFont6,300,CLR_BLACK )
oPrint:Say( nLin,2110,cCntSleAbt,oFont6,300,CLR_BLACK )


nLin += 150              	             
oPrint:Say( nLin,nColIni,"ฺltima leitura de sangria",oFont5,300,CLR_BLACK )
nLin += 40

nLinAx := nLin

// BOX
oPrint:Box( nLin,40,nLin+110,300 ) 
oPrint:Box( nLin,305,nLin+110,800 ) 
oPrint:Box( nLin,805,nLin+110,1050 ) 
oPrint:Box( nLin,1055,nLin+110,1250 ) 
oPrint:Box( nLin,1255,nLin+110,1500 ) 
oPrint:Box( nLin,1505,nLin+110,2100 ) 
oPrint:Box( nLin,2105,nLin+110,nColFim ) 

nLin += 60
oPrint:Say( nLin,50,"OS",oFont5,300,CLR_BLACK )
oPrint:Say( nLin,310,"Atendente",oFont5,300,CLR_BLACK )
oPrint:Say( nLin,810,"Dia",oFont5,300,CLR_BLACK )
oPrint:Say( nLin,1060,"Hora",oFont5,300,CLR_BLACK )
oPrint:Say( nLin,1260,"Agente",oFont5,300,CLR_BLACK )
oPrint:Say( nLin,1510,"Cont. Cash",oFont5,300,CLR_BLACK )
oPrint:Say( nLin,2110,"Cont. Sale",oFont5,300,CLR_BLACK )

nLin := nLinAx

oPrint:Say( nLin,50,cNumOsAbst,oFont6,300,CLR_BLACK )
oPrint:Say( nLin,310,cAbast,oFont6,300,CLR_BLACK )
oPrint:Say( nLin,810,cDtAbst,oFont6,300,CLR_BLACK )
oPrint:Say( nLin,1060,cHrAbst,oFont6,300,CLR_BLACK )
oPrint:Say( nLin,1260,cAgAbst,oFont6,300,CLR_BLACK )
oPrint:Say( nLin,1510,cCntCshAbt,oFont6,300,CLR_BLACK )
oPrint:Say( nLin,2110,cCntSleAbt,oFont6,300,CLR_BLACK )


oPrint:EndPage()          

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetDados    บAutor  ณJackson E. de Deusบ Data ณ  18/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna os dados da pesquisa                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RetDados()

Local cSql := ""
Local aAux := {}      
Local aValor := {{"",""},{"",""}}

aDados := {{"SANGRIA"},{"AUDITORIA"}}

// nRecSang, nRecAudt
// sangria anterior
cSql := "SELECT ZI_PATRIMO, ZI_FDOTRO, ZI_DATA, ZN_NUMOS, ZN_AGENTE, ZN_NOMAGEN, ZN_HORA, ZI_CNTCAS, ZN_NUMATU "
cSql += " FROM " +RetSqlName("SZI") + " SZI "
cSql += "LEFT JOIN " +RetSqlName("SZN") +" SZN ON "
cSql += " ZN_CLIENTE = ZI_CLIENTE AND ZN_LOJA = ZI_LOJA "
cSql += " AND ZN_TIPINCL IN ( 'SANGRIA' )"
cSql += " AND SZN.D_E_L_E_T_ = '' AND ZN_DATA = ZI_DATA AND ZN_PATRIMO = ZI_PATRIMO "
cSql += " WHERE SZI.R_E_C_N_O_ = '"+cvaltochar(nRecS)+"' AND SZI.D_E_L_E_T_ = '' "

If Select("TSQL") > 0
	TSQL->(dbCloseArea())
EndIf 

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cSql),"TSQL",.F.,.T.) 

dbSelectArea("TSQL")
dbGotop()
While !EOF()
	AADD( aDados[1], { Trim(TSQL->ZI_PATRIMO),TSQL->ZI_FDOTRO, TSQL->ZN_NUMOS, TSQL->ZN_AGENTE, Trim(TSQL->ZN_NOMAGEN),;
					 STOD(TSQL->ZI_DATA), TSQL->ZN_HORA, TSQL->ZI_CNTCAS, TSQL->ZN_NUMATU } )
	aValor[2][1] := TSQL->ZI_DATA
	aValor[2][2] := TSQL->ZN_HORA
	dbSkip()
End
TSQL->(dbCloseArea())

// auditoria
cSql := "SELECT ZI_PATRIMO, ZI_CLIENTE, ZI_LOJA, ZI_DATA, ZI_TIPO, ZI_LIMTRO, ZI_VLRAJU, ZI_VLRTRO, ZI_VLRSAN, ZI_FDOTRO, ZI_CNTCAS, "
cSql += " A1_NOME, A1_END, A1_BAIRRO, A1_MUN, A1_EST, N1_DESCRIC, N1_XLOCINS, "
cSql += " ZN_MOEDA1R, ZN_NOTA01, ZN_NUMOS, ZN_AGENTE, ZN_NOMAGEN, ZN_HORA, ZN_NUMATU "
/*
cSql += "( "
cSql += 	"SELECT SUM(ZZE_VLRLIQ) VLLIQ FROM " +RetSqlName("ZZE")
cSql += 	" WHERE ZZE_PATRIM = ZI_PATRIMO "
cSql += 	"AND ZZE_ESTTRA = 'EFETUADA PDV' "
cSql += 	"AND ZZE_DATATR = ZI_DATA "
cSql += ") POS "
*/
cSql += " FROM " +RetSqlName("SZI") + " SZI "

cSql += " INNER JOIN " +RetSqlName("SN1") +" SN1 ON "
cSql += " N1_CHAPA = ZI_PATRIMO AND SN1.D_E_L_E_T_ = '' "

cSql += " INNER JOIN " +RetSqlName("SA1") +" SA1 ON "
cSql += " A1_COD = ZI_CLIENTE AND ZI_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = '' "

cSql += "LEFT JOIN " +RetSqlName("SZN") +" SZN ON "
cSql += " ZN_PATRIMO = ZI_PATRIMO AND ZN_DATA = ZI_DATA "
cSql += " AND ZN_CLIENTE = ZI_CLIENTE AND ZN_LOJA = ZI_LOJA "
cSql += " AND ZN_TIPINCL IN ( 'AUDITORIA' )"
cSql += " AND SZN.D_E_L_E_T_ = ''"

cSql += " WHERE SZI.D_E_L_E_T_ = '' "

If !Empty(cNumChapa)
	cSql += " AND ZI_PATRIMO = '"+cNumChapa+"' "
EndIf                                          

If !Empty(nRecAdt)
	cSql += " AND SZI.R_E_C_N_O_ = '"+cvaltochar(nRecAdt)+"' "
EndIf
                                                                                                                   		                                                                		
If Select("TSQL") > 0
	TSQL->(dbCloseArea())
EndIf 

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cSql),"TSQL",.F.,.T.) 

ProcRegua(0)
dbSelectArea("TSQL")
dbGotop()
While !EOF()
	aValor[1][1] := TSQL->ZI_DATA
	aValor[1][2] := TSQL->ZN_HORA
	nPos := StaticCall(TTAUDT02,VendaPOS,cNumChapa,aValor)        
	
	AADD( aDados[2], { Trim(TSQL->ZI_PATRIMO), AllTrim(TSQL->N1_DESCRIC), AllTrim(TSQL->N1_XLOCINS),TSQL->ZI_CLIENTE, TSQL->ZI_LOJA,;
					 Trim(TSQL->A1_NOME), Trim(TSQL->A1_END), Trim(TSQL->A1_BAIRRO),Trim(TSQL->A1_MUN), Trim(TSQL->A1_EST),STOD(TSQL->ZI_DATA),;
					 TSQL->ZI_TIPO, TSQL->ZI_LIMTRO,TSQL->ZN_NUMOS, TSQL->ZN_HORA, TSQL->ZN_AGENTE,Trim(TSQL->ZN_NOMAGEN),TSQL->ZN_NUMATU,;
					 TSQL->ZI_VLRTRO, TSQL->ZI_VLRSAN, TSQL->ZI_FDOTRO, TSQL->ZI_CNTCAS, TSQL->ZN_NOTA01, TSQL->ZN_MOEDA1R, nPos, TSQL->ZI_VLRAJU } )
					 
	dbSkip()
End
TSQL->(dbCloseArea())


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValPerg  บAutor  ณJackson E. de Deus   บ Data ณ  18/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se existe a pergunta, se nใo existir, cria.       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValPerg(cPerg)
   	PutSx1(cPerg,'01','Patrim๔nio ?','','','mv_ch0','C',6,0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','')
	//PutSx1(cPerg,'02','Data ?','','','mv_ch1','D',8,0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')	
	PutSx1(cPerg,'02','Cliente ?','','','mv_ch1','C',6,0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')		
	PutSx1(cPerg,'03','Loja ?','','','mv_ch2','C',4,0,0,'G','','','','','mv_par03',,,'','','','','','','','','','','','','','')			
Return