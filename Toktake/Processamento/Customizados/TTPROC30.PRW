#include "totvs.ch"
#include "fwmvcdef.ch"
#include "topconn.ch"
#INCLUDE "XMLXFUN.CH"
#Include "aarray.ch"
#Include "json.ch"  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC30  บAutor  ณJackson E. de Deus  บ Data ณ  13/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณManutencao das Ordens de Servico                            บฑฑ
ฑฑบ          ณ															  บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณJackson       ณ13/02/14ณ01.01 |Criacao                                 ณฑฑ
ฑฑณJackson       ณ27/05/14ณ01.02 |Criacao de funcao para Cancelamento     ณฑฑ
ฑฑณ								  de OS e funcao para busca do apontamentoณฑฑ
ฑฑณJackson       ณ29/07/14ณ01.03 |Criacao de funcao para desabilitar      ณฑฑ
ฑฑณ								  validacao da OS e correcao da janela	  ณฑฑ
ฑฑณ								  de inclusao de OS						  ณฑฑ
ฑฑณJackson       ณ08/10/14ณ01.04 |Ajustes na rotina de Obter apontamentos ณฑฑ
ฑฑณ								  e ver apontamentos com correcao dos	  ณฑฑ
ฑฑณ								  lancamentos na SZN-SZF				  ณฑฑ
ฑฑณJackson       ณ19/03/15ณ01.05 |Nova opcao de transferencia de OS		  ณฑฑ
ฑฑณ								  Alteracao no cancelamento ed OS		  ณฑฑ
ฑฑณJackson       ณ16/08/16ณ01.06 |Alteracoes para novo app				  ณฑฑ
ฑฑณ								  		  								  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function TTPROC30()

Local oBrowse
Private cCadastro := "Manuten็ใo de Ordens de Servi็o"
Private cRota	:=	''
Private cUsrPerm := GetMV("MV_XINCOS")

If cEmpAnt <> "01"
	return
EndIF

If ! UPPER(cUserName) $ UPPER(cUsrPerm)
	Alert("Voc๊ nใo tem permissใo para acessar essa rotina.","TTPROC30")
	Return
EndIf                                    

dbSelectArea("SX2")
SX2->(dbSetOrder(1))
If !SX2->(dbSeek("SZG"))
	ShowHelpDlg("SZG", {"Tabela: SZG" + CRLF + " Nใo encontrada no cadastro de tabelas (SX2)."},5,{"Nใo ้ possํvel continuar."},5)							
	Return
EndIf

oBrowse := FWMBrowse():New()
oBrowse:SetAlias("SZG")
//oBrowse:SetFilterDefault( "ZG_NOVOFRM=='T'" )
oBrowse:SetDescription(cCadastro)
                                                                          
oBrowse:AddLegend("AllTrim(ZG_STATUS) == 'OPEN'","WHITE"	,"Criado")
oBrowse:AddLegend("AllTrim(ZG_STATUS) == 'ACTE'","YELLOW"	,"Recebido pelo Agente")
oBrowse:AddLegend("AllTrim(ZG_STATUS) == 'INIC'","PINK"		,"Iniciado")
oBrowse:AddLegend("AllTrim(ZG_STATUS) == 'CTEC'","GRAY"		,"Cancelado pelo Agente")
oBrowse:AddLegend("AllTrim(ZG_STATUS) == 'COPE'","BROWN"	,"Cancelado pela Central")
oBrowse:AddLegend("AllTrim(ZG_STATUS) == 'FIOK'","GREEN"	,"Finalizado")

oBrowse:Activate()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMenuDef   บAutor  ณJackson E. de Deus  บ Data ณ  10/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ MenuDef. Define o menu do Browse.                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MenuDef()

Local aRotina	:= {}

ADD OPTION aRotina TITLE 'Pesquisar'				ACTION 'PesqBrw'			OPERATION 1 ACCESS 0
ADD OPTION aRotina TITLE 'Visualizar'				ACTION 'U_TTPROC32(2)'		OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Incluir'					ACTION 'U_TTPROC32(3)'		OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Cancelar'					ACTION 'U_TTPROC32(5)'		OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE 'Ver apontamentos'			ACTION 'U_TTPROC32(6)'		OPERATION 6 ACCESS 0
ADD OPTION aRotina TITLE 'Processar'				ACTION 'U_TTPROC32(11)'		OPERATION 11 ACCESS 0
ADD OPTION aRotina TITLE 'Transferir'				ACTION 'U_TTPROC32(8)'		OPERATION 8 ACCESS 0 
ADD OPTION aRotina TITLE 'Email cliente'			ACTION 'U_TTPROC32(10)'		OPERATION 10 ACCESS 0
ADD OPTION aRotina TITLE 'Reenviar OS'				ACTION 'U_TTPROC32(12)'		OPERATION 10 ACCESS 0
ADD OPTION aRotina TITLE 'Gerar Plano Trab'			ACTION 'U_TTPROC32(13)'		OPERATION 10 ACCESS 0


Return(aRotina)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC32  บAutor  ณJackson E. de Deus  บ Data ณ  11/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExecuta a rotina adequada de acordo com a opcao do Browse   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TTPROC32(nOpc)

// visualiza OS - dados da SZG      
If nOpc == 2
	Visual()                  
// inclui nova OS	
ElseIf nOpc == 3
	Incluir()    
// cancela OS	
ElseIf nOpc == 5
	Cancelar()
// mostra apontamentos da OS		
ElseIf nOpc == 6
	Respostas()             
// transferencia de Os
ElseIf nOpc == 8
	TransfOS()
// legenda da tela	
ElseIf nOpc == 9
	Legenda()    
// reenviar email cliente
ElseIf nOpc == 10
	ReMail()
// processar respostas
ElseIf nOpc == 11
	fProcXml()
