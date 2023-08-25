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
User Function CONJOB03()

Local cQuery

Local cHri              :=   '00:00'
Local cHrf              :=   '23:59'
Local aAux              :=   {}
Local dUltLei
Local dLeiFim
Local nX,nY
Local dDiaExe  
Local aEmail            :=  {}
Local cCntAtu           :=  ''
Local nIni 

Private cArqXls         := '' 

Private aList8B         :=   {}
Private oExcel 

PRIVATE cToken         :=    "yVXxnxgOExcIaBQOQ9CFgK0cLgX22dJct7y85WXW" //Token Connect Vending
PRIVATE oRestClient    :=    nil //FWRest():New("http://vmpay.vertitecnologia.com.br")
PRIVATE aHeader        :=    {}
PRIVATE aLinhas        :=    {}
PRIVATE aRetorno       :=    {}   
PRIVATE aCanister      :=    {}
PRIVATE nCanister      :=    0
Private cDir           :=   'C:\temp\'

IF Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","0101")
ENDIF

oExcel := FWMSEXCEL():New()

//cArqXls := "\spool\analise_base_"+dtos(ddatabase)+strtran(time(),":")+".xls"'
cArqXls := "analise_base_"+dtos(ddatabase)+strtran(time(),":")+".xls"'

oRestClient    :=    FWRest():New("http://vmpay.vertitecnologia.com.br")

dDiaExe := strzero(day(ddatabase),2)

cQuery := "SELECT AAM_CONTRT,AAM_XDIALT,AAN_XCBASE,AAM_CODCLI,AAM_LOJA,AAN_ITEM,AAN_CODPRO,A1_NOME,B1_DESC"
cQuery += " FROM "+RetSQLName("AAN")+" AAN"
cQuery += " INNER JOIN "+RetSQLName("AAM")+" AAM ON AAM_FILIAL=AAN_FILIAL AND AAM_CONTRT=AAN_CONTRT"
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=AAM_CODCLI AND A1_LOJA=AAM_LOJA AND A1.D_E_L_E_T_=' '"
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=AAN_CODPRO AND B1.D_E_L_E_T_=' '"
cQuery += "     AND AAM.D_E_L_E_T_=' '"
cQuery += " WHERE AAN_FILIAL='"+xFilial("AAN")+"' AND AAN.D_E_L_E_T_=' ' AND AAN_XBOXVM='1'"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("CONJOB03.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    Aadd(aAux,{ TRB->AAM_CONTRT,;   //01
                TRB->AAM_XDIALT,;   //02
                TRB->AAN_XCBASE,;   //03
                TRB->AAM_CODCLI+TRB->AAM_LOJA,;   //04
                TRB->A1_NOME,;     //05
                TRB->AAN_ITEM,;     //06
                TRB->AAN_CODPRO,;   //07
                "",;                //08
                "",;                //09
                "",;                //10
                TRB->B1_DESC,;      //11
                .T.})               //12
    DbSkip()
EndDo 

//Buscar Maquinas                         
Maquinas()

cCntAtu := aAux[01,01]
nIni    := 1

