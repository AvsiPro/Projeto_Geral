
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO12    บAutor  ณMicrosiga           บ Data ณ  07/28/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MBM008(Armazem,Produto)

           
Local cJson := ""
Local oObj := Nil
Local nSaldo := 0
Local cArmazem := ""
Local cQuery := ""

If cEmpAnt <> "01"
	Return
EndIf

If SubStr(Armazem,1,1) == "P"
	cArmazem := "A" +SubStr( Armazem,2 )
Else
	cArmazem := Armazem
EndIf


// CONSULTA ROTA
If SubStr(cArmazem,1,1) == "R"
	cQuery := "SELECT SUM(Z7_QATU) SALDO "
	cQuery += " FROM "+RetSQLName("SZ7")+" Z7"
	cQuery += " WHERE Z7_FILIAL = '"+xFilial("SZ7")+"' AND Z7_ARMMOV = '"+cArmazem+"' AND Z7_COD = '"+Produto+"' "
	cQuery += " AND Z7_STATUS IN ('1','2') "
	cQuery += " AND Z7_RETORNO = '' "
	cQuery += " AND Z7.D_E_L_E_T_ = '' "
	
	MpSysOpenQuery( cQuery, "TRB" )
	dbSelectArea("TRB")
	If !EOF()
		nSaldo := TRB->SALDO
	EndIf
	TRB->(dbCloseArea())
Else
	dbSelectArea("SZ6")
	dbSetOrder(1)	// LOCAL PRODUTO
	If MSSeek( xFilial("SZ6") +AvKey(cArmazem,"Z6_LOCAL") +AvKey(Produto,"Z6_COD")  )
		nSaldo := SZ6->Z6_QATU	
	EndIf
EndIf
 


oObj := JsonObject():New()
oObj:PutVal("status","ok")
oObj:PutVal("result",nSaldo)
cJson := oObj:ToJson()

Return cJson