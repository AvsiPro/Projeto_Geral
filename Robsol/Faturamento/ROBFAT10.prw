#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'   
#INCLUDE "TBICONN.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ROBFAT10  ³ Autor ³ Alexandre Venancio    ³ Data ³06/04/2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³ ROBSOL          ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Exibir o historico financeiro do cliente nos ult 12 meses  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³                                               ³±±
±±³              ³  /  /  ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function ROBFAT10(codigo,loja,cIdPr)

Local aArea		:=	GetArea()

Private oDlg1,oGrp1,oSay1,oSay2,oSay3,oSay4,oGrp2,oBrw1,oBtn1,oList,oBtn2,oBtn3,oSay5,oSay6
Private aList 	:=	{} 
Private aItens	:=	{}
Private cNome 	:=	Posicione("SA1",1,xFilial("SA1")+codigo+loja,"A1_NOME")
Private cCgc	:=	Posicione("SA1",1,xFilial("SA1")+codigo+loja,"A1_CGC")
Private cFone 	:=	Posicione("SA1",1,xFilial("SA1")+codigo+loja,"A1_TEL")
 
Default cCodigo := ''
Default cLoja 	:= ''

cCodigo := codigo 
cLoja   := loja 

PreAcols(codigo,loja,cIdPr)

If len(aList) < 1
	MsgAlert("Não foram encontrados titulos vencidos para este cliente","ROBFAT10")
	Return
EndIf

//Prepare Environment Empresa "01" FILIAL "01" Tables "SA1","SE1"

oDlg1      := MSDialog():New( 091,232,581,924,"Histórico Financeiro do Cliente",,,.F.,,,,,,.T.,,,.T. )

