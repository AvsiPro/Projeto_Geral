#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} IGATV01
Gatilho para alteração da data de vencimento de PA
o ponto de entrada F050MCP não tem efeito quando o titulo é do tipo PA
@type user function
@author user
@since 18/06/2025
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function IGATV01(nOpc)

Local aArea := GetArea()
Local dRet  := M->E2_VENCTO
Local dNewDt:= M->E2_XVENCPA

If !Empty(dNewDt)
    If dNewDt < M->E2_EMISSAO
        MsgAlert("Data inválida")
        M->E2_XVENCPA := ctod(' / / ')
    Else 
        If nOpc == 'A'
            dRet := dNewDt
        Else 
            dRet := datavalida(dNewDt)
        EndIf 
    EndIf 
EndIf 

RestArea(aArea)

Return(dRet)
