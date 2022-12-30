#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

Static __oModelAut := NIL //variavel oModel para substituir msexecauto em MVC


//Exemplo de rotina automática para inclusão de contas contábeis no ambiente Contabilidade Gerencial (SigaCTB).
/// ROTINA AUTOMATICA - INCLUSAO DE CONTA CONTABIL CTB
User Function TINTA006(aAux,cErro,nTipReg)

Local nOpcAuto  :=  0
Local nX
Local oCT1
Local aLog
Local cLog      :=  ""
Local lRet      :=  .T.
Local nCont     :=  0

Default cErro   :=  ''
Default nTipReg :=  3

If __oModelAut == Nil //somente uma unica vez carrega o modelo CTBA020-Plano de Contas CT1
    __oModelAut := FWLoadModel('CTBA020')
EndIf

nOpcAuto    := nTipReg

__oModelAut:SetOperation(nOpcAuto) // 3 - Inclusão | 4 - Alteração | 5 - Exclusão
__oModelAut:Activate() //ativa modelo

//---------------------------------------------------------
// Preencho os valores da CT1
//---------------------------------------------------------

oCT1 := __oModelAut:GetModel('CT1MASTER') //Objeto similar enchoice CT1 

For nCont := 1 to len(aAux)
    If substr(aAux[nCont,01],1,3) == "CT1"
        //oCT1:SETVALUE('CT1_CONTA','17')
        oCT1:SETVALUE(aAux[nCont,01],aAux[nCont,02])
    EndIf 
Next nCont 

//---------------------------------------------------------
// Preencho os valores da CVD
//---------------------------------------------------------

oCVD := __oModelAut:GetModel('CVDDETAIL') //Objeto similar getdados CVD

For nCont := 1 to len(aAux)
    If substr(aAux[nCont,01],1,3) == "CVD"
        oCVD:SETVALUE(aAux[nCont,01] , aAux[nCont,02]) 
    EndIf 
Next nCont 

//---------------------------------------------------------
// Preencho os valores da CTS
//---------------------------------------------------------

oCTS := __oModelAut:GetModel('CTSDETAIL') //Objeto similar getdados CTS
For nCont := 1 to len(aAux)
    If substr(aAux[nCont,01],1,3) == "CTS"
        oCTS:SETVALUE(aAux[nCont,01] , aAux[nCont,02]) 
    EndIf 
Next nCont 

If __oModelAut:VldData() //validacao dos dados pelo modelo

    __oModelAut:CommitData() //gravacao dos dados

Else

    aLog := __oModelAut:GetErrorMessage() //Recupera o erro do model quando nao passou no VldData

    //laco para gravar em string cLog conteudo do array aLog
    For nX := 1 to Len(aLog)
        If !Empty(aLog[nX])
            cLog += Alltrim(aLog[nX]) + CRLF
        EndIf
    Next nX
    

    lMsErroAuto := .T. //seta variavel private como erro
    //AutoGRLog(cLog) //grava log para exibir com funcao mostraerro
    //mostraerro()
    cErro := cLog
    lRet := .F. //retorna false

EndIf

__oModelAut:DeActivate() //desativa modelo

Return( lRet )
