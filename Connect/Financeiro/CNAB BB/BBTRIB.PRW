#include "rwmake.ch"

/*
+-----------+------------+----------------+-------------------+-------+---------------+
| Programa  | SAFTRIB   | Desenvolvedor  | Rodrigo Barreto   | Data  | 21/10/2022    |
+-----------+------------+----------------+-------------------+-------+---------------+
| Descricao | Função criada para o banco safra CNAB 400 DE IMPOSTOS                   |
+-----------+-------------------------------------------------------------------------+
| Retorno   |  cTrb                                                                   |
+-----------+-------------------------------------------------------------------------+
| Modulos   | SIGAFIN                                                                 |
+-----------+-------------------------------------------------------------------------+
| Processos | REMESSA DE PAGAMENTO AO BANCO BRASIL			                          |
+---------- +-------------+-----------------------------------------------------------+
| DATA      | PROGRAMADOR | MOTIVO                                                    |
+-----------+-------------+-----------------------------------------------------------+
|CAMPOS     | SE2->E2_XREFER, SE2->E2_XCODREC, SE2->E2_XPERIOD                         |
+-----------+-------------+-----------------------------------------------------------+


*/
User Function BBTRIB

	Private cTrb 		:= space(120)

	Do Case
		Case SEA->EA_MODELO ="22"  //GARE ICMS(SP)
			cTrb	:=	padl(ALLTRIM(SE2->E2_XCODREC),6,"0");// Código da Receita do Tributo 111 116 6 - Alfa N002
				+"01";// Tipo de Identificação do Contribuinte 117 118 2 - Num N003
				+SUBSTR(SM0->M0_CGC,1,14);// Identificação do Contribuinte 119 132 14 - Num N004
				+ALLTRIM(SEA->EA_MODELO);// Código de Identificação do Tributo 133 134 2 - Alfa N005
				+alltrim(GRAVADATA(SE2->E2_VENCREA,.F.,5));// Data de Vencimento 135 142 8 - Num G044
				+PADL(ALLTRIM(SM0->M0_INSC),12,"0");// Código doMunicípio / Número Declaração 143 154 12 - Num N012
				+"0000000000000";//Etiqueta Dívida Ativa / N. Etiqueta 155 167 13 - Num N013
				+SUBSTR(SE2->E2_XPERAP,1,2)+SUBSTR(SE2->E2_XPERAP,3,4);	//Período de Referência 168 173 6 - Num N006
				+"0000000000000";//Notificação Número da Parcela / Notificação 174 186 13 - Num N014
				+STRZERO((SE2->E2_VALOR*100),15);// Valor da Receita 187 201 13 2 Num G042
				+STRZERO((SE2->E2_VALJUR*100),14);// Valor dos Juros / Encargos 202 215 12 2 Num G047
				+STRZERO(SE2->E2_MULTA*100,14);// Valor da Multa 216 229 12 2 Num G048
				+SPACE(1)//FEBRABAN/CNAB 230 230 1 - Alfa G004

		Case SEA->EA_MODELO = "16" //DARF
			cTrb	:= padl(ALLTRIM(SE2->E2_XCODREC),6,"0");// Código da Receita do Tributo 111 116 6 - Alfa N002
				+"01";// Identificação do Contribuinte 117 118 2 - Num N003
				+SUBSTR(SM0->M0_CGC,1,14); // Identificação do Contribuinte 119 132 14 - Num N004
				+ALLTRIM(SEA->EA_MODELO);//Identificação do Tributo 133 134 2 - Alfa N005
				+ALLTRIM(GRAVADATA(SE2->E2_XPERIOD,.F.,5));//Período de Apuração 135 142 8 - Num N008
				+STRZERO(VAL(SE2->E2_XREFER),17);//Número de Referência 143 159 17 - Num N009
				+STRZERO((SE2->E2_VALOR+SE2->E2_ACRESC+SE2->E2_JUROS+SE2->E2_MULTA)*100,15);//Valor Principal 160 174 13 2 Num G042
				+STRZERO(SE2->E2_MULTA*100,15); //157	171	valor multa//Valor da Multa 175 189 13 2 Num G048
				+STRZERO(SE2->E2_JUROS*100,15);//Valor dos Juros / Encargos 190 204 13 2 Num G047
				+GRAVADATA(SE2->E2_VENCTO,.F.,5);// Data de Vencimento 205 212 8 - Num G044
				+SPACE(18) //FEBRABAN/CNAB 213 230 18 - Alfa G004

			/*
		Case SEA->EA_MODELO $ "06|07|08" //TRIBUTO FEDERAL CÓDIGO BARRAS |DARE Tributo Estadual (Tipo de Pagamento 07)|DAM SP Tributo Municipal

			cTrb	:= "J";//98	98
				+ALLTRIM(SE2->E2_LINDIG);//99	146	COD DE BARRAS48
				+SPACE(165);//147	311	USO EXCLUSIVO BANCO SAFRA
				+SPACE(80) // 312 391

		Case SEA->EA_MODELO = "35" //FGTS
			cTrb	:= "L";//98	98
				+ALLTRIM(SE2->E2_LINDIG);//99	146	COD DE BARRAS48
				+STRZERO(VAL(SE2->E2_XREFER),16);//147	162 IDENTIFICADOR CONT
				+SPACE(165);//147	311	USO EXCLUSIVO BANCO SAFRA
				+SPACE(80) // 312 391

		Case SEA->EA_MODELO = "13" //concessionárias
			cTrb	:= "L";//98	98
				+ALLTRIM(SE2->E2_LINDIG);//99	146	COD DE BARRAS48
				+GRAVADATA(SE2->E2_VENCREA,.F.,5);//147	154	DATA VENCIMENTO
				+SPACE(157);//155	311
			+SPACE(80) // 312 391*/
	EndCase

Return(cTrb)
