#INCLUDE 'TOTVS.CH'
#INCLUDE 'RESTFUL.CH'

#Define  _CRLF  CHR(13)+CHR(10)

/*        
+-----------+------------+----------------+-------------------+-------+---------------+
| Programa  |INTWEB01    | Desenvolvedor  | Guilherme Lopes   | Data  | 06/05/2024    |
+-----------+------------+----------------+-------------------+-------+---------------+
| Descricao | Classe REST responsável pela integração com a SIGOWEB                   |
|           |				                                                          |
+-----------+-------------------------------------------------------------------------+
| Modulos   | 		                                                                  |
+-----------+-------------------------------------------------------------------------+
| Processos |                                                                         |
+-----------+-------------------------------------------------------------------------+
|                  Modificacoes desde a construcao inicial                            |
+----------+-------------+------------------------------------------------------------+
| DATA     | PROGRAMADOR | MOTIVO                                                     |
+----------+-------------+------------------------------------------------------------+
|          |             |                                                            |
+----------+-------------+------------------------------------------------------------+
*/
WSRESTFUL WSSIGOWEB DESCRIPTION "Integrações SIGOWEB"

    WSDATA grupo AS CHARACTER
    WSDATA unidade AS CHARACTER
	WSDATA cpf AS CHARACTER
	WSDATA status AS CHARACTER
	WSDATA datademissao AS CHARACTER
    WSDATA dataDemisDe AS CHARACTER
    WSDATA dataDemisAte AS CHARACTER
	WSDATA matricula AS CHARACTER
    
    WsMethod GET Description "Sincronização de dados via GET" WsSyntax "/GET/{method}"
    
END WSRESTFUL


/* {Protheus.doc} GET
Método GET retornar dados de acordo com método informado

@author Guilherme Lopes
@since 07/05/2024
@version P12

*/
//-------------------------------------------------------------------------------
WSMETHOD GET WSRECEIVE cnpj, cpf, status, datademissao, matricula, dataDemisDe, dataDemisAte WSSERVICE WSSIGOWEB
	
	Local cGrupo    := ::grupo
    Local cUnidade  := ::unidade
	Local cCPF	    := ::cpf
    Local cStatus   := ::status
    Local cDDemis   := ::datademissao
    Local cDemDe    := ::dataDemisDe
    Local cDemAte   := ::dataDemisAte
    Local cMat      := ::matricula
    Local aParUrl   := ::aURLParms
	
	Local oRet
	Local lRet		:= .T.
    conOut("INTWEB01:JSON", ::GetContent())
    // define o tipo de retorno do método
	::SetContentType("application/json")

    If Len(aParUrl) > 0

        If aParUrl[1] == "unidades"
            oRet := fGetUnid()
            cRet := oRet:toJSON()
        ElseIf aParUrl[1] == "empregados"
            If !Empty(AllTrim(cGrupo))
                oRet := fGetEmpre(cGrupo, cUnidade, cCPF, cStatus, cDemDe, cDemAte)
                cRet := oRet:toJSON()
            Else
                cRet := '{"erro": "Grupo não informado."}'
            EndIf
        ElseIf aParUrl[1] == "setores"
            If !Empty(AllTrim(cGrupo))
                oRet := fGetSetores(cGrupo)
                cRet := oRet:toJSON()
            Else
                cRet := '{"erro": "Grupo não informado."}'
            EndIf
        ElseIf aParUrl[1] == "cargos"
            If !Empty(AllTrim(cGrupo))
                oRet := fGetCargos(cGrupo)
                cRet := oRet:toJSON()
            Else
                cRet := '{"erro": "Grupo não informado."}'
            EndIf
        ElseIf aParUrl[1] == "movimentos"
            If !Empty(AllTrim(cGrupo))
                oRet := fGetMov(cGrupo, cUnidade, cMat, cStatus, cDemDe, cDemAte)
                cRet := oRet:toJSON()
            Else
                cRet := '{"erro": "Grupo não informado."}'
            EndIf
        ElseIf aParUrl[1] == "transferencias" 
            If !Empty(AllTrim(cGrupo))
                oRet := fGetTransf(cGrupo, cUnidade, cMat)
                cRet := oRet:toJSON()
            Else
                cRet := '{"erro": "Grupo não informado."}'
            EndIf
        Else
            cRet := '{"erro": "Método não dispponível."}'
        Endif

        ::SetResponse(EncodeUtf8( cRet, 'cp1252' ))
    Else
        lRet := .F.
        SetRestFault(400,'Metodo não informado!!!')
    Endif

