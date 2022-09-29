#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH' 
#INCLUDE 'TBICONN.CH' 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณTTFINC22  ณ Autor ณ Alexandre Venancio    ณ Data ณ 09/09/13 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณLocacao   ณ                  ณContato ณ                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Rotina para visualizacao de divergencias de recebimento.   ณฑฑ
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

User Function TTFINC22(dia)

Local aArea	:=	GetArea()
SetPrvt("oDlg2","oGrp1","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oGrp2","oBrw1","oBtn1")
Private aList	:=	{}
Private oList
//dia := ctod("10/09/2013")
//Prepare Environment Empresa "11" Filial "01" Tables "SE2,SEA"

Preacols(dia)

oDlg2      := MSDialog():New( 091,232,610,1148,"Libera็๕es de Recebimentos",,,.F.,,,,,,.T.,,,.T. )
   
	oGrp1      := TGroup():New( 004,004,056,448,"Libera็๕es com vencimento em "+dtoc(dia),oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
		oSay1      := TSay():New( 014,148,{||"Border๔"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
		oSay2      := TSay():New( 014,208,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		
		oSay3      := TSay():New( 032,016,{||"Fornecedor"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oSay4      := TSay():New( 032,056,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,284,008)
		
		oSay5      := TSay():New( 032,348,{||"Nota Fiscal"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
		oSay6      := TSay():New( 032,384,{||""},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,056,008)
	
	oGrp2      := TGroup():New( 060,004,224,448,"Itens Divergentes",oDlg2,CLR_BLACK,CLR_WHITE,.T.,.F. )
		//oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{072,012,216,440},,, oGrp2 ) 
		oList := TCBrowse():New(072,012,430,145,, {'Produto','Descricao','Observacao','Valor Pedido','Valor NF','Motivo liberacao'},{35,90,20,45,45,120},;
	                            oGrp2,,,,{|| FHelp(oList:nAt)},{|| },, ,,,  ,,.F.,,.T.,,.F.,,.T.,.T.)
		oList:SetArray(aList)
		oList:bLine := {||{ aList[oList:nAt,04],; 
		 					 aList[oList:nAt,05],;
		 					 aList[oList:nAt,06],;
		                     aList[oList:nAt,07],;
		                     aList[oList:nAt,09],;
		                     aList[oList:nAt,13]}}      
		                     
	oBtn1      := TButton():New( 232,308,"Sair",oDlg2,{||oDlg2:end()},037,012,,,,.T.,,"",,,,.F. )   
	oBtn2      := TButton():New( 232,108,"Planilha",oDlg2,{||Planilha()},037,012,,,,.T.,,"",,,,.F. )   

oDlg2:Activate(,,,.T.)

RestArea(aArea)

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC22  บAutor  ณMicrosiga           บ Data ณ  09/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Preacols(dia)

Local cQuery


cQuery := "SELECT E2_NUMBOR,Z4_CHAVENF,A2_NOME,Z4_PRODUTO,Z4_DESC,Z4_OBS,Z4_VLRCORR,E4.E4_DESCRI AS DESC1,Z4_VLRINF,E42.E4_DESCRI AS DESC2,Z4_TOTDIV,E2_USUALIB,E2_XMOTLIB,"
cQuery += "Z4_DATA,Z4_HORA,Z4_STATUS"
cQuery += " FROM "+RetSQLName("SE2")+" E2"
cQuery += " INNER JOIN "+RetSQLName("SZ4")+" Z4 ON Z4_CHAVENF=E2_FILORIG+E2_NUM+E2_PREFIXO+E2_FORNECE+E2_LOJA+'N' AND Z4_STATUS='2'"
cQuery += " INNER JOIN "+RetSQLName("SA2")+" A2 ON A2_COD=E2_FORNECE AND A2_LOJA=E2_LOJA AND A2.D_E_L_E_T_=''"
cQuery += " LEFT JOIN "+RetSQLName("SE4")+" E4 ON E4.E4_CODIGO=Z4_VLRCORR AND E4.D_E_L_E_T_=''"
cQuery += " LEFT JOIN "+RetSQLName("SE4")+" E42 ON E42.E4_CODIGO=Z4_VLRINF AND E42.D_E_L_E_T_=''"
cQuery += " WHERE E2_VENCREA='"+dtos(dia)+"' AND E2.D_E_L_E_T_=''"
cQuery += " AND E2_NUMBOR<>'' ORDER BY E2_NUMBOR,Z4_CHAVENF"

If Select('TRB') > 0
	dbSelectArea('TRB')
	dbCloseArea()
EndIf

MemoWrite("TTFINC10.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    Aadd(aList,{TRB->E2_NUMBOR,TRB->Z4_CHAVENF,TRB->A2_NOME,TRB->Z4_PRODUTO,TRB->Z4_DESC,Alltrim(TRB->Z4_OBS),;
    			If(SUBSTR(UPPER(TRB->Z4_OBS),1,5)=="CONDI",Alltrim(TRB->Z4_VLRCORR)+" - "+TRB->DESC1,TRB->Z4_VLRCORR),TRB->DESC1,;
    			If(SUBSTR(UPPER(TRB->Z4_OBS),1,5)=="CONDI",Alltrim(TRB->Z4_VLRINF)+" - "+TRB->DESC2,TRB->Z4_VLRINF),;
    			TRB->DESC2,TRB->Z4_TOTDIV,TRB->E2_USUALIB,TRB->E2_XMOTLIB})
	dbskip()
EndDo

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC22  บAutor  ณMicrosiga           บ Data ณ  09/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FHelp(nLinha)

Local aArea	:=	GetArea()
oSay2:settext("")
oSay4:settext("")
oSay6:settext("") 

oSay2:settext(aList[nLinha,01])
oSay4:settext(aList[nLinha,03])
oSay6:settext(SUBSTR(aList[nLinha,02],3,9))

oDlg2:refresh()

RestArea(aArea)

Return                     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC22  บAutor  ณMicrosiga           บ Data ณ  09/10/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Planilha()

Local oExcel := FWMSEXCEL():New()
Local cTitulo := "Liberacoes"
Local cDir := ""
Local cArqXls := "Liberacoes.xml"

cDir := cGetFile(, OemToAnsi("Selecione o diret๓rio de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 

If Empty(cDir)
	Return
EndIf

oExcel:AddworkSheet("Pedidos_Liberados") 

oExcel:AddTable ("Pedidos_Liberados","Pedidos")

oExcel:AddColumn("Pedidos_Liberados","Pedidos","Bordero",1,1)
oExcel:AddColumn("Pedidos_Liberados","Pedidos","NF",1,1)
oExcel:AddColumn("Pedidos_Liberados","Pedidos","Fornecedor",1,1)
oExcel:AddColumn("Pedidos_Liberados","Pedidos","Produto.",1,1)
oExcel:AddColumn("Pedidos_Liberados","Pedidos","Descri็ใo",1,1)                                                                 
oExcel:AddColumn("Pedidos_Liberados","Pedidos","Motivo Bloqueio.",1,1)
oExcel:AddColumn("Pedidos_Liberados","Pedidos","Valor PC",1,1)
oExcel:AddColumn("Pedidos_Liberados","Pedidos","Valor NF",1,1,.T.)
oExcel:AddColumn("Pedidos_Liberados","Pedidos","Usuario Liberacao",1,1)                                                                                                                                                                                                                                                                                                                                      
oExcel:AddColumn("Pedidos_Liberados","Pedidos","Motivo Liberacao",1,1)                                                                 


For nI := 1 To Len(aList)
	oExcel:AddRow("Pedidos_Liberados","Pedidos",{aList[nI][1],; 	//bordero
											aList[nI][2],;		//produto
											aList[nI][3],;		//descricao
											aList[nI][4],;		//OMM inst
											aList[nI][5],;	//Data inst
											aList[nI][6],;	//Data rem
											aList[nI][7],;		//Status
											aList[nI][9],;		//Loja
											aList[nI][12],;		//Local fisico
											aList[nI][13]})		//valor
Next nI

oExcel:Activate()

oExcel:GetXMLFile(cDir +cArqXls)

If File(cDir +cArqXls)
	Aviso("TTFINC22","A planilha foi gerada em "+cDir,{"Ok"})
	If !ApOleClient( 'MsExcel' )
		Aviso("TTFINC22", 'MsExcel nใo instalado. ' +CRLF +'O arquivo estแ em: '+cDir )
	Else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cDir +cArqXls )
		oExcelApp:SetVisible(.T.)         
		oExcelApp:Destroy()
	EndIf
EndIf  


Return