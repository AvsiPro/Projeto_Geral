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

//| Descricoes de formulario

Static DESCFORM1	:= "CONFERENCIA CEGA"
Static DESCFORM2	:= "LEITURA DE MAQUINA"
Static DESCFORM3	:= "SANGRIA"
Static DESCFORM4	:= "ABASTECIMENTO"
Static DESCFORM6	:= "CORRECAO DE ABASTECIMENTO"  //NAO UTILIZA MAIS
Static DESCFORM7	:= "MANUTENCAO"
Static DESCFORM8	:= "ABASTECIMENTO BEBIDAS"
Static DESCFORM9	:= "LEITURA DE MAQUINA"
Static DESCFORM11	:= "CORRECAO DE SANGRIA"
Static DESCFORM13	:= "ENTREGAS"
Static DESCFORM14	:= "INCLUSAO SIST PAGTO"
Static DESCFORM15	:= "ALTERACAO SIST PAGTO"
Static DESCFORM16	:= "INSTALACAO"
Static DESCFORM17	:= "REMOCAO"
Static DESCFORM18	:= "CORRECAO ABASTEC BEBIDAS"
Static DESCFORM19	:= "CORRECAO ABASTECIMENTO"
Static DESCFORM20	:= "AVISO INVENTARIO"
Static DESCFORM21	:= "INVENTARIO"
Static DESCFORM5151 := "ATIVACAO"
Static DESCFORM1008 := "ATIVACAO"
Static DESCFORM1002 := "FUSAO"
Static DESCFORM1003 := "LANCAMENTO"

/*


?
Programa   WSKPF001 Autor  Alexandre Venancio   Data   02/05/13   
?
Desc.      Funo utilizada para Deserializar uma String retornada	  
           pelos mtodos: 											  
           GetAnswerFormByListOfOrdemServicoExternalID e              
			  GetAnswerFormByListOfOrdemServicoExternalID				  
?
Uso        Integracao Keeple                                          
?


*/

