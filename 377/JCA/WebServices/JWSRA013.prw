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

Local lRet          := .t.
Local nCont         := 0
Private cFilorig    := '' 
Private cEspecie    := "CTE"
Private cVersaoCTE  := ''
Private cChave_Nfe  := ''
Private cCNPJ_FIL   := ''
Private cNatOp      := ''
Private cCNPJ_TOM   := ''
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
Private cTipoCli    := ''
Private aCSTTipo    := separa(SuperGetMV("TI_CSTCTE",.F.,"00/40/41/51"),"/")
Private cCstCte     := ''
Private cMunIni     := ''
Private cMunFim     := ''
Private cEstFil     := ''
Private cEstTom     := ''
Default nChama      := 0

If ValType(oXml) != "O"
    cErrorN := 'xml nao pode ser convertido em objeto'
    Return(.f.)
Endif

cVersaoCTE := oXML:_CTEProc:_versao:TEXT  

cChave_Nfe := SubStr(oxml:_CTEPROC:_CTE:_INFCTE:_ID:TEXT,4)

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

DBSelectArea("SA1")
DBSetOrder(3)
If DbSeek(xFilial("SA1")+cCNPJ_TOM)
	cCodCli		:= SA1->A1_COD
	cLjFornec	:= SA1->A1_LOJA
    cTipoCli    := SA1->A1_PESSOA
Endif

cNum	:= PadL(Alltrim(oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_NCT:TEXT),9,"0") //Nro da Nota
cSerie	:= PadR(oXml:_CTEProc:_CTE:_InfCTE:_IDE:_Serie:Text,3," ")
cNotaG  := cNum

// ************ Verifica se já existe essa NF na base de dados ***************
// filial doc serie cliente loja
DbSelectArea("SF2")
DbSetOrder(1)
If Dbseek(cFilorig+cNum+cSerie+cCodCli+cLjFornec)
    cNfExst := cNum
    cErrorN := 'CTe já lançado'
    Return(.F.)
EndIf 

cDtEmissao	:= oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_dhEmi:Text
cHrEmissao  := substr(cDtEmissao,12,5)
cDtEmissao	:= Substr(cDtEmissao,9,2)+"/"+Substr(cDtEmissao,6,2)+"/"+Substr(cDtEmissao,1,4)
            
nTotalMerc      := Val(oXml:_CTEPROC:_CTE:_INFCTE:_VPREST:_VTPREST:Text)

If XmlChildEx( oXml:_CTEPROC:_CTE:_INFCTE:_IDE, "_CFOP" ) != Nil
    cCfopFrt := oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_CFOP:TEXT 
EndIF

If XmlChildEx( oXml:_CTEPROC:_CTE:_INFCTE:_IDE, "_UFINI" ) != Nil
    cEstIni := upper(oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_UFINI:TEXT)
ENDIF

If XmlChildEx( oXml:_CTEPROC:_CTE:_INFCTE:_IDE, "_UFFIM" ) != Nil
    cEstFim := upper(oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_UFFIM:TEXT)
ENDIF

If XmlChildEx( oXml:_CTEPROC:_CTE:_INFCTE:_EMIT:_ENDEREMIT, "_CMUN" ) != Nil
    cMunIni := oXml:_CTEPROC:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_CMUN:TEXT
EndIf 

If XmlChildEx( oXml:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST, "_CMUN" ) != Nil
    cMunFim := oXml:_CTEPROC:_CTE:_INFCTE:_DEST:_ENDERDEST:_CMUN:TEXT
EndIf 

For nCont := 1 to len(aCSTTipo)
    If XmlChildEx( oXml:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS, "_ICMS"+aCSTTipo[nCont] ) <> Nil 
        cCstCte := &("oXml:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS"+aCSTTipo[nCont]+":_CST:TEXT")
    EndIf 
Next nCont

If !Empty(cEstIni) .And. !Empty(cEstFim) .And. !Empty(cCstCte)
    cTesCTe := BuscaTes(cEstFil,cCfopFrt,cEstIni,cEstFim,cCstCte,cMunIni,cMunFim,cEstTom,cFilorig,nTotalMerc)
EndIf 

If nChama == 0
    If !Empty(cTesCTe)
        lRet := GerarCte()
    Else 
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
            ZPH->(Msunlock())
        EndIf
        
        cErrorN := 'Nao encontrada combinação para tes'
        lRet := .F.
    EndIf
ElseIf nChama == 1
    lRet := {cFilorig,cEstFil,cCfopFrt,cEstIni,cEstFim,cMunIni,cMunFim,cCstCte,cEstTom,nTotalMerc,cTesCTe}
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

Local aCabec    := {}
Local aItensT   := {}   
Local aLinha    := {}
Local lRet      := .T.
Local cProdCTe  :=  SuperGetMv("TI_PRODCTE",.F.,"S0500001")

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
EndIf 

Return(lRet)

/*
    funcao para validar a combinação de tes
    utilizada tambem para reaproveitar o código de geração do cte
    quando chamado pela rotina de configuração de tes para o tracker (JFISM001)
*/
user function xvldws13(nOpc,cXml,nTipo)

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
    RPCSetEnv("01","00020087")
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

    aRet := XMLCTE(oXml,@cNota,'',nTipo)
EndIf 

Return(aRet)
