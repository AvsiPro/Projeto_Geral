#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH' 
#INCLUDE 'TBICONN.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณTTPROC33  ณ Autor ณAlexandre Venancio     ณ Data ณ27/08/2014ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณLocacao   ณ                  ณContato ณ                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ   MAPA DE PATRIMONIOS                                      ณฑฑ
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

User Function TTPROC33()

Local nOpc := GD_INSERT+GD_DELETE+GD_UPDATE 
Local nOpica	:=	0
Private aCoBrw1 := {}
Private aHoBrw1 := {}
Private noBrw1  := 0        
Private aCampos	:=	{"ZH_CHAPA","N1_DESCRIC","ZH_POSICAO","ZH_PRODUTO","B1_DESC","ZH_QUANT"}
Private aAlter	:=	{"ZH_POSICAO","ZH_PRODUTO","ZH_QUANT"}
Private cCliente := '000485'

Prepare Environment EMPRESA "01" FILIAL "01" TABLES "SZH"

SetPrvt("oDlg1","oGrp1","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oGrp2","oBrw1","oBtn1","oBtn2","oBtn3","oBtn4")


oDlg1      := MSDialog():New( 134,262,594,1036,"Mapa de Produtos",,,.F.,,,,,,.T.,,,.T. )
	
	oGrp1      := TGroup():New( 004,036,036,352,"Informa็๕es do Contrato",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay1      := TSay():New( 012,044,{||"Cliente"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,008)
	oSay2      := TSay():New( 012,072,{||"oSay2"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,272,008)
	oSay3      := TSay():New( 024,076,{||"Contrato"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
	oSay4      := TSay():New( 024,112,{||"oSay4"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
	oSay5      := TSay():New( 024,212,{||"Tabela de Pre็o"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
	oSay6      := TSay():New( 024,260,{||"oSay6"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,008)
	
	oGrp2      := TGroup():New( 040,008,196,372,"Configura็๕es",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	MHoBrw1()
	MCoBrw1(cCliente)
	oBrw1      := MsNewGetDados():New(048,012,192,368,nOpc,'AllwaysTrue()','AllwaysTrue()','',aAlter,0,99,'AllwaysTrue()','','AllwaysTrue()',oGrp2,aHoBrw1,aCoBrw1 )

	oBtn3      := TButton():New( 204,020,"+",oDlg1,{||Adiciona()},010,008,,,,.T.,,"",,,,.F. )
	oBtn4      := TButton():New( 204,040,"-",oDlg1,{||Remove()},010,008,,,,.T.,,"",,,,.F. )

	oBtn1      := TButton():New( 204,116,"Salvar",oDlg1,{||oDlg1:end(nOpica:=1)},037,012,,,,.T.,,"",,,,.F. )
	oBtn2      := TButton():New( 204,192,"Sair",oDlg1,{||oDlg1:end(nOpica:=0)},037,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)
 
If nOpica == 1

EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC33  บAutor  ณMicrosiga           บ Data ณ  08/27/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MHoBrw1()


DbSelectArea("SX3")
DbSetOrder(2)
For nX := 1 to len(aCampos)
	If DbSeek(aCampos[nX])
//While !Eof() .and. SX3->X3_ARQUIVO == "SZH"
   //If X3Uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL
   //If Alltrim(SX3->X3_CAMPO) $ cCampos                                
	      noBrw1++
	      Aadd(aHoBrw1,{Trim(X3Titulo()),;
	           SX3->X3_CAMPO,;
	           SX3->X3_PICTURE,;
	           SX3->X3_TAMANHO,;
	           SX3->X3_DECIMAL,;
	           "",;
	           "",;
	           SX3->X3_TIPO,;
	           "",;
	           "" } )
   	EndIf
   //DbSkip()
//End
Next nX

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC33  บAutor  ณMicrosiga           บ Data ณ  08/27/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MCoBrw1(cCliente)

Local aAux := {}
Local cQuery 

cQuery := "SELECT DISTINCT N1_CHAPA,N1_DESCRIC,ZH_CHAPA,ZH_POSICAO,ZH_PRODUTO,B1_DESC,ZH_QUANT,ZH_CLIENTE,ZH_LOJA,A1_NREDUZ"
cQuery += " FROM "+RetSQLName("SN1")+" N1"
cQuery += " LEFT JOIN "+RetSQLName("SZH")+" ZH ON ZH_CLIENTE=N1_XCLIENT AND ZH_LOJA=N1_XLOJA AND ZH.D_E_L_E_T_=''"
cQuery += " LEFT JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=ZH_PRODUTO AND B1.D_E_L_E_T_=''"
cQuery += " LEFT JOIN "+RetSQLName("SA1")+" A1 ON A1_COD=ZH_CLIENTE AND A1_LOJA=ZH_LOJA"
cQuery += " WHERE N1_XCLIENT='"+cCliente+"' AND N1.D_E_L_E_T_=''"
cQuery += " AND N1_PRODUTO IN(SELECT B1_COD FROM "+RetSQLName("SB1")+" B1 WHERE B1_XSECAO='026' AND D_E_L_E_T_='')"

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf         
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
dbSelectArea("TRB")

While !EOF()

	Aadd(aCoBrw1,Array(noBrw1+1))
	For nI := 1 To noBrw1
	   CriaVar(aHoBrw1[nI][2])
	Next
	
	aCoBrw1[LEN(aCoBrw1)][1] := TRB->N1_CHAPA
	aCoBrw1[LEN(aCoBrw1)][2] := Alltrim(TRB->N1_DESCRIC)
	aCoBrw1[LEN(aCoBrw1)][3] := If(!empty(TRB->ZH_POSICAO),TRB->ZH_POSICAO,space(2))
	aCoBrw1[LEN(aCoBrw1)][4] := If(!empty(Alltrim(TRB->ZH_PRODUTO)),Alltrim(TRB->ZH_PRODUTO),space(15))
	aCoBrw1[LEN(aCoBrw1)][5] := If(!empty(Alltrim(TRB->B1_DESC)),Alltrim(TRB->B1_DESC),space(40))
	aCoBrw1[LEN(aCoBrw1)][6] := If(!empty(TRB->ZH_QUANT),TRB->ZH_QUANT,0)
	
	aCoBrw1[LEN(aCoBrw1)][noBrw1+1] := .F.
	Dbskip()
EndDo

Return
        
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC33  บAutor  ณMicrosiga           บ Data ณ  08/27/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Adiciona()

Local aArea	:=	GetArea()  
Local nLinha:=	oBrw1:nAt 

	Aadd(aCoBrw1,Array(noBrw1+1))
	For nI := 1 To noBrw1
	   CriaVar(aHoBrw1[nI][2])
	Next
	aCoBrw1[LEN(aCoBrw1)][1] := aCoBrw1[oBrw1:nAt][1]
	aCoBrw1[LEN(aCoBrw1)][2] := Alltrim(aCoBrw1[oBrw1:nAt][2]) 
	aCoBrw1[LEN(aCoBrw1)][3] := space(2)
	aCoBrw1[LEN(aCoBrw1)][4] := space(15)
	aCoBrw1[LEN(aCoBrw1)][5] := space(40)
	aCoBrw1[LEN(aCoBrw1)][6] := 0
	aCoBrw1[LEN(aCoBrw1)][noBrw1+1] := .F.
	               
	oBrw1:setarray(aCoBrw1)
	oBrw1:refresh()
	oBrw1:nAt := nLinha              
	oBrw1:refresh()
	oDlg1:refresh() 
	
RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC33  บAutor  ณMicrosiga           บ Data ณ  08/27/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Remove() 

Local aArea	:=	GetArea()  
Local nLinha:=	oBrw1:nAt 

ADEL(aCoBrw1,nLinha)
ASIZE(aCoBrw1,Len(aCoBrw1)-1)
oBrw1:setarray(aCoBrw1)
oBrw1:refresh()
oBrw1:nAt := nLinha              
oBrw1:refresh()
oDlg1:refresh() 


RestArea(aAreA)

Return