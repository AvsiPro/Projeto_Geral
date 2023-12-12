#INCLUDE 'PROTHEUS.CH'
/*
    Ponto de entrada para tratamento de vendas perdidas
    MIT 44_ESTOQUE_EST009 - Rotina para apurar as vendas perdidas e consulta

    DOC MIT
    https://docs.google.com/document/d/19LU8dgLuT44NOOVOlN3fwa9iECYmcjHm/edit
    DOC ENTREGA
    
    
*/

User Function MT185GERA

Local aParam := PARAMIXB

Local aRet  := {}

//-- PARAMIXB[01] - Marca de selecao
//-- PARAMIXB[02] - Numero da SA
//-- PARAMIXB[03] - Item da SA
//-- PARAMIXB[04] - Produto
//-- PARAMIXB[05] - Descricao do Produto
//-- PARAMIXB[06] - Armazem
//-- PARAMIXB[07] - UM
//-- PARAMIXB[08] - Qtd. a Requisitar (Formato Caracter)
//-- PARAMIXB[09] - Qtd. a Requisitar
//-- PARAMIXB[10] - Centro de Custo
//-- PARAMIXB[11] - 2a.UM
//-- PARAMIXB[12] - Qtd. 2a.UM
//-- PARAMIXB[13] - Ordem de Producao
//-- PARAMIXB[14] - Conta Contabil
//-- PARAMIXB[15] - Item Contabil
//-- PARAMIXB[16] - Classe Valor
//-- PARAMIXB[17] - Projeto
//-- PARAMIXB[18] - Nr. da OS
//-- PARAMIXB[19] - Tarefa

//-- Customização do cliente

Return aRet
