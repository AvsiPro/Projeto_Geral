#include "totvs.ch"
#include "topconn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROR40  บAutor  ณJackson E. de Deus  บ Data ณ  18/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de apontamentos da Rota				          บฑฑ
ฑฑบ          ณ Somente Sangria/Leitura no momento						  บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณJackson       ณ18/07/14ณ01.00 |Criacao                                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function TTPROR40()

Local oDlg
Local nOpca			:= 0
Local oGrp
Local oBtn1
Local oBtn2
Local nI			:= 0
Local cPerg			:= "TTPROR40"
Private cTpServ		:= ""
Private nColIni		:= 40
Private nColIni2	:= 70                   
Private nLin		:= 25
Private nColFim		:= 3400
Private nColFim2	:= 3360      
Private aCampos		:= {}
Private aDados		:= {}        
Private aApont		:= {}
Private cRota		:= ""	//"R01005" //R01005 //RT0004
Private cData		:= ""	//"20140320"
Private _cDir		:= ""

If cEmpAnt <> "01"
	return
EndIF

ValPerg(cPerg)
Pergunte(cPerg,.T.,"Configure os parโmetros") 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Tela de configuracao 			         	     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DEFINE MSDIALOG oDlg FROM  96,9 TO 310,592 TITLE OemToAnsi("Apontamentos") PIXEL
	@ 18, 6 TO 66, 287 LABEL "" OF oDlg  PIXEL
	@ 29, 15 SAY OemToAnsi("Relat๓rio de apontamentos") SIZE 268, 8 OF oDlg PIXEL
	@ 38, 15 SAY OemToAnsi("") SIZE 268, 8 OF oDlg PIXEL
	@ 48, 15 SAY OemToAnsi("Configure os parametros") SIZE 268, 8 OF oDlg PIXEL
	DEFINE SBUTTON FROM 80, 190 TYPE 5 ACTION Pergunte(cPerg,.T.) ENABLE OF oDlg
	DEFINE SBUTTON FROM 80, 223 TYPE 1 ACTION (oDlg:End(),nOpca:=1) ENABLE OF oDlg
	DEFINE SBUTTON FROM 80, 255 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTER

