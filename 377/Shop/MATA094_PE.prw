#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"
#Include "TOPCONN.CH"

/*/{Protheus.doc} MATA094_PE
TODO Rotina responsável por montar a tela para digitação do link do documento na tela de Liberação de Documentos.

O Ponto de Entrada MVC MATA094, chamado a partir do código-fonte MATA094_PE.PRW, 
 permite ao usuário adicionar opções na barra de menus EnchoiceBar.

@author Henrique Dutra
@since 31/03/2021
@version 1.0
@version 1.1
@Rotina chama User Function para montar e tratar o link.
U_MITA002
19/11/2021 - Adicionado acionado função para gerar PA no ponto FORMCOMMITTTSPOS

@type function
*/

User Function MATA094()
    Local aAreaAtu  := GetArea()
    Local aParam    := PARAMIXB
    Local xRet      := .T.
    Local oObj      := ""
    Local cIdPonto  := ""
    Local cIdModel  := ""
    Local lSegue    := .t.
    Local cQryScr   := ""
    Local cNumDoc   := SCR->CR_NUM
    Private dVencPa := SC7->C7_XVENCPA
    Private nVlroPA := SC7->C7_XVLRPA

    If (aParam <> NIL)
        oObj     := aParam[1]
        cIdPonto := aParam[2]
        cIdModel := aParam[3]   
        nOpc     := oObj:GetOperation() // PEGA A OPERAÇÃO
        
        If cIdPonto ==  'FORMCOMMITTTSPOS'
            //Se for tipo PC verifico se é um pedido de Reembolso
            If SCR->CR_TIPO == 'PC'
                //Verifico se a condição de pagamento é antecipada
                DbSelectArea("SE4")
                SE4->(DbSetOrder(1))
                SE4->(MsSeek(xFilial("SE4") + SC7->C7_COND ))
                If SE4->E4_CTRADT == '1' .or. (!Empty(dVencPa) .and. nVlroPA >0)
                    //Baixa título provisório e gera PA
                    lSegue := BaixaPR()
                    //Gerar título de pagamento antecipado
                    If lSegue
                        lSegue := GeraPA()
                    Endif
                    xRet := lSegue
                Endif
            Endif
        ElseIf cIdPonto == 'MODELCOMMITNTTS'
            If SCR->CR_TIPO == 'PC'
                If Select("TRBSCR") > 0
                    DbSelectArea("TRBSCR")
                    TRBSCR->(DbCloseArea())
                Endif
                cQryScr := " SELECT MAX(CR_NIVEL) AS CR_NIVEL FROM "+ RetSqlTab("SCR") +" WHERE SCR.D_E_L_E_T_<>'*'
                cQryScr += " AND CR_NUM = '"+ cNumDoc +"'"
                TcQuery cQryScr NEW ALIAS "TRBSCR"
                //Se for maximo nível de aprovação chama a rotina para geração do documento de entrada de reembolsos de despesa
                If TRBSCR->CR_NIVEL == SCR->CR_NIVEL
                    xRet := INCLREEMB(SCR->CR_NUM, SCR->CR_FILIAL)
                Endif
            Endif
        ElseIf cIdPonto == 'BUTTONBAR'
            xRet := {}
            Aadd(xRet ,  {"Link do Documento", "Link do Documento", {|| U_MITA002() }})
        EndIf
    
        RestArea(aAreaAtu)
        
    EndIf
 
