#include "protheus.ch"
#include "fwmvcdef.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC05  บAutor  ณAlexandre Venancio  บ Data ณ  06/19/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Consulta de Estoque inicial PA                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTPROC06()

Local oBrowse                
Local cQuery	
Local _aStru	:= {} 

If cEmpAnt <> "01"
	return
EndIF

AADD(_aStru,{"PRODUTO"		,"C",06,0})
AADD(_aStru,{"DESCRICAO"	,"C",25,0})
AADD(_aStru,{"SALDO"		,"N",07,2})

_cArq     := CriaTrab(_aStru,.T.)
_cIndice  := CriaTrab(Nil,.F.)

If Sele("TRB") <> 0
	TRB->(DbCloseArea())
Endif

dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)

cQuery := "SELECT DISTINCT C6_PRODUTO,C6_DESCRI FROM "+RetSQLName("SC6")
cQuery += " WHERE C6_DATFAT IN(SELECT MAX(C6_DATFAT) FROM "+RetSQLName("SC6")
cQuery += " 					WHERE C6_FILIAL='"+xFilial("SC6")+"' AND C6_LOCAL='P01064')
cQuery += " AND C6_LOCAL='P01064' AND D_E_L_E_T_=''"
 
If Select("TRBROTA") > 0
	dbSelectArea("TRBROTA")
	DbCloseArea()
EndIf
 
MemoWrite("TTFINR08.SQL",cQuery)

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRBROTA",.F.,.T.)

dbSelectArea("TRBROTA")
dbGotop()

Do While TRBROTA->(!Eof())
	DbSelectArea("TRB")
		
	/*----------------------------|
	|alimenta a tabela temporแria |
	|----------------------------*/
		
	RecLock("TRB",.T.) 

	TRB->PRODUTO 	:= TRBROTA->C6_PRODUTO
	TRB->DESCRICAO	:= TRBROTA->C6_DESCRI									
	TRB->SALDO	 	:= 0
	MsUnlock()	
		
	dbSelectArea("TRBROTA")
	DbSkip()
Enddo	

oBrowse := FWMBrowse():New()
oBrowse:SetAlias("TRB")
oBrowse:SetDescription('Saldos Iniciais')
             
//oBrowse:SetFilterDefault("B2_LOCAL=='P01064'")

oBrowse:Activate()

Return NIL 
               
Static Function MenuDef()
Return FWMVCMenu( "TTPROC06" )

Static Function ModelDef()

Local oStruSZ9 := FWFormStruct( 1, 'TRB' )//, {|cCampo| AllTrim(cCampo) $ "B2_LOCAL" })
Local oStruSZ9D := FWFormStruct( 1, 'TRB')//, {|cCampo| AllTrim(cCampo) $ "B2_COD|B2_QINI" })
Local oModel	// Modelo de dados que serแ construํdo

oModel := MPFormModel():New( 'MPPROC05', , /*{ |oModel| ModelPos(oModel) }*/ ) // Quando User Function nao pode ter o mesmo nome do fonte

oModel:AddFields( 'SZ9MASTER',/*Owner*/ , oStruSZ9 )
oModel:AddGrid( 'SZ9DETAIL', 'SZ9MASTER', oStruSZ9D, /*{ |oModelGrid, nLine, cAction, cField| MGridPre(oModelGrid, nLine, cAction, cField) }*/, /*{ |oModelGrid| MGridPos(oModelGrid) }*/ )

//oModel:SetRelation( 'SZ9DETAIL', { { 'B2_FILIAL', 'xFilial( "SB2" )' }, { 'B2_COD','B2_COD' } }, SB2->( IndexKey( 1 ) ) )
                
oModel:SetPrimaryKey({})

oModel:SetDescription( 'Cadastro de Tarefas' )

// Permite que Grid tenha ou nao pelo menos uma linha digitada
oModel:GetModel('SZ9DETAIL'):SetOptional(.F.)


Return oModel                   

Static Function ViewDef()

Local oModel := FWLoadModel( 'TTPROC05' )
Local oStruSZ9 := FWFormStruct( 2, 'TRB' )
Local oStruSZ9D := FWFormStruct( 2, 'TRB' )
Local oView
          
/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRemove campos da apresentacaoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/
/*
oStruSZ9:RemoveField('Z9_SEQ')
oStruSZ9:RemoveField('Z9_TAREFA')
oStruSZ9:RemoveField('Z9_AREA')
oStruSZ9:RemoveField('Z9_SLA')
oStruSZ9:RemoveField('Z9_CORELAC')
oStruSZ9:RemoveField('Z9_CONTROL')

oStruSZ9D:RemoveField('Z9_COD')
oStruSZ9D:RemoveField('Z9_DESC')
*/

oView := FWFormView():New()
oView:SetModel( oModel )

oView:AddField( 'VIEW_SB2M', oStruSZ9, 'SB2MASTER' )   
oView:AddGrid( 'VIEW_SB2D', oStruSZ9D, 'SB2DETAIL' ) 
            
//oView:AddIncrementField( 'VIEW_SZ9D', 'Z9_SEQ' )

oView:CreateHorizontalBox( 'SUPERIOR', 20 ) 
oView:CreateHorizontalBox( 'INFERIOR', 80 )

oView:SetOwnerView( 'VIEW_SB2M', 'SUPERIOR' )
oView:SetOwnerView( 'VIEW_SB2D', 'INFERIOR' )
                 
Return oView