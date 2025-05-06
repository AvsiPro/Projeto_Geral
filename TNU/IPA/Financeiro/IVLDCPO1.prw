#INCLUDE 'Protheus.ch'
/*/{Protheus.doc} IVLDCPO1
Validação do campo vencimento para tipo de titulo PA
Não permitir que sejam informadas datas inferiores a 8 dias
@type user function
@author Alexandre Venâncio
@since 20/04/2025
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/

User Function IVLDCPO1(cCampo)

Local aArea     := GetArea()
Local nDias     := 0
Local dDataIni  := Date() 
Local dDataFim  := M->E2_VENCTO
Local lRet      := .T.

If Alltrim(M->E2_TIPO) == "PA"
    nDias     := DateDiffDay(dDataIni, dDataFim)
    //nQtdDias  := val(SuperGetmv("TI_DIASPA",.F.,'8'))
    If nDias < 8 //nQtdDias
        MsgAlert("Nao é permitido incluir uma data de vencimento inferior a 8 dias da emissão para os titulos de PA")
        M->E2_VENCTO  := CTOD(' / / ')
        M->E2_VENCREA := CTOD(' / / ')
        lRet := .F.
    EndIf 
EndIf 

RestArea(aArea)

Return(lRet)
