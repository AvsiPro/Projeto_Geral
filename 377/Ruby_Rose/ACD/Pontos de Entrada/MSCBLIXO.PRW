#INCLUDE 'PROTHEUS.CH'  

/*/{Protheus.doc}	ACD PONTO DE ENTRADA MSCBLIXO PARA SPOOL DE IMPRESS�O PELO 

@author			Paulo Lima 
@since			11/12/2021
@version		1.0
@return			Logico (.t. ou .f.)

� acionado ao entrar na lixeira e seu retorno .f. bloqueia o uso da lixeira.
Return esperado:= Logico (True habilita lixeira, Bloqueia a Lixeira)

/*/

///////////////////////////////////////////////////////////////////////////////
//PONTO DE ENTRADA MSCBLIXO                                                  //
///////////////////////////////////////////////////////////////////////////////

User Function MSCBLIXO()
Local lRet := .t. //.F.

Alert ("N�o esquecer de bloquear a Lixeira") //Alert ("Lixeira Bloqueada")

Return lRet
