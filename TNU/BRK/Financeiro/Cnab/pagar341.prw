#include "Protheus.ch"
/*
+-----------------------------------------------------------------------------+
|Programa  : PAGAR341                                                         |
|Descrição : Função única para o Sispag ITAU                                  |
+-----------------------------------------------------------------------------+
|Autor     : TI2228 - Marciane Gennari Rosa                                   | 
|Observacao:                  04/11/2010                                                |
|                                                                             |
+-------------------------------------------------+--------+------------------+
|Alterado                                         |Em      | Por              |
|                                                 |DD/MM/AA|                  |                                                                                                                             |
|                                                 |DD/MM/AA|                  |
|                                                 |DD/MM/AA|                  |
|                                                 |DD/MM/AA|                  |
|                                                 |DD/MM/AA|                  |
|                                                 |DD/MM/AA|                  |
|                                                 |DD/MM/AA|                  |
+-----------------------------------------------------------------------------+

FORNECEDORES
+----------------------+----------+
| Nome Campo           | Parametro|                                            
+----------------------+----------+
| CODIGO AGENCIA       |   PP001  |                     
| VALOR PAGTO          |   PP002  |                     
| VALOR DESCONTO       |   PP003  |                   
| VALOR ACRESCIMO      |   PP004  |                   
| DV CODIGO DE BARRAS  |   PP005  |                     
| FATOR VENCTO E VALOR |   PP006  |                     
| CAMPO LIVRE (CODBAR) |   PP007  |                     
+----------------------+----------+


TRIBUTOS
+----------------------+----------+
| Nome Campo           | Parametro|                                            
+----------------------+----------+
| TIPO DO IMPOSTO  |   PT000  |                     
| DADOS DARF / GPS   / DARF SIMPLES / FGTS / IPVA / DPVAT  |   PT001  |  PT002  |                     
+----------------------+----------+

P/ VEICULOS criar campos
+----------------------+----------+
| Nome Campo           | Parametro|                                            
+----------------------+----------+
SE2->E2_RENAV    C    9                                
SE2->E2_IPVUF    C    2                                                                 
SE2->E2_CODMUN   C    5    
SE2->E2_PLACA    C    7                              
SE2->E2_OPCAO    C    1   Opção de Pagamento - Para DPVAT sempre opção 0
                          27-DPVAT e 26-Licenciamento é obrigatório utilizar o código 0.
                          //Strzero((SE2->E2_SALDO+SE2->E2_ACRESC)*100,14)
     
*/

User Function Pagar341(_cOpcao)   

Local  _cTipo     := ""
Local  _cRetorno  := ""
Local  _cConta    := ""
Local  _cCampo    := ""
Local  _TtAbat    := 0.00
Local  _Liqui     := 0.00
Local  _nCCItau   := 000000
Local  _nDVCCIt   := 0
Local  _nCCDif    := 000000000000
Local  _nDVDif    := ""

_cTipo    := Alltrim(Upper(_cOpcao))

