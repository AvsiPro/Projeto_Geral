#INCLUDE 'PROTHEUS.CH'

User Function NGUTIL4C()

Local aArea     :=  GetArea()
Local cFilBem   :=  ''
Local lMnt656   :=  FUNNAME() == 'MNTA656'
Local lMnt655   :=  FUNNAME() == 'MNTA655'
/*
If INCLUI .AND. lMnt656
    cFilBem := Posicione("ST9",1,xFilial("ST9")+aCols[1,3],"T9_ZFILORI")
    gerAbstOri(cFilBem)
EndIf
*/
//Grava o numero do abastecimento CT2 / SD3
If Inclui .And. (lMnt656 .Or.lMnt655)
    cAbast := Iif(lMnt656 .And. Type('cAbast') == 'C',cAbast, M->TQN_NABAST)

    If CT2->(FieldPos("CT2_XABAST")) > 0 .And. SD3->D3_DOC $ CT2->CT2_HIST .And. SD3->D3_FILIAL == CT2->CT2_FILORI
        RecLock('CT2', .F.)
            CT2->CT2_XABAST := cAbast
        CT2->(MsUnlock())
    EndIf

    If SD3->(FieldPos("D3_XABAST")) > 0
        RecLock('SD3', .F.)
            SD3->D3_XABAST := cAbast
        SD3->(MsUnlock())
    EndIf
EndIf

RestArea(aArea)

Return

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 07/09/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function gerAbstOri(cFilBem)

Local aArea     :=  GetArea()
Local aAbast    :=  {}
Local nPosPlc   :=  Ascan(aHeader,{|x| x[2] == "TQN_PLACA"})
Local nPosFrt   :=  Ascan(aHeader,{|x| x[2] == "TQN_FROTA"})
Local nPosDta   :=  Ascan(aHeader,{|x| x[2] == "TQN_DTABAS"})
Local nPosHra   :=  Ascan(aHeader,{|x| x[2] == "TQN_HRABAS"})
Local nPosQtd   :=  Ascan(aHeader,{|x| x[2] == "TQQ_QUANT"})
Local nPosHod   :=  Ascan(aHeader,{|x| x[2] == "TQN_HODOM"})
Local nPosCmt   :=  Ascan(aHeader,{|x| x[2] == "TQN_CODMOT"})
Local nCont 

For nCont := 1 to len(aCols)
    aAuxHr := separa(aCols[nCont,nPosHra],":")
    aAuxHr[2] := strzero(val(aAuxHr[2])+10,2)
    If val(aAuxHr[2]) > 59
        aAuxHr[2] := '00'
        aAuxHr[1] := strzero(val(aAuxHr[1])+1,2)
    EndIf 

    aCols[nCont,nPosHra] := aAuxHr[1]+":"+aAuxHr[2]

    cCnpj := Posicione("TQN",1,cfilant+aCols[nCont,nPosFrt],"TQN_CNPJ")
    cCodC := Posicione("TQN",1,cfilant+aCols[nCont,nPosFrt],"TQN_CODCOM")

    aAbast := { {'TQN_FILIAL', cFilant                                           , Nil },;
                {'TQN_PLACA' , PadR( aCols[nCont,nPosPlc] , TAMSX3("TQN_PLACA")[1] ) , Nil },;
                {'TQN_FROTA' , PadR( aCols[nCont,nPosFrt] , TAMSX3("TQN_FROTA")[1] ) , Nil },;
                {'TQN_CNPJ'  , PadR( cCnpj            , TAMSX3("TQN_CNPJ")[1] )  , Nil },;
                {'TQN_CODCOM', PadR( cCodC            , TAMSX3("TQN_CODCOM")[1] ), Nil },;
                {'TQN_DTABAS', aCols[nCont,nPosDta]+1                            , Nil },;
                {'TQN_HRABAS', aCols[nCont,nPosHra]                              , Nil },;
                {'TQN_XARLA' , '00310001'                                        , Nil },;
                {'TQN_QUANT' , 1                                                 , Nil },;
                {'TQN_VALUNI', 1                                                 , Nil },;
                {'TQN_VALTOT', 1                                                 , Nil },;
                {'TQN_CODMOT', PadR( aCols[n,nPosCmt] , TAMSX3("TQN_CODMOT")[1] ), Nil },;
                {'TQN_POSTO' , PadR( TTA->TTA_POSTO   , TAMSX3("TQN_POSTO")[1] ) , Nil },;
                {'TQN_LOJA'  , PadR( TTA->TTA_LOJA    , TAMSX3("TQN_LOJA")[1] )  , Nil },;
                {'TQN_NOTFIS', PadR( 'CFOLHA'         , TAMSX3("TQN_NOTFIS")[1] ), Nil }}