User Function WSKPF001(cString)

	Local cIniTag	:= "\u003c" // -> Abertura de TAG <
	Local cFimTag	:= "\u003e" // -> Fechamento de TAG >
	Local cEscape	:= "\" 	  	// -> Escapa valores entre aspas
	Local cLastChv	:= "}"	  	// -> Ultima chave de fechamento da String
	Local nPosIni	:= 0
	Local nPosFim	:= 0
	Local nLastChv	:= 0
	Local nI		:= 0
	Local cNewStr	:= ""

	nPosIni := AT(cIniTag,cString) 			//| Verifica primeira ocorrncia do inicio de tag - "\u003c"
	cString := SubStr(cString,nPosIni)		//| Inicia recorte da String
	nLastChv := AT(cLastChv,cString) 		//| Procura ultima chave "}"
	cString := SubStr(cString,1,nLastChv-1) //| Recorta a ultima chave da String - "}"

	//|---Varre String passada por parmetro e gera uma nova---|\\

	For nI := 1 To Len(cString)
		If !(SubStr(cString,nI,1) $ "\")
			cNewStr += EncodeUTF8( NoAcento( SubStr(cString,nI,1) ) )
		Else

			//|---Verifica Inicio de TAG Serializado---|\\

			If SubStr(cString,nI+1,1) $ "u" .And. ;
			SubStr(cString,nI+2,1) $ "0" .And. ;
			SubStr(cString,nI+3,1) $ "0" .And. ;
			SubStr(cString,nI+4,1) $ "3" .And. ;
			SubStr(cString,nI+5,1) $ "c"

				cNewStr += "<"	//| Preenche nova String com Tag de abertura "<"
				nI += 5 		//| Pula 5 caracteres da String original

				//|--- Verifica Fim de TAG Serializado---|\\

			ElseIf SubStr(cString,nI+1,1) $ "u" .And. ;
			SubStr(cString,nI+2,1) $ "0" .And. ;
			SubStr(cString,nI+3,1) $ "0" .And. ;
			SubStr(cString,nI+4,1) $ "3" .And. ;
			SubStr(cString,nI+5,1) $ "e"

				cNewStr += ">"	//| Preenche nova String com Tag de fechamento ">"
				nI += 5			//| Pula 5 caracteres da String original

			EndIf
		EndIf
	Next nI

	If SubStr( cNewStr,Len(cNewStr),1 ) == '"'
		cNewStr := SubStr( cNewStr,1,Len(cNewStr)-1 )
	EndIf

Return cNewStr

/*


?
Programa  WSKPF002  Autor  Alexandre Venancio   Data   02/05/13   
?
Desc.      Funo especfica, gera o Array com dados do Fornecedor    
           ou Cliente para uso posterior no mtodo SaveOrUpdateCliente
?
Uso        Integracao Keeple                                          
?


*/

User Function WSKPF002(nTipo,cCliFor,cLoja,cNumChapa,cCodPA,cContato,cDepto,cTel,cXmail,cDadosCnt)

	Local aDados 	:= {}
	Local cQuery 	:= ""
	Local cAuthCode	:= SuperGetMV("MV_XWSK001",.T.,"CB467841C87120B92AEF4C2B64469334A1FE8F65")       //ok
	Local cCliCode	:= SuperGetMV("MV_XWSK000",.T.,"VMJ35ACMPDYO4GBA0CYI")                           //ok
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
	Local cEndPA	:= ''
	Local cBaiPA	:= ''
	Local cMunPA	:= ''
	Local cEstPA	:= ''
	Local cCepPA	:= ''
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
		MsgAlert("O parmetro Tipo da busca no foi informado!","WSKPF002")
		Return
	EndIf

	If Empty(cCliFor)
		MsgAlert("O parmetro Cliente/Fornecedor no foi informado!","WSKPF002")
		Return
	EndIf

	If Empty(cLoja)
		MsgAlert("O parmetro Loja no foi informado!","WSKPF002")
		Return
	EndIf

	If nTipo == 1 //| Consulta por Cliente

		//| Monta Query de Consulta

		cQuery := "SELECT * "
		cQuery += "FROM " +RetSqlName("SA1") + " AS SA1 "
		cQuery += "WHERE "
		cQuery += "SA1.A1_COD = '"+cCliFor+"' AND SA1.A1_LOJA = '"+cLoja+"' "
		cQuery += "AND D_E_L_E_T_ = '' "

		cQuery := ChangeQuery(cQuery)

		//| Se rea j estiver aberta, fecha

		If Select("TRB") > 0
			TRB->(dbCloseArea())
		EndIf

		TCQUERY cQuery NEW ALIAS "TRB"

		dbSelectArea("TRB")
		TRB->(dbGoTop())
		If TRB->( !EOF() )
			cCodLoja	:= TRB->A1_COD+TRB->A1_LOJA
			cNome		:= AllTrim(TRB->A1_NOME)
			cTipo		:= TRB->A1_TIPO
			If !Empty(cDadosCnt)
				DbSelectArea("ABS")
				DbSetOrder(1)
				If Dbseek(xFilial("ABS")+cDadosCnt)
					cNome		:= Alltrim(ABS->ABS_DESCRI) + " - Numero Contratao - "+cCodPA
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

		// Se rea j estiver aberta, fecha
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
			lAtivo		:= .T. //IIF(TRB->A2_MSBLQL=="2",.T.,.F.) // comentado pois se o fornecedor estiver bloqueado, vai inativar no Equipe Remota
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
	AADD(aDados	,Val(cCodLoja))				// aDados[3]  -> externalID [Cdigo+Loja]
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


?
Programa  WSKPF003  Autor  Alexandre Venancio   Data   02/05/13   
?
Desc.      Funo especfica para gerar o XML com dados da Nfe.		  
           Esse Xml  utilizado como parametro n24 no mtodo         
           OpenOrdemServico											  
?
Uso        Integracao Keeple                                          
?


*/
//User Function WSKPF003(nTpServ,cNumNF,cSerie,cForCli,cCodLj,nTpNF)

/*


?
Programa  WSKPF004  Autor  Alexandre Venancio   Data   02/05/13   
?
Desc.      Gera Array para ser utilizado na abertura da OS no mtodo  
           OpenOrdemServico			                                  
?
Uso        Integracao Keeple                                          
?


*/

User Function WSKPF004(cNumDoc,aCliFor,cXMLOS,nTpServ,nAgente,cHoraAgen,cDtAgen,cDadosCnt)

	Local cAuthCode		:= SuperGetMV("MV_XWSK002",.T.,"500F902FEB607FE6816FAD7CD0EC7A562EE1FFB7")
	Local cCliCode		:= SuperGetMV("MV_XWSK000",.T.,"VMJ35ACMPDYO4GBA0CYI")
	Local aDadosOS		:= {}
	Local nAtendID		:= SuperGetMV("MV_XWSK008",.T.,0)
	Local cPriori		:= SuperGetMV("MV_XWSK009",.T.,"N")
	Local cMsgAviso		:= ""
	Local cDtSolic		:= ""
	Local cDtCriac		:= ""
	Local cDtHrAgen		:= ""
	Local cDtAux		:= ""
	Local cHrMais		:= SuperGetMV("MV_XWSK010",.T.,1)
	Local cTime			:= ""
	Local cHoraINi		:= ""
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
		MsgAlert("O parmetro Nmero de documento no foi informado!","WSKPF004")
		Return
	EndIf

	If Len(aCliFor) == 0
		MsgAlert("O parmetro Dados do Fornecedor/Cliente no foi informado!","WSKPF004")
		Return
	EndIf

	If Empty(cXMLOS)
		MsgAlert("O parmetro Xml da OS no foi informado!","WSKPF004")
		Return
	EndIf

	If nTpServ == 0
		MsgAlert("O parmetro Tipo de formulrio no foi informado!","WSKPF004")
		Return
	EndIf

	If nTpServ == 0
		MsgAlert("O parmetro Cdigo do agente no foi informado!","WSKPF004")
		Return
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

	// data/hora agendamento
	//cDtAux := cDtAux +"T" +cHora      //aqui

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

	//If "Troca de Tabela" $ cDadosCnt
	//	cDadosCnt := "Ateno para a Troca de Tabela, nova Tabela utilizada: "+substr(cDadosCnt,1,3)
	//EndIf
    nTpServ := 9
	// Monta Array da OS
	AADD(aDadosOS, cAuthCode)			// aDadosOS[1]	-> AuthCode
	AADD(aDadosOS, cCliCode)			// aDadosOS[2]	-> ClientCode
	AADD(aDadosOS, Val(cNumDoc))		// aDadosOS[3]	-> externalID				[Nmero do documento]
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
Programa  WSKPF005  Autor  Alexandre Venancio   Data   02/05/13   
?
Desc.      Gera Array com itens das respostas das Ordens de Servico   
           com base na resposta deserializada dos mtodos:            
           GetAnswerFormByListOfOrdemServicoExternalID				  
           GetAnswerFormByListOfOrdemNumeroOS						  
           Utilizado para classificao das Notas Fiscais.			  
?
Uso        Integracao Keeple                                          
?


*/
User Function WSKPF005(cResult,cMsgErro)

	Local oXML		:= NIL
	Local cError	:= ""
	Local cWarning	:= ""
	Local cCodCli	:= ""
	Local cLjCli	:= ""
	Local dData
	Local cHora
	Local aItens	:= {}
	Local aDados	:= {}
	Local nQuant	:= 0
	Local nItem		:= 0
	Local aCampos	:= {}
	Local cNumChapa := ""
	Local nI		:= 0

	Default cResult	:= ""
	Default cMsgErro := ""
	//Default aAnswers := {}

	// Verifica parametros
	If Empty(cResult) .And. Len(aAnswers) == 0
		//MsgAlert("O parmetro Resultado no foi informado!","WSKPF005")
		Return
	EndIf

	//Gera o Objeto XML
	If !Empty(cResult)
		oXml := XmlParser( cResult, "_", @cError, @cWarning )
		If (oXml == NIL )
			MsgStop("Falha ao gerar Objeto XML : "+cError+" / "+cWarning)
			Return aDados
		Endif
	EndIf

	aCampos := {"NUMEROOS",;					//[1]
	"NUMNF",;						//[2]
	"AGENTE",;						//[3]
	"CLIENTE",;						//[4]
	"LOJA",;						//[5]
	"DATA",;						//[6]
	"HORA",;						//[7]
	"STATUS",;						//[8]
	"ITENS"}						//[9]

	If oXML <> Nil
		If ValType(oXml:_FormAnswers:_FormAnswer) == "O"
			cNumChapa := ""
			dData := CtoD( SubStr( oXml:_FormAnswers:_FormAnswer:_STATUSDATAHORA:TEXT,1,10 ) )
			cHora := SubStr( oXml:_FormAnswers:_FormAnswer:_STATUSDATAHORA:TEXT,12 )
			cCodCli := oXml:_FormAnswers:_FormAnswer:_EXTERNALCLIENTEID:TEXT
			cCodCli := SubStr(cCodCli,1,Len(cCodCli)-4)
			cCodCli := StrZero( Val(cCodCli), TamSx3("A1_COD")[1],0 )

			cLjCli := oXml:_FormAnswers:_FormAnswer:_EXTERNALCLIENTEID:TEXT
			cLjCli := SubStr(cLjCli, Len(cLjCli)-3, Len(cLjCli) )

			If XmlChildEx( oXml:_FormAnswers:_FormAnswer:_ITEMANSWERS, "_ITEMANSWER" ) == NIL
				aDados := {}
				Return aDados
			Else
				If ValType(oXml:_FormAnswers:_FormAnswer:_ItemAnswers:_ItemAnswer:_Answer) == "O"
					If ValType(oXml:_FormAnswers:_FormAnswer:_ItemAnswers:_ItemAnswer:_Answer:_ItemQuantityAnswer) == "O"
						XmlNode2Arr(oXml:_FormAnswers:_FormAnswer:_ItemAnswers:_ItemAnswer:_Answer:_ItemQuantityAnswer, "_ItemQuantityAnswer")
						aItensXML	:= oXml:_FormAnswers:_FormAnswer:_ItemAnswers:_ItemAnswer:_Answer:_ItemQuantityAnswer
					Else
						aItensXML	:= oXml:_FormAnswers:_FormAnswer:_ItemAnswers:_ItemAnswer:_Answer:_ItemQuantityAnswer
					EndIf
				EndIf

				For nX := 1 To Len(aItensXML)
					nQuant := Val( AllTrim(aItensXML[nX]:_Qtd:TEXT) )
					nItem := Val( AllTrim(aItensXML[nX]:_ItemID:TEXT) )

					AADD(aItens, {PadL(nItem,TamSx3("D1_ITEM")[1],"0"),;	// Item da NF
					nQuant})	// Qtd do Produto
				Next nX

				aSort(aItens,,,{|x,y| x[1] < y[1]})

				AADD( aDados, {	"NUMEROOS"	,	oXml:_FormAnswers:_FormAnswer:_NUMEROOS:TEXT	})				// Numero da OS
				AADD( aDados, {	"NUMNF"		,	oXml:_FormAnswers:_FormAnswer:_ORDEMSERVICOEXTERNALID:TEXT	})	// Numero da NF
				AADD( aDados, {	"AGENTE"	,	Val (oXml:_FormAnswers:_FormAnswer:_AGENTECODIGO:TEXT )	})		// Codigo do agente
				AADD( aDados, {	"CLIENTE"	,	cCodCli	})														// cliente
				AADD( aDados, {	"LOJA"		,	cLjCli	})														// loja
				AADD( aDados, {	"DATA"		,	dData	})													   	// data
				AADD( aDados, {	"HORA"		,	cHora	})													  	// hora
				AADD( aDados, {	"STATUS"	,	oXml:_FormAnswers:_FormAnswer:_STATUS:TEXT	})					// status
				AADD( aDados, {	"ITENS"		,	aItens })														// itens

				If AllTrim(cNumChapa) <> ""
					AADD(aDados, {"PATRIMONIO", cNumChapa })
				EndIf
			EndIf
		ElseIf ValType(oXml:_FormAnswers:_FormAnswer) == "A"
			For nI := 1 To Len(oXml:_FormAnswers:_FormAnswer)
				dData := CtoD( SubStr( oXml:_FormAnswers:_FormAnswer[nI]:_STATUSDATAHORA:TEXT,1,10 ) )
				cHora := SubStr( oXml:_FormAnswers:_FormAnswer[nI]:_STATUSDATAHORA:TEXT,12 )
				cCodCli := oXml:_FormAnswers:_FormAnswer[nI]:_EXTERNALCLIENTEID:TEXT
				cCodCli := SubStr(cCodCli,1,Len(cCodCli)-4)
				cCodCli := StrZero( Val(cCodCli), TamSx3("A1_COD")[1],0 )

				cLjCli := oXml:_FormAnswers:_FormAnswer[nI]:_EXTERNALCLIENTEID:TEXT
				cLjCli := SubStr(cLjCli, Len(cLjCli)-3, Len(cLjCli) )

				If XmlChildEx( oXml:_FormAnswers:_FormAnswer[nI]:_ITEMANSWERS, "_ITEMANSWER" ) == NIL
					aDados := {}
				Else
					If ValType(oXml:_FormAnswers:_FormAnswer[nI]:_ItemAnswers:_ItemAnswer:_Answer) == "O"
						If ValType(oXml:_FormAnswers:_FormAnswer[nI]:_ItemAnswers:_ItemAnswer:_Answer:_ItemQuantityAnswer) == "O"
							XmlNode2Arr(oXml:_FormAnswers:_FormAnswer[nI]:_ItemAnswers:_ItemAnswer:_Answer:_ItemQuantityAnswer, "_ItemQuantityAnswer")
							aItensXML	:= oXml:_FormAnswers:_FormAnswer[nI]:_ItemAnswers:_ItemAnswer:_Answer:_ItemQuantityAnswer
						Else
							aItensXML	:= oXml:_FormAnswers:_FormAnswer[nI]:_ItemAnswers:_ItemAnswer:_Answer:_ItemQuantityAnswer
						EndIf
					EndIf

					aItens := {}
					For nX := 1 To Len(aItensXML)
						nQuant := Val( AllTrim(aItensXML[nX]:_Qtd:TEXT) )
						nItem := Val( AllTrim(aItensXML[nX]:_ItemID:TEXT) )

						AADD(aItens, {PadL(nItem,TamSx3("D1_ITEM")[1],"0") ,;	// Item da NF
						nQuant})								// Qtd do Produto
					Next nX

					aSort(aItens,,,{|x,y| x[1] < y[1]})

					AADD( aDados, {	"NUMEROOS"	,	oXml:_FormAnswers:_FormAnswer[nI]:_NUMEROOS:TEXT	})				// Numero da OS
					AADD( aDados, {	"NUMNF"		,	oXml:_FormAnswers:_FormAnswer[nI]:_ORDEMSERVICOEXTERNALID:TEXT	})	// Numero da OS
					AADD( aDados, {	"AGENTE"	,	Val (oXml:_FormAnswers:_FormAnswer[nI]:_AGENTECODIGO:TEXT)	})		// Codigo do agente
					AADD( aDados, {	"CLIENTE"	,	cCodCli	})															// cliente
					AADD( aDados, {	"LOJA"		,	cLjCli	})															// loja
					AADD( aDados, {	"DATA"		,	dData	})													   		// data
					AADD( aDados, {	"HORA"		,	cHora	})													  		// hora
					AADD( aDados, {	"STATUS"	,	oXml:_FormAnswers:_FormAnswer[nI]:_STATUS:TEXT })					// status
					AADD( aDados, {	"ITENS"		,	aItens })															// itens
				EndIf
			Next nI
		EndIf
	EndIf

Return aDados

/*


?
Programa  WSKPF006  Autor  Alexandre Venancio   Data   02/05/13   
?
Desc.      Recorta a String serializada do metodo OpenOrdemServico	  
             														  
?
Uso        Integracao Keeple                                          
?


*/

User Function WSKPF006(cResult,nTpServ,lInvent,oObjeto) //,aAnswers,cMsgErro,,oObjeto)

	Local oXML			:= NIL
	Local oXML2			:= NIL
	Local cError		:= ""
	Local cWarning		:= ""
	Local aDados		:= {}
	Local cCodCli		:= ""
	Local cLjCli		:= ""
	Local dDataIni
	Local cHoraIni
	Local dData
	Local cHora
	Local aResp			:= {}
	Local aSequencia	:= {}
	Local aItens
	Local aCampos		:= {}
	Local nI			:= 0
	Local nPos			:= 0
	Local aRItem		:= {}
	Default lInvent		:= .F.

	If !Empty(cResult)
		oXml := XmlParser( cResult, "_", @cError, @cWarning )
		If oXml == Nil
			MsgStop("Falha ao gerar Objeto XML : "+cError+" / "+cWarning)
			Return aDados
		Endif
	EndIf

	If Valtype(oObjeto) == "O"
		oXml2 := oObjeto
	EndIf

	aCampos := {"NUMEROOS",;					//[1]
	"AGENTE",;						//[2]
	"CLIENTE",;						//[3]
	"LOJA",;						//[4]
	"DATAINI",;						//[5]
	"HORAINI",;						//[6]
	"DATAFIM",;						//[7]
	"HORAFIM",;						//[8] //			"PATRIMONIO",;					//[9] //			"DESCRICAO_DO_PROBLEMA",;		//[10]
	"ATIVO",;		   				//[10]
	"KM",;			 				//[11]
	"HISTORICO",;					//[13]
	"PROBLEMA",;		                   	//[16]
	"OCORRENCIA",;            	//[18]
	"SOLUCAO",;
	"OP01",;
	"OP02",;
	"OP03"}

	If oXml <> Nil
		dData := CtoD( SubStr( oXml:_FormAnswers:_FormAnswer:_STATUSDATAHORA:TEXT,1,10 ) )
		cHora := SubStr( oXml:_FormAnswers:_FormAnswer:_STATUSDATAHORA:TEXT,12 )

		cCodCli := oXml:_FormAnswers:_FormAnswer:_EXTERNALCLIENTEID:TEXT
		cCodCli := SubStr(cCodCli,1,Len(cCodCli)-4)
		cCodCli := StrZero( Val(cCodCli), TamSx3("A1_COD")[1],0 )

		cLjCli := oXml:_FormAnswers:_FormAnswer:_EXTERNALCLIENTEID:TEXT
		cLjCli := SubStr(cLjCli, Len(cLjCli)-1, Len(cLjCli) )

		// sequencias de atualizacao de status
		aSequencia := oXml:_FormAnswers:_FormAnswer:_STATUSSEQUENCE:_STATUSINFO
		For nI := 1 To Len( aSequencia )
			If AllTrim(aSequencia[nI]:_STATUS:TEXT) == "INIC"
				dDataIni := CtoD( SubStr( aSequencia[nI]:_DATAHORA:TEXT,1,10 ) )
				cHoraIni := SubStr(aSequencia[nI]:_DATAHORA:TEXT,12 )
			EndIf
		Next nI

		AADD( aDados, { "NUMEROOS"	,oXml:_FormAnswers:_FormAnswer:_NUMEROOS:TEXT } )				// Numero da OS
		AADD( aDados, { "AGENTE"	,AllTrim(oXml:_FormAnswers:_FormAnswer:_AGENTECODIGO:TEXT ) } )	// Codigo do agente
		AADD( aDados, { "CLIENTE"	,cCodCli } )													// cliente
		AADD( aDados, { "LOJA"		,cLjCli } )														// loja
		AADD( aDados, { "DATAINI"	,dDataIni } )													// data ini
		AADD( aDados, { "HORAINI"	,cHoraIni } )													// hora ini
		AADD( aDados, { "DATAFIM"	,dData } )														// data fim
		AADD( aDados, { "HORAFIM"	,cHora } )														// hora fim

	ElseIf oXml2 <> Nil
		dData := CtoD( SubStr( oXml2:_STATUSDATAHORA:TEXT,1,10 ) )
		cHora := SubStr( oXml2:_STATUSDATAHORA:TEXT,12 )

		cCodCli := oXml2:_EXTERNALCLIENTEID:TEXT
		cCodCli := SubStr(cCodCli,1,Len(cCodCli)-4)
		cCodCli := StrZero( Val(cCodCli), 6 )

		cLjCli := oXml2:_EXTERNALCLIENTEID:TEXT
		cLjCli := SubStr(cLjCli, Len(cLjCli)-1, Len(cLjCli) )
		cLjCli := Strzero(val(cLjCli),4)

		// sequencias de atualizacao de status
		aSequencia := oXml2:_STATUSSEQUENCE:_STATUSINFO
		For nI := 1 To Len( aSequencia )
			If AllTrim(aSequencia[nI]:_STATUS:TEXT) == "INIC"
				dDataIni := CtoD( SubStr( aSequencia[nI]:_DATAHORA:TEXT,1,10 ) )
				cHoraIni := SubStr(aSequencia[nI]:_DATAHORA:TEXT,12 )
			EndIf
		Next nI

		AADD( aDados, { "NUMEROOS"	,oXml2:_NUMEROOS:TEXT } )				// Numero da OS
		AADD( aDados, { "AGENTE"	,AllTrim(oXml2:_AGENTECODIGO:TEXT ) } )	// Codigo do agente
		AADD( aDados, { "CLIENTE"	,cCodCli } )							// cliente
		AADD( aDados, { "LOJA"		,cLjCli } )								// loja
		AADD( aDados, { "DATAINI"	,dDataIni } )							// data ini
		AADD( aDados, { "HORAINI"	,cHoraIni } )							// hora ini
		AADD( aDados, { "DATAFIM"	,dData } )								// data fim
		AADD( aDados, { "HORAFIM"	,cHora } )								// hora fim
	EndIf

	If !lInvent
		// Quebra as respostas no array aResp
		If oXml2 <> Nil
			If ValType(oXml2:_ItemAnswers) == "A"

				aAuxPil	:=	oXml2:_ItemAnswers
				aResp :=	aAuxPil[2]:_ITEMANSWER

			ElseIf XmlChildEx(oXml2:_ItemAnswers,"_ITEMANSWER") != NIL
				aResp	:= oXml2:_ItemAnswers:_ItemAnswer
			EndIf

		Else
			If ValType(oXml:_FormAnswers:_FormAnswer:_ItemAnswers) == "A"
				aAuxPil	:=	oXml:_FormAnswers:_FormAnswer:_ItemAnswers
				aResp :=	aAuxPil[2]:_ITEMANSWER

			ElseIf XmlChildEx(oXml:_FormAnswers:_FormAnswer:_ItemAnswers,"_ITEMANSWER") != NIL
				aResp	:= oXml:_FormAnswers:_FormAnswer:_ItemAnswers:_ItemAnswer
			EndIf

			Freeobj(oXML)	//chamado

		EndIf

		For nI := 9 To Len(aCampos)
			nPos := U_WSKPF013(aResp,aCampos[nI])
			If nPos > 0
				If "OP" $ aCampos[nI]
					If XmlChildEx(aResp[nPos]:_ANSWER,"_SELECTEDALTERNATIVE") != NIL
						Aadd(aDados, { aCampos[nI] , aResp[nPos]:_ANSWER:_SELECTEDALTERNATIVE:TEXT } )	// campos texto
					EndIf
				Else
					AADD( aDados, { aCampos[nI] , aResp[nPos]:_ANSWER:TEXT } )	// campos texto
				EndIf
			EndIf

		Next nI
	EndIf

Return aDados

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

/*


?
Programa  WSKPF008  Autor  Alexandre Venancio   Data   05/11/13   
?
Desc.      Funo especfica para gerar o XML com dados do Ativo Fixo.
           Esse Xml  utilizado como parametro n24 no mtodo         
           OpenOrdemServico											  
           Utilizado na Leitura de Maquina de Cafe/Sangria/Entregas   
?
Uso        Integracao Keeple                                          
?


*/
User Function WSKPF008(nTpServ,cNumChapa,aInfo,aResp,cCliFor,cLoja,cDadosCnt)

	Local cXML := ""
	Local cTpLacre := ""
	Local cTpMoed := ""
	Local cTpLog := ""
	Local cTpTroco := ""
	Local cLac := ""
	Local cUsaTroco := ""
	Local cLog := ""
	Local cTroco := ""
	Local cMailCli := ""
	Local cMail1 := ""
	Local cMail2 := ""
	Local aAux	:=	{}

	Default cNumChapa := ""
	Default aInfo := {"","N","N","N"}	// infos auxiliares do patrimonio
	Default aResp := {}
	Default cDadosCnt := ""
	If AllTrim(cNumChapa) == "" .And. nTpServ <> 13
		MsgAlert("O parmetro Nmero do patrimnio no foi informado!","WSKPF008")
		Return
	EndIf

	If nTpServ == 2 .Or. nTpServ == 3 .Or. nTpServ == 11
		// email do cliente
		dbSelectArea("SA1")
		dbSetOrder(1)
		If dbSeek( xFilial("SA1") +AvKey(cCliFor,"A1_COD") +AvKey(cLoja,"A1_LOJA") )
			// email 1
			If !Empty(SA1->A1_EMAIL)
				cMail1 := AllTrim(lower(SA1->A1_EMAIL))
			EndIf
			// email 2
			If !Empty(SA1->A1_XEMAIL)
				cMail2 := AllTrim(lower(SA1->A1_XEMAIL))
			EndIf

			If !Empty(cMail1)
				cMailCli += cMail1
				If !Empty(cMail2)
					cMailCli += ";" +cMail2
				EndIf
			Else
				If !Empty(cMail2)
					cMailCli := cMail2
				EndIf
			EndIf
		EndIf
	EndIf

	// Sangria
	If nTpServ == 3

		If Upper(AllTrim(GetEnvServer())) == "JVVXC9_TESTE"
			cTpLacre := IF( !Empty(aInfo[1]), aInfo[1], "Sem Lacre" )
		Else
			cTpLacre := IF( !Empty(aInfo[1]), aInfo[1], "Sem Lacre" )
		EndIf

		cTpMoed := IF( !Empty(aInfo[2]), aInfo[2], "no" )
		cTpLog := IF( !Empty(aInfo[3]), aInfo[3], "no" )
		cTpTroco := IF( !Empty(aInfo[4]), aInfo[4], "no" )
		// Correcao Sangria
	ElseIf nTpServ == 11

		If Upper(AllTrim(GetEnvServer())) == "JVVXC9_TESTE"
			cTpLacre := IF( !Empty(aResp[48]), aResp[48], "Sem Lacre" )
		Else
			cTpLacre := IF( !Empty(aResp[48]), aResp[48], "Sem lacre" )
		EndIf
		cTpMoed := IF( !Empty(aResp[49]), aResp[49], "no" )
		cTpLog := IF( !Empty(aResp[50]), aResp[50], "no" )
		If cTpMoed == "sim"
			cTpTroco := "sim"
		Else
			cTpTroco := "no"
		EndIf
	EndIf

	// Monta XML
	// leitura maquina cafe
	If nTpServ == 2
		cXML := "<?xml version='1.0' encoding='utf-8'?>"
		cXML += "<DynFormAnswer>"
		cXML += 	"<ItemAnswer>"

		cXML += 	"<ItemID>17465</ItemID>"
		cXML += 		"<TextAnswer>"+cNumChapa+"</TextAnswer>"
		cXML +=		"</ItemAnswer>"

		// Email do Cliente -> a1_email a1_Xemail
		cXML += 	"<ItemAnswer>"
		cXML += 		"<ItemID>82909</ItemID>"	       //67804
		cXML += 		"<TextAnswer>"+cMailCli+"</TextAnswer>"
		cXML += 	"</ItemAnswer>"

		//alteracao descricao dos campos Ps

		// Itens
		cXML += 	"<ItemAnswer>"
		//If Upper(AllTrim(GetEnvServer())) == "JVVXC9_TESTE"
		//    cXML += 		"<ItemId>67820</ItemID>"
		//Else
		cXML += 		"<ItemID>82910</ItemID>"     //67820
		//EndIf

		cXML += 		"<TextAnswer>"

		cXML += 			"<valuesdefinitions>"
		cXML += 				"<value>"
		cXML += 					"<id>1</id>"
		cXML += 					"<title>Informe o valor</title>"
		cXML += 					"<type>NUMBER</type>"
		cXML += 				"</value>"
		cXML += 			"</valuesdefinitions>"
		cXML += 			"<itemsdefinitions>"

		aAux := ItenPs('',cNumChapa,cDadosCnt)
		For nX := 1 to len(aAux)
			//cLabel := ItenPs(cvaltochar(nX),cNumChapa)
			cXML += 		"<item>"
			cXML +=				"<id>P"+cvaltochar(aAux[nX,01])+"</id>"
			cXML +=				"<name>(P"+cvaltochar(aAux[nX,01])+") "+If(!Empty(aAux[nX,02]),aAux[nX,02],'Vazio')+"</name>"
			cXML +=				"<adtinfos>"
			cXML +=					"<ai>"
			cXML +=						"<vid>1</vid>"
			cXML +=						"<dfvl></dfvl>"
			cXML +=					"</ai>"
			cXML +=				"</adtinfos>"
			cXML +=			"</item>"
		Next nX

		cXML += 			"</itemsdefinitions>"
		cXML += 		"</TextAnswer>"
		cXML += 	"</ItemAnswer>"

		cXML += "</DynFormAnswer>"

		//final alteracao descricao dos campos Ps

		// sangria
	ElseIf nTpServ == 3
		cXML := "<?xml version='1.0' encoding='utf-8'?>"
		cXML += "<DynFormAnswer>"
		cXML += 	"<ItemAnswer>"
		//If Upper(AllTrim(GetEnvServer())) == "JVVXC9_TESTE"
		//	cXML +=			"<ItemID>65683</ItemID>"
		//Else
		cXML +=			"<ItemID>83826</ItemID>"  //18005
		//EndIf
		cXml += 		"<TextAnswer>"+cNumChapa+"</TextAnswer>"
		cXml += 	"</ItemAnswer>"

		// lacres
		cXml += "<ItemAnswer>"
		//If Upper(AllTrim(GetEnvServer())) == "JVVXC9_TESTE"
		//	cXml += 	"<ItemID>65693</ItemID>"
		//else
		cXml += 	"<ItemID>83827</ItemID>"     //  65684      72332
		//EndIf
		cXml +=		"<TextAnswer>"+cTpLacre+"</TextAnswer>"
		cXml += "</ItemAnswer>"

		// moedeiro
		cXml += "<ItemAnswer>"
		//If Upper(AllTrim(GetEnvServer())) == "JVVXC9_TESTE"
		//	cXml += 	"<ItemID>65694</ItemID>"
		//else
		cXml += 	"<ItemID>83828</ItemID>"     //72333
		//endif
		cXml += 	"<TextAnswer>"+cTpMoed+"</TextAnswer>"
		cXml += "</ItemAnswer>"

		// Log
		cXml += "<ItemAnswer>"
		//If Upper(AllTrim(GetEnvServer())) == "JVVXC9_TESTE"
		//	cXml += 	"<ItemID>65695</ItemID>"
		//else
		cXml += 	"<ItemID>83829</ItemID>"       //72334
		//endif
		cXml += 	"<TextAnswer>"+cTpLog+"</TextAnswer>"
		cXml += "</ItemAnswer>"

		// Troco
		cXml += 	"<ItemAnswer>"
		//If Upper(AllTrim(GetEnvServer())) == "JVVXC9_TESTE"
		//	cXml += 		"<ItemID>65696</ItemID>"
		//else
		cXml += 		"<ItemID>83830</ItemID>"    //72335
		//endif
		cXml += 		"<TextAnswer>"+cTpTroco+"</TextAnswer>"
		cXML +=		"</ItemAnswer>"

		// Email do Cliente -> a1_email a1_Xemail
		cXML += 	"<ItemAnswer>"
		//If Upper(AllTrim(GetEnvServer())) == "JVVXC9_TESTE"
		//	cXML += 		"<ItemID>67801</ItemID>"
		//else
		cXML += 		"<ItemID>83831</ItemID>"	 //72336
		//endif
		cXML += 		"<TextAnswer>"+cMailCli+"</TextAnswer>"
		cXML += 	"</ItemAnswer>"

		//If Upper(AllTrim(GetEnvServer())) != "JVVXC9_TESTE"
		//teste para enviar o POS junto
		cXML += 	"<ItemAnswer>"
		cXml += 		"<ItemID>87302</ItemID>"           //ok
		cXml += 		"<TextAnswer>"+STATICCALL(TTFINC24,POSPatr,cNumChapa)+"</TextAnswer>"	// POS
		cXml += 	"</ItemAnswer>"
		//EndIf
		//alteracao descricao dos campos Ps

		// Itens
		cXML += 	"<ItemAnswer>"
		//If Upper(AllTrim(GetEnvServer())) == "JVVXC9_TESTE"
		//	cXML += 		"<ItemID>67818</ItemID>"    //
		//Else
		cXML += 		"<ItemID>83832</ItemID>"
		//EndIf
		cXML += 		"<TextAnswer>"

		cXML += 			"<valuesdefinitions>"
		cXML += 				"<value>"
		cXML += 					"<id>1</id>"
		cXML += 					"<title>Informe o valor</title>"
		cXML += 					"<type>NUMBER</type>"
		cXML += 				"</value>"
		cXML += 			"</valuesdefinitions>"
		cXML += 			"<itemsdefinitions>"

		aAux := ItenPs('',cNumChapa)
		For nX := 1 to len(aAux)
			//    For nX := 1 to 25
			//cLabel := ItenPs(cvaltochar(nX),cNumChapa)       //aqui
			cXML += 		"<item>"
			cXML +=				"<id>P"+cvaltochar(aAux[nX,01])+"</id>"
			cXML +=				"<name>(P"+cvaltochar(aAux[nX,01])+") "+If(!Empty(aAux[nX,02]),aAux[nX,02],'Vazio')+"</name>"
			cXML +=				"<adtinfos>"
			cXML +=					"<ai>"
			cXML +=						"<vid>1</vid>"
			cXML +=						"<dfvl></dfvl>"
			cXML +=					"</ai>"
			cXML +=				"</adtinfos>"
			cXML +=			"</item>"
		Next nX

		cXML += 			"</itemsdefinitions>"
		cXML += 		"</TextAnswer>"
		cXML += 	"</ItemAnswer>"

		//final alteracao descricao dos campos Ps

		cXML += "</DynFormAnswer>"
		// Correcao Sangria
	ElseIf nTpServ == 11 .And. Len(aResp) > 0
		cXML := "<?xml version='1.0' encoding='utf-8'?>"
		cXML += "<DynFormAnswer>"
		cXML += 	"<ItemAnswer>"
		cXML +=			"<ItemID>54037</ItemID>"            //ok
		cXml += 		"<TextAnswer>"+cNumChapa+"</TextAnswer>"
		cXml += 	"</ItemAnswer>"

		// informacoes dos radio button
		// lacres
		cXml +=		"<ItemAnswer>"
		cXml += 		"<ItemID>67768</ItemID>"    // ok
		cXml +=			"<TextAnswer>"+cTpLacre+"</TextAnswer>"
		cXml += 	"</ItemAnswer>"

		// moedeiro
		cXml += 	"<ItemAnswer>"
		cXml += 		"<ItemID>67774</ItemID>"    //ok
		cXml += 		"<TextAnswer>"+cTpMoed+"</TextAnswer>"
		cXml += 	"</ItemAnswer>"
		// Log
		cXml += 	"<ItemAnswer>"
		cXml += 		"<ItemID>67775</ItemID>"         //ok
		cXml += 		"<TextAnswer>"+cTpLog+"</TextAnswer>"
		cXml += 	"</ItemAnswer>"

		// Troco
		cXml += 	"<ItemAnswer>"
		cXml += 		"<ItemID>67776</ItemID>"          //ok
		cXml += 		"<TextAnswer>"+cTpTroco+"</TextAnswer>"
		cXML +=		"</ItemAnswer>"

		// Email do Cliente -> a1_email a1_Xemail
		cXML += 	"<ItemAnswer>"
		If Upper(AllTrim(GetEnvServer())) != "JVVXC9_TESTE"
			cXML += 		"<ItemID>72419</ItemID>"	   //67814
		Else
			cXML += 		"<ItemID>67814</ItemID>"	   //67814
		EndIf
		cXML += 		"<TextAnswer>"+cMailCli+"</TextAnswer>"
		cXML += 	"</ItemAnswer>"
		cXML +=		"<ItemAnswer>"
		cXml += 		"<ItemID>67777</ItemID>"             //ok
		cXml += 		"<TextAnswer>"+aResp[51]+"</TextAnswer>"	//@LACRES_M_-_LACRE_RETIRADO_MOEDEIRO
		cXML +=		"</ItemAnswer>"

		cXml += 	"<ItemAnswer>"
		cXml += 		"<ItemID>67778</ItemID>"              //ok
		cXml += 		"<TextAnswer>"+aResp[52]+"</TextAnswer>"	//@LACRES_M_-_LACRE_COLOCADO_MOEDEIRO
		cXml += 	"</ItemAnswer>"
		cXML += 	"<ItemAnswer>"
		cXml += 		"<ItemID>54088</ItemID>"           //ok
		cXml += 		"<TextAnswer>"+aResp[1]+"</TextAnswer>"	// POS
		cXml += 	"</ItemAnswer>"
		cXml += 	"<ItemAnswer>"
		cXml += 		"<ItemID>54037</ItemID>"         //ok
		cXml += 		"<TextAnswer>"+aResp[2]+"</TextAnswer>"	// PATRIMONIO
		cXml += 	"</ItemAnswer>"
		cXml += 	"<ItemAnswer>"
		cXml += 		"<ItemID>54076</ItemID>"             //ok
		cXml += 		"<TextAnswer>"+aResp[3]+"</TextAnswer>"	// ACOMPANHANTE
		cXml += 	"</ItemAnswer>"
		cXml += 	"<ItemAnswer>"
		cXml += 		"<ItemID>67769</ItemID>"             //ok
		cXml += 		"<TextAnswer>"+aResp[4]+"</TextAnswer>"	// MOEDA RETIRADO
		cXml += 	"</ItemAnswer>"
		cXml += 	"<ItemAnswer>"
		cXml += 		"<ItemID>54080</ItemID>"              //ok
		cXml += 		"<TextAnswer>"+aResp[5]+"</TextAnswer>"	// QTD 05
		cXml += 	"</ItemAnswer>"
		cXml += 	"<ItemAnswer>"
		cXml += 		"<ItemID>54105</ItemID>"              //ok
		cXml += 		"<TextAnswer>"+aResp[6]+"</TextAnswer>"	// CONTADOR 1
		cXml += 	"</ItemAnswer>"
		cXml += 	"<ItemAnswer>"
		cXml += 		"<ItemID>67773</ItemID>"               //ok
		cXml += 		"<TextAnswer>"+aResp[7]+"</TextAnswer>"	// NUMERO BANANINHA?
		cXml += 	"</ItemAnswer>"
		cXml += 	"<ItemAnswer>"
		cXml += 		"<ItemID>67771</ItemID>"               //ok
		cXml += 		"<TextAnswer>"+aResp[8]+"</TextAnswer>"	// MOEDA COLOCADO
		cXml += 	"</ItemAnswer>"
		cXml += 	"<ItemAnswer>"
		cXml += 		"<ItemID>67772</ItemID>"               //ok
		cXml += 		"<TextAnswer>"+aResp[9]+"</TextAnswer>"	// CEDULA COLOCADO
		cXml += 	"</ItemAnswer>"
		cXml += 	"<ItemAnswer>"
		cXml += 		"<ItemID>54106</ItemID>"               //ok
		cXml += 		"<TextAnswer>"+aResp[10]+"</TextAnswer>"	// CONTADOR 2
		cXml += 	"</ItemAnswer>"
		cXml += 	"<ItemAnswer>"
		cXml += 		"<ItemID>54081</ItemID>"               //ok
		cXml += 		"<TextAnswer>"+aResp[11]+"</TextAnswer>"	// QTD 0,10
		cXml += 	"</ItemAnswer>"
		cXml += 	"<ItemAnswer>"
		cXml += 		"<ItemID>67770</ItemID>"                //ok
		cXml += 		"<TextAnswer>"+aResp[12]+"</TextAnswer>"	// CEDULA RETIRADO
		cXml += 	"</ItemAnswer>"
		cXml += 	"<ItemAnswer>"

		cXml += 		"<ItemID>54089</ItemID>"                //ok
		cXml += 		"<TextAnswer>"+aResp[13]+"</TextAnswer>"	// TOTAL CASH
		cXml += 	"</ItemAnswer>"
		cXml += 	"<ItemAnswer>"
		cXml += 		"<ItemID>54090</ItemID>"                //ok
		cXml += 		"<TextAnswer>"+aResp[14]+"</TextAnswer>"	// TOTAL VENDAS QTD
		cXml += 	"</ItemAnswer>"
		cXml += 	"<ItemAnswer>"
		cXml += 		"<ItemID>54082</ItemID>"                //ok
		cXml += 		"<TextAnswer>"+aResp[15]+"</TextAnswer>"	// QTD 0,25
		cXml += 	"</ItemAnswer>"
		cXml += 	"<ItemAnswer>"
		cXml += 		"<ItemID>54107</ItemID>"                //ok
		cXml += 		"<TextAnswer>"+aResp[16]+"</TextAnswer>"	// CONTADOR 3
		cXml += 	"</ItemAnswer>"
		cXml += 	"<ItemAnswer>"
		cXml += 		"<ItemID>54108</ItemID>"                //ok
		cXml += 		"<TextAnswer>"+aResp[17]+"</TextAnswer>"	// CONTADOR 4
		cXml += 	"</ItemAnswer>"
		cXml += 	"<ItemAnswer>"
		cXml += 		"<ItemID>54083</ItemID>"                //ok
		cXml += 		"<TextAnswer>"+aResp[18]+"</TextAnswer>"	// QTD 0,50
		cXml += 	"</ItemAnswer>"
		cXml += 	"<ItemAnswer>"
		cXml += 		"<ItemID>54091</ItemID>"                //ok
		cXml += 		"<TextAnswer>"+aResp[19]+"</TextAnswer>"	// PARCIAL
		cXml += 	"</ItemAnswer>"
		cXml += 	"<ItemAnswer>"

		cXml += 		"<ItemID>54092</ItemID>"                //ok
		cXml += 		"<TextAnswer>"+aResp[20]+"</TextAnswer>"	// NUMERO TESTES
		cXml += 	"</ItemAnswer>"
		cXml += 	"<ItemAnswer>"
		cXml += 		"<ItemID>54084</ItemID>"                //ok
		cXml += 		"<TextAnswer>"+aResp[21]+"</TextAnswer>"	// QTD 1
		cXml += 	"</ItemAnswer>"
		cXml += 	"<ItemAnswer>"
		cXml += 		"<ItemID>54109</ItemID>"                //ok
		cXml += 		"<TextAnswer>"+aResp[22]+"</TextAnswer>"	// CONTADOR 5
		cXml += 	"</ItemAnswer>"

		cXML += 	"<ItemAnswer>"

		cXML += 		"<ItemID>54093</ItemID>"
		cXML += 		"<TextAnswer>"

		cXML += 			"<valuesdefinitions>"
		cXML += 				"<value>"
		cXML += 					"<id>1</id>"
		cXML += 					"<title>Informe o valor</title>"
		cXML += 					"<type>NUMBER</type>"
		cXML += 				"</value>"
		cXML += 			"</valuesdefinitions>"
		cXML += 			"<itemsdefinitions>"

		aAux := ItenPs('',cNumChapa)
		For nX := 1 to len(aAux)
			//For nX := 1 to 25
			//	cLabel := ItenPs(cvaltochar(nX),cNumChapa)
			cXML += 		"<item>"
			cXML +=				"<id>P"+cvaltochar(aAux[nX,01])+"</id>"
			cXML +=				"<name>(P"+cvaltochar(aAux[nX,01])+") "+If(!Empty(aAux[nX,02]),aAux[nX,02],'Vazio')+"</name>"
			cXML +=				"<adtinfos>"
			cXML +=					"<ai>"
			cXML +=						"<vid>1</vid>"
			cXML +=						"<dfvl>"+aResp[nX+22]+"</dfvl>"
			cXML +=					"</ai>"
			cXML +=				"</adtinfos>"
			cXML +=			"</item>"
		Next nX

		//TROCAR PARA DINAMICO FIM
		cXML += 			"</itemsdefinitions>"
		cXML += 		"</TextAnswer>"
		cXML += 	"</ItemAnswer>"

		cXML += "</DynFormAnswer>"
		//FORMULARIO DE ENTREGAS
	ElseIf nTpServ == 13
		cXml := "<?xml version='1.0' encoding='utf-8' ?>"
		cXml += "<DynFormAnswer>"
		cXml += 	"<ItemAnswer>"
		cXml += "<ItemID>"+ IIF( "TESTE" $ AllTrim(GetEnvServer()),"94408","98724" ) +"</ItemID>"
		//cXml += 		"<ItemID>94408</ItemID>"
		cXml += 		"<TextAnswer>"+aResp[1]+"</TextAnswer>"	// relacao de conferentes
		cXml += 	"</ItemAnswer>"
		cXml += "</DynFormAnswer>"
	EndIf

Return cXML

/*


?
Programa  WSKPF009  Autor  Alexandre Venancio   Data   05/11/13   
?
Desc.      Gera a Ordem de Servico.									  
           Retorna o numero da OS.									  
           											  				  
           					  										  
?
Uso        Integracao Keeple                                          
?


*/
User Function WSKPF009(nTpServ,cCliFor,cLoja,aDoc,nAgente,cHoraAgen,lFechamento,cDtAgen,cDadosCnt,aDadosSP,cCodPA,cContato,cDepto,cTel,cXmail)

	Local cRetWS001	:= ""
	Local cXMLOS	:= ""
	Local aDadosOS	:= {}
	Local aCliFor	:= {}
	Local cCodFor	:= ""
	Local cLjFor	:= ""
	Local cDescCF	:= ""
	Local cNumOS	:= ""
	Local nTipo		:= 1
	Local cNumChapa := ""
	Local cDescChapa:= ""
	Local cNumNF	:= ""
	Local cSerie	:= ""
	Local cRota		:= ""
	Local cDescRota	:= ""
	Local cDescStatus:=""
	Local cNomeAgente:= ""
	Local cDescForm := ""
	Local aItens	:= {}
	Local aLeitura	:= {}
	Local cOSOrigem	:= ""
	Local nTotSel	:= 0
	Local nTotCash	:= 0
	Local lAltTec	:= .F.
	Local lNovaOS	:= .F.
	Local aInfoPatr := {"","","",""}
	Local aResp		:= {}
	Local nTpNF		:= 0
	Local aOpcoes		:= {}
	Default nTpServ	:= 0
	Default cCliFor	:= ""
	Default cLoja	:= ""
	Default aDoc	:= {}
	Default nAgente	:= 0
	Default cHoraAgen := ""
	Default lFechamento := .F.
	Default cDtAgen	:= ''
	Default cDadosCnt	:= ''
	Default aDadosSP := {}
	Default cCodPA	:=	''

	Private cXSoapCli := "" //| Varivel do tipo Private

	/*
	?
	Valida os parametros informados
	
	*/
	If nTpServ == 0
		MsgAlert("Parmetro Tipo de Servico  invlido! ","WSKPF009")
		Return
	EndIf

	If cCliFor == ""
		MsgAlert("Parmetro Cliente/Fornecedor  invlido! ","WSKPF009")
		Return
	EndIf

	If cLoja == ""
		MsgAlert("Parmetro Loja  invlido! ","WSKPF009")
		Return
	EndIf

	If Len(aDoc) == 0
		MsgAlert("Parmetro Documento  invlido! ","WSKPF009")
		Return
	EndIf

	If nAgente == 0
		MsgAlert("Parmetro Agente  invlido! ","WSKPF009")
		Return
	EndIf

	// Conferencia cega
	If nTpServ == 11111
		nTipo := 2
		cNumNF	:= aDoc[1]
		cSerie	:= aDoc[2]
		nTpNF := aDoc[3]		// nota entrada ou saida
		If nTpNF == 1
			cCliNF := cCliFor	// fornecedor na nota
			cLjNF := cLoja		// loja na nota
		Else
			cCliNF := aDoc[4]		// cliente na nota
			cLjNF := aDoc[5]		// loja na nota
		EndIf

		// Leitura Maquina de cafe / Sangria
	ElseIf nTpServ == 22222 .Or. nTpServ == 3 .Or. nTpServ == 11
		nTipo := 1
		cNumChapa := aDoc[1]

		// caso seja sangria - considerar informacoes auxiliares
		If nTpServ == 3
			If Len(aDoc) > 1
				aInfoPatr := aDoc[2]
			EndIf
		EndIf

		// caso seja correcao de sangria - considerar respostas
		If nTpServ == 11
			If Len(aDoc) > 1
				aResp := aDoc[2]		// campos preenchidos
				cOSOrigem := aDoc[3]	// OS de origem
			EndIf
		EndIf

		cDescChapa := Posicione( "SN1", 2, xFilial("SN1") +cNumChapa, "N1_DESCRIC" )
		cRota := Posicione( "AA1",7, xFilial("AA1") +CVALTOCHAR(nAgente), "AA1_LOCAL" )
		cDescRota := Posicione( "ZZ1", 1, xFilial("ZZ1") +cRota, "ZZ1_DESCRI" )

		// Abastecimento / Correcao de abastecimento / Abastecimento de maquinas de bebidas = 8
	ElseIf nTpServ == 4 .Or. nTpServ == 88888
		nTipo := 1
		cNumNF	:= aDoc[1]
		cSerie	:= aDoc[2]
		cNumChapa := aDoc[3]
		cRota	:= aDoc[4]

		cDescChapa := Posicione( "SN1", 2, xFilial("SN1") +cNumChapa, "N1_DESCRIC" )
		cDescRota := Posicione( "ZZ1", 1, xFilial("ZZ1") +cRota, "ZZ1_DESCRI" )

		// Correcao de abastecimento
	ElseIf nTpServ == 6
		nTipo := 1
		cNumNF	:= aDoc[1]
		cSerie	:= aDoc[2]
		cNumChapa := aDoc[3]
		cRota := aDoc[4]
		aItens := aDoc[5]
		cOSOrigem := aDoc[6]
		nTotSel := aDoc[7]
		nTotCash := aDoc[8]

		cDescChapa := Posicione( "SN1", 2, xFilial("SN1") +cNumChapa, "N1_DESCRIC" )
		cDescRota := Posicione( "ZZ1", 1, xFilial("ZZ1") +cRota, "ZZ1_DESCRI" )

		// Chamado Tecnico
	ElseIf nTpServ == 1001 .Or. nTpServ == 1002 .Or. nTpServ == 8 .Or. nTpServ == 5151 .Or. nTpServ == 1008  //14
		nTipo := 1
		cNumChapa := aDoc[1]
		cRota := aDoc[2]
		cProblema := aDoc[3]
		cDescClas  := aDoc[6]
		cDescChapa := aDoc[5]
		//cDescRota := Posicione( "ZZ1", 1, xFilial("ZZ1") +cRota, "ZZ1_DESCRI" )
		cDescRota := ''
		// Entrega
	ElseIf nTpServ == 13
		nTipo := 1	// dados cliente
		cNumNF	:= aDoc[1]
		cSerie	:= aDoc[2]
		cCliNF := aDoc[3]		// cliente na nota
		cLjNF := aDoc[4]		// loja na nota
		AADD( aResp, aDoc[5] )	// relacao de conferentes
		// Alteracao sist. pagamento
	ElseIf nTpServ == 15
		cNumChapa := aDoc[1]
		cRota := aDoc[2]
		cProblema := aDoc[3]
		nTipo := 1
		cDescChapa := Posicione( "SN1", 2, xFilial("SN1") +cNumChapa, "N1_DESCRIC" )
		cDescRota := Posicione( "ZZ1", 1, xFilial("ZZ1") +cRota, "ZZ1_DESCRI" )
		//OS de instalacao de maquinas pela OMM
	ElseIf nTpServ == 16 .or. nTpServ == 17
		cNumChapa := aDoc[1]
		//cRota := aDoc[2]
		//cProblema
		nTipo := 1
	ElseIf nTpServ == 18 .or. nTpServ == 19
		nTipo := 1
		cNumNF	:= aDoc[1]
		cSerie	:= aDoc[2]
		cNumChapa := aDoc[3]
		cRota := aDoc[4]
		aItens := aDoc[5]
		cOSOrigem := aDoc[6]
		nTotSel := aDoc[7]
		nTotCash := aDoc[8]
		aLeitura := aDoc[9]

		cDescChapa := Posicione( "SN1", 2, xFilial("SN1") +cNumChapa, "N1_DESCRIC" )
		cDescRota := Posicione( "ZZ1", 1, xFilial("ZZ1") +cRota, "ZZ1_DESCRI" )

		//OS de AVISO DE INVENTARIO
	ElseIf nTpServ == 20
		cNumChapa := aDoc[1]
		cRota := aDoc[2]
		//cProblema
		nTipo := 1
		//Formularo de inventario da PA ou rota
	ElseIf nTpServ == 21
		cNumChapa := aDoc[1]
		cRota := aDoc[4]
		nTipo := 1
	EndIf

	// Monta dados do Cliente/Fornecedor
	aCliFor := U_WSKPF002(nTipo,cCliFor,cLoja,cNumChapa,cCodPA,cContato,cDepto,cTel,cXmail,cDadosCnt)

	If aCliFor <> Nil .And. Len(aCliFor) > 0
		// Monta XML para a Ordem de Servico

		// Conferencia cega
		If nTpServ == 11111
			cXMLOS := U_WSKPF003(nTpServ,aDoc[1],aDoc[2],cCliNF,cLjNF,nTpNF)

			// Leitura de Maquina de Cafe
		ElseIf nTpServ == 2222
			cXMLOS := U_WSKPF008(nTpServ,aDoc[1],,,cCliFor,cLoja,cDadosCnt)

			// Sangria	/ Correcao Sangria
		ElseIf nTpServ == 3 .Or. nTpServ == 11
			cXMLOS := U_WSKPF008(nTpServ,aDoc[1],aInfoPatr,aResp,cCliFor,cLoja)

			// Abastecimento / Correcao de Abastecimento / Abastecimento de maquinas de bebidas = 8
		ElseIf nTpServ == 4 .Or. nTpServ == 6 .Or. nTpServ == 18 .Or. nTpServ == 19
			cXMLOS := U_WSKPF017(nTpServ,aDoc[1],aDoc[2],cCliFor,cLoja,cNumChapa,cRota,aItens,nTotSel,nTotCash,cDadosCnt,aLeitura)

			// Chamado tecnico
		ElseIf nTpServ == 7
			cXMLOS := U_WSKPF018(nTpServ,cNumChapa,cProblema,cDescClas)
			//Entrega de mercadorias
		ElseIf nTpServ == 13
			cXMLOS := U_WSKPF008(nTpServ,,,aResp,,)
			//Inclusao de sistema de pagamentos.
		ElseIf nTpServ == 5151 .Or. nTpServ == 1001 .Or. nTpServ == 1002 .Or. nTpServ == 8  .Or. nTpServ == 1008 //14
			cXMLOS := U_WSKPF018(nTpServ,cNumChapa,cProblema,cDescClas)
			// Alteracao de sistema de pagamento
		ElseIf nTpServ == 15
			cXMLOS := U_WSKPF028(cNumChapa,cProblema)
			//Instalacao de maquinas via OMM
		ElseIf nTpServ == 16 .Or. nTpServ == 17
			cXMLOS := U_WSKPF030(aDoc,nTpServ)
		ElseIf nTpServ == 20
			nTpServ := 9
			cXMLOS := "<?xml version='1.0' encoding='utf-8'?>" 
			cXMLOS += "<ItemAnswer><Item>QUESTAO_1</Item><Answer>@STRING</Answer></ItemAnswer><ItemAnswer><Item>QUESTAO_2</Item><Answer>@STRING</Answer></ItemAnswer><ItemAnswer><Item>QUESTAO_3</Item><Answer>@STRING</Answer></ItemAnswer>"
		ElseIf nTpServ == 21
			cXMLOS := U_WSKPF032(cCodPa,cCliFor+cLoja)
		EndIf

		MemoWrite("xml_os.xml",cXMLOS)	//comentar

		If !Empty(cXMLOS)
			/*
			?
			Salva/Atualiza o cadastro de Cliente/Fornecedor no Equipe Remota
			Mtodo: SaveOrUpdateCliente                                     
			
			*/
			cRetWS001	:= U_WSKPC001(aCliFor)
			//cRetWS001 := 'true'
			If "true" $ cRetWS001
				// Monta o Array final para ser usado na abertura da OS
				If nTpServ == 1111 .or. nTpServ == 13 //.Or. nTpServ == 14
					aDadosOS := U_WSKPF004(aDoc[1],aCliFor,cXMLOS,nTpServ,nAgente,cHoraAgen,cDtAgen,cDadosCnt)
				Else
					aDadosOS := U_WSKPF004(cvaltochar(aCliFor[3]),aCliFor,cXMLOS,nTpServ,nAgente,cHoraAgen,cDtAgen,cDadosCnt)
				EndIf

				If Valtype(aDadosOS) == "A" .And. Len(aDadosOS) > 0

					/*
					
					Cria a Ordem de Servico no sistema Equipe Remota
					Metodo OpenOrdemServico                         
					
					*/ 
					nTpServ := 9  
					cXml := "<?xml version='1.0' encoding='UTF-8'?>"
					cXml += "<DynFormAnswer>"

					cXML += 	"<ItemAnswer>"
					cXML += 		"<ItemCode>8</ItemCode>"
					cXML += 		"<TextAnswer>"
				
					cXML += 		"<valuesdefinitions>"
					cXML += 			"<value>"
					cXML += 				"<id>1</id>"
					cXML += 				"<title>Material</title>"
					cXML += 				"<type>TEXT</type>"
					cXML += 			"</value>"
					cXML += 		"</valuesdefinitions>"
				
					cXML += 		"<itemsdefinitions>"
				
					For nX := 1 to 3
						cXML += 			"<item>"
						cXML +=					"<id>MATERIAL"+cvaltochar(nX)+"</id>"
						cXML +=					"<name>Material "+cvaltochar(nX)+"</name>"
						cXML +=					"<adtinfos>"
						cXML +=						"<ai>"
						cXML +=							"<vid>"+cvaltochar(nX)+"</vid>"
						cXML +=							"<dfvl></dfvl>"
						cXML +=						"</ai>"
						cXML +=					"</adtinfos>"
						cXML +=				"</item>"
					Next nX
				
					cXML += 		"</itemsdefinitions>"
				
					cXML +=			"</TextAnswer>"
					cXML += 	"</ItemAnswer>" 
					cXml += "</DynFormAnswer>" 
					aDadosOs[24] := cXml
					cNumOS := U_WSKPC002(aDadosOS)

					If !Empty(cNumOS) .And. "true" $ cNumOS

						aRetorno := Strtokarr(cNumOs,":")
						cNumOS := strtran(aRetorno[4],"}")

						MemoWrite(cvaltochar(cNumOS) +"_" +"xml_os.xml",cXMLOS)      //comentar

						//Alterado para no perder tempo com posicione, pois esta informao ja vem no array aclifor
						cDescCF := aClifor[5]

						cNomeAgente := Posicione( "AA1",8, xFilial("AA1") +CVALTOCHAR(nAgente), "AA1_NOMTEC" )
						cDescStatus := "Despachado"
						cDescForm := &( 'DESCFORM' +CValToChar(nTpServ) )

						/*If lFechamento
						If nTpServ == 2 .Or. nTpServ == 4 .Or. nTpServ == 6
						cDescForm += "/FECHAMENTO"
						EndIf
						EndIf*/

						// grava na tabela SZG - manutencao de OS
						/*If ChkFile("SZG")
							If RecLock("SZG",.T.)
								SZG->ZG_FILIAL 	:= xFilial("SZG")
								SZG->ZG_NUMOS	:= cNumOS
								SZG->ZG_TPFORM 	:= 5151 //nTpServ
								SZG->ZG_DESCCF	:= cDescForm
								SZG->ZG_CODTEC	:= Posicione( "AA1",8, xFilial("AA1") +CVALTOCHAR(nAgente), "AA1_CODTEC" )
								SZG->ZG_AGENTE 	:= nAgente
								SZG->ZG_AGENTED	:= cNomeAgente
								SZG->ZG_DATAINI	:= SOAPDTGETD(aDadosOS[21]) // agendamento
								SZG->ZG_HORAINI	:= SOAPDTGETT(aDadosOS[26])	// agendamento
								SZG->ZG_DTCRIAC := Date()	// novo
								SZG->ZG_HRCRIAC := Time()	// novo
								SZG->ZG_CLIFOR	:= cCliFor
								SZG->ZG_LOJA 	:= cLoja
								SZG->ZG_PATRIM 	:= cNumChapa
								SZG->ZG_STATUS	:= DESP		// DESPACHADO
								SZG->ZG_STATUSD := cDescStatus
								SZG->ZG_ENVIO 	:= IF (TYPE("cXSoapCli")== "C",cXSoapCli,"")

								SZG->( MsUnLock() )

							EndIf
						EndIf  */
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf

Return cNumOS

/*


?
Programa  WSKPF010  Autor  Alexandre Venancio   Data   19/11/13   
?
Desc.     Obtem o formulario de respostas de acordo com o servico.    
                                                                      
?
Uso        Integracao Keeple                                          
?


*/

User Function WSKPF010(nTpServ,aNumOS)

	Local cAuthCode		:= SuperGetMV("MV_XWSK006",.T.,"6241D1E1C9517582E2CBFE491E908A10C7C3DFCE")
	Local cClientCod	:= SuperGetMV("MV_XWSK000",.T.,"42CB7AEE2B2FFA173B53")
	Local aDados		:= {cAuthCode,cClientCod,aNumOS}
	Local cResWS		:= ""
	Local aDadosWS		:= {}

	cResWS := U_WSKPC006(aDados)

	If AllTrim(cResWS) <> "" .And. "FIOK" $ cResWS
		// Deserializa Resultado
		cResWS := U_WSKPF001(cResWS)
		If AllTrim(cResWS) <> ""
			// Gera um Array com os dados do XML
			If nTpServ == 1	// conferencia cega
				aDadosWS := U_WSKPF005(cResWS)
			ElseIf nTpServ == 2 .Or. nTpServ == 8	// leitura de maquina de cafe
				aDadosWS := U_WSKPF011(cResWS)
			ElseIf nTpServ == 3 .Or. nTpServ == 11	// leitura de sangria / correcao de sangria
				aDadosWS := U_WSKPF012(cResWS)
			ElseIf nTpServ == 4 .Or. nTpServ == 6 // abastecimento / correcao de abastecimento
				aDadosWS := U_WSKPF014(cResWS)
			ElseIf nTpServ == 7 // chamado tecnico
				aDadosWS := U_WSKPF019(cResWS)
			ElseIf nTpServ == 14					// inclusao sistema de pagamento
				aDadosWS := U_WSKPF027(cResWS)
			ElseIf nTpServ == 15					// alteracao sistema de pagamento
				aDadosWS := U_WSKPF029(cResWS)
			EndIf
		EndIf
	EndIf

Return aDadosWS

/*


?
Programa  WSKPF011  Autor  Alexandre Venancio   Data   19/11/13   
?
Desc.     Obtem o formulario de respostas da leitura da maquina       
          de cafe.                                                    
?
Uso        Integracao Keeple                                          
?


*/

User Function WSKPF011(cResult,aAnswers,cMsgErro,nTpServ)

	Local aDados := {}
	Local oXML
	Local cError	:= ""
	Local cWarning	:= ""
	Local cCodCli	:= ""
	Local cLjCli	:= ""
	Local dData
	Local cHora
	Local aResp
	Local aItens
	Local aCampos	:= {}
	Local nI		:= 0
	Local nPos		:= 0
	Local cCampPatr := ""
	Private cItemP	:=	-1
	Private lEntrou	:=	.T.
	Default aAnswers := {}

	If !Empty(cResult)
		oXml := XmlParser( cResult, "_", @cError, @cWarning )
		If (oXml == NIL )
			MsgStop("Falha ao gerar Objeto XML : "+cError+" / "+cWarning)
			Return aDados
		Endif
	EndIf

	If nTpServ == 2
		aCampos := {"NUMEROOS",;					//[1]
		"AGENTE",;						//[2]
		"CLIENTE",;						//[3]
		"LOJA",;						//[4]
		"DATA",;						//[5]
		"HORA",;						//[6]
		"NUMERO_DO_ATIVO",;				//[7]
		"TOTAL_DE_SELECOES",;			//[8]
		"PARCIAL",;						//[9]
		"TOTAL_COFRE_/_VALOR_VISOR",;	//[10]
		"NUMERO_DE_TESTES",;			//[11]
		"P1",;				//[12]
		"P2",;				//[13]
		"P3",;				//[14]
		"P4",;				//[15]
		"P5",;				//[16]
		"P6",;				//[17]
		"P7",;				//[18]
		"P8",;				//[19]
		"P9",;				//[20]
		"P10",;			//[21]
		"P11",;			//[22]
		"P12",;			//[23]
		"ENVIAR_COPIA_POR_E-MAIL",;//[24]
		"P13",;				//[25]
		"P14",;				//[26]
		"P15",;				//[27]
		"P16",;				//[28]
		"P17",;				//[29]
		"P18",;				//[30]
		"P19",;				//[31]
		"P20",;				//[32]
		"P21",;				//[33]
		"P22",;			//[34]
		"P23",;			//[35]
		"P24",;			//[36]
		"P25"}          //[37]
	Else
		aCampos := {"NUMEROOS",;					//[1]
		"AGENTE",;						//[2]
		"CLIENTE",;						//[3]
		"LOJA",;						//[4]
		"DATA",;						//[5]
		"HORA",;						//[6]
		"PATRIMONIO",;					//[7]
		"TOTAL_DE_SELECOES",;			//[8]
		"PARCIAL",;						//[9]
		"TOTAL_DE_CASH",;				//[10]
		"NUMERO_DE_TESTES",;			//[11]
		"CONTADOR_1_(P1)",;				//[12]
		"CONTADOR_2_(P2)",;				//[13]
		"CONTADOR_3_(P3)",;				//[14]
		"CONTADOR_4_(P4)",;				//[15]
		"CONTADOR_5_(P5)",;				//[16]
		"CONTADOR_6_(P6)",;				//[17]
		"CONTADOR_7_(P7)",;				//[18]
		"CONTADOR_8_(P8)",;				//[19]
		"CONTADOR_9_(P9)",;				//[20]
		"CONTADOR_10_(P10)",;			//[21]
		"CONTADOR_11_(P11)",;			//[22]
		"CONTADOR_12_(P12)",;			//[23]
		"ENVIAR_COPIA_POR_E-MAIL",; 	//[24]
		"CONTADOR_13_(P13)",;			//[25]
		"CONTADOR_14_(P14)",;			//[26]
		"CONTADOR_15_(P15)",;			//[27]
		"CONTADOR_16_(P16)",;			//[28]
		"CONTADOR_17_(P17)",;			//[29]
		"CONTADOR_18_(P18)",;			//[30]
		"CONTADOR_19_(P19)",;			//[31]
		"CONTADOR_20_(P20)",;			//[32]
		"CONTADOR_21_(P21)",;			//[33]
		"CONTADOR_22_(P22)",;			//[34]
		"CONTADOR_23_(P23)",;			//[35]
		"CONTADOR_24_(P24)",;			//[36]
		"CONTADOR_25_(P25)"	}           //[37]
	EndIf

	If nTpServ == 2
		cCampPatr := "NUMERO_DO_ATIVO"
	ElseIf nTpServ == 8
		cCampPatr := "PATRIMONIO"
	EndIf
	If oXml <> Nil
		dData := CtoD( SubStr( oXml:_FormAnswers:_FormAnswer:_STATUSDATAHORA:TEXT,1,10 ) )
		cHora := SubStr( oXml:_FormAnswers:_FormAnswer:_STATUSDATAHORA:TEXT,12 )

		cCodCli := oXml:_FormAnswers:_FormAnswer:_EXTERNALCLIENTEID:TEXT
		cCodCli := SubStr(cCodCli,1,Len(cCodCli)-4)
		cCodCli := StrZero( Val(cCodCli), TamSx3("A1_COD")[1],0 )

		cLjCli := oXml:_FormAnswers:_FormAnswer:_EXTERNALCLIENTEID:TEXT
		cLjCli := SubStr(cLjCli, Len(cLjCli)-3, Len(cLjCli) )

		// Quebra as respostas no array aResp
		aResp	:= oXml:_FormAnswers:_FormAnswer:_ItemAnswers:_ItemAnswer

		AADD( aDados, { "NUMEROOS"	,oXml:_FormAnswers:_FormAnswer:_NUMEROOS:TEXT } )					// Numero da OS
		AADD( aDados, { "AGENTE"	,AllTrim(oXml:_FormAnswers:_FormAnswer:_AGENTECODIGO:TEXT ) } )	// Codigo do agente
		AADD( aDados, { "CLIENTE"	,cCodCli } )														// cliente
		AADD( aDados, { "LOJA"		,cLjCli } )															// loja
		AADD( aDados, { "DATA"		,dData } )															// data
		AADD( aDados, { "HORA"		,cHora } )															// hora

		For nI := 7 To Len(aCampos)
			nPos := U_WSKPF013(aResp,aCampos[nI])
			cResp := ''
			If nTpServ == 2
				If Alltrim(aCampos[nI]) == "ENVIAR_COPIA_POR_E-MAIL" .And. nPos > 0
					If XmlChildEx(aResp[nPos]:_ANSWER,"_SELECTEDALTERNATIVE") != NIL
						cResp := aResp[nPos]:_ANSWER:_SELECTEDALTERNATIVE:TEXT
					EndIf
				EndIf
			endIf

			If aCampos[nI] $ cCampPatr
				// Ajuste para corrigir o patrimonio enviado com caracteres incorretos
				For nJ := 1 To Len(aResp[nPos]:_ANSWER:TEXT)
					If !IsDigit( SubStr(aResp[nPos]:_ANSWER:TEXT,nJ,1) )
						cMsgErro += " Patrimonio informado com caracteres invalidos. "
						aDados := {}
						Return aDAdos
					EndIf
				Next nJ
				AADD( aDados, { aCampos[nI], aResp[nPos]:_ANSWER:TEXT } )	// campos texto
			Else
				If lEntrou
					AADD( aDados, { aCampos[nI], If(cItemP==-1,If(!Empty(cResp),cResp,Val( aResp[nPos]:_ANSWER:TEXT)),cItemP)  } )	// campos numericos
				EndIf
			EndIf
		Next nI
	EndIf

Return aDados

/*


?
Programa  WSKPF012  Autor  Alexandre Venancio   Data   19/11/13   
?
Desc.     Obtem o formulario de respostas da Sangria.                 
                                                                      
?
Uso        Integracao Keeple                                          
?


*/

User Function WSKPF012(cResult,aAnswers,cMsgErro)

	Local aDados := {}
	Local oXML
	Local cError	:= ""
	Local cWarning	:= ""
	Local cCodCli	:= ""
	Local cLjCli	:= ""
	Local dData
	Local cHora
	Local aResp
	Local aItens
	Local aCampos	:= {}
	Local nI		:= 0
	Local nPos		:= 0
	Local nValor	:= 0
	Private cIteMP	:= -1

	If Empty(cResult) .And. Len(aAnswers) == 0
		Return aDados
	EndIf

	If !Empty(cResult)
		oXml := XmlParser( cResult, "_", @cError, @cWarning )
		If (oXml == NIL )
			MsgStop("Falha ao gerar Objeto XML : "+cError+" / "+cWarning)
			Return aDados
		Endif
	EndIf

	aCampos := {"NUMEROOS",;					//[1]
	"AGENTE",;						//[2]
	"CLIENTE",;						//[3]
	"LOJA",;						//[4]
	"DATA",;						//[5]
	"HORA",;						//[6]
	"ACOMPANHANTE",;				//[7]
	"PATRIMONIO",;					//[8]
	"MOEDA_RETIRADO",;				//[9]
	"CEDULA_RETIRADO",;				//[10]
	"QUANTIDADE R0,05",;			//[11]
	"QUANTIDADE R0,10",;			//[12]
	"QUANTIDADE R0,25",;			//[13]
	"QUANTIDADE R0,50",;			//[14]
	"QUANTIDADE R1,00",;			//[15]
	If(Upper(AllTrim(GetEnvServer())) == "JVVXC9_TESTE","BANANINHA","NUMERO"),;						//[16] bananinha  O FILHO DA PUTA DO XAXIM MUDOU DE NOVO ESTAVA COMO NUMERO
	"MOEDA_COLOCADO",;				//[17]	// GLENVIEW ?? - GLENVIEW_-_LACRE_COLOCADO
	If("CEDULA_-_LACRE_COLOCADO" $ UPPER(cResult),"CEDULA_-_LACRE_COLOCADO","CEDULA_COLOCADO"),;//If(Upper(AllTrim(GetEnvServer())) == "JVVXC9_TESTE","CEDULA_-_LACRE_COLOCADO","CEDULA_COLOCADO"),;				//[18]CEDULA_COLOCADO
	"NUMERO_DE_SERIE_DO_POS",;		//[19]
	"TOTAL CASH (R$)",;				//[20]
	"TOTAL VENDAS QTD",;			//[21]
	"CONTADOR 01",;					//[22]
	"CONTADOR 02",;					//[23]
	"CONTADOR 03",;					//[24]
	"CONTADOR 04",;					//[25]
	"CONTADOR 05",;					//[26]
	"PARCIAL",;						//[27]
	"NUMERO_TESTES",;				//[28]
	"P1",;							//[29]
	"P2",;							//[30]
	"P3",;							//[31]
	"P4",;							//[32]
	"P5",;							//[33]
	"P6",;							//[34]
	"P7",;							//[35]
	"P8",;							//[36]
	"P9",;							//[37]
	"P10",;							//[38]
	"P11",;							//[39]
	"P12",;							//[40]
	"LACRES",;						//[41] radio form
	"MOEDEIRO_COM_TROCO",;			//[42] radio form
	"LOG",;							//[43] radio form
	"LACRE_-_RETIRADO_MOEDEIRO",;	//[44] lacre retirado moedeiro
	"GLENVIEW_-_LACRE_COLOCADO",;	//[45] lacre colocado moedeiro
	"ENVIAR_COPIA_POR_E-MAIL",;		//[46] enviar email ao cliente
	"P13",;							//[29]
	"P14",;							//[30]
	"P15",;							//[31]
	"P16",;							//[32]
	"P17",;							//[33]
	"P18",;							//[34]
	"P19",;							//[35]
	"P20",;							//[36]
	"P21",;							//[37]
	"P22",;							//[38]
	"P23",;							//[39]
	"P24",;							//[40]
	"P25"						}

	If oXml <> Nil
		dData := CtoD( SubStr( oXml:_FormAnswers:_FormAnswer:_STATUSDATAHORA:TEXT,1,10 ) )
		cHora := SubStr( oXml:_FormAnswers:_FormAnswer:_STATUSDATAHORA:TEXT,12 )

		cCodCli := oXml:_FormAnswers:_FormAnswer:_EXTERNALCLIENTEID:TEXT
		cCodCli := SubStr(cCodCli,1,Len(cCodCli)-4)
		cCodCli := StrZero( Val(cCodCli), TamSx3("A1_COD")[1],0 )

		cLjCli := oXml:_FormAnswers:_FormAnswer:_EXTERNALCLIENTEID:TEXT
		cLjCli := SubStr(cLjCli, Len(cLjCli)-3, Len(cLjCli) )

		// Quebra as respostas no array aResp
		aResp	:= oXml:_FormAnswers:_FormAnswer:_ItemAnswers:_ItemAnswer

		AADD( aDados, { "NUMEROOS"	, oXml:_FormAnswers:_FormAnswer:_NUMEROOS:TEXT } )					// Numero da OS
		AADD( aDados, { "AGENTE"	, AllTrim(oXml:_FormAnswers:_FormAnswer:_AGENTECODIGO:TEXT ) } )	// Codigo do agente
		AADD( aDados, { "CLIENTE"	, cCodCli } )														// cliente
		AADD( aDados, { "LOJA"		, cLjCli } )														// loja
		AADD( aDados, { "DATA"		, dData } )															// data
		AADD( aDados, { "HORA"		, cHora } )															// hora

		For nI := 7 To Len(aCampos)
			nPos := U_WSKPF013(aResp,aCampos[nI])
			If nPos == 0
				AADD( aDados, { aCampos[nI], If(cItemP==-1,"",cItemP) } )
				Loop
			EndIf

			// Ajuste para corrigir o patrimonio enviado com caracteres incorretos
			If aCampos[nI] == 'PATRIMONIO'
				For nJ := 1 To Len(aResp[nPos]:_ANSWER:TEXT)
					If !IsDigit( SubStr(aResp[nPos]:_ANSWER:TEXT,nJ,1) )
						cMsgErro += " Patrimonio informado com caracteres invalidos. "
						aDados := {}
						Return aDAdos
					EndIf
				Next nJ
			EndIf

			// campos de selecao
			If aCampos[nI] $ "LACRES|MOEDEIRO_COM_TROCO|LOG|ENVIAR_COPIA_POR_E-MAIL"
				If aCampos[nI] == "ENVIAR_COPIA_POR_E-MAIL"
					If XmlChildEx( aResp[nPos]:_Answer, "_SELECTEDALTERNATIVE" ) <> NIL
						AADD( aDados, { aCampos[nI], aResp[nPos]:_Answer:_SelectedAlternative:TEXT } )
					EndIf
				Else
					AADD( aDados, { aCampos[nI], aResp[nPos]:_Answer:_SelectedAlternative:TEXT } )
				EndIf
			Else
				// Campos Texto
				If aCampos[nI] $ "ACOMPANHANTE|PATRIMONIO|MOEDA_RETIRADO|CEDULA_RETIRADO|MOEDA_COLOCADO|CEDULA_-_LACRE_COLOCADO|BANANINHA|CONTADOR 01|CONTADOR 02|CONTADOR 03|CONTADOR 04|CONTADOR 05|NUMERO_DE_SERIE_DO_POS|LACRE_-_RETIRADO_MOEDEIRO|LACRE_-_COLOCADO_MOEDEIRO|TOTAL CASH (R$)|NUMERO|CEDULA_COLOCADO"
					// POS - Retirar os pontos
					If aCampos[nI] $ "NUMERO_DE_SERIE_DO_POS"
						AADD( aDados, { aCampos[nI], StrTran(aResp[nPos]:_ANSWER:TEXT,".","") } )
						// Total cash - Retirar pontos e converter para numerico
					ElseIf aCampos[nI] == "TOTAL CASH (R$)"
						xVal := StrTran(aResp[nPos]:_ANSWER:TEXT,".","")
						xVal := Val(xVal)
						AADD( aDados, { aCampos[nI], xVal } )
						// campos texto
					Else
						AADD( aDados, { aCampos[nI], aResp[nPos]:_ANSWER:TEXT } )
					EndIf
					// Campos numericos
				Else
					If nPos > 0
						If aCampos[nI] == "QUANTIDADE R0,05"

							AADD( aDados, { aCampos[nI], Val( aResp[nPos]:_ANSWER:TEXT ) } )
							nValor += Round( Val( aResp[nPos]:_ANSWER:TEXT ) * 0.05, 2 )

						ElseIf aCampos[nI] == "QUANTIDADE R0,10"

							AADD( aDados, { aCampos[nI], Val( aResp[nPos]:_ANSWER:TEXT ) } )
							nValor += Round( Val( aResp[nPos]:_ANSWER:TEXT ) * 0.10, 2 )

						ElseIf aCampos[nI] == "QUANTIDADE R0,25"

							AADD( aDados, { aCampos[nI], Val( aResp[nPos]:_ANSWER:TEXT ) } )
							nValor += Round( Val( aResp[nPos]:_ANSWER:TEXT ) * 0.25, 2 )

						ElseIf aCampos[nI] == "QUANTIDADE R0,50"

							AADD( aDados, { aCampos[nI], Val( aResp[nPos]:_ANSWER:TEXT ) } )
							nValor += Round( Val( aResp[nPos]:_ANSWER:TEXT ) * 0.50, 2 )

						ElseIf aCampos[nI] == "QUANTIDADE R1,00"

							AADD( aDados, { aCampos[nI], Val( aResp[nPos]:_ANSWER:TEXT ) } )
							nValor += Round( Val( aResp[nPos]:_ANSWER:TEXT ) * 1, 2 )

						Else
							AADD(aDados, { aCampos[nI],Val( aResp[nPos]:_ANSWER:TEXT ) } )
						EndIf
					EndIf
				EndIf
			EndIf
		Next nI
		AADD( aDados, { "TROCO_MOEDA", nValor } )
	EndIf

Return aDados

/*


?
Programa  WSKPF013  Autor  Alexandre Venancio   Data   19/11/13   
?
Desc.     Busca nas respostas do xml a posicao do campo informado     
          no parametro.                                               
?
Uso        Integracao Keeple                                          
?


*/

User Function WSKPF013(aItens,cCampo)

	Local nPos := 0
	Local nI := 0
	Local aAux	:=	{}
	Local nPos2 := 0
	Local cBotP := ''
	Local cBarra:= ''

	cItemp := -1

	//Preenchendo a quantidade de botoes P que tem na maquina
	cBarra := ""

	If !cCampo $ cBotP
		For nI := 1 To Len(aItens)
			If UPPER( AllTrim(aItens[nI]:_ITEM:TEXT) ) == UPPER(cCampo)
				nPos := nI
				lEntrou := .T.
				Exit
			EndIf
		Next nI
	Else
		For nI := 1 To Len(aItens)
			If UPPER( AllTrim(aItens[nI]:_ITEM:TEXT) ) == 'ITENS'
				nPos := nI
				Exit
			EndIf
		Next nI
		if nPos > 0
			If XmlChildEx(aItens[nPos]:_Answer,"_ITEMANSWER") != NIL .OR. TYPE("aItens[nPos]:_Answer:_ItemAnswer") != "U" //.OR. VALTYPE(aItens[nPos]:_Answer:_ItemAnswer) == "A"
				aAux := aItens[nPos]:_Answer:_ItemAnswer
				If Valtype(aAux) == "O"
					If aAux:_ITEMID:TEXT == cCampo
						cItemP := val(aAux:_VALUEID:TEXT)
						lEntrou := .T.
					Else
						lEntrou := .F.
					EndIf
					nPos := 0
				Else
					For nX := 1 to len(aAux)
						If Alltrim(aAux[nX]:_Itemid:text) == cCampo
							cItemP := val(aAux[nX]:_value:text)
							nPos := 0
							lEntrou := .T.
							exit
						EndIf
					Next nX
				EndIf
			Else
				nPos := 0
				lEntrou := .F.
			EndIf
		else
			lEntrou := .F.
		EndIf
	EndIf

Return nPos

/*


?
Programa  WSKPF014  Autor  Alexandre Venancio   Data   26/12/13   
?
Desc.     Obtem o formulario de respostas do Abastecimento.           
                                                                      
?
Uso        Integracao Keeple                                          
?


*/
User Function WSKPF014(cResult,aAnswers,cMsgErro,lCorrec)

	Local cError := ""
	Local cWarning := ""
	Local oXml
	Local cNo
	Local aRet := {}
	Local nI,nJ,nK,nL,nM,nN,nX,nY
	Local aRet := {}
	Local nPMola := 2
	Local nPSaldo := 3
	Local nPAbast := 4
	Local nPRetir := 5
	Local nPDscAv := 6
	Local aItensXML := {}
	Local aItens := {}
	Local aCont := {}
	Local aLeitura := {}
	Local lBebida	:=	.F.

	Default cResult := ""
	Default lCorrec := .F.

	If Empty(cResult)
		ConOut("# WSKPF014 - PARAMETRO cResult invalido  #")
		Return aRet
	EndIf

	oXml := XmlParser( cResult, "", @cError, @cWarning )
	If oXml == Nil
		MsgStop("Falha ao gerar Objeto XML : "+cError+" / "+cWarning)
		ConOut("# WSKPF014 -> FALHA AO GERAR O OBJETO XML : "+cError+" / "+cWarning +" #")
		cMsgErro += "# WSKPF014 -> FALHA AO GERAR O OBJETO XML : "+cError+" / "+cWarning +" #"

		Return aRet
	EndIf

	BEGIN SEQUENCE
		If XmlChildEx( oXml, "_FORMANSWERS" ) <> NIL
			If XmlChildEx( oXml:_FORMANSWERS, "_FORMANSWER" ) <> NIL
				If XmlChildEx( oXml:_FORMANSWERS:_FORMANSWER, "_NUMEROOS" ) <> NIL
					AADD( aRet, { "NUMEROOS", oXml:_FORMANSWERS:_FORMANSWER:_NUMEROOS:TEXT  } )
				EndIf
				If XmlChildEx( oXml:_FORMANSWERS:_FORMANSWER, "_STATUSDATAHORA" ) <> NIL
					AADD( aRet, { "DATA", CTOD(SubStr(oXml:_FORMANSWERS:_FORMANSWER:_STATUSDATAHORA:TEXT,1,10) ) } )
					AADD( aRet, { "HORA", SubStr( oXml:_FORMANSWERS:_FORMANSWER:_STATUSDATAHORA:TEXT,12 ) } )
				EndIf
				If XmlChildEx( oXml:_FORMANSWERS:_FORMANSWER, "_ITEMANSWERS" ) <> NIL
					oNod3 := oXml:_FORMANSWERS:_FORMANSWER:_ITEMANSWERS
					cNo4 := "oXml:_FORMANSWERS:_FORMANSWER:_ITEMANSWERS"
					For nL := 1 To XmlChildCount(oNod3)
						oNod4 := XmlGetchild( Eval( &( "{||"+cNo4+"}" ) ) , nL )
						If ValType(oNod4) == "A"
							For nM := 1 To Len(oNod4)
								If UPPER(oNod4[nM]:_Item:TEXT) == "ABASTECIMENTO"	// itens do abastecimento
									If XmlChildEx(oNod4[nM]:_ANSWER,"_ITEMANSWER") <> NIL
										aItensXML := oNod4[nM]:_ANSWER:_ITEMANSWER
										aItens := {}
										// PRODUTO - POSICAO MOLA - SALDO - ABASTECIDO - RETIRADO - DESCARTE/AVARIA
										For nX := 1 To Len(aItensXML)
											If ASCAN(ARET,{|X| X[1] == 'PATRIMONIO'}) > 0
												If POSICIONE("SB1",1,XFILIAL("SB1")+POSICIONE("SN1",2,XFILIAL("SN1")+ARET[ASCAN(ARET,{|X| X[1] == 'PATRIMONIO'}),02],"N1_PRODUTO"),"B1_XFAMILI") $ "144/153"
													lBebida := .T.
												EndIf
											EndIf
											If !lBebida
												If aItensXML[nX]:_VALUEID:TEXT == "1"
													AADD( aItens, { AllTrim(aItensXML[nX]:_ITEMID:TEXT) , AllTrim(aItensXML[nX]:_VALUE:TEXT), {0,.T.}, {0,.T. }, {0,.T.}, {0,.T.} } )
												EndIF
											Else
												If aScan( aItens, { |x| AllTrim(x[1]) == AllTrim(aItensXML[nX]:_ItemID:TEXT) }  ) == 0
													AADD( aItens, { AllTrim(aItensXML[nX]:_ItemID:TEXT) ,"", {0,.T.}, {0,.T. }, {0,.T.}, {0,.T.} } )
												EndIf
											EndIf

										Next nX
										For nX := 1 To Len(aItens)
											For nY := 1 To Len(aItensXmL)
												If AllTrim( aItensXML[nY]:_ItemID:TEXT ) == aItens[nX][1]
													If AllTrim( aItensXML[nY]:_ValueID:TEXT ) == "1"	// posicao mola
														If lBebida
															aItens[nX][nPMola] := AllTrim( aItensXML[nY]:_Value:TEXT )
														EndIf
													ElseIf AllTrim( aItensXML[nY]:_ValueID:TEXT ) == "2"	// saldo
														aItens[nX][nPSaldo][1] := Val( aItensXML[nY]:_Value:TEXT )
													ElseIf AllTrim( aItensXML[nY]:_ValueID:TEXT ) == "3"	// abastecido
														aItens[nX][nPAbast][1] := Val( aItensXML[nY]:_Value:TEXT )
													ElseIf AllTrim( aItensXML[nY]:_ValueID:TEXT ) == "4"	// retirado
														aItens[nX][nPRetir][1] := Val( aItensXML[nY]:_Value:TEXT )
													ElseIf AllTrim( aItensXML[nY]:_ValueID:TEXT ) == "5"	// descarte/avaria
														aItens[nX][nPDscAv][1] := Val( aItensXML[nY]:_Value:TEXT )
													EndIf
												EndIf
											Next nY
										Next nX
									EndIf
								ElseIf UPPER(oNod4[nM]:_Item:TEXT) == "CONTADORES"	// itens da leitura
									/*
									If ValType(oNod4[nM]:_ANSWER:_ITEMANSWER) = "O"
									XmlNode2Arr(oNod4[nM]:_ANSWER:_ITEMANSWER, "_ITEMANSWER")
									EndIf
									aCont := oNod4[nM]:_ANSWER:_ITEMANSWER
									*/
									If ValType(oNod4[nM]:_ANSWER:_ITEMQUANTITYANSWER) == "O"
										XmlNode2Arr(oNod4[nM]:_ANSWER,"_ITEMQUANTITYANSWER")
									EndIf

									aCont := oNod4[nM]:_ANSWER:_ITEMQUANTITYANSWER

									aLeitura := {}

									For nX := 1 To Len(aCont)
										AADD( aLeitura, { "P"+cvaltochar(aCont[nX]:_ITEMID:TEXT), aCont[nX]:_QTD:TEXT  } )
									Next nX
								ElseIf UPPER(oNod4[nM]:_Item:TEXT)  $ "TOTAL_DE_SELECOES/TOTAL_DE_CASH" .And. !lCorrec
									AADD( aRet, { UPPER(oNod4[nM]:_ITEM:TEXT), oNod4[nM]:_ANSWER:_ITEMQUANTITYANSWER:_QTD:TEXT } )
								Else	// outros campos
									AADD( aRet, { UPPER(oNod4[nM]:_ITEM:TEXT), oNod4[nM]:_ANSWER:TEXT  } )
								EndIf
							Next nM
						EndIf
					Next nL
				EndIf
			EndIf
		EndIf
		If Len(aItens) > 0
			AADD( aRet, { "ABASTECIMENTO", aItens  } )
		EndIf
		If Len(aLeitura) > 0
			AADD( aRet, { "LEITURA", aLeitura  } )
		EndIf
		RECOVER
		Conout("## WSKPF014 - OS " +NumAtend +" -> ERRO NO PROCESSAMENTO DO XML ##")
		cMsgErro += "ERRO - VERIFICAR A ESTRUTURA DO XML"
	END SEQUENCE

Return aRet

/*


?
Programa  WSKPF015  Autor  Alexandre Venancio   Data   26/12/13   
?
Desc.     Obtem o formulario de respostas da solicitacao de OS.       
                                                                      
?
Uso        Integracao Keeple                                          
?


*/

User Function WSKPF015(cResult,aAnswers,cMsgErro)

	Local oXML			:= NIL
	Local cError		:= ""
	Local cWarning		:= ""
	Local aDados		:= {}
	Local cNumChapa		:= ""
	Local cFormulario	:= ""
	Local nAgenteOS		:= 0
	Local nI			:= 0
	Local nTpServ		:= 0
	Local cQuery		:= ""
	Local cNumNf		:= ""
	Local cSerie		:= ""
	Local cRota			:= ""
	Local cCodCli		:= ""
	Local cLjCli		:= ""
	Local nRecSN1		:= 0

	Default cResult	:= ""
	Default aAnswers := {}

	// Verifica parametros
	If Empty(cResult) .And. Len(aAnswers) == 0
		//MsgAlert("O parmetro Resultado no foi informado!","WSKPF005")
		Return
	EndIf

	//Gera o Objeto XML
	If !Empty(cResult)
		oXml := XmlParser( cResult, "_", @cError, @cWarning )
		If (oXml == NIL )
			MsgStop("Falha ao gerar Objeto XML : "+cError+" / "+cWarning)
		Endif
	EndIf

	If oXML <> Nil
		If ValType(oXml:_FormAnswers:_FormAnswer) == "O"
			// Formulario
			If XmlChildEx( oXml:_FormAnswers:_FormAnswer:_ITEMANSWERS, "_SELECTEDALTERNATIVE" ) <> NIL
				cFormulario := FWNoAccent (AllTrim( oXml:_FormAnswers:_FormAnswer:_ITEMANSWERS:_SelectedAlternative:TEXT) )
			Else
				cMsgErro += " Campo nao encontrado no formulario de respostas: _SELECTEDALTERNATIVE"
				aDados := {}
				Return aDados
			EndIf

			// Agente
			nAgenteOS := AllTrim(oXML:_FormAnswers:_FormAnswer:_AGENTECODIGO:TEXT)

			// Quebra as respostas no array aResp
			aResp	:= oXml:_FormAnswers:_FormAnswer:_ItemAnswers

			nPos := U_WSKPF013(aResp,"NR_PATRIMONIO")
			If nPos == 0
				//ERRO CAMPO NAO ENCONTRADO NO XML!
				cMsgErro += " Campo nao encontrado no formulario de respostas: NR_PATRIMONIO"
				aDados := {}
				Return aDAdos
			EndIf

			// Patrimonio
			cNumChapa := aResp[nPos]:_ANSWER:TEXT
			If Empty(cNumChapa)
				cMsgErro += " Patrimonio nao informado. "
				aDados := {}
				Return aDAdos
			EndIf

			nPos := U_WSKPF013(aResp,"TIPO_SOLICITACAO")
			If nPos == 0
				//ERRO CAMPO NAO ENCONTRADO NO XML!
				cMsgErro += " Campo nao encontrado no formulario de respostas: TIPO_SOLICITACAO"
				aDados := {}
				Return aDAdos
			EndIf

			aItensXML := aResp[nPos]:_Answer //:_ItemQuantityAnswer

			If "OCULTA" $ UPPER(cFormulario)
				nTpServ := 1
			ElseIf "LEITURA" $ UPPER(cFormulario)
				nTpServ := 2
			ElseIf "SANGRIA" $ UPPER(cFormulario)
				nTpServ := 3
			ElseIf "ABASTECIMENTO" $ UPPER(cFormulario)
				nTpServ := 4
			EndIf

			AADD( aDados, nTpServ )
			AADD( aDados, nAgenteOS )
			AADD( aDados, cNumChapa )
		EndIf
	EndIf

	If Len(aDados) > 0
		nRecSN1 := U_TTTMKA19(cNumChapa)
		If nRecSN1 > 0
			dbSelectArea("SN1")
			dbGoto(nRecSN1)
			cCodCli := SN1->N1_XCLIENT
			cLjCli := SN1->N1_XLOJA
		Else
			cMsgErro += "O patrimonio "+cNumChapa +" nao encontrado na base de dados." +CRLF
			aDados := {}
			Return aDAdos
		EndIf

		If Empty(cCodCli) .Or. Empty(cLjCli)
			cMsgErro += "Patrimonio sem cliente/loja."
			aDados := {}
			Return aDAdos
		EndIf

		AADD( aDados, cCodCli )
		AADD( aDados, cLjCli )

		// No abastecimento busca a nota, serie e rota
		If nTpServ == 4
			// monta query de consulta na SZG
			cQuery := "SELECT TOP 1 * FROM " +RetSqlName("SZG")
			cQuery += " WHERE ZG_AGENTE = '"+nAgenteOS+"' "
			cQuery += " AND ZG_CLIFOR = '"+cCodCli+"' AND ZG_LOJA = '"+cLjCli+"' "
			cQuery += " AND ZG_TPFORM = '4' "
			cQuery += " ORDER BY ZG_DATAINI DESC "

			If Select("TRBSZG") > 0
				TRBSZG->( dbCloseArea() )
			EndIf

			TcQuery cQuery New Alias "TRBSZG"

			dbSelectArea("TRBSZG")
			If !EOF()
				cNumNf := TRBSZG->ZG_DOC
				cSerie := TRBSZG->ZG_SERIE
				cRota := TRBSZG->ZG_ROTA
			EndIf

			If Empty(cNumNF) .Or. Empty(cSerie) .Or. Empty(cRota)
				cMsgErro += "No foi encontrada a OS anterior de abastecimento."
			Else
				AADD( aDados, cNumNF )
				AADD( aDados, cSerie )
				AADD( aDados, cRota )
			EndIf
		EndIf
	EndIf

Return aDados

/*


?
Programa  WSKPF016  Autor  Alexandre Venancio   Data   10/03/14   
?
Desc.     Reprocessa as Ordens de servico cujas respostas ainda       
          nao foram gravadas na tabela de contadores                  
?
Uso        Integracao Keeple                                          
?


*/

User Function WSKPF016()

	Local cQuery := ""
	Local cResult := ""
	Local cREsposta := ""
	Local aDados := {}
	Local aDadosWS := {}
	Local aDoc := {}
	Local aREsp := {}
	Local nHdl
	Local cMsgErro := ""

	cQuery := "SELECT ZG_NUMOS, ZG_DATAINI, ZG_DESCFRM, ZN_NUMOS, ZG_RESPOST FROM "  +RetSqlName("SZG") +" SZG "

	cQuery += " LEFT JOIN " +RetSqlName("SZN") +" SZN ON "
	cQuery += "SZN.ZN_NUMOS = SZG.ZG_NUMOS "
	cQuery += "AND SZN.D_E_L_E_T_ = SZG.D_E_L_E_T_ "

	cQuery += "WHERE ZG_STATUS = 'FIOK' AND ZG_TPFORM = '2' AND ZG_DATAFIM = '20140905' "
	cQuery += "AND SZG.D_E_L_E_T_ = '' "

	cQuery += "ORDER BY ZN_NUMOS "

	If Select("TRB") > 0
		TRB->( dbCloseArea() )
	EndIf

	TcQuery cQuery New Alias "TRB"

	dbSelectArea("TRB")
	While !EOF()
		If !Empty(TRB->ZN_NUMOS)
			dbSkip()
			Loop
		EndIf

		// soh pegar status inconsistente
		//If TRB->ZG_STATUS <> "INCO"
		//	dbSkip()
		//	Loop
		//	EndIf

		aDados := {}
		cResult := ""
		cResposta := TRB->ZG_RESPOST
		cMsgErro := ""

		AADD(aDados, "6241D1E1C9517582E2CBFE491E908A10C7C3DFCE")
		AADD(aDados, "42CB7AEE2B2FFA173B53")

		adoc := { Val(TRB->ZG_NUMOS) }

		AADD( aDados, ADOC )

		If Empty(cResult)
			// Obtem as respostas e trata o retorno
			cResult := U_WSKPC006(aDados)
			cResult := U_WSKPF001(cResult)
		EndIf

		If Empty(cResult)
			dbSkip()
			Loop
		EndIf

		oWS := WSTTWS():New()
		If oWS:SETACOMPANHAMENTOORDEMSERVICO("6241D1E1C9517582E2CBFE491E908A10C7C3DFCE","42CB7AEE2B2FFA173B53",cResult)
			cResposta := oWs:cSETACOMPANHAMENTOORDEMSERVICORESULT
		Else
			cREsposta := GetWSCError()
		EndIf

		AADD(aResp, {TRB->ZG_NUMOS, cResposta} )

		dbSelectArea("SZG")
		dbSetOrder(1)
		dbSeek( xFilial("SZG") +TRB->ZG_NUMOS )
		If Empty(SZG->ZG_RESPOST)
			RecLock("SZG",.F.)
			SZG->ZG_RESPOST := cResult
			MsUnLock()
		EndIf

		dbSelectArea("TRB")
		dbSkip()
	End

	nHdl := FCreate("c:\temp\reprocessamento_os.txt")
	If nHdl == -1
		MsgInfo("Erro de criacao do arquivo de log:" +Str(Ferror()))
		For nI := 1 To Len(aResp)
			cTxtLog +=  "OS: " +aResp[nI][1] + " - " +aResp[nI][2] +CRLF
		Next nI
		fClose(nHdl)
		Aviso("",cTxtLog,{"Ok"})
		Return
	Else
		For nI := 1 To Len(aResp)
			FWrite(nHdl, "OS: " +aResp[nI][1] + " - " +aResp[nI][2] +CRLF)
		Next nI
		fClose(nHdl)
		Aviso("","Log gravado.",{"Ok"})
	EndIf

Return

/*


?
Programa  WSKPF017  Autor  Alexandre Venancio   Data   07/04/14   
?
Desc.     Monta o xml para abertura da OS de Abastecimento/Correcao   
          Parametro 24 do metodo OpenOrdemServico                     
?
Uso        Integracao Keeple                                          
?


*/

User Function WSKPF017(nTpServ,cNumNF,cSerie,cForCli,cCodLj,cNumChapa,cArmazem,aItens,nTotSel,nTotCash,cDadosCnt,aLeitura)

	Local cXML			:= ""
	Local nI			:= 0
	Local cDesc			:= ""
	Local cQuery		:= ""
	Local cCliente		:= ""
	Local cPosicao		:= ""
	Local cCodigo		:= ""
	Local nPos			:= 0
	Local nVID			:= 0
	Local nPProduto		:= 1	// posicao do produto no array
	Local nPMola		:= 2	// posicao da mola no array
	Local nPSaldo		:= 3	// posicao do saldo no array
	Local nPAbast		:= 4	// posicao da qtd abastecida no array
	Local nPRetir		:= 5	// posicao da qtd retirada no array
	Local lSemMapa		:= .F.
	Local cProdMaq		:= POSICIONE("SB1",1,xFilial("SB1")+POSICIONE("SN1",2,XFILIAL("SN1")+AVKEY(CNUMCHAPA,"N1_CHAPA"),"N1_PRODUTO"),"B1_XFAMILI")
	Local cMailCli		:= ""
	Local cMail1		:= ""
	Local cMail2		:= ""
	Local cTabPat		:= Posicione("SN1",2,xFilial("SN1")+cNumChapa,"N1_XTABELA")
	Local aContAnt		:= {}
	Local aEsqMola		:= {{'A',1,10},{'B',11,20},{'C',21,30},{'D',31,40},{'E',41,50},{'F',51,60}}
	Local cMp			:= ""
	Default nTpServ		:= 0
	Default cNumNF		:= ""
	Default cSerie		:= ""
	Default cForCli		:= ""
	Default cNumChapa	:= ""
	Default cArmazem	:= ""
	Default cCodLj		:= ""
	Default aItens 		:= {}
	Default nTotSel		:= 0
	Default nTotCash	:= 0

	If nTpServ == 0
		MsgAlert("O parmetro Tipo do Servico nao foi informado!","WSKPF017")
		Return
	EndIf

	If Empty(cForCli)
		MsgAlert("O parmetro Cdigo do fornecedor no foi informado!","WSKPF017")
		Return
	EndIf

	If Empty(cCodLj)
		MsgAlert("O parmetro Loja do fornecedor no foi informado!","WSKPF017")
		Return
	EndIf

	If Empty(cNumChapa)
		MsgAlert("O parmetro cdigo do patrimnio no foi informado!","WSKPF017")
		Return
	EndIf

	If nTpServ == 4
		If Empty(cArmazem)
			MsgAlert("O parmetro cdigo do armazem no foi informado!","WSKPF017")
			Return
		EndIf
	ElseIf nTpServ == 6 .or. nTpServ == 18 .or. nTpServ == 19
		If Len(aItens) == 0
			MsgAlert("O parmetro Respostas do Abastecimento no foi informado!","WSKPF017")
			Return
		EndIf
	EndIf

	// email do cliente
	dbSelectArea("SA1")
	dbSetOrder(1)
	If dbSeek( xFilial("SA1") +AvKey(cForCli,"A1_COD") +AvKey(cCodLj,"A1_LOJA") )
		// email 1
		If !Empty(SA1->A1_EMAIL)
			cMail1 := AllTrim(lower(SA1->A1_EMAIL))
		EndIf
		// email 2
		If !Empty(SA1->A1_XEMAIL)
			cMail2 := AllTrim(lower(SA1->A1_XEMAIL))
		EndIf

		If !Empty(cMail1)
			cMailCli += cMail1
			If !Empty(cMail2)
				cMailCli += ";" +cMail2
			EndIf
		Else
			If !Empty(cMail2)
				cMailCli := cMail2
			EndIf
		EndIf
	EndIf

	// Busca produtos no formulario de abastecimento
	//ABASTECIMENTO DE MAQUINAS DE BEBIDAS = 8
	If nTpServ == 4 .OR. nTpServ == 8
		//ALTERAR AQUI, AGORA VEM DO PATRIMONIO
		If SubStr(cArmazem,1,2) <> "R0"
			dbSelectArea("ZZ1")
			dbSetOrder(3)
			If dbSeek( xFilial("ZZ1") +cForCli +cCodLj )
				cArmazem := SubStr(ZZ1->ZZ1_ITCONT,15)
			EndIf
		EndIf
		//Busca contadores da ultima leitura deste patrimonio
		cQuery := "SELECT TOP 1 ZN_DATA,ZN_COTCASH,ZN_NUMATU,"
		cVirgula := ""

		For nXtt := 1 to 60
			cQuery += cVirgula +"ZN_BOTAO"+strzero(nXtt,2)
			cVirgula := ","
		Next nXtt

		cQuery += " FROM "+RetSQLName("SZN")
		cQuery += " WHERE ZN_PATRIMO='"+cNumChapa+"' AND ZN_COTCASH<>'' AND D_E_L_E_T_='' ORDER BY ZN_DATA DESC"

		If Select("TRB") >0
			TRB->( dbCloseArea() )
		EndIf

		TcQuery cQuery New Alias "TRB"

		dbSelectArea("TRB")

		If !Empty(TRB->ZN_COTCASH) .OR. !Empty(TRB->ZN_NUMATU)
			Aadd(aContAnt,{"ZN_COTCASH",TRB->ZN_COTCASH})
			Aadd(aContAnt,{"ZN_NUMATU",TRB->ZN_NUMATU})

			For nXtt := 1 to 60
				Aadd(aContAnt,{"ZN_BOTAO"+strzero(nXtt,2),&("ZN_BOTAO"+strzero(nXtt,2))})
			Next nXtt
		Else
			Aadd(aContAnt,{"ZN_COTCASH",0})
			Aadd(aContAnt,{"ZN_NUMATU",0})

			For nXtt := 1 to 60
				Aadd(aContAnt,{"ZN_BOTAO"+strzero(nXtt,2),0})
			Next nXtt
		EndIf

		// Verifica Mapa de produtos - ordenar pelas posicoes - A1 - z9
		//If nTpServ != 8  //ChkFile("SZH",.T.) .And.
		If cProdMaq != "153"
			cQuery := "SELECT DISTINCT ZH_MOLA,ZH_CODPROD,ZH_TIPOMOL, B1_DESC, B1_GRUPO,DA1_XPRCPP"
			cQuery += " FROM " +RetSqlName("SZH") +" SZH "
			cQuery += " INNER JOIN " +RetSqlName("SB1") + " SB1 ON SB1.B1_COD = SZH.ZH_CODPROD AND SB1.D_E_L_E_T_ = '' "
			cQuery += " LEFT JOIN "+RetSQLName("DA1")+" DA1 ON DA1_CODPRO=ZH_CODPROD AND DA1_CODTAB='"+cTabPat+"' AND DA1.D_E_L_E_T_=''
			cQuery += " WHERE ZH_CHAPA = '"+cNumChapa+"' "
			cQuery += " AND ZH_CLIENTE = '"+cForCli+"' AND ZH_LOJA = '"+cCodLj+"' "
			cQuery += " AND SZH.D_E_L_E_T_ = '' AND ZH_MSBLQL<>'1' "
			cQuery += " ORDER BY ZH_MOLA "

			If Select("TRB") >0
				TRB->( dbCloseArea() )
			EndIf

			TcQuery cQuery New Alias "TRB"
			//aEsqMola		:= {{'A',1,10},{'B',11,20}{'C',21,30}{'D',31,40}{'E',41,50},{'F',51,60}}
			dbSelectArea("TRB")
			While !EOF()
				cMolax := ''

				If substr(Alltrim(TRB->ZH_MOLA),2,1) == "0" .And. TRB->ZH_TIPOMOL == "1"
					cMP := '10' //substr(Alltrim(TRB->ZH_MOLA),1,2)
				Else
					cMp	:= substr(Alltrim(TRB->ZH_MOLA),2,1)
				EndIf
				Do Case
					Case VAL(TRB->ZH_MOLA) >= aEsqMola[1,2] .AND. VAL(TRB->ZH_MOLA) <= aEsqMola[1,3]
					cMolax := aEsqMola[1,1]+Alltrim(TRB->ZH_MOLA)
					Case VAL(TRB->ZH_MOLA) >= aEsqMola[2,2] .AND. VAL(TRB->ZH_MOLA) <= aEsqMola[2,3]
					cMolax := aEsqMola[2,1]+cMp //substr(Alltrim(TRB->ZH_MOLA),2,1)
					Case VAL(TRB->ZH_MOLA) >= aEsqMola[3,2] .AND. VAL(TRB->ZH_MOLA) <= aEsqMola[3,3]
					cMolax := aEsqMola[3,1]+cMp //substr(Alltrim(TRB->ZH_MOLA),2,1)
					Case VAL(TRB->ZH_MOLA) >= aEsqMola[4,2] .AND. VAL(TRB->ZH_MOLA) <= aEsqMola[4,3]
					cMolax := aEsqMola[4,1]+cMp //substr(Alltrim(TRB->ZH_MOLA),2,1)
					Case VAL(TRB->ZH_MOLA) >= aEsqMola[5,2] .AND. VAL(TRB->ZH_MOLA) <= aEsqMola[5,3]
					cMolax := aEsqMola[5,1]+cMp //substr(Alltrim(TRB->ZH_MOLA),2,1)
					Case VAL(TRB->ZH_MOLA) >= aEsqMola[6,2] .AND. VAL(TRB->ZH_MOLA) <= aEsqMola[6,3]
					cMolax := aEsqMola[6,1]+cMp //substr(Alltrim(TRB->ZH_MOLA),2,1)

				EndCase

				AADD( aItens, { cMolax,;
				AllTrim(TRB->ZH_CODPROD),;
				AllTrim(TRB->B1_DESC),;
				TRB->DA1_XPRCPP ,0,0,0})
				TRB->(dbSkip())
			End
			TRB->(dbCloseArea())
		EndIf

		If Len(aItens) == 0
			lSemMapa := .T.
		Else
			Asort( aItens,,, {|x,y| x[1] < y[1]})
		EndIf

		// Busca nos Saldos - Produtos com quantidade disponivel > 0 e nao bloqueados
		cQuery := "SELECT B1_GRUPO, B2_COD, B1_DESC,  B2_QATU - ( B2_QEMP + B2_RESERVA )  FROM " +RetSqlName("SB2")  +" SB2 "

		cQuery += "	INNER JOIN " +RetSqlName("SB1") +" SB1 ON "
		cQuery += "	SB1.B1_COD = SB2.B2_COD "
		cQuery += "	AND SB1.D_E_L_E_T_ = SB2.D_E_L_E_T_ "

		cQuery += "	WHERE B2_LOCAL = '"+cArmazem+"' AND SB2.D_E_L_E_T_ = '' "
		cQuery += " AND B2_QATU - ( B2_QEMP + B2_RESERVA ) > '0'  " //AND B2_QATU > '0' "
		cQuery += " AND B1_MSBLQL <> '1' "

		//Maquinas de bebidas quentes e geladas, devem conter somente os itens a que compete seus abastecimentos.
		If nTpServ == 8
			If cProdMaq == "144"
				//BEBIDAS GELADAS - ENVIAR SOMENTE LATAS DE REFRIGERANTES
				cQuery += " AND B1_GRUPO='0120'"
			ElseIf cProdMaq == "153"
				//BEBIDAS QUENTES ENVIAR INSUMOS DE CAF E DERIVADOS.
				cQuery += " AND B1_XSECAO='007'"
			EndIf
		EndIf

		cQuery += "	GROUP BY B1_GRUPO, B2_COD, B1_DESC,  B2_QATU - ( B2_QEMP + B2_RESERVA ) "

		If Select("TRB") >0
			TRB->( dbCloseArea() )
		EndIf

		TcQuery cQuery New Alias "TRB"
		dbSelectArea("TRB")
		While !EOF()
			If Ascan( aItens, { |x| AllTrim(x[2]) == AllTrim(TRB->B2_COD) }  ) == 0
				AADD( aItens, {"",;
				AllTrim(TRB->B2_COD),;
				AllTrim(TRB->B1_DESC),;
				0} )
			EndIf
			TRB->(dbSkip())
		End
		TRB->(dbCloseArea())

		If Len(aItens) == 0
			If lSemMapa
				cMsg := "No existe mapa de produtos para o patrimnio." +CRLF
			EndIf
			Aviso("",cMsg +"No h produtos com saldo suficiente para o armazem.",{"Ok"})
			Return
		EndIf
	EndIf

	cForCli := Val(cForCli)
	cForCli := AllTrim(Str(cForCli))
	cCliente := cForCli+cCodLj

	// Monta XML
	// formulario de abastecimento
	If nTpServ == 4
		cXML := "<?xml version='1.0' encoding='utf-8'?>"
		cXML += "<DynFormAnswer>"
		cXML += 	"<ServiceOrderID>@ORDEMSERVICOID</ServiceOrderID>"

		// Cod do cliente
		cXML += 	"<ItemAnswer>"
		cXML += 		"<ItemID>34635</ItemID>"    //PROD
		cXML += 		"<TextAnswer>"+cCliente+"</TextAnswer>"
		cXML += 	"</ItemAnswer>"

		// Num Patrimonio
		cXML += 	"<ItemAnswer>"
		cXML += 		"<ItemID>34634</ItemID>"	       //
		cXML += 		"<TextAnswer>"+cNumChapa+"</TextAnswer>"
		cXML += 	"</ItemAnswer>"

		// Email do Cliente -> a1_email a1_Xemail
		cXML += 	"<ItemAnswer>"
		//If Upper(AllTrim(GetEnvServer())) == "JVVXC9_TESTE"
		//	cXML += 		"<ItemID>67785</ItemID>"	      //PROD 84796
		//Else
		cXML += 		"<ItemID>84796</ItemID>"	      //PROD
		//EndIf
		cXML += 		"<TextAnswer>"+cMailCli+"</TextAnswer>"
		cXML += 	"</ItemAnswer>"

		// OBS Administrador?
		cXML += 	"<ItemAnswer>"
		cXML += 		"<ItemID>94565</ItemID>"	       //
		cXML += 		"<TextAnswer>Sim</TextAnswer>"
		cXML += 	"</ItemAnswer>"

		// Mensagem do Administrador
		cXML += 	"<ItemAnswer>"
		cXML += 		"<ItemID>94569</ItemID>"	       //
		cXML += 		"<TextAnswer>AO TROCAR DE TABELA,  AQUI QUE O SISTEMA IR ALERTAR O ABASTECEDOR</TextAnswer>"
		cXML += 	"</ItemAnswer>"

		cXML += 	"<ItemAnswer>"
		cXML += 		"<ItemID>94396</ItemID>"
		cXML += 		"<TextAnswer>"
		cXML += 			"<maxtries>3</maxtries>"
		cXML += 			"<itemquantitycheck>"
		cXML += 				"<itemid>1</itemid>"
		cXML += 				"<itemname>Total Sale</itemname>"
		cXML += 				"<qtd>"+cvaltochar(aContAnt[2,2])+"</qtd>"
		cXML += 			"</itemquantitycheck>"
		cXML += 		"</TextAnswer>"
		cXML += 	"</ItemAnswer>"

		cXML += 	"<ItemAnswer>"
		cXML += 		"<ItemID>94397</ItemID>"
		cXML += 		"<TextAnswer>"
		cXML += 			"<maxtries>3</maxtries>"
		cXML += 			"<itemquantitycheck>"
		cXML += 				"<itemid>1</itemid>"
		cXML += 				"<itemname>Total Cash</itemname>"
		cXML += 				"<qtd>"+cvaltochar(aContAnt[1,2])+"</qtd>"
		cXML += 			"</itemquantitycheck>"
		cXML += 		"</TextAnswer>"
		cXML += 	"</ItemAnswer>"

		// Itens
		cXML += 	"<ItemAnswer>"
		cXML += 		"<ItemID>34633</ItemID>"
		cXML += 		"<TextAnswer>"
		cXML += 			"<valuesdefinitions>"
		cXML += 				"<value>"
		cXML += 					"<id>1</id>"
		cXML += 					"<title>Posio</title>"
		cXML += 					"<type>TEXT</type>"
		cXML += 				"</value>"
		cXML += 				"<value>"
		cXML += 					"<id>2</id>"
		cXML += 					"<title>Saldo</title>"
		cXML += 					"<type>NUMBER</type>"
		cXML += 				"</value>"
		cXML += 				"<value>"
		cXML += 					"<id>3</id>"
		cXML += 					"<title>Abastecido</title>"
		cXML += 					"<type>NUMBER</type>"
		cXML += 				"</value>"
		cXML += 				"<value>"
		cXML += 					"<id>4</id>"
		cXML += 					"<title>Retirado</title>"
		cXML += 					"<type>NUMBER</type>"
		cXML += 				"</value>"
		cXML += 				"<value>"
		cXML += 					"<id>5</id>"
		cXML += 					"<title>Vencido/Avaria</title>"
		cXML += 					"<type>NUMBER</type>"
		cXML += 				"</value>"

		cXML += 			"</valuesdefinitions>"

		// formulario de abastecimento - correcao
	Elseif nTpServ == 6 .or. nTpServ == 18 .or. nTpServ == 19
		cXML := "<?xml version='1.0' encoding='utf-8'?>"
		cXML += "<DynFormAnswer>"
		cXML += 	"<ServiceOrderID>@ORDEMSERVICOID</ServiceOrderID>"

		// Cod do cliente
		cXML += 	"<ItemAnswer>"
		cXML += 		"<ItemID>"+If(nTpServ==19,"94536","94518")+"</ItemID>"
		cXML += 		"<TextAnswer>"+cCliente+"</TextAnswer>"
		cXML += 	"</ItemAnswer>"

		// Num Patrimonio
		cXML += 	"<ItemAnswer>"
		cXML += 		"<ItemID>"+If(nTpServ==19,"94535","94517")+"</ItemID>"
		cXML += 		"<TextAnswer>"+AllTrim(cNumChapa)+"</TextAnswer>"
		cXML += 	"</ItemAnswer>"

		// Email do Cliente -> a1_email a1_Xemail
		cXML += 	"<ItemAnswer>"
		cXML += 		"<ItemID>"+If(nTpServ==19,"94537","94519")+"</ItemID>"
		cXML += 		"<TextAnswer>"+cMailCli+"</TextAnswer>"
		cXML += 	"</ItemAnswer>"

		// Itens
		cXML += 	"<ItemAnswer>"
		cXML += 		"<ItemID>"+If(nTpServ==19,"94534","94516")+"</ItemID>"
		cXML += 		"<TextAnswer>"
		cXML += 			"<valuesdefinitions>"
		cXML += 				"<value>"
		cXML += 					"<id>1</id>"
		cXML += 					"<title>Posio</title>"
		cXML += 					"<type>TEXT</type>"
		cXML += 				"</value>"
		cXML += 				"<value>"
		cXML += 					"<id>2</id>"
		cXML += 					"<title>Saldo</title>"
		cXML += 					"<type>NUMBER</type>"
		cXML += 				"</value>"
		cXML += 				"<value>"
		cXML += 					"<id>3</id>"
		cXML += 					"<title>Abastecido</title>"
		cXML += 					"<type>NUMBER</type>"
		cXML += 				"</value>"
		cXML += 				"<value>"
		cXML += 					"<id>4</id>"
		cXML += 					"<title>Retirado</title>"
		cXML += 					"<type>NUMBER</type>"
		cXML += 				"</value>"

		cXML += 				"<value>"
		cXML += 					"<id>5</id>"
		cXML += 					"<title>Vencido/Avaria</title>"
		cXML += 					"<type>NUMBER</type>"
		cXML += 				"</value>"

		cXML += 			"</valuesdefinitions>"

		//Abastecimento de maquinas de Bebidas - ALEXANDRE 08/05/14
	ElseIf nTpServ == 8

		cXML := "<?xml version='1.0' encoding='utf-8'?>"
		cXML += "<DynFormAnswer>"
		cXML += 	"<ServiceOrderID>@ORDEMSERVICOID</ServiceOrderID>"

		// Cod do cliente
		cXML += 	"<ItemAnswer>"
		cXML += 		"<ItemID>52323</ItemID>"
		cXML += 		"<TextAnswer>"+cCliente+"</TextAnswer>"
		cXML += 	"</ItemAnswer>"

		// Num Patrimonio
		cXML += 	"<ItemAnswer>"
		cXML += 		"<ItemID>52322</ItemID>"
		cXML += 		"<TextAnswer>"+cNumChapa+"</TextAnswer>"
		cXML += 	"</ItemAnswer>"

		// Email do Cliente -> a1_email a1_Xemail
		cXML += 	"<ItemAnswer>"
		If Upper(AllTrim(GetEnvServer())) == "JVVXC9_TESTE"
			cXML += 		"<ItemID>84801</ItemID>" // PROD 84801
		Else
			cXML += 		"<ItemID>67791</ItemID>" // PROD
		EndIf
		cXML += 		"<TextAnswer>"+cMailCli+"</TextAnswer>"
		cXML += 	"</ItemAnswer>"

		// OBS Administrador?
		cXML += 	"<ItemAnswer>"
		cXML += 		"<ItemID>94562</ItemID>"	       //
		cXML += 		"<TextAnswer>Sim</TextAnswer>"
		cXML += 	"</ItemAnswer>"

		// Mensagem do Administrador
		cXML += 	"<ItemAnswer>"
		cXML += 		"<ItemID>94568</ItemID>"	       //
		cXML += 		"<TextAnswer>AO TROCAR DE TABELA,  AQUI QUE O SISTEMA IR ALERTAR O ABASTECEDOR</TextAnswer>"
		cXML += 	"</ItemAnswer>"

		//Total Cash 94398
		//Total Sales 94399

		cXML += 	"<ItemAnswer>"
		cXML += 		"<ItemID>94399</ItemID>"
		cXML += 		"<TextAnswer>"
		cXML += 			"<maxtries>3</maxtries>"
		cXML +=				"<comparetype>lessorequal</comparetype>"
		cXML += 			"<itemquantitycheck>"
		cXML += 				"<itemid>1</itemid>"
		cXML += 				"<itemname>Informe o contedo do contador</itemname>"
		cXML += 				"<qtd>"+cvaltochar(aContAnt[2,2])+"</qtd>"
		cXML += 			"</itemquantitycheck>"
		cXML += 		"</TextAnswer>"
		cXML += 	"</ItemAnswer>"

		cXML += 	"<ItemAnswer>"
		cXML += 		"<ItemID>94398</ItemID>"
		cXML += 		"<TextAnswer>"
		cXML += 			"<maxtries>3</maxtries>"
		cXML +=				"<comparetype>lessorequal</comparetype>"
		cXML += 			"<itemquantitycheck>"
		cXML += 				"<itemid>1</itemid>"
		cXML += 				"<itemname>Informe o contedo do contador</itemname>"
		cXML += 				"<qtd>"+cvaltochar(aContAnt[1,2])+"</qtd>"
		cXML += 			"</itemquantitycheck>"
		cXML += 		"</TextAnswer>"
		cXML += 	"</ItemAnswer>"

		// CONTADORES NOS ABASTECIMENTO DE BEBIDAS
		cXML += 	"<ItemAnswer>"
		If Upper(AllTrim(GetEnvServer())) == "JVVXC9_TESTE"
			cXML += 		"<ItemID>84802</ItemID>"
		Else
			cXML += 		"<ItemID>67843</ItemID>"     //67820
		EndIf

		aAux := ItenPs('',cNumChapa,If( "Troca de Tabela" $ cDadosCnt,SUBSTR(cDadosCnt,1,3),cTabPat))

		cXML += 		"<TextAnswer>"
		cXML += 			"<maxtries>3</maxtries>"
		cXML +=				"<comparetype>lessorequal</comparetype>"

		For nX := 1 to len(aAux)
			IF !Empty(aAux[nX,02])
				cXML += 			"<itemquantitycheck>"
				cXML += 				"<itemid>"+cvaltochar(aAux[nX,01])+"</itemid>"
				cXML += 				"<itemname>(P"+cvaltochar(aAux[nX,01])+") "+aAux[nX,02]+" </itemname>"
				cXML += 				"<qtd>"+cvaltochar(aContAnt[nX+2,2])+"</qtd>"
				cXML += 			"</itemquantitycheck>"
			EndIF

		Next nX

		cXML +=				"<comparetype>lessorequal</comparetype>"

		cXML += 		"</TextAnswer>"
		cXML += 	"</ItemAnswer>"

		// Itens DO ABASTECIMENTO
		cXML += 	"<ItemAnswer>"
		cXML += 		"<ItemID>52321</ItemID>"
		cXML += 		"<TextAnswer>"
		cXML += 			"<valuesdefinitions>"
		cXML += 				"<value>"
		cXML += 					"<id>1</id>"
		cXML += 					"<title>Posio</title>"
		cXML += 					"<type>TEXT</type>"
		cXML += 				"</value>"
		cXML += 				"<value>"
		cXML += 					"<id>2</id>"
		cXML += 					"<title>Saldo</title>"
		cXML += 					"<type>NUMBER</type>"
		cXML += 				"</value>"
		cXML += 				"<value>"
		cXML += 					"<id>3</id>"
		cXML += 					"<title>Abastecido</title>"
		cXML += 					"<type>NUMBER</type>"
		cXML += 				"</value>"
		cXML += 				"<value>"
		cXML += 					"<id>4</id>"
		cXML += 					"<title>Retirado</title>"
		cXML += 					"<type>NUMBER</type>"
		cXML += 				"</value>"

		cXML += 				"<value>"
		cXML += 					"<id>5</id>"
		cXML += 					"<title>Vencido/Avaria</title>"
		cXML += 					"<type>NUMBER</type>"
		cXML += 				"</value>"

		cXML += 			"</valuesdefinitions>"

	EndIf

	// Prepara os itens
	cXML += 			"<itemsdefinitions>"
	cAux := ""
	// Formulario de abastecimento
	If nTpServ == 4 .OR. nTpServ == 8
		For nI := 1 To Len(aItens)
			cPosicao := aItens[nI][1]
			cCodigo := aItens[nI][2]
			cDesc := aItens[nI][3]
			cDesc := StrTran(cDesc,"&"," ")
			IIF( aItens[nI][4]<>0, cValor := Transform(aItens[nI][4],"@E 999.99"), cValor := "" )

			cXML += 		"<item>"
			cXML +=				"<id>"+cCodigo+"</id>"
			cXML +=				"<name>Cod " +cCodigo +" - " +cDesc +" - " +"Valor R$"+cValor +"</name>"
			cXML +=				"<adtinfos>"
			cXML +=					"<ai>"
			cXML +=						"<vid>1</vid>"
			cXML +=						"<dfvl>"+cPosicao+"</dfvl>"
			cXML +=					"</ai>"
			If !Empty(cPosicao)
				cXML +=					"<ai>"
				cXML +=						"<vid>2</vid>"
				cXML +=						"<dfvl>0</dfvl>"
				cXML +=					"</ai>"
				cXML +=					"<ai>"
				cXML +=						"<vid>3</vid>"
				cXML +=						"<dfvl>0</dfvl>"
				cXML +=					"</ai>"
				cXML +=					"<ai>"
				cXML +=						"<vid>4</vid>"
				cXML +=						"<dfvl>0</dfvl>"
				cXML +=					"</ai>"
				cXML +=					"<ai>"
				cXML +=						"<vid>5</vid>"
				cXML +=						"<dfvl>0</dfvl>"
				cXML +=					"</ai>"
			EndIF

			cXML +=				"</adtinfos>"
			cXML +=			"</item>"

			cAux += cPosicao + "/"
		Next nI
		// Formulario de abastecimento - correcao
	ElseIf nTpServ == 6 .or. nTpServ == 18 .or. nTpServ == 19
		For nI := 1 To Len(aItens)
			cDesc := AllTrim( Posicione( "SB1",1, xFilial("SB1")+aItens[nI][1],"B1_DESC") )
			cDesc := StrTran(cDesc,"&"," ")
			cValor := ""
			nVID := 1

			cXML += 		"<item>"
			cXML +=				"<id>"+aItens[nI][1]+"</id>"
			cXML +=				"<name>Cod " +aItens[nI][nPProduto] +" - " +cDesc +" - " +"Valor R$"+cValor +"</name>"
			cXML +=				"<adtinfos>"

			// 1. Posicao Mola
			cXML +=					"<ai>"
			cXML +=						"<vid>1</vid>"
			cXML +=						"<dfvl>"+iif(LEN(aItens[nI][nPMola])>1,aItens[nI][nPMola],"") +"</dfvl>"

			// Posicao da Mola nao preenchida?
			If Empty(aItens[nI][nPMola])
				cXML +=					"<hl>r</hl>"
				cXML +=					"<msg>Preencha corretamente</msg>"
			EndIf

			cXML +=					"</ai>"

			// Informacoes da Correcao [saldo-abastecido-retirado]
			For nJ := 3 To 6
				nVID++
				If Valtype(aItens[nI][nJ][1]) == "N"
					aItens[nI][nJ][1] := cvaltochar(aItens[nI][nJ][1])
				EndIf

				cXML +=					"<ai>"
				cXML +=						"<vid>"+cvaltochar(nVID)+"</vid>"
				cXML +=						"<dfvl>"+aItens[nI][nJ][1]+"</dfvl>"

				If !aItens[nI][nJ][2]
					cXML +=				"<hl>r</hl>"
					cXML +=				"<msg>Preencha corretamente</msg>"
				EndIf

				cXML +=					"</ai>"
			Next nJ

			cXML +=				"</adtinfos>"
			cXML +=			"</item>"
		Next nI
	EndIf

	cXML += 			"</itemsdefinitions>"
	cXML += 		"</TextAnswer>"
	cXML += 	"</ItemAnswer>"

	If nTpServ == 6 .or. nTpServ == 18 .or. nTpServ == 19
		// Total de selecoes
		cXML += "<ItemAnswer>"
		cXML += 	"<ItemID>"+If(nTpServ==19,"94538","94522")+"</ItemID>"
		cXML += 	"<TextAnswer>"+nTotSel+"</TextAnswer>"
		cXML += "</ItemAnswer>"

		// Total cash
		cXML += "<ItemAnswer>"
		cXML +=		"<ItemID>"+If(nTpServ==19,"94539","94521")+"</ItemID>"
		cXML +=		"<TextAnswer>"+nTotCash+"</TextAnswer>"
		cXML +=	"</ItemAnswer>"

		//Contadores Ps para maquinas de bebidas
		// CONTADORES NOS ABASTECIMENTO DE BEBIDAS	    PRECISA TESTAR POIS O RAPHAEL NAO PASSOU COMO MANDO O VALOR DO CAMPO PREENCHIDO
		If nTpServ == 18 .And. len(aLeitura) > 0
			cXML += 	"<ItemAnswer>"
			If Upper(AllTrim(GetEnvServer())) == "JVVXC9_TESTE"
				cXML += 		"<ItemID>94520</ItemID>"
			Else
				cXML += 		"<ItemID>67843</ItemID>"     //67820
			EndIf

			cXML += 		"<TextAnswer>"
			cXML += 			"<maxtries>3</maxtries>"
			cXML +=				"<comparetype>lessorequal</comparetype>"

			For nX := 1 to len(aLeitura)
				IF !Empty(aLeitura[nX,02])
					cXML += 			"<itemquantitycheck>"
					cXML += 				"<itemid>"+cvaltochar(nX)+"</itemid>"
					cXML += 				"<itemname>"+cvaltochar(aLeitura[nX,01])+"</itemname>"
					//cXML += 				"<qtd>"+cvaltochar(aContAnt[nX,2])+"</qtd>"
					cXML += 				"<qtd>"+cvaltochar(aLeitura[nX,02])+"</qtd>"
					cXML += 			"</itemquantitycheck>"
				EndIF

			Next nX

			cXML +=				"<comparetype>lessorequal</comparetype>"

			cXML += 		"</TextAnswer>"
			cXML += 	"</ItemAnswer>"
		EndIf
	EndIf

	cXML += "</DynFormAnswer>"

Return cXml

/*


?
Programa  WSKPF018  Autor  Microsiga            Data   04/10/14   
?
Desc.     Gera o xml para abertura da Ordem de servico do Chamado Tec.
          Parametro n 24 do OpenOrdemServico                          
                                                                      
?
Uso        Integracao Keeple                                          
?


*/

User Function WSKPF018(nTpServ,cNumChapa,cProblema,cDescClas)

	Local cXml := ""
	Default nTpServ := 0
	Default cNumChapa := ""
	Default cProblema := ""

	cXml := "<?xml version='1.0' encoding='UTF-8'?>"
	cXml += "<DynFormAnswer>"
	/*cXML += 	"<ItemAnswer>"
	cXML += 		"<ItemCode>5</ItemCode>"
	cXML += 		"<TextAnswer>8899</TextAnswer>"
	cXML += 	"</ItemAnswer>"*/

	/*cXML += 	"<ItemAnswer>"
	cXML += 		"<ItemCode>71</ItemCode>"
	cXML += 		"<TextAnswer>"

	cXML += 		"<valuesdefinitions>"
	cXML += 			"<value>"
	cXML += 				"<id>1</id>"
	cXML += 				"<title>Material</title>"
	cXML += 				"<type>TEXT</type>"
	cXML += 			"</value>"
	cXML += 		"</valuesdefinitions>"

	cXML += 		"<itemsdefinitions>"

	For nX := 1 to 3
	cXML += 			"<item>"
	cXML +=					"<id>MATERIAL"+cvaltochar(nX)+"</id>"
	cXML +=					"<name>Material "+cvaltochar(nX)+"</name>"
	cXML +=					"<adtinfos>"
	cXML +=						"<ai>"
	cXML +=							"<vid>"+cvaltochar(nX)+"</vid>"
	cXML +=							"<dfvl></dfvl>"
	cXML +=						"</ai>"
	cXML +=					"</adtinfos>"
	cXML +=				"</item>"
	Next nX

	cXML += 		"</itemsdefinitions>"

	cXML +=			"</TextAnswer>"
	cXML += 	"</ItemAnswer>" */
	cXml += "</DynFormAnswer>"

Return cXml

/*


?
Programa  WSKPF019  Autor  Alexandre Venancio   Data   26/12/13   
?
Desc.     Obtem o formulario de respostas do chamado Tecnico.	      
                                                                      
?
Uso        Integracao Keeple                                          
?


*/
User Function WSKPF019(cResult)

	Local aArea			:=	GetArea()
	Local aDados		:=	{}
	Local oXML			:= NIL
	Local cError		:= ""
	Local cWarning		:= ""
	Local aOSs			:= {}

	If !Empty(cResult)
		oXml := XmlParser( cResult, "_", @cError, @cWarning )
		If oXml == Nil
			MsgStop("Falha ao gerar Objeto XML : "+cError+" / "+cWarning)
			Return aDados
		Endif
	Else
		Return
	EndIf

	If XmlChildEx(oXml,"_CHANGESTREAM") != Nil
		If XmlChildEx(oXml:_CHANGESTREAM:_CHANGES,"_CHANGE") != Nil

			If ValType(oXml:_CHANGESTREAM:_CHANGES:_CHANGE:_XML:_FORMANSWERS:_FORMANSWER) == "O"
				aOSs := oXml:_CHANGESTREAM:_CHANGES:_CHANGE:_XML:_FORMANSWERS:_FORMANSWER
				cTipo := aOSs:_EXTERNALTIPOSERVICOID:TEXT
				cOS   := aOSs:_NUMEROOS:TEXT
				If Alltrim(aOSs:_STATUS:TEXT) == "FIOK"
					DbSelectArea("SZ6")
					DbSetORder(1)
					If Dbseek(xFilial("SZ6")+cOS) .Or. !Dbseek(xFilial("SZ6")+cOS)
						If Empty(SZ6->Z6_DATAFIM)
							If cTipo == "6"
								aDados := U_WSKPF007('',val(cTipo),aOSs)
								lBloq := .F.
								DbSelectArea("SA1")
								If DbSeek(xFilial("SA1")+aDados[Ascan(aDados,{|x| x[1] == "CLIENTE"}),02])
									If SA1->A1_MSBLQL == '1'
										Reclock("SA1",.F.)
										SA1->A1_MSBLQL := '2'
										SA1->(Msunlock())
										lBloq := .T.
									EndIf
								EndIf

								If lBloq
									DbSelectArea("SA1")
									If DbSeek(xFilial("SA1")+aDados[Ascan(aDados,{|x| x[1] == "CLIENTE"}),02])
										Reclock("SA1",.F.)
										SA1->A1_MSBLQL := '1'
										SA1->(Msunlock())
									EndIf
								EndIf
							ElseIf cTipo == "7" .Or. cTipo == "8"
								aDados := U_WSKPF006('',7,.F.,aOSs)
								DbSelectArea("SZ6")
								DbSetOrder(1)
								If Dbseek(xFilial("SZ6")+Alltrim(aDados[Ascan(aDados,{|x| x[1] == "NUMEROOS"}),02]))
									Reclock("SZ6",.F.)
									SZ6->Z6_DATAFIM := aDados[Ascan(aDados,{|x| x[1] == "DATAFIM"}),02]
									SZ6->Z6_HORAFIM := aDados[Ascan(aDados,{|x| x[1] == "HORAFIM"}),02]
									SZ6->Z6_RESPOST	:=	cResult
									SZ6->(Msunlock())
								Else
									Reclock("SZ6",.T.)
									SZ6->Z6_FILIAL 	:= xFilial("SZ6")
									SZ6->Z6_NUMOS	:= aDados[Ascan(aDados,{|x| x[1] == "NUMEROOS"}),02]
									SZ6->Z6_TPFORM 	:= VAL(cTipo)
									SZ6->Z6_DESCFOR	:= 'CHAMADO'
									SZ6->Z6_AGENTE 	:= aDados[Ascan(aDados,{|x| x[1] == "AGENTE"}),02]
									SZ6->Z6_NOMEAGE	:= '' //Posicione("AA1",8,xFilial("AA1")+aDados[Ascan(aDados,{|x| x[1] == "AGENTE"}),02],"AA1_NOMTEC")
									SZ6->Z6_DATAINI	:= aDados[Ascan(aDados,{|x| x[1] == "DATAINI"}),02]
									SZ6->Z6_HORAINI	:= aDados[Ascan(aDados,{|x| x[1] == "HORAINI"}),02]
									SZ6->Z6_DATACRI := aDados[Ascan(aDados,{|x| x[1] == "DATAINI"}),02]
									SZ6->Z6_HORACRI := aDados[Ascan(aDados,{|x| x[1] == "HORAINI"}),02]
									SZ6->Z6_CODCLI	:= aDados[Ascan(aDados,{|x| x[1] == "CLIENTE"}),02]
									SZ6->Z6_LOJCLI 	:= aDados[Ascan(aDados,{|x| x[1] == "LOJA"}),02]
									SZ6->Z6_CHAPA 	:= aDados[Ascan(aDados,{|x| x[1] == "ATIVO"}),02]
									SZ6->Z6_STATUS	:= "FIOK"
									SZ6->Z6_STATUSD := aDados[Ascan(aDados,{|x| x[1] == "OP02"}),02]
									SZ6->Z6_DATAFIM := aDados[Ascan(aDados,{|x| x[1] == "DATAFIM"}),02]
									SZ6->Z6_HORAFIM := aDados[Ascan(aDados,{|x| x[1] == "HORAFIM"}),02]
									//SZ6->Z6_RESPOST	:=	cResult
									SZ6->(Msunlock())
									U_PRTSRV05(aDados)
								EndIf
								If UPPER(ALLTRIM(aDados[Ascan(aDados,{|x| x[1] == "OP02"}),02])) == "FINALIZAR"
									U_PRTFSV03(aDados,'',VAL(cTipo))
								EndIf

							ElseIf cTipo == "88"
								aDados := U_WSKPF007('',8,aOSs,.T.)
							ElseIf cTipo == "9"
								aDados := U_WSKPF007('',9,aOSs,.T.)
								If len(aDados) > 0
									//STATICCALL(QFTCOM03,GeraPedido,'PC',cPedido)
									aPedido := STATICCALL(QFTCOM03,ConfCega,aDados,aDados[Ascan(aDados,{|x| x[1] == "CLIENTE"}),02])
									If len(aPedido) > 0
										//TRB->C7_NUM,TRB->C7_PRODUTO,TRB->C7_QUANT,TRB->C7_PRECO
										cliente := aDados[Ascan(aDados,{|x| x[1] == "CLIENTE"}),02]
										nAgente	:= val(aDados[Ascan(aDados,{|x| x[1] == "AGENTE"}),02])
										//nTipo,nTpServ,cCliFor,cLoja,cNumChapa,nAgente,cDtAgen,cHoraAgen,lJob,cObs,aNotas
										U_WSKPF001(1,8,cliente,'01','',nAgente,dDataBase,TIME(),.F.,'',aPedido)
										Reclock("SZ6",.T.)
										SZ6->Z6_FILIAL	:=	xFilial("SZ6")
										SZ6->Z6_NUMOS 	:=	aDados[Ascan(aDados,{|x| x[1] == "NUMEROOS"}),02]
										SZ6->Z6_TPFORM	:=	9
										SZ6->Z6_DESCFOR	:=	'ACEITE NF'
										SZ6->Z6_AGENTE	:= 	CVALTOCHAR(nAgente)
										SZ6->Z6_NOMEAGE	:=	Posicione( "AA1",7, xFilial("AA1") +CVALTOCHAR(nAgente), "AA1_NOMTEC" )
										SZ6->Z6_DATACRI	:=	aDados[Ascan(aDados,{|x| x[1] == "DATAINI"}),02]
										SZ6->Z6_HORACRI	:=	aDados[Ascan(aDados,{|x| x[1] == "HORAINI"}),02]
										SZ6->Z6_DATAFIM	:=	aDados[Ascan(aDados,{|x| x[1] == "DATAFIM"}),02]
										SZ6->Z6_HORAFIM	:=	aDados[Ascan(aDados,{|x| x[1] == "HORAFIM"}),02]
										SZ6->Z6_CODCLI	:=	aDados[Ascan(aDados,{|x| x[1] == "CLIENTE"}),02]
										SZ6->Z6_LOJCLI	:=	aDados[Ascan(aDados,{|x| x[1] == "LOJA"}),02]
										SZ6->Z6_RESPOST	:=	cResult
										SZ6->(Msunlock())

									EndIf
								EndIf
							ElseIf cTipo == "10"
								aDados := U_WSKPF016('',16,aOSs)
							ElseIf cTipo == "12"
								aDados := U_WSKPF011('',val(cTipo),aOSs)
							ElseIf cTipo == "13"
								aDados := U_WSKPF014('',13,aOSs)
							ElseIf cTipo == "11"
								aDados := U_WSKPF018('',18,aOSs)
							ElseIf cTipo == "20"
								aDados := U_WSKPF012('',20,aOSs)
							ElseIf cTipo == "25"
								aDados := U_WSKPF020('',aOSs)
								nAgente	:= val(aDados[Ascan(aDados,{|x| x[1] == "AGENTE"}),02])

								Reclock("SZ6",.T.)
								SZ6->Z6_FILIAL	:=	xFilial("SZ6")
								SZ6->Z6_NUMOS 	:=	aDados[Ascan(aDados,{|x| x[1] == "NUMEROOS"}),02]
								SZ6->Z6_TPFORM	:=	25
								SZ6->Z6_DESCFOR	:=	'DEPOSITO'
								SZ6->Z6_AGENTE	:= 	CVALTOCHAR(nAgente)
								SZ6->Z6_NOMEAGE	:=	Posicione( "AA1",7, xFilial("AA1") +CVALTOCHAR(nAgente), "AA1_NOMTEC" )
								SZ6->Z6_DATACRI	:=	aDados[Ascan(aDados,{|x| x[1] == "DATAINI"}),02]
								SZ6->Z6_HORACRI	:=	aDados[Ascan(aDados,{|x| x[1] == "HORAINI"}),02]
								SZ6->Z6_DATAFIM	:=	aDados[Ascan(aDados,{|x| x[1] == "DATAFIM"}),02]
								SZ6->Z6_HORAFIM	:=	aDados[Ascan(aDados,{|x| x[1] == "HORAFIM"}),02]
								SZ6->Z6_CODCLI	:=	aDados[Ascan(aDados,{|x| x[1] == "CLIENTE"}),02]
								SZ6->Z6_LOJCLI	:=	aDados[Ascan(aDados,{|x| x[1] == "LOJA"}),02]
								SZ6->Z6_RESPOST	:=	cResult
								SZ6->(Msunlock())
							ElseIf cTipo == "26"
								aDados := U_WSKPF021('',aOSs)
								nAgente	:= val(aDados[Ascan(aDados,{|x| x[1] == "AGENTE"}),02])

								Reclock("SZ6",.T.)
								SZ6->Z6_FILIAL	:=	xFilial("SZ6")
								SZ6->Z6_NUMOS 	:=	aDados[Ascan(aDados,{|x| x[1] == "NUMEROOS"}),02]
								SZ6->Z6_TPFORM	:=	25
								SZ6->Z6_DESCFOR	:=	'DEPOSITO'
								SZ6->Z6_AGENTE	:= 	CVALTOCHAR(nAgente)
								SZ6->Z6_NOMEAGE	:=	Posicione( "AA1",7, xFilial("AA1") +CVALTOCHAR(nAgente), "AA1_NOMTEC" )
								SZ6->Z6_DATACRI	:=	aDados[Ascan(aDados,{|x| x[1] == "DATAINI"}),02]
								SZ6->Z6_HORACRI	:=	aDados[Ascan(aDados,{|x| x[1] == "HORAINI"}),02]
								SZ6->Z6_DATAFIM	:=	aDados[Ascan(aDados,{|x| x[1] == "DATAFIM"}),02]
								SZ6->Z6_HORAFIM	:=	aDados[Ascan(aDados,{|x| x[1] == "HORAFIM"}),02]
								SZ6->Z6_CODCLI	:=	aDados[Ascan(aDados,{|x| x[1] == "CLIENTE"}),02]
								SZ6->Z6_LOJCLI	:=	aDados[Ascan(aDados,{|x| x[1] == "LOJA"}),02]
								SZ6->Z6_RESPOST	:=	cResult
								SZ6->(Msunlock())

							EndIf
						Else
							aDados := U_WSKPF006('',7,.F.,aOSs)

						EndIf
					EndIf
				EndIf
				//EndIF
			Else

				aOSs := oXml:_CHANGESTREAM:_CHANGES:_CHANGE:_XML:_FORMANSWERS:_FORMANSWER //:_FORMANSWER[2]

				If len(aOSs) > 0
					For nKy := 1 to len(aOSs)
						IF Alltrim(aOSs[nKy]:_STATUS:TEXT) == "FIOK"
							cTipo := aOSs[nKy]:_EXTERNALTIPOSERVICOID:TEXT
							cOS   := aOSs[nKy]:_NUMEROOS:TEXT
							aDados := {}
							DbSelectArea("SZ6")
							DbSetOrder(1)
							If Dbseek(xFilial("SZ6")+cOS) .Or. !Dbseek(xFilial("SZ6")+cOS)
								If Empty(SZ6->Z6_DATAFIM)
									/*
									ok	WSKPF005	-	TIPO 4		-	LEITURA DE MAQUINAS		(cResult,nTpServ,oObjeto)
									ok	WSKPF006	-	TIPO 7 OU 15	-	CHAMADO TECNICO		(cResult,nTpServ,lInvent,oObjeto)
									ok	WSKPF007	-	TIPO 6 OU 8 OU 9-	FORMULRIO PADARIA  (cResult,lInvent,oObjeto)
									ok	WSKPF011	-	TIPO 12		-	CHAMADA DE INVENTARIO 	(cResult,nOpcao,oObjeto)
									ok	WSKPF012	-	TIPO 20		-	PEDIDO DE COMPRA		(cResult,nOpcao,oObjeto)
									ok	WSKPF014	-	TIPO 13	   		RETORNO DE INVENTARIO	(cResult,cCampo,oObjeto)
									ok	WSKPF016	-	TIPO 10		-	TROCA DE MAPA			(cResult,cCampo,oObjeto)
									ok	WSKPF018	-	TIPO 11		-	DESCARTE   				(cResult,nTipo,oObjeto)
									ok	WSKPF020	-	TIPO 25		-	DEPOSITO BANCARIO 		(cResult,oObjeto) 							*/
									If cTipo == "4"
										aDados := U_WSKPF005('',val(cTipo),aOSs[nKy])
										//lGravou := U_QFTFAT11(VAL(cTipo),aDados,.F.)
										DbSelectArea("SZ6")
										DbSetOrder(1)
										If Dbseek(xFilial("SZ6")+aDados[Ascan(aDados,{|x| x[1] == "NUMEROOS"}),02])
											Reclock("SZ6",.F.)
											SZ6->Z6_DATAFIM := aDados[Ascan(aDados,{|x| x[1] == "DATA"}),02]
											SZ6->Z6_HORAFIM := aDados[Ascan(aDados,{|x| x[1] == "HORA"}),02]
											SZ6->Z6_RESPOST	:=	cResult
											SZ6->(Msunlock())
										EndIf

									ElseIf cTipo == "6"
										aDados := U_WSKPF007('',val(cTipo),aOSs[nKy])
										lBloq := .F.
										DbSelectArea("SA1")
										If DbSeek(xFilial("SA1")+aDados[Ascan(aDados,{|x| x[1] == "CLIENTE"}),02])
											If SA1->A1_MSBLQL == '1'
												Reclock("SA1",.F.)
												SA1->A1_MSBLQL := '2'
												SA1->(Msunlock())
												lBloq := .T.
											EndIf
										EndIf
										//Grava o orcamento dos produtos deixados na padaria
										//U_QFTFAT12(aDados,cResult)

										If lBloq
											DbSelectArea("SA1")
											If DbSeek(xFilial("SA1")+aDados[Ascan(aDados,{|x| x[1] == "CLIENTE"}),02])
												Reclock("SA1",.F.)
												SA1->A1_MSBLQL := '1'
												SA1->(Msunlock())
											EndIf
										EndIf
									ElseIf cTipo == "7" .Or. cTipo == "8"
										aDados := U_WSKPF006('',7,.F.,aOSs[nKy])
										DbSelectArea("SZ6")
										DbSetOrder(1)
										If Dbseek(xFilial("SZ6")+Alltrim(aDados[Ascan(aDados,{|x| x[1] == "NUMEROOS"}),02]))
											Reclock("SZ6",.F.)
											SZ6->Z6_DATAFIM := aDados[Ascan(aDados,{|x| x[1] == "DATAFIM"}),02]
											SZ6->Z6_HORAFIM := aDados[Ascan(aDados,{|x| x[1] == "HORAFIM"}),02]
											SZ6->Z6_RESPOST	:=	substr(cResult,1,65534)
											SZ6->(Msunlock())
										Else
											Reclock("SZ6",.T.)
											SZ6->Z6_FILIAL 	:= xFilial("SZ6")
											SZ6->Z6_NUMOS	:= aDados[Ascan(aDados,{|x| x[1] == "NUMEROOS"}),02]
											SZ6->Z6_TPFORM 	:= VAL(cTipo)
											SZ6->Z6_DESCFOR	:= 'CHAMADO'
											SZ6->Z6_AGENTE 	:= aDados[Ascan(aDados,{|x| x[1] == "AGENTE"}),02]
											SZ6->Z6_NOMEAGE	:= Posicione("AA1",8,xFilial("AA1")+aDados[Ascan(aDados,{|x| x[1] == "AGENTE"}),02],"AA1_NOMTEC")
											SZ6->Z6_DATAINI	:= aDados[Ascan(aDados,{|x| x[1] == "DATAINI"}),02]
											SZ6->Z6_HORAINI	:= aDados[Ascan(aDados,{|x| x[1] == "HORAINI"}),02]
											SZ6->Z6_DATACRI := aDados[Ascan(aDados,{|x| x[1] == "DATAINI"}),02]
											SZ6->Z6_HORACRI := aDados[Ascan(aDados,{|x| x[1] == "HORAINI"}),02]
											SZ6->Z6_CODCLI	:= aDados[Ascan(aDados,{|x| x[1] == "CLIENTE"}),02]
											SZ6->Z6_LOJCLI 	:= aDados[Ascan(aDados,{|x| x[1] == "LOJA"}),02]
											SZ6->Z6_CHAPA 	:= aDados[Ascan(aDados,{|x| x[1] == "ATIVO"}),02]
											SZ6->Z6_STATUS	:= "FIOK"
											SZ6->Z6_STATUSD := aDados[Ascan(aDados,{|x| x[1] == "OP02"}),02]
											SZ6->Z6_DATAFIM := aDados[Ascan(aDados,{|x| x[1] == "DATAFIM"}),02]
											SZ6->Z6_HORAFIM := aDados[Ascan(aDados,{|x| x[1] == "HORAFIM"}),02]
											SZ6->Z6_RESPOST	:=	cResult
											SZ6->(Msunlock())
											U_PRTSRV05(aDados)
										EndIf
										If UPPER(ALLTRIM(aDados[Ascan(aDados,{|x| x[1] == "OP02"}),02])) == "FINALIZAR
											U_PRTFSV03(aDados,'',VAL(cTipo))
										EndIf

									ElseIf cTipo == "88"
										aDados := U_WSKPF007('',8,aOSs[nKy],.T.)
										//U_QFTOPE04(aDados,2)
									ElseIf cTipo == "9"
										aDados := U_WSKPF007('',9,aOSs[nKy],.T.)
										If len(aDados) > 0
											//STATICCALL(QFTCOM03,GeraPedido,'PC',cPedido)
											//aPedido := STATICCALL(QFTCOM03,ConfCega,aDados,aDados[Ascan(aDados,{|x| x[1] == "CLIENTE"}),02])
											If len(aPedido) > 0
												//TRB->C7_NUM,TRB->C7_PRODUTO,TRB->C7_QUANT,TRB->C7_PRECO
												cliente := aDados[Ascan(aDados,{|x| x[1] == "CLIENTE"}),02]
												nAgente	:= val(aDados[Ascan(aDados,{|x| x[1] == "AGENTE"}),02])
												//nTipo,nTpServ,cCliFor,cLoja,cNumChapa,nAgente,cDtAgen,cHoraAgen,lJob,cObs,aNotas
												U_WSKPF001(1,8,cliente,'01','',nAgente,dDataBase,TIME(),.F.,'',aPedido)
												Reclock("SZ6",.T.)
												SZ6->Z6_FILIAL	:=	xFilial("SZ6")
												SZ6->Z6_NUMOS 	:=	aDados[Ascan(aDados,{|x| x[1] == "NUMEROOS"}),02]
												SZ6->Z6_TPFORM	:=	9
												SZ6->Z6_DESCFOR	:=	'ACEITE NF'
												SZ6->Z6_AGENTE	:= 	CVALTOCHAR(nAgente)
												SZ6->Z6_NOMEAGE	:=	Posicione( "AA1",7, xFilial("AA1") +CVALTOCHAR(nAgente), "AA1_NOMTEC" )
												SZ6->Z6_DATACRI	:=	aDados[Ascan(aDados,{|x| x[1] == "DATAINI"}),02]
												SZ6->Z6_HORACRI	:=	aDados[Ascan(aDados,{|x| x[1] == "HORAINI"}),02]
												SZ6->Z6_DATAFIM	:=	aDados[Ascan(aDados,{|x| x[1] == "DATAFIM"}),02]
												SZ6->Z6_HORAFIM	:=	aDados[Ascan(aDados,{|x| x[1] == "HORAFIM"}),02]
												SZ6->Z6_CODCLI	:=	aDados[Ascan(aDados,{|x| x[1] == "CLIENTE"}),02]
												SZ6->Z6_LOJCLI	:=	aDados[Ascan(aDados,{|x| x[1] == "LOJA"}),02]
												SZ6->Z6_RESPOST	:=	cResult
												SZ6->(Msunlock())
											EndIf
										EndIf
									ElseIf cTipo == "10"
										aDados := U_WSKPF016('',16,aOSs[nKy])
									ElseIf cTipo == "12"
										aDados := U_WSKPF011('',val(cTipo),aOSs[nKy])
									ElseIf cTipo == "13"
										aDados := U_WSKPF014('',13,aOSs[nKy])
									ElseIf cTipo == "11"
										aDados := U_WSKPF018('',18,aOSs[nKy])
									ElseIf cTipo == "20"
										aDados := U_WSKPF012('',20,aOSs[nKy])
									ElseIf cTipo == "25"
										aDados := U_WSKPF020('',aOSs[nKy])
										nAgente	:= val(aDados[Ascan(aDados,{|x| x[1] == "AGENTE"}),02])

										Reclock("SZ6",.T.)
										SZ6->Z6_FILIAL	:=	xFilial("SZ6")
										SZ6->Z6_NUMOS 	:=	aDados[Ascan(aDados,{|x| x[1] == "NUMEROOS"}),02]
										SZ6->Z6_TPFORM	:=	25
										SZ6->Z6_DESCFOR	:=	'DEPOSITO'
										SZ6->Z6_AGENTE	:= 	CVALTOCHAR(nAgente)
										SZ6->Z6_NOMEAGE	:=	Posicione( "AA1",7, xFilial("AA1") +CVALTOCHAR(nAgente), "AA1_NOMTEC" )
										SZ6->Z6_DATACRI	:=	aDados[Ascan(aDados,{|x| x[1] == "DATAINI"}),02]
										SZ6->Z6_HORACRI	:=	aDados[Ascan(aDados,{|x| x[1] == "HORAINI"}),02]
										SZ6->Z6_DATAFIM	:=	aDados[Ascan(aDados,{|x| x[1] == "DATAFIM"}),02]
										SZ6->Z6_HORAFIM	:=	aDados[Ascan(aDados,{|x| x[1] == "HORAFIM"}),02]
										SZ6->Z6_CODCLI	:=	aDados[Ascan(aDados,{|x| x[1] == "CLIENTE"}),02]
										SZ6->Z6_LOJCLI	:=	aDados[Ascan(aDados,{|x| x[1] == "LOJA"}),02]
										SZ6->Z6_RESPOST	:=	cResult
										SZ6->(Msunlock())
									ElseIf cTipo == "26"
										aDados := U_WSKPF021('',aOSs[nKy])
										nAgente	:= val(aDados[Ascan(aDados,{|x| x[1] == "AGENTE"}),02])

										Reclock("SZ6",.T.)
										SZ6->Z6_FILIAL	:=	xFilial("SZ6")
										SZ6->Z6_NUMOS 	:=	aDados[Ascan(aDados,{|x| x[1] == "NUMEROOS"}),02]
										SZ6->Z6_TPFORM	:=	25
										SZ6->Z6_DESCFOR	:=	'DEPOSITO'
										SZ6->Z6_AGENTE	:= 	CVALTOCHAR(nAgente)
										SZ6->Z6_NOMEAGE	:=	Posicione( "AA1",7, xFilial("AA1") +CVALTOCHAR(nAgente), "AA1_NOMTEC" )
										SZ6->Z6_DATACRI	:=	aDados[Ascan(aDados,{|x| x[1] == "DATAINI"}),02]
										SZ6->Z6_HORACRI	:=	aDados[Ascan(aDados,{|x| x[1] == "HORAINI"}),02]
										SZ6->Z6_DATAFIM	:=	aDados[Ascan(aDados,{|x| x[1] == "DATAFIM"}),02]
										SZ6->Z6_HORAFIM	:=	aDados[Ascan(aDados,{|x| x[1] == "HORAFIM"}),02]
										SZ6->Z6_CODCLI	:=	aDados[Ascan(aDados,{|x| x[1] == "CLIENTE"}),02]
										SZ6->Z6_LOJCLI	:=	aDados[Ascan(aDados,{|x| x[1] == "LOJA"}),02]
										SZ6->Z6_RESPOST	:=	cResult
										SZ6->(Msunlock())
									EndIf
								Else

								EndIf
							EndIf
							//U_QPWS01(cTipo,cOS,.T.)
						EndIF
					Next nKy
				EndIf
			EndIf
		EndIf
	Else
		aOSs := oXml:_FORMANSWERS:_FORMANSWER
		If valtype(aOSs) == "A"
			If len(aOSs) > 0
				For nKy := 1 to len(aOSs)
					IF Alltrim(aOSs[nKy]:_STATUS:TEXT) == "FIOK"
						cTipo := aOSs[nKy]:_EXTERNALTIPOSERVICOID:TEXT
						cOS   := aOSs[nKy]:_NUMEROOS:TEXT
						aDados := {}
						If cTipo == "4"
							aDados := U_WSKPF005('',val(cTipo),aOSs[nKy])
							lGravou := U_QFTFAT11(VAL(cTipo),aDados,.F.)
							DbSelectArea("SZ6")
							DbSetOrder(1)
							If Dbseek(xFilial("SZ6")+Avkey(aDados[Ascan(aDados,{|x| x[1] == "NUMEROOS"}),02],"Z6_NUMOS"))
								Reclock("SZ6",.F.)
								SZ6->Z6_DATAFIM := aDados[Ascan(aDados,{|x| x[1] == "DATA"}),02]
								SZ6->Z6_HORAFIM := aDados[Ascan(aDados,{|x| x[1] == "HORA"}),02]
								SZ6->Z6_RESPOST	:=	cResult
								SZ6->(Msunlock())
							EndIf
						EndIf
					EndIf
				Next nKy
			EndIf
		ElseIf valtype(aOSs) == "O"
			cTip := aOSs:_EXTERNALTIPOSERVICOID:TEXT
			cOS   := aOSs:_NUMEROOS:TEXT
			aDados := {}

			If cTip == "7" .Or. cTip == "15"
				aArray1 := U_QFTFSV04(1)
				aArray2 := U_QFTFSV04(2)
				//aDados := U_WSKPF006(cResult,7)
				dData := CtoD( SubStr( aOSs:_STATUSDATAHORA:TEXT,1,10 ) )
				cHora := SubStr( aOSs:_STATUSDATAHORA:TEXT,12 )

				cCodCli := aOSs:_EXTERNALCLIENTEID:TEXT
				cCodCli := SubStr(cCodCli,1,Len(cCodCli)-2)
				cCodCli := StrZero( Val(cCodCli), TamSx3("A1_COD")[1],0 )

				cLjCli := aOSs:_EXTERNALCLIENTEID:TEXT
				cLjCli := SubStr(cLjCli, Len(cLjCli)-1, Len(cLjCli) )

				dDataIni := ctod(' / / ')
				cHoraIni := ''
				// sequencias de atualizacao de status
				aSequencia := aOSs:_STATUSSEQUENCE:_STATUSINFO
				If Valtype(aSequencia) <> "O"
					For nI := 1 To Len( aSequencia )
						If AllTrim(aSequencia[nI]:_STATUS:TEXT) == "INIC" .OR. AllTrim(aSequencia[nI]:_STATUS:TEXT) == "CTEC"
							dDataIni := CtoD( SubStr( aSequencia[nI]:_DATAHORA:TEXT,1,10 ) )
							cHoraIni := SubStr(aSequencia[nI]:_DATAHORA:TEXT,12 )
						EndIf
					Next nI
				EndIF

				If Empty(cHoraini)
					dDataIni := dData
					cHoraIni := cHora
				EndIf

				AADD( aDados, { "NUMEROOS"	,aOSs:_NUMEROOS:TEXT } )					// Numero da OS
				AADD( aDados, { "AGENTE"	,AllTrim(aOSs:_AGENTECODIGO:TEXT ) } )	// Codigo do agente
				AADD( aDados, { "CLIENTE"	,cCodCli } )														// cliente
				AADD( aDados, { "LOJA"		,cLjCli } )															// loja
				AADD( aDados, { "DATAINI"		,dDataIni } )														// data ini
				AADD( aDados, { "HORAINI"		,cHoraIni } )														// hora ini
				AADD( aDados, { "DATAFIM"		,dData } )														// data fim
				AADD( aDados, { "HORAFIM"		,cHora } )

				lRetorno := U_QFTFSV03(aDados,'',VAL(cTip))

				//If !lRetorno
				DbSelectArea("SZ6")
				DbSetOrder(1)
				If Dbseek(xFilial("SZ6")+Avkey(aDados[K(aDados,{|x| x[1] == "NUMEROOS"}),02],"Z6_NUMOS"))
					Reclock("SZ6",.F.)
					SZ6->Z6_DATAFIM := aDados[Ascan(aDados,{|x| x[1] == "DATAFIM"}),02]
					SZ6->Z6_HORAFIM := aDados[Ascan(aDados,{|x| x[1] == "HORAFIM"}),02]
					SZ6->Z6_RESPOST	:=	cResult
					SZ6->(Msunlock())
				EndIf
				//EndIf
			EndIf

		EndIf
	EndIf
	Freeobj(oXML)	//chamada feita
Return

/*


"
Programa  WSKPF020  Autor  Alexandre Venancio   Data   19/05/14   
?
Desc.      Faz a transferencia de OS entre tecnicos                   
                                                                      
?
Uso        AP                                                        
?


*/

User Function WSKPF020(cNumOs,nAgente)

	Local lRet := .F.
	Local aDados := {}
	Local cAuthCode := "DA490E96B31ACE4C7ABB0B5E0784A3DB6C96985D"
	Local cClientCode := "42CB7AEE2B2FFA173B53"
	Local cResult := ""
	Local cDtAux := ""
	Local cObsZG := ""

	dbSelectArea("SZG")
	dbSetOrder(1)
	If !dbSeek( xFilial("SZG") +AvKey(cNumOs,"ZG_NUMOS") )
		// OS nao encontrada
		Return lRet
	EndIf
	cObsZG := AllTrim(SZG->ZG_OBS)

	If nAgente == SZG->ZG_AGENTE
		Return lRet
	EndIf

	cAgntOld := cvaltochar(SZG->ZG_AGENTE)
	cNomAgOld := SZG->ZG_AGENTED
	cRota := Posicione( "AA1",7, xFilial("AA1") +CVALTOCHAR(nAgente), "AA1_LOCAL" )
	cNomAgente := Posicione( "AA1",7, xFilial("AA1") +CVALTOCHAR(nAgente), "AA1_NOMTEC" )

	cDtAux := SubStr(DTOS(SZG->ZG_DATAINI),1,4)+"-"+SubStr(DTOS(SZG->ZG_DATAINI),5,2)+"-"+SubStr(DTOS(SZG->ZG_DATAINI),7,2)+"T"+SZG->ZG_HORAINI

	AADD( aDados, cAuthCode )
	AADD( aDados, cClientCode )
	AADD( aDados, Val(cNumOs) )
	AADD( aDados, 1 )
	AADD( aDados, nAgente )
	AADD( aDados, cDtAux )             // datahora agendamento
	AADD( aDados, Nil )
	AADD( aDados, .T. )

	cResult := U_WSKPC009(aDados)
	If !Empty(cResult) .And. "true" $ cResult
		// grava a alteracao na tabela SZG
		If RecLock("SZG",.F.)
			SZG->ZG_AGENTE := nAgente
			SZG->ZG_AGENTED := cNomAgente
			SZG->ZG_ROTA := cRota
			SZG->ZG_STATUS := "DESP"
			SZG->ZG_STATUSD := "Despachado"
			SZG->ZG_OBS := cObsZG +"|" +"TRANSFERIDA - AGENTE ANT.: " +cAgntOld + "/" +cNomAgOld
			SZG->( MsUnLock() )
			lRet := .T.
		EndIf
	EndIf

Return lRet

/*


?
Programa  WSKPF021  Autor  Alexandre Venancio   Data   27/05/14   
?
Desc.     Faz o cancelamento de uma OS                                
                                                                      
?
Uso        AP                                                         
?


*/

User Function WSKPF021(cNumOs,cStatus,cDescStat)

	// metodo cancelar OS
	/*
	SetAcompanhamentoOrdemServicoByNumeroOS("DA490E96B31ACE4C7ABB0B5E0784A3DB6C96985D",
	"42CB7AEE2B2FFA173B53", 31117, null, null, null, "COPE", true)
	*/

	Local lRet := .F.
	Local aDados := {}
	Local cAuthCode := "DA490E96B31ACE4C7ABB0B5E0784A3DB6C96985D"
	Local cClientCode := "42CB7AEE2B2FFA173B53"
	Local cResult := ""
	Local cDtAux := ""

	cDtAux := StrTran( DtoC( Date() ) ,"/","-")
	cDtAux := SubStr(cDtAux,7) +"-" +SubStr(cDtAux,4,2) +"-" +SubStr(cDtAux,1,2) + "T" +Time()

	AADD( aDados, cAuthCode )
	AADD( aDados, cClientCode )
	AADD( aDados, Val(cNumOs) )
	AADD( aDados, 1 )
	AADD( aDados, 0 )
	AADD( aDados, cDtAux)
	AADD( aDados, cStatus )
	AADD( aDados, .T. )

	cResult := U_WSKPC009(aDados)
	If !Empty(cResult) .And. "true" $ cResult
		If RecLock("SZG",.F.)
			SZG->ZG_STATUS := cStatus //"COPE"
			SZG->ZG_STATUSD := cDescStat             //"Cancelado pelo Atendente"
			MsUnLock()
		EndIf
		lRet := .T.
	EndIf

Return lRet

/*


?
Programa  WSKPF022  Autor  Alexandre Venancio   Data   08/08/14   
?
Desc.     Envia email ao cliente com resultados das leituras dos      
          contadores das maquinas                                     
?
Uso        AP                                                         
?


*/

User Function WSKPF022(cAgente,cDataAtu,lReenvio)

	Local cQuery := ""
	Local cQuery2 := ""
	Local nI
	Local aArquivos := {}
	Local cDestino := ""
	Local cAssunto := "Fechamento - Leituras - Praticca"
	Local cHtml := ""
	Local nPendente := 0
	Local aResp := {}
	Local aAux := {}
	Local nTotal := 0
	Local cCliente := ""
	Local cLoja := ""
	Local cStatus := ""
	Local lEnvMail := .F.
	Local aAxMail := {}
	Local aEmail := {}
	Local cMailDest := ""
	Local cNomeAb	:=	""
	Local aPastas := Directory("c:\garbage\*.*", "D")

	Default cAgente := ""
	Default cDataAtu := Date()
	Default lReenvio := .F.

	// primeira consulta - resultados agrupados com total por agente + cliente + loja do dia
	cQuery := "SELECT ZG_AGENTE,ZG_AGENTED, ZG_CLIFOR, ZG_LOJA, COUNT(*) TOTAL FROM " +RetSqlName("SZG")
	cQuery += " WHERE ZG_DATAINI = '"+DTOS(cDataAtu)+"'"

	If !Empty(cAgente)
		cQuery += " AND ZG_AGENTE='"+cAgente+"' AND ZG_EOS='3'"
	Else
		cQuery += " AND ZG_EOS<>'' "
	EndIf

	cQuery += " GROUP BY ZG_AGENTE,ZG_AGENTED, ZG_CLIFOR, ZG_LOJA "

	If Select("TRBG") > 0
		TRBG->( dbCloseArea() )
	EndIf

	TcQuery cQuery New Alias "TRBG"
	dbSelectArea("TRBG")
	While TRBG->( !EOF() )
		cAgente	 := CVALTOCHAR(TRBG->ZG_AGENTE)
		cCliente := TRBG->ZG_CLIFOR
		cLoja := TRBG->ZG_LOJA
		cNomeAb := cvaltochar(TRBG->ZG_AGENTED)
		nTotal := TRBG->TOTAL
		nPendente := 0
		cStatus := ""
		aResp := {}
		aAux := {}
		cHtml := ""
		lEnvMail := .F.

		// segunda consulta - todas as OS do agente - cliente - loja do dia
		cQuery2 := "SELECT ZG_NUMOS, ZG_EOS, ZG_STATUS, ZG_PATRIM, ZG_PATRIMD, ZG_DATAFIM, ZG_HORAFIM, ZN_NUMATU, ZN_COTCASH, "
		cQuery2 += " ZN_BOTAO01, ZN_BOTAO02, ZN_BOTAO03, ZN_BOTAO04, ZN_BOTAO05, ZN_BOTAO06, ZN_BOTAO07, "
		cQuery2 += " ZN_BOTAO08, ZN_BOTAO09, ZN_BOTAO10, ZN_BOTAO11, ZN_BOTAO12, ZN_BOTAO13, ZN_BOTAO14, "
		cQuery2 += " ZN_BOTAO15, ZN_BOTAO16, ZN_BOTAO17, ZN_BOTAO18, ZN_BOTAO19, ZN_BOTAO20, ZN_BOTAO21, "
		cQuery2 += " ZN_BOTAO22, ZN_BOTAO23, ZN_BOTAO24, ZN_BOTAO25, ZN_BOTTEST, ZN_PARCIAL FROM " +RetSqlName("SZG") +" ZG "
		cQuery2 += " LEFT JOIN " +RetSqlName("SZN") +" ZN ON "
		cQuery2 += " ZN_DATA = ZG_DATAFIM "
		cQuery2 += " AND ZN_PATRIMO = ZG_PATRIM "
		cQuery2 += " AND ZN_NUMOS = ZG_NUMOS "
		cQuery2 += " AND ZN_AGENTE = ZG_AGENTE "
		cQuery2 += " AND ZN.D_E_L_E_T_ = ZG.D_E_L_E_T_ "
		cQuery2 += " WHERE "
		cQuery2 += " ZG_DATAINI = '"+DTOS(cDataAtu)+"' AND ZG_CLIFOR = '"+cCliente+"' AND ZG_LOJA = '"+cLoja+"' AND ZG_AGENTE = '"+cAgente+"' "
		If !lReenvio
			cQuery2 += " AND ZG.ZG_EOS <> '2'"
		EndIf

		cQuery2 += " AND ZG.D_E_L_E_T_ = '' "

		If Select("TRBG2") > 0
			TRBG->( dbCloseArea() )
		EndIf

		TcQuery cQuery2 New Alias "TRBG2"
		dbSelectArea("TRBG2")
		While TRBG2->( !EOF() )
			If !AllTrim(TRBG2->ZG_STATUS) $ "CTEC|COPE|CCLI|FIOK"
				nPendente++
				TRBG2->( dbSkip() )
				Loop
			EndIf

			For nI := 1 To FCount()
				If FieldName(nI) == "ZG_EOS"
					If AllTrim( FieldGet(nI) ) == "1" .or. lReenvio
						lEnvMail := .T.
					EndIf
				ElseIf FieldName(nI) == "ZG_STATUS"
					cStatus := AllTrim( FieldGet(nI) )
					Exit
				EndIf
			Next nI

			// Adicionar somente as OS finalizadas
			If cStatus == "FIOK"
				For nI := 1 To FCount()
					If FieldName(nI) $ "ZG_EOS|ZG_STATUS"
						Loop
					EndIf

					AADD( aAux, { FieldName(nI), IIF(ValType(FieldGet(nI))=="N",cvaltochar(FieldGet(nI)),FieldGet(nI)) }  )
				Next nI
			EndIf

			If Len(aAux) > 0
				AADD( aResp, aAux )
			EndIf
			aAux := {}
			TRBG2->( dbSkip() )
		End
		TRBG2->( dbCloseArea() )

		// verifica se pode enviar o email
		If lEnvMail .And. nPendente == 0
			cDestino := AllTrim( Posicione("SA1",1,xFilial("SA1") +AvKey(cCliente,"A1_COD") +AvKey(cLoja,"A1_LOJA"), "A1_EMAIL") )	// EMAIL DO CLIENTE
			cDestino += ";tgsouza@Praticca.com.br;fblopes@Praticca.com.br"
			//cDestino := 'avenancio@Praticca.com.br'

			aEmail := StrToKarr(cDestino,";")
			If Len(aEmail) > 0
				For nI := 1 To Len(aEmail)
					If Ascan( aAxMail, { |x| AllTrim(x) == aEmail[nI] } ) == 0
						AADD( aAxMail, aEmail[nI] )
					EndIf
				Next nI

				For nI := 1 To Len(aEmail)
					cMailDest += aEmail[nI]
					If nI <> Len(aEmail)
						cMailDest += ";"
					EndIf
				Next nI
			EndIf
			//incluir aqui o envio da foto tirada no atendimento para o cliente, o padrao da pasta e \protheus_data\_keeple\Tipo_Form\Nr_OS\Foto\xxx.jpg
			cHtml := U_WSKPF023(aResp,cNomeAb)
			If !Empty(cHtml) .And. !Empty(cMailDest)
				Aadd(aArquivos,{"\system\logocob.jpg",'Content-ID: <ID_logocob.jpg>'})
				U_TTMAILN('microsiga@Praticca.com.br', cMailDest, cAssunto, cHtml, aArquivos,.T.)

				// Altera o flag das OS para '2 - enviada'
				For nI := 1 To Len(aResp)
					dbSelectArea("SZG")
					dbSetOrder(1)
					dbSeek( xFilial("SZG") +AvKey( aResp[nI][1][2],"ZG_NUMOS") )
					If RecLock("SZG",.F.)
						SZG->ZG_EOS := "2"
						MsUnLock()
					EndIf
				Next nI

				U_TTGENC01( xFilial("SZG"),"TTWS","ORDEM DE SERVICO","",,"","WS",dtos(date()),time(),,"ENVIO DE EMAIL - CLIENTE: "+cCliente + " | LOJA: " +cLoja,,,"SZG" )
			EndIf
		EndIf
		TRBG->( dbSkip() )
	End
	TRBG->( dbCloseArea() )

Return

/*


?
Programa  WSKPF023  Autor  Alexandre Venancio   Data   08/08/14   
?
Desc.     Cria o corpo do email com informacoes dos contadores        
          para envio ao cliente                                       
?
Uso        AP                                                         
?


*/

User Function WSKPF023(aResp,cNomeAb)

	Local cHtml := ""
	Local nI
	Local nJ
	Local cNumchapa := ""
	Local cDescChapa := ""
	Local cData := ""
	Local cHora := ""
	Local cTxtCab := ""
	Local lTodosP := .T.
	Local cProd := ""
	Local cFamil := ""
	Local nOpera := 1

	If Len(aResp) == 0
		Return cHtml
	EndIf

	cHtml := "<html>"
	cHtml += "<head>
	cHtml += "<title></title>"
	cHtml += "<style type='text/css'>  "
	cHtml += "	table.bordasimples {border-collapse: collapse;}	"
	cHtml += "	table.bordasimples tr td {border:1px solid #91476C;}"
	cHtml += "	body { background-color: #FFFFFF;	color: #5D665B; 	margin: 50px;	font-family: Times New Roman, Times, serif;	font-size: small; 	}"
	cHtml += "</style>"
	cHtml += "</head>"

	cHtml += "<body>"
	cHtml += " <table align='center'><tr>"
	cHtml += "	<img src='cid:ID_logocob.jpg' height='42' width='42'></td>"
	cHtml += " </tr></table><br><br>"

	cHtml += "<font face='Verdana'>Conforme solicitao de nosso abastecedor e por constar seu email em nosso cadastro, voc esta recebendo uma cpia da leitura realizada nos Patrimnios abaixo para conferncia <br><br>"
	cHtml += " Abastecedor que realizou a leitura <b>"+cNomeAb+"</b>"

	dbSelectArea("SX3")
	dbSetOrder(2)

	For nI := 1 To Len(aResp)
		For nJ := 1 To 5
			If aResp[nI][nJ][1] == "ZG_PATRIM"
				cNumChapa := aResp[nI][nJ][2]
				Loop
			ElseIf aResp[nI][nJ][1] == "ZG_PATRIMD"
				cDescChapa := aResp[nI][nJ][2]
				Loop
			ElseIf aResp[nI][nJ][1] == "ZG_DATAFIM"
				cData :=  aResp[nI][nJ][2]
				Loop
			ElseIf aResp[nI][nJ][1] == "ZG_HORAFIM"
				cHora := aResp[nI][nJ][2]
				Loop
			EndIf
		Next nJ

		// Verificar tipo da maquina para montar o email - VERIFICAR POSTERIORMENTE
		cProd := Posicione("SN1",2,xFilial("SN1") +AvKey(cNumChapa,"N1_CHAPA"), "N1_PRODUTO" )
		cFamil := Posicione("SB1",1,xFilial("SB1") +AvKey(cProd,"B1_COD"),"B1_XFAMILI")
		If AllTrim(cFamil) <> "153"
			lTodosP := .F.
		EndIf
		//cData := '20141112'
		cTxtCab := "Mquina " +cNumChapa +" - " +cDescChapa +" - " +cvaltochar(stod(cData)) + "	" +cHora

		cHtml += "<table border='1'>"
		cHtml += 	"<tr>"
		cHtml += 		"<td colspan='2' bgcolor='#191970'><font face='verdana' color='FFFFFF'><B>"+cTxtCab+"</B></font></td>"
		cHtml += 	"</tr>"

		cHtml += 	"<tr>"
		cHtml += 		"<td bgcolor='#6495ED'><font face='verdana' color='FFFFFF'><B>Tipo de contador</B></font></td>"
		cHtml += 		"<td bgcolor='#6495ED'><font face='verdana' color='FFFFFF'><B>Valor</B></font></td>"
		cHtml += 	"</tr>"

		nOpera := 1

		For nJ := 6 To Len(aResp[nI])
			// Outras maquinas - nao mostrar os P's
			If !lTodosP
				If "ZN_BOTAO" $ aResp[nI][nJ][1]
					Loop
				EndIf
				// Maquina de bebidas quentes - nao mostrar campo CotCash
			Else
				If "ZN_COTCASH" == aResp[nI][nJ][1]
					Loop
				EndIf
			EndIf

			dbSeek(aResp[nI][nJ][1])

			If nOpera % 2 == 0
				cHtml += 	"<tr>"
				cHtml += 		"<td bgcolor='#EEE9E9'>"+X3Titulo(aResp[nI][nJ][1])+"</td>"
				cHtml += 		"<td bgcolor='#EEE9E9'>"+aResp[nI][nJ][2]+"</td>"
				cHtml += 	"</tr>"
			Else
				cHtml += 	"<tr>"
				cHtml += 		"<td>"+X3Titulo(aResp[nI][nJ][1])+"</td>"
				cHtml += 		"<td>"+aResp[nI][nJ][2]+"</td>"
				cHtml += 	"</tr>"
			EndIf
			nOpera++
		Next nJ

		cHtml += "</table>"

		If nI <> Len(aResp)
			cHtml += "<p>&nbsp;</p>"
		EndIf
	Next nI

	cHtml += "<BR><BR><font color='#FFA500'><b>Praticca.<BR>"
	cHtml += "MATRIZ - SP</b></font><BR>"
	cHtml += "Tel.: 011 99999999<BR>"
	cHtml += "<a href='http://www.Praticca.com.br'>www.Praticca.com.br</a><BR><BR><BR><BR>"

	cHtml += "<font face='arial' size='2'>AVISO LEGAL<br><br>"
	cHtml += "Esta mensagem  destinada exclusivamente para a(s) pessoa(s) a quem  dirigida, podendo conter informao confidencial e/ou  legalmente privilegiada. Se voc no for destinatrio desta mensagem, desde j fica notificado de abster-se a divulgar, copiar, distribuir, examinar ou, de qualquer forma, utilizar a informao contida nesta mensagem, pode ser ilegal. Caso voc tenha recebido esta mensagem por engano, pedimos que nos retorne este E-Mail, promovendo, desde logo, a eliminao do seu contedo em sua base de dados, registros ou sistema de controle. Fica desprovida de eficcia e validade a mensagem que contiver vnculos obrigacionais, expedidas por quem no detenha poderes de representao.<br><br><br>"

	cHtml += "LEGAL ADVICE<br><br>"
	cHtml += "This message is exclusively destined for the people to whom it is directed, and it can bear private and/or legally exceptional information. If you are not addressee of this message, since now you are advised to not release, copy, distribute, check or, otherwise, use the information contained in this message, because it is illegal. If you received this message by mistake, we ask you to return this email, making possible, as soon as possible, the elimination of its contents of your database, registrations or controls system. The message that bears any mandatory links, issued by someone who has no representation powers, shall be null or void.<br><br></font>"

	cHtml += "</body>"
	cHtml += "</html>"

Return cHtml

/*


?
Programa  WSKPXFUN  Autor  Microsiga            Data   11/04/14   
?
Desc.       Geracao do formulario de ficha de atendimento novo        
          com troca de sistema de pagamento.                          
?
Uso        AP                                                        
?


*/

User Function WSKPF024()

	Local aArea	:=	GetArea()

	// Sangria
	If nTpServ == 3

		If Upper(AllTrim(GetEnvServer())) == "JVVXC9_TESTE"
			cTpLacre := IF( !Empty(aInfo[1]), aInfo[1], "Sem Lacre" )
		Else
			cTpLacre := IF( !Empty(aInfo[1]), aInfo[1], "Sem Lacre" )
		EndIf

		cTpMoed := IF( !Empty(aInfo[2]), aInfo[2], "no" )
		cTpLog := IF( !Empty(aInfo[3]), aInfo[3], "no" )
		cTpTroco := IF( !Empty(aInfo[4]), aInfo[4], "no" )

	EndIf

	RestArea(aArea)

Return
/*


?
Programa  WSKPXFUN  Autor  Microsiga            Data   11/04/14   
?
Desc.      Geracao do form de inclusao de sistema de pagamento.       
                                                                      
?
Uso        AP                                                         
?


*/

User Function WSKPF025(cNumChapa,aOpcoes)

	Local aArea	:=	GetArea()
	Local cXml	:=	''

	cXml := "<?xml version='1.0' encoding='utf-8' ?>"
	cXml += "<DynFormAnswer>"

	cXml += 	"<ItemAnswer>"
	cXml += 		"<ItemID>87708</ItemID>"
	cXml += 		"<TextAnswer>"+cNumChapa+"</TextAnswer>"
	cXml += 	"</ItemAnswer>"
	cXml += 	"<ItemAnswer>"
	cXml += 		"<ItemID>87365</ItemID>"
	cXml += 		"<TextAnswer>"+aOpcoes[1,2]+"</TextAnswer>"
	cXml += 	"</ItemAnswer>"
	cXml += 	"<ItemAnswer>"
	cXml += 		"<ItemID>87366</ItemID>"
	cXml += 		"<TextAnswer>"+aOpcoes[2,2]+"</TextAnswer>"
	cXml += 	"</ItemAnswer>"
	cXml += 	"<ItemAnswer>"
	cXml += 		"<ItemID>87367</ItemID>"
	cXml += 		"<TextAnswer>"+aOpcoes[3,2]+"</TextAnswer>"
	cXml += 	"</ItemAnswer>"
	cXml += 	"<ItemAnswer>"
	cXml += 		"<ItemID>87368</ItemID>"
	cXml += 		"<TextAnswer>"+aOpcoes[4,2]+"</TextAnswer>"
	cXml += 	"</ItemAnswer>"
	cXml += 	"<ItemAnswer>"
	cXml += 		"<ItemID>87369</ItemID>"
	cXml += 		"<TextAnswer>"+aOpcoes[5,2]+"</TextAnswer>"
	cXml += 	"</ItemAnswer>"
	cXml += 	"<ItemAnswer>"
	cXml += 		"<ItemID>87606</ItemID>"
	cXml += 		"<TextAnswer>"+aOpcoes[6,2]+"</TextAnswer>"
	cXml += 	"</ItemAnswer>"

	cXml += "</DynFormAnswer>"

	RestArea(aArea)

Return(cXml)

/*


"
Programa  WSKPF026  Autor  Alexandre Venancio  Data   04/11/14   
?
Desc.     Tratamento do retorno da OS de Confirmacao de entrega       
                                                                      
?
Uso        AP                                                         
?


*/

User Function WSKPF026(cResult,cMsgErro)

	Local aDados := {}
	Local cMsgTxt := ""
	Local cError := ""
	Local cWarning := ""
	Local aItens := {}
	Local oXml
	Local nI

	Default cResult := ""

	If Empty(cResult)
		ConOut("# WSKPF026 - CADE O PARAMETRO? #")
		Return aDados
	EndIf

	oXml := XmlParser( cResult, "", @cError, @cWarning )
	If oXml == Nil
		cMsgTxt := "FALHA AO GERAR O OBJETO XML : " +cError+" / "+cWarning
		MsgStop(cMsgTxt)
		ConOut("# WSKPF026 ->" +cMsgTxt  +" #")
		cMsgErro += cMsgTxt
		Return aDados
	EndIf

	If XmlChildEx( oXml, "_FORMANSWERS" ) <> NIL
		If XmlChildEx( oXml:_FORMANSWERS, "_FORMANSWER" ) <> NIL
			If XmlChildEx( oXml:_FORMANSWERS:_FORMANSWER, "_NUMEROOS" ) <> NIL
				AADD( aDados, { "NUMEROOS", oXml:_FORMANSWERS:_FORMANSWER:_NUMEROOS:TEXT  } )
			EndIf
			If XmlChildEx( oXml:_FORMANSWERS:_FORMANSWER, "_STATUSDATAHORA" ) != NIL
				AADD( aDados, { "DATA", CtoD( SubStr( oXml:_FormAnswers:_FormAnswer:_STATUSDATAHORA:TEXT,1,10 )) } )
				AADD( aDados, { "HORA", SubStr( oXml:_FormAnswers:_FormAnswer:_STATUSDATAHORA:TEXT,12 ) } )
			EndIf
			If XmlChildEx( oXml:_FORMANSWERS:_FORMANSWER, "_ITEMANSWERS" ) <> NIL
				If XmlChildEx( oXml:_FORMANSWERS:_FORMANSWER:_ITEMANSWERS, "_ITEMANSWER" ) <> NIL
					aItens := oXml:_FORMANSWERS:_FORMANSWER:_ITEMANSWERS:_ITEMANSWER
					For nI := 1 To Len(aItens)
						If XmlChildEx( aItens[nI]:_ANSWER, "_SELECTEDALTERNATIVE" ) <> Nil
							AADD( aDados, { upper(aItens[nI]:_ITEM:TEXT), upper(aItens[nI]:_ANSWER:_SELECTEDALTERNATIVE:TEXT) } )
						Else
							AADD( aDados, { upper(aItens[nI]:_ITEM:TEXT), upper(aItens[nI]:_ANSWER:TEXT) } )
						EndIf

					Next nI
				EndIf
			EndIf
		EndIf
	EndIf

Return aDados

/*


?
Programa  WSKPXFUN  Autor  Microsiga            Data   11/05/14   
?
Desc.       Retorno das OSs de Inclusao de sistema de pagamento.     
                                                                      
?
Uso        AP                                                         
?


*/

User Function WSKPF027(cResult)

	Local aDados := {}
	Local oXML
	Local cError	:= ""
	Local cWarning	:= ""
	Local cCodCli	:= ""
	Local cLjCli	:= ""
	Local dData
	Local cHora
	Local cDataI	:= ""
	Local cHoraI	:= ""
	Local aResp
	Local aItens
	Local aCampos	:= {}
	Local aHoraIni	:= {}
	Local nI		:= 0
	Local nPos		:= 0
	Local cCampPatr := ""

	If !Empty(cResult)
		oXml := XmlParser( cResult, "_", @cError, @cWarning )
		If (oXml == NIL )
			MsgStop("Falha ao gerar Objeto XML : "+cError+" / "+cWarning)
			Return aDados
		Endif
	EndIf

	If oXml <> Nil
		dData := CtoD( SubStr( oXml:_FormAnswers:_FormAnswer:_STATUSDATAHORA:TEXT,1,10 ) )
		cHora := SubStr( oXml:_FormAnswers:_FormAnswer:_STATUSDATAHORA:TEXT,12 )

		cCodCli := oXml:_FormAnswers:_FormAnswer:_EXTERNALCLIENTEID:TEXT
		cCodCli := SubStr(cCodCli,1,Len(cCodCli)-4)
		cCodCli := StrZero( Val(cCodCli), TamSx3("A1_COD")[1],0 )

		cLjCli := oXml:_FormAnswers:_FormAnswer:_EXTERNALCLIENTEID:TEXT
		cLjCli := SubStr(cLjCli, Len(cLjCli)-3, Len(cLjCli) )

		// Quebra as respostas no array aResp
		aResp	:= oXml:_FormAnswers:_FormAnswer:_ItemAnswers:_ItemAnswer

		AADD( aDados, { "NUMEROOS"	,oXml:_FormAnswers:_FormAnswer:_NUMEROOS:TEXT } )					// Numero da OS
		AADD( aDados, { "AGENTE"	,AllTrim(oXml:_FormAnswers:_FormAnswer:_AGENTECODIGO:TEXT ) } )	// Codigo do agente
		AADD( aDados, { "CLIENTE"	,cCodCli } )														// cliente
		AADD( aDados, { "LOJA"		,cLjCli } )															// loja

		aHoraIni := oXml:_FormAnswers:_FormAnswer:_STATUSSEQUENCE:_STATUSINFO

		For nI := 1 to len(aHoraIni)
			If aHoraIni[nI]:_STATUS:TEXT == "INIC"
				cDataI := CtoD( SubStr( aHoraini[nI]:_DATAHORA:TEXT,1,10))
				cHoraI := SubStr( aHoraini[nI]:_DATAHORA:TEXT,12)
				exit
			EndIf
		Next nI

		AADD( aDados, { "DATAINI"   ,cDataI })
		AADD( aDados, { "HORAINI"   ,cHoraI })
		AADD( aDados, { "DATA"		,dData } )															// data
		AADD( aDados, { "HORA"		,cHora } )															// hora

		AADD( aDados, { "PATRIMONIO",aResp[1]:_ANSWER:TEXT})											// patrimonio

		For nI := 2 To Len(aResp)
			cResp := ''
			cCampo:= ''
			If XmlChildEx(aResp[nI]:_ANSWER,"_ALTERNATIVESCOMMENT") != NIL
				cResp := aResp[nI]:_ANSWER:_ALTERNATIVESCOMMENT:TEXT
				cCampo:= aResp[nI]:_ITEM:TEXT
				AADD( aDados, { upper(cCampo), cResp } )	// campos texto
			EndIf

		Next nI
	EndIf

Return(aDados)

/*


?
Programa  WSKPXFUN  Autor  Microsiga            Data   08/19/14   
?
Desc.       Itens dos botoes Ps dos patrimonios                       
                                                                      
?
Uso        AP                                                         
?


*/

Static Function ItenPs(cpos,cpatr,cDadosCnt)

	Local aArea	:=	GetArea()
	Local cQuery
	Local cRet	:=	''
	Local aRet	:=	{}
	Default cDadosCnt := ""

	cQuery := "SELECT 1 AS SEQ,N1_XP1 AS COD,B1_DESC,D1.DA1_XPRCPP AS VALOR"
	cQuery += " FROM "+RetSQLName("SN1")+" N1"
	cQuery += " LEFT JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=N1_XP1 AND B1.D_E_L_E_T_=''"
	cQuery += " LEFT JOIN "+RetSQLName("DA0")+" D0 ON DA0_FILIAL='"+xFilial("DA0")+"'"
	//se tiver troca de tabela ou o patrimonio ja tenha uma tabela amarrada
	If !Empty(cDadosCnt)
		cQuery += " AND DA0_CODTAB='"+cDadosCnt+"' AND D0.D_E_L_E_T_=''"
	Else
		cQuery += " AND DA0_XCLIEN=N1_XCLIENT AND D0.D_E_L_E_T_=''"
	EndIf

	cQuery += " LEFT JOIN "+RetSQLName("DA1")+" D1 ON DA1_FILIAL='"+xFilial("DA1")+"' AND DA1_CODTAB=DA0_CODTAB AND DA1_CODPRO=N1_XP1 AND D1.D_E_L_E_T_=''"
	cQuery += " WHERE N1_FILIAL='' AND N1_CHAPA='"+cpatr+"' AND N1.D_E_L_E_T_=''"
	//Alteracao para vir somente uma vez buscar os ps
	For nTr := 2 to 25
		cQuery += " UNION "+chr(13)+chr(10)
		cQuery += " SELECT "+cvaltochar(nTr)+" AS SEQ,N1_XP"+cvaltochar(nTr)+" AS COD,B1_DESC,D1.DA1_XPRCPP AS VALOR"+chr(13)+chr(10)
		cQuery += " FROM "+RetSQLName("SN1")+" N1"+chr(13)+chr(10)
		cQuery += " LEFT JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL='"+xFilial("SB1")+"' AND B1_COD=N1_XP"+cvaltochar(nTr)+" AND B1.D_E_L_E_T_=''"+chr(13)+chr(10)
		cQuery += " LEFT JOIN "+RetSQLName("DA0")+" D0 ON DA0_FILIAL='"+xFilial("DA0")+"'
		If !Empty(cDadosCnt)
			cQuery += " AND DA0_CODTAB='"+cDadosCnt+"' AND D0.D_E_L_E_T_=''"
		Else
			cQuery += " AND DA0_XCLIEN=N1_XCLIENT  AND D0.D_E_L_E_T_=''"
		EndIf
		cQuery += " AND D0.D_E_L_E_T_=''"+chr(13)+chr(10)
		cQuery += " LEFT JOIN "+RetSQLName("DA1")+" D1 ON DA1_FILIAL='"+xFilial("DA1")+"' AND DA1_CODTAB=DA0_CODTAB AND DA1_CODPRO=N1_XP"+cvaltochar(nTr)+" AND D1.D_E_L_E_T_=''"+chr(13)+chr(10)
		cQuery += " WHERE N1_FILIAL='' AND N1_CHAPA='"+cpatr+"' AND N1.D_E_L_E_T_=''" +chr(13)+chr(10)
	next nTr
	cQuery += " ORDER BY 1"

	If Select("TRB") > 0
		dbSelectArea("TRB")
		dbCloseArea()
	EndIf

	MemoWrite("TTATFC07.SQL",cQuery)

	cQuery:= ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)

	DbSelectArea("TRB")
	While !EOF()
		IF !Empty(TRB->COD)
			cRet := Alltrim(TRB->COD) + " - " + Alltrim(TRB->B1_DESC) + " R$ " + Transform(TRB->VALOR,"@R 999.99")
			If Ascan(aRet,{|x| Alltrim(cvaltochar(x[1])) == Alltrim(cvaltochar(TRB->SEQ))}) == 0
				Aadd(aRet,{TRB->SEQ,cRet})
			EndIf
		EndIf
		DbSkip()
	EndDo

	RestArea(aArea)

