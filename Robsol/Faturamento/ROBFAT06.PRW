#Include 'PROTHEUS.CH'
#Include 'RWMAKE.CH'
#Include 'FONT.CH'
#Include 'COLORS.CH'


/*/{Protheus.doc} ROBFAT06
    @long_description Tela de atendimento de chamados Robsol
    @type User Function
    @author Felipe Mayer
    @since 23/08/2022
    @version 1
/*/

User Function ROBFAT06()

Local aList0    := {}
Local aList1    := {}
Local cQuery    := ''
Local cAliasSQL := GetNextAlias()
Local aStatus   := {'Aberto','Atendido','Negado'}

Private cMsgNew   := space(1024)

SetPrvt("oDlg1","oGrp1","oGrp2","oFld1","oBtn1","oBtn2","oList0","oList1","oCombo1")
SetPrvt("oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oSay7","oSay8","oSay9","oSay10","oSay11","oSay12","oSay13","oSay14","oSay16","oSay17")

    cQuery := " SELECT TOP 1 * FROM "+RetSqlName('Z50')+" Z50 "
    cQuery += " INNER JOIN "+RetSqlName('SF2')+" SF2 "
    cQuery += "     ON F2_DOC=Z50_NOTA "
    cQuery += "     AND F2_CLIENTE=Z50_CODCLI "
    cQuery += "     AND F2_LOJA=Z50_LOJCLI "
    cQuery += "     AND SF2.D_E_L_E_T_='' "
    cQuery += " INNER JOIN "+RetSqlName('SC5')+" SC5  "
    cQuery += "     ON C5_FILIAL = F2_FILIAL "
    cQuery += "     AND C5_CLIENTE = F2_CLIENTE "
    cQuery += "     AND C5_LOJACLI = F2_LOJA "
    cQuery += "     AND C5_VEND1 = F2_VEND1 "
    cQuery += "     AND C5_NOTA = F2_DOC "
    cQuery += "     AND C5_SERIE = F2_SERIE "
    cQuery += "     AND C5_CONDPAG = F2_COND "
    cQuery += "     AND C5_TIPOCLI = F2_TIPOCLI "
    cQuery += "     AND C5_NOTA = F2_DOC "
    cQuery += "     AND C5_LOJAENT = F2_LOJENT "
    cQuery += "     AND SC5.D_E_L_E_T_='' "
    cQuery += " WHERE Z50.D_E_L_E_T_='' "
    cQuery += "     AND Z50_NOTA='"+Z50->Z50_NOTA+"' "
    cQuery += "     AND Z50_CODCLI='"+Z50->Z50_CODCLI+"' "
    cQuery += "     AND Z50_LOJCLI='"+Z50->Z50_LOJCLI+"'
	cQuery := ChangeQuery(cQuery)

	MPSysOpenQuery(cQuery,cAliasSQL)

    While (cAliasSQL)->(!EoF())

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
        })
        (cAliasSQL)->(DbSkip())
    EndDo

    DbSelectArea((cAliasSQL))
    DbGoTop()

    If Len(aList0) > 0

        DbSelectArea("SA1")
        SA1->(DbSetOrder(1))
        SA1->(DbSeek(xFilial("SA1")+(cAliasSQL)->C5_CLIENTE+(cAliasSQL)->C5_LOJACLI))

        DbSelectArea("SC6")
        SC6->(DbSetOrder(1))
        SC6->(DbSeek((cAliasSQL)->C5_FILIAL+(cAliasSQL)->C5_NUM))

        While SC6->(!EoF() .And. (cAliasSQL)->C5_FILIAL == SC6->C6_FILIAL .AND. (cAliasSQL)->C5_NUM == SC6->C6_NUM)
            Aadd(aList1,{SC6->C6_ITEM,SC6->C6_PRODUTO,SC6->C6_DESCRI,SC6->C6_QTDVEN,SC6->C6_PRCVEN,SC6->C6_VALOR,SC6->C6_DESCONT})
            SC6->(DbSkip())
        EndDo

        If Len(aList1) > 0

            oDlg1  := MSDialog():New( 086,213,756,1508,"Atender Chamados de Garantia",,,.F.,,,,,,.T.,,,.T. )
            oGrp1  := TGroup():New( 004,008,120,632,"Observações para atendimento",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )

            oMGet1 := TMultiGet():New( 012,012,{|u| Alltrim((cAliasSQL)->Z50_OBS) },oGrp1,316,100,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.T.,,,.F.,,  )
            oMGet2 := TMultiGet():New( 012,332,{|u| If(PCount()>0,cMsgNew:=u,cMsgNew) },oGrp1,292,100,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )

            oGrp2  := TGroup():New( 124,008,308,632,"Dados Pedido x Dados do Cliente",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
            oFld1  := TFolder():New( 132,012,{"Dados do Chamado","Informações cadastrais","Itens Pedido"},{},oGrp2,,,,.T.,.F.,616,172,)

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

            oList1 := TCBrowse():New(004,004,600,143,,{'Item','Codigo','Descricao','Qtd','Vlr Unit.','Valor Total','Desconto %'},;
                        {20,60,230,35,35,35,30},oFld1:aDialogs[3],,,,{|| },{|| },,,,,,,.F.,,.T.,,.F.,,,)
            
            oList1:SetArray(aList1)
            oList1:bLine := {||{;
                aList1[oList1:nAt,01],;
                aList1[oList1:nAt,02],;
                aList1[oList1:nAt,03],;
                aList1[oList1:nAt,04],;
                Transform(aList1[oList1:nAt,05],"@E 999,999,999.99"),;
                Transform(aList1[oList1:nAt,06],"@E 999,999,999.99"),;
                aList1[oList1:nAt,07];
            }}

            oBtn1 := TButton():New( 312,212,"Atender",oDlg1,{|| fGrvStatus(Val((cAliasSQL)->Z50_STATUS))},037,012,,,,.T.,,"",,,,.F. )
            oBtn2 := TButton():New( 312,296,"Cancelar",oDlg1,{|| oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )

            oDlg1:Activate(,,,.T.)
        EndIf
    EndIf

Return


Static Function fGrvStatus(nStatus)

Default nStatus := 1

Local aStatus:= {'1=Aberto','2=Atendido','3=Negado'}
Local cProd  := Space(TamSX3('B1_COD')[01])
Local aParam := {{ 2, "Status Chamado",nStatus,aStatus,60,, .T. },;
                 { 1, "Produto Troca",  cProd,  "", ".T.", "SB1", ".T.", 80,  .F.}}

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
        cPar2 := MV_PAR02

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

                RecLock('Z50', .F.)
                    Z50->Z50_STATUS := cValToChar(cPar1)
                    Z50->Z50_OBSATD := cObsOld + CRLF + Alltrim(cMsgGrv)
                Z50->(MsUnlock())

                If cPar1 == 2
                    Processa({|| fGeraPV()}, "Gerando Pedido de Vendas...")
                ElseIf cPar1 == 3
                    MsgInfo('Atendimento Negado pelo atendente!')
                ElseIf cPar1 == 1
                    MsgInfo('Atendimento em aberto!')
                EndIf

                oDlg1:end()
            EndIf
        EndIf
    EndIf

Return


Static Function fGeraPV()


Return


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
