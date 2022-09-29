#include "Protheus.ch"

User Function Pagar341(_cOpcao)

Local  _cTipo     	:= ""
Local  _cRetorno  	:= ""
Local  _cAgc     	:= ""
Local _cDigcc 		:= ""
Local _cBanco 		:= ""
Local  _cConta     	:= ""
Local  _cCampo    	:= ""
Local  _TtAbat    	:= 0.00
Local  _Juros     	:= 0.00
Local  _Liqui     	:= 0.00


_cTipo    := Alltrim(Upper(_cOpcao))

Do Case
	
	Case _cTipo == "PP001"	//  Agencia e Conta Corrente Favorecido
		
		// Numero da Conta Corrente
		
		_cBanco  := alltrim(SA2->A2_BANCO)
		_cAgc     := alltrim(SA2->A2_AGENCIA)
		_cConta  := alltrim(SA2->A2_NUMCON)
		_cDigCc  := alltrim(SA2->A2_XDIGCON)
		
		
		//--- Formato banco ITAU (341)
		// Numero da Conta Corrente
		
		If _cBanco  == "341"
			_cRetorno := "0"+strzero(val(substr(_cAgc,1,4)),4)+" "+"0000000"
			_cRetorno += strzero(val(substr(_cConta,1,5)),5)+" "+substr(_cDigCc,1,1)
		Else
			_cRetorno := strzero(val(substr(_cAgc,1,5)),5)+" "
			_cRetorno += strzero(val(substr(_cConta,1,12)),12)
			If len(rtrim(ltrim(_cDigCc))) > 1
				_cRetorno += strzero(val(substr(_cDigCc,1,2)),2)
			Else
				_cRetorno += " "+substr(_cDigCc,1,1)
			EndIf
		EndIf
		
		//--- Mensagem ALERTA
		If Empty(_cAgc) .or. Empty(_cConta) .or. Empty(_cDigcc)
			
			MsgAlert('Fornecedor '+alltrim(sa2->a2_cod)+"-"+alltrim(sa2->a2_loja)+" "+alltrim(sa2->a2_nome)+' sem banco/agência/conta corrente no titulo '+SE2->E2_PREFIXO+'-'+SE2->E2_NUM+'-'+SE2->E2_PARCELA+'. Atualize os dados no titulo e execute esta rotina novamente.')
			
		EndIf
		
		//--- Mensagem ALERTA
		If Empty(SA2->A2_CGC)
			
			MsgAlert('Fornecedor '+alltrim(sa2->a2_cod)+"-"+alltrim(sa2->a2_loja)+" "+alltrim(sa2->a2_nome)+' sem CNPJ no cadastro. Atualize os dados no cadastro do fornecedor e execute esta rotina novamente.')
			
		EndIf
		
	Case _cTipo == "PP002"	//  Valor Pagamento
		
		
		_TtAbat := 0.00
		_Juros  := 0.00
		
		//--- Funcao SOMAABAT totaliza todos os titulos com e2_tipo AB- relacionado ao
		//---        titulo do parametro
		_TtAbat   := somaabat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,'P',SE2->E2_MOEDA,DDATABASE,SE2->E2_FORNECE,SE2->E2_LOJA)
		_TtAbat   += SE2->E2_DECRESC
		_Juros    := (SE2->E2_MULTA + SE2->E2_VALJUR + SE2->E2_ACRESC)
		_Liqui    := (SE2->E2_SALDO-_TtAbat+_Juros)
		
		_cRetorno := Left(StrZero((_Liqui*1000),16),15)
		
	Case _cTipo == "PP003"	//  Valor Abatimento/Desconto
		
		_TtAbat   := somaabat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,'P',SE2->E2_MOEDA,DDATABASE,SE2->E2_FORNECE,SE2->E2_LOJA)
		_TtAbat   += SE2->E2_DECRESC
		
		_cRetorno := Left(StrZero((_TtAbat*1000),16),15)
		
	Case _cTipo == "PP004"	//  Valor Juros
		
		_Juros    := (SE2->E2_MULTA + SE2->E2_VALJUR + SE2->E2_ACRESC)
		_cRetorno := Left(StrZero((_Juros*1000),16),15)
		
	Case _cTipo == "PP005"	//  Digito Verificador (Codigo de Barras)
		
		If     Len(Alltrim(SE2->E2_CODBAR)) < 44       // Antiga Codificacao (Numerica)
			_cRetorno := Substr(SE2->E2_CODBAR,33,1)
		ElseIf Len(Alltrim(SE2->E2_CODBAR)) == 47      // Nova Codificacao (Numerica)
			_cRetorno := Substr(SE2->E2_CODBAR,33,1)
		Else
			_cRetorno := Substr(SE2->E2_CODBAR,5,1)   // Codificacao Cod. Barras
		EndIf
		
		If Empty(SE2->E2_CODBAR)
			
			MsgAlert("Titulo "+alltrim(se2->e2_prefixo)+"-"+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+" do fornecedor "+alltrim(sa2->a2_cod)+"-"+alltrim(sa2->a2_loja)+" "+alltrim(sa2->a2_nome)+" sem código de barras. Informe o código de barras no título indicado e execute esta rotina novamente.")
			
		EndIf
		
		
	Case _cTipo == "PP006"	//  Fator de Vencimento e Valor do Titulo (Codigo de Barras)
		
		If     Len(Alltrim(SE2->E2_CODBAR)) < 44
			_cCampo := "00000000000000" //Substr(SE2->E2_CODBAR,34,5)
		ElseIf Len(Alltrim(SE2->E2_CODBAR)) == 47
			_cCampo := Substr(SE2->E2_CODBAR,34,14)
		Else
			_cCampo := Substr(SE2->E2_CODBAR,6,14)
		EndIf
		
		_cRetorno := Strzero(Val(_cCampo),14)
		
	Case _cTipo == "PP007"	//  Campo Livre (Codigo de Barras)
		
		If Len(Alltrim(SE2->E2_CODBAR)) < 44
			_cRetorno := Substr(SE2->E2_CODBAR,5,5)+Substr(SE2->E2_CODBAR,11,10)+Substr(SE2->E2_CODBAR,22,10)
		ElseIf Len(Alltrim(SE2->E2_CODBAR)) == 47
			_cRetorno := Substr(SE2->E2_CODBAR,05,05)+ Substr(SE2->E2_CODBAR,11,10)+ Substr(SE2->E2_CODBAR,22,10)
		Else
			_cRetorno := Substr(SE2->E2_CODBAR,20,25)
		EndIf
		
	Case _cTipo == "PP008"	//  Tipo de Conta para DOC (Conta Poupança)
		_cRetorno := ""
		
		If SEA->EA_MODELO=="03"
			
			_cRetorno := "11"
		EndIf
		
	Case _cTipo == "PT001"
		
		_cRetorno := ""
		//  Dados GARE-ICMS
		
		If SEA->EA_MODELO == "22"
			
			// Posicao 018 a 019
			_cRetorno := "05"
			
			// Posicao 020 a 023: Codigo da Receita
			If Empty(SE2->E2_CODRET)
				Alert("Atenção, codigo da receita não informado / GARE-ICMS. Arquivo não será validado.")
				_cRetorno := "Atenção, codigo da receita não informado / GARE-ICMS. Arquivo não será validado."
				return(_cRetorno)
			Endif
			
			_cRetorno += SE2->E2_CODRET
			
			// Posicao 024 a 024: Tp Inscricao  1-CNPJ /  2-CEI ( Cadastro Específico do INSS )
			_cRetorno += "1"
			
			// Posicao 025 a 038: CNPJ/CPF do Contribuinte
			_cRetorno += Subs(SM0->M0_CGC,1,14)
			
			//Posicao 039 a 050: Inscricao Estadual do Contribuinte
			_cRetorno += Subs(SM0->M0_INSC,1,12)
			
			//Posicao 051 a 063: DIVIDA ATIVA/NUMERO ETIQUETA // VERIFICAR JUNTO AO BANCO E A GUIA
			_cRetorno += Strzero(val(SE2->E2_NUM+SE2->E2_PARCELA),13)
			
			// Posicao 064 a 069:  MES/ANO DE REFERENCIA
			_cRetorno += STRZERO(VAL(SUBS(DTOS(SE2->E2_VENCREA),5,2))-1,2)+SUBS(DTOS(SE2->E2_VENCREA),1,4)
			
			// Posicao 070 a 082:  NUMERO PARCELA/NOTIFICACAO  // VERIFICAR JUNTO AO BANCO E A GUIA
			_cRetorno += Strzero(val(SE2->E2_NUM+SE2->E2_PARCELA),13)
			
			// Posicao 083 a 096: VALOR DA RECEITA
			_cRetorno += Strzero(SE2->E2_SALDO*100,14)
			
			// Posicao 097 a 110: VALOR DOS JUROS
			_cRetorno += Strzero(SE2->E2_VALJUR*100,14)
			
			// Posicao 111 a 124: MULTA
			_cRetorno += Strzero(SE2->E2_MULTA*100,14)
			
			// Posicao 125 a 138: Valor Total (Principal + Acrescimenos + Multa + Juros)
			_cRetorno += STRZERO((SE2->E2_SALDO+SE2->E2_ACRESC+SE2->E2_VALJUR+SE2->E2_VALJUR)*100,14)
			
			// Posicao 139 a 146: Data Vencimento
			_cRetorno += GravaData(SE2->E2_VENCTO,.F.,5)
			
			// Posicao 147 a 154: Data Pagamento
			_cRetorno += GravaData(SE2->E2_VENCREA,.F.,5)
			
			// Posicao 155 a 165: Compl.Registro
			_cRetorno += Space(11)
			
			// Posicao 166 a 195: Nome do Contribuinte
			_cRetorno += ALLTRIM(Subs(SM0->M0_NOMECOM,1,30))	
			
		
		//02-Darf Normal / 03-Darf Simples
		ElseIf (SEA->EA_MODELO == "16" .or. SEA->EA_MODELO == "18")
			
			// Posicao 018 a 019:
			If SEA->EA_MODELO =="16"
				_cRetorno := "02"
			ElseIf SEA->EA_MODELO =="18"
				_cRetorno := "03"
			Endif
			
			// Posicao 020 a 023: Codigo da Receita
			If Empty(SE2->E2_CODRET)
				Alert("Atenção, codigo da receita não informado / DARF/DARF-SIMPLES. Arquivo não será validado.")
				_cRetorno := "Atenção, codigo da receita não informado / DARF/DARF-SIMPLES. Arquivo não será validado."
				return(_cRetorno)
			Endif
			
			_cRetorno += SE2->E2_CODRET
			
			// Posicao 024 a 024: Tp Inscricao  1-CPF /  2-CNPJ
			_cRetorno += "2"
			
			// Posicao 025 a 038: CNPJ/CPF do Contribuinte
			_cRetorno += Subs(SM0->M0_CGC,1,14)
			
			// Posicao 039 a 046: Periodo Apuracao
			If Empty(SE2->E2_XDTAPUR)
				Alert("Atenção, o campo referente a data de apuração da DARF não está preenchido.")
				_cRetorno := "Atenção, o campo referente a data de apuração da DARF não está preenchido."
				return(_cRetorno)
			Endif
			
			_cRetorno += SUBS(DTOS(SE2->E2_XDTAPUR),7,2)+SUBS(DTOS(SE2->E2_XDTAPUR),5,2)+SUBS(DTOS(SE2->E2_XDTAPUR),1,4)
			
			If	SEA->EA_MODELO =="16"
				
				// Posicao 047 a 063: Referencia
				_cRetorno += Repl("0",17)
				
			ElseIf SEA->EA_MODELO =="18"
				
				// Posicao 047 a 055: VALOR DA RECEITA BRUTA ACUMULADA
				_cRetorno += Repl("0",4)
				
				// Posicao 056 a 059: PERCENTUAL SOBRE A RECEITA BRUTA ACUM.
				_cRetorno += Repl("0",4)
				
				// Posicao 060 a 063: COMPLEMENTO DE REGISTRO
				_cRetorno += Repl("0",4)
				
			Endif
			// Posicao 064 a 077: Valor Principal
			_cRetorno += Strzero(SE2->E2_SALDO*100,14)
			
			// Posicao 078 a 091: Multa
			_cRetorno += STRZERO(SE2->E2_ACRESC*100,14)
			
			// Posicao 092 a 105: Juros
			_cRetorno += STRZERO(0,14)
			
			// Posicao 106 a 119: Valor Total (Principal + Multa + Juros)
			_cRetorno += STRZERO((SE2->E2_SALDO+SE2->E2_ACRESC)*100,14)
			
			// Posicao 120 a 127: Data Vencimento
			_cRetorno += GravaData(SE2->E2_VENCTO,.F.,5)
			
			// Posicao 128 a 135: Data Pagamento
			_cRetorno += GravaData(SE2->E2_VENCREA,.F.,5)
			
			// Posicao 136 a 165: Compl.Registro
			_cRetorno += Space(30)
			
			// Posicao 166 a 195: Nome do Contribuinte
			_cRetorno += Subs(SM0->M0_NOMECOM,1,30)
			
			// Dados GPS
		ElseIf (SEA->EA_MODELO == "17")
			
			
			// Posicao 018 a 019: Identificacao do Tributo 01-GPS
			_cRetorno := "01"
			
			// Posicao 020 a 023: Codigo Pagamento
			_cRetorno +=  ""
			
			// Posicao 024 a 029: Competencia
			_cRetorno += ""
			
			// Posicao 030 a 043: N Identificacao  //--- CNPJ/CPF do Contribuinte
			
			_cRetorno += Strzero(Val(SM0->M0_CGC),14)
			
			
			// Posicao 044 a 057: Valor Principal (Valor Titulo - Outras Entidades)
			_cRetorno += ""
			
			// Posicao 058 a 071: Valor Outras Entidades
			_cRetorno += ""
			
			// Posicao 072 a 085: Multa
			_cRetorno += Strzero(SE2->E2_ACRESC*100,14)
			
			// Posicao 086 a 099: Valor Total (Principal + Multa)
			_cRetorno += Strzero((SE2->E2_SALDO+SE2->E2_ACRESC)*100,14)
			
			// Posicao 100 a 107: Data Vencimento
			_cRetorno += GravaData(SE2->E2_VENCREA,.F.,5)
			
			// Posicao 108 a 115: Compl.Registro
			_cRetorno += Space(8)
			
			// Posicao 116 a 165: Informacoes Complementares
			_cRetorno += Space(50)
			
			// Posicao 166 a 195: Nome do Contribuinte
			
			_cRetorno += ALLTRIM(Subs(SM0->M0_NOMECOM,1,30))
			
		EndIf
		
		
		
	Otherwise  //  Parametro não existente
		
		MsgAlert('Não foi encontrado o Parametro '+ _cTipo + "."+;
		'Solicite à informática para verificar o fonte PAGAR341, ou o arquivo de configuração do CNAB.')
		
EndCase

return(_cRetorno)
