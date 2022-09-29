
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦SF1100E()  ¦ Autor ¦ Ricardo Souza	¦ Data ¦21.05.2010¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ PONTO DE ENTRADA  EXECUTADO NA HORA DO ESTORNO DA NOTA 	  ¦¦¦
¦¦¦	     	 ¦ FISCAL DE ENTRADA LIMPA OS CAMPOS CRIADOS NA SF1.	      ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ COMPRAS                                                    ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

User Function SF1100E()

Local cQuery		:= ""
Local CRLF     		:= CHR(13)
Local aAreaSF1 		:= SF1->(GetArea())
Local lAtivaOS		:= If(cEmpAnt == "01",SuperGetMV("MV_XWSKP018",.T.,.T.),"")	// Se esta ativo o uso do WS
Local cEmpRegra		:= ""

If SM0->M0_CODIGO $ "01"
	IF 	GETMV("MV_XDIVNF")==.T.
		RecLock("SF1",.F.)		
			SF1->F1_XSTDIV:=""
		MsUnLock()
	ENDIF	
	
	Begin Transaction
		cQuery :="  UPDATE "+RetSqlName("SZ4") +"  "+CRLF
		cQuery +="  	SET " + RetSqlName("SZ4") + ".D_E_L_E_T_ = '*' "+CRLF  
		cQuery +="  WHERE Z4_CHAVENF = '"+ SF1->(F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA + F1_TIPO) +"' "+CRLF
		clsql:=	TcSqlExec(cQuery)
	End Transaction
	SZ4->(DbCommit())
	
	
	// Verifica se a NF possui OS gerada no Equipe Remota
	If lAtivaOS
		// Empresas que utilizam o recurso
		cEmpRegra	:= SuperGetMV("MV_XWSK011",.T.,"") 
		
		// Se a empresa esta parametrizada para utilizar esse recurso
		If SM0->M0_CODIGO $ cEmpRegra
			If FindFunction("U_TTCOMC09")
				//U_TTCOMC09(,,4)  
			EndIf  
		EndIf
	EndIf
EndIf	
			
RestArea(aAreaSF1)
	
Return