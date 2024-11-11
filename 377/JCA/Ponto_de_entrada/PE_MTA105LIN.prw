#INCLUDE 'PROTHEUS.CH'
/////////////////////////////////////////////////////////////////////////////////
//    Ponto de entrada na rotina de solicitação ao armazem                     // 
//                                                                             // 
//    Utilizado para validar se a peça que esta sendo incluida na os vinda do  //
// GFR entra na regra de bloqueio por tempo de uso ou contador de km           // 
/////////////////////////////////////////////////////////////////////////////////
// Alexandre Venancio - 10/06/24 - criação                                     //
/////////////////////////////////////////////////////////////////////////////////

User Function MTA105LIN

Local aArea := GetArea()
Local lRet  := .T.
Local lBloq := .T.
Local nPosP := Ascan(aHeader,{|x| alltrim(x[2]) == "CP_PRODUTO"})
Local nPosO := Ascan(aHeader,{|x| alltrim(x[2]) == "CP_OP"})

If !Empty(aCols[n,nPosP])
    cOrdem := SUBSTR(aCols[n,nPosO],1,6)
    cCodBem := Posicione("STJ",1,xFilial("STJ")+cOrdem,"TJ_CODBEM")
    cContad := Posicione("STJ",1,xFilial("STJ")+cOrdem,"TJ_POSCONT")
    If !Empty(cOrdem)
        lBloq := U_xvld105(aCols[n,nPosP],cCodBem,cOrdem,cContad)
    endif

EndIf 

RestArea(aArea)

Return(lRet)


