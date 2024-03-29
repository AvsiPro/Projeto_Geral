#include "topconn.ch"

// validacao de campos
User Function TTFINC17(cCampo,cValor)

Local lRet := .T.
Local aDados := {}
Local cLaccMoe := ""
Local LaccCed := ""

Local nPosChapa := Ascan(aHeader,{|x|AllTrim(x[2])=="ZN_PATRIMO"})
Local nPosCli := Ascan(aHeader,{|x|AllTrim(x[2])=="ZN_CLIENTE"})
Local nPosLoja := Ascan(aHeader,{|x|AllTrim(x[2])=="ZN_LOJA"})
Local nPosRota := Ascan(aHeader,{|x|AllTrim(x[2])=="ZN_ROTA"})
Local nPosData := Ascan(aHeader,{|x|AllTrim(x[2])=="ZN_DATA"})
Local nPosBanan := Ascan(aHeader,{|x|AllTrim(x[2])=="ZN_BANANIN"})
 
Local cNumChapa := aCols[n][nPosChapa]
Local cCodCli := aCols[n][nPosCli]
Local cLoja := aCols[n][nPosLoja]
Local cCodRota := aCols[n][nPosRota]
Local dData := aCols[n][nPosData]

//Local cCorLacre := M->ZF_CORLACR aheader


/*
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿎ampo ZN_LACRMOE - Lacre retirado moeda                                                �
//쿌o digitar, ver ultimo lacre incluido (ZN_LACCMOE) desse patrimonio antes da data atual�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
*/
If cCampo == "ZN_LACRMOE"
	If !IsInCallStack("U_TTPROC15")
		Return lRet
	EndIf
	
	cQuery := "SELECT TOP 1 ZN_DATA, ZN_PATRIMO,ZN_CLIENTE, ZN_LOJA,ZN_LACCMOE FROM " +RetSqlName("SZN") +" SZN "
	cQuery += "WHERE ZN_FILIAL = '"+xFilial("SZN")+"' "
	cQuery += "AND ZN_PATRIMO = '"+cNumChapa+"' "
	cQuery += "AND ZN_CLIENTE = '"+cCodCli+"' "
	cQuery += "AND ZN_LOJA = '"+cLoja+"' "
	cQuery += "AND ZN_DATA < '"+DtoS(Date())+"' "
	cQuery += "AND D_E_L_E_T_ = '' "
	cQuery += "ORDER BY ZN_DATA DESC "
    
	ExecQuery(cQuery)
	
	If Select("TRBC") > 0
		dbSelectArea("TRBC")
		dbGoTop()
		While !EOF()
			cLaccMoe := TRBC->ZN_LACCMOE
			dbSkip()
		End
	EndIf
	
	If AllTrim(cLaccMoe) <> ""
		If cLaccMoe <> cValor
			Help( ,, "TTFINC17",, "Lan�amento anterior do lacre n�o encontrado.", 1, 0)
		EndIf 
	EndIf

	Return lRet
EndIf



/*
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿎ampo ZN_LACRCED - Lacre retirado cedula                                               �
//쿌o digitar, ver ultimo lacre incluido (ZN_LACCCED) desse patrimonio antes da data atual�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
*/
If cCampo == "ZN_LACRCED"
	If !IsInCallStack("U_TTPROC15")
		Return lRet
	EndIf
	
	cQuery := "SELECT TOP 1 ZN_DATA, ZN_PATRIMO,ZN_CLIENTE, ZN_LOJA,ZN_LACCCED FROM " +RetSqlName("SZN") +" SZN "
	cQuery += "WHERE ZN_FILIAL = '"+xFilial("SZN")+"' "
	cQuery += "AND ZN_PATRIMO = '"+cNumChapa+"' "
	cQuery += "AND ZN_CLIENTE = '"+cCodCli+"' "
	cQuery += "AND ZN_LOJA = '"+cLoja+"' "
	cQuery += "AND ZN_DATA < '"+DtoS(Date())+"' "
	cQuery += "AND D_E_L_E_T_ = '' "
	cQuery += "ORDER BY ZN_DATA DESC "
    
	ExecQuery(cQuery)
	
	If Select("TRBC") > 0
		dbSelectArea("TRBC")
		dbGoTop()
		While !EOF()
			LaccCed := TRBC->ZN_LACCCED
			dbSkip()
		End
	EndIf
	
	If AllTrim(LaccCed) <> ""
		If LaccCed <> cValor
			Help( ,, "TTFINC17",, "Lan�amento anterior do lacre n�o encontrado.", 1, 0)
		EndIf 
	EndIf

	Return lRet
EndIf




