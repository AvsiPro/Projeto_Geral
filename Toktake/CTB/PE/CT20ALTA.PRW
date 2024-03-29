#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CT20ALTA  �Autor  �Jackson E. de Deus  � Data �  14/11/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �O ponto de entrada CT20ALTA � executado antes da rotina de  ���
���          �altera��o do Plano de Contas.                               ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CT20ALTA()

Local cDadosOrig := 'CT1ALT_' +cusername
Local aStruct := {}
Local aArea := GetArea()

/*
//������������������������������������������������������������������������������������������Ŀ
//�O bloco abaixo foi criado para que a cada alteracao, seja gravado log dos campos alterados�
//�O arquivo temporario com os dados atuais � usado posteriormente pelo PE CT20ALTD			 �
//��������������������������������������������������������������������������������������������
*/
If File("\system\" +cDadosOrig +".dbf")
	FErase("\system\" +cDadosOrig +".dbf")
EndIf

aStruct := dbStruct()
MsCreate( cDadosOrig, aStruct, "DBFCDXADS" )
dbUseArea( .T., "DBFCDXADS", cDadosOrig, "TRBC", .F. ,.F. )
dbSelectArea("TRBC")
RecLock("TRBC",.T.)
For nI := 1 To FCount()
	TRBC->&(FieldName(nI)) := CT1->&(FieldName(nI))
Next nI
TRBC->( MsUnLock() )
TRBC->( dbCloseArea() )
                       
RestArea(aArea)

Return