/*/{Protheus.doc} validOP
    (long_description)
    @type  Static Function
    @author user
    @since 18/06/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
User Function xvld105(cProduto,cCodBem,cOrdem,cContad)

Local aArea     := GetArea()
Local cQuery    := '' 
Local lLibera   := .T.

cQuery := "SELECT *"
cQuery += " FROM "+RetSQLName("STJ")+" STJ"
cQuery += " INNER JOIN "+RetSQLName("STL")+" STL ON TJ_FILIAL = TL_FILIAL"
cQuery += "        AND TJ_ORDEM = TL_ORDEM"
cQuery += "        AND STL.D_E_L_E_T_ = ' '"
cQuery += "        AND TL_TIPOREG = 'P'"
cQuery += "        AND TL_CODIGO='"+cProduto+"'"
cQuery += " INNER JOIN "+RetSQLName("ZPO")+" ZPO ON ZPO_FILIAL = '"+xFilial("ZPO")+"'"
cQuery += "        AND (ZPO_CODIGO = TL_CODIGO  OR ZPO_CODIGO "
cQuery += "             IN(SELECT B1_XCODPAI FROM "+RetSQLName("SB1")+" WHERE B1_FILIAL=' ' AND B1_COD='"+cProduto+"'))"

cQuery += "        AND ZPO.D_E_L_E_T_ = ' '"
cQuery += " WHERE  STJ.D_E_L_E_T_ = ' '"
cQuery += "  AND TJ_FILIAL BETWEEN ' ' AND 'ZZ'"
cQuery += "  AND TJ_CODBEM='"+cCodBem+"'"
cQuery += "     AND TL_ORDEM <> '"+cOrdem+"'"
cQuery += "     ORDER BY TL_ORDEM DESC,ZPO_CODIGO DESC"

cAliasTMP := GetNextAlias()
MPSysOpenQuery(cQuery, cAliasTMP)

If (cAliasTMP)->(!EoF())
    
    lLibera := .t.
    
    If (cAliasTMP)->ZPO_TIPO == '1' .Or. (cAliasTMP)->ZPO_TIPO == '3' //Contador
        lLibera := Iif((cAliasTMP)->ZPO_CONTAD < (cContad - (cAliasTMP)->TJ_POSCONT),.T.,.F.)
    EndIf

    If ((cAliasTMP)->ZPO_TIPO == '2' .Or. (cAliasTMP)->ZPO_TIPO == '3') .And. !lLibera //Tempo

        dIniAtu := stod((cAliasTMP)->TL_DTINICI)
        dFimAnt := SToD((cAliasTMP)->TL_DTFIM)
        nTempo  := (cAliasTMP)->ZPO_TEMPO

        If (cAliasTMP)->ZPO_TPTEMP == 'M' //mes
            lLibera := Iif(DateDiffMonth(dFimAnt, dIniAtu) > nTempo,.T.,.F.)

        ElseIf (cAliasTMP)->ZPO_TPTEMP == 'S' //semana
            lLibera := Iif(GetWeekDifference(dFimAnt, dIniAtu) > nTempo ,.T.,.F.)

        ElseIf (cAliasTMP)->ZPO_TPTEMP == 'D' //dia
            lLibera := Iif(DateDiffDay(dFimAnt, dIniAtu) > nTempo,.T.,.F.)

        ElseIf (cAliasTMP)->ZPO_TPTEMP == 'H' //hora
            
            cHrIniAtu := (cAliasTMP)->TL_HOINICI
            cHrFimAnt := (cAliasTMP)->TL_HOFIM

            dateTime1 := DToC(dFimAnt) + " " + cHrFimAnt
            dateTime2 := DToC(dIniAtu) + " " + cHrIniAtu

            lLibera := Iif(GetHourDifference(dateTime1, dateTime2) > nTempo,.T.,.F.)
        EndIf

    EndIf

EndIf

(cAliasTMP)->(DbCloseArea())



If lLibera 
    //Busca por produtos que estejam na SCP mas não estejam na STL, inclusão direta na solicitação ao armazem
    cQuery := "SELECT * 
    cQuery += " FROM "+RetSQLName("SCP")+" SCP"
    cQuery += " INNER JOIN "+RetSQLName("ZPO")+" ZPO ON ZPO_FILIAL = '"+xFilial("ZPO")+"'"
    cQuery += " AND (ZPO_CODIGO = CP_PRODUTO OR ZPO_CODIGO IN(SELECT B1_XCODPAI FROM "+RetSQLName("SB1")
    cQuery += " WHERE  B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD='"+cProduto+"   ') ) AND ZPO.D_E_L_E_T_ = ' '"
    cQuery += " LEFT JOIN "+RetSQLName("STJ")+" TJ1 ON TJ1.TJ_FILIAL=CP_FILIAL AND TJ1.TJ_ORDEM=SUBSTRING(CP_OP,1,6) AND TJ1.D_E_L_E_T_=' '"
    cQuery += " WHERE  CP_FILIAL BETWEEN ' ' AND 'ZZ' AND SUBSTRING(CP_OP,1,6) <> '"+cOrdem+"'"
    cQuery += " AND TRIM(CP_OBS)='"+cCodBem+"'"
    cQuery += " AND SCP.D_E_L_E_T_=' '
    cQuery += " AND CP_FILIAL+SUBSTRING(CP_OP,1,6)+CP_PRODUTO NOT IN(SELECT TL_FILIAL+TL_ORDEM+TL_CODIGO"
    cQuery += "     FROM "+RetSQLName("STL")+" WHERE TL_FILIAL='"+xFilial("STL")+"' AND TL_ORDEM='"+cOrdem+"' AND D_E_L_E_T_=' ')
    cQuery += " ORDER BY  CP_NUM,ZPO_CODIGO DESC "

    cAliasTMP := GetNextAlias()
    MPSysOpenQuery(cQuery, cAliasTMP)

    If (cAliasTMP)->(!EoF())
        
        lLibera := .t.
        
        If (cAliasTMP)->ZPO_TIPO == '1' .Or. (cAliasTMP)->ZPO_TIPO == '3' //Contador
            lLibera := Iif((cAliasTMP)->ZPO_CONTAD < (cContad - (cAliasTMP)->TJ_POSCONT),.T.,.F.)
        EndIf

        If ((cAliasTMP)->ZPO_TIPO == '2' .Or. (cAliasTMP)->ZPO_TIPO == '3') .And. !lLibera //Tempo

            dIniAtu := stod((cAliasTMP)->TL_DTINICI)
            dFimAnt := SToD((cAliasTMP)->TL_DTFIM)
            nTempo  := (cAliasTMP)->ZPO_TEMPO

            If (cAliasTMP)->ZPO_TPTEMP == 'M' //mes
                lLibera := Iif(DateDiffMonth(dFimAnt, dIniAtu) > nTempo,.T.,.F.)

            ElseIf (cAliasTMP)->ZPO_TPTEMP == 'S' //semana
                lLibera := Iif(GetWeekDifference(dFimAnt, dIniAtu) > nTempo ,.T.,.F.)

            ElseIf (cAliasTMP)->ZPO_TPTEMP == 'D' //dia
                lLibera := Iif(DateDiffDay(dFimAnt, dIniAtu) > nTempo,.T.,.F.)

            ElseIf (cAliasTMP)->ZPO_TPTEMP == 'H' //hora
                
                cHrIniAtu := (cAliasTMP)->TL_HOINICI
                cHrFimAnt := (cAliasTMP)->TL_HOFIM

                dateTime1 := DToC(dFimAnt) + " " + cHrFimAnt
                dateTime2 := DToC(dIniAtu) + " " + cHrIniAtu

                lLibera := Iif(GetHourDifference(dateTime1, dateTime2) > nTempo,.T.,.F.)
            EndIf

        EndIf

    EndIf

    (cAliasTMP)->(DbCloseArea())

EndIf 

RestArea(aArea)

Return(lLibera)

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
