#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} User Function nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 02/08/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function CONJOB01()

Local cQuery

Local cHri             :=   '00:00'
Local cHrf             :=   '23:59'
Local aAux             :=   {}
Local aVendas          :=   {}
Local dUltLei
Local dLeiFim
Local nX,nY
Local dDiaExe  
Local aList8           :=   {}
Local aMaqSVM          :=   {}

Private cArqHTML
Private cPathHTML
Private aList8B        :=   {}
PRIVATE cToken         :=    "yVXxnxgOExcIaBQOQ9CFgK0cLgX22dJct7y85WXW" //Token Connect Vending
PRIVATE oRestClient    :=    FWRest():New("http://vmpay.vertitecnologia.com.br")
PRIVATE aHeader        :=    {}

IF Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","0101")
ENDIF

cArqHTML    := "\workflow\Leituras_Salvas.html"
cPathHTML   := GetMV("MV_WFDIR") 


dDiaExe := strzero(day(ddatabase),2)

cQuery := "SELECT AAM_CONTRT,AAM_XDIALT,AAN_XCBASE,AAM_CODCLI,AAM_LOJA,AAN_ITEM,AAN_CODPRO,A1_TELEX"
cQuery += " FROM "+RetSQLName("AAN")+" AAN"
cQuery += " INNER JOIN "+RetSQLName("AAM")+" AAM ON AAM_FILIAL=AAN_FILIAL AND AAM_CONTRT=AAN_CONTRT"
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=AAM_CODCLI AND A1_LOJA=AAM_LOJA AND A1.D_E_L_E_T_=' '"
cQuery += "     AND AAM_XDIALT LIKE '%"+dDiaExe+"%'"
cQuery += " AND AAM_XDIALT<>' '"
cQuery += "     AND AAM.D_E_L_E_T_=' '"
cQuery += " WHERE AAN.D_E_L_E_T_=' ' AND AAN_XBOXVM='1'"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("CONFATC01.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    Aadd(aAux,{ TRB->AAM_CONTRT,;   //01
                TRB->AAM_XDIALT,;   //02
                TRB->AAN_XCBASE,;   //03
                TRB->AAM_CODCLI,;   //04
                TRB->AAM_LOJA,;     //05
                TRB->AAN_ITEM,;     //06
                TRB->AAN_CODPRO,;   //07
                "",;                //08
                "",;                //09
                "",;                //10
                TRB->A1_TELEX})     //11
    DbSkip()
EndDo 

If len(aAux) > 0

    //Busca Maquinas
    Maquinas()

    For nX := 1 to len(aAux)
        dUltLei := UltLei(aAux[nX,03])
        If Empty(dtos(dUltLei))
            dUltLei := ddatabase-30
        EndIf

        dLeiFim := ddatabase-1

        //Exemplo URL enviar ao cliente
        //https://vmpay.vertitecnologia.com.br/verti/reports/vends?
        //dataInicial=30/06/2023-00:00&dataFinal=01/08/2023-23:59&machine_id=36245
        /*
        aAux[nX,08] := "https://vmpay.vertitecnologia.com.br/verti/reports/vends?"
        aAux[nX,08] += "dataInicial="+cvaltochar(dUltLei)+"-"+cHri
        aAux[nX,08] += "&dataFinal="+cvaltochar(dLeiFim)+"-"+cHrf
        aAux[nX,08] += "&machine_id="+alltrim(aAux[nX,03])
        */

        //Novo Modelo disponbilizado pela vertis
        //https://vmpay.vertitecnologia.com.br/connect_vending_comercio_de_ma/c/
        // 35207/   - instalation
        //reports/vends?
        //vend[occurred_at]=custom&vend[occurred_at_end]=31/01/2023%2023:59
        //&vend[occurred_at_start]=01/01/2023%2000:00
        //&vend[groups][]=client
        //&vend[groups][]=location
        //&vend[groups][]=machine
        //&vend[groups][]=good
        nPosMaq := Ascan(aHeader,{|x| x[2] == Alltrim(aAux[nX,03])})

        If nPosMaq > 0
            aAux[nX,08] := "https://vmpay.vertitecnologia.com.br/connect_vending_comercio_de_ma/c/"
            //aAux[nX,08] += "%INSTALLATION%"
            //aAux[nX,08] += Alltrim(aHeader[nPosMaq,03])
            aAux[nX,08] += Alltrim(aAux[nX,11])
            aAux[nX,08] += "/reports/vends?"
            aAux[nX,08] += "vend[occurred_at]=custom&vend[occurred_at_end]="+cvaltochar(dLeiFim)+"%20"+cHrf
            aAux[nX,08] += "&vend[occurred_at_start]="+cvaltochar(dUltLei)+"%20"+cHri
            aAux[nX,08] += "&vend[groups][]=client"
            aAux[nX,08] += "&vend[groups][]=location
            aAux[nX,08] += "&vend[groups][]=machine
            aAux[nX,08] += "&vend[groups][]=good
            

            aAux[nX,09] := dUltLei
            aAux[nX,10] := dLeiFim

            //Aadd(aVendas, U_CONWSC03(aAux[nX,03],2,dUltLei,dLeiFim,cHri,cHrf))
            cDtCriac := Dtos(dUltLei)
            cDtCriac := substr(cDtCriac,1,4)+"-"+substr(cDtCriac,5,2)+"-"+substr(cDtCriac,7,2)
            // data/hora inicial de venda
            //cDtCriac += " 00:01:00"
            
            cDtCriac += "T" +cHri+"-03:00" //"00:00-03:00"
            
            cDtCria2 := Dtos(dLeiFim)
            cDtCria2 := substr(cDtCria2,1,4)+"-"+substr(cDtCria2,5,2)+"-"+substr(cDtCria2,7,2)
            // data/hora inicial de venda
            //cDtCriac += " 00:01:00"
            
            cDtCria2 += "T" +cHrf+"-03:00" //"00:00-03:00"

            Aadd(aVendas,Vendas(cDtCriac,aHeader[nPosMaq,01],nPosMaq,cDtCria2))
        EndIf
    Next nX
