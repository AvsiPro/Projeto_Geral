/*
    Incluir legendas MNTA420
    
*/
User Function MNTA420M()

//MsgInfo("Exemplo de semaforização através do Ponto de Entrada MNTA420M.","P.E. MNTA420M")
//C=Cancelado;L=Liberado ;P=Pendente

aCores := { {"TJ_XSITUAC=='1'","BR_VERMELHO"},;
            {"TJ_SITUACA=='L' .AND. TJ_XSITUAC<>'1'","BR_VERDE"},;
			{"TJ_SITUACA=='C'","BR_CINZA"},;
            {"TJ_SITUACA=='P' .AND. TJ_XSITUAC<>'1'","BR_AMARELO"}}

Return .T.
