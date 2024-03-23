#Include 'Protheus.ch'
#Include 'RestFul.ch'
#Include "FwMvcDef.ch"
#include "fileio.ch"
/*
    API
    API para receber os dados de CTE e NFE a ser enviada pelo Tracker

    Doc Mit
   
    Doc Valida��o entrega
    
    
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
    Local aAux      :=  .F.
    Local nLinha 
    Local cError    :=  ''
    Local nCont
    Local cWarning  :=  ''
    Local oResponse     := JsonObject():New()
    Local oCampo        := JsonObject():New()
    Local lGerou        := .T.
    
    Private cNfExst     :=  ''

    RpcClearEnv()
    RpcSetType(3)
    //RPCSetEnv('01','00020087')
    RPCSetEnv('T1','D MG 01')

	::SetContentType("application/json")

    If lRet
        oBody  := JsonObject():New()
        oBody:fromJson(cJson) 

        cTipo      := oBody:getJsonText("tipo")
        cDoc       := oBody:getJsonText("fatura")
        
        For nCont := 1 to len(oBody['itens'])
            cXmlRec    := oBody['itens'][nCont]:getJsonText("xml")
            cPathXml   := oBody['itens'][nCont]:getJsonText("pathxml")
        
            If Empty(cXmlRec) .and. Empty(cPathXml)
                lRet		:= .F.
                oResponse['code'] := "#400"
                oResponse['status'] := 500
                oResponse['message'] := '#erro_json'
                oResponse['detailedMessage'] := 'N�o foi informado o xml e endere�o do xml'
            Else 
                cXmlRec := Decode64(cXmlRec)
                cXmlRec := fRemoveCarc(cXmlRec)

                oXml := XmlParser( cXmlRec, "_", @cError, @cWarning )
                
                /*If alltrim(upper(cTipo)) == "NFE"
                    XMLent(oXml)
                Else*/ 
                    lgerou := XMLCTE(oXml)
                //EndIf 

                DbSelectArea("SA1")
                DbSetOrder(3)
                If Dbseek(xFilial("SA1")+cXmlRec)
                    
                    oCampo['DADOS']   := {}
                        
                    nLinha := 1

                    If len(aAux) < 1
                        AADD( oCampo['DADOS'], JsonObject():New() )
                        oCampo['DADOS'][nLinha]["INADIMPLENTE"] := .F.
                    Else 

                        /*For nCont := 1 to len(aAux)
                            AADD( oCampo['DADOS'], JsonObject():New() )
                            oCampo['DADOS'][nLinha]["INADIMPLENTE"] := .T.
                            oCampo['DADOS'][nLinha]["TITULOS"] := {}
                            AADD( oCampo['DADOS'][nLinha]["TITULOS"], JsonObject():New() )
                            // E1_NUM,E1_PREFIXO,E1_PARCELA,E1_VENCREA,E1_VALOR
                            oCampo['DADOS'][nLinha]["TITULOS"][1]["TITULO"] := aAux[nCont,01]
                            oCampo['DADOS'][nLinha]["TITULOS"][1]["PREFIXO"] := aAux[nCont,02]
                            oCampo['DADOS'][nLinha]["TITULOS"][1]["PARCELA"] := aAux[nCont,03]
                            oCampo['DADOS'][nLinha]["TITULOS"][1]["VENCIMENTO"] := cvaltochar(aAux[nCont,04])
                            oCampo['DADOS'][nLinha]["TITULOS"][1]["VALOR"] := aAux[nCont,05]
                            nLinha++
                        Next nCont */
                    EndIf 
                    
                    ::SetResponse(FWJsonSerialize(oCampo, .F., .F., .T.))
                else
                    lRet		:= .F.
                    oResponse['code'] := "#400"
                    oResponse['status'] := 500
                    oResponse['message'] := '#erro_cnpj'
                    oResponse['detailedMessage'] := 'CNPJ n�o encontrado na base'
                EndIf 
                
            EndIf 
        Next nCont
        
    EndIf
	
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
    cWord := strtran(cWord,"�","a")
	cWord := strtran(cWord,"�","a")
	cWord := strtran(cWord,"�","a")
	cWord := strtran(cWord,"�","a")
    cWord := strtran(cWord,"�","")
    cWord := strtran(cWord,"%","")
    cWord := strtran(cWord,"*","")     
    cWord := strtran(cWord,"&","")
    cWord := strtran(cWord,"$","")
    cWord := strtran(cWord,"#","")
    cWord := strtran(cWord,"�","") 
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
    cWord := StrTran(cWord, '�', '')
    cWord := StrTran(cWord, '�', '')
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
Static Function XMLCTE(oXml)

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

If ValType(oXml) != "O"
     Return()
Endif

cVersaoCTE := oXML:_CTEProc:_versao:TEXT  

cChave_Nfe := SubStr(oxml:_CTEPROC:_CTE:_INFCTE:_ID:TEXT,4)

If Empty(cChave_Nfe)
	//MsgAlert("A chave de acesso n�o foi informada!","XMLCTE")
	Return
EndIf     

If XmlChildEx( oXml:_CTEPROC:_CTE:_INFCTE:_EMIT, "_CNPJ" ) != Nil
    cCNPJ_FIL := oxml:_CTEPROC:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT 
EndIF 

aSm0 := FWLoadSM0()
nPos := Ascan(aSM0,{|x| Alltrim(x[18]) == Alltrim(cCNPJ_FIL )})			
nPos := 1
cFilorig := aSm0[nPos,02] //SM0->M0_CODFIL
cEstFil  := Alltrim(aSm0[nPos,04])

cNatOp	:= PadR(oXml:_cteProc:_cte:_Infcte:_IDE:_NATOP:Text,45," ")

//Busca pelo cnpj do Tomador 

If XmlChildEx( oXml:_CTEPROC:_CTE:_INFCTE:_IDE, "_TOMA4" ) <> NIL
    cCNPJ_TOM := oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA4:_CNPJ:TEXT
    cEstTom   := UPPER(oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA4:_ENDERTOMA:_UF:TEXT)
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

// ************ Verifica se j� existe essa NF na base de dados aqui ***************
// filial doc serie cliente loja
DbSelectArea("SF2")
DbSetOrder(1)
If Dbseek(cFilorig+cNum+cSerie+cCodCli+cLjFornec)
    cNfExst := cNum
    //Return(.F.)
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
    cTesCTe := BuscaTes(cEstFil,cCfopFrt,cEstIni,cEstFim,cCstCte,cMunIni,cMunFim,cEstTom)
EndIf 

lRet := GerarCte()

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
Static Function BuscaTes(cEstFil,cCfopFrt,cEstIni,cEstFim,cCstCte,cMunIni,cMunFim,cEstTom)

Local cRet := '501'

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
Local cProdCTe  :=  SuperGetMv("TI_PRODCTE",.F.,"000000000000000000000000000061")

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
aadd(aCabec,{"F2_COND"      ,"004"      })
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
    lRet := .F.
EndIf 

Return(lRet)
