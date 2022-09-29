#include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTXCC    บAutor  ณJackson E. de Deus   บ Data ณ  04/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณSincronizacao entre Protheus x CCartoes                     บฑฑ
ฑฑบ          ณDepende de configuracao do Link no ODBC e DbAcess           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTXCC()

//prepare environment empresa "01" filial "01"
If cEmpAnt <> "01"
	Return
EndIf

If !MsgYesNo("Deseja executar a sincroniza็ใo entre Protheus x CCart๕es?")
	Return
EndIf
    
MsAguarde({ || ExecP() },"Aguarde, sincronizando...")

//reset Environment
 
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExecP     บAutor  ณJackson E. de Deus  บ Data ณ  08/10/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Executa a sincronizacao                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ExecP()

Local cDBOra	:= "MSSQL/CCARTOES"	// alias DBACESS
Local cSrvOra	:= "192.168.255.7"
Local nPort		:= 8001
Local nHndOra
Local cProcd	:= "SP_ITF_AtualizaPatrimonio_Movimento"

CursorWait()
MsProcTxt("Abrindo conexใo..")
nHndOra := TcLink(cDbOra,cSrvOra,8001)
If nHndOra < 0
	MsProcTxt("Erro na conexใo..")
    UserException("Erro ("+srt(nHndOra,4)+") ao conectar com "+cDbOra+" em "+cSrvOra)
Else
	MsProcTxt("Conexใo ok..")
	conout("CCARTOES conectado - Handler"+str(nHndOra,4))
	                   
	MsProcTxt("Verificando procedure..")
	If TCSPExist(cProcd)
	
		MsProcTxt("Executando procedure..")
		aResult := TCSPEXEC(cProcd)
		If !empty(TcSqlError())  
			MsProcTxt("Erro na execu็ใo da procedure.." +TcSqlError())
			Conout('Erro na execu็ใo da Stored Procedure : '+TcSqlError())
		Else
			MsProcTxt("Execu็ใo ok..")
			MsgInfo("Sincroniza็ใo completa")
		EndIf
	Else
		MsgAlert("Procedure nใo encontrada no banco de dados do CCart๕es!" +CRLF +"Entre em contato com o Depto de TI")	
	EndIf

	MsProcTxt("Desconectando..")	
	TcUnlink(nHndOra)           
	
	MsProcTxt("Desconectado..")
	conout("CCARTOES desconectado.")
EndIf

CursorArrow()

Return 