For nX := 1 to len(aAux)
    If cCntAtu <> aAux[nX,01]
        
        aRet := Htmanalise(nIni,aAux)
        Aadd(aEmail,aRet[2])
        nIni := nX
        cCntAtu := aAux[nX,01]

    EndIf 

    nPosMaq := Ascan(aHeader,{|x| Alltrim(x[1]) == alltrim(aAux[nX,03])})
    If nPosMaq == 0
        aAux[nX,12] := .F.
    else
        Aadd(aAux[nX],Instalacoes(alltrim(aHeader[nPosMaq,02]),nPosMaq))
        //Buscar id de Planogramas por maquina
        If len(aHeader[nPosMaq]) > 2
            aAuxP := Planograma(aHeader[nPosMaq,02],cvaltochar(aHeader[nPosMaq,03,1]),nPosMaq)
            DbSelectArea("Z07")
            DbSetOrder(1)
            Dbseek(xFilial("Z07")+aHeader[nPosMaq,01])
            While !EOF() .And. Alltrim(Z07->Z07_CHAPA) == Alltrim(aHeader[nPosMaq,01])
                nPosMol := Ascan(aAuxP,{|x| val(x[3]) == val(Z07->Z07_SELECA)})
                If nPosMol > 0
                    aAuxP[nPosMol,01] := .T.

                    aAuxP[nPosMol,06] := Z07->Z07_CODPRO
                    aAuxP[nPosMol,07] := Posicione("SB1",1,xFilial("SB1")+Z07->Z07_CODPRO,"B1_DESC")
                    
                    If Alltrim(Z07->Z07_CODPRO) <> Alltrim(aAuxP[nPosMol,04])
                        aAuxP[nPosMol,09] := "DIFERENTE"
                    EndIf 
                EndIf

                Dbskip()
            EndDo 

            Aadd(aAux[nX],aAuxP)
        EndIf

        dUltLei := UltLei(aAux[nX,03])
        If Empty(dtos(dUltLei))
            dUltLei := ddatabase-30
        EndIf

        dLeiFim := ddatabase-1

        //Exemplo URL enviar ao cliente
        //https://vmpay.vertitecnologia.com.br/verti/reports/vends?
        //dataInicial=30/06/2023-00:00&dataFinal=01/08/2023-23:59&machine_id=36245
        aAux[nX,08] := "https://vmpay.vertitecnologia.com.br/verti/reports/vends?"
        aAux[nX,08] += "dataInicial="+cvaltochar(dUltLei)+"-"+cHri
        aAux[nX,08] += "&dataFinal="+cvaltochar(dLeiFim)+"-"+cHrf
        aAux[nX,08] += "&machine_id="+alltrim(aAux[nX,03])

        aAux[nX,09] := dUltLei
        aAux[nX,10] := dLeiFim

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

        Aadd(aAux[nX],Vendas(cDtCriac,aHeader[nPosMaq,02],nPosMaq,cDtCria2))

    ENDIF

Next nX
/*
For nX := 1 to len(aAux)
    aRet := Htmanalise(nX,aAux)
    nX := aRet[1]
    Aadd(aEmail,aRet[2])
Next nX 
*/
cFrom := 'nf.erp@connectvending.com.br'
cTo   := 'alexandre.venancio@avsipro.com.br'
cSubject := 'Validações de Pré-Faturamento'
cBody := ''

For nX := 1 to len(aEmail)
    cBody += aEmail[nX]+CRLF
Next nX 

U_EnviarEmail(cTo,cSubject,cBody,'',.f.) 

oExcel:Activate()
oExcel:GetXMLFile(cDir +cArqXls)

//oExcelApp := MsExcel():New()
//oExcelApp:Destroy()

//savevend()

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
±±ºPrograma  ³CONJOB03   ºAutor  ³Microsiga           º Data ³  06/08/17   º±±
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


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONWSC03   ºAutor  ³Microsiga           º Data ³  04/13/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Busca maquinas                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC FUNCTION Maquinas()

    LOCAL nX
    Local oJsonBody

    oRestClient:setPath("/api/v1/machines?access_token="+cToken) 

    IF oRestClient:Get(aHeader)
        cValor := oRestClient:GetResult("GET")
        
        FWJsonDeserialize(cValor,@oJsonBody)
        
        For nX := 1 to len(oJsonBody)
            Aadd(aHeader,{oJsonBody[nX]:ASSET_NUMBER,;
                          cvaltochar(oJsonBody[nX]:ID)  })
        Next nX 

    ENDIF

RETURN 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONWSC03   ºAutor  ³Microsiga           º Data ³  04/13/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Busca Instalacoes                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC FUNCTION Instalacoes(cCod,nPos)


Local oJsonBody
Local aRet := {}

oRestClient:setPath("/api/v1/machines/"+Alltrim(cCod)+"/installations?access_token="+cToken) 

