#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTTECC06  �Autor  �Jackson E. de Deus  � Data �  01/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Verifica se todos os itens da Os foram atendidos            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTTECC06(cOSField)

Local cQuery := ""
Local nCntTot := 0
Local nCntFim := 0
Local lRet := .F.

If cEmpAnt <> "01"
	Return
EndIf

cQuery := "SELECT * FROM " +RetSqlName("AB7") +" WHERE AB7_FILIAL = '"+xfilial("AB7")+"' AND AB7_NUMOS = '"+cOSField+"' AND D_E_L_E_T_ = '' "

If Select("TRBB7") > 0
	TRBB7->( dbCloseArea() ) 
EndIf                      
                           
TcQuery cQuery New Alias "TRBB7"
                     
dbSelectArea("TRBB7")

While !EOF()
	
	nCntTot++
	
	If AllTrim(TRBB7->AB7_TIPO) $ "4|5"	// atendido/encerrado
		nCntFim++
	EndIf
	 
	dbSkip()
End
                               
dbCloseArea()

If nCntFim == nCntTot
	lRet := .T.
EndIf


Return lRet