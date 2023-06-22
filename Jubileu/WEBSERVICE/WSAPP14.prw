// BIBLIOTECAS NECESS�RIAS
#Include "TOTVS.ch"
#Include "RESTFUL.ch"

// DECLARA��O DO SERVI�O REST
WSRESTFUL WSAPP14 Description "Servi�o para envio de arquivos Danfe, Xml e Boleto." 
    WsData cTipo AS String  Optional
    WsData cDoc  As String  Optional
    WsData cSerie As String Optional 
    WsData cFilNF As String Optional 
    WsData cParce As String Optional

    // DECLARA��O DO M�TODO GET
WSMETHOD GET filespdfs;
    DESCRIPTION "Retorna um arquivo por meio do m�todo FwFileReader().";
    WsSyntax '/WSAPP14';
    Path '/WSAPP14'

END WSRESTFUL

// M�TODO GET
WSMETHOD GET filespdfs WsReceive cTipo,cDoc,cSerie,cFilNF,cParce WSREST WSAPP14

	Local lRet:= .T.
	lRet := GeraPDFs( self )

Return( lRet )

Static Function GeraPDFs( oSelf )

    Local cFile := ""// VALORES RETORNADOS NA LEITURA
    Local oFile // CAMINHO ABAIXO DO ROOTPATH
    Local cNumero           :=  ''
    Local cTipFile          :=  ''
    Local cFilNota          :=  ''
    Local cSerNF            :=  ''
    Local cPasta            :=  '\cliente\'
    Local cFilName          :=  ''
    Local cParBol           :=  ''

    Default oself:cTipo		:=	''
    Default oself:cDoc		:=	''
    Default oself:cSerie    :=  ''
    Default oself:cFilNF    :=  '0801'
    Default oself:cParce    :=  ''

    cFilNota := oself:cFilNF

    If Select("SM0") == 0
		RpcSetType(3)
		RPCSetEnv("01",cFilNota)
	EndIf

    conout(oself:cDoc)
    conout(oself:cTipo)
    conout(oself:cSerie)
    conout(oSelf:cParce)

    cNumero := oSelf:cDoc
    cTipFile := oSelf:cTipo
    cSerNF  :=  oSelf:cSerie
    cParBol :=  UPPER(oSelf:cParce)

    If Alltrim(upper(cTipFile)) == 'BOLETO'
        MV_PAR01 := cSerNF
        MV_PAR02 := cNumero
        U_ROBBOL(.T.,cPasta+'Boleto\',cFilNota,cParBol)
        oFile  := FwFileReader():New(cPasta+"Boleto\boleto_"+cNumero+"_"+Alltrim(cParBol)+".pdf")
        cFilName := "boleto_"+cNumero+"_"+Alltrim(cParBol)+".pdf"
    ElseIf Alltrim(upper(cTipFile)) == 'DANFE' 
        U_ROBDANFE(cNumero,cSerNF,cPasta,'Danfe')
        oFile  := FwFileReader():New(cPasta+"Danfe\"+cNumero+".pdf")
        cFilName := cNumero+".pdf"
    ElseIf Alltrim(upper(cTipFile)) == 'XML'
        u_ROBXML(cNota, cSerie, cPasta+'xml\' + cArquivo  + ".xml", .F.)
        cFilName := cArquivo  + ".xml"
    EndIf

    
    // SE FOR POSS�VEL ABRIR O ARQUIVO, LEIA-O
    // SE N�O, EXIBA O ERRO DE ABERTURA
    If (oFile:Open())
        cFile := oFile:FullRead() // EFETUA A LEITURA DO ARQUIVO

        // RETORNA O ARQUIVO PARA DOWNLOAD
        oSelf:SetHeader("Content-Disposition", "attachment; filename="+cFilName)
        oSelf:SetResponse(cFile)

        lSuccess := .T. // CONTROLE DE SUCESSO DA REQUISI��O
    Else
        SetRestFault(002, "can't load file") // GERA MENSAGEM DE ERRO CUSTOMIZADA

        lSuccess := .F. // CONTROLE DE SUCESSO DA REQUISI��O
    EndIf

Return (lSuccess)
