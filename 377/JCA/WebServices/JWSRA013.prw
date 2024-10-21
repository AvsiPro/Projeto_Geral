#Include 'Protheus.ch'
#Include 'RestFul.ch'
#Include "FwMvcDef.ch"
#include "fileio.ch"
/*
    API
    API para receber os dados de CTE e NFE a ser enviada pelo Tracker

    Doc Mit
   
    Doc Validação entrega
    
    
*/

User Function JWSRA013()

Return

WsRestFul JWSRA013 DESCRIPTION "API REST - Consultar status financeiro de cliente" 
	
	WsMethod POST Description "API REST - Consultar status financeiro de cliente - METODO POST "  WsSyntax "JWSRA013"

End WsRestFul


WsMethod POST WSSERVICE JWSRA013

    LOCAL lRet      := .T.
    LOCAL oBody     
    Local cJson     := ::GetContent()
    Local cXmlRec   :=  ''
    Local cPathXml  :=  ''
    Local cTipo     :=  ''
    Local cDoc      :=  ''
    Local nLinha 
    Local cError    :=  ''
    Local nCont
    Local cWarning  :=  ''
    Local oResponse     := JsonObject():New()
    Local oCampo        := JsonObject():New()
    Local lGerou        := .T.
    Local cNota         :=  ''
    Private cErrorN     :=  ''
    Private cCombina    :=  ''
    Private cNfExst     :=  ''

    If Select("SM0") == 0
        RpcClearEnv()
        RpcSetType(3)
        RPCSetEnv('01','00020087')
        //RPCSetEnv('T1','D MG 01')
    EndIf

	::SetContentType("application/json")

    If lRet
        oBody  := JsonObject():New()
        oBody:fromJson(cJson) 

        cTipo      := oBody:getJsonText("tipo")
        cDoc       := oBody:getJsonText("fatura")
        
        oCampo['DADOS']   := {}

        nLinha := 1

        For nCont := 1 to len(oBody['itens'])
            cXmlRec    := oBody['itens'][nCont]:getJsonText("xml")
            cPathXml   := oBody['itens'][nCont]:getJsonText("pathxml")
        
            If Empty(cXmlRec) .and. Empty(cPathXml)
                lRet		:= .F.
                oResponse['code'] := "#400"
                oResponse['status'] := 500
                oResponse['message'] := '#erro_json'
                oResponse['detailedMessage'] := 'Não foi informado o xml e endereço do xml'
            Else 
                cXmlRec := Decode64(cXmlRec)
                cXmlRec := fRemoveCarc(cXmlRec)

                //cXmlRec := DecodeUTF8(cXmlRec)

                oXml := XmlParser( cXmlRec, "_", @cError, @cWarning )
                
                If ValType(oXml) != "O"
                    cPath := substr(cPathXml,at('cte',cPathXml)-1)
                    //cPathXml := 'https://tmstransportador.blob.core.windows.net'
                    //cPath    := '/cte/254/2024/04/03/5761/autorizado/35240410992167003660570010004288841015537085.xml'
                    cPathXml := substr(cPathXml,1,at('cte',cPathXml)-2)
                    oRestxml := FWRest():New(cPathXml)
                    oRestxml:setpath(cPath)
                            
                    aHeader :=  {}
                    
                    If oRestxml:Get(aHeader)         
                        cXmlRec := oRestxml:cresult

                        oXml := XmlParser( cXmlRec, "_", @cError, @cWarning )

                    EndIf 
                EndIf 

                cErrorN := ''
                cCombina:= ''
                lgerou := XMLCTE(oXml,@cNota,cXmlRec,0)
                
                If lgerou    
                    
                    AADD( oCampo['DADOS'], JsonObject():New() )
                    oCampo['DADOS'][nLinha]["Status"] := .T.
                    oCampo['DADOS'][nLinha]["Nota"]   := cNota
                    oCampo['DADOS'][nLinha]["Motivo"] := cCombina
                    nLinha++
                
                else
                    AADD( oCampo['DADOS'], JsonObject():New() )
                    oCampo['DADOS'][nLinha]["Status"] := .F.
                    oCampo['DADOS'][nLinha]["Nota"]   := cNota
                    oCampo['DADOS'][nLinha]["Motivo"] := cErrorN

                    nLinha++
                    
                EndIf 
                
            EndIf 
        Next nCont
        
    EndIf
	
    ::SetResponse(FWJsonSerialize(oCampo, .F., .F., .T.))

    If !lRet
        ::SetResponse(FWJsonSerialize(oResponse, .F., .F., .T.))
    EndIf

	RpcClearEnv()

Return lRet

/*/{Protheus.doc} fRemoveCarc
    Remover caracteres especiais 
    @type  Static Function
    @author user
    @since 22/03/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function fRemoveCarc(cWord)
    cWord := FwCutOff(cWord, .T.)
    cWord := strtran(cWord,"ã","a")
	cWord := strtran(cWord,"á","a")
	cWord := strtran(cWord,"à","a")
	cWord := strtran(cWord,"ä","a")
    cWord := strtran(cWord,"º","")
    cWord := strtran(cWord,"%","")
    cWord := strtran(cWord,"*","")     
    cWord := strtran(cWord,"&","")
    cWord := strtran(cWord,"$","")
    cWord := strtran(cWord,"#","")
    cWord := strtran(cWord,"§","") 
    cWord := strtran(cWord,",","")
    cWord := StrTran(cWord, "'", "")
    cWord := StrTran(cWord, "#", "")
    cWord := StrTran(cWord, "%", "")
    cWord := StrTran(cWord, "*", "")
    cWord := StrTran(cWord, "&", "E")
    cWord := StrTran(cWord, "!", "")
    cWord := StrTran(cWord, "@", "")
    cWord := StrTran(cWord, "$", "")
    cWord := StrTran(cWord, "?", "")
    cWord := StrTran(cWord, '°', '')
    cWord := StrTran(cWord, 'ª', '')
    cWord := Alltrim(Lower(cWord))
Return cWord

/*/{Protheus.doc} XMLCTE
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
Static Function XMLCTE(oXml,cNotaG,cXmlRec,nChama)

Local lRet          := .T.
Local lRetorno      := .F.
Local nCont         := 0
Local lLancado      := .F.
Private cFilorig    := '' 
Private cEspecie    := "CTE"
Private cVersaoCTE  := ''
Private cChave_Nfe  := ''
Private cProtoc     := '' 
Private cIdRCTe     := ''
Private cRetCTe     := ''
Private cAmbCTe     := ''
Private cCNPJ_FIL   := ''
Private cNatOp      := ''
Private cCNPJ_TOM   := ''
Private cCNPJ_DES   := ''
Private cNum        := ''
Private cSerie      := ''
Private cDtEmissao  := ''
Private cHrEmissao  := ''
Private cCfopFrt    := ''
Private cEstIni     := ''
Private cEstFim     := ''
Private cTesCTe     := ''
Private cCodCli     := ''
Private cLjFornec   := ''
Private cCliDst     := ''
Private cLojDst     := ''
Private cTipoCli    := ''
Private aCSTTipo    := BuscaS2() //separa(SuperGetMV("TI_CSTCTE",.F.,"00/40/41/51"),"/")
Private cCstCte     := ''
Private cMunIni     := ''
Private cMunFim     := ''
Private cEstFil     := ''
Private cEstTom     := ''
Private aPesos      := {}
Private aPeCTe      := {}
Private aImposto    := {}
Private aImpCte     := {}
Private cMunIniCTE  := ""
Private cMunFimCTE  := ""
Private cChaveCTE   := ""
Private nValImp     := 0
Private nValCarga   := 0
Private aEstReg   := BuscaReg()

