#INCLUDE 'PROTHEUS.CH'

/*
    PE Inclusão ícone chamada do relatório Requisição de material
    MIT 44_Frotas GFR003_Inclusao_icone_chamada_do_relatorio_requisicao_de_material

    DOC MIT
    https://docs.google.com/document/d/14-EqQa8iNDzj9u90g7bPk35clx4qJRAa/edit#heading=h.1qtg03d8a5nw
    DOC Entrega
    
    
*/

//
User Function MNTA420C()
 
    //Define Array contendo as Rotinas a executar do programa    
    // ----------- Elementos contidos por dimensao ------------   
    // 1. Nome a aparecer no cabecalho                            
    // 2. Nome da Rotina associada                                
    // 3. Usado pela rotina                                       
    // 4. Tipo de Transação a ser efetuada                        
    //    1 - Pesquisa e Posiciona em um Banco de Dados           
    //    2 - Simplesmente Mostra os Campos                       
    //    3 - Inclui registros no Bancos de Dados                 
    //    4 - Altera o registro corrente                          
    //    5 - Remove o registro corrente do Banco de Dados        
    //    6 - Altera determinados campos sem incluir novos Regs   
     
    aAdd( aRotina, { "Relação de peças", "U_JESTR001()", 0, 4 } )

    aAdd( aRotina, { "Imprimir OS", "U_JGFRR001()", 0, 4 } )
    
     
Return aRotina
