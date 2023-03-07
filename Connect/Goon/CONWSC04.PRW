#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "fileio.ch"
#INCLUDE  'TBICONN.CH'

//|Status das OS|

#DEFINE DESP "DESP"	//| Despachado
#DEFINE	ACTE "ACTE"	//| Recebido pelo Agente
#DEFINE	INIC "INIC"	//| Iniciado
#DEFINE CTEC "CTEC"	//| Cancelado pelo Agente
#DEFINE COPE "COPE"	//| Cancelado pelo Atendente
#DEFINE	CCLI "CCLI"	//| Cancelado pelo cliente
#DEFINE	FIOK "FIOK"	//| Finalizado OK
#DEFINE	AGEN "AGEN"	//| Agendado
#DEFINE TACM "TACM"	//| Agente a caminho

//| Posicoes no array - retorno das OS de abastecimento utilizadas nas funcoes 14 e 17

Static nPProduto := 1
Static nPMola	 := 2
Static nPSaldo	 := 3
Static nPAbast	 := 4
Static nPRetir	 := 5


/*



Programa   WSKPF001 Autor  Alexandre Venancio   Data   02/05/13

Desc.      Funo utilizada para Deserializar uma String retornada	  
           pelos mtodos: 										  
           GetAnswerFormByListOfOrdemServicoExternalID e              
			  GetAnswerFormByListOfOrdemServicoExternalID				  

Uso        Integracao Keeple                                          
?


*/

User Function CONWSC04(nTpServ,cCliFor,cLoja,aDoc,nAgente,cHoraAgen,lFechamento,cDtAgen,cDadosCnt,aDadosSP,cCodPA,cContato,cDepto,cTel,cXmail)

Local cRetWS001	:= ""
Local cXMLOS	:= ""
Local aDadosOS	:= {}
Local aCliFor	:= {}
Local cNumOS	:= ""
Local nTipo		:= 1
Local cNumChapa := ""
Local oObj 
Local cRet      :=  ''

Default nTpServ	:= 25
Default cCliFor	:= "51722957 "
Default cLoja	:= "0125"
Default aDoc	:= {}
Default nAgente	:= 47611
Default cHoraAgen := ""
Default lFechamento := .F.
Default cDtAgen	:= ''
Default cDadosCnt	:= ''
Default aDadosSP := {}
Default cCodPA	:=	''

Private cXSoapCli := ""

IF Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","0101")
ENDIF

// Monta dados do Cliente/Fornecedor
aCliFor := U_WSKPF002(nTipo,cCliFor,cLoja,cNumChapa,cCodPA,cContato,cDepto,cTel,cXmail,cDadosCnt)

If aCliFor <> Nil .And. Len(aCliFor) > 0

    If nTpServ == 25
        cXMLOS := ChmTec01()
    EndIf 

    If !Empty(cXMLOS)

        // Monta XML para a Ordem de Servico
        cRetWS001	:= U_WSKPC001(aCliFor)
        
        If "true" $ cRetWS001
            aDadosOS := U_WSKPF004('001',aCliFor,cXMLOS,nTpServ,nAgente,cHoraAgen,cDtAgen,cDadosCnt)

            If Valtype(aDadosOS) == "A" .And. Len(aDadosOS) > 0
                cNumOS := U_WSKPC002(aDadosOS)

                If !Empty(cNumOS) .And. "true" $ cNumOS
                    FWJsonDeserialize(cNumOS,@oObj)
                    cRet := oObj:NUMEROOS
                EndIf 

            EndIf 
        EndIF

    EndIf 
EndIf 

Return(cRet)

