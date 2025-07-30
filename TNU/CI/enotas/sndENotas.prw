#include "totvs.ch"

/*/{Protheus.doc} sndENotas
Rotina de Envio de NF para o E-Notas
@type function
@version 1.0
@author Cristiam Rossi
@since 16/04/2021
@param _Filial, character, Filial da NF a ser transmitida
@param _Doc, character, Número da NF da NF a ser transmitida
@param _Serie, character, Série da NF a ser transmitida
@param lQuiet, logical, exibe mensagens de aviso
@return logical, Sucesso ou Fracasso na Transmissão da NF para o E-Notas
/*/
/*
+----------------------------------------------------------------------------+
|                         Historio de Manutencao                             |
|                                                                            |
| 21/05/2025 - Inclusao do Campo NBS                                         |
+----------------------------------------------------------------------------+
*/

user function sndENotas( _Filial, _Doc, _Serie, lQuiet )
local   aArea     := getArea()
local   aAreaSA1  := SA1->(getArea())
local   aAreaSD2  := SD2->(getArea())
local   aAreaSF2  := SF2->(getArea())
local   lOk       := .F.
local   cUrl      := "https://api.enotasgw.com.br"
local   oRest
local   cJSON     := ""
local   aHeader   := {}
local   cAcesso   := superGetMV("FS_ENFKEY",,"YTUyOTk0NDktMWNiZS00NjAzLWE0NzYtMWEwOTAwMDUwNzAw")       // API KEY
local   cEmpID    := ""
local   oRet      := JsonObject():New()
local   cErro     := ""
local   cErro2    := ""
local   xRet
local   cNFeID    := ""
local   cIdExt    := ""

