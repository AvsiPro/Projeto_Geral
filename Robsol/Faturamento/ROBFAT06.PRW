#Include 'PROTHEUS.CH'
#Include 'RWMAKE.CH'
#Include 'FONT.CH'
#Include 'COLORS.CH'
#Include "Fileio.ch"

/*/{Protheus.doc} ROBFAT06
    @long_description Tela de atendimento de chamados Robsol
    @type User Function
    @author Felipe Mayer
    @since 23/08/2022
    @version 1
/*/
User Function ROBFAT06()

Local aList0    := {}
Local cQuery    := ''
Local cAliasSQL := GetNextAlias()
Local aStatus   := {'Aberto','Atendido','Negado','Aguardando Cliente'}
Local lZ52      :=  .F.

Private cMsgNew   := space(1024)
Private cVend1    := ''

SetPrvt("oDlg1","oGrp1","oGrp2","oFld1","oBtn1","oBtn2","oList0","oList1","oCombo1")
SetPrvt("oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oSay7","oSay8","oSay9","oSay10","oSay11","oSay12","oSay13","oSay14","oSay16","oSay17")

    If Z50->Z50_STATUS == '4'
        MsgAlert('Não é possível atender um pedido finalizado.')
        Return
    EndIf

    cQuery := " SELECT TOP 1 ISNULL(CAST(CAST(Z50_OBSATD AS VARBINARY(8000)) AS VARCHAR(8000)),'') AS Z50_OBSATD"
    cQuery += " ,Z50.*,SF2.*,SC5.* FROM "+RetSqlName('Z50')+" Z50 "
    cQuery += " INNER JOIN "+RetSqlName('SF2')+" SF2 "
    cQuery += "     ON F2_DOC=Z50_NOTA "
    cQuery += "     AND F2_CLIENTE=Z50_CODCLI "
    cQuery += "     AND F2_LOJA=Z50_LOJCLI "
    cQuery += "     AND SF2.D_E_L_E_T_='' "
    cQuery += " LEFT JOIN "+RetSqlName('SC5')+" SC5  "
    cQuery += "     ON C5_FILIAL = F2_FILIAL "
    cQuery += "     AND C5_CLIENTE = F2_CLIENTE "
    cQuery += "     AND C5_LOJACLI = F2_LOJA "
    cQuery += "     AND C5_VEND1 = F2_VEND1 "
    /*cQuery += "     AND C5_NOTA = F2_DOC "
    cQuery += "     AND C5_SERIE = F2_SERIE "*/
    cQuery += "     AND C5_CONDPAG = F2_COND "
    cQuery += "     AND C5_TIPOCLI = F2_TIPOCLI "
    //cQuery += "     AND C5_NOTA = F2_DOC "
    cQuery += "     AND C5_LOJAENT = F2_LOJENT "
    cQuery += "     AND SC5.D_E_L_E_T_='' "
    cQuery += " WHERE Z50.D_E_L_E_T_='' "
    cQuery += "     AND Z50_NOTA='"+Z50->Z50_NOTA+"' "
    cQuery += "     AND Z50_CODCLI='"+Z50->Z50_CODCLI+"' "
    cQuery += "     AND Z50_LOJCLI='"+Z50->Z50_LOJCLI+"' "
    cQuery += "     AND Z50_CODIGO='"+Z50->Z50_CODIGO+"' "
    cQuery += "     AND Z50_PROD='"+Z50->Z50_PROD+"' "
    cQuery += "     AND Z50_ITEM='"+Z50->Z50_ITEM+"' "
	cQuery := ChangeQuery(cQuery)

	MPSysOpenQuery(cQuery,cAliasSQL)

    While (cAliasSQL)->(!EoF())

        If Empty(cVend1)
            cVend1 := Alltrim((cAliasSQL)->C5_VEND1)
        EndIf

        Aadd(aList0,{;
            Alltrim((cAliasSQL)->Z50_CODIGO),;
            DToC(SToD((cAliasSQL)->Z50_DTCRIA)),;
            Alltrim((cAliasSQL)->Z50_HRCRIA),;
            aStatus[Val((cAliasSQL)->Z50_STATUS)],;
            Alltrim((cAliasSQL)->Z50_NOTA),;
            DToC(SToD((cAliasSQL)->Z50_EMISSAO)),;
            Alltrim((cAliasSQL)->Z50_CODCLI),;
            Alltrim((cAliasSQL)->Z50_LOJCLI),;
            Alltrim(Posicione("SA1",1,xFilial("SA1")+Alltrim((cAliasSQL)->Z50_CODCLI),"A1_NREDUZ")),;
            Alltrim((cAliasSQL)->Z50_PROD),;
            Alltrim(Posicione("SB1",1,xFilial("SB1")+(cAliasSQL)->Z50_PROD,"B1_DESC")),;
            Alltrim(Transform((cAliasSQL)->Z50_QUANT,"@E 999,999,999.99")),;
            Alltrim(Transform((cAliasSQL)->Z50_PRECO,"@E 999,999,999.99")),;
            RobToDef(3,(cAliasSQL)->Z50_OPCTRC),;
            RobToDef(1,(cAliasSQL)->Z50_DEFEIT),;
            RobToDef(2,(cAliasSQL)->Z50_TPDEFE),;
            (cAliasSQL)->Z50_OBSATD,;
        })
        (cAliasSQL)->(DbSkip())
    EndDo

    DbSelectArea((cAliasSQL))
    
    If Len(aList0) < 1
        cQuery := "SELECT TOP 1 COALESCE(CAST(CAST(Z50_OBSATD AS VARBINARY(8000)) AS VARCHAR(8000)),' ') AS Z50_OBSATD,Z50.*,Z52.*" 
        cQuery += " FROM "+RetSQLName("Z50")+" Z50" 
        cQuery += " INNER JOIN "+RetSQLName("Z52")+" Z52 ON Z52_DOC=Z50_NOTA"
        cQuery += "     AND Z52_CLIENT=Z50_CODCLI"
        cQuery += "     AND Z52_LOJA=Z50_LOJCLI"
        cQuery += "     AND Z52.D_E_L_E_T_=' '"
        cQuery += " WHERE  Z50.D_E_L_E_T_=' '"
        cQuery += "     AND Z50_NOTA='"+Z50->Z50_NOTA+"' "
        cQuery += "     AND Z50_CODCLI='"+Z50->Z50_CODCLI+"' "
        cQuery += "     AND Z50_LOJCLI='"+Z50->Z50_LOJCLI+"'

        If Select((cAliasSQL)) > 0
            (cAliasSQL)->(DBCloseArea())
        EndIF 

        cQuery := ChangeQuery(cQuery)

        MPSysOpenQuery(cQuery,cAliasSQL)

        While (cAliasSQL)->(!EoF())

            /*If Empty(cVend1)
                cVend1 := Alltrim((cAliasSQL)->C5_VEND1)
            EndIf*/

            Aadd(aList0,{;
                Alltrim((cAliasSQL)->Z50_CODIGO),;
                DToC(SToD((cAliasSQL)->Z50_DTCRIA)),;
                Alltrim((cAliasSQL)->Z50_HRCRIA),;
                aStatus[Val((cAliasSQL)->Z50_STATUS)],;
                Alltrim((cAliasSQL)->Z50_NOTA),;
                DToC(SToD((cAliasSQL)->Z50_EMISSAO)),;
                Alltrim((cAliasSQL)->Z50_CODCLI),;
                Alltrim((cAliasSQL)->Z50_LOJCLI),;
                Alltrim(Posicione("SA1",1,xFilial("SA1")+Alltrim((cAliasSQL)->Z50_CODCLI),"A1_NREDUZ")),;
                Alltrim((cAliasSQL)->Z50_PROD),;
                Alltrim(Posicione("SB1",1,xFilial("SB1")+(cAliasSQL)->Z50_PROD,"B1_DESC")),;
                Alltrim(Transform((cAliasSQL)->Z50_QUANT,"@E 999,999,999.99")),;
                Alltrim(Transform((cAliasSQL)->Z50_PRECO,"@E 999,999,999.99")),;
                RobToDef(3,(cAliasSQL)->Z50_OPCTRC),;
                RobToDef(1,(cAliasSQL)->Z50_DEFEIT),;
                RobToDef(2,(cAliasSQL)->Z50_TPDEFE),;
                (cAliasSQL)->Z50_OBSATD,;
            })
            (cAliasSQL)->(DbSkip())
            lZ52 := .T.
        EndDo

        DbSelectArea((cAliasSQL))
    EndIf 

    If Len(aList0) > 0

        DbSelectArea("SA1")
        SA1->(DbSetOrder(1))
        SA1->(DbSeek(xFilial("SA1")+(cAliasSQL)->Z50_CODCLI+(cAliasSQL)->Z50_LOJCLI))

        If !lZ52
            DbSelectArea("SC6")
            SC6->(DbSetOrder(1))
            SC6->(DbSeek((cAliasSQL)->C5_FILIAL+(cAliasSQL)->C5_NUM))
        EndIf 


        If Len(aList0) > 0

            oDlg1  := MSDialog():New( 086,213,756,1508,"Atender Chamados de Garantia",,,.F.,,,,,,.T.,,,.T. )
            oGrp1  := TGroup():New( 004,008,120,632,"Observações para atendimento",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

            oMGet1 := TMultiGet():New( 012,012,{|u| Alltrim(aList0[1,17]) },oGrp1,316,100,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.T.,,,.F.,,  )
            oMGet2 := TMultiGet():New( 012,332,{|u| If(PCount()>0,cMsgNew:=u,cMsgNew) },oGrp1,292,100,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )

            oGrp2  := TGroup():New( 124,008,308,632,"Dados Pedido x Dados do Cliente",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
            oFld1  := TFolder():New( 132,012,{"Dados do Chamado","Informações cadastrais"},{},oGrp2,,,,.T.,.F.,616,172,)

            oList0 := TCBrowse():New(004,004,600,143,,;
            {'Chamado','Data Chamado','Hora Chamado','Status','Nota','Emissao Nota','Cod Cliente','Loja Cliente',;
                'Nome Cliente','Produto','Descricao','Quantidade','Valor','Opcao Troca','Defeito','Tipo Defeito'},;
                    {35,35,35,35,35,35,35,35,60,35,60,35,35,35,35,35},oFld1:aDialogs[1],,,,{|| },{|| },,,,,,,.F.,,.T.,,.F.,,,)
            
            oList0:SetArray(aList0)
            oList0:bLine := {||{;
                aList0[oList0:nAt,01],;
                aList0[oList0:nAt,02],;
                aList0[oList0:nAt,03],;
                aList0[oList0:nAt,04],;
                aList0[oList0:nAt,05],;
                aList0[oList0:nAt,06],;
                aList0[oList0:nAt,07],;
                aList0[oList0:nAt,08],;
                aList0[oList0:nAt,09],;
                aList0[oList0:nAt,10],;
                aList0[oList0:nAt,11],;
                aList0[oList0:nAt,12],;
                aList0[oList0:nAt,13],;
                aList0[oList0:nAt,14],;
                aList0[oList0:nAt,15],;
                aList0[oList0:nAt,16];
            }}
            
            oSay1  := TSay():New( 008,008,{||"Razão Social / Nome Fantasia"},oFld1:aDialogs[2],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,008)
            oSay2  := TSay():New( 008,088,{||SA1->A1_NOME},oFld1:aDialogs[2],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,248,008)
            oSay3  := TSay():New( 008,348,{||SA1->A1_NREDUZ},oFld1:aDialogs[2],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,256,008)
            oSay4  := TSay():New( 028,008,{||"Endereço"},oFld1:aDialogs[2],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
            oSay5  := TSay():New( 028,088,{||SA1->A1_END},oFld1:aDialogs[2],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,256,008)
            oSay6  := TSay():New( 028,348,{||SA1->A1_BAIRRO},oFld1:aDialogs[2],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,092,008)
            oSay7  := TSay():New( 028,452,{||SA1->A1_MUN},oFld1:aDialogs[2],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,104,008)
            oSay8  := TSay():New( 028,572,{||SA1->A1_EST},oFld1:aDialogs[2],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
            oSay9  := TSay():New( 052,008,{||"Email"},oFld1:aDialogs[2],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
            oSay10 := TSay():New( 052,088,{||SA1->A1_EMAIL},oFld1:aDialogs[2],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,256,008)
            oSay11 := TSay():New( 052,348,{||"Telefones"},oFld1:aDialogs[2],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
            oSay12 := TSay():New( 052,400,{||SA1->A1_DDD+'-'+SA1->A1_TEL+" / "+SA1->A1_XDDD+'-'+SA1->A1_XTELEFO},oFld1:aDialogs[2],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,204,008)
            oSay13 := TSay():New( 076,008,{||"Endereço de Entrega"},oFld1:aDialogs[2],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,076,008)
            oSay14 := TSay():New( 076,088,{||SA1->A1_ENDENT},oFld1:aDialogs[2],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,260,008)
            oSay15 := TSay():New( 076,348,{||SA1->A1_BAIRROE+SA1->A1_MUNE},oFld1:aDialogs[2],,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,256,008)

            oBtn1 := TButton():New( 312,212,"Atender",oDlg1,{|| fGrvStatus(Val((cAliasSQL)->Z50_STATUS))},037,012,,,,.T.,,"",,,,.F. )
            oBtn2 := TButton():New( 312,296,"Cancelar",oDlg1,{|| oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )
            oBtn3 := TButton():New( 312,380,"Imagens Enviadas",oDlg1,{|| Processa( {||  U_fAbreImg(Z50->Z50_CODIGO) }, "Processando Imagens..." )},050,012,,,,.T.,,"",,,,.F. )

            oDlg1:Activate(,,,.T.)
        EndIf
    EndIf

Return


/*/{Protheus.doc} fGrvStatus
    @description Realiza a gravaçao dos Status ao atender um chamado
    @type User Function
    @author Felipe Mayer
    @since 30/09/2022
/*/
Static Function fGrvStatus(nStatus)

Default nStatus := 1

Local lAtStat:= .F.
Local aRetPed:= {}
Local aStatus:= {'1=Aberto','2=Atendido','3=Negado','4=Aguardando'}
Local cProd  := Space(TamSX3('B1_COD')[01])
Local aParam := {{ 2, "Status Chamado",nStatus,aStatus,60,, .T. },;
                 { 1, "Produto Troca",  cProd,  "@!", ".T.", "SB1", ".T.", 80,  .F.}}

    If Empty(cMsgNew)
        MsgAlert('Necessário preencher o campo de observações!')
        Return
    EndIf

    If nStatus == 2
        MsgAlert('Chamado já foi atendido anteriormente, consulte as observações!')
        Return
    EndIf

    If ParamBox(aParam, "Atender Chamado")
        cPar1 := Iif(ValType(MV_PAR01) == 'N',MV_PAR01,Val(MV_PAR01))
        cPar2 := upper(Alltrim(MV_PAR02))

        If cPar1 == nStatus
            MsgInfo('Necessário atualizar o Status do Atendimento')
        Else
            If cPar1 == 2 .And. Empty(cPar2)
                MsgInfo('Necessário selecionar produto para troca!')
            Else
                cObsOld := Alltrim(Z50->Z50_OBSATD)+CRLF+'-------------'

                cMsgGrv := 'Data '+cvaltochar(dDatabase)+' Hora '+cvaltochar(time())+CRLF
                cMsgGrv += 'Usuário '+cUserName+CRLF 
                cMsgGrv += 'Status selecionado '+aStatus[cPar1]+CRLF
                cMsgGrv += 'Observações anotadas '+cMsgNew

                If cPar1 == 2
                    If Empty(Z50->Z50_PEDVEN)
                        Processa({|| aRetPed := fGeraPV(cPar2,If(Z50->Z50_FILPED=='0102','0101',Z50->Z50_FILPED))}, "Gerando Pedido de Vendas...")
                        lAtStat := aRetPed[1]
                    else
                        lAtStat := .T.
                    EndIF 

                ElseIf cPar1 == 3
                    MsgInfo('Atendimento Negado pelo atendente!')
                    lAtStat := .T.

                ElseIf cPar1 == 1 .or. cPar1 == 4
                    MsgInfo('Atendimento em aberto!')
                    lAtStat := .T.
                EndIf
                
                If lAtStat
                    RecLock('Z50', .F.)
                        Z50->Z50_STATUS := If(cPar1 == 4,'1',cValToChar(cPar1))
                        Z50->Z50_OBSATD := cObsOld + CRLF + Alltrim(cMsgGrv)
                        Z50->Z50_ATENDE := cUserName
                        //Z50->Z50_FILPED := aRetPed[3]

                        If cPar1 == 2 .And. len(aRetPed) > 0
                            Z50->Z50_PEDVEN := aRetPed[2]
                        EndIf
                    Z50->(MsUnlock())

                    nHandle := FCREATE('\updchamados\chamado_'+Alltrim(Z50->Z50_CODIGO)+'\notification.txt')

                    If nHandle = -1
                        conout("Erro ao criar arquivo - ferror " + Str(Ferror()))
                    Else
                        FWrite(nHandle, 'atualizou')
                        FClose(nHandle)
                    Endif
                EndIf

                oDlg1:end()
            EndIf
        EndIf
    EndIf

Return


/*/{Protheus.doc} ENCERCHM
    @description Responsavel por finalizar o chamado
    @type User Function
    @author Felipe Mayer
    @since 30/09/2022
/*/
User Function ENCERCHM()

Local lEncerra:= .F.
Local aStatus := {'1=Aberto','2=Atendido','3=Negado','4=Aguardando'}
Local cStatus := ''
Local cMsgGrv := ''
Local cObsOld := ''
Local cSeq3   := 0
Local cNFAtend := ''

Local cMultG := ""
Local oTMultiget,oTButton1,oSay1,oSay2,oSay3,oSay4
Local cMsgFin := 'Os produtos enviados via chamado, realmente possuem defeito de fabricação?'
Local cMsgFin2:= 'Caso não atendam a política de garantia, será gerado um título financeiro para o cliente.'
Local aItems:= {'Atende','Não atende'}

    cStatus := Z50->Z50_STATUS

    If cStatus == '4'
        MsgAlert('Pedido já foi finalizado.')
        Return
    EndIf

    cObsOld := Alltrim(Z50->Z50_OBSATD)+CRLF+'-------------'

    cMsgGrv := 'Data: '+cvaltochar(dDatabase)+' Hora '+cvaltochar(time())+CRLF
    cMsgGrv += 'Usuário: '+cUserName+CRLF
    cMsgGrv += 'Ultimo Status: '+ aStatus[Val(cStatus)]+CRLF

    If cStatus == '2'

        DEFINE DIALOG oDlg TITLE "Finalizar Atendimento" FROM 180, 180 TO 520, 750 PIXEL

            oSay1 := TSay():New(006, 003, {|| cMsgFin },oDlg,"",TFont():New("Arial",,-16),,,,.T.,RGB(031,073,125),,300,30,,,,,,.F.,,)
            oSay2 := TSay():New(024, 003, {|| cMsgFin2},oDlg,"",TFont():New("Arial",,-16),,,,.T.,RGB(031,073,125),,300,30,,,,,,.F.,,)
            oSay3 := TSay():New(060, 003, {|| 'Escreva a justificativa:'},oDlg,"",TFont():New("Arial",,-18,,.T.),,,,.T.,RGB(031,073,125),,200,30,,,,,,.F.,,)
            oSay4 := TSay():New(153, 053, {|| 'política de garantia'},oDlg,"",TFont():New("Arial",,-12,,.T.),,,,.T.,RGB(031,073,125),,200,30,,,,,,.F.,,)

            oTMultiget := TMultiget():Create(oDlg,{|u|if(pCount()>0,cMultG:=u,cMultG)},72,03,280,72,,,,,,.T.)

            cCombo1 := aItems[1]    
            oCombo1 := TComboBox():New(150,03,{|u|if(PCount()>0,cCombo1:=u,cCombo1)}, aItems,48,20,oDlg,,{|| },,RGB(031, 073, 125),,.T.,TFont():New("Arial",,-12,,.T.),,,,,,,,'cCombo1')
            
            //Valor a cobrar de frete
            oSay5 := TSay():New(153, 125, {|| 'Frete'},oDlg,"",TFont():New("Arial",,-12,,.T.),,,,.T.,RGB(031,073,125),,200,30,,,,,,.F.,,)
            oFrete	:= TGet():New( 150,140,{|u| If(PCount()>0,cSeq3:=u,cSeq3)},oDlg,044,008,'@E 9,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	
            oTButton1 := TButton():New(150,242,"Confirmar",oDlg,{||oDlg:end()},40,15,,TFont():New("Arial",,-12,,.T.),.F.,.T.,.F.,,.F.,,,.F.)
        
        ACTIVATE DIALOG oDlg CENTERED

        cNFAtend := Posicione("SC5",1,If(Z50->Z50_FILPED<>"0102",Z50->Z50_FILPED,'0101')+Z50->Z50_PEDVEN,"C5_NOTA")
    
        If Empty(cNFAtend)
            lEncerra := .F.
            MsgAlert("Não é possível encerrar o chamado ainda pois a nota fiscal para atender o cliente ainda não foi emitida")
            RETURN
        EndIf 
        
        If !Empty(cMultG)
            If cCombo1 == 'Atende'
                lEncerra := .T.
            Else
                Processa({|| lEncerra := fGeraTit(cSeq3)}, "Gerando Titulo no Financeiro...")
            EndIf

            If lEncerra
                cMsgGrv += 'Justificativa: '+cMultG+CRLF
            EndIf
        Else
            MsgAlert('Obrigatório inserir a justificativa', 'ENCERCHM')
        EndIf

    ElseIf cStatus == '3'
        If MsgYesNo('Esse chamado foi negado anteriormente, deseja mesmo encerrar?', 'ENCERCHM')
            lEncerra := .T.
        EndIf

    Else
        MsgAlert('Não é possível finalizar um chamado em aberto. Por favor, verifique as etapas de atendimento.')
    EndIf

    

    If lEncerra
        MsgInfo('Chamado Finalizado!')

        cMsgGrv += 'Chamado Finalizado'

        RecLock('Z50', .F.)
        Z50->Z50_STATUS := '4'
        Z50->Z50_OBSATD := cObsOld + CRLF + Alltrim(cMsgGrv)
        Z50->Z50_NFATEN := cNFAtend
        Z50->(MsUnlock())
    Else
        MsgAlert('Operação Cancelada!')
    EndIf

Return



/*/{Protheus.doc} fGeraPV
    @description Gera Pedido de Vendas
    @type Static Function
    @author Felipe Mayer
    @since 01/10/2022
/*/
Static Function fGeraPV(cProd,cFilPv)

Local cDoc       := '' //GetSxeNum("SC5", "C5_NUM")
Local cA1Cod     := PadR(Z50->Z50_CODCLI,TamSX3("C5_CLIENTE")[1])   // Código do Cliente
Local cA1Loja    := PadR(Z50->Z50_LOJCLI,TamSX3("C5_LOJACLI")[1])   // Loja do Cliente
Local cB1Cod     := PadR(cProd,TamSX3("B1_COD")[1])                 // Código do Produto
Local cF4TES     := SuperGetMV('MV_TESGAR',.F.,"501")               // Código do TES
Local cE4Codigo  := SuperGetMV('MV_CNDGAR',.F.,"001")               // Código da Condição de Pagamento
Local cNaturez   := SuperGetMV('MV_NATPGAR',.F.,"11010001")
Local aCabec     := {}
Local aItens     := {}
Local aLinha     := {}
Local lRet       := .T. 
//Local cFilRet    := ''

Private lMsErroAuto    := .F.
Private lAutoErrNoFile := .F.
 
cFilant    := cFilPv
cDoc       := GetSxeNum("SC5", "C5_NUM")

aadd(aCabec, {"C5_FILIAL",     cFilant,      Nil})
aadd(aCabec, {"C5_NUM",     cDoc,      Nil})
aadd(aCabec, {"C5_TIPO",    "N",       Nil})
aadd(aCabec, {"C5_XCHAMAD", Z50->Z50_CODIGO,Nil})
aadd(aCabec, {"C5_XCLASPV", "P",       Nil})
aadd(aCabec, {"C5_CLIENTE", cA1Cod,    Nil})
aadd(aCabec, {"C5_LOJACLI", cA1Loja,   Nil})
aadd(aCabec, {"C5_LOJAENT", cA1Loja,   Nil})
aadd(aCabec, {"C5_CONDPAG", cE4Codigo, Nil})
aadd(aCabec, {"C5_TIPOCLI", "F",       Nil})
aadd(aCabec, {"C5_NATUREZ", PadR(cNaturez,TamSX3("C5_NATUREZ")[1]),Nil})
aadd(aCabec, {"C5_VEND1",   '000001',Nil}) //PadR(cVend1,TamSX3("C5_VEND1")[1])

aadd(aLinha,{"C6_FILIAL",   cFilant ,           Nil})
aadd(aLinha,{"C6_ITEM",   '01',           Nil})
aadd(aLinha,{"C6_PRODUTO",cB1Cod,         Nil})
aadd(aLinha,{"C6_QTDVEN", 1,              Nil})
aadd(aLinha,{"C6_PRCVEN", Z50->Z50_PRECO, Nil})
aadd(aLinha,{"C6_PRUNIT", Z50->Z50_PRECO, Nil})
aadd(aLinha,{"C6_VALOR",  Z50->Z50_PRECO, Nil})
aadd(aLinha,{"C6_TES",    cF4TES,         Nil})
aadd(aItens, aLinha)

MSExecAuto({|a, b, c, d| MATA410(a, b, c, d)}, aCabec, aItens, 3, .F.)

If !lMsErroAuto
    MsgInfo("Pedido de Vendas gerado com sucesso! <b>" + cDoc + "</b>")
    //cFilRet := SC5->C5_FILIAL 
    ConfirmSX8()
Else
    lRet := .F.
    cDoc := ''
    //cFilRet := ''

    RollbackSX8()
    If MsgYesNo('Erro ao gerar o pedido de vendas, deseja visualizar?')
        MostraErro()
    EndIf
EndIf


Return {lRet,cDoc}



/*/{Protheus.doc} fGeraTit
    @description Gera titulo no financeiro Contas a Receber
    @type Static Function
    @author Felipe Mayer
    @since 01/10/2022
/*/
Static Function fGeraTit(cSeq3)

Local aVetSE1 := {}
Local lRet    := .T.
Local cHist   := SuperGetMV('MV_HSTGAR',.F.,'Fora da politica de garantia')
Local nVenc   := SuperGetMV('MV_VNCGAR',.F.,10)
Local cTipo   := SuperGetMV('MV_TIPGAR',.F.,'BOL')
Local cNatu   := SuperGetMV('MV_NATGAR',.F.,'OUTROS')

    aAdd(aVetSE1, {"E1_FILIAL",  FWxFilial("SE1")                             , Nil})
    aAdd(aVetSE1, {"E1_NUM",     PadR(Z50->Z50_NOTA,TamSX3("E1_NUM")[1])      , Nil})
    aAdd(aVetSE1, {"E1_PREFIXO", 'GAR'                                        , Nil})
    aAdd(aVetSE1, {"E1_TIPO",    PadR(cTipo,TamSX3("E1_TIPO")[1])             , Nil})
    aAdd(aVetSE1, {"E1_PARCELA", Z50->Z50_ITEM                                , Nil})
    aAdd(aVetSE1, {"E1_NATUREZ", PadR(cNatu,TamSX3("E1_NATUREZ")[1])          , Nil})
    aAdd(aVetSE1, {"E1_CLIENTE", PadR(Z50->Z50_CODCLI,TamSX3("E1_CLIENTE")[1]), Nil})
    aAdd(aVetSE1, {"E1_LOJA",    PadR(Z50->Z50_LOJCLI,TamSX3("E1_LOJA")[1])   , Nil})
    aAdd(aVetSE1, {"E1_EMISSAO", dDataBase                                    , Nil})
    aAdd(aVetSE1, {"E1_VENCTO",  dDataBase+nVenc                              , Nil})
    aAdd(aVetSE1, {"E1_VENCREA", dDataBase+nVenc                              , Nil})
    aAdd(aVetSE1, {"E1_VALOR",   Z50->Z50_PRECO+cSeq3                         , Nil})
    aAdd(aVetSE1, {"E1_HIST",    Alltrim(cHist)+" - CHAMADO "+Z50->Z50_CODIGO , Nil})
    aAdd(aVetSE1, {"E1_MOEDA",   1                                            , Nil})
    
    Begin Transaction
        lMsErroAuto := .F.
        MSExecAuto({|x,y| FINA040(x,y)}, aVetSE1, 3)
        
        If lMsErroAuto
            lRet := .F.
            DisarmTransaction()

            If MsgYesNo('Erro ao gerar titulo financeiro, deseja visualizar?')
                MostraErro()
            EndIf
        EndIf
    End Transaction

Return lRet


/*/{Protheus.doc} RobToDef
    @description Controle de Legendas de Tipo de Defeito
    @type Static Function
    @author Felipe Mayer
    @since 01/10/2022
/*/
Static Function RobToDef(nIndex,cProp)

Local cRet := ''

// 1-Defeito / 2-Tipo Defeito / 3-OpcTroca
If nIndex == 1
	If cProp == '1'
		cRet := 'Frontal'
	ElseIf cProp == '2'
		cRet := 'Hastes'
	ElseIf cProp == '3'
		cRet := 'Charneiras'
	ElseIf cProp == '4'
		cRet := 'Lentes'
	EndIf
ElseIf nIndex == 2
	If cProp == 'A'
		cRet := 'DESCASCANDO'
	ElseIf cProp == 'B'
		cRet := 'TRINCADO'
	ElseIf cProp == 'C'
		cRet := 'OXIDAÇÃO'
	ElseIf cProp == 'D'
		cRet := 'RISCADA'
	ElseIf cProp == 'E'
		cRet := 'QUEBRADA'
	ElseIf cProp == 'F'
		cRet := 'QUEBRADA NA SOLDA'
	ElseIf cProp == 'G'
		cRet := 'SOLTA'
	ElseIf cProp == 'H'
		cRet := 'PARAFUSO ESPANADO'
	ElseIf cProp == 'I'
		cRet := 'DEFEITO NA PONTEIRA'
	ElseIf cProp == 'J'
		cRet := 'TONALIDADES DIFERENTES'
	ElseIf cProp == 'L'
		cRet := 'MANCHADA'
	ElseIf cProp == 'M'
		cRet := 'DEFEITO NA MOLA'
	ElseIf cProp == 'N'
		cRet := 'SUPORTE DE PLAQUETAS'
	EndIf
Else
    If cProp == '1'
		cRet := 'Troca Tudo'
	ElseIf cProp == '2'
		cRet := 'Troca Peças'
    EndIf
EndIf


Return cRet


/*/{Protheus.doc} User Function _xEspelho
    (long_description)
    @type  Function
    @author user
    @since 09/03/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function _xEspelho(cNota,cFilNf)
    
Local aArea     :=  GetArea()
Local cPastaS  	:= '\clientes\cnpj\'
Local cPastaL   :=  'C:\Espelho_NF\'
Local ccnpj     :=  ''

DbSelectArea("SF2")
DbSetOrder(1)
If Dbseek(cFilNf+cNota)
    ccnpj := Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_CGC")
    
    If File(cPastaS+ccnpj+'\'+cNota+'.pdf')
        If !ExistDir(cPastaL)
            Makedir(cPastaL)
        EndIf
        CPYS2T(cPastaS+ccnpj+'\'+cNota+'.pdf',cPastaL)
        WinExec('Explorer.exe /select,"' + cPastaL+cNota+'.pdf' + '"', 1)
    else
        u_ROBDANFE(SF2->F2_DOC, SF2->F2_SERIE, cPastaS, ccnpj)
        If File(cPastaS+ccnpj+'\'+cNota+'.pdf')
            If !ExistDir(cPastaL)
                Makedir(cPastaL)
            EndIf
            CPYS2T(cPastaS+ccnpj+'\'+cNota+'.pdf',cPastaL)
            WinExec('Explorer.exe /select,"' + cPastaL+cNota+'.pdf' + '"', 1)
        EndIf
    EndIf 
else
    MsgAlert("Nota fiscal não encontrada")
endIf 

RestArea(aArea)

Return