Return lRet

Static Function fGetUnid()

    Local aSm0      := FWLoadSM0()
    Local oJsonRet  := JSonObject():New()
    Local nI        := 0

    oJsonRet["data"] := {}

    For nI  := 1 To Len(aSm0)

        oJsonAux := JSonObject():New()

        oJsonAux['grupo'] := aSm0[nI,1]
        oJsonAux['unidade'] := aSm0[nI,2]
        oJsonAux['nome'] := aSm0[nI,7]
        oJsonAux['cnpj'] := aSm0[nI,18]

        Aadd(oJsonRet['data'],oJsonAux)

    Next nI

Return oJsonRet

Static Function fGetEmpre(cGrupo, cUnidade, cCPF, cStatus, cDemDe, cDemAte)

    Local cQuery    := ""
    Local cAliTmp   := GetNextAlias()
    Local oJsonRet  := JSonObject():New()

    oJsonRet["data"] := {}

    DbSelectArea("SRE")

    cQuery := "SELECT " + _CRLF
    cQuery += "M0_CGC CNPJ, " + _CRLF
    cQuery += "M0_CODIGO+M0_CODFIL CODIGO_LOCAL, " + _CRLF
    cQuery += "RA_CIC CPF, " + _CRLF
    cQuery += "RA_NOME NOME, " + _CRLF
    cQuery += "'' REGIME_PUBLICO, " + _CRLF
    cQuery += "CASE " + _CRLF
    cQuery += "WHEN RA_CODFUNC = '10206' THEN 'E' " + _CRLF
    cQuery += "ELSE 'F' " + _CRLF
    cQuery += "END AS TIPO_COLABORADOR, " + _CRLF
    cQuery += "RA_MAT MATRICULA_EMPRESA, " + _CRLF
    cQuery += "RA_CODUNIC MATRICULAESOCIAL, " + _CRLF
    cQuery += "RA_RG RG, " + _CRLF
    cQuery += "RA_SEXO SEXO, " + _CRLF
    cQuery += "SUBSTRING(RA_NASC,7,2) + '/' + SUBSTRING(RA_NASC,5,2) + '/' + SUBSTRING(RA_NASC,1,4) DATA_NASCIMENTO, " + _CRLF
    cQuery += "ISNULL((SELECT RE_DATA FROM SRE"+cGrupo+"0 RE WHERE RE_MATP = RA_MAT AND RE_FILIALP = RA_FILIAL AND RE_EMPP = '"+cGrupo+"' AND RE_EMPP <> RE_EMPD AND RE.D_E_L_E_T_ <> '*'),'') TRANSF, " + _CRLF
    cQuery += "SUBSTRING(RA_ADMISSA,7,2) + '/' + SUBSTRING(RA_ADMISSA,5,2) + '/' + SUBSTRING(RA_ADMISSA,1,4) DATA_ADMISSAO, " + _CRLF
    cQuery += "RA_DEMISSA DATA_DEMISSAO, " + _CRLF
    cQuery += "RA_NUMCP CTPS_NUMERO, " + _CRLF
    cQuery += "RA_SERCP CTPS_SERIE, " + _CRLF
    cQuery += "RA_UFCP CTPS_ORGAO, " + _CRLF
    cQuery += "RA_PIS NIS, " + _CRLF
    cQuery += "RA_DDDCELU CELULAR_DDD, " + _CRLF
    cQuery += "RA_NUMCELU CELULAR_NUMERO, " + _CRLF
    cQuery += "RA_EMAIL EMAIL, " + _CRLF
    cQuery += "RA_RESCRAI, " + _CRLF
    cQuery += "RA_SITFOLH " + _CRLF
    cQuery += "FROM SRA"+cGrupo+"0 RA " + _CRLF
    cQuery += "INNER JOIN SYS_COMPANY AS M0 " + _CRLF
    cQuery += "ON M0_CODIGO = '"+cGrupo+"' " + _CRLF
    cQuery += "AND M0_CODFIL = RA_FILIAL " + _CRLF
    cQuery += "AND M0.D_E_L_E_T_ <> '*' " + _CRLF
    cQuery += "WHERE RA.D_E_L_E_T_ <> '*' " + _CRLF
    cQuery += "AND RA_CIC <> '' " + _CRLF

    If !Empty(AllTrim(cUnidade))
        cQuery += "AND RA_FILIAL = '"+cUnidade+"' " + _CRLF
    EndIf
    If !Empty(AllTrim(cCPF))
        cQuery += "AND RA_CIC = '"+cCPF+"' " + _CRLF
    EndIf
    If cStatus == 'd'
        cQuery += "AND RA_SITFOLH = 'D' " + _CRLF
        cQuery += "AND RA_DEMISSA BETWEEN '"+cDemDe+"' AND '"+cDemAte+"' " + _CRLF
    ElseIf cStatus == 'a'
        cQuery += "AND RA_SITFOLH <> 'D' " + _CRLF
        cQuery += "AND RA_RESCRAI NOT IN ('30','31') " + _CRLF
    Endif

    cQuery := ChangeQuery(cQuery)
    DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliTmp, .T., .T.)

    DbSelectArea(cAliTmp)
    If (cAliTmp)->(!Eof())
        While (cAliTmp)->(!Eof())

            oJsonAux := JSonObject():New()

            oJsonAux['CNPJ'] := (cAliTmp)->CNPJ
            oJsonAux['CODIGO_LOCAL'] := AllTrim((cAliTmp)->CODIGO_LOCAL)
            oJsonAux['CPF'] := (cAliTmp)->CPF
            oJsonAux['NOME'] := AllTrim((cAliTmp)->NOME)
            // oJsonAux['REGIMEPUBLICO'] := (cAliTmp)->REGIMEPUBLICO
            oJsonAux['TIPO_COLABORADOR'] := (cAliTmp)->TIPO_COLABORADOR
            oJsonAux['MATRICULA_EMPRESA'] := (cAliTmp)->MATRICULA_EMPRESA
            oJsonAux['MATRICULAESOCIAL'] := (cAliTmp)->MATRICULAESOCIAL
            oJsonAux['RG'] := AllTrim((cAliTmp)->RG)
            oJsonAux['SEXO'] := (cAliTmp)->SEXO
            oJsonAux['DATA_NASCIMENTO'] := (cAliTmp)->DATA_NASCIMENTO
            If Empty(AllTrim((cAliTmp)->TRANSF))
                oJsonAux['TIPOADMISSAO'] := 'P'
                oJsonAux['DATA_ADMISSAO'] := (cAliTmp)->DATA_ADMISSAO
            Else
                oJsonAux['TIPOADMISSAO'] := 'T'
                oJsonAux['DATA_ADMISSAO'] := Substr((cAliTmp)->TRANSF, 7, 2) + '/' + Substr((cAliTmp)->TRANSF, 5, 2) + '/' + Substr((cAliTmp)->TRANSF, 1, 4) //DtoC(StoD((cAliTmp)->TRANSF))
            EndIf
            If !Empty(AllTrim((cAliTmp)->DATA_DEMISSAO))
                oJsonAux['DATA_DEMISSAO'] := Substr((cAliTmp)->DATA_DEMISSAO, 7, 2) + '/' + Substr((cAliTmp)->DATA_DEMISSAO, 5, 2) + '/' + Substr((cAliTmp)->DATA_DEMISSAO, 1, 4) //DtoC(StoD((cAliTmp)->DATA_DEMISSAO))
            EndIf
            oJsonAux['CTPS_NUMERO'] := AllTrim((cAliTmp)->CTPS_NUMERO)
            oJsonAux['CTPS_SERIE'] := AllTrim((cAliTmp)->CTPS_SERIE)
            oJsonAux['CTPS_ORGAO'] := AllTrim((cAliTmp)->CTPS_ORGAO)
            oJsonAux['NIS'] := AllTrim((cAliTmp)->NIS)
            oJsonAux['CELULAR_DDD'] := AllTrim((cAliTmp)->CELULAR_DDD)
            oJsonAux['CELULAR_NUMERO'] := AllTrim((cAliTmp)->CELULAR_NUMERO)
            oJsonAux['EMAIL'] := AllTrim((cAliTmp)->EMAIL)
            oJsonAux['SITUACAO'] := (cAliTmp)->RA_SITFOLH

            Aadd(oJsonRet['data'],oJsonAux)

            (cAliTmp)->(DbSkip())
        End
    EndIf

    fCloseArea(cAliTmp)

