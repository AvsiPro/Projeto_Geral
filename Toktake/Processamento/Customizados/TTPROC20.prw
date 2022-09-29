#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'  
#INCLUDE 'TBICONN.CH'     
#DEFINE pula Chr(10)    
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ TTPROC20 ณ Autor ณAlexandre Venancio     ณ Data ณ10/09/2013ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณLocacao   ณ                  ณContato ณ                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Rotina de Auditorias de faturamento de clientes.           ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAplicacao ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Processamento                                              ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณ                                               ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAlexandre     ณ10/09/13ณ01.01 | Criacao                                ณฑฑ
ฑฑณ              ณ  /  /  ณ                                               ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function TTPROC20(cPeriodo)

SetPrvt("oDlg1","oGrp1","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oSay7","oSay8","oGrp2","oBrw1")
SetPrvt("oBtn2","oBtn3","oBtn4","oBtn5","oBmp1","oSay9","oSay10","oSay11","oSay12","oSay13","oSay14")
Private oList
Private oList2	      
Private oList3
Private aList2	:=	{} 
Private aBkL2	:=	{}   
Private aList3	:=	{}
Private aList	:=	{} 
Private aPatri	:=	{}
Private aContr	:=	{}
Private aConta	:=	{} 
Private aInsumo	:=	{}         
Private aCalDos	:=	{}
Private aMed3mP	:=	{}
Private aTotP	:=	{}
Private aSangria:=	{}
Private aMoel	:=	{}
Private aVlrRe	:=	{}
Private aDuplic	:=	{}
Private aAudit1c:=	{}
Private aVlUnit	:=	{}
Private aAudPrM	:=	{}
Private nGerar	:=	0    
Private aCcart4	:=	{}
Private oOk   	:= LoadBitmap(GetResources(),'br_verde')       //Controla se o pedido foi alterado ou nao no grid.
Private oNo   	:= LoadBitmap(GetResources(),'br_vermelho')  

If cEmpAnt <> "01"
	return
EndIF