Default nChama      := 0

If ValType(oXml) != "O"
    cErrorN := 'xml nao pode ser convertido em objeto'
    Return(.f.)
Endif

cVersaoCTE := oXML:_CTEProc:_versao:TEXT  

cChave_Nfe  := SubStr(oxml:_CTEPROC:_CTE:_INFCTE:_ID:TEXT,4)
cProtoc     := oxml:_CTEPROC:_PROTCTE:_INFPROT:_NPROT:TEXT
cIdRCTe     := oxml:_CTEPROC:_PROTCTE:_INFPROT:_CSTAT:TEXT
cRetCTe     := oxml:_CTEPROC:_PROTCTE:_INFPROT:_XMOTIVO:TEXT
cAmbCTe     := oxml:_CTEPROC:_PROTCTE:_INFPROT:_TPAMB:TEXT

If Empty(cChave_Nfe)
	cErrorN := 'Chave de acesso do CTe não informada'
	Return(.f.)
EndIf     

If XmlChildEx( oXml:_CTEPROC:_CTE:_INFCTE:_EMIT, "_CNPJ" ) != Nil
    cCNPJ_FIL := oxml:_CTEPROC:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT 
EndIF 

aSm0 := FWLoadSM0()
nPos := Ascan(aSM0,{|x| Alltrim(x[18]) == Alltrim(cCNPJ_FIL)})			
//nPos := 1
cFilorig := aSm0[nPos,02] //SM0->M0_CODFIL
cfilant := cFilorig

If XmlChildEx( oXml:_CTEPROC:_CTE:_INFCTE:_EMIT, "_ENDEREMIT" ) != Nil
    cEstFil := UPPER(oxml:_CTEPROC:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_UF:TEXT )
EndIF 

cNatOp	:= PadR(oXml:_cteProc:_cte:_Infcte:_IDE:_NATOP:Text,45," ")

//Busca pelo cnpj do Tomador 

If XmlChildEx( oXml:_CTEPROC:_CTE:_INFCTE:_IDE, "_TOMA4" ) <> NIL
    cCNPJ_TOM := oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA4:_CNPJ:TEXT
    cEstTom   := UPPER(oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA4:_ENDERTOMA:_UF:TEXT)
ElseIF XmlChildEx( oXml:_CTEPROC:_CTE:_INFCTE, "_REM" ) <> NIL 
    If XmlChildEx( oXml:_CTEPROC:_CTE:_INFCTE:_REM, "_CNPJ" ) <> NIL
        cCNPJ_TOM := oXml:_CTEPROC:_CTE:_INFCTE:_REM:_CNPJ:TEXT 
    Elseif XmlChildEx( oXml:_CTEPROC:_CTE:_INFCTE:_REM, "_CPF" ) <> NIL
        cCNPJ_TOM := oXml:_CTEPROC:_CTE:_INFCTE:_REM:_CPF:TEXT 
    EndIf 

    cEstTom   := UPPER(oXml:_CTEPROC:_CTE:_INFCTE:_REM:_ENDERREME:_UF:TEXT)
EndIf 

If XmlChildEx( oXml:_CTEPROC:_CTE:_INFCTE:_DEST, "_CNPJ" ) <> NIL
    cCNPJ_DES := oXml:_CTEPROC:_CTE:_INFCTE:_DEST:_CNPJ:TEXT 
Elseif XmlChildEx( oXml:_CTEPROC:_CTE:_INFCTE:_DEST, "_CPF" ) <> NIL
    cCNPJ_DES := oXml:_CTEPROC:_CTE:_INFCTE:_DEST:_CPF:TEXT 
EndIf 

DBSelectArea("SA1")
DBSetOrder(3)
If DbSeek(xFilial("SA1")+cCNPJ_TOM)
	cCodCli		:= SA1->A1_COD
	cLjFornec	:= SA1->A1_LOJA
    cTipoCli    := SA1->A1_PESSOA
Endif

If nChama > 0
    DBSelectArea("SA1")
    DBSetOrder(3)
    If DbSeek(xFilial("SA1")+cCNPJ_DES)
        cCliDst		:= SA1->A1_COD
        cLojDst	    := SA1->A1_LOJA
    else 
        cNomeDst := oXml:_CTEPROC:_CTE:_INFCTE:_DEST:_XNOME:TEXT

        If XmlChildEx( oXml:_CTEPROC:_CTE:_INFCTE:_DEST, "_FONE" ) <> NIL
            cFoneDst := oXml:_CTEPROC:_CTE:_INFCTE:_DEST:_FONE:TEXT
        else 
            cFoneDst := '99999999' 
        EndIf 

        cCepDst  := oXml:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:_CEP:TEXT
        cCdMDst  := oXml:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:_CMUN:TEXT
        cPisDst  := oXml:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:_CPAIS:TEXT
        cESTDst  := oXml:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:_UF:TEXT
        cBaiDst  := oXml:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:_XBAIRRO:TEXT
        cMunDst  := oXml:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:_XMUN:TEXT
        cEndDst  := oXml:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:_XLGR:TEXT
        cTipoDs  := 'F'
        cPesDst  := if(len(cCNPJ_DES)>11,'J','F')
        cInsDst  := 'ISENTO'
        criaSA1()
    Endif
EndIf 

cNum	:= PadL(Alltrim(oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_NCT:TEXT),9,"0") //Nro da Nota
cSerie	:= PadR(oXml:_CTEProc:_CTE:_InfCTE:_IDE:_Serie:Text,3," ")
cNotaG  := cNum


//Adicionado por Andre Vicente 31/07/2024 
//Validar cliente nao cadastrado
If EMPTY(cCodCli)
    cErrorN := "CNPJ do Cliente não Cadastrado NR - " + cCNPJ_TOM
    If nChama == 0
        //Gravo Chave para reprocessamento apos cadastrar cliente
        DbSelectArea("ZPH")
        DbSetOrder(1)
        If !Dbseek(cFilorig+cNum+cSerie+cCodCli+cLjFornec)
            RecLock("ZPH",.T.)
            ZPH->ZPH_FILIAL := cFilorig
            ZPH->ZPH_DOC    := cNum
            ZPH->ZPH_SERIE  := cSerie
            ZPH->ZPH_FORNEC := cCodCli
            ZPH->ZPH_LOJA   := cLjFornec
            ZPH->ZPH_XML    := cXmlRec
            ZPH->ZPH_STATUS := '0'
            ZPH->ZPH_DATA   := ddatabase
            ZPH->ZPH_HORA   := cvaltochar(time())
            ZPH->ZPH_LOG    := cErrorN
            ZPH->ZPH_CHVCTE := cChave_Nfe
            ZPH->(Msunlock())
        EndIf
        Return(.F.)
    Endif    
Endif 


// ************ Verifica se já existe essa NF na base de dados ***************
// filial doc serie cliente loja
DbSelectArea("SF2")
DbSetOrder(1)
If Dbseek(cFilorig+cNum+cSerie+cCodCli+cLjFornec)
    cNfExst := cNum
    cErrorN := 'CTe já lançado'
    If nChama == 0
        Return(.F.)
    else 
        lLancado := .T.
    EndIf 
EndIf 

cDtEmissao	:= oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_dhEmi:Text
cHrEmissao  := substr(cDtEmissao,12,5)
cDtEmissao	:= Substr(cDtEmissao,9,2)+"/"+Substr(cDtEmissao,6,2)+"/"+Substr(cDtEmissao,1,4)
            
nTotalMerc      := Val(oXml:_CTEPROC:_CTE:_INFCTE:_VPREST:_VTPREST:Text)

