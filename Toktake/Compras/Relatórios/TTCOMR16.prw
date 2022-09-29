#include "topconn.ch" 
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTCOMR16บAutor  ณJackson E. de Deus    บ Data ณ  13/02/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Pedidos aprovados nใo entregues							  บฑฑ
ฑฑบ          ณ															  บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณJackson	       ณ13/02/15ณ01.00 |Criacao                               ณฑฑ
 ฑฑณJackson	       ณ20/03/15ณ01.01 |Correcao em colunas do relatorio      ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function TTCOMR16()

Local cPerg := "TTCOMR16"
Local lEnd := .F. 
Local oDlg 
Local nOpca := 0
Private aDados := {}
Private aExcel := {}
Private cDir := ""

//If cEmpAnt == "01"
	AjustaSX1(cPerg)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Tela de configuracao do Relatorio			         	     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DEFINE MSDIALOG oDlg FROM  96,9 TO 310,592 TITLE OemToAnsi("Pedidos aprovados nใo entregues") PIXEL
		@ 18, 6 TO 66, 287 LABEL "" OF oDlg  PIXEL
		@ 29, 15 SAY OemToAnsi("Este relatorio ira emitir uma relacao de Pedidos aprovados nใo entregues") SIZE 268, 8 OF oDlg PIXEL
		@ 38, 15 SAY OemToAnsi(" ") SIZE 268, 8 OF oDlg PIXEL
		DEFINE SBUTTON FROM 80, 190 TYPE 5 ACTION Pergunte(cPerg,.T.) ENABLE OF oDlg
		DEFINE SBUTTON FROM 80, 223 TYPE 1 ACTION (oDlg:End(),nOpca:=1) ENABLE OF oDlg
		DEFINE SBUTTON FROM 80, 255 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTER
	
	
	If nOpca == 1
		If Empty(MV_PAR01)
			MV_PAR01 := dDatabase
		EndIf
			
		cDir := AllTrim(MV_PAR02)
		If SubStr(cDir,Len(cDir),1) <> "\"
			cDir += "\"
		EndIf
		
		Processa( { |lEnd| Retdados(@lEnd) },"Buscando dados, aguarde..")
			
		If Len(aExcel) > 0
			Planilha()	      
		EndIf
	EndIf	
//EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetdadosบAutor  ณJackson E. de Deus    บ Data ณ  15/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBusca os dados do relatorio                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Retdados()

Local cSql := ""
Local nCont := 0

cSql := "SELECT DISTINCT C7_NUM,C7_EMISSAO,C7_FORNECE,A2_NOME,C7_DATPRF,CR_DATALIB, "
cSql += "C7_COND,E4_DESCRI,C7_PRODUTO,B1_DESC,B1_XSUBGRT,B2_QATU-B2_RESERVA AS SALDO,C7_QUANT, "
cSql += "C7_PRECO,C7_TOTAL,C7_FILENT,CR_APROV,AK_NOME "
cSql += "FROM " +RetSqlName("SC7") +" C7 "
cSql += "INNER JOIN " +RetSqlName("SB1") +" B1 ON B1_FILIAL='' AND B1_COD=C7_PRODUTO AND B1.D_E_L_E_T_='' "
cSql += "INNER JOIN " +RetSqlName("SA2") +" A2 ON A2_FILIAL='' AND A2_COD=C7_FORNECE AND A2_LOJA=C7_LOJA AND A2.D_E_L_E_T_='' "
cSql += "INNER JOIN " +RetSqlName("SCR") +" CR ON CR_FILIAL=C7_FILIAL AND CR_NUM=C7_NUM  AND CR_STATUS='03' AND CR.D_E_L_E_T_='' "
cSql += "INNER JOIN " +RetSqlName("SB2") +" B2 ON B2_FILIAL=C7_FILIAL AND B2_COD=C7_PRODUTO AND B2_LOCAL=C7_LOCAL AND B2.D_E_L_E_T_='' "
cSql += "LEFT JOIN " +RetSqlName("SAK") +" AK ON AK_FILIAL=' ' AND AK_COD=CR_APROV AND AK.D_E_L_E_T_='' "
cSql += "LEFT JOIN " +RetSqlName("SE4") +" E4 ON E4_FILIAL=' ' AND E4_CODIGO=C7_COND AND E4.D_E_L_E_T_='' "
cSql += "WHERE C7.D_E_L_E_T_=''  AND C7_QUJE<C7_QUANT AND C7_RESIDUO<>'S' "
cSql += "AND C7_EMISSAO>='"+dtos(MV_PAR01)+"' "
cSql += "ORDER BY C7_NUM "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf                  

TcQuery cSql New Alias "TRB"

