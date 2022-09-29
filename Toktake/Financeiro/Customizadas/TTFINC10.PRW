#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TBICONN.CH'
#include "DBTREE.CH"    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณTTFINC10  ณ Autor ณAlexandre Venancio     ณ Data ณ06/12/2012ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณLocacao   ณFinanceiro        ณContato ณ                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณRotina para aprovacao de borderos de pagamento              ณฑฑ
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
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTFINC10(lRefresh,dDia1,dDia2)
             
Local aArea		:=	GetArea()
Local nApr		:=	0
Private oDlg1,oGrp1,oGrp2,oTree1,oGrp3,oBrw1,oBtn1,oBtn2,oBtn3,oBtn4,oBtn5,oList,oList2,oSay1,oSay2,oSay3,oBtn6
Private aList	:=	{}
Private oNiv1   := LoadBitmap(GetResources(),'br_preto')  
Private oNiv2   := LoadBitmap(GetResources(),'br_vermelho')  
Private oNiv3   := LoadBitmap(GetResources(),'br_amarelo')  
Private oNiv4  	:= LoadBitmap(GetResources(),'br_marrom')       //Controla se o pedido foi alterado ou nao no grid.
Private oNiv5	:= LoadBitmap(GetResources(),'br_verde')       //Controla se o pedido foi alterado ou nao no grid.
Private oNiv6   := LoadBitmap(GetResources(),'br_azul')     
Private oNiv7   := LoadBitmap(GetResources(),'br_pink')     
Private aGet1	:=	{}
Private aGet2 	:= 	{}
Private aNo		:=	{} 
Private aRaiz	:=	{}
Private aAux	:=	{}        
Private cAprv2	:=	GetMV("MV_XAPROV2")
Private cAprvF	:=	GetMV("MV_XAPROVF") 
Private lAprv2	:=	__cuserid $ cAprv2 
Private lAprvF	:=	__cuserid $ cAprvF
Private dData1	:=	If(!Empty(dDia1),dDia1,ctod("  /  /   "))
Private dData2	:=	If(!Empty(dDia2),dDia2,ctod("  /  /   "))
DEFAULT lRefresh := .F.

//Prepare Environment Empresa "01" Filial "01" Tables "SE2,SEA"
                
Aadd(aList,{.T.,'','','','','','','',''}) 
                       
If !lRefresh
	TTFINC99()
endIf


oDlg1      := MSDialog():New( 091,232,566,1156,"Aprova็ใo de Border๔s de Pagamento",,,.F.,,,,,,.T.,,,.T. )

