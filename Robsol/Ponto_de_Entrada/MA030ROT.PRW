#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

User Function MA030ROT()

Local aArea	:=	GetArea() 
Local aRetorno := {}

AAdd( aRetorno, { "Log Altera��o", "U_ROBGEN12('SA1',SA1->A1_COD,'')", 2, 0 } )

RestArea(aArea)

Return( aRetorno )

User Function CRM980MDef()

Local aRotina := {}
//----------------------------------------------------------------------------------------------------------
// [n][1] - Nome da Funcionalidade
// [n][2] - Fun��o de Usu�rio
// [n][3] - Opera��o (1-Pesquisa; 2-Visualiza��o; 3-Inclus�o; 4-Altera��o; 5-Exclus�o)
// [n][4] - Acesso relacionado a rotina, se esta posi��o n�o for informada nenhum acesso ser� validado
//----------------------------------------------------------------------------------------------------------

AAdd(aRotina,{ "Log Altera��o", "U_ROBGEN12('SA1',SA1->A1_COD,'')", MODEL_OPERATION_VIEW, 0 } )

Return( aRotina )
