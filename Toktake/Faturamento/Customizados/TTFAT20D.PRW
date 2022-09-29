#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'  
#INCLUDE 'TBICONN.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ TTFAT20D ณ Autor ณ Alexandre Venancio    ณ Data ณ 07/05/14 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณLocacao   ณ Faturamento      ณContato ณ Marcelo Melao                  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Rotina Delivery                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ Data De/Ate                                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAplicacao ณ Manutencao dos pedidos a serem faturados no periodo.       ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAlexandre     ณ07/05/14ณ01.01 |Criacao                                 ณฑฑ
ฑฑณ              ณ  /  /  ณ      |                                        ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function TTFAT20D(dDatD,dDatA)

Local aArea		:=	GetArea()
Local aPergs	:= 	{} 
Local aRet		:= 	{}
Local dDataIni	:=	ctod("  /  /  ")
Local dDataFim	:=	ctod("  /  /  ")
Local oFont		:= TFont():New('Arial',,-12,.T.,.T.)
Local lContinua := .T.
Private oList1
Private aList1   :=	{}
Private aListB1	 := {}
Private oList2
Private aList2   :=	{}
Private aListB2  := {}  
Private oOk   	:= LoadBitmap(GetResources(),'br_verde')       // a liberar - Controla se o pedido foi alterado ou nao no grid.
Private oNo   	:= LoadBitmap(GetResources(),'br_vermelho')		// alterado
Private oPl		:= LoadBitmap(GetResources(),'br_amarelo')		// totalmente atendido 
Private oPr		:= LoadBitmap(GetResources(),'br_azul')			// parcial 
Private lTrava1	:=	.F.
Private lTrava2	:=	.F.

SetPrvt("oDlg1","oGrp1","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oGrp2","oBrw1","oGrp3","oBrw2")
SetPrvt("oSay9","oSay10","oSay7","oSay8","oGrp4","oBtn1","oBtn2","oBtn3","oBtn4","oBtn5","oBtn6","oBtn7","oBtn8","oBtn9","oSay11")

If cEmpAnt <> "01"
	Return
EndIf

//Prepare Environment Empresa "01" Filial "01" Tables "SC9/SB1/SC5/SX2" 

aAdd(aPergs ,{1,"Data De:",dDataIni,"99/99/99","","","",50,.F.})
aAdd(aPergs ,{1,"Data At้:",dDataFim,"99/99/99","","","",50,.F.})	
If !ParamBox(aPergs ,"Filtro - Data de entrega",@aRet)
	Return
EndIf

dDataIni := aRet[1]
dDataFim := aRet[2]

If Empty(dtos(dDataIni))
	dDataIni := dDatabase
EndIf
If Empty(dtos(dDataFim))
	dDataFim := dDatabase
EndIf

Processa({ || Carregar(@lContinua,dDataIni,dDataFim)   },"Verificando pedidos, aguarde..")

If !lContinua
	Aviso("TTFAT20D","Nใo foram encontrados pedidos em aberto para o perํodo selecionado.",{"Ok"})
	Return
EndIf


