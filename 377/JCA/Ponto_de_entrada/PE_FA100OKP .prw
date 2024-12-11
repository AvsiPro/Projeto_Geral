#include 'totvs.ch'

/*/{Protheus.doc} FA100OKP()
	
   O ponto de entrada FA100OKP sera utilizado para bloquear a inclusao de movimentos a pagar na 
   rotina Movimentos Bancarios. Se o retorno for verdadeiro, o movimento sera realizado normalmente, 
   caso contrario nao haverá inclusao do movimento. Retorno lógico.
	Programa Fonte
    @return lRet - lógico, .T. valida a inclusão e continua o processo,
    caso contrário .F. e interrompe o processo.
/*/
User Function FA100OKP()
	Local lRet := .T.

	// Validações de usuário
	If (Type("oMainWnd")=="O") //Se nao for via schedule
		If Empty(E5_DEBITO)
        	lRet := .F.
    	EndIf
	EndIf

	If !(lRet)
		// Mensagem de Help para esclarescer o motivo de interromper a inclusão
		Help( ,, 'Help',, "Conta débito não foi informada.", 1, 0 )

		// Alterando lMsErroAuto para .T. (verdadeiro), devido aos casos de integrações ou ExecAuto
		lMsErroAuto := .T.
	EndIf

Return lRet
