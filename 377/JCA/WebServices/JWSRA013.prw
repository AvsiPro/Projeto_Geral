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
    Local aAux      :=  .F.
    Local nLinha 
    Local cError    :=  ''
    Local nCont
    Local cWarning  :=  ''
    Local oResponse     := JsonObject():New()
    Local oCampo        := JsonObject():New()

    RpcClearEnv()
    RpcSetType(3)
    //RPCSetEnv('01','00020087')
    RPCSetEnv('T1','D MG 01')

	::SetContentType("application/json")

    If lRet
        oBody  := JsonObject():New()
        oBody:fromJson(cJson) 

        cXmlRec    := oBody:getJsonText("xml")
        cPathXml   := oBody:getJsonText("pathxml")
        cTipo      := oBody:getJsonText("tipo")
        cDoc       := oBody:getJsonText("numero")

        If Empty(cXmlRec) .and. Empty(cPathXml)
            lRet		:= .F.
            oResponse['code'] := "#400"
            oResponse['status'] := 500
            oResponse['message'] := '#erro_json'
            oResponse['detailedMessage'] := 'Não foi informado o xml e endereço do xml'
        Else 
            cXmlRec := Decode64(cXmlRec)
            cXmlRec := fRemoveCarc(cXmlRec)
/*
            cFilXml  := 'C:\xml_imp\NOTA_'+dtos(ddatabase)+strtran(cvaltochar(time()),":")+'.xml'
            nHandXml := fcreate( cFilXml , FO_READWRITE + FO_SHARED )

            fwrite(nHandXml,cXmlRec+CRLF,100000)
            fclose(nHandXml)
*/            
            //oXml := XmlParserFile( '\spool\'+substr(cFilXml,12), "_", @cError, @cWarning )

            oXml := XmlParser( cXmlRec, "_", @cError, @cWarning )
            
            If alltrim(upper(cTipo)) == "NFE"
                XMLent(oXml)
            Else 
                XMLCTE(oXml)
            EndIf 

            DbSelectArea("SA1")
            DbSetOrder(3)
            If Dbseek(xFilial("SA1")+cXmlRec)
                
                oCampo['DADOS']   := {}
                    
                //aAux := Busca(cCod,cLoja)
                nLinha := 1

                If len(aAux) < 1
                    AADD( oCampo['DADOS'], JsonObject():New() )
                    oCampo['DADOS'][nLinha]["INADIMPLENTE"] := .F.
                Else 

                    For nCont := 1 to len(aAux)
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
                    Next nCont 
                EndIf 
                
                ::SetResponse(FWJsonSerialize(oCampo, .F., .F., .T.))
            else
                lRet		:= .F.
                oResponse['code'] := "#400"
                oResponse['status'] := 500
                oResponse['message'] := '#erro_cnpj'
                oResponse['detailedMessage'] := 'CNPJ não encontrado na base'
            EndIf 

            
        EndIf 
                        
        
        
    EndIf

	
    If !lRet
        ::SetResponse(FWJsonSerialize(oResponse, .F., .F., .T.))
    EndIf

	RpcClearEnv()

Return lRet


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
    //cWord := StrTran(cWord, ">", "")
    //cWord := StrTran(cWord, "<", "")
    cWord := StrTran(cWord, "!", "")
    cWord := StrTran(cWord, "@", "")
    cWord := StrTran(cWord, "$", "")
    //cWord := StrTran(cWord, "(", "")
    //cWord := StrTran(cWord, ")", "")
    //cWord := StrTran(cWord, "_", "")
    //cWord := StrTran(cWord, "=", "")
    //cWord := StrTran(cWord, "+", "")
    //cWord := StrTran(cWord, "{", "")
    //cWord := StrTran(cWord, "}", "")
    //cWord := StrTran(cWord, "[", "")
    //cWord := StrTran(cWord, "]", "")
    cWord := StrTran(cWord, "?", "")
    //cWord := StrTran(cWord, "\", "")
    //cWord := StrTran(cWord, "|", "")
    //cWord := StrTran(cWord, ":", "")
    //cWord := StrTran(cWord, ";", "")
    //cWord := StrTran(cWord, '"', '')
    cWord := StrTran(cWord, '°', '')
    cWord := StrTran(cWord, 'ª', '')
    cWord := Alltrim(Lower(cWord))
Return cWord

