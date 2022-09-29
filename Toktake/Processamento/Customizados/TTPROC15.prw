#include "protheus.ch"
#include "fwmvcdef.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC15  บAutor  ณAlexandre Venancio  บ Data ณ  06/20/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Rotina utilizada para lancamento e consulta de Sangria    บฑฑ
ฑฑบ          ณde Maquinas.							                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTPROC15()
Local oBrowse

If cEmpAnt <> "01"
	return
EndIF

// Instanciamento da Classe de Browse
oBrowse := FWMBrowse():New()
// Defini็ใo da tabela do Browse
oBrowse:SetAlias('SZN')
// Titulo da Browse
oBrowse:SetDescription('Sangria de Patrimonios') 
// Opcionalmente pode ser desligado a exibi็ใo dos detalhes    
oBrowse:SetFilterDefault( "!EMPTY(ZN_ROTA) .AND. ZN_TIPINCL='SANGRIA'" )
// Ativa็ใo da Classe
oBrowse:Activate()

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC15  บAutor  ณMicrosiga           บ Data ณ  06/20/13   บฑฑ
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

ADD OPTION aRotina Title 'Visualizar' Action 'VIEWDEF.TTPROC15' OPERATION 2 ACCESS 0
//ADD OPTION aRotina Title 'Incluir' Action 'VIEWDEF.TTPROC15' OPERATION 3 ACCESS 0
//ADD OPTION aRotina Title 'Alterar' Action 'VIEWDEF.TTPROC15' OPERATION 4 ACCESS 0
ADD OPTION aRotina Title 'Incluir' Action 'U_TTFINC24' OPERATION 3 ACCESS 0
ADD OPTION aRotina Title 'Alterar' Action 'U_TTFINC24' OPERATION 4 ACCESS 0
//ADD OPTION aRotina Title 'Excluir' Action 'VIEWDEF.TTPROC15' OPERATION 5 ACCESS 0
ADD OPTION aRotina Title 'Imprimir' Action 'U_TTFINR14()' OPERATION 8 ACCESS 0
ADD OPTION aRotina Title 'Extrato Rota' Action 'U_TTPROR40()' OPERATION 8 ACCESS 0
//ADD OPTION aRotina Title 'Encerrar' Action 'U_TTFINC26' OPERATION 9 ACCESS 0
//ADD OPTION aRotina Title 'Importar' Action 'U_TTPROC14' OPERATION 10 ACCESS 0

Return aRotina      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC15  บAutor  ณMicrosiga           บ Data ณ  06/20/13   บฑฑ
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
Local oStruZA0 := FWFormStruct( 1, 'SZN', {|cCampo| AllTrim(cCampo) $ "ZN_ROTA|ZN_DATA"} ) 
Local oStruZA1 := FWFormStruct( 1, 'SZN') //, {|cCampo| AllTrim(cCampo) $ "ZN_DATA|ZN_PATRIMO|ZN_TIPMAQ|ZN_NUMANT|ZN_NUMATU|ZN_COTCASH|ZN_BOTTEST"} ) 
Local oModel // Modelo de dados que serแ construํdo

// Cria o objeto do Modelo de Dados
oModel := MPFormModel():New('PEPROC15' )

// Adiciona ao modelo um componente de formulแrio
oModel:AddFields( 'ZNMASTER', /*cOwner*/, oStruZA0)

//GRID
oModel:AddGrid( 'SZNDETAIL', 'ZNMASTER', oStruZA1)

//RELACIONAMENTO ENTRE O CABECALHO E OS ITENS - PARA UTILIZACAO COM UMA UNICA TABELA
oModel:SetRelation( 'SZNDETAIL', { { 'ZN_FILIAL', 'xFilial( "SZN" )' }, { 'ZN_ROTA','ZN_ROTA' },{'ZN_DATA','ZN_DATA'} }, SZN->( IndexKey( 1 ) ) )

//DEFININDO A CHAVE PRIMARIA
oModel:SetPrimaryKey( {"ZN_FILIAL","ZN_ROTA"} )  

// Adiciona a descri็ใo do Modelo de Dados
oModel:SetDescription( 'Modelo de dados de Saldos' )

// Adiciona a descri็ใo do Componente do Modelo de Dados
oModel:GetModel( 'ZNMASTER' ):SetDescription( 'Sangrias' )

