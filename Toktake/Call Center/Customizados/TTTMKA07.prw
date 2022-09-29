#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TmkBody	  ºAutor  ³Jackson E. de Deus  º Data ³  06/06/13 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Monta o corpo do email em html.							  º±±
±±º          ³				                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TTTMKA07(nTipo,aCabMail,cArqMail,aItens,lFim,aInfoSeq)

/*
nTipo
1 = Alteracao
2 = Atrasado (Utilizado pelo Job)
*/

Local aSeq			:= {}
Local nPosNewObs
Local nI
Default lFim := .F.
Default nTipo := 1
							 
cArqMail += "<html>"  
cArqMail += "<head>"

If nTipo == 1
	cArqMail += "<title>Alteração no Atendimento - Call Center - Telemarketing</title>"
ElseIf nTipo == 2
	cArqMail += "<title>**ATENDIMENTO ATRASADO**</title>"
EndIf
			
cArqMail += "</head>"  
cArqMail += "<body>"			
cArqMail += '<p align="center"><b><font color="#000080" size="4">'   // Alinhamento e tamanho do fonte titulo
If nTipo == 1
	cArqMail += "Alteração no Atendimento - Call Center - Telemarketing" 			// "Alteração no Atendimento - Call Center - Telemarketing"
ElseIf nTipo == 2
	cArqMail += "<font color='#FF0000'>**ATENDIMENTO ATRASADO**</font>"
EndIf
cArqMail += '</font></b></p>'

cArqMail += '<hr>'                	// Linha horizontal do corpo do email


cArqMail += '<p><b>'
cArqMail += "Dados do Atendimento" // Dados do Atendimento
cArqMail += '</b></p>'

cArqMail += "<table border='1' width='100%'>"
cArqMail += '<tr>'
cArqMail += '<td width="40%"><b><font size="2">&nbsp;<font color="#0000FF" face="Verdana">' 	//Cor azul
cArqMail += "Atendimento" //Atendimento
cArqMail += '</font>&nbsp;</font></b></td>'
cArqMail += '<td width="60%"><font face="Verdana" size="2">'
cArqMail += aCabMail[1]
cArqMail += '</font></td>'
cArqMail += '</tr>'

cArqMail += '<tr>'
cArqMail += '<td width="40%"><b><font size="2">&nbsp;<font color="#0000FF" face="Verdana">'
cArqMail += "Cliente"	//Cliente , Prospect 
cArqMail += '</font>&nbsp;</font></b></td>'
cArqMail += '<td width="60%"><font face="Verdana" size="2">'
cArqMail += aCabMail[2]
cArqMail += '</font></td>'
cArqMail += '</tr>'

cArqMail += '<tr>'
cArqMail += '<td width="40%"><b><font size="2">&nbsp;<font color="#0000FF" face="Verdana">'
cArqMail += "Data" //Data
cArqMail += '</font>&nbsp;</font></b></td>'
cArqMail += '<td width="60%"><font face="Verdana" size="2">'
cArqMail += IIF(!Empty(aCabMail[3]),DTOC(aCabMail[3]),'&nbsp;')//Se estiver vazio cria o 'espaco' onde estaria o dado.
cArqMail += '</font></td>'
cArqMail += '</tr>'

cArqMail += '<tr>'
cArqMail += '<td width="40%"><b><font size="2">&nbsp;<font color="#0000FF" face="Verdana">'
cArqMail += "Operador" //Operador
cArqMail += '</font>&nbsp;</font></b></td>'
cArqMail += '<td width="60%"><font face="Verdana" size="2">'
cArqMail += IIF(!Empty(aCabMail[4]),aCabMail[4],'&nbsp;')//Se estiver vazio cria o 'espaco' onde estaria o dado.
cArqMail += '</font></td>'
cArqMail += '</tr>'


cArqMail += '<tr>'
cArqMail += '<td width="40%"><b><font size="2">&nbsp;<font color="#0000FF" face="Verdana">'
cArqMail += "Observação do atendimento" //Observacao do atendimento
cArqMail += '</font>&nbsp;</font></b></td>'
cArqMail += '<td width="60%"><font face="Verdana" size="2">'


If Empty(aCabMail[5])
	cArqMail += '&nbsp;'
Else
	aSeq := StrTokarr(aCabMail[5],"#")
	For nI := 1 To Len(aSeq)
		// Se for alteracao de atendimento
		If nTipo == 1
			If IsInCallStack("U_TK271END")
				cArqMail += aSeq[nI] +"<br>"
				cArqMail += "<br>"
				Loop
			EndIf
			If AT(aCabMail[6],aSeq[nI]) > 0
				nPosNewObs := At(aCabMail[6],aSeq[nI])
				cArqMail += SubStr(aSeq[nI],1,nPosNewObs)
				If lFim
					cArqMail += "<font color='#FF0000'>" +aCabMail[6] +"</font>"
					cArqMail += "<br>"
					cArqMail += SubStr(aSeq[nI],nPosNewObs)
				Else
					cArqMail += "<font color='#FF0000'>" +SubStr(aSeq[nI],nPosNewObs) +"</font>"
					cArqMail += "<br>"
				EndIf
				Loop
			EndIf
			cArqMail += aSeq[nI] +"<br>"
			//cArqMail += "<br>"
		// Chamada do Job de envio de emails		
		ElseIf nTipo == 2
			If Len(aInfoSeq) > 0
				If !Empty(aInfoSeq[2])
					If aInfoSeq[2] == SubStr(aSeq[nI],1,3)
						cArqMail += "<font color='#FF0000'>" +aSeq[nI] +"</font>"
						cArqMail += "<br>"

						// tratamento das variaveis pois sao privadas da funcao U_TTTMKA08()						
						If ValType(lAgInsRem) <> "U" .And. ValType(lExpirou) <> "U"
							If ValType(lAgInsRem) == "L" .And. ValType(lExpirou) == "L"
								If lAgInsRem .And. !lExpirou
									cArqMail += "<font color='#FF0000'>Faltam poucos dias para a instalação/remoção!" +"</font>"
								ElseIf lAgInsRem .And. lExpirou
									cArqMail += "<font color='#FF0000'>O prazo agendado para instalação/remoção expirou!" +"</font>"
								EndIf
							EndIf
						EndIf
						
						cArqMail += "<br>"
						Loop
					EndIf
				EndIf
			EndIf
			cArqMail += aSeq[nI] +"<br>"
			//cArqMail += "<br>"	
		EndIf		
	Next nI