EndIf 


IF len(aVendas) > 0
    aList8B := {}
//'Data','Seleção','Produto','Descrição','Quant. Apont.',chapa,codigo cliente
    FOR nX := 1 TO len(aVendas) 
        aList8 := {}
        nPosAux := Ascan(aAux,{|x| alltrim(x[3])==alltrim(aVendas[nX,2])})
                
        If aVendas[nX] != NIL
            If len(aVendas[nX]) > 2
                        
                for nY := 4 to len(aVendas[nX])
                    cCodProt := ''
                    IF aVendas[nX,nY,05] == "null"
                        cCodProt := "Nao Consta"
                    ELSE
                        cCodProt := aVendas[nX,nY,05]
                    ENDIF
                    
                    if cCodProt != "Nao Consta"
                        cDesc := Posicione("SB1",1,xFilial("SB1")+cCodProt,"B1_DESC")
                    else
                        cDesc := "Codigo do produto nao se encontra no VMPay"
                    endif

                    nPosit := Ascan(aList8,{|x| x[2]+x[6] == aVendas[nX,nY,01]+alltrim(aVendas[nX,2])})
                    IF nPosit == 0
                        cData := ddatabase //stod(StrTran(SubStr(aVendas[nX,nY,02], 1, 10), '-')) //StrTran(StrTran(SubStr(aVendas[nX,nY,02], 1, 10), '-', '/'), 'T', ' ')
                        Aadd(aList8,{cvaltochar(cData),;
                                    aVendas[nX,nY,01],;
                                    cCodProt,;
                                    cDesc,;
                                    val(aVendas[nX,nY,03]),;
                                    aVendas[nX,2],;
                                    aAux[nPosAux,04],;
                                    IF(val(aVendas[nX,nY,03])>1,val(aVendas[nX,nY,04])/val(aVendas[nX,nY,03]),val(aVendas[nX,nY,04])),;
                                    aAux[nPosAux,01],;
                                    aAux[nPosAux,03],;
                                    aAux[nPosAux,05],;
                                    aAux[nPosAux,06],;
                                    aAux[nPosAux,07],;
                                    aAux[nPosAux,08],;
                                    aAux[nPosAux,09],;
                                    aAux[nPosAux,10]})
                    ELSE
                        aList8[nPosit,05] += val(aVendas[nX,nY,03])
                    ENDIF
                next nY
            EndIf
        EndIf 
        

        If len(aList8) > 0
            Aadd(aList8B, {})
            
            Aadd(aList8B[len(aList8B)], aList8)
        Else 
            Aadd(aMaqSVM,{aAux[nX,01],aAux[nX,03],aAux[nX,04],aAux[nX,05],aAux[nX,06]})
        EndIf 
    NEXT nX
    
