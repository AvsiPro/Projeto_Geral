#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTTMKA08 บAutor  ณJackson E. de Deus   บ Data ณ  06/27/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณJob de envio de email.                                      บฑฑ
ฑฑบ          ณVerifica os atendimentos atrasados e dispara os emails.     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTTMKA08(cEmp, cFil)

Local lVldFields	:= .F.
Local aFields		:= {}                  
Local cNumAtend		:= ""
Local cTarget		:= ""
Local nPosOperad	:= 5
Local nPosSLA		:= 11
Local cCodFil		:= ""
Local cNumAtend		:= ""
Local aCabMail		:= {}
Local aItens		:= {}
Local cArqMail		:= ""
Local cRemete		:= ""
Local cSubject		:= ""
Local aAttach		:= {}
Local nI
Local lEstourou		:= .F.
Local lFim			:= {}
Local cHora			:= ""
Local dDtFim
Local dDtAtual
Private aInfoSeq	:= {}
Private cAssOMM 	:= ""
Private aDados		:= {}
Private cHoras		:= ""
Private lAgInsRem	:= .F.
Private lExpirou	:= .F.
Default cEmp		:= "01"
Default cFil		:= "01"

If cEmpAnt <> "01"
	Return
EndIf

ConOut("OMM: Iniciando Job de envio de emails - Atendimentos atrasados")

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณConsidera somente dias: seg - sex ณ
//ณe  horario das 08:00h - 18:00h    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/
If CValToChar(Dow(Date())) $ "1|7"
	Return
EndIf

cHora := Time()
If cHora < "08:00:00" .Or. cHora > "18:00:00"
	Return
EndIf


// Verifica funcoes no repositorio
If !FindFunction("U_TTTMKA09")
	ConOut("TTTMKA08, Funcao U_TTTMKA09 nao compilada no repositorio. Nao sera possivel continuar.")	  
	Return
EndIf

// Prepara o corpo do email
If !FindFunction("U_TTTMKA07")
	ConOut("TTTMKA08, Funcao U_TTTMKA07 nao compilada no repositorio. Nao sera possivel continuar.")	  
	Return
EndIf

// Envia o email
If !FindFunction("U_TTMAILN")
	ConOut("TTTMKA08 ,Funcao U_TTMAILN nao compilada no repositorio. Nao sera possivel continuar.")
	Return
EndIf


ConOut("Iniciando empresa "+cEmp +" Filial " +cFil)
RpcSetType(3)
RpcSetEnv(cEmp,cFil)

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ•ฝ•ฝฟ
//ณVerifica existencia dos campos customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ•ฝ•ฝู
*/
AADD(aFields, {"SUD"})	//[1]
AADD(aFields, {"SZ9"})	//[1]
AADD(aFields[1], {"UD_XTAREF",;	//[1][2][1]
				"UD_XTARSEQ",;
				"UD_XTARDT",;
				"UD_XTARHR"})
				
AADD(aFields[2], {"Z9_SEQ",;	//[1][2][1]
				"Z9_SLA"})

If FindFunction("U_TTTMKA06")
	lVldFields := U_TTTMKA06(aFields)
	If ValType(lVldFields) == "L"
		If !lVldFields
			Return
		EndIf
	EndIf	
EndIf

cAssOMM := SuperGetMV("MV_XTMK002",.T.,"")

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณBusca os dados dos atendimentosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/
BuscaDados(@aDados)

