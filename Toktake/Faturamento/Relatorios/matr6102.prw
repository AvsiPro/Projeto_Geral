#INCLUDE "MATR610.CH" 
#Include "FIVEWIN.Ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MATR610  � Autor � Marco Bianchi         � Data � 11/09/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao de Pedidos de Vendas por Vendedor/Produto          ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFAT                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function MATR6102()

Local oReport

If FindFunction("TRepInUse") .And. TRepInUse()
	//-- Interface de impressao
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	MATR610R3()
EndIf

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor � Marco Bianchi         � Data � 11/09/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpO1: Objeto do relat�rio                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()

Local oReport

#IFDEF TOP
	Local cAliasQry := GetNextAlias()
#ELSE	
	Local cAliasQry := "SC5"
#ENDIF	

Local cMascara  := GetMv("MV_MASCGRD")
Local nTamRef   := Val(Substr(cMascara,1,2))

// Variaveis da secao totalizadora
Local nTotQuant := 0
Local nTotEntr  := 0
Local nTotVal   := 0


//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//�                                                                        �
//��������������������������������������������������������������������������
oReport := TReport():New("MATR610",STR0015,"MTR610", {|oReport| ReportPrint(oReport,cAliasQry,nTamRef)},STR0016 + " " + STR0017)
oReport:SetTotalInLine(.F.)

//������������������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           				�
//��������������������������������������������������������������������������
AjustaSX1()
Pergunte(oReport:uParam,.F.)

//������������������������������������������������������������������������Ŀ
//�Criacao da secao utilizada pelo relatorio                               �
//�                                                                        �
//�TRSection():New                                                         �
//�ExpO1 : Objeto TReport que a secao pertence                             �
//�ExpC2 : Descricao da se�ao                                              �
//�ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   �
//�        sera considerada como principal para a se��o.                   �
//�ExpA4 : Array com as Ordens do relat�rio                                �
//�ExpL5 : Carrega campos do SX3 como celulas                              �
//�        Default : False                                                 �
//�ExpL6 : Carrega ordens do Sindex                                        �
//�        Default : False                                                 �
//�                                                                        �
//��������������������������������������������������������������������������
//������������������������������������������������������������������������Ŀ
//�Criacao da celulas da secao do relatorio                                �
//�                                                                        �
//�TRCell():New                                                            �
//�ExpO1 : Objeto TSection que a secao pertence                            �
//�ExpC2 : Nome da celula do relat�rio. O SX3 ser� consultado              �
//�ExpC3 : Nome da tabela de referencia da celula                          �
//�ExpC4 : Titulo da celula                                                �
//�        Default : X3Titulo()                                            �
//�ExpC5 : Picture                                                         �
//�        Default : X3_PICTURE                                            �
//�ExpC6 : Tamanho                                                         �
//�        Default : X3_TAMANHO                                            �
//�ExpL7 : Informe se o tamanho esta em pixel                              �
//�        Default : False                                                 �
//�ExpB8 : Bloco de c�digo para impressao.                                 �
//�        Default : ExpC2                                                 �
//�                                                                        �
//��������������������������������������������������������������������������
oVendedor := TRSection():New(oReport,STR0018,{"SC5","TRB","SA3"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oVendedor:SetTotalInLine(.F.)
TRCell():New(oVendedor,"VENDEDOR"	,"TRB",STR0018,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| TRB->VENDEDOR })
TRCell():New(oVendedor,"A3_NOME"	,"SA3",STR0019,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| SA3->A3_NOME })

