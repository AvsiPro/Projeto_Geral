#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTTMKA09  บAutor  ณJackson E. de Deus  บ Data ณ  06/29/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrepara o Array de Cabe็alho e Array de Itens para o e-mail.บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TTTMKA09(nTipo,cCodFil,cNumAtend,aCabMail,aItens,aInfoSeq)

Local aArea			:= GetArea()
Local cAssunto		:= ""
Local cTabAssunto	:= "T1" 
Local cCodOcorr		:= ""
Local cCodSol		:= ""
Local cCodUsr		:= ""
Local cDescAssu		:= ""
Local cDescProd		:= ""
Local cDescOcorr	:= ""
Local cDescSol		:= ""
Local cObsExec		:= ""
Local cNomeUsr		:= ""
Local cTaref		:= ""
Local cTarSeq		:= ""
Local cDescTar		:= ""
Local cCliente		:= ""

Default nTipo		:= 1

If cEmpAnt <> "01"
	Return
EndIf

dbSelectArea("SUD")
dbSetOrder(1)
If dbSeek(xFilial("SUD")+cNumAtend) 
	While SUD->UD_FILIAL == cCodFil .And. SUD->UD_CODIGO == cNumAtend .And. SUD->(!Eof())
	                          
		// Campos de codigo
		cAssunto	:= SUD->UD_ASSUNTO
		cCodProd	:= SUD->UD_PRODUTO 
		cCodOcorr	:= SUD->UD_OCORREN  
		cCodSol		:= SUD->UD_SOLUCAO  
		cCodUsr		:= SUD->UD_OPERADO		                                                 
		cObsExec	:= MSMM(SUD->UD_CODEXEC)
		
		// Busca descricoes dos campos
		cDescAssu	:= Posicione("SX5",1,xFilial("SX5")+cTabAssunto+cAssunto,"X5_DESCRI")
		cDescProd	:= Posicione("SB1",1,xFilial("SB1")+cCodProd,"B1_DESC")
		cDescOcorr	:= Posicione("SUR",1,xFilial("SUR")+cCodOcorr,"UR_DESC")
		cDescSol	:= Posicione("SUQ",1,xFilial("SUQ")+cCodSol,"UQ_DESC")
	
		// Busca nome do usuario (operador)
		PswOrder(1)
		If PswSeek(__cUserID)
			aUser := PswRet(1)
			If Len(aUser) > 0
				cNomeUsr := aUser[1][4]
			Else
				cNomeUsr := aUser[1][4] := ""
			Endif
		Endif
	
		
		//Adiciona os itens do atendimento para ser usado no envio do email
		Aadd(aItens,{;
					PadL(SUD->UD_ITEM,3,"0"),;			// [01] - Item
					cAssunto			,;				// [02] - Assunto 
	   				cDescAssu			,;				// [03] - Descricao do Assunto - VIRTUAL
				 	cCodProd		  	,;				// [04] - Produto
				 	cDescProd			,;				// [05] - Descricao do Produto - VIRTUAL
				 	cCodOcorr			,;				// [06] - Ocorrencia
				 	cDescOcorr			,;				// [07] - Descricao da Ocorrencia - VIRTUAL
				 	cCodSol				,;				// [08] - Acao
				 	cDescSol			,;				// [09] - Descricao da Acao - VIRTUAL
				 	cCodUsr				,;				// [10] - Codigo do Operador
				 	cNomeUsr			,;				// [11] - Descricao do Operador	
				 	DTOC(SUD->UD_DATA)	,;				// [12] - Data
				 	SUD->UD_OBS	   		,;  			// [13] - Observacao
					SUD->UD_STATUS		,;				// [14] - Status - ver			1 - Pendente / 2 - Encerrado
				 	DTOC(SUD->UD_DTEXEC),;				// [15] - Data de Execucao
				 	cObsExec	})						// [16] - Memo da Execucao					 
		
		// Se for chamado via job de disparo dos emails, salva qual a tarefa atrasada para mostar no email
		If nTipo == 2
			cTaref := SUD->UD_XTAREF
			cTarSeq := SUD->UD_XTARSEQ
		EndIf
				 	
	 	SUD->(dbSkip())
	End
	
	// Busca descricao da tarefa pendente para mostrar no email
	If nTipo == 2
		cDescTar := GetAdvFVal("SZ9","Z9_TAREFA",xFilial("SZ9")+cTaref+cTarSeq,2,"")
		AADD(aInfoSeq, cTaref)
		AADD(aInfoSeq, cTarSeq)
		AADD(aInfoSeq, cDescTar)
	EndIf
	
	// Prepara a observacao
	dbSelectArea("SUC")
	dbSetOrder(1)
	If dbSeek(xFilial("SUC")+cNumAtend)
		cMsgObs := MSMM(SUC->UC_CODOBS)
		cCodCli := SubStr(SUC->UC_CHAVE,1,TamSx3("A1_COD")[1])
		cLjCli := SubStr(SUC->UC_CHAVE,TamSx3("A1_COD")[1]+1,TamSx3("A1_LOJA")[1])
		cCliente := cCodCli +"/" +cLjCli
		cCliente += "-" +Posicione("SA1",1,xFilial("SA1")+cCodCli+cLjCli,"A1_NOME") 
		
		Aadd(aCabMail,SUC->UC_CODIGO )											// [1] Atendimento
		Aadd(aCabMail,cCliente)													// [2] Cliente
		Aadd(aCabMail,SUC->UC_DATA)	          									// [3] Data da ligacao
		Aadd(aCabMail,SUC->UC_OPERADO + "-" +cNomeUsr)							// [4] Codigo - Operador
		Aadd(aCabMail,cMsgObs)													// [5] Observacao TMK																																									
	EndIf
EndIf
	
RestArea(aArea)

Return