#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH' 
#INCLUDE 'TBICONN.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ TTFINC15 ³ Autor ³Alexandre Venancio     ³ Data ³27/08/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Locacao   ³                  ³Contato ³                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³  Rotina de preparacao de rota para sangria.                ³±±
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
±±³Jackson       ³ 22/01/14 ³                                             ³±±
±±³              ³  /  /   ³                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function TTFINC15

Local nOpc := GD_INSERT+GD_DELETE+GD_UPDATE
Local nOpca	:=	0  
Local oFont  := TFont():New("Arial",,12,.T.) //,.F.,5,.T.,5,.T.,.F.)
Private lGrava	:=	.T.
Private aCoBrw2 := {}
Private aHoBrw2 := {}
Private noBrw2  := 0   
Private cCampos	:=	"ZF_LACRE/ZF_CORLACR/ZF_ENVELOP/ZF_GLENVIE/ZF_CORLAGR"
Private aList2	:=	{}
Private oList2	
Private aList	:=	{}
Private oList	        
Private cRota	:=	space(6)
Private cResp	:=	space(50)
Private dData	:=	ctod('  /  /  ')
Private aNrSem1	:=	{}
Private aNrSem2	:=	{}
Private nSemMes	:=	''
Private	nDiaSem	:=	''
Private cRotCmp	:=	GetMv("MV_XRTCMP")
SetPrvt("oDlg1","oSay1","oSay2","oSay3","oGet1","oGet2","oGet3","oGrp1","oBrw1","oGrp2","oBrw2","oGrp3")
SetPrvt("oBtn1","oBtn2","oSay4","oSay5","oSay6","oBtn3","oBtn4")
Private nCnL	:=	0
Private nCnB	:=	0
Private nCnG	:=	0
Private nMoe	:=	0
Private nTro	:=	0
Private nCnA	:=	0
           
//Prepare Environment Empresa "01" Filial "01" //Tables "ZZE" 

Moedas()
Aadd(aList,{'','','','','',''})