Return (xRet)
Static Function BaixaPR()
    local aTitBx := {}
    local cHistBaixa := "Baixa ref. substituicao de titulo Provis"
    local cTiposProv := Padr('PR',3,'')
    local dVencTit := SE2->E2_VENCTO
    local cFilTit  := SE2->E2_FILIAL
    local cNumTit  := SE2->E2_NUM
    local cPrefTit := SE2->E2_PREFIXO
    local cParcTit := SE2->E2_PARCELA
    local cTipoTit := SE2->E2_TIPO
    local cFornTit := SE2->E2_FORNECE
    local cLojaTit := SE2->E2_LOJA
    local nVlrTit  := SE2->E2_VALOR
    local lRet     := .t.
    Private lMsErroAuto := .f.
    DbSelectArea("SE2")
    SE2->(DbSetOrder(6)) //E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO 
    If MsSeek(xFilial('SE2') + SC7->C7_FORNECE + SC7->C7_LOJA + Space(3) + 'PCA' +SC7->C7_NUM + Space(3) + cTiposProv,.t.)    

        dVencPa := SE2->E2_VENCTO
        nVlroPA := SE2->E2_SALDO
                                                                                           
        If SE2->E2_VENCTO < dDataBase
            If !Isblind()
                Help( ,, 'PA com vencimento Expirado' ,, 'O vencimento do pagamento antecipado está expirado! Efetue a rejeição do pedido.', 1,0,NIL, NIL, NIL, NIL, NIL, {"O comprador responsável será avisado para validar os valores e uma nova data de pagamento junto ao fornecedor"})
            Else
                Conout("O vencimento do pagamento antecipado está expirado! Efetue a rejeição do pedido..."+SC7->C7_NUM)
            Endif
            lRet := .f.
        Else
            //Variaveis para utilizaas na gravação da tabela de rastreio após a substituição do provisório
            dVencTit := SE2->E2_VENCTO
            cFilTit  := SE2->E2_FILIAL
            cNumTit  := SE2->E2_NUM
            cPrefTit := SE2->E2_PREFIXO
            cParcTit := SE2->E2_PARCELA
            cTipoTit := SE2->E2_TIPO
            cFornTit := SE2->E2_FORNECE
            cLojaTit := SE2->E2_LOJA
            nVlrTit  := SE2->E2_VALOR

            //Efetua a baixa do título provisório
            Aadd(aTitBx, {"E2_PREFIXO",    SE2->E2_PREFIXO,      NIL})
            Aadd(aTitBx, {"E2_NUM",        SE2->E2_NUM,          NIL})
            Aadd(aTitBx, {"E2_PARCELA",    SE2->E2_PARCELA,      NIL})
            Aadd(aTitBx, {"E2_TIPO",       SE2->E2_TIPO,         NIL})
            Aadd(aTitBx, {"E2_FORNECE",    SE2->E2_FORNECE,      NIL})
            Aadd(aTitBx, {"E2_LOJA",       SE2->E2_LOJA,         NIL})
            Aadd(aTitBx, {"AUTMOTBX",      "STP",                NIL})
            Aadd(aTitBx, {"AUTDTBAIXA",    dDataBase,            NIL})
            Aadd(aTitBx, {"AUTDTDEB",      dDataBase,            NIL})
            Aadd(aTitBx, {"AUTHIST",       cHistBaixa,           NIL})

            MVPROVIS := Space(3)  //Alteração para não apresentar o Help "TITULOPROV"  
            MsExecauto({|a,b,c,d,e,f,| FINA080(a,b,c,d,e,f)}, aTitBx, 3, .F., 1, .F., .F.)   
            MVPROVIS := cTiposProv //Retornao conteúdo original 
            If (lMsErroAuto == .T.)
                lRet := .f.
                If !IsBlind()
                    MostraErro()
                Else
                    Conout("Ocorreu um erro na baixa do titulo provisorio do pedido "+ SC7->C7_NUM)
                Endif
            Else
                //Deleta o título provisório
                If SE2->(MsSeek(xFilial('SE2') + SC7->C7_FORNECE + SC7->C7_LOJA + Space(3) + 'PCA' +SC7->C7_NUM + Space(3) + cTiposProv,.t.) )   
                    RecLock("SE2",.F.)
                    SE2->(DbDelete())
                    SE2->(MsUnlock())
                Endif
                //ApMsgInfo("Titulo provisório baixado com sucesso!","Substituição Titulo Provisório")
                //Grava referencia do provisório
                lRet := .t.
                RecLock("FII",.T.)
                FII->FII_FILIAL := xFilial("FII")
                FII->FII_ENTORI := "SE2"
                FII->FII_PREFOR := cPrefTit
                FII->FII_NUMORI := cNumTit
                FII->FII_PARCOR := cParcTit
                FII->FII_TIPOOR := cTipoTit
                FII->FII_CFORI  := cFornTit
                FII->FII_LOJAOR := cLojaTit
                //Destino
                FII->FII_ENTDES := "SE2"
                FII->FII_PREFDE := cPrefTit
                FII->FII_NUMDES := cNumTit
                FII->FII_PARCDE := cParcTit
                FII->FII_TIPODE := "PA"
                FII->FII_CFDES  := cFornTit
                FII->FII_LOJADE := cLojaTit
                FII->FII_FILDES := xFilial("FII")
                FII->FII_SEQ    := SE5->E5_SEQ
                FII->FII_ROTINA := FUNNAME()
                FII->FII_OPERAC := "  "
                FII->(MsUnlock())

                // Grava referencia do novo titulo para o arquivo no banco de conhecimento
                dbSelectArea("AC9")
                AC9->(dbSetOrder(2))
                If AC9->(dbSeek(xFilial("AC9") + "SE2" + xFilial("SE2") + cPrefTit+cNumTit+cParcTit+cTipoTit+cFornTit+cLojaTit))
                    RecLock("AC9",.F.)
                    AC9->AC9_CODENT := cPrefTit+cNumTit+cParcTit+"PA"+cFornTit+cLojaTit
                    MsUnlock()
                EndIf
                //Grava registro de rastreamento
                RecLock("FI8",.T.)
                FI8_FILIAL	:= cFilTit
                FI8_DATA	:= dDataBase
                FI8_PRFORI	:= cPrefTit
                FI8_NUMORI	:= cNumTit
                FI8_PARORI	:= cParcTit
                FI8_TIPORI	:= cTipoTit
                FI8_FORORI	:= cFornTit
                FI8_LOJORI	:= cLojaTit
                FI8_FILDES	:= cFilTit
                FI8_PRFDES	:= cPrefTit
                FI8_NUMDES	:= cNumTit
                FI8_PARDES	:= cParcTit
                FI8_TIPDES	:= 'PA'
                FI8_FORDES	:= cFornTit
                FI8_LOJDES	:= cLojaTit
                FI8_VALOR	:= nVlrTit
                FI8_STATUS	:= "0"
                FI8->(MsUnlock())
                //Grava o numero do titulo pai para rastreio na exclusão do título efetivo
                DbSelectArea("SE2")
                DbSetOrder(6)
                //E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO                                                                                                                                                                                              
                If SE2->(MsSeek(xFilial("SE2") + cFornTit + cLojaTit + cPrefTit + cNumTit + cParcTit + cTipoTit ),.T.)
                    RecLock("SE2",.F.)
                    SE2->E2_TITPAI := FI8->FI8_PRFORI + FI8->FI8_NUMORI + FI8->FI8_PARORI + FI8->FI8_TIPORI + FI8->FI8_FORORI + FI8->FI8_LOJORI
                    SE2->(MsUnlock())
                Endif
            Endif
            dVencPa := dVencTit
            nVlroPA := nVlrTit
        Endif
    Endif