Return oJsonRet

Static Function fGetSetores(cGrupo)

    Local cQuery    := ""
    Local cAliTmp   := GetNextAlias()
    Local oJsonRet  := JSonObject():New()
    
    // Local aSm0      := FWLoadSM0()

    cQuery := "SELECT * " + _CRLF
    cQuery += "FROM CTT"+cGrupo+"0 " + _CRLF
    cQuery += "WHERE D_E_L_E_T_ <> '*' " + _CRLF
    cQuery += "AND CTT_CLASSE = '2' " + _CRLF
    cQuery += "AND CTT_BLOQ <> '1'

    cQuery := ChangeQuery(cQuery)
    DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliTmp, .T., .T.)

    oJsonRet["data"] := {}

    DbSelectArea(cAliTmp)
    If (cAliTmp)->(!Eof())
        While (cAliTmp)->(!Eof())

            oJsonAux := JSonObject():New()

            /*/ 
            nPos := 0
            nPos := aScan(aSm0,{|x| x[1] == cGrupo .And. x[2] == cUnidade})

            cCnpj := ""
            If nPos > 0
                cCnpj := aSm0[nPos,18]
            EndIf

            oJsonAux['CNPJ'] := cCnpj             
            oJsonAux['CODIGO_LOCAL'] := cGrupo+cUnidade
            /*/
            oJsonAux['CODIGO_SETOR'] := AllTrim((cAliTmp)->CTT_CUSTO)
            oJsonAux['SETOR'] := AllTrim((cAliTmp)->CTT_DESC01)
            oJsonAux['DESCRICAO_SETOR'] := "" 

            Aadd(oJsonRet['data'],oJsonAux)

            (cAliTmp)->(DbSkip())
        End
    EndIf