ENDIF

savevend()

If len(aAux) > 0
    oHtml := TWFHtml():New( cArqHTML )

    oHTML:ValByName("DIA_LEITURA",ddatabase)

    cBodyLin := ""

    For nX := 1 to len(aAux)
        cStatus := ""
        If Ascan(aList8B,{|x| x[1,1,6] == Alltrim(aAux[nX,03])}) > 0
            cStatus := "OK"
        ElseIf Ascan(aMaqSVM,{|x| Alltrim(x[2]) == Alltrim(aAux[nX,03]) }) > 0
            cStatus := "Maquina sem venda"
        Else 
            cStatus := "Sem Comunicação"
        EndIf 

        cBodyLin += cHtmStatus()

        cBodyLin := strtran(cBodyLin,"!CONTRATO!",Alltrim(aAux[nX,01]))
        cBodyLin := strtran(cBodyLin,"!ATIVO!",Alltrim(aAux[nX,03]))
        cBodyLin := strtran(cBodyLin,"!STATUS!",cStatus)
        
    Next nX


    oHTML:ValByName("linhasPedido",cBodyLin)
    cMail := 'reports@connectvending.com.br' // pode ser obtido de um parâmetro
    
    cFileName    := CriaTrab(NIL,.F.) + ".htm"
    cFileName    := cPathHTML + "\" + cFileName 
    oHtml:SaveFile(cFileName)

    cRet         := WFLoadFile(cFileName)
    cMensagem    := StrTran(cRet,chr(13),"")
    cMensagem    := StrTran(cRet,chr(10),"")
    cMensagem    := OemtoAnsi(cMensagem)
    cSubject     := 'Job de Leituras diaria'

    lEmail := U_EnviarEmail(cMail,cSubject,cMensagem,'',.f.) 
    
EndIf  

Return


/*/{Protheus.doc} UltLei(aList[nX,02])
    (long_description)
    @type  Static Function
    @author user
    @since 11/01/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function UltLei(cAtivo)

Local aArea :=  GetArea()
Local cQuery 
Local dRet 

cQuery := "SELECT MAX(Z08_DATA) AS ULTIMA FROM "+RetSQLName("Z08")
cQuery += " WHERE Z08_FILIAL BETWEEN ' ' AND 'ZZ' AND D_E_L_E_T_=' '
cQuery += " AND Z08_NUMSER='"+cAtivo+"'"

if Select("TRB") > 0
    DBSELECTAREA("TRB")
    DBCLOSEAREA()
endif

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

dRet := stod(TRB->ULTIMA)

RestArea(aArea)

Return(dRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONFATC01   ºAutor  ³Microsiga           º Data ³  06/08/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC FUNCTION savevend()
    
LOCAL aArea        :=   GetArea()  
LOCAL aGravarP     :=   {} 
LOCAL cCod         
LOCAL cSeq         :=   "01" 
LOCAL nX   
LOCAL nY  
Local nZ 
Local cMes 
Local cAno

for nX := 1 to len(aList8B)

    cCod := GetSXENum("Z08", "Z08_COD") 
    cSeq := "01"

    For nY := 1 to len(aList8B[nX,1])
    
        aGravarP := {}
    //aContrato := {TRB->AAM_CONTRT,TRB->AAN_ITEM,TRB->AAM_CODCLI,TRB->AAM_LOJA,TRB->AAN_CODPRO}
        cMes := Strtokarr(aList8B[nX,01,nY,01], "/")[2]
        If len(Strtokarr(aList8B[nX,01,nY,01], "/")[3]) > 2
            cAno := SubStr(Strtokarr(aList8B[nX,01,nY,01], "/")[3],3,2)
        Else 
            cAno := Strtokarr(aList8B[nX,01,nY,01], "/")[3]
        EndIf 

        Aadd( aGravarP, {"Z08_FILIAL"  ,xFilial("Z08")})
        Aadd( aGravarP, {"Z08_COD"     ,cCod})
        Aadd( aGravarP, {"Z08_SEQUEN"  ,cSeq})
        Aadd( aGravarP, {"Z08_NUMSER"  ,aList8B[nX,01,nY,06]})
        Aadd( aGravarP, {"Z08_DATA"    ,ctod(aList8B[nX,01,nY,01])})
        Aadd( aGravarP, {"Z08_SELECA"  ,StrZero(val(aList8B[nX,01,nY,02]),3)})
        Aadd( aGravarP, {"Z08_PRODUT"  ,aList8B[nX,01,nY,03]})
        Aadd( aGravarP, {"Z08_CONTRT"  ,aList8B[nX,01,nY,09]})
        Aadd( aGravarP, {"Z08_ITEM"    ,aList8B[nX,01,nY,12]})
        Aadd( aGravarP, {"Z08_QTDLID"  ,aList8B[nX,01,nY,05]})
        Aadd( aGravarP, {"Z08_VLRLID"  ,aList8B[nX,01,nY,08]})
        Aadd( aGravarP, {"Z08_DTDIGIT" ,dDataBase}) 
        Aadd( aGravarP, {"Z08_PERIODO" ,cMes + cAno})
        Aadd( aGravarP, {"Z08_MAQUINA" ,aList8B[nX,01,nY,13]}) 
        Aadd( aGravarP, {"Z08_CODCLI"  ,aList8B[nX,01,nY,07]})  
        Aadd( aGravarP, {"Z08_LOJACL"  ,aList8B[nX,01,nY,11]})
        Aadd( aGravarP, {"Z08_URLFAT"  ,aList8B[nX,01,nY,14]})
        Aadd( aGravarP, {"Z08_MSBLQL"  ,'2'})
    
        IF len(aGravarP) > 0

            DbSelectArea("Z08") 

            Reclock("Z08",.T.)

            FOR nZ := 1 TO len(aGravarP)

                &("Z08->"+aGravarP[nZ,01]) := aGravarP[nZ,02]
            
            NEXT nZ

            Z08->(Msunlock())
            
        ENDIF

        cSeq := Soma1(cSeq)

    next nY
    
next nX

        
RestArea(aArea)

RETURN

/*/{Protheus.doc}  Gerahtm
    (long_description)
    @type  Static Function
    @author user
    @since 02/08/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Gerahtm()
    
