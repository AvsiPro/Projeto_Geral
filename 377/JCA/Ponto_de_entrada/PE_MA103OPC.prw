#INCLUDE 'PROTHEUS.CH'

/*
    Ponto de entrada inclusão de itens menu documento de entrada
    MIT 44_ESTOQUE_EST003 - Boletim de entrada _  boletim de entrada de nota fiscal

    DOC MIT
    https://docs.google.com/document/d/1ryOUSqK-re9ttZwBiDu_xsL34cHlGjhA/edit
    DOC Entrega
    
    
*/

User Function MA103OPC()

Local aRet := {}

aAdd(aRet,{'Boletim de Entrada', 'U_JESTR003()', 0, 5})

Return aRet
