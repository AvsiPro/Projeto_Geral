#INCLUDE "RWMAKE.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE 'MSOLE.CH'
#INCLUDE 'PROTHEUS.CH'    
#INCLUDE "TopConn.ch" 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TOKR1702บAutor  ณ                     บ Data ณ  03/11/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TOKR1702()

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
cDesc1   := "Este programa ira emitir a conferencia do retorno e devolu็ใo"
cDesc2   := ""
cDesc3   := ""
tamanho  := "G"
Limite   := 150
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }      
nomeprog := "TKR172"
nLastKey := 0                             
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
ntipo    := 15    
m_pag    := 1
wnrel    := "TKR172"      
cperg    := "TKR172"  
cString	 := "SC5"
_ctitulo := titulo 	 := "Relat๓rio Retorno e Devolu็ใo"

pergunte("TKR172",.f.)

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
Dbselectarea("SF2")
dbsetorder(1)
Dbseek(Xfilial("SF2")+MV_PAR01,.T.)

DO WHILE !EOF() .AND. SF2->F2_DOC <= MV_PAR02
	
	If (SF2->F2_SERIE <> mv_par03) .or. SF2->F2_TIPO <> 'N'
	   DbSkip()
	   Loop
	Endif	
	
	Processa({|lEnd| ImprNd()},"Imprimindo Conferencia "+ SF2->F2_DOC +", Aguarde...")
	
	Dbselectarea("SF2")
	
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

_NumDEV	 := GetSx8Num("DEV")

Dbselectarea("SA1")
Dbsetorder(1)
Dbseek(Xfilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)


DBSELECTAREA("SF2")
DBSETORDER(1)
_cvar := SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_PREFIXO+SF2->F2_DOC 

Dbselectarea("SD2")
Dbsetorder(3)
Dbseek(Xfilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE)

_nrec := recno()
_nLinTot := 0                        
_nDesc := 0
Do while SF2->F2_FILIAL +SF2->F2_DOC+SF2->F2_SERIE == XFILIAL("SD2")+SD2->D2_DOC+SD2->D2_SERIE .and. !eof()
	
	dBSELECTAREA("SC5")
	DBSEEK(XFILIAL("SC5")+SD2->D2_PEDIDO)
    
	_nLinTot += 1 //MLCount(Sc6->C6_txtNd,80)

	_nDesc += SD2->D2_DESCON                  
	
	dBSELECTAREA("SD2")
	dBSKIP()
	
Enddo
                                                             
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

