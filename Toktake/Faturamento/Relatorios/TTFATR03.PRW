#INCLUDE "RWMAKE.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE 'MSOLE.CH'
#INCLUDE 'PROTHEUS.CH'    
#INCLUDE "TopConn.ch" 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TTFATR02บAutor  ณ Artur Nucci Ferrari บ Data ณ  31/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Nota Fiscal de D้bito                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
//--- Marciane 17.09.07                                                    //
//--- Imprimir as observa็๕es do pedido de venda C5_MENNOTA E C5_F_MENSA   //
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function TTFATR03()


nLastKey 	:= 0
lEnd        := .F.
//oPrint
lFirstPage  := .T.            
         
oCouNew08	:= TFont():New("Courier New",10,10,,.T.,,,,.T.,.F.)
oCouNew08N	:= TFont():New("Courier New",10,10,,.T.,,,,.F.,.F.)		// Negrito
oCouNew12N	:= TFont():New("Courier New",12,12,,.T.,,,,.F.,.F.)		// Negrito
oCouNew11N	:= TFont():New("Courier New",11,11,,.T.,,,,.F.,.F.)		// Negrito
oCouNew14N	:= TFont():New("Courier New",14,14,,.T.,,,,.F.,.F.)		// Negrito
oCouNew11 	:= TFont():New("Courier New",11,11,,.T.,,,,.T.,.F.)
oArial10N	:= TFont():New("Arial",10,10,,.T.,,,,.F.,.F.)		// Negrito
oArial11N	:= TFont():New("Arial",11,11,,.T.,,,,.T.,.F.)		// Negrito
oArial12N	:= TFont():New("Arial",12,12,,.T.,,,,.T.,.F.)		// Negrito
oArial13N	:= TFont():New("Arial",13,13,,.T.,,,,.F.,.F.)		// Negrito
oArial14N	:= TFont():New("Arial",14,14,,.T.,,,,.F.,.F.)		// Negrito
oArial18N	:= TFont():New("Arial",18,18,,.T.,,,,.F.,.F.)		// Negrito
oArial48N	:= TFont():New("Arial",48,48,,.T.,,,,.F.,.F.)		// Negrito   
oArial12	:= TFont():New("Arial",12,12,,.F.,,,,.T.,.F.)   
oArial10	:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)		
cStartPath 	:= GetSrvProfString("Startpath","")

lEnd     := .F.
cDesc1   := "Este programa ira emitir a Nota Fiscal de Credito"
cDesc2   := ""
cDesc3   := ""
tamanho  := "G"
Limite   := 150
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }      
nomeprog := "NOTACRD"
nLastKey := 0                             
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
ntipo    := 15    
m_pag    := 1
wnrel    := "NOTACRD"      
cperg    := "NOTACRD   "  
cString	 := "SF1"
_ctitulo := titulo 	 := "Relatorio Notas de Cr้dito"

If cEmpAnt <> "01"
	Return
EndIf


AjustaSx1(cperg)

pergunte("NOTACRD   ",.f.)

wnrel    := SetPrint(cString,wnrel,cperg,titulo,cDesc1,cDesc2,cDesc3,.F.)

If nLastKey==27
 Set Filter to
 Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
 Set Filter to
 Return
Endif

nTipo:=IIF(aReturn[4]==1,15,18)

RptStatus({|lEnd| BDIMP(@lEnd,wnRel,cString)},titulo)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBDIMP  บAutor  ณSandra                 บ Data ณ  06/05/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณChamada de impressao de Notas de Debito                       ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function BDIMP

//IF PERGUNTE(CPERG,.T.)
	
oPrint := TMSPrinter():New( _ctitulo )
oPrint:SetPortrait()
Dbselectarea("SF1")
dbsetorder(1)
Dbseek(Xfilial("SF1")+MV_PAR01,.T.)

DO WHILE !EOF() .AND. SF1->F1_DOC <= MV_PAR02
	
	If (SF1->F1_SERIE <> mv_par03) .or. SF1->F1_TIPO <> 'D'
	   DbSkip()
	   Loop
	Endif	
	
	Processa({|lEnd| ImprNd()},"Imprimindo Notas de Credito "+ SF1->F1_DOC +", Aguarde...")
	
	Dbselectarea("SF1")
	
	DBSKIP()
	
