#Include "protheus.ch"
#Include "totvs.ch"
#Include "tcrma117.ch"
#Include "topconn.ch"
 
/*/{Protheus.doc} TINCWHVD
Transferência de contas em lote via Integramais 
@author Geanlucas Sousa
@since 24/10/2023
@version 1.0
@type function
/*/
User Function TINCWHVD(cToken,cUsrLog,cFilDest,cNomeFil)
    
    Local aArea     := FWGetArea()
    Local cAlias    := GetNextAlias()
    Local cQuery    := ''
    Local nReg      := 0 

    Private cRet        := ''
    Private cDetalhe    := ''

    cQuery := " SELECT /*PARALLEL(16)*/ * "
    cQuery += " FROM "+RetSQLName("P98")
    cQuery += " WHERE D_E_L_E_T_=' '" 
    cQuery += " AND P98_FILIAL='"+xFilial("P98")+"'"
    cQuery += " AND P98_CODEXT='"+cToken+"'"
    cQuery += " AND P98_STATUS='0'"
    cQuery += " AND P98_TABELA = 'SA1'"
    TcQuery cQuery New Alias &cAlias

	Count to nReg

	If nReg == 0 
        fImpCSV(cUsrLog,cFilDest,cNomeFil)
		(cAlias)->(DbCloseArea())
	Else
        If MsgYesNo("Existem "+cValToChar(nReg)+" clientes para serem processados, deseja continuar com a atualização de vendedores?","TINCWHVD")
            fImpCSV(cUsrLog,cFilDest,cNomeFil)
        EndIf
        (cAlias)->(DbCloseArea())
    EndIf

    FWAlertSuccess("Processo Finalizado!", "Sucesso!")

    FWRestArea(aArea)
    
Return .T.

/*/{Protheus.doc} fImpCSV
Transferência de contas em lote via arquivo CSV
@author Geanlucas Sousa
@since 24/10/2023
@version 1.0
@type function
/*/
Static Function fImpCSV(cUsrLog,cFilDest,cNomeFil)

Local aArea         := FWGetArea()
Local aPerg         := {}
Local aRet          := {}
Local cFileType	    := "Arquivo .CSV |*.CSV"
Local aDados        := {}
Local nOport        := 1

aAdd(aPerg,{6,STR0002,Space(150),"",,"",90,.T.,cFileType,"",GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE})  //'Selecione o Arquivo'

If ParamBox(aPerg,STR0001,aRet) //'Transferência de Contas via Arquivo'

    aDados := fPrepDados(aRet[1])
    FWMsgRun(, {|| fImpDados(aDados,Alltrim(Str(nOport)),cUsrLog,cFilDest,cNomeFil)},"","Processando os dados...")

EndIf

FWRestArea(aArea)
Return

/*/{Protheus.doc} fPrepDados
Retorna contas a serem transferidas conforme leitura do arquivo CSV
@author Geanlucas Sousa
@since 24/10/2023
@version 1.0
@type function
/*/
Static Function fPrepDados(cFile)

Local nTot      := 0
// Local nQtd      := 0
Local aLinha    := {}
Local aRet      := {}

FT_FUSE(cFile)

nTot := FT_FLASTREC()
//Procregua(nTot)
FT_FGOTOP()

Do While !FT_FEOF()

    // nQtd++
    // IncProc("Processando "+Alltrim(Str(nQtd))+" de "+Alltrim(str(nTot))) 
	aLinha := StrtoKarr(Alltrim(FT_FREADLN()),";")
	aAdd(aRet,aLinha)
    FT_FSKIP()

EndDo

FT_FUSE()

Return aRet

/*/{Protheus.doc} fImpDados
Prepara transferencia
@author Geanlucas Sousa
@since 24/10/2023
@version 1.0
@type function
/*/
Static Function fImpDados(aDados,cAcOpor,cUsrLog,cFilDest,cNomeFil)

