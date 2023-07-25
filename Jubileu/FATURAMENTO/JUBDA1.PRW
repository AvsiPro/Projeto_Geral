#INCLUDE 'PROTHEUS.CH'
#include "tbiconn.ch"
#include "fileio.ch"
#include "topconn.ch"

/*/{Protheus.doc} User Function nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 20/07/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function JUBDA1()

Local cArqT1 := "C:\000\TABELA.CSV"
Local aAux   := {}
Local nCont  := 0
Local nX     := 0

If Empty(FunName())
    RpcSetType(3)
    RPCSetEnv("01","0801")
EndIf

FT_FUSE(cArqT1)

FT_FGOTOP()

While !FT_FEOF()
		
	cLinha := FT_FREADLN()
	
	AADD(aAux,Separa(cLinha,";",.T.))

	FT_FSKIP()

EndDo 

FT_FUSE()

DbSelectArea("DA1")
For nCont := 2 to len(aAux)
    Reclock("DA1",.T.)
    For nX := 1 to len(aAux[nCont])
        lNumer := Alltrim(aAux[1,nX]) $ 'DA1_CODTAB/DA1_ITEM/DA1_CODPRO'
        &("DA1->"+aAux[1,nX]) := If(!lNumer,val(aAux[nCont,nX]),aAux[nCont,nX])
    Next nX 
    DA1->(Msunlock())
Next nCont

Return
