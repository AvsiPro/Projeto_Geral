#INCLUDE "MATA521.CH"

/*/
���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MenuDef   � Autor � Marco Bianchi         � Data �03/12/2008���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Utilizacao de menu Funcional                               ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Array com opcoes da rotina.                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Parametros do array a Rotina:                               ���
���          �1. Nome a aparecer no cabecalho                             ���
���          �2. Nome da Rotina associada                                 ���
���          �3. Reservado                                                ���
���          �4. Tipo de Transa��o a ser efetuada:                        ���
���          �	  1 - Pesquisa e Posiciona em um Banco de Dados           ���
���          �    2 - Simplesmente Mostra os Campos                       ���
���          �    3 - Inclui registros no Bancos de Dados                 ���
���          �    4 - Altera o registro corrente                          ���
���          �    5 - Remove o registro corrente do Banco de Dados        ���
���          �5. Nivel de acesso                                          ���
���          �6. Habilita Menu Funcional                                  ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function MenuDef()

Local lNFeCancel := SuperGetMV("MV_CANCNFE",.F.,.F.) .OR. SuperGetMV("MV_CANNFSE",.F.,.F.)

PRIVATE aRotina    := { ;
	{ STR0002 ,"PesqBrw"  , 0 , 0,0,.F.},; //"Pesquisa"
	{ STR0004,"Mc090Visua", 0 , 2,0,.F.},; //"Visualizar"
	{ STR0005,"Ma521MarkB", 0 , 5,0,.F.},; //"Excluir" - Marca��o
	{ STR0005,"Ma521Mbrow", 0 , 5,0,.F.}}  //"Excluir" - Sele��o
	
	If lNFeCancel
		AADD(aRotina,{ STR0049,"Ma521Legen"	, 0 , 1,0 ,.F.})		//"Legenda"
		AADD(aRotina,{ STR0050,"Ma521Refre"	, 0 , 1,0 ,.F.})		//"Refresh"
		// Inclui bot�o para consulta do processamento do job;schedulo FATJOBNFE
		AADD(aRotina,{ STR0051,"Ma521Pend"	, 0 , 1,0 ,.F.})		//"Pendencia"
	EndIf

Return(aRotina)

//Dummy Function
Function MT521ADummy()

Return Nil