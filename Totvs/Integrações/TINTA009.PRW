#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

//    Rotina para geracao das naturezas pelo processo webhook


User Function TINTA009(aAux,cErro,cAlias,nTipReg)

Local aArea         := GetArea()
Local aRotAuto    :=  {}
Local nCont         :=  0
Local lRetorno      :=  .T.
Local oResult       := JsonObject():New()

Default cErro       :=  ''
Default nTipReg     :=  3

Private nOpcAuto
Private lMsErroAuto :=  .F.

For nCont := 1 to len(aAux)
    Aadd(aRotAuto,{aAux[nCont,01],;
                aAux[nCont,02],Nil})
Next nCont 

nOpcAuto := nTipReg

MSExecAuto({|x, y| FINA010(x, y)},aRotAuto, nOpcAuto)

If lMsErroAuto

    lRetorno := .F.
    _cNome := "TINTA009.txt"
	ctxtErro := MostraErro(,_cNome)
Else
    for nCont := 1 to Len(aAux)
      oResult[aAux[nCont,01]] := (cAlias)->&(aAux[nCont,01])
    next
    lRetorno:=.T.
EndIf

RestArea(aArea)

Return(oResult)