/*
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿎ampo ZN_BANANIN - Bananinha                                                           �
//쿣er na SZF se para esta rota neste dia, esta bananinha esta no range (SZF->ZF_ENVELOP).�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
*/
If cCampo == "ZN_BANANIN"
	If !IsInCallStack("U_TTPROC15")
		Return lRet
	EndIf
	
	cQuery := "SELECT COUNT(*) TOTAL FROM " +RetSqlName("SZF") +" SZF "
	cQuery += "WHERE ZF_FILIAL = '"+xFilial("SZF")+"' "
	cQuery += "AND ZF_PATRIMO = '"+cNumChapa+"' "
	cQuery += "AND ZF_ROTA = '"+cCodRota+"' "
	cQuery += "AND ZF_DATA = '"+DtoS(dData)+"' "
	//cQuery += "AND ZF_ENVELOP = '"++"' "		//ACERTAR -> ZN_BANANIN - como fazer para verificar o range se na ZN possuo apenas um campo?
	cQuery += "AND D_E_L_E_T_ = '' "
	cQuery += "ORDER BY ZN_DATA DESC "
    
	ExecQuery(cQuery)
	
	If Select("TRBC") > 0
		dbSelectArea("TRBC")
		dbGoTop()
		While !EOF()
			nCount := TRBC->TOTAL
			dbSkip()
		End
	EndIf
	
	If nCount == 0
		Help( ,, "TTFINC17",, "Bananinha n�o encontrada no itinerario da tesouraria do dia.", 1, 0)
	EndIf

	Return lRet
EndIf 



/*
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿎ampo ZN_LACCMOE - Lacre colocado moeda�
//쿣er se esta na SZF (SZF->ZF_LACRE)     �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
*/
If cCampo == "ZN_LACCMOE"
	If !IsInCallStack("U_TTPROC15")
		Return lRet
	EndIf
	
	cQuery := "SELECT COUNT(*) TOTAL FROM " +RetSqlName("SZF") +" SZF "
	cQuery += "WHERE ZF_FILIAL = '"+xFilial("SZF")+"' "
	cQuery += "AND ZF_PATRIMO = '"+cNumChapa+"' "
	cQuery += "AND ZF_ROTA = '"+cCodRota+"' "
	cQuery += "AND ZF_DATA = '"+DtoS(dData)+"' "
	cQuery += "AND ZN_LACCMOE = '"+cLaccMoe+"' "
	cQuery += "AND D_E_L_E_T_ = '' "
	cQuery += "ORDER BY ZN_DATA DESC "
    
	ExecQuery(cQuery)
	
	If Select("TRBC") > 0
		dbSelectArea("TRBC")
		dbGoTop()
		While !EOF()
			nCount := TRBC->TOTAL
			dbSkip()
		End
	EndIf
	
	If nCount == 0
		Help( ,, "TTFINC17",, "Lacre n�o encontrado no itinerario da tesouraria do dia.", 1, 0)
	EndIf
	
	Return lRet
EndIf



/*
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴훐ula8�
//쿎ampo ZN_LACCCED - Lacre colocado cedula�
//쿣er se esta na SZF                      �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴훐ula8�
*/
If cCampo == "ZN_LACCCED"
	If !IsInCallStack("U_TTPROC15")
		Return lRet
	EndIf
	
	cQuery := "SELECT COUNT(*) TOTAL FROM " +RetSqlName("SZF") +" SZF "
	cQuery += "WHERE ZF_FILIAL = '"+xFilial("SZF")+"' "
	cQuery += "AND ZF_PATRIMO = '"+cNumChapa+"' "
	cQuery += "AND ZF_ROTA = '"+cCodRota+"' "
	cQuery += "AND ZF_DATA = '"+DtoS(dData)+"' "
	cQuery += "AND ZN_LACCCED = '"+LaccCed+"' "
	cQuery += "AND D_E_L_E_T_ = '' "
	cQuery += "ORDER BY ZN_DATA DESC "
    
	ExecQuery(cQuery)
	
	If Select("TRBC") > 0
		dbSelectArea("TRBC")
		dbGoTop()
		While !EOF()
			nCount := TRBC->TOTAL
			dbSkip()
		End
	EndIf
	
	If nCount == 0
		Help( ,, "TTFINC17",, "Lacre n�o encontrado no itinerario da tesouraria do dia.", 1, 0)
	EndIf
	
	Return lRet
EndIf


/*
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�0�
//쿎ampo ZN_LACRE                      �
//쿣er se esta na SZF (SZF->ZF_CORLACR)�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�0�
*/
If cCampo == "ZN_LACRE"
	If !IsInCallStack("U_TTPROC15")
		Return lRet
	EndIf
	
	cQuery := "SELECT COUNT(*) TOTAL FROM " +RetSqlName("SZF") +" SZF "
	cQuery += "WHERE ZF_FILIAL = '"+xFilial("SZF")+"' "
	cQuery += "AND ZF_PATRIMO = '"+cNumChapa+"' "
	cQuery += "AND ZF_ROTA = '"+cCodRota+"' "
	cQuery += "AND ZF_DATA = '"+DtoS(dData)+"' "
	cQuery += "AND ZN_LACRE = '"+cCorLacre+"' "
	cQuery += "AND D_E_L_E_T_ = '' "
	cQuery += "ORDER BY ZN_DATA DESC "
    
	ExecQuery(cQuery)
	
	If Select("TRBC") > 0
		dbSelectArea("TRBC")
		dbGoTop()
		While !EOF()
			nCount := TRBC->TOTAL
			dbSkip()
		End
	EndIf
	
	If nCount == 0
		Help( ,, "TTFINC17",, "Lacre com essa cor n�o encontrado no itinerario da tesouraria do dia.", 1, 0)
	EndIf
	
	Return lRet
EndIf


Return lRet




                
// Executa a Query
Static Function ExecQuery(cQuery)

cQuery := ChangeQuery(cQuery)

If Select("TRBC") > 0
	TRBC->(dbCloseArea())
EndIf                   

TcQuery cQuery New Alias "TRBC"


Return