/*/{Protheus.doc} XMLent
    Leitura do XML de nota fiscal
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
Static Function XMLent(oXml)

Local aArea			:= GetArea()
Local lRet			:= .T.                       
Local cError		:= ""

Private cTesCli		:=	""
aItensCad := {}
aList4		:= {}
cCondPg		:=	''

//oXml := XmlParserFile( cPath+cFile, "_", @cError, @cWarning )

If ValType(oXml) != "O"
     MsgAlert(cFile+" - "+cError)
     Return(.F.)
Endif


cVersaoNFE := oXML:_nfeProc:_versao:TEXT

cTipNf := oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_TPNF:TEXT

// -> Verifica se NF está autorizada na Sefaz
cChave_NFe := SubStr(oxml:_NFEPROC:_NFE:_INFNFE:_ID:TEXT,4)
cProtocol  := oxml:_NFEPROC:_PROTNFE:_INFPROT:_NPROT:TEXT

If Empty(cChave_NFe)
	MsgAlert("A chave de acesso não foi informada!","XMLNFE")
	Return(.F.)
EndIf   
	         
// Se a Tag NFEPROC:NFE:INFNFE:_DET for Objeto
If ValType(oXml:_NfeProc:_Nfe:_InfNfe:_DET) = "O"
     XmlNode2Arr(oXml:_NfeProc:_Nfe:_InfNfe:_DET, "_DET")
EndIf

// Gera Array com os dados dos produtos do XML
aItensXML	:= oXML:_nfeProc:_NFe:_infNFe:_Det
aItensXML	:= IIf(ValType(aItensXML)=="O", {aItensXML}, aItensXML)

If Len(aItensXML) == 0
	MsgAlert("Erro na estrutura dos Itens do arquivo XML!", "XMLNfe")
	Return(.F.)
EndIf

// Inicializa as variaveis de controle
nError := 0
cFilorig := "XX"
//cnpj
cCNPJ_FIL := oxml:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT


//OpenSm0()
SM0->(dbGoTop())
While !SM0->(Eof())
     If cEmpAnt != SM0->M0_CODIGO
          SM0->(dbskip()) // ignora filiais que nao sejam da empresa ativa.
          loop
     Endif
     
     If cCNPJ_FIL == SM0->M0_CGC
          cFilorig := SM0->M0_CODFIL
          Exit //Forca a saida
     Endif
     
     SM0->(dbskip())
EndDo

cFilant := cFilorig 
//Opensm0(cempant+cFilant)
//Openfile(cempant+cFilant)

If XmlChildEx( oXml:_NFEPROC:_NFE:_INFNFE:_DEST , "_CNPJ" ) != Nil
	cCNPJ_CLI := oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT
Else
	cCNPJ_CLI := oxml:_NFEPROC:_NFE:_INFNFE:_DEST:_CPF:TEXT
EndIf
//Verificando fornecedor: " +cCNPJ_FOR)                  
cNum	:= PadL(Alltrim(oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT),9,"0") //Nro da Nota
cSerie	:= STRZERO(VAL(oXml:_NfeProc:_Nfe:_InfNfe:_IDE:_Serie:Text),3) //STRZero(val(Alltrim(oXml:_NfeProc:_Nfe:_InfNfe:_IDE:_Serie:Text)),3)
cNatOp	:= PadR(oXml:_NfeProc:_Nfe:_InfNfe:_IDE:_NATOP:Text,45," ")

If XmlChildEx( oXml:_NFEPROC:_NFE:_INFNFE , "_COBR") != Nil
	If XmlChildEx( oXml:_NFEPROC:_NFE:_INFNFE:_COBR, "_DUP") != Nil
		aDupAux := oXml:_NFEPROC:_NFE:_INFNFE:_COBR:_DUP
		If valtype(aDupAux) == "O"
			cCondPg := "001"
		Else
			If len(aDupAux) == 1
				cCondPg := "001"
			Else
				nPos := Ascan(aCondPg,{|x| cvaltochar(len(aDupAux))+"X" $ x[2] })
				If nPos > 0 
					cCondPg := aCondPg[nPos,01]
				Else
					cCondPg := '001'
				EndIf
			Endif
		EndIf
	Else
		cCondPg := '001'
	EndIf
else
	cCondPg := '001'
EndIf

DBSelectArea("SA2")
DBSetOrder(3)
If DbSeek(xFilial("SA2")+cCNPJ_CLI) 
	cFornec		:= SA2->A2_COD
	cLjFornec	:= SA2->A2_LOJA
	cEstFor		:= SA2->A2_EST
	cNomeFor	:= SA2->A2_NOME
	cForCond	:= SA2->A2_COND  
	cEndFor		:= Alltrim(SA2->A2_END)+" - "+Alltrim(SA2->A2_BAIRRO)+" - "+Alltrim(SA2->A2_MUN)+" - "+cEstFor
	cIE_CLI		:= SA2->A2_INSCR
	//cTesCli		:= SA1->A1_XTES
EndIf

If !Empty(cFornec)
	nNumItens	:= LEN(aItensXML) 
	
	cDtEmissao	:= oXml:_NFEPROC:_NFE:_INFNFE:_IDE:_dhEmi:Text
	cDtEmissao	:= CTOD(Substr(cDtEmissao,9,2)+"/"+Substr(cDtEmissao,6,2)+"/"+Substr(cDtEmissao,1,4))
	
	//Base ICMS
	nBaseIcm	:= Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VBC:Text)
	//Valor ICMS
	nVlrIcm		:= Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VICMS:Text)
	// Valor Mercadorias
	nTotalMerc	:= Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VPROD:Text)  
	//Base ST
	nBaseSt		:= Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VBCST:Text)	
	// -> Inicializa a variavel para realizar o somatorio de descontos da nota.
	nDescNota	:= Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VDESC:Text)
	//Valor IPI
	nVlrIPI 	:= Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VIPI:Text)
	
	cNumTitulo      := cNum
	nValor          := Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VNF:Text)
	
	If XmlChildEx( oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT , "VOUTRO" ) != Nil
		nAcrescimo := Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VOUTRO:Text)
	Else
	     nAcrescimo := 0
	Endif
	
	cVencimento := ""
	
	nFrete	:= val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VFRETE:Text)
	
	nSeguro	:= Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VSeg:Text)
	//Valor ST
	nIcmsSubs	:= Val(oXml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VST:Text)
	 
	Aadd(aList4,{nBaseIcm,nVlrIcm,nBaseSt,nIcmsSubs,nTotalMerc,nFrete,nSeguro,nDescNota,nAcrescimo,nVlrIPI,nValor}) 
	
	
	// Verifica Produtos - amarração
	lCadOk	:= ValProd(cFornec, cLjFornec, aItensXML,oXml)
	dDataBase := cDtEmissao
    GeraEnt(cFornec,cLjFornec)
	
	
Else
	FWrite(nHandlel,"Cliente não encontrado na base - cnpj "+cCNPJ_CLI+CRLF,1000)
	conout("Cliente inexistente para o cnpj "+cCNPJ_CLI)
	lRet := .F.
EndIf

nItem	:= 0
aCabec	:= {}
aItens	:= {}
aLinha	:= {}

lExistArq	:= .F.
lIniLog		:= .F.

oXml := NIL

RestArea(aArea)
	
Return lRet

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

Local aPergs		:= {}	// Utilizado no ParamBox no inicio da execução
Local aRet			:= {}	// Utilizado no ParamBox no inicio da execução
Local nPapel 

aItensCad := {}
cEspecie  := "CTE"

If ValType(oXml) != "O"
     Return()
Endif

cVersaoCTE := oXML:_CTEProc:_versao:TEXT  

// -> Verifica se NF está autorizada na Sefaz
cChave_Nfe := SubStr(oxml:_CTEPROC:_CTE:_INFCTE:_ID:TEXT,4)

If Empty(cChave_Nfe)
	//MsgAlert("A chave de acesso não foi informada!","XMLCTE")
	Return
EndIf                                

// Inicializa as variaveis de controle
nError := 0
cFilorig := '' 


If XmlChildEx( oXml:_CTEPROC:_CTE:_INFCTE:_EMIT, "_CNPJ" ) != Nil
    cCNPJ_FIL := oxml:_CTEPROC:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT 
EndIF 

aFils 	:=	{}
aSm0 := FWLoadSM0()
nPos := Ascan(aSM0,{|x| Alltrim(x[18]) == Alltrim(cCNPJ_FIL )})			
nPos := 1
cFilorig := aSm0[nPos,02] //SM0->M0_CODFIL

cNatOp	:= PadR(oXml:_cteProc:_cte:_Infcte:_IDE:_NATOP:Text,45," ")

//Busca pelo cnpj do remetente 
If XmlChildEx( oXml:_CTEPROC:_CTE:_INFCTE:_REM, "_CNPJ" ) != Nil
    cCNPJ_FOR := oxml:_CTEPROC:_CTE:_INFCTE:_REM:_CNPJ:TEXT 
ElseIf XmlChildEx( oXml:_CTEPROC:_CTE:_INFCTE:_REM, "_CPF" ) != Nil
    cCNPJ_FOR := oxml:_CTEPROC:_CTE:_INFCTE:_REM:_CPF:TEXT 
EnDIf 


DBSelectArea("SA1")
DBSetOrder(3)
If DbSeek(xFilial("SA1")+cCNPJ_FOR)
	cFornec		:= SA1->A1_COD
	cLjFornec	:= SA1->A1_LOJA
	cEstFor		:= SA1->A1_EST
	cNomeFor	:= SA1->A1_NOME
	cForCond	:= SA1->A1_COND
	cEndFor		:= Alltrim(SA1->A1_END)+" - "+Alltrim(SA1->A1_BAIRRO)+" - "+Alltrim(SA1->A1_MUN)+" - "+cEstFor
	cIE_FOR		:= SA1->A1_INSCR
/*Else
	MsgAlert(OemToAnsi("Fornecedor inexistente! " + cCNPJ_FOR +CRLF))*/
