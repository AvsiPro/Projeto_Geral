#include "protheus.ch
#include "topconn.ch"
#include "tbiconn.ch"
#INCLUDE "REPORT.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROR07  บAutor  ณJackson E. de Deus  บ Data ณ  03/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio Indicadores de Produto							  บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณJackson       ณ03/03/15ณ01.00 |Criacao                                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function TTPROR07()

Local cPerg := "TTPROR07" 
Local lJob := .F.
Local nOpca := 0
Private _aCli := {}
Private _cDir := ""

If cEmpAnt <> "01"
	return
EndIF

If lJob
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"
EndIf

ValPerg(cPerg)
Pergunte(cPerg,.T.,"Configure os parโmetros") 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Tela de configuracao 			         	     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DEFINE MSDIALOG oDlg FROM  96,9 TO 310,592 TITLE OemToAnsi("Indicadores de produto") PIXEL
	@ 18, 6 TO 66, 287 LABEL "" OF oDlg  PIXEL
	@ 29, 15 SAY OemToAnsi("Relat๓rio de indicadores") SIZE 268, 8 OF oDlg PIXEL
	@ 38, 15 SAY OemToAnsi("") SIZE 268, 8 OF oDlg PIXEL
	@ 48, 15 SAY OemToAnsi("Configure os parametros") SIZE 268, 8 OF oDlg PIXEL
	DEFINE SBUTTON FROM 80, 190 TYPE 5 ACTION Pergunte(cPerg,.T.) ENABLE OF oDlg
	DEFINE SBUTTON FROM 80, 223 TYPE 1 ACTION (oDlg:End(),nOpca:=1) ENABLE OF oDlg
	DEFINE SBUTTON FROM 80, 255 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTER

If nOpca == 1 
	
	_cDir := cGetFile(, OemToAnsi("Selecione o diret๓rio de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 
	If Empty(_cDir)                                          
		Aviso(cPerg,"Escolha um diret๓rio vแlido.",{"Ok"})
	EndIf
	
	Imprime()
EndIf

Return

                
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImprime  บAutor  ณJackson E. de Deus  บ Data ณ  03/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carga dos dados                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Imprime()

Local aDados := {}            
Local aAux := {}
Local aAux2 := {}
Local aPA := {}
Local aCli := {}
Local cSql := ""
Local cSql2 := ""
Local cGrpEcon := MV_PAR03
Local cCodcli := MV_PAR04
Local cLoja := MV_PAR05
Local cPA := MV_PAR06
Local cPatr := MV_PAR07
Local nTpRel := MV_PAR08	//1 sintetico - 2 analitico
Local nPos := 0
Local cCodPA := ""

Private cDispMaq := "24:00"
Private dDataDe := MV_PAR01
Private dDataAte := MV_PAR02

If Empty(cPatr) .And. Empty(cPA) .And. Empty(cGrpEcon) .And. Empty(cCodcli) .And. Empty(cLoja)
	MsgStop("Preencha corretamente os parโmetros!")
	Return
EndIf

If Empty(cGrpEcon) .And. Empty(cCodcli)
	MsgStop("Preencha pelo menos o grupo econ๔mico ou c๓digo de cliente!")
	Return
EndIf

// select clientes
cSql := "SELECT A1_GRUECON, A1_COD, A1_LOJA "
cSql += " FROM " +RetSqlName("SA1")
cSql += " WHERE"  

If !Empty(cGrpEcon)
	cSql += " A1_GRUECON = '"+cGrpEcon+"' "
EndIf

If !Empty(cCodCli)
	
	If !Empty(cGrpEcon)
		cSql += " AND A1_COD = '"+cCodCli+"' "
		If !Empty(cLoja)
			cSql += " AND A1_LOJA = '"+cLoja+"' "
		EndIf
	Else
		cSql += " A1_COD = '"+cCodCli+"' "
		If !Empty(cLoja)
			cSql += " AND A1_LOJA = '"+cLoja+"' "
		EndIf
	EndIf
	  

EndIf

cSql += "ORDER BY A1_COD, A1_LOJA"


If Select("TRBX") > 0
	TRBX->(dbCloseArea())
EndIf
                       
//TcQuery cSql New Alias "TRB2"
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cSql),"TRBX",.F.,.T.)
dbSelectArea("TRBX")
While TRBX->(!EOF())
	AADD( _aCli, { TRBX->A1_GRUECON, TRBX->A1_COD, TRBX->A1_LOJA, {} } )
	dbSkip()
End


