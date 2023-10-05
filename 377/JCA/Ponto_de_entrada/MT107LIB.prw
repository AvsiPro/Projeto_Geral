#Include 'Totvs.ch'

/*/{Protheus.doc} MT107LIB
   @description: Ponto de entrada MT107LIB utilizado para validacao do usuario na Liberacao
   @type: User Function
   @author: Felipe Mayer
   @since: 20/09/2023
/*/

User Function MT107LIB()
    
Local lRet := .T. 
Local lAdm := RetCodUsr() == '000000'
Local cMsgAux := ''

    If Alltrim(SCP->CP_XORIGEM) == 'MNTA420'

        ZPT->(DbSetOrder(1))
        lAprov := ZPT->(DbSeek( FWxFilial('ZPT') + AvKey(RetCodUsr(),'ZPT_USER') ))

        If ( lAprov .Or. lAdm )
            lRet := .T.

            cQuery := " SELECT STJ.* FROM "+RetSqlName("SCP")+" SCP
            cQuery += " INNER JOIN "+RetSqlName("STL")+" STL
            cQuery += " 	ON TL_FILIAL = CP_FILIAL
            cQuery += " 	AND TL_NUMSA = CP_NUM
            cQuery += " 	AND TL_ITEMSA = CP_ITEM
            cQuery += " 	AND STL.D_E_L_E_T_ = ''
            cQuery += " INNER JOIN "+RetSqlName("STJ")+" STJ
            cQuery += " 	ON  TJ_FILIAL = TL_FILIAL
            cQuery += " 	AND TJ_ORDEM = TL_ORDEM
            cQuery += " 	AND STJ.D_E_L_E_T_ = ''
            cQuery += " WHERE SCP.D_E_L_E_T_ = ''
            cQuery += " 	AND CP_FILIAL = '"+FWxFilial('SCP')+"'
            cQuery += " 	AND CP_XORIGEM = 'MNTA420'
            cQuery += " 	AND CP_NUM = '"+SCP->CP_NUM+"'
            cQuery += " 	AND CP_ITEM = '"+SCP->CP_ITEM+"'
            
            cAliasTMP := GetNextAlias()
            MPSysOpenQuery(cQuery, cAliasTMP)
            
            If (cAliasTMP)->(!EoF())
                
                STJ->(DbSetOrder(1))
                If STJ->(DbSeek( (cAliasTMP)->(TJ_FILIAL + TJ_ORDEM + TJ_PLANO + TJ_TIPOOS + TJ_CODBEM + TJ_SERVICO + TJ_SEQRELA) ))
                    cMsg := FWInputBox("Informe a justificativa da liberação", "")

                    If Empty(cMsg)
                        MsgStop('Necessário preencher a justificativa da liberação', 'MT107LIB')
                        lRet := .F.
                    Else
                        RecLock('STJ', .F.)
                            STJ->TJ_SITUACA := 'L'
                        STJ->(MsUnlock())

                        cMsgAux := 'Usuário Liberação: '+UsrRetName(RetCodUsr()) + CRLF
                        cMsgAux += 'Data Liberação: '+DToC(Date()) + CRLF
                        cMsgAux += 'Hora Liberação: '+Left(Time(),5) + CRLF
                        cMsgAux += 'Justificativa: '+cMsg + CRLF
                        
                        RecLock('SCP', .F.)
                            SCP->CP_XMSGLIB := cMsgAux
                        SCP->(MsUnlock())
                    EndIf
                Else
                    MsgStop('Erro na liberação', 'MT107LIB')
                    lRet := .F.
                EndIf
            Else
                MsgStop('Erro na liberação', 'MT107LIB')
                lRet := .F.
            EndIf
            
            (cAliasTMP)->(DbCloseArea())

        Else
            MsgStop('Usuário não possui permissão para liberar a solicitação.', 'MT107LIB')
            lRet := .F.
        EndIf        
    EndIf

Return lRet
