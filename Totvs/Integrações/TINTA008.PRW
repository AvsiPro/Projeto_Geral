#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

//    Rotina para geracao dos Itens contabeis pelo processo webhook

User Function TINTA008(aAux,cErro,cAlias,nTipReg)

Local aArea         := GetArea()
Local aDadosAuto    :=  {}
Local nCont         :=  0
Local lRetorno      :=  .T.
Local oResult       := JsonObject():New()

Default cErro       :=  ''
Default nTipReg     :=  3

Private nOpcAuto
Private lMsErroAuto :=  .F.
Private lMsHelpAuto := .f.

For nCont := 1 to len(aAux)
    Aadd(aDadosAuto,{aAux[nCont,01],;
                aAux[nCont,02],Nil})
Next nCont 

nOpcAuto := nTipReg

MSExecAuto({|x, y| CTBA040(x, y)},aDadosAuto, nOpcAuto)

If lMsErroAuto

    lRetorno := .F.
    _cNome := "TINTA008.txt"
	ctxtErro := MostraErro(,_cNome)
    oResult['Retorno'] := ctxtErro

Else
    for nCont := 1 to Len(aAux)
      oResult[aAux[nCont,01]] := (cAlias)->&(aAux[nCont,01])
    next
    lRetorno:=.T.
EndIf

RestArea(aArea)

Return(oResult)
