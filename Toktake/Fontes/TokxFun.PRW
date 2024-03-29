#INCLUDE "Protheus.ch"
#INCLUDE "rwMake.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.CH"

/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � TokXFun  � Biblioteca de Funcoes genericas utilizadas no projeto.       ���
�����������������������������������������������������������������������������������������͹��
��� Observacoes � Aqui devem ser incluidas apenas as funcoes de uso generico.             ���
���             � As funcoes de uso especifico do Cliente devem estar no programa         ���
���             � ???xFun.                                                                ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    � CriaSX1  � Autor �       TOTVS           � Data � Abr/2009  ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica e cria um novo grupo de perguntas.                 ���
��������������������������������������������������������������������������Ĵ��
���Parametros� ExpA1: array com os elementos do SX1                        ���
��������������������������������������������������������������������������Ĵ��
���Retorno   � Nil                                                         ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������

Exemplo para Criar o aRegs para P10 e chamada da funcao

Local aRegs	:= {}
Private	cPerg   := "???????   "

aAdd(aRegs,{cPerg,"01","De Prefixo     ?","","","mv_ch1","C",3,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","De Portador    ?","","","mv_ch7","C",3,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
aAdd(aRegs,{cPerg,"13","De Emissao     ?","","","mv_chd","D",8,0,0,"G","","MV_PAR13","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"20","Env.E-mail     ?","","","mv_chk","N",1,0,2,"C","","MV_PAR20","Nao","","","","","Sim","","","","","","","","","","","","","","","","","","","","","","","",""})

U_CriaSx1(aRegs)
pergunte(cPerg,.F.)
*/
User Function CriaSx1(aRegs)

Local aAreaAnt	:= GetArea()
Local aAreaSX1	:= SX1->(GetArea())
Local nJ			:= 0
Local nY			:= 0

dbSelectArea("SX1")
dbSetOrder(1)

For nY := 1 To Len(aRegs)
	If !MsSeek(aRegs[nY,1]+aRegs[nY,2])
		RecLock("SX1",.T.)
		For nJ := 1 To FCount()
			If nJ <= Len(aRegs[nY])
				FieldPut(nJ,aRegs[nY,nJ])
			EndIf
		Next nJ
		MsUnlock()
	EndIf
Next nY

RestArea(aAreaSX1)
RestArea(aAreaAnt)

Return(Nil)

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �MontaQry  � Autor �       TOTVS           � Data � Abr/2009  ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Cria tabela temporaria com Select via query.                 ���
��������������������������������������������������������������������������Ĵ��
���Parametros� ExpA1: Varivel com a query desejada.                        ���
���          � ExpA2: Nome da tabela temporaria a ser criada.              ���
��������������������������������������������������������������������������Ĵ��
���Retorno   � Numeros de registros retornados pela Select.                ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
Exemplo da chamada da funcao

cQuery := "SELECT COUNT(*) "
cQuery += " FROM "+RetSqlName("SA1")+" SA1 (NOLOCK) "
cQuery += " WHERE SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND "
cQuery += " SA1.D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY A1_COD DESC "

U_MONTAQRY(cQuery,"TRB")
*/
User Function MontaQry(cSql,cAliasTRB)

Local nCnt := 0
Local bSql := ChangeQuery( cSql )

// Verificar se o Alias ja esta aberto.
If Select(cAliasTRB) > 0
	DbSelectArea(cAliasTRB)
	DbCloseArea(cAliasTRB)
EndIf

//Grava o script da query no system
//MemoWrit(Alltrim(FunName())+Alltrim(cAliasTRB)+".SQL",cSql)

DbUseArea( .T., "TOPCONN", TcGenQry(,,bSql), cAliasTRB, .T., .F. )
DbSelectArea(cAliasTRB)
DbGoTop()

// Conta quantos sao os registros retornados pelo Select.
DbEval( {|| nCnt++ })

DbSelectArea(cAliasTRB)
DbGoTop()

Return(nCnt)

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    � EnvMail  � Autor �       TOTVS           � Data � Abr/2009  ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao para envio de e-mail.                                ���
��������������������������������������������������������������������������Ĵ��
���Parametros� ExpA1: Conta de e-mail de destino separarados por ;         ���
���Parametros� ExpA2: Assunto do e-mail                                    ���
���Parametros� ExpA3: Texto do corpo do e-mail.                            ���
���Parametros� ExpA4: Anexos a serem enviados.                             ���
��������������������������������������������������������������������������Ĵ��
���Retorno   � Nil                                                         ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
Exemplo da chamda:
cMailDestino := Alltrim(SA1->A1_EMIAL)
cAssunto 	 := "Fatura"
cTexto 	 	 := U_MonTxt()
cAnexos	 	 := "\faturas\"+Alltrim(SE1->E1_PREFIXO+SE1->E1_NUM)+"_pag1.jpg" //O diretorio faturas deve estar no mesmo diretorio do system

U_EnvMail(cMailDestino,cAssunto,cTexto,cAnexos)
*/

User Function EnvMail(cMailDestino,cAssunto,cTexto,cAnexos)

Local cAccount	:= GetMV("MV_RELACNT")//Conta de e-mail para enviar a msg
Local cPassword	:= GetMV("MV_RELPSW") //senha da conta definida acima
Local cServer	:= GetMV("MV_RELSERV")//IP do servidor de e-mail
Local cEmailde  := GetMV("MV_RELFROM")//Endereco de e_mail que vai enviar a msg o mesmo da conta

Local lMensagem	:= .T.
Local cRet 		:= .f.

cRet := TkSendMail(	cAccount,cPassword,cServer,cEmailde,cMailDestino,cAssunto,cTexto,cAnexos)

If cRet
	Aviso('E-Mail','E-Mail enviado com sucesso!',{"OK"},2,"Ok!",)
Else
	Aviso('E-Mail','E-Mail n�o pode ser enviado!',{"OK"},2,"Favor Verificar.",)
EndIf

Return()

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    � MonTxt   � Autor �       TOTVS           � Data � Abr/2009  ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Monta texto em HTML utilizado para os casos de envio de     ���
���          � e-mail pelo Protheus para nao reponder.                     ���
��������������������������������������������������������������������������Ĵ��
���Parametros� Nil                                                         ���
��������������������������������������������������������������������������Ĵ��
���Retorno   � Mensagem montada                                            ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

User Function MonTxt()

Local cMensagem := ""

cMensagem += "<html>"
cMensagem += "<body>"

cMensagem += '<p align="center"><b><font color="#000080" face="Arial" size="4">'
cMensagem += "Segue E-Mail."
cMensagem += '</font></b></p>'

cMensagem += '<hr>'

cMensagem += '<p align="LEFT"><font face="Arial"><b>'
cMensagem += 'Caso queira responder a este e-mail, gentileza encaminhar para o endere�o:'
cMensagem += '<br>'
cMensagem += '<a href="mailto:totvs@totvs.com.br">totvs@totvs.com.br'
cMensagem += '</a></b></font></p>'

cMensagem += '<p align="LEFT"><font face="Arial">'
cMensagem += 'TOTVS S/A'
cMensagem += '<br>'
cMensagem += 'Av. Bras Leme, 1717 - Jardim Sao Paulo - CEP 9999-999'
cMensagem += '<br>'
cMensagem += 'S�o Paulo-SP - PABX: (11) 3981-7000 FAX: (11)3981-7000'
cMensagem += '<br>'
cMensagem += '<a href="http://www.totvs.com.br" target="TOTVS">http://www.totvs.com.br'
cMensagem += '</font></p>'

cMensagem += '</body>'

cMensagem += '</html>'

Return(cMensagem)

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �   C      � Autor �       TOTVS           � Data � Abr/2009  ���
��������������������������������������������������������������������������Ĵ��
���Descricao � Funcao responsavel por manter o Layout independente da      ���
���          � resolucao horizontal do Monitor do Usuario.                 ���
��������������������������������������������������������������������������Ĵ��
���Parametros� ExpA1: Coordernada.                                         ���
��������������������������������������������������������������������������Ĵ��
���Retorno   � Coordenada recalculada.                                     ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
Exemplo de chamada:
@ C(018),C(040) Say "Fornecedor" 	Size C(034),C(008)
*/
User Function C(nTam)

Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor

If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
Else	// Resolucao 1024x768 e acima
	nTam *= 1.28
EndIf

//���������������������������Ŀ
//�Tratamento para tema "Flat"�
//�����������������������������
If "MP8/P10" $ oApp:cVersion
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf

Return Int(nTam)

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    � RetAcen  � Autor �       TOTVS           � Data � Abr/2009  ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao para retirar acentos da string - Windows             ���
��������������������������������������������������������������������������Ĵ��
���Parametros� ExpA1: Texto a ser ajustado.				                   ���
��������������������������������������������������������������������������Ĵ��
���Retorno   � Texto ajustado                                              ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
User Function RetAcent(_cTexto)
//�������������������������������������������������������������������������Ŀ
//� Declaracao de variaveis                             							 �
//���������������������������������������������������������������������������
Local i				:= 0
Local _cTextoDev 	:= ""
Local _carac 		:= ""

for i:=1 to len(_cTexto )
	_carac := substr( _ctexto,i,1 )
	do Case
		Case Asc(_carac) = 198 .Or. Asc(_carac) = 133 .Or. Asc(_carac) = 131
			_carac := "a"
			
		Case Asc(_carac) = 181 .Or. Asc(_carac) = 182
			_carac := "A"
			
		Case Asc(_carac) = 130 .Or. Asc(_carac) = 136
			_carac := "e"
			
		Case Asc(_carac) = 144 .Or. Asc(_carac) = 210
			_carac :="E"
			
		Case Asc(_carac) = 162 .Or. Asc(_carac) = 147
			_carac := "o"
			
		Case Asc(_carac) = 224 .Or. Asc(_carac) = 226
			_carac := "O"
			
		Case Asc(_carac) = 161
			_carac := "i"
			
		Case Asc(_carac) = 214
			_carac := "I"
			
		Case Asc(_carac) = 129 .Or. Asc(_carac) = 163
			_carac := "u"
			
		Case Asc(_carac) = 233
			_carac := "U"
			
		Case Asc(_carac) = 135
			_carac := "c"
			
		Case Asc(_carac) = 128
			_carac := "C"
			
		Case Asc(_carac) = 228 .Or. Asc(_carac) = 229
			_carac := "o"
	EndCase
	
	_cTextoDev += _carac
	
Next

_cTextoDev := Alltrim(StrTran(Alltrim(_cTextoDev),chr(13)+chr(10),""))
_cTextoDev := Alltrim(StrTran(Alltrim(_cTextoDev),chr(13),""))
_cTextoDev := Alltrim(StrTran(Alltrim(_cTextoDev),chr(10),""))

Return( _cTextoDev )


/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    � RetAcen2 � Autor �       TOTVS           � Data � Abr/2009  ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao para retirar acentos da string - Windows             ���
��������������������������������������������������������������������������Ĵ��
���Parametros� ExpA1: Texto a ser ajustado.				                   ���
��������������������������������������������������������������������������Ĵ��
���Retorno   � Texto ajustado                                              ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
User Function RetAcen2( _cTexto )

//������������������������������������������������������������������������Ŀ
//� Declaracao de variaveis                                                �
//��������������������������������������������������������������������������
Local i 		 := 0
Local _cTextoDev := ""
Local _carac     := ""

for i:=1 to len(_cTexto )
	_carac := substr( _ctexto,i,1 )
	do Case
		Case _carac $ "�|�|�|�"
			_carac := "a"
			
		Case _carac$ "�|�|�|�"
			_carac := "A"
			
		Case _carac$ "�|�|�"
			_carac := "e"
			
		Case _carac$ "�|�|�"
			_carac :="E"
			
		Case _carac$ "�|�|�|�"
			_carac := "o"
			
		Case _carac$ "�|�|�|�"
			_carac := "O"
			
		Case _carac$ "�"
			_carac := "i"
			
		Case _carac$ "�"
			_carac := "I"
			
		Case _carac$ "�|�"
			_carac := "u"
			
		Case _carac$ "�"
			_carac := "U"
			
		Case _carac$ "�"
			_carac := "c"
			
		Case _carac$ "�"
			_carac := "C"
			
		Case _carac$ "�"
			_carac := "o"
			
		Case _carac$ "`|!|@|#|$|%|^|&|*|(|)|_|-|+|=|[|]|{|}|/|?|.|>|,|<|:|;|'|\|�"
			_carac := " "
			
		Case _carac$ '"'
			_carac := " "
			
	EndCase
	_cTextoDev += _carac
Next

_cTextoDev := Alltrim(StrTran(Alltrim(_cTextoDev),chr(13)+chr(10),Space(2)))
_cTextoDev := Alltrim(StrTran(Alltrim(_cTextoDev),chr(13),Space(2)))
_cTextoDev := Alltrim(StrTran(Alltrim(_cTextoDev),chr(10),Space(2)))

Return( _cTextoDev )

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    � AXTABELA � Autor �       TOTVS           � Data � Abr/2009  ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Edicao da tabela cTabela do SX5                             ���
��������������������������������������������������������������������������Ĵ��
���Parametros� ExpA1: Nome da tabela do SX5 a ser editada.                 ���
��������������������������������������������������������������������������Ĵ��
���Retorno   � Nil                                                         ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
User Function AxTabela(cTabela)

Private NOPCX,NUSADO,AHEADER,ACOLS,ARECNO
Private _CCODFIL,_CCHAVE,_CDESCRI,NQ,_NITEM,NLINGETD
Private CTITULO,AC,AR,ACGD,CLINHAOK,CTUDOOK
Private LRETMOD2,N

//���������������������������������Ŀ
//� Opcao de acesso para o Modelo 2 �
//�����������������������������������
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza
nOpcx    := 3
nUsado   := 0
aHeader  := {}
aCols    := {}
aRecNo   := {}
_cTabela := cTabela // Defina aqui a Tabela para edicao

//�����������������������������Ŀ
//� Posiciona a filial corrente �
//�������������������������������

_cCodFil := "  "

//������������������Ŀ
//� Montando aHeader �
//��������������������
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SX5")
While !Eof() .And. (X3_ARQUIVO == "SX5")
	If X3USO(X3_USADO) .And. cNivel >= X3_NIVEL
		If AllTrim(X3_CAMPO) $ "X5_DESCRI*X5_CHAVE"
			nUsado:=nUsado+1
			Aadd(aHeader,{ AllTrim(x3_titulo), x3_campo, x3_Picture,;
			x3_tamanho, x3_decimal, x3_Valid ,;
			x3_usado, x3_tipo, x3_arquivo, x3_context } )
		EndIf
	EndIf
	dbSkip()
End

//����������������������������������������������������������Ŀ
//� Posiciona o Cabecalho da Tabela a ser editada (_cTabela) �
//������������������������������������������������������������
dbSelectArea("SX5")
dbSetOrder(1)

//�������������������������������������Ŀ
//� Cabecalho da tabela, filial � vazio �
//���������������������������������������
If !dbSeek("  "+"00"+_cTabela)
	Help(" ",1,"RFATAA21")
	MsgStop("Cadastrar Cabecalho da Tabela")
	Return
EndIf
_cChave  := AllTrim(SX5->X5_CHAVE)
_cDescri := SubStr(SX5->X5_DESCRI,1,35)

//��������������������������������������������������������������������������Ŀ
//� Montando aCols - Posiciona os itens da tabela conforme a filial corrente �
//����������������������������������������������������������������������������
dbSeek(_cCodFil+_cTabela)
While !Eof() .And. SX5->X5_FILIAL == _cCodFil .And. SX5->X5_TABELA==_cTabela
	Aadd(aCols ,Array(nUsado+1))
	Aadd(aRecNo,Array(nUsado+1))
	For nQ:=1 to nUsado
		aCols[Len(aCols),nQ]  := FieldGet(FieldPos(aHeader[nQ,2]))
		aRecNo[Len(aCols),nQ] := FieldGet(FieldPos(aHeader[nQ,2]))
	Next
	aRecNo[Len(aCols),nUsado+1] := RecNo()
	aCols[Len(aCols),nUsado+1]  := .F.
	dbSelectArea("SX5")
	dbSkip()
EndDo

_nItem := Len(aCols)
If Len(aCols)==0
	Aadd(aCols,Array(nUsado+1))
	For nQ:=1 to nUsado
		aCols[Len(aCols),nQ]:= CriaVar(FieldName(FieldPos(aHeader[nQ,2])))
	Next
	aCols[Len(aCols),nUsado+1] := .F.
EndIf

//���������������������������������Ŀ
//� Variaveis do Rodape do Modelo 2 �
//�����������������������������������
nLinGetD:=0

//������������������Ŀ
//� Titulo da Janela �
//��������������������
cTitulo := _cDescri

//��������������������������������������������������������������Ŀ
//� Array com descricao dos campos do Cabecalho do Modelo 2      �
//����������������������������������������������������������������
aC:={}
Aadd(aC,{"_cChave" ,{15,10} ,"Tabela"   ,"@!"," ","",.f.})
Aadd(aC,{"_cDescri",{15,58} ,"Descricao","@!"," ","",.f.})

//��������������������������������������������������������������Ŀ
//� Nao utiliza o rodape, apesar de passar para Modelo 2         �
//����������������������������������������������������������������
aR:={}

//����������������������������������������������Ŀ
//� Array com coordenadas da GetDados no modelo2 �
//������������������������������������������������
aCGD:={44,5,118,315}

//������������������������������������Ŀ
//� Validacoes na GetDados da Modelo 2 �
//��������������������������������������
cLinhaOk:= "(!Empty(aCols[n,2]) .Or. aCols[n,3])"
cTudoOk := "AllwaysTrue()"

//��������������������Ŀ
//� Chamada da Modelo2 �
//����������������������
lRetMod2 := .F.
N        := 1
lRetMod2 := Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,{"X5_CHAVE","X5_DESCRI"})

If lRetMod2
	
	Begin Transaction
	
	dbSelectAre("SX5")
	dbSetOrder(1)
	For n := 1 to Len(aCols)
		If aCols[n,Len(aHeader)+1] == .T.
			//����������������������������������������������������������Ŀ
			//� Filial e Chave e a chave indepEndente da descricao		 �
			//� que pode ter sido alterada               					 �
			//������������������������������������������������������������
			If dbSeek(_cCodFil+_cTabela+aCols[n,1])
				RecLock("SX5",.F.,.T.)
				dbDelete()
				MsUnlock()
			EndIf
		Else
			If dbSeek(xFilial("SF2")+_cTabela+aCols[n,1])
				If aCols[n,2] != SX5->X5_DESCRI
					RecLock("SX5",.F.)
					SX5->X5_CHAVE  := aCols[n,1]
					SX5->X5_DESCRI := aCols[n,2]
					MsUnlock()
				EndIf
			Else
				If _nItem >= n
					dbGoto(aRecNo[n,3])
					RecLock("SX5",.F.)
					SX5->X5_CHAVE := aCols[n,1]
					SX5->X5_DESCRI:= aCols[n,2]
					MsUnlock()
				ElseIf (!Empty(aCols[n,1]))
					RecLock("SX5",.T.)
					SX5->X5_FILIAL := _cCodFil
					SX5->X5_TABELA := _cTabela
					SX5->X5_CHAVE  := aCols[n,1]
					SX5->X5_DESCRI := aCols[n,2]
					MsUnlock()
				EndIf
			EndIf
		EndIf
	Next
	
	End Transaction
EndIf

Return()

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �  Excel   � Autor �       TOTVS           � Data � Abr/2009  ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Abre TRB no Excel.                                          ���
��������������������������������������������������������������������������Ĵ��
���Parametros� ExpA1: Alias da tabela temporaria.                          ���
���Parametros� ExpA2: Nome do arquivo excel a ser criado.                  ���
��������������������������������������������������������������������������Ĵ��
���Retorno   � Nil                                                         ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
O arquivo TRB ja deve estar criado
Exemplo de chamada:
U_Excel("TRB","RESTC01")
*/
User Function Excel(xAlias,xNome)

Local cPath  := " "
Local cArq   := " "

//Carrego o path de onde sera gerado o arquivo em excel
cPath	:= cGetFile("","Local",0,"",.T.,GETF_RETDIRECTORY+GETF_LOCALHARD+GETF_LOCALFLOPPY)
cPath   += IIf( Right( AllTrim( cPath ), 1 ) <> '\' , '\', '' )
cARQ    := ALLTRIM(cPath)+xNome+".XLS"
ARQUIVO := "\SYSTEM\"+xNome+".XLS"

DBSELECTAREA(xAlias)

IF FILE(ARQUIVO)
	DELETE FILE(ARQUIVO)
ENDIF
COPY TO &ARQUIVO
//direciona o arquivo para o \temp  do path c:\windows\
IF FILE(ARQUIVO)
	COPY FILE &ARQUIVO TO &cARQ
ENDIF

//carrega o excel com o arquivo gerado, para isso, colocar o excel no path da maquina.
//WINEXEC("EXCEL "+ALLTRIM(cARQ),1)

If ! ApOleClient( 'MsExcel' )
	MsgAlert('MsExcel nao instalado')
	Return()
EndIf

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( ALLTRIM(cARQ) ) // Abre uma planilha
oExcelApp:SetVisible(.T.)

DBSELECTAREA(xAlias)

Return()

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �  AbreArq � Autor �       TOTVS           � Data � Abr/2009  ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Rotina de selecao e abertura do arquivos.                   ���
��������������������������������������������������������������������������Ĵ��
���Parametros� ExpA1: Tipo de extensao do arquivo a ser aberto.            ���
��������������������������������������������������������������������������Ĵ��
���Retorno   � Arquivo selecionado.                                        ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
Exemplo de chamada:
AADD(aButtons, { 5,.T.,{|o| (cArq := U_AbreArq("TXT"),o:oWnd:refresh())	}})//Seleciona o arquivo
*/
User Function AbreArq(cTipo,cPath)

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local cTipo := Iif(cTipo==Nil ,"*",cTipo)
Local cType	:= "Arquivos "+cTipo+"|*."+cTipo+"|Todos os Arquivos|*.*"
Local cArq	:= ""
//���������������������������������������������������������������������Ŀ
//� Seleciona o arquivo                                                 �
//�����������������������������������������������������������������������

If Empty(cPath)
	cArq := cGetFile(cType, OemToAnsi("Selecione o arquivo."),0,"SERVIDOR\",.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)
Else
	cArq := cGetFile(cType, OemToAnsi("Selecione o arquivo."),0,cPath,.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)
End

Return(cArq)

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �  FCOPIA  � Autor �       TOTVS           � Data � Abr/2009  ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Renomea Arquivos Processados Para Nao serem Executados Novam���
���          � Ex: ARQ.TXT -> ARQ.OK                                       ���
��������������������������������������������������������������������������Ĵ��
���Parametros� ExpA1: Arquivo a ser renomeado.                             ���
��������������������������������������������������������������������������Ĵ��
���Retorno   � Nil.                                                        ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
Exemplo de chamada:
U_FCopia(cArq)
*/
User Function FCopia(cArq)

Local cSeq,I,cExtensaoC,cArqTemp,nnPos,cArqOri

cSeq 		:= "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
cArqOri		:= cArq
nnPos		:= AT(".",cArq)-1
cExtensaoC	:= ".OK"
I := 1

cArqTemp := Subs(cArq,1,nnPos)+cExtensaoC+Subs(cSeq,I,1)

While .T.
	If File(cArqTemp)
		I++
		cExtensaoC := If(I <= Len(cSeq) , ".OK" , ".OZ")
		cArqTemp:= Subs(cArq,1,nnPos)+cExtensaoC+Subs(cSeq,I,1)
	Else
		Exit
	Endif
End

RENAME &cArqOri TO &cArqTemp  && Renome Arquivo .TXT p/ .OK0 (Ja Processado)

Return()

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �RetCombo  � Autor �       TOTVS           � Data � Abr/2009  ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna o conte�do do combo de um campo					   ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1: campo que cont�m o combo                             ���
���          � ExpC2: conte�do do campo a ser retornado                    ���
��������������������������������������������������������������������������Ĵ��
���Retorno   � Descricao do combo                                          ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
Exemplo de chamada:
U_RetCombo("A1_XBLQFAT", SA1->A1_XBLQFAT)
*/
User Function RetCombo(cCampo,cChave)

Local aSx3Box	:= RetSx3Box( Posicione("SX3", 2, cCampo, "X3CBox()" ),,, 1 )

Return AllTrim( aSx3Box[aScan( aSx3Box, { |aBox| aBox[2] = cChave } )][3] )

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �  QryArr  � Autor �       TOTVS           � Data � Abr/2009  ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Executa uma query retornando os dados em um array com a     ���
���          � ordem pela sintaxe da select da query.                      ���
��������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = query a ser executada                               ���
��������������������������������������������������������������������������Ĵ��
���Retorno   � ExpA1 = array com o resultado da query                      ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
Exemplo de chamada:
U_QryArr(cQuery)
*/
User Function QryArr(cQuery)

Local aAreaAtu	:= GetArea()
Local aRet		:= {}
Local aRet1		:= {}
Local nRegAtu	:= 0
Local x			:= 0

TCQUERY cQuery NEW ALIAS "_TRB"

DbSelectArea("_TRB")
aRet1	:= Array(fCount())
nRegAtu	:= 1

While !Eof()
	For x:=1 to fCount()
		aRet1[x] := FieldGet(x)
	Next
	AADD(aRet,aclone(aRet1))
	DbSkip()
	nRegAtu += 1
Enddo

DbSelectArea("_TRB")
_TRB->(DbCloseArea())

Return(aRet)

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �  Week    � Autor �       TOTVS           � Data � Abr/2009  ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Identifica data incial e final da semana                    ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = referencia de data.                                 ���
��������������������������������������������������������������������������Ĵ��
���Retorno   � ExpA1 = Data inicio da semana.                              ���
���          � ExpA2 = Data fim da semana.                                 ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
Exemplo de chamada:
U_Week(dDataBase)
*/
User Function Week(dData)

Local aRet 			:= {"",""}
Local nDiaSemana 	:= Dow(dData)

//Acho o dia inicio da semana
aRet[1] := DTOS(dData-(nDiaSemana-1))
//Acho o dia final da semana
aRet[2] := DTOS(dData+(7-nDiaSemana))

Return(aRet)

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �VerFil    � Autor �       TOTVS           � Data � Jun/2009  ���
��������������������������������������������������������������������������Ĵ��
���Descricao � Funcao que retorna as filiais da empresa passada no param.  ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Parametros� ExpA1: cEmpresa - Usar SubStr(cNumEmp,1,2)                  ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Retorno   � Todas as filiais da empresa passada no parametro.           ���
��������������������������������������������������������������������������Ĵ��
���Uso       �                                                             ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
Exemplo de chamada
cFiliais := U_VerFil(SubStr(cNumEmp,1,2))
*/
User Function VerFil(cEmpresa)

Local aArea 	:= GetArea()
Local aAreaSM0 	:= SM0->(GetArea())
Local cRet		:= ""

dbSelectArea("SM0")
dbSetOrder(1)
dbGoTop()

While !EOF()
	
	If SM0->M0_CODIGO == cEmpresa
		If Empty(cRet)
			cRet := SM0->M0_CODFIL
		Else
			cRet += "/"+SM0->M0_CODFIL
		EndIf
	EndIf
	
	dbSkip()
EndDo

RestArea(aAreaSM0)
RestArea(aArea)

Return(cRet)
