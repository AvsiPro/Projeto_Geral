#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'                     
#INCLUDE 'TBICONN.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ TTFAT12C ณ Autor ณ Alexandre Venancio    ณ Data ณ 18/03/13 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณLocacao   ณ                  ณContato ณ                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ  Config de Agenda para o PCA                               ณฑฑ
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

User Function TTFAT12C
                   
Local nOpc	:=	0
SetPrvt("oDlg1","oSay1","oGrp1","oSay2","oSay3","oSay4","oSay5","oSay6","oSay7","oSay8","oSay9","oCBox1")
SetPrvt("oCBox3","oCBox4","oCBox5","oCBox6","oCBox7","oCBox8","oCBox9","oCBox10","oCBox11","oCBox12")
SetPrvt("oCBox14","oCBox15","oCBox16","oCBox17","oCBox18","oCBox19","oCBox20","oCBox21","oCBox22","oCBox23")
SetPrvt("oCBox25","oGrp2","oSay10","oCBox26","oBrw1","oBtn1","oBtn2","oBtn3","oList","oSay10","oCBox27","oCBox28")
Private aTipInv	:=	{"Mensal","Quinzenal","10 Dias","1x por semana","2x por semana","3x por semana","4x por semana","Diario"}    
Private aTipEst	:=	{"Selecione","Carga Seca","Refrigerada e Iogurte","Lanche","Uso e Consumo"}  
Private aDiaSem	:=	{"1 Semana","2 Semana","3 Semana","4 Semana","5 Semana","Todas"}              
Private xCombo1	:=	""  
Private xCombo2	:=	aTipEst[1] 
Private xCombo3 :=	aDiaSem[6]                                                     
Private aList	:=	{}    
Private cPa		:=	space(6)
Private aChecks	:=	{}
Private oOk   	:= LoadBitmap(GetResources(),'br_verde')       //Controla se o pedido foi alterado ou nao no grid.
Private oNo   	:= LoadBitmap(GetResources(),'br_vermelho')
Private cAgenda	:= ""  

Aadd(aList,{'','','','',''})
Aadd(aChecks,{.F.,.F.,.F.,.F.,.F.,.F.})

//Prepare Environment Empresa "01" Filial "01" Tables "ZZ1/SC5/SC6"
If cEmpAnt <> "01"
	Return
EndIf

If !TTFAT12P()
	Return
EndIf
   
cAgenda := Posicione("ZZ1",1,xFilial("ZZ1")+cPa,"ZZ1_XAGEND")

If !Empty(cAgenda)
	//agenda - dias da semana que estao marcados para entrega
	cAux := substr(cAgenda,1,6)
	For nX := 1 to 6
		If substr(cAux,nX,1) == "1"
		 	aChecks[1,nX] := .T.
		EndIf
	Next nX
	//Periodo de inventario
	cAux := substr(cAgenda,7,3)
	xCombo1 := aTipInv[Ascan(aTipInv,{|x| substr(x,1,3) == cAux})]
	//Semanas do mes
	cAux := substr(cAgenda,10,1)
	xCombo3 := aDiaSem[Ascan(aDiaSem,{|x| substr(x,1,1) == cAux})]
	//Tipo de carga

	cAux := substr(cAgenda,11,30)
	aAux := strtokarr(cAux,",")
	//aTipEst	:=	{"Selecione","Carga Seca","Refrigerada e Iogurte","Lanche","Uso e Consumo"}  	
	aList := {}        
	For nX := 1 to len(aAux)
		cTeste:= aTipEst[Ascan(aTipEst,{|x| substr(x,1,1) == substr(aAux[nX],1,1)})]
		Aadd(aList,{cTeste,substr(aAux[nX],4,1)+"+"+substr(aAux[nX],5,1)})
	Next nX
EndIf

oDlg1      := MSDialog():New( 304,293,564,1070,"Configura็ใo Agenda",,,.F.,,,,,,.T.,,,.T. )
oSay1      := TSay():New( 004,004,{||"PA:  "+cPa+" - "+Posicione("ZZ1",1,xFilial("ZZ1")+cPa,"ZZ1_DESCRI")},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,328,008)

