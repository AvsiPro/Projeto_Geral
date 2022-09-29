#include "protheus.ch"
#include "fwmvcdef.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTFINC13  �Autor  �Alexandre Venancio  � Data �  06/20/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Rotina utilizada para inclusao e manutencao de bandeiras  ���
���          �SITEF                                                       ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTFINC13()
Local oBrowse
// Instanciamento da Classe de Browse
oBrowse := FWMBrowse():New()
// Defini��o da tabela do Browse
oBrowse:SetAlias('ZZM')
// Titulo da Browse
oBrowse:SetDescription('Cadastro de Produto (Bandeiras)')
// Opcionalmente pode ser desligado a exibi��o dos detalhes
// Ativa��o da Classe
oBrowse:Activate()

Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTFINC13  �Autor  �Microsiga           � Data �  06/20/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Criacao do menu padrao                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MenuDef()

Local aRotina := {}

ADD OPTION aRotina Title 'Visualizar' Action 'U_TTFINC12("0")' OPERATION 2 ACCESS 0
//ADD OPTION aRotina Title 'Incluir' Action 'VIEWDEF.TTFINC13' OPERATION 3 ACCESS 0
ADD OPTION aRotina Title 'Incluir' Action 'U_TTFINC12("1")' OPERATION 3 ACCESS 0
ADD OPTION aRotina Title 'Alterar' Action 'U_TTFINC12("2")' OPERATION 4 ACCESS 0
ADD OPTION aRotina Title 'Excluir' Action 'VIEWDEF.TTFINC13' OPERATION 5 ACCESS 0
ADD OPTION aRotina Title 'Imprimir' Action 'VIEWDEF.TTFINC13' OPERATION 8 ACCESS 0
//ADD OPTION aRotina Title 'Copiar' Action 'VIEWDEF.TTFINC13' OPERATION 9 ACCESS 0
//ADD OPTION aRotina Title 'Importar' Action 'U_TTPROC11' OPERATION 10 ACCESS 0

Return aRotina      
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTFINC13  �Autor  �Microsiga           � Data �  06/20/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Criacao do modelo de dados                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ModelDef()
// Cria a estrutura a ser usada no Modelo de Dados
Local oStruZA0 := FWFormStruct( 1, 'ZZM') 
Local oModel // Modelo de dados que ser� constru�do

// Cria o objeto do Modelo de Dados
oModel := MPFormModel():New('PEFINC13' )

// Adiciona ao modelo um componente de formul�rio
oModel:AddFields( 'ZMMASTER', /*cOwner*/, oStruZA0)

//DEFININDO A CHAVE PRIMARIA
oModel:SetPrimaryKey( {"ZZM_FILIAL","ZZM_NOME"} )  

// Adiciona a descri��o do Modelo de Dados
oModel:SetDescription( 'Bandeiras' )

// Adiciona a descri��o do Componente do Modelo de Dados
oModel:GetModel( 'ZMMASTER' ):SetDescription( 'Bandeiras' )

// Retorna o Modelo de dados   
Return oModel              

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTFINC13  �Autor  �Microsiga           � Data �  06/20/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Criacao da View                                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ViewDef()

// Cria um objeto de Modelo de dados baseado no ModelDef() do fonte informado
Local oModel := FWLoadModel( 'TTFINC13' )

// Cria a estrutura a ser usada na View
Local oStruZA0 := FWFormStruct( 2, 'ZZM')

// Interface de visualiza��o constru�da
Local oView              

// Cria o objeto de View
oView := FWFormView():New()

// Define qual o Modelo de dados ser� utilizado na View
oView:SetModel( oModel )         

// Adiciona no nosso View um controle do tipo formul�rio 
// (antiga Enchoice)
oView:AddField( 'VIEW_ZZM', oStruZA0, 'ZMMASTER' )
                                           
//oView:AddIncrementField( 'VIEW_ZZM', 'ZC_ITEM' )

// Criar um "box" horizontal para receber algum elemento da view
oView:CreateHorizontalBox( 'SUPERIOR', 20 ) 
oView:CreateHorizontalBox( 'INFERIOR', 80 )

// Relaciona o identificador (ID) da View com o "box" para exibi��o
oView:SetOwnerView( 'VIEW_ZZM', 'SUPERIOR' )

// Retorna o objeto de View criado
Return oView