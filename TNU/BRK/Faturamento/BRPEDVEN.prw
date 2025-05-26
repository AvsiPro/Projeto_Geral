#include 'protheus.ch'
#include 'parmtype.ch'
#Include "colors.ch"
#Include "FWPrintSetup.ch"
#INCLUDE "RWMAKE.CH"
#Include "TopConn.Ch"
#Include "TbiConn.Ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa      ³RELCARC2                                        º Data ³ 22/07/2017  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Descricao     ³ Impressao de Pick Lists                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Desenvolvedor ³ Natalia Perioto	     º Empresa ³ Totvs Nacoes Unidas	            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÑÊÍÍÍÍÍÍËÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Linguagem     ³ eAdvpl     º Versao ³ 12    º Sistema ³ Microsiga                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Modulo(s)     ³ SIGAFAT                                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Tabela(s)     ³ SC5 SC6 SC9                                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Observacao    ³                                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

user function BRPEDVEN(cNF,cSer)


LOCAL oFont8
LOCAL oFont11c
LOCAL oFont10
LOCAL oFont14
LOCAL oFont16n
LOCAL oFont15
LOCAL oFont14n
LOCAL oFont24
Local lCred := .f.
Local lEst  := .f.
Local lImp := .T.
Local lFat := .F.
Local cObs := ""
Local cArq := ""
Local nTotal := 0

Private oPrint

//-- Fontes para Tela
Private oFont1 := TFont():New("Courier New",,012,,.F.,,,,,.F.,.F.)
Private oFont2 := TFont():New("Courier New",,012,,.F.,,,,,.F.,.F.)
Private oFont2n := TFont():New("Courier New",,012,,.T.,,,,,.F.,.F.)

//-- Fontes para Impressao
Private oFont6   	:= TFont():New("Courier New",9, 6,.T.,.F.,5,.T.,5,.F.,.F.)
Private oFont7   	:= TFont():New("Courier New",9, 7,.T.,.F.,5,.T.,5,.F.,.F.)
Private oFont8   	:= TFont():New("Courier New",9, 8,.T.,.F.,5,.T.,5,.F.,.F.)
Private oFont8n  	:= TFont():New("Courier New",9, 8,.T.,.T.,5,.T.,5,.F.,.F.)
Private oFont10  	:= TFont():New("Courier New",9,10,.T.,.F.,5,.T.,5,.F.,.F.)
Private oFont10n 	:= TFont():New("Courier New",9,10,.T.,.T.,5,.T.,5,.F.,.F.)
Private oFont11  	:= TFont():New("Courier New",9,11,.T.,.F.,5,.T.,5,.F.,.F.)
Private oFont11n 	:= TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.F.,.F.)
Private oFont12  	:= TFont():New("Courier New",9,12,.T.,.F.,5,.T.,5,.F.,.F.)
Private oFont12n 	:= TFont():New("Courier New",9,12,.T.,.T.,5,.T.,5,.F.,.F.)
Private oFont14 	:= TFont():New("Courier New",9,14,.T.,.F.,5,.T.,5,.F.,.F.)
Private oFont14n    := TFont():New("Courier New",9,14,.T.,.T.,5,.T.,5,.F.,.F.)
Private oFont15 	:= TFont():New("Courier New",9,15,.T.,.F.,5,.T.,5,.F.,.F.)
Private oFont15n 	:= TFont():New("Courier New",9,15,.T.,.T.,5,.T.,5,.F.,.F.)
Private oFont16  	:= TFont():New("Courier New",9,16,.T.,.F.,5,.T.,5,.F.,.F.)
Private oFont16n 	:= TFont():New("Courier New",9,16,.T.,.T.,5,.T.,5,.F.,.F.)
Private oFont20  	:= TFont():New("Courier New",9,20,.T.,.T.,5,.T.,5,.F.,.F.)
Private oFont21  	:= TFont():New("Courier New",9,21,.T.,.T.,5,.T.,5,.F.,.F.)
Private oFont24  	:= TFont():New("Courier New",9,24,.T.,.T.,5,.T.,5,.F.,.F.)

Private oFontTit	:= oFont11n
Private oFontTxt	:= oFont8
Private oFontTxtn	:= oFont10n
Private oFontIte	:= oFont8
Private oFontItep	:= oFont7

//Private cPath		:= GetSrvProfString('Startpath','')
Private cPath 		:= GetMV("MV_XBOLITAU")

/*If !ExistDir("C:\temp\")
	MontaDir("C:\temp\")
EndIf*/

xNf	:= cNF
xSer := cSer


