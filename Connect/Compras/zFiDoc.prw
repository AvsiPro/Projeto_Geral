//Bibliotecas
#Include "Protheus.ch"
 
/*/{Protheus.doc} zF1Doc
Função que preenche os zeros a esquerda do documento de uma nota de entrada
@author Atilio
@since 17/12/2017
@version 1.0
@type function
/*/
 
User Function zF1Doc()
    Local aArea    := GetArea()
    Local nTamanho := TamSX3('F1_DOC')[01]
    Local lRet     := .T.
 
    //Se tiver nota fiscal digitada
    If !Empty(cNFiscal)
        //Tira os espaços, depois, adiciona zeros a esquerda conforme tamanho do campo
        cNFiscal  := Alltrim(cNFiscal)
        cNFiscal  := PadL(cNFiscal, nTamanho, '0')
        M->F1_DOC := cNFiscal
 
        //Dá um Refresh nos campos da Tela
        GetDRefresh()
    EndIf
     
    RestArea(aArea)
Return lRet
