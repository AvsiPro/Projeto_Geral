//|=====================================================================|
//|Programa: F050IRF.PRW   |Autor: Marciane Gennari   | Data: 21/10/09  |
//|=====================================================================|
//|Descricao: Ponto de entrada para gravar histórico no titulo de IRRF  |
//|           Código da Retenção e Gera Dirf SIM.                       |
//|=====================================================================|
//|Sintaxe:                                                             |
//|=====================================================================|
//|Uso: Ponto de entrada da rotina FINA050                              |
//|=====================================================================|
//|       ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.             |
//|---------------------------------------------------------------------|
//|Programador |Data:      |BOPS  |Motivo da Alteracao                  |
//|=====================================================================|
#Include "rwmake.ch"

User Function F050IRF()

  Local _cRotina  := Alltrim(FunName())
  Local _cNome    := ""
  Local _cCdRet   := "" 
  Local _cFornece := ""
  Local _cLoja    := ""
  Local _cCnpj    := ""
  Local _cRazao   := ""
  Local _cMes     := "" 
  Local _cAno     := "" 
  
  If cEmpAnt == "01"
	  If _cRotina == "FINA050" .or.  _cRotina == "MATA103"  .or. _cRotina == "FINA750"
	     
	     If _cRotina == "FINA050" .or. _cRotina == "FINA750"                  
	        _cFornece := M->E2_FORNECE
	        _cLoja    := M->E2_LOJA
	        _cMes     := Subs(Dtos(M->E2_EMISSAO),5,2) //--- Base Retencao IRRF pela emissao do titulo    
	        _cAno     := Subs(Dtos(M->E2_EMISSAO),1,4) 
	     Else           
	        _cFornece := SF1->F1_FORNECE        
	        _cLoja    := SF1->F1_LOJA
	        _cMes     := Subs(Dtos(SF1->F1_EMISSAO),5,2) 
	        _cAno     := Subs(Dtos(SF1->F1_EMISSAO),1,4) 
	     EndIf          
	     
	     _cNome  := GetAdvFval("SA2","A2_NREDUZ",xFilial("SA2")+_cFornece+_cLoja,1)
	     _cRazao := GetAdvFval("SA2","A2_NOME",xFilial("SA2")+_cFornece+_cLoja,1)
	     _cCnpj  := GetAdvFval("SA2","A2_CGC",xFilial("SA2")+_cFornece+_cLoja,1)
	     
	     RECLOCK("SE2",.F.)
	     SE2->E2_HIST    := "IRRF "+_cNome  
	     If Empty(SE2->E2_CODRET)
	        SE2->E2_DIRF    := "1"  
	     EndIf
	     If SM0->M0_CODIGO $ '01/02/11'
		     SE2->E2_XAPUR  := LastDay(CTOD("01"+"/"+_cMes+"/"+_cAno))  
		     SE2->E2_XCONTR  := _cRazao                                  
		     SE2->E2_XCNPJC  := _cCnpj                                   
		     SE2->E2_FORORI  := _cFornece                                
	    	 SE2->E2_LOJORI  := _cLoja                                  
	  	 EndIf
	    MSUNLOCK()               
	  
	  EndIf
EndIf	 

RETURN   