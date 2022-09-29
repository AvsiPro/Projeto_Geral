//|=====================================================================|
//|Programa: F050COF.PRW   |Autor: Marciane Gennari   | Data:  21/10/09 |
//|=====================================================================|
//|Descricao: Ponto de entrada para gravar histórico no titulo do       |
//|           COFINS.                                                   |
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
//|                                                                     |
//|=====================================================================|
#Include "rwmake.ch"

User Function F050COF()

  Local _cRotina  := Alltrim(FunName())
  Local _cNome    := ""
  Local _cFornece := ""
  Local _cLoja    := ""
  Local _RecSE2Atu 
  Local _RecSE2Pai 
  
  If _cRotina == "FINA050" .or. _cRotina == "MATA103" .or. _cRotina == "FINA750" .or. ;
     _cRotina == "FINA080" .or. _cRotina == "FINA241"
      
     If _cRotina == "FINA050"                
        _cFornece := M->E2_FORNECE
        _cLoja    := M->E2_LOJA
     
     ElseIf _cRotina == "FINA080" .or. _cRotina == "FINA241" .or. _cRotina == "FINA750"  
 
        _RecSE2Atu := SE2->(Recno())
        _RecSE2Pai := Paramixb

        DbSelectArea("SE2")
        DbGoto(_RecSE2Pai)
        _cFornece := SE2->E2_FORNECE
        _cLoja    := SE2->E2_LOJA
     
        DbGoto(_RecSE2Atu)

     Else           

        _cFornece := SF1->F1_FORNECE        
        _cLoja    := SF1->F1_LOJA
     

     EndIf          
     
     _cNome  := GetAdvFval("SA2","A2_NREDUZ" ,xFilial("SA2")+_cFornece+_cLoja,1)
      
     RECLOCK("SE2",.F.)
     If SE2->E2_CODRET == "5952"
        SE2->E2_HIST   := "PIS/COFINS/CSLL "+_cNome
     Else
        SE2->E2_HIST   := "COFINS "+_cNome
     EndIf
     SE2->E2_FORORI  := _cFornece                                
     SE2->E2_LOJORI  := _cLoja                                  
     MSUNLOCK()    
  EndIf  
RETURN   