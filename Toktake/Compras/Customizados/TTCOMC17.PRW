#Include "TOTVS.CH"
#Include "TBICONN.CH"  
#Define pula chr(13)+chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCOMC17  บAutor  ณAlexandre Venancio  บ Data ณ  11/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Rotina responsavel pela criacao de mapa de maquinas.      บฑฑ
ฑฑบ          ณTemplates e visualizacao pelo patrimonio.                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTCOMC17(cTipChm,cPatrim,lVisual,lRecursiv,lOmm)      

Local aArea 	:= GetArea()
Local nSeletor	:=	0  
Local lGrav		:=	.F.
Local nPosAx	:=	0  
Local lRet		:=	.T.
Local lTemplate := .F. 
Local cCodCli := ""
Local cLoja := ""
Private cModelo	:=	''   
Private aMolas	:=	{}
Private oDlg,oBtn1,oBtn2,oBtn3,otMultiBtn
Private oGrp1,oGrp2,oGrp3,oGrp4,oGrp5,oGrp6,oGrp7,oGrp8,oGrp9,oGrp10
Private oGrp11,oGrp12,oGrp13,oGrp14,oGrp15,oGrp16,oGrp17,oGrp18,oGrp19,oGrp20
Private oGrp21,oGrp22,oGrp23,oGrp24,oGrp25,oGrp26,oGrp27,oGrp28,oGrp29,oGrp30
Private oGrp31,oGrp32,oGrp33,oGrp34,oGrp35,oGrp36,oGrp37,oGrp38,oGrp39,oGrp40
Private oGrp41,oGrp42,oGrp43,oGrp44,oGrp45,oGrp46,oGrp47,oGrp48,oGrp49,oGrp50
Private oGrp51,oGrp52,oGrp53,oGrp54,oGrp55,oGrp56,oGrp57,oGrp58,oGrp59,oGrp60 
Private oSay1,oSay2,oSay3,oSay4,oSay5,oSay6,oSay7,oSay8,oSay9,oSay10
Private oSay11,oSay12,oSay13,oSay14,oSay15,oSay16,oSay17,oSay18,oSay19,oSay20
Private oSay21,oSay22,oSay23,oSay24,oSay25,oSay26,oSay27,oSay28,oSay29,oSay30
Private oSay31,oSay32,oSay33,oSay34,oSay35,oSay36,oSay37,oSay38,oSay39,oSay40
Private oSay41,oSay42,oSay43,oSay44,oSay45,oSay46,oSay47,oSay48,oSay49,oSay50
Private oSay51,oSay52,oSay53,oSay54,oSay55,oSay56,oSay57,oSay58,oSay59,oSay60    
Private oLat1,oLat2,oLat3,oLat4,oLat5,oLat6,oLatA,oLatB,oLatC,oLatD,oLatE,oLatF
Private nLinha	:=	85
Private nColuna	:=	12
Private nPulo	:=	85 / 2
Private nDistan	:=	115 
Private nConta	:=	1  
Private	oFont	:= TFont():New("Verdana",,10,,.F.,,,,.T.,.F.)
Private	oFont2	:= TFont():New("Verdana",,9,,.F.,,,,.T.,.F.)
Private	oFont3	:= TFont():New("Tahoma",,15,,.T.,,,,.T.,.F.)
Private cmod	:=	''      
Private aLista	:=	{}           
Private cCod	:= ''  
Private cDesc	:= ''   
Private nTipo1	:= '' 
Private nTipo2	:= ''    
Private lCheck	:= .F.  
Private cTabela := ''

Default cTipChm	:= "Template"
Default cPatrim	:= '' 
Default lVisual := .T. 
Default lRecursiv := .F. 
Default lOmm	:= .F.
//Prepare Environment Empresa "01" Filial "01"  

If cEmpAnt <> "01"
	Return
EndIf

If lOmm
	cTabela := SUD->UD_XTABPRC                     
EndIf
If !Empty(cPatrim)
	If lOmm
		cModelo := cTipChm 
		cTipChm := 'Patrimonio '+cPatrim
	Else	
		cModelo := Posicione("SN1",2,xFilial("SN1")+cPatrim,"N1_PRODUTO")
	EndIf
	cMod 	:= Posicione("SB1",1,xFilial("SB1")+cModelo,"B1_DESC")
	If lRecursiv
		cPatrim := ''
	EndIf
Else 
	cModelo := Modelo()
	lTemplate := .T.
EndIf

If Empty(cModelo)
	Return
Else
	//ajustar para quando vier da consulta de patrimonio, omm e do proprio patrimonio.
	If Empty(cPatrim) .Or. lOmm
		//Procurar o mapa padrao cadastrado.
		Mapadefault()	       
	Else
		BuscaPatr(cPatrim)
	EndIf
EndIF

