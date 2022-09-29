#include "protheus.ch"
#include "topconn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTTMKA13  บAutor  ณJackson E. de Deus  บ Data ณ  11/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida patrimonio digitado no campo UD_XNPATRI.             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTTMKA13()
           
Local lRet := .F.
Local nPosChapa
Local nPosProd
Local cCodCli := ""
Local cLojaCli := "" 
Local cNumAtend := ""
Local cOcorr := ""
Local cOcorrIns := If(cEmpAnt == "01",SuperGetMv("MV_XTMK003",.T.,""),"")
Local cOcorrRem := If(cEmpAnt == "01",SuperGetMv("MV_XTMK004",.T.,""),"")
Local cOcorrTran := If(cEmpAnt == "01",SuperGetMv("MV_XTMK012",.T.,""),"")
Local cProd := ""
Local cPatrim := ""
Local cStatusN1 := ""
Local aStatus := {}
Local nRecPatri := 0

If cEmpAnt <> "01"
	lRet := .T.
	Return(lRet)
EndIf

If IsIncallStack("U_TTTMKA31")
	Return .T.
EndIf

AADD(aStatus, {"1","Disponivel" })
AADD(aStatus, {"2","Em transito" })
AADD(aStatus, {"3","Em cliente" })
AADD(aStatus, {"4","Manutencao" })
AADD(aStatus, {"5","Empenhado" })
AADD(aStatus, {"6","Em remocao" }) 
AADD(aStatus, {"7","Em Transferencia" })
 
nPosProd := Ascan(aHeader,{|x|AllTrim(x[2])=="UD_PRODUTO"})
nPosChapa := Ascan(aHeader,{|x|AllTrim(x[2])=="UD_XNPATRI"}) 

cNumAtend := SUD->UD_CODIGO
cOcorr := Posicione("SUD",1,xFilial("SUD")+cNumAtend,"UD_OCORREN")

dbSelectArea("SUC")
cCodCli := SubStr(SUC->UC_CHAVE,1,6)
cLojaCli := SubStr(SUC->UC_CHAVE,7,4)

If IsIncallStack("U_TTTMKA04")
	cProd := oMsGD:Acols[oMsGD:nAt,nPosProd]	
Else                                             
	cProd := aCols[n][nPosProd]  
EndIf   
cPatrim := M->UD_XNPATRI 

If AllTrim(cPatrim) == ""
	Return .F. 
EndIf         
 
/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica existencia do patrimonio e faz o tratamento adequadoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/
dbSelectArea("SN1")
dbSetOrder(2)	// filial + chapa
//If dbSeek(xFilial("SN1")+AvKey(cPatrim,"N1_CHAPA"))
// BUSCA O RECNO DO PATRIMONIO
nRecPatri := U_TTTMKA19(cPatrim)
If nRecPatri <> 0
	SN1->( dbGoTo(nRecPatri) )
	If SN1->N1_PRODUTO == cProd 
		// Se for instalacao, considera somente maquinas disponiveis
		If cOcorr == cOcorrIns .Or. cOcorr == cOcorrTran
			If AllTrim(SN1->N1_XCLIENT) == '' .And. AllTrim(SN1->N1_XLOJA) == '' .And. AllTrim(SN1->N1_XSTATTT) == '1'
				lRet := .T.
			// Caso nao esteja disponivel, prepara mensagem de aviso para o usuario
			Else
				cMensagem := "O patrim๔nio nใo estแ disponํvel." +CRLF              
				If AllTrim(SN1->N1_XSTATTT) <> ""
					cStatusN1 := AllTrim(SN1->N1_XSTATTT)
					For nI := 1 To Len(aStatus)
						If aStatus[nI][1] == cStatusN1   
							cDescricao := aStatus[nI][2]
							cMensagem += "Status: " + cDescricao +CRLF
							Exit
						EndIf
					Next nI
				EndIf
				
				If AllTrim(SN1->N1_XCLIENT) <> "" .And. AllTrim(SN1->N1_XLOJA) <> ""
					cMensagem += "Local atual: " +CRLF
					cMensagem += "Cliente: " +SN1->N1_XCLIENT +CRLF
					cMensagem += "Loja: " +SN1->N1_XLOJA +CRLF					
				EndIf
				Aviso("TTTMKA13",cMensagem,{"Ok"},2)	
				MSGALERT(CMENSAGEM)
			EndIf
		// Se for remocao, considera somente maquinas que estao nesse cliente
		ElseIf cOcorr == cOcorrRem
			If SN1->N1_XCLIENT == cCodCli .And. SN1->N1_XLOJA == cLojaCli .And. AllTrim(SN1->N1_XSTATTT) == '3'
				lRet := .T.
			Else
				cMensagem := "O patrim๔nio nใo estแ no cliente." +CRLF              
				If AllTrim(SN1->N1_XSTATTT) <> ""
					cStatusN1 := AllTrim(SN1->N1_XSTATTT)
					For nI := 1 To Len(aStatus)
						If aStatus[nI][1] == cStatusN1   
							cDescricao := aStatus[nI][2]
							cMensagem += "Status: " + cDescricao +CRLF
							Exit
						EndIf
					Next nI
				EndIf
				
				If AllTrim(SN1->N1_XCLIENT) <> "" .And. AllTrim(SN1->N1_XLOJA) <> ""
					cMensagem += "Local atual" +CRLF
					cMensagem += "Cliente: " +SN1->N1_XCLIENT +CRLF
					cMensagem += "Loja: " +SN1->N1_XLOJA +CRLF					
				EndIf
				Aviso("TTTMKA13",cMensagem,{"Ok"},2)	
				MSGALERT(CMENSAGEM)
					
			EndIf
		EndIf
	Else
		cMensagem := "Patrim๔nio invแlido." +CRLF
		If AllTrim(SN1->N1_PRODUTO) <> ""
			cMensagem += "Jแ vinculado em um produto diferente. " +CRLF
			cMensagem += "Produto " +AllTrim(SN1->N1_PRODUTO) +" " +AllTrim(GetAdvFVal("SB1","B1_DESC",xFilial("SB1")+SN1->N1_PRODUTO,1,"")) +CRLF
		EndIf
		cMensagem += "Insira um n๚mero de patrim๔nio vแlido para esse produto."
		MSGALERT(CMENSAGEM)
		Aviso("TTTMKA13",cMensagem,{"Ok"},2)	 			
	EndIf                                                                                                         
Else	
	Aviso("TTTMKA13","Patrim๔nio inexistente." +CRLF +"Insira um n๚mero de patrim๔nio vแlido para esse produto.",{"Ok"})	 			
	MSGALERT("Patrim๔nio inexistente." +CRLF +"Insira um n๚mero de patrim๔nio vแlido para esse produto.")
EndIf

dbSelectArea("SUD")


Return lRet