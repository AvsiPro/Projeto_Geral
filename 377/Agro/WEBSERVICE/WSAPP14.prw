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

    conout('Filial Danfe '+cFilNota)

    If Select("SM0") == 0
		RpcSetType(3)
		RPCSetEnv("01",cFilNota)
	EndIf

    conout('Filial atual'+cfilant)
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

        If File(cPasta+"Boleto\boleto_"+cNumero+"_"+Alltrim(cParBol)+".pdf")
            Ferase(cPasta+"Boleto\boleto_"+cNumero+"_"+Alltrim(cParBol)+".pdf")
        EndIf

        DbSelectArea("SE1")
        DbSetOrder(1)
        If Dbseek(xFilial("SE1")+Avkey(MV_PAR01,"E1_PREFIXO")+MV_PAR02+avkey(cParBol,"E1_PARCELA"))
            DbSelectArea("SA6")
            DbSetOrder(1)
            If Dbseek(xFilial("SA6")+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA)
                U_ROBBOL(.T.,cPasta+'Boleto\',cFilNota,cParBol)
            EndIf
        EndIf
        //U_ROBBOL(.T.,cPasta+'Boleto\',cFilNota,cParBol)
        oFile  := FwFileReader():New(cPasta+"Boleto\boleto_"+cNumero+"_"+Alltrim(cParBol)+".pdf")
        cFilName := "boleto_"+cNumero+"_"+Alltrim(cParBol)+".pdf"
    ElseIf Alltrim(upper(cTipFile)) == 'DANFE' 
        DbSelectArea("SF2")
        DbSetOrder(1)
        If Dbseek(cFilNota+cNumero+cSerNF)
            conout('posicionou na nota '+cFilNota+cNumero+cSerNF)
        else
            conout('n�o posicionou na nota '+cFilNota+cNumero+cSerNF)
        endif

        DbSelectArea("SF3")
        DbSetOrder(5)
        DbSeek(cFilNota+cSerNF+cNumero)

        U_JUBDANFE(cNumero,cSerNF,cPasta,'Danfe_'+cFilNota)
        oFile  := FwFileReader():New(cPasta+"Danfe_"+cFilNota+"\"+cNumero+".pdf")
        cFilName := cNumero+".pdf"

        conout(cPasta+"Danfe_"+cFilNota+"\"+cNumero+".pdf")
        conout(cFilName)
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