ElseIf nOpc == 12
	ReenvOS()    
// plano trab
ElseIf nOpc == 13	
	PlanoTrb()
EndIf

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLegenda  บAutor  ณJackson E. de Deus  บ Data ณ  14/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria tela de legendas das OS na tela                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Legenda()

BrwLegenda(cCadastro,"Status",{{"BR_BRANCO","Criado"},;
                               {"BR_AMARELO","Recebido pelo Agente"},;
                               {"BR_PINK","Iniciado"},;
                               {"BR_CINZA","Cancelado pelo Agente"},;
                               {"BR_MARROM","Cancelado pela Central"},;
                               {"BR_VERDE","Finalizado"} })      

 
                                                        
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVisual    บAutor  ณJackson E. de Deus  บ Data ณ  13/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVisualiza a Ordem de Servico                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Visual()

Local aCampos := {"NOUSER","ZG_NUMOS","ZG_FORM","ZG_DESCFRM","ZG_CODTEC","ZG_AGENTED","ZG_CLIFOR","ZG_LOJA","ZG_DESCCF",;
					"ZG_PATRIM","ZG_PATRIMD","ZG_DOC","ZG_SERIE","ZG_TPDOC","ZG_ROTA","ZG_ROTAD","ZG_DTCRIAC","ZG_HRCRIAC",;
					"ZG_DATAINI","ZG_HORAINI","ZG_DATAFIM","ZG_HORAFIM","ZG_DTCANC","ZG_HRCANC","ZG_STATUS","ZG_STATUSD",;
					"ZG_OBS", "ZG_OBSRET","ZG_EOS","ZG_MSG","ZG_ENVIO","ZG_RESPOST","ZG_OBSCANC"}
                        
AxVisual('SZG',Recno(),2,aCampos,,,,/*aButtons*/)    

Return
      


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIncluir   บAutor  ณJackson E. Deus     บ Data ณ  13/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณInclui uma nova Ordem de Servico                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Incluir()

Local aDimension	:= MsAdvSize()
Local cNumeOs		:= ""	
Local aButtons		:= {} //{ {"HISTORIC", { || Patrim(2) }, "Maquinas", "Maquinas" , {|| .T.} } }
Local bTudoOk		:= { || cNumeOs := Gravar(1),oDlg:End() }
Local bCancel		:= { || oDlg:End() }
Local lMemoria		:= .T.
Local aCpoZG		:= { "NOUSER","ZG_NUMOS","ZG_ROTA","ZG_ROTAD","ZG_CODTEC","ZG_AGENTED","ZG_CLIFOR","ZG_LOJA","ZG_DESCCF","ZG_PATRIM","ZG_PATRIMD","ZG_DOC","ZG_SERIE","ZG_TPDOC","ZG_FORM","ZG_DESCFRM","ZG_MSG","ZG_DATAINI","ZG_HORAINI" }
Local aPos			:= {}
Local aPos2			:= {}
Local aObjects		:= {}
Local aInfo			:= {}
Local aPosObj		:= {}
Local lOk			:= .F.
Local oDlg               
Local nOpcc			:= 0
Private cDescFrm	:= ""
Private aAlter		:= { "ZG_ROTA","ZG_CODTEC","ZG_CLIFOR","ZG_LOJA","ZG_PATRIM","ZG_DOC","ZG_SERIE","ZG_TPDOC","ZG_FORM","ZG_MSG","ZG_DATAINI","ZG_HORAINI" }

// cria as variaveis de memoria
RegToMemory("SZG",.T.)

// Monta a tela
oDlg	:= MSDialog():New( aDimension[7],aDimension[1],aDimension[6],aDimension[5],"Inclusใo de Ordem de Servi็o",,,.F.,,,,,,.T.,,,.T. )
	
	oEnchZG	:= MsmGet():New("SZG",,3,,,,aCpoZG,{0,0,0,0},aAlter,,,,,oDlg,,lMemoria,.T.) 					
	oEnchZG:oBox:Align := CONTROL_ALIGN_ALLCLIENT                                                     

	EnchoiceBar(oDlg,bTudoOk,bCancel,,@aButtons )
	
oDlg:Activate(,,,.T.)


Return(cNumeOs)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC30  บAutor  ณMicrosiga           บ Data ณ  08/18/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PlanoTrb()

Local aPergs := {}
Local aRet := {}
Local cRota := ""
Local nQtdOS := 0
Local cMsg := ""


aAdd(aPergs ,{1,"Rota"	,Space(6),"@!",".T.","ZZ1",".T.",60,.F.})

If !ParamBox(aPergs ,"Configure a Rota",@aRet)
	Return                                     
Else
	cRota := aRet[1] 
EndIf		


//If !Empty(cRota)
	If MsgYesNo("Confirma a gera็ใo de OS para a Rota " +cRota +" ?")
		Processa( { || nQtdOS := U_TTOPER02({"01","01",cRota,.F.}) }, "Gerando ordens de servi็o.." )		    
		If nQtdOS == 0
			cMsg := "Nenhuma Ordem de Servi็o foi criada." +CRLF +"A cria็ใo de Ordem de Servi็o para a Rota depende do plano de trabalho configurado."
		Else
			cMsg := "Foram incluํdas " +cvaltochar(nQtdOS) + " OS."
		EndIf
		
		Aviso("",cMsg,{"Ok"})
	EndIf 
//EndIf      

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCancelar  บAutor  ณJackson E. de Deus  บ Data ณ  27/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCancelamento de OS				                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Cancelar()

Local aArea := GetArea()
Local aPergs	:= {}
Local aRet		:= {}
Local cNumOSDe	:= ""
Local cNumOSAte := ""
Local cRotaDe	:= ""
Local cRotaAte	:= ""
Local dDataIni	:= stod("")
Local dDataFim  := stod("") 
Local aTpCanc	:= {"Cancelado pela Central","Cancelado pelo Agente"}
Local aArea		:= GetArea()
Local nCnt		:= 0
Local nTpCanc	:= 0
Local cObsCanc	:= ""

