#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTTMKA11  ºAutor  ³Alexandre Venancio  º Data ³  07/02/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Geracao da OS de atendimento da OMM                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TTTMKA11()
                     
Local aArquivos := {}
Local cMsg		:= "Preparação de Máquinas do Grupo X da Omm de Nro.: "+SUC->UC_CODIGO
Local lAdjustToLegacy := .F. 
Local lDisableSetup  := .T.
Local nTotal	:= 0
Local cSisP		:=	''
Local aSisP		:=	{}
Local cDescPag	:= "" 
Local cVlr
Local cVlr2
Local aAux2		:=	{}  
Local aObLoc	:=	{} 
Local aTipL		:=	{"Gestor","Estacionamento no Local","Estacionamento Pago","Restrição Caminhão","Acompanha Kit","Forma Pagto Kit","Prazo Pagto Kit"}
Local aDtFonte		:= {}
Local dDataFonte
Local dDataOMM

Private cLogoD	:= GetSrvProfString("Startpath","") + "DANFE01.BMP" 
Private oFont0	:= TFont():New('Courier new',,-15,.T.,.F.)
Private oFont1 := TFont():New( "Courier New", , -18, .T.)
Private oFont2	:= TFont():New('Courier new',,-10,.T.,.T.)
Private oFont3	:= TFont():New('Courier new',,-08,.T.,.F.)   
Private oFont4	:= TFont():New('Courier new',,-05,.T.,.F.)
Private oFont5	:= TFont():New('Courier new',,-12,.T.,.T.)
Private oPrinter  
Private nLinha    

//Prepare Environment Empresa "01" Filial "01" Modulo "FAT" Tables "SUD" 

If cEmpAnt <> "01"
	Return
EndIf

//cSisP		:= Alltrim(GetMv("MV_XTMK010"))
//cSisP 		+= "#"+ Alltrim(GetMv("MV_XTMK011"))  
//aSisP		:= strtokarr(cSisP,"#")

aDtFonte := GetAPOInfo("TK271BOK.PRW")		// data - posicao 4
dDataFonte := CtoD("07/10/2013") //aDtFonte[4]
dDataOMM := SUC->UC_DATA

DbSelectArea("SUD")
DbSetOrder(1)
DbSeek(SUC->UC_FILIAL+SUC->UC_CODIGO)


If oPrinter == Nil
	lPreview := .T.
	oPrinter := FWMSPrinter():New("Omm.rel", 6, lAdjustToLegacy, , lDisableSetup)
	
	// Ordem obrigátoria de configuração do relatório
	oPrinter:SetResolution(72)
	oPrinter:SetPortrait()
	oPrinter:SetPaperSize(DMPAPER_A4)
	oPrinter:SetMargin(60,60,60,60) 
	// nEsquerda, nSuperior, nDireita, nInferior 
	oPrinter:cPathPDF := "\SPOOL\"     
	oPrinter:Setup()
EndIf               

oPrinter:StartPage()

cabec()

