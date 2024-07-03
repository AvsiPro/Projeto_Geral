#INCLUDE 'PROTHEUS.CH'
/*
    Ponto de entrada rotina de abastecimento manual e em lote

    utilizado para gerar a movimentação do arla junto com o abastecimento
    e tambem para grar o codigo do abastecimento na contabilização

*/
User Function NGUTIL4C()

Local aArea     :=  GetArea()
Local lMnt656   :=  FUNNAME() == 'MNTA656'
Local lMnt655   :=  FUNNAME() == 'MNTA655'

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

    If !Empty(M->TQN_ZPRARL)
        MovArla()
    EndIf 

EndIf

RestArea(aArea)

Return
/*/{Protheus.doc} MovArla
    (long_description)
    @type  Static Function
    @author user
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function MovArla()

Local _aItem    :=  {}
Local _atotitem :=  {}
Local _aCab1    :=  {}
Local cLocPad   := Posicione("SB1",1,xFilial("SB1")+M->TQN_ZPRARL,"B1_LOCPAD")
Local cUnMed    := Posicione("SB1",1,xFilial("SB1")+M->TQN_ZPRARL,"B1_UM")
Local cDoc      := GetSXenum("SD3","D3_COD")

Private lMsErroAuto := .F.

ConfirmSX8()

_aItem:={{"D3_COD"      ,M->TQN_ZPRARL      ,NIL},;
        {"D3_UM"        ,cUnMed             ,NIL},;
        {"D3_QUANT"     ,M->TQN_QTDARL      ,NIL},;
        {"D3_LOCAL"     ,cLocPad            ,NIL},;
        {"D3_LOTECTL"   ,""                 ,NIL},;
        {"D3_LOCALIZ"   ,""                 ,NIL}}

aadd(_atotitem,_aitem)

_aCab1 := { {"D3_DOC"       ,cDoc           , NIL},;
            {"D3_TM"        ,SD3->D3_TM     , NIL},;
            {"D3_CC"        ,SD3->D3_CC     , NIL},;
            {"D3_CONTA"     ,SD3->D3_CONTA  , NIL},;
            {"D3_XABAST"    ,M->TQN_NABAST  , NIL},;
            {"D3_EMISSAO"   ,ddatabase      , NIL}}

MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab1,_atotitem,3)
                
If lMsErroAuto
    Mostraerro()
EndIf

Return
