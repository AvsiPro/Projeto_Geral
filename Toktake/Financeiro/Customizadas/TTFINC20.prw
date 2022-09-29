#include "protheus.ch"
#include "fwmvcdef.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC20  บAutor  ณAlexandre Venancio  บ Data ณ  06/20/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Rotina utilizada para preparacao da rota de sangria       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTFINC20()
Local oBrowse
// Instanciamento da Classe de Browse
oBrowse := FWMBrowse():New()
// Defini็ใo da tabela do Browse
oBrowse:SetAlias('SZF')
// Titulo da Browse
oBrowse:SetDescription('Rota Tesouraria - Sangrias')
// Opcionalmente pode ser desligado a exibi็ใo dos detalhes    
oBrowse:SetFilterDefault( "ZF_ITEM=='001'" )
// Ativa็ใo da Classe
oBrowse:Activate()

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC20  บAutor  ณMicrosiga           บ Data ณ  06/20/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Criacao do menu padrao                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MenuDef()

Local aRotina := {}

ADD OPTION aRotina Title 'Visualizar' Action 'VIEWDEF.TTFINC20' OPERATION 2 ACCESS 0
//ADD OPTION aRotina Title 'Incluir' Action 'VIEWDEF.TTFINC20' OPERATION 3 ACCESS 0
ADD OPTION aRotina Title 'Incluir' Action 'U_TTFINC15("1")' OPERATION 3 ACCESS 0
ADD OPTION aRotina Title 'Alterar' Action 'VIEWDEF.TTFINC20' OPERATION 4 ACCESS 0
ADD OPTION aRotina Title 'Excluir' Action 'VIEWDEF.TTFINC20' OPERATION 5 ACCESS 0
ADD OPTION aRotina Title 'Imprimir' Action 'U_TTFINR13' OPERATION 8 ACCESS 0 
ADD OPTION aRotina Title 'Material Tec' Action 'U_TTFINC32' OPERATION 8 ACCESS 0 
//ADD OPTION aRotina Title 'Copiar' Action 'VIEWDEF.TTFINC20' OPERATION 9 ACCESS 0
//ADD OPTION aRotina Title 'Importar' Action 'U_TTPROC11' OPERATION 10 ACCESS 0

Return aRotina      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC20  บAutor  ณMicrosiga           บ Data ณ  06/20/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Criacao do modelo de dados                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ModelDef()
// Cria a estrutura a ser usada no Modelo de Dados
Local oStruZA0 := FWFormStruct( 1, 'SZF',{|cCampo| AllTrim(cCampo) $ "ZF_ROTA|ZF_DATA|ZF_RESP"} ) 
Local oStruZA1 := FWFormStruct( 1, 'SZF') 

Local oModel // Modelo de dados que serแ construํdo

// Cria o objeto do Modelo de Dados
oModel := MPFormModel():New('PEFINC20' )

// Adiciona ao modelo um componente de formulแrio
oModel:AddFields( 'ZFMASTER', /*cOwner*/, oStruZA0)

//GRID
oModel:AddGrid( 'SZFDETAIL', 'ZFMASTER', oStruZA1)

//RELACIONAMENTO ENTRE O CABECALHO E OS ITENS - PARA UTILIZACAO COM UMA UNICA TABELA
oModel:SetRelation( 'SZFDETAIL', { { 'ZF_FILIAL', 'xFilial( "SZF" )' }, { 'ZF_ROTA','ZF_ROTA' },{'ZF_DATA','ZF_DATA'} }, SZF->( IndexKey( 1 ) ) )

//DEFININDO A CHAVE PRIMARIA
oModel:SetPrimaryKey( {"ZF_FILIAL","ZF_ROTA","ZF_DATA"} )  

// Adiciona a descri็ใo do Modelo de Dados
oModel:SetDescription( 'Rota Diแria' )

// Adiciona a descri็ใo do Componente do Modelo de Dados
oModel:GetModel( 'ZFMASTER' ):SetDescription( 'Rota Diแria' )

// Retorna o Modelo de dados   
Return oModel              

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFINC20  บAutor  ณMicrosiga           บ Data ณ  06/20/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Criacao da View                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ViewDef()

// Cria um objeto de Modelo de dados baseado no ModelDef() do fonte informado
Local oModel := FWLoadModel( 'TTFINC20' )

// Cria a estrutura a ser usada na View
Local oStruZA0 := FWFormStruct( 2, 'SZF')
Local oStruZA1 := FWFormStruct( 2, 'SZF')

// Interface de visualiza็ใo construํda
Local oView              

// Cria o objeto de View
oView := FWFormView():New()

// Define qual o Modelo de dados serแ utilizado na View
oView:SetModel( oModel )         
          
oStruZA0:RemoveField('ZF_LACRE')
oStruZA0:RemoveField('ZF_CORLACR')
oStruZA0:RemoveField('ZF_ENVELOP')
oStruZA0:RemoveField('ZF_GLENVIE')
oStruZA0:RemoveField('ZF_MOEDA01')
oStruZA0:RemoveField('ZF_MOEDA02')
oStruZA0:RemoveField('ZF_MOEDA03')
oStruZA0:RemoveField('ZF_MOEDA04')
oStruZA0:RemoveField('ZF_MOEDA05')
oStruZA0:RemoveField('ZF_PATRIMO')
oStruZA0:RemoveField('ZF_CLIENTE')
oStruZA0:RemoveField('ZF_LOJA')
oStruZA0:RemoveField('ZF_RETMOE1')
oStruZA0:RemoveField('ZF_RETMOE2')
oStruZA0:RemoveField('ZF_RETMOE3')
oStruZA0:RemoveField('ZF_RETMOE4')
oStruZA0:RemoveField('ZF_RETMOE5') 
oStruZA0:RemoveField('ZF_ITEM') 
oStruZA0:RemoveField('ZF_CORLAGR') 
oStruZA0:RemoveField('ZF_ALTERAD')

oStruZA1:RemoveField('ZF_ITEM') 
oStruZA1:RemoveField('ZF_ROTA')
oStruZA1:RemoveField('ZF_DATA')
oStruZA1:RemoveField('ZF_RESP') 
oStruZA1:RemoveField('ZF_ALTERAD')
// Adiciona no nosso View um controle do tipo formulแrio 
// (antiga Enchoice)
oView:AddField( 'VIEW_SZF', oStruZA0, 'ZFMASTER' )
oView:AddGrid( 'VIEW_SZFD', oStruZA1, 'SZFDETAIL' )                                          
//oView:AddIncrementField( 'VIEW_ZZM', 'ZC_ITEM' )

// Criar um "box" horizontal para receber algum elemento da view
oView:CreateHorizontalBox( 'SUPERIOR', 20 ) 
oView:CreateHorizontalBox( 'INFERIOR', 80 )

// Relaciona o identificador (ID) da View com o "box" para exibi็ใo
oView:SetOwnerView( 'VIEW_SZF', 'SUPERIOR' )   
oView:SetOwnerView( 'VIEW_SZFD', 'INFERIOR' )

// Retorna o objeto de View criado
Return oView