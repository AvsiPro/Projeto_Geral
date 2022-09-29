#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE  'TBICONN.CH'

#DEFINE DMPAPER_A4
#DEFINE IMP_SPOOL 2
#DEFINE IMP_PDF	   6

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AMCFAT01  ºAutor  ³Microsiga           º Data ³  01/13/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Imprime o pedido de vendas para separacao                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AMCFAT01

Local aPergs 	:= {}
Local dDtDe 	:= ctod(" / / ")
Local dDtAte 	:= ctod(" / / ")
Local aRet := {}
Local lRet    
      
Private	oPrint
Private aBitmap := "\SIGAADV\ITAU.BMP"
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
Private aCoords1 := {0150,1900,0550,2300}
Private aCoords2 := {0450,1050,0550,1900}
Private aCoords3 := {0710,1900,0810,2300}
Private aCoords4 := {0980,1900,1050,2300}
Private aCoords5 := {1330,1900,1400,2300}
Private aCoords6 := {2080,1900,2180,2300}     // 2000 - 2100
Private aCoords7 := {2350,1900,2420,2300}     // 2270 - 2340
Private aCoords8 := {2700,1900,2770,2300}     // 2620 - 2690
Private oBrush       
Private nlinha   := 0
Private ncoluna  := 0
Private nPagina	 :=	1       
Private nTotPag	 := 1

//PREPARE ENVIRONMENT EMPRESA "10" FILIAL "03" MODULO "FAT" TABLES "SC5"        
Private aDadosEmp    := {	AllTrim(SM0->M0_NOMECOM)                                                   ,; //[1]Nome da Empresa
							SM0->M0_ENDCOB                                                              ,; //[2]Endereço
							AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
							"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
							"PABX/FAX: "+SM0->M0_TEL                                                    ,; //[5]Telefones
							"C.N.P.J.: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+          ; //[6]
							Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
							Subs(SM0->M0_CGC,13,2)                                                     ,; //[6]CGC
							"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]I.E 
							Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                         ,; 
							Alltrim(XX8->XX8_DESCRI)												}  //[8]Nome Filial


aAdd( aPergs ,{1,"Entrega de? ",dDtDe,"@!",'.T.',,'.T.',40,.F.})   
aAdd( aPergs ,{1,"Entrega Até? ",dDtAte,"@!",'.T.',,'.T.',40,.F.})

If ParamBox(aPergs ,"Período",aRet)
	dDtDe	:=	aRet[1]
	dDtAte 	:=	aRet[2]  
	DbselectArea("SC6")
	DbSetORder(3)
	If Dbseek(xFilial("SC6")+dtos(dDtDe))
		oPrint 	:= FWMSPrinter():New("pedido"+strtran(cvaltochar(time()),":")+".rel",  IMP_PDF, lAdjustToLegacy, "", lDisableSetup,,,,.F.,,,.T.)

		oPrint:SetResolution(78) //Tamanho estipulado para a Danfe
		oPrint:SetPortrait()
		oPrint:SetPaperSize(DMPAPER_A4)
		oPrint:StartPage()   	// Inicia uma nova página
		oPrint:SetMargin(60,60,60,60)
		oPrint:cPathPDF := "C:\Temp\"
		   
		//Logotipo do banco e da AMC
		aBmp	:= "\SYSTEM\logoamc.bmp"
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
		oFont14n:= TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
		oFont15n:= TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
		oFont16 := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
		oFont16n:= TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
		oFont24 := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)
		oFont9I:Italic := .T.
		oBrush := TBrush():New("",CLR_GRAY)//4
		//
		//oPrint:StartPage()   // Inicia uma nova página
		//        
		cPedido := SC6->C6_NUM
		Cabecalho(cPedido)
	
		While !EOF() .AND. SC6->C6_ENTREG >= dDtDe .AND. SC6->C6_ENTREG <= dDtAte
			If cPedido != SC6->C6_NUM
				cPedido := SC6->C6_NUM
		    	oPrint:EndPage()
		    	oPrint:StartPage()
				Cabecalho(cPedido)
			EndIf
			Itens(cPedido)
			//Dbskip()
		EndDo          
		oPrint:Preview()     // Visualiza antes de imprimir   
	Else

	EndIF
EndIf



Return     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AMCFAT01  ºAutor  ³Microsiga           º Data ³  01/13/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Cabecalho(cPedido)               

Local aArea	:=	GetArea()
      
oPrint:Box(000,010,060,105, "-4")   //Cabeçalho    
oPrint:Box(000,105,060,505, "-4")   //Cabeçalho    
oPrint:Box(000,505,060,650, "-4")   //Cabeçalho    

// LOGOTIPO DA NOTA DE DEBITO
If File(aBmp)
	oPrint:SayBitmap( 005,0020,aBmp,070,040 )
EndIf   

oPrint:Say(0010,0230,aDadosEmp[1]								,oFont11N)
oPrint:Say(0025,0260,aDadosEmp[8]								,oFont8)
oPrint:Say(0035,0190,Alltrim(aDadosEmp[2])+" "+aDadosEmp[3]		,oFont7)
oPrint:Say(0045,0260,aDadosEmp[5]								,oFont7)
oPrint:Say(0055,0240,aDadosEmp[6]+" "+aDadosEmp[7]				,oFont7)

oPrint:Say(0010,0550,"Data: "+cvaltochar(dDataBase)				,oFont9)
oPrint:Say(0030,0520,"Pedido de Venda"							,oFont16N)
oPrint:Say(0050,0560,cPedido									,oFont11N)
                                
