
#INCLUDE "RWMAKE.CH" 
#INCLUDE "TBICONN.CH"

User Function PILEST04()

Local _aCab1        :=  {}
Local _aItem        :=  {}
Local _atotitem     :=  {}
Local aSB2Sld       :=  {}
Local nCont         :=  0

Private lMsHelpAuto := .t. // se .t. direciona as mensagens de help
Private lMsErroAuto := .f. //necessario a criacao

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","0201")
EndIf

cQuery := " select * from SLAPLIC.dbo.SB7_AUX "

If Select("TRB") > 0
    TRB->( dbclosearea() )
Endif
    
DbUseArea(.T.,'TOPCONN', TcGenQry(,,cQuery),"TRB", .T., .T.)
    
While !EOF()
    Aadd(aSB2Sld,{  TRB->B7FILIAL,;
                    TRB->B7COD,;
                    TRB->B7LOCAL,;
                    TRB->B7QUANT,;
                    TRB->B7DATA,;
                    TRB->B7SEQ,;
                    0,;
                    0,;
                    '',;
                    0})
    Dbskip()
EndDo 

DbSelectArea("SB2")
DbSetOrder(1)
For nCont := 1 to len(aSB2Sld)
    
    If DbSeek(aSB2Sld[nCont,01] + aSB2Sld[nCont,02] + aSB2Sld[nCont,03] )
        aSB2Sld[nCont,07] := SaldoSb2()
        aSB2Sld[nCont,08] := aSB2Sld[nCont,04] - (aSB2Sld[nCont,07])

        If aSB2Sld[nCont,08] <> 0
            If aSB2Sld[nCont,08] < 0
                aSB2Sld[nCont,09] := "501"
                aSB2Sld[nCont,08] := aSB2Sld[nCont,08] * (-1)
            Else
                aSB2Sld[nCont,09] := "001" 
            EndIf   
        EndIf 
    EndIf
    
Next nCont 

Asort(aSB2Sld,,,{|x,y| x[9] < y[9] })

cTM := aSB2Sld[1,9]
_aItem := {}
cNumero := ''

If !Empty(cTM)
    cNumero := NextNumero("SD3",2,"D3_DOC",.T.)
    _aCab1 := { {"D3_DOC"       ,cNumero    , NIL},;
                {"D3_TM"        ,cTM        , NIL},;
                {"D3_EMISSAO"   ,ddatabase  , NIL}}
EndIf 

For nCont := 1 to len(aSB2Sld)

    If cTM <> aSB2Sld[nCont,09]
        //executa
        lMsErroAuto := .F.

        MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab1,_atotitem,3)

        If lMsErroAuto 
            Mostraerro() 
            DisarmTransaction() 
            break
        EndIf

        cNumero := NextNumero("SD3",2,"D3_DOC",.T.)

        _aCab1 := { {"D3_DOC"       ,cNumero   , NIL},;
                    {"D3_TM"        ,cTM       , NIL},;
                    {"D3_EMISSAO"   ,ddatabase , NIL}}

        cTM := aSB2Sld[nCont,09]
        _aItem := {}
    EndIf 

    _aItem:={   {"D3_COD"   ,aSB2Sld[nCont,02]  ,NIL},;
                {"D3_UM"    ,Posicione("SB1",1,xFilial("SB1")+aSB2Sld[nCont,02],"B1_UM") ,NIL},; 
                {"D3_QUANT" ,aSB2Sld[nCont,08]  ,NIL},;
                {"D3_LOCAL" ,aSB2Sld[nCont,03] ,NIL}}

    aadd(_atotitem,_aitem) 
   

Next nCont 

If len(_atotitem) > 0
    //executa
    lMsErroAuto := .F.
    
    MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab1,_atotitem,3)

    If lMsErroAuto 
        Mostraerro() 
        DisarmTransaction() 
        break
    EndIf
EndIf 

Return 
