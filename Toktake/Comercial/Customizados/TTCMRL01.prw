#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TBICONN.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ TTCMRL01 ณ Autor ณ Alexandre Venancio    ณ Data ณ 24/04/15 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณLocacao   ณ                  ณContato ณ                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณRotina responsavel por efetuar a troca de tabela em clientesณฑฑ
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

User Function TTCMRL01
            
Local lCheck 	:= .F.
Private oDlg1,oGrp1,oSay1,oSay2,oSay3,oGrp2,oBrw1,oGrp3,oBrw2,oBtn1,oBtn2,oBtn3,oList1,oList2
Private oGet1,oGet2,oCBox1,oCBox2,oBtn5
Private aList1 := {}
Private aList2 := {}
Private aL2Aux := {} 
Private aL1Bkp := {}
Private oOk   	:= LoadBitmap(GetResources(),'br_verde')       //Controla se o pedido foi alterado ou nao no grid.
Private oNo   	:= LoadBitmap(GetResources(),'br_vermelho')
Private lFiltro	:= .F.  
Private cTabela	:= space(3)
Private aItTab	:= {}
Private dApDia	:= ctod("  /  /  ")
Private aCombo  := {'','Todos','Bebidas','Lanches/Snacks'}
Private xCombo1	:= aCombo[1]

//Prepare Environment Empresa "01" Filial "01" Tables "DA0","DA1" 

PreAcols()

If len(aList1) < 1
	Aadd(aList2,{.F.,'','','','',''})
	Aadd(aList1,{'','','',''})
EndIf

oDlg1      := MSDialog():New( 091,232,542,1130,"Troca de Tabela",,,.F.,,,,,,.T.,,,.T. )