default lQuiet    := .F.

    if ! getENotas( @cEmpID )
        if ! lQuiet
            msgStop( "Esta Empresa/Filial não está configurada para o E-Notas", "Integração E-Notas" )
        endif
        restArea( aArea )
        return nil
    endif

    dbSelectArea("SA1")
    dbSelectArea("SD2")
    dbSelectArea("SF2")
    dbSelectArea("ZPD")
    

    SA1->( dbSetOrder(1) )
    SD2->( dbSetOrder(3) )
    SF2->( dbSetOrder(1) )
    

    if ! SF2->( dbSeek( _Filial + _Doc + _Serie ) )
        if ! lQuiet
            msgStop("Documento não encontrado Cabeçalho ["+_Filial +"/"+ _Doc +"-"+ _Serie+"]","Integração E-Notas")
        endif
        return .F.
    endif
    
    if ! SD2->( dbSeek( SF2->(F2_FILIAL+F2_DOC+F2_SERIE) ) )
        if ! lQuiet
            msgStop("Documento não encontrado Itens ["+_Filial +"/"+ _Doc +"-"+ _Serie+"]","Integração E-Notas")
        endif
        return .F.
    endif

    if ! SA1->( dbSeek( xFilial("SA1") + SF2->(F2_CLIENTE+F2_LOJA) ) )
        if ! lQuiet
            msgStop("Cliente não encontrado ["+xFilial("SA1") +"/"+ SF2->F2_CLIENTE +"-"+ SF2->F2_LOJA+"]","Integração E-Notas")
        endif
        return .F.
    endif

    oRest := fwRest():new( cURL )

    aadd(aHeader, "Accept: application/json")
    aadd(aHeader, "Content-Type: application/json; charset=utf-8")
    aadd(aHeader, "Authorization: Basic "+cAcesso )

    oRest:setPath("/v1/empresas/" + cEmpID + "/nfes")    // emissao da NF

    cIdExt := substr(getDePara( ZPD->ZPD_IDEXT ),2)
    cIdExt := left(cIdExt, len(cIdExt)-1)

    cJSON += '{'
    cJSON +=    '"idExterno": '+ getDePara( ZPD->ZPD_IDEXT )+','
    cJSON +=    '"ambienteEmissao":'+ getDePara( ZPD->ZPD_AMB )+','
    cJSON +=    '"enviarPorEmail":'+ getDePara( ZPD->ZPD_ENVMAI )+','
    cJSON +=    '"dadosAdicionaisEmail":{'
    cJSON +=        '"outrosDestinatarios":"fat.enotas@gci.com.br"'
    cJSON +=    '},'
    cJSON +=    '"cliente":{'
    cJSON +=        '"tipoPessoa":'+ getDePara( ZPD->ZPD_TPESSO )+','
    cJSON +=        '"nome":'+ getDePara( ZPD->ZPD_NOME )+','
    cJSON +=        '"telefone":'+ getDePara( ZPD->ZPD_TEL )+','
    cJSON +=        '"email":'+ getDePara( ZPD->ZPD_EMAIL )+','
    cJSON +=        '"cpfCnpj":'+ getDePara( ZPD->ZPD_CPF )+','
    cJSON +=        '"inscricaoMunicipal":'+ getDePara( ZPD->ZPD_INSCM )+','
    cJSON +=        '"endereco":{'
    cJSON +=            '"logradouro":'+ getDePara( ZPD->ZPD_END )+','
    cJSON +=            '"numero":'+ getDePara( ZPD->ZPD_NUM )+','
    cJSON +=            '"complemento":'+ getDePara( ZPD->ZPD_COMPLE )+','
    cJSON +=            '"bairro":'+ getDePara( ZPD->ZPD_BAIRRO )+','
    cJSON +=            '"cep":'+ getDePara( ZPD->ZPD_CEP )+','
    cJSON +=            '"uf":'+ getDePara( ZPD->ZPD_UF )+','
    cJSON +=            '"cidade":'+ getDePara( ZPD->ZPD_MUN )
    cJSON +=        '}'
    cJSON +=    '},'
    cJSON +=    '"servico":{'
    cJSON +=        '"descricao":'+ getDePara( ZPD->ZPD_DESCRI )+','
    cJSON +=        '"issRetidoFonte":'+ getDePara( ZPD->ZPD_ISSRET )+','
    cJSON +=        '"valorCofins":'+ getDePara( ZPD->ZPD_COFINS )+','
    cJSON +=        '"valorCsll":'+ getDePara( ZPD->ZPD_CSLL )+','
    cJSON +=        '"valorInss":'+ getDePara( ZPD->ZPD_INSS )+','
    cJSON +=        '"valorIr":'+ getDePara( ZPD->ZPD_IR )+','
    cJSON +=        '"valorPis":'+ getDePara( ZPD->ZPD_PIS )+','
    cJSON +=        '"codigoNBS":'+ getDePara( ZPD->ZPD_NBS )
    cJSON +=    '},'
    cJSON +=    '"valorTotal":'+ getDePara( ZPD->ZPD_VALOR )+','
    cJSON +=    '"observacoes":'+ getDePara( ZPD->ZPD_OBS )
    cJSON += '}'

    cJSON := NOACENTO( cJSON )

    oRest:SetPostParams( cJSON )
    if oRest:Post( aHeader )
        lOk  := .T.
    else
        cErro := oRest:getLastError()
    endif
    xRet := decodeUTF8( oRest:GetResult() )

    if ! empty( cErro2 := oRet:fromJson(xRet) )
        cErro += iif(empty(cErro), "", " | ") + alltrim( cErro2 )
    else
        cNFeID := oRet['nfeId']
    endif

    if ! lQuiet
        if lOk
            msgInfo("NF enviada com êxito para o E-Notas","Integração E-Notas")
        else
            msgStop("Problema ao enviar NF para E-Notas:"+CRLF+cErro+CRLF+CRLF+xRet,"Integração E-Notas")
        endif
    endif

// atualiza demais registros da NF p/ Last <- N
    cQuery := "update "+retSqlName("ZPE")+" set ZPE_LAST='N'"
    cQuery += " where ZPE_FILIAL='"+xFilial("ZPE")+"'"
    cQuery += " and ZPE_DOC='"+SF2->F2_DOC+"'"
    cQuery += " and ZPE_SERIE='"+SF2->F2_SERIE+"'"
    cQuery += " and D_E_L_E_T_=' '"
    if tcSqlExec( cQuery ) < 0
        conout("[sndENotas.prw] Falha ao atualizar ZPE_LAST, Erro: "+CRLF+TCSQLError() )
    endif

    recLock("ZPE",.T.)
    ZPE->ZPE_FILIAL := xFilial("ZPE")
    ZPE->ZPE_DOC    := SF2->F2_DOC
    ZPE->ZPE_SERIE  := SF2->F2_SERIE
    ZPE->ZPE_NFEINT := cIdExt
    ZPE->ZPE_STATUS := iif( lOK, "1", "2" )     // 1=Ok   2=Recusa E-Notas
    ZPE->ZPE_DATA   := Date()
    ZPE->ZPE_HORA   := Time()
    ZPE->ZPE_LAST   := " "
    ZPE->ZPE_NFEID  := cNFeID
    ZPE->ZPE_ERRO   := cErro
    ZPE->ZPE_RETORN := xRet
    ZPE->ZPE_REQUES := cJSON
    msUnlock()

    SA1->( restArea( aAreaSA1 ) )
    SD2->( restArea( aAreaSD2 ) )
    SF2->( restArea( aAreaSF2 ) )
    //SB5->( restArea( aAreaSB5 ))
    restArea( aArea )
