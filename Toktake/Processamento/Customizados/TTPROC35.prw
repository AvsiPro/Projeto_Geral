#include "parmtype.ch"
#include "topconn.ch"
#include "tbiconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC35  บAutor  ณJackson E. de Deus  บ Data ณ  16/01/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Grava os indicadores                                       บฑฑ
ฑฑบ          ณ															  บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณJackson       ณ16/01/15ณ01.00 |Criacao                                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function TTPROC35(cCodFil,cNumOs,cXml,lReprocess)

Local lNovoFrm := .F.                   
Local lAlter := .F.
Local nRecZK := 0
Local lExist := .F.
Local oXml := Nil
Local cError := ""
Local cWarning := ""
Local cMsgTxt := ""
Local nI
Local dDtCriac := StoD("")
Local cHrCriac := ""
Local dDtIni := StoD("")
Local cHrIni := ""
Local dDtAgend := StoD("")
Local cHrAgend := ""
Local dDtFim := StoD("")
Local cHrFim := ""
Local nQtdDias := 0
Local cQtdHoras := ""
Local cTempoIni := ""
Local cTempoMaq := ""
Local cCoordInic := ""
Local cCoordFim := ""
Local cPatrim := ""
Local cDescPatr := ""
Local cCliente := ""
Local cLoja := ""
Local cNomCli := ""
Local cCodPa := ""
Local cTecnico := ""
Local cNomeTec := ""
Local cAgente := ""
Local aHorario := {"","","",""}
Local cSuperv := ""
Local cNomeSuperv := ""
Local cGeren := ""
Local cNomeGeren := ""
Local cPrazoOk := "0"
Local cRegOk := ""
Local lPrazoOk := .T.
Local cNumTMK := ""
Local cHrTmk := ""
Local cTpForm := ""  
Local cEmpFunc := ""
Local cDescForm := ""
Local cTurnoTec := ""
Local cDescTrn := ""
Local aFrmChmdo := {"5","6","7","16","17"}	// inc sist pag | chamado novo | chamado velho | inst maq | rem maq
Local lCham := .F.
Local aArea := GetArea()
Local cCodTec := ""
Local aDadosOS := {}

PARAMTYPE 1 VAR cCodFil		AS CHARACTER	DEFAULT ""
PARAMTYPE 2 VAR cNumOs		AS CHARACTER	DEFAULT ""
PARAMTYPE 3 VAR cXml		AS CHARACTER	DEFAULT ""
PARAMTYPE 4 VAR lReprocess	AS LOGICAL		DEFAULT .F.  

If cEmpAnt <> "01"
	return
EndIF

dbSelectArea("SZK")
dbSetOrder(1)
If dbSeek( cCodFil +AvKey(cNumOs,"ZK_NUMOS") )
	If !lReprocess
		Return        
	EndIf
	nRecZK := Recno()
EndIf

     

dbSelectArea("SZG") 
dbSetOrder(1)
If dbSeek( cCodFil +AvKey(cNumOs,"ZG_NUMOS") )
	lNovoFrm := SZG->ZG_NOVOFRM
	cTpForm := cvaltochar(SZG->ZG_TPFORM)
	cDescForm := SZG->ZG_DESCFRM
	cCodTec := SZG->ZG_CODTEC
	cAgente := cvaltochar(SZG->ZG_AGENTE)
	cCliente := SZG->ZG_CLIFOR
	cLoja := SZG->ZG_LOJA
	cNomCli := SZG->ZG_DESCCF
	cPatrim := SZG->ZG_PATRIM
	cDescPatr := SZG->ZG_PATRIMD
	dDtAgend := SZG->ZG_DATAINI
	cHrAgend := SZG->ZG_HORAINI
	dDtCriac := SZG->ZG_DTCRIAC
	cHrCriac := SZG->ZG_HRCRIAC
	dDtIni := SZG->ZG_DATAINI
	cHrIni := SZG->ZG_HORAINI
	dDtFim := SZG->ZG_DATAFIM
	cHrFim := SZG->ZG_HORAFIM
EndIf


oXml := XmlParser( cXml, "", @cError, @cWarning )
If oXml == Nil
	cMsgTxt := "FALHA AO GERAR O OBJETO XML : " +cError+" / "+cWarning
    ConOut("# " +FunName() +" ->" +cMsgTxt  +" #")
