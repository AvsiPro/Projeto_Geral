#Include "Protheus.ch"

User Function MA415BUT()   

Local aButtons	:=	{}

aadd(aButtons,{"POSCLI",{||U_HIT0200(M->CJ_CLIENTE,M->CJ_LOJA)},"Historico" })

Return(aButtons)

User Function A410CONS()

Local aButtons	:=	{}

aadd(aButtons,{"POSCLI",{||U_HIT0200(M->C5_CLIENTE,M->C5_LOJACLI)},"Historico" })

Return(aButtons)