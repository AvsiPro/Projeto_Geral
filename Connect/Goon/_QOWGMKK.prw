#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"

/* ===============================================================================
WSDL Location    http://ws.goon.mobi/webservices/keeplefieldintegration.asmx?WSDL
Gerado em        03/03/23 12:18:29
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _QOWGMKK ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSKeepleFieldIntegration
------------------------------------------------------------------------------- */

WSCLIENT WSKeepleFieldIntegration

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD GetClientWebserviceURL
	WSMETHOD SaveOrUpdateCliente
	WSMETHOD SaveOrUpdateClientContact
	WSMETHOD GetClientContactList
	WSMETHOD UpdateFormItemAnswer
	WSMETHOD UpdateFormItemAnswerByCode
	WSMETHOD SetClientContactExternalId
	WSMETHOD OpenOrdemServico
	WSMETHOD BulkOpenOrdemServico
	WSMETHOD OpenOrdemServicoWithClienteInfo
	WSMETHOD BulkOpenOrdemServicoWithClienteInfo
	WSMETHOD SetAcompanhamentoOrdemServico
	WSMETHOD SetAcompanhamentoOrdemServicoByNumeroOS
	WSMETHOD SendMessage
	WSMETHOD DeactivateOrdemServicoByExternalID
	WSMETHOD DeactivateOrdemServicoByNumeroOS
	WSMETHOD GetAcompanhamentoOrdemServico
	WSMETHOD GetAnswerFormByListOfOrdemServicoExternalID
	WSMETHOD GetAnswerFormByListOfOrdemServicoNumeroOS
	WSMETHOD GetAllocatedOrdersByAgentStrDate
	WSMETHOD GetServiceOrders
	WSMETHOD GetAllocatedOrdersByAgent
	WSMETHOD GetChangeStream
	WSMETHOD GetAgentRoute
	WSMETHOD GetAgentStatusList
	WSMETHOD SaveOrUpdateMobileAgent
	WSMETHOD SaveOrUpdateMobileAgentTeam
	WSMETHOD GetMobileAgentTeamList
	WSMETHOD GetMobileAgentList
	WSMETHOD SaveOrUpdateAttendant
	WSMETHOD GetAttendantList
	WSMETHOD GetClientList
	WSMETHOD GetClientListInternal
	WSMETHOD GetAllClients
	WSMETHOD GetAssetManagementList
	WSMETHOD GetAlertList
	WSMETHOD UpdateServiceOrderFlowState
	WSMETHOD UpdateMobileAgentClientPortfolio
	WSMETHOD SendEmailNotification
	WSMETHOD VerifyAccount

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cauthCode                 AS string
	WSDATA   cclientCode               AS string
	WSDATA   cGetClientWebserviceURLResult AS string
	WSDATA   nexternalID               AS int
	WSDATA   cmatricula                AS string
	WSDATA   cnome                     AS string
	WSDATA   cfisicaJuridica           AS string
	WSDATA   ccPFCNPJ                  AS string
	WSDATA   cclassificacao            AS string
	WSDATA   cendereco                 AS string
	WSDATA   cenderecoNumero           AS string
	WSDATA   cenderecoComplemento      AS string
	WSDATA   cenderecoBairro           AS string
	WSDATA   ccidade                   AS string
	WSDATA   cuF                       AS string
	WSDATA   ccEP                      AS string
	WSDATA   ctelefoneResidencial      AS string
	WSDATA   ctelefoneComercial        AS string
	WSDATA   ctelefoneCelular          AS string
	WSDATA   cemail                    AS string
	WSDATA   cobservacao               AS string
	WSDATA   ccontatoNome              AS string
	WSDATA   lclienteAtivo             AS boolean
	WSDATA   latendidoEmTodosTiposServicos AS boolean
	WSDATA   oWSmobileAgentCodeList    AS KeepleFieldIntegration_ArrayOfLong
	WSDATA   cmobileAgentCodeSource    AS string
	WSDATA   cadditionalDataXml        AS string
	WSDATA   ccontatoTelefone          AS string
	WSDATA   cadditionalContactsXml    AS string
	WSDATA   cexternalIdType           AS string
	WSDATA   cSaveOrUpdateClienteResult AS string
	WSDATA   nclientExternalID         AS int
	WSDATA   cname                     AS string
	WSDATA   cphoneNumber              AS string
	WSDATA   ccellNumber               AS string
	WSDATA   coccupancy                AS string
	WSDATA   cSaveOrUpdateClientContactResult AS string
	WSDATA   oWSexternalClientIdList   AS KeepleFieldIntegration_ArrayOfInt
	WSDATA   lisToFetchOnlyContactsWithExternalIdNull AS boolean
	WSDATA   cGetClientContactListResult AS string
	WSDATA   nformItemAnswerId         AS int
	WSDATA   canswer                   AS string
	WSDATA   cUpdateFormItemAnswerResult AS string
	WSDATA   cformItemAnswerCode       AS string
	WSDATA   cUpdateFormItemAnswerByCodeResult AS string
	WSDATA   nexternalClientId         AS int
	WSDATA   cSetClientContactExternalIdResult AS string
	WSDATA   nexternalClienteID        AS int
	WSDATA   nexternalTipoServicoID    AS int
	WSDATA   nexternalAtendenteID      AS int
	WSDATA   cdataSolicitacao          AS dateTime
	WSDATA   cprioridade               AS string
	WSDATA   cdescricao                AS string
	WSDATA   nlatitude                 AS double
	WSDATA   nlongitude                AS double
	WSDATA   cdataCriacao              AS dateTime
	WSDATA   cenderecoReferencia       AS string
	WSDATA   nnumeroOS                 AS int
	WSDATA   cdynFormCreateFormXML     AS string
	WSDATA   nagenteCodigo             AS int
	WSDATA   cdataHoraAgendamento      AS dateTime
	WSDATA   cresponsibleMobileAgentAssignType AS string
	WSDATA   cOpenOrdemServicoResult   AS string
	WSDATA   cxml                      AS string
	WSDATA   cBulkOpenOrdemServicoResult AS string
	WSDATA   cclienteMatricula         AS string
	WSDATA   cclienteNome              AS string
	WSDATA   cclienteFisicaJuridica    AS string
	WSDATA   cclienteCPFCNPJ           AS string
	WSDATA   cclienteClassificacao     AS string
	WSDATA   cclienteEndereco          AS string
	WSDATA   cclienteEnderecoNumero    AS string
	WSDATA   cclienteEnderecoComplemento AS string
	WSDATA   cclienteEnderecoBairro    AS string
	WSDATA   cclienteCidade            AS string
	WSDATA   cclienteUF                AS string
	WSDATA   cclienteCEP               AS string
	WSDATA   cclienteTelefoneResidencial AS string
	WSDATA   cclienteTelefoneComercial AS string
	WSDATA   cclienteTelefoneCelular   AS string
	WSDATA   cclienteEmail             AS string
	WSDATA   cclienteObservacao        AS string
	WSDATA   lclienteAtendidoEmTodosTiposServicos AS boolean
	WSDATA   cOpenOrdemServicoWithClienteInfoResult AS string
	WSDATA   cBulkOpenOrdemServicoWithClienteInfoResult AS string
	WSDATA   nexternalOrdemServicoID   AS int
	WSDATA   nordemPrioridadeInsertPlace AS int
	WSDATA   cstatus                   AS string
	WSDATA   lnotificaAgente           AS boolean
	WSDATA   ldataHoraAgendamentoFlexivel AS boolean
	WSDATA   cSetAcompanhamentoOrdemServicoResult AS string
	WSDATA   cSetAcompanhamentoOrdemServicoByNumeroOSResult AS string
	WSDATA   cmessage                  AS string
	WSDATA   cSendMessageResult        AS string
	WSDATA   cDeactivateOrdemServicoByExternalIDResult AS string
	WSDATA   cDeactivateOrdemServicoByNumeroOSResult AS string
	WSDATA   cGetAcompanhamentoOrdemServicoResult AS string
	WSDATA   oWSexternalIDList         AS KeepleFieldIntegration_ArrayOfInt
	WSDATA   cGetAnswerFormByListOfOrdemServicoExternalIDResult AS string
	WSDATA   oWSnumeroOSList           AS KeepleFieldIntegration_ArrayOfInt
	WSDATA   cGetAnswerFormByListOfOrdemServicoNumeroOSResult AS string
	WSDATA   cdataFinalizacaoCancelamento AS string
	WSDATA   ctipoData                 AS string
	WSDATA   cflowStateTag             AS string
	WSDATA   cGetAllocatedOrdersByAgentStrDateResult AS string
	WSDATA   cdataInicio               AS dateTime
	WSDATA   cdataFim                  AS dateTime
	WSDATA   nversionNumber            AS int
	WSDATA   nserviceTypeExternalId    AS int
	WSDATA   cGetServiceOrdersResult   AS string
	WSDATA   ldataFixa                 AS boolean
	WSDATA   ldataFlexivel             AS boolean
	WSDATA   cGetAllocatedOrdersByAgentResult AS string
	WSDATA   clastSequenceCode         AS string
	WSDATA   cGetChangeStreamResult    AS string
	WSDATA   cdata                     AS dateTime
	WSDATA   cGetAgentRouteResult      AS string
	WSDATA   cGetAgentStatusListResult AS string
	WSDATA   nagentCode                AS int
	WSDATA   nexternalAgentId          AS int
	WSDATA   lservesAllClients         AS boolean
	WSDATA   lservesAllServiceTypes    AS boolean
	WSDATA   lisToUpdateMobileAgentTeam AS boolean
	WSDATA   nmobileAgentTeamExternalId AS int
	WSDATA   cstartMonitoringTime      AS string
	WSDATA   cfinishMonitoringTime     AS string
	WSDATA   caddess                   AS string
	WSDATA   caddressNumber            AS string
	WSDATA   caddressComplement        AS string
	WSDATA   caddressNeighborhood      AS string
	WSDATA   caddressCity              AS string
	WSDATA   caddressState             AS string
	WSDATA   caddressZipcode           AS string
	WSDATA   cSaveOrUpdateMobileAgentResult AS string
	WSDATA   lisMessagingAvailable     AS boolean
	WSDATA   cSaveOrUpdateMobileAgentTeamResult AS string
	WSDATA   cGetMobileAgentTeamListResult AS string
	WSDATA   oWSmobileAgentExternalIdList AS KeepleFieldIntegration_ArrayOfLong
	WSDATA   cGetMobileAgentListResult AS string
	WSDATA   lisToSendEmailWithCredentials AS boolean
	WSDATA   lmanagesAllMobileAgents   AS boolean
	WSDATA   oWSmanagedMobileAgentExternalIdList AS KeepleFieldIntegration_ArrayOfLong
	WSDATA   lisToUpdateProfile        AS boolean
	WSDATA   cprofileName              AS string
	WSDATA   cSaveOrUpdateAttendantResult AS string
	WSDATA   oWSattendantExternalIdList AS KeepleFieldIntegration_ArrayOfInt
	WSDATA   cGetAttendantListResult   AS string
	WSDATA   oWSclientExternalIdList   AS KeepleFieldIntegration_ArrayOfInt
	WSDATA   lisToFetchOnlyClientsWithExternalIdNull AS boolean
	WSDATA   cGetClientListResult      AS string
	WSDATA   oWSlocationEntityIdList   AS KeepleFieldIntegration_ArrayOfInt
	WSDATA   cGetClientListInternalResult AS string
	WSDATA   cGetAllClientsResult      AS string
	WSDATA   cupdatedDateTime          AS dateTime
	WSDATA   cGetAssetManagementListResult AS string
	WSDATA   cGetAlertListResult       AS string
	WSDATA   cuserID                   AS string
	WSDATA   cserviceOrderInfo         AS string
	WSDATA   cUpdateServiceOrderFlowStateResult AS string
	WSDATA   oWSclientExternalIdListToAdd AS KeepleFieldIntegration_ArrayOfInt
	WSDATA   oWSclientExternalIdListToRemove AS KeepleFieldIntegration_ArrayOfInt
	WSDATA   cUpdateMobileAgentClientPortfolioResult AS string
	WSDATA   oWSserviceIdList          AS KeepleFieldIntegration_ArrayOfInt
	WSDATA   cSendEmailNotificationResult AS string
	WSDATA   oWSaccountIdList          AS KeepleFieldIntegration_ArrayOfInt
	WSDATA   cVerifyAccountResult      AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSKeepleFieldIntegration
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20180425 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSKeepleFieldIntegration
	::oWSmobileAgentCodeList := KeepleFieldIntegration_ARRAYOFLONG():New()
	::oWSexternalClientIdList := KeepleFieldIntegration_ARRAYOFINT():New()
	::oWSexternalIDList  := KeepleFieldIntegration_ARRAYOFINT():New()
	::oWSnumeroOSList    := KeepleFieldIntegration_ARRAYOFINT():New()
	::oWSmobileAgentExternalIdList := KeepleFieldIntegration_ARRAYOFLONG():New()
	::oWSmanagedMobileAgentExternalIdList := KeepleFieldIntegration_ARRAYOFLONG():New()
	::oWSattendantExternalIdList := KeepleFieldIntegration_ARRAYOFINT():New()
	::oWSclientExternalIdList := KeepleFieldIntegration_ARRAYOFINT():New()
	::oWSlocationEntityIdList := KeepleFieldIntegration_ARRAYOFINT():New()
	::oWSclientExternalIdListToAdd := KeepleFieldIntegration_ARRAYOFINT():New()
	::oWSclientExternalIdListToRemove := KeepleFieldIntegration_ARRAYOFINT():New()
	::oWSserviceIdList   := KeepleFieldIntegration_ARRAYOFINT():New()
	::oWSaccountIdList   := KeepleFieldIntegration_ARRAYOFINT():New()