Return(aRet)

/*


?
Programa  WSKPF028  Autor  Alexandre Venancio   Data   11/11/14   
?
Desc.      Geracao do form de alteracao de sistema de pagamento.      
                                                                      
?
Uso        AP                                                         
?


*/

User Function WSKPF028(cNumChapa,cProblema)

	Local aArea	:=	GetArea()
	Local cXml	:=	''
	Default cProblema := ""

	// criacao dos campos de P's
	cXP := 		"<TextAnswer>"
	cXP += 			"<valuesdefinitions>"
	cXP += 				"<value>"
	cXP += 					"<id>1</id>"
	cXP += 					"<title>Informe o valor</title>"
	cXP += 					"<type>NUMBER</type>"
	cXP += 				"</value>"
	cXP += 			"</valuesdefinitions>"
	cXP += 			"<itemsdefinitions>"

	aAux := ItenPs('',cNumChapa)
	For nX := 1 to len(aAux)
		cXP +=	"<item>"
		cXP +=		"<id>P"+cvaltochar(aAux[nX,01])+"</id>"
		cXP +=		"<name>(P"+cvaltochar(aAux[nX,01])+") "+If(!Empty(aAux[nX,02]),aAux[nX,02],'Vazio')+"</name>"
		cXP +=		"<adtinfos>"
		cXP +=			"<ai>"
		cXP +=				"<vid>1</vid>"
		cXP +=				"<dfvl></dfvl>"
		cXP +=			"</ai>"
		cXP +=		"</adtinfos>"
		cXP +=	"</item>"
	Next nX

	cXP += 			"</itemsdefinitions>"
	cXP += 		"</TextAnswer>"

	cXml := "<?xml version='1.0' encoding='utf-8' ?>"
	cXml += "<DynFormAnswer>"

	cXml += 	"<ItemAnswer>"
	cXml += 		"<ItemID>67595</ItemID>"
	cXml += 		"<TextAnswer>"+cNumChapa+"</TextAnswer>"
	cXml += 	"</ItemAnswer>"
	cXml += 	"<ItemAnswer>"
	cXml += 		"<ItemID>67596</ItemID>"
	cXml += 		"<TextAnswer>"+cProblema+"</TextAnswer>"
	cXml += 	"</ItemAnswer>"

	cXml += 	"<ItemAnswer>"
	cXml += 		"<ItemID>87311</ItemID>"
	cXml +=			cXP
	cXml += 	"</ItemAnswer>"

	cXml += 	"<ItemAnswer>"
	cXml += 		"<ItemID>87312</ItemID>"
	cXml += 		cXP
	cXml += 	"</ItemAnswer>"

	cXml += 	"<ItemAnswer>"
	cXml += 		"<ItemID>87313</ItemID>"
	cXml += 		"<TextAnswer>Ok</TextAnswer>"
	cXml += 	"</ItemAnswer>"
	cXml += "</DynFormAnswer>"

	RestArea(aArea)

