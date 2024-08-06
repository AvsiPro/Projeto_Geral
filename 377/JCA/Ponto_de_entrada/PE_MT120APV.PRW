#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "TbiConn.ch"
#Include "totvs.ch"

//+----------------------------------------------------------------------------------------------------------------------+
//| PROGRAMA  | MT120APV | WRC                                                                              | 06/08/2024 |
//+----------------------------------------------------------------------------------------------------------------------+
//| DESCRIÇÃO | O Ponto de Entrada MT120APV é responsavel pela gravação do 						                         |
//|           |                                                                                                          |
//|           | grupo de aprovação do Pedido de Compras e/ou Autorização de Entrega                                      |
//|           |                                                                                                          |
//|           | Este ponto de entrada foi solicitado para atender os pedidos gerados via msexecauto fluig                |
//|           | Os pedidos não devem nascer bloqueados.                                                                                                         |
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


User Function MT120APV()

	Local ExpC1 := Nil
	Local ExpC2 := Nil
	Local cGrp := "" //Grupo de aprovação

	IF IsInCallStack('MSEXECAUTO')
		If Type("ALTERA") == "U"
			ALTERA := .F.
		Endif

		If Type("PARAMIXB") == "U"
			//EXEMPLO 1 (Manipulando o grupo de aprovação):
			cGrp := "999999"
			Return cGrp
		Endif
	ENDIF

Return 
