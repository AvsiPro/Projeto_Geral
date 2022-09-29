#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH' 
#INCLUDE 'TBICONN.CH' 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC28  บAutor  ณMicrosiga           บ Data ณ  02/24/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Rotina para acerto de configuracao de sistema de pagamentoบฑฑ
ฑฑบ          ณno patrimonio atraves da prestacao de contas da tesouraria. บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTFINC28(cPatrimonio)

Local aArea		:=	GetArea()
Local cSisPg	//:=	Posicione("SN1",2,xFilial("SN1")+Avkey(cPatrimonio,"N1_CHAPA")) 
Local nP		:=	0      
Local cVar		:=	''
Local cBar		:=	''
Local aSisPg	:=	{"CE","MC","MS","VR","SM","PO","CI","CA"} 
Local nPos		:=	0
Private cPatr		:=	space(10)
Private oDlg1,oGrp1,oCBox1,oCBox2,oCBox3,oCBox4,oCBox5,oCBox6,oCBox7,oCBox8,oBtn1
Private oGet1 
Private lCheck1,lCheck2,lCheck3,lCheck4,lCheck5,lCheck6,lCheck7,lCheck8 
Private aSelPg	:=	{0,0,0,0,0,0,0,0}

//Prepare Environment Empresa "01" Filial "01" Tables "SD3" 

cSisPg := Posicione("SN1",2,xFilial("SN1")+Avkey(cPatrimonio,"N1_CHAPA"),"N1_XSISPG")  

//If Empty(cSisPg)
	
	
	oDlg1      := MSDialog():New( 088,232,356,628,"Sistema de Pagamento do Patrim๔nio - "+cPatrimonio,,,.F.,,,,,,.T.,,,.T. )
	oGrp1      := TGroup():New( 012,004,104,192,"Informe o Sistema de Pagamento",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

	oCBox1     := TCheckBox():New( 029,020,"CE=Cedula",{|u|If(Pcount()>0,lCheck1:=u,lCheck1)},oGrp1,048,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	oCBox2     := TCheckBox():New( 029,112,"MC=Moedeiro c/ Troco",{|u|If(Pcount()>0,lCheck2:=u,lCheck2)},oGrp1,068,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	oCBox3     := TCheckBox():New( 049,020,"MS=Moedeiro s/ Troco",{|u|If(Pcount()>0,lCheck3:=u,lCheck3)},oGrp1,072,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	oCBox4     := TCheckBox():New( 049,112,"VR",{|u|If(Pcount()>0,lCheck4:=u,lCheck4)},oGrp1,048,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	oCBox5     := TCheckBox():New( 069,020,"SM=Smart",{|u|If(Pcount()>0,lCheck5:=u,lCheck5)},oGrp1,048,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	oCBox6     := TCheckBox():New( 069,112,"PO=POS",{|u|If(Pcount()>0,lCheck6:=u,lCheck6)},oGrp1,048,008,,{||POS()},,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	oGet1      := TGet():New( 069,146,{|u|If(PCount()>0,cPatr:=u,cPatr)},oGrp1,040,008,'',{||!Empty(cPatr)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

	oCBox7     := TCheckBox():New( 088,020,"CI=Cartใo Indutivo",{|u|If(Pcount()>0,lCheck7:=u,lCheck7)},oGrp1,056,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	oCBox8     := TCheckBox():New( 088,112,"CA=Caneta",{|u|If(Pcount()>0,lCheck8:=u,lCheck8)},oGrp1,048,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
	oBtn1      := TButton():New( 112,076,"OK",oDlg1,{||oDlg1:end(nP:=1)},037,012,,,,.T.,,"",,,,.F. )
	
    oGet1:hide()
	oDlg1:Activate(,,,.T.) 
//EndIf

If !Empty(cPatr)
	DbSelectArea("ZZN")
	DbSetOrdeR(1)
	IF !DbSeek(xFilial("ZZN")+cPatr)
		nPos++
	EndIf
	DbSetORder(2)
	IF !DbSeek(xFilial("ZZN")+cPatr)
		nPos++
	EndIf
	If nPos > 1
		MsgAlert("Nใo existe este POS cadastrado na Base","TTFINC28")
		nP := 0
	EndIf		
EndIF
	
If nP == 1 
	cBar	:=	"" 
	For nX := 1 to 8
		If &('lCheck'+cvaltochar(nX))
			cVar +=	  cBar +	aSisPg[nX]+"=1"
		Else
			cVar +=	  cBar +	aSisPg[nX]+"=0"
		EndIf
		cBar :=		"|"
	Next nX 
	
	If !Empty(cVar)
		DbSelectArea("SN1")
		DbSetOrder(2)
		If DbSeek(xFilial("SN1")+Avkey(cPatrimonio,"N1_CHAPA"))
			Reclock("SN1",.F.)
			SN1->N1_XSISPG	:=	cVar
			SN1->(Msunlock())
		EndIf
	EndIf
	                 
EndIf

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC28  บAutor  ณMicrosiga           บ Data ณ  10/28/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function POS()

If lCheck6
	oGet1:show()
	oGet1:setfocus()
Else
	oGet1:hide()
	cPatr		:=	space(10)
EndIf           

Return             