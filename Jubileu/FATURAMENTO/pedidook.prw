#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³         ³ Autor ³                       ³ Data ³           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³                  ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Aplicacao ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista Resp.³  Data  ³                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³  /  /  ³                                               ³±±
±±³              ³  /  /  ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function JbFat01

Private oDlg1,oGrp1,oBrw1,oGrp2,oBrw2,oGrp3,oBrw3,oGrp4,oBrw4,oBtn1
Private oList1
Private oList2
Private oList3
Private oList4
Private aList1 := {}
Private aList2 := {}
Private aList3 := {}
Private aList4 := {}
Private aList2B := {}
Private aList3B := {}
Private aList4B := {}
Private oOk   	:= LoadBitmap(GetResources(),'br_verde')       //Controla se o pedido foi alterado ou nao no grid.
Private oNo   	:= LoadBitmap(GetResources(),'br_vermelho')    
Private oFont1 := TFont():New('Arial',,-15,.T.)
Private oFont2 := TFont():New('Arial',,-12,.T.)
Private oFont3 := TFont():New('Verdana',,-12,.T.)
Private oFont5 	:= TFont():New('Arial',,-18,.T.)

If Empty(FunName())
	RpcSetType(3)
	RPCSetEnv("01","0301")
EndIf

Aadd(aList1,{"","","","",.F.,"","","","",""})
Aadd(aList2,{"","","","",.F.,"","","","",""})
Aadd(aList3,{"","","","","","","","","",""})
Aadd(aList4,{"","","","","","","","","",""})

oDlg1      := MSDialog():New( 092,232,660,1259,"Integração PedidoOk!",,,.F.,,,,,,.T.,,,.T. )

