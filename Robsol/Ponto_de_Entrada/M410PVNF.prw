//Bibliotecas
#Include 'Protheus.ch'
#Include 'RwMake.ch'
 
/*------------------------------------------------------------------------------------------------------*
 | P.E.:  M410PVNF                                                                                      |
 | Desc:  Validação na chamada do Prep Doc Saída no Ações Relacionadas do Pedido de Venda               |
 | Links: http://tdn.totvs.com/pages/releaseview.actionçpageId=6784152                                  |
 *------------------------------------------------------------------------------------------------------*/
 
User Function M410PVNF()
    Local lRet := .T.
    Local aArea := GetArea()
    Local aAreaC5 := SC5->(GetArea())
     
    If SC5->C5_ZZSTATU $ 'B/C'
        MsgInfo('Não é possível efetivar documentos bloqueados por inadimplência ou aguardando resposta do cliente.', 'M410PVNF')
        lRet := .F.
    EndIf
     
    RestArea(aAreaC5)
    RestArea(aArea)
Return lRet
