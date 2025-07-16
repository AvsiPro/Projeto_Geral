#INCLUDE 'PROTHEUS.CH'
/*/{Protheus.doc} MT120FIM
Ponto de entrada no final da gravação do pedido de compra
utilizado para os casos onde o usuario esta incluindo uma PA amarrada ao pedido
caso o pedido já esteja liberado no inicio do processo, deverá permanecer após a atualização
@type user function
@author user
@since 02/05/2025
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function MT120FIM()

Local nOpcao := PARAMIXB[1]   // Opção Escolhida pelo usuario  3 incluir 4 alterar
Local cNumPC := PARAMIXB[2]   // Numero do Pedido de Compras
Local nOpcA  := PARAMIXB[3]   // Indica se a ação foi Cancelada = 0  ou Confirmada = 1
Local cQuery 
Local lLibOk := type("lLibera") != "U"

If nOpcA == 1 .And. nOpcao == 4
    cQuery := " SELECT COUNT(*) AS QTD" 
    cQuery += " FROM "+RetSQLName("FIE")+" FIE" 
    cQuery += " INNER JOIN "+RetSQLName("SE2")+" E2 ON E2_FILIAL=FIE_FILIAL AND E2_PREFIXO=FIE_PREFIX AND E2_NUM=FIE_NUM "
    cQuery += " AND E2_PARCELA=FIE_PARCEL AND E2_TIPO=FIE_TIPO AND E2_FORNECE=FIE_FORNEC AND E2_LOJA=FIE_LOJA AND E2.D_E_L_E_T_=' '" 
    cQuery += " AND E2_EMISSAO >= '"+dtos(dDataBase)+"'" 
    cQuery += " WHERE FIE_PEDIDO = '"+cNumPC+"' AND FIE.D_E_L_E_T_ = ' '  " 

    PlsQuery(cQuery, "TRB")
    DbSelectArea("TRB")
    nTotal := TRB->QTD

    If nTotal > 0 .And. lLibOk
        If lLibera

            DbSelectArea("SC7")
            DbSetOrder(1)
            If DbSeek(xFilial("SC7")+cNumPC)
                While !EOF() .And. SC7->C7_FILIAL == xFilial("SC7") .And. SC7->C7_NUM == cNumPC
                    Reclock("SC7",.F.)
                    SC7->C7_CONAPRO := 'L'
                    SC7->(Msunlock())
                    Dbskip()
                EndDo 
            EndIf 
        EndIf 
    EndIF 
    
EndIf 

Return