oDlg1      := MSDialog():New( 091,232,586,1045,"Delivery " +Dtoc(dDataIni) +" - " +Dtoc(dDataFim),,,.F.,,,,,,.T.,,,.T. )

	oGrp1      := TGroup():New( 004,004,056,396,"Informa็๕es Gerais",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		oSay1      := TSay():New( 016,012,{||"Cliente"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,008)
		oSay2      := TSay():New( 016,036,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,348,008)			// codigo-loja / nome
		oSay3      := TSay():New( 030,012,{||"Estoque"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,008)
		oSay4      := TSay():New( 030,036,{||""},oGrp1,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,042,010)			// armazem C6_LOCAL
		oSay5      := TSay():New( 044,012,{||"Tipo Fat."},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,030,008)
		oSay6      := TSay():New( 044,036,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,042,008)			// parcial / total
	    oSay11     := TSay():New( 044,220,{|| ""},oGrp1,,,.F.,.F.,.F.,.T., ,,150,008,,,,,,.T.) 
	    
	oGrp2      := TGroup():New( 056,004,148,120,"Pedidos",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oList1 := TCBrowse():New(064,008,109,080,, {'Status','Pedido','Entrega'},{15,30,30},;
	                            oGrp2,,,,{|| FHelp(oList1:nAt,oList2:nAt) },{|| /*editcol*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
	oList1:SetArray(aList1)
	oList1:bLine := {||{ aList1[oList1:nAt,01],; 
	 					 aList1[oList1:nAt,02],;
	 					 aList1[oList1:nAt,03]}}

	oGrp3      := TGroup():New( 056,124,148,396,"Itens",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oList2 := TCBrowse():New(064,128,265,080,, {'Pedido','Item','Produto','Descricใo','Qtd Ped','Qtd Lib','Saldo','OPดs'},{30,15,30,45,20,20,20,20},;
	                            oGrp3,,,,{|| FHelp1(oList2:nAt,oList1:nAt) },{|| /*editcol2()*/ },, ,,,  ,,.F.,,.T.,,.F.,,,)
	oList2:SetArray(aList2)
	oList2:bLine := {||{aList2[oList2:nAt,01],; 
	 					 aList2[oList2:nAt,02],;
	 					 aList2[oList2:nAt,03],;
	 					 aList2[oList2:nAt,04],;                               
	 					 aList2[oList2:nAt,05],;
	 					 aList2[oList2:nAt,06],;
	 					 aList2[oList2:nAt,07],;
	 					 aList2[oList2:nAt,08]}}
	
	oFld1      := TFolder():New( 152,004,{"Filtro"},{},oDlg1,,,,.T.,.F.,230,076,)  
		
	oFld2      := TFolder():New( 152,236,{"A็๕es","Consulta"},{},oDlg1,,,,.T.,.F.,160,076,) 
		oBtn1      := TButton():New( 008,010,"Trava Pedido",oFld2:aDialogs[1],{ || TravaPed(oList1:nAt), FHelp1(oList2:nAt,oList1:nAt) },037,012,,,,.T.,,"",,,,.F. )
		oBtn2      := TButton():New( 008,062,"Trava Produto",oFld2:aDialogs[1],{ ||TravaItem(oList2:nAt), FHelp1(oList2:nAt,oList1:nAt) },037,012,,,,.T.,,"",,,,.F. )
		oBtn3      := TButton():New( 008,110,"Reserva",oFld2:aDialogs[1],{ || AltResrv(oList1:nAt,oList2:nAt) },037,012,,,,.T.,,"",,,,.F. )							// gerenciar reservas
		oBtn4      := TButton():New( 036,010,"Liberar estoque",oFld2:aDialogs[1],{ || LibEst(oList1:nAt,oList2:nAt) },037,012,,,,.T.,,"",,,,.F. )							// liberar estoque
		oBtn5      := TButton():New( 036,062,"Tipo Fat.",oFld2:aDialogs[1],{ || AltTpFat(oList1:nAt) },037,012,,,,.T.,,"",,,,.F. )									// alterar tipo de faturamento
		oBtn6      := TButton():New( 036,110,"Sair",oFld2:aDialogs[1],{||oDlg1:end(nOpc:=0)},037,012,,,,.T.,,"",,,,.F. )
	    
	   	oBtn7      := TButton():New( 008,010,"Ver Pedido",oFld2:aDialogs[2],{ || VerPedido( oList1:nAt ) },037,012,,,,.T.,,"",,,,.F. )
		oBtn8      := TButton():New( 008,062,"Ver Saldo",oFld2:aDialogs[2],{ || VerSaldo(oList1:nAt,oList2:nAt)  },037,012,,,,.T.,,"",,,,.F. )
		oBtn9      := TButton():New( 008,110,"Ver Reserva",oFld2:aDialogs[2],{ || VerRsrva( oList2:nAt )  },037,012,,,,.T.,,"",,,,.F. )					 
		oBtn10     := TButton():New( 036,110,"Sair",oFld2:aDialogs[2],{||oDlg1:end(nOpc:=0)},037,012,,,,.T.,,"",,,,.F. )    

		oBtn3:Disable()	// botao reserva
	
oDlg1:Activate(,,,.T.)

RestArea(aArea)

Return     


// 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCarregar  บAutor  ณJackson E. de Deus  บ Data ณ  15/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCarrega os dados dos pedidos de venda                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Carregar(lContinua,dDataIni,dDataFim)

ProcRegua(0)
IncProc("")
aList1 := PreAcols1(dtos(dDataIni),dtos(dDataFim))
If Len(aList1) == 0
	lContinua := .F.
Else      
	IncProc("")
	aList2 := PreAcols2(dtos(dDataIni),dtos(dDataFim))
EndIf                                               

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFHelp  บAutor  ณMicrosiga           บ Data ณ  05/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Help das linhas                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FHelp(nLinha,nLinha2)

Local aArea	:=	GetArea()
Local nPos2	:=	If(aList2[nLinha2,01]==aList1[nLinha,02],nLinha2,Ascan(aList2,{|x| x[1] == aList1[nLinha,02]}))
Local cTextHtml := ""
Local aAux := {}
Local nI := 0

oList2:GoPosition(nPos2)

oSay2:setText("")	// Altera Texto Cliente/Loja/Razao Social/Nome fantasia
oSay2:setText(aList1[nLinha,05] +"-" +aList1[nLinha,06] +" / " +aList1[nLinha,07] +space(20) +aList1[nLinha,08])

oSay4:setText("")	// Altera texto local armazem
oSay4:setText(aList2[nLinha2,09])

oSay6:setText("")	// Altera texto Tipo faturamento
oSay6:setText( IF(aList1[nLinha,09]=="1","Parcial","Total") )

oSay11:setText("")
If nPos2 > 0
	oSay11:setText( TxtStatus(aList2[nPos2,10]) )
EndIf
//oSay11:SetText("Status Reserva - "+aList2[nPos2,10] )
oSay11:CtrlRefresh() 

oList2:refresh()
oList1:refresh()
oDlg1:refresh()

RestArea(aArea)

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFHelp1 บAutor  ณMicrosiga           บ Data ณ  05/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณalexandre venancio - assinar funcao                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FHelp1(nLinha,nLinha1)

Local aArea	:=	GetArea()
Local nPos1	:=	Ascan(aList1,{|x| x[2] == aList2[nLinha,01]})
                  
oList1:GoPosition(nPos1)

//oSay11:setText("")
//oSay11:SetText("Status Reserva - "+aList2[nLinha,10])  
oSay11:setText("")  
oSay11:setText( TxtStatus(aList2[nLinha,10]) )
oSay11:CtrlRefresh() 

oList2:refresh()
oList1:refresh()
oDlg1:refresh()

RestArea(aArea)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT20D  บAutor  ณMicrosiga           บ Data ณ  05/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Preenche o primeiro array com os cabecalhos dos pedidos   บฑฑ
ฑฑบ          ณa serem faturados no periodo informado.                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PreAcols1(dDat1,dDat2)

Local aArea	:=	GetArea()
Local cQuery 
Local aRet	:=	{}

cQuery := "SELECT C5_LIBEROK,C5_TIPLIB,C5_NUM,C5_XDTENTR, C5.R_E_C_N_O_ C5REC, C5_CLIENT, C5_LOJAENT, A1_NOME, A1_NREDUZ FROM "+RetSQLName("SC5") + " C5 "
cQuery += " INNER JOIN " +RetSqlName("SA1") +" A1 ON A1_COD = C5_CLIENT AND A1_LOJA = C5_LOJAENT "
cQuery += " WHERE C5_XDTENTR BETWEEN '"+dDat1+"' AND '"+dDat2+"' AND C5_FILIAL='"+xFilial("SC5")+"'"
cQuery += " AND C5_NUM IN(SELECT C6_NUM FROM "+RetSQLName("SC6")+" WHERE C6_FILIAL='"+xFilial("SC6")+"'"
cQuery += " AND C6_ENTREG BETWEEN '"+dDat1+"' AND '"+dDat2+"' AND C6_QTDVEN>C6_QTDENT AND D_E_L_E_T_='')"
cQuery += " AND C5.D_E_L_E_T_='' ORDER BY C5_NUM "

If Select("TRB") > 0
	dbSelectArea("TRB")
	DbCloseArea()
EndIf

MemoWrite("TTFAT20D.SQL",cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB")

While !EOF() 
    Aadd(aRet, { IF(TRB->C5_LIBEROK=="S",oPl,oOk),TRB->C5_NUM,Cvaltochar(STOD(TRB->C5_XDTENTR)), TRB->C5REC, TRB->C5_CLIENT, TRB->C5_LOJAENT, AllTrim(TRB->A1_NOME), AllTrim(TRB->A1_NREDUZ), ALLTRIM(TRB->C5_TIPLIB) })
    //						1							2						3						4				5				6				7				8							9
	Dbskip()
EndDo

aListB1 := aClone(aRet)

RestArea(aArea)

Return(aRet)                   


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT20D  บAutor  ณMicrosiga           บ Data ณ  05/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Preenche o segundo array com os itens dos pedidos a serem  บฑฑ
ฑฑบ          ณfaturados no periodo informado.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PreAcols2(dDat1,dDta2)

Local aArea	:=	GetArea()
Local aRet	:=	{}
Local cQuery

cQuery := "SELECT C6_NUM,C6_ITEM,C6_PRODUTO,C6_DESCRI,C6_QTDVEN,C6_LOCAL,C6_ENTREG,C6_QTDENT,C6_QTDEMP, R_E_C_N_O_ C6REC"
cQuery += " FROM "+RetSQLName("SC6")
cQuery += " WHERE C6_FILIAL='"+xFilial("SC6")+"' AND C6_ENTREG BETWEEN '"+dDat1+"' AND '"+dDta2+"' AND D_E_L_E_T_='' AND C6_QTDVEN>C6_QTDENT"
cQuery += " ORDER BY C6_NUM,C6_ITEM"

If Select("TRB") > 0
	dbSelectArea("TRB")
	DbCloseArea()
EndIf

MemoWrite("TTFAT20D.SQL",cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB")
//'Item','Produto','Descricใo','Qtd Ped','Qtd Lib','Saldo','OPดs'
While !EOF()      
    Aadd(aRet,{TRB->C6_NUM,TRB->C6_ITEM,Alltrim(TRB->C6_PRODUTO),Alltrim(TRB->C6_DESCRI),TRB->C6_QTDVEN-TRB->C6_QTDENT,TRB->C6_QTDEMP,0, 0,TRB->C6_LOCAL,'', TRB->C6REC})
    		//		1				2			3							4							5						6 	  7  8		  9       10		11
	Dbskip()
EndDo

For nX := 1 to len(aRet)
	DbSelectArea("SB2")
	Dbsetorder(1)
	If DbSeek(xFilial("SB2")+AvKey(aRet[nX,03],"B2_COD")+Avkey(aRet[nX,09],"B2_LOCAL"))
		aRet[nX,07]	:= SaldoSB2()
    EndIf 
    
    cQuery := "SELECT C9_BLCRED,C9_BLEST FROM "+RetSQLName("SC9")
	cQuery += " WHERE C9_FILIAL='"+xFilial("SC9")+"' AND C9_PEDIDO='"+aRet[nX,01]+"' AND C9_ITEM='"+aRet[nX,02]+"' AND D_E_L_E_T_=''
	
	If Select("TRB") > 0
		dbSelectArea("TRB")
		DbCloseArea()
	EndIf
	
	MemoWrite("TTFAT20D.SQL",cQuery)
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
	
	dbSelectArea("TRB")
	While !EOF()
	    aRet[nX,10] := 'Cr้dito '+If(Empty(TRB->C9_BLCRED),'Ok /','Bloqueado /')+' Estoque '+If(Empty(TRB->C9_BLEST),'Ok','Bloqueado')
		DbSkip()
	EndDo
	
	If Empty(aRet[nX,10])
		aRet[nX,10] := "Item sem libera็ใo"
	EndIf
	
	cQuery := "SELECT SUM(C2_QUANT) AS QTD FROM SC2110  C2"
	cQuery += " WHERE C2_FILIAL='01' AND C2_DATPRF ='"+dtos(DdataBase)+"'"
	cQuery += " AND C2_PRODUTO ='"+aRet[nX,03]+"' AND C2_LOCAL='D00006' AND C2.D_E_L_E_T_=''"
	If Select("TRB") > 0
		dbSelectArea("TRB")
		DbCloseArea()
	EndIf
	
	MemoWrite("TTFAT20D.SQL",cQuery)
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
	
	dbSelectArea("TRB")
	While !EOF()
	    aRet[nX,08] :=  TRB->QTD
		Dbskip()
	EndDo
		
Next nX

aListB2 := aClone(aRet)

RestArea(aArea)

Return(aRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTravaPed  บAutor  ณMicrosiga           บ Data ณ  05/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณalexandre venancio - assinar funcao                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TravaPed(nLinha)

Local aArea	:=	GetArea()
Local aAux	:=	{}

aList2 := {}
If !lTrava1
	For nX := 1 to len(aListB2)
		If aListB2[nX,01] == aList1[nLinha,02]
			Aadd(aAux,aListB2[nX])
		EndIf
	Next nX 
	aList2 := aClone(aAux)
	lTrava1 := .T.
	//oBtn1      := TButton():New( 173,248,"Destravar",oGrp4,{||TravaPed(oList1:nAt)},037,012,,,,.T.,,"",,,,.F. )  // alterar atributo do botao
	If ValType(oBtn1) == "O"
		oBtn1:cCaption := "Destravar" 
	EndIf
	If lTrava2	// se item esta como travado, troca label para 'Trava Produto'
		If ValType(oBtn2) == "O"
			oBtn2:cCaption := "Trava Produto"
		EndIf	
		lTrava2 := .F.
	EndIf
Else
	aAux := aClone(aListB2)
	aList2 := aClone(aAux)
	lTrava1 := .F.
	//oBtn1      := TButton():New( 173,248,"Trava Pedido",oGrp4,{||TravaPed(oList1:nAt)},037,012,,,,.T.,,"",,,,.F. ) // alterar atributo do botao
	If ValType(oBtn1) == "O"
		oBtn1:cCaption := "Trava Pedido"
	EndIf	
	If lTrava2	// se item esta como travado, troca label para 'Trava Produto'
		If ValType(oBtn2) == "O"
			oBtn2:cCaption := "Trava Produto"
		EndIf
		lTrava2 := .F.
	EndIf
EndIf

If Len(aAux) > 0
	oList2:SetArray(aList2)
	oList2:bLine := {||{aList2[oList2:nAt,01],; 
	 					 aList2[oList2:nAt,02],;
	 					 aList2[oList2:nAt,03],;
	 					 aList2[oList2:nAt,04],; 
	 					 aList2[oList2:nAt,05],;
	 					 aList2[oList2:nAt,06],;
	 					 aList2[oList2:nAt,07],;
	 					 aList2[oList2:nAt,08]}}
	oList2:refresh()
	oDlg1:refresh()
	//oSay11:setText("")
	//oSay11:SetText("Status Reserva - "+aList2[oList2:nAt,10])  
EndIf 


RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTravaItem  บAutor  ณMicrosiga           บ Data ณ  05/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณalexandre venancio - assinar funcao                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TravaItem(nLinha)

Local aArea	:=	GetArea()
Local aAux	:=	{}

If !lTrava2
	For nX := 1 to len(aListB2)
		If aListB2[nX,03] == aList2[nLinha,03]
			Aadd(aAux,aListB2[nX])
		EndIf
	Next nX 
	aList2 := {}
	aList2 := aClone(aAux)
	lTrava2 := .T.
	//oBtn2      := TButton():New( 173,300,"Destravar",oGrp4,{||TravaItem(oList2:nAt)},037,012,,,,.T.,,"",,,,.F. )
	If ValType(oBtn2) == "O"
		oBtn2:cCaption := "Destravar"
	EndIf	
	If lTrava1	// se pedido esta como travado, troca label para 'Trava Pedido'
		oBtn1:cCaption := "Trava Pedido" 
		lTrava1 := .F.
	EndIf
Else
	aAux := aClone(aListB2)
	aList2 := {}
	aList2 := aClone(aAux)
	lTrava2 := .F.
	//oBtn2      := TButton():New( 173,300,"Trava Produto",oGrp4,{||TravaItem(oList2:nAt)},037,012,,,,.T.,,"",,,,.F. )
	If ValType(oBtn2) == "O"
		oBtn2:cCaption := "Trava Produto"
	EndIf	
	If lTrava1	// se pedido esta como travado, troca label para 'Trava Pedido'
		oBtn1:cCaption := "Trava Pedido"
		lTrava1 := .F.
	EndIf
EndIf

If len(aAux) > 0
	oList2:SetArray(aList2)
	oList2:bLine := {||{aList2[oList2:nAt,01],; 
	 					 aList2[oList2:nAt,02],;
	 					 aList2[oList2:nAt,03],;
	 					 aList2[oList2:nAt,04],; 
	 					 aList2[oList2:nAt,05],;
	 					 aList2[oList2:nAt,06],;
	 					 aList2[oList2:nAt,07],;
	 					 aList2[oList2:nAt,08]}}
	oList2:refresh()
	oDlg1:refresh()	
EndIf 

RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAltTpFat  บAutor  ณJackson E. de Deus  บ Data ณ  08/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAltera o tipo de faturamento do pedido                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AltTpFat(nLinha)

Local cTipoFat := ""
Local cNovoTipo := ""
Local cAux := ""

If aList1[nLinha,09]=="1"
	cTipoFat := "Parcial - Libera็ใo por Item"
	cNovoTipo := "Total - Libera็ใo por Pedido de venda"
	cAux := "2"
ElseIf aList1[nLinha,09]=="2"
	cTipoFat := "Total - Libera็ใo por Pedido de venda"
	cNovoTipo := "Parcial - Libera็ใo por Item"
	cAux := "1"
	cTxt := "Parcial"
EndIf

If MsgYesNo("O pedido selecionado possui tipo de faturamento '" +cTipoFat +"'." +CRLF +"Deseja alterar para '" +cNovoTipo +"' ?","TTFAT20D - ALTTPFAT" )
	aList1[nLinha,09] := cAux	// altera o tipo no array 1 principal
	aListB1[nLinha,09] := cAux	// altera o tipo no array 1 backup
	
	dbSelectArea("SC5")
	dbGoTo(aList1[nLinha,04])
	RecLock("SC5",.F.) 
	SC5->C5_TIPLIB := cAux
	SC5->( MsUnLock() )
	
	oSay6:setText("")	// Altera texto Tipo faturamento
	oSay6:setText( IF(cAux=="1","Parcial","Total") ) 
	oSay6:Refresh()
EndIf

Return
      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAltResrv  บAutor  ณJackson E. de Deus  บ Data ณ  09/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAltera reserva do produto                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AltResrv(nLinha1,nLinha2) 

Local oDlg1, oSay,oSay1,oSay2,oSay3
Local nQtd := 0
Local nOpc := 0
Local nSaldo := 0

// Tela
oDlg1	:= MSDialog():New( 230,300,428,620,"Controle de reservas",,,.F.,,,,,,.T.,,,.T. )
	oFont	:= TFont():New('Arial',,-12,.T.,.T.)
	oSay3	:= TSay():New( 004,020,{|| "Pedido " +aList2[nLinha2,01] +" - " +" Item "+aList2[nLinha2,02] },oDlg1,,/*oFont*/,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)	
	oSay1	:= TSay():New( 014,020,{|| aList2[nLinha2,04] },oDlg1,,/*oFont*/,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)	
	oSay	:= TSay():New( 024,020,{||"Quantidade atual reservada: " +cvaltochar(aList2[nLinha2,06]) },oDlg1,,/*oFont*/,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)
 	oSay2	:= TSay():New( 044,020,{||"Digite a quantidade a ficar reservada:" },oDlg1,,/*oFont*/,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)
 	//oCBox1	:= TComboBox():New(020,020,{ |u| If(PCount()>0,cCombo2:=u,cCombo2) },aTipoLib,110,010,oDlg1,,{|| nTpLib := oCBOX1:NAT  },,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,cCombo2)
  	
  	@ 052,020 MSGET nQtd PICTURE PesqPict("SC6","C6_QTDVEN")		OF oDlg1 SIZE 060,008 PIXEL HASBUTTON
  	
	oSBtn1	:= SButton():New( 065,080,1,{|| oDlg1:End(nOpc:=1)  },oDlg1,.T.,"", ) 
	oSBtn2	:= SButton():New( 065,110,2,{|| oDlg1:End()  },oDlg1,.T.,"", ) 

oDlg1:Activate(,,,.T.)

If nOpc == 1
	If nQtd > 0
		//aSaldos := CalcEst( aList2[nLinha2,03], aList2[nLinha2,09], dDataBase+1 )	// produto,armazem,data
		DbSelectArea("SB2")
		Dbsetorder(1)
		If DbSeek(xFilial("SB2")+AvKey(aList2[nLinha2,03],"B2_COD")+Avkey(aList2[nLinha2,09],"B2_LOCAL"))
			nSaldo	:= SaldoSB2()
			If nSaldo >= nQtd
				Processa({|| LibSB2(3,nLinha1,nLinha2,nQtd)   },"Liberando produtos, aguarde..")
			EndIf 
	    EndIf
	Else                   
		dbSelectArea("SC9")
		dbSetOrder(2)	// cliente loja pedido item
		If dbSeek( xFilial("SC9") +AvKey(aList1[nLinha1,05],"C9_CLIENTE") +AvKey(aList1[nLinha1,06],"C9_LOJA") +AvKey(aList1[nLinha1,02],"C9_PEDIDO") +AvKey(aList2[nLinha2,02],"C9_ITEM") )
			If AllTrim(SC9->C9_BLEST) <> "10" .And. AllTrim(SC9->C9_BLCRED) <> "10"
				A460Estorna(.F.,.T.)
			EndIf
		EndIf
	EndIf	
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLibEst  บAutor  ณJackson E. de Deus    บ Data ณ  14/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTela para liberacao de estoque                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function LibEst(nLinha1,nLinha2)

Local oDlg1
Local oSay
Local oSBtn1
Local aTipoLib := {"Todos itens do pedido","Item liberado - com bloqueio","Item sem libera็ใo"}
Local cCombo2 := aTipoLib[1]
Local nTpLib := 1
Local oCBox1
Local nOpca := 0
	
oDlg1	:= MSDialog():New( 230,300,348,550,"Tipo de libera็ใo",,,.F.,,,,,,.T.,,,.T. )
	oFont	:= TFont():New('Arial',,-12,.T.,.T.)
	oSay	:= TSay():New( 004,020,{||"Selecione abaixo o tipo de libera็ใo:"},oDlg1,,/*oFont*/,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,008)
     oCBox1	:= TComboBox():New(020,020,{ |u| If(PCount()>0,cCombo2:=u,cCombo2) },aTipoLib,090,010,oDlg1,,{|| nTpLib := oCBOX1:NAT  },,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,cCombo2)
  	
	oSBtn1	:= SButton():New( 045,051,1,{|| oDlg1:End(nOpca:=1)  },oDlg1,.T.,"", )
	oSBtn2	:= SButton():New( 045,082,2,{|| oDlg1:End()  },oDlg1,.T.,"", )
	
oDlg1:Activate(,,,.T.)

If nOpca == 1
	// 1- Pedido total - somente quando status == verde / aberto - malibdofat
	If nTpLib == 1
		If UPPER(aList1[nLinha1,01]:cName) <> "BR_VERDE"
			MsgInfo("A libera็ใo total deve ocorrer somente quando o pedido estiver sem libera็ใo - status VERDE")
			Return
		EndIf
	// 2 - Liberado - limpar campo C9_BLEST	
	ElseIf aList2[nLinha2,06] == 0
		//MsgInfo("Ainda nใo houve a libera็ใo desse item")
		Return
	EndIf
	// 2 - liberou mas ficou bloqueado em estoque - validar saldo disponivel
	// 3- libera o item - malibdofat
	Processa( {|| LibSB2(nTpLib,nLinha1,nLinha2)   },"Liberando produtos, aguarde..")
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLibSB2  บAutor  ณJackson E. de Deus    บ Data ณ  15/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFaz a liberacao de estoque                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function LibSB2(nTpLib,nLinha1,nLinha2,nQtd)

Local lBlqCrd	:= .F.
Local lBlqEst	:= .T.
Local aAuxItem	:= {}
Local nI		:= 0
Local nCont		:= 0
Local aSaldos	:= {} 
Local nQtdLib	:= 0
Local nSaldo	:= 0
Local nCntLib	:= 0
Local nQtdLibOk := 0

Default nQtd	:= Nil

If nTpLib == 1
	For nI := 1 To Len(aList2)	// prepara array auxiliar - produto + recno + qtd
		If aList2[nI,01] == aList1[nLinha1,02]
			AADD( aAuxItem, { aList2[nI,03], aList2[nI,11], aList2[nI,05], aList2[nI,02], 0   } )	// produto - recno - qtdven - item - qtd liberada
			nCont++
		EndIf
	Next nI       
                        
// limpar campo C9_BLEST
ElseIf nTpLib == 2	
 	dbSelectArea("SB2")
	dbSetOrder(1)	// filial + codigo + local
	If DbSeek(xFilial("SB2")+AvKey(aList2[nLinha2,03],"B2_COD")+Avkey(aList2[nLinha2,09],"B2_LOCAL"))
		nSaldo	:= SaldoSB2()
		If nSaldo >= aList2[nLinha2,06]	// saldo maior ou igual qtd empenhada
			AADD( aAuxItem, { aList2[nLinha2,03], aList2[nLinha2,11], aList2[nLinha2,05], aList2[nLinha2,02], 0   } )	// produto - recno - qtdven - item - qtd liberada
			nCont++	
		EndIf
    EndIf
			
ElseIf nTpLib == 3
	//aSaldos := CalcEst( aList2[nLinha2,03], aList2[nLinha2,09], dDataBase+1 )	// produto,armazem,data
    // Chamada da funcao de controle de reservas
    If nQtd <> Nil 
    	AADD( aAuxItem, { aList2[nLinha2,03], aList2[nLinha2,11], aList2[nLinha2,05],  aList2[nLinha2,02], 0  } )	// produto - recno - qtdven - item - qtd liberada
		nCont++	
     // chamada da funcao de liberacao de itens
	Else
		nQtd := aList2[nLinha2,05]
     	DbSelectArea("SB2")
		Dbsetorder(1)	// filial + codigo + local
		If DbSeek(xFilial("SB2")+AvKey(aList2[nLinha2,03],"B2_COD")+Avkey(aList2[nLinha2,09],"B2_LOCAL"))
			nSaldo	:= SaldoSB2()
			If nSaldo >= aList2[nLinha2,05] .And. aList2[nLinha2,06] == 0
				AADD( aAuxItem, { aList2[nLinha2,03], aList2[nLinha2,11], aList2[nLinha2,05],  aList2[nLinha2,02], 0  } )
				nCont++	
			EndIf
	    EndIf
	EndIf
EndIf   

ProcRegua(nCont)

// Processa as liberacoes
// SC9
If nTpLib == 2
	// limpar campo bloqueio - C9_BLEST
	dbSelectArea("SC9")
	dbSetOrder(2)	// cliente + loja + pedido + item
	If dbSeek( xFilial("SC9") +AvKey(aList1[nLinha1,05],"C9_CLIENTE") +AvKey(aList1[nLinha1,06],"C9_LOJA") +AvKey(aList1[nLinha1,02],"C9_PEDIDO") +AvKey(aList2[nLinha2,02],"C9_ITEM") )
		RecLock("SC9",.F.)
		SC9->C9_BLEST := ""
		SC9->( MsUnLock() )
		
		aList2[nLinha2,10] := 'Cr้dito '+If(Empty(SC9->C9_BLCRED),'Ok /','Bloqueado /')+' Estoque '+If(Empty(SC9->C9_BLEST),'Ok','Bloqueado')
		aAuxItem[nLinha2,05] := aAuxItem[nLinha2,03]
		
		MsgInfo("Item liberado")
	EndIf    
	
// MaLibDoFat	
Else
	dbSelectArea("SC6")
	For nI := 1 To Len(aAuxItem)
		nQtdLib := 0
		nQtd := aAuxItem[nI][3]
		dbGoTo(aAuxItem[nI,02])	// recno SC6
		If Recno() == aAuxItem[nI,02]
			If nQtd == 0
				nQtd := aAuxItem[nI,03] // SC6->C6_QTDVEN
			EndIf
			
			IncProc(aAuxItem[nI,01]) 
			nQtdLib := MaLibDoFat( SC6->( RecNo() ),nQtd,,,@lBlqCrd,@lBlqEst,.T.,.F.) 
			// altera no array a quantidade liberada
			If nQtdLib > 0
				aList2[nLinha2,06] := nQtdLib
				aAuxItem[nI,05] := nQtdLib
				MaLiberOk( {  aList1[nLinha1,02] },.T. ) 
				 
				nCntLib++
			EndIf		
		EndIf
	Next nI
	If nCntLib > 0	
		MsgInfo("Itens liberados: "+cvaltochar(nCntLib))
	EndIf
EndIf

FHelp1(nLinha2,nLinha1)
MsUnLockAll()
	      
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVerPedido  บAutor  ณJackson E. de Deus บ Data ณ  14/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVisualiza o pedido de venda posicionado                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VerPedido(nLinha1,cNumPed)

Local aArea := GetArea()
Private aRotina := StaticCall( MATA410 , MenuDef )
Default cNumPed := Nil

If cNumPed == Nil
	cNumPed := aList1[nLinha1,02]
EndIf	

dbSelectArea("SC5")
dbSetOrder(1)
If dbSeek(xFilial("SC5") +AvKey(cNumPed,"C5_NUM") )
	SC5->(a410Visual("SC5",RecNo(),2))
Endif
 
RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVerSaldo  บAutor  ณJackson E. de Deus  บ Data ณ  15/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMostra informacoes de saldo do produto no armazem atual     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VerSaldo(nLinha1,nLinha2) 

Local oDlg2, oSay1, oSay2, oSay3, oSay4, oSay5, oSay6, oSay7, oSay8, oSay9, oSay10, oSay11, oSay12, oSay13, oSay14, oSay15, oSay16
Local nQtdPed,nSldAtual,nQtdRsrv,nSldDisp,nQtdEmpC6 := 0
Local lDiverSC9 := .F.
Local cTxtDiver := ""
Local oFont	:= TFont():New('Arial',,-12,.T.,.T.)

dbSelectArea("SC6")
dbGoTo(aList2[nLinha2,11])
If Recno() <> aList2[nLinha2,11]
	Return
EndIf
nQtdPed := SC6->C6_QTDVEN
nQtdEmpC6 := SC6->C6_QTDEMP

dbSelectArea("SB2")
dbSetOrder(1)	// filial + codigo + local
If !dbSeek(xFilial("SB2")+AvKey(aList2[nLinha2,03],"B2_COD")+Avkey(aList2[nLinha2,09],"B2_LOCAL"))
	Return
EndIf	
nSldAtual := SB2->B2_QATU
nQtdRsrv := SB2->B2_RESERVA
nSldDisp := SaldoSB2()

// Liberado SC6
If nQtdEmpC6 > 0
	// verifica divergencia entre liberacao C6 x C9 x B2
	dbSelectArea("SC9")
	dbSetOrder(2)	// cliente + loja + pedido + item
	dbSeek( xFilial("SC9") +AvKey(aList1[nLinha1,05],"C9_CLIENTE") +AvKey(aList1[nLinha1,06],"C9_LOJA") +AvKey(aList1[nLinha1,02],"C9_PEDIDO") +AvKey(aList2[nLinha2,02],"C9_ITEM") )
	
	If !Found()	// nao tem liberacao SC9
		lDiverSC9 := .T. 
	Else
		/*
		If !Empty(SC9->C9_BLEST)	// tem registro mas nao esta liberado
			lDiverSC9 := .T.
		Else
			If nQtdEmpC6 > SC9->C9_QTDLIB	// tem liberacao mas em quantidade inferior ao que esta na SC6
				lDiverSC9 := .T.
			EndIf
		EndIf
		*/                
		If Empty(SC9->C9_BLEST) .And. nQtdEmpC6 > SC9->C9_QTDLIB
			lDiverSC9 := .T.
		EndIf
	EndIf               
EndIf

If lDiverSC9
	cTxtDiver := "Existe inconsist๊ncia na libera็ใo do item no pedido. Verificar SC6 x SC9"
EndIf

oDlg2 := Tela("Consulta de saldo")
	oSay1 := TSay():New( 010,010,{|| "Pedido: " },oDlg2,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)
	oSay2 := TSay():New( 010,110,{|| aList1[nLinha1,02] },oDlg2,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)
	
	oSay3 := TSay():New( 020,010,{|| "Item: " },oDlg2,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)   
	oSay4 := TSay():New( 020,110,{|| aList2[nLinha2,02] },oDlg2,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)
	
	oSay5 := TSay():New( 030,010,{|| "Produto: " },oDlg2,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010) 
	oSay6 := TSay():New( 030,110,{|| aList2[nLinha2,03] + " - " +aList2[nLinha2,04] },oDlg2,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010) 
	
	oSay7 := TSay():New( 040,010,{|| "Armaz้m: " },oDlg2,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)
	oSay8 := TSay():New( 040,110,{|| aList2[nLinha2,09] },oDlg2,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)
	
	oSay9 := TSay():New( 050,010,{|| "Quantidade no pedido: " },oDlg2,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)
	oSay10 := TSay():New( 050,110,{|| cvaltochar( nQtdPed ) },oDlg2,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)
	
	oSay13 := TSay():New( 060,010,{|| "Saldo fํsico no armaz้m: "},oDlg2,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)
	oSay14 := TSay():New( 060,110,{|| cvaltochar( nSldAtual ) },oDlg2,,oFont,.F.,.F.,.F.,.T., IIF( nSldAtual>0,CLR_BLUE,CLR_RED ),CLR_WHITE,150,010)
	
	oSay11 := TSay():New( 070,010,{|| "Reserva do produto no armaz้m: " },oDlg2,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)
	oSay12 := TSay():New( 070,110,{|| cvaltochar( nQtdRsrv ) },oDlg2,,oFont,.F.,.F.,.F.,.T.,IIF( nQtdRsrv>0,CLR_RED,CLR_BLUE ),CLR_WHITE,150,010)

	oSay15 := TSay():New( 080,010,{|| "Saldo disponํvel no armaz้m: " },oDlg2,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,010)
	oSay16 := TSay():New( 080,110,{|| cvaltochar( nSldDisp ) },oDlg2,,oFont,.F.,.F.,.F.,.T., IIF( nSldDisp>0,CLR_BLUE,CLR_RED ), CLR_WHITE,150,010)
	
	oSay17 := TSay():New( 100,010,{|| cTxtDiver },oDlg2,,oFont,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,250,012)
			
oDlg2:Activate(,,,.T.)
   

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVerRsrva   บAutor  ณJackson E. de Deus บ Data ณ  15/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณConsulta de reservas de todos os pedidos no armazem atual   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VerRsrva(nLinha2) 

Local oList
Local aAux := {}
Local oDlg2, oSay1, oSay2, oSay3, oSay4

aAux := QueryProd(nLinha2)

oDlg2 := Tela("Consulta de reserva") 
	oSay1 := TSay():New( 010,010,{|| "Produto: " +aList2[oList2:nAt,03] + " - " +aList2[oList2:nAt,04] },oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,008)
	oSay2 := TSay():New( 020,010,{|| ""  },oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,008)
    oSay3 := TSay():New( 010,200,{|| "Armaz้m: "},oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,008)
    oSay4 := TSay():New( 010,230,{|| "" },oDlg2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,008)

	oList := TCBrowse():New( 030,010,240,100,, {'Cliente','Loja','Data Emissใo','Pedido','Item','Qtd','Qtd Lib','Data entrega'},{20,20,20,20,20,20,20,20},oDlg2,,,,{ || oSay2:setText(aAux[oList:nAt,08]), oSay4:setText(aList2[nLinha2,09])  },{|| VerPedido("",aAux[oList:nAt,03])  },, ,,,  ,,.F.,,.T.,,.F.,,,)
	oList:SetArray(aAux)
	oList:bLine := { || { aAux[oList:nAt,01],;
							 aAux[oList:nAt,02],;
							 aAux[oList:nAt,09],;
							 aAux[oList:nAt,03],;
							 aAux[oList:nAt,04],;
							 aAux[oList:nAt,05],;
							 aAux[oList:nAt,06],;
							 aAux[oList:nAt,07] } }
							 
	oBtn := TButton():New( 140,010,"Outros armaz้ns",oDlg2,{ || VerRsrva2(nLinha2) },050,012,,,,.T.,,"",,,,.F. )	 					  					 							 
					  					 
oDlg2:Activate(,,,.T.)

Return

 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVerRsrva2  บAutor  ณJackson E. de Deus บ Data ณ  15/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณConsulta de reservas de todos os pedidos e armaz้ns         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VerRsrva2(nLinha2) 

Local oList
Local aAux := {}
Local oDlg2, oSay1
Local oFont	:= TFont():New('Arial',,-12,.T.,.T.)

aAux := QueryProd(nLinha2,.T.)

oDlg2 := Tela("Consulta de reserva - outros armaz้ns") 
	oSay1 := TSay():New( 010,010,{|| "" },oDlg2,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,150,008)
	oList := TCBrowse():New( 020,010,240,110,, {'Cliente','Loja','Data Emissใo','Pedido','Item','Qtd','Qtd Lib','Data entrega','Armaz้m'},{20,20,20,20,20,20,20,20,20},oDlg2,,,,{ || oSay1:setText(aAux[oList:nAt,08])  },{|| VerPedido("",aAux[oList:nAt,03]) },, ,,,  ,,.F.,,.T.,,.F.,,,)
	oList:SetArray(aAux)
	oList:bLine := { || { aAux[oList:nAt,01],;
							 aAux[oList:nAt,02],;
							 aAux[oList:nAt,09],;
							 aAux[oList:nAt,03],;
							 aAux[oList:nAt,04],;
							 aAux[oList:nAt,05],;
							 aAux[oList:nAt,06],;
							 aAux[oList:nAt,07],;
							 aAux[oList:nAt,10] } }
							  					  					 							 
	oBtn2 := TButton():New( 140,215,"Sair",oDlg2,{ || oDlg2:End() },035,012,,,,.T.,,"",,,,.F. )	 					  					 
oDlg2:Activate(,,,.T.)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณQueryProd  บAutor  ณJackson E. de Deus บ Data ณ  15/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna os dados dos produtos dos pedidos                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function QueryProd(nLinha2,lTodos)

Local cQuery := ""
Local aAux := {}
Default lTodos := .F.

cQuery := "SELECT C5_CLIENTE, C5_LOJACLI, A1_NOME, C5_EMISSAO, C6_NUM, C6_ITEM, C6_PRODUTO, C6_QTDVEN, C6_QTDEMP, C6_QTDENT, C6_ENTREG, C6_LOCAL FROM " +RetSqlName("SC6") +" SC6 "
cQuery += "INNER JOIN " +RetSqlName("SC5") +" SC5 ON "
cQuery += "SC5.C5_FILIAL = SC6.C6_FILIAL AND SC5.C5_NUM = SC6.C6_NUM AND SC5.C5_CLIENTE = SC6.C6_CLI AND SC5.C5_LOJACLI = SC6.C6_LOJA "
cQuery += " INNER JOIN " +RetSqlName("SA1") +" SA1 ON "
cQuery += " SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI "
cQuery += "WHERE C6_QTDEMP > 0 AND C6_NOTA = '' AND C6_SERIE = '' AND SC6.D_E_L_E_T_ = '' AND C6_FILIAL = '"+xFilial("SC6")+"' AND C6_PRODUTO = '"+aList2[nLinha2,03]+"' "

If !lTodos
	cQuery += " AND C6_LOCAL = '"+aList2[nLinha2,09]+"' "
Else
	cQuery += " AND SUBSTRING(C6_LOCAL,1,1) = 'D' AND C6_LOCAL <> '"+aList2[nLinha2,09]+"' "
EndIf    

If Select("TRBR") > 0
	TRBR->(dbclosearea())
EndIf

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRBR",.F.,.T.)

dbSelectArea("TRBR")
While !EOF()
	AADD( aAux, { TRBR->C5_CLIENTE, TRBR->C5_LOJACLI, TRBR->C6_NUM, TRBR->C6_ITEM, TRBR->C6_QTDVEN, TRBR->C6_QTDEMP, dtoc(stod(TRBR->C6_ENTREG)), TRBR->A1_NOME, DTOC(STOD(TRBR->C5_EMISSAO)), TRBR->C6_LOCAL } )
	//					1					2				3				4			5					6				7							8				9							10
	dbSkip()
End

If Len(aAux) == 0
	AADD(aAux, { Space(6), Space(4), Space(6), Space(2), 0, 0, dtoc(stod("")), "", dtoc(stod("")), "" } )
EndIf           

Return aAux

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTela บAutor  ณJackson E. de Deus       บ Data ณ  14/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMonta a tela pequena para consulta de saldo/reservas        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Tela(cTitulo)

Local oDlg2,oBtn
Default cTitulo := ""

oDlg2 := MSDialog():New( 091,232,400,750,cTitulo,,,.F.,,,,,,.T.,,,.T. )
oBtn2 := TButton():New( 140,215,"Sair",oDlg2,{ || oDlg2:End() },035,012,,,,.T.,,"",,,,.F. )	 	

Return oDlg2


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTxtStatus  บAutor  ณJackson E. de Deus บ Data ณ  16/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMonta o texto em html do status do item - bloq/lib          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TxtStatus(cTxtItem)

Local cTextHtml := ""
Local aAux := {}
Local nI := 0

cTextHtml := '<font size=4 color=black>Status Reserva - </font>' 
aAux := StrToKarr(cTxtItem ,"/")
For nI := 1 To Len(aAux)
	If "Bloqueado" $ aAux[nI]
		cTextHtml += '<font size=4 color=red>' +aAux[nI] +'</font>'
	Else
		If "libera็ใo" $ aAux[nI]
			cTextHtml += '<font size=4 color=black>' +aAux[nI] +'</font>'
		Else                         
			cTextHtml += '<font size=4 color=blue>' +aAux[nI] +'</font>'
		EndIf
	EndIf
	If nI == 1 .And. Len(aAux) > 1   
		cTextHtml += '<font size=4 color=black>/</font>'
	EndIf
Next nI

Return cTextHtml