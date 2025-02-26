#Include 'Protheus.ch'

 /*/{Protheus.doc} M410STTS

@author    Paulo Lima
@since    02/12/2021
@return    Nil
/*/

/*/
Ponto-de-Entrada: M410STTS - Alterações no Pedido de Venda

Versões:	Protheus 11 e Protheus 12
Idiomas:	Todos

Descrição:
Este ponto de entrada pertence à rotina de pedidos de venda, MATA410().
Está em todas as rotinas de inclusão, alteração, exclusão, cópia e devolução de compras.

Executado após todas as alterações no arquivo de pedidos terem sido feitas.

Parâmetros:
nOper --> Tipo: Numérico - Descrição: Operação que está sendo executada, sendo:

3 - Inclusão
4 - Alteração
5 - Exclusão
6 - Cópia
7 - Devolução de Compras

Programa Fonte:
MATA410.PRX
/*/

User Function M410STTS()
Local _nOper 	:= PARAMIXB[1]
Local aArea		:= GetArea()
Local cPedido	:= SC5->C5_NUM
Local cDataHr   := DtoS(Date()) + Time()

	dbSelectArea("ZZ1")

	If _nOper == 3 //iNCLUSÃO
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
	 ElseIf _nOper == 5 //Exclusão
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

	U_GeraOSep("SC5")		// Função que gera os registros na tabela CB7 e CB8 baseados na SC5.

Return
