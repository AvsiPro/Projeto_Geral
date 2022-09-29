#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH' 
#INCLUDE 'TBICONN.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ TTAUDT02 ณ Autor ณAlexandre Venancio     ณ Data ณ04/08/14  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณLocacao   ณ                  ณContato ณ                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Controle de Conta corrente dos patrimonios.                ณฑฑ
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

User Function TTAUDT02

SetPrvt("oDlg1","oGrp1","oSay1","oSay3","oSay4","oSay5","oGrp2","oSay2","oSay6","oGet1","oGet2","oGrp3")
SetPrvt("oBtn2","oBtn3","oBtn4","oBtn6","oBtn7","oGrp4","oBrw3","oGrp5","oBrw1","oBrw2","oSay7","oGet3")  
Private cPatr := space(6)
Private cCliente := space(10) 
Private dDia	:=	ctod(' / / ')
Private oList1
Private oList2
Private oList3
Private aList1 := {}
Private aList2 := {}     
Private aList2B:= {}
Private aList3 := {}
Private aTipos := {'0=Saldo Inicial','1=Sangria','2=Abastecimento','3=Ajuste+ S','4=Ajuste- S','5=Ajuste+ A','6=Ajuste- A','7=Leitura','8=Auditoria','9=Encerramento'}
Private oOk    := LoadBitmap(GetResources(),'br_verde')       //Controla se o pedido foi alterado ou nao no grid.
Private oNo    := LoadBitmap(GetResources(),'br_vermelho')    

//Prepare Environment EMPRESA "01" FILIAL "01"

Aadd(aList1,{'','',''})
Aadd(aList2,{.F.,'','',0,0,0,0,0,'','',0,'','','','',''})
Aadd(aList3,{.T.,'','','','','','','','','','','','','','',''})

oDlg1      := MSDialog():New( 091,232,640,1203,"Conta Corrente do Patrim๔nio",,,.F.,,,,,,.T.,,,.T. )

