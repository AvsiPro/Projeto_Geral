#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'COLORS.CH' 
#include "tbiconn.ch"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณTTFAT03C  ณ Autor ณAlexandre Venancio     ณ Data ณ21/06/12  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณLocacao   ณ                  ณContato ณ                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Rotina para visualizar romaneios por motorista em aberto.  ณฑฑ
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

User Function TTFAT03C()

Local aArea	:=	GetArea()

Private cMotor	:=	space(6)
Private cNota	:=	space(9)    
Private cNome	:=	""

Private oDlg1,oGrp1,oSay1,oSay3,oGet1,oGet2,oBtn1,oGrp2,oBrw1,oBtn2,oSay4,oSay5
Private oList
Private aList := {}
Private oOk   	:= LoadBitmap(GetResources(),'br_amarelo')       //Controla se o pedido foi alterado ou nao no grid.
Private oNo   	:= LoadBitmap(GetResources(),'br_vermelho')

Aadd(aList,{.T.,"","","",""})

If cEmpAnt <> "01"
	Return
EndIf

//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "FAT" TABLES "SF2"

oDlg1      := MSDialog():New( 091,232,498,708,"Romaneio em aberto por motorista",,,.F.,,,,,,.T.,,,.T. )

	oGrp1      := TGroup():New( 004,008,040,224,"Dados do Motorista",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

	oSay1      := TSay():New( 020,012,{||"Motorista"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)
	oGet1      := TGet():New( 020,040,{|u|If(Pcount()>0,cMotor:=u,cMotor)},oGrp1,048,008,'',{||If(!empty(cMotor),cNome:=Posicione("DA4",1,xFilial("DA4")+cMotor,"DA4_NOME"),cNome:="")},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"DA4","",,)

	oSay3      := TSay():New( 020,092,{||"Nota Fiscal"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oGet2      := TGet():New( 020,124,{|u|If(Pcount()>0,cNota:=u,cNota)},oGrp1,048,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

	oBtn1      := TButton():New( 020,180,"Pesquisar",oGrp1,{||Preacols()},037,012,,,,.T.,,"",,,,.F. )
	    
	oSay5      := TSay():New( 040,060,{||"Romaneio em Aberto                   Romaneio fechado"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,140,008)
	@40, 50  BITMAP oBmp1 RESOURCE 'br_amarelo.bmp' SIZE 7,7.5 OF oDlg1 PIXEL
	@40, 130 BITMAP oBmp2 RESOURCE 'br_vermelho.bmp' SIZE 7,7.5 OF oDlg1 PIXEL
	
	oGrp2      := TGroup():New( 044,008,172,224,"Romaneio",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oList := TCBrowse():New(056,016,200,110,, {'','Romaneio','Data Romaneio','Qtd NF Rom','Qtd Canhotos'},{10,50,40,40,40},;
	                            oGrp2,,,,{|| },{|| visrom(aList[oList:nAt,02],cMotor,cNome)},, ,,,  ,,.F.,,.T.,,.F.,,,)
	oList:SetArray(aList)
	oList:bLine := {||{ If(aList[oList:nAt,01],oOk,oNo),; 
	 					 aList[oList:nAt,02],;
	 					 aList[oList:nAt,03],;
	 					 aList[oList:nAt,04],;
	 					 aList[oList:nAt,05]}}
    
	oSay4      := TSay():New( 175,012,{||cNome},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,124,008)
	
	oBtn2      := TButton():New( 190,092,"Sair",oDlg1,{||oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

//Reset Environment
                      
RestArea(aArea)

Return                        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT03C  บAutor  ณMicrosiga           บ Data ณ  06/21/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Preacols()

Local aArea	:=	Getarea()
Local cQuery

aList := {}

If Empty(cMotor) .And. Empty(cNota)
	MsgAlert("O Motorista ou o N๚mero da Nota Fiscal deve ser preenchido para pesquisa.","TTFAT03C")
	Aadd(aList,{.T.,"","","",""})
	RestArea(aArea)
	Return
EndI

// nota saida 
If _lNfSaida

	cQuery := "SELECT F2_XCARGA,F2_XDTROM,COUNT(*) NF_ROM,(CASE WHEN F2_XRECENT='S' THEN SUM(1) ELSE 0 END ) CANHOTOS,F2_XMOTOR"
	cQuery += " FROM "+RetSQLName("SF2")
	cQuery += " WHERE D_E_L_E_T_='' AND F2_TRANSP='000019' AND ("
	
	If !empty(cMotor)
		cQuery += "SUBSTRING(F2_XMOTOR,1,6)= '"+cMotor+"')" 
	Else            
		cQuery += " F2_XMOTOR IN(SELECT F2_XMOTOR FROM "+RetSQLName("SF2")+" WHERE F2_FILIAL='"+xFilial("SF2")+"' AND F2_DOC='"+cNota+"'))"
	EndIf
	
	cQuery += " GROUP BY F2_XCARGA,F2_XDTROM,F2_XRECENT,F2_XMOTOR"
	
// nota devolucao
Else

	cQuery := "SELECT F1_XCARGA,F1_XDTROM,COUNT(*) NF_ROM,(CASE WHEN F1_XRECENT='S' THEN SUM(1) ELSE 0 END ) CANHOTOS,F1_XMOTOR"
	cQuery += " FROM "+RetSQLName("SF1")
	cQuery += " WHERE D_E_L_E_T_ = ''  AND ("
	
	If !empty(cMotor)
		cQuery += "SUBSTRING(F1_XMOTOR,1,6)= '"+cMotor+"')" 
	Else            
		cQuery += " F1_XMOTOR IN(SELECT F1_XMOTOR FROM "+RetSQLName("SF1")+" WHERE F1_FILIAL='"+xFilial("SF1")+"' AND F1_DOC='"+cNota+"'))"
	EndIf
	
	cQuery += " GROUP BY F1_XCARGA,F1_XDTROM,F1_XRECENT,F1_XMOTOR"

EndIf

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTFAT03C.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB") 

While !EOF()
	Aadd(aList,{If(TRB->NF_ROM-TRB->CANHOTOS==0,.F.,.T.),TRB->F2_XCARGA,cvaltochar(stod(TRB->F2_XDTROM)),cvaltochar(TRB->NF_ROM),cvaltochar(TRB->CANHOTOS),If(empty(cMotor),TRB->F2_XMOTOR,"")})
	DbSkip()
EndDo
                                                                                     
If len(aList) < 1
	Aadd(aList,{.T.,"","","","",""})
EndIf

oList:SetArray(aList)
oList:bLine := {||{ If(aList[oList:nAt,01],oOk,oNo),; 
 					 aList[oList:nAt,02],;
 					 aList[oList:nAt,03],;  
 					 aList[oList:nAt,04],;
 					 aList[oList:nAt,05]}}    
If empty(cMotor)
	If len(aList[1]) > 5
		cNome := aList[1,6]
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
ฑฑบPrograma  ณTTFAT03C  บAutor  ณMicrosiga           บ Data ณ  06/21/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function visrom(cCarga,cMotor,cNome)

Local aArea	:=	GetArea()
Local aNotas	:=	{}      
Local oDlg1,oGrp1,oSay1,oGrp2,oBrw1,oBtn2,oBtn1
Local cQuery

If _lNfSaida

	cQuery := "SELECT F2_XCARGA CARGA,F2_XRECENT ENTREGUE,F2_XDTENTR DTENTR,F2_FILIAL FILIAL,F2_SERIE SERIE,F2_DOC DOC"
	cQuery += " FROM "+RetSQLName("SF2")
	cQuery += " WHERE D_E_L_E_T_='' AND F2_TRANSP='000019'"
	cQuery += " AND F2_XCARGA='"+cCarga+"'"
	cQuery += " ORDER BY F2_DOC"

Else
 
	cQuery := "SELECT F1_XCARGA CARGA,F1_XRECENT ENTREGUE,F1_XDTENTR DTENTR,F1_FILIAL FILIAL,F1_SERIE SERIE,F1_DOC DOC"
	cQuery += " FROM "+RetSQLName("SF1")
	cQuery += " WHERE D_E_L_E_T_='' "
	cQuery += " AND F1_XCARGA='"+cCarga+"'"
	cQuery += " ORDER BY F2_DOC"
	
EndIf

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("TTFAT03C.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB") 

While !EOF()
    Aadd(aNotas,{TRB->DOC,TRB->CARGA,TRB->ENTREGUE,cvaltochar(stod(TRB->DTENTR)),TRB->FILIAL,TRB->SERIE})
	DbSkip()
EndDo


oDlg1      := MSDialog():New( 091,232,498,708,"Romaneio em aberto por motorista",,,.F.,,,,,,.T.,,,.T. )

	oGrp1      := TGroup():New( 004,008,040,224,"Dados do Motorista",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
	
	oSay1      := TSay():New( 020,012,{||"Motorista "+cMotor+" - "+cNome},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,134,008)
   
	oGrp2      := TGroup():New( 044,008,172,224,"Notas X Romaneio",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

	oBrw1 := TCBrowse():New(056,016,200,110,, {'Nota','Romaneio','Canhoto','Dt Entrega'},{40,40,20,40},;
	                            oGrp2,,,,{|| },{|| },, ,,,  ,,.F.,,.T.,,.F.,,,)
	oBrw1:SetArray(aNotas)
	oBrw1:bLine := {||{ aNotas[oBrw1:nAt,01],; 
	 					 aNotas[oBrw1:nAt,02],;
	 					 aNotas[oBrw1:nAt,03],;
	 					 aNotas[oBrw1:nAt,04]}}
	 					 
	oBtn2      := TButton():New( 180,120,"Sair",oDlg1,{||oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )
	oBtn1      := TButton():New( 180,064,"Visualizar NF",oDlg1,{||visnf(aNotas[oBrw1:nAt,01],aNotas[oBrw1:nAt,06],aNotas[oBrw1:nAt,05]) },037,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

RestArea(aArea)

Return             


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT03C  บAutor  ณMicrosiga           บ Data ณ  06/22/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function visnf(nf,serie,fil)

Local aArea	:=	GetArea()

If _lNfSaida
	dbSelectArea("SF2")
	dbSetOrder(1)
	If dbSeek(fil+nf+serie)
		Mc090Visual("SF2",Recno(),2,.F.,.F.) // Rotina padrใo de visualizacao de NF
	EndIf
// nota devolucao
Else 
	dbSelectArea("SF1")
	dbSetOrder(1)
	If MSSeek(xFilial("SF1")+nf+serie+"000001"+"0001")
		dbSelectArea("SD1")
		dbSetOrder(1)                     
		If dbSeek( xFilial("SD1") +AvKey(SF1->F1_DOC,"D1_DOC") +AvKey(SF1->F1_SERIE,"D1_SERIE") +AvKey(SF1->F1_FORNECE,"D1_FORNECE") +AvKey(SF1->F1_LOJA,"D1_LOJA")  )
			A103NFiscal('SF1',SF1->( Recno() ),1)
		EndIf
	EndIf
EndIf	  
	
RestArea(aArea)

return