Local cHtml := ''

cHtml += '<h2 style="color: #2e6c80;">Cleaning options:</h2>
cHtml += '<table class="editorDemoTable" style="height: 295px; width: 809px;">
cHtml += '<thead>
cHtml += '<tr style="height: 18px;">
cHtml += '<td style="height: 18px; width: 146.387px;">Name of the feature</td>
cHtml += '<td style="height: 18px; width: 251.35px;">Example</td>
cHtml += '<td style="height: 18px; width: 96.3125px;">Default</td>'
cHtml += '<td style="width: 93.5px;">&nbsp;</td>'
cHtml += '<td style="width: 93.5px;">&nbsp;</td>'
cHtml += '<td style="width: 93.55px;">&nbsp;</td>'
cHtml += '</tr>'
cHtml += '</thead>'
cHtml += '<tbody>'
cHtml += '<tr style="height: 21px;">'
cHtml += '<td style="height: 21px; width: 146.387px;">Remove tag attributes</td>'
cHtml += '<td style="height: 21px; width: 251.35px;"><img style="margin: 1px 15px;" src="images/smiley.png" alt="laughing" width="40" height="16" /> (except <strong>img</strong>-<em>src</em> and <strong>a</strong>-<em>href</em>)</td>'
cHtml += '<td style="height: 21px; width: 96.3125px;">&nbsp;</td>'
cHtml += '<td style="width: 93.5px;">&nbsp;</td>'
cHtml += '<td style="width: 93.5px;">&nbsp;</td>'
cHtml += '<td style="width: 93.55px;">&nbsp;</td>'
cHtml += '</tr>'
cHtml += '<tr style="height: 22px;">'
cHtml += '<td style="height: 22px; width: 146.387px;">Remove inline styles</td>'
cHtml += '<td style="height: 22px; width: 251.35px;"><span style="color: green; font-size: 13px;">You <strong style="color: blue; text-decoration: underline;">should never</strong>&nbsp;use inline styles!</span></td>'
cHtml += '<td style="height: 22px; width: 96.3125px;"><strong style="font-size: 17px; color: #2b2301;">x</strong></td>'
cHtml += '<td style="width: 93.5px;"><strong style="font-size: 17px; color: #2b2301;">&nbsp;</strong></td>'
cHtml += '<td style="width: 93.5px;"><strong style="font-size: 17px; color: #2b2301;">&nbsp;</strong></td>'
cHtml += '<td style="width: 93.55px;"><strong style="font-size: 17px; color: #2b2301;">&nbsp;</strong></td>'
cHtml += '</tr>'
cHtml += '<tr style="height: 18px;">'
cHtml += '<td style="height: 18px; width: 146.387px;">&nbsp;</td>'
cHtml += '<td style="height: 18px; width: 251.35px;">&nbsp;</td>'
cHtml += '<td style="height: 18px; width: 96.3125px;">&nbsp;</td>'
cHtml += '<td style="width: 93.5px;">&nbsp;</td>'
cHtml += '<td style="width: 93.5px;">&nbsp;</td>'
cHtml += '<td style="width: 93.55px;">&nbsp;</td>'
cHtml += '</tr>'
cHtml += '</tbody>'
cHtml += '</table>'

