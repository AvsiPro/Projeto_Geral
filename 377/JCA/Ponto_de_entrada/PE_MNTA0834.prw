#Include 'Totvs.ch'
#Include "FwMVCDef.ch"

/*
    Ponto de entrada criação de itens menu rotina Pneus

    MIT 44_PNEUS PNEU003_criacao_de_cadastro_de_pneus_com_base_em_um_ja_cadastrado_

    Doc Mit
    https://docs.google.com/document/d/1s8xV8QXObsMAKG7nH1nTinIv11RsfMws/edit

    Doc Validação entrega
    
    
    
*/

User Function MNTA0834()

Local aRotina := PARAMIXB[1]

    ADD OPTION aRotina Title 'Replicar Pneus' Action 'U_JGFRA006()'   OPERATION 9 ACCESS 0

Return aRotina