DEFINE DIALOG oDlg TITLE "Mapa de Mแquinas "+cTipChm FROM 180,180 TO 750,1075 PIXEL

	otMultiBtn := tMultiBtn():New( 00,00,'Modelo - '+Alltrim(cModelo)+' - '+Alltrim(cmod),oDlg, {|x,y| Mola(val(Str(y,2)),cModelo) },420,180,'Afastamento',0,'Mensagem',10 )
	otMultiBtn:SetFonts('Tahoma',14,'Tahoma',8)
    
	//Trazer o botao salvar somente quando for chamada pela rotina de inclusao de mapa ou omm.
	If (Empty(cPatrim) .And. lVisual) .OR. lOmm .Or. !lTemplate
		oBtn1      := TButton():New( 04,340,"Salvar",oDlg,{||oDlg:end(nSeletor:=1)},037,012,,,,.T.,,"",,,,.F. )
	EndIf
	
	oBtn2      := TButton():New( 04,380,"Sair",oDlg,{||oDlg:end(nSeletor:=0)},037,012,,,,.T.,,"",,,,.F. ) //290
	
	If !lVisual
		oBtn3      := TButton():New( 04,300,"Template",oDlg,{||U_TTCOMC17(cTipChm,cPatrim,lVisual,.T.,.F.)},037,012,,,,.T.,,"",,,,.F. ) //290
	EndIF
	
	For nX := 1 to 60
		otMultiBtn:AddButton('Mola '+strzero(nX,2))
	Next nX

	oLatA:= TSay():Create(oDlg,{||'A'},026,22,,oFont2,,,,.T.,CLR_RED,CLR_WHITE,200,20)
	oLatB:= TSay():Create(oDlg,{||'B'},033,22,,oFont2,,,,.T.,CLR_RED,CLR_WHITE,200,20)
	oLatC:= TSay():Create(oDlg,{||'C'},040,22,,oFont2,,,,.T.,CLR_RED,CLR_WHITE,200,20)
	oLatD:= TSay():Create(oDlg,{||'D'},048,22,,oFont2,,,,.T.,CLR_RED,CLR_WHITE,200,20)
	oLatE:= TSay():Create(oDlg,{||'E'},055,22,,oFont2,,,,.T.,CLR_RED,CLR_WHITE,200,20)
	oLatF:= TSay():Create(oDlg,{||'F'},063,22,,oFont2,,,,.T.,CLR_RED,CLR_WHITE,200,20)

	oGrp1      := TGroup():New( 078,008,280,442,"Configura็ใo",oDlg,CLR_BLACK,CLR_WHITE,.T.,.F. )
	
	For nY := 1 to 6
		For nX := 1 to 10                                
	       //	&("oGrp"+cvaltochar(nConta)) := TGroup():New( nLinha,nColuna,nDistan,nColuna+nPulo,"",oDlg,CLR_BLACK,CLR_WHITE,.T.,.F. )
                       // 1   2      3     4        5        6         7 8  9  10  11  12
                       //Pos Hab   Linha Coluna   Dista    Salto      Cd Qt Tp Des Say flag
			Aadd(aMolas,{nX,.T.,nLinha,nColuna,nDistan,nColuna+nPulo,'',0,'','', '', .F.})
	    	nColuna += nPulo
	    	nConta++
		Next nX     
		nLinha 	+=	30 
		nColuna	:=	12
		nPulo	:=	85 / 2
		nDistan := 	nLinha + 30 
	Next nY     
	
	oLat1:= TSay():Create(oDlg,{||'A'},95,02,,oFont3,,,,.T.,CLR_RED,CLR_WHITE,200,20)
	oLat2:= TSay():Create(oDlg,{||'B'},125,02,,oFont3,,,,.T.,CLR_RED,CLR_WHITE,200,20)
	oLat3:= TSay():Create(oDlg,{||'C'},155,02,,oFont3,,,,.T.,CLR_RED,CLR_WHITE,200,20)
	oLat4:= TSay():Create(oDlg,{||'D'},185,02,,oFont3,,,,.T.,CLR_RED,CLR_WHITE,200,20)
	oLat5:= TSay():Create(oDlg,{||'E'},215,02,,oFont3,,,,.T.,CLR_RED,CLR_WHITE,200,20)
	oLat6:= TSay():Create(oDlg,{||'F'},245,02,,oFont3,,,,.T.,CLR_RED,CLR_WHITE,200,20)

	If len(aLista) > 0
		For nTT := 1 to len(aLista)
			aMolas[val(aLista[nTT,01]),07] := aLista[nTT,02]
			cCod := aLista[nTT,02]
			aMolas[val(aLista[nTT,01]),08] := aLista[nTT,03]
			aMolas[val(aLista[nTT,01]),10] := aLista[nTT,05]    
			//Se encontrar a tabela de pre็os no patrimonio, buscar o valor do item nesta tabela
			nPreco := -1
			If !Empty(cTabela)
				nPreco := Posicione("DA1",1,xFilial("DA1")+cTabela+aLista[nTT,02],"DA1_XPRCPP")
			EndIF
			
			aMolas[val(aLista[nTT,01]),11] := cvaltochar(aLista[nTT,03])+valmola(cmodelo)+SPACE(10)+If(nPreco>=0,"R$ "+transform(nPreco,"@E 99.99"),"")+SPACE(5)+aLista[nTT,09]+pula
	
			//Se for chamado pela rotina de consulta de patrimonio entใo bloquear todos os itens para nao serem alterados
			//If !Empty(cPatrim) .And. !lOmm .And. !cUserName $ "JDEUS"
			If !Empty(cPatrim) .And. lTemplate
				aMolas[val(aLista[nTT,01]),02] := .F.// alterado TESTE
			EndIF		

			If aLista[nTT,07] == "2"
				aMolas[val(aLista[nTT,01])+1,02] := .F.
				If len(Alltrim(aLista[nTT,05])) > 30
					aMolas[val(aLista[nTT,01]),11] += substr(aLista[nTT,05],1,30)+pula
					aMolas[val(aLista[nTT,01]),11] += substr(Alltrim(aLista[nTT,05]),31)+pula
				Else	
					aMolas[val(aLista[nTT,01]),11] += Alltrim(aLista[nTT,05])+pula+pula
				EndIf
			Else     
				If len(Alltrim(aLista[nTT,05])) > 15                                          
					aMolas[val(aLista[nTT,01]),11] += substr(aLista[nTT,05],1,15)+pula
					aMolas[val(aLista[nTT,01]),11] += substr(Alltrim(aLista[nTT,05]),16)+pula
				Else	
					aMolas[val(aLista[nTT,01]),11] += Alltrim(aLista[nTT,05])+pula+pula
				EndIf
			EndIf
			
			
			aMolas[val(aLista[nTT,01]),11] += substr(Posicione("SB1",1,xFilial("SB1")+aLista[nTT,02],"B1_XFAMLIT"),1,15)
			aMolas[val(aLista[nTT,01]),12] := If(aLista[nTT,07]=="1",.F.,.T.)   
			//Carrega a mola na tela se o item do patrimonio estiver preenchido
			If !Empty(cCod)
				mola(val(aLista[nTT,01]),cModelo,.T.)
			EndIf
		Next nTT
	EndIf	

