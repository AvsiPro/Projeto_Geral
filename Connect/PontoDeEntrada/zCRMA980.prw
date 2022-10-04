#INCLUDE 'protheus.ch'
#INCLUDE 'FWMVCDef.ch'

User Function CRMA980() As Variant
    Local aParam As Array
    Local cIDPonto As Character
    Local cIDModel As Character
    Local oObj As Object
    Local xRet As Variant

    aParam := PARAMIXB
    xRet := .T.

    If aParam <> NIL
        oObj := aParam[1]                               // Objeto do formul�rio ou do modelo, conforme o caso.
        cIDPonto := aParam[2]                           // ID do local de execu��o do ponto de entrada.
        cIDModel := aParam[3]                           // ID do formul�rio.

        If (cIDPonto == "MODELPRE")                     // Antes da altera��o de qualquer campo do modelo.
        ElseIf (cIDPonto == "MODELPOS")                 // Na valida��o total do modelo.
        ElseIf (cIDPonto == "FORMPRE")                  // Antes da altera��o de qualquer campo do formul�rio.
        ElseIf (cIDPonto == "FORMPOS")                  // Na valida��o total do formul�rio.
        ElseIf (cIDPonto == "FORMLINEPRE")              // Antes da altera��o da linha do formul�rio FWFORMGRID.
        ElseIf (cIDPonto == "FORMLINEPOS")              // Na valida��o total da linha do formul�rio FWFORMGRID.
        ElseIf (cIDPonto == "MODELCOMMITTTS")           // Ap�s a grava��o total do modelo e dentro da transa��o.
        ElseIf (cIDPonto == "MODELCOMMITNTTS")          // Ap�s a grava��o total do modelo e fora da transa��o.
        ElseIf (cIDPonto == "FORMCOMMITTTSPRE")         // Antes da grava��o da tabela do formul�rio.
        ElseIf (cIDPonto == "FORMCOMMITTTSPOS")         // Ap�s a grava��o da tabela do formul�rio.
        ElseIf (cIDPonto == "FORMCANCEL")               // No cancelamento do bot�o.
        ElseIf (cIDPonto == "MODELVLDACTIVE")           // Na ativa��o do modelo
        ElseIf (cIDPonto == "BUTTONBAR")                // Para a inclus�o de bot�es na ControlBar.
            xRet    := {{'Consulta CNPJ',;                                                  //Titulo para o bot�o
                                            'CONSULTAR',;                                              //Nome do Bitmap para exibi��o
                                            {|| U_zCNPJSA1()},;         //CodeBlock a ser executado
                                            'Este bot�o consulta o CNPJ e retorna os resultados.'}}           //ToolTip (Opcional)
        ENDIF

    EndIf

Return (xRet)
