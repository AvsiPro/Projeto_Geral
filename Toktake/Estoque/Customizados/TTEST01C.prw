#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'           
#INCLUDE "TBICONN.CH" 
#Include "HBUTTON.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณTTEST01C  ณ Autor ณAlexandre Venancio     ณ Data ณ16/03/2012ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณLocacao   ณ                  ณContato ณ                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Consulta de pecas pela descricao.                          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAplicacao ณ Inclusao de solicitacao ao armazem.                        ณฑฑ
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

User Function TTEST01C()

SetPrvt("oDlg1","oGrp1","oBmp1","oGrp2","oBrw1","oGrp3","oSay9","oSay10","oSay11","oSay12","oGet1","oGet2")
SetPrvt("oGet4","oBtn3","oBtn4","oBtn1","oBtn2","oBtn5")

Private oOk   	:= LoadBitmap(GetResources(),'br_verde')       //Controla se o pedido foi alterado ou nao no grid.
Private oNo   	:= LoadBitmap(GetResources(),'br_vermelho')  

Private oList
Private aList	:=	{}         
Private aListB	:=	{}
Private cCodF	:=	space(25)
Private cCodP	:=	space(15)
Private cDesF	:=	space(50)
Private cDesP	:=	space(45)               
Private nOpT	:=	1

If cEmpAnt <> "01"
	Return
EndIf
//------------------------
//| Abertura do ambiente |
//------------------------
//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "EST" TABLES "SCP","SB1"   

PreAcols()

oDlg1      := MSDialog():New( 089,229,619,1016,"Solicita็ใo de Pe็as",,,.F.,,,,,,.T.,,,.T. )

