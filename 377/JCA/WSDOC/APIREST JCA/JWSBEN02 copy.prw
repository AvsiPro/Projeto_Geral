#INCLUDE "Protheus.ch"
#INCLUDE "RESTFUL.ch"
#Include "rwmake.ch"
#Include "tbiconn.ch"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

//ws para pesquisa de funcionário especifico informando empresa e matricula/cpf
//AGUARDANDO CHAMADO TOTVS PARA FAZER ALTERAÇÃO DE USUARIO

WSRESTFUL JWSBEN02 DESCRIPTION "EVENTO para manutneção PLANO DE SAUDE E ODONTOLOGICO RHL RHK e RHM" //GPEA133

    WSMETHOD POST DESCRIPTION "Manutenção de Vales - PLANO DE SAUDE E ODONTOLOGICO "  WSSYNTAX "/JWSBEN02/{1 altera inclui 2 daleta}" //GPEA133

ENDWSRESTFUL

WsMethod POST WsReceive RECEIVE WsService JWSBEN02

    LOCAL lRet := .T.
    LOCAL lFilok := .F.
    // LOCAL aCampo := {} // campo alterar
    LOCAL xConteudo := "" //conteudo
    LOCAL oResponse     := JsonObject():New()
    Local oContra
    Local n  := 0
    LOCAL nI := 0
    LOCAL nC := 0
    Local nR := 0
    LOCAL cTpcpo := "" //tipo de campo
    LOCAL cCampo := ""
    LOCAL aFunci := {}
    Local cQRCC  := "" //pesquisa tabelas S016 e s017
    Private nAgr := 0 //controla sequencia do agregado
    PRIVATE cOperacao :=   "" //ALTERAR
    PRIVATE aSra := {}
    PRIVATE aRHK := {}
    PRIVATE aRHL := {}
    PRIVATE aRHM := {}
    PRIVATE cErro := ""
    PRIVATE aErroRet := {}
    PRIVATE cEmpf := "" //esmpresa do cadastro
    //PRIVATE cTpBen  := ""
    PRIVATE cCodFor := "" //"001" // faz parte do indice
    PRIVATE cTpPlano := "" //"3" // "1 - Faixa Salarial 2 - Faixa Etaria 3 - Valor Fixo  4 - % S/ Salario 5 - Salarial/Etaria 6 - Salarial/Tempo"
    PRIVATE cCodPlano := "" //"07"
    PRIVATE cTpForn := ""//"2"//"1" //1 plano de saude ou 2 odontologico
    // PRIVATE cCodFor := "002"//"001" // faz parte do indice
    PRIVATE cCodDep := "" //"03"
    PRIVATE cCpfAgr := "" //"34296463837"
    PRIVATE cMatric := "" //"042181" //"001840"
    PRIVATE cCodAgr := ""

    //LOCAL oJson := NIL

    RpcClearEnv()
    RpcSetType(3)
    //RPCSetEnv('99','01')
    RPCSetEnv('01','00020087')

    Self:SetContentType("application/json")

    oContra := JsonObject():New()

    cError := oContra:fromJson( self:getContent() )
    lOk := .F.

    If Empty(cError) .and. valtype(oContra["BENEFICIO"]) == "A" .and.  LEN(self:aURLParms) > 0
        ConOut("leu json")
        cOperacao :=   ALLTRIM(::aURLParms[1]) //== "1" //ALTERAR 2 DELETAR

        If valtype(oContra["BENEFICIO"]) == "A"
            aFunci:= oContra:GetJSonObject('BENEFICIO')
            For nI := 1 to len(aFunci)
                IF nI == 1
                    IF !EMPTY(alltrim(oContra["BENEFICIO"][nI]["EMPRESA"])) .OR. alltrim(oContra["BENEFICIO"][nI]['EMPRESA']) != NIL
                        cEmpf := alltrim(oContra["BENEFICIO"][nI]["EMPRESA"])
                        MyOpenSM0()
                        SM0->( DBGOTOP() )
                        WHILE !SM0->( EOF() ) .AND. !lFilok
                            IF padl(cEmpf,8,"0") == ALLTRIM(SM0->M0_CODFIL)
                            //IF padl(cEmpf,2,"0") == ALLTRIM(SM0->M0_CODFIL)
                                cFilant := ALLTRIM(SM0->M0_CODFIL)
                                cNumEmp := "01"+cFilant
                                lFilok := .T.
                            ENDIF
                            SM0->( DBSKIP() )
                        ENDDO

                        IF !lFilok
                            lRet := .F.
                            oResponse['code'] := 2
                            oResponse['status'] := 404
                            oResponse['message'] := 'Confira a empresa digitada.'
                            oResponse['detailedMessage'] := ''
                        ENDIF
                    ELSE
                        lRet := .F.
                        oResponse['code'] := 3
                        oResponse['status'] := 404
                        oResponse['message'] := 'Confira se a Empresa foi informada.'
                        oResponse['detailedMessage'] := ''
                    ENDIF
                ENDIF

                //valida funcinario na empresa e se não está demitido
                IF lRet
                    IF !EMPTY(alltrim(oContra["BENEFICIO"][nI]['MATRICULA'])) .OR. alltrim(oContra["BENEFICIO"][nI]['MATRICULA']) != NIL
                        cMatric := alltrim(oContra["BENEFICIO"][nI]['MATRICULA'])
                        cMatric :=  NewCGCCPF(cMatric)
                        IF LEN(cMatric) == 11 //CNPJ
                            cSeek := PADR(STRZERO( VAL(cMatric),11), TAMSX3('RA_CIC') [1]) //RA_FILIAL+RA_CIC 5
                            nInd := 5
                        ELSEIF LEN(ALLTRIM(cMatric)) == 6 //MATRICULA
                            cSeek := PADR(STRZERO( VAL(cMatric),6), TAMSX3('RA_MAT') [1]) //RA_FILIAL+RA_MAT+RA_NOME 1
                            nInd := 1
                        ELSE
                            lRet := .F.
                            oResponse['code'] := 3
                            oResponse['status'] := 404
                            oResponse['message'] := 'Parametro não tem a quantidade de caracteres esperada. Matricula com 6 ou CPF com 11.'
                            oResponse['detailedMessage'] := ''
                        ENDIF

                        SRA->( DBSETORDER(nInd) )//::aURLParms[2]
                        IF SRA->( DBSEEK( xFilial('SRA') + cSeek ) )
                            cMatric := SRA->RA_MAT
                        ELSE
                            lRet := .F.
                            oResponse['code'] := 4
                            oResponse['status'] := 403
                            oResponse['message'] := 'Matricula não encontrada'
                            oResponse['detailedMessage'] := ''
                        ENDIF
                    ELSE
                        lRet := .F.
                        oResponse['code'] := 5
                        oResponse['status'] := 404
                        oResponse['message'] := 'Matricula não foi informada'
                        oResponse['detailedMessage'] := ''
                    ENDIF
                ENDIF

                //valida tipo de beneficio 1 para plano de saude e 02 para odonto
                IF lRet
                    IF !EMPTY(alltrim(oContra["BENEFICIO"][nI]['TIPO_FORNEC'])) .OR. alltrim(oContra["BENEFICIO"][nI]['TIPO_FORNEC']) != NIL
                        ConOut("tipo de beneficio")
                        cTpForn := alltrim(oContra["BENEFICIO"][nI]['TIPO_FORNEC'])
                        IF !cTpForn $ ("1,2")
                            lRet := .F.
                            oResponse['code'] := 6
                            oResponse['status'] := 404
                            oResponse['message'] := 'Informe 1 para saude e 2 para odonto.'
                            oResponse['detailedMessage'] := ''
                        ENDIF
                    ELSE
                        lRet := .F.
                        oResponse['code'] := 7
                        oResponse['status'] := 404
                        oResponse['message'] := 'Informe o tipo de beneficio TIPO_FORNEC 1 saude e 2 odonto.'
                        oResponse['detailedMessage'] := ''
                    ENDIF
                ENDIF

                //valida código do fornecedor de acordo cmo tipo de beneficio
                IF lRet
                    IF !EMPTY(alltrim(oContra["BENEFICIO"][nI]['COD_FORNECE'])) .OR. alltrim(oContra["BENEFICIO"][nI]['COD_FORNECE']) != NIL
                        cCodFor := alltrim(oContra["BENEFICIO"][nI]['COD_FORNECE'])

                        //verifica codigo do forncedor é valido para o tipo de bebficio se tipo de forncedor 1 tabela S016 se 2 tabea S017
                        cQRCC := " SELECT * "
                        cQRCC += "FROM "+ RetSQLName("RCC")+ " RCC "
                        cQRCC += " WHERE RCC.D_E_L_E_T_='' "
                        cQRCC += " AND RCC.RCC_FILIAL= '"+xFilial('RCC')+"' AND RCC_SEQUEN = '"+ cCodFor +"'"

                        IF cTpForn == "1"
                            cQRCC += " AND RCC.RCC_CODIGO = 'S016' "
                        ELSE
                            cQRCC += " AND RCC.RCC_CODIGO = 'S017' "
                        ENDIF

                        If Select("TMP2")<>0
                            DbSelectArea("TMP2")
                            DbCloseArea()
                        EndIf

                        cQRCC := ChangeQuery(cQRCC)
                        DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQRCC),'TMP2',.F.,.T.	)

                        dbSelectArea("TMP2")
                        TMP2->(dbGoTop())

                        IF TMP2->(!EOF())
                            lRet := .T.
                        ELSE
                            lRet := .F.
                            oResponse['code'] := 8
                            oResponse['status'] := 404
                            oResponse['message'] := 'Não foi localizado o forncedor: '+ cCodFor
                            oResponse['detailedMessage'] := ''
                        ENDIF
                    ELSE
                        lRet := .F.
                        oResponse['code'] := 8
                        oResponse['status'] := 404
                        oResponse['message'] := 'Informe o codigo do beneficio COD_BENEFICIO'
                        oResponse['detailedMessage'] := ''
                    ENDIF
                ENDIF

                //VALIDA TIPO DE PLANO
                IF lRet
                    IF !EMPTY(alltrim(oContra["BENEFICIO"][nI]['TIPO_PLANO'])) .OR. alltrim(oContra["BENEFICIO"][nI]['TIPO_PLANO']) != NIL
                        cTpPlano :=  alltrim(oContra["BENEFICIO"][nI]['TIPO_PLANO'])
                        IF !cTpPlano $ ("1,2,3,4,5,6")
                            lRet := .F.
                            oResponse['code'] := 6
                            oResponse['status'] := 404
                            oResponse['message'] := 'Informe um tipo de plano valido.'
                            oResponse['detailedMessage'] := ''
                        ENDIF
                    ELSE
                        lRet := .F.
                        oResponse['code'] := 8
                        oResponse['status'] := 406
                        oResponse['message'] := 'Informe o tipo de plano'
                        oResponse['detailedMessage'] := ''
                    ENDIF
                ENDIF

                //valida código do plano de acordo com o tipo
                //1=Faixa Salarial  S008
                //2=Faixa Etaria    S009
                //3=Valor Fixo      S028
                //4=% S/ Salario    S029
                //5=Salarial/Etaria S059
                //6=Salarial/Tempo  S140
                IF lRet
                    IF !EMPTY(alltrim(oContra["BENEFICIO"][nI]['COD_PLANO'])) .OR. alltrim(oContra["BENEFICIO"][nI]['COD_PLANO']) != NIL
                        cCodPlano :=  alltrim(oContra["BENEFICIO"][nI]['COD_PLANO'])
                        /*
                        //pesquisa tabeças rcc
                        //verifica codigo do forncedor é valido para o tipo de bebficio se tipo de forncedor 1 tabela S016 se 2 tabea S017
                        cQRCC := " SELECT * "
                        cQRCC += "FROM "+ RetSQLName("RCC")+ " RCC "
                        cQRCC += " WHERE RCC.D_E_L_E_T_='' "
                        cQRCC += " AND RCC.RCC_FILIAL= '"+xFilial('RCC')+"' " //AND RCC_SEQUEN = '"+ cCodPlano +"'"

                        IF cTpPlano == "1"
                            cQRCC += " AND RCC.RCC_CODIGO = 'S008' "
                        ELSEIF cTpPlano == "2"
                            cQRCC += " AND RCC.RCC_CODIGO = 'S009' "
                        ELSEIF cTpPlano == "3"
                            cQRCC += " AND RCC.RCC_CODIGO = 'S028' "
                        ELSEIF cTpPlano == "4"
                            cQRCC += " AND RCC.RCC_CODIGO = 'S029' "
                        ELSEIF cTpPlano == "5"
                            cQRCC += " AND RCC.RCC_CODIGO = 'S059' "
                        ELSEIF cTpPlano == "6"
                            cQRCC += " AND RCC.RCC_CODIGO = 'S140' "
                        ENDIF

                        If Select("TMP3")<>0
                            DbSelectArea("TMP3")
                            DbCloseArea()
                        EndIf

                        cQRCC := ChangeQuery(cQRCC)
                        DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQRCC),'TMP3',.F.,.T.	)

                        dbSelectArea("TMP3")
                        TMP3->(dbGoTop())

                        IF TMP3->(!EOF())
                            lRet := .T.
                        ELSE
                            lRet := .F.
                            oResponse['code'] := 8
                            oResponse['status'] := 404
                            oResponse['message'] := 'Não foi localizado o codigo de plano: '+ cCodPlano
                            oResponse['detailedMessage'] := ''
                        ENDIF
                    ELSE
                        lRet := .F.
                        oResponse['code'] := 8
                        oResponse['status'] := 406
                        oResponse['message'] := 'Informe o tipo de plano'
                        oResponse['detailedMessage'] := ''*/
                    ENDIF
                ENDIF

                IF lRet
                    //verifica arrays da tabela RHK RHL E RHM
                    IF cOperacao $ "'1','2'"
                        IF valtype(oContra["BENEFICIO"][nI]['CAMPOSRHK']) == "A" .OR. (alltrim(oContra["BENEFICIO"][nI]['CAMPOSRHK']) != NIL .AND. !EMPTY(alltrim(oContra["BENEFICIO"][nI]['CAMPOSRHK'])))
                            ConOut("entrou nas RH")
                            nC := 0
                            For nC := 1 to len(oContra["BENEFICIO"][nI]['CAMPOSRHK'])
                                cCampo := ALLTRIM(oContra["BENEFICIO"][1]['CAMPOSRHK'][nC]["CAMPO"])
                                xConteudo := ALLTRIM(oContra["BENEFICIO"][1]['CAMPOSRHK'][nC]["CONTEUDO"])
                                CAMPO := ""

                                SX3->( DBSETORDER(1) )
                                SX3->( DBSEEK( 'RHK' ) )
                                WHILE !SX3->( EOF() ) .AND. SX3->X3_ARQUIVO == 'RHK' .AND. EMPTY(CAMPO)
                                    //valida tipo de campo e conteudo informado
                                    aAux := {}
                                    IF X3USO( SX3->X3_USADO) .AND. SX3->X3_CONTEXT != 'V'
                                        IF alltrim(cCampo) ==  ALLTRIM(SX3->X3_CAMPO)
                                            CAMPO := ALLTRIM( SX3->X3_CAMPO)
                                            //CONVERTER PARA CARACTER
                                            cTpcpo := SX3->X3_TIPO
                                            IF cTpcpo == 'N'
                                                xConteudo := Val(StrTran(strtran(xConteudo,"."),",","."))
                                            ELSEIF cTpcpo == 'D'
                                                xConteudo := STOD(xConteudo)
                                            ENDIF
                                            aAux := {CAMPO,xConteudo}
                                            aadd(aRHK,aAux)
                                        ENDIF
                                    ENDIF
                                    //CAMPO := ALLTRIM( SX3->X3_CAMPO)
                                    SX3->( DBSKIP() )
                                ENDDO
                            NEXT nC
                        ENDIF

                        //verifica arrays da tabela RHL
                        IF valtype(oContra["BENEFICIO"][nI]['CAMPOSRHL']) == "A" .OR. (alltrim(oContra["BENEFICIO"][nI]['CAMPOSRHL']) != NIL .AND. !EMPTY(alltrim(oContra["BENEFICIO"][nI]['CAMPOSRHL'])))//alltrim(oContra["BENEFICIO"][nI]['CAMPOSRHL']) != NIL
                            ConOut("entrou rhl")
                            nC := 0
                            For nC := 1 to len(oContra["BENEFICIO"][nI]['CAMPOSRHL'])
                                cCampo := ALLTRIM(oContra["BENEFICIO"][1]['CAMPOSRHL'][nC]["CAMPO"])
                                xConteudo := ALLTRIM(oContra["BENEFICIO"][1]['CAMPOSRHL'][nC]["CONTEUDO"])
                                CAMPO := ""
                                SX3->( DBSETORDER(1) )
                                SX3->( DBSEEK( 'RHL' ) )
                                WHILE !SX3->( EOF() ) .AND. SX3->X3_ARQUIVO == 'RHL' .AND. EMPTY(CAMPO)
                                    //valida tipo de campo e conteudo informado
                                    aAux := {}
                                    IF X3USO( SX3->X3_USADO) .AND. SX3->X3_CONTEXT != 'V'
                                        IF alltrim(cCampo) ==  ALLTRIM(SX3->X3_CAMPO)
                                            CAMPO := ALLTRIM( SX3->X3_CAMPO)
                                            //CONVERTER PARA CARACTER
                                            cTpcpo := SX3->X3_TIPO
                                            IF cTpcpo == 'N'
                                                xConteudo := Val(StrTran(strtran(xConteudo,"."),",","."))
                                            ELSEIF cTpcpo == 'D'
                                                xConteudo := STOD(xConteudo)
                                            ENDIF

                                            IF CAMPO == "RHL_CODIGO"
                                                cCodDep := xConteudo
                                            ENDIF

                                            aAux := {CAMPO,xConteudo}
                                            aadd(aRHL,aAux)
                                        ENDIF
                                    ENDIF
                                    //CAMPO := ALLTRIM( SX3->X3_CAMPO)
                                    SX3->( DBSKIP() )
                                ENDDO
                            NEXT nC
                        ENDIF

                        //verifica arrays da tabela RHM e pesquisa codigo do agregado pelo cpf
                        IF valtype(oContra["BENEFICIO"][nI]['CAMPOSRHM']) == "A" .OR. (alltrim(oContra["BENEFICIO"][nI]['CAMPOSRHM']) != NIL .AND. !EMPTY(alltrim(oContra["BENEFICIO"][nI]['CAMPOSRHM']))) //alltrim(oContra["BENEFICIO"][nI]['CAMPOSRHM']) != NIL
                            ConOut("entrou rhm")
                            nC := 0
                            For nC := 1 to len(oContra["BENEFICIO"][nI]['CAMPOSRHM'])
                                cCampo := ALLTRIM(oContra["BENEFICIO"][1]['CAMPOSRHM'][nC]["CAMPO"])
                                xConteudo := ALLTRIM(oContra["BENEFICIO"][1]['CAMPOSRHM'][nC]["CONTEUDO"])
                                CAMPO := ""

                                SX3->( DBSETORDER(1) )
                                SX3->( DBSEEK( 'RHM' ) )
                                WHILE !SX3->( EOF() ) .AND. SX3->X3_ARQUIVO == 'RHM' .AND. EMPTY(CAMPO)
                                    //valida tipo de campo e conteudo informado
                                    aAux := {}
                                    IF X3USO( SX3->X3_USADO) .AND. SX3->X3_CONTEXT != 'V'
                                        IF alltrim(cCampo) ==  ALLTRIM(SX3->X3_CAMPO)
                                            CAMPO := ALLTRIM( SX3->X3_CAMPO)
                                            //CONVERTER PARA CARACTER
                                            cTpcpo := SX3->X3_TIPO
                                            IF cTpcpo == 'N'
                                                xConteudo := Val(StrTran(strtran(xConteudo,"."),",","."))
                                            ELSEIF cTpcpo == 'D'
                                                xConteudo := STOD(xConteudo)
                                            ENDIF

                                            IF CAMPO == "RHM_CPF"
                                                cCpfAgr := xConteudo
                                                //RHM_FILIAL+RHM_MAT+RHM_TPFORN+RHM_CODFOR+RHM_CODIGO
                                                dbSelectArea("RHM")
                                                dbSetOrder(1)
                                                IF  RHM->(MsSeek(xFilial('RHM') + cMatric +cTpForn + cCodFor)) //cGet1 = Numero da Ordem de Produção
                                                    While !RHM->(EOF()) .AND. cTpForn == RHM->RHM_TPFORN
                                                        IF ALLTRIM(RHM->RHM_CPF) == cCpfAgr
                                                            cCodAgr := RHM->RHM_CODIGO
                                                        ENDIF

                                                        nAgr += 1
                                                        //rever essa pesquisa por dbseek com filtro 1
                                                        //PESQUISO PARA RETORNAR O CÓDIGO MEHLRO PESQUISAR RHM_FILIAL+RHM_MAT+RHM_TPFORN+RHM_CODFOR+RHM_CODIGO e comparar com cpf se existi se existir eu pego o código se não exisitir eu pego o proximo
                                                        //assim eu verifico se existe o cpf e altero a RHM e pego o código se não existir eu pego o amior somo 1 e crio
                                                        /*
                                                        cAliastab := "RHM"

                                                        cQuerAg := " SELECT * "
                                                        cQuerAg += "FROM "+ RetSQLName(cAliastab) + " "+cAliastab
                                                        cQuerAg += " WHERE "+ cAliastab +".D_E_L_E_T_=''"
                                                        cQuerAg += " AND RHM.RHM_FILIAL= '"+xFilial('RHM')+"' AND RHM.RHM_MAT = '"+ cMatric +"' "
                                                        cQuerAg += " AND RHM.RHM_TPFORN= '"+ cTpForn +"' AND RHM.RHM_CODFOR = '"+cCodFor+"'"
                                                        //cQuerAg += " AND RHM.RHM_CPF ='"+ cCpfAgr +"'"

                                                        If Select("TMP1")<>0
                                                            DbSelectArea("TMP1")
                                                            DbCloseArea()
                                                        EndIf

                                                        cQuerAg := ChangeQuery(cQuerAg)
                                                        DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuerAg),'TMP1',.F.,.T.	)

                                                        dbSelectArea("TMP1")
                                                        TMP1->(dbGoTop())

                                                        WHILE TMP1->(!EOF())
                                                            //IF TMP1->(!EOF())
                                                            IF ALLTRIM(RHM_CPF) == cCpfAgr
                                                                cCodAgr := TMP1->RHM_CODIGO
                                                            ENDIF

                                                            nAgr += 1

                                                            //ELSE
                                                            //fazer tratavia pois se não achou e vai incluir e tem o campo código,
                                                            //mas se achar outros precisa incluir mais um...se deltetar tem que achar
                                                            /*
                                                    lRet := .F.
                                                    oResponse['code'] := 8
                                                    oResponse['status'] := 404
                                                    oResponse['message'] := 'Não foi localizado o forncedor: '+ cCodFor
                                                        oResponse['detailedMessage'] := ''*/
                                                        //ENDIF
                                                        //TMP1->(DBSKIP())
                                                        RHM->(DBSKIP())
                                                    ENDDO
                                                ENDIF
                                            ENDIF
                                            aAux := {CAMPO,xConteudo}
                                            aadd(aRHM,aAux)
                                        ENDIF
                                    ENDIF
                                    //CAMPO := ALLTRIM( SX3->X3_CAMPO)
                                    SX3->( DBSKIP() )
                                ENDDO
                            NEXT nC
                        ENDIF
                    ENDIF
                ENDIF

                //CHAMA EXECAUTO
                IF lRet
                    IF MYGPEA001()
                        ConOut("retornou positivo")
                        oResponse['data']   := {}
                        AADD( oResponse['data'], JsonObject():New() )

                        IF cOperacao == "2"
                            oResponse['data'][1]['status'] := "DELETADO MATRICULA " + cMatric +" CODIGO DO BENEFICIO "+cCodFor
                        ELSE
                            oResponse['data'][1]['status'] := "Registro atualizado com sucesso, matricula " + cMatric +" codigo do beneficio "+ cCodFor

                            FOR nR := 1 to len(aSra)

                                oResponse['data'][1][aSra[nR,1]] := aSra[nR,2]

                            NEXT nR
                        ENDIF

                        ConOut("retornou ok")
                        ::SetResponse(FWJsonSerialize(oResponse, .F., .F., .T.))
                    ELSE
                        ConOut("retornou negativo")
                        IF LEN(aErroRet) > 0
                            ConOut("retornou negativo 2")
                            lRet := .F.
                            oResponse['code'] := 15
                            oResponse['status'] := 404

                            n := 0
                            FOR n := 1 to len(aErroRet)
                                IF n == 1
                                    cErro := aErroRet[n] + CHR(13)+CHR(10)
                                ENDIF
                                cErro +=  IF(!aErroRet[n] == NIL,aErroRet[n]+ CHR(13)+CHR(10),"")
                             
                            NEXT n

                            oResponse['message'] := EncodeUTF8(cErro,"cp1252")
                            oResponse['detailedMessage'] := ''

                        ELSE
                            lRet := .F.
                            oResponse['code'] := 8
                            oResponse['status'] := 404
                            oResponse['message'] := 'Informe o codigo do beneficio COD_BENEFICIO'
                            oResponse['detailedMessage'] := ''
                        ENDIF
                    ENDIF
                ENDIF
            NEXT nC
        ENDIF
    ELSE
        lRet := .F.
        oResponse['code'] := 8
        oResponse['status'] := 405
        oResponse['message'] := 'Erro no json, informe 1 para incluir ou alterar e 2 para deletar'
        oResponse['detailedMessage'] := ''
    ENDIF

    If !lRet
        SetRestFault( oResponse['code'],;
            oResponse['message'],;
            .T.,;
            oResponse['status'],;
            oResponse['detailedMessage'];
            )
    EndIf

    RpcClearEnv()