//cSql := "SELECT * FROM " +RetSqlName("SZK") +" ZK "
cSql := "SELECT A1_COD,A1_LOJA,A1_GRUECON, ZK_CLIENTE, ZK_LOJA, ZK_PA, ZK_PATRIM, ZK_DTCRIAC, ZK_HRCRIAC, ZK_DTAGEND, ZK_HRAGEND, ZK_DTFIM, ZK_HRFIM, "
cSql += "ZK_PRAZOOK, ZK_TMPHORA, ZK_TMPINI, ZK_TMPMAQ, AAG_DESCRI, "
cSql += "ISNULL(DATEDIFF(hh,ZK_DTCRIAC +' ' +ZK_HRCRIAC ,ZK_DTFIM + ' ' +ZK_HRFIM),0) As TMPATD "
cSql += "FROM " +RetSqlName("SZK") +" ZK "

cSql += " INNER JOIN " +RetSqlName("SZG") +" ZG ON ZG_NUMOS = ZK_NUMOS AND ZG.D_E_L_E_T_ = '' "
cSql += " LEFT JOIN " +RetSqlName("SN1") +" N1 ON N1_CHAPA = ZK_PATRIM AND N1.D_E_L_E_T_ = '' "
cSql += " INNER JOIN " +RetSqlName("SA1") +" A1 ON A1_COD = ZK_CLIENTE AND A1_LOJA = ZK_LOJA AND A1.D_E_L_E_T_ = '' "
cSql += " INNER JOIN " +RetSqlName("AB2") +" AB2 ON AB2_XOSMOB = ZK_NUMOS AND AB2.D_E_L_E_T_ = '' "
cSql += " INNER JOIN " +RetSqlName("AB1") +" AB1 ON AB1.AB1_NRCHAM = AB2.AB2_NRCHAM AND AB1.D_E_L_E_T_ = '' "
cSql += " LEFT JOIN " +RetSqlName("AAG") +" AAG ON AAG.AAG_CODPRB = AB2.AB2_CODPRB AND AAG.D_E_L_E_T_ = '' "  

cSql += " WHERE "
cSql += " ZG_TPFORM IN ('6','7') "
cSql += " AND ZK.D_E_L_E_T_ = '' "
cSql += " AND ZK_DTCRIAC BETWEEN '"+dtos(dDataDe)+"' AND '"+dtos(dDataAte)+"' "

If !Empty(cPatr)
	cSql += " AND ZK_PATRIM = '"+cPatr+"' "
EndIf

If !Empty(cPa)
	cSql += " AND ZK_PA = '"+cPa+"' "
EndIf

If !Empty(cCodCli)  
	cSql += " AND ZK_CLIENTE = '"+cCodCli+"' "
	If !Empty(cLoja)
		cSql += " AND ZK_LOJA = '"+cLoja+"' "
	EndIf
EndIf

If !Empty(cGrpEcon)
	cSql += " AND A1_GRUECON = '"+cGrpEcon+"' "
EndIf

cSql += "ORDER BY A1_GRUECON, ZK_CLIENTE, ZK_LOJA, ZK_PA, ZK_PATRIM, N1_XLOCINS, ZK_PATRIMD"


If Select("TRB2") > 0
	TRB2->(dbCloseArea())
EndIf
                       
//TcQuery cSql New Alias "TRB2"
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cSql),"TRB2",.F.,.T.)
dbSelectArea("TRB2")

// massa de dados
While TRB2->(!EOF())
	// desconsiderar reembolso
	If "REEMBOLSO" $ UPPER(TRB2->AAG_DESCRI)
		dbSkip()
		Loop
	EndIf
	
	
	AADD( aDados, {  TRB2->A1_GRUECON, TRB2->ZK_CLIENTE, TRB2->ZK_LOJA, TRB2->ZK_PA, TRB2->ZK_PATRIM,;
					 STOD(TRB2->ZK_DTCRIAC), TRB2->ZK_HRCRIAC, STOD(TRB2->ZK_DTAGEND), TRB2->ZK_HRAGEND, STOD(TRB2->ZK_DTFIM), TRB2->ZK_HRFIM,;
					 TRB2->ZK_PRAZOOK, TRB2->ZK_TMPHORA, TRB2->ZK_TMPINI, TRB2->ZK_TMPMAQ,TRB2->TMPATD } )
	dbSkip()
End

For nI := 1 To Len(_aCli)
	For nJ := 1 To Len(aDados)	
		If _aCli[nI][1] == aDados[nJ][1] .And. _aCli[nI][2] == aDados[nJ][2] .And.;
			 _aCli[nI][3] == aDados[nJ][3] // .And. aDados[nI][4] == _aCli[nJ][4]	// grupo cliente loja pa

			cCodPA := aDados[nJ][4]
			nPos := Ascan( _aCli[nI][4], { |x| x[1] == cCodPa } )
			If nPos == 0
				AADD( _aCli[nI][4], { cCodPa } ) 
				nPos := Len(_acli[nI][4])
			EndIf
			
			AADD( _aCli[nI][4][nPos], aDados[nJ] )
		EndIf 
	Next nJ
