#include 'protheus.ch'
#include 'parmtype.ch'



User Function CTBA020()

Local aParam     := PARAMIXB
Local xRet       := .T.
Local oObj       := ''
Local cIdPonto   := ''
Local cIdModel   := ''
Local lIsGrid    := .F.

Local nLinha     := 0
Local nQtdLinhas := 0


If aParam <> NIL
      
    oObj       := aParam[1]
    cIdPonto   := aParam[2]
    cIdModel   := aParam[3]
    lIsGrid    := ( Len( aParam ) > 3 )
      
    If lIsGrid
        nQtdLinhas := oObj:GetQtdLine()
        nLinha     := oObj:nLine
    EndIF       
            
       
    If cIdPonto == 'FORMCOMMITTTSPOS'
		ApMsgInfo('Chamada apos a grava��o da tabela do formul�rio (FORMCOMMITTTSPOS).' + CRLF + 'ID ' + cIdModel)
            
		/*Par�metros Recebidos:

		1     O        Objeto do formul�rio ou do modelo, conforme o caso
		2     C        ID do local de execu��o do ponto de entrada
		3     C        ID do formul�rio
		4     L        Se .T. indica novo registro (Inclus�o) se .F. registro j� existente (Altera��o / Exclus�o)*/
            
    EndIf

EndIf

Return xRet
