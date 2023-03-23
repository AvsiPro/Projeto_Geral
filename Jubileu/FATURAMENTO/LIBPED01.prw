#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "tbiconn.ch"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RPTDEF.CH"

#DEFINE DMPAPER_A4
#DEFINE IMP_SPOOL 2
#DEFINE IMP_PDF	   6

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³         ³ Autor ³                       ³ Data ³           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³                  ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³                                                            ³±±
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

User Function LIBPED01()

	Local nSair     := 0   
	Local nX        := 0
	Local nCount    := 0
	Private cCodBar	:= space(14) //Diogo aumentei tamanho de 13 para 14
	Private cNota	:= space(45)
	Private oList1
	Private oList2
	Private aList1	:= {}
	Private aList2	:= {}
	Private oOk   	:= LoadBitmap(GetResources(),'br_verde')       //Controla se o pedido foi alterado ou nao no grid.
	Private oNo   	:= LoadBitmap(GetResources(),'br_vermelho')    
	Private oFont1 	:= TFont():New('Arial',,-78,.T.)
	Private oFont2 	:= TFont():New('Arial',,-16,.T.)
	Private oFont3 	:= TFont():New('Verdana',,-35,.T.)
	Private oFont5 	:= TFont():New('Arial',,-22,.T.)
	Private oDlg1,oGrp1,oSay1,oSay2,oGet1,oGrp2,oGet2,oGrp3,oBrw1,oGrp4,oBrw2,oBtn1,oBtn2,oBtn3,oSay4,oSay5,oSay6,oSay7,oSay8
	Private aOpcoes	:= {}
	Private aRetorno:= {}
	Private cOpcao1 := ''
	Private cOpcao2 := ''
	Private cOpcao3 := ''
	Private aAglut2	:= {}
	Private aBaread	:= {}
	
	If Empty(FunName())
		RpcSetType(3)
		RPCSetEnv("01","0301")
	EndIf

	aAdd(aOpcoes ,{2,"Tipo de Conferência",1, {"1=Saída","2=Entrada"}, 100,'.T.',.T.}) 

	If !ParamBox(aOpcoes ,"Conferência",aRetorno)
		Return
	Else
		cOpcao1 := cvaltochar(aRetorno[1])

	EndIF

	Aadd(aList1,{.F.,'','','','',''})
	Aadd(aList2,{'','','','',''})

	//oDlg1      := MSDialog():New( 092,232,567,1196,"Conferência de Saída",,,.F.,,,,,,.T.,,,.T. )
	oDlg1      := MSDialog():New( 077,056,652,1133,"Conferência de Saída",,,.F.,,,,,,.T.,,,.T. )

		oGrp1      := TGroup():New( 004,008,056,264,"Numero Pedido",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

			oGet1      := TGet():New( 015,042,{|u| If(Pcount()>0,cNota:=u,cNota)},oGrp1,150,008,'',{|| If(!Empty(cNota),BuscaNFe(cNota),)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SC5","",,)
			//oCBox1     := TComboBox():New( 040,152,{|u| If(Pcount()>0,cOpc:=u,cOpc)},aOpcoes,072,010,oDlg1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
			
			oSay1      := TSay():New( 032,016,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,180,008)
			oSay2      := TSay():New( 044,016,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,180,008)
		
		oGrp2      := TGroup():New( 004,268,056,524,"Bipar Caixa",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

			oGet2      := TGet():New( 024,280,{|u| If(Pcount()>0,cCodBar:=u,cCodBar)},oGrp2,140,008,'',{|| If(!Empty(cCodBar),BuscaCx(cCodBar),)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
		
			
		
	//	oGrp3      := TGroup():New( 060,008,204,224,"Itens NF",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oGrp3      := TGroup():New( 060,008,204,264,"Itens NF",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

		//oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{068,012,196,220},,, oGrp3 ) 
		oList1 	   := TCBrowse():New(068,012,248,130,, {'','Codigo','Descrição','Qtd UN','Qtd CX','Cod_Bar_Prod'},{10,30,40,30,30,40},;
									oGrp3,,,,{|| /*FHelp(oList1:nAt)*/},{|| /*editcol(oList1:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
		oList1:SetArray(aList1)
		oList1:bLine := {||{ If(aList1[oList1:nAt,01],oOk,oNo),;
							aList1[oList1:nAt,02],;
							aList1[oList1:nAt,03],; 
							aList1[oList1:nAt,04],;
							aList1[oList1:nAt,05],;
							aList1[oList1:nAt,06]}}
		
	//	oGrp4      := TGroup():New( 060,228,204,468,"Itens Conferidos",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oGrp4      := TGroup():New( 060,268,204,524,"Itens Conferidos",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

		//oBrw2      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{068,232,196,464},,, oGrp4 ) 
		oList2 	   := TCBrowse():New(068,272,250,130,, {'Codigo','Descrição','Qtd UN','Qtd CX','Cod_Bar_CX'},{30,40,30,30,40},;
									oGrp4,,,,{|| /*FHelp(oList1:nAt)*/},{|| /*editcol(oList1:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
		oList2:SetArray(aList2)
		oList2:bLine := {||{ aList2[oList2:nAt,01],;
							aList2[oList2:nAt,02],; 
							aList2[oList2:nAt,03],;
							aList2[oList2:nAt,04],; 
							aList2[oList2:nAt,05]}}
		
		oBtn1      := TButton():New( 212,146,"Salvar",oDlg1,{|| oDlg1:end(nSair:=1)},037,012,,,,.T.,,"",,,,.F. )
		oBtn2      := TButton():New( 212,244,"Sair",oDlg1,{||oDlg1:end(nSair:=0)},037,012,,,,.T.,,"",,,,.F. )
		oBtn3      := TButton():New( 212,324,"Imprimir",oDlg1,{|| imprimirze()},037,012,,,,.T.,,"",,,,.F. )
		
		
		//oBtn1:disable()
		oBtn3:disable()
		
		oSay4      := TSay():New( 232,016,{||"Qtd Caixas"},oDlg1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,180,018)
		oSay5      := TSay():New( 240,036,{||""},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,180,039)
		oSay6      := TSay():New( 232,436,{||"Qtd Contadas"},oDlg1,,oFont2,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,180,018)
		oSay7      := TSay():New( 240,456,{||""},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE,180,039)
		oSay8      := TSay():New( 240,126,{||""},oDlg1,,oFont3,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,260,039)
		
	oDlg1:Activate(,,,.T.)

	If nSair > 0	
		
		nX 	 	 := 0
		nY	 	 := 0
		cNf := Alltrim(cNota)
		aAux1 := {}
		nOpcX      := 0
		nCount     := 0
		aCabec     := {}
		aItens     := {}
		aLinha     := {}
		aErroAuto  := {}
		lErro  	 := .F.
		lOK 		 := .F.
		lMsErroAuto    := .F.

		ConOut("Inicio: " + Time())
		ConOut(Repl("-",80))

		DbselectArea('SC5')
		DbSetOrder(1)


		If cNf <> ''
																																				
			If Dbseek(xFilial('SC5')+cNf) 
						
				aCabec   := {}
				aItens   := {}
				aLinha   := {}

				//cDoc 	:= SC5->C5_NUM
				//cA1Cod  := Posicione('SA1',14,xFilial('SA1')+cValToChar(oPedV[nX]:id_cliente),'A1_COD')
				//cA1Loja := Posicione('SA1',14,xFilial('SA1')+cValToChar(oPedV[nX]:id_cliente),'A1_LOJA')
				aadd(aCabec,{"C5_NUM", cNf, Nil}) 
				aadd(aCabec,{"C5_TIPO", "N", Nil}) 
				aadd(aCabec,{"C5_CLIENTE", alltrim(aList1[1,8]), Nil}) 
				aadd(aCabec,{"C5_LOJACLI", alltrim(aList1[1,9]), Nil}) 
				aadd(aCabec,{"C5_LOJAENT", alltrim(aList1[1,9]), Nil}) 


				For nX := 1 to len(aList1)
					nPos1 := Ascan(aList2,{|x| Alltrim(x[1]) == Alltrim(aList1[nX,02])}) 
					//Ascan(aList2,{|x| Alltrim(x[1]) == Alltrim(aList1[nX,02])}) 
					If nPos1 
						Aadd(aAux1,{aList1[nX,12], aList1[nX,2],aList1[nX,5],aList1[nX,13],aList1[nX,16],aList1[nX,14],aList1[nX,15],aList2[nPos1,4]})
						//Aadd(aAux2,aAux1)
						//aAux1 := {}
					EndIf
					//nQtdCx += aRet[nX,5]
				Next nX

				nX := 0

				For nX := 1 to len(aAux1)

					dbselectarea('SC6')
					dbsetorder(1)

					If Dbseek(xFilial('SC6')+cNf+alltrim(aAux1[nX,1])+alltrim(aAux1[nX,2]))

						aLinha := {}
						aadd(aLinha,{"LINPOS",     "C6_ITEM",    alltrim(aAux1[nX,1])})
						//aadd(aLinha,{"C6_ITEM",,Nil})
						aadd(aLinha,{"AUTDELETA","N",Nil})
						aadd(aLinha,{"C6_PRODUTO",alltrim(aAux1[nX,2]),Nil})
						aadd(aLinha,{"C6_QTDVEN",aAux1[nX,3],Nil})
						aadd(aLinha,{"C6_PRCVEN",aAux1[nX,4],Nil})
						aadd(aLinha,{"C6_PRUNIT",aAux1[nX,5],Nil})
						//aadd(aLinha,{"C6_VALOR",aAux1[nX,6],Nil})
						aadd(aLinha,{"C6_TES",alltrim(aAux1[nX,7]),Nil})
						aadd(aLinha,{"C6_QTDLIB",aAux1[nX,8],Nil})
						//aAux1[nX,8]
		
						aadd(aItens,aLinha)
					Else
						lErro := .T.
					EndIf	
				Next nX

				If !lErro
					nOpcX := 4
					MSExecAuto({|a, b, c, d| MATA410(a, b, c, d)}, aCabec, aItens, nOpcX, .F.)

					If !lMsErroAuto
						ConOut("atualizado com sucesso! " + cNf)
					Else
						RollbackSX8()
						ConOut("Erro na atualizacao!")

						aErroAuto := GetAutoGRLog()
						For nCount := 1 To Len(aErroAuto)
							cLogErro += StrTran(StrTran(aErroAuto[nCount], "<", ""), "-", "") + " "
							ConOut(cLogErro)
						Next nCount

					EndIf
				EndIf
			EndIf
		EndIf
	EndIf

Return

/****************************************************************** /
	Busca a Nota fiscal pelo codigo de barra da SEFAZ

/ ******************************************************************/
Static Function BuscaNFe(cchvnfe)

Local cQuery 	:=	''
Local aRet		:=	{}
// Local aPergs	:=	{}
Local nX        :=  0

aList1 := {}
aList2 := {}

oSay1:settext("")
oSay2:settext("")
oSay5:settext("")
oSay7:settext("")
oSay8:settext("")

	If len(Alltrim(cchvnfe)) < 7
		cQuery := "SELECT DISTINCT C6_PRODUTO,C6_ITEM,B1_DESC,C6_UNSVEN,C6_QTDVEN,B1_CODBAR,A1_NOME,C6_NUM,LK_CODBAR,C5_CLIENTE,C5_LOJACLI,C5_NUM,C6_PRCVEN,C6_VALOR,C6_TES,C6_PRUNIT"
		cQuery += " FROM "+RetSQLName("SC6")+" C6"
		cQuery += " INNER JOIN "+RetSQLName("SC5")+" C5 ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM AND C5_CLIENTE=C6_CLI AND C5.D_E_L_E_T_=''"
		cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=C6_PRODUTO AND B1.D_E_L_E_T_=''"
		cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_COD=C5_CLIENTE AND A1_LOJA=C5_LOJACLI AND A1.D_E_L_E_T_=''"
		cQuery += " LEFT JOIN "+RetSQLName("SLK")+" LK ON LK_CODIGO=C6_PRODUTO AND LK.D_E_L_E_T_=''"
		//cQuery += " LEFT JOIN "+RetSQLName("SZL")+" ZL ON ZL_FILIAL=C6_FILIAL AND ZL_DOCTO=C6_NUM AND C6_PRODUTO=SUBSTRING(ZL_OBS,1,8)  AND ZL.D_E_L_E_T_=''"
		cQuery += " WHERE C6_FILIAL='"+xFilial("SC6")+"' AND C6.D_E_L_E_T_=''"
		cQuery += " AND C6_NUM ='"+Strzero(val(cchvnfe),6)+"'"
		cQuery += " AND C6_NOTA = ' ' "
		cQuery += " ORDER BY C6_PRODUTO"
		
		If Select('TRB') > 0
			dbSelectArea('TRB')
			dbCloseArea()
		EndIf
		
		MemoWrite("TTEST01C.SQL",cQuery)
		DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
		
		DbSelectArea("TRB")  
		
		If !Empty(TRB->A1_NOME)
			oSay1:settext('Cliente '+Alltrim(TRB->A1_NOME))
		EndIF
		If !Empty(TRB->C6_NUM)
			oSay2:settext('Pedido '+Alltrim(TRB->C6_NUM))
		EndIF
		
		While !EOF()
			Aadd(aRet,{.F.,TRB->C6_PRODUTO,Alltrim(TRB->B1_DESC),TRB->C6_UNSVEN,TRB->C6_QTDVEN,TRB->B1_CODBAR,;
						TRB->LK_CODBAR,TRB->C5_CLIENTE,TRB->C5_LOJACLI,TRB->C5_NUM,'',TRB->C6_ITEM,TRB->C6_PRCVEN,TRB->C6_VALOR,TRB->C6_TES,TRB->C6_PRUNIT})
			Dbskip()
		EndDo
	endif
		
If len(aRet) > 0
	
	aList1 := {}
		
	nQtdCx := 0
	For nX := 1 to len(aRet)
		If Ascan(aList1,{|x| Alltrim(x[2]) == Alltrim(aRet[nX,02])}) == 0
			Aadd(aList1,aRet[nX])
		Else
			nPosic := Ascan(aList1,{|x| Alltrim(x[2]) == Alltrim(aRet[nX,02])})
			aList1[nPosic,04] += aRet[nX,04]
			aList1[nPosic,05] += aRet[nX,05]
		EndIf
		//nQtdCx += aRet[nX,5]
	Next nX
	oBtn3:enable()
	
	Aeval(aList1,{|aList1| nQtdCx += aList1[5]})
	
	oSay5:settext(cvaltochar(nQtdCx))
Else
	oBtn3:disable()
EndIF

If len(aList1) < 1
	Aadd(aList1,{.F.,'','','','','','','','','','','','','','',''})
EndIf

If len(aList2) < 1
	Aadd(aList2,{'','','','',''})
EndIf

oList1:SetArray(aList1)
oList1:bLine := {||{ If(aList1[oList1:nAt,01],oOk,oNo),;
					 aList1[oList1:nAt,02],;
					 aList1[oList1:nAt,03],; 
 					 aList1[oList1:nAt,04],;
 					 aList1[oList1:nAt,05],;
 					 aList1[oList1:nAt,06]}}

oList2:SetArray(aList2)
oList2:bLine := {||{ aList2[oList2:nAt,01],;
					 aList2[oList2:nAt,02],; 
 					 aList2[oList2:nAt,03],;
 					 aList2[oList2:nAt,04],; 
 					 aList2[oList2:nAt,05]}}
	
	
oList1:refresh()
oList2:refresh()

oDlg1:refresh()

Return
/****************************************************************** /
	Busca o produto pelo código de barras da caixa.

/ ******************************************************************/

Static Function BuscaCx(cCodBar)

// Local cRet := ''
/******************************************************************
	usar a SLK para gravar codigo de barras por caixa do produto
*******************************************************************/
Local nPos := Ascan(aList1,{|x| Alltrim(x[7]) == Alltrim(cCodBar)})
Local lPass:= .T.
If len(aList2) > 0
	If Empty(aList2[1,1]) 
		aList2 := {}
		Aadd(aAglut2,{Alltrim(cCodBar),0,0})
	EndIf
EndIF

If lPass
	If nPos > 0
		//'Codigo','Descrição','Qtd UN','Qtd CX','Codigo_Barra' alist2
		nPosc := Ascan(aList2,{|x| Alltrim(x[5]) == Alltrim(aList1[nPos,07])})
		nSoma := 0
		Aeval(aList1,{|aList1| nSoma += If(Alltrim(aList1[7]) == Alltrim(cCodBar),aList1[5],0)})
		
		If nPosc > 0
			If aList2[nPosc,04] >= nSoma 
				MsgAlert("Item já atingiu a quantidade de caixas solicitadas na nota fiscal", "Erro!")
			Else
				aList2[nPosc,04] += 1
				aList2[nPosc,03] += aList1[nPos,04]/aList1[nPos,05]
				If Ascan(aAglut2,{|x| x[1] == Alltrim(cCodbar)}) > 0
					aAglut2[Ascan(aAglut2,{|x| x[1] == Alltrim(cCodbar)}),03] += 1
					aAglut2[Ascan(aAglut2,{|x| x[1] == Alltrim(cCodbar)}),02] := nSoma
				EndIf
			EndIf
		Else
			Aadd(aList2,{aList1[nPos,02],aList1[nPos,03],aList1[nPos,04]/aList1[nPos,05],1,cCodBar})
			If Ascan(aAglut2,{|x| x[1] == Alltrim(cCodbar)}) > 0
				aAglut2[Ascan(aAglut2,{|x| x[1] == Alltrim(cCodbar)}),03] := 1
				aAglut2[Ascan(aAglut2,{|x| x[1] == Alltrim(cCodbar)}),02] := nSoma
			EndIf
		EndIf
		
		If len(aList2) < 1
			Aadd(aList2,{'','','','',''})
		EndIf
		
		oList2:SetArray(aList2)
		oList2:bLine := {||{ aList2[oList2:nAt,01],;
							 aList2[oList2:nAt,02],; 
		 					 aList2[oList2:nAt,03],;
		 					 aList2[oList2:nAt,04],; 
		 					 aList2[oList2:nAt,05]}}
		
		
		oList2:refresh()
		validanf()
	Else
		amarra(cCodBar)
	EndIf
EndIf

nTotCx := 0 
Aeval(aList2,{|aList2| nTotCx += aList2[4]})
nPositm := Ascan(aList2,{|x| Alltrim(x[5]) == Alltrim(cCodBar)})

oSay7:settext("")
oSay8:settext("")
oSay7:settext(cvaltochar(nTotCx))
If nPositm > 0
	oSay8:settext(aList2[nPositm,02])
EndIf

cCodBar	:=	space(13)
oGet2:buffer := space(13)
oGet2:CtrlRefresh()
oGet2:setfocus()
oDlg1:refresh()

Return

/****************************************************************** /
	Faz a amarração do codigo de barras da caixa com o produto na
	SLK

/ ******************************************************************/

static Function amarra(codigo)

// Local oAmar,oAmarG1,/*oBrw1,*/oAmarB1,oLAm
Local aAux := {}
Local nPs  := 1
Local nX   := 0

For nX := 1 to len(aList1)
	If Empty(aList1[nX,07])
		Aadd(aAux,{aList1[nX,02],aList1[nX,03]})
	EndIf
Next nX

// If len(aAux) > 0
// 	oAmar      := MSDialog():New( 092,232,563,781,"Amarrar Caixa ao Produto",,,.F.,,,,,,.T.,,,.T. )
	
// 		oAmarG1    := TGroup():New( 000,004,200,264,"Selecione o Produto",oAmar,CLR_BLACK,CLR_WHITE,.T.,.F. )
// 		//oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{008,008,192,256},,, oAmarG1 ) 
// 		oLAm 	   := TCBrowse():New(008,010,248,190,, {'Codigo','Descrição'},{50,90},;
// 		                            oAmarG1,,,,{|| /*FHelp(oList1:nAt)*/},{|| /*editcol(oList1:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
// 		oLAm:SetArray(aAux)
// 		oLAm:bLine := {||{  aAux[oLAm:nAt,01],;
// 							aAux[oLAm:nAt,02]}}
		
// 		oAmarB1    := TButton():New( 208,088,"Confirmar",oAmar,{||oAmar:end(nPs:=oLAm:nAt)},037,012,,,,.T.,,"",,,,.F. )
// 		oAmarB2    := TButton():New( 208,148,"Cancelar",oAmar,{||oAmar:end(nPs:=0)},037,012,,,,.T.,,"",,,,.F. )
	
// 	oAmar:Activate(,,,.T.)
// EndIF

If nPs > 0
	// nPosic := Ascan(aList1,{|x| Alltrim(x[2]) == Alltrim(aAux[nPs,01])})
	nPosic := Ascan(aList1,{|x| Alltrim(x[6]) == codigo})
	If nPosic > 0
		aList1[nPosic,07] := codigo
		//'Codigo','Descrição','Qtd UN','Qtd CX','Codigo_Barra' alist2
		//'','Codigo','Descrição','Qtd UN','Qtd CX','Cod_Bar_Prod'   alist1
		Aadd(aList2,{aList1[nPosic,02],aList1[nPosic,03],aList1[nPosic,04],1,codigo})
		DbSelectArea("SLK")
		DbSetOrder(1)
		Reclock("SLK",.T.)
		SLK->LK_FILIAL := xFilial("SLK")
		SLK->LK_CODBAR := codigo
		SLK->LK_CODIGO := aList1[nPosic,02]
		SLK->LK_QUANT  := aList1[nPosic,04] / aList1[nPosic,05]
		SLK->(Msunlock())
		
		oList1:SetArray(aList1)
		oList1:bLine := {||{ If(aList1[oList1:nAt,01],oOk,oNo),;
							 aList1[oList1:nAt,02],;
							 aList1[oList1:nAt,03],; 
		 					 aList1[oList1:nAt,04],;
		 					 aList1[oList1:nAt,05],;
		 					 aList1[oList1:nAt,06]}}
		
		oList2:SetArray(aList2)
		oList2:bLine := {||{ aList2[oList2:nAt,01],;
							 aList2[oList2:nAt,02],; 
		 					 aList2[oList2:nAt,03],;
		 					 aList2[oList2:nAt,04],; 
		 					 aList2[oList2:nAt,05]}}
		
		
		oList1:refresh()
		oList2:refresh()
		
		validanf()
		
		oDlg1:refresh()
		
	EndIf 
EndIf

Return

/****************************************************************** /
	Busca a Nota fiscal pelo codigo de barra da SEFAZ

/ ******************************************************************/

Static Function validanf()

Local nTotal1	:= 0
Local nTotal2	:= 0 
Local nX    	:= 0 
Local lTotal	:= .F.
Local aAux		:=	{}
	  
For nX := 1 to len(aList1)
	Aadd(aAux,aList1[nX,02])
Next nX

For nX := 1 to len(aAux)
	nTotal1 := 0
	Aeval(aList1,{|aList1| nTotal1 += If(Alltrim(aList1[2]) == Alltrim(aAux[nX]),aList1[5],0)})
	nTotal2 := 0
	Aeval(aList2,{|aList2| nTotal2 += If(Alltrim(aList2[1]) == Alltrim(aAux[nX]),aList2[4],0)})
	If nTotal1 <> nTotal2
		lTotal := .F.
		
	Else
		nPos := Ascan(aList1,{|x| Alltrim(x[2]) == Alltrim(aAux[nX])})
		If nPos > 0
			aList1[nPos,01] := .T.
		EndIf
	EndIf
Next nX

oList1:SetArray(aList1)
oList1:bLine := {||{ If(aList1[oList1:nAt,01],oOk,oNo),;
					 aList1[oList1:nAt,02],;
					 aList1[oList1:nAt,03],; 
 					 aList1[oList1:nAt,04],;
 					 aList1[oList1:nAt,05],;
 					 aList1[oList1:nAt,06]}}
oList1:refresh()

/*If lTotal
	oBtn1:enable()
Else
	oBtn1:disable()
EndIf*/

Return

/****************************************************************** /
	Busca a Nota fiscal pelo codigo de barra da SEFAZ

/ ******************************************************************/
Static Function imprimirze()

Private oArial12	:= TFont():New("Arial",12,12,,.F.,,,,.T.,.F.)
Private oArial10	:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
Private oArial10N	:= TFont():New("Arial",10,10,,.T.,,,,.F.,.F.)
Private oArial12N	:= TFont():New("Arial",12,12,,.T.,,,,.F.,.F.)
Private oArial14N	:= TFont():New("Arial",14,14,,.T.,,,,.F.,.F.)		// Negrito
Private oArial24N	:= TFont():New("Arial",24,24,,.T.,,,,.F.,.F.)		// Negrito
Private cStartPath 	:= GetSrvProfString("Startpath","")
Private oPrint
Private nLinha := 0
Private nLinha2:= 0
Private cCmEm		:=	''
Private cNomAr		:=	"Conferencia"+dtos(ddatabase)+cvaltochar(strtran(time(),":"))+".rel"

If !ExistDir( "c:\temp\" )
	MakeDir( "c:\temp\" )
EndIF

cCmEm := 'c:\temp\'

BDIMP(cCmEm,cNomAr)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QFTRFAT01 ºAutor  ³Microsiga           º Data ³  06/30/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Impressao                                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function BDIMP(cCmEm,cNomAr)

Local lAdjustToLegacy	:= .F.
Local lDisableSetup 	:= .T.
// Local cDestino := ""
// Local cBcoBol := ""
// Local cRetorno := ""

Private cMsg	 	:= ""
Private aArquivos	:=	{}

oPrint := FWMSPrinter():New(cNomAr, IMP_PDF, lAdjustToLegacy,cCmEm , lDisableSetup,,,,.T.,,,.T.)
oPrint:SetPortrait()
oPrint:SetMargin(60,60,60,60)
oPrint:cPathPDF := cCmEm //"c:\temp\"

Processa({|lEnd| ImprNd(cCmEm)},"Imprimindo Conferência","Aguarde...")

Return
/****************************************************************** /
	Busca a Nota fiscal pelo codigo de barra da SEFAZ

/ ******************************************************************/

Static Function ImprNd(cCmEm)

Cabec()
Itens()

oPrint:Preview()

Return

/****************************************************************** /
	Busca a Nota fiscal pelo codigo de barra da SEFAZ

/ ******************************************************************/


Static Function Cabec()

oPrint:StartPage() 		// IniciaO  uma nova pagina
oPrint:SetPortrait()
oPrint:SetMargin(60,60,60,60)
oPrint:cPathPDF := cCmEm //"c:\temp\"

nLinha := 030
nLinha2 := nLinha + 20

If substr(cFilant,1,2) == "01"
	oPrint:SayBitmap(nLinha,010,cStartPath+"\LGRL01.BMP",050,050) //230,040)  // 474,117
Else
	oPrint:SayBitmap(nLinha,010,cStartPath+"\LGRL02.BMP",050,050) //230,040)  // 474,117
EndIf

nLinha += 15
nLinha2 := nLinha + 20

oPrint:Say(nLinha,200,'Conferência de Saída',oArial14N)

nLinha += 10
nLinha2 := nLinha + 20

oPrint:Say(nLinha,200,'Itens Conferidos',oArial10N)

nLinha += 30
nLinha2 := nLinha + 15

nCol1 := 005
nCol2 := nCol1 + 70
		
oPrint:Box(nLinha,nCol1,nLinha2,nCol2, "-1")	//1  codigo produto
oPrint:Say(nLinha+10,nCol1+5,'Produto',oArial10N)

nCol1 := nCol2
nCol2 := nCol1 + 160

oPrint:Box(nLinha,nCol1,nLinha2,nCol2, "-1")	//2  Descrição produto
oPrint:Say(nLinha+10,nCol1+5,'Descrição',oArial10N)

nCol1 := nCol2
nCol2 := nCol1 + 50

oPrint:Box(nLinha,nCol1,nLinha2,nCol2, "-1")	//3  Quantidade Unitária
oPrint:Say(nLinha+10,nCol1+5,'Qtd Unit.',oArial10N)


nCol1 := nCol2
nCol2 := nCol1 + 50

oPrint:Box(nLinha,nCol1,nLinha2,nCol2, "-1")	//4  Quantidade Caixa
oPrint:Say(nLinha+10,nCol1+5,'Qtd Caixas',oArial10N)

nCol1 := nCol2
nCol2 := nCol1 + 50

oPrint:Box(nLinha,nCol1,nLinha2,nCol2, "-1")	//4  Quantidade Contada
oPrint:Say(nLinha+10,nCol1+5,'Qtd Contada',oArial10N)

nCol1 := nCol2
nCol2 := nCol1 + 70

oPrint:Box(nLinha,nCol1,nLinha2,nCol2, "-1")	//5  Código de Barras Produto
oPrint:Say(nLinha+10,nCol1+5,'Cod. Barra Produto',oArial10N)

nCol1 := nCol2
nCol2 := nCol1 + 70

oPrint:Box(nLinha,nCol1,nLinha2,nCol2, "-1")	//6  Código de Barras Caixa
oPrint:Say(nLinha+10,nCol1+5,'Cod. Barra Caixa',oArial10N)
			
//RestArea(aArea)

Return 
/****************************************************************** /
	Busca a Nota fiscal pelo codigo de barra da SEFAZ

/ ******************************************************************/

Static Function Itens()

Local nX := 0

For nX := 1 to len(aList1)
	nLinha += 15
	nLinha2 := nLinha + 20

	If nLinha > 750
		Cabec()
	EndIf
	
	nCol1 := 005
	nCol2 := nCol1 + 70
			
	oPrint:Box(nLinha,nCol1,nLinha2,nCol2, "-1")	//1  codigo produto
	oPrint:Say(nLinha+10,nCol1+5,aList1[nX,02],oArial10)
	
	nCol1 := nCol2
	nCol2 := nCol1 + 160
	
	oPrint:Box(nLinha,nCol1,nLinha2,nCol2, "-1")	//2  Descrição produto
	oPrint:Say(nLinha+10,nCol1+5,aList1[nX,03],oArial10)
	
	nCol1 := nCol2
	nCol2 := nCol1 + 50
	
	oPrint:Box(nLinha,nCol1,nLinha2,nCol2, "-1")	//3  Quantidade Unitária
	oPrint:Say(nLinha+10,nCol1+5,cvaltochar(aList1[nX,04]),oArial10)
	
	
	nCol1 := nCol2
	nCol2 := nCol1 + 50
	
	oPrint:Box(nLinha,nCol1,nLinha2,nCol2, "-1")	//4  Quantidade Caixa
	oPrint:Say(nLinha+10,nCol1+5,cvaltochar(aList1[nX,05]),oArial10)
	
	nCol1 := nCol2
	nCol2 := nCol1 + 50
	
	nPos := Ascan(aList2,{|x| Alltrim(x[1]) == Alltrim(aList1[nX,02])})
	
	oPrint:Box(nLinha,nCol1,nLinha2,nCol2, "-1")	//4  Quantidade Contada
	oPrint:Say(nLinha+10,nCol1+5,If(nPos>0,cvaltochar(aList2[nPos,04]),'0'),oArial10)
	
	nCol1 := nCol2
	nCol2 := nCol1 + 70
	
	oPrint:Box(nLinha,nCol1,nLinha2,nCol2, "-1")	//5  Código de Barras Produto
	oPrint:Say(nLinha+10,nCol1+5,aList1[nX,06],oArial10)
	
	nCol1 := nCol2
	nCol2 := nCol1 + 70
	
	oPrint:Box(nLinha,nCol1,nLinha2,nCol2, "-1")	//6  Código de Barras Caixa
	oPrint:Say(nLinha+10,nCol1+5,If(nPos>0,aList2[nPos,05],''),oArial10)
Next nX

nLinha := 710
oPrint:Line(nLinha,350,nLinha,520,, '-2')
oPrint:Say(nLinha+15,350,'Conferido por:',oArial10N)

Return


			
