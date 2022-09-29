#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TTTMKA19   �Autor  �Jackson E. de Deus � Data �  06/11/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Encontra o RECNO do patrimonio.                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TTTMKA19(cNumChapa)

Local cQuery := ""
Local nRecno := 0

If cEmpAnt <> "01"
	Return(nRecno)
EndIf

cQuery := "SELECT R_E_C_N_O_ SN1REC "
cQuery += "FROM " +RetSqlName("SN1") + " SN1 "
cQuery += "WHERE N1_CHAPA = '"+cNumChapa+"' "
cQuery += "AND D_E_L_E_T_ = '' "

If Select("TRBSN1") > 0
	TRBSN1->(dbCloseArea())
EndIf                     

TcQuery cQuery new alias "TRBSN1"

dbSelectArea("TRBSN1")
If TRBSN1->( !EOF() )
	nRecno := TRBSN1->SN1REC
EndIf
           
TRBSN1->(dbCloseArea())
                                 
Return nRecno