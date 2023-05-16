#Include "rwmake.ch"
#Include "topconn.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"  
#INCLUDE "TOTVS.CH"
#include "tbiconn.ch"                                                                                                                 
#include "fwmvcdef.ch"   
#Include "fileio.ch"
#Include "Font.Ch"
#INCLUDE "FWBROWSE.CH"
*****************************
User Function fNomForApv()
*****************************
local cTab      := GetNextAlias()
Local cQuery    := ""
Local cNome     := ""

cQuery  := " SELECT C7_FORNECE, C7_LOJA FROM " + RETSQLNAME("SC7") + " A "
cQuery  += " WHERE D_E_L_E_T_ = '' "
cQuery  += " AND C7_FILIAL = '"+SCR->CR_FILIAL+"'  "
cQuery  += " AND C7_NUM = '"+SCR->CR_NUM+"' "
cQuery  += " GROUP BY C7_FORNECE, C7_LOJA "
If Select("cTab") > 0; cTab->(DbCloseArea()); EndIf
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cTab, .T., .T.)



If !(cTab)->(EOF())

    cNome   := GetAdvFVal("SA2","A2_NOME"		, xFilial("SA2") + (cTab)->C7_FORNECE + (cTab)->C7_LOJA  ,1,"")

EndIf

(cTab)->(DbCloseArea())



Return(cNome)
*****************************
User Function fNomPGT()
*****************************
local cTabPG      := GetNextAlias()
Local cQuery    := ""
Local cCondic   := ""

cQuery  := " SELECT C7_COND FROM " + RETSQLNAME("SC7") + " A "
cQuery  += " WHERE D_E_L_E_T_ = '' "
cQuery  += " AND C7_FILIAL = '"+SCR->CR_FILIAL+"'  "
cQuery  += " AND C7_NUM = '"+SCR->CR_NUM+"' "
cQuery  += " GROUP BY C7_COND "
If Select("cTabPG") > 0; cTabPG->(DbCloseArea()); EndIf
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cTabPG, .T., .T.)



If !(cTabPG)->(EOF())

    cCondic   := GetAdvFVal("SE4","E4_DESCRI"		, xFilial("SE4") + (cTabPG)->C7_COND ,1,"")

EndIf

(cTabPG)->(DbCloseArea())



Return(cCondic)
