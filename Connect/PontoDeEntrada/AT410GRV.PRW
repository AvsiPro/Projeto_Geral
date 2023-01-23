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
    Local nX    := 0
    Local lTeca := .F.
    // Local cCham := ''
    // Local cItem := "01"
    // Local cNumSer := ""
    // Local nPosPr:= Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_PRODUTO"})
    Local nPosCt:= Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_CONTRT"})
    Local nPosNs:= Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_NUMSERI"})
    Local nPosOs:= Ascan(aHeader,{|x| Alltrim(x[2]) == "C6_NUMOS"})

    While !Empty(procname(nPos))
        If Alltrim(upper(procname(nPos))) $ 'TECA450'
            lTeca := .T.
            exit 
        EndIf 
        nPos++
    EndDo

    If lTeca
        // cCham := Alltrim(AB7->AB7_NRCHAM) 
        // DbSelectArea("AB2")
        // AB2->(DbSetOrder(1))
        // While AB2->(Dbseek(xFilial("AB2")+AvKey(cCham, "AB2_NRCHAM")+cItem))
        //     for nX := 1 to len(aCols)
        //         if AllTrim(aCols[nX,nPosPr]) == AllTrim(AB2->AB2_CODPRO) .AND. !(AB2->AB2_XCBASE $ cNumSer)
        //             aCols[nX,nPosCt] := AB2->AB2_XCONTR
        //             aCols[nX,nPosNs] := AB2->AB2_XCBASE
        //         endif
        //     next
            
        //     cNumSer += AB2->AB2_XCBASE + "/"
        //     cItem := Soma1(cItem)

        // EndDo 

        for nX := 1 to len(aCols)
            DbSelectArea("AB7")
            DbSetOrder(1)
            AB7->(DbSeek(xFilial("AB7") + SubStr(aCols[nX,nPosOs], 1, 8)))

            DbSelectArea("AB2")
            DbSetOrder(1)
            AB2->(DbSeek(xFilial("AB2") + AB7->AB7_NRCHAM))
            
            aCols[nX,nPosCt] := AB2->AB2_XCONTR
            aCols[nX,nPosNs] := AB2->AB2_XCBASE

        next

        M->C5_XTPPED := 'I'

        MsgInfo("Pedido número: " + M->C5_NUM, "Fim!")

    Endif 

    RestArea(aArea)
    
Return
