#Include "Protheus.ch"

/*/{Protheus.doc}	MT450FIM
Ponto de Entrada da Rotina de Análise Credito Pedido - Faturamento.

@author				Paulo Lima
@since				15/12/2021
@return				Nil
/*/
User Function MT450FIM()
	Local cPedido := paramIXB[1]
	Local cTexto
	//U_GObsLP(SC5->C5_NUM)
	
	// TOTVS
	U_GeraOSep("SC5")		// Função que gera os registros na tabela CB7 e CB8 baseados na SC5.
	
   	// TOTVS
	U_bloqCredEst(cPedido)

	//Gravar usuario que liberou no cabeçalho do pedido
	cTexto := CRLF+'Usuario '+Alltrim(cusername)+' liberou o credito deste pedido em '+cvaltochar(ddatabase)+' as '+cvaltochar(time())+CRLF
	Reclock("SC5",.F.)
	SC5->C5_XUSULIB := cusername
	SC5->C5_XHISTAL	:= Alltrim(SC5->C5_XHISTAL)+cTexto
	SC5->(MsUnlock())

Return
