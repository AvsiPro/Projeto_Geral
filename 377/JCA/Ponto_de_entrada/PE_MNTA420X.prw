#Include 'Totvs.ch'

/*/{Protheus.doc} MNTA420X
   Bloqueio de peças por tempo previsto 
   @type: User Function
   @author: Felipe Mayer
   @since: 19/09/2023
/*/
User Function MNTA420X()
    
Local lLibera := .T.

    If Inclui .And. STL->TL_TIPOREG == 'P'
        cQuery := " SELECT * FROM "+RetSqlName("STL")+" STL
        cQuery += " INNER JOIN "+RetSqlName("STJ")+" STJ
        cQuery += " 	ON  TJ_FILIAL = TL_FILIAL
        cQuery += " 	AND TJ_ORDEM = TL_ORDEM
        cQuery += " 	AND STJ.D_E_L_E_T_ = ''
        cQuery += " INNER JOIN "+RetSqlName("ZPO")+" ZPO
        cQuery += " 	ON ZPO_FILIAL = ''
        cQuery += " 	AND ZPO_CODIGO = TL_CODIGO
        cQuery += " 	AND ZPO.D_E_L_E_T_ = ''
        cQuery += " WHERE STL.D_E_L_E_T_ = ''
        cQuery += "     AND TL_FILIAL = '"+FWxFilial('STL')+"' "
        cQuery += " 	AND TL_CODIGO = '"+STL->TL_CODIGO+"'
        cQuery += " 	AND TL_SEQRELA = '1'
        cQuery += " 	AND TL_TIPOREG = 'P'
        
        cAliasTMP := GetNextAlias()
        MPSysOpenQuery(cQuery, cAliasTMP)
        
        If (cAliasTMP)->(!EoF())
            
            If (cAliasTMP)->ZPO_TIPO == '1' .Or. (cAliasTMP)->ZPO_TIPO == '3' //Contador
                lLibera := Iif((cAliasTMP)->ZPO_CONTAD >= STJ->TJ_POSCONTAD,.T.,.F.)
            EndIf

            If ((cAliasTMP)->ZPO_TIPO == '2' .Or. (cAliasTMP)->ZPO_TIPO == '3') .And. lLibera //Tempo

                dIniAtu := STL->TL_DTINICI
                dFimAnt := SToD((cAliasTMP)->TL_DTFIM)
                nTempo  := (cAliasTMP)->ZPO_TEMPO

                If (cAliasTMP)->ZPO_TPTEMP == 'M' //mes
                    lLibera := Iif(DateDiffMonth(dFimAnt, dIniAtu) > nTempo,.T.,.F.)

                ElseIf (cAliasTMP)->ZPO_TPTEMP == 'S' //semana
                    lLibera := Iif(GetWeekDifference(dFimAnt, dIniAtu) > nTempo ,.T.,.F.)

                ElseIf (cAliasTMP)->ZPO_TPTEMP == 'D' //dia
                    lLibera := Iif(DateDiffDay(dFimAnt, dIniAtu) > nTempo,.T.,.F.)

                ElseIf (cAliasTMP)->ZPO_TPTEMP == 'H' //hora
                    
                    cHrIniAtu := STL->TL_HOINICI
                    cHrFimAnt := (cAliasTMP)->TL_HOFIM

                    dateTime1 := DToC(dFimAnt) + " " + cHrFimAnt
                    dateTime2 := DToC(dIniAtu) + " " + cHrIniAtu

                    lLibera := Iif(GetHourDifference(dateTime1, dateTime2) > nTempo,.T.,.F.)
                EndIf

            EndIf

        EndIf
        
        (cAliasTMP)->(DbCloseArea())

        If !lLibera
            MsgInfo('Bloqueado de acordo com a regra de peças com tempo previsto.')
            STJ->TJ_SITUACA := 'B'
            
            If NGIFDBSEEK("SCP",STL->TL_NUMSA+STL->TL_ITEMSA,1,.F.)
                RecLock('SCP', .F.)
                    SCP->CP_STATSA  := 'B'
                    SCP->CP_SALBLQ  := SCP->CP_QUANT
                    SCP->CP_XORIGEM := Alltrim(FunName())
                SCP->(MsUnlock())
            EndIf
        EndIf
    EndIf

Return .T.


Static function GetWeekFromDate(dt)
local dia, mes, ano, data1, data2, dif, semana

// Obtenha o dia, mês e ano da data
dia := DAY(dt)
mes := MONTH(dt)
ano := YEAR(dt)

// Crie uma data de referência (01/01/ANO) para o início do ano
data1 := CTOD("01/01/" + alltrim(STR(ano, 4)))

// Encontre o próximo domingo após a data de referência
data2 := data1 + (7 - DAY(data1) + 1)

// Calcule a diferença entre a data de referência e a data fornecida
dif := dt - data1

// Calcule o número da semana
semana := (dif + 1) / 7 + 1

return semana


Static function GetWeekDifference(startDate, endDate)
local semanaInicio, semanaFim, diferenca

semanaInicio := GetWeekFromDate(startDate)
semanaFim := GetWeekFromDate(endDate)

diferenca := semanaFim - semanaInicio

return Int(diferenca)


Static function GetHourDifference(dateTime1, dateTime2)
local date1, time1, date2, time2, hourDifference

// Separa a data e a hora da primeira string
date1 := CTOD(SUBSTR(dateTime1, 1, 10))
time1 := SUBSTR(dateTime1, 12)

// Separa a data e a hora da segunda string
date2 := CTOD(SUBSTR(dateTime2, 1, 10))
time2 := SUBSTR(dateTime2, 12)

// Calcula a diferença em dias
local daysDifference := DateDiffDay(date1, date2)

// Calcula a diferença em horas
local hour1 := VAL(SUBSTR(time1, 1, 2))
local minute1 := VAL(SUBSTR(time1, 4, 2))
local hour2 := VAL(SUBSTR(time2, 1, 2))
local minute2 := VAL(SUBSTR(time2, 4, 2))

local minutesDifference := (hour2 - hour1) * 60 + (minute2 - minute1)

// Calcula a diferença em horas
hourDifference := (daysDifference * 24) + (minutesDifference / 60.0)

return hourDifference