Do while SF2->F2_DOC+SF2->F2_SERIE == SD2->D2_DOC+SD2->D2_SERIE .and. !eof()
	
	dBSELECTAREA("SC5")
	DBSEEK(XFILIAL("SC5")+SD2->D2_PEDIDO)
    
    _MenNota1 := SC5->C5_MENNOTA   
    
	dBSELECTAREA("SC6")
	DBSEEK(XFILIAL("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV)
	
	oPrint:Say(700+_nitem*60,0150,SC6->C6_PRODUTO+"  "+SC6->C6_DESCRI,oArial10N)
	oPrint:Say(710+_nitem*60,0100,"___________________________________________________________________________________________________________________________________",oArial10N)
//	oPrint:Line(700+_nitem*60,0100,1222,2295)
	
		_nitem++
		_nlinhas++
		
		if _nitem > 25 .and. _nlinhas # _nlintot
			_Rodapend(.f.)
			_nitem:=1
		    _npagat++
			_CabecND()
		endif
	
	_totvND      +=SD2->D2_TOTAL
	
	dbselectarea("SD2")
	dbskip()
	
Enddo
ConfirmSX8()
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

oPrint:Box(180,100,300,2295)

For _nCount:=1 to _nLinCab
	oPrint:Say(1+_nCount*5,100,MemoLine(_mCabec1,80,_nCount),oArial10N) 
Next a

// Dados da Nota                                                         
oPrint:Say(200,0110,"RETORNO E DEVOLUวรO - Nฐ CONTROLE :",oArial14N)
oPrint:Say(200,1400,_NumDEV,oArial14N)
oPrint:Say(200,1750,"Serie: "+Alltrim(SF2->F2_SERIE)+" Nota: "+SF2->F2_DOC,oArial12N)
oPrint:Say(240,1750,"Data Emissใo:  "+DTOC(DDATABASE),oArial12N)
//                       

// dados do cliente              
oPrint:Box(300,100,300,2295)
oPrint:Say(0320,110,'Razใo Social',oArial10N)
oPrint:Say(0320,1000,'CNPJ/CPF',oArial10N)
oPrint:Say(0320,1600,'Temperatura (ฐC) do Carro',oArial10N)
oPrint:Box(0360,1590,0470,1890)
oPrint:Say(0360,110,SA1->A1_NOME,oArial10)
oPrint:Say(0360,1000,Transform(SA1->A1_CGC,PesqPict("SA1","A1_CGC")),oArial10)
oPrint:Say(0400,110,'Endere็o',oArial10N)
oPrint:Say(0400,1000,'Inscri็ใo Estadual',oArial10N)
oPrint:Say(0430,110,SA1->A1_END,oArial10)
oPrint:Say(0430,1000,SA1->A1_INSCR,oArial10)
oPrint:Say(0470,110,'Bairro',oArial10N)
oPrint:Say(0470,550,'Municipio',oArial10N)  
oPrint:Say(0470,900,'UF',oArial10N)    
oPrint:Say(0470,1050,'CEP',oArial10N)
oPrint:Say(0500,110,SA1->A1_BAIRRO,oArial10)
oPrint:Say(0500,550,SA1->A1_MUN,oArial10)
oPrint:Say(0500,900,SA1->A1_EST,oArial10)
oPrint:Say(0500,1050,substr(SA1->A1_CEP,1,5)+'-'+substr(SA1->A1_CEP,6,3),oArial10)


oPrint:Box(320,100,595,2295)
oPrint:Box(685,100,600,2295)
oPrint:Say(620,0390,"DESCRIวรO DOS PRODUTOS",oArial10N)
oPrint:Line(605,990,2500,990)
oPrint:Say(620,1000,"CONTAGEM",oArial10N)
oPrint:Line(605,1290,2500,1290)
oPrint:Say(620,1300,"RE-CONTAGEM",oArial10N)
oPrint:Line(605,1590,2500,1590)
oPrint:Say(620,1600,"DESCARTE",oArial10N)
oPrint:Line(605,1890,2500,1890)
oPrint:Say(620,1900,"DISPONอVEL",oArial10N)
oPrint:Line(605,2090,2500,2090)
oPrint:Say(620,2100,"TEMP.(ฐC)",oArial10N)
oPrint:Box(2500,100,600,2295)
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
/*/
oPrint:Line(2240,0100,2240,0360)   
oPrint:Line(2240,0370,2240,1870)   
oPrint:Line(2240,1880,2240,2295)
/*/
/*/                                                                                            
_aLinMen := JustificaTXT(_MenNota1,500)

For _nCount:=1 to Len(_aLinMen)
	oPrint:Say(130+_nCount*60,110,_aLinMen[_nCount],oArial12N) 
Next _nCount
/*/

oPrint:Line(2700,0500,2700,0500)                
oPrint:Say(2710,0200,"Responsแvel  Recebimento",oArial12N)
oPrint:Line(2700,0500,2700,0500)                
oPrint:Say(2710,900,"De Acordo do Entregador",oArial12N)
oPrint:Say(2780,900,"Contagem",oArial12N)
oPrint:Say(3000,900,"De Acordo do Entregador",oArial12N)
oPrint:Say(3070,900,"Re-Contagem",oArial12N)
oPrint:Say(2710,1600,"Controle de Qualidade",oArial12N)
oPrint:EndPage() 			// Inicia uma nova pagina
                        
Return