Local aCampos       := {''}
Local aTransf       := {}
Local aAtual        := {}
Local aVld          := {}
Local aRetVal       := {}
Local aVldTerr      := {}
Local aLog          := {}
Local aHeader       := {STR0003,STR0004,STR0005,STR0006,STR0007,STR0008}  // 'Linha'#'Entidade'#'Conta'#'ESN Origem'#'ESN Destino'#'Status da Transferência'
Local aGrpTrf       := StrToKarr(GETMV("TI_GRBPTER",,'004413;004848'),";")
Local aGroups       := UsrRetGrp()
Local cErro         := ''
Local cAliasConta   := ''
Local cEntidade     := ''
Local cConta        := ''
Local cOrigem       := ''
Local cDestino      := ''
Local cOwner        := ''
Local cCodCta       := ''
Local cLojCta       := ''
Local cEntRF        := ''
Local cStatusRF     := ''
Local cCNPJ  		:= ''
Local cMascara		:= ''
Local cCodTerr      := ''
Local cCNPJEnt      := ''
Local cLogPWU       := ''
Local cSETPUB       := ''
Local cSitBlqRf		:= GetMv('TI_STBLQRF',,'NULA;BAIXADA')
Local cCodPool      := GetMv("TI_CODPOOL",,"")
Local cQryZQ0		:= GetNextAlias()
Local cUndPublic    := GetMv("TI_CDUNDPB",,"TSS005")
Local lCont         := .T.
Local lAtvBlqRf		:= GetMv('TI_LBBLQRF',, .T.)
Local lPoolAtv      := GetMV("TI_TRAPOOL",,.F.) //Permite realizar transferencias para ao pool para contas ativas
Local lJanela       := .T.
Local lByPass       := .F.
Local n1            := 0
Local nChoice       := 0
Local nQtd          := 0
Local lRet          := .F.

// efetua bypass, caso
n1 := 1
Do While n1 <= Len(aGroups) .And. !lByPass
    lByPass := aScan(aGrpTrf,aGroups[n1])>0
    n1++
EndDo