Return lRet

Static Function GeraPA()

    local aArray   := {}
    local cNumPa   := "PCA"+ SC7->C7_NUM
    local cOwner   := ""
    local cBancoPA    := GetMv("MV_BCOPA") 
    local cContaPA    := GetMv("MV_CCPA")
    local cAgenciaPA  := GetMv("MV_AGENPA")
    local cNatureza   := Posicione("SA2",1,xFilial("SA2") + SC7->C7_FORNECE + SC7->C7_LOJA,"A2_NATUREZ")
    local cHistorico  := "Pagamento Antecipado do Pedido " + SC7->C7_NUM
    local dLibPed     := SC7->C7_EMISSAO
    local cTiposPa := Padr('PA',3,'')
    local lRet        := .t.

    private lMsErroAuto := .F.
    If ! MsSeek(xFilial('SE2') + SC7->C7_FORNECE + SC7->C7_LOJA + Space(3) + 'PCA' +SC7->C7_NUM + Space(3) + cTiposPa,.t.)    
    
        DbSelectArea("SED")
        SED->(DbSetOrder(1)) //ED_FILIAL+ED_CODIGO 

        //CH_FILIAL+CH_PEDIDO+CH_FORNECE+CH_LOJA+CH_ITEMPD+CH_ITEM 
        //CX_FILIAL+CX_SOLICIT+CX_ITEMSOL+CX_ITEM 
        If dVencPa <= dDataBase
            dVencPa :=  dVencPa + 2
            dLibPed := dDataBase
        Endif    
        DbSelectArea("SCX")
        SCX->(DbSetOrder(1))
        SCX->(MsSeek(xFilial("SCX") + SC7->C7_NUMSC + SC7->C7_ITEMSC ),.F.)
        cOwner := SCX->CX_CLVL
        aAdd(aArray,{ "E2_PREFIXO" , Space(3)        , NIL })
        aAdd(aArray,{ "E2_NUM"     , cNumPa          , NIL })
        aAdd(aArray,{ "E2_PACELA"  , Space(3)        , NIL })
        aAdd(aArray,{ "E2_TIPO"    , "PA"            , NIL })
        aAdd(aArray,{ "E2_NATUREZ" , cNatureza       , NIL })
        aAdd(aArray,{ "E2_FORNECE" , SC7->C7_FORNECE , NIL })
        aAdd(aArray,{ "E2_LOJA"    , SC7->C7_LOJA    , NIL })
        aAdd(aArray,{ "E2_EMISSAO" , dLibPed         , NIL })
        aAdd(aArray,{ "E2_CLVL"    , cOwner          , NIL })
        aAdd(aArray,{ "E2_XMODPAG" , SC7->C7_XMODPAG , NIL })
        aAdd(aArray,{ "E2_VENCTO"  , dVencPa         , NIL })
        aAdd(aArray,{ "E2_VENCREA" , Datavalida(dVencPa,.t.), NIL })
        aAdd(aArray,{ "E2_VALOR"   , nVlroPA         , NIL })
        aAdd(aArray,{ "E2_HIST"    , cHistorico      , NIL })
        aAdd(aArray,{ "AUTBANCO"   , cBancoPA        , NIL })
        aAdd(aArray,{ "AUTAGENCIA" , cAgenciaPA      , NIL })
        aAdd(aArray,{ "AUTCONTA"   , cContaPA        , NIL })

        MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aArray,, 3) 

        If lMsErroAuto
            lRet := .f.
            If !IsBlind()
                ApMsgAlert("Título de adiantamento não incluído, informe o administrador do sistema!","Pagamento Antecipado")
                MostraErro()
            Else
                Conout("Título de adiantamento não incluído, informe o administrador do sistema...Pedido "+SC7->C7_NUM)
            Endif
        Else
            //Gravando amarração da PA com o pedido
            lRet := .t.
            DbSelectArea( "FIE" )
            dbSetOrder(3)
            If MsSeek( xFilial("FIE")+"P"+SE2->(E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO)+SC7->C7_NUM )
                RecLock( "FIE", .F. )
            Else
                RecLock( "FIE", .T. )
            Endif
            FIE->FIE_FILIAL	:= xFilial( "FIE" )
            FIE->FIE_CART	:= "P"
            FIE->FIE_PEDIDO	:= SC7->C7_NUM
            FIE->FIE_PREFIX	:= SE2->E2_PREFIXO
            FIE->FIE_NUM	:= SE2->E2_NUM
            FIE->FIE_PARCEL	:= SE2->E2_PARCELA
            FIE->FIE_TIPO	:= SE2->E2_TIPO
            FIE->FIE_FORNEC	:= SE2->E2_FORNECE
            FIE->FIE_LOJA	:= SE2->E2_LOJA
            FIE->FIE_VALOR	:= SE2->E2_VALOR
            FIE->FIE_SALDO	:= SE2->E2_SALDO
            FIE->FIE_FILORI := cFilant
            FIE->( MsUnLock() )
        Endif
    Endif