Endif

cNum	:= PadL(Alltrim(oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_NCT:TEXT),9,"0") //Nro da Nota
cSerie	:= PadR(oXml:_CTEProc:_CTE:_InfCTE:_IDE:_Serie:Text,3," ")


// -> Verifica se já existe essa NF na base de dados
/*DBSelectArea("SF1")
DbSetorder(1)
If DbSeek(cFilorig+AvKey(cNum,"F1_DOC")+AvKey(cSerie,"F1_SERIE")+AvKey(cFornec,"F1_FORNECE")+AvKey(cLjFornec,"F1_LOJA")+AvKey(cTipo,"F1_TIPO"))
	If lExecMenu
		Alert(OemToAnsi("A Nota Fiscal " +cNum +"/" +cSerie +" já consta no sistema."))
		GeraLog("A Nota Fiscal " +cNum +"/" +cSerie +" já consta no sistema."  +CRLF)
		FClose(nHdl)
		Return()
	Else
		ConOut("Nao importada. Nota Fiscal já consta no sistema." + cFornec+"/"+cLjFornec +CRLF)
		GeraLog("Nao importada. Nota Fiscal já consta no sistema." + cFornec+"/"+cLjFornec +CRLF)
		FClose(nHdl)
		Return()
	EndIf
EndIf  */   