Return(cXml)

/*


?
Programa  WSKPF029  Autor  Alexandre Venancio   Data   11/11/14   
?
Desc.     Tratamento do retorno da OS de alteracao de sist. pagmento  
                                                                      
?
Uso        AP                                                         
?


*/

User Function WSKPF029(cResult,cMsgErro)

	Local aDados := {}
	Local cMsgTxt := ""
	Local cError := ""
	Local cWarning := ""
	Local aItens := {}
	Local oXml
	Local nI
	Local aAnswers := {}
	Local aCampos := { {"MANUTENCAO",		{"DEFEITO_CONSTATADO",;
	"CAUSA_PROVAVEL",;
	"SERVICO_EXECUTADO" }},;
	{"POS",				{"NSERIE_POS_ANT",;
	"NSERIE_POS_ATU" }},;
	{"PLACA_ANTERIOR",	{"TOTAL_SALES_PLACA_ANT",;
	"PARCIAL_PLACA_ANT",;
	"TOTAL_CASH_PLACA_ANT",;
	"TESTES_PLACA_ANT",;
	"CONTADORES_PLACA_ANT" }},;
	{"PLACA_ATUAL",		{"TOTAL_SALES_PLACA_ATU",;
	"PARCIAL_PLACA_ATU",;
	"TOTAL_CASH_PLACA_ATU",;
	"TESTES_PLACA_ATU",;
	"CONTADORES_PLACA_ATU" }},;
	{"MOEDEIRO",		{"NSERIE_MOED_ANT",;
	"NSERIE_MOED_ATU"}},;
	{"CEDULA",			{"NSERIE_CED_ANT",;
	"NSERIE_CED_ATU"}},;
	{"SMART",			{"NSERIE_SMART_ANT",;
	"NSERIE_SMART_ATU"}},;
	{"LACRE",			{"NSERIE_LAC_ANT",;
	"NSERIE_LAC_ATU" }}}

	Default cResult := ""

	If Empty(cResult)
		ConOut("# WSKPF029 - CADE O PARAMETRO? #")
		Return aDados
	EndIf

	oXml := XmlParser( cResult, "", @cError, @cWarning )
	If oXml == Nil
		cMsgTxt := "FALHA AO GERAR O OBJETO XML : " +cError+" / "+cWarning
		MsgStop(cMsgTxt)
		ConOut("# WSKPF029 ->" +cMsgTxt  +" #")
		cMsgErro += cMsgTxt
		Return aDados
	EndIf

	If XmlChildEx( oXml, "_FORMANSWERS" ) <> NIL
		If XmlChildEx( oXml:_FORMANSWERS, "_FORMANSWER" ) <> NIL
			If XmlChildEx( oXml:_FORMANSWERS:_FORMANSWER, "_NUMEROOS" ) <> NIL
				AADD( aDados, { "NUMEROOS", oXml:_FORMANSWERS:_FORMANSWER:_NUMEROOS:TEXT  } )
			EndIf

			If XmlChildEx( oXml:_FORMANSWERS:_FORMANSWER, "_AGENTECODIGO" ) <> NIL
				AADD( aDados, { "AGENTE", oXml:_FORMANSWERS:_FORMANSWER:_AGENTECODIGO:TEXT  } )
			EndIf

			If XmlChildEx( oXml:_FORMANSWERS:_FORMANSWER, "_EXTERNALCLIENTEID" ) <> NIL
				cCodCli := oXml:_FORMANSWERS:_FORMANSWER:_EXTERNALCLIENTEID:TEXT
				cCodCli := SubStr(cCodCli,1,Len(cCodCli)-4)
				cCodCli := StrZero( Val(cCodCli), TamSx3("A1_COD")[1],0 )

				cLjCli := oXml:_FORMANSWERS:_FORMANSWER:_EXTERNALCLIENTEID:TEXT
				cLjCli := SubStr(cLjCli, Len(cLjCli)-3, Len(cLjCli) )
				AADD( aDados, { "CLIENTE", cCodCli } )
				AADD( aDados, { "LOJA", cLjCli } )
			EndIf

			// sequencias atendimento
			If XmlChildEx( oXml:_FORMANSWERS:_FORMANSWER, "_STATUSSEQUENCE" ) <> NIL
				aHoraIni := oXml:_FormAnswers:_FormAnswer:_STATUSSEQUENCE:_STATUSINFO
				For nI := 1 to len(aHoraIni)
					If aHoraIni[nI]:_STATUS:TEXT == "INIC"
						cDataI := CtoD( SubStr( aHoraini[nI]:_DATAHORA:TEXT,1,10))
						cHoraI := SubStr( aHoraini[nI]:_DATAHORA:TEXT,12)
						AADD( aDados, { "DATAINI", CtoD( SubStr( aHoraini[nI]:_DATAHORA:TEXT,1,10)) } )
						AADD( aDados, { "HORAINI", SubStr( aHoraini[nI]:_DATAHORA:TEXT,12) } )
						Exit
					EndIf
				Next nI
			EndIf

			If XmlChildEx( oXml:_FORMANSWERS:_FORMANSWER, "_STATUSDATAHORA" ) <> NIL
				AADD( aDados, { "DATAFIM", CtoD( SubStr( oXml:_FormAnswers:_FormAnswer:_STATUSDATAHORA:TEXT,1,10 )) } )
				AADD( aDados, { "HORAFIM", SubStr( oXml:_FormAnswers:_FormAnswer:_STATUSDATAHORA:TEXT,12 ) } )
			EndIf

			If XmlChildEx( oXml:_FORMANSWERS:_FORMANSWER, "_ITEMANSWERS" ) <> NIL
				If XmlChildEx( oXml:_FORMANSWERS:_FORMANSWER:_ITEMANSWERS, "_ITEMANSWER" ) <> NIL
					aAnswers := oXml:_FORMANSWERS:_FORMANSWER:_ITEMANSWERS:_ITEMANSWER
					For nI := 1 To Len(aCampos)
						cTpAlt := aCampos[nI][1]
						AADD( aDados, {cTpAlt} )
						nPosFim := Len(aDados)
						For nJ := 1 To Len(aCampos[nI][2])
							For nK := 1 To Len(aAnswers)
								If Trim( UPPER(aAnswers[nK]:_ITEM:TEXT) ) == aCampos[nI][2][nJ]
									// item alternativa
									If XmlChildEx( aAnswers[nK]:_ANSWER, "_SELECTEDALTERNATIVE" ) <> Nil
										AADD( aDados[nPosFim], { upper(aAnswers[nK]:_ITEM:TEXT), upper(aAnswers[nK]:_ANSWER:_SELECTEDALTERNATIVE:TEXT) } )
									Else
										// item values
										If "CONTADORES" $ upper( aAnswers[nK]:_ITEM:TEXT )
											If XmlChildEx( aAnswers[nK]:_ANSWER, "_ITEMANSWER" ) <> NIL
												If ValType( aAnswers[nK]:_ANSWER:_ITEMANSWER ) == "O"
													XmlNode2Arr( aAnswers[nK]:_ANSWER:_ITEMANSWER, "_ITEMANSWER" )
												EndIf
												aContadores	:= aAnswers[nK]:_ANSWER:_ITEMANSWER
												For nL := 1 To Len(aContadores)
													AADD( aDados[nPosFim], { upper( aContadores[nL]:_ITEMID:TEXT ), upper(aContadores[nL]:_VALUE:TEXT) } )
												Next nL
											EndIf
											// campos comuns
										Else
											AADD( aDados[nPosFim], { upper( aAnswers[nK]:_ITEM:TEXT ), upper(aAnswers[nK]:_ANSWER:TEXT) } )
										EndIf
									EndIf
								EndIf
							Next nK
						Next nJ
					Next nI
				EndIf
			EndIf
		EndIf
	EndIf

