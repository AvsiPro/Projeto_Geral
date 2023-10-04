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
Local _aCols    :=  {}
Local nPosPrd   :=  0
Local nPosItm   :=  0
Local nPosDes   :=  0
Local nItens    :=  0
Local nBkpRec   :=  Recno()

aAdd(aPergs, {1, "Código",  cCodigo,  "", ".T.", "SB1", ".T.", 80,  .F.})

If ParamBox(aPergs, "Informe o código do produto a ser incluído nesta cotação",aRet)

    aCampos := FWSX3Util():GetListFieldsStruct( "SC8" , .F. )   

    For nCont := 1 to len(aCampos)
        Aadd(_aCols,{aCampos[nCont,01],&("SC8->"+aCampos[nCont,01])}) 
    Next nCont

    nPosPrd := Ascan(aCampos,{|x| Alltrim(x[1]) == "C8_PRODUTO"})
    nPosItm := Ascan(aCampos,{|x| Alltrim(x[1]) == "C8_ITEM"})
    nPosDes := Ascan(aCampos,{|x| Alltrim(x[1]) == "C8_DESCRI"})

    cProdPai := Posicione("SB1",1,xFilial("SB1")+aRet[1],"B1_XCODPAI")
    DbSelectArea("ZPN")
    DbSetOrder(1)
    If Dbseek(SC8->C8_FILIAL+aRet[1])
        MsgAlert("Marca com restrição de compra para esta filial","PE_MT150ROT")
        lPermitir := .F.
    EndIf

    If lPermitir
        If Empty(cProdPai)
            MsgAlert("Somente produtos filhos podem ser adicionados","PE_MT150ROT")
            lPermitir := .F.
        Else 
            DbSelectArea("SC8")
            DbGotop()
            DbSetOrder(1)
            If Dbseek(xfilial("SC8")+cCotacao)
                While !EOF() .And. SC8->C8_FILIAL == xFilial("SC8") .And. SC8->C8_NUM == cCotacao 
                    If Alltrim(SC8->C8_PRODUTO) == Alltrim(aRet[1])
                        MsgAlert("Produto já consta na Cotação","PE_MT150ROT")
                        lPermitir := .F.
                        exit
                    EndIf
                    nItens++
                    Dbskip()
                EndDo 
            EndIf 
        EndIf
    EndIf

    If lPermitir
        _aCols[nPosPrd,02] := aRet[1]
        _aCols[nPosItm,02] := Strzero(nItens+1,4)

        If nPosDes > 0
            _aCols[nPosDes,02] := Posicione("SB1",1,xFilial("SB1")+aRet[1],"B1_DESC")
        EndIF 

        Reclock("SC8",.T.)
        For nCont := 1 to len(_aCols)
            &("SC8->"+_aCols[nCont,01]) := _aCols[nCont,02]
        Next nCont
        SC8->(MSUNLOCK())

        MsgAlert("Produto incluído na cotação com sucesso!!!","PE_MT150ROT")
        DbSelectArea("SC8")
        Dbgoto(nBkpRec)
    EndIf 
EndIf

RestArea(aArea)

Return