Next nI


Processa({ || Sintetic(nTpRel) },"Aguarde...")    


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSintetic บAutor  ณJackson E. de Deus   บ Data ณ  02/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio sintetico em Excel                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Sintetic(nTpRel)


Local nI,nJ,nK,nL                         
Local dDtCriac	:= STOD("")
Local cHrCriac	:= ""
Local dDtFim	:= STOD("")
Local cHrFim	:= ""
Local nTotHoras	:= 0
Local cTmpStop	:= ""
Local cTmpAx	:= ""
Local nTotOCorr	:= 0
Local nTotOS	:= 0
Local nQtPrzOk	:= 0
Local nAtPrazo	:= 0
Local nDias		:= 0 
Local nTotItens	:= 0
Local nSales	:= 0
Local oExcel
Local cGrpEcon	:= MV_PAR03
Local cCodcli	:= MV_PAR04
Local cLoja		:= MV_PAR05
Local cPA		:= MV_PAR06
Local cPatr		:= MV_PAR07
Local cDirLocal	:= _cDir
Local cCodPA	:= ""           
Local aCol		:= {Nil,Nil,Nil,Nil,Nil,Nil,Nil}
Local aAuxfim	:= {}
Local aCham		:= {}
Local lAnal		:= IIF(nTpRel==2,.T.,.F.)
Local aAxPatr	:= {}
Local nPosPat	:= 0
Local aPTCHM	:= {} 

// Gera excel
oExcel := FWMSEXCEL():New()

//Primeira aba - parametros
oExcel:AddworkSheet("Parametros")
oExcel:AddTable ("Parametros","Parametros")
oExcel:AddColumn("Parametros","Parametros","Parametros",1,1)
oExcel:AddColumn("Parametros","Parametros","Respostas",1,1)

oExcel:AddRow("Parametros","Parametros",{"Data de: ", dtoc(dDataDe) } )
oExcel:AddRow("Parametros","Parametros",{"Data ate: ", DtoC(dDataAte) } )
oExcel:AddRow("Parametros","Parametros",{"Grupo economico: ", cGrpEcon  } )
oExcel:AddRow("Parametros","Parametros",{"Cliente: ", cCodcli } )
oExcel:AddRow("Parametros","Parametros",{"Loja: " , cLoja } )
oExcel:AddRow("Parametros","Parametros",{"PA: " , cPA } )
oExcel:AddRow("Parametros","Parametros",{"Patrim๔nio", cPatr  } ) 

// sintetico
If !lAnal
	oExcel:AddworkSheet("Indicadores")
	oExcel:AddTable ("Indicadores","Indicadores")
	oExcel:AddColumn("Indicadores","Indicadores","Grupo econ๔mico",1,1)
	oExcel:AddColumn("Indicadores","Indicadores","Cliente",1,1)
	oExcel:AddColumn("Indicadores","Indicadores","Loja",1,1)
	oExcel:AddColumn("Indicadores","Indicadores","Nome fantasia",1,1)
	oExcel:AddColumn("Indicadores","Indicadores","PA",1,1)
	oExcel:AddColumn("Indicadores","Indicadores","Disponibilidade de mแquina",3,1)  
	oExcel:AddColumn("Indicadores","Indicadores","Total de ocorr๊ncias",3,1)
	oExcel:AddColumn("Indicadores","Indicadores","Total de mแquinas na PA",3,1)
	oExcel:AddColumn("Indicadores","Indicadores","Ocorr๊ncia de chamados por mแquina",3,2)	//
	oExcel:AddColumn("Indicadores","Indicadores","Atendimento das OS's de manuten็ใo no prazo",3,1)
	oExcel:AddColumn("Indicadores","Indicadores","Tempo m้dio at้ o atendimento das OS's de manuten็ใo",3,2)    //
	oExcel:AddColumn("Indicadores","Indicadores","Reclama็ใo dos clientes",3,2) 	 //
	oExcel:AddColumn("Indicadores","Indicadores","Quantidade de itens vendidos",3,2) // 
	
