#include "TOPCONN.CH"
#include "PROTHEUS.CH"  
#include "FWMVCDEF.CH"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Z07Tela  �Autor  �AVSI Pro  � Data �  18/11/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Mapa de maquina                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Z07Tela()

Local oBrowse
Private cCadastro := "Mapa de m�quina"

oBrowse := FWMBrowse():New()
oBrowse:SetAlias("Z07")
oBrowse:SetDescription(cCadastro)
             
oBrowse:AddLegend("Z07_STATUS=='1'","BLACK","Desativado")
oBrowse:AddLegend("Z07_STATUS=='2'","WHITE","Aguardando aprov.")
oBrowse:AddLegend("Z07_STATUS=='3'","GREEN","Ativo")

oBrowse:Activate()

Return
                   

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MenuDef  �Autor  �AVSI Pro   � Data �  15/12/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Menu do browse                                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function MenuDef()

Local aRotina := {} 
// Local cAlias := "Z07"

ADD OPTION aRotina TITLE 'Visualizar'   ACTION "U_Z07Chama(1)"    OPERATION 2                      ACCESS 0
ADD OPTION aRotina TITLE 'Incluir'      ACTION "U_CONOPC03(,.T.)"    OPERATION 3                      ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'      ACTION "U_Z07Chama(1)"    OPERATION 4                      ACCESS 0
ADD OPTION aRotina TITLE 'Excluir'      ACTION 'U_Z07Chama(3)' OPERATION 5                      ACCESS 0
ADD OPTION aRotina TITLE 'Layout Padr�o'ACTION 'U_Z07Chama(2)' OPERATION 5                      ACCESS 0

Return(aRotina)

User Function Z07Chama(nOpc)

Local cPatrim := Z07->Z07_CHAPA 

    If nOpc == 1
        U_CONOPC03(Z07->Z07_CHAPA,.F.)
    ElseiF nOpc == 2 
        U_CONOPC03(,.F.)
    else
        While !EOF() .AND. Alltrim(Z07->Z07_CHAPA) == Alltrim(cPatrim)
            Reclock("Z07",.F.)
            DbDelete()
            Z07->(Msunlock())        
            Dbskip()
        EndDo
        Msgalert("Processo finalizado!!!")
    EndIf 
Return 