If XmlChildEx( oXml:_CTEPROC:_CTE:_INFCTE:_IDE, "_InfCTeNorm" ) 
    nValCarga       := Val(oXML:_CTEPROC:_CTE:_InfCte:_InfCTeNorm:_InfCarga:_vCarga:Text)
endif

If XmlChildEx( oXml:_CTEPROC:_CTE:_INFCTE:_VPREST, "_COMP" ) != Nil
    aImposto := oXml:_CTEPROC:_CTE:_INFCTE:_VPREST:_COMP
    For nCont := 1 to len(aImposto)
        cTexto := aImposto[nCont]:_XNOME:TEXT
        cConteudo := aImposto[nCont]:_VCOMP:TEXT
        Aadd(aImpCte,{cTexto,cConteudo})
    next nCont
endif 

If XmlChildEx( oXml:_CTEPROC:_CTE:_INFCTE:_IDE, "_CFOP" ) != Nil
    cCfopFrt := oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_CFOP:TEXT 
EndIF

If XmlChildEx( oXml:_CTEPROC:_CTE:_INFCTE:_IDE, "_UFINI" ) != Nil
    cEstIni := upper(oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_UFINI:TEXT)
ENDIF

If XmlChildEx( oXml:_CTEPROC:_CTE:_INFCTE:_IDE, "_UFFIM" ) != Nil
    cEstFim := upper(oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_UFFIM:TEXT)
ENDIF


//Regra incluido por Andre Vicente Grupo 377 
// Pega municipio de origem e destino da carga gravo da SF2 para ser utilizado no sped D100
If XmlChildEx( oXml:_CTEPROC:_CTE:_INFCTE:_IDE, "_CMUNINI" ) != Nil //<cMunIni>3550308</cMunIni>
    cMunIniCTE := oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_CMUNINI:TEXT
EndIf 

If XmlChildEx( oXml:_CTEPROC:_CTE:_INFCTE:_IDE, "_CMUNFIM" ) != Nil //<cMunFim>3304557</cMunFim>
    cMunFimCTE := oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_CMUNFIM:TEXT
EndIf 

If XmlChildEx( oXml:_CTEPROC:_CTE:_INFCTE:_EMIT:_ENDEREMIT, "_CMUN" ) != Nil
    cMunIni := oXml:_CTEPROC:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_CMUN:TEXT
EndIf 

If XmlChildEx( oXml:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST, "_CMUN" ) != Nil
    cMunFim := oXml:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:_CMUN:TEXT
EndIf 

If XmlChildEx( oXml:_CTEPROC:_CTE:_INFCTE, "_INFCTENORM" ) != Nil
    If XmlChildEx( oXml:_CTEPROC:_CTE:_INFCTE:_INFCTENORM, "_INFCARGA" ) != Nil
        If XmlChildEx( oXml:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFCARGA, "_INFQ" ) != Nil
            aPesos := oXml:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFCARGA:_INFQ

            For nCont := 1 to len(aPesos)
                cTexto := aPesos[nCont]:_TPMED:TEXT
                cConteudo := aPesos[nCont]:_QCARGA:TEXT
                Aadd(aPeCTe,{cTexto,cConteudo})
            Next nCont 
        EndIf 
    EndIF 
EndIf 

For nCont := 1 to len(aCSTTipo)
    If XmlChildEx( oXml:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS, "_ICMS"+aCSTTipo[nCont] ) <> Nil 
        cCstCte := &("oXml:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS"+aCSTTipo[nCont]+":_CST:TEXT")
    EndIf 
Next nCont

//Saida contorno para tratamento de quando há um cst novo.
If Empty(cCstCte)
    For nCont := 1 to 99
        nPosX := Ascan(aCSTTipo,{|x| x == Strzero(nCont,2)})
        If nPosX == 0
            If XmlChildEx( oXml:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS, "_ICMS"+strzero(nCont,2) ) <> Nil 
                cCstCte := &("oXml:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS"+strzero(nCont,2)+":_CST:TEXT")
            EndIf 
        EndIf 
    Next nCont 
EndIf 

If ValType(XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_Imp:_ICMS,"_ICMS00")) == "O" //--ICMS Tributado
	nValBC	:= Val(oXML:_CTEPROC:_CTE:_INFCTE:_Imp:_ICMS:_ICMS00:_vBC:Text)
	nValImp := Val(oXML:_CTEPROC:_CTE:_INFCTE:_Imp:_ICMS:_ICMS00:_vICMS:Text)
	nAlqICMS:= Val(oXml:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_PICMS:TEXT)
ElseIf ValType(XmlChildEx(oXML:_CTEPROC:_CTE:_InfCTe:_Imp:_ICMS,"_ICMSOUTRAUF")) == "O" //--ICMS Outra UF
	nValBC	:= Val(oXML:_CTEPROC:_CTE:_INFCTE:_Imp:_ICMS:_ICMSOUTRAUF:_vBCOutraUF:Text)
	nValImp := Val(oXML:_CTEPROC:_CTE:_INFCTE:_Imp:_ICMS:_ICMSOUTRAUF:_vICMSOUTRAUF:Text)
	nAlqICMS:= Val(oXml:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMSOUTRAUF:_PICMSOUTRAUF:TEXT)
ElseIf ValType(XmlChildEx(oXML:_CTEPROC:_CTE:_InfCTe:_Imp:_ICMS,"_ICMS60")) == "O" //--ICMS Outra UF
	nValBC	:= Val(oXML:_CTEPROC:_CTE:_INFCTE:_Imp:_ICMS:_ICMS60:_vBCSTRET:Text)
	nValImp := Val(oXML:_CTEPROC:_CTE:_INFCTE:_Imp:_ICMS:_ICMS60:_vICMSSTRET:Text)
	nAlqICMS:= Val(oXml:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_PICMSSTRET:TEXT)
ElseIf ValType(XmlChildEx(oXML:_CTEPROC:_CTE:_InfCTe:_Imp:_ICMS,"_ICMS90")) == "O" //--ICMS Outra UF
	nValBC	:= Val(oXML:_CTEPROC:_CTE:_INFCTE:_Imp:_ICMS:_ICMS90:_vBC:Text)
	nValImp := Val(oXML:_CTEPROC:_CTE:_INFCTE:_Imp:_ICMS:_ICMS90:_vICMS:Text)
	nAlqICMS:= Val(oXml:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_PICMS:TEXT)				
EndIf

If !Empty(cEstIni) .And. !Empty(cEstFim) .And. !Empty(cCstCte)
    cTesCTe := BuscaTes(cEstFil,cCfopFrt,cEstIni,cEstFim,cCstCte,cMunIni,cMunFim,cEstTom,cFilorig,nTotalMerc)
EndIf 