If nOpca == 1
	If Empty(MV_PAR02)
		Aviso("TTPROR40","Preencha o parametro data!",{"Ok"})
		Return
	EndIf
	
	_cDir := cGetFile(, OemToAnsi("Selecione o diret๓rio de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 
	If Empty(_cDir)
		MsgAlert("Escolha um diret๓rio vแlido!")
		Return
	EndIf

	Processa({ || Imprime()},"Buscando dados...")     
EndIf


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImprime    บAutor  ณJackson E. de Deus บ Data ณ  18/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Faz a impressao do relatorio                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Imprime()

Local nI
Local oExcel := FWMSEXCEL():New()
Local cArqXls := "extrato_rota.xml"
Local cSheet1 := "Relatorio"
Private cCodRota := ""
Private cDescRota := ""
Private cRespRota := ""

cRota := MV_PAR01
cData := DTOS(MV_PAR02)

RetDados()
dbSelectARea("TSQL")
dbGoTop()
If EOF()  
	MsgAlert("Nใo hแ dados.")
	Return
EndIf


oExcel:AddworkSheet(cSheet1) 
oExcel:AddTable (cSheet1,"Relatorio")
oExcel:AddColumn(cSheet1,"Relatorio","Patrim๔nio",1,1)
oExcel:AddColumn(cSheet1,"Relatorio","Modelo",1,1)
oExcel:AddColumn(cSheet1,"Relatorio","Cliente",1,1)
oExcel:AddColumn(cSheet1,"Relatorio","Hora",1,1)	
oExcel:AddColumn(cSheet1,"Relatorio","Lacre Ret Mo",1,1)
oExcel:AddColumn(cSheet1,"Relatorio","Lacre Ret Ce",1,1)
oExcel:AddColumn(cSheet1,"Relatorio","Moeda Ab. 0.05",1,2)
oExcel:AddColumn(cSheet1,"Relatorio","Moeda Ab. 0.10",1,2)
oExcel:AddColumn(cSheet1,"Relatorio","Moeda Ab. 0.25",1,2)
oExcel:AddColumn(cSheet1,"Relatorio","Moeda Ab. 0.50",1,2)
oExcel:AddColumn(cSheet1,"Relatorio","Moeda Ab. 1",1,2) 
oExcel:AddColumn(cSheet1,"Relatorio","Total Troco",1,2)
oExcel:AddColumn(cSheet1,"Relatorio","Bananinha",1,1) 
oExcel:AddColumn(cSheet1,"Relatorio","Lacre Col Mo",1,1) 
oExcel:AddColumn(cSheet1,"Relatorio","Lacre Col Ce",1,1) 
oExcel:AddColumn(cSheet1,"Relatorio","POS",1,2)
oExcel:AddColumn(cSheet1,"Relatorio","Cont Cash",1,2)
oExcel:AddColumn(cSheet1,"Relatorio","Numerador atual",1,2)
oExcel:AddColumn(cSheet1,"Relatorio","Log 1",1,1) 
oExcel:AddColumn(cSheet1,"Relatorio","Log 2",1,1) 
oExcel:AddColumn(cSheet1,"Relatorio","Log 3",1,1) 
oExcel:AddColumn(cSheet1,"Relatorio","Log 4",1,1) 
oExcel:AddColumn(cSheet1,"Relatorio","Log 5",1,1) 
oExcel:AddColumn(cSheet1,"Relatorio","Testes",1,2)
oExcel:AddColumn(cSheet1,"Relatorio","Parcial",1,2) 

For nI := 1 To 25
	oExcel:AddColumn(cSheet1,"Relatorio","Botao " +cvaltochar(nI),1,2)   
Next nI                                                 

          
dbSelectARea("TSQL")
ProcRegua(TSQL->(lastrec()))     
dbGoTop()
While !EOF() 
             
	cIdPOS := ""
	dbSelectArea("ZZN")
	dbSetOrder(3)
	If MSSeek( xFilial("ZZN") +AvKey(TSQL->ZN_PATRIMO,"ZZN_PATRIM") )
		cIdPOS := ZZN->ZZN_IDPDV
	EndIf
	
	dbSelectARea("TSQL")

	oExcel:AddRow(cSheet1,"Relatorio",{ TSQL->ZN_PATRIMO,;
										TSQL->ZN_TIPMAQ,;
										TSQL->ZN_DESCCLI,;
										TSQL->ZN_HORA,;
										TSQL->ZN_LACRMOE,;
										TSQL->ZN_LACRCED,;
										TSQL->ZN_MABAST1,;
										TSQL->ZN_MABAST2,;
										TSQL->ZN_MABAST3,;
										TSQL->ZN_MABAST4,;
										TSQL->ZN_MABAST5,;
										TSQL->ZN_TROCO,;
										TSQL->ZN_BANANIN,;
										TSQL->ZN_LACCMOE,;
										TSQL->ZN_LACCCED,;
										cIdPOS,;
										TSQL->ZN_COTCASH,;
										TSQL->ZN_NUMATU,;
										TSQL->ZN_LOGC01,;
										TSQL->ZN_LOGC02,;
										TSQL->ZN_LOGC03,;
										TSQL->ZN_LOGC04,;
										TSQL->ZN_LOGC05,;
										TSQL->ZN_BOTTEST,;
										TSQL->ZN_PARCIAL,;
										TSQL->ZN_BOTAO01,;
										TSQL->ZN_BOTAO02,;
										TSQL->ZN_BOTAO03,;
										TSQL->ZN_BOTAO04,;
										TSQL->ZN_BOTAO05,;
										TSQL->ZN_BOTAO06,;
										TSQL->ZN_BOTAO07,;
										TSQL->ZN_BOTAO08,;
										TSQL->ZN_BOTAO09,;
										TSQL->ZN_BOTAO10,;
										TSQL->ZN_BOTAO11,;
										TSQL->ZN_BOTAO12,;
										TSQL->ZN_BOTAO13,;
										TSQL->ZN_BOTAO14,;
										TSQL->ZN_BOTAO15,;
										TSQL->ZN_BOTAO16,;
										TSQL->ZN_BOTAO17,;
										TSQL->ZN_BOTAO18,;
										TSQL->ZN_BOTAO19,;
										TSQL->ZN_BOTAO20,;
										TSQL->ZN_BOTAO21,;
										TSQL->ZN_BOTAO22,;
										TSQL->ZN_BOTAO23,;
										TSQL->ZN_BOTAO24,;
										TSQL->ZN_BOTAO25 } )
   
	TSQL->( dbSkip() )
End

TSQL->( dbCloseArea() )


oExcel:Activate()
oExcel:GetXMLFile( _cDir +cArqXls)

If File( _cDir +cArqXls )
	Aviso("TTPROR40","A planilha foi gerada em "+_cDir,{"Ok"})
	If !ApOleClient( "MsExcel" )
		Aviso("TTPROR40", "MsExcel nใo instalado. " +CRLF +"O arquivo estแ localizado em: "+_cDir, {"Ok"} )
	Else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( _cDir +cArqXls )
		oExcelApp:SetVisible(.T.)         
		oExcelApp:Destroy()
	EndIf
EndIf


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetDados    บAutor  ณJackson E. de Deusบ Data ณ  18/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna os dados da pesquisa                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RetDados()

Local cSql := ""
Local nI, nX
Local aAux := {} 
Local nTpForm := ""
Local cResult := ""
Local aRet := {}       
Local cAuxP := ""
Local axPatrim := {}
Local cPatr := MV_PAR03
Local lNovoFrm := .F.

If !Empty(cPatr)
	axPatrim := StrToKarr(cPatr,";")
	For nX := 1 To Len(axPatrim)
		cAuxP += "'" +axPatrim[nX] +"'"
		If nX <> Len(axPatrim)
			cAuxP += ","
		EndIf
	Next nX
EndIf
 
cSql := "SELECT * FROM " +RetSqlName("SZG") +" SZG "
cSql += "INNER JOIN " +RetSqlName("SZN") +" SZN ON "
cSql += "ZN_FILIAL = ZG_FILIAL "
cSql += "AND ZN_NUMOS = ZG_NUMOS "
cSql += "AND ZN_DATA = ZG_DATAFIM "
cSql += "AND SZN.D_E_L_E_T_ = SZG.D_E_L_E_T_ "
cSql += "WHERE ZG_ROTA = '"+cRota+"' AND ZG_DATAFIM = '"+cData+"' AND ZG_STATUS = 'FIOK' AND SZG.D_E_L_E_T_ = '' "

If !Empty(cAuxP)
	cSql += "AND ZG_PATRIM IN ("+cAuxP+") "
EndIf               

cSql += "ORDER BY SZG.R_E_C_N_O_ "
                                                                                                                   

If Select("TSQL") > 0
	TSQL->(dbCloseArea())
EndIf 

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cSql),"TSQL",.F.,.T.) 


Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValPerg  บAutor  ณJackson E. de Deus   บ Data ณ  18/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se existe a pergunta, se nใo existir, cria.       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValPerg(cPerg)
   	PutSx1(cPerg,'01','Rota ?','','','mv_ch0','C',6,0,0,'G','','ZZ1','','','mv_par01',,,'','','','','','','','','','','','','','')
	PutSx1(cPerg,'02','Data ?','','','mv_ch1','D',8,0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')	
	PutSx1(cPerg,'03','Patrimonios ?','','','mv_ch2','C',99,0,0,'G','','','','','mv_par03',,,'','','','','','','','','','','','','','')		
Return