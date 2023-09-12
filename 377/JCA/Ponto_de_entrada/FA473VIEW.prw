#INCLUDE 'TOTVS.CH'
#INCLUDE "FWMVCDEF.CH"
   
/*
    {Protheus.doc} F473VIEW
    Ponto de entrada F473VIEW para adicionar rotina em outras ações
    na rotina FINA473 Conciliação automatica
    02-MIT 44 FINANCEIRO FIN006 - Conciliacao Automatica - inclusao de tarifas em massa
    https://docs.google.com/document/d/1nkTlKsGJ1tOAhvsvDDAPpwq4RHwnh0lQ/edit
*/

User Function F473VIEW() 

    Local aRet As Object

    aRet  := {}

    aAdd(aRet,  {"oView",   "AddUserButton", 'Efetivação em lote'   ,''   , {|oView| U_JCATARIF1(oView)}     }  )

Return(aRet)

