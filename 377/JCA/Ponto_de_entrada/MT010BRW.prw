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

AAdd( aRotUser, { 'Cadastro de Marcas', 'U_JCASCR01()', 0, 3 } )
AAdd( aRotUser, { 'Cadastro de Produtos x Marcas', 'U_JCASCR03()', 0, 3 } )

Return (aRotUser)
