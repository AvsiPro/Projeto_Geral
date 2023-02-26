#Include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ROBGEN11  ºAutor  ³Alexandre Venancio  º Data ³  28/02/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de gravacao de logs de transacoes.                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
	SZL->ZL_VALOR  	:= Valor									//15	Numérico
	SZL->ZL_OBS    	:= Obs										//150	Caracter
	SZL->ZL_CLIENTE	:= cCli           							//6		Caracter
	SZL->ZL_LOJA	:= cLoja	                				//4		Caracter   
	SZL->ZL_TABELA	:= cTabela									//3 	Caracter
	SZL->(MsUnLock())

RestArea(aArea)

Return
