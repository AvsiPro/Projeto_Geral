#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

User Function MT150ROT()
//Define Array contendo as Rotinas a executar do programa
// ----------- Elementos contidos por dimensão ------------
// 1. Nome a aparecer no cabeçalho
// 2. Nome da Rotina associada
// 3. Usado pela rotina
// 4. Tipo de transação a ser efetuada
// 1 - Pesquisa e posiciona em um banco de dados
// 2 - Simplesmente mostra os campos
// 3 - Inclui registros no banco de dados
// 4 - Altera o registro corrente
// 5 - Remove o registro corrente do banco de dados
// 6 - Altera determinados campos sem incluir novos Regs
AAdd( aRotina, { 'Incluir Produtos filho', 'U_xMt150r(SC8->C8_NUM)', 0, 4 })

Return aRotina

/*/{Protheus.doc} User Function nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 03/10/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function xMt150r(cCotacao)

Local aArea     :=  GetArea()
Local aRet      :=  {}
Local aPergs    :=  {}
Local cCodigo   :=  space(15)
Local lPermitir :=  .T.
Local cProdPai  :=  ''
Local nCont     :=  0
Local aCampos   :=  {}
Local aCampo1   :=  {}
Local _aCols    :=  {}
Local _aCols2   :=  {}
Local nPosPrd   :=  0
Local nPosItm   :=  0
Local nPosDes   :=  0
Local nPosPr2   :=  0
Local nPosIt2   :=  0
Local nItens    :=  0
Local nFornec   :=  0
Local nPosFoc   :=  0
Local nPosFno   :=  0
Local nPosFma   :=  0
Local nY        :=  0
Local cProdC1   :=  ""
Local aForProd  :=  {}
Local aItmCs1   :=  {}
Local CITSC1    :=  ''
Local cIdent    :=  ''
Local nPosId1   :=  0
Local nPosId2   :=  0
Local aForAtu   :=  {}

aAdd(aPergs, {1, "Código",  cCodigo,  "", ".T.", "SB1", ".T.", 80,  .F.})

If ParamBox(aPergs, "Informe o código do produto a ser incluído nesta cotação",aRet)

    aForAtu := QtdFor(SC8->C8_NUM)

    nFornec   := len(aForAtu)

    cProdPai := Posicione("SB1",1,xFilial("SB1")+aRet[1],"B1_XCODPAI")
    
    If Empty(cProdPai)
        MsgAlert("Somente produtos filhos podem ser adicionados","PE_MT150ROT")
        lPermitir := .F.  
    Else 
        lPaiSol := BusPaiSC(SC8->C8_NUM,cProdPai)
        If !lPaiSol
            MsgAlert("Produto pai não encontrado na solicitação de compra","PE_MT150ROT")
            lPermitir := .F.
        EndIf 
    EndIf 

    If lPermitir 
        For nY := 1 to nFornec 
            _aCols := {}
            _aCols2:= {}

            If !aRet[1] $ cProdC1
                aItmCs1 := maxc1(SC8->C8_NUMSC)
                CITSC1  := aItmCs1[1]
                cIdent  := aItmCs1[2]
            EndIf

            aCampos := FWSX3Util():GetListFieldsStruct( "SC8" , .F. )   

            For nCont := 1 to len(aCampos)
                Aadd(_aCols,{aCampos[nCont,01],&("SC8->"+aCampos[nCont,01])}) 
            Next nCont

            aCampo1 := FWSX3Util():GetListFieldsStruct( "SC1" , .F. ) 
            
            For nCont := 1 to len(aCampo1)
                Aadd(_aCols2,{aCampo1[nCont,01],&("SC1->"+aCampo1[nCont,01])}) 
            Next nCont

            nPosPrd := Ascan(aCampos,{|x| Alltrim(x[1]) == "C8_PRODUTO"})
            nPosItm := Ascan(aCampos,{|x| Alltrim(x[1]) == "C8_ITEM"})
            nPosIsc := Ascan(aCampos,{|x| Alltrim(x[1]) == "C8_ITEMSC"})
            nPosId1 := Ascan(aCampos,{|x| Alltrim(x[1]) == "C8_IDENT"})
            nPosFoc := Ascan(aCampos,{|x| Alltrim(x[1]) == "C8_FORNECE"})
            nPosFno := Ascan(aCampos,{|x| Alltrim(x[1]) == "C8_FORNOME"})
            nPosFma := Ascan(aCampos,{|x| Alltrim(x[1]) == "C8_FORMAIL"})

            nPosPr2 := Ascan(aCampo1,{|x| Alltrim(x[1]) == "C1_PRODUTO"})
            nPosIt2 := Ascan(aCampo1,{|x| Alltrim(x[1]) == "C1_ITEM"})
            nPosDes := Ascan(aCampo1,{|x| Alltrim(x[1]) == "C1_DESCRI"})
            nPosId2 := Ascan(aCampo1,{|x| Alltrim(x[1]) == "C1_IDENT"})

            DbSelectArea("ZPN")
            DbSetOrder(1)
            If Dbseek(SC8->C8_FILIAL+aRet[1])
                MsgAlert("Marca com restrição de compra para esta filial","PE_MT150ROT")
                lPermitir := .F.
                exit
            EndIf

            If lPermitir
                /*If Empty(cProdPai)
                    MsgAlert("Somente produtos filhos podem ser adicionados","PE_MT150ROT")
                    lPermitir := .F.
                    exit
                Else */

                    nItens := 0

                    DbSelectArea("SC8")
                    DbGotop()
                    DbSetOrder(1)
                    If Dbseek(xfilial("SC8")+cCotacao)
                        While !EOF() .And. SC8->C8_FILIAL == xFilial("SC8") .And. SC8->C8_NUM == cCotacao
                            nPosFoPr := Ascan(aForProd,{|x| x[1]+x[2] == SC8->C8_PRODUTO+SC8->C8_FORNECE}) 

                            If Alltrim(SC8->C8_PRODUTO) == Alltrim(aRet[1]) .and. nPosFoPr > 0
                                MsgAlert("Produto já consta na Cotação","PE_MT150ROT")
                                lPermitir := .F.
                                exit
                            Else 
                                Aadd(aForProd,{SC8->C8_PRODUTO,SC8->C8_FORNECE,SC8->C8_FORNOME,SC8->C8_FORMAIL})
                            EndIf

                            nItens++
                            Dbskip()
                        EndDo 
                        //Posicionar novamente para continuar o tratamento na mesma cotação
                        Dbseek(xfilial("SC8")+cCotacao)
                    EndIf 
                //EndIf
            EndIf

            If lPermitir
                _aCols[nPosPrd,02] := aRet[1]
                _aCols[nPosItm,02] := Strzero(nItens+1,4)

                _aCols[nPosId1,02] := cIdent

                
                _aCols[nPosFoc,02] := aForAtu[nY,01]
                _aCols[nPosFno,02] := aForAtu[nY,02]
                _aCols[nPosFma,02] := aForAtu[nY,03]

                _aCols2[nPosPr2,02] := aRet[1]
                _aCols2[nPosIt2,02] := CITSC1
                _aCols2[nPosId2,02] := cIdent

                If nPosDes > 0
                    _aCols2[nPosDes,02] := Posicione("SB1",1,xFilial("SB1")+aRet[1],"B1_DESC")
                EndIF 

                If !aRet[1] $ cProdC1
                    Reclock("SC1",.T.)
                    For nCont := 1 to len(_aCols2)
                        &("SC1->"+_aCols2[nCont,01]) := _aCols2[nCont,02]
                    Next nCont
                    SC1->(MSUNLOCK())
                
                EndIf 

                cProdC1 += aRet[1]+"/"

                _aCols[nPosIsc,02] := CITSC1

                Reclock("SC8",.T.)
                For nCont := 1 to len(_aCols)
                    &("SC8->"+_aCols[nCont,01]) := _aCols[nCont,02]
                Next nCont
                SC8->(MSUNLOCK())

            EndIf 
        Next nY
    Endif

    If lPermitir
        MsgAlert("Produto incluído na cotação com sucesso!!!","PE_MT150ROT")
        DbSelectArea("SC8")
    EndIf 
    
