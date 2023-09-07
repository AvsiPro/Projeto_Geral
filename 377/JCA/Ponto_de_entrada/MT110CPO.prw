#INCLUDE 'PROTHEUS.CH'
/*
    Ponto de entrada para adicionar mais campos para a apresentação
    MIT 44_COMPRAS_COM011 _ Tipos de solicitação de compras
    https://docs.google.com/document/d/1ESMwrvQ37rSRT1_DmEgjO9yVyINOCblA/edit
    
*/
User Function MT110CPO()

Local aNewCpos :=  PARAMIXB[1]  //Array contendo os campos da tabela SC1 (Default) 

aAdd(aNewCpos, "C1_XTIPCOT")  //-- Adiciona os campos do usuario 

Return aNewCpos
