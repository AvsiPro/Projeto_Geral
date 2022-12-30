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
| Processos | REMESSA DE PAGAMENTO AO BANCO SAFRA                              |
+---------- +-------------+-----------------------------------------------------------+
| DATA      | PROGRAMADOR | MOTIVO                                                    |
+-----------+-------------+-----------------------------------------------------------+
|CAMPOS     | SE2->E2_XREFER, SE2->E2_XCODREC, SE2->E2_XPERIOD                         |
+-----------+-------------+-----------------------------------------------------------+


*/
User Function SAFTRIB

	Private cTrb := space(120)

	Do Case
		Case SEA->EA_MODELO ="22"  //GARE ICMS(SP)
			cTrb	:= "J";//98	98
				+SUBSTR(SM0->M0_CGC,1,14);//99	112
				+SUBSTR(IF(EMPTY(SM0->M0_ENDENT), SM0->M0_ENDCOB, SM0->M0_ENDENT),1,40); //113	152	endereço cont
				+SUBSTR(IF(EMPTY(SM0->M0_CIDENT), SM0->M0_CIDCOB, SM0->M0_CIDENT),1,30);//153	182	cidade com
				+IF(EMPTY(SM0->M0_ESTENT), SM0->M0_ESTCOB, SM0->M0_ESTENT);//183	184	estado cont
				+"4665600   ";//185	194	cod nac de arrecadação	CNAE
				+ALLTRIM(SE2->E2_XCODREC);	//195	198	cod receita GARE
				+GRAVADATA(SE2->E2_VENCREA,.F.,8);//199	206	DT VENCIMENTO GARE
				+PADL(ALLTRIM(SM0->M0_INSC),12,"0");//207	218	INSCRIÇÃO ESTADUAL
				+"0140720900116";//219	231	IE DA EMPRESA DIVIDA ATIVA
				+SUBSTR(SE2->E2_XPERAP,3,4)+SUBSTR(SE2->E2_XPERAP,1,2);//232	237	DATA REFERENCIA
				+"0000000000000";//238	250	CODIGO AIIM
				+STRZERO((SE2->E2_VALOR*100),15);//251	265	VALOR GARE CAMPO 9
				+STRZERO((SE2->E2_VALJUR*100),15);//266	280	VALOR MORA GARE CAMPO 10
				+STRZERO(SE2->E2_MULTA*100,15);//281	295	VALOR DAMULTA CAMPO 11
				+"000000000000000";//296	310	VALOR ACRSCIMO CAMPO12
				+"000000000000000";//311	325	VALOR DE HONORÁRIOS CAMPO 13
				+SPACE(30);//326	355	OBSER
				+SPACE(36)//356	391	USO EXC FEBRABAN

		Case SEA->EA_MODELO = "16" //DARF
			cTrb	:= "J";//98	98
				+SUBSTR(SM0->M0_CGC,1,14);//99	112
				+GRAVADATA(SE2->E2_XPERIOD,.F.,8);//113	120	periodo apuração
				+STRZERO(VAL(SE2->E2_XREFER),17);//121	137	numero ref darf
				+ALLTRIM(SE2->E2_XCODREC);	//138	141	codigo rec darf
				+STRZERO((SE2->E2_VALOR+SE2->E2_ACRESC+SE2->E2_JUROS+SE2->E2_MULTA)*100,15); //	142	156	valor principal
				+STRZERO(SE2->E2_MULTA*100,15); //157	171	valor multa
				+STRZERO(SE2->E2_JUROS*100,15);//172	186	valor juros
				+GRAVADATA(SE2->E2_VENCTO,.F.,8);//187	194	data vencimento darf
				+SPACE(100);//195	294	observações
				+SPACE(17);//295	311	safra
				+SPACE(80) // 312 391

		Case SEA->EA_MODELO $ "06|07|08" //TRIBUTO FEDERAL CÓDIGO BARRAS |DARE Tributo Estadual (Tipo de Pagamento 07)|DAM SP Tributo Municipal
			cTrb	:= "D";//98	98
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
				+GRAVADATA(SE2->E2_VENCREA,.F.,8);//147	154	DATA VENCIMENTO
				+SPACE(157);//155	311
				+SPACE(80) // 312 391
	EndCase
Return(cTrb)
