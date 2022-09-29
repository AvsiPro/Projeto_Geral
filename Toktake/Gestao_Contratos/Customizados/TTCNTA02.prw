#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCNT200MNU บAutor  ณMicrosiga           บ Data ณ  08/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  TELA que exibe os patrimonios existentes no cliente para  บฑฑ
ฑฑบ          ณamarracao com o contrato.                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTCNTA02()

Local aArea	:=	GetArea()      
Local cQuery
Local oGrp1,oBtn1,oBtn2,oBtn3
Local cCliente	:=	"" 
Local nOpc	:=	0
Local aAux	:=	{}   
Local aPergs	:=	{}
Local aCont	:=	{"Novo","Atual"}
Local aRet	:=	{}
Local cCont	:=	""

Private cTpCont := ""
Private oList
Private aPatrim	:=	{}
Private oDlg1,oSay1
Private oOk   	:= LoadBitmap(GetResources(),'br_verde')       //Controla se o pedido foi alterado ou nao no grid.
Private oNo   	:= LoadBitmap(GetResources(),'br_vermelho')  

If cEmpAnt <> "01"
	Return
EndIf

/*
aAdd(aPergs ,{2,"Novo Contrato",aCont[1], aCont,100,".T.",.F.})										//[5]

If !ParamBox(aPergs ,"Detalhes",@aRet)
	RestArea(aArea)
	Return         
EndIf

If aRet[1] == "Novo"
	aAdd(aPergs ,{1,"Contrato",space(TamSx3("CNA_CONTRA")[1]),"@!",".T.","CN9",".T.",100,.F.})			//[8] 
	If !ParamBox(aPergs ,"Detalhes",@aRet) 
	Else
		cCont := aRet[2]
	EndIf
EndIf
*/

If !ConPad1(,,,"CN9",,,.F.)
	Return
Else
	cCont	:= CNA->CNA_CONTRA 
	cPlanilha	:= CNA->CNA_NUMERO
	cpCliente	:= CNA->CNA_CLIENT
	cpLoja		:= CNA->CNA_LOJACL
EndIf  

dbSelectArea("CN9")
dbSetOrder(1)
If !MsSeek( xFilial("CN9") +AvKey(cCont,"CN9_NUMERO") )
	Return
EndIf


cQuery := "SELECT N1_CHAPA,N1_PRODUTO,B1_DESC,N1_XLOCINS,A1_NREDUZ,CN9_DTINIC,CN9_UNVIGE,CN9_VIGE,ZD_DATAINS,UD_XVLALUG,A1_LOJA"
cQuery += " FROM "+RetSQLName("SN1")+" N1"
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_COD=N1_XCLIENT AND A1_LOJA=N1_XLOJA AND A1.D_E_L_E_T_=''"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=N1_PRODUTO AND B1.D_E_L_E_T_=''" 
cQuery += " LEFT JOIN "+RetSQLName("SZD")+" ZD ON ZD_CLIENTE=N1_XCLIENT AND ZD_LOJA=N1_XLOJA AND ZD_IDSTATU='1' AND ZD_PATRIMO=N1_CHAPA AND ZD.D_E_L_E_T_=''"