Return aDados

/*


?
Programa  WSKPXFUN  Autor  Microsiga            Data   02/05/15   
?
Desc.      XML Formulario de instalacao de maquinas                   
                                                                      
?
Uso        AP                                                         
?


*/

User Function WSKPF030(aDados,nTpServ)

	Local aArea		:=	GetArea()
	Local cXml
	Local cQuery
	Local aDoses	:=	{}
	Local aAux		:=	{}
	Local nP		:=	1

	If nTpServ == 16
		cXML := "<?xml version='1.0' encoding='utf-8'?>"
		cXML += "<DynFormAnswer>"
		cXML += 	"<ItemAnswer>"
		If Upper(AllTrim(GetEnvServer())) == "JVVXC9_TESTE"
			cXML +=			"<ItemID>94159</ItemID>"            //Patrimonio
		Else
			cXML +=			"<ItemID>94442</ItemID>"
		EndIF

		cXml += 		"<TextAnswer>"+aDados[1]+"</TextAnswer>"
		cXml += 	"</ItemAnswer>"

		cXml +=		"<ItemAnswer>"
		If Upper(AllTrim(GetEnvServer())) == "JVVXC9_TESTE"
			cXml += 		"<ItemID>94158</ItemID>"    // OMM
		Else
			cXml += 		"<ItemID>94441</ItemID>"
		EndIf

		cXml +=			"<TextAnswer>"+aDados[2]+"</TextAnswer>"
		cXml += 	"</ItemAnswer>"

		cXml +=		"<ItemAnswer>"
		If Upper(AllTrim(GetEnvServer())) == "JVVXC9_TESTE"
			cXml += 		"<ItemID>94155</ItemID>"    // Tipo
		Else
			cXml += 		"<ItemID>94438</ItemID>"
		EndIf

		cXml +=			"<TextAnswer>"+cvaltochar(aDados[3])+"</TextAnswer>"
		cXml += 	"</ItemAnswer>"

		cXml +=		"<ItemAnswer>"

		If Upper(AllTrim(GetEnvServer())) == "JVVXC9_TESTE"
			cXml += 		"<ItemID>94156</ItemID>"    //  Local Fisico
		Else
			cXml += 		"<ItemID>94439</ItemID>"
		EndIf

		cXml +=			"<TextAnswer>"+aDados[4]+"</TextAnswer>"
		cXml += 	"</ItemAnswer>"

		cXml +=		"<ItemAnswer>"
		If Upper(AllTrim(GetEnvServer())) == "JVVXC9_TESTE"
			cXml += 		"<ItemID>94157</ItemID>"    // Tenso de Operao
		Else
			cXml += 		"<ItemID>94440</ItemID>"
		EndIf

		cXml +=			"<TextAnswer>"+aDados[5]+"</TextAnswer>"
		cXml += 	"</ItemAnswer>"

		cXml +=		"<ItemAnswer>"

		If Upper(AllTrim(GetEnvServer())) == "JVVXC9_TESTE"
			cXml += 		"<ItemID>94245</ItemID>"    // POS
		Else
			cXml += 		"<ItemID>98672</ItemID>"   //falta
		EndIf

		cXml +=			"<TextAnswer></TextAnswer>"
		cXml += 	"</ItemAnswer>"

		cXml +=		"<ItemAnswer>"

		If Upper(AllTrim(GetEnvServer())) == "JVVXC9_TESTE"
			cXml += 		"<ItemID>94160</ItemID>"    // Ps
		Else
			cXml += 		"<ItemID>94443</ItemID>"
		EndIf

		// criacao dos campos de P's
		cXml += 		"<TextAnswer>"
		cXml +=			"<valuesdefinitions>"
		cXml += 				"<value>"
		cXml += 					"<id>1</id>"
		cXml += 					"<title>Informe o valor</title>"
		cXml += 					"<type>NUMBER</type>"
		cXml += 				"</value>"
		cXml += 			"</valuesdefinitions>"
		cXml += 			"<itemsdefinitions>"

		cQuery := "SELECT ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), UD_XDOSES)),'') AS DOSE"
		cQuery += " FROM "+RetSQLName("SUD")
		cQuery += " WHERE UD_CODIGO='"+aDados[2]+"' AND UD_ITEM='"+aDados[7]+"'"

		If Select('TRB') > 0
			dbSelectArea('TRB')
			dbCloseArea()
		EndIf

		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)
		dbSelectArea("TRB")

		If !Empty(TRB->DOSE)
			aDoses := strtokarr(TRB->DOSE,"|")

			For nX := 1 to len(aDoses)
				If ";" $ aDoses[nX]
					aAux := strtokarr(aDoses[nX],";")
					cXml +=	"<item>"
					cXml +=		"<id>P"+cvaltochar(nP)+"</id>"

					If !Empty(aAux[1])
						cRet := Alltrim(aAux[1]) + " - " + Alltrim(Posicione("SB1",1,xFilial("SB1")+aAux[1],"B1_DESC")) + " R$ " + Transform(val(aAux[2]),"@R 999.99")
						cXml +=		"<name>(P"+cvaltochar(nP)+") "+cRet+"</name>"
					Else
						cXml +=		"<name>(P"+cvaltochar(nP)+") Vazio+</name>"
					EndIF
					cXml +=		"<adtinfos>"
					cXml +=			"<ai>"
					cXml +=				"<vid>1</vid>"
					cXml +=				"<dfvl></dfvl>"
					cXml +=			"</ai>"
					cXml +=		"</adtinfos>"
					cXml +=	"</item>"
					nP++
				EndIf
			Next nX
		Else
			aAux := ItenPs('',aDados[1])
			For nX := 1 to len(aAux)
				cXml += 		"<item>"
				cXml +=				"<id>P"+cvaltochar(aAux[nX,01])+"</id>"
				cXml +=				"<name>(P"+cvaltochar(aAux[nX,01])+") "+iF(!Empty(aAux[nX,02]),aAux[nX,02],'Vazio')+"</name>"
				cXml +=				"<adtinfos>"
				cXml +=					"<ai>"
				cXml +=						"<vid>1</vid>"
				cXml +=						"<dfvl></dfvl>"
				cXml +=					"</ai>"
				cXml +=				"</adtinfos>"
				cXml +=			"</item>"
			Next nX
		EndIf

		cXml += 			"</itemsdefinitions>"
		cXml += 		"</TextAnswer>"
		cXml += 	"</ItemAnswer>"
		cXml += "</DynFormAnswer>"
	Else
		cXML := "<?xml version='1.0' encoding='utf-8'?>"
		cXML += "<DynFormAnswer>"
		cXML += 	"<ItemAnswer>"
		If Upper(AllTrim(GetEnvServer())) == "JVVXC9_TESTE"
			cXML +=			"<ItemID>94227</ItemID>"            //Patrimonio
		Else
			cXML +=			"<ItemID>94448</ItemID>"
		EndIF

		cXml += 		"<TextAnswer>"+aDados[1]+"</TextAnswer>"
		cXml += 	"</ItemAnswer>"

		cXml +=		"<ItemAnswer>"
		If Upper(AllTrim(GetEnvServer())) == "JVVXC9_TESTE"
			cXml += 		"<ItemID>94226</ItemID>"    // OMM
		Else
			cXml += 		"<ItemID>94447</ItemID>"
		EndIf

		cXml +=			"<TextAnswer>"+aDados[2]+"</TextAnswer>"
		cXml += 	"</ItemAnswer>"

		cXml +=		"<ItemAnswer>"
		If Upper(AllTrim(GetEnvServer())) == "JVVXC9_TESTE"
			cXml += 		"<ItemID>94223</ItemID>"    // Tipo
		Else
			cXml += 		"<ItemID>94444</ItemID>"
		EndIf

		cXml +=			"<TextAnswer>"+cvaltochar(aDados[3])+"</TextAnswer>"
		cXml += 	"</ItemAnswer>"

		cXml +=		"<ItemAnswer>"

		If Upper(AllTrim(GetEnvServer())) == "JVVXC9_TESTE"
			cXml += 		"<ItemID>94224</ItemID>"    //  Local Fisico
		Else
			cXml += 		"<ItemID>94445</ItemID>"
		EndIf

		cXml +=			"<TextAnswer>"+aDados[4]+"</TextAnswer>"
		cXml += 	"</ItemAnswer>"

		cXml +=		"<ItemAnswer>"
		If Upper(AllTrim(GetEnvServer())) == "JVVXC9_TESTE"
			cXml += 		"<ItemID>94225</ItemID>"    // Tenso de Operao
		Else
			cXml += 		"<ItemID>94446</ItemID>"
		EndIf

		cXml +=			"<TextAnswer>"+aDados[5]+"</TextAnswer>"
		cXml += 	"</ItemAnswer>"

		cXml +=		"<ItemAnswer>"

		If Upper(AllTrim(GetEnvServer())) == "JVVXC9_TESTE"
			cXml += 		"<ItemID>94228</ItemID>"    // Ps
		Else
			cXml += 		"<ItemID>94449</ItemID>"
		EndIf

		// criacao dos campos de P's
		cXml += 		"<TextAnswer>"
		cXml +=			"<valuesdefinitions>"
		cXml += 				"<value>"
		cXml += 					"<id>1</id>"
		cXml += 					"<title>Informe o valor</title>"
		cXml += 					"<type>NUMBER</type>"
		cXml += 				"</value>"
		cXml += 			"</valuesdefinitions>"
		cXml += 			"<itemsdefinitions>"

		aAux := ItenPs('',aDados[1])
		For nX := 1 to len(aAux)
			cXml += 		"<item>"
			cXml +=				"<id>P"+cvaltochar(aAux[nX,01])+"</id>"
			cXml +=				"<name>(P"+cvaltochar(aAux[nX,01])+") "+iF(!Empty(aAux[nX,02]),aAux[nX,02],'Vazio')+"</name>"
			cXml +=				"<adtinfos>"
			cXml +=					"<ai>"
			cXml +=						"<vid>1</vid>"
			cXml +=						"<dfvl></dfvl>"
			cXml +=					"</ai>"
			cXml +=				"</adtinfos>"
			cXml +=			"</item>"
		Next nX

		cXml += 			"</itemsdefinitions>"
		cXml += 		"</TextAnswer>"
		cXml += 	"</ItemAnswer>"

		cXml += "</DynFormAnswer>"

	EndIf

	RestArea(aArea)

