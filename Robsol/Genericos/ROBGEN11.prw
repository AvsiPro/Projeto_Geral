#Include "Rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ROBGEN11  �Autor  �Alexandre Venancio  � Data �  28/02/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina de gravacao de logs de transacoes.                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ROBGEN11(xFil,Modulo,TipoMov,Prefixo,Docto,Serie,UserMov,DiaMov,HoraMov,Valor,Obs,cCli,cLoja,cTabela)

Local aArea	:= 	GetArea()

	Reclock("SZL",.T.)   
	SZL->ZL_FILIAL	:= xFil
	SZL->ZL_MODULO 	:= Modulo			  						//20	Caracter
	SZL->ZL_TIPOMOV := TipoMov 									//20	Caracter
	SZL->ZL_PREFIXO := Prefixo									//3		Caracter
	SZL->ZL_DOCTO   := Docto				   					//15	Caracter
	SZL->ZL_SERIE  	:= Serie									//3		Caracter
	SZL->ZL_USUARIO := UserMov									//15	Caracter
	SZL->ZL_DATA    := stod(DiaMov)								//8		Data
	SZL->ZL_HORA    := substr(HoraMov,1,5)						//5		Caracter
	SZL->ZL_VALOR  	:= Valor									//15	Num�rico
	SZL->ZL_OBS    	:= Obs										//150	Caracter
	SZL->ZL_CLIENTE	:= cCli           							//6		Caracter
	SZL->ZL_LOJA	:= cLoja	                				//4		Caracter   
	SZL->ZL_TABELA	:= cTabela									//3 	Caracter
	SZL->(MsUnLock())

RestArea(aArea)

Return
