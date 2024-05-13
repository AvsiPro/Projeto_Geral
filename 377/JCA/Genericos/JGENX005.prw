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
Local aItemFora := SEPARA(SuperGetMV("TI_ITEMFO",.F.,"B1_COD/B1_GRUPO/B1_FABRIC/B1_ZMARCA"),"/")

cTabela	+=	"->"

If nOpc == 1
    For nX := 1 to len(aAuxX3)
        cCampo := alltrim(aAuxX3[nX])

        If M->&(cCampo) != &(cTabela+cCampo) .and. Ascan(aItemFora,{|x| alltrim(x) == alltrim(cCampo)}) == 0
            Aadd(aRet,{cCampo,M->&(cCampo)})
        EndIf 
    Next nX 
ElseIf nOpc == 2 
    For nX := 1 to len(aAuxX3)
        cCampo := alltrim(aAuxX3[nX])
        If Ascan(aItemFora,{|x| alltrim(x) == alltrim(cCampo)}) == 0
            Aadd(aRet,{cCampo,M->&(cCampo)})
        EndIf 
    Next nX 
Else
    For nX := 1 to len(aAuxX3)
        cCampo := alltrim(aAuxX3[nX])
        If Ascan(aItemFora,{|x| alltrim(x) == alltrim(cCampo)}) == 0
            Aadd(aRet,{cCampo,&(cTabela+cCampo)})
        EndIf 
    Next nX 
EndIf 

RestArea(aArea1)

Return(aRet)