IF oRestClient:Get(aHeader)
    cValor     :=    oRestClient:GetResult("GET")
    FWJsonDeserialize(cValor,@oJsonBody)

    If valtype(oJsonBody) == "A"
        Aadd(aHeader[nPos],{oJsonBody[1]:ID,;
                            oJsonBody[1]:LAST_AUDIT_ENDED_AT,;
                            oJsonBody[1]:PLACE})
        Aadd(aRet,{oJsonBody[1]:ID,;
                    oJsonBody[1]:LAST_AUDIT_ENDED_AT,;
                    oJsonBody[1]:PLACE})
    EndIf 
    
ENDIF

RETURN(aRet)           

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONWSC03   ºAutor  ³Microsiga           º Data ³  04/13/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Busca planogramas                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC FUNCTION Planograma(cMaq,cInst,nPos)

LOCAL nJ
Local oJson
Local aMapa     :=  {}
Local aAux      :=  {}
 ///planograms
oRestClient:setPath("/api/v1/machines/"+Alltrim(cMaq)+"/installations/"+cInst+"?access_token="+cToken) 
        
IF oRestClient:Get(aHeader)
    cValor    :=    oRestClient:GetResult("GET")
    cValor := DecodeUTF8(cValor, "cp1252")
    oJson := JsonObject():New()
    oJson2:= JsonObject():New()
    oJson3:= JsonObject():New()

    ret := oJson:FromJson(cValor)
    
    //lret := oJson:GetJsonValue("current_planogram", @keyVal,  @keyType)
    ret := oJson2:FromJson(oJson:GetJsonText("current_planogram"))

    aMapa := oJson2["items"]
    
    For nJ :=  1 to len(aMapa)
        aAxCd := aMapa[nJ]:GetJsonObject('good')
        aCodPrd := strtokarr(aAxCd:GetJsonText('upc_code_name'),"#")

        Aadd(aAux,{.F.,;
            aHeader[nPos,2],;
            aMapa[nJ]:GetJsonText('name'),;
            If(len(aCodPrd)>1,Alltrim(aCodPrd[2]),aAxCd:GetJsonText('upc_code_name')),; //aAxCd:GetJsonText('upc_code'),; //aMapa[nJ]:GetJsonText('id'),;
            If(len(aCodPrd)>1,Alltrim(aCodPrd[1]),aAxCd:GetJsonText('upc_code_name')),; //aAxCd:GetJsonText('name'),;
            aMapa[nJ]:GetJsonText('planogram_id'),;
            aMapa[nJ]:GetJsonText('good_id'),;
            aMapa[nJ]:GetJsonText('updated_at'),;
            aMapa[nJ]:GetJsonText('par_level'),;
            aMapa[nJ]:GetJsonText('alert_level'),;
            aMapa[nJ]:GetJsonText('desired_price'),;
        })
    Next nJ

ENDIF

RETURN(aAux) 


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
Local aRet      :=  {}

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
                    //Aadd(aAux,If(aAux2[nX]:GOOD:UPC_CODE==nil,'null',aAux2[nX]:GOOD:UPC_CODE))
                        Aadd(aAux,Alltrim(aCod[2]))
                    //EndIf 
                    
                ELSE
                        Aadd(aAux,'Item Nao encontrado')
                    
                EndIf

                Aadd(aRet,aAux)
            ENDIF
             
            aAux := {}
        Next nX       
        
    ELSE
        nPage := 0
    ENDIF
ENDDO 

RETURN(aRet)

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 16/08/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Htmanalise(nLinha,aAux)

Local cHtml := ""
Local nCont := 0
Local cCntr := aAux[nLinha,01]
Local nQtdA := 0
Local nY    := 0
Local lMapa := .F.
Local nMola := 0
Local aVndT := {}
Local aVndA := {}

For nCont := nLinha to len(aAux)
    If aAux[nCont,01] <> cCntr
        exit
    Else 
        nQtdA++
    EndIf
