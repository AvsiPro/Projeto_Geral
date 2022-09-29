#INCLUDE "RPTDEF.CH"
#INCLUDE "topconn.ch"
#INCLUDE "SHELL.CH"
#INCLUDE "Protheus.ch"                                
#INCLUDE "TBICONN.CH"
#INCLUDE "FWPrintSetup.ch"

User Function CpyT2S(cOrig,cDest)

Local lSucess    := .F.
Local cOrig      := cOrig
Local cDest    	 := "\SPOOL\"
Local cStartPath := "\SYSTEM\"

lSucess := CpyT2S(cOrig,cDest,.F.)

Return lSucess