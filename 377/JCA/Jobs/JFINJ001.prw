#Include 'Totvs.ch'
#include "Fileio.ch"
/*/{Protheus.doc} JFINJ001
   @description: Job para envio do boleto para a Tracker via encode64
   
    Doc Mit
   
    Doc Entrega
   
   
/*/
User Function JFINJ001(xEmp, xFi, lJob, cTitulo)

    Local aItens := {}
    Local nCont 

    Default xEmp := '01'
    Default xFil := '00080230'
    Default lJob := .F.
    Default cTitulo := ''

    If Empty(FunName())
       RpcSetType(3)
       RpcSetEnv('01','00080230')
    EndIf

    aItens := Busca(cTitulo)

    If len(aItens) > 0
        For nCont := 1 to len(aItens)
            aItens[nCont,14] := GerBol(aItens[nCont])
        Next nCont

        EnvJson(aItens)
    EndIf 
    
Return

/*/{Protheus.doc} Busca
    Busca titulos com boletos gerados
    @type  Static Function
    @author user
    @since 12/03/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Busca(cTitulo)

Local aArea := GetArea()
Local cQuery 
Local aRet  := {}
Local cPref := Alltrim(SuperGetMV("TI_XPRTRC",.F.,"FAT"))

cQuery := "SELECT E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_NUMBCO,A1_CGC,E1_EMISSAO,E1_VENCREA,"
cQuery += " E1_IDCNAB,E1_ZIMPBOL,E1_CODBAR,E1_CLIENTE,E1_LOJA,E1.R_E_C_N_O_ AS RECNOE1 "
cQuery += " FROM "+RetSQLName("SE1")+" E1"
cQuery += " INNER JOIN "+RetSQLName("SA1")+" A1 ON A1_FILIAL='"+xFilial("SA1")+"' AND A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA AND A1.D_E_L_E_T_=' '"
cQuery += " WHERE E1_FILIAL BETWEEN ' ' AND 'ZZZ'"
cQuery += " AND E1_BAIXA=' '"
cQuery += " AND E1_NUMBCO<>' '"
cQuery += " AND E1_PREFIXO IN('"+cPref+"') "

If !Empty(cTitulo)
    cQUERY += " AND E1_NUM='"+cTitulo+"'"
else
    //cQuery += " AND E1_EMISSAO='"+dtos(dDataBase)+"'"
    //cQuery += " AND E1_VENCREA>='"+dtos(dDatabase)+"'"
    cQuery += " AND E1_XCTRBOL='1'"
endif 

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("JFINJ001.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB") 

While !EOF()
    Aadd(aRet,{ TRB->E1_FILIAL,;
                TRB->E1_PREFIXO,;
                TRB->E1_NUM,;
                TRB->E1_PARCELA,;
                TRB->E1_TIPO,;
                TRB->E1_NUMBCO,;
                TRB->E1_IDCNAB,;
                TRB->E1_ZIMPBOL,;
                TRB->E1_CODBAR,;
                TRB->E1_CLIENTE,;
                TRB->E1_LOJA,;
                TRB->RECNOE1,;
                TRB->A1_CGC,;
                "",;
                STOD(TRB->E1_EMISSAO),;
                STOD(TRB->E1_VENCREA)})
    Dbskip()
EndDo

RestArea(aArea)

Return(aRet)

/*/{Protheus.doc} GerBol
    (long_description)
    @type  Static Function
    @author user
    @since 12/03/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function GerBol(aAux)

Local aArea     := GetArea()
Local cEncode64 := ""

Local cFile := ""// VALORES RETORNADOS NA LEITURA

Private cMarca  := GetMark()

DbSelectArea("SE1")
DbsetOrder(1)
If Dbseek(Avkey(aAux[1],"E1_FILIAL")+Avkey(aAux[2],"E1_PREFIXO")+Avkey(aAux[3],"E1_NUM")+Avkey(aAux[4],"E1_PARCELA")+Avkey(aAux[5],"E1_TIPO"))
    Reclock("SE1",.F.)
    Replace E1_OK With cMarca
    MsUnLock()
EndIf

MV_PAR20    :=  SE1->E1_PORTADO
MV_PAR21    :=  SE1->E1_AGEDEP  
MV_PAR22    :=  SE1->E1_CONTA

DbSelectArea("SEE")
DbSetOrder(1)
If Dbseek(xFilial("SEE")+MV_PAR20+MV_PAR21+MV_PAR22)
    While !EOF() .AND. SEE->EE_CODIGO == MV_PAR20 .and. SEE->EE_CONTA == MV_PAR22
        If SEE->EE_NRBYTES == 400
            MV_PAR19 := SEE->EE_SUBCTA
            Exit 
        EndIf 
        Dbskip()
    EndDo