If nChama == 0
    If !Empty(cTesCTe)
        lRet := .T. //GerarCte()
        DbSelectArea("ZPH")
        DbSetOrder(1)
        If !Dbseek(cFilorig+cNum+cSerie+cCodCli+cLjFornec)
            RecLock("ZPH",.T.)
            ZPH->ZPH_FILIAL := cFilorig
            ZPH->ZPH_DOC    := cNum
            ZPH->ZPH_SERIE  := cSerie
            ZPH->ZPH_FORNEC := cCodCli
            ZPH->ZPH_LOJA   := cLjFornec
            ZPH->ZPH_XML    := cXmlRec
            ZPH->ZPH_STATUS := '0' //If(lRet,'1','0')
            ZPH->ZPH_DATA   := ddatabase
            ZPH->ZPH_HORA   := cvaltochar(time())
            ZPH->ZPH_LOG    := cErrorN
            ZPH->ZPH_CHVCTE := ALLTRIM(cChave_Nfe)
            ZPH->(Msunlock())
        Else
           //Como inclui ZPH no momento que nao há cliente,se entrar de novo ele atualiza status 
           If Dbseek(cFilorig+cNum+cSerie+cCodCli+cLjFornec)
                RecLock("ZPH",.F.)
                ZPH->ZPH_STATUS := '0' //If(lRet,'1','0')
                ZPH->ZPH_DATA   := ddatabase
                ZPH->ZPH_HORA   := cvaltochar(time())
                ZPH->(Msunlock())
           EndIf
 
        EndIf

    Else 
        cErrorN := 'Nao encontrada combinação para tes'
        lRet := .F.
        DbSelectArea("ZPH")
        DbSetOrder(1)
        If !Dbseek(cFilorig+cNum+cSerie+cCodCli+cLjFornec)
            RecLock("ZPH",.T.)
            ZPH->ZPH_FILIAL := cFilorig
            ZPH->ZPH_DOC    := cNum
            ZPH->ZPH_SERIE  := cSerie
            ZPH->ZPH_FORNEC := cCodCli
            ZPH->ZPH_LOJA   := cLjFornec
            ZPH->ZPH_XML    := cXmlRec
            ZPH->ZPH_STATUS := '0'
            ZPH->ZPH_DATA   := ddatabase
            ZPH->ZPH_HORA   := cvaltochar(time())
            ZPH->ZPH_LOG    := cErrorN
            ZPH->ZPH_CHVCTE := ALLTRIM(cChave_Nfe)
            ZPH->(Msunlock())
        EndIf
        
    EndIf
ElseIf nChama == 1
    
    IF Type('cErrorN') != "C" 
       cErrorN := 'Sem erro'
    Endif

    lRet := {cFilorig,cEstFil,cCfopFrt,cEstIni,cEstFim,cMunIni,cMunFim,cCstCte,cEstTom,nTotalMerc,cTesCTe,lLancado,cChave_Nfe,cErrorN}

    //Incluido por Andre Vicente 12/08/2024
    // Ao reprocessar nao estava incluindo o codigo do cliente cadastrado posteriormente
    If !Empty(cTesCTe) .AND. !Empty(cCodCli)
            /*If !lLancado
                lRetorno := GerarCte()
            Endif*/

            //Adicionado por Andre Vicente 377
            //Correçao para lançamento que tiverem ja lançado mais com status de represado ainda.
            If lLancado
                DbSelectArea("ZPH")
                DbSetOrder(1)
                If Dbseek(cFilorig+cNum+cSerie+cCodCli+cLjFornec)
                    If ZPH->ZPH_STATUS = '0'
                        RecLock("ZPH",.F.)
                        ZPH->ZPH_STATUS := '1'
                        ZPH->ZPH_CHVCTE := ALLTRIM(cChave_Nfe)
                        ZPH->(Msunlock())
                    Endif
                EndIf
            Endif
            If lRetorno
                //Ajustar Reprocessamento aqu
                DbSelectArea("ZPH")
                DbSetOrder(2)
                If ZPH->(MSSeek(cFilorig+cChave_Nfe))
                    RecLock("ZPH",.F.)
                    ZPH->ZPH_FILIAL := cFilorig
                    ZPH->ZPH_DOC    := cNum
                    ZPH->ZPH_SERIE  := cSerie
                    ZPH->ZPH_FORNEC := cCodCli
                    ZPH->ZPH_LOJA   := cLjFornec
                    ZPH->ZPH_STATUS := If(lRetorno,'1','0')
                    ZPH->(Msunlock())
                EndIf
            Endif
    Endif
Else 
    If !Empty(cTesCTe)
        lRet := GerarCte()
    EndIf 
EndIf 

Return(lRet)

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 24/11/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function GetErro()

Local cPath	:= GetSrvProfString("Startpath","")
Local cArq	:= "Erro_Rot_Auto_"+Dtos(dDataBase)+"_"+StrTran(Time(),":","_")+Alltrim(Str(ThreadID()))+".txt"
Local cRet	:= ""

MostraErro( cPath , cArq )

