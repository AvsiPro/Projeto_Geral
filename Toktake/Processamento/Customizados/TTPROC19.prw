#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ TTPROC19 ³ Autor ³ Alexandre Venancio    ³ Data ³ 12/09/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³                  ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Parametros para chamada da rotina de auditorias processamen³±±
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

User Function TTPROC19

Local oDlg1,oGrp1,oSay1,oSay2,oSay3,oSay4,oSay5,oGet1,oGet2,oGet3,oGet4,oGet5,oBtn1,oCBox1
Local nOp	:=	0
Local dDia	:=	ctod(" / / ") 
Local dDia1	:=	ctod(" / / ") 
Local dDia2	:=	ctod(" / / ") 
Local cLoja	:=	space(4)
Local cAnlt :=	space(6)
Local cComp	:=	space(7) 
Local cCont	:=	space(20)
Local aCombo:=	{"","Liberados","Pendentes"}
Local xCombo:=	aCombo[1]   
Local lTudo	:=	.F.

If cEmpAnt <> "01"
	return
EndIF

oDlg1      := MSDialog():New( 091,232,400,588,"Parâmetros",,,.F.,,,,,,.T.,,,.T. )

oGrp1      := TGroup():New( 004,004,120,168,"Opções",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay1      := TSay():New( 020,008,{||"Data Fechamento"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,062,008)
	oGet1      := TGet():New( 020,064,{|u|If(Pcount()>0,dDia:=u,dDia)},oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	//oGet2      := TGet():New( 020,124,{|u|If(Pcount()>0,cLoja:=u,cLoja)},oGrp1,036,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	oCBox1     := TCheckBox():New( 021,127,"Trazer tudo",{|u| If(Pcount()>0,lTudo:=u,lTudo)},oDlg1,056,008,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )

	oSay2      := TSay():New( 040,008,{||"Analista"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oGet3      := TGet():New( 040,064,{|u|If(Pcount()>0,cAnlt:=u,cAnlt)},oGrp1,060,008,'',{||If(!Empty(cAnlt),oSay5:settext(UsrFullName(cAnlt)),oSay5:settext(""))},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"USR","",,)
	
	oSay3      := TSay():New( 060,008,{||"Competência"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oGet4      := TGet():New( 060,064,{|u|If(Pcount()>0,cComp:=u,cComp)},oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	
	oSay4      := TSay():New( 080,016,{||UsrFullName()},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,232,008)
	//oCBox1     := TComboBox():New( 080,052,{|u|If(Pcount()>0,xCombo:=u,xCombo)},aCombo,060,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
    
	oSay5      := TSay():New( 100,016,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,232,008)
	//oGet5      := TGet():New( 100,052,{|u|If(Pcount()>0,cCont:=u,cCont)},oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"CN9","",,)
	
	oGD1      := TGet():New( 90,064,{|u|If(Pcount()>0,dDia1:=u,dDia1)},oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	oGD2      := TGet():New( 100,064,{|u|If(Pcount()>0,dDia2:=u,dDia2)},oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	
	oBtn1      := TButton():New( 134,040,"Confirmar",oDlg1,{||oDlg1:end(nOp:=1)},037,012,,,,.T.,,"",,,,.F. )
	oBtn2      := TButton():New( 134,100,"Sair",oDlg1,{||oDlg1:end(nOp:=0)},037,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

If nOp == 1
	MV_PAR01	:=	dDia
	MV_PAR02	:=	cAnlt
	MV_PAR03	:=	cComp
	MV_PAR04	:=	lTudo 
	MV_PAR05	:=	cCont
	MV_PAR06	:=	dDia1
	MV_PAR07	:=	dDia2
	Processa({ || U_TTPROC20(),"Aguarde..."})
EndIf

Return