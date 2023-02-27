
#INCLUDE "RWMAKE.CH" 
#INCLUDE "TBICONN.CH"

User Function TMATA241()

Local _aCab1        :=  {}
Local _aItem        :=  {}
Local _atotitem     :=  {}
Local cTMSai        :=  "501"
Local cTMEnt        :=  "001"
Local cCodProd      :=  "PRODUTO "
Local cUnid         :=  "PC "
Local aSB2Sld       :=  {}

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
                    TRB->B7SEQ})
    Dbskip()
EndDo 

/*
_aCab1 := { {"D3_DOC" ,NextNumero("SD3",2,"D3_DOC",.T.), NIL},;
            {"D3_TM" ,cCodigoTM , NIL},;
            {"D3_CC" ,"        ", NIL},;
            {"D3_EMISSAO" ,ddatabase, NIL}}


_aItem:={   {"D3_COD" ,cCodProd ,NIL},;
            {"D3_UM" ,cUnid ,NIL},; 
            {"D3_QUANT" ,1 ,NIL},;
            {"D3_LOCAL" ,"01" ,NIL},;
            {"D3_LOTECTL" ,"",NIL},;
            {"D3_LOCALIZ" , "ENDEREÇO            ",NIL}}

aadd(_atotitem,_aitem) 

MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab1,_atotitem,3)

If lMsErroAuto 
    Mostraerro() 
    DisarmTransaction() 
    break
EndIf
*/

Return 
