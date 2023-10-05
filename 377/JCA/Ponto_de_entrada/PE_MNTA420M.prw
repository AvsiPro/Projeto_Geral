User Function MNTA420M()

//MsgInfo("Exemplo de semaforização através do Ponto de Entrada MNTA420M.","P.E. MNTA420M")
//C=Cancelado;L=Liberado ;P=Pendente

aCores := { {"TJ_SITUACA=='L'","BR_VERDE"},;
			{"TJ_SITUACA=='C'","BR_CINZA"},;
            {"TJ_SITUACA=='P'","BR_AMARELO"},;
            {"TJ_SITUACA=='B'","BR_VERMELHO"}}

Return .T.
