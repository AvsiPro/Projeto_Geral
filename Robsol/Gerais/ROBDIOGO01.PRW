#INCLUDE 'protheus.ch'

/*/{Protheus.doc} User Function ROBDIOGO01
    (long_description)
    @type  Function
    @author user
    @since 07/10/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function ROBDIOGO01()
    
    Local nCount     :=    1
    Local cNum       :=    ''
    Local cNumAux    :=    ''

    IF Select("SM0") == 0
        RpcSetType(3)
        RPCSetEnv("01","0103")
    ENDIF

    DbSelectArea('SC6')

    DBGOTO(1)
    while !EOF()
        if SC6->C6_ITEM == '**'
            cNum := SOMA1(cNumAux)
            RecLock("SC6", .F.)	
            SC6->C6_ITEM := cNum
            MsUnLock()
        endif
        cNumAux := SC6->C6_ITEM
        nCount++
        DBGOTO(nCount)
    end

Return
