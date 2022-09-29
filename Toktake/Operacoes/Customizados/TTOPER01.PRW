#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TBICONN.CH'
#include "TOTVS.CH"
#include "topconn.ch"

Static nPosaListb := 0

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ TTOPER01 ณ Autor ณ Alexandre Venancio    ณ Data ณ 25/09/13 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณLocacao   ณ                  ณContato ณ                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ  Programacao de Rotas.                                     ณฑฑ
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
ฑฑณ Alexandre    ณ22/05/14ณ01.02   Acerto do Filtro                       ณฑฑ
ฑฑณ Jackson      ณ07/07/14 01.03 ณ Alteracao da ordenacao dos patrimonios ณฑฑ
ฑฑณ 							   para a tela de sequencias			  ณฑฑ
ฑฑณ Jackson      ณ20/10/14 01.04 ณ Ajuste no sequenciamento para aceitar  ณฑฑ
ฑฑณ 								 mais de um atendimento/dia por		  ณฑฑ
ฑฑณ 								 patrimonio							  ณฑฑ
ฑฑณ Jackson      ณ22/10/14 01.04 ณ Incluida opcao de simulacao da geracao ณฑฑ
ฑฑณ									das OS Mobile						  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function TTOPER01()
                 
Local nsair		:=	0
Local cNumPatr	:= Space(6)
Private oDlg1,oGrp1,oBrw1,oGrp2,oBmp1,oSay1,oGrp3,oBrw2,oGrp4,oBtn1,oBtn2,oBtn3,oBtn4,oBtn5,oBtn6,oBtn7,oMsCalend
Private oSay2,oSay3,oSay4,oSay5,oSay6,oSay7,oSay8,oSay9,oSay10,oSay11,oSay12
Private oList1,oList2       
Private aList1	:=	{}
Private aList2	:=	{} 
Private aListb	:=	{}
Private aPatrAlt:=  {}
Private oOk   	:= LoadBitmap(GetResources(),'br_verde')       
Private oNo   	:= LoadBitmap(GetResources(),'br_vermelho')
Private aBkpL1	:=	{}  
Private aDiasM	:=	{}
Private aDiasM2	:=	{}
Private lSangria := .F.
private lAlterou := .F.
Private lSegAtend := .F.
Private aUserFl   := PswRet(1) 
Private lSacUs	 := .F.
Private cGrupSc	 :=	GetMV("MV_XSACNPR")

For nX := 1 to len(aUserFl)
	For nJ := 1 to len(aUserFl[nX,10])
		IF Alltrim(aUserFl[nX,10,nJ]) $ Alltrim(cGrupSc)
			lSacUs := .T.
		EndIf
	Next nJ
Next nX


//Prepare Environment Empresa "01" Filial "01" Tables "SD3" 

Processa({ || PreAcols()},"Aguarde","Carregando patrim๔nios..")


