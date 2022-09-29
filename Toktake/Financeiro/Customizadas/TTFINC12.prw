#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'                                                                 
#INCLUDE 'TBICONN.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ TTFINC12 ³ Autor ³ Alexandre Venancio    ³ Data ³13/08/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³                  ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³  Rotina de manutencao das bandeiras SITEF                  ³±±
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

User Function TTFINC12(cOpc)

Local nOpc	:=	0             

Private aRede	:=	{}
Private aProc	:=	{}
Private aDiaS	:=	{"Todos","Segunda","Terça","Quarta","Quinta","Sexta","Sabado"}             
Private xCombo1
Private xCombo2
Private xCombo3	:=	If(cOpc=="1",aDiaS[1],ZZM->ZZM_DIASEM)
Private nTarifa	:=	If(cOpc=="1",0,ZZM->ZZM_TARIFA)                
Private nCstDoc	:=	If(cOpc=="1",0,ZZM->ZZM_CSTDOC)
Private nCstTef	:=	If(cOpc=="1",0,ZZM->ZZM_CSTTEF)
Private nTaxa	:=	If(cOpc=="1",0,ZZM->ZZM_TAXA)     
Private nCrtDia	:=	If(cOpc=="1","0",ZZM->ZZM_CORTE)
Private nPrzDep	:=	If(cOpc=="1","0",ZZM->ZZM_PRZDIA)
Private cBanco	:=	If(cOpc=="1",Space(3),ZZM->ZZM_BANCO)
Private cAgencia:=	If(cOpc=="1",Space(6),ZZM->ZZM_AGENCI)
Private cConta	:=	If(cOpc=="1",Space(15),ZZM->ZZM_CONTA)
Private cNome	:=	If(cOpc=="1",Space(25),ZZM->ZZM_PRODUT)
Private cDescr	:=	If(cOpc=="1",Space(35),ZZM->ZZM_DESCRI)

SetPrvt("oDlg1","oGrp1","oSay1","oSay2","oSay3","oSay4","oGet1","oGet2","oCBox1","oCBox2","oGrp2","oSay5")
SetPrvt("oSay7","oGet3","oGet4","oGet5","oGrp3","oGet6","oGrp4","oSay8","oSay9","oSay10","oSay11","oSay12")
SetPrvt("oGet7","oGet8","oGet9","oGet10","oGet11","oCBox3","oBtn1","oBtn2")
                     
//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" // MODULO "COM" //TABLES "SB1"
                                     
Aadd(aProc,"")
Aadd(aRede,"")

DbSelectArea("SX5")
DbSetOrder(1)
If DbSeek(xFilial("SX5")+'ZU')
	While !EOF() .AND. Alltrim(X5_TABELA) == "ZU"
		Aadd(aProc,Alltrim(SX5->X5_DESCRI))
		Dbskip()
	Enddo
endIf

DbSetOrder(1)
If DbSeek(xFilial("SX5")+'ZV')
	While !EOF() .AND. Alltrim(X5_TABELA) == "ZV"
		Aadd(aRede,Alltrim(SX5->X5_DESCRI))
		Dbskip()
	Enddo
endIf

xCombo1 := If(cOpc=="1",aProc[1],ZZM->ZZM_REDE)
xCombo2 := If(cOpc=="1",aRede[1],ZZM->ZZM_PROCES)