While !EOF() .AND. SUD->UD_CODIGO == SUC->UC_CODIGO

	If nLinha >= 799
		oPrinter:EndPage()
		oPrinter:StartPage()
		cabec()
	EndIf
	
	oPrinter:Say(nLinha, 15, Replicate("_", 105), oFont1)
	nLinha += 15
	
	oPrinter:Say(nLinha, 25,'Item:',oFont2)
	oPrinter:Say(nLinha, 50,SUD->UD_ITEM,oFont3)
	
	oPrinter:Say(nLinha, 305,'Nro. Patrimônio:',oFont2)
	oPrinter:Say(nLinha, 385,SUD->UD_XNPATRI,oFont3)
	 
	nLinha += 10
	
	oPrinter:Say(nLinha, 25,'Categoria:',oFont2) 
	oPrinter:Say(nLinha, 75,Posicione("SX5",1,xFilial("SX5")+'Z4'+Posicione("SB1",1,xFilial("SB1")+SUD->UD_PRODUTO,"B1_XSUBGRU"),"X5_DESCRI"),oFont3) 
	
	oPrinter:Say(nLinha, 305,'Máquina:',oFont2)
	oPrinter:Say(nLinha, 375,Posicione("SB1",1,xFilial("SB1")+SUD->UD_PRODUTO,"B1_ESPECIF"),oFont3)
	
	nLinha += 10
	
	oPrinter:Say(nLinha, 25,'Voltagem:',oFont2)
	oPrinter:Say(nLinha, 75,If(SUD->UD_XVOLT=="1","110",If(SUD->UD_XVOLT=="2","220","Não se Aplica")),oFont3)   
	
	oPrinter:Say(nLinha, 305,'Ponto Hidr.:',oFont2) 
	oPrinter:Say(nLinha, 375,If(SUD->UD_XPTHDL=="1","Sim","Não"),oFont3) 
	
	nLinha += 10                                       
	oPrinter:Say(nLinha, 25,'Sistema de Pagamento',oFont2)
	

	If dDataOMM > dDataFonte
		aSisP := StrtoKarr(SUD->UD_XMOEDA,"|")
		For nX := 1 To Len(aSisP)
			If SubStr(aSisP[nX],1,2) == "CE" .And. SubStr(aSisP[nX],4,1) == "1"
				cDescPag += "Aceitador de cédulas|"                       
			ElseIf SubStr(aSisP[nX],1,2) == "MC" .And. SubStr(aSisP[nX],4,1) == "1"
				cDescPag += "Moedeiro c/ troco|"                      
			ElseIf SubStr(aSisP[nX],1,2) == "MS" .And. SubStr(aSisP[nX],4,1) == "1"
				cDescPag += "Moedeiro s/ troco|"                       
			ElseIf SubStr(aSisP[nX],1,2) == "VR" .And. SubStr(aSisP[nX],4,1) == "1"
				cDescPag += "VR|"                       
			ElseIf SubStr(aSisP[nX],1,2) == "SM" .And. SubStr(aSisP[nX],4,1) == "1"
				cDescPag += "Smart|"                       
			ElseIf SubStr(aSisP[nX],1,2) == "PO" .And. SubStr(aSisP[nX],4,1) == "1"
				cDescPag += "POS|"
			ElseIf SubStr(aSisP[nX],1,2) == "CI" .And. SubStr(aSisP[nX],4,1) == "1"
				cDescPag += "Cartão Indutivo"
			ElseIf AllTrim(aSisP[nX]) == "GRATIS"
				cDescPag += "GRATIS"
			EndIf
		Next nX
		
		If SubStr(cDescPag, Len(cDescPag),1) == "|"
			cDescPag := SubStr(cDescPag,1,Len(cDescPag)-1)
		EndIf
	// Tratamento para OMMS criadas anteriormente a nova versao do fonte TK271BOK (mudou a forma de gravacao do campo de formas de pagamento)
	Else
		cSisP		:= Alltrim(GetMv("MV_XTMK010"))
		cSisP 		+= "#"+ Alltrim(GetMv("MV_XTMK011"))  
		aSisP		:= strtokarr(cSisP,"#")
		oPrinter:Say(nLinha, 155,aSisP[val(SUD->UD_XMOEDA)],oFont3)		
	EndIf
	
	oPrinter:Say(nLinha, 155,cDescPag,oFont3)
	
	nLinha += 10 
	// observacao do pagamento                                           
 	oPrinter:Say(nLinha, 25,'Obs de Pagamento',oFont2)
 	cObsPg := AllTrim(SUD->UD_XOBSPAG)        
	nTamObs := Len(cObsPg)
 	If nTamObs <= 80
	  	oPrinter:Say(nLinha, 155,cObsPg,oFont3) 
	Else
		nPosAtu := 1
		nFim := 80
		While nPosAtu < nTamObs 
			oPrinter:Say(nLinha, 155, SubStr(cObsPg,nPosAtu,nFim),oFont3) 
			nPosAtu += 80
			nLinha += 10
		End
	EndIf
	  	

	
	nLinha += 10
	oPrinter:Say(nLinha, 25,'Local Fisico de Instalação:',oFont2)   
	oPrinter:Say(nLinha, 155,SUD->UD_XLOCFIS,oFont3)
	
	nLinha += 10
	oPrinter:Say(nLinha, 25,'Produtos Subsidiados:',oFont2)   
	oPrinter:Say(nLinha, 155,If(SUD->UD_XSUBS=="1","Sim","Nao"),oFont3)
	
	nLinha += 10
	cTab := "" 
	If !Empty(SUD->UD_CODEXEC)
		cTab := " " +tabela(SUD->UD_CODEXEC)
	EndIf
	oPrinter:Say(nLinha, 25,'Mapa de Produtos:',oFont2)
	oPrinter:Say(nLinha, 155,Alltrim(SUD->UD_XOBSREC)+cTab,oFont2)
	
	cDescPag := ""
	
	DbSkip()             
EndDo

nLinha += 10

	If nLinha >= 799
		oPrinter:EndPage()
		oPrinter:StartPage()
		cabec()
	EndIf

oPrinter:Say(nLinha, 15, Replicate("_", 105), oFont1)

nLinha += 15

oPrinter:Say(nLinha, 200,'Observações da Omm:',oFont1) 
nLinha += 20
oPrinter:Say(nLinha, 25,'Data do Cadastro',oFont2)
oPrinter:Say(nLinha, 150,'Usuário',oFont2)
oPrinter:Say(nLinha, 250,'Histórico',oFont2)
                    