Define MsDialog oDlg1 From 091,232 To 656,1164 Title "Estrutura Operacional" Pixel Style 128

	oDlg1:lEscClose := .F.
	
	oGrp1      := TGroup():New( 004,004,202,252,"Patrim๔nios",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	//oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{015,010,203,246},,, oGrp1 ) 
	oList1 := TCBrowse():New(015,010,235,175,, {'Patrim๔nio','Modelo' /*,'Sequ๊ncia','Frequencia'*/},{50,80/*,40,40*/},;
                            oGrp1,,,,{|| FHelp(oList1:nAt)},{|| /*EDITCOL*/ },, ,,,  ,,.F.,,.T.,,.F.,,,)                          
	oList1:SetArray(aList1)
	oList1:bLine := {||{aList1[oList1:nAt,01],; 
 						 aList1[oList1:nAt,02],;
 						 aList1[oList1:nAt,21],;	// sequencia
 						 aList1[oList1:nAt,14]}}

	oSay1      := TSay():New( 193,010,{ ||"Qtd Patrim๔nios " },oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,152,008)
	
	// Pesquisa de patrimonio - POSICIONA
	@ 191,180 MSGET cNumPatr	PICTURE "@!"	OF oGrp1 SIZE 020,008 PIXEL
	oSBtn3 := TButton():New( 190,210,"Pesquisar",oGrp1,{ || IF(!empty(cNumPatr),fPosiciona(cNumPatr),)  },30,12,,,,.T.,,"",,,,.F.)
	

	oGrp2      := TGroup():New( 004,260,087,456,"Programa็ใo do M๊s",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	//oBmp1      := TBitmap():New( 016,268,180,080,,"",.F.,oGrp2,,,.F.,.T.,,"",.T.,,.T.,,.F. )
	oMsCalend := MsCalend():New(016,268,oGrp2,.T.) 
		
	oGrp3      := TGroup():New( 092,260,212,456,"Tarefas X Operador",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	//oBrw2      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{125,264,204,452},,, oGrp3 ) 
	oList2 := TCBrowse():New(101,264,190,095,, {'Servi็o','Rota','Residente','Sangria','Moto','Entregador','Supervisor'},{40,20,20,20,20,20,20},;
	                            oGrp3,,,,{|| Fhelp2(oList2:nAt)},{|| IF(!lSacUs,editcol2(oList2:nAt),"")},, ,,,  ,,.F.,,.T.,,.F.,,,)
	
	oSay12      := TSay():New( 198,270,{||""},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,152,008)

	oGrp4      := TGroup():New( 205,004,268,252,"Informa็๕es sobre Cliente e Local de Instala็ใo",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

	    oSay2      := TSay():New( 217,012,{||"Cliente"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
		oSay3      := TSay():New( 217,072,{||""},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,172,008)
		oSay4      := TSay():New( 237,012,{||"Local Fisico Instala็ใo"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,056,008)
		oSay5      := TSay():New( 237,072,{||""},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,172,008)
		oSay6      := TSay():New( 227,012,{||"Endere็o"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oSay7      := TSay():New( 227,072,{||""},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,172,008)
		oSay8      := TSay():New( 247,012,{||"Tipo Servi็o"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oSay9      := TSay():New( 247,072,{||""},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,172,008)
		oSay10     := TSay():New( 257,012,{||"Forma de Pagto."},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
		oSay11     := TSay():New( 257,072,{||""},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,172,008)
		
	oBtn1      := TButton():New( 220,260,"Filtro",oDlg1,{ ||Processa({ || filtro(1)},"Aguarde") },037,012,,,,.T.,,"",,,,.F. )
	oBtn2      := TButton():New( 252,260,"Limpar Filtro",oDlg1,{ || Processa({||filtro(0)},"Aguarde") },037,012,,,,.T.,,"",,,,.F. )	
	oBtnInv    := TButton():New( 252,299,"Inv PA",oDlg1,{ || U_TTOPER18() },037,012,,,,.T.,,"",,,,.F. )	
	oBtnH      := TButton():New( 220,341,"Horarios",oDlg1,{ || Kalend() },037,012,,,,.T.,,"",,,,.F. )	
	oBtn5      := TButton():New( 220,380,"Replicar",oDlg1,{ || MsAguarde({ || ReplSZE() },"Aguarde,replicando plano...") },037,012,,,,.T.,,"",,,,.F. )	
	oBtn3      := TButton():New( 220,419,"Gravar",oDlg1,{ || IF(lAlterou,Processa({ || Gravar()},"Aguarde","Salvando altera็๕es.."), )  },037,012,,,,.T.,,"",,,,.F. )
	oBtSim     := TButton():New( 252,341,"Simular",oDlg1,{ || Simular() },037,012,,,,.T.,,"",,,,.F. )	
	oBtn7      := TButton():New( 252,380,"Gerar Excel",oDlg1,{ || Processa({ || U_TTOPER04()},"Aguarde") },037,012,,,,.T.,,"",,,,.F. )	
	oBtn4      := TButton():New( 252,419,"Sair",oDlg1,{ || If(lAlterou,If(MsgYesNo("Deseja gravar antes de sair?"), Processa({ ||Gravar()},"Aguarde","Salvando altera็๕es.."),oDlg1:End() ),oDlg1:End() ),oDlg1:End() },037,012,,,,.T.,,"",,,,.F. )
		
		If lSacUs
			oBtn1:disable()
			oBtn2:disable()
			oBtnInv:disable()
			oBtnH:disable()
			oBtn5:disable()
			oBtn3:disable()
			oBtSim:disable()
			oBtn7:disable()
		EndIf
ACTIVATE DIALOG oDlg1 CENTERED
//Reset Environment
                                                                     
Return                 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTOPER01  บAutor  ณMicrosiga           บ Data ณ  09/25/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Procura Patrimonios                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Preacols()

Local aArea		:=	GetArea()
Local cQuery 
Local aPera		:=	{} 
Local nTT		:=	1
Local cAux		:=	''
Local nCont		:= 0
Local aAux		:= {}
Local cRota2	:= ""
Local cRota3	:= ""
Local cSeq2		:= ""
Local cSeq3		:= ""
Local lFrmLeit	:= .F.
Local lFrmSang	:= .F.    


DbSelectArea("SX5")
DbSetOrder(1)
If DbSeek(xFilial("SX5")+AvKey("ZW","X5_TABELA"))
  	While !EOF() .AND. SX5->X5_TABELA == "ZW"
		Aadd(aList2,{Alltrim(SX5->X5_DESCRI),space(6),space(6),space(6),space(6),space(6),space(6),''})
		Dbskip()
	EndDo
EndIf

cQuery := "SELECT N1_CHAPA,B1_DESC,N1_XCLIENT,N1_XLOJA,N1_XLOCINS,A1_NREDUZ,A1_END,A1_COMPLEM,A1_BAIRRO,A1_MUN,N1_XTPSERV,A1_EST,NL_DESCRIC, N1_XSTATTT, "
cQuery += "ZE_MENSAL,ZE_ROTA,ZE_FREQUEN,ZE_FECHAME,ZZ1_DESCRI,N1_XPLANTR,N1_XSISPG,ZE_TIPOPLA,ZE.R_E_C_N_O_ AS RECZE, ZE_SEQ, ZE_ROTAAUX, ZE_SEQAUX,N1_XPA,ZE_FRMLEIT, ZE_FRMSANG "
cQuery += " FROM "+RetSQLName("SN1")+" N1"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=N1_PRODUTO AND B1.D_E_L_E_T_='' AND B1_XSECAO='026' "
cQuery += " LEFT JOIN "+RetSQLName("SA1")+" A1 ON A1_COD=N1_XCLIENT AND A1_LOJA=N1_XLOJA AND A1.D_E_L_E_T_='' " 
cQuery += " LEFT JOIN "+RetSQLName("SZE")+" ZE ON ZE_CHAPA=N1_CHAPA AND ZE.D_E_L_E_T_='' AND SUBSTRING(ZE_MENSAL,1,6)='"+substr(dtos(dDataBase),1,6)+"' "
cQuery += " LEFT JOIN "+RetSQLName("ZZ1")+" Z1 ON ZZ1_COD=ZE_ROTA AND ZZ1_MSBLQL<>'1' AND Z1.D_E_L_E_T_=''"
cQuery += " LEFT JOIN "+RetSQLName("SNL")+" NL ON NL_FILIAL='"+xFilial("SNL")+"' AND NL_CODIGO=N1_LOCAL AND NL.D_E_L_E_T_=''"
cQuery += " WHERE N1_XSTATTT IN ('2','3','5','6') AND N1.D_E_L_E_T_='' AND N1_BAIXA = '' "
 
If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTATFC07.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")

While !EOF()
	nCont++
	dbskip()
EndDo

Procregua(nCont)
dbgoTop()
While !EOF()
	Incproc()
    If Ascan(aList1,{|x| Alltrim(x[1]) == Alltrim(TRB->N1_CHAPA)}) == 0
	    Aadd(aList1,{TRB->N1_CHAPA,TRB->B1_DESC,If(TRB->N1_XSTATTT=="2","PATRIMONIO EM TRANSITO",TRB->N1_XCLIENT),TRB->N1_XLOJA,TRB->N1_XLOCINS,TRB->A1_NREDUZ,;
	    			 If(!Empty(TRB->NL_DESCRIC),TRB->NL_DESCRIC,TRB->A1_END),If(!Empty(TRB->NL_DESCRIC),'',TRB->A1_COMPLEM),;
	    			 If(!Empty(TRB->NL_DESCRIC),'',TRB->A1_BAIRRO),If(!Empty(TRB->NL_DESCRIC),'',TRB->A1_MUN),;
	    			 TRB->N1_XTPSERV,TRB->ZE_MENSAL,;
	    			 TRB->ZE_ROTA,TRB->ZE_FREQUEN,TRB->ZE_FECHAME,TRB->ZZ1_DESCRI,.T.,.F.,TRB->N1_XPLANTR,TRB->N1_XSISPG,TRB->ZE_SEQ,TRB->ZE_TIPOPLA,"",;
	    			 TRB->A1_EST,TRB->N1_XPA+" - "+Posicione("ZZ1",1,xFilial("ZZ1")+TRB->N1_XPA,"ZZ1_DESCRI")})
	Else
		cAux := aList1[Ascan(aList1,{|x| Alltrim(x[1]) == Alltrim(TRB->N1_CHAPA)}),12]
		For nTz := 9 to len(Alltrim(cAux))
			If substr(TRB->ZE_MENSAL,nTz,1) != "0" .And. substr(cAux,nTz,1) == "0"	
				cAux := substr(cAux,1,nTz-1)+substr(TRB->ZE_MENSAL,nTz,1)+substr(cAux,nTz+1)
			EndIf
		Next nTz
		aList1[Ascan(aList1,{|x| Alltrim(x[1]) == Alltrim(TRB->N1_CHAPA)}),12] := cAux
	EndIf
    
    Aadd(alistb,{TRB->N1_CHAPA,TRB->ZE_TIPOPLA})
    
    For nPP := 1 to len(aList2)
    	Aadd(aListb[len(alistb)],{aList2[nPP,01],aList2[nPP,02],aList2[nPP,03],aList2[nPP,04],aList2[nPP,05],aList2[nPP,06],aList2[nPP,07],aList2[nPP,08],TRB->ZE_MENSAL,TRB->ZE_SEQ,TRB->ZE_FECHAME,TRB->ZE_FREQUEN })
    Next nPP  
    
    Aadd( aListb[len(alistb)],TRB->RECZE )
    Aadd( aListb[len(alistb)], {} )
    Aadd( aListb[len(alistb)], .F. )	// controle de alteracoes
    
    // tratamento rotas auxiliares - mais de um atendimento no mesmo patrimonio e no mesmo dia
    If !Empty(TRB->ZE_ROTAAUX)
    	aAux := StrToKarr(TRB->ZE_ROTAAUX,"/")
    	cRota2 := aAux[1]
    	If Len(aAux) > 1
    		cRota3 := aAux[2]
    	EndIf
    EndIf
    
    // tratamento sequencias auxiliares - mais de um atendimento no mesmo patrimonio e no mesmo dia
    If !Empty(TRB->ZE_SEQAUX)
    	aAux := StrToKarr(TRB->ZE_SEQAUX,"/")
    	cSeq2 := aAux[1]
    	If Len(aAux) > 1
    		cSeq3 := aAux[2]
    	EndIf
    EndIf		
     
    Aadd( aListb[len(alistb)], cRota2 )		// [14] Rota 2	- adicionado 25/03/14
    Aadd( aListb[len(alistb)], cRota3 )		// [15] Rota 3	- adicionado 25/03/14
    Aadd( aListb[len(alistb)], cSeq2 )		// [16] Seq 2	- adicionado 16/10/14
    Aadd( aListb[len(alistb)], cSeq3 )		// [17] Seq 3	- adicionado 16/10/14
    
    Aadd( aListb[len(alistb)], IIF(TRB->ZE_FRMLEIT=="T",.T.,.F.) )		// [18] form leitura	- adicionado 13/09/2017
    Aadd( aListb[len(alistb)], IIF(TRB->ZE_FRMSANG=="T",.T.,.F.) )		// [19] form sangria	- adicionado 13/09/2017
                                                   
    
    If !Empty(TRB->ZE_TIPOPLA)
   		alistb[len(alistb),val(SUBSTR(TRB->ZE_TIPOPLA,1,1))+2,val(SUBSTR(TRB->ZE_TIPOPLA,2,1))+1] := TRB->ZE_ROTA
   	EndIf
		                               
   	Dbskip()
EndDo

If Len(aList1) == 0
	Aadd(aList1,{ "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","", ""})
EndIf
	          
   	
//Asort(aList1,,,{|x,y| x[1] < y[1]})
Asort(aList1,,,{ |x,y| x[3]+x[4]+x[1] < y[3]+y[4]+y[1] /*.And. x[21] < y[21]*/ } )
Asort(alistb,,,{ |x,y| x[1] < y[1] } )
aBkpL1 := aClone(aList1)


RestArea(aArea)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfPosiciona  บAutor ณJackson E. de Deus บ Data ณ  02/17/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPosiciona no patrimonio digitado                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fPosiciona(cNumPatr)

Local nPos := 0


nPos := Ascan(aList1, {|x| AllTrim(x[1]) == AllTrim(cNumPatr) } )
If nPos > 0
	oList1:GoPosition(nPos)
EndIf

oList1:Refresh()      

Return         

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTOPER01  บAutor  ณMicrosiga           บ Data ณ  09/25/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Atualiza informacoes sobre o cliente.                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FHelp(nLinha)
 
Local aArea	 := GetArea()        
Local nPosd	 := 0
Local cAux	 := ''
Local aAux	 := {}
Local aSepS	 := {}
Local aSisP	 := { "CE=Cedula","MC=Moedeiro c/Troco","MS=Moedeiro Sem Troco","VR=VR","SM=Smart","PO=POS","CI=Cartใo Indutivo","CA=Caneta" }
Local cSisP	 := ''  
Local cBarra := ''
Local cTpPla := ""
Local aContr := {"Loca็ใo",;		//[1]
				"Servi็o de Caf้",;	//[2]
				"LA",;				//[3]
				"SA",;				//[4]
				"Kit Lanche",;		//[5]
				"Caf้ + Loca็ใo",;	//[6]
				"LA + Loca็ใo",;	//[7]
				"SA + Loca็ใo"}		//[8]           
				                   

If !Empty(aList1[nLinha,20])
	aSepS	:=	strtokarr(aList1[nLinha,20],"|")
	For nX := 1 to len(aSepS)
		If substr(aSepS[nX],4,1) == "1"
			cSisP	+=	cBarra	+substr(aSisP[nX],4)
			cBarra	:=	" / "
		EndIf
	Next nX
EndIf
                 
oSay1:settext("")
oSay3:settext("")
oSay5:settext("")
oSay7:settext("")
oSay9:settext("")
oSay11:settext("")
oSay12:setText("")
oSay1:settext("Qtd. Patrim๔nios "+cvaltochar(len(aList1)))
oSay3:settext(aList1[nLinha,03]+"-"+aList1[nLinha,04]+" - "+aList1[nLinha,06])
oSay5:settext(aList1[nLinha,05])
oSay7:settext(Alltrim(aList1[nLinha,07])+" - "+Alltrim(aList1[nLinha,09])+" - "+Alltrim(aList1[nLinha,10]))
oSay9:settext( 	If(!empty(aList1[nLinha,11]), aContr[val(aList1[nLinha,11])] + space(10) +"PA - "+ aList1[nLinha,25], '')) //+"/ Rota "+aList1[nLinha,13]+" - "+Alltrim(aList1[nLinha,16])) // alterado Jackson
oSay11:settext(cSisP)

If oList2:nAt == 1
	lSangria := .T.
Else
	lSAngria := .F.
EndIf	

If !Empty(aList1[nLinha,12])
	oMsCalend := Nil
	oMsCalend := MsCalend():New(016,268,oGrp2,.T.)
	oMsCalend:dDiaAtu := dDatabase
	oMsCalend:CtrlRefresh()
	    
	cAux := AllTrim( aList1[nLinha,12] )
	nPosd := 9
	For nX := firstday(ddatabase) to lastday(ddatabase)
		If substr(cAux,nPosd,1) $ "1|F"
	   		oMsCalend:AddRestri( day(nX), CLR_GREEN, CLR_HRED)
		EndIf
		nPosd++	
	Next nX	
Else 
	oMsCalend := Nil
	oMsCalend := MsCalend():New(016,268,oGrp2,.T.)
	oMsCalend:dDiaAtu := dDatabase
		
	//Acoes do Calendario
	oMsCalend:bChange := { || markday(oMsCalend:dDiaAtu) }
	
	oMsCalend:CtrlRefresh()
EndIf


//Preenche o Segundo Array com os planos de trabalhos jแ definidos para o patrimonio marcado no array 1
For nP := 1 to len(aList2) 
	For nT := 2 to 7
		aList2[nP,nT] := space(6)
	Next nT
Next nP
		
For nX := 1 to len(alistb) 
	If Alltrim(alistb[nX,01]) == Alltrim(aList1[nLinha,01])
	 	If !Empty(alistb[nX,2])
  	   		aList2[ val( substr(alistb[nX,2],1,1)) ][ val(substr(alistb[nX,2],2,1)) ] := alistb[nX,val(substr(alistb[nX,2],1,1))+2,val(substr(alistb[nX,2],2,1))+1]
		EndIf
	EndIf
Next nX

 
oList2:SetArray(aList2)
oList2:bLine := {||{aList2[oList2:nAt,01],; 
					aList2[oList2:nAt,02],;
 					aList2[oList2:nAt,03],;
 					aList2[oList2:nAt,04],; 
 					aList2[oList2:nAt,05],;
 					aList2[oList2:nAt,06],;
 					aList2[oList2:nAt,07]}}

oList2:refresh() 
oDlg1:refresh()

RestArea(aArea)

Return                                   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTOPER01  บAutor  ณMicrosiga           บ Data ณ  01/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Rota responsavel pela tarefa selecionada no plano de tra- บฑฑ
ฑฑบ          ณbalho do patrimonio.                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FHelp2(nlinha)

Local aArea	:=	GetArea()
Local cAux	:=	''
Local cBarra:=	''

oSay12:setText("")

For nX := 2 to 7
	If !Empty(aList2[nLinha,nX])
		cAux += cBarra + aList2[nLinha,nX] +" "+ Posicione("ZZ1",1,xFilial("ZZ1")+aList2[nLinha,nX],"ZZ1_DESCRI")
		cBarra := "/"
	EndIF
Next nX

oSay12:setText(cAux)
oDlg1:refresh()
                    
If oList2:nAt == 1
	lSangria := .T.
EndIf
 
RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTOPER01  บAutor  ณMicrosiga           บ Data ณ  06/30/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Pesquisa rotas agrupadas dentro do mesmo patrimonio.      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Pesqlb(cPatrimonio,cRota1,cRota2)

Local lRet :=	.F.
Local nPos :=	1 //Ascan(aListb,{|x| Alltrim(x[1]) == Alltrim(cPatrimonio)})
Local aRet	:=	{}

//If nPos > 0
While nPos <= len(aListb)
	For nT := 3 to 10
		For nY := 2 to 8
			If aListb[nPos,nT,nY] == cRota1 .Or. aListb[nPos,nT,nY] == cRota2
				//lRet := .T.
				//exit    
				If Ascan(aRet,{|x| x = aListb[nPos,01]}) == 0
					aadd(aRet,aListb[nPos,01]) 					
				EndIf				           
				exit
			EndIf
		Next nY
	Next nT     
	nPos++
EndDo
//EndIf	

Return(aRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTOPER01  บAutor  ณMicrosiga           บ Data ณ  09/25/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Filtro                                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function filtro(nSel)

Local aArea		:=	GetArea()
Local aPergs	:= 	{} 
Local aRet		:= 	{} 
Local aAux		:=	{}
Local aCop		:=	aClone(aBkpL1)
Local cAux		:=	'' 
Local nPosd		:=	0
Local nDiaS		:=	1  
Local dDataE	:=	ctod("  /  /  ")  
Local aSubAr	:=	{}

aList1 := {}

If nSel == 1            
	aAdd(aPergs ,{1,"Rota De"	,space(TamSx3("ZZ1_COD")[1]),"@!",".T.","ZZ1",".T.",60,.F.})
	aAdd(aPergs ,{1,"Rota At้"	,space(TamSx3("ZZ1_COD")[1]),"@!",".T.","ZZ1",".T.",60,.F.})
	aAdd(aPergs ,{2,"Dia Semana","0", {"0=Todos","1=Segunda","2=Ter็a","3=Quarta","4=Quinta","5=Sexta"},50,'',.T.}) 
	aAdd(aPergs ,{1,"Data Especifica",dDataE,"99/99/99","","","",0,.F.})
	aAdd(aPergs ,{1,"Cliente"	,space(TamSx3("A1_COD")[1]),"@!",".T.","SA1",".T.",60,.F.})
	aAdd(aPergs ,{1,"Loja"		,space(TamSx3("A1_LOJA")[1]),"@!",".T.","",".T.",30,.F.})
	aAdd(aPergs ,{1,"Patrimonio",space(TamSx3("N1_CHAPA")[1]),"@!",".T.","SN1",".T.",60,.F.})
	aAdd(aPergs ,{2,"Estado"	,"", {"","0=Todos","1=SP","2=RJ","3=BA","4=PE","5=CE","6=MG","7=PR","8=RS"},50,'',.T.})
	
		
	If ParamBox(aPergs ,"Filtrar por",@aRet) 
		aSubAr := Pesqlb('',aRet[1],aRet[2])
		For nX := 1 to len(aCop)
			//Rota de
			If !Empty(aRet[1])   
			    //Rota Ate
				If (aCop[nX,13] >= aRet[1] .And. aCop[nX,13] <= aRet[2]) .Or. Ascan(aSubAr,{|x| x = aCop[nX,01]}) > 0 //Pesqlb(aCop[nX,1],aRet[1],aRet[2])
					//If aCop[nX,13] <= aRet[2]
						//Data Especifica
						If !Empty(aRet[4])
							nPos := substr(cvaltochar(aRet[4]),1,2)
							cAux := substr(aCop[nX,12],09)
							If substr(cAux,val(nPos),1) == "1"
								aCop[nX,17] := .F.
							EndIf
						Else
							//Dia Semana
							If val(aRet[3]) <> 0
								cAux := substr(aCop[nX,12],09)
								nPosd := 0
								nDiaS := 0
								For nY := firstday(ddatabase) to lastday(ddatabase)
									If dow(nY) <> 1 .And. dow(nY) <> 7
										nPosd++
										nDiaS++
										If nDiaS == val(aRet[3]) .And. substr(cAux,nPosd,1) == "1"
										 	//Aadd(aAux,aCop[nX])
										 	aCop[nX,17] := .F.
										 	exit
										EndIf
										If nDiaS == 5
											nDiaS := 0
										EndIf
									EndIf
								Next nY	
							Else
								//Aadd(aAux,aCop[nX])
								aCop[nX,17] := .F.
							EndIf
						EndIf
						//Cliente
						If !Empty(aRet[5])
							If aRet[5] == aCop[nX,03]
								aCop[nX,17] := .F.
							Else
								aCop[nX,17] := .T.
							EndIf
						EndIf    
						//Loja
						If !Empty(aRet[6])
							If aRet[6] == aCop[nX,04]
								aCop[nX,17] := .F.
							Else
								aCop[nX,17] := .T.
							EndIf	
						EndIf
						//Patrimonio
						If !Empty(aRet[7])
							If Alltrim(aRet[7]) == Alltrim(aCop[nX,01])
								aCop[nX,17] := .F.
							Else
								aCop[nX,17] := .T.
							EndIf	
						EndIf
						//Estado  aCop[nX,24]   
						If !Empty(aRet[8])
							If aRet[8] == "0" 
								aCop[nX,17] := .F.	
							ElseIf aRet[8] == "1" 
								If Empty(aCop[nX,24]) .OR. aCop[nX,24] == "SP" .OR. !aCop[nX,24] $ "RJ/BA/PE/CE/MG/PR/RS"
									aCop[nX,17] := .F.
								Else                  
									aCop[nX,17] := .T.
								EndIf
							ElseIf aRet[8] == "2"  
								If Empty(aCop[nX,24]) .OR. aCop[nX,24] == "RJ"
									aCop[nX,17] := .F.
								Else                  
									aCop[nX,17] := .T.
								EndIf
							ElseIf aRet[8] == "3"
								If Empty(aCop[nX,24]) .OR. aCop[nX,24] == "BA"
									aCop[nX,17] := .F.
								Else                  
									aCop[nX,17] := .T.
								EndIf
							ElseIf aRet[8] == "4"
								If Empty(aCop[nX,24]) .OR. aCop[nX,24] == "PE"
									aCop[nX,17] := .F.
								Else                  
									aCop[nX,17] := .T.
								EndIf
							ElseIf aRet[8] == "5"
								If Empty(aCop[nX,24]) .OR. aCop[nX,24] == "CE"
									aCop[nX,17] := .F.
								Else                  
									aCop[nX,17] := .T.
								EndIf
							ElseIf aRet[8] == "6"
								If Empty(aCop[nX,24]) .OR. aCop[nX,24] == "MG"
									aCop[nX,17] := .F.
								Else                  
									aCop[nX,17] := .T.
								EndIf
							ElseIf aRet[8] == "7"
								If Empty(aCop[nX,24]) .OR. aCop[nX,24] == "PR"
									aCop[nX,17] := .F.
								Else                  
									aCop[nX,17] := .T.
								EndIf
							ElseIf aRet[8] == "8"
								If Empty(aCop[nX,24]) .OR. aCop[nX,24] == "RS"
									aCop[nX,17] := .F.
								Else                  
									aCop[nX,17] := .T.
								EndIf  
							EndIf
						EndIf
					//EndIf
				EndIf
			ElseIf val(aRet[3]) <> 0 
				//dia da semana
				cAux := substr(aCop[nX,12],09)
				nPosd := 0
				nDiaS := 0
				For nY := firstday(ddatabase) to lastday(ddatabase)
					If dow(nY) <> 1 .And. dow(nY) <> 7
						nPosd++
						nDiaS++
						If nDiaS == val(aRet[3]) .And. substr(cAux,nPosd,1) == "1"
						 	aCop[nX,17] := .F.
						 	exit
						EndIf
						If nDiaS == 5
							nDiaS := 0
						EndIf
					EndIf
				Next nY	
			ElseIf !Empty(aRet[4])
                //data especifica
				nPos := substr(cvaltochar(aRet[4]),1,2)
				cAux := substr(aCop[nX,12],09)
				If substr(cAux,val(nPos),1) == "1"
					aCop[nX,17] := .F.
				EndIf 
			ElseIf !Empty(aRet[5]) 
				//cliente
				If aCop[nX,03] == aRet[5]
					If !Empty(aRet[6]) 
						If aCop[nX,04] == aRet[6]
							aCop[nX,17] := .F.
						EndIf
					Else
						aCop[nX,17] := .F.
					EndIf
				EndIf
			ElseIf !Empty(aRet[7])  
				//loja
				If aCop[nX,01] == aRet[7]
					aCop[nX,17] := .F.
				EndIf	
			ElseIf !Empty(aRet[8])   
				//patrimonio
				//aCop[nX,17] := .F.					
				If aRet[8] == "0" 
					aCop[nX,17] := .F.	
				ElseIf aRet[8] == "1" 
					If Empty(aCop[nX,24]) .OR. aCop[nX,24] == "SP" .OR. !aCop[nX,24] $ "RJ/BA/PE/CE/MG/PR/RS"
						aCop[nX,17] := .F.
					Else                  
						aCop[nX,17] := .T.
					EndIf
				ElseIf aRet[8] == "2"  
					If Empty(aCop[nX,24]) .OR. aCop[nX,24] == "RJ"
						aCop[nX,17] := .F.
					Else                  
						aCop[nX,17] := .T.
					EndIf
				ElseIf aRet[8] == "3"
					If Empty(aCop[nX,24]) .OR. aCop[nX,24] == "BA"
						aCop[nX,17] := .F.
					Else                  
						aCop[nX,17] := .T.
					EndIf
				ElseIf aRet[8] == "4"
					If Empty(aCop[nX,24]) .OR. aCop[nX,24] == "PE"
						aCop[nX,17] := .F.
					Else                  
						aCop[nX,17] := .T.
					EndIf
				ElseIf aRet[8] == "5"
					If Empty(aCop[nX,24]) .OR. aCop[nX,24] == "CE"
						aCop[nX,17] := .F.
					Else                  
						aCop[nX,17] := .T.
					EndIf
				ElseIf aRet[8] == "6"
					If Empty(aCop[nX,24]) .OR. aCop[nX,24] == "MG"
						aCop[nX,17] := .F.
					Else                  
						aCop[nX,17] := .T.
					EndIf
				ElseIf aRet[8] == "7"
					If Empty(aCop[nX,24]) .OR. aCop[nX,24] == "PR"
						aCop[nX,17] := .F.
					Else                  
						aCop[nX,17] := .T.
					EndIf
				ElseIf aRet[8] == "8"
					If Empty(aCop[nX,24]) .OR. aCop[nX,24] == "RS"
						aCop[nX,17] := .F.
					Else                  
						aCop[nX,17] := .T.
					EndIf  
				EndIf
			EndIf
		Next nX	
		//aList1 := aClone(aAux)
		For nX := 1 to len(aCop)
			If !aCop[nX,17]
				Aadd(aList1,aCop[nX])
			EndIf                    
		Next nX
	EndIf
Else
	aList1 := aClone(aCop)
EndIf

If len(aList1) < 1
	MsgAlert("Nใo encontrado op็๕es que satisfa็am ao filtro informado","TTOPER01")
	aList1 := aClone(aBkpL1)
EndIf

oList1:SetArray(aList1)
oList1:bLine := {||{aList1[oList1:nAt,01],; 
 						 aList1[oList1:nAt,02],;
 						 aList1[oList1:nAt,21],;
 						 aList1[oList1:nAt,14]}}
oList1:nAt := 1
oList1:refresh()
FHelp(oList1:nAt)
oDlg1:refresh()

	
RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTOPER01  บAutor  ณMicrosiga           บ Data ณ  09/26/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  incluir ou excluir um patrimonio de uma rota              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function incrota(nLinha,cOp)

Local aArea	:=	GetArea()
Local aPergs	:= 	{} 
Local aRet		:= 	{} 

If cOp == 1
	If !Empty(aList1[nLinha,13])
		If !MsgYesNo("Deseja trocar a rota deste Patrim๔nio?","TTOPER01")
			RestArea(aArea)
			Return
		Else
			aAdd(aPergs ,{1,"Informe a nova Rota"	,space(TamSx3("ZZ1_COD")[1]),"@!",".T.","ZZ1",".T.",100,.F.})
			If ParamBox(aPergs ,"Cadastro de Rotas",@aRet)
				If !Empty(aRet[1])
					DbSelectArea("SZE")
					DbSetOrder(1)
					If DbSeek(xFilial("SZE")+aList1[nLinha,03]+aList1[nLinha,04]+aList1[nLinha,01])
						While !EOF() .AND. SZE->ZE_PATRIMO == aList1[nLinha,01]
							If SUBSTR(SZE->ZE_MENSAL,1,6) == SUBSTR(aList1[nLinha,12],1,6)
								Reclock("SZE",.F.)
								SZE->ZE_ROTA := aRet[1]
								SZE->(Msunlock())
								aList1[nLinha,13] := aRet[1]
								aBkpL1[Ascan(aBkpL1,{|x| x[1] == aList[nLinha,01]}),13] := aRet[1]
								exit
							EndIf
							Dbskip()
						Enddo
					EndIf
				EndIf
			EndIf
		EndIf
	Else
		aAdd(aPergs ,{1,"Informe a Rota"	,space(TamSx3("ZZ1_COD")[1]),"@!",".T.","ZZ1",".T.",100,.F.})
		aAdd(aPergs ,{1,"Informe a Frequencia"	,space(TamSx3("ZE_FREQUEN")[1]),"@!",".T.","",".T.",100,.F.})
		aAdd(aPergs ,{1,"Informe o Fechamento"	,space(TamSx3("ZE_FECHAME")[1]),"@!",".T.","",".T.",100,.F.})
		If ParamBox(aPergs ,"Cadastro de Rotas",@aRet)
			If !Empty(aRet[1])
				DbSelectArea("SZE")
				DbSetOrder(1)
				If !DbSeek(xFilial("SZE")+aList1[nLinha,03]+aList1[nLinha,04]+aList1[nLinha,01])
					Reclock("SZE",.T.)
					SZE->ZE_FILIAL 	:= 	xFilial("SZE")
					SZE->ZE_CLIENTE	:= 	aList1[nLinha,03]
					SZE->ZE_LOJA	:= 	aList1[nLinha,04]
					SZE->ZE_FREQUEN	:= 	aRet[2]
					SZE->ZE_FECHAME	:=	aRet[3]
					SZE->ZE_ROTA 	:= 	aRet[1]
					SZE->(Msunlock())
					aList1[nLinha,13] := aRet[1]
					aList1[nLinha,16] := Posicione("ZZ1",1,xFilial("ZZ1")+aRet[1],"ZZ1_DESCRI")
					aBkpL1[Ascan(aBkpL1,{|x| x[1] == aList1[nLinha,01]}),13] := aRet[1]
					aBkpL1[Ascan(aBkpL1,{|x| x[1] == aList1[nLinha,01]}),13] := aList1[nLinha,16]
				EndIf
			EndIf
		EndIf
	EndIf      
Else
	If MsgYesNo("Confirma a retirada da rota deste Patrim๔nio?","TTOPER01")
		DbSelectArea("SZE")
		DbSetOrder(1)
		If DbSeek(xFilial("SZE")+aList1[nLinha,03]+aList1[nLinha,04]+aList1[nLinha,01]) 
			While !EOF() .AND. SZE->ZE_PATRIMO == aList1[nLinha,01]
				If SUBSTR(SZE->ZE_MENSAL,1,6) == SUBSTR(aList1[nLinha,12],1,6)
					Reclock("SZE",.F.)
					DbDelete()
					SZE->(Msunlock())
					exit
				EndIf
				DbSkip()
			EndDo
		EndIf
		
		aList1[nLinha,13] := space(6)
		aList1[nLinha,16] := ''
		aBkpL1[Ascan(aBkpL1,{|x| x[1] == aList1[nLinha,01]}),13] := space(6)
		aBkpL1[Ascan(aBkpL1,{|x| x[1] == aList1[nLinha,01]}),13] := ''
		
	EndIf
EndIf

oList1:refresh()
oDlg1:refresh()

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTOPER01  บAutor  ณMicrosiga           บ Data ณ  09/26/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Dias marcados ou desmarcados no calendario.               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function markday(ddia)

Local aArea	:=	GetArea()
Local cAux	:=	if(!empty(substr(aList1[oList1:nAt,12],1,8)),substr(aList1[oList1:nAt,12],1,8),cvaltochar(year(dDataBase))+cvaltochar(strzero(month(ddatabase),2))+aList1[oList1:nAt,14])
Local ninicio	:=	9

Aadd(aDiasM,{aList1[oList1:nAt,01],dtoc(ddia)})
aList1[oList1:nAt,18] := .T.

For nX := firstday(ddia) to lastday(ddia)
	If lSangria
		If Dow(nX) == 1 .Or. Dow(nX) == 7
			cAux += "0"
		EndIf	
	EndIf
	
	If nX == ddia
		cAux += "1"
	Else     
		If !empty(substr(aList1[oList1:nAt,12],ninicio,1))
			cAux += substr(aList1[oList1:nAt,12],ninicio,1) 
		else
			cAux += "0"
		EndIf
	EndIf
    
	ninicio++	
Next nX

aList1[oList1:nAt,12] := cAux  
aBkpL1[Ascan(aBkpL1,{|x| x[1] == aList1[oList1:nAt,01]}),12] := cAux
oMsCalend:AddRestri( day(ddia), CLR_GREEN, CLR_HRED)
                                                                      
oList1:refresh()
oDlg1:refresh()

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTOPER01  บAutor  ณMicrosiga           บ Data ณ  09/30/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Marcando ou desmarcando os itens permitidos no plano de   บฑฑ
ฑฑบ          ณtrabalho do patrimonio selecionado.                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function editcol2(nLinha)

Local aArea	:=	GetArea()
Local nColP	:=	oList2:colpos 
Local nLinP	:=	oList2:nAt //Ascan(alistb,{|x| Alltrim(x[1]) == Alltrim(aList1[oList1:nAt,01])})
Local aAux	:=	{}
Local nPosicao	:=	0 
Local cAux		:=	''
Local cPatrim	:= 	''  
Local cRota		:=	SPACE(6) //If(!Empty(aList2[nLinP,nColP]),aList2[nLinP,nColP],Space(6))
Local cRota2	:=	SPACE(6)
Local cRota3	:=	SPACE(6)
//Local cRota4	:=	SPACE(6)
Local lPExc		:=	If(!Empty(aList2[nLinP,nColP]),.T.,.F.)
Local cDias		:= 	'' 
Local aRet		:= 	{} 
Local ninicio	:=	9 
Local cRetPlan	:=	''
Local cBkExcP	:=	''
Local oSay1,oSay2,oBtn1,oBtn2,oBtn3,oSay3,oGet2   
Local nOpcao	:=	0
Local nPosAr	:=	0
Local dDtFecmto := ctod("")
Local nCol		:= 0 
Local lFecmto	:= .F.
Local cAuxFreq	:= GetMV("MV_XOPE001") 	//{"1D","2D","S","Q","M"}
Local cCombo	:= ""
Local cAdicF	:= ""
Local cSeq		:= SPACE(3) //If( !Empty(aList1[oList1:nAt,21]),aList1[oList1:nAt,21],space(2) )
Local cSeq2		:= SPACE(3)
Local cSeq3		:= SPACE(3)
Local lFrmLeit	:= .F.              
Local lFrmSang	:= .F.

Private cFreq		:= SPACE(2) //If(!Empty(aList2[nLinP,nColP]),aList1[oList1:nAt,14],space(2))
Private cTpPla		:= cvaltochar(nLinP) +cvaltochar(nColP)
Private aFreq		:= {}
Private nPosServ	:= nLinP+2                            
Private oMsCalend2
                
// frequencias
If(Empty(cAuxFreq),cAuxFreq:="1D#2D#S#Q#M",)
aFreq := StrToKarr(cAuxFreq,"#")

// Verifica se ja existe Rota nesse tipo de servico                                                                                               
/*
nPosAr := Ascan( alistb,{|x| x[1] == aList1[oList1:nAt,01] .And. Val( SubStr(x[2],1,1) ) == nLinP .And. Val( SubStr(x[2],2,1) ) <> nColP  } ) 
If nPosAr > 0
	MsgAlert( "Jแ existe rota cadastrada para esse tipo de servi็o." +CRLF +"Para prosseguir, exclua a rota jแ existente." )
	Return
EndIf
*/

//Zerando o Array com os dias marcados durante a edicao da linha
aDiasM2	:=	{}
                                          
If oList2:nAt == 1
	lSangria := .T.
Else
	lSangria := .F.	
EndIf


// Carrega as variaveis da TEla
nPosAr := Ascan( alistb,{|x| x[1] == aList1[oList1:nAt,01] .And. x[2] == cTpPla  } )   
If nPosAr > 0
	cDias 	:= aListb[nPosAr][nPosServ][09]
	cRota	:= aListb[nPosAr][nPosServ][nColP+1]
	cSeq	:= aListb[nPosAr][nPosServ][10]
	cfreq	:= aListb[nPosAr][nPosServ][12]
	If Empty(cfreq)
		cFreq := aFreq[1]
	EndIf

	If !Empty(aListB[nPosAr][12])
		aDiasM2 := aClone(aListB[nPosAr][12])
	EndIf
	
	If !Empty(aListb[nPosAr][14])		// rotas aux
		cRota2 := aListb[nPosAr][14]
	EndIf
	
	If !Empty(aListb[nPosAr][15])
		cRota3 := aListb[nPosAr][15] 
	EndIf
	
	If !Empty(aListb[nPosAr][16])		// sequencias aux
		cSeq2 := aListb[nPosAr][16] 
	EndIf                         
	
	If !Empty(aListb[nPosAr][17])
		cSeq3 := aListb[nPosAr][17] 
	EndIf
	
	// form leitura
	lFrmLeit := aListb[nPosAr][18]
	
	// form sangria              
	lFrmSang := aListb[nPosAr][19]
	                         
EndIf


	                                                                                   
// Monta a Tela	
oDlg2	:= MSDialog():New( 088,232,410,635,"Abastecimento",,,.F.,,,,,,.T.,,,.T. )
	
	oGrp	:= TGroup():New( 002,002,048,190,"",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
		
	oSay1	:= TSay():New( 010,005,{||"Executor"},oGrp,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)
	//oGetRota1	:= TGet():New( 010,037,{|u| If(PCount()>0,cRota:=u,cRota)},oGrp,044,008,'@!', { || VldRota( nColP,cRota,__readvar )}, CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZZ1",cRota,,)
	@ 010,037 MSGET oGetRota1 VAR cRota	F3 "ZZ1"	PICTURE "@!"	OF oGrp SIZE 044,008 VALID VldRota( nColP,cRota ) PIXEL HASBUTTON
	                                                                                                                                 
	// Segundo executor
	//oGetRota2 := TGet():New( 010,089,{|u| If(PCount()>0,cRota2:=u,cRota2)},oGrp,044,008,'@!', { || VldRota( nColP,cRota2 )}, CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZZ1",cRota2,,)
	@ 010,089 MSGET oGetRota2 VAR cRota2	F3 "ZZ1"	PICTURE "@!"	OF oGrp SIZE 044,008 VALID VldRota( nColP,cRota2 ) PIXEL HASBUTTON
	oGetRota2:Hide()
	If cFreq $ "2D|3D" .And. !Empty(cRota2)
		oGetRota2:Show()
	EndIf         
	
	// Terceiro executor
	//oGetRota3 := TGet():New( 010,136,{|u| If(PCount()>0,cRota3:=u,cRota3)},oGrp,044,008,'@!', { || VldRota( nColP,cRota3 )}, CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZZ1",cRota3,,)
	@ 010,136 MSGET oGetRota3 VAR cRota3	F3 "ZZ1"	PICTURE "@!"	OF oGrp SIZE 044,008 VALID VldRota( nColP,cRota3 ) PIXEL HASBUTTON
	oGetRota3:Hide()                  
	If cFreq $ "2D|3D" .And. !Empty(cRota3)
		oGetRota3:Show()
	EndIf	
		
	oSay3	:= TSay():New( 022,005,{||"Frequencia"},oGrp,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)
	oCBox1	:= TComboBox():New( 022,037,{ |u| If(PCount()>0,cfreq:=u,cfreq) },aFreq,044,010,oGrp,,{ || VldFreq() },,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,cfreq)
	
	oSay3	:= TSay():New( 034,005,{||"Sequencia"},oGrp,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,026,008)
	oGet2	:= TGet():New( 034,037,{|u| If(PCount()>0,cSeq:=u,cSeq)},oGrp,044,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	oGet2:Disable()
	
	// sequencia 2 - aux
	oGSeq2	:= TGet():New( 034,089,{|u| If(PCount()>0,cSeq2:=u,cSeq2)},oGrp,044,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	oGSeq2:Disable()
	oGSeq2:Hide()
	                    
	// sequencia 3 - aux
	oGSeq3	:= TGet():New( 034,136,{|u| If(PCount()>0,cSeq3:=u,cSeq3)},oGrp,044,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	oGSeq3:Disable()
	oGSeq3:Hide()
	
	If cFreq == "2D
		oGSeq2:Show()
	EndIf            
	If cFreq == "3D"
		oGSeq2:Show()
		oGSeq3:Show()
	EndIf
	
	
	oCheck1 := TCheckBox():New(046,005,'Mais de um atendente?',{|u|if(PCount()>0,lSegAtend:=u,lSegAtend) },oGrp,100,210,,{|| VldAtend() },,,,,,.T.,,,)
	oCheck1:Hide()
	If cFreq $ "2D|3D"  .And. ( !Empty(cRota2) .Or. !Empty(cRota3) )
		lSegAtend := .T.
		oCheck1:Show()
	EndIf
	
	
	// se for abastecimento - mostrar opcao de formularios leitura/sangria
	oChkLeit := TCheckBox():New(056,005,'Leitura?',{|u|if(PCount()>0,lFrmLeit:=u,lFrmLeit) },oGrp,100,210,,{|| },,,,,,.T.,,,)
	oChkSang := TCheckBox():New(056,50,'Sangria?',{|u|if(PCount()>0,lFrmSang:=u,lFrmSang) },oGrp,100,210,,{|| },,,,,,.T.,,,)
	                              
	
	
	oMsCalend2 := MsCalend():New(067,030,oDlg2,.T.)
	oMsCalend2:bChange := { || markd2(oMsCalend2:dDiaAtu,cDias,@lFecmto,lSangria,@dDtFecmto,nPosAr) }
	
	// --> Prepara a variavel cAux - Dias do MES
	If !Empty(aList2[nLinP,nColP])
		For nX := firstday(dDataBase) to lastday(dDataBase)
			// na sangria trata os sabados e domingos
			If lSangria                         
				If dow(nX) == 1 .Or. dow(nX) == 7
					cAux += "0"
				Else
					If substr(cDias,ninicio,1) $ "1|F"
						cAux += substr(cDias,ninicio,1)  
						oMsCalend2:AddRestri( day(nX), CLR_GREEN, CLR_HRED)
						AADD(aDiasM2, { aList1[oList1:nAt][1], dtoc(nX) } )		
					Else
						cAux += "0"
					EndIf
				EndIf			
			Else
				If substr(cDias,ninicio,1) $ "1|F"
					cAux += substr(cDias,ninicio,1)  
					oMsCalend2:AddRestri( day(nX), CLR_GREEN, CLR_HRED)
					AADD(aDiasM2, { aList1[oList1:nAt][1], dtoc(nX) } ) 
				Else
					cAux += "0"
				EndIf
			EndIf
	
			ninicio++
		Next nX
	EndIf
	// <--
	
	//oBtn9		:= TButton():New( 060,170,"Marcar tudo",oDlg2,{||MarkMes(oMsCalend2:dDiaAtu)},037,008,,,,.T.,,"",,,,.F. )
             
	
	
	oBtFchmto	:= TButton():New( 140,010,"Fechamento",oDlg2,{ || IF( !lFecmto, lFecmto := .T.,), IF( lFecmto,MsgInfo("Escolha o dia do fechamento"),)  },037,012,,,,.T.,,"",,,,.F. )
	oBtn2		:= TButton():New( 140,056,"Excluir",oDlg2,{||oDlg2:end(nOpcao:=2)},032,012,,,,.T.,,"",,,,.F. )
	oBtn2:Disable()
	
	oBtn1		:= TButton():New( 140,106,"Ok",oDlg2,{ ||oDlg2:End(nOpcao:=1) },037,012,,,,.T.,,"",,,,.F. )
	oBtn3		:= TButton():New( 140,156,"Sair",oDlg2,{ ||oDlg2:End(nOpcao:=0) },037,012,,,,.T.,,"",,,,.F. )
	
	If !Empty(aList2[nLinP,nColP])
		oBtn2:Enable()
	EndIf
	
	oMscalend2:dDiaAtu := ddatabase
oDlg2:Activate(,,,.T.)            


//	Incluir ou excluir uma rota do plano de trabalho
If nOpcao == 1
	cAux := ""
	If !Empty(cRota) .And. Len(aDiasM2) > 0  /*.And. Len(aDiasm) > 0 */ 
		cRetPlan := aList1[oList1:nAt,12]
		cAdicF	:=	cvaltochar(year(dDataBase))+cvaltochar(strzero(month(dDataBase),2))+If(len(cFreq)<2,cFreq+space(2-len(cFreq)),cFreq)
	    
	    Asort(aDiasm2,,,{|x,y| x[2] < y[2]})
	    
	    For nX := firstday(ctod(aDiasm2[1,2])) to lastday(ctod(aDiasm2[1,2]))		        
	        nPosd := Ascan(aDiasm2,{|x| ctod(x[2]) == nX})
		   
	        If nPosd > 0
	        	If lSangria
			       	If dow(nX) == 1 .Or. dow(nX) == 7
			       		cAux += "0"
			       		Loop
			       	EndIf
		    	EndIf
		    
	        	If nX == dDtFecmto
	        		cAux += "F"
	        	Else	
					cAux += "1"
				EndIf	
			Else
				cAux += "0"
			EndIf  
		Next nX
	    
	    cAdicF += cAux
	    nPosaListb := Ascan( alistb,{|x| x[1] == aList1[oList1:nAt,01] .And. x[2] == cTpPla  } )
	    // se nao encontrou esse plano de trabalho, adiciona
	    If nPosaListb == 0                                 
	     	
	     	Aadd(alistb,{aList1[oList1:nAt,01], cTpPla})
    
		    For nPP := 1 to len(aList2)
		    	Aadd( aListb[len(alistb)],{aList2[nPP,01],aList2[nPP,02],aList2[nPP,03],aList2[nPP,04],aList2[nPP,05],aList2[nPP,06],aList2[nPP,07],aList2[nPP,08],"","","",""})
		    Next nPP  
		    
		    Aadd(aListb[len(alistb)], 0 )
            Aadd(aListb[len(alistb)], {} )
            Aadd(aListb[len(alistb)], .F. )	// controle de alteracoes
            
            Aadd(aListb[len(alistb)], "" )		// Rota 2	- adicionado 25/03/14
            Aadd(aListb[len(alistb)], "" )		// Rota 3	- adicionado 25/03/14
            Aadd(aListb[len(alistb)], "" )		// Seq 2	- adicionado 16/10/14
            Aadd(aListb[len(alistb)], "" )		// Seq 3	- adicionado 16/10/14 
            
            Aadd(aListb[len(alistb)], .F. )		// form leitura - 13/09/2017 
            Aadd(aListb[len(alistb)], .F. )		// form sangria - 13/09/2017 
	    EndIf
	       
		nPosaListb := Ascan( alistb,{|x| x[1] == aList1[oList1:nAt,01] .And. x[2] == cTpPla  } )   			
    	aListb[nPosaListb][02] := cTpPla										// tipo plano
    	aListb[nPosaListb][nPosServ][nColP+1] := cRota							// rota
		aListb[nPosaListb][nPosServ][09] := cAdicF								// mensal
		aListb[nPosaListb][nPosServ][10] := cSeq								// sequencia
		aListb[nPosaListb][nPosServ][11] := cvaltochar(Day(dDtFecmto))			// fechamento
		aListb[nPosaListb][nPosServ][12] := cFreq
	    aListB[nPosaListb][12] := aclone(aDiasM2)
	    aListB[nPosaListb][13] := .T. // houve alteracao
	    
	    aListB[nPosaListb][14] := cRota2 // Rota 2	- adicionado 25/03/14
	    aListB[nPosaListb][15] := cRota3 // Rota 3	- adicionado 25/03/14
	    aListB[nPosaListb][16] := cSeq2	// Seq 2 	- adicionado 16/10/14
	    aListB[nPosaListb][17] := cSeq3	// Seq 3	- adicionado 16/10/14
	    
	    aListB[nPosaListb][18] := lFrmLeit	// form leitura - adicionado 13/09/17
	    aListB[nPosaListb][19] := lFrmSang	// form sangria - adicionado 13/09/17
	    
	    
	    
	    
	    aList2[nLinP,nColP] := cRota
	    aList1[oList1:nAt,21] := cSeq
	    aList1[oList1:nAt,14] := cFreq
	    aList1[oList1:nAt,22] := cTpPla
	    aList1[oList1:nAt][18] := .T.	// aList1 - houve alteracao
	    	             
		For nZ := 9 to len(cRetPlan)
			If substr(cAdicF,nZ,1) != "0" .And. substr(cRetPlan,nZ,1) == "0"
				cRetPlan := substr(cRetPlan,1,nZ-1) + substr(cAdicF,nZ,1) + substr(cRetPlan,nZ+1) 
			EndIf
		Next nZ
		
		If !Empty(cRetPlan)                           
			aList1[oList1:nAt,12] := cRetPlan
		Else
			aList1[oList1:nAt,12] := cAdicF //cRetPlan
		EndIf
	EndIf          
	
	lAlterou := .T.
	        
	// Chama tela para configurar as sequencias dos patrimonios da Rota
	TelaSeq(cRota,cAdicF)
	
// Excluir uma rota existente do plano de trabalho do patrimonio.
Elseif nOpcao == 2
	cRetPlan := aList1[oList1:nAt,12]

	For nX := 1 to len(aListb)
		If Alltrim(aListb[nX][01]) == Alltrim(aList1[oList1:nAt,01]) .And. Alltrim(aListb[nX][02]) == cTpPla
			nPosAux := nX
			cAux := aListb[nX,nPosServ,09]
			//aListb[nX,nPosServ,09] := space(len(alist1[olist1:nat][12]))	// zera a posicao
			Exit
		EndIf	
	Next nX
	
	For nX := 9 To Len(caux)
		If SubStr(cAux,nX,1) == "0"
			Loop
		EndIf	
		lUsado := ChkDia(nX,nPosAux)
		If !lUsado
			cRetPlan := SubStr(cRetPlan,1,nX-1) +"0" +SubStr(cRetPlan,nX+1)
		EndIf
	Next nX
	
	// Retorna o conteudo restante para o array principal para montar novamente o calendario com as rotas restantes.
	aList1[oList1:nAt,12] := cRetPlan
	aList2[nLinP,nColP] := space(6)
	                    	
	dbSelectArea("SZE")     
	If aListb[nPosAr,11] > 0
		DbGoTo(aListb[nPosAr,11])
		If Recno() == aListb[nPosAr,11]
					
    		// apaga horario - SZR
			cAno := CValToChar(YEAR(dDatabase))
			cMes := StrZero(MONTH(dDatabase),2)
	
		    dbSelectArea("SZR")
		    dbSetOrder(2)	    
			If DbSeek( xFilial("SZR") +AvKey(SZE->ZE_ROTA,"ZR_ROTA")+AvKey(SZE->ZE_CHAPA,"ZR_CHAPA")+AvKey(cAno,"ZR_ANO")+AvKey(cMes,"ZR_MES") )
				While SZR->ZR_FILIAL == xFilial("SZR") .And. AllTrim(SZR->ZR_ROTA) == AllTrim(SZE->ZE_ROTA) .And. ;
						AllTrim(SZR->ZR_CHAPA) == AllTrim(SZE->ZE_CHAPA) .And. AllTrim(SZR->ZR_ANO) == cAno .And. ;
						Val(SZR->ZR_MES) >= Val(cMes) .And. SZR->(!EOF())
						
					RecLock("SZR",.F.)
					SZR->(dbDelete())
					SZR->(MsUnLock())
					
					SZR->(dbSkip())
				End
			EndIf
               

			// apaga SZE
			dbSelectArea("SZE")
			Reclock("SZE",.F.)
			SZE->(DbDelete())
			SZE->(Msunlock())
		EndIf
		                
		ADel(aListB,nPosAr)
		ASize(aListB,len(aListB)-1)
	EndIf	
EndIf
                
FHelp(oList1:nAt)
oList1:refresh()  
oList2:SetArray(aList2)
oList2:bLine := { || {aList2[oList2:nAt,01],; 
 						 aList2[oList2:nAt,02],;
 						 aList2[oList2:nAt,03],;
 						 aList2[oList2:nAt,04],; 
 						 aList2[oList2:nAt,05],;
 						 aList2[oList2:nAt,06],;
 						 aList2[oList2:nAt,07] }}
oList2:refresh()
oDlg1:refresh()

RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldFreq   บAutor  ณMicrosiga           บ Data ณ  03/24/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldFreq() 
                                                                         

cFreq := aFreq[oCBox1:nAt]
	                                                                         
If "D" $ cFreq .And. Val(SubStr(cFreq,1,1)) > 1
	oCheck1:Show()
	If lSegAtend
		If cFreq == "2D"		
			oGetRota2:Show()
			oGetRota3:Hide()
			oGSeq2:Show()
			oGSeq3:Hide()
		EndIf
		If cFreq == "3D"    
			oGetRota2:Show()
			oGetRota3:Show()
			oGSeq2:Show()
			oGSeq3:Show()         
		EndIf
	Else
		If cFreq == "2D"		
			oGSeq2:Show()
			oGSeq3:Hide()
		ElseIf cFreq == "3D"    
			oGSeq2:Show()
			oGSeq3:Show()    
		EndIf
	EndIf
Else              
	lSegAtend := .F.
	oCheck1:Hide()
	oGetRota2:Hide()
	oGetRota3:Hide()
	oGSeq2:Hide()
	oGSeq3:Hide()
EndIf                                                                    

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldAtend  บAutor  ณMicrosiga           บ Data ณ  03/24/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldAtend()


If lSegAtend
	If cFreq == "2D"		
		oGetRota2:Show()
	EndIf
	If cFreq == "3D"    
		oGetRota2:Show()
		oGetRota3:Show()            
	EndIf
Else
	oGetRota2:Hide()
	oGetRota3:Hide()        
EndIf	
      
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTelaSeq   บAutor  ณJackson E. de Deus  บ Data ณ  24/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMostra a tela de sequencias dos patrimonios por Rota        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TelaSeq(cRota,cMensal) 

Local aAux := {}
Local aRet := {}
Local nPos := 0
Local aAuxPos := {}
Local aAuxP := {}
Local nPos1 := 0
Local nPos2 := 0 
Local nSeq := 0
Local lTrocou := .F.

Local dDia := FirstDay(dDatabase)
Local nDiaFim := LastDay(dDatabase)
Local dD
Local cAno := CValToChar(YEAR(dDatabase))
Local cMes := StrZero(MONTH(dDatabase),2)
Local cDia := ""
Local nDia := 0
Local cSeq := ""
Local cTpPlan := ""
Local cSeqAnt := ""
Local aAuxBkp := {} 

// organiza os patrimonios para a montagem da tela
aAux := Patrim(cRota,cMensal)
//aAuxBkp := ACOPY(aAux)
aAuxBkp := Array(Len(aAux))
Acopy(aAux,aAuxBkp)

// ordena os patrimonios -> cliente + loja + patrimonio
Ordenar(@aAux)

// tela para ajuste de sequencias dos patrimonios na Rota
aRet := U_TTOPSEQ01(cRota,aAux)

// Trabalha o retorno
If Valtype(aRet) == "A"
	For nI := 1 To Len(aRet)
		lTrocou := .F.
		aRet[nI][5] := cvaltochar(Val(aRet[nI][5]))
		                
		// verifica se mudou a sequencia - alterar
		For nJ := 1 To Len(aAuxBkp)
			If AllTrim(aAuxBkp[nJ][1]) == AllTrim(aRet[nI][1]) .And. Val(aAuxBkp[nJ][5]) <> Val(aRet[nI][5])
				lTrocou := .T.
				cSeqAnt := cvaltochar(Val(aAuxBkp[nJ][5]))
				Exit
			EndIf
		Next nJ
		
		dbSelectArea("SZR")
		dbSetOrder(2)	// filial rota patrimonio ano mes dia sequencia tipopla
		nDia := 0
		cTpPlan := aRet[nI][4]
		cSeq := cvaltochar(Val(aRet[nI][5]))
	
		For dD := dDia To nDiaFim
			nDia++
			cDia := StrZero(Day(dD),2)
			If SubStr(aRet[nI][15],nDia,1) $ "1|F|T"
			
				// trocou sequencia
				If lTrocou
					// ja existe registro na SZR
					If dbSeek( xFilial("SZR") +AvKey(cRota,"ZR_ROTA")+AvKey(aRet[nI][1],"ZR_CHAPA")+AvKey(cAno,"ZR_ANO")+AvKey(cMes,"ZR_MES")+AvKey(cDia,"ZR_DIA")+AvKey(cSeqAnt,"ZR_SEQ") +Avkey(cTpPlan,"ZR_TIPOPLA")  )
						RecLock("SZR",.F.)
						SZR->ZR_SEQ := cSeq
						MsUnLock()
					// nao existe registro	
					Else
						RecLock("SZR",.T.)
						SZR->ZR_FILIAL := xFilial("SZR")
						SZR->ZR_ROTA := cRota
						SZR->ZR_CLIENTE := aRet[nI][6]
						SZR->ZR_LOJA := aRet[nI][7]
						SZR->ZR_CHAPA := aRet[nI][1]
						SZR->ZR_ANO := cAno
						SZR->ZR_MES := cMes
						SZR->ZR_DIA := cDia       
						SZR->ZR_DATA := stod(cAno+cMes+cDia)
						SZR->ZR_DIASEMA := CVALTOCHAR(Dow(stod(cAno+cMes+cDia)))
						//SZR->ZR_HORA := ""
						SZR->ZR_SEQ := cSeq
						SZR->ZR_TIPOPLA := cTpPlan
						MsUnLock()	
					EndIf
				// nao trocou sequencia	
				Else
					If !dbSeek( xFilial("SZR") +AvKey(cRota,"ZR_ROTA")+AvKey(aRet[nI][1],"ZR_CHAPA")+AvKey(cAno,"ZR_ANO")+AvKey(cMes,"ZR_MES")+AvKey(cDia,"ZR_DIA")+AvKey(cSeq,"ZR_SEQ") +Avkey(cTpPlan,"ZR_TIPOPLA")  )
						RecLock("SZR",.T.)
						SZR->ZR_FILIAL := xFilial("SZR")
						SZR->ZR_ROTA := cRota
						SZR->ZR_CLIENTE := aRet[nI][6]
						SZR->ZR_LOJA := aRet[nI][7]
						SZR->ZR_CHAPA := aRet[nI][1]
						SZR->ZR_ANO := cAno
						SZR->ZR_MES := cMes
						SZR->ZR_DIA := cDia
						SZR->ZR_DATA := stod(cAno+cMes+cDia)
						SZR->ZR_DIASEMA := CVALTOCHAR(Dow(stod(cAno+cMes+cDia)))
						//SZR->ZR_HORA := ""
						SZR->ZR_SEQ := cSeq
						SZR->ZR_TIPOPLA := cTpPlan
						MsUnLock()
					EndIf				
				EndIf			
			EndIf
		Next dD                   

		// alterar gravacao da sequencia
		For nJ := 1 to Len(aRet[nI][14])
			aAuxPos := StrToKarr(aRet[nI][14][nJ],"/")
			nPos1 := Val(aAuxPos[1])
			nPos2 := Val(aAuxPos[2])    
		    
			If Empty(aRet[nI][18])
				aListB[nPos1][nPos2][10] := aRet[nI][5]
			Else
				If !"SEQAUX" $ AllTrim(aRet[nI][18])
					aListB[nPos1][nPos2][10] := aRet[nI][5]
				Else                           
					aAuxP := StrToKarr( aRet[nI][18], "|"  )
					If Len(aAuxP) > 1
						nSeq := Val(aAuxP[2])                    
						If nSeq == 1	// seq aux 2
							aListB[nPos1][16] := aRet[nI][5]
						ElseIf nSeq == 2	// seq aux 3
							aListB[nPos1][17] := aRet[nI][5]
						EndIf
					EndIf		   
				EndIf
			EndIf	
			aListB[nPos1][13] := .T.				// alterou  
		Next nJ
	Next nI               
EndIf


Return
                                                                                                         

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldRota   บAutor  ณJackson E. de Deus  บ Data ณ  18/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida a rota digitada no campo "Executor".                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldRota(nColP,cRota)
               
Local lRet := .T.

// Valida coluna Sangria
If nColP == 4
	If !Empty(cRota)
		If SubStr(cRota,1,2) <> "RT"
			MsgAlert("Na Sangria sใo aceitas somente rotas iniciadas com 'RT'.")
			If __readvar == "cRota"
				oGetRota1:SetFocus()
			ElseIf __readvar == "cRota2"
				oGetRota2:SetFocus()
			ElseIf __readvar == "cRota3"
				oGetRota3:SetFocus()
			EndIf
			lRet := .F.
		EndIf
	EndIf
Else
	If !Empty(cRota)
		If SubStr(cRota,1,2) == "RT"
			MsgAlert("Rotas iniciadas com 'RT' sใo aceitas somente na Sangria.")
			If __readvar == "cRota"
				oGetRota1:SetFocus()
			ElseIf __readvar == "cRota2"
				oGetRota2:SetFocus()
			ElseIf __readvar == "cRota3"
				oGetRota3:SetFocus()
			EndIf
			lRet := .F.
		EndIf           
	EndIf
EndIf                 

//If( !Empty(cRota),oSay2:settext(Posicione("ZZ1",1,xFilial("ZZ1")+cRota,"ZZ1_DESCRI")),oSay2:SETText("") )      

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTOPER01  บAutor  ณMicrosiga           บ Data ณ  01/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function markd2(ddia,cDias,lFecmto,lSangria,dDtFecmto,nPosAr)

Local aArea	:=	GetArea()
Local nPosD	:=	9
Local nCont	:=	0
Local dDiaAux := dDia
Local lFeriado := .F.
Default nPosAr := 0

// valida feriado na sangria
If lSangria
	ddia := DataValida(ddia,.T.)	// retorna o prox. dia util
	If ddia <> dDiaAux
		MsgInfo("Na Sangria nใo sใo considerados os sแbados, domingos e feriados")
	EndIf
	oMsCalend2:dDiaAtu := ddia
Else
	lFeriado := ChkFeriado(ddia)
	If lFeriado
		If !MsgYesNo("O dia escolhido ้ feriado." +CRLF +"Confirma?")
			If lFecmto
				lFecmto := .F.
			EndIf
			Return
		EndIf      
	EndIf
EndIf
 
// salva data do fechamento
If lFecmto
	dDtFecmto := ddia
EndIf

For nX := firstday(dDia) to dDia
	nCont++  
Next nX
             


If substr(cDias,nCont+8,1) != "0" .And. !Empty(cDias)
	ninicio := 9
	cDias := substr(cDias,nCont+7,1)+'0'+substr(cDias,nCont+9)

	oMsCalend2 := Nil
	oMsCalend2 := MsCalend():New(016,268,oDlg2,.T.)
	
	oMsCalend2:CtrlRefresh()

	//Acoes do Calendario
	oMsCalend2:bChange := {|| markd2(oMsCalend2:dDiaAtu,cDias) }
	
	For nX := firstday(dDia) to lastday(dDia)
		If lSangria
			if dow(nX) <> 1 .and. dow(nX) <> 7
				If substr(cDias,ninicio,1) $ "1|F"
					If lFecmto
						oMsCalend2:AddRestri( day(nX), CLR_HRED, CLR_BLUE)  
					Else      
						oMsCalend2:AddRestri( day(nX), CLR_GREEN, CLR_HRED)
					EndIf
				EndIf
			EndIf
		Else 
			If substr(cDias,ninicio,1) $ "1|F"
				If lFecmto
					oMsCalend2:AddRestri( day(nX), CLR_HRED, CLR_BLUE)  
				Else
					oMsCalend2:AddRestri( day(nX), CLR_GREEN, CLR_HRED)  
				EndIf
			EndIf
		EndIf	
	
		ninicio++	
	Next nX

	If Ascan(aDiasM2,{|x| x[2] == dtoc(ddia) }) > 0
		Adel(aDiasM2,Ascan(aDiasM2,{|x| x[2] == dtoc(ddia) }))
		ASize(aDiasM2,len(aDiasM2))
	EndIf	        
	
Else
	Aadd(aDiasM,{aList1[oList1:nAt,01],dtoc(ddia)}) 
	Aadd(aDiasM2,{aList1[oList1:nAt,01],dtoc(ddia)})
    
    If nPosAr > 0
    	AADD(aListB[nPosAr][12], {aList1[oList1:nAt,01],dtoc(ddia)} )
    EndIf
  	If lFecmto
  		oMsCalend2:AddRestri( day(ddia), CLR_HRED, CLR_BLUE)
  	Else
		oMsCalend2:AddRestri( day(ddia), CLR_GREEN, CLR_HRED)
	EndIf
EndIf
                                                                      
oList1:refresh()
oDlg1:refresh()

RestArea(aArea)

lFecmto := .F.

//oMsCalend2:CtrlRefresh()

Return

      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTOPER01  บAutor  ณMicrosiga           บ Data ณ  02/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

// Faz a gravacao das rotas na SZE
Static Function Gravar()

Local cCli := ""
Local cLoja := ""
Local cChapa := ""
Local cRota := ""
Local cMensal := ""
Local cFrequen := ""
Local cTipoPLa := ""
Local cSeq := ""
Local nPosIni := 3
Local nPosfim := 10
Local cDtFecmto := ""
Local lGravou := .F.
Local cRotaAux := ""
Local cSeqAux := ""
Local lFrmLeit	:= .F.
Local lFrmSang	:= .F.


DbSelectArea("SZE")
ProcRegua(Len(aListB))
For nI := 1 To Len(aListb)
	IncProc()
	If !aListb[nI][13]
		Loop
	EndIf
	
	cChapa		:= aListb[nI][01]
	cTipoPla	:= aListb[nI][02]
	lFrmLeit	:= aListb[nI][18]
	lFrmSang	:= aListb[nI][19]
	
	
	If lSegAtend
		cRotaAux	:= aListb[nI][14]
		If !Empty(aListb[nI][15])
			cRotaAux += "/" 
			cRotaAux += aListb[nI][15]
		EndIf
	EndIf
	
	cSeqAux := ""
	If !Empty(aListb[nI][16])
		cSeqAux += aListb[nI][16]
	EndIf
	If !Empty(aListb[nI][17])
		cSeqAux += "/" +aListb[nI][17]
	EndIf
	
	cCli		:= Posicione("SN1",2,xFilial("SN1")+Avkey(cChapa,"N1_CHAPA"),"N1_XCLIENT")
	cLoja		:= Posicione("SN1",2,xFilial("SN1")+Avkey(cChapa,"N1_CHAPA"),"N1_XLOJA")
	
	If Empty(cChapa) .Or. Empty(cTipoPla)
		Loop
	EndIf
	                                     
	For nJ := nPosIni To nPosfim
		For nK := 3 To 8 // ??
			cRota		:= aListb[nI,nJ,nK]
			cMensal		:= IIF( Len( aListb[nI,nJ])>8, aListb[nI,nJ,09], "")
			cSeq		:= IIF( Len(aListb[nI,nJ])>9, aListb[nI,nJ,10], "") 
		    cFrequen	:= SubStr(cMensal,7,2)
		    dDtFecmto	:= IIF( Len(aListb[nI,nJ])>10, aListb[nI,nJ,11], "" ) 
			
			If Empty(cRota) .or. Empty(cMensal) .Or. Empty(cSeq) .Or. Empty(cFrequen)
				Loop
			EndIf
			
			// Se possui recno, altera, caso contrario cria um novo
			If aListb[nI,11] > 0
				dbGoTo(aListb[nI,11])
				If AllTrim(SZE->ZE_TIPOPLA) == AllTrim(cTipoPla)
					RecLock("SZE",.F.)
				    SZE->ZE_FREQUEN	:= cFrequen
				    SZE->ZE_ROTA	:= cRota
				    SZE->ZE_MENSAL	:= cMensal
				    SZE->ZE_TIPOPLA	:= cTipoPla
				    SZE->ZE_SEQ		:= cSeq
				    SZE->ZE_FECHAME := cDtFecmto
				    SZE->ZE_ROTAAUX := cRotaAux
				    SZE->ZE_SEQAUX := cSeqAux
				    SZE->ZE_FRMLEIT := lFrmLeit
	    	    	SZE->ZE_FRMSANG := lFrmSang
	    	    
				    SZE->(Msunlock())
		        	lGravou := .T.
		        Else
		        	RecLock("SZE",.T.)
				    SZE->ZE_FILIAL	:= xFilial("SZE")
				    SZE->ZE_CLIENTE	:= cCli
				    SZE->ZE_LOJA	:= cLoja
				    SZE->ZE_FREQUEN	:= cFrequen
				    SZE->ZE_CHAPA	:= cChapa
				    SZE->ZE_ROTA	:= cRota
				    SZE->ZE_MENSAL	:= cMensal
				    SZE->ZE_TIPOPLA	:= cTipoPla
				    SZE->ZE_SEQ		:= cSeq
				    SZE->ZE_FECHAME := cDtFecmto
   				    SZE->ZE_ROTAAUX := cRotaAux
		    	    SZE->ZE_SEQAUX := cSeqAux
			     	SZE->ZE_FRMLEIT := lFrmLeit
	    	    	SZE->ZE_FRMSANG := lFrmSang
			     	
			     	aListb[nI,11] := Recno()
				    SZE->(Msunlock())
					lGravou := .T.
		        EndIf	
			Else
				RecLock("SZE",.T.)
			    SZE->ZE_FILIAL	:= xFilial("SZE")
			    SZE->ZE_CLIENTE	:= cCli
			    SZE->ZE_LOJA	:= cLoja
			    SZE->ZE_FREQUEN	:= cFrequen
			    SZE->ZE_CHAPA	:= cChapa
			    SZE->ZE_ROTA	:= cRota
			    SZE->ZE_MENSAL	:= cMensal
			    SZE->ZE_TIPOPLA	:= cTipoPla
			    SZE->ZE_SEQ		:= cSeq
			    SZE->ZE_FECHAME := cDtFecmto
			    SZE->ZE_ROTAAUX := cRotaAux
	    	    SZE->ZE_SEQAUX := cSeqAux
	    	    SZE->ZE_FRMLEIT := lFrmLeit
	    	    SZE->ZE_FRMSANG := lFrmSang
	    	    
		    	aListb[nI,11] := Recno()
			    SZE->(Msunlock())
				lGravou := .T.
				Exit
			EndIf	
	
		    cRota		:= ""
			cMensal		:= ""
			cSeq		:= ""
			cFrequen	:= ""
		Next nK	
	Next nJ                                                             
	
	cCli		:= ""
	cLoja		:= ""
	cChapa		:= ""
	cTipoPla	:= ""
	lFrmLeit	:= .F.
	lFrmSang	:= .F.                                                             
Next nI

lAlterou := .F.

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkDia    บAutor  ณJackson E. de Deus  บ Data ณ  18/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se o dia esta sendo usado                          บฑฑ
ฑฑบ          ณExclusao de dias do calendario principal                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkDia(nPos,nPosExc)

Local lUsado := .F.
Local lAchou := .F.                          
Local nX := 0
Local nY := 0
                                             
For nX := 1 to len(aListb)
	If lAchou
		Exit
	EndIf
	If Alltrim(aListb[nX,01]) == Alltrim(aList1[oList1:nAt,01]) .And. AllTrim(aListb[nX,02]) <> ""
		If nX == nPosExc
			Loop
		EndIf
		For nY := 3 To 10
			cAux := aListb[nX,nY,09]
			If SubStr(cAux,nPos,1) $ "1|F"  
				lUsado := .T.
				lAchou := .T.
				Exit
			EndIf
		Next nY
	EndIf
Next nX

Return lUsado


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTOPER01  บAutor  ณMicrosiga           บ Data ณ  09/21/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RepPl()
                
Local aRet := {}
Local aPergs := {}
Local nOpca := 0
Local lTodas := .F.
Local cRotaIni := ""
Local cRotaAte := ""
Local cSql := ""
Local aDias := { {},{},{},{},{},{} } 
Local aMapaMes := { {},{},{},{},{},{} }
Local aMapaMes2 := { {},{},{},{},{},{} } 
Local aMap := {}
Local nSemana := 1
Local aSemInc := {}
Local aAuxSem := {}
Local aAuxInf := {}
Local nUltDia := 0 
Local nPos := 0 
Local cAno :=  SubStr( DtoS(dDatabase),1,4)                   
Local cMes := SubStr( DtoS(dDatabase),5,2) 
Local cDiaIni := StrZero( Day(FirstDay(dDatabase)),2 )
Local cDiaFim := StrZero( Day(LastDay(dDatabase)),2 )
Local nI
Local nJ
Local nK
Local nX
Local aRT := {}
Local aR0 := {}

nOpca := Aviso("Replica็ใo","Essa rotina tem o objetivo de replicar os planos de trabalho do m๊s atual para o m๊s seguinte.";
				+CRLF + "Configure as rotas desejadas na tela seguinte.";
				+CRLF + "Caso o plano de trabalho jแ exista no m๊s seguinte, serแ substituํdo.";
				+CRLF + "Deseja continuar?",{"Sim","Nใo"},3)
If nOpca == 2
	Return
EndIf

aAdd(aPergs ,{1,"Rota De"	,space(TamSx3("ZZ1_COD")[1]),"@!",".T.","ZZ1",".T.",60,.F.})
aAdd(aPergs ,{1,"Rota At้"	,space(TamSx3("ZZ1_COD")[1]),"@!",".T.","ZZ1",".T.",60,.F.})
aAdd(aPergs ,{4,"Todas",.F.,"",90,"",.F.})

If !ParamBox(aPergs ,"Escolha de Rota",@aRet)
	Return                                     
Else
	If aRet[3]
		lTodas := .T.
	Else
		If UPPER(aRet[1]) == "ZZZZZZ"
			aRet[1] := Space(6)
		EndIf
		cRotaIni := aRet[1]
		If Empty(aRet[2])
			aRet[2] := "ZZZZZZ"
		EndIf                  
		cRotaAte := aRet[2]	
	EndIf
EndIf

// semana/dias do mes atual
For dDia := FirstDay(dDatabase) To LastDay(dDatabase)
	If Dow(dDia) == 1
		nSemana++
	EndIf        
	
	AADD( aMapaMes[nSemana], { Dow(dDia), Day(dDia), {} } )
Next dDia

// semana/dias do mes seguinte
dNovoMes := LastDay(dDatabase)+1
nSemana := 1
For dDia := FirstDay(dNovoMes) To LastDay(dNovoMes)
	If Dow(dDia) == 1
		nSemana++
	EndIf        
	
	AADD( aMapaMes2[nSemana], { Dow(dDia), Day(dDia),{} } )
Next dDia

// semanas mes seguinte
For nX := 5 To 6
	If Len(aMapaMes2[nX]) < 7 .And. !Empty(aMapaMes2[nX])
		AADD( aSemInc, nX )
	EndIf
Next nX

// consulta 1 - registros do mes atual SZE
cQuery := "SELECT * FROM " +RetSqlName("SZE") + " WHERE SUBSTRING(ZE_MENSAL,1,6)='"+substr( dtos(dDataBase),1,6 )+"' AND D_E_L_E_T_ = '' "
cQuery += "AND ZE_TIPOPLA <> '' "

If !lTodas
	cQuery += "AND ZE_ROTA BETWEEN '"+cRotaIni+"' AND '"+cRotaAte+"' "
EndIf

cQuery += "ORDER BY ZE_CHAPA "
If Select("TRB") > 0
	TRB->( dbCloseArea() )
EndIf                    
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)  
dbSelectArea("TRB")
While !EOF()

	If SubStr( TRB->ZE_ROTA,1,2 ) == "RT"
		AADD( aRT, { TRB->R_E_C_N_O_ } )
	ElseIf SubStr( TRB->ZE_ROTA,1,2 ) == "R0"
		AADD( aR0, { TRB->R_E_C_N_O_ } )
	EndIf

	dbSkip()
End

// replicacao dia mes - ja grava SZE - SZR depois
nDiasMes2 := LastDay(dNovoMes) - FirstDay(dNovoMes) +1
For nI := 1 To Len(aRT)
	dbSelectArea("SZE")
	dbGoTo(aRT[nI][1])
	
	cCodFil		:= SZE->ZE_FILIAL
	cCodCli		:= SZE->ZE_CLIENTE
	cLoja		:= SZE->ZE_LOJA
	cFreq		:= SZE->ZE_FREQUEN
	cPatrimo	:= SZE->ZE_CHAPA
	cRota		:= SZE->ZE_ROTA	
	cAux2		:= SZE->ZE_MENSAL
	cTpPla		:= SZE->ZE_TIPOPLA
	cSeq		:= SZE->ZE_SEQ
	cRotaAx		:= SZE->ZE_ROTAAUX
	cSeqAx		:= SZE->ZE_SEQAUX
	cTabela		:= SZE->ZE_TABELA
	        
	// tratamento pra gambiarra de mais de uma rota no mesmo dia
	If !Empty(SZE->ZE_ROTAAUX)                                  
		//AADD( aR0,  )
	EndIf 
	
	cNovoMes := SubStr(dtos(dNovoMes),1,4) +SubStr(dtos(dNovoMes),5,2)
	cNovoMes += SZE->ZE_FREQUEN
	                            
	cAuxMensal	:= AllTrim( SubStr( SZE->ZE_MENSAL, 9) )
	nDiasMes	:= Len(cAuxMensal)
	
	cAux := ""
	nPos := 0
	For nX := FirstDay(dNovoMes) To LastDay(dNovoMes)           
		If Day(nX) <= nDiasMes
			nPos++
			cChar := SubStr( cAuxMensal, nPos, 1) 
			
			// Dia marcado
			If cChar <> "0"
				If SubStr( TRB->ZE_TIPOPLA,1,1 ) == "1"
					If Dow(nX) == 1 .Or. Dow(nX) == 7
						cAux += "0"
						cAux += cChar
						nX++
						Loop
					Else
						dDiaAux := DataValida(nX,.T.)
						If dDiaAux > nX
							cAux += "0"
							cAux += cChar
							nX++
							Loop
						EndIf
					EndIf
				EndIf    
						
				cAux += cChar
				
			// Dia nao marcado
			Else
				cAux += cChar
			EndIf
		Else
			For nY := Day(nX) To nDiasMes2
				cAux += "0"
			Next nY
			Exit
		EndIf
	Next nX
	
	cAux2 := cNovoMes +cAux
	            
	If !ExSZE(cCodFil,cCodCli,cLoja,cPatrimo,cRota,cTpPla, substr( dtos(dDataBase),1,6 ))
		RecLock("SZE",.T.)
	Else
		RecLock("SZE",.F.)
	EndIf
	// grava SZE
	SZE->ZE_FILIAL	:= cCodFil
	SZE->ZE_CLIENTE	:= cCodCli
	SZE->ZE_LOJA	:= cLoja
	SZE->ZE_FREQUEN	:= cFreq
	SZE->ZE_CHAPA	:= cPatrimo
	SZE->ZE_ROTA	:= cRota
	SZE->ZE_MENSAL	:= cAux2
	SZE->ZE_TIPOPLA := cTpPla
	SZE->ZE_SEQ		:= cSeq
	SZE->ZE_ROTAAUX	:= cRotaAx
	SZE->ZE_SEQAUX	:= cSeqAx
	//SZE->ZE_TABELA	:= cTabela

	SZE->(MsUnLock())
	CONOUT("CHAPA: " +SZE->ZE_CHAPA +" -> " +cAux2)
Next nI

	
// consulta SZR
cSql := "SELECT * FROM " +RetSqlName("SZR") 
cSql += " WHERE ZR_ROTA BETWEEN '"+cRotaIni+"' AND '"+cRotaAte+"' AND ZR_ANO = '"+cAno+"' "
cSql += " AND ZR_MES = '"+cMes+"' AND ZR_DIA BETWEEN '"+cDiaIni+"' AND '"+cDiaFim+"' "
cSql += " AND D_E_L_E_T_ = '' AND ZR_HORA <> '' AND ZR_TIPOPLA <> '' "
cSql += " ORDER BY ZR_DIA, ZR_HORA"
If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf
                       
TcQuery cSql New Alias "TRB"

dbSelectArea("TRB")
While !EOF()
          
    // Rota Abastecimento - calculo por semanas
    If SubStr( TRB->ZR_ROTA,1,2 ) == "R0"	// aMapaMes aMapaMes2
	    For nI := 1 To Len(aMapaMes)
	    	For nJ := 1 To Len(aMapaMes[nI])
	    		//If aMapaMes[nI][nJ][2] == Val(TRB->ZR_DIA)
	    		If aMapaMes[nI][nJ][1] == Val(TRB->ZR_DIASEMA)
	    			AADD( aMapaMes[nI][nJ][3], { TRB->ZR_CHAPA, TRB->ZR_HORA, TRB->R_E_C_N_O_ } )
    				//AADD( aMapX, { TRB->ZR_CHAPA, TRB->ZR_HORA, TRB->R_E_C_N_O_ } )
	    		EndIf
	    	Next nJ
	    Next nI
	
	// Rota Sangria - calculo por dia do mes
	ElseIf SubStr( TRB->ZR_ROTA,1,2 ) == "RT"	// aMap 
		AADD( aMap, { TRB->ZR_CHAPA, TRB->ZR_HORA, TRB->R_E_C_N_O_ } )	    
	EndIf
	
	TRB->(dbSkip())
End

// semanal
dDia := dNovoMes
For nI := 1 To Len(aMapaMes)
	nSemana := nI
	
   	For nJ := 1 To Len(aMapaMes[nI])	// dias semana
   		nDia := aMapaMes[nI][nJ][1]
   		aAtend := FmtArr( aMapaMes[nI][nJ][3] )
   		If !Empty(aAtend)
	   		// novo mes
	   		For nK := 1 To Len(aMapaMes2[nSemana])
	   			If aMapaMes2[nSemana][nK][1] == nDia
	   				aMapaMes2[nSemana][nK][3] := ACLONE(aAtend)
	   			EndIf
	   		Next nK
   		EndIf
   	Next nJ
   	
   	// semana incompleta - preencher restante com base na primeira semana
   	If nSemana >= 5 .And. !Empty(aSemInc)
	   	nPos := Ascan( aSemInc, { |x| x == nSemana } )
	   	If nPos > 0
	   		nUltDia := Len(aMapaMes2[nSemana]) +1
	   	
	   		If Len(aMapaMes[1]) == 7
				aAuxSem := Aclone(aMapaMes[1])
			Else
				aAuxSem := Aclone(aMapaMes[2])
	   		EndIf
	   		
			For nK := nUltDia To Len(aAuxSem)
				aAtend := Aclone( aAuxSem[nK][3] )
				If !Empty(aAtend)
					AADD( aMapaMes2[nSemana], { nK, Day(dDia), {} } )
					aMapaMes2[nSemana][nK][3] := ACLONE( aAtend )
					dDia++
				EndIf
			Next nK
		EndIf
	EndIf		 	
Next nI

/*
aDiaCp := {}
For nI := 1 To Len(aMapaMes2)
	nSemana := nI	
	For nJ := 1 To Len(aMapaMes2[nI])
		nDiaMes := aMapaMes2[nI][nJ][2]
		nDiaSem := aMapaMes2[nI][nJ][1]
		aAtend := ACLONE( aMapaMes2[nI][nJ][3] )
		  
	
		For nK := 1 To Len(aAtend)
			// atend[nK][3] recno ZR
			// gravar SZR
			dbSelectArea("SZR")
			dbGoTo(aAtend[nK][3])
			cCodFil		:= SZR->ZR_FILIAL
			cRota		:= SZR->ZR_ROTA
			cCodCli		:= SZR->ZR_CLIENTE
			cLoja		:= SZR->ZR_LOJA
			cPatrimo	:= SZR->ZR_CHAPA
			cAno		:= SUBSTR(DTOS(dNovoMes),1,4)
			cMes		:= SUBSTR(DTOS(dNovoMes),5,2)
			cDia		:= SZR->ZR_DIA
			dData		:= SZR->ZR_DATA
			cHora		:= SZR->ZR_HORA
			cSEq		:= SZR->ZR_SEQ
			cTpPla		:= SZR->ZR_TIPOPLA
			cDiaSem		:= SZR->ZR_DIASEMA
		                 
			dbGoTop()
			dbSetOrder(2)
			If MsSeek( xFilial("SZR") +AvKey(cRota,"ZR_ROTA")+AvKey(cPatrimo,"ZR_CHAPA")+AvKey(cAno,"ZR_ANO")+AvKey(cMes,"ZR_MES")+AvKey(cDia,"ZR_DIA")+AvKey(cSeq,"ZR_SEQ") +Avkey(cTpPla,"ZR_TIPOPLA") )
				RecLock("SZR",.F.)
			Else
				RecLock("SZR",.T.)
			EndIf
	
			SZR->ZR_FILIAL	:= cCodFil
			SZR->ZR_ROTA	:= cRota
			SZR->ZR_CLIENTE := cCodCli
			SZR->ZR_LOJA	:= cLoja
			SZR->ZR_CHAPA	:= cPatrimo
			SZR->ZR_ANO		:= cAno
			SZR->ZR_MES		:= cMes
			SZR->ZR_DIA		:= cDia
			SZR->ZR_DATA	:= dData
			SZR->ZR_HORA	:= cHora
			SZR->ZR_SEQ		:= cSeq
			SZR->ZR_TIPOPLA	:= cTpPla
			SZR->ZR_DIASEMA := cDiaSem
			MsUnLock()
			
			AADD( aDiaCp, { cPatrimo, cDia  } )
		Next nK
	Next nJ
Next nI
*/
// gravar SZE - semanal
// aR0
dbselectArea("SZE")
For nL := 1 To Len(aR0)
	lTem := .F.
	dbGoTo(aR0[nL][1])
	cCodFil		:= SZE->ZE_FILIAL
	cCodCli		:= SZE->ZE_CLIENTE
	cLoja		:= SZE->ZE_LOJA
	cFreq		:= SZE->ZE_FREQUEN
	cPatrimo	:= SZE->ZE_CHAPA
	cRota		:= SZE->ZE_ROTA
	cTpPla		:= SZE->ZE_TIPOPLA
	cSeq		:= SZE->ZE_SEQ
	cRotaAx		:= SZE->ZE_ROTAAUX
	cSeqAx		:= SZE->ZE_SEQAUX
	cTabela		:= SZE->ZE_TABELA
	
	// pega os dias que terao atendimento		
	cNovoMes := SubStr(dtos(dNovoMes),1,4) +SubStr(dtos(dNovoMes),5,2)
	cNovoMes += SZE->ZE_FREQUEN
	cAux := ""
	For nX := FirstDay(dNovoMes) To LastDay(dNovoMes)           			
		If Ascan( aDiaCp, { |x| x[1] == cPatrimo .And. Val(x[2]) == Day(nX) }  ) == 0
			cAux += "0"
		Else
			cAux += "1"
			lTem := .T.
		EndIf
	Next nX            
	If !lTem
		Loop
	EndIf
	cMensal := cNovoMes +cAux
      
    // valida existencia do registro na SZE
    nRecProx := 0 	
	nRecProx:= RecZENew(cPatrimo,cRota,dNovoMes)
	dbselectArea("SZE")
	If nRecProx == 0
		RecLock("SZE",.T.)
	Else
		dbGoTo(nRecProx)
		RecLock("SZE",.F.)
	EndIf
	
	SZE->ZE_FILIAL	:= cCodFil
	SZE->ZE_CLIENTE	:= cCodCli
	SZE->ZE_LOJA	:= cLoja
	SZE->ZE_FREQUEN	:= cFreq
	SZE->ZE_CHAPA	:= cPatrimo
	SZE->ZE_ROTA	:= cRota
	SZE->ZE_MENSAL	:= cMensal	// GRAVAR COM BASE NOS HORARIOS SZR
	SZE->ZE_TIPOPLA := cTpPla
	SZE->ZE_SEQ		:= cSeq
	SZE->ZE_ROTAAUX	:= cRotaAx
	SZE->ZE_SEQAUX	:= cSeqAx
	SZE->ZE_TABELA	:= cTabela

	MsUnLock()
Next nL

// dia mes - SZR
dbSelectArea("SZR")
For nI := 1 To Len(aMap)
	dbGoTo(aMap[nI][3])
	cCodFil		:= SZR->ZR_FILIAL
	cRota		:= SZR->ZR_ROTA
	cCodCli		:= SZR->ZR_CLIENTE
	cLoja		:= SZR->ZR_LOJA
	cPatrimo	:= SZR->ZR_CHAPA
	cAno		:= SUBSTR(DTOS(dNovoMes),1,4)
	cMes		:= SUBSTR(DTOS(dNovoMes),5,2)
	cDia		:= SZR->ZR_DIA
	dData		:= SZR->ZR_DATA
	cHora		:= SZR->ZR_HORA
	cSEq		:= SZR->ZR_SEQ
	cTpPla		:= SZR->ZR_TIPOPLA
	cDiaSem		:= SZR->ZR_DIASEMA

   	dbGoTop()                 
	dbSetOrder(2)
	If DbSeek( xFilial("SZR") +AvKey(cRota,"ZR_ROTA")+AvKey(cPatrimo,"ZR_CHAPA")+AvKey(cAno,"ZR_ANO")+AvKey(cMes,"ZR_MES")+AvKey(cDia,"ZR_DIA")+AvKey(cSeq,"ZR_SEQ") +Avkey(cTpPla,"ZR_TIPOPLA") )
		RecLock("SZR",.F.)
	Else
		RecLock("SZR",.T.)
	EndIf
	
	SZR->ZR_FILIAL	:= cCodFil
	SZR->ZR_ROTA	:= cRota
	SZR->ZR_CLIENTE := cCodCli
	SZR->ZR_LOJA	:= cLoja
	SZR->ZR_CHAPA	:= cPatrimo
	SZR->ZR_ANO		:= cAno
	SZR->ZR_MES		:= cMes
	SZR->ZR_DIA		:= cDia
	SZR->ZR_DATA	:= dData
	SZR->ZR_HORA	:= cHora
	SZR->ZR_SEQ		:= cSeq
	SZR->ZR_TIPOPLA	:= cTpPla
	SZR->ZR_DIASEMA := cDiaSem
	MsUnLock()
Next nI

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVazioZe  บAutor  ณJackson E. de Deus   บ Data ณ  19/10/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se ja existe o registro na tabela SZE             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RecZENew(cPatrimo,cRota,dNovoMes)

Local cSql := ""
Local nRecno := 0

cSql := "SELECT R_E_C_N_O_ ZEREC FROM " +RetSqlName("SZE")
cSql += " WHERE ZE_ROTA = '"+cRota+"' AND ZE_CHAPA = '"+cPatrimo+"' AND ZE_MENSAL LIKE '%"+SubStr(DTOS(dNovoMes),1,6)+"%' AND D_E_L_E_T_ = '' "

If Select("TRBH") > 0
	TRBH->(dbCloseArea())
EndIf                   

TcQuery cSql New Alias "TRBH"

dbSelectArea("TRBH")
If !EOF()
	nRecno := TRBH->ZEREC
EndIf

TRBH->(dbCloseArea())
	
Return nRecno


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFmtArr  บAutor  ณJackson E. de Deus    บ Data ณ  21/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Formata o retorno dos dados                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FmtArr( aDados )

Local aRet := {}           
Local nI

For nI := 1 To Len(aDados)
	AADD( aRet, { aDados[nI][1], aDados[nI][2], aDados[nI][3]  } )
Next nI

Return aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTOPER01  บAutor  ณMicrosiga           บ Data ณ  10/19/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ExSZE(cCodFil,cCodCli,cLoja,cPatrimo,cRota,cTpPla,cMensal)

Local cSql := ""
Local lRet := .F.


cSql := "SELECT COUNT(*) TOTAL FROM " +RetSqlName("SZE")
cSql += " WHERE ZE_FILIAL = '"+cCodFil+"' AND ZE_CLIENTE = '"+cCodCli+"' AND ZE_LOJA = '"+cLoja+"' "
cSql += " AND ZE_CHAPA = '"+cPatrimo+"' AND ZE_ROTA = '"+cRota+"' AND ZE_TIPOPLA = '"+cTpPla+"' "
cSql += " AND ZE_MENSAL LIKE '%"+cMensal+"%' AND D_E_L_E_T_ = '' "

If Select("TRB2") > 0
	TRB2->( dbCloseArea() )
EndIf                    
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB2',.F.,.T.)    

dbSelectArea("TRB2")
If TRB2->TOTAL > 0
	lRet := .T.
EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReplSZE   บAutor  ณJackson E. de Deus  บ Data ณ  12/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณReplicar plano de trabalho                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ReplSZE()
      
Local cQuery := ""
Local cAno :=  SubStr( DtoS(dDatabase),1,4)                   
Local cMes := SubStr( DtoS(dDatabase),5,2) 
Local cAnoAnt := cAno
Local cMesAnt := cMes
Local cNovoMes := ""
Local dAuxMes := ""
Local cAuxMensal := ""
Local nPos := 0
Local cChar := ""
Local cAux := ""
Local aDadosSZE := {}
Local nDiasMes := 0
Local nDiasMes2 := 0
Local nDiferDias := 0
Local dDiaAux
Local nTot := 0
Local aDias1 := {}
Local aDias2 := {}
Local nSemana := 1
Local nDiaSemana := 0
Local lDiaOK := .F.
Local cAux2 := ""
Local nHdl
Local cArqLog := "C:\temp\replicacao.txt"
Local aRet := {}
Local aPergs := {}
Local lTodas := .F.
Local cRotaIni := ""
Local cRotaAte := "" 
Local lLog := .F.

If "JDEUS" $ cUsername
	lLog := .T.
EndIf	       

If lLog
	nHdl := FCreate(cArqLog)
	If nHdl == -1
		MsgInfo("Erro de criacao do arquivo de log:" +Str(Ferror()))
		Return
	EndIf
EndIf
                     
If Month(dDatabase) < 12   
	cMes := Soma1(cMes)
	cNovoMes := cAno + cMes
	dAuxMes := StoD( cAno + cMes + "01" )
Else
	cAno := Soma1(cAno)
	cMes := "01"
	cNovoMes := cAno + cMes
	dAuxMes := StoD( cAno + cMes + "01" )
EndIf


nOpca := Aviso("Replica็ใo","Essa rotina tem o objetivo de replicar os planos de trabalho do m๊s atual para o m๊s seguinte.";
				+CRLF + "Configure as rotas desejadas na tela seguinte.";
				+CRLF + "Caso o plano de trabalho jแ exista no m๊s seguinte, serแ substituํdo.";
				+CRLF + "Deseja continuar?",{"Sim","Nใo"},3)
If nOpca == 2
	Return
EndIf

aAdd(aPergs ,{1,"Rota De"	,space(TamSx3("ZZ1_COD")[1]),"@!",".T.","ZZ1",".T.",60,.F.})
aAdd(aPergs ,{1,"Rota At้"	,space(TamSx3("ZZ1_COD")[1]),"@!",".T.","ZZ1",".T.",60,.F.})
aAdd(aPergs ,{4,"Todas",.F.,"",90,"",.F.})

If !ParamBox(aPergs ,"Escolha de Rota",@aRet)
	Return                                     
Else
	If aRet[3]
		lTodas := .T.
	Else
		If UPPER(aRet[1]) == "ZZZZZZ"
			aRet[1] := Space(6)
		EndIf
		cRotaIni := aRet[1]
		If Empty(aRet[2])
			aRet[2] := "ZZZZZZ"
		EndIf                  
		cRotaAte := aRet[2]	
	EndIf
EndIf

// consulta 1 - registros do mes atual
cQuery := "SELECT * FROM " +RetSqlName("SZE") + " WHERE SUBSTRING(ZE_MENSAL,1,6)='"+substr( dtos(dDataBase),1,6 )+"' AND D_E_L_E_T_ = '' "
cQuery += "AND ZE_TIPOPLA <> '' "

If !lTodas
	cQuery += "AND ZE_ROTA BETWEEN '"+cRotaIni+"' AND '"+cRotaAte+"' "
EndIf

cQuery += "ORDER BY ZE_CHAPA "
If Select("TRB") > 0
	TRB->( dbCloseArea() )
EndIf                    
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.) 
                                                             
// consulta 2 - registros do mes seguinte
cQuery := "SELECT * FROM " +RetSqlName("SZE") + " WHERE SUBSTRING(ZE_MENSAL,1,6)='"+cNovoMes+"' AND D_E_L_E_T_ = '' "
cQuery += "AND ZE_TIPOPLA <> '' "

If !lTodas
	cQuery += "AND ZE_ROTA BETWEEN '"+cRotaIni+"' AND '"+cRotaAte+"' "
EndIf

cQuery += " ORDER BY ZE_CHAPA "
If Select("TRB2") > 0
	TRB2->( dbCloseArea() )
EndIf                    
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB2',.F.,.T.)    

dbSelectArea("TRB2")
While !EOF()
	AADD(aDadosSZE, {TRB2->R_E_C_N_O_, AllTrim(TRB2->ZE_CLIENTE), AllTrim(TRB2->ZE_LOJA), AllTrim(TRB2->ZE_FREQUEN), AllTrim(TRB2->ZE_FECHAME), AllTrim(TRB2->ZE_CHAPA), AllTrim(TRB2->ZE_ROTA), AllTrim(TRB2->ZE_MENSAL), AllTrim(TRB2->ZE_TIPOPLA), AllTrim(TRB2->ZE_SEQ) })
	dbSkip()
End                 
dbCloseArea()

nDiasMes2 := LastDay(dAuxMes) - FirstDay(dAuxMes) +1
aDias2 := DiasSEmana(1,dAuxMes)	// dias semana prox mes
	
dbSelectArea("TRB")
While !EOF()
	nTot++
	dbSkip()
End
ProcRegua(nTot)

aDiasZR := {}


//dbSelectArea("TRB")
TRB->( dbGotop() )
While TRB->( !EOF() )
	//IncProc("Patrim๔nio "+TRB->ZE_CHAPA)
	MsProcTxt("Patrim๔nio " +TRB->ZE_CHAPA)

	lSemana := .F.
	lMes := .F.
	aAxZR := {}
	// ZZ1_TPREPL = TIPO DE REPLICACAO - 1 = SEMANAL | 2 = MENSAL
	If SubStr(TRB->ZE_ROTA,1,2) $ "R0|RA|RC|RJ|RM|RS|RB|RP"
		lSemana := .T.
	ElseIf SubStr(TRB->ZE_ROTA,1,2) == "RT"
		lMes := .T.
	EndIf
	
	lDiaOK		:= .F.
	nPos		:= 0
	cAux		:= ""
	cAux2		:= ""
	cAuxMensal	:= AllTrim( SubStr( TRB->ZE_MENSAL, 9) )
	nDiasMes	:= Len(cAuxMensal)
	nDiferDias	:= nDiasMes2 - nDiasMes
	nSemana		:= 1
	nDiaSemana	:= 0
	aDias1		:= DiasSEmana(2,ddatabase,cAuxMensal)	// dias semana mes atual - com dias marcados ou nao    
	
	// faz a replicacao por dias da semana
	If lSemana
		nDia := 0
		For nI := 1 To Len(aDias2)
			For nJ := 1 To Len(aDias2[nI])
				nDia++
				nD := 0
				nDSem := aDias2[nI][nJ]
				xSem := 0
				lDiaOK := VerDia( aDias1,nI,nDSem,TRB->ZE_FREQUEN,Len(aDias2),@xSem )
				
				If lDiaOK
					cAux += "1"
					If xSem > 0
						nPD1 := Ascan( aDias1[xSem], { |x| x[1] == aDias2[nI][nJ] .And. x[2] } )
						If nPD1 > 0
							nD := Day(aDias1[xSem][nPD1][3])
						EndIf					
					Else
						nPD1 := Ascan( aDias1[nI], { |x| x[1] == aDias2[nI][nJ] .And. x[2] } )
						If nPD1 > 0
							nD := Day(aDias1[nI][nPD1][3])
						EndIf
					EndIf
					
					AADD( aAxZR, { nI, aDias2[nI][nJ], nD, nDia } )	// semana_atu | dia_semana_atu | dia_mes_ant | dia_mes_atu
				Else          
					cAux += "0"
				EndIf
			Next nJ
		Next nI   
	EndIf
	

	// Faz a replicacao por dias do mes
	If lMes		
		For nX := FirstDay(dAuxMes) To LastDay(dAuxMes)                 
			If Day(nX) <= nDiasMes
				nPos++
				cChar := SubStr( cAuxMensal, nPos, 1) 
				
				// Dia marcado
				If cChar <> "0"
					If SubStr( TRB->ZE_TIPOPLA,1,1 ) == "1"
						If Dow(nX) == 1 .Or. Dow(nX) == 7
							cAux += "0"
							cAux += cChar
							nX++
							Loop
						Else
							dDiaAux := DataValida(nX,.T.)
							If dDiaAux > nX
								cAux += "0"
								cAux += cChar
								nX++
								Loop
							EndIf
						EndIf
					EndIf    
							
					cAux += cChar
					
					AADD( aAxZR, { 0, dow(nX), Day(nX), Day(nX) } )	// semana_atu | dia_semana_atu | dia_mes_ant | dia_mes_atu
										
				// Dia nao marcado
				Else
					cAux += cChar
				EndIf
			Else
				For nY := Day(nX) To nDiasMes2
					cAux += "0"
				Next nY
				Exit
			EndIf
		Next nX
	EndIf
	
	cAux2 := cNovoMes +SubStr( TRB->ZE_MENSAL,7,2) +cAux
	If lLog .And. nHdl > 0
		FWrite(nHdl, "Patrimonio: " +TRB->ZE_CHAPA + " Rota: " +TRB->ZE_ROTA +" Mensal: " +cAux2  +CRLF)
	EndIf
    
	// verifica se ja existe o plano de trabalho do patrimonio para o mes seguinte
	nPosRec := aScan(aDadosSZE, { |x|, x[2] == AllTrim(TRB->ZE_CLIENTE) .And. x[3] == AllTrim(TRB->ZE_LOJA) .And. x[6] == AllTrim(TRB->ZE_CHAPA) .And. x[7] == AllTrim(TRB->ZE_ROTA) .And. x[9] == AllTrim(TRB->ZE_TIPOPLA) } )

	// SZE
	If nPosRec > 0
		dbSelectArea("SZE")        
		dbGoTo(aDadosSZE[nPosRec][1])
		RecLock("SZE",.F.)
	   	SZE->ZE_FILIAL	:= TRB->ZE_FILIAL
		SZE->ZE_CLIENTE	:= TRB->ZE_CLIENTE
		SZE->ZE_LOJA	:= TRB->ZE_LOJA
		SZE->ZE_ROTA	:= TRB->ZE_ROTA
		SZE->ZE_CHAPA	:= TRB->ZE_CHAPA
		SZE->ZE_FECHAME	:= TRB->ZE_FECHAME
		SZE->ZE_MENSAL	:= cAux2
		SZE->ZE_TIPOPLA	:= TRB->ZE_TIPOPLA
		SZE->ZE_FREQUEN	:= TRB->ZE_FREQUEN
		SZE->ZE_SEQ		:= TRB->ZE_SEQ
		SZE->ZE_SEQAUX	:= TRB->ZE_SEQAUX
		SZE->ZE_ROTAAUX	:= TRB->ZE_ROTAAUX
		SZE->ZE_TABELA  := TRB->ZE_TABELA
		SZE->ZE_FRMLEIT := IIF( TRB->ZE_FRMLEIT $ "T",.T.,.F. ) //TRB->ZE_FRMLEIT 
		SZE->ZE_FRMSANG := IIF( TRB->ZE_FRMSANG $ "T",.T.,.F. ) //TRB->ZE_FRMSANG
		SZE->( MsUnLock() )
	Else
		dbSelectArea("SZE")
		RecLock("SZE",.T.)
		SZE->ZE_FILIAL	:= TRB->ZE_FILIAL
		SZE->ZE_CLIENTE	:= TRB->ZE_CLIENTE
		SZE->ZE_LOJA	:= TRB->ZE_LOJA
		SZE->ZE_ROTA	:= TRB->ZE_ROTA
		SZE->ZE_CHAPA	:= TRB->ZE_CHAPA
		SZE->ZE_FECHAME	:= TRB->ZE_FECHAME
		SZE->ZE_MENSAL	:= cAux2
		SZE->ZE_TIPOPLA	:= TRB->ZE_TIPOPLA
		SZE->ZE_FREQUEN	:= TRB->ZE_FREQUEN
		SZE->ZE_SEQ		:= TRB->ZE_SEQ
		SZE->ZE_SEQAUX	:= TRB->ZE_SEQAUX
		SZE->ZE_ROTAAUX	:= TRB->ZE_ROTAAUX
		SZE->ZE_TABELA  := TRB->ZE_TABELA
		SZE->ZE_FRMLEIT := IIF( TRB->ZE_FRMLEIT $ "T",.T.,.F. ) //TRB->ZE_FRMLEIT
		SZE->ZE_FRMSANG := IIF( TRB->ZE_FRMSANG $ "T",.T.,.F. ) //TRB->ZE_FRMSANG
		SZE->( MsUnLock() )
	EndIf
	

	// SZR
	dbSelectArea("SZR")
	dbSetOrder(2)
	For nJ := 1 To Len(aAxZR)
		nS := aAxZR[nJ][1]	// semana
		nDS := aAxZR[nJ][2]	// dia_semana_atu
		nD := aAxZR[nJ][3]	// dia_mes_ant
		cDiaAnt := ""
		cDiaAtu := ""
	
		//nPD1 := Ascan( aDias1[nS], { |x| x[1] == nDS .And. x[2] } )
		//If nPD1 > 0
			//nD := Day(aDias1[nS][nPD1][3])
		If nD > 0	
			cDiaAnt := PadL(nD,2,"0")

			// semana - dia_semana					
			If lSemana
				cDiaAtu := PadL(aAxZR[nJ][4],2,"0")
			// mes - dia_mes x dia_mes	
			ElseIf lMes
				cDiaAtu := cDiaAnt
			EndIf
			
			// mes anterior
			If DbSeek( TRB->ZE_FILIAL +AvKey(TRB->ZE_ROTA,"ZR_ROTA")+AvKey(TRB->ZE_CHAPA,"ZR_CHAPA")+AvKey(cAnoAnt,"ZR_ANO")+AvKey(cMesAnt,"ZR_MES")+AvKey(cDiaAnt,"ZR_DIA") +AvKey(TRB->ZE_SEQ,"ZR_SEQ") +Avkey(TRB->ZE_TIPOPLA,"ZR_TIPOPLA")  )
				cHora := SZR->ZR_HORA
				            
				// mes novo
				If DbSeek( TRB->ZE_FILIAL +AvKey(TRB->ZE_ROTA,"ZR_ROTA")+AvKey(TRB->ZE_CHAPA,"ZR_CHAPA")+AvKey(cAno,"ZR_ANO")+AvKey(cMes,"ZR_MES")+AvKey(cDiaAtu,"ZR_DIA") +AvKey(TRB->ZE_SEQ,"ZR_SEQ") +Avkey(TRB->ZE_TIPOPLA,"ZR_TIPOPLA")  )					
					RecLock("SZR",.F.)
				Else                  
					RecLock("SZR",.T.)
				EndIf

				SZR->ZR_FILIAL	:= TRB->ZE_FILIAL
				SZR->ZR_ROTA	:= TRB->ZE_ROTA
				SZR->ZR_CHAPA	:= TRB->ZE_CHAPA
				SZR->ZR_CLIENTE	:= TRB->ZE_CLIENTE
				SZR->ZR_LOJA	:= TRB->ZE_LOJA
				SZR->ZR_ANO		:= cAno
				SZR->ZR_MES		:= cMes
				SZR->ZR_DIA		:= cDiaAtu
				SZR->ZR_DATA	:= stod(cNovoMes+cDiaAtu)
				SZR->ZR_HORA	:= cHora
				SZR->ZR_SEQ		:= TRB->ZE_SEQ
				SZR->ZR_TIPOPLA	:= TRB->ZE_TIPOPLA 
				SZR->ZR_DIASEMA := CVALTOCHAR(dow(stod(cNovoMes+cDiaAtu)))
				
				SZR->(MsUnLock())
			EndIf
			
			
			// seq Aux
			aAxSq := {}
			aAux := {}
			axSEQ := {}
			cSeq := "" 
			cRota := ""
		
			// Residente - Mais de um atendimento para o mesmo patrimonio e mesmo residente                         
			If !Empty(TRB->ZE_SEQAUX)
				If AllTrim(TRB->ZE_FREQUEN) $ "2D|3D" .And. Empty(TRB->ZE_ROTAAUX)
					aAxSq := StrToKarr( TRB->ZE_SEQAUX, "/" )
					If Len(aAxSq) > 0
						For nX := 1 To Len(aAxSq)
							AADD( axSEQ, aAxSq[nX] )
						Next nX
					EndIf	
		
					For nX := 1 To Len(axSEQ)
						cSeq := axSEQ[nX]
						// mes anterior
						If DBSeek( TRB->ZE_FILIAL +AvKey(TRB->ZE_ROTA,"ZR_ROTA")+AvKey(TRB->ZE_CHAPA,"ZR_CHAPA")+AvKey(cAnoAnt,"ZR_ANO")+AvKey(cMesAnt,"ZR_MES")+AvKey(cDiaAnt,"ZR_DIA") +AvKey(cSeq,"ZR_SEQ") +Avkey(TRB->ZE_TIPOPLA,"ZR_TIPOPLA")  )
							cHora := SZR->ZR_HORA
							            
							// mes novo
							If DbSeek( TRB->ZE_FILIAL +AvKey(TRB->ZE_ROTA,"ZR_ROTA")+AvKey(TRB->ZE_CHAPA,"ZR_CHAPA")+AvKey(cAno,"ZR_ANO")+AvKey(cMes,"ZR_MES")+AvKey(cDiaAtu,"ZR_DIA") +AvKey(cSeq,"ZR_SEQ") +Avkey(TRB->ZE_TIPOPLA,"ZR_TIPOPLA")  )					
								RecLock("SZR",.F.)
							Else                  
								RecLock("SZR",.T.)
							EndIf
			
							SZR->ZR_FILIAL	:= TRB->ZE_FILIAL
							SZR->ZR_ROTA	:= TRB->ZE_ROTA
							SZR->ZR_CHAPA	:= TRB->ZE_CHAPA
							SZR->ZR_CLIENTE	:= TRB->ZE_CLIENTE
							SZR->ZR_LOJA	:= TRB->ZE_LOJA
							SZR->ZR_ANO		:= cAno
							SZR->ZR_MES		:= cMes
							SZR->ZR_DIA		:= cDiaAtu
							SZR->ZR_DATA	:= stod(cNovoMes+cDiaAtu)
							SZR->ZR_HORA	:= cHora
							SZR->ZR_SEQ		:= cSeq
							SZR->ZR_TIPOPLA	:= TRB->ZE_TIPOPLA 
							SZR->ZR_DIASEMA := CVALTOCHAR(dow(stod(cNovoMes+cDiaAtu)))
							
							SZR->(MsUnLock())
						EndIf
					Next nX						
				EndIf
						
				// Residente - Mais de um atendimento para o mesmo patrimonio e residentes diferentes				
				If AllTrim(TRB->ZE_FREQUEN) $ "2D|3D" .And. !Empty(TRB->ZE_ROTAAUX)
					aAxSq := StrToKarr( TRB->ZE_SEQAUX, "/" )
					If Len(aAxSq) > 0
						For nX := 1 To Len(aAxSq)
							AADD( axSEQ, aAxSq[nX] )
						Next nX
					EndIf	
			
					aAux := StrToKarr(TRB->ZE_ROTAAUX,"/")
					For nX := 1 To Len(aAux)
						If Len(axSEQ) >= nX
							cSeq := axSEQ[nX]
						Else
							cSeq := TRB->ZE_SEQ
						EndIf
						
						cRota := aAux[nX]
						
						// mes anterior
						If DbSeek( TRB->ZE_FILIAL +AvKey(cRota,"ZR_ROTA")+AvKey(TRB->ZE_CHAPA,"ZR_CHAPA")+AvKey(cAnoAnt,"ZR_ANO")+AvKey(cMesAnt,"ZR_MES")+AvKey(cDiaAnt,"ZR_DIA") +AvKey(cSeq,"ZR_SEQ") +Avkey(TRB->ZE_TIPOPLA,"ZR_TIPOPLA")  )
							cHora := SZR->ZR_HORA
							            
							// mes novo
							If DbSeek( TRB->ZE_FILIAL +AvKey(cRota,"ZR_ROTA")+AvKey(TRB->ZE_CHAPA,"ZR_CHAPA")+AvKey(cAno,"ZR_ANO")+AvKey(cMes,"ZR_MES")+AvKey(cDiaAtu,"ZR_DIA") +AvKey(cSeq,"ZR_SEQ") +Avkey(TRB->ZE_TIPOPLA,"ZR_TIPOPLA")  )					
								RecLock("SZR",.F.)
							Else                  
								RecLock("SZR",.T.)
							EndIf
			
							SZR->ZR_FILIAL	:= TRB->ZE_FILIAL
							SZR->ZR_ROTA	:= cRota
							SZR->ZR_CHAPA	:= TRB->ZE_CHAPA
							SZR->ZR_CLIENTE	:= TRB->ZE_CLIENTE
							SZR->ZR_LOJA	:= TRB->ZE_LOJA
							SZR->ZR_ANO		:= cAno
							SZR->ZR_MES		:= cMes
							SZR->ZR_DIA		:= cDiaAtu
							SZR->ZR_DATA	:= stod(cNovoMes+cDiaAtu)
							SZR->ZR_HORA	:= cHora
							SZR->ZR_SEQ		:= cSeq
							SZR->ZR_TIPOPLA	:= TRB->ZE_TIPOPLA 
							SZR->ZR_DIASEMA := CVALTOCHAR(dow(stod(cNovoMes+cDiaAtu)))
							
							SZR->(MsUnLock())
						EndIf
					Next nX
				EndIf
			EndIf	
		EndIf			
	Next nJ
			
	dbSelectArea("TRB")
	TRB->( dbSkip() )
End         

TRB->( dbCloseArea() )


If lLog .And. nHdl > 0
	fclose(nHdl)         
EndIf


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkFeriadoบAutor  ณJackson E. de Deus  บ Data ณ  18/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica dias de feriado                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkFeriado(ddia)
           
Local lRet := .F.
Local cQuery := ""

cQuery := "SELECT * FROM " +RetSqlName("SP3") + " WHERE P3_FILIAL = '"+xFilial("SP3")+"' AND P3_DATA = '"+dtos(ddia)+"' AND D_E_L_E_T_ = '' "
If Select("TRBP") > 0
	TRBP->( dbCloseArea() )
EndIf                     

TcQuery cQuery New Alias "TRBP"
dbSelectArea("TRBP")
If !EOF()
	lRet := .T.
EndIf
               
dbCloseArea()

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDiasSEmanaบAutor  ณJackson E. de Deus  บ Data ณ  12/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna os dias das semanas                                 บฑฑ
ฑฑบ          ณ							                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function DiasSEmana(nTipo,dData,cDiasAtu)

Local nSemana := 1
Local nI := 0
Local aDias := { {},{},{},{},{},{} }
Local nPos := 0

// dias semana prox mes
If nTipo == 1
	For nI := FirstDay(dData) To LastDay(dData)            
		AADD( aDias[nSemana], Dow(nI)  )       
		If Dow(nI) == 7
			nSemana++
		EndIf
	Next nI 
	
	//Alexandre
	While len(aDias) > nSemana
		aDel(aDias,len(aDias))
		ASIZE(aDias,LEN(aDias)-1)
	enddo	
// dias semana mes atual com dias marcados ou nao	      
ElseIf nTipo == 2
	For nJ := FirstDay(dData) To LastDay(dData)
		nPos++
		cChar := SubStr( cDiasAtu, nPos, 1)                          
		AADD( aDias[nSemana], { Dow(nJ), IIF(cChar<>"0",.T.,.F.), nJ  } )	//dia_semana | usado | dia_mes
		If Dow(nJ) == 7
			nSemana++
		EndIf
	Next nJ
EndIf

Return aDias


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVerDia    บAutor  ณJackson E. de Deus  บ Data ณ  12/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se o dia informado deve ser utilizado              บฑฑ
ฑฑบ          ณ							                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VerDia(aDias1,nSemana,nDia,cFreq,nTamMes,xSem)

Local lRet := .F.
Local nI := 0              
//Local nPosS	:=	ASCAN( aDias1[nsemana],{|x| cvaltochar(x[1]) = cvaltochar(nDia)} )
/*
If nPosS == 0 .And. nSemana == 1
	nSemana++
ElseIf  nPosS == 0 .And. (nSemana == nTamMes .Or. nSemana > nTamMes)
	nSemana--
EndIf
*/

For nI := 1 To Len(aDias1[nSemana])
	If aDias1[nSemana][nI][1] == nDia
		If aDias1[nSemana][nI][2]
			lREt := .T.
			Exit
		EndIf
	EndIf
Next nI    

// tratamento - quando nao encontrar o dia no mes anterior
// adianta semana ou retrocede semana
If !lRet
	If nSemana == 1
		nSemana++
	ElseIf nSemana >= 5
		nSemana--
	EndIf
	xSem := nSemana
	For nI := 1 To Len(aDias1[nSemana])
		If aDias1[nSemana][nI][1] == nDia
			If aDias1[nSemana][nI][2]
				lRet := .T.
				Exit
			EndIf
		EndIf
	Next nI  
EndIf



Return lRet     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTOPER01  บAutor  ณMicrosiga           บ Data ณ  05/13/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MarkMes(ddia)

Local aArea	:=	GetArea()

oMsCalend2 := Nil
oMsCalend2 := MsCalend():New(016,268,oDlg2,.T.)

oMsCalend2:CtrlRefresh()

//Acoes do Calendario
oMsCalend2:bChange := {|| markd2(oMsCalend2:dDiaAtu,cDias) }

RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณOrdenar  บAutor  ณJackson E. de Deus   บ Data ณ  07/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ordena o array auxiliar que ้ passado para a tela de seq.  บฑฑ
ฑฑบ          ณ Cliente + Loja + Patrimonio                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Ordenar(aAux)

Local nI,nJ,nK
Local aCli := {}
Local aAAAux := {}
Local aAux2 := {}
                          
For nI := 1 To Len(aAux)     
	If aScan( aCli, { |x| AllTrim(x) == AllTrim(aAux[nI][6])+"/" +AllTrim(aAux[nI][7]) } ) > 0
		Loop
	EndIf
	AADD( aCli, aAux[nI][6] +"/" +aAux[nI][7]  )
Next nI

For nI := 1 To Len(aCli)
	For nJ := 1 To Len(aAux)
		If aAux[nJ][6]+"/" +aAux[nJ][7] == aCli[nI]
			AADD( aAAAux, aAux[nJ] )
		EndIf
	Next nJ
	aSort( aAAAux,,,{ |x,y| Val(x[1]) < Val(y[1]) } )
	For nK := 1 To Len(aAAAux)
		AADD( aAux2, aAAAux[nK] )     
	Next nK
	aAAAux := {}
Next nI

aAux := aClone(aAux2)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPatrim  บAutor  ณJackson E. de Deus    บ Data ณ  08/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna os patrimonios da rota e mes                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Patrim(cRota,cMensal)

Local cDescSB1,cTpAux := ""
Local nPos,nPosAx, nI, nJ, nK
Local aAux := {}
Local aAuxX := {}
Local aSeqs := {}    
Local cPos := "" 
Local cDescSB1,cCodCli,cLjCli,cEndCli,cCidade,cUF,cLocFis,cFrequen, cSeq2, cSeq3
Local nQtdAtend := 1

If !Empty(cMensal)
	cMensal := SubStr(cMensal,1,6)	
Else
	cMensal := cvaltochar(year(ddatabase)) +StrZero(month(ddatabase),2)
EndIf   
           
// comparar Rota - Mensal
For nI := 1 To Len(aListb)
	nPos := 0
	cDescSB1 := ""
	For nJ := 3 To 10
		nPos := 0
		cDescSB1 := ""
		For nK := 3 To 8
			nPos := 0
			cDescSB1 := ""
			If aListb[nI][nJ][nK] == cRota
				If Len( aListb[nI][nJ] ) > 8
					If SubStr( AllTrim( aListb[nI][nJ][09] ),1,6 ) == cMensal
						If Len( aListb[nI][nJ] ) > 9
							nPos := aScan( aList1, { |x| AllTrim(x[1]) == AllTrim(aListb[nI][1])  } )
							cCodCli := ""
							cLjCli := ""
							If nPos > 0
								cDescSB1 := AllTrim(aList1[nPos][2])
								cCodCli := AllTrim(aList1[nPos][3])
								cLjCli := Alltrim(aList1[nPos][4])
								cEndCli := AllTrim(aList1[nPos][7])
								cCidade := AllTrim(aList1[nPos][10])
								cFrequen := aListB[nI][nJ][12]
								cUF := AllTrim(aList1[nPos][24])
								cLocFis := AllTrim(aList1[nPos][5])
							EndIf         
							
							nQtdAtend := 1
							aSeqs := {}
							If cFrequen $ "2D#3D"
								If AllTrim(cFrequen) == "2D"
									nQtdAtend := 2
								ElseIf AllTrim(cFrequen) == "3D"
									nQtdAtend := 3
								EndIf
							EndIf
							
							If Ascan( aAux, { |x| x[1] == aListb[nI][1] /*.And. x[3] == aListb[nI][nJ][10]*/ .And. x[4] == aListb[nI][2] } ) == 0
								If nQtdAtend == 1
									AADD( aAux, { aListb[nI][1],;						// patrimonio
												cDescSB1,;								// descricao
												cvaltochar(nI)+"/"+cvaltochar(nJ) ,;	// posicao/sequencia
											 	aListb[nI][2],;							// tipo de servico 
											 	aListb[nI][nJ][10],;					// sequencia
											 	cCodCli,;								// cliente
											 	cLjCli,;								// loja
											 	cEndCli,;								// endereco
											 	cCidade,;								// cidade
											 	cUF,;									// estado
											 	cLocFis,;								// local fisico
											 	"",;									// horario - SEM USO
											 	"",;									// tipos de servico
											 	{},;									// posicoes no aListB para gravar no retorno
											 	SubStr( AllTrim( aListb[nI][nJ][09] ),9 ),;	// mensal do patrimonio/tp servico
											 	{},;												// todos os mensal dos tp servico
											 	cFrequen,;								// frequencia
											 	""})									// seq auxiliar
								Else
									cSeq2 := ""
									cSeq3 := ""
							        cSeq2 := aListb[nI][16]
						        	cSeq3 := aListb[nI][17]
									If AllTrim(cFrequen) == "2D"
										AADD( aSeqs, cSeq2 )
									EndIf 
				                    If AllTrim(cFrequen) == "3D"
				                    	AADD( aSeqs, cSeq2 )
										AADD( aSeqs, cSeq3 )          
									EndIf
									
									AADD( aAux, { aListb[nI][1],;						// patrimonio
												cDescSB1,;								// descricao
												cvaltochar(nI)+"/"+cvaltochar(nJ) ,;	// posicao/sequencia
											 	aListb[nI][2],;							// tipo de servico 
											 	aListb[nI][nJ][10],;					// sequencia
											 	cCodCli,;								// cliente
											 	cLjCli,;								// loja
											 	cEndCli,;								// endereco
											 	cCidade,;								// cidade
											 	cUF,;									// estado
											 	cLocFis,;								// local fisico
											 	"",;									// horario - SEM USO
											 	"",;									// tipos de servico
											 	{},;									// posicoes no aListB para gravar no retorno
											 	SubStr( AllTrim( aListb[nI][nJ][09] ),9 ),;	// mensal do patrimonio/tp servico
											 	{},;												// todos os mensal dos tp servico
											 	cFrequen,;								// frequencia
											 	cSeq2+"|"+cSeq3})						// seq auxiliar
										 	
									For nX := 1 To Len(aSeqs)	 	
										AADD( aAux, { aListb[nI][1],;							// patrimonio
													cDescSB1,;									// descricao
													cvaltochar(nI)+"/"+cvaltochar(nJ) ,;		// posicao/sequencia
												 	aListb[nI][2],;								// tipo de servico 
												 	aSeqs[nX],;									// sequencia
												 	cCodCli,;									// cliente
												 	cLjCli,;									// loja
												 	cEndCli,;									// endereco
												 	cCidade,;									// cidade
												 	cUF,;										// estado
												 	cLocFis,;									// local fisico
												 	"",;										// horario - SEM USO
												 	"",;										// tipos de servico
												 	{},;										// posicoes no aListB para gravar no retorno
												 	SubStr( AllTrim( aListb[nI][nJ][09] ),9 ),;	// mensal do patrimonio/tp servico
												 	{},;										// todos os mensal dos tp servico
												 	cFrequen,;									// frequencia
												 	"SEQAUX|" +cvaltochar(nX)})					// seq auxiliar
									Next nX
								EndIf		 	
							EndIf		 	
						EndIf			 	
					EndIf
				EndIf
			EndIf            
		Next nK
	Next nJ
Next nI

For nI := 1 To Len(aAux)
	nPosAx := Ascan( aAuxX, { |x| x[1] == aAux[nI][1] .And. !aAux[nI][17] $ "2D|3D" } )
	If nPosAx == 0
		AADD(aAuxX, aAux[nI] )
	EndIf
Next nI  

For nI := 1 To Len(aAuxX)
	cTpAux := ""
	aRet := ChkTpServ(aAuxX[nI][1], aAux)
	For nJ := 1 To Len(aRet)
		IIF(nJ<>Len(aRet),cTpAux += aRet[nJ][1] +" - ",cTpAux += aRet[nJ][1])	// pega tipo de servico
		
		AADD( aAuxX[nI][14], aRet[nJ][2] )	// guarda a posicao do aListB e mensal
		AADD( aAuxX[nI][16], aRet[nJ][3] )	// mensal do servico	
	Next nJ
	aAuxX[nI][12] := cTpAux

Next nI

aAux := Aclone(aAuxX)

Return aAux



Static Function ChkTpServ(cPatrim,aAux)

Local aServicos := {}
Local nI

For nI := 1 To Len(aAux)
	If aAux[nI][1] == cPatrim .And. Ascan( aServicos, { |x| x[1] == aAux[nI][4] } ) == 0
		AADD(aServicos, { aAux[nI][4], aAux[nI][3], aAux[nI][15]  } )	// pega tipo de servico, posicao no alistB e mensal
	EndIf
Next nI

For nI := 1 To Len(aServicos)   
	nPos := Val(SubStr( aServicos[nI][1],1,1 ))
	aServicos[nI][1] := aList2[nPos][1]
Next nI

Return aServicos      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณKalend  บAutor  ณJackson E. de Deus    บ Data ณ  08/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMonta o calendario de horarios na tela                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Kalend()

Local cRota := ""
Local aAux := {}
Local aPergs := {}
Local aRet := {}


AAdd(aPergs ,{1,"Rota"	,space(TamSx3("ZZ1_COD")[1]),"@!",".T.","ZZ1",".T.",60,.F.})
If !ParamBox(aPergs ,"Horarios da Rota",@aRet)
	Return                                     
Else
	cRota := aRet[1]	
EndIf

// organiza os patrimonios para a montagem da tela
aAux := Patrim(cRota)

// ordena os patrimonios -> cliente + loja + patrimonio
Ordenar(@aAux)

// tela para ajuste de sequencias dos patrimonios na Rota
U_TTOPER08(aAux,cRota)


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSimular  บAutor  ณJackson E. de Deus   บ Data ณ  22/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณSimulacao da geracao das OS Mobile                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Simular()

Local cRota := ""
Local aPergs := {}
Local aRet := {}

AAdd(aPergs ,{1,"Rota"	,space(TamSx3("ZZ1_COD")[1]),"@!",".T.","ZZ1",".T.",60,.F.})
If !ParamBox(aPergs ,"Simula็ใo",@aRet)
	Return                                     
Else
	cRota := aRet[1]	
EndIf

Processa({ || U_TTOPER02( {cEmpAnt, cFilAnt, cRota, .T.}) },"Aguarde")      

Return
