#include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"
#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	MA410MNU
// Autor 		Alexandre Venancio
// Data 		28/07/2015
// Descricao  	Ponto de entrada no menu dos pedidos de venda
// 				
// 				
// Uso         	
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MA410MNU()

aAdd(aRotina,{"Informações de Frete"			,	"U_ROBFAT01()"	,0,2,0,NIL})
aAdd(aRotina,{"Liberações"			            ,	"U_ROBFAT05()"	,0,2,0,NIL})
aAdd(aRotina,{"Tit. em Aberto"	    	        ,	"U_ROBFAT09()"	,0,2,0,NIL})
aAdd(aRotina,{"Liberacao de Pedido"	    	    ,	"U_ROBFAT11()"	,0,2,0,NIL})
aAdd(aRotina,{"Alterar Vendedor"	    	    ,	"U_ROBFAT12()"	,0,2,0,NIL})
AAdd(aRotina,{"Log Alteração"                   ,   "U_ROBGEN12('SC5',SC5->C5_NUM,'SC6')", 2, 0 } )

return 