//Prepare Environment Empresa "01" Filial "01" Tables "SZN,SN1"
Aadd(aList2,{'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''})
Aadd(aList3,{'','','','','',''})
cafe(cPeriodo) 

If len(aList) > 0
	
	oDlg1      := MSDialog():New( 091,232,601,1270,"Auditorias - Processamento",,,.F.,,,,,,.T.,,,.T. )
	
		oGrp1      := TGroup():New( 004,004,056,508,"Gerais",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
			oSay1      := TSay():New( 016,016,{||"Cliente"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)
			oSay2      := TSay():New( 016,044,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_WHITE,CLR_BLUE,192,008)
		    oSay2:lTransparent := .F.
		    
			oSay3      := TSay():New( 016,240,{||"Segmento"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)
			oSay4      := TSay():New( 016,280,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_WHITE,CLR_BLUE,092,008)
			oSay4:lTransparent := .F.
		    
		    oSay9      := TSay():New( 016,380,{||"Contrato"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)
		    oSay10     := TSay():New( 016,410,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_WHITE,CLR_BLUE,052,008)
			oSay10:lTransparent := .F.
			
			oSay5      := TSay():New( 036,016,{||"Responsแvel"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
			oSay6      := TSay():New( 036,056,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,156,008)
		
			oSay7      := TSay():New( 036,240,{||"Compet๊ncia"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
			oSay8      := TSay():New( 036,280,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,140,008)
	
			oSay11     := TSay():New( 036,380,{||"Perํodo Fat"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,062,008)
			oSay12     := TSay():New( 036,410,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,140,008)
			
			oSay13     := TSay():New( 046,380,{||"Perํodo Coleta"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,062,008)
			oSay14     := TSay():New( 046,420,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,140,008)

			oBmp1      := TBitmap():New( 036,152,012,012,,"",.T.,oGrp1,,,.F.,.T.,,"",.T.,,.T.,,.F. )
	
		oGrp2      := TGroup():New( 060,004,220,508,"Dados a faturar e leituras",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
			//oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{072,012,212,500},,, oGrp2 ) 
			oList := TCBrowse():New(072,012,180,145,, {'','Codigo','Contador','Valor Unit.','Valor Total','Pedidos'},;
									{10,30,30,30,30,30},;
		                            oGrp2,,,,{|| FHelp(oList:nAt)},{|| editcol(oList:nAt,0)},, ,,,  ,,.F.,,.T.,,.F.,,.T.,.T.)
			oList:SetArray(aList)
			oList:bLine := {||{ If(aList[oList:nAt,24]=="0",oNo,oOk),;
			   					 aList[oList:nAt,01],; 
			 					 aList[oList:nAt,09],;
			                     aList[oList:nAt,12],;
			                     aList[oList:nAt,05],;
			                     aList[oList:nAt,14]}} 
			                                     //13
			oList2 := TCBrowse():New(072,195,180,145,, {'Tipo Leit','Patrimonio','Data','Total Sale','Total Cash',''},;
						{30,30,30,30,30,30},;
                        oGrp2,,,,{|| /*FHelp(oList:nAt)*/},{|| DetFech(oList2:nAt) /*editcol(oList:nAt,0)*/},, ,,,,,.F.,,.T.,,.F.,,.T.,.T.)
      		oList2:SetArray(aList2)
			oList2:bLine := {||{aList2[oList2:nAt,06],;
								 aList2[oList2:nAt,02],;
			   					 aList2[oList2:nAt,03],; 
			 					 aList2[oList2:nAt,04],;
			                     aList2[oList2:nAt,05],;
			                     aList2[oList2:nAt,32]}} 
			                     //32
			oList3 := TCBrowse():New(072,380,120,145,, {'Pedido','NF','Valor'},;
						{30,30,30},;
                        oGrp2,,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt,0)*/},, ,,,  ,,.F.,,.T.,,.F.,,.T.,.T.)
      		oList3:SetArray(aList3)
			oList3:bLine := {||{aList3[oList3:nAt,01],;
			   					 aList3[oList3:nAt,02],; 
			 					 Transform(aList3[oList3:nAt,03],"@E 999,999,999.99")}} 
	
	
		oBtn1      := TButton():New( 228,076,"Planilha",oDlg1,{||Processa({||editcol(oList:nAt,3)},"Aguarde...")},037,012,,,,.T.,,"",,,,.F. )
		oBtn2      := TButton():New( 228,152,"Vis. Pedido",oDlg1,{|| VerPv(oList3:nAt)},037,012,,,,.T.,,"",,,,.F. )
		oBtn3      := TButton():New( 228,228,"Observa็๕es",oDlg1,{||ObsFat(oList:nAt)},037,012,,,,.T.,,"",,,,.F. )
		//oBtn5      := TButton():New( 228,304,"Estornar",oDlg1,{||estornar(oList:nAt)},037,012,,,,.T.,,"",,,,.F. )
		oBtn5      := TButton():New( 228,304,"Pr้-Faturamento",oDlg1,{|| Prepedido(aList[oList:nAt,01])},037,012,,,,.T.,,"",,,,.F. )
		oBtn4      := TButton():New( 228,400,"Sair",oDlg1,{||oDlg1:end(nOp:=0)},037,012,,,,.T.,,"",,,,.F. )
	    oBtn1:disable()
	    //oBtn2:disable()
	oDlg1:Activate(,,,.T.)
Else
	MsgAlert("Nใo encontrado registros que satisfa็am ao filtro digitado","TTPROC20")
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC20  บAutor  ณMicrosiga           บ Data ณ  09/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Labels                                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FHelp(nLinha)

Local aArea	:=	GetArea()
Local cAux3	:=	''                                                 

aList2 := {}

oSay2:setText("")
oSay4:setText("")
oSay6:setText("")
oSay8:setText("")
oSay10:setText("") 
oSay14:setText("")
oBmp1:SetBmp("")

If !empty(aList[nLinha,14])
	oBtn2:disable()
Else
	//oBtn2:enable()
endIf

oSay2:setText("Loja "+aList[nLinha,02]+" - "+aList[nLinha,15])
oSay4:setText(aList[nLinha,16])
oSay6:setText(aList[nLinha,17])
oSay8:setText(MV_PAR03)
oSay10:SetText(aList[nLinha,18])
oSay12:SetText(cvaltochar(aList[nLinha,19]) + " A "+cvaltochar(aList[nLinha,20])) 
oSay14:SetText(cvaltochar(aList[nLinha,22]) + " A "+cvaltochar(aList[nLinha,23]))
//oBmp1:SetBmp(If(nLinha==1,"BAND_VERM","BAND_VERD"))

For nX := 1 to len(aBkL2) 
	If aBkL2[nX,01] == aList[nLinha,18]
		Aadd(aList2,aBkL2[nX])
	EndIf
Next nX  

If len(aList2) == 0
	aadd(aList2,{'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''})
Else 
	aList3 := {}
	For nX := 1 to len(aList2)
		If !Empty(aList2[nX,33]) .And. !Alltrim(aList2[nX,33]) $ cAux3 .And. aList2[nX,32] != "FAnt"
			If "/" $ aList2[nX,33]
				aPedl3 := strtokarr(aList2[nX,33],"/")
				For nP := 1 to len(aPedl3)
					If Ascan(aList3,{|x| x[1] == aPedl3[nP]}) == 0
						Aadd(aList3,{aPedl3[nP],'',0})
					EndIf
				Next nP     
			Else
				If Ascan(aList3,{|x| Alltrim(x[1]) == Alltrim(aList2[nX,33])}) == 0
					Aadd(aList3,{aList2[nX,33],'',0})
				EndIf
			endIf
		endIf
	Next nX  
	
	If len(aList3) > 0
		For nX := 1 to len(aList3)
			cQuery := "SELECT C6_NOTA,SUM(C6_VALOR) AS TOTAL FROM "+RetSQLName("SC6")
			cQuery += " WHERE C6_FILIAL='"+xFilial("SC6")+"' AND C6_NUM='"+aList3[nX,01]+"' AND D_E_L_E_T_=''"
			cQuery += " GROUP BY C6_NOTA
			
			If Select('TRB') > 0
				dbSelectArea('TRB')
				dbCloseArea()
			EndIf
			
			MemoWrite("FatCafe.SQL",cQuery)
			DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
			
			DbSelectArea("TRB")
			
			While !EOF()
				aList3[nX,03] += TRB->TOTAL
				aList3[nX,02] += If(!Empty(aList3[nX,02]),"/"+TRB->C6_NOTA,TRB->C6_NOTA)
				DbSkip()
			EndDo
		Next nX 
		aList[oList:nAt,24] := '1'
		nTotPr := 0
		AEval(aList3, {|aList3| nTotPr += aList3[03] })   
		Aadd(aList3,{'Total','',nTotPr})
	Else
		Aadd(aList3,{'','',0})
	EndIf
EndIf

	oList2:SetArray(aList2)
	oList2:bLine := {||{aList2[oList2:nAt,06],;
						 aList2[oList2:nAt,02],;
	   					 aList2[oList2:nAt,03],; 
	 					 aList2[oList2:nAt,04],;
	                     aList2[oList2:nAt,05],;
	                     aList2[oList2:nAt,32]}} 
	                     //32      
	oList3:SetArray(aList3)
	oList3:bLine := {||{aList3[oList3:nAt,01],;
	   					 aList3[oList3:nAt,02],; 
	 					 Transform(aList3[oList3:nAt,03],"@E 999,999,999.99")}} 

	oList2:refresh()
	oList3:refresh()
	oDlg1:refresh()     
 
RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC20  บAutor  ณMicrosiga           บ Data ณ  09/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Duplo clique na posicao da grid.                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function editcol(nLinha,nP)

Local aArea	:=	GetArea()
Local nColP	:=	If(nP==0,oList:colpos,nP)
Local aAux	:=	{}
//	  1		 2		  3		  4			  5					6					7				8			9
//'Codigo','Loja','Estoque','Log','Abast. X Cons.','Recarga X Sangria','Consumo X Contador','Pro-Rata','Contador',
//			10				 11				12				13		 14            15		   16		   17		  18	
//'Faturamento Medio','Log X Contador','Valor Unit.','Valor Total','Pedidos','NOMECLIENTE','TIPOCONTRA','ANALISTA','CONTRATO' 
    
If nColP == 5 .And. !Empty(aList[nLinha,nColP])
	CnsIns(aList[nLinha,01])
ElseIf nColP == 7 .And. !Empty(aList[nLinha,nColP])
	ValPPat(nLinha)
ElseIf nColP == 3 .And. !Empty(aList[nLinha,9])
	//cliente,contrato,tipocontrato,patrimonio,data,numerant,numatual,diferenca,contadorps
	For nX := 1 to len(aConta)
		If aConta[nX,01] = aList[nLinha,18] //Ascan(aConta,{|x| x[1] == aList[nLinha,18]}) > 0
			Aadd(aAux,{aConta[nX,03]+"-"+aConta[nX,04]+" "+aList[nLinha,15],aList[nLinha,18],aList[nLinha,16],;
						aConta[nX,06],cvaltochar(stod(aConta[nX,08])),aConta[nX,09],aConta[nX,10],aConta[nX,11],aConta[nX,12]-aConta[nX,15],;
						aConta[nX,16],aConta[nX,17]})
		EndIf
	Next nX
	If len(aAux) > 0
		ConsFech('Contadores',aAux,nColP,If(nP==0,.F.,.T.))
	EndIf
ElseIf nColP == 12 .And. !Empty(aList[nLinha,nColP])
	U_TTPROC21({},aList[nLinha,15],aList[nLinha,18],aList[nLinha,16],2) 
ElseIf nColP == 4  .And. !Empty(aList[nLinha,nColP])
	U_TTPROC21(aCcart4,aList[nLinha,15],aList[nLinha,18],aList[nLinha,16],3) 
EndIf



RestArea(aArea)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC20  บAutor  ณMicrosiga           บ Data ณ  09/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Auditoria para servico de cafe                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function cafe(cPeriodo)

Local aArea	:=	GetArea()
Local cQuery
Local cPer1
Local cPer2	                                       
Local cParCf	:=	GetMV("MV_XPARCF")
Local cPerc1	
Local cPerc2
Local dDia		:=	MV_PAR01
                         
/*BEGINDOC
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ<ฟ
//ณBusca contratos cadastrados como Servi็o de Caf้ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ<ู
ENDDOC*/
cQuery := "SELECT CN9_NUMERO,CN9_DTFIM,CN9_SITUAC,CN9_CONDPG,CN9_CLIENT,CN9_LOJACL,CN9_XANLAT,CN9_XANLBK,CN9_XPCOMP,CN9_XTPFAT,CN9_XTPCNT," 
cQuery += " CN9_XMINPO,CN9_XVOLMI,CN9_XCOMPE,CN9_XRATEI,CN9_XPRMIN,CN9_XVLEXC,CN9_XFORFA,CN9_XPECOL,CN9_XCCART,CN9_XPRORA"
cQuery += " FROM "+RetSQLName("CN9")
cQuery += " WHERE  D_E_L_E_T_='' AND CN9_TPCTO IN("+cParCf+")"

//Parametro 1 - Cliente Loja
If Empty(MV_PAR01)
	//cQuery += " AND CN9_CLIENT LIKE '%"+Substr(MV_PAR01,1,6)+"%'
	dDia := dDatabase
EndIf
//Parametro 2 - Analista
If !Empty(MV_PAR02)
	cQuery += " AND (CN9_XANLAT='"+MV_PAR02+"' OR CN9_XANLBK='"+MV_PAR02+"')"
EndIf
//Parametro 3 - Competencia
//If !Empty(MV_PAR03)

//EndIf                      
//Parametro 4 - Status
//If !Empty(MV_PAR04)

//EndIf                 
//Parametro 5 - Contrato
If !Empty(MV_PAR05)
	cQuery += " AND CN9_NUMERO LIKE '%"+Alltrim(MV_PAR05)+"%'"
EndIf
//Periodo de Faturamento ****************** NOVO TESTE ********************
//cQuery += " AND SUBSTRING(CN9_XPEPRO,1,2) >= '"+cvaltochar(strzero(Day(dDatabase),2))+"' AND SUBSTRING(CN9_XPEPRO,4,2) <= '"+cvaltochar(strzero(Day(dDatabase),2))+"'"
If !MV_PAR04
	cQuery += " AND '"+cvaltochar(strzero(Day(dDia),2))+"' BETWEEN SUBSTRING(CN9_XPEPRO,1,2) AND SUBSTRING(CN9_XPEPRO,4,2)"
EndIf

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("TTPRO20.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    Aadd(aContr,{TRB->CN9_NUMERO,TRB->CN9_DTFIM,TRB->CN9_SITUAC,TRB->CN9_CONDPG,TRB->CN9_CLIENT,TRB->CN9_LOJACL,TRB->CN9_XANLAT,TRB->CN9_XANLBK,;
    				TRB->CN9_XPCOMP,TRB->CN9_XTPFAT,TRB->CN9_XTPCNT,TRB->CN9_XMINPO,TRB->CN9_XVOLMI,TRB->CN9_XCOMPE,TRB->CN9_XRATEI,TRB->CN9_XPRMIN,;
    				TRB->CN9_XVLEXC,TRB->CN9_XFORFA,TRB->CN9_XPECOL,TRB->CN9_XCCART,TRB->CN9_XPRORA})
	Dbskip()
EndDo

If len(aContr) > 0
			/*BEGINDOC
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณBusca os Patrim๔nios que prestam o tipo de Servi็o Caf้ณ
			//ณAmarrados a estes contratos.                           ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			ENDDOC*/
	For nX := 1 to len(aContr)

		//cPer1  := CTOD(SUBSTR(aContr[nX,09],1,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-1)),3))
		cPer1  := mv_par06
		
		cQuery := "SELECT N1_XCLIENT,N1_XLOJA,N1_CHAPA,N1_DESCRIC FROM "+RetSQLName("SN1")
		cQuery += " WHERE D_E_L_E_T_=''"
		cQuery += " AND (N1_XTPSERV IN('2','6') AND N1_XCLIENT='"+aContr[nX,05]+"'"
		
		//Alterado para buscar os patrimonios que foram removidos do cliente
		cQuery += " OR N1_CHAPA IN(SELECT ZD_PATRIMO FROM "+RetSQLName("SZD")+" WHERE ZD_CLIENTE='"+aContr[nX,05]+"'"
		cQuery += " AND ZD_DATAREM > '"+dtos(cPer1)+"'))"
		
		//Contratos com faturamento por loja
		If aContr[nX,10] == "2"
			cQuery += " AND N1_XLOJA='"+aContr[nX,06]+"'"
		EndIf
		
		//So trazer patrimonios do tipo Maquina
		cQuery += " AND N1_PRODUTO IN(SELECT B1_COD FROM "+RetSQLName("SB1")+" WHERE B1_XSECAO='026' AND D_E_L_E_T_='')"
		
		If Select('TRB') > 0
			dbSelectArea('TRB')
			dbCloseArea()
		EndIf
		
		MemoWrite("TTPRO20.SQL",cQuery)
		DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
		
		DbSelectArea("TRB")
		
		While !EOF()
		    Aadd(aPatri,{aContr[nX,01],aContr[nX,02],aContr[nX,05],aContr[nX,06],aContr[nX,10],TRB->N1_CHAPA,TRB->N1_DESCRIC,0,aContr[nX,09],'','',aContr[nX,19]})
			Dbskip()
		Enddo 
		
		/*BEGINDOC
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAuditoria CCartoesณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		ENDDOC*/   
		/*
		If aContr[nX,20] == "1"                                                                         
			//Query fornecida pelo Andre da G2 para contar a quantidade de doses consumidas pelo patrimonio.
			cPer1  := CTOD(SUBSTR(aContr[nX,09],1,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-1)),3))
			cPer2  := If(SUBSTR(aContr[nX,09],1,2) >= substr(aContr[nX,09],4,2),CTOD(SUBSTR(aContr[nX,09],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03))),3)),CTOD(SUBSTR(aContr[nX,09],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-1)),3)))
			cPerc1 := If(SUBSTR(aContr[nX,19],1,2) > substr(aContr[nX,19],4,2),CTOD(SUBSTR(aContr[nX,19],1,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-1)),3)),CTOD(SUBSTR(aContr[nX,19],1,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03))),3))) //CTOD(SUBSTR(aPatri[nX,12],1,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03))),3))
			cPerc2 := If(SUBSTR(aContr[nX,19],1,2) > substr(aContr[nX,19],4,2),CTOD(SUBSTR(aContr[nX,19],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03))),3)),CTOD(SUBSTR(aContr[nX,19],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03))),3))) //CTOD(SUBSTR(aPatri[nX,12],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03))),3)) 
            
			For nPc := 1 to len(aPatri)
				If aPatri[nPc,01] == aContr[nX,01]
					cQuery := "SELECT COUNT(*) AS CCARTOES FROM ccartoes4.dbo.LogOperacaoCreditoConsumo l"
		            cQuery += " INNER JOIN ccartoes4.dbo.Dominio d on d.Codigo = cast(l.CodigoEvento as varchar(20)) and d.CodTabela='EVN'"
		            cQuery += " INNER JOIN ccartoes4.dbo.Filial f on f.idFilial = l.idFilialCartao"
		            cQuery += " LEFT OUTER JOIN ccartoes4.dbo.LogMaqRegistro lmr on lmr.idLogMaqRegistro = l.idLogMaqRegistro"
		            cQuery += " LEFT OUTER JOIN ccartoes4.dbo.LogMaqHeader lmh on lmh.idLogMaqHeader = lmr.idLogMaqHeader"
		            cQuery += " WHERE  l.DataHora >= '"+dtos(cPer1)+"' AND l.DataHora <= '"+dtos(cPer2)+"'"
		            cQuery += " AND patrimonio='"+aPatri[nPc,06]+"' AND l.CodigoEvento='20'"  
		            cQuery += " group by patrimonio"
		
		       		If Select('TRB') > 0
						dbSelectArea('TRB')
						dbCloseArea()
					EndIf
					
					MemoWrite("TTPRO20.SQL",cQuery)
					DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
					
					DbSelectArea("TRB")
					
					Aadd(aCcart4,{aContr[nX,01],aPatri[nPc,06],TRB->CCARTOES}) 
					If Ascan(aList,{|x| x[1] == aContr[nX,05]}) == 0 
						Aadd(aList,{aContr[nX,05],aContr[nX,06],'','OK','','','','','','','','','','',;
							Posicione("SA1",1,xFilial("SA1")+aContr[nX,05]+aContr[nX,06],"A1_NOME"),;
							'SERVIวO DE CAFษ',UsrFullName(aContr[nX,07]),;
							aContr[nX,01],cPer1,cPer2,'',cPerc1,cPerc2,'0'})
					Else
						If aList[Ascan(aList,{|x| x[1] == aPatri[nPc,03]}),04] != 'NOK'
							aList[Ascan(aList,{|x| x[1] == aPatri[nPc,03]}),04] := 'OK'
						EndIf
					EndIf
				EndIf
			Next nPc

		EndIf
		*/		
	Next nX	
	If len(aPatri) > 0          
		/*BEGINDOC
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณBusca todos os contadores registrados para os patrimoniosณ
		//ณno periodo de faturamento estipulado pelo contrato.      ณ
		//ณLevando-se em considera็ใo o mes a ser auditado.         ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		ENDDOC*/
				
		For nX := 1 to len(aPatri)
			//cPer1  := CTOD(SUBSTR(aPatri[nX,09],1,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-1)),3))
			cPer1 := mv_par06
			//cPer2  := If(SUBSTR(aPatri[nX,09],1,2) >= substr(aPatri[nX,09],4,2),If(CTOD(SUBSTR(aPatri[nX,09],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-1)),3))>cPer1,CTOD(SUBSTR(aPatri[nX,09],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-1)),3)),CTOD(SUBSTR(aPatri[nX,09],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03))),3))),CTOD(SUBSTR(aPatri[nX,09],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-1)),3)))
			//cPer2  := If(SUBSTR(aPatri[nX,09],1,2) >= substr(aPatri[nX,09],4,2),If(CTOD(SUBSTR(aPatri[nX,09],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-1)),3))>cPer1,CTOD(SUBSTR(aPatri[nX,09],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-1)),3)),CTOD(SUBSTR(aPatri[nX,09],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03))),3))),If(Empty(CTOD(SUBSTR(aPatri[nX,09],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-1)),3))),lastday(cPer1),CTOD(SUBSTR(aPatri[nX,09],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-1)),3))))
			cPer2  := mv_par07
			//cPerc1 := If(SUBSTR(aPatri[nX,12],1,2) > substr(aPatri[nX,12],4,2),CTOD(SUBSTR(aPatri[nX,12],1,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-1)),3)),CTOD(SUBSTR(aPatri[nX,12],1,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-30)),3))) 
			cPerc1 := cPer1
			//cPerc2 := If(SUBSTR(aPatri[nX,12],1,2) > substr(aPatri[nX,12],4,2),CTOD(SUBSTR(aPatri[nX,12],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-1)),3)),CTOD(SUBSTR(aPatri[nX,12],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-2)),3))) 
			//cPerc2 := If(SUBSTR(aPatri[nX,12],1,2) > substr(aPatri[nX,12],4,2),CTOD(SUBSTR(aPatri[nX,12],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-1)),3)),If(!Empty(CTOD(SUBSTR(aPatri[nX,12],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-30)),3))),CTOD(SUBSTR(aPatri[nX,12],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-30)),3)),lastday(cPerc1)))
			cPerc2 := cPer2
			
			//correcao na segunda data de periodo de faturamento
			/* // comentado jackson
			If cPer2 > cPer1 + 30 .And. cPer2 > cPerc2
				cPer2 := cPer1 + val(substr(aPatri[nX,09],4,2)) 
			EndIf
			*/
			
			aPatri[nX,10]	:=	cPer1
			aPatri[nX,11]	:=	cPer2
			
			cQuery := "SELECT ZN_CONFERE,R_E_C_N_O_ AS REGIS,ZN_PEDIDOS,ZN_CLIENTE,ZN_LOJA,ZN_PATRIMO,ZN_DATA,ZN_NUMANT,ZN_NUMATU,ZN_NUMATU-ZN_NUMANT AS DIF,"
			cQuery += " (ZN_BOTAO01+ZN_BOTAO02+ZN_BOTAO03+ZN_BOTAO04+ZN_BOTAO05+ZN_BOTAO06+ZN_BOTAO07+ZN_BOTAO08+ZN_BOTAO09+ZN_BOTAO10+ZN_BOTAO11+ZN_BOTAO12) AS PS,"
			
			//ALTERADO DEPOIS DE PRONTO, RODRIGO INFORMOU QUE OS CONTADORES AGORA ESTAO SENDO ACUMULADOS.
			cQuery += "(SELECT TOP 1(ZN_BOTAO01+ZN_BOTAO02+ZN_BOTAO03+ZN_BOTAO04+ZN_BOTAO05+ZN_BOTAO06+ZN_BOTAO07+ZN_BOTAO08+ZN_BOTAO09+ZN_BOTAO10+ZN_BOTAO11+ZN_BOTAO12)
			cQuery += " 	FROM "+RetSQLName("SZN")+" WHERE ZN_PATRIMO='"+aPatri[nX,06]+"' AND (ZN_DATA<'"+dtos(cPer2)+"' AND ZN_CONFERE<>'1') AND D_E_L_E_T_=''"
			//Esta parte foi adicionada para que traga os ps que nao estejam no periodo de coleta, mas tragam os que estao dentro do mesmo periodo.
			cQuery += "		AND ZN_DATA NOT BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"'"
			cQuery += "		AND ZN_TIPINCL<>'SANGRIA'"
			
			cQuery += " ORDER BY ZN_DATA DESC) AS P_ANT"


			
			cQuery += " FROM "+RetSQLName("SZN")
			cQuery += " WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_=''"
			cQuery += " AND ZN_PATRIMO='"+aPatri[nX,06]+"'"     
			
			//cQuery += " AND ZN_DATA BETWEEN '"+dtos(cPer1)+"' AND '"+dtos(cPer2)+"' AND ZN_CLIENTE='"+aPatri[nX,03]+"'"
			//Buscar somente os contadores informados entre o periodo de coleta do contrato do cliente.
			cQuery += " AND ((ZN_DATA BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"' OR ZN_CONFERE='1') AND ZN_CONFERE<>'I')"
			
				/*BEGINDOC
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณContratos com faturamento por loja do cliente.ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				ENDDOC*/
			If aPatri[nX,05] == "2"
				cQuery += " AND ZN_LOJA='"+aPatri[nX,04]+"'"
			EndIf  
			
			cQuery += " ORDER BY 7 DESC"
			
			If Select('TRB') > 0
				dbSelectArea('TRB')
				dbCloseArea()
			EndIf
			
			MemoWrite("TTPROC20.SQL",cQuery)
			DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
			
			DbSelectArea("TRB")
			
			While !EOF()
				//ALTERADO AQUI PARA PODER SOMAR OS CONTADORES CORRETAMENTE DE ACORDO COM OS LANวAMENTOS
				If Ascan(aConta,{|x| x[1]+x[6] == aPatri[nX,01]+aPatri[nX,06]}) == 0
					Aadd(aConta,{aPatri[nX,01],aPatri[nX,02],aPatri[nX,03],aPatri[nX,04],aPatri[nX,05],aPatri[nX,06],aPatri[nX,07],;
									TRB->ZN_DATA,TRB->ZN_NUMANT,TRB->ZN_NUMATU,TRB->DIF,TRB->PS,cPer1,If(stod(TRB->ZN_DATA)>cPer2,STOD(TRB->ZN_DATA),cPer2),;
									TRB->P_ANT,cPerc1,cPerc2,TRB->ZN_PEDIDOS,TRB->REGIS})
					If Stod(TRB->ZN_DATA) > cPer2
						aPatri[nX,11] := stod(TRB->ZN_DATA)
					EndIf 
				Else
					If TRB->ZN_CONFERE == "T"                                                          
						aConta[Ascan(aConta,{|x| x[1]+x[6] == aPatri[nX,01]+aPatri[nX,06]}),09]	:=	TRB->ZN_NUMANT
					EndIf
					aConta[Ascan(aConta,{|x| x[1]+x[6] == aPatri[nX,01]+aPatri[nX,06]}),10] :=	If(TRB->ZN_CONFERE=="T",aConta[Ascan(aConta,{|x| x[1]+x[6] == aPatri[nX,01]+aPatri[nX,06]}),10],TRB->ZN_NUMATU)
					aConta[Ascan(aConta,{|x| x[1]+x[6] == aPatri[nX,01]+aPatri[nX,06]}),11] :=  	If(TRB->ZN_CONFERE=="T",aConta[Ascan(aConta,{|x| x[1]+x[6] == aPatri[nX,01]+aPatri[nX,06]}),11]+TRB->DIF,TRB->DIF)
					aConta[Ascan(aConta,{|x| x[1]+x[6] == aPatri[nX,01]+aPatri[nX,06]}),12] :=	If(TRB->ZN_CONFERE=="T",aConta[Ascan(aConta,{|x| x[1]+x[6] == aPatri[nX,01]+aPatri[nX,06]}),12]+TRB->PS ,TRB->PS - aConta[Ascan(aConta,{|x| x[1]+x[6] == aPatri[nX,01]+aPatri[nX,06]}),12])
				EndIf
			
				/*BEGINDOC
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณSoma de contadores por Patrim๔nio.ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				ENDDOC*/
								
				If aContr[Ascan(aContr,{|x| x[1] == aPatri[nX,01]}),18] == "2"
					/*BEGINDOC
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤด[ฟ
					//ณSoma os Pดs dos patrim๔nios por contrato.ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤด[ู
					ENDDOC*/
										
					If Ascan(aTotP,{|x| x[1]+x[4] == aPatri[nX,01]+aPatri[nX,06]}) == 0
						Aadd(aTotP,{aPatri[nX,01],aPatri[nX,03],aPatri[nX,04],aPatri[nX,06],TRB->PS-TRB->P_ANT,;
									Posicione("SN1",2,xFilial("SN1")+AvKey(aPatri[nX,06],"N1_CHAPA"),"N1_XVOLMIN"),0})
					Else
						aTotP[Ascan(aTotP,{|x| x[1]+x[4] == aPatri[nX,01]+aPatri[nX,06]}),05] += TRB->PS-TRB->P_ANT
					EndIf
				EndIf
								
				DbSkip()
			EndDo
		Next nX
	EndIf
EndIf

//SEGUNDO GRID - ALTERADO DEPOIS DE APRESENTADO PARA O GUSTAVO. 09/06/14
For nX := 1 to len(aPatri)
	//Verifica se o patrimonio foi apontado nos contadores
	//cPerc1  := CTOD(SUBSTR(aPatri[nX,09],1,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-1)),3))
 //	cPerc2  := If(SUBSTR(aPatri[nX,09],1,2) >= substr(aPatri[nX,09],4,2),If(CTOD(SUBSTR(aPatri[nX,09],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-1)),3))>cPerc1,CTOD(SUBSTR(aPatri[nX,09],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-1)),3)),CTOD(SUBSTR(aPatri[nX,09],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03))),3))),CTOD(SUBSTR(aPatri[nX,09],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-1)),3)))
	//cPerc2  := If(SUBSTR(aPatri[nX,09],1,2) >= substr(aPatri[nX,09],4,2),If(CTOD(SUBSTR(aPatri[nX,09],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-1)),3))>cPer1,CTOD(SUBSTR(aPatri[nX,09],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-1)),3)),CTOD(SUBSTR(aPatri[nX,09],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03))),3))),If(Empty(CTOD(SUBSTR(aPatri[nX,09],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-1)),3))),lastday(cPer1),CTOD(SUBSTR(aPatri[nX,09],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-1)),3))))
    
	cQuery := "SELECT TOP 1 'ANTERIOR' AS N1,ZN_TIPINCL,ZN_DATA,ZN_PATRIMO,ZN_NUMATU,ZN_COTCASH,ZN_CONFERE,"
	cQuery += " ZN_BOTAO01,ZN_BOTAO02,ZN_BOTAO03,ZN_BOTAO04,ZN_BOTAO05,ZN_BOTAO06,ZN_BOTAO07,ZN_BOTAO08,ZN_BOTAO09,ZN_BOTAO10,ZN_BOTAO11,ZN_BOTAO12,"
	cQuery += " N1_XP1,N1_XP2,N1_XP3,N1_XP4,N1_XP5,N1_XP6,N1_XP7,N1_XP8,N1_XP9,N1_XP10,N1_XP11,N1_XP12,N1_XLOJA,ZN_PEDIDOS,Z1.R_E_C_N_O_ AS REC"
	cQuery += " FROM "+RetSQLName("SZN")+" Z1"
	cQuery += " INNER JOIN "+RetSQLName("SN1")+" N1 ON N1_CHAPA=ZN_PATRIMO AND N1.D_E_L_E_T_=''"
	//cQuery += " 	WHERE ZN_DATA BETWEEN '"+dtos(cPerc1-40)+"' AND '"+dtos(cPerc1-1)+"'"
	cQuery += " 	WHERE ZN_DATA BETWEEN '"+dtos(cPerc1-40)+"' AND '"+dtos(cPerc1)+"'"
	cQuery += " AND ZN_DATA =(SELECT MAX(ZN_DATA) FROM "+RetSQLName("SZN")+" ZN"
	cQuery += "					INNER JOIN "+RetSQLName("SN1")+" N1 ON N1_CHAPA=ZN_PATRIMO AND N1.D_E_L_E_T_=''"
	//cQuery += "					WHERE ZN_DATA BETWEEN '"+dtos(cPerc1-40)+"' AND '"+dtos(cPerc1-1)+"'"
	cQuery += "					WHERE ZN_DATA BETWEEN '"+dtos(cPerc1-40)+"' AND '"+dtos(cPerc1)+"'"
	cQuery += "					AND ZN.D_E_L_E_T_='' AND ZN_CLIENTE='"+aPatri[nX,03]+"' AND ZN_CONFERE='F' AND ZN_PATRIMO='"+aPatri[nX,06]+"')"
	cQuery += " 	AND Z1.D_E_L_E_T_='' AND ZN_CONFERE='F' AND ZN_PATRIMO='"+aPatri[nX,06]+"'"
	cQuery += " UNION ALL "	 
	cQuery += " SELECT 'ATUAL' AS N1,ZN_TIPINCL,ZN_DATA,ZN_PATRIMO,ZN_NUMATU,ZN_COTCASH,ZN_CONFERE,"
	cQuery += " ZN_BOTAO01,ZN_BOTAO02,ZN_BOTAO03,ZN_BOTAO04,ZN_BOTAO05,ZN_BOTAO06,ZN_BOTAO07,ZN_BOTAO08,ZN_BOTAO09,ZN_BOTAO10,ZN_BOTAO11,ZN_BOTAO12,"
	cQuery += " N1_XP1,N1_XP2,N1_XP3,N1_XP4,N1_XP5,N1_XP6,N1_XP7,N1_XP8,N1_XP9,N1_XP10,N1_XP11,N1_XP12,N1_XLOJA,ZN_PEDIDOS,ZN.R_E_C_N_O_ AS REC"
	cQuery += " FROM "+RetSQLName("SZN")+" ZN"
	cQuery += " INNER JOIN "+RetSQLName("SN1")+" N1 ON N1_CHAPA=ZN_PATRIMO AND N1.D_E_L_E_T_=''"
	cQuery += " 	WHERE ZN_DATA BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"'"
	cQuery += " 	AND ZN.D_E_L_E_T_='' AND ZN_PATRIMO='"+aPatri[nX,06]+"' AND ZN_CLIENTE='"+aPatri[nX,03]+"'"
	cQuery += " ORDER BY ZN_DATA"
	
	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf
	
	MemoWrite("TTPROC20.SQL",cQuery)
	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
	
	DbSelectArea("TRB")
	
	While !EOF()
	    Aadd(aBkL2,{aPatri[nX,01],TRB->ZN_PATRIMO,cvaltochar(stod(TRB->ZN_DATA)),TRB->ZN_NUMATU,TRB->ZN_COTCASH,TRB->ZN_TIPINCL,;
	    			TRB->ZN_BOTAO01,TRB->ZN_BOTAO02,TRB->ZN_BOTAO03,TRB->ZN_BOTAO04,TRB->ZN_BOTAO05,TRB->ZN_BOTAO06,TRB->ZN_BOTAO07,;
	    			TRB->ZN_BOTAO08,TRB->ZN_BOTAO09,TRB->ZN_BOTAO10,TRB->ZN_BOTAO11,TRB->ZN_BOTAO12,;
	    			TRB->N1_XP1,TRB->N1_XP2,TRB->N1_XP3,TRB->N1_XP4,TRB->N1_XP5,TRB->N1_XP6,TRB->N1_XP7,TRB->N1_XP8,TRB->N1_XP9,;
	    			TRB->N1_XP10,TRB->N1_XP11,TRB->N1_XP12,TRB->N1_XLOJA,If(TRB->N1=='ANTERIOR','FAnt',If(TRB->ZN_CONFERE=="F",'FAtu','Int')),;
	    			TRB->ZN_PEDIDOS,TRB->REC})
		Dbskip()
	EndDo

Next nX

			/*BEGINDOC
									//ฺฤฤฤฤฤฤฤฤฤฤฟ
									//ณValida็๕esณ
									//ภฤฤฤฤฤฤฤฤฤฤู
		
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAuditoria 1                                                    ณ
			//ณ                                                               ณ
			//ณ      Todos os Patrim๔nios tiveram seus contadores registrados?ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			ENDDOC*/ 
			
For nX := 1 to len(aPatri)
	//Verifica se o patrimonio foi apontado nos contadores
	//cPerc1 := If(SUBSTR(aPatri[nX,12],1,2) > substr(aPatri[nX,12],4,2),CTOD(SUBSTR(aPatri[nX,12],1,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03))),3)),CTOD(SUBSTR(aPatri[nX,12],1,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-1)),3))) //CTOD(SUBSTR(aPatri[nX,12],1,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03))),3))
	//cPerc2 := If(SUBSTR(aPatri[nX,12],1,2) > substr(aPatri[nX,12],4,2),CTOD(SUBSTR(aPatri[nX,12],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03))),3)),CTOD(SUBSTR(aPatri[nX,12],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-1)),3))) //CTOD(SUBSTR(aPatri[nX,12],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03))),3)) 
    
 	AuditCant(aPatri[nX,06],aPatri[nX,10],aPatri[nX,11],cPerc1,cPerc2,aPatri[nX,01])
 	
	If Ascan(aConta,{|x| x[6] == aPatri[nX,06]}) == 0
		aPatri[nX,08] -= 1                           
		//Array com as informacoes das auditorias realizadas.
		//formato - 1 col = Numero da auditoria, 2 col = Numero do patrimonio, 3 col = valor mes, 4 col = valor anterior,5 col = Status, 6 col = Contrato
		Aadd(aAudit1c,{1,aPatri[nX,06],'','','Nใo apontado',aPatri[nX,01]})
	Else
		Aadd(aAudit1c,{1,aPatri[nX,06],'','','OK',aPatri[nX,01]})			
			/*BEGINDOC
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณContador atual ้ maior que o Contador Anterior?ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			ENDDOC*/

		For nY := 1 to len(aConta)
			If aConta[nY,01] == aPatri[nX,01] .And. aConta[nY,06] == aPatri[nX,06]
				If aConta[nY,10] < aConta[nY,09]
					If Ascan(aAudit1c,{|x| cvaltochar(x[1])+x[2] == '2'+aConta[nY,06]}) == 0
						Aadd(aAudit1c,{2,aConta[nY,06],aConta[nY,10],aConta[nY,09],'Divergente',aConta[nY,01]}) 
					EndIf
					aPatri[nX,08] -= 1
				Else
					If Ascan(aAudit1c,{|x| cvaltochar(x[1])+x[2] == '2'+aConta[nY,06]}) == 0
						Aadd(aAudit1c,{2,aConta[nY,06],aConta[nY,10],aConta[nY,09],'OK',aConta[nY,01]})
					EndIf
				EndIf
				
				//    Soma dos Pดs eh igual a contador atual - contador anterior?  //
				//ALTERADO DEPOIS DE PRONTO, RODRIGO INFORMOU QUE OS CONTADORES AGORA SAO ACUMULADOS
				If aConta[nY,11] != (aConta[nY,12] - aConta[nY,15])
					If Ascan(aAudit1c,{|x| cvaltochar(x[1])+x[2] == '3'+aConta[nY,06]}) == 0
						Aadd(aAudit1c,{3,aConta[nY,06],(aConta[nY,12] - aConta[nY,15]),aConta[nY,11],'Divergente',aConta[nY,01]})
					EndIf
					aPatri[nX,08] -= 1 
				Else
                	If Ascan(aAudit1c,{|x| cvaltochar(x[1])+x[2] == '3'+aConta[nY,06]}) == 0
						Aadd(aAudit1c,{3,aConta[nY,06],(aConta[nY,12] - aConta[nY,15]),aConta[nY,11],'OK',aConta[nY,01]})
					EndIf
				EndIf                 
			EndIf
		Next nY
	EndIf
	
	If aPatri[nX,08] == 0
		//Verifica se o cliente ja esta no array ou nao para exibicao na tela.
		If Ascan(aList,{|x| x[1] == aPatri[nX,03]}) == 0
			Aadd(aList,{aPatri[nX,03],aPatri[nX,04],'','','','','','','OK','','','','','',;
						Posicione("SA1",1,xFilial("SA1")+aPatri[nX,03]+aPatri[nX,04],"A1_NOME"),;
						'SERVIวO DE CAFษ',UsrFullName(aContr[Ascan(aContr,{|x| x[1] == aPatri[nX,01]}),07]),;
						aPatri[nX,01],aPatri[nX,10],aPatri[nX,11],'',cPerc1,cPerc2,'0'})
		Else
			If aList[Ascan(aList,{|x| x[1] == aPatri[nX,03]}),09] != 'NOK'
				aList[Ascan(aList,{|x| x[1] == aPatri[nX,03]}),09] := 'OK'
			EndIf
		EndIf
	Else 
		If Ascan(aList,{|x| x[1] == aPatri[nX,03]}) == 0
			Aadd(aList,{aPatri[nX,03],aPatri[nX,04],'','','','','','','NOK','','','','','',;
						Posicione("SA1",1,xFilial("SA1")+aPatri[nX,03]+aPatri[nX,04],"A1_NOME"),;
						'SERVIวO DE CAFษ',UsrFullName(aContr[Ascan(aContr,{|x| x[1] == aPatri[nX,01]}),07]),;
						aPatri[nX,01],aPatri[nX,10],aPatri[nX,11],'',cPerc1,cPerc2,'0'})
		Else
			If aList[Ascan(aList,{|x| x[1] == aPatri[nX,03]}),09] != 'NOK'
				aList[Ascan(aList,{|x| x[1] == aPatri[nX,03]}),09] := 'NOK'
			EndIf
		EndIf
		
	EndIf
Next nX

// **************   VALIDACAO Insumos enviados para o cliente X doses apontadas   ******************* //    
//    Aadd(aContr,{TRB->CN9_NUMERO,TRB->CN9_DTFIM,TRB->CN9_SITUAC,TRB->CN9_CONDPG,TRB->CN9_CLIENT,TRB->CN9_LOJACL,TRB->CN9_XANLAT,;
//    				TRB->CN9_XANLBK,TRB->CN9_XPCOMP,TRB->CN9_XTPFAT,TRB->CN9_XTPCNT})              
/*
For nX := 1 to len(aContr)
	//Periodo de faturamento
	cPer1  := CTOD(SUBSTR(aContr[nX,09],1,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-1)),3))
	cPer2  := If(SUBSTR(aContr[nX,09],1,2) >= substr(aContr[nX,09],4,2),CTOD(SUBSTR(aContr[nX,09],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03))),3)),CTOD(SUBSTR(aContr[nX,09],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-1)),3))) 
	
	//cQuery := "SELECT D3_COD,B1_DESC,D3_LOCAL,ZZ1_DESCRI,SUM(D3_QUANT) AS QTD"
	If aContr[nX,10] == "1"
		cQuery := "SELECT D3_COD,B1_DESC,SUBSTRING(ZZ1_ITCONT,1,6) AS ZZ1_ITCONT,SUM(D3_QUANT) AS QTD"
	Else
		cQuery := "SELECT D3_COD,B1_DESC,SUBSTRING(ZZ1_ITCONT,1,10) AS ZZ1_ITCONT,SUM(D3_QUANT) AS QTD"
	EndIf
	cQuery += " FROM "+RetSQLName("SD3")+" D3"
	cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=D3_COD AND B1.D_E_L_E_T_='' AND B1_XSECAO='007'"
	cQuery += " INNER JOIN "+RetSQLName("ZZ1")+" Z1 ON ZZ1_COD=D3_LOCAL AND Z1.D_E_L_E_T_=''"
	cQuery += " WHERE D3_FILIAL='"+xFilial("SD3")+"' AND D3_EMISSAO BETWEEN '"+dtos(cPer1)+"' AND '"+dtos(cPer2)+"'"
	cQuery += " AND D3_LOCAL IN(SELECT ZZ1_COD FROM "+RetSQLName("ZZ1")
	//Tipo de faturamento do contrato
	If aContr[nX,10] == "1"
		cQuery += " 				WHERE SUBSTRING(ZZ1_ITCONT,1,6)='"+aContr[nX,05]+"'"
	Else
		cQuery += " 				WHERE SUBSTRING(ZZ1_ITCONT,1,10)='"+aContr[nX,05]+aContr[nX,06]+"'" 
	EndIf                                 
	
	cQuery += " 				AND D_E_L_E_T_='')"
	
	cQuery += " AND D3.D_E_L_E_T_='' AND D3_XNUMNF<>'' "
	cQuery += " GROUP BY D3_COD,B1_DESC,ZZ1_ITCONT"
	cQuery += " ORDER BY D3_COD"
   
	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf
	
	MemoWrite("TTPRO20.SQL",cQuery)
	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
	
	DbSelectArea("TRB")
	
	While !EOF()
	    Aadd(aInsumo,{TRB->D3_COD,TRB->B1_DESC,TRB->ZZ1_ITCONT,TRB->QTD,0})
		Dbskip()
	EndDo
	
Next nX 

aCalDos := aDoses()

For nX := 1 to len(aCalDos)
	If Ascan(aInsumo,{|x| x[3]+x[1] = aCalDos[nX,01]+aCalDos[nX,05]}) > 0
		aCalDos[nX,09] := aInsumo[Ascan(aInsumo,{|x| x[3]+x[1] = aCalDos[nX,01]+aCalDos[nX,05]}),04]
	EndIf	
Next nX
//Validando se todos os insumos enviados batem com a quantidade de doses consumidas.  

For nX := 1 to len(aCalDos)
	If aCalDos[nX,08] <> aCalDos[nX,09] .And. Ascan(aList,{|x| x[1] == aCalDos[nX,01]}) > 0
		If aList[Ascan(aList,{|x| x[1] == aCalDos[nX,01]}),05] != 'NOK'
			aList[Ascan(aList,{|x| x[1] == aCalDos[nX,01]}),05] := 'NOK'
		EndIf 
	Else
		If Ascan(aList,{|x| x[1] == aCalDos[nX,01]}) > 0
			If aList[Ascan(aList,{|x| x[1] == aCalDos[nX,01]}),05] != 'NOK' 
				aList[Ascan(aList,{|x| x[1] == aCalDos[nX,01]}),05] := 'OK'
			EndIf
		EndIf
	EndIf
Next nX 
*/
// ****************   Valida็ใo dos contadores dos ultimos 3 meses com o faturamento atual   *************  //
/*
For nX := 1 to len(aPatri)
	cPer1  := CTOD(SUBSTR(aPatri[nX,09],1,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-90)),3))
	cPer2  := If(SUBSTR(aPatri[nX,09],1,2) >= substr(aPatri[nX,09],4,2),CTOD(SUBSTR(aPatri[nX,09],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-30)),3)),CTOD(SUBSTR(aPatri[nX,09],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-60)),3)))
	
	cQuery := "SELECT ZN_PATRIMO,"
	cQuery += " AVG(ZN_BOTAO01+ZN_BOTAO02+ZN_BOTAO03+ZN_BOTAO04+ZN_BOTAO05+ZN_BOTAO06+ZN_BOTAO07+ZN_BOTAO08+ZN_BOTAO09+ZN_BOTAO10+ZN_BOTAO11+ZN_BOTAO12) AS PS"
	cQuery += "  FROM "+RetSQLName("SZN")
	cQuery += " WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_=''"
	cQuery += " AND ZN_DATA BETWEEN '"+DTOS(cPer1)+"' AND '"+DTOS(cPer2)+"' AND ZN_CLIENTE='"+aPatri[nX,03]+"'"
	cQuery += " GROUP BY ZN_PATRIMO"
	cQuery += " ORDER BY 2,1"

	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf
	
	MemoWrite("TTPRO20.SQL",cQuery)
	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
	
	DbSelectArea("TRB")
	
	While !EOF()
		Aadd(aMed3mP,{TRB->ZN_PATRIMO,TRB->PS})
		DbSkip()
	EndDo
Next nX

//Validando a media dos ultimos 3 meses de contadores por patrimonio
For nX := 1 to len(aConta)
	If Ascan(aMed3MP,{|x| x[1] == aConta[nX,06]}) > 0
		If aConta[nX,12] < aMed3mP[Ascan(aMed3MP,{|x| x[1] == aConta[nX,06]}),02]
			//Auditoria contadores
			If Ascan(aAudit1c,{|x| cvaltochar(x[1])+x[2] == '4'+aConta[nX,06]}) == 0
				Aadd(aAudit1c,{4,aConta[nX,06],aConta[nX,12],aMed3mP[Ascan(aMed3MP,{|x| x[1] == aConta[nX,06]}),02],'Divergente',aConta[nX,01]})
			EndIf
			
			If aList[Ascan(aList,{|x| x[1] == aConta[nX,03]}),10] != 'NOK'
				aList[Ascan(aList,{|x| x[1] == aConta[nX,03]}),10] := 'NOK'
			EndIf 
   		Else 
   			If Ascan(aAudit1c,{|x| cvaltochar(x[1])+x[2] == '4'+aConta[nX,06]}) == 0
				Aadd(aAudit1c,{4,aConta[nX,06],aConta[nX,12],aMed3mP[Ascan(aMed3MP,{|x| x[1] == aConta[nX,06]}),02],'OK',aConta[nX,01]})
			EndIf
			If aList[Ascan(aList,{|x| x[1] == aConta[nX,03]}),10] != 'NOK'
				aList[Ascan(aList,{|x| x[1] == aConta[nX,03]}),10] := 'OK'
			EndIf	
		EndIf
	Else
		If aList[Ascan(aList,{|x| x[1] == aConta[nX,03]}),10] != 'NOK'
			aList[Ascan(aList,{|x| x[1] == aConta[nX,03]}),10] := 'OK'
		EndIf	
	EndIf
Next nX                              
*/
// *****************************  Validacao das Sangrias X Consumos das maquinas   ********************************* // 
/*
For nX := 1 to len(aPatri)
	cPer1  := CTOD(SUBSTR(aPatri[nX,09],1,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-30)),3))
	cPer2  := If(SUBSTR(aPatri[nX,09],1,2) >= substr(aPatri[nX,09],4,2),CTOD(SUBSTR(aPatri[nX,09],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03))),3)),CTOD(SUBSTR(aPatri[nX,09],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-30)),3)))

	cQuery := "SELECT ZN_PATRIMO,ZN_COTCASH,ZN_MOEDA1R+ZN_NOTA01 AS DIN,ZN_DATA"
	cQuery += ",(SELECT TOP 1 ZN_COTCASH FROM "+RetSQLName("SZN")+" Z WITH(NOLOCK) WHERE Z.ZN_PATRIMO=ZN.ZN_PATRIMO AND ZN_TIPINCL='SANGRIA' AND ZN_DATA<'"+dtos(cPer1)+"' AND D_E_L_E_T_='' ORDER BY ZN_DATA DESC) AS ZN_MESANT"
  	cQuery += " FROM "+RetSQLName("SZN")+" ZN"
	cQuery += " WHERE ZN_TIPINCL='SANGRIA' AND ZN_DATA BETWEEN '"+dtos(cPer1)+"' AND '"+dtos(cPer2)+"'"
	cQuery += " AND ZN_PATRIMO = '"+aPatri[nX,06]+"'"
	cQuery += " AND D_E_L_E_T_=''"
	 
	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf
	
	MemoWrite("TTPRO20.SQL",cQuery)
	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
	
	DbSelectArea("TRB")
	
	While !EOF()
		Aadd(aSangria,{aPatri[nX,01],aPatri[nX,03],aPatri[nX,04],TRB->ZN_PATRIMO,TRB->ZN_COTCASH - TRB->ZN_MESANT,TRB->ZN_DATA,TRB->DIN,aPatri[nX,10],aPatri[nX,11],aPatri[nX,12]})
		DbSkip()
	EndDo
	
   	cQuery := "SELECT ZZE_PATRIM,ZZE_REDE,ZZE_PRODUT,SUM(ZZE_VLRBRU) AS VALOR FROM "+RetSQLName("ZZE")
	cQuery += " WHERE ZZE_DATATR BETWEEN '"+dtos(cPer1)+"' AND '"+dtos(cPer2)+"' AND ZZE_PATRIM='"+aPatri[nX,06]+"' AND D_E_L_E_T_=''"
	cQuery += " GROUP BY ZZE_PATRIM,ZZE_REDE,ZZE_PRODUT"
	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf
	
	MemoWrite("TTPRO20.SQL",cQuery)
	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
	
	DbSelectArea("TRB")
	
	While !EOF()
		Aadd(aMoel,{aPatri[nX,01],aPatri[nX,03],aPatri[nX,04],TRB->ZZE_PATRIM,TRB->VALOR,TRB->ZZE_REDE,TRB->ZZE_PRODUT,aPatri[nX,10],aPatri[nX,11],aPatri[nX,12]})
		DbSkip()
	EndDo

Next nX

// ****  Validando os valores recebidos com a quantidade de doses consumidas

For nX := 1 to len(aSangria)
	If Ascan(aVlrRe,{|x| x[1] = aSangria[nX,01]}) == 0
		Aadd(aVlrRe,{aSangria[nX,01],aSangria[nX,02],aSangria[nX,03],aSangria[nX,05],0})
	Else
		aVlrRe[Ascan(aVlrRe,{|x| x[1] = aSangria[nX,01]}),04] += aSangria[nX,05]
	EndIf
Next nX

For nX := 1 to len(aMoel)
	If Ascan(aVlrRe,{|x| x[1] = aMoel[nX,01]}) == 0
		Aadd(aVlrRe,{aMoel[nX,01],aMoel[nX,02],aMoel[nX,03],aMoel[nX,05],0})
	Else
		aVlrRe[Ascan(aVlrRe,{|x| x[1] = aMoel[nX,01]}),04] += aMoel[nX,05]
	EndIf
Next nX                               
*/
//Validacao final de valores recebidos  
/*
nTotV	:=	0
For nX := 1 to len(aConta)
	cQuery := "SELECT AVG(DA1_PRCVEN+DA1_XPRCPP) AS VLR"
	cQuery += " FROM "+RetSQLName("DA1")+" DA"
	cQuery += " INNER JOIN "+RetSQLName("DA0")+" D0 ON DA0_CODTAB=DA1_CODTAB AND DA0_XCLIEN='"+aConta[nX,03]+"' AND DA0_XLOJA='"+aConta[nX,04]+"'
	cQuery += " WHERE DA.D_E_L_E_T_=''" 	
	
	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf
	
	MemoWrite("TTPRO20.SQL",cQuery)
	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
	
	DbSelectArea("TRB")
	
	nTotV := (TRB->VLR) * aConta[nX,12]
	
	For nY := 1 to len(aVlrRe)
		If aVlrRe[nY,01] == aConta[nX,01] 
			aVlrRe[nY,05] += nTotV
		EndIf
	Next nY
Next nX

For nX := 1 to len(aConta)
	If Ascan(aVlrRe,{|x| x[1] == aConta[nX,01]}) > 0
		If aVlrRe[Ascan(aVlrRe,{|x| x[1] == aConta[nX,01]}),4] <> aVlrRe[Ascan(aVlrRe,{|x| x[1] == aConta[nX,01]}),5]
			If aList[Ascan(aList,{|x| x[1] == aConta[nX,03]}),07] != 'NOK'
				aList[Ascan(aList,{|x| x[1] == aConta[nX,03]}),07] := 'NOK'
			EndIf 
   		Else
			If aList[Ascan(aList,{|x| x[1] == aConta[nX,03]}),07] != 'NOK'
				aList[Ascan(aList,{|x| x[1] == aConta[nX,03]}),07] := 'OK'
			EndIf	
		EndIf
	Else
		If aList[Ascan(aList,{|x| x[1] == aConta[nX,03]}),07] != 'NOK'
			aList[Ascan(aList,{|x| x[1] == aConta[nX,03]}),07] := 'OK'
		EndIf	
	EndIf
Next nX   		

// Validacao de duplicidade de registro de um mesmo patrimonio para lojas diferentes do cliente no periodo.
If len(aConta) > 0
	aBkConta	:=	aClone(aConta)
	Asort(aBkConta,,,{|x,y| x[6] < y[6]})
	cPtBk	:=	aBkConta[1,6]
	cClBk	:=	aBkConta[1,3]+aBkConta[1,4]
	cCnBk	:=	aBkConta[1,1]
	
	For nX := 2 to len(aBkConta)
		If aBkConta[nX,06] == cPtBk .And. aBkConta[nX,03]+aBkConta[nX,04] != cClBk
			aadd(aDuplic,{cCnBk,cPtBk,substr(cClBk,1,6),substr(cClBk,7,4)})
			aadd(aDuplic,{aBkConta[nX,01],aBkConta[nX,06],aBkConta[nX,03],aBkConta[nX,04]})  
		EndIf
		
		If aBkConta[nX,06] != cPtBk
			cPtBk	:=	aBkConta[nX,6]
			cClBk	:=	aBkConta[nX,3]+aBkConta[nX,4]
		EndIf		
	Next nX 	                                               
	
	If len(aDuplic) > 0
		For nX := 1 to len(aDuplic)
			aList[Ascan(aList,{|x| x[18] == aDuplic[nX,01]}),21] := 'NOK'
		Next nX
	Else
		For nX := 1 to len(aList)
			aList[nX,21] := 'OK'
		Next nX
	EndIf
EndIf     
*/
/*BEGINDOC
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤot&)เ:)4ฟ
//ณ                Auditoria de Pre็o Unitแrio                ณ
//ณ                                                           ณ
//ณ  Serao auditados os valores presentes na tabela de pre็o  ณ
//ณcom os valores constantes no ultimo faturamento para este  ณ
//ณcliente.                                                   ณ
//ณ                                                           ณ
//ณ   Valida็ใo de Pดs X Tabela de Pre็o                      ณ
//ณ     Verifica็ใo se todos os Ps informados nos patrimonios ณ
//ณ tem seu devido pre็o cadastrado na tabela.                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤoู
ENDDOC*/    
/*
For nPP := 1 to len(aContr)

	cQuery := "SELECT DA0_CODTAB FROM "+RetSQLName("DA0")+" WHERE DA0_XCLIEN='"+aContr[nPP,05]+"' AND DA0_XLOJA='"+aContr[nPP,06]+"' AND DA0_ATIVO='1' AND D_E_L_E_T_=''"
	
	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf
	
	MemoWrite("TTPRO20.SQL",cQuery)
	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
	
	DbSelectArea("TRB") 
	
	cTable := TRB->DA0_CODTAB
	
	cQuery := "SELECT N1_CHAPA,N1_DESCRIC,N1_XTPSERV"+chr(13)+chr(10)
	
	For nX := 1 to 12
		cQuery += ",N1_XP"+cvaltochar(nX)+",B"+cvaltochar(nX)+".B1_DESC AS DESC"+cvaltochar(nX)+",T"+cvaltochar(nX)+".DA1_PRCVEN AS PRCE"+cvaltochar(nX)+",T"+cvaltochar(nX)+".DA1_XPRCPP AS PRCP"+cvaltochar(nX)+chr(13)+chr(10)
	Next nX
	
	cQuery += " FROM "+RetSQLName("SN1")+" N1"+chr(13)+chr(10)
	
	For nX := 1 to 12
		cQuery += " LEFT JOIN "+RetSQLName("SB1")+" B"+cvaltochar(nX)+" ON B"+cvaltochar(nX)+".B1_COD=N1_XP"+cvaltochar(nX)+" AND B"+cvaltochar(nX)+".D_E_L_E_T_=''"+chr(13)+chr(10)
	Next nX
	
	For nX := 1 to 12
		cQuery += " LEFT JOIN "+RetSQLName("DA1")+" T"+cvaltochar(nX)+" ON T"+cvaltochar(nX)+".DA1_CODTAB='"+cTable+"' AND T"+cvaltochar(nX)+".DA1_CODPRO=N1_XP"+cvaltochar(nX)+" AND T"+cvaltochar(nX)+".D_E_L_E_T_=''"+chr(13)+chr(10)
	Next nX
	
	cQuery += " WHERE N1_XCLIENT='"+aContr[nPP,05]+"' AND N1_XTPSERV IN('2','6') AND N1.D_E_L_E_T_=''"+chr(13)+chr(10)
	
	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf
	
	MemoWrite("TTPRO20.SQL",cQuery)
	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
	
	DbSelectArea("TRB") 
    
	While !EOF()
		Aadd(aVlUnit,{aContr[nPP,01],TRB->N1_CHAPA,TRB->N1_DESCRIC,;
						TRB->N1_XP1,TRB->DESC1,TRB->PRCE1,TRB->PRCP1,;
						TRB->N1_XP2,TRB->DESC2,TRB->PRCE2,TRB->PRCP2,;
						TRB->N1_XP3,TRB->DESC3,TRB->PRCE3,TRB->PRCP3,;
						TRB->N1_XP4,TRB->DESC4,TRB->PRCE4,TRB->PRCP4,;
						TRB->N1_XP5,TRB->DESC5,TRB->PRCE5,TRB->PRCP5,;
						TRB->N1_XP6,TRB->DESC6,TRB->PRCE6,TRB->PRCP6,;
						TRB->N1_XP7,TRB->DESC7,TRB->PRCE7,TRB->PRCP7,;
						TRB->N1_XP8,TRB->DESC8,TRB->PRCE8,TRB->PRCP8,;
						TRB->N1_XP9,TRB->DESC9,TRB->PRCE9,TRB->PRCP9,;
						TRB->N1_XP10,TRB->DESC10,TRB->PRCE10,TRB->PRCP10,;
						TRB->N1_XP11,TRB->DESC11,TRB->PRCE11,TRB->PRCP11,;
						TRB->N1_XP12,TRB->DESC12,TRB->PRCE12,TRB->PRCP12})
                                                                           
		For nY := 1 to 12
			If Ascan(aAudPrM,{|x| x[1]+x[2] == aContr[nPP,01]+&("TRB->N1_XP"+cvaltochar(nY))}) == 0
				Aadd(aAudPrM,{aContr[nPP,01],&("TRB->N1_XP"+cvaltochar(nY)),&("TRB->PRCE"+cvaltochar(nY)),0,aContr[nPP,09],&("TRB->DESC"+cvaltochar(nY)),aContr[nPP,05],'',&("TRB->PRCP"+cvaltochar(nY)),0})
			EndIf
		Next nY
				
		DbSkip()
	EndDo
	
Next nPP

For nX := 1 to len(aAudPrM)
	cPer1  := CTOD(SUBSTR(aAudPrM[nX,05],1,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-60)),3))
	cPer2  := If(SUBSTR(aAudPrM[nX,05],1,2) >= substr(aAudPrM[nX,05],4,2),CTOD(SUBSTR(aAudPrM[nX,05],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-30)),3)),CTOD(SUBSTR(aAudPrM[nX,05],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-60)),3)))

	cQuery	:= "SELECT DISTINCT D2_COD,B1_DESC,D2_PRCVEN,D2_EMISSAO"
	cQuery 	+= " FROM "+RetSQLName("SD2")+" D2"
	cQuery 	+= " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=D2_COD AND B1.D_E_L_E_T_=''"
 	cQuery 	+= " WHERE D2_CLIENTE='"+aAudPrM[nX,07]+"' AND D2_EMISSAO BETWEEN '"+dtos(cPer1)+"' AND '"+dtos(cPer2)+"' AND D2.D_E_L_E_T_=''"  
 	cQuery 	+= " AND D2_COD='"+aAudPrM[nX,02]+"'" 
 	cQuery 	+= " ORDER BY D2_EMISSAO DESC"
	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf
	
	MemoWrite("TTPRO20.SQL",cQuery)
	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
	
	DbSelectArea("TRB") 
    
    aAudPrM[nX,04] := TRB->D2_PRCVEN
    aAudPrM[nX,08] := TRB->D2_EMISSAO
	
Next nX

For nX := 1 to len(aAudPrM)            
	If Ascan(aList,{|x| x[18] == aAudPrM[nX,01]}) > 0
			
		If aAudPrM[nX,03] != aAudPrM[nX,04]
			aList[Ascan(aList,{|x| x[18] == aAudPrM[nX,01]}),12] := 'NOK'
		Else                                  
			If aList[Ascan(aList,{|x| x[18] == aAudPrM[nX,01]}),12] != 'NOK'
				aList[Ascan(aList,{|x| x[18] == aAudPrM[nX,01]}),12] := 'OK'
			EndIf
		EndIf
	EndIf
Next nX     

For nX := 1 to len(aConta)
	If Ascan(aList,{|x| x[18] == aConta[nX,01]}) > 0
		aList[Ascan(aList,{|x| x[18] == aConta[nX,01]}),14] := aConta[nX,18]
		
		aAuxP := strtokarr(aList[Ascan(aList,{|x| x[18] == aConta[nX,01]}),14],"/")
		nAuxP := 0
	
		For nY := 1 to len(aAuxP)
			cQuery := "SELECT SUM(C6_VALOR) AS VALOR FROM "+RetSQLName("SC6")+" WHERE C6_FILIAL='"+xFilial("SC6")+"' AND C6_NUM='"+aAuxP[nY]+"' AND D_E_L_E_T_=''"
				
			If Select('TRB') > 0
				dbSelectArea('TRB')
				dbCloseArea()
			EndIf
			
			MemoWrite("FatCafe.SQL",cQuery)
			DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
			
			DbSelectArea("TRB") 
			nAuxP += TRB->VALOR
		Next nX
		
		aList[Ascan(aList,{|x| x[18] == aConta[nX,01]}),13] :=  Transform(round(nAuxP,2),"@E 999,999,999.99")
	
	EndIf
Next nX
*/                                
RestArea(aArea)


Return                 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC20  บAutor  ณMicrosiga           บ Data ณ  09/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Consulta detalhes do fechamento (Cafe)                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static  Function ConsFech(cTipo,aItens,nPos,lPlan)

Local aArea	:=	GetArea()
Local oG1,oSS1,oSs2,oSs3,oSs4,oSs5,oSs6,oG2,oBrw1,oBtn1,oBtn2,oBtn4
Local aBkpIt	:=	aClone(aItens)
Local oBList	:=	oList                                                   
Private oObj,oDlg2


If !lPlan
	//	  1		 2		  3		  4			  5					6					7				8			9
	//'Codigo','Loja','Estoque','Log','Abast. X Cons.','Recarga X Sangria','Consumo X Contador','Pro-Rata','Contador',
	//			10				 11				12				13		 14            15		   16		  17		  18	
	//'Faturamento Medio','Log X Contador','Valor Unit.','Valor Total','Pedidos','NOMECLIENTE','ANALISTA','TIPOCONTRA','CONTRATO' 
	
	oDlg2      := MSDialog():New( 091,232,570,1019,"Consulta "+cTipo,,,.F.,,,,,,.T.,,,.T. )
		oG1      := TGroup():New( 004,004,056,384,"Contrato",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
			oSS1      := TSay():New( 016,080,{||"Cliente"},oG1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
			oSs2      := TSay():New( 016,112,{||aItens[1,1]},oG1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,232,008)
			oSs3      := TSay():New( 032,016,{||"Contrato"},oG1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)
			oSs4      := TSay():New( 032,044,{||aItens[1,2]},oG1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,008)
			oSs5      := TSay():New( 032,212,{||"Tipo Contrato"},oG1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
			oSs6      := TSay():New( 032,260,{||aItens[1,3]},oG1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,112,008)
		
		oG2      := TGroup():New( 060,004,204,384,"Lan็amentos",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
			//oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{072,012,196,376},,, oG2 ) 
			oObj := TCBrowse():New(072,012,360,130,, {'Patrimonio','Data','Num. Ant.','Num. Atual','Diferenca','Contador Ps'},;
														{50,30,40,40,40,40},;
		                            oG2,,,,{|| },{|| },, ,,,  ,,.F.,,.T.,,.F.,,.T.,.T.)
			oObj:SetArray(aItens)                    
			oObj:bLine := {||{ aItens[oObj:nAt,04],; 
			 					 aItens[oObj:nAt,05],;
			 					 aItens[oObj:nAt,06],;
			                     aItens[oObj:nAt,07],;
			                     aItens[oObj:nAt,08],;
			                     aItens[oObj:nAt,09]}}
			                     
		
		//oBtn1      := TButton():New( 212,084,"Filtrar",oDlg2,{||filcns(aItens,aBkpIt)},037,012,,,,.T.,,"",,,,.F. )
		oBtn2      := TButton():New( 212,084,"Faturamento",oDlg2,{||FatCafe(aBkpIt,.F.)},037,012,,,,.T.,,"",,,,.F. )
		//oBtn3      := TButton():New( 212,200,"Insumos",oDlg2,{||CnsIns(aItens[1,1])},037,012,,,,.T.,,"",,,,.F. )
		//aAudit1c
		oBtn3      := TButton():New( 212,150,"Apurar Div.",oDlg2,{||U_TTPROC21(aAudit1c,aItens[1,1],aItens[1,2],aItens[1,3],1)},037,012,,,,.T.,,"",,,,.F. )
		oBtn4      := TButton():New( 212,260,"Sair",oDlg2,{||oDlg2:end()},037,012,,,,.T.,,"",,,,.F. )
	
	oDlg2:Activate(,,,.T.)
Else
	FatCafe(aBkpIt,.T.)
EndIf
	
RestArea(aArea) 

oBList := oList

Return  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC20  บAutor  ณMicrosiga           บ Data ณ  09/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   filtro                                                   บฑฑ
ฑฑบ          ณ DESABILITADO                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function filcns(aArray1,aArray2)
      
Local aArea		:=	GetArea()
Local aPergs    :=	{}
Local aOpcoes	:=	{"Divergentes","Liberados","Limpar Filtro"}
Local aRet		:=	{}
Local aAux		:=	{}
Local aItens	:=	{}

aAdd(aPergs ,{2,"Op็ใo Filtro"		,aOpcoes[1],aOpcoes,50,"",.F.})														//[17]

If ParamBox(aPergs,"Parโmetros",aRet)
	If substr(aRet[1],1,1) == "D"
		For nX := 1 to len(aArray2)
			If aArray2[nX,08] != aArray2[nX,09]
				Aadd(aAux,aArray2[nX])
			EndIf
		Next nX
	ElseIf substr(aRet[1],1,1) == "L"
		For nX := 1 to len(aArray2)
			If aArray2[nX,08] == aArray2[nX,09]
				Aadd(aAux,aArray2[nX])
			EndIf
		Next nX
	Else
		aAux := aClone(aArray1)
	EndIf
EndIf

If len(aAux) > 0
		aItens := aClone(aAux)
		oObj:SetArray(aItens)                    
		oObj:bLine := {||{ aItens[oObj:nAt,04],; 
		 					 aItens[oObj:nAt,05],;
		 					 aItens[oObj:nAt,06],;
		                     aItens[oObj:nAt,07],;
		                     aItens[oObj:nAt,08],;
		                     aItens[oObj:nAt,09]}}
		oObj:refresh()
		oDlg2:refresh()
EndIf

RestArea(aArea)

Return                                                         

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC20  บAutor  ณMicrosiga           บ Data ณ  09/13/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Tela que exibe o que sera faturado e suas quantidades.    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FatCafe(aItens,lPlan)

Local aArea	:=	GetArea()
Local cQuery 
Local oDlgF1,oGrp1,oSay1,oSay2,oSay3,oSay4,oSay5,oSay6,oSay7,oSay8,oSay9,oSay10,oSay11,oSay12,oSay13,oSay14,oGrp2,oBrw1,oSBtn2,oSBtn3
Local aFat	:=	{}
Local aVlr	:=	{}
Local cPat	:=	'' 
Local nTotDos	:=	0 
Local aCP	:=	{}
Local aXP	:=	{}
Local cTab	:=	''     
Local nOpi	:=	0
Local nNeMin 	:=	0
Private aProd	:=	{}
Private aProRa:=	{}

//	1		 2			3			4		5		6		7		 8		 	9
//cliente,contrato,tipocontrato,patrimonio,data,numerant,numatual,diferenca,contadorps
For nX := 1 to len(aItens)
    If !Alltrim(aItens[nX,04]) $ cPat  
    	cPat += Alltrim(aItens[nX,04])+"/"
    	cPer1 := aConta[aScan(aConta,{|x| x[6] == aItens[nX,04]}),13]
    	cPer2 := aConta[aScan(aConta,{|x| x[6] == aItens[nX,04]}),14]
    	cPerc1 := aConta[aScan(aConta,{|x| x[6] == aItens[nX,04]}),16] //If(SUBSTR(aConta[aScan(aConta,{|x| x[6] == aItens[nX,04]}),16],1,2) > substr(aConta[aScan(aConta,{|x| x[6] == aItens[nX,04]}),17],4,2),CTOD(SUBSTR(aConta[aScan(aConta,{|x| x[6] == aItens[nX,04]}),16],1,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-1)),3)),CTOD(SUBSTR(aConta[aScan(aConta,{|x| x[6] == aItens[nX,04]}),16],1,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03))),3))) //CTOD(SUBSTR(aPatri[nX,12],1,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03))),3))
		cPerc2 := aConta[aScan(aConta,{|x| x[6] == aItens[nX,04]}),17] //If(SUBSTR(aConta[aScan(aConta,{|x| x[6] == aItens[nX,04]}),17],1,2) > substr(aConta[aScan(aConta,{|x| x[6] == aItens[nX,04]}),17],4,2),CTOD(SUBSTR(aConta[aScan(aConta,{|x| x[6] == aItens[nX,04]}),16],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03))),3)),CTOD(SUBSTR(aConta[aScan(aConta,{|x| x[6] == aItens[nX,04]}),16],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03))),3))) //CTOD(SUBSTR(aPatri[nX,12],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03))),3)) 
			
		cQuery := "SELECT ZN_CONFERE,ZN_PATRIMO,ZN_DATA,ZN_BOTTEST,ZN_BOTAO01,ZN_BOTAO02,ZN_BOTAO03,ZN_BOTAO04,ZN_BOTAO05,ZN_BOTAO06,ZN_BOTAO07,ZN_BOTAO08,ZN_BOTAO09,"+chr(13)+chr(10)
		cQuery += " ZN_BOTAO10,ZN_BOTAO11,ZN_BOTAO12,ZN.R_E_C_N_O_ AS REGIS,"+chr(13)+chr(10)
		cQuery += " N1_XVOLMIN,N1_XP1,N1_XP2,N1_XP3,N1_XP4,N1_XP5,N1_XP6,N1_XP7,N1_XP8,N1_XP9,N1_XP10,N1_XP11,N1_XP12,"+chr(13)+chr(10)
		
		//ALTERADO DEPOIS DE FINALIZADO, RODRIGO INFORMOU QUE OS CONTADORES ESTAO ACUMULANDO AGORA.
		cQuery += " (SELECT TOP 1 ZN_DATA FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND ZN_PATRIMO='"+aItens[nX,04]+"' AND ZN_DATA < '"+dtos(cPer2)+"' AND ZN_CONFERE<>'1' AND ZN_DATA NOT BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"' AND D_E_L_E_T_='' ORDER BY ZN_DATA DESC) AS P1_DATANT,"+chr(13)+chr(10)
		cQuery += " (SELECT TOP 1 ZN_BOTAO01 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND ZN_PATRIMO='"+aItens[nX,04]+"' AND ZN_DATA < '"+dtos(cPer2)+"' AND ZN_CONFERE<>'1' AND ZN_DATA NOT BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"' AND D_E_L_E_T_='' ORDER BY ZN_DATA DESC) AS P1_ANT,"+chr(13)+chr(10)
		cQuery += " (SELECT TOP 1 ZN_BOTAO02 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND ZN_PATRIMO='"+aItens[nX,04]+"' AND ZN_DATA < '"+dtos(cPer2)+"' AND ZN_CONFERE<>'1' AND ZN_DATA NOT BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"' AND D_E_L_E_T_='' ORDER BY ZN_DATA DESC) AS P2_ANT,"+chr(13)+chr(10)
		cQuery += " (SELECT TOP 1 ZN_BOTAO03 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND ZN_PATRIMO='"+aItens[nX,04]+"' AND ZN_DATA < '"+dtos(cPer2)+"' AND ZN_CONFERE<>'1' AND ZN_DATA NOT BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"' AND D_E_L_E_T_='' ORDER BY ZN_DATA DESC) AS P3_ANT,"+chr(13)+chr(10)
		cQuery += " (SELECT TOP 1 ZN_BOTAO04 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND ZN_PATRIMO='"+aItens[nX,04]+"' AND ZN_DATA < '"+dtos(cPer2)+"' AND ZN_CONFERE<>'1' AND ZN_DATA NOT BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"' AND D_E_L_E_T_='' ORDER BY ZN_DATA DESC) AS P4_ANT,"+chr(13)+chr(10)
		cQuery += " (SELECT TOP 1 ZN_BOTAO05 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND ZN_PATRIMO='"+aItens[nX,04]+"' AND ZN_DATA < '"+dtos(cPer2)+"' AND ZN_CONFERE<>'1' AND ZN_DATA NOT BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"' AND D_E_L_E_T_='' ORDER BY ZN_DATA DESC) AS P5_ANT,"+chr(13)+chr(10)
		cQuery += " (SELECT TOP 1 ZN_BOTAO06 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND ZN_PATRIMO='"+aItens[nX,04]+"' AND ZN_DATA < '"+dtos(cPer2)+"' AND ZN_CONFERE<>'1' AND ZN_DATA NOT BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"' AND D_E_L_E_T_='' ORDER BY ZN_DATA DESC) AS P6_ANT,"+chr(13)+chr(10)
		cQuery += " (SELECT TOP 1 ZN_BOTAO07 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND ZN_PATRIMO='"+aItens[nX,04]+"' AND ZN_DATA < '"+dtos(cPer2)+"' AND ZN_CONFERE<>'1' AND ZN_DATA NOT BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"' AND D_E_L_E_T_='' ORDER BY ZN_DATA DESC) AS P7_ANT,"+chr(13)+chr(10)
		cQuery += " (SELECT TOP 1 ZN_BOTAO08 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND ZN_PATRIMO='"+aItens[nX,04]+"' AND ZN_DATA < '"+dtos(cPer2)+"' AND ZN_CONFERE<>'1' AND ZN_DATA NOT BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"' AND D_E_L_E_T_='' ORDER BY ZN_DATA DESC) AS P8_ANT,"+chr(13)+chr(10)
		cQuery += " (SELECT TOP 1 ZN_BOTAO09 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND ZN_PATRIMO='"+aItens[nX,04]+"' AND ZN_DATA < '"+dtos(cPer2)+"' AND ZN_CONFERE<>'1' AND ZN_DATA NOT BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"' AND D_E_L_E_T_='' ORDER BY ZN_DATA DESC) AS P9_ANT,"+chr(13)+chr(10)
		cQuery += " (SELECT TOP 1 ZN_BOTAO10 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND ZN_PATRIMO='"+aItens[nX,04]+"' AND ZN_DATA < '"+dtos(cPer2)+"' AND ZN_CONFERE<>'1' AND ZN_DATA NOT BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"' AND D_E_L_E_T_='' ORDER BY ZN_DATA DESC) AS P10_ANT,"+chr(13)+chr(10)
		cQuery += " (SELECT TOP 1 ZN_BOTAO11 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND ZN_PATRIMO='"+aItens[nX,04]+"' AND ZN_DATA < '"+dtos(cPer2)+"' AND ZN_CONFERE<>'1' AND ZN_DATA NOT BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"' AND D_E_L_E_T_='' ORDER BY ZN_DATA DESC) AS P11_ANT,"+chr(13)+chr(10)
		cQuery += " (SELECT TOP 1 ZN_BOTAO12 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND ZN_PATRIMO='"+aItens[nX,04]+"' AND ZN_DATA < '"+dtos(cPer2)+"' AND ZN_CONFERE<>'1' AND ZN_DATA NOT BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"' AND D_E_L_E_T_='' ORDER BY ZN_DATA DESC) AS P12_ANT,"+chr(13)+chr(10)
		cQuery += " (SELECT TOP 1 ZN_BOTTEST FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND ZN_PATRIMO='"+aItens[nX,04]+"' AND ZN_DATA < '"+dtos(cPer2)+"' AND ZN_CONFERE<>'1' AND ZN_DATA NOT BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"' AND D_E_L_E_T_='' ORDER BY ZN_DATA DESC) AS PT_ANT"+chr(13)+chr(10)

		cQuery += "  FROM "+RetSQLName("SZN")+" ZN"+chr(13)+chr(10)
		cQuery += "  LEFT JOIN "+RetSQLName("SN1")+" N1 ON N1_CHAPA=ZN_PATRIMO AND N1.D_E_L_E_T_=''"+chr(13)+chr(10)
		cQuery += " WHERE ZN_TIPINCL<>'SANGRIA' AND ZN_PATRIMO='"+aItens[nX,04]+"' AND (ZN_DATA BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"' OR ZN_CONFERE='1')"+chr(13)+chr(10)
		cQuery += " AND ZN.D_E_L_E_T_='' ORDER BY ZN_DATA DESC"+chr(13)+chr(10)
		
		If Select('TRB') > 0
			dbSelectArea('TRB')
			dbCloseArea()
		EndIf
		
		MemoWrite("FatCafe.SQL",cQuery)
		DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
		
		DbSelectArea("TRB")
		
		While !EOF()
			If Ascan(aXP,{|x| x[1] == TRB->ZN_PATRIMO}) == 0
			    Aadd(aXP,{TRB->ZN_PATRIMO})
			    Aadd(aFat,{{TRB->N1_XP1,TRB->ZN_BOTAO01-TRB->P1_ANT,0,0},{TRB->N1_XP2,TRB->ZN_BOTAO02-TRB->P2_ANT,0,0},;
			    			{TRB->N1_XP3,TRB->ZN_BOTAO03-TRB->P3_ANT,0,0},{TRB->N1_XP4,TRB->ZN_BOTAO04-TRB->P4_ANT,0,0},;
			    			{TRB->N1_XP5,TRB->ZN_BOTAO05-TRB->P5_ANT,0,0},{TRB->N1_XP6,TRB->ZN_BOTAO06-TRB->P6_ANT,0,0},;
			    			{TRB->N1_XP7,TRB->ZN_BOTAO07-TRB->P7_ANT,0,0},{TRB->N1_XP8,TRB->ZN_BOTAO08-TRB->P8_ANT,0,0},;
			    			{TRB->N1_XP9,TRB->ZN_BOTAO09-TRB->P9_ANT,0,0},{TRB->N1_XP10,TRB->ZN_BOTAO10-TRB->P10_ANT,0,0},;
			    			{TRB->N1_XP11,TRB->ZN_BOTAO11-TRB->P11_ANT,0,0},{TRB->N1_XP12,TRB->ZN_BOTAO12-TRB->P12_ANT,0,0}})
			Else
				aFat[len(aFat),1,2] := If(TRB->ZN_CONFERE=="T",(TRB->ZN_BOTAO01-TRB->P1_ANT) + aFat[len(aFat),1,2],(TRB->ZN_BOTAO01-TRB->P1_ANT) - aFat[len(aFat),1,2])
				aFat[len(aFat),2,2] := If(TRB->ZN_CONFERE=="T",(TRB->ZN_BOTAO02-TRB->P2_ANT) + aFat[len(aFat),2,2],(TRB->ZN_BOTAO02-TRB->P2_ANT) - aFat[len(aFat),2,2])
				aFat[len(aFat),3,2] := If(TRB->ZN_CONFERE=="T",(TRB->ZN_BOTAO03-TRB->P3_ANT) + aFat[len(aFat),3,2],(TRB->ZN_BOTAO03-TRB->P3_ANT) - aFat[len(aFat),3,2])
				aFat[len(aFat),4,2] := If(TRB->ZN_CONFERE=="T",(TRB->ZN_BOTAO04-TRB->P4_ANT) + aFat[len(aFat),4,2],(TRB->ZN_BOTAO04-TRB->P4_ANT) - aFat[len(aFat),4,2])
				aFat[len(aFat),5,2] := If(TRB->ZN_CONFERE=="T",(TRB->ZN_BOTAO05-TRB->P5_ANT) + aFat[len(aFat),5,2],(TRB->ZN_BOTAO05-TRB->P5_ANT) - aFat[len(aFat),5,2])
				aFat[len(aFat),6,2] := If(TRB->ZN_CONFERE=="T",(TRB->ZN_BOTAO06-TRB->P6_ANT) + aFat[len(aFat),6,2],(TRB->ZN_BOTAO06-TRB->P6_ANT) - aFat[len(aFat),6,2])
				aFat[len(aFat),7,2] := If(TRB->ZN_CONFERE=="T",(TRB->ZN_BOTAO07-TRB->P7_ANT) + aFat[len(aFat),7,2],(TRB->ZN_BOTAO07-TRB->P7_ANT) - aFat[len(aFat),7,2])
				aFat[len(aFat),8,2] := If(TRB->ZN_CONFERE=="T",(TRB->ZN_BOTAO08-TRB->P8_ANT) + aFat[len(aFat),8,2],(TRB->ZN_BOTAO08-TRB->P8_ANT) - aFat[len(aFat),8,2])
				aFat[len(aFat),9,2] := If(TRB->ZN_CONFERE=="T",(TRB->ZN_BOTAO09-TRB->P9_ANT) + aFat[len(aFat),9,2],(TRB->ZN_BOTAO09-TRB->P9_ANT) - aFat[len(aFat),9,2])
				aFat[len(aFat),10,2] := If(TRB->ZN_CONFERE=="T",(TRB->ZN_BOTAO10-TRB->P10_ANT) + aFat[len(aFat),10,2],(TRB->ZN_BOTAO10-TRB->P10_ANT) - aFat[len(aFat),10,2])
				aFat[len(aFat),11,2] := If(TRB->ZN_CONFERE=="T",(TRB->ZN_BOTAO11-TRB->P11_ANT) + aFat[len(aFat),11,2],(TRB->ZN_BOTAO11-TRB->P11_ANT) - aFat[len(aFat),11,2])
				aFat[len(aFat),12,2] := If(TRB->ZN_CONFERE=="T",(TRB->ZN_BOTAO12-TRB->P12_ANT) + aFat[len(aFat),12,2],(TRB->ZN_BOTAO12-TRB->P12_ANT) - aFat[len(aFat),12,2])
			EndIf 
			//Minimo do patrimonio esta nas posicoes 6 e 8 pois a posicao 6 sera readequada de acordo com o minimo do contrato e a posicao 8 servira para corrigir o minimo na planilha sintetica.
			If Ascan(aProRa,{|x| x[1]+x[2]+x[3] == aItens[nX,02]+aItens[nX,04]+TRB->ZN_DATA}) == 0	
				Aadd(aProRa,{aItens[nX,02],aItens[nX,04],TRB->ZN_DATA,STOD(TRB->P1_DATANT),cPer2,TRB->N1_XVOLMIN,stod(TRB->ZN_DATA),TRB->N1_XVOLMIN})
			EndIf
			
			Dbskip()
		Enddo
	EndIf
Next nX	
//	1		 2			3			4		5		6		7		 8		 	9
//cliente,contrato,tipocontrato,patrimonio,data,numerant,numatual,diferenca,contadorps

	cQuery := "SELECT DA1_CODTAB,DA1_CODPRO,B1_DESC,DA1_PRCVEN,DA1_XPRCPP"
	cQuery += " FROM "+RetSQLName("DA1")+" DA1"
	cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=DA1_CODPRO AND B1.D_E_L_E_T_=''"
	cQuery += " WHERE  DA1.D_E_L_E_T_=''"
	cQuery += " AND DA1_CODTAB IN(SELECT DA0_CODTAB FROM "+RetSQLName("DA0")+" WHERE DA0_ATIVO='1' AND DA0_DATATE>'"+dtos(dDatabase)+"'"
	cQuery += " AND DA0_XCLIEN='"+substr(aItens[1,1],1,6)+"' AND DA0_XLOJA='"+substr(aItens[1,1],8,4)+"')"
	
	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf
	
	MemoWrite("FatCafe.SQL",cQuery)
	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
	
	DbSelectArea("TRB")
	//Buscando os valores dos produtos na tabela de preco de venda do cliente.
	While !EOF()
	    Aadd(aVlr,{TRB->DA1_CODTAB,TRB->DA1_CODPRO,TRB->B1_DESC,TRB->DA1_PRCVEN,TRB->DA1_XPRCPP}) 
		Dbskip()
	EndDo

For nY := 1 to len(aVlr)
	For nX := 1 to len(aFat)
		For nZ := 1 to len(aFat[nX])
			If Alltrim(aVlr[nY,02]) == Alltrim(aFat[nX,nZ,1])   
				//Colocando o valor de faturamento no array
				aFat[nX,nZ,3]	:=	aVlr[nY,04]
				aFat[nX,nZ,4]	:=	aVlr[nY,05]
			EndIf
		Next nZ
	Next nX
Next nY

For nX := 1 to len(aFat)
	For nY := 1 to len(aFat[nX])
		If !empty(aFat[nX,nY,01])  .And. aFat[nX,nY,02] > 0
			If Ascan(aProd,{|x| Alltrim(x[1]) == Alltrim(aFat[nX,nY,01])}) == 0 
			//carregando as doses a serem faturadas para o cliente e seu respectivo pre็o
				cDesc := If(Ascan(aVlr,{|x| Alltrim(x[2]) == Alltrim(aFat[nX,nY,01])})>0,aVlr[Ascan(aVlr,{|x| Alltrim(x[2]) == Alltrim(aFat[nX,nY,01])}),03],'')
				cTab  := If(Ascan(aVlr,{|x| Alltrim(x[2]) == Alltrim(aFat[nX,nY,01])})>0,aVlr[Ascan(aVlr,{|x| Alltrim(x[2]) == Alltrim(aFat[nX,nY,01])}),01],'')
				Aadd(aProd,{aFat[nX,nY,01],cDesc,aFat[nX,nY,02],aFat[nX,nY,03],Transform(aFat[nX,nY,02]*aFat[nX,nY,03],"@E 999,999,999.9999"),;
							aItens[1,1],aItens[1,2],aItens[1,3],cPat,aFat[nX,nY,04],Transform(aFat[nX,nY,02]*aFat[nX,nY,04],"@E 999,999,999.9999"),;
							cPer1,cPer2,aItens[1,10],aItens[1,11],cTab,''})
				nTotDos += aFat[nX,nY,02]                             
			Else
				aProd[Ascan(aProd,{|x| Alltrim(x[1]) == Alltrim(aFat[nX,nY,01])}),03] += 	aFat[nX,nY,02]
				aProd[Ascan(aProd,{|x| Alltrim(x[1]) == Alltrim(aFat[nX,nY,01])}),05] := Transform(aProd[Ascan(aProd,{|x| Alltrim(x[1]) == Alltrim(aFat[nX,nY,01])}),03] * aProd[Ascan(aProd,{|x| Alltrim(x[1]) == Alltrim(aFat[nX,nY,01])}),04],"@E 999,999,999.9999")
				aProd[Ascan(aProd,{|x| Alltrim(x[1]) == Alltrim(aFat[nX,nY,01])}),11] := Transform(aProd[Ascan(aProd,{|x| Alltrim(x[1]) == Alltrim(aFat[nX,nY,01])}),03] * aProd[Ascan(aProd,{|x| Alltrim(x[1]) == Alltrim(aFat[nX,nY,01])}),10],"@E 999,999,999.9999")
				nTotDos += aFat[nX,nY,02] 
			EndIf                                                      
		EndIf
	Next nY
Next nX  

//  ***************************    Controle para faturamento Minimo    ******************************  //
//Caso o cliente nใo tenha atingido o valor minimo de doses devera ser cobrado o valor complementar
//atraves do codigo especifico informado no contrato        
//   Possui Minimo ?  
If aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),12] $ "1/2"
	//   Tipo de Faturamento Minimo
	If aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),18] $ "1/3"  
		//PRO-RATA
		//aProRa,{aItens[nX,02],aItens[nX,04],TRB->ZN_DATA,cPer1,cPer2}
		For nX := 1 to len(aProRa)
			If aProRa[nX,01] == aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),01]
				If stod(aProRa[nX,03]) != aProRa[nX,05] .Or. aProRa[nX,04] != aProRa[nX,07]
					nQtdD := stod(aProRa[nX,03]) - aProRa[nX,04]
					nNeMin	:=	If(nQtdD==30,(aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),13] / 30)* nQtdD,Round((aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),13] / 30),0) * nQtdD)
					aProRa[nX,06] := nNeMin //If(aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),18]=="1",aProRa[nX,06],nNeMin)
				EndIf
			EndIf
		Next nX
	
		//   CLIENTE OU LOJA
		//  Atingiu o Volume Minimo do Contrato ?
		If If(nNeMin>0,nNeMin,aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),13]) - nTotDos > 0
			cProd	:=	aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),16]
			cDesc 	:= Posicione("SB1",1,xFilial("SB1")+aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),16],"B1_DESC")
			nQtd 	:= round(If(nNeMin>0,nNeMin,aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),13]) - nTotDos,0)
			nVlr 	:=  If(Ascan(aVlr,{|x| x[2] = aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),16]})>0,aVlr[Ascan(aVlr,{|x| x[2] = aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),16]}),04],0)
			nTot	:=	nVlr * nQtd
			nVlrPP	:=  If(Ascan(aVlr,{|x| x[2] = aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),16]})>0,aVlr[Ascan(aVlr,{|x| x[2] = aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),16]}),05],0)
			nTotPP	:= 	nVlrPP * nQtd 
			cTab  := '' //If(Ascan(aVlr,{|x| Alltrim(x[2]) == Alltrim(aFat[nX,nY,01])})>0,aVlr[Ascan(aVlr,{|x| Alltrim(x[2]) == Alltrim(aFat[nX,nY,01])}),01],'')
			Aadd(aProd,{cProd,cDesc,nQtd,nVlr,Transform(nTot,"@E 999,999,999.9999"),aItens[1,1],aItens[1,2],aItens[1,3],cPat,nVlrPP,nTotPP,cPer1,cPer2,aItens[1,10],aItens[1,11],cTab,'C'})
		ElseIf If(nNeMin>0,nNeMin,aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),13]) - nTotDos < 0 .And.	aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),17] > 0 
			cProd	:=	aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),16]
			cDesc 	:= 	Posicione("SB1",1,xFilial("SB1")+aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),16],"B1_DESC")
			nQtd 	:= 	round(nTotDos - If(nNeMin>0,nNeMin,aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),13]),0) //aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),13]
			nVlr	:=	aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),17]
			nTot	:=	nVlr * nQtd                                              
			nVlrPP	:= aVlr[Ascan(aVlr,{|x| x[2] = aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),16]}),05] 
			nTotPP	:= 	nVlrPP * nQtd
			cTab  := '' //If(Ascan(aVlr,{|x| Alltrim(x[2]) == Alltrim(aFat[nX,nY,01])})>0,aVlr[Ascan(aVlr,{|x| Alltrim(x[2]) == Alltrim(aFat[nX,nY,01])}),01],'')
			Aadd(aProd,{cProd,cDesc,nQtd,nVlr,Transform(nTot,"@E 999,999,999.9999"),aItens[1,1],aItens[1,2],aItens[1,3],cPat,nVlrPP,nTotPP,cPer1,cPer2,aItens[1,10],aItens[1,11],cTab,'C'})
		EndIf
	ElseIf aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),18] == "2"
		//Verifica o volume minimo do contrato de acordo com os patrimonios no cliente
		nNewMin := 0
		//Minimo por Equipamento, devemos primeiro verificar o minimo de cada um dos equipamentos e trocar pelo minimo do contrato.
		For nPP := 1 to len(aItens)
			//nNewMin += //Posicione("SN1",2,xFilial("SN1")+AvKey(aItens[nPP,04],"N1_CHAPA"),"N1_XVOLMIN")
			If Ascan(aProRa,{|x| x[2] == aItens[nPP,04]}) > 0 
				nQtdD1	:=	aProra[Ascan(aProra,{|x| x[2] == aItens[nPP,04]}),05] - aProra[Ascan(aProra,{|x| x[2] == aItens[nPP,04]}),07]
				nQtdD2	:=	stod(aProra[Ascan(aProra,{|x| x[2] == aItens[nPP,04]}),03]) - aProra[Ascan(aProra,{|x| x[2] == aItens[nPP,04]}),04]
				nMin1 := aProRa[Ascan(aProRa,{|x| x[2] == aItens[nPP,04]}),06] / 30 //nQtdD1
				nMin2 := round(nQtdD2 * nMin1,0)
				aProRa[Ascan(aProRa,{|x| x[2] == aItens[nPP,04]}),06] := nMin2 
				If ascan(aTotp,{|x| x[1]+x[4] == aProRa[Ascan(aProRa,{|x| x[2] == aItens[nPP,04]}),01]+aProra[Ascan(aProRa,{|x| x[2] == aItens[nPP,04]}),02]}) > 0
					aTotP[ascan(aTotp,{|x| x[1]+x[4] == aProRa[Ascan(aProRa,{|x| x[2] == aItens[nPP,04]}),01]+aProra[Ascan(aProRa,{|x| x[2] == aItens[nPP,04]}),02]}),06] := nMin2
				EndIf
				
				//As doses apontadas no patrimonio atingiram o volume minimo dele?
				If aTotP[ascan(aTotp,{|x| x[1]+x[4] == aProRa[Ascan(aProRa,{|x| x[2] == aItens[nPP,04]}),01]+aProra[Ascan(aProRa,{|x| x[2] == aItens[nPP,04]}),02]}),05] < nMin2
				    //Nใo existe compensacao entre patrimonios?
					If aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),14] == "3"
						cProd	:=	aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),16]
						cDesc 	:= 	Posicione("SB1",1,xFilial("SB1")+aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),16],"B1_DESC")
						nQtd 	:= 	round(nMin2-aTotP[ascan(aTotp,{|x| x[1]+x[4] == aProRa[Ascan(aProRa,{|x| x[2] == aItens[nPP,04]}),01]+aProra[Ascan(aProRa,{|x| x[2] == aItens[nPP,04]}),02]}),05],0)
						nVlr	:=	aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),17]
						nTot	:=	nVlr * nQtd
						nVlrPP	:= aVlr[Ascan(aVlr,{|x| x[2] = aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),16]}),05] 
						nTotPP	:= 	nVlrPP * nQtd
						cTab  := '' //If(Ascan(aVlr,{|x| Alltrim(x[2]) == Alltrim(aFat[nX,nY,01])})>0,aVlr[Ascan(aVlr,{|x| Alltrim(x[2]) == Alltrim(aFat[nX,nY,01])}),01],'')
						Aadd(aProd,{cProd,cDesc,nQtd,nVlr,Transform(nTot,"@E 999,999,999.9999"),aItens[1,1],aItens[1,2],aItens[1,3],cPat,nVlrPP,nTotPP,cPer1,cPer2,aItens[1,10],aItens[1,11],cTab,'C'})
	                 EndIf
	     		EndIf
				
				nNewMin += nMin2 
				
			EndIf
		Next nPP
		If nNewMin > aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),13]
			aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),13] := nNewMin
		EndIf
		//Atingiu o volume minimo do contrato ?
		If aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),13] - nTotDos > 0
			//Existe Rateio minimo para o cliente?
			If aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),15] $ "1/2"
			//------------------ validacao para rateio por cliente e loja  --------------------------- //
				cProd	:=	aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),16]
				cDesc 	:= 	Posicione("SB1",1,xFilial("SB1")+aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),16],"B1_DESC")
				nQtd 	:= 	round(aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),13] - nTotDos,0)
				nVlr	:=	aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),17]
				nTot	:=	nVlr * nQtd
				nVlrPP	:= aVlr[Ascan(aVlr,{|x| x[2] = aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),16]}),05] 
				nTotPP	:= 	nVlrPP * nQtd
				cTab  := '' //If(Ascan(aVlr,{|x| Alltrim(x[2]) == Alltrim(aFat[nX,nY,01])})>0,aVlr[Ascan(aVlr,{|x| Alltrim(x[2]) == Alltrim(aFat[nX,nY,01])}),01],'')
				Aadd(aProd,{cProd,cDesc,nQtd,nVlr,Transform(nTot,"@E 999,999,999.9999"),aItens[1,1],aItens[1,2],aItens[1,3],cPat,nVlrPP,nTotPP,cPer1,cPer2,aItens[1,10],aItens[1,11],cTab,'C'})

			ElseIf aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),15] == "3"
				// Existe Compensacao entre lojas para o cliente?
				If aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),14] == "1"
					//  ---------------   Compensacao por cliente.   ------------------------- //
					
				ElseIf aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),14] == "2"
					//Compensacao por loja.
					//Percorre o Array aTotP (Totais por patrimonio) deste cliente e 
					//verifica quais lojas nใo atingiram o minimo por patrimonio.
					For nX := 1 to len(aTotP)
						If aTotP[nX,01] == aItens[1,2] .And. aTotP[nX,03] == substr(aItens[1,1],8,4)
							If Ascan(aCP,{|x| x[1] == aTotP[nX,03]}) == 0
								Aadd(aCP,{aTotP[nX,03],aTotP[nX,05],aTotP[nX,06],aItens[1,2]})
							Else              
								aCP[Ascan(aCP,{|x| x[1] == aTotP[nX,03]}),02] += aTotP[nX,05]
								aCP[Ascan(aCP,{|x| x[1] == aTotP[nX,03]}),03] += aTotP[nX,06]
							EndIf
						EndIf
					Next nX
					//Verificando quantos patrimonios na filial nao atingiram o minimo para compensar o rateio
					For nX := 1 to len(aTotP)
						If aTotP[nX,01] == aItens[1,2] .And. aTotP[nX,03] == substr(aItens[1,1],8,4)
							aTotP[nX,07] := aTotP[nX,06] / aCP[Ascan(aCP,{|x| x[1] == aTotP[nX,03]}),03] 
						EndIf
					Next nX
					//Varrendo mais uma vez para distribuir o percentual dos itens que atingiram o valor minimo para os que nao atingiram
					nQtdP := 0 
					nTotP := 1
					//Verificando o numero de patrimonios na filial
					For nX := 1 to len(aTotP)
						If aTotP[nX,01] == aItens[1,2] .And. aTotP[nX,03] == substr(aItens[1,1],8,4)
					    	nQtdP++
					 	EndIf
					Next nX
					//Verificando itens que devem ter seu percentual distribuido para os demais que nao atingiram a quantidade minima de faturamento.
					For nX := 1 to len(aTotP)
						If aTotP[nX,01] == aItens[1,2] .And. aTotP[nX,03] == substr(aItens[1,1],8,4)
							If aTotP[nX,05] - aTotP[nX,06] >= 0
								nDist := aTotP[nX,07] / (nQtdP - nTotP)
								aTotP[nX,07] := 0 
								nTotP++
								//Distribuindo os valores para os demais itens
								For nY := 1 to len(aTotP)
									If aTotP[nX,01] == aItens[1,2] .And. aTotP[nX,03] == substr(aItens[1,1],8,4)	
										If aTotP[nY,07] > 0
											aTotP[nY,07] += nDist
										EndIf
									EndIf
								Next nY
							EndIf                                  
						EndIf
					Next nX
					//Incluindo os itens a serem faturados complementares por patrimonio.
					For nX := 1 to len(aTotP)
						If aTotP[nX,01] == aItens[1,2] .And. aTotP[nX,03] == substr(aItens[1,1],8,4) .And. aTotP[nX,07] > 0 
							cProd	:=	aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),16]
							cDesc 	:= Alltrim(Posicione("SB1",1,xFilial("SB1")+aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),16],"B1_DESC")) + ' - Patr.'+aTotP[nX,04] 
							nQtd 	:= Round((aCp[Ascan(aCP,{|x| x[1]+x[4] == aTotP[nX,03]+aTotP[nX,01]}),03]-aCp[Ascan(aCP,{|x| x[1]+x[4] == aTotP[nX,03]+aTotP[nX,01]}),02]) * aTotP[nX,07],0)
							//(aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),13] - nTotDos) * aTotP[nX,07]
							nVlr 	:= aVlr[Ascan(aVlr,{|x| x[2] = aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),16]}),04] 
							nTot	:=	nVlr * nQtd 
							nVlrPP	:= aVlr[Ascan(aVlr,{|x| x[2] = aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),16]}),05] 
							nTotPP	:= 	nVlrPP * nQtd
							Aadd(aProd,{cProd,cDesc,nQtd,nVlr,Transform(nTot,"@E 999,999,999.99"),aItens[1,1],aItens[1,2],aItens[1,3],cPat,nVlrPP,nTotPP,cPer1,cPer2,aItens[1,10],aItens[1,11],'','C'})
						EndIf
					Next nX

				Else
					//Nao ha rateio para o cliente, cada patrimonio que nao atingir o volume minimo deve ser cobrado dose complementar.
					//Percorre o Array aTotP (Totais por patrimonio) deste cliente e 
					//verifica quais lojas nใo atingiram o minimo por patrimonio.
					For nX := 1 to len(aTotP)
						If aTotP[nX,01] == aItens[1,2] //.And. aTotP[nX,03] == substr(aItens[1,1],8,4)
							If aTotP[nX,05] - aTotP[nX,06] < 0
								aTotP[nX,07] := (aTotP[nX,05] - aTotP[nX,06]) * -1
							EndIf
						EndIf
					Next nX
				    //Adicionando o item complementar a ser faturado quando nao ha rateio nem compensacao 
					For nX := 1 to len(aTotP)
						If aTotP[nX,01] == aItens[1,2] .And. aTotP[nX,03] == substr(aItens[1,1],8,4) .And. aTotP[nX,07] > 0 
							cProd	:=	aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),16]
							cDesc 	:= Alltrim(Posicione("SB1",1,xFilial("SB1")+aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),16],"B1_DESC")) + ' - Patr.'+aTotP[nX,04] 
							nQtd 	:= round(aTotP[nX,07],0)
							//(aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),13] - nTotDos) * aTotP[nX,07]
							nVlr 	:= aVlr[Ascan(aVlr,{|x| x[2] = aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),16]}),04] 
							nTot	:=	nVlr * nQtd
							nVlrPP	:= aVlr[Ascan(aVlr,{|x| x[2] = aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),16]}),05] 
							nTotPP	:= 	nVlrPP * nQtd
							Aadd(aProd,{cProd,cDesc,nQtd,nVlr,Transform(nTot,"@E 999,999,999.99"),aItens[1,1],aItens[1,2],aItens[1,3],cPat,nVlrPP,nTotPP,cPer1,cPer2,aItens[1,10],aItens[1,11],'','C'})
						EndIf
					Next nX	
				EndIf
			Else
				//Nao ha rateio para o cliente, cada patrimonio que nao atingir o volume minimo deve ser cobrado dose complementar.
				//Percorre o Array aTotP (Totais por patrimonio) deste cliente e 
				//verifica quais lojas nใo atingiram o minimo por patrimonio.
				For nX := 1 to len(aTotP)
					If aTotP[nX,01] == aItens[1,2] //.And. aTotP[nX,03] == substr(aItens[1,1],8,4)
						If aTotP[nX,05] - aTotP[nX,06] < 0
							aTotP[nX,07] := (aTotP[nX,05] - aTotP[nX,06]) * -1
						EndIf
					EndIf
				Next nX
			    //Adicionando o item complementar a ser faturado quando nao ha rateio nem compensacao 
				//For nX := 1 to len(aTotP)
					//If aTotP[nX,01] == aItens[1,2] .And. aTotP[nX,03] == substr(aItens[1,1],8,4) .And. aTotP[nX,07] > 0 
						cProd	:=	aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),16]
						cDesc 	:= Alltrim(Posicione("SB1",1,xFilial("SB1")+aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),16],"B1_DESC")) //+ ' - Patr.'+aTotP[nX,04] 
						nQtd 	:= ROUND(aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),13] - nTotDos,0) //round(aTotP[nX,07],0)
						//(aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),13] - nTotDos) * aTotP[nX,07]
						nVlr 	:= aVlr[Ascan(aVlr,{|x| x[2] = aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),16]}),04] 
						nTot	:=	nVlr * nQtd
						nVlrPP	:= aVlr[Ascan(aVlr,{|x| x[2] = aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),16]}),05] 
						nTotPP	:= 	nVlrPP * nQtd
					  //	If Ascan(aProd,{|x| x[1]+x[17] == cProd+"C"}) > 0
					//	  	aProd[Ascan(aProd,{|x| x[1]+x[17] == cProd+"C"}),03] += nQtd
					 //	  	aProd[Ascan(aProd,{|x| x[1]+x[17] == cProd+"C"}),04] += nVlr
					  //	  	aProd[Ascan(aProd,{|x| x[1]+x[17] == cProd+"C"}),05] := Transform(val(strtran(aProd[Ascan(aProd,{|x| x[1]+x[17] == cProd+"C"}),05],",",".")) + nTot,"@E 999,999,999.99")
					//	  	aProd[Ascan(aProd,{|x| x[1]+x[17] == cProd+"C"}),10] += nVlrPP
					 //	  	aProd[Ascan(aProd,{|x| x[1]+x[17] == cProd+"C"}),11] += nTotPP
					 //	Else
							Aadd(aProd,{cProd,cDesc,nQtd,nVlr,Transform(nTot,"@E 999,999,999.99"),aItens[1,1],aItens[1,2],aItens[1,3],cPat,nVlrPP,nTotPP,cPer1,cPer2,aItens[1,10],aItens[1,11],'','C'})
					 //	EndIf
					//EndIf
				//Next nX

			EndIf
		ElseIf aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),13] - nTotDos < 0 .And. aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),17] > 0
			// ---------------  Valores excentes quando existem no contrato
		EndIf
	EndIf