Else
	If XmlChildEx( oXml, "_ATENDIMENTO" ) <> NIL
		If XmlChildEx( oXml:_ATENDIMENTO, "_STATUS_HIST" ) <> NIL
			/*
			// tratar status
			If XmlChildEx( oXml:_ATENDIMENTO:_STATUS_HIST, "_INIC" ) <> NIL			
				dDtIni := STOD( STRTRAN( SUBSTR(oXml:_ATENDIMENTO:_STATUS_HIST:_INIC:TEXT,1,10),"-","" ) )
				cHrIni := SUBSTR( oXml:_ATENDIMENTO:_STATUS_HIST:_INIC:TEXT,12,8 )                        
			Else
				dDtIni := STOD( STRTRAN( SUBSTR(oXml:_ATENDIMENTO:_STATUS_HIST:_FIOK:TEXT,1,10),"-","" ) )
				cHrIni := SUBSTR( oXml:_ATENDIMENTO:_STATUS_HIST:_FIOK:TEXT,12,8 ) 
			EndIf
			
			dDtFim := STOD( STRTRAN( SUBSTR(oXml:_ATENDIMENTO:_STATUS_HIST:_FIOK:TEXT,1,10),"-","" ) )
			cHrFim := SUBSTR( oXml:_ATENDIMENTO:_STATUS_HIST:_FIOK:TEXT,12,8 )
			*/			
		EndIf
	EndIf
EndIf

dbSelectArea("SN1")
dbSetOrder(2)
If dbSeek( xFilial("SN1") +AvKey(cPatrim,"N1_CHAPA")  )
	cCodPa := SN1->N1_XPA
	cTempoMaq := SN1->N1_XTMPMAQ
EndIf

dbSelectArea("AA1")
dbSetOrder(1)
If dbSeek( xFilial("AA1") +AvKey(cCodTec,"AA1_CODTEC") ) 
	cTecnico := AA1->AA1_CODTEC
	cNomeTec := AA1->AA1_NOMTEC
	cSuperv := AA1->AA1_XSUPER
	cTurnoTec := AA1->AA1_TURNO
	cNomeSuperv := GetAdvFval("AA1", "AA1_NOMTEC" ,xFilial("AA1") +cSuperv, 1)
	cDescTrn := GetAdvFval("SR6", "R6_DESC" ,xFilial("AA1") +cTurnoTec, 1)
	cGeren := GetAdvFval("AA1", "AA1_XGEREN" ,xFilial("AA1") +cSuperv, 1)
	cNomeGeren := GetAdvFval("AA1", "AA1_NOMTEC" ,xFilial("AA1") +cGeren, 1)
	If !Empty(cTurnoTec) .And. !Empty(dDtFim)
		aHorario := StaticCall( TTOPER17,Turno,cTurnoTec,dDtFim )
	EndIf
EndIf
                        
// pega numero de chamado call center e hora de inicio - se for Os de chamado tecnico
For nI := 1 To Len(aFrmChmdo)
	If aFrmChmdo[nI] == AllTrim(cTpForm)
		lCham := .T.
		Exit
	EndIf
Next nI  
If lCham
	ChkTmk(cNumOs,@cNumTMK,@cHrTmk)
EndIf

// calculos
// tempo de atendimento da os
nQtdDias := dDtFim - dDtIni
cQtdHoras := IntToHora(SubtHoras(dDtIni, cHrIni,dDtFim,cHrFim))                    

// tempo entre a criacao da OS e o atendimento
If !Empty(dDtCriac) .And. !Empty(cHrCriac)
	cTempoIni := IntToHora(SubtHoras(dDtCriac, cHrCriac,dDtIni,cHrIni))
EndIf
                              
// OS ATENDIDA NO PRAZO?
If dDtFim > dDtAgend
	cPrazoOk := "1"
ElseIf dDtFim == dDtAgend .And. cHrFim > cHrAgend
	cPrazoOk := "1"
EndIf
                   

// REGISTRO OK?
                
dbSelectArea("SZK")
If lReprocess .And. nRecZK > 0
	dbGoTo(nRecZK)
	If Recno() == nRecZK
		lExist := .T.
		lAlter := .T.
		//RecLock("SZK",.F.)
		//dbDelete()
		//MsUnlock()          
	EndIf
