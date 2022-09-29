#include "tbiconn.ch"
#include "topconn.ch"    
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMXML001   บAutor  ณJackson E. de Deus  บ Data ณ  22/01/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Job de processamento das Ordens de Servico Mobile          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MXML004(aParam)

Local aSize := {}
Local nI
Local dFim := Date()
Local cHrIni := ""
Local cHrFim := ""
Local cTempo := ""
Local aConn := {}
Local nThread := 0
Local nPos := 0
Local cNow := ""
Local cTimeApos := ""
Local lExec := .F.
Private __lJob := .T.
Default aParam := {"01","01"}

If cEmpAnt <> "01"
	Return
EndIf

If !Empty(FunName())
	__lJob := .F.
Else
	RpcSetType(3) 
	RpcSetEnv (aParam[1],aParam[2],,,"FAT",,,.T.,.T.,.T.)    
EndIf           

cHrIni := Time()

CONOUT("#MXML004 -> INICIO DE PROCESSAMENTO: "+DTOC(dFim) +" " +cHrIni )

While .T. 
	lExec := .F.
	If Time() > "23:00:00"
		Exit
	EndIf   
		    
	cNow := Time()
	If ( Empty(cTimeApos) .Or. ElapTime(cTimeApos,cNow) >= "00:05:00" )
		lExec := .T.
	EndIf
	
	If lExec
		ExecOS() 
		cTimeApos := Time()         	
	EndIf	
End	 

cHrFim := Time()
cTempo := ElapTime(cHrIni,cHrFim)

CONOUT("#MXML004 -> FIM DE PROCESSAMENTO: "+DTOC(dFim) +" " +cHrFim + " - TEMPO TOTAL: " +cTempo )

If __lJob
	RpcClearEnv()      
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExecOS   บAutor  ณJackson E. de Deus   บ Data ณ  10/02/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Executa o processamento                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ExecOS()

Local cQuery	:= ""
Local aOsPend	:= {} 
Local nI
Local dFim		:= Date()-3
Local cHrIni	:= ""
Local cHrFim	:= ""
Local lAvanca	:= .T.
Local lMat460On	:= .F.
Local lAtivo	:= .T.
Local nPos		:= 0
Local cUserTT	:= ""
Local nCount	:= 0
Local nTConn	:= 0
Local aJob		:= {} 
Local nHandle	:= 0
Local lQuebraJob:= .F.

  
// OS com processamento pendente
cQuery := "SELECT ZG_FILIAL,ZG_NUMOS,ZG_DESCFRM, ZG_AGENTED, ZG_DATAFIM, ZG_HORAFIM, ZG_NOVOFRM FROM " +RetSqlName("SZG") +" WITH (NOLOCK) "
//cQuery += "WHERE ZG_FORM IN ( '02','03','04','06','08','13','16','17' ) AND ZG_STATUS = 'FIOK' AND ZG_DATAFIM >= '"+DTOS(dFim)+"' AND ZG_PROC = '' "
cQuery += "WHERE ZG_FORM IN ('02','03','06','16','17') AND ZG_STATUS = 'FIOK' AND ZG_DATAFIM >= '"+DTOS(dFim)+"' AND ZG_PROC = '' "

//cQuery += "AND ZG_CODTEC <> '900393' "

//cQuery += "ORDER BY ZG_FORM, ZG_ROTA, ZG_DATAFIM, ZG_HORAFIM "
cQuery += "ORDER BY ZG_DATAFIM, ZG_HORAFIM "

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf                  

TcQuery cQuery New Alias "TRB"

dbSelectArea("TRB")
While !EOF()
	AADD( aOSPend, { TRB->ZG_NUMOS, IIF(TRB->ZG_NOVOFRM=="T",.T.,.F.),TRB->ZG_FILIAL } )
	dbSkip()
End

TRB->(dbCloseArea())
	
CONOUT("#MXML004 -> TOTAL DE OS PARA PROCESSAMENTO: " +CVALTOCHAR(Len(aOSPend)) )

For nI := 1 to Len(aOsPend)
	fProcXml( aOSPend[nI][1],aOSPend[nI][2],aOSPend[nI][3] )	
Next nI


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkFat   บAutor  ณJackson E. de Deus   บ Data ณ  22/03/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se alguem esta usando a rotina de faturamento     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkFat(cUserTT)

Local lMat460On := .F.
Local aConn := {}
Local nPos := 0
Local nTConn := 0
Local nJ

aConn := U_CONNUSR()
For nJ := 1 To Len(aConn)
	nPos := AScan( aConn[nJ], {|x|, "MATA460" $ x[11] /*.OR. "MATA240" $ x[11] .OR. "MATA241" $ x[11]*/ } )
	If nPos > 0
		lMat460On := .T.
		cUserTT := aConn[nJ][nPos][1]
		nTConn := aConn[nJ][nPos][3]
		Exit
	EndIf
Next nJ	

Return lMat460On


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfProcXml   บAutor  ณJackson E. de Deus บ Data ณ  22/01/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa a Ordem de servico                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fProcXml(cOSMobile,lNovo,cCodFil)

Local lOk := .T.
Local cXml := ""
Local cMsgErro := ""
Local cPathRet := "\_mobile\mobile\data_receive\"
Local cHrIni := ""
Local cHrFim := ""

dbSelectArea("SZG")
dbSetOrder(1)
If !MsSeek( cCodFil +AvKey(cOSMobile,"ZG_NUMOS") )
	Return
EndIf

If !Empty(SZG->ZG_PROC)
	Return
EndIf

// Xml vazio - procura arquivo xml com respostas              
If !Empty(SZG->ZG_RESPOST)
	cXml := SZG->ZG_RESPOST
Else
	If lNovo
		If File( cPathRet +AllTrim(SZG->ZG_NUMOS) +".xml" )  
			cXml := MemoRead( cPathRet +AllTrim(SZG->ZG_NUMOS) +".xml" )
		Else
			Conout("#MXML004 -> XML DE RESPOSTAS INVALIDO")
			Return		
		EndIf
	Else 
		If File( cPathRet +AllTrim(SZG->ZG_NUMOS) +"_" +"xml_os.xml" )  
			cXml := MemoRead( cPathRet +AllTrim(SZG->ZG_NUMOS) +"_" +"xml_os.xml" )
		Else
			Conout("#MXML004 -> XML DE RESPOSTAS INVALIDO")
			Return		
		EndIf
	EndIf

EndIf
                                                                            
cHrIni := Time()
CONOUT( "#MXML004 -> INICIANDO O PROCESSAMENTO DA OS " +AllTrim(cOsMobile) )

BEGIN SEQUENCE
	cFilAnt := cCodFil
	U_MXML003(SZG->ZG_NUMOS)
RECOVER
	CONOUT("#MXML004 -> ERRO AO PROCESSAR A OS " +AllTrim(cOsMobile))
END SEQUENCE

cHrFim := Time()
CONOUT( "#MXML004 -> FINALIZOU O PROCESSAMENTO DA OS " +AllTrim(cOsMobile) +" - TEMPO: " +ElapTime(cHrIni,cHrFim) )     

// indicadores
U_TTPROC35(cCodFil,SZG->ZG_NUMOS,cXml)


// enviar email de leituras para o cliente
U_TTPROC95()

Return lOk