// Analitico
Else 
	oExcel:AddworkSheet("Indicadores")
	oExcel:AddTable ("Indicadores","Indicadores")
	oExcel:AddColumn("Indicadores","Indicadores","Grupo econ๔mico",1,1)
	oExcel:AddColumn("Indicadores","Indicadores","Cliente",1,1)
	oExcel:AddColumn("Indicadores","Indicadores","Loja",1,1)
	oExcel:AddColumn("Indicadores","Indicadores","Nome fantasia",1,1)
	oExcel:AddColumn("Indicadores","Indicadores","PA",1,1)
	oExcel:AddColumn("Indicadores","Indicadores","Mแquina",1,1)
	oExcel:AddColumn("Indicadores","Indicadores","Modelo",1,1)
	oExcel:AddColumn("Indicadores","Indicadores","Disponibilidade de mแquina",3,1)	
	oExcel:AddColumn("Indicadores","Indicadores","Ocorr๊ncia de chamados por mแquina",3,2)
	oExcel:AddColumn("Indicadores","Indicadores","Atendimento das OS's de manuten็ใo no prazo",3,1)
	oExcel:AddColumn("Indicadores","Indicadores","Tempo m้dio at้ o atendimento das OS's de manuten็ใo",3,2)
	//oExcel:AddColumn("Indicadores","Indicadores","Reincid๊ncia de defeitos",3,2)
	oExcel:AddColumn("Indicadores","Indicadores","Reclama็ใo dos clientes",3,2)
	oExcel:AddColumn("Indicadores","Indicadores","Quantidade de itens vendidos",3,2)
EndIf	

cGrp := ""             
cCodCli := ""
cLoja := ""
cNomCli := ""
cCodPa := ""
cPatrAnt := ""
aPatSl := {}

// novo tratamento
ProcRegua(Len(_aCli))
For nI := 1 To Len(_aCli)
	cGrp := _aCli[nI][1]
	cCodCli := _aCli[nI][2]
	cLoja := _aCli[nI][3]
	cNomCli := AllTrim( Posicione("SA1",1,xFilial("SA1")+cCodCli+cLoja, "A1_NREDUZ") )
	cPA := ""
	cDescPa := ""
	aCham := Aclone( _aCli[nI][4] )
	
	aCol := {Nil,Nil,Nil,Nil,Nil,Nil,Nil}
	
	nDispMaq := 0
	nTotOCorr := 0
	nAtPrazo := 0
	cTmpMedio := ""
	nReincDef := 0  
	nTotMaqPA := 0
	nTotReclam := 0
	nTotItens := 0
	nQtPrzOk := 0
	cTmpAx := ""
	cTmpStop := ""
	nTmpStp := 0	
	nTotOS := 0 
	nXTMP := 0 
	aPatSl := {}
	aPTCHM := {}
	
	If Empty(aCham)
		nDispMaq := 100
	EndIf
    
	// coluna 6 - reclamacoes clientes
	nTotReclam := fReclam( cCodCli,cLoja,dDataDe,dDataAte )

	For nJ := 1 To Len(aCham)
		cPA := aCham[nJ][1]
		If !Empty(cPA)
			cDescPa := cPA +" - " +AllTrim(Posicione( "ZZ1",1,xFilial("ZZ1") +AvKey(cPa,"ZZ1_COD"),"ZZ1_DESCRI" ))
		EndIf
		
		nDispMaq := 0
		nTotOCorr := 0
		nAtPrazo := 0
		cTmpMedio := ""
		nReincDef := 0
		nTotReclam := 0
		nTotItens := 0
		nQtPrzOk := 0
		cTmpAx := ""
		cTmpStop := ""
		nTmpStp := 0	
		nXTMP := 0
		nTotOS := Len( aCham[nJ] )-1
		aPatSl := {}
		         
		For nK := 2 To Len(aCham[nJ])
				
			cPatr := aCham[nJ][nK][5]
			cModelo := AllTrim( Posicione( "SN1",2,xFilial("SN1")+AvKey(cPatr,"N1_CHAPA"),"N1_DESCRIC" ) )
			     			
			If !Empty(aCham[nJ][nK][15])     
				If AllTrim(aCham[nJ][nK][15]) == "1"
					cDispMaq := "24:00"
				ElseIf AllTrim(aCham[nJ][nK][15]) == "2"
					cDispMaq := "12:00"
				EndIf				
			EndIf
			
			nTmpStp += aCham[nJ][nK][16]
			nXTMP += SubtHoras( aCham[nJ][nK][6],aCham[nJ][nK][7],aCham[nJ][nK][10],aCham[nJ][nK][11]  )
		
			  
			If aCham[nJ][nK][12] == "0"
				nQtPrzOk++
			EndIf
		           
			cPatrAnt := cPatr   
			                      
			If AScan( aPTCHM, { |x| x == cPatr } ) == 0
				AADD( aPTCHM, cPatr )                       
			EndIf
	
		Next nK
		
		// total maquinas na PA
		nTotMaqPA := 0
		If !Empty(cPA)
			nTotMaqPA := fTotMaqPA(cPA,@aPatSl)
		EndIf
		
		// coluna 1                      
		nDias := dDataAte-dDataDe
		nTotHoras := HoraToInt(cDispMaq) * nDias * nTotMaqPA
		//nDispMaq := Round( (1-(nTmpStp/nTotHoras)) * 100,2 )
		nDispMaq := Round( (1-(nXTMP/nTotHoras)) * 100,2 )
		  
		
		// coluna 2
		// nTotOS   
		
		// coluna 3
		// nTotMaqPA 
		                                     
		// coluna 4
		nTotOCorr := nTotOS/nTotMaqPA
		             	
		// coluna 5
		nAtPrazo := Round( (nQtPrzOk/nTotOS * 100),2 )
		
		// coluna 6
		//cTmpMedio := IntToHora( nTmpStp/nTotOs )  //HoraToInt(cTmpStop)/nTotOS
		cTmpMedio := IntToHora( nXTMP/nTotOs )  //HoraToInt(cTmpStop)/nTotOS
		  
		
		// coluna 7
		//nReincDef := fReincDef(cCodCli,cLoja,dDataAte)
	
		// coluna 7
		nTotReclam := fReclam(cCodCli,cLoja,dDataDe,dDataAte)
		
		// coluna 8
	   //	For nL := 1 to Len(aPatSl)
	   For nL := 1 to Len(aPTCHM)		
			nTotItens += fTotItens( cCodCli,cLoja,dDataDe,dDataAte, aPTCHM[nL] )
		Next nL  
	Next nJ
	    
	// adiciona
	AADD( aAuxFim, {cGrp,;
					cCodCli,;
					cLoja,;
					cNomCli,;
					cDescPa,;
					nDispMaq,;
					nTotOS,; 
					nTotMaqPA,;
					nTotOCorr,;
					nAtPrazo,;
					cTmpMedio,;
					nTotReclam,;
					nTotItens}  )   
					
					
				
					
					
					
					

	IncProc()
		
