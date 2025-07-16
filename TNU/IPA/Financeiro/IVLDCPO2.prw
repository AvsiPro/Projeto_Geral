#INCLUDE 'Protheus.ch'

/*/{Protheus.doc} IVLDCPO2
Preenchimento dos campos do titulo PA
Quando estiver sendo gerado pelo pedido de compra
@type user function
@author Alexandre Venâncio
@since 11/06/2025
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function IVLDCPO2(cOpc)

Local aArea := GetArea()
Local cRet  := ''
Local nPos  := 0
Local nCont 
Local cCtaOrc := ''

If Funname() == "MATA121"
    If cOpc == "E2_PREFIXO"
        cRet := 'AF'
    ElseIf cOpc == "E2_NUM"
        //M->C7_XXCTORC
        //SX5
        //_A ou _P - X5_TABELA
        // X5_CHAVE
        // X5_DESCRI
        nPos := Ascan(aHeadC7,{|x| x[2] == "C7_XXCTORC"})
        If nPos > 0 
            For nCont := 1 to len(aColsC7)
                If !Empty(aColsC7[nCont,nPos])
                    cCtaOrc := aColsC7[nCont,nPos]
                    exit 
                endIf 
            Next nCont 

            If substr(cCtaOrc,1,2) $ 'PC/PJ'
                DbselectArea("SX5")
                DbSetOrder(1)
                If Dbseek(xFilial("SX5")+'_P')
                    cRet := Alltrim(SX5->X5_CHAVE)+Alltrim(SX5->X5_DESCRI)
                    Reclock("SX5",.F.)
                    SX5->X5_DESCRI := SOMA1(Alltrim(SX5->X5_DESCRI))
                    SX5->(Msunlock())
                EndIf 
            Else 
                DbselectArea("SX5")
                DbSetOrder(1)
                If Dbseek(xFilial("SX5")+'_A')
                    cRet := Alltrim(SX5->X5_CHAVE)+Alltrim(SX5->X5_DESCRI)
                    Reclock("SX5",.F.)
                    SX5->X5_DESCRI := SOMA1(Alltrim(SX5->X5_DESCRI))
                    SX5->(Msunlock())
                EndIf
            EndIf 
        EndIf 
        
        
    ElseIf cOpc == "E2_TIPO"
        cRet := 'PA'
        //cRet := 'PP'

        cVldSis := 'FA050Tipo()' //GetSX3Cache(cOpc, "X3_VALID")
        SetFunName('FINA050')
        If ! Empty(cVldSis)
            lContinua := &(cVldSis)
        EndIf

        cBancoAdt	:= '237' //CriaVar("A6_COD")
        cAgenciaAdt := '3368 ' //CriaVar("A6_AGENCIA")
        cNumCon		:= '42338     ' //CriaVar("A6_NUMCON")
        cChequeAdt	:= CriaVar("EF_NUM")
        cHistor		:= CriaVar("EF_HIST")
        cBenef		:= CriaVar("EF_BENEF")

        //lret := fa050Cheque(cBancoAdt,cAgenciaAdt,cNumCon,cChequeAdt,Iif(cPaisLoc $ "ARG",.F.,.T.))
        //Fa050DigPa(,@M->E2_MOEDA,.F.)
        //https://tdn.totvs.com/pages/releaseview.action?pageId=504794483 PROCESSO DE COMPENSAÇÃO
        //https://tdn.totvs.com/pages/releaseview.action?pageId=511545788 ESTORNO COMPENSAÇÃO
        SetFunName('MATA121')
    ElseIf cOpc == "E2_FORNECE"
        cRet := CA120FORN
    ElseIf cOpc == "E2_LOJA"
        cRet := cA120Loj
    ElseIf cOpc == "E2_EMISSAO"
        cRet := ddatabase
    ElseIf cOpc == "E2_VENCTO"
        cRet := ddatabase + val(Alltrim(SuperGetMV("TI_DIAVCT",.F.,"8")))
    ElseIf cOpc == "E2_HIST"
        cRet := "PEDIDO DE COMPRA "+ca120Num
    ElseIf cOpc == "E2_VENCREA"
        cRet := datavalida(ddatabase + val(Alltrim(SuperGetMV("TI_DIAVCT",.F.,"8"))))
    ElseIf cOpc == "E2_XXCTORC"
        nPos := Ascan(aHeadC7,{|x| alltrim(x[2]) == "C7_XXCTORC"})
        If nPos > 0 .And. len(aColsC7) > 0
            cRet := aColsC7[1,nPos]
        EndIf 
    ElseIf Alltrim(cOpc) $ "E2_VALOR/E2_VLCRUZ/E2_SALDO"
        cRet := AVALORES[1]
    EndIf 
Else 
    If cOpc == "E2_EMISSAO"
        cRet := ddatabase
    Else
        If valtype(m->&(copc)) == "C"
            cRet := space(TamSX3(cOpc)[1])
        ElseIf valtype(m->&(copc)) == "D"
            cRet := ctod(' / / ')
        ElseIf valtype(m->&(copc)) == "N"
            cRet := 0
        ElseIf valtype(m->&(copc)) == "U"
            cRet := 0
        Endif 
    EndIf 
EndIf 

RestArea(aArea)

Return(cRet)