/*/{Protheus.doc} User Function nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 06/03/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function WSKPX006(aDados)

	/*------------------------------------------------------------------+
	|	Estrutura do Array que deve ser passado como parmetro			|
	|	aDados[x]														|
	|                                               					|
	|	Posicao			Campo							Tipo			|
	|-------------------------------------------------------------------+
	|	aDados[1]		authCode						-> String		|
	|	aDados[2]		clientCode						-> String		|
	|	aDados[3][x]	numeroOSList					-> Array Int	|
	|																	|
	+------------------------------------------------------------------*/

	Local oWS		:= NIL	// Objeto do WebService
	Local oWSArray	:= NIL	// Objeto Array de Int
	//Local cMetodo	:= "GetAnswerFormByListOfOrdemNumeroOS"
	Local cResult	:= ""
	Local nX
    Local oXml      := NIL
    Local cError    :=  ''
    Local cWarning  :=  ''
    Local oObj

	Default aDados	:= {'1AD4457221B86EDD00007A96EA7D9EBB58C1702A','Q64E8XIJ6NV4F1KGU3I1',{}}

    IF Select("SM0") == 0
        RpcSetType(3)
        RPCSetEnv("01","0101")
    ENDIF

	// Verifica tamanho do Array
	If Len(aDados) == 0
		MsgAlert("Não foram informados os parametros necessarios!","WSKPX006")
		//Return
	EndIf

	// Verifica parametro AuthCode
	If Alltrim(aDados[1]) == ""
		MsgAlert("Parametro AuthCode invalido! " +CRLF +"Favor preencher.","WSKPX006")
		//Return
	EndIf

	// Verifica parametro ClientCode
	If AllTrim(aDados[2]) == ""
		MsgAlert("Parametro ClientCode invalido! " +CRLF +"Favor preencher.","WSKPX006")
		//Return
	EndIf

	// Instancia Classe de montagem do Array de Int - 3 parametro
	oWSArray := KeepleFieldIntegration_ArrayOfInt():New()

	For nX := 1 To Len(aDados[3])
		AADD(oWSArray:nInt, aDados[3][nX])
	Next nX

	AADD(aDados, oWSArray)

	// Instancia a Classe (Client WebService gerado no DevStudio)
	oWS	:= WSKeepleFieldIntegration():New()

	// Metodo -> GetAnswerFormByListOfOrdemNumeroOS
	If oWS:GetAnswerFormByListOfOrdemServicoNumeroOS(aDados[1],aDados[2],aDados[4])
		// Sucesso
		cResult := oWs:cGetAnswerFormByListOfOrdemServicoNumeroOSResult
        FWJsonDeserialize(cResult,@oObj)
        oXml := XmlParser( oObj:ANSWERSXML, "_", @cError, @cWarning )
	Else
		cResult := GetWSCError()
		// Gera Log de Erro
	EndIf

Return cResult



/*


?
Programa  WSKPF002  Autor  Alexandre Venancio   Data   02/05/13   
?
Desc.      Funo especfica, gera o Array com dados do Fornecedor    
           ou Cliente para uso posterior no mtodo SaveOrUpdateCliente
?
Uso        Integracao Keeple                                          
?


*/