Return oJsonRet

Static Function fGetCargos(cGrupo)

    Local cQuery    := ""
    Local cAliTmp   := GetNextAlias()
    Local oJsonRet  := JSonObject():New()
    
    // Local aSm0      := FWLoadSM0()

    cQuery := "SELECT * " + _CRLF
    cQuery += "FROM SQ3"+cGrupo+"0 " + _CRLF
    cQuery += "WHERE D_E_L_E_T_ <> '*' " + _CRLF

    cQuery := ChangeQuery(cQuery)
    DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliTmp, .T., .T.)

    oJsonRet["data"] := {}

    DbSelectArea(cAliTmp)
    If (cAliTmp)->(!Eof())
        While (cAliTmp)->(!Eof())

            oJsonAux := JSonObject():New()

            /*/ 
            nPos := 0
            nPos := aScan(aSm0,{|x| x[1] == cGrupo .And. x[2] == cUnidade})

            cCnpj := ""
            If nPos > 0
                cCnpj := aSm0[nPos,18]
            EndIf

            oJsonAux['CNPJ'] := cCnpj
             
            oJsonAux['CODIGO_LOCAL'] := cGrupo+cUnidade
            /*/
            oJsonAux['CODIGO_SETOR'] := AllTrim((cAliTmp)->Q3_CC)
            oJsonAux['CODIGO_CARGO'] := AllTrim((cAliTmp)->Q3_CARGO)
            oJsonAux['CARGO'] := AllTrim((cAliTmp)->Q3_DESCSUM)
            oJsonAux['CBO'] := AllTrim((cAliTmp)->Q3_CBO)

            cDesc := fGetDesc(cGrupo, (cAliTmp)->Q3_DESCDET)
            oJsonAux['DESCRICAO_ATIVIDADE'] := AllTrim(cDesc)

            Aadd(oJsonRet['data'],oJsonAux)

            (cAliTmp)->(DbSkip())
        End
    EndIf