dbSelectArea("TRB")
TRB->( dbGoTop() )
If TRB->( EOF() )
	MsgInfo("Nใo existem dados para os parโmetros informados.")
	Return
EndIf


While !EOF()
	nCont++
	dbSkip()
End

ProcRegua(nCont)

TRB->( dbGoTop() )
While !EOF()
	IncProc( "Pedido: " +TRB->C7_NUM  )
	
	AADD( aExcel, { TRB->C7_NUM,TRB->C7_FORNECE,STOD(TRB->C7_EMISSAO),TRB->A2_NOME, STOD(TRB->C7_DATPRF), STOD(TRB->CR_DATALIB),;
					TRB->C7_COND, TRB->E4_DESCRI, TRB->C7_PRODUTO, TRB->B1_DESC, TRB->B1_XSUBGRT, TRB->SALDO, TRB->C7_QUANT,;
					TRB->C7_PRECO, TRB->C7_TOTAL, TRB->C7_FILENT, TRB->CR_APROV, TRB->AK_NOME })

	TRB->( dbSkip() )
End

TRB->( dbCloseArea() )
             							      
Return  



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPlanilhaบAutor  ณJackson E. de Deus    บ Data ณ  15/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera a planilha em excel                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Planilha()  

Local oExcel := FWMSEXCEL():New()
Local cTitulo := "Pedidos"
Local cCabeca := "Pedidos"
Local cTime := Time()
Local nI
Local cArqXls := "pedidos_" +SubStr(cTime,1,2) +SubStr(cTime,4,2) +SubStr(cTime,7) +".xml"  

oExcel:AddworkSheet(cTitulo) 
oExcel:AddTable (cTitulo,cCabeca)

oExcel:AddColumn(cTitulo,cCabeca,"Pedido",1,1)
oExcel:AddColumn(cTitulo,cCabeca,"Cod Fornecedor",1,1)
oExcel:AddColumn(cTitulo,cCabeca,"Data emissใo",1,1)
oExcel:AddColumn(cTitulo,cCabeca,"Fornecedor",1,1)  
oExcel:AddColumn(cTitulo,cCabeca,"Data de entrega",1,1) 
oExcel:AddColumn(cTitulo,cCabeca,"Data de libera็ใo",1,1) 
oExcel:AddColumn(cTitulo,cCabeca,"Cond. Pagamento",1,1)  
oExcel:AddColumn(cTitulo,cCabeca,"Desc. Cond.",1,1) 
oExcel:AddColumn(cTitulo,cCabeca,"Cod Produto",1,1)
oExcel:AddColumn(cTitulo,cCabeca,"Desc Produto",1,1)
oExcel:AddColumn(cTitulo,cCabeca,"Subgrupo",1,1)
oExcel:AddColumn(cTitulo,cCabeca,"Saldo",1,1)
oExcel:AddColumn(cTitulo,cCabeca,"Quantidade",1,1)
oExcel:AddColumn(cTitulo,cCabeca,"Pre็o",1,1)
oExcel:AddColumn(cTitulo,cCabeca,"Total",1,1)
oExcel:AddColumn(cTitulo,cCabeca,"Filial entrega",1,1)
oExcel:AddColumn(cTitulo,cCabeca,"Cod. Aprovador",1,1)
oExcel:AddColumn(cTitulo,cCabeca,"Desc. Aprovador",1,1)


For nI := 1 To Len(aExcel)
	oExcel:AddRow( cTitulo,cCabeca, aExcel[nI] )
Next nI
     
oExcel:Activate()

oExcel:GetXMLFile(cDir +cArqXls)

If File(cDir +cArqXls)
	MsgInfo("A planilha foi gerada em "+cDir,"TTCOMR16")
	If !ApOleClient( 'MsExcel' )
		MsgInfo('MsExcel nใo instalado. ' +CRLF +'O arquivo estแ em: '+cDir )
	Else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cDir +cArqXls )
		oExcelApp:SetVisible(.T.)         
		oExcelApp:Destroy()
	EndIf
EndIf  

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSX1  บAutor  ณJackson E. de Deus บ Data ณ  15/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAjusta a pergunta do relatorio                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AjustaSX1(cPerg)


Local aHelp1 := {"Data de emissใo inicial dos pedidos."}
Local aHelp2 := {"Escolha o local para salvar o relat๓rio."}

PutSx1(cPerg,'01','Emissใo de ?','Emissใo de ?' ,'Emissใo de ?','mv_cha','D',8,0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','',aHelp1,aHelp1,aHelp1)
PutSX1(cPerg,"02","Salvar em:","Salvar em:","Salvar em:" ,"mv_chb","C",50,0,0,"G","ExistDir(MV_PAR02)","RETDIR","","S","mv_par02","","","","","","","","","","","","","","","","",aHelp2,aHelp2,aHelp2)     

Return