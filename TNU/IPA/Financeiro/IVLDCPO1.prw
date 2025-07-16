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
Local cGrupPer  := SuperGetMV("TI_GRPPRM",.F.,"000001")
Local aGrupUsr  := UsrRetGrp()
Local nX        := 0
Local lPerm     := .F.

If Alltrim(M->E2_TIPO) != "PA"
    For nX := 1 to len(aGrupUsr)
        nPos := Ascan(aGrupUsr,{|x| x $ cGrupPer})
        If nPos > 0
            lPerm := .T.
            exit 
        EndIf 
    Next nX 

    nDias     := DateDiffDay(dDataIni, dDataFim)
    nQtdDias  := val(Alltrim(SuperGetMV("TI_DIAVCT",.F.,"8")))
    
    If nDias < nQtdDias .And. !lPerm
        MsgAlert("Nao é permitido incluir uma data de vencimento inferior a 8 dias da emissão!!!") //para os titulos de PA
        M->E2_VENCTO  := CTOD(' / / ')
        M->E2_VENCREA := CTOD(' / / ')
        lRet := .F.
    EndIf 
EndIf 

RestArea(aArea)

Return(lRet)



