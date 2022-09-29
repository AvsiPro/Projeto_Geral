#include "topconn.ch"
#include "protheus.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFATR50  บAutor  ณJackson E. de Deus  บ Data ณ  23/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Extrato de abastecimento                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTFATR50( cArmazem,dInicio,dFim,cHrInicio )

Local cPerg := "TTFATR50"
Local lEnd := .F.
Local nOpca := 0
Private cDir := ""
Default cArmazem := ""
Default dInicio := stod("")
Default dFim := stod("")
Default cHrInicio := "00:00:00"

If cEmpAnt == "01"
	AjustaSX1(cPerg)
	
	
	If !Empty(cArmazem) .And. !Empty(dInicio) .And. !Empty(dFim)
		MV_PAR01 := cArmazem
		MV_PAR02 := dInicio
		MV_PAR03 := dFim
		cDir := cGetFile(, OemToAnsi("Selecione o diret๓rio de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 
		If !Empty(cDir)                                          
			CursorWait()
			Processa( { |lEnd| Gerar(@lEnd) },"Gerando relatorio, aguarde..")
			CursorArrow()
		Else
			Aviso(cPerg,"Escolha um diret๓rio vแlido.",{"Ok"})
		EndIf
		Return
	EndIf
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Tela de configuracao do Relatorio			         	     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DEFINE MSDIALOG oDlg FROM  96,9 TO 310,592 TITLE OemToAnsi("Extrato de abastecimento") PIXEL
		@ 18, 6 TO 66, 287 LABEL "" OF oDlg  PIXEL
		@ 29, 15 SAY OemToAnsi("Este relatorio ira emitir um extrato de abastecimento da Rota") SIZE 268, 8 OF oDlg PIXEL
		@ 48, 15 SAY OemToAnsi("parametros do relatorio..") SIZE 268, 8 OF oDlg PIXEL
		DEFINE SBUTTON FROM 80, 190 TYPE 5 ACTION Pergunte(cPerg,.T.) ENABLE OF oDlg
		DEFINE SBUTTON FROM 80, 223 TYPE 1 ACTION (oDlg:End(),nOpca:=1) ENABLE OF oDlg
		DEFINE SBUTTON FROM 80, 255 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTER
	
	If nOpca == 1  
		cDir := cGetFile(, OemToAnsi("Selecione o diret๓rio de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 
		If !Empty(cDir)                                          
			CursorWait()
			Processa( { |lEnd| Gerar(@lEnd,cHrInicio) },"Gerando relatorio, aguarde..")
			CursorArrow()
		Else
			Aviso(cPerg,"Escolha um diret๓rio vแlido.",{"Ok"})
		EndIf
	EndIf
endif

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGerar		บAutor  ณJackson E. de Deus  บ Data ณ  04/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera o relatorio em planilha de excel.                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Gerar(lEnd,cHrInicio)

Local cSql := ""
Local cSql_2 := ""
Local nCont := 0
Local aPA := {}
Local aOS := {} 
Local aMaq := {}
Local aPs := {}
Local aMaquinas := {}
Local aTabela := {}
Local aXX := {} 
Local aCont := {}   
Local cNumOS := ""
Local cAxVld := ""
Local cStatus := ""
Local cArmazem := ""
Local oExcel := FWMSEXCEL():New()
Local cArqXls := "extrato_abastecimento.xml"
Local cSheet1 := "Kardex - SD3"
Local cSheet2 := "Mov SZ5"
Local cSheet3 := "Mov SZ0"
Local cSheet4 := "Contadores"
Local cSheet5 := "Orcamentos"
Local cSheet6 := "Mapa_Maquina"

              
If Empty(MV_PAR02)
	MsgAlert("Informe PA Ate!")
	Return
EndIf

If Empty(MV_PAR04)
	MsgAlert("Informe Rota Ate!")
	Return
EndIf   

If Empty(MV_PAR06)
	MsgAlert("Informe Patrimonio Ate!")
	Return
EndIf

If Empty(MV_PAR07)
	MV_PAR07 := dDatabase
EndIf             
               
If Empty(MV_PAR08)
	MV_PAR08 := dDatabase
EndIf


// DEFINICAO FORMATO
//Primeira aba - parametros
oExcel:AddworkSheet("Parametros")
oExcel:AddTable ("Parametros","Parametros")
oExcel:AddColumn("Parametros","Parametros","Parametros",1,1)
oExcel:AddColumn("Parametros","Parametros","Respostas",1,1)

oExcel:AddRow("Parametros","Parametros",{"PA De: ", mv_par01 } )
oExcel:AddRow("Parametros","Parametros",{"PA Ate: ", mv_par02 } )
oExcel:AddRow("Parametros","Parametros",{"Rota De: ", mv_par03 } )
oExcel:AddRow("Parametros","Parametros",{"Rota Ate: ", mv_par04 } )
oExcel:AddRow("Parametros","Parametros",{"Patrimonio De: ", mv_par05 } )
oExcel:AddRow("Parametros","Parametros",{"Patrimonio Ate: ", mv_par06 } )
oExcel:AddRow("Parametros","Parametros",{"Data De: ", dtoc(mv_par07) } )
oExcel:AddRow("Parametros","Parametros",{"Data Ate: ", dtoc(mv_par08) } )

// movimento SD3

oExcel:AddworkSheet(cSheet1) 
oExcel:AddTable (cSheet1,"Relatorio")
oExcel:AddColumn(cSheet1,"Relatorio","Emissใo",1,4)
oExcel:AddColumn(cSheet1,"Relatorio","Documento",1,1)
oExcel:AddColumn(cSheet1,"Relatorio","Codigo",1,1)
oExcel:AddColumn(cSheet1,"Relatorio","Descri็ใo",1,1)
oExcel:AddColumn(cSheet1,"Relatorio","Armaz้m",1,1)
oExcel:AddColumn(cSheet1,"Relatorio","Tipo Mov",1,1)
oExcel:AddColumn(cSheet1,"Relatorio","Movimento Realizado",1,1)
oExcel:AddColumn(cSheet1,"Relatorio","Quantidade",3,2) 
    
// movimento SZ5
oExcel:AddworkSheet(cSheet2) 
oExcel:AddTable (cSheet2,"Relatorio")
oExcel:AddColumn(cSheet2,"Relatorio","OS Mobile",1,1)
oExcel:AddColumn(cSheet2,"Relatorio","Tipo Cria็ใo",1,1)
oExcel:AddColumn(cSheet2,"Relatorio","Formulแrio",1,1)
oExcel:AddColumn(cSheet2,"Relatorio","Data",1,4)
oExcel:AddColumn(cSheet2,"Relatorio","Hora",1,1)
oExcel:AddColumn(cSheet2,"Relatorio","Patrim๔nio",1,1)
oExcel:AddColumn(cSheet2,"Relatorio","Modelo",1,1)
oExcel:AddColumn(cSheet2,"Relatorio","Cliente",1,1)
oExcel:AddColumn(cSheet2,"Relatorio","Loja",1,1)
oExcel:AddColumn(cSheet2,"Relatorio","Razใo social",1,1)
oExcel:AddColumn(cSheet2,"Relatorio","Armaz้m",1,1)
oExcel:AddColumn(cSheet2,"Relatorio","Mola",1,1)  
oExcel:AddColumn(cSheet2,"Relatorio","Cod. Produto",1,1)                                                              
oExcel:AddColumn(cSheet2,"Relatorio","Desc. Produto",1,1)
oExcel:AddColumn(cSheet2,"Relatorio","Tipo Mov",1,1)
oExcel:AddColumn(cSheet2,"Relatorio","Saldo Atual",3,2) 
oExcel:AddColumn(cSheet2,"Relatorio","Abastecido",3,2,.T.)
oExcel:AddColumn(cSheet2,"Relatorio","Desc. Movimenta็ใo",1,1)
oExcel:AddColumn(cSheet2,"Relatorio","Preco Publico",3,2)	// preco - solicitacao Aline 



// movimento SZ0
oExcel:AddworkSheet(cSheet3) 
oExcel:AddTable (cSheet3,"Relatorio")
oExcel:AddColumn(cSheet3,"Relatorio","OS Mobile",1,1)
oExcel:AddColumn(cSheet3,"Relatorio","Formulแrio",1,1)
oExcel:AddColumn(cSheet3,"Relatorio","Data",1,4)
oExcel:AddColumn(cSheet3,"Relatorio","Hora",1,1)
oExcel:AddColumn(cSheet3,"Relatorio","Patrim๔nio",1,1)
oExcel:AddColumn(cSheet3,"Relatorio","Modelo",1,1)
oExcel:AddColumn(cSheet3,"Relatorio","Cliente",1,1)
oExcel:AddColumn(cSheet3,"Relatorio","Loja",1,1)
oExcel:AddColumn(cSheet3,"Relatorio","Razใo social",1,1)
oExcel:AddColumn(cSheet3,"Relatorio","Armaz้m",1,1)
oExcel:AddColumn(cSheet3,"Relatorio","Mola",1,1)  
oExcel:AddColumn(cSheet3,"Relatorio","Cod. Produto",1,1)                                                              
oExcel:AddColumn(cSheet3,"Relatorio","Desc. Produto",1,1)
oExcel:AddColumn(cSheet3,"Relatorio","Saldo",3,2) 
oExcel:AddColumn(cSheet3,"Relatorio","Abastecido",3,2,.T.) 
oExcel:AddColumn(cSheet3,"Relatorio","Retirado",3,2,.T.) 
oExcel:AddColumn(cSheet3,"Relatorio","Avaria",3,2,.T.) 
oExcel:AddColumn(cSheet3,"Relatorio","Saldo_movimento",3,2)
oExcel:AddColumn(cSheet3,"Relatorio","Preco Publico",3,2)	// preco - solicitacao Aline
oExcel:AddColumn(cSheet3,"Relatorio","Abastecido_Apontado",3,2,.T.) 
//oExcel:AddColumn(cSheet3,"Relatorio","Retirado",3,2,.T.) 
//oExcel:AddColumn(cSheet3,"Relatorio","Avaria",3,2,.T.) 
//oExcel:AddColumn(cSheet3,"Relatorio","Saldo_movimento",3,2)
//oExcel:AddColumn(cSheet3,"Relatorio","Abastecido_Apontado",3,2,.T.) 

// Contadores
oExcel:AddworkSheet(cSheet4) 
oExcel:AddTable (cSheet4,"Relatorio")
oExcel:AddColumn(cSheet4,"Relatorio","OS Mobile",1,1)
oExcel:AddColumn(cSheet4,"Relatorio","Formulแrio",1,1)
oExcel:AddColumn(cSheet4,"Relatorio","Data",1,4)
oExcel:AddColumn(cSheet4,"Relatorio","Hora",1,1)
oExcel:AddColumn(cSheet4,"Relatorio","Patrim๔nio",1,1)
oExcel:AddColumn(cSheet4,"Relatorio","Modelo",1,1)
oExcel:AddColumn(cSheet4,"Relatorio","Cliente",1,1)
oExcel:AddColumn(cSheet4,"Relatorio","Loja",1,1)
oExcel:AddColumn(cSheet4,"Relatorio","Razใo social",1,1)
oExcel:AddColumn(cSheet4,"Relatorio","Status",3,2)
oExcel:AddColumn(cSheet4,"Relatorio","Numerador atual",3,2)
oExcel:AddColumn(cSheet4,"Relatorio","Cash atual",3,2)
oExcel:AddColumn(cSheet4,"Relatorio","Parcial",3,2)
oExcel:AddColumn(cSheet4,"Relatorio","Testes",3,2)
// mapa = 60 botoes
For nI := 1 To 60
	oExcel:AddColumn(cSheet4,"Relatorio","Botao " +cvaltochar(nI),3,2)
Next nI


// Orcamentos
oExcel:AddworkSheet(cSheet5) 
oExcel:AddTable (cSheet5,"Relatorio")
oExcel:AddColumn(cSheet5,"Relatorio","OS Mobile",1,1)
oExcel:AddColumn(cSheet5,"Relatorio","Orcamento",1,1)
oExcel:AddColumn(cSheet5,"Relatorio","Data",1,4)
oExcel:AddColumn(cSheet5,"Relatorio","Cliente",1,1)
oExcel:AddColumn(cSheet5,"Relatorio","Loja",1,1)
oExcel:AddColumn(cSheet5,"Relatorio","Razใo social",1,1)
oExcel:AddColumn(cSheet5,"Relatorio","Patrim๔nio",1,1)
oExcel:AddColumn(cSheet5,"Relatorio","Modelo",1,1)
oExcel:AddColumn(cSheet5,"Relatorio","Tabela",1,1)
oExcel:AddColumn(cSheet5,"Relatorio","Status",1,1)
oExcel:AddColumn(cSheet5,"Relatorio","Pedido",1,1)

oExcel:AddColumn(cSheet5,"Relatorio","Item",1,1)
oExcel:AddColumn(cSheet5,"Relatorio","Cod. Produto",1,1)
oExcel:AddColumn(cSheet5,"Relatorio","Desc. Produto",1,1)
oExcel:AddColumn(cSheet5,"Relatorio","Quantidade",3,2)
oExcel:AddColumn(cSheet5,"Relatorio","Pre็o empresa",3,2)
oExcel:AddColumn(cSheet5,"Relatorio","Valor Total",3,2,.T.)
oExcel:AddColumn(cSheet5,"Relatorio","Pre็o p๚blico",3,2)
oExcel:AddColumn(cSheet5,"Relatorio","Armaz้m",1,1)


// pedido PP
/*
oExcel:AddworkSheet(cSheet4) 
oExcel:AddTable (cSheet4,"Relatorio")
oExcel:AddColumn(cSheet4,"Relatorio","OS Mobile",1,1)
oExcel:AddColumn(cSheet4,"Relatorio","Pedido",1,1)
oExcel:AddColumn(cSheet4,"Relatorio","Data",1,4)
oExcel:AddColumn(cSheet4,"Relatorio","Cliente",1,1)
oExcel:AddColumn(cSheet4,"Relatorio","Loja",1,1)
oExcel:AddColumn(cSheet4,"Relatorio","Razใo social",1,1)
//oExcel:AddColumn(cSheet4,"Relatorio","Tabela",1,1)
oExcel:AddColumn(cSheet4,"Relatorio","Status",1,1)
oExcel:AddColumn(cSheet4,"Relatorio","Item",1,1)
oExcel:AddColumn(cSheet4,"Relatorio","Cod. Produto",1,1)
oExcel:AddColumn(cSheet4,"Relatorio","Desc. Produto",1,1)
oExcel:AddColumn(cSheet4,"Relatorio","Quantidade",3,2)
oExcel:AddColumn(cSheet4,"Relatorio","Pre็o p๚blico",3,2)
oExcel:AddColumn(cSheet4,"Relatorio","Valor Total",3,2,.T.)
//oExcel:AddColumn(cSheet4,"Relatorio","Pre็o empresa",3,2)
//oExcel:AddColumn(cSheet4,"Relatorio","Armaz้m",1,1)
*/                                             

// Mapa maquina
oExcel:AddworkSheet(cSheet6) 
oExcel:AddTable (cSheet6,"Relatorio")
oExcel:AddColumn(cSheet6,"Relatorio","Patrim๔nio",1,1)
oExcel:AddColumn(cSheet6,"Relatorio","Modelo",1,1)
oExcel:AddColumn(cSheet6,"Relatorio","Tabela",1,1)
// mapa = 60 botoes
For nI := 1 To 60
	oExcel:AddColumn(cSheet6,"Relatorio","Botao " +cvaltochar(nI),1,1)
	oExcel:AddColumn(cSheet6,"Relatorio","PE",3,2)
	oExcel:AddColumn(cSheet6,"Relatorio","PP",3,2)
Next nI


// CONSULTA 1 - TOTAL DE PA's POR OS
cSql := "SELECT DISTINCT ZG_PA"

cSql += " FROM " +RetSqlName("SZG") +" SZG WITH (NOLOCK) "

cSql += " WHERE "
cSql += " SZG.D_E_L_E_T_ = '' "

cSql += " AND ZG_PA BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+" ' "

cSql += "AND ZG_ROTA BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'

cSql += "AND ZG_PATRIM BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'

If Empty(cHrInicio)
	cSql += " AND ZG_DATAFIM BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "  
Else
	cSql += " AND ( "
	cSql +=		" ( ZG_DATAFIM = '"+DTOS(MV_PAR07)+"' AND ZG_HORAFIM > '"+cHrInicio+"' ) "
	cSql += 	" OR "
	cSql +=		" ( ZG_DATAFIM BETWEEN '"+DTOS(MV_PAR07+1)+"' AND '"+DTOS(MV_PAR08)+"' ) " 
	cSql += " ) "
EndIf

cSql += " AND ZG_FORM IN  ( '04','08','13' ) "
cSql += " ORDER BY ZG_PA "

If Select("TRD") > 0
	TRD->(dbCloseArea())
EndIf                  

TcQuery cSql New Alias "TRD"

dbSelectArea("TRD")
While !EOF()
	nCont++
	dbSkip()
End

If nCont == 0
	Aviso("TTFATR50","Nใo hแ dados",{"Ok"})
	Return
EndIf

ProcRegua(nCont)



// SHEET 1 -> SD3 
TRD->(dbGoTop())
While !EOF()

	If Ascan( aPA, { |x| AllTrim(x[1]) == AllTrim(TRD->ZG_PA) } ) == 0
		AADD( aPA, { AllTrim(TRD->ZG_PA) } )
	EndIf
	
	TRD->( dbSkip() )
End

ProcRegua(nCont)


// CONSULTA 2 - MOVIMENTAวีES SD3 (KARDEX)

For nI := 1 To Len(aPA)

	IncProc(cSheet1 +" -> " +"PA: "+AllTrim(aPA[nI][1]) ) 

cSql := "SELECT D3_EMISSAO,D3_DOC,D3_LOCAL, D3_TM, D3_COD, B1_DESC, D3_QUANT, "
cSql += " 'MOVIMENTO' = CASE WHEN D3_TM BETWEEN '500' AND '998' "
cSql += " 	THEN 'SAIDA - RETIRADA/AVARIA' ELSE "
cSql += "						CASE WHEN D3_TM < '500' "
cSql += " 					THEN 'ENTRADA - ABASTECIMENTO' ELSE "
cSql += "						CASE WHEN D3_TM = '999' THEN 'ESTORNO' "
cSql += "							END "
cSql += "						END "
cSql += "				END "

cSql += " FROM " +RetSqlName("SD3") +" AS SD3 "

cSql += " INNER JOIN " +RetSqlName("SB1") +" AS SB1 ON "
cSql += " D3_COD = B1_COD "
cSql += " AND D3_XORIGEM IN ('TTPROC25','TTFAT40C') "                   
cSql += " AND SD3.D_E_L_E_T_ = '' "
cSql += " AND SB1.D_E_L_E_T_ = '' "

//cSql += " AND D3_LOCAL '"+MV_PAR01+"' BETWEEN '"+MV_PAR02+"' "
cSql += " AND D3_LOCAL = '"+AllTrim(aPA[nI][1])+"'

cSql += " AND D3_EMISSAO BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "

cSql += " ORDER BY D3_EMISSAO, D3_LOCAL,D3_COD "

If Select("TRD") > 0
	TRD->(dbCloseArea())
EndIf                  

TcQuery cSql New Alias "TRD"

dbSelectArea("TRD")

// SHEET 1 -> SD3 
//	TRD->(dbGoTop())
	While !EOF()

	
   		IncProc(cSheet1 +" -> " +"DOC MOVIMENTAวรO: "+AllTrim(TRD->D3_DOC) )
		oExcel:AddRow(cSheet1,"Relatorio",{DTOC(STOD(TRD->D3_EMISSAO)),; 
											TRD->D3_DOC,;										
											TRD->D3_COD,;
											TRD->B1_DESC,;
											TRD->D3_LOCAL,;
											TRD->D3_TM,;
											TRD->MOVIMENTO,;
											TRD->D3_QUANT })
	
	
		TRD->( dbSkip() )
	End

Next nI

ProcRegua(nCont)

// CONSULTA 3 - OS ATENDIDAS NO PERIODO (SZ5)

cSql := "SELECT ZG_NUMOS, ZG_DESCFRM, ZG_DATAFIM, ZG_HORAFIM, ZG_PATRIM, ZG_PATRIMD, "
cSql += " ZG_PA,ZG_ROTA, ZG_CLIFOR, ZG_LOJA, ZG_DESCCF, ZG_TABELA "

cSql += " FROM " +RetSqlName("SZG") +" SZG WITH (NOLOCK) "

cSql += " WHERE "
cSql += " SZG.D_E_L_E_T_ = '' "

cSql += " AND ZG_PA BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+" ' "

//cSql += " AND ZG_ROTA = '"+MV_PAR01+"' "

cSql += "AND ZG_ROTA BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'

cSql += "AND ZG_PATRIM BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'

If Empty(cHrInicio)
	cSql += " AND ZG_DATAFIM BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "  
Else
	cSql += " AND ( "
	cSql +=		" ( ZG_DATAFIM = '"+DTOS(MV_PAR07)+"' AND ZG_HORAFIM > '"+cHrInicio+"' ) "
	cSql += 	" OR "
	cSql +=		" ( ZG_DATAFIM BETWEEN '"+DTOS(MV_PAR07+1)+"' AND '"+DTOS(MV_PAR08)+"' ) " 
	cSql += " ) "
EndIf

cSql += " AND ZG_FORM IN  ( '04','08','13' ) "
cSql += " ORDER BY ZG_HORAFIM, ZG_PATRIM "

If Select("TRE") > 0
	TRE->(dbCloseArea())
EndIf                  

TcQuery cSql New Alias "TRE"

dbSelectArea("TRE")
While !EOF()
	nCont++
	dbSkip()
End

If nCont == 0
	Aviso("TTFATR50","Nใo hแ dados",{"Ok"})
	Return
EndIf

ProcRegua(nCont)

TRE->(dbGoTop())
While !EOF()

	If Ascan( aOS, { |x| AllTrim(x[1]) == AllTrim(TRE->ZG_NUMOS) } ) == 0
		AADD( aOS, { AllTrim(TRE->ZG_NUMOS), TRE->ZG_TABELA, AllTrim(TRE->ZG_PA) } )
	EndIf
	
	If Ascan( aMaq, { |x| AllTrim(x) == AllTrim(TRE->ZG_PATRIM) } ) == 0
		AADD( aMaq, AllTrim(TRE->ZG_PATRIM) )
	EndIf
	
	
	TRE->( dbSkip() )
End

ProcRegua(nCont)


// SHEET 2 -> SZ5
For nI := 1 To Len(aOS)

	IncProc(cSheet2 +" -> " +"OS: "+AllTrim(aOS[nI][1]) ) 
	
//	cSql := " SELECT Z0_CHAPA,Z0_CLIENTE,Z0_LOJA,Z0_PA,Z0_PRODUTO, Z0_MOLA, Z0_SALDO, Z0_ABAST, Z0_RETIR, Z0_AVARIA, Z0_SLDMOV, Z0_DATA, Z0_ABAPONT "
	cSql := " SELECT Z5_CHAPA,ZG_CLIFOR,ZG_LOJA,Z5_LOCAL,Z5_COD, Z5_MOLA, Z5_QUANT, Z5_TM, Z5_OBS, Z5_NUMOS, Z5_EMISSAO, Z6_QATU, "
	cSql += "	'TIPO' = CASE WHEN ZG_TPCRIAC = '1' THEN 'OS - AVULSA' ELSE "
	cSql += "	CASE WHEN ZG_TPCRIAC = '2' THEN 'OS - PLANO DE TRABALHO'  END END, "
	cSql += " ZG_DESCFRM,ZG_HORAFIM,ZG_PATRIMD,ZG_DESCCF,B1_DESC, DA1_XPRCPP "
	cSql += " FROM " +RetSqlName("SZ5") + " AS SZ5 " 
	cSql += " INNER JOIN " +RetSqlName("SZG") + " SZG ON "
	cSql += " ZG_FILIAL = Z5_FILIAL AND ZG_NUMOS = Z5_NUMOS AND SZG.D_E_L_E_T_ = '' "

	cSql += " INNER JOIN " +RetSqlName("SB1") + " SB1 ON "
	cSql += " B1_COD = Z5_COD AND SB1.D_E_L_E_T_ = '' "

	cSql += " INNER JOIN " +RetSqlName("SZ6") + " SZ6 ON "
	cSql += " Z6_FILIAL = Z5_FILIAL AND Z6_LOCAL = Z5_LOCAL"
	cSql += " AND Z6_COD = Z5_COD AND SZ6.D_E_L_E_T_ = '' "

	
	cSql += " LEFT JOIN " +RetSqlName("DA1") +" DA1 ON "
	cSql += " DA1_CODTAB = ZG_TABELA "
	cSql += " AND DA1_CODPRO = Z5_COD "
	cSql += " AND DA1.D_E_L_E_T_ = '' "
	
	cSql += " WHERE Z5_NUMOS = '"+AllTrim(aOS[nI][1])+"' AND SZ5.D_E_L_E_T_ = '' "
		
	cSql += " ORDER BY Z5_MOLA "
	
	If Select("TRE") > 0
		TRE->(dbCloseArea())
	EndIf                  
	
	TcQuery cSql New Alias "TRE"
	
	dbSelectArea("TRE")
	While !EOF()
		oExcel:AddRow(cSheet2,"Relatorio",{aOS[nI][1],;
											TRE->TIPO,;		 
											TRE->ZG_DESCFRM,;
											DTOC(STOD(TRE->Z5_EMISSAO)),;
											TRE->ZG_HORAFIM,;
											TRE->Z5_CHAPA,;
											TRE->ZG_PATRIMD,;
											TRE->ZG_CLIFOR,;
											TRE->ZG_LOJA,;
											TRE->ZG_DESCCF,;									
											TRE->Z5_LOCAL,;
											TRE->Z5_MOLA,;
											TRE->Z5_COD,;						
											TRE->B1_DESC,;
											TRE->Z5_TM,;
											TRE->Z6_QATU,;
											TRE->Z5_QUANT,;
											TRE->Z5_OBS,; 
											TRE->DA1_XPRCPP}) 
		TRE->(dbSkip())                       
	End
 
Next nI

ProcRegua(nCont)



// CONSULTA 4 - OS ATENDIDAS NO PERIODO (SZ0)

cSql := "SELECT ZG_NUMOS, ZG_DESCFRM, ZG_DATAFIM, ZG_HORAFIM, ZG_PATRIM, ZG_PATRIMD, "
cSql += " ZG_PA,ZG_ROTA, ZG_CLIFOR, ZG_LOJA, ZG_DESCCF, ZG_TABELA "

cSql += " FROM " +RetSqlName("SZG") +" SZG WITH (NOLOCK) "

cSql += " WHERE "
cSql += " SZG.D_E_L_E_T_ = '' "

cSql += " AND ZG_PA BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+" ' "

//cSql += " AND ZG_ROTA = '"+MV_PAR01+"' "

cSql += "AND ZG_ROTA BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'

cSql += "AND ZG_PATRIM BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'

If Empty(cHrInicio)
	cSql += " AND ZG_DATAFIM BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "  
Else
	cSql += " AND ( "
	cSql +=		" ( ZG_DATAFIM = '"+DTOS(MV_PAR07)+"' AND ZG_HORAFIM > '"+cHrInicio+"' ) "
	cSql += 	" OR "
	cSql +=		" ( ZG_DATAFIM BETWEEN '"+DTOS(MV_PAR07+1)+"' AND '"+DTOS(MV_PAR08)+"' ) " 
	cSql += " ) "
EndIf

cSql += " AND ZG_FORM IN  ( '04','08','13' ) "
cSql += " ORDER BY ZG_HORAFIM, ZG_PATRIM "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf                  

TcQuery cSql New Alias "TRB"

dbSelectArea("TRB")
While !EOF()
	nCont++
	dbSkip()
End

If nCont == 0
	Aviso("TTFATR50","Nใo hแ dados",{"Ok"})
	Return
EndIf

ProcRegua(nCont)

TRB->(dbGoTop())
While !EOF()

	If Ascan( aOS, { |x| AllTrim(x[1]) == AllTrim(TRB->ZG_NUMOS) } ) == 0
		AADD( aOS, { AllTrim(TRB->ZG_NUMOS), TRB->ZG_TABELA, AllTrim(TRB->ZG_PA) } )
	EndIf
	
	If Ascan( aMaq, { |x| AllTrim(x) == AllTrim(TRB->ZG_PATRIM) } ) == 0
		AADD( aMaq, AllTrim(TRB->ZG_PATRIM) )
	EndIf
	
	
	TRB->( dbSkip() )
End

ProcRegua(nCont)


// SHEET 3 -> SZ0
For nI := 1 To Len(aOS)

	IncProc(cSheet3 +" -> " +"OS: "+AllTrim(aOS[nI][1]) ) 
	
	cSql := " SELECT Z0_CHAPA,Z0_CLIENTE,Z0_LOJA,Z0_PA,Z0_PRODUTO, Z0_MOLA, Z0_SALDO, Z0_ABAST, Z0_RETIR, Z0_AVARIA, Z0_SLDMOV, Z0_DATA, Z0_ABAPONT "
	cSql += ", ZG_DESCFRM,ZG_HORAFIM,ZG_PATRIMD,ZG_DESCCF,B1_DESC, DA1_XPRCPP "
	cSql += " FROM " +RetSqlName("SZ0") + " SZ0 " 
	cSql += " INNER JOIN " +RetSqlName("SZG") + " SZG ON "
	cSql += " ZG_FILIAL = Z0_FILIAL AND ZG_NUMOS = Z0_NUMOS AND SZG.D_E_L_E_T_ = '' "
	cSql += " INNER JOIN " +RetSqlName("SB1") + " SB1 ON "
	cSql += " B1_COD = Z0_PRODUTO AND SB1.D_E_L_E_T_ = '' "
	
	cSql += " LEFT JOIN " +RetSqlName("DA1") +" DA1 ON "
	cSql += " DA1_CODTAB = ZG_TABELA "
	cSql += " AND DA1_CODPRO = Z0_PRODUTO "
	cSql += " AND DA1.D_E_L_E_T_ = '' "
	
	cSql += " WHERE Z0_NUMOS = '"+AllTrim(aOS[nI][1])+"' AND SZ0.D_E_L_E_T_ = '' "
		
	cSql += " ORDER BY Z0_MOLA "
	
	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf                  
	
	TcQuery cSql New Alias "TRB"
	
	dbSelectArea("TRB")
	While !EOF()
		oExcel:AddRow(cSheet3,"Relatorio",{aOS[nI][1],; 
											TRB->ZG_DESCFRM,;
											DTOC(STOD(TRB->Z0_DATA)),;
											TRB->ZG_HORAFIM,;
											TRB->Z0_CHAPA,;
											TRB->ZG_PATRIMD,;
											TRB->Z0_CLIENTE,;
											TRB->Z0_LOJA,;
											TRB->ZG_DESCCF,;									
											TRB->Z0_PA,;
											TRB->Z0_MOLA,;
											TRB->Z0_PRODUTO,;						
											TRB->B1_DESC,;
											TRB->Z0_SALDO,;
											TRB->Z0_ABAST,;
											TRB->Z0_RETIR,;
											TRB->Z0_AVARIA,;
											TRB->Z0_SLDMOV,;
											TRB->DA1_XPRCPP,;
											TRB->Z0_ABAPONT }) 
		TRB->(dbSkip())
	End
 
Next nI

ProcRegua(nCont)



// SHEET 3 - SZN
For nX := 1 To Len(aOS)
	cNumOS := aOS[nX][1] 
	IncProc(cSheet4 +" -> " +"OS: "+AllTrim(cNumOS) )
                
	dbSelectArea("SZG")
	dbSetOrder(1)
	If !dbSeek( xFilial("SZG") +AvKey(cNumOS,"ZG_NUMOS") )
		Loop
	EndIf   

	dbSelectArea("SZN")
	dbSetOrder(4)
	If dbSeek( xFilial("SZN") +AvKey(cNumOS,"ZN_NUMOS") )
		aVal := {}
		aPs := {}
		cAxVld := SZN->ZN_VALIDA
		If cAxVld == "S"
			cAxVld := "Pendente de valida็ใo"
		ElseIf cAxVld == "O"
			cAxVld := "Contadores OK"
		ElseIf cAxVld == "X"
			cAxVld := "Contadores invแlidos"
		EndIf
		
		For nI := 1 To 60      
			cPosBot := PadL( nI, 2, "0" )
			AADD( aPs, &("SZN->ZN_BOTAO"+cPosBot) )
		Next nI
			
		AADD( aVal, { SZG->ZG_NUMOS,; 
					SZG->ZG_DESCFRM,;
					DTOC(SZG->ZG_DATAFIM),;
					SZG->ZG_HORAFIM,;
					SZG->ZG_PATRIM,;
					SZG->ZG_PATRIMD,;
					SZG->ZG_CLIFOR,;
					SZG->ZG_LOJA,;
					SZG->ZG_DESCCF,;
					cAxVld,;
					SZN->ZN_NUMATU,;
					SZN->ZN_COTCASH,;
					SZN->ZN_PARCIAL,;
					SZN->ZN_BOTTEST } )
					
		For nI := 1 To Len(aPS)
			AADD( aVal[Len(aVal)], aPs[nI] )
		Next nI
		
		For nI := 1 To Len(aVal)
			oExcel:AddRow(cSheet4,"Relatorio", aVal[nI] )
		Next nI
	EndIf
Next nX


// SHEET 4 - ORCAMENTOS
dbSelectArea("SCJ")
dbSetOrder(6)
For nI := 1 To Len(aOS) 
	IncProc(cSheet4 +" -> " +"OS: "+AllTrim(aOS[nI][1]) )
	      
	dbSelectArea("SCJ")
	If MsSeek( xFilial("SCJ") +AvKey(aOS[nI][1],"CJ_XNUMOS") )
		If SCJ->CJ_STATUS == "A"
			cStatus := "Aberto"
		ElseIf SCJ->CJ_STATUS == "B"
			cStatus := "Baixado"
		ElseIf SCJ->CJ_STATUS == "C"
			cStatus := "Cancelado"
		ElseIf SCJ->CJ_STATUS == "E"
			cStatus := "Aprovado"
		EndIf
		
		dbSelectArea("SCK")
		dbSetOrder(1)
		If MSSeek( xFilial("SCK") +AvKey(SCJ->CJ_NUM,"CK_NUM") )
			While SCK->CK_FILIAL == SCJ->CJ_FILIAL .AND. SCK->CK_NUM == SCJ->CJ_NUM .AND. SCK->(!EOF())
				
				oExcel:AddRow(cSheet5,"Relatorio",{SCJ->CJ_XNUMOS,;
										SCJ->CJ_NUM,;
										DTOC(SCJ->CJ_EMISSAO),;
										SCJ->CJ_CLIENTE,;
										SCJ->CJ_LOJA,;
										Posicione( "SA1",1,xFilial("SA1") +AvKey(SCJ->CJ_CLIENTE,"A1_COD") +AvKey(SCJ->CJ_LOJA,"A1_LOJA"),"A1_NREDUZ" ),;									
										SCJ->CJ_XPATRIM,;
										Posicione( "SN1",2,xFilial("SN1") +AvKey(SCJ->CJ_XPATRIM,"N1_CHAPA"),"N1_DESCRIC" ),;
										SCJ->CJ_TABELA,;
										cStatus,;
										SCJ->CJ_XNUMPV,;
										SCK->CK_ITEM,;
										SCK->CK_PRODUTO,;
										AllTrim(SCK->CK_DESCRI),;
										SCK->CK_QTDVEN,;
										SCK->CK_PRCVEN,;
										SCK->CK_VALOR,;
										SCK->CK_XPRCPP,;
										SCK->CK_LOCAL })
										
			
				SCK->(dbSkip())
			End
		EndIf								
	EndIf
Next nI


// SHEET 5 -> Mapa Maquina
For nX := 1 To Len(aOS)
	cNumOS := aOs[nX][1]

	dbSelectArea("SZG")
	dbSetOrder(1)
	If !dbSeek( xFilial("SZG") +AvKey(cNumOS,"ZG_NUMOS") )
		Loop
	EndIf
	
	cNumChapa := SZG->ZG_PATRIM
		
	If AScan( aXX, { |x| x == cNumChapa } ) > 0
		Loop
	EndIf
	
	dbSelectArea("SN1")
	dbSetOrder(2)         
	If ! dbSeek( xFilial("SN1") +AvKey(cNumChapa,"N1_CHAPA") )
		Loop
	EndIf
	
	IncProc(cSheet6 +" -> " +"Patrim๔nio: "+AllTrim(SN1->N1_CHAPA) )  
	
	aPs := {}
	For nI := 1 To 60
		AADD( aPs, { &("SN1->N1_XP"+cvaltochar(nI)),0,0 } )	// produto | preco empresa | preco publico
	Next nI
	
	If !Empty(SZG->ZG_TABELA)
		aTabela := STATICCALL( TTFAT20C, TabPRC,SZG->ZG_TABELA,aPs)		
	EndIf 

	For nI := 1 To Len(aPs)
		For nJ := 1 To Len(aTabela)
			If aTabela[nJ][1] == aPs[nI][1]
				aPs[nI][2] := aTabela[nJ][2]
				aPs[nI][3] := aTabela[nJ][3]
			EndIf
		Next nJ
	Next nI
	
	aMaquinas := {}
	AADD( aMaquinas, { SN1->N1_CHAPA,;
						SN1->N1_DESCRIC,;
						SZG->ZG_TABELA })
							
	For nI := 1 To Len(aPs)
		AADD( aMaquinas[Len(aMaquinas)], aPs[nI][1]  )
		AADD( aMaquinas[Len(aMaquinas)], aPs[nI][2]  )
		AADD( aMaquinas[Len(aMaquinas)], aPs[nI][3]  )
	Next nI
		
	For nI := 1 To Len(aMaquinas)
		oExcel:AddRow(cSheet6,"Relatorio", aMaquinas[nI] )
	Next nI
	
	AADD( aXX, SN1->N1_CHAPA )
Next nX	

  
oExcel:Activate()
oExcel:GetXMLFile(cDir +cArqXls)

If File(cDir +cArqXls)
	Aviso("TTFATR50","A planilha foi gerada em "+cDir,{"Ok"})
	If !ApOleClient( 'MsExcel' )
		Aviso("TTFATR50", 'MsExcel nใo instalado. ' +CRLF +'O arquivo estแ localizado em: '+cDir, {"Ok"} )
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
ฑฑบPrograma  ณAjustaSX1  บAutor  ณJackson E. de Deus บ Data ณ  04/11/14   บฑฑ
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

PutSx1(cPerg,"01","PA De: ?","PA ?","PA ?","mv_cha","C",7,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"02","PA Ate: ?","PA Ate: ?","PA Ate: ?","mv_chb","C",7,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"03","Rota De: ?","Rota De: ?","Rota De: ?","mv_chc","C",7,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"04","Rota Ate: ?","Rota Ate: ?","Rota Ate: ?","mv_chd","C",7,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"05","Patrimonio De: ?","Patrimonio De: ?","Patrimonio De: ?","mv_che","C",7,0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"06","Patrimonio Ate: ?","Patrimonio Ate: ?","Patrimonio Ate: ?","mv_chf","C",7,0,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"07","Data De ?","Data De ?","Data De ?","mv_chg","D",8,0,0,"G","","","","","mv_par07","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"08","Data Ate ?","Data Ate ?","Data Ate ?","mv_chh","D",8,0,0,"G","","","","","mv_par08","","","","","","","","","","","","","","","","","","","","","","")

      
Return