cDtEmissao	:= oXml:_CTEPROC:_CTE:_INFCTE:_IDE:_dhEmi:Text

cDtEmissao	:= Substr(cDtEmissao,9,2)+"/"+Substr(cDtEmissao,6,2)+"/"+Substr(cDtEmissao,1,4)
            
cNumTitulo      := cNum
nTotalMerc      := Val(oXml:_CTEPROC:_CTE:_INFCTE:_VPREST:_VTPREST:Text)

cVencimento := ""  

If XmlChildEx( oXml:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC, "_INFNFE" ) != Nil
	If Valtype(oXml:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE) <> "A"
		cChvNFS := oXml:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE:_CHAVE:TEXT
		aItemNF := {} //BuscNFT(cChvNFS,'')   
	Else
		aChaves := oXml:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE
		cBarra := ''
		cChvNFS:= ''
		For nPapel := 1 to len(aChaves)
			cChvNFS += cBarra + aChaves[nPapel]:_CHAVE:TEXT
			cBarra := "','"
		Next nPapel
		
		aItemNF 	:= {} //BuscNFT(cChvNFS,'')
		
	EndIF
Else
                                   
	cNfs	:=	space(150)
	aAdd(aPergs ,{1,"Numero das NFs?"			,cNfs   ,'',"","","",120,.F.})

	If !ParamBox(aPergs ,"Filtro",aRet)
		Return	
	Else
		aItemNF := {} //BuscNFT('',aRet[1])
	EndIf
EndIf

nFrete := 0
nSeguro := 0
nIcmsSubs := 0
	
//aAdd(aItensCad, {'01','FRETE','FRETE','FRETE',1,nTotalMerc,nTotalMerc,'cfop','ncm','cund','outro','cest',cNum,cSerie,'seguro',0})

cTable := oTable:GetAlias()

DbSelectArea(cTable)
DbSetOrder(1)
IF !DbSeek(cChave_NFe)
	nHandle := FT_FUse(cFile) 
	cLine := ''
	While !FT_FEOF()                                              
		cLine	+= FT_FReadLn() // Retorna a linha corrente  
		FT_FSKIP()
	End
	 	
	Reclock(cTable,.T.)
	&(cTable+"->TMP_CHAVE")	:=	cChave_NFe
	&(cTable+"->TMP_CNPJF")	:=	cCNPJ_FOR
	&(cTable+"->TMP_CNPJC")	:=	cCNPJ_FIL
	&(cTable+"->TMP_NUM")	:=	cNum
	&(cTable+"->TMP_PREFIX"):=	cSerie
	&(cTable+"->TMP_FLAGIM"):=	"1"      
	&(cTable+"->TMP_EMISSA"):=	ctod(cDtEmissao)
	//ZZ0->ZZ0_XMLNFE	:=	cLine 
	&(cTable+"->TMP_XMLNFA"):=	cLine
	&(cTable+"->TMP_FILE")	:=	cFile 
	&(cTable)->(Msunlock())
EndIF 

Return  

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

