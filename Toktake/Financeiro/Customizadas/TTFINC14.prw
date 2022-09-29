#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TBICONN.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ TTFINC14 ณ Autor ณ Alexandre Venancio    ณ Data ณ14/08/2013ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณLocacao   ณ                  ณContato ณ                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ  Rotina de conferencia de caixa                            ณฑฑ
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

User Function TTFINC14
       
Local cApoini	:=	''
Local cApofim	:=	''
Local cApoCed	:=	''
Local nOpc		:= 0
Private cCodFil	:= ""
Private lCampinas := .F.
Private oDlg1,oGrp1,oGrp2,oGrp3,oGrp4,oSay1,oGet1,oBtn1,oBtn2,oBtn3,oSay2,oSay3,oSay4,oSay5,oSay6
Private oList,oList2,oList3,oList4,oList5
Private aList	:=	{}
Private aList2	:=	{}
Private aList3	:=	{}
Private aList4	:=	{}
Private aList5	:=	{}       
Private dDat	:=	CTOD("  /  /  ")
                    
//Prepare Environment Empresa "01" Filial "01" //Tables "ZZE" 

Aadd(aList,{'','',''})
Aadd(aList2,{'','','',''})
Aadd(aList3,{'','','',''})
Aadd(aList4,{'','','',''})
Aadd(aList5,{'','','',''})

// Adicionado por Jackson - 05/03/14
cCodFil := cFilAnt