Return oJsonRet


Static Function fGetMov(cGrupo, cUnidade, cMat, cStatus, cDemDe, cDemAte)

    Local cQuery    := ""
    Local cAliTmp   := GetNextAlias()
    Local oJsonRet  := JSonObject():New()
    // Local cIniMov   := SuperGetMv("FS_DTINIMV",.F.,'20240701')

    // Local aSm0      := FWLoadSM0()
    cQuery := "SELECT * " + _CRLF
    cQuery += "FROM " + _CRLF
    cQuery += "( " + _CRLF
    cQuery += "SELECT " + _CRLF
    cQuery += "M0_CGC CNPJ, " + _CRLF
    cQuery += "M0_CODIGO+M0_CODFIL CODIGO_LOCAL, " + _CRLF
    cQuery += "RA_MAT MATRICULA, " + _CRLF
    cQuery += "RA_CIC CPF, " + _CRLF
    cQuery += "ISNULL(TAB.CARGO,SRA.RA_CARGO) CARGO, " + _CRLF
    cQuery += "ISNULL(TAB.SETOR,SRA.RA_CC) SETOR, " + _CRLF
    cQuery += "SUBSTRING(RA_ADMISSA,7,2) + '/' + SUBSTRING(RA_ADMISSA,5,2) + '/' + SUBSTRING(RA_ADMISSA,1,4) ADMISSAO, " + _CRLF
    cQuery += "ISNULL(TAB.INI_CARGO, ISNULL((SELECT TOP 1 (SUBSTRING(R7_DATA,7,2) + '/' + SUBSTRING(R7_DATA,5,2) + '/' + SUBSTRING(R7_DATA,1,4)) FROM SR7"+cGrupo+"0 WHERE R7_MAT = RA_MAT AND R7_FILIAL = RA_FILIAL AND R7_CARGO = RA_CARGO AND D_E_L_E_T_ <> '*' ORDER BY R7_DATA),'')) INI_CARGO, " + _CRLF
    cQuery += "ISNULL(TAB.FIM_CARGO,'') FIM_CARGO " + _CRLF
    cQuery += "FROM SRA"+cGrupo+"0 SRA " + _CRLF
    
    cQuery += "LEFT JOIN ( " + _CRLF
    
    cQuery += "SELECT " + _CRLF
    cQuery += "(SELECT M0_CGC FROM SYS_COMPANY WHERE M0_CODIGO = RE_EMPP AND M0_CODFIL = RE_FILIALP AND D_E_L_E_T_ <> '*') CNPJ_DEST, " + _CRLF
    cQuery += "RA_FILIAL AS FILIAL, " + _CRLF
    cQuery += "RE_EMPP+RE_FILIALP EMPFIL, " + _CRLF
    cQuery += "RE_MATP MATRICULA, " + _CRLF
    cQuery += "RE_CCP SETOR, " + _CRLF
    cQuery += "RA_CIC  CPF, " + _CRLF
    cQuery += "RA_CARGO CARGO, " + _CRLF
    cQuery += "(SELECT TOP 1 (SUBSTRING(R7_DATA,7,2) + '/' + SUBSTRING(R7_DATA,5,2) + '/' + SUBSTRING(R7_DATA,1,4)) FROM SR7"+cGrupo+"0 WHERE R7_MAT = RE_MATP AND R7_FILIAL = RE_FILIALP AND R7_CARGO = RA_CARGO AND D_E_L_E_T_ <> '*' ORDER BY R7_DATA) INI_CARGO, " + _CRLF
    cQuery += "'' FIM_CARGO " + _CRLF
    cQuery += "FROM SRE"+cGrupo+"0 RE " + _CRLF
    cQuery += "INNER JOIN SRA"+cGrupo+"0 RA " + _CRLF
    cQuery += "ON RA_FILIAL = RE_FILIALP " + _CRLF
    cQuery += "AND RA_MAT = RE_MATP " + _CRLF
    cQuery += "AND RA.D_E_L_E_T_ <> '*' " + _CRLF
    cQuery += "WHERE RE.D_E_L_E_T_ <> '*' " + _CRLF
    cQuery += "AND RE_EMPP = '"+cGrupo+"' " + _CRLF
    cQuery += "AND (RE_CCP <> RE_CCD) " + _CRLF
    // cQuery += "AND RE_DATA >= '"+cIniMov+"' " + _CRLF
    If !Empty(AllTrim(cUnidade))
        cQuery += "AND RE_FILIALP = '"+cUnidade+"' " + _CRLF
    Endif
    If !Empty(AllTrim(cMat))
        cQuery += "AND (RE_MATP = '"+cMat+"' OR RE_MATD = '"+cMat+"') " + _CRLF
    EndIf

    cQuery += "UNION " + _CRLF

    cQuery += "SELECT  " + _CRLF
    cQuery += "(SELECT M0_CGC FROM SYS_COMPANY WHERE M0_CODIGO = "+cGrupo+" AND M0_CODFIL = R7_FILIAL AND D_E_L_E_T_ <> '*') CNPJ_DEST, " + _CRLF
    cQuery += "RA_FILIAL AS FILIAL, " + _CRLF
    cQuery += "'"+cGrupo+"'+R7_FILIAL EMPFIL, " + _CRLF
    cQuery += "R7_MAT MATRICULA, " + _CRLF
    cQuery += "RA_CC SETOR, " + _CRLF
    cQuery += "RA_CIC  CPF, " + _CRLF
    cQuery += "R7_CARGO CARGO, " + _CRLF
    cQuery += "(SELECT TOP 1 (SUBSTRING(R72.R7_DATA,7,2) + '/' + SUBSTRING(R72.R7_DATA,5,2) + '/' + SUBSTRING(R72.R7_DATA,1,4)) FROM SR7070 R72 WHERE R72.R7_MAT = R7.R7_MAT AND R72.R7_FILIAL = R72.R7_FILIAL AND R72.R7_CARGO = R7.R7_CARGO AND R72.D_E_L_E_T_ <> '*' ORDER BY R72.R7_DATA) INI_CARGO, " + _CRLF
    cQuery += "(SELECT TOP 1 (SUBSTRING(R72.R7_DATA,7,2) + '/' + SUBSTRING(R72.R7_DATA,5,2) + '/' + SUBSTRING(R72.R7_DATA,1,4)) FROM SR7"+cGrupo+"0 R72 WHERE R72.R7_MAT = R7.R7_MAT AND R72.R7_FILIAL = R72.R7_FILIAL AND R72.R7_CARGO <> R7.R7_CARGO AND R72.R7_DATA > R7.R7_DATA AND R72.D_E_L_E_T_ <> '*' ORDER BY R7_DATA) FIM_CARGO " + _CRLF    
    cQuery += "FROM SR7"+cGrupo+"0 R7 " + _CRLF
    cQuery += "INNER JOIN SRA"+cGrupo+"0 RA " + _CRLF
    cQuery += "ON RA_FILIAL = R7_FILIAL " + _CRLF
    cQuery += "AND RA_MAT = R7_MAT " + _CRLF
    cQuery += "AND RA.D_E_L_E_T_ <> '*' " + _CRLF
    cQuery += "WHERE R7.D_E_L_E_T_ <> '*' " + _CRLF
    cQuery += "AND R7_TIPO IN ('004','009') " + _CRLF
    // cQuery += "AND R7_DATA >= '"+cIniMov+"' " + _CRLF
    If !Empty(AllTrim(cUnidade))
        cQuery += "AND R7_FILIAL = '"+cUnidade+"' " + _CRLF
    Endif
    If !Empty(AllTrim(cMat))
        cQuery += "AND R7_MAT = '"+cMat+"' " + _CRLF
    EndIf
    cQuery += "GROUP BY RA_FILIAL, R7_FILIAL, R7_MAT, RA_CC, RA_CIC, R7_CARGO, R7_DATA " + _CRLF 
    cQuery += ") AS TAB " + _CRLF
    cQuery += "ON TAB.FILIAL = SRA.RA_FILIAL " + _CRLF
    cQuery += "AND TAB.MATRICULA = SRA.RA_MAT " + _CRLF
    cQuery += "INNER JOIN SYS_COMPANY AS M0 " + _CRLF
    cQuery += "ON M0_CODIGO = '"+cGrupo+"' " + _CRLF
    cQuery += "AND M0_CODFIL = RA_FILIAL " + _CRLF
    cQuery += "AND M0.D_E_L_E_T_ <> '*' " + _CRLF
    cQuery += "WHERE SRA.D_E_L_E_T_ <> '*' " + _CRLF
    cQuery += "AND RA_CIC <> '' " + _CRLF

    If !Empty(AllTrim(cUnidade))
        cQuery += "AND RA_FILIAL = '"+cUnidade+"' " + _CRLF
    EndIf
    If !Empty(AllTrim(cMat))
        cQuery += "AND RA_MAT = '"+cMat+"' " + _CRLF
    EndIf

    If cStatus == 'd'
        cQuery += "AND RA_SITFOLH = 'D' " + _CRLF
        cQuery += "AND RA_DEMISSA BETWEEN '"+cDemDe+"' AND '"+cDemAte+"' " + _CRLF
    ElseIf cStatus == 'a'
        cQuery += "AND RA_SITFOLH <> 'D' " + _CRLF
        cQuery += "AND RA_RESCRAI NOT IN ('30','31') " + _CRLF
    Endif
    cQuery += ") AS TAB2 " + _CRLF
    cQuery += "GROUP BY CNPJ, CODIGO_LOCAL, MATRICULA, CPF, CARGO, SETOR, ADMISSAO, INI_CARGO, FIM_CARGO " + _CRLF
    cQuery += "ORDER BY MATRICULA " + _CRLF

    // cQuery += "AND RA_SITFOLH <> 'D' " + _CRLF
    // cQuery += "AND RA_RESCRAI NOT IN ('30','31') " + _CRLF
    

    cQuery := ChangeQuery(cQuery)
    DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliTmp, .T., .T.)

    oJsonRet["data"] := {}

    DbSelectArea(cAliTmp)
    If (cAliTmp)->(!Eof())
        While (cAliTmp)->(!Eof())

            oJsonAux := JSonObject():New()

            oJsonAux['CNPJ'] := AllTrim((cAliTmp)->CNPJ)
            oJsonAux['CODIGO_LOCAL'] := AllTrim((cAliTmp)->CODIGO_LOCAL)
            oJsonAux['MATRICULA_EMPRESA'] := AllTrim((cAliTmp)->MATRICULA)
            oJsonAux['CPF'] := AllTrim((cAliTmp)->CPF)
            oJsonAux['CODIGO_SETOR'] := AllTrim((cAliTmp)->SETOR)
            oJsonAux['CODIGO_CARGO'] := AllTrim((cAliTmp)->CARGO)
            IF !Empty(AllTrim((cAliTmp)->INI_CARGO))
                oJsonAux['DATA_INICIO_CARGO'] := AllTrim((cAliTmp)->INI_CARGO)
            Else
                oJsonAux['DATA_INICIO_CARGO'] := AllTrim((cAliTmp)->ADMISSAO)
            EndIf
            oJsonAux['DATA_FIM_CARGO'] := AllTrim((cAliTmp)->FIM_CARGO)
            

            Aadd(oJsonRet['data'],oJsonAux)

            (cAliTmp)->(DbSkip())
        End
    EndIf