EndIf

If !lPlan
	
	oDlgF1      := MSDialog():New( 091,232,514,793,"Demonstrativo de Faturamento",,,.F.,,,,,,.T.,,,.T. )
	
		oGrp1      := TGroup():New( 004,004,060,272,"Informa็๕es do Cliente",oDlgF1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		oSay1      := TSay():New( 013,012,{||"Cliente:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
		oSay2      := TSay():New( 013,032,{||aItens[1,1]},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,232,008)
		oSay3      := TSay():New( 025,012,{||"Contrato"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
		oSay4      := TSay():New( 025,040,{||aItens[1,2]},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
		oSay5      := TSay():New( 025,096,{||"Tipo Contrato"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oSay6      := TSay():New( 025,136,{||aItens[1,3]},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,128,008)
		oSay7      := TSay():New( 037,012,{||"Patrim๔nios"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oSay8      := TSay():New( 037,044,{||cPat},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,224,016)
		oSay9      := TSay():New( 049,012,{||"Doses Apontadas"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,062,008)
		oSay10     := TSay():New( 049,064,{||Transform(nTotDos,"@E 999,999,999")},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,016)
		oSay11     := TSay():New( 049,090,{||"Doses Minimas"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,062,008)
		oSay12     := TSay():New( 049,120,{||Transform(If(nNeMin>0,nNeMin,aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),13]),"@E 999,999,999")+" / "+Transform(aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),13],"@E 999,999,999")},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,016)
	    oSay13     := TSay():New( 049,190,{||"Complementares"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,062,008)
	    oSay14     := TSay():New( 049,235,{||Transform(If(nNeMin>0,nNeMin,aContr[Ascan(aContr,{|x| x[1] == aItens[1,2]}),13])-nTotDos,"@E 999,999,999")},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,050,016) 
	    
		oGrp2      := TGroup():New( 064,004,184,272,"Itens",oDlgF1,CLR_BLACK,CLR_WHITE,.T.,.F. )
			//oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{076,012,176,264},,, oGrp2 ) 
			oObjs := TCBrowse():New(076,012,254,095,, {'Produto','Descricใo','Qtd.','Valor PE','Total PE','Valor PP','Total PP'},;
														{30,40,30,30,30,30,30},;
		                            oGrp2,,,,{|| },{|| },, ,,,  ,,.F.,,.T.,,.F.,,.T.,.T.)
			oObjs:SetArray(aProd)                    
			oObjs:bLine := {||{ aProd[oObjs:nAt,01],; 
			 					 aProd[oObjs:nAt,02],;
			 					 aProd[oObjs:nAt,03],;
			 					 aProd[oObjs:nAt,04],;
			                     aProd[oObjs:nAt,05],;
			                     aProd[oObjs:nAt,10],;
			                     aProd[oObjs:nAt,11]}}
	
		oSBtn1     := SButton():New( 188,080,11,{||Processa({||PlanCafe(aProd)},"Aguarde...")},oDlgF1,,"Gerar Planilha", )
		//oSBtn2     := SButton():New( 188,120,1,{||oDlgF1:end(nOpi:=1)},oDlgF1,,"Gerar Pedido", )
		oSBtn3     := SButton():New( 188,160,2,{||oDlgF1:end(nOpi:=0)},oDlgF1,,"Voltar", )
		
	oDlgF1:Activate(,,,.T.)
Else  
	If nGerar == 0
		PlanCafe(aProd)	
	Else
		nOpi := 1
	EndIf
EndIf

If nOpi == 1
	//Gerar o Pedido de venda para o cliente
	Processa({|| aList[oList:nat,14] :=  U_TTPROC22()},"Aguarde...")
	
	aAuxP := strtokarr(aList[oList:nAt,14],"/")
	nAuxP := 0
	
	For nX := 1 to len(aAuxP)
		cQuery := "SELECT SUM(C6_VALOR) AS VALOR FROM "+RetSQLName("SC6")+" WHERE C6_FILIAL='"+xFilial("SC6")+"' AND C6_NUM='"+aAuxP[nX]+"' AND D_E_L_E_T_=''"
			
		If Select('TRB') > 0
			dbSelectArea('TRB')
			dbCloseArea()
		EndIf
		
		MemoWrite("FatCafe.SQL",cQuery)
		DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
		
		DbSelectArea("TRB") 
		nAuxP += TRB->VALOR
	Next nX
	
	aList[oList:nat,13] :=  Transform(round(nAuxP,2),"@E 999,999,999.99")
	
	DbSelectArea("SZN")
	For nX := 1 to len(aConta)
		If aConta[nX,01] == aList[oList:nAt,18]
			DbGoto(aConta[nX,19])	
			Reclock("SZN",.F.)
			SZN->ZN_CONFERE	:=	'F'
			SZN->ZN_PEDIDOS	:=	aList[oList:nAt,14]
			SZN->(Msunlock())
		EndIf
		
	Next nX

	oList:refresh()
	oDlg1:refresh()
	nGerar := 0
EndIf

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC20  บAutor  ณMicrosiga           บ Data ณ  09/13/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Demonstrativo de faturamento de doses de cafe para o clienteฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PlanCafe(aProd)

Local oExcel := FWMSEXCEL():New()
Local cTitulo := "Demonstrativo"
Local cDir := ""
Local cArqXls := "Demonstrativo.xml" 
Local nTotal	:=	0
Local nTotal2	:=	0
Local nQtd		:=	0 
Local nTotalA	:=	0
Local nTotal2A	:=	0
Local nQtdA		:=	0 
Local cPat		:=	''   
Local cSheet	:=	''  
Local lMudou	:=	.F. 
Local aAux		:=	{} 
Local aSheAn	:=	{}
Local nAux		:=	1
Local aSintet	:=	{}     
Local aBira		:=	{}  
Local nTotPr	:=	0

cDir := cGetFile(, OemToAnsi("Selecione o diret๓rio de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 

If Empty(cDir)
	Return
EndIf

oExcel:AddworkSheet("Demonstrativo") 

oExcel:AddTable ("Demonstrativo","Cliente")

oExcel:AddColumn("Demonstrativo","Cliente","Cliente",1,1)
oExcel:AddColumn("Demonstrativo","Cliente","Contrato",1,1) 
oExcel:AddColumn("Demonstrativo","Cliente","Tipo de Servi็o",1,1) 
oExcel:AddColumn("Demonstrativo","Cliente","Patrim๔nios",1,1) 

oExcel:AddRow("Demonstrativo","Cliente",{aProd[1,6],"","",""})

//oExcel:AddRow("Demonstrativo","Cliente",{""})

oExcel:AddRow("Demonstrativo","Cliente",{"",;
											aProd[1,7],;
										  aProd[1,8],;
										  aProd[1,9]})
										                
cCabecalho	:=	"Pedidos"+Chr(13)+Chr(10)+"Cliente "+aProd[1,6]+Chr(13)+Chr(10)+"Periodo Fat"+cvaltochar(aProd[1,12])+" A "+cvaltochar(aProd[1,13])+Chr(13)+Chr(10)+"Periodo Col "+cvaltochar(aProd[1,14])+" A "+cvaltochar(aProd[1,15])+Chr(13)+Chr(10)									  
oExcel:AddworkSheet("Demonstrativo_Geral") 
oExcel:AddTable ("Demonstrativo_Geral",cCabecalho)
oExcel:AddColumn("Demonstrativo_Geral",cCabecalho,"Produto",1,1)
oExcel:AddColumn("Demonstrativo_Geral",cCabecalho,"Descri็ใo",1,1)
oExcel:AddColumn("Demonstrativo_Geral",cCabecalho,"Quantidade",1,1)
oExcel:AddColumn("Demonstrativo_Geral",cCabecalho,"Valor Unit Empresa",1,1)
oExcel:AddColumn("Demonstrativo_Geral",cCabecalho,"Valor Unit Publico",1,1)
oExcel:AddColumn("Demonstrativo_Geral",cCabecalho,"Valor Total Empresa",1,1)
oExcel:AddColumn("Demonstrativo_Geral",cCabecalho,"Valor Total Publico",1,1)


For nI := 1 To Len(aProd)
	oExcel:AddRow("Demonstrativo_Geral",cCabecalho,{aProd[nI][1],; 	//Produto
											aProd[nI][2],;		//Descricao
											aProd[nI][3],;		//Qtd
											aProd[nI][4],;		//Valor Unit Empresa
											aProd[nI][10],;		//Valor Unit Publico
											aProd[nI][5],;		//Valor Total Empresa
											aProd[nI][11]})		//Valor Total Publico 
	nQtd 	+=	aProd[nI][3]
    nTotal 	+= val(strtran(strtran(aProd[nI,5],"."),",","."))
    nTotal2	+= val(strtran(strtran(If(valtype(aProd[nI,11])=="C",aProd[nI,11],cvaltochar(aProd[nI,11])),"."),",","."))
Next nI
 
	oExcel:AddRow("Demonstrativo_Geral",cCabecalho,{"Total",; 
											"",;		
											Transform(nQtd,"@R 999,999,999"),;		
											"",;		
											"",;
											Transform(nTotal,"@E 999,999,999.9999"),;
											Transform(nTotal2,"@E 999,999,999.9999")})		//valor   

		cSheet := "Sint้tico" 
		nQtd 	:= 0
		nTotal 	:= 0
		nTotal2	:= 0
		
		oExcel:AddworkSheet(cSheet) 
		oExcel:AddTable (cSheet,"Pedidos")
		oExcel:AddColumn(cSheet,"Pedidos","Patrimonio",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","Modelo",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","Instala็ใo",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","Leitura Anterior",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","Leitura Atual",1,1) 
		oExcel:AddColumn(cSheet,"Pedidos","Contador Anterior",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","Contador Atual",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","Diferen็a",1,1) 
		//Consumo Log		
		oExcel:AddColumn(cSheet,"Pedidos","P1",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","PE",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","PP",1,1)
		
		oExcel:AddColumn(cSheet,"Pedidos","P2",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","PE",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","PP",1,1) 
		
		oExcel:AddColumn(cSheet,"Pedidos","P3",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","PE",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","PP",1,1)

		oExcel:AddColumn(cSheet,"Pedidos","P4",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","PE",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","PP",1,1)


		oExcel:AddColumn(cSheet,"Pedidos","P5",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","PE",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","PP",1,1)

		oExcel:AddColumn(cSheet,"Pedidos","P6",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","PE",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","PP",1,1)

		oExcel:AddColumn(cSheet,"Pedidos","P7",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","PE",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","PP",1,1)

		oExcel:AddColumn(cSheet,"Pedidos","P8",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","PE",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","PP",1,1)

		oExcel:AddColumn(cSheet,"Pedidos","P9",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","PE",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","PP",1,1)

		oExcel:AddColumn(cSheet,"Pedidos","P10",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","PE",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","PP",1,1)

		oExcel:AddColumn(cSheet,"Pedidos","P11",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","PE",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","PP",1,1)

		oExcel:AddColumn(cSheet,"Pedidos","P12",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","PE",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","PP",1,1)

		oExcel:AddColumn(cSheet,"Pedidos","Total Ps",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","Minimo Doses",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","Complemento Doses",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","Pro-Rata Complemento",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","Vlr Unit Compl",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","Total Complemento",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","Sangria",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","Total a Faturar",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","ID Cliente",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","Endere็o",1,1) 
		oExcel:AddColumn(cSheet,"Pedidos","Remo็ใo",1,1)
		oExcel:AddColumn(cSheet,"Pedidos","Volume Minimo Contrato",1,1)
		
aAux := strtokarr(aProd[1,09],"/")
For nX := 1 to len(aAux)
	
		cQuery := "SELECT DISTINCT ZN_CONFERE,ZN_CLIENTE,ZN_LOJA,ZN_PATRIMO,N1_DESCRIC,ZD_DATAINS,ZD_DATAREM,"+chr(13)+chr(10)
		cQuery += " ZN_DATA,ZN_NUMANT,ZN_NUMATU,ZN_NUMATU-ZN_NUMANT AS DIF,ZN_BOTTEST"+chr(13)+chr(10)
		cQuery += " ,(SELECT TOP 1 ZN_DATA FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(aProd[1,13])+"' AND ZN_CONFERE<>'1' AND ZN_DATA NOT BETWEEN '"+dtos(aProd[1,14])+"' AND '"+dtos(aProd[1,15])+"' AND ZN_CLIENTE='"+SUBSTR(aProd[1,6],1,6)+"' AND ZN_PATRIMO='"+aAux[nX]+"' ORDER BY ZN_DATA DESC) AS UF_DATA"+chr(13)+chr(10)
		cQuery += " ,ZN_BOTAO01, (SELECT TOP 1 ZN_BOTAO01 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(aProd[1,13])+"' AND ZN_CONFERE<>'1' AND ZN_DATA NOT BETWEEN '"+dtos(aProd[1,14])+"' AND '"+dtos(aProd[1,15])+"' AND ZN_CLIENTE='"+SUBSTR(aProd[1,6],1,6)+"' AND ZN_PATRIMO='"+aAux[nX]+"' ORDER BY ZN_DATA DESC) AS UF_BOTAO01"+chr(13)+chr(10)
		cQuery += " ,ZN_BOTAO02, (SELECT TOP 1 ZN_BOTAO02 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(aProd[1,13])+"' AND ZN_CONFERE<>'1' AND ZN_DATA NOT BETWEEN '"+dtos(aProd[1,14])+"' AND '"+dtos(aProd[1,15])+"' AND ZN_CLIENTE='"+SUBSTR(aProd[1,6],1,6)+"' AND ZN_PATRIMO='"+aAux[nX]+"' ORDER BY ZN_DATA DESC) AS UF_BOTAO02"+chr(13)+chr(10)  
		cQuery += " ,ZN_BOTAO03, (SELECT TOP 1 ZN_BOTAO03 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(aProd[1,13])+"' AND ZN_CONFERE<>'1' AND ZN_DATA NOT BETWEEN '"+dtos(aProd[1,14])+"' AND '"+dtos(aProd[1,15])+"' AND ZN_CLIENTE='"+SUBSTR(aProd[1,6],1,6)+"' AND ZN_PATRIMO='"+aAux[nX]+"' ORDER BY ZN_DATA DESC) AS UF_BOTAO03"+chr(13)+chr(10)  
		cQuery += " ,ZN_BOTAO04, (SELECT TOP 1 ZN_BOTAO04 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(aProd[1,13])+"' AND ZN_CONFERE<>'1' AND ZN_DATA NOT BETWEEN '"+dtos(aProd[1,14])+"' AND '"+dtos(aProd[1,15])+"' AND ZN_CLIENTE='"+SUBSTR(aProd[1,6],1,6)+"' AND ZN_PATRIMO='"+aAux[nX]+"' ORDER BY ZN_DATA DESC) AS UF_BOTAO04"+chr(13)+chr(10)  
		cQuery += " ,ZN_BOTAO05, (SELECT TOP 1 ZN_BOTAO05 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(aProd[1,13])+"' AND ZN_CONFERE<>'1' AND ZN_DATA NOT BETWEEN '"+dtos(aProd[1,14])+"' AND '"+dtos(aProd[1,15])+"' AND ZN_CLIENTE='"+SUBSTR(aProd[1,6],1,6)+"' AND ZN_PATRIMO='"+aAux[nX]+"' ORDER BY ZN_DATA DESC) AS UF_BOTAO05"+chr(13)+chr(10)  
		cQuery += " ,ZN_BOTAO06, (SELECT TOP 1 ZN_BOTAO06 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(aProd[1,13])+"' AND ZN_CONFERE<>'1' AND ZN_DATA NOT BETWEEN '"+dtos(aProd[1,14])+"' AND '"+dtos(aProd[1,15])+"' AND ZN_CLIENTE='"+SUBSTR(aProd[1,6],1,6)+"' AND ZN_PATRIMO='"+aAux[nX]+"' ORDER BY ZN_DATA DESC) AS UF_BOTAO06"+chr(13)+chr(10)  
		cQuery += " ,ZN_BOTAO07, (SELECT TOP 1 ZN_BOTAO07 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(aProd[1,13])+"' AND ZN_CONFERE<>'1' AND ZN_DATA NOT BETWEEN '"+dtos(aProd[1,14])+"' AND '"+dtos(aProd[1,15])+"' AND ZN_CLIENTE='"+SUBSTR(aProd[1,6],1,6)+"' AND ZN_PATRIMO='"+aAux[nX]+"' ORDER BY ZN_DATA DESC) AS UF_BOTAO07"+chr(13)+chr(10)  
		cQuery += " ,ZN_BOTAO08, (SELECT TOP 1 ZN_BOTAO08 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(aProd[1,13])+"' AND ZN_CONFERE<>'1' AND ZN_DATA NOT BETWEEN '"+dtos(aProd[1,14])+"' AND '"+dtos(aProd[1,15])+"' AND ZN_CLIENTE='"+SUBSTR(aProd[1,6],1,6)+"' AND ZN_PATRIMO='"+aAux[nX]+"' ORDER BY ZN_DATA DESC) AS UF_BOTAO08"+chr(13)+chr(10)  
		cQuery += " ,ZN_BOTAO09, (SELECT TOP 1 ZN_BOTAO09 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(aProd[1,13])+"' AND ZN_CONFERE<>'1' AND ZN_DATA NOT BETWEEN '"+dtos(aProd[1,14])+"' AND '"+dtos(aProd[1,15])+"' AND ZN_CLIENTE='"+SUBSTR(aProd[1,6],1,6)+"' AND ZN_PATRIMO='"+aAux[nX]+"' ORDER BY ZN_DATA DESC) AS UF_BOTAO09"+chr(13)+chr(10)  
		cQuery += " ,ZN_BOTAO10, (SELECT TOP 1 ZN_BOTAO10 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(aProd[1,13])+"' AND ZN_CONFERE<>'1' AND ZN_DATA NOT BETWEEN '"+dtos(aProd[1,14])+"' AND '"+dtos(aProd[1,15])+"' AND ZN_CLIENTE='"+SUBSTR(aProd[1,6],1,6)+"' AND ZN_PATRIMO='"+aAux[nX]+"' ORDER BY ZN_DATA DESC) AS UF_BOTAO10"+chr(13)+chr(10)  
		cQuery += " ,ZN_BOTAO11, (SELECT TOP 1 ZN_BOTAO11 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(aProd[1,13])+"' AND ZN_CONFERE<>'1' AND ZN_DATA NOT BETWEEN '"+dtos(aProd[1,14])+"' AND '"+dtos(aProd[1,15])+"' AND ZN_CLIENTE='"+SUBSTR(aProd[1,6],1,6)+"' AND ZN_PATRIMO='"+aAux[nX]+"' ORDER BY ZN_DATA DESC) AS UF_BOTAO11"+chr(13)+chr(10)  
		cQuery += " ,ZN_BOTAO12, (SELECT TOP 1 ZN_BOTAO12 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(aProd[1,13])+"' AND ZN_CONFERE<>'1' AND ZN_DATA NOT BETWEEN '"+dtos(aProd[1,14])+"' AND '"+dtos(aProd[1,15])+"' AND ZN_CLIENTE='"+SUBSTR(aProd[1,6],1,6)+"' AND ZN_PATRIMO='"+aAux[nX]+"' ORDER BY ZN_DATA DESC) AS UF_BOTAO12"+chr(13)+chr(10) 
		cQuery += " ,N1_XVOLMIN,DA0_CODTAB,A1_END,A1_BAIRRO,A1_MUN,A1_EST,N1_XCODCC,"+chr(13)+chr(10)
		cQuery += " (SELECT SUM(ZN_MOEDA1R+ZN_NOTA01) FROM "+RetSQLName("SZN")+" ZN WHERE ZN_TIPINCL='SANGRIA' AND ZN.D_E_L_E_T_='' AND ZN_DATA BETWEEN '"+dtos(aProd[1,12])+"' AND '"+dtos(aProd[1,13])+"' AND ZN_CLIENTE='"+SUBSTR(aProd[1,6],1,6)+"' AND ZN_PATRIMO='"+aAux[nX]+"') AS SANGRIA"+chr(13)+chr(10)
		            
		For nTT := 1 to 12
			cQuery += " ,N1_XP"+cvaltochar(nTT)+",D"+cvaltochar(nTT)+".DA1_PRCVEN AS PE"+cvaltochar(nTT)+",D"+cvaltochar(nTT)+".DA1_XPRCPP AS PP"+cvaltochar(nTT)+chr(13)+chr(10)
		Next nTT
		
		cQuery += " FROM "+RetSQLName("SZN")+" ZN"+chr(13)+chr(10)
		cQuery += " INNER JOIN "+RetSQLName("SN1")+" N1 ON N1_CHAPA=ZN_PATRIMO AND N1.D_E_L_E_T_=''"+chr(13)+chr(10)
		cQuery += " LEFT JOIN "+RetSQLName("SZD")+" ZD ON ZD_PATRIMO=ZN_PATRIMO AND ZD.D_E_L_E_T_='' AND ZD_CLIENTE=ZN_CLIENTE AND ZD_LOJA=ZN_LOJA AND ZD_IDSTATU='1'"+chr(13)+chr(10)
		cQuery += " LEFT JOIN "+RetSQLName("DA0")+" DA0 ON DA0_XCLIEN=ZN_CLIENTE AND DA0.D_E_L_E_T_='' AND DA0_ATIVO='1'"+chr(13)+chr(10)
		
		For nTT := 1 to 12                                                                                                       
			cQuery += " LEFT JOIN "+RetSQLName("DA1")+" D"+cvaltochar(nTT)+" ON D"+cvaltochar(nTT)+".DA1_CODTAB=DA0_CODTAB AND D"+cvaltochar(nTT)+".DA1_CODPRO=N1_XP"+cvaltochar(nTT)+" AND D"+cvaltochar(nTT)+".D_E_L_E_T_=''"+chr(13)+chr(10)
		Next nTT
		
		cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_COD=ZN_CLIENTE AND A1_LOJA=ZN_LOJA AND A1.D_E_L_E_T_=''"+chr(13)+chr(10)
		cQuery += " WHERE ZN_TIPINCL<>'SANGRIA' AND ZN.D_E_L_E_T_='' AND (ZN_DATA BETWEEN '"+dtos(aProd[1,14])+"' AND '"+dtos(aProd[1,15])+"' OR ZN_CONFERE='1')"+chr(13)+chr(10)
		cQuery += " AND ZN_CLIENTE='"+SUBSTR(aProd[1,6],1,6)+"' AND ZN_PATRIMO='"+aAux[nX]+"'"+chr(13)+chr(10)
		cQuery += " ORDER BY 7 DESC"+chr(13)+chr(10)
		

		If Select('TRB') > 0
			dbSelectArea('TRB')
			dbCloseArea()
		EndIf
		
		MemoWrite("TTPRO20.SQL",cQuery)
		DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
		
		DbSelectArea("TRB")
		//ZN_CLIENTE,ZN_LOJA,ZN_PATRIMO,N1_DESCRIC,ZD_DATAINS,ZD_DATAREM,ZN_DATA,ZN_NUMANT,ZN_NUMATU,ZN_NUMATU-ZN_NUMANT AS DIF,
		//ZN_BOTTEST,ZN_BOTAO01,ZN_BOTAO02,ZN_BOTAO03,ZN_BOTAO04,ZN_BOTAO05,ZN_BOTAO06,ZN_BOTAO07,ZN_BOTAO08,ZN_BOTAO09,ZN_BOTAO10,ZN_BOTAO11,ZN_BOTAO12,
		//N1_XVOLMIN,N1_XP1,DA1_PRCVEN,DA1_XPRCPP,DA0_CODTAB,A1_END,A1_BAIRRO,A1_MUN,A1_EST,sangria
		While !EOF()	
            IF Ascan(aSheAn,{|x| x[1] == TRB->ZN_PATRIMO}) == 0
				Aadd(aSheAn,{TRB->ZN_PATRIMO,TRB->N1_XP1,Alltrim(Posicione("SB1",1,xFilial("SB1")+TRB->N1_XP1,"B1_DESC")),TRB->ZN_BOTAO01-TRB->UF_BOTAO01,TRB->PE1,TRB->PP1,TRB->N1_XCODCC,'1'})
				Aadd(aSheAn,{TRB->ZN_PATRIMO,TRB->N1_XP2,Alltrim(Posicione("SB1",1,xFilial("SB1")+TRB->N1_XP2,"B1_DESC")),TRB->ZN_BOTAO02-TRB->UF_BOTAO02,TRB->PE2,TRB->PP2,TRB->N1_XCODCC,'2'})
				Aadd(aSheAn,{TRB->ZN_PATRIMO,TRB->N1_XP3,Alltrim(Posicione("SB1",1,xFilial("SB1")+TRB->N1_XP3,"B1_DESC")),TRB->ZN_BOTAO03-TRB->UF_BOTAO03,TRB->PE3,TRB->PP3,TRB->N1_XCODCC,'3'})
				Aadd(aSheAn,{TRB->ZN_PATRIMO,TRB->N1_XP4,Alltrim(Posicione("SB1",1,xFilial("SB1")+TRB->N1_XP4,"B1_DESC")),TRB->ZN_BOTAO04-TRB->UF_BOTAO04,TRB->PE4,TRB->PP4,TRB->N1_XCODCC,'4'})
				Aadd(aSheAn,{TRB->ZN_PATRIMO,TRB->N1_XP5,Alltrim(Posicione("SB1",1,xFilial("SB1")+TRB->N1_XP5,"B1_DESC")),TRB->ZN_BOTAO05-TRB->UF_BOTAO05,TRB->PE5,TRB->PP5,TRB->N1_XCODCC,'5'})
				Aadd(aSheAn,{TRB->ZN_PATRIMO,TRB->N1_XP6,Alltrim(Posicione("SB1",1,xFilial("SB1")+TRB->N1_XP6,"B1_DESC")),TRB->ZN_BOTAO06-TRB->UF_BOTAO06,TRB->PE6,TRB->PP6,TRB->N1_XCODCC,'6'})
				Aadd(aSheAn,{TRB->ZN_PATRIMO,TRB->N1_XP7,Alltrim(Posicione("SB1",1,xFilial("SB1")+TRB->N1_XP7,"B1_DESC")),TRB->ZN_BOTAO07-TRB->UF_BOTAO07,TRB->PE7,TRB->PP7,TRB->N1_XCODCC,'7'})
				Aadd(aSheAn,{TRB->ZN_PATRIMO,TRB->N1_XP8,Alltrim(Posicione("SB1",1,xFilial("SB1")+TRB->N1_XP8,"B1_DESC")),TRB->ZN_BOTAO08-TRB->UF_BOTAO08,TRB->PE8,TRB->PP8,TRB->N1_XCODCC,'8'})
				Aadd(aSheAn,{TRB->ZN_PATRIMO,TRB->N1_XP9,Alltrim(Posicione("SB1",1,xFilial("SB1")+TRB->N1_XP9,"B1_DESC")),TRB->ZN_BOTAO09-TRB->UF_BOTAO09,TRB->PE9,TRB->PP9,TRB->N1_XCODCC,'9'})
				Aadd(aSheAn,{TRB->ZN_PATRIMO,TRB->N1_XP10,Alltrim(Posicione("SB1",1,xFilial("SB1")+TRB->N1_XP10,"B1_DESC")),TRB->ZN_BOTAO10-TRB->UF_BOTAO10,TRB->PE10,TRB->PP10,TRB->N1_XCODCC,'10'})
				Aadd(aSheAn,{TRB->ZN_PATRIMO,TRB->N1_XP11,Alltrim(Posicione("SB1",1,xFilial("SB1")+TRB->N1_XP11,"B1_DESC")),TRB->ZN_BOTAO11-TRB->UF_BOTAO11,TRB->PE11,TRB->PP11,TRB->N1_XCODCC,'11'})
				Aadd(aSheAn,{TRB->ZN_PATRIMO,TRB->N1_XP12,Alltrim(Posicione("SB1",1,xFilial("SB1")+TRB->N1_XP12,"B1_DESC")),TRB->ZN_BOTAO12-TRB->UF_BOTAO12,TRB->PE12,TRB->PP12,TRB->N1_XCODCC,'12'})
			Else
				If TRB->ZN_CONFERE != "T"
				 	aSheAn[Ascan(aSheAn,{|x| x[1]+x[8] == TRB->ZN_PATRIMO+'1'}),04] -= TRB->ZN_BOTAO01-TRB->UF_BOTAO01 
				 	aSheAn[Ascan(aSheAn,{|x| x[1]+x[8] == TRB->ZN_PATRIMO+'2'}),04] -= TRB->ZN_BOTAO02-TRB->UF_BOTAO02
				 	aSheAn[Ascan(aSheAn,{|x| x[1]+x[8] == TRB->ZN_PATRIMO+'3'}),04] -= TRB->ZN_BOTAO03-TRB->UF_BOTAO03
				 	aSheAn[Ascan(aSheAn,{|x| x[1]+x[8] == TRB->ZN_PATRIMO+'4'}),04] -= TRB->ZN_BOTAO04-TRB->UF_BOTAO04
				 	aSheAn[Ascan(aSheAn,{|x| x[1]+x[8] == TRB->ZN_PATRIMO+'5'}),04] -= TRB->ZN_BOTAO05-TRB->UF_BOTAO05
				 	aSheAn[Ascan(aSheAn,{|x| x[1]+x[8] == TRB->ZN_PATRIMO+'6'}),04] -= TRB->ZN_BOTAO06-TRB->UF_BOTAO06
				 	aSheAn[Ascan(aSheAn,{|x| x[1]+x[8] == TRB->ZN_PATRIMO+'7'}),04] -= TRB->ZN_BOTAO07-TRB->UF_BOTAO07
				 	aSheAn[Ascan(aSheAn,{|x| x[1]+x[8] == TRB->ZN_PATRIMO+'8'}),04] -= TRB->ZN_BOTAO08-TRB->UF_BOTAO08
				 	aSheAn[Ascan(aSheAn,{|x| x[1]+x[8] == TRB->ZN_PATRIMO+'9'}),04] -= TRB->ZN_BOTAO09-TRB->UF_BOTAO09
				 	aSheAn[Ascan(aSheAn,{|x| x[1]+x[8] == TRB->ZN_PATRIMO+'10'}),04] -= TRB->ZN_BOTAO10-TRB->UF_BOTAO10
				 	aSheAn[Ascan(aSheAn,{|x| x[1]+x[8] == TRB->ZN_PATRIMO+'11'}),04] -= TRB->ZN_BOTAO11-TRB->UF_BOTAO11
				 	aSheAn[Ascan(aSheAn,{|x| x[1]+x[8] == TRB->ZN_PATRIMO+'12'}),04] -= TRB->ZN_BOTAO12-TRB->UF_BOTAO12
				Else
				 	aSheAn[Ascan(aSheAn,{|x| x[1]+x[8] == TRB->ZN_PATRIMO+'1'}),04] += TRB->ZN_BOTAO01-TRB->UF_BOTAO01 
				 	aSheAn[Ascan(aSheAn,{|x| x[1]+x[8] == TRB->ZN_PATRIMO+'2'}),04] += TRB->ZN_BOTAO02-TRB->UF_BOTAO02
				 	aSheAn[Ascan(aSheAn,{|x| x[1]+x[8] == TRB->ZN_PATRIMO+'3'}),04] += TRB->ZN_BOTAO03-TRB->UF_BOTAO03
				 	aSheAn[Ascan(aSheAn,{|x| x[1]+x[8] == TRB->ZN_PATRIMO+'4'}),04] += TRB->ZN_BOTAO04-TRB->UF_BOTAO04
				 	aSheAn[Ascan(aSheAn,{|x| x[1]+x[8] == TRB->ZN_PATRIMO+'5'}),04] += TRB->ZN_BOTAO05-TRB->UF_BOTAO05
				 	aSheAn[Ascan(aSheAn,{|x| x[1]+x[8] == TRB->ZN_PATRIMO+'6'}),04] += TRB->ZN_BOTAO06-TRB->UF_BOTAO06
				 	aSheAn[Ascan(aSheAn,{|x| x[1]+x[8] == TRB->ZN_PATRIMO+'7'}),04] += TRB->ZN_BOTAO07-TRB->UF_BOTAO07
				 	aSheAn[Ascan(aSheAn,{|x| x[1]+x[8] == TRB->ZN_PATRIMO+'8'}),04] += TRB->ZN_BOTAO08-TRB->UF_BOTAO08
				 	aSheAn[Ascan(aSheAn,{|x| x[1]+x[8] == TRB->ZN_PATRIMO+'9'}),04] += TRB->ZN_BOTAO09-TRB->UF_BOTAO09
				 	aSheAn[Ascan(aSheAn,{|x| x[1]+x[8] == TRB->ZN_PATRIMO+'10'}),04] += TRB->ZN_BOTAO10-TRB->UF_BOTAO10
				 	aSheAn[Ascan(aSheAn,{|x| x[1]+x[8] == TRB->ZN_PATRIMO+'11'}),04] += TRB->ZN_BOTAO11-TRB->UF_BOTAO11
				 	aSheAn[Ascan(aSheAn,{|x| x[1]+x[8] == TRB->ZN_PATRIMO+'12'}),04] += TRB->ZN_BOTAO12-TRB->UF_BOTAO12
				EndIf
			 	
			EndIf			                      
			
			If Ascan(aSintet,{|x| x[1] == TRB->ZN_PATRIMO}) == 0 .OR. TRB->ZN_CONFERE == "T"
				Aadd(aSintet,{TRB->ZN_PATRIMO,TRB->N1_DESCRIC,cvaltochar(STOD(TRB->ZD_DATAINS)),cvaltochar(STOD(TRB->ZD_DATAREM)),;
								cvaltochar(STOD(TRB->ZN_DATA)),TRB->ZN_NUMANT,TRB->ZN_NUMATU,TRB->DIF,;
								TRB->ZN_BOTAO01-TRB->UF_BOTAO01,TRB->PE1,TRB->PP1,;
								TRB->ZN_BOTAO02-TRB->UF_BOTAO02,TRB->PE2,TRB->PP2,;
								TRB->ZN_BOTAO03-TRB->UF_BOTAO03,TRB->PE3,TRB->PP3,;
								TRB->ZN_BOTAO04-TRB->UF_BOTAO04,TRB->PE4,TRB->PP4,;
								TRB->ZN_BOTAO05-TRB->UF_BOTAO05,TRB->PE5,TRB->PP5,;
								TRB->ZN_BOTAO06-TRB->UF_BOTAO06,TRB->PE6,TRB->PP6,;
								TRB->ZN_BOTAO07-TRB->UF_BOTAO07,TRB->PE7,TRB->PP7,;
								TRB->ZN_BOTAO08-TRB->UF_BOTAO08,TRB->PE8,TRB->PP8,;
								TRB->ZN_BOTAO09-TRB->UF_BOTAO09,TRB->PE9,TRB->PP9,;
								TRB->ZN_BOTAO10-TRB->UF_BOTAO10,TRB->PE10,TRB->PP10,;
								TRB->ZN_BOTAO11-TRB->UF_BOTAO11,TRB->PE11,TRB->PP11,;
								TRB->ZN_BOTAO12-TRB->UF_BOTAO12,TRB->PE12,TRB->PP12,;
								(TRB->ZN_BOTAO01+TRB->ZN_BOTAO02+TRB->ZN_BOTAO03+TRB->ZN_BOTAO04+TRB->ZN_BOTAO05+TRB->ZN_BOTAO06+TRB->ZN_BOTAO07+TRB->ZN_BOTAO08+TRB->ZN_BOTAO09+TRB->ZN_BOTAO10+TRB->ZN_BOTAO11+TRB->ZN_BOTAO12) - (TRB->UF_BOTAO01+TRB->UF_BOTAO02+TRB->UF_BOTAO03+TRB->UF_BOTAO04+TRB->UF_BOTAO05+TRB->UF_BOTAO06+TRB->UF_BOTAO07+TRB->UF_BOTAO08+TRB->UF_BOTAO09+TRB->UF_BOTAO10+TRB->UF_BOTAO11+TRB->UF_BOTAO12),;		
								If(Ascan(aProRa,{|x| x[2] == TRB->ZN_PATRIMO})>0,aProRa[Ascan(aProRa,{|x| x[2] == TRB->ZN_PATRIMO}),06],TRB->N1_XVOLMIN),;
								0,0,0,0,TRB->SANGRIA,0,TRB->N1_XCODCC,TRB->A1_END+" - "+TRB->A1_BAIRRO+" - "+TRB->A1_MUN,cvaltochar(stod(UF_DATA)),;
								If(TRB->N1_XVOLMIN>0,TRB->N1_XVOLMIN,aContr[Ascan(aContr,{|x| x[1] == aProd[1,7]}),13])})
			Else
				aSintet[Ascan(aSintet,{|x| x[1] == TRB->ZN_PATRIMO}),09] -= TRB->ZN_BOTAO01-TRB->UF_BOTAO01
				aSintet[Ascan(aSintet,{|x| x[1] == TRB->ZN_PATRIMO}),12] -= TRB->ZN_BOTAO02-TRB->UF_BOTAO02
				aSintet[Ascan(aSintet,{|x| x[1] == TRB->ZN_PATRIMO}),15] -= TRB->ZN_BOTAO03-TRB->UF_BOTAO03
				aSintet[Ascan(aSintet,{|x| x[1] == TRB->ZN_PATRIMO}),18] -= TRB->ZN_BOTAO04-TRB->UF_BOTAO04
				aSintet[Ascan(aSintet,{|x| x[1] == TRB->ZN_PATRIMO}),21] -= TRB->ZN_BOTAO05-TRB->UF_BOTAO05
				aSintet[Ascan(aSintet,{|x| x[1] == TRB->ZN_PATRIMO}),24] -= TRB->ZN_BOTAO06-TRB->UF_BOTAO06
				aSintet[Ascan(aSintet,{|x| x[1] == TRB->ZN_PATRIMO}),27] -= TRB->ZN_BOTAO07-TRB->UF_BOTAO07
				aSintet[Ascan(aSintet,{|x| x[1] == TRB->ZN_PATRIMO}),30] -= TRB->ZN_BOTAO08-TRB->UF_BOTAO08
				aSintet[Ascan(aSintet,{|x| x[1] == TRB->ZN_PATRIMO}),33] -= TRB->ZN_BOTAO09-TRB->UF_BOTAO09
				aSintet[Ascan(aSintet,{|x| x[1] == TRB->ZN_PATRIMO}),36] -= TRB->ZN_BOTAO10-TRB->UF_BOTAO10
				aSintet[Ascan(aSintet,{|x| x[1] == TRB->ZN_PATRIMO}),39] -= TRB->ZN_BOTAO11-TRB->UF_BOTAO11
				aSintet[Ascan(aSintet,{|x| x[1] == TRB->ZN_PATRIMO}),42] -= TRB->ZN_BOTAO12-TRB->UF_BOTAO12
			EndIf
												
		dbskip()
	Enddo	
Next nX            

nProC	:=	0
nTot1	:=	0
nTot2	:=	0 
nPrcUn	:=	0

AEval(aSintet, {|aSintet| nTotPr += aSintet[45] })   
AEval(aProra, {|aProra| If(aProra[8]==0,aProra[6]/len(aProra),aProRa[8]) })  

For nX := 1 to len(aSintet)  
	If Ascan(aProra,{|x| x[2] == aSintet[nX,01]}) > 0
		aSintet[nX,47]	:=	If(round((aSintet[nX,45]/nTotPr) * (aSintet[nX,46]-nTotPr),0)>0,round((aSintet[nX,45]/nTotPr) * (aSintet[nX,46]-nTotPr),0),0)
	Else
		aSintet[nX,47] := If(aSintet[nX,46]-aSintet[nX,45]>0,aSintet[nX,46]-aSintet[nX,45],0)
	EndIf
	nProC += aSintet[nX,47]
	nTot1 += If(aSintet[nX,45] < aSintet[nX,46],aSintet[nX,45],0)
	nTot2 += aSintet[nX,46] 
Next nX                    
                   
cTabela := ''
For nX := 1 to len(aProd)
	If aProd[nX,04] > 0 .And. nPrcUn == 0
		nPrcUn := aProd[nX,04]           
	endif
	If Empty(cTabela) .And. !Empty(aProd[nX,16])
		cTabela := aProd[nx,16]
	EndIf
Next nX

For nX := 1 to len(aSintet)
	
	If nPrcUn == 0
		nPrcUn := Posicione("DA1",1,xFilial("DA1")+cTabela+aContr[Ascan(aContr,{|x| x[1] == aProd[1,7]}),16],"DA1_PRCVEN")
	eNDiF
	
	If aSintet[nX,45] < aSintet[nX,46]
		aSintet[nX,48] := round((aSintet[nX,45] / nTot1) * nProC,0)
	EndIf                                                          
	aSintet[nX,49] := nPrcUn
	aSintet[nX,50] := aSintet[nX,49] * aSintet[nX,48]
	
	aSintet[nX,52] += (aSintet[nX,09]*aSintet[nX,10])+(aSintet[nX,12]*aSintet[nX,13])+(aSintet[nX,15]*aSintet[nX,16])+(aSintet[nX,18]*aSintet[nX,19])+(aSintet[nX,21]*aSintet[nX,22])+(aSintet[nX,24]*aSintet[nX,25])+(aSintet[nX,27]*aSintet[nX,28])+(aSintet[nX,30]*aSintet[nX,31])+(aSintet[nX,33]*aSintet[nX,34])+(aSintet[nX,36]*aSintet[nX,37])+(aSintet[nX,39]*aSintet[nX,40])+(aSintet[nX,42]*aSintet[nX,43])+aSintet[nX,50]
Next nX                    

For nX := 1 to len(aSintet)
	oExcel:AddRow(cSheet,"Pedidos",{aSintet[nX,01],aSintet[nX,02],aSintet[nX,03],aSintet[nX,55],aSintet[nX,05],;
									aSintet[nX,06],aSintet[nX,07],aSintet[nX,08],aSintet[nX,09],aSintet[nX,10],;
									aSintet[nX,11],aSintet[nX,12],aSintet[nX,13],aSintet[nX,14],aSintet[nX,15],;
									aSintet[nX,16],aSintet[nX,17],aSintet[nX,18],aSintet[nX,19],aSintet[nX,20],;
									aSintet[nX,21],aSintet[nX,22],aSintet[nX,23],aSintet[nX,24],aSintet[nX,25],;
									aSintet[nX,26],aSintet[nX,27],aSintet[nX,28],aSintet[nX,29],aSintet[nX,30],;
									aSintet[nX,31],aSintet[nX,32],aSintet[nX,33],aSintet[nX,34],aSintet[nX,35],;
									aSintet[nX,36],aSintet[nX,37],aSintet[nX,38],aSintet[nX,39],aSintet[nX,40],;
									aSintet[nX,41],aSintet[nX,42],aSintet[nX,43],aSintet[nX,44],aSintet[nX,45],;
									ROUND(aSintet[nX,46],0),ROUND(aSintet[nX,47],0),ROUND(aSintet[nX,48],0),aSintet[nX,49],aSintet[nX,50],;
									aSintet[nX,51],aSintet[nX,52],aSintet[nX,53],aSintet[nX,54],aSintet[nX,04],aSintet[nX,56]})

Next nX

cSheet := "Analitico" 
nQtd 	:= 0
nTotal 	:= 0
nTotal2	:= 0

oExcel:AddworkSheet(cSheet) 
oExcel:AddTable (cSheet,"Pedidos")
oExcel:AddColumn(cSheet,"Pedidos","Patrim๔nio",1,1)
oExcel:AddColumn(cSheet,"Pedidos","Produto",1,1)
oExcel:AddColumn(cSheet,"Pedidos","Descri็ใo",1,1)
oExcel:AddColumn(cSheet,"Pedidos","Quantidade",1,1)
oExcel:AddColumn(cSheet,"Pedidos","Valor Unit. Empresa",1,1)
oExcel:AddColumn(cSheet,"Pedidos","Valor Total Empresa",1,1)
oExcel:AddColumn(cSheet,"Pedidos","Valor Unit. Publico",1,1)
oExcel:AddColumn(cSheet,"Pedidos","Valor Total Publico",1,1) 
oExcel:AddColumn(cSheet,"Pedidos","ID_Cliente",1,1)

nQtd	:=	0
nTotal	:=	0
nTotal2	:=	0

For nX := 1 to len(aSheAn)
	If aSheAn[nX,04] > 0
		
		If aSintet[Ascan(aSintet,{|x| x[1] == aSheAn[nX,01]}),48] > 0 .And. len(aBira) < 1
			Aadd(aBira,{aSheAn[nX,01],aContr[Ascan(aContr,{|x| x[1] == aProd[01,07]}),16],;
						Posicione("SB1",1,xFilial("SB1")+aContr[Ascan(aContr,{|x| x[1] == aProd[01,07]}),16],"B1_DESC"),;
						aSintet[Ascan(aSintet,{|x| x[1] == aSheAn[nX,01]}),48],aSintet[Ascan(aSintet,{|x| x[1] == aSheAn[nX,01]}),49],;
						0,0,aSheAn[nX,07]})
						nQtd += aBira[len(aBira),04] 
						nTotal += aBira[len(aBira),04]*aBira[len(aBira),05]
						nTotal2 += aBira[len(aBira),04]*aBira[len(aBira),06]
			
		EndIf
		
		nQtd 	+=	aSheAn[nX,04]
	    nTotal 	+= aSheAn[nX,05]*aSheAn[nX,04]
	    nTotal2	+= aSheAn[nX,06]*aSheAn[nX,04]
        
		oExcel:AddRow(cSheet,"Pedidos",{aSheAn[nX,01],;
										aSheAn[nX,02],;
										aSheAn[nX,03],;
										aSheAn[nX,04],;
										round(aSheAn[nX,05],4),;
										round(aSheAn[nX,05]*aSheAn[nX,04],4),;
										round(aSheAn[nX,06],4),;
										round(aSheAn[nX,06]*aSheAn[nX,04],4),;
										aSheAn[nX,07]})
	EndIf
	nAux++
	If nAux > 12  
		If nQtd > 0  
			If len(aBira) > 0
				oExcel:AddRow(cSheet,"Pedidos",{aBira[len(aBira),01],;
											aBira[len(aBira),02],;
											aBira[len(aBira),03],;
											aBira[len(aBira),04],;
											round(aBira[len(aBira),05],4),;
											round(aBira[len(aBira),05]*aBira[len(aBira),04],4),;
											round(aBira[len(aBira),06],4),;
											round(aBira[len(aBira),06]*aBira[len(aBira),04],4),;
											aBira[len(aBira),07]})
				aBira := {}
			EndIf
										
			oExcel:AddRow(cSheet,"Pedidos",{"Totais",;
											"",;
											"",;
											nQtd,;
											"",;
											round(nTotal,4),;
											"",;
											round(nTotal2,4),;
											""})
		EndIf 
        nQtdA	+= nQtd
        nTotalA	+= nTotal
        nTotal2A+= nTotal2
 		nQtd := 0
		nTotal := 0
		nTotal2 := 0
		oExcel:AddRow(cSheet,"Pedidos",{"",;
										"",;
										"",;
										"",;
										"",;
										"",;
										"",;
										"",;
										""})
		nAux := 1
	EndIf
Next nX 		

oExcel:AddRow(cSheet,"Pedidos",{"",;
								"",;
								"",;
								"",;
								"",;
								"",;
								"",;
								"",;
								""})
 
oExcel:AddRow(cSheet,"Pedidos",{"Total Geral",;
								"",;
								"",;
								nQtdA,;
								"",;
								round(nTotalA,4),;
								"",;
								round(nTotal2A,4),;
								""})
									
oExcel:Activate()

oExcel:GetXMLFile(cDir +cArqXls)

If File(cDir +cArqXls)
	Aviso("TTPROC20","A planilha foi gerada em "+cDir,{"Ok"})
	If !ApOleClient( 'MsExcel' )
		Aviso("TTPROC20", 'MsExcel nใo instalado. ' +CRLF +'O arquivo estแ em: '+cDir )
	Else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cDir +cArqXls )
		oExcelApp:SetVisible(.T.)         
		oExcelApp:Destroy()
	EndIf
EndIf  

Return  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC20  บAutor  ณMicrosiga           บ Data ณ  09/16/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Pegar as doses apontadas nos patrimonios.                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ADoses()

Local aArea	:=	GetArea()
Local cQuery
Local aRetorno	:=	{} 
Local aInsCli	:=	{}
Local aRet		:=	{}
Local cPerc1	
Local cPerc2
  
//For nX := 1 to len(aContr)
For nX := 1 to len(aPatri)
	//cPer1  := CTOD(SUBSTR(aPatri[nX,09],1,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-1)),3))
	cPer1 := mv_par06
	//cPer2  := If(SUBSTR(aPatri[nX,09],1,2) >= substr(aPatri[nX,09],4,2),CTOD(SUBSTR(aPatri[nX,09],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03))),3)),CTOD(SUBSTR(aPatri[nX,09],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-1)),3)))
	cPer2 := mv_par07
	//cPerc1 := CTOD(SUBSTR(aPatri[nX,12],1,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03))),3))
	//cPerc2 := CTOD(SUBSTR(aPatri[nX,12],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03))),3))
	//cPerc1 := If(SUBSTR(aPatri[nX,12],1,2) >= substr(aPatri[nX,12],4,2),CTOD(SUBSTR(aPatri[nX,12],1,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-1)),3)),CTOD(SUBSTR(aPatri[nX,12],1,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03))),3))) //CTOD(SUBSTR(aPatri[nX,12],1,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03))),3))
	cPerc1 := cPer1
	//cPerc2 := If(SUBSTR(aPatri[nX,12],1,2) >= substr(aPatri[nX,12],4,2),CTOD(SUBSTR(aPatri[nX,12],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-1)),3)),CTOD(SUBSTR(aPatri[nX,12],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03))),3))) //CTOD(SUBSTR(aPatri[nX,12],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03))),3)) 
 	cPerc2 := cPer2
 	
	//O que foi apontado em cada uma das maquinas.
	cQuery := "SELECT ZN_CLIENTE,ZN_LOJA,ZN_BOTTEST,ZN_BOTAO01,ZN_BOTAO02,ZN_BOTAO03,ZN_BOTAO04,ZN_BOTAO05,ZN_BOTAO06,ZN_BOTAO07,ZN_BOTAO08,ZN_BOTAO09,"
	cQuery += " ZN_BOTAO10,ZN_BOTAO11,ZN_BOTAO12,ZN_PATRIMO,"
	cQuery += " N1_XP1,N1_XP2,N1_XP3,N1_XP4,N1_XP5,N1_XP6,N1_XP7,N1_XP8,N1_XP9,N1_XP10,N1_XP11,N1_XP12,"
	//Desacumular os contadores
	cQuery += " (SELECT TOP 1 ZN_BOTAO01 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(cPer2)+"' AND ZN_DATA NOT BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"' AND ZN_CLIENTE='"+aPatri[nX,03]+"'  AND ZN_PATRIMO='"+aPatri[nX,06]+"' ORDER BY ZN_DATA DESC) AS UF_BOTAO01,"
	cQuery += " (SELECT TOP 1 ZN_BOTAO02 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(cPer2)+"' AND ZN_DATA NOT BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"' AND ZN_CLIENTE='"+aPatri[nX,03]+"'  AND ZN_PATRIMO='"+aPatri[nX,06]+"' ORDER BY ZN_DATA DESC) AS UF_BOTAO02,"
	cQuery += " (SELECT TOP 1 ZN_BOTAO03 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(cPer2)+"' AND ZN_DATA NOT BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"' AND ZN_CLIENTE='"+aPatri[nX,03]+"'  AND ZN_PATRIMO='"+aPatri[nX,06]+"' ORDER BY ZN_DATA DESC) AS UF_BOTAO03,"
	cQuery += " (SELECT TOP 1 ZN_BOTAO04 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(cPer2)+"' AND ZN_DATA NOT BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"' AND ZN_CLIENTE='"+aPatri[nX,03]+"'  AND ZN_PATRIMO='"+aPatri[nX,06]+"' ORDER BY ZN_DATA DESC) AS UF_BOTAO04,"
	cQuery += " (SELECT TOP 1 ZN_BOTAO05 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(cPer2)+"' AND ZN_DATA NOT BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"' AND ZN_CLIENTE='"+aPatri[nX,03]+"'  AND ZN_PATRIMO='"+aPatri[nX,06]+"' ORDER BY ZN_DATA DESC) AS UF_BOTAO05,"
	cQuery += " (SELECT TOP 1 ZN_BOTAO06 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(cPer2)+"' AND ZN_DATA NOT BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"' AND ZN_CLIENTE='"+aPatri[nX,03]+"'  AND ZN_PATRIMO='"+aPatri[nX,06]+"' ORDER BY ZN_DATA DESC) AS UF_BOTAO06,"
	cQuery += " (SELECT TOP 1 ZN_BOTAO07 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(cPer2)+"' AND ZN_DATA NOT BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"' AND ZN_CLIENTE='"+aPatri[nX,03]+"'  AND ZN_PATRIMO='"+aPatri[nX,06]+"' ORDER BY ZN_DATA DESC) AS UF_BOTAO07,"
	cQuery += " (SELECT TOP 1 ZN_BOTAO08 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(cPer2)+"' AND ZN_DATA NOT BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"' AND ZN_CLIENTE='"+aPatri[nX,03]+"'  AND ZN_PATRIMO='"+aPatri[nX,06]+"' ORDER BY ZN_DATA DESC) AS UF_BOTAO08,"
	cQuery += " (SELECT TOP 1 ZN_BOTAO09 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(cPer2)+"' AND ZN_DATA NOT BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"' AND ZN_CLIENTE='"+aPatri[nX,03]+"'  AND ZN_PATRIMO='"+aPatri[nX,06]+"' ORDER BY ZN_DATA DESC) AS UF_BOTAO09,"
	cQuery += " (SELECT TOP 1 ZN_BOTAO10 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(cPer2)+"' AND ZN_DATA NOT BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"' AND ZN_CLIENTE='"+aPatri[nX,03]+"'  AND ZN_PATRIMO='"+aPatri[nX,06]+"' ORDER BY ZN_DATA DESC) AS UF_BOTAO10,"
	cQuery += " (SELECT TOP 1 ZN_BOTAO11 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(cPer2)+"' AND ZN_DATA NOT BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"' AND ZN_CLIENTE='"+aPatri[nX,03]+"'  AND ZN_PATRIMO='"+aPatri[nX,06]+"' ORDER BY ZN_DATA DESC) AS UF_BOTAO11,"
	cQuery += " (SELECT TOP 1 ZN_BOTAO12 FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(cPer2)+"' AND ZN_DATA NOT BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"' AND ZN_CLIENTE='"+aPatri[nX,03]+"'  AND ZN_PATRIMO='"+aPatri[nX,06]+"' ORDER BY ZN_DATA DESC) AS UF_BOTAO12"

	cQuery += "  FROM "+RetSQLName("SZN")+" ZN"
	cQuery += "  LEFT JOIN "+RetSQLName("SN1")+" N1 ON N1_CHAPA=ZN_PATRIMO AND N1.D_E_L_E_T_=''"
	cQuery += " WHERE ZN_DATA BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"'"
	
	//pegar os contadores informados no periodo de coleta
	//cQuery += " AND ZN_DATA BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"'"
	
	cQuery += " AND ZN_CLIENTE='"+aPatri[nX,03]+"'"
	
	cQuery += " AND ZN_PATRIMO='"+aPatri[nX,06]+"'"
	
	If aPatri[nX,05] != "1"
		cQuery += " AND ZN_LOJA='"+aPatri[nX,04]+"'"
	EndIf
	
	cQuery += " AND ZN.D_E_L_E_T_='' ORDER BY ZN_DATA DESC"  
	
	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf
	
	MemoWrite("FatCafe.SQL",cQuery)
	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
	
	DbSelectArea("TRB")
	//Buscando os valores dos produtos na tabela de preco de venda do cliente.
	While !EOF() 
		If Ascan(aRetorno,{|x| x[28] == TRB->ZN_PATRIMO}) == 0
		    Aadd(aRetorno,{TRB->N1_XP1,TRB->ZN_BOTAO01-TRB->UF_BOTAO01,TRB->N1_XP2,TRB->ZN_BOTAO02-TRB->UF_BOTAO02,;
		    				TRB->N1_XP3,TRB->ZN_BOTAO03-TRB->UF_BOTAO03,TRB->N1_XP4,TRB->ZN_BOTAO04-TRB->UF_BOTAO04,;
		    				TRB->N1_XP5,TRB->ZN_BOTAO05-TRB->UF_BOTAO05,TRB->N1_XP6,TRB->ZN_BOTAO06-TRB->UF_BOTAO06,;
		    				TRB->N1_XP7,TRB->ZN_BOTAO07-TRB->UF_BOTAO07,TRB->N1_XP8,TRB->ZN_BOTAO08-TRB->UF_BOTAO08,;
		    				TRB->N1_XP9,TRB->ZN_BOTAO09-TRB->UF_BOTAO09,TRB->N1_XP10,TRB->ZN_BOTAO10-TRB->UF_BOTAO10,;
		    				TRB->N1_XP11,TRB->ZN_BOTAO11-TRB->UF_BOTAO11,TRB->N1_XP12,TRB->ZN_BOTAO12-TRB->UF_BOTAO12,;
		    				TRB->ZN_CLIENTE,TRB->ZN_LOJA,aPatri[nX,01],ZN_PATRIMO})
		Else
			aRetorno[Ascan(aRetorno,{|x| x[28] == TRB->ZN_PATRIMO}),02]	-=	TRB->ZN_BOTAO01-TRB->UF_BOTAO01
			aRetorno[Ascan(aRetorno,{|x| x[28] == TRB->ZN_PATRIMO}),04]	-=	TRB->ZN_BOTAO02-TRB->UF_BOTAO02
			aRetorno[Ascan(aRetorno,{|x| x[28] == TRB->ZN_PATRIMO}),06]	-=	TRB->ZN_BOTAO03-TRB->UF_BOTAO03
			aRetorno[Ascan(aRetorno,{|x| x[28] == TRB->ZN_PATRIMO}),08]	-=	TRB->ZN_BOTAO04-TRB->UF_BOTAO04
			aRetorno[Ascan(aRetorno,{|x| x[28] == TRB->ZN_PATRIMO}),10]	-=	TRB->ZN_BOTAO05-TRB->UF_BOTAO05
			aRetorno[Ascan(aRetorno,{|x| x[28] == TRB->ZN_PATRIMO}),12]	-=	TRB->ZN_BOTAO06-TRB->UF_BOTAO06
			aRetorno[Ascan(aRetorno,{|x| x[28] == TRB->ZN_PATRIMO}),14]	-=	TRB->ZN_BOTAO07-TRB->UF_BOTAO07
			aRetorno[Ascan(aRetorno,{|x| x[28] == TRB->ZN_PATRIMO}),16]	-=	TRB->ZN_BOTAO08-TRB->UF_BOTAO08
			aRetorno[Ascan(aRetorno,{|x| x[28] == TRB->ZN_PATRIMO}),18]	-=	TRB->ZN_BOTAO09-TRB->UF_BOTAO09
			aRetorno[Ascan(aRetorno,{|x| x[28] == TRB->ZN_PATRIMO}),20]	-=	TRB->ZN_BOTAO10-TRB->UF_BOTAO10
			aRetorno[Ascan(aRetorno,{|x| x[28] == TRB->ZN_PATRIMO}),22]	-=	TRB->ZN_BOTAO11-TRB->UF_BOTAO11
			aRetorno[Ascan(aRetorno,{|x| x[28] == TRB->ZN_PATRIMO}),24]	-=	TRB->ZN_BOTAO12-TRB->UF_BOTAO12
		EndIf
		Dbskip()
	EndDo 
	
