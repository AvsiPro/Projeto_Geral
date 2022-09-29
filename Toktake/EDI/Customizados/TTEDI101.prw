#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TBICONN.CH'
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ TTEDI101 ณ Autor ณAlexandre Venancio     ณ Data ณ31/10/2012|ฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณLocacao   ณ                  ณContato ณ                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAplicacao ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณ                                               ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ              ณ  /  /  ณ                                               ณฑฑ
ฑฑณ              ณ  /  /  ณ                                               ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function TTEDI101() 

Local oFonte := TFont():New('Verdana',,15,.T.)
Local nOp	 := 0
Local cPedAx := '' 
Local nQtdP	 := 0
SetPrvt("oDlg1","oGrp1","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oSay7","oSay8","oGrp2","oBrw1")
SetPrvt("oBtn2","oBtn3")
                                                                       
Private aAuxP	 := {}
Private oList
Private oOk   	:= LoadBitmap(GetResources(),'br_amarelo')       //Controla se o pedido foi alterado ou nao no grid.
Private oNo   	:= LoadBitmap(GetResources(),'br_vermelho')
Private oPr		:= LoadBitmap(GetResources(),'br_verde')
 
If cEmpAnt <> "01"
	Return
EndIf

For nX := 1 to len(aList)
	If !aList[nX,35] $ cPedAx
		Aadd(aAuxP,aList[nX]) 
		nQtdP++
	EndIf
	cPedAx += aList[nX,35] +"/"
Next nX

oDlg1      := MSDialog():New( 091,232,563,1068,"Importador de Pedidos",,,.F.,,,,,,.T.,,,.T. )

