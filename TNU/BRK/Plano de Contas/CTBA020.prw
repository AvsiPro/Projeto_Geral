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
		ApMsgInfo('Chamada apos a gravação da tabela do formulário (FORMCOMMITTTSPOS).' + CRLF + 'ID ' + cIdModel)
            
		/*Parâmetros Recebidos:

		1     O        Objeto do formulário ou do modelo, conforme o caso
		2     C        ID do local de execução do ponto de entrada
		3     C        ID do formulário
		4     L        Se .T. indica novo registro (Inclusão) se .F. registro já existente (Alteração / Exclusão)*/
            
    EndIf

EndIf

Return xRet