EndIf

cArqMail += '</font></td>'
cArqMail += '</tr>'
cArqMail += '</table>'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Prepara a impressao do conteudo dos itens - SUD  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
[01] - Item
[02] - Assunto 
[03] - Descricao do Assunto - VIRTUAL
[04] - Produto
[05] - Descricao do Produto - VIRTUAL
[06] - Ocorrencia
[07] - Descricao da Ocorrencia - VIRTUAL
[08] - Acao
[09] - Descricao da Acao - VIRTUAL
[10] - Codigo do Operador
[11] - Descricao do Operador	
[12] - Data
[13] - Observacao
[14] - Status - ver			1 - Pendente / 2 - Encerrado
[15] - Data de Execucao
[16] - Memo da Execucao	
*/
cArqMail += "<table border='1'  width='100%'>"
For nCont := 1 To Len(aItens)
	cArqMail += '<tr>'
	
	cArqMail += '<th rowspan=2><font face="Verdana" size=2>'
	cArqMail += aItens[nCont][1]
	cArqMail += '</font></th>'
	
	// Assunto - somente descricao	
	cArqMail += '<td><font face="Verdana" size="2">'
	cArqMail += IIF(!Empty(aItens[nCont][3]),AllTrim(aItens[nCont][3]),'&nbsp;') 
	cArqMail += '</font></td>'

	//Produto
	cArqMail += '<td><font face="Verdana" size="2">'
	cArqMail += IIF(!Empty(aItens[nCont][4]),AllTrim(aItens[nCont][4]) + " - " + AllTrim(aItens[nCont][5]),'&nbsp;') 
	cArqMail += '</font></td>'
	
	// Ocorrencia - somente descricao
	cArqMail += '<td><font face="Verdana" size="2">'
	cArqMail += IIF(!Empty(aItens[nCont][7]),AllTrim(aItens[nCont][7]),'&nbsp;') 
	cArqMail += '</font></td>'
	
	// Acao - Somente descricao	
	cArqMail += '<td><font face="Verdana" size="2">'
	cArqMail += IIF(!Empty(aItens[nCont][9]),AllTrim(aItens[nCont][9]),'&nbsp;') 
	cArqMail += '</font></td>'
	
	//Responsavel - somente descricao	
	cArqMail += '<td><font face="Verdana" size="2">'
	cArqMail += IIF(!Empty(aItens[nCont][11]),AllTrim(aItens[nCont][11]),'&nbsp;') 
	cArqMail += '</font></td>'
	
	//Data da acao	
	cArqMail += '<td><font face="Verdana" size="2">'
	cArqMail += IIF(!Empty(aItens[nCont][12]),AllTrim(aItens[nCont][12]),'&nbsp;')  
	cArqMail +='</font></td>'
	
	//Observacao	
	cArqMail += '<td><font face="Verdana" size="2">'
	cArqMail += IIF(!Empty(aItens[nCont][13]),AllTrim(aItens[nCont][13]),'&nbsp;')  
	cArqMail += '</font></td>'
	
	//Status
	cArqMail += '<td><font color ="#FF0000" face="Verdana" size="2">'
	If !Empty(aItens[nCont][14])
		If aItens[nCont][14] == "1"
			cArqMail += "1" +"=" +"Pendente"
		ElseIf	aItens[nCont][14] == "2"
			cArqMail += "2" +"=" +"Encerrado"		
		EndIf
	Else
		cArqMail += '&nbsp;'
	EndIf
	cArqMail += '</font></td>'
	
	//Data Execucao
	cArqMail += '<td><font face="Verdana" size="2">'
	cArqMail += IIF(!Empty(aItens[nCont][15]),AllTrim(aItens[nCont][15]),'&nbsp;')  
	cArqMail += '</font></td>'

	cArqMail += '</tr>'
	
	//Memo
	cArqMail += '<tr><th colspan=9><font face="Verdana" color="#0000FF" size=1>'
	cArqMail += IIF(!Empty(aItens[nCont][16]), aItens[nCont][15]+ ": <br>",'&nbsp;')
  	cArqMail += '</font><font face="Verdana" size=1>'
  	
  	If !Empty(aItens[nCont][16])
  		For nI := 1 To Len(aItens[nCont][16])
  			If SubStr(aItens[nCont][16],nI,2) <> CHR(13)+CHR(10)
				cArqMail += SubStr(aItens[nCont][16],nI,1)                             
			Else                                          
				cArqMail += "<br>"
				nI += 1
			EndIf
  		Next nI
  	Else
		cArqMail +=	'&nbsp;'
  	EndIf
  		
	cArqMail += '</font></th></tr>'
	
Next nCont

cArqMail += '</table>'

                    
cArqMail += '<p>&nbsp;</p>'
cArqMail += '</body>'
cArqMail += '</html>'

Return .T.