Return(cXml)

/*


?
Programa  WSKPXFUN  Autor  Microsiga            Data   02/11/15   
?
Desc.      Retorno formulario de Instalacao e Remocao                 
                                                                      
?
Uso        AP                                                         
?


*/

User Function WSKPF031(cResult,aAnswers,cMsgErro)

	Local oXML			:= NIL
	Local cError		:= ""
	Local cWarning		:= ""
	Local aDados		:= {}
	Local cCodCli		:= ""
	Local cLjCli		:= ""
	Local dDataIni
	Local cHoraIni
	Local dData
	Local cHora
	Local aResp			:= {}
	Local aSequencia	:= {}
	Local aItens
	Local aCampos		:= {}
	Local nI			:= 0
	Local nPos			:= 0
	Local aAux			:= {}

	If !Empty(cResult)
		oXml := XmlParser( cResult, "_", @cError, @cWarning )
		If oXml == Nil
			MsgStop("Falha ao gerar Objeto XML : "+cError+" / "+cWarning)
			Return aDados
		Endif
	EndIf

	If oXml <> Nil
		dData := CtoD( SubStr( oXml:_FormAnswers:_FormAnswer:_STATUSDATAHORA:TEXT,1,10 ) )
		cHora := SubStr( oXml:_FormAnswers:_FormAnswer:_STATUSDATAHORA:TEXT,12 )

		cCodCli := oXml:_FormAnswers:_FormAnswer:_EXTERNALCLIENTEID:TEXT
		cCodCli := SubStr(cCodCli,1,Len(cCodCli)-4)
		cCodCli := StrZero( Val(cCodCli), TamSx3("A1_COD")[1],0 )

		cLjCli := oXml:_FormAnswers:_FormAnswer:_EXTERNALCLIENTEID:TEXT
		cLjCli := SubStr(cLjCli, Len(cLjCli)-3, Len(cLjCli) )

		// sequencias de atualizacao de status
		aSequencia := oXml:_FormAnswers:_FormAnswer:_STATUSSEQUENCE:_STATUSINFO
		For nI := 1 To Len( aSequencia )
			If AllTrim(aSequencia[nI]:_STATUS:TEXT) == "INIC"
				dDataIni := CtoD( SubStr( aSequencia[nI]:_DATAHORA:TEXT,1,10 ) )
				cHoraIni := SubStr(aSequencia[nI]:_DATAHORA:TEXT,12 )
			EndIf
		Next nI

		AADD( aDados, { "NUMEROOS"	,oXml:_FormAnswers:_FormAnswer:_NUMEROOS:TEXT } )					// Numero da OS
		AADD( aDados, { "AGENTE"	,AllTrim(oXml:_FormAnswers:_FormAnswer:_AGENTECODIGO:TEXT ) } )	// Codigo do agente
		AADD( aDados, { "CLIENTE"	,cCodCli } )														// cliente
		AADD( aDados, { "LOJA"		,cLjCli } )															// loja
		AADD( aDados, { "DATAINI"		,dDataIni } )														// data ini
		AADD( aDados, { "HORAINI"		,cHoraIni } )														// hora ini
		AADD( aDados, { "DATAFIM"		,dData } )														// data fim
		AADD( aDados, { "HORAFIM"		,cHora } )														// hora fim

		// Quebra as respostas no array aResp
		aResp	:= oXml:_FormAnswers:_FormAnswer:_ItemAnswers:_ItemAnswer

		For nX := 1 to len(aResp)
			If XmlChildEx(aResp[nX],"_ANSWER") == NIL
				loop
			EndIf
			AADD( aDados, { upper(aResp[nX]:_ITEM:TEXT) 	,	upper(aResp[nX]:_ANSWER:TEXT) } )
			If XmlChildEx(aResp[nX]:_ANSWER,"_SELECTEDALTERNATIVE") != NIL
				aAux := aResp[nX]:_ANSWER:_SELECTEDALTERNATIVE
				If (Valtype(aAux) == "A" .And. len(aAux) == 1) .or. valtype(aAux) == "O" //(XmlChildEx(aAux,"TEXT") != NIL .And. valtype(aAux) == "O")
					AADD( aDados, { upper(aResp[nX]:_ITEM:TEXT) 	, upper(aAux:TEXT) })
				Else
					For nY := 1 to len(aAux)
						AADD( aDados, { upper(aResp[nX]:_ITEM:TEXT) 	, upper(aAux[nY]:TEXT) })
					Next nY
				EndIf
			ElseIf XmlChildEx(aResp[nX]:_ANSWER,"_ITEMANSWER") != NIL
				aAux := aResp[nX]:_ANSWER:_ITEMANSWER
				If (Valtype(aAux) == "A" .And. len(aAux) == 1) .or. valtype(aAux) == "O" //(XmlChildEx(aAux,"TEXT") != NIL .And. valtype(aAux) == "O")
					AADD( aDados, { upper(aResp[nX]:_ITEM:TEXT) 	, upper(aAux:TEXT) })
				Else
					For nY := 1 to len(aAux)
						AADD( aDados, { upper(aAux[nY]:_ITEMID:TEXT) 	, upper(aAux[nY]:_VALUE:TEXT) })
					Next nY
				EndIf
			EndIf
		Next nX
	EndIf