ACTIVATE DIALOG oDlg CENTERED 


If nSeletor == 1
	dbSelectArea("SN1")
	dbSetOrder(2)
	If !Empty(cPatrim)
		If MsSeek( xFilial("SN1") +AvKey(cPatrim,"N1_CHAPA") )
			cCodCli := SN1->N1_XCLIENT
			cLoja := SN1->N1_XLOJA
			If Empty(cCodCli) .Or. Empty(cLoja)
				MsgAlert("O patrimonio nใo estแ associado a nenhum cliente/loja.")
				Return
			EndIf
		EndIf
	EndIf
	lGrav := Gravar(lTemplate,cPatrim,cCodCli,cLoja)
Else
	lRet	:=	.F.
EndIf
 
RestArea(aArea)

Return(lRet)  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCOMC17  บAutor  ณMicrosiga           บ Data ณ  03/11/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Configura as molas conforme o usuario seleciona os itens  บฑฑ
ฑฑบ          ณno cabecalho da rotina.                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function mola(pos,cModelo,lInicio)

Local aArea	:=	GetArea() 
Local aAux	:=	{}
Local lFlg	:=	.F.     
Default lInicio := .F.

If !lInicio
	
	If !empty(aMolas[pos,07]) .And. aMolas[Pos,02] 
		If !MsgYesNo("Este Mola jแ esta configurada, confirma a altera็ใo?","Mola - TTCOMC17") 
			RestAreA(aArea)
			Return 
		Else
			&("oSay"+cvaltochar(pos)):settext("")
			If ValType( &( "oGrp"+cvaltochar(pos) ) ) == "O"
				FreeObj( &("oGrp"+cvaltochar(pos)) )   
			EndIf
			oDlg:refresh()  
			lFlg	:=	.T. 
		EndIf
	EndIf
         
	If aMolas[Pos,02] 
	
		aAux := PreMola(pos,lFlg,cModelo)
	
		If len(aAux) < 1
			RestArea(aArea)
			Return
		EndIf
	    //Completa o array com as informacoes do usuario
		aMolas[Pos,07] := aAux[1]
		aMolas[Pos,08] := aAux[4]
		aMolas[Pos,09] := aAux[3]
		aMolas[Pos,10] := aAux[2] 
		aMolas[Pos,12] := aAux[5]
		aMolas[Pos,11] := substr(aAux[3],1,3)+space(20)+Alltrim(aAux[6])+pula 
	    
		If aAux[5]
			
			aMolas[Pos+1,02] := .F.
			//Preenche o conteudo de dentro do Grupo
			If len(Alltrim(aAux[2])) > 30
				aMolas[Pos,11] += substr(aAux[2],1,30)+pula
				aMolas[Pos,11] += substr(Alltrim(aAux[2]),31)+pula
			Else	
				aMolas[Pos,11] += Alltrim(aAux[2])+pula+pula
			EndIf
			aMolas[Pos,11] += Alltrim(Posicione("SB1",1,xFilial("SB1")+aAux[1],"B1_XFAMLIT"))
			
			
			&("oGrp"+cvaltochar(pos)) := TGroup():New( aMolas[pos,3],aMolas[pos,4],aMolas[pos+1,5],aMolas[pos+1,6],space(10)+Alltrim(aMolas[Pos,07]),oDlg,CLR_BLACK,CLR_WHITE,.T.,.F. )
		                 // 1   2      3     4        5        6         7  8   9   10   11  12
		                 //Pos Hab   Linha Coluna   Dista    Salto      Cod Qt Tip desc say flag
			//Aadd(aMolas,{nX,.T.,nLinha,nColuna,nDistan,nColuna+nPulo,'',0,''})            \/pula 6 nlinha
			//oSay:= TSay():Create(oDlg,{||'Texto para exibi็ใo'+pula+'Sorvelito da Kibใo'},91,15,,/*ofont*/,,,,.T.,CLR_RED,CLR_WHITE,200,20)
			//																				   /\pula 3 ncoluna	     
			&("oSay"+cvaltochar(pos)) := TSay():Create(oDlg,{||aMolas[Pos,11]},aMolas[pos,3]+6,aMolas[pos,4]+3,,oFont,,,,.T.,CLR_RED,CLR_WHITE,200,23)
		Else
			If len(Alltrim(aAux[2])) > 13
				aMolas[Pos,11] += substr(aAux[2],1,13)+pula
				aMolas[Pos,11] += substr(Alltrim(aAux[2]),14,13)+pula
			Else	
				aMolas[Pos,11] += Alltrim(aAux[2])+pula+pula
			EndIf
			aMolas[Pos,11] += Alltrim(Posicione("SB1",1,xFilial("SB1")+aAux[1],"B1_XFAMLIT"))
			
			
			&("oGrp"+cvaltochar(pos)) := TGroup():New( aMolas[pos,3],aMolas[pos,4],aMolas[pos,5],aMolas[pos,6],space(5)+Alltrim(aMolas[Pos,07]),oDlg,CLR_BLACK,CLR_RED,.T.,.F. )
			
					    // 1   2      3     4        5        6         7  8   9   10   11  12
		    	        //Pos Hab   Linha Coluna   Dista    Salto      Cod Qt Tip desc say flag
			//Aadd(aMolas,{nX,.T.,nLinha,nColuna,nDistan,nColuna+nPulo,'',0,''})            \/pula 6 nlinha
			//oSay:= TSay():Create(oDlg,{||'Texto para exibi็ใo'+pula+'Sorvelito da Kibใo'},91,15,,/*ofont*/,,,,.T.,CLR_RED,CLR_WHITE,200,20)
			//																				   /\pula 3 ncoluna	     
			&("oSay"+cvaltochar(pos)) := TSay():Create(oDlg,{||aMolas[Pos,11]},aMolas[pos,3]+6,aMolas[pos,4]+3,,oFont,,,,.T.,CLR_RED,CLR_BLACK,200,23)
			//&("oSay"+cvaltochar(pos)):lTransparent := .F.
			
		EndIf
	Else 
		//Alert("Mola bloqueada")
	EndIf 
