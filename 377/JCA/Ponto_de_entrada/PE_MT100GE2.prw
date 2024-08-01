#include "rwmake.ch"
#include "protheus.ch"


//+----------------------------------------------------------------------------------------------------------------------+
//| PROGRAMA  | MT100GE2 | WRC                                                                              | 26/04/2023 |
//+----------------------------------------------------------------------------------------------------------------------+
//| DESCRIÇÃO | Ponto de entrada que edita o conteúdo dos titulos a pagar gerados na MATA103                             |
//|           |                                                                                                          |
//|           | Usado para atualizar o histórico do título.  Chamado 179854                                              |
//|           |                                                                                                          |
//|           | Esta rotina trabalha em conjunto com o PE MA103BUT através da variável cHistJCA103                       |
//|           |                                                                                                          |
//|           |                                                                                                          |
//+----------------------------------------------------------------------------------------------------------------------+
//| HISTORICO DAS ALTERAÇÕES                                                                                             |
//+----------------------------------------------------------------------------------------------------------------------+               
//| DATA     | AUTOR                | DESCRICAO                                                                          |
//+----------------------------------------------------------------------------------------------------------------------+
//| 28/04/24 | TOTVS (Merge por WRC)| 03-MIT 44 FINANCEIRO FIN012- Criação campo CNPJ no cadastro do                     |
//|          |                      | fornecedor e no título a pagar                                                     |
//|          |                      | https://docs.google.com/document/d/10MRiybMe2fEDU-ExeFmq0RJonosTqANV/edit          |
//|          |                      | SE2->E2_ZCGCBOL := SA2->A2_ZCGCBOL os campos precisam existir no dicionário        |
//|          |                      | https://tdn.totvs.com/pages/releaseview.action?pageId=6085781                      |                                                                      |
//|          |                      |                                                                                    |
//|          |                      |                                                                                    |
//+----------------------------------------------------------------------------------------------------------------------+


User Function MT100GE2

	Local nOpc := PARAMIXB[2]  // 1=inclusao ; 2 = exclusão
	LOCAL nPar := 0

	If nOpc = 1
		SE2->E2_HIST := cHistJCA103
		SE2->E2_ZCGCBOL := SA2->A2_ZCGCBOL

		//ajusta data de vencimento na integração fluig
		IF FUNNAME() == "RPC"
			IF valtype(aVcto) != nil
				nPar := val(PARAMIXB[1,1])
				IF len(aVcto) >= nPar
					IF valtype(stod(aVcto[nPar])) == "D" .AND. aVcto[nPar] != NIL
						SE2->E2_VENCTO  := ctod(aVcto[nPar])
						SE2->E2_VENCREA := DataValida(ctod(aVcto[nPar]),.T.)
					ENDIF
				ENDIF
			ENDIF
		ENDIF
	Endif
Return