Return oJsonRet

Static Function fGetTransf(cGrupo, cUnidade, cMat)

    Local cQuery    := ""
    Local cAliTmp   := GetNextAlias()
    Local oJsonRet  := JSonObject():New()

    // Local aSm0      := FWLoadSM0()

    cQuery := "SELECT " + _CRLF
    cQuery += "SUBSTRING(RE_DATA,7,2) + '/' + SUBSTRING(RE_DATA,5,2) + '/' + SUBSTRING(RE_DATA,1,4) DATA_TRANSFERENCIA, " + _CRLF
    cQuery += "(SELECT M0_CGC FROM SYS_COMPANY WHERE M0_CODIGO = RE_EMPD AND M0_CODFIL = RE_FILIALD AND D_E_L_E_T_ <> '*') CNPJ_ORIG, " + _CRLF
    cQuery += "(SELECT M0_CGC FROM SYS_COMPANY WHERE M0_CODIGO = RE_EMPP AND M0_CODFIL = RE_FILIALP AND D_E_L_E_T_ <> '*') CNPJ_DEST, " + _CRLF
    cQuery += "(SELECT RA_CIC FROM SRA"+cGrupo+"0 WHERE RA_MAT = RE_MATP AND RA_FILIAL = RE_FILIALP AND D_E_L_E_T_ <> '*') CPF, " + _CRLF
    cQuery += "* " + _CRLF
    cQuery += "FROM SRE"+cGrupo+"0 RE " + _CRLF
    cQuery += "WHERE RE.D_E_L_E_T_ <> '*' " + _CRLF
    cQuery += "AND RE_EMPP = '"+cGrupo+"' " + _CRLF
    cQuery += "AND (RE_EMPP <> RE_EMPD OR RE_FILIALP <> RE_FILIALD) " + _CRLF
    If !Empty(AllTrim(cUnidade))
        cQuery += "AND RE_FILIALP = '"+cUnidade+"' " + _CRLF
    Endif
    If !Empty(AllTrim(cMat))
        cQuery += "AND (RE_MATP = '"+cMat+"' OR RE_MATD = '"+cMat+"') " + _CRLF
    EndIf

    cQuery := ChangeQuery(cQuery)
    DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliTmp, .T., .T.)

    oJsonRet["data"] := {}

    DbSelectArea(cAliTmp)
    If (cAliTmp)->(!Eof())
        While (cAliTmp)->(!Eof())

            oJsonAux := JSonObject():New()

            oJsonAux['CPF'] := AllTrim((cAliTmp)->CPF)
            oJsonAux['MATRICULA_EMPRESA_ DE'] := AllTrim((cAliTmp)->RE_MATD)
            oJsonAux['CNPJ_DE'] := AllTrim((cAliTmp)->CNPJ_ORIG)
            oJsonAux['CODIGO_LOCAL_DE'] := AllTrim((cAliTmp)->RE_EMPD+RE_FILIALD)
            oJsonAux['MATRICULA_EMPRESA_ PARA'] := AllTrim((cAliTmp)->RE_MATP)
            oJsonAux['CNPJ_PARA'] := AllTrim((cAliTmp)->CNPJ_DEST)
            oJsonAux['CODIGO_LOCAL_PARA'] := AllTrim((cAliTmp)->RE_EMPP+RE_FILIALP)
            oJsonAux['DATA_TRANSFERENCIA'] := AllTrim((cAliTmp)->DATA_TRANSFERENCIA)

            Aadd(oJsonRet['data'],oJsonAux)

            (cAliTmp)->(DbSkip())
        End
    EndIf

