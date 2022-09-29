/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MT089CD  ³ Autor ³ Alexandre Cadubitski  ³ Data ³ 30.07.2009 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Ponto de entrada que permite alterar a regra de selecao do TES³±±
±±³          ³alterar a ordem do array com os elementos encontrados pela    ³±±
±±³          ³rotina e alterar o conteudo do array com os campos do SFM.    ³±±
±±³          ³Todos os retornos tem que ser em forma de CodBlock.           ³±±
±±³          ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MT089CD()
//As variaveis foram carregada com paramixb somente para verificar o condeudo original.
Local bCond 	:=	PARAMIXB[1] //Condicao que avalia os campos do SFM
Local bSort 	:=	PARAMIXB[2] //Forma de ordenacao do array onde o 1o elemento sera utilizado. Esse array inicialmente possui 9 posicoes
Local bIRWhile	:=	PARAMIXB[3] //Regra de selecao dos registros do SFM
Local bAddTes 	:=	PARAMIXB[4] //Conteudo a ser acrescentado no array
Local cTabela	:=	PARAMIXB[5] //Tabela que esta sendo tratada
Local cTipoCli	:= ""
Local cCliente  := ""
Local cLoja		:= ""
Local lFlag		:= .F.
Local nCont		:= 0
  
  
// Tratamento para AMC
If cEmpAnt == "10"
	Return({bCond,bSort,bIRWhile,bAddTes})
EndIf
              
While !empty(procname(nCont))
	If "TTFAT02C/TTEDI101" $ alltrim(procname(nCont))
		lFlag	:= .T.
		Exit
	EndIf   
	nCont++
EndDo
                    
If !lFlag
	If cTabela == "SC6" //Pedcido de Venda
		bCond	:= {||( M->C5_TIPOCLI == (cAliasSFM)->FM_XTPCLI .Or. Empty((cAliasSFM)->FM_XTPCLI) ) } //Acrescenta compo novo a regra, esse campo devera ser acrescentdo no X2_UNICO do SFM.
		bSort	:= {|x,y| x[1]+x[2]+x[3]+x[4]+x[5]+x[6]+x[10]+x[7] > y[1]+y[2]+y[3]+y[4]+y[5]+y[6]+y[10]+y[7]}//Altero a ordem do array, posicao 10, para considerar o campo especifico acrescentado na linha abaixo
		bIRWhile:= {||.T.}    
		bAddTes	:= {||aAdd(aTes[Len(aTes)],(cAliasSFM)->FM_XTPCLI ) }//Acrescento campo a ser considerado na TES Inteligente.
		
	Else
	
		bCond	:= {||.T.}
		bSort	:= bSort
		bIRWhile:= {||.T.}    
		bAddTes	:= {||.T.}
	
	EndIf
EndIf

Return({bCond,bSort,bIRWhile,bAddTes})