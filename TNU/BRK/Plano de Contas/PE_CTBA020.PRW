#INCLUDE "PROTHEUS.CH"
#include "TbiConn.ch"
#include "topconn.ch"
#INCLUDE "FWMVCDEF.CH"

Static __oModelAut := NIL //variavel oModel para substituir msexecauto em MVC

User Function CTBA020

Local aParam     := PARAMIXB
Local xRet       := .T.
Local oObj       := ''
Local cIdPonto   := ''
Local cIdModel   := ''
Local lIsGrid    := .F.

//Local nLinha     := 0
//Local nQtdLinhas := 0
Local nNx     
Local aFilial := FWLoadSM0()
Local cFilAtual := cFilAnt
Local CEmpAtual := cEmpAnt
Local aDadoCT1  := {}

If aParam <> NIL
      
  oObj       := aParam[1]
  cIdPonto   := aParam[2]
  cIdModel   := aParam[3]
  lIsGrid    := ( Len( aParam ) > 3 )
      
                  
       
  If cIdPonto == 'FORMCOMMITTTSPOS' .AND. cEmpAnt == '11' .AND. cFilAnt == '010101' 
    //ApMsgInfo('Chamada apos a gravação total do modelo e dentro da transação (MODELCOMMITTTS).' + CRLF + 'ID ' + cIdModel )

    If aParam[4] //Inclusão

      If MsgYesNo("Deseja replicar o plano de contas para as demais filiais?", "Inclusão de Palno de Contas")

        dbSelectArea("SX3")
        SX3->(DbGoTop())
        SX3->(dbSetOrder(1))
        SX3->(dbSeek('CT1'))
        While SX3->(!EOF()) .AND. (SX3->X3_ARQUIVO == 'CT1') //.and. (SX3->X3_CONTEXT == 'R')

          If SX3->X3_CONTEXT <> 'R' .and. Alltrim(SX3->X3_CAMPO) <> "CT1_ESTOUR" .and. Alltrim(SX3->X3_CAMPO) <> "CT1_FILIAL" 
   
            AADD(aDadoCT1,{Alltrim(SX3->X3_CAMPO),CT1->&(Alltrim(SX3->X3_CAMPO))}) 

          EndIf  

	        SX3->(dbSkip())

        EndDo  

        For nNx :=1  to Len(aFilial)

         If aFilial[nNx][1] == cEmpAnt .and. aFilial[nNx][2] <> cFilAnt
            
            BREXECCT(3,aFilial[nNx][2],aFilial[nNx][1],aDadoCT1) 
          EndIf   

        Next nNx  

      cEmpAnt := CEmpAtual
      cFilAnt := cFilAtual

      EndIf

    EndIf
            
		/*Parâmetros Recebidos:

		1     O        Objeto do formulário ou do modelo, conforme o caso
		2     C        ID do local de execução do ponto de entrada
		3     C        ID do formulário
		4     L        Se .T. indica novo registro (Inclusão) se .F. registro já existente (Alteração / Exclusão)*/
            
  EndIf

EndIf

Return xRet

Static Function BREXECCT(nOPC,cFilCta,cEmpCta,aDadoCT1)

Local nOpcAuto := nOPC
Local nX
Local oCT1
Local aLog
Local cLog :=""
Local lRet := .T.
Local nNx

cEmpAnt := cEmpCta
cFilAnt := cFilCta

If __oModelAut == Nil //somente uma unica vez carrega o modelo CTBA020-Plano de Contas CT1
  __oModelAut := FWLoadModel('CTBA020')
EndIf


__oModelAut:SetOperation(nOpcAuto) // 3 - Inclusão | 4 - Alteração | 5 - Exclusão
__oModelAut:Activate() //ativa modelo

//---------------------------------------------------------
// Preencho os valores da CT1
//---------------------------------------------------------


oCT1 := __oModelAut:GetModel('CT1MASTER') //Objeto similar enchoice CT1 

oCT1:SETVALUE('CT1_FILIAL' ,cFilCta)

For nNx := 1 to Len(aDadoCT1)

  
  oCT1:SETVALUE(aDadoCT1[nNx][1], aDadoCT1[nNx][2])

Next nNx


//---------------------------------------------------------
// Preencho os valores da CVD
//---------------------------------------------------------

/*oCVD := __oModelAut:GetModel('CVDDETAIL') //Objeto similar getdados CVD

SX3->(DbGoTop())
SX3->(dbSetOrder(1))
SX3->(dbSeek('CVD'))

While SX3->(!EOF()) .AND. (SX3->X3_ARQUIVO == 'CVD') //.and. (SX3->X3_CONTEXT == 'R')

  If SX3->X3_CONTEXT <> 'R' .and.  Alltrim(SX3->X3_CAMPO) <> "CVD_CONTA"
    If Alltrim(SX3->X3_CAMPO) == "CVD_FILIAL"

      oCVD:SETVALUE('CVD_FILIAL' ,cFilCta)

    Else

      oCVD:SETVALUE(Alltrim(SX3->X3_CAMPO), CVD->&(Alltrim(SX3->X3_CAMPO)))

    EndIf  
  EndIf  

	SX3->(dbSkip())

EndDo  


//---------------------------------------------------------
// Preencho os valores da CTS
//---------------------------------------------------------


oCTS := __oModelAut:GetModel('CTSDETAIL') //Objeto similar getdados CTS

SX3->(DbGoTop())
SX3->(dbSetOrder(1))
SX3->(dbSeek('CTS'))

While SX3->(!EOF()) .AND. (SX3->X3_ARQUIVO == 'CTS') //.and. (SX3->X3_CONTEXT == 'R')

  If SX3->X3_CONTEXT <> 'R' .and. Alltrim(SX3->X3_CAMPO) <> "CTS_IDENTI"
    If Alltrim(SX3->X3_CAMPO) == "CTS_FILIAL"

      oCTS:SETVALUE('CTS_FILIAL' ,cFilCta)

    Else

      oCTS:SETVALUE(Alltrim(SX3->X3_CAMPO), CTS->&(Alltrim(SX3->X3_CAMPO)))

    EndIf  
  EndIf
	SX3->(dbSkip())

EndDo */ 


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
  AutoGRLog(cLog) //grava log para exibir com funcao mostraerro
  mostraerro()
  lRet := .F. //retorna false

EndIf

__oModelAut:DeActivate() //desativa modelo


Return( lRet )




