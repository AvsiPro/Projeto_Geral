#include "rwmake.ch"
#include "protheus.ch"


//+-------------------------------------------------------------------------------------------------+
//| PROGRAMA  | MA103BUT | WRC                                                         | 26/04/2023 |
//+-------------------------------------------------------------------------------------------------+
//| DESCRI��O | Ponto de entrada que permite adicionar bot�es na interface de edi��o de documentos  |
//|           | de entrada (MATA103)                                                                |
//|           |                                                                                     |
//|           | Inclui bot�o que permite ao usu�rio informar o conte�do do campo hist�rico para os  |
//|           | t�tulos a pagar gerados na rotina.                                                  |
//|           |                                                                                     |
//|           | Chamado 179854                                                                      |
//|           |                                                                                     |
//|           | Esta rotina trabalha em conjunto com o PE MT100GE2 atrav�s da vari�vel cHistJCA103  |
//|           |                                                                                     |
//+-------------------------------------------------------------------------------------------------+
//| HISTORICO DAS ALTERA��ES                                                                        |
//+-------------------------------------------------------------------------------------------------+
//| DATA     | AUTOR                | DESCRICAO                                                     |
//+-------------------------------------------------------------------------------------------------+
//|          |                      |                                                               |
//|          |                      |                                                               |
//|          |                      |                                                               |
//+-------------------------------------------------------------------------------------------------+


User Function MA103BUT
Local aRet := {}

Public cHistJCA103 := Space(TamSx3("E2_HIST")[1])   // Esta vari�vel � usada em JMAT103 e no PE MT100GE2

If INCLUI .or. ALTERA
	AAdd(aRet,{ 'NOTE',{| |  U_JMAT103A() }, 'Hist�rico Tit. a Pagar','Hist�rico Tit. a Pagar' } )
Endif

Return aRet

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// JMAT103A
//
// Interface que permite ao usu�rio informar o conte�do que ser� usado no campo de hist�rico do contas a pagar
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function JMAT103A()

Local aPergs := {}
Local aRet   := {}


aAdd( aPergs ,{1, "Hist�rico"      ,cHistJCA103       ,"@!"   ,'.T.',"",'.T.', 120, .F.})
      
If !ParamBox(aPergs,"Hist�rico Tit. a Pagar",@aRet,{||.T.},,,,,,,.F.,.F.)
   Return
Endif

cHistJCA103 := aRet[1]

Return