Next nX

//Amarrando o produto do Px de cada maquina com o devido codigo da dose para a contagem de insumos
For nX := 1 to len(aRetorno)
	For nY := 1 to 23 step 2
		If aRetorno[nX,nY+1] > 0 .And. !Empty(aRetorno[nX,nY])
			If Ascan(aInsCli,{|x| x[1]+x[2] = aRetorno[nX,25]+aRetorno[nX,nY]}) == 0
				Aadd(aInsCli,{aRetorno[nX,25],aRetorno[nX,nY],aRetorno[nX,nY+1],aRetorno[nX,27]})
			Else
				aInsCli[Ascan(aInsCli,{|x| x[1]+x[2] = aRetorno[nX,25]+aRetorno[nX,nY]}),03] += aRetorno[nX,nY+1]
			EndIf
		EndIf
		
	Next nY
Next nX

//Buscando as informacoes de doses para poder fazer a amarracao de quais produtos foram enviados para as PAs dos clientes.
For nX := 1 to len(aInsCli)
	cQuery := "SELECT G1_COD,B.B1_DESC AS DESCP,G1_COMP,C.B1_DESC AS DESCI,"
	cQuery += " CASE WHEN G1_QUANT < 1 THEN G1_QUANT ELSE G1_QUANT/1000 END AS G1_QUANT"
	cQuery += "  FROM "+RetSQLName("SG1")+" G1"
	cQuery += "  INNER JOIN "+RetSQLName("SB1")+" B ON B.B1_COD=G1_COD AND B.D_E_L_E_T_=''"
	cQuery += "  INNER JOIN "+RetSQLName("SB1")+" C ON C.B1_COD=G1_COMP AND C.D_E_L_E_T_=''"
	cQuery += " WHERE G1_COD='"+aInsCli[nX,02]+"' AND G1.D_E_L_E_T_=''"
	
	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf
	
	MemoWrite("FatCafe.SQL",cQuery)
	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
	
	DbSelectArea("TRB")
	//Buscando os valores dos produtos na tabela de preco de venda do cliente.
	While !EOF()                     
		If Ascan(aRet,{|x| x[1]+x[5] = aInsCli[nX,01]+TRB->G1_COMP}) == 0
		    Aadd(aRet,{aInsCli[nX,01],aInsCli[nX,02],TRB->DESCP,aInsCli[nX,03],TRB->G1_COMP,TRB->DESCI,TRB->G1_QUANT,TRB->G1_QUANT*aInsCli[nX,03],0,aInsCli[nX,04],0})
		Else
			aRet[Ascan(aRet,{|x| x[1]+x[5] = aInsCli[nX,01]+TRB->G1_COMP}),04] += aInsCli[nX,03]
			aRet[Ascan(aRet,{|x| x[1]+x[5] = aInsCli[nX,01]+TRB->G1_COMP}),08] += TRB->G1_QUANT*aInsCli[nX,03]
		EndIf
		Dbskip()
	EndDo 
