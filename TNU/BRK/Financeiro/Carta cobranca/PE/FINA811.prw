#include 'protheus.ch'
#include 'parmtype.ch'

user function FINA811()

nOpcAuto := 0

a811Param := {}

a811Param := {{""},;//cliente DE
			  {""},;//Loja De     
			  {"999999"},;//Cliente Ate
			  {"99"},;//Loja Ate
			  {ctod("//")},;//Emissao De
			  { date()},;//Emissao Ate
			  { date()},;//Data Referencia
			  {0},;//Valor de
			  {100000},;//Valor Ate
			  {"2"},;// IMPORTANTE:  SEMPRE 2 PARA N�O APRESENTAR TELA DE SELE��O DE FILIAIS
			  {"1"},;//T�tulos a vencer (tipo caracter  sendo "1" = Sim ou "2" = N�o)
			  {"1"},;//Considera valor (tipo caracter sendo "1" = Total ou  "2" = Saldo)
			  {"2"},;// IMPORTANTE: SEMPRE 2 PARA N�O APRESENTAR TELA DE SELE��O DE SITUA��O DE COBRAN�A
			  {{}},;//IMPORTANTE: ENVIAR ARRAY VAZIO
			  {""},;//IMPORTANTE: SEMPRE VAZIO
			  {"000001"}}// C�digo do layout da carta a ser utilizado (tipo caracter)
	
return a811Param