// --> Adicionado por Jackson E. de Deus
cQuery += " LEFT JOIN "+RetSQLName("SUD")+" SUD ON SUD.UD_XNPATRI = N1.N1_CHAPA AND SUD.UD_PRODUTO = N1.N1_PRODUTO AND SUD.D_E_L_E_T_ = ''
cQuery += " LEFT JOIN "+RetSQLName("SUC")+" SUC ON SUBSTRING(SUC.UC_CHAVE,1,6) = N1.N1_XCLIENT AND SUBSTRING(SUC.UC_CHAVE,7,4) = N1.N1_XLOJA AND SUC.D_E_L_E_T_ = ''
// <--
/*
If aRet[1] == "Novo"

	cCli := CN9->CN9_CLIENT //POSICIONE("CN9",1,xFilial("CN9")+cCont,"CN9_CLIENT")
	cQuery += " LEFT JOIN "+RetSQLName("CN9")+" CN9 ON CN9_NUMERO='"+cCont+"' AND CN9.D_E_L_E_T_=''" 
	cQuery += " WHERE N1_XCLIENT='"+cCli+"' AND N1.D_E_L_E_T_=''" 

	If CN9->CN9_XTPFAT != '1'
		cLoj := CN9->CN9_LOJACL //POSICIONE("CN9",1,xFilial("CN9")+cCont,"CN9_LOJACL")
		cQuery += "	AND N1_XLOJA='"+cLoj+"'"
	EndIf
	
Else*/
	cQuery += " LEFT JOIN "+RetSQLName("CN9")+" CN9 ON CN9_NUMERO='"+cCont+"' AND CN9.D_E_L_E_T_=''"
	cQuery += " WHERE N1_XCLIENT='"+cpCliente+"' AND N1.D_E_L_E_T_=''" 
	
	If CN9->CN9_XTPFAT != '1'
		cQuery += " AND N1_XLOJA='"+cpLoja+"'"
	EndIf
//EndIf