oProduto := TRSection():New(oVendedor,STR0020,{"TRB","SB1"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oProduto:SetTotalInLine(.F.)
TRCell():New(oProduto,"B1_COD"		,"TRB",STR0020,PesqPict("SB1","B1_COD")		,TamSx3("B1_COD")[1]	,/*lPixel*/,{|| IIF(TRB->GRADE == "S" .And. MV_PAR08 == 1,Substr(SB1->B1_COD,1,nTamRef),SB1->B1_COD) })
TRCell():New(oProduto,"B1_DESC"		,"SB1",STR0021,PesqPict("SB1","B1_DESC")	,TamSx3("B1_DESC")[1]	,/*lPixel*/,{|| SB1->B1_DESC })
//TRCell():New(oProduto,"ESTADO"		,"TRB",STR0022,/*Picture*/					,/*Tamanho*/			,/*lPixel*/,{|| TRB->ESTADO })
TRCell():New(oProduto,"QUANTIDADE"	,"TRB",STR0023,PesqPictQt("C6_QTDVEN",16)	,TamSx3("C6_QTDVEN")[1]	,/*lPixel*/,{|| TRB->QUANTIDADE },,,"RIGHT")
TRCell():New(oProduto,"ENTREGUE"	,"TRB",STR0024,PesqPictQt("C6_QTDVEN",16)	,TamSx3("C6_QTDVEN")[1]	,/*lPixel*/,{|| TRB->ENTREGUE },,,"RIGHT")
TRCell():New(oProduto,"B1_UM"		,"SB1",STR0025,/*Picture*/					,/*Tamanho*/			,/*lPixel*/,{|| SB1->B1_UM })
TRCell():New(oProduto,"VALOR"		,"TRB",STR0026,PesqPict("SC6","C6_VALOR",16),TamSx3("C6_VALOR")[1]	,/*lPixel*/,{|| TRB->VALOR },,,"RIGHT")

TRFunction():New(oProduto:Cell("QUANTIDADE"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/,oVendedor)
TRFunction():New(oProduto:Cell("ENTREGUE")	,/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/,oVendedor)
TRFunction():New(oProduto:Cell("VALOR")		,/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/,oVendedor)


//������������������������������������������������������������������������Ŀ
//� Secao Totalizadora                            	    			       �
//��������������������������������������������������������������������������
oTotal := TRSection():New(oReport,"","",/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)	// "Faturamento por Cliente"
oTotal:SetTotalInLine(.F.)
oTotal:SetEdit(.F.)
TRCell():New(oTotal,"B1_COD"		,,STR0012	,PesqPict("SB1","B1_COD")		,TamSx3("B1_COD")[1]	,/*lPixel*/,/*{|| ) }*/)
TRCell():New(oTotal,"B1_DESC"		,,""		,PesqPict("SB1","B1_DESC")		,TamSx3("B1_DESC")[1]	,/*lPixel*/,/*{||  }*/)
//TRCell():New(oTotal,"ESTADO"		,,""		,/*Picture*/					,/*Tamanho*/			,/*lPixel*/,/*{||  }*/)
TRCell():New(oTotal,"NTOTQUANT"		,,STR0023	,PesqPictQt("C6_QTDVEN",16)		,TamSx3("C6_QTDVEN")[1],/*lPixel*/,{|| nTotQuant },,,"RIGHT")
TRCell():New(oTotal,"NTOTENTR"		,,STR0024	,PesqPictQt("C6_QTDVEN",16)		,TamSx3("C6_QTDVEN")[1],/*lPixel*/,{|| nTotEntr },,,"RIGHT")
TRCell():New(oTotal,"B1_UM"			,,""		,/*Picture*/					,/*Tamanho*/			,/*lPixel*/,/*{||  }*/)
TRCell():New(oTotal,"NTOTVAL"		,,STR0026	,PesqPict("SC6","C6_VALOR",16)	,TamSx3("C6_VALOR")[1]	,/*lPixel*/,{|| nTotVal },,,"RIGHT")

//������������������������������������������������������������������������Ŀ
//� Imprime cabecalho da secao no topo da pagina                 		   �
//��������������������������������������������������������������������������
oReport:Section(1):Section(1):SetHeaderPage(.T.)


Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor � Marco Bianchi         � Data � 11/09/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relat�rio                           ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport,cAliasQry,nTamRef)


Local lQuery    := .F.
#IFNDEF TOP
	Local cCondicao := ""
#ENDIF
Local cDupli	:= If( (MV_PAR09 == 1),"S",If( (MV_PAR09 == 2),"N","SN" ) )
Local cEstoq	:= If( (MV_PAR10 == 1),"S",If( (MV_PAR10 == 2),"N","SN" ) )
Local nI 		:= 0
Local aCampos	:= {}
Local aTam		:= {}
Local bVend		:= { |x| "C5_VEND"+Str(x,1) }
Local aPedido	:= {}
Local nCont		:= 0
Local nPos		:= 0


//������������������������������������������������������������������������Ŀ
//�Transforma parametros Range em expressao SQL                            �
//��������������������������������������������������������������������������
MakeSqlExpr(oReport:uParam)

//��������������������������������������������������������������Ŀ
//� Define array para arquivo de trabalho                        �
//����������������������������������������������������������������
aTam:=TamSX3("C5_VEND1")
AADD(aCampos,{ "VENDEDOR"   ,"C",aTam[1],aTam[2] } )
//aTam:=TamSX3("A1_EST")
//AADD(aCampos,{ "ESTADO"     ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_PRODUTO")
AADD(aCampos,{ "PRODUTO"    ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_EMISSAO")
AADD(aCampos,{ "EMISSAO"    ,"D",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_VALOR")
AADD(aCampos,{ "VALOR"      ,"N",IIf(aTam[1] > 16,aTam[1],16),IIf(aTam[2] > 2,aTam[2],2) } )
aTam:=TamSX3("C6_QTDVEN")
AADD(aCampos,{ "QUANTIDADE" ,"N",IIf(aTam[1] > 16,aTam[1],16),IIf(aTam[2] > 2,aTam[2],2) } )
aTam:=TamSX3("C6_QTDENT")
AADD(aCampos,{ "ENTREGUE"   ,"N",IIf(aTam[1] > 16,aTam[1],16),IIf(aTam[2] > 2,aTam[2],2) } )
aTam:=TamSX3("C6_GRADE")
AADD(aCampos,{ "GRADE"      ,"C",aTam[1],aTam[2] } )
AADD(aCampos,{ "MOEDA"      ,"N",1,0 } )


// Secao totalizadora
oReport:Section(2):Cell("NTOTQUANT" ):SetBlock({|| nTotQuant })	
oReport:Section(2):Cell("NTOTENTR" ):SetBlock({|| nTotEntr })	
oReport:Section(2):Cell("NTOTVAL" ):SetBlock({|| nTotVal })	

// Salta pagina na quebra de secao
oReport:Section(1):SetPageBreak(.T.)
	
//��������������������������������������������������������������Ŀ
//� Cria arquivo de Trabalho                                     �
//����������������������������������������������������������������
cNomArq := CriaTrab(aCampos)
Use &cNomArq Alias TRB   NEW
IndRegua("TRB",cNomArq,"VENDEDOR+PRODUTO",,,STR0009)		//"Selecionando Registros..."
//IndRegua("TRB",cNomArq,"VENDEDOR+PRODUTO+ESTADO",,,STR0009)		//"Selecionando Registros..."
//������������������������������������������������������������������������Ŀ
//�Filtragem do relat�rio                                                  �
//��������������������������������������������������������������������������
dbSelectArea("SC5")		// Pedido de Vendas
dbSetOrder(2)				// Emissao,Numero Pedido
#IFDEF TOP
	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1                                           �
	//��������������������������������������������������������������������������
	oReport:Section(1):BeginQuery()	
	BeginSql Alias cAliasQry
	SELECT *
	FROM %Table:SC5% SC5
	WHERE C5_FILIAL = %xFilial:SC5% 
		AND C5_EMISSAO >= %Exp:mv_par01% AND C5_EMISSAO <= %Exp:mv_par02% 
		AND C5_TIPO NOT IN ('D','B')
		AND SC5.%NotDel%
	ORDER BY C5_EMISSAO,C5_NUM
	EndSql 
	//������������������������������������������������������������������������Ŀ
	//�Metodo EndQuery ( Classe TRSection )                                    �
	//�                                                                        �
	//�Prepara o relat�rio para executar o Embedded SQL.                       �
	//�                                                                        �
	//�ExpA1 : Array com os parametros do tipo Range                           �
	//�                                                                        �
	//��������������������������������������������������������������������������
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)
		
#ELSE
	
		cCondicao := 'C5_FILIAL=="'+xFilial("SC5") + '"'
		cCondicao += '.And.DTOS(C5_EMISSAO)>="'+DTOS(mv_par01)+'"'
		cCondicao += '.And.DTOS(C5_EMISSAO)<="'+DTOS(mv_par02)+'"'
		cCondicao += '.And. !(C5_TIPO $ ("DB"))'
	
		oReport:Section(1):SetFilter(cCondicao,IndexKey())

#ENDIF		

//������������������������������������������������������������������������Ŀ
//�Metodo TrPosition()                                                     �
//�                                                                        �
//�Posiciona em um registro de uma outra tabela. O posicionamento ser�     �
//�realizado antes da impressao de cada linha do relat�rio.                �
//�                                                                        �
//�                                                                        �
//�ExpO1 : Objeto Report da Secao                                          �
//�ExpC2 : Alias da Tabela                                                 �
//�ExpX3 : Ordem ou NickName de pesquisa                                   �
//�ExpX4 : String ou Bloco de c�digo para pesquisa. A string ser� macroexe-�
//�        cutada.                                                         �
//�                                                                        �
//��������������������������������������������������������������������������
TRPosition():New(oReport:Section(1),"SA3",1,{|| SA3->A3_FILIAL+TRB->VENDEDOR })		
TRPosition():New(oReport:Section(1):Section(1),"SB1",1,{|| SB1->B1_FILIAL+TRB->PRODUTO })		


dbSelectArea(cAliasQry)
While !Eof() 
	//��������������������������������������������������������������Ŀ
	//� Verifica se Vendedor devera ser impresso                     �
	//����������������������������������������������������������������
	nCont := 1
	For nI:=1 to 5
		IF (cAliasQry)->&(EVAL(bVend,nI)) >= mv_par03 .And. (cAliasQry)->&(EVAL(bVend,nI)) <= mv_par04 ;
			.And. !Empty((cAliasQry)->&(EVAL(bVend,nI)))
			cCodVen:=(cAliasQry)->&(EVAL(bVend,nI))
			GRAVATRBR4(cCodVen,cEstoq,cDupli,cAliasQry,nTamRef,@aPedido,nCont)
			nCont+=1
		EndIF
	Next nI
	dbSelectArea(cAliasQry)
	dbSkip()
EndDO

//������������������������������������������������������������������������Ŀ
//� Impressao do Relatorio                                       		   �
//��������������������������������������������������������������������������
dbSelectArea("TRB")
dbGoTop()
oReport:SetMeter(TRB->(LastRec()))
nTotQuant := nTotentr := nTotVal := 0
While !oReport:Cancel() .And. !TRB->(Eof())
	
	oReport:Section(1):Init()
	oReport:Section(1):Section(1):Init()
	oReport:Section(1):PrintLine()
	cVend := TRB->VENDEDOR

	While !oReport:Cancel() .And. !TRB->(Eof())	 .And. TRB->VENDEDOR == cVend
		
		// Se Total Geral for por Pedido (mv_par13==2) e houver mais de um vendedor no pedido, soma apenas um.
		nPos := AScan(aPedido,{|x| x[1]+x[2] == VENDEDOR+PRODUTO})
//		nPos := AScan(aPedido,{|x| x[1]+x[2]+x[3] == VENDEDOR+PRODUTO+ESTADO})
		If mv_par13 == 1
			nTotQuant += TRB->QUANTIDADE
			nTotEntr  += TRB->ENTREGUE
			nTotVal   += TRB->VALOR
		ElseIf mv_par13 == 2 .And. nPos > 0
			nTotQuant += aPedido[nPos,4]
			nTotEntr  += aPedido[nPos,5]
			nTotVal   += aPedido[nPos,6]
		EndIf
		
		oReport:Section(1):Section(1):PrintLine()	
		oReport:IncMeter()
		dbSelectArea("TRB")
		dbSkip()
	EndDo
	//������������������������������������������������������������������������Ŀ
	//� Altera texto do Total para cada Vendedor                     		   �
	//��������������������������������������������������������������������������
	oReport:Section(1):SetTotalText(STR0027 + " " + cVend)
	
	oReport:Section(1):Section(1):Finish()
	oReport:Section(1):Finish()	

EndDo

oReport:EndPage() //-- Salta Pagina
oReport:Section(2):Init()	         
oReport:Section(2):PrintLine()
oReport:Section(2):Finish()	         

dbSelectArea("TRB")
dbCloseArea()
FERASE(cNomArq+GetDBExtension())			// arquivo de trabalho
FERASE(cNomArq+OrdBagExt()) 			   // indice gerado


Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �GRAVATRBR4� Autor � Marco Bianchi         � Data � 11/09/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Grava Novo Registro no arquivo de trabalho                 ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MATR610(void)                                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static FuncTion GRAVATRBR4(cCodVen,cEstoq,cDupli,cAliasQry,nTamRef,aPedido,nCont)

Local	cProdRef := ""
Local	nTotQtd  := 0
Local	nTotEnt  := 0
Local	nTotVal  := 0
Local	nReg     := 0
Local	nPos     := 0

dbSelectArea("SA1")
dbSeek(xFilial()+(cAliasQry)->C5_CLIENTE+(cAliasQry)->C5_LOJACLI)

dbSelectArea("SC6")
dbSeek(xFilial()+(cAliasQry)->C5_NUM,.F.)

While !Eof() .And. C6_FILIAL+C6_NUM == xFilial()+(cAliasQry)->C5_NUM

	//���������������������������������������������Ŀ
	//� Verifica se considera residuo               �
	//�����������������������������������������������
	If mv_par12 == 2 .And. C6_BLQ == "R "
		dbSkip()
		Loop
	EndIf				 	
	
	IF C6_PRODUTO < mv_par05 .Or. C6_PRODUTO > mv_par06
		dbSkip()
		Loop
	EndIF
	//���������������������������������������������Ŀ
	//� Avalia TES a Ser Impresso                   �
	//�����������������������������������������������
	If !AvalTes(C6_TES,cEstoq,cDupli)
		dbSkip()
		Loop
	Endif
	//���������������������������������������������Ŀ
	//� Valida o produto conforme a mascara         �
	//�����������������������������������������������
	lRet:=ValidMasc(SC6->C6_PRODUTO,MV_PAR07)
	If !lRet
		dbSkip()
		Loop
	Endif
	
	IF SC6->C6_GRADE == "S" .And. MV_PAR08 == 1
		cProdRef := Substr(SC6->C6_PRODUTO,1,nTamRef)
		nTotQtd  := 0
		nTotEnt  := 0
		nTotVal  := 0
		nReg     := 0
		While !Eof() .And. xFilial() == C6_FILIAL .And. cProdRef == Substr(SC6->C6_PRODUTO,1,nTamRef) .And.;
			SC6->C6_NUM == (cAliasQry)->C5_NUM
			nReg:=Recno()
			IF C6_PRODUTO < mv_par05 .Or. C6_PRODUTO > mv_par06
				dbSkip()
				Loop
			EndIF
			//���������������������������������������������Ŀ
			//� Valida o produto conforme a mascara         �
			//�����������������������������������������������
			lRet:=ValidMasc(SC6->C6_PRODUTO,MV_PAR07)
			If !lRet
				dbSkip()
				Loop
			Endif
			nTotVal += xMoeda(SC6->C6_VALOR,(cAliasQry)->C5_MOEDA,mv_par11,(cAliasQry)->C5_EMISSAO)
			nTotQtd += SC6->C6_QTDVEN
			nTotEnt += SC6->C6_QTDENT
			dbSkip()
			loop
		End
		If nReg > 0
			dbGoto(nReg)
			nReg:=0
		Endif
	Endif
	
	// Se Total Geral for por Pedido (mv_par13==2) e houver mais de um vendedor no pedido, soma apenas um.
	nPos := AScan(aPedido,{|x| x[1]+x[2]+x[3] == cCodVen+SC6->C6_PRODUTO+SA1->A1_EST})	
	If mv_par13 == 2 .And. nCont == 1
		If nPos == 0
			AADD(aPedido,{cCodVen,SC6->C6_PRODUTO,SA1->A1_EST,IIF(SC6->C6_GRADE=="S" .And. MV_PAR08 == 1,nTotQtd,SC6->C6_QTDVEN),IIF(SC6->C6_GRADE=="S" .And. MV_PAR08 == 1,nTotEnt,SC6->C6_QTDENT),IIF(SC6->C6_GRADE=="S" .And. MV_PAR08 == 1,nTotVal,xMoeda(SC6->C6_VALOR,SC5->C5_MOEDA,mv_par11,SC5->C5_EMISSAO))})
		ElseIf nPos > 0
			aPedido[nPos,4] += IIF(SC6->C6_GRADE=="S" .And. MV_PAR08 == 1,nTotQtd,SC6->C6_QTDVEN)
			aPedido[nPos,5] += IIF(SC6->C6_GRADE=="S" .And. MV_PAR08 == 1,nTotEnt,SC6->C6_QTDENT)
			aPedido[nPos,6] += IIF(SC6->C6_GRADE=="S" .And. MV_PAR08 == 1,nTotVal,xMoeda(SC6->C6_VALOR,SC5->C5_MOEDA,mv_par11,SC5->C5_EMISSAO))
		EndIf	
	EndIf	
	
	dbSelectArea("TRB")
	dbSeek(cCodVen+SC6->C6_PRODUTO+SA1->A1_EST)
	
	IF !Found()
		RecLock("TRB",.t.)
		REPLACE VENDEDOR   With cCodVen
		//REPLACE ESTADO     With SA1->A1_EST
		REPLACE PRODUTO    With SC6->C6_PRODUTO
	Else
		RecLock("TRB",.f.)
	EndIF
	
	REPLACE VALOR	    With  VALOR       +IIF(SC6->C6_GRADE=="S" .And. MV_PAR08 == 1,nTotVal,xMoeda(SC6->C6_VALOR,(cAliasQry)->C5_MOEDA,mv_par11,(cAliasQry)->C5_EMISSAO))
	REPLACE QUANTIDADE With  QUANTIDADE  +IIF(SC6->C6_GRADE=="S" .And. MV_PAR08 == 1,nTotQtd,SC6->C6_QTDVEN)
	REPLACE ENTREGUE   With  ENTREGUE    +IIF(SC6->C6_GRADE=="S" .And. MV_PAR08 == 1,nTotEnt,SC6->C6_QTDENT)
	REPLACE GRADE      With  SC6->C6_GRADE
	REPLACE MOEDA      With  (cAliasQry)->C5_MOEDA
	MsUnlock()
	dbSelectArea("SC6")
	dbSkip()
	
EndDO
dbSelectArea((cAliasQry))

Return .T.




/*/
�����������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� DATA   � BOPS �Prograd.�ALTERACAO                                      ���
��������������������������������������������������������������������������Ĵ��
���08.09.98�17561A�Eduardo �Acerto na impressao qdo for grade - Diversos   ���
���20.11.98�MELHOR�Viviani �Inclusao  da pergunta Qual moeda               ���
���30.03.99�MELHOR�Edson   �Passagem do tamanho na SetPrint.               ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR610  � Autor � Paulo Boschetti       � Data � 23.04.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao de Pedidos de Vendas por Vendedor/Produto          ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MATR610(void)                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Matr61022()
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
LOCAL CbTxt
LOCAL titulo
LOCAL cDesc1 := OemToAnsi(STR0001)	//"Este relatorio ira emitir a relacao de Pedidos por"
LOCAL cDesc2 := OemToAnsi(STR0002)	//"ordem de Vendedor/Produto."
LOCAL cDesc3 := ""
LOCAL CbCont,cabec1,cabec2,wnrel
LOCAL tamanho:="M"
LOCAL limite := 132
LOCAL cString:="SC5"
LOCAL lContinua := .T.
LOCAL aTam    := {}
LOCAL j,nTotGer,nTotQuant,nTotProd,nTotGer1:=nTotVend:=nTotProdQ:=nTotProdv:=0
LOCAL nTam1,nDec1,nTam2,nDec2,nTam3,nDec3

PRIVATE cMascara :=GetMv("MV_MASCGRD")
PRIVATE nTamRef  :=Val(Substr(cMascara,1,2))
PRIVATE aReturn := { STR0003, 1,STR0004, 2, 2, 1, "",1 }		//"Zebrado"###"Administracao"
PRIVATE nomeprog:="MATR610"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   :="MTR610"

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
AjustaSX1()
Pergunte("MTR610",.F.)

Titulo := OemToAnsi(STR0005) + " - " + GetMv("MV_MOEDA"+Str(MV_PAR11,1))		//"Pedidos de Vendas por Vendedor/Produto    "

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01        	// A partir da data                         �
//� mv_par02        	// Ate a data                               �
//� mv_par03        	// Vendedor de                              �
//� mv_par04 	    	// Vendedor ate                             �
//� mv_par05	     	// Produto de                               �
//� mv_par06        	// Produto ate                              �
//� mv_par07        	// Mascara de Produto                       �
//� mv_par08        	// Aglutina pedidos de grade                �
//� mv_par09        	// TES Qto Faturamento                      �
//� mv_par10        	// TES Qto Estoque                          �
//� mv_par11        	// Qual moeda                               �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:="MATR610"            //Nome Default do relatorio em Disco

wnrel:=SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey == 27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	dbClearFilter()
	Return
Endif

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
Titulo := OemToAnsi(STR0005) + " - "+GetMv("MV_MOEDA"+Str(mv_par11,1))		//"Pedidos de Vendas por Vendedor/Produto    "

RptStatus({|lEnd| C610Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � C610IMP  � Autor � Rosane Luciane Chene  � Data � 09.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR610			                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function C610Imp(lEnd,WnRel,cString)
LOCAL CbTxt
LOCAL titulo
LOCAL cDesc1 := OemToAnsi(STR0001)	//"Este relatorio ira emitir a relacao de Pedidos por"
LOCAL cDesc2 := OemToAnsi(STR0002)	//"ordem de Vendedor/Produto."
LOCAL cDesc3 := ""
LOCAL CbCont,cabec1,cabec2
LOCAL tamanho:="M"
LOCAL limite := 132
LOCAL lContinua := .T.
LOCAL aCampos := {}
LOCAL aTam    := {}
LOCAL j,nTotGer,nTotQuant,nTotProd, nI
LOCAL nTotGer1 := 0 
LOCAL nTotVend := 0 
LOCAL nTotProdQ:= 0 
LOCAL nTotProdv:= 0
LOCAL nTam1,nDec1,nTam2,nDec2,nTam3,nDec3
LOCAL bVend := { |x| "C5_VEND"+Str(x,1) }
LOCAL nCnt := 0
LOCAL cDupli := If( (MV_PAR09 == 1),"S",If( (MV_PAR09 == 2),"N","SN" ) )
LOCAL cEstoq := If( (MV_PAR10 == 1),"S",If( (MV_PAR10 == 2),"N","SN" ) )
LOCAL cQuant    := ""
LOCAL cEntregue := "" 
LOCAL nTotQFat	:= 0
LOCAL nTotQPed	:= 0
LOCAL aPedido	:= {}
LOCAL nCont		:= 0
LOCAL nPos		:= 0

//��������������������������������������������������������������Ŀ
//� Definicao dos cabecalhos                                     �
//����������������������������������������������������������������
titulo := STR0006	+ " - " + GetMv("MV_MOEDA"+Str(MV_PAR11,1)) //"PEDIDOS DE VENDAS POR VENDEDOR/PRODUTO    "
cabec1 := STR0007	//"CODIGO          DENOMINACAO                      UF       QUANTIDADE      QUANTIDADE   UN                  VALOR"
cabec2 := STR0008	//"PRODUTO                                                       PEDIDA        FATURADA                       TOTAL"
nTipo  := IIF(aReturn[4]=1,GetMV("MV_COMP"),GetMv("MV_NORM"))

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1

//��������������������������������������������������������������Ŀ
//� Define array para arquivo de trabalho                        �
//����������������������������������������������������������������
aTam:=TamSX3("C5_VEND1")
AADD(aCampos,{ "VENDEDOR"   ,"C",aTam[1],aTam[2] } )
//aTam:=TamSX3("A1_EST")
//AADD(aCampos,{ "ESTADO"     ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_PRODUTO")
AADD(aCampos,{ "PRODUTO"    ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_EMISSAO")
AADD(aCampos,{ "EMISSAO"    ,"D",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_VALOR")
AADD(aCampos,{ "VALOR"      ,"N",IIf(aTam[1] > 16,aTam[1],16),IIf(aTam[2] > 2,aTam[2],2) } )
aTam:=TamSX3("C6_QTDVEN")
AADD(aCampos,{ "QUANTIDADE" ,"N",IIf(aTam[1] > 16,aTam[1],16),IIf(aTam[2] > 2,aTam[2],2) } )
aTam:=TamSX3("C6_QTDENT")
AADD(aCampos,{ "ENTREGUE"   ,"N",IIf(aTam[1] > 16,aTam[1],16),IIf(aTam[2] > 2,aTam[2],2) } )
aTam:=TamSX3("C6_GRADE")
AADD(aCampos,{ "GRADE"      ,"C",aTam[1],aTam[2] } )
AADD(aCampos,{ "MOEDA"      ,"N",1,0 } )

//��������������������������������������������������������������Ŀ
//� Cria arquivo de Trabalho                                     �
//����������������������������������������������������������������
cNomArq := CriaTrab(aCampos)
Use &cNomArq Alias TRB   NEW

IndRegua("TRB",cNomArq,"VENDEDOR+PRODUTO",,,STR0009)		//"Selecionando Registros..."
//IndRegua("TRB",cNomArq,"VENDEDOR+PRODUTO+ESTADO",,,STR0009)		//"Selecionando Registros..."
dbSelectArea("SC5")
dbSetOrder(2)
dbSeek(xFilial()+DTOS(mv_par01),.T.)

SetRegua(RecCount())		// Total de Elementos da regua

While !Eof() .And. lContinua .And. C5_EMISSAO >= mv_par01 .And. C5_EMISSAO <= mv_par02 .And. C5_FILIAL == xFilial("SC5")
	
	IF AT(C5_TIPO,"DB") != 0
		DbSkip()
		Loop
	EndIf
	IncRegua()
	
	//��������������������������������������������������������������Ŀ
	//� Verifica se Vendedor devera ser impresso                     �
	//����������������������������������������������������������������
	nCont := 1
	For nI:=1 to 5
		IF SC5->&(EVAL(bVend,nI)) >= mv_par03 .And. SC5->&(EVAL(bVend,nI)) <= mv_par04 ;
			.And. !Empty(SC5->&(EVAL(bVend,nI)))
			cCodVen:=SC5->&(EVAL(bVend,nI))
			GravaTrab(cCodVen,cEstoq,cDupli,@aPedido,nCont)
			nCont+=1
		EndIF
	Next nI
	dbSelectArea("SC5")
	dbSkip()
EndDO

dbSelectArea("TRB")
dbGotop()
nTotGer := 0

While !Eof() .And. lContinua
	
	IF lEnd
		@PROW()+1,001 Psay STR0010		//"CANCELADO PELO OPERADOR"
		lContinua := .F.
		Exit
	Endif
	
	cVend := VENDEDOR
	dbSelectArea("SA3")
	dbSeek(xFilial()+cVend)
	
	IF li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIF
	
	@li,  0 Psay STR0011+ cVend + "  " + SA3->A3_NOME		//"VENDEDOR : "
	li+=2
	
	dbSelectArea("TRB")
	nTotVend := 0
	
	While !Eof() .And. lContinua .And. VENDEDOR == cVend
		
		cProduto = TRB->PRODUTO
		nTotprodq := 0
		nTotProdv := 0
		nCnt      := 0
		While !Eof() .and. lContinua .and. cProduto == TRB->PRODUTO .And. cVend == TRB->VENDEDOR
			
			IF lEnd
				@PROW()+1,001 Psay STR0010	//"CANCELADO PELO OPERADOR"
				lContinua := .F.
				Exit
			Endif
			
			IF li > 55
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
				li+=2
			EndIF
			
			dbSelectArea("SB1")
			dbSeek(xFilial()+TRB->PRODUTO)
			
			@li,  0 Psay IIF(TRB->GRADE == "S" .And. MV_PAR08 == 1,Substr(B1_COD,1,nTamRef),B1_COD)
			@li, 17 Psay Subs(B1_DESC,1,30)
			
			dbSelectArea("TRB")
			
			@li, 49 Psay ESTADO	      Picture "@!"  
			cQuant    := PADL( Transform( QUANTIDADE,PesqPictQt("C6_QTDVEN",16) ), 16 )   			
			@li, 52 Psay cQuant
			cEntregue := PADL( Transform( ENTREGUE  ,PesqPictQt("C6_QTDENT",16) ), 16 )   						
			@li, 68 Psay cEntregue 
			@li, 87 Psay SB1->B1_UM
			@li, 96 Psay VALOR		   Picture PesqPict("SC6","C6_VALOR",16)
			
			li++
			nTotProdq += QUANTIDADE
			nTotProdv += VALOR
			
			nTotVend += VALOR
			
			// Se Total Geral for por Pedido (mv_par13==2) e houver mais de um vendedor no pedido, soma apenas um.
			nPos := AScan(aPedido,{|x| x[1]+x[2]+x[3] == VENDEDOR+PRODUTO})
			//nPos := AScan(aPedido,{|x| x[1]+x[2]+x[3] == VENDEDOR+PRODUTO+ESTADO})			
			If mv_par13 == 1
				nTotQPed += QUANTIDADE 
				nTotQFat += ENTREGUE
				nTotGer1 += VALOR
			ElseIf mv_par13 == 2 .And. nPos > 0
				nTotQPed += aPedido[nPos,4]
				nTotQFat += aPedido[nPos,5]
				nTotGer1 += aPedido[nPos,6]
			EndIf
			
			nCnt+=1
			dbSkip()
		Enddo
		IF li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIF
		If nCnt > 1
			ImpTotPROD(IIF(TRB->GRADE=="S" .And. MV_PAR08 == 1,Substr(cProduto,1,nTamRef),cProduto),nTotProdq,nTotprodv)
		Endif
	EndDO
	
	IF li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIF
	
	ImpTotVend(nTotVend)
	
EndDO

If !Empty( nTotGer1 ) 
	IF li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIF
	li++
	@li,  0 Psay STR0012	//"T O T A L  G E R A L : "
	@li, 52 Psay nTotQPed Picture PesqPict("SC6","C6_QTDVEN",16)
	@li, 68 Psay nTotQFat Picture PesqPict("SC6","C6_QTDENT",16)
	@li, 96 Psay nTotGer1 PicTure PesqPict("SC6","C6_VALOR",16)
EndIF

dbSelectArea("TRB")
If Reccount() > 0
	roda(cbcont,cbtxt,"M")
Endif
dbCloseArea()
FERASE(cNomArq+GetDBExtension())		    //arquivo de trabalho
FERASE(cNomArq+OrdBagExt())    //indice gerado

dbSelectArea("SC5")
dbClearFilter()
dbSetOrder(1)

If aReturn[5] == 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � GRAVATRAB� Autor � Paulo Boschetti       � Data � 23.04.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Grava Novo Registro no arquivo de trabalho                 ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MATR610(void)                                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static FuncTion GravaTrab(cCodVen,cEstoq,cDupli,aPedido,nCont)

Local	cProdRef := ""
Local	nTotQtd  := 0
Local	nTotEnt  := 0
Local	nTotVal  := 0
Local	nReg     := 0
Local	nPos     := 0

dbSelectArea("SA1")
dbSeek(xFilial()+SC5->C5_CLIENTE+SC5->C5_LOJACLI)

dbSelectArea("SC6")
dbSeek(xFilial()+SC5->C5_NUM,.F.)

While !Eof() .And. C6_FILIAL+C6_NUM == xFilial()+SC5->C5_NUM

	//���������������������������������������������Ŀ
	//� Verifica se considera residuo               �
	//�����������������������������������������������
	If mv_par12 == 2 .And. C6_BLQ == "R "
		dbSkip()
		Loop
	EndIf				 	
	
	IF C6_PRODUTO < mv_par05 .Or. C6_PRODUTO > mv_par06
		dbSkip()
		Loop
	EndIF
	//���������������������������������������������Ŀ
	//� Avalia TES a Ser Impresso                   �
	//�����������������������������������������������
	If !AvalTes(C6_TES,cEstoq,cDupli)
		dbSkip()
		Loop
	Endif
	//���������������������������������������������Ŀ
	//� Valida o produto conforme a mascara         �
	//�����������������������������������������������
	lRet:=ValidMasc(SC6->C6_PRODUTO,MV_PAR07)
	If !lRet
		dbSkip()
		Loop
	Endif
	
	IF SC6->C6_GRADE == "S" .And. MV_PAR08 == 1
		cProdRef := Substr(SC6->C6_PRODUTO,1,nTamRef)
		nTotQtd  := 0
		nTotEnt  := 0
		nTotVal  := 0
		nReg     := 0
		While !Eof() .And. xFilial() == C6_FILIAL .And. cProdRef == Substr(SC6->C6_PRODUTO,1,nTamRef) .And.;
			SC6->C6_NUM == SC5->C5_NUM
			nReg:=Recno()
			IF C6_PRODUTO < mv_par05 .Or. C6_PRODUTO > mv_par06
				dbSkip()
				Loop
			EndIF
			//���������������������������������������������Ŀ
			//� Valida o produto conforme a mascara         �
			//�����������������������������������������������
			lRet:=ValidMasc(SC6->C6_PRODUTO,MV_PAR07)
			If !lRet
				dbSkip()
				Loop
			Endif
			nTotVal += xMoeda(SC6->C6_VALOR,SC5->C5_MOEDA,mv_par11,SC5->C5_EMISSAO)
			nTotQtd += SC6->C6_QTDVEN
			nTotEnt += SC6->C6_QTDENT
			dbSkip()
			loop
		End
		If nReg > 0
			dbGoto(nReg)
			nReg:=0
		Endif
	Endif

	// Se Total Geral for por Pedido (mv_par13==2) e houver mais de um vendedor no pedido, soma apenas um.
	nPos := AScan(aPedido,{|x| x[1]+x[2]+x[3] == cCodVen+SC6->C6_PRODUTO+SA1->A1_EST})	
	If mv_par13 == 2 .And. nCont == 1
		If nPos == 0
			//AADD(aPedido,{cCodVen,SC6->C6_PRODUTO,SA1->A1_EST,IIF(SC6->C6_GRADE=="S" .And. MV_PAR08 == 1,nTotQtd,SC6->C6_QTDVEN),IIF(SC6->C6_GRADE=="S" .And. MV_PAR08 == 1,nTotEnt,SC6->C6_QTDENT),IIF(SC6->C6_GRADE=="S" .And. MV_PAR08 == 1,nTotVal,xMoeda(SC6->C6_VALOR,SC5->C5_MOEDA,mv_par11,SC5->C5_EMISSAO))})
			AADD(aPedido,{cCodVen,SC6->C6_PRODUTO,IIF(SC6->C6_GRADE=="S" .And. MV_PAR08 == 1,nTotQtd,SC6->C6_QTDVEN),IIF(SC6->C6_GRADE=="S" .And. MV_PAR08 == 1,nTotEnt,SC6->C6_QTDENT),IIF(SC6->C6_GRADE=="S" .And. MV_PAR08 == 1,nTotVal,xMoeda(SC6->C6_VALOR,SC5->C5_MOEDA,mv_par11,SC5->C5_EMISSAO))})
		ElseIf nPos > 0
			aPedido[nPos,4] += IIF(SC6->C6_GRADE=="S" .And. MV_PAR08 == 1,nTotQtd,SC6->C6_QTDVEN)
			aPedido[nPos,5] += IIF(SC6->C6_GRADE=="S" .And. MV_PAR08 == 1,nTotEnt,SC6->C6_QTDENT)
			aPedido[nPos,6] += IIF(SC6->C6_GRADE=="S" .And. MV_PAR08 == 1,nTotVal,xMoeda(SC6->C6_VALOR,SC5->C5_MOEDA,mv_par11,SC5->C5_EMISSAO))
		EndIf	
	EndIf	
	

	dbSelectArea("TRB")
	dbSeek(cCodVen+SC6->C6_PRODUTO+SA1->A1_EST)
	IF !Found()
		RecLock("TRB",.t.)
		REPLACE VENDEDOR   With cCodVen
		//REPLACE ESTADO     With SA1->A1_EST
		REPLACE PRODUTO    With SC6->C6_PRODUTO
	Else
		RecLock("TRB",.f.)
	EndIF
	
	REPLACE VALOR	   With  VALOR      +IIF(SC6->C6_GRADE=="S" .And. MV_PAR08 == 1,nTotVal,xMoeda(SC6->C6_VALOR,SC5->C5_MOEDA,mv_par11,SC5->C5_EMISSAO))
	REPLACE QUANTIDADE With  QUANTIDADE +IIF(SC6->C6_GRADE=="S" .And. MV_PAR08 == 1,nTotQtd,SC6->C6_QTDVEN)
	REPLACE ENTREGUE   With  ENTREGUE   +IIF(SC6->C6_GRADE=="S" .And. MV_PAR08 == 1,nTotEnt,SC6->C6_QTDENT)
	REPLACE GRADE      With  SC6->C6_GRADE
	REPLACE MOEDA      With  SC5->C5_MOEDA
	MsUnlock()
	

	
	dbSelectArea("SC6")
	dbSkip()
	
EndDO

dbSelectArea("SC5")

Return .T.

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �IMPTOTVEND� Autor � Paulo Boschetti       � Data � 23.04.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao totalizacao do vendedor                          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MATR610(void)                                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
STATIC FUNCTION IMPTOTVEND(nTotVend)
li++
@li,  0 Psay STR0013	+ cVend		//"TOTAL VENDEDOR ---> "
@li, 96 Psay nTotVend	   	   PicTure  PesqPict("SC6","C6_VALOR",16)
li:=80
Return .T.
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �IMPTOTPROD� Autor � Paulo Boschetti       � Data � 23.04.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime total do produto                                   ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
STATIC FUNCTION IMPTOTPROD(cProd,nQtd,nVal)

@li,  0 Psay STR0014 + cProd		//"TOTAL PRODUTO  ---> "
@li, 52 Psay nQtd           Picture  PesqPictQt("C6_QTDVEN",16)
@li, 96 Psay nVal           PicTure  PesqPict("SC6","C6_VALOR",16)
li+=2
dbSelectArea("TRB")
Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AjustaSX1 �Autor  �                    � Data � 06/04/2006  ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AjustaSX1()

Local aHelpPor := {}
Local aHelpSpa := {}
Local aHelpEng := {}

If cPaisLoc<>"BRA"
	SX1->(dbSetOrder(1))
	If SX1->(DbSeek("MTR61001"))
		RecLock("SX1",.F.)
		Replace SX1->X1_PERSPA With "�De Fecha ?"
		Replace SX1->X1_PERENG With "From Date ?"
		SX1->(MsUnLock())
		SX1->(DbCommit())
	Endif
Endif

AADD(aHelpPor,"Informe se ser�o considerados pedidos   ")
AADD(aHelpPor,"com res�duos eliminados (Sim) ou se os  ")
AADD(aHelpPor,"mesmos n�o ser�o considerados na        ")
AADD(aHelpPor,"sele��o (N�o).                          ")
AADD(aHelpSpa,"Informa habr� sido considerado pedidos" )
AADD(aHelpSpa,"con residuos eliminados (s�) o si iguales" )
AADD(aHelpSpa,"unos no son consideradas en la" )
AADD(aHelpSpa,"selecci�n (no). " ) 
AADD(aHelpEng,"It informs will have been considered sales")
AADD(aHelpEng,"orders with eliminated residues (Yes) or")
AADD(aHelpEng,"if the same ones will not be considered in")
AADD(aHelpEng,"selection (Not).")
PutSx1('MTR610', '12', 'Considera Res�duos?', '�Considera residuo ?', 'Consider Residue ?', 'mv_chc', 'N', 1, 0, 1, 'C', '', '', '', '', 'mv_par10', 'Sim' 				   , 'Sim'					   , 'Sim'					 , '', 'N�o'		  , 'N�o'		  , 'N�o'		  ,'','','','','','','','','',aHelpPor,aHelpEng,aHelpSpa)
PutSX1Help("P.MTR61012.",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor := {}
aHelpSpa := {}
aHelpEng := {}
AADD(aHelpPor,"Por vendedor: Soma os totais dos vende- ")
AADD(aHelpPor,"dores.")
AADD(aHelpPor,"Por pedido: Caso dois vendedores sejam")
AADD(aHelpPor,"informados no mesmo pedido, valor do ")
AADD(aHelpPor,"pedido sera somado apenas 1 vez.")

AADD(aHelpSpa,"Para el vendedor: la suma total de " )
AADD(aHelpSpa,"los vendedores." )
AADD(aHelpSpa,"Por pedido: el caso de que dos proveedo-" )
AADD(aHelpSpa,"res se les informa a el mismo pedido, el" )
AADD(aHelpSpa,"valor del pedido debe ser a�adido s�lo " )
AADD(aHelpSpa,"1 vez." )

AADD(aHelpEng,"For seller: the sum total of sellers.")
AADD(aHelpEng,"By sales order: If two vendors are in-")
AADD(aHelpEng,"formed in the same sales order, the re-")
AADD(aHelpEng,"quest would be value added only 1 time.")
PutSx1('MTR610', '13', 'Total Geral por?', 'Total General por', 'Grand Total for', 'mv_chd', 'N', 1, 0, 1, 'C', '', '', '', '', 'mv_par13', 'Vendedor','Vendedor','Seller', '', 'Pedido','Pedido','Sales Order','','','','','','','','','',aHelpPor,aHelpEng,aHelpSpa)
PutSX1Help("P.MTR61013.",aHelpPor,aHelpEng,aHelpSpa)


Return