For n1 := 1 To Len(aDados)

    cLogPWU := ""
    nQtd++
    // If !IsBlind()
    //     IncProc('Processando '+Alltrim(Str(nQtd))+' de '+Alltrim(Str(Len(aDados)))) 
    // EndIf
	aCampos := aDados[n1]
    aAtual  := aClone(aCampos)

    cErro       := ""
    lCont       := .T.
    cConta      := ""
    cDestino    := ""
    cOrigem     := ""
    cOwner      := ""
    cSETPUB     := ""

    aCampos := aDados[n1]
    aCampos[2] := Padr(aCampos[2],6)
    aCampos[3] := Padr(aCampos[3],6)

    // valida existência da conta
    If aCampos[1]=='1'
        cAliasConta := 'SA1'
        cEntidade   := STR0016  // 'Cliente'
    EndIf

    dbSelectArea(cAliasConta)
    dbSetOrder(1)
    If !dbSeek(xFilial(cAliasConta)+aCampos[2])
        aAdd(aLog,{nQtd,cEntidade,aCampos[2],"","",STR0018}) // 'Conta não localizada no cadastro'
        lCont := .F.
    Else
        If aCampos[1]=='1'

            cConta   := aCampos[2]+"-"+StrTran(fwcutoff(Alltrim(FieldGet(FieldPos("A1_NOME"))),.F.),";",",")
            cOwner   := FieldGet(FieldPos("A1_VEND"))
            cCodCta  := SA1->A1_COD
            cLojCta  := SA1->A1_LOJA
            cCodTerr := SA1->A1_CODTER
            cCNPJEnt := SA1->A1_CGC
            cSETPUB  := Posicione("AI0",1,xFilial("AI0") + aCampos[2] , "AI0_SETPUB")

            If !lPoolAtv .And. SA1->A1_XSITCLI == "1" .And. u_TK271POL(aCampos[3])
                aAdd(aLog,{nQtd,cEntidade,cConta,cOwner,aCampos[3],STR0041}) // 'Não é permitido realizar transferencias de clientes ativos para o pool de contas'
                cLogPWU += aLog[Len(aLog)][6] + CRLF
                lCont := .F.
            EndIf

            //Valida se cliente é destinatário de faturamento (RATEIO)
            If  lCont .And. U_A020Ratc(SA1->A1_COD,SA1->A1_LOJA)

                //JANELAS DE TRANSF CONTAS CRM
                BeginSQL Alias cQryZQ0
                    SELECT ZQ0_CODIGO
                    FROM %Table:ZQ0%
                    WHERE ZQ0_FILIAL = %Exp:xFilial("ZQ0")%
                    AND %Exp:DtoS(MsDate())% BETWEEN ZQ0_DTINI AND ZQ0_DTFIM
                    AND %NotDel%
                EndSQL
                If (cQryZQ0)->(EOF())
                    lJanela := .F.
                EndIf
                (cQryZQ0)->(DbCloseArea())

                If  !lJanela
                    aAdd(aLog,{nQtd,cEntidade,cConta,cOwner,aCampos[3],STR0042 +SA1->A1_COD + STR0043 + Alltrim(SA1->A1_NOME)+ STR0044 +DtoC(MsDate())+ STR0045 }) //"O cliente [######] - [##########] é um destinatário de faturamento, por isso não será transferida nesta data [##/##/####] pois não existe janela de transferência liberada pela contabilidade"
                    cLogPWU += aLog[Len(aLog)][6] + CRLF
                    lCont := .F.
                EndIf
            EndIf
        EndIf
    EndIf

    cOrigem := cOwner+"-"+Alltrim(ReadValue("SA3",1,xFilial("SA3")+cOwner,"A3_NOME"))

    dbSelectArea("SA3")
    dbSetOrder(1)

    // valida existencia de ESN Destino
    If !dbSeek(xFilial("SA3")+aCampos[3])
        aAdd(aLog,{nQtd,cEntidade,cConta,cOrigem,aCampos[3],STR0021}) // 'ESN Destino não localizado'
        cLogPWU += aLog[Len(aLog)][6] + CRLF
        lCont := .F.
    Else
        If SA3->A3_MSBLQL <> "1"
            If cOwner==aCampos[3]
                aAdd(aLog,{nQtd,cEntidade,cConta,cOrigem,cDestino,STR0035}) // 'ESN Destino já é o dono da conta'
                cLogPWU += aLog[Len(aLog)][6] + CRLF
                lCont := .F.
            Else
                cDestino := aCampos[3]+"-"+Alltrim(SA3->A3_NOME)
                // valida SE ESN Destino está na estrutura de vendas
                dbSelectArea("AZS")
                dbSetOrder(4)
                If !dbSeek(xFilial("AZS")+aCampos[3]) .Or. Empty(AZS->AZS_IDESTN)
                    aAdd(aLog,{nQtd,cEntidade,cConta,cOrigem,cDestino,STR0022}) // 'ESN Destino não está na estrutura de vendas'
                    cLogPWU += aLog[Len(aLog)][6] + CRLF
                    lCont := .F.
                EndIf
            EndIf
        Else
            aAdd(aLog,{nQtd,cEntidade,cConta,cOrigem,cDestino,STR0040}) // 'ESN Destino está bloqueado para uso'
            cLogPWU += aLog[Len(aLog)][6] + CRLF
            lCont := .F.
        EndIf
    EndIf

    // Realiza a validação do stastus CNPJ
    If lCont .And. lAtvBlqRf .And. !aCampos[3] $ cCodPool //Bloqueio de transferencia somente se estiver ligado e não for para o pool

        cEntRF := "AI0"

        cCNPJ   	:= AllTrim(Posicione(cAliasConta, 1,xFilial(cAliasConta) + cCodCta + cLojCta, "A1_CGC"))
        cMascara	:= IIF(Len(cCNPJ)<=11, "@R 999.999.999-99", "@R 99.999.999/9999-99")
        cStatusRF	:= AllTrim(Posicione(cEntRF, 1,xFilial(cEntRF) + cCodCta + cLojCta, cEntRF + "_XSITRF"))

        If cStatusRF $ cSitBlqRf
            aAdd(aLog,{nQtd,cEntidade,cConta,cOrigem,cDestino,"Não será possível seguir com o processo pois o "+ IIF(cAliasConta=='SA1', 'cliente ', If(cAliasConta=='SUS', 'prospect ', 'suspect ')) ;
                + Alltrim(Transform(cCNPJ,cMascara)) +" se encontra " + cStatusRF + " na Receita Federal"})
            cLogPWU += aLog[Len(aLog)][6] + CRLF
            lCont := .F.
        EndIf

    EndIf

    //Valida permissão de transferência (TCRMA204)
    If lCont
        aVld := U_TC204Vld(cOwner, cAliasConta, cCodCta, cLojCta)
        If (lCont := aVld[1])
            aVld := U_TC204Vld(SA3->A3_COD, cAliasConta, cCodCta, cLojCta)
            lCont := aVld[1]
        EndIf
        If !lCont
            aAdd(aLog,{nQtd,cEntidade,cConta,cOrigem,cDestino,'Esta conta não poderá ser transferida pois está em processos de negociação. Em casos de dúvidas, entre em contato com o time de Estratégia Comercial CRM.'})
            cLogPWU += aLog[Len(aLog)][6] + CRLF
        EndIf
    EndIf

	// Valida se território do vendedor pode receber conta (território vendedor x território da conta)
	// Função: V001Territory dentro da TCRMV001
    If !lBypass .And. lCont .And. !U_V002Territory(Alltrim(SA3->A3_UNIDAD))
		aVldTerr := U_V001Territory(,,aCampos[3],cCNPJEnt,cCodTerr,.F. )
		If	Len(aVldTerr) > 0 .And. !aVldTerr[1]
            aAdd(aLog,{nQtd,cEntidade,cConta,cOrigem,cDestino,aVldTerr[2]}) // "O canal [ ###### ] não possui permissão para atuar no território [ ###### ]")
            lCont := .F.
		EndIf
    EndIf

    //Valida transferência de cliente para pool de contas dentro do mês de inativação
    If cAliasConta == 'SA1'

        aRetVal := U_TCRMV065(aCampos[3], aCampos[2])

        If !aRetVal[1]

            aAdd(aLog, { nQtd, cEntidade, cConta,  cOrigem, aCampos[3], aRetVal[2] } )
            cLogPWU += aLog[Len(aLog)][6] + CRLF
            lCont := .F.

        EndIf

    EndIf

    //Caso entidade seja do setor público e vendedor destino não pertença a unidade Setor Público, bloqueia a transfência.
    If  !lByPass .And. cSETPUB == "1" .And. !(SA3->A3_UNIDAD $ Alltrim(cUndPublic))
        aAdd(aLog,{nQtd,cEntidade,cConta,cOrigem,cDestino,STR0046}) //'Conta do Setor Público. Não será transferida porque o vendedor não pertence a unidade Setor Público (código TSS005).'
        cLogPWU += aLog[Len(aLog)][6] + CRLF
        lCont := .F.
    EndIf

    // se deu tudo certo, marca para transferência
    If lCont
        aAdd(aLog,{nQtd,cEntidade,cConta,cOrigem,cDestino,STR0024}) // 'Conta pronta para transferência'
        aAdd(aTransf,{cOwner,aCampos[3],aCampos[1],aCampos[2],If(Len(aCampos)>=4,aCampos[4],'')})
    ElseIf !Empty(cLogPWU)
        cRet := "#Erro"
        cDetalhe := "#ERRO - Recno tabela SA1 - "+cvaltochar(SA1->(Recno())) + " | " + cLogPWU
        U_TINCGRLG(0,SA1->(Recno()),"SA3",cRet,cDetalhe,'2',.F.,cUsrLog)
    EndIf

