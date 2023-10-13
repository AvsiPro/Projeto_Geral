#Include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³JCAGEN01 ºAutor  ³Alexandre Venancio  º Data ³  24/09/23   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de gravacao de logs de transacoes.                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function JGENX001(xFil,Modulo,TipoMov,Prefixo,Docto,cItem,UserMov,DiaMov,HoraMov,Valor,Obs,cCli,cLoja,cTabela,nQtdAtu,nVlTotA,nVlAnt,nQtdAnt,nTotAnt)

Local aArea	:= 	GetArea()

	Reclock("SZL",.T.)   
	SZL->ZL_FILIAL		:= xFil
	SZL->ZL_MODULO 		:= Modulo			  						//20	Caracter
	SZL->ZL_TIPOMOV 	:= TipoMov 									//20	Caracter
	SZL->ZL_PREFIXO 	:= Prefixo									//3		Caracter
	SZL->ZL_DOCTO   	:= Docto				   					//15	Caracter
	SZL->ZL_ITEM  		:= cItem									//4		Caracter
	SZL->ZL_USUARIO 	:= UserMov									//15	Caracter
	SZL->ZL_DATA    	:= DiaMov								//8		Dat
	SZL->ZL_HORA    	:= substr(HoraMov,1,5)						//5		Caracter
	SZL->ZL_VALOR  		:= Valor									//15	Numérico
	SZL->ZL_OBS    		:= Obs										//150	Caracter
	SZL->ZL_CLIENTE		:= cCli           							//6		Caracter
	SZL->ZL_LOJA		:= cLoja	                				//4		Caracter   
	SZL->ZL_TABELA		:= cTabela									//3 	Caracter
	SZL->ZL_QTD 		:= nQtdAtu
	SZL->ZL_TOTAL		:= nVlTotA
	SZL->ZL_VLRANT		:= nVlAnt
	SZL->ZL_QTDANT 		:= nQtdAnt
	SZL->ZL_TOTLANT		:= nTotAnt
	SZL->(MsUnLock())

RestArea(aArea)

Return