Next nI

For nI := 1 To Len(aAuxfim)
	oExcel:AddRow("Indicadores","Indicadores",aAuxFim[nI])
Next nI
			

oExcel:Activate()

oExcel:GetXMLFile(cDirLocal +"indicadores.xml")

If File( cDirLocal +"indicadores.xml" )
	Aviso( FunName(),"A planilha foi gerada em " +cDirLocal, {"Ok"})
	If !ApOleClient( 'MsExcel' )
		Aviso( FunName(), 'MsExcel nใo instalado. ' +CRLF +'O arquivo estแ em: '+cDirLocal,{"Ok"} )
	Else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cDirLocal+"indicadores.xml" )
		oExcelApp:SetVisible(.T.)         
		oExcelApp:Destroy()
	EndIf
EndIf
	

Return
   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkStop บAutor  ณJackson E. de Deus    บ Data ณ  02/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tempo de maquina parada                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkStop( cCodCli,cLoja,cPatr  )

Local nTempo := 0
Local cTmpAx := ""
Local cTmpStop := ""            
Local cSql := ""
Local aArea := GetArea()

cSql := "SELECT ZK_DTCRIAC, ZK_HRCRIAC, ZK_DTFIM, ZK_HRFIM FROM SZK010 SZK "
cSql += "INNER JOIN SZG010 SZG ON ZG_NUMOS = ZK_NUMOS AND ZG_TPFORM IN ( '6','7' ) "
cSql += " WHERE ZK_CLIENTE = '"+cCodCli+"' AND ZK_LOJA = '"+cLoja+"' "
cSql += " AND ZK_PATRIM = '"+cPatr+"' AND ZK_DTCRIAC BETWEEN '"+dtos(dDataDe)+"' AND '"+dtos(dDataAte)+"' AND SZK.D_E_L_E_T_ = '' "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf
                       
TcQuery cSql New Alias "TRB"
dbSelectArea("TRB")

While !EOF()
	dDtCriac := STOD(TRB->ZK_DTCRIAC)
	cHrCriac := TRB->ZK_HRCRIAC
	
	dDtFim := STOD(TRB->ZK_DTFIM)
	cHrFim := TRB->ZK_HRFIM
	
	cTmpAx := IntToHora( SubtHoras( dDtCriac, cHrCriac, dDtFim, cHrFim ) ) 
	cTmpStop := IntToHora( SomaHoras(cTmpStop,cTmpAx) )
	dbSkip()
End

nTempo := HoratoInt(cTmpStop)
  
RestArea(aArea)

Return nTempo



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfTotOS  บAutor  ณJackson E. de Deus    บ Data ณ  02/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ total de OS por cliente/loja/patrimonio                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fTotOS( cCodCli,cLoja,cPatr )

Local nTotOS := 0
Local aArea := GetArea()             

