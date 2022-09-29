#INCLUDE "PROTHEUS.CH
#INCLUDE "TOPCONN.CH"

User Function CpyS2TEx

Local lSucess    := .F.
Local cArq       := "SXSBRA.TXT"
Local cLcArqD    := "C:\ADM\SXSBRA.TXT"
Local cStartPath := GetSrvProfString("StartPath","")
Local cRootPath  := GetSrvProfString("RootPath","")

lSucess := CpyS2TEx(Alltrim(cRootPath+cStartPath)+ALLTRIM(cArq),Alltrim(cLcArqD))

If lSucess == .T.
	Alert("Arquivo Copiado com Sucesso")
Else
	Alert("Arquivo Não Copiado") 
Endif

Return lSucess