Return

WSMETHOD RESET WSCLIENT WSKeepleFieldIntegration
	::cauthCode          := NIL 
	::cclientCode        := NIL 
	::cGetClientWebserviceURLResult := NIL 
	::nexternalID        := NIL 
	::cmatricula         := NIL 
	::cnome              := NIL 
	::cfisicaJuridica    := NIL 
	::ccPFCNPJ           := NIL 
	::cclassificacao     := NIL 
	::cendereco          := NIL 
	::cenderecoNumero    := NIL 
	::cenderecoComplemento := NIL 
	::cenderecoBairro    := NIL 
	::ccidade            := NIL 
	::cuF                := NIL 
	::ccEP               := NIL 
	::ctelefoneResidencial := NIL 
	::ctelefoneComercial := NIL 
	::ctelefoneCelular   := NIL 
	::cemail             := NIL 
	::cobservacao        := NIL 
	::ccontatoNome       := NIL 
	::lclienteAtivo      := NIL 
	::latendidoEmTodosTiposServicos := NIL 
	::oWSmobileAgentCodeList := NIL 
	::cmobileAgentCodeSource := NIL 
	::cadditionalDataXml := NIL 
	::ccontatoTelefone   := NIL 
	::cadditionalContactsXml := NIL 
	::cexternalIdType    := NIL 
	::cSaveOrUpdateClienteResult := NIL 
	::nclientExternalID  := NIL 
	::cname              := NIL 
	::cphoneNumber       := NIL 
	::ccellNumber        := NIL 
	::coccupancy         := NIL 
	::cSaveOrUpdateClientContactResult := NIL 
	::oWSexternalClientIdList := NIL 
	::lisToFetchOnlyContactsWithExternalIdNull := NIL 
	::cGetClientContactListResult := NIL 
	::nformItemAnswerId  := NIL 
	::canswer            := NIL 
	::cUpdateFormItemAnswerResult := NIL 
	::cformItemAnswerCode := NIL 
	::cUpdateFormItemAnswerByCodeResult := NIL 
	::nexternalClientId  := NIL 
	::cSetClientContactExternalIdResult := NIL 
	::nexternalClienteID := NIL 
	::nexternalTipoServicoID := NIL 
	::nexternalAtendenteID := NIL 
	::cdataSolicitacao   := NIL 
	::cprioridade        := NIL 
	::cdescricao         := NIL 
	::nlatitude          := NIL 
	::nlongitude         := NIL 
	::cdataCriacao       := NIL 
	::cenderecoReferencia := NIL 
	::nnumeroOS          := NIL 
	::cdynFormCreateFormXML := NIL 
	::nagenteCodigo      := NIL 
	::cdataHoraAgendamento := NIL 
	::cresponsibleMobileAgentAssignType := NIL 
	::cOpenOrdemServicoResult := NIL 
	::cxml               := NIL 
	::cBulkOpenOrdemServicoResult := NIL 
	::cclienteMatricula  := NIL 
	::cclienteNome       := NIL 
	::cclienteFisicaJuridica := NIL 
	::cclienteCPFCNPJ    := NIL 
	::cclienteClassificacao := NIL 
	::cclienteEndereco   := NIL 
	::cclienteEnderecoNumero := NIL 
	::cclienteEnderecoComplemento := NIL 
	::cclienteEnderecoBairro := NIL 
	::cclienteCidade     := NIL 
	::cclienteUF         := NIL 
	::cclienteCEP        := NIL 
	::cclienteTelefoneResidencial := NIL 
	::cclienteTelefoneComercial := NIL 
	::cclienteTelefoneCelular := NIL 
	::cclienteEmail      := NIL 
	::cclienteObservacao := NIL 
	::lclienteAtendidoEmTodosTiposServicos := NIL 
	::cOpenOrdemServicoWithClienteInfoResult := NIL 
	::cBulkOpenOrdemServicoWithClienteInfoResult := NIL 
	::nexternalOrdemServicoID := NIL 
	::nordemPrioridadeInsertPlace := NIL 
	::cstatus            := NIL 
	::lnotificaAgente    := NIL 
	::ldataHoraAgendamentoFlexivel := NIL 
	::cSetAcompanhamentoOrdemServicoResult := NIL 
	::cSetAcompanhamentoOrdemServicoByNumeroOSResult := NIL 
	::cmessage           := NIL 
	::cSendMessageResult := NIL 
	::cDeactivateOrdemServicoByExternalIDResult := NIL 
	::cDeactivateOrdemServicoByNumeroOSResult := NIL 
	::cGetAcompanhamentoOrdemServicoResult := NIL 
	::oWSexternalIDList  := NIL 
	::cGetAnswerFormByListOfOrdemServicoExternalIDResult := NIL 
	::oWSnumeroOSList    := NIL 
	::cGetAnswerFormByListOfOrdemServicoNumeroOSResult := NIL 
	::cdataFinalizacaoCancelamento := NIL 
	::ctipoData          := NIL 
	::cflowStateTag      := NIL 
	::cGetAllocatedOrdersByAgentStrDateResult := NIL 
	::cdataInicio        := NIL 
	::cdataFim           := NIL 
	::nversionNumber     := NIL 
	::nserviceTypeExternalId := NIL 
	::cGetServiceOrdersResult := NIL 
	::ldataFixa          := NIL 
	::ldataFlexivel      := NIL 
	::cGetAllocatedOrdersByAgentResult := NIL 
	::clastSequenceCode  := NIL 
	::cGetChangeStreamResult := NIL 
	::cdata              := NIL 
	::cGetAgentRouteResult := NIL 
	::cGetAgentStatusListResult := NIL 
	::nagentCode         := NIL 
	::nexternalAgentId   := NIL 
	::lservesAllClients  := NIL 
	::lservesAllServiceTypes := NIL 
	::lisToUpdateMobileAgentTeam := NIL 
	::nmobileAgentTeamExternalId := NIL 
	::cstartMonitoringTime := NIL 
	::cfinishMonitoringTime := NIL 
	::caddess            := NIL 
	::caddressNumber     := NIL 
	::caddressComplement := NIL 
	::caddressNeighborhood := NIL 
	::caddressCity       := NIL 
	::caddressState      := NIL 
	::caddressZipcode    := NIL 
	::cSaveOrUpdateMobileAgentResult := NIL 
	::lisMessagingAvailable := NIL 
	::cSaveOrUpdateMobileAgentTeamResult := NIL 
	::cGetMobileAgentTeamListResult := NIL 
	::oWSmobileAgentExternalIdList := NIL 
	::cGetMobileAgentListResult := NIL 
	::lisToSendEmailWithCredentials := NIL 
	::lmanagesAllMobileAgents := NIL 
	::oWSmanagedMobileAgentExternalIdList := NIL 
	::lisToUpdateProfile := NIL 
	::cprofileName       := NIL 
	::cSaveOrUpdateAttendantResult := NIL 
	::oWSattendantExternalIdList := NIL 
	::cGetAttendantListResult := NIL 
	::oWSclientExternalIdList := NIL 
	::lisToFetchOnlyClientsWithExternalIdNull := NIL 
	::cGetClientListResult := NIL 
	::oWSlocationEntityIdList := NIL 
	::cGetClientListInternalResult := NIL 
	::cGetAllClientsResult := NIL 
	::cupdatedDateTime   := NIL 
	::cGetAssetManagementListResult := NIL 
	::cGetAlertListResult := NIL 
	::cuserID            := NIL 
	::cserviceOrderInfo  := NIL 
	::cUpdateServiceOrderFlowStateResult := NIL 
	::oWSclientExternalIdListToAdd := NIL 
	::oWSclientExternalIdListToRemove := NIL 
	::cUpdateMobileAgentClientPortfolioResult := NIL 
	::oWSserviceIdList   := NIL 
	::cSendEmailNotificationResult := NIL 
	::oWSaccountIdList   := NIL 
	::cVerifyAccountResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSKeepleFieldIntegration
Local oClone := WSKeepleFieldIntegration():New()
	oClone:_URL          := ::_URL 
	oClone:cauthCode     := ::cauthCode
	oClone:cclientCode   := ::cclientCode
	oClone:cGetClientWebserviceURLResult := ::cGetClientWebserviceURLResult
	oClone:nexternalID   := ::nexternalID
	oClone:cmatricula    := ::cmatricula
	oClone:cnome         := ::cnome
	oClone:cfisicaJuridica := ::cfisicaJuridica
	oClone:ccPFCNPJ      := ::ccPFCNPJ
	oClone:cclassificacao := ::cclassificacao
	oClone:cendereco     := ::cendereco
	oClone:cenderecoNumero := ::cenderecoNumero
	oClone:cenderecoComplemento := ::cenderecoComplemento
	oClone:cenderecoBairro := ::cenderecoBairro
	oClone:ccidade       := ::ccidade
	oClone:cuF           := ::cuF
	oClone:ccEP          := ::ccEP
	oClone:ctelefoneResidencial := ::ctelefoneResidencial
	oClone:ctelefoneComercial := ::ctelefoneComercial
	oClone:ctelefoneCelular := ::ctelefoneCelular
	oClone:cemail        := ::cemail
	oClone:cobservacao   := ::cobservacao
	oClone:ccontatoNome  := ::ccontatoNome
	oClone:lclienteAtivo := ::lclienteAtivo
	oClone:latendidoEmTodosTiposServicos := ::latendidoEmTodosTiposServicos
	oClone:oWSmobileAgentCodeList :=  IIF(::oWSmobileAgentCodeList = NIL , NIL ,::oWSmobileAgentCodeList:Clone() )
	oClone:cmobileAgentCodeSource := ::cmobileAgentCodeSource
	oClone:cadditionalDataXml := ::cadditionalDataXml
	oClone:ccontatoTelefone := ::ccontatoTelefone
	oClone:cadditionalContactsXml := ::cadditionalContactsXml
	oClone:cexternalIdType := ::cexternalIdType
	oClone:cSaveOrUpdateClienteResult := ::cSaveOrUpdateClienteResult
	oClone:nclientExternalID := ::nclientExternalID
	oClone:cname         := ::cname
	oClone:cphoneNumber  := ::cphoneNumber
	oClone:ccellNumber   := ::ccellNumber
	oClone:coccupancy    := ::coccupancy
	oClone:cSaveOrUpdateClientContactResult := ::cSaveOrUpdateClientContactResult
	oClone:oWSexternalClientIdList :=  IIF(::oWSexternalClientIdList = NIL , NIL ,::oWSexternalClientIdList:Clone() )
	oClone:lisToFetchOnlyContactsWithExternalIdNull := ::lisToFetchOnlyContactsWithExternalIdNull
	oClone:cGetClientContactListResult := ::cGetClientContactListResult
	oClone:nformItemAnswerId := ::nformItemAnswerId
	oClone:canswer       := ::canswer
	oClone:cUpdateFormItemAnswerResult := ::cUpdateFormItemAnswerResult
	oClone:cformItemAnswerCode := ::cformItemAnswerCode
	oClone:cUpdateFormItemAnswerByCodeResult := ::cUpdateFormItemAnswerByCodeResult
	oClone:nexternalClientId := ::nexternalClientId
	oClone:cSetClientContactExternalIdResult := ::cSetClientContactExternalIdResult
	oClone:nexternalClienteID := ::nexternalClienteID
	oClone:nexternalTipoServicoID := ::nexternalTipoServicoID
	oClone:nexternalAtendenteID := ::nexternalAtendenteID
	oClone:cdataSolicitacao := ::cdataSolicitacao
	oClone:cprioridade   := ::cprioridade
	oClone:cdescricao    := ::cdescricao
	oClone:nlatitude     := ::nlatitude
	oClone:nlongitude    := ::nlongitude
	oClone:cdataCriacao  := ::cdataCriacao
	oClone:cenderecoReferencia := ::cenderecoReferencia
	oClone:nnumeroOS     := ::nnumeroOS
	oClone:cdynFormCreateFormXML := ::cdynFormCreateFormXML
	oClone:nagenteCodigo := ::nagenteCodigo
	oClone:cdataHoraAgendamento := ::cdataHoraAgendamento
	oClone:cresponsibleMobileAgentAssignType := ::cresponsibleMobileAgentAssignType
	oClone:cOpenOrdemServicoResult := ::cOpenOrdemServicoResult
	oClone:cxml          := ::cxml
	oClone:cBulkOpenOrdemServicoResult := ::cBulkOpenOrdemServicoResult
	oClone:cclienteMatricula := ::cclienteMatricula
	oClone:cclienteNome  := ::cclienteNome
	oClone:cclienteFisicaJuridica := ::cclienteFisicaJuridica
	oClone:cclienteCPFCNPJ := ::cclienteCPFCNPJ
	oClone:cclienteClassificacao := ::cclienteClassificacao
	oClone:cclienteEndereco := ::cclienteEndereco
	oClone:cclienteEnderecoNumero := ::cclienteEnderecoNumero
	oClone:cclienteEnderecoComplemento := ::cclienteEnderecoComplemento
	oClone:cclienteEnderecoBairro := ::cclienteEnderecoBairro
	oClone:cclienteCidade := ::cclienteCidade
	oClone:cclienteUF    := ::cclienteUF
	oClone:cclienteCEP   := ::cclienteCEP
	oClone:cclienteTelefoneResidencial := ::cclienteTelefoneResidencial
	oClone:cclienteTelefoneComercial := ::cclienteTelefoneComercial
	oClone:cclienteTelefoneCelular := ::cclienteTelefoneCelular
	oClone:cclienteEmail := ::cclienteEmail
	oClone:cclienteObservacao := ::cclienteObservacao
	oClone:lclienteAtendidoEmTodosTiposServicos := ::lclienteAtendidoEmTodosTiposServicos
	oClone:cOpenOrdemServicoWithClienteInfoResult := ::cOpenOrdemServicoWithClienteInfoResult
	oClone:cBulkOpenOrdemServicoWithClienteInfoResult := ::cBulkOpenOrdemServicoWithClienteInfoResult
	oClone:nexternalOrdemServicoID := ::nexternalOrdemServicoID
	oClone:nordemPrioridadeInsertPlace := ::nordemPrioridadeInsertPlace
	oClone:cstatus       := ::cstatus
	oClone:lnotificaAgente := ::lnotificaAgente
	oClone:ldataHoraAgendamentoFlexivel := ::ldataHoraAgendamentoFlexivel
	oClone:cSetAcompanhamentoOrdemServicoResult := ::cSetAcompanhamentoOrdemServicoResult
	oClone:cSetAcompanhamentoOrdemServicoByNumeroOSResult := ::cSetAcompanhamentoOrdemServicoByNumeroOSResult
	oClone:cmessage      := ::cmessage
	oClone:cSendMessageResult := ::cSendMessageResult
	oClone:cDeactivateOrdemServicoByExternalIDResult := ::cDeactivateOrdemServicoByExternalIDResult
	oClone:cDeactivateOrdemServicoByNumeroOSResult := ::cDeactivateOrdemServicoByNumeroOSResult
	oClone:cGetAcompanhamentoOrdemServicoResult := ::cGetAcompanhamentoOrdemServicoResult
	oClone:oWSexternalIDList :=  IIF(::oWSexternalIDList = NIL , NIL ,::oWSexternalIDList:Clone() )
	oClone:cGetAnswerFormByListOfOrdemServicoExternalIDResult := ::cGetAnswerFormByListOfOrdemServicoExternalIDResult
	oClone:oWSnumeroOSList :=  IIF(::oWSnumeroOSList = NIL , NIL ,::oWSnumeroOSList:Clone() )
	oClone:cGetAnswerFormByListOfOrdemServicoNumeroOSResult := ::cGetAnswerFormByListOfOrdemServicoNumeroOSResult
	oClone:cdataFinalizacaoCancelamento := ::cdataFinalizacaoCancelamento
	oClone:ctipoData     := ::ctipoData
	oClone:cflowStateTag := ::cflowStateTag
	oClone:cGetAllocatedOrdersByAgentStrDateResult := ::cGetAllocatedOrdersByAgentStrDateResult
	oClone:cdataInicio   := ::cdataInicio
	oClone:cdataFim      := ::cdataFim
	oClone:nversionNumber := ::nversionNumber
	oClone:nserviceTypeExternalId := ::nserviceTypeExternalId
	oClone:cGetServiceOrdersResult := ::cGetServiceOrdersResult
	oClone:ldataFixa     := ::ldataFixa
	oClone:ldataFlexivel := ::ldataFlexivel
	oClone:cGetAllocatedOrdersByAgentResult := ::cGetAllocatedOrdersByAgentResult
	oClone:clastSequenceCode := ::clastSequenceCode
	oClone:cGetChangeStreamResult := ::cGetChangeStreamResult
	oClone:cdata         := ::cdata
	oClone:cGetAgentRouteResult := ::cGetAgentRouteResult
	oClone:cGetAgentStatusListResult := ::cGetAgentStatusListResult
	oClone:nagentCode    := ::nagentCode
	oClone:nexternalAgentId := ::nexternalAgentId
	oClone:lservesAllClients := ::lservesAllClients
	oClone:lservesAllServiceTypes := ::lservesAllServiceTypes
	oClone:lisToUpdateMobileAgentTeam := ::lisToUpdateMobileAgentTeam
	oClone:nmobileAgentTeamExternalId := ::nmobileAgentTeamExternalId
	oClone:cstartMonitoringTime := ::cstartMonitoringTime
	oClone:cfinishMonitoringTime := ::cfinishMonitoringTime
	oClone:caddess       := ::caddess
	oClone:caddressNumber := ::caddressNumber
	oClone:caddressComplement := ::caddressComplement
	oClone:caddressNeighborhood := ::caddressNeighborhood
	oClone:caddressCity  := ::caddressCity
	oClone:caddressState := ::caddressState
	oClone:caddressZipcode := ::caddressZipcode
	oClone:cSaveOrUpdateMobileAgentResult := ::cSaveOrUpdateMobileAgentResult
	oClone:lisMessagingAvailable := ::lisMessagingAvailable
	oClone:cSaveOrUpdateMobileAgentTeamResult := ::cSaveOrUpdateMobileAgentTeamResult
	oClone:cGetMobileAgentTeamListResult := ::cGetMobileAgentTeamListResult
	oClone:oWSmobileAgentExternalIdList :=  IIF(::oWSmobileAgentExternalIdList = NIL , NIL ,::oWSmobileAgentExternalIdList:Clone() )
	oClone:cGetMobileAgentListResult := ::cGetMobileAgentListResult
	oClone:lisToSendEmailWithCredentials := ::lisToSendEmailWithCredentials
	oClone:lmanagesAllMobileAgents := ::lmanagesAllMobileAgents
	oClone:oWSmanagedMobileAgentExternalIdList :=  IIF(::oWSmanagedMobileAgentExternalIdList = NIL , NIL ,::oWSmanagedMobileAgentExternalIdList:Clone() )
	oClone:lisToUpdateProfile := ::lisToUpdateProfile
	oClone:cprofileName  := ::cprofileName
	oClone:cSaveOrUpdateAttendantResult := ::cSaveOrUpdateAttendantResult
	oClone:oWSattendantExternalIdList :=  IIF(::oWSattendantExternalIdList = NIL , NIL ,::oWSattendantExternalIdList:Clone() )
	oClone:cGetAttendantListResult := ::cGetAttendantListResult
	oClone:oWSclientExternalIdList :=  IIF(::oWSclientExternalIdList = NIL , NIL ,::oWSclientExternalIdList:Clone() )
	oClone:lisToFetchOnlyClientsWithExternalIdNull := ::lisToFetchOnlyClientsWithExternalIdNull
	oClone:cGetClientListResult := ::cGetClientListResult
	oClone:oWSlocationEntityIdList :=  IIF(::oWSlocationEntityIdList = NIL , NIL ,::oWSlocationEntityIdList:Clone() )
	oClone:cGetClientListInternalResult := ::cGetClientListInternalResult
	oClone:cGetAllClientsResult := ::cGetAllClientsResult
	oClone:cupdatedDateTime := ::cupdatedDateTime
	oClone:cGetAssetManagementListResult := ::cGetAssetManagementListResult
	oClone:cGetAlertListResult := ::cGetAlertListResult
	oClone:cuserID       := ::cuserID
	oClone:cserviceOrderInfo := ::cserviceOrderInfo
	oClone:cUpdateServiceOrderFlowStateResult := ::cUpdateServiceOrderFlowStateResult
	oClone:oWSclientExternalIdListToAdd :=  IIF(::oWSclientExternalIdListToAdd = NIL , NIL ,::oWSclientExternalIdListToAdd:Clone() )
	oClone:oWSclientExternalIdListToRemove :=  IIF(::oWSclientExternalIdListToRemove = NIL , NIL ,::oWSclientExternalIdListToRemove:Clone() )
	oClone:cUpdateMobileAgentClientPortfolioResult := ::cUpdateMobileAgentClientPortfolioResult
	oClone:oWSserviceIdList :=  IIF(::oWSserviceIdList = NIL , NIL ,::oWSserviceIdList:Clone() )
	oClone:cSendEmailNotificationResult := ::cSendEmailNotificationResult
	oClone:oWSaccountIdList :=  IIF(::oWSaccountIdList = NIL , NIL ,::oWSaccountIdList:Clone() )
	oClone:cVerifyAccountResult := ::cVerifyAccountResult