ENDDO
oPrint:Preview()  				// Visualiza antes de imprimir
Return .T.




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ

ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFATR01  บAutor  ณMicrosiga           บ Data ณ  05/06/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImprNd

_mCabec1 := memoread(cStartPath+"\Cabec01."+cNumemp)
_nLinCab := MLCount(_mCabec1,80)

_mRodap1 := memoread(cStartPath+"\TxtRd01."+cNumemp)
_nLinRod := MLCount(_mRodap1,80)

_mDeposi := memoread(cStartPath+"\TxtRd02."+cNumemp)
_nLinDep := MLCount(_mDeposi,80)


Dbselectarea("SA1")
Dbsetorder(1)
Dbseek(Xfilial("SA1")+SF1->F1_FORNECE+SF2->F1_LOJA)


DBSELECTAREA("SF1")
DBSETORDER(1)
_dvenc:= {}       
_cvar := SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_PREFIXO+SF1->F2_DOC+"NCC" 
Dbselectarea("SE1")
Dbsetorder(2)
If Dbseek(Xfilial("SE1")+_cvar)
   While SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM==xfilial("SE1")+_cvar .and.!eof()
       IF ascan(_dvenc,SE1->E1_VENCTO)==0
     	  aadd(_dVenc, SE1->E1_VENCTO)
       endif	  
       DbSkip()
   Enddo  	
else
	aadd(_dVenc,ctod("  /  /  "))
endif


Dbselectarea("SD1")
Dbsetorder(3)
Dbseek(Xfilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE)

_nrec := recno()
_nLinTot := 0                        
_nDesc := 0
_MenNota1 := ''
Do while SF1->F1_FILIAL +SF1->F1_DOC+SF1->F1_SERIE == XFILIAL("SD1")+SD1->D1_DOC+SD1->D1_SERIE .and. !eof()
	
    
    _MenNota1 += SF1->F1_XMENNOT  +'/'

	_nLinTot += 1 //MLCount(Sc6->C6_txtNd,80)                           '

	dBSKIP()
	
Enddo
                                                             
If !Empty(_MenNota1)
   _nLinTot += 1
EndIf

DbGoTo(_nrec)

if int(_nLinTot/10) <> _nLinTot/10
	_nPags := round((_nLinTot/10)+.5,0)
else
	_nPags:=int(_nLinTot/10)
endif
_npagat := 1

_CabecND()

_nitem := 1
_nlinhas := 0

_totvND := 0
_totvDesc := 0  

Do while SF1->F1_DOC+SF1->F1_SERIE == SD1->D1_DOC+SD1->D1_SERIE .and. !eof()
	
/*
	dBSELECTAREA("SC5")
	DBSEEK(XFILIAL("SC5")+SD2->D2_PEDIDO)
    
    _MenNota1 := SC5->C5_MENNOTA   
*/    
    
	dBSELECTAREA("SB1")
	DBSEEK(XFILIAL("SB1")+SD1->D1_COD)
	
	
    oPrint:Say(1310+_nitem*60,0110,TRANSFORM(SD1->D1_QUANT,"@e 999,999,999.99"),oArial10N)
    oPrint:Say(1310+_nitem*60,0400,SB1->B1_DESC,oArial10N)
	oPrint:Say(1310+_nitem*60,2050,TRANSFORM(SD1->D1_TOTAL,"@e 999,999,999.99"),oArial10N)
	_cdata	 		:= substr(dtoc(SD1->D1_EMISSAO),1,2)+" de "+MesExtenso(Month(SD1->D1_EMISSAO)) + " de " + Str(Year(SD1->D1_EMISSAO), 4)
		_nitem++
		_nlinhas++
		
		if _nitem > 14 .and. _nlinhas # _nlintot
			_Rodapend(.f.)
			_nitem:=1
		    _npagat++
			_CabecND()
		endif
	
	_totvND      +=SD2->D2_TOTAL
	
	dbselectarea("SD1")
	dbskip()
	
Enddo

_RodaPeND(.t.)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFATR01  บAutor  ณMicrosiga           บ Data ณ  05/17/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function _CabecND()