// Retorna o Modelo de dados   
Return oModel              

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC15  บAutor  ณMicrosiga           บ Data ณ  06/20/13   บฑฑ
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
Local oModel := FWLoadModel( 'TTPROC15' )

// Cria a estrutura a ser usada na View
Local oStruZA0 := FWFormStruct( 2, 'SZN')
Local oStruZA1 := FWFormStruct( 2, 'SZN')

// Interface de visualiza็ใo construํda
Local oView              

// Cria o objeto de View
oView := FWFormView():New()

// Define qual o Modelo de dados serแ utilizado na View
oView:SetModel( oModel )         

//oStruZA0:RemoveField('ZN_DATA')
oStruZA0:RemoveField('ZN_PATRIMO')
oStruZA0:RemoveField('ZN_TIPMAQ')
oStruZA0:RemoveField('ZN_CLIENTE')
oStruZA0:RemoveField('ZN_CODPA')
oStruZA0:RemoveField('ZN_DESCCLI')
oStruZA0:RemoveField('ZN_LOJA') 
oStruZA0:RemoveField('ZN_TROCO') 
oStruZA0:RemoveField('ZN_LACRE') 

oStruZA0:RemoveField('ZN_NUMANT')
oStruZA0:RemoveField('ZN_NUMATU')
oStruZA0:RemoveField('ZN_COTCASH')
oStruZA0:RemoveField('ZN_BOTTEST')
oStruZA0:RemoveField('ZN_BOTAO01')
oStruZA0:RemoveField('ZN_BOTAO02')
oStruZA0:RemoveField('ZN_BOTAO03')
oStruZA0:RemoveField('ZN_BOTAO04')
oStruZA0:RemoveField('ZN_BOTAO05')
oStruZA0:RemoveField('ZN_BOTAO06')
oStruZA0:RemoveField('ZN_BOTAO07')
oStruZA0:RemoveField('ZN_BOTAO08')
oStruZA0:RemoveField('ZN_BOTAO09')
oStruZA0:RemoveField('ZN_BOTAO10')
oStruZA0:RemoveField('ZN_BOTAO11')
oStruZA0:RemoveField('ZN_BOTAO12')

oStruZA0:RemoveField('ZN_BOTAO13')
oStruZA0:RemoveField('ZN_BOTAO14')
oStruZA0:RemoveField('ZN_BOTAO15')
oStruZA0:RemoveField('ZN_BOTAO16')
oStruZA0:RemoveField('ZN_BOTAO17')
oStruZA0:RemoveField('ZN_BOTAO18')
oStruZA0:RemoveField('ZN_BOTAO19')
oStruZA0:RemoveField('ZN_BOTAO20')
oStruZA0:RemoveField('ZN_BOTAO21')
oStruZA0:RemoveField('ZN_BOTAO22')
oStruZA0:RemoveField('ZN_BOTAO23')
oStruZA0:RemoveField('ZN_BOTAO24')
oStruZA0:RemoveField('ZN_BOTAO25')

oStruZA0:RemoveField('ZN_DESCCLI')
oStruZA0:RemoveField('ZN_TIPINCL')
oStruZA0:RemoveField('ZN_LACRMOE')
oStruZA0:RemoveField('ZN_LACRCED')
oStruZA0:RemoveField('ZN_MOEDA05')
oStruZA0:RemoveField('ZN_MOEDA10')
oStruZA0:RemoveField('ZN_MOEDA25')
oStruZA0:RemoveField('ZN_MOEDA50')
oStruZA0:RemoveField('ZN_MOEDA1R')
oStruZA0:RemoveField('ZN_BANANIN')
oStruZA0:RemoveField('ZN_LACCMOE')
oStruZA0:RemoveField('ZN_LACCCED')
oStruZA0:RemoveField('ZN_CARCOMR')
oStruZA0:RemoveField('ZN_CARCOMC')
oStruZA0:RemoveField('ZN_LOGC01')
oStruZA0:RemoveField('ZN_LOGC02')
oStruZA0:RemoveField('ZN_LOGC03')
oStruZA0:RemoveField('ZN_LOGC04')
oStruZA0:RemoveField('ZN_LOGC05')
oStruZA0:RemoveField('ZN_HORA')
oStruZA0:RemoveField('ZN_NOTA01')
oStruZA0:RemoveField('ZN_NOTA02')
oStruZA0:RemoveField('ZN_NOTA03')
oStruZA0:RemoveField('ZN_NOTA04')
oStruZA0:RemoveField('ZN_NOTA05')
oStruZA0:RemoveField('ZN_NOTA06')
oStruZA0:RemoveField('ZN_NOTA07')
oStruZA0:RemoveField('ZN_CONFERE')
oStruZA0:RemoveField('ZN_CORLACR')
oStruZA0:RemoveField('ZN_GLENVIE')  
oStruZA0:RemoveField('ZN_GLENVRE')
oStruZA0:RemoveField('ZN_CORLAGL')
oStruZA0:RemoveField('ZN_NUMOS')
oStruZA0:RemoveField('ZN_PARCIAL')
oStruZA0:RemoveField('ZN_PEDIDOS')

