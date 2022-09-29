
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CONNUSR     �Autor  �Jackson E. de Deus� Data �  09/02/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna informacoes de usuarios conectados no sistema      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CONNUSR()

Local oRpcSrv
Local aServers := {}
Local aInfo := {}
Local aConn := {}
Local nI

If "HOM" $ GetEnvServer() .OR. "JVVXC9_NOVO" == GetEnvServer()
	AADD(aServers, {"189.36.48.134",10145,"JVVXC9_HOM"} )	
	AADD(aServers, {"189.36.48.134",10145,"JVVXC9_NOVO"} )	
Else
	AADD(aServers, {"189.36.48.135",10131,"JVVXC9"} )
	AADD(aServers, {"189.36.48.135",10132,"JVVXC9"} )
	AADD(aServers, {"189.36.48.135",10133,"JVVXC9"} )
	AADD(aServers, {"189.36.48.135",10134,"JVVXC9"} )
	AADD(aServers, {"189.36.48.135",10135,"JVVXC9"} )
	AADD(aServers, {"189.36.48.135",10137,"SCHEDULE"} )
	AADD(aServers, {"189.36.48.135",10141,"JVVXC9_WS"} )
EndIf

For nI := 1 To Len(aServers)
	aInfo := {}
	
	oRpcSrv := TRpc():New( aServers[nI][3] )
	If ( oRpcSrv:Connect( aServers[nI][1], aServers[nI][2] ) )
 
	    aInfo := oRpcSrv:CallProcEX("GetUserInfoArray")
		If !Empty(aInfo)
			AADD( aConn, aInfo )
		EndIf

    	oRpcSrv:Disconnect()
	Endif
Next nI

Return aConn