#INCLUDE 'PROTHEUS.CH'

User Function NGUTIL4C()

Local aArea     :=  GetArea()
Local cFilBem   :=  ''
Local lMnt656   :=  FUNNAME() == 'MNTA656'
Local lMnt655   :=  FUNNAME() == 'MNTA655'

If INCLUI .AND. lMnt656
    cFilBem := Posicione("ST9",1,xFilial("ST9")+aCols[1,3],"T9_ZFILORI")
    gerAbstOri(cFilBem)
EndIf

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
Local cBkpFil   :=  CFILANT
Local cBkpEmp   :=  cEmpAnt
Local aAbast    :=  {}
Local nPosPlc   :=  Ascan(aHeader,{|x| x[2] == "TQN_PLACA"})
Local nPosFrt   :=  Ascan(aHeader,{|x| x[2] == "TQN_FROTA"})
Local nPosDta   :=  Ascan(aHeader,{|x| x[2] == "TQN_DTABAS"})
//Local nPosHra   :=  Ascan(aHeader,{|x| x[2] == "TQN_HRABAS"})
//Local nPosQtd   :=  Ascan(aHeader,{|x| x[2] == "TQQ_QUANT"})
//Local nPosHod   :=  Ascan(aHeader,{|x| x[2] == "TQN_HODOM"})
Local nPosCmt   :=  Ascan(aHeader,{|x| x[2] == "TQN_CODMOT"})

cFilant := cFilBem
/*cNumEmp := cEmpAnt + cFilAnt
OpenFile(cNumEmp)*/
//RPCSetEnv('01','00020087','','','GFR')

/*
aAbast := { {'TQN_FILIAL', cFilBem               , Nil },;
            {'TQN_NABAST', '000000000000007'     , Nil },;
            {'TQN_PLACA' , aCols[n,nPosPlc]      , Nil },;
            {'TQN_FROTA' , aCols[n,nPosFrt]      , Nil },;
            {'TQN_POSTO' , '000007'              , Nil },;
            {'TQN_CNPJ'  , '09338337000501'      , Nil },;
            {'TQN_LOJA'  , '01'                  , Nil },;
            {'TQN_CODCOM', 'DA '                 , Nil },;
            {'TQN_DTABAS', aCols[n,nPosDta]      , Nil },;
            {'TQN_HRABAS', aCols[n,nPosHra]      , Nil },;
            {'TQN_TANQUE', '01'                  , Nil },;
            {'TQN_BOMBA' , '01 '                 , Nil },;
            {'TQN_HODOM' , aCols[n,nPosHod]      , Nil },;
            {'TQN_QUANT' , 11                    , Nil },;
            {'TQN_VALUNI', 4                     , Nil },;
            {'TQN_VALTOT', 11 * 4                , Nil },;
            {'TQN_CODMOT', aCols[n,nPosCmt]      , Nil }} */

aAbast := { {'TQN_FILIAL', cFilBem                                           , Nil },;
            {'TQN_PLACA' , PadR( aCols[n,nPosPlc] , TAMSX3("TQN_PLACA")[1] ) , Nil },;
            {'TQN_FROTA' , PadR( aCols[n,nPosFrt] , TAMSX3("TQN_FROTA")[1] ) , Nil },;
            {'TQN_CNPJ'  , PadR( '09338337000501' , TAMSX3("TQN_CNPJ")[1] )  , Nil },;
            {'TQN_CODCOM', PadR( 'DA'             , TAMSX3("TQN_CODCOM")[1] ), Nil },;
            {'TQN_DTABAS', aCols[n,nPosDta]                                  , Nil },;
            {'TQN_HRABAS', '12:45'                                           , Nil },;
            {'TQN_TANQUE', PadR( '01'             , TAMSX3("TQN_TANQUE")[1] ), Nil },;
            {'TQN_BOMBA' , PadR( '01'             , TAMSX3("TQN_BOMBA")[1] ) , Nil },;
            {'TQN_QUANT' , 10                                                , Nil },;
            {'TQN_VALUNI', 3.57                                              , Nil },;
            {'TQN_VALTOT', 35.70                                             , Nil },;
            {'TQN_HODOM' , 1068                                              , Nil },;
            {'TQN_CODMOT', PadR( aCols[n,nPosCmt] , TAMSX3("TQN_CODMOT")[1] ), Nil },;
            {'TQN_POSTO' , PadR( '000007'         , TAMSX3("TQN_POSTO")[1] ) , Nil },;
            {'TQN_LOJA'  , PadR( '01'             , TAMSX3("TQN_LOJA")[1] )  , Nil },;
            {'TQN_NOTFIS', PadR( CFOLHA           , TAMSX3("TQN_NOTFIS")[1] ), Nil }}
//
//aCols[n,nPosHra]
lMSHelpAuto := .T. // Não apresenta erro em tela
lMSErroAuto := .F. // Caso a variável torne-se .T. apos MsExecAuto, apresenta erro em tela     

MSExecAuto( { | v, x, y | MNTA655( v, x, y ) }, , aAbast, 3 )

If lMsErroAuto
    /*If !IsBlind()          
        ConOut( "Ocorreu um error")
    Else
        cError := MostraErro( GetSrvProfString("Startpath","") , ) // Armazena mensagem de erro na raiz.
        ConOut( cError)
    EndIf*/
ELSE
    ConOut( "Inclusão com sucesso")
EndIf


cEmpAnt := cBkpEmp
cFilant := cBkpFil
cNumEmp := cEmpAnt + cFilAnt
 
//6. Chama a função OpenFile para voltar para a filial de origem
//OpenFile(cNumEmp)
//RPCSetEnv(cEmpAnt,cFilant,'','','GFR')

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
