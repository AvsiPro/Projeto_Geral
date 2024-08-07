#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "TbiConn.ch"
#Include "totvs.ch"

//+----------------------------------------------------------------------------------------------------------------------+
//| PROGRAMA  | MT120APV | WRC                                                                              | 06/08/2024 |
//+----------------------------------------------------------------------------------------------------------------------+
//| DESCRI��O | O Ponto de Entrada MT120APV � responsavel pela grava��o do 						                         |
//|           |                                                                                                          |
//|           | grupo de aprova��o do Pedido de Compras e/ou Autoriza��o de Entrega                                      |
//|           |                                                                                                          |
//|           | Este ponto de entrada foi solicitado para atender os pedidos gerados via msexecauto fluig                |
//|           | Os pedidos n�o devem nascer bloqueados.                                                                                                         |
//|           |                                                                                                          |
//+----------------------------------------------------------------------------------------------------------------------+
//| HISTORICO DAS ALTERA��ES                                                                                             |
//+----------------------------------------------------------------------------------------------------------------------+               
//| DATA     | AUTOR                | DESCRICAO                                                                          |
//+----------------------------------------------------------------------------------------------------------------------+
//| 28/04/24 | TOTVS (Merge por WRC)| 03-MIT 44 FINANCEIRO FIN012- Cria��o campo CNPJ no cadastro do                     |
//|          |                      | fornecedor e no t�tulo a pagar                                                     |
//|          |                      | https://docs.google.com/document/d/10MRiybMe2fEDU-ExeFmq0RJonosTqANV/edit          |
//|          |                      | SE2->E2_ZCGCBOL := SA2->A2_ZCGCBOL os campos precisam existir no dicion�rio        |
//|          |                      | https://tdn.totvs.com/pages/releaseview.action?pageId=6085781                      |                                                                      |
//|          |                      |                                                                                    |
//|          |                      |                                                                                    |
//+----------------------------------------------------------------------------------------------------------------------+


User Function MT120APV()

	Local ExpC1 := Nil
	Local ExpC2 := Nil
	Local cGrp := "" //Grupo de aprova��o

	IF IsInCallStack('MSEXECAUTO')
		If Type("ALTERA") == "U"
			ALTERA := .F.
		Endif

		If Type("PARAMIXB") == "U"
			//EXEMPLO 1 (Manipulando o grupo de aprova��o):
			cGrp := "999999"
			Return cGrp
		Endif
	ENDIF

Return 
