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
//|           | Os pedidos n�o devem nascer bloqueadosa solu��o com menos impacto econtrada foi enviar o grupo 999999    |
//|           |                                                                                                          |
//+----------------------------------------------------------------------------------------------------------------------+
//| HISTORICO DAS ALTERA��ES                                                                                             |
//+----------------------------------------------------------------------------------------------------------------------+               
//| DATA     | AUTOR                | DESCRICAO                                                                          |
//+----------------------------------------------------------------------------------------------------------------------+


User Function MT120APV()
	Local ExpC1 := Nil
	Local ExpC2 := Ni
	Local cGrp := "" //Grupo de aprova��o

	IF IsInCallStack('MSEXECAUTO')
		If Type("ALTERA") == "U"
			ALTERA := .F.
		Endif

		If Type("PARAMIXB") == "U"
			//EXEMPLO 1 (Manipulando o grupo de aprova��o):
			cGrp := ""
		
			RestArea(aAreaSC7)
			RestArea(aAreaAtu)
			Return cGrp
		Endif
	ENDIF

Return



