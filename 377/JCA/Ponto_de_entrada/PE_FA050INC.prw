#include 'totvs.ch'

/*/{Protheus.doc} FA050INC()
	
    A finalidade do ponto de entrada FA050INC é permitir validações de usuário
    na inclusão do Contas a Pagar (FINA050), localizado no TudoOK da rotina.
 
    @return lRet - lógico, .T. valida a inclusão e continua o processo,
        caso contrário .F. e interrompe o processo.
/*/
User Function FA050INC()
	Local aArea :=  GetArea()
	Local lRet  :=  .T.


	If FunName() == "GPEM670"
		lRet  := .T.
	Else
		If FunName() <> "COMXCOL"

			// Validações de usuário
			If (Type("oMainWnd")=="O") //Se nao for via schedule
				If Empty(E2_CONTAD)
					lRet := .F.
				EndIf
			EndIf

			If !(lRet)
				// Mensagem de Help para esclarescer o motivo de interromper a inclusão
				Help( ,, 'Help',, "Conta débito não foi informada.", 1, 0 )

				// Alterando lMsErroAuto para .T. (verdadeiro), devido aos casos de integrações ou ExecAuto
				lMsErroAuto := .T.
			EndIf

			If substr(M->E2_CONTAD,1,1) $ '4/5' .And. !'GLB' $ M->E2_PREFIXO
				If Empty(M->E2_CCUSTO)
					MsgAlert("Para contas contábeis iniciadas em ( 4 ou 5 ) o campo Centro de Custo é de preenchimento obrigatório")
					lRet := .F.
				EndIf
			Endif
		EndIf
	EndIf

	RestArea(aArea)
Return lRet
