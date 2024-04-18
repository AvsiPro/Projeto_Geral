#INCLUDE 'PROTHEUS.CH'

/*
    PE Para alteração do cadastro de produtos
    Complementar para a atualização dos dados da SBZ.
    
    DOC MIT
    
    DOC ENTREGA
    
    
*/

User Function MT010ALT()

Local aArea         :=  GetArea()
Local aAlterados    :=  {}
Local nCont         :=  0
Local aFilhos       :=  {}
Local nX,nZ
Local cBkpSb1       :=  SB1->B1_COD
Local aFilSBZ       :=  {}

If Empty(SB1->B1_XCODPAI)
    aFilhos := Buscafilhos(cBkpSb1)
    aFilSBZ := BuscaFBZ(cBkpSb1)
    
    For nZ := 1 to len(aFilSBZ)
        DbSelectArea("SBZ")
        DbSetOrder(1)
        If DbSeek(aFilSBZ[nZ]+cBkpSb1)
            aAlterados := {}

            aAlterados := U_JGENX005('SBZ',3)

            If len(aFilhos) > 0 .And. len(aAlterados) > 0
                DbSelectArea("SBZ")
                For nX := 1 to len(aFilhos)
                    If DbSeek(aFilSBZ[nZ]+aFilhos[nX,01])
                        Reclock("SBZ",.F.)
                    Else 
                        Reclock("SBZ",.T.)
                    EndIf 

                    For nCont := 1 to len(aAlterados) 
                        
                        If Alltrim(aAlterados[nCont,01]) == "BZ_COD"
                            &('SBZ->'+aAlterados[nCont,01]) := aFilhos[nX,01]
                        Else
                            &('SBZ->'+aAlterados[nCont,01]) := aAlterados[nCont,02]
                        EndIf 
                    Next nCont

                    SBZ->(Msunlock())
                Next nX 
            EndIf 
        EndIf 
    Next nZ 
EndIf 


RestArea(aArea)

Return 


/*/{Protheus.doc} nomeStaticFunction
    Busca os produtos filhos deste cadastro que esta sendo atualizado
    @type  Static Function
    @author user
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static function Buscafilhos(cCodigo)

Local aArea := GetArea()
Local aRet  := {}
Local cQuery 

cQuery := "SELECT B1_COD,B1.R_E_C_N_O_ AS REGB1"
cQuery += " FROM "+RetSQLName("SB1")+" B1"
cQuery += " WHERE B1_FILIAL='"+xFilial("SB1")+"'"
cQuery += " AND B1_XCODPAI='"+cCodigo+"' AND B1_XCODPAI<>' '"
cQuery += " AND D_E_L_E_T_=' '"


If Select("TRB") > 0
	TRB->( dbCloseArea() )
EndIf             

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)  

dbSelectArea("TRB")

While !EOF()
    Aadd(aRet,{TRB->B1_COD,TRB->REGB1})

    Dbskip()
EndDo 

RestArea(aArea)

Return(aRet)

/*/{Protheus.doc} BuscaFBZ(cBkpSb1)
    Busca filiais em que o produto existe para atualizar os filhos
    @type  Static Function
    @author user
    @since date
    @version version
    @param param, param_type, param_descr
    @return return, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Static Function BuscaFBZ(cCodigo)

Local aArea := GetArea()
Local aRet  := {}
Local cQuery 

cQuery := "SELECT BZ_FILIAL"
cQuery += " FROM "+RetSQLName("SBZ")+" BZ"
cQuery += " WHERE BZ_COD='"+cCodigo+"'"
cQuery += " AND D_E_L_E_T_=' '"


If Select("TRB") > 0
	TRB->( dbCloseArea() )
EndIf             

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)  

dbSelectArea("TRB")

While !EOF()
    Aadd(aRet,TRB->BZ_FILIAL)

    Dbskip()
EndDo 

RestArea(aArea)

Return(aRet)