Return(aDados)

/*


?
Programa  WSKPXFUN  Autor  Microsiga            Data   05/26/15   
?
Desc.       Formulario de inventario XML                              
                                                                      
?
Uso        AP                                                         
?


*/

User Function WSKPF032(cCodPa,cCliente)

	Local aArea	:=	GetArea()
	Local cXML 	:=	''
	Local cQuery
	Local aItens:= {}

	cQuery := "SELECT B2_COD,B1_DESC,B2_QATU,B2_QEMPSA"
	cQuery += " FROM "+RetSQLName("SB2")+" B2"
	cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_COD=B2_COD AND B1.D_E_L_E_T_=''"
	cQuery += " WHERE B2_FILIAL='"+xFilial("SB2")+"' AND B2_LOCAL='"+cCodPA+"'"
	cQuery += " AND (B2_QATU>0 OR B2_QEMPSA>0)"
	cQuery += " AND B2.D_E_L_E_T_=''"

	If Select("TRB") > 0
		dbSelectArea("TRB")
		dbCloseArea()
	EndIf

	MemoWrite("TTPROC25.SQL",cQuery)

	cQuery:= ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)

	While !EOF()
		Aadd(aItens,{Alltrim(TRB->B2_COD),Alltrim(TRB->B1_DESC),TRB->B2_QATU,TRB->B2_QEMPSA})
		DbSkip()
	EndDo

	cXML := '<?xml version="1.0" encoding="utf-8"?>'
	cXML += "<DynFormAnswer>"
	cXML += 	"<ServiceOrderID>@ORDEMSERVICOID</ServiceOrderID>"

	// Cod do cliente
	cXML += 	"<ItemAnswer>"
	cXML += 		"<ItemID>94550</ItemID>"    //cliente
	cXML += 		"<TextAnswer>"+cCliente+"</TextAnswer>"
	cXML += 	"</ItemAnswer>"

	// Num Patrimonio
	cXML += 	"<ItemAnswer>"
	cXML += 		"<ItemID>94549</ItemID>"	       // patrimonio
	cXML += 		"<TextAnswer>"+cCodPA+"</TextAnswer>"
	cXML += 	"</ItemAnswer>"

	cXML += 	"<ItemAnswer>"
	cXML += 		"<ItemID>94551</ItemID>"	      //email
	cXML += 		"<TextAnswer>1</TextAnswer>"
	cXML += 	"</ItemAnswer>"

	// Itens
	cXML += 	"<ItemAnswer>"
	cXML += 		"<ItemID>94548</ItemID>"
	cXML += 		"<TextAnswer>"
	cXML += 			"<maxtries>3</maxtries>"
	cXML +=				"<comparetype>equal</comparetype>"

	For nX := 1 to len(aItens)
		cXML += 			"<itemquantitycheck>"
		cXML += 				"<itemid>"+aItens[nX,01]+"</itemid>"
		cXML += 				"<itemname>"+aItens[nX,01]+" - "+aItens[nX,02]+" </itemname>"
		cXML += 				"<qtd>"+cvaltochar(aItens[nX,3])+"</qtd>"
		cXML += 			"</itemquantitycheck>"
		cXML += 			"<itemquantitycheck>"
		cXML += 				"<itemid>D"+aItens[nX,01]+"</itemid>"
		cXML += 				"<itemname>Avaria/Descarte</itemname>"
		cXML += 				"<qtd>"+cvaltochar(aItens[nX,4])+"</qtd>"
		cXML += 			"</itemquantitycheck>"
	Next nX

	cXML +=				"<comparetype>equal</comparetype>"

	cXML += 		"</TextAnswer>"

	cXML += 	"</ItemAnswer>"
	cXML += "</DynFormAnswer>"

	RestArea(aAreA)

