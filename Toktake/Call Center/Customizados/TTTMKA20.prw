#include "protheus.ch"
#include "topconn.ch"
  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTTTMKA20  บAutor  ณJackson E. de Deus  บ Data ณ  29/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณLancamento de lacres/moedas para troco                      บฑฑ
ฑฑบ          ณ															  บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณAnalista Resp.ณ  Data  ณVersao| Alteracao realizada                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณJackson       ณ29/12/13ณ01.00 |Criacao                                 ณฑฑ
ฑฑณJackson       ณ07/08/13ณ01.01 |Ajuste feito para retornar os valores   ณฑฑ
ฑฑณ								  digitados para gravacao na SUD		  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function TTTMKA20(nTipo,cNumChapa,nLimTroco,aInfo,aLacres,aMoedas)


Local lRet		 	:= .F.

Local aDimension	:= MsAdvSize()
Local nTamanho		:= 0.6
Local oLayer		:= FWLayer():new()
Local oFont			:= TFont():New('Arial',,-12,.T.,.T.)
Local nOpc			:= GD_INSERT+GD_UPDATE+GD_DELETE
Local aAlter		:= {""}
Local lBloqueia		:= .F.
Local aAuxLacr		:= {}
Local aAuxMoe		:= {}
Private oDlg
Private lGrava		:=	.T.
Private aCoBrw2		:= {}
Private aHoBrw2		:= {}
Private noBrw2		:= 0   
Private cCampos		:=	"ZF_LACRE|ZF_CORLACR|ZF_GLENVIE"
Private aList2		:=	{}
Private oList2	
Private aList		:=	{}
Private oList	        
Private cRota		:=	"RT0004"
Private cRespRota	:=	space(50)	// ver com gloria
Private dData		:=	ctod('  /  /  ')
Private nTroco		:= 0
Private cPictVal	:= ""
Private cPatrimo	:= AllTrim(cNumChapa)

Default nTipo		:= 0

If cEmpAnt <> "01"
	Return(lRet)
EndIf

If nTipo == 0
	Aviso("TTTMKA20","Tipo de lan็amento invแlido."+CRLF +"Informar o tipo: Instala็ใo ou Remo็ใo",{"Ok"})
	Return lRet
EndIf

If nTipo == 1
	cPictVal := "@E 999,999"
ElseIf nTipo == 2
	cPictVal := "@E 999,999.99"
EndIf


Moedas(nTipo)
Aadd(aList,{'','',''})

MHoBrw2()
MCoBrw2()
     
// Se ja houve lancamentos - preenche conteudo
If Len(aLacres) > 0 .Or. Len(aMoedas) > 0
	lBloqueia := .T.
	
	nOpc := 2 // somente visualizacao
EndIf

If nTamanho <> 100
	aDimension[1] := aDimension[1] * nTamanho
	aDimension[2] := aDimension[2] * nTamanho
	aDimension[3] := aDimension[3] * nTamanho
	aDimension[4] := aDimension[4] * nTamanho
	aDimension[5] := aDimension[5] * nTamanho
	aDimension[6] := aDimension[6] * nTamanho
	aDimension[7] := aDimension[7] * nTamanho
EndIf
	
