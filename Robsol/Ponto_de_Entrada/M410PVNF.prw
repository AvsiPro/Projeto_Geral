//Bibliotecas
#Include 'Protheus.ch'
#Include 'RwMake.ch'
 
/*------------------------------------------------------------------------------------------------------*
 | P.E.:  M410PVNF                                                                                      |
 | Desc:  Valida��o na chamada do Prep Doc Sa�da no A��es Relacionadas do Pedido de Venda               |
 | Links: http://tdn.totvs.com/pages/releaseview.action�pageId=6784152                                  |
 *------------------------------------------------------------------------------------------------------*/
 
User Function M410PVNF()
    Local lRet := .T.
    Local aArea := GetArea()
    Local aAreaC5 := SC5->(GetArea())
     
    If SC5->C5_ZZSTATU $ 'B/C'
        MsgInfo('N�o � poss�vel efetivar documentos bloqueados por inadimpl�ncia ou aguardando resposta do cliente.', 'M410PVNF')
        lRet := .F.
    EndIf
     
    RestArea(aAreaC5)
    RestArea(aArea)
Return lRet
