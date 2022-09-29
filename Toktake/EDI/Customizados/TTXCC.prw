#include "tbiconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTXCC    �Autor  �Jackson E. de Deus   � Data �  04/09/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Sincronizacao entre Protheus x CCartoes                     ���
���          �Depende de configuracao do Link no ODBC e DbAcess           ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTXCC()

//prepare environment empresa "01" filial "01"
If cEmpAnt <> "01"
	Return
EndIf

If !MsgYesNo("Deseja executar a sincroniza��o entre Protheus x CCart�es?")
	Return
EndIf
    
MsAguarde({ || ExecP() },"Aguarde, sincronizando...")

//reset Environment
 
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ExecP     �Autor  �Jackson E. de Deus  � Data �  08/10/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Executa a sincronizacao                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ExecP()

Local cDBOra	:= "MSSQL/CCARTOES"	// alias DBACESS
Local cSrvOra	:= "192.168.255.7"
Local nPort		:= 8001
Local nHndOra
Local cProcd	:= "SP_ITF_AtualizaPatrimonio_Movimento"

CursorWait()
MsProcTxt("Abrindo conex�o..")
nHndOra := TcLink(cDbOra,cSrvOra,8001)
If nHndOra < 0
	MsProcTxt("Erro na conex�o..")
    UserException("Erro ("+srt(nHndOra,4)+") ao conectar com "+cDbOra+" em "+cSrvOra)
Else
	MsProcTxt("Conex�o ok..")
	conout("CCARTOES conectado - Handler"+str(nHndOra,4))
	                   
	MsProcTxt("Verificando procedure..")
	If TCSPExist(cProcd)
	
		MsProcTxt("Executando procedure..")
		aResult := TCSPEXEC(cProcd)
		If !empty(TcSqlError())  
			MsProcTxt("Erro na execu��o da procedure.." +TcSqlError())
			Conout('Erro na execu��o da Stored Procedure : '+TcSqlError())
		Else
			MsProcTxt("Execu��o ok..")
			MsgInfo("Sincroniza��o completa")
		EndIf
	Else
		MsgAlert("Procedure n�o encontrada no banco de dados do CCart�es!" +CRLF +"Entre em contato com o Depto de TI")	
	EndIf

	MsProcTxt("Desconectando..")	
	TcUnlink(nHndOra)           
	
	MsProcTxt("Desconectado..")
	conout("CCARTOES desconectado.")
EndIf

CursorArrow()

Return 