return lOk


/*/{Protheus.doc} getENotas
Retorna EmpresaID e Ambiente configurado para E-Notas
@type function
@version 1.0
@author Cristiam Rossi
@since 17/04/2021
@param cEmpID, character, EmpresaID - uso E-Notas
@param cAmbiente, character, Ambiente - Homologação/Produção - uso E-Notas
@return logical, Se a empresa/filial está habilitada para o E-Notas
/*/
static function getENotas( cEmpID )
local aArea := getArea()
local lRet  := .F.

    cEmpID    := ""
    
    dbSelectArea("ZPA")
    ZPA->(dbSetOrder(1))
    if ZPA->( dbSeek( xFilial("ZPA") + cFilAnt ) ) .and. ZPA->ZPA_ENOTAS == "S"
//    if ZPA->( dbSeek( xFilial("ZPA") + "000101" ) ) .and. ZPA->ZPA_ENOTAS == "S"
        lRet      := .T.
        cEmpID    := alltrim(ZPA->ZPA_EMPID)
    endif

    restArea( aArea )
return lRet


/*/{Protheus.doc} getFCli
Função de Validação do CNPJ da Clínica a ser usuária do E-Notas
@type function
@version 1.0
@author Cristiam Rossi
@since 17/04/2021
@param cCNPJ, character, CNPJ da Clínica
@return logical, CNPJ apto a ser cadastrado
/*/
user function getFCli( cCNPJ )
local cAliasQry := getNextAlias()
local lOk       := .F.

    if empty( cCNPJ )
        return .F.
    endif

    beginSql alias cAliasQry
        select R_E_C_N_O_ RECNOSM0
        from SYS_COMPANY
        where M0_CGC = %exp:cCNPJ%
        and %notDel%
    endSql

    if ! (cAliasQry)->( eof() )
        lOk := .T.
        SM0->( dbGoto( (cAliasQry)->RECNOSM0 ) )
    endif
    (cAliasQry)->( dbCloseArea() )

    if ! lOk
        msgStop( "O CNPJ informado não se encontra no cadastro de filiais", "Validação de Clínica" )
    else
        dbSelectArea("ZPA")
        ZPA->( dbSetOrder(2) )
        if ZPA->( dbSeek( xFilial("ZPA") + cCNPJ ) )
            lOk := .F.
            msgStop( "O CNPJ informado já tem cadastro no E-Notas, verifique!", "Validação de Clínica" )
        endif
    endif

return lOk


/*/{Protheus.doc} getDePara
Rotina DE / PARA, obter dados para a montagem do JSON de remessa
@type function
@version 1.0
@author Cristiam Rossi
@since 19/04/2021
@param cCampo, character, Campo da tabela 
@return character, valor convertido para string
/*/
static function getDePara( cConteudo )
local   aArea  := getArea()
local   cRet   := ""
local   bError
private xValor
private cErroA := ""

    if ! empty( cConteudo )

        bError   := ErrorBlock( { |oErro| ChkErr( oErro ) } ) 
        begin sequence

        xValor := &( cConteudo )

        if Valtype(xValor)=='C'
            cRet := '"' + alltrim(xValor) + '"'

        elseif Valtype(xValor)=='L'
            cRet := iif( xValor, "true", "false" )

        elseif Valtype(xValor)=='N'
            cRet := cValToChar( xValor )
        endif

        end sequence
        ErrorBlock( bError )
    endif

    restArea(aArea)
return cRet


/*/{Protheus.doc} ChkErr
Tratamento pra não dar error.log
@type function
@version 1.0
@author Cristiam Rossi
@since 19/04/2021
@param oErroArq, object, Objeto do error.log
/*/
static function ChkErr(oErroArq)
    if oErroArq:GenCode > 0
        cErroA += '(' + Alltrim( Str( oErroArq:GenCode ) ) + ') : ' + AllTrim( oErroArq:Description ) + CRLF
    endif
    break
return nil
