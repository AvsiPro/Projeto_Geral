#include 'totvs.ch'

/*/{Protheus.doc} FA100OKP()
	
   O ponto de entrada FA100OKP sera utilizado para bloquear a inclusao de movimentos a pagar na 
   rotina Movimentos Bancarios. Se o retorno for verdadeiro, o movimento sera realizado normalmente, 
   caso contrario nao haver� inclusao do movimento. Retorno l�gico.
	Programa Fonte
    @return lRet - l�gico, .T. valida a inclus�o e continua o processo,
    caso contr�rio .F. e interrompe o processo.
/*/
User Function FA100OKP()
	Local lRet := .T.

	// Valida��es de usu�rio
	If (Type("oMainWnd")=="O") //Se nao for via schedule
		If Empty(E5_DEBITO)
        	lRet := .F.
    	EndIf
	EndIf

	If !(lRet)
		// Mensagem de Help para esclarescer o motivo de interromper a inclus�o
		Help( ,, 'Help',, "Conta d�bito n�o foi informada.", 1, 0 )

		// Alterando lMsErroAuto para .T. (verdadeiro), devido aos casos de integra��es ou ExecAuto
		lMsErroAuto := .T.
	EndIf

Return lRet
