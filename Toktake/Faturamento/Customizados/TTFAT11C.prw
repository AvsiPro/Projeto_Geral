#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'  
#INCLUDE 'TBICONN.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ TTFAT11C ณ Autor ณ Alexandre Venancio    ณ Data ณ 14/03/13 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณLocacao   ณ                  ณContato ณ                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ  Agenda PCA                                                ณฑฑ
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
ฑฑณJackson Ezidioณ19/05/15ณ      | Ajustes no funcionamento               ณฑฑ
ฑฑณ              ณ  /  /  ณ      |                                        ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function TTFAT11C()
                             
Local nOpc	:=	0

SetPrvt("oDlg1","oGrp1","oBrw1","oGrp2","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oSay7","oSay8")
SetPrvt("oGet1","oGet2","oCBox1","oCBox2","oCBox3","oGet3","oCBox4","oGet4","oCBox5","oBtn1","oBtn2") 
Private oList
Private aList	:=	{}  
Private aPAs		:=	{}                  
Private oList2
Private aList2	:=	{}    
Private aEstRPa	:=	{}                
Private aNrSem1	:=	{}
Private aNrSem2	:=	{}
Private nSemMes	      
Private dDatad	:=	ctod(' / / ')
Private dDatat	:=	ctod(' / / ') 
Private cPaFil	:=	space(6)
Private aAbaste	:=	{''}       
Private aStatus	:=	{'','Em Aberto','Em Andamento','Aguardar'} 
Private aTipoe	:=	{"Todos","Carga Seca","Refrigerado e Iogurte","Lanche","Uso e Consumo"}  
Private aListCp	:=	{}
Private xCombo1	:=	aAbaste[1]
Private xCombo2	:=	aStatus[1]
Private xCombo3	:=	aTipoe[1]

If cEmpAnt <> "01"
	Return
EndIf
//Prepare Environment Empresa "01" Filial "01" Tables "ZZ1/SC5/SC6" 

LeadTime()  

PreAtend()

PreAcols()

//aList := aClone(aPAs)
For nX := 1 to len(aPAs)
	If Ascan(aList,{|x| x[4]+x[6] == aPAs[nX,04]+aPAs[nX,06]}) == 0
		Aadd(aList,aPAs[nX])
	EndIf
Next nX
        
aListCp := aClone(aList)

For nX := 1 to len(aList)
	If Ascan(aAbaste,aList[nX,08]) == 0
		Aadd(aAbaste,aList[nX,08])
	EndIf
Next nX

oDlg1      := MSDialog():New( 091,223,660,1227,"Agenda - PCA",,,.F.,,,,,,.T.,,,.T. )