oGrp1      := TGroup():New( 000,008,124,252,"Cabeçalho PedidoOk",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
//oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{008,012,120,248},,, oGrp1 ) 
oList1 	   := TCBrowse():New(008,010,240,110,, {'','Numero','Emissão','Obs_Cliente','Obs_Representada'},{10,40,40,60,60},;
		                            oGrp1,,,,{|| FHelp(oList1:nAt)},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
		oList1:SetArray(aList1)
		oList1:bLine := {||{ If(aList1[oList1:nAt,05],oOk,oNo),;
                             aList1[oList1:nAt,01],; 
		 					 aList1[oList1:nAt,02],;
                             aList1[oList1:nAt,03],; 
		 					 aList1[oList1:nAt,04]}}

oGrp3      := TGroup():New( 128,008,252,252,"Itens PedidoOk",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
//oBrw3      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{136,012,248,248},,, oGrp3 ) 
oList3 	   := TCBrowse():New(136,010,240,110,, {'Item','Cod.Produto','Qtd','Valor Bruto','Valor Liquido'},{20,40,40,60,60},;
		                            oGrp3,,,,{|| /*FHelp(oList1:nAt)*/},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
		oList3:SetArray(aList3)
		oList3:bLine := {||{ aList3[oList3:nAt,01],; 
		 					 aList3[oList3:nAt,02],;
                             aList3[oList3:nAt,03],;
                             aList3[oList3:nAt,04],; 
		 					 aList3[oList3:nAt,05]}}

oGrp2      := TGroup():New( 000,256,124,500,"Cabeçalho Protheus",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
//oBrw2      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{008,260,120,496},,, oGrp2 ) 
oList2 	   := TCBrowse():New(008,258,240,110,, {'','Numero','Cliente','Status','Emissão'},{10,40,40,60,60},;
		                            oGrp2,,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
		oList2:SetArray(aList2)
		oList2:bLine := {||{ iF(aList2[oList2:nAt,05],oOk,oNo),;
                             aList2[oList2:nAt,01],; 
		 					 aList2[oList2:nAt,02],;
                             aList2[oList2:nAt,03],; 
		 					 aList2[oList2:nAt,04]}}

oGrp4      := TGroup():New( 128,256,252,500,"Itens Protheus",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
//oBrw4      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{136,260,248,496},,, oGrp4 ) 
oList4 	   := TCBrowse():New(136,258,240,110,, {'','Item','Codigo','Descrição','Qtd'},{10,20,40,60,60},;
		                            oGrp4,,,,{|| /*FHelp(oList:nAt)*/},{|| /*editcol(oList:nAt)*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
		oList4:SetArray(aList4)
		oList4:bLine := {||{ If(aList4[oList4:nAt,05],oOk,oNo),;
                             aList4[oList4:nAt,01],; 
		 					 aList4[oList4:nAt,02],;
                             aList4[oList4:nAt,03],; 
		 					 aList4[oList4:nAt,04]}}

//oBtn1      := TButton():New( 256,464,"oBtn1",oDlg1,,037,012,,,,.T.,,"",,,,.F. )

oMenu := TMenu():New(0,0,0,0,.T.)
// Adiciona itens no Menu
oTMenuIte1 := TMenuItem():New(oDlg1,"Integrar Pedidos",,,,{|| integrar()},,,,,,,,,.T.)
oTMenuIte2 := TMenuItem():New(oDlg1,"Gerar Excel",,,,{|| excel()},,,,,,,,,.T.)
oTMenuIte9 := TMenuItem():New(oDlg1,"Sair",,,,{|| oDlg1:end()},,,,,,,,,.T.)

oMenu:Add(oTMenuIte1)
oMenu:Add(oTMenuIte2)
oMenu:Add(oTMenuIte9)

// Cria botão que sera usado no Menu
oTButton1 := TButton():New( 256, 464, "Opções",oDlg1,{|| /*alert("Botão 01")*/ },40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
// Define botão no Menu
oTButton1:SetPopupMenu(oMenu)

oSay1      := TSay():New( 260,008,{||"Status"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,028,012)
oSay2      := TSay():New( 260,040,{||"Sucesso"},oDlg1,,oFont5,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,412,012)


oDlg1:Activate(,,,.T.)

Return

Static Function FHelp(nLinha)
    
Local nX := 0

aList2 := {}
aList3 := {}
aList4 := {}

oSay2:settext("")

For nX := 1 to len(aList3B)
    If aList3B[nX,06] == aList1[nLinha,01]
        Aadd(aList3,aList3B[nX])
    EndIf
Next nX

For nX := 1 to len(aList2B)
    If aList2B[nX,06] == aList1[nLinha,01]
        Aadd(aList2,aList2B[nX])
    EndIf
Next nX


For nX := 1 to len(aList4B)
    If aList4B[nX,06] == aList1[nLinha,01]
        Aadd(aList4,aList4B[nX])
    EndIf
Next nX

If len(aList2) < 1
    Aadd(aList2,{"","","","",.f.,"","","","",""})
EndIf

If len(aList3) < 1
    Aadd(aList3,{"","","","","","","","","",""})
EndIf

If len(aList4) < 1
    Aadd(aList4,{"","","","",.F.,"","","","",""})
EndIf

oSay2:settext(If(!Empty(aList2[1,3]),if(aList2[1,5],' # Sucesso!!! #',' ### Falha ### ')+aList2[1,3],""))

oList2:nAt := 1
oList3:nAt := 1
oList4:nAt := 1

oList2:SetArray(aList2)
oList2:bLine := {||{ iF(aList2[oList2:nAt,05],oOk,oNo),;
                        aList2[oList2:nAt,01],; 
                        aList2[oList2:nAt,02],;
                        aList2[oList2:nAt,03],; 
                        aList2[oList2:nAt,04]}}

oList3:SetArray(aList3)
oList3:bLine := {||{ aList3[oList3:nAt,01],; 
                        aList3[oList3:nAt,02],;
                        aList3[oList3:nAt,03],; 
                        aList3[oList3:nAt,04],;
                        aList3[oList3:nAt,05]}}

oList4:SetArray(aList4)
oList4:bLine := {||{ If(aList4[oList4:nAt,05],oOk,oNo),;
                             aList4[oList4:nAt,01],; 
		 					 aList4[oList4:nAt,02],;
                             aList4[oList4:nAt,03],; 
		 					 aList4[oList4:nAt,04]}}

oList2:refresh()
oList3:refresh()
oList4:refresh()
oDlg1:refresh()


Return 

Static Function Integrar

U_WSPOK01()

Fhelp(oList1:nAt)    

Return