DbSelectArea("SC5")
DbSetorder(1)
Dbseek(xFilial("SC5")+cPedido)
                   
DbSelectArea("SA1")
DbSetORder(1)
DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
//Cliente
oPrint:Box(070,010,100,505, "-4")	 
oPrint:Box(070,505,100,650, "-4")	 
oPrint:Say(080,015,"Cliente:"			,oFont9N)
oPrint:Say(080,510,"Fone:"				,oFont9N)

oPrint:Say(090,015,SC5->C5_CLIENTE+" - "+Alltrim(SA1->A1_NOME)			,oFont11N)
oPrint:Say(090,510,SA1->A1_TEL										,oFont11N)

//Endereço
oPrint:Box(100,010,130,650, "-4") 
oPrint:Say(110,015,"Endereço de entrega:"			,oFont9N)
oPrint:Say(120,015,Alltrim(SA1->A1_END)+" - "+Alltrim(SA1->A1_BAIRRO)+" - "+Alltrim(SA1->A1_MUN)+" - "+SA1->A1_EST+" CEP "+SA1->A1_CEP			,oFont11N)
	 
//Condições
oPrint:Box(130,010,170,405, "-4")	 
oPrint:Box(130,405,170,505, "-4")	 
oPrint:Box(130,505,170,650, "-4")	 
oPrint:Say(140,015,"Condições"				,oFont9N)
oPrint:Say(150,015,Alltrim(Posicione("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG,"E4_DESCRI"))				,oFont9N)

oPrint:Say(140,415,"Data de Entrega:"		,oFont9N)
oPrint:Say(150,415,cvaltochar(SC6->C6_ENTREG)		,oFont9N)

oPrint:Say(140,515,"Pedido separado por:"	,oFont9N)

//Observação do Pedido
oPrint:Fillrect( {170,010,190,650}, oBrush, "-4")
oPrint:Box(190,010,240,650, "-4")	 
oPrint:Say(180,015,"Observações do Pedido:"	,oFont9N)
oPrint:Say(190,015,SC5->C5_MENNOTA	,oFont9N)


RestArea(aArea)

Return                    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AMCFAT01  ºAutor  ³Microsiga           º Data ³  01/13/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Itens()
                          
Local nQtdTot	:=	0
Local nVlrTot	:=	0
//Local aArea	:=	GetArea()

oPrint:Fillrect( {260,010,280,055}, oBrush, "-4")
oPrint:Fillrect( {260,055,280,125}, oBrush, "-4")
oPrint:Fillrect( {260,125,280,505}, oBrush, "-4")
oPrint:Fillrect( {260,505,280,575}, oBrush, "-4")
oPrint:Fillrect( {260,575,280,650}, oBrush, "-4")

oPrint:Line (260,055,280,055)  //linha que separa Item do codigo
oPrint:Line (260,125,280,125)  //linha que separa codigo da descrição
oPrint:Line (260,505,280,505)  //linha que separa descrição da unidade
oPrint:Line (260,575,280,575)  //linha que separa unidade da quantidade

oPrint:Say(270,015,"Item"				,oFont9N)
oPrint:Say(270,060,"Código"				,oFont9N)
oPrint:Say(270,130,"Descrição"			,oFont9N)
oPrint:Say(270,510,"Unidade"			,oFont9N)
oPrint:Say(270,580,"Quantidade"			,oFont9N)

nLinha 	:= 280
nLinha2	:= 310
 
While !EOF() .AND. SC6->C6_NUM == cPedido
	// Linha inicial dos itens 260
	oPrint:Box(nLinha,010,nLinha2,055, "-4")   //Cabeçalho    
	oPrint:Box(nLinha,055,nLinha2,125, "-4")   //Cabeçalho    
	oPrint:Box(nLinha,125,nLinha2,505, "-4")   //Cabeçalho    
	oPrint:Box(nLinha,505,nLinha2,575, "-4")   //Cabeçalho    
	oPrint:Box(nLinha,575,nLinha2,650, "-4")   //Cabeçalho 
	
	oPrint:Say(nLinha+10,020,SC6->C6_ITEM			,oFont11N)
	oPrint:Say(nLinha+10,065,SC6->C6_PRODUTO		,oFont11N)
	oPrint:Say(nLinha+10,135,SC6->C6_DESCRI			,oFont11N)
	oPrint:Say(nLinha+10,515,SC6->C6_UM				,oFont11N)
	oPrint:Say(nLinha+10,585,cvaltochar(SC6->C6_QTDVEN)			,oFont11N)
	nQtdTot += SC6->C6_QTDVEN
	nVlrTot += SC6->C6_VALOR
	nLinha += 30
	nLinha2 += 30
	Dbskip()
EndDo

oPrint:Box(nLinha,010,nLinha2+30,390, "-4")   //Cabeçalho    
oPrint:Box(nLinha,390,nLinha2+30,505, "-4")   //Cabeçalho    
oPrint:Box(nLinha,505,nLinha2+30,650, "-4")   //Cabeçalho    

oPrint:Say(nLinha+10,015,"Observação"							,oFont9N)
oPrint:Say(nLinha+10,405,"Quantidade Total:"					,oFont9N) 
oPrint:Say(nLinha+40,425,cvaltochar(nQtdTot)					,oFont11N) 

oPrint:Say(nLinha+10,520,"Valor Total do Pedido R$:"			,oFont9N)
oPrint:Say(nLinha+40,540,Transform(nVlrTot,"@E 999,999.99")		,oFont11N)


//RestArea(aArea)

Return