cSql := "SELECT COUNT(*) TOTAL FROM SZK010 SZK "
cSql += "INNER JOIN SZG010 SZG ON ZG_NUMOS = ZK_NUMOS AND ZG_TPFORM = '7' "
cSql += " WHERE ZK_CLIENTE = '"+cCodCli+"' AND ZK_LOJA = '"+cLoja+"' "
cSql += " AND ZK_PATRIM = '"+cPatr+"' AND ZK_DTCRIAC BETWEEN '"+dtos(dDataDe)+"' AND '"+dtos(dDataAte)+"' AND SZK.D_E_L_E_T_ = '' "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf
                       
TcQuery cSql New Alias "TRB"
dbSelectArea("TRB")

If !EOF()
	nTotOS := TRB->TOTAL
EndIf


RestArea(aArea)

Return nTotOS


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfOSPrazo  บAutor  ณJackson E. de Deus  บ Data ณ  02/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณtotal de os atendida no prazo por cliente/loja/patrimonio   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fOSPrazo( cCodCli,cLoja,cPatr )

Local nOsPrazo := 0
Local aArea := GetArea()             

cSql := "SELECT COUNT(*) TOTAL FROM SZK010 SZK "
cSql += "INNER JOIN SZG010 SZG ON ZG_NUMOS = ZK_NUMOS AND ZG_TPFORM IN ('6','7') "
cSql += " WHERE ZK_CLIENTE = '"+cCodCli+"' AND ZK_LOJA = '"+cLoja+"' "
cSql += " AND ZK_PATRIM = '"+cPatr+"' AND ZK_DTCRIAC BETWEEN '"+dtos(dDataDe)+"' AND '"+dtos(dDataAte)+"' AND SZK.D_E_L_E_T_ = '' "
cSql += " AND ZK_PRAZOOK = '0' "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf
                       
TcQuery cSql New Alias "TRB"
dbSelectArea("TRB")

If !EOF()
	nOsPrazo := TRB->TOTAL
EndIf

RestArea(aArea)

Return nOsPrazo


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfTotMaqPA  บAutor  ณJackson E. de Deus บ Data ณ  02/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ total de maquinas na PA                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fTotMaqPA(cCodPA,aPatSL)

Local cSql := ""
Local nTotMaq := 0
Local aArea := GetArea() 

cSql := "SELECT N1_CHAPA FROM " +RetSqlName("SN1") +" SN1 " 
cSql += "INNER JOIN " +RetSqlname("SB1") + " SB1 ON B1_COD = N1_PRODUTO "
cSql += " WHERE N1_XPA = '"+cCodPA+"' AND SN1.D_E_L_E_T_ = '' AND B1_XSECAO = '026' AND SB1.D_E_L_E_T_ = '' "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf
                       
TcQuery cSql New Alias "TRB"
dbSelectArea("TRB")
While !EOF() 
	AADD( aPatSL, TRB->N1_CHAPA )
	nTotMaq++
	dbSkip()
End                     

RestArea(aArea)

Return nTotMaq

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfReincDef  บAutor  ณJackson E. de Deus บ Data ณ  02/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ reincidencia de defeitos                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fReincDef(cCodCli,cLoja,dDataAte,cPatr)

Local cQuery := ""
Local aMaq := {}
Local nTotal := 0
Local nReinc := 0 
Local aArea := GetArea()
Default cPatr := ""

cQuery := "SELECT AB2_NUMSER FROM " +RetSqlName("AB2") +" AB2 "
cQuery += "INNER JOIN " +RetSqlName("AB1") +" AB1 ON "
cQuery += "AB1.AB1_FILIAL = AB2.AB2_FILIAL AND AB1.AB1_NRCHAM = AB2.AB2_NRCHAM AND AB1.D_E_L_E_T_ = '' "
cQuery += "WHERE AB2.D_E_L_E_T_ = '' AND AB1.AB1_NUMTMK <> '' "

If !Empty(cPatr)
	cQuery += " AND AB2_NUMSER = '"+cPatr+"' "
EndIf

cQuery += " AND AB1.AB1_CODCLI = '"+cCodCli+"' AND AB1.AB1_LOJA = '"+cLoja+"' "
cQuery += " AND AB1.AB1_EMISSA BETWEEN '"+DtoS( dDataAte-60) +"' AND '"+DtoS(dDataAte)+"' "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf                  

TcQuery cQuery New Alias "TRB"

dbSelectArea("TRB")
dbGoTop()
While !EOF()      
	If Ascan( aMaq, { |x| x == TRB->AB2_NUMSER } ) == 0  
		AADD( aMaq, TRB->AB2_NUMSER )                  
	Else
		nReinc++
	EndIf
	TRB->(dbSkip())
End