oGrp1      := TGroup():New( 004,004,156,124,"Foto do Produto",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oBmp1      := TBitmap():New( 012,008,112,140,,"lgrl01.bmp",.F.,oGrp1,,,.F.,.T.,,"",.T.,,.T.,,.F. )
 
oGrp2      := TGroup():New( 004,128,156,384,"Produtos",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

	oList := TCBrowse():New(012,133,245,135,, {'','Produto','Descricao','Cod Fabr','Desc Fabr','Saldo'},{5,10,30,10,30,15},;
	                            oGrp2,,,,{|| FHelp(oList:nAt)},{|| editcol(oList:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,)
	oList:SetArray(aList)
	oList:bLine := {||{ If(aList[oList:nAt,01],oOk,oNo),; 
	 					 aList[oList:nAt,02],;
	 					 aList[oList:nAt,03],;
	                     aList[oList:nAt,04],;
	                     aList[oList:nAt,05],;
	                     aList[oList:nAt,06]}}

oGrp3      := TGroup():New( 159,004,227,384,"Filtro",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay9      := TSay():New( 175,016,{||"C๓digo Fabricante"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
	oGet1      := TGet():New( 175,076,{|u| If(PCount()>0,cCodF:=u,cCodF)},oGrp3,108,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	
	oSay10     := TSay():New( 194,016,{||"Descri็ใo Fabricante"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,071,008)
	oGet2      := TGet():New( 194,076,{|u| If(PCount()>0,cDesF:=u,cDesF)},oGrp3,108,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	
	oSay11     := TSay():New( 175,200,{||"C๓digo Protheus"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
	oGet3      := TGet():New( 175,256,{|u| If(PCount()>0,cCodP:=u,cCodP)},oGrp3,120,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	
	oSay12     := TSay():New( 194,200,{||"Descri็ใo Protheus"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
	oGet4      := TGet():New( 194,256,{|u| If(PCount()>0,cDesP:=u,cDesP)},oGrp3,120,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

	oBtn3      := TButton():New( 211,128,"Filtrar",oGrp3,{||Filtro("")},037,008,,,,.T.,,"",,,,.F. )
	oBtn4      := TButton():New( 211,212,"Limpar Filtro",oGrp3,{||Filtro("Limpar")},037,008,,,,.T.,,"",,,,.F. )

oBtn1      := TButton():New( 236,168,"Gerar Solicita็ใo",oDlg1,{||incluir()},052,012,,,,.T.,,"",,,,.F. )
oBtn5      := TButton():New( 236,068,"Itens Selecionados",oDlg1,{|| Itens()},052,012,,,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 236,272,"Sair",oDlg1,{||oDlg1:end()},052,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)     

//Reset Environment

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTEST01C  บAutor  ณAlexandre Venancio  บ Data ณ  03/16/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Preenchimento do acols com todos os produtos do tipo      บฑฑ
ฑฑบ          ณmaquina e uso e consumo.                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PreAcols()

Local aArea	:=	GetArea()
Local cQuery

cQuery := "SELECT B1_COD,B1_DESC,B1_ESPECIF,B1_XCODFAB,B1_XDESCFA,B2_QATU-B2_RESERVA AS SALDO"
cQuery += " FROM "+RetSQLName("SB1")+" B1"
cQuery += " LEFT JOIN "+RetSQLName("SB2")+" B2 ON B2_FILIAL='"+xFilial("SB2")+"' AND B2_COD=B1_COD AND B2.D_E_L_E_T_<>'*'"
cQuery += " WHERE B1_FILIAL='"+xFilial("SB1")+"' AND B1_XSECAO IN('025','026') AND B1.D_E_L_E_T_<>'*' ORDER BY B1_COD"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("TTEST01C.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

While !EOF()           
    Aadd(aList,{.F.,TRB->B1_COD,TRB->B1_DESC,TRB->B1_XCODFAB,TRB->B1_XDESCFA,TRB->SALDO,TRB->B1_ESPECIF,.T.,0})
	DbSkip()
EndDo
 
aListB := aClone(aList)

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTEST01C  บAutor  ณMicrosiga           บ Data ณ  03/21/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Filtro                                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Filtro(cOpc)

Local aAux		:=	aClone(aList)
Local aListA	:=	{}
Loca nX			:=	0

Processa( {||},"Aguarde...") 

If cOpc == "Limpar"
	aList := aClone(aListB)
	ASIZE(aList,len(aList))
	cCodF	:=	space(25)
	cCodP	:=	space(15)
	cDesF	:=	space(50)
	cDesP	:=	space(45)
Else
	aListA := aClone(aListB)
	//cCodF,cDesF,cCodP,cDesP
	// 4      5     2     3       

	//.F.,TRB->B1_COD,TRB->B1_DESC,TRB->B1_XCODFAB,TRB->B1_XDESCFA,TRB->SALDO,TRB->B1_ESPECIF,.T.,Qtd
	// 1		2			3				4			5				6			7		   8   9
	
	For nX := 1 to len(aListA)
		If !empty(cCodP)
			If !Alltrim(cCodP) $ Alltrim(aListA[nX,02])
				aListA[nX,08] := .F.
				LOOP
			EndIf
		EndIf
		If !empty(cCodF)
			If !Alltrim(cCodF) $ Alltrim(aListA[nX,04])
				aListA[nX,08] := .F.
				LOOP
			EndIf
		EndIf
		If !empty(cDesF)
			If !Alltrim(cDesF) $ Alltrim(aListA[nX,05])
				aListA[nX,08] := .F.
				LOOP
			EndIf
		EndIf
		If !empty(cDesP)
			If !Alltrim(cDesP) $ Alltrim(aListA[nX,03])
				aListA[nX,08] := .F.
				LOOP
			EndIf
		EndIf
	Next nX
	
	aList := {}
	
	nX := 1

	While nX <= len(aListA) 
		If !aListA[nX,08]
			ADEL(aListA,nX)     
			//Redimensinando o tamanho do array para mostrar corretamente no browse
			//Sempre deve fazer isto quando estiver utilizando tcbrowse, senใo a montagem da tela sempre vai procurar pelo array original que sera diferente do atual
			ASIZE(aListA,LEN(aListA)-1)
		else
			aadd(aList,{})   
			nX++
		EndIf 
	Enddo

	If len(aList) > 0
		ACOPY(aListA,aList,1,len(aList))
	Else
		MsgAlert("Nใo hแ produtos que atendam aos dados digitados no filtro, volte e verifique.","TTEST01C")
   		aList := aClone(aListA)
   		ASIZE(aList,len(aList))
	EndIf
EndIf                                                                                                     

oList:nAt := 1
oList:SetFocus()
	oList:SetArray(aList)
	oList:bLine := {||{ If(aList[oList:nAt,01],oOk,oNo),; 
	 					 aList[oList:nAt,02],;
	 					 aList[oList:nAt,03],;
	                     aList[oList:nAt,04],;
	                     aList[oList:nAt,05],;
	                     aList[oList:nAt,06]}}

oList:refresh()
oDlg1:refresh()

Return   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTEST01C  บAutor  ณMicrosiga           บ Data ณ  03/21/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Itens()

Local aAux		:=	aClone(aList)
Local aListA	:=	aClone(aListB)
Local nX := 1 

aList := {}

If nOpt == 1
	While nX <= len(aListA) 
		If !aListA[nX,01]
			ADEL(aListA,nX)     
			//Redimensinando o tamanho do array para mostrar corretamente no browse
			//Sempre deve fazer isto quando estiver utilizando tcbrowse, senใo a montagem da tela sempre vai procurar pelo array original que sera diferente do atual
			ASIZE(aListA,LEN(aListA)-1)
		else
			aadd(aList,{})   
			nX++
		EndIf 
	Enddo
	
	If len(aList) > 0
		ACOPY(aListA,aList,1,len(aList))
	Else
		MsgAlert("Nenhum item foi alterado para gerar a solicita็ใo.","TTEST01C")
	   		aList := aClone(aListA)
	   		ASIZE(aList,len(aList))
		Return
	EndIf
	                                                                                                    
	oList:nAt := 1
	oList:SetFocus()
		oList:SetArray(aList)
		oList:bLine := {||{ If(aList[oList:nAt,01],oOk,oNo),; 
		 					 aList[oList:nAt,02],;
		 					 aList[oList:nAt,03],;
		                     aList[oList:nAt,04],;
		                     aList[oList:nAt,05],;
		                     aList[oList:nAt,06]}} 
	nOpT := 0 
	oBtn5:settext("Todos")
Else
	   
	aList := aClone(aListB)
		oList:SetArray(aList)
		oList:bLine := {||{ If(aList[oList:nAt,01],oOk,oNo),; 
		 					 aList[oList:nAt,02],;
		 					 aList[oList:nAt,03],;
		                     aList[oList:nAt,04],;
		                     aList[oList:nAt,05],;
		                     aList[oList:nAt,06]}}
	oList:refresh()
	oDlg1:refresh()	
	oBtn5:settext("Itens Selecionados")     
	nOpT := 1
EndIf	

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTEST01C  บAutor  ณMicrosiga           บ Data ณ  03/21/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FHelp(nLinha)

If Mod(nLinha,2) == 0             
	oBmp1      := TBitmap():New( 012,008,112,140,,"prod1.bmp",.F.,oGrp1,,,.F.,.T.,,"",.T.,,.T.,,.F. )
Else
	oBmp1      := TBitmap():New( 012,008,112,140,,"prod2.bmp",.F.,oGrp1,,,.F.,.T.,,"",.T.,,.T.,,.F. )
EndIf

oBmp1:refresh()
oDlg1:refresh()

Return  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTEST01C  บAutor  ณMicrosiga           บ Data ณ  03/21/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function editcol(nLinha)
                                                    
Local aArea	:=	GetArea()
Local oDlg,oSay1,oSay2,oSay3,oSay4,oSay5,oGet1,oBtn1
Local nQtd	:=	space(3)
  
If aList[nLinha,01]
	aList[nLinha,01] := .F.
	aList[nLinha,09] := 0
	aListB[Ascan(aListB,{|x| x[2] = aList[nLinha,02]}),01] := .F.
	aListB[Ascan(aListB,{|x| x[2] = aList[nLinha,02]}),09] := 0
Else
	oDlg	   := MSDialog():New( 091,232,288,584,"Quantidade Solicitada",,,.F.,,,,,,.T.,,,.T. )
	oSay1      := TSay():New( 008,016,{||"Produto"},oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
	oSay2      := TSay():New( 008,048,{||aList[nLinha,02]},oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,008)
	oSay3      := TSay():New( 024,016,{||"Descri็ใo"},oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)
	oSay4      := TSay():New( 024,048,{||aList[nLinha,03]},oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,116,008)
	oSay5      := TSay():New( 052,012,{||"Informe a quantidade desejada"},oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,008)
	oGet1      := TGet():New( 052,104,{|u| If(PCount()>0,nQtd:=u,nQtd)},oDlg,044,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	
	oBtn1      := TButton():New( 072,064,"Confirmar",oDlg,{||oDlg:end()},037,012,,,,.T.,,"",,,,.F. )
	
	oDlg:Activate(,,,.T.)
                     
	aList[nLinha,09] := nQtd 
	aListB[Ascan(aListB,{|x| x[2] = aList[nLinha,02]}),09] := nQtd
	aList[nLinha,01] := .T.                   
	aListB[Ascan(aListB,{|x| x[2] = aList[nLinha,02]}),01] := .T.
EndIF


RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTEST01C  บAutor  ณAlexandre Venancio  บ Data ณ  03/16/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function incluir()

Local aCabec	:= {}
Local aItens	:= {}

PRIVATE lMsErroAuto := .F.
                        
aCabec := {}
aItens := {}

For nX := 1 to len(aListB)
	If aListB[nX,01]
		If len(aCabec) == 0
			aadd(aCabec,{"CP_NUM"	  ,getsxenum("SCP","CP_NUM"),Nil})
			aadd(aCabec,{"CP_SOLICIT" , CUSERNAME,Nil})
			aadd(aCabec,{"CP_EMISSAO" , dDataBase,Nil})
		EndIf
		
		aAdd(aItens,{})
		aadd(aItens[len(aItens)],{"CP_PRODUTO" ,aListB[nX,02],Nil})
		aadd(aItens[len(aItens)],{"CP_QUANT"   ,val(aListB[nX,09]),Nil})
		aadd(aItens[len(aItens)],{"CP_ITEM"    ,Strzero(len(aItens),2),Nil}) 
		aadd(aItens[len(aItens)],{"CP_CC"		,"00000000",Nil}) 
	EndIf
Next nX

If len(aCabec) > 0
	MSExecAuto({|x,y,z| MATA105(x,y,z)},aCabec,aItens,3)
	ConfirmSX8()	
	If !lMsErroAuto
		MsgAlert("Solicita็ใo incluํda com sucesso","TTEST01C")  
		DbSelectArea("SCP")
		DbSetOrder(1)
		Dbseek(xFilial("SCP")+aCabec[1,2])
		A105Imprim("SCP",RECNO(),1)
	Else
		Mostraerro()
		RollbackSX8()
	EndIf
EndIf

oDlg1:end()
	
Return Nil