oGrp1      := TGroup():New( 008,008,196,488,"Agenda da Semana",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

	oList := TCBrowse():New(020,016,460,170,, {'Status','Data','Entrega','PA','Protocolo','Estoque','Armaz้m','Abastecedor','Observa็ใo'},{30,40,40,30,30,30,60,60,30},;
	                            oGrp1,,,,{|| },{|| produtos(oList:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,)
	oList:SetArray(aList)
	oList:bLine := {||{ aList[oList:nAt,01],; 
	 					 aList[oList:nAt,02],;
	 					 aList[oList:nAt,03],;
	                     aList[oList:nAt,04],;
	                     aList[oList:nAt,05],;
	                     aList[oList:nAt,06],;
	                     aList[oList:nAt,07],;
	                     aList[oList:nAt,08],;
	                     aList[oList:nAt,09]}}
/*
oGrp2      := TGroup():New( 200,008,252,488,"Filtros",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

	oSay1      := TSay():New( 212,016,{||"Data Entrega"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oGet1      := TGet():New( 212,051,{|u| If(Pcount()>0,dDatad:=u,dDatad)},oGrp2,045,008,'',{||If(!empty(dDatad),dDatat:=dDatad,)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	oSay2      := TSay():New( 212,100,{||"A"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,004,008)
	oGet2      := TGet():New( 212,108,{|u| If(Pcount()>0,dDatat:=u,dDatat)},oGrp2,045,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	
	oSay3      := TSay():New( 212,168,{||"Abastecedor"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oCBox1     := TComboBox():New( 212,204,{|u| If(Pcount()>0,xCombo1:=u,xCombo1)},aAbaste,072,010,oGrp2,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
	
	oSay8      := TSay():New( 212,284,{||"PA"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oGet4      := TGet():New( 212,304,{|u| If(Pcount()>0,cPaFil:=u,cPaFil)},oGrp2,060,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZZ1","",,)

	//oSay4      := TSay():New( 212,284,{||"Filial"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,008)
	//oCBox2     := TComboBox():New( 212,304,,,072,010,oGrp2,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
	
	//oSay5      := TSay():New( 212,384,{||"Celula"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
	//oCBox3     := TComboBox():New( 212,404,,,072,010,oGrp2,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
	
	oSay6      := TSay():New( 232,016,{||"Tipo Estoque"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
	//oGet3      := TGet():New( 232,052,,oGrp2,045,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	oCBox3     := TComboBox():New( 232,052,{|u| If(Pcount()>0,xCombo3:=u,xCombo3)},aTipoE,072,010,oGrp2,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
	
	oSay7      := TSay():New( 232,168,{||"Status"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
	oCBox4     := TComboBox():New( 232,204,{|u| If(Pcount()>0,xCombo2:=u,xCombo2)},aStatus,072,010,oGrp2,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
	
	//oSay8      := TSay():New( 232,217,{||"Protocolo"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	//oGet4      := TGet():New( 232,251,,oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	
	//oSay9      := TSay():New( 232,322,{||"Entrega"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	//oCBox5     := TComboBox():New( 232,349,,,072,010,oGrp2,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )

	oBtn1      := TButton():New( 212,432,"Filtrar",oGrp2,{||filtro(1)},037,008,,,,.T.,,"",,,,.F. )
	oBtn4      := TButton():New( 222,432,"Limpar",oGrp2,{||filtro(0)},037,008,,,,.T.,,"",,,,.F. )
*/
oBtn2      := TButton():New( 260,128,"Gerar Pedidos",oDlg1,{||oDlg1:end(nOpc:=1)},037,012,,,,.T.,,"",,,,.F. )
oBtn3      := TButton():New( 260,215,"SNP",oDlg1,{||snp(oList:nAt)},037,012,,,,.T.,,"",,,,.F. )         
oBtn4      := TButton():New( 260,304,"Sair",oDlg1,{||oDlg1:end(nOpc:=0)},037,012,,,,.T.,,"",,,,.F. )         

oDlg1:Activate(,,,.T.)

If nOpc == 1
	Processa({ || GerarPV()},OEMToAnsi("Aguarde, gerando pedidos"))
EndIf

Return  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT11C  บAutor  ณMicrosiga           บ Data ณ  03/14/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Produtos da Pa em atendimento                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Produtos()
    
Local nOpc	:=	0 
Local clrf	:=	chr(13)+chr(10)                                             
SetPrvt("oDlg2","oGrp1","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oGrp2","oBrw1","oBtn1","oBtn2") 
SetPrvt("oSay7","oSay8","oSay9","oSay10","oSay11","oSay12","oSay13","oSay14")

aList2 := {}
        
If len(aList[oList:nAt]) > 14
	For nX := 1 to len(aPAs)
		If aPAs[nX,04]+aPAs[nX,06] == aList[oList:nAt,04]+aList[oList:nAt,06]
			Aadd(aEstRPa,{aPAs[nX,04],aPAs[nX,14],Posicione("SB1",1,xFilial("SB1")+aPAs[nX,14],"B1_DESC"),;
						aPAs[nX,15],aPAs[nX,16],aPAs[nX,17],aPAs[nX,18],aPAs[nX,19],;
						aPAs[nX,20],aPAs[nX,21],aPAs[nX,22],aPAs[nX,23],aPAs[nX,24],;
						aPAs[nX,25],aPAs[nX,26],0,0,Posicione("SB2",1,xFilial("SB2")+aPAs[nX,14]+aPAs[nX,04],"B2_XESTREG"),0}) 
			aEstRPa[len(aEstRPa),16] := (aEstRPa[len(aEstRPa),13]) * 1.10
		EndIf                                                                                                                       
	Next nX
Else
	PreItens(aList[oList:nAt,04],aList[oList:nAt,06])
	For nX := 1 to 12
		Aadd(aList[oList:nAt],0)
	Next nX
	Aadd(aList[oList:nAT],.T.)
EndIf

For nX := 1 to len(aEstRPa)
	If aEstRPa[nX,01] == aList[oList:nAt,04]
		Aadd(aList2,aEstRPa[nX])
	EndIf
Next nX

If len(aList2) < 1
	MsgAlert("Nใo hแ produtos cadastrados no estoque regulador para este tipo de estoque.","TTFAT11C")
	Return
EndIf

Asort(aList2,,,{|x,y| x[2] < y[2]})  

oDlg2      := MSDialog():New( 091,205,589,1266,"Pedido de Abastecimento",,,.F.,,,,,,.T.,,,.T. )

oGrp1      := TGroup():New( 004,008,092,516,"Informa็๕es da PA",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )

	oSay1      := TSay():New( 016,056,{||"Cliente"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,008)  
	oSay7      := TSay():New( 016,114,{||Posicione("SA1",1,xFilial("SA1")+aList[oList:nAt,12],"A1_NOME")},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,400,008)
	
	oSay2      := TSay():New( 028,064,{||"PA"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,008,008) 
	oSay8	   := TSay():New( 028,114,{||aList[oList:nAt,04]+" - "+aList[oList:nAt,07]},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,200,008) 
	
	oSay3      := TSay():New( 040,021,{||"Estoque Regulador"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,054,008)
	oSay13     := TSay():New( 040,114,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,024,008)
	
	oSay4      := TSay():New( 052,021,{||"Endere็o de Entrega"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
	oSay10     := TSay():New( 052,114,{||aList[oList:nAt,10]},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,400,008)
	
	oSay5      := TSay():New( 064,058,{||"Bairro"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,008)
	oSay11     := TSay():New( 064,114,{||aList[oList:nAt,11]},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,400,008)
	
	oSay6      := TSay():New( 076,033,{||"Tipo de Estoque"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
	oSay11     := TSay():New( 076,114,{||aList[oList:nAt,06]},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,400,008)

oGrp2      := TGroup():New( 096,008,220,516,"Produtos",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
	
	oList2 := TCBrowse():New(106,012,500,110,, {'C๓digo','Descri็ใo','Faturado'+clrf+'M-2','Faturado'+clrf+'M-1','Remessa'+clrf+'M-2','Remessa'+clrf+'M-1','Remessa'+clrf+'M๊s','Perdas','Rem.(-3)','Rem.(-2)','Rem.(-1)','Consumo'+clrf+'Perํodo','Qtd','Pedido'},{30,90,25,25,25,25,25,25,25,25,25,20,25,25},;
	                            oGrp2,,,,{||EstReg()},{|| editcol()},, ,,,  ,,.F.,,.T.,,.F.,,,)
	oList2:SetArray(aList2)
	oList2:bLine := {||{ aList2[oList2:nAt,02],; 
	 					 aList2[oList2:nAt,03],;
	 					 aList2[oList2:nAt,04],;
	                     aList2[oList2:nAt,05],;
	                     aList2[oList2:nAt,06],;
	                     aList2[oList2:nAt,07],;
	                     aList2[oList2:nAt,08],;
	                     aList2[oList2:nAt,09],;
	                     aList2[oList2:nAt,10],;
	                     aList2[oList2:nAt,11],;
	                     aList2[oList2:nAt,12],;
	                     aList2[oList2:nAt,13],;
	                     aList2[oList2:nAt,14],;
	                     aList2[oList2:nAt,15]}}

oBtn1      := TButton():New( 226,182,"Confirmar",oDlg2,{||oDlg2:end(nOpc:=1)},037,010,,,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 226,306,"Cancelar",oDlg2,{||oDlg2:end(nOpc:=0)},037,010,,,,.T.,,"",,,,.F. )
               
oDlg2:Activate(,,,.T.)

If nOpc == 1
	Gravar()
EndIf


Return                                                              

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT11C  บAutor  ณMicrosiga           บ Data ณ  04/23/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function EstReg()

oSay13:settext("")
oDlg2:refresh()
oSay13:settext(cvaltochar(aList2[oList2:nAt,18]))      

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT11C  บAutor  ณMicrosiga           บ Data ณ  04/22/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Buscando primeiro os itens em atendimento.                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PreAtend()

Local cQuery
Local cTipo :=	''

cQuery := "SELECT ZO.*,ZZ1_END,ZZ1_BAIRRO,ZZ1_ITCONT,ZZ1_XAGEND FROM "+RetSQLName("SZO")+" ZO"
cQuery += " INNER JOIN "+RetSQLName("ZZ1")+" Z1 ON ZZ1_FILIAL=ZO_FILIAL AND ZZ1_COD=ZO_CODPA AND Z1.D_E_L_E_T_=''"
cQuery += " WHERE ZO_FILIAL='"+xFilial("SZO")+"' AND ZO_PEDIDO='' AND ZO.D_E_L_E_T_=''"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("TTFAT11C.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB") 

While !EOF()   
	cTipo := If(TRB->ZO_TIPEST=="CS",'Carga Seca',If(TRB->ZO_TIPEST=="RI",'Refrigerado e Iogurte',If(TRB->ZO_TIPEST=="LC",'Lanche','Uso e Consumo')))
		
	//If Ascan(aPAs,{|x| x[4]+x[6] == TRB->ZO_CODPA+cTipo}) == 0           
		Aadd(aPAs,{'Em Andamento',cvaltochar(stod(TRB->ZO_DATEMIS)),cvaltochar(stod(TRB->ZO_DATENT)),TRB->ZO_CODPA,'',cTipo,Alltrim(TRB->ZO_DESCARM),;
					Alltrim(TRB->ZO_ABASTEC),TRB->ZO_OBSERVA,TRB->ZZ1_END,TRB->ZZ1_BAIRRO,TRB->ZZ1_ITCONT,TRB->ZZ1_XAGEND,;
					TRB->ZO_CODPRO,TRB->ZO_FATM2,TRB->ZO_FATM1,TRB->ZO_REMM2,TRB->ZO_REMM1,TRB->ZO_REMMA,TRB->ZO_PERDAS,TRB->ZO_REMA3,TRB->ZO_REMA2,;
					TRB->ZO_REMA1,TRB->ZO_CP,TRB->ZO_ESTOQUE,TRB->ZO_QTDPED,.T.})                                                  
	//EndIf
	Dbskip()
EndDo
	
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT11C  บAutor  ณMicrosiga           บ Data ณ  03/14/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Buscando PAs para compor a agenda do PCA                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PreAcols()

Local cQuery
Local aAux1		:=	{}
Local aAux2 	:=	{}
Local cTipC		:=	''  
Local cLt
Local cDse         
Local cDEnt
Local cDsa		:=	dow(ddatabase)
Local nSoma		:=	0
Local nCntLt	:=	0
Local nCntSm	:=	nSemMes 
Local lCheg		:=	.F.
Local lMes2		:=	.F.
Local dDatEnt	:=	ctod('  /  /  ')

//PAดs habilitadas no sistema
cQuery := "SELECT B2_LOCAL,ZZ1_DESCRI,ZZ1_XNOMAT,ZZ1_TELEFO,ZZ1_END,ZZ1_BAIRRO,ZZ1_ITCONT,ZZ1_XAGEND,COUNT(*)"
cQuery += " FROM "+RetSQLName("SB2")+" B2"
cQuery += " INNER JOIN "+RetSQLName("ZZ1")+" Z1 ON ZZ1_COD=B2_LOCAL AND ZZ1_XAGEND<>'' AND Z1.D_E_L_E_T_=''"
cQuery += " WHERE B2_FILIAL='"+xFilial("ZZ1")+"' AND B2_XESTREG>0"
cQuery += " AND B2.D_E_L_E_T_='' AND B2_LOCAL BETWEEN 'P00000' AND 'PZZZZZZ'"
cQuery += " GROUP BY B2_LOCAL,ZZ1_DESCRI,ZZ1_XNOMAT,ZZ1_TELEFO,ZZ1_END,ZZ1_BAIRRO,ZZ1_ITCONT,ZZ1_XAGEND"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("TTFAT11C.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB") 

While !EOF()
	//Entregas mensais que ocorrem em determinada semana do mes.
	If substr(TRB->ZZ1_XAGEND,7,3) == "Men" .And. val(substr(TRB->ZZ1_XAGEND,10,1)) != nSemMes 
		DbSkip()
		loop
	EndIf                                                        
	
	//Verificando os tipos de Estoques com o Lead Time de cada um
	aAux1 := strtokarr(substr(TRB->ZZ1_XAGEND,11,30),",")
	//If TRB->B2_LOCAL == "P01447"
	//	msgalert("chegou")
	//EndIf
	
	For nX := 1 to len(aAux1)
		aAux2 := strtokarr(aAux1[nX],"|")   
		
		cDsa		:=	dow(ddatabase)
		nSoma		:=	0
		nCntLt	:=	0
		nCntSm	:=	nSemMes 
		lCheg		:=	.F.
		lMes2		:=	.F.
		dDatEnt	:=	ctod('  /  /  ') 
		                    
		//LT - Lead Time da liga็ใo para realizar a Entrega (D+x)
		cLt := substr(aAux2[2],2,1)  
		cDEnt	:=	substr(TRB->ZZ1_XAGEND,1,6)
		nCont 	:= cDsa
		nQtdD   := 0
		//Determinando o DSE - Dia da Semana da Entrega
      	nCP := cDsa //- 1
      	nCC := 0 
      	cDse := 0
      	For nX := nCP to 6
      		If nX == 6
      			nX := 1
      		EndIf
      		nCC++	
      		If nCC == val(cLt)
      			If substr(cDEnt,nX,1) == "1"
      				cDse := nX
      			EndIf
  				nX := 7
  				lCheg := .T.
      		EndIf
      	Next nX
        
		If cDse == 0
			loop
			DbSkip()
		EndIf
	   /*	For nX := 1 to 5
			If nCont > 5
				nCont := 2
			EndIf
			If nX == val(cLt)
				cDse := nX 
				nX := 7
				lCheg := .T.
			EndIf
			nCont++
		Next nX*/
	
		/*While !lCheg
	   		If nCont > 5
	   			nCont := 1
	   		EndIf
	   		
	   		If substr(cDEnt,nCont,1) == "1"
	   			cDse := nCont + 1
	   			nQtdD++
	   			If nQtdD == val(cLt)
		   			lCheg := .T.
		   		EndIf
	   		EndIf
	   		nCont++			
		EndDo*/
		//Verificando se a data de entrega da PA esta dentro do Lead Time da ligacao (data da ligacao)
		While nCntLt < val(cLt)
			nSoma := cDsa + 1
			If nSoma > 6
				cDsa := 2
				nSoma := 2
				nCntSm++
				If nCntSm > 5 .Or. nCntSm > len(aNrSem1)
					nCntSm := 1
					lMes2	:= .T.
				EndIf
			EndIf
			cDsa++
			nCntLt++		
		EndDo 
		//Se a soma cair no sabado entao a entrega e na segunda
		If nSoma > 6 .And. cDsa == 2
			nSoma := 2
		EndIf
			
		If Empty(aNrSem1[nCntSm,nSoma])
			If nCntSm >= len(aNrSem1)
				nCntSm := 1
				lMes2	:= .T.
			Endif
		EndIf
               
		If lMes2
			dDatEnt := aNrSem2[nCntSm,nSoma] //
		Else                    
			If (!empty(aNrSem1[nCntSm,nSoma]) .And. aNrSem1[nCntSm,nSoma] >= ddatabase) .Or. aNrSem1[nSemMes,nSoma] > dDatabase
				If aNrSem1[nSemMes,nSoma] > dDatabase
					dDatEnt := aNrSem1[nSemMes,nSoma]
				Else
					dDatEnt := aNrSem1[nCntSm,nSoma]
				EndIf
			Else
				nCntSm++
				If nCntSm > 5 .Or. nCntSm > len(aNrSem1)
					nCntSm := 1
				EndIf
				If !empty(aNrSem1[nCntSm,nSoma])
					dDatEnt := aNrSem1[nCntSm,nSoma]
				Else
					dDatEnt := aNrSem2[nCntSm,nSoma]
				EndIf
			EndIf
		EndIf
        
		//So devem trazer as PAs que o dia da semana da entrega, batem com a soma anterior.
	    If substr(cDEnt,cDse,1) == "1" //cDse == nSoma
	    	cTipC	:=	If(aAux2[1]=="CS",'Carga Seca',If(aAux2[1]=="RI",'Refrigerado e Iogurte',If(aAux2[1]=="LC",'Lanche','Uso e Consumo')))
	    	cGer 	:= 	POSICIONE("SZO",2,XFILIAL("SZO")+TRB->B2_LOCAL+aAux2[1]+dtos(dDatEnt),"ZO_PEDIDO")
	    	If Ascan(aPAs,{|x| x[4]+x[6] = TRB->B2_LOCAL+cTipC}) == 0 .And. empty(cGer)
				Aadd(aPAs,{'Em Aberto',cvaltochar(dDataBase),cvaltochar(dDatEnt),TRB->B2_LOCAL,'',cTipC,Alltrim(TRB->ZZ1_DESCRI),Alltrim(TRB->ZZ1_XNOMAT),TRB->ZZ1_TELEFO,TRB->ZZ1_END,TRB->ZZ1_BAIRRO,TRB->ZZ1_ITCONT,TRB->ZZ1_XAGEND,aAux2[1]}) //,0,0,0,0,0,0,0,0,0,0,0,0,.T.})
			EndIf
		EndIf
	Next nX
	
	DbSkip()
EndDo

Asort(aPAs,,,{|x,y| x[4] < y[4]})                                
                  
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT11C  บAutor  ณMicrosiga           บ Data ณ  03/15/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Carregando os dados dos produtos da pa selecionada.       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PreItens(cPa,cLocE)                    

Local nPos		:=	0       
Local cMes1		:= 	STRZERO(If(MONTH(DDATABASE)-2 < 1,MONTH(DDATABASE)-2+12,MONTH(DDATABASE)-2),2)
Local cAno1		:=	If(MONTH(DDATABASE)- 2 < 1,year(ddatabase)-1,year(ddatabase))
//Local cUltD1	:=	dtos(Lastday(stod(cvaltochar(cAno)+cMes+'01')))
Local cMes2		:=	If(val(cMes1)+1>12,'01',STRZERO(val(cMes1)+1,2))
Local cAno2		:=	If(val(cMes1)+1>12,cAno1+1,cAno1)
Local cUltD		:=	dtos(Lastday(stod(cvaltochar(cAno2)+cMes2+'01'))) 
Local cAux		:=	''
Local aAux		:=	{}
Local cTipE		:=	cLocE
Local cLocE		:=	If(cLocE=="Carga Seca","D00001",If(cLocE=="Lanche","D00006",If(Substr(cLocE,1,5)=="Refri","D00001","D00002")))
Local aUltEst	:=	{}

//Zera o array para cada tipo de estoque      
aEstRPa := {}

//Estoque Regulador
cQuery := "SELECT B2_COD,B2_QATU,B2_RESERVA,B2_LOCAL,B1_DESC,B2_XESTREG
cQuery += " FROM "+RetSQLName("SB2")+" B2"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=B2_COD AND B1_LOCPAD='"+cLocE+"' AND B1.D_E_L_E_T_=''"
cQuery += " WHERE B2_FILIAL='"+xFilial("SB2")+"'"
cQuery += " AND B2_LOCAL='"+cPA+"' AND B2.D_E_L_E_T_='' AND B2_XESTREG>0"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("TTFAT11C.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB") 
                               
While !EOF()                                     
	Aadd(aEstRPa,{TRB->B2_LOCAL,TRB->B2_COD,TRB->B1_DESC,0,0,0,0,0,;
					0,0,0,0,0,0,0,0,TRB->B2_QATU-TRB->B2_RESERVA,TRB->B2_XESTREG,ROUND(TRB->B2_XESTREG*0.1,0),0,0,0,0,0,0,0,.T.})
	DbSkip()
EndDo

//Faturados nos ultimos dois meses
cQuery := "SELECT C6_LOCAL,C5_XFINAL,C6_PRODUTO,B1_DESC,SUBSTRING(C6_DATFAT,5,2) AS MES,SUM(C6_QTDVEN) AS QTD"
cQuery += " FROM "+RetSQLName("SC6")+" C6"
cQuery += " INNER JOIN "+RetSQLName("SC5")+" C5 ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM AND C5.D_E_L_E_T_=''"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=C6_PRODUTO AND B1_LOCPAD='"+cLocE+"' AND B1.D_E_L_E_T_=''"
cQuery += " WHERE C6_FILIAL='"+xFilial("SC6")+"' AND C6.D_E_L_E_T_=''"
cQuery += " AND C6_PRODUTO IN(SELECT B2_COD FROM "+RetSQLName("SB2")+" WHERE B2_FILIAL='"+xFilial("SB2")+"' AND B2_XESTREG>0" 
cQuery += "		AND B2_LOCAL IN('"+cPA+"') AND D_E_L_E_T_='')"
cQuery += " AND C6_DATFAT BETWEEN '"+cvaltochar(cAno1)+cMes1+"01' AND '"+cUltD+"'"
cQuery += " AND C6_LOCAL IN('"+cPA+"')"
cQuery += " GROUP BY C6_LOCAL,C5_XFINAL,C6_PRODUTO,B1_DESC,SUBSTRING(C6_DATFAT,5,2)"


If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("TTFAT11C.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB") 

While !EOF()                                     
	nPos := Ascan(aEstRPa,{|x| x[1]+x[2] == TRB->C6_LOCAL+TRB->C6_PRODUTO})
	/*If nPos == 0 
		Aadd(aEstRPa,{TRB->C6_LOCAL,TRB->C6_PRODUTO,TRB->B1_DESC,IF(TRB->C5_XFINAL=="2" .AND. TRB->MES == cMes1,TRB->QTD,0),;
						IF(TRB->C5_XFINAL=="2" .AND. TRB->MES == cMes2,TRB->QTD,0),0,0,0,;
						IF(TRB->C5_XFINAL=="L",TRB->QTD,0),0,0,0,0,0,0,0,0,0,0,0})
	Else*/
	If nPos > 0
		aEstRPa[nPos,04] += IF(TRB->C5_XFINAL=="2" .AND. TRB->MES == cMes1,TRB->QTD,0)
		aEstRPa[nPos,05] += IF(TRB->C5_XFINAL=="2" .AND. TRB->MES == cMes2,TRB->QTD,0)
		aEstRPa[nPos,09] += IF(TRB->C5_XFINAL=="L",TRB->QTD,0) 
	EndIf
	Dbskip()
Enddo

//REMESSAS
cQuery := "SELECT C6_PRODUTO,C6_LOCAL,SUBSTRING(C6_DATFAT,5,2) AS MES,SUM(C6_QTDVEN) AS QTD"
cQuery += " FROM "+RetSQLName("SC6")+" C6"
cQuery += " INNER JOIN "+RetSQLName("SC5")+" C5 ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM AND C5_NOTA<>'' AND C5_EMISSAO BETWEEN '"+cvaltochar(cAno1)+cMes1+"01' AND '"+DTOS(DDATABASE)+"' AND C5_XCODPA IN('"+cPA+"') AND C5.D_E_L_E_T_=''"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=C6_PRODUTO AND B1_LOCPAD='"+cLocE+"' AND B1.D_E_L_E_T_=''"
cQuery += " WHERE C6_NOTA<>'' AND C6_LOCAL<>'"+cPA+"'"
cQuery += " AND C6.D_E_L_E_T_=''"
cQuery += " AND C6_FILIAL='"+xFilial("SC6")+"'"
cQuery += " GROUP BY C6_PRODUTO,C6_LOCAL,SUBSTRING(C6_DATFAT,5,2)"
cQuery += " ORDER BY C6_PRODUTO"
      
If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("TTFAT11C.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB") 
While !EOF()                                     
	nPos := Ascan(aEstRPa,{|x| x[1]+x[2] == cPa+TRB->C6_PRODUTO})
	/*If nPos == 0 
		Aadd(aEstRPa,{cPa,TRB->C6_PRODUTO,Posicione("SB1",1,xFilial("SB1")+TRB->C6_PRODUTO,"B1_DESC"),0,;
						0,IF(TRB->MES == cMes1,TRB->QTD,0),IF(TRB->MES == cMes2,TRB->QTD,0),;
						IF(TRB->MES == STRZERO(MONTH(DDATABASE),2),TRB->QTD,0),;
						0,0,0,0,0,0,0,0,0,0,0,0,0})
	Else*/
	If nPos > 0
		aEstRPa[nPos,06] += IF(TRB->MES == cMes1,TRB->QTD,0)
		aEstRPa[nPos,07] += IF(TRB->MES == cMes2,TRB->QTD,0)
		aEstRPa[nPos,08] += IF(TRB->MES == STRZERO(MONTH(DDATABASE),2),TRB->QTD,0) 
	EndIf
	Dbskip()
Enddo

//Ultimas 3 remessas de cada produto para a Pa 
cVirg := ""
For nX := 1 to len(aEstRPa)  
	cAux += cVirg + aEstRPa[nX,02]
	cVirg := "','"
Next nX

cQuery := "SELECT C6_PRODUTO,C6_NUM,SUBSTRING(C6_DATFAT,5,4) AS REM,SUM(C6_QTDVEN) AS QTD"
cQuery += " FROM "+RetSQLName("SC6")+" C6" 
cQuery += " INNER JOIN "+RetSQLName("SC5")+" C5 ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM AND C5_XGPV='PCA' AND C5_NOTA<>'' AND C5_XCODPA IN('"+cPa+"') AND C5.D_E_L_E_T_='' AND C5_EMISSAO BETWEEN '"+cvaltochar(cAno1)+cMes1+"01' AND '"+dtos(dDataBase)+"'"
cQuery += " WHERE C6_NOTA<>'' AND C6.D_E_L_E_T_='' AND C6_FILIAL='"+xFilial("SC6")+"'"  
cQuery += " AND C6_PRODUTO IN ('"+cAux+"')"
cQuery += " GROUP BY C6_PRODUTO,C6_NUM,SUBSTRING(C6_DATFAT,5,4)"
cQuery += " ORDER BY C6_PRODUTO,SUBSTRING(C6_DATFAT,5,4) DESC"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("TTFAT11C.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB") 

nP	:=	1
cPr	:=	TRB->C6_PRODUTO

While !EOF()
	
	If nP > 3
		If cPr == TRB->C6_PRODUTO
			Dbskip()
			loop    
		Else
			nP := 1
			cPr := TRB->C6_PRODUTO
		EndIf
	EndIf
	
	If nP == 3                                                               	
		aEstRPa[Ascan(aEstRPa,{|x| x[2] = TRB->C6_PRODUTO}),12] += TRB->QTD
	ElseIf nP == 2
		aEstRPa[Ascan(aEstRPa,{|x| x[2] = TRB->C6_PRODUTO}),11] += TRB->QTD
	Else
		aEstRPa[Ascan(aEstRPa,{|x| x[2] = TRB->C6_PRODUTO}),10] += TRB->QTD
	EndIf
	nP++
	DbSkip()
EndDo
                 
cQuery := "SELECT ZO_CODPRO,ZO_ESTOQUE FROM "+RetSQLName("SZO")
cQuery += " WHERE ZO_FILIAL='"+xFilial("SZO")+"' AND ZO_CODPA='"+cPA+"' AND D_E_L_E_T_='' ORDER BY ZO_CODPRO,ZO_DATENT"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("TTFAT11C.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB") 
nC	:= 2

While !EOF()
	If nC > 3 .And. Ascan(aUltEst,{|x| x[1] == TRB->ZO_CODPRO}) > 0
		Dbskip()
		loop
	Else
		nC := 2
	EndIf
	If Ascan(aUltEst,{|x| x[1] == TRB->ZO_CODPRO}) == 0
	    Aadd(aUltEst,{TRB->ZO_CODPRO,TRB->ZO_ESTOQUE,0,0})
	Else
		aUltEst[Ascan(aUltEst,{|x| x[1] == TRB->ZO_CODPRO}),nC] := TRB->ZO_ESTOQUE
		nC++
	EndIf
	DbSkip()
EndDo

//Consumo Periodo
For nX := 1 to len(aEstRPa) 
	nPos := Ascan(aUltEst,{|x| x[1] == aEstRPa[nX,02]})
	aEstRPa[nX,13] := round(((aEstRPa[nX,10] - If(nPos>0,aUltEst[nPos,03],0)) + (aEstRPa[nX,11] - If(nPos>0,aUltEst[nPos,03],0)) + (aEstRPa[nX,12] - If(nPos>0,aUltEst[nPos,03],0)) - (aEstRPa[nX,09]/3)) / 3,0)
	aEstRPa[nX,16] := (aEstRPa[nX,13]) * 1.10
Next nX

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT11C  บAutor  ณMicrosiga           บ Data ณ  04/17/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Verifica o dia da semana e compara com o lead time        บฑฑ
ฑฑบ          ณcadastrado na agenda do pca.                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function LeadTime()

Local nCont		:=	1
Local cPDMC		:=	firstday(ddatabase)
Local cUDMC		:=	lastday(ddatabase)
Local cPDMS		:=	firstday(lastday(ddatabase)+1)
Local cUDMS		:=	lastday(lastday(ddatabase)+1)   
Local cNMes		:=	month(cPDMC)
            
Aadd(aNrSem1,{'','','','','','',''})      
Aadd(aNrSem2,{'','','','','','',''})      

For nX := cPDMC to cUDMS
	If DOW(nX) <> 1 .And. DOW(nX) <> 7
		If month(nX) == cNMes
			aNrSem1[len(aNrSem1),DOW(nX)] := nX
			nCont++
			If nCont > 5 .and. nX < cUDMC
				Aadd(aNrSem1,{'','','','','','',''})      
				nCont := 1
			EndIf 
		Else
			aNrSem2[len(aNrSem2),DOW(nX)] := nX
			nCont++
			If nCont > 5 .and. nX < cUDMS .And. !Empty(aNrSem2[len(aNrSem2),DOW(nX+1)]) 
				Aadd(aNrSem2,{'','','','','','',''})      
				nCont := 1
			EndIf
		EndIf
	EndIf
Next nX
  
For nX := 1 to len(aNrSem1)
	If Ascan(aNrSem1[nX],dDataBase) > 0
		nSemMes := nX
		exit
	EndIf
Next nX

Return                                                                           

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT11C  บAutor  ณAlexandre Venancio  บ Data ณ  04/22/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Editar as colunas de estoque "QTD" e pedido               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function editcol()

Local cBkp1	:=	aList2[oList2:nAt,13]
Local lPas	:=	.F.
                                     
aList2[oList2:nAt,13] := aList2[oList2:nAt,14]
lEditCell(aList2, oList2, "@R 9999",13)
aList2[oList2:nAt,14] := aList2[oList2:nAt,13]
aList2[oList2:nAt,13] := cBkp1

cBkp1 := aList2[oList2:nAt,14]
aList2[oList2:nAt,14] := aList2[oList2:nAt,16] - cBkp1   

lEditCell(aList2, oList2, "@R 9999",14)    
DbSelectArea("SB2")
Dbsetorder(1)
DbSeek(xFilial("SB2")+aList2[oList2:nAt,02]+Posicione("SB1",1,xFilial("SB1")+aList2[oList2:nAt,02],"B1_LOCPAD"))
nSaldo := SaldoSB2() 

If nSaldo < aList2[oList2:nAt,14]
	MsgAlert("Quantidade insuficiente em estoque para atender esta solicita็ใo"+chr(13)+chr(10)+"Saldo Disponํvel "+cvaltochar(nSaldo),"TTFAT11C - editcol")
EndIf    

aList2[oList2:nAt,15] := If(aList2[oList2:nAt,14]<0,0,round(aList2[oList2:nAt,14],0))
aList2[oList2:nAt,14] := cBkp1                                      


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT11C  บAutor  ณMicrosiga           บ Data ณ  04/22/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Gravando as informacoes parciais do atendimento da Pa     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Gravar()
      
Local lRet	:=	.T. 
Local nPos	:=	oList:nAt
Local cTipE	:=	If(aList[nPos,06]=="Carga Seca","CS",If(aList[nPos,06]=="Lanche","LC",If(Substr(aList[nPos,06],1,5)=="Refri","RI","UC")))
Local lFim	:=	.F.

//'Em Aberto',cvaltochar(dDataBase),cvaltochar(dDatEnt),TRB->B2_LOCAL,'',cTipC,Alltrim(TRB->ZZ1_DESCRI),Alltrim(TRB->ZZ1_XNOMAT),TRB->ZZ1_TELEFO,TRB->ZZ1_END,TRB->ZZ1_BAIRRO,TRB->ZZ1_ITCONT,TRB->ZZ1_XAGEND,aAux2[1]
//TRB->B2_LOCAL,TRB->B2_COD,TRB->B1_DESC,0,0,0,0,0,0,0,0,0,0,0,0,0,TRB->B2_QATU-TRB->B2_RESERVA,TRB->B2_XESTREG,ROUND(TRB->B2_XESTREG*0.1,0,pedido
    
If MsgYesNo("O Atendimento esta finalizado?","TTFAT11C - Gravar")
	lFim := .T.
EndIf  

//Estou jogando os dados do atendimento nesta tabela, para posterior geracao do pedido de venda
//Tambem porque o atendimento pode ser interrompido no meio e o que ja foi digitado assim nใo se perde.
DbSelectArea("SZO")
DbSetOrder(1)
For nX := 1 to len(aList2)
	If !DbSeek(xFilial("SZO")+aList[nPos,04]+aList2[nX,02]+DTOS(CTOD(aList[nPos,03]))) 
		Reclock("SZO",.T.)
  	Else
		Reclock("SZO",.F.)
	EndIf
	
	SZO->ZO_FILIAL	:= 	xFilial("SZO")
	SZO->ZO_CODPA	:=	aList[nPos,04]
	SZO->ZO_DATEMIS	:=	ctod(aList[nPos,02])
	SZO->ZO_DATENT	:=	ctod(aList[nPos,03])
	SZO->ZO_TIPEST	:=	If(len(aList[nPos])>14,cTipE,aList[nPos,14])
	SZO->ZO_DESCARM	:=	aList[nPos,07]
	SZO->ZO_ABASTEC	:=	aList[nPos,08]
	SZO->ZO_OBSERVA	:=	aList[nPos,09]
	SZO->ZO_CODPRO	:=	aList2[nX,02]
	SZO->ZO_FATM2	:=	aList2[nX,04]
	SZO->ZO_FATM1	:=	aList2[nX,05]
	SZO->ZO_REMM2	:=	aList2[nX,06]
	SZO->ZO_REMM1	:=	aList2[nX,07]
	SZO->ZO_REMMA	:=	aList2[nX,08]
	SZO->ZO_PERDAS	:=	aList2[nX,09]
	SZO->ZO_REMA3	:=	aList2[nX,10]
	SZO->ZO_REMA2	:=	aList2[nX,11]
	SZO->ZO_REMA1	:=	aList2[nX,12]
	SZO->ZO_CP		:=	aList2[nX,13]
	SZO->ZO_ESTOQUE	:=	aList2[nX,14]
	SZO->ZO_QTDPED	:=	aList2[nX,15]
	SZO->ZO_HORA	:=	substr(time(),1,5)
	SZO->ZO_USUARIO	:=	cusername
	SZO->ZO_FINAL	:=	If(lFim,"S","")
	SZO->(Msunlock())		
	
	SZO->(Msunlock())		
 
Next nX

aList[nPos,01] := 'Em Andamento'
oDlg1:refresh()

Return        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT11C  บAutor  ณMicrosiga           บ Data ณ  04/30/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function snp(nlinha)

Local aArea	:=	GetArea()
Local cTipE	:=	If(aList[nlinha,06]=="Carga Seca","CS",If(aList[nlinha,06]=="Lanche","LC",If(Substr(aList[nlinha,06],1,5)=="Refri","RI","UC")))

DbSelectArea("SZO")
DbSetOrder(2)   
If DbSeek(xFilial("SZO")+aList[nlinha,04]+cTipE+DTOS(CTOD(aList[nlinha,03]))) 
	While !EOF() .And. SZO->ZO_CODPA == aList[nlinha,04] .AND. SZO->ZO_TIPEST == cTipE .And. SZO->ZO_DATENT == CTOD(aList[nlinha,03])
		Reclock("SZO",.F.)
		SZO->ZO_PEDIDO	:=	"SNP"
		SZO->(Msunlock())
		Dbskip()
	EndDo
EndIf

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT11C  บAutor  ณMicrosiga           บ Data ณ  04/23/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Pedidos a serem faturados.                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GerarPV()

Local cQuery
Local aBlq		:= {}
Private aCab	:=	{}
Private aItm	:=	{}
Private aC5		:=	{}
Private aItens	:=	{}  
Private	lMsErroAuto	:=	.F.

cQuery := "SELECT ZO_CODPA,ZO_DATENT,ZO_TIPEST,ZO_CODPRO,ZO_QTDPED FROM "+RetSQLName("SZO")
cQuery += " WHERE ZO_FILIAL='"+xFilial("SZO")+"' AND ZO_QTDPED>0 AND ZO_FINAL='S' AND ZO_PEDIDO='' AND D_E_L_E_T_=''"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("TTFAT11C.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF() 
	If Ascan(aCab,{|x| x[1]+x[3] == TRB->ZO_CODPA+TRB->ZO_TIPEST}) == 0
	    Aadd(aCab,{TRB->ZO_CODPA,TRB->ZO_DATENT,TRB->ZO_TIPEST,''})
	EndIf
	
    Aadd(aItm,{TRB->ZO_CODPA,TRB->ZO_DATENT,TRB->ZO_TIPEST,TRB->ZO_CODPRO,TRB->ZO_QTDPED})
    
	DbSkip()
EndDo

For nX := 1 to len(aCab)
	
	//Caso a data de entrega esteja inferior ao dia da geracao do pedido, colocado esta validacao pois existem pedidos que demoram a serem gerados.
	If stod(aCab[nX,02]) < dDataBase 
		dDAnt	:= aCab[nX,02]
		aCab[nX,02] := NovaData(aCab[nX,01],aCab[nX,02])
		For nY := 1 to len(aItm)
			aItm[nY,02] := aCab[nX,02]
		Next nY
		cQuery := "UPDATE "+RetSQLName("SZO")+" SET ZO_DATENT='"+aCab[nX,02]+"'"
		cQuery += "	WHERE ZO_FILIAL='"+xFilial("SZO")+"' AND ZO_CODPA='"+aCab[nX,01]+"' AND ZO_DATENT='"+dDAnt+"' AND ZO_TIPEST='"+aCab[nX,03]+"' AND D_E_L_E_T_=''"
		TcSqlExec(cQuery)

	EndIf
	
	aC5 	:= ImpPCA(nX)
	aItens 	:= {}
	
	For nY := 1 to len(aItm)
		If aItm[nY,01]+aItm[nY,02]+aItm[nY,03] == aCab[nX,01]+aCab[nX,02]+aCab[nX,03]
			MontIt2(nY)
		EndIf
		// verifique produto bloqueado
		dbSelectArea("SB1")
		dbSetOrder(1)
		If dbSeek( xFilial("SB1") +AvKey(aItm[nY][4],"B1_COD") )
			If AllTrim(SB1->B1_MSBLQL) == "1"
				If RecLock("SB1",.F.)
					SB1->B1_MSBLQL := "2"
					SB1->(MsUnLock())
				EndIf
				
				AADD( aBlq, Recno() )
			EndIf
		EndIf
	Next nY
	
	aAreaC5 := GetArea()
	cNumPed := GetSx8Num("SC5","C5_NUM")	
	
	aC5[2,2] := cNumPed
	
	For nY := 1 to len(aItens)
		aItens[nY,02,02] := cNumPed
	Next nY
	
	MsExecAuto({|x, y, z| MATA410(x, y, z)}, aC5, aItens, 3)                    

	If lMsErroAuto
		MostraErro()  
	EndIF

	RestArea(aAreaC5)
	
	dbSelectArea("SC5")
	dbSetOrder(1)
	If dbSeek( xFilial("SC5") +AvKey(cNumPed,"C5_NUM") )
		ConfirmSX8()
	
		cQuery := "UPDATE "+RetSQLName("SZO")+" SET ZO_PEDIDO='"+cNumPed+"'"
		cQuery += "	WHERE ZO_FILIAL='"+xFilial("SZO")+"' AND ZO_CODPA='"+aCab[nX,01]+"' AND ZO_DATENT='"+aCab[nX,02]+"' AND ZO_TIPEST='"+aCab[nX,03]+"' AND D_E_L_E_T_=''"
		TcSqlExec(cQuery)
		aCab[nX,04] := cNumPed	
	Else
		RollBackSX8()
	EndIf	
Next nX
                   
If !Empty(aBlq)
	dbSelectArea("SB1")
	For nI := 1 To Len(aBlq)
		dbGoTo(aBlq[nI])
		If Recno() == aBlq[nI]
			If RecLock("SB1",.F.)
				SB1->B1_MSBLQL := "1"
				SB1->(MSUNLOCK())
			EndIf
		EndIf
	Next nI       
EndIf

GerarPdf()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT11C  บAutor  ณMicrosiga           บ Data ณ  04/23/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  G E R A C A O   D O   P E D I D O                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ImpPCA(nLinha)

Local aArea		:=	GetArea()
Local aCabec	:= {}    
Local cLocE		:=	If(aCab[nLinha,03]=="Carga Seca","D00001",If(aCab[nLinha,03]=="Lanche","D00006",If(Substr(aCab[nLinha,03],1,5)=="Refri","D00001","D00002")))
Local cTabelaZ	:=	Posicione("ZZ1",1,xFilial("ZZ1")+aCab[nLinha,01],"ZZ1_TAB_LA")
Local cTab		:=	space(3)
                         
If xFilial("SC5") <> "01"     
	If !empty(cTabelaZ)
		cTab := cTabelaZ
	Else
		cTab := "YXG"
	EndIf
endif

Aadd(aCabec,{"C5_FILIAL"	,xFilial("SC5") 	,Nil})   // 
Aadd(aCabec,{"C5_NUM"		,'' 	,Nil})
Aadd(aCabec,{"C5_TIPO"		,'N'			 	,Nil})   //
Aadd(aCabec,{"C5_CLIENTE"	,'000001'		 	,Nil})  //
Aadd(aCabec,{"C5_LOJACLI"	,Strzero(val(cfilant),4)	,Nil})  //
Aadd(aCabec,{"C5_CLIENT"	,'000001'			,Nil})  //
Aadd(aCabec,{"C5_LOJAENT"	,Strzero(val(cfilant),4)	,Nil}) //
Aadd(aCabec,{"C5_XIDPCA"	,''    				,Nil})                //
Aadd(aCabec,{"C5_XDTENTR"	,stod(aCab[nLinha,02]),Nil})  //
Aadd(aCabec,{"C5_XNFABAS"	,'1'			 	,Nil})   //
Aadd(aCabec,{"C5_XCODPA"	,aCab[nLinha,01]	,Nil}) //
Aadd(aCabec,{"C5_XFINAL"	,'4'			 	,Nil})          //
Aadd(aCabec,{"C5_XFLDEST"	,''				   	,Nil})
Aadd(aCabec,{"C5_TRANSP"	,'000019'		 	,Nil})          //
Aadd(aCabec,{"C5_XTPCARG"	,''				 	,Nil})
Aadd(aCabec,{"C5_XHRPREV"	,'00:00'		 	,Nil})
Aadd(aCabec,{"C5_CONDPAG"	,'001'			 	,Nil})
Aadd(aCabec,{"C5_TABELA"	,cTab	 			,Nil})
Aadd(aCabec,{"C5_XCCUSTO"	,'70500002'		   	,Nil})
Aadd(aCabec,{"C5_XITEMCC"	,Posicione("ZZ1",1,xFilial("ZZ1")+aCab[nLinha,01],"ZZ1_ITCONT"),Nil})
Aadd(aCabec,{"C5_MOEDA"		,1 					,Nil})
Aadd(aCabec,{"C5_FRETE"		,0 					,Nil})
Aadd(aCabec,{"C5_TXMOEDA"	,1 					,Nil})
Aadd(aCabec,{"C5_EMISSAO"	,ddatabase		 	,Nil})
Aadd(aCabec,{"C5_XGPV"		,'PCA'			 	,Nil})
Aadd(aCabec,{"C5_MENNOTA"	,'' 				,Nil})
Aadd(aCabec,{"C5_ESPECI1"	,'UN'	 		  	,Nil})
Aadd(aCabec,{"C5_XHRINC" 	,cvaltochar(TIME())	,Nil})
Aadd(aCabec,{"C5_XDATINC"	,DATE()				,Nil})
Aadd(aCabec,{"C5_XLOCAL" 	,cLocE				,Nil})
Aadd(aCabec,{"C5_XNOMUSR"	,cUserName 			,Nil})
Aadd(aCabec,{"C5_XCODUSR"	,__cUserId 		   	,Nil})
Aadd(aCabec,{"C5_TPFRETE"	,"C" 				,Nil})
Aadd(aCabec,{"C5_TIPOCLI"	,"F" 				,Nil})
Aadd(aCabec,{"C5_TIPLIB" 	,'1'			  	,Nil})
Aadd(aCabec,{"C5_VEND1"  	,'000001' 		  	,Nil})
Aadd(aCabec,{"C5_XTPPAG" 	,''				  	,Nil})

RestArea(aArea)

Return(aCabec)                       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTEDI100  บAutor  ณMicrosiga           บ Data ณ  11/12/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   I T E N S   D O   P E D I D O                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MontIt2(nLinha)

Local aArea		:=	GetArea()
Local cOpera	:=	''
Local cTes		:=	space(3)
Local nCsv		:=	0
Local cPreco	:= 	0     
Local nCustoD   := 	Posicione("SB1",1,xFilial("SB1")+aItm[nLinha,04],"B1_CUSTD")
Local cTipoP	:=	Posicione("SB1",1,xFilial("SB1")+aItm[nLinha,04],"B1_XSECAO")
Local cTabelaZ	:=	Posicione("ZZ1",1,xFilial("ZZ1")+aItm[nLinha,01],"ZZ1_TAB_LA")
	
Local cTab		:=	space(3)
                         
If xFilial("SC6") <> "01"     
	If !empty(cTabelaZ)
		cTab := cTabelaZ
	Else
		cTab := "YXG"
	EndIf
endif

//TRB->ZO_CODPA,TRB->ZO_DATENT,TRB->ZO_TIPEST,TRB->ZO_CODPRO,TRB->ZO_QTDPED 

cTpCli  := "F"
cxFinal := "4"
cEPP    := Posicione("SA1",1,xFilial("SA1")+'00000100'+cfilant,"A1_XEPP")

cOpera  := U_TTOPERA('PCA',cTpCli,cxFinal,cEPP)  

If !Empty(cOpera)
	//Buscando a TES a ser informada no item do pv.
	aAreaF4 := GetArea()
	cQueryX := "SELECT FM_TS,F4_CF"
	cQueryX += " FROM "+RetSQLName("SFM")+" FM"
	cQueryX += "	INNER JOIN "+RetSQLName("SF4")+" F4 ON F4_FILIAL=FM_FILIAL AND F4_CODIGO=FM_TS AND F4.D_E_L_E_T_=''"
	cQueryX += " WHERE FM_TIPO='"+cOpera+"' AND FM_FILIAL='"+xFilial("SFM")+"' AND FM_GRPROD='"+Posicione("SB1",1,xFilial("SB1")+aItm[nLinha,04],"B1_GRTRIB")+"' AND FM.D_E_L_E_T_=''"

	If Select('TRB2') > 0
		dbSelectArea('TRB2')
		dbCloseArea()
	EndIf       
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQueryX),"TRB2",.F.,.T.)
	dbSelectArea("TRB2")
	cTes := If(Empty(TRB2->FM_TS),space(3),TRB2->FM_TS)
	
	If Empty(cTes)
		cTes := cTesInt(aItm[nLinha,04],cOpera)
	EndIf
	 
	RestArea(aAreaF4)
EndIf

                
nLucro 	:= GetMv("MV_XLUCRO")
nLucrot := GetMv("MV_XLUCROT")  

If xFilial("SC6") == "01" .OR. cTipoP $ "005/007"
	If Empty(nCustoD)
		MsgAlert("Este produto nใo possui custo standard informado. Favor procurar o setor de Controladoria.","TTEDI100")								
		Return(.F.)
	Else
		If SubStr(aItm[nLinha,04],1,2)$("21/22") 
			cPreco := nCustoD * nLucrot //Custo Standar + Margem
		Else
			cPreco := nCustoD * nLucro  //Custo Standar + Margem
		EndIf
	EndIf
Else
	cPreco := Posicione("DA1",1,xFilial("DA1")+cTab+aItm[nLinha,04],"DA1_PRCVEN")
EndIf 
				
Aadd(aItens,{{"C6_FILIAL"	,xFilial("SC6")	 			,Nil},;
				{"C6_NUM"	,'' 						,Nil},; 
				{"C6_ITEM"	,Strzero(len(aItens)+1,2) 	,Nil},; 
				{"C6_PRODUTO",aItm[nLinha,04] 			,Nil},;
				{"C6_XPRDORI",aItm[nLinha,04] 			,Nil},;
				{"C6_QTDVEN",aItm[nLinha,05] 			,Nil},;
				{"C6_XQTDORI",aItm[nLinha,05] 			,Nil},;
				{"C6_TPOP"	,"F" 						,Nil},;
				{"C6_PRCVEN",round(cPreco,4)	  		,Nil},;
				{"C6_VALOR"	,round(round(cPreco,4) * round(aItm[nLinha,05],4),4) 				,Nil},;
				{"C6_PRUNIT",round(cPreco,4)			,Nil},;
				{"C6_TES"	,cTes 			   			,Nil},;
				{"C6_CLI"	,'000001'		 			,Nil},;
				{"C6_LOJA"	,Strzero(val(cfilant),4)	,Nil},;
				{"C6_LOCAL"	,Posicione("SB1",1,xFilial("SB1")+aItm[nLinha,04],"B1_LOCPAD") 	,Nil},;
				{"C6_CCUSTO",'70500002' 				,Nil},;
				{"C6_ITEMCC",Posicione("ZZ1",1,xFilial("ZZ1")+aItm[nLinha,01],"ZZ1_ITCONT") 	,Nil},;
				{"C6_XGPV"	,'PCA'			 			,Nil},;
				{"C6_ENTREG",stod(aItm[nLinha,03])	 	,Nil},;
				{"C6_XDTEORI",aItm[nLinha,05] 			,Nil},;
				{"C6_UM"	,Posicione("SB1",1,xFilial("SB1")+aItm[nLinha,04],"B1_UM") 		,Nil},;
				{"C6_SEGUM"	,Posicione("SB1",1,xFilial("SB1")+aItm[nLinha,04],"B1_SEGUM") 		,Nil},;
				{"C6_XHRINC" ,TIME() 					,Nil},;
				{"C6_XDATINC",DATE()		 			,Nil},;
				{"C6_XUSRINC",cUsername 	 			,Nil}})

RestArea(aArea)

Return                                                                                                             

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT11C  บAutor  ณMicrosiga           บ Data ณ  04/23/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera pdf com os pedidos gerados pela rotina.               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GerarPDF()

Local aArquivos := {}
Local cMsg		:= "Pedidos Gerados - PCA"
Local lAdjustToLegacy := .F. 
Local lDisableSetup  := .T.
Local cLogoD	:= GetSrvProfString("Startpath","") + "DANFE01.BMP" 
Local nTotal	:= 0
Private oPrinter      


oFont1 := TFont():New( "Courier New", , -18, .T.)

If oPrinter == Nil
	lPreview := .T.
	oPrinter := FWMSPrinter():New("Pca.rel", 6, lAdjustToLegacy, , lDisableSetup)

	// Ordem obrigแtoria de configura็ใo do relat๓rio
	oPrinter:SetResolution(72)
	oPrinter:SetPortrait()
	oPrinter:SetPaperSize(DMPAPER_A4)
	oPrinter:SetMargin(60,60,60,60) 
	// nEsquerda, nSuperior, nDireita, nInferior 
	oPrinter:cPathPDF := "\SPOOL\" 
EndIf       

oPrinter:Box(10,10,510,850)
oPrinter:Say( 30, 250, "Pedidos Faturados - PCA", oFont1, 1400, CLR_HRED)
oPrinter:SayBitmap(015,015,cLogoD,055,056)

oPrinter:Say(090, 15,'Filial',oFont1)
oPrinter:Say(090, 50,'Pedido',oFont1)
oPrinter:Say(090, 100,'PA',oFont1)
oPrinter:Say(090, 150,'Data Entrega',oFont1)
oPrinter:Say(090, 230,'Tipo Estoque',oFont1)

oPrinter:Say(100, 15, Replicate("-", 500), oFont1)

nLin := 110             

//		1				2			3				4				5				6			7				8			9				10				11			
//TRB->C5_FILIAL,TRB->C5_NUM,TRB->C5_XFINAL,TRB->ZZC_FINAL,TRB->C5_XNOMUSR,TRB->C5_XDATINC,TRB->C5_XHRINC,TRB->TOTAL,TRB->C5_XCODPA,TRB->C5_CLIENTE,TRB->C5_LOJACLI
For nX := 1 to len(aCab)
	cTipo := If(aCab[nX,03]=="CS",'Carga Seca',If(aCab[nX,03]=="RI",'Refrigerado e Iogurte',If(aCab[nX,03]=="LC",'Lanche','Uso e Consumo')))
   	oPrinter:Say(nLin, 15,cfilant							,oFont1)
   	oPrinter:Say(nLin, 50,aCab[nX,04]  						,oFont1)
   	oPrinter:Say(nLin, 100,aCab[nX,01] 						,oFont1)
   	oPrinter:Say(nLin, 150,cvaltochar(stod(aCab[nX,02]))	,oFont1)
   	oPrinter:Say(nLin, 230,cTipo							,oFont1)
   
	nLin := nLin + 10
Next nX
                           
oPrinter:EndPage()

oPrinter:Preview()

Aadd(aArquivos,{"\spool\Pca.pdf",'Content-ID: <ID_pedido.pdf>'}) 

U_TTMAILN('microsiga@toktake.com.br',Alltrim(cusername)+'@toktake.com.br','Agenda PCA',cMsg,aArquivos,.F.)


FreeObj(oPrinter)  

oPrinter := Nil	
  

Return                    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT11C  บAutor  ณMicrosiga           บ Data ณ  05/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Filtro                                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function filtro(nOpc)

Local aArea	:=	GetArea()
Local aBkL	:=	{}
                           
If nOpc == 0
	aList := aClone(aListCp)
	aBkL  := aClone(aListCp)
	ASIZE(aList,len(aList))
	ASIZE(aBkL,len(aBkL))
	dDatad	:=	ctod("  /  /  ")
	dDatat	:=	ctod("  /  /  ")
	cPaFil	:=	space(6)
	xCombo1	:=	aAbaste[1]
	xCombo2	:=	aStatus[1]
	xCombo3	:=	aTipoe[1]
Else
//	Aadd(aPAs,{'Em Andamento',cvaltochar(stod(TRB->ZO_DATEMIS)),cvaltochar(stod(TRB->ZO_DATENT)),TRB->ZO_CODPA,'',cTipo,Alltrim(TRB->ZO_DESCARM),;
//					Alltrim(TRB->ZO_ABASTEC),TRB->ZO_OBSERVA,TRB->ZZ1_END,TRB->ZZ1_BAIRRO,TRB->ZZ1_ITCONT,TRB->ZZ1_XAGEND,;
//					TRB->ZO_CODPRO,TRB->ZO_FATM2,TRB->ZO_FATM1,TRB->ZO_REMM2,TRB->ZO_REMM1,TRB->ZO_REMMA,TRB->ZO_PERDAS,TRB->ZO_REMA3,TRB->ZO_REMA2,;
//					TRB->ZO_REMA1,TRB->ZO_CP,TRB->ZO_ESTOQUE,TRB->ZO_QTDPED})                                                  

	For nX := 1 to len(aList)
		//Data De
		If !empty(dDatad)
			If dDatad > ctod(aList[nX,03])
				aList[nX,27] := .F.
				Loop	
			EndIf
		EndIf    
		//Data ate
		If !empty(dDatat)
			If dDatat < ctod(aList[nX,03])
				aList[nX,27] := .F.
				Loop	
			EndIf
		EndIf   
		//PA
		If !empty(cPaFil)
			If cPaFil != aList[nX,04]
				aList[nX,27] := .F.
				Loop
			EndIF
		EndIf    
		//Abastecedor
		If !empty(xCombo1)
			If xCombo1 != aList[nX,08]
				aList[nX,27] := .F.
				Loop
			EndIF
		EndIf      
		//Tipo de estoque
		If !empty(xCombo3) .And. xCombo3 != "Todos"
			If xCombo3 != aList[nX,06]
				aList[nX,27] := .F.
				Loop
			EndIF
		EndIf      
		
		//Status
		If !empty(xCombo2)
			If xCombo2 != aList[nX,01]
				aList[nX,27] := .F.
				Loop
			EndIF
		EndIf      

	Next nX                       

	nX := 1
	While nX <= len(aList) 
		If !aList[nX,27]
			ADEL(aList,nX)     
			//Redimensinando o tamanho do array para mostrar corretamente no browse
			//Sempre deve fazer isto quando estiver utilizando tcbrowse, senใo a montagem da tela sempre vai procurar pelo array original que sera diferente do atual
			ASIZE(aList,LEN(aList)-1)
		else
			aadd(aBkL,{})   
			nX++
		EndIf 
	Enddo

	If len(aBkL) > 0
		ACOPY(aList,aBkL,1,len(aList))
	Else
		MsgAlert("Nใo hแ produtos que atendam aos dados digitados no filtro, volte e verifique.","TTEST01C")
	 	aList := aClone(aListCp)
		aBkL  := aClone(aListCp)
		ASIZE(aList,len(aList))
		ASIZE(aBkL,len(aBkL))
	EndIf

EndIf

	oList:SetArray(aBkL)
	oList:bLine := {||{ aBkL[oList:nAt,01],; 
	 					 aBkL[oList:nAt,02],;
	 					 aBkL[oList:nAt,03],;
	                     aBkL[oList:nAt,04],;
	                     aBkL[oList:nAt,05],;
	                     aBkL[oList:nAt,06],;
	                     aBkL[oList:nAt,07],;
	                     aBkL[oList:nAt,08],;
	                     aBkL[oList:nAt,09]}}
	                     
	oList:refresh()
	oDlg1:refresh()


RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT11C  บAutor  ณMicrosiga           บ Data ณ  05/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function NovaData(cPa,dDat)

Local oDlg1,oSay1,oGet1,oBtn1,oSay2 
Local dNewDat	:=	ctod("  /  /  ")
Local nOp		:=	0   
Local dRet		
                                   
While nOp == 0
	oDlg1      := MSDialog():New( 091,232,235,521,"Data de entrega invแlida PA - "+cPa,,,.F.,,,,,,.T.,,,.T. )
	oSay2      := TSay():New( 010,032,{||"Data Informada "+cvaltochar(stod(dDat))},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,092,008)
	oSay1      := TSay():New( 020,012,{||"Nova Data"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oGet1      := TGet():New( 020,068,{|u| If(Pcount()>0,dNewDat:=u,dNewDat)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	oBtn1      := TButton():New( 044,048,"Ok",oDlg1,{||oDlg1:end(nOp:=1)},037,012,,,,.T.,,"",,,,.F. )
	
	oDlg1:Activate(,,,.T.)

	If nOp == 1
		dRet := dNewDat
	EndIf              
EndDo

Return(dtos(dRet))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT11C  บAutor  ณAlexandre Venancio  บ Data ณ  06/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cadastrar a TES inteligente para os casos onde ela nao     บฑฑ
ฑฑบ          ณexista.                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function cTesInt(cProd,cOpera)

Local aArea	:= GetArea()  
Local cTesr	:= space(3)
Local oDlg1,oGrp1,oSay1,oSay2,oSay3,oSay4,oSay5,oSay6,oSay7,oGet1,oBtn1
Local cGrp	:= Posicione("SB1",1,xFilial("SB1")+cProd,"B1_GRTRIB")
Local cDGr	:= Posicione("SX5",1,xFilial("SX5")+'21'+cGrp,"X5_DESCRI")

While empty(cTesr)
	oDlg1      := MSDialog():New( 091,232,359,661,"Cadastro Tes Inteligente",,,.F.,,,,,,.T.,,,.T. )
	
	oGrp1      := TGroup():New( 008,008,104,200,"Informa็๕es do produto",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		
		oSay1      := TSay():New( 020,014,{||"Produto - "+cProd},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
		oSay2      := TSay():New( 020,073,{||Posicione("SB1",1,xFilial("SB1")+cProd,"B1_DESC")},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,123,008)
		
		oSay3      := TSay():New( 036,014,{||"Grupo Trib. Prod. - "+cGrp+" - "+Alltrim(cDGr)},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,182,008)
		oSay4      := TSay():New( 052,014,{||"Estado Origem - "+SM0->M0_ESTCOB},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,051,008)
		
		oSay5      := TSay():New( 052,098,{||"Estado Destino - "+SM0->M0_ESTCOB},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,054,008)
		oSay6      := TSay():New( 068,014,{||"Tipo Opera็ใo - "+cOpera+" - "+Alltrim(Posicione("SX5",1,xFilial("SX5")+'DJ'+cOpera,"X5_DESCRI"))},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,178,008)
		
		oSay7      := TSay():New( 084,020,{||"Informe a TES para esta condi็ใo"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,084,008)
		oGet1      := TGet():New( 084,112,{|u| If(Pcount()>0,cTesr:=u,cTesr)},oGrp1,040,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SF4","",,)
		
		oBtn1      := TButton():New( 109,080,"Confirmar",oDlg1,{|| oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )
	
	oDlg1:Activate(,,,.T.) 
	
	If existcpo("SF4",cTesr)
		DbSelectArea("SFM")
		DbSetOrder(1)
		Reclock("SFM",.T.)
		SFM->FM_FILIAL 	:= xFilial("SFM")
		SFM->FM_TIPO	:= cOpera
		SFM->FM_TS		:= cTesr
		SFM->FM_EST		:= SM0->M0_ESTCOB
		SFM->FM_GRPROD	:= cGrp
		SFM->(Msunlock())
	Else
		cTesr	:=	space(3)
	EndIf

EndDo	

RestArea(aArea)

Return(cTesr)