#INCLUDE "RWMAKE.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE 'MSOLE.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE "TopConn.ch"            

#DEFINE DMPAPER_A4
#DEFINE IMP_SPOOL 2
#DEFINE IMP_PDF	   6
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TTFATR02 บAutor  ณ Sandra             บ Data ณ  03/11/09   บฑฑ
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


User Function TTFATR02()


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
cDesc1   := "Este programa ira emitir a Nota Fiscal de Debito"
cDesc2   := ""
cDesc3   := ""
tamanho  := "G"
Limite   := 150
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "", 1 }      
nomeprog := "NOTADEB"
nLastKey := 0                             
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
ntipo    := 15    
m_pag    := 1
wnrel    := "NOTADEB"      
cperg    := "NOTADEB   "  
cString	 := "SC5"
_ctitulo := titulo 	 := "Relatorio Notas de Debito"

AjustaSx1(cperg)

pergunte("NOTADEB   ",.f.)

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
ฑฑบDesc.     ณChamada de impressao de Notas de Debito                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function BDIMP

Local lAdjustToLegacy := .F. 
Local lDisableSetup  := .T.
Local nNotaAtual	:=	MV_PAR01  
Local aArquivos		:=	{}

	
//oPrint := TMSPrinter():New( _ctitulo )  
oPrint := FWMSPrinter():New("NFD"+nNotaAtual+".rel",  IMP_PDF, lAdjustToLegacy, "C:\", lDisableSetup,,,,.F.,,,.T.)
oPrint:SetResolution(78) 
oPrint:SetPortrait()
oPrint:cPathPDF := "C:\TEMP\"

Dbselectarea("SF2")
dbsetorder(1)
Dbseek(Xfilial("SF2")+MV_PAR01,.T.)

DO WHILE !EOF() .AND. SF2->F2_DOC <= MV_PAR02
	
	If (SF2->F2_SERIE <> mv_par03) .or. SF2->F2_TIPO <> 'N'
	   DbSkip()
	   Loop
	Endif	          
	
	Aadd(aArquivos,{"C:\temp\nfd"+SF2->F2_DOC+".pdf",'Content-ID: <ID_nfd.pdf>'}) 
    Aadd(aArquivos,{"\system\logocob.jpg",'Content-ID: <ID_logocob.jpg>'})

	If SF2->F2_DOC <> nNotaAtual
		oPrint:Preview()   
		oPrint := FWMSPrinter():New("NFD"+SF2->F2_DOC+".rel",  IMP_PDF, lAdjustToLegacy, "C:\", lDisableSetup,,,,.F.,,,.T.)
		oPrint:SetResolution(78) 
		oPrint:SetPortrait()       
		oPrint:cPathPDF := "C:\TEMP\"
		nNotaAtual := SF2->F2_DOC

	EndIf
	
	Processa({|lEnd| ImprNd()},"Imprimindo Notas de Debito "+ SF2->F2_DOC +", Aguarde...")
	
	Dbselectarea("SF2")
	    //Utilizando a nova classe de email para poder anexar corretamente o email ao corpo da mensagem.
	    // ************************************************************ //
	    // 		Parametros da rotina de envio de email  			  	//
	    //																//
	    //	01 - Remetente da mensagem                                  //
	    //	02 - Destinatario do email                                  //
	    //	03 - Assunto do email                                       //
	    //	04 - Corpo da mensagem                                      //
	    //	05 - Array com arquivos a serem atachados                   //
		//			Posicao 1 - \Caminho\NomeArquivo.extensao           //
		//			Posicao 2 - Content-ID "Apelido" da imagem          //
		//	06 - Confirmacao de leitura (logico)						//
		// ************************************************************ //
		
	    U_TTMAILN('microsiga@toktake.com.br','avenancio@toktake.com.br','Nota de D้bito','Teste de nota de d้bito',aArquivos,.F.)  
	    aArquivos := {}
	
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
Dbseek(Xfilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)


DBSELECTAREA("SF2")
DBSETORDER(1)
_dvenc:= {}       
_cvar := SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_PREFIXO+SF2->F2_DOC 
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


Dbselectarea("SD2")
Dbsetorder(3)
Dbseek(Xfilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE)

_nrec := recno()
_nLinTot := 0                        
_nDesc := 0
_MenNota1 := ''
Do while SF2->F2_FILIAL +SF2->F2_DOC+SF2->F2_SERIE == XFILIAL("SD2")+SD2->D2_DOC+SD2->D2_SERIE .and. !eof()
	
	dBSELECTAREA("SC5")
	DBSEEK(XFILIAL("SC5")+SD2->D2_PEDIDO)
    
    _MenNota1 += SC5->C5_MENNOTA  +'/'

	_nLinTot += 1 //MLCount(Sc6->C6_txtNd,80)

	_nDesc += SD2->D2_DESCON                  
	
	dBSELECTAREA("SD2")
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

_nitem := 0
_nlinhas := 0

_totvND := 0
_totDesc:=0
_totvDesc := 0 
_totBruto :=0 

Do while SF2->F2_DOC+SF2->F2_SERIE == SD2->D2_DOC+SD2->D2_SERIE .and. !eof()
	
	dBSELECTAREA("SC5")
	DBSEEK(XFILIAL("SC5")+SD2->D2_PEDIDO)
    
    _MenNota1 := SC5->C5_MENNOTA   
    
	dBSELECTAREA("SC6")
	DBSEEK(XFILIAL("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV)
	
	
    oPrint:Say(375+_nitem,010,TRANSFORM(SD2->D2_QUANT,"@e 999,999,999.99"),oArial10N)
    oPrint:Say(375+_nitem,120,SC6->C6_DESCRI,oArial10N)
	oPrint:Say(375+_nitem,460,TRANSFORM(SD2->D2_TOTAL,"@e 999,999,999.99"),oArial10N)
	_cdata	 := substr(dtoc(SD2->D2_EMISSAO),1,2)+" de "+MesExtenso(Month(SD2->D2_EMISSAO)) + " de " + Str(Year(SD2->D2_EMISSAO), 4)
		_nitem+=10
		_nlinhas++
		
		if _nitem > 140 .and. _nlinhas # _nlintot
			_Rodapend(.f.)
			_nitem:=0
		    _npagat++
			_CabecND()
		endif
	
	_totvND      +=SD2->D2_TOTAL
	_totDesc	 +=SD2->D2_DESCON 
	_totBruto    :=_totBruto + (SD2->D2_TOTAL + SD2->D2_DESCON) 
	
	dbselectarea("SD2")
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
oArial11	:= TFont():New("Arial",11,11,,.F.,,,,.T.,.F.)		
oArial14	:= TFont():New("Arial",14,14,,.F.,,,,.T.,.F.)		
	
oPrint:StartPage() 		// IniciaO  uma nova pagina

oPrint:SetMargin(60,60,60,60)
oPrint:cPathPDF := "C:\Temp\"                        

oPrint:Box(000,000,175,600 )
 
If cEmpAnt == "01"
   oPrint:SayBitmap(020,010,cStartPath+"\TI.BMP",100,110) //230,040)  // 474,117
EndIf

For _nCount:=1 to _nLinCab
	//oPrint:Say(70+_nCount*50,1520,MemoLine(_mCabec1,80,_nCount),oArial10N)
	oPrint:Say(10+_nCount,010,MemoLine(_mCabec1,10,_nCount),oArial10N)
Next a


// nome da empresa                                                         
oPrint:Say(030,200,alltrim(SM0->M0_NOMECOM),oArial14N)
oPrint:Say(060,130,SM0->M0_ENDCOB,oArial14)   
oPrint:Say(060,420,"NOTA DE DษBITO",oArial14N)                                          
oPrint:Say(090,130,substr(SM0->M0_CEPCOB,1,5)+'-'+substr(SM0->M0_CEPCOB,6,3) + '     ' + Alltrim(SM0->M0_CIDCOB) + '       ' + SM0->M0_ESTCOB,oArial14)                 
oPrint:Say(090,420,Alltrim(SF2->F2_SERIE)+" "+SF2->F2_DOC,oArial18N)
oPrint:Say(120,130,'Tel: ' + SM0->M0_TEL + ' Fax ' + SM0->M0_FAX,oArial14)    
oPrint:Say(150,130,'CNPJ - No. ' + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99") + '  IE '  + Transform(SM0->M0_INSC,"@R 999.999.999.999"),oArial14)                                                    

// dados do cliente                        
oPrint:Box(0185,000,0330,600 )

oPrint:Say(0200,010,'Razใo Social',oArial11N)
oPrint:Say(0200,300,'CNPJ/CPF',oArial11N) // alterado por Fabio Sales em 16/03/2012 oPrint:Say(0750,1000,'CNPJ/CPF',oArial10N)
oPrint:Say(0210,010,SA1->A1_NOME,oArial11)
oPrint:Say(0210,300,Transform(SA1->A1_CGC,PesqPict("SA1","A1_CGC")),oArial11) // alterado por Fabio Sales em 16/03/2012 oPrint:Say(0800,1000,Transform(SA1->A1_CGC,PesqPict("SA1","A1_CGC")),oArial10)
oPrint:Say(0250,010,'Endere็o',oArial10N)
oPrint:Say(0250,300,'Inscri็ใo Estadual',oArial10N) // alterado por Fabio Sales em 16/03/2012 oPrint:Say(0900,1200,'Inscri็ใo Estadual',oArial10N)
oPrint:Say(0260,010,SA1->A1_END,oArial10)
oPrint:Say(0260,300,SA1->A1_INSCR,oArial10) // alterado por Fabio Sales em 16/03/2012 oPrint:Say(0900,1200,'Inscri็ใo Estadual',oArial10N)
oPrint:Say(0300,010,'Bairro',oArial10N)
oPrint:Say(0300,150,'Municipio',oArial10N)	// alterado por Fabio Sales em 16/03/2012 oPrint:Say(1050,550,'Municipio',oArial10N)   
oPrint:Say(0300,350,'UF',oArial10N)    	// alterado por Fabio Sales em 16/03/2012 oPrint:Say(1050,900,'UF',oArial10N)    
oPrint:Say(0300,450,'CEP',oArial10N)		// alterado por Fabio Sales em 16/03/2012 oPrint:Say(1050,1050,'CEP',oArial10N)
oPrint:Say(0310,010,SA1->A1_BAIRRO,oArial10)
oPrint:Say(0310,150,SA1->A1_MUN,oArial10)   // alterado por Fabio Sales em 16/03/2012 oPrint:Say(1100,550,SA1->A1_MUN,oArial10) 
oPrint:Say(0310,350,SA1->A1_EST,oArial10)	// alterado por Fabio Sales em 16/03/2012 oPrint:Say(1100,900,SA1->A1_EST,oArial10)
oPrint:Say(0310,450,substr(SA1->A1_CEP,1,5)+'-'+substr(SA1->A1_CEP,6,3),oArial10)// alterado por Fabio Sales em 16/03/2012 oPrint:Say(1100,1050,substr(SA1->A1_CEP,1,5)+'-'+substr(SA1->A1_CEP,6,3),oArial10)*/   

oPrint:Box(0340,000,0360,110)
oPrint:Say(0350,010,"QUANTIDADE",oArial11N)  // alterado a fonte por Fabio Sales em 15/03/2012 de oArial12N para oArial10N

oPrint:Box(0340,0115,360,450)
oPrint:Say(0350,0125,"DESCRIวรO DOS GASTOS",oArial10N)  // alterado a fonte por Fabio Sales em 15/03/2012 de oArial12N para oArial10N
oPrint:Box(0340,0455,360,600)
oPrint:Say(0350,0465,"VALOR R$",oArial10N) // alterado a fonte por Fabio Sales em 15/03/2012 de oArial12N para oArial10N

oPrint:Box(0365,000,600,110)    // alterado por Fabio Sales em 15/03/2012 oPrint:Box(1310,0100,2300,0360)
oPrint:Box(0365,115,600,450)    // alterado por Fabio Sales em 15/03/2012 oPrint:Box(1310,0370,2300,1870)
oPrint:Box(0365,455,600,600)	   // alterado por Fabio Sales em 15/03/2012 oPrint:Box(1310,1880,2300,2295)

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

oPrint:Box(605,000,625,160) // alterado por Fabio Sales em 15/03/2012 oPrint:Line(2240,0100,2240,0360)   
oPrint:Box(605,165,625,350) // alterado por Fabio Sales em 15/03/2012 oPrint:Line(2240,0370,2240,1870)   
oPrint:Box(605,355,625,600) // alterado por Fabio Sales em 15/03/2012 oPrint:Line(2240,1880,2240,2295)


if _lfim 
	oPrint:Say(620,005,"TOTAL BRUTO  =",oArial10N)             
	oPrint:Say(620,070,TRANSFORM(_totBruto,"@e 999,999,999.99"),oArial10N) 	
	oPrint:Say(620,170,"TOTAL DE DESCONTO  =",oArial10N)             
	oPrint:Say(620,255,TRANSFORM(_totDesc,"@e 999,999,999.99"),oArial10N) 
	oPrint:Say(620,360,"TOTAL DA NOTA DE DษBITO  =",oArial10N)             
	oPrint:Say(620,480,TRANSFORM(_totvND,"@e 999,999,999.99"),oArial10N)
endif         
                                                                                      
oPrint:Say(635,000,"D้bito referente เ loca็ใo de Bens M๓veis, conforme contrato entre as partes",oArial12)                                                       

_aLinMen := JustificaTXT(_MenNota1,500)

// mensagem da nota fiscal de d้bito.
clmsg:=""
clmsg2:=""
For _nCount:=1 to Len(_aLinMen)
	clmsg+=SubStr(_aLinMen[_nCount],1,105)
	clmsg2+=Rtrim(SubStr(_aLinMen[_nCount],106,105))
Next _nCount
oPrint:Say(655,000,clmsg,oArial10N)
oPrint:Say(665,000,clmsg2,oArial10N)
clmsg:=""
clmsg2:=""

_cRecibo := JustificaTXT("Segue anexo boleto(s) para pagamento at้ o(s) dia(s): " ,90) //Int(length(_cRecibo)/90)+1

For _nCount:=1 to Len(_cRecibo)
	oPrint:Say(685+_nCount,000,_cRecibo[_nCount],oArial12) // 2320
Next _nCount

_cvenc := "VENCIMENTO(S): "
_cvenc1:= ""
_cvenc2:="" // incluido por Fabio Sales em 17/02/2012 para quebra de linha caso haja mais de 5 vencimentos.
for i := 1 to len(_dvenc)                         
	&& condi็ใo incluida por Fabio Sales em 17/02/2012 para verifica็ใo da quantidade de vencimentos.
	If i < 6
    	_cvenc1 += "(" + str(i,2) + ")" + " " + DTOC(_dVenc[i]) + "   "
 	Else                                                              
 		_cvenc2 += "(" + str(i,2) + ")" + " " + DTOC(_dVenc[i]) + "   "
 	EndIf
next I
oPrint:Say(705+_nCount,000,_CVENC,oArial12N)//Incluido por Fabio Sales em 17/02/2012 para colocar em "VENCIMENTO" em negrito
oPrint:Say(705+_nCount,100,_CVENC1,oArial12) //2290
oPrint:Say(705+_nCount,000,_CVENC2,oArial12)// incluido por Fabio Sales em 17/02/2012 para imprimir apartir do 6บ vencimento.

oPrint:Say(755+_nCount,300,Trim(SM0->M0_CIDCOB) + ', ' + _cdata,oArial12N) //2950  // fabio sales incluiu a fun็ใo trim para eliminar os espa็os e acertar a impressใo no PDF em 14/02/2012
oPrint:Line(805,300,805,600)        
oPrint:Say(815+_nCount,350,alltrim(SM0->M0_NOMECOM),oArial12N) 
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
EndIf                           

Return