Return

/*/{Protheus.doc} Maquinas
    (long_description)
    @type  Static Function
    @author user
    @since 24/08/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Maquinas()

LOCAL nX
Local oJsonBody

oRestClient:setPath("/api/v1/machines?access_token="+cToken) 

IF oRestClient:Get(aHeader)
    cValor := oRestClient:GetResult("GET")

    cValor := DecodeUTF8(cValor, "cp1252")

    FWJsonDeserialize(cValor,@oJsonBody)

    For nX := 1 to len(oJsonBody)
        If AttIsMemberOf(oJsonBody[nX] , "INSTALLATION") 
            Aadd(aHeader,{cvaltochar(oJsonBody[nX]:ID),;
                        oJsonBody[nX]:ASSET_NUMBER,;
                        cvaltochar(oJsonBody[nX]:INSTALLATION:ID)  })
        EndIf
    Next nX 

ENDIF

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONWSC03   ºAutor  ³Microsiga           º Data ³  05/31/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Vendas por maquina com data inicial                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC FUNCTION Vendas(cDtCriac,cMaquina,nPos,cDtCria2)

LOCAL cValor    :=    'res'
LOCAL nPage     :=    1
LOCAL nX
///api/v1/vends/?access_token=AkH1cWGwYdvUy3KfKwHdTQaegWcD9SVCsGQ03trB&start_date=31-05-2017%2000:00:00&machine_id=227
Local aAux     :=    {}
Local aAux2    :=   {}

WHILE nPage > 0
    oRestClient:setPath("/api/v1/vends/?access_token="+cToken+"&start_date="+cDtCriac+"&end_date="+cDtCria2+"&machine_id="+cMaquina+"&page="+cvaltochar(nPage)) 
    
    IF oRestClient:Get(aHeader)
        cValor := oRestClient:GetResult("GET")

        cValor := DecodeUTF8(cValor, "cp1252")
        FWJsonDeserialize(cValor, @aAux2)
        
        oJson := JsonObject():New()
        
        ret := oJson:FromJson(cValor)
        
        
        cValor := strtran(cValor,"[")
        cValor := strtran(cValor,"]")
        cValor := strtran(cValor,'"')
        
        
        IF !Empty(cValor)
            nPage++ 
        ELSE
            nPage := 0
        ENDIF
        
        aLinhas := strtokarr(cValor,"},{")

        For nX := 1 to len(aAux2)
            If aAux2[nX]:GOOD:CATEGORY_ID != NIL
                
                Aadd(aAux,aAux2[nX]:COIL)
                Aadd(aAux,aAux2[nX]:OCCURRED_AT)
                Aadd(aAux,cvaltochar(aAux2[nX]:QUANTITY))
                Aadd(aAux,cvaltochar(aAux2[nX]:VALUE))
                
                If aAux2[nX]:GOOD:NAME != NIL
                    aCod := separa(aAux2[nX]:GOOD:NAME,"#")
                    Aadd(aAux,Alltrim(aCod[2]))
                ELSE
                    Aadd(aAux,'Item Nao encontrado')
                    
                EndIf

                Aadd(aHeader[nPos],aAux)
            ENDIF
             
            aAux := {}
        Next nX       
        
    ELSE
        nPage := 0
    ENDIF
ENDDO 

RETURN(aHeader[nPos])

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 12/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function cHtmStatus()

cRet := '<tr>'     
cRet += '    <td width=150><strong>!CONTRATO!</strong></td>'
cRet += '    <td width=150><strong>!ATIVO!</strong></td>'
cRet += '    <td width=100 align=right><strong>!STATUS!</strong></td>'
cRet += '</tr>'

Return(cRet)