EndIf

RestArea(aArea)

Return

/*/{Protheus.doc} maxc1(SC8->C8_NUMSC)
    (long_description)
    @type  Static Function
    @author user
    @since 10/10/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function maxc1(cSC1)

Local aAreaC1 := GetArea()
Local cQuery  := ""
Local aRet    := {}

cQuery := "SELECT MAX(C1_ITEM) AS MAX,MAX(C1_IDENT) AS IDEN"
cQuery += " FROM "+RetSQLName("SC1")
cQuery += " WHERE C1_FILIAL='"+xFilial("SC1")+"' AND C1_NUM='"+cSC1+"'"
cQuery += " AND D_E_L_E_T_=' ' "

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("JCOMJ001.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

Aadd(aRet,STRZERO(VAL(TRB->MAX)+1,4))
Aadd(aRet,STRZERO(VAL(TRB->IDEN)+1,4))

RestArea(aAreaC1)
    
Return(aRet)

/*/{Protheus.doc} QtdFor
    (long_description)
    @type  Static Function
    @author user
    @since 10/10/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function QtdFor(cSc8num)

Local aAreaC1 := GetArea()
Local cQuery  := ""
Local aRet    := {}

cQuery := "SELECT  C8_FORNECE,C8_FORNOME,C8_FORMAIL,COUNT(R_E_C_N_O_)"
cQuery += " FROM "+RetSQLName("SC8")
cQuery += " WHERE C8_FILIAL='"+xFilial("SC8")+"' AND C8_NUM='"+cSc8num+"'"
cQuery += " AND D_E_L_E_T_=' ' "
cQuery += " GROUP BY C8_FORNECE,C8_FORNOME,C8_FORMAIL,R_E_C_N_O_"
cQuery += " ORDER BY R_E_C_N_O_"

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("JCOMJ001.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

While !EOF()
    If Ascan(aRet,{|x| x[1] == TRB->C8_FORNECE}) == 0
        Aadd(aRet,{TRB->C8_FORNECE,TRB->C8_FORNOME,TRB->C8_FORMAIL})
    EndIf 
    Dbskip()
ENDDO


RestArea(aAreaC1)
    
Return(aRet)

/*/{Protheus.doc} BusPaiSC(SC8->C8_NUM,cProdPai)
    (long_description)
    @type  Static Function
    @author user
    @since 20/10/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function BusPaiSC(cNumSc1,cProdPai)

Local aAreaC1 := GetArea()
Local cQuery  := ""
Local lRet    := .F.

cQuery := "SELECT C1_PRODUTO"
cQuery += " FROM "+RetSQLName("SC1")
cQuery += " WHERE C1_FILIAL='"+xFilial("SC1")+"' AND C1_NUM='"+cNumSc1+"'"
cQuery += " AND C1_PRODUTO='"+cProdPai+"' AND D_E_L_E_T_=' ' "

IF Select('TRB') > 0
    dbSelectArea('TRB')
    dbCloseArea()
ENDIF

MemoWrite("PE_MT150ROT.SQL",cQuery)
DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB")

If !Empty(TRB->C1_PRODUTO)
    lRet := .T.
EndIf 

RestArea(aAreaC1)

Return(lRet)