RETURN lRet

//----------------------------------------------------------
// Funcao Auxiliar para retirar a máscara do campo CNPJ/CPF:
//----------------------------------------------------------
Static Function NewCGCCPF(cCGCCPF)

    LOCAL aInvChar := {"/",".","-"}
    LOCAL nI

    For nI:=1 to Len(aInvChar)
        cCGCCPF := StrTran(cCGCCPF,aInvChar[nI])
    Next

Return cCGCCPF

STATIC FUNCTION MYGPEA001()

    Local oModel
    Local oSubMdl
    Local n := 0
    Local cModel := ""
    LOCAL lSra := .T.
    // LOCAL aRHK := {}
    // LOCAL aRHL := {}
    // Local aRHM := {}
    //local cTpBen := "0"
    local cCodTab := ""
    local nColFor := 0
    Local nSeq      := 0
    local nTam := 0
    local aSeekk := {}
    local aSeekl := {}
    local aSeekm := {}
    Local oSubRHK
    Local oSubRHL
    Local oSubRHM
    Local cRHRdt := AnoMes(Date())
    Local cQuerAg := ""
    Local cQuery := ""

    nTam    := TamSx3("RHM_CODIGO")[1]

    dbSelectArea("SRA")
    dbSetOrder(1)
    If SRA->(MsSeek(xFilial('SRA') + cMatric))
        CONOUT("Inicio: "+TIME())
        oModel := FWLoadModel("GPEA001")
        oModel:SetOperation(3)//(MODEL_OPERATION_UPDATE)
        oModel:Activate()
        oSubRHK := oModel:GetModel("GPEA001_MRHK") //TITULAR

        aSeekk := {}
        aAdd(aSeekk,{"RHK_FILIAL" ,xFilial("SHK")})
        aAdd(aSeekk,{"RHK_MAT"       ,cMatric })
        aAdd(aSeekk,{"RHK_TPFORN"    ,cTpForn})
        aAdd(aSeekk,{"RHK_CODFOR"    ,cCodFor})

        IF LEN(aRHL) > 0
            aSeekl := {}
            aAdd(aSeekl,{"RHL_FILIAL" ,xFilial("RHL")})
            aAdd(aSeekl,{"RHL_MAT"        ,    cMatric })
            aAdd(aSeekl,{"RHL_TPFORN"    ,cTpForn})
            aAdd(aSeekl,{"RHL_CODFOR"    ,cCodFor})
            aAdd(aSeekl,{"RHL_CODIGO"    ,cCodDep})
        ENDIF

        IF LEN(aRHM) > 0
            aSeekm := {}// RHM_FILIAL+RHM_MAT+RHM_TPFORN+RHM_CODFOR+RHM_CODIGO
            aAdd(aSeekm,{"RHM_FILIAL" ,xFilial("RHM")})
            aAdd(aSeekm,{"RHM_MAT"        ,    cMatric })
            aAdd(aSeekm,{"RHM_TPFORN"    ,cTpForn})
            aAdd(aSeekm,{"RHM_CODFOR"    ,cCodFor})
            IF EMPTY(cCodAgr)
                cCodAgr := padl(cvaltochar(nAgr + 1),2,"0")
            ENDIF
            aAdd(aSeekm,{"RHM_CODIGO"    ,cCodAgr})
        ENDIF

        //incluir ou alterar
        IF cOperacao == "1" //alteração inclusão
             CONOUT("antes do posicionamento")
            oSubRHK:GoLine(1)//Volta ao topo pra pra buscar!!
            //se não existir adiciona uma linha e informa o tipo 1 ou 2
            IF !oSubRHK:SeekLine(aSeekk) .And. !oSubRHK:IsDeleted()
                oSubRHK:Addline()
                oSubRHK:SetValue(   "RHK_TPFORN", cTpForn      )
            ENDIF

            oSubRHK:SetValue(   "RHK_CODFOR",   cCodFor      )
            oSubRHK:SetValue(   "RHK_TPPLAN",   cTpPlano      )
            oSubRHK:LoadValue(   "RHK_PLANO",    cCodPlano      )

            IF LEN(aRHk) > 0
                n := 0
                FOR n := 1 TO LEN(aRHK)
                    oSubRHK:SetValue(   aRHK[n,1]  ,  aRHK[n,2]      )
                NEXT n
            ENDIF

            //verifica se tem informação para dependente
            IF LEN(aRHL) > 0

                oSubRHL := oModel:GetModel("GPEA001_MRHL") // DEPENDENTE RHM_FILIAL+RHM_MAT+RHM_CPF

                //verifica se existe para criar ou alterar

                oSubRHL:GoLine(1)//Volta ao topo pra pra buscar!!
                IF !oSubRHL:SeekLine(aSeekl) .And. !oSubRHL:IsDeleted()
                    aSeekl := {}
                    aAdd(aSeekl,{"RHL_FILIAL" ,xFilial("RHL")})
                    aAdd(aSeekl,{"RHL_MAT"        ,    cMatric })
                    aAdd(aSeekl,{"RHL_TPFORN"    ,cTpForn})
                    aAdd(aSeekl,{"RHL_CODFOR"    ,cCodFor})
                    IF !oSubRHL:SeekLine(aSeekl) .And. !oSubRHL:IsDeleted()
                        //PRECISA NAO EXISTIR NO CADASTRO DE DEPENDENTES
                        oSubRHL:SetValue(   "RHL_CODIGO"  ,  cCodDep      )
                    ELSE
                        oSubRHL:Addline()
                        oSubRHL:SetValue(   "RHL_CODIGO"  ,  cCodDep      )
                    ENDIF
                    //ELSE
                    //    oSubRHL:LoadValue(   "RHL_CODIGO"  ,  cCodDep      )
                ENDIF

                oSubRHL:SetValue(   "RHL_TPPLAN",cTpPlano     )
                oSubRHL:LoadValue(   "RHL_PLANO",cCodPlano      )

                n := 0
                FOR n := 1 TO LEN(aRHL)
                    IF  aRHL[n,1] <> "RHL_CODIGO"
                        oSubRHL:SetValue(   aRHL[n,1]  ,  aRHL[n,2]      )
                    ENDIF
                NEXT n
            ENDIF

            IF LEN(aRHM) > 0
                oSubRHM := oModel:GetModel("GPEA001_MRHM") //AGREGADO

                //  oSubRHM:SetRelation( "GPEA001_MRHM", { { "RHM_FILIAL", 'xFilial( "RHK" )' }, { "RHM_MAT", 'RHK_MAT' }, { "RHM_TPFORN", 'RHK_TPFORN' }, { "RHM_CODFOR", 'RHK_CODFOR' } }, RHM->( IndexKey( 1 ) ) )

                oSubRHM:GoLine(1)//Volta ao topo pra pra buscar!!
                IF !oSubRHM:SeekLine(aSeekm) .And. !oSubRHM:IsDeleted()

                    IF cCodAgr != "01"
                        oSubRHM:Addline()
                    ENDIF
                ENDIF

                oSubRHM:SetValue( "RHM_FILIAL" , xFilial("RHM"))
                oSubRHM:LoadValue('RHM_CODFOR'    , cCodFor )

                //oSubRHM:SetValue( "RHM_TPFORN"    ,cTpForn)
                oSubRHM:LoadValue( "RHM_CODIGO"  ,  cCodAgr     )
                //oSubRHM:SetValue( "RHM_NOME"  ,  "RODRIGO" )
                //oSubRHM:LoadValue('RHM_CODFOR'    , cCodFor )

                oSubRHM:SetValue( "RHM_TPPLAN",cTpPlano)
                oSubRHM:SetValue( "RHM_PLANO",cCodPlano     )

                n := 0
                FOR n := 1 TO LEN(aRHM)
                    oSubRHM:SetValue(   aRHM[n,1]  ,  aRHM[n,2]      )
                NEXT n
            ENDIF
            //EXCLUSAO
            ELSEIF cOperacao == "2"
            //Para exclusão, posicionar na linha desejada
            oSubRHK:GoLine(1)//Volta ao topo pra pra buscar!!
            IF oSubRHK:SeekLine(aSeekk) .And. !oSubRHK:IsDeleted()
                IF LEN(aRHk) > 0
                    oSubRHK:DeleteLine()
                ENDIF

                IF LEN(aRHL) > 0
                    oSubRHL := oModel:GetModel("GPEA001_MRHL") // DEPENDENTE
                    IF oSubRHL:SeekLine(aSeekl) .And. !oSubRHL:IsDeleted()
                        // cAliastab := "RHR"
                        // Se o dependente possuir calculo nao pode deletar
                        //cCposQuery 	:= "%RHR.RHR_FILIAL, RHR.RHR_MAT, RHR_CODIGO, RHR_TPPLAN, RHR_TPFORN, RHR_CODFOR, RHR_PLANO, RHR_COMPPG%"
                        /*cQuery := " SELECT * "
                        cQuery += "FROM "+ RetSQLName(cAliastab) + " "+cAliastab
                        cQuery += " WHERE "+ cAliastab +".D_E_L_E_T_=''"
                        cQuery += " AND RHR.RHR_FILIAL= '"+xFilial('RHR')+"' AND RHR.RHR_ORIGEM = '02' "
                        cQuery += " AND RHR.RHR_CODIGO= '"+cCodDep+"' AND RHR.RHR_TPFORN = '"+cTpForn+"'"
                        cQuery += " AND RHR.RHR_CODFOR= '"+cCodFor+"' AND RHR.RHR_TPPLAN= '"+cTpPlano+"'"

                        cQuery+= " AND RHR.RHR_COMPPG ='"+ cRHRdt +"'"

                        If Select("TMP")<>0
                            DbSelectArea("TMP")
                            DbCloseArea()
                        EndIf

                        cQuery := ChangeQuery(cQuery)
                        DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),'TMP',.F.,.T.	)

                        dbSelectArea("TMP")
                        TMP->(dbGoTop())

                        IF TMP->(!EOF())
                            lSra := .F.
                        ELSE///*/
                        oSubRHL:DeleteLine()
                        lSra := .T.
                        //EndIf

                    ELSE
                        cErro := "Não foi localizado nenhum beneficio para esse dependente, verifique Filial, matricula, tipo de forncedor e código do dependente."
                        lSra := .F.
                    ENDIF
                ENDIF

                IF LEN(aRHM) > 0 .AND. lSra
                    oSubRHM := oModel:GetModel("GPEA001_MRHM") //AGREGADO
                    oSubRHM:GoLine(1)//Volta ao topo pra pra buscar!!
                    IF oSubRHM:SeekLine(aSeekm) .And. !oSubRHM:IsDeleted()
                        oSubRHM:DeleteLine()
                    ELSE
                        //ENDIF
                        //ELSE
                        cErro := "Não foi localizado nenhum beneficio para esse agregado, verifique Filial, matricula, tipo de forncedor e cpf do agregado."
                        lSra := .F.
                    ENDIF
                ENDIF
            ELSE
                cErro := "Não foi localizado nenhum beneficio para esse funcionário, verifique Filial, matricula, tipo e código de forncedor."
                lSra := .F.
            ENDIF
        ENDIF

        IF lSra
            IF oModel:VldData()
                oModel:CommitData()
                lSra := .T.
                ConOut("ok")
            Else
                aErroRet := oModel:GetErrorMessage()
                lSra := .F.
            EndIf
        ENDIF

        oModel:DeActivate()
    ENDIF
    CONOUT("Fim: "+TIME())
    //EndIf

Return lSra

STATIC FUNCTION MyOpenSM0()
    LOCAL lOpen := .F.
    LOCAL i := 0

    IF !EMPTY(  SELECT('SM0'))
        lOpen := .T.
    ELSE

        FOR i := 1 TO 20
            dbUseArea(  .T., , 'SIGAMAT.EMP',   'SMO',  .T.,    .F.)
            IF !EMPTY(  SELECT('SM0'))
                lOpen := .T.
                dbSetIndex('SIGAMAT.IND')
                EXIT
            ENDIF
            Sleep(500)
        NEXT
    ENDIF
RETURN lOpen
