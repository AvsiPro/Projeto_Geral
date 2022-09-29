/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A010TOK   ºAutor  ³Jackson E. de Deus  º Data ³  08/02/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE utilizado na inclusão e alteração do produto            º±±
±±º          ³ validação de dados ao clicar no botão OK                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function A010TOK()

Local lExecuta	:= .T.
Local cCodEAN	:= Alltrim(M->B1_CODBAR)


/*--------------------------------------------------------------------------------------+ 		    			           
|São admissíveis 0, 8, 12, 13 ou 14 caracteres.											| 
|Assim, nenhuma nota será rejeitada por não informar os códigos, ou por informar um	| 
|código incorreto.																		|
+---------------------------------------------------------------------------------------*/
  

If Len(cCodEAN) != 0 .And. Len(cCodEAN) != 13 .And. Len(cCodEAN) != 14
	Aviso("A010TOK","Código EAN inválido! - Corrigir para prosseguir.", {"Ok"},1) 
	lExecuta := .F.
Else 
	lExecuta := .T.
EndIf
If cEmpAnt == "01"
	//CHAMADA PARA GRAVACAO DE LOG NA ALTERACAO DE CADASTRO DE PRODUTOS	 - Alexandre 25/02/14	
	IF ALTERA .AND. lExecuta
		U_TTGENC05("SB1")
	EndIf       
EndIF

Return (lExecuta)