RestArea(aArea)

Return nReinc


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfReclam  บAutor  ณJackson E. de Deus   บ Data ณ  02/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ total de reclamacoes                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fReclam(cCodCli,cLoja,dDataDe,dDataAte)

Local cQuery := ""
Local nTotal := 0
Local aArea := GetArea()
   
cQuery := "SELECT COUNT(*) TOTAL FROM " +RetSqlName("SUD") +" SUD "

// TMK
cQuery += "INNER JOIN " +RetSqlName("SUC") +" SUC ON "
cQuery += "UC_FILIAL = UD_FILIAL "
cQuery += "AND UC_CODIGO = UD_CODIGO AND SUC.D_E_L_E_T_ = '' AND SUC.UC_CODCANC = '' "

// OCORRENCIAS
cQuery += "INNER JOIN " +RetSqlName("SU9") +" SU9 ON " +CRLF
cQuery += "SU9.U9_CODIGO = SUD.UD_OCORREN " +CRLF
cQuery += "AND SU9.D_E_L_E_T_ = SUD.D_E_L_E_T_ " +CRLF
                      
cQuery += "WHERE " +CRLF     
cQuery += "UC_DATA BETWEEN '"+DtoS(dDataDe) +"' AND '"+DtoS(dDataAte)+"' "
cQuery += "AND UC_CHAVE = '"+cCodCli+cLoja+"' "
cQuery += "AND SUD.D_E_L_E_T_ = '' " +CRLF
cQuery += "AND UD_ASSUNTO IN ( '000003' ) " +CRLF
cQuery += "AND UD_CODIGO NOT IN ( "
cQuery += "SELECT AB1_NUMTMK FROM " +RetSqlName("AB1") +" AB1 "
cQuery += " WHERE AB1_NUMTMK = UD_CODIGO AND AB1.D_E_L_E_T_ = '' "
cQuery += " )"
                                 
If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf                  

TcQuery cQuery New Alias "TRB"

dbSelectArea("TRB")
dbGoTop()
If !EOF()      
	nTotal += TRB->TOTAL
End

RestArea(aArea) 

Return nTotal 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfTotItens  บAutor  ณJackson E. de Deus บ Data ณ  02/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณtotal itens vendidos                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fTotItens( cCodCli,cLoja,dDataDe,dDataAte,cPatr,cNumOS )

Local cQuery := ""
Local nAux := 0
Local nTotal := 0                                                       
Local aNum := {}
Local nNumAtu := 0 
Local nNumAnt := 0
Local dData
Local nI
Local aArea := GetArea()
Default cPatr := ""
Default cNumOS := ""

cQuery := "SELECT ZN_NUMANT, ZN_NUMATU, ZN_DATA FROM " +RetSqlName("SZN") +" SZN "
cQuery += "WHERE "
cQuery += " ZN_CLIENTE = '"+cCodCli+"' AND ZN_LOJA = '"+cLoja+"' AND ZN_NUMOS <> '' "

If !Empty(cPatr)
	cQuery += " AND ZN_PATRIMO = '"+cPatr+"' "
EndIf

If !Empty(cNumOS)
	cQuery += " AND ZN_NUMOS = '"+cNumOS+"' "	
EndIf

cQuery += " AND ZN_DATA BETWEEN '"+DtoS(dDataDe) +"' AND '"+DtoS(dDataAte)+"' "
cQuery += " AND ZN_VALIDA <> 'X' "
cQuery += " ORDER BY ZN_DATA DESC, ZN_HORA DESC, ZN_NUMATU DESC"

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf                  

TcQuery cQuery New Alias "TRB"

dbSelectArea("TRB")
dbGoTop()

If !Empty(cNumOS)
	If !EOF()
		//If !Empty(TRB->ZN_NUMANT)
		//	nTotal := TRB->ZN_NUMATU - TRB->ZN_NUMANT
		//Else 
			cQuery2 := "SELECT TOP 1 ZN_NUMATU FROM " +RetSqlName("SZN")
			cQuery2 += " WHERE ZN_PATRIMO = '"+cPatr+"' AND D_E_L_E_T_ = '' "
			cQuery2 += " AND ZN_VALIDA <> 'X' AND ZN_CLIENTE = '"+cCodCli+"' AND ZN_LOJA = '"+cLoja+"' AND ZN_NUMATU < '"+CVALTOCHAR(TRB->ZN_NUMATU)+"' "
			cQuery2 += " ORDER BY ZN_NUMATU DESC "
			
			MpSysOpenQuery( cQuery2, "TRB2" )
			
			dbSelectArea("TRB2")
			
			nTotal := ( TRB->ZN_NUMATU - TRB2->ZN_NUMATU )
			
			TRB2->( dbCloseArea() )
		//EndIf
	EndIf
