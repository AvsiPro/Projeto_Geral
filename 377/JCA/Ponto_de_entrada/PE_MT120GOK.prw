#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

/*--------------------------------------------------------------------------------------------------------------*
 | P.E.:  MT120GOK                                                                                              |
 | Desc:  Tratamento no PC antes de sua contabiliza                             |
 |Rodrigo Barreto 02/06/2023                                                       |
*--------------------------------------------------------------------------------------------------------------*/


User Function MT120GOK()

    //Function A120PEDIDO - Função do Pedido de Compras e Autorização de Entrega responsavel pela inclusão,7
    // alteração, exclusão e cópia dos PCs.

    PRIVATE cPedido    :=  PARAMIXB[1] // Numero do Pedido
    PRIVATE lInclui    :=  PARAMIXB[2] // Inclusão
    PRIVATE lAltera    :=  PARAMIXB[3] // Alteração
    PRIVATE lExclusao  :=  PARAMIXB[4] // Exclusão
    PRIVATE cGrupo := ""
    PRIVATE cItem := ""

    IF (lInclui .or. lAltera) .AND. IsInCallStack('MSEXECAUTO')
        dbSelectArea('SCR')
        SCR->(dbSetOrder(1))
        //deleta registro na tabela SCR
        IF SCR->(dbSeek(XFilial("SCR")+"PC"+cPedido))
            MaAlcDoc({SCR->CR_NUM,"PC",SCR->CR_TOTAL,,,,,1,1,},SCR->CR_EMISSAO,3)                
        EndIf

        IF SCR->(dbSeek(XFilial("SCR")+"IP"+cPedido))
            MaAlcDoc({SCR->CR_NUM,"IP",SCR->CR_TOTAL,,,,,1,1,},SCR->CR_EMISSAO,3)
        ENDIF

        dbSelectArea("SC7")
        SC7->(dbSetOrder(1))
        IF SC7->(dbSeek(XFilial("SC7")+cPedido))
            WHILE !SC7->( EOF()) //.AND. ALLTRIM(SC7->C7_NUM) == ALLTRIM(cCodigo)
                RecLock("SC7", .F.)
                SC7->C7_CONAPRO := "L"
                SC7->C7_APROV   := ""
                lOk := .T.
                MsUnlock()
                SC7->(dbSkip())
            ENDDO
        ENDIF
    ENDIF
Return


       
        

           
