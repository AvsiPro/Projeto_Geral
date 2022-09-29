#include "rwmake.ch"

/*                                                                                    
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    �CTBxFun � Biblioteca de Funcoes genericas utilizadas nos lancamentos    ���
���             �        � padroes.                                                      ���
�����������������������������������������������������������������������������������������͹��
��� Observacoes � Aqui devem ser incluidas apenas as funcoes que serao utilizadas         ���
���             � nos lancamentos padroes.                                                ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/


/*
�������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������ͻ��
��� Fun��o        � IMPRET       � Autor �    TOTVS                 � Data � 01/09/2009 ���
���������������������������������������������������������������������������������������͹��
��� Descricao     � Retorna o valor do imposto retido de acordo com o tipo do titulo    ���
���               � IS-, IR-, PI-, CF-, CS-                                             ���
���               � Recebe o tipo do imposto (IS-, IR-, PI-, CF-, CS-)                  ���
���               � Retorna o valor do imposto retido                                   ���
�������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������Ĵ��
���Retorno   � Valor do Imposto.                                                        ���
���������������������������������������������������������������������������������������Ĵ��
��� Uso      � Lancamento Padrao Financeiro contas a receber                            ���
����������������������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������������������
��������������������������������������������������������������������������������������������
*/

User Function ImpRet( _cImpRet )

Local _aAreaE1	:= SE1->(GetArea())

Local _cPrefixo := SE1->E1_PREFIXO
Local _cNum     := SE1->E1_NUM
Local _cParcela := SE1->E1_PARCELA
Local _nValor	:= 0.00

If !cEmpAnt $ "01/02"
	Return
EndIF

SE1->(DbSetOrder(1))
If SE1->(DbSeek(xFilial("SE1")+_cPrefixo+_cNum+_cParcela+_cImpRet,.t.))

   _nValor := SE1->E1_VALOR
		
EndIf

RestArea(_aAreaE1)

Return _nValor


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � LPADTO   � Autor � Marciane Gennari   � Data �  25/09/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Programa para buscar os campos corretos dos titulos em     ���
���          � Compensacao (pagar ou receber)                             ���
�������������������������������������������������������������������������͹��
���Uso       �  Adiantamento Cliente / Fornecedor                         ���
�������������������������������������������������������������������������ͼ��
��  _Carteira --> "R" - Receber ou "P" - Pagar                             ��
��  _Chavetit --> SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO) ��
��  _Documen  --> SE5->E5_DOCUMEN                                          ��
��  _TipoTit  --> SE5->E5_TIPO                                             ��
��  _Campo    --> "E1_MSEMP" --> Nome do campo para retornar conteudo      ��
��  _Devolver --> Tipo do t�tulo que quer devolver a informacao RA/NCC/PA  ��
��                NF                                                       ��
��  _AdtForCli --> Codigo Fornecedor + Codigo Loja para contas a pagar     ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function LPADTO(_Carteira,_ChaveTit,_Documen,_TipoTit,_Campo,_Devolver,_ADTFORCLI)

Local aArea      := GetArea()
Local _aAreaSE1  := SE1->(GetArea())
Local _aAreaSE2  := SE2->(GetArea())
Local _Retorno   := ""
Local _tamanho   := 0


_Tamanho += TamSX3('E5_PREFIXO')[1]
_Tamanho += TamSX3('E5_NUMERO')[1]
_Tamanho += TamSX3('E5_PARCELA')[1]
_Tamanho += TamSX3('E5_TIPO')[1]


