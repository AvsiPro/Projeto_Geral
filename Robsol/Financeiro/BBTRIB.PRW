#include "rwmake.ch"

/*
+-----------+------------+----------------+-------------------+-------+---------------+
| Programa  | OCONR001   | Desenvolvedor  | Daiana Andrade    | Data  | 22/03/2011    |
+-----------+------------+----------------+-------------------+-------+---------------+
| Descricao | Fun??o criada para montar Seguimento N - Impostos                       |
+-----------+-------------------------------------------------------------------------+
| Retorno   |  cTrb                                                                   |
+-----------+-------------------------------------------------------------------------+
| Modulos   | SIGAFIN                                                                 |
+-----------+-------------------------------------------------------------------------+
| Processos | REMESSA DE PAGAMENTO AO BANCO do brasil                           |
+---------- +-------------+-----------------------------------------------------------+
| DATA      | PROGRAMADOR | MOTIVO                                                    |
+-----------+-------------+-----------------------------------------------------------+
|CAMPOS     | E2_XCODREC, E2_XCOMP, E2_XATUMON, E2_E_VLENT                            |
+-----------+-------------+-----------------------------------------------------------+


*/           
User Function BBTRIB                           

	Private cTributo 	:= ""
	
	Private cTrb 		:= space(120)
	
	Do Case
		Case SEA->EA_MODELO = "17" //GPS
				cTrb :=	padl(alltrim(SE2->E2_XCODREC),6,"0");//STRZERO(VAL(SE2->E2_XCODREC),6);//codigo pagamento Pos.111 116
					//+STRZERO("1",2);//codigo pagamento Pos. 117-118				
					//+StrZero(ALLTRIM(SM0->M0_CGC),14,"0"); //identifica??o do contribuite 119-132 
					+padl("1",2," ");
					+SUBSTR(SM0->M0_CGC,1,14);                                                                                                                                                                                                                       
					+"17"; //133 134
					+StrZero(VAL(SE2->E2_XCOMP),6);//mes ano da competencia Pos. 135 -140
					+STRZERO((SE2->E2_VALOR)*100,14);//Valor Principal Pos. 141 - 155
					+STRZERO((SE2->E2_E_VLENT)*100,14);//valor de outras entidades Pos. 156 - 170
					+STRZERO((SE2->E2_XATUMON)*100,14);//atualiza??o monet?ria Pos. 171 185
					+SPACE(45) //Informa?oes complemetares, deve ir em branco Pos.186- 23				                  
		Case SEA->EA_MODELO = "16" //DARF NORMAL   
			//dDatApur := FirstDate(SE2->E2_VENCREA)-1		
			cTrb := padl(alltrim(SE2->E2_XCODREC),6,"0");//codigo pagamento Pos.111 116
					+padl("1",2," ");//codigo pagamento Pos. 117-118				
					+SUBSTR(SM0->M0_CGC,1,14); //identifica??o do contribuite 119-132     
					+"16"; //133 134
					+GRAVADATA(SE2->E2_XDTAPU,.F.,5);//Per?do de Apura??o Pos. 135 - 142
					+STRZERO(VAL(SE2->E2_XNRREF),16); //- Idenfitica??o do FGTS Pos. 143 a 159
					+STRZERO((SE2->E2_VALOR)*100,14);//Valor Principal Pos. 160 - 174
					+STRZERO((SE2->E2_MULTA)*100,14);//Valor de multa Pos. 175 - 189
					+STRZERO((SE2->E2_JUROS)*100,14);//Valor de juros Pos. 190 -204
					+GRAVADATA(SE2->E2_VENCREA,.F.,5);//Data de vencimento Pos. 205 - 212 
					+SPACE(18) //Informa?oes complemetares, deve ir em branco Pos.213 230		
	    Case SEA->EA_MODELO = "18" //darf simp
			//cTrb := "11"+;//Identifica??o do tributo Pos. 18 - 19
				cTrb :=	padl(alltrim(SE2->E2_XCODREC),6,"0");// C?digo Receita - Pos. 111 116
					+padl("1",2," ");//codigo pagamento Pos. 117-118				
					+SUBSTR(SM0->M0_CGC,1,14); //identifica??o do contribuite 119-132     
					+"18"; //133 134
					+"00000000000000";
					+"000000";
					+STRZERO((SE2->E2_VALOR)*100,14);//Valor Principal Pos. 165 - 179
					+STRZERO((SE2->E2_MULTA)*100,14);//Valor de multa Pos. 180-194
					+STRZERO((SE2->E2_JUROS)*100,14);//Valor de juros Pos. 195 -209
					+SPACE(21) //Pos. 210 a 230				
		EndCase
	
Return(cTrb)
 