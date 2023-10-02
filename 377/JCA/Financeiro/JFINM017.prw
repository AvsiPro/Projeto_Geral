#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

/*
    Programa que gera os movimentos em lote na rotina de concilialÁ„o banc·ria
	Este programa È chamado atravÈs do ponto de entrada F473VIEW.prw
     06-MIT 44 FINANCEIRO FIN017- Gerar boleto de Adiantamento - RA
 	https://docs.google.com/document/d/1lEfWblcls4_Z28sdq9QI0cB5Mw0om2Fc/edit
*/

User Function JFINM017()

    LOCAL aArray := {}

    PRIVATE lMsErroAuto := .F.

    Conout("----Inicio da Rotina Automatica!------")

    aArray := { { "E1_PREFIXO"  , "RET"             , NIL },;
        { "E1_NUM"      , SE1->E1_NUM          , NIL },;
        { "E1_TIPO"     , "RA"              , NIL },;
        { "E1_NATUREZ"  , SE1->E1_NATUREZ          , NIL },;
        { "E1_CLIENTE"  , SE1->E1_CLIENTE          , NIL },;
        { "E1_LOJA"     , SE1->E1_LOJA              , NIL },;
        { "E1_EMISSAO"  , DDATACRED         , NIL },;
        { "E1_VENCTO"   , DDATACRED         , NIL },;
        { "E1_VENCREA"  , DDATACRED         , NIL },;
        { "CBCOAUTO"    , cBanco            , NIL },;
        { "CAGEAUTO"    , cAgencia            , NIL },;
        { "CCTAAUTO"    , cConta         , NIL },;
        { "E1_VALOR"    , nValrec              , NIL }}

    MsExecAuto( { |x,y| FINA040(x,y)} , aArray, 3)  // 3 - Inclusao, 4 - Altera√ß√£o, 5 - Exclus√£o

Return