EndIf

If lReprocess .And. lExist
	RecLock("SZK",.F.)     
Else
	RecLock("SZK",.T.)
EndIf

//If RecLock("SZK",.T.)
	SZK->ZK_FILIAL := cCodFil
	SZK->ZK_NUMOS := cNumOs
	SZK->ZK_TPFORM := cTpForm
	SZK->ZK_DSCFRM := cDescForm
	SZK->ZK_NUMTMK := cNumTMK
	SZK->ZK_DTCRIAC := dDtCriac
	SZK->ZK_HRCRIAC := cHrCriac
	SZK->ZK_DTINI := dDtIni
	SZK->ZK_HRINI := cHrIni
	SZK->ZK_DTAGEND := dDtAgend
	SZK->ZK_HRAGEND := cHrAgend
	SZK->ZK_DTFIM := dDtFim
	SZK->ZK_HRFIM := cHrFim
	SZK->ZK_HINITMK := cHrTmk
	SZK->ZK_TMPDIA := nQtdDias
	SZK->ZK_TMPHORA	:= cQtdHoras
	SZK->ZK_TMPINI := cTempoIni
	SZK->ZK_LATLNG1 := cCoordInic
	SZK->ZK_LATLNG2 := cCoordFim
	SZK->ZK_PATRIM := cPatrim
	SZK->ZK_PATRIMD := cDescPatr
	SZK->ZK_CLIENTE := cCliente
	SZK->ZK_LOJA := cLoja
	SZK->ZK_NOMECLI := cNomCli
	SZK->ZK_AGENTE := cAgente
	SZK->ZK_CODTEC := cTecnico
	SZK->ZK_NOMTEC := cNomeTec
	
	If !lAlter	// no reprocessamento nao alterar esses campos
		SZK->ZK_PA := cCodPa
		SZK->ZK_TMPMAQ := cTempoMaq
		SZK->ZK_TURNTEC := cTurnoTec
		SZK->ZK_TURNDSC := cDescTrn
		SZK->ZK_ENTRA1 := aHorario[1]
		SZK->ZK_SAIDA1 := aHorario[2]
		SZK->ZK_ENTRA2 := aHorario[3]
		SZK->ZK_SAIDA2 := aHorario[4]
		SZK->ZK_SUPERV := cSuperv
		SZK->ZK_SUPERVD := cNomeSuperv
		SZK->ZK_GEREN := cGeren
		SZK->ZK_GEREND := cNomeGeren
	EndIf

	SZK->ZK_PRAZOOK := cPrazoOk
	SZK->ZK_REGOK := cRegOk
     
	SZK->(MsUnlock())
//EndIf

RestArea(aArea)

Return

      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkTmk  บAutor  ณJackson E. de Deus    บ Data ณ  20/01/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se OS mobile foi originada de chamado TMK         บฑฑ
ฑฑบ          ณ Alimenta numero do chamado e hora de inicio                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkTmk(cNumOs,cNumTMK,cHrTmk)

Local cSql := ""

cSql := "SELECT UC_CODIGO, UC_INICIO FROM " +RetSqlName("SUC")  +" SUC "
cSql += " INNER JOIN " +RetSqlName("AB1") +" AB1 ON AB1.AB1_FILIAL = SUC.UC_FILIAL AND AB1.AB1_NUMTMK = SUC.UC_CODIGO AND AB1.D_E_L_E_T_ = '' "
cSql += " INNER JOIN " +RetSqlName("AB2") +" AB2 ON AB2.AB2_FILIAL = AB1.AB1_FILIAL AND AB2.AB2_NRCHAM = AB1.AB1_NRCHAM "
cSql += "WHERE AB2.D_E_L_E_T_ = '' AND AB1.AB1_NUMTMK <> '' AND AB2_XOSMOB = +'"+cNumOs+"' "

If Select("TRB2") > 0
	TRB2->(dbCloseArea())
EndIf
                       
TcQuery cSql New Alias "TRB2"
dbSelectArea("TRB2")

If !EOF()
	cNumTmk := TRB2->UC_CODIGO
	cHrTmk := TRB2->UC_INICIO
EndIf
                      
TRB2->(dbCloseArea())                      
                      
Return