User Function WSKPF002(nTipo,cCliFor,cLoja,cNumChapa,cCodPA,cContato,cDepto,cTel,cXmail,cDadosCnt)

	Local aDados 	:= {}
	Local cQuery 	:= ""
	Local cAuthCode	:= SuperGetMV("MV_XWSK001",.T.,"6E424965C50DA1DC2F40B5E96DAEAFAB68A4BC14")       //ok
	Local cCliCode	:= SuperGetMV("MV_XWSK000",.T.,"Q64E8XIJ6NV4F1KGU3I1")                           //ok
	Local cCodLoja	:= ""
	Local cNome		:= ""
	Local cTipo		:= ""
	Local cEndereco	:= ""
	Local cComplem	:= ""
	Local cBairro	:= ""
	Local cMun		:= ""
	Local cUF		:= ""
	Local cCep		:= ""
	Local cEmail	:= ""
	Local lAtivo	:= .F.
	Local cCNPJ		:= ""
	Local cEndP		:= ''
	Default cContato:= ""
	Default nTipo	:= 0	// Tipo de busca [1-Cliente] [2-Fornecedor]
	Default cCliFor	:= ""
	Default cLoja	:= ""
	Default cNumChapa := ""
	Default cCodPA	:= ""
	Default cDepto	:= ""
	Default cTel	:= ""
	Default cXmail := ""
	Default cDadosCnt	:=	""

	If nTipo == 0
		MsgAlert("O parametro Tipo da busca nao foi informado!","WSKPF002")
		Return
	EndIf

	If Empty(cCliFor)
		MsgAlert("O parametro Cliente/Fornecedor nao foi informado!","WSKPF002")
		//Return
	EndIf

	If Empty(cLoja)
		MsgAlert("O parametro Loja nao foi informado!","WSKPF002")
		//Return
	EndIf

	If nTipo == 1 //| Consulta por Cliente

		//| Monta Query de Consulta

		cQuery := "SELECT * "
		cQuery += "FROM " +RetSqlName("SA1") + " AS SA1 "
		cQuery += "WHERE "
		cQuery += "SA1.A1_COD = '"+cCliFor+"' AND SA1.A1_LOJA = '"+cLoja+"' "
		cQuery += "AND D_E_L_E_T_ = '' "

		cQuery := ChangeQuery(cQuery)

		If Select("TRB") > 0
			TRB->(dbCloseArea())
		EndIf

		TCQUERY cQuery NEW ALIAS "TRB"

		dbSelectArea("TRB")
		TRB->(dbGoTop())
		If TRB->( !EOF() )
			cCodLoja	:= TRB->A1_COD+TRB->A1_LOJA
			cNome		:= AllTrim(TRB->A1_NOME)
			cTipo		:= TRB->A1_PESSOA
			If !Empty(cDadosCnt)
				DbSelectArea("ABS")
				DbSetOrder(1)
				If Dbseek(xFilial("ABS")+cDadosCnt)
					cNome		:= Alltrim(ABS->ABS_DESCRI) + " - Numero Contrataaao - "+cCodPA
					cEndereco	:= Alltrim(ABS->ABS_END)
					cComplem	:= ''
					cBairro		:= Alltrim(ABS->ABS_BAIRRO)
					cMun		:= Alltrim(ABS->ABS_MUNIC)
					cUF			:= AllTrim(ABS->ABS_ESTADO)
					cCep		:= AllTrim(ABS->ABS_CEP)
				Endif
			Else
				cEndereco	:= If(!Empty(cEndP),Alltrim(cEndP),AllTrim(TRB->A1_END))
				cComplem	:= If(!Empty(cEndP),'',AllTrim(TRB->A1_COMPLEMEN))
				cBairro		:= If(!Empty(cEndP),'',AllTrim(TRB->A1_BAIRRO))
				cMun		:= If(!Empty(cEndP),'',AllTrim(TRB->A1_MUN))
				cUF			:= AllTrim(TRB->A1_EST)
				cCep		:= AllTrim(TRB->A1_CEP)
			EndIF
			cTel		:= If(!Empty(cTel),Alltrim(cTel),Alltrim(TRB->A1_DDD)+AllTrim(TRB->A1_TEL))
			cEmail		:= ""	//AllTrim(TRB->A1_XEMAIL)
			cContato	:= IF(!Empty(cContato),Alltrim(cContato),AllTrim(TRB->A1_CONTATO))
			lAtivo		:= .T. //IIF(TRB->A1_MSBLQL=="2",.T.,.F.) // comentado pois se o cliente estiver bloqueado, vai inativar no Equipe Remota
			cCNPJ		:= AllTrim(TRB->A1_CGC)
		EndIf
		TRB->( dbCloseArea() )

		// Consulta por Fornecedor
	ElseIf nTipo == 2
		// Monta Query de Consulta
		cQuery := "SELECT * "
		cQuery += "FROM " +RetSqlName("SA2") + " AS SA2 "
		cQuery += "WHERE "
		cQuery += "SA2.A2_COD = '"+cCliFor+"' AND SA2.A2_LOJA = '"+cLoja+"' "
		cQuery += "AND D_E_L_E_T_ = '' "

		cQuery := ChangeQuery(cQuery)

		If Select("TRB") > 0
			TRB->(dbCloseArea())
		EndIf

		TCQUERY cQuery NEW ALIAS "TRB"

		dbSelectArea("TRB")
		TRB->(dbGoTop())
		If TRB->( !EOF() )
			cCodLoja	:= TRB->A2_COD+TRB->A2_LOJA
			cNome		:= AllTrim(TRB->A2_NOME)
			cTipo		:= TRB->A2_TIPO
			cEndereco	:= AllTrim(TRB->A2_END)
			cComplem	:= AllTrim(TRB->A2_COMPLEMEN)
			cBairro		:= AllTrim(TRB->A2_BAIRRO)
			cMun		:= AllTrim(TRB->A2_MUN)
			cUF			:= AllTrim(TRB->A2_EST)
			cCep		:= AllTrim(TRB->A2_CEP)
			cTel		:= AllTrim(TRB->A2_TEL)
			cEmail		:= "" //TRB->A2_XEMAIL
			cContato	:= AllTrim(TRB->A2_CONTATO)
			lAtivo		:= .T. 
			cCNPJ		:= AllTrim(TRB->A2_CGC)
		EndIf
		TRB->( dbCloseArea() )
	EndIf

	If !Empty(cContato)
		cObsrv := 'Chamado aberto por '+Alltrim(cContato)+' Depto - '+Alltrim(cDepto)+' Fone - '+Alltrim(cTel)+' E-mail - '+Alltrim(cXmail)
	Else
		cObsrv := ''
	EndIf
	// Prepara os dados do Cliente/Fornecedor no Array aDados
	AADD(aDados	,cAuthCode)					// aDados[1]  -> AuthCode
	AADD(aDados	,cCliCode)					// aDados[2]  -> ClientCode
	AADD(aDados	,Val(cCodLoja))				// aDados[3]  -> externalID [Cadigo+Loja]
	AADD(aDados	,"")						// aDados[4]  -> matricula
	AADD(aDados	,cNome)						// aDados[5]  -> nome
	AADD(aDados	,cTipo)						// aDados[6]  -> fisicaJuridica
	AADD(aDados	,cCNPJ)						// aDados[7]  -> cPFCNPJ
	AADD(aDados	,"CNOR")					// aDados[8]  -> classificacao [CNOR - Cliente normal, CIMP - Cliente importante, CMIM - Cliente muito importante]
	AADD(aDados	,cEndereco)					// aDados[9]  -> endereco
	AADD(aDados	,"")						// aDados[10] -> enderecoNumero
	AADD(aDados	,cComplem)					// aDados[11] -> enderecoComplemento
	AADD(aDados	,cBairro)					// aDados[12] -> enderecoBairro
	AADD(aDados	,cMun)						// aDados[13] -> cidade
	AADD(aDados	,cUF)						// aDados[14] -> uF
	AADD(aDados	,cCep)						// aDados[15] -> cEP
	AADD(aDados	,cTel)						// aDados[16] -> telefoneResidencial
	AADD(aDados	,cTel)						// aDados[17] -> telefoneComercial
	AADD(aDados	,cTel)						// aDados[18] -> telefoneCelular
	AADD(aDados	,cEmail)					// aDados[19] -> email
	AADD(aDados	,cObsrv)					// aDados[20] -> observacao
	AADD(aDados	,cContato)					// aDados[21] -> contatoNome
	AADD(aDados	,lAtivo)					// aDados[22] -> clienteAtivo
	AADD(aDados	,.F.)						// aDados[23] -> atendidoEmTodosTiposServicos