Next nCont

oExcel:AddworkSheet(cCntr) 

oExcel:AddTable (cCntr,"Cliente")

oExcel:AddColumn(cCntr,"Cliente","Contrato",1,1)
oExcel:AddColumn(cCntr,"Cliente","Cliente",1,1)
oExcel:AddColumn(cCntr,"Cliente","Qtd Ativos SAF",1,1)

oExcel:AddRow(cCntr,"Cliente",{cCntr,; 	
                                aAux[nLinha,04]+'-'+aAux[nLinha,05],;		
                                cvaltochar(nQtdA)})

cHtml += '<table border="1" cellpadding="1" cellspacing="1" style="width:672.6px">
cHtml += '	<tbody>
cHtml += '		<tr>
cHtml += '			<td style="background-color:#3399ff; width:140px"><span style="color:#ffffff"><strong>Contrato</strong></span></td>
cHtml += '			<td style="background-color:#3399ff; width:329px"><span style="color:#ffffff"><strong>Cliente</strong></span></td>
cHtml += '			<td style="background-color:#3399ff; width:186px"><span style="color:#ffffff"><strong>Qtd. Ativos SAF</strong></span></td>
cHtml += '		</tr>'
cHtml += '		<tr>'
cHtml += '			<td style="width:140px">'+cCntr+'</td>'
cHtml += '			<td style="width:329px">'+aAux[nLinha,04]+'-'+aAux[nLinha,05]+'</td>'
cHtml += '			<td style="width:186px">'+cvaltochar(nQtdA)+'</td>' //&nbsp;
cHtml += '		</tr>'
cHtml += '	</tbody>'
cHtml += '</table>'
cHtml += '<p>&nbsp;</p>'

oExcel:AddTable (cCntr,"Ativos")

oExcel:AddColumn(cCntr,"Ativos","Ativo",1,1)
oExcel:AddColumn(cCntr,"Ativos","Modelo",1,1)
oExcel:AddColumn(cCntr,"Ativos","Comunicação",1,1)
oExcel:AddColumn(cCntr,"Ativos","Ultima Comunicação",1,1)
oExcel:AddColumn(cCntr,"Ativos","Local Fisico",1,1)


cHtml += '<table border="1" cellpadding="1" cellspacing="1" style="width:500px">'
cHtml += '	<tbody>'
cHtml += '		<tr>'
cHtml += '			<td style="background-color:#aaaaaa"><span style="color:#ffffff"><strong>Ativo</strong></span></td>
cHtml += '			<td style="background-color:#aaaaaa"><span style="color:#ffffff"><strong>Modelo</strong></span></td>
cHtml += '			<td style="background-color:#aaaaaa"><span style="color:#ffffff"><strong>Comunicação</strong></span></td>
cHtml += '			<td style="background-color:#aaaaaa"><span style="color:#ffffff"><strong>Ultima Comunicação</strong></span></td>
cHtml += '			<td style="background-color:#aaaaaa"><span style="color:#ffffff"><strong>Local Fisico</strong></span></td>
cHtml += '		</tr>'