Return lRet

Static Function INCLREEMB(cNumPed, cFilDoc)
    local cQrySc7     := ""
    local aGrupoRD    := StrTokArr(GetMv("SC_GRPRD"),";")
    local lRet        := .t.
    Private aDadosNfe := {}

    If Select("TRB7") > 0
        DbSelectArea("TRB7")
        TRB7->(DbCloseArea())
    Endif

    cQrySc7 += " SELECT DISTINCT C7_FILIAL, C7_NUM, C7_FORNECE, C7_LOJA, C7_ITEM, C7_PRODUTO, C7_UM, C7_QUANT, C7_PRECO, C7_TOTAL, B1_GRUPO, C7_TES, C7_COND, C7_XLINK, C7_LOCAL "
    cQrySc7 += " FROM " + RetSqlTab("SC7") + " LEFT OUTER JOIN "+ RetSqlTab("SB1") + " 
    cQrySc7 += " ON C7_PRODUTO = B1_COD AND SB1.D_E_L_E_T_<>'*' 
    cQrySc7 += " WHERE SC7.D_E_L_E_T_<>'*'  AND C7_FILIAL = '"+cFilDoc+ "' AND C7_NUM = '"+Alltrim(cNumPed)+"' "

    TcQuery cQrySc7 NEW ALIAS "TRB7"

    If aScan(aGrupoRD,{|x| AllTrim(x) == TRB7->B1_GRUPO }) > 0 
        //Se for reembolso gera documento de entrada
        While TRB7->(!Eof())
            aadd(aDadosNfe,{ TRB7->C7_FILIAL,;      //01
                                TRB7->C7_NUM,;      //02
                                TRB7->C7_FORNECE,;  //03
                                TRB7->C7_LOJA,;     //04
                                TRB7->C7_ITEM,;      //05
                                TRB7->C7_PRODUTO,;  //06
                                TRB7->C7_UM,;       //07
                                TRB7->C7_QUANT,;    //08
                                TRB7->C7_PRECO,;    //09
                                TRB7->C7_TOTAL,;    //10
                                TRB7->B1_GRUPO,;    //11
                                TRB7->C7_TES,;      //12
                                TRB7->C7_COND,;     //13
                                TRB7->C7_XLINK,;    //14
                                TRB7->C7_LOCAL;     //15
                                })
        TRB7->(DbSkip())
        EndDo
        lRet :=INCDOCENT()
    Endif