//oStruZA1:RemoveField('ZN_CLIENTE')
oStruZA1:RemoveField('ZN_CODPA')
oStruZA1:RemoveField('ZN_DATA') 
oStruZA1:RemoveField('ZN_CONFERE')
//oStruZA1:RemoveField('ZN_DESCCLI')
//oStruZA1:RemoveField('ZN_LOJA')
oStruZA1:RemoveField('ZN_ROTA') 
oStruZA1:RemoveField('ZN_NUMANT')
oStruZA1:RemoveField('ZN_NUMATU')
//oStruZA1:RemoveField('ZN_COTCASH')
oStruZA1:RemoveField('ZN_BOTTEST')
oStruZA1:RemoveField('ZN_BOTAO01')
oStruZA1:RemoveField('ZN_BOTAO02')
oStruZA1:RemoveField('ZN_BOTAO03')
oStruZA1:RemoveField('ZN_BOTAO04')
oStruZA1:RemoveField('ZN_BOTAO05')
oStruZA1:RemoveField('ZN_BOTAO06')
oStruZA1:RemoveField('ZN_BOTAO07')
oStruZA1:RemoveField('ZN_BOTAO08')
oStruZA1:RemoveField('ZN_BOTAO09')
oStruZA1:RemoveField('ZN_BOTAO10')
oStruZA1:RemoveField('ZN_BOTAO11')
oStruZA1:RemoveField('ZN_BOTAO12')
oStruZA1:RemoveField('ZN_DESCCLI')
oStruZA1:RemoveField('ZN_MOEDA05')
oStruZA1:RemoveField('ZN_MOEDA10')
oStruZA1:RemoveField('ZN_MOEDA25')
oStruZA1:RemoveField('ZN_MOEDA50') 
oStruZA1:RemoveField('ZN_NOTA02')
oStruZA1:RemoveField('ZN_NOTA03')
oStruZA1:RemoveField('ZN_NOTA04')
oStruZA1:RemoveField('ZN_NOTA05')
oStruZA1:RemoveField('ZN_NOTA06')
oStruZA1:RemoveField('ZN_NOTA07')
oStruZA1:RemoveField('ZN_TIPMAQ')     
oStruZA1:RemoveField('ZN_NUMOS')
oStruZA1:RemoveField('ZN_PARCIAL')
oStruZA1:RemoveField('ZN_PEDIDOS')



// Adiciona no nosso View um controle do tipo formulแrio 
// (antiga Enchoice)
oView:AddField( 'VIEW_SZN', oStruZA0, 'ZNMASTER' )
oView:AddGrid( 'VIEW_SZND', oStruZA1, 'SZNDETAIL' ) 
                                           
//oView:AddIncrementField( 'VIEW_SZND', 'ZN_ITEM' )

// Criar um "box" horizontal para receber algum elemento da view
oView:CreateHorizontalBox( 'SUPERIOR', 20 ) 
oView:CreateHorizontalBox( 'INFERIOR', 80 )

// Relaciona o identificador (ID) da View com o "box" para exibi็ใo
oView:SetOwnerView( 'VIEW_SZN', 'SUPERIOR' )
oView:SetOwnerView( 'VIEW_SZND', 'INFERIOR' )

// Retorna o objeto de View criado
Return oView