For nY := nLinha to nCont-1
    cHtml += '		<tr>'
    cHtml += '		    <td>'+Alltrim(aAux[nY,03])+'</td>'
    cHtml += '			<td>'+aAux[nY,11]+'</td>
    cHtml += '			<td>'+If(aAux[nY,12],'Ok','Falha')+'</td>
    cHtml += '			<td>'+If(len(aAux[nY])>12,cvaltochar(aAux[nY,13,1,2]),'Falha')+'</td>
    cHtml += '			<td>'+If(len(aAux[nY])>13,cvaltochar(aAux[nY,13,1,3]),'Falha')+'</td>
    cHtml += '		</tr>'

    oExcel:AddRow(cCntr,"Ativos",{  Alltrim(aAux[nY,03]),; 	
                                    aAux[nY,11],;		
                                    If(aAux[nY,12],'Ok','Falha'),;
                                    If(len(aAux[nY])>12,aAux[nY,13,1,2],'Falha'),;
                                    If(len(aAux[nY])>13,aAux[nY,13,1,3],'Falha')})

    If len(aAux[nY])>13
        If ascan(aAux[nY,14],{|x| x[9] == "DIFERENTE"})
            lMapa := .T.
        EndIf
    EndIf

    If len(aAux[nY]) > 14
        For nMola := 1 to len(aAux[nY,15])
            nPos := Ascan(aVndT,{|x| x[1] == aAux[nY,15,nMola,1]})
            If nPos > 0
                aVndT[nPos,04] += val(aAux[nY,15,nMola,3])
            Else 
                Aadd(aVndT,{aAux[nY,15,nMola,1],;
                            aAux[nY,15,nMola,5],;
                            Posicione("SB1",1,xFilial("SB1")+aAux[nY,15,nMola,5],"B1_DESC"),;
                            val(aAux[nY,15,nMola,3])})
            EndIf 

            nPos := Ascan(aVndA,{|x| x[1]+x[2] ==  aAux[nY,3]+aAux[nY,15,nMola,1]})
            If nPos > 0
                aVndA[nPos,05] += val(aAux[nY,15,nMola,3])
            Else 
                Aadd(aVndA,{aAux[nY,3],;
                            aAux[nY,15,nMola,1],;
                            aAux[nY,15,nMola,5],;
                            Posicione("SB1",1,xFilial("SB1")+aAux[nY,15,nMola,5],"B1_DESC"),;
                            val(aAux[nY,15,nMola,3])})
            EndIf 
        Next nMola
    EndIf 
Next nY

cHtml += '	</tbody>'
cHtml += '</table>'
cHtml += '<p>&nbsp;</p>'

If lMapa

    oExcel:AddTable (cCntr,"Layout")

    oExcel:AddColumn(cCntr,"Layout","Ativo",1,1)
    oExcel:AddColumn(cCntr,"Layout","Seleção",1,1)
    oExcel:AddColumn(cCntr,"Layout","Produto Vmpay",1,1)
    oExcel:AddColumn(cCntr,"Layout","Descrição",1,1)
    oExcel:AddColumn(cCntr,"Layout","Produto Protheus",1,1)
    oExcel:AddColumn(cCntr,"Layout","Descrição",1,1)
    
    cHtml += '<table border="1" cellpadding="1" cellspacing="1" style="width:500px">
    cHtml += '	<tbody>'
    cHtml += '		<tr>'
    cHtml += '			<td style="background-color:#aaaaaa"><span style="color:#ffffff"><strong>Ativo</strong></span></td>
    cHtml += '			<td style="background-color:#aaaaaa"><span style="color:#ffffff"><strong>Seleção</strong></span></td>
    cHtml += '			<td style="background-color:#aaaaaa"><span style="color:#ffffff"><strong>Produto VMPay</strong></span></td>
    cHtml += '			<td style="background-color:#aaaaaa"><span style="color:#ffffff"><strong>Descrição</strong></span></td>
    cHtml += '			<td style="background-color:#aaaaaa"><span style="color:#ffffff"><strong>Produto Protheus</strong></span></td>
    cHtml += '			<td style="background-color:#aaaaaa"><span style="color:#ffffff"><strong>Descrição</strong></span></td>
    cHtml += '		</tr>

    If len(aAux[nLinha]) > 13
        For nY := nLinha to nCont-1
            If len(aAux[nY]) > 13
                For nMola := 1 to len(aAux[nY,14])
                    If aAux[nY,14,nMola,1]
                        cHtml += '		<tr>'
                        cHtml += '			<td>'+aAux[nY,3]+'</td>'
                        cHtml += '			<td>'+strzero(val(aAux[nY,14,nMola,3]),3)+'</td>'
                        cHtml += '			<td>'+aAux[nY,14,nMola,4]+'</td>'
                        cHtml += '			<td>'+aAux[nY,14,nMola,5]+'</td>'
                        cHtml += '			<td>'+aAux[nY,14,nMola,6]+'</td>'
                        cHtml += '			<td>'+aAux[nY,14,nMola,7]+'</td>'
                        cHtml += '		</tr>'

                        oExcel:AddRow(cCntr,"Layout",{  aAux[nY,3],;
                                                        strzero(val(aAux[nY,14,nMola,3]),3),; 	
                                                        aAux[nY,14,nMola,4],;		
                                                        aAux[nY,14,nMola,5],;
                                                        aAux[nY,14,nMola,6],;
                                                        aAux[nY,14,nMola,7]})
                    EndIf
                Next nMola
            EndIf
        Next nY 
    EndIf

    cHtml += '	</tbody>
    cHtml += '</table>

    cHtml += '<p>&nbsp;</p>