oGrp1      := TGroup():New( 008,008,192,448,"Informa็๕es Gerais",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

	oSay1      := TSay():New( 200,100,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,304,008)
	oSay2      := TSay():New( 216,100,{||""},oDlg1,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,308,008)
	
	oSay3      := TSay():New( 182,16,{||"  Aprovacao 1บ nํvel        Aprova็ใo 2บ nํvel                Aprova็ใo 3บ nํvel                Aprova็ใo 4บ nํvel                Liberado para pagto.             Em Aprova็ใo p/ usuario"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_RED,CLR_WHITE,480,008)
	
	@182,010 BITMAP oNiv1L RESOURCE 'br_preto.bmp' SIZE 7,7.5 OF oDlg1 PIXEL
	@182,070 BITMAP oNiv2L RESOURCE 'br_vermelho.bmp' SIZE 7,7.5 OF oDlg1 PIXEL
	@182,140 BITMAP oNiv3L RESOURCE 'br_amarelo.bmp' SIZE 7,7.5 OF oDlg1 PIXEL 
	@182,210 BITMAP oNiv4L RESOURCE 'br_marrom.bmp' SIZE 7,7.5 OF oDlg1 PIXEL
	@182,280 BITMAP oNiv5L RESOURCE 'br_verde.bmp' SIZE 7,7.5 OF oDlg1 PIXEL
	@182,350 BITMAP oNiv6L RESOURCE 'br_azul.bmp' SIZE 7,7.5 OF oDlg1 PIXEL
		
	oGrp2      := TGroup():New( 020,016,180,140,"Border๔s X Conta",oGrp1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	
	oTree1     := DbTree():New( 034,022,164,134,oGrp2,{||Grid1(val(oTree1:GetCargo()))},,.T.,.F. )
	
	oGrp3      := TGroup():New( 020,144,180,440,"Titulos a serem pagos",oGrp1,CLR_BLACK,CLR_WHITE,.T.,.F. )

	oList := TCBrowse():New(030,148,290,135,, {'','Bco/Tit.','Ag./Natureza','Cta/Fornec.','Bordero/Pedido','Valor Total','Vencto/Aprov'},{10,40,50,60,50,50,60},;
                            oGrp3,,,,{|| NivAprv(If(!"/" $ Alltrim(otree1:getprompt(.t.)),aGet2[oList:nAt,07],aGet1[oList:nAt,07]),If(!"/" $ Alltrim(otree1:getprompt(.t.)),.F.,.T.))},{|| editcol(oList:nAt)},, ,,,  ,,.F.,,.T.,,.F.,,,)

oBtn2      := TButton():New( 212,051,"Aprovar",oDlg1,{||oDlg1:end(nApr:=1)},037,012,,,,.T.,,"",,,,.F. )
oBtn3      := TButton():New( 196,008,"Vis. Pedido",oDlg1,{||VisPC()},037,012,,,,.T.,,"",,,,.F. )
oBtn5      := TButton():New( 196,051,"Aprov. Exce็ใo",oDlg1,{||AprovExc()},037,012,,,,.T.,,"",,,,.F. )  //vistit
oBtn4      := TButton():New( 212,008,"Vis. NF",oDlg1,{||VisNf()},037,012,,,,.T.,,"",,,,.F. )
oBtn1      := TButton():New( 212,411,"Sair",oDlg1,{||oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )

If lAprvF .or. cusername $ "AVENANCIO"
	oBtn6      := TButton():New( 196,411,"Todas Aprov",oDlg1,{|| U_TTFINC22(dData1)},037,012,,,,.T.,,"",,,,.F. )
EndIf

//oBtn2:disable()	

Processa({|| PreAcols()},OemToAnsi("Processando, Aguarde"))

oDlg1:Activate(,,,.T.)
      
If nApr == 1             
	aprovar() 
	u_ttfinc10(.t.,dData1,dData2)
EndIf

RestArea(aArea)                                             

//Reset Environment

Return                     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC10  บAutor  ณMicrosiga           บ Data ณ  12/07/12   บฑฑ
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
                 
Local aArea		:=	GetArea()
Local cQuery
Local nAprov	:= 1 
Local nItens	:= 1

cQuery := "SELECT E2_PORTADO,EA_AGEDEP,EA_NUMCON,E2_NUMBOR,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_NATUREZ,E2_FORNECE,E2_LOJA,E2_NOMFOR,E2_DTNFINC,E2_EMISSAO,E2_VENCTO,E2_VENCREA,E2_VALLIQ,"
cQuery += " E2_VALOR,E2_DESCONT,E2_MULTA,E2_JUROS,E2_ACRESC,E2_DECRESC,E2_SALDO,E2_NUMBOR,E2_VLCRUZ,E2_ORIGEM,E2_USUALIB,E2_FILORIG,E2_XMOTLIB,EA_XAPROV1,EA_XAPROV2,EA_XAPROV3,EA_XAPROV4"
cQuery += "  FROM "+RetSQLName("SE2")+" E2"
cQuery += "  LEFT JOIN "+RetSQLName("SEA")+" EA ON EA_NUMBOR=E2_NUMBOR AND EA_NUM=E2_NUM AND EA_PREFIXO=E2_PREFIXO AND EA_PARCELA=E2_PARCELA AND E2_FORNECE=EA_FORNECE AND E2_LOJA=EA_LOJA AND EA.D_E_L_E_T_=''"
cQuery += " WHERE E2_VENCREA BETWEEN '"+dtos(dData1)+"' AND '"+dtos(dData2)+"'"
cQuery += " AND E2.D_E_L_E_T_=''"
cQuery += " AND E2_NUMBOR<>''"
cQuery += " ORDER BY E2_PORTADO,EA_AGEDEP,EA_NUMCON,E2.E2_NUMBOR,E2.E2_PREFIXO,E2.E2_NUM"                             

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("TTFINC10.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
   
	nAprov := 1
   	
	If !Empty(TRB->EA_XAPROV1)
		nAprov++
	EndIf
	
	If !Empty(TRB->EA_XAPROV2)
		nAprov++
	EndIf       
	
	If !Empty(TRB->EA_XAPROV3)
		nAprov++
	EndIf
    
	If !Empty(TRB->EA_XAPROV4)
		nAprov++                                        
	EndIf

	If Ascan(aRaiz,{|x| x[1]+x[2]+x[3] = TRB->E2_PORTADO+TRB->EA_AGEDEP+TRB->EA_NUMCON}) == 0
		Aadd(aRaiz,{TRB->E2_PORTADO,TRB->EA_AGEDEP,TRB->EA_NUMCON})
	EndIf
	
	If Ascan(aNo,{|x| x[1]+x[2]+x[3]+x[4] = TRB->E2_PORTADO+TRB->EA_AGEDEP+TRB->EA_NUMCON+TRB->E2_NUMBOR}) == 0
		Aadd(aNo,{TRB->E2_PORTADO,TRB->EA_AGEDEP,TRB->EA_NUMCON,TRB->E2_NUMBOR})
	EndIf	
	
	If Ascan(aGet1,{|x| x[1]+x[2]+x[3]+x[4] = TRB->E2_PORTADO+TRB->EA_AGEDEP+TRB->EA_NUMCON+TRB->E2_NUMBOR}) == 0
		Aadd(aGet1,{TRB->E2_PORTADO,TRB->EA_AGEDEP,TRB->EA_NUMCON,TRB->E2_NUMBOR,TRB->E2_VALOR-TRB->E2_DECRESC-TRB->E2_VALLIQ,TRB->E2_VENCREA,nAprov,TRB->EA_XAPROV1,TRB->EA_XAPROV2,TRB->EA_XAPROV3,TRB->EA_XAPROV4})
	Else
		aGet1[Ascan(aGet1,{|x| x[1]+x[2]+x[3]+x[4] = TRB->E2_PORTADO+TRB->EA_AGEDEP+TRB->EA_NUMCON+TRB->E2_NUMBOR}),05] += TRB->E2_VALOR - TRB->E2_DECRESC - TRB->E2_VALLIQ 
	EndIf
   	
   
	Aadd(aGet2,{TRB->E2_PORTADO,TRB->EA_AGEDEP,TRB->EA_NUMCON,TRB->E2_NUMBOR,TRB->E2_PREFIXO,TRB->E2_NUM,nAprov,TRB->E2_PARCELA,TRB->E2_TIPO,;
				TRB->E2_NATUREZ,TRB->E2_FORNECE,TRB->E2_LOJA,TRB->E2_DTNFINC,TRB->E2_EMISSAO,TRB->E2_VENCTO,TRB->E2_VENCREA,TRB->E2_VALOR-TRB->E2_DECRESC-TRB->E2_VALLIQ,;
				TRB->E2_USUALIB,TRB->E2_FILORIG,TRB->E2_ORIGEM,'','',0,TRB->EA_XAPROV1,TRB->EA_XAPROV2,TRB->EA_XAPROV3,TRB->EA_XAPROV4,TRB->E2_XMOTLIB,nItens++})
	DbSkip()
EndDo  

If len(aNo) < 1
	MsgAlert("Nใo foi encontrado nenhum titulo para a data informada","TTFINC10")
	break
	Return
EndIf

For nX := 1 to len(aGet2)
	If Substr(aGet2[nX,20],1,4) != "FINA"
		cQuery := "SELECT TOP 1 D1_PEDIDO,AK_NOME,C7.R_E_C_N_O_ AS REC"
		cQuery += " FROM "+RetSQLName("SD1")+" D1"
		cQuery += " INNER JOIN "+RetSQLName("SC7")+" C7 ON C7_FILIAL=D1_FILIAL AND C7_NUM=D1_PEDIDO AND C7_ITEM=D1_ITEMPC AND C7.D_E_L_E_T_=''"
		cQuery += " LEFT JOIN "+RetSQLName("SCR")+" CR ON CR_FILIAL=C7_FILIAL AND CR_NUM=C7_NUM AND CR_NIVEL='01' AND CR.D_E_L_E_T_=''"
		cQuery += " LEFT JOIN "+RetSQLName("SAK")+" AK ON AK_COD=CR_APROV AND AK_FILIAL=CR_FILIAL AND AK.D_E_L_E_T_=''"
		cQuery += " WHERE D1_FILIAL='"+aGet2[nX,19]+"' AND D1_SERIE='"+aGet2[nX,05]+"' AND D1_DOC='"+aGet2[nX,06]+"'" 
		cQuery += "	AND D1_FORNECE='"+aGet2[nX,11]+"' AND D1_LOJA='"+aGet2[nX,12]+"'"
		cQuery += " AND D1.D_E_L_E_T_=''"
		
		If Select('TRB') > 0
			dbSelectArea('TRB')
			dbCloseArea()
		EndIf
		
		MemoWrite("TTFINC10.SQL",cQuery)
		DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
		
		DbSelectArea("TRB")
		aGet2[nX,21] := TRB->D1_PEDIDO
		aGet2[nX,22] := TRB->AK_NOME
		aGet2[nX,23] := TRB->REC
		
	EndIf
Next nX
 
Arvore()
Grid1(1)

Return     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC10  บAutor  ณMicrosiga           บ Data ณ  12/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Arvore()

Local aArea	:=	GetArea()
Local nX	:=	0
Local cNo	:=	''
Local cUltN	:=	''
Local nCont	:=	1

For nX := 1 to len(aNo)
	If !aNo[nX,1]+aNo[nX,2]+aNo[nX,3] $ cNo
		If nX > 1 
			nCont++
			oTree1:EndTree()                     
		EndIf
		cNo += aNo[nX,1]+aNo[nX,2]+aNo[nX,3]
		oTree1:AddTree(PadR(aNo[nX,1]+" / "+aNo[nX,2]+" / "+aNo[nX,3],100 ), .T.,"folder" , , , , cvaltochar(nCont) )
	EndIf
	
	oTree1:AddTree(PadR(aNo[nX,4],100 ), .F., , , , ,aNo[nX,4] )
	oTree1:EndTree()
	
Next nX
	
RestArea(aArea)

Return                        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC10  บAutor  ณMicrosiga           บ Data ณ  12/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Grid1(nGalho)

Local aArea	:=	GetArea()
Local cAux	:=	otree1:getprompt(.t.) //aRaiz[nGalho,1]+aRaiz[nGalho,2]+aRaiz[nGalho,3]+If(!"/" $ Alltrim(otree1:getprompt(.t.)),otree1:getprompt(.t.),'') //  ,aNo[nGalho,1]+aNo[nGalho,2]+aNo[nGalho,3]+aNo[nGalho,4])
Local cAprv	:=	''
Local cAprv2:=	''
Local lOp

aAux	:=	{}

//		1				2				3			4				5				6		7		8				9
//TRB->E2_PORTADO,TRB->EA_AGEDEP,TRB->EA_NUMCON,TRB->E2_NUMBOR,TRB->E2_PREFIXO,TRB->E2_NUM,.F.,TRB->E2_PARCELA,TRB->E2_TIPO,;
//		10				11				12				13			14				15				16				17
//TRB->E2_NATUREZ,TRB->E2_FORNECE,TRB->E2_LOJA,TRB->E2_DTNFINC,TRB->E2_EMISSAO,TRB->E2_VENCTO,TRB->E2_VENCREA,TRB->E2_VALOR,;
//		18				19				20		 21 22 23	   24				25				26				27
//TRB->E2_USUALIB,TRB->E2_FILORIG,TRB->E2_ORIGEM,'','',0,TRB->EA_XAPROV1,TRB->EA_XAPROV2,TRB->EA_XAPROV3,TRB->EA_XAPROV4

If !"/" $ Alltrim(otree1:getprompt(.t.))                                                                                                                 
	For nX := 1 to len(aGet2)
		If aGet2[nX,04] == cAux
			Aadd(aAux,aGet2[nX])
		EndIf
	Next nX
	oList:SetArray(aAux)
	/*If !Empty(aAux[oList:nAt,len(aAux[oList:nAt])])
		lOp	:=	oNiv7
	ElseIf aAux[oList:nAt,07] == 1
		lOp	:=	oNiv1
	ElseIf aAux[oList:nAt,07] == 2
		lOp	:=	oNiv2
	ElseIf aAux[oList:nAt,07] == 3
		lOp	:=	oNiv3
	ElseIf aAux[oList:nAt,07] == 4
		lOp	:=	oNiv4
	ElseIf aAux[oList:nAt,07] == 5
		lOp	:=	oNiv5
	Else
		lOp	:=	oNiv6
	EndIf */
	//If(aAux[oList:nAt,07]==1,oNiv1,If(aAux[oList:nAt,07]==2,oNiv2,If(aAux[oList:nAt,07]==3,oNiv3,If(aAux[oList:nAt,07]==4,oNiv4,If(aAux[oList:nAt,07]==5,oNiv5,oNiv6))))),;
	oList:bLine := {||{ If(aAux[oList:nAt,07]==1,oNiv1,If(aAux[oList:nAt,07]==2,oNiv2,If(aAux[oList:nAt,07]==3,oNiv3,If(aAux[oList:nAt,07]==4,oNiv4,If(aAux[oList:nAt,07]==5,oNiv5,oNiv6))))),;
						 aAux[oList:nAt,06],; 
	 					 Posicione("SED",1,xFilial("SED")+aAux[oList:nAt,10],"ED_DESCRIC"),;
	 					 Posicione("SA2",1,xFilial("SA2")+aAux[oList:nAt,11]+aAux[oList:nAt,12],"A2_NOME"),;
	                     cvaltochar(aAux[oList:nAt,21]),;
	                     Transform(aAux[oList:nAt,17],"@E 999,999,999.99"),;
	                     aAux[oList:nAt,22]}}
	
	
	oList:refresh()                            
	
Else                             
	For nX := 1 to len(aGet1)
		If Alltrim(aGet1[nX,01]+" / "+aGet1[nX,02]+" / "+aGet1[nX,03]) == Alltrim(cAux)
			Aadd(aAux,aGet1[nX])
		EndIf
	Next nX
	oList:SetArray(aAux)
	oList:bLine := {||{ If(aAux[oList:nAt,07]==1,oNiv1,If(aAux[oList:nAt,07]==2,oNiv2,If(aAux[oList:nAt,07]==3,oNiv3,If(aAux[oList:nAt,07]==4,oNiv4,If(aAux[oList:nAt,07]==5,oNiv5,oNiv6))))),;
						 aAux[oList:nAt,01],; 
	 					 aAux[oList:nAt,02],;
	 					 aAux[oList:nAt,03],;
	                     aAux[oList:nAt,04],;
	                     Transform(aAux[oList:nAt,05],"@E 999,999,999.99"),;
	                     cvaltochar(stod(aAux[oList:nAt,06]))}} 
	                     

	
	oList:refresh()
EndIf 

If !Empty(aGet2[Ascan(aGet2,{|x| x[04] = aAux[oList:nAt,04]}),24])    
	cAprv := "Aprovador 1 "+UsrFullName(aGet2[Ascan(aGet2,{|x| x[04] = aAux[oList:nAt,04]}),24])
	If !Empty(aGet2[Ascan(aGet2,{|x| x[04] = aAux[oList:nAt,04]}),25])                          
		cAprv += " / Aprovador 2 "+UsrFullName(aGet2[Ascan(aGet2,{|x| x[04] = aAux[oList:nAt,04]}),25])
		If !Empty(aGet2[Ascan(aGet2,{|x| x[04] = aAux[oList:nAt,04]}),26])                          
			cAprv2 := "Aprovador 3 "+UsrFullName(aGet2[Ascan(aGet2,{|x| x[04] = aAux[oList:nAt,04]}),26])
			If !Empty(aGet2[Ascan(aGet2,{|x| x[04] = aAux[oList:nAt,04]}),27])                          
				cAprv2 += " / Aprovador 4 "+UsrFullName(aGet2[Ascan(aGet2,{|x| x[04] = aAux[oList:nAt,04]}),27])
			EndIf
		EndIf
	EndIf
	oSay1:SetText(cAprv)
	oSay2:SetText(cAprv2)
Else
	oSay1:SetText("")
	oSay2:SetText("")
EndIf		
 
NivAprv(aAux[oList:nAt,07],.F.)

oDlg1:refresh()

RestArea(aArea)

Return              

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC10  บAutor  ณMicrosiga           บ Data ณ  12/12/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VisPC()

Local aArea			:=	GetArea()   
Local creno			:=	0
Local cLocFil		:=	CFILANT
Local oDlg2,oGrp1,oBrw1,oBtn1,oBtn2,oLista
Local aColsd		:=	{}   
Local nOp			:=	0
Local lSair			:=	.F.  

Private l120Auto 	:=	.F.
PRIVATE nTipoPed 	:=	1 
Private inclui		:=	.F.   
Private cCadastro	:= 'Pedido'
PRIVATE aRotina		:=		{{"Pesquisar","PesqBrw"   , 0, 1, 0, .F. },; //
						   	{"Visualizar",	"A120Pedido", 0, 2, 0, Nil },; //
							{"Incluir","A120Pedido", 0, 3, 0, Nil },; //
							{"Alterar","A120Pedido", 0, 4, 6, Nil },; //
							{"Excluir","A120Pedido", 0, 5, 7, Nil },; //
							{"Copia","A120Copia" , 0, 4, 0, Nil },; //
							{"Imprimir","A120Impri" , 0, 2, 0, Nil },; //
							{"Legenda","A120Legend", 0, 2, 0, .F. },; //
							{"Conhecimento","MsDocument", 0, 4, 0, Nil }} //
							
If len(aAux[oList:nAt]) < 15
	RestArea(aArea)
	Return
EndIf	


If Empty(aAux[oList:nAt,21])
	cQuery := "SELECT DISTINCT D1_FILIAL,D1_PEDIDO,D1_FORNECE,D1_LOJA"
	cQuery += " FROM "+RetSQLName("SE2")+" E2"
	cQuery += " INNER JOIN "+RetSQLName("SD1")+" D1 ON D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_TIPO =E2_XCHNFE AND D1.D_E_L_E_T_=''"
	cQuery += " WHERE E2_FATURA='"+aAux[oList:nAt,06]+"' AND E2_FATPREF='"+aAux[oList:nAt,05]+"' AND E2_TIPOFAT='"+aAux[oList:nAt,09]+"'"
	cQuery += " AND E2.D_E_L_E_T_=''"
	
	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf
	
	MemoWrite("TTFINC10.SQL",cQuery)
	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
	
	DbSelectArea("TRB")
	
	While !EOF()
		Aadd(aColsd,{TRB->D1_FILIAL,TRB->D1_PEDIDO,TRB->D1_FORNECE,TRB->D1_LOJA})
		Dbskip()
	EndDo        
    
	If len(aColsd) > 0 
		While !lSair
			oDlg2      := MSDialog():New( 091,232,324,613,"Nota Aglutinada",,,.F.,,,,,,.T.,,,.T. )
		   	
		   		oGrp1      := TGroup():New( 004,004,084,180,"Selecione o Pedido",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
		
				oLista := TCBrowse():New(016,008,170,070,, {'Filial','Pedido'},{50,90},;
		                            oGrp1,,,,{|| },{|| },, ,,,  ,,.F.,,.T.,,.F.,,,) 
		 		oLista:SetArray(aColsd) 
				oLista:bLine := {||{aColsd[oLista:nAt,01],;
									aColsd[oLista:nAt,02]}}
		
			oBtn1      := TButton():New( 092,048,"Visualizar",oDlg2,{||oDlg2:end(nOp:=oLista:nAt)},037,012,,,,.T.,,"",,,,.F. )
			oBtn2      := TButton():New( 092,100,"Sair",oDlg2,{||oDlg2:end(nOp:=0)},037,012,,,,.T.,,"",,,,.F. )
			
			oDlg2:Activate(,,,.T.)
			
			If nOp > 0 
				DbSelectArea("SC7")
				DbSetOrder(3)
			
				If DbSeek(aColsd[nOp,01]+aColsd[nOp,03]+aColsd[nOp,04]+aColsd[nOp,02])
					CFILANT := 	aColsd[nOp,01]
					creno	:=	Recno()
				
					A120Pedido("SC7",creno,2)  //Visualizacao
					CFILANT	:=	cLocFil
				EndIf
			Else
				lSair := .T. 
			EndIf
		End
		
		
	EndIf

Else
	DbSelectArea("SC7")
	DbSetOrder(3)

	If DbSeek(aAux[oList:nAt,19]+aAux[oList:nAt,11]+aAux[oList:nAt,12]+aAux[oList:nAt,21])
		CFILANT := 	aAux[oList:nAt,19]
		creno	:=	Recno()
	
		A120Pedido("SC7",creno,2)  //Visualizacao
		CFILANT	:=	cLocFil
	EndIf
                  
EndIf
                  
RestArea(aArea)

Return                                                                               

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC10  บAutor  ณMicrosiga           บ Data ณ  12/13/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VisNF()

Local aArea	:=	GetArea()
Local cFAtu	:=	CFILANT
Local oDlg2,oGrp1,oBrw1,oBtn1,oBtn2,oLista
Local aColsd		:=	{}   
Local nOp			:=	0
Local lSair			:=	.F.  

PRIVATE aRotina   := {  { "Pesquisar","Ma460Pesq", 0 , 1},;  //
								{ "Ordem","Ma460Ordem", 0 , 0},; //
								{ "Prep. Doc's","Ma460Nota", 0 , 4},;  //
								{ "Estor.Doc's","Ma461Estor", 0 , 0},; //	
								{ "Visualiza Doc.","Ma461View" , 0 , 2},; //
								{ "Legenda","A461Legend", 0 , 6}}  //	

If len(aAux[oList:nAt]) < 15
	RestArea(aArea)
	Return
EndIf	

If Empty(aAux[oList:nAt,21])
	cQuery := "SELECT DISTINCT F1_FILIAL,F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,F1_TIPO,A2_NREDUZ"
	cQuery += " FROM "+RetSQLName("SE2")+" E2"
	cQuery += " INNER JOIN "+RetSQLName("SF1")+" F1 ON F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO =E2_XCHNFE AND F1.D_E_L_E_T_=''" 
	cQuery += " INNER JOIN "+RetSQLName("SA2")+" A2 ON A2_COD=F1_FORNECE AND A2_LOJA=F1_LOJA AND A2.D_E_L_E_T_=''"
	cQuery += " WHERE E2_FATURA='"+aAux[oList:nAt,06]+"' AND E2_FATPREF='"+aAux[oList:nAt,05]+"' AND E2_TIPOFAT='"+aAux[oList:nAt,09]+"'"
	cQuery += " AND E2.D_E_L_E_T_=''"
	
	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf
	
	MemoWrite("TTFINC10.SQL",cQuery)
	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
	
	DbSelectArea("TRB")
	
	While !EOF()
		Aadd(aColsd,{TRB->F1_FILIAL,TRB->F1_DOC,TRB->F1_SERIE,TRB->F1_FORNECE,TRB->F1_LOJA,TRB->F1_TIPO,TRB->A2_NREDUZ})
		Dbskip()
	EndDo        
    
	If len(aColsd) > 0 
		While !lSair
			oDlg2      := MSDialog():New( 091,232,324,613,"Nota Aglutinada",,,.F.,,,,,,.T.,,,.T. )
		   	
		   		oGrp1      := TGroup():New( 004,004,084,180,"Selecione a Nota",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
		
				oLista := TCBrowse():New(016,008,170,070,, {'Filial','Nota','Serie','Fornecedor'},{15,30,15,50},;
		                            oGrp1,,,,{|| },{|| },, ,,,  ,,.F.,,.T.,,.F.,,,) 
		 		oLista:SetArray(aColsd) 
				oLista:bLine := {||{aColsd[oLista:nAt,01],;
									aColsd[oLista:nAt,02],;
									aColsd[oLista:nAt,03],;
									aColsd[oLista:nAt,07]}}
		
			oBtn1      := TButton():New( 092,048,"Visualizar",oDlg2,{||oDlg2:end(nOp:=oLista:nAt)},037,012,,,,.T.,,"",,,,.F. )
			oBtn2      := TButton():New( 092,100,"Sair",oDlg2,{||oDlg2:end(nOp:=0)},037,012,,,,.T.,,"",,,,.F. )
			
			oDlg2:Activate(,,,.T.)
			
			If nOp > 0 
				dbSelectArea("SF1")
				dbSetOrder(1)   
				CFILANT := aColsd[nOp,01]
				
				If dbSeek(aColsd[nOp,01]+aColsd[nOp,02]+aColsd[nOp,03]+aColsd[nOp,04]+aColsd[nOp,05]+aColsd[nOp,06])
					A103NFiscal("SF1",Recno(),2,.F.,.F.) // Rotina padrใo de visualizacao de NF 
				Else
					MsgAlert("Nใo hแ uma NF lan็ada para este pagamento, somente um titulo financeiro","TTFINC10")
				EndIf
				
				CFILANT := cFAtu
			Else
				lSair := .T. 
			EndIf
		End
		
		
	EndIf

Else

	dbSelectArea("SF1")
	dbSetOrder(1)   
	CFILANT := aAux[oList:nAt,19]
	
	If dbSeek(aAux[oList:nAt,19]+aAux[oList:nAt,06]+aAux[oList:nAt,05]+aAux[oList:nAt,11]+aAux[oList:nAt,12])
		A103NFiscal("SF1",Recno(),2,.F.,.F.) // Rotina padrใo de visualizacao de NF 
	Else
		MsgAlert("Nใo hแ uma NF lan็ada para este pagamento, somente um titulo financeiro","TTFINC10")
	EndIf
	
	CFILANT := cFAtu

EndIf

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC10  บAutor  ณMicrosiga           บ Data ณ  12/13/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VisTit()

Local aArea	:=	GetArea()
Local creno	:=	0

If len(aAux[oList:nAt]) < 15
	RestArea(aArea)
	Return
EndIf	
	
DbSelectArea("SE2")
DbSetOrder(1)
//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA                                                                                               
If DbSeek(xFilial("SE2")+aAux[oList:nAt,05]+aAux[oList:nAt,06]+aAux[oList:nAt,08]+aAux[oList:nAt,09]+aAux[oList:nAt,11]+aAux[oList:nAt,12])
	creno := Recno()
	FA050Visua("SE2",creno,2)   
EndIf

RestArea(aArea)

Return                                                                                                                                                     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC10  บAutor  ณMicrosiga           บ Data ณ  12/17/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function editcol(linha)

Local aArea	:=	GetArea() 
Local lCab	:=	.F. 


If len(aAux[linha]) == 11
	If aAux[linha,07] > 10
		aAux[linha,07] -= 10
	Else
		If lAprvF 
			If aAux[linha,07] < 3
				MsgAlert("Os nํveis anteriores ainda nใo foram liberados.","TTFINC10")                    
				Return                                                                                    
			Else
				If __cuserid == aAux[linha,10] .Or. __cuserid == aAux[linha,11]
					MsgAlert("Seu nํvel jแ encontra-se liberado.","TTFINC10")
					Return
				EndIf
			EndIf 
		ElseIf lAprv2 
			If aAux[linha,07] < 2
				MsgAlert("Os nํveis anteriores ainda nใo foram aprovados.","TTFINC10")
				Return
			ElseIf aAux[linha,07] > 2
				MsgAlert("Seu nํvel jแ encontra-se aprovado.","TTFINC10")
				Return
			EndIf
		Else
			If aAux[linha,07] > 1 
				If !Empty(aAux[linha,08])
					MsgAlert("Seu nํvel jแ encontra-se aprovado.","TTFINC10")
					Return           
				EndIf
			EndIf
		EndIf
		aAux[linha,07] += 10
	EndIf            
	For nX := 1 to len(aGet2)
		If aGet2[nX,01]+aGet2[nX,02]+aGet2[nX,03]+aGet2[nX,04] == aAux[linha,01]+aAux[linha,02]+aAux[linha,03]+aAux[linha,04]
			aGet2[nX,07] := aAux[linha,07]
		EndIf
	Next nX
Else
	If lAprvF 
		If aAux[linha,07] < 3
			MsgAlert("Os nํveis anteriores ainda nใo foram liberados.","TTFINC10")                    
			Return                                                                                    
		Else
			If __cuserid == aAux[linha,26] .Or. __cuserid == aAux[linha,27]
				MsgAlert("Seu nํvel jแ encontra-se liberado.","TTFINC10")
				Return
			EndIf
		EndIf 
	ElseIf lAprv2 
		If aAux[linha,07] < 2
			MsgAlert("Os nํveis anteriores ainda nใo foram aprovados.","TTFINC10")
			Return
		ElseIf aAux[linha,07] > 2
			MsgAlert("Seu nํvel jแ encontra-se aprovado.","TTFINC10")
			Return
		EndIf
	Else
		If aAux[linha,07] > 1 
			If !Empty(aAux[linha,24])
				MsgAlert("Seu nํvel jแ encontra-se aprovado.","TTFINC10")
				Return           
			EndIf
		EndIf
	EndIf

 	aAux[linha,07] := If(aAux[linha,07]>10,aAux[linha,07]-10,aAux[linha,07]+10)
 	For nX := 1 to len(aGet2)
		If aGet2[nX,01]+aGet2[nX,02]+aGet2[nX,03]+aGet2[nX,04] == aAux[linha,01]+aAux[linha,02]+aAux[linha,03]+aAux[linha,04]
			If aGet2[nX,07] > 10
				lCab := .T.
			Else
				lCab := .F. 
			EndIf
		EndIf   
	Next nX 
	
	If lCab
	   //	aGet1[Ascan(aGet1,{|x| x[1]+x[2]+x[3]+x[4] == aAux[linha,01]+aAux[linha,02]+aAux[linha,03]+aAux[linha,04]}),07] -= 10 
	//Else 
		aGet1[Ascan(aGet1,{|x| x[1]+x[2]+x[3]+x[4] == aAux[linha,01]+aAux[linha,02]+aAux[linha,03]+aAux[linha,04]}),07] += 10 
	EndIf
EndIf

oList:refresh()
oDlg1:refresh()

RestArea(aArea)

Return                  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC10  บAutor  ณMicrosiga           บ Data ณ  01/02/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function NivAprv(nNivel,lGrid)

Local aArea	:=	GetArea()  

cAprv	:=	""
cAprv2	:=	""
/*
If nNivel == 1
	If !lAprv2 .And. !lAprvF .And. If(!lGrid .Or. !"/" $ Alltrim(otree1:getprompt(.t.)),Empty(aGet2[oList:nAt,24]),Empty(aGet1[oList:nAt,08]))
		oBtn2:enable()
	Else     
		oBtn2:disable()	
	EndIf		
ElseIf nNivel == 2
	If lAprv2 .And. If(!lGrid .Or. !"/" $ Alltrim(otree1:getprompt(.t.)),Empty(aGet2[oList:nAt,25]),Empty(aGet1[oList:nAt,09]))
		oBtn2:enable()
	Else     
		oBtn2:disable()
	EndIf
ElseIf nNivel == 3
   	If lAprvF .And. If(!lGrid .Or. !"/" $ Alltrim(otree1:getprompt(.t.)),Empty(aGet2[oList:nAt,26]),Empty(aGet1[oList:nAt,10]))
   		oBtn2:enable()
	Else
		oBtn2:disable()
	EndIf
Else
   	If lAprvF .And. If(!lGrid .Or. !"/" $ Alltrim(otree1:getprompt(.t.)),Empty(aGet2[oList:nAt,27]),Empty(aGet1[oList:nAt,11]))
   		oBtn2:enable()
	Else
		oBtn2:disable()
	EndIf
EndIf
*/
If lGrid
	If !Empty(aGet1[oList:nAt,08])    
		cAprv := "Aprovador 1 "+UsrFullName(aGet1[oList:nAt,08])
		If !Empty(aGet1[oList:nAt,09])                          
			cAprv += " / Aprovador 2 "+UsrFullName(aGet1[oList:nAt,09])
			If !Empty(aGet1[oList:nAt,10])                          
				cAprv2 := "Aprovador 3 "+UsrFullName(aGet1[oList:nAt,10])
				If !Empty(aGet1[oList:nAt,11])                          
					cAprv2 += " / Aprovador 4 "+UsrFullName(aGet1[oList:nAt,11])
				EndIf
			EndIf
		EndIf
		oSay1:SetText(cAprv)
		oSay2:SetText(cAprv2)
	Else
		oSay1:SetText("")
		oSay2:SetText("")
	EndIf		
EndIf 
  
oDlg1:refresh()

RestArea(aArea)

Return                                                                          

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC10  บAutor  ณMicrosiga           บ Data ณ  03/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TTFINC99()

Local oDlg1,oSay1,oSay2,oGet1,oGet2,oBtn1,oBtn2
Local nOpc		:=	0

oDlg1      := MSDialog():New( 091,232,310,671,"Parametros",,,.F.,,,,,,.T.,,,.T. )

oSay1      := TSay():New( 020,040,{||"Vencimento De:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oGet1      := TGet():New( 020,104,{|u| If(Pcount()>0,dData1:=u,dData1)},oDlg1,060,008,'',{||If(!empty(dData1),dData2:=dData1,Nil)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oSay2      := TSay():New( 048,040,{||"Vencimento At้:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oGet2      := TGet():New( 047,104,{|u| If(Pcount()>0,dData2:=u,dData2)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

oBtn1      := TButton():New( 076,056,"Pesquisar",oDlg1,{||oDlg1:end(nOpc:=1)},037,012,,,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 076,120,"Cancelar",oDlg1,{||oDlg1:end(nOpc:=0)},037,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)     

If nOpc == 0
	dData1	:=	dDataBase
	dData2	:=	dDataBase
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC10  บAutor  ณMicrosiga           บ Data ณ  04/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function aprovar()

Local aArea	:=	GetArea()
Local cBord	:=	aGet2[01,04]
Local aPas	:=	{} 
Local cMsg	:=	''
Local nPos	:=	0


For nX := 1 to len(aGet2)
	If aGet2[nX,04] == cBord
		If aGet2[nX,07]	< 10 .And. aGet1[Ascan(aGet1,{|x| x[4] = aGet2[nX,04]}),07] > 10 
			aadd(aPas,{aGet2[nX,06],aGet2[nX,04]})
		EndIf
	Else
		cBord := aGet2[nX,04]
		If aGet2[nX,07]	< 10 .And. aGet1[Ascan(aGet1,{|x| x[4] = aGet2[nX,04]}),07] > 10 
			aadd(aPas,{aGet2[nX,06],aGet2[nX,04]})
		EndIf
	EndIf
Next nX

If len(aPas) > 0            
	cMsg := "O(s) seguinte(s) titulo(s) nใo consta(m) como liberado(s)."
	For nX := 1 to len(aPas)
		cMsg += chr(13)+chr(10)+"Titulo "+aPas[nX,01]+" Border๔ "+aPas[nX,02]
	Next nX
	cMsg += chr(13)+chr(10)+"Deseja fazer a libera็ใo parcial deste(s) titulo(s)?"
	If !MsgYesNo(cMsg,"TTFINC10")
		Return
	EndIf	
EndIf

DbSelectArea("SEA")
DbSetOrder(1)
//EA_FILIAL+EA_NUMBOR+EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA                                                                                     
For nX := 1 to len(aGet2)
	IF DbSeek(xFilial("SEA")+aGet2[nX,04]+aGet2[nX,05]+aGet2[nX,06]+aGet2[nX,08]+aGet2[nX,09]+aGet2[nX,11]+aGet2[nX,12])
		If aGet2[nX,07] > 10
			Reclock("SEA",.F.)
			&("SEA->EA_XAPROV"+substr(cvaltochar(aGet2[nX,07]),2,1)) := __cuserid
			SEA->(Msunlock()) 
		Else
			If Ascan(aPas,{|x| x[1]+x[2] == aGet2[nX,06]+aGet2[nX,04]}) > 0 
				Reclock("SEA",.F.)
				DbDelete()
				SEA->(Msunlock())
			EndIf
		EndIf
	EndIf                     
	
Next nX 
//		1				2				3				4				5			6			7			8				9				10				11			
//TRB->E2_PORTADO,TRB->EA_AGEDEP,TRB->EA_NUMCON,TRB->E2_NUMBOR,TRB->E2_VALOR,TRB->E2_VENCREA,nAprov,TRB->EA_XAPROV1,TRB->EA_XAPROV2,TRB->EA_XAPROV3,TRB->EA_XAPROV4

//		1				2				3			4				5				6		7		8				9
//TRB->E2_PORTADO,TRB->EA_AGEDEP,TRB->EA_NUMCON,TRB->E2_NUMBOR,TRB->E2_PREFIXO,TRB->E2_NUM,.F.,TRB->E2_PARCELA,TRB->E2_TIPO,;
//		10				11				12				13			14				15				16				17
//TRB->E2_NATUREZ,TRB->E2_FORNECE,TRB->E2_LOJA,TRB->E2_DTNFINC,TRB->E2_EMISSAO,TRB->E2_VENCTO,TRB->E2_VENCREA,TRB->E2_VALOR,;
//		18				19				20		 21 22 23	   24				25				26				27
//TRB->E2_USUALIB,TRB->E2_FILORIG,TRB->E2_ORIGEM,'','',0,TRB->EA_XAPROV1,TRB->EA_XAPROV2,TRB->EA_XAPROV3,TRB->EA_XAPROV4

DbSelectArea("SE2")
DbSetOrder(1)
For nX := 1 to len(aPas)
    nPos := Ascan(aGet2,{|x| x[6]+x[4] == aPas[nX,01]+aPas[nX,02]})
    If nPos > 0
		If DbSeek(xFilial("SE2")+aGet2[nPos,05]+aGet2[nPos,06]+aGet2[nPos,08]+aGet2[nPos,09]+aGet2[nPos,11]+aGet2[nPos,12])
			Reclock("SE2",.F.)
			SE2->E2_PORTADO	:=	SPACE(3)
			SE2->E2_BCOPAG	:=	SPACE(3)
			SE2->E2_NUMBOR	:=	SPACE(6)
			SE2->(Msunlock())
		EndIf
	EndIf
Next nX

RestArea(aArea)  

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC10  บAutor  ณMicrosiga           บ Data ณ  09/02/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AprovExc()

Local aArea	:=	GetArea()
Local cFAtu	:=	CFILANT
Private aRotina := {{"PESQUISAR"		,"AxPesqui"		,0,1} ,; // pesquisar
		             {"LIBERA PAGTO"	,"U_TELA"		,0,2} ,; // libera pagamento
		             {"LEGENDA"			,"U_Legend"		,0,3} ,; // legenda
		             {"VISUALISAR"		,"U_TELA"		,0,4} ,; // visualizar
		             {"REL. DE DIV."	,"U_TTBLQR001"	,0,5} }  // relat๓rio

If len(aAux[oList:nAt]) < 15
	RestArea(aArea)
	Return
EndIf	

dbSelectArea("SF1")
dbSetOrder(1)   
CFILANT := aAux[oList:nAt,19]

If dbSeek(aAux[oList:nAt,19]+aAux[oList:nAt,06]+aAux[oList:nAt,05]+aAux[oList:nAt,11]+aAux[oList:nAt,12])
	//A103NFiscal("SF1",Recno(),2,.F.,.F.) // Rotina padrใo de visualizacao de NF 
	U_TELA('SF1',Recno(),4)
Else
	MsgAlert("Nใo hแ uma NF lan็ada para este pagamento, somente um titulo financeiro","TTFINC10")
EndIf

CFILANT := cFAtu

RestArea(aArea)

Return