oGrp1      := TGroup():New( 004,012,044,400,"Informa็๕es Gerais",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay1      := TSay():New( 012,156,{||"Setor"},oGrp1,,oFonte,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,036,008)
	oSay2      := TSay():New( 012,188,{||"Processamento / PCA"},oGrp1,,oFonte,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,080,008)
	
	oSay3      := TSay():New( 020,016,{||"Usuแrio"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
	oSay4      := TSay():New( 020,044,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
	oSay4:setText(cusername)
	
	oSay5      := TSay():New( 020,328,{||"Data"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,008)
	oSay6      := TSay():New( 020,360,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay6:setText(cvaltochar(dDataBase))
	
	oSay7      := TSay():New( 032,016,{||"Quantidade de Pedidos"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
	oSay8      := TSay():New( 032,084,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,008)
	oSay8:setText(cvaltochar(nQtdP))

oGrp2      := TGroup():New( 052,012,196,400,"Informa็๕es dos Pedidos",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oList := TCBrowse():New(064,020,380,120,, {'','Pedido','Cliente','Loja','Descri็ใo','Data Entrega','Cod. PA','Centro de Custo','Item Contabil'},{10,30,20,30,80,35,35,35,35},;
	                            oGrp2,,,,{|| },{|| editCab(aAuxP[oList:nAt,35])},, ,,,  ,,.F.,,.T.,,.F.,,,)
	oList:SetArray(aAuxP)
	oList:bLine := {||{  if(aAuxP[oList:nAt,32]==1,oPr,if(aAuxP[oList:nAt,32]==2,oOk,oNo)),;      
						 aAuxP[oList:nAt,35],;
	 					 aAuxP[oList:nAt,04],;
	 					 aAuxP[oList:nAt,05],;
	                     aAuxP[oList:nAt,34],;
	                     aAuxP[oList:nAt,06],;
	                     aAuxP[oList:nAt,08],;
	                     aAuxP[oList:nAt,16],;
	                     aAuxP[oList:nAt,17]}}	

oBtn1      := TButton():New( 208,116,"Visualizar Itens",oDlg1,{||VerItens(aAuxP[oList:nAt,35])},040,012,,,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 208,180,"Confirmar Imp.",oDlg1,{||oDlg1:end(nOp:=1)},040,012,,,,.T.,,"",,,,.F. )
oBtn3      := TButton():New( 208,244,"Sair",oDlg1,{||oDlg1:end(nOp:=0)},040,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)
               
If nOp == 1
	Gravar()
EndIf

Return      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTEDI101  บAutor  ณMicrosiga           บ Data ณ  11/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Gravar()

Local aArea	 := GetArea()
Local _acab	 :=	{}  
Local _aitm  := {}  
//Local _aGamb :=	{}
Local cPedido	:=	''
Local aRotina2  := {{"Incluir","A410Barra",0,3},;							 
					{"Alterar","A410Barra",0,4}}								 
Local aRotina3  := {{ OemToAnsi("delete"),"A410Deleta"	,0,5,21,NIL},;
					{ OemToAnsi("Residuo"),"Ma410Resid",0,2,0,NIL}}			
    
Private lMsErroAuto := 	.F. 
                      
For nX := 1 to len(aCabec)
    cPedido := aCabec[nX,2,2]	
	
    If aAuxP[Ascan(aAuxP,{|x| x[35] = cPedido}),32] == 1
	    _acab := {}
		_aitm := {}
		
		
	    For nJ := 1 to len(aCabec[nX])
			Aadd(_acab,aCabec[nX,nJ])
	    Next nJ
	    
	    For nP := 1 to len(aItens)
	    	If aItens[nP,2,2] == cPedido
	    		Aadd(_aitm,aItens[nP])
	    		//_aGamb := StrToKarr(_aitm[len(_aitm),10,2],",")
	    		_aitm[len(_aitm),3,2] := Strzero(len(_aitm),2)
	    		_aitm[len(_aitm),10,2] := NOROUND(val(strtran(strtran(_aitm[len(_aitm),10,2],","),"."))/100,2) //A410Arred(val(strtran(strtran(_aitm[len(_aitm),10,2],","),"."))/10000,"C6_PRCVEN")
	    		//_aitm[len(_aitm),11,2] := val(strtran(strtran(_aitm[len(_aitm),11,2],","),"."))/10000
	    		_aitm[len(_aitm),11,2] := noround(_aitm[len(_aitm),06,2]*_aitm[len(_aitm),10,2],2) //A410Arred((_aitm[len(_aitm),06,2]*_aitm[len(_aitm),10,2]),"C6_VALOR")
	    		_aitm[len(_aitm),12,2] := NOROUND(val(strtran(strtran(_aitm[len(_aitm),12,2],","),"."))/100,2)
	    		_aitm[len(_aitm),14,2] := NOROUND(val(strtran(strtran(_aitm[len(_aitm),14,2],","),"."))/100,2)
    			dbSelectArea("SB2")
				dbSetOrder(1)
				If !dbSeek(_aitm[len(_aitm),1,2]+_aitm[len(_aitm),4,2]+_aitm[len(_aitm),17,2])
					CriaSB2(_aitm[len(_aitm),4,2],_aitm[len(_aitm),17,2])
				Endif
                //ADel(_aitm[len(_aitm)],11)
                //ASize(_aitm[len(_aitm)],26)
	    	EndIf
	    Next nP 
	    
	    	
		MSExecAuto({|x,y,z|MATA410(x,y,z)},_acab,_aitm,3)
		// Mostra Erro na geracao de Rotinas automaticas
		If lMsErroAuto
			RollBackSx8()
			MostraErro()
		Else
			MSGAlert("Pedido gerado"+cPedido,"TTEDI101") 
		EndIf 
	
		
	EndIf		

Next nX
			
RestArea(aArea)

Return                                      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTEDI101  บAutor  ณMicrosiga           บ Data ณ  11/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VerItens(cPedido)

Local aArea	:=	GetArea()
Local oGrp5,oBrw1,oBtn51,oBtn52
Local aAux	:=	{} 
Local cTabela 	:=	aList[Ascan(aList,{|x| x[35] = cPedido}),15]
Private oLista,oDlg5	
Private aLista	:=	{}

For nX := 1 to len(aItens)       
	If aItens[nX,2,2] == cPedido
		For nJ := 1 to len(aItens[nX])
			Aadd(aAux,aItens[nX,nJ,2])	
		Next nJ      
		Aadd(aLista,aAux) 
		aAux := {}
	EndIf
Next nX              

oDlg5      := MSDialog():New( 091,232,448,885,"Itens do Pedido a ser importado",,,.F.,,,,,,.T.,,,.T. )

	oGrp5      := TGroup():New( 008,008,144,312,"Itens",oDlg5,CLR_BLACK,CLR_WHITE,.T.,.F. )

	oLista := TCBrowse():New(008,008,300,120,, {'Produto','Descri็ใo','Qtd','Vlr Unit.','Vlr Total','TES','Tabela'},{30,40,30,30,30,30,30},;
	                            oGrp5,,,,{|| },{|| editcol(oLista:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,)
	oLista:SetArray(aLista)      
	oLista:bLine := {||{aLista[oLista:nAt,4],;
	 					 Posicione("SB1",1,xFilial("SB1")+aLista[oLista:nAt,4],"B1_DESC"),; 
	 					 aLista[oLista:nAt,6],;
	 					 aLista[oLista:nAt,10],;
	 					 aLista[oLista:nAt,11],;
	 					 aLista[oLista:nAt,13],;
	 					 cTabela}}

oBtn51     := TButton():New( 152,092,"Confirmar",oDlg5,{||Acerto()},037,012,,,,.T.,,"",,,,.F. )
oBtn52     := TButton():New( 152,184,"Sair",oDlg5,{||oDlg5:end()},037,012,,,,.T.,,"",,,,.F. )

oDlg5:Activate(,,,.T.)

RestArea(aArea)

Return      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTEDI101  บAutor  ณMicrosiga           บ Data ณ  11/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function editCab(cPedido)

Local oDlg9,oGrp1,oSay1,oSay2,oSay3,oSay4,oGet1,oGet2,oGet3,oGet4,oBtn1,oBtn2
Local cTabela 	:=	If(empty(aList[Ascan(aList,{|x| x[35] = cPedido}),15]),space(3),aList[Ascan(aList,{|x| x[35] = cPedido}),15])
Local cFormP	:=	If(empty(aList[Ascan(aList,{|x| x[35] = cPedido}),36]),space(3),aList[Ascan(aList,{|x| x[35] = cPedido}),36])
Local cMesR		:=	If(empty(aList[Ascan(aList,{|x| x[35] = cPedido}),37]),space(5),aList[Ascan(aList,{|x| x[35] = cPedido}),37])
Local cItmC		:=	If(empty(aList[Ascan(aList,{|x| x[35] = cPedido}),17]),space(20),aList[Ascan(aList,{|x| x[35] = cPedido}),17])
Local nOpc		:=	0 
Local lRepl		:=	.F.

oDlg9      := MSDialog():New( 097,495,401,879,"Informa็๕es Cabe็alho Pedido",,,.F.,,,,,,.T.,,,.T. )

oGrp1      := TGroup():New( 008,008,120,176,"Informa็๕es",oDlg9,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay1      := TSay():New( 024,028,{||"Forma de Pagto."},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
	oGet1      := TGet():New( 024,100,{|u| If(Pcount()>0,cFormP:=u,cFormP)},oGrp1,060,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"Z8","",,)

	oSay2      := TSay():New( 048,028,{||"M๊s Refer๊ncia"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
	oGet2      := TGet():New( 048,100,{|u| If(Pcount()>0,cMesR:=u,cMesR)},oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"Z9","",,)

	oSay3      := TSay():New( 072,028,{||"Tabela"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oGet3      := TGet():New( 072,100,{|u| If(Pcount()>0,cTabela:=u,cTabela)},oGrp1,060,008,'',{||},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"DA0","",,)

	oSay4      := TSay():New( 096,028,{||"Item Contแbil"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oGet4      := TGet():New( 096,100,{|u| If(Pcount()>0,cItmC:=u,cItmC)},oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"CTD","",,)  

oBtn1      := TButton():New( 128,048,"Confirmar",oDlg9,{||oDlg9:end(nOpc:=1)},037,012,,,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 128,108,"Voltar",oDlg9,{||oDlg9:end(nOpc:=0)},037,012,,,,.T.,,"",,,,.F. )

oDlg9:Activate(,,,.T.)

If nOpc == 1 
	lRepl := MsgYesNo("Replicar as informa็๕es de cabe็alho para os demais pedidos?","TTEDI101")
	
	If !lRepl
		For nX := 1 to len(aList)
			If aList[nX,35] == cPedido
				aList[nX,36] := cFormP
				aList[nX,37] := cMesR
				aList[nX,15] := cTabela
				aList[nX,17] := cItmC
			EndIf
		Next nX  
		
		For nX := 1 to len(aAuxP)
			If aAuxP[nX,35] == cPedido
				aAuxP[nX,36] := cFormP
				aAuxP[nX,37] := cMesR
				aAuxP[nX,15] := cTabela
				aAuxP[nX,17] := cItmC
			EndIf
		Next nX  
		
		For nX := 1 to len(aCabec)
			If aCabec[nX,2,2] == cPedido
				aCabec[nX,18,2] :=	cTabela
				aCabec[nX,20,2] := cItmC
				aCabec[nX,38,2] :=	cFormP
				aCabec[nX,39,2] :=	cMesR
			EndIf
		Next nX
		
		For nX := 1 to len(aItens)
			If aItens[nX,2,2] == cPedido
				aItens[nX,19,2] := cItmC
			EndIf
		Next nX
		                        
		If aAuxP[oList:nAt,32] > 1
			aAuxP[oList:nAt,32] -= 1		       
		EndIf
	Else
		For nX := 1 to len(aList)
			aList[nX,36] := cFormP
			aList[nX,37] := cMesR
			aList[nX,15] := cTabela
			aList[nX,17] := If(Empty(aList[nX,17]),cItmC,aList[nX,17])
		Next nX  
		
		For nX := 1 to len(aAuxP)
			aAuxP[nX,36] := cFormP
			aAuxP[nX,37] := cMesR
			aAuxP[nX,15] := cTabela
			aAuxP[nX,17] := If(Empty(aAuxP[nX,17]),cItmC,aAuxP[nX,17])
		
			If aAuxP[nX,32] > 1
				aAuxP[nX,32] -= 1		       
			EndIf

		Next nX  
		
		For nX := 1 to len(aCabec)
			aCabec[nX,18,2] :=	cTabela
			aCabec[nX,20,2] :=	If(Empty(aCabec[nX,20,2]),cItmC,aCabec[nX,20,2])
			aCabec[nX,38,2] :=	cFormP
			aCabec[nX,39,2] :=	cMesR
		Next nX
		
		For nX := 1 to len(aItens)
			aItens[nX,19,2] := If(Empty(aItens[nX,19,2]),cItmC,aItens[nX,19,2])
		Next nX
		
	EndIf
	oList:refresh()		    
    oDlg1:refresh()
EndIf

Return                 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTEDI101  บAutor  ณMicrosiga           บ Data ณ  11/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function editcol()
           
Local cBak1 := aLista[oLista:nAt,13] 
Local cBak2	:= aLista[oLista:nAt,06]
Local lOk	:= .F.   
Local cDupF	:= POSICIONE("ZZC",1,xFilial("ZZC")+ACABEC[ascan(aCabec,{|x| x[2,2] == aLista[oLista:nAt,02]}),12,2],"ZZC_DUPLI")
Local cEstF	:= POSICIONE("ZZC",1,xFilial("ZZC")+ACABEC[ascan(aCabec,{|x| x[2,2] == aLista[oLista:nAt,02]}),12,2],"ZZC_ESTQ") 
Local cPCP	:= POSICIONE("SB1",1,xFilial("SB1")+aLista[oLista:nAt,04],"B1_XPISCOF")
Local cDupT	:= ''
Local cEstT	:= ''
Local cPCT	:= ''
Local lCop	:= .T.                   
Local lDesc	:= If(acabec[ascan(acabec,{|x| x[2][2] = alista[oLista:nAt,02]}),12,2] == "L",.T.,.F.)
                                   
aLista[oLista:nAt,06] := aLista[oLista:nAt,13] 
        
While !lOk
	
	lEditCell(aLista,oLista,'@!',6)
	
	If Empty(aLista[oLista:nAt,06])
		lOk := .T.
	Else
		If aLista[oLista:nAt,06] < '500'
			MsgAlert("Tes Invแlida!")
		Else
			lOk := .T.
			If !existcpo("SF4",aLista[oLista:nAt,06])
				MsgAlert("Esta TES nใo existe","TTEDI101")
				lOk := .F.
				loop
			EndIf
			cEstT := Posicione("SF4",1,ACABEC[ascan(aCabec,{|x| x[2,2] == aLista[oLista:nAt,02]}),1,2]+aLista[oLista:nAt,06],"F4_ESTOQUE")
			cDupT := Posicione("SF4",1,ACABEC[ascan(aCabec,{|x| x[2,2] == aLista[oLista:nAt,02]}),1,2]+aLista[oLista:nAt,06],"F4_DUPLIC")
			cPCT  := Posicione("SF4",1,ACABEC[ascan(aCabec,{|x| x[2,2] == aLista[oLista:nAt,02]}),1,2]+aLista[oLista:nAt,06],"F4_PISCOF")
			
			If !lDesc
				If  cEstT != cEstF 
					MsgAlert("Esta TES nใo pode ser utilizada com esta Finalidade de Venda"+Chr(13)+Chr(10)+"Tes movimenta estoque="+cEstT+" Finalidade movimenta estoque ="+cEstF,"TTEDI101")
					lOk := .F.
				EndIf
				
				If cDupT != cDupF
					MsgAlert("Esta TES nใo pode ser utilizada com esta Finalidade de Venda"+Chr(13)+Chr(10)+"Tes gera duplicata="+cDupT+" Finalidade gera duplicata="+cDupF,"TTEDI101")
					lOk := .F.
				EndIf
				
				If cPCT == "4" .And. cPCP == "S"
					MsgAlert("Este produto tem cr้dito de PIS/COFINS e a TES nใo estแ configurada para calcular. Altere para uma TES com cr้dito de PIS/COFINS.","TTEDI101")
					lOk := .F.
				EndIf
				
				If cPCT == "3" .And. cPCP == "N"       
					MsgAlert("Este produto nใo tem cr้dito de PIS/COFINS e a TES estแ configurada para calcular. Altere para uma TES sem cr้dito de PIS/COFINS.","TTEDI101")
					lOk := .F.
				EndIf
				
				If empty(cPCP)
					MsgAlert("Este produto estแ sem a configura็ใ de cr้dito de PIS/COFINS, procure o Depto. Fiscal.","TTEDI101")
					lOk	:= .F.
				EndIf
			EndIf
							
			If lOk	
				If len(aLista) > 1
					If MsgYesNo("Deseja replicar esta TES para os demais itens?","TTEDI101")
						For nX := oLista:nAt to len(aLista) 
							lCop := .T.
							If !lDesc
								cPCP := POSICIONE("SB1",1,xFilial("SB1")+aLista[nX,04],"B1_XPISCOF")
								If cPCT == "4" .And. cPCP == "S"
									//MsgAlert("O produto "+aLista[nX,04]+" tem cr้dito de PIS/COFINS e a TES nใo estแ configurada para calcular. Altere para uma TES com cr้dito de PIS/COFINS.","TTEDI101")
									lCop := .F.
								EndIf
								
								If cPCT == "3" .And. cPCP == "N"       
									//MsgAlert("O produto "+aLista[nX,04]+" nใo tem cr้dito de PIS/COFINS e a TES estแ configurada para calcular. Altere para uma TES sem cr้dito de PIS/COFINS.","TTEDI101")
									lCop := .F.
								EndIf
								
								If empty(cPCP)
									//MsgAlert("O produto "+aLista[nX,04]+" estแ sem a configura็ใ de cr้dito de PIS/COFINS, procure o Depto. Fiscal.","TTEDI101")
									lCop	:= .F.
								EndIf  
							EndIf
							
							If lCop
								aLista[nX,13] := aLista[oLista:nAt,06]	
							EndIf
						Next nX
					EndIf
				EndIf
			EndIf
		EndIf 
	EndIf
EndDo

If aLista[oLista:nAt,06] != cBak1
	aLista[oLista:nAt,13] := aLista[oLista:nAt,06]
	aLista[oLista:nAt,06] := cBak2  

	If aAuxP[oList:nAt,32] > 1
		aAuxP[oList:nAt,32] -= 1		       
	EndIf
Else
	aLista[oLista:nAt,13] := cBak1
	aLista[oLista:nAt,06] := cBak2
EndIf                                              

oLista:refresh()
oDlg5:refresh()
 
Return     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTEDI101  บAutor  ณMicrosiga           บ Data ณ  11/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Acerto()

Local aArea	:=	GetArea()

For nX := 1 to len(aLista)
	If ascan(aItens,{|x| x[2,2]+x[4,2] = alista[nX,2]+alista[nX,4]}) > 0
		aItens[ascan(aItens,{|x| x[2,2]+x[4,2] = alista[nX,2]+alista[nX,4]}),13,2] := aLista[nX,13]
	EndIf
Next nX  

oDlg5:end()

RestArea(aArea)

Return      