Return aDados

/*


?
Programa  WSKPF004  Autor  Alexandre Venancio   Data   02/05/13   
?
Desc.      Gera Array para ser utilizado na abertura da OS no mtodo  
           OpenOrdemServico			                                  
?
Uso        Integracao Keeple                                          
?


*/

User Function WSKPF004(cNumDoc,aCliFor,cXMLOS,nTpServ,nAgente,cHoraAgen,cDtAgen,cDadosCnt)

	Local cAuthCode		:= SuperGetMV("MV_XWSK002",.T.,"DCD770EB50443E0A0EA3EF2B06AF6394EEAC08CB")
	Local cCliCode		:= SuperGetMV("MV_XWSK000",.T.,"Q64E8XIJ6NV4F1KGU3I1")
	Local aDadosOS		:= {}
	Local nAtendID		:= SuperGetMV("MV_XWSK008",.T.,0)
	Local cPriori		:= SuperGetMV("MV_XWSK009",.T.,"N")
	Local cDtCriac		:= ""
	Local cDtHrAgen		:= ""
	Local cDtAux		:= ""
	Local cHrMais		:= SuperGetMV("MV_XWSK010",.T.,1)
	Local cTime			:= ""
	Local cHora			:= ""
	Local cMin			:= ""
	Local cSeg			:= ""
	Local ltrocadia		:= .F.
	Default cNumDoc		:= ""
	Default aCliFor		:= {}
	Default cXMLOS		:= ""
	Default nTpServ		:= 0
	Default nAgente		:= 0
	Default cHoraAgen	:= ""
	Default cDtAgen		:= ''

	// Verifica parametros
	If Alltrim(cNumDoc) == ""
		MsgAlert("O parametro Numero de documento nao foi informado!","WSKPF004")
		//Return
	EndIf

	If Len(aCliFor) == 0
		MsgAlert("O parametro Dados do Fornecedor/Cliente nao foi informado!","WSKPF004")
		//Return
	EndIf

	If Empty(cXMLOS)
		MsgAlert("O parametro Xml da OS nao foi informado!","WSKPF004")
		//Return
	EndIf

	If nTpServ == 0
		MsgAlert("O parametro Tipo de formulario nao foi informado!","WSKPF004")
		//Return
	EndIf

	If nTpServ == 0
		MsgAlert("O parametro Codigo do agente nao foi informado!","WSKPF004")
		//Return
	EndIf

	Set Century On	// muda padrao da data para ano com 4 digitos

	// Hora do momento
	cTime := Time()
	cHora := SubStr(cTime, 1, 2)
	cMin := SubStr(cTime, 4, 2)
	cSeg := SubStr(cTime, 7, 2)

	//SOAPDTMOUNT(DATA,HORA)
	// Acrescenta valor a hora do momento - para uso na Data da solicitacao e Data do agendamento
	cHora := Val(cHora)
	cHora := cHora + cHrMais
	cHora := AllTrim(Str(cHora))
	cHora := PadL(cHora,2,"0")
	If cHora == "24"
		cHora := "00"
		ltrocadia := .T.
	EndIf
	cHora += ":" +cMin +":" +cSeg

	// Data da Criacao - Data e hora do momento
	cDtCriac := Date()
	If ltrocadia
		cDtCriac++
	EndIf

	cDtCriac := DtoC(cDtCriac)
	cDtCriac := StrTran(cDtCriac,"/","-")
	cDtCriac := SubStr(cDtCriac,7) +"-" +SubStr(cDtCriac,4,2) +"-" +SubStr(cDtCriac,1,2)
	cDtAux := cDtCriac

	// data/hora criacao/solicitacao
	cDtCriac += "T" +cTime

	// Data/hora do agendamento
	If !Empty(cDtAgen)
		cDtAgen := Dtoc(cDtAgen)
		cDtAgen := StrTran(cDtAgen,"/","-")
		cDtAgen := SubStr(cDtAgen,7) +"-" +SubStr(cDtAgen,4,2) +"-" +SubStr(cDtAgen,1,2)
		cDtAux 	:= cDtAgen
	EndIf

	If Empty(cHoraAgen)
		cHoraAgen := cHora
	EndIf

	cDtHrAgen := cDtAux +"T" +cHoraAgen+If(len(cHoraAgen)==5,":00","")  //aqui

	// Monta Array da OS
	AADD(aDadosOS, cAuthCode)			// aDadosOS[1]	-> AuthCode
	AADD(aDadosOS, cCliCode)			// aDadosOS[2]	-> ClientCode
	AADD(aDadosOS, Val(cNumDoc))		// aDadosOS[3]	-> externalID				[Numero do documento]
	AADD(aDadosOS, aCliFor[3])			// aDadosOS[4]	-> externalClientID			[Cd do Fornecedor/Cliente Praticca]
	AADD(aDadosOS, nTpServ)				// aDadosOS[5]	-> externalTipoServicoID	[ID do Tipo de servio: 1 - Nota Fiscal Oculta | 2 - Leitura de maquina de cafe | 3 - Sangria | 4 - Abastecimento ]
	AADD(aDadosOS, nAtendID)			// aDadosOS[6]	-> externalAtendenteID		[Valor ainda nao utilizado]
	AADD(aDadosOS, cDtCriac)			// aDadosOS[7]	-> dataSolicitacao			[Data e hora que o cliente fez a solicitao do servio]
	AADD(aDadosOS, cPriori)				// aDadosOS[8]	-> Prioridade				[N - Normal, A - Alta, U - Urgente]
	AADD(aDadosOS, aCliFor[21])			// aDadosOS[9]	-> contatoNome
	AADD(aDadosOS, aCliFor[17])			// aDadosOS[10]	-> contatoTelefone
	AADD(aDadosOS, aCliFor[9])			// aDadosOS[11]	-> Endereco
	AADD(aDadosOS, aCliFor[10])			// aDadosOS[12]	-> enderecoNumero
	AADD(aDadosOS, aCliFor[11])			// aDadosOS[13]	-> enderecoComplemento
	AADD(aDadosOS, aCliFor[12])			// aDadosOS[14]	-> enderecoBairro
	AADD(aDadosOS, aCliFor[13])			// aDadosOS[15]	-> Cidade
	AADD(aDadosOS, aCliFor[14])			// aDadosOS[16]	-> uF
	AADD(aDadosOS, aCliFor[15])			// aDadosOS[17]	-> cEP
	AADD(aDadosOS, aCliFor[20])					// aDadosOS[18]	-> Descricao //AQUI
	AADD(aDadosOS, 0)					// aDadosOS[19]	-> Latitude
	AADD(aDadosOS, 0)					// aDadosOS[20]	-> Longitude
	AADD(aDadosOS, iF(!Empty(cDtAgen),cDtAgen,cDtCriac))			// aDadosOS[21]	-> dataCriacao
	AADD(aDadosOS, "")					// aDadosOS[22]	-> enderecoReferencia
	AADD(aDadosOS, 0)					// aDadosOS[23]	-> numeroOS
	AADD(aDadosOS, cXMLOS)				// aDadosOS[24]	-> dynFormCreateFormXML
	AADD(aDadosOS, nAgente)				// aDadosOS[25]	-> agenteCodigo
	AADD(aDadosOS, cDtHrAgen)			// aDadosOS[26]	-> dataHoraAgendamento

