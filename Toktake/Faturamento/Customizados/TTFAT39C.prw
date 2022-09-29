#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'  
#INCLUDE 'TBICONN.CH'
#include "topconn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT39C  บAutor  ณJackson E. de Deus  บ Data ณ  15/02/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Previsao de demanda			                              บฑฑ
ฑฑบ          ณ 													          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TTFAT39C()

Local oDlg1                             
Local nOpc	:=	0
Local aSize := MsAdvSize()
Private _aStruTrb1 := {}
Private _cArquivo	:= ""
Private _cIndice	:= ""
Private oList

If cEmpAnt <> "01"
	Return
EndIf

CursorWait()

dadosIni()
	
CursorArrow()

dbSelectArea("TRB1")
dbGoTop()
oDlg1 := MSDialog():New( aSize[7],aSize[1],aSize[6],aSize[5],"Previsใo de demanda",,,.F.,,,,,,.T.,,,.T. )
    
    oList := TCBrowse():New(0,0,0,0,,,,oDlg1,,,,,{ || IIF(Empty(TRB1->PEDIDO),Produtos(),MsgInfo("Jแ existe pedido gerado!"))  },,,,,,,.F.,'TRB1',.T.,,.F.,,.T.,.F.)
       
	oList:AddColumn(TCColumn():New(""			,{|| TRB1->STATUS  },"@BMP",,,,,.T.,.F.,,,,.F.,))
	oList:AddColumn(TCColumn():New("PA"			,{|| TRB1->PA },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))	                                                                                                          	
	oList:AddColumn(TCColumn():New("Entrega"	,{|| TRB1->DTENT },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))	                                                                                                          	
	oList:AddColumn(TCColumn():New("Estoque"	,{|| TRB1->ESTOQUE },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
    oList:AddColumn(TCColumn():New("Pedido"		,{|| TRB1->PEDIDO },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))         	

	oList:Align := CONTROL_ALIGN_ALLCLIENT
      	
	EnchoiceBar( oDlg1,{ || oDlg1:End() },{ || oDlg1:End(nOpcClick := 0)},,/*@aButtons*/,,,.F.,.F.,.F.,.F.,.F. )
	
oDlg1:Activate(,,,.T.)

TRB1->( dbCloseArea() )

If File( "\system\" +_cArquivo +"." +OrdbagExt() )
	MsErase( "\system\" +_cArquivo +"." +OrdbagExt() )
EndIf


Return 
 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProdutos  บAutor  ณJackson E. de Deus  บ Data ณ  15/02/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Produtos da Pa em atendimento                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Produtos()

Local oDlg2    
Local nOpc			:= 0
Local aScreen		:= getScreenRes() 
Local aSize			:= MsAdvSize()
Local oLayer		:= FwLayer():New()
Local aButtons		:= {}
Local lEnd			:= .F.
Private _aAlter		:= {"ZO_CODPRO","ZO_QTDPED"}    
Private _cTpEst		:= ""
Private _cArmazem	:= TRB1->PA
Private _cArmA		:= "A" +SubStr(_cArmazem,2)
Private oList2                   
Private aHeader		:= {}
Private aCols		:= {}
Private _aRecnos	:= {}
Private _aCampos	:= { "ZO_CODPRO","B1_DESC","ZO_ESTOQUE","ZO_QINV","ZO_QAVAR","ZO_QDIFF","ZO_CMD","ZO_CP","ZO_QCALC","ZO_QTDPED" }
Private _aSecao		:= { "005","007","008", "010", "014", "015" ,"016", "017", "036" } 
Private _dEntAnt	:= dDatabase
Private _dInvent	:= stod("")
Private _dEntAtu	:= dDatabase
Private _dEntProx	:= dDatabase
Private _lInvEnv	:= .F.
Private _lInvOk		:= .F.
Private _cNumOS		:= ""
Private _cStatOS	:= ""
Private _lTemPed	:= .F.
Private _lRota		:= IIF( SubStr(_cArmazem,1,1)=="R",.T.,.F.)
Private _cAtend		:= ""
Private _aMaqRel2	:= {}
Private _aMaquinas	:= {}
Private _aProdAlter := {}
Private _cTpRota	:= IIF( AllTrim(Posicione("ZZ1",1,xFilial("ZZ1")+AvKey(_cArmazem,"ZZ1_COD"),"ZZ1_TIPO" ))=="1","CAFE","SNACKS" )                         
        
// verifica se esta no prazo de entrega da agenda
fDados()

// verifica as maquinas
fMaqX()

If Empty( _aMaquinas )
	If !_lRota
		MsgInfo("Nใo hแ mแquinas instaladas nesse local.")
	Else
		MsgInfo("Nใo hแ programa็ใo de mแquinas para essa data. Verifique o plano de trabalho.")
	EndIf
EndIf

AADD( aButtons, {"HISTORIC", { || oProcess := MsNewProcess():New( { |lEnd| ProcDem(@lEnd) }, "Calculando demanda..", "Aguarde..", .T. ),oProcess:Activate() } , "Proc Invent.", "Processar" , {|| .T.} } )
AADD( aButtons, {"HISTORIC", { || ViewMaq() }, "Mแquinas", "Mแquinas" , {|| .T.} } )
AADD( aButtons, {"HISTORIC", { || LJMsgRun("Gerando o pedido de venda","Aguarde...",{ || GerarPV() }) }, "Pedido", "Pedido" , {|| .T.} } )
AADD( aButtons, {"HISTORIC", { || LJMsgRun("Gerando o pedido de descarte","Aguarde...",{ || PVDesc() }) }, "Pedido", "Pedido descarte" , {|| .T.} } )
AADD( aButtons, {"HISTORIC", { || LJMsgRun("Gerando o desconto","Aguarde...",{ || DescDif() }) }, "Desconto", "Desconto" , {|| .T.} } )
AADD( aButtons, {"HISTORIC", { || LJMsgRun("Gerando o relatorio","Aguarde...",{ || CursorWait(),U_TTRLPICK( _aMaquinas,_dEntAtu ),CursorArrow() }) }, "PickList", "PickList" , {|| .T.} } )
AADD( aButtons, {"HISTORIC", { || LJMsgRun("Gerando o relatorio","Aguarde...",{ || CursorWait(),fParCalc(),CursorArrow() }) }, "Consumo", "Consumo" , {|| .T.} } )


	
LoadHead()

oDlg2 := MSDialog():New( aSize[7],aSize[1],aSize[6],aSize[5],"Pedido de Abastecimento",,,.F.,,,,,,.T.,,,.T. )

	oDlg2:lEscClose := .F.
	oDlg2:lMaximized := .T. 
	
	oLayer:Init(oDlg2,.F.)
	oLayer:addLine("LINHA1",95,.F.)

	oLayer:addCollumn('COLUNA1_1',100,.F.,"LINHA1") 
	If aScreen[2] <= 800
		oLayer:addWindow("COLUNA1_1","WIN_1","Informa็๕es da PA",50,.F.,.T.,{||},"LINHA1")
  		oLayer:addWindow("COLUNA1_1","WIN_2","Produtos",50,.F.,.T.,{||},"LINHA1")
	Else
		oLayer:addWindow("COLUNA1_1","WIN_1","Informa็๕es da PA",30,.F.,.T.,{||},"LINHA1")
  		oLayer:addWindow("COLUNA1_1","WIN_2","Produtos",70,.F.,.T.,{||},"LINHA1")
	EndIf
                                                     
	oGrp1 := oLayer:GetWinPanel("COLUNA1_1","WIN_1","LINHA1")
	oGrp2 := oLayer:GetWinPanel("COLUNA1_1","WIN_2","LINHA1")
                                                  
	// cabecalho
	oSay1	:= TSay():New( 005,005,{|| "PA" },oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,008)  
	oS1		:= TSay():New( 005,090,{|| _cArmazem + " - " +AllTrim(Posicione("ZZ1",1,xFilial("ZZ1")+AvKey(TRB1->PA,"ZZ1_COD"),"ZZ1_DESCRI")) },oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,400,008)
	
	oSay2	:= TSay():New( 015,005,{|| "Endere็o de Entrega" },oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008) 
	oS2		:= TSay():New( 015,090,{|| Posicione("ZZ1",1,xFilial("ZZ1")+AvKey(TRB1->PA,"ZZ1_COD"),"ZZ1_END")},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,400,008)
	
	oSay3	:= TSay():New( 025,005,{|| "Bairro" },oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
	oS3		:= TSay():New( 025,090,{|| Posicione("ZZ1",1,xFilial("ZZ1")+AvKey(TRB1->PA,"ZZ1_COD"),"ZZ1_BAIRRO") },oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,400,008)
	
	oSay4	:= TSay():New( 035,005,{|| "Tipo de Estoque" },oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
	oS4		:= TSay():New( 035,090,{|| _cTpEst },oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,400,008)
	
	oSay5	:= TSay():New( 045,005,{|| "Data da entrega anterior" },oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,008)
	oS5		:= TSay():New( 045,090,{|| dtoc(_dEntAnt) },oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,400,008)
	
	oSay6	:= TSay():New( 055,005,{|| "Data do Inventแrio" },oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
	oS6		:= TSay():New( 055,090,{|| dtoc(_dInvent) },oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,400,008)
	
	oSay7	:= TSay():New( 065,005,{|| "Data da Entrega" },oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
	oS7		:= TSay():New( 065,090,{|| dtoc(_dEntAtu) },oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,400,008)
	
	oSay8	:= TSay():New( 075,005,{|| "Data da pr๓xima Entrega" },oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,008)                                                                                                                   
	oS8		:= TSay():New( 075,090,{|| dtoc(_dEntProx) },oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,400,008)
    
    oSay9	:= TSay():New( 085,005,{|| "Ordem de Servi็o gerada?" },oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)  
	oS9		:= TSay():New( 085,090,{|| IIF(_lInvEnv,_cNumOS + " - " +_cStatOS,"") },oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,150,008)
	                       
	// getdados
	oList2 := MsNewGetDados():New(0,0,0,0,GD_INSERT+GD_UPDATE+GD_DELETE,"AllwaysTrue()","AllwaysTrue()","",_aAlter,0,999,"STATICCALL( TTFAT39C, VldCpo )","","AllwaysTrue()",oGrp2,aHeader,aCols, { || acols := aclone(oList2:acols) })
	//oList2:oBrowse:bRClicked := { |oObject,nX,nY| oMenu:Activate( nX, (nY-10), oObject ) }
	oList2:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

	EnchoiceBar(oDlg2,{ || oDlg2:End(nOpc:=1)  },{ || oDlg2:End(nOpc:=0) },,@aButtons,,,.F.,.F.,.F.,.T.,.F. )
	
	oDlg2:bStart := { || LJMsgRun("Carregando produtos..","Aguarde...",{ || LoadProd() }) }
		               
oDlg2:Activate(,,,.T.)

If nOpc == 1
	Gravar(oList2:Acols)
EndIf


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldCpo  บAutor  ณJackson E. de Deus    บ Data ณ  15/02/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida campo digitado                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldCpo()

Local lRet := .T.
Local nPosProd := Ascan( aHeader, { |x| AllTrim(x[2]) == "ZO_CODPRO" } )
Local nPosEst := Ascan( aHeader, { |x| AllTrim(x[2]) == "ZO_ESTOQUE" } )
Local nPosDesc := Ascan( aHeader, { |x| AllTrim(x[2]) == "B1_DESC" } )
Local nPosQCalc := Ascan( aHeader, { |x| AllTrim(x[2]) == "ZO_QCALC" } )
Local nLinha := 0
Local lOk := .T.


If __readvar == "M->ZO_CODPRO"
	// somente aceita se for nova linha e nao for repetido
	For nLinha := 1 To Len(aCols)
		// se ja tem inventario - nao deixa adicionar produto
		If _lInvEnv                                          
			MsgAlert("Jแ foi gerada a OS de inventแrio, nใo ้ possํvel adicionar novos produtos!")
			Return .F.
		Else
			nPos := Ascan( aCols, { |x| AllTrim(x[1]) == AllTrim(M->ZO_CODPRO) }  )
			If nPos > 0 .And. nPos <> nLinha
				MsgAlert("Nใo ้ permitido produto repetido!")
				Return .F.
			EndIf
		EndIf
	Next nI
	       
	// verifica se eh produto valido
	dbSelectArea("SB1")
	dbSetOrder(1)
	If MSSeek( xFilial("SB1") +AvKey(M->ZO_CODPRO,"B1_COD") )
		If !Empty(SB1->B1_XSECAO) 
			For nI := 1 To Len(_aSecao)
				If AllTrim(SB1->B1_XSECAO) == _aSecao[nI]
					lOk := .T.
					Exit
				EndIf
			Next nI
			If !lOk
				MsgAlert("Linha de produto nใo permitida! -> "+AllTrim(SB1->B1_XSECAOT))
				Return .F.
			EndIf
		EndIf                                  
		
		aCols[oList2:nAt][nPosDesc] := SB1->B1_DESC
			
		// atualiza o saldo atual da PA
		dbSelectArea("SB2")
		dbSetOrder(1)
		If MsSeek( xFilial("SB2") +AvKey(M->ZO_CODPRO,"B2_COD")+AvKey(_cArmA,"B2_LOCAL")  )
			aCols[oList2:nAt][nPosEst] := SB2->B2_QATU-SB2->B2_QEMPSA-SB2->B2_RESERVA
		Else
			aCols[oList2:nAt][nPosEst] := 0
		EndIf			
	EndIf
// qtd	
ElseIf __readvar == "M->ZO_QTDPED"
	If M->ZO_QTDPED > 0      
		dbSelectArea("SB1")
		dbSetOrder(1)
		If MSSeek( xFilial("SB1") +AvKey(aCols[oList2:nAt][nPosProd],"B1_COD") )
			If AllTrim(SB1->B1_SEGUM) == "CX"
				If SB1->B1_CONV > 0
					If (M->ZO_QTDPED * SB1->B1_CONV) % SB1->B1_CONV <> 0
						MsgInfo("Quantidade nใo compatํvel com a quantidade da caixa!")
					EndIf
				EndIf
			EndIf
		EndIf              
	EndIf
EndIf		

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLoadHead  บAutor  ณJackson E. de Deus  บ Data ณ  15/02/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega o aHeader do grid                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function LoadHead()

Local nI := 0
Local cCampos := ""
      
dbSelectArea("SX3")
dbSetOrder(2)            
For nI := 1 To Len(_aCampos)
	If _aCampos[nI] == "ZO_CODPROD"
		If dbSeek(_aCampos[nI])
			AADD(aHeader,{Trim(X3Titulo()), SX3->X3_CAMPO, SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL,;
					 "", SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_F3, SX3->X3_CONTEXT, SX3->X3_CBOX })
		EndIf
	Else
		If dbSeek(_aCampos[nI])
			AADD(aHeader,{Trim(X3Titulo()), SX3->X3_CAMPO, SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL,;
					 "", SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_F3, SX3->X3_CONTEXT, SX3->X3_CBOX })
		EndIf
	EndIf
Next nI

Return
 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfDados  บAutor  ณJackson E. de Deus    บ Data ณ  16/02/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica datas                                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fDados()
           
Local cQuery	:= ""
Local nPosIni	:= 8
Local cMes		:= SubStr(dtos(dDatabase),1,6)
Local cMes2		:= SubStr(dtos(LastDay(dDatabase)+1),1,6)
Local cMensal	:= ""
Local dDia
Local nP		:= 0                           
Local lOk		:= .F.
Local dDtIni
Local dDtFim
Local dAux		:= stod("")

// data entrega atual - D+1 -> ONTEM INVENTARIO - HOJE PROCESSAMENTO - AMANHA ENTREGA :)
_dEntAtu := dDatabase+1	// D+1 -> AMANHA

If Dow(_dEntAtu) == 7
	_dEntAtu += 2
ElseIf Dow(_dEntAtu) == 1
	_dEntAtu += 1
EndIf

If !_lRota
	_dInvent := dDatabase-1	// D-1 -> ONTEM
EndIf

// entrega anterior
cQuery := "SELECT TOP 1 * FROM " +RetSqlName("SF2")
cQuery += " WHERE F2_FILIAL = '"+xFilial("SF2")+"' AND F2_XCODPA = '"+_cArmazem+"' AND F2_XDTENTR < '"+DTOS(dDatabase)+"'  " 
cQuery += " AND D_E_L_E_T_ = '' "
cQuery += " ORDER BY F2_XDTENTR DESC "

If Select("TRB") > 0
	TRB->(dbCloseArea("TRB"))
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

dbSelectArea("TRB")                  
If !EOF()
	_dEntAnt := STOD(TRB->F2_XDTENTR)
EndIf
TRB->(dbCloseArea("TRB"))


// proxima entrega
If !_lRota
	// ALTERAR AQUI PARA PEGAR A PROXIMA ENTREGA COM BASE NO CADASTRO DE PAS - ZZ1
	cQuery := "SELECT * FROM ZZ1010 WHERE ZZ1_FILIAL = '"+xFilial("ZZ1")+"' AND ZZ1_XATEND <> '' AND ZZ1_XAGEND <> '' AND ZZ1_COD = '"+_cArmazem+"' "
	cQuery += "AND D_E_L_E_T_ = '' "
	cQuery += "ORDER BY ZZ1_COD"
	
	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf
	
	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
	
	dbSelectARea("TRB")
	nDiaSem := Val(TRB->ZZ1_XAGEND)
	
	
	dAux := dDatabase
	While .T.
		If dAux > dDatabase
			If Dow(dAux) == nDiaSem
				// antes de sexta
				If Dow(dAux) < 6
					_dEntProx := dAux+1
				// na sexta
				ElseIf Dow(dAux) == 6
					_dEntProx := dAux+4
				// no sabado
				ElseIF Dow(dAux) == 7
					_dEntProx := dAux+3
				// no domingo
				ElseIf Dow(dAux) == 1
					_dEntProx := dAux+2
				EndIf
				Exit
			EndIf
		EndIf
		dAux++
	End      
Else
	If _cTpRota == "SNACKS"         
		_dEntProx := _dEntAtu+1
		If Dow(_dEntProx) == 7
			_dEntProx += 2
		ElseIf Dow(_dEntProx) == 1
			_dEntProx += 1
		EndIf
	ElseIf _cTpRota == "CAFE"
		_dEntProx := _dEntAtu+7
	EndIf
EndIf


/*
cQuery := "SELECT ZE_MENSAL FROM " +RetSqlName("SZE") + " SZE "
cQuery += " WHERE "
cQuery += " ZE_FILIAL = '"+xFilial("SZE")+"' AND ZE_TIPOPLA IN ( '72','73','82','83' ) "
cQuery += " AND ZE_ROTA = '"+_cArmazem+"' AND D_E_L_E_T_ = '' "
cQuery += " AND ( ZE_MENSAL LIKE '%"+cMes+"%' OR ZE_MENSAL LIKE '%"+cMes2+"%' ) "
cQuery += " ORDER BY ZE_MENSAL "

If Select("TRB") > 0
	TRB->(dbCloseArea("TRB"))
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

dbSelectArea("TRB")                  
While !EOF()
	cMensal := AllTrim(TRB->ZE_MENSAL)
	If SubsTr(cMensal,1,4) == cvaltochar(year(dDatabase)) .And. VaL(SubsTr(cMensal,5,2)) == MontH(dDatabase)
		dDtIni := dDatabase
		dDtFim := LastDay(dDatabase)
	Else
		dDtIni := FirstDay(LastDay(dDatabase)+1)
		dDtFim := LastDay(LastDay(dDatabase)+1)
	EndIf
	
	For dDia := dDtIni To dDtFim
		nP := Day(dDia)	
		If SubStr(cMensal,nPosIni+nP,1) $ "1#F#T"
			_dEntProx := dDia+2
			lOk := .T.
			Exit
		EndIf
	Next dDia
	If lOk
		Exit
	EndIf
	TRB->(dbSkip())
End
TRB->(dbCloseArea("TRB"))
*/

// inventario gerado? -> somente nas PAs
If !_lRota
	cQuery := "SELECT ZG_NUMOS, ZG_STATUS,ZG_STATUSD,ZG_CODTEC FROM " +RetSqlName("SZG")
	cQuery += " WHERE ZG_ROTA = '"+_cArmA+"' AND ZG_DATAINI = '"+DTOS(dDatabase-1)+"' "
	cQuery += " AND ( ZG_TPFORM = '21' OR ZG_FORM = '21' ) AND D_E_L_E_T_ = '' AND ZG_STATUS NOT IN ('COPE','CTEC','CCLI') "
	
	If Select("TRB") > 0
		TRB->(dbCloseArea("TRB"))
	EndIf
	
	DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
	
	dbSelectArea("TRB")                  
	If !EOF()
		_lInvEnv := .T.
		_cNumOS := AllTrim(TRB->ZG_NUMOS)
		_cStatOS := AllTrim(TRB->ZG_STATUSD)
		If AllTrim(TRB->ZG_STATUS) == "FIOK"
			_lInvOk := .T.
			_cAtend := TRB->ZG_CODTEC
		EndIf 
	EndIf
	TRB->(dbCloseArea("TRB"))
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ LoadProd  บAutor  ณJackson E. de Deus บ Data ณ  15/02/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carrega os produtos da PA                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function LoadProd()

Local cQuery	:= ""
Local nQAtu		:= 0
Local nQtdInv	:= 0
Local nDiff		:= 0
Local nQtdAvar	:= 0
Local nCMD		:= 0
Local nConsP	:= 0
Local nQtdCalc	:= 0
Local nQtdEnv	:= 0
Local cProd		:= ""
Local cDesc		:= ""
Local aItens	:= {}
Local nI

CargaZO()

If Empty(_aRecnos)
	CargaIni()
	CargaZO()
EndIf

If !Empty(_aRecnos)
	For nI := 1 To Len(_aRecnos)				
		dbSelectArea("SZO")
		dbGoTo(_aRecnos[nI])
		
		nQAtu := SZO->ZO_ESTOQUE
		//If AllTrim(SZO->ZO_FINAL) <> "S" 
			dbSelectArea("SB2")
			dbSetOrder(1)
			If MSSeek( xFilial("SB2") +AvKey(SZO->ZO_CODPRO,"B2_COD") +AvKey(_cArmA,"B2_LOCAL") )
				nQAtu := (SB2->B2_QATU-SB2->B2_QEMPSA-SB2->B2_RESERVA)
			EndIf
		//EndIf
		AADD( aItens, { SZO->ZO_CODPRO,;
						Posicione("SB1",1,xFilial("SB1")+AvKey(SZO->ZO_CODPRO,"B1_COD"),"B1_DESC" ),;
						nQAtu,;
						SZO->ZO_QINV,;
						SZO->ZO_QAVAR,;
						SZO->ZO_QDIFF,;
						SZO->ZO_CMD,;
						SZO->ZO_CP,;
						SZO->ZO_QCALC,;
						SZO->ZO_QTDPED } )
						
		If !Empty(SZO->ZO_PEDIDO)
			_lTemPed := .T.
		EndIf
		
		// grava a OS caso ainda nao esteja
		If Empty(SZO->ZO_OSINV) .And. !Empty(_cNumOS)
			RecLock("SZO",.F.)
			SZO->ZO_OSINV := _cNumOS
			MsUnLock()
		EndIf
	Next nI
EndIf	 

For nI := 1 To Len(aItens)
	cProd		:= aItens[nI][1]
	cDesc		:= aItens[nI][2]
	nQAtu		:= aItens[nI][3]
	nQtdInv		:= aItens[nI][4]
	nQtdAvar	:= aItens[nI][5]
	nDiff		:= aItens[nI][6]
	nCMD		:= aItens[nI][7]
	nConsP		:= aItens[nI][8]
	nQtdCalc	:= aItens[nI][9]
	nQtdEnv		:= aItens[nI][10]

	AAdd(aCols, Array(Len(aHeader)+1))
 	nLin := Len(aCols)
	
	aCols[nLin][1] := cProd
	aCols[nLin][2] := cDesc
	aCols[nLin][3] := nQAtu				// qtd estoque
	aCols[nLin][4] := nQtdInv			// qtd inventario - contado
	aCols[nLin][5] := nQtdAvar			// qtd inventario - avariado
	acols[nLin][6] := nDiff				// diferenca entre inventario e estoque
	aCols[nLin][7] := nCMD				// consumo medio diario
	aCols[nLin][8] := nConsP			// consumo projetado
	aCols[nLin][9] := nQtdCalc			// qtd a enviar
	aCols[nLin][10] := nQtdEnv			// qtd a enviar - arredondado conforme segunda unidade de medida ?
		
	aCols[nLin][Len(aHeader)+1] := .F.		
Next nI


oList2:Acols := aClone(aCols)
oList2:Refresh(.T.)
oList2:GoTop()

// se ja tem pedido - nao deixa alterar o grid
If _lTemPed
	oList2:Disable()
EndIf	    

Return                                                             


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCargaZO  บAutor  ณJackson E. de Deus   บ Data ณ  18/02/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carga da tabela SZO                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CargaZO()

Local cQuery	:= ""
      
// consulta direto na SZO
cQuery := "SELECT SZO.R_E_C_N_O_ ZOREC FROM " +RetSqlName("SZO") +" SZO "
cQuery += " INNER JOIN " +RetSqlName("SB1") +" SB1 ON B1_COD = ZO_CODPRO AND SB1.D_E_L_E_T_ = '' "
cQuery += " WHERE ZO_CODPA = '"+_cArmazem+"' AND ZO_DATEMIS = '"+DTOS(dDatabase)+"' AND SZO.D_E_L_E_T_ = '' "
cQuery += " ORDER BY B1_XSECAO, B1_XFAMILI, B1_GRUPO"

// SECAO LINHA/familia CATEGORIA
// B1_XSECAO,B1_XSECAOT,B1_XFAMILI, B1_XFAMLIT,B1_GRUPO, B1_XGRUPOT,*  
// 005 007 008 010 014 015 016 017 

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf      

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
dbSelectArea("TRB") 
While !EOF()
	AADD( _aRecnos, TRB->ZOREC )
	dbSkip()
End
TRB->(dbCloseArea())

Return
      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCargaIni  บAutor  ณJackson E. de Deus  บ Data ณ  18/02/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Carga inicial pela SB2                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CargaIni()

Local cQuery	:= ""
Local aItens	:= {}
Local aSZ0		:= {}
Local aAux		:= {}
Local aSec		:= {}

If _lRota
	If _cTpRota == "CAFE"
		aSec := { "005","007","036" }
	ElseIf _cTpRota == "SNACKS"
		aSec := { "005","007", "008", "010", "014", "015" ,"016", "017" } 
	EndIf
Else
	aSec := aclone(_aSecao)	
EndIf


cQuery := "SELECT B2_COD, B1_DESC,( B2_QATU-B2_QEMPSA-B2_RESERVA ) QTDATU FROM " +RetSqlName("SB2") +" SB2 "
cQuery += " INNER JOIN " + RetSqlName("SB1") +" SB1 ON B1_COD = B2_COD AND SB1.D_E_L_E_T_ = '' AND B1_XMIXENT = '1' "
cQuery += " WHERE B2_FILIAL = '"+xFilial("SB2")+"' AND B2_LOCAL = '"+IIF(!_lRota,_cArmA,_cArmazem)+"' AND SB2.D_E_L_E_T_ = '' " 

cQuery += " AND B1_XSECAO IN ( "	
For nI := 1 To Len(aSec)
	cQuery += "'" +aSec[nI] + "'"
	If nI <> Len(aSec)
		cQuery += ","
	EndIf
Next nI
cQuery += " ) "
	
cQuery += " ORDER BY B1_XSECAO, B1_XFAMILI, B1_GRUPO"

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )
dbSelectArea("TRB") 
While !EOF()  
	AADD( aItens, { TRB->B2_COD,;
					TRB->B1_DESC,;
					TRB->QTDATU,;
					0,;
					0,;
					0,;
					0,;
					0,;
					0,;
					0 } )	

	TRB->(dbSkip())
End
TRB->(dbCloseArea())  	        


// no caso da rota tratar aqui para considerar somente os produtos que estao sendo utilizados - SZ0 - 30 DIAS
If _lRota .And. _cTpRota == "SNACKS"
	cQuery := "SELECT Z0_PRODUTO,COUNT(*) FROM " +RetSqlName("SZ0")
	cQuery += " WHERE Z0_NUMOS IN (
	cQuery += "	SELECT ZG_NUMOS FROM " +RetSqlName("SZG")
	cQuery += 	" WHERE ZG_ROTA = '"+_cArmazem+"' "
	cQuery += 	" AND ZG_STATUS = 'FIOK' "
	cQuery += " ) "
	cQuery += " AND Z0_DATA BETWEEN '"+dtos(_dEntAtu-30)+"' AND '"+dtos(_dEntAtu-1)+"' "
	cQuery += " AND ( Z0_SALDO > 0 OR Z0_ABAST > 0 OR Z0_RETIR > 0 OR Z0_AVARIA > 0 OR Z0_SLDMOV > 0  ) "
	cQuery += " GROUP BY Z0_PRODUTO " 
		
	MPSysOpenQuery( cQuery , "TRB" )  
	dbSelectArea("TRB")
	While !EOF()		
		AADD( aSZ0, TRB->Z0_PRODUTO )		
		dbSkip()
	End
	
	TRB->(dbCloseArea())
	
	For nI := 1 To Len(aItens)
		If AScan( aSZ0, { |x| AllTrim(x[1]) == AllTrim(aItens[nI][1]) } ) > 0
			AADD( aAux, aItens[nI] )
		EndIf
	Next nI
	
	If !Empty(aAux)
		aItens := Aclone(aAux)
	EndIf	
EndIf

// tratar aqui para pegar tambem os produtos alternativos - somente o que for insumo de bebida quente
dbSelectArea("SB1")
dbSetOrder(1)
For nI := 1 To Len(aItens)
	If MsSeek( xFilial("SB1") +AvKey(aItens[nI][1],"B1_COD") )                                      
		If AllTrim(SB1->B1_XSECAO) $ "005#007#036"	                       
			If !Empty( SB1->B1_ALTER )
				If AScan( aItens, { |x| AllTrim(x[1]) == AllTrim(SB1->B1_ALTER)  } ) == 0
					If MsSeek( xFilial("SB1") +AvKey(SB1->B1_ALTER,"B1_COD")  )
						AADD( aItens, { SB1->B1_COD,;
										SB1->B1_DESC,;
										0,;
										0,;
										0,;
										0,;
										0,;
										0,;
										0,;
										0 } )
					EndIf
				EndIf
			EndIf
		EndIf 
	EndIf
Next nI


Gravar(aItens)


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณdadosIni  บAutor  ณJackson E. de Deus  บ Data ณ  15/02/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Buscando PAs para compor a agenda		                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function dadosIni()

Local cQuery
Local nPosDia := 8 +Day(dDatabase-1)		// D-1 -> verifica PA com inventario do dia anterior
Local cMes := SubStr(dtos(dDatabase),1,6)
Local cNumPed := ""
Local nDiaSem := 0
Local dAux := stod("")

// se for primeiro dia do mes - considerar mes anterior
If Day(dDatabase) == 1
	cMes := SubStr(dtos(firstday(dDatabase)-1),1,6)	
EndIf


_aStruTrb1 := {}

// trb1
AADD( _aStruTrb1,{"STATUS"		,"C"	,12,0})
AADD( _aStruTrb1,{"DT"			,"D"	,8,0})
AADD( _aStruTrb1,{"DTENT"		,"D"	,8,0})
AADD( _aStruTrb1,{"PA"			,"C"	,TamSx3("B2_LOCAL")[1],0})
AADD( _aStruTrb1,{"PROT"		,"C"	,30,0})
AADD( _aStruTrb1,{"ESTOQUE"		,"C"	,30,0})
AADD( _aStruTrb1,{"ARM"			,"C"	,TamSx3("ZZ1_DESCRI")[1],0})
AADD( _aStruTrb1,{"ABAST"		,"C"	,TamSx3("AA1_NOMTEC")[1],0})
AADD( _aStruTrb1,{"OBS"			,"C"	,40,0})
AADD( _aStruTrb1,{"PEDIDO"		,"C"	,TamSx3("C5_NUM")[1],0})


If File("\system\" +_cArquivo +"." +OrdbagExt())
	MsErase("\system\" +_cArquivo +"." +OrdbagExt())
EndIf

If Select("TRB1") > 0
	TRB1->(dbCloseArea())
EndIf

_cArquivo := CriaTrab(_aStruTrb1,.T.)
_cIndice  := CriaTrab(Nil,.F.)
	
dbUseArea(.T.,,_cArquivo,"TRB1",.F.,.F.)
IndRegua("TRB1",_cIndice,"PA")

/*
cQuery := "SELECT ZE_ROTA,ZZ1_COD,ZZ1_DESCRI,ZZ1_XNOMAT,ZZ1_TELEFO,ZZ1_END,ZZ1_BAIRRO,ZZ1_ITCONT,ZZ1_XAGEND FROM " +RetSqlName("SZE") + " SZE "
cQuery += " INNER JOIN " +RetSqlName("ZZ1") + " ZZ1 ON "
cQuery += " ZZ1_FILIAL = ZE_FILIAL AND ZZ1_COD = ZE_ROTA AND ZZ1.D_E_L_E_T_ = '' "
cQuery += " WHERE "
cQuery += " ZE_FILIAL = '"+xFilial("SZE")+"' AND ZE_TIPOPLA IN ( '72','73','82','83' ) "
cQuery += " AND ZE_MENSAL LIKE '%"+cMes+"%' AND SUBSTRING(ZE_MENSAL,"+CVALTOCHAR(nPosDia)+",1) IN ('1','F','T') "
cQuery += " AND ZZ1_COD BETWEEN 'P00000' AND 'PZZZZZZ' "
cQuery += " ORDER BY ZE_ROTA"
*/

cQuery := "SELECT * FROM ZZ1010 WHERE ZZ1_FILIAL = '"+xFilial("ZZ1")+"' AND ZZ1_XATEND <> '' AND ZZ1_XAGEND <> '' AND ZZ1_COD BETWEEN 'P00000' AND 'PZZZZZ' "
cQuery += "AND D_E_L_E_T_ = '' "
cQuery += "ORDER BY ZZ1_COD"


If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB") 
While !EOF()

	nDiaSem := Val(TRB->ZZ1_XAGEND)
	dAux := dDatabase
	  
	// seg - pegar inventario da sexta
	If Dow(dDatabase) == 2
		dAux -= 3
	// dom - pegar inventario da sexta
	ElseIf Dow(dDatabase) == 1
		dAux -= 2
	Else
		dAux -= 1
	EndIf
	
	
	If Dow(dAux) == nDiaSem	//If Dow(dDatabase)-1 == nDiaSem
		// verifica se ja existe pedido para essa PA na data - se existe - desconsiderar
		cNumPEd := fPedPA(TRB->ZZ1_COD,dDatabase)	// pa emissao
		If cUserName == "JDEUS" .And. getEnvServer() == "CONP"
			cNumPed := ""                                        
		EndIf
		
		dbSelectArea("TRB1")
		RecLock("TRB1",.T.)
		TRB1->STATUS	:= IIF( Empty(cNumPed),"BR_BRANCO","BR_VERDE" ) 
		TRB1->DT		:= dDatabase
		TRB1->DTENT		:= dAux	//dDatabase+1
		TRB1->PA		:= TRB->ZZ1_COD
		TRB1->ESTOQUE	:= TRB->ZZ1_DESCRI
		TRB1->ARM		:= ""
		TRB1->ABAST		:= TRB->ZZ1_XNOMAT
		TRB1->OBS		:= TRB->ZZ1_TELEFO
		TRB1->PEDIDO	:= cNumPed
		TRB1->(MsUnLock())
	EndIf

	dbSelectArea("TRB") 
	TRB->( dbSkip() )
EndDo

TRB->(dbCloseArea())

// rotas - nao precisam de plano - inventario
cQuery := "SELECT ZZ1_COD,ZZ1_DESCRI,ZZ1_XNOMAT,ZZ1_TELEFO,ZZ1_END,ZZ1_BAIRRO,ZZ1_ITCONT,ZZ1_XAGEND "
cQuery += " FROM "+RetSQLName("ZZ1")+" ZZ1 "
cQuery += " WHERE "
cQuery += " ZZ1_FILIAL = '"+xFilial("ZZ1")+"' AND D_E_L_E_T_ = '' AND ZZ1_COD BETWEEN 'R00000' AND 'RZZZZZZ' AND ZZ1_TIPO IN ('1','2') "
cQuery += " ORDER BY ZZ1_COD"

If Select("TRB") > 0
	TRB->(dbCloseArea())
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )

DbSelectArea("TRB") 
While !EOF()
                                                             
	cNumPed := ""
	// verifica se ja existe pedido para essa Rota na data - se existe - desconsiderar
	cNumPEd := fPedPA(TRB->ZZ1_COD,dDatabase)	// rota emissao
	If cUserName == "JDEUS" .And. getEnvServer() == "CONP"
		cNumPed := ""                                        
	EndIf
	
	dAux := dDatabase+1                 
	// sexta - data entrega eh segunda
	If Dow(dAux) == 6
		dAux += 3
	// sabado - data entrega eh segunda
	ElseIf Dow(dAux) == 7
		dAux += 2
	ElseIf Dow(dAux) == 1
		dAux += 1
	EndIf
	
		
	dbSelectArea("TRB1")
	RecLock("TRB1",.T.)
	TRB1->STATUS	:= IIF( Empty(cNumPed),"BR_BRANCO","BR_VERDE" ) 
	TRB1->DT		:= dDatabase
	TRB1->DTENT		:= dAux	//dDatabase+1
	TRB1->PA		:= TRB->ZZ1_COD
	TRB1->ESTOQUE	:= TRB->ZZ1_DESCRI
	TRB1->ARM		:= ""
	TRB1->ABAST		:= TRB->ZZ1_XNOMAT
	TRB1->OBS		:= TRB->ZZ1_TELEFO
	TRB1->PEDIDO	:= cNumPed		
	TRB1->(MsUnLock())

	dbSelectArea("TRB") 
	TRB->( dbSkip() )
EndDo
TRB->(dbCloseArea())
                
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfPedPA  บAutor  ณJackson E. de Deus    บ Data ณ  17/02/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se ja foi gerado pedido para o armazem            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fPedPA(cArm,dData)
              
Local lExiste := .F.
Local cQuery := ""
Local cNumPed := ""

cQuery := "SELECT * FROM " +RetSqlName("SC5") +" SC5 " 

cQuery += "INNER JOIN " +RetSqlName("SC6") +" SC6 ON "
cQuery += "C6_FILIAL = C5_FILIAL "
cQuery += "AND C6_NUM = C5_NUM "

cQuery += " WHERE C5_FILIAL = '"+xFilial("SC5")+"' AND C5_XCODPA = '"+cArm+"' AND C5_EMISSAO = '"+dtos(dData)+"' "
cQuery += " AND C5_XFINAL = '4' AND SC5.D_E_L_E_T_ = '' AND C5_NOTA NOT LIKE '%XX%' "

If Select("TRBC") > 0
	TRBC->(dbCloseArea())
EndIf

DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRBC", .F., .T. )
dbSelectArea("TRBC") 
While !EOF()
	If AllTrim(TRBC->C6_LOCAL) == "D00002"
		dbSkip()
		Loop
	EndIf
	cNumPed := TRBC->C5_NUM
	dbSkip()
End
TRBC->(dbCloseArea())
	

Return cNumPed


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณOsInvent  บAutor  ณJackson E. de Deus  บ Data ณ  15/02/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Geracao da OS de inventario                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function OsInvent()

If _lInvEnv
	MsgAlert("Jแ existe uma OS de inventแrio!")
	Return
EndIf

// gerar OS de inventario
If !MsgYesNo("Deseja enviar uma OS de inventแrio para o atendente?")
	Return
EndIf

LJMsgRun("Gerando a Ordem de Servi็o","Aguarde...",{|| geraOS() })

Return
      


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณgeraOS  บAutor  ณJackson E. de Deus    บ Data ณ  16/02/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Criacao de OS de inventario                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function geraOS()

Local cOsInvent := ""     
Local cCodTec	:= AllTrim(Posicione("ZZ1",1,xFilial("ZZ1") +AvKey(_cArmazem,"ZZ1_COD"),"ZZ1_XATEND" ))
Local nTpInv	:= 1	// 1 = SB2 | 2 = SZ7

If Empty(_aRecnos)
	If MsgYesNO("Ainda nใo foi feita manuten็ใo nos produtos a serem enviados. Confirma os produtos da maneira como estใo?")
		Gravar(oList2:acols)
	Else 
		Return
	EndIf
EndIf

If Empty(cCodTec)
	MsgAlert("PA sem atendente configurado. Escolha o atendente responsแvel pelo inventแrio na consulta a seguir.")
	lRet := ConPad1(,,,"AA1",,,.F.)
	If !lRet
		Return
	EndIf
	cCodTec := AllTrim(AA1->AA1_CODTEC)
EndIf

cOsInvent := U_TTPROC42( _cArmazem,"000001","0001",cCodTec,nTpInv )
If !Empty(cOsInvent)
	dbSelectArea("SZO")
	For nI := 1 To Len(_aRecnos)
		dbGoTo(_aRecnos[nI])
		RecLock("SZO",.F.)
		SZO->ZO_OSINV := cOsInvent
		MsUnLock()			
	Next nI
	MsgInfo("Ordem de servi็o criada! -> " +cOsInvent)
	_cNumOS := cOsInvent
	oS9:Refresh()
EndIf


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT39C  บAutor  ณMicrosiga           บ Data ณ  10/25/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fMaqX()

Local cMes		:= SubStr(dtos(_dEntAtu),1,6)
Local cMes2		:= ""
Local nPosDia	:= 8+Day(_dEntAtu)
Local aMaquinas	:= {}
Local cQuery	:= ""

If !_lRota
	// maquinas
	cQuery := "SELECT N1_CHAPA FROM " +RetSqlName("SN1")
	cQuery += " WHERE N1_XPA = '"+_cArmazem+"'
	cQuery += " AND D_E_L_E_T_ = '' "
	cQuery += " ORDER BY N1_CHAPA "
	If Select("TRBZ") > 0
		TRBZ->(dbCloseArea())
	EndIf
	
	TcQuery cQuery New Alias "TRBZ" 
	
	dbSelectArea("TRBZ")
	While TRBZ->(!EOF())
		AADD( aMaquinas, { TRBZ->N1_CHAPA,0,{},0} ) 	
		TRBZ->(dbSkip())
	End
	TRBZ->(dbCloseArea())
	
	If Empty(aMaquinas)
		MsgInfo("Nใo hแ mแquinas instaladas nesse local.")
		Return
	EndIf
	
	_aMaquinas := Aclone( aMaquinas )
Else
	/*
	_dEntAtu
	_dEntProx*/
	nPosIni	:= 8+Day(_dEntAtu)
	nPosFim := 8+Day(_dEntProx)
	
	// maquinas -> Alterar para considerar todas as maquinas do periodo de atendimento
	cQuery := "SELECT ZE_CHAPA, ZE_MENSAL FROM " +RetSqlName("SZE")
	cQuery += " WHERE ZE_ROTA = '"+_cArmazem+"'
	cQuery += " AND ZE_MENSAL LIKE '%"+cMes+"%' AND D_E_L_E_T_ = '' "
	cQuery += " ORDER BY ZE_CHAPA "
	                         
	If Select("TRBZ") > 0
		TRBZ->(dbCloseArea())
	EndIf
	
	TcQuery cQuery New Alias "TRBZ" 
	
	dbSelectArea("TRBZ")
	While TRBZ->(!EOF())
	                 
		cMensalM := AllTrim(TRBZ->ZE_MENSAL)
		For dDia := _dEntAtu To _dEntProx
			If "1" $ SubStr( cMensalM,nPosIni,nPosFim )
				If Ascan( aMaquinas, { |x| x[1] == TRBZ->ZE_CHAPA } ) == 0
					AADD( aMaquinas, { TRBZ->ZE_CHAPA, 0,{},7 } )	
				EndIf
			EndIf
		Next dDia
	
		//AADD( aMaquinas, { TRBZ->ZE_CHAPA, 0,{},1 } )	
		TRBZ->(dbSkip())
	End
	TRBZ->(dbCloseArea())
	
	If Empty(aMaquinas)
		MsgInfo("Nใo hแ programa็ใo de mแquinas para essa data. Verifique o plano de trabalho.")
		Return
	EndIf
	
	_aMaquinas := Aclone( aMaquinas )
	

	// proxima visita - depende do plano de trabalho do proximo mes ja replicado
	nPosIni := 8
	cMes2 := SubStr(dtos(LastDay(_dEntAtu)+1),1,6)
	
	cQuery := "SELECT ZE_CHAPA,ZE_MENSAL FROM " +RetSqlName("SZE") + " SZE "
	cQuery += " WHERE "
	cQuery += " ZE_FILIAL = '"+xFilial("SZE")+"' "
	cQuery += " AND ZE_ROTA = '"+_cArmazem+"' AND D_E_L_E_T_ = '' "
	cQuery += " AND ( ZE_MENSAL LIKE '%"+cMes+"%' OR ZE_MENSAL LIKE '%"+cMes2+"%' ) "
	cQuery += " ORDER BY ZE_MENSAL "
	
	If Select("TRB") > 0
		TRB->(dbCloseArea("TRB"))
	EndIf

	MpSysOpenQuery(cQuery,"TRB")	
	dbSelectArea("TRB")                  
	While !EOF()			
		nPOs := Ascan( aMaquinas, { |x| x[1] == TRB->ZE_CHAPA } ) 
		If nPos == 0
			TRB->(dbSkip())
			Loop
		EndIf
		
		If aMaquinas[nPos][4] > 0
			TRB->(dbSkip())
			Loop
		EndIf
		
		cMensal := AllTrim(TRB->ZE_MENSAL)
		If SubsTr(cMensal,1,4) == CValToChar(Year(_dEntAtu)) .And. VaL(SubsTr(cMensal,5,2)) == MontH(_dEntAtu)
			dDtIni := _dEntAtu
			dDtFim := LastDay(_dEntAtu)
		Else
			dDtIni := FirstDay(LastDay(_dEntAtu)+1)
			dDtFim := LastDay(LastDay(_dEntAtu)+1)
		EndIf
		
		For dDia := dDtIni+1 To dDtFim
			nP := Day(dDia)	
			If SubStr(cMensal,nPosIni+nP,1) $ "1#F#T"
				aMaquinas[nPos][4] := dDia-_dEntAtu				
				Exit
			EndIf
		Next dDia
		TRB->(dbSkip())
	End
	TRB->(dbCloseArea("TRB"))
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT39C  บAutor  ณMicrosiga           บ Data ณ  11/11/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ViewMaq()

Local oWindow

oWindow := MSDialog():New( 0,0,300,500,"Mแquinas atendidas no perํodo",,,.F.,,CLR_WHITE,,,,.T.,,,.T. )		
	
	oList := TCBrowse():New(0,0,0,0,,,,oWindow,,,,{ || },{ ||  },,,,,,,.F.,,.T.,,.F.,,,)
	oList:SetArray(_aMaquinas)
	  
	oList:AddColumn(TCColumn():New("Patrim๔nio"		,{ || _aMaquinas[oList:nAt][1] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,)) 
	oList:AddColumn(TCColumn():New("Modelo"		,{ || Posicione( "SN1",2,xFilial("SN1")+AvKey(_aMaquinas[oList:nAt][1],"N1_CHAPA"),"N1_DESCRIC" ) },"@!",,,'LEFT',,.F.,.F.,,,,.F.,)) 
	                                      
	oList:Align := CONTROL_ALIGN_ALLCLIENT
	//oList:bLDblClick := {|| DblClk(@aNFS,@cNotas)} 	
	oList:nScrollType := 1 
			    
oWindow:Activate(,,,.T.) 



Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProcDem     บAutor  ณJackson E. de Deusบ Data ณ  16/02/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa o calculo da demanda                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ProcDem(lEnd)

Local nI
Local nJ
Local cOsInvent := _cNumOS
Local dDtFimOS := stod("")
Local aDados := {}
Local axItens := {}
Local aItens := {}
Local aItensDs := {}
Local nPosProd	:= Ascan( aHeader, { |x| AllTrim(x[2]) == "ZO_CODPRO" } )
Local nPosEstP	:= Ascan( aHeader, { |x| AllTrim(x[2]) == "ZO_ESTOQUE" } )
Local nPosInv 	:= Ascan( aHeader, { |x| AllTrim(x[2]) == "ZO_QINV" } )
Local nPosAVar	:= Ascan( aHeader, { |x| AllTrim(x[2]) == "ZO_QAVAR" } )
Local nPosDiff	:= Ascan( aHeader, { |x| AllTrim(x[2]) == "ZO_QDIFF" } )
Local nPCmd		:= Ascan( aHeader, { |x| AllTrim(x[2]) == "ZO_CMD" } ) 
Local nPCP		:= Ascan( aHeader, { |x| AllTrim(x[2]) == "ZO_CP" } ) 
Local nPCalc	:= Ascan( aHeader, { |x| AllTrim(x[2]) == "ZO_QCALC" } ) 
Local nPQEnv	:= Ascan( aHeader, { |x| AllTrim(x[2]) == "ZO_QTDPED" } ) 
Local aCalc		:= {0,0,0,0}
Local nPosDia	:= 8+Day(_dEntAtu)
Local cMes		:= SubStr(dtos(_dEntAtu),1,6)
Local cMes2		:= ""
Local nPosAlter	:= 0
Local nPosOrig	:= 0
Local nPesoOri	:= 0
Local nPesoAlt	:= 0
Local nQtd		:= 0
									
If Empty(cOsInvent) .And. !_lRota
	MsgInfo("A Ordem de servi็o nใo foi criada!")
	Return
EndIf

Esvazia()

aCols := Aclone(oList2:Acols)
//ProcRegua(Len(aCols))
oProcess:SetRegua1(Len(aCols))

// produtos alternativos
ProdAlter()
	
// PA
If !Empty(cOsInvent) .And. !_lRota
	dbSelectArea("SZG")
	dbSetOrder(1)
	If MsSeek( xFilial("SZG") +AvKey(cOsInvent,"ZG_NUMOS") )
		If AllTrim(SZG->ZG_STATUS) <> "FIOK"
			MsgInfo("A ordem de servi็o ainda nใo foi finalizada.")
		Else
			_lInvOk := .T.
			dDtFimOS := SZG->ZG_DATAFIM
					
			aDados := U_MXML000(SZG->ZG_RESPOST)
			For nI := 1 To Len(aDados)          
				If aDados[nI][1] == "INVENTARIO"
					For nJ := 2 To Len(aDados[nI])
						AADD( axItens, ACLONE(aDados[nI][nJ]) )
					Next nJ
				EndIf	
			Next nI
			For nI := 1 To Len(axItens)	// verificar
				AADD( aItens, { axitens[nI][1][2], Val(axItens[nI][2][2]) } )
				AADD( aItensDs, { axitens[nI][1][2], Val(axItens[nI][3][2]) } )
			Next nI		    		
		EndIf
		         
		// inventario ok - faz calculos e grava
		If _lInvOk
			For nI := 1 To Len(oList2:aCols)
			
				If lEnd
					Exit
				EndIf			

				If oList2:aCols[nI][Len(aHeader)+1]
					Loop
				EndIf
				
				// nao calcular o alternativo aqui
				nPosAlter := AScan( _aProdAlter, { |x| x[1] == oList2:aCols[nI][nPosProd] } )
				If nPosAlter > 0		
					Loop
				EndIf
				
				cDescProd := AllTrim( Posicione( "SB1",1,xFilial("SB1") +AvKey(oList2:aCols[nI][nPosProd],"B1_COD"),"B1_DESC" ) )		
				oProcess:SetRegua2(Len(aMaquinas))
				
				oProcess:IncRegua1( AllTrim(oList2:aCols[nI][nPosProd]) +" -> " +cDescProd )
				
				For nJ := 1 To Len(aItens)
					If AllTrim(oList2:aCols[nI][nPosProd]) == AllTrim(aItens[nJ][1])
						oList2:aCols[nI][nPosInv] := aItens[nJ][2]
					EndIf
				Next nJ
				
				For nJ := 1 To Len(aItensDs)
					If AllTrim(oList2:aCols[nI][1]) == AllTrim(aItensDs[nJ][1])
						oList2:aCols[nI][nPosAvar] := aItensDs[nJ][2]
					EndIf
				Next nJ
				      
			    aCalc := {0,0,0,0} 
			    nDiff := oList2:aCols[nI][nPosInv] - oList2:aCols[nI][nPosEstP]
				aCalc := CalcE(_cARmazem,oList2:aCols[nI][nPosProd],dDtFimOS,_dEntAnt,_dEntAtu,_dEntProx,oList2:aCols[nI][nPosInv])
				//aCalc := CalcE2(_cARmazem,oList2:aCols[nI][nPosProd],dDtFimOS,_dEntAnt,_dEntAtu,_dEntProx,oList2:aCols[nI][nPosInv])
												
				// diferenca
				oList2:aCols[nI][nPosDiff] := nDiff
								
				// consumo medio -> consumo estoque N das maquinas da PA / dias uteis
				oList2:aCols[nI][nPCmd] := aCalc[1] 
				
				// consumo projetado -> consumo medio diario * qtd dias (prox entrega - entrega atual)
				oList2:aCols[nI][nPCP] := aCalc[2]
				
				// qtd calculada -> consumo projetado - estoque liquido + consumo de 1 dia (janela de interrupcao para processamento/entrega)
				oList2:aCols[nI][nPCalc] := aCalc[3] 
				
				// qtd a enviar -> calculada : arredondado
				oList2:aCols[nI][nPQEnv] := aCalc[4]
				
				nCalc := 0
				For nJ := 1 To Len( _aMaquinas )
					aProds := Aclone( _aMaquinas[nJ][3] )
					For nK := 1 To Len( aProds )
						If AllTrim(aProds[nK][1]) == AllTrim(oList2:aCols[nI][nPosProd])
							nCalc += Arred( aProds[nK][2] )
						EndIf
					Next nK
				Next nJ
				
				// quantidade a enviar -> com base no pickList	
				oList2:aCols[nI][nPQEnv] := nCalc
				
			Next nI					
		EndIf
	EndIf
// Rota
Else
	For nI := 1 To Len(oList2:aCols)
		If lEnd
			Exit
		EndIf
		
		If oList2:aCols[nI][Len(aHeader)+1]
			Loop
		EndIf            
		
		// nao calcular o alternativo aqui
		nPosAlter := AScan( _aProdAlter, { |x| x[1] == oList2:aCols[nI][nPosProd] } )
		If nPosAlter > 0		
			Loop
		EndIf
				
		cDescProd := AllTrim( Posicione( "SB1",1,xFilial("SB1") +AvKey(oList2:aCols[nI][nPosProd],"B1_COD"),"B1_DESC" ) )		
		oProcess:SetRegua2(Len(_aMaquinas))		
		oProcess:IncRegua1( AllTrim(oList2:aCols[nI][nPosProd]) +" -> " +cDescProd )
	    
	    aCalc := {0,0,0,0} 	    
		aCalc := CalcE(_cARmazem,oList2:aCols[nI][nPosProd],dDatabase,dDatabase,_dEntAtu,_dEntAtu+1,oList2:aCols[nI][nPosInv])
												
		// consumo medio -> consumo estoque N das maquinas da PA / dias uteis
		oList2:aCols[nI][nPCmd] := aCalc[1] 
		
		// consumo projetado -> consumo medio diario * qtd dias (prox entrega - entrega atual)
		oList2:aCols[nI][nPCP] := aCalc[2]
		
		// qtd calculada -> consumo projetado - estoque liquido + consumo de 1 dia (janela de interrupcao para processamento/entrega)
		oList2:aCols[nI][nPCalc] := aCalc[3]
		
		// qtd a enviar -> calculada : arredondado
		oList2:aCols[nI][nPQEnv] := aCalc[4]
		
        If _cTpRota == "SNACKS"                          
			nCalc := 0
			For nJ := 1 To Len( _aMaquinas )
				aProds := Aclone( _aMaquinas[nJ][3] )
				For nK := 1 To Len( aProds )
					If AllTrim(aProds[nK][1]) == AllTrim(oList2:aCols[nI][nPosProd])
						nCalc += Arred( aProds[nK][2] )
					EndIf
				Next nK
			Next nJ
			// quantidade a enviar -> com base no pickList	
			oList2:aCols[nI][nPQEnv] := nCalc
		EndIf
		/*		
		If _cTpRota == "CAFE"
			nCalc := Arred( (nCalc/7)*7 )
		EndIf*/
						              							
	Next nI
EndIf      

// tratamento para os produtos alternativos
For nI := 1 To Len(oList2:aCols)
	If lEnd
		Exit
	EndIf            
	
	// tratamento para o produto alternativo
	nPosAlter := AScan( _aProdAlter, { |x| x[1] == oList2:aCols[nI][nPosProd] } )	// eh um alternativo?
	If nPosAlter > 0
		nPosOrig := AScan( oList2:aCols, { |x|, x[nPosProd] == _aProdAlter[nPosAlter][3] } )	// procura o original no grid
		If nPosOrig > 0
			nPesoOri := _aProdAlter[nPosAlter][4]
			nPesoAlt := _aProdAlter[nPosAlter][2]
			nQtd := 0
			
			If nPesoOri == nPesoAlt
				nQtd := oList2:aCols[nPosOrig][nPQEnv]		
			Else
				nQtd := ( oList2:aCols[nPosOrig][nPQEnv] * nPesoOri ) / nPesoAlt
			EndIf
			
			oList2:aCols[nI][nPCmd] := 0
			oList2:aCols[nI][nPCP] := 0
			oList2:aCols[nI][nPCalc] := 0
			oList2:aCols[nI][nPQEnv] := nQtd
			Loop
		EndIf
	EndIf
Next nI

// grava na tabela
Gravar(oList2:aCols)

// grava o pickList na tabela PickList
GravaPick()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProdAlter  บAutor  ณMicrosiga           บ Data ณ  11/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ProdAlter()

Local nPosProd	:= Ascan( aHeader, { |x| AllTrim(x[2]) == "ZO_CODPRO" } )
Local nI


dbSelectArea("SB1")
dbSetOrder(1)
	
For nI := 1 To Len(oList2:aCols)

	// ver o seu alternativo -> somente cafe
	If MsSeek( xFilial("SB1") +AvKey(oList2:aCols[nI][nPosProd],"B1_COD") )     
		nPeso := SB1->B1_PESO
		If AllTrim(SB1->B1_XSECAO) $ "005#007#036" .And. !Empty( SB1->B1_ALTER )		              
			If Ascan( _aProdAlter, { |x| x[1] == SB1->B1_ALTER } ) == 0
				If MsSeek( xFilial("SB1") +AvKey( SB1->B1_ALTER,"B1_COD" ) ) 
					AADD( _aProdAlter, { SB1->B1_COD,SB1->B1_PESO,oList2:aCols[nI][nPosProd], nPeso  } ) // alternativo, peso, original, peso     
				EndIf
			EndIf
		EndIf
	EndIf
		 						
Next nI                                    

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT39C  บAutor  ณMicrosiga           บ Data ณ  11/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Esvazia Array para calculo                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Esvazia()
    
Local nI    
  
For nI := 1 To Len( _aMaquinas )
	If Len( _aMaquinas[nI][3] ) > 0
		_aMaquinas[nI][3] := {}
	EndIf
Next nI


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCalcE  บAutor  ณJackson E. de Deus     บ Data ณ  16/02/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Faz o calculo do consumo e qtd a enviar                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CalcE(cArmazem,cProduto,dAtu,dEntAnt,dEntAtu,dEntProx,nEstLiq)
            
Local aCalc := {0,0,0,0}
Local nCalc := 0
Local cQuery := ""
Local nDias := dAtu - dEntAnt+1
Local nDias2 := dEntProx - dEntAtu+1
Local nDoses := 0
Local aDoses := {}
Local lInsumo := .F.
Local cSecao := ""
Local nPeriodo := 1
Local nPosDia := 8
Local nI 
Local nAux := 0
Local nAux2 := 0
Local nProj := 0

// INSUMO?
cSecao := AllTrim(Posicione("SB1",1,xFilial("SB1") +AvKey(cProduto,"B1_COD"),"B1_XSECAO"))
If cSecao $ "005#007#036"
	lInsumo := .T.
EndIf
       

// PA
If !_lRota

	// snacks
	If !lInsumo	
		// alterar para pegar a venda - considerar periodo
		nCalc := 0	                    	
		For nI := 1 To Len(_aMaquinas)
			oProcess:IncRegua2("Mแquina: " +_aMaquinas[nI][1])
			
			cModelo := Posicione( "SN1",2,xFilial("SN1") +AvKey(_aMaquinas[nI][1],"N1_CHAPA"),"N1_PRODUTO" )
			cTipBeb := Posicione( "SB1",1, xFilial("SB1") +AvKey(cModelo,"B1_COD"),"B1_XFAMILI" )
			lBebida	:= cTipBeb $ "144/153"
			
			// bebida gelada ROYAL - pegar pelos contadores
			If lBebida .And. cSecao == "008" .And. AllTrim(cModelo) == "8000305"
				nAux := VendaBeb( _aMaquinas[nI][1],cProduto,dEntAnt,dAtu )
				nCalc += nAux
			Else
				nAux := VendaZ0(_aMaquinas[nI][1],cProduto,,dEntAnt,dAtu)
				nCalc += nAux
			EndIf
			
			nAux := nAux/nDias 
												 
			AADD( _aMaquinas[nI][3],{ cProduto, nAux } )	// O total calculado dessa maquina		
		Next nI 
		
		If nCalc < 0
			nCalc := 0
		EndIf
			
		aCalc[1] := nCalc / nDias
		aCalc[2] := aCalc[1] * nDias2
		aCalc[3] := aCalc[2] - nEstLiq +aCalc[1]		
		aCalc[4] := Arred(aCalc[3])
				
		If aCalc[4] < 0
			aCalc[4] := 0
		EndIf
		
	// Insumos
	Else
		// pelos contadores
		nCalc := 0
		aDetail := {}
		aDoses := {}	                    	
		For nI := 1 To Len(_aMaquinas)
			oProcess:IncRegua2("Mแquina: " +_aMaquinas[nI][1])
			
			nCalcMaq := CalcCsmo( _aMaquinas[nI][1],cProduto,dEntAnt,dAtu,@aDetail )

			_aMaquinas[nI][2] += nCalcMaq
						
			nCalc += nCalcMaq
			AADD( _aMaquinas[nI][3],{ cProduto, nCalcMaq, aDoses } )	// O total calculado dessa maquina
		Next nI
		
		If nCalc < 0
			nCalc := 0
		EndIf         
		
		aCalc[1] := nCalc / nDias
		aCalc[2] := aCalc[1] * nDias2
		aCalc[3] := aCalc[2] - nEstLiq +aCalc[1]		
		aCalc[4] := Arred(aCalc[3])
		
		If aCalc[4] < 0
			aCalc[4] := 0
		EndIf
	EndIf	

// ROTA
Else
	// snacks
	If !lInsumo
		nCalc := 0
		nAux := 0
		nAux2 := 0
		nProj := 0
		For nI := 1 To Len(_aMaquinas)
		
			oProcess:IncRegua2("Mแquina: " +_aMaquinas[nI][1])
			
			cModelo := Posicione( "SN1",2,xFilial("SN1") +AvKey(_aMaquinas[nI][1],"N1_CHAPA"),"N1_PRODUTO" )
			cTipBeb := Posicione( "SB1",1, xFilial("SB1") +AvKey(cModelo,"B1_COD"),"B1_XFAMILI" )
			lBebida	:= cTipBeb $ "144/153"
			
			nAux := 0
			nAux2 := 0
			
			// bebida gelada ROYAL - pegar pelos contadores
			If lBebida .And. cSecao == "008" .And. AllTrim(cModelo) == "8000305"
				nAux := VendaBeb( _aMaquinas[nI][1],cProduto,dAtu-30,dAtu )
			Else		
				// venda do periodo de 30 dias
				nAux := VendaZ0(_aMaquinas[nI][1],cProduto,,dAtu-30,dAtu)	//nAux := VendaZH(aMaquinas[nI][1],cProduto)
			EndIf
								
			nCalc += nAux			
			nAux2 := (nAux/30)
			nProj += nAux2
			nAux2 := Arred(nAux2)
								 
			AADD( _aMaquinas[nI][3],{ cProduto, nAux2 } )	// O total calculado dessa maquina							 
		Next nI
		
		If nCalc < 0
			nCalc := 0
		EndIf
				                     
		//nCalc -> Total vendido = soma da venda do produto em todas as maquinas
		aCalc[1] := (nCalc/30)	// media do periodo
		aCalc[2] := nProj		// soma das projecoes para todas as maquinas
		aCalc[3] := aCalc[2]	// Int(aCalc[2])		
		aCalc[4] := Arred(aCalc[3])
		
		If aCalc[4] < 0
			aCalc[4] := 0
		EndIf  	
			         
	// insumos cafe
	Else						
		nCalc := 0
		nAux2 := 0
		nProj := 0                    	
		For nI := 1 To Len(_aMaquinas)
		
			oProcess:IncRegua2("Mแquina: " +_aMaquinas[nI][1])
			nAux2 := 0
			nCalcMaq := 0
			aDoses := {}
			aDatas := {}
			For nJ := dAtu-9 To dAtu-2
				AADD( aDatas, nJ )
			Next nJ
			For nJ := 1 To Len(aDatas)
				aDetail := {}
				nCalcMaq := CalcCsmo( _aMaquinas[nI][1],cProduto,aDatas[nJ],aDatas[nJ], @aDetail )				
				_aMaquinas[nI][2] += nCalcMaq
				
				AADD( aDoses,{ aDatas[nJ], aDetail } )								                
				
				nAux2 += nCalcMaq
				nCalc += nCalcMaq
			Next nJ

			AADD( _aMaquinas[nI][3],{ cProduto, nAux2, aDoses } )	// O total calculado dessa maquina
		Next nI
		
		If nCalc < 0
			nCalc := 0
		EndIf
		
		// converter o resultado de acordo com a embalagem - 03/11/2016
		nPeso := Posicione( "SB1",1,xFilial("SB1")+AvKey(cProduto,"B1_COD"),"B1_PESO" )
		If nPeso > 0
		//	nCalc := nCalc/nPeso
		EndIf
		
		aCalc[1] := ( nCalc / 7 )		
		aCalc[2] := ( aCalc[1] * 7 )	// calculado multiplicado por 7 - projecao de 1 semana
		aCalc[3] := aCalc[2]		
		aCalc[4] := Arred(aCalc[3])
	
		If aCalc[4] < 0
			aCalc[4] := 0
		EndIf  						
	EndIf
EndIf


Return aCalc


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณArred  บAutor  ณJackson E. de Deus     บ Data ณ  09/08/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Arredondamento para cima                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Arred(nVal)

Local cAux := ""
Local nPos := 0
Local cDec := ""

If "." $ CvalToChar(nVal)
	cAux := cvaltochar(nVal)
	nPos := At(".",cAux)
	cDec := SubStr( cAux,nPos+1 )
	If Val(cDec) > 0
		nVal := Int(nVal)+1
	EndIf
EndIf

Return nVal


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVendaZH  บAutor  ณJackson E. de Deus   บ Data ณ  09/08/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Venda da mola no periodo de 30 dias                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VendaZH(cMaquina,cProduto)

Local nVenda := 0

cQuery := "SELECT ZH_VENDA FROM " +RetSqlName("SZH") 
cQuery += " WHERE ZH_CHAPA = '"+cMaquina+"' AND ZH_STATUS = '3' AND D_E_L_E_T_ = '' AND ZH_VERSAO <> '' "
cQuery += " AND ZH_CODPROD = '"+cProduto+"' "

MPSysOpenQuery( cQuery , "TRB" ) 

dbSelectArea("TRB")
While !EOF()
	nVenda += TRB->ZH_VENDA
	dbSkip()
End

Return nVenda


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVendaZ0   บAutor  ณJackson E. de Deus  บ Data ณ  12/07/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Venda no periodo - Snacks                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VendaZ0(cMaquina,cProduto,cMola,dEntAnt,dAtu)

Local cQuery := ""
Local aSZ0 := {} 
Local aDatas := {}
Local nCount := 0 
Local aMola := {}
Local nI
Local nJ
Local nK
Local cMola := ""
Local nVenda := 0
Local dData := stod("")
Local nSld := 0
Local nSldMov := 0
Local nVendatot := 0


Default cMola := ""
Default dEntAnt := Stod("")
Default dAtu := Stod("")

cQuery := "SELECT Z0_DATA,Z0_MOLA, Z0_SALDO,Z0_SLDMOV FROM " +RetSqlName("SZ0")
cQuery += " WHERE "
cQuery += " Z0_PRODUTO = '"+cProduto+"' "
cQuery += " AND Z0_CHAPA = '"+cMaquina+"' "
cQuery += " AND Z0_DATA < '"+DTOS(dAtu)+"' "

If !Empty(dEntAnt)
	cQuery += " AND Z0_DATA >= '"+DTOS(dEntAnt)+"' "
EndIf

cQuery += "AND D_E_L_E_T_ = '' "

If !Empty(cMola)
	cQuery += " AND Z0_MOLA = '"+cMola+"' "
EndIf

cQuery += "ORDER BY Z0_DATA DESC,Z0_MOLA "
	
If Select("TRBZ") > 0
	TRBZ->(dbCloseArea())
EndIf

TcQuery cQuery New Alias "TRBZ" 

dbSelectArea("TRBZ")
/*
// consulta cabeceira - considerar 3 primeiros registros por maquina

SELECT Z0_CHAPA, Z0_SALDO, Z0_SLDMOV, Z0_DATA,
( SELECT TOP 1 Z0_SLDMOV FROM SZ0010 SZ02 
				WHERE Z0_CHAPA = SZ01.Z0_CHAPA 
					AND Z0_PRODUTO = SZ01.Z0_PRODUTO
					AND SZ02.Z0_DATA < SZ01.Z0_DATA
					ORDER BY Z0_DATA DESC ) AS SLDMOV,

(
SELECT TOP 1 Z0_SLDMOV FROM SZ0010 SZ02 
				WHERE Z0_CHAPA = SZ01.Z0_CHAPA 
					AND Z0_PRODUTO = SZ01.Z0_PRODUTO
					AND SZ02.Z0_DATA < SZ01.Z0_DATA
					ORDER BY Z0_DATA DESC
)-Z0_SALDO AS VENDA


FROM SZ0010 SZ01
WHERE Z0_PRODUTO = '1003415'
AND Z0_CHAPA IN (
'10520',
'11214', 
'11517',
'6070',  
'6877',  
'9267'  
)
AND Z0_DATA < '20160713'
ORDER BY Z0_CHAPA,Z0_DATA DESC
*/

While !EOF()	
	/*If Len(aDatas) >= 4
		Exit
	Else
		If Ascan( aDatas, { |x| x == STOD(TRBZ->Z0_DATA) } ) == 0
			AADD( aDatas, STOD(TRBZ->Z0_DATA) )
		EndIf
	EndIf*/
	
	AADD( aSZ0, { STOD(TRBZ->Z0_DATA), AllTrim(TRBZ->Z0_MOLA), TRBZ->Z0_SALDO, TRBZ->Z0_SLDMOV } )
		
	TRBZ->(dbSkip())
End

For nI := 1 To Len(aSZ0)
	If Ascan( aMola, { |x| x[1] == aSZ0[nI][2] } )	 == 0
		AADD( aMola, { aSZ0[nI][2] } )
	EndIf
Next nI

cMOla := ""
dData := stod("")
nSld := 0
nSldMov := 0
nVendatot := 0

For nI := 1 To Len(aMola)
	cMola := aMola[nI][1]
	For nJ := 1 To Len(aSZ0)
		If cMola == aSZ0[nJ][2]
			dData := aSz0[nJ][1]
			nSld := aSZ0[nJ][3]
			    
			For nK := 1 To Len(aSZ0)
				If cMola == aSZ0[nK][2] .And. aSZ0[nK][1] < dData
					nSldMov := aSZ0[nK][4]
				
					If ( nSldMov - nSld ) > 0
						nVendatot += nSldMov - nSld
					EndIf
									
					Exit
				EndIf
			Next nK
		EndIf
	Next nJ
Next nI


Return nVendatot


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCalcCsmo  บAutor  ณJackson E. de Deus  บ Data ณ  22/02/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Consumo dos insumos                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CalcCsmo( cMaq, cProd, dEntAnt,dAtu,aDetail )

Local aCalc := {}
Local cQuery := ""
Local nQuant := 0
Local nI,nJ
Local aProdsMaq := {}
Local cBotP := ""
Local nCntAux := 0
Local nRecAnt := 0
Local lOrcam := .F.
Local nQtdIns := 0
Local nCnt1 := 0
Local nCnt2 := 0
Local nConts := 0
Local nLimite := SuperGetMV("MV_XFAT008",.T.,0) //300
Local lVldCnt := SuperGetMV("MV_XFAT009",.T.,.F.)
Local nDias := ( dAtu - dEntAnt )+1
Local nCnt := 0
Local dData := Stod("")

		
// produtos nas posicoes
cQuery := "SELECT  "
For nI := 1 To 12//60
	cQuery += "N1_XP" +cvaltochar(nI)
	If nI <> 12//60
		cQuery += ","
	EndIf	
Next nI

cQuery += " FROM " +RetSqlName("SN1")
cQuery += " WHERE N1_CHAPA = '"+cMaq+"' AND D_E_L_E_T_ = '' "

MPSysOpenQuery( cQuery , "TRBZ" )

dbSelectArea("TRBZ")
If !EOF()
	For nI := 1 To 12//60
		AADD( aProdsMaq, { &("TRBZ->N1_XP"+cvaltochar(nI)),0,{},0 })	// dose | qtd_insumo_usa | quantidade contadores | total consumo insumo
	Next nI
EndIf

// receita                  
For nI := 1 To Len(aProdsMaq)
	If !Empty(aProdsMaq[nI][1])
		cQuery := "SELECT G1_COD, G1_COMP, G1_QUANT FROM " +RetSqlName("SG1")
		cQuery += " WHERE G1_COMP = '"+cProd+"' AND G1_COD = '"+aProdsMaq[nI][1]+"' AND D_E_L_E_T_ = '' "
		
		MPSysOpenQuery( cQuery , "TRBZ" )
		If !EOF()
			aProdsMaq[nI][2] := TRBZ->G1_QUANT
		EndIf
	EndIf
Next nI


nCnt := 0

// SZN
cQuery  := "SELECT "		
For nI := 1 To 12//60                       
	cBotP := Padl( cvaltochar(nI),2,"0"  )
	cQuery += "ZN_BOTAO" +cBotP
	If nI <> 12//60
		cQuery += ","
	EndIf
Next nI

cQuery += " FROM " +RetSqlName("SZN")
cQuery += " WHERE "
cQuery += " ZN_PATRIMO = '"+cMaq+"' "
cQuery += " AND ZN_DATA BETWEEN '"+dtos(dEntAnt)+"' AND '"+dtos(dAtu)+"' AND ZN_VALIDA = 'O' AND ZN_TIPINCL IN ('ABASTEC','LEITURA CF', 'INSTALACAO', 'REMOCAO' ) "
cQuery += " ORDER BY ZN_DATA DESC, ZN_HORA DESC, ZN_NUMATU DESC "

MPSysOpenQuery( cQuery , "TRBZ" )		

If EOF()
	Return nQuant
EndIf

While !EOF()
	For nI := 1 To Len(aProdsMaq)
		If aProdsMaq[nI][2] > 0	// TEM RECEITA?
			cBotP := Padl( cvaltochar(nI),2,"0" )
			AADD( aProdsMaq[nI][3], &("TRBZ->ZN_BOTAO"+cBotP))		
		EndIf
	Next nI
	TRBZ->(dbSkip())
End	
	
nCntAux := 0
nRecAnt := ZNCon(cMaq,dEntAnt)
If nRecAnt > 0
	dbSelectArea("SZN")
	dbGoTo(nRecAnt)
	For nI := 1 To Len(aProdsMaq)
		If aProdsMaq[nI][2] > 0
			cBotP := Padl( cvaltochar(nI),2,"0"  )                                     
			AADD( aProdsMaq[nI][3], &("SZN->ZN_BOTAO"+cBotP) ) 
		EndIf
	Next nI
EndIf
			       
For nI := 1 To Len(aProdsMaq)
	If aProdsMaq[nI][2] > 0     
		nCnt1 := 0
		nCnt2 := 0
		nConts := 0	
		If !Empty(aProdsMaq[nI][3])
			aSort( aProdsMaq[nI][3],,,{ |x,y| x < y })
			If Len(aProdsMaq[nI][3]) > 1   
				nCnt1 := aProdsMaq[nI][3][1]
				nCnt2 := aProdsMaq[nI][3][Len(aProdsMaq[nI][3])] 
				nConts := ABS( nCnt2-nCnt1 )
			Else
				nConts := aProdsMaq[nI][3][1]
			EndIf			
		EndIf
		If lVldCnt
			If nConts < ( nLimite * nDias )
				aProdsMaq[nI][4] := ( nConts * aProdsMaq[nI][2] )
				nQuant += aProdsMaq[nI][4]
			EndIf
		Else
			aProdsMaq[nI][4] := ( nConts * aProdsMaq[nI][2] )
			nQuant += aProdsMaq[nI][4]
		EndIf
	EndIf		
Next nI

aDetail := Aclone( aProdsMaq )
                                                                                                                     	

Return nQuant



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTFAT39C  บAutor  ณMicrosiga           บ Data ณ  09/16/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VendaBeb( cMaq, cProd, dEntAnt,dAtu,aDetail )

Local aCalc := {}
Local cQuery := ""
Local nQuant := 0
Local nI,nJ
Local aProdsMaq := {}
Local cBotP := ""
Local nCntAux := 0
Local nRecAnt := 0
Local lOrcam := .F.
Local nQtdIns := 0
Local nCnt1 := 0
Local nCnt2 := 0
Local nConts := 0
Local nLimite := SuperGetMV("MV_XFAT008",.T.,0) //300
Local lVldCnt := SuperGetMV("MV_XFAT009",.T.,.F.)
Local nDias := ( dAtu - dEntAnt )+1
Local nCnt := 0
Local dData := Stod("")

// produtos no mapa
cQuery := "SELECT * FROM SZH010 WHERE ZH_CHAPA = '"+cMaq+"' AND D_E_L_E_T_ = '' AND ZH_STATUS = '3' "
cQuery += " ORDER BY ZH_BANDEJA, ZH_MOLA"

MPSysOpenQuery( cQuery , "TRBZ" )

dbSelectArea("TRBZ")
While !EOF()
	AADD( aProdsMaq, { TRBZ->ZH_CODPROD,{},0 })	// produto | quantidade contadores | total consumo
	dbSkip()
End

If Empty( aProdsMaq )
	Return nQuant
EndIf

nCnt := 0

// SZN
cQuery  := "SELECT "		
For nI := 1 To 16//60                       
	cBotP := Padl( cvaltochar(nI),2,"0"  )
	cQuery += "ZN_BOTAO" +cBotP
	If nI <> 16//60
		cQuery += ","
	EndIf
Next nI

cQuery += " FROM " +RetSqlName("SZN")
cQuery += " WHERE "
cQuery += " ZN_PATRIMO = '"+cMaq+"' "
cQuery += " AND ZN_DATA BETWEEN '"+dtos(dEntAnt)+"' AND '"+dtos(dAtu)+"' AND ZN_VALIDA = 'O' AND ZN_TIPINCL IN ('ABASTEC','LEITURA CF', 'INSTALACAO', 'REMOCAO' ) "
cQuery += " ORDER BY ZN_DATA DESC, ZN_HORA DESC, ZN_NUMATU DESC "

MPSysOpenQuery( cQuery , "TRBZ" )
dbSelectArea("TRBZ")

If EOF()
	Return nQuant
EndIf
		
While !EOF()
	For nI := 1 To Len( aProdsMaq )
		cBotP := PadL( cvaltochar(nI),2,"0" )
		AADD( aProdsMaq[nI][2], &("TRBZ->ZN_BOTAO"+cBotP) )		
	Next nI
	TRBZ->(dbSkip())
End	
	
nCntAux := 0
nRecAnt := ZNCon(cMaq,dEntAnt)
If nRecAnt > 0
	dbSelectArea("SZN")
	dbGoTo(nRecAnt)
	For nI := 1 To Len(aProdsMaq)
		cBotP := Padl( cvaltochar(nI),2,"0"  )                                     
		AADD( aProdsMaq[nI][2], &("SZN->ZN_BOTAO"+cBotP) ) 
	Next nI
EndIf
			       
For nI := 1 To Len(aProdsMaq)
	nCnt1 := 0
	nCnt2 := 0
	nConts := 0	
	If !Empty(aProdsMaq[nI][2])
		aSort( aProdsMaq[nI][2],,,{ |x,y| x < y })
		If Len(aProdsMaq[nI][2]) > 1   
			nCnt1 := aProdsMaq[nI][2][1]
			nCnt2 := aProdsMaq[nI][2][Len(aProdsMaq[nI][2])] 
			nConts := ABS( nCnt2-nCnt1 )
		Else
			nConts := aProdsMaq[nI][2][1]
		EndIf			
	EndIf
	If lVldCnt
		If nConts < ( nLimite * nDias )
			aProdsMaq[nI][3] := nConts
			nQuant += aProdsMaq[nI][3]
		EndIf
	Else
		aProdsMaq[nI][3] := nConts
		nQuant += aProdsMaq[nI][3]
	EndIf		
Next nI

aDetail := Aclone( aProdsMaq )


Return nQuant



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfParCalc  บAutor  ณJackson E. de Deus  บ Data ณ  27/09/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fParCalc()

Local oExcel	:= FWMSEXCEL():New()
Local cPlanilha := "previsao_calculo.xml"
Local cProduto := ""
Local cDescProd := ""
Local cPatrimo := ""
Local cDescPAtr := ""
Local nCalc := 0
Local dData := stod("")
Local cDose := ""
Local nQtd_usa := 0
Local nQtd_Cont := 0
Local nTotInsumo := 0
Local aMaquinas := {}
Local aDetalhe := {}
Local aDatas := {}
Local aCont := {}
Local nI,nJ,nK,nL 
         
cDir := cGetFile(, OemToAnsi("Selecione o diret๓rio de destino"), 0, "C:\", .T., GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY, .F., .F.) 
If Empty(cDir)
	Aviso("TTCNTLOC","Escolha um diret๓rio vแlido.",{"Ok"})
	Return
EndIf


oExcel:AddworkSheet("Calculo")
oExcel:AddTable("Calculo","Insumos")
oExcel:AddColumn("Calculo","Insumos","Patrimonio",1,1)
oExcel:AddColumn("Calculo","Insumos","Modelo",1,1)    
oExcel:AddColumn("Calculo","Insumos","Produto",1,1)
oExcel:AddColumn("Calculo","Insumos","Desc. Produto",1,1)
oExcel:AddColumn("Calculo","Insumos","Total",1,2)    

oExcel:AddworkSheet("Calculo2")
oExcel:AddTable("Calculo2","Snacks")
oExcel:AddColumn("Calculo2","Snacks","Patrimonio",1,1)
oExcel:AddColumn("Calculo2","Snacks","Modelo",1,1)    
oExcel:AddColumn("Calculo2","Snacks","Produto",1,1)
oExcel:AddColumn("Calculo2","Snacks","Desc. Produto",1,1)
oExcel:AddColumn("Calculo2","Snacks","Total",1,2)

oExcel:AddworkSheet("Doses")
oExcel:AddTable("Doses","Insumos")
oExcel:AddColumn("Doses","Insumos","Patrimonio",1,1)
oExcel:AddColumn("Doses","Insumos","Modelo",1,1)    
oExcel:AddColumn("Doses","Insumos","Insumo",1,1)
oExcel:AddColumn("Doses","Insumos","Desc. Insumo",1,1)
oExcel:AddColumn("Doses","Insumos","Dose",1,1)
oExcel:AddColumn("Doses","Insumos","Desc. Dose",1,1)
oExcel:AddColumn("Doses","Insumos","Qtd Receita",1,2)   
oExcel:AddColumn("Doses","Insumos","Dia",1,4)
oExcel:AddColumn("Doses","Insumos","Qtd Contadores",1,2)
oExcel:AddColumn("Doses","Insumos","Qtd Consumo",1,2)

For nI := 1 To Len(_aMaquinas)
	cPatrimo := _aMaquinas[nI][1]  
	aProds := Aclone( _aMaquinas[nI][3] )					
	cModelo := Posicione( "SN1",2,xFilial("SN1") +AvKey(cPatrimo,"N1_CHAPA"),"N1_PRODUTO" )
	cDescModl := Posicione( "SB1",1,xFilial("SB1") +AvKey(cModelo,"B1_COD"),"B1_DESC" )
	cTipBeb := Posicione( "SB1",1, xFilial("SB1") +AvKey(cModelo,"B1_COD"),"B1_XFAMILI" )
	lBebida	:= cTipBeb $ "144/153"
	
	For nJ := 1 To Len(aProds)
		cProduto := aProds[nJ][1]
		nCalc := aProds[nJ][2]
		aDet := IIf( Len(aProds[nJ])>=3,Aclone( aProds[nJ][3] ),{} ) 
				
		If lBebida
			oExcel:AddRow("Calculo","Insumos",{cPatrimo,;
											cDescModl,;
											cProduto,;
											AllTrim(Posicione( "SB1",1,xFilial("SB1") +AvKey(cProduto,"B1_COD"),"B1_DESC" )),;
											nCalc})
																						
			// detalhamento doses
			If !Empty( aDet )
				For nK := 1 To Len( aDet )
					dDia := aDet[nK][1]
					aDoses := Aclone( aDet[nK][2] ) 
					For nL := 1 To Len( aDoses )        
						cDose := aDoses[nL][1]
						nQtdUsa := aDoses[nL][2]
						
						aCnt := Aclone( aDoses[nL][3] )
						nConts := 0
						If Len(aCnt) > 1
							nConts := aCnt[Len(aCnt)] - aCnt[1]
						EndIf
					
						nTot := aDoses[nL][4]
						
						// dose | qtd_insumo_usa | quantidade contadores | total consumo insumo				
						oExcel:AddRow("Doses","Insumos",{cPatrimo,;
														cDescModl,;
														cProduto,;
														AllTrim(Posicione( "SB1",1,xFilial("SB1") +AvKey(cProduto,"B1_COD"),"B1_DESC" )),;
														cDose,;
														AllTrim(Posicione( "SB1",1,xFilial("SB1") +AvKey(cDose,"B1_COD"),"B1_DESC" )),;
														nQtdUsa,;
														dDia,;
														nConts,;
														nTot})
					Next nL	
					
				Next nK
			EndIf
		
		Else
			oExcel:AddRow("Calculo2","Snacks",{cPatrimo,;
											cModelo,;
											cProduto,;
											AllTrim(Posicione( "SB1",1,xFilial("SB1") +AvKey(cProduto,"B1_COD"),"B1_DESC" )),;
											nCalc})	
		EndIf
	Next nJ				
Next nI 

		
oExcel:Activate()
oExcel:GetXMLFile(cDir+cPlanilha)

If File(cDir +cPlanilha)
	Aviso("TTFAT39C","A planilha foi gerada em "+UPPER(cDir) +CRLF +"Nome: "+cPlanilha,{"Ok"})
	If !ApOleClient( 'MsExcel' )
		Aviso("TTFAT39C", "MsExcel nใo instalado. " +CRLF +"O arquivo estแ em: "+cDir )
	Else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cDir +cPlanilha )
		oExcelApp:SetVisible(.T.)         
		oExcelApp:Destroy()
	EndIf
EndIf  

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณZNCon  บAutor  ณJackson E. de Deus     บ Data ณ  15/04/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ZNCon(cMaq,dEntAnt)

Local cQuery := ""      
Local nRecno := 0

cQuery := "SELECT TOP 1 R_E_C_N_O_ "
cQuery += " FROM " +RetSqlName("SZN")
cQuery += " WHERE ZN_PATRIMO = '"+cMaq+"' "
cQuery += " AND ZN_DATA < '"+dtos(dEntAnt)+"' AND D_E_L_E_T_ = '' AND ZN_VALIDA = 'O' AND ZN_TIPINCL IN ('ABASTEC','LEITURA CF', 'INSTALACAO', 'REMOCAO' ) "
cQuery += " ORDER BY ZN_DATA DESC, ZN_HORA DESC, ZN_NUMATU DESC "

MPSysOpenQuery( cQuery , "TRB" )

dbSelectArea("TRB")

If !EOF()
	nRecno := TRB->R_E_C_N_O_
EndIf


Return nRecno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGravar  บAutor  ณJackson E. de Deus    บ Data ณ  16/02/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Grava as alteracoes na tabela SZO					      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Gravar(aDados)
      
Local lRet	:=	.T. 
Local cTipE	:=	_cTpEst	//If(aList[nPos,06]=="Carga Seca","CS",If(aList[nPos,06]=="Lanche","LC",If(Substr(aList[nPos,06],1,5)=="Refri","RI","UC")))
Local lFim	:=	.F.


dbSelectArea("SZO")
For nLinha := 1 To Len(aDados)
	// Alteracao  
	If nLinha <= Len(_aRecnos)
		dbGoTo(_aRecnos[nLinha])
		If RecLock("SZO",.F.)  
			// Exclusao
			If aDados[nLinha][Len(aHeader)+1]
				SZO->( dbDelete() )
				
			// Alteracao
			Else
				For nCol := 1 To Len(aHeader)
					//nPos := 0
					//nPos := aScan( _aAlter, { |x|, AllTrim(x) == AllTrim(aHeader[nCol][2]) } )
					//If nPos > 0
						nNrCampo := FieldPos(Trim(aHeader[nCol][2]))
						FieldPut(nNrCampo, aDados[nLinha][nCol])
					//EndIf
				Next nCol
			EndIf    
			SZO->( MsUnlock() )
		EndIf
		
	// Inclusao
	Else
		If RecLock("SZO",.T.)
			SZO->ZO_FILIAL	:=  xFilial("SZO")
			SZO->ZO_CODPA	:= _cArmazem		
			SZO->ZO_HORA	:= SubStr(Time(),1,5)
			SZO->ZO_USUARIO	:= cUserName
			SZO->ZO_FINAL	:= If(lFim,"S","")
		  	SZO->ZO_DATEMIS	:= dDatabase
			For nCol := 1 To Len(aHeader)
				nNrCampo := FieldPos(Trim(aHeader[nCol][2]))
				If nNrCampo > 0
					FieldPut(nNrCampo, aDados[nLinha][nCol])
				EndIf
			Next nCol
			SZO->( MsUnlock() )
		EndIf
	EndIf
Next nI


Return        


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGerarPV  บAutor  ณJackson E. de Deus   บ Data ณ  16/02/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera o pedido de venda	                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GerarPV()

Local cQuery
Local cNumPed	:= ""
Local aBlq		:= {}
Local aArea		:= GetArea()
Local cLocE		:= ""
Local cTabelaZ	:= Posicione("ZZ1",1,xFilial("ZZ1")+_cArmazem,"ZZ1_TAB_LA")
Local cTab		:= Space(3)
Local cTes		:= Space(3)
Local nPreco	:= 0     
Local aTES		:= {}	
Local lAjusTES	:= .F.
Local cTpCli	:= "F"
Local cxFinal	:= "4"
Local cEPP    	:= Posicione("SA1",1,xFilial("SA1")+"00000100"+cFilAnt,"A1_XEPP")
Local cOpera	:= U_TTOPERA("PCA",cTpCli,cxFinal,cEPP) 
Local cItem		:= "00"
Local cItemCC	:= Posicione("ZZ1",1,xFilial("ZZ1")+_cArmazem,"ZZ1_ITCONT")
Local cProd		:= ""
Local cLocal	:= ""
Local nPosQtd	:= Ascan( aHeader, { |x| AllTrim(x[2]) == "ZO_QTDPED" } )
Local aDadosWS	:= {}
Local cMsgErro	:= ""
Local axItens	:= {}
Local aItensDs	:= {}
Local aItensIv	:= {}
Local nI, nJ
Local aEst		:= {}
Local nSaldo	:= 0
Local cArmazem	:= ""
Local nQtdPed	:= 0
Local oTelaProds:= Nil
Local oListP	:= Nil
Local oSize		:= Nil 
Local cDescProd := ""
Private aCabec	:= {}
Private aItens	:= {}  
Private	lMsErroAuto	:=	.F.
                                    

If Empty(_cNumOS) .And. !_lRota
	MsgAlert("Ainda nใo foi criada a Ordem de servi็o para a contagem!")
	Return
Else
	dbSelectArea("SZG")
	dbSetOrder(1)
	If MSSeek( xFilial("SZG") +avKey(_cNumOS,"ZG_NUMOS") )
		If SZG->ZG_STATUS $ "COPE|CTEC|CCLI"
			MsgAlert("A Ordem de servi็o foi cancelada! ษ necessแrio fazer a contagem do estoque antes de emitir um novo pedido.")
			Return
		EndIf     
		If AllTrim(SZG->ZG_STATUS) <> "FIOK" 
			MsgAlert("A Ordem de servi็o ainda nใo foi finalizada! ")
			Return
		EndIf
	EndIf	
EndIf


cNumPed := GetSx8Num("SC5","C5_NUM")
                      
If xFilial("SC5") <> "01"     
	If !Empty(cTabelaZ)
		cTab := cTabelaZ
	Else
		cTab := "YXG"
	EndIf
EndIf                        

acols := aclone(oList2:aCols)

// ver produtos que possem nao saldo
For nLinha := 1 To Len(aCols)
	If aCols[nLinha][Len(aHeader)+1]
		Loop
	EndIf
	       
	cProd := aCols[nLinha][1]
	cDescProd := AllTrim(aCols[nLinha][2])
	nQtdPed := aCols[nLinha][nPosQtd]
	cArmazem := Posicione( "SB1",1,xFilial("SB1")+AvKey(cProd,"B1_COD"),"B1_LOCPAD" )
	nSaldo := 0
	
	If !Empty( cArmazem )
		dbSelectArea("SB2")
		dbSetOrder(2)
		If MSSeek( xFilial("SB2") +AvKey(cArmazem,"B2_LOCAL") +AvKey(cProd,"B2_COD") )
			nSaldo := ( SB2->B2_QATU - SB2->B2_RESERVA )
		EndIf

		If nSaldo < nQtdPed
			AADD( aEst, { cProd +" - " +cDescProd, cArmazem, nQtdPed, nSaldo } )
		EndIf
	EndIf	
Next nLinha

If !Empty( aEst )
	MsgInfo("Alguns produtos nใo possuem saldo suficiente para o faturamento.")
	 
	oTelaProds := MSDialog():New( 0,0,300,600,"Saldo insuficiente",,,.F.,,,,,,.T.,,,.T. )
    
	    oListP := TCBrowse():New(0,0,0,0,,,,oTelaProds,,,,,{ ||  },,,,,,,.F.,,.T.,,.F.,,.T.,.F.) 
	    
		oListP:SetArray(aEst)
		oListP:AddColumn(TCColumn():New("Produto"			,{|| aEst[oListP:nAt][1] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))	                                                                                                          	
		oListP:AddColumn(TCColumn():New("Armazem"			,{|| aEst[oListP:nAt][2] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))	                                                                                                          	
		oListP:AddColumn(TCColumn():New("Qtd solicitada"	,{|| aEst[oListP:nAt][3] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))
	    oListP:AddColumn(TCColumn():New("Qtd disponํvel"	,{|| aEst[oListP:nAt][4] },"@!",,,'LEFT',,.F.,.F.,,,,.F.,))         	
	
		oListP:Align := CONTROL_ALIGN_ALLCLIENT
      		
	oTelaProds:Activate(,,,.T.)

	If !MsgYesNo( "Deseja prosseguir com as mesmas quantidades?" ) 
		Return
	EndIf	
EndIf


For nLinha := 1 To Len(aCols)
	If aCols[nLinha][Len(aHeader)+1]
		Loop
	EndIf
	
	// TES
	AADD( aTES, { aCols[nLinha][1], "" } )
	
	// verifique produto bloqueado
	dbSelectArea("SB1")
	dbSetOrder(1)
	If dbSeek( xFilial("SB1") +AvKey(aCols[nLinha][1],"B1_COD") )
		If AllTrim(SB1->B1_MSBLQL) == "1"
			If RecLock("SB1",.F.)
				SB1->B1_MSBLQL := "2"
				SB1->(MsUnLock())
			EndIf
			
			AADD( aBlq, Recno() )
		EndIf
	EndIf
Next nLinha


dbSelectArea("SB2")
dbSetOrder(1)
For nI := 1 To Len(aTES) 
	cTes := MaTesInt(2,cOpera,"000001","00"+cFilAnt,"C",aTES[nI][1],"C6_TES")
	If Empty(cTes)
		lAjusTES := .T.
		aTES[nI][2] := Space(3)
	Else
		aTES[nI][2] := cTes
	EndIf	
Next nI

If lAjusTES
	aTES := U_TTFAT26C( aTES )
EndIf


For nLinha := 1 To Len(aCols)
	If aCols[nLinha][Len(aHeader)+1]
		Loop
	EndIf
	
	nQtd := aCols[nLinha][nPosQtd]	
	If nQtd == 0
		Loop
	EndIf
	
	cProd := aCols[nLinha][1]
	cLocal := Posicione("SB1",1,xFilial("SB1") +AvKey(cProd,"B1_COD"), "B1_LOCPAD")
	cItem := Soma1(cItem)   
	cTes := ""
	
	
	If Empty(cTab)
		nPreco := Posicione("SB1",1,xFilial("SB1") +AvKey(cProd,"B1_COD"), "B1_CUSTD")	
	Else
		nPreco := Posicione("DA1",1,xFilial("DA1") +AvKey(cTab,"DA1_CODTAB") +AvKey(cProd,"DA1_CODPRO"), "DA1_PRCVEN" )	
	EndIf
		
	For nI := 1 To Len(aTes)
		If aTes[nI][1] == cProd
			cTes := aTes[nI][2]
			Exit
		EndIf
	Next nI

	Aadd(aItens,{{"C6_FILIAL"		, xFilial("SC6")	 		,Nil},;
					{"C6_NUM"		, cNumPed 					,Nil},; 
					{"C6_ITEM"		, cItem 					,Nil},; 
					{"C6_PRODUTO"	, cProd			 			,Nil},;
					{"C6_XPRDORI"	, cProd			 			,Nil},;
					{"C6_QTDVEN"	, nQtd			 			,Nil},;
					{"C6_XQTDORI"	, nQtd						,Nil},;
					{"C6_TPOP"		, "F" 						,Nil},;				
					{"C6_PRCVEN"	, Round(nPreco,TamSx3("C6_PRCVEN")[1])	  		,Nil},;
					{"C6_VALOR"		, Round(nPreco*nQtd,TamSx3("C6_VALOR")[1])		,Nil},;
					{"C6_PRUNIT"	, Round(nPreco,TamSx3("C6_PRUNIT")[1])			,Nil},;
					{"C6_TES"		, cTes 			   			,Nil},;
					{"C6_CLI"		, "000001"		 			,Nil},;
					{"C6_LOJA"		, Strzero(val(cFilAnt),4)	,Nil},;
					{"C6_LOCAL"		, cLocal				 	,Nil},;
					{"C6_CCUSTO"	, "70500002" 				,Nil},;
					{"C6_ITEMCC"	, cItemCC					,Nil},;
					{"C6_XGPV"		, "PCA"			 			,Nil},;
					{"C6_ENTREG"	, _dEntAtu					,Nil},;
					{"C6_XDTEORI"	, _dEntAtu		 			,Nil},;
					{"C6_XHRINC"	, Time() 					,Nil},;
					{"C6_XDATINC"	, Date()		 			,Nil},;
					{"C6_XUSRINC"	, cUsername 	 			,Nil}})
Next nLinha


Aadd(aCabec,{"C5_FILIAL"	, xFilial("SC5") 			,Nil})
Aadd(aCabec,{"C5_NUM"		, cNumPed 					,Nil})
Aadd(aCabec,{"C5_TIPO"		, "N"			 			,Nil})
Aadd(aCabec,{"C5_CLIENTE"	, "000001"		 			,Nil})
Aadd(aCabec,{"C5_LOJACLI"	, Strzero(val(cfilant),4)	,Nil})
Aadd(aCabec,{"C5_CLIENT"	, "000001"					,Nil})
Aadd(aCabec,{"C5_LOJAENT"	, Strzero(val(cfilant),4)	,Nil})
Aadd(aCabec,{"C5_XIDPCA"	, ""   						,Nil})
Aadd(aCabec,{"C5_XDTENTR"	, _dEntAtu					,Nil})
Aadd(aCabec,{"C5_XNFABAS"	, "1"			 			,Nil})
Aadd(aCabec,{"C5_XCODPA"	, _cArmazem					,Nil})
Aadd(aCabec,{"C5_XFINAL"	, "4"			 			,Nil})
Aadd(aCabec,{"C5_XFLDEST"	, ""			   			,Nil})
Aadd(aCabec,{"C5_TRANSP"	, "000019"		 			,Nil})
Aadd(aCabec,{"C5_XTPCARG"	, ""			 			,Nil})
Aadd(aCabec,{"C5_XHRPREV"	, "00:00"		 			,Nil})
Aadd(aCabec,{"C5_CONDPAG"	, "001"			 			,Nil})
Aadd(aCabec,{"C5_TABELA"	, cTab			 			,Nil})
Aadd(aCabec,{"C5_XCCUSTO"	, "70500002"			   	,Nil})
Aadd(aCabec,{"C5_XITEMCC"	, cItemCC					,Nil})
Aadd(aCabec,{"C5_MOEDA"		, 1 						,Nil})
Aadd(aCabec,{"C5_FRETE"		, 0 						,Nil})
Aadd(aCabec,{"C5_TXMOEDA"	, 1 						,Nil})
Aadd(aCabec,{"C5_EMISSAO"	, ddatabase		 			,Nil})
Aadd(aCabec,{"C5_XGPV"		, "PCA"			 			,Nil})
Aadd(aCabec,{"C5_MENNOTA"	, "" 						,Nil})
Aadd(aCabec,{"C5_ESPECI1"	, "UN"	 		  			,Nil})
Aadd(aCabec,{"C5_XHRINC" 	, TIME()					,Nil})
Aadd(aCabec,{"C5_XDATINC"	, Date()					,Nil})
Aadd(aCabec,{"C5_XLOCAL" 	, cLocE						,Nil})
Aadd(aCabec,{"C5_XNOMUSR"	, cUserName 				,Nil})
Aadd(aCabec,{"C5_XCODUSR"	, __cUserId 		   		,Nil})
Aadd(aCabec,{"C5_TPFRETE"	, "C" 						,Nil})
Aadd(aCabec,{"C5_TIPOCLI"	, "F" 						,Nil})
Aadd(aCabec,{"C5_TIPLIB" 	, "1"			  			,Nil})
Aadd(aCabec,{"C5_VEND1"  	, "000001" 		  			,Nil})
Aadd(aCabec,{"C5_XTPPAG" 	, ""			  			,Nil})

	
MsExecAuto({|x, y, z| MATA410(x, y, z)}, aCabec, aItens, 3)                    

dbSelectArea("SC5")
dbSetOrder(1)
If MSSeek( xFilial("SC5") +AvKey(cNumPed,"C5_NUM") )
	ConfirmSX8()	

	dbSelectArea("SZO")
	For nLinha := 1 To Len(_aRecnos)
		dbGoTo(_aRecnos[nLinha]) 
		RecLock("SZO",.F.)
		SZO->ZO_PEDIDO := cNumPed
		MsUnLock()
	Next nLinha
	
	// altera status
	dbSelectArea("TRB1")
	RecLock("TRB1",.F.)
		TRB1->STATUS := "BR_VERDE"
	MsUnLock()
	                 
	MsgInfo("Pedido gerado! " +cNumPed)	
	
 	// Processa o inventario do ARMAZEM
 	If !_lRota              
		dbSelectArea("SZG")
		dbSetOrder(1)
		If MSSeek( xFilial("SZG") +avKey(_cNumOS,"ZG_NUMOS") )
			If Empty(SZG->ZG_PROC)
				aDadosWS := U_MXML000(SZG->ZG_RESPOST)
				For nI := 1 To Len(aDadosWS)          
					If aDadosWS[nI][1] == "INVENTARIO"
						For nJ := 2 To Len(aDadosWS[nI])
							AADD( axItens, ACLONE(aDadosWS[nI][nJ]) )
						Next nJ
					EndIf	
				Next nI
				For nI := 1 To Len(axItens)	// verificar
					AADD( aItensIv, { axitens[nI][1][2], Val(axItens[nI][2][2]) } )
					AADD( aItensDs, { axitens[nI][1][2], Val(axItens[nI][3][2]) } )
				Next nI
					
				If !Empty(aItensIv)
					// zera armazem
					MsAguarde({ || StaticCall( TTPROC57, Invent, _cArmA ) },"Ajustando estoque..")
					
					// ajusta saldo novo
					MsAguarde({ || StaticCall( TTPROC57, Invent, _cArmA,3, aItensIv ) },"Ajustando estoque..")
											
					If AllTrim(SZG->ZG_NUMOS) == _cNumOS
						RecLock("SZG",.F.)
						SZG->ZG_PROC := "BR_VERDE"
						MsUnLock()
					EndIf				
				EndIf
			EndIf
		EndIf
	EndIf
Else
	If lMsErroAuto
		MostraErro()  
	EndIf
	RollBackSX8()
EndIf	

                   
If !Empty(aBlq)
	dbSelectArea("SB1")
	For nI := 1 To Len(aBlq)
		dbGoTo(aBlq[nI])
		If Recno() == aBlq[nI]
			If RecLock("SB1",.F.)
				SB1->B1_MSBLQL := "1"
				SB1->(MSUNLOCK())
			EndIf
		EndIf
	Next nI       
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPVDesc  บAutor  ณJackson E. de Deus    บ Data ณ  18/02/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera o pedido de descarte                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PVDesc()
                  

Local aItens := {}
Local nPosProd	:= Ascan( aHeader, { |x| AllTrim(x[2]) == "ZO_CODPRO" } )
Local nPosAVar	:= Ascan( aHeader, { |x| AllTrim(x[2]) == "ZO_QAVAR" } )
Local nI
Local cNumPed	:= ""

aCols := aclone( oList2:Acols )
For nI := 1 To Len(aCols)
	If aCols[nI][Len(aHeader)+1]
		Loop
	EndIf
	
	If aCols[nI][nPosAvar] > 0
		AADD( aItens, { aCols[nI][nPosProd], aCols[nI][nPosAvar] } )
	EndIf
Next nI

If !Empty(aItens)
	cNumPed := STATICCALL( TTPROC25, GeraPedido,"000001",Strzero(val(cFilAnt),4),_cArmazem,_cNumOs,aItens )
	If !Empty(cNumPed)
		MsgInfo("Pedido de descarte gerado: " +cNumPed)
	EndIf
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDescDif  บAutor  ณJackson E. de Deus   บ Data ณ  30/03/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Desconto da diferenca                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function DescDif()

Local aItens := {}
Local nPosProd	:= Ascan( aHeader, { |x| AllTrim(x[2]) == "ZO_CODPRO" } )
Local nPosDProd := 2	//Ascan( aHeader, { |x| AllTrim(x[2]) == "ZO_CODPRO" } )
Local nPosDiff	:= Ascan( aHeader, { |x| AllTrim(x[2]) == "ZO_QDIFF" } )
Local nI                            
Local nItem := 0                  
Local nQtd := 0
Local nCustD := 0
Local nTot := 0
Local aAux := aclone( oList2:Acols )

If _lInvOk
	For nI := 1 To Len(aAux)
		If aAux[nI][Len(aHeader)+1]
		//	Loop
		EndIf
		
		If ( aAux[nI][nPosDiff] < 0 )
			nItem++
			nQtd := ABS(aAux[nI][nPosDiff])
			nCustd := Posicione("SB1",1,xFilial("SB1") +avKey(aAux[nI][nPosProd],"B1_COD"),"B1_CUSTD")
			nTot := Round( nQtd * nCustd,2 )
			AADD( aItens, { cvaltochar(nItem),;
							 nQtd,;
							 aAux[nI][nPosProd],;
							 aAux[nI][nPosDProd],;
							 nTot,;
							 nCustD  } )
		EndIf
	Next nI
EndIf


/*
axItens
1 = item
2 = qtd
3 = cod prod
4 = desc prod
5 = vl tot
6 = vl unit
*/
If !Empty(aItens)
	RelDscto(_cAtend,dDatabase,aItens)
EndIf	
	  

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRelDscto  บAutor  ณJackson E. de Deus  บ Data ณ  30/03/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RelDscto(cAtendente,dData,axItens)

Local oPrint
Local cNomeResp := AllTrim( Posicione("AA1",1,xFilial("AA1") +AvKey(cAtendente,"AA1_CODTEC"), "AA1_NOMTEC") ) 
Local cCpf		:= ""
Local cRg 		:= ""
Local cEmp		:= AllTrim( Posicione("AA1",1,xFilial("AA1") +AvKey(cAtendente,"AA1_CODTEC"), "AA1_XEMPRE") ) 
Local clEmpres	:= ""
Local nTotal	:= 0
Local nI

	
Private nColIni		:= 40
Private nColIni2	:= 70                   
Private nLin		:= 25
Private nColFim		:= 2400
Private nColFim2	:= 2360  

oFont1 := TFont():New('Arial',,-25,.T.,.T.)
oFont2 := TFont():New('Arial',,-15,.T.,.T.)
oFont3 := TFont():New('Arial',,-15,.T.,.F.)
oFont4 := TFont():New('Arial',,-20,.T.,.T.)
oFont5 := TFont():New('Courier new',,-10,.T.,.T.)                                                            
oFont6 := TFont():New('Courier new',,-10,.T.,.F.)       


ChkDoc(cAtendente,cEmp,@cCpf,@cRG)


If cEmp == "01"
	clEmpres := "TOK TAKE"   
ElseIf cEmp == "02"  
	clEmpres := "LUXOR"
ElseIf cEmp == "03"
	clEmpres := "MC"	
ElseIf cEmp == "04"
	clEmpres := "MA"	
ElseIf cEmp == "05" 
	clEmpres := "CAFE PILOTO"	
ElseIf cEmp == "06" 
	clEmpres := "ACROBAT"	
ElseIf cEmp == "10"
	clEmpres := "MAQUINA DE CAFE"	
ElseIf cEmp == "12"
	clEmpres := "MHJ"	
ElseIf cEmp == "13"
	clEmpres := "MKL"	
EndIf


oPrint := TMSPrinter():New("Autoriza็ใo de desconto")  
oPrint:SetPortrait()  
oPrint:SetPaperSize(9)
oPrint:Setup()     
oPrint:StartPage()  


For nI := 1 to Len( axItens )
	nTotal += axItens[nI][5]
Next nI

nLin := 200
oPrint:Say(nLin,nColIni2+1100,"AUTORIZAวรO DE DESCONTO EM FOLHA DE PAGAMENTO",oFont5,300,CLR_BLACK )
nLin += 150  
			 
oPrint:Say(nLin,nColIni2+100, "Eu, "+ cNomeResp +",portador do RG :"+ cRg +",CPF :"+ cCpf +", Matrํcula :"+ cAtendente +", funcionแrio da Empresa "+ clEmpres,oFont6,1400,CLR_BLACK )                                                                 	
nLin += 60   

oPrint:Say(nLin,nColIni2+100, "autorizo o desconto em folha de pagamento, no valor total de R$ "+ Alltrim( TransForm(nTotal,PesqPict("SF2","F2_VALBRUT") )) +" , em _____ parcelas, referente เ diferen็a na distribui็ใo de produtos.",oFont6,1400,CLR_BLACK )                                                                 	
nLin += 150   

//oPrint:Say(nLin,nColIni2+100, "Nota fiscal: " +cNumNF +"/" +cSerie,oFont6,1400,CLR_BLACK )                                                                 	
//nLin += 60 

//oPrint:Say(nLin,nColIni2+100, "Data de emissใo: "+dtoc(dDtEmissao),oFont6,1400,CLR_BLACK )
//nLin += 60                                                       	                                        

oPrint:Say(nLin,nColIni2+100, "Data da ocorr๊ncia:  "+ Dtoc(dData),oFont6,1400,CLR_BLACK )
nLin += 200                                                       	                                        

oPrint:Say(nLin,nColIni2+1100, "PRODUTOS QUE SE ENCONTRAM COM DIVERGสNCIA NESSE ARMAZษM",oFont6,1400,CLR_BLACK )
nLin += 50                                                       	                                         
oPrint:Say(nLin,nColIni2+1100, "----------------------------------------------------",oFont6,1400,CLR_BLACK )

nLin += 60 

oPrint:Say(nLin,nColIni2+100, "PRODUTO", oFont6,200,CLR_BLACK )
oPrint:Say(nLin,nColIni2+500, "DESCRIวรO", oFont6,200,CLR_BLACK )
oPrint:Say(nLin,nColIni2+1500, "QTD", oFont6,200,CLR_BLACK )
oPrint:Say(nLin,nColIni2+1700, "VALOR UNITARIO", oFont6,200,CLR_BLACK )
oPrint:Say(nLin,nColIni2+2200, "VALOR TOTAL", oFont6,200,CLR_BLACK )
nLin += 60 

oPrint:Line( nLin,nColIni2+100,nLin,nColFim+200 )
nLin += 20 

// item diferenca produto descricao valor 
For nI := 1 to Len( axItens )
	If nLin >= 2300
		oPrint:Say(nLin,nColIni2+2000, "CONTINUA PROX PAG. ---> ", oFont6,200,CLR_BLACK )
		oPrint:EndPage()             
  		oPrint:StartPage()

  		oPrint:Say(nLin,nColIni2+1200,"AUTORIZAวรO DE DESCONTO EM FOLHA DE PAGAMENTO",oFont5,300,CLR_BLACK )                  
  		nLin += 150
  		oPrint:Say(nLin,nColIni2+100, "PRODUTO", oFont6,200,CLR_BLACK )
		oPrint:Say(nLin,nColIni2+500, "DESCRIวรO", oFont6,200,CLR_BLACK )
		oPrint:Say(nLin,nColIni2+1500, "QTD", oFont6,200,CLR_BLACK )
		oPrint:Say(nLin,nColIni2+1700, "VALOR UNITARIO", oFont6,200,CLR_BLACK )
		oPrint:Say(nLin,nColIni2+2200, "VALOR TOTAL", oFont6,200,CLR_BLACK )
		nLin += 60 
		
		oPrint:Line( nLin,nColIni2+100,nLin,nColFim+200 )
		nLin += 20 
	EndIf
	
	oPrint:Say(nLin,nColIni2+100, axItens[nI][3] , oFont6,200,CLR_BLACK )
	oPrint:Say(nLin,nColIni2+500, axItens[nI][4], oFont6,200,CLR_BLACK )
	oPrint:Say(nLin,nColIni2+1500, CVALTOCHAR(axItens[nI][2]), oFont6,200,CLR_BLACK )
	oPrint:Say(nLin,nColIni2+1700, Transform( axItens[nI][6], PesqPict("SF2","F2_VALBRUT") ), oFont6,200,CLR_BLACK )
	oPrint:Say(nLin,nColIni2+2200, Transform( axItens[nI][5], PesqPict("SF2","F2_VALBRUT") ), oFont6,200,CLR_BLACK )
	nLin += 30
Next nI
nLin += 20
	
oPrint:Line( nLin,nColIni2+100,nLin,nColFim+200 )
nLin += 50 

oPrint:Say(nLin,nColIni2+100, "TOTAL A DESCONTAR R$ ", oFont6,200,CLR_BLACK )
oPrint:Say(nLin,nColIni2+2200, Transform(nTotal,PesqPict("SF2","F2_VALBRUT")), oFont6,200,CLR_BLACK )
nLin += 50 

oPrint:Line( nLin,nColIni2+100,nLin,nColFim+200 )
   	 
// rodape 	
RelRoda(@oPrint)
     
oPrint:Preview() 

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRelRoda  บAutor  ณJackson E. de Deus   บ Data ณ  01/04/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rodape do relatorio                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RelRoda(oPrint)

If nLin < 2300
	nLin := 2300
EndIf

oPrint:Line( nLin,nColIni2+2100,nLin,nColFim+500 )
nLin += 10

oPrint:Say(nLin,nColIni2+100, "Responsแvel pela apura็ใo : " +UsrFullName(__cUserID) , oFont6,200,CLR_BLACK )
oPrint:Say(nLin,nColIni2+2200, "Assinatura do funcionแrio" , oFont6,200,CLR_BLACK )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkDoc  บAutor  ณJackson E. de Deus    บ Data ณ  30/03/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkDoc(cAtendente,cEmp,cCpf,cRG)

Local cQuery := ""

If Empty(cEmp)
	Return
EndIf

cQuery := "SELECT RA_CIC, RA_RG FROM SRA" +cEmp +"0"
cQuery += " WHERE RA_MAT = '"+cAtendente+"' "

MPSysOpenQuery( cQuery , "TRBA" )   

dbSelectArea("TRBA")
cCpf := AllTrim(TRBA->RA_CIC)
cRg := AllTrim(TRBA->RA_RG)

dbCloseArea()

Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTab  บAutor  ณJackson E. de Deus       บ Data ณ  25/10/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria a tabela PICKLIST                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Tab()

Local aCampos := {{"MAQUINA","C",6,0},;
					{"POSICAO","C",3,0},;
					{"PRODUTO","C",15,0},;
					{"QUANT","N",6,2},;    
					{"DIA","D",8,0}} 


DbCreate( "PICKLIST",aCampos,"TOPCONN" ) 

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGravaPick  บAutor  ณJackson E. de Deus บ Data ณ  25/10/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Grava o Pick                                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GravaPick()

Local nI,nJ,nK,nL 
     
If !TCCanOpen("PICKLIST")
	Tab()       
EndIf


If Select("TRBP") > 0
	TRBP->(dbCloseArea())
EndIf

// snacks
DbUseArea(.T., "TOPCONN", "PICKLIST", "TRBP", .T., .F.) 
//Index On MAQUINA TO "TRBM"

DbSelectArea("TRBP") 


For nI := 1 To Len(_aMaquinas)
	cPatrimo := _aMaquinas[nI][1]
	aProds := Aclone( _aMaquinas[nI][3] ) 
	
	cModelo := Posicione( "SN1",2,xFilial("SN1") +AvKey(cPatrimo,"N1_CHAPA"),"N1_PRODUTO" )
	cTipBeb := Posicione( "SB1",1, xFilial("SB1") +AvKey(cModelo,"B1_COD"),"B1_XFAMILI" )
	lBebida	:= cTipBeb $ "144/153"				
	                 
	
	For nJ := 1 To Len(aProds)
		cProduto := aProds[nJ][1]
		nCalc := aProds[nJ][2]
		
		// rota - gravar a projecao
		If _cTpRota == "CAFE"
			nCalc := (nCalc/7)*7
		EndIf
				       
		nRecM := FoundM( cPatrimo,cProduto,_dEntAtu )
		DbSelectArea("TRBP") 	
		If nRecM == 0
			RecLock("TRBP",.T.)
			TRBP->MAQUINA := cPatrimo
			TRBP->PRODUTO := cProduto
			TRBP->QUANT	  := Arred( nCalc )
			TRBP->DIA	  := _dEntAtu
		Else           
			dbGoTo(nRecM)
			RecLock("TRBP",.F.)
			TRBP->QUANT	  := Arred( nCalc )
		EndIf
		
		MsUnLock()				
	Next nJ				
Next nI                         


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFoundM  บAutor  ณJackson E. de Deus    บ Data ณ  31/10/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Procura o RECNO do registro na tabela PICKLIST             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FoundM( cMaquina,cProduto,dDia )	

Local nRec := 0
Local cQuery := ""
Local aArea := GetArea()

cQuery := "SELECT R_E_C_N_O_ MAQREQ FROM PICKLIST "
cQuery += " WHERE MAQUINA = '"+cMaquina+"' AND PRODUTO = '"+cProduto+"' AND DIA = '"+DTOS(dDia)+"' "
cQuery += " AND D_E_L_E_T_ = '' "

MPSysOpenQuery( cQuery , "TRBR" )

dbSelectArea("TRBR")
nRec := TRBR->MAQREQ  

dbCloseArea()

RestArea(aArea)

Return nRec