EndIf

If len(aVndT) > 0

    oExcel:AddTable (cCntr,"Vendas")

    oExcel:AddColumn(cCntr,"Vendas","Seleção",1,1)
    oExcel:AddColumn(cCntr,"Vendas","Produto Vmpay",1,1)
    oExcel:AddColumn(cCntr,"Vendas","Descrição",1,1)
    oExcel:AddColumn(cCntr,"Vendas","Qtd Vendida",1,1)

    cHtml += '<table border="1" cellpadding="1" cellspacing="1" style="width:500px">
    cHtml += '	<tbody>'
    cHtml += '		<tr>'
    cHtml += '			<td style="background-color:#aaaaaa"><span style="color:#ffffff"><strong>Mola</strong></span></td>
    cHtml += '			<td style="background-color:#aaaaaa"><span style="color:#ffffff"><strong>Produto</strong></span></td>
    cHtml += '			<td style="background-color:#aaaaaa"><span style="color:#ffffff"><strong>Descri&ccedil;&atilde;o</strong></span></td>
    cHtml += '			<td style="background-color:#aaaaaa"><span style="color:#ffffff"><strong>Qtd Vendida</strong></span></td>
    cHtml += '		</tr>'

    For nY := 1 to len(aVndT)
        cHtml += '		<tr>'
        cHtml += '			<td>'+strzero(val(aVndT[nY,01]),3)+'</td>'
        cHtml += '			<td>'+aVndT[nY,02]+'</td>'
        cHtml += '			<td>'+aVndT[nY,03]+'</td>'
        cHtml += '			<td>'+cvaltochar(aVndT[nY,04])+'</td>'
        cHtml += '		</tr>'

        oExcel:AddRow(cCntr,"Vendas",{  strzero(val(aVndT[nY,01]),3),;
                                        aVndT[nY,02],;		
                                        aVndT[nY,03],;
                                        cvaltochar(aVndT[nY,04])})
    Next nY 

    oExcel:AddTable (cCntr,"Vendas_por_Ativo")

    oExcel:AddColumn(cCntr,"Vendas_por_Ativo","Ativo",1,1)
    oExcel:AddColumn(cCntr,"Vendas_por_Ativo","Seleção",1,1)
    oExcel:AddColumn(cCntr,"Vendas_por_Ativo","Produto Vmpay",1,1)
    oExcel:AddColumn(cCntr,"Vendas_por_Ativo","Descrição",1,1)
    oExcel:AddColumn(cCntr,"Vendas_por_Ativo","Qtd Vendida",1,1)

    For nY := 1 to len(aVndA)
        oExcel:AddRow(cCntr,"Vendas_por_Ativo",{  aVndA[nY,01],;
                                                strzero(val(aVndA[nY,02]),3),;
                                                aVndA[nY,03],;		
                                                aVndA[nY,04],;
                                                cvaltochar(aVndA[nY,05])})
    Next nY

    cHtml += '	</tbody>'
    cHtml += '</table>'

    cHtml += '<p>&nbsp;</p>'
EndIf



Return({nCont-1,cHtml})