Else
	While !EOF()//If !EOF()	//
	               
		nNumAnt := 0
		
		cQuery2 := "SELECT TOP 1 ZN_NUMATU FROM " +RetSqlName("SZN")
		cQuery2 += " WHERE ZN_PATRIMO = '"+cPatr+"' AND D_E_L_E_T_ = '' "
		cQuery2 += " AND ZN_VALIDA <> 'X' AND ZN_CLIENTE = '"+cCodCli+"' AND ZN_LOJA = '"+cLoja+"' AND ZN_NUMATU < '"+CVALTOCHAR(TRB->ZN_NUMATU)+"' "
		cQuery2 += " ORDER BY ZN_NUMATU DESC "
		
		MpSysOpenQuery( cQuery2, "TRB2" )
		dbSelectArea("TRB2")
		If !EOF()
			nNumAnt := TRB2->ZN_NUMATU
		EndIf
		
		TRB2->(dbCloseArea())
	                            
		dbSelectArea("TRB")
		AADD( aNum, { TRB->ZN_NUMATU, nNumAnt, STOD(TRB->ZN_DATA) } )
		
		TRB->(dbSkip())
	End	//EndIf	//End         
	
	For nI := 1 To Len(aNum)
		nNumAtu := aNum[nI][1]
		nNumAnt := aNum[nI][2]
		dData := aNum[nI][3]
	
		nTotal += ( nNumAtu - nNumAnt )
	
	Next nI
EndIf
		

RestArea(aArea)

Return nTotal


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetNumAnt  บAutor  ณJackson E. de Deus บ Data ณ  02/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ retorna numerador anterior do patrimonio                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RetNumAnt(cCodCli,cLoja,cPatr,dData,nNumAtu)

Local nNumAnt := 0
Local cQuery := ""

cQuery := "SELECT ZN_NUMANT, ZN_NUMATU, ZN_DATA FROM " +RetSqlName("SZN") +" SZN "
cQuery += "WHERE "
cQuery += " ZN_CLIENTE = '"+cCodCli+"' AND ZN_LOJA = '"+cLoja+"' AND ZN_NUMOS <> '' "
cQuery += " AND ZN_PATRIMO = '"+cPatr+"' "
cQuery += " AND ZN_DATA BETWEEN '"+dtos(dData-30)+"' AND '"+dtos(dData)+"' "

cQuery += " ORDER BY ZN_DATA DESC"

If Select("TRBX") > 0
	TRB->(dbCloseArea())
EndIf                  

TcQuery cQuery New Alias "TRBX"

dbSelectArea("TRBX")
dbGoTop()
While !EOF()
	If TRBX->ZN_NUMATU < nNumAtu
		nNumAnt := TRBX->ZN_NUMATU
		Exit
	EndIf
	dbSkip()
End

TRBX->(dbCloseArea())
         

Return nNumAnt

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValPerg  บAutor  ณJackson E. de Deus   บ Data ณ  02/03/15   บฑฑ
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

PutSx1(cPerg,'01','Data De ?','','','mv_ch0','D',8,0,0,'G','','','','','mv_par01',,,'','','','','','','','','','','','','','')	
PutSx1(cPerg,'02','Data Ate ?','','','mv_ch1','D',8,0,0,'G','','','','','mv_par02',,,'','','','','','','','','','','','','','')	
PutSx1(cPerg,'03','Grupo economico ?','','','mv_ch2','C',TamSx3("A1_GRUECON")[1],0,0,'G','','ZZB','','','mv_par03',,,'','','','','','','','','','','','','','')		
PutSx1(cPerg,'04','Cliente ?','','','mv_ch3','C',TamSx3("A1_COD")[1],0,0,'G','','SA1','','','mv_par04',,,'','','','','','','','','','','','','','')
PutSx1(cPerg,'05','Loja ?','','','mv_ch4','C',TamSx3("A1_LOJA")[1],0,0,'G','','','','','mv_par05',,,'','','','','','','','','','','','','','')		
PutSx1(cPerg,'06','PA ?','','','mv_ch5','C',TamSx3("ZZ1_COD")[1],0,0,'G','','ZZ1','','','mv_par06',,,'','','','','','','','','','','','','','')
PutSx1(cPerg,'07','Patrimonio ?','','','mv_ch6','C',TamSx3("N1_CHAPA")[1],0,0,'G','','','','','mv_par07',,,'','','','','','','','','','','','','','')
PutSx1(cPerg,'08','Tipo ?','','','mv_ch7','N',1 ,0,1,'C','','','','','mv_par07',"Sintetico","","","",/*"Analitico"*/"","","","","","","","","","","","")   

Return