Return(cXML)
/*


?
Programa  fRetFil   Autor  Alexandre Venancio   Data   12/09/14   
?
Desc.      Retorna a filial da OS mobile                              
           Informar nRecno e cCodFil por referencia @                 
?
Uso        AP                                                         
?


*/

Static Function fRetFil(cNumOS,nRecno,cCodFil)

	Local cQuery := ""

	cQuery := "SELECT R_E_C_N_O_ REC, ZG_FILIAL FILIAL FROM " +RetSqlName("SZG") +" WHERE ZG_NUMOS = '"+cNumOS+"' AND D_E_L_E_T_ = '' "

	If Select("TRBG") > 0
		TRBG->(dbCloseArea())
	EndIf

	TcQuery cQuery New Alias "TRBG"
	dbSelectArea("TRBG")
	If !EOF()
		nRecno := TRBG->REC
		cCodFil := TRBG->FILIAL
	EndIf

	TRBG->(dbCloseArea())

Return

/*


?
Programa  WSKPXFUN  Autor  Microsiga            Data   12/09/15   
?
Desc.       Busca resultado das OSs geradas no dia.                  
                                                                      
?
Uso        AP                                                         
?


*/

User Function WSKPX003

	Local cEmp		:= "00"
	Local cFil		:= "  "
	Local cResWS	:= ""
	Local aDados	:= {}
	Local aDoc		:= {}
	Local cError	:= ''
	Local cWarning	:= ''
	Local oXml		:= Nil
	Local aResp		:= {}

	RpcSetType(3)
	RpcSetEnv(cEmp,cFil)

	AADD(aDados, "9A9878189C99C88EAB6C1BA705AF4291C637BC7F")
	AADD(aDados, "A426CDDD78E3AD21CBD3")

	cQuery := "SELECT Z6_NUMOS FROM "+RetSQLName("SZ6")
	cQuery += " WHERE (Z6_DATACRI='"+dtos(ddatabase)+"' AND Z6_DATAFIM='') AND Z6_TPFORM='4' AND D_E_L_E_T_=''" //OR (Z6_TPFORM='15' AND Z6_DATAFIM='')

	If Select('TRB') > 0
		dbSelectArea('TRB')
		dbCloseArea()
	EndIf

	MemoWrite("QFTCOM03.SQL",cQuery)
	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

	DbSelectArea("TRB")

	While !EOF()
		Aadd(adoc,VAL(TRB->Z6_NUMOS))
		Dbskip()
	EndDo

	AADD( aDados, ADOC )

	cResWS := U_WSKPX006(aDados)
	cResWS := U_WSKPF000(cResWS)

	U_WSKPF019(cResWS)

	/*If !Empty(cResWS)
	oXml := XmlParser( cResWS, "_", @cError, @cWarning )
	If (oXml == NIL )
	MsgStop("Falha ao gerar Objeto XML : "+cError+" / "+cWarning)
	Return aDados
	Endif

	aResp := oXml:_FORMANSWERS:_FORMANSWER

	For nX := 1 to len(aResp)
	If aResp[nX]:_STATUS:TEXT == "FIOK"
	cTipo := aResp[nX]:_EXTERNALTIPOSERVICOID:TEXT
	cOS	  := aResp[nX]:_NUMEROOS:TEXT
	U_QPWS01(cTipo,cOS,.T.)
	EndIf
	Next nX
	EndIf  */

Return

/*


?
Programa  WSKPXFUN  Autor  Microsiga            Data   12/09/15   
?
Desc.      Busca OSs alteradas nos ultimos 10 minutos.               
                                                                      
?
Uso        AP                                                         
?


*/

User Function WSKPX004()

	Local cEmp		:= "01"
	Local cFil		:= "01"
	Local cResWS	:= ""
	Local aDados	:= {}
	Local aDoc		:= {}
	Local cError	:= ''
	Local cWarning	:= ''
	Local oXml		:= Nil
	Local aResp		:= {}
	Local nTempo 	:= 2400	// tempo de refresh de atualizacao das OS - 2 minuto

	//RpcSetType(3)
	//RpcSetEnv(cEmp,cFil)

	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02' MODULO "TEC" //|TABLES "AB2"

	AADD(aDados, "E8F66610668732650F881EB61B9D7D52F6A38C5E")
	AADD(aDados, "BKQD9ES9JMELZUQKCYE7")

	AADD( aDados, '' )

	While .T.
	
		cResWS := U_WSKPX007(aDados,.F.)
		
		If 'WSCERR' $ cResWS
			//Return
			Sleep(nTempo)
			loop
		EndIf
		
		//| Transfoma a String no formato XML vlido.
		
		cResWS := U_WSKPF001(cResWS,.T.) 
		//|U_WSKPF019(cResWS)
		U_WSKPX009(cResWS)
		
		//Sleep(nTempo)
	EndDo
	
	RESET ENVIRONMENT

Return

/*


?
Programa  WSKPXFUN  Autor  Microsiga            Data   01/15/16   
?
Desc.       Busca relacao de todas as OS finalizadas no dia pelo      
          retaguarda do keeple.                                       
?
Uso        Nao esta funcionando legal a de 10 minutos WSKPX004        
?


*/

User Function WSKPX005

	Local cEmp		:= "01"
	Local cFil		:= "0201"
	Local cResWS	:= ""
	Local aDados	:= {}
	Local aDoc		:= {}
	Local cError	:= ''
	Local cWarning	:= ''
	Local oXml		:= Nil
	Local aResp		:= {}

	RpcSetType(3)
	RpcSetEnv(cEmp,cFil)

	AADD(aDados, "87CF4588965F21C2A6AE8DCBA683BAC41FD6C39B")
	AADD(aDados, "A426CDDD78E3AD21CBD3")

	AADD( aDados, 0 )  //Agente, quando manda null busca de todos

	//	2016-01-11T09:25:00
	cDtalt := substr(dtos(dDatabase),1,4)+'-'+substr(dtos(dDatabase),5,2)+'-'+substr(dtos(dDatabase),7,2)+'T'+cvaltochar(time())

	Aadd( aDados, cDtalt )
	//cResWS := U_WSKPX006(aDados)
	//cResWS := U_WSKPF000(cResWS)

	// Instancia a Classe (Client WebService gerado no DevStudio)
	oWS	:= WSKeepleFieldIntegration():New()

	// Mtodo -> GetAnswerFormByListOfOrdemNumeroOS
	If oWS:GetAllocatedOrdersByAgent(aDados[1],aDados[2],aDados[3],aDados[4],"S")
		// Sucesso
		cResult := oWs:cGetAnswerFormByListOfOrdemServicoNumeroOSResult
	Else
		cResult := GetWSCError()
		// Gera Log de Erro
	EndIf

	If !Empty(cResult) .And. !'CERR' $ cResult
		oXml := XmlParser( cResult, "_", @cError, @cWarning )
		If (oXml == NIL )
			MsgStop("Falha ao gerar Objeto XML : "+cError+" / "+cWarning)
			Return aDados
		Endif

		aResp := oXml:_FORMANSWERS:_FORMANSWER

		For nX := 1 to len(aResp)
			If aResp[nX]:_STATUS:TEXT == "FIOK"
				cTipo := aResp[nX]:_EXTERNALTIPOSERVICOID:TEXT
				cOS	  := aResp[nX]:_NUMEROOS:TEXT
				//U_QPWS01(cTipo,cOS,.T.)
			EndIf
		Next nX
	EndIf

Return

/*


?
Programa   WSKPX006 Autor  Alexandre Venancio   Data   04/08/15   
?
Desc.      Acessa WebService da Keeple para obter o resultado do      
           preenchimento dos formulrios nas Ordens de Servio.       
           Mtodo: GetAnswerFormByListOfOrdemNumeroOS.		          
?
Uso        Classificao do Documento de Entrada                      
?


*/

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
	Local cMetodo	:= "GetAnswerFormByListOfOrdemNumeroOS"
	Local cResult	:= ""
	Local nX
	Default aDados	:= {}

	// Verifica tamanho do Array
	If Len(aDados) == 0
		MsgAlert("No foram informados os parmetros necessrios!","WSKPX006")
		Return
	EndIf

	// Verifica parametro AuthCode
	If Alltrim(aDados[1]) == ""
		MsgAlert("Parmetro AuthCode invlido! " +CRLF +"Favor preencher.","WSKPX006")
		Return
	EndIf

	// Verifica parametro ClientCode
	If AllTrim(aDados[2]) == ""
		MsgAlert("Parmetro ClientCode invlido! " +CRLF +"Favor preencher.","WSKPX006")
		Return
	EndIf

	// Instancia Classe de montagem do Array de Int - 3 parametro
	oWSArray := KeepleFieldIntegration_ArrayOfInt():New()

	For nX := 1 To Len(aDados[3])
		AADD(oWSArray:nInt, aDados[3][nX])
	Next nX

	AADD(aDados, oWSArray)

	// Instancia a Classe (Client WebService gerado no DevStudio)
	oWS	:= WSKeepleFieldIntegration():New()

	// Mtodo -> GetAnswerFormByListOfOrdemNumeroOS
	If oWS:GetAnswerFormByListOfOrdemServicoNumeroOS(aDados[1],aDados[2],aDados[4])
		// Sucesso
		cResult := oWs:cGetAnswerFormByListOfOrdemServicoNumeroOSResult
	Else
		cResult := GetWSCError()
		// Gera Log de Erro
	EndIf

Return cResult

/*


?
Programa   WSKPX006 Autor  Alexandre Venancio   Data   04/08/15   
?
Desc.      Acessa WebService da Keeple para obter o resultado do      
           preenchimento dos formulrios nas Ordens de Servio.       
           Mtodo: GetAnswerFormByListOfOrdemNumeroOS.		          
?
Uso        Classificao do Documento de Entrada                      
?


*/

User Function WSKPX007(aDados,lRecham)

	/*------------------------------------------------------------------+
	|	Estrutura do Array que deve ser passado como parmetro			|
	|	aDados[x]														|
	|                                               					|
	|	Posicao			Campo							Tipo			|
	|-------------------------------------------------------------------+
	|	aDados[1]		authCode						-> String		|
	|	aDados[2]		clientCode						-> String		|
	|	aDados[3][x]]	numeroOSList					-> Array Int	|
	|																	|
	+------------------------------------------------------------------*/

	Local oWS		:= NIL	// Objeto do WebService
	Local oWSArray	:= NIL	// Objeto Array de Int
	Local cMetodo	:= "GetChangeStream"
	Local cResult	:= ""
	Local nX
	Local cCodSeq	:=	'' //If(!lRecham,GetMV("MV_ZZLSQOR"),'')
	Default aDados	:= {}

	// Verifica tamanho do Array
	If Len(aDados) == 0
		MsgAlert("No foram informados os parmetros necessrios!","WSKPX006")
		Return
	EndIf

	// Verifica parametro AuthCode
	If Alltrim(aDados[1]) == ""
		MsgAlert("Parmetro AuthCode invlido! " +CRLF +"Favor preencher.","WSKPX006")
		Return
	EndIf

	// Verifica parametro ClientCode
	If AllTrim(aDados[2]) == ""
		MsgAlert("Parmetro ClientCode invlido! " +CRLF +"Favor preencher.","WSKPX006")
		Return
	EndIf

	// Instancia Classe de montagem do Array de Int - 3 parametro
	oWSArray := KeepleFieldIntegration_ArrayOfInt():New()

	aDados[3] := cCodSeq
	// Instancia a Classe (Client WebService gerado no DevStudio)
	oWS	:= WSKeepleFieldIntegration():New()

	// Mtodo -> GetAnswerFormByListOfOrdemNumeroOS
	If oWS:GetChangeStream(aDados[1],aDados[2],aDados[3])
		// Sucesso
		cResult := oWs:cGetChangeStreamResult
	Else
		cResult := GetWSCError()
	EndIf

Return cResult

/*


?
Programa  WSKPXFUN  Autor  Microsiga            Data   12/22/15   
?
Desc.       Chamada para excluir OS no Keeple                         
                                                                      
?
Uso        AP                                                         
?


*/

User Function WSKPX008(aDados)

	/*------------------------------------------------------------------+
	|	Estrutura do Array que deve ser passado como parmetro			|
	|	aDados[x]														|
	|                                               					|
	|	Posicao			Campo							Tipo			|
	|-------------------------------------------------------------------+
	|	aDados[1]		authCode						-> String		|
	|	aDados[2]		clientCode						-> String		|
	|	aDados[3]		numeroOs						-> Int			|
	|	aDados[4]		ordemPrioridadeInsertPlace		-> Int			|
	|	aDados[5]		agenteCodigo					-> Int			|
	|	aDados[6]		dataHoraAgendamento				-> dateTime		|
	|	aDados[7]		status							-> String		|
	|	aDados[8]		notificaAgente					-> Boolean		|
	+------------------------------------------------------------------*/

	Local oWS		:= NIL	// Objeto do WebService
	Local oWSArray	:= NIL	// Objeto Array de Int
	Local cMetodo	:= "GetChangeStream"
	Local cResult	:= ""
	Local nX
	Local aDados	:=	{}

	AADD(aDados, "B0411009F0A1D76E593C0ECEA837B54406FE3309")
	AADD(aDados, "A426CDDD78E3AD21CBD3")

	AADD( aDados,3008)
	AADD( aDados, 0 )
	AADD( aDados, 4281 )
	AADD( aDados, '2015-12-18T08:00:00' )
	AADD( aDados, 'COPE' )
	AADD( aDados, .F. )

	// Verifica tamanho do Array
	If Len(aDados) == 0
		MsgAlert("No foram informados os parmetros necessrios!","WSKPX006")
		Return
	EndIf

	// Verifica parametro AuthCode
	If Alltrim(aDados[1]) == ""
		MsgAlert("Parmetro AuthCode invlido! " +CRLF +"Favor preencher.","WSKPX006")
		Return
	EndIf

	// Verifica parametro ClientCode
	If AllTrim(aDados[2]) == ""
		MsgAlert("Parmetro ClientCode invlido! " +CRLF +"Favor preencher.","WSKPX006")
		Return
	EndIf

	// Instancia Classe de montagem do Array de Int - 3 parametro
	oWSArray := KeepleFieldIntegration_ArrayOfInt():New()

	//aDados[3] := cCodSeq
	// Instancia a Classe (Client WebService gerado no DevStudio)
	oWS	:= WSKeepleFieldIntegration():New()

	// Mtodo -> GetAnswerFormByListOfOrdemNumeroOS
	//
	If oWS:SetAcompanhamentoOrdemServico(aDados[1],aDados[2],aDados[3],aDados[4],aDados[5],aDados[6],aDados[7],aDados[8])
		// Sucesso
		cResult := oWs:cDeactivateOrdemServicoByNumeroOsResult
	Else
		cResult := GetWSCError()
	EndIf

Return cResult

/*/{Protheus.doc} WSKPX009
Processamento e gravao do retorno das Ordems de servios
retornadas do Mobile.
@author Fabio Sales
@since 01/08/2017
@Param clResult , C, xml com as informaes das ordens de servio.
@version 1.0
/*/

User Function WSKPX009(cResult)

	Local aArea		:=	GetArea()
	Local aDados	:=	{}
	Local oXML		:= NIL
	Local cError	:= ""
	Local cWarning	:= ""
	Local aOSs		:= {}	
	Local cTipo 	:= ""
	Local cOS   	:= ""					
	Local cStatus	:= ""	
	Local cDescSt	:= ""				
	Local cData		:= ""
	Local clHora	:= ""
	Local cData		:= ""
	Local cHistSt	:= ""	
	Local alStatus := {}
	Local aAux		:=	{}
	Local aAuxItm	:=	{}	
	//| Carrega com os status para gravar a descrio na entidade.
	//|OBS: Caso tenha Novos status basta segui esssa mesma lgica.
		
	aadd(alStatus,{"DESP","Despachado"})
	aadd(alStatus,{"ACTE","Recebido pelo Agente"})
	aadd(alStatus,{"INIC","Iniciado"})
	aadd(alStatus,{"CTEC","Cancelado pelo Agente"})
	aadd(alStatus,{"COPE","Cancelado pelo Atendente"})
	aadd(alStatus,{"CCLI","Cancelado pelo cliente"})
	aadd(alStatus,{"FIOK","Finalizado OK"})
	aadd(alStatus,{"AGEN","Agendado"})
			
	//| Verifica se houve algum retorno, se Houver realiza o Parser do XML.

	If !Empty(cResult)
		oXml := XmlParser( cResult, "_", @cError, @cWarning )
		If oXml == Nil
			MsgStop("Falha ao gerar Objeto XML : "+cError+" / "+cWarning)
			Return()
		Endif
	Else
		Return
	EndIf

	//| valida se a Tag Principal possui contedo.
	
	If XmlChildEx(oXml,"_CHANGESTREAM") != Nil
		
		//| Verifica se a Tag Secundria possui contedo.
		
		If XmlChildEx(oXml:_CHANGESTREAM:_CHANGES,"_CHANGE") != Nil
			
			//| verifica se retornou mais de uma Ordem de servio. "O"= Apenas uma ordem de servio| "A"= Mais de uma Ordem de servio.
			
			If ValType(oXml:_CHANGESTREAM:_CHANGES:_CHANGE:_XML:_FORMANSWERS:_FORMANSWER) == "O"
				
				//| Converto o Objeto para Array para trabalhar com uma nica estrutura,
							
				XmlNode2Arr( oXml:_CHANGESTREAM:_CHANGES:_CHANGE:_XML:_FORMANSWERS:_FORMANSWER, "_FORMANSWER" )
																
			EndIf
			
			aOSs := oXml:_CHANGESTREAM:_CHANGES:_CHANGE:_XML:_FORMANSWERS:_FORMANSWER 

			If len(aOSs) > 0
								
				For nKy := 1 to len(aOSs)								
															
					cTipo 	:= Alltrim(aOSs[nKy]:_ExternalTipoServicoId:TEXT)
					cOS   	:= Alltrim(aOSs[nKy]:_NumeroOs:TEXT)					
					cStatus	:= Alltrim(aOSs[nKy]:_Status:TEXT)					
					cData	:= Alltrim(aOSs[nKy]:_StatusDataHora:TEXT)
					clHora	:= Right(cData,8)
					cData	:= Left(cData,10)	
					
					cDescSt	:= alStatus[Ascan(alStatus,{|x| x[1] == cStatus}),02] //| Obtm a descrio do status															
					
					DBSELECTAREA("SZG")
					SZG->(DBSETORDER(3)) //| ZG_NUMOS
					
					//| Verifica se a Ordem de servio J existe.
					
					IF SZG->(DBSEEK(cOS))
					
						//| Verifica se o ultimo status  diferente do ultimo j gravado.
						
						IF ALLTRIM(SZG->ZG_STATUS) <> AllTrim(cStatus)
							
							//| Monta String para gravaao do Histrico de status.
							
							cHistSt :="---------------------------" + CRLF
							cHistSt += "STATUS: "	+ cStatus + " - " + cDescSt + CRLF
							cHistSt += "DATA: " 	+ cData + CRLF
							cHistSt += "HORA: " 	+ clHora + CRLF						
							cHistSt +="---------------------------" + CRLF + CRLF													
							
							If cStatus == "FIOK"
								aAnsForm := aOSs[nKy]:_ITEMANSWERS  
								cHistSt += " ---------------- " +CRLF
								cHistSt += " ITENS APONTADOS NA OS " +CRLF
											
											
								For nTb := 1 to len(aAnsForm)
									If VALTYPE(XmlChildEx(aAnsForm[nTb],"_ITEMANSWER")) == "A" //NIL
										aAux := aAnsForm[nTb]:_ITEMANSWER 
										For nTs := 1 to len(aAux)
											cText 	:= aAux[nTs]:_ITEM:TEXT 
											If "_MATERIAL" $ cText
												cText := aAux[nTs]:_ANSWER:TEXT
												nTs++
											EndIf
											 
											cAnswer := aAux[nTs]:_ANSWER:TEXT
											cAnswer2:= ''
											If XmlChildEx(aAux[nTs]:_ANSWER,"_SELECTEDALTERNATIVE") != Nil 
												cAnswer2 := aAux[nTs]:_ANSWER:_SELECTEDALTERNATIVE:TEXT
											EndIf                           
											
											If !Empty(cAnswer)
												cHistSt += cText+CRLF
												cHistSt += cAnswer+CRLF
												cHistSt += cAnswer2+CRLF
												cHistSt += " ---------------- " +CRLF 
											EndIf
											Aadd(aAuxItm,{cText,cAnswer,cAnswer2})
										Next nTs
									EndIf	
								Next nTb
							EndIf       
							
							RECLOCK("SZG",.F.)
																				
								IF AllTrim(cStatus) == "FIOK" //| Status de finalizado.																													
									
									SZG->ZG_RESPOST := cResult
									SZG->ZG_DATAFIM	:= ctod(cData)
									SZG->ZG_HORAFIM := clHora
									
								ELSEIF AllTrim(cStatus) $ "CTEC|COPE|CCLI" //| CTEC= Canc. Pelo Agente| COPE=Canc. pelo Atendente| CCLI=Canc. pelo cliente.
								
									SZG->ZG_DTCANC	:= ctod(cData)
									SZG->ZG_HRCANC	:= clHora
									
								ELSEIF AllTrim(cStatus) == "INIC" //| INIC= Iniciado	
																										
									SZG->ZG_DATAINI	:= ctod(cData)
									SZG->ZG_HORAINI	:= clHora									
																
								ENDIF
								//gravar aqui tambem os itens preenchidos.
								SZG->ZG_HISTST	:= SZG->ZG_HISTST + cHistSt																										
								SZG->ZG_STATUS	:= cStatus
								SZG->ZG_STATUSD	:= cDescSt
							
							SZG->(MSUNLOCK()) 
								
							If len(aAuxItm) > 0
								
								nAgente := val(aOSs[nKy]:_AGENTECODIGO:TEXT)
								cCodCli	:= Strzero(VAL(aOSs[nKy]:_EXTERNALCLIENTEID:TEXT),8)
								
								For nX := 1 to len(aAuxItm)   
									If !Empty(aAuxItm[nX,02]) .And. val(substr(aAuxItm[nX,01],1,1)) > 0
										RecLock("SZH",.T.)
										SZH->ZH_FILIAL :=	xFilial("SZH")
										SZH->ZH_NUMOS  :=	cOS
										SZH->ZH_CODTEC :=	Posicione( "AA1",8, xFilial("AA1") +CVALTOCHAR(nAgente), "AA1_CODTEC" )
										//SZH->ZH_GERENT :=
										//SZH->ZH_CODDUP :=
										SZH->ZH_CODCLI := 	substr(cCodCli,1,6)
										SZH->ZH_LOJA   :=	substr(cCodCli,7,2)
										//SZH->ZH_SUBCLI :=
										SZH->ZH_DATFIM :=	ctod(cData)
										SZH->ZH_MATUTIL:=	aAuxItm[nX,01]
										SZH->ZH_QTDMATL:=	val(aAuxItm[nX,02])
										SZH->(Msunlock())
									EndIf
								Next nX
							EndIf						
																																	
						ENDIF
					Else    
						nAgente := val(aOSs[nKy]:_AGENTECODIGO:TEXT)
						nTpServ := VAL(aOSs[nKy]:_EXTERNALTIPOSERVICOID:TEXT)   
						cNomeAgente := cvaltochar(upper(aOSs[nKy]:_MOBILEAGENTNAME:TEXT)) 
						cStatus := Alltrim(aOSs[nKy]:_STATUS:TEXT)
						
						If cStatus == "FIOK"
							aAnsForm := aOSs[nKy]:_ITEMANSWERS  
							cHistSt += " ---------------- " +CRLF
							cHistSt += " ITENS APONTADOS NA OS " +CRLF
										
							If valtype(aAnsForm) == "A"			
								For nTb := 1 to len(aAnsForm)
									If VALTYPE(XmlChildEx(aAnsForm[nTb],"_ITEMANSWER")) == "A" //NIL
										aAux := aAnsForm[nTb]:_ITEMANSWER 
										For nTs := 1 to len(aAux)
											cText 	:= aAux[nTs]:_ITEM:TEXT 
											If "_MATERIAL" $ cText
												cText := aAux[nTs]:_ANSWER:TEXT
												nTs++
											EndIf
											 
											cAnswer := aAux[nTs]:_ANSWER:TEXT
											cAnswer2:= ''
											If XmlChildEx(aAux[nTs]:_ANSWER,"_SELECTEDALTERNATIVE") != Nil 
												cAnswer2 := aAux[nTs]:_ANSWER:_SELECTEDALTERNATIVE:TEXT
											EndIf                           
											
											If !Empty(cAnswer)
												cHistSt += cText+CRLF
												cHistSt += cAnswer+CRLF
												cHistSt += cAnswer2+CRLF
												cHistSt += " ---------------- " +CRLF 
											EndIf
											Aadd(aAuxItm,{cText,cAnswer,cAnswer2})
										Next nTs
									EndIf	
								Next nTb
							EndIf
						EndIf
						
						If ChkFile("SZG")
							If RecLock("SZG",.T.)
								SZG->ZG_FILIAL 	:= xFilial("SZG")
								SZG->ZG_NUMOS	:= cOS
								SZG->ZG_TPFORM 	:= nTpServ
								SZG->ZG_DESCCF	:= '' //cDescForm
								SZG->ZG_CODTEC	:= Posicione( "AA1",8, xFilial("AA1") +CVALTOCHAR(nAgente), "AA1_CODTEC" )
								SZG->ZG_AGENTE 	:= nAgente
								SZG->ZG_AGENTED	:= cNomeAgente
								SZG->ZG_DATAINI	:= CTOD(aOSs[nKy]:_DATASOLICITACAO:TEXT) //SOAPDTGETD(aDadosOS[21]) // agendamento
								SZG->ZG_HORAINI	:= TIME() //SOAPDTGETT(aDadosOS[26])	// agendamento
								/*SZG->ZG_DTCRIAC := Date()	// novo
								SZG->ZG_HRCRIAC := Time()	// novo
								SZG->ZG_CLIFOR	:= cCliFor
								SZG->ZG_LOJA 	:= cLoja
								SZG->ZG_PATRIM 	:= cNumChapa */
								SZG->ZG_STATUS	:= cStatus		// DESPACHADO
								//SZG->ZG_STATUSD := cDescStatus
								//SZG->ZG_ENVIO 	:= IF (TYPE("cXSoapCli")== "C",cXSoapCli,"")

								SZG->( MsUnLock() )

							EndIf
						EndIf 
						
						If len(aAuxItm) > 0
								
							nAgente := val(aOSs[nKy]:_AGENTECODIGO:TEXT)
							cCodCli	:= Strzero(VAL(aOSs[nKy]:_EXTERNALCLIENTEID:TEXT),8)
							
							For nX := 1 to len(aAuxItm)   
								If !Empty(aAuxItm[nX,02]) .And. val(substr(aAuxItm[nX,01],1,1)) > 0
									RecLock("SZH",.T.)
									SZH->ZH_FILIAL :=	xFilial("SZH")
									SZH->ZH_NUMOS  :=	cOS
									SZH->ZH_CODTEC :=	Posicione( "AA1",8, xFilial("AA1") +CVALTOCHAR(nAgente), "AA1_CODTEC" )
									//SZH->ZH_GERENT :=
									//SZH->ZH_CODDUP :=
									SZH->ZH_CODCLI := 	substr(cCodCli,1,6)
									SZH->ZH_LOJA   :=	substr(cCodCli,7,2)
									//SZH->ZH_SUBCLI :=
									SZH->ZH_DATFIM :=	ctod(cData)
									SZH->ZH_MATUTIL:=	aAuxItm[nX,01]
									SZH->ZH_QTDMATL:=	val(aAuxItm[nX,02])
									SZH->(Msunlock())
								EndIf
							Next nX
						EndIf
					ENDIF
					
					//| Limpa as variveiis.
					
					cTipo 	:= ""
					cOS   	:= ""					
					cStatus	:= ""					
					cData	:= ""
					clHora	:= ""
					cData	:= ""					
								
				Next nKy
									
			ENDIF
			
		Endif
		
	Endif	
	
	Freeobj(oXML)	//chamada feita

Return()

/*/{Protheus.doc} WSKPX009
Importao da tabela das LPUs
@author Fabio Sales
@since 01/03/2018
@Param clResult , C, xml com as informaes das ordens de servio.
@version 1.0
/*/

User Function WSKPX010(alDados)
	
	Local nI		:= 0
	Local nLendados	:= 0	
	Default alDados	:= {}
	
	nLendados :=  Len(alDados)
	
	IF  nLendados > 0
		
		FOR Ni := 1 tO  nLendados
			
			//| COLOCAR AQUI A LGICA DE IMPORTAO DOS PREOS DAS LPUs.
		
		NEXT
	
	ENDIF	

Return()
