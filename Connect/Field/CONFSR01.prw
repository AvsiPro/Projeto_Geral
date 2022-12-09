#include 'protheus.ch'
#include 'parmtype.ch'
#include 'TBICONN.ch'

#DEFINE DMPAPER_A4
#DEFINE IMP_SPOOL 2
#DEFINE IMP_PDF	   6

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFSR01  บAutor  ณMicrosiga           บ Data ณ  09/12/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio de Pre-faturamento                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CONFSR01(cTipo,cPeriodo)

Local nlinha   := 0
Local nPagina  := 1  
Local nTotDia  := 0     
Local nTotMes  := 0
Local cDiaAt   := ''
Local nSub
Local nCont 
Private lAdjustToLegacy := .F. 
Private lDisableSetup  := .T.
Private oFont2n
Private oFont8
Private oFont9
Private oFont10
Private oFont15n
Private oFont16
Private oFont16n
Private oFont14n
Private oFont24
Private i := 0
Private oPrint
Private aBmp2	 := "\SYSTEM\logoamc.bmp"
Private aBmp 	 := "\SYSTEM\logo_toktake.png"
Private aCoords1 := {0150,1900,0550,2300}
Private aCoords2 := {0450,1050,0550,1900}
Private aCoords3 := {0710,1900,0810,2300}
Private aCoords4 := {0980,1900,1050,2300}
Private aCoords5 := {1330,1900,1400,2300}
Private aCoords6 := {2080,1900,2180,2300}     // 2000 - 2100
Private aCoords7 := {2350,1900,2420,2300}     // 2270 - 2340
Private aCoords8 := {2700,1900,2770,2300}     // 2620 - 2690
Private oBrush            

Default cTipo	:=	'SINTษTICO'