/*
{'TQN_QUANT' , aCols[nCont,nPosQtd]                              , Nil },;
                {'TQN_VALUNI', 3.57                                              , Nil },;
                {'TQN_VALTOT', 35.70                                             , Nil },;
                
{'TQN_HODOM' , aCols[nCont,nPosHod]                                             , Nil },;
                {'TQN_TANQUE', PadR( TTA->TTA_TANQUE  , TAMSX3("TQN_TANQUE")[1] ), Nil },;
                {'TQN_BOMBA' , PadR( TTA->TTA_BOMBA   , TAMSX3("TQN_BOMBA")[1] ) , Nil },;
                */
    lMSHelpAuto := .T. // Não apresenta erro em tela
    lMSErroAuto := .F. // Caso a variável torne-se .T. apos MsExecAuto, apresenta erro em tela     

    MSExecAuto( { | v, x, y | MNTA655( v, x, y ) }, , aAbast, 3 )

    If lMsErroAuto
        Mostraerro()
    ELSE
        ConOut( "Inclusão com sucesso")
    EndIf

Next nCont 

RestArea(aArea)

Return

user function xtesaba

Local aAbast := {}
 
    //Abre empresa/filial/módulo/arquivos - deve ser comentada a função RPCSetEnv se quiser verificar as mensagens de erro em tela
    RPCSetEnv('01','00020087','','','GFR')
 
    // Itens obrigatórios para inclusão do abastecimento para posto interno
    aAbast := { {'TQN_PLACA' , PadR( 'AAA1700 '       , TAMSX3("TQN_PLACA")[1] ) , Nil },;
                {'TQN_FROTA' , PadR( '17000'          , TAMSX3("TQN_FROTA")[1] ) , Nil },;
                {'TQN_CNPJ'  , PadR( '09338337000501' , TAMSX3("TQN_CNPJ")[1] )  , Nil },;
                {'TQN_CODCOM', PadR( 'DA '            , TAMSX3("TQN_CODCOM")[1] ), Nil },;
                {'TQN_DTABAS', StoD( '20230905' )                                , Nil },;
                {'TQN_HRABAS', '15:05'                                           , Nil },;
                {'TQN_TANQUE', PadR( '01'             , TAMSX3("TQN_TANQUE")[1] ), Nil },;
                {'TQN_BOMBA' , PadR( '01'             , TAMSX3("TQN_BOMBA")[1] ) , Nil },;
                {'TQN_QUANT' , 10                                                , Nil },;
                {'TQN_VALUNI', 3.57                                              , Nil },;
                {'TQN_VALTOT', 35.70                                             , Nil },;
                {'TQN_HODOM' , 4050                                              , Nil },;
                {'TQN_CODMOT', PadR( '000002'         , TAMSX3("TQN_CODMOT")[1] ), Nil },;
                {'TQN_POSTO' , PadR( '000007'         , TAMSX3("TQN_POSTO")[1] ) , Nil },;
                {'TQN_LOJA'  , PadR( '01'             , TAMSX3("TQN_LOJA")[1] )  , Nil },;
                {'TQN_NOTFIS', PadR( '33'             , TAMSX3("TQN_NOTFIS")[1] ), Nil }}
 
    lMSHelpAuto := .T. // Não apresenta erro em tela
    // Caso a variável torne-se .T. após MsExecAuto, apresenta erro em tela
    //(se não possuir a função RPCSetEnv, com esta função não será apresentada mensagem em tela)
    lMSErroAuto := .F.
     
    MSExecAuto( { | v, x, y | MNTA655( v, x, y ) }, , aAbast, 3 )
    If lMsErroAuto
        If !IsBlind() //Apresentará mensagem com o MostraErro se não utilizar RPCSetEnv.
            MostraErro()
        Else          //Não apresentará mensagem, pois utiliza a função RPCSetEnv.
            cError := MostraErro(GetSrvProfString("Startpath", ""), "MNTA655EXEC_"+DTOS(DATE())+"_"+;
                      Left(Time(),2)+SubStr(Time(),4,2)+".LOG") // Armazena mensagem de erro na raiz (StartPath).
            ConOut( cError)
        EndIf
    EndIf

return