Return oClone

// WSDL Method GetClientWebserviceURL of Service WSKeepleFieldIntegration

WSMETHOD GetClientWebserviceURL WSSEND cauthCode,cclientCode WSRECEIVE cGetClientWebserviceURLResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GetClientWebserviceURL xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GetClientWebserviceURL>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/GetClientWebserviceURL",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cGetClientWebserviceURLResult :=  WSAdvValue( oXmlRet,"_GETCLIENTWEBSERVICEURLRESPONSE:_GETCLIENTWEBSERVICEURLRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SaveOrUpdateCliente of Service WSKeepleFieldIntegration

WSMETHOD SaveOrUpdateCliente WSSEND cauthCode,cclientCode,nexternalID,cmatricula,cnome,cfisicaJuridica,ccPFCNPJ,cclassificacao,cendereco,cenderecoNumero,cenderecoComplemento,cenderecoBairro,ccidade,cuF,ccEP,ctelefoneResidencial,ctelefoneComercial,ctelefoneCelular,cemail,cobservacao,ccontatoNome,lclienteAtivo,latendidoEmTodosTiposServicos,oWSmobileAgentCodeList,cmobileAgentCodeSource,cadditionalDataXml,ccontatoTelefone,cadditionalContactsXml,cexternalIdType WSRECEIVE cSaveOrUpdateClienteResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SaveOrUpdateCliente xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("externalID", ::nexternalID, nexternalID , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("matricula", ::cmatricula, cmatricula , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("nome", ::cnome, cnome , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("fisicaJuridica", ::cfisicaJuridica, cfisicaJuridica , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("cPFCNPJ", ::ccPFCNPJ, ccPFCNPJ , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("classificacao", ::cclassificacao, cclassificacao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("endereco", ::cendereco, cendereco , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("enderecoNumero", ::cenderecoNumero, cenderecoNumero , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("enderecoComplemento", ::cenderecoComplemento, cenderecoComplemento , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("enderecoBairro", ::cenderecoBairro, cenderecoBairro , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("cidade", ::ccidade, ccidade , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("uF", ::cuF, cuF , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("cEP", ::ccEP, ccEP , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("telefoneResidencial", ::ctelefoneResidencial, ctelefoneResidencial , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("telefoneComercial", ::ctelefoneComercial, ctelefoneComercial , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("telefoneCelular", ::ctelefoneCelular, ctelefoneCelular , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("email", ::cemail, cemail , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("observacao", ::cobservacao, cobservacao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("contatoNome", ::ccontatoNome, ccontatoNome , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clienteAtivo", ::lclienteAtivo, lclienteAtivo , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("atendidoEmTodosTiposServicos", ::latendidoEmTodosTiposServicos, latendidoEmTodosTiposServicos , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("mobileAgentCodeList", ::oWSmobileAgentCodeList, oWSmobileAgentCodeList , "ArrayOfLong", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("mobileAgentCodeSource", ::cmobileAgentCodeSource, cmobileAgentCodeSource , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("additionalDataXml", ::cadditionalDataXml, cadditionalDataXml , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("contatoTelefone", ::ccontatoTelefone, ccontatoTelefone , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("additionalContactsXml", ::cadditionalContactsXml, cadditionalContactsXml , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("externalIdType", ::cexternalIdType, cexternalIdType , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</SaveOrUpdateCliente>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/SaveOrUpdateCliente",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cSaveOrUpdateClienteResult :=  WSAdvValue( oXmlRet,"_SAVEORUPDATECLIENTERESPONSE:_SAVEORUPDATECLIENTERESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SaveOrUpdateClientContact of Service WSKeepleFieldIntegration

WSMETHOD SaveOrUpdateClientContact WSSEND cauthCode,cclientCode,nclientExternalID,nexternalID,cname,cphoneNumber,ccellNumber,cemail,coccupancy WSRECEIVE cSaveOrUpdateClientContactResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SaveOrUpdateClientContact xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientExternalID", ::nclientExternalID, nclientExternalID , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("externalID", ::nexternalID, nexternalID , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("name", ::cname, cname , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("phoneNumber", ::cphoneNumber, cphoneNumber , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("cellNumber", ::ccellNumber, ccellNumber , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("email", ::cemail, cemail , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("occupancy", ::coccupancy, coccupancy , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</SaveOrUpdateClientContact>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/SaveOrUpdateClientContact",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cSaveOrUpdateClientContactResult :=  WSAdvValue( oXmlRet,"_SAVEORUPDATECLIENTCONTACTRESPONSE:_SAVEORUPDATECLIENTCONTACTRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GetClientContactList of Service WSKeepleFieldIntegration

WSMETHOD GetClientContactList WSSEND cauthCode,cclientCode,oWSexternalClientIdList,lisToFetchOnlyContactsWithExternalIdNull WSRECEIVE cGetClientContactListResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GetClientContactList xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("externalClientIdList", ::oWSexternalClientIdList, oWSexternalClientIdList , "ArrayOfInt", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("isToFetchOnlyContactsWithExternalIdNull", ::lisToFetchOnlyContactsWithExternalIdNull, lisToFetchOnlyContactsWithExternalIdNull , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GetClientContactList>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/GetClientContactList",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cGetClientContactListResult :=  WSAdvValue( oXmlRet,"_GETCLIENTCONTACTLISTRESPONSE:_GETCLIENTCONTACTLISTRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method UpdateFormItemAnswer of Service WSKeepleFieldIntegration

WSMETHOD UpdateFormItemAnswer WSSEND cauthCode,cclientCode,nformItemAnswerId,canswer WSRECEIVE cUpdateFormItemAnswerResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<UpdateFormItemAnswer xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("formItemAnswerId", ::nformItemAnswerId, nformItemAnswerId , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("answer", ::canswer, canswer , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</UpdateFormItemAnswer>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/UpdateFormItemAnswer",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cUpdateFormItemAnswerResult :=  WSAdvValue( oXmlRet,"_UPDATEFORMITEMANSWERRESPONSE:_UPDATEFORMITEMANSWERRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method UpdateFormItemAnswerByCode of Service WSKeepleFieldIntegration

WSMETHOD UpdateFormItemAnswerByCode WSSEND cauthCode,cclientCode,cformItemAnswerCode,canswer WSRECEIVE cUpdateFormItemAnswerByCodeResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<UpdateFormItemAnswerByCode xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("formItemAnswerCode", ::cformItemAnswerCode, cformItemAnswerCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("answer", ::canswer, canswer , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</UpdateFormItemAnswerByCode>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/UpdateFormItemAnswerByCode",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cUpdateFormItemAnswerByCodeResult :=  WSAdvValue( oXmlRet,"_UPDATEFORMITEMANSWERBYCODERESPONSE:_UPDATEFORMITEMANSWERBYCODERESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SetClientContactExternalId of Service WSKeepleFieldIntegration

WSMETHOD SetClientContactExternalId WSSEND cauthCode,cclientCode,nexternalClientId,cname,nexternalId WSRECEIVE cSetClientContactExternalIdResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SetClientContactExternalId xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("externalClientId", ::nexternalClientId, nexternalClientId , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("name", ::cname, cname , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("externalId", ::nexternalId, nexternalId , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</SetClientContactExternalId>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/SetClientContactExternalId",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cSetClientContactExternalIdResult :=  WSAdvValue( oXmlRet,"_SETCLIENTCONTACTEXTERNALIDRESPONSE:_SETCLIENTCONTACTEXTERNALIDRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method OpenOrdemServico of Service WSKeepleFieldIntegration

WSMETHOD OpenOrdemServico WSSEND cauthCode,cclientCode,nexternalID,nexternalClienteID,nexternalTipoServicoID,nexternalAtendenteID,cdataSolicitacao,cprioridade,ccontatoNome,ccontatoTelefone,cendereco,cenderecoNumero,cenderecoComplemento,cenderecoBairro,ccidade,cuF,ccEP,cdescricao,nlatitude,nlongitude,cdataCriacao,cenderecoReferencia,nnumeroOS,cdynFormCreateFormXML,nagenteCodigo,cdataHoraAgendamento,cresponsibleMobileAgentAssignType,cmobileAgentCodeSource WSRECEIVE cOpenOrdemServicoResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<OpenOrdemServico xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("externalID", ::nexternalID, nexternalID , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("externalClienteID", ::nexternalClienteID, nexternalClienteID , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("externalTipoServicoID", ::nexternalTipoServicoID, nexternalTipoServicoID , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("externalAtendenteID", ::nexternalAtendenteID, nexternalAtendenteID , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("dataSolicitacao", ::cdataSolicitacao, cdataSolicitacao , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("prioridade", ::cprioridade, cprioridade , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("contatoNome", ::ccontatoNome, ccontatoNome , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("contatoTelefone", ::ccontatoTelefone, ccontatoTelefone , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("endereco", ::cendereco, cendereco , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("enderecoNumero", ::cenderecoNumero, cenderecoNumero , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("enderecoComplemento", ::cenderecoComplemento, cenderecoComplemento , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("enderecoBairro", ::cenderecoBairro, cenderecoBairro , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("cidade", ::ccidade, ccidade , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("uF", ::cuF, cuF , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("cEP", ::ccEP, ccEP , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("descricao", ::cdescricao, cdescricao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("latitude", ::nlatitude, nlatitude , "double", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("longitude", ::nlongitude, nlongitude , "double", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("dataCriacao", ::cdataCriacao, cdataCriacao , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("enderecoReferencia", ::cenderecoReferencia, cenderecoReferencia , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("numeroOS", ::nnumeroOS, nnumeroOS , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("dynFormCreateFormXML", ::cdynFormCreateFormXML, cdynFormCreateFormXML , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("agenteCodigo", ::nagenteCodigo, nagenteCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("dataHoraAgendamento", ::cdataHoraAgendamento, cdataHoraAgendamento , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("responsibleMobileAgentAssignType", ::cresponsibleMobileAgentAssignType, cresponsibleMobileAgentAssignType , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("mobileAgentCodeSource", ::cmobileAgentCodeSource, cmobileAgentCodeSource , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</OpenOrdemServico>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/OpenOrdemServico",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cOpenOrdemServicoResult :=  WSAdvValue( oXmlRet,"_OPENORDEMSERVICORESPONSE:_OPENORDEMSERVICORESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method BulkOpenOrdemServico of Service WSKeepleFieldIntegration

WSMETHOD BulkOpenOrdemServico WSSEND cauthCode,cclientCode,cxml WSRECEIVE cBulkOpenOrdemServicoResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<BulkOpenOrdemServico xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("xml", ::cxml, cxml , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</BulkOpenOrdemServico>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/BulkOpenOrdemServico",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cBulkOpenOrdemServicoResult :=  WSAdvValue( oXmlRet,"_BULKOPENORDEMSERVICORESPONSE:_BULKOPENORDEMSERVICORESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method OpenOrdemServicoWithClienteInfo of Service WSKeepleFieldIntegration

WSMETHOD OpenOrdemServicoWithClienteInfo WSSEND cauthCode,cclientCode,nexternalClienteID,cclienteMatricula,cclienteNome,cclienteFisicaJuridica,cclienteCPFCNPJ,cclienteClassificacao,cclienteEndereco,cclienteEnderecoNumero,cclienteEnderecoComplemento,cclienteEnderecoBairro,cclienteCidade,cclienteUF,cclienteCEP,cclienteTelefoneResidencial,cclienteTelefoneComercial,cclienteTelefoneCelular,cclienteEmail,cclienteObservacao,lclienteAtivo,lclienteAtendidoEmTodosTiposServicos,nexternalID,nexternalTipoServicoID,nexternalAtendenteID,cdataSolicitacao,cprioridade,ccontatoNome,ccontatoTelefone,cendereco,cenderecoNumero,cenderecoComplemento,cenderecoBairro,ccidade,cuF,ccEP,cdescricao,nlatitude,nlongitude,cdataCriacao,cenderecoReferencia,nnumeroOS,cdynFormCreateFormXML,nagenteCodigo,cdataHoraAgendamento,cresponsibleMobileAgentAssignType,cmobileAgentCodeSource WSRECEIVE cOpenOrdemServicoWithClienteInfoResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<OpenOrdemServicoWithClienteInfo xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("externalClienteID", ::nexternalClienteID, nexternalClienteID , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clienteMatricula", ::cclienteMatricula, cclienteMatricula , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clienteNome", ::cclienteNome, cclienteNome , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clienteFisicaJuridica", ::cclienteFisicaJuridica, cclienteFisicaJuridica , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clienteCPFCNPJ", ::cclienteCPFCNPJ, cclienteCPFCNPJ , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clienteClassificacao", ::cclienteClassificacao, cclienteClassificacao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clienteEndereco", ::cclienteEndereco, cclienteEndereco , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clienteEnderecoNumero", ::cclienteEnderecoNumero, cclienteEnderecoNumero , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clienteEnderecoComplemento", ::cclienteEnderecoComplemento, cclienteEnderecoComplemento , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clienteEnderecoBairro", ::cclienteEnderecoBairro, cclienteEnderecoBairro , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clienteCidade", ::cclienteCidade, cclienteCidade , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clienteUF", ::cclienteUF, cclienteUF , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clienteCEP", ::cclienteCEP, cclienteCEP , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clienteTelefoneResidencial", ::cclienteTelefoneResidencial, cclienteTelefoneResidencial , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clienteTelefoneComercial", ::cclienteTelefoneComercial, cclienteTelefoneComercial , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clienteTelefoneCelular", ::cclienteTelefoneCelular, cclienteTelefoneCelular , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clienteEmail", ::cclienteEmail, cclienteEmail , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clienteObservacao", ::cclienteObservacao, cclienteObservacao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clienteAtivo", ::lclienteAtivo, lclienteAtivo , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clienteAtendidoEmTodosTiposServicos", ::lclienteAtendidoEmTodosTiposServicos, lclienteAtendidoEmTodosTiposServicos , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("externalID", ::nexternalID, nexternalID , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("externalTipoServicoID", ::nexternalTipoServicoID, nexternalTipoServicoID , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("externalAtendenteID", ::nexternalAtendenteID, nexternalAtendenteID , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("dataSolicitacao", ::cdataSolicitacao, cdataSolicitacao , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("prioridade", ::cprioridade, cprioridade , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("contatoNome", ::ccontatoNome, ccontatoNome , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("contatoTelefone", ::ccontatoTelefone, ccontatoTelefone , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("endereco", ::cendereco, cendereco , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("enderecoNumero", ::cenderecoNumero, cenderecoNumero , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("enderecoComplemento", ::cenderecoComplemento, cenderecoComplemento , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("enderecoBairro", ::cenderecoBairro, cenderecoBairro , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("cidade", ::ccidade, ccidade , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("uF", ::cuF, cuF , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("cEP", ::ccEP, ccEP , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("descricao", ::cdescricao, cdescricao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("latitude", ::nlatitude, nlatitude , "double", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("longitude", ::nlongitude, nlongitude , "double", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("dataCriacao", ::cdataCriacao, cdataCriacao , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("enderecoReferencia", ::cenderecoReferencia, cenderecoReferencia , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("numeroOS", ::nnumeroOS, nnumeroOS , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("dynFormCreateFormXML", ::cdynFormCreateFormXML, cdynFormCreateFormXML , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("agenteCodigo", ::nagenteCodigo, nagenteCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("dataHoraAgendamento", ::cdataHoraAgendamento, cdataHoraAgendamento , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("responsibleMobileAgentAssignType", ::cresponsibleMobileAgentAssignType, cresponsibleMobileAgentAssignType , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("mobileAgentCodeSource", ::cmobileAgentCodeSource, cmobileAgentCodeSource , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</OpenOrdemServicoWithClienteInfo>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/OpenOrdemServicoWithClienteInfo",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cOpenOrdemServicoWithClienteInfoResult :=  WSAdvValue( oXmlRet,"_OPENORDEMSERVICOWITHCLIENTEINFORESPONSE:_OPENORDEMSERVICOWITHCLIENTEINFORESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method BulkOpenOrdemServicoWithClienteInfo of Service WSKeepleFieldIntegration

WSMETHOD BulkOpenOrdemServicoWithClienteInfo WSSEND cauthCode,cclientCode,cxml WSRECEIVE cBulkOpenOrdemServicoWithClienteInfoResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<BulkOpenOrdemServicoWithClienteInfo xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("xml", ::cxml, cxml , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</BulkOpenOrdemServicoWithClienteInfo>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/BulkOpenOrdemServicoWithClienteInfo",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cBulkOpenOrdemServicoWithClienteInfoResult :=  WSAdvValue( oXmlRet,"_BULKOPENORDEMSERVICOWITHCLIENTEINFORESPONSE:_BULKOPENORDEMSERVICOWITHCLIENTEINFORESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SetAcompanhamentoOrdemServico of Service WSKeepleFieldIntegration

WSMETHOD SetAcompanhamentoOrdemServico WSSEND cauthCode,cclientCode,nexternalOrdemServicoID,nordemPrioridadeInsertPlace,nagenteCodigo,cdataHoraAgendamento,cstatus,lnotificaAgente,cmobileAgentCodeSource,ldataHoraAgendamentoFlexivel WSRECEIVE cSetAcompanhamentoOrdemServicoResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SetAcompanhamentoOrdemServico xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("externalOrdemServicoID", ::nexternalOrdemServicoID, nexternalOrdemServicoID , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ordemPrioridadeInsertPlace", ::nordemPrioridadeInsertPlace, nordemPrioridadeInsertPlace , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("agenteCodigo", ::nagenteCodigo, nagenteCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("dataHoraAgendamento", ::cdataHoraAgendamento, cdataHoraAgendamento , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("status", ::cstatus, cstatus , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("notificaAgente", ::lnotificaAgente, lnotificaAgente , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("mobileAgentCodeSource", ::cmobileAgentCodeSource, cmobileAgentCodeSource , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("dataHoraAgendamentoFlexivel", ::ldataHoraAgendamentoFlexivel, ldataHoraAgendamentoFlexivel , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</SetAcompanhamentoOrdemServico>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/SetAcompanhamentoOrdemServico",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cSetAcompanhamentoOrdemServicoResult :=  WSAdvValue( oXmlRet,"_SETACOMPANHAMENTOORDEMSERVICORESPONSE:_SETACOMPANHAMENTOORDEMSERVICORESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SetAcompanhamentoOrdemServicoByNumeroOS of Service WSKeepleFieldIntegration

WSMETHOD SetAcompanhamentoOrdemServicoByNumeroOS WSSEND cauthCode,cclientCode,nnumeroOs,nordemPrioridadeInsertPlace,nagenteCodigo,cdataHoraAgendamento,cstatus,lnotificaAgente,cmobileAgentCodeSource,ldataHoraAgendamentoFlexivel WSRECEIVE cSetAcompanhamentoOrdemServicoByNumeroOSResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SetAcompanhamentoOrdemServicoByNumeroOS xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("numeroOs", ::nnumeroOs, nnumeroOs , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("ordemPrioridadeInsertPlace", ::nordemPrioridadeInsertPlace, nordemPrioridadeInsertPlace , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("agenteCodigo", ::nagenteCodigo, nagenteCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("dataHoraAgendamento", ::cdataHoraAgendamento, cdataHoraAgendamento , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("status", ::cstatus, cstatus , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("notificaAgente", ::lnotificaAgente, lnotificaAgente , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("mobileAgentCodeSource", ::cmobileAgentCodeSource, cmobileAgentCodeSource , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("dataHoraAgendamentoFlexivel", ::ldataHoraAgendamentoFlexivel, ldataHoraAgendamentoFlexivel , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</SetAcompanhamentoOrdemServicoByNumeroOS>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/SetAcompanhamentoOrdemServicoByNumeroOS",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cSetAcompanhamentoOrdemServicoByNumeroOSResult :=  WSAdvValue( oXmlRet,"_SETACOMPANHAMENTOORDEMSERVICOBYNUMEROOSRESPONSE:_SETACOMPANHAMENTOORDEMSERVICOBYNUMEROOSRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SendMessage of Service WSKeepleFieldIntegration

WSMETHOD SendMessage WSSEND cauthCode,cclientCode,nagenteCodigo,cmessage WSRECEIVE cSendMessageResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SendMessage xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("agenteCodigo", ::nagenteCodigo, nagenteCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("message", ::cmessage, cmessage , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</SendMessage>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/SendMessage",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cSendMessageResult :=  WSAdvValue( oXmlRet,"_SENDMESSAGERESPONSE:_SENDMESSAGERESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method DeactivateOrdemServicoByExternalID of Service WSKeepleFieldIntegration

WSMETHOD DeactivateOrdemServicoByExternalID WSSEND cauthCode,cclientCode,nexternalOrdemServicoID WSRECEIVE cDeactivateOrdemServicoByExternalIDResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<DeactivateOrdemServicoByExternalID xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("externalOrdemServicoID", ::nexternalOrdemServicoID, nexternalOrdemServicoID , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</DeactivateOrdemServicoByExternalID>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/DeactivateOrdemServicoByExternalID",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cDeactivateOrdemServicoByExternalIDResult :=  WSAdvValue( oXmlRet,"_DEACTIVATEORDEMSERVICOBYEXTERNALIDRESPONSE:_DEACTIVATEORDEMSERVICOBYEXTERNALIDRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method DeactivateOrdemServicoByNumeroOS of Service WSKeepleFieldIntegration

WSMETHOD DeactivateOrdemServicoByNumeroOS WSSEND cauthCode,cclientCode,nnumeroOS WSRECEIVE cDeactivateOrdemServicoByNumeroOSResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<DeactivateOrdemServicoByNumeroOS xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("numeroOS", ::nnumeroOS, nnumeroOS , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</DeactivateOrdemServicoByNumeroOS>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/DeactivateOrdemServicoByNumeroOS",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cDeactivateOrdemServicoByNumeroOSResult :=  WSAdvValue( oXmlRet,"_DEACTIVATEORDEMSERVICOBYNUMEROOSRESPONSE:_DEACTIVATEORDEMSERVICOBYNUMEROOSRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GetAcompanhamentoOrdemServico of Service WSKeepleFieldIntegration

WSMETHOD GetAcompanhamentoOrdemServico WSSEND cauthCode,cclientCode,nexternalID WSRECEIVE cGetAcompanhamentoOrdemServicoResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GetAcompanhamentoOrdemServico xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("externalID", ::nexternalID, nexternalID , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GetAcompanhamentoOrdemServico>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/GetAcompanhamentoOrdemServico",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cGetAcompanhamentoOrdemServicoResult :=  WSAdvValue( oXmlRet,"_GETACOMPANHAMENTOORDEMSERVICORESPONSE:_GETACOMPANHAMENTOORDEMSERVICORESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GetAnswerFormByListOfOrdemServicoExternalID of Service WSKeepleFieldIntegration

WSMETHOD GetAnswerFormByListOfOrdemServicoExternalID WSSEND cauthCode,cclientCode,oWSexternalIDList WSRECEIVE cGetAnswerFormByListOfOrdemServicoExternalIDResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GetAnswerFormByListOfOrdemServicoExternalID xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("externalIDList", ::oWSexternalIDList, oWSexternalIDList , "ArrayOfInt", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GetAnswerFormByListOfOrdemServicoExternalID>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/GetAnswerFormByListOfOrdemServicoExternalID",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cGetAnswerFormByListOfOrdemServicoExternalIDResult :=  WSAdvValue( oXmlRet,"_GETANSWERFORMBYLISTOFORDEMSERVICOEXTERNALIDRESPONSE:_GETANSWERFORMBYLISTOFORDEMSERVICOEXTERNALIDRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GetAnswerFormByListOfOrdemServicoNumeroOS of Service WSKeepleFieldIntegration

WSMETHOD GetAnswerFormByListOfOrdemServicoNumeroOS WSSEND cauthCode,cclientCode,oWSnumeroOSList WSRECEIVE cGetAnswerFormByListOfOrdemServicoNumeroOSResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GetAnswerFormByListOfOrdemServicoNumeroOS xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("numeroOSList", ::oWSnumeroOSList, oWSnumeroOSList , "ArrayOfInt", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GetAnswerFormByListOfOrdemServicoNumeroOS>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/GetAnswerFormByListOfOrdemServicoNumeroOS",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cGetAnswerFormByListOfOrdemServicoNumeroOSResult :=  WSAdvValue( oXmlRet,"_GETANSWERFORMBYLISTOFORDEMSERVICONUMEROOSRESPONSE:_GETANSWERFORMBYLISTOFORDEMSERVICONUMEROOSRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GetAllocatedOrdersByAgentStrDate of Service WSKeepleFieldIntegration

WSMETHOD GetAllocatedOrdersByAgentStrDate WSSEND cauthCode,cclientCode,nagenteCodigo,cdataFinalizacaoCancelamento,ctipoData,cmobileAgentCodeSource,cflowStateTag WSRECEIVE cGetAllocatedOrdersByAgentStrDateResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GetAllocatedOrdersByAgentStrDate xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("agenteCodigo", ::nagenteCodigo, nagenteCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("dataFinalizacaoCancelamento", ::cdataFinalizacaoCancelamento, cdataFinalizacaoCancelamento , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("tipoData", ::ctipoData, ctipoData , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("mobileAgentCodeSource", ::cmobileAgentCodeSource, cmobileAgentCodeSource , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("flowStateTag", ::cflowStateTag, cflowStateTag , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GetAllocatedOrdersByAgentStrDate>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/GetAllocatedOrdersByAgentStrDate",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cGetAllocatedOrdersByAgentStrDateResult :=  WSAdvValue( oXmlRet,"_GETALLOCATEDORDERSBYAGENTSTRDATERESPONSE:_GETALLOCATEDORDERSBYAGENTSTRDATERESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GetServiceOrders of Service WSKeepleFieldIntegration

WSMETHOD GetServiceOrders WSSEND cauthCode,cclientCode,nagenteCodigo,cdataInicio,cdataFim,cmobileAgentCodeSource,cflowStateTag,nversionNumber,nserviceTypeExternalId WSRECEIVE cGetServiceOrdersResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GetServiceOrders xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("agenteCodigo", ::nagenteCodigo, nagenteCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("dataInicio", ::cdataInicio, cdataInicio , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("dataFim", ::cdataFim, cdataFim , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("mobileAgentCodeSource", ::cmobileAgentCodeSource, cmobileAgentCodeSource , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("flowStateTag", ::cflowStateTag, cflowStateTag , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("versionNumber", ::nversionNumber, nversionNumber , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("serviceTypeExternalId", ::nserviceTypeExternalId, nserviceTypeExternalId , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GetServiceOrders>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/GetServiceOrders",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cGetServiceOrdersResult :=  WSAdvValue( oXmlRet,"_GETSERVICEORDERSRESPONSE:_GETSERVICEORDERSRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GetAllocatedOrdersByAgent of Service WSKeepleFieldIntegration

WSMETHOD GetAllocatedOrdersByAgent WSSEND cauthCode,cclientCode,nagenteCodigo,cdataFinalizacaoCancelamento,ctipoData,cmobileAgentCodeSource,cflowStateTag,ldataFixa,ldataFlexivel WSRECEIVE cGetAllocatedOrdersByAgentResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GetAllocatedOrdersByAgent xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("agenteCodigo", ::nagenteCodigo, nagenteCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("dataFinalizacaoCancelamento", ::cdataFinalizacaoCancelamento, cdataFinalizacaoCancelamento , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("tipoData", ::ctipoData, ctipoData , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("mobileAgentCodeSource", ::cmobileAgentCodeSource, cmobileAgentCodeSource , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("flowStateTag", ::cflowStateTag, cflowStateTag , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("dataFixa", ::ldataFixa, ldataFixa , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("dataFlexivel", ::ldataFlexivel, ldataFlexivel , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GetAllocatedOrdersByAgent>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/GetAllocatedOrdersByAgent",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cGetAllocatedOrdersByAgentResult :=  WSAdvValue( oXmlRet,"_GETALLOCATEDORDERSBYAGENTRESPONSE:_GETALLOCATEDORDERSBYAGENTRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GetChangeStream of Service WSKeepleFieldIntegration

WSMETHOD GetChangeStream WSSEND cauthCode,cclientCode,clastSequenceCode WSRECEIVE cGetChangeStreamResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GetChangeStream xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("lastSequenceCode", ::clastSequenceCode, clastSequenceCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GetChangeStream>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/GetChangeStream",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cGetChangeStreamResult :=  WSAdvValue( oXmlRet,"_GETCHANGESTREAMRESPONSE:_GETCHANGESTREAMRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GetAgentRoute of Service WSKeepleFieldIntegration

WSMETHOD GetAgentRoute WSSEND cauthCode,cclientCode,nagenteCodigo,cdata,cmobileAgentCodeSource WSRECEIVE cGetAgentRouteResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GetAgentRoute xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("agenteCodigo", ::nagenteCodigo, nagenteCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("data", ::cdata, cdata , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("mobileAgentCodeSource", ::cmobileAgentCodeSource, cmobileAgentCodeSource , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GetAgentRoute>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/GetAgentRoute",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cGetAgentRouteResult :=  WSAdvValue( oXmlRet,"_GETAGENTROUTERESPONSE:_GETAGENTROUTERESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GetAgentStatusList of Service WSKeepleFieldIntegration

WSMETHOD GetAgentStatusList WSSEND cauthCode,cclientCode,nagenteCodigo,cdata,cmobileAgentCodeSource WSRECEIVE cGetAgentStatusListResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GetAgentStatusList xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("agenteCodigo", ::nagenteCodigo, nagenteCodigo , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("data", ::cdata, cdata , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("mobileAgentCodeSource", ::cmobileAgentCodeSource, cmobileAgentCodeSource , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GetAgentStatusList>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/GetAgentStatusList",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cGetAgentStatusListResult :=  WSAdvValue( oXmlRet,"_GETAGENTSTATUSLISTRESPONSE:_GETAGENTSTATUSLISTRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SaveOrUpdateMobileAgent of Service WSKeepleFieldIntegration

WSMETHOD SaveOrUpdateMobileAgent WSSEND cauthCode,cclientCode,nagentCode,nexternalAgentId,cname,cemail,cphoneNumber,lservesAllClients,lservesAllServiceTypes,lisToUpdateMobileAgentTeam,nmobileAgentTeamExternalId,cstartMonitoringTime,cfinishMonitoringTime,caddess,caddressNumber,caddressComplement,caddressNeighborhood,caddressCity,caddressState,caddressZipcode WSRECEIVE cSaveOrUpdateMobileAgentResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SaveOrUpdateMobileAgent xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("agentCode", ::nagentCode, nagentCode , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("externalAgentId", ::nexternalAgentId, nexternalAgentId , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("name", ::cname, cname , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("email", ::cemail, cemail , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("phoneNumber", ::cphoneNumber, cphoneNumber , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("servesAllClients", ::lservesAllClients, lservesAllClients , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("servesAllServiceTypes", ::lservesAllServiceTypes, lservesAllServiceTypes , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("isToUpdateMobileAgentTeam", ::lisToUpdateMobileAgentTeam, lisToUpdateMobileAgentTeam , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("mobileAgentTeamExternalId", ::nmobileAgentTeamExternalId, nmobileAgentTeamExternalId , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("startMonitoringTime", ::cstartMonitoringTime, cstartMonitoringTime , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("finishMonitoringTime", ::cfinishMonitoringTime, cfinishMonitoringTime , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("addess", ::caddess, caddess , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("addressNumber", ::caddressNumber, caddressNumber , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("addressComplement", ::caddressComplement, caddressComplement , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("addressNeighborhood", ::caddressNeighborhood, caddressNeighborhood , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("addressCity", ::caddressCity, caddressCity , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("addressState", ::caddressState, caddressState , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("addressZipcode", ::caddressZipcode, caddressZipcode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</SaveOrUpdateMobileAgent>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/SaveOrUpdateMobileAgent",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cSaveOrUpdateMobileAgentResult :=  WSAdvValue( oXmlRet,"_SAVEORUPDATEMOBILEAGENTRESPONSE:_SAVEORUPDATEMOBILEAGENTRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SaveOrUpdateMobileAgentTeam of Service WSKeepleFieldIntegration

WSMETHOD SaveOrUpdateMobileAgentTeam WSSEND cauthCode,cclientCode,nexternalId,cname,lisMessagingAvailable WSRECEIVE cSaveOrUpdateMobileAgentTeamResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SaveOrUpdateMobileAgentTeam xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("externalId", ::nexternalId, nexternalId , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("name", ::cname, cname , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("isMessagingAvailable", ::lisMessagingAvailable, lisMessagingAvailable , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</SaveOrUpdateMobileAgentTeam>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/SaveOrUpdateMobileAgentTeam",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cSaveOrUpdateMobileAgentTeamResult :=  WSAdvValue( oXmlRet,"_SAVEORUPDATEMOBILEAGENTTEAMRESPONSE:_SAVEORUPDATEMOBILEAGENTTEAMRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GetMobileAgentTeamList of Service WSKeepleFieldIntegration

WSMETHOD GetMobileAgentTeamList WSSEND cauthCode,cclientCode WSRECEIVE cGetMobileAgentTeamListResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GetMobileAgentTeamList xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GetMobileAgentTeamList>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/GetMobileAgentTeamList",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cGetMobileAgentTeamListResult :=  WSAdvValue( oXmlRet,"_GETMOBILEAGENTTEAMLISTRESPONSE:_GETMOBILEAGENTTEAMLISTRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GetMobileAgentList of Service WSKeepleFieldIntegration

WSMETHOD GetMobileAgentList WSSEND cauthCode,cclientCode,oWSmobileAgentExternalIdList WSRECEIVE cGetMobileAgentListResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GetMobileAgentList xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("mobileAgentExternalIdList", ::oWSmobileAgentExternalIdList, oWSmobileAgentExternalIdList , "ArrayOfLong", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GetMobileAgentList>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/GetMobileAgentList",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cGetMobileAgentListResult :=  WSAdvValue( oXmlRet,"_GETMOBILEAGENTLISTRESPONSE:_GETMOBILEAGENTLISTRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SaveOrUpdateAttendant of Service WSKeepleFieldIntegration

WSMETHOD SaveOrUpdateAttendant WSSEND cauthCode,cclientCode,nexternalId,cname,cemail,lisToSendEmailWithCredentials,lmanagesAllMobileAgents,oWSmanagedMobileAgentExternalIdList,lisToUpdateProfile,cprofileName WSRECEIVE cSaveOrUpdateAttendantResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SaveOrUpdateAttendant xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("externalId", ::nexternalId, nexternalId , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("name", ::cname, cname , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("email", ::cemail, cemail , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("isToSendEmailWithCredentials", ::lisToSendEmailWithCredentials, lisToSendEmailWithCredentials , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("managesAllMobileAgents", ::lmanagesAllMobileAgents, lmanagesAllMobileAgents , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("managedMobileAgentExternalIdList", ::oWSmanagedMobileAgentExternalIdList, oWSmanagedMobileAgentExternalIdList , "ArrayOfLong", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("isToUpdateProfile", ::lisToUpdateProfile, lisToUpdateProfile , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("profileName", ::cprofileName, cprofileName , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</SaveOrUpdateAttendant>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/SaveOrUpdateAttendant",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cSaveOrUpdateAttendantResult :=  WSAdvValue( oXmlRet,"_SAVEORUPDATEATTENDANTRESPONSE:_SAVEORUPDATEATTENDANTRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GetAttendantList of Service WSKeepleFieldIntegration

WSMETHOD GetAttendantList WSSEND cauthCode,cclientCode,oWSattendantExternalIdList WSRECEIVE cGetAttendantListResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GetAttendantList xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("attendantExternalIdList", ::oWSattendantExternalIdList, oWSattendantExternalIdList , "ArrayOfInt", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GetAttendantList>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/GetAttendantList",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cGetAttendantListResult :=  WSAdvValue( oXmlRet,"_GETATTENDANTLISTRESPONSE:_GETATTENDANTLISTRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GetClientList of Service WSKeepleFieldIntegration

WSMETHOD GetClientList WSSEND cauthCode,cclientCode,oWSclientExternalIdList,lisToFetchOnlyClientsWithExternalIdNull WSRECEIVE cGetClientListResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GetClientList xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientExternalIdList", ::oWSclientExternalIdList, oWSclientExternalIdList , "ArrayOfInt", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("isToFetchOnlyClientsWithExternalIdNull", ::lisToFetchOnlyClientsWithExternalIdNull, lisToFetchOnlyClientsWithExternalIdNull , "boolean", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GetClientList>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/GetClientList",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cGetClientListResult :=  WSAdvValue( oXmlRet,"_GETCLIENTLISTRESPONSE:_GETCLIENTLISTRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GetClientListInternal of Service WSKeepleFieldIntegration

WSMETHOD GetClientListInternal WSSEND cauthCode,cclientCode,oWSlocationEntityIdList WSRECEIVE cGetClientListInternalResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GetClientListInternal xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("locationEntityIdList", ::oWSlocationEntityIdList, oWSlocationEntityIdList , "ArrayOfInt", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GetClientListInternal>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/GetClientListInternal",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cGetClientListInternalResult :=  WSAdvValue( oXmlRet,"_GETCLIENTLISTINTERNALRESPONSE:_GETCLIENTLISTINTERNALRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GetAllClients of Service WSKeepleFieldIntegration

WSMETHOD GetAllClients WSSEND cauthCode,cclientCode WSRECEIVE cGetAllClientsResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GetAllClients xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GetAllClients>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/GetAllClients",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cGetAllClientsResult :=  WSAdvValue( oXmlRet,"_GETALLCLIENTSRESPONSE:_GETALLCLIENTSRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GetAssetManagementList of Service WSKeepleFieldIntegration

WSMETHOD GetAssetManagementList WSSEND cauthCode,cclientCode,cupdatedDateTime WSRECEIVE cGetAssetManagementListResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GetAssetManagementList xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("updatedDateTime", ::cupdatedDateTime, cupdatedDateTime , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GetAssetManagementList>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/GetAssetManagementList",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cGetAssetManagementListResult :=  WSAdvValue( oXmlRet,"_GETASSETMANAGEMENTLISTRESPONSE:_GETASSETMANAGEMENTLISTRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GetAlertList of Service WSKeepleFieldIntegration

WSMETHOD GetAlertList WSSEND cauthCode,cclientCode,cupdatedDateTime WSRECEIVE cGetAlertListResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GetAlertList xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("updatedDateTime", ::cupdatedDateTime, cupdatedDateTime , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</GetAlertList>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/GetAlertList",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cGetAlertListResult :=  WSAdvValue( oXmlRet,"_GETALERTLISTRESPONSE:_GETALERTLISTRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method UpdateServiceOrderFlowState of Service WSKeepleFieldIntegration

WSMETHOD UpdateServiceOrderFlowState WSSEND cauthCode,cclientCode,cuserID,cserviceOrderInfo WSRECEIVE cUpdateServiceOrderFlowStateResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<UpdateServiceOrderFlowState xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("userID", ::cuserID, cuserID , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("serviceOrderInfo", ::cserviceOrderInfo, cserviceOrderInfo , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</UpdateServiceOrderFlowState>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/UpdateServiceOrderFlowState",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cUpdateServiceOrderFlowStateResult :=  WSAdvValue( oXmlRet,"_UPDATESERVICEORDERFLOWSTATERESPONSE:_UPDATESERVICEORDERFLOWSTATERESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method UpdateMobileAgentClientPortfolio of Service WSKeepleFieldIntegration

WSMETHOD UpdateMobileAgentClientPortfolio WSSEND cauthCode,cclientCode,nagentCode,oWSclientExternalIdListToAdd,oWSclientExternalIdListToRemove,cmobileAgentCodeSource WSRECEIVE cUpdateMobileAgentClientPortfolioResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<UpdateMobileAgentClientPortfolio xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::cclientCode, cclientCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("agentCode", ::nagentCode, nagentCode , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientExternalIdListToAdd", ::oWSclientExternalIdListToAdd, oWSclientExternalIdListToAdd , "ArrayOfInt", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientExternalIdListToRemove", ::oWSclientExternalIdListToRemove, oWSclientExternalIdListToRemove , "ArrayOfInt", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("mobileAgentCodeSource", ::cmobileAgentCodeSource, cmobileAgentCodeSource , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</UpdateMobileAgentClientPortfolio>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/UpdateMobileAgentClientPortfolio",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cUpdateMobileAgentClientPortfolioResult :=  WSAdvValue( oXmlRet,"_UPDATEMOBILEAGENTCLIENTPORTFOLIORESPONSE:_UPDATEMOBILEAGENTCLIENTPORTFOLIORESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SendEmailNotification of Service WSKeepleFieldIntegration

WSMETHOD SendEmailNotification WSSEND cauthCode,nclientCode,oWSserviceIdList WSRECEIVE cSendEmailNotificationResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SendEmailNotification xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("clientCode", ::nclientCode, nclientCode , "int", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("serviceIdList", ::oWSserviceIdList, oWSserviceIdList , "ArrayOfInt", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</SendEmailNotification>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/SendEmailNotification",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cSendEmailNotificationResult :=  WSAdvValue( oXmlRet,"_SENDEMAILNOTIFICATIONRESPONSE:_SENDEMAILNOTIFICATIONRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method VerifyAccount of Service WSKeepleFieldIntegration

WSMETHOD VerifyAccount WSSEND cauthCode,cdata,oWSaccountIdList WSRECEIVE cVerifyAccountResult WSCLIENT WSKeepleFieldIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<VerifyAccount xmlns="http://www.equiperemota.com.br">'
cSoap += WSSoapValue("authCode", ::cauthCode, cauthCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("data", ::cdata, cdata , "dateTime", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("accountIdList", ::oWSaccountIdList, oWSaccountIdList , "ArrayOfInt", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</VerifyAccount>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://www.equiperemota.com.br/VerifyAccount",; 
	"DOCUMENT","http://www.equiperemota.com.br",,,; 
	"http://ws.goon.mobi/webservices/keeplefieldintegration.asmx")

::Init()
::cVerifyAccountResult :=  WSAdvValue( oXmlRet,"_VERIFYACCOUNTRESPONSE:_VERIFYACCOUNTRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure ArrayOfLong

WSSTRUCT KeepleFieldIntegration_ArrayOfLong
	WSDATA   nlong                     AS long OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT KeepleFieldIntegration_ArrayOfLong
	::Init()
Return Self

WSMETHOD INIT WSCLIENT KeepleFieldIntegration_ArrayOfLong
	::nlong                := {} // Array Of  0
Return

WSMETHOD CLONE WSCLIENT KeepleFieldIntegration_ArrayOfLong
	Local oClone := KeepleFieldIntegration_ArrayOfLong():NEW()
	oClone:nlong                := IIf(::nlong <> NIL , aClone(::nlong) , NIL )
Return oClone

WSMETHOD SOAPSEND WSCLIENT KeepleFieldIntegration_ArrayOfLong
	Local cSoap := ""
	aEval( ::nlong , {|x| cSoap := cSoap  +  WSSoapValue("long", x , x , "long", .F. , .F., 0 , NIL, .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure ArrayOfInt

WSSTRUCT KeepleFieldIntegration_ArrayOfInt
	WSDATA   nint                      AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT KeepleFieldIntegration_ArrayOfInt
	::Init()
Return Self

WSMETHOD INIT WSCLIENT KeepleFieldIntegration_ArrayOfInt
	::nint                 := {} // Array Of  0
Return

WSMETHOD CLONE WSCLIENT KeepleFieldIntegration_ArrayOfInt
	Local oClone := KeepleFieldIntegration_ArrayOfInt():NEW()
	oClone:nint                 := IIf(::nint <> NIL , aClone(::nint) , NIL )
Return oClone

WSMETHOD SOAPSEND WSCLIENT KeepleFieldIntegration_ArrayOfInt
	Local cSoap := ""
	aEval( ::nint , {|x| cSoap := cSoap  +  WSSoapValue("int", x , x , "int", .F. , .F., 0 , NIL, .F.,.F.)  } ) 
Return cSoap


