#include "TOPCONN.CH"
#include "PROTHEUS.CH"  
#include "FWMVCDEF.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Z07Tela  ºAutor  ³Jackson E. de Deus  º Data ³  18/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Mapa de maquina                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Z07Tela()

Local oBrowse
Private cCadastro := "Mapa de máquina"

oBrowse := FWMBrowse():New()
oBrowse:SetAlias("Z07")
oBrowse:SetDescription(cCadastro)
             
//oBrowse:SetFilterDefault("Z07_MSBLQL<>'1'")
oBrowse:AddLegend("Z07_STATUS=='1'","BLACK","Desativado")
oBrowse:AddLegend("Z07_STATUS=='2'","WHITE","Aguardando aprov.")
oBrowse:AddLegend("Z07_STATUS=='3'","GREEN","Ativo")

oBrowse:Activate()

Return
                   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MenuDef  ºAutor  ³Jackson E. de Deus   º Data ³  15/12/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Menu do browse                                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MenuDef()

Local aRotina := {} 
// Local cAlias := "Z07"

ADD OPTION aRotina TITLE 'Pesquisar'  ACTION "PesqBrw"                         OPERATION 1 ACCESS 0
ADD OPTION aRotina TITLE 'Visualizar' ACTION "STATICCALL( Z07Tela, Manut, 2 )" OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Incluir'    ACTION "STATICCALL( Z07Tela, Manut, 3 )" OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'    ACTION "STATICCALL( Z07Tela, Manut, 4 )" OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE 'Excluir'    ACTION "STATICCALL( Z07Tela, Manut, 5 )" OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE 'Revisao'    ACTION "STATICCALL( Z07Tela, Manut, 6 )" OPERATION 6 ACCESS 0
ADD OPTION aRotina TITLE 'Aprovar'    ACTION "STATICCALL( Z07Tela, Aprov, 7 )" OPERATION 7 ACCESS 0

Return(aRotina)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Aprov  ºAutor  ³Jackson E. de Deus     º Data ³  12/08/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Aprova o mapa                                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Aprov()

Local aArea        := GetArea()                                                          
Local cPatrimo     := Z07->Z07_CHAPA
Local cCodCli      := Z07->Z07_CLIENTE
Local cLoja        := Z07->Z07_LOJA
Local cVersao      := Z07->Z07_VERSAO
// Local cVerOld    := ""

If MsgYesNo("É necessário conferir as molas antes de aprovar. Você já conferiu?")
    // desativa mapa atual ativo
    If Val(cVersao) >= 1        
        cQuery := "UPDATE "+RetSqlName("Z07")
        cQuery += " SET Z07_STATUS = '1', Z07_MSBLQL = '1' "
        cQuery += " WHERE Z07_CHAPA = '"+cPatrimo+"' AND Z07_VERSAO <> '"+cVersao+"' " //AND Z07_CLIENTE = '"+cCodCli+"' AND Z07_LOJA = '"+cLoja+"' " - Alteração realizada por Ronaldo G. de Jesus - 07/02/2017
        
        nExec := TCSQLExec(cQuery)
        If nExec < 0
            MsgAlert( "ERRO " +CRLF + TCSQLError() )
        EndIf
    EndIf
        
    // aprovacao da nova versao
    cQuery := "UPDATE "+RetSqlName("Z07")
    cQuery += " SET Z07_STATUS = '3', Z07_DINICIO = '"+dtos(Date())+"' "
    cQuery += " WHERE Z07_CHAPA = '"+cPatrimo+"' AND Z07_VERSAO = '"+cVersao+"' AND Z07_CLIENTE = '"+cCodCli+"' AND Z07_LOJA = '"+cLoja+"' "
    
    nExec := TCSQLExec(cQuery)
    If nExec < 0
        MsgInfo( "ERRO " +CRLF + TCSQLError() )
    Else
        MsgInfo("Mapa aprovado!")    
    EndIf    
EndIf

RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Manut  ºAutor  ³Jackson E. de Deus     º Data ³  26/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Manutencao do cadastro de mapa                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Manut(nOpc)