Return oJsonRet

Static Function fGetDesc(cGrupo, cChave)

    Local cQuery    := ""
    Local cQryTmp   := GetNextAlias()
    Local cDescRet  := ""

    cQuery := "SELECT YP_TEXTO " + _CRLF
    cQuery += "FROM SYP"+cGrupo+"0 " + _CRLF
    cQuery += "WHERE YP_CHAVE = '"+cChave+"' " + _CRLF
    cQuery += "AND YP_CAMPO = 'Q3_DESCDET' " + _CRLF
    cQuery += "AND D_E_L_E_T_ <> '*' " + _CRLF
    cQuery += "ORDER BY YP_SEQ " + _CRLF

    cQuery := ChangeQuery(cQuery)
    DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cQryTmp, .T., .T.)


    DbSelectArea(cQryTmp)
    If (cQryTmp)->(!Eof())
        While (cQryTmp)->(!Eof())

            cDescRet += StrTran(AllTrim((cQryTmp)->YP_TEXTO),'\13\10',' ')
            
            (cQryTmp)->(DbSkip())
        End
    EndIf

    fCloseArea(cQryTmp)

Return cDescRet

Static Function fCloseArea(pParTabe)
/***********************************************
* Funcao para verificar se existe tabela e exclui-la
*
****/
	If (Select(pParTabe)!= 0)
		dbSelectArea(pParTabe)
		dbCloseArea()
		If File(pParTabe+GetDBExtension())
			FErase(pParTabe+GetDBExtension())
		EndIf
	EndIf
Return