If Select("TPitens") > 0 		
	DbselectArea("TPitens")
	DbCloseArea()
Endif


_cArqRel	:= "Mapa_"+alltrim(xNf) + ".REL"
_cArquivo	:= "Mapa_"+alltrim(xNf)

If File( cPath + "\" + _cArquivo )
	fErase( cPath + "\" + _cArquivo )
Endif

oPrint := FwMSPrinter():New(_cArquivo, 2,.F., cPath, .T., .F., ,"PDF",.T.,.T.,.F.,.F.,) 

//oPrint := FwMSPrinter():New(_cArquivo,6,.F.,,.T.)

oPrint:SetResolution(72)			// Default
oPrint:SetPortrait() 				// SetLandscape() ou SetPortrait()
oPrint:SetPaperSize(9)				// A4 210mm x 297mm  620 x 876
oPrint:SetMargin(10,10,10,10)		// < nLeft>, < nTop>, < nRight>, < nBottom>
oPrint:cPathPDF:= cPath
//oPrint:SetViewPdf(.f.)


If Select("TPitens") > 0 
	DbselectArea("TPitens")
	DbCloseArea()
Endif
		 
		
_cQuery	:= "select SB1.B1_DESC,    "
_cQuery	+= "       SD2.D2_PEDIDO,  "
_cQuery	+= "       SD2.D2_ITEM,    "
_cQuery	+= "       SD2.D2_COD,     "
_cQuery	+= "       SD2.D2_QUANT,   "
_cQuery	+= "       SD2.D2_PRCVEN,  "
_cQuery	+= "       SD2.D2_TOTAL,   "
_cQuery	+= "       SD2.D2_CLIENTE, "
_cQuery	+= "       SD2.D2_LOJA ,   "
_cQuery	+= "       SD2.D2_EMISSAO, "
_cQuery	+= "       SD2.D2_DOC,     "
_cQuery	+= "       SD2.D2_SERIE,    "
_cQuery	+= "       SC5.C5_MENNOTA    "
_cQuery	+= "  from "+retSqlName("SD2")+" SD2, "+retSqlName("SB1")+" SB1, "+retSqlName("SC5")+" SC5 "
_cQuery	+= " where SD2.D2_FILIAL='"+xFilial("SD2")+"' and SD2.D2_DOC='"+xNf+"' and SD2.D2_SERIE='"+xSer+"' and SD2.D_E_L_E_T_=' '"
_cQuery	+= "   and SC5.C5_FILIAL = '"+xFilial("SC5")+"' and SC5.C5_NUM = SD2.D2_PEDIDO and SC5.D_E_L_E_T_=' '"
_cQuery	+= "   and SB1.B1_COD = SD2.D2_COD and SB1.D_E_L_E_T_=' '"
_cQuery	+= " order by SD2.D2_ITEM"

TcQuery _cQuery New Alias "TPitens"
		
oPrint:StartPage()   	// Inicia uma nova página
nPg := 1
			
SA1->(DbSetOrder(1))
SA1->(DbSeek(xFilial("SA1")+TPitens->D2_CLIENTE+TPitens->D2_LOJA))
			
			
xArqLogo	:= "LGMID.png"
oPrint:Say  (0030,0260,"MAPA DE FATURAMENTO",oFont16n )
oPrint:SayBitmap(0010,00008,cPath+xArqLogo,100,020)
		
oPrint:Say  (0100,0020,"NOTA Nº: " + Alltrim(TPitens->D2_DOC),oFont12 )
oPrint:Say  (0100,0300,"DATA: " + substr(TPitens->D2_EMISSAO,7,2) + "/" + substr(TPitens->D2_EMISSAO,5,2) + "/" + substr(TPitens->D2_EMISSAO,1,4),oFont12 )

			
oPrint:Say  (0140,0020,"Cliente: " + Alltrim(SA1->A1_NOME) + " ( " +Alltrim(SA1->A1_COD) + " )" ,oFont10 )
oPrint:Say  (0150,0020,"CNPJ: " + transform(SA1->A1_CGC,"@E 99.999.999/9999-99") + " I.E.: " + SA1->A1_INSCR ,oFont10 )
			
oPrint:Line (0190,0020,0190,0580,CLR_BLACK, "-2")
oPrint:Say  (0200,0020,"It"  ,oFont10n )
oPrint:Say  (0200,0050,"Codigo"  ,oFont10n )
oPrint:Say  (0200,0130,"Descrição"  ,oFont10n )
oPrint:Say  (0200,0330,"Qtd"  ,oFont10n )
oPrint:Say  (0200,0400,"Vlr. Unit"  ,oFont10n )
oPrint:Say  (0200,0470,"Total"  ,oFont10n )
oPrint:Say  (0200,0550,"Pedido"  ,oFont10n )
			
			
xLinha := 210
TPitens->(DbGotop())
Do While TPitens->( !Eof() )

	cObs += Alltrim(TPitens->C5_MENNOTA)
	oPrint:Say  (xLinha,0020,Alltrim(TPitens->D2_ITEM)    ,oFont10 )
	oPrint:Say  (xLinha,0050,Alltrim(TPitens->D2_COD) ,oFont10 )
	oPrint:Say  (xLinha,0130,Alltrim(TPitens->B1_DESC)    ,oFont10 )
	oPrint:Say  (xLinha,0330,Alltrim(STR(TPitens->D2_QUANT))   ,oFont10 )
	oPrint:Say  (xLinha,0400,"R$ " + Alltrim(TRANSFORM(TPitens->D2_PRCVEN, "@E 999,999,999.99")),oFont10 )
	oPrint:Say  (xLinha,0470,"R$ " + Alltrim(TRANSFORM(TPitens->D2_TOTAL, "@E 999,999,999.99")),oFont10 )
	oPrint:Say  (xLinha,0550,Alltrim(TPitens->D2_PEDIDO),oFont10 )
				
	oPrint:Line (xLinha+10,0020,xLinha+10,0580,CLR_BLACK, "-2")
				
	nTotal += TPitens->D2_TOTAL			
	xLinha := xLinha + 20
				
		If xLinha >= 750
					
			xLinha := 35
			oPrint:EndPage()
			oPrint:StartPage() 
				
		Endif
				
			TPitens->(DbSkip())
Enddo
			
If Select("TPitens") > 0 
	DbselectArea("TPitens")
	DbCloseArea()
Endif

	oPrint:Say  (xLinha ,0400,"Total Geral: "+"R$ " +Alltrim(TRANSFORM(nTotal, "@E 999,999,999.99"))  ,oFont10n )			 
	
	xLinha := xLinha + 30
				
	If xLinha >= 750
						
		xLinha := 35
		oPrint:EndPage()
		oPrint:StartPage() 
					
	Endif
	
				
	oPrint:Say  (xLinha ,0020,"Observações: " ,oFont12n )
	If xLinha >= 750
						
		xLinha := 35
		oPrint:EndPage()
		oPrint:StartPage() 
					
	Endif
		oPrint:Say  (xLinha + 60,0020,Alltrim(cObs) ,oFont10 )
				
		oPrint:EndPage()

	
oPrint:Print()
File2Printer( cPath + _cArquivo + ".rel", "PDF" )	

		
If Select("TPitens") > 0 
	DbselectArea("TPitens")
	DbCloseArea()
Endif



fErase( cPath +_cArqRel )

cArq := cPath+_cArquivo + ".PDF"

return cArq

Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j,x
dbSelectArea("SX1")
dbSetOrder(1)                                                                                      

cPerg := PADR(cPerg,10)

aAdd(aRegs,{cPerg,"01","do Pedido?"     ,"","","mv_ch1","C",06,0,0 ,"G" ,""         ,"mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SC5",""})
aAdd(aRegs,{cPerg,"02","até o Pedido?"  ,"","","mv_ch2","C",06,0,0 ,"G" ,""         ,"mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SC5",""})
aAdd(aRegs,{cPerg,"03","Credito?"       ,"","","mv_ch3","C",09,0,0 ,"C" ,""         ,"mv_par03","Liberado","","","","","Bloqueado","","","","","Ambos","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Estoque?"       ,"","","mv_ch4","C",09,0,0 ,"C" ,""         ,"mv_par04","Liberado","","","","","Bloqueado","","","","","Ambos","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Considera Pedidos Faturados?"       ,"","","mv_ch5","C",03,0,0 ,"C" ,""         ,"mv_par05","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","",""})
DbSelectArea("SX1")
DbSetOrder(1)
//grava array no SX1
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Else
		For x:=1 to len(aRegs[i])
			If x<=fcount() .and. aRegs[i,x]<>&(fieldname(x))
				If !(alltrim(strzero(x,2))$'10;17;22;27;32;37')
					RecLock("SX1",.f.)
					FieldPut(x,aRegs[i,x])
					MsUnLock()
				Endif
			Endif
		Next
	Endif
Next
	
i:=len(aRegs)+1
While dbSeek(cPerg+strzero(i,2))
	RecLock("SX1",.f.)
	DbDelete()        
	MsUnLock()
	i++
End

dbSelectArea(_sAlias)
Return