Local oWindow
Local lOk             :=    .F.
Local aSize           :=    MsAdvSize()                 
// Local aCpoZ07        :   = { "NOUSER","Z07_CHAPA", "Z07_CODMAQ", "Z07_CLIENTE", "Z07_LOJA" }
// Local aPos           :   = {000,000,000,000}
Local nOpcGD          :=    GD_INSERT+GD_UPDATE+GD_DELETE
Local aButtons        :=    {} //{ {"HISTORIC", { || SelPlan() }, "Planilha", "Planilha" , {|| .T.} } }
Local oFont           :=    TFont():New('Courier new',,-12,.T.)
Local lAprovar        :=    .F.
Local nTamanho           
Local nLinhaAux     
Local nColunaAux    
Local nColunaX      
Private oLayer        :=    FwLayer():New()
Private aAlter        :=    { /*"Z07_BANDEJA","Z07_MOLA",*/"Z07_QUANT",/*"Z07_TIPOMOL",*/"Z07_CODPROD" }
Private aCols         :=    {}
Private aHeader       :=    {}
Private _aDados       :=    {}
Private _aRecnos      :=    {}
Private _cChapa       :=    Space(6)
Private _cCliente     :=    Space(6)
Private _cLOja        :=    Space(4)
Private _cCodMaq      :=    Space(15)
Private _cVersao      :=    ""
Private _dInicio      :=    stod("")
Private _aBandeja     :=    { { 1, "S1", .F., {}, {} },{ 2, "S2", .F., {}, {} },{ 3, "S3", .F., {}, {} },{ 4, "S4", .F., {}, {} },{ 5, "S5", .F., {}, {} },{ 6, "S6", .F., {},{} },{ 7, "S7", .F., {},{} },{ 8, "S8", .F., {},{} },{ 9, "S9", .F., {},{} },{ 10, "S10", .F., {},{} },{ 11, "S11", .F., {},{} },{ 12, "S12", .F., {},{} },{ 13, "S13", .F., {},{} },{ 14, "S14", .F., {},{} },{ 15, "S15", .F., {},{} },{ 16, "S16", .F., {},{} },{ 17, "S17", .F., {},{} },{ 18, "S18", .F., {},{} },{ 19, "S19", .F., {},{} },{ 20, "S20", .F., {},{} },{ 21, "S21", .F., {},{} },{ 22, "S22", .F., {},{} },{ 23, "S23", .F., {},{} },{ 24, "S24", .F., {},{} },{ 25, "S25", .F., {},{} },{ 26, "S26", .F., {},{} },{ 27, "S27", .F., {},{} },{ 28, "S28", .F., {},{} },{ 29, "S29", .F., {},{} },{ 30, "S30", .F., {},{} },{ 31, "S31", .F., {},{} },{ 32, "S32", .F., {},{} },{ 33, "S33", .F., {},{} },{ 34, "S34", .F., {},{} },{ 35, "S35", .F., {},{} },{ 36, "S36", .F., {},{} },{ 37, "S37", .F., {},{} },{ 38, "S38", .F., {},{} },{ 39, "S39", .F., {},{} },{ 40, "S40", .F., {},{} } }
Private _cMsgInfo     :=    ""
Private _cMsgRev      :=    "Você está gerando uma nova versão do mapa"
Private _cMsgAprov    :=    "Essa é uma versão de mapa gerada via aplicativo mobile"

If nOpc == 2
    nOpcGD := 2
ElseIf nOpc == 3 .Or. nOpc == 4 .Or. nOpc == 6
    nOpcGD := GD_INSERT+GD_UPDATE+GD_DELETE
ElseIf nOpc == 5
    nOpcGD := 2
EndIf

fHead()
dbSelectArea("Z07")
RegToMemory("Z07",.T.)

If nOpc == 3
    _dInicio := Date()
    _cVersao := "1"
EndIf

If Z07->Z07_STATUS == "2"
    lAprovar := .T.
EndIf