aTexto := Strtokarr(Alltrim(MSMM(StrTran( StrTran( SUC->UC_CODOBS, Chr( 13 )+cHR(10), '' ), chr(13)+Chr( 10 ), '' ) ,80)),"#")
nLinha += 20

cEnd := Alltrim(Posicione("SA1",1,xFilial("SA1")+SUC->UC_CHAVE,"A1_END")) +  " - Bairro "+Alltrim(Posicione("SA1",1,xFilial("SA1")+SUC->UC_CHAVE,"A1_BAIRRO"))+" - Mun "+Alltrim(Posicione("SA1",1,xFilial("SA1")+SUC->UC_CHAVE,"A1_MUN")) + " - Est "+Alltrim(Posicione("SA1",1,xFilial("SA1")+SUC->UC_CHAVE,"A1_EST"))
oPrinter:Say(nLinha, 25,'Endereço de Instalação - '+cEnd,oFont5)
nLinha += 10  
 
oPrinter:Say(nLinha, 15, Replicate("_", 105), oFont1)
nLinha += 10   
                                         
cCont := Alltrim(Posicione("SU5",1,xFilial("SU5")+SUC->UC_CODCONT,"U5_CONTAT"))
cFone := Alltrim(Posicione("SU5",1,xFilial("SU5")+SUC->UC_CODCONT,"U5_FONE"))

oPrinter:Say(nLinha, 25,'Contato no cliente - ' +cCont+' Fone '+cFone,oFont2)
nLinha += 10   

oPrinter:Say(nLinha, 15, Replicate("_", 105), oFont1)
nLinha += 10   
                               
DbSeek(SUC->UC_FILIAL+SUC->UC_CODIGO)

aObLoc	:=	StrtokArr(SUD->UD_XDIVLOC,"|")

If len(aObLoc) > 0
	For nX := 1 to len(aObLoc)
		aAux := StrtokArr(aObLoc[nX],";")
		//aTipL
		If len(aAux) > 1
			oPrinter:Say(nLinha, 25, aTipL[nX] + " - " + If(aAux[2]=="1","Sim",If(aAux[2]=="0","Não",aAux[2])) , oFont2)	
			nLinha += 10
		EndIf           
	Next nX
EndIf

//oPrinter:Say(nLinha, 25,'Observação na OMM - ' + Alltrim(SUD->UD_OBS),oFont2)
cObsPg := Alltrim(SUD->UD_OBS)
TamObs := Len(cObsPg)
If nTamObs <= 80
  	oPrinter:Say(nLinha, 30,cObsPg,oFont5) 
Else
	nPosAtu := 1
	nFim := 80
	While nPosAtu < nTamObs 
		oPrinter:Say(nLinha, 30, SubStr(cObsPg,nPosAtu,nFim),oFont5) 
		nPosAtu += 80
		nLinha += 10
	End
EndIf

nLinha += 10   

oPrinter:Say(nLinha, 15, Replicate("_", 105), oFont1)
nLinha += 10   

//oPrinter:EndPage()
//oPrinter:StartPage()
//cabec()
//nLinha += 20
				
