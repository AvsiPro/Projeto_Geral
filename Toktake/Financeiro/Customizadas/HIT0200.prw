#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'   
#INCLUDE "TBICONN.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ HIT0200  ณ Autor ณ Alexandre Venancio    ณ Data ณ06/04/2012ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณLocacao   ณ HITACHI          ณContato ณ                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Exibir o historico financeiro do cliente nos ult 12 meses  ณฑฑ
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

User Function HIT0200(codigo,loja)

Local aArea		:=	GetArea()

Private oDlg1,oGrp1,oSay1,oSay2,oSay3,oSay4,oGrp2,oBrw1,oBtn1,oList,oBtn2,oBtn3
Private aList 	:=	{} 
Private aItens	:=	{}

 
PreAcols(codigo,loja)

If len(aList) < 1
	MsgAlert("Nใo foram encontrados titulos vencidos para este cliente","HIT0200")
	Return
EndIf

//Prepare Environment Empresa "01" FILIAL "01" Tables "SA1","SE1"

oDlg1      := MSDialog():New( 091,232,581,924,"Hist๓rico Financeiro do Cliente",,,.F.,,,,,,.T.,,,.T. )

oGrp1      := TGroup():New( 004,004,056,336,"Dados do Cliente",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay1      := TSay():New( 012,016,{||"C๓digo Cliente:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
	oGet1      := TGet():New( 020,016,{|u| If(PCount()>0,codigo:=u,codigo+"-"+loja)},oGrp1,056,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	
	oSay2      := TSay():New( 012,092,{||"Nome:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,008)
	oGet2      := TGet():New( 020,092,{|| Posicione("SA1",1,xFilial("SA1")+codigo+loja,"A1_NOME")},oGrp1,184,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

	oSay3      := TSay():New( 032,016,{||"CNPJ"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,008)
	oGet3      := TGet():New( 040,016,{|| Posicione("SA1",1,xFilial("SA1")+codigo+loja,"A1_CGC")},oGrp1,056,008,'@R 99.999.999/9999-99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

	oSay4      := TSay():New( 032,092,{||"Telefone"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)
	oGet4      := TGet():New( 040,092,{|| Posicione("SA1",1,xFilial("SA1")+codigo+loja,"A1_TEL")},oGrp1,060,008,'@R 9999-9999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	
	oGet1:Disable()
	oGet2:Disable()
	oGet3:Disable()
	oGet4:Disable()

oGrp2      := TGroup():New( 064,004,212,336,"Hist๓rico",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

	oList := TCBrowse():New(076,012,320,130,, {'N๚mero NF','S้rie','Emissใo','Vencimento','Valor','Data Entrega','Canhoto','Romaneio'},{50,30,50,50,50,50,30,30},;
	                            oGrp2,,,,{|| },{|| },, ,,,  ,,.F.,,.T.,,.F.,,,)
	oList:SetArray(aList)
	oList:bLine := {||{ aList[oList:nAt,01],; 
	 					 aList[oList:nAt,02],;
	 					 aList[oList:nAt,03],;
	                     aList[oList:nAt,04],;
	                     aList[oList:nAt,05],;
	                     aList[oList:nAt,06],;
	                     aList[oList:nAt,07],;
	                     aList[oList:nAt,08]}}

oBtn2      := TButton():New( 220,088,"Vis. Itens",oDlg1,{||ConsItens(aList[oList:nAt,01],aList[oList:nAt,02],aList[oList:nAt,09])},037,012,,,,.T.,,"",,,,.F. )
oBtn3      := TButton():New( 220,148,"Enviar PDF",oDlg1,{||U_TTRREIMP(aList[oList:nAt,01],aList[oList:nAt,02])},037,012,,,,.T.,,"",,,,.F. )
oBtn1      := TButton():New( 220,208,"Sair",oDlg1,{||oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )
oBtn3:disable()

oDlg1:Activate(,,,.T.)

//Reset Environment

RestArea(aArea)

Return                                                                                                      


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHIT0200   บAutor  ณMicrosiga           บ Data ณ  04/08/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PreAcols(codigo,loja)

Local aArea	:=	GetArea()
Local cQuery
Local nX 

aList := {} 
aItens:= {}

cQuery := "SELECT E1_PREFIXO,E1_NUM,E1_TIPO,E1_VALOR,E1_EMISSAO,E1_VENCREA,E1_VEND1,E1_SALDO"
cQuery += " FROM "+RetSQLName("SE1")
cQuery += " WHERE E1_CLIENTE='"+codigo+"' AND E1_LOJA='"+loja+"'"
cQuery += " AND E1_VENCREA <'"+dtos(dDataBase)+"' AND (E1_BAIXA='' OR E1_SALDO>0) AND D_E_L_E_T_=''"


If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("HIT0200.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")         

While !Eof()  
    Aadd(aList,{TRB->E1_NUM,SUBSTR(TRB->E1_PREFIXO,3,3),STOD(TRB->E1_EMISSAO),STOD(TRB->E1_VENCREA),;
    			Transform(TRB->E1_VALOR,"@E 999,999,999.99"),"","","",SUBSTR(TRB->E1_PREFIXO,1,2)})
	DbSkip()
EndDo


If cEmpAnt == "01"                         
	For nX := 1 to len(aList)
	
		cQuery := "SELECT F2_XCARGA,F2_XRECENT,F2_XRECASS,F2_XDTENTR"
		cQuery += " FROM "+RetSQLName("SF2")
		cQuery += " WHERE F2_FILIAL='"+aList[nX,09]+"'"
		cQuery += " AND F2_SERIE='"+aList[nX,02]+"' AND F2_DOC='"+aList[nX,01]+"'"
		cQuery += " AND D_E_L_E_T_=''"
		
		If Select('TRB') > 0
			dbSelectArea('TRB')
			dbCloseArea()
		EndIf
	
		MemoWrite("HIT0200.SQL",cQuery)
		DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
		
		DbSelectArea("TRB")
		
		While !EOF()
			aList[nX,06] :=  STOD(TRB->F2_XDTENTR)
			aList[nX,07] :=  TRB->F2_XRECASS
			aList[nX,08] :=  TRB->F2_XCARGA
			DbSkip()
		EndDo          
		
		cQuery := "SELECT D2_FILIAL,D2_DOC,D2_SERIE,D2_ITEM,D2_COD,B1_DESC,D2_QUANT,D2_PRCVEN,D2_TOTAL"
		cQuery += " FROM "+RetSQLName("SD2")+" D2"
		cQuery += "  INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=D2_COD AND B1.D_E_L_E_T_=''"
		cQuery += " WHERE D2_FILIAL='"+aList[nX,09]+"'"
		cQuery += " AND D2_SERIE='"+aList[nX,02]+"' AND D2_DOC='"+aList[nX,01]+"'"
		cQuery += " AND D2.D_E_L_E_T_=''"
	
		If Select('TRB') > 0
			dbSelectArea('TRB')
			dbCloseArea()
		EndIf
	
		MemoWrite("HIT0200.SQL",cQuery)
		DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
		
		DbSelectArea("TRB")
		
		While !EOF()
			Aadd(aItens,{TRB->D2_FILIAL,TRB->D2_DOC,TRB->D2_SERIE,TRB->D2_ITEM,TRB->D2_COD,TRB->B1_DESC,TRB->D2_QUANT,TRB->D2_PRCVEN,TRB->D2_TOTAL})
			Dbskip()
		EndDo
	
	Next nX
EndIf    


RestArea(aArea)

Return                                              

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHIT0200   บAutor  ณMicrosiga           บ Data ณ  11/26/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ConsItens(cDoc,cSerie,cFila)

Local oDlg2,oGrp2,oBtn1,oList2
Local aAux	:=	{}
Local nX 

For nX := 1 to len(aItens)  
	If aItens[nX,01] == cFila .And. aItens[nX,02] == cDoc .And. Alltrim(aItens[nX,03]) == Alltrim(cSerie)
		Aadd(aAux,aItens[nX])
	EndIf
Next nX

If len(aAux) > 0
	oDlg2      := MSDialog():New( 091,232,426,789,"Itens da Nota Fiscal - ",,,.F.,,,,,,.T.,,,.T. )
	
	oGrp2      := TGroup():New( 008,008,132,264,"Detalhes",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
	//oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{024,020,120,252},,, oGrp1 )
		oList2 := TCBrowse():New(024,020,240,100,, {'Item NF','C๓digo','Descri็ใo','Quantidade','Valor Unit.','Valor Total'},{30,40,50,30,30,30},;
		                            oGrp2,,,,{|| },{|| },, ,,,  ,,.F.,,.T.,,.F.,,,)
		oList2:SetArray(aAux)
		oList2:bLine := {||{ aAux[oList2:nAt,04],; 
		 					 aAux[oList2:nAt,05],;
		 					 aAux[oList2:nAt,06],;
		                     Transform(aAux[oList2:nAt,07],"@R 9,999.99"),;
		                     Transform(aAux[oList2:nAt,08],"@E 999,999.99"),;
		                     Transform(aAux[oList2:nAt,09],"@E 999,999.99")}}
	 
	oBtn1      := TButton():New( 144,112,"Sair",oDlg2,{||oDlg2:end()},037,012,,,,.T.,,"",,,,.F. )
	
	oDlg2:Activate(,,,.T.)
EndIf

Return