oWindow := MSDialog():New( aSize[7],aSize[1],aSize[6],aSize[5],"Mapa de máquina",,,.F.,,,,,,.T.,,,.T. )    
      
    oWindow:lEscClose := .F.
    oWindow:lMaximized := .T. 
    
    oLayer:Init(oWindow,.F.)
    oLayer:addLine("LINHA1",70,.F.)

    oLayer:addCollumn('COLUNA1_1',33,.F.,"LINHA1")
    oLayer:addCollumn('COLUNA2_1',67,.F.,"LINHA1")

    oLayer:addWindow("COLUNA1_1","WIN_1","Selecoes",100,.F.,.T.,{||},"LINHA1")
    oLayer:addWindow("COLUNA2_1","WIN_2","Molas",100,.F.,.T.,{||},"LINHA1")
                                                     
    oPnl1 := oLayer:GetWinPanel("COLUNA1_1","WIN_1","LINHA1")
    oPnl2 := oLayer:GetWinPanel("COLUNA2_1","WIN_2","LINHA1")
             
    // painel superior - campos
    oPanel := tPanel():New( 0,0,"",oWindow,,,,,,0,50)
    oPanel:Align := CONTROL_ALIGN_TOP
                         
    oImgProd := TBitmap():New(0,aSize[5]-600,50,50,"","",.T.,oPanel,{ || },,.F.,.T.,,,.F.,,.T.,,.F.)
    //oImgProd:Load( , "\_mobile\data\data_img\1001120.jpg" )
    
    oChapa := TGet():New( 05,05,{|u| If(PCount()>0,_cChapa:=u,_cChapa) },oPanel,045,010,"@!",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,{ || AtuCab() },.F.,.F.,""/*F3*/,"",,,,,,,"Patrimônio",2,oFont)    
    If nOpc <> 3
        oChapa:Disable()
    EndIf

    oMaq := TGet():New( 05, 100,{|u| If(PCount()>0, _cCodMaq  := u,  _cCodMaq) }, oPanel, 045, 010, "@!", , CLR_BLACK, CLR_WHITE, , , , .T., "", , , .F., .F., , .F., .F., "", "", , , , , , ,  "Modelo", 2, oFont )        
    oMaq:Disable()
    oCli := TGet():New( 20,  05,{|u| If(PCount()>0, _cCliente := u, _cCliente) }, oPanel, 045, 010, "@!", , CLR_BLACK, CLR_WHITE, , , , .T., "", , , .F., .F., , .F., .F., "", "", , , , , , , "Cliente", 2, oFont )    
    oCli:Disable()
    oLj :=  TGet():New( 20, 100,{|u| If(PCount()>0, _cLOja    := u,    _cLOja) }, oPanel, 045, 010, "@!", , CLR_BLACK, CLR_WHITE, , , , .T., "", , , .F., .F., , .F., .F., "", "", , , , , , ,    "Loja", 2, oFont )    
    oLj:Disable()                  
    oDt :=  TGet():New( 05, 200,{|u| If(PCount()>0, _dInicio  := u,  _dInicio) }, oPanel, 045, 010, "@!", , CLR_BLACK, CLR_WHITE, , , , .T., "", , , .F., .F., , .F., .F., "", "", , , , , , ,  "Inicio", 2, oFont )    
    oDt:Disable()    
    oVer := TGet():New( 20, 200,{|u| If(PCount()>0, _cVersao  := u,  _cVersao) }, oPanel, 045, 010, "@!", , CLR_BLACK, CLR_WHITE, , , , .T., "", , , .F., .F., , .F., .F., "", "", , , , , , ,  "Versão", 2, oFont )    
    oVer:Disable()

    oInfo := TSay():New( 40, 05,{|| _cMsgInfo }, oPanel, , , .F., .F., .F., .T., CLR_BLACK, CLR_WHITE, 016, 500 )
    oInfo:SetCss(" QLabel {font: bold 12px; color: #ff3377; } ")    
    If lAprovar    
        _cMsgInfo := _cMsgAprov
    EndIf
    If nOpc == 6
     _cMsgInfo := _cMsgRev
    EndIf
    
        nTamanho      :=    20
        nLinha        :=    5
        nColuna       :=    5
        nLinhaAux     :=    35
        nColunaAux    :=    25
        nColunaX      :=    nColuna
    
        oBdj1 := TButton():New( nLinha, nColuna,"S1",oPnl1,{ || AtvBdj(1)     },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj1:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nColuna += nColunaAux

        oBdj2 := TButton():New( nLinha, nColuna,"S2",oPnl1,{ || AtvBdj(2)     },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj2:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nColuna += nColunaAux

        oBdj3 := TButton():New( nLinha, nColuna,"S3",oPnl1,{ || AtvBdj(3)     },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj3:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nColuna += nColunaAux

        oBdj4 := TButton():New( nLinha, nColuna,"S4",oPnl1,{ || AtvBdj(4)     },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj4:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nColuna += nColunaAux

        oBdj5 := TButton():New( nLinha, nColuna,"S5",oPnl1,{ || AtvBdj(5)    },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj5:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nColuna += nColunaAux

        oBdj6 := TButton():New( nLinha, nColuna,"S6",oPnl1,{ || AtvBdj(6)    },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj6:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nColuna += nColunaAux

        oBdj7 := TButton():New( nLinha, nColuna,"S7",oPnl1,{ || AtvBdj(7)    },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj7:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nColuna += nColunaAux
        
        oBdj8 := TButton():New( nLinha, nColuna,"S8",oPnl1,{ || AtvBdj(8)    },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj8:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nLinha += nLinhaAux
        nColuna := nColunaX

        
        oBdj9 := TButton():New( nLinha, nColuna,"S9",oPnl1,{ || AtvBdj(9)    },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj9:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nColuna += nColunaAux

        oBdj10 := TButton():New( nLinha, nColuna,"S10",oPnl1,{ || AtvBdj(10)  },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj10:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nColuna += nColunaAux

        oBdj11 := TButton():New( nLinha, nColuna,"S11",oPnl1,{ || AtvBdj(11)  },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj11:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nColuna += nColunaAux

        oBdj12 := TButton():New( nLinha, nColuna,"S12",oPnl1,{ || AtvBdj(12)  },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj12:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nColuna += nColunaAux

        oBdj13 := TButton():New( nLinha, nColuna,"S13",oPnl1,{ || AtvBdj(13)  },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj13:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nColuna += nColunaAux

        oBdj14 := TButton():New( nLinha, nColuna,"S14",oPnl1,{ || AtvBdj(14)  },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj14:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nColuna += nColunaAux

        oBdj15 := TButton():New( nLinha, nColuna,"S15",oPnl1,{ || AtvBdj(15)  },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj15:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nColuna += nColunaAux
        
        oBdj16 := TButton():New( nLinha, nColuna,"S16",oPnl1,{ || AtvBdj(16)  },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj16:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nLinha += nLinhaAux
        nColuna := nColunaX

        
        oBdj17 := TButton():New( nLinha, nColuna,"S17",oPnl1,{ || AtvBdj(17)  },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj17:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nColuna += nColunaAux

        oBdj18 := TButton():New( nLinha, nColuna,"S18",oPnl1,{ || AtvBdj(18)  },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj18:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nColuna += nColunaAux

        oBdj19 := TButton():New( nLinha, nColuna,"S19",oPnl1,{ || AtvBdj(19)  },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj19:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nColuna += nColunaAux

        oBdj20 := TButton():New( nLinha, nColuna,"S20",oPnl1,{ || AtvBdj(20)  },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj20:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nColuna += nColunaAux
        
        oBdj21 := TButton():New( nLinha, nColuna,"S21",oPnl1,{ || AtvBdj(21)  },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj21:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nColuna += nColunaAux
        
        oBdj22 := TButton():New( nLinha, nColuna,"S22",oPnl1,{ || AtvBdj(22)  },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj22:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nColuna += nColunaAux
        
        oBdj23 := TButton():New( nLinha, nColuna,"S23",oPnl1,{ || AtvBdj(23)  },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj23:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nColuna += nColunaAux
        
        oBdj24 := TButton():New( nLinha, nColuna,"S24",oPnl1,{ || AtvBdj(24)  },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj24:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nLinha += nLinhaAux
        nColuna := nColunaX

        
        oBdj25 := TButton():New( nLinha, nColuna,"S25",oPnl1,{ || AtvBdj(25)  },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj25:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nColuna += nColunaAux
        
        oBdj26 := TButton():New( nLinha, nColuna,"S26",oPnl1,{ || AtvBdj(26)  },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj26:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nColuna += nColunaAux

        oBdj27 := TButton():New( nLinha, nColuna,"S27",oPnl1,{ || AtvBdj(27)  },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj27:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nColuna += nColunaAux

        oBdj28 := TButton():New( nLinha, nColuna,"S28",oPnl1,{ || AtvBdj(28)  },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj28:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nColuna += nColunaAux

        oBdj29 := TButton():New( nLinha, nColuna,"S29",oPnl1,{ || AtvBdj(29)  },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj29:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nColuna += nColunaAux

        oBdj30 := TButton():New( nLinha, nColuna,"S30",oPnl1,{ || AtvBdj(30)  },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj30:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nColuna += nColunaAux

        oBdj31 := TButton():New( nLinha, nColuna,"S31",oPnl1,{ || AtvBdj(31)  },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj31:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nColuna += nColunaAux

        oBdj32 := TButton():New( nLinha, nColuna,"S32",oPnl1,{ || AtvBdj(32)  },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj32:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nLinha += nLinhaAux
        nColuna := nColunaX

        
        oBdj33 := TButton():New( nLinha, nColuna,"S33",oPnl1,{ || AtvBdj(33)  },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj33:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nColuna += nColunaAux

        oBdj34 := TButton():New( nLinha, nColuna,"S34",oPnl1,{ || AtvBdj(34)  },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj34:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nColuna += nColunaAux

        oBdj35 := TButton():New( nLinha, nColuna,"S35",oPnl1,{ || AtvBdj(35)  },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj35:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nColuna += nColunaAux

        oBdj36 := TButton():New( nLinha, nColuna,"S36",oPnl1,{ || AtvBdj(36)  },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj36:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nColuna += nColunaAux

        oBdj37 := TButton():New( nLinha, nColuna,"S37",oPnl1,{ || AtvBdj(37)  },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj37:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nColuna += nColunaAux

        oBdj38 := TButton():New( nLinha, nColuna,"S38",oPnl1,{ || AtvBdj(38)  },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj38:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nColuna += nColunaAux

        oBdj39 := TButton():New( nLinha, nColuna,"S39",oPnl1,{ || AtvBdj(39)  },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj39:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
        
        nColuna += nColunaAux
        
        oBdj40 := TButton():New( nLinha, nColuna,"S40",oPnl1,{ || AtvBdj(40)  },nTamanho,nTamanho,,,,.T.,,"",,,,.F. )
        oBdj40:SetCss( "QPushButton{  background-color: #C2D6D6; border: 1px solid gray; border-radius: 3px; background-repeat: none; margin: 1px }" ) 
    

    // D:\Protheus11\Protheus_Data\_mobile\data\data_img      
    oMsGD := MsNewGetDados():New(0,0,0,0,nOpcGD,'STATICCALL( Z07Tela, LinOk )','STATICCALL( Z07Tela, TudoOk )','',aAlter,0,100,'STATICCALL( Z07Tela,AltCpo )','','AllwaysTrue()',oPnl2,aHeader,aCols, { || fChange() })
       oMsGD:oBrowse:Align    := CONTROL_ALIGN_ALLCLIENT
       
        If nOpc <> 3
            Carrega()   
        EndIf

    oMsGD:Refresh(.T.)     
    oMsGD:GoTop()
    oMsGd:Disable()
     
oWindow:Activate(,,,.T.,/*aButtons*/,,EnchoiceBar(oWindow,{ || fChange(),IIF(oMsGD:tudoOk(),lOk := Gravar(nOpc),), IIF(lOk, oWindow:End() ,)    },{ || oWindow:End(),,aButtons,,,.F.,.F.,.F.} )) 

Return 



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AtvBdj  ºAutor  ³Jackson E. de Deus    º Data ³  12/08/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Configuracao de bandeja                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AtvBdj(nPos)

Local nI

// salva o que esta na bandeja ativa
For nI := 1 To Len(_aBandeja)
    If _aBandeja[nI][3]
        _aBandeja[nI][4] := aclone( oMsGd:acols )
    EndIf
Next nI

// muda status bandeja
For nI := 1 To Len(_aBandeja)
    If nI <> nPos
        _aBandeja[nI][3] := .F.
    EndIf
Next nI

// ativa dados dessa bandeja clicada
_aBandeja[nPos][3] := .T.

oLayer:setWinTitle("COLUNA2_1", "WIN_2", "Bandeja "+_aBandeja[nPos][2], "LINHA1")    

aCols := {}
If !Empty(_aBandeja[nPos][4])
    aCols := aclone(_aBandeja[nPos][4])
EndIf

If Empty(aCols)
    oMsGD:aCols := {}

    AAdd(aCols, Array(Len(aHeader)+1))
    nLin := Len(aCols) 
    //aCols[nLin][1] := Space(TamSX3("Z07_BANDEJA")[1])
    // aCols[nLin][1] := Space(TamSX3("Z07_MOLA")[1])
    // aCols[nLin][2] := Space(TamSX3("Z07_TIPOMOL")[1])
    aCols[nLin][3] := 0 //Space(TamSX3("Z07_QUANT")[1])
    aCols[nLin][4] := Space(TamSX3("Z07_CODPROD")[1])
    aCols[nLin][5] := Space(TamSX3("B1_DESC")[1])
    aCols[nLin][6] := Space(TamSx3("BM_DESC")[1])
    aCols[nLin][Len(aHeader)+1] := .F.
EndIf

oMsGD:SetArray( aCols )
oMsGD:Refresh()     
oMsGd:Enable()                            

Return
       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AtuCab  ºAutor  ³Jackson E. de Deus    º Data ³  12/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualiza campos do cabecalho                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AtuCab()

If !Empty(_cChapa)
    dbSelectArea("SN1")
    dbSetOrder(2)
    If msSeek( xFilial("SN1") +AvKey(_cChapa,"N1_CHAPA") )
        _cCodMaq  := SN1->N1_PRODUTO
        _cCliente := SN1->N1_XCLIENT
        _cLOja    := SN1->N1_XLOJA
    EndIf
Else    
    _cCodMaq  := ""
    _cCliente := ""
    _cLOja    := ""
EndIf

oMaq:Refresh()
oCli:Refresh()
oLj:Refresh()
      
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fChange   ºAutor  ³Jackson E. de Deus  º Data ³  12/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ bloco fchange do grid                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fChange()
            
Local nPos
Local nI

nPos := Ascan( _aBandeja, { |x| x[3] == .T. } )
If nPos > 0
    _aBandeja[nPos][4] := aclone(oMsGD:aCols)
EndIf

For nI := 1 To Len(oMsGD:aCols)
    conout()
Next nI

oMsGD:Refresh(.T.)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AltCpo  ºAutor  ³Jackson E. de Deus    º Data ³  26/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Alteracao de campos do grid                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AltCpo()

Local lRet        :=    .T.
Local cImgDef     :=    "nophoto.png"
Local nPosDesc    :=    Ascan( aheader, { |x| ALLTRIM(x[2]) == "Z07_DESCPRO" } )
Local nPGrupo     :=    Ascan( aheader, { |x| ALLTRIM(x[2]) == "BM_DESC" } )
Local nPos        :=    0

// mola
If __readvar == "M->Z07_SELECA"
// If __readvar == "M->Z07_MOLA"
    If Len(ALLTRIM(CVALTOCHAR(M->Z07_SELECA))) > 2
        MsgAlert("O código de mola deve ter apenas 2 caracteres!")
        lRet := .F.
    EndIf
    
    nPos := AScan( oMsGd:aCols, { |x| x[2] == M->Z07_SELECA .And. x <> oMsGd:nAt } )
    If nPos > 0
        MsgAlert("Essa mola já está configurada!")
        lRet := .F.    
    EndIf
    // If Len(ALLTRIM(CVALTOCHAR(M->Z07_MOLA))) > 2
    //     MsgAlert("O código de mola deve ter apenas 2 caracteres!")
    //     lRet := .F.
    // EndIf
    
    // nPos := AScan( oMsGd:aCols, { |x| x[2] == M->Z07_MOLA .And. x <> oMsGd:nAt } )
    // If nPos > 0
    //     MsgAlert("Essa mola já está configurada!")
    //     lRet := .F.    
    // EndIf
    
// tipo mola    
ElseIf __readvar == "M->Z07_TIPOMOL"

// quantidade                                   
ElseIf __readvar == "M->Z07_QUANT"

    If !Empty(M->Z07_QUANT)
        If M->Z07_QUANT > 20
            MsgAlert("A mola não deve ter capacidade superior a 20!")
            lRet := .F.
        EndIf
    EndIf

// produto        
ElseIf __readvar == "M->Z07_CODPROD"

    If !Empty(M->Z07_CODPROD)
        dbSelectArea("SB1")
        dbSetOrder(1)
        If msSeek( xFilial("SB1") +AvKey(M->Z07_CODPROD,"B1_COD") )
            omsGd:acols[omsGd:nAt][nPosDesc] := SB1->B1_DESC
            
            cGrupo := SB1->B1_GRUPO
            omsGd:aCols[omsGd:nAt][nPGrupo] := AllTrim(Posicione( "SBM",1,xFilial("SBM") +AvKey(cGrupo,"BM_GRUPO"),"BM_DESC" ))                
        EndIf
    
        If File("\_mobile\mobile\data\data_img\"+alltrim(M->Z07_CODPROD) +".png")
            oImgProd:Load( , "\_mobile\mobile\data\data_img\" +alltrim(M->Z07_CODPROD) +".png" )
            oImgProd:Refresh()
            
            //omsGd:acols[omsGd:nAt][6] := "\_mobile\data\data_img\" +alltrim(M->Z07_CODPROD) +".jpg"
        Else
            oImgProd:Load( , "\_mobile\mobile\data\data_img\" +cImgDef +".png")
            oImgProd:Refresh()
        EndIf
    EndIf
EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LinOk  ºAutor  ³Jackson E. de Deus     º Data ³  02/12/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ LinhaOk do grid                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function LinOk()

Local lRet       :=    .T.                                                  
// Local nPBan := Ascan( aheader, { |x| ALLTRIM(x[2]) == "Z07_BANDEJA" } )
// Local nPMola     :=    Ascan( aheader, { |x| ALLTRIM(x[2]) == "Z07_MOLA" } )
Local nPMola     :=    Ascan( aheader, { |x| ALLTRIM(x[2]) == "Z07_SELECA" } )
// Local nPTpMol    :=    Ascan( aheader, { |x| ALLTRIM(x[2]) == "Z07_TIPOMOL" } )
Local nPQtd      :=    Ascan( aheader, { |x| ALLTRIM(x[2]) == "Z07_QUANT" } )
// Local nPProd := Ascan( aheader, { |x| ALLTRIM(x[2]) == "Z07_CODPROD" } )            

// mola 
If Empty(oMsGd:acols[oMsGd:nAt][nPMola])
    lRet := .F. 
    MsgAlert("Preencha a mola!")
    Return lRet
EndIf

// tipo de mola
If Empty(oMsGd:acols[oMsGd:nAt][nPTpMol])
    lRet := .F. 
    MsgAlert("Preencha o tipo de mola!")
    Return lRet
EndIf

// qtd
If Empty(oMsGd:acols[oMsGd:nAt][nPQtd])
    lRet := .F. 
    MsgAlert("Preencha a capacidade da mola!")
    Return lRet
EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TudoOk  ºAutor  ³Jackson E. de Deus    º Data ³  06/12/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao tudok do grid                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function TudoOk()

Local lRet := .T.
// Local nI
// Local aBandeja := {}

If Empty(_cChapa)
    MsgAlert("Configure o patrimônio!")
    lRet := .F.
    Return lRet
EndIf

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fHead  ºAutor  ³Jackson E. de Deus     º Data ³  26/11/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carrega aHeader                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fHead()

dbSelectArea("SX3")
dbSetOrder(2)            
dbGoTop()

// marcacao
//Aadd(aHeader, {" ","CHECK", "@BMP", 2, 0, ".F." ,""    , "C", "", "R" ,"" , "","","V"})
/*
If msSeek("Z07_BANDEJA")
    AADD(aHeader,{Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"",SX3->X3_USADO,SX3->X3_TIPO,"",SX3->X3_CONTEXT,SX3->X3_CBOX,,,"V" } )
EndIf 
*/
// If msSeek("Z07_MOLA")
//     AADD(aHeader,{Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"",SX3->X3_USADO,SX3->X3_TIPO,"",SX3->X3_CONTEXT,SX3->X3_CBOX } )
// EndIf      

// If msSeek("Z07_TIPOMOL")
//     AADD(aHeader,{Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX } )
// EndIf     

If msSeek("Z07_SELECA")
    AADD(aHeader,{Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"" /*vld campo*/,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO } )
EndIf

If msSeek("Z07_CODPROD")
    AADD(aHeader,{Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"" /*vld campo*/,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO } )
EndIf

If msSeek("Z07_DESCPRO") 
    AADD(aHeader,{Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"",SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO } )
EndIf

If msSeek("Z07_QUANT")
    AADD(aHeader,{Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX } )
EndIf

//Aadd(aHeader, {" ","IMGP", "@BMP", 2, 0, ".F." ,""    , "C", "", "R" ,"" , "","","V"})


// If msSeek("BM_DESC") 
//     AADD(aHeader,{Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"",SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO } )
// EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Carrega  ºAutor  ³Jackson E. de Deus   º Data ³  11/26/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carrega o mapa                                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Carrega()

Local cSql := ""
Local nLin := 0

cSql := "SELECT * FROM Z07010 "
cSql += " WHERE Z07_CHAPA = '"+Z07->Z07_CHAPA+"' AND Z07_VERSAO = '"+Z07->Z07_VERSAO+"' AND D_E_L_E_T_ = '' "
cSql += " ORDER BY Z07_SELECA "
// cSql += " ORDER BY Z07_BANDEJA, Z07_MOLA "

If Select("TRB") > 0
    TRB->(dbCloseArea())
EndIf

TcQuery cSql New Alias "TRB"

dbSelectArea("TRB")
While !EOF()

    _cChapa      :=    TRB->Z07_CHAPA
    _cCliente    :=    TRB->Z07_CLIENTE
    _cLOja       :=    TRB->Z07_LOJA
    _cCodMaq     :=    TRB->Z07_CODMAQ
    _cVersao     :=    TRB->Z07_VERSAO
    _dInicio     :=    STOD(TRB->Z07_DINICIO)

    AAdd(aCols, Array(Len(aHeader)+1))
    nLin := Len(aCols)
                   
    //aCols[nLin][1] := TRB->Z07_BANDEJA
    // aCols[nLin][1] := TRB->Z07_MOLA
    // aCols[nLin][2] := TRB->Z07_TIPOMOL
    aCols[nLin][3] := TRB->Z07_QUANT
    aCols[nLin][4] := TRB->Z07_CODPROD
    aCols[nLin][5] := AllTrim(Posicione( "SB1",1,xFilial("SB1") +AvKey(TRB->Z07_CODPROD,"B1_COD"),"B1_DESC" ))
    
    cGrupo := AllTrim(Posicione( "SB1",1,xFilial("SB1") +AvKey(TRB->Z07_CODPROD,"B1_COD"),"B1_GRUPO" ))
    
    aCols[nLin][6] := AllTrim(Posicione( "SBM",1,xFilial("SBM") +AvKey(cGrupo,"BM_GRUPO"),"BM_DESC" ))    
    //aCols[nLin][6] := "OK"
    
    aCols[nLin][Len(aHeader)+1] := .F.
    
    AADD( _aBandeja[Val(TRB->Z07_BANDEJA)][5], TRB->R_E_C_N_O_ )    //AADD( _aRecnos, TRB->R_E_C_N_O_ )
                              
    // adiciona na bandeja
    AADD( _aBandeja[Val(TRB->Z07_BANDEJA)][4], acols[nLin] )
    
    TRB->(dbSkip())            
End   

oMsGD:Acols := aClone(aCols)
oMsGD:Refresh(.T.)     
oMsGD:GoTop() 
                          
//oMsGD:SetArray( aInfo, .T. )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Gravar  ºAutor  ³Jackson E. de Deus    º Data ³  12/02/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Efetua a gravacao do mapa                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Gravar(nOpc)

// Local nRecno := 0
Local nLinha      :=    0
Local nCol        :=    0
Local nNrCampo    :=    0
Local nPos        :=    0
Local aDados      :=    {}
Local aRecnos     :=    {}
Local lOk         :=    .T. 
Local nPProd      :=    Ascan( aheader, { |x| ALLTRIM(x[2]) == "Z07_CODPROD" } )
// Local nPMola      :=    Ascan( aheader, { |x| ALLTRIM(x[2]) == "Z07_MOLA" } )
Local aMap        :=    {}
Local cBandeja    :=    ""
Local lCafe       :=    .T.
Local lGrava      :=    .T.
Local cGrupo      :=    ""
Local nI

dbSelectArea("SN1")
dbSetOrder(2)
If MsSeek( xFilial("SN1") +AvKey(_cChapa,"N1_CHAPA") )
    dbSelectArea("SB1")
    dbSetOrder(1)
    If MSSeek( xFilial("SB1") +AvKey(SN1->N1_PRODUTO,"B1_COD") )
        If AllTrim(SB1->B1_XFAMILI) $ "144/153"
            lCafe := .T.
        EndIf
    EndIf
EndIf

// revisao - verifica se existe diferenca entre bandejas/molas
If nOpc == 6                                                  

EndIf

dbSelectArea("Z07")
For nI := 1 To Len(_aBandeja)

    cBandeja    :=    cvaltochar(_aBandeja[nI][1])
    aDados      :=    aClone( _aBandeja[nI][4] )
    aRecnos     :=    aClone( _aBandeja[nI][5] )
    
    // revisao
    If nOpc == 6
        // bloqueia o mapa atual
        For nLinha := 1 To Len(aDados)
            If nLinha <= Len(aRecnos)
                dbGoTo(aRecnos[nLinha])
                If RecLock("Z07",.F.)  
                    Z07->Z07_MSBLQL := "1"
                    Z07->Z07_STATUS := "1"
                    Z07->( MsUnlock() )
                EndIf
            EndIf    
        Next nI
        
        // inclui o novo mapa
        If RecLock("Z07",.T.)
            Z07->Z07_CHAPA      :=    _cChapa
            Z07->Z07_CLIENTE    :=    _cCliente
            Z07->Z07_LOJA       :=    _cLoja
            Z07->Z07_CODMAQ     :=    _cCodMaq
            Z07->Z07_USUARIO    :=    cUserName
            Z07->Z07_DINICIO    :=    Date()
            Z07->Z07_VERSAO     :=    Soma1(_cVersao)
            Z07->Z07_STATUS     :=    "3"
            Z07->Z07_BANDEJA    :=    cBandeja
            
            For nCol := 1 To Len(aHeader)
                nNrCampo := FieldPos(Trim(aHeader[nCol][2]))
                FieldPut(nNrCampo, aDados[nLinha][nCol])
            Next nCol
            Z07->( MsUnlock() )
        EndIf
    // inclusao / alteracao / exclusao
    Else
        For nLinha := 1 To Len(aDados)
            // Alteracao  
            If nLinha <= Len(arecnos)
                dbGoTo(arecnos[nLinha])
                If RecLock("Z07",.F.)  
                    // Exclusao
                    If aDados[nLinha][Len(aHeader)+1]
                        Z07->( dbDelete() )
                        
                    // Alteracao
                    Else                
                        Z07->Z07_BANDEJA := cBandeja
                        For nCol := 1 To Len(aHeader)
                            nPos := 0
                            nPos := aScan( aAlter, { |x|, AllTrim(x) == AllTrim(aHeader[nCol][2]) } )
                            If nPos > 0
                                nNrCampo := FieldPos(Trim(aHeader[nCol][2]))
                                FieldPut(nNrCampo, aDados[nLinha][nCol])
                            EndIf
                        Next nCol
                    EndIf    
                    Z07->( MsUnlock() )
                EndIf
                
            // Inclusao
            Else
                If RecLock("Z07",.T.)
                    Z07->Z07_CHAPA      :=    _cChapa
                    Z07->Z07_CLIENTE    :=    _cCliente
                    Z07->Z07_LOJA       :=    _cLoja
                    Z07->Z07_CODMAQ     :=    _cCodMaq
                    Z07->Z07_USUARIO    :=    cUserName
                    Z07->Z07_DINICIO    :=    Date()
                    Z07->Z07_VERSAO     :=    _cVersao
                    Z07->Z07_STATUS     :=    "3"
                    Z07->Z07_BANDEJA    :=    cBandeja
                    
                    For nCol := 1 To Len(aHeader)
                        nNrCampo := FieldPos(Trim(aHeader[nCol][2]))
                        FieldPut(nNrCampo, aDados[nLinha][nCol])
                    Next nCol
                    Z07->( MsUnlock() )
                EndIf
            EndIf
        Next nI
    EndIf

    // ajuste campos SN1
    For nLinha := 1 To Len(aDados)
        If !aDados[nLinha][Len(aHeader)+1] .And. !Empty(aDados[nLinha][1]) .And. !Empty(aDados[nLinha][2])
            AADD( aMap, aDados[nLinha] )
        EndIf
    Next nLinha    
Next nI

If !lCafe
    ASort( aMap,,,{ |x,y| x[1] < y[1] .And. x[2] < y[2] } )  
    ASort( aMap,,,{ |x,y| x[1] < y[1] .And. x[2] < y[2] } )  
Else
/*    For nI := 1 To Len(aMap)
        aMap[nI][1] := Val(aMap[nI][1]) 
    Next nI*/
    
    ASort( aMap,,,{ |x,y| val(x[1]) < val(y[1]) } )  
        
/*    For nI := 1 To Len(aMap)
        aMap[nI][1] := cvaltochar(aMap[nI][1]) 
    Next nI*/
EndIf

dbSelectArea("SN1")
dbSetOrder(2)
If msSeek( xFilial("SN1") +AvKey(_cChapa,"N1_CHAPA") )
    RecLock("SN1",.F.)
    For nI := 1 To 60
        &("SN1->N1_XP" +cvaltochar(nI)) := ""
    Next nI          
    MsUnLock()
                
    If nOpc <> 5
        RecLock("SN1",.F.)
        For nI := 1 To Len(aMap)
            lGrava := .T.
            If nI <= 60
                If !lCafe
                    &("SN1->N1_XP" +cvaltochar(nI)) := aMap[nI][nPProd]
                Else
                    If !Empty(aMap[nI][nPMola]) .And. !Empty(aMap[nI][nPProd])
                        // valida acucar - posicao 1 e posicao 2
                        cGrupo := Posicione("SB1",1,xFilial("SB1")+AvKey(aMap[nI][nPProd],"B1_COD"),"B1_GRUPO")
                        If cGrupo $ "0004#0005#0006" .And. nI <= 2
                            &("SN1->N1_XP" +cvaltochar(nI)) := ""
                            Loop
                        EndIf
                
                        If lGrava
                            &("SN1->N1_XP" +cvaltochar(aMap[nI][nPMola])) := aMap[nI][nPProd]
                        EndIf                    
                    EndIf
                EndIf
            EndIf
        Next nI          
        MsUnLock()
    EndIf
EndIf

Return lOk