Return aDadosOS


/*


?
Programa  WSKPF007  Autor  Alexandre Venancio   Data   02/05/13   
?
Desc.      Alimenta arquivos de log de erro de todos os mtodos.      
                                                                      
?
Uso        Integracao Keeple                                          
?


*/

User Function WSKPF007(cMetodo,cErro,aDados)

	Local cPathLog	:= SuperGetMV("MV_XWSK013", .T.,"\system\xml\wskeeple\")			// Destino dos Logs
	Local cPathOld	:= SuperGetMV("MV_XWSK014", .T.,"\system\xml\wskeeple\old\")		// Destino dos Logs antigos
	Local nTamMax	:= SuperGetMV("MV_XWSK015", .T.,512000)							// Tamanho maximo de cada arquivo - em Bytes
	Local cLogErro	:= ""
	Local aInfo		:= {}
	Local cMicro	:= ""
	Local cNumIP	:= ""
	Local nHdl
	Local nTamArq
	Local cTime		:= ""
	Local cHora		:= ""
	Local cMin		:= ""
	Local cSeg		:= ""
	Local cMes		:= ""
	Local nAno
	Local lRet		:= .F.
    Local nJ
    Local nI
    Local nK

	Default cMetodo := ""
	Default cErro	:= ""
	Default aDados	:= {}

	// Verifica parmetros
	If Empty(cMetodo)
		MsgAlert("O parmetro Mtodo  invlido!", "WSKPF007")
		Return
	EndIf

	If Empty(cErro)
		MsgAlert("O parmetro Erro  invlido!", "WSKPF007")
		Return
	EndIf

	If Len(aDados) == 0
		MsgAlert("O parmetro Dados Enviados  invlido!", "WSKPF007")
		Return
	EndIf

	// Nome do Log
	cLogErro := "ws_error_" +Lower(cMetodo) +DtoS(Date()) +".log"

	// Verifica existencia do diretorio de log
	If !ExistDir(cPathLog)
		MakeDir(cPathLog)
	EndIf

	// Verifica existencia do arquivo de log
	If !File(cPathLog+cLogErro)
		// Cria arquivo
		nHdl := FCreate(cPathLog+cLogErro)
		If nHdl == -1
			//MsgInfo("Erro de abertura do arquivo de log:" +Str(Ferror()))
		EndIf
	Else
		// Abre arquivo para gravao
		nHdl := FOpen(cPathLog+cLogErro , FO_READWRITE + FO_SHARED )
		If nHdl == -1
			//MsgInfo("Erro de abertura do arquivo de log: " +Str(FError()))
		EndIf
	EndIf

	// Grava erro no arquivo de log
	If nHdl <> -1
		// Determina o tamanho do arquivo e ja posiciona no final
		nTamArq := FSeek(nHdl, 0, 2)

		cMicro := GetComputerName()
		cNumIP := GetClientIP()
		aInfo := GetUserInfoArray()
		cNomUser := aInfo[1][1]

		// Grava
		FWrite(nHdl, CRLF)
		FWrite(nHdl, "Erro de execuo do mtodo " +cMetodo +CRLF)			// Adiciona descricao do log
		FWrite(nHdl, cErro +CRLF +CRLF)										// Adiciona o Erro do Web Service
		FWrite(nHdl, "Parmetros enviados " +CRLF)							// Parametros enviados ao metodo
		FWrite(nHdl, Replicate("-",91) +CRLF)
		FWrite(nHdl, "Ordem	|   Tipo   | Valor" +CRLF)
		FWrite(nHdl, Replicate("-",91) +CRLF)

		// Adiciona no log os parametros enviados
		For nI := 1 To Len(aDados)
			If ValType(aDados[nI]) == "C"
				FWrite(nHdl, +AllTrim(Str(nI)) +"	| String" +"   | " +aDados[nI] +CRLF)
			ElseIf ValType(aDados[nI]) == "N"
				FWrite(nHdl, +AllTrim(Str(nI)) +"	| Inteiro" +"  | " +AllTrim(Str(aDados[nI])) +CRLF)
			ElseIf Valtype(aDados[nI]) == "L"
				FWrite(nHdl, +AllTrim(Str(nI)) +"	| Booleano" +" | " +IIF(aDados[nI] == .T.,".T.",".F.") +CRLF)
			ElseIf ValType(aDados[nI]) == "A"
				FWrite(nHdl, +AllTrim(Str(nI)) +"	| Array" +CRLF)
				For nJ := 1 To Len(aDados[nI])
					If ValType(aDados[nI][nJ]) == "C"
						FWrite(nHdl, +AllTrim(Str(nI)) +"/" +AllTrim(Str(nJ)) +"	| String" +"   | " +aDados[nI][nJ] +CRLF)
					ElseIf ValType(aDados[nI][nJ]) == "N"
						FWrite(nHdl, +AllTrim(Str(nI)) +"/" +AllTrim(Str(nJ)) +"	| Inteiro" +"  | " +AllTrim(Str(aDados[nI][nJ])) +CRLF)
					ElseIf Valtype(aDados[nI][nJ]) == "L"
						FWrite(nHdl, +AllTrim(Str(nI)) +"/" +AllTrim(Str(nJ)) +"	| Booleano" +" | " +IIF(aDados[nI][nJ] == .T.,".T.",".F.") +CRLF)
					ElseIf ValType(aDados[nI][nJ]) == "A"
						FWrite(nHdl, +AllTrim(Str(nI)) +"/" +AllTrim(Str(nJ)) +"	| Array" +"    | "  +"Incompatvel para o parametro" +CRLF)
					ElseIf ValType(aDados[nI][nJ]) == "O"
						FWrite(nHdl, +AllTrim(Str(nI)) +"/" +AllTrim(Str(nJ)) +"	| Objeto" +"    | "  +"Incompatvel para o parametro" +CRLF)
					ElseIf ValType(aDados[nI][nJ]) == "B"
						FWrite(nHdl, +AllTrim(Str(nI)) +"/" +AllTrim(Str(nJ)) +"	| Bloco" +"    | "  +"Incompatvel para o parametro" +CRLF)
					EndIf
				Next nJ

				// Somente sera passado objeto nos metodos
				// GetAnswerFormByListOfOrdemServicoExternalID / GetAnswerFormByListOfOrdemNumeroOS
				// O objeto fica na quarta posicao do Array
			ElseIf ValType(aDados[nI]) == "O"
				FWrite(nHdl, +AllTrim(Str(nI)) +"	| Objeto" +CRLF)
				For nK := 1 To Len(aDados[nI]:nInt)
					If ValType(aDados[nI]:nInt[nK]) == "C"
						FWrite(nHdl, +AllTrim(Str(nI)) +"/" +AllTrim(Str(nK)) +"	| String" +"   | " +aDados[nI]:nInt[nK] +CRLF)
					ElseIf ValType(aDados[nI]:nInt[nK]) == "N"
						FWrite(nHdl, +AllTrim(Str(nI)) +"/" +AllTrim(Str(nK)) +"	| Inteiro" +"  | " +AllTrim(Str(aDados[nI]:nInt[nK])) +CRLF)
					ElseIf ValType(aDados[nI]:nInt[nK]) == "L"
						FWrite(nHdl, +AllTrim(Str(nI)) +"/" +AllTrim(Str(nK)) +"	| Booleano" +" | " +IIF(aDados[nI]:nInt[nK] == .T., ".T.",".F.") +CRLF)
					ElseIf ValType(aDados[nI]:nInt[nK]) == "A"
						FWrite(nHdl, +AllTrim(Str(nI)) +"/" +AllTrim(Str(nK)) +"	| Array" +"    | "  +"Incompatvel para o parametro" +CRLF)
					ElseIf ValType(aDados[nI]:nInt[nK]) == "O"
						FWrite(nHdl, +AllTrim(Str(nI)) +"/" +AllTrim(Str(nK)) +"	| Objeto" +"    | "  +"Incompatvel para o parametro" +CRLF)
					ElseIf ValType(aDados[nI]:nInt[nK]) == "B"
						FWrite(nHdl, +AllTrim(Str(nI)) +"/" +AllTrim(Str(nK)) +"	| Bloco" +"    | "  +"Incompatvel para o parametro" +CRLF)
					EndIf
				Next nK
			EndIf
		Next nI

		FWrite(nHdl, Replicate("-",91) +CRLF)
		FWrite(nHdl, CRLF)
		FWrite(nHdl, "Dados complementares" +CRLF)		 		// Dados do micro de origem
		FWrite(nHdl, "Usurio: " +cNOmUser +CRLF)				// Nome do usuario
		FWrite(nHdl, "Computador: " +cMicro +CRLF)				// Nome do computador
		FWrite(nHdl, "Endereo IP: " +cNumIP +CRLF)				// Endereco IP

	EndIf

	// Fecha arquivo
	FClose(nHdl)

	/*------------------+
	| move os arquivos	|
	+------------------*/
	// Abre arquivo para leitura - modo exclusivo
	nHdl := FOpen(cPathLog+cLogErro , FO_READ + FO_EXCLUSIVE )

	If nHdl == -1
		//MsgInfo("Erro de abertura do arquivo de log: " +Str(FError()))
		Return
	EndIf

	// Determina o tamanho do arquivo e ja posiciona no final
	nTamArq := FSeek(nHdl, 0, 2)

	// Se excedeu o tamanho
	If nTamArq >= nTamMax
		nAno := YEAR(Date())
		nAno := AllTrim(Str(nAno))
		cMes := cMonth(Date())
		cMes := AllTrim(cMes)

		cTime := Time()
		cHora := SubStr(cTime, 1, 2)
		cMin := SubStr(cTime, 4, 2)
		cSeg := SubStr(cTime, 7, 2)

		// Verifica existencia do diretorio de logs antigos
		// ex: \system\xml\wskeeple\old\2013\April
		If !ExistDir(cPathOld)
			MakeDir(cPathOld)
		EndIf

		If !ExistDir(cPathOld +nAno)
			MakeDir(cPathOld +nAno)
		EndIf

		If !ExistDir(cPathOld +nAno +"\" +cMes)
			MakeDir(cPathOld +nAno +"\" +cMes)
		EndIf

		// Fecha arquivo
		FClose(nHdl)

		// Verifica existencia do mesmo arquivo no diretorio destino
		If !File( cPathOld +nAno +"\" +cMes +"\" +cLogErro )
			FRename( cPathLog +cLogErro, cPathOld +nAno +"\" +cMes +"\" +cLogErro )
		Else
			// Altera o nome do arquivo retirando sua extensao
			cLogErro := FileNoExt(cLogErro)

			// Move renomeando - adiciona hora + min + seg ao final
			FRename( cPathLog +cLogErro +".log", cPathOld +nAno +"\" +cMes +"\" +cLogErro +"_" +cHora +cMin +cSeg +".log" )
		EndIf
	EndIf

Return lRet

/*/{Protheus.doc} ChmTec01
    (long_description)
    @type  Static Function
    @author user
    @since 06/03/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @ OS de Atendimento Tecnico
    (examples)
    @see (links_or_references)
/*/
Static Function ChmTec01()

Local aArea     :=  GetArea()
Local cRetXml   :=  ''

cRetXml := '<?xml version="1.0" encoding="utf-8"?>'
cRetXml += '<DynFormAnswer>'
cRetXml += '<ItemAnswer>'
cRetXml += '<ItemCode>1</ItemCode>'
cRetXml += '<TextAnswer>TIPO_DE_INTERVENCAO</TextAnswer>'
cRetXml += '</ItemAnswer>'
cRetXml += '<ItemAnswer>'
cRetXml += '<ItemCode>2</ItemCode>'
cRetXml += '<TextAnswer>NOME_DO_RECLAMANTE</TextAnswer>'
cRetXml += '</ItemAnswer>'
cRetXml += '<ItemAnswer>'
cRetXml += '<ItemCode>3</ItemCode>'
cRetXml += '<TextAnswer>DEPARTAMENTO_DO_RECLAMANTE</TextAnswer>'
cRetXml += '</ItemAnswer>'
/*cRetXml += '<ItemAnswer>'
cRetXml += '<ItemCode>4</ItemCode>'
cRetXml += '<TextAnswer>E_MAIL_DO_RECLAMANTE</TextAnswer>'
cRetXml += '</ItemAnswer>'
cRetXml += '<ItemAnswer>'
cRetXml += '<ItemCode>5</ItemCode>'
cRetXml += '<TextAnswer>TELEFONE_DO_RECLAMANTE</TextAnswer>'
cRetXml += '</ItemAnswer>'
cRetXml += '<ItemAnswer>'
cRetXml += '<ItemCode>6</ItemCode>'
cRetXml += '<TextAnswer>EQUIPAMENTO</TextAnswer>'
cRetXml += '</ItemAnswer>'
cRetXml += '<ItemAnswer>'
cRetXml += '<ItemCode>7</ItemCode>'
cRetXml += '<TextAnswer>PECAS_SUGERIDAS</TextAnswer>'
cRetXml += '</ItemAnswer>'*/
cRetXml += '</DynFormAnswer>'

RestArea(aArea)

Return(cRetXML)
