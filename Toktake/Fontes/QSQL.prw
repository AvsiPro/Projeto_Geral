#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±³Funcao    ³QSQL      ³ Autor ³ RENATO TAKAO          ³ Data ³ 11/04/01 ³±±
±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±³Descricao ³Dispara Query SQL e traz resultado na tela.                 ³±±
±³          ³                                                            ³±±
±³Update    ³Nao permite operacoes que alterem dados no banco.           ³±±
±³          ³                                                            ³±±
±³Select    ³Permite todos recursos de SELECTs (JOIN, DISTINCT, etc)     ³±±
±³          ³                                                            ³±±
±³Erros     ³Analisa erros na Query para que o programa nao aborte.      ³±±
±³          ³Para fazer isso, eh necessario disparar a Query, isto eh,   ³±±
±³          ³a Query sera executada 2 vezes. Degrada bastante, mas eh    ³±±
±³          ³melhor que ver o programa abortando.                        ³±±
±³          ³                                                            ³±±
±³Problemas ³Caso encontre algum problema na rotina, envie e-mail para   ³±±
±³          ³rtakao@microsiga.com.br. Sugestoes e criticas tambem.       ³±±
±³          ³Quando o programa estiver totalmente testado, sera enviado  ³±±
±³          ³com BOPS de melhoria para ser incluido no AP5SDU.           ³±±
±³          ³                                                            ³±±
±³Testes    ³Os testes foram feitos com SQL2000. Informacoes de testes   ³±±
±³          ³com Informix, Oracle, Sybase serao de grande utilidade.     ³±±
±³          ³                                                            ³±±
±³Outro DB  ³Foram feitos testes extraindo dados de database fora do     ³±±
±³          ³Top Connect, Database de outro sistema.                     ³±±
±³          ³Houve problemas com relacao aos dados, na criacao da tabela ³±±
±³          ³pela CriaTrab, onde os campos so podem ter 10 caracteres.   ³±±
±³          ³Problemas de compatibilizacao de dados, use recursos do     ³±±
±³          ³Database para converter os dados para VARCHAR que e o       ³±±
±³          ³padrao Microsiga. Exemplo abaixo.                           ³±±
±³          ³CONVERT(VARCHAR(10),NF_ITEM.DATAINICICLO, 112) AS EXPR1     ³±±
±³          ³                                                            ³±±
±³Q Analyser³O uso deste programa e semelhante ao Query Analiser, porem  ³±±
±³          ³com bem menos recursos. Foi elaborado pela necessidade de   ³±±
±³          ³uso do Query analiser do SQL.                               ³±±
±³          ³                                                            ³±±
±³Creditos  ³A elaboracao deste programa teve a colaboracao do pessoal   ³±±
±³          ³de SUPORTE RDMAKE e SUPORTE PROTHEUS/TOP. (Michel e Eric)   ³±±
±³          ³                                                            ³±±
±³Ajuda     ³Ha 2 problemas que devem ser mencionados e que espero que   ³±±
±³          ³alguem possa resolver.                                      ³±±
±³          ³1 - O ponteiro do mouse fica em ampulheta.                  ³±±
±³          ³2 - Os campos numericos foram fixados em 15,2 pois em algu- ³±±
±³          ³mas tabelas houve erro no append de campos com altos valores³±±
±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±³ Uso      ³ TOP CONNECT - Databases padrao SQL                         ³±±
±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION QSQL()

Local _cQueryTxt := ''
Local oDlg1

Private cTitulo:="Query Analyzer AP"  
Private _aCpoBrw :={}                 

DEFINE MSDIALOG oDlg1 TITLE cTitulo From 001,001 To 31,100

@ 180,010 Get _cQueryTxt   Size 300,040  MEMO Object oMemo
@ 210,330 BmpButton Type 1 Action EXECUTA(_cQueryTXT)
@ 210,360 BmpButton Type 2 Action close(oDlg1)

Activate Dialog oDlg1 centered

Return()


/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³      Executa Funcao        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

STATIC FUNCTION EXECUTA(_cQueryTXT)

Local _aStruct :={}                 
//Local _aCpoBrw :={}                 

If Select('QRY') > 0
	DBSELECTAREA("QRY")
	DBCLOSEAREA("QRY")  
EndIf

If Select('XXX') > 0
	DbSelectArea("XXX")
	DbCloseArea()
EndIf

// Analisa a query quanto a possibilidade de alteracao de dados. Nao permite execucao.
_cOper:={"DROP","TRUNCATE","DELETE","INSERT"}//"UPDATE"
For _i:=1 to Len(_cOper)
	If AT(_cOper[_i],_cQueryTxt)>0
		APMsgAlert("Alteracao de dados NAO permitida!",cTitulo)
		Return
	Endif
Next

// Verifica se tem erros na Query. A Query e executada. Caso isso nao seja feito e houver erro na Query, o programa eh abortado.
_nRet = TCSQLEXEC(_cQueryTxt)
If _nRet#0
	APMsgAlert(AllTrim(TCSQLERROR()),cTitulo) 
  	Return
EndIf

// Dispara a Query
dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQueryTxt), "QRY", .F., .T.)
DBSELECTAREA("QRY")
DBGOTOP()

_aStruct:=DbStruct()	// Pega a estrutura do RecordSet
_aCpoBrw:={}

// Monta cabecalho
For _i:=1 to Len(_aStruct)
	AADD(_aCpoBrw,{_aStruct[_i][1],,_aStruct[_i][1]})
Next

// Compatibiliza os campos
// Os campos numericos na origem veem com 15,8 (Tamanho maximo) pelo DBStruct(), porem, estao gravados como VARCHAR no banco.
// Um valor acima 		causaria erro na hora de appendar da QRY para a XXX (Criada pela criatrab).
// Na estrutura que sera usada pela Criatrab, os campos numericos estao sendo alterado para 15,2 para que nao ocorra erro no Append.

For _i := 1 to Len(_aStruct)
	If _aStruct[_i,2] != "C" 
		TCSetField("QRY", _aStruct[_i,1], _aStruct[_i,2],_aStruct[_i,3],_aStruct[_i,4])
		If _aStruct[_i,2] = "N"
			_aStruct[_i,3]:=15
			_aStruct[_i,4]:=2
		Endif
	Endif
Next

// Passa o RecordSet para arquivo. * Em testes diretos com o RecordSet, o Browse fica perdido na navegacao.
If Select('XXX') > 0
	DbSelectArea('XXX')
	DbCloseArea('XXX')  
EndIf

_cArq := CriaTrab(_aStruct,.T.)
dbUseArea(.T.,,_cArq,"XXX",.T.)
Append from QRY 

DBSELECTAREA("QRY")
DBCLOSEAREA("QRY")  

DbSelectArea('XXX')
DbGoTop()

Mostra()

//oBrowseSQL := MsSelect():New("XXX","","",_aCpoBrw,.F.,"",{001,010,180,380})  	// Browse definido como objeto
															// SE,TAM,IE,TAM
//oBrowseSQL:oBrowse:Refresh()	// Refresh do Browse (Forcado)

RETURN()

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Mostra ResultSet           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

Static Function Mostra()

Local oDlg2

DEFINE MSDIALOG oDlg2 TITLE cTitulo From 001,001 To 31,100

//@ 180,010 Get _cQueryTxt   Size 300,040  MEMO Object oMemo
@ 210,330 BmpButton Type 6 Action U_Excel("XXX","RESTC01")
@ 210,360 BmpButton Type 1 Action close(oDlg2)

oBrowseSQL := MsSelect():New("XXX","","",_aCpoBrw,.F.,"",{001,010,180,380})  	// Browse definido como objeto
															// SE,TAM,IE,TAM
oBrowseSQL:oBrowse:Refresh()	// Refresh do Browse (Forcado)

Activate Dialog oDlg2 centered

Return()