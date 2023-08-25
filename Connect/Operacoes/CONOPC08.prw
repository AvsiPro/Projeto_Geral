#INCLUDE 'PROTHEUS.CH'


//|Status das OS|



/*/{Protheus.doc} User Function nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 08/08/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function CONOPC08()

Local aDados := {}

Private aStatOS := {}

Aadd(aStatOS,{"DESP","Despachado"})
Aadd(aStatOS,{"ACTE","Recebido pelo Agente"})
Aadd(aStatOS,{"INIC","Iniciado"})
Aadd(aStatOS,{"CTEC","Cancelado pelo Agente"})
Aadd(aStatOS,{"COPE","Cancelado pelo Atendente"})
Aadd(aStatOS,{"CCLI","Cancelado pelo cliente"})
Aadd(aStatOS,{"FIOK","Finalizado OK"})
Aadd(aStatOS,{"AGEN","Agendado"})
Aadd(aStatOS,{"TACM","Agente a caminho"})

IF Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","0101")
ENDIF

//Busca chamados
aDados := Busca()
//Tela de acompanhamento
tela(aDados)

Return

/*/{Protheus.doc} Busca
    (long_description)
    @type  Static Function
    @author user
    @since 08/08/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Busca()

Local aRet      :=  {}
Local cQuery    :=  ""
Local aDadosWS  :=  {}
Local aOsGoon   :=  {}
Local aAux      :=  {}
Local cResult   :=  ''
Local cError    :=  ''
Local cWarning  :=  ''
Local nCont

Aadd(aDadosWS,'1AD4457221B86EDD00007A96EA7D9EBB58C1702A')
Aadd(aDadosWS,'Q64E8XIJ6NV4F1KGU3I1')

cQuery := "SELECT AB2_NRCHAM,AB2_XOS,AB2_CODCLI,AB2_LOJA,A1_NREDUZ,AB2_EMISSA,AB2_XCBASE,AB2_XTEC,AA1_NOMTEC,B1_DESC"
cQuery += " FROM "+RetSQLName("AB2")+" AB2"
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=AB2_CODCLI AND A1_LOJA=AB2_LOJA AND A1.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=AB2_CODPRO AND B1.D_E_L_E_T_=' '"
cQuery += " LEFT JOIN "+RetSQLName("AA1")+" AA1 ON AA1_FILIAL=AB2_FILIAL AND AA1_CODTEC=AB2_XTEC AND AA1.D_E_L_E_T_=' '"
cQuery += " WHERE AB2.D_E_L_E_T_=' '"
cQuery += " AND AB2_XOS<>' ' AND AB2_STATUS='A'"

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf
  
MemoWrite("CONOPC08.SQL",cQuery)

cQuery:= ChangeQuery(cQuery)

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)   

DbSelectArea("TRB")

While !EOF()
    If Ascan(aOsGoon,{|x| x == val(TRB->AB2_XOS)}) == 0
        Aadd(aOsGoon,val(TRB->AB2_XOS))
    EndIf 

    Aadd(aRet,{TRB->AB2_NRCHAM,;
                TRB->AB2_XOS,;
                TRB->AB2_CODCLI,;
                TRB->AB2_LOJA,;
                Alltrim(TRB->A1_NREDUZ),;
                STOD(TRB->AB2_EMISSA),;
                TRB->AB2_XCBASE,;
                TRB->AB2_XTEC,;
                TRB->AA1_NOMTEC,;
                Alltrim(TRB->B1_DESC),;
                "",;
                "",;
                ""})
    Dbskip()
EndDo 

Aadd(aDadosWS,aOsGoon)

cResult := U_WSKPC006(aDadosWS)
FWJsonDeserialize(cResult, @aAux)
        
oXml := XmlParser( aAux:ANSWERSXML, "_", @cError, @cWarning )

If oXml <> Nil
    If valtype(oXml:_FormAnswers:_FormAnswer) == "A"
        For nCont := 1 to len(oXml:_FormAnswers:_FormAnswer)
            cNumOs := oXml:_FormAnswers:_FormAnswer[nCont]:_NUMEROOS:TEXT
            aSequencia := oXml:_FormAnswers:_FormAnswer[nCont]:_STATUSSEQUENCE:_STATUSINFO
            If len(aSequencia) > 0
                nPos := Ascan(aRet,{|x| VAL(x[2]) == val(cNumOs)})
                If nPos > 0
                    aRet[nPos,11] := aSequencia[len(aSequencia)]:_STATUS:TEXT
                    aRet[nPos,12] := aSequencia[len(aSequencia)]:_DATAHORA:TEXT
                    aRet[nPos,13] := aSequencia
                EndIf
            Endif
        Next nCont
    ElseIf valtype(oXml:_FormAnswers:_FormAnswer) = "O"
    EndIf
Endif

Return(aRet)

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 08/08/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function tela(aDados)

Local nCont := 0    
Private oDlg1,oGrp1,oBtn1,oList1
Private aList1 := {}

For nCont := 1 to len(aDados)
    Aadd(aList1,aDados[nCont])
Next nCont

If len(aList1) > 0
    oDlg1      := MSDialog():New( 092,232,662,1209,"Protheus x Goon",,,.F.,,,,,,.T.,,,.T. )
    oGrp1      := TGroup():New( 004,008,256,476,"Status das Ordens de Serviços",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
    //oBrw1      := MsSelect():New( "","","",{{"","","Title",""}},.F.,,{012,012,252,472},,, oGrp1 ) 
    //AB2_NRCHAM,AB2_XOS,AB2_CODCLI,AB2_LOJA,A1_NREDUZ,AB2_EMISSA,AB2_XCBASE,AB2_XTEC,AA1_NOMTEC,B1_DESC
    oList1 := TCBrowse():New(012,012,460,240,, {'Status','Hora_status','Chamado','OS Goon','Cliente','Data','Patrimonio','Tecnico','Modelo'},;
                                {30,30,40,30,80,30,30,60,80},;
                                oGrp1,,,,{|| /*FHelp(oList1:nAt)*/},{|| editcol(oList1:nAt) },, ,,,  ,,.F.,,.T.,,.F.,,,)                          
    oList1:SetArray(aList1)
    oList1:bLine := {||{aList1[oList1:nAt,11],;
                        aList1[oList1:nAt,12],;
                        aList1[oList1:nAt,01],; 
                        aList1[oList1:nAt,02],;
                        aList1[oList1:nAt,05],;
                        aList1[oList1:nAt,06],;
                        aList1[oList1:nAt,07],;
                        aList1[oList1:nAt,09],;
                        aList1[oList1:nAt,10]}}

    oBtn1      := TButton():New( 260,200,"Sair",oDlg1,{|| oDlg1:end()},037,012,,,,.T.,,"",,,,.F. )

    oDlg1:Activate(,,,.T.)
EndIF

Return

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 09/08/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function editcol(nLinha)
    
Local cText := ""
Local nCont := 0

If valtype(aList1[nLinha,13]) == "A"
    For nCont := 1 to len(aList1[nLinha,13])
        nPos := Ascan(aStatOS,{|x| Alltrim(x[1]) == Alltrim(UPPER(aList1[nLinha,13,nCont]:_STATUS:TEXT))})

        cText += aList1[nLinha,13,nCont]:_STATUS:TEXT + CRLF
        If nPos > 0
            cText += aStatOS[nPos,02] + CRLF
        EndIf 
        cText += aList1[nLinha,13,nCont]:_DATAHORA:TEXT + CRLF
    Next nCont
EndIf 

MsgAlert(cText)

Return