Next n1

// mostra LOG
If !IsBlind()
    nChoice := u_CRMXlBox(,aHeader,aLog,STR0025,.T.) // 'Contas - Transferência em Lote'
    If nChoice > 0 .And. Len(aTransf)>0
        FWMsgRun(, {|| lRet := fTransfContas(aTransf,cAcOpor,cUsrLog,cFilDest,cNomeFil) },"","Processando os dados...")
        // Processa({|| lRet := fTransfContas(aTransf,cAcOpor,cUsrLog,cFilDest,cNomeFil) })
    EndIf
ElseIf Len(aTransf)>0
    lRet := fTransfContas(aTransf,cAcOpor,cUsrLog,cFilDest,cNomeFil)
EndIf

If !lRet
    fResultPlan(aHeader,aLog,1)
EndIf

Return 


/*/{Protheus.doc} fTransfContas
efetiva transferencia das contas
@author Geanlucas Sousa
@since 24/10/2023
@version 1.0
@type function
/*/
Static Function fTransfContas(aTransf,cAcOpor,cUsrLog,cFilDest,cNomeFil)

Local n1            := 0
Local oTransf       := NIL
Local aUsers        := {"",""}
Local aCheck        := {}
Local nPosCheck     := 0
Local aHeader       := {STR0004,STR0028,STR0029,STR0030,STR0006,STR0031,STR0007,STR0008} //"Entidade"#'Código'#'Nome'#'Cód. Origem'#'ESN Origem'#'Cód. Destino'#'ESN Destino'#'Status da Transferência'
Local lGerSolic     := .F.
Local aLinha        := {}
Local lAprTransf    := GetMv("TI_APRTRFL",,.F.)
Local cCodigoMotivo := GetMV('TI_MOTTRFR',,'000008')
Local cObserva      := 'Transferência automática em lote: Migração da: '+cFilDest+'-'+cNomeFil
Local lRet          := .F.

