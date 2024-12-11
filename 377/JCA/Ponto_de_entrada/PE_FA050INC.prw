#include 'totvs.ch'

/*/{Protheus.doc} FA050INC()
	
    A finalidade do ponto de entrada FA050INC � permitir valida��es de usu�rio
    na inclus�o do Contas a Pagar (FINA050), localizado no TudoOK da rotina.
 
    @return lRet - l�gico, .T. valida a inclus�o e continua o processo,
        caso contr�rio .F. e interrompe o processo.
/*/
User Function FA050INC()
	Local aArea :=  GetArea()
	Local lRet  :=  .T.


	If FunName() == "GPEM670"
		lRet  := .T.
	Else
		If FunName() <> "COMXCOL"

			// Valida��es de usu�rio
			If (Type("oMainWnd")=="O") //Se nao for via schedule
				If Empty(E2_CONTAD)
					lRet := .F.
				EndIf
			EndIf

			If !(lRet)
				// Mensagem de Help para esclarescer o motivo de interromper a inclus�o
				Help( ,, 'Help',, "Conta d�bito n�o foi informada.", 1, 0 )

				// Alterando lMsErroAuto para .T. (verdadeiro), devido aos casos de integra��es ou ExecAuto
				lMsErroAuto := .T.
			EndIf

			If substr(M->E2_CONTAD,1,1) $ '4/5' .And. !'GLB' $ M->E2_PREFIXO
				If Empty(M->E2_CCUSTO)
					MsgAlert("Para contas cont�beis iniciadas em ( 4 ou 5 ) o campo Centro de Custo � de preenchimento obrigat�rio")
					lRet := .F.
				EndIf
			Endif
		EndIf
	EndIf

	RestArea(aArea)
Return lRet