oCouNew08	:= TFont():New("Courier New",10,10,,.T.,,,,.T.,.F.)
oCouNew08N	:= TFont():New("Courier New",10,10,,.T.,,,,.F.,.F.)		// Negrito
oCouNew12N	:= TFont():New("Courier New",12,12,,.T.,,,,.F.,.F.)		// Negrito
oCouNew11N	:= TFont():New("Courier New",11,11,,.T.,,,,.F.,.F.)		// Negrito
oCouNew14N	:= TFont():New("Courier New",14,14,,.T.,,,,.F.,.F.)		// Negrito
oCouNew11 	:= TFont():New("Courier New",11,11,,.T.,,,,.T.,.F.)
oArial10N	:= TFont():New("Arial",10,10,,.T.,,,,.F.,.F.)		// Negrito
oArial11N	:= TFont():New("Arial",11,11,,.T.,,,,.T.,.F.)		// Negrito
oArial12N	:= TFont():New("Arial",12,12,,.T.,,,,.T.,.F.)		// Negrito
oArial13N	:= TFont():New("Arial",13,13,,.T.,,,,.F.,.F.)		// Negrito
oArial14N	:= TFont():New("Arial",14,14,,.T.,,,,.F.,.F.)		// Negrito
oArial18N	:= TFont():New("Arial",18,18,,.T.,,,,.F.,.F.)		// Negrito
oArial48N	:= TFont():New("Arial",48,48,,.T.,,,,.F.,.F.)		// Negrito
oArial12	:= TFont():New("Arial",12,12,,.F.,,,,.T.,.F.)   
oArial10	:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)		
	

oPrint:StartPage() 		// IniciaO  uma nova pagina

 
oPrint:Box(100,100,700,2295 )
 

If cEmpAnt == "01"
   oPrint:SayBitmap(200,135,cStartPath+"\TI.BMP",320,430) //230,040)  // 474,117
EndIf

For _nCount:=1 to _nLinCab
	oPrint:Say(70+_nCount*50,1520,MemoLine(_mCabec1,80,_nCount),oArial10N)
Next a


// nome da empresa                                                         
oPrint:Say(200,600,alltrim(SM0->M0_NOMECOM),oArial12N)
oPrint:Say(300,500,SM0->M0_ENDCOB,oArial12)   
oPrint:Say(300,1750,"NOTA DE CRษDITO",oArial12N)                                          
oPrint:Say(400,500,substr(SM0->M0_CEPCOB,1,5)+'-'+substr(SM0->M0_CEPCOB,6,3) + '     ' + SM0->M0_CIDCOB + ' ' + SM0->M0_ESTCOB,oArial12)                 
oPrint:Say(400,1800,Alltrim(SF1->F1_SERIE)+" "+SF1->F1_DOC,oArial14N)
oPrint:Say(500,500,'Tel: ' + SM0->M0_TEL + ' Fax ' + SM0->M0_FAX,oArial12)    
oPrint:Say(600,500,'CNPJ - No. ' + SM0->M0_CGC + '  IE '  + SM0->M0_INSC,oArial12)                              
//                       

// dados do cliente                        
oPrint:Box(0720,100,1200,2295 )
oPrint:Say(0750,110,'Razใo Social',oArial10N)
oPrint:Say(0750,1000,'CNPJ/CPF',oArial10N)
oPrint:Say(0800,110,SA1->A1_NOME,oArial10)
oPrint:Say(0800,1000,Transform(SA1->A1_CGC,PesqPict("SA1","A1_CGC")),oArial10)
oPrint:Say(0900,110,'Endere็o',oArial10N)
oPrint:Say(0900,1000,'Inscri็ใo Estadual',oArial10N)
oPrint:Say(0950,110,SA1->A1_END,oArial10)
oPrint:Say(0950,1000,SA1->A1_INSCR,oArial10)
oPrint:Say(1050,110,'Bairro',oArial10N)
oPrint:Say(1050,550,'Municipio',oArial10N)  
oPrint:Say(1050,900,'UF',oArial10N)    
oPrint:Say(1050,1050,'CEP',oArial10N)
oPrint:Say(1100,110,SA1->A1_BAIRRO,oArial10)
oPrint:Say(1100,550,SA1->A1_MUN,oArial10)
oPrint:Say(1100,900,SA1->A1_EST,oArial10)
oPrint:Say(1100,1050,substr(SA1->A1_CEP,1,5)+'-'+substr(SA1->A1_CEP,6,3),oArial10)
//                   