EndIf 

lBolSeparado := .f.

CCMPVENCTO := "SE1->E1_VENCTO"

cFileBol := U_RF01BImp(.f.,.f.)

If !'.pdf' $ cFileBol
    cFileBol := alltrim(cFileBol)+'.pdf'
EndIf 

cFile := CodificaBase64(cFileBol)

cEncode64 := Encode64(cFile)

RestArea(aArea)

Return(cEncode64)


/*/{Protheus.doc} CodificaBase64
    Gerar o encode64 do boleto
    @type  Static Function
    @author user
    @since 17/12/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function CodificaBase64(cArquivo)

    Local hFile, nSize, cBuffer
    
    // Abrir o arquivo para leitura
    hFile := FOpen(cArquivo, FO_READ)
    
    If hFile == Nil
        Return ""
    EndIf
    
    nSize := FSeek(hFile, 0, 2)  
    
    FSeek(hFile, 0, 0)  

    cBuffer := Space(nSize)
    
    FRead(hFile, @cBuffer, nSize)  
    FClose(hFile)
      
Return cBuffer

/*/{Protheus.doc} aItens
    (long_description)
    @type  Static Function
    @author user
    @since 12/03/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function EnvJson(aItens)

Local aArea     := GetArea()
Local nCont 
Local oEnvio    := JsonObject():New()
Local cApiDest  := SuperGetMV("TI_APIDES",.F.,"https://buslog.track3r.com.br")
Local cEndPnt   := SuperGetMV("TI_ENDPNT",.F.,"/api/totvs-protheus/recebe-boleto-fatura")
Local cToken    := SuperGetMV("TI_TOKTRK",.F.,'0D901F83-1739-41E3-995B-7303EF0BB19A')


For nCont := 1 to len(aItens)
    oEnvio['filial']        := aItens[nCont,01]
    oEnvio['prefixo']       := aItens[nCont,02]
    oEnvio['titulo']        := aItens[nCont,03]
    oEnvio['parcela']       := aItens[nCont,04]
    oEnvio['tipo']          := aItens[nCont,05]
    oEnvio['nosso_numero']  := aItens[nCont,06]
    oEnvio['idcnab']        := aItens[nCont,07]
    oEnvio['status_boleto'] := If(aItens[nCont,08]=="1","Impresso",If(aItens[nCont,08]=="2","Enviado","Nao impresso"))
    oEnvio['cliente']       := aItens[nCont,13]
    oEnvio['emissao']       := cvaltochar(aItens[nCont,15])
    oEnvio['vencimento']    := cvaltochar(aItens[nCont,16])
    oEnvio['boleto64']      := aItens[nCont,14]

    cRet := oEnvio:toJson()
    
    ApiEnv04(cApiDest,cEndPnt,cRet,cToken,aItens[nCont,12])

Next nCont 

RestArea(aArea)

Return


/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 12/03/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function ApiEnv04(cUrlDest,cPathDest,cJson,cToken,nRecnE1)

Local oRest 
Local oJson     :=  ""
Local aHeader   :=  {}
Local cRetorno  :=  ""
Local lRet      :=  .T.
Local cUrlInt	:=	Alltrim(cUrlDest) 
Local cPath     :=  Alltrim(cPathDest)

Aadd(aHeader,'Content-Type: application/json')
Aadd(aHeader,'Token: '+cToken) 

oRest := FWRest():New(cUrlInt)

oRest:SetPath(cPath)

oRest:SetPostParams(cJson)

If oRest:Post(aHeader)
    oJson := JsonObject():New()
    cRet  := oRest:GetResult()
    oRet := oJson:FromJson(cRet)
    lRet := .T.
    DbSelectArea("SE1")
    dbGoto(nRecnE1)
    Reclock("SE1",.F.)
    SE1->E1_XCTRBOL := '2'
    SE1->(MsUnLock())
else
    cRetorno := Alltrim(oRest:GetLastError()) 
    cRet := Alltrim(oRest:cresult)
    oBody  := JsonObject():New()
    oBody:fromJson(cRet)
    lRet := .F.
Endif

Return(cRet)

User Function xJfinj01

Local aPerg := {}
Local cTit  := space(9)

If Empty(FunName())
    RpcSetType(3)
    RpcSetEnv('01','00080230')
EndIf

aAdd(aPerg,{01,"Titulo" ,cTit 		,""					,"","SE1"	,"", 60,.F.})	// MV_PAR01

If ParamBox(aPerg,"Filtro",/*aRet*/,/*bOk*/,/*aButtons*/,.T.,,,,FUNNAME(),.T.,.T.)
    cFilNF := MV_PAR01 
    Processa({|| U_JFINJ001('', '', .F., cFilNF)},"Aguarde")
EndIf 

Return 