// If !IsBlind()
//     ProcRegua(Len(aTransf))
// EndIf

For n1 := 1 To Len(aTransf)

    // If !IsBlind()
    //     IncProc(STR0009+Alltrim(Str(n1))+STR0010+Alltrim(str(Len(aTransf)))) 
    // EndIf

    If Len(aTransf[n1]) >= 5 .And. !Empty(aTransf[n1,5])
        cAcOpor := aTransf[n1,5]
    EndIf

    aLinha := fVerifEnt(aTransf[n1,3],aTransf[n1,4],cAcOpor)

    dbSelectArea("SA3")
    dbSetOrder(1)
    SA3->(DbSeek(xFilial('SA3') + aTransf[n1,2]))
    lGerSolic   := lAprTransf .And. SA3->A3_MODTRF == "2"

    //Posiciona no novo dono para verificar necessidade de aprovação

    dbSeek(xFilial("SA3")+aTransf[n1,1])

    aUsers[1] := ReadValue("AZS",4,xFilial("AZS")+aTransf[n1,1],"AZS_CODUSR")
    aUsers[2] := ReadValue("AZS",4,xFilial("AZS")+aTransf[n1,2],"AZS_CODUSR")

    aAdd(aCheck,{   FwCutOff(aLinha[02]),;
                    FwCutOff(aLinha[03]),;
                    FwCutOff(aLinha[05]),;
                    FwCutOff(aTransf[n1,1]),;
                    FwCutOff(Alltrim(SA3->A3_NOME)),;
                    FwCutOff(aTransf[n1,2]),;
                    FwCutOff(Alltrim(readvalue("SA3",1,xFilial("SA3")+aTransf[n1,2],"A3_NOME"))),;
                    ""})

    nPosCheck := Len(aCheck)

    oTransf := tiTransferAccount():new()

    // popula dados do objeto de transferência
    oTransf:donoAnterior        := aTransf[n1,1]
    oTransf:novoDono            := aTransf[n1,2]
    oTransf:fci                 := aLinha[16]
    oTransf:entidade            := aLinha[01]
    oTransf:codigo              := aLinha[03]
    oTransf:loja                := aLinha[04]
    oTransf:acaoOportunidade    := aLinha[15]
    oTransf:codigoTerritorio    := aLinha[18]
    oTransf:tipoUnidade         := aLinha[19]
    oTransf:codigoUnidade       := aLinha[20]
    oTransf:codigoMotivo        := cCodigoMotivo
    oTransf:codigoAprovador     := ''
    oTransf:observacoes         := cObserva
    oTransf:emailAprovador      := ''
    oTransf:processoAprovacao   := ''
    oTransf:mesmoUsuario        := aUsers[1]==aUsers[2]
    oTransf:recNumber           := aLinha[22]
    oTransf:userLog             := __cUserID
    oTransf:geraSolicitacao     := lGerSolic

	__cInterNet := "AUTOMATICO"

    Begin Transaction

        lGerSolic := .F. // Forçado para migração, alinhar com o time responsavel 
        If lGerSolic
            oTransf:executeSolicitacao()
        Else
            oTransf:forceTransf()
        EndIf
        If !Empty(oTransf:erroProcesso)
            aCheck[nPosCheck,8] := "Erro: " + oTransf:erroProcesso
            aCheck[nPosCheck,8] := StrTran(aCheck[nPosCheck,8],CHR(13)," | ")
            aCheck[nPosCheck,8] := StrTran(aCheck[nPosCheck,8],CHR(10),"")
            cRet := "#Erro"
            cDetalhe := "#ERRO - Recno tabela SA1 - "+cvaltochar(oTransf:recNumber) + " | Erro: " + oTransf:erroProcesso
            U_TINCGRLG(0,oTransf:recNumber,"SA1",cRet,cDetalhe,'2',.F.,cUsrLog)
        Else
            lRet := .T.
            cRet := "#Sucesso"
            cDetalhe := "#SUCESSO - Recno tabela SA1 - "+cvaltochar(oTransf:recNumber) + " | A1_COD "+ oTransf:codigo ;
            +" | Atualizado o vendedor e territorio | valor anterior : A1_VEND " + oTransf:donoAnterior + " e A1_CODMEMB "+oTransf:codigoUnidade
            U_TINCGRLG(0,oTransf:recNumber,"SA1",cRet,cDetalhe,'2',.F.,cUsrLog)
            aCheck[nPosCheck,8] := If(lGerSolic,"Solicitação de transferência enviada para aprovação ","Transferência efetivada automaticamente")
        EndIf

    End Transaction

	__cInterNet := Nil
    oTransf     := Nil

