#INCLUDE 'PROTHEUS.CH'
/*
    Ponto de entrada
    Renegociação com fornecedor e gravar este histórico de negociação.
    
    MIT 44_COMPRAS_COM010 - Histórico de Renegociações com Fornecedor - processo cotação

    Doc Mit
    https://docs.google.com/document/d/16xzLf8aK-K80MuSAq9ejX0ExjPrX7efc/edit
    Doc Validação entrega
    https://docs.google.com/document/d/1JhdsRjmUgZ7KhZ0-5UaWeBTaWKrNXyRu/edit
    
    
*/
User Function MT150OK()  

Local nOpcx := Paramixb[1]   
Local lRet  := .T. 
Local nCont := 1      
Local nCon2 := 1
Local aAlt  := {}
Local lGravar   :=  .F.
Local nPos  :=  0
/*
nOpcx
Numero da opção selecionada.
2- Novo Participante
3- Atualizar
4- Proposta
5- Excluir

*/

 While !Empty(procname(nPos))
    If Alltrim(upper(procname(nPos))) $ 'A150TUDOK'
        lGravar := .T.
        exit 
    EndIf 
    nPos++
EndDo

If nOpcx == 3 .and. lGravar
    nPosNum := Ascan(aHeader,{|x| Alltrim(x[2]) == 'C8_NUM'})
    nPosItm := Ascan(aHeader,{|x| Alltrim(x[2]) == 'C8_ITEM'})
    nPosPro := Ascan(aHeader,{|x| Alltrim(x[2]) == 'C8_NUMPRO'})
    nPosGrd := Ascan(aHeader,{|x| Alltrim(x[2]) == 'C8_ITEMGRD'})

    DbSelectArea("SC8")
    DbSetOrder(1)
    //C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO+C8_ITEMGRD
    For nCont := 1 to len(aCols)
        If Dbseek(xFilial("SC8")+aCols[nCont,nPosNum]+CA150FORN+CA150LOJ+aCols[nCont,nPosItm]+aCols[nCont,nPosPro]+aCols[nCont,nPosGrd])
            For nCon2 := 1 to len(aHeader)
                //If !Alltrim(aHeader[nCon2,2]) $ 'C8_DESCRI/C8_ALI_WT/C8_REC_WT'
                If Alltrim(aHeader[nCon2,2]) $ 'C8_QUANT/C8_PRECO/C8_TOTAL/C8_XQTDATU'
                    If &('SC8->'+Alltrim(aHeader[nCon2,2])) <> aCols[nCont,nCon2]
                        nPosa := Ascan(aAlt,{|x| x[1]+x[2] == aCols[nCont,nPosNum]+aCols[nCont,nPosItm]})
                        If nPosa == 0
                            Aadd(aAlt,{ aCols[nCont,nPosNum],;
                                        aCols[nCont,nPosItm],;
                                        Alltrim(aHeader[nCon2,2]),;
                                        &('SC8->'+Alltrim(aHeader[nCon2,2])),;
                                        aCols[nCont,nCon2]})
                        else
                            Aadd(aAlt[nPosa],Alltrim(aHeader[nCon2,2]))
                            Aadd(aAlt[nPosa],&('SC8->'+Alltrim(aHeader[nCon2,2])))
                            Aadd(aAlt[nPosa],aCols[nCont,nCon2])
                        EndIf
                    EndIf 
                EndIf
            Next nCon2
        EndIf 
    Next nCont

    cAux := ""
    cConteudo := "" 

    For nCont := 1 to len(aAlt)
        nQtdAtu := 0
        nQtdAnt := 0
        nPos := Ascan(aAlt[nCont],{|x| alltrim(x) == "C8_QUANT"})
        If nPos > 0
            nQtdAtu := aAlt[nCont,nPos+2]
            nQtdAnt := aAlt[nCont,nPos+1]
        EndIf 

        Valor := 0
        nVlAnt :=  0 
        nPos := Ascan(aAlt[nCont],{|x| alltrim(x) == "C8_PRECO"})
        If nPos > 0
            Valor := aAlt[nCont,nPos+2]
            nVlAnt := aAlt[nCont,nPos+1]
        EndIf 

        nVlTotA := 0
        nTotAnt := 0
        nPos := Ascan(aAlt[nCont],{|x| alltrim(x) == "C8_TOTAL"})
        If nPos > 0
            nVlTotA := aAlt[nCont,nPos+2]
            nTotAnt := aAlt[nCont,nPos+1]
        EndIf
        

        cConteudo := 'Campo '+aAlt[nCont,03]
        cConteudo += ' - Conteudo anterior '+cvaltochar(aAlt[nCont,04])
        cConteudo += ' - Conteudo atual '+cvaltochar(aAlt[nCont,05])

        U_JGENX001(xFilial("SZL"),'Compras','Alteracao Cotacao','',aAlt[nCont,01],aAlt[nCont,02],CUSERNAME,ddatabase,cvaltochar(time()),Valor,'Alteracao nos itens da cotacao - '+cConteudo,CA150FORN,CA150LOJ,'SC8',nQtdAtu,nVlTotA,nVlAnt,nQtdAnt,nTotAnt)
        
        
    Next nCont
EndIF 

Return lRet