// MONTA A TELA
oDlg := MSDialog():New( aDimension[7],aDimension[1],aDimension[6],aDimension[5],"Patrim๔nio " +cNumChapa,,,.F.,,,,,,.T.,,,.T. )	

    oLayer:init(oDlg,.T.)
	oLayer:addLine("LN_1",80,.F.)
	
	oLayer:addCollumn("COL_1",50,.f.,"LN_1")
	oLayer:addCollumn("COL_2",50,.f.,"LN_1")

	oLayer:addWindow("COL_1","WIN_1","",100,.t.,.F.,{||},"LN_1")
	oLayer:addWindow("COL_2","WIN_2","",100,.t.,.F.,{||},"LN_1")

	oPnl1 := oLayer:GetWinPanel("COL_1","WIN_1","LN_1")
	oPnl2 := oLayer:GetWinPanel("COL_2","WIN_2","LN_1")

	// getdados materiais
	oBrw2 := MsNewGetDados():New(0,0,0,0,nOpc,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',oPnl1,aHoBrw2,aCoBrw2 )
	oBrw2:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	
	If lBloqueia
		//oBrw2:SetArray(aLacres)
		//aList2 := aClone(aMoedas)
	EndIf
		
	// tcbrowse moedas/troco
	oList2 := TCBrowse():New(0,0,0,0,, {'Valores','Saํda'},{100,60},oPnl2,,,,{|| },{|| editcol(nTipo) },, ,,,  ,,.F.,,.T.,,.F.,,,)
	oList2:SetArray(aList2)
	oList2:bLine := {||{ aList2[oList2:nAt,01],; 
	 						 IF(nTipo==1,aList2[oList2:nAt,02], Transform(aList2[oList2:nAt,02], cPictVal ))  }}

	oList2:Align := CONTROL_ALIGN_ALLCLIENT
		
	oPanel3 := tPanel():New(0,0,"",oDlg,,,,,,100,020)
	oPanel3:align := CONTROL_ALIGN_BOTTOM
	
	oSay := TSay():New( 000,005,{ || "" },oPanel3,,oFont,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,200,010)
	oBtn1 := TBtnBmp2():New( 0, 0, 40, 40, 'SALVAR'	, , , ,{ || lRet := Salvar(nTipo,cNumChapa,nLimTroco,@aInfo) } , oPanel3, "Confirmar" , ,)
	oBtn2 := TBtnBmp2():New( 0, 0, 40, 40, 'CANCEL'	, , , ,{ || oDlg:End() } , oPanel3, "Sair" , ,)
	
	//oSay:Align := CONTROL_ALIGN_LEFT                              
	oBtn2:Align := CONTROL_ALIGN_RIGHT                                  
	oBtn1:Align := CONTROL_ALIGN_RIGHT
	
	If lBloqueia
		oBtn1:Disable()
	EndIf
	
oDlg:Activate(,,,.T.) 
           
Return lRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSalvar  บAutor  ณJackson E. de Deus    บ Data ณ  17/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Salva as informacoes                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Salvar(nTipo,cNumChapa,nLimTroco,aInfo)

Local lRet := .T.
Local cAux := ""
Local nI
Local cTroco := ""

If Len(aList) > 0
	/*
	If Empty(oBrw2:aCols[1,2])
		MsgAlert("Nใo foi informado nenhum lacre para o patrim๔nio")
		lGrava := .F.
	EndIf  
	*/
	If nTipo == 1
		lTroco	:=	.F.
		For nX := 1 to len(aList2) -1
			If aList2[nX,02] > 0
				lTroco := .T.
			EndIf
		Next nX
		If !lTroco
			MsgAlert("Informe os valores de moedas/c้dulas.")
			lGrava := .F.
		EndIf
	EndIf
	
	// Total troco
	If nTipo == 1                  
		If !Empty(ALIST2[6][2])
			If Valtype(ALIST2[6][2]) == "C"
				nTroco := Val(ALIST2[6][2])
			ElseIf ValType(ALIST2[6][2]) == "N"
				nTroco := ALIST2[6][2]
			EndIf
		EndIf
		If nLimTroco > 0
			If nTroco > nLimTroco
				Aviso("TTTMKA04","O limite mแximo do troco deve ser: R$" +AllTrim(Transform(nLimTroco,PesqPict("SN1","N1_XLIMTRO"))),{"Ok"})
			EndIf           
		EndIf
	Else
		If !Empty(ALIST2[3][2])
			If Valtype(ALIST2[3][2]) == "C"
				nTroco := Val(ALIST2[3][2])
			ElseIf ValType(ALIST2[3][2]) == "N"
				nTroco := ALIST2[3][2]
			EndIf
		EndIf
	EndIf                                                                                         
	
	If lGrava
		Processa( {|| lRet := Gravar(nTipo,cNumChapa,nLimTroco,aInfo) } )  
	endIf
	If lRet
		oBtn1:disable()
		
		// grava o retorno para posterior gravacao na SUD
		For nI := 1 To Len(oBrw2:aCols)
			cAux += oBrw2:Acols[nI][1]			// lacre
			cAux += ";" +oBrw2:Acols[nI][2]		// tipo
			cAux += ";" +oBrw2:Acols[nI][3]		// cor
			cAux += ";" +oBrw2:Acols[nI][4]		// gleenview
			If nI <> Len(oBrw2:aCols)
				cAux += "|"
			EndIf
		Next nI
		
		// troco
		If nTipo == 1							
			cTroco := cvaltochar(aList2[01,02]) += ";"
			cTroco += cValTochAr(aList2[02,02]) += ";"
			cTroco += cValToChar(aList2[03,02]) += ";"
			cTroco += cValToChar(aList2[04,02]) += ";"
			cTroco += cValToChar(aList2[05,02]) += ";"
			cTroco += cvaltochar(nTroco)
		ElseIf nTipo == 2
			cTroco := cvaltochar(aList2[01,02]) += ";"
			cTroco += cValTochAr(aList2[02,02]) += ";"
			cTroco += cvaltochar(nTroco)
		EndIf
		
		For nI := 1 To Len(aInfo)
			If aInfo[nI][3] == cNumChapa
				aInfo[nI][4] := cAux 
				aInfo[nI][5] := cTroco
				Exit
			EndIf
		Next nI	                                       	
	EndIf  
EndIf

Return lRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMoedas  บAutor  ณJackson E. de Deus    บ Data ณ  17/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCarrega as moedas no array                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Moedas(nTipo)

Local aArea	:=	GetArea()

If nTipo == 1
	Aadd(aList2,{'R$ 0,05',0})
	Aadd(aList2,{'R$ 0,10',0})
	Aadd(aList2,{'R$ 0,25',0})
	Aadd(aList2,{'R$ 0,50',0})
	Aadd(aList2,{'R$ 1,00',0})
	Aadd(aList2,{'Total',0})
ElseIf nTipo == 2
	Aadd(aList2,{'Moedas',0})
	Aadd(aList2,{'Cedulas',0})
	Aadd(aList2,{'Total',0})
EndIf             

RestArea(aArea)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMHoBrw2  บAutor  ณJackson E. de Deus   บ Data ณ  17/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria o aHeader                                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MHoBrw2()

// Lacre | Cor | Tipo (Moedeiro,Aceitador,Cofre) | Gleenview

DbSelectArea("SX3")
DbSetOrder(2)
DbSeek("ZF_LACRE")
noBrw2++
Aadd(aHoBrw2,{Trim(X3Titulo()),;
           	"T_LACRE",;
           	SX3->X3_PICTURE,;
           	SX3->X3_TAMANHO,;
           	SX3->X3_DECIMAL,;
           	"",;
           	"",;
           	SX3->X3_TIPO,;
           	"",;
           	"" } )
 
       
DbSeek("ZF_CORLACR")
Aadd(aHoBrw2,{Trim(X3Titulo()),;
	           SX3->X3_CAMPO,;
	           SX3->X3_PICTURE,;
	           SX3->X3_TAMANHO,;
	           SX3->X3_DECIMAL,;
	           "",;
	           "",;
	           SX3->X3_TIPO,;
	           "",;
	           "",;
	           "1=Cinza;2=Laranja;3=Preto;4=Branco;5=Amarelo;6=Vermelho"  } )

Aadd(aHoBrw2,{"Tipo",;
	           SX3->X3_CAMPO,;
	           SX3->X3_PICTURE,;
	           SX3->X3_TAMANHO,;
	           SX3->X3_DECIMAL,;
	           "",;
	           "",;
	           SX3->X3_TIPO,;
	           "",;
	           "",;
	           "1=Moedeiro;2=Aceitador Cedulas;3=Cofre" } )



DbSeek("ZF_GLENVIE")
Aadd(aHoBrw2,{Trim(X3Titulo()),;
	           SX3->X3_CAMPO,;
	           SX3->X3_PICTURE,;
	           SX3->X3_TAMANHO,;
	           SX3->X3_DECIMAL,;
	           "",;
	           "",;
	           SX3->X3_TIPO,;
	           "",;
	           "" } )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMCoBrw2  บAutor  ณJackson E. de Deus   บ Data ณ  17/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Criacao do aCols                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MCoBrw2()

Local aAux := {}

Aadd(aCoBrw2,Array(5))
For nI := 1 To 4
   If nI == 1
		aCoBrw2[1][nI] := CriaVar("ZF_LACRE")
   Else
		aCoBrw2[1][nI] := CriaVar(aHoBrw2[nI][2])
   EndIf
Next

aCoBrw2[1][5] := .F.

Return    
 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณeditcol  บAutor  ณJackson E. de Deus   บ Data ณ  17/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ edicao do tcbrowse                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function editcol(nTipo)

Local aArea	:=	GetArea()
Local aMult	:=	{0.05,0.10,0.25,0.50,1}
Local lAtu := .F.

If nTipo == 1
	If oList2:nAt == Len(aList2)
		Return
	EndIf
	lEditCell(aList2, oList2, cPictVal,2)      
	aList2[len(aList2),02] := 0         
	
	For nX := 1 to len(aList2) - 1
		aList2[len(aList2),02] += (aList2[nX,02] * aMult[nX])
	Next nX      
	                                  	
	aList2[len(aList2),02] := Transform(aList2[len(aList2),02],"@E 999,999.99")
	
ElseIf nTipo == 2
	If oList2:nAt == Len(aList2)
		Return
	EndIf
	lEditCell(aList2, oList2, cPictVal,2)
   	aList2[len(aList2),02] := 0         		
	
	For nX := 1 to len(aList2) - 1
		aList2[len(aList2),02] += (aList2[nX,02] * 1)
	Next nX
	
	//aList2[len(aList2),02] := Transform(aList2[len(aList2),02],"@E 999,999,999.99") 
EndIf


oList2:refresh()
oDlg:refresh()

RestArea(aArea)

Return



              
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGravar  บAutor  ณJackson E. de Deus    บ Data ณ  17/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Grava                                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Gravar(nTipo,cNumChapa,nLimTroco,aInfo)

Local lRet 			:= .T.                       
Local nI			:= 0
Local aArea			:=	GetArea()
Local aFINA100		:= {}
Local nRecZZO		:= 0
Local nAltZZO		:= 0
Local cMoeda		:= "M1"
Local cCxTesour		:= "CXG"
Local cAgTesour		:= "000001"
Local cCntatesou	:= "000000         "
Local cCxPatr		:= "CXP"
Local cAgPatr		:= "000000"
Local cNatureza		:= "10101009"
Local aDados		:= oBrw2:aCols
Local nTpLacre		:= 1

Private lMsErroAuto	:= .F.


// instalacao                             
If nTipo == 1
	ProcRegua(3)
	IncProc("Atualizando o caixa..")
	
	// cria o caixa do patrimonio caso nao exista - se existir, zera o caixa
	dbSelectArea("SA6")
	dbSetOrder(1)
	If !dbSeek( xFilial("SA6") +AvKey("CXP","A6_COD") +AvKey("000000","A6_AGENCIA") +AvKey(cNumChapa,"A6_NUMCON") )
		RecLock("SA6",.T.)
		SA6->A6_FILIAL	:= xFilial("SA6")
		SA6->A6_COD		:= "CXP"
		SA6->A6_AGENCIA	:= "000000"
		SA6->A6_NUMCON	:= cNumChapa
		SA6->A6_NOME	:= "CAIXA SANGRIA PATRIMONIO " +cNumChapa
		SA6->A6_SALATU	:= 0
		SA6->A6_XSLDFUN	:= nTroco
		SA6->( MsUnLock() )
		
		oSay:SetText("Caixa criado para o patrim๔nio "+cNumChapa)
		oSay:Refresh()     
	Else
		If SA6->A6_SALATU > 0
			RecLock("SA6",.F.)
			SA6->A6_XSLDFUN := nTroco
			MsUnLock()               
			// zera o caixa
			aFINA100 := {	{"E5_DATA"		,dDatabase									,Nil},;
			                {"E5_MOEDA"     ,cMoeda										,Nil},;
			                {"E5_VALOR"     ,SA6->A6_SALATU								,Nil},;
			                {"E5_NATUREZ"   ,cNatureza									,Nil},;
			                {"E5_BANCO"     ,cCxPatr									,Nil},;
			                {"E5_AGENCIA"   ,cAgPatr									,Nil},;
			                {"E5_CONTA"     ,cNumChapa					  				,Nil},;
			                {"E5_HISTOR"    ,"LIMPEZA DE CAIXA"							,Nil},;
			                {"E5_VENCTO"    ,dDatabase									,Nil}	}
			                
			MSExecAuto( {|x,y,z| FinA100(x,y,z)},0,aFINA100,3 )	// pagar
			
			If lMsErroAuto  
				DisarmTransaction()
				MostraErro()
				Return .F.
			EndIf
				
			oSay:SetText("O saldo do caixa do patrim๔nio foi zerado.")
			oSay:Refresh()
		EndIf
	EndIf
	
	BeginTran()

	
	IncProc("Gravando a saida dos lacres..")
	/*
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ,ฟ
	//ณLan็amento de lacres - gleenviewณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ,ู
	*/
	For nI := 1 To Len(aDados)
		If !aDados[nI][Len(aDados[nI])]
			Loop
		EndIf   
		
		// verifica lacre
		If !Empty(aDados[nI][1])
			nRecZZO := FindZZO(1,aDados[nI][1],cNumChapa)
			If nRecZZO > 0
				Aviso("TTTMKA20","Jแ houve o lan็amento de lacre para esse patrim๔nio.",{"Ok"})
			Else
				dbSelectArea("ZZO")
				RecLock("ZZO",.T.)
				ZZO->ZZO_FILIAL := xFilial("ZZO")
				ZZO->ZZO_DATSAI := dDatabase
				ZZO->ZZO_ROTA	:= cRota 
				ZZO->ZZO_RESPON := cRespRota
				ZZO->ZZO_PATRIM := cNumChapa
				ZZO->ZZO_DATUTI := dDatabase
				ZZO->ZZO_TIPO := "1"
				ZZO->ZZO_LACRE := aDados[nI][1]
				ZZO->ZZO_CORLAC := aDados[nI][2]
	
				ZZO->( MsUNLock() )	
		 		oSay:SetText("Gravado o lan็amento do lacre.")				
			EndIf
		EndIf	                                                                              
		                 
		// verifica gleenview
		If !Empty(aDados[nI][4])
			nRecZZO := FindZZO(3,aDados[nI][4],cNumChapa)
			If nRecZZO > 0
				Aviso("TTTMKA20","Jแ houve o lan็amento de gleenview para esse patrim๔nio.",{"Ok"})
			Else
				dbSelectArea("ZZO")
				RecLock("ZZO",.T.)
				ZZO->ZZO_FILIAL := xFilial("ZZO")
				ZZO->ZZO_DATSAI := dDatabase
				ZZO->ZZO_ROTA	:= cRota 
				ZZO->ZZO_RESPON := cRespRota
				ZZO->ZZO_PATRIM := cNumChapa
				ZZO->ZZO_DATUTI := dDatabase
				ZZO->ZZO_TIPO := "3"
				ZZO->ZZO_LACRE := aDados[nI][4]
			
				ZZO->( MsUNLock() )	
		 		oSay:SetText("Gravado o lan็amento do gleenview.")		
			EndIf
		EndIf	  
				
		oSay:Refresh()
	Next nI
	
	IncProc("Atualizando o caixa..")                                
	/*
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMovimenta็๕es bancแriasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	*/
	If nTroco > 0
		lChkSE5 := ChkSE5(1,cCxTesour,cAgTesour,cCntatesou,cNatureza,cMoeda,nTroco)	// tipo, banco, agencia, conta, natureza, moeda, troco
		If lChkSE5
			Aviso("TTTMKA20","Jแ houve a movimenta็ใo bancแria do caixa da tesouraria." +CRLF +"-> Retirada para o caixa do patrim๔nio.",{"Ok"})
			lRet := .T.
		Else
			// Retira do caixa da tesouraria    
			aFINA100 := {	{"E5_DATA"		,dDatabase									,Nil},;
			                {"E5_MOEDA"     ,cMoeda										,Nil},;
			                {"E5_VALOR"     ,nTroco										,Nil},;
			                {"E5_NATUREZ"   ,cNatureza									,Nil},;
			                {"E5_BANCO"     ,cCxTesour									,Nil},;
			                {"E5_AGENCIA"   ,cAgTesour									,Nil},;
			                {"E5_CONTA"     ,cCntatesou		            				,Nil},;
			                {"E5_HISTOR"    ,"TRANSF. INICIAL P/ PATRI.: "+cNumChapa	,Nil}}
			
		
			MSExecAuto( {|x,y,z| FinA100(x,y,z)},0,aFINA100,3 )	// pagar
			 
			If lMsErroAuto
				DisarmTransaction()
				MostraErro()
				Return .F.
			EndIf	      
			oSay:SetText("Movimento bancแrio gerado - Tesouraria -> Patrim๔nio.") 
			osay:Refresh()
		EndIf
		
		
		lChkSE5 := ChkSE5(2,cCxPatr,cAgPatr,cNumChapa,cNatureza,cMoeda,nTroco)	// tipo, banco, agencia, conta, natureza, moeda, troco
		If lChkSE5
			Aviso("TTTMKA20","Jแ houve a movimenta็ใo bancแria do caixa do patrim๔nio." +CRLF +"-> Entrada do caixa da tesouraria.",{"Ok"})
			lRet := .T.
		Else
			// Coloca saldo no caixa do patrimonio  
			aFINA100 := {	{"E5_DATA"		,dDatabase									,Nil},;
			                {"E5_MOEDA"     ,cMoeda										,Nil},;
			                {"E5_VALOR"     ,nTroco										,Nil},;
			                {"E5_NATUREZ"   ,cNatureza									,Nil},;
			                {"E5_BANCO"     ,cCxPatr									,Nil},;
			                {"E5_AGENCIA"   ,cAgPatr									,Nil},;
			                {"E5_CONTA"     ,cNumChapa					  				,Nil},;
			                {"E5_HISTOR"    ,"TRANSF. INICIAL DO CAIXA DA TESOURARIA"	,Nil},;
			                {"E5_VENCTO"    ,dDatabase									,Nil}	}
			
			MSExecAuto( {|x,y,z| FinA100(x,y,z)},0,aFINA100,4 )	// receber
			 
			If lMsErroAuto  
				DisarmTransaction()
				MostraErro()
				Return .F.
			EndIf
			oSay:SetText("Movimento bancแrio gerado -  Tesouraria -> Patrim๔nio.") 
			osay:Refresh()
		EndIf
	EndIf	
	            
	EndTran()
	MsUnLockAll()
		
// remocao
ElseIf nTipo == 2
	ProcRegua(2)
	IncProc("Atualizando caixa..")
		
	// montar tela
	// perguntar se vai gerar um movimento a pagar do caixa do patrimonio
	// dispara email
	// Coloca saldo no caixa do patrimonio
	If nTroco > 0  
		aFINA100 := {	{"E5_DATA"		,dDatabase									,Nil},;
		                {"E5_MOEDA"     ,cMoeda										,Nil},;
		                {"E5_VALOR"     ,nTroco										,Nil},;
		                {"E5_NATUREZ"   ,cNatureza									,Nil},;
		                {"E5_BANCO"     ,cCxTesour									,Nil},;
		                {"E5_AGENCIA"   ,cAgTesour									,Nil},;
		                {"E5_CONTA"     ,cCntatesou					  				,Nil},;
		                {"E5_HISTOR"    ,"REMOCAO PATRIMONIO "+cNumChapa			,Nil},;
		                {"E5_VENCTO"    ,dDatabase									,Nil}	}
		
		MSExecAuto( {|x,y,z| FinA100(x,y,z)},0,aFINA100,4 )	// receber
		 
		If lMsErroAuto  
			DisarmTransaction()
			MostraErro()
			Return .F.
		EndIf
		oSay:SetText("Movimento bancแrio gerado -  Patrim๔nio -> Tesouraria.") 
		osay:Refresh()
		
				
		dbSelectArea("SA6")
		dbSetOrder(1)
		If dbSeek( xFilial("SA6") +AvKey("CXP","A6_COD") +AvKey("000000","A6_AGENCIA") +AvKey(cNumChapa,"A6_NUMCON") )
			If nTroco <> SA6->A6_SALATU
				//Aviso("TTTMKA20","O valor informado nใo corresponde com o saldo do caixa.",{"Ok"})
		
				// dispara email
				cRemete := SuperGetMV("MV_RELACNT",.T.,"microsiga",)
				cTarget := 	AllTrim(UsrRetMail(__cUserID)) + "tesouraria@toktake.com.br"
				cSubject := "Remo็ใo de patrim๔nio - confer๊ncia de troco"
				//cBody := ""
				//U_TTMailN(cRemete,cTarget,cSubject,cBody,aAttach,.F.)
			EndIf
		EndIf
	EndIf	
	
	IncProc("Gravando o retorno dos lacres..")
		            
	/*
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ,ฟ
	//ณLan็amento de lacres - gleenviewณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ,ู
	*/
	For nI := 1 To Len(aDados)
		nRecZZO := 0
	
		If aDados[nI][Len(aDados[nI])]
			Loop
		EndIf   
		
		// verifica lacre
		If !Empty(aDados[nI][1])
			nRecZZO := FindZZO(1,aDados[nI][1],cNumChapa)
			If nRecZZO > 0
				dbSelectArea("ZZO")
				dbGoTo(nRecZZO)
				If !Empty(ZZO->ZZO_DATRET)
					Aviso("TTTMKA20","Jแ houve o retorno do lacre desse patrim๔nio.",{"Ok"})	
				Else
					RecLock("ZZO",.F.)
					ZZO->ZZO_DATRET := dDatabase
					ZZO->( MsUNLock() )
				EndIf
		 		oSay:SetText("Gravado o lan็amento do lacre.")				
		 		oSay:Refresh()
			EndIf
		EndIf	                                                                              
		
		nRecZZO := 0
		                 
		// verifica gleenview
		If !Empty(aDados[nI][4])
			nRecZZO := FindZZO(3,aDados[nI][4],cNumChapa)
			If nRecZZO > 0
				dbSelectArea("ZZO")
				dbGoTo(nRecZZO)
				If !Empty(ZZO->ZZO_DATRET)
					Aviso("TTTMKA20","Jแ houve o retorno do gleenview desse patrim๔nio.",{"Ok"})
				Else
					RecLock("ZZO",.F.)
					ZZO->ZZO_DATRET := dDatabase
					ZZO->( MsUNLock() )
				EndIf
		 		oSay:SetText("Gravado o lan็amento do gleenview.")
	 			oSay:Refresh()		
			EndIf
		EndIf	  
				
		oSay:Refresh()
	Next nI
EndIf


RestArea(aArea)

Return lRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFindZZO  บAutor  ณJackson E. de Deus   บ Data ณ  17/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Busca o lacre na ZZO                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FindZZO(nTpLacre,cLacre,cNumChapa)
                
Local nRecno := 0
Local cQuery := ""

cQuery += "SELECT R_E_C_N_O_ ZZOREC FROM " +RetSqlName("ZZO") 
cQuery += " WHERE ZZO_LACRE = '"+cLacre+"' AND ZZO_PATRIM = '"+cNumChapa+"' AND ZZO_TIPO = '"+cvaltochar(nTpLacre)+"' "
cQuery += " AND ZZO_ROTA = '"+cRota+"' "
cQuery += " AND D_E_L_E_T_ = '' "                                                       

If Select("TRBD") > 0
	TRBD->( dbCloseArea() )
EndIf

TcQuery cQuery New Alias "TRBD"

If !EOF()
	nREcno := TRBD->ZZOREC
EndIf

TRBD->( dbCloseArea() )

Return nRecno



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChkSE5  บAutor  ณJackson E. de Deus    บ Data ณ  17/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se ja existe o movimento bancario                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ChkSE5(nTipo,cBanco,cAgencia,cConta,cNatureza,cMoeda,nValor)
           
Local lRet := .F.
Local cQuery := ""

cQuery += "SELECT COUNT(*) TOTAL FROM " +RetSqlName("SE5")
cQuery += " WHERE "
cQuery += " E5_BANCO = '"+cBanco+"' "
cQuery += " AND E5_AGENCIA = '"+cAgencia+"' "
cQuery += " AND E5_CONTA = '"+cConta+"' "
cQuery += " AND E5_NATUREZ = '"+cNatureza+"' "
cQuery += " AND E5_MOEDA = '"+cMoeda+"' "
cQuery += " AND E5_VALOR = '"+CVALTOCHAR(nValor)+"' "
cQuery += " AND E5_DATA = '"+DTOS(DDATABASE)+"' "

If nTipo == 1
	cQuery += " AND E5_HISTOR LIKE '%INICIAL%' AND E5_HISTOR LIKE '%PATRI%' AND E5_HISTOR LIKE '%"+cPatrimo+"%'"
ElseIf nTipo == 2
	cQuery += " AND E5_HISTOR LIKE '%INICIAL%' AND E5_HISTOR LIKE '%TESOURARIA%' "
EndIf

cQuery += " AND D_E_L_E_T_ = '' "

If Select("TRBS") > 0
	TRBS->( dbCloseArea() )
EndIf

Tcquery cQuery New Alias "TRBS"

dbSelectArea("TRBS")
If TRBS->( !EOF() ) 
	If TRBS->TOTAL > 0
		lRet := .T.
	EndIf             
EndIf


Return lRet