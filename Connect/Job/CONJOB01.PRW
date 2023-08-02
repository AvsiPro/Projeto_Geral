#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} User Function nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 02/08/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function CONJOB01()

Local cQuery

Local cHri     :=   '00:00'
Local cHrf     :=   '23:59'
Local aAux     :=   {}
Local aVendas  :=   {}
Local dUltLei
Local dLeiFim
Local nX,nY
Local aList8   :=   {}
Local aMaqSVM  :=   {}

Private aList8B  :=   {}

IF Select("SM0") == 0
    RpcSetType(3)
    RPCSetEnv("01","0101")
ENDIF

cQuery := "SELECT AAM_CONTRT,AAM_XDIALT,AAN_XCBASE,AAM_CODCLI,AAM_LOJA,AAN_ITEM,AAN_CODPRO"
cQuery += " FROM "+RetSQLName("AAN")+" AAN"
cQuery += " INNER JOIN "+RetSQLName("AAM")+" AAM ON AAM_FILIAL=AAN_FILIAL AND AAM_CONTRT=AAN_CONTRT"
cQuery += "     AND AAM_XDIALT<>' ' AND AAM.D_E_L_E_T_=' '"
cQuery += " WHERE AAN.D_E_L_E_T_=' '"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("CONFATC01.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    Aadd(aAux,{ TRB->AAM_CONTRT,;   //01
                TRB->AAM_XDIALT,;   //02
                TRB->AAN_XCBASE,;   //03
                TRB->AAM_CODCLI,;   //04
                TRB->AAM_LOJA,;     //05
                TRB->AAN_ITEM,;     //06
                TRB->AAN_CODPRO,;   //07
                "",;                //08
                "",;                //09
                ""})                //10
    DbSkip()
EndDo 

For nX := 1 to len(aAux)
    dUltLei := UltLei(aAux[nX,03])
    If Empty(dtos(dUltLei))
        dUltLei := ddatabase-30
    EndIf

    dLeiFim := ddatabase-1

    //Exemplo URL enviar ao cliente
    //https://vmpay.vertitecnologia.com.br/verti/reports/vends?
    //dataInicial=30/06/2023-00:00&dataFinal=01/08/2023-23:59&machine_id=36245
    aAux[nX,08] := "https://vmpay.vertitecnologia.com.br/verti/reports/vends?"
    aAux[nX,08] += "dataInicial="+cvaltochar(dUltLei)+"-"+cHri
    aAux[nX,08] += "&dataFinal="+cvaltochar(dLeiFim)+"-"+cHrf
    aAux[nX,08] += "&machine_id="+alltrim(aAux[nX,03])

    aAux[nX,09] := dUltLei
    aAux[nX,10] := dLeiFim

    Aadd(aVendas, U_CONWSC03(aAux[nX,03],2,dUltLei,dLeiFim,cHri,cHrf))
Next nX

IF len(aVendas) > 0
    aList8B := {}
//'Data','Seleção','Produto','Descrição','Quant. Apont.',chapa,codigo cliente
    FOR nX := 1 TO len(aVendas) 
        aList8 := {}
        If aVendas[nX] != NIL
            If len(aVendas[nX]) > 2
                for nY := 3 to len(aVendas[nX])
                    cCodProt := ''
                    IF aVendas[nX,nY,05] == "null"
                        cCodProt := "Nao Consta"
                    ELSE
                        cCodProt := aVendas[nX,nY,05]
                    ENDIF
                    
                    if cCodProt != "Nao Consta"
                        cDesc := Posicione("SB1",1,xFilial("SB1")+cCodProt,"B1_DESC")
                    else
                        cDesc := "Codigo do produto nao se encontra no VMPay"
                    endif

                    nPosit := Ascan(aList8,{|x| x[2] == aVendas[nX,nY,01]})
                    IF nPosit == 0
                        cData := ddatabase //stod(StrTran(SubStr(aVendas[nX,nY,02], 1, 10), '-')) //StrTran(StrTran(SubStr(aVendas[nX,nY,02], 1, 10), '-', '/'), 'T', ' ')
                        Aadd(aList8,{cvaltochar(cData),;
                                    aVendas[nX,nY,01],;
                                    cCodProt,;
                                    cDesc,;
                                    val(aVendas[nX,nY,03]),;
                                    aVendas[nX,2],;
                                    aAux[nX,04],;
                                    IF(val(aVendas[nX,nY,03])>1,val(aVendas[nX,nY,04])/val(aVendas[nX,nY,03]),val(aVendas[nX,nY,04])),;
                                    aAux[nX,01],;
                                    aAux[nX,03],;
                                    aAux[nX,05],;
                                    aAux[nX,06],;
                                    aAux[nX,07],;
                                    aAux[nX,08],;
                                    aAux[nX,09],;
                                    aAux[nX,10]})
                    ELSE
                        aList8[nPosit,05] += val(aVendas[nX,nY,03])
                    ENDIF
                next nY
            EndIf
        EndIf 
        

        If len(aList8) > 0
            Aadd(aList8B, {})
            
            Aadd(aList8B[len(aList8B)], aList8)
        Else 
            Aadd(aMaqSVM,{aAux[nX,01],aAux[nX,03],aAux[nX,04],aAux[nX,05],aAux[nX,06]})
        EndIf 
    NEXT nX
    
