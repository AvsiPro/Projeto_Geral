#Include "Totvs.ch"

/*/{Protheus.doc} ROBJOB05
    (long_description) Job para processar rastreio braspress
    @type User Function
    @author Felipe Mayer
    @since 09/02/2023
/*/
User Function ROBJOB05(xEmp,xFil)

Local aHeader  := {}
Local nMaxTent := 5
Local nCntTent := 0
Local nX       := 0
Local cGrava   := ''
Local cQuery   := ""

Default xEmp := '01'
Default xFil := '0103'

RpcSetType(3)
RPCSetEnv(xEmp,xFil)

cUrlInt := Alltrim(SuperGetmv('TI_APIBRAS',.F.,"https://api.braspress.com")) 
oRest   := FWRest():New(cUrlInt)
jJSON   := JsonObject():New()
cUsrId  := Alltrim(SuperGetmv('TI_USRBRAS',.F.,"ROB301_PRD:Cp2TJ2R1VD1O7qub"))

aAdd(aHeader,'Content-Type: application/json; charset=utf-8')
aAdd(aHeader,'Authorization: Basic ' + Encode64(cUsrId))
aAdd(aheader,'Cookie: JSESSIONID=998EA0B48034ADA3FAE84FB1AB0D4B6B')

cQuery := " SELECT ISNULL(CAST(CAST(C5_XBRASPR AS VARBINARY(8000)) AS VARCHAR(8000)),'') as C5_XBRASPR,* FROM " + RetSQLName("SC5") + " 
cQuery += " WHERE C5_TRANSP IN ('T3','"+IIf(cFilAnt == '0101','T1','T16')+"') "
cQuery += " AND D_E_L_E_T_=''  " 
cQuery += " AND C5_FILIAL = '"+xFilial('SC5')+"'

cAliasTMP := GetNextAlias()
MPSysOpenQuery(cQuery, cAliasTMP)


While (cAliasTMP)->(!EoF())
    If !("Entrega Realizada" $ (cAliasTMP)->C5_XBRASPR)
        nCntTent := 0
        cGrava := ''

        oRest:setPath("/v3/tracking/byNf/"+Alltrim(SM0->M0_CGC)+"/"+cValToChar(val((cAliasTMP)->C5_NOTA))+"/json")

        While .T.
            nCntTent++

            If oRest:Get(aHeader)
                jJSON:fromJSON(oRest:GetResult())
                
                If Len(jJSON:GetJsonObject('conhecimentos')) > 0 .And. Empty(cGrava)
                    aTimeLine := jJSON['conhecimentos'][1]['timeLine']
                
                    If aTimeLine != Nil
                        For nX := 1 To Len(aTimeLine)
                            cGrava += aTimeLine[nX]['descricao'] + " " + aTimeLine[nX]['data'] + CRLF + CRLF

                            If nX == Len(aTimeLine)
                                cGrava += CRLF + '<ultsts>' +aTimeLine[nX]['data'] + '-' + aTimeLine[nX]['descricao']+ '</ultsts>'

                                If SC5->(DbSeek(xFilial("SC5") + (cAliasTMP)->C5_NUM))
                                    Reclock("SC5", .F.)
                                        SC5->C5_XBRASPR := cGrava
                                    SC5->(MsUnLock())
                                    Exit
                                EndIf
                            EndIf
                        Next nX
                    EndIf
                Else
                    nCntTent := 0
                    Exit
                EndIf
            EndIf

            If nCntTent == nMaxTent
                conout('Erro ao consultar Braspress, nota: '+(cAliasTMP)->C5_NOTA)
                Exit
            EndIf
        EndDo
    EndIf

    (cAliasTMP)->(DbSkip())
EndDo

RpcClearEnv()

Return 