Else
	If aMolas[pos,12]
		&("oGrp"+cvaltochar(pos)) := TGroup():New( aMolas[pos,3],aMolas[pos,4],aMolas[pos+1,5],aMolas[pos+1,6],space(10)+Alltrim(aMolas[Pos,07]),oDlg,CLR_BLACK,CLR_WHITE,.T.,.F. )
	                 // 1   2      3     4        5        6         7  8   9   10   11  12
	                 //Pos Hab   Linha Coluna   Dista    Salto      Cod Qt Tip desc say flag
		//Aadd(aMolas,{nX,.T.,nLinha,nColuna,nDistan,nColuna+nPulo,'',0,''})            \/pula 6 nlinha
		//oSay:= TSay():Create(oDlg,{||'Texto para exibi็ใo'+pula+'Sorvelito da Kibใo'},91,15,,/*ofont*/,,,,.T.,CLR_RED,CLR_WHITE,200,20)
		//																				   /\pula 3 ncoluna	     
		&("oSay"+cvaltochar(pos)) := TSay():Create(oDlg,{||aMolas[Pos,11]},aMolas[pos,3]+6,aMolas[pos,4]+3,,oFont,,,,.T.,CLR_RED,CLR_WHITE,200,23)
	Else
		&("oGrp"+cvaltochar(pos)) := TGroup():New( aMolas[pos,3],aMolas[pos,4],aMolas[pos,5],aMolas[pos,6],space(5)+Alltrim(aMolas[Pos,07]),oDlg,CLR_BLACK,CLR_RED,.T.,.F. )
		
				    // 1   2      3     4        5        6         7  8   9   10   11  12
	    	        //Pos Hab   Linha Coluna   Dista    Salto      Cod Qt Tip desc say flag
		//Aadd(aMolas,{nX,.T.,nLinha,nColuna,nDistan,nColuna+nPulo,'',0,''})            \/pula 6 nlinha
		//oSay:= TSay():Create(oDlg,{||'Texto para exibi็ใo'+pula+'Sorvelito da Kibใo'},91,15,,/*ofont*/,,,,.T.,CLR_RED,CLR_WHITE,200,20)
		//																				   /\pula 3 ncoluna	     
		&("oSay"+cvaltochar(pos)) := TSay():Create(oDlg,{||aMolas[Pos,11]},aMolas[pos,3]+6,aMolas[pos,4]+3,,oFont,,,,.T.,CLR_RED,CLR_BLACK,200,23)
		//&("oSay"+cvaltochar(pos)):lTransparent := .F.
	EndIF