Do Case
	Case _Carteira == "R" .AND. Trim(_TipoTit) $ "RA/NCC" .and. !(TRIM(_Devolver) $ "RA/NCC") 
		// Estou posicionado no RA ou NCC (SE5) e � para devolver os dados da NF,ETC (SE1).

		DbSelectArea("SE1")
		DbSetOrder(1)
		DbSeek(xFilial("SE1")+SUBSTR(_Documen,1,_Tamanho))
		
		_Retorno := SE1->(FIELDGET(FIELDPOS(_Campo)))

	Case _Carteira == "R" .AND. Trim(_TipoTit) $ "RA/NCC" .and. TRIM(_Devolver) $ "RA/NCC"
		// Estou posicionado no RA ou NCC (SE5) e � para devolver os dados da RA/NCC (SE1).
	
		DbSelectArea("SE1")
		DbSetOrder(1)
		DbSeek(xFilial("SE1")+SUBSTR(_ChaveTit,3,_Tamanho))
		_Retorno := SE1->(FIELDGET(FIELDPOS(_Campo)))
		
	Case _Carteira == "R" .AND. !(Trim(_TipoTit) $ "RA/NCC") .and. !TRIM(_Devolver) $ "RA/NCC"
		// Estou posicionado nos titulos de NF,etc. e � para devolver os dados da NF,etc.

		DbSelectArea("SE1")
		DbSetOrder(1)
		DbSeek(xFilial("SE1")+SUBSTR(_ChaveTit,3,_Tamanho))
		_Retorno := SE1->(FIELDGET(FIELDPOS(_Campo)))
	
	Case _Carteira == "R" .AND. !(Trim(_TipoTit) $ "RA/NCC") .and. (TRIM(_Devolver) $ "RA/NCC")
		// Estou posicionado nos titulos de NF,etc.(SE5) e � para devolver os dados da RA/NCC (SE1).
	
		DbSelectArea("SE1")
		DbSetOrder(1)
		DbSeek(xFilial("SE1")+SUBSTR(_Documen,1,_Tamanho))
		
		_Retorno := SE1->(FIELDGET(FIELDPOS(_Campo)))
		
	Case _Carteira == "P" .AND. Trim(_TipoTit) $ "PA/NDF" .and. !(TRIM(_Devolver) $ "PA/NDF") 
		// Estou posicionado no PA ou NDF (SE5) e � para devolver os dados da NF,ETC (SE2).

		DbSelectArea("SE2")
		DbSetOrder(1)
		DbSeek(xFilial("SE2")+SUBSTR(_Documen,1,_Tamanho)+_ADTFORCLI)
		
		_Retorno := SE2->(FIELDGET(FIELDPOS(_Campo)))
	
	Case _Carteira == "P" .AND. Trim(_TipoTit) $ "PA/NDF" .and. (TRIM(_Devolver) $ "PA/NDF") 
		// Estou posicionado no PA ou NDF (SE5) e � para devolver os dados da PA/NDF (SE2).
	
		DbSelectArea("SE2")
		DbSetOrder(1)
		DbSeek(xFilial("SE2")+SUBSTR(_ChaveTit,3,_Tamanho)+_ADTFORCLI)

		_Retorno := SE2->(FIELDGET(FIELDPOS(_Campo)))

	Case _Carteira == "P" .AND. !(Trim(_TipoTit) $ "PA/NDF") .and. !(TRIM(_Devolver) $ "PA/NDF") 
		// Estou posicionado nos titulos de NF,etc. (SE5) e � para devolver os dados da NF,etc (SE2).

		DbSelectArea("SE2")
		DbSetOrder(1)
		DbSeek(xFilial("SE2")+SUBSTR(_ChaveTit,3,_Tamanho)+_ADTFORCLI)

		_Retorno := SE2->(FIELDGET(FIELDPOS(_Campo)))
	
	Case _Carteira == "P" .AND. !(Trim(_TipoTit) $ "PA/NDF") .and. (TRIM(_Devolver) $ "PA/NDF")
		// Estou posicionado nos titulos de NF,etc. (SE5) e � para devolver os dados da PA/NDF( SE2).
	
		DbSelectArea("SE2")
		DbSetOrder(1)
		DbSeek(xFilial("SE2")+SUBSTR(_Documen,1,_Tamanho)+_ADTFORCLI)
		
		_Retorno := SE2->(FIELDGET(FIELDPOS(_Campo)))

	OtherWise
		_Retorno := "Ver conta"
EndCase

RestArea(_aAreaSE1)
RestArea(_aAreaSE2)
RestArea(aArea)

Return(_Retorno)

          
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � LpCtaNat  � Autor � Marciane Gennari   � Data �  14/10/09  ���
�������������������������������������������������������������������������͹��
���Descricao � Programa que executa a fun��o LPADTO para retornar a conta ���
���          � da natureza para Compensacao (pagar ou receber)            ���
�������������������������������������������������������������������������͹��
���Uso       �  LPs Adiantamento Cliente / Fornecedor                     ���
�������������������������������������������������������������������������ͼ��
��  _cCart --> "R" - Receber ou "P" - Pagar                                ��
��  _cTipo --> Tipo do titulo para receber o retorno dos dados, sendo RA   ��
��             ou NCC ou PA ou NDF ou NF ou outros tipos de titulos        ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function LpCtaNat(_cCart,_cTipo)
   
Local _cRetorno := ""
Local _cNaturez := ""
 
If _cCart == "R"
   _cNaturez := U_LPADTO(_cCart,SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO),SE5->E5_DOCUMEN,SE5->E5_TIPO,"E1_NATUREZ",_cTipo,"")
Else
   _cNaturez := U_LPADTO(_cCart,SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO),SE5->E5_DOCUMEN,SE5->E5_TIPO,"E2_NATUREZ",_cTipo,SE5->E5_CLIFOR+SE5->E5_LOJA)
EndIf       

_cRetorno := GETADVFVAL("SED","ED_CONTA",XFILIAL("SED")+_cNaturez,1)
                                                                                                                                                                                                                                                                                                                           
Return(_cRetorno)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LPHT01    �Autor  �Microsiga           � Data �  12/10/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �USADO NOS LANCAMENTOS PADROES                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
  
User Function LPHT01()

_chist := IF(ALLTRIM(SE2->E2_TIPO)$"TX /INS/ISS",ALLTRIM(GETADVFVAL("SA2","A2_NOME",xFilial("SA2")+SE2->E2_FORORI+SE2->E2_LOJORI,1))+" "+ALLTRIM(GETADVFVAL("SA2","A2_CGC",xFilial("SA2")+SE2->E2_FORORI+SE2->E2_LOJORI,1)),ALLTRIM(SA2->A2_NOME))                  

Return(_chist)



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LPHT02    �Autor  �Microsiga           � Data �  12/10/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �USADO NOS LANCAMENTOS PADROES                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
  
User Function LPHT02()

_chist := IF(ALLTRIM(SE2->E2_TIPO)$"TX /INS/ISS/FOL".OR.SE2->E2_PREFIXO=="GPE",ALLTRIM(GETADVFVAL("SED","ED_DESCRIC",XFILIAL("SED")+SE2->E2_NATUREZ,1)),ALLTRIM(SE2->E2_TIPO))                                                                                      

Return(_chist)