If Len(aDados) > 0
	For nI := 1 To Len(aDados)
		// Passa somente pelo primeiro item de cada atendimento
		If aDados[nI][2] == cNumAtend
			Loop
		EndIf
		
		cCodFil		:= aDados[nI][1]
		cNumAtend	:= aDados[nI][2]
		cTarget		:= AllTrim(UsrRetMail(aDados[nI][nPosOperad])) 

		/*
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤtฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤocaolฟ
		//ณCaso seja a tarefa de informar o Patrimonio, verificar a data agendada de instalacao/remocaoณ
		//ณCaso falte apenas 3 ou menos dias para chegar nessa data, estourou o SLA                    ณ
		//ณSolicitacao do Valtinho                                                                     ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤocaolู
		*/
		If AllTrim(aDados[nI][14]) $ "1|3" .And. aDados[nI][13] <> ""
			dDtFim := sTOd(aDados[nI][13])
			dDtAtual := Date()
			
			// Ultrapassou a data informada (data agendada para instalacao/remocao)
			If dDtAtual >= dDtFim
				nSlaTarefa := 0
				lAgInsRem := .T.
				lExpirou := .T.
			EndIf
			// Data agendada - data atual
			If DDtFim - dDtAtual < 3 // diferenca dos dias
				nSlaTarefa := 0
				lAgInsRem := .T.
			EndIf
		Else
			nSLATarefa	:= aDados[nI][12]
		EndIf
		
		// Se for sequencia 1, considera como data e hora a abertura do atendimento
		If aDados[nI][9] == "001"
			cDtIni := StoD(aDados[nI][6])
			cHrIni := aDados[nI][7]
		// Caso seja sequencia a partir de 002, considera data e hora do grid - item
		Else
			cDtIni := StoD(aDados[nI][10])
			cHrIni := aDados[nI][11]
		EndIf
		
		//Se SLA esta estourado (pode ser por causa do calculo do agendamento da instalacao, solicitado pelo Valtinho)
		If nSlaTarefa == 0
			lEstourou := .T.
		ElseIf !Empty(cDtIni) .And. !Empty(cHrIni)
			ConOut("Iniciando calculo do atendimento " +cNumAtend)	  
			lEstourou := CalcSLA(cDtIni, cHrIni, nSLATarefa)
		EndIf
	
		If ValType(lEstourou) == "L"
			If lEstourou
				ConOut("**Atendimento " +cNumAtend +" -> ATRASADO**")
				// Prepara variaveis para montagem do corpo do email
				U_TTTMKA09(2,cCodFil,cNumAtend,@aCabMail,@aItens,@aInfoSeq)
                    
    			If ValType(aCabMail) == "A" .And. Valtype(aItens) == "A"
                   	If Len(aCabMail) > 0 .And. Len(aItens) > 0                                   
						// Prepara o corpo do email
						U_TTTMKA07(2,aCabMail,@cArqMail,aItens,.F.,aInfoSeq)
						cRemete := SuperGetMV("MV_RELACNT",.T.,"microsiga",) 
						cSubject := "ATRASADO - Atendimento " +aDados[nI][2] +" realizado pelo CALL CENTER - ATRASADO"
						
						ConOut("Atendimento " +cNumAtend +" -> Enviando E-mail para as a็๕es...")
						// Envia o email
						U_TTMailN(cRemete,cTarget,cSubject,cArqMail,aAttach,.F.)
					EndIf
				EndIf							
			EndIf
		EndIf
		
		cNumAtend := aDados[nI][2]
		cArqMail := ""
		aCabMail := {}
		aItens := {}
		aInfoSeq := {}
		lEstourou := .F. 
		lAgInsRem := .F. 
		lExpirou := .F.   
	Next nI
EndIf

RpcClearEnv()
    
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCalcSLA  บAutor  ณJackson E. de Deus   บ Data ณ  28/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFaz o calculo das horas da tarefa.                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CalcSLA(cDtIni, cHrIni, nSLATarefa)

Local lEstourou 	:= .F.
Local nI
Local cDtAtual
Local cHrAtual		:= ""
Local cHrComIni 	:= ""
Local cHrComFim 	:= ""                                  
Local cHrTot
Local nMinutos
Local nSegundos
Local lFim			:= .F.

// hora comercial - inicio/fim
cHrComIni 	:= SuperGetMV("MV_XTMK007",.T.,"00:00:00")
cHrComFim 	:= SuperGetMV("MV_XTMK008",.T.,"23:59:59")

