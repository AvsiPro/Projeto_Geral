#include "rwmake.ch"
#include "protheus.ch"


//+-------------------------------------------------------------------------------------------------+
//| PROGRAMA  | MA103BUT | WRC                                                         | 26/04/2023 |
//+-------------------------------------------------------------------------------------------------+
//| DESCRIÇÃO | Ponto de entrada que permite adicionar botões na interface de edição de documentos  |
//|           | de entrada (MATA103)                                                                |
//|           |                                                                                     |
//|           | Inclui botão que permite ao usuário informar o conteúdo do campo histórico para os  |
//|           | títulos a pagar gerados na rotina.                                                  |
//|           |                                                                                     |
//|           | Chamado 179854                                                                      |
//|           |                                                                                     |
//|           | Esta rotina trabalha em conjunto com o PE MT100GE2 através da variável cHistJCA103  |
//|           |                                                                                     |
//+-------------------------------------------------------------------------------------------------+
//| HISTORICO DAS ALTERAÇÕES                                                                        |
//+-------------------------------------------------------------------------------------------------+
//| DATA     | AUTOR                | DESCRICAO                                                     |
//+-------------------------------------------------------------------------------------------------+
//|          |                      |                                                               |
//|          |                      |                                                               |
//|          |                      |                                                               |
//+-------------------------------------------------------------------------------------------------+


User Function MA103BUT
Local aRet := {}

Public cHistJCA103 := Space(TamSx3("E2_HIST")[1])   // Esta variável é usada em JMAT103 e no PE MT100GE2

If INCLUI .or. ALTERA
	AAdd(aRet,{ 'NOTE',{| |  U_JMAT103A() }, 'Histórico Tit. a Pagar','Histórico Tit. a Pagar' } )
Endif

Return aRet

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// JMAT103A
//
// Interface que permite ao usuário informar o conteúdo que será usado no campo de histórico do contas a pagar
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function JMAT103A()

Local aPergs := {}
Local aRet   := {}


aAdd( aPergs ,{1, "Histórico"      ,cHistJCA103       ,"@!"   ,'.T.',"",'.T.', 120, .F.})
      
If !ParamBox(aPergs,"Histórico Tit. a Pagar",@aRet,{||.T.},,,,,,,.F.,.F.)
   Return
Endif

cHistJCA103 := aRet[1]

Return
