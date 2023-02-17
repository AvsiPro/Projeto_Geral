#include "rwmake.ch"

/*
+-----------+------------+----------------+-------------------+-------+---------------+
| Programa  | OCONR001   | Desenvolvedor  | Daiana Andrade    | Data  | 22/03/2011    |
+-----------+------------+----------------+-------------------+-------+---------------+
| Descricao | Função criada para montar Seguimento N - Impostos                       |
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
			//+StrZero(ALLTRIM(SM0->M0_CGC),14,"0"); //identificação do contribuite 119-132
			+padl("1",2,"0");
				+SUBSTR(SM0->M0_CGC,1,14);
				+"17"; //133 134
				+StrZero(VAL(SE2->E2_XCOMP),6);//mes ano da competencia Pos. 135 -140
				+STRZERO((SE2->E2_VALOR)*100,14);//Valor Principal Pos. 141 - 155
				+STRZERO((SE2->E2_E_VLENT)*100,14);//valor de outras entidades Pos. 156 - 170
				+STRZERO((SE2->E2_XATUMON)*100,14);//atualização monetária Pos. 171 185
				+SPACE(45) //Informaçoes complemetares, deve ir em branco Pos.186- 23
		Case SEA->EA_MODELO = "16" //DARF NORMAL
			cTrb := padl(alltrim(SE2->E2_XCODREC),6,"0");//codigo pagamento Pos.111 116
				+padl("1",2,"0");//codigo pagamento Pos. 117-118
				+SUBSTR(SM0->M0_CGC,1,14); //identificação do contribuite 119-132
				+ALLTRIM(SEA->EA_MODELO);//Identificação do Tributo 133 134 2 - Alfa N005
				+GRAVADATA(SE2->E2_XDTAPU,.F.,5);//Perído de Apuração Pos. 135 - 142
				+STRZERO(VAL(SE2->E2_XNRREF),17); //- Idenfiticação do FGTS Pos. 143 a 159
				+STRZERO((SE2->E2_VALOR+SE2->E2_ACRESC+SE2->E2_JUROS+SE2->E2_MULTA)*100,15);//Valor Principal 160 174 13 2 Num G042
				+STRZERO(SE2->E2_MULTA*100,15); //157	171	valor multa//Valor da Multa 175 189 13 2 Num G048
				+STRZERO(SE2->E2_JUROS*100,15);//Valor dos Juros / Encargos 190 204 13 2 Num G047
				+GRAVADATA(SE2->E2_VENCTO,.F.,5);// Data de Vencimento 205 212 8 - Num G044
				+SPACE(18) //Informaçoes complemetares, deve ir em branco Pos.213 230
		Case SEA->EA_MODELO = "18" //darf simp
			//cTrb := "11"+;//Identificação do tributo Pos. 18 - 19
			cTrb :=	padl(alltrim(SE2->E2_XCODREC),6,"0");// Código Receita - Pos. 111 116
				+padl("1",2,"0");//codigo pagamento Pos. 117-118
				+SUBSTR(SM0->M0_CGC,1,14); //identificação do contribuite 119-132
				+"18"; //133 134
				+"00000000000000";
				+"000000";
				+STRZERO((SE2->E2_VALOR)*100,14);//Valor Principal Pos. 165 - 179
				+STRZERO((SE2->E2_MULTA)*100,14);//Valor de multa Pos. 180-194
				+STRZERO((SE2->E2_JUROS)*100,14);//Valor de juros Pos. 195 -209
				+SPACE(21) //Pos. 210 a 230
	EndCase

Return(cTrb)
