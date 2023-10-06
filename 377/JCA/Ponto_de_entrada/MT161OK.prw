#INCLUDE "PROTHEUS.CH"

User Function MT161OK()

Local lRetPE    := .T.
Local aPropPE   := PARAMIXB[1]
//Local cTpDocPE  := PARAMIXB[2]
Local nCont1    := 1
Local nCont2    := 1
Local nCont3    := 1
Local nCont4    := 1
Local nCont5    := 1
Local aAux      := {}
Local aAux2     := {}
Local aDados    := {}

//Primeiro são as paginas da tela de propostas
For nCont1 := 1 to len(aPropPE)
    //Segundo são os itens de cada proposta
    For nCont2 := 1 to len(aPropPE[nCont1])
        aAux := {}
        For nCont3 := 1 to len(aPropPE[nCont1][nCont2])
            If len(aPropPE[nCont1][nCont2][nCont3]) > 0
                If valtype(aPropPE[nCont1][nCont2][nCont3][1]) == "C"
                    For nCont4 := 1 to len(aPropPE[nCont1][nCont2][nCont3])
                        Aadd(aAux,aPropPE[nCont1][nCont2][nCont3][nCont4])
                    Next nCont4
                Else 
                    For nCont4 := 1 to len(aPropPE[nCont1][nCont2][nCont3])
                        aAux2 := {}
                        For nCont5 := 1 to len(aPropPE[nCont1][nCont2][nCont3][nCont4])
                            Aadd(aAux2,aPropPE[nCont1][nCont2][nCont3][nCont4][nCont5])
                        Next nCont5
                        Aadd(aAux,aAux2)
                    Next nCont4
                EndIf
            EndIf
        Next nCont3
        Aadd(aDados,aAux)
    Next nCont2
Next nCont1

gravar(aDados)

Return lRetPE

//CABEÇALHO DA PROPOSTA//
//aArray[n]         : Número da página
//aArray[n,p]       : Posição do pedido na página (1,2)
//aArray[n,p,1,x]   : Dados do cabeçalho da proposta 
//aArray[n,p,1,1 ]  : Cod Fornecedor 
//aArray[n,p,1,2 ]  : Loja 
//aArray[n,p,1,3 ]  : Nome 
//aArray[n,p,1,4 ]  : Proposta 
//aArray[n,p,1,5 ]  : Condição de pagamento 
//aArray[n,p,1,6 ]  : Frete 
//aArray[n,p,1,7 ]  : Valor total da proposta


//ITENS DA PROPOSTA// 
//aArray[n,p,2,x]       : Itens da proposta 
//aArray[n,p,2,x,1]     : Flag vencedor normal
//aArray[n,p,2,x,2]     : Item da cotação (C8_ITEM)
//aArray[n,p,2,x,3]     : Código do produto 
//aArray[n,p,2,x,4]     : Valor total
//aArray[n,p,2,x,5]     : Data de entrega
//aArray[n,p,2,x,6]     : Observações (C8_OBS)
//aArray[n,p,2,x,7]     : Filial Entrega (C8_FILENT)
//aArray[n,p,2,x,8]     : Flag finalizado 
//aArray[n,p,2,x,9]     : Recno SC8 
//aArray[n,p,2,x,10]    : Identificador (C8_IDENT)
//aArray[n,p,2,x,11]    : Total de Itens da Cotação
//aArray[n,p,2,x,12]    : Numero da Proposta (SC8->C8_NUMPRO)
//aArray[n,p,2,x,13]    : Preco Unitario (SC8->C8_PRECO)
//aArray[n,p,2,x,14]    : Flag vencedor auditoria

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 09/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function gravar(aDados)

Local aArea :=  GetArea()
Local nCont :=  1
Local nCont2:=  1

DbSelectArea("ZPS")

For nCont := 1 to len(aDados)
    If len(aDados[nCont]) > 2
        For nCont2 := 8 to len(aDados[nCont])
            Reclock("ZPS",.T.)
            //ZPS->ZPS_CODIGO := GetSXENum("ZPS","ZPS_CODIGO")
            ZPS->ZPS_COTACA := SC8->C8_NUM
            ZPS->ZPS_FORNEC := aDados[nCont,01]
            ZPS->ZPS_LOJA   := aDados[nCont,02]
            ZPS->ZPS_CONDPG := aDados[nCont,05]
            ZPS->ZPS_FRETE  := aDados[nCont,06]
            ZPS->ZPS_VLTOTP := aDados[nCont,07]

            ZPS->ZPS_FLAGWI := aDados[nCont,nCont2,01]
            ZPS->ZPS_ITEMCO := aDados[nCont,nCont2,02]
            ZPS->ZPS_PRODUT := aDados[nCont,nCont2,03]
            ZPS->ZPS_QUANT  := aDados[nCont,nCont2,11]
            ZPS->ZPS_VLRUNI := aDados[nCont,nCont2,13]
            ZPS->ZPS_VLRTOT := aDados[nCont,nCont2,04]
            ZPS->ZPS_FILENT := aDados[nCont,nCont2,07]
            ZPS->ZPS_DTENTR := aDados[nCont,nCont2,05]
            ZPS->ZPS_QTITPR := aDados[nCont,nCont2,11]
            ZPS->ZPS_OBSERV := aDados[nCont,nCont2,06]
            ZPS->(Msunlock())
        Next nCont2
        
    EndIf
Next nCont 

RestArea(aArea)

Return