Next nX

//SALDO DOS INSUMOS NO CLIENTE
For nX := 1 to len(aRet)

	cQuery := "SELECT B2_QATU-B2_RESERVA AS SALDO"
	cQuery += " FROM "+RetSQLName("SB2")
	cQuery += " WHERE B2_FILIAL='"+xFilial("SB2")+"' AND B2_COD ='"+aRet[nX,05]+"' AND D_E_L_E_T_=''"
	cQuery += " AND B2_LOCAL IN(SELECT ZZ1_COD FROM "+RetSQLName("ZZ1")+" WHERE ZZ1_ITCONT LIKE '"+aRet[nX,01]+"%' AND D_E_L_E_T_='' AND ZZ1_MSBLQL<>'1')"
	
	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf
	
	MemoWrite("FatCafe.SQL",cQuery)
	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
	
	DbSelectArea("TRB")
	cBarra := ""
	While !EOF()
		aRet[nX,11] += TRB->SALDO
		dbSkip()
	EndDo
Next nX

RestArea(aArea)

Return(aRet) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC20  บAutor  ณMicrosiga           บ Data ณ  09/16/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Consulta de Insumos enviados X Insumos consumidos pela    บฑฑ
ฑฑบ          ณinformacao dos Ps apontados pelos contadores.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CnsIns(cCliente)  