Do Case
	
    Case _cTipo == "PP001"	//  Agencia e Conta Corrente Favorecido

       // Numero da Conta Corrente
       _nPosDV := iIF(Empty(SA2->A2_DVCTA),"0",SA2->A2_DVCTA)                                               
       //--- Formato banco ITAU (341)
       If sa2->a2_banco = "341"
          //_cRetorno := "0"+strzero(val(substr(sa2->a2_agencia,1,4)),4)+" "+"0000000"
          IF _nPosDV == '0' 
			 _cRetorno += "0"+strzero(val(substr(sa2->a2_agencia,1,4)),4)
			 _cRetorno += " "+"000000"+strzero(VAL(substr(sa2->a2_numcon,1,06)),06)+" "+STRZERO(VAL(_nPosDV),1)
		  ELSE
			_nCCItau  := STRZERO(VAL(sa2->a2_numcon),6) 
			_nDVCCIt  := STRZERO(VAL(_nPosDV),1)
			_cRetorno := "0"+substr(sa2->a2_agencia,1,4)+" "+"000000"+_nCCItau+" "+_nDVCCIt			
	      ENDIF      // 4868   03890-4
          //_cRetorno += strzero(val(substr(_cConta,1,4)),4)+" "+substr(_cConta,6,1)     //sa2->a2_dgnumc                          
       Else
          //_cRetorno += strzero(val(substr(_cConta,1,4)),13)
          IF _nPosDV == '0'
			 _cRetorno += strzero(val(substr(sa2->a2_agencia,1,5)),5)
			 _cRetorno += " "+strzero(VAL(substr(sa2->a2_numcon,1,10)),12)+" "+STRZERO(VAL(_nPosDV),1)
		  ELSE
		    _nCCDif   := strzero(VAL(substr(sa2->a2_numcon,1,10)),12)
			_nDVDif   := STRZERO(VAL(_nPosDV),1)
            _cRetorno := strzero(val(substr(sa2->a2_agencia,1,5)),5)+" "+_nCCDif+" "+_nDVDif
	      ENDIF
       EndIf
         
         //--- Mensagem ALERTA
         If Empty(SA2->A2_AGENCIA) .or. Empty(sa2->a2_numcon)                             
     
            MsgAlert('Fornecedor '+alltrim(sa2->a2_cod)+"-"+alltrim(sa2->a2_loja)+" "+alltrim(sa2->a2_nome)+' sem banco/agência/conta corrente no titulo '+SE2->E2_PREFIXO+'-'+SE2->E2_NUM+'-'+SE2->E2_PARCELA+'. Atualize os dados no titulo e execute esta rotina novamente.')
 
         EndIf                  
  
         //--- Mensagem ALERTA
         If Empty(SA2->A2_CGC)
     
            MsgAlert('Fornecedor '+alltrim(sa2->a2_cod)+"-"+alltrim(sa2->a2_loja)+" "+alltrim(sa2->a2_nome)+' sem CNPJ no cadastro. Atualize os dados no cadastro do fornecedor e execute esta rotina novamente.')

         EndIf          
                 
    Case _cTipo == "PP002"	//  Valor Pagamento                    
   
         _TtAbat := 0.00
         
         //--- Funcao SOMAABAT totaliza todos os titulos com e2_tipo AB- relacionado ao
         //---        titulo do parametro 
         _TtAbat   := somaabat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,'P',SE2->E2_MOEDA,DDATABASE,SE2->E2_FORNECE,SE2->E2_LOJA)
         _TtAbat   += SE2->E2_DECRESC                       
         _Liqui    := (SE2->E2_SALDO-_TtAbat+SE2->E2_ACRESC)
         
         _cRetorno :=    StrZero(_Liqui*100,15)
        
    Case _cTipo == "PP003"	//  Valor Abatimento/Desconto          
   
         _TtAbat   := somaabat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,'P',SE2->E2_MOEDA,DDATABASE,SE2->E2_FORNECE,SE2->E2_LOJA)
         _TtAbat   += SE2->E2_DECRESC                          
         
         _cRetorno := StrZero(_TtAbat*100,15)

    //Case _cTipo == "PP004"	//  Valor Juros           
   
    //     _cRetorno := StrZero(SE2->E2_ACRESC*100,15)

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
	         _cRetorno := "01" 
		 EndIf                                      
	                                                       
    //Case _cTipo == "PP009"	//  Tipo de Conta para DOC (Agencia)	
	
	//     _cRetorno := IF(SA2->A2_BANCO$"341","000000"+SA2->A2_AGENCIA,SA2->A2_AGENCIA)
	     
    Case _cTipo == "PP009"	//  Conta para DOC (sem ser ITAU)	
	
	     _cRetorno := IF(SA2->A2_BANCO$"341",STRZERO(VAL(SUBS(SA2->A2_NUMCON,1,6)),6),STRZERO(VAL(SUBS(SA2->A2_NUMCON,1,12)),12))  
     
    Case _cTipo == "PP010"	//  Digito de Conta para DOC (sem ser ITAU)	
	
	     _cRetorno := IF(SA2->A2_BANCO$"341",VAL(SA2->A2_DVCTA),SA2->A2_DVCTA)  
		 
	Case _cTipo == "PT000"
		 
         _cRetorno := ""                       
         
         //  Dados DARF  
         If SEA->EA_MODELO == "16"            // Posicao 018 a 019: Identificacao do Tributo 02-Darf 03-Darf Simples
             _cRetorno := "02"                         
         ElseIf (SEA->EA_MODELO == "17")    // Posicao 018 a 019: Identificacao do Tributo 01-GPS                    
            _cRetorno := "01"                                                       
         ElseIf  SEA->EA_MODELO == "18"     // Posicao 018 a 019: Identificacao do Tributo  03-Darf Simples
            _cRetorno := "03"                          
         ElseIf SEA->EA_MODELO == "22"     // Posicao 018 a 019: Identificacao do Tributo  05-ICMS
            _cRetorno := "05"                          
         ElseIf SEA->EA_MODELO == "35"    // Posicao 018 a 019: Identificacao do Tributo  11-FGTS-GFIP
            _cRetorno := "11"                          
         ElseIf SEA->EA_MODELO == "25"  .or. SEA->EA_MODELO == "26" .or. SEA->EA_MODELO == "27"  //--- Posicao 018 a 019: Identificacao do Tributo  07-IPVA e 08-DPVAT
              _cRetorno := If(SEA->EA_MODELO=="25","07","08")  
         EndIf     


    Case _cTipo == "PT001"	                           
 
         _cRetorno := ""                       
         
         //  Dados DARF  
         If SEA->EA_MODELO == "16"    
   
            // Posicao 018 a 019: Identificacao do Tributo 02-Darf 03-Darf Simples
           // _cRetorno := "02"                         

            // Posicao 020 a 023: Codigo da Receita                                 
            _cRetorno += If(!Empty(SE2->E2_YCODREC),STRZERO(Val(SE2->E2_YCODREC),4),STRZERO(Val(SE2->E2_YCODREC),4))
  
            // Posicao 024 a 024: Tp Inscricao  1-CPF /  2-CNPJ               
            IF SA2->A2_TIPO = "J"
               _cRetorno += "2"       
            ELSE
              _cRetorno += "1"       
            ENDIF

           //If !Empty(SE2->E2_XCNPJC)
           //    _cRetorno += Iif (len(alltrim(SE2->E2_XCNPJC))>11,"2","1")
           //Else               
           //   _cRetorno += "2"       
           //EndIf
  
            // Posicao 025 a 038: N Inscricao  //--- CNPJ/CPF do Contribuinte E2_XCNPJC
            //If !Empty(SE2->E2_CNPJRET)
            //   _cRetorno += Strzero(Val(SE2->E2_CNPJRET),14)
            //Else
               _cRetorno += Subs(SM0->M0_CGC,1,14)
            //EndIf
                                                 
            // Posicao 039 a 046: Periodo Apuracao
            _cRetorno += GravaData(SE2->E2_EMISSAO,.F.,5)   //  E2_E_APUR
            
            // Posicao 047 a 063: Referencia   
            _cRetorno +=  "0000000000000"+Strzero(Val(SE2->E2_YCODREC),4)   //Strzero(Val(SE2->E2_XREFER),17)

            // Posicao 064 a 077: Valor Principal
            _cRetorno += Strzero(SE2->E2_SALDO*100,14)                               
            
            // Posicao 078 a 091: Multa             
            _cRetorno += STRZERO(SE2->E2_MULTA*100,14)         
            
            // Posicao 092 a 105: Juros        
            _cRetorno += Strzero(SE2->E2_JUROS*100,14)          

            // Posicao 106 a 119: Valor Total (Principal + Multa + Juros)
            _cRetorno += STRZERO((SE2->E2_SALDO+SE2->E2_MULTA+SE2->E2_JUROS)*100,14)           

            // Posicao 120 a 127: Data Vencimento                           
            _cRetorno += GravaData(SE2->E2_VENCTO,.F.,5)                             

            // Posicao 128 a 135: Data Pagamento                            
            _cRetorno += GravaData(SE2->E2_VENCREA,.F.,5)                            

            // Posicao 136 a 165: Compl.Registro                          
            _cRetorno += Space(30)                                                   

            // Posicao 166 a 195: Nome do Contribuinte                 
            //If !Empty(SE2->E2_CNPJRET)  //E2_XCNPJ
            //   _cRetorno += Subs(SE2->SE2->E2_CNPJRET,1,14)+SPACE(16)  //E2_XCONTR,1,30
            //   If Empty(SE2->E2_XCONTR)
            //      MsgAlert('Nome do Contribuinte não informado para a DARF - Titulo '+alltrim(se2->e2_prefixo)+"-"+alltrim(se2->e2_num)+"-"+alltrim(se2->e2_parcela)+'. Atualize o Nome do Contribuinte no titulo indicado e execute esta rotina novamente.')
            //   EndIf
            // Else
               _cRetorno += Subs(SM0->M0_NOMECOM,1,30)
            //EndIf                                                                      
                                                             
            //--- Mensagem ALERTA que está sem periodo de apuração
            //If Empty(se2->e2_e_apur)                              
        
            //   MsgAlert('Tributo sem Data de Apuracao. Informe o campo Apuracao no titulo: '+alltrim(se2->e2_prefixo)+" "+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+" Tipo: "+alltrim(se2->e2_tipo)+" Fornecedor/Loja: "+alltrim(se2->e2_fornece)+"-"+alltrim(se2->e2_loja)+' e execute esta rotina novamente.')

            //EndIf     
  
            
         // Dados GPS
         ElseIf (SEA->EA_MODELO == "17")   
   

            // Posicao 018 a 019: Identificacao do Tributo 01-GPS                    
            //_cRetorno := "01"                                                       

            // Posicao 020 a 023: Codigo Pagamento                                 
            _cRetorno +=  STRZERO(Val(SE2->E2_YCODREC),4)  
                                                 
            // Posicao 024 a 029: Competencia   MMAAAA  
            _cRetorno += STRZERO(MONTH(SE2->E2_VENCREA),2)+STRZERO(YEAR(SE2->E2_VENCREA),4)
            
            // Posicao 030 a 043: N Identificacao  //--- CNPJ/CPF do Contribuinte        
            //If !Empty(SE2->E2_CNPJRET)
            //     If Empty(SE2->E2_CNPJRET)
            //
            //         MsgAlert('O titulo de tributo '+alltrim(se2->e2_prefixo)+"-"+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+' do fornecedor '+alltrim(se2->e2_fornece)+" "+alltrim(se2->e2_loja)+' está sem o CNPJ/CPF do Contribuinte. Atualize os dados no titulo e execute esta rotina novamente.')
            //     EndIf
            //   _cRetorno += Strzero(Val(CNPJRET),14)
            //Else
                _cRetorno += Strzero(Val(SM0->M0_CGC),14)
            //EndIf
  
            // Posicao 044 a 057: Valor Principal (Valor Titulo - Outras Entidades)STRZERO(SE2->(E2_YINSS+E2_YVLOUT+E2_CORREC)*100,14)         
            _cRetorno += Strzero((SE2->E2_YINSS)*100,14)                               
            
            // Posicao 058 a 071: Valor Outras Entidades
            _cRetorno += Strzero(SE2->E2_YVLOUT*100,14)            
            
            // Posicao 072 a 085: Multa        
            _cRetorno += Strzero(SE2->E2_MULTA+SE2->E2_JUROS*100,14)            
            
            // Posicao 086 a 099: Valor Total (Principal + Multa)
            _cRetorno += Strzero((SE2->E2_YINSS+SE2->E2_YVLOUT+SE2->E2_MULTA+SE2->E2_JURO)*100,14)              

            // Posicao 100 a 107: Data Vencimento                           
            _cRetorno += GravaData(SE2->E2_VENCREA,.F.,5)                             

            // Posicao 108 a 115: Compl.Registro                          
            _cRetorno += Space(8)                                                   

            // Posicao 116 a 165: Informacoes Complementares              
            _cRetorno += Space(50)                                                  

            // Posicao 166 a 195: Nome do Contribuinte                                                  
            //If !Empty(SE2->E2_CNPJRET)
            //   _cRetorno += Subs(SE2->E2_XCONTR,1,30)
            //   If Empty(SE2->E2_XCONTR)
            //      MsgAlert('Nome do Contribuinte não informado para a GPS - Titulo '+alltrim(se2->e2_prefixo)+"-"+alltrim(se2->e2_num)+"-"+alltrim(se2->e2_parcela)+'. Atualize o Nome do Contribuinte no titulo indicado e execute esta rotina novamente.')
            //   EndIf
            //Else
               _cRetorno += Subs(SM0->M0_NOMECOM,1,30)
            //EndIf                                                                      
                                                             
            //--- Mensagem ALERTA que está sem periodo de apuração
            If Empty(se2->E2_VENCREA)  //e2_e_apur                           
        
               MsgAlert('Tributo sem Competencia. Informe o campo Apuração no titulo: '+alltrim(se2->e2_prefixo)+" "+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+" Tipo: "+alltrim(se2->e2_tipo)+" Fornecedor/Loja: "+alltrim(se2->e2_fornece)+"-"+alltrim(se2->e2_loja)+' e execute esta rotina novamente.')

            EndIf     
                                                             

         //----- DARF SIMPLES
         ElseIf  SEA->EA_MODELO == "18"   
                                                                     
            // Posicao 018 a 019: Identificacao do Tributo  03-Darf Simples
            //_cRetorno := "03"                          

            // Posicao 020 a 023: Codigo da Receita  - Para DARF Simples - fixar código 6106
             _cRetorno += "6106"
                       
            // Posicao 024 a 024: Tp Inscricao  1-CPF /  2-CNPJ               
            IF SA2->A2_TIPO = "J"
               _cRetorno += "2"       
            ELSE
              _cRetorno += "1"       
            ENDIF
            //If !Empty(SE2->E2_XCNPJC)
            //    _cRetorno += Iif (len(alltrim(SE2->E2_XCNPJC))>11,"2","1")
            //Else               
            //  _cRetorno += "2"       
            //EndIf
  
            // Posicao 025 a 038: N Inscricao  //--- CNPJ/CPF do Contribuinte
            //If !Empty(SE2->E2_XCNPJC)
            //   _cRetorno += Strzero(Val(SE2->E2_XCNPJC),14)
            //Else
               _cRetorno += Subs(SM0->M0_CGC,1,14)
            //EndIf
                                                 
            // Posicao 039 a 046: Periodo Apuracao
            _cRetorno += GravaData(SE2->E2_VENCREA,.F.,5)  //E2_E_APUR
            
            // Posicao 047 a 055: Valor da Receita Bruta Acumulada
            _cRetorno += Repl("0",9) 
            
            // Posicao 056 a 059: % sobre a Receita Bruta Acumulada
            _cRetorno += Repl("0",4) 
            
            // Posicao 060 a 063: Compl.Registro                          
            _cRetorno += Space(4)                                                   

            // Posicao 064 a 077: Valor Principal
            _cRetorno += Strzero(SE2->E2_SALDO*100,14)                               
            
            // Posicao 078 a 091: Multa             
            _cRetorno += STRZERO(SE2->E2_MULTA*100,14)         
            
            // Posicao 092 a 105: Juros        
            _cRetorno += STRZERO(SE2->E2_JUROS*100,14)         
            
            // Posicao 106 a 119: Valor Total (Principal + Multa + Juros)
            _cRetorno += STRZERO((SE2->E2_SALDO+SE2->E2_MULTA+SE2->E2_JUROS)*100,14)           

            // Posicao 120 a 127: Data Vencimento                           
            _cRetorno += GravaData(SE2->E2_VENCTO,.F.,5)                             

            // Posicao 128 a 135: Data Pagamento                            
            _cRetorno += GravaData(SE2->E2_VENCREA,.F.,5)                            

            // Posicao 136 a 165: Compl.Registro                          
            _cRetorno += Space(30)                                                   

            // Posicao 166 a 195: Nome do Contribuinte                 
            //If !Empty(SE2->E2_XCNPJC)
            //   _cRetorno += Subs(SE2->E2_XCONTR,1,30)
            //   If Empty(SE2->E2_XCONTR)
            //      MsgAlert('Nome do Contribuinte não informado para a DARF Simples - Titulo '+alltrim(se2->e2_prefixo)+"-"+alltrim(se2->e2_num)+"-"+alltrim(se2->e2_parcela)+'. Atualize o Nome do Contribuinte no titulo indicado e execute esta rotina novamente.')
            //   EndIf
            //Else
               _cRetorno += Subs(SM0->M0_NOMECOM,1,30)
            //EndIf                                                                      
                                                             
            //--- Mensagem ALERTA que está sem periodo de apuração
            If Empty(SE2->E2_VENCREA)  //e2_e_apur
        
               MsgAlert('Tributo sem Data de Apuracao. Informe o campo Apuracao no titulo: '+alltrim(se2->e2_prefixo)+" "+alltrim(se2->e2_num)+" "+alltrim(se2->e2_parcela)+" Tipo: "+alltrim(se2->e2_tipo)+" Fornecedor/Loja: "+alltrim(se2->e2_fornece)+"-"+alltrim(se2->e2_loja)+' e execute esta rotina novamente.')

            EndIf     
  

         //--- GARE ICMS SP                  
         ElseIf SEA->EA_MODELO == "22" //--- GARE ICMS - SP
 
            // Posicao 018 a 019: Identificacao do Tributo  05-ICMS
            //_cRetorno := "05"                          

            // Posicao 020 a 023: Codigo da Receita                                 
            _cRetorno +=  STRZERO(Val(SE2->E2_YCODREC),4)  
                       
            // Posicao 024 a 024: Tp Inscricao  1-CPF /  2-CNPJ               
            _cRetorno += "2"       
            
            // Posicao 025 a 038: N Inscricao  //--- CNPJ/CPF do Contribuinte
            _cRetorno +=  Strzero(Val(u_dadosSM0("02",SE2->E2_FILIAL)),14) //--- Funcao u_dadosSM0 está no fonte PAGAR356.PRW                               
  
            //--- Posicao 039 a 050: Inscricao Estadual-  
            _cRetorno +=  Strzero(Val(u_dadosSM0("01",SE2->E2_FILIAL)),12)   //--- Funcao u_dadosSM0 está no fonte PAGAR356.PRW                              
 
            //--- Posicao 051 a 063: Divida Ativa / Etiqueta  
            _cRetorno +=  Repl("0",13)   //Strzero(Val(SE2->E2_XDIVID),13)                               

            //--- Posicao 064 a 069: Periodo de Referencia (Mes/Ano)  Formato MMAAAA 
            _cRetorno += Strzero(Month(SE2->E2_VENCREA),2)+Strzero(Year(SE2->E2_VENCREA),4)  //SE2->E2_E_APUR

            //--- Posicao 070 a 082: N. Parcela / Notificação  
            _cRetorno +=  Strzero(Val(SE2->E2_PARCELA),13)                               

            //--- Posicao 083 a 096: Valor da Receita (Principal) 
            _cRetorno += Strzero(SE2->E2_SALDO*100,14)
     
            //--- Posicao 097 a 110: Valor Juros/Encargos 
            _cRetorno += Strzero(SE2->E2_JUROS*100,14)                              

            //--- Posicao 111 a 124: Valor da Multa              
            _cRetorno += Strzero(SE2->E2_MULTA*100,14)     
            
            //--- Posicao 125 a 138: Valor do Pagamento              
            _cRetorno += STRZERO((SE2->E2_SALDO+SE2->E2_MULTA+SE2->E2_JUROS)*100,14)           
            
            //--- Posicao 139 a 146: Data de Vencimento   Formato DDMMAAAA
            _cRetorno += Gravadata(SE2->E2_VENCTO,.F.,5)                               

            //--- Posicao 147 a 154: Data de Pagamento-  Formato DDMMAAAA
            _cRetorno += Gravadata(SE2->E2_VENCREA,.F.,5)                               

            //--- Posicao 155 a 165: Brancos                                   
            _cRetorno += Space(11)                                                      

            //--- Posicao 166 a 195: Nome do Contribuinte                                   
            //If !Empty(SE2->E2_XCNPJC)
            //    _cRetorno += Subs(SE2->E2_XCONTR,1,30)
            //    If Empty(SE2->E2_XCONTR)
            //      MsgAlert('Nome do Contribuinte não informado para o segmento N - GARE ICMS - Titulo '+alltrim(se2->e2_prefixo)+"-"+alltrim(se2->e2_num)+"-"+alltrim(se2->e2_parcela)+'. Atualize o Nome do Contribuinte no titulo indicado e execute esta rotina novamente.')
            //    EndIf
            //Else
               _cRetorno += Subs(SM0->M0_NOMECOM,1,30)
            //EndIf   
  
         //--- 25 - IPVA SP   
         //--- 26 - Licenciamento
         //--- 27 - DPVAT              
         ElseIf SEA->EA_MODELO == "25"  .or. SEA->EA_MODELO == "26" .or. SEA->EA_MODELO == "27" 
   
              //--- Posicao 018 a 019: Identificacao do Tributo  07-IPVA e 08-DPVAT
              _cRetorno := If(SEA->EA_MODELO=="25","07","08")  
              
              //--- Posicao 020 a 023 - Brancos
              _cRetorno += Space(4)                        
    
              // Posicao 024 a 024: Tp Inscricao  1-CPF /  2-CNPJ               
              IF SA2->A2_TIPO = "J"
                 _cRetorno += "2"       
              ELSE
                 _cRetorno += "1"       
              ENDIF

              //If !Empty(SE2->E2_XCNPJC)
              //    _cRetorno += Iif (len(alltrim(SE2->E2_XCNPJC))>11,"2","1")
              //Else               
              //  _cRetorno += "2"       
              //EndIf
  
              // Posicao 025 a 038: N Inscricao  //--- CNPJ/CPF do Contribuinte
              IF SA2->A2_TIPO = "J"
                 _cRetorno += Strzero(Val(SA2->A2_CGC),14)      
              ELSE
                 _cRetorno += Strzero(Val(SUBSTR(SA2->A2_CGC,1,11)),14)
              ENDIF

              //If !Empty(SE2->E2_XCNPJC)
              //   _cRetorno += Strzero(Val(SE2->E2_XCNPJC),14)
              //Else
              //   _cRetorno += Subs(SM0->M0_CGC,1,14)
              //EndIf
                                                 
              //--- Posicao 039 a 042 - Exercicio Ano Base  
              _cRetorno += Strzero(SE2->E2_ANOBASE,4)                               

              //--- Posicao 043 a 051 - Renavam  
              //_cRetorno +=  Strzero(Val(SE2->E2_RENAV),9)                               
                                                                           
              //--- Posicao 052 a 053 - Unidade Federação   
              //_cRetorno +=  Upper(SE2->E2_IPVUF)                               

             //--- Posicao 054 a 058 - Codigo do Municipio  
             //_cRetorno += Strzero(Val(SE2->E2_CODMUN),5)    

             //--- Posicao 059 a 065 - Placa   
             //_cRetorno +=  SE2->E2_PLACA                              

             //--- Posicao 066 a 066 - Opção de Pagamento - Para DPVAT sempre opção 0
             //If SEA->EA_MODELO == "25"
             //   _cRetorno += Alltrim(SE2->E2_OPCAO)
             // Else
             //     _cRetorno += "0"   //--- Para 27-DPVAT e 26-Licenciamento é obrigatório utilizar o código 0.
             //EndIf
     
            //--- Posicao 067 a 080 - Valor do IPVA/DPVAT  
            //_cRetorno += Strzero((SE2->E2_SALDO+SE2->E2_ACRESC)*100,14)
     
            //--- Posicao 081 a 094 - Valor do Desconto                         
            _cRetorno += Strzero(SE2->E2_DECRESC*100,14)                              

            //--- Posicao 095 a 108 - Valor do Pagamento               
            _cRetorno += Strzero((SE2->E2_SALDO+SE2->E2_ACRESC-SE2->E2_DECRESC)*100,14)     
 
            //--- Posicao 109 a 116: Data de Vencimento   Formato DDMMAAAA
            _cRetorno += Gravadata(SE2->E2_VENCTO,.F.,5)                               

            //--- Posicao 117 a 124: Data de Pagamento-  Formato DDMMAAAA
            _cRetorno += Gravadata(SE2->E2_VENCREA,.F.,5)                               

            //--- Posicao 125 a 165: Brancos                                   
            _cRetorno += Space(41)                                                      

            //--- Posicao 166 a 195: Nome do Contribuinte                                   
            //If !Empty(SE2->E2_XCNPJC)
            //    _cRetorno += Subs(SE2->E2_XCONTR,1,30)
            //    If Empty(SE2->E2_XCONTR)
            //      MsgAlert('Nome do Contribuinte não informado para o segmento N (IPVA/DPVAT)- Titulo '+alltrim(se2->e2_prefixo)+"-"+alltrim(se2->e2_num)+"-"+alltrim(se2->e2_parcela)+'. Atualize o Nome do Contribuinte no titulo indicado e execute esta rotina novamente.')
            //    EndIf
            //Else
               _cRetorno += Subs(SM0->M0_NOMECOM,1,30)
            //EndIf   
 
         //--- 35 - FGTS              
         ElseIf SEA->EA_MODELO == "35" 

            // Posicao 018 a 019: Identificacao do Tributo  11-FGTS-GFIP
            _cRetorno := "11"                          

            // Posicao 020 a 023: Codigo da Receita  
            _cRetorno +=  STRZERO(Val(SE2->E2_YCODREC),4)  
                       
            // Posicao 024 a 024: Tp Inscricao  1-CPF /  2-CNPJ               
              IF SA2->A2_TIPO = "J"
                 _cRetorno += "2"       
              ELSE
                 _cRetorno += "1"       
              ENDIF

            //If !Empty(SE2->E2_XCNPJC)
            //    _cRetorno += Iif (len(alltrim(SE2->E2_XCNPJC))>11,"2","1")
            //Else               
            //  _cRetorno += "2"       
            //EndIf
  
              // Posicao 025 a 038: N Inscricao  //--- CNPJ/CPF do Contribuinte
              IF SA2->A2_TIPO = "J"
                 _cRetorno += Strzero(Val(SA2->A2_CGC),14)      
              ELSE
                 _cRetorno += Strzero(Val(SUBSTR(SA2->A2_CGC,1,11)),14)       
              ENDIF

            //If !Empty(SE2->E2_XCNPJC)
            //   _cRetorno += Strzero(Val(SE2->E2_XCNPJC),14)
            //Else
            //   _cRetorno += Subs(SM0->M0_CGC,1,14)
            //EndIf
                                                 
            // Posicao 039 a 086: Codigo de Barras
            _cRetorno += SE2->E2_CODBAR 
            
            // Posicao 087 a 102: Identificador do FGTS
            _cRetorno += Strzero(Val(SE2->E2_IDENT),16) //IDENTEE                          
            
            // Posicao 103 a 111: Lacre de Conectividade Social
            //_cRetorno += Strzero(Val(SE2->E2_LACRE),9)
             
            // Posicao 112 a 113: Digito do Lacre de Conectividade Social
            //_cRetorno += Strzero(Val(SE2->E2_DGLACR),2)
             
            // Posicao 114 a 143: Nome do Contribuinte                 
            //If !Empty(SE2->E2_XCNPJC)
            //   _cRetorno += Subs(SE2->E2_XCONTR,1,30)
            //   If Empty(SE2->E2_XCONTR)
            //      MsgAlert('Nome do Contribuinte não informado para o FGTS - Titulo '+alltrim(se2->e2_prefixo)+"-"+alltrim(se2->e2_num)+"-"+alltrim(se2->e2_parcela)+'. Atualize o Nome do Contribuinte no titulo indicado e execute esta rotina novamente.')
            //   EndIf
            //Else
               _cRetorno += Subs(SM0->M0_NOMECOM,1,30)
            //EndIf                                                                      
            
            // Posicao 144 a 151: Data Pagamento                            
            _cRetorno += GravaData(SE2->E2_VENCREA,.F.,5)                            

            // Posicao 152 a 165: Valor do Pagamento
            _cRetorno += STRZERO((SE2->E2_SALDO+SE2->E2_MULTA+SE2->E2_JUROS-SE2->E2_DECRESC)*100,14)           

            // Posicao 166 a 195: Compl.Registro                          
            _cRetorno += Space(30)                                                   
         
         EndIf     
                                   
	Case _cTipo == "PT002"
		 // Posicao 166 a 195: Referencia  MM/AAAA c/ brancos a esquerda
         _cRetorno := "           " + Month2Str(SE2->E2_EMISSAO) + Year2Str(SE2->E2_EMISSAO)                      
  
  	Case _cTipo == "PT003"
		 // Posicao 166 a 195: Referencia  MM/AAAA c/ zeros a esquerda
         _cRetorno := Strzero(VAL(Month2Str(SE2->E2_EMISSAO)+Year2Str(SE2->E2_EMISSAO)),17)                      
    
    Otherwise  //  Parametro não existente
      
	 MsgAlert('Não foi encontrado o Parametro '+ _cTipo + "."+;
                  'Solicite à informática para verificar o fonte PAGAR341, ou o arquivo de configuração do CNAB.')

EndCase		      

return(_cRetorno)                                          
