#Include 'Protheus.ch'

 /*/{Protheus.doc} M410STTS

@author    Paulo Lima
@since    02/12/2021
@return    Nil
/*/

/*/
Ponto-de-Entrada: M410STTS - Altera��es no Pedido de Venda

Vers�es:	Protheus 11 e Protheus 12
Idiomas:	Todos

Descri��o:
Este ponto de entrada pertence � rotina de pedidos de venda, MATA410().
Est� em todas as rotinas de inclus�o, altera��o, exclus�o, c�pia e devolu��o de compras.

Executado ap�s todas as altera��es no arquivo de pedidos terem sido feitas.

Par�metros:
nOper --> Tipo: Num�rico - Descri��o: Opera��o que est� sendo executada, sendo:

3 - Inclus�o
4 - Altera��o
5 - Exclus�o
6 - C�pia
7 - Devolu��o de Compras

Programa Fonte:
MATA410.PRX
/*/

User Function M410STTS()
Local _nOper 	:= PARAMIXB[1]
Local aArea		:= GetArea()
Local cPedido	:= SC5->C5_NUM
Local cDataHr   := DtoS(Date()) + Time()

	dbSelectArea("ZZ1")

	If _nOper == 3 //iNCLUS�O
        dbSelectArea("ZZ1")
         RecLock("ZZ1",.T.)
            ZZ1_FILIAL      := xFilial("ZZ1")
            ZZ1->ZZ1_PEDIDO := cPedido
            ZZ1->ZZ1_I_FS01 := cDataHr
            /*/ZZ1->ZZ1_F_FS01 := cDataHr
    		ZZ1->ZZ1_I_FS02 := cDataHr
            ZZ1->ZZ1_F_FS02 := cDataHr
            ZZ1->ZZ1_I_FS03 := cDataHr
            ZZ1->ZZ1_F_FS03 :=
            ZZ1->ZZ1_I_FS04 :=
            ZZ1->ZZ1_F_FS04 :=
            ZZ1->ZZ1_I_FS05 :=
            ZZ1->ZZ1_F_FS05 :=
            ZZ1->ZZ1_EXCLUS :=
            /*/
         MsUnlock()
	 ElseIf _nOper == 5 //Exclus�o
	    dbSelectArea("ZZ1")
		If dbSeek(xFilial("ZZ1")+cPedido)
         RecLock("ZZ1",.T.)
			ZZ1->(RecLock("ZZ1", .F.))
			ZZ1->(dbDelete())
			ZZ1->(MsUnlock())
         MsUnlock()
		EndIf
	EndIf

    RestArea(aArea)

	U_GeraOSep("SC5")		// Fun��o que gera os registros na tabela CB7 e CB8 baseados na SC5.

Return