//cQuery += " AND N1_CHAPA NOT IN(SELECT ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), CNB_XPATRI)),'') AS CNB_XPATRI FROM "+RetSQLName("CNB")+" WHERE D_E_L_E_T_='')"
cQuery += " AND N1_CHAPA NOT IN( SELECT ZQ_PATRIM FROM "+RetSQLName("SZQ")+" WHERE ZQ_CONTRA = '"+cCont+"' AND ZQ_PLAN = '"+cPlanilha+"' AND ZQ_DATAREM = '' AND  D_E_L_E_T_='')"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("TTCNTA02.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
	If Ascan(aPatrim,{|x| Alltrim(x[2]) == Alltrim(TRB->N1_CHAPA)}) == 0    
		Aadd(aPatrim,{.F.,TRB->N1_CHAPA,TRB->N1_PRODUTO,Alltrim(TRB->B1_DESC),Alltrim(TRB->N1_XLOCINS),stod(TRB->CN9_DTINIC),STOD(TRB->ZD_DATAINS),TRB->CN9_VIGE,TRB->CN9_UNVIGE,TRB->UD_XVLALUG,0,"Loja "+TRB->A1_LOJA+" - "+TRB->A1_NREDUZ})
		cCliente := AllTrim(TRB->A1_NREDUZ)
	ENDiF
	Dbskip()
EndDo 

// verifica existencia do campo customizado [tipo de contrato] - Jackson E. de Deus
dbSelectArea("CN9")                          
If FieldPos("CN9_XTPCNT") > 0
	cTpCont := CN9->CN9_XTPCNT
Else
	Aviso("TTCNTA02","O campo CN9_XTPCNT nใo existe na base de dados." +CRLF +"O campo ้ necessแrio para defini็ใo do tipo do contrato.",{"Ok"})	   
EndIf


If len(aPatrim) > 0
	
	oDlg1      := MSDialog():New( 091,232,454,965,cCliente,,,.F.,,,,,,.T.,,,.T. )
	
		oGrp1      := TGroup():New( 008,008,152,362,"Patrimonios",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )  
		
		oSay1      := TSay():New( 014,120,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,190,008)
		
		oList := TCBrowse():New(025,015,340,125,, {'','Patrimonio','Produto','Descricao','Local Fisico','Data inicial','Data Instal.','Periodo','Valor Locacao','Selecao'},{5,20,30,30,30,25,25,20,20,5},;
		                            oGrp1,,,,{|| Fhelp(oList:nAt)},{|| editcol(oList:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,)
		oList:SetArray(aPatrim)
		oList:bLine := {||{ If(aPatrim[oList:nAt,01],oOk,oNo),; 
		 					 aPatrim[oList:nAt,02],;
		 					 aPatrim[oList:nAt,03],;
		                     aPatrim[oList:nAt,04],;
		                     aPatrim[oList:nAt,05],;
		                     aPatrim[oList:nAt,06],;
		                     aPatrim[oList:nAt,07],;
		                     aPatrim[oList:nAt,08],;
		                     Transform(aPatrim[oList:nAt,10],"@E 999,999,999.99"),;
		                     aPatrim[oList:nAt,11]}} //10 selecao 
	
		oBtn1      := TButton():New( 161,150,"Confirmar",oDlg1,{||oDlg1:end(nOpc:=1)},037,012,,,,.T.,,"",,,,.F. )
		oBtn2      := TButton():New( 161,196,"Sair",oDlg1,{||oDlg1:end(nOpc:=0)},037,012,,,,.T.,,"",,,,.F. )
		
		If len(aPatrim) > 10
			oBtn3      := TButton():New( 161,100,"Carregar R$",oDlg1,{||Processa({||Carregar()},"Aguarde")},037,012,,,,.T.,,"",,,,.F. )
		EndIf
		
	oDlg1:Activate(,,,.T.)
	
	If nOpc == 1

		For nX := 1 to len(aPatrim)
			If aPatrim[nX,01]
				Aadd(aAux,aPatrim[nX])
			EndIf	
		Next nX          

		If len(aAux) > 0
			U_TTCNTA01(If(Empty(cCont),CNA->CNA_CONTRA,cCont),If(Empty(cCont),CNA->CNA_REVISA,space(3)),aAux)
		EndIf
	EndIf
EndIf
	    
If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

RestArea(aArea)

Return   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCNT200MNU บAutor  ณMicrosiga           บ Data ณ  08/06/13   บฑฑ
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

Local cBkp	:=	aPatrim[nLinha,09]
Local cBkp2	:=	aPatrim[nLinha,10]

aPatrim[nLinha,09] := aPatrim[nLinha,10]

lEditcell(aPatrim,oList,"@E 999,999,999.99",09)

aPatrim[nLinha,10] := aPatrim[nLinha,09]
aPatrim[nLinha,09] := cBkp

If cTpCont == "3"
	cBkp := aPatrim[nLinha,10]		
	aPatrim[nLinha,10] := aPatrim[nLinha,11]  
	lEditcell(aPatrim,oList,"@R 999",10)
	aPatrim[nLinha,11]  := aPatrim[nLinha,10]  
	aPatrim[nLinha,10]  := cBkp
EndIf

If aPatrim[nLinha,10] > 0
	aPatrim[nLinha,01] := .T.
Else	
	aPatrim[nLinha,01] := .F.
EndIf
                
oList:refresh()
oDlg1:refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCNT200MNU บAutor  ณMicrosiga           บ Data ณ  08/30/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Fhelp(nlin)

Local aArea	:=	GetArea()

oSay1:setText("")

oSay1:setText(aPatrim[nlin,12])

oDlg1:refresh()

RestArea(aArea)

Return                                        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCNT200MNU บAutor  ณMicrosiga           บ Data ณ  09/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Carregar()

Local aArea	:=	GetArea()
Local cArqTxt := "C:\Locacao.csv"
Local nHandle := FT_FUse(cArqTxt) 
Local nX	:=	0

If nHandle < 1
	MsgAlert("Arquivo nใo encontrado no diretorio","CNT200MNU - c:\Locacao.csv")
	Return
EndIf
ProcRegua(0)
While !FT_FEOF() 
	cLine	:= FT_FReadLn() // Retorna a linha corrente  
	aAux    := StrTokArr(cLine,";") 
	If nX > 0
		IncProc()
		aAux[2] := val(strtran(aAux[2],",","."))
		If Ascan(aPatrim,{|x| Alltrim(x[2]) == Alltrim(aAux[1])}) > 0 
			aPatrim[Ascan(aPatrim,{|x| Alltrim(x[2]) == Alltrim(aAux[1])}),10] := aAux[2]
			aPatrim[Ascan(aPatrim,{|x| Alltrim(x[2]) == Alltrim(aAux[1])}),01] := .T.
		EndIf
	EndIf
	nX++
	FT_FSKIP()
End
                                                 
FT_FUSE()

oList:refresh()
oDlg1:refresh()

RestArea(aArea)

Return