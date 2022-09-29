#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMBM006    บAutor  ณJackson E. de Deus  บ Data ณ  17/12/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa o retorno da OS de atendimento                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MBM006(Atendente,OSMobile,Values)
           
Local cJson := ""
Local oObj
Local cMsg := ""
Local cStatus := ""
Local aDados := {} 
Local cDescStat := ""
Local lAtvVldOS := SuperGetMv("MV_XMB006",.F.,.F.)
Local nRecno := 0
Local cCodFil := ""
Local cCodEmp := ""
Local dDtFim := stod("")
Local cHrFim := "" 
Local oXml := Nil    
Local cError := ""
Local cWarning := ""

If cEmpAnt <> "01"
	Return
EndIf

OSMobile := PadL(OSMobile,TamSx3("ZG_NUMOS")[1],"0")

// obtem dados do xml
aDados := U_MXML000(Values)
For nI := 1 To Len(aDados)
	If aDados[nI][1] == "STATUS"
		cStatus := aDados[nI][2]
		If cStatus == "ACTE"
			cDescStat := "Recebido pelo agente"
		ElseIf cStatus == "INIC"
			cDescStat := "Iniciado"
		ElseIf cStatus == "FIOK"
			cDescStat := "Finalizado"
		EndIf                                 
	EndIf
Next nI

// pegar data e hora de finalizacao
If cStatus == "FIOK"
	oXml := XmlParser( Values, "", @cError, @cWarning )
	If oXml <> Nil
		dDtFim := STOD( STRTRAN( SUBSTR(oXml:_ATENDIMENTO:_DATAHORAFIM:TEXT,1,10),"-","" ) )
		cHrFim := SUBSTR( oXml:_ATENDIMENTO:_DATAHORAFIM:TEXT,12,8 )	
	EndIf
EndIf			       


fRetFil(OSMobile,@nRecno,@cCodFil,@cCodEmp)
dbSelectArea("SZG")
dbSetOrder(1)

//If MSSeek( xFilial("SZG") +AvKey(OSMobile,"ZG_NUMOS") )
If nRecno > 0
	dbGoTo(nRecno)
	If AllTrim(SZG->ZG_CODTEC) == AllTrim(Atendente)
		If RecLock("SZG",.F.)
			If !AllTrim(SZG->ZG_STATUS) $ "COPE|CTEC|CCLI"
				SZG->ZG_STATUS	:= cStatus
				SZG->ZG_STATUSD	:= cDescStat
				
				If cStatus == "FIOK"
					SZG->ZG_DATAFIM	:= IIF( !Empty(dDtFim),dDtFim,Date() )
					SZG->ZG_HORAFIM := IIF( !Empty(cHrFim),cHrFim,Time() )
				EndIf
				
				If !Empty(Values)
					SZG->ZG_RESPOST := Values
				EndIf
			EndIf
						 
			// se ja tentou validar uma vez, agora ja avisa que a OS esta finalizada e deve ser excluida no APP
			If cStatus == "FIOK"
				If SZG->ZG_NTRY == 1
					SZG->ZG_NTRY := 2
				EndIf
			EndIf
				    
			MsUnLock()
		EndIf
		MemoWrite("\_mobile\mobile\data_receive\"+OSMobile+".xml",Values)    
		cMsg := "OS alterada!"
	EndIf
Else
	cMsg := "OS nao encontrada!"
EndIf

oObj := JsonObject():New()
oObj:PutVal("status","ok")
oObj:PutVal("result",cMsg)
oObj:PutVal("tentativa",IIF( lAtvVldOS,SZG->ZG_NTRY,2 ) )
cJson := oObj:ToJson()

CONOUT("#MBM006 -> " +OSMOBILE +" - " +cJson)
	   
Return cJson



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfRetFil   บAutor  ณJackson E. de Deus  บ Data ณ  12/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna a filial da OS mobile                              บฑฑ
ฑฑบ          ณ Informar nRecno e cCodFil por referencia @                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fRetFil(cNumOS,nRecno,cCodFil,cCodEmp)

Local cQuery := ""

cQuery := "SELECT R_E_C_N_O_ REC, ZG_FILIAL FILIAL FROM " +RetSqlName("SZG") +" WHERE ZG_NUMOS = '"+cNumOS+"' AND D_E_L_E_T_ = '' "

If Select("TRBG") > 0
	TRBG->(dbCloseArea())
EndIf                   

TcQuery cQuery New Alias "TRBG"
dbSelectArea("TRBG")
If !EOF()
	nRecno := TRBG->REC
	cCodFil := TRBG->FILIAL
	//cCodEmp := TRBG->EMPRESA
EndIf

TRBG->(dbCloseArea())                        

Return