Next n1

If Len(aCheck) > 0 .And. !IsBlind()
    U_CRMXlBox(,aHeader,aCheck,STR0034,.T.) // 'LOG - Transferência em Lote'
EndIf

If lRet
    fResultPlan(aHeader,aCheck,2)
EndIf

Return lRet

/*/{Protheus.doc} fVerifEnt
retorna dados de acordo com a entidade
@author Geanlucas Sousa
@since 24/10/2023
@version 1.0
@type function
/*/
Static Function fVerifEnt(cEnt,cCod,cAcOpor)

Local aAreaOld      := FWGetArea()
Local cTemp         := GetNextAlias()
Local cWhere        := "% AND "+Iif(cEnt=='1','AD1_CODCLI','AD1_PROSPE')+"='"+cCod+"' %"
Local nQtdOpor      := 0
Local aRet			:= {}

BeginSql Alias cTemp

    SELECT  COUNT(1) QTD
    FROM    %table:AD1%
    WHERE   AD1_FILIAL=%xFilial:AD1%
            %exp:cwhere%
            AND AD1_STATUS='1'
            AND %notDel%

EndSql

nQtdOpor := Iif((cTemp)->QTD>99,99,(cTemp)->QTD)

(cTemp)->(dbCloseArea())

aRet := {}

