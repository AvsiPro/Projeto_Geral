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
        oObj := aParam[1]                               // Objeto do formulário ou do modelo, conforme o caso.
        cIDPonto := aParam[2]                           // ID do local de execução do ponto de entrada.
        cIDModel := aParam[3]                           // ID do formulário.

        If (cIDPonto == "MODELPRE")                     // Antes da alteração de qualquer campo do modelo.
        ElseIf (cIDPonto == "MODELPOS")                 // Na validação total do modelo.
        ElseIf (cIDPonto == "FORMPRE")                  // Antes da alteração de qualquer campo do formulário.
        ElseIf (cIDPonto == "FORMPOS")                  // Na validação total do formulário.
        ElseIf (cIDPonto == "FORMLINEPRE")              // Antes da alteração da linha do formulário FWFORMGRID.
        ElseIf (cIDPonto == "FORMLINEPOS")              // Na validação total da linha do formulário FWFORMGRID.
        ElseIf (cIDPonto == "MODELCOMMITTTS")           // Após a gravação total do modelo e dentro da transação.
        ElseIf (cIDPonto == "MODELCOMMITNTTS")          // Após a gravação total do modelo e fora da transação.
        ElseIf (cIDPonto == "FORMCOMMITTTSPRE")         // Antes da gravação da tabela do formulário.
        ElseIf (cIDPonto == "FORMCOMMITTTSPOS")         // Após a gravação da tabela do formulário.
        ElseIf (cIDPonto == "FORMCANCEL")               // No cancelamento do botão.
        ElseIf (cIDPonto == "MODELVLDACTIVE")           // Na ativação do modelo
        ElseIf (cIDPonto == "BUTTONBAR")                // Para a inclusão de botões na ControlBar.
            xRet    := {{'Consulta CNPJ',;                                                  //Titulo para o botão
                                            'CONSULTAR',;                                              //Nome do Bitmap para exibição
                                            {|| U_zCNPJSA1()},;         //CodeBlock a ser executado
                                            'Este botão consulta o CNPJ e retorna os resultados.'}}           //ToolTip (Opcional)
        ENDIF

    EndIf

Return (xRet)
