#include "protheus.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMBM003    บAutor  ณJackson E. de Deus  บ Data ณ  12/10/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Geracao do mapa de maquina	                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MBM003(Maquina,cFile,Atendente,cRetorno) 
           
Local lRet := .T.
Local nHandle := 0
Local aLinArq := {}
Local aLinhas := {}
Local nVersao := 0
Local cQuery := ""
Local nI
Local cModelo := ""
Local cCodCli := ""
Local cLoja	:= ""
Local cMail := GetMV("MV_XMB003")

If cEmpAnt <> "01"
	Return
EndIf

// consistencias
dbSelectArea("SN1")
dbSetOrder(2)
If !msSeek( xFilial("SN1") +AvKey(Maquina,"N1_CHAPA") )
	lRet := .F.
	cRetorno := "Mแquina invแlida!"
Else	
	cModelo := SN1->N1_PRODUTO
	cCodCli := SN1->N1_XCLIENT
	cLoja	:= SN1->N1_XLOJA
		                     
	nHandle := FT_FUse(cFile)
	If nHandle <> -1	
		FT_FGoTop()     
		While !FT_FEOF()
			aLinArq := StrToKarr(FT_FReadLn(),";")
			           
			AADD( aLinhas, aLinArq )
			
			FT_FSKIP()
		End
		FT_FUSE()
		
		nVersao := 0
		
		If !Empty(aLinhas)
		
			// valida produtos
			dbSelectArea("SB1")
			dbSetOrder(1)
			For nI := 1 To Len(aLinhas)
				If !MsSeek( xFilial("SB1") +AvKey(aLinhas[nI][5],"B1_COD") )
					lRet := .F.
					cRetorno := "Produto invแlido! -> " +AllTrim(aLinhas[nI][5])
					Exit
				EndIf			
			Next nI
			
			If lRet
				// ultima versao do mapa dessa maquina
				cQuery := "SELECT ZH_VERSAO FROM SZH010 WHERE ZH_CHAPA = '"+Maquina+"' AND D_E_L_E_T_ = '' ORDER BY ZH_VERSAO DESC "
				If Select("TRBZ") > 0
					TRBZ->(dbCloseArea())
				EndIf
				
				TcQuery cQuery New Alias "TRBZ"
				If !EOF()
					nVersao := Val(TRBZ->ZH_VERSAO)
				EndIf
				
				nVersao++
				                   
				Begin Transaction
					dbSelectArea("SZH")
					For nI := 1 To Len(aLinhas)
						RecLock("SZH",.T.)
						SZH->ZH_FILIAL	:= xFilial("SZH")
						SZH->ZH_CHAPA	:= Maquina
						SZH->ZH_CODMAQ	:= cModelo
						SZH->ZH_CLIENTE	:= cCodCli
						SZH->ZH_LOJA	:= cLoja
						SZH->ZH_BANDEJA	:= cvaltochar(aLinhas[nI][1])
						SZH->ZH_MOLA	:= aLinhas[nI][2]
						SZH->ZH_TIPOMOL	:= aLinhas[nI][3]
						SZH->ZH_QUANT	:= Val(aLinhas[nI][4])
						SZH->ZH_CODPROD	:= aLinhas[nI][5]
						SZH->ZH_VERSAO	:= cvaltochar(nVersao)
						SZH->ZH_STATUS	:= "2"	// em aprovacao
						SZH->ZH_MSBLQL	:= "2"	// nao bloqueado
						SZH->ZH_USUARIO	:= "M|" +Atendente
						MsUnLock()
					Next nI
					U_TTMAILN('microsiga@toktake.com.br', cMail, "Novo mapa de mแquina - " +Maquina, "Acabamos de receber um novo mapa de mแquina! Assim que puder verifique pois ele estแ pendente de aprova็ใo.<br> Patrim๔nio: "+Maquina , {},.F.)
				End Transaction
			EndIf	
		EndIf
	EndIf 

	cRetorno := "Mapa recebido com sucesso! :)"
EndIf	


Return lRet