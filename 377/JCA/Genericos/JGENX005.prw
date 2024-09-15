#INCLUDE 'PROTHEUS.CH'
/*
    Função para validar quais campos foram alterados na tabela solicitada

    Utilizada para validar os campos alterados a principio no cadastro de produtos (SB1.SB5.SBZ)
    Para que esta alteração possa ser replicada para os produtos filhos deste produto, caso existam.
    
    DOC MIT
    
    DOC ENTREGA
    
    
*/
User Function JGENX005(cTabela,nOpc)

Local aArea1	:=	GetArea()
Local nX 
Local aAuxX3    := FWSX3Util():GetAllFields( cTabela , .F. )
Local aRet      :=  {}
Local aItemFora := SEPARA(SuperGetMV("TI_ITEMFO",.F.,"B1_COD/B1_GRUPO/B1_FABRIC/B1_ZMARCA/B1_UCOM/B1_UCALSTD/B1_UCOM/B1_UPRC/B1_DATREF/B1_UCALSTD/B1_VIGENC/B1_CONINI/B1_PROC/B1_CODISS/B1_ALIQISS/B1_XCODPAI"),"/")
Local lImport   := .F.

cTabela	+=	"->"

If nOpc == 1
    For nX := 1 to len(aAuxX3)
        cCampo := alltrim(aAuxX3[nX])   

        //If M->&(cCampo) != &(cTabela+cCampo)  .and. Ascan(aItemFora,{|x| alltrim(x) == alltrim(cCampo)}) == 0 .and. M->&(cCampo) != Nil
        If valtype(aAuto) == "A"
            nPosAuto := Ascan(aAuto,{|x| alltrim(x[1]) == cCampo})
            If nPosAuto > 0
                lImport := .T.
            EndIf 
        Endif 
        //If Ascan(aItemFora,{|x| alltrim(x) == alltrim(cCampo)}) == 0 .and. M->&(cCampo) != Nil
        If Ascan(aItemFora,{|x| alltrim(x) == alltrim(cCampo)}) == 0 .and. &(cTabela+cCampo) != Nil
            If lImport
                If nPosAuto > 0
                    Aadd(aRet,{cCampo,aAuto[nPosAuto,02]})
                Else 
                    Aadd(aRet,{cCampo,&(cTabela+cCampo)})
                EndIf 
            Else 
                Aadd(aRet,{cCampo,&(cTabela+cCampo)}) //M->&(cCampo)
            EndIF 
        EndIf 
    Next nX 
ElseIf nOpc == 2 
    For nX := 1 to len(aAuxX3)
        cCampo := alltrim(aAuxX3[nX])
        //If Ascan(aItemFora,{|x| alltrim(x) == alltrim(cCampo)}) == 0 .and. M->&(cCampo) != Nil
        If Ascan(aItemFora,{|x| alltrim(x) == alltrim(cCampo)}) == 0 .and. &(cTabela+cCampo) != Nil
            Aadd(aRet,{cCampo,&(cTabela+cCampo)}) //M->&(cCampo)
        EndIf 
    Next nX 
Else
    For nX := 1 to len(aAuxX3)
        cCampo := alltrim(aAuxX3[nX])
        If Ascan(aItemFora,{|x| alltrim(x) == alltrim(cCampo)}) == 0 .and. &(cTabela+cCampo) != Nil
            Aadd(aRet,{cCampo,&(cTabela+cCampo)})
        EndIf 
    Next nX 
EndIf 

RestArea(aArea1)

Return(aRet)