oGrp1      := TGroup():New( 004,004,056,336,"Dados do Cliente",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay1      := TSay():New( 012,016,{||"Código Cliente:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
	oGet1      := TGet():New( 020,016,{|u| If(PCount()>0,codigo:=u,codigo+"-"+loja)},oGrp1,056,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	
	oSay2      := TSay():New( 012,092,{||"Nome:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,008)
	oGet2      := TGet():New( 020,092,{|u| If(PCount()>0,cNome:=u,cNome)},oGrp1,184,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

	oSay3      := TSay():New( 032,016,{||"CNPJ"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,008)
	oGet3      := TGet():New( 040,016,{|u| If(PCount()>0,cCgc:=u,cCgc)},oGrp1,056,008,'@R 99.999.999/9999-99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

	oSay4      := TSay():New( 032,092,{||"Telefone"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)
	oGet4      := TGet():New( 040,092,{|u| If(PCount()>0,cFone:=u,cFone)},oGrp1,060,008,'@R 9999-9999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	

	oSay5      := TSay():New( 035,192,{||"Vencidos"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,224,008)
	oSay6      := TSay():New( 045,192,{||"A Vencer"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,224,008)
	
	oGet1:Disable()
	oGet2:Disable()
	oGet3:Disable()
	oGet4:Disable()

oGrp2      := TGroup():New( 064,004,212,336,"Histórico",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

	oList := TCBrowse():New(076,012,320,130,, {'Número NF','Série','Emissão','Vencimento','Valor','Status'},{50,30,50,50,50,50},; //,'Data Entrega','Canhoto','Romaneio'
	                            oGrp2,,,,{|| Fhelp(oList:nAt)},{|| },, ,,,  ,,.F.,,.T.,,.F.,,,)
	oList:SetArray(aList)
	oList:bLine := {||{ aList[oList:nAt,01],; 
	 					 aList[oList:nAt,02],;
	 					 aList[oList:nAt,03],;
	                     aList[oList:nAt,04],;
	                     Transform(aList[oList:nAt,05],"@E 999,999,999.99"),;
						 If(aList[oList:nAt,04]<ddatabase,'Vencido','A Vencer')}}

oBtn2      := TButton():New( 220,088,"Vis. Itens",oDlg1,{||ConsItens(aList[oList:nAt,01],aList[oList:nAt,02],aList[oList:nAt,09])},037,012,,,,.T.,,"",,,,.F. )
//oBtn3      := TButton():New( 220,148,"Enviar PDF",oDlg1,{||U_TTRREIMP(aList[oList:nAt,01],aList[oList:nAt,02])},037,012,,,,.T.,,"",,,,.F. )
oBtn1      := TButton():New( 220,208,"Sair",oDlg1,{||oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )
//oBtn3:disable()

oDlg1:Activate(,,,.T.)

//Reset Environment

RestArea(aArea)

Return                                                                                                      


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ROBFAT10   ºAutor  ³Microsiga           º Data ³  04/08/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PreAcols(codigo,loja,cIdPr)

Local aArea	:=	GetArea()
Local cQuery
Local nX 

aList := {} 
aItens:= {}

cQuery := "SELECT E1_PREFIXO,E1_NUM,E1_TIPO,E1_VALOR,E1_EMISSAO,E1_VENCREA,E1_VEND1,E1_SALDO,E1_FILORIG,E1_CLIENTE,E1_LOJA"
cQuery += " FROM "+RetSQLName("SE1")
cQuery += " WHERE E1_FILIAL BETWEEN ' ' AND 'ZZZ' AND E1_CLIENTE='"+codigo+"' AND E1_LOJA='"+loja+"'"
//cQuery += " AND E1_VENCREA <'"+dtos(dDataBase)+"'"
cQuery += " AND (E1_BAIXA=' ' OR E1_SALDO>0) AND D_E_L_E_T_=''"

If !Empty(cIdPr)
	cQuery += " UNION "
	cQuery += " SELECT E1_PREFIXO,E1_NUM,E1_TIPO,E1_VALOR,E1_EMISSAO,E1_VENCREA,E1_VEND1,E1_SALDO,E1_FILORIG,E1_CLIENTE,E1_LOJA"
	cQuery += " FROM "+RetSQLName("SE1")
	cQuery += " WHERE E1_FILIAL BETWEEN ' ' AND 'ZZZ' AND E1_CLIENTE IN(SELECT A1_COD FROM "+RetSQLName("SA1")
	cQuery += " 					WHERE A1_FILIAL='"+xFilial("SA1")+"' AND A1_XIDPROP='"+cIdPr+"')" 
	//cQuery += " AND E1_VENCREA <'"+dtos(dDataBase)+"'"
	cQuery += " AND (E1_BAIXA=' ' OR E1_SALDO>0) AND D_E_L_E_T_=' '"


EndIF


If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("ROBFAT10.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")         

While !Eof()  
    Aadd(aList,{TRB->E1_NUM,TRB->E1_PREFIXO,STOD(TRB->E1_EMISSAO),STOD(TRB->E1_VENCREA),;
    			TRB->E1_VALOR,"","","",TRB->E1_FILORIG,;
				TRB->E1_CLIENTE,TRB->E1_LOJA})
	DbSkip()
EndDo


                         
For nX := 1 to len(aList)

/*	cQuery := "SELECT F2_XCARGA,F2_XRECENT,F2_XRECASS,F2_XDTENTR"
	cQuery += " FROM "+RetSQLName("SF2")
	cQuery += " WHERE F2_FILIAL='"+aList[nX,09]+"'"
	cQuery += " AND F2_SERIE='"+aList[nX,02]+"' AND F2_DOC='"+aList[nX,01]+"'"
	cQuery += " AND D_E_L_E_T_=''"
	
	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf

	MemoWrite("ROBFAT10.SQL",cQuery)
	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
	
	DbSelectArea("TRB")
	
	While !EOF()
		aList[nX,06] :=  STOD(TRB->F2_XDTENTR)
		aList[nX,07] :=  TRB->F2_XRECASS
		aList[nX,08] :=  TRB->F2_XCARGA
		DbSkip()
	EndDo          
*/	
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

	MemoWrite("ROBFAT10.SQL",cQuery)
	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
	
	DbSelectArea("TRB")
	
	While !EOF()
		Aadd(aItens,{TRB->D2_FILIAL,TRB->D2_DOC,TRB->D2_SERIE,TRB->D2_ITEM,TRB->D2_COD,TRB->B1_DESC,TRB->D2_QUANT,TRB->D2_PRCVEN,TRB->D2_TOTAL})
		Dbskip()
	EndDo

Next nX

RestArea(aArea)

Return                                              

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ROBFAT10   ºAutor  ³Microsiga           º Data ³  11/26/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
		oList2 := TCBrowse():New(024,020,240,100,, {'Item NF','Código','Descrição','Quantidade','Valor Unit.','Valor Total'},{30,40,50,30,30,30},;
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

/*/{Protheus.doc} Fhelp
	(long_description)
	@type  Static Function
	@author user
	@since 26/01/2023
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function Fhelp(nLinha)

Local nTotVc := 0
Local nTotAv := 0

Aeval(aList,{|x| nTotVc += If(x[4]<ddatabase,x[5],0)})
Aeval(aList,{|x| nTotAv += If(x[4]>=ddatabase,x[5],0)})

oSay5:settext("")
oSay6:settext("")

oSay5:settext("Vencidos "+Transform(nTotVc,"@E 999,999.99") )
oSay6:settext("A Vencer "+Transform(nTotAv,"@E 999,999.99") )

If aList[nLinha,10] <> cCodigo .Or. aList[nLinha,11] <> cloja 
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial("SA1")+aList[nLinha,10]+aList[nLinha,11])
	cNome := SA1->A1_NOME
	cCgc  := SA1->A1_CGC
	cFone := SA1->A1_TEL

	oGet1:cText(cNome)
	oGet2:cText(cCgc)
	oGet3:cText(cFone)
	
	
EndIF 

oDlg1:refresh()

Return
