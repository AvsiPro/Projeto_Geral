#INCLUDE 'PROTHEUS.CH'

User Function MT110CPO()

Local aNewCpos :=  PARAMIXB[1]  //Array contendo os campos da tabela SC1 (Default) 

aAdd(aNewCpos, "C1_XTIPCOT")  //-- Adiciona os campos do usuario 

Return aNewCpos
