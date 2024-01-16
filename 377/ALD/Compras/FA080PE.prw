#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} User Function nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 19/12/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function FA080PE()

Local aVetSE2 := {}
Local cChave  := SE2->E2_FILIAL+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA

Private lMsErroAuto := .F.


If SE2->E2_PREFIXO == "ADT"

    aArea := GetArea()
    aAdd(aVetSE2, {"E2_FILIAL",  SE2->E2_FILIAL     ,  Nil})
    aAdd(aVetSE2, {"E2_NUM",     SE2->E2_NUM        ,  Nil})
    aAdd(aVetSE2, {"E2_PREFIXO", 'PA'               ,  Nil})
    aAdd(aVetSE2, {"E2_PARCELA", SE2->E2_PARCELA    ,  Nil})
    aAdd(aVetSE2, {"E2_TIPO",    'PA'               ,  Nil})
    aAdd(aVetSE2, {"E2_NATUREZ", SE2->E2_NATUREZ    ,  Nil})
    aAdd(aVetSE2, {"E2_FORNECE", SE2->E2_FORNECE    ,  Nil})
    aAdd(aVetSE2, {"E2_LOJA",    SE2->E2_LOJA       ,  Nil})
    aAdd(aVetSE2, {"E2_EMISSAO", dDatabase+1          ,  Nil})
    aAdd(aVetSE2, {"E2_VENCTO",  SE2->E2_VENCTO     ,  Nil})
    aAdd(aVetSE2, {"E2_VENCREA", SE2->E2_VENCREA    ,  Nil})
    aAdd(aVetSE2, {"E2_VALOR",   SE2->E2_VALOR      ,  Nil})
    //aAdd(aVetSE2, {"E2_CC"   ,   SE2->E2_CC         ,  Nil})
    aAdd(aVetSE2, {"E2_HIST",    cUserName+" - "+cvaltochar(ddatabase)+" - "+cvaltochar(time())   ,  Nil})
    aAdd(aVetSE2, {"E2_MOEDA",   1                  ,  Nil})
    aAdd(aVetSE2, {"E2_TITORIG", cChave            ,  Nil})
    

    aAdd(aVetSE2, {"AUTBANCO"   , cBanco   ,   NIL})
    aAdd(aVetSE2, {"AUTAGENCIA" , cAgencia  ,   NIL})
    aAdd(aVetSE2, {"AUTCONTA"   , cConta    ,   NIL})

    //Inicia o controle de transação
    Begin Transaction
    //Chama a rotina automática
    lMsErroAuto := .F.
    MSExecAuto({|x,y| FINA050(x,y)}, aVetSE2, 3)

    //Se houve erro, mostra o erro ao usuário e desarma a transação
    If lMsErroAuto
        MostraErro()
        DisarmTransaction()
    
    EndIf
    //Finaliza a transação
    End Transaction

    RestArea(aArea)

    Reclock("SE2",.F.)
    SE2->(DbDelete())
    SE2->(Msunlock())
    DBSelectArea("SE5")
    DbSetOrder(7)
    If Dbseek(cChave)
        Reclock("SE5",.F.)
        SE5->(DbDelete())
        SE5->(Msunlock())
    EndIf 
EndIf 



Return
