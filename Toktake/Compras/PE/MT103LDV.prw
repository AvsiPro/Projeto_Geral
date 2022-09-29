#INCLUDE "RWMAKE.CH"

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    � MT103LDV � Autor � Cadubitski e Wanderley � Data � 14.01.10  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o � Inclui campos no preenchimento de Notas de Retorno           ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe   � Void MATA103(void)                                           ���
���������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                     ���
���������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                       ���
���������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                     ���
���������������������������������������������������������������������������Ĵ��
���              �        �      �                                          ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
User Function MT103LDV()

Local aLinSD2,cAliasLoc

aLinSD2   := aClone(ParamIxb[1])    //&& Linha de Campos a Serem preenchidos
cAliasLoc := ParamIxb[2]            //&& Alias do Arquivo para tratamento da Linha

If cEmpAnt == "01"
	//clocal  := GetMv("MV_XLCDEV")
	clocal    := If(SUBSTR(SF2->F2_XCODPA,1,1) == "R",D2_LOCAL,"D00016")
	dbSelectArea(cAliasLoc)
	
	AAdd( aLinSD2, { "D1_LOCAL", clocal   , Nil } )
	//AAdd( aLinSD2, { "D1_VALVER", (cAliasLoc)->D2_VALVER   , Nil } )
	//AAdd( aLinSD2, { "D1_CONTRAT", (cAliasLoc)->D2_CONTRAT   , Nil } )
EndIf

Return aLinSD2