oGrp1      := TGroup():New( 013,004,100,184,"Configura็ใo de Datas de Entrega",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay2      := TSay():New( 025,008,{||"Agenda"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_WHITE,CLR_HRED,092,008)
	/*oSay3      := TSay():New( 037,008,{||"Seg"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_WHITE,CLR_HRED,014,008)
	oSay4      := TSay():New( 037,023,{||"Ter"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_WHITE,CLR_HRED,014,008)
	oSay5      := TSay():New( 037,039,{||"Qua"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_WHITE,CLR_HRED,014,008)
	oSay6      := TSay():New( 037,054,{||"Qui"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_WHITE,CLR_HRED,014,008)
	oSay7      := TSay():New( 037,069,{||"Sex"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_WHITE,CLR_HRED,014,008)
	oSay8      := TSay():New( 037,085,{||"Sแb"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_WHITE,CLR_HRED,014,008)
	*/
	oSay2:lTransparent := .F.
	/*oSay3:lTransparent := .F.
	oSay4:lTransparent := .F.
	oSay5:lTransparent := .F.
	oSay6:lTransparent := .F.
	oSay7:lTransparent := .F.
	oSay8:lTransparent := .F.*/

	//oBrw2      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{037,008,057,100},,, oGrp1 ) 
	oList2 := TCBrowse():New(037,008,092,035,, {'Seg','Ter','Qua','Qui','Sex','Sab'},{80,80,80,80,80,50},;
	                            oGrp1,,,,{|| },{||  posicao()},, ,,,  ,,.F.,,.T.,,.F.,,,)
	oList2:SetArray(aChecks)
	oList2:bLine := {||{ If(aChecks[oList2:nAt,01],oOk,oNo),;
	 					 If(aChecks[oList2:nAt,02],oOk,oNo),;
						 If(aChecks[oList2:nAt,03],oOk,oNo),;
	 					 If(aChecks[oList2:nAt,04],oOk,oNo),;
	 					 If(aChecks[oList2:nAt,05],oOk,oNo),;
	 					 If(aChecks[oList2:nAt,06],oOk,oNo)}}
    /*
	oCBox1     := TCheckBox():New( 049,008,"A",,oGrp1,015,015,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",,{||check("1")} )
	oCBox2     := TCheckBox():New( 049,023,"B",,oGrp1,015,010,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",,{||check("2")} )
	oCBox3     := TCheckBox():New( 049,039,"C",,oGrp1,015,010,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",,{||check("3")} )
	oCBox4     := TCheckBox():New( 049,054,"D",,oGrp1,015,010,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",,{||check("4")} )
	oCBox5     := TCheckBox():New( 049,069,"E",,oGrp1,015,010,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",,{||check("5")} )
	oCBox6     := TCheckBox():New( 049,085,"F",,oGrp1,015,010,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",,{||check("6")} )
	*/
	
	oSay9      := TSay():New( 025,103,{||"Data Inventแrio"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_WHITE,CLR_HRED,073,008)
	oCBox25    := TComboBox():New( 037,104,{|u|If(Pcount()>0,xCombo1:=u,xCombo1)},aTipInv,072,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
	oSay9:lTransparent := .F.
	
	oSay10     := TSay():New( 050,103,{||"Semana do M๊s"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_WHITE,CLR_HRED,073,008)
	oCBox27    := TComboBox():New( 062,104,{|u|If(Pcount()>0,xCombo3:=u,xCombo3)},aDiaSem,072,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
	oSay10:lTransparent := .F.

oGrp2      := TGroup():New( 013,188,100,368,"Configura็ใo de Tipo de Estoque",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
   
	oSay10     := TSay():New( 024,193,{||"Tipo de Estoque:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,043,008)
	oCBox26    := TComboBox():New( 024,240,{|u|If(Pcount()>0,xCombo2:=u,xCombo2)},aTipEst,072,010,oGrp2,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
		
	oList := TCBrowse():New(040,196,170,055,, {'Tipo Estoque','Lead Time'},{60,60},;
	                            oGrp2,,,,{|| },{|| editcol() },, ,,,  ,,.F.,,.T.,,.F.,,,)
	oList:SetArray(aList)
	oList:bLine := {||{ aList[oList:nAt,01],; 
	 					 aList[oList:nAt,02]}}

	oBtn1      := TButton():New( 024,320,"Incluir",oGrp2,{|| incluir(xCombo2)},037,010,,,,.T.,,"",,,,.F. )

oBtn2      := TButton():New( 106,145,"Incluir",oDlg1,{||oDlg1:end(nOpc:=1)},037,012,,,,.T.,,"",,,,.F. )
oBtn3      := TButton():New( 106,189,"Cancelar",oDlg1,{||oDlg1:end(nOpc:=0)},037,012,,,,.T.,,"",,,,.F. )
                                                                                                       
oBtn2:disable()

oDlg1:Activate(,,,.T.)

If nOpc == 1
	gravar()
	U_TTFAT12C()
EndIf


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT12C  บAutor  ณMicrosiga           บ Data ณ  04/15/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Incluir tipo de armazem para gerar lead time de ligacoes   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function incluir(cOpc)
      
Local aArea	:=	GetArea()

If cOpc != "Selecione"
	If Ascan(aList,{|x| x[1] == cOpc}) == 0
		Aadd(aList,{cOpc,space(1)})
	EndIf
EndIf

If len(aList) > 1 .And. Empty(aList[1,1])
	Adel(aList,1)
	Asize(aList,len(aList)-1)
EndIf


RestArea(aArea)

Return     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT12C  บAutor  ณMicrosiga           บ Data ณ  04/15/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Editando a coluna de Lead Time                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function editcol()

Local aArea	:=	GetArea()    
Local lOk	:=	.F.

If !empty(aList[oList:nAt,01])
	While !lOk
		If Empty(aList[oList:nAt,02]) 
			lEditCell( aList, oList, "@!", 2)
			If val(aList[oList:nAt,02]) > 0
				aList[oList:nAt,02] := "D+"+cvaltochar(aList[oList:nAt,02])
				lOk := .T.
			EndIf                            
		Else   
			aList[oList:nAt,02] := val(substr(aList[oList:nAt,02],3,1))
			lEditCell( aList, oList, "@!", 2)
			If aList[oList:nAt,02] > 0
				aList[oList:nAt,02] := "D+"+cvaltochar(aList[oList:nAt,02])
				lOk := .T.
			EndIf                            
		EndIf
	EndDo
EndIf

botaoinc()

oList:refresh()

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT12C  บAutor  ณMicrosiga           บ Data ณ  04/16/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Alteracao para os itens do grid com dia da semana que     บฑฑ
ฑฑบ          ณdevera ocorrer a entrega.                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function posicao()

Local npos := oList2:ColPos()  
      
If aChecks[1,nPos] 
	aChecks[1,nPos] := .F.
Else
	aChecks[1,nPos] := .T.
EndIf

oList2:SetArray(aChecks)
oList2:bLine := {||{ If(aChecks[oList2:nAt,01],oOk,oNo),; 
 					 If(aChecks[oList2:nAt,02],oOk,oNo),;
 					 If(aChecks[oList2:nAt,03],oOk,oNo),;
 					 If(aChecks[oList2:nAt,04],oOk,oNo),;
 					 If(aChecks[oList2:nAt,05],oOk,oNo),;
 					 If(aChecks[oList2:nAt,06],oOk,oNo)}}

botaoinc()

oList2:refresh()
oDlg1:refresh()

Return               

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT12C  บAutor  ณMicrosiga           บ Data ณ  04/16/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Habilitar o botao incluir para a agenda.                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static function botaoinc()
            
Local lHab	:=	.F.
Local nTrue	:=	0

For nX := 1 to len(aList)
	If !empty(aList[nX,01]) .And. !empty(aList[nX,02])
		lHab := .T.
	EndIf
Next nX

For nX := 1 to len(aChecks[1])
	If aChecks[1,nX]
		nTrue++
	EndIf
Next nX

If len(aChecks[1]) - nTrue < len(aChecks[1]) .And. lHab
	lHab := .T.
Else
	lHab := .F.
EndIf

If lHab
	oBtn2:enable()
Else
	oBtn2:disable()      
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT12C  บAutor  ณMicrosiga           บ Data ณ  04/15/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Parametros da rotina de configuracao da agenda do pca.     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TTFAT12P()

Local oDlg1,oSay1,oGet1,oBtn1,oBtn2
Local lRet	:= .F.        
Local nOp	:=	0

oDlg1      := MSDialog():New( 091,232,262,608,"Configura็ใo da Agenda PCA",,,.F.,,,,,,.T.,,,.T. )
oSay1      := TSay():New( 024,024,{||"Informe o c๓digo da PA:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
oGet1      := TGet():New( 024,092,{|u| If(Pcount()>0,cPa:=u,cPa)},oDlg1,060,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZZ1","",,)
oBtn1      := TButton():New( 052,032,"Confirmar",oDlg1,{||oDlg1:end(nOp:=1)},037,012,,,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 052,112,"Cancelar",oDlg1,{||oDlg1:end(nOp:=0)},037,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

If nOp == 1
	lRet := .T.
EndIf  

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT12C  บAutor  ณMicrosiga           บ Data ณ  04/17/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Grava as informacoes no cadastro da Pa                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function gravar()

Local aArea	:=	GetArea() 
Local cCampo:=	""
Local cBar	:=	"|"
Local cVir	:=	","
Local cTpE	:=	""
                  
For nX := 1 to len(aChecks[1])
	If aChecks[01,nX]
		cCampo += "1"
	Else
		cCampo += "0"
	EndIf
Next nX

cCampo += substr(xCombo1,1,3)
cCampo += substr(xCombo3,1,1)

For nX := 1 to len(aList)
	If substr(aList[nX,01],1,1) == "C"
		cTpE := "CS"
	ElseIf substr(aList[nX,01],1,1) == "R"
		cTpE := "RI"
	ElseIf substr(aList[nX,01],1,1) == "L"  
		cTpE := "LC"
	ElseIf substr(aList[nX,01],1,1) == "U"
		cTpE := "UC"
	EndIf
	cCampo += cTpE + cBar + strtran(aList[nX,02],"+") + If(nX+1<=len(aList),cVir,"")
Next nX


DbSelectArea("ZZ1")
DbSetOrder(1)
If DbSeek(xFilial("ZZ1")+cPa)
	Reclock("ZZ1",.F.)
	ZZ1->ZZ1_XAGEND	:=	cCampo
	ZZ1->(Msunlock())
EndIf

RestArea(aArea)

Return