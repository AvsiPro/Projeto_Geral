#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'  
#INCLUDE 'TBICONN.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ TTCNTA03 ³ Autor ³ Alexandre Venancio    ³ Data ³ 02/09/13 ³±±
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

User Function TTCNTA03

SetPrvt("oDlg1","oGrp1","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oSay7","oSay8","oSay9","oSay10")
SetPrvt("oSay12","oGet1","oGet2","oCBox1","oCBox2","oGrp2","oBrw1","oBtn1","oBtn2","oBtn3","oBtn4")      
Private oOk   	:= LoadBitmap(GetResources(),'br_verde')       //Controla se o pedido foi alterado ou nao no grid.
Private oNo   	:= LoadBitmap(GetResources(),'br_vermelho')  

Private aList	:=	{}
Private oList

If cEmpAnt <> "01"
	Return
EndIF
//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "EST" TABLES "SCP","SB1"   

Aadd(aList,{.F.,'','','',''})

oDlg1      := MSDialog():New( 091,232,548,925,"Reajuste de Contratos",,,.F.,,,,,,.T.,,,.T. )

	oGrp1      := TGroup():New( 004,004,076,336,"Informações Contrato",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		oSay1      := TSay():New( 016,012,{||"Numero Contrato"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
		oGet1      := TGet():New( 016,056,,oGrp1,080,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

		oSay2      := TSay():New( 016,204,{||"Percentual Reajuste %"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,056,008)
		oGet2      := TGet():New( 016,260,,oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

		oSay3      := TSay():New( 040,012,{||"Apenas Item"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oCBox1     := TComboBox():New( 040,056,,,024,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )

		oSay4      := TSay():New( 040,088,{||"Cliente"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
		oSay5      := TSay():New( 040,112,{||"xyz"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,208,008)

		oSay6      := TSay():New( 060,012,{||"Data Ultimo Reajuste"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,056,008)
		oSay7      := TSay():New( 060,068,{||"10/01/2013"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)

		oSay8      := TSay():New( 060,108,{||"Índice"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
		oSay9      := TSay():New( 060,132,{||"IPCA - 12%"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)

		oSay10     := TSay():New( 060,164,{||"Obs.:"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,008)
		oSay11     := TSay():New( 060,188,{||"isento"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,132,008)

		oSay12     := TSay():New( 016,140,{||"Índice"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
		oCBox2     := TComboBox():New( 016,164,,,036,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )

	oGrp2      := TGroup():New( 084,004,200,336,"Patrimonios",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
		//oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{096,012,188,328},,, oGrp2 )
		oList := TCBrowse():New(096,012,320,098,, {'Moeda','X Mil','Unidade','Total'},{60,40,40,40},;
                           oGrp2,,,,{|| },{|| editcol()},, ,,,  ,,.F.,,.T.,,.F.,,,)
 
		oList:SetArray(aList)
		oList:bLine := {||{If(aList[oList:nAt,01],oOk,oNo),; 
						     aList[oList:nAt,02],; 
	 						 aList[oList:nAt,03],;
	 						 aList[oList:nAt,04]}}       


oBtn1      := TButton():New( 204,056,"Simular",oDlg1,,037,012,,,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 204,116,"Confirmar",oDlg1,,037,012,,,,.T.,,"",,,,.F. )
oBtn3      := TButton():New( 204,232,"Sair",oDlg1,,037,012,,,,.T.,,"",,,,.F. )
oBtn4      := TButton():New( 204,176,"Isentar",oDlg1,,037,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

Return
