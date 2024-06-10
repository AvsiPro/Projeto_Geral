/*
    Incluir opções menu cadastro de produtos
    
*/
User Function MT010BRW()

Local aRotUser := {}

//Define Array contendo as Rotinas a executar do programa     
// ----------- Elementos contidos por dimensao ------------    
// 1. Nome a aparecer no cabecalho                             
// 2. Nome da Rotina associada                                 
// 3. Usado pela rotina                                        
// 4. Tipo de Transacao a ser efetuada                         
//    1 - Pesquisa e Posiciona em um Banco de Dados            
//    2 - Simplesmente Mostra os Campos                        
//    3 - Inclui registros no Bancos de Dados                  
//    4 - Altera o registro corrente                           
//    5 - Remove o registro corrente do Banco de Dados         
//    6 - Altera determinados campos sem incluir novos Regs     

AAdd( aRotUser, { 'Cadastro de Marcas', 'U_JCOMA002()', 0, 3 } )
AAdd( aRotUser, { 'Copia JCA', 'U_JCOMG002()', 0, 3 } )
AAdd( aRotUser, { 'Bloqueio Marca x Filial', 'U_JCOMA001()', 0, 3 } )
AAdd( aRotUser, { 'Alterar Cod. Fab.', 'U_JGENX007()', 0, 3 } )


Return (aRotUser)