oDlg1      := MSDialog():New( 079,300,562,936,"Cadastro de Produto (Bandeiras)",,,.F.,,,,,,.T.,,,.T. )

	oGrp1      := TGroup():New( 004,004,064,308,"Produto",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

		oSay1      := TSay():New( 012,019,{||"Nome"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oGet1      := TGet():New( 020,020,{|u| If(Pcount()>0,cNome:=u,cNome)},oGrp1,080,008,'@!',{||!Empty(cNome)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

		oSay2      := TSay():New( 012,160,{||"Descrição"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oGet2      := TGet():New( 020,160,{|u| If(Pcount()>0,cDescr:=u,cDescr)},oGrp1,100,008,'@!',{||!Empty(cDescr)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

		oSay3      := TSay():New( 035,022,{||"Rede"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oCBox1     := TComboBox():New( 044,020,{|u| If(Pcount()>0,xCombo1:=u,xCombo1)},aRede,081,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )

		oSay4      := TSay():New( 036,161,{||"Processadora"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
		oCBox2     := TComboBox():New( 044,160,{|u| If(Pcount()>0,xCombo2:=u,xCombo2)},aProc,081,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
	
	oGrp2      := TGroup():New( 068,004,104,308,"Conta Depósito",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

		oSay5      := TSay():New( 077,020,{||"Banco"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oGet3      := TGet():New( 085,020,{|u| If(Pcount()>0,cBanco:=u,cBanco)},oGrp2,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA6","",,)

		oSay6      := TSay():New( 077,096,{||"Agência"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oGet4      := TGet():New( 085,096,{|u| If(Pcount()>0,cAgencia:=u,cAgencia)},oGrp2,048,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

		oSay7      := TSay():New( 077,184,{||"Conta"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oGet5      := TGet():New( 085,184,{|u| If(Pcount()>0,cConta:=u,cConta)},oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

	oGrp3      := TGroup():New( 108,004,140,308,"Custo DOC (R$)",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	
		oGet6      := TGet():New( 123,020,{|u| If(Pcount()>0,nCstDoc:=u,nCstDoc)},oGrp3,060,008,'@E 999,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	
	oGrp4      := TGroup():New( 144,004,208,308,"Parâmetros por Transação",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	
		oSay8      := TSay():New( 155,020,{||"Taxa %"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oGet7      := TGet():New( 164,020,{|u| If(Pcount()>0,nTaxa:=u,nTaxa)},oGrp4,060,008,'@R 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

		oSay9      := TSay():New( 155,130,{||"Tarifa (R$)"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oGet8      := TGet():New( 164,129,{|u| If(Pcount()>0,nTarifa:=u,nTarifa)},oGrp4,060,008,'@E 999,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

		oSay10     := TSay():New( 155,234,{||"Custo TEF (R$)"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
		oGet9      := TGet():New( 164,234,{|u| If(Pcount()>0,nCstTef:=u,nCstTef)},oGrp4,060,008,'@E 999,999,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

		oSay11     := TSay():New( 179,020,{||"Prazo Depósito (Dias)"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,053,008)
		oGet10     := TGet():New( 188,020,{|u| If(Pcount()>0,nPrzDep:=u,nPrzDep)},oGrp4,060,008,'@R 999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

		oSay12     := TSay():New( 179,130,{||"Corte (Dias)"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oGet11     := TGet():New( 188,129,{|u| If(Pcount()>0,nCrtDia:=u,nCrtDia)},oGrp4,060,008,'@R 999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

		oSay13     := TSay():New( 179,235,{||"Dia da Semana"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,041,008)
		oCBox3     := TComboBox():New( 188,234,{|u| If(Pcount()>0,xCombo3:=u,xCombo3)},aDiaS,061,010,oGrp4,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )

	oBtn1      := TButton():New( 216,100,"Confirmar",oDlg1,{||oDlg1:end(nOpc:=1)},037,012,,,,.T.,,"",,,,.F. )
	oBtn2      := TButton():New( 216,160,"Sair",oDlg1,{||oDlg1:end(nOpc:=0)},037,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)                                                     

If nOpc == 1
	Gravar(cOpc)	
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTFINC12  ºAutor  ³Microsiga           º Data ³  08/14/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Gravar(cOpc)


Local nTot	:=	0
//cNome,cDescr,xCombo1,xCombo2,cBanco,cAgencia,cConta,nCstDoc,nTaxa,nTarifa,nCstTef,nPrzDep,nCrtDia,xCombo3
DbSelectArea("ZZM")
DbSetOrder(1)    

Reclock("ZZM",If(cOpc=="1",.T.,.F.))
ZZM->ZZM_PRODUT	:= 	cNome
ZZM->ZZM_DESCRI	:=	cDescr	
ZZM->ZZM_REDE	:=	xCombo1
ZZM->ZZM_PROCES	:=	xCombo2
ZZM->ZZM_BANCO	:=	cBanco
ZZM->ZZM_AGENCI	:=	cAgencia
ZZM->ZZM_CONTA	:=	cConta
ZZM->ZZM_CSTDOC	:=	nCstDoc
ZZM->ZZM_TAXA	:=	nTaxa
ZZM->ZZM_TARIFA	:=	nTarifa
ZZM->ZZM_CSTTEF	:=	nCstTef
ZZM->ZZM_PRZDIA	:=	nPrzDep
ZZM->ZZM_CORTE	:=	nCrtDia
ZZM->ZZM_DIASEM	:=	If(Ascan(aDias,{|x| x = xCombo3})==1,"T",cvaltochar(Ascan(aDias,{|x| x = xCombo3})))
ZZM->(Msunlock())

cQuery := "SELECT COUNT(*) AS QTD " //ZZE_VLRBRU,ZZE_REDE,ZZE_PRODUT,ZZE_ESTTRA,ZZE_VLRENC,ZZE_CSTTEF,ZZE_VLRLIQ 
cQuery += " FROM "+RetSQLName("ZZE")
cQuery += " WHERE ZZE_PRODUT='"+cNome+"' AND ZZE_REDE='"+xCombo1+"'" 

If nTarifa + nTaxa > 0
	cQuery += If( nCstTef > 0 ," AND  (ZZE_VLRENC=0 "," AND ZZE_VLRENC=0 ")
EndIf

If nCstTef > 0
	cQuery += If(nTarifa + nTaxa > 0," OR  ZZE_CSTTEF=0)"," AND  ZZE_CSTTEF=0")
EndIf

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("TTCNTA02.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

If TRB->QTD > 0	
	Alert("Atenção!!!"+chr(13)+chr(10)+"Todos as transações para esta bandeira que estiverem sem os devidos calculos serão recalculados com as taxas informadas neste momento","TTFINC12")
	cQuery := "UPDATE "+RetSQLName("ZZE")
	cQuery += " SET ZZE_VLRENC=(ZZE_VLRBRU*("+cvaltochar(nTaxa/100)+"))+("+cvaltochar(nTarifa)+"),ZZE_CSTTEF="+cvaltochar(nCstTef)
	cQuery += ",ZZE_VLRLIQ=ZZE_VLRBRU-((ZZE_VLRBRU*("+cvaltochar(nTaxa/100)+"))+("+cvaltochar(nTarifa)+")-"+cvaltochar(nCstTef)+")"
	cQuery += " FROM "+RetSQLName("ZZE")
	cQuery += " WHERE ZZE_PRODUT='"+cNome+"' AND ZZE_REDE='"+xCombo1+"' AND (ZZE_VLRENC=0 OR ZZE_CSTTEF=0) AND ZZE_ESTTRA<>'NEGADA'"
	TcSqlExec(cQuery)
	
	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf   
EndIf

Return