// data - considerar data de encerramento
aAdd(aPergs ,{1,"OS De"		,SZG->ZG_NUMOS,"@!",".T.","",".T.",60,.F.})
aAdd(aPergs ,{1,"OS Ate"	,SZG->ZG_NUMOS,"@!",".T.","",".T.",60,.F.})
aAdd(aPergs ,{1,"Rota De"	,SZG->ZG_ROTA,"@!",".T.","ZZ1",".T.",60,.F.})
aAdd(aPergs ,{1,"Rota Ate"	,SZG->ZG_ROTA,"@!",".T.","ZZ1",".T.",60,.F.})
aAdd(aPergs ,{1,"Data De"	,dDatabase,"99/99/99","","","",50,.F.})
aAdd(aPergs ,{1,"Data Ate"	,dDatabase,"99/99/99","","","",50,.F.})
aAdd(aPergs ,{3,"Tipo Canc.",1,aTpCanc,100,"",.F.})
aAdd(aPergs ,{1,"Motivo?"	,Space(100),"@!",".T.","",".T.",60,.T.})

If !ParamBox(aPergs ,"Cancelamento",@aRet,,,,,,,"ttproc30_cancel.txt",.T.)
	Return                                     
Else
	cNumOSDe := aRet[1] 
	cNumOSAte := aRet[2]
	cRotaDe := aRet[3] 
	cRotaAte := aRet[4] 
	dDataIni := aRet[5]
	dDataFim := aRet[6]
	nTpCanc := aRet[7]
	cObsCanc := AllTrim(UPPER(aRet[8]))
EndIf		

If MsgYesNo("Confirma o cancelamento?") 
	Processa( { || nCnt := ProcCanc(cNumOSDe,cNumOSAte,cRotaDe,cRotaAte,dDataIni,dDataFim,nTpCanc,cObsCanc) },"Cancelando OS, aguarde.." ) 
	Aviso("TTPROC30-Cancelar","Total canceladas: " +CRLF +cvaltochar(nCnt),{"Ok"})
EndIf

RestArea(aArea)

Return nCnt

      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProcCanc  บAutor  ณJackson E. de Deus  บ Data ณ  26/01/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa o cancelamento das OS                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ProcCanc( cNumOSDe,cNumOSAte,cRotaDe,cRotaAte,dDataIni,dDataFim,nTpCanc,cObsCanc )

Local lRet := .F.
Local oXml
Local cError := ""
Local cWarning := ""
Local cStatusOS := ""
Local cSql := ""
Local nTot := 0
Local nCnt := 0      
Local cStatus := ""
Local cDescStat := ""
Local lNovoFrm := SZG->ZG_NOVOFRM
Local cRegID1 := ""
Local aaNotif := Nil
Local cNPush1 := ""
Local cRetEnvio := ""
Local nI

If nTpCanc == 1
	cStatus := "COPE"                   
	cDescStat := "Cancelado pelo Atendente"
ElseIf nTpCanc == 2
	cStatus := "CTEC"
	cDescStat := "Cancelado pelo Agente"
EndIf 


dbSelectArea("SZG")
dbSetOrder(1)

cSql := "SELECT ZG_NUMOS, R_E_C_N_O_ ZGREC FROM " +RetSqlName("SZG") 
cSql += " WHERE "
cSql += " ZG_NUMOS BETWEEN '"+cNumOSDe+"' AND '"+cNumOSAte+"' "
cSql += " AND ZG_ROTA BETWEEN '"+cRotaDe+"' AND '"+cRotaAte+"' "
cSql += " AND ZG_DATAINI BETWEEN '"+dtos(dDataIni)+"' AND '"+dtos(dDatafim)+"' " 
cSql += " AND ZG_STATUS NOT IN ( 'FIOK','CTEC','COPE','CCLI' ) AND D_E_L_E_T_ = '' "
cSql += " ORDER BY ZG_NUMOS "

If Select("TRBZ") > 0
	TRBZ->(dbCloseArea())
EndIf

dbUseArea( .T., "TOPCONN", TcGenQry(,,cSql), "TRBZ", .F. ,.F. )
dbSelectArea("TRBZ")
While !EOF()
	nTot++
	dbSkip()
End


