#Include "RwMake.ch"
#Include 'Protheus.ch'
#Include 'Topconn.ch'
#INCLUDE 'APVT100.CH'

/*/
{Protheus.doc}	ACD166FI
Ponto de Entrada ao finalizar o Processo de Separação.

@author				Paulo Lima
@since				01/02/2022
@return				Nil

Descrição:
Localização: Está localizado na função FimProcesso com o objetivo de finalizar o Processo de Separação. 
Finalidade: O Ponto de Entrada tem o Objetivo de Executar rotinas complementares no momento de finalizar o Processo de Separação.
Eventos
/*/

User Function ACD166FI()
Local aArea		:= GetArea()
Local cPedido	:= CB7->CB7_PEDIDO
Local cDataHr   := DtoS(Date()) + Time()

        dbSelectArea("ZZ1")
        if dbSeek(xFilial("ZZ1")+cPedido)
            RecLock("ZZ1",.F.)
                /*/
                ZZ1_FILIAL      := xFilial("ZZ1")
                ZZ1->ZZ1_PEDIDO := cPedido
                ZZ1->ZZ1_I_FS01 := SPACE(13)
                ZZ1->ZZ1_F_FS01 := SPACE(13)
                ZZ1->ZZ1_I_FS02 := SPACE(13)
                ZZ1->ZZ1_F_FS02 := cDataHr
                ZZ1->ZZ1_I_FS03 := cDataHr
                /*/
                ZZ1->ZZ1_F_FS03 := cDataHr
                ZZ1->ZZ1_I_FS04 := cDataHr
                ZZ1->ZZ1_F_FS04 := SPACE(13)
                ZZ1->ZZ1_I_FS05 := SPACE(13)
                ZZ1->ZZ1_F_FS05 := SPACE(13)
                ZZ1->ZZ1_I_FS06 := SPACE(13)
                ZZ1->ZZ1_F_FS06 := SPACE(13)
                //ZZ1->ZZ1_EXCLUS := cDataHr
            MsUnlock()
        EndIf

        dbSelectArea("SC5")
        If dbSeek(xFilial("SC5")+cPedido)
            RecLock("SC5",.F.)
                SC5->C5_ZZSTATU := "B" //AGUARDANDO CONFERENCIA
            MsUnlock()
        EndIf

    RestArea(aArea)
Return()

