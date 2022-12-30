#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

//    Rotina para geracao dos centro de custo pelo processo webhook


User Function TINTA007(aAux,cErro,cAlias,nTipReg)

Local aArea         := GetArea()
Local aDadosAuto    :=  {}
Local nCont         :=  0
Local lRetorno      :=  .T.
Local oResult       := JsonObject():New()

Default cErro       :=  ''
Default nTipReg     :=  3

Private nOpcAuto
Private lMsErroAuto :=  .F.

For nCont := 1 to len(aAux)
    Aadd(aDadosAuto,{aAux[nCont,01],;
                aAux[nCont,02],Nil})
Next nCont 

nOpcAuto := nTipReg

MSExecAuto({|x, y| CTBA030(x, y)},aDadosAuto, nOpcAuto)

If lMsErroAuto

    lRetorno := .F.
    _cNome := "TINTA007.txt"
	ctxtErro := MostraErro(,_cNome)
Else
    for nCont := 1 to Len(aAux)
      oResult[aAux[nCont,01]] := (cAlias)->&(aAux[nCont,01])
    next
    lRetorno:=.T.
EndIf

RestArea(aArea)

Return(oResult)

