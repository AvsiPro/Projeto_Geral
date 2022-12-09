#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} User Function AT410GRV 
    (long_description)
    @type  Function
    @author user
    @since 04/12/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function AT410GRV

Local aArea := GetArea()
Local nPos  := 0
Local lTeca := .F.
Local cCham := ''
Local nPosPr:= Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_PRODUTO"})
Local nPosCt:= Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_CONTRT"})

While !Empty(procname(nPos))
    If Alltrim(upper(procname(nPos))) $ 'TECA450'
        lTeca := .T.
        exit 
    EndIf 
    nPos++
EndDo

If lTeca
    cCham := Alltrim(AB7->AB7_NRCHAM) //substr(AB7->AB7_NRCHAM,1,8)+Strzero(val(substr(AB7->AB7_NRCHAM,8)),2)
    DbSelectArea("AB2")
    DbSetOrder(1)
    If Dbseek(xFilial("AB2")+cCham+aCols[nAcols,nPosPr]+AB7->AB7_NUMSER)
        aCols[nAcols,nPosCt] := AB2->AB2_XCONTR
    EndIf 

    M->C5_XTPPED := 'I'
Endif 

RestArea(aArea)
    
Return
