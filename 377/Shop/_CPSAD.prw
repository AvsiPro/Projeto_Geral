#include "Protheus.ch"
#include "Topconn.ch"
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Consulta Especifica de Marcas - SAD
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function _CPSAD()
 
Local bRet := .F.
 
Private nPosProd   := aScan(aHeader, {|x| alltrim(x[2]) == "C7_PRODUTO"})
Private cCodigo    := Alltrim(&(ReadVar()))
 
bRet := FiltraZZY()
 
Return(bRet)
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Consulta Especifica de Marcas - SAD
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function FiltraZZY()
 
Local cQuery
Local cGrpFor       :=  ''      
Local cBarra        :=  ''
Private cBusca      :=  space(25)
Private oDlgZZY     :=  nil
Private _bRet       :=  .F.
Private aDadosZZY   :=  {}
Private aBkpFil     :=  {}
 
//Query para produto x fornecedor
cQuery := " SELECT A5_PRODUTO,A5_NOMPROD,B1_GRUPO" + CRLF
cQuery += " FROM "+RetSQLName("SA5")+" A5" + CRLF
cQuery += " INNER JOIN "+RetSQLName("SB1")+" B1 ON B1_FILIAL=A5_FILIAL AND B1_COD=A5_PRODUTO AND B1.D_E_L_E_T_=' ' AND B1_MSBLQL<>'1'" + CRLF
cQuery += " WHERE A5.D_E_L_E_T_=' '" + CRLF
cQuery += " AND A5_FORNECE='"+CA120FORN+"' AND A5_LOJA='"+CA120LOJ+"'"

cAlias1:= CriaTrab(Nil,.F.)

If Select(cAlias1) > 0
    (cAlias1)->(DBCloseArea())
EndIf 

DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlias1, .F., .T.)
 
(cAlias1)->(DbGoTop())

Do While (cAlias1)->(!Eof())

    If !(cAlias1)->B1_GRUPO $ cGrpFor
        cGrpFor += cBarra + (cAlias1)->B1_GRUPO
        cBarra := "','"
    EndIf 

    aAdd( aDadosZZY, { (cAlias1)->A5_PRODUTO, (cAlias1)->A5_NOMPROD, (cAlias1)->B1_GRUPO} )
    aAdd( aBkpFil  , { (cAlias1)->A5_PRODUTO, (cAlias1)->A5_NOMPROD, (cAlias1)->B1_GRUPO} )
    (cAlias1)->(DbSkip())
 
Enddo

//Query para grupo x fornecedor 
cQuery := " SELECT B1_COD,B1_DESC,B1_GRUPO" + CRLF 
cQuery += " FROM "+RetSQLName("SB1")+" B1" + CRLF
cQuery += " INNER JOIN "+RetSQLName("SAD")+" AD ON AD_FILIAL=B1_FILIAL" + CRLF
cQuery += " AND AD_FORNECE='"+CA120FORN+"' AND AD_LOJA='"+CA120LOJ+"' AND AD_GRUPO=B1_GRUPO AND AD.D_E_L_E_T_=' '" + CRLF
cQuery += " AND B1_GRUPO NOT IN('"+cGrpFor+"')"+ CRLF
cQuery += " WHERE B1.D_E_L_E_T_=' ' AND B1_MSBLQL<>'1' " + CRLF 

If Select(cAlias1) > 0
    (cAlias1)->(DBCloseArea())
EndIf 

//cAlias1:= CriaTrab(Nil,.F.)
DbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQuery),cAlias1, .F., .T.)
 
(cAlias1)->(DbGoTop())

If (cAlias1)->(Eof()) .And. len(aDadosZZY) < 1
    Aviso( "Cadastro de Grupo x Fornecedores", "Não existe dados a consultar", {"Ok"} )
    Return .F.
Endif
 
Do While (cAlias1)->(!Eof())
 
    aAdd( aDadosZZY, { (cAlias1)->B1_COD, (cAlias1)->B1_DESC, (cAlias1)->B1_GRUPO} )
    aAdd( aBkpFil  , { (cAlias1)->B1_COD, (cAlias1)->B1_DESC, (cAlias1)->B1_GRUPO} )
    (cAlias1)->(DbSkip())
 
Enddo
 
(cAlias1)->(DbCloseArea())
 
nList := aScan(aDadosZZY, {|x| alltrim(x[3]) == alltrim(cCodigo)})
 
iif(nList = 0,nList := 1,nList)
 
    //--Montagem da Tela
    Define MsDialog oDlgZZY Title "Busca de Grupo x Fornecedores" From 0,0 To 280, 500 Of oMainWnd Pixel
    
    @ 5,5 LISTBOX oLstZZY ;
    VAR lVarMat ;
    Fields HEADER "Cod. Produto", "Descrição", "Grupo" ;
    SIZE 245,110 On DblClick ( ConfZZY(oLstZZY:nAt, @aDadosZZY, @_bRet) ) ;
    OF oDlgZZY PIXEL
    
    oLstZZY:SetArray(aDadosZZY)
    oLstZZY:nAt := nList
    oLstZZY:bLine := { || {aDadosZZY[oLstZZY:nAt,1], aDadosZZY[oLstZZY:nAt,2], aDadosZZY[oLstZZY:nAt,3]}}
    
    TSay():New( 122,10,{||"Filtro"},oDlgZZY,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
    TGet():New( 122,25,{|u|IF(PCount()>0,cBusca:=u,cBusca)},oDlgZZY,060,008,'@!',{|| fBusca(cBusca)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)

    DEFINE SBUTTON FROM 122,125 TYPE 1 ACTION ConfZZY(oLstZZY:nAt, @aDadosZZY, @_bRet) ENABLE OF oDlgZZY
    DEFINE SBUTTON FROM 122,160 TYPE 2 ACTION oDlgZZY:End() ENABLE OF oDlgZZY
    
    Activate MSDialog oDlgZZY Centered
 
Return _bRet
 
Static Function ConfZZY(_nPos, aDadosZZY, _bRet)

If _nPos > 0 
    cCodigo := aDadosZZY[_nPos,1]
    
    aCols[n,nPosProd] := cCodigo

    DbSelectArea("SB1")
    DbSetOrder(1)
    DbSeek(xFilial("SB1")+cCodigo)

    _bRet := .T.
    
    oDlgZZY:End()
EndIf 

Return

/*/{Protheus.doc} fBusca
    (long_description)
    @type  Static Function
    @author user
    @since 10/11/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function fBusca(cBusca)

Local aArea := GetArea()
Local nCont := 1
Local aAux  := {}

aDadosZZY := {}

If !Empty(cBusca)
    For nCont := 1 to len(aBkpFil)
        If Alltrim(cBusca) $ aBkpFil[nCont,01] .Or. Alltrim(cBusca) $ aBkpFil[nCont,02]
            Aadd(aAux,aBkpFil[nCont])
        EndIf
    Next nX

    aDadosZZY := aAux
Else 
    aDadosZZY := aBkpFil
EndIf 

oLstZZY:SetArray(aDadosZZY)
oLstZZY:nAt := nList
oLstZZY:bLine := { || {aDadosZZY[oLstZZY:nAt,1], aDadosZZY[oLstZZY:nAt,2], aDadosZZY[oLstZZY:nAt,3]}}

oLstZZY:refresh()
oDlgZZY:refresh()

RestArea(aArea)
    
Return