ProcRegua(nTot)
dbGoTop()
While TRBZ->( !EOF() )
	IncProc( "# OS " +AllTrim(TRBZ->ZG_NUMOS) )
	dbSelectArea("SZG")
	nRecno := TRBZ->ZGREC
	dbGoTo(nRecno)
	If Recno() == nRecno
		If ! AllTrim(SZG->ZG_STATUS) $ "FIOK|CTEC|COPE|CCLI"
							
			If RecLock("SZG",.F.)
				SZG->ZG_STATUS := cStatus
				SZG->ZG_STATUSD := cDescStat
				SZG->ZG_DTCANC := Date()
				SZG->ZG_HRCANC := Time()
				SZG->ZG_OBSCANC := cObsCanc
				MsUnLock()
				
				dbSelectArea("SZS")
				dbSetOrder(2)
				If msSeek( xFilial("SZS") +AvKey( SZG->ZG_CODTEC,"ZS_CODTEC" ) )    
					cRegID1 := AllTrim(SZS->ZS_IDGCM)
					
					// envia para atendente
					// String JSON para Push          
					aaNotif := Array(#)
					aaNotif[#'tag'] := "os"
					aaNotif[#'os'] := Val(SZG->ZG_NUMOS)
					aaNotif[#'operacao'] := "cancel"
					cNPush1 := ToJson(aaNotif)
				
					// cancelamento
					If !Empty(cRegID1) .And. !Empty(cNPush1)
						For nI := 1 To 5
							cRetEnvio := U_GOOGLE01(cRegID1,cNPush1)
							If "200 OK" $ cRetEnvio
								Exit
							EndIf
						Next nI
					EndIf
				EndIf
									
				nCnt++
			EndIf      

			dbSelectArea("TRBZ")
			
		EndIf 
	EndIf
            	
	dbSelectArea("TRBZ")
	TRBZ->( dbSkip() )
End

Return nCnt


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjsOS บAutor  ณJackson E. de Deus      บ Data ณ  17/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ajuste em SZN e SZF apos o cancelamento de OS              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AjsOS(cNumOS)

Local cQuery := ""
Local aArea := GetArea()


dbSelectArea("SZG")
If dbSeek( xFilial("SZG") +AvKey(cNumOS,"ZG_NUMOS") )
	cQuery := "SELECT ZF.R_E_C_N_O_ AS ZFR "
	cQuery += " FROM "+RetSQLName("SZF")+" ZF "
	cQuery += " WHERE ZF_FILIAL='"+xFilial("SZF")+"' "
	cQuery += " AND ZF.D_E_L_E_T_ = '' AND ZF_PATRIMO = '"+SZG->ZG_PATRIM+"' AND ZF_DATA = '"+DTOS(SZG->ZG_DATAINI)+"' "
	cQuery += " AND ZF_ROTA = '"+SZG->ZG_ROTA+"' "
	
	If Select("TRB") > 0
		dbSelectArea("TRB")
		dbCloseArea()
	EndIf
	  
	MemoWrite("TTATFC07.SQL",cQuery)
	
	cQuery:= ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.F.,.T.)   
		
	dbSelectArea("TRB")
	If TRB->ZFR > 0
		//Marcando o registro da preparacao de lacre com a informacao de cancelamento daquele item na rota
		dbSelectArea("SZF")
		dbGoTo(TRB->ZFR)
		If Recno() == TRB->ZFR
			Reclock("SZF",.F.)
			SZF->ZF_ALTERAD := 'R'
			SZF->(Msunlock())     
		EndIf
	EndIf
EndIf

RestArea(aArea)

Return 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTransfOS  บAutor  ณJackson E. de Deus  บ Data ณ  13/02/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Transferencia de OS                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function	TransfOS()

Local cAgente := AllTrim(SZG->ZG_AGENTED)
Local cAgenteNovo := ""
Local nAgente := 0
Local lOk := .F.
Local lNovoFrm := SZG->ZG_NOVOFRM

If AllTrim(SZG->ZG_STATUS) $ "FIOK"
	Alert("Ordem de Servi็o jแ finalizada.")
	Return
EndIf

If AllTrim(SZG->ZG_STATUS) $ "COPE|CTEC"
	Alert("Ordem de Servi็o cancelada.")
	Return
EndIf

                             
lRet := ConPad1(,,,"AA1",,,.F.)
If lRet
	nAgente := Val(AA1->AA1_PAGER)
	cAgenteNovo := AllTrim(AA1->AA1_NOMTEC)
	If MsgNoYes("Confirma a transfer๊ncia de OS?" +CRLF +"Agente atual: " +cAgente +CRLF +"Agente novo: " +cAgenteNovo )
		If !lNovoFrm
			//Processa( { || lOk := ProcTransf(SZG->ZG_NUMOS,nAgente)  },"Transfer๊ncia de ordem de servi็o, aguarde..")
		Else
			Processa( { || lOk := PrcTnsf2(SZG->ZG_NUMOS,AA1->AA1_CODTEC)  },"Transfer๊ncia de ordem de servi็o, aguarde..")
		EndIf
		If lOk
			Aviso("","Ordem de Servi็o transferida.",{"Ok"})
		EndIf
	EndIf
EndIf                  

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC30  บAutor  ณMicrosiga           บ Data ณ  01/27/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PrcTnsf2(cNumOs,cTecnico)

Local lRet := .F.
Local cAgntOld := SZG->ZG_CODTEC
Local cNomAgOld := SZG->ZG_AGENTED
Local aaNotif := Nil
Local aaNotif2 := Nil
Local cRegID1 := ""
Local cRegID2 := ""
Local nI
Local cRetEnvio := ""
Local lEnviou := .F.

IncProc("Transferindo Ordem de Servi็o..")

dbSelectArea("SZS")
dbSetOrder(2)
If msSeek( xFilial("SZS") +AvKey( SZG->ZG_CODTEC,"ZS_CODTEC" ) )    
	cRegID1 := AllTrim(SZS->ZS_IDGCM)
EndIf

If msSeek( xFilial("SZS") +AvKey( cTecnico,"ZS_CODTEC" ) )    
	cRegID2 := AllTrim(SZS->ZS_IDGCM)
EndIf 

If RecLock("SZG",.F.)
	SZG->ZG_CODTEC := cTecnico
	SZG->ZG_AGENTE := 0 
	SZG->ZG_AGENTED := AA1->AA1_NOMTEC
	SZG->ZG_ROTA := AA1->AA1_LOCAL
	SZG->ZG_STATUS := "OPEN"
	SZG->ZG_STATUSD := "Criada"
	SZG->ZG_OBS := "TRANSFERIDA - AGENTE ANT.: " +cAgntOld + "/" +cNomAgOld 
	SZG->( MsUnLock() )
	
	// envia para novo atendente
	// String JSON para Push          
	aaNotif := Array(#)
	aaNotif[#'tag'] := "os"
	aaNotif[#'os'] := Val(cNumOS)
	aaNotif[#'operacao'] := "cancel"
	cNPush1 := ToJson(aaNotif)
	
	// String JSON para Push          
	aaNotif2 := Array(#)
	aaNotif2[#'tag'] := "os"
	aaNotif2[#'os'] := Val(cNumOS)
	aaNotif2[#'operacao'] := "novo"
	cNPush2 := ToJson(aaNotif2)
	
	// cancelamento
	If !Empty(cRegID1) .And. !Empty(cNPush1) .And. !Empty(cRegID2) .And. !Empty(cNPush2)
		For nI := 1 To 5
			cRetEnvio := U_GOOGLE01(cRegID1,cNPush1)
			If "200 OK" $ cRetEnvio
				lEnviou := .T. 
				Exit
			EndIf
		Next nI
		If !lEnviou
			MsgAlert("Houve erro ao disparar a notifica็ใo para o atendente anterior. Tente novamente.")
		Else
			For nI := 1 To 5
				cRetEnvio := U_GOOGLE01(cRegID2,cNPush2)
				If "200 OK" $ cRetEnvio
					lEnviou := .T. 
					Exit
				EndIf
			Next nI
			If !lEnviou
				MsgAlert("Houve erro ao disparar a notifica็ใo para o novo antendente. Utilize a op็ใo Reenviar OS.")
			Else
				MsgInfo("Ordem de Servi็o transferida.")
			EndIf
		EndIf
	EndIf 
	
	lRet := .T.
		                 
EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChk       บAutor  ณJackson E. de Deus  บ Data ณ  13/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณverifica se os campos estao ok antes de criar a OS          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Chk()

Local aArea := GetArea()
Local lRet := .T.
Local cCodPA := ""
Local cErro := ""

If Empty( M->ZG_FORM )
	Aviso("","Preencha o c๓digo do formulแrio.",{"Ok"})
	Return .F.
EndIf

If Empty( M->ZG_CODTEC )
	Aviso("","Preencha o c๓digo do Atendente.",{"Ok"})
	Return .F.
EndIf

dbSelectArea("SZS")
dbSetOrder(2)
If !MSSeek( "01" +AvKey(M->ZG_CODTEC,"ZS_CODTEC") )
	Aviso("","O Atendente nใo estแ vinculado em nenhum aparelho.",{"Ok"})
	Return .F.
EndIf

// por tipo de formulario
If M->ZG_FORM $ "01#13"
	If Empty(M->ZG_DOC) .OR. Empty(M->ZG_SERIE)
		Aviso("","Preencha a nota fiscal e s้rie.",{"Ok"})
		Return .F.
	EndIf
EndIf

If M->ZG_FORM $ "02#03#04#06#08#16#17"
	If Empty(M->ZG_PATRIM)
		Aviso("","Preencha o c๓digo do patrim๔nio.",{"Ok"})
		Return .F.
	EndIf
EndIf
             

// validacao pra nao deixar gerar a OS caso esteja prestando contas - REF TTPROC57.PRW
// abastecimento
If M->ZG_FORM $ "04#08"
	cCodPa := Posicione( "SN1",2,xFilial("SN1") +AvKey(M->ZG_PATRIM,"N1_CHAPA"),"N1_XPA" )
	STATICCALL( TTFATC30, isClosing, cCodPa,@cErro )
	
	If !Empty( cErro )
		Aviso("",cErro,{"Ok"})
		RestArea(aArea)	
		Return .F.
	EndIf
	
// entregas
ElseIf M->ZG_FORM == "13"

	dbSelectArea("SF2")
	dbSetOrder(2)
	If MsSeek( xFilial("SF2") +AvKey(M->ZG_CLIFOR,"F2_CLIENTE") +AvKey(M->ZG_LOJA,"F2_LOJA") +AvKey(M->ZG_DOC,"F2_DOC") +AvKey(M->ZG_SERIE,"F2_SERIE") )				
		If AllTrim(SF2->F2_XFINAL) == "4" .And. AllTrim(SF2->F2_XNFABAS) == "1"
			cCodPA := SF2->F2_XCODPA
			
			STATICCALL( TTFATC30, isClosing, cCodPa,@cErro )
	
			If !Empty( cErro )
				Aviso("",cErro,{"Ok"})
				RestArea(aArea)	
				Return .F.
			EndIf
		EndIf	
	EndIf			

EndIf


Return lRet

      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGravar    บAutor  ณJackson E. de Deus  บ Data ณ  13/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera a Ordem de Servico                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Gravar(nOpca)

Local oDlg
Local aDoc := {}                                                                
Local cNumOS := ""
Local cMsg := ""
Local nQtdOS := 0
Local aInfLacr := {}  
Local cCodPa	:=	''
Local cProblema := Space(100)
Local cDadosCnt := "" 
Local cPa := ""
Local cHoraAgen := M->ZG_HORAINI
Local cDtAgen := M->ZG_DATAINI
Local cCallCenter := ""
Local cDescProd := ""
Local cLocFis := ""
Local cVolt := ""
Local cItem := ""
Local aSisPg := {}
Local nTpInv := 1
Local aDados := {}
Local cTabPreco := ""
Local cEndereco := ""
Local cTpAbast := ""
Local aInfo := {}
Local cModelo := ""
Local cLocal := ""
LOcal cLocFis := ""
Local aInfLacre := {}

If !Chk()
	Return cNumOS
EndIf

If !Empty(M->ZG_FORM)
	If AllTrim(M->ZG_FORM) <> "01" .And. AllTrim(M->ZG_FORM) <> "21"
		If !Empty(M->ZG_PATRIM)
		                         
			aInfo := {}
			If M->ZG_FORM $ "03#04#08"
				aInfo := dlgLacre(M->ZG_PATRIM)
			EndIf
			           
			// troca de tabela? - TESTE
			If M->ZG_FORM $ "04#08"
				//AADD( aInfo, { "trocatabela",.T. } )
			EndIf
		
			cTabPreco := Posicione( "SN1",2,xFilial("SN1") +AvKey(M->ZG_PATRIM,"N1_CHAPA"),"N1_XTABELA" )
			cCodPA := Posicione( "SN1",2,xFilial("SN1") +AvKey(M->ZG_PATRIM,"N1_CHAPA"),"N1_XPA" )
			cModelo := Posicione( "SN1",2,xFilial("SN1") +AvKey(M->ZG_PATRIM,"N1_CHAPA"),"N1_PRODUTO" )
			cLocFis := Posicione( "SN1",2,xFilial("SN1") +AvKey(M->ZG_PATRIM,"N1_CHAPA"),"N1_XLOCINS" )
			cTpAbast := "1"	
			cTipBeb := Posicione("SB1",1,xFilial("SB1") +AvKey(cModelo,"B1_COD"),"B1_XFAMILI")    
			If cTipBeb == "144"
				cTpAbast := "3"
			ElseIf cTipBeb == "153"
				cTpAbast := "2"
			EndIf     
			
			If AllTrim(M->ZG_FORM) == "04"
				If cTpAbast == "2" .Or. cTpAbast == "3"
					MsgAlert("A mแquina ้ de bebidas. Altere o formulแrio para formulแrio de abastecimento de bebidas.")
					Return cNumOS
				EndIf
			ElseIf AllTrim(M->ZG_FORM) == "08"
				If cTpAbast == "1"
					MsgAlert("A mแquina ้ de lanches. Altere o formulแrio para formulแrio de abastecimento.")
					Return cNumOS
				EndIf
			EndIf
						
			If !Empty(cCodPA)
				dbSelectArea("ZZ1")
				dbSetOrder(1)
				If MsSeek( xFilial("ZZ1") +AvKey(cCodPA,"ZZ1_COD") )
					cEndereco += AllTrim(ZZ1->ZZ1_END) +"," +AllTrim(ZZ1->ZZ1_MUN) +"," +AllTrim(ZZ1->ZZ1_EST) +CRLF +cLocFis
					cLocal := AllTrim(ZZ1->ZZ1_DESCRI)
				EndIf
			Else
				MsgAlert("Patrim๔nio sem PA! Verifique.")
				Return cNumOS
			EndIf			
		EndIf	
	Else
		If AllTrim(M->ZG_FORM) == "01"
			If AllTrim(M->ZG_TPDOC) == "1"
				cEndereco := "TOK TAKE - EXPEDIวรO"
				cLocal := "TOK TAKE"
			Else				
				cEndereco := ""
			EndIf
			
					
		ElseIf AllTrim(M->ZG_FORM) == "06"
			aInfo := {{"DEFEITO",""}}
					
		ElseIf AllTrim(M->ZG_FORM) == "13"
			dbSelectArea("SF2")
			dbSetOrder(2)
			If MsSeek( xFilial("SF2") +AvKey(M->ZG_CLIFOR,"F2_CLIENTE") +AvKey(M->ZG_LOJA,"F2_LOJA") +AvKey(M->ZG_DOC,"F2_DOC") +AvKey(M->ZG_SERIE,"F2_SERIE") )				
				If AllTrim(SF2->F2_XFINAL) == "4" .And. AllTrim(SF2->F2_XNFABAS) == "1"
					cCodPA := SF2->F2_XCODPA
					
					dbSelectArea("ZZ1")
					dbSetOrder(1)                 
					If MsSeek( xFilial("ZZ1") +AvKey(cCodPA,"ZZ1_COD") )
						cEndereco += AllTrim(ZZ1->ZZ1_END) +"," +AllTrim(ZZ1->ZZ1_MUN) +"," +AllTrim(ZZ1->ZZ1_EST) 
						cLocal := AllTrim(ZZ1->ZZ1_DESCRI)
					EndIf
				Else
					cCodPA := M->ZG_ROTA
					dbSelectArea("SA1")
					dbSetOrder(1)                 
					If MsSeek( xFilial("SA1") +AvKey(M->ZG_CLIFOR,"A1_COD") +AvKey(M->ZG_LOJA,"A1_LOJA") )
						cEndereco += AllTrim(SA1->A1_END) +"," +AllTrim(SA1->A1_MUN) +"," +AllTrim(SA1->A1_EST)
						cLocal := AllTrim(SA1->A1_NREDUZ)
					EndIf							
				EndIf
			EndIf
		// inventario
		ElseIf AllTrim(M->ZG_FORM) == "21"
			cCodPA := M->ZG_ROTA
			dbSelectArea("ZZ1")
			dbSetOrder(1)                 
			If MsSeek( xFilial("ZZ1") +AvKey(cCodPA,"ZZ1_COD") )
				cEndereco += AllTrim(ZZ1->ZZ1_END) +"," +AllTrim(ZZ1->ZZ1_MUN) +"," +AllTrim(ZZ1->ZZ1_EST) 
				cLocal := AllTrim(ZZ1->ZZ1_DESCRI)
			EndIf
		EndIf			
	EndIf	
			
	aDados := { AllTrim(M->ZG_FORM),;
				AllTrim(M->ZG_DESCFRM),;
				AllTrim(M->ZG_CODTEC),;
				AllTrim(M->ZG_AGENTED),;
				AllTrim(M->ZG_PATRIM),;
				AllTrim(M->ZG_PATRIMD),;
				cTpAbast,;
				cTabPreco,;
				M->ZG_DATAINI,;
				M->ZG_HORAINI,;
				AllTrim(M->ZG_DESCCF),;
				cEndereco,;
				""/*M->ZG_CONTATO*/,;
				AllTrim(M->ZG_MSG),;
				M->ZG_ROTA,;
				cLocal,;
				M->ZG_DOC,;
				M->ZG_SERIE,;
				M->ZG_TPDOC,;
				M->ZG_CLIFOR,;
				M->ZG_LOJA,;
				aInfo,;
				cModelo,;
				cCodPA }
							

	cNumOS := U_MOBILE(aDados)
	MsgInfo("OS criada: " +cNumOS)
	Return cNumOS
EndIf


Return(cNumOS)


Static Function dlgLacre(cPatrimo)

Local aInfo := {}
Local cSisPg := ""
Local aAux := {}
Local aArea := GetArea()

dbSelectArea("SN1")
dbSetOrder(2)
If MsSeek( xFilial("SN1") +AvKey(cPatrimo,"N1_CHAPA") )
	cSisPg := AllTrim( SN1->N1_XSISPG )		
EndIf

If Empty(cSisPg)
	AADD( aInfo,{"cedlacreret","N"} )
	AADD( aInfo,{"cedlacrecol","N"} )
	AADD( aInfo,{"bananinha","N"} )
	
	AADD( aInfo,{"gleenviewret","N"} )
	AADD( aInfo,{"gleenviewcol","N"} )
	
	AADD( aInfo,{"log1","N"} )
	AADD( aInfo,{"log2","N"} )
	AADD( aInfo,{"log3","N"} )
	AADD( aInfo,{"log4","N"} )
	AADD( aInfo,{"log5","N"} )
Else

	If "CE=1" $ cSisPg
		AADD( aInfo,{"cedlacreret","S"} )
		AADD( aInfo,{"cedlacrecol","S"} )
		AADD( aInfo,{"bananinha","S"} )
	EndIf
	
	If "MC=1" $ cSisPg
		AADD( aInfo,{"gleenviewret","S"} )
		AADD( aInfo,{"gleenviewcol","S"} )
	EndIf
	
	If "SM=1" $ cSisPg
		AADD( aInfo,{"log1","S"} )
		AADD( aInfo,{"log2","S"} )
		AADD( aInfo,{"log3","S"} )
		AADD( aInfo,{"log4","S"} )
		AADD( aInfo,{"log5","S"} )
	EndIf
	
EndIf

RestArea(aArea)

Return aInfo


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRespostas  บAutor  ณJackson E. de Deus บ Data ณ  26/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMostra as respostas da OS caso tenha sido finalizada        บฑฑ
ฑฑบ          ณLEITURA/SANGRIA/CHAMADO - implementar outros formularios    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Respostas()
      
Local aArea := GetArea()
Local oWnd
Local oLayer:= FwLayer():New() 
Local aSize	:= MsAdvSize(Nil,.F.)
Local aRecSZN := {}
Local aInfo	:= {}
Local oLst
Local lNovoFrm := IIF( SZG->ZG_NOVOFRM,.T.,.F. )

For nI := 1 To Len(aSize)
	aSize[nI] := aSize[nI]*0.5
Next nI

If lNovoFrm
	If SZG->ZG_TPFORM == 2
		lLeitura := .T.
	ElseIf SZG->ZG_TPFORM == 3
		lSangria := .T.	
	ElseIf SZG->ZG_TPFORM == 4 .Or. SZG->ZG_TPFORM == 8
		lAbast := .T.	
	EndIf
EndIf

// SZN
cQuery := "SELECT R_E_C_N_O_ FROM " +RetSqlName("SZN") + " WHERE ZN_NUMOS = '"+AllTrim(SZG->ZG_NUMOS)+"' AND D_E_L_E_T_ = '' "

MPSysOpenQuery( cQuery , "TRBA" )                        

dbSelectArea("TRBA")
While !EOF()
	AADD( aRecSZN, TRBA->R_E_C_N_O_ )
	dbSkip()
End

TRBA->(dbCloseArea())

dbSelectArea("SZN")
For nI := 1 To Len( aRecSZN )
	dbGoTo(aRecSZN[nI])
	AADD( aInfo, { SZN->ZN_TIPINCL, SZN->ZN_PATRIMO, SZN->ZN_TIPMAQ, SZN->ZN_DATA, SZN->ZN_NUMATU, aRecSZN[nI] } )
Next nI

If Empty(aInfo)
	MsgInfo("Nใo hแ lan็amento de contadores.")
	Return
EndIf

oWnd := MSDialog():New( aSize[7],aSize[1],aSize[6],aSize[5],"Apontamentos",,,.F.,,CLR_WHITE,,,,.T.,,,.T. )		
	
	oLayer:Init(oWnd,.F.)
	
	oLayer:addCollumn('COLUNA1',100,.F.)
  	oLayer:addWindow("COLUNA1","WIN_1","Registros",100,.F.,.T.,{||} )
	oPnl := oLayer:GetWinPanel("COLUNA1","WIN_1")
	oPnl:FreeChildren()
			
	oLst := TCBrowse():New(0,0,0,0,,,,oPnl,,,,{ ||  },{ || TelaAlt(oLst:nAt,aInfo) },,,,,,,.F.,,.T.,,.F.,,,)
	oLst:SetArray(aInfo)

	oLst:AddColumn(TCColumn():New("Lan็amento"		,{|| aInfo[oLst:nAt][1] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,)) 
	oLst:AddColumn(TCColumn():New("Patrim๔nio"		,{|| aInfo[oLst:nAt][2] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,)) 
	oLst:AddColumn(TCColumn():New("Modelo"			,{|| aInfo[oLst:nAt][3] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,)) 
	oLst:AddColumn(TCColumn():New("Data"			,{|| aInfo[oLst:nAt][4] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	oLst:AddColumn(TCColumn():New("Numerador atual"	,{|| aInfo[oLst:nAt][5] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))	 
	
	//oLstDet:bRClicked := { |oObject,nX,nY| oMenu:Activate( nX, (nY-10), oObject ) }
	oLst:Align := CONTROL_ALIGN_ALLCLIENT
	
	oLst:nScrollType := 1
	
	// Menu popup
	MENU oMenu POPUP 
	MENUITEM "Invalidar Registro" ACTION ( STATICCALL( TTPROC56,ZeraReg,aInfo[oLst:nAt][6]) )
	ENDMENU                                                                           

	oLst:bRClicked := { |oObject,nX,nY| oMenu:Activate( nX, (nY-10), oObject ) }	 
			    
oWnd:Activate(,,,.T.) 

RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTPROC30  บAutor  ณMicrosiga           บ Data ณ  04/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TelaAlt(nPos,aInfo)

Local nRecno := aInfo[nPos][6]

dbSelectArea("SZN")
dbGoTo(nRecno)
If Recno() == nRecno
	STATICCALL( TTPROC93, Alterar )
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReMail  บAutor  ณJackson E. de Deus    บ Data ณ  15/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Enviar o email das leituras para o cliente                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ReMail()

Local aPergs		:= {}
Local aRet			:= {}
Local cCliente		:= ""
Local dData			:= stod("")
Local cAgente		:= ""


aAdd(aPergs ,{1,"Cliente"		,Space(6),"@!",".T.","SA1",".T.",60,.F.}) 
aAdd(aPergs ,{1,"Data"			,dDatabase,"99/99/99","","","",50,.F.})
aAdd(aPergs ,{1,"Atendente"		,Space(6),"@!","","AA1","",50,.F.})

If !ParamBox(aPergs ,"Reenviar e-mail leitura",@aRet)
	Return                                     
Else
	cCliente := aRet[1] 
	dData := aRet[2]
	cAgente := aRet[3]

	If !Empty(cCliente) .And. !Empty(dData) .And. !Empty(cAgente)	
		//cAgente := AllTrim( Posicione( "AA1",1,xFilial("AA1")+AvKey(cAgente,"AA1_CODTEC"),"AA1_PAGER" ) )
		If !Empty(cAgente)
			MsAguarde({ || U_TTPROC95(cAgente,dData,.T.,cCliente) },"Aguarde, reenviando e-mail...")
		//Else
		//	MsgAlert("Verifique o cadastro de atendente!" +CRLF +"Campo c๓digo de pager vazio")
		EndIf
	EndIf	
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReenvOS  บAutor  ณJackson E. de Deus   บ Data ณ  11/01/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Reenvia a notificacao push para o aparelho                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function	ReenvOS()

Local aArea := GetArea()                   
Local cRegID := ""
Local aaNotif := {}
Local cNPush := ""
Local cRetEnvio := ""

If Empty(SZG->ZG_FORM)
	Return
EndIf

If AllTrim(SZG->ZG_STATUS) == "FIOK"
	MsgAlert("Ordem de Servi็o jแ finalizada.")
	Return
EndIf

If AllTrim(SZG->ZG_STATUS) == "ACTE"
	MsgAlert("Ordem de Servi็o jแ recebida no aparelho do atendente.")
	Return
EndIf
                                        

If AllTrim(SZG->ZG_STATUS) $ "COPE|CTEC|CCLI"        
	MsgAlert("Ordem de Servi็o estแ cancelada.")
	Return
	/*If !MsgYesNo("A Ordem de Servi็o estแ cancelada. Deseja reabrir?")
		Return
	EndIf*/
EndIf                                        


dbSelectArea("SZS")
dbSetOrder(2)
If msSeek( xFilial("SZS") +AvKey( SZG->ZG_CODTEC,"ZG_NUMOS" ) )    
	cRegID := AllTrim(SZS->ZS_IDGCM)
EndIf  

RecLock("SZG",.F.)
SZG->ZG_STATUS := "OPEN"
SZG->ZG_STATUSD := "Criada"
MsUnLock()

// String JSON para Push          
aaNotif := Array(#)
aaNotif[#'tag'] := "os"
aaNotif[#'os'] := Val(SZG->ZG_NUMOS)
aaNotif[#'operacao'] := "novo"
cNPush := ToJson(aaNotif)
                         
If !Empty(cRegID) .And. !Empty(cNPush)
	cRetEnvio := U_GOOGLE01(cRegID,cNPush)
	If "200 OK" $ cRetEnvio
		MsgInfo("A ordem de servi็o foi enviada para o atendente!")
	Else
		Alert("Houve erro ao enviar a ordem de servi็o." +CRLF +cRetEnvio)
	EndIf
EndIf  

RestArea(aArea)	   

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfProcXml  บAutor  ณJackson E. de Deus  บ Data ณ  15/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fProcXml()

Local cXml := ""
Local cMsgErro := ""


If AllTrim(SZG->ZG_STATUS) <> "FIOK"
	MsgAlert("OS nใo finalizada! Aguarde a finaliza็ใo da OS.")
	Return
EndIf


If ( Empty(SZG->ZG_PROC) .And. !SZG->ZG_FORM $ "16#17" ) .OR. cUserName == "JDEUS"
	If !Empty(SZG->ZG_RESPOST)
		cXml := SZG->ZG_RESPOST
	Else
		If File( "\_mobile\mobile\data_receive\" +AllTrim(SZG->ZG_NUMOS) +".xml" )  
			cXml := MemoRead( "\_mobile\mobile\data_receive\" +AllTrim(SZG->ZG_NUMOS) +".xml" )
		Else
			MsgAlert("Xml de respostas invแlido. Utilize a rotina de obter apontamentos para atualiza็ใo.")
			Return		
		EndIf
	EndIf		
	CursorWait()
	MsAguarde({ || U_MXML003(SZG->ZG_NUMOS) },"Aguarde...","Processando respostas",.T.)
	CursorArrow()
Else
	If AllTrim(SZG->ZG_PROC) == "BR_VERDE"
		MsgInfo("Ordem de Servi็o jแ processada.") 	
	EndIf
EndIf



Return