cRet := StrTran(MemoRead(  cPath + '\' + cArq ),Chr(13) + Chr(10)," ")
cRet := StrTran(cRet, '"', "'")

fErase(cArq)

Return cRet

/*/{Protheus.doc} BuscaTes

    @type  Static Function
    @author user
    @since 22/03/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function BuscaTes(cEstFil,cCfopFrt,cEstIni,cEstFim,cCstCte,cMunIni,cMunFim,cEstTom,cFilorig,nTotalMerc)

Local cRet := ''
Local lIntEst := cEstIni == cEstFim //Operação interestadual
Local cQuery 

cCombina := 'Filial - '+cFilorig+' / Est Fil - '+cEstFil+' / CFOP - '+cCfopFrt+' / Est Ini - '+cEstIni+' / Est Fim - '+cEstFim
cCombina += ' / CST - '+cCstCte+' / cMunIni - '+cMunIni+' / cMunFim - '+cMunFim+' / Est Tom '+cEstTom + ' / Valor - '+cvaltochar(nTotalMerc)

cQuery := "SELECT ZPG_TES "
cQuery += " FROM "+RetSQLName("ZPG")
cQuery += " WHERE ZPG_FILIAL='"+xFilial("ZPG")+"' AND D_E_L_E_T_=' '"
cQuery += " AND ZPG_CFOP='"+cCfopFrt+"'"
cQuery += " AND ZPG_ESTFIL='"+cEstFil+"'"
cQuery += " AND ZPG_ESTTOM IN('*','"+cEstTom+"')"
cQuery += " AND ZPG_CSTOPE='"+cCstCte+"'"

If !lIntEst
    cQuery += " AND ZPG_TIPOOP='1'"
Else 
    cQuery += " AND ZPG_TIPOOP='2'"
EndIf 

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("JFISM001.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")  

If !Empty(TRB->ZPG_TES)
    cRet := TRB->ZPG_TES 
    cCombina += ' / TES - '+TRB->ZPG_TES 
//Else    
    //solicitado em 25/04 para não colocar uma tes generica quando nao encontrar a combinação
    //gravar em uma tabela transitoria para posterior ajuste pelo usuario
    /*cRet := '501'
    cCombina += ' / TES - Nao encontrada combinação' */
EndIf 

Return(cRet)

/*/{Protheus.doc} GerarCte
    (long_description)
    @type  Static Function
    @author user
    @since 22/03/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function GerarCte()

//Local aCabec    := {}
//Local aItensT   := {}   
//Local aLinha    := {}
Local aCab      :=  {}
Local lRet      := .T.
Local lCont     := .T.
Local cProdCTe  :=  SuperGetMv("TI_PRODCTE",.F.,"S0500001")
Local nPesCB    :=  ascan(aPeCte,{|x| 'PESO'$ x[1] .AND. 'CUB' $ X[1]  })
Local nPesTx    :=  ascan(aPeCte,{|x| 'PESO'$ x[1] .AND. 'TAX' $ X[1]  })
Local nVolm     :=  ascan(aPeCte,{|x| 'VOLUM'$ x[1] })
Local nPosFV    :=  ascan(aImpCte,{|x| 'FRETE VALOR' $ x[1]})
Local nPosIV    :=  ascan(aImpCte,{|x| 'IMP REPASSA' $ x[1]})
Local aItemDTC  :=  {}
Local aItem     :=  {}
Local cRet      :=  ""
Local aCabDTC   :=  {}
Local cCdOrFr   := ""
Local cCdFmFr   := ""
Local nPosReg   := Ascan(aEstReg,{|x| x[1] == cEstIni})
Local nPosFim   := Ascan(aEstReg,{|x| x[1] == cEstFim})
Local aVetDoc   := {}
Local aVetVlr   := {}
Local aVetNFc   := {}
Local aDocOri   := {}

Private lMsErroAuto :=  .F.

//CLIENTE DESTINATARIO DEVE SER CADASTRADO E 
//DEVE-SE UTILIZAR A TABELA DUL PARA CADASTRAR ENDEREÇOS COMPLEMENTARES.

DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1")+cCodCli+cLjFornec)

If Empty(A1_CDRDES)
    If nPosReg > 0
        Reclock("SA1",.F.)
        SA1->A1_CDRDES := aEstReg[nPosReg,2]+substr(cMunIni,3)
        cCdOrFr := aEstReg[nPosReg,2]+substr(cMunIni,3)
        SA1->(Msunlock())
    Else 
        MsgAlert("Municipio não cadastrado na tabela DUY")
        lRet := .F.
        Return(lRet)
    EndIf 
Else
    cCdOrFr := SA1->A1_CDRDES
EndIf 

If nPosFim > 0
    cCdFmFr := aEstReg[nPosFim,2]+substr(cMunFim,3)
EndIf 

AAdd(aCab,{'DTP_QTDLOT',1,NIL})
AAdd(aCab,{'DTP_QTDDIG',0,NIL})
AAdd(aCab,{'DTP_STATUS','1',NIL}) //-- Em aberto

MsExecAuto({|x,y|cRet := TmsA170(x,y)},aCab,3)

If lMsErroAuto

    MostraErro()

    lCont := .F.

Else

    cLotNfc := cRet

EndIf

If lCont

		lMsErroAuto := .F.
		DbSelectArea("DTC")

		aCabDTC := {{"DTC_FILIAL" ,xFilial("DTC") 					    , Nil},;
					{"DTC_FILORI" ,CFILANT 							    , Nil},;
                    {"DTC_LOTNFC" ,cLotNfc 							    , Nil},;
                    {"DTC_CLIREM" ,Padr(cCodCli,Len(DTC->DTC_CLIREM))	, Nil},;
                    {"DTC_LOJREM" ,Padr(cLjFornec ,Len(DTC->DTC_LOJREM)), Nil},;
                    {"DTC_DATENT" ,dDataBase 						    , Nil},;
                    {"DTC_CLIDES" ,Padr(cCliDst,Len(DTC->DTC_CLIREM))	, Nil},;
                    {"DTC_LOJDES" ,Padr(cLojDst,Len(DTC->DTC_LOJREM))   , Nil},;
                    {"DTC_CLIDEV" ,Padr(cCodCli,Len(DTC->DTC_CLIREM))	, Nil},;
                    {"DTC_LOJDEV" ,Padr(cLjFornec ,Len(DTC->DTC_LOJREM)), Nil},;
                    {"DTC_CLICAL" ,Padr(cCodCli,Len(DTC->DTC_CLIREM))	, Nil},;
                    {"DTC_LOJCAL" ,Padr(cLjFornec ,Len(DTC->DTC_LOJREM)), Nil},;
                    {"DTC_NUMNFC" ,cNum 							    , Nil},;
                    {"DTC_SERNFC" ,cSerie							    , Nil},;
                    {"DTC_DOCTMS" ,'2'								    , Nil},;
                    {"DTC_DEVFRE" ,"1" 								    , Nil},;
                    {"DTC_SERTMS" ,"3" 								    , Nil},;
                    {"DTC_TIPTRA" ,"1" 								    , Nil},;
                    {"DTC_TIPNFC" ,"0" 								    , Nil},;
                    {"DTC_TIPFRE" ,"1" 								    , Nil},;
                    {"DTC_CODNEG" ,"01" 							    , Nil},;
                    {"DTC_SELORI" ,"1" 								    , Nil},;
                    {"DTC_CDRORI" ,cCdOrFr              			    , Nil},;
                    {"DTC_CDRDES" ,cCdFmFr		                        , Nil},;
                    {"DTC_CDRCAL" ,cCdFmFr              			    , Nil},;
					{"DTC_NFENTR" ,'1'								    , Nil},;
					{"DTC_TIPAGD" ,'1'								    , Nil},;
					{"DTC_DOCREE" ,'2'								    , Nil},;
					{"DTC_RETIRA" ,'1'								    , Nil},;
					{"DTC_INVORI" ,'2'								    , Nil},;
                    {"DTC_SERVIC" ,"018" 							    , Nil},;
                    {"DTC_DISTIV" ,'2'								    , Nil}}
//
//					
                    
		aItem := {{"DTC_NUMNFC" 	,cNum							, Nil},;
                    {"DTC_SERNFC" 	,cSerie							, Nil},;
                    {"DTC_CODPRO" 	,cProdCTe						, Nil},;
					{"DTC_CF" 		,cCfopFrt						, Nil},;
                    {"DTC_CODEMB" 	,"CX" 							, Nil},;
                    {"DTC_EMINFC" 	,ctod(cDtEmissao) 				, Nil},;
                    {"DTC_QTDVOL" 	,If(nVolm>0,val(aPeCTe[nVolm,2]),0)		, Nil},;
                    {"DTC_PESO" 	,If(nPesTx>0,val(aPeCTe[nPesTx,2]),0)	, Nil},;
                    {"DTC_PESOM3" 	,If(nPesCB>0,val(aPeCTe[nPesCB,2]),0)   , Nil},;
                    {"DTC_VALOR" 	,nTotalMerc						, Nil},;
                    {"DTC_BASSEG" 	,0.00 							, Nil},;
                    {"DTC_METRO3" 	,0.0000							, Nil},;
                    {"DTC_QTDUNI" 	,0 								, Nil},;
					{"DTC_MOEDA" 	,1 								, Nil},;
                    {"DTC_NFEID"    ,cChave_Nfe					    , Nil},;
					{"DTC_EDI" 		,"2" 							, Nil}}

		AAdd(aItemDTC,aClone(aItem))
//
    // Parametros da TMSA050 (notas fiscais do cliente)
    // xAutoCab - Cabecalho da nota fiscal
    // xAutoItens - Itens da nota fiscal
    // xItensPesM3 - acols de Peso Cubado
    // xItensEnder - acols de Enderecamento
    // nOpcAuto - Opcao rotina automatica

    MSExecAuto({|u,v,x,y,z| TMSA050(u,v,x,y,z)},aCabDTC,aItemDTC,,,3)

    If lMsErroAuto
        MostraErro()
        lCont := .F.
    Else
        //DTC_FILIAL+DTC_FILORI+DTC_LOTNFC+DTC_CLIREM+DTC_LOJREM+DTC_CLIDES+DTC_LOJDES+DTC_SERVIC+DTC_CODPRO+DTC_NUMNFC+DTC_SERNFC
        DbselectArea("DTC")
        DbSetOrder(1)
        Dbseek(xFilial("DTC")+cFilant+cLotNfc)

        
        DbSelectArea("DTP")
        DbSetOrder(2)
        Dbseek(xFilial("DTP")+cFilant+cLotNfc)
        //TMSA050Sub(1)
        DTC->(dbCommit())
    EndIf

    If lCont
		AAdd(aVetDoc,{"DT6_FILORI",CFILANT  })
		AAdd(aVetDoc,{"DT6_LOTNFC",cLotNfc  })
		AAdd(aVetDoc,{"DT6_FILDOC",CFILANT  })
		AAdd(aVetDoc,{"DT6_DOC"   ,cNum     })
		AAdd(aVetDoc,{"DT6_SERIE" ,cSerie   })
		AAdd(aVetDoc,{"DT6_DATEMI",ctod(cDtEmissao)})
		AAdd(aVetDoc,{"DT6_HOREMI",strtran(time(),":")})
		AAdd(aVetDoc,{"DT6_VOLORI", nTotalMerc})
		AAdd(aVetDoc,{"DT6_QTDVOL", If(nVolm>0,val(aPeCTe[nVolm,2]),0)})
		AAdd(aVetDoc,{"DT6_PESO" , If(nPesTx>0,val(aPeCTe[nPesTx,2]),0)})
		AAdd(aVetDoc,{"DT6_PESOM3", If(nPesCB>0,val(aPeCTe[nPesCB,2]),0)})
		AAdd(aVetDoc,{"DT6_PESCOB", 0.0000})
		AAdd(aVetDoc,{"DT6_METRO3", 0.0000})
		AAdd(aVetDoc,{"DT6_VALMER", nValCarga}) //nTotalMerc
		AAdd(aVetDoc,{"DT6_QTDUNI", 0})
		AAdd(aVetDoc,{"DT6_VALFRE", nTotalMerc})  //If(nPosFV>0,val(aImpCte[nPosFV,2]),0)
		AAdd(aVetDoc,{"DT6_VALIMP", nValImp})  //If(nPosIV>0,val(aImpCte[nPosIV,2]),0)
		AAdd(aVetDoc,{"DT6_VALTOT", nTotalMerc})
		AAdd(aVetDoc,{"DT6_BASSEG", 0.00})
		AAdd(aVetDoc,{"DT6_SERTMS","2"})
		AAdd(aVetDoc,{"DT6_TIPTRA","1"})
		AAdd(aVetDoc,{"DT6_DOCTMS","2"})
		AAdd(aVetDoc,{"DT6_CDRORI",cCdOrFr  })
		AAdd(aVetDoc,{"DT6_CDRDES",cCdFmFr  })
		AAdd(aVetDoc,{"DT6_CDRCAL",cCdFmFr  })
		AAdd(aVetDoc,{"DT6_TABFRE","2024"})
		AAdd(aVetDoc,{"DT6_TIPTAB","01"})
		AAdd(aVetDoc,{"DT6_SEQTAB","00"})
		AAdd(aVetDoc,{"DT6_TIPFRE","1"})
		AAdd(aVetDoc,{"DT6_FILDES",CFILANT  })
		AAdd(aVetDoc,{"DT6_BLQDOC","2"})
		AAdd(aVetDoc,{"DT6_PRIPER","2"})
		AAdd(aVetDoc,{"DT6_PERDCO", 0.00000})
		AAdd(aVetDoc,{"DT6_FILDCO",""})
		AAdd(aVetDoc,{"DT6_DOCDCO",""})
		AAdd(aVetDoc,{"DT6_SERDCO",""})
		AAdd(aVetDoc,{"DT6_CLIREM",DTC->DTC_CLIREM}) //Padr("001",Len(DTC->DTC_CLIREM))})
		AAdd(aVetDoc,{"DT6_LOJREM",DTC->DTC_LOJREM}) //Padr("01" ,Len(DTC->DTC_LOJREM))})
		AAdd(aVetDoc,{"DT6_CLIDES",DTC->DTC_CLIREM}) //Padr("002",Len(DTC->DTC_CLIREM))})
		AAdd(aVetDoc,{"DT6_LOJDES",DTC->DTC_LOJREM}) //Padr("01" ,Len(DTC->DTC_LOJREM))})
		AAdd(aVetDoc,{"DT6_CLIDEV",DTC->DTC_CLIREM}) //Padr("001",Len(DTC->DTC_CLIREM))})
		AAdd(aVetDoc,{"DT6_LOJDEV",DTC->DTC_LOJREM}) //Padr("01" ,Len(DTC->DTC_LOJREM))})
		AAdd(aVetDoc,{"DT6_CLICAL",DTC->DTC_CLIREM}) //Padr("001",Len(DTC->DTC_CLIREM))})
		AAdd(aVetDoc,{"DT6_LOJCAL",DTC->DTC_LOJREM}) //Padr("01" ,Len(DTC->DTC_LOJREM))})
		AAdd(aVetDoc,{"DT6_DEVFRE","2"})
		AAdd(aVetDoc,{"DT6_FATURA",""})
		AAdd(aVetDoc,{"DT6_SERVIC","018"})
		AAdd(aVetDoc,{"DT6_CODMSG",""})
		AAdd(aVetDoc,{"DT6_STATUS","1"})
		AAdd(aVetDoc,{"DT6_DATEDI",CToD(" / / ")})
		AAdd(aVetDoc,{"DT6_NUMSOL",""})
		AAdd(aVetDoc,{"DT6_VENCTO",CToD(" / / ")})
		AAdd(aVetDoc,{"DT6_FILDEB",CFILANT})
		AAdd(aVetDoc,{"DT6_PREFIX",""})
		AAdd(aVetDoc,{"DT6_NUM" ,""})
		AAdd(aVetDoc,{"DT6_TIPO" ,""})
		AAdd(aVetDoc,{"DT6_MOEDA" , 1})
		AAdd(aVetDoc,{"DT6_BAIXA" ,CToD(" / / ")})
		AAdd(aVetDoc,{"DT6_FILNEG",CFILANT})
		AAdd(aVetDoc,{"DT6_ALIANC",""})
		AAdd(aVetDoc,{"DT6_REENTR", 0})
		AAdd(aVetDoc,{"DT6_TIPMAN",""})
		AAdd(aVetDoc,{"DT6_PRZENT",ctod(cDtEmissao)})
		AAdd(aVetDoc,{"DT6_FIMP" ,"0"})
        Aadd(aVetDoc,{"DT6_CHVCTE",cChave_Nfe})

		AAdd(aVetVlr,{{"DT8_CODPAS","01"},;
                        {"DT8_VALPAS", nTotalMerc},;
                        {"DT8_VALIMP", nValImp},; 
                        {"DT8_VALTOT", nTotalMerc},;
                        {"DT8_FILORI", cfilant},;
                        {"DT8_TABFRE","2024"},;
                        {"DT8_TIPTAB","01"},;
                        {"DT8_FILDOC",cfilant},;
                        {"DT8_CODPRO",cProdCTe},;
                        {"DT8_DOC" ,cNum},;
                        {"DT8_SERIE" ,cSerie},;
                        {"VLR_ICMSOL",0}})
        
        AAdd(aVetVlr,{{"DT8_CODPAS","TF"},;
                        {"DT8_VALPAS", nTotalMerc},;
                        {"DT8_VALIMP", nValImp},; 
                        {"DT8_VALTOT", nTotalMerc},;
                        {"DT8_FILORI", cfilant},;
                        {"DT8_TABFRE","2024"},;
                        {"DT8_TIPTAB","01"},;
                        {"DT8_FILDOC",cfilant},;
                        {"DT8_CODPRO",cProdCTe},;
                        {"DT8_DOC" ,cNum},;
                        {"DT8_SERIE" ,cSerie},;
                        {"VLR_ICMSOL",0}})

//If(nPosIV>0,val(aImpCte[nPosIV,2]),0)
//If(nPosFV>0,val(aImpCte[nPosFV,2]),0)
		

		AAdd(aVetNFc,{{"DTC_CLIREM",Padr("001",Len(DTC->DTC_CLIREM))},;
                        {"DTC_LOJREM",Padr("01" ,Len(DTC->DTC_LOJREM))},;
                        {"DTC_NUMNFC",Padr("011",Len(DTC->DTC_NUMNFC))},;
                        {"DTC_SERNFC",Padr("UNI" ,Len(DTC->DTC_SERNFC))},;
                        {"DTC_CODPRO",Padr("001" ,Len(DTC->DTC_CODPRO))},;
                        {"DTC_TIPNFC" ,"0" , Nil},;
                        {"DTC_QTDVOL", If(nVolm>0,val(aPeCTe[nVolm,2]),0)},;
                        {"DTC_PESO" , If(nPesTx>0,val(aPeCTe[nPesTx,2]),0)},;
                        {"DTC_PESOM3", If(nPesCB>0,val(aPeCTe[nPesCB,2]),0)},;
                        {"DTC_METRO3", 0.0000},;
                        {"DTC_VALOR" , nTotalMerc}})

		/*aDocOri:= { DTC->DTC_FILDOC,;   // [1] Filial Docto Original  (caracter)
                    DTC->DTC_DOC,;      // [2] No. Docto Original     (caracter)
                    DTC->DTC_SERIE,;    // [3] Serie Docto Original   (caracter)
                    nTotalMerc,;        // [4] % Docto. Orignal       (numerico)
                    .F.,;               // [5] Complemento de Imposto (lógico)
                    7 }                 // [6] nOpcx - TMSA500        (numerico)*/
        //aDocOri := {}

		aErrMsg := TMSImpDoc(aVetDoc,aVetVlr,aVetNFc,cLotNfc,.F.,0,1,.F.,.F.,.F.,.F. ) //aDocOri

        If len(aErrMsg) < 1 

			//-- Complemento SF2
			cQuery := " UPDATE " + RetSqlName("SF2") 				+ CRLF
			cQuery += "    SET F2_CHVNFE 	= '" + cChave_Nfe + "' "	+ CRLF
			cQuery += "      , F2_ESPECIE 	= 'CTE'  " 			  	+ CRLF
			cQuery += "  WHERE F2_FILIAL 	= '" + CFILANT + "'"  	+ CRLF
			cQuery += "    AND F2_DOC    	= '" + cNum   + "' " 	+ CRLF
			cQuery += "    AND F2_SERIE  	= '" + cSerie + "' " 	+ CRLF
			cQuery += "    AND D_E_L_E_T_ 	= ' ' "

			TCSqlExec( cQuery )

			//-- Complemento DT6
			cQuery := " UPDATE " + RetSqlName("DT6") 				+ CRLF
			cQuery += "    SET DT6_CHVCTE = '" + cChave_Nfe + "' "	+ CRLF
			cQuery += "    	 , DT6_PROCTE = '" + cProtoc + "' "	+ CRLF
			cQuery += "    	 , DT6_IDRCTE = '" + cIdRCTe + "' "	+ CRLF
			cQuery += "    	 , DT6_SITCTE = '2' "				+ CRLF//--Autorizado
			cQuery += "    	 , DT6_RETCTE = '" + cIdRCTe + ' - ' + cRetCTe + "' "	+ CRLF
			cQuery += "    	 , DT6_AMBIEN = '" + cAmbCTe + "' "	+ CRLF

			cQuery += "  WHERE DT6_FILIAL = '" + xFilial("DT6") + "' "			+ CRLF
			cQuery += "    AND DT6_FILORI = '" + CFILANT + "' " + CRLF
			cQuery += "    AND DT6_CLIDEV = '" + cCodcli + "' " + CRLF
			cQuery += "    AND DT6_LOJDEV = '" + cLjFornec + "' " + CRLF
			cQuery += "    AND DT6_DOC 	  = '" + cNum   + "' " 	+ CRLF
			cQuery += "    AND DT6_SERIE  = '" + cSerie + "' " 	+ CRLF
			cQuery += "    AND D_E_L_E_T_ = ' ' "				+ CRLF

			TCSqlExec( cQuery )

			cQuery := " UPDATE " + RetSqlName("SF3") 				+ CRLF
			cQuery += "    SET F3_CHVNFE  = '" + cChave_Nfe + "' "		+ CRLF
			cQuery += "    	 , F3_PROTOC  = '" + cProtoc + "' "		+ CRLF
			cQuery += "      , F3_CODRSEF = '100'  " 				+ CRLF
			cQuery += "    	 , F3_DESCRET = '100 - Autorizado o uso do CT-e'  " + CRLF
			cQuery += "      , F3_ESPECIE = 'CTE'  " 				+ CRLF
			cQuery += "  WHERE F3_FILIAL  = '" + CFILANT + "'" 		+ CRLF
			cQuery += "    AND F3_CLIEFOR = '" + cCodcli + "' " 	+ CRLF
			cQuery += "    AND F3_LOJA    = '" + cLjFornec + "' " 	+ CRLF
			cQuery += "    AND F3_NFISCAL = '" + cNum   + "' " 		+ CRLF
			cQuery += "    AND F3_SERIE   = '" + cSerie + "' "		+ CRLF
			cQuery += "    AND F3_CFO     > '5000' " 				+ CRLF
			cQuery += "    AND D_E_L_E_T_ = ' ' "					+ CRLF

			TCSqlExec( cQuery )

			cQuery := " UPDATE " + RetSqlName("SFT") + CRLF
			cQuery += "    SET FT_CHVNFE  = '" + cChave_Nfe + "' " + CRLF
			cQuery += "      , FT_ESPECIE = 'CTE' " 			+ CRLF

			
			cQuery += "  WHERE FT_FILIAL  = '" + CFILANT + "'" 	+ CRLF
			cQuery += "    AND FT_TIPOMOV = 'S' " 				+ CRLF
			cQuery += "    AND FT_SERIE   = '" + cSerie + "' " 	+ CRLF
			cQuery += "    AND FT_NFISCAL = '" + cNum   + "' " 	+ CRLF
			cQuery += "    AND FT_CLIEFOR = '" + cCodcli + "' " + CRLF
			cQuery += "    AND FT_LOJA    = '" + cLjFornec + "' " + CRLF
			cQuery += "    AND D_E_L_E_T_ = ' ' "

			TCSqlExec( cQuery )

		EndIf
    EndIF 

EndIf
/*
https://centraldeatendimento.totvs.com/hc/pt-br/articles/360007499431-Log%C3%ADstica-Linha-Protheus-TMS-Ponto-de-entrada-TM200DT6-Grava%C3%A7%C3%A3o-do-Documento-de-Transporte
*/
/*
aadd(aCabec,{"F2_FILIAL"    ,cFilorig   })
aadd(aCabec,{"F2_TIPO"      ,"N"        })
aadd(aCabec,{"F2_FORMUL"    ,"N"        })
aadd(aCabec,{"F2_DOC"       ,cNum       })
aadd(aCabec,{"F2_SERIE"     ,cSerie     })
aadd(aCabec,{"F2_EMISSAO"   ,CTOD(cDtEmissao)})
aadd(aCabec,{"F2_CLIENTE"   ,cCodCli    })
aadd(aCabec,{"F2_TIPOCLI"   ,cTipoCli   })
aadd(aCabec,{"F2_LOJA"      ,cLjFornec  })
aadd(aCabec,{"F2_ESPECIE"   ,cEspecie   })
aadd(aCabec,{"F2_COND"      ,"001"      })
aadd(aCabec,{"F2_VALBRUT"   ,nTotalMerc })
aadd(aCabec,{"F2_VALFAT"    ,nTotalMerc })      
aadd(aCabec,{"F2_HORA"      ,cHrEmissao })
aadd(aCabec,{"F2_CHVNFE"    ,cChave_Nfe })

aadd(aLinha,{"D2_FILIAL"    ,cFilorig   ,Nil}) 
aadd(aLinha,{"D2_ITEM"      ,"01"       ,Nil})
aadd(aLinha,{"D2_COD"       ,cProdCTe   ,Nil})
aadd(aLinha,{"D2_QUANT"     ,1          ,Nil})
aadd(aLinha,{"D2_PRCVEN"    ,nTotalMerc ,Nil})
aadd(aLinha,{"D2_TOTAL"     ,nTotalMerc ,Nil})
aadd(aLinha,{"D2_TES"       ,cTesCTe    ,Nil})
aadd(aLinha,{"D2_CF"        ,cCfopFrt   ,Nil})
            
aadd(aItensT,aLinha)
        
lMsErroAuto := .F.

MSExecAuto({|x,y,z| mata920(x,y,z)},aCabec,aItensT,3) 

If lMsErroAuto 
    cErrorN := GetErro()
    lRet := .F.
Else 
 
    SF2->(DbSetOrder(1))
  	//MsSeek(xFilial()+cNum+cSerie+cCodCli+cLjFornec)
    If SF2->(DbSeek(xFilial("SF2") +cNum+cSerie+cCodCli+cLjFornec ))
        RecLock("SF2", .F.)
        SF2->F2_CMUNOR := Substr(cMunIniCTE,3,5)  
        SF2->F2_CMUNDE := Substr(cMunFimCTE,3,5)  
        SF2->F2_UFDEST := Alltrim(cEstFim)  
        SF2->F2_UFORIG := Alltrim(cEstIni)  
        SF2->(MsUnLock())          
    Endif	

EndIf 
*/


Return(lRet)

/*
    funcao para validar a combinação de tes
    utilizada tambem para reaproveitar o código de geração do cte
    quando chamado pela rotina de configuração de tes para o tracker (JFISM001)
*/
user function xvldws13(nOpc,cXml,nTipo,nRecZPH)

Local cError := ''
Local cWarning := ''
Local cNota  := ''
Local aRet  := {}

Private oXml 
Default nOpc := 0
Default cXMl := ''
Default nTipo := 1

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","00080242")
EndIf

If nOpc == 0
    aSm0 := FWLoadSM0()
    //nPos := Ascan(aSM0,{|x| Alltrim(x[18]) == Alltrim(cCNPJ_FIL)})			
    nPos := 1
    cFilorig := aSm0[nPos,02] //SM0->M0_CODFIL
    cEstFil  := Alltrim(aSm0[nPos,04])
    CFILANT  := cFilorig 
    //cEstFil,cCfopFrt,cEstIni,cEstFim,cCstCte,cMunIni,cMunFim,cEstTom,cFilorig,nTotalMerc
    BuscaTes('MG','6357','MG','RJ','00','3151206','3303500','MG',cFilorig,0)
Else 
    oXml := XmlParser( cXml, "_", @cError, @cWarning )
    If oXml == Nil 
        DbSelectArea("ZPH")
        If valtype(nRecZPH) == "C"
            nRecZPH := val(nRecZPH)
        EndIf 
        DbGoto(nRecZPH)
        cXml := ZPH->ZPH_XML
        oXml := XmlParser( cXml, "_", @cError, @cWarning )
    EndIf 
    aRet := XMLCTE(oXml,@cNota, @cError ,nTipo)
EndIf 

Return(aRet)


/*/{Protheus.doc} BuscaS2()
    Busca tipos ICMS para validação no xml
    @type  Static Function
    @author user
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function BuscaS2()

Local aArea :=  GetArea()
Local aRet  :=  {}

DbSelectArea("SX5")
DbSetOrder(1)
If Dbseek(xFilial("SX5")+'S2')
    While !Eof() .And. SX5->X5_TABELA == 'S2'
        Aadd(aRet,Alltrim(SX5->X5_CHAVE))
        Dbskip()
    EndDo 

EndIf 

RestArea(aArea)

Return(aRet) 


/*/{Protheus.doc} BuscaReg
    (long_description)
    @type  Static Function
    @author user
    @since 14/10/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function BuscaReg()

Local aArea := GetArea()
Local cQuery 
Local aRet  := {}

cQuery := "SELECT SUBSTRING(DUY_GRPVEN,1,1) AS SIGLA,DUY_EST,COUNT(*)"
cQuery += " FROM "+RetSqlName("DUY")
cQuery += " WHERE DUY_FILIAL='"+xFilial("DUY")+"'"
cQuery += " AND DUY_EST<>' ' AND LEN(DUY_GRPVEN) > 2"
cQuery += " AND D_E_L_E_T_=' ' AND SUBSTRING(DUY_GRPVEN,1,2) <> 'FL'"
cQuery += " GROUP BY SUBSTRING(DUY_GRPVEN,1,1),DUY_EST"
cQuery += " ORDER BY 2"


IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("JFISM001.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB") 

While !EOF()
    Aadd(aRet,{TRB->DUY_EST,TRB->SIGLA})
    Dbskip()
EndDo 

RestArea(aAreA)

Return(aRet)

/*/{Protheus.doc} criaSA1()
    (long_description)
    @type  Static Function
    @author user
    @since 15/10/2024
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function criaSA1()

Local aArea     := GetArea()
Local cCodN     := GetSXENum("SA1","A1_COD")
Local cLojN     := "01"
Local aCliente  := {}
Local nPosFim   := Ascan(aEstReg,{|x| x[1] == cESTDst})
Local cCdFmFr   := aEstReg[nPosFim,2]+substr(cCdMDst,3)

Private lMsErroAuto := .F.

aCliente:={ {"A1_COD"    ,cCodN                                 ,Nil},;
            {"A1_LOJA"   ,cLojN                                 ,Nil},;
            {"A1_NOME"   ,Substr(cNomeDst,1,40)                 ,Nil},;
            {"A1_NREDUZ" ,Substr(cNomeDst,1,20)                 ,Nil},;
            {"A1_PESSOA" ,cPesDst                               ,Nil},;
            {"A1_TIPO"   ,cTipoDs								,Nil},;
            {"A1_END" 	 ,cEndDst                               ,Nil},;
            {"A1_EST"    ,cESTDst	    						,Nil},;
            {"A1_COD_MUN",substr(cCdMDst,3)						,Nil},;
            {"A1_MUN"    ,cMunDst                               ,Nil},;
            {"A1_BAIRRO" ,cBaiDst		                        ,Nil},;
            {"A1_CEP"    ,cCepDst   	                        ,Nil},;
            {"A1_DDD"    ,substr(cFoneDst,1,2)                  ,Nil},;
            {"A1_TEL"    ,substr(cFoneDst,3)                    ,Nil},;
            {"A1_CGC"    ,cCNPJ_DES                             ,Nil},;
            {"A1_INSCR"  ,cInsDst                               ,Nil},;
            {"A1_PAIS"   ,substr(cPisDst,1,3)                   ,Nil},;
            {"A1_CONTA"  ,'11201010010007'                      ,Nil},;
            {"A1_CONTRIB",'2'                                   ,Nil},;
            {"A1_CDRDES" ,cCdFmFr                               ,Nil},;
            {"A1_CODPAIS",'0'+cPisDst                           ,Nil}}

		
MSExecAuto({|x,y| Mata030(x,y)},aCliente,3) //Inclusao

If lMsErroAuto
    MostraErro()
Else
    cCliDst		:= cCodN
	cLojDst	    := cLojN
    ConfirmSX8()
Endif

RestArea(aArea)

Return

/*

    Ponto de entrada TMS para trocar a TES de acordo com as regras criadas pela JCA
    
*/
User Function TM200TES()
Local aNFCTRC			:= PARAMIXB[1] 
Local cCliRem 			:= PARAMIXB[2]
Local cLojRem			:= PARAMIXB[3]
Local cRegra			:= PARAMIXB[4]
Local cFrete			:= PARAMIXB[5]
Local cCliDev 			:= PARAMIXB[6]
Local cLojDev			:= PARAMIXB[7]

Default cTesCTe := ''

If !Empty(cTesCTe)
    cRegra := cTesCTe
EndIf

Return (cRegra)