oDlg1      := MSDialog():New( 091,232,660,1045,"Confer๊ncia de Caixa",,,.F.,,,,,,.T.,,,.T. )

	lCampinas := .F.

	oGrp1      := TGroup():New( 004,004,235,200,"Movimentos incluํdos no fechamento",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		//oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{016,008,188,196},,, oGrp1 )    
		oList := TCBrowse():New(016,008,188,160,, {'Estrutura','C้dulas','Moedas'},{60,40,40},;
	                            oGrp1,,,,{|| },{|| /*EDITCOL*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
		oList:SetArray(aList)
		oList:bLine := {||{ aList[oList:nAt,01],; 
	 						 Transform(aList[oList:nAt,02],"@E 999,999,999.99"),;
	 						 Transform(aList[oList:nAt,03],"@E 999,999,999.99")}}

		//oBrw2      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{192,008,223,196},,, oGrp1 ) 
		oList2 := TCBrowse():New(180,008,188,050,, {'Estrutura','Totais','C้dulas','Moedas'},{60,40,40},;
	                            oGrp1,,,,{|| },{|| /*EDITCOL*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
		oList2:SetArray(aList2)
		oList2:bLine := {||{ aList2[oList2:nAt,01],; 
	 						 Transform(aList2[oList2:nAt,02],"@E 999,999,999.99"),;
	 						 Transform(aList2[oList2:nAt,03],"@E 999,999,999.99"),;
	 						 Transform(aList2[oList2:nAt,04],"@E 999,999,999.99")}}


	oGrp2      := TGroup():New( 004,204,080,396,"Apontamento inicial Moedas",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		//oBrw3      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{012,208,072,392},,, oGrp2 ) 
		oList3 := TCBrowse():New(012,208,185,064,, {'Moeda','X Mil','Unidade','Total'},{60,40,40,40},;
	                            oGrp2,,,,{|| },{|| editcol1()},, ,,,  ,,.F.,,.T.,,.F.,,,)
		oList3:SetArray(aList3)
		oList3:bLine := {||{ aList3[oList3:nAt,01],; 
	 						 aList3[oList3:nAt,02],; 
	 						 aList3[oList3:nAt,03],;         
	 						 Transform(aList3[oList3:nAt,04],"@E 999,999,999.99")}}
	
	oGrp3      := TGroup():New( 084,204,160,396,"Apontamento Final Moedas",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		//oBrw4      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{088,208,148,392},,, oGrp3 ) 
		oList4 := TCBrowse():New(093,208,185,064,, {'Moeda','X Mil','Unidade','Total'},{60,40,40,40},;
	                            oGrp3,,,,{|| },{|| editcol2()},, ,,,  ,,.F.,,.T.,,.F.,,,)
		oList4:SetArray(aList4)
		oList4:bLine := {||{ aList4[oList4:nAt,01],; 
	 						 aList4[oList4:nAt,02],;
	 						 aList4[oList4:nAt,03],;
	 						 Transform(aList4[oList4:nAt,04],"@E 999,999,999.99")}}
	
	oGrp4      := TGroup():New( 160,204,235,396,"Fechamento - C้dulas",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		//oBrw5      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{164,208,224,392},,, oGrp4 ) 
		oList5 := TCBrowse():New(169,208,185,064,, {'Moeda','Centos','Unidade','Total'},{60,40,40,40},;
	                            oGrp4,,,,{|| },{|| editcol3()},, ,,,  ,,.F.,,.T.,,.F.,,,)
		oList5:SetArray(aList5)
		oList5:bLine := {||{ aList5[oList5:nAt,01],; 
	 						 aList5[oList5:nAt,02],;
	 						 aList5[oList5:nAt,03],;
	 						 Transform(aList5[oList5:nAt,04],"@E 999,999,999.99")}}       

oSay1      := TSay():New( 244,005,{||"Data do Caixa"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
oGet1      := TGet():New( 244,048,{|u| If(Pcount()>0,dDat:=u,dDat)},oDlg1,060,008,'',{|| PreAcols()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSay2      := TSay():New( 260,005,{||"Total das Contagens"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,140,008)
oSay5      := TSay():New( 260,075,{||"0,00"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,140,008)
oSay3      := TSay():New( 260,120,{||"0,00"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,140,008)
oSay4      := TSay():New( 260,160,{||"0,00"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,140,008)
oSay6      := TSay():New( 260,250,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,140,008)
       
// CheckBox Caixa Campinas
oCheck1 := TCheckBox():New(270,05,'Caixa Campinas',{|u|if(PCount()>0,lCampinas:=u,lCampinas) },oDlg1,100,210,,,,,,,,.T.,,,)

oBtn1      := TButton():New( 256,359,"Sair",oDlg1,{||oDlg1:end(nOpc:=0)},037,012,,,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 240,359,"Confirmar",oDlg1,{||oDlg1:end(nOpc:=1)},037,012,,,,.T.,,"",,,,.F. )
oBtn2:disable()	 						                                                                      
oBtn3      := TButton():New( 272,359,"Fundo Troco",oDlg1,{|| Processa({||fdotroco() },"Buscando informa็๕es das Rotas...") },037,012,,,,.T.,,"",,,,.F. )
oBtn3:disable()                                                                                             


// Adicionado por Jackson - 05/03/14 - Tratamento para caixa campinas - gravar na filial 03
If lCampinas
	cCodFil := "03"
EndIf
	
oDlg1:Activate(,,,.T.)

If nOpc == 1
	Gravar()
	
	If lCampinas
		cCodFil := "03"
	EndIf
   
	DbSelectArea("SZP")
	DbSetOrder(1)
	If !DbSeek(cCodFil+dtos(dDat))
	    Reclock("SZP",.T.)
	    SZP->ZP_FILIAL	:=	cCodFil
	    SZP->ZP_DATA	:=	dDat
	Else
		Reclock("SZP",.F.)
	EndIf
	    
	For nX := 1 to len(aList3)                                                                                                          
	 	cApoini	+= aList3[nX,01] + ";" + cvaltochar(aList3[nX,02]) + ";" + cvaltochar(aList3[nX,03])+ ";" + cvaltochar(aList3[nX,04]) +"|"
	Next nX

   	SZP->ZP_APONINI	:=	cApoini

	For nX := 1 to len(aList4)
	 	cApofim	+= aList4[nX,01] + ";" + cvaltochar(aList4[nX,02]) + ";" + cvaltochar(aList4[nX,03])+ ";" + cvaltochar(aList4[nX,04]) +"|"
	Next nX

	SZP->ZP_APONFIM	:=	cApofim
	
	For nX := 1 to len(aList5)
	 	cApoced	+= aList5[nX,01] + ";" + cvaltochar(aList5[nX,02]) + ";" + cvaltochar(aList5[nX,03])+ ";" + cvaltochar(aList5[nX,04]) +"|"
	Next nX

	SZP->ZP_APONCED	:=	cApoced
	SZP->ZP_CXFECHA	:=	'S'
	SZP->ZP_USUARIO	:=	cusername
	SZP->ZP_DTFECH	:=	date()
	SZP->ZP_HORA	:=	time()
	SZP->(Msunlock())
		
Else
	If !Empty(dDat) .And. len(aList) > 0 .And. Posicione("SZP",1,xFilial("SZP")+dtos(dDat),"ZP_CXFECHA") != "S" .And. ;
		(aList3[len(alist3),04] > 0 .OR. aList4[len(alist4),04] > 0 .OR. aList4[len(alist4),04] > 0)
		DbSelectArea("SZP")
		DbSetOrder(1)
		If !DbSeek(cCodFil+dtos(dDat))
		    Reclock("SZP",.T.)
		    SZP->ZP_FILIAL	:=	cCodFil
		    SZP->ZP_DATA	:=	dDat
		Else
			Reclock("SZP",.F.)
		EndIf
		    
		For nX := 1 to len(aList3)
		 	cApoini	+= aList3[nX,01] + ";" + cvaltochar(aList3[nX,02]) + ";" + cvaltochar(aList3[nX,03])+ ";" + cvaltochar(aList3[nX,04]) +"|"
		Next nX
	
	   	SZP->ZP_APONINI	:=	cApoini

		For nX := 1 to len(aList4)
		 	cApofim	+= aList4[nX,01] + ";" + cvaltochar(aList4[nX,02]) + ";" + cvaltochar(aList4[nX,03])+ ";" + cvaltochar(aList4[nX,04]) +"|"
		Next nX
	
		SZP->ZP_APONFIM	:=	cApofim
		
		For nX := 1 to len(aList5)
		 	cApoced	+= aList5[nX,01] + ";" + cvaltochar(aList5[nX,02]) + ";" + cvaltochar(aList5[nX,03])+ ";" + cvaltochar(aList5[nX,04]) +"|"
		Next nX
	
		SZP->ZP_APONCED	:=	cApoced
		SZP->ZP_CXFECHA	:=	'N'
		SZP->(Msunlock())
		
	EndIf
EndIf

Return                                                                                                                                                     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC14  บAutor  ณMicrosiga           บ Data ณ  08/14/13   บฑฑ
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
Local nTotC	:=	0
Local nTotM	:=	0
Local aAux1	:=	{}
Local aAux2	:=	{}

aList	:=	{}
aList2	:=	{}
aList3	:=	{}
aList4	:=	{}
aList5	:=	{}

// Tratamento para caixa campinas - gravar na filial 03
If lCampinas
	cCodFil := "03"
EndIf

cQuery := "SELECT ZN_ROTA,SUM(ZN_MOEDA05*0.05)+SUM(ZN_MOEDA10*0.10)+SUM(ZN_MOEDA25*0.25)+SUM(ZN_MOEDA50*0.50)+SUM(ZN_MOEDA1R*1) AS MOEDA,"
//cQuery += " SUM(ZN_NOTA01*1)+SUM(ZN_NOTA02*2)+SUM(ZN_NOTA03*5)+SUM(ZN_NOTA04*10)+SUM(ZN_NOTA05*20)+SUM(ZN_NOTA06*50)+SUM(ZN_NOTA07*100) AS CEDULA"
cQuery += " SUM(ZN_NOTA01*1) AS CEDULA"
cQuery += " FROM "+RetSQLName("SZN")
cQuery += " WHERE ZN_FILIAL='"+xFilial("SZN")+"' AND ZN_ROTA<>'' AND ZN_TIPINCL IN('SANGRIA','AUDITORIA') AND ZN_DATA='"+DTOS(dDat)+"'"

// Se for conferencia do caixa de campinas - traz somente Rota Campinas
If lCampinas                                                            
	cQuery += " AND ZN_ROTA = 'RT0003' "  
Else
	cQuery += " AND ZN_ROTA <> 'RT0003' "                                                                                        
EndIf
 
cQuery += " AND D_E_L_E_T_='' "
cQuery += " GROUP BY ZN_ROTA "
                                              
If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTATFC07.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")

While !EOF()
    Aadd(aList,{TRB->ZN_ROTA,TRB->CEDULA,TRB->MOEDA}) 
    nTotC	+=	TRB->CEDULA
    nTotM	+=	TRB->MOEDA
	DbSkip()
EndDo

If len(aList) < 1
	Aadd(aList,{'','',''})
	Aadd(aList2,{'',0,0,0})
	Aadd(aList3,{'','','',''})
	Aadd(aList4,{'','','',''})
	Aadd(aList5,{'','','',''})
	oBtn3:disable()			
Else
	Aadd(aList2,{'',0,0,0})
	aList2[1,1]	:= 'Totais'
	aList2[1,2]	:= nTotC + nTotM
	aList2[1,3]	:= nTotC 
	aList2[1,4]	:= nTotM
    oBtn3:enable()
    
	cQuery := "SELECT * FROM "+RetSQLName("SZP")+" WHERE ZP_FILIAL='"+cCodFil+"' AND ZP_DATA='"+DTOS(dDat)+"' AND D_E_L_E_T_=''" 
	If Select("TRB") > 0
		dbSelectArea("TRB")
		dbCloseArea()
	EndIf
	  
	MemoWrite("TTATFC07.SQL",cQuery)
	
	cQuery:= ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
	
	DbSelectArea("TRB")
    
	If !Empty(TRB->ZP_APONINI)
 		aAux1 := strtokarr(TRB->ZP_APONINI,"|")
 		For nX := 1 to len(aAux1)
 			aAux2 := strtokarr(aAux1[nX],";")
 			If !Empty(aAux2[1])
	 			Aadd(aList3,{aAux2[1],val(aAux2[2]),val(aAux2[3]),val(aAux2[4])})
	 		EndIf
 		Next nX
 		aAux1 := strtokarr(TRB->ZP_APONFIM,"|")
 		For nX := 1 to len(aAux1)
 			aAux2 := strtokarr(aAux1[nX],";")
 			If !Empty(aAux2[1])
	 			Aadd(aList4,{aAux2[1],val(aAux2[2]),val(aAux2[3]),val(aAux2[4])})
	 		endif
 		Next nX
 		aAux1 := strtokarr(TRB->ZP_APONCED,"|")
 		For nX := 1 to len(aAux1)
 			aAux2 := strtokarr(aAux1[nX],";")
 			If !Empty(aAux2[1])
	 			Aadd(aList5,{aAux2[1],val(aAux2[2]),val(aAux2[3]),val(aAux2[4])})
	 		endif
 		Next nX
 	Else
		//Aadd(aList2,{'Totais',nTotC+nTotM,nTotC,nTotM})
		Aadd(aList3,{'R$ 0,01',0,0,0})
		Aadd(aList3,{'R$ 0,05',0,0,0})
		Aadd(aList3,{'R$ 0,10',0,0,0})
		Aadd(aList3,{'R$ 0,25',0,0,0})
		Aadd(aList3,{'R$ 0,50',0,0,0})
		Aadd(aList3,{'R$ 1,00',0,0,0})
		Aadd(aList3,{'Totais',0,0,0})
		Aadd(aList4,{'R$ 0,01',0,0,0})
		Aadd(aList4,{'R$ 0,05',0,0,0})
		Aadd(aList4,{'R$ 0,10',0,0,0})
		Aadd(aList4,{'R$ 0,25',0,0,0})
		Aadd(aList4,{'R$ 0,50',0,0,0})
		Aadd(aList4,{'R$ 1,00',0,0,0})
		Aadd(aList4,{'Totais',0,0,0})
		Aadd(aList5,{'R$   1,00',0,0,0})
		Aadd(aList5,{'R$   2,00',0,0,0})
		Aadd(aList5,{'R$   5,00',0,0,0})
		Aadd(aList5,{'R$  10,00',0,0,0})
		Aadd(aList5,{'R$  20,00',0,0,0})
		Aadd(aList5,{'R$  50,00',0,0,0})
		Aadd(aList5,{'R$ 100,00',0,0,0})
		Aadd(aList5,{'Totais',0,0,0})   
	EndIf
	
EndIf

oList:SetArray(aList)
oList:bLine := {||{ aList[oList:nAt,01],; 
					 Transform(aList[oList:nAt,02],"@E 999,999,999.99"),;
 					 Transform(aList[oList:nAt,03],"@E 999,999,999.99")}}

oList:refresh()

oList2:SetArray(aList2)
oList2:bLine := {||{ aList2[oList2:nAt,01],; 
					 Transform(aList2[oList2:nAt,02],"@E 999,999,999.99"),;
 					 Transform(aList2[oList2:nAt,03],"@E 999,999,999.99"),;
 					 Transform(aList2[oList2:nAt,04],"@E 999,999,999.99")}}

oList3:SetArray(aList3)
oList3:bLine := {||{ aList3[oList3:nAt,01],; 
					 aList3[oList3:nAt,02],;
 					 aList3[oList3:nAt,03],;
 					 aList3[oList3:nAt,04]}}

oList4:SetArray(aList4)
oList4:bLine := {||{ aList4[oList4:nAt,01],; 
					 aList4[oList4:nAt,02],;
 					 aList4[oList4:nAt,03],;
 					 aList4[oList4:nAt,04]}}

oList5:SetArray(aList5)
oList5:bLine := {||{ aList5[oList5:nAt,01],; 
					 aList5[oList5:nAt,02],;
 					 aList5[oList5:nAt,03],;
 					 aList5[oList5:nAt,04]}}

oList:refresh()
oList2:refresh()
oList3:refresh()
oList4:refresh()
oList5:refresh()

contagem()        

oDlg1:refresh()

RestArea(aArea)

Return                     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC14  บAutor  ณMicrosiga           บ Data ณ  08/15/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function editcol1()

Local aArea	:=	GetArea()                
Local aMult	:=	{0.01,0.05,0.10,0.25,0.50,1}
              
If  Posicione("SZP",1,cCodFil+dtos(dDat),"ZP_CXFECHA") != "S"
	If oList3:nAt < len(aList3)
		lEditCell(aList3, oList3, "@E 999,999,999.99",2)
		lEditCell(aList3, oList3, "@E 999,999,999.99",3) 
		
		aList3[oList3:nAt,04] := (aList3[oList3:nAt,03] * aMult[oList3:nAt]) + ((aList3[oList3:nAt,02] * 1000) * aMult[oList3:nAt])
		
		aList3[len(aList3),02] := 0
		aList3[len(aList3),03] := 0
		aList3[len(aList3),04] := 0
		
		For nX := 1 to len(aList3) - 1
			aList3[len(aList3),02] += aList3[nX,02]
			aList3[len(aList3),03] += aList3[nX,03]
			aList3[len(aList3),04] += aList3[nX,04]
		Next nX
		
		Transform(aList3[len(aList3),04],"@E 999,999,999.99")
	EndIf
	oList3:refresh()
	oDlg1:refresh()
		
	contagem()
EndIf		
RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC14  บAutor  ณMicrosiga           บ Data ณ  08/16/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function editcol2()

Local aArea	:=	GetArea()                
Local aMult	:=	{0.01,0.05,0.10,0.25,0.50,1}
    
If  Posicione("SZP",1,cCodFil+dtos(dDat),"ZP_CXFECHA") != "S"
	If oList4:nAt < len(aList4)
		lEditCell(aList4, oList4, "@E 999,999,999.99",2)
		lEditCell(aList4, oList4, "@E 999,999,999.99",3) 
		
		aList4[oList4:nAt,04] := (aList4[oList4:nAt,03] * aMult[oList4:nAt]) + ((aList4[oList4:nAt,02] * 1000) * aMult[oList4:nAt])
		
		aList4[len(aList4),02] := 0
		aList4[len(aList4),03] := 0
		aList4[len(aList4),04] := 0
		
		For nX := 1 to len(aList4) - 1
			aList4[len(aList4),02] += aList4[nX,02] - aList3[nX,02]
			aList4[len(aList4),03] += aList4[nX,03] - aList3[nX,03]
			aList4[len(aList4),04] += aList4[nX,04] - aList3[nX,04]
		Next nX
		
		Transform(aList4[len(aList4),04],"@E 999,999,999.99")
	EndIf        
	
	oList4:refresh()
	oDlg1:refresh()
	
	contagem()
EndIf
		
RestArea(aArea)

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC14  บAutor  ณMicrosiga           บ Data ณ  08/16/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function editcol3()

Local aArea	:=	GetArea()                
Local aMult	:=	{1,2,5,10,20,50,100}

If Posicione("SZP",1,cCodFil+dtos(dDat),"ZP_CXFECHA") != "S"
	If oList5:nAt < len(aList5)
		lEditCell(aList5, oList5, "@E 999,999,999.99",2)
		lEditCell(aList5, oList5, "@E 999,999,999.99",3) 
		
		aList5[oList5:nAt,04] := (aList5[oList5:nAt,03] * aMult[oList5:nAt]) + ((aList5[oList5:nAt,02] * 100) * aMult[oList5:nAt])
		
		aList5[len(aList5),02] := 0
		aList5[len(aList5),03] := 0
		aList5[len(aList5),04] := 0
		
		For nX := 1 to len(aList5) - 1
			aList5[len(aList5),02] += aList5[nX,02]
			aList5[len(aList5),03] += aList5[nX,03]
			aList5[len(aList5),04] += aList5[nX,04]
		Next nX
		
		Transform(aList5[len(aList5),04],"@E 999,999,999.99")
	EndIf        
	
	oList5:refresh()
	oDlg1:refresh()
	
	contagem()
EndIf
	
RestArea(aArea)

Return                       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC14  บAutor  ณMicrosiga           บ Data ณ  08/16/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function contagem()

Local aArea	:=	GetArea()
Local nRetC	:=	0
Local nRetM	:=	0
Local nTotG	:=	0        
Local lTotC	:=	.F.
Local lTotM	:=	.F.
Local lTotG	:=	.F.

oSay3:settext("")
oSay4:settext("")
oSay5:settext("")       
oSay6:settext("")

nRetC := aList5[len(aList5),04]
nRetM := aList4[len(aList4),04]  //aList3[len(aList3),04] + aList4[len(aList4),04] //
nTotG := nRetC + nRetM

If ValType(nTotG) == "N"
	oSay5:settext(Transform(nTotG,"@E 999,999,999.99"))
	oSay3:settext(Transform(nRetC,"@E 999,999,999.99"))
	oSay4:settext(Transform(nRetM,"@E 999,999,999.99"))	
	
	If aList2[len(aList2),02] == nTotG
		lTotG	:=	.T.
	EndIf
	
	If aList2[len(aList2),03] == nRetC
		lTotC	:=	.T.
	EndIf
	
	If aList2[len(aList2),04] == nRetM
		lTotM	:=	.T.
	EndIf    
EndIf


oSay6:settext(If(lTotG .And. lTotC .And. lTotM,"Caixa Batido","Caixa nใo Batido"))  

If lTotG .And. lTotC .And. lTotM .AND. Posicione("SZP",1,cCodFil+dtos(dDat),"ZP_CXFECHA") != "S"
	oBtn2:enable()
EndIf

oDlg1:refresh()

RestArea(aArea)

Return                                                                          

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC14  บAutor  ณMicrosiga           บ Data ณ  08/20/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Gravar()

Local aArea	:=	GetArea()
Local cQuery
Local aMoedas	:=	{0.05,0.10,0.25,0.50,1}
Local aCedulas	:=	{1,2,5,10,20,50,100}
Local nTot1		:=	0
Local nTot2		:=	0
Local aRotas	:=	{}
Local aAux		:=	{}

cQuery := "SELECT ZN_FILIAL,ZN_DATA,ZN_PATRIMO,ZN_CLIENTE,ZN_LOJA,ZN_CONFERE,ZN_TIPINCL,ZN_MOEDA05,ZN_MOEDA10,ZN_MOEDA25,ZN_MOEDA50,
//cQuery += " ZN_MOEDA1R,ZN_NOTA01,ZN_NOTA02,ZN_NOTA03,ZN_NOTA04,ZN_NOTA05,ZN_NOTA06,ZN_NOTA07,ZN_ROTA,ZN_TROCO,ZN_ROTA"
cQuery += " ZN_MOEDA1R,ZN_NOTA01,ZN_ROTA,ZN_TROCO,ZN_ROTA"
cQuery += " FROM "+RetSQLName("SZN")
cQuery += " WHERE ZN_FILIAL='"+xFilial("SZN")+"' AND ZN_TIPINCL IN ('SANGRIA','AUDITORIA') AND ZN_DATA='"+DTOS(dDat)+"' AND D_E_L_E_T_='' AND ZN_CONFERE <> 'X' "

// Se for conferencia do caixa de campinas - traz somente Rota Campinas
If lCampinas                                                            
	cQuery += " AND ZN_ROTA = 'RT0003' "                                                                                          
Else
	cQuery += " AND ZN_ROTA <> 'RT0003' "                                                                                          
EndIf
      
If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTATFC07.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")

While !EOF()
	nTot1 := (TRB->ZN_MOEDA05 * aMoedas[1]) + (TRB->ZN_MOEDA10 * aMoedas[2]) + (TRB->ZN_MOEDA25 * aMoedas[3]) + (TRB->ZN_MOEDA50 * aMoedas[4]) + (TRB->ZN_MOEDA1R * aMoedas[5])
	//nTot2 := (TRB->ZN_NOTA01 * aCedulas[1]) + (TRB->ZN_NOTA02 * aCedulas[2]) + (TRB->ZN_NOTA03 * aCedulas[3]) + (TRB->ZN_NOTA04 * aCedulas[4]) + (TRB->ZN_NOTA05 * aCedulas[5]) + (TRB->ZN_NOTA06 * aCedulas[6]) + (TRB->ZN_NOTA07 * aCedulas[7]) 
	nTot2 := (TRB->ZN_NOTA01 * aCedulas[1]) 
	TST100(nTot1+nTot2,TRB->ZN_PATRIMO,STOD(TRB->ZN_DATA),TRB->ZN_TROCO,TRB->ZN_ROTA)
	confere(TRB->ZN_FILIAL,STOD(TRB->ZN_DATA),TRB->ZN_PATRIMO)
	
	If Ascan(aRotas,{|x| Alltrim(x[1]) == Alltrim(TRB->ZN_ROTA)}) == 0
		Aadd(aRotas,{TRB->ZN_ROTA,stod(TRB->ZN_DATA)})
	EndIf
	
	DbSelectArea("TRB")
	Dbskip()
EndDo

For nX := 1 to len(aRotas)
	aAux := {}
	Aadd(aAux,aRotas[nX,01])
	Aadd(aAux,aRotas[nX,02])
	U_TTFINC26(aAux)
Next nX

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC14  บAutor  ณMicrosiga           บ Data ณ  08/20/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TST100(nVlr,cPat,dData,nTroco,cRota)  
                    
Local aArea		:=	GetArea()
Local nOpc     := 0
Local aFINA100 := {}
Local dDat		:=	dDatabase
Private lMsErroAuto := .F.
                             
dDatabase := dData      

DbSelectArea("SA6")
DbSetOrder(1)
If !DbSeek(xFilial("SA6")+"CXP000000"+Avkey(cPat,"N1_CHAPA"))
	Reclock("SA6",.T.)
	SA6->A6_FILIAL	:=	xFilial("SA6")
	SA6->A6_COD		:=	"CXP"
	SA6->A6_AGENCIA	:=	"000000"
	SA6->A6_NUMCON	:=	cPat
	SA6->A6_NOME	:=	"CAIXA SANGRIA PATRIMONIO "+cPat
	SA6->(Msunlock())
EndIf

aFINA100 := {	{"E5_DATA"		,dData                        ,Nil},;
                {"E5_MOEDA"     ,"M1"                         ,Nil},;
                {"E5_VALOR"     ,nVlr                         ,Nil},;
                {"E5_NATUREZ"   ,"10101035"                   ,Nil},;
                {"E5_BANCO"     ,"CXP"                        ,Nil},;
                {"E5_AGENCIA"   ,"000000"                     ,Nil},;
                {"E5_CONTA"     ,cPat	     	           	  ,Nil},;
                {"E5_HISTOR"    ,"SANGRIA TESOURARIA"	  	  ,Nil}}

MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINA100,3)
 
If lMsErroAuto
	MostraErro()
EndIf

lMsErroAuto := .F.
    
aFINA100 := {	{"E5_DATA"		,dData                        ,Nil},;
                {"E5_MOEDA"     ,"M1"                         ,Nil},;
                {"E5_VALOR"     ,nVlr                         ,Nil},;
                {"E5_NATUREZ"   ,"10101009"                   ,Nil},;
                {"E5_BANCO"     ,"CXG"                        ,Nil},;
                {"E5_AGENCIA"   ,"000001"                     ,Nil},;
		         {"E5_CONTA"     ,IF(lCampinas,"000003", If(cfilant="01","000000         ","0000"+strzero(val(cfilant),2)+space(9)) )             ,Nil},;
                {"E5_HISTOR"    ,"SANGRIA PATRIMONIO "+cPat+" ROTA "+cRota	  ,Nil}}

MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINA100,4)
 
If lMsErroAuto
	MostraErro()
EndIf

If nTroco > 0
	lMsErroAuto	:=	.F.
	
	aFINA100 := {	{"E5_DATA"		,dData                        ,Nil},;
	                {"E5_MOEDA"     ,"M1"                         ,Nil},;
	                {"E5_VALOR"     ,nTroco                       ,Nil},;
	                {"E5_NATUREZ"   ,"10101009"                   ,Nil},;
	                {"E5_BANCO"     ,"CXP"                        ,Nil},;
	                {"E5_AGENCIA"   ,"000000"                     ,Nil},;
	                {"E5_CONTA"     ,cPat	     	           	  ,Nil},;
	                {"E5_HISTOR"    ,"ABAST. TROCO ROTA "+cRota	  ,Nil}}
	
	MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINA100,4)
	 
	If lMsErroAuto
		MostraErro()
	EndIf
	
	lMsErroAuto := .F.
	    
	aFINA100 := {	{"E5_DATA"		,dData                        ,Nil},;
	                {"E5_MOEDA"     ,"M1"                         ,Nil},;
	                {"E5_VALOR"     ,nTroco                       ,Nil},;
	                {"E5_NATUREZ"   ,"10101009"                   ,Nil},;
	                {"E5_BANCO"     ,"CXT"                        ,Nil},;
	                {"E5_AGENCIA"   ,"000000"                     ,Nil},;
	                {"E5_CONTA"     ,cRota				          ,Nil},;
	                {"E5_HISTOR"    ,"ABAST. TROCO PATR. "+cPat	  ,Nil}}
	
	MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINA100,3)
	 
	If lMsErroAuto
		MostraErro()
	EndIf
	
EndIf

dDatabase    := dDat 

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC14  บAutor  ณMicrosiga           บ Data ณ  08/20/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function confere(cFIL,dia,pat)

Local aArea	:=	GetArea()

DbSelectArea("SZN")
DbSetORder(2)
If DbSeek(cFIL+DTOS(dia)+Avkey(pat,"ZN_PATRIMO")+AvKey('SANGRIA',"ZN_TIPINCL"))
	Reclock("SZN",.F.)
	SZN->ZN_CONFERE	:=	'X'
	SZN->(Msunlock())
EndIf

If DbSeek(cFIL+DTOS(dia)+Avkey(pat,"ZN_PATRIMO")+AvKey('AUDITORIA',"ZN_TIPINCL"))
	Reclock("SZN",.F.)
	SZN->ZN_CONFERE	:=	'X'
	SZN->(Msunlock())
EndIf


RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC14  บAutor  ณMicrosiga           บ Data ณ  03/27/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio consolidado do fundo de troco de todas as rotas บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fdotroco()

Local aArea	:= GetArea()
Local aBrw1	:= {} 
Local aAux	:= {}
Local oExcel := FWMSEXCEL():New()
Local cTitulo := "Fundo_de_troco"
Local cDir := ""
Local cArqXls := "Fundo_de_troco.xml" 

cDir := cGetFile(, OemToAnsi("Selecione o diret๓rio de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 

If Empty(cDir)
	Return
EndIf

For nX := 1 to len(aList)
	aAux := U_TTFINR14({aList[nX,01],dDat,.T.})
	Aadd(aBrw1,aAux[1])	
Next nX


cCabecalho := "GERAL"
oExcel:AddworkSheet("Fundo_de_troco") 
oExcel:AddTable ("Fundo_de_troco",cCabecalho)
oExcel:AddColumn("Fundo_de_troco",cCabecalho,"Rota",1,1)
oExcel:AddColumn("Fundo_de_troco",cCabecalho,"Total_Troco",1,1)
oExcel:AddColumn("Fundo_de_troco",cCabecalho,"Total_Cedulas",1,1)
oExcel:AddColumn("Fundo_de_troco",cCabecalho,"Total_Moedas",1,1)
oExcel:AddColumn("Fundo_de_troco",cCabecalho,"Total_POS",1,1)
oExcel:AddColumn("Fundo_de_troco",cCabecalho,"Total_Venda",1,1)
oExcel:AddColumn("Fundo_de_troco",cCabecalho,"Total_Sangria",1,1)
oExcel:AddColumn("Fundo_de_troco",cCabecalho,"Total_Adicao_Liquida",1,1)

For nI := 1 To Len(aBrw1)
	oExcel:AddRow("Fundo_de_troco",cCabecalho,{aBrw1[nI][1],; 	//Produto
											Transform(aBrw1[nI][2],"@E 999,999,999.99"),;		//Descricao
											Transform(aBrw1[nI][3],"@E 999,999,999.99"),;		//Qtd
											Transform(aBrw1[nI][4],"@E 999,999,999.99"),;
											Transform(aBrw1[nI][5],"@E 999,999,999.99"),;
											Transform(aBrw1[nI][6],"@E 999,999,999.99"),;
											Transform(aBrw1[nI][7],"@E 999,999,999.99"),;
											Transform(aBrw1[nI][8],"@E 999,999,999.99")}) 
Next nI

oExcel:Activate()

oExcel:GetXMLFile(cDir +cArqXls)

If File(cDir +cArqXls)
	Aviso("TTFINC14","A planilha foi gerada em "+cDir,{"Ok"})
	If !ApOleClient( 'MsExcel' )
		Aviso("TTFINC14", 'MsExcel nใo instalado. ' +CRLF +'O arquivo estแ em: '+cDir )
	Else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cDir +cArqXls )
		oExcelApp:SetVisible(.T.)         
		oExcelApp:Destroy()
	EndIf
EndIf  

RestArea(aArea)

Return