// Data e hora atuais
cDtAtual := Date()
cHoras	:= ""
		
/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤXฟ
//ณSe o dia atual for igual o dia do inicio da tarefa, somente compara as horasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤXู
*/
If cDtAtual == cDtIni
	cHrAtual	:= Time()
	cHoras		:= ElapTime(cHrIni,cHrAtual)	// horas decorridas desde o inicio da tarefa
	// Prepara a variavel do SLA
	nSLATarefa := PadL(CValToChar(nSLATarefa),2,"0")
	nSLATarefa := nSLATarefa + ":00:00"
	
	If cHoras > CValToChar(nSLATarefa)
		lEstourou := .T.
		Return lEstourou
	EndIf
	
/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤeDฟ
//ณSe o dia atual for maior que o dia do inicio da tarefa,ณ
//ณverifica todos os dias                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤeDู
*/
Else
	// Somente se a data de inicio for anterior a data atual
	If cDtAtual > cDtIni
		cHrAtual := Time()
		For nI := cDtIni To cDtAtual                  
			// se for primeiro dia, calcula hora do inicio da tarefa ate fim do horario comercial
			If nI == cDtIni
				cHrAux := ElapTime(cHrIni, cHrComFim)
				nMinutos := Val(SubStr(cHrAux,4,2))
				nSegundos := Val(SubStr(cHrAux,7,2))
				cHrAux := Val(SubStr(cHrAux,1,2))
				cHoras := cHrAux
				Loop
			// se for dia atual, considera somente ate agora - esse horario                   
			ElseIf nI == cDtAtual
				cHrAux := ElapTime(cHrComIni, cHrAtual)
				nMinutos += Val(SubStr(cHrAux,4,2))
				nSegundos += Val(SubStr(cHrAux,7,2))   
				cHrAux := Val(SubStr(cHrAux,1,2))
				cHoras += cHrAux
				Exit
			Else
				// caso seja um dia intermediario, calcula todo o horario comercial
				cHrAux := ElapTime(cHrComIni, cHrComFim)
				nMinutos += Val(SubStr(cHrAux,4,2))
				nSegundos += Val(SubStr(cHrAux,7,2)) 
				cHrAux := Val(SubStr(cHrAux,1,2))          
				cHoras += cHrAux
			EndIf
			
		Next nI     
		                            
		// Prepara a variavel do total de horas
	//	nTotalHora := (cHoras*3600) + (nMinutos*60+nSegundos)
	//	nTotalHora := nTotalHora/3600
		nTotalHora := cHoras
		// Ajusta os valores de hora, minuto e segundo
		While !lFim
			If nSegundos >= 60
				nMinutos += 1
				nSegundos := nSegundos - 60		
			EndIf
	
			If nMinutos >= 60
				nTotalHora += 1
				nMinutos := nMinutos - 60
			EndIf	
			                 
			If nSegundos <= 59 .And. nMinutos <= 59
				lFim := .T.
			EndIf
		End
		
		// Prepara a variavel de Total de Horas
		nMinutos	:= PadL(CValToChar(nMinutos),2,"0")
		nSegundos	:= PadL(CValToChar(nSegundos),2,"0")
		cHoras		:= CValToChar(cHoras) +":" +CValToChar(nMinutos) +":" +CValToChar(nSegundos)
		
		// Prepara a variavel do SLA
		nSLATarefa := PadL(CValToChar(nSLATarefa),2,"0")
		nSLATarefa := nSLATarefa + ":00:00"
		
		// Se a Qtd de horas desde o inicio da tarefa for maior que o SLA
		// Total horas > SLA
		// 23:43:10 > 12:00:00
		If cHoras > nSLATarefa
			lEstourou := .T.
			Return lEstourou	
		EndIf
    EndIf
EndIf


Return lEstourou




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBuscaDadosบAutor  ณJackson E. de Deus  บ Data ณ  29/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna os dados dos atendimentos atrasados.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function BuscaDados(aDados)

Local cQuery := ""