Local aArea := GetArea()
Local aAux	:=	{}
Local oDlg1,oGrp1,oSay1,oSay2,oSay3,oSay4,oGrp2,oBrw1,oBtn1,oBtn2,oBtn3,oSay5,oSay6,oSay7,oSay8
Local oDose


For nX := 1 to len(aCalDos)
	If aCalDos[nX,01] = substr(cCliente,1,6)
		Aadd(aAux,aCalDos[nX])
	EndIf
Next nX
	
If len(aAux) > 0
	oDlg1      := MSDialog():New( 091,232,575,924,"Consulta Insumos",,,.F.,,,,,,.T.,,,.T. )
	
	oGrp1      := TGroup():New( 004,004,060,336,"Contrato",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		oSay1      := TSay():New( 016,072,{||"Cliente"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oSay2      := TSay():New( 016,116,{||aAux[1,1]+" "+aList[oList:nAt,15]},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,188,008)
		oSay3      := TSay():New( 036,020,{||"Contrato"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oSay4      := TSay():New( 036,060,{||aAux[1,10]},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,168,008)
	
		oSay5      := TSay():New( 036,130,{||"Compet๊ncia"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oSay6      := TSay():New( 036,170,{||MV_PAR03},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,168,008)
	
		oSay7      := TSay():New( 036,210,{||"Perํodo"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oSay8      := TSay():New( 036,250,{||cvaltochar(aList[oList:nAt,19]) + " A "+cvaltochar(aList[oList:nAt,20])},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,168,008)
		
		
	oGrp2      := TGroup():New( 064,004,208,336,"Lan็amentos",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		//oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{072,008,200,328},,, oGrp2 ) 
		oDose := TCBrowse():New(076,012,310,125,, {'Produto','Descricใo','Pดs. informados','Calc Insumos','Qtd Env','Saldo'},;
													{30,100,40,40,40,40},;
	                            oGrp2,,,,{|| },{|| },, ,,,  ,,.F.,,.T.,,.F.,,.T.,.T.)
		oDose:SetArray(aAux)                    
		oDose:bLine := {||{ aAux[oDose:nAt,05],; 
		 					 aAux[oDose:nAt,06],;
		 					 aAux[oDose:nAt,04],;
		                     round(aAux[oDose:nAt,08],0),;
		                     aAux[oDose:nAt,09],;
		                     aAux[oDose:nAt,11]}} 
		                     
	//oBtn1      := TButton():New( 216,084,"oBtn1",oDlg1,,037,012,,,,.T.,,"",,,,.F. )
	//oBtn2      := TButton():New( 216,144,"oBtn2",oDlg1,,037,012,,,,.T.,,"",,,,.F. )
	oBtn3      := TButton():New( 216,204,"Sair",oDlg1,{||oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )
	
	oDlg1:Activate(,,,.T.)
Else
	MsgAlert("Nใo encontrado insumos enviados para este cliente no perํodo informado","TTPROC20")
EndIf

RestArea(aArea)

Return                                          

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC20  บAutor  ณMicrosiga           บ Data ณ  09/23/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Valores de Sangria e POS dos patrimonios.                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValPPat(nLinha)

Local oDlg1,oSay1,oSay2,oBrw1,oBtn1
Local oLista
Local aValor	:=	{}

For nX := 1 to len(aSangria)
	If aSangria[nX,01] == aList[nLinha,18]
		Aadd(aValor,{aSangria[nX,04],aSangria[nX,07],0,aSangria[nX,05],0,aSangria[nX,08],aSangria[nX,09],aSangria[nX,10],aSangria[nX,02],aSangria[nX,01]})
	EndIf
Next nX

For nX := 1 to len(aMoel)
	If Ascan(aValor,{|x| x[1] == aMoel[nX,04]}) > 0
		aValor[Ascan(aValor,{|x| x[1] == aMoel[nX,04]}),03] := aMoel[nX,05]
	Else
		Aadd(aValor,{aMoel[nX,04],0,aMoel[nX,05],0,0,aMoel[nX,08],aMoel[nX,09],aMoel[nX,10],aMoel[nX,02],aMoel[nX,01]})
	EndIf
Next nX


For nX := 1 to len(aValor) 
	cPerc1 := If(SUBSTR(aValor[nX,08],1,2) > substr(aValor[nX,08],4,2),CTOD(SUBSTR(aValor[nX,08],1,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03)-1)),3)),CTOD(SUBSTR(aValor[nX,08],1,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03))),3)))
	cPerc2 := If(SUBSTR(aValor[nX,08],1,2) > substr(aValor[nX,08],4,2),CTOD(SUBSTR(aValor[nX,08],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03))),3)),CTOD(SUBSTR(aValor[nX,08],4,2)+SUBSTR(CVALTOCHAR((CTOD('01/'+MV_PAR03))),3))) 
			
	cQuery := "SELECT ZN_PATRIMO" 

	For nY := 1 to 12
		cQuery += " ,(ZN_BOTAO"+cvaltochar(strzero(nY,2))+"- (SELECT TOP 1 ZN_BOTAO"+cvaltochar(strzero(nY,2))+" FROM "+RetSQLName("SZN")
		cQuery += " WHERE ZN_TIPINCL<>'SANGRIA' AND D_E_L_E_T_='' AND ZN_DATA < '"+dtos(aValor[nX,07])+"' AND ZN_DATA NOT BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"' AND ZN_PATRIMO='"+aValor[nX,01]+"' ORDER BY ZN_DATA DESC)) * D"+cvaltochar(nY)+".DA1_XPRCPP AS UF_BOTAO"+cvaltochar(strzero(nY,2))
	Next nY
	
	cQuery += " FROM "+RetSQLName("SZN")+" ZN"
	cQuery += " LEFT JOIN "+RetSQLName("DA0")+" DA0 ON DA0_XCLIEN=ZN_CLIENTE AND DA0.D_E_L_E_T_='' AND DA0_ATIVO='1'"
	cQuery += " LEFT JOIN "+RetSQLName("SN1")+" N1 ON N1_CHAPA=ZN_PATRIMO AND N1.D_E_L_E_T_=''"
		
	For nY := 1 to 12
		cQuery += " LEFT JOIN "+RetSQLName("DA1")+" D"+cvaltochar(nY)+" ON D"+cvaltochar(nY)+".DA1_CODTAB=DA0_CODTAB AND D"+cvaltochar(nY)+".DA1_CODPRO=N1_XP"+cvaltochar(nY)+" AND D"+cvaltochar(nY)+".D_E_L_E_T_=''
	Next nY
	
	cQuery += " WHERE ZN_TIPINCL<>'SANGRIA' AND ZN.D_E_L_E_T_='' AND ZN_DATA BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"'"
	cQuery += " AND ZN_CLIENTE='"+aValor[nX,09]+"' AND ZN_PATRIMO='"+aValor[nX,01]+"'"
 
 	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf
	
	MemoWrite("FatCafe.SQL",cQuery)
	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
	
	DbSelectArea("TRB")
	aValor[nX,05] := TRB->UF_BOTAO01 + TRB->UF_BOTAO02 + TRB->UF_BOTAO03 + TRB->UF_BOTAO04 + TRB->UF_BOTAO05 + TRB->UF_BOTAO06 + TRB->UF_BOTAO07 + TRB->UF_BOTAO08 + TRB->UF_BOTAO09 + TRB->UF_BOTAO10 + TRB->UF_BOTAO11 + TRB->UF_BOTAO12
Next nX


If len(aValor) > 0
/*	oDlg1      := MSDialog():New( 091,232,384,740,"Valores recebidos pelo Patrim๔nio",,,.F.,,,,,,.T.,,,.T. )
	oSay1      := TSay():New( 012,048,{||"Contrato"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay2      := TSay():New( 012,100,{||aList[nLinha,18]},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,088,008)
		oLista := TCBrowse():New(028,008,240,075,, {'Patrimonio','Cedulas e Moedas','Moeda Eletronica','Contador Cash','Pดs X Preco Publico'},;
													{50,40,40,40,40},;
	                            oDlg1,,,,{|| },{|| },, ,,,  ,,.F.,,.T.,,.F.,,.T.,.T.)
		oLista:SetArray(aValor)                    
		oLista:bLine := {||{ aValor[oLista:nAt,01],; 
		 					 Transform(aValor[oLista:nAt,02],"@E 999,999,999.99"),; 
		 					 Transform(aValor[oLista:nAt,03],"@E 999,999,999.99"),;
		 					 aValor[oLista:nAt,04],;
		 					 aValor[oLista:nAt,05]}} 
	
	oBtn1      := TButton():New( 120,100,"Sair",oDlg1,{||oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )
	
	oDlg1:Activate(,,,.T.)  */
	U_TTPROC21(aValor,aList[nLinha,15],aList[nLinha,18],aList[nLinha,16],4)
Else
	MsgAlert("Nใo foram encontrados registros de Sangria para este cliente no perํodo informado","TTPROC20")
EndIf

Return                                                                          

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC20  บAutor  ณMicrosiga           บ Data ณ  11/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Valida se o contador anterior e menor que o contador atualบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AuditCant(cPatri,cPer1,cPer2,cPerc1,cPerc2,contrato)
                           
Local aArea	:=	GetArea()                           
Local cQuery 

cQuery := "SELECT ZN_PATRIMO,ZN_DATA,ZN_BOTTEST,ZN_BOTAO01,ZN_BOTAO02,ZN_BOTAO03,ZN_BOTAO04,ZN_BOTAO05,ZN_BOTAO06,ZN_BOTAO07,ZN_BOTAO08,ZN_BOTAO09,"+chr(13)+chr(10)
cQuery += " ZN_BOTAO10,ZN_BOTAO11,ZN_BOTAO12,"+chr(13)+chr(10)

cQuery += " (SELECT TOP 1 ZN_DATA FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND ZN_PATRIMO='"+cPatri+"' AND ZN_DATA < '"+dtos(cPer2)+"' AND ZN_DATA NOT BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"' AND D_E_L_E_T_='' ORDER BY ZN_DATA DESC) AS P1_DATANT,"+chr(13)+chr(10)

For naa := 1 to 12
	cQuery += " (SELECT TOP 1 ZN_BOTAO"+Strzero(naa,2)+" FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND ZN_PATRIMO='"+cPatri+"' AND ZN_DATA < '"+dtos(cPer2)+"' AND ZN_DATA NOT BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"' AND D_E_L_E_T_='' ORDER BY ZN_DATA DESC) AS P"+cvaltochar(naa)+"_ANT,"+chr(13)+chr(10)
Next naa             

cQuery += " (SELECT TOP 1 ZN_BOTTEST FROM "+RetSQLName("SZN")+" WHERE ZN_TIPINCL<>'SANGRIA' AND ZN_PATRIMO='"+cPatri+"' AND ZN_DATA < '"+dtos(cPer2)+"' AND ZN_DATA NOT BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"' AND D_E_L_E_T_='' ORDER BY ZN_DATA DESC) AS PT_ANT"+chr(13)+chr(10)

cQuery += "  FROM "+RetSQLName("SZN")+" ZN"+chr(13)+chr(10)
cQuery += "  LEFT JOIN "+RetSQLName("SN1")+" N1 ON N1_CHAPA=ZN_PATRIMO AND N1.D_E_L_E_T_=''"+chr(13)+chr(10)
cQuery += " WHERE ZN_TIPINCL<>'SANGRIA' AND ZN_PATRIMO='"+cPatri+"' AND (ZN_DATA BETWEEN '"+dtos(cPerc1)+"' AND '"+dtos(cPerc2)+"' OR ZN_CONFERE='1')"+chr(13)+chr(10)
cQuery += " AND ZN.D_E_L_E_T_=''"+chr(13)+chr(10)

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("FatCafe.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
	//formato - 1 col = Numero da auditoria, 2 col = Numero do patrimonio, 3 col = valor mes, 4 col = valor anterior,5 col = Status, 6 col = Contrato
	Aadd(aAudit1c,{5,cPatri,TRB->ZN_BOTTEST,TRB->PT_ANT,If(TRB->ZN_BOTTEST>=TRB->PT_ANT,'Ok','Divergente'),contrato,'BOTAO_Teste'})
	For naa := 1 to 12
		Aadd(aAudit1c,{5,cPatri,&('TRB->ZN_BOTAO'+strzero(naa,2)),&('TRB->P'+cvaltochar(naa)+'_ANT'),If(&('TRB->ZN_BOTAO'+strzero(naa,2)) >= &('TRB->P'+cvaltochar(naa)+'_ANT'),'Ok','Divergente'),contrato,'BOTAO'+strzero(naa,2)})
	Next naa
	
	DbSkip()
EndDo

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC20  บAutor  ณMicrosiga           บ Data ณ  11/18/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ObsFat(nLinha)

Local aArea	:=	GetArea()   
Local cMsg  := 	''
                  
DbSelectArea("CN9")
DbSetOrder(1)
DbSeek(xFilial("CN9")+aList[nLinha,18])

	cMsg := AllTrim( CN9->CN9_XCHECK)     

MsgAlert(cMsg)
	

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC20  บAutor  ณMicrosiga           บ Data ณ  02/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Estornar o pedido gerado pela auditoria.                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function estornar(nLinha)

Local aArea	:=	GetArea()
Local cQuery

cQuery := "SELECT R_E_C_N_O_ AS REC FROM "+RetSQLName("SZN")
cQuery += " WHERE ZN_CLIENTE IN(SELECT CN9_CLIENT FROM "+RetSQLName("CN9")+" WHERE CN9_NUMERO LIKE '%"+aList[nLinha,18]+"%')"
cQuery += " AND ZN_PEDIDOS LIKE '"+Alltrim(aList[nLinha,14])+"' AND D_E_L_E_T_=''"
 
If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("FatCafe.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    DbSelectArea("SZN")
    DbGoto(TRB->REC)
    Reclock("SZN",.F.)
    SZN->ZN_CONFERE	:=	'1'
    SZN->ZN_PEDIDOS	:=	''  
    SZN->(Msunlock())
    DbSelectArea("TRB")
	DbSkip()
EndDo

aList[nLinha,14] := ''
aList[nLinha,13] := 0

oList:refresh()
oDlg1:refresh()

Fhelp(nlinha)

RestArea(aArea)

Return                    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC20  บAutor  ณMicrosiga           บ Data ณ  06/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exibir o pre-pedido que sera faturado.                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PrePedido(ccliente)
                                                     
Local aArea	:=	Getarea()
Local cAuxP	:=	''  
Local aAuxP	:=	{}
Local oDlgP1,oGrpP1,oBrw1,oGrp2,oBrw2,oGrp3,oBrw3,oGrp4,oSay1,oSay2,oSay3,oSay4,oSay5,oBtn1,oBtn2,oBtn3,oBtn4
Local cS1,cS2,cS3,cS4,cS5	:=	'' 
Local cDt1		:= 	ctod(' / / ')
Local cDt2		:=	ctod(' / / ')
Local cFatPor	:=	'0'
Private aBrw1	:=	{}  
Private aBrw2	:=	{}
Private aBrw3	:=	{}
Private aTabela	:=	{}
Private nDifDose := 0

DbSelectArea("CN9")
DbSetOrder(1)
If DbSeek(xFilial("CN9")+aList2[1,1])
	If CN9->CN9_XMINPO == "1"
		cS1 := "O Minimo Cobrado por este contrato ้ por Quantidade. \"
   	ElseIf CN9->CN9_XMINPO == "2"
   		cS1 := "Minimo Cobrado por este contrato ้ por Valor. \"
   	Else
   		cS1 := "Nใo se aplica minimo a este contrato. \"
   	EndIf        
   	
   	If CN9->CN9_XVOLMI > 0
	   	cS2 := "Quantidade Minima contrato "+cvaltochar(CN9->CN9_XVOLMI)+" doses. \"
	Else
		cS2 := ""
	EndIf


   	If CN9->CN9_XFORFA == "1"
   		cS3 := "O Volume minimo deste contrato ้ calculado por Cliente. \"
   	ElseIf CN9->CN9_XFORFA == "2"
   		cS3 := "O Volume minimo deste contrato ้ calculado por Equipamento. \"
   	Else
   		cS3 := "O Volume minimo deste contrato ้ calculado por Unidade. \"
   	EndIf
   	
   	If CN9->CN9_XTPFAT == "1"
   		cFatPor := '1'
   		cS4	:= "Os pedidos deste contrato devem ser gerados todos para o Cliente"+chr(13)+chr(10)+" e loja contido no contrato. \"
   	Else              
   		cFatPor := '2'
 		cS4 := "Os pedidos deste contrato deve ser gerados um para cada loja do cliente. \"
 	EndIf
   	
   	If CN9->CN9_XTPCNT == "1"
   		cS5 := "Forma de faturamento do contrato = Individual. \"
   	ElseIf CN9->CN9_XTPCNT == "2"
   		cS5 := "Forma de faturamento do contrato = Agrupado. \"   	
  	Else
  		cS5 := "Forma de faturamento do contrato = Selecionado. \"
   	EndIf
EndIf

//Asort(aList2,,,{|x,y| x[2]+x[3] < y[2]+y[3]})
cAuxP := aList2[1,2]
Aadd(aAuxP,aList2[1])         


For nX := 2 to len(aList2)
	If Alltrim(aList2[nX,02]) != Alltrim(cAuxP) .Or. aList2[nX,32] == "FAtu"
		If Ascan(aAuxP,{|x| x[2]+x[3] == aList2[nX-1,02]+aList2[nX-1,03]}) == 0 ;
			.And. Ascan(aAuxP,{|x| Alltrim(x[2])+Alltrim(x[32]) == Alltrim(aList2[nX-1,02])+"FAnt"}) != 0 ;
			.And. Ascan(aAuxP,{|x| Alltrim(x[2])+Alltrim(x[32]) == Alltrim(aList2[nX-1,02])+"FAtu"}) == 0 .And. aList2[nX,32] != "FAtu"
				Aadd(aAuxP,aList2[nX-1])
		EndIf
		Aadd(aAuxP,aList2[nX])
		cAuxP := aList2[nX,02]
	Else
		If nX == len(aList2) ;
			.And. Ascan(aAuxP,{|x| Alltrim(x[2])+Alltrim(x[32]) == Alltrim(aList2[nX,02])+"FAnt"}) != 0 ;
			.And. Ascan(aAuxP,{|x| Alltrim(x[2])+Alltrim(x[32]) == Alltrim(aList2[nX,02])+"FAtu"}) == 0
			Aadd(aAuxP,aList2[nX])
		EndIf
	EndIf
Next nX


If len(aAuxP) > 0   
   	
	Monta1(aAuxP,ccliente)
    Aadd(aBrw3,{'','','','',''})       

    //Informacao sobre datas
    For nPP := 1 to len(aAuxP)     
    	If Empty(cDt1) .Or. cDt1 > ctod(aAuxP[nPP,03])
	    	cDt1 := ctod(aAuxP[nPP,03])
	    EndIf
	    If Empty(cDt2) .Or. cDt2 < ctod(aAuxP[nPP,03])
	    	cDt2 := ctod(aAuxP[nPP,03])
	    EndIf
	    
    Next nPP
    
    cS1 += chr(13)+chr(10)+"Perํodo de faturamento "+cvaltochar(cDt1)+" เ "+cvaltochar(cDt2)+" \"   
	nDias := cDt2 - cDt1
	cS1 += chr(13)+chr(10)+"Dias de faturamento "+cvaltochar(If(nDias==0,1,nDias))+" \"
   	
   	//Pro-rata
   	If CN9->CN9_XPRORA == "2"
   		cS1 += chr(13)+chr(10)+"Para este contrato nแo hแ cobran็a de pr๓-rata. \"  
	    //Informa็ใo sobre doses complementares.
		If CN9->CN9_XVOLMI > aBrw1[len(aBrw1),03]
			nDifDose := CN9->CN9_XVOLMI - aBrw1[len(aBrw1),03]
			cS2 += chr(13)+chr(10)+"Serใo cobradas "+cvaltochar(CN9->CN9_XVOLMI - aBrw1[len(aBrw1),03])+" doses complementares \"
			//Inclusao do item de Dose Complementar.
			If CN9->CN9_XFORFA == "1"
				If !Empty(CN9->CN9_XPRMIN)	
					If Ascan(aTabela,{|x| Alltrim(x[1]) == Alltrim(CN9->CN9_XPRMIN)}) > 0
						nPreco :=	aTabela[Ascan(aTabela,{|x| Alltrim(x[1]) == Alltrim(CN9->CN9_XPRMIN)}),02]
						aBrw1[len(aBrw1),02] := 'Sub-Total'
						//Guardando a posicao do sub-total
						nPos1 := len(aBrw1)    
						nQtd := CN9->CN9_XVOLMI - aBrw1[len(aBrw1),03]          
						//Incluindo o item de dose complementar
						Aadd(aBrw1,{CN9->CN9_XPRMIN,Posicione("SB1",1,xFilial("SB1")+CN9->CN9_XPRMIN,"B1_DESC"),;
									nQtd,nPreco,nQtd*nPreco})
						Aadd(aBrw1,{'','Total',aBrw1[nPos1,03]+nQtd,,aBrw1[nPos1,5]+aBrw1[len(aBrw1),05]})
					Else
						cS2 += chr(13)+chr(10)+"O Produto para dose compl. nใo foi encontrado na tabela de pre็o do cliente ("+aTabela[1,4]+") \"
					EndIf
				Else
					cS2 += chr(13)+chr(10)+"Nใo foi encontrado o produto de dose complementar no contrato. \"
				EndIf
			EndIf
		EndIf
   	Else
     	nDosed:= CN9->CN9_XVOLMI/30
     	If nDias*nDosed > aBrw1[len(aBrw1),03]
     		If ROUND(nDias*nDosed,0) <> CN9->CN9_XVOLMI 
     			cS2 += chr(13)+chr(10)+"Pr๓-rata a ser cobrada para o perํodo "+cvaltochar(ROUND(nDias*nDosed,0))+" doses \"
     		EndIf                   
     		
     		nDifDose := round((nDias*nDosed)-aBrw1[len(aBrw1),03],0)
     			
       		cS2 += chr(13)+chr(10)+"Serใo cobradas	"+cvaltochar(round((nDias*nDosed)-aBrw1[len(aBrw1),03],0))+" doses complementares \" 
       		
	     	If Ascan(aTabela,{|x| Alltrim(x[1]) == Alltrim(CN9->CN9_XPRMIN)}) > 0
				nPreco :=	aTabela[Ascan(aTabela,{|x| Alltrim(x[1]) == Alltrim(CN9->CN9_XPRMIN)}),02]
				aBrw1[len(aBrw1),02] := 'Sub-Total'
				//Guardando a posicao do sub-total
				nPos1 := len(aBrw1)    
				nQtd := Round((nDias*nDosed) - aBrw1[len(aBrw1),03],0)
				//Incluindo o item de dose complementar
				Aadd(aBrw1,{CN9->CN9_XPRMIN,Posicione("SB1",1,xFilial("SB1")+CN9->CN9_XPRMIN,"B1_DESC"),;
							nQtd,nPreco,nQtd*nPreco})
				Aadd(aBrw1,{'','Total',aBrw1[nPos1,03]+nQtd,,aBrw1[nPos1,5]+aBrw1[len(aBrw1),05]})
	     	EndIf
      	EndIf
   	EndIf  	
    
	
	cS1 += chr(13)+chr(10)+cS2+chr(13)+chr(10)+cS3+chr(13)+chr(10)+cS4+chr(13)+chr(10)+cS5
	
    oDlgP1      := MSDialog():New( 091,232,636,988,"Pr้-Faturamento",,,.F.,,CLR_BLACK,CLR_WHITE,,,.T.,,,.T. )
	
	oGrpP1      := TGroup():New( 004,004,120,194,"Faturamento Geral",oDlgP1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		//oBrw1      := MsNewGetDados():New(012,008,108,180,nOpc,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',oGrpP1,aHoBrw1,aCoBrw1 )
		oBrw1 := TCBrowse():New(012,008,180,105,, {'Produto','Descri็ใo','Qtd','Vlr Unit.','Vlr Total'},;
								{20,25,20,20,30},;
	                            oGrpP1,,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt,0)*/},, ,,,  ,,.F.,,.T.,,.F.,,.T.,.T.)
		oBrw1:SetArray(aBrw1)
		oBrw1:bLine := {||{ aBrw1[oBrw1:nAt,01],; 
		 					 aBrw1[oBrw1:nAt,02],;
		                     aBrw1[oBrw1:nAt,03],;
		                     If(!Empty(aBrw1[oBrw1:nAt,04]),Transform(aBrw1[oBrw1:nAt,04],"@E 99,999.99"),aBrw1[oBrw1:nAt,04]),;
		                     If(!Empty(aBrw1[oBrw1:nAt,05]),Transform(aBrw1[oBrw1:nAt,05],"@E 99,999.99"),aBrw1[oBrw1:nAt,05])}} 
	
	oGrpP2      := TGroup():New( 004,198,120,378,"Faturamento por Patrim๔nio",oDlgP1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		//oBrw2      := MsNewGetDados():New(012,192,108,364,nOpc,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',oGrpP2,aHoBrw2,aCoBrw2 )
		oBrw2 := TCBrowse():New(012,202,170,105,, {'Produto','Descri็ใo','Qtd','Vlr Unit.','Vlr Total'},;
								{20,25,20,20,30},;
	                            oGrpP2,,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt,0)*/},, ,,,  ,,.F.,,.T.,,.F.,,.T.,.T.)
		oBrw2:SetArray(aBrw2)
		oBrw2:bLine := {||{ aBrw2[oBrw2:nAt,01],; 
		 					 aBrw2[oBrw2:nAt,02],;
		                     aBrw2[oBrw2:nAt,03],;
		                     If(!Empty(aBrw2[oBrw2:nAt,04]),Transform(aBrw2[oBrw2:nAt,04],"@E 99,999.99"),aBrw2[oBrw2:nAt,04]),;
		                     If(!Empty(aBrw2[oBrw2:nAt,05]),Transform(aBrw2[oBrw2:nAt,05],"@E 99,999.99"),aBrw2[oBrw2:nAt,05])}} 
	
	oGrpP3      := TGroup():New( 124,004,240,194,"Faturamento por Loja Cliente",oDlgP1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		//oBrw3      := MsNewGetDados():New(132,008,228,180,nOpc,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',oGrpP3,aHoBrw3,aCoBrw3 )
		oBrw3 := TCBrowse():New(132,008,180,105,, {'Produto','Descri็ใo','Qtd','Vlr Unit.','Vlr Total'},;
								{20,50,20,20,30},;
	                            oGrpP3,,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt,0)*/},, ,,,  ,,.F.,,.T.,,.F.,,.T.,.T.)
		oBrw3:SetArray(aBrw3)
		oBrw3:bLine := {||{ aBrw3[oBrw3:nAt,01],; 
		 					 aBrw3[oBrw3:nAt,02],;
		                     aBrw3[oBrw3:nAt,03],;
		                     If(!Empty(aBrw3[oBrw3:nAt,04]),Transform(aBrw3[oBrw3:nAt,04],"@E 99,999.99"),aBrw3[oBrw3:nAt,04]),;
		                     If(!Empty(aBrw3[oBrw3:nAt,05]),Transform(aBrw3[oBrw3:nAt,05],"@E 99,999.99"),aBrw3[oBrw3:nAt,05])}} 
	
	oGrpP4      := TGroup():New( 124,198,240,378,"Informa็๕es Contrato",oDlgP1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		
		oSay1      := TSay():New( 134,202,{||cS1},oGrpP4,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,172,628)
		//oSay2      := TSay():New( 154,202,{||cS2},oGrpP4,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,172,028)
		//oSay3      := TSay():New( 174,202,{||cS3},oGrpP4,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,172,028)
		//oSay4      := TSay():New( 194,202,{||cS4},oGrpP4,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,172,028)
		//oSay5      := TSay():New( 214,202,{||cS5},oGrpP4,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,172,028)
//		oSay2      := TSay():New( 220,202,{||"oSay2"},oGrpP4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,172,008)
	
	oBtn1      := TButton():New( 248,052,"Demonstrativo",oDlgP1,{||DemonstCF(ccliente,cS1)},037,012,,,,.T.,,"",,,,.F. )
	oBtn2      := TButton():New( 248,136,"oBtn2",oDlgP1,,037,012,,,,.T.,,"",,,,.F. )
	oBtn3      := TButton():New( 248,216,"Gerar Ped.",oDlgP1,{|| Processa({|| MontaPed(cFatPor,aAuxP)},"Aguarde")},037,012,,,,.T.,,"",,,,.F. )
	oBtn4      := TButton():New( 248,288,"Sair",oDlgP1,{||oDlgP1:end()},037,012,,,,.T.,,"",,,,.F. )
	
	If !Empty(aList3[oList3:nAt,01])
		oBtn3:disable()
	EndIf
	
	oDlgP1:Activate(,,,.T.)
EndIf

RestArea(aArea)

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC20  บAutor  ณMicrosiga           บ Data ณ  06/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta os arrays sobre cada tipo de faturamento             บฑฑ
ฑฑบ          ณgeral, por patrimonio ou por loja do cliente.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Monta1(aArray,ccliente)

Local aAuxiliar	:=	{} 
Local aProdutos	:=	{}
Local cPatrim	:=	'' 
Local nPrcUn	:=	0 
Local cDesc		:= ""
aBrw1 := {}
aBrw2 := {}
aBrw3 := {}
aTabela	:=	Precos(ccliente)

//Asort(aArray,,,{|x,y| x[2]+cvaltochar(x[3]) < y[2]+cvaltochar(y[3])})

For nX := 1 to len(aArray)
	If Ascan(aAuxiliar,{|x| x[2] == aArray[nX,02]}) == 0
		Aadd(aAuxiliar,{aArray[nX,01],aArray[nX,02],aArray[nX,03],aArray[nX,04],aArray[nX,05],aArray[nX,06],;
						aArray[nX,07],aArray[nX,08],aArray[nX,09],aArray[nX,10],aArray[nX,11],aArray[nX,12],;
						aArray[nX,13],aArray[nX,14],aArray[nX,15],aArray[nX,16],aArray[nX,17],aArray[nX,18],;
						aArray[nX,19],aArray[nX,20],aArray[nX,21],aArray[nX,22],aArray[nX,23],aArray[nX,24],;
						aArray[nX,25],aArray[nX,26],aArray[nX,27],aArray[nX,28],aArray[nX,29],aArray[nX,30],;
						aArray[nX,31],aArray[nX,32],aArray[nX,33],aArray[nX,34]})
	Else                  
		nPos := Ascan(aAuxiliar,{|x| x[2] == aArray[nX,02]}) 
		aAuxiliar[nPos,07] := aArray[nX,07] - aAuxiliar[nPos,07]
		aAuxiliar[nPos,08] := aArray[nX,08] - aAuxiliar[nPos,08]
		aAuxiliar[nPos,09] := aArray[nX,09] - aAuxiliar[nPos,09]
		aAuxiliar[nPos,10] := aArray[nX,10] - aAuxiliar[nPos,10]
		aAuxiliar[nPos,11] := aArray[nX,11] - aAuxiliar[nPos,11]
		aAuxiliar[nPos,12] := aArray[nX,12] - aAuxiliar[nPos,12]
		aAuxiliar[nPos,13] := aArray[nX,13] - aAuxiliar[nPos,13]
		aAuxiliar[nPos,14] := aArray[nX,14] - aAuxiliar[nPos,14]
		aAuxiliar[nPos,15] := aArray[nX,15] - aAuxiliar[nPos,15]
		aAuxiliar[nPos,16] := aArray[nX,16] - aAuxiliar[nPos,16]
		aAuxiliar[nPos,17] := aArray[nX,17] - aAuxiliar[nPos,17]
		aAuxiliar[nPos,18] := aArray[nX,18] - aAuxiliar[nPos,18]
	EndIf	
Next nX
//Geral
For nX := 1 to len(aAuxiliar)
	For nJ := 7 to 18	// CONSIDERANDO SOMENTE 1 - 12
		If aAuxiliar[nX,nJ] > 0
            //Preco unitario do produto na tabela do cliente
			If Ascan(aTabela,{|x| Alltrim(x[1]) == Alltrim(aAuxiliar[nX,nJ+12])}) > 0
		   		nPrcUn := aTabela[Ascan(aTabela,{|x| Alltrim(x[1]) == Alltrim(aAuxiliar[nX,nJ+12])}),02]
		 	Else
		 		nPrcUn := 0
		 	EndIf
		 	If !Empty(aAuxiliar[nX,nJ+12])
				If Ascan(aProdutos,{|x| Alltrim(x[1]) == Alltrim(aAuxiliar[nX,nJ+12])}) == 0
					Aadd(aProdutos,{Alltrim(aAuxiliar[nX,nJ+12]),Alltrim(Posicione("SB1",1,xFilial("SB1")+aAuxiliar[nX,nJ+12],"B1_DESC")),aAuxiliar[nX,nJ],nPrcUn,aAuxiliar[nX,nJ]*nPrcUn})                                         	
				Else
				    aProdutos[Ascan(aProdutos,{|x| Alltrim(x[1]) == Alltrim(aAuxiliar[nX,nJ+12])}),3] += aAuxiliar[nX,nJ]
				    aProdutos[Ascan(aProdutos,{|x| Alltrim(x[1]) == Alltrim(aAuxiliar[nX,nJ+12])}),5] += aAuxiliar[nX,nJ] * nPrcUn
				EndIf
			EndIf
		Endif
	Next nJ
Next nX

// dose complementar
/*
If nDifDose > 0
	For nI := 1 To Len(aTabela)
		nPrcUn := aTabela[nI][2]	
		cDesc := Posicione( "SB1",1,xFilial("SB1")+AvKey(aTabela[nI][1],"B1_COD"),"B1_DESC" )
		If "COMPL" $ cDesc
			AADD( aProdutos,{ aTabela[nI][1],cDesc,nDifDose,nPrcUn,nDifDose*nPrcUn})                                         	 )
		EndIf
	Next nI
EndIf
*/

For nX := 1 to len(aProdutos)
	Aadd(aBrw1,aProdutos[nx])
Next nX

    

nTotPr := 0
nTotQt := 0
AEval(aBrw1, {|aBrw1| nTotPr += aBrw1[05] , nTotQt += aBrw1[03]}) 
Aadd(aBrw1,{'','Total',nTotQt,,nTotPr})  

aProdutos := {}
//Por Patrimonio
For nX := 1 to len(aAuxiliar)                                  
	//Total Parcial
	If Len(aProdutos) > 0
		Aadd(aProdutos,{'','Sub-Total ',nTotQt,'',nTotPr,''})
	EndIf
	
	nTotPr := 0  
	nTotQt := 0

	Aadd(aProdutos,{'','Patrimonio '+aAuxiliar[nX,02]+' PA '+POSICIONE("ZZ1",3,XFILIAL("ZZ1")+CCLIENTE+AAUXILIAR[NX,31],"ZZ1_COD"),'','','',''})
	
	For nJ := 7 to 18
		If aAuxiliar[nX,nJ] > 0
            //Preco unitario do produto na tabela do cliente
			If Ascan(aTabela,{|x| Alltrim(x[1]) == Alltrim(aAuxiliar[nX,nJ+12])}) > 0
		   		nPrcUn := aTabela[Ascan(aTabela,{|x| Alltrim(x[1]) == Alltrim(aAuxiliar[nX,nJ+12])}),02]
		 	Else
		 		nPrcUn := 0
		 	EndIf
		 	If !Empty(aAuxiliar[nX,nJ+12])
				If Ascan(aProdutos,{|x| Alltrim(x[1])+Alltrim(x[6]) == Alltrim(aAuxiliar[nX,nJ+12])+Alltrim(aAuxiliar[nX,02])}) == 0
					Aadd(aProdutos,{Alltrim(aAuxiliar[nX,nJ+12]),Alltrim(Posicione("SB1",1,xFilial("SB1")+aAuxiliar[nX,nJ+12],"B1_DESC")),aAuxiliar[nX,nJ],nPrcUn,aAuxiliar[nX,nJ]*nPrcUn,aAuxiliar[nX,02]})                                         	
				Else
				    aProdutos[Ascan(aProdutos,{|x| Alltrim(x[1])+Alltrim(x[6]) == Alltrim(aAuxiliar[nX,nJ+12])+Alltrim(aAuxiliar[nX,02])}),3] += aAuxiliar[nX,nJ]
				    aProdutos[Ascan(aProdutos,{|x| Alltrim(x[1])+Alltrim(x[6]) == Alltrim(aAuxiliar[nX,nJ+12])+Alltrim(aAuxiliar[nX,02])}),5] += aAuxiliar[nX,nJ] * nPrcUn
				EndIf
				nTotPr += aProdutos[len(aProdutos),05]
				nTotQt += aProdutos[len(aProdutos),03]
			EndIf
		Endif
	Next nJ
Next nX

For nX := 1 to len(aProdutos)
	Aadd(aBrw2,aProdutos[nX])
Next nX
//Total parcial ultimo patrimonio
If nTotPr > 0
	Aadd(aBrw2,{'','Sub-Total ',nTotQt,'',nTotPr,''})
EndIf	

nTotPr := 0  
nTotQt := 0
AEval(aBrw2, {|aBrw2| If(!Empty(aBrw2[01]),nTotPr += aBrw2[05],) }) 
AEval(aBrw2, {|aBrw2| If(!Empty(aBrw2[01]),nTotQt += aBrw2[03],) }) 
Aadd(aBrw2,{'','Total Geral',nTotQt,,nTotPr})  

//Por Loja do cliente.
aProdutos := {}
Aadd(aProdutos,{'','Loja '+aAuxiliar[01,31],'','','',''})  
nTotPr := 0 
nTotQt := 0

For nX := 1 to len(aAuxiliar)                                  
	//Total Parcial
	If len(aProdutos) > 0 .And. Ascan(aProdutos,{|x| x[2] = "Loja "+aAuxiliar[nX,31]}) == 0
		Aadd(aProdutos,{'','Sub-Total ',nTotQt,'',nTotPr,''})
		Aadd(aProdutos,{'','Loja '+aAuxiliar[nX,31],'','','',''})
		nTotPr := 0
		nTotQt := 0
	EndIf
	
	For nJ := 7 to 18
		If aAuxiliar[nX,nJ] > 0
            //Preco unitario do produto na tabela do cliente
			If Ascan(aTabela,{|x| Alltrim(x[1]) == Alltrim(aAuxiliar[nX,nJ+12])}) > 0
		   		nPrcUn := aTabela[Ascan(aTabela,{|x| Alltrim(x[1]) == Alltrim(aAuxiliar[nX,nJ+12])}),02]
		 	Else
		 		nPrcUn := 0
		 	EndIf 
		 	//  
		 	If !Empty(aAuxiliar[nX,nJ+12])
				If Ascan(aProdutos,{|x| Alltrim(x[1])+Alltrim(x[6]) == Alltrim(aAuxiliar[nX,nJ+12])+Alltrim(aAuxiliar[nX,31])}) == 0
					Aadd(aProdutos,{Alltrim(aAuxiliar[nX,nJ+12]),Alltrim(Posicione("SB1",1,xFilial("SB1")+aAuxiliar[nX,nJ+12],"B1_DESC")),aAuxiliar[nX,nJ],nPrcUn,aAuxiliar[nX,nJ]*nPrcUn,aAuxiliar[nX,31]})                                         	
					nTotPr += aAuxiliar[nX,nJ]*nPrcUn 
					nTotQt += aAuxiliar[nX,nJ]
				Else
				    aProdutos[Ascan(aProdutos,{|x| Alltrim(x[1])+Alltrim(x[6]) == Alltrim(aAuxiliar[nX,nJ+12])+Alltrim(aAuxiliar[nX,31])}),3] += aAuxiliar[nX,nJ]
				    aProdutos[Ascan(aProdutos,{|x| Alltrim(x[1])+Alltrim(x[6]) == Alltrim(aAuxiliar[nX,nJ+12])+Alltrim(aAuxiliar[nX,31])}),5] += aAuxiliar[nX,nJ] * nPrcUn
				    nTotPr += aAuxiliar[nX,nJ]*nPrcUn
				    nTotQt += aAuxiliar[nX,nJ]
				EndIf
			EndIf
				
		Endif
	Next nJ
Next nX

For nX := 1 to len(aProdutos)
	Aadd(aBrw3,aProdutos[nX])
Next nX
//Total parcial ultimo patrimonio
If nTotPr > 0
	Aadd(aBrw3,{'','Sub-Total ',nTotQt,'',nTotPr,''})
EndIf	

nTotPr := 0
nTotQt := 0
AEval(aBrw3, {|aBrw3| If(!Empty(aBrw3[01]),nTotPr += aBrw3[05],) }) 
AEval(aBrw3, {|aBrw3| If(!Empty(aBrw3[01]),nTotQt += aBrw3[03],) }) 
Aadd(aBrw3,{'','Total Geral',nTotQt,,nTotPr})  

Return	   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC20  บAutor  ณMicrosiga           บ Data ณ  06/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Tabela de precos do cliente                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Precos(ccliente)

Local aAux	:=	{}
Local cQuery

cQuery := "SELECT DA0_CODTAB,DA1_CODPRO,DA1_PRCVEN,DA1_XPRCPP"
cQuery += " FROM "+RetSQLName("DA0")+" D0"
cQuery += " INNER JOIN "+RetSQLName("DA1")+" D1 ON DA1_CODTAB=DA0_CODTAB AND D1.D_E_L_E_T_=''"
cQuery += " WHERE DA0_XCLIEN='"+ccliente+"'"
cQuery += " ORDER BY DA1_CODPRO"
            
If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("FatCafe.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
	Aadd(aAux,{TRB->DA1_CODPRO,TRB->DA1_PRCVEN,TRB->DA1_XPRCPP,TRB->DA0_CODTAB})
	DbSkip()
Enddo

Return(aAux)                                                                     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC20  บAutor  ณMicrosiga           บ Data ณ  06/16/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Determinar qual e o contador a ser utilizado no faturamentoฑฑ
ฑฑบ          ณatual.                                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function DetFech(nlinha)

Local aArea	:=	GetArea()
Local cPtr	:=	aList2[nLinha,2] 
Local nPosA	:=	Ascan(aList2,{|x| Alltrim(x[2])+Alltrim(x[32]) == Alltrim(aList2[nLinha,02])+'FAnt'})

If oList2:colpos == 6 .And. aList2[nLinha,32] != "FAnt" .And. Empty(aList3[1,1]) .And. nPosA > 0
	If MsgYesNo("Este serแ o contador a ser utilizado no fechamento deste patrim๔nio?","DetFech - TTPROC20")
		For nX := nPosA to len(aList2)
			If aList2[nX,02] == cPtr 
				If Alltrim(aList2[nX,32]) != "FAnt"
					aList2[nX,32] := "Int"
				EndIf
			Else
				exit
			EndIf
		Next nX
		aList2[nlinha,32] := 'FAtu'
		aList[oList:nAt,24] := '1'
		FHelp(oList:nAt)
	EndIf
EndIf                               

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC20  บAutor  ณMicrosiga           บ Data ณ  06/18/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Planilha de demonstrativo de cafe                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function DemonstCF(ccliente,cs1)

Local oExcel := FWMSEXCEL():New()
Local cTitulo := "Demonstrativo"
Local cDir := ""
Local cArqXls := "Demonstrativo.xml" 
Local nTotal	:=	0
Local nTotal2	:=	0
Local nQtd		:=	0 
Local nTotalA	:=	0
Local nTotal2A	:=	0
Local nQtdA		:=	0 
Local cPat		:=	''   
Local cSheet	:=	''  
Local lMudou	:=	.F. 
Local aAux		:=	{} 
Local aSheAn	:=	{}
Local nAux		:=	1
Local aSintet	:=	{}     
Local aBira		:=	{}  
Local nTotPr	:=	0 
Local aTexto	:=	strtokarr(cs1,"\")

cDir := cGetFile(, OemToAnsi("Selecione o diret๓rio de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 

If Empty(cDir)
	Return
EndIf

oExcel:AddworkSheet("Demonstrativo") 

oExcel:AddTable ("Demonstrativo","Cliente")

oExcel:AddColumn("Demonstrativo","Cliente","Cliente",1,1)
oExcel:AddColumn("Demonstrativo","Cliente","Contrato",1,1) 
oExcel:AddColumn("Demonstrativo","Cliente","Tipo de Servi็o",1,1) 
oExcel:AddColumn("Demonstrativo","Cliente","Patrim๔nios",1,1) 

oExcel:AddRow("Demonstrativo","Cliente",{aList[oList:nAt,01]+"-"+aList[oList:nAt,02]+" "+aList[oList:nAt,15],"","",""})

//oExcel:AddRow("Demonstrativo","Cliente",{""})
cBarra := ''
For nX := 1 to len(aPatri)
	If aPatri[nX,01] == aList[oList:nAt,18]
		cPat += cBarra + Alltrim(aPatri[nX,06])
		cBarra := "/"
	EndIF
Next nX

oExcel:AddRow("Demonstrativo","Cliente",{"",;
										  aList[oList:nAt,18],;
										  aList[oList:nAt,16],;
										  cPat})
For nX := 1 to len(aTexto)										  
	oExcel:AddRow("Demonstrativo","Cliente",{aTexto[nX],'','',''})									   
Next nX

cCabecalho := "GERAL"
oExcel:AddworkSheet("Demonstrativo_Geral") 
oExcel:AddTable ("Demonstrativo_Geral",cCabecalho)
oExcel:AddColumn("Demonstrativo_Geral",cCabecalho,"Produto",1,1)
oExcel:AddColumn("Demonstrativo_Geral",cCabecalho,"Descri็ใo",1,1)
oExcel:AddColumn("Demonstrativo_Geral",cCabecalho,"Quantidade",1,1)
oExcel:AddColumn("Demonstrativo_Geral",cCabecalho,"Valor Unit Empresa",1,1)
//oExcel:AddColumn("Demonstrativo_Geral",cCabecalho,"Valor Unit Publico",1,1)
oExcel:AddColumn("Demonstrativo_Geral",cCabecalho,"Valor Total Empresa",1,1)
//oExcel:AddColumn("Demonstrativo_Geral",cCabecalho,"Valor Total Publico",1,1)

For nI := 1 To Len(aBrw1)
	oExcel:AddRow("Demonstrativo_Geral",cCabecalho,{aBrw1[nI][1],; 	//Produto
											aBrw1[nI][2],;		//Descricao
											aBrw1[nI][3],;		//Qtd
											aBrw1[nI][4],;
											Transform(aBrw1[nI][5],"@E 999,999,999.99")}) 
Next nI

cCabecalho := "Por_Patrimonio"
oExcel:AddworkSheet("Demonstrativo_Patrimonio") 
oExcel:AddTable ("Demonstrativo_Patrimonio",cCabecalho)
oExcel:AddColumn("Demonstrativo_Patrimonio",cCabecalho,"Produto",1,1)
oExcel:AddColumn("Demonstrativo_Patrimonio",cCabecalho,"Descri็ใo",1,1)
oExcel:AddColumn("Demonstrativo_Patrimonio",cCabecalho,"Quantidade",1,1)
oExcel:AddColumn("Demonstrativo_Patrimonio",cCabecalho,"Valor Unit Empresa",1,1)
//oExcel:AddColumn("Demonstrativo_Patrimonio",cCabecalho,"Valor Unit Publico",1,1)
oExcel:AddColumn("Demonstrativo_Patrimonio",cCabecalho,"Valor Total Empresa",1,1)
//oExcel:AddColumn("Demonstrativo_Patrimonio",cCabecalho,"Valor Total Publico",1,1)

For nI := 1 To Len(aBrw2)
	oExcel:AddRow("Demonstrativo_Patrimonio",cCabecalho,{aBrw2[nI][1],; 	//Produto
											aBrw2[nI][2],;		//Descricao
											aBrw2[nI][3],;		//Qtd
											aBrw2[nI][4],;
											If(!Empty(aBrw2[nI][5]),Transform(aBrw2[nI][5],"@E 999,999,999.99"),"")}) 
Next nI

cCabecalho := "Por_Loja"
oExcel:AddworkSheet("Demonstrativo_Loja") 
oExcel:AddTable ("Demonstrativo_Loja",cCabecalho)
oExcel:AddColumn("Demonstrativo_Loja",cCabecalho,"Produto",1,1)
oExcel:AddColumn("Demonstrativo_Loja",cCabecalho,"Descri็ใo",1,1)
oExcel:AddColumn("Demonstrativo_Loja",cCabecalho,"Quantidade",1,1)
oExcel:AddColumn("Demonstrativo_Loja",cCabecalho,"Valor Unit Empresa",1,1)
//oExcel:AddColumn("Demonstrativo_Loja",cCabecalho,"Valor Unit Publico",1,1)
oExcel:AddColumn("Demonstrativo_Loja",cCabecalho,"Valor Total Empresa",1,1)
//oExcel:AddColumn("Demonstrativo_Loja",cCabecalho,"Valor Total Publico",1,1)

For nI := 1 To Len(aBrw3)
	oExcel:AddRow("Demonstrativo_Loja",cCabecalho,{aBrw3[nI][1],; 	//Produto
											aBrw3[nI][2],;		//Descricao
											aBrw3[nI][3],;		//Qtd
											aBrw3[nI][4],;
											IF(!Empty(aBrw3[nI][5]),Transform(aBrw3[nI][5],"@E 999,999,999.99"),"")}) 
Next nI
 
				
oExcel:Activate()

oExcel:GetXMLFile(cDir +cArqXls)

If File(cDir +cArqXls)
	Aviso("TTPROC20","A planilha foi gerada em "+cDir,{"Ok"})
	If !ApOleClient( 'MsExcel' )
		Aviso("TTPROC20", 'MsExcel nใo instalado. ' +CRLF +'O arquivo estแ em: '+cDir )
	Else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cDir +cArqXls )
		oExcelApp:SetVisible(.T.)         
		oExcelApp:Destroy()
	EndIf
EndIf  

Return  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC20  บAutor  ณMicrosiga           บ Data ณ  06/18/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MontaPed(cFatPor,aAuxP)

Local aArea	:=	GetArea()     
Local cPat	:=	''     
Local cBarra:=	''
Local aAuxiliar	:=	{} 
Local dDt1		:=	ctod(' / / ')
Local dDt2		:=	ctod(' / / ')
Local nPrcPP	:=	0 
Local lCompl	:=	.F.
      
aProd := {}

If cFatPor == "1"
	For nPP := 1 to len(aAuxP)     
    	If Empty(dDt1) .Or. dDt1 > ctod(aAuxP[nPP,03])
	    	dDt1 := ctod(aAuxP[nPP,03])
	    EndIf
	    If Empty(dDt2) .Or. dDt2 < ctod(aAuxP[nPP,03])
	    	dDt2 := ctod(aAuxP[nPP,03])
	    EndIf
	    
    Next nPP
    	
	      
	For nX := 1 to len(aPatri)
		cPat += cBarra+aPatri[nX,06]
		cBarra := "/"
	Next nX
	
	// dose complementar
	/*
	If nDifDose > 0
	    Adel(aBrw1,Len(aBrw1))
	    asize( aBrw1, Len(aBrw1)-1 )
		For nI := 1 To Len(aTabela)
			nPrcUn := aTabela[nI][2]	
			cDesc := Posicione( "SB1",1,xFilial("SB1")+AvKey(aTabela[nI][1],"B1_COD"),"B1_DESC" )
			If "COMPL" $ cDesc
				AADD( aBrw1,{ aTabela[nI][1], cDesc, nDifDose, nPrcUn, nDifDose*nPrcUn } ) 
			EndIf
		Next nI		
		nTotPr := 0
		nTotQt := 0
		AEval(aBrw1, {|aBrw1| nTotPr += aBrw1[05] , nTotQt += aBrw1[03]}) 
		Aadd(aBrw1,{'','Total',nTotQt,,nTotPr})  
	EndIf
	*/  
	For nX := 1 to len(aBrw1)
		If !Empty(aBrw1[nX,01]) 
			If Ascan(aTabela,{|x| Alltrim(x[1]) == Alltrim(aBrw1[nX,01])}) > 0
				nPrcPP := aTabela[Ascan(aTabela,{|x| Alltrim(x[1]) == Alltrim(aBrw1[nX,01])}),03]
			Else
				nPrcPP := 0
			EndIf
			Aadd(aProd,{aBrw1[nX,01],;
						aBrw1[nX,02],;
						aBrw1[nX,03],;
						aBrw1[nX,04],;
						aBrw1[nX,05],;
						aList[oList:nAt,01]+aList[oList:nAt,02],;
						aList[oList:nAt,18],;
						aList[oList:nAt,16],;
						cPat,;
						nPrcPP,;
						(nPrcPP*aBrw1[nX,03]),;
						aList[oList:nAt,19],;
						aList[oList:nAt,20],;
						aList[oList:nAt,22],;
						aList[oList:nAt,23],;
						aTabela[1,4],;
						If('COMPL'$Upper(aBrw1[nX,02]),'C',''),;
						dDt1,;
						dDt2})
		EndIf
	Next nX
	       
	// complemento
	If nDifDose > 0
		For nI := 1 To Len(aTabela)
			nPrcUn := aTabela[nI][2]	
			nPrcPP := aTabela[nI][3]	
			cDesc := Posicione( "SB1",1,xFilial("SB1")+AvKey(aTabela[nI][1],"B1_COD"),"B1_DESC" )
			If "COMPL" $ cDesc .And. Ascan( aProd, { |x| x[1] == aTabela[nI][1] } ) == 0	// alterado 31/07/2015
				Aadd(aProd,{ aTabela[nI][1],;
							cDesc,;
							nDifDose,;
							nPrcUn,;
							nDifDose*nPrcUn ,;
							aList[oList:nAt,01]+aList[oList:nAt,02],;
							aList[oList:nAt,18],;
							aList[oList:nAt,16],;
							cPat,;
							nPrcPP,;
							(nPrcPP*nDifDose),;
							aList[oList:nAt,19],;
							aList[oList:nAt,20],;
							aList[oList:nAt,22],;
							aList[oList:nAt,23],;
							aTabela[1,4],;
							'C',;
							dDt1,;
							dDt2})
			EndIf
		Next nI		
	EndIf
	

	//Gerar o pedido
	cRet := U_TTPROC22()
	aList3 := {}	
	If "/" $ cRet
		aAuxiliar := strtokarr(cRet,"/")
		
		For nX := 1 to len(aAuxiliar)
			cQuery := "SELECT SUM(C6_VALOR) AS TOTAL FROM "+RetSQLName("SC6")
			cQuery += " WHERE C6_FILIAL='"+xFilial("SC6")+"' AND C6_NUM='"+aAuxiliar[nX]+"' AND D_E_L_E_T_=''"
			If Select('TRB') > 0
				dbSelectArea('TRB')
				dbCloseArea()
			EndIf
			
			MemoWrite("FatCafe.SQL",cQuery)
			DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
			
			DbSelectArea("TRB")
			nTot := TRB->TOTAL
			
			Aadd(aList3,{aAuxiliar[nX],'',nTot})
		Next nX

	Else
		cQuery := "SELECT SUM(C6_VALOR) AS TOTAL FROM "+RetSQLName("SC6")
		cQuery += " WHERE C6_FILIAL='"+xFilial("SC6")+"' AND C6_NUM='"+cRet+"' AND D_E_L_E_T_=''"
		If Select('TRB') > 0
			dbSelectArea('TRB')
			dbCloseArea()
		EndIf
		
		MemoWrite("FatCafe.SQL",cQuery)
		DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
		
		DbSelectArea("TRB")
		nTot := TRB->TOTAL
		
		Aadd(aList3,{cRet,'',nTot})
	EndIf
    
    //Gravar informacoes dos pedidos na tabela szn
    DbSelectArea("SZN")
    DbSetOrder(1)
    For nX := 1 to len(aAuxP)
    	If aAuxP[nX,32] == "FAtu"
        	aAuxP[nX,33] := cRet
        	DbGoto(aAuxP[nX,34])
        	Reclock("SZN",.F.)
        	SZN->ZN_CONFERE := 'F'
        	SZN->ZN_PEDIDOS := cRet
        	SZN->(Msunlock())
     	EndIf
    Next nX
    oList3:SetArray(aList3)
	oList3:bLine := {||{aList3[oList3:nAt,01],;
	   					 aList3[oList3:nAt,02],; 
	 					 aList3[oList3:nAt,03]}} 

	aList[oList:nAt,24] := '1'
	oList3:refresh()
	oDlg1:refresh()
Else    
	//data inicial e final do faturamento
	For nPP := 1 to len(aAuxP)     
    	If Empty(dDt1) .Or. dDt1 > ctod(aAuxP[nPP,03])
	    	dDt1 := ctod(aAuxP[nPP,03])
	    EndIf
	    If Empty(dDt2) .Or. dDt2 < ctod(aAuxP[nPP,03])
	    	dDt2 := ctod(aAuxP[nPP,03])
	    EndIf
	    
    Next nPP   
    //Patrimonios contidos no contrato
   	For nX := 1 to len(aPatri)
   		If aList2[1,1] == aPatri[nX,01]
			cPat += cBarra+aPatri[nX,06]
			cBarra := "/"   
		EndIf
	Next nX
    
	//Faturamento pelos contadores apurados
	For nX := 1 to len(aBrw3)
		If !Empty(aBrw3[nX,01]) 
			If Ascan(aTabela,{|x| Alltrim(x[1]) == Alltrim(aBrw3[nX,01])}) > 0
				nPrcPP := aTabela[Ascan(aTabela,{|x| Alltrim(x[1]) == Alltrim(aBrw3[nX,01])}),03]
			Else
				nPrcPP := 0
			EndIf
			Aadd(aProd,{aBrw3[nX,01],aBrw3[nX,02],aBrw3[nX,03],aBrw3[nX,04],aBrw3[nX,05],;
						aList[oList:nAt,01]+aList[oList:nAt,02],aList[oList:nAt,18],aList[oList:nAt,16],cPat,nPrcPP,(nPrcPP*aBrw3[nX,03]),;
						aList[oList:nAt,19],aList[oList:nAt,20],aList[oList:nAt,22],aList[oList:nAt,23],aTabela[1,4],;
						If('COMPL'$Upper(aBrw3[nX,02]),'C',''),dDt1,dDt2})
			//Validacao para incluir o complemento no pedido nos casos de faturamento por loja do cliente.
			//o Sistema estava colocando o complemento somente nos faturamentos por cliente - 10/03/15 - Alexandre
			If 'COMPL' $ Upper(aBrw3[nX,02])
				lCompl := .T.
			EndIf 
		EndIf
	Next nX
	
	If !lCompl
		//Finalizacao da validacao do complemento - 10/03/15 - Alexandre
		For nX := 1 to len(aBrw1)
			If 'COMPL' $ Upper(aBrw1[nX,02])
				Aadd(aProd,{aBrw1[nX,01],aBrw1[nX,02],aBrw1[nX,03],aBrw1[nX,04],aBrw1[nX,05],;
						aList[oList:nAt,01]+aList[oList:nAt,02],aList[oList:nAt,18],aList[oList:nAt,16],cPat,nPrcPP,(nPrcPP*aBrw1[nX,03]),;
						aList[oList:nAt,19],aList[oList:nAt,20],aList[oList:nAt,22],aList[oList:nAt,23],aTabela[1,4],;
						'C',dDt1,dDt2}) 
			
			EndIf
		Next nX
	EndIf
	
 	//Gerar o pedido
	cRet := U_TTPROC22()
	aList3 := {}
	If !Empty(cRet)	
		If "/" $ cRet
			aAuxiliar := strtokarr(cRet,"/")
			
			For nX := 1 to len(aAuxiliar)
				cQuery := "SELECT SUM(C6_VALOR) AS TOTAL FROM "+RetSQLName("SC6")
				cQuery += " WHERE C6_FILIAL='"+xFilial("SC6")+"' AND C6_NUM='"+aAuxiliar[nX]+"' AND D_E_L_E_T_=''"
				If Select('TRB') > 0
					dbSelectArea('TRB')
					dbCloseArea()
				EndIf
				
				MemoWrite("FatCafe.SQL",cQuery)
				DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
				
				DbSelectArea("TRB")
				nTot := TRB->TOTAL
				
				Aadd(aList3,{aAuxiliar[nX],'',nTot})
			Next nX
	
		Else
			cQuery := "SELECT SUM(C6_VALOR) AS TOTAL FROM "+RetSQLName("SC6")
			cQuery += " WHERE C6_FILIAL='"+xFilial("SC6")+"' AND C6_NUM='"+cRet+"' AND D_E_L_E_T_=''"
			If Select('TRB') > 0
				dbSelectArea('TRB')
				dbCloseArea()
			EndIf
			
			MemoWrite("FatCafe.SQL",cQuery)
			DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
			
			DbSelectArea("TRB")
			nTot := TRB->TOTAL
			
			Aadd(aList3,{cRet,'',nTot})
		EndIf
	    
	    //Gravar informacoes dos pedidos na tabela szn
	    DbSelectArea("SZN")
	    DbSetOrder(1)
	    For nX := 1 to len(aAuxP)
	    	If aAuxP[nX,32] == "FAtu"
	        	aAuxP[nX,33] := cRet
	        	DbGoto(aAuxP[nX,34])
	        	Reclock("SZN",.F.)
	        	SZN->ZN_CONFERE := 'F'
	        	SZN->ZN_PEDIDOS := cRet
	        	SZN->(Msunlock())  
	        	CONOUT("#TTPROC20 -> GEROU PEDIDO - RECNO SZN: " +CVALTOCHAR(aAuxP[nX,34]))
	     	EndIf
	    Next nX
	EndIf 
	    
    oList3:SetArray(aList3)
	oList3:bLine := {||{aList3[oList3:nAt,01],;
	   					 aList3[oList3:nAt,02],; 
	 					 aList3[oList3:nAt,03]}} 

	aList[oList:nAt,24] := '1'
	oList3:refresh()
	oDlg1:refresh()
EndIf

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC20  บAutor  ณMicrosiga           บ Data ณ  06/20/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Visualizar o pedido de venda gerado.                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VerPv(nLinha)

Local aArea		:=	GetArea()   
Local cRec		:=	0
PRIVATE Altera 	:=  .F.
PRIVATE aRotina := MenuDef()                               
PRIVATE cCadastro := "Visualiza็ใo de Pedido de Venda"

If !Empty(aList3[nLinha,01])
	DbSelectArea("SC5")
	DbSetORder(1)
	If Dbseek(xFilial("SC5")+aList3[nLinha,01])
		cRec := Recno()     
		A410Visual("SC5",cRec,2) 
	EndIf
EndIf

RestArea(aArea)

Return