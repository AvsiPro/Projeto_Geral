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
//|           | Os pedidos não devem nascer bloqueadosa solução com menos impacto econtrada foi enviar o grupo 999999    |
//|           |                                                                                                          |
//+----------------------------------------------------------------------------------------------------------------------+
//| HISTORICO DAS ALTERAÇÕES                                                                                             |
//+----------------------------------------------------------------------------------------------------------------------+               
//| DATA     | AUTOR                | DESCRICAO                                                                          |
//+----------------------------------------------------------------------------------------------------------------------+


User Function MT120APV()
	Local ExpC1 := Nil
	Local ExpC2 := Ni
	Local cGrp := "" //Grupo de aprovação

	IF IsInCallStack('MSEXECAUTO')
		If Type("ALTERA") == "U"
			ALTERA := .F.
		Endif

		If Type("PARAMIXB") == "U"
			//EXEMPLO 1 (Manipulando o grupo de aprovação):
			cGrp := ""
		
			RestArea(aAreaSC7)
			RestArea(aAreaAtu)
			Return cGrp
		Endif
	ENDIF

Return