ENDIF

savevend()

Return


/*/{Protheus.doc} UltLei(aList[nX,02])
    (long_description)
    @type  Static Function
    @author user
    @since 11/01/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function UltLei(cAtivo)

Local aArea :=  GetArea()
Local cQuery 
Local dRet 

cQuery := "SELECT MAX(Z08_DATA) AS ULTIMA FROM "+RetSQLName("Z08")
cQuery += " WHERE Z08_FILIAL BETWEEN ' ' AND 'ZZ' AND D_E_L_E_T_=' '
cQuery += " AND Z08_NUMSER='"+cAtivo+"'"

if Select("TRB") > 0
    DBSELECTAREA("TRB")
    DBCLOSEAREA()
endif

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

dRet := stod(TRB->ULTIMA)

RestArea(aArea)

Return(dRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONFATC01   ºAutor  ³Microsiga           º Data ³  06/08/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC FUNCTION savevend()
    
LOCAL aArea        :=   GetArea()  
LOCAL aGravarP     :=   {} 
LOCAL cCod         
LOCAL cSeq         :=   "01" 
LOCAL nX   
LOCAL nY  
Local nZ 
Local cMes 
Local cAno

for nX := 1 to len(aList8B)

    cCod := GetSXENum("Z08", "Z08_COD") 
    cSeq := "01"

    For nY := 1 to len(aList8B[nX,1])
    
        aGravarP := {}
    //aContrato := {TRB->AAM_CONTRT,TRB->AAN_ITEM,TRB->AAM_CODCLI,TRB->AAM_LOJA,TRB->AAN_CODPRO}
        cMes := Strtokarr(aList8B[nX,01,nY,01], "/")[2]
        If len(Strtokarr(aList8B[nX,01,nY,01], "/")[3]) > 2
            cAno := SubStr(Strtokarr(aList8B[nX,01,nY,01], "/")[3],3,2)
        Else 
            cAno := Strtokarr(aList8B[nX,01,nY,01], "/")[3]
        EndIf 

        Aadd( aGravarP, {"Z08_FILIAL"  ,xFilial("Z08")})
        Aadd( aGravarP, {"Z08_COD"     ,cCod})
        Aadd( aGravarP, {"Z08_SEQUEN"  ,cSeq})
        Aadd( aGravarP, {"Z08_NUMSER"  ,aList8B[nX,01,nY,06]})
        Aadd( aGravarP, {"Z08_DATA"    ,ctod(aList8B[nX,01,nY,01])})
        Aadd( aGravarP, {"Z08_SELECA"  ,StrZero(val(aList8B[nX,01,nY,02]),3)})
        Aadd( aGravarP, {"Z08_PRODUT"  ,aList8B[nX,01,nY,03]})
        Aadd( aGravarP, {"Z08_CONTRT"  ,aList8B[nX,01,nY,09]})
        Aadd( aGravarP, {"Z08_ITEM"    ,aList8B[nX,01,nY,12]})
        Aadd( aGravarP, {"Z08_QTDLID"  ,aList8B[nX,01,nY,05]})
        Aadd( aGravarP, {"Z08_VLRLID"  ,aList8B[nX,01,nY,08]})
        Aadd( aGravarP, {"Z08_DTDIGIT" ,dDataBase}) 
        Aadd( aGravarP, {"Z08_PERIODO" ,cMes + cAno})
        Aadd( aGravarP, {"Z08_MAQUINA" ,aList8B[nX,01,nY,13]}) 
        Aadd( aGravarP, {"Z08_CODCLI"  ,aList8B[nX,01,nY,07]})  
        Aadd( aGravarP, {"Z08_LOJACL"  ,aList8B[nX,01,nY,11]})
        Aadd( aGravarP, {"Z08_URLFAT"  ,aList8B[nX,01,nY,14]})
        Aadd( aGravarP, {"Z08_MSBLQL"  ,'2'})
    
        IF len(aGravarP) > 0

            DbSelectArea("Z08") 

            Reclock("Z08",.T.)

            FOR nZ := 1 TO len(aGravarP)

                &("Z08->"+aGravarP[nZ,01]) := aGravarP[nZ,02]
            
            NEXT nZ

            Z08->(Msunlock())
            
        ENDIF

        cSeq := Soma1(cSeq)

    next nY
    
next nX

        
RestArea(aArea)

RETURN