Return lRet

Static Function INCDOCENT
    local aRatPC   := {}
    local aRateioCC:= {}
    local aItens   := {}
    local aItensPre:= {}
    local aLinhaPre:= {}
    local aCodRet  := {}
    local nContRat := 0
    local nCont    := 0
    local nAux     := 0
    local cFilDoc  := aDadosNfe[1,1] 
    local cNumPC   := aDadosNfe[1,2] 
    local cFornece := aDadosNfe[1,3] 
    local cLojForn := aDadosNfe[1,4]
    local cItemAux := ""
    local cErro    := ""
    local nItemAux := 0
    local lNfOk    := .t.
    private lMsErroAuto := .f.
    private lMsHelpAuto := .t.
    private lAutoErrNoFile := .T.

    DbSelectArea("SCH") 
    SCH->(DbSetOrder(1)) //CH_FILIAL+CH_PEDIDO+CH_FORNECE+CH_LOJA+CH_ITEMPD+CH_ITEM 
    If SCH->(MsSeek( cFilDoc + cNumPC + cFornece + cLojForn ),.t.)
        While SCH->(!Eof()) .and. SCH->(CH_FILIAL+CH_PEDIDO+CH_FORNECE+CH_LOJA) == cFilDoc + cNumPC + cFornece + cLojForn
            If cItemAux <> SCH->CH_ITEMPD
                aadd(aRatPC, {SCH->CH_ITEMPD,{SCH->CH_FILIAL, SCH->CH_PEDIDO, SCH->CH_FORNECE, SCH->CH_LOJA, SCH->CH_ITEMPD, SCH->CH_ITEM, SCH->CH_PERC, SCH->CH_CC, SCH->CH_CONTA, SCH->CH_ITEMCTA, SCH->CH_CLVL}})
                nItemAux ++
            Else
                aadd(aRatPC[nItemAux], { SCH->CH_FILIAL, SCH->CH_PEDIDO, SCH->CH_FORNECE, SCH->CH_LOJA, SCH->CH_ITEMPD, SCH->CH_ITEM, SCH->CH_PERC, SCH->CH_CC, SCH->CH_CONTA, SCH->CH_ITEMCTA, SCH->CH_CLVL })
            Endif
            cItemAux := SCH->CH_ITEMPD
            SCH->(DbSkip())
        EndDo
    Endif
    DbSelectArea("SX5")
    SX5->(MsSeek(xFilial("SX5") +'01' + "RD0"))
	cDoc := Alltrim(SX5->X5_DESCRI)
    
    DbSelectArea("SX5")
    SX5->(MsSeek(xFilial("SX5") +'01' + "RD0"))
    RecLock("SX5",.F.)
    SX5->X5_DESCRI  := 'RD'+ Soma1(AllTrim(Substr(cDoc,3,7)))
    SX5->X5_DESCSPA := 'RD'+ Soma1(AllTrim(Substr(cDoc,3,7)))
    SX5->X5_DESCENG := 'RD'+ Soma1(AllTrim(Substr(cDoc,3,7)))
    SX5->(MsUnlock())
	aCabec := {}
	AADD(aCabec,{"F1_FILIAL"  , cFilDoc             , NIL }) //Filial
	AADD(aCabec,{"F1_TIPO"    , 'N'                 , NIL }) //Tipo de Nf
	AADD(aCabec,{"F1_FORMUL"  , 'S'                 , NIL }) //Formulaio prorio
	AADD(aCabec,{"F1_DOC"     , cDoc                , NIL }) //Numero do documento
	AADD(aCabec,{"F1_SERIE"   , 'RD0'                , NIL }) //Serie
	AADD(aCabec,{"F1_EMISSAO" , dDataBase           , NIL }) //Emissao
	AADD(aCabec,{"F1_DTDIGIT" , dDataBase           , NIL }) //Digitacao
	AADD(aCabec,{"F1_FORNECE" , cFornece            , NIL }) //Fornecedor
	AADD(aCabec,{"F1_LOJA"    , cLojForn            , NIL }) //Loja
	AADD(aCabec,{"F1_ESPECIE" , 'RD'                , NIL }) //Especie
	AADD(aCabec,{"F1_COND"    , aDadosNfe[1,13]     , NIL }) //Condicao de pagamento
	aadd(aCabec,{"F1_DESPESA" , 0                   , NIL })
	aadd(aCabec,{"F1_DESCONT" , 0                   , Nil })
	aadd(aCabec,{"F1_SEGURO"  , 0                   , Nil })
	aadd(aCabec,{"F1_FRETE"   , 0                   , Nil })
	aadd(aCabec,{"F1_MOEDA"   , 1                   , Nil })
	aadd(aCabec,{"F1_TXMOEDA" , 1                   , Nil })
	//aadd(aCabec,{"F1_STATUS"  , "A"                 , Nil })
	aadd(aCabec,{"F1_XLINK"   , aDadosNfe[1,14]     , Nil })
	
	FOR nCont := 1 TO LEN(aDadosNfe)
	    
		CONOUT("Step 4 - Entrei no For do ALINHA da Nota de Entrada")
		aLinha := {}
        aLinhaPre := {}
        //Array da pré nota
		AADD(aLinhaPre,{"D1_ITEM"   , StrZero(nCont,TamSx3("D1_ITEM")[1]) , NIL})
		AADD(aLinhaPre,{"D1_COD"    , aDadosNfe[nCont,6]       			   , NIL})
		aadd(aLinhaPre,{"D1_UM"     , aDadosNfe[nCont,7]                      , NIL})
		aadd(aLinhaPre,{"D1_LOCAL"  , aDadosNfe[nCont,15]                     , NIL})
		AADD(aLinhaPre,{"D1_QUANT"  , aDadosNfe[nCont,8]   				   , NIL})
		AADD(aLinhaPre,{"D1_VUNIT"  , aDadosNfe[nCont,9]  					   , NIL})
		AADD(aLinhaPre,{"D1_TOTAL"  , aDadosNfe[nCont,10]       			   , NIL})
		AADD(aLinhaPre,{"D1_XLINK"  , aDadosNfe[nCont,14]       			   , NIL})
        aadd(aItensPre, aLinhaPre)
        aadd(aItensPre[Len(aItensPre)], {'D1_PEDIDO', aDadosNfe[nCont,2] , nil}) // Número do Pedido de Compras
        aadd(aItensPre[Len(aItensPre)], {'D1_ITEMPC', aDadosNfe[nCont,5] , nil}) // Item do Pedido de Compras

        //Array para documento de entrada 
        aAdd(aLinha,{"LINPOS"    , "D1_ITEM"                       ,SD1->D1_ITEM})
		AADD(aLinha,{"D1_COD"    , aDadosNfe[nCont,6]       			   , NIL})
		aadd(aLinha,{"D1_UM"     , aDadosNfe[nCont,7]                      , NIL})
		aadd(aLinha,{"D1_LOCAL"  , aDadosNfe[nCont,15]                     , NIL})
		AADD(aLinha,{"D1_QUANT"  , aDadosNfe[nCont,8]   				   , NIL})
		AADD(aLinha,{"D1_VUNIT"  , aDadosNfe[nCont,9]  					   , NIL})
		AADD(aLinha,{"D1_TOTAL"  , aDadosNfe[nCont,10]       			   , NIL})
		AADD(aLinha,{"D1_TES"    , aDadosNfe[nCont,12]                     , NIL})
		AADD(aLinha,{"D1_RATEIO" , '1'			     					   , NIL})

		AADD(aItens, aLinha)
        aadd(aItens[Len(aItens)], {'D1_PEDIDO', aDadosNfe[nCont,2] , nil}) // Número do Pedido de Compras
        aadd(aItens[Len(aItens)], {'D1_ITEMPC', aDadosNfe[nCont,5] , nil}) // Item do Pedido de Compras
        If Len(aRatPC) > 0
            AAdd(aRateioCC,{STRZERO(nCont,4),{}})	
            FOR nContRat := 1 TO LEN(aRatPC)

                IF STRZERO(nCont,4) == aRatPC[nContRat,1]
                
                    aItemRat := {}	
                    
                    AAdd(aItemRat,{"DE_FILIAL" , aRatPC[nContRat, 2,1]              ,NIL})
                    AAdd(aItemRat,{"DE_ITEM"   , aRatPC[nContRat, 2,6]              ,NIL})
                    AAdd(aItemRat,{"DE_DOC"    , cDoc                               ,NIL})
                    AAdd(aItemRat,{"DE_SERIE"  , "RD0"                              ,NIL})
                    AAdd(aItemRat,{"DE_FORNECE", cFornece                           ,NIL})
                    AAdd(aItemRat,{"DE_LOJA"   , cLojForn                           ,NIL})
                    AAdd(aItemRat,{"DE_ITEMNF" , StrZero(nCont,TamSx3("D1_ITEM")[1]),NIL})
                    AAdd(aItemRat,{"DE_PERC"   , aRatPC[nContRat, 2,7]              ,NIL})
                    AAdd(aItemRat,{"DE_CC"     , aRatPC[nContRat, 2,8]              ,NIL})
                    AAdd(aItemRat,{"DE_CONTA  ", aRatPC[nContRat, 2,9]              ,NIL})
                    AAdd(aItemRat,{"DE_ITEMCTA", aRatPC[nContRat, 2,10]             ,NIL})
                    AAdd(aItemRat,{"DE_CLVL"   , aRatPC[nContRat, 2,11]             ,NIL})

                    AAdd(aRateioCC[nCont][2],aItemRat)
                ENDIF

            Next nContRat
        Endif
	NEXT nCont
			                         
	IF LEN(aCabec) > 0 .AND. ;
	   LEN(aItens) > 0
	   
	   	CONOUT("Step 5 - Entrei no IF DO LEN ACAB")
	   	    
		aCabec      := FWVetByDic(aCabec,"SF1",.F.,1)
		aItens      := FWVetByDic(aItens,"SD1",.T.,1)  
		aItensPre   := FWVetByDic(aItensPre,"SD1",.T.,1)  
		
		lMsErroAuto := .F.
        //Altera o parametro para permitir a inclusão da pre nota do pedido bloqueado
        //Isso foi necessário devido ao pedido ainda está me processo de aprovação, o que não permitiria a inclusão da nota.
		DbSelectArea("SX6")
		SX6->(DbSetOrder(1))
		If SX6->(DbSeek(XFilial("SX6")+"MV_RESTNFE "))
			RecLock("SX6",.F.)
			SX6->X6_CONTEUD := "N" //Não permite o faturamento manual enquanto a rotina automatica estiver em execução.
			MsUnlock()
		Endif
        
        MSExecAuto( { |x,y,z| MATA140( x, y, z ) }, aCabec, aItensPre, 3 ) // Inclusão Pré Nota
		CONOUT("ANTES DO MSEXCAUTO IGUAL 3")
            // Exemplo para manipular o pergunte MTA103
            aParamAux := {}
            aAdd(aParamAux, {"MV_PAR01", 2}) //-- Mostra Lanc. Contabil? 1 = Sim, 2 = Não
            aAdd(aParamAux, {"MV_PAR06", 2}) //-- Contabilizacao Online? 1 = Sim, 2 = Não
		MSExecAuto({|x,y,z,a,b| MATA103(x,y,z,,,,,a,,,b)},aCabec,aItens,3,aRateioCC,,,,,,,,.t. )
            //Retorna o conteudo do parametro que bloquea notas com pedidos bloqueados
            DbSelectArea("SX6")
            SX6->(DbSetOrder(1))
            If SX6->(DbSeek(XFilial("SX6")+"MV_RESTNFE "))
                RecLock("SX6",.F.)
                SX6->X6_CONTEUD := "S" //Não permite o faturamento manual enquanto a rotina automatica estiver em execução.
                MsUnlock()
            Endif
		CONOUT("DEPOIS DO MSEXCAUTO IGUAL 3")
 
		IF lMsErroAuto == .T.
                lNfOk := .f.
			CONOUT("Step 6 - Entrei no IF DO lMsErroAuto")
                MostraErro()
			aErrPCAuto := GETAUTOGRLOG()

			For nAux := 1 to Len(aErrPCAuto)
				cErro = cErro + (aErrPCAuto[nAux]) + "|"
			Next nAux
		ELSE
                lNfOk := .t.
            ApMsgInfo('Nota de Reembolso incluída com sucesso!')
			CONOUT("Step 7 - Entrei no ELSE DO lMsErroAuto")
		ENDIF	    
        Else
            lNfOk := .f.
            MostraErro()
            aErrPCAuto := GETAUTOGRLOG()
            For nAux := 1 to Len(aErrPCAuto)
                cErro = cErro + (aErrPCAuto[nAux]) + "|"
            Next nAux
            CONOUT("Erro na inclusao da pre nota de reembolso..."+cErro)
        Endif
    Endif
Return lNfOk
