//|=====================================================================|
//|Programa: F050ISS.PRW   |Autor: Marciane Gennari   | Data: 21/10/09  |
//|=====================================================================|
//|Descricao: Ponto de entrada para gravar histórico no titulo de ISS.  |
//|                                                                     |
//|=====================================================================|
//|Sintaxe:                                                             |
//|=====================================================================|
//|Uso: Ponto de entrada da rotina FINA050                              |
//|=====================================================================|
//|       ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.             |
//|---------------------------------------------------------------------|
//|Programador |Data:      |BOPS  |Motivo da Alteracao                  |
//|---------------------------------------------------------------------|
//|                                                                     |
//|=====================================================================|
#Include "rwmake.ch"

User Function F050ISS()

  Local _cRotina := Alltrim(FunName())
  Local _cNome   := ""
  Local _cFornece := ""
  Local _cLoja    := ""

If cEmpAnt == "01"
  If _cRotina == "FINA050" .or. _cRotina == "MATA103" .or. _cRotina == "FINA750"
      
     If _cRotina == "FINA050" .or. _cRotina == "FINA750"                  
        _cFornece := M->E2_FORNECE
        _cLoja    := M->E2_LOJA
     Else           
        _cFornece := SF1->F1_FORNECE        
        _cLoja    := SF1->F1_LOJA
      EndIf          
     
     _cNome  := GetAdvFval("SA2","A2_NREDUZ" ,xFilial("SA2")+_cFornece+_cLoja,1)
    
     RECLOCK("SE2",.F.)
     SE2->E2_HIST    := "ISS "+_cNome
     SE2->E2_FORORI  := _cFornece                                
     SE2->E2_LOJORI  := _cLoja                                  
     MSUNLOCK()    
  
  EndIf  
EndIf

RETURN   