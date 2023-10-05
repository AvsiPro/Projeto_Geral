#Include 'Totvs.ch'

/*/{Protheus.doc} JCAJOB04
   @description: Contabilização de Abastecimentos nas Filiais de Origem
   @type: User Function
   @author: Felipe Mayer
   @since: 15/09/2023
/*/
User Function JCAJOB04(xEmp, xFi, lJob)

    Local aCab   := {}
    Local aItens := {}
    Local nOpcao := 0

    Private CTF_LOCK := 0
    Private lSubLote := .T.

    Default xEmp := '01'
    Default xFil := '00020087'
    Default lJob := .F.

    If Empty(FunName())
       RpcSetType(3)
       RpcSetEnv(xEmp,xFil)
    EndIf

    If !lJob
        nOpcao := Aviso(;
            "Contabilização Filial de Origem","Está rotina tem como objetivo fazer a Contabilização de Abastecimentos nas Filiais de Origem."+CRLF+;
            "Por favor, clique na opção desejada e aguarde até o fim da execução.",;
            {"Confirmar","Fechar"},3;
        )

        If nOpcao == 2
            Return()
        Endif
    EndIf

    cQuery := " SELECT T9_ZFILORI, CT2_MOEDLC, CT2_DC, CT2_DEBITO, CT2_CREDIT,
    cQuery += " CT2_XABAST, CT2_VALOR, CT2_HP, CT2_HIST, D3_DOC, D3_COD, D3_FILIAL
    cQuery += " FROM "+RetSqlName('TQN')+" TQN
    cQuery += " INNER JOIN "+RetSqlName('ST9')+" ST9
    cQuery += " 	ON T9_FILIAL = '"+xFilial('ST9')+"'
    cQuery += " 	AND T9_CODBEM = TQN_FROTA
    cQuery += " 	AND T9_ZFILORI != ''
    cQuery += " 	AND ST9.D_E_L_E_T_ = ''
    cQuery += " INNER JOIN "+RetSqlName('SD3')+" SD3
    cQuery += " 	ON D3_FILIAL = TQN_FILIAL
    cQuery += " 	AND D3_XABAST = TQN_NABAST
    cQuery += " 	AND D3_XDTCTFL = ''
    cQuery += " 	AND SD3.D_E_L_E_T_ = ''
    cQuery += " INNER JOIN "+RetSqlName('CT2')+" CT2
    cQuery += " 	ON CT2_FILIAL = TQN_FILIAL
    cQuery += " 	AND CT2_XABAST = TQN_NABAST
    cQuery += " 	AND CT2.D_E_L_E_T_ = ''
    cQuery += " WHERE TQN.D_E_L_E_T_ = ''
    cQuery += " 	AND T9_ZFILORI != TQN_FILIAL

    cAliasTMP := GetNextAlias()
    MPSysOpenQuery(cQuery, cAliasTMP)
    
    While (cAliasTMP)->(!EoF())
        aCab   := {}
        aItens := {}

        aAdd(aCab, {'DDATALANC'  ,  dDataBase  ,Nil} )
        aAdd(aCab, {'CLOTE'      ,  '008840'   ,Nil} )
        aAdd(aCab, {'CSUBLOTE'   ,  '001'      ,Nil} )
        aAdd(aCab, {'CPADRAO'    ,  ''         ,Nil} )
        aAdd(aCab, {'NTOTINF'    ,  0          ,Nil} )
        aAdd(aCab, {'NTOTINFLOT' ,  0          ,Nil} )

        aAdd(aItens,{;
            {'CT2_FILIAL' , (cAliasTMP)->T9_ZFILORI , Nil},;
            {'CT2_LINHA'  , '001'                   , Nil},;
            {'CT2_MOEDLC' , (cAliasTMP)->CT2_MOEDLC , Nil},;
            {'CT2_DC'     , (cAliasTMP)->CT2_DC     , Nil},;
            {'CT2_DEBITO' , (cAliasTMP)->CT2_DEBITO , Nil},;
            {'CT2_CREDIT' , (cAliasTMP)->CT2_CREDIT , Nil},;
            {'CT2_VALOR'  , (cAliasTMP)->CT2_VALOR  , Nil},;
            {'CT2_ORIGEM' , 'JCAJOB04'              , Nil},;
            {'CT2_HP'     , (cAliasTMP)->CT2_HP     , Nil},;
            {'CT2_XABAST' , (cAliasTMP)->CT2_XABAST , Nil},;
            {'CT2_HIST'   , (cAliasTMP)->CT2_HIST   , Nil} ;
        }) 

        lMsErroAuto := .F.
        lMsHelpAuto := .T.

        MsExecAuto({|x, y,z| CTBA102(x,y,z)}, aCab ,aItens, 3)

        If lMsErroAuto
            If lJob
                MostraErro('\system\','JCAJOB04_'+DToS(dDataBase)+StrTran(cValToChar(Time()),":"))
            Else
                If MsgYesNo('Erro ao gerar contabilização, deseja visualizar o erro?')
                    MostraErro()
                EndIf
            EndIf
        Else

            SD3->(DbSetOrder(2))
            If SD3->(DbSeek(;
                AvKey((cAliasTMP)->D3_FILIAL,'D3_FILIAL');
                +AvKey((cAliasTMP)->D3_DOC,'D3_DOC');
                +AvKey((cAliasTMP)->D3_COD,'D3_COD');
            ))
                RecLock('SD3', .F.)
                    D3_XDTCTFL := Date()
                SD3->(MsUnlock())
            EndIf
        Endif
        
        (cAliasTMP)->(DbSkip())
    EndDo

    If !lJob
        MsgInfo('Processo realizado com sucesso!')
    EndIf
    
    (cAliasTMP)->(DbCloseArea())
Return