oGrp1      := TGroup():New( 004,004,068,176,"Informa็๕es do Patrim๔nio",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay1      := TSay():New( 016,012,{||"Modelo"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,156,008)
	oSay2      := TSay():New( 028,012,{||"Cliente"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,156,008)
	oSay3      := TSay():New( 040,012,{||"Local Fisico de instala็ใo"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,156,008)
	oSay4      := TSay():New( 053,012,{||"Sistema de Pagamento"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,156,008)

oGrp2      := TGroup():New( 004,180,068,280,"Informe o Patrim๔nio ou o Cliente",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

	oSay5      := TSay():New( 018,184,{||"Patrim๔nio"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)
	oGet1      := TGet():New( 019,216,{|u|If(PCount()>0,cPatr:=u,cPatr)},oGrp2,060,008,'',{||If(!Empty(cPatr),Processa({ || procura(1) },"Aguarde"),)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SN1","",,)

	oSay6      := TSay():New( 033,184,{||"Cliente"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008) //044
	oGet2      := TGet():New( 033,216,{|u|If(Pcount()>0,cCliente:=u,cCliente)},oGrp2,060,008,'',{||If(!Empty(cCliente),Processa({ || procura(2) },"Aguarde"),)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA1001","",,)

	oSay7      := TSay():New( 048,184,{||"Data"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008) //044
	oGet3      := TGet():New( 048,216,{|u|If(Pcount()>0,dDia:=u,dDia)},oGrp2,060,008,'',{|| Processa({ || procura(3) },"Aguarde")},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA1001","",,)

oGrp3      := TGroup():New( 004,284,068,476,"A็๕es",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

	oBtn1      := TButton():New( 017,304,"Ajuste",oGrp3,{|| Ajuste()},037,012,,,,.T.,,"",,,,.F. )
	oBtn2      := TButton():New( 017,361,"Reprocessa",oGrp3,{|| Reprocessa(cPatr)},037,012,,,,.T.,,"",,,,.F. )
	oBtn3      := TButton():New( 017,421,"Gravar",oGrp3,{|| Gravar()},037,012,,,,.T.,,"",,,,.F. )
	oBtn4      := TButton():New( 044,304,"Auditoria",oGrp3,{|| GerarAud()},037,012,,,,.T.,,"",,,,.F. )
	oBtn6      := TButton():New( 044,361,"Relat๓rio",oGrp3,{|| Relato()},037,012,,,,.T.,,"",,,,.F. )
	oBtn7      := TButton():New( 044,421,"Sair",oGrp3,{||oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )
    //SButton():New( 45,221,15,{||Alert('?')},oDlg1,.T.,,) 
    oBtn8      := TButton():New( 068,445,"FT",oGrp3,{||MsgAlert("(Fundo de Troco Anterior + Troco Abastecido) - (Total Venda - (Valor Sangria + Troco Sangrado)) + Ajuste ","Calculo do Fundo de Troco")},020,008,,,,.T.,,"",,,,.F. )
     
    oBtn1:disable()
    oBtn2:disable() 
    oBtn3:disable()
    oBtn4:disable()
    oBtn6:disable()
	
oGrp4      := TGroup():New( 072,004,260,124,"Patrim๔nios",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	//oBrw3      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{080,008,256,120},,, oGrp4 ) 
	
	oList1 := TCBrowse():New(080,008,112,175,, {'Patrim๔nio','Descricao'},{30,100},;
	                            oGrp4,,,,{|| FHelp(oList1:nAt)},{|| },, ,,,  ,,.F.,,.T.,,.F.,,,)
	oList1:SetArray(aList1)
	oList1:bLine := {||{aList1[oList1:nAt,01],; 
	 					 aList1[oList1:nAt,02]}} 
	      

oGrp5      := TGroup():New( 072,128,260,476,"Conta Corrente",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	//oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{080,132,160,472},,, oGrp5 ) 
	oList2 := TCBrowse():New(080,132,340,085,, {'','Data','Tipo','Ajuste','Lim Troco','Troco Ab.','Troco San.','Vlr. San','Cnt Cash','Venda','Fundo Troco'},{10,30,30,30,30,30,30,30,30,30,30},;
	                            oGrp5,,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
	oList2:SetArray(aList2)
	oList2:bLine := {||{If(aList2[oList2:nAt,01],oOk,oNo),; 
	 					 aList2[oList2:nAt,02],;
	 					 aList2[oList2:nAt,03],; 
	 					 aList2[oList2:nAt,04],;
	 					 aList2[oList2:nAt,05],; 
	 					 aList2[oList2:nAt,06],;
	 					 aList2[oList2:nAt,07],; 
	 					 aList2[oList2:nAt,08],;
	 					 aList2[oList2:nAt,09],; 
	 					 aList2[oList2:nAt,10],;
	 					 aList2[oList2:nAt,11]}} 


	//oBrw2      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{165,132,248,472},,, oGrp5 ) 
	oList3 := TCBrowse():New(170,132,340,085,, {'','Data','Tipo','Ajuste','Lim Abast','Cnt Cash','Contagem','Abastecido','Desabastecido','Cnt Cash','Saldo Maq','Estoque Calc'},{10,30,30,30,30,30,30,30,30,30,30},;
	                            oGrp5,,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
	oList3:SetArray(aList3)
	oList3:bLine := {||{If(aList3[oList3:nAt,01],oOk,oNo),; 
	 					 aList3[oList3:nAt,02],;
	 					 aList3[oList3:nAt,03],; 
	 					 aList3[oList3:nAt,04],;
	 					 aList3[oList3:nAt,05],; 
	 					 aList3[oList3:nAt,06],;
	 					 aList3[oList3:nAt,07],; 
	 					 aList3[oList3:nAt,08],;
	 					 aList3[oList3:nAt,09],; 
	 					 aList3[oList3:nAt,10],;
	 					 aList3[oList3:nAt,11]}} 
	 					 
	// Menu popup grid 1
	MENU oMenu POPUP 
	MENUITEM "Corrigir Contador" ACTION ( corrigir(1) )
	MENUITEM "Eliminar Registro" ACTION ( corrigir(2) )
	ENDMENU
                                                                                                       
	oList2:bRClicked := { |oObject,nX,nY| oMenu:Activate( nX, (nY-10), oObject ) } 
	
	// ORDEM DE SERVICO GERADA
	oSOS := TSay():New( 260,10,{ || "OS Auditoria" },oDlg1,"",,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,90,12,,,,,,.F. )	
	oSOS:SetCss( "QLabel {font: bold 12px; color: #333333; }" )
	oSOS:bLClicked := { ||  }
	
	oOSStat := TBitmap():Create(oDlg1,260,120,10,10,"BR_BRANCO",,.T., {|| },,.F.,.F.,,,.F.,,.T.,,.F.)
	
	//1บ Informar a OS que foi gerada no momento do disparo.
	//2บ Informa เ ultima OS gerada para Patrim๔nio e tamb้m informa se o ciclo foi finalizado ou se estแ pendente.
    

oDlg1:Activate(,,,.T.)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTAUDT02  บAutor  ณMicrosiga           บ Data ณ  08/04/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Busca informacoes na base                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function procura(opcao)

Local cQuery    
Local nVlr		:=	0      
Local cCashSM	:=	''	
                       
oList1:nAt := 1
                            
cQuery := "SELECT ZI.*,N1_DESCRIC,N1_XLOCINS,N1_XSISPG,N1_XLIMTRO,N1_XCLIENT,N1_XLOJA,A1_COD,A1_LOJA,A1_NOME,A1_NREDUZ,ZI.R_E_C_N_O_ AS REG,ZN_HORA,ZN.R_E_C_N_O_ AS REGZN,"
cQuery += " ZN_LOGC01,(SELECT TOP 1 ZN_LOGC01 FROM "+RetSQLName("SZN")+" WHERE ZN_PATRIMO=ZN.ZN_PATRIMO AND ZN_LOGC01<>''"
cQuery += " 	AND ZN_DATA<ZN.ZN_DATA AND R_E_C_N_O_<ZN.R_E_C_N_O_ ORDER BY ZN_DATA DESC) AS LOGCANT1,"
cQuery += " ZN_LOGC02,(SELECT TOP 1 ZN_LOGC02 FROM "+RetSQLName("SZN")+" WHERE ZN_PATRIMO=ZN.ZN_PATRIMO AND ZN_LOGC02<>''"
cQuery += " 	AND ZN_DATA<ZN.ZN_DATA AND R_E_C_N_O_<ZN.R_E_C_N_O_ ORDER BY ZN_DATA DESC) AS LOGCANT2,"
cQuery += " ZN_LOGC03,(SELECT TOP 1 ZN_LOGC03 FROM "+RetSQLName("SZN")+" WHERE ZN_PATRIMO=ZN.ZN_PATRIMO AND ZN_LOGC03<>''"
cQuery += " 	AND ZN_DATA<ZN.ZN_DATA AND R_E_C_N_O_<ZN.R_E_C_N_O_ ORDER BY ZN_DATA DESC) AS LOGCANT3,"
cQuery += " ZN_LOGC04,(SELECT TOP 1 ZN_LOGC04 FROM "+RetSQLName("SZN")+" WHERE ZN_PATRIMO=ZN.ZN_PATRIMO AND ZN_LOGC04<>''"
cQuery += " 	AND ZN_DATA<ZN.ZN_DATA AND R_E_C_N_O_<ZN.R_E_C_N_O_ ORDER BY ZN_DATA DESC) AS LOGCANT4"

cQuery += " FROM "+RetSQLName("SZI")+" ZI"
cQuery += " INNER JOIN "+RetSQLName("SN1")+" N1 ON N1_CHAPA=ZI_PATRIMO AND N1_XCLIENT=ZI_CLIENTE AND N1.D_E_L_E_T_=''"
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_COD=ZI_CLIENTE AND A1_LOJA=ZI_LOJA AND A1.D_E_L_E_T_=''"
cQuery += " LEFT JOIN "+RetSQLName("SZN")+" ZN ON ZN_PATRIMO=ZI_PATRIMO AND ZN_DATA=ZI_DATA AND ZN_NUMOS<>'' AND ZN.D_E_L_E_T_='' AND ZN_TIPINCL IN('SANGRIA','AUDITORIA','INSTALACAO')"

If opcao == 1        
	cCliente:=space(10)    
	cQuery += " WHERE ZI_PATRIMO='"+Alltrim(cPatr)+"' AND ZI.D_E_L_E_T_=''"
ElseIf opcao == 2
	cPatr:=space(6)                     
	cQuery += " WHERE ZI_CLIENTE='"+substr(cCliente,1,6)+"' AND ZI.D_E_L_E_T_=''"
Else                                                               
	If !Empty(dDia)
		cQuery += " WHERE ZI_DATA='"+dtos(dDia)+"' AND ZI.D_E_L_E_T_=''"   
	Else
		return
	EndIf
EndIf

cQuery += " ORDER BY ZI_DATA"
aList1 := {} 
aList2 := {}    
aList3 := {}    
aList2B := {}    

If Select("TRB") > 0
	dbSelectArea("TRB")
	DbCloseArea()
EndIf

MemoWrite("TTAUDT02.SQL",cQuery)
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
dbSelectArea("TRB")
     

While !EOF() 
	If Ascan(aList1,{|x| Alltrim(x[1]) == Alltrim(TRB->ZI_PATRIMO)}) == 0
	    Aadd(aList1,{TRB->ZI_PATRIMO,Alltrim(TRB->N1_DESCRIC),TRB->A1_COD+TRB->A1_LOJA+" - "+Alltrim(TRB->A1_NOME)+" - "+Alltrim(TRB->A1_NREDUZ),;
	    				TRB->N1_XLOCINS,TRB->N1_XSISPG,TRB->N1_XCLIENT,TRB->N1_XLOJA,TRB->N1_XLIMTRO})
	EndIf
    //'1=Sangria','2=Abastecimento','3=Ajuste+ S','4=Ajuste- S','5=Ajuste+ A','6=Ajuste- A'
    If TRB->ZI_TIPO $ '0/1/3/4/8/9'  //7
    	//Venda
    	If "RECARGA" $ TRB->N1_DESCRIC //.OR. "SM=1" $ TRB->N1_XSISPG
    		If VAL(TRB->ZN_LOGC01) < VAL(TRB->LOGCANT1) .OR. VAL(TRB->ZN_LOGC02) < VAL(TRB->LOGCANT2)
    			nVlr := VAL(TRB->ZN_LOGC01) + VAL(TRB->ZN_LOGC02) + VAL(TRB->ZN_LOGC03) + VAL(TRB->ZN_LOGC04)
    			cCashSM := cvaltochar((VAL(TRB->ZN_LOGC01)+VAL(TRB->ZN_LOGC02)+VAL(TRB->ZN_LOGC03)+VAL(TRB->ZN_LOGC04))) 
    		Else	
    			nVlr := (VAL(TRB->ZN_LOGC01)-VAL(TRB->LOGCANT1)) + (VAL(TRB->ZN_LOGC02)-VAL(TRB->LOGCANT2)) + (VAL(TRB->ZN_LOGC03)-VAL(TRB->LOGCANT3)) + (VAL(TRB->ZN_LOGC04)-VAL(TRB->LOGCANT4))
		    	cCashSM := cvaltochar((VAL(TRB->ZN_LOGC01)+VAL(TRB->ZN_LOGC02)+VAL(TRB->ZN_LOGC03)+VAL(TRB->ZN_LOGC04)) - (VAL(TRB->LOGCANT1)+VAL(TRB->LOGCANT2)+VAL(TRB->LOGCANT3)+VAL(TRB->LOGCANT4)))
		    EndIf        
		    nVlr := substr(cvaltochar(nVlr),1,len(cvaltochar(nVlr))-2)+','+right(cvaltochar(nVlr),2)
		Else
			nVlr := TRB->ZI_SLDCTA 
			cCashSM := ''
		EndIf  
		If Ascan(aList2B,{|x| x[2]+x[3]+x[12] == cvaltochar(stod(TRB->ZI_DATA))+substr(aTipos[Ascan(aTipos,{|x| substr(x,1,1) == TRB->ZI_TIPO})],3)+TRB->ZI_PATRIMO}) == 0    	
			Aadd(aList2B,{.T.,cvaltochar(stod(TRB->ZI_DATA)),substr(aTipos[Ascan(aTipos,{|x| substr(x,1,1) == TRB->ZI_TIPO})],3),;
						If(TRB->ZI_TIPO=="1",0,TRB->ZI_VLRAJU),TRB->ZI_LIMTRO,TRB->ZI_VLRTRO,TRB->ZI_TROSAN,TRB->ZI_VLRSAN,;
						If(!Empty(cCashSM),cCashSM,TRB->ZI_CNTCAS),;
						nVlr,TRB->ZI_FDOTRO,TRB->ZI_PATRIMO,TRB->REG,TRB->ZN_HORA,TRB->REGZN}) 
		EndIf
    EndIF
    
	DbSkip()
EndDo

If len(aList1) < 1 
	Aadd(aList1,{'','',''})
EndIf                      

If len(aList2) < 1
	Aadd(aList2,{.F.,'','',0,0,0,0,0,'','',0,'','','','',''})
EndIf


If len(aList3) < 1
	Aadd(aList3,{.T.,'','','','','','','','','','','','','','',''})
EndIf

	oList1:SetArray(aList1)
	oList1:bLine := {||{aList1[oList1:nAt,01],; 
	 					 aList1[oList1:nAt,02]}} 


    Cabec()  
    FHelp(oList1:nAt)
	oList1:refresh()
	//oList2:refresh()
	oDlg1:refresh()

return           

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTAUDT02  บAutor  ณMicrosiga           บ Data ณ  08/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Informacoes do cabecalho da rotina                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Cabec()
    
Local aAux := {}
Local cAux := ''
Local cBarra := ''
Local cPOS	:=	''

oSay1:setText("")
oSay2:setText("")
oSay3:setText("")
oSay4:setText("")

If len(aList1) > 0 .And. !Empty(aList1[1,1])
	oSay1:settext("Modelo - "+aList1[oList1:nAt,02])
	oSay2:settext("Cliente - "+aList1[oList1:nAt,03])
	oSay3:settext("Local Fisico de instala็ใo - "+aList1[oList1:nAt,04]) 
	
	If !Empty(aList1[oList1:nAt,05])
		aAux := strtokarr(aList1[oList1:nAt,05],"|")
		
		For nX := 1 to len(aAux)
			If "1" $ aAux[nX]
				cAux += cBarra + substr(aAux[nX],1,2)
				cBarra := "/"
			EndIf
		Next nX
	EndIf
	cPOS := STATICCALL(TTFINC24,POSPatr,aList1[oList1:nAt,01])
	oSay4:settext("Sistema de Pagamento - "+If(Empty(cAux),'Nenhum',cAux)+If(!Empty(cPOS),' - POS '+cPOS,''))  
	
	
Else
	oSay1:setText("Modelo")
	oSay2:setText("Cliente")
	oSay3:setText("Local Fisico de instala็ใo")
	oSay4:setText("Sistema de Pagamento")		
EndIf

Return  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTAUDT02  บAutor  ณMicrosiga           บ Data ณ  08/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Informacoes da tela                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FHelp(nLinha)

Local aAux := {}
Local aAux2:= {}

If !Empty(aList1[nLinha,01])      
    aList2 := {}
	For nX := 1 to len(aList2B)
		If aList2B[nX,12] == aList1[nLinha,01]
			Aadd(aList2,aList2B[nX])
		EndIf
	Next nX
	
	For nX := 1 to len(aList2)
		aAux2 := ReprocAnt(If(!Empty(cPatr),cPatr,aList2[nX,12]),aList2[nX,02])
 		nVenda 	:= val(aList2[nX,09]) - If(len(aAux2)>0,aAux2[1,3],0) 
	 	nVenda := val(substr(cvaltochar(nVenda),1,len(cvaltochar(nVenda))-2)+"."+right(cvaltochar(nVenda),2))
		If len(aAux2) > 0 .And. !"Ajuste" $ aList2[nX,03] 
			aList2[nX,10] := nVenda //(aList2[nX,09] - aAux2[1,3])/100
		EndIf
	Next nX
	
	oBtn1:enable()
	oBtn2:enable()
	oBtn3:enable()
	oBtn4:enable()
	oBtn6:enable()
Else
	oBtn1:disable()
	oBtn2:disable()
	oBtn3:disable()   
	oBtn4:disable()
	oBtn6:disable()
EndIf

  
	oList2:SetArray(aList2)
	oList2:bLine := {||{If(aList2[oList2:nAt,01],oOk,oNo),; 
	 					 aList2[oList2:nAt,02],;
	 					 aList2[oList2:nAt,03],; 
	 					 Transform(aList2[oList2:nAt,04],"@E 999,999,999.99"),;
	 					 Transform(aList2[oList2:nAt,05],"@E 999,999,999.99"),; 
	 					 Transform(aList2[oList2:nAt,06],"@E 999,999,999.99"),;
	 					 Transform(aList2[oList2:nAt,07],"@E 999,999,999.99"),; 
	 					 Transform(aList2[oList2:nAt,08],"@E 999,999,999.99"),;
	 					 aList2[oList2:nAt,09],; 
	 					 Transform(aList2[oList2:nAt,10],"@E 999,999,999.99"),;
	 					 Transform(aList2[oList2:nAt,11],"@E 999,999,999.99")}} 
	 					   
	Cabec()
	oList2:nAt := len(aList2)
	oList2:refresh() 

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTAUDT02  บAutor  ณMicrosiga           บ Data ณ  08/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Ajustes de valores                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Ajuste()

Local aArea	:=	GetArea()
Local oTela,oGrupo,oS1,oS2,oS3,oCBox1,oGt1,oMGet1,oBotao1,oBotao2
Local aCombo := {"","3=Acr้scimo Sangria","4=Desconto Sangria","5=Acr้scimo Abast.","6=Desconto Abast."}
Local xCombo := aCombo[1]
Local nValor := 0 
Local dData	:= ctod('  /  /  ')     
Local cMotivo := space(255)
Local nOpc 	:= 0 
Local nFdtr	:=	0
Local cMsg	:=	'Ajuste realizado pelo usuแrio '+cusername+' no dia '+cvaltochar(ddatabase)+' as '+cvaltochar(time())+chr(13)+chr(10)

oTela      := MSDialog():New( 113,301,510,675,"Movimento de Ajuste",,,.F.,,,,,,.T.,,,.T. )

oGrupo      := TGroup():New( 004,004,156,176,"Dados",oTela,CLR_BLACK,CLR_WHITE,.T.,.F. )

	oS1      := TSay():New( 020,020,{||"Tipo de Ajuste"},oGrupo,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
	oCBox1     := TComboBox():New( 020,060,{|u| If(Pcount()>0,xCombo:=u,xCombo)},aCombo,072,010,oGrupo,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )

	oS2      := TSay():New( 040,020,{||"Valor"},oGrupo,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oGt1      := TGet():New( 040,060,{|u|If(PCount()>0,nValor:=u,nValor)},oGrupo,072,008,'@E 999,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
    
	oS4      := TSay():New( 060,020,{||"Data"},oGrupo,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oGt2      := TGet():New( 060,060,{|u|If(PCount()>0,dData:=u,dData)},oGrupo,072,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

	oS3      := TSay():New( 076,076,{||"Motivo"},oGrupo,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,008)
	oMGet1     := TMultiGet():New( 088,020,{|u| If(Pcount()>0,cMotivo:=u,cMotivo)},oGrupo,144,063,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )

oBotao1      := TButton():New( 168,040,"Confirmar",oTela,{||oTela:end(nOpc:=1)},037,012,,,,.T.,,"",,,,.F. )
oBotao2      := TButton():New( 168,100,"Cancelar",oTela,{||oTela:end(nOpc:=0)},037,012,,,,.T.,,"",,,,.F. )

oTela:Activate(,,,.T.)

If nOpc == 1
	If Empty(xCombo) .Or. nValor = 0 .Or. Empty(cMotivo)
		MsgAlert("Os 3 campos devem ser preenchidos","TTAUDT02") 
	Else 
		nFdtr := saldofd(aList1[oList1:nAt,01],dData,RECNO(),.T.)
		nFdtr := nFdtr + If(substr(xCombo,1,1)$"4/6",nValor*(-1),nValor)
		Reclock("SZI",.T.)
		SZI->ZI_FILIAL := xFilial("SZI")
		SZI->ZI_PATRIMO := aList1[oList1:nAt,01]
		SZI->ZI_DATA	:=	dData
		SZI->ZI_TIPO	:=	substr(xCombo,1,1)
		SZI->ZI_VLRAJU	:=	nValor
		SZI->ZI_FDOTRO	:=	nFdtr	
		SZI->ZI_CLIENTE	:= 	aList1[oList1:nAt,06]
		SZI->ZI_LOJA	:=	aList1[oList1:nAt,07]
		SZI->ZI_MOTIVO	:=	cMsg+cMotivo
		nRec			:=	Recno()
		SZI->(Msunlock())
		 
		Aadd(aList2B,{.T.,cvaltochar(dData),substr(aTipos[Ascan(aTipos,{|x| substr(x,1,1) == substr(xCombo,1,1)})],3),;
				nValor,aList1[oList1:nAt,08],0,0,0,'',0,nFdtr,SZI->ZI_PATRIMO,;
				nRec,''})  
		
		Asort(aList2B,,,{|x,y| ctod(x[2])+x[13] < ctod(y[2])+y[13]})		
 		//Carrega os dados novamente apos fazer o ajuste
		procura(1)                                     
		//Reprocessa o fundo de troco apos carregar os dados na tela.
		Reprocessa(aList1[oList1:nAt,01],.T.)                 
		
	EndIf
EndIf

RestArea(aArea)

Return                

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTAUDT02  บAutor  ณMicrosiga           บ Data ณ  08/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Saldo do Fundo de troco anterior ao lancamento            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function saldofd(cPatr,dia,nRec,lRep)

Local aArea	:=	GetArea()
Local cQuery 
Local nRet	:=	0                          
Default lRep := .F.

cQuery := "SELECT TOP 1 ZI_FDOTRO AS SALDO FROM "+RetSQLName("SZI")+" WHERE ZI_PATRIMO='"+cPatr+"' AND ZI_DATA <"+if(lRep,"=","")+"'"+DTOS(dia)+"'"
If nRec <> 0
	cQuery += " AND R_E_C_N_O_<>"+cvaltochar(nRec)+" 
EndIf
cQuery += " AND D_E_L_E_T_='' AND ZI_TIPO<>'7' ORDER BY ZI_DATA DESC,R_E_C_N_O_ DESC"

If Select("TRB") > 0
	dbSelectArea("TRB")
	DbCloseArea()
EndIf

MemoWrite("TTAUDT02.SQL",cQuery)
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
dbSelectArea("TRB")

nRet := TRB->SALDO

RestArea(aArea)

Return(nRet)     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTAUDT02  บAutor  ณMicrosiga           บ Data ณ  10/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Reprocessamento dos saldos de fundo de troco.            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Reprocessa(cPatr,lAj)

Local aArea	:=	GetArea()
Local cQuery 
Local aAnt	:=	{}
Local aAux	:=	{}
Local dDia1
Local dDia2 
Local nVlrPOS	:=	0 
Local dDiaLim
Local nDiaAux	:=	0	
Local nResAju	:=	0   
Local nLimTro	:=	Posicione("SN1",2,xFilial("SN1")+cPatr,"N1_XLIMTRO")  
Local cSmart	:=	Posicione("SN1",2,xFilial("SN1")+cPatr,"N1_XSISPG")  
Default lAj		:=	.F.

dDiaLim := CorteRep(if(!Empty(cPatr),cPatr,aList2[1,12])) 

If aList2[1,2] == dtoc(stod(dDiaLim))
	lAj := .T.
EndIf

aAnt 	:= ReprocAnt(if(!Empty(cPatr),cPatr,aList2[1,12]),aList2[1,2],lAj)
                     
For nX := 1 to len(aList2)
    
    aAux  := {}
	
	If aList2[nX,05] == 0
		aList2[nX,05] := nLimTro
	EndIf
	                                                  
 	If nX == len(aList2)
		dDia1 := dtos(CTOD(aList2[nX-1,02]))
		dDia2 := dtos(CTOD(aList2[nX,02]))
	else
 		dDia1 := If(nX==1,If(len(aAnt)==0,dtos(CTOD(aList2[nX,02])),aAnt[1,1]),dtos(CTOD(aList2[nX-1,02])))
		dDia2 := dtos(CTOD(aList2[nX,02])) //If(nX==1,dtos(CTOD(aList2[nX,02])),dtos(CTOD(aList2[nX,02])))
	EndIf
 	
 	If dDia2 <= dDiaLim 
 		If "Ajuste" $ aList2[nX,03]	
 			nResAju := aList2[nX,04]
 			If "-"  $ aList2[nX,03]	
 				nResAju := nResAju * (-1)
 			EndIf
 		EndIf
 		loop
 	Else   
 	    If Ascan(aList2,{|x| x[2] == cvaltochar(stod(dDia1))}) > 0
	 		If 'Ajuste' $ aList2[Ascan(aList2,{|x| x[2] == cvaltochar(stod(dDia1))}),03]
				//If Ascan(aList2,{|x| x[2] == cvaltochar(stod(dDia1))}) - 1 > 0
					dDia1 := dtos(ctod(aList2[Ascan(aList2,{|x| x[2] == cvaltochar(stod(dDia1))}) ,02]))  //- 1
					nDiaAux := 1
				//EndIf
			EndIf 			
		EndIf
 	EndIf
 	
	cQuery := "SELECT ZN_DATA,ZN_HORA,ZN_COTCASH,ZN_MOEDA1R,ZN_NOTA01,ZN_TROCO,ZN_NOTA02,ZN_LOGC01,ZN_LOGC02,ZN_TIPMAQ,ZN_LOGC03,ZN_LOGC04"
	cQuery += " FROM "+RetSQLName("SZN")
	cQuery += " WHERE ZN_PATRIMO='"+if(!Empty(cPatr),cPatr,aList2[nX,12])+"'"
	cQuery += " AND ZN_DATA BETWEEN '"+dDia1+"' AND '"+dDia2+"'"
	cQuery += " AND D_E_L_E_T_='' AND ZN_AGENTE<>'' AND ZN_NUMOS<>'' AND ZN_TIPINCL IN('SANGRIA','AUDITORIA')"
	cQuery += " ORDER BY ZN_DATA DESC" 
	
	If Select("TRB") > 0
		dbSelectArea("TRB")
		DbCloseArea()
	EndIf
		
	MemoWrite("ReprocAnt.SQL",cQuery)
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
	dbSelectArea("TRB")

	While !EOF()   
					//    1				3				3				4				5			6				7				8				9           10              11             12
        Aadd(aAux,{TRB->ZN_DATA,TRB->ZN_HORA,TRB->ZN_COTCASH,TRB->ZN_MOEDA1R,TRB->ZN_NOTA01,TRB->ZN_TROCO,TRB->ZN_LOGC01,TRB->ZN_LOGC02,TRB->ZN_TIPMAQ,TRB->ZN_LOGC03,TRB->ZN_LOGC04,TRB->ZN_NOTA02})
 		Dbskip()
 	EndDo
 	    
 	If len(aAux) == 2
	 	nVlrPOS := VendaPOS(if(!Empty(cPatr),cPatr,aList2[nX,12]),aAux)
	 	
	 	If "RECARGA" $ Alltrim(aAux[1,9]) //.OR. "SM=1" $ cSmart
    		If VAL(aAux[1,7]) < VAL(aAux[2,7]) .OR. VAL(aAux[1,8]) < VAL(aAux[2,8])
    			nVlr := VAL(aAux[1,7]) + VAL(aAux[1,8]) + VAL(aAux[1,10])+VAL(aAux[1,11]) //VAL(TRB->ZN_LOGC01) + VAL(TRB->ZN_LOGC02) + VAL(TRB->ZN_LOGC03) + VAL(TRB->ZN_LOGC04)
    			cCashSM := cvaltochar((VAL(TRB->ZN_LOGC01)+VAL(TRB->ZN_LOGC02)+VAL(TRB->ZN_LOGC03)+VAL(TRB->ZN_LOGC04))) 
    		Else	
			 	nVlr := (VAL(aAux[1,7])-VAL(aAux[2,7])) + (VAL(aAux[1,8])-VAL(aAux[2,8])) + (VAL(aAux[1,10])-VAL(aAux[2,10])) + (VAL(aAux[1,11])-VAL(aAux[2,11]))  
	    	EndIf
	    	nVlr := substr(cvaltochar(nVlr),1,len(cvaltochar(nVlr))-2)+','+right(cvaltochar(nVlr),2)
		
	 		nVenda	:= val(strtran(nVlr,",",".")) //nVlr 
	 	Else
	 		nVenda 	:= aAux[1,3] - aAux[2,3]
		 	nVenda := val(substr(cvaltochar(nVenda),1,len(cvaltochar(nVenda))-2)+"."+right(cvaltochar(nVenda),2))
	 	EndIf
        
		If nX <> 1
		 	nFdoAnt := aList2[Ascan(aList2,{|x| cvaltochar(x[2]) == cvaltochar(stod(dDia1))}),11]
		else
			nFdoAnt := 0
		endif  
		
		If nDiaAux == 1
			nFdoAnt := aList2[Ascan(aList2,{|x| x[2] == cvaltochar(stod(dDiaLim))}),11]   
			nDiaAux := 0
		EndIf

	 	nSangria:= (aAux[1,4]+aAux[1,5]) + nVlrPOS
	 	nTroco 	:= aAux[1,6]
	 	nFdoTro := (nTroco+nFdoAnt) +(nVenda-nSangria) + nResAju//(nVenda+nTroco+nFdoAnt) - nSangria
		nResAju	:=	0
	 	aList2[Ascan(aList2,{|x| cvaltochar(x[2]) == cvaltochar(stod(dDia2))}),01] := .F.
	 	aList2[Ascan(aList2,{|x| cvaltochar(x[2]) == cvaltochar(stod(dDia2))}),08] := nSangria
	 	aList2[Ascan(aList2,{|x| cvaltochar(x[2]) == cvaltochar(stod(dDia2))}),10] := nVenda
	 	aList2[Ascan(aList2,{|x| cvaltochar(x[2]) == cvaltochar(stod(dDia2))}),11] := nFdoTro
	 	oList2:refresh()
	 	oDlg1:refresh()
 	Else
 		cQuery := "SELECT * FROM "+RetSQLName("SZI")
		cQuery += " WHERE ZI_PATRIMO='"+if(!Empty(cPatr),cPatr,aList2[nX,12])+"'"
		cQuery += " AND ZI_DATA BETWEEN '"+dDia1+"' AND '"+dDia2+"' AND D_E_L_E_T_=''"
		cQuery += " ORDER BY ZI_DATA DESC"
		
		If Select("TRB") > 0
			dbSelectArea("TRB")
			DbCloseArea()
		EndIf
			
		MemoWrite("ReprocAnt.SQL",cQuery)
		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
		dbSelectArea("TRB")
	
		While !EOF()   
			If Ascan(aAux,{|x| x[1] == TRB->ZI_DATA}) == 0
		        Aadd(aAux,{TRB->ZI_DATA,'',TRB->ZI_CNTCAS,0,0,0,'','','','',''})
		 	EndIf
	 		Dbskip()
	 	EndDo
	 	
	 	If len(aAux) > 1
	 		nVlrPOS := VendaPOS(if(!Empty(cPatr),cPatr,aList2[nX,12]),aAux)
	 	Else
	 		nVlrPOS := 0
	 	EndIf
	 	
	 	If "RECARGA" $ Alltrim(aAux[1,9]) //.OR. "SM=1" $ cSmart
    		If VAL(aAux[1,7]) < VAL(aAux[2,7]) .OR. VAL(aAux[1,8]) < VAL(aAux[2,8])
    			nVlr := VAL(aAux[1,7]) + VAL(aAux[1,8]) + VAL(aAux[1,10])+VAL(aAux[1,11]) //VAL(TRB->ZN_LOGC01) + VAL(TRB->ZN_LOGC02) + VAL(TRB->ZN_LOGC03) + VAL(TRB->ZN_LOGC04)
    			cCashSM := cvaltochar((VAL(TRB->ZN_LOGC01)+VAL(TRB->ZN_LOGC02)+VAL(TRB->ZN_LOGC03)+VAL(TRB->ZN_LOGC04))) 
    		Else
    			If Empty(aAux[2,7]) .Or. Empty(aAux[2,8]) 
    				nVlr := (VAL(aAux[1,7]) + VAL(aAux[1,8]) + VAL(aAux[1,10])+VAL(aAux[1,11])) - val(aList2[Ascan(aList2,{|x| x[2] == cvaltochar(stod(dDia1))})-1,09])
    			else
			 		nVlr := (VAL(aAux[1,7])-VAL(aAux[2,7])) + (VAL(aAux[1,8])-VAL(aAux[2,8])) + (VAL(aAux[1,10])-VAL(aAux[2,10])) + (VAL(aAux[1,11])-VAL(aAux[2,11]))  
				EndIf
	    	EndIf
	    	nVlr := substr(cvaltochar(nVlr),1,len(cvaltochar(nVlr))-2)+','+right(cvaltochar(nVlr),2)
		
	 		nVenda	:= val(strtran(nVlr,",",".")) //nVlr 
	 	Else  
	 		If len(aAux) > 1
		 		nVenda 	:= If(Valtype(aAux[1,3])=="C",val(aAux[1,3]),aAux[1,3]) - If(Valtype(aAux[2,3])=="C",val(aAux[2,3]),aAux[2,3])
			 	nVenda := val(substr(cvaltochar(nVenda),1,len(cvaltochar(nVenda))-2)+"."+right(cvaltochar(nVenda),2))
			 Else
			 	nVenda := 0
			 EndIf
	 	EndIf
        
		If nX <> 1
		 	nFdoAnt := aList2[Ascan(aList2,{|x| cvaltochar(x[2]) == cvaltochar(stod(dDia1))}),11]
		else
			nFdoAnt := 0
		endif  
		
		If nDiaAux == 1
			nFdoAnt := aList2[Ascan(aList2,{|x| x[2] == cvaltochar(stod(dDiaLim))}),11]   
			nDiaAux := 0
		EndIf

	 	nSangria:= (aAux[1,4]+aAux[1,5]) + nVlrPOS
	 	nTroco 	:= aAux[1,6]
	 	nFdoTro := (nTroco+nFdoAnt) +(nVenda-nSangria) ///+ nResAju//(nVenda+nTroco+nFdoAnt) - nSangria
		nResAju	:=	0
	 	aList2[Ascan(aList2,{|x| cvaltochar(x[2]) == cvaltochar(stod(dDia2))}),01] := .F.
	 	aList2[Ascan(aList2,{|x| cvaltochar(x[2]) == cvaltochar(stod(dDia2))}),08] := nSangria
	 	aList2[Ascan(aList2,{|x| cvaltochar(x[2]) == cvaltochar(stod(dDia2))}),10] := nVenda
	 	aList2[Ascan(aList2,{|x| cvaltochar(x[2]) == cvaltochar(stod(dDia2))}),11] := nFdoTro
	 	oList2:refresh()
	 	oDlg1:refresh()
 	EndIf
Next nX	 

RestArea(aArea)

Return                                  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTAUDT02  บAutor  ณMicrosiga           บ Data ณ  10/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Busca o registro anterior ao primeiro que aparece na grid.บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ReprocAnt(cPat,ddia,lAj)

Local aArea	:=	GetArea()
Local cQuery
Local aRet	:=	{}  
Default lAj := .F.


cQuery := "SELECT TOP 1 ZN_DATA,ZN_HORA,ZN_COTCASH"
cQuery += " FROM "+RetSQLName("SZN")+" WHERE ZN_PATRIMO='"+cPat+"'"
cQuery += " AND ZN_DATA<"+if(lAj,"=","")+"'"+dtos(ctod(ddia))+"'"
cQuery += " AND D_E_L_E_T_='' AND ZN_AGENTE<>'' AND ZN_TIPINCL IN('SANGRIA','AUDITORIA')" 
cQuery += " ORDER BY ZN_DATA DESC"

If Select("TRB") > 0
	dbSelectArea("TRB")
	DbCloseArea()
EndIf

MemoWrite("ReprocAnt.SQL",cQuery)
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
dbSelectArea("TRB")

While !EOF()
    Aadd(aRet,{TRB->ZN_DATA,TRB->ZN_HORA,TRB->ZN_COTCASH})
	DbSkip()
EndDo
              

RefrshOS()

RestArea(aArea)

Return(aRet)                      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTAUDT02  บAutor  ณMicrosiga           บ Data ณ  10/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Venda em POS do Patrimonio                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VendaPOS(cPatr,aValor)

Local aArea		:=	GetArea()
Local nValor 	:=	0
Local cQuery


// REVISAR ESSA CONSULTA

cQuery := "SELECT ZZE_DATATR,ZZE_HORATR,ZZE_VLRBRU"
cQuery += " FROM "+RetSQLName("ZZE")
cQuery += " WHERE ZZE_PATRIM='"+cPatr+"' AND ZZE_DATATR BETWEEN '"+aValor[2,1]+"' AND '"+aValor[1,1]+"'"
cQuery += " AND ZZE_ESTTRA LIKE 'EFETUADA%' AND D_E_L_E_T_=''"	
cQuery += " ORDER BY ZZE_DATATR,ZZE_HORATR"

If Select("TRBP") > 0
	dbSelectArea("TRBP")
	DbCloseArea()
EndIf

MemoWrite("VendaPOS.SQL",cQuery)
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRBP",.F.,.T.)
dbSelectArea("TRBP")

While !EOF()
	If (TRBP->ZZE_DATATR+substr(TRBP->ZZE_HORATR,1,5) >= aValor[2,1]+aValor[2,2]) .And. ;
		(TRBP->ZZE_DATATR+substr(TRBP->ZZE_HORATR,1,5) <= aValor[1,1]+aValor[1,2]) 
		nValor += TRBP->ZZE_VLRBRU
	EndIf
	
	Dbskip()
EndDo

RestArea(aArea)

Return(nValor)                                                  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTAUDT02  บAutor  ณMicrosiga           บ Data ณ  10/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Grava as alteracoes realizadas pela rotina no banco.      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Gravar()

Local aArea	:=	GetArea()
      
/*
 1					2										3
.T.,cvaltochar(stod(TRB->ZI_DATA)),substr(aTipos[Ascan(aTipos,{|x| substr(x,1,1) == TRB->ZI_TIPO})],3),; 
                                          4						  5				6				7			  8				9
					If(TRB->ZI_TIPO=="1",0,TRB->ZI_VLRAJU),TRB->ZI_LIMTRO,TRB->ZI_VLRTRO,TRB->ZI_TROSAN,TRB->ZI_VLRSAN,TRB->ZI_CNTCAS,;
											10					
					If("RECARGA" $ TRB->N1_DESCRIC,nVlr,TRB->ZI_SLDCTA),;                             
					      11				12		  13		 14
					TRB->ZI_FDOTRO,TRB->ZI_PATRIMO,TRB->REG,TRB->ZN_HORA
*/
For nX := 1 to len(aList2)
	If !aList2[nX,01]
		DbSelectArea("SZI")
		DbGoto(aList2[nX,13])
		Reclock("SZI",.F.)
		SZI->ZI_VLRSAN := aList2[nX,08]
		SZI->ZI_FDOTRO := aList2[nX,11]
		SZI->(Msunlock())              
		aList2[nX,01] := .T.
		oBtn3:disable()
	EndIf
Next nX

RestArea(aArea)

Return                                     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTAUDT02  บAutor  ณMicrosiga           บ Data ณ  10/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Corte para reprocessar saldos de fundo de troco.          บฑฑ
ฑฑบ          ณdeve buscar do ultimo ajuste em diante somente.             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CorteRep(cPatr)

Local aArea	:=	GetArea()
Local cQuery
Local dDiaRet

cQuery := "SELECT TOP 1 ZI_DATA FROM "+RetSQLName("SZI")
cQuery += " WHERE ZI_TIPO IN('3','4','8') AND ZI_PATRIMO='"+cPatr+"'"
cQuery += " AND D_E_L_E_T_=''"
cQuery += " ORDER BY ZI_DATA DESC"

If Select("TRB") > 0
	dbSelectArea("TRB")
	DbCloseArea()
EndIf

MemoWrite("CorteRep.SQL",cQuery)
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
dbSelectArea("TRB")

dDiaRet := TRB->ZI_DATA

RestArea(aArea)

Return(dDiaRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTAUDT02  บAutor  ณMicrosiga           บ Data ณ  11/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Geracao da OS de Auditoria financeira no patrimonio.       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GerarAud()

Local aArea		:=	GetArea()
Local aDoc		:=	{}
Local aInfLacre	:=	{}
Local cPatrim	:=	aList1[oList1:nAt,01]
Local cCliente	:=	substr(aList1[oList1:nAt,03],1,6)
Local cLoja		:=	substr(aList1[oList1:nAt,03],7,4)                 
Local cTec		:=	space(6) 
Local cDatAd	:=	ctod(' / / ')
Local oDlg1Adt,oSay1Adt,oCBox1Adt,oSBtn1Adt,oGet1Adt,oGet2Adt,oSay2Adt,oSay3Adt
Local cNumOS := ""
Local aDados := {}
Local aInfo := {}
Local nJ
Local cEndereco := ""
Local cLocal := ""



oDlg1Adt      := MSDialog():New( 091,232,238,520,"Auditoria",,,.F.,,,,,,.T.,,,.T. )
oSay1Adt      := TSay():New( 012,044,{||"Escolha o Auditor"},oDlg1Adt,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)

	oSay2Adt      := TSay():New( 028,010,{||"Auditor"},oDlg1Adt,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
	oGet1Adt      := TGet():New( 028,032,{|u|If(PCount()>0,cTec:=u,cTec)},oDlg1Adt,030,008,'',{||If(!Empty(cTec) .and. !Empty(cDatAd),oSBtn1Adt:enable(),oSBtn1Adt:disable())},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"AA1","",,)

	oSay3Adt      := TSay():New( 028,072,{||"Data"},oDlg1Adt,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
	oGet2Adt      := TGet():New( 028,092,{|u|If(PCount()>0,cDatAd:=u,cDatAd)},oDlg1Adt,030,008,'',{||If(!Empty(cTec) .and. !Empty(cDatAd),oSBtn1Adt:enable(),oSBtn1Adt:disable())},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSBtn1Adt     := SButton():New( 048,052,1,{||oDlg1Adt:end()},oDlg1Adt,,"OK", )
oSBtn1Adt:disable()

oDlg1Adt:Activate(,,,.T.)

If !Empty(cTec)
	
	aInfo := {}
	aInfLacre := STATICCALL( TTPROC30, dlgLacre,cPatrim )
	
	For nJ := 1 To Len( aInfLacre )
		AADD( aInfo, { aInfLacre[nJ][1],aInfLacre[nJ][2] } )
	Next nJ 

	
	dbSelectArea("AA1")
	dbSetOrder(1)
	dbSeek( xFilial("AA1") +AvKey(cTec,"AA1_CODTEC") )
	
	dbSelectArea("SN1")
	dbSetOrder(2)
	dbSeek( xFilial("SN1") +avKey(cPatrim,"N1_CHAPA") )
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek( xFilial("SA1") +AvKey(cCliente,"A1_COD") +AvKey(cLoja,"A1_LOJA") )
	
	dbSelectArea("ZZ1")
	dbSetOrder(1)                 
	If dbSeek( xFilial("ZZ1") +AvKey(SN1->N1_XPA,"ZZ1_COD") )
		cEndereco := AllTrim(ZZ1->ZZ1_END) +"," +AllTrim(ZZ1->ZZ1_MUN) +"," +AllTrim(ZZ1->ZZ1_EST) 
		cLocal := AllTrim(ZZ1->ZZ1_DESCRI)
	EndIf
			
	
	aDados := { "03",;
				"AUDITORIA",;
				cTec,;
				AllTrim(AA1->AA1_NOMTEC),;
				AllTrim(cPatrim),;
				AllTrim(SN1->N1_DESCRIC),;
				"",;
				"",;
				cDatAd,;
				"18:00:00",;
				AllTrim(ZZ1->ZZ1_DESCRI),;
				cEndereco,;
				"",;
				"Mensagem",;
				AllTrim(AA1->AA1_LOCAL),;
				cLocal,;
				"",;
				"",;
				"",;
				cCliente,;
				cLoja,;
				aInfo,;
				SN1->N1_PRODUTO,;
				SN1->N1_XPA }
							

	cNumOS := U_MOBILE( aDados )
	If !Empty( cNumOS )
		MsgInfo( "OS criada: " +cNumOS )
	EndIf
                
	RefrshOS()
EndIf
	
RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTAUDT02  บAutor  ณMicrosiga           บ Data ณ  11/17/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Corrigir contadores ou deletar registros.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function corrigir(nSelec)

Local aArea	:=	GetArea()

If nSelec == 1

ElseIf nSelec == 2
   /*	DbSelectArea("SZN")
	Dbgoto(aList2[oList2:nAt,15])
	Reclock("SZN",.F.)
	dbdelete()
	SZN->(Msunlock())
	DbSelectArea("SZI")
	Dbgoto(aList2[oList2:nAt,13])
	Reclock("SZI",.F.)
	dbdelete()
	SZI->(Msunlock())
	
	Adel(aList2,oList2:nAt)
	Asize(aList2,len(aList2)-1)
	
	//Carrega os dados novamente apos fazer o ajuste
	Reprocessa(aList1[oList1:nAt,01],.T.)          */
EndIf

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTAUDT02  บAutor  ณMicrosiga           บ Data ณ  11/18/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio de Auditoria                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Relato()

Local aArea	:=	GetArea()
Local nPos 	:=	Ascan(aList2,{|x| Alltrim(x[3]) == "Auditoria"})

ccpatrim()

For nX := len(aList2) to 1 step -1
	If Alltrim(aList2[nX,03]) == "Auditoria"
		nPos := nX 
		exit
	ENDIF
NEXT nX

If nPos > 0
	U_TTPROR41(aList1[oList1:nAt,01],aList2[nPos-1,13],aList2[nPos,13],aList2) 
EndIf
                                    
RestArea(aArea)

Return    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTAUDT02  บAutor  ณMicrosiga           บ Data ณ  12/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime o conta corrente do patrimonio marcado.            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ccpatrim()

Local oExcel := FWMSEXCEL():New()
Local cTitulo := "Conta_Corrente"
Local cDir := ""
Local cArqXls := "ContaCorrente.xml" 
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

oExcel:AddworkSheet("Conta_Corrente") 

oExcel:AddTable ("Conta_Corrente","Patrimonio_"+aList1[oList1:nAt,01])

oExcel:AddColumn("Conta_Corrente","Patrimonio_"+aList1[oList1:nAt,01],"Data",1,1)
oExcel:AddColumn("Conta_Corrente","Patrimonio_"+aList1[oList1:nAt,01],"Tipo",1,1)
oExcel:AddColumn("Conta_Corrente","Patrimonio_"+aList1[oList1:nAt,01],"Ajuste",1,1)
oExcel:AddColumn("Conta_Corrente","Patrimonio_"+aList1[oList1:nAt,01],"Limite_Troco",1,1)
oExcel:AddColumn("Conta_Corrente","Patrimonio_"+aList1[oList1:nAt,01],"Troco_Abastecido",1,1)
oExcel:AddColumn("Conta_Corrente","Patrimonio_"+aList1[oList1:nAt,01],"Troco_Sangrado",1,1)
oExcel:AddColumn("Conta_Corrente","Patrimonio_"+aList1[oList1:nAt,01],"Valor_Sangrado",1,1)
oExcel:AddColumn("Conta_Corrente","Patrimonio_"+aList1[oList1:nAt,01],"Contador_Cash",1,1)
oExcel:AddColumn("Conta_Corrente","Patrimonio_"+aList1[oList1:nAt,01],"Venda",1,1)
oExcel:AddColumn("Conta_Corrente","Patrimonio_"+aList1[oList1:nAt,01],"Fundo_Troco",1,1)

For nX := 1 to len(aList2)
	oExcel:AddRow("Conta_Corrente","Patrimonio_"+aList1[oList1:nAt,01],{aList2[nX,02],;
													 					 aList2[nX,03],; 
													 					 Transform(aList2[nX,04],"@E 999,999,999.99"),;
													 					 Transform(aList2[nX,05],"@E 999,999,999.99"),; 
													 					 Transform(aList2[nX,06],"@E 999,999,999.99"),;
													 					 Transform(aList2[nX,07],"@E 999,999,999.99"),; 
													 					 Transform(aList2[nX,08],"@E 999,999,999.99"),;
													 					 aList2[nX,09],; 
													 					 Transform(aList2[nX,10],"@E 999,999,999.99"),;
													 					 Transform(aList2[nX,11],"@E 999,999,999.99")})
Next nX
				
oExcel:Activate()

oExcel:GetXMLFile(cDir +cArqXls)

If File(cDir +cArqXls)
	Aviso("TTAUDT02","A planilha foi gerada em "+cDir,{"Ok"})
	If !ApOleClient( 'MsExcel' )
		Aviso("TTAUDT02", 'MsExcel nใo instalado. ' +CRLF +'O arquivo estแ em: '+cDir )
	Else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cDir +cArqXls )
		oExcelApp:SetVisible(.T.)         
		oExcelApp:Destroy()
	EndIf
EndIf  

Return


// status da ultima OS gerada
Static Function RefrshOS()
                             
Local cQuery := ""
                  
cQuery := "SELECT TOP 1 * FROM " +RetSqlName("SZG")
cQuery += " WHERE ZG_PATRIM = '"+cPatr+"' AND ZG_FORM = '03' AND ZG_DESCFRM = 'AUDITORIA' AND D_E_L_E_T_ = '' "
cQuery += " ORDER BY ZG_DTCRIAC DESC, ZG_HRCRIAC DESC "
                                                       
MpSysOpenQuery(cQuery,"TRB")

dbSelectArea("TRB")


oSOS:SetText("OS Auditoria " +AllTrim(TRB->ZG_NUMOS))

If AllTrim( TRB->ZG_STATUS ) == "OPEN"
	oOSStat:SetBmp( "BR_BRANCO" )
ElseIf AllTrim( TRB->ZG_STATUS ) == "ACTE"    
	oOSStat:SetBmp( "BR_AMARELO" )     
ElseIf AllTrim( TRB->ZG_STATUS ) == "INIC"
	oOSStat:SetBmp( "BR_VIOLETA" )
ElseIf AllTrim( TRB->ZG_STATUS ) == "COPE"
	oOSStat:SetBmp( "BR_MARROM" )
ElseIf AllTrim( TRB->ZG_STATUS ) == "CTEC"
    oOSStat:SetBmp( "BR_CINZA" )                            
ElseIf AllTrim( TRB->ZG_STATUS ) == "FIOK"
	oOSStat:SetBmp( "BR_VERDE" )
EndIf

TRB->(dbCloseArea())

Return  