oGrp1      := TGroup():New( 006,008,062,220,"Informa็๕es Gerais",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

	oSay1      := TSay():New( 018,028,{||"Nova Tabela"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oGet1      := TGet():New( 018,064,{|u| If(Pcount()>0,cTabela:=u,cTabela)},oGrp1,060,008,'@!',{||If(!Empty(cTabela) .And. !Empty(dApDia) .And. !Empty(xCombo1),oBtn5:enable(),oBtn5:disable())},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"DA1","",,)
	
	oSay3      := TSay():New( 034,028,{||"A Partir de ?"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oGet2      := TGet():New( 034,064,{|u| If(Pcount()>0,dApDia:=u,dApDia)},oGrp1,060,008,'',{||If(!Empty(cTabela) .And. !Empty(dApDia) .And. !Empty(xCombo1),oBtn5:enable(),oBtn5:disable())},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	
	oSay2      := TSay():New( 018,128,{||"Tipo Servi็o"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oCBox1     := TComboBox():New( 018,160,{|u|If(Pcount()>0,xCombo1:=u,xCombo1)},aCombo,044,010,oGrp1,,{||If(!Empty(cTabela) .And. !Empty(dApDia) .And. !Empty(xCombo1),oBtn5:enable(),oBtn5:disable())},,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
	
	oCBox2     := TCheckBox():New( 053,013,"Inverter Marca็๕es",{|u|If(Pcount()>0,lCheck:=u,lCheck)},oGrp1,058,008,,{||marklist(lCheck)},,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	oBtn5      := TButton():New( 034,160,"Aplicar",oGrp1,{||aplicar()},037,012,,,,.T.,,"",,,,.F. )
	oBtn5:disable()

oGrp2      := TGroup():New( 064,008,192,220,"Clientes",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

	oList1 := TCBrowse():New(072,012,205,115,, {'','Cliente','Loja','Nome'},{10,30,20,50},;
                            oGrp2,,,,{|| Fhelp(oList1:nAt)},{|| editcol1(oList1:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,.F.)

	oList1:SetArray(aList1)
	oList1:bLine := {||{ If(aList1[oList1:nAt,01],oOk,oNo),;
						  aList1[oList1:nAt,02],;
						  aList1[oList1:nAt,03],;
						  aList1[oList1:nAt,04]}}
 

oGrp3      := TGroup():New( 006,224,192,430,"Maquinas no Cliente",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

	oList2 := TCBrowse():New(015,228,199,173,, {'','Patrimonio','Descricao','Prox.Visita','Tabela','Data Alteracao'},{10,30,50,30,30,30},;
                            oGrp3,,,,{|| },{|| /*If(oList1:nAt<6 .And. !lCxFech,editcol1(oList1:nAt),)*/},, ,,,  ,,.F.,,.T.,,.F.,,,.F.)

	oList2:SetArray(aList2)
	oList2:bLine := {||{ If(aList2[oList2:nAt,08],oOk,oNo),;
						  aList2[oList2:nAt,01],;
						  aList2[oList2:nAt,02],;
						  aList2[oList2:nAt,03],;
						  aList2[oList2:nAt,04],;
						  aList2[oList2:nAt,09]}}

oBtn1      := TButton():New( 198,060,"Salvar",oDlg1,{||salvar()},037,012,,,,.T.,,"",,,,.F. )
//oBtn2      := TButton():New( 198,124,"Filtro",oDlg1,{||filtro()},037,012,,,,.T.,,"",,,,.F. )
oBtn3      := TButton():New( 198,252,"Mapa",oDlg1,,037,012,,,,.T.,,"",,,,.F. )
oBtn4      := TButton():New( 198,324,"Sair",oDlg1,{||oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

Return                                                           

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCMRL01  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PreAcols()

Local aArea	:=	GetArea()
Local cQuery
Local nPosDia := 8     
Local nPosAux := 0   
Local cPrxVis := ''
nPosDia += Day(dDataBase+1)

cQuery := "SELECT DISTINCT ZE_FILIAL,ZE_CLIENTE,ZE_LOJA,A1_NREDUZ,ZE_CHAPA,N1_DESCRIC,N1_XTABELA,ZE_MENSAL,ZE_TABELA,B1_XFAMILI,ZE.R_E_C_N_O_ AS REGISTRO"
cQuery += " FROM "+RetSQLName("SZE")+" ZE"
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=ZE_CLIENTE AND A1_LOJA=ZE_LOJA AND A1.D_E_L_E_T_=''"
cQuery += " INNER JOIN "+RetSQLName("SN1")+" N1 ON N1_FILIAL='"+xFilial("SN1")+"' AND N1_CHAPA=ZE_CHAPA AND N1.D_E_L_E_T_='' AND N1_DESCRIC NOT LIKE 'RECARGA%'"   
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=N1_PRODUTO AND B1.D_E_L_E_T_=''"
cQuery += " WHERE ZE_FILIAL='"+xFilial("SZE")+"' AND ZE.D_E_L_E_T_='' AND ZE_MENSAL LIKE '"+substr(cvaltochar(dtos(dDataBase)),1,6)+"%' ORDER BY 1,2"

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTCMRL01.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")

While !EOF()
    If Ascan(aList1,{|x| x[2]+x[3] == TRB->ZE_CLIENTE+TRB->ZE_LOJA}) == 0
    	Aadd(aList1,{.F.,TRB->ZE_CLIENTE,TRB->ZE_LOJA,Alltrim(TRB->A1_NREDUZ),TRB->ZE_FILIAL}) 
    	Aadd(aL1Bkp,{.F.,TRB->ZE_CLIENTE,TRB->ZE_LOJA,Alltrim(TRB->A1_NREDUZ),TRB->ZE_FILIAL})
    EndIf
                                                       
    cPrxVis := ''
    CAUX := SUBSTR(TRB->ZE_MENSAL,nPosDia)
    nPosAux := at(If(!Empty(TRB->ZE_TABELA),"T","1"),CAUX)
    If nPosAux > 0
    	cAuxv := substr(dtos(dDatabase),1,6)+cvaltochar(nPosDia+nPosAux-9)
    	cPrxVis := cvaltochar(stod(cAuxv))
    EndIf
    
    If Ascan(aL2Aux,{|x| x[1] == TRB->ZE_CHAPA}) > 0
    	If !Empty(cPrxVis)
	    	If ctod(aL2Aux[Ascan(aL2Aux,{|x| x[1] == TRB->ZE_CHAPA}),03]) > ctod(cPrxVis) .Or. Empty(ctod(aL2Aux[Ascan(aL2Aux,{|x| x[1] == TRB->ZE_CHAPA}),03]))
	        	aL2Aux[Ascan(aL2Aux,{|x| x[1] == TRB->ZE_CHAPA}),03] := cPrxVis
	        	aL2Aux[Ascan(aL2Aux,{|x| x[1] == TRB->ZE_CHAPA}),10] := TRB->REGISTRO
	     	EndIf
	    EndIf
    Else
	    Aadd(aL2Aux,{TRB->ZE_CHAPA,TRB->N1_DESCRIC,cPrxVis,If(!Empty(TRB->ZE_TABELA),TRB->ZE_TABELA,TRB->N1_XTABELA),;
	    				TRB->ZE_CLIENTE,TRB->ZE_LOJA,TRB->B1_XFAMILI,.F.,'',TRB->REGISTRO,TRB->ZE_MENSAL})
	EndIf
	Dbskip()
EndDo


RestArea(aArea)

Return                 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCMRL01  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Fhelp(nLinha)

Local aArea	:=	GetArea()
Local aAux  :=  {}
Local aBkL2 := 	aclone(aList2)   

aList2 := {}

For nX := 1 to len(aL2Aux)
	If aL2Aux[nX,05]+aL2Aux[nX,06] == aList1[nLinha,02]+aList1[nLinha,03]
		Aadd(aAux,aL2Aux[nX])
	EndIf
Next nX
         
If len(aAux) > 0
	aList2 := aClone(aAux)
Else
	Aadd(aList2,{'','','','',''})
EndIf
 
oList2:SetArray(aList2)
oList2:bLine := {||{ If(aList2[oList2:nAt,08],oOk,oNo),;
					  aList2[oList2:nAt,01],;
					  aList2[oList2:nAt,02],;
					  aList2[oList2:nAt,03],;
					  aList2[oList2:nAt,04],;
					  aList2[oList2:nAt,09]}} 
oList1:refresh()
oList2:refresh()
oDlg1:refresh()

RestArea(aArea)

Return        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCMRL01  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Filtro()

Local aPergs	:= {} 
Local aRet		:= {}
Local aTipo		:= {'Todas','Bebidas','Lanches/Snacks'}
Local aAux1		:= aclone(aList1)
Local aAux2		:= aclone(aList2)
            
aAdd(aPergs ,{1,"Cliente"	,space(TamSx3("A1_COD")[1]),"@!",".T.","SA1",".T.",50,.F.})
aAdd(aPergs ,{1,"Tabela"	,space(TamSx3("DA0_CODTAB")[1]),"@!",".T.","DA0",".T.",50,.F.})
aAdd(aPergs ,{2,"Tipo de Maquina"		,aTipo[1],aTipo,50,"",.F.})												
  

	//aL1Bkp
	//aL2Aux 
If ParamBox(aPergs ,"Filtrar por?",@aRet)
	aList1 := {}
	aList2 := {}
	
	If !Empty(aRet[1])
		
		If !Empty(aRet[2])
		
			If aRet[3] == 1
			
			ElseIf aRet[3] == 2
			
			Else
			
			EndIf
		EndIf
	ElseIf !Empty(aRet[2])
		If aRet[3] == 1
				
		ElseIf aRet[3] == 2
				
		Else
				
		EndIf
	Else
		If substr(aRet[3],1,1) == "T"
			aList2 := aclone(aL2Aux)
		ElseIf substr(aRet[3],1,1) == "B"
			For nX := 1 to len(aL2Aux)
				If Alltrim(aL2Aux[nX,07]) $ "144/153"
					Aadd(aList2,aL2Aux[nX])
				EndIf
			Next nX
		Else
			For nX := 1 to len(aL2Aux)
				If !Alltrim(aL2Aux[nX,07]) $ "144/153"
					Aadd(aList2,aL2Aux[nX])
				EndIf
			Next nX
		EndIf
	EndIf   
    
    If len(aList2) > 0
    	lFiltro := .T.
    	For nX := 1 to len(aList2)
    		If Ascan(aL1Bkp,{|x| x[2]+x[3] == aList2[nX,05]+aList2[nX,06]}) > 0                
    			//So incluir uma vez no array
    			If Ascan(aList1,{|x| x[2]+x[3] == aList2[nX,05]+aList2[nX,06]}) == 0
	    			Aadd(aList1,aL1Bkp[Ascan(aL1Bkp,{|x| x[2]+x[3] == aList2[nX,05]+aList2[nX,06]})])
	    		EndIf
	    	EndIf
    	Next nX
    Else
    	aList1 := aclone(aAux1)
    	aList2 := aclone(aAux2)
    	lFiltro := .F.
    EndIf
    
	oList1:SetArray(aList1)
	oList1:bLine := {||{ If(aList1[oList1:nAt,01],oOk,oNo),;
						  aList1[oList1:nAt,02],;
						  aList1[oList1:nAt,03],;
						  aList1[oList1:nAt,04]}}
						  
	oList2:SetArray(aList2)
	oList2:bLine := {||{ If(aList2[oList2:nAt,08],oOk,oNo),;
						  aList2[oList2:nAt,01],;
						  aList2[oList2:nAt,02],;
						  aList2[oList2:nAt,03],;
						  aList2[oList2:nAt,04],;
						  aList2[oList2:nAt,09]}} 
	
	oList1:refresh()
	oList2:refresh()
	oDlg1:refresh()
	
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCMRL01  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function marklist(lCheck)     

Local aArea	:=	GetArea()

For nX := 1 to len(aList1)
	If aList1[nX,01]
		aList1[nX,01] := .F.
	else
		aList1[nX,01] := .T.
	EndIf
Next nX
         
oList1:refresh()
oDlg1:refresh()

RestArea(aArea)

Return    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCMRL01  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function editcol1(nLinha)

Local aArea	:=	GetArea()

If aList1[nLinha,01]
	aList1[nLinha,01] := .F.
Else
	aList1[nLinha,01] := .T.
EndIf

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCMRL01  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function aplicar()

Local aArea		:=	GetArea() 
Local lAchou    :=	.F.
Local aAux1		:=	aClone(aList1)
Local aAux2		:=	aClone(aList2)
Local nPosD		:=	0
Local cAux		:=	''
Local nPosP		:=	0

aItTab := ItensTab()

If len(aItTab) == 0
	RestArea(aArea)
	Return
EndIf

For nX := 1 to len(aList1)
	If aList1[nX,01]
		lAchou := .T.
		For nY := 1 to len(aList2)
			If aList2[nY,05]+aList2[nY,06] == aList1[nX,02]+aList1[nX,03]
			 	If !ItensPatr(aItTab,aList2[nY,01])	
			 		aList1 := aClone(aAux1)
			 		aList2 := aClone(aAux2)
			 		//mensagem de erro
			 		Return            
			 	Else
			 		aList2[nY,04] := cTabela
			 		nPosD := day(dApDia)+8
			 		cAux  := substr(aList2[nY,11],nPosD)
			 		nPosP := at("1",cAux)
			 		aList2[nY,09] := If(dApDia + nPosP - 1 > ctod(aList2[nY,03]),dApDia + nPosP - 1,ctod(aList2[nY,03]))
			 		aList2[nY,11] := substr(aList2[nY,11],1,(day(aList2[nY,09])-1)+8)+"T"+substr(aList2[nY,11],day(aList2[nY,09])+1+8)
			 		aList2[nY,08] := .T.
			 	EndIf
			 	
			EndIf
		Next nY
	EndIf
Next nX

RestArea(aArea)

Return    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCMRL01  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ItensTab()

Local aArea		:=	GetArea()
Local cQuery    :=	""                                                             
Local aRetorno	:=	{}

cQuery := "SELECT DA1_CODPRO FROM "+RetSQLName("DA1")+" WHERE DA1_CODTAB='"+cTabela+"' AND D_E_L_E_T_=''"

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTCMRL01.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")

While !EOF()
    Aadd(aRetorno,TRB->DA1_CODPRO)
	DbSkip()
EndDo

RestArea(aArea)

Return(aRetorno) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCMRL01  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ItensPatr(aItTab,cPatr)

Local aArea	:=	GetArea()
Local cQuery 
Local lRet	:=	.T.

cQuery := "SELECT N1_CHAPA"   
For nXPT := 1 to 60 // 60 CRIAR CAMPOS
	cQuery += " ,N1_XP"+cvaltochar(nXPT)+" AS N"+cvaltochar(nXPT)
Next nXPT
cQuery += " FROM "+RetSQLName("SN1")+" N1"
cQuery += " WHERE N1.D_E_L_E_T_='' AND N1_CHAPA='"+cPatr+"' AND N1_XTABELA='"+cTabela+"'"

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("OM010TOK.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")

While !EOF()
    For nXPT := 1 to 60 // 60 criar os campos na SN1	
    	If !Empty(&("TRB->N"+cvaltochar(nXPT)))
    		If ASCAN(aItTab,{|X| alltrim(X) == alltrim(&("TRB->N"+cvaltochar(nXPT)))}) == 0
	    		MsgAlert("O produto "+Alltrim(&("TRB->N"+cvaltochar(nXPT)))+" consta no Patrim๔nio "+TRB->N1_CHAPA+" amarrado a esta tabela e o mesmo nใo consta na tabela, favor verificar!!!","TTCMRL01")
	    		Return(.F.)	
	    	EndIf
	    EndIf
	Next nXPT
	Dbskip()
EndDo 

RestArea(aArea)

Return(lRet)
      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCMRL01  บAutor  ณMicrosiga           บ Data ณ  04/28/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function salvar()

Local aArea	:=	GetArea()



For nX := 1 to len(aList1)
	If aList1[nX,01]
		
		For nY := 1 to len(aList2)
			If aList2[nY,05]+aList2[nY,06] == aList1[nX,02]+aList1[nX,03]
				If aList2[nY,08]
					Dbselectarea("SZE")
					Dbgoto(aList2[nY,10])
					Reclock("SZE",.F.)
					SZE->ZE_TABELA :=	aList2[nY,04]
					SZE->ZE_MENSAL :=	aList2[nY,11]
					SZE->(Msunlock())
				EndIf
			EndIf
		Next nY
	EndIf
Next nX
  
oDlg1:end()

U_TTCMRL01()

RestArea(aArea)

Return