oFont2n := TFont():New("Times New Roman",,10,,.T.,,,,,.F. )
oFont5  := TFont():New("Arial",9,5 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont7  := TFont():New("Arial",9,7 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont8  := TFont():New("Arial",9,8 ,.T.,.T.,5,.T.,5,.T.,.F.)
oFont9  := TFont():New("Arial",9,9 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont9I := TFont():New("Arial",9,9 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont9N := TFont():New("Arial",9,9 ,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10 := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont11n:= TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont12n:= TFont():New("Arial",9,12,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n:= TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n:= TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16 := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n:= TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont24 := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

oPrint 	:= FWMSPrinter():New("PreFat"+dtos(ddatabase)+cvaltochar(strtran(time(),":"))+".rel",  IMP_PDF, lAdjustToLegacy, "c:\temp\", lDisableSetup,,,,.F.,,,.T.)

oPrint:SetResolution(78) //Tamanho estipulado para a Danfe
oPrint:SetPortrait()
oPrint:SetPaperSize(DMPAPER_A4)
oPrint:StartPage()   	// Inicia uma nova pแgina
oPrint:SetMargin(60,60,60,60)
oPrint:cPathPDF := "c:\temp\"

oFont9I:Italic := .T.
oBrush := TBrush():New("",5)//4
//
Cabecalho(nPagina,cTipo)
nPagina++

Asort(aList,,,{|x,y| x[9] < y[9]})

If cTipo == "ANALITICO"
	nLinha := 110             
Else
	nLinha := 100
EndIf
 
If cPeriodo == "1"
	cDiaAt	:= aList[1,10]
Else
	cDiaAt	:= strzero(day(ddatabase),2)
EndIf

For nCont := 1 to len(aList)
	//Nova pagina 
	If nLinha > 715
		Cabecalho(nPagina,cTipo)
		nPagina++
		
		If cTipo == "ANALITICO"
			nLinha := 110             
		Else
			nLinha := 100
		EndIf
		 
		If cPeriodo == "1"
			cDiaAt	:= aList[1,10]
		Else
			cDiaAt	:= strzero(day(ddatabase),2)
		EndIf
			
	EndIf         
	
	If cPeriodo == "1"
		If cDiaAt <> aList[nCont,10]
			oPrint:Say(nLinha,195,'Total dia '+cDiaAt				   						,oFont9N,,CLR_HBLUE)
			oPrint:Say(nLinha,575,Transform(nTotDia,"@E 99,999.99")							,oFont9N,,CLR_HBLUE)
			nTotMes += nTotDia

			nTotDia := aList[nCont,02]
			cDiaAt  := aList[nCont,10]
			nLinha += 20 
		else
			nTotDia += aList[nCont,02]
		EndIf
			
		oPrint:Say(nLinha,025,aList[nCont,10]					,oFont9)
		oPrint:Say(nLinha,105,aList[nCont,01]					,oFont9)
		oPrint:Say(nLinha,195,aList[nCont,05]					,oFont9)
		oPrint:Say(nLinha,575,Transform(aList[nCont,02],"@E 99,999.99")							,oFont9)
		nLinha += 15
		//Impressใo analitica
		If cTipo == "ANALITICO"
			For nSub := 1 to len(aList2b)
				If aList2b[nSub,04] == aList[nCont,01]
					cPerCob := ''
					If aList2b[nSub,05] > firstday(ddatabase)
						cPerCob := 'Inicio da Cobran็a '+cvaltochar(aList2b[nSub,05])
					ElseIf aList2b[nSub,06] < lastday(ddatabase)
						cPerCob := 'Fim da Cobran็a '+cvaltochar(aList2b[nSub,06])
					EndIf
					
					If !Empty(cPerCob)
						oPrint:Say(nLinha,030,cPerCob, oFont9,,CLR_HRED)	
					EndIf
					
					oPrint:Say(nLinha,135,aList2b[nSub,01]				,oFont9)
					oPrint:Say(nLinha,195,Alltrim(aList2b[nSub,02])					,oFont9)
					oPrint:Say(nLinha,485,Transform(aList2b[nSub,03],"@E 99,999.99")							,oFont9)   
					nLinha += 15
				EndIf
			Next nSub  
			//nLinha += 15
		EndIF
			
	//IncProc()     
	Else 

		If aList[nCont,10] == cDiaAt // strzero(day(ddatabase),2)
			oPrint:Say(nLinha,025,aList[nCont,10]					,oFont9)
			oPrint:Say(nLinha,105,aList[nCont,01]					,oFont9)
			oPrint:Say(nLinha,195,aList[nCont,05]					,oFont9)
			oPrint:Say(nLinha,575,Transform(aList[nCont,02],"@E 99,999.99")							,oFont9)
			nLinha += 15	
			nTotDia += aList[nCont,02]
		EndIf
		//Impressใo analitica
		If cTipo == "ANALITICO"
			For nSub := 1 to len(aList2b)
				If aList2b[nSub,04] == aList[nCont,01]
					oPrint:Say(nLinha,135,aList2b[nSub,01]				,oFont9)
					oPrint:Say(nLinha,195,aList2b[nSub,02]					,oFont9)
					oPrint:Say(nLinha,485,Transform(aList2b[nSub,03],"@E 99,999.99")							,oFont9)   
					nLinha += 15
				EndIf
			Next nSub  
			//nLinha += 15
		EndIF

		oPrint:Say(nLinha,195,'Total dia '+cDiaAt				   						,oFont9N,,CLR_HBLUE)
		oPrint:Say(nLinha,575,Transform(nTotDia,"@E 99,999.99")							,oFont9N,,CLR_HBLUE)
	EndIf
Next nCont
 
nTotMes += nTotDia
                   

oPrint:Say(nLinha,195,'Total dia '+cDiaAt										,oFont9N,,CLR_HBLUE)
oPrint:Say(nLinha,575,Transform(nTotDia,"@E 99,999.99")							,oFont9N,,CLR_HBLUE)

nLinha+=20
                                                                                                        
oPrint:Say(nLinha,195,'Total M๊s '					   						,oFont9N,,CLR_HBLUE)
oPrint:Say(nLinha,573,Transform(nTotMes,"@E 999,999.99")						,oFont9N,,CLR_HBLUE)


oPrint:EndPage()     // Finaliza a pแgina
oPrint:Preview()                

Asort(aList,,,{|x,y| x[1] < y[1]})

Return Nil    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONFSR01  บAutor  ณMicrosiga           บ Data ณ  09/09/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Cabecalho(nPagina,cTipo)

Local aArea	:=	GetArea()
 
If nPagina > 1
	oPrint:StartPage()   	// Inicia uma nova pแgina
EndIf	

oPrint:FillRect(aCoords1,oBrush)
oPrint:FillRect(aCoords2,oBrush)
oPrint:FillRect(aCoords3,oBrush)
oPrint:FillRect(aCoords4,oBrush)
oPrint:FillRect(aCoords5,oBrush)
oPrint:FillRect(aCoords6,oBrush)
oPrint:FillRect(aCoords7,oBrush)
oPrint:FillRect(aCoords8,oBrush)
//
// LOGOTIPO
If File(aBmp2)
	oPrint:SayBitmap( 0000,0020,aBmp2,070,040 )
	oPrint:SayBitmap( 0000,0600,aBmp,040,040 )
EndIf   

oPrint:Box(0000,130,0050,530, "-4")   //Total
oPrint:Say(0020,0240,'IMPRESSรO DE PRษ-FATURAMENTO'								,oFont14N)
oPrint:Say(0035,0300,cTipo														,oFont12N)
oPrint:Say(0048,0420,'Emitido em '+cvaltochar(ddatabase)+' as '+cvaltochar(time())		,oFont7)



oPrint:Box(070,010,0730,650, "-4")   //Total

oPrint:Say(080,025,'Dia Fat.'						,oFont9)
oPrint:Say(080,105,'Contrato'						,oFont9)
oPrint:Say(080,195,'Cliente'						,oFont9)
oPrint:Say(080,580,'Valor'							,oFont9)

If cTipo == "ANALITICO"
	oPrint:Say(090,135,'Patrimonio'						,oFont9)
	oPrint:Say(090,195,'Modelo'	 						,oFont9)
	oPrint:Say(090,485,'Valor Mensal'					,oFont9)
EndIf

//oPrint:Line (0163,130,0200,130)  //linha que separa quantidade da descri็ใo

oPrint:Say(0737,0620,'Pแgina '+cvaltochar(nPagina)		,oFont7)

RestArea(aArea)

Return