If cEnt=='1'
    dbSelectArea("SA1")
    dbSetOrder(1)
    dbSeek(xFilial("SA1")+cCod)
    aAdd(aRet,"SA1")
    aAdd(aRet,AllTrim(Posicione("SX2",1,"SA1","X2NOME()")))
    aAdd(aRet,SA1->A1_COD)
    aAdd(aRet,SA1->A1_LOJA)
    aAdd(aRet,SA1->A1_NOME)
    aAdd(aRet,SA1->A1_NREDUZ)
    aAdd(aRet,SA1->A1_PESSOA)
    aAdd(aRet,SA1->A1_CGC)
    aAdd(aRet,SA1->A1_DDD)
    aAdd(aRet,SA1->A1_TEL)
    aAdd(aRet,SA1->A1_EMAIL)
    aAdd(aRet,SA1->A1_EST)
    aAdd(aRet,SA1->A1_MUN)
    aAdd(aRet,nQtdOpor)
    aAdd(aRet,Iif(nQtdOpor>0,cAcOpor,'3'))
    aAdd(aRet,GetMV('TI_TRFCTAA',,'201050')) // FCI
    aAdd(aRet,Alltrim(Posicione('ZX5',1,xFilial("ZX5")+'CRM003'+GetMV('TI_TRFCTAA',,'201050'),'ZX5_DESCRI')))// DESC FCI
    aAdd(aRet,SA1->A1_CODTER)
    aAdd(aRet,Iif(Empty(SA1->A1_TPMEMB),'1',SA1->A1_TPMEMB))
    aAdd(aRet,SA1->A1_CODMEMB)
    aAdd(aRet,"2")
    aAdd(aRet,SA1->(Recno()))
EndIf

FWRestArea(aAreaOld)
Return (aRet)

/*/{Protheus.doc} fResultPlan
retorna dados de acordo com a entidade
@author Geanlucas Sousa
@since 24/10/2024
@version 1.0
@type function
/*/
Static Function fResultPlan(aHeader,aItens,nOpc)

    Local cDados     := ''
    Local cDir 		 := 'c:\temp\integramais\'
    Local cNomeArq 	 := "Consistencia_"+dtos(ddatabase)+strtran(time(),":")+".txt" 
    Local nY, nZ
    Local oFWriter

    If Len(aHeader) > 0 .AND. Len(aItens) > 0 

        Iif(nOpc == 1,cNomeArq := "Pre_Atualizacao ",cNomeArq := "Pos_Atualizacao ")
        cNomeArq := cNomeArq+StrTran(DtoC(ddatabase),"/",'-')+" _ "+StrTran(Time(),":",'-')+".txt" 
        oFWriter := FWFileWriter():New(cDir + cArqXls, .T.)

        If ! oFWriter:Create()
            FWAlertError("Houve um erro ao gerar o arquivo: " + CRLF + oFWriter:Error():Message, "Atenção")
        Else

            // Campos
            For nY := 1 to Len(aHeader)
                cDados += aHeader[nY] 
                If nY < Len(aHeader)
                    cDados += ';'
                EndIf 
            Next nY
            cDados += CRLF
            
            //Dados
            For nY := 1 To Len(aItens)
                For nZ := 1 to Len(aItens[nY])
                    If ValType(aItens[nY,nZ]) $ "D/N"
                        cDados += cValToChar(aItens[nY,nZ])
                    Else
                        cDados += aItens[nY,nZ]
                    EndIf
                    If nY < Len(aItens)
                        cDados += ';'
                    EndIf 
                Next nZ
                cDados += CRLF
            Next nY

            // Gera o arquivo em TXT
            oFWriter:Write(cDados)
            oFWriter:Close()
            FreeObj(oFWriter)

            If FWAlertYesNo("Arquivo gerado com sucesso ( " + cDir + cNomeArq + " )!" + CRLF + "Deseja abrir?", "Atenção")
                ShellExecute("OPEN", cNomeArq, "", cDir, 1 )
            EndIf

        EndIf
    EndIf
Return
