#include "rwmake.ch"

/*
+-----------+------------+----------------+-------------------+-------+---------------+
| Programa  | OCONR001   | Desenvolvedor  | Daiana Andrade    | Data  | 22/03/2011    |
+-----------+------------+----------------+-------------------+-------+---------------+
| Descricao | Função criada para montar Seguimento N - Impostos                       |
+-----------+-------------------------------------------------------------------------+
| Retorno   |  cTpPag para o banco safra                                                                   |
+-----------+-------------------------------------------------------------------------+
| Modulos   | SIGAFIN                                                                 |
+-----------+-------------------------------------------------------------------------+
| Processos | REMESSA DE PAGAMENTO AO BANCO SAFRA                              |
+---------- +-------------+-----------------------------------------------------------+
| DATA      | PROGRAMADOR | MOTIVO                                                    |
+-----------+-------------+-----------------------------------------------------------+
|CAMPOS     |                         |
+-----------+-------------+-----------------------------------------------------------+


*/

User Function TIPOSAF

    Private cTpPag 	:= space(2)

    Do Case
        Case SEA->EA_MODELO ="22"  //GARE ICMS(SP)
            cTpPag := "05"
        Case SEA->EA_MODELO = "16" //DARF
            cTpPag := "02"
        Case SEA->EA_MODELO = "07" //DARE Tributo Estadual (Tipo de Pagamento 07)
            cTpPag := "07"
        Case SEA->EA_MODELO = "06" //TRIBUTO FEDERAL CÓDIGO BARRAS
            cTpPag :=  "06"
        Case SEA->EA_MODELO = "08" //DAM SP Tributo Municipal
            cTpPag := "10"
        Case SEA->EA_MODELO = "35" //FGTS
            cTpPag :=  "08"
        Case SEA->EA_MODELO = "13" //concessionárias
            cTpPag := "99"
    EndCase
Return(cTpPag)
