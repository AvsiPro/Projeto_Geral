//Bibliotecas
#Include "Protheus.ch"
 
/*------------------------------------------------------------------------------------------------------*
 | P.E.:  FA750BRW                                                                                      |
 | Desc:  Adiciona ações relacionadas no Funções Contas a Pagar                                         |
 | Links: http://tdn.totvs.com/pages/releaseview.actionçpageId=6071251                                  |
 *------------------------------------------------------------------------------------------------------*/
 
User Function FA750BRW()
    Local aRotina:={}

    aAdd(aRotina, { "CNAB Folha"    , "u_GeraTxt()" , 0 , 4,15,NIL})
    aAdd(aRotina, { "Retorno CNAB Folha"    , "u_ProcTxt()" , 0 , 4,15,NIL})
Return aRotina
