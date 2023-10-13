#Include "Rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �JCAGEN01 �Autor  �Alexandre Venancio  � Data �  24/09/23   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina de gravacao de logs de transacoes.                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
	SZL->ZL_VALOR  		:= Valor									//15	Num�rico
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