EndIf


RestArea(aArea)

Return                  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCOMC17  บAutor  ณMicrosiga           บ Data ณ  03/12/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PreMola(nPos,lAlt,cModelo)

Local aArea	:=	GetArea()
Local oPreM,oPGr1,oPrsay1,oPrsay2,oPrsay3,oPrsay4,oPrsay5,oPrget1,oCBox1,oPrget2,oCBox2,oPrBtn1,oPrget3
Local aRet	:=	{}
Local nOpc	:=	0
Local nQtd	:=	If(lAlt,cvaltochar(aMolas[nPos,08])+space(3-len(cvaltochar(aMolas[nPos,08]))),space(3))  
Local lPassou:= .F.
                  

cCod	:=	If(lAlt,aMolas[nPos,07],space(15))
cDesc	:=	If(lAlt,aMolas[nPos,10],'') 
lCheck	:=	If(lAlt,aMolas[nPos,12],.F.)

while !lPassou
	oPreM      := MSDialog():New( 125,473,327,837,"Informe o Produto para a Mola "+cvaltochar(nPos),,,.F.,,,,,,.T.,,,.T. )
	
	oPGr1      := TGroup():New( 004,004,080,172,"",oPreM,CLR_BLACK,CLR_WHITE,.T.,.F. )
	
		oPrsay1      := TSay():New( 012,032,{||"C๓digo"},oPGr1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)  
		oPrget1      := TGet():New( 012,084,{|u| If(Pcount()>0,cCod:=u,cCod)},oPGr1,060,008,'@!',{|| valmola(cModelo)  },CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","",,)
		oPrsay2      := TSay():New( 024,032,{||cDesc},oPGr1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,112,008)
	
		oPrsay3      := TSay():New( 036,032,{||"Tipo Mola"},oPGr1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oPrget3      := TGet():New( 036,084,{|u| If(Pcount()>0,nTipo2:=u,nTipo2)},oPGr1,060,008,'',{||},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","",,)
		oPrget3:disable()
		
		oPrsay4      := TSay():New( 054,032,{||"Quantidade"},oPGr1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oPrget2      := TGet():New( 054,084,{|u| If(Pcount()>0,nQtd:=u,nQtd)},oPGr1,060,008,'',{||},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	
		oPrsay5      := TSay():New( 068,032,{||"Mola Dupla?"},oPGr1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oCBox2     := TCheckBox():New( 068,084,"Sim",{|u|If(Pcount()>0,lCheck:=u,lCheck)},oPGr1,048,008,,{||lCheck:=checar(lCheck,lAlt,nPos)},,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	    oCBox2:disable()
	                                                                                                           
    oPrBtx      := TButton():New( 084,001,"Excluir",oPreM,{||oPreM:end(nOpc:=2)},024,008,,,,.T.,,"",,,,.F. )
	oPrBtn1      := TButton():New( 084,048,"Confirmar",oPreM,{||oPreM:end(nOpc:=1)},024,008,,,,.T.,,"",,,,.F. )
	oPrBtn2      := TButton():New( 084,097,"Cancelar",oPreM,{||oPreM:end(nOpc:=0)},024,008,,,,.T.,,"",,,,.F. )
	
	
	oPreM:Activate(,,,.T.)
	
	// confirmar
	If nOpc == 1 
		If xvalidm(lAlt,nPos)
			If Alltrim(cCod) == "CORINGA"
				aRet := {cCod,"CORINGA",'1',0,lCheck,Alltrim(Posicione("SX5",1,xFilial("SX5")+'ZT'+Posicione("SB1",1,xFilial("SB1")+cCod,"B1_XPREPAR"),"X5_DESCRI"))}
			Else 
				If valtype(nQtd) == "C"
					nQtd := val(nQtd)
				EndIf	
				aRet := {cCod,cDesc,Alltrim(cvaltochar(nQtd))+Alltrim(nTipo1),nQtd,lCheck,Alltrim(Posicione("SX5",1,xFilial("SX5")+'ZT'+Posicione("SB1",1,xFilial("SB1")+cCod,"B1_XPREPAR"),"X5_DESCRI"))}
			EndIf
			lPassou := .T.
		EndIf
	// exclusao
	ElseIf nOpc == 2
		aMolas[nPos][7] := ""
		aMolas[nPos][8] := 0
		aMolas[nPos][10] := ""
		aMolas[nPos][11] := ""
		lPassou := .T.
	Else 
		exit
	EndIf 
EndDo

RestArea(aArea)

Return(aRet)  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCOMC17  บAutor  ณMicrosiga           บ Data ณ  04/02/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function valmola(cModelo)

Local aArea	:=	GetArea()  
Local aMdM	:=	{'G=P','D=S'} 
Local aAux	:=	{}
Local nPosa	:=	0

DbSelectArea("SB1")
DbSetOrdeR(1)
If DbSeek(xFilial("SB1")+cModelo)                   
	nTipo1 := Alltrim(Posicione("SX5",1,xFilial("SX5")+'ZZ'+SB1->B1_XMOLA,"X5_DESCRI"))
	If substr(nTipo1,1,5) $ 'GRANDE/DUPLA'
		lCheck := .T.
	EndIf
EndIf    

If DbSeek(xFilial("SB1")+cCod)                   
	nTipo2 := Alltrim(Posicione("SX5",1,xFilial("SX5")+'ZZ'+SB1->B1_XMOLA,"X5_DESCRI"))
	If substr(nTipo2,1,5) $ 'GRANDE/DUPLA'
		lCheck := .T.
	else
		lCheck := .F.
	EndIf
EndIf  
          
aAux := strtokarr(nTipo2,"/")

nPosa := Ascan(aMdM,{|x| x = substr(nTipo1,1,1)})

If nPosa > 0
	If !lCheck
		nTipo1 := substr(aMdM[nPosa],3,1)   
	Else
		nTipo1 := substr(aMdM[nPosa],1,1)   
	EndIf
EndIf

If !Empty(cCod) .And. cCod<>'CORINGA'
	cDesc := Posicione("SB1",1,xFilial("SB1")+cCod,"B1_DESC")
else
	cDesc := ''
Endif

RestArea(aArea)

Return(nTipo1)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCOMC17  บAutor  ณMicrosiga           บ Data ณ  03/13/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function checar(lOp1,lOp2,nPos)

Local aArea :=	GetArea()
Local lRet	:=	.T.

If lOp1
	If nPos % 10 == 0
		MsgAlert("Esta mola nใo pode ser dupla, por se tratar da ultima mola da prateleira","checar - TTCOMC17")
		lRet := .F.
	EndIf

	If !Empty(aMolas[nPos+1,07]) .And. lRet
		Msgalert("Esta mola nใo poderแ ser dupla, pois a pr๓xima mola jแ esta ocupada, verifique!","chechar - TTCOMC17")
		lRet := .F.
	EndIf
	
EndIf

RestArea(aArea)

Return(lRet)                         

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCOMC17  บAutor  ณMicrosiga           บ Data ณ  03/16/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Modelo()

Local aArea		:=	GetArea()
Local cRetorno	:=	space(15) 
Local lSair		:=	.F.           

While !lSair
	
	SetPrvt("oModelo1","oGrupoM1","oSayM1","oSaym2","oGetM1","oBtnM1","oBtnM2")
	
	oModelo1   	:= MSDialog():New( 091,232,277,573,"Modelo da Mแquina",,,.F.,,,,,,.T.,,,.T. )
	
	oGrupoM1	:= TGroup():New( 008,008,068,156,"Informe o modelo para configura็ใo",oModelo1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		
		oSayM1      := TSay():New( 028,032,{||"Modelo"},oGrupoM1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
		oGetM1      := TGet():New( 028,060,{|u|If(PCount()>0,cRetorno:=u,cRetorno)},oGrupoM1,060,008,'@!',{||If(!empty(cRetorno),cmod:=Posicione("SB1",1,xFilial("SB1")+cRetorno,"B1_ESPECIF"),cmod:='')},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","",,)
		
		oSaym2      := TSay():New( 048,016,{||cmod},oGrupoM1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,128,008)
	
	oBtnM1      := TButton():New( 072,036,"Confirmar",oModelo1,{||oModelo1:end(nMod:=1)},036,008,,,,.T.,,"",,,,.F. )
	oBtnM2      := TButton():New( 072,086,"Cancelar",oModelo1,{||oModelo1:end(nMod:=0)},036,008,,,,.T.,,"",,,,.F. )
	
	oModelo1:Activate(,,,.T.) 
	
	If nMod == 1 
		If Posicione("SB1",1,xFilial("SB1")+cRetorno,"B1_XSECAO") != "026"
			Msgalert("Somente produtos do tipo mแquina podem ser utilizados para realizar o cadastro de mapa de produtos","Modelo - TTCOMC17")
			cmod := ''
		Else
			lSair := .T.
		EndIf
	Else
		cRetorno := space(15)
		cmod := ''
		lSair := .T.
	EndIf
enddo

RestArea(aArea)

Return(cRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCOMC17  บAutor  ณMicrosiga           บ Data ณ  04/02/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Grava as informacoes digitadas pelo usuario na tabela AA6 บฑฑ
ฑฑบ          ณKit de atendimento X tipo de maquina.                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Gravar(lTemplate,cPatrim,cCodCli,cLoja)

Local aArea		:=	GetArea()
Local lRet		:=	.T.
Local cQuery
Local cPrdAnt	:=	''
Local cRg		:=	0
Default lTemplate	:= .F.
Default cCodCli	:= ""
Default cLoja	:= ""


                              
If lTemplate
	For nTw := 1 to len(aMolas)
		If !Empty(aMolas[nTw,07]) 
			cQuery := "SELECT AA6_PRODUT AS PRODUTO,R_E_C_N_O_ AS REGISTRO FROM "+RetSQLName("AA6")
			cQuery += " WHERE AA6_FILIAL='"+xFilial("AA6")+"' AND AA6_CODPRO='"+cModelo+"' AND AA6_CODPRB='000013' AND AA6_ITEM='"+strzero(nTw,2)+"' AND D_E_L_E_T_=''"
			
			If Select("TRB") > 0
				dbSelectArea("TRB")
				dbCloseArea()
			EndIf
			  
			MemoWrite("TTAUDR01.SQL",cQuery)
			
			cQuery:= ChangeQuery(cQuery)
			DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
			
			DbSelectArea("TRB")
			cRg := 0
			If !EMPTY(TRB->PRODUTO)
				cPrdAnt := TRB->PRODUTO
				cRg		:= TRB->REGISTRO	
				If Alltrim(cPrdAnt) != Alltrim(aMolas[nTw,07])
					//gravar log da transa็ใo de troca de produto na log na rotina ttgenc01
				EndIf
			EndIf                                                                      
			
			
			DbSelectArea("AA6")
			//DbSetOrder(1)	     
			//AA6_FILIAL+AA6_CODPRO+AA6_CODPRB+AA6_ITEM     
			If cRg <> 0
				Dbgoto(cRg)
				Reclock("AA6",.F.)
			Else
				Reclock("AA6",.T.)
				AA6->AA6_CODPRO	:=	cModelo
				AA6->AA6_CODPRB	:=	'000013'
				AA6->AA6_ITEM	:=	strzero(nTw,2)
			EndIf
			
			AA6->AA6_PRODUT	:=	aMolas[nTw,07]
			AA6->AA6_QUANT	:=	If(Valtype(aMolas[nTw,08])=="C",val(aMolas[nTw,08]),aMolas[nTw,08])
			AA6->AA6_XMOLA	:=	cvaltochar(nTw)
			AA6->AA6_XDUPLA	:=	If(aMolas[nTw,12],'2','1')
	        AA6->(Msunlock())
		EndIf	
	Next nTw 
Else    
	//Atualiza o patrimonio com o mapa
	DbSelectArea("SN1")
	DbSetOrder(2)
	MSSeek(xFilial("SN1")+AvKey(cPatrim,"N1_CHAPA"))
	Reclock("SN1",.F.)
	For nTw := 1 to len(aMolas)                          
		//If !Empty(aMolas[nTw,07])
			&("SN1->N1_XP"+cvaltochar(nTw)) := aMolas[nTw,07]	
		//EndIf
	Next nTw 
	SN1->(Msunlock())
	
	DbSelectArea("SZH")
	DbSetOrder(1)
            // 1   2      3     4        5        6         7  8   9   10   11  12
            //Pos Hab   Linha Coluna   Dista    Salto      Cod Qt Tip desc say flag
			//Aadd(aMolas,{nX,.T.,nLinha,nColuna,nDistan,nColuna+nPulo,'',0,''})            \/pula 6 nlinha
	For nTw := 1 to len(aMolas)
		//If !Empty(aMolas[nTw,07])
			If MSSeek( xFilial("SZH") +AvKey(cPatrim,"ZH_CHAPA") +AvKey(cCodCli,"ZH_CLIENTE") +AvKey(cLoja,"ZH_LOJA") + Alltrim(AvKey(cvaltochar(nTw),"ZH_MOLA")) )
				Reclock("SZH",.F.)
			Else
				Reclock("SZH",.T.)
			EndIf

			SZH->ZH_CHAPA	:=	cPatrim	
			SZH->ZH_CODMAQ	:=	cModelo
			SZH->ZH_CODPROD	:=	aMolas[nTw,07]
			SZH->ZH_QUANT	:=	aMolas[nTw,08]
			SZH->ZH_MOLA	:=	cvaltochar(nTw)
			SZH->ZH_TIPOMOL	:=	aLista[aScan(aLista,{|x| x[1] = cvaltochar(nTw)}),7]
			SZH->ZH_CLIENTE	:=	cCodCli //Substr(SUC->UC_CHAVE,1,6)
			SZH->ZH_LOJA	:=	cLoja //Substr(SUC->UC_CHAVE,7,4) 
			
			SZH->(Msunlock())
		//EndIf
	Next nTw
EndIf

RestArea(aArea)

Return(lRet)                    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCOMC17  บAutor  ณMicrosiga           บ Data ณ  04/02/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Mapadefault()

Local aArea		:=	GetArea()
Local cQuery               

cQuery := "SELECT AA6_PRODUT,AA6_QUANT,AA6_XMOLA,AA6_XDUPLA,B1_DESC,B1_XPREPAR FROM "+RetSQLName("AA6")+" A6" 
cQuery += " LEFT JOIN " +RetSqlName("SB1") +" B1 ON B1_COD=AA6_PRODUT AND B1.D_E_L_E_T_=''"
cQuery += " WHERE AA6_FILIAL='"+xFilial("AA6")+"' AND AA6_CODPRO='"+cModelo+"' AND AA6_CODPRB='000013' AND A6.D_E_L_E_T_='' ORDER BY AA6_ITEM"

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTAUDR01.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")
                       // 1   2      3     4        5        6         7 8  9  10  11  12
                       //Pos Hab   Linha Coluna   Dista    Salto      Cd Qt Tp Des Say flag
While !EOF()                      
	nTipo1 := Alltrim(Posicione("SX5",1,xFilial("SX5")+'ZZ'+TRB->AA6_PRODUT,"X5_DESCRI"))
    Aadd(aLista,{TRB->AA6_XMOLA,TRB->AA6_PRODUT,TRB->AA6_QUANT,'',Alltrim(TRB->B1_DESC),'',TRB->AA6_XDUPLA,nTipo1,Alltrim(Posicione("SX5",1,xFilial("SX5")+'ZT'+TRB->B1_XPREPAR,"X5_DESCRI"))})
	DbSkip()
EndDo

RestArea(aArea)

Return
            
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCOMC17  บAutor  ณMicrosiga           บ Data ณ  05/16/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Busca os produtos do patrimonio informado                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function BuscaPatr(cPatrim)

Local aArea	:=	GetArea()
Local cQuery               
Local nCont :=  1 
Local cProd := ""
Local cMola := ""
Local nTipo1 := 0
                 
While nCont < 61
	cQuery := "SELECT N1_XP"+cvaltochar(nCont)+",B1_DESC,N1_XTABELA,ZH_TIPOMOL,ZH_QUANT"
	cQuery += " FROM "+RetSQLName("SN1")+" N1"
	cQuery += " LEFT JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=N1_XP"+cvaltochar(nCont)+" AND B1.D_E_L_E_T_=''"  
	cQuery += " LEFT JOIN "+RetSQLName("SZH")+" ZH ON ZH_MOLA='"+cvaltochar(nCont)+"' AND ZH_CHAPA=N1_CHAPA AND ZH.D_E_L_E_T_=''" 
	cQuery += " WHERE N1_CHAPA='"+cPatrim+"' AND N1.D_E_L_E_T_=''"
	
	If Select("TRB") > 0
		dbSelectArea("TRB")
		dbCloseArea()
	EndIf
	  
	MemoWrite("TTAUDR01.SQL",cQuery)
	
	cQuery:= ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
	
	DbSelectArea("TRB")
	                       // 1   2      3     4        5        6         7 8  9  10  11  12
	                       //Pos Hab   Linha Coluna   Dista    Salto      Cd Qt Tp Des Say flag
	While !EOF()
		//Grava a tabela contida no patrimonio para poder buscar o pre็o dos itens na hora de montar o mapa
		If Empty(cTabela) .And. !Empty(TRB->N1_XTABELA)
			cTabela :=	TRB->N1_XTABELA
		EndIf
		
		//nTipo1 := Alltrim(Posicione("SX5",1,xFilial("SX5")+'ZZ'+&("TRB->N1_XP"+cvaltochar(nCont)),"X5_DESCRI"))
		cProd := &("TRB->N1_XP"+cvaltochar(nCont))
		cMola := Posicione("SB1",1,xFilial("SB1")+AvKey(cProd,"B1_COD"),"B1_XMOLA")
		nTipo1 := Alltrim(Posicione("SX5",1,xFilial("SX5")+'ZZ'+cMola,"X5_DESCRI"))
	    
	    Aadd(aLista,{cvaltochar(nCont),&("TRB->N1_XP"+cvaltochar(nCont)),TRB->ZH_QUANT,'',Alltrim(TRB->B1_DESC),'',TRB->ZH_TIPOMOL,nTipo1,Alltrim(Posicione("SX5",1,xFilial("SX5")+'ZT'+Posicione("SB1",1,xFilial("SB1")+&("TRB->N1_XP"+cvaltochar(nCont)),"B1_XPREPAR"),"X5_DESCRI"))})
		DbSkip()
	EndDo
	nCont++
EndDo

RestArea(aArea)

Return

static function xvalidm(lAlt,nPos) //,lCheck,lAlt,nPos)

Local aArea	:=	Getarea()
Local lRet 	:=	.t.


lRet := checar(lCheck,lAlt,nPos)

RestArea(aArea)

Return(lRet)