While !EOF() .AND. SUD->UD_CODIGO == SUC->UC_CODIGO
    
	//If Ascan(aAux2,{|x| x[1] == SUD->UD_PRODUTO}) == 0
	
		If nLinha >= 650
			oPrinter:EndPage()
			oPrinter:StartPage()
			cabec()
		EndIf
	
		nLinha += 10
		//oPrinter:Say(nLinha, 25,Alltrim(Posicione("SB1",1,xFilial("SB1")+SUD->UD_PRODUTO,"B1_ESPECIF")),oFont2) 
		oPrinter:Say(nLinha, 275,"PE Preço subsidiado Empresa",oFont2) 
		oPrinter:Say(nLinha, 425,"PP Preço publico cobrado",oFont2) 
     	nLinha += 10
     	
		Aadd(aAux2,{SUD->UD_PRODUTO})
		oPrinter:Say(nLinha, 25,Alltrim(Posicione("SB1",1,xFilial("SB1")+SUD->UD_PRODUTO,"B1_ESPECIF")),oFont2) 
		//nLinha += 10
		
		aProd	:=	Strtokarr(SUD->UD_XDOSES,"|")  
	    
	    If dDataOMM > dDataFonte
			//pula a primeira posicao pois se trata do limite de troco
		    For nX := 2 to len(aProd)
			    nLinha += 10 
		    	aPr2 := Strtokarr(aProd[nX],";")  
		   		nCol := 25
		    	cDesc := Alltrim(Posicione("SB1",1,xFilial("SB1")+aPr2[1],"B1_ESPECIF"))
	    		cVlr  := aPr2[2]
	    		cVlr2 := aPr2[3]
		    	/*
		    	If len(aPr2) > 2
		    		cDesc := Alltrim(Posicione("SB1",1,xFilial("SB1")+aPr2[2],"B1_ESPECIF"))
		    		cVlr  := aPr2[3]
		    	Else                                                                         
			    	cDesc := Alltrim(Posicione("SB1",1,xFilial("SB1")+aPr2[1],"B1_ESPECIF"))
			    	cVlr  := aPr2[2]
			    EndIf
				*/
				//nLinha += 10          
		        
				If !Empty(alltrim(cDesc))
					oPrinter:Say(nLinha, nCol,"P"+cvaltochar(nX-1)+" - "+cDesc,oFont2)
					nCol += 300
					oPrinter:Say(nLinha, nCol,cVlr,oFont2)
			
					oPrinter:Say(nLinha, 470,cVlr2,oFont2)
				EndIf
					
			Next nX
		// Tratamento para OMMS criadas anteriormente a nova versao do fonte TK271BOK (mudou a forma de gravacao do campo de formas de pagamento)
		Else
			 For nX := 1 to len(aProd)
		    	aPr2 := Strtokarr(aProd[nX],";")  
		   		nCol := 25
		    	If len(aPr2) > 2
		    		cDesc := Alltrim(Posicione("SB1",1,xFilial("SB1")+aPr2[2],"B1_ESPECIF"))
		    		cVlr  := aPr2[3]
		    	Else                                                                         
			    	cDesc := Alltrim(Posicione("SB1",1,xFilial("SB1")+aPr2[1],"B1_ESPECIF"))
			    	cVlr  := aPr2[2]
		    	EndIf
			
				nLinha += 10          
			        
				If !Empty(alltrim(cDesc))
					oPrinter:Say(nLinha, nCol,"P"+cvaltochar(nX)+" - "+cDesc,oFont2)
					nCol += 300
					oPrinter:Say(nLinha, nCol,cVlr,oFont2)
				EndIf
				
			Next nX	
		EndIf
	//EndIf
	nLinha += 20
	Dbskip()
EndDo


oPrinter:EndPage()
oPrinter:StartPage()
cabec()
nLinha += 20		

For nX := 1 to len(aTexto)
	If len(alltrim(aTexto[nX])) > 80
		oPrinter:Say(nLinha, 25,substr(aTexto[nX],1,90),oFont5)
		nLinha += 10
		oPrinter:Say(nLinha, 45,substr(aTexto[nX],91,90-2),oFont5)
	Else                                           
		oPrinter:Say(nLinha, 25,SubStr(aTexto[nX],1,Len(aTexto[nX])-2),oFont5)
	EndIf
	nLinha += 15
Next nX

       
oPrinter:EndPage()

oPrinter:Preview()

//Aadd(aArquivos,{"\spool\Omm.pdf",'Content-ID: <ID_omm.pdf>'}) 

//U_TTMAILN('microsiga@toktake.com.br',cusername+'@toktake.com.br;avenancio@toktake.com.br','omm',cMsg,aArquivos,.F.)


FreeObj(oPrinter)  

oPrinter := Nil	  

Return       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTTMKA11  ºAutor  ³Microsiga           º Data ³  07/18/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function tabela(cod)

Local aArea	:= GetArea() 

Local cQuery := "SELECT YP_TEXTO FROM "+RetSQLName("SYP")+" WHERE YP_CHAVE='"+cod+"' AND D_E_L_E_T_='' AND UPPER(YP_TEXTO) LIKE '%ABELA%'"
Local cRet	:= ""

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTATFC05.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB") 

cRet := TRB->YP_TEXTO    

RestArea(aArea)

Return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTTMKA11  ºAutor  ³Microsiga           º Data ³  08/02/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function cabec()

Local aArea	:=	GetArea()

oPrinter:SayBitmap(025,005,cLogoD,055,056)
oPrinter:Say( 40, 60, "Preparação de Máquinas ref. Omm de Nr. "+SUC->UC_CODIGO, oFont1, 800, CLR_HRED)
oPrinter:Say( 90, 15, Replicate("_", 105), oFont1)

oPrinter:Say(105, 45,'Cliente:',oFont0)
oPrinter:Say(105, 105,Posicione("SA1",1,xFilial("SA1")+SUC->UC_CHAVE,"A1_NREDUZ"),oFont0)

oPrinter:Say(120, 45,'Fluxo',oFont0)
oPrinter:Say(120, 105,Posicione("SZ9",1,xFilial("SZ9")+SUD->UD_XTAREF,"Z9_DESC"),oFont0)

nLinha := 125  

RestArea(aArea)

Return