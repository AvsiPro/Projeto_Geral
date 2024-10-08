#INCLUDE 'PROTHEUS.CH'

/*
    PE Para validar altera��o do cadastro de produtos
    Utilizado para validar na altera��o de modo a n�o permitir que produtos filhos
    sejam alterados e para que ao atualizar algum dado do pai replique para os filhos
    seja SB1, SB5 ou SBZ

    DOC MIT
    
    DOC ENTREGA
    
    
*/

User Function A010TOK()
Local aArea         :=  GetArea()
Local lExecuta      := .T.
Local aAlterados    :=  {}
Local nCont         :=  0
Local aFilhos       :=  {}
Local nX            :=  0
Local cBkpSb1       :=  M->B1_COD
Local cDescric      :=  M->B1_DESC
Local lAltPai       := .f.
Local lCmpsFilho    := .t.
Local aCmpsFilho    := {"B1_FABRIC","B1_CONTA"}  // Campos que podem ser alterados no produto filho
If Altera 

    DbSelectArea("SB1")
    DbSetOrder(1)

    If SB1->(DBSeek(FwXFilial("SB1")+cBkpSb1))

        aAlterados := U_JGENX005('SB1',1)

        For nX := 1 to len(aAlterados)
            If ascan(aCmpsFilho,{|cEle| Upper(Alltrim(cEle)) == Upper(Alltrim(aAlterados[nX,1])) }) <= 0
                lCmpsFilho := .f.
            Endif
        Next

        IF lCmpsFilho .and. !Empty(SB1->B1_XCODPAI)  // Se for somente campos permitidos no produto filho
            lExecuta := .t.    
        ElseIf !Empty(SB1->B1_XCODPAI)
            MsgAlert("Produtos filhos n�o podem ser alterados.","A010TOK")
            lExecuta := .F.
        ElseIf Empty(SB1->B1_XCODPAI) 
            /* 

            ESTA PARTE FOI TRANSFERIDA PARA O FINAL DA VALIDA��O DA ALTERA��O DE PRODUTOS
            PONTO DE ENTRADA PE_MT010ALT
            lAltPai  := .t.

            If len(aAlterados) > 0

                aFilhos := Buscafilhos(cBkpSb1)

                If len(aFilhos) > 0
                    DbSelectArea("SB1")
                    For nX := 1 to len(aFilhos)
                        Dbgoto(aFilhos[nX,02])
                        Reclock("SB1",.F.)

                        For nCont := 1 to len(aAlterados)
                            &('SB1->'+aAlterados[nCont,01]) := aAlterados[nCont,02]
                        Next nCont

                        If !Empty(SB1->B1_ZMARCA)
                            SB1->B1_DESC := Alltrim(cDescric)+" "+Alltrim(Posicione("ZPM",1,xFilial("ZPM")+SB1->B1_ZMARCA,"ZPM_DESC"))
                        EndIf 
                        

                        SB1->(Msunlock())
                    Next nX 
                EndIf 
            EndIf 

            aAlterados := {}
                
            DbSelectArea("SB5")
            DbSetOrder(1)
            If DbSeek(xFilial("SB5")+cBkpSb1)
                aAlterados := U_JGENX005('SB5',2)

                If len(aFilhos) > 0 .And. len(aAlterados) > 0
                    DbSelectArea("SB5")
                    For nX := 1 to len(aFilhos)
                        If DbSeek(xFilial("SB5")+aFilhos[nX,01])
                            Reclock("SB5",.F.)
                        Else 
                            Reclock("SB5",.T.)
                        EndIf 

                        For nCont := 1 to len(aAlterados)
                            
                            If Alltrim(aAlterados[nCont,01]) == "B5_COD"
                                &('SB5->'+aAlterados[nCont,01]) := aFilhos[nX,01]
                            Else
                                &('SB5->'+aAlterados[nCont,01]) := aAlterados[nCont,02]
                            endif
                        Next nCont

                        SB5->(Msunlock())
                    Next nX 
                EndIf 
            EndIf */ 
        EndIF
    Endif 
EndIf 

RestArea(aArea)

Return (lExecuta)

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


