#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

User Function MA030ROT()

Local aArea	:=	GetArea() 
Local aRetorno := {}

AAdd( aRetorno, { "Log Alteração", "U_ROBGEN12('SA1',SA1->A1_COD,'')", 2, 0 } )

RestArea(aArea)

Return( aRetorno )

User Function CRM980MDef()

Local aRotina := {}
//----------------------------------------------------------------------------------------------------------
// [n][1] - Nome da Funcionalidade
// [n][2] - Função de Usuário
// [n][3] - Operação (1-Pesquisa; 2-Visualização; 3-Inclusão; 4-Alteração; 5-Exclusão)
// [n][4] - Acesso relacionado a rotina, se esta posição não for informada nenhum acesso será validado
//----------------------------------------------------------------------------------------------------------

AAdd(aRotina,{ "Log Alteração", "U_ROBGEN12('SA1',SA1->A1_COD,'')", MODEL_OPERATION_VIEW, 0 } )

Return( aRotina )