oDlg1      := MSDialog():New( 091,232,950,1028,"Preparação de Rota para Sangria",,,.F.,,,,,,.T.,,,.T. )
	
	oSay1      := TSay():New( 004,004,{||"Rota"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oGet1      := TGet():New( 004,044,{|u| If(Pcount()>0,cRota:=u,cRota)},oDlg1,044,008,'@!',{||If(!Empty(dData) .And. xValDia(),Processa({|| PreAcols()},"Aguarde"),cResp := Posicione("ZZ1",1,xFilial("ZZ1")+cRota,"ZZ1_XNOMAT"))},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZZ1","",,)

	oSay2      := TSay():New( 004,096,{||"Responsável"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oGet2      := TGet():New( 004,132,{|u| If(Pcount()>0,cResp:=u,cResp)},oDlg1,130,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	oGet2:disable()  
	
	oSay3      := TSay():New( 004,280,{||"Data de Saída"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
	oGet3      := TGet():New( 004,320,{|u| If(Pcount()>0,dData:=u,dData)},oDlg1,060,008,'',{||If(xValDia() .And. !Empty(cRota),Processa({||PreAcols()},"Aguarde"),)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	
oGrp1      := TGroup():New( 020,004,176,200,"Rota do Dia",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

	oList := TCBrowse():New(028,008,190,130,, {'Patrimonio','Tipo Maquina','Sist Pag.','Cliente'},{40,50,30,100},;
                            oGrp1,,,,{|| FHelp(oList:nAt) },{|| /*EDITCOL*/},, ,,,  ,,.F.,,.T.,,.F.,,,)
	oList:SetArray(aList)
	oList:bLine := {||{ aList[oList:nAt,01],; 
 						 aList[oList:nAt,02],;
 						 aList[oList:nAt,06],;
 						 aList[oList:nAt,03]}} 
 						 
 	oSay6      := TSay():New( 158,060,{||"Sistema de Pagamento"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,132,008)
 	oSay6      := TSay():New( 165,005,{||"CE=Ced/MC=Mo c/Troco/MS=Mo S/Troco/VR=VR/SM=Smart/PO=POS/CI=Crt Ind/CA=Canet"},oDlg1,,oFont,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,232,008)	

oGrp2      := TGroup():New( 020,204,248,395,"Materiais enviados",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	MHoBrw2()
	MCoBrw2()
	oBrw2      := MsNewGetDados():New(028,206,210,393,nOpc,/*'AllwaysTrue()'*/'U_TTF015Lok()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',oGrp2,aHoBrw2,aCoBrw2 )

	oSay4      := TSay():New( 213,260,{||"Sugestão de Envio de Materiais"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,132,008)
	oSay5      := TSay():New( 223,220,{||"Lacres - "+cvaltochar(nCnL)+" 	Bananinhas - "+cvaltochar(nCnB)+"	Glenviews - "+cvaltochar(nCnG)+" Caneta - "+If(nCnA>0,cvaltochar(nCna),'0')},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,142,008)
	oSay5      := TSay():New( 233,220,{||"Maquinas com Troco - "+cvaltochar(nMoe)+" / Sugestão de Troco R$ "+transform(nTro,"@E 999,999,999.99")},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,132,008)

	oSAud      := TSay():New( 240,220,{||""},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,132,008)	
	oSAud:SetCss(" QLabel {font: bold 12px; color: #FF0000; } ")
	

oGrp3      := TGroup():New( 176,004,248,200,"Moedas para Troco",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

		oList2 := TCBrowse():New(184,008,190,060,, {'Valores','Saída'},{100,60},;
	                            oGrp3,,,,{|| },{|| editcol()},, ,,,  ,,.F.,,.T.,,.F.,,,)
		oList2:SetArray(aList2)
		oList2:bLine := {||{ aList2[oList2:nAt,01],; 
	 						 aList2[oList2:nAt,02]}}


//oBtn3      := TButton():New( 260,050,"Incluir Roteiro",oDlg1,{||INCROTA()},037,012,,,,.T.,,"",,,,.F. )
//oBtn3:disable()

//oBtn4      := TButton():New( 260,306,"Acerto SisPG",oDlg1,{||U_TTFINC28(aList[oList:nAt,01])},037,012,,,,.T.,,"",,,,.F. )
//oBtn4:disable()

oBtn1      := TButton():New( 260,140,"Confirmar",oDlg1,{||oDlg1:end(nOpca:=1)},037,012,,,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 260,216,"Sair",oDlg1,{||oDlg1:end(nOpca:=0)},037,012,,,,.T.,,"",,,,.F. )
oBtn1:disable()

oDlg1:Activate(,,,.T.) 

If nOpca == 1
	If len(aList) > 0
		If Empty(aList[1,1])
			MsgAlert("Não há informação de patrimonios para esta rota neste dia","TTFINC15") 
			lGrava := .F.
		EndIf 
		If Empty(oBrw2:aCols[1,2])
			MsgAlert("Não foi informado nenhum lacre para a rota","TTFINC15")
			lGrava := .F.
		EndIf  
		/*lTroco	:=	.F.
		For nX := 1 to len(aList2) -1
			If aList2[nX,02] > 0
				lTroco := .T.
			EndIf
		Next nX
		If !lTroco
			MsgAlert("Não foi informado troco para a rota","TTFINC15")
			lGrava := .F.
		EndIf 
		*/
		If lGrava
			gravar()
		endIf  
	EndIf
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTFINC15  ºAutor  ³Microsiga           º Data ³  08/20/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Verifica se no dia informado ja existe uma sangria prepa- º±±
±±º          ³rada para a rota em questao                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xValDia()

Local aArea	:=	GetArea()
Local cQuery	
Local lRet	:=	.T. 

//If dData > date()+7
If dData > date()+17
	MsgAlert("Não é permitido inclusão de romaneios superiores a 3 dias.","xValDia - TTFINC15")
	lRet := .F.
	Return(lRet)
EndIf

cQuery := "SELECT COUNT(*) AS TOT FROM "+RetSQLName("SZF")+" WHERE ZF_FILIAL='"+xFilial("SZF")+"' AND ZF_DATA='"+dtos(dData)+"' AND ZF_ROTA='"+cRota+"' AND D_E_L_E_T_=''"

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTATFC07.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")

IF TRB->TOT > 0
	MsgAlert("Lançamento já informado para esta Rota/Dia, verifique!!!","TTFINC15")
	lRet	:=	.F.
	aList := {}
	aadd(aList,{'','','','','',''})
	oList:SetArray(aList)
	oList:bLine := {||{ aList[oList:nAt,01],; 
	 						 aList[oList:nAt,02],;
	 						 aList[oList:nAt,06],;
	 						 aList[oList:nAt,03]}}
	
	oList:refresh()
	oDlg1:refresh()

EndIf              


Return(lRet) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTFINC15  ºAutor  ³Microsiga           º Data ³  02/25/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Habilita o botao de acerto do sistema de pagamento do patrim±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FHelp(nLinha)

Local aArea	:=	GetArea()
/*
If Empty(aList[nLinha,06])
	oBtn4:enable()               
Else
	oBtn4:disable()
EndIf
*/

// tratamento patrimonio auditoria
cQuery := "SELECT COUNT(*) TOTAL "
cQuery += " FROM "+RetSQLName("SZE")+" ZE"
cQuery += " WHERE ZE_FILIAL='"+CFILANT+"' AND ZE.D_E_L_E_T_='' AND ZE_ROTA='"+cRota+"' AND SUBSTRING(ZE_TIPOPLA,1,1) = '5' "
cQuery += " AND ZE_MENSAL LIKE '"+cvaltochar(YEAR(DDATA))+cvaltochar(STRZERO(MONTH(dData),2))+"%' AND ZE_CHAPA = '"+aList[nLinha][1]+"' "
cQuery += " AND ZE_CLIENTE = '"+aList[nLinha][4]+"' AND ZE_LOJA = '"+aList[nLinha][5]+"' "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf
  
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
dbSelectArea("TRB")
If !EOF()
	If TRB->TOTAL > 0
		oSAud:SetText("Auditoria")
		oSAud:Refresh()
	EndIf
EndIf
TRB->(dbCloseArea())



RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO33    ºAutor  ³Microsiga           º Data ³  08/19/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  aHeader dos lacres                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MHoBrw2()

DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("SZF")
While !Eof() .and. SX3->X3_ARQUIVO == "SZF"
   If X3Uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL .And. ALLTRIM(SX3->X3_CAMPO) $ cCampos
      noBrw2++
      Aadd(aHoBrw2,{Trim(X3Titulo()),;
           SX3->X3_CAMPO,;
           SX3->X3_PICTURE,;
           SX3->X3_TAMANHO,;
           SX3->X3_DECIMAL,;
           "",;
           "",;
           SX3->X3_TIPO,;
           "",;
           "" } )
   EndIf
   DbSkip()
End

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO33    ºAutor  ³Microsiga           º Data ³  08/19/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Cria o array de lacres                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MCoBrw2()

Local aAux := {}

Aadd(aCoBrw2,Array(noBrw2+1))
For nI := 1 To noBrw2
   aCoBrw2[1][nI] := CriaVar(aHoBrw2[nI][2])
Next
aCoBrw2[1][noBrw2+1] := .F.

Return                       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTFINC15  ºAutor  ³Microsiga           º Data ³  02/25/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TTF015Lok()

Local aArea	:=	GetArea()
Local lRet	:=	.T.
Local nX	:=	1  
Local nLac	:=	''
Local nGle	:=	''
Local nBan	:=	''

For nX := 1 to len(aCols)
	If !aCols[nX,01] $ nLac .And. !Empty(aCols[nX,01])
		nLac += aCols[nX,01] 
	Else
		If !Empty(aCols[nX,01])
			MsgAlert("O Lacre "+aCols[nX,01]+" já foi utilizado em outra linha","TTFINC15 - TTF015Lok")
			lRet := .F.
			exit
		EndIf
	EndIf
	If !aCols[nX,03] $ nBan .And. !Empty(aCols[nX,03])
		nBan += aCols[nX,03] 
	Else
		If !Empty(aCols[nX,03])
			MsgAlert("A Bananinha "+aCols[nX,03]+" já foi utilizada em outra linha","TTFINC15 - TTF015Lok") 
			lRet := .F.
			exit
		EndIf
	EndIf    
	If !aCols[nX,04] $ nGle .And. !Empty(aCols[nX,04])
		nGle += aCols[nX,04] 
	Else
		If !Empty(aCols[nX,04])
			MsgAlert("O Glenview "+aCols[nX,04]+" já foi utilizado em outra linha","TTFINC15 - TTF015Lok") 
			lRet := .F.
			exit  
		EndIf
	EndIf
	
Next nX 

RestArea(aArea)

Return(lRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTFINC15  ºAutor  ³Microsiga           º Data ³  08/19/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Preenche o array com as moedas                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Moedas()

Local aArea	:=	GetArea()

Aadd(aList2,{'R$ 0,05',0})
Aadd(aList2,{'R$ 0,10',0})
Aadd(aList2,{'R$ 0,25',0})
Aadd(aList2,{'R$ 0,50',0})
Aadd(aList2,{'R$ 1,00',0})
Aadd(aList2,{'Total',0})

RestArea(aArea)

Return   


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTFINC15  ºAutor  ³Microsiga           º Data ³  08/19/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Edicao dos valores de troco a serem enviados para a rota  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function editcol()

Local aArea	:=	GetArea()
Local aMult	:=	{0.05,0.10,0.25,0.50,1}

lEditCell(aList2, oList2, "@E 999,999",2)
       
aList2[len(aList2),02] := 0

For nX := 1 to len(aList2) - 1
	aList2[len(aList2),02] += (aList2[nX,02] * aMult[nX])
Next nX      

aList2[len(aList2),02] := Transform(aList2[len(aList2),02],"@E 999,999,999.99")

oList2:refresh()
oBtn1:enable()
oDlg1:refresh()

RestArea(aArea)

Return                              

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTFINC15  ºAutor  ³Microsiga           º Data ³  08/19/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Busca os patrimonios a serem incluidos na rota de sangria º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function PreaCols()

Local aArea	:=	GetArea()
Local cQuery               
Local aAx	:=	{} 
Local cSisP	:=	''
Local aSisP	:=	{GETMV("MV_XSIGSIS")}   //"CE","MC","MS","VR","SM","PO" 
Local aAux	:=	{}  
Local nPos	:= 0
Local cMensal := ""
Local cRange := ""
Local nPosDia:=0

nCnL	:=	0
nCnB	:=	0
nCnG	:=	0
nMoe	:=	0
nTro	:=	0  
nCnA	:=	0

cResp := Posicione("ZZ1",1,xFilial("ZZ1")+cRota,"ZZ1_XNOMAT")

If empty(dData) .or. empty(cRota)
	MsgAlert("Informe a Rota e data desejada","TTFINC15")
	aList := {}
	aadd(aList,{'','','','','',''})
	oList:SetArray(aList)
	oList:bLine := {||{ aList[oList:nAt,01],; 
	 						 aList[oList:nAt,02],;
	 						 aList[oList:nAt,06],;
	 						 aList[oList:nAt,03]}}
	
	oList:refresh()
	oDlg1:refresh()
	
	RestArea(aArea)
	Return         
EndIf

If dow(dData) == 1 .OR. dow(dData) == 7
	MsgAlert("Informe uma data valida para a roteirização!","TTFINC15") 
	aList := {}
	aadd(aList,{'','','','','',''})
	oList:SetArray(aList)
	oList:bLine := {||{ aList[oList:nAt,01],; 
	 						 aList[oList:nAt,02],;
	 						 aList[oList:nAt,06],;
	 						 aList[oList:nAt,03]}}
	
	oList:refresh()
	oDlg1:refresh()
	      
	RestArea(aArea)
	Return         
EndIf

aList :=	{}

cQuery := "SELECT ZE_CHAPA,B1_ESPECIF,A1_NREDUZ,ZE_CLIENTE,ZE_LOJA,ZE_FREQUEN,ZE_ROTA,N1_PRODUTO,ZE_MENSAL,N1_XSISPG,B1_ESPECIF,N1_XLIMTRO,ZE_TIPOPLA"
cQuery += " FROM "+RetSQLName("SZE")+" ZE"
cQuery += " LEFT JOIN "+RetSQLName("SN1")+" N1 ON N1_CHAPA=ZE_CHAPA AND N1.D_E_L_E_T_=''"
cQuery += " LEFT JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=N1_PRODUTO AND B1.D_E_L_E_T_=''"
cQuery += " LEFT JOIN "+RetSQLName("SA1")+" A1 ON A1_COD=ZE_CLIENTE AND A1_LOJA=ZE_LOJA AND A1.D_E_L_E_T_='' "
cQuery += " WHERE ZE_FILIAL='"+CFILANT+"' AND ZE.D_E_L_E_T_='' AND ZE_ROTA='"+cRota+"' AND SUBSTRING(ZE_TIPOPLA,1,1) IN ('1','2','4','5','6') "
cQuery += " AND ZE_MENSAL LIKE '"+cvaltochar(YEAR(DDATA))+cvaltochar(STRZERO(MONTH(DDATA),2))+"%'"

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTATFC07.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")
//LeadTime()
While !EOF()   
	//If Year(dData) == Val(substr(TRB->ZE_MENSAL,1,4)) .And. Strzero(month(dData),2) == Substr(TRB->ZE_MENSAL,5,2)
	  /*	cMensal := SubStr(TRB->ZE_MENSAL,9)
		For nX := FirstDay(dData) To LastDay(dData)
			nPos++
			If Dow(nX) == 1 .Or. Dow(nX) == 7
				Loop
			EndIf
		
			cRange += SubStr(cMensal,nPos,1)
		Next nX
		//cRange	:=	Substr(TRB->ZE_MENSAL,9,25)
		nP := 1	//	nP := nDiasem - 1
		aAx :=	{}
		For nX := 1 to 5
			Aadd(aAx,substr(cRange,nP,5))
			nP += 5
		Next nX
		For nI := FirstDay(dData) To Lastday(dData)
			If Dow(nI) == 1 .Or. Dow(nI) == 7
				Loop
			EndIf                                  
			nPosDia++
			If nI == dData
				Exit
			EndIf
		Next nI*/
	//	If substr(aAx[nSemMes],nDiaSem-1,1) == "1" .OR. substr(aAx[nSemMes],nDiaSem-1,1) == "F"
		cRange := Substr(TRB->ZE_MENSAL,9,day(lastday(ddata))) //novo - alterei pois o lead time nesta rotina nao tem muita utilida como no pca
		//If SubStr(cRange,nPosDia,1) $ "1|F" 
		If SubStr(cRange,day(dData),1) $ "1|F"
			cSisP	:=	''
			cBarra	:=	''
			If !Empty(TRB->N1_XSISPG)
				//Ced","Moed c/t","Moed s/t","VR","Smart","POS
				aAux := strtokarr(TRB->N1_XSISPG,"|")
				For nT := 1 to len(aAux)
					aR := strtokarr(aAux[nT],"=")
					If Alltrim(aR[2]) == "1"
						cSisP += cBarra + aR[1]  
						If aR[1] == "CE" .AND. substr(TRB->ZE_TIPOPLA,1,1) <> '6'
							nCnB++         
							nCnL++
						ElseIf aR[1] == "MS" .AND. substr(TRB->ZE_TIPOPLA,1,1) <> '6' 
							nCnL++
						ElseIf aR[1] == "MC" .AND. substr(TRB->ZE_TIPOPLA,1,1) <> '6'
							 If !Alltrim(TRB->B1_ESPECIF) $ "XM"
							 	nCnG++
							 Else
							 	nCnL++
							 EndIf
						ElseIf aR[1] == "CA" .OR. aR[1] == "SM"
							nCnA++
						EndIF                               
						
						cBarra := "/"
						If aR[1] == "MC"  .AND. substr(TRB->ZE_TIPOPLA,1,1) <> '6'
							nMoe++
						EndIf
					EndIf
				Next nT
				nTro	+=	TRB->N1_XLIMTRO  // SUGESTAO DE TROCO
			EndIf
			If Ascan(aList,{|x| Alltrim(x[1]) == Alltrim(TRB->ZE_CHAPA)}) == 0
		    	//Aadd(aList,{TRB->ZE_CHAPA,Alltrim(TRB->B1_ESPECIF),If(substr(aAx[nSemMes],nDiaSem-1,1) == "F","F/"+Alltrim(TRB->A1_NREDUZ),Alltrim(TRB->A1_NREDUZ)),TRB->ZE_CLIENTE,TRB->ZE_LOJA,cSisP})
		    	Aadd(aList,{TRB->ZE_CHAPA,Alltrim(TRB->B1_ESPECIF),;
		    				If(SubStr(cRange,day(dData),1) == "F","F/"+Alltrim(TRB->A1_NREDUZ),Alltrim(TRB->A1_NREDUZ)),;
		    				TRB->ZE_CLIENTE,TRB->ZE_LOJA,cSisP})
		 	EndIf
	    EndIf 
	//EndIf
	 
	 cMensal := ""
	 nPos := 0
	 nPosDia := 0
	 cRange := ""
	 nP := 0
	 aaX := {}
	 
	DbSkip()
EndDo

//Rota Tesouraria deve ser enviado 10 lacres a mais, para rota LA apenas um lacre e um glenview a mais.
If substr(cRota,2,1) <> "T"
	nCnG++
	nCnL++
Else
	nCnL += 10
EndIf

If len(aList) < 1
	Aadd(aList,{'','','','','',''})   
Else
	aSort(aList,,,{|x,y| x[4]<y[4]})
EndIf                           

//If cRotCmp == cRota .OR. cfilant != "01"
//	oBtn3:enable()
//EndIf
	
oList:SetArray(aList)
oList:bLine := {||{ aList[oList:nAt,01],; 
 						 aList[oList:nAt,02],;
 						 aList[oList:nAt,06],;
 						 aList[oList:nAt,03]}}

oList:refresh()
oDlg1:refresh()

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTFINC15  ºAutor  ³Microsiga           º Data ³  08/19/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verifica os dias uteis da semana para comparar com os dias º±±
±±º          ³contidos no plano de trabalho                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function LeadTime()

Local cPDMC		:=	firstday(dData)
Local cUDMC		:=	lastday(dData)
Local cPDMS		:=	firstday(lastday(dData)+1)
Local cUDMS		:=	lastday(lastday(dData)+1)   
Local cNMes		:=	month(cPDMC)
Local nCont		:=	DOW(cPDMC)
Local cRet		:=	''
 
aNrSem1	:=	{}
aNrSem2	:=	{}            
Aadd(aNrSem1,{'','','','','','',''})      
Aadd(aNrSem2,{'','','','','','',''})      

For nX := cPDMC to cUDMS
	If DOW(nX) <> 1 .And. DOW(nX) <> 7 .And. DOW(nX) <> 0 
		If month(nX) == cNMes
			aNrSem1[len(aNrSem1),DOW(nX)] := nX
			nCont++
			If (nCont > 6 .OR. !Empty(aNrSem1[len(aNrSem1),06])) .and. nX < cUDMC .And. len(aNrSem1) < 5
				Aadd(aNrSem1,{'','','','','','',''})      
				nCont := 2
			EndIf 
		Else
			aNrSem2[len(aNrSem2),DOW(nX)] := nX
			nCont++
			If DOW(nX+1) <> 0
				If nCont > 6 .and. nX < cUDMS .And. !Empty(aNrSem2[len(aNrSem2),DOW(nX+1)]) 
					Aadd(aNrSem2,{'','','','','','',''})       
					nCont := 2
				EndIf    
			EndIf
		EndIf
	EndIf
Next nX
  
For nX := 1 to len(aNrSem1)
	If Ascan(aNrSem1[nX],dData) > 0
		nSemMes := nX            
		nDiaSem	:= Ascan(aNrSem1[nX],dData)
		exit
	EndIf
Next nX               

Return                                         

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTFINC15  ºAutor  ³Microsiga           º Data ³  08/19/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   Grava as informacoes em suas respectivas tabelas e faz   º±±
±±º          ³a transferencia do valor para o caixa da rota.              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function gravar()
                       
Local nItem	:=	1
Local lGrvZN := SuperGetMV("MV_XFIN001",.T.,.F.)

DbSelectArea("SZF")
Reclock("SZF",.T.)
SZF->ZF_FILIAL	:=	xFilial("SZF")
SZF->ZF_DATA	:=	dData
SZF->ZF_ROTA	:=	cRota
SZF->ZF_RESP	:=	cResp 
SZF->ZF_ITEM	:=	Strzero(nItem,3)

SZF->ZF_MOEDA01	:=	aList2[01,02]
SZF->ZF_MOEDA02	:=	aList2[02,02]
SZF->ZF_MOEDA03	:=	aList2[03,02]
SZF->ZF_MOEDA04	:= 	aList2[04,02]
SZF->ZF_MOEDA05	:= 	aList2[05,02]

SZF->(Msunlock())

nItem++

For nX := 1 to len(aList)
	Reclock("SZF",.T.)
	SZF->ZF_FILIAL	:=	xFilial("SZF")
	SZF->ZF_DATA	:=	dData
	SZF->ZF_ROTA	:=	cRota
	SZF->ZF_RESP	:=	cResp 
	SZF->ZF_ITEM	:=	Strzero(nItem,3)
	SZF->ZF_PATRIMO	:=	aList[nX,01]
	SZF->ZF_CLIENTE	:=	aList[nX,04]
	SZF->ZF_LOJA	:=	aList[nX,05]
	SZF->(Msunlock())
	nItem++
Next nX

For nX := 1 to len(oBrw2:aCols)
	Reclock("SZF",.T.)
	SZF->ZF_FILIAL	:=	xFilial("SZF")
	SZF->ZF_DATA	:=	dData
	SZF->ZF_ROTA	:=	cRota
	SZF->ZF_RESP	:=	cResp 
	SZF->ZF_ITEM	:=	Strzero(nItem,3)
	SZF->ZF_LACRE	:= 	oBrw2:aCols[nX,Ascan(oBrw2:aHeader,{|x| Alltrim(x[2]) == "ZF_LACRE"})]
	SZF->ZF_CORLACR	:=	oBrw2:aCols[nX,Ascan(oBrw2:aHeader,{|x| Alltrim(x[2]) == "ZF_CORLACR"})]
	SZF->ZF_ENVELOP	:=	oBrw2:aCols[nX,Ascan(oBrw2:aHeader,{|x| Alltrim(x[2]) == "ZF_ENVELOP"})]
	SZF->ZF_GLENVIE	:=	oBrw2:aCols[nX,Ascan(oBrw2:aHeader,{|x| Alltrim(x[2]) == "ZF_GLENVIE"})] 
	SZF->ZF_CORLAGR	:=	oBrw2:aCols[nX,Ascan(oBrw2:aHeader,{|x| Alltrim(x[2]) == "ZF_CORLAGR"})]	
	SZF->(Msunlock())                                             
	nItem++
Next nX     
//Controle de Lacres
For nX := 1 to len(oBrw2:aCols)
	If !Empty(oBrw2:aCols[nX,Ascan(oBrw2:aHeader,{|x| Alltrim(x[2]) == "ZF_LACRE"})])
		Reclock("ZZO",.T.)
		ZZO->ZZO_FILIAL	:=	xFilial("ZZO")
		ZZO->ZZO_LACRE	:=	oBrw2:aCols[nX,Ascan(oBrw2:aHeader,{|x| Alltrim(x[2]) == "ZF_LACRE"})]
		ZZO->ZZO_CORLAC	:=	oBrw2:aCols[nX,Ascan(oBrw2:aHeader,{|x| Alltrim(x[2]) == "ZF_CORLACR"})]
		ZZO->ZZO_DATSAI	:=	dData
		ZZO->ZZO_ROTA	:=	cRota
		ZZO->ZZO_RESPON	:=	Posicione("ZZ1",1,xFilial("ZZ1")+cRota,"ZZ1_XATEND")                                                     
		ZZO->ZZO_TIPO	:=	'1'
		ZZO->(Msunlock())
	EndIf
Next nX
//Controle de Bananinhas
For nX := 1 to len(oBrw2:aCols)
	If !Empty(oBrw2:aCols[nX,Ascan(oBrw2:aHeader,{|x| Alltrim(x[2]) == "ZF_ENVELOP"})])
		Reclock("ZZO",.T.)
		ZZO->ZZO_FILIAL	:=	xFilial("ZZO")
		ZZO->ZZO_LACRE	:=	oBrw2:aCols[nX,Ascan(oBrw2:aHeader,{|x| Alltrim(x[2]) == "ZF_ENVELOP"})]
		ZZO->ZZO_DATSAI	:=	dData
		ZZO->ZZO_ROTA	:=	cRota
		ZZO->ZZO_RESPON	:=	Posicione("ZZ1",1,xFilial("ZZ1")+cRota,"ZZ1_XATEND")                                                     
		ZZO->ZZO_TIPO	:=	'2'
		ZZO->(Msunlock())  
	EndIf
Next nX
//Controle de Glenviews
For nX := 1 to len(oBrw2:aCols)
	If !Empty(oBrw2:aCols[nX,Ascan(oBrw2:aHeader,{|x| Alltrim(x[2]) == "ZF_GLENVIE"})])
		Reclock("ZZO",.T.)
		ZZO->ZZO_FILIAL	:=	xFilial("ZZO")
		ZZO->ZZO_LACRE	:=	oBrw2:aCols[nX,Ascan(oBrw2:aHeader,{|x| Alltrim(x[2]) == "ZF_GLENVIE"})]
		ZZO->ZZO_CORLAC	:=	oBrw2:aCols[nX,Ascan(oBrw2:aHeader,{|x| Alltrim(x[2]) == "ZF_CORLAGR"})]
		ZZO->ZZO_DATSAI	:=	dData
		ZZO->ZZO_ROTA	:=	cRota
		ZZO->ZZO_RESPON	:=	Posicione("ZZ1",1,xFilial("ZZ1")+cRota,"ZZ1_XATEND")                                                     
		ZZO->ZZO_TIPO	:=	'3'
		ZZO->(Msunlock()) 
	EndIf
Next nX
If lGrvZN
	U_TTFINC21(cRota,dData)
EndIf
//Transfere os valores entregues para a rota para o caixa da Rota.
TST100(val(strtran(aList2[06,02],",",".")),dData) 

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTFINC15  ºAutor  ³Microsiga           º Data ³  10/04/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   Transferencia de valores do caixa geral para o caixa da  º±±
±±º          ³rota                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function TST100(nVlr,dData)  
                    
Local aArea		:=	GetArea()
Local nOpc     := 0
Local aFINA100 := {}
Local dDat		:=	dDatabase
Private lMsErroAuto := .F.

If nVlr == 0
	RestArea(aArea)
	Return
EndIf
                             
dDatabase := dData

aFINA100 := {   {"E5_DATA"			,dDataBase                    				,Nil},;
				{"E5_MOEDA" 		,"R$"                         				,Nil},;
                {"E5_VALOR"			,nVlr						  				,Nil},;
                {"E5_NATUREZ"    	,"10101009"                   				,Nil},;
                {"E5_BANCO"        	,"CXG"                        				,Nil},;
                {"E5_AGENCIA"    	,"000001"                        			,Nil},;
                {"E5_CONTA"        	,If(cfilant="01","000000         ","0000"+strzero(VAL(cfilant),2)+space(9))                         	,Nil},;
                {"E5_NUMCHEQ"     	,dtos(dData)+cRota                        	,Nil},;
                {"E5_BENEF"        	,"Transf R$ p Abast troco "+cRota ,Nil},;
                {"E5_HISTOR"    	,"Transf R$ p Abast troco "+cRota ,Nil}}
    
MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINA100,3)
  
If lMsErroAuto
	MostraErro()
EndIf    

 aFINA100 := {  {"E5_DATA"        	,dDataBase                    			,Nil},;
 				{"E5_MOEDA"			,"R$"                            		,Nil},;
     			{"E5_VALOR"         ,nVlr						            ,Nil},;
        		{"E5_NATUREZ"    	,"10101009"                   			,Nil},;
          		{"E5_BANCO"        	,"CXT"                        			,Nil},;
            	{"E5_AGENCIA"    	,"000000"                     			,Nil},;
             	{"E5_CONTA"        	,cRota                        			,Nil},;
            	{"E5_NUMCHEQ"     	,dtos(dData)+cRota                     	,Nil},;
              	{"E5_HISTOR"    	,"Transf R$ da Tesour para Abastec.",Nil}}
    
MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINA100,4)
    
If lMsErroAuto
	MostraErro()
EndIf

dDatabase    := dDat 

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TTFINC15  ºAutor  ³Microsiga           º Data ³  11/22/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function IncRota()

Local aArea		:=	GetArea()
Local cQuery
Local aRet		:=	{}
Local aPergs	:=	{}
Local xCli		:=	space(6)
Local xLoj		:=	space(4)

aAdd(aPergs ,{1,"Cliente",xCli,"@!" ,"","SA1","",6,.T.})
aAdd(aPergs ,{1,"Loja",xLoj,"@!" ,"","","",4,.T.})

If ParamBox(aPergs,"Informe o Cliente",@aRet)
	If !Empty(aRet[1]) .And. !Empty(aRet[2])
	    
		If Empty(aList[1,1])
			aList := {}
		EndIf
		
		cQuery := "SELECT N1_CHAPA,N1_DESCRIC,A1_NREDUZ,N1_XLIMTRO,N1_XSISPG"
		cQuery += " FROM "+RetSQLName("SN1")+" N1"
		cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_COD=N1_XCLIENT AND A1_LOJA=N1_XLOJA AND A1.D_E_L_E_T_=''"
		cQuery += " WHERE N1_XCLIENT='"+aRet[1]+"' AND N1_XLOJA='"+aRet[2]+"'"
		cQuery += " AND N1_PRODUTO IN(SELECT B1_COD FROM "+RetSQLName("SB1")+" WHERE B1_XSECAO='026' AND D_E_L_E_T_='')"
		cQuery += " AND N1.D_E_L_E_T_=''"

		If Select("TRB") > 0
			dbSelectArea("TRB")
			dbCloseArea()
		EndIf
		  
		MemoWrite("TTATFC07.SQL",cQuery)
		
		cQuery:= ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   
		
		DbSelectArea("TRB")
		
		While !EOF()   
	
		   	Aadd(aList,{TRB->N1_CHAPA,Alltrim(TRB->N1_DESCRIC),Alltrim(TRB->A1_NREDUZ),aRet[1],aRet[2],TRB->N1_XSISPG})
			Dbskip()
		Enddo
	
		If len(aList) < 1
			Aadd(aList,{'','','','','',''})   
		Else
			aSort(aList,,,{|x,y| x[4]<y[4]})
		EndIf
			
		oList:SetArray(aList)
		oList:bLine := {||{ aList[oList:nAt,01],; 
		 						 aList[oList:nAt,02],;
		 						 aList[oList:nAt,06],;
		 						 aList[oList:nAt,03]}}
		
		oList:refresh()
		oDlg1:refresh()
		

	EndIf
EndIf

RestArea(aArea)

Return