// monta query
cQuery += "SELECT "										+CRLF
cQuery += "SUD.UD_FILIAL, "								+CRLF
cQuery += "SUD.UD_CODIGO, "								+CRLF
cQuery += "SUD.UD_ITEM, "								+CRLF
cQuery += "SUD.UD_PRODUTO, "							+CRLF
cQuery += "SUD.UD_OPERADO, "							+CRLF
cQuery += "SUC.UC_DATA, "								+CRLF
cQuery += "SUC.UC_FIM, "								+CRLF
cQuery += "SUD.UD_XTAREF, "								+CRLF
cQuery += "SUD.UD_XTARSEQ, "							+CRLF
cQuery += "SUD.UD_XTARDT, "								+CRLF
cQuery += "SUD.UD_XTARHR, "								+CRLF
cQuery += "SUD.UD_XDTINST, "							+CRLF
cQuery += "SZ9.Z9_CONTROL, "							+CRLF
cQuery += "SZ9.Z9_SEQ, "								+CRLF
cQuery += "SZ9.Z9_SLA "									+CRLF
cQuery += "FROM " +RetSqlName("SUD") +" SUD "			+CRLF

cQuery += "INNER JOIN " +RetSqlName("SUC") +" SUC ON "	+CRLF
cQuery += "SUD.UD_FILIAL = SUC.UC_FILIAL "				+CRLF
cQuery += "AND SUD.UD_CODIGO = SUC.UC_CODIGO "			+CRLF
cQuery += "AND SUD.D_E_L_E_T_ = SUC.D_E_L_E_T_ "		+CRLF
cQuery += "AND SUC.UC_CODCANC = '' "					+CRLF // Nao trazer os cancelados
cQuery += "AND SUC.UC_STATUS <> '3' "					+CRLF // somente em aberto

cQuery += "INNER JOIN " +RetSqlName("SZ9") +" SZ9 ON "	+CRLF
cQuery += "SUD.UD_XTAREF = SZ9.Z9_COD "					+CRLF
cQuery += "AND SUD.UD_XTARSEQ = SZ9.Z9_SEQ "			+CRLF
cQuery += "AND SUD.D_E_L_E_T_ = SZ9.D_E_L_E_T_ "		+CRLF

cQuery += "WHERE  "										+CRLF
cQuery += "SUD.UD_STATUS = '1' "						+CRLF
cQuery += "AND SUD.UD_ASSUNTO = '"+cAssOMM+"' "			+CRLF
cQuery += "AND SUD.D_E_L_E_T_ = '' "					+CRLF                     
                
cQuery += "ORDER BY SUD.UD_FILIAL, SUD.UD_CODIGO, SUD.UD_ITEM "

cQuery := ChangeQuery(cQuery)

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf                   

TcQuery cQuery New Alias "TRB"

dbSelectArea("TRB")
dbGoTop()
While !EOF()
	AADD(aDados, {;
				TRB->UD_FILIAL,;	//[1] Filial
				TRB->UD_CODIGO,;	//[2] Codigo
				TRB->UD_ITEM,;		//[3] Item
				TRB->UD_PRODUTO,;	//[4] Produto
				TRB->UD_OPERADO,;	//[5] Operador
				TRB->UC_DATA,;		//[6] Data Inicio Atendimento
				TRB->UC_FIM,;		//[7] Hora Inicio Atendimento
				TRB->UD_XTAREF,;	//[8] Tarefa
				TRB->UD_XTARSEQ,;	//[9] Sequencia
				TRB->UD_XTARDT,;	//[10] Data Inicio da tarefa sequencia a partir da 002
				TRB->UD_XTARHR,;	//[11] Hora Inicio da tarefa a partir da 002
				TRB->Z9_SLA,;		//[12] SLA da tarefa
				TRB->UD_XDTINST,;	//[13] Data agendada da instalacao/remocao
				TRB->Z9_CONTROL})	//[14] Controle
	dbSkip()
End
dbCloseArea()


Return