oPrint:Box(1210,0100,1300,0360)
oPrint:Say(1230,0110,"QUANTIDADE",oArial12N) 
oPrint:Box(1210,0370,1300,1870)
oPrint:Say(1230,0390,"DESCRIวรO DOS GASTOS",oArial12N)
oPrint:Box(1210,1880,1300,2295)
oPrint:Say(1230,2040,"VALOR R$",oArial12N)

oPrint:Box(1310,0100,2300,0360)        
oPrint:Box(1310,0370,2300,1870)        
oPrint:Box(1310,1880,2300,2295 )

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFATR01  บAutor  ณMicrosiga           บ Data ณ  05/17/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _RodapeNd(_lfim)

oPrint:Line(2240,0100,2240,0360)   
oPrint:Line(2240,0370,2240,1870)   
oPrint:Line(2240,1880,2240,2295)
if _lfim
	oPrint:Say(2250,1470,"TOTAL DA NOTA DE CRษDITO ",oArial10N)             
	oPrint:Say(2250,2050,TRANSFORM(_totvND,"@e 999,999,999.99"),oArial10N) 
endif  
If SF2->F2_XFINAL == '8'                                                                                              
	oPrint:Say(2300,0110,"D้bito referente เ loca็ใo de Bens M๓veis, conforme contrato entre as partes",oArial12)                                                       
endif

_aLinMen := JustificaTXT(_MenNota1,500)

For _nCount:=1 to Len(_aLinMen)
	oPrint:Say(2320+_nCount*60,110,_aLinMen[_nCount],oArial12N) 
Next _nCount

_cRecibo := JustificaTXT("Segue anexo boleto(s) para pagamento at้ o(s) dia(s): " ,90) //Int(length(_cRecibo)/90)+1	

For _nCount:=1 to Len(_cRecibo)
	oPrint:Say(2420+_nCount*60,110,_cRecibo[_nCount],oArial12) // 2320
Next _nCount

_cvenc := "VENCIMENTO(S): "
for i := 1 to len(_dvenc)
    _cvenc += "(" + str(i,2) + ")" + " " + DTOC(_dVenc[i]) + "   "
next I 
oPrint:Say(2500+_nCount*40,0110,_CVENC,oArial12) //2290

//for i := 1 to len(_dvenc)
//   oPrint:Say(2460+i*80,0110+i*60,"VENCIMENTO: "+DTOC(_dVenc[i]),oArial10n) //2290
//next

//_cdata	 		:= substr(dtoc(SD2->D2_EMISSAO),1,2)+" de "+MesExtenso(Month(SD2->D2_EMISSAO)) + " de " + Str(Year(SD2->D2_EMISSAO), 4)

oPrint:Say(2700+_nCount*60,1500,SM0->M0_CIDCOB + ', ' + _cdata,oArial12N) //2950
oPrint:Line(2990,1500,2990,2300)        
oPrint:Say(3000,1600,alltrim(SM0->M0_NOMECOM),oArial12N) 
oPrint:EndPage() 			// Inicia uma nova pagina
 _cdata:=""





Static Function AjustaSx1(_perg)
    
DbSelectArea("SX1")
DbSetOrder(1)

If !DbSeek(_Perg+"01",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := _Perg
	SX1->X1_ORDEM   := "01"
	SX1->X1_PERGUNT := "Nota de "
	SX1->X1_VARIAVL := "mv_ch1"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 9
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par01"
//    MsUnLock()
EndIf                           

If !DbSeek(_Perg+"02",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := _Perg
	SX1->X1_ORDEM   := "02"
	SX1->X1_PERGUNT := "Nota ate"
	SX1->X1_VARIAVL := "mv_ch2"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 9
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par02"
//    MsUnLock()
EndIf                           
If !DbSeek(_Perg+"03",.t.)
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := _Perg
	SX1->X1_ORDEM   := "03"
	SX1->X1_PERGUNT := "Serie   "
	SX1->X1_VARIAVL := "mv_ch3"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 3
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par03"
//    MsUnLock()
EndIf                           

Return