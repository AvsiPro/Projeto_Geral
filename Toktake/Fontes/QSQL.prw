#include "rwmake.ch"
#include "topconn.ch"

/*
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ��
��Funcao    �QSQL      � Autor � RENATO TAKAO          � Data � 11/04/01 ���
������������������������������������������������������������������������Ĵ��
��Descricao �Dispara Query SQL e traz resultado na tela.                 ���
��          �                                                            ���
��Update    �Nao permite operacoes que alterem dados no banco.           ���
��          �                                                            ���
��Select    �Permite todos recursos de SELECTs (JOIN, DISTINCT, etc)     ���
��          �                                                            ���
��Erros     �Analisa erros na Query para que o programa nao aborte.      ���
��          �Para fazer isso, eh necessario disparar a Query, isto eh,   ���
��          �a Query sera executada 2 vezes. Degrada bastante, mas eh    ���
��          �melhor que ver o programa abortando.                        ���
��          �                                                            ���
��Problemas �Caso encontre algum problema na rotina, envie e-mail para   ���
��          �rtakao@microsiga.com.br. Sugestoes e criticas tambem.       ���
��          �Quando o programa estiver totalmente testado, sera enviado  ���
��          �com BOPS de melhoria para ser incluido no AP5SDU.           ���
��          �                                                            ���
��Testes    �Os testes foram feitos com SQL2000. Informacoes de testes   ���
��          �com Informix, Oracle, Sybase serao de grande utilidade.     ���
��          �                                                            ���
��Outro DB  �Foram feitos testes extraindo dados de database fora do     ���
��          �Top Connect, Database de outro sistema.                     ���
��          �Houve problemas com relacao aos dados, na criacao da tabela ���
��          �pela CriaTrab, onde os campos so podem ter 10 caracteres.   ���
��          �Problemas de compatibilizacao de dados, use recursos do     ���
��          �Database para converter os dados para VARCHAR que e o       ���
��          �padrao Microsiga. Exemplo abaixo.                           ���
��          �CONVERT(VARCHAR(10),NF_ITEM.DATAINICICLO, 112) AS EXPR1     ���
��          �                                                            ���
��Q Analyser�O uso deste programa e semelhante ao Query Analiser, porem  ���
��          �com bem menos recursos. Foi elaborado pela necessidade de   ���
��          �uso do Query analiser do SQL.                               ���
��          �                                                            ���
��Creditos  �A elaboracao deste programa teve a colaboracao do pessoal   ���
��          �de SUPORTE RDMAKE e SUPORTE PROTHEUS/TOP. (Michel e Eric)   ���
��          �                                                            ���
��Ajuda     �Ha 2 problemas que devem ser mencionados e que espero que   ���
��          �alguem possa resolver.                                      ���
��          �1 - O ponteiro do mouse fica em ampulheta.                  ���
��          �2 - Os campos numericos foram fixados em 15,2 pois em algu- ���
��          �mas tabelas houve erro no append de campos com altos valores���
������������������������������������������������������������������������Ĵ��
�� Uso      � TOP CONNECT - Databases padrao SQL                         ���
������������������������������������������������������������������������Ĵ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
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
//����������������������������Ŀ
//�      Executa Funcao        �
//������������������������������
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
//����������������������������Ŀ
//� Mostra ResultSet           �
//������������������������������
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