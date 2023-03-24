
#INCLUDE "RWMAKE.CH" 
#INCLUDE "TBICONN.CH"

User Function PILEST04()

Local _aCab1        :=  {}
Local _aItem        :=  {}
Local _atotitem     :=  {}
Local aSB2Sld       :=  {}
Local nCont         :=  0
Local _atuB7X       :=  {}
Local nX    

Private lMsHelpAuto := .t. // se .t. direciona as mensagens de help
Private lMsErroAuto := .f. //necessario a criacao

If Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","0201")
EndIf

cQuery := " select * from SLAPLIC.dbo.SB7_AUX "
cQuery += " WHERE B7SEQ IS NULL"

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
                    0,;
                    TRB->B7CR})
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
    Else 
        CriaSB2(aSB2Sld[nCont,02],aSB2Sld[nCont,03])
        aSB2Sld[nCont,07] := 0
        aSB2Sld[nCont,08] := aSB2Sld[nCont,04] 
        aSB2Sld[nCont,09] := "001"
    EndIf
    
Next nCont 

Asort(aSB2Sld,,,{|x,y| x[9] < y[9] })

cTM := ''
_aItem := {}
cNumero := ''


For nCont := 1 to len(aSB2Sld)

    If cTM <> aSB2Sld[nCont,09]
        If !Empty(cTM)
            //executa
            lMsErroAuto := .F.

            MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab1,_atotitem,3)

            If lMsErroAuto 
                For nX := 1 to len(_atuB7X)
                    _cNome := "PILEST04.txt"
                    ctxtErro := MostraErro(,_cNome)
                    cUpdQry := "UPDATE SLAPLIC.dbo.SB7_AUX "
                    cUpdQry += " SET B7ERR='"+ctxtErro+"'"
                    cUpdQry += " where B7CR='"+cvaltochar(_atuB7X[nX,01])+"'"
                    TcSqlExec(cUpdQry)
                Next nX
            Else 
                For nX := 1 to len(_atuB7X)
                    DbSelectArea("SD3")
                    DbSetOrder(2)
                    If Dbseek(_atuB7X[nX,03] + Avkey(cNumero,"D3_DOC") + _atuB7X[nX,02])
                        cRecno := SD3->(Recno())
                        cUpdQry := "UPDATE SLAPLIC.dbo.SB7_AUX "
                        cUpdQry += " SET B7SEQ='"+cvaltochar(cRecno)+"'"
                        cUpdQry += " where B7CR='"+cvaltochar(_atuB7X[nX,01])+"'"
                        TcSqlExec(cUpdQry)
                    EndIf
                Next nX
            EndIf
        EndIf 

        cNumero := NextNumero("SD3",2,"D3_DOC",.T.)
        cTM := aSB2Sld[nCont,09]

        _aCab1 := { {"D3_DOC"       ,cNumero   , NIL},;
                    {"D3_TM"        ,cTM       , NIL},;
                    {"D3_EMISSAO"   ,ddatabase , NIL}}

        
        _aItem := {}
        _atotitem := {}
        _atuB7X := {}
    EndIf 

    _aItem:={   {"D3_COD"   ,aSB2Sld[nCont,02]  ,NIL},;
                {"D3_UM"    ,Posicione("SB1",1,xFilial("SB1")+aSB2Sld[nCont,02],"B1_UM") ,NIL},; 
                {"D3_QUANT" ,aSB2Sld[nCont,08]  ,NIL},;
                {"D3_LOCAL" ,aSB2Sld[nCont,03] ,NIL}}

    Aadd(_atuB7X,{aSB2Sld[nCont,11],aSB2Sld[nCont,02],aSB2Sld[nCont,01]})

    aadd(_atotitem,_aitem) 
   

Next nCont 

If len(_atotitem) > 0 .AND. len(_aCab1) > 0
    //executa
    lMsErroAuto := .F.
    
    MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab1,_atotitem,3)

    If lMsErroAuto 
        For nX := 1 to len(_atuB7X)
            _cNome := "PILEST04.txt"
            ctxtErro := MostraErro(,_cNome)
            cUpdQry := "UPDATE SLAPLIC.dbo.SB7_AUX "
            cUpdQry += " SET B7ERR='"+ctxtErro+"'"
            cUpdQry += " where B7CR='"+cvaltochar(_atuB7X[nX,01])+"'"
            TcSqlExec(cUpdQry)
        Next nX
    Else 
        For nX := 1 to len(_atuB7X)
            DbSelectArea("SD3")
            DbSetOrder(2)
            If Dbseek(_atuB7X[nX,03] + Avkey(cNumero,"D3_DOC") + _atuB7X[nX,02])
                cRecno := SD3->(Recno())
                cUpdQry := "UPDATE SLAPLIC.dbo.SB7_AUX "
                cUpdQry += " SET B7SEQ='"+cvaltochar(cRecno)+"'"
                cUpdQry += " where B7CR='"+cvaltochar(_atuB7X[nX,01])+"'"
                TcSqlExec(cUpdQry)
            EndIf
        Next nX   
    EndIf
EndIf 

Return 
