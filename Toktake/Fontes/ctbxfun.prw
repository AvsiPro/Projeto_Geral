#include "rwmake.ch"

/*                                                                                    
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa    ³CTBxFun ³ Biblioteca de Funcoes genericas utilizadas nos lancamentos    º±±
±±º             ³        ³ padroes.                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Observacoes ³ Aqui devem ser incluidas apenas as funcoes que serao utilizadas         º±±
±±º             ³ nos lancamentos padroes.                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±³ Fun‡…o        ³ IMPRET       ³ Autor ³    TOTVS                 ³ Data ³ 01/09/2009 ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Descricao     ³ Retorna o valor do imposto retido de acordo com o tipo do titulo    º±±
±±º               ³ IS-, IR-, PI-, CF-, CS-                                             º±±
±±º               ³ Recebe o tipo do imposto (IS-, IR-, PI-, CF-, CS-)                  º±±
±±º               ³ Retorna o valor do imposto retido                                   º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Valor do Imposto.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Lancamento Padrao Financeiro contas a receber                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LPADTO   º Autor ³ Marciane Gennari   º Data ³  25/09/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa para buscar os campos corretos dos titulos em     º±±
±±º          ³ Compensacao (pagar ou receber)                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³  Adiantamento Cliente / Fornecedor                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±  _Carteira --> "R" - Receber ou "P" - Pagar                             ±±
±±  _Chavetit --> SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO) ±±
±±  _Documen  --> SE5->E5_DOCUMEN                                          ±±
±±  _TipoTit  --> SE5->E5_TIPO                                             ±±
±±  _Campo    --> "E1_MSEMP" --> Nome do campo para retornar conteudo      ±±
±±  _Devolver --> Tipo do título que quer devolver a informacao RA/NCC/PA  ±±
±±                NF                                                       ±±
±±  _AdtForCli --> Codigo Fornecedor + Codigo Loja para contas a pagar     ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
		// Estou posicionado no RA ou NCC (SE5) e é para devolver os dados da NF,ETC (SE1).

		DbSelectArea("SE1")
		DbSetOrder(1)
		DbSeek(xFilial("SE1")+SUBSTR(_Documen,1,_Tamanho))
		
		_Retorno := SE1->(FIELDGET(FIELDPOS(_Campo)))

	Case _Carteira == "R" .AND. Trim(_TipoTit) $ "RA/NCC" .and. TRIM(_Devolver) $ "RA/NCC"
		// Estou posicionado no RA ou NCC (SE5) e é para devolver os dados da RA/NCC (SE1).
	
		DbSelectArea("SE1")
		DbSetOrder(1)
		DbSeek(xFilial("SE1")+SUBSTR(_ChaveTit,3,_Tamanho))
		_Retorno := SE1->(FIELDGET(FIELDPOS(_Campo)))
		
	Case _Carteira == "R" .AND. !(Trim(_TipoTit) $ "RA/NCC") .and. !TRIM(_Devolver) $ "RA/NCC"
		// Estou posicionado nos titulos de NF,etc. e é para devolver os dados da NF,etc.

		DbSelectArea("SE1")
		DbSetOrder(1)
		DbSeek(xFilial("SE1")+SUBSTR(_ChaveTit,3,_Tamanho))
		_Retorno := SE1->(FIELDGET(FIELDPOS(_Campo)))
	
	Case _Carteira == "R" .AND. !(Trim(_TipoTit) $ "RA/NCC") .and. (TRIM(_Devolver) $ "RA/NCC")
		// Estou posicionado nos titulos de NF,etc.(SE5) e é para devolver os dados da RA/NCC (SE1).
	
		DbSelectArea("SE1")
		DbSetOrder(1)
		DbSeek(xFilial("SE1")+SUBSTR(_Documen,1,_Tamanho))
		
		_Retorno := SE1->(FIELDGET(FIELDPOS(_Campo)))
		
	Case _Carteira == "P" .AND. Trim(_TipoTit) $ "PA/NDF" .and. !(TRIM(_Devolver) $ "PA/NDF") 
		// Estou posicionado no PA ou NDF (SE5) e é para devolver os dados da NF,ETC (SE2).

		DbSelectArea("SE2")
		DbSetOrder(1)
		DbSeek(xFilial("SE2")+SUBSTR(_Documen,1,_Tamanho)+_ADTFORCLI)
		
		_Retorno := SE2->(FIELDGET(FIELDPOS(_Campo)))
	
	Case _Carteira == "P" .AND. Trim(_TipoTit) $ "PA/NDF" .and. (TRIM(_Devolver) $ "PA/NDF") 
		// Estou posicionado no PA ou NDF (SE5) e é para devolver os dados da PA/NDF (SE2).
	
		DbSelectArea("SE2")
		DbSetOrder(1)
		DbSeek(xFilial("SE2")+SUBSTR(_ChaveTit,3,_Tamanho)+_ADTFORCLI)

		_Retorno := SE2->(FIELDGET(FIELDPOS(_Campo)))

	Case _Carteira == "P" .AND. !(Trim(_TipoTit) $ "PA/NDF") .and. !(TRIM(_Devolver) $ "PA/NDF") 
		// Estou posicionado nos titulos de NF,etc. (SE5) e é para devolver os dados da NF,etc (SE2).

		DbSelectArea("SE2")
		DbSetOrder(1)
		DbSeek(xFilial("SE2")+SUBSTR(_ChaveTit,3,_Tamanho)+_ADTFORCLI)

		_Retorno := SE2->(FIELDGET(FIELDPOS(_Campo)))
	
	Case _Carteira == "P" .AND. !(Trim(_TipoTit) $ "PA/NDF") .and. (TRIM(_Devolver) $ "PA/NDF")
		// Estou posicionado nos titulos de NF,etc. (SE5) e é para devolver os dados da PA/NDF( SE2).
	
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LpCtaNat  º Autor ³ Marciane Gennari   º Data ³  14/10/09  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa que executa a função LPADTO para retornar a conta º±±
±±º          ³ da natureza para Compensacao (pagar ou receber)            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³  LPs Adiantamento Cliente / Fornecedor                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±  _cCart --> "R" - Receber ou "P" - Pagar                                ±±
±±  _cTipo --> Tipo do titulo para receber o retorno dos dados, sendo RA   ±±
±±             ou NCC ou PA ou NDF ou NF ou outros tipos de titulos        ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LPHT01    ºAutor  ³Microsiga           º Data ³  12/10/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³USADO NOS LANCAMENTOS PADROES                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
  
User Function LPHT01()

_chist := IF(ALLTRIM(SE2->E2_TIPO)$"TX /INS/ISS",ALLTRIM(GETADVFVAL("SA2","A2_NOME",xFilial("SA2")+SE2->E2_FORORI+SE2->E2_LOJORI,1))+" "+ALLTRIM(GETADVFVAL("SA2","A2_CGC",xFilial("SA2")+SE2->E2_FORORI+SE2->E2_LOJORI,1)),ALLTRIM(SA2->A2_NOME))                  

Return(_chist)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LPHT02    ºAutor  ³Microsiga           º Data ³  12/10/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³USADO NOS LANCAMENTOS PADROES                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
  
User Function LPHT02()

_chist := IF(ALLTRIM(SE2->E2_TIPO)$"TX /INS/ISS/FOL".OR.SE2->E2_PREFIXO=="GPE",ALLTRIM(GETADVFVAL("SED","ED_DESCRIC",XFILIAL("SED")+SE2->E2_NATUREZ,1)),ALLTRIM